require 'csv'

run do |env|
	request = Rack::Request.new(env)
	
	body = proc do |stream|
		csv = CSV.new(stream)
		
		csv << ['Minimum', 'Maximum', 'Average']
		
		csv.each do |row|
			numbers = row.map(&:to_f)
			minimum, maximum = numbers.minmax
			average = numbers.sum / numbers.size
			
			csv << [minimum, maximum, average]
		end
	rescue => error
	ensure
		stream.close(error)
	end
	
	[200, {'content-type' => 'text/csv'}, body]
end
