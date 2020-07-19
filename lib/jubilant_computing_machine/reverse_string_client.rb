# frozen_string_literal: true

module JubilantComputingMachine
  class ReverseStringClient
    def process_request(socket:, addrinfo:, worker:)
      input = socket.gets
      socket.puts "#{input.chomp.reverse}"
      socket.close
    end
  end
end
