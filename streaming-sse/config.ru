def server_sent_events?(env)
	env['HTTP_ACCEPT'].include?('text/event-stream')
end

run do |env|
	if server_sent_events?(env)
		body = proc do |stream|
			while true
				stream << "data: The time is #{Time.now}\n\n"
				sleep 1
			end
		rescue => error
		ensure
			stream.close(error)
		end
		
		[200, {'content-type' => 'text/event-stream'}, body]
	else
		# Else the request is for the index page, return the contents of index.html:
		[200, {'content-type' => 'text/html'}, [File.read('index.html')]]
	end
end
