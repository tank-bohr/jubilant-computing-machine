#!/usr/bin/env ruby
require 'socket'
socket = Socket.new(:INET, :STREAM)

sockaddr = Socket.pack_sockaddr_in(2200, '127.0.0.1')
socket.bind(sockaddr)
socket.listen(_backlog = 5)

workers_count = 3
worker_pipes = []
workers_count.times do |number|
  to_read, to_write = IO.pipe
  if fork.nil?
    # it's a child. it's a worker
    $0 = "[RAAS] worker #{number}"
    run = true
    while run do
      ready, _, _ = select([to_read, socket])
      ready.each do |io|
        if io == to_read
          run = false
        elsif io == socket
          begin
            client_socket, client_addrinfo = socket.accept_nonblock
            input = client_socket.gets
            client_socket.puts "#{input.chomp.reverse}"
            client_socket.close
          rescue IO::WaitReadable
            # Skip this work. Another worker took this work
          end
        end
      end
    end
    exit
  else
    # it's a parent. it's a master
    worker_pipes << to_write
  end
end

# Master process context
$0 = "[RAAS] master"

puts 'Press Enter'
read = gets

worker_pipes.each(&:puts)
Process.waitall
puts 'Done'
