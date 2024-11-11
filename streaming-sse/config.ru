run do |env|
	request = Rack::Request.new(env)
	
	# If the request is for the index page, return the contents of index.html
	if request.path_info == "/"
		[200, {'content-type' => 'text/html'}, [File.read('index.html')]]
	else
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
	end
end
