require "sinatra/base"
require "json"
require "set"

class SSEApp < Sinatra::Base
	set :connections, Set.new
	set :message_id, 0

	get "/" do
		erb :index
	end

	get "/events" do
		content_type "text/event-stream"
		cache_control :no_cache
		
		stream :keep_open do |out|
			queue = Thread::Queue.new
			
			# Add this connection to our set
			if settings.connections.add?(queue)
				out.callback { settings.connections.delete(queue) }
			end

			# Send periodic messages and handle client messages
			begin
				while (message = queue.pop)
					out << "data: #{message}\n\n"
				end
			rescue => error
				puts "Connection error: #{error}"
			end
		end
	end

	post "/broadcast" do
		request.body.rewind
		message_text = request.body.read
		
		# Create message with timestamp
		message = {
			id: settings.message_id += 1,
			text: message_text,
			timestamp: Time.now.strftime("%H:%M:%S")
		}.to_json

		# Broadcast to all connected clients
		settings.connections.each do |queue|
			begin
				queue << message
			rescue => error
				puts "Failed to send to client: #{error}"
			end
		end

		status 200
		"Message broadcasted"
	end
end

run SSEApp