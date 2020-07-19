# frozen_string_literal: true

module JubilantComputingMachine
  class ReverseStringClient
    def process_request(socket:, addrinfo:, worker:) # rubocop:disable Lint/UnusedMethodArgument
      input = socket.gets
      socket.puts input.chomp.reverse.to_s
      socket.close
    end
  end
end
