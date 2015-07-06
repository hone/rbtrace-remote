require 'socket'

port, pid = ARGV

puts "Starting daemon on #{port} attach rbtrace to pid #{pid}"

Socket.tcp_server_loop(port) do |conn|
  options = conn.read
  cmd = "bundle exec rbtrace -p #{pid} #{options}"
  IO.popen(cmd) do |rbtrace_io|
    begin
      while data = rbtrace_io.readpartial(1024) do
        conn.print(data)
      end
    rescue EOFError
    end
  end
  conn.close
end
