# frozen_string_literal: true
require "jubilant_computing_machine/listening_socket"
require "jubilant_computing_machine/reverse_string_client"
require "jubilant_computing_machine/wrokers_pool"

module JubilantComputingMachine
  def run
    socket = ListeningSocket.new()
    client = ReverseStringClient.new()
    WrokersPool.new(listening_socket: socket, client: client).tap(&:run).tap(&:wait)
  end

  module_function :run
end
