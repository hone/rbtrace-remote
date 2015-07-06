require 'socket'

port, options = ARGV

Socket.tcp('localhost', port) do |conn|
  # send command
  conn.puts(options)
  conn.close_write

  # pipe output out
  begin
    while data = conn.readpartial(1024) do
      print data
    end
  rescue EOFError
  end

  conn.close
end
