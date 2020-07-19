# frozen_string_literal: true
require "jubilant_computing_machine/worker"

module JubilantComputingMachine
  class WrokersPool
    attr_reader :listening_socket, :workers_count, :worker_pids, :pipes, :client
    alias_method :socket, :listening_socket

    def initialize(listening_socket:, client:, workers_count: 3)
      @listening_socket = listening_socket
      @client = client
      @workers_count = workers_count

      @worker_pids = []
      @pipes = []
    end

    def run
      set_process_title
      listening_socket.listen
      workers_count.times(&method(:spawn_worker))
    end

    def wait
      puts 'Press Enter'
      gets
      stop_workers
      puts 'Done'
    end

    private

    def set_process_title
      Process.setproctitle("[#{client.class}] master")
    end

    def spawn_worker(number)
      io_read, io_write = IO.pipe
      worker_pids << fork do
        Worker.new(listening_socket: socket, client: client, pipe: io_read, number: number).run
      end
      pipes << io_write
    end

    def stop_workers
      pipes.each { |io| io.print 'stop' }
      Process.waitall
    end
  end
end
