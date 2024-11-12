require 'async/redis'

client = Async::Redis::Client.new

run do |env|
	body = proc do |stream|
		subscription_task = Async do
			client.subscribe("chat") do |context|
				context.each do |type, name, message|
					stream.write(message)
				end
			end
		end
		
		stream.each do |message|
			client.publish("chat", message)
		end
	rescue => error
	ensure
		subscription_task&.stop
		stream.close(error)
	end
	
	[200, {'content-type' => 'text/plain'}, body]
end
