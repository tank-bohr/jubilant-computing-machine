# frozen_string_literal: true

module JubilantComputingMachine
  class Worker
    attr_reader :listening_socket, :pipe, :number, :client

    def initialize(listening_socket:, pipe:, number:, client:)
      @listening_socket = listening_socket
      @pipe = pipe
      @number = number
      @client = client
      @run = true
    end

    def run
      set_process_title
      while run?
        run_select
      end
    end

    def stop!
      @run = false
    end

    private

    def set_process_title
      Process.setproctitle("[#{client.class}] worker #{number}")
    end

    def run_select
      ready, _, _ = select([listening_socket.fd, pipe])
      ready.each(&method(:process_fd))
    end

    def process_fd(fd)
      if fd == listening_socket.fd
        process_request
      elsif fd == pipe
        process_cmd
      end
    end

    def process_request
      socket, addrinfo = listening_socket.accept_nonblock
      client.process_request(socket: socket, addrinfo: addrinfo, worker: self)
    rescue IO::WaitReadable
      # Skip this work. Another worker took this work
    end

    def process_cmd
      cmd = pipe.read_nonblock(8)
      stop! if cmd == 'stop'
    end

    def run?
      @run
    end
  end
end
