# frozen_string_literal: true
require 'socket'

module JubilantComputingMachine
  class ListeningSocket
    LOCALHOST = '127.0.0.1'.freeze

    attr_reader :socket, :backlog
    alias_method :fd, :socket

    def initialize(port: 2200, backlog: 3)
      @socket = Socket.new(:INET, :STREAM)
        .tap { |s| s.setsockopt(:SOCKET, :REUSEADDR, true) }
        .tap { |s| s.bind(Socket.pack_sockaddr_in(port, LOCALHOST)) }
      @backlog = backlog
    end

    def listen
      socket.listen(backlog)
    end

    def accept_nonblock
      socket.accept_nonblock
    end
  end
end
