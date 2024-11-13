require 'async/redis'

client = Async::Redis::Client.new

run do |env|
	body = proc do |stream|
		subscription_task = Async do
			# Subscribe to the redis channel and forward messages to the client:
			client.subscribe("chat") do |context|
				context.each do |type, name, message|
					stream.write(message)
				end
			end
		end
		
		stream.each do |message|
			# Read messages from the client and publish them to the redis channel:
			client.publish("chat", message)
		end
	rescue => error
	ensure
		subscription_task&.stop
		stream.close(error)
	end
	
	[200, {'content-type' => 'text/plain'}, body]
end
