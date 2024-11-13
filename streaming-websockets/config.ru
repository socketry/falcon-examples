require "async/websocket/adapters/rack"

run do |env|
	if Async::WebSocket::Adapters::Rack.websocket?(env)
		Async::WebSocket::Adapters::Rack.open(env) do |connection|
			while true
				connection.write("The time is #{Time.now}")
				connection.flush
				sleep 1
			end
		end
	else
		# Else the request is for the index page, return the contents of index.html:
		[200, {'content-type' => 'text/html'}, [File.read('index.html')]]
	end
end
