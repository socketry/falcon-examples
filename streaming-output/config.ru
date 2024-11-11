require 'csv'

run do |env|
	request = Rack::Request.new(env)
	
	body = proc do |stream|
		csv = CSV.new(stream)
		
		csv << ['Date', 'Time']
		
		while true
			now = Time.now
			csv << [now.strftime('%Y-%m-%d'), now.strftime('%H:%M:%S')]
			sleep(1)
		end
	end
	
	[200, {'content-type' => 'text/csv'}, body]
end
