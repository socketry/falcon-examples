require 'digest'

run do |env|
	input = env['rack.input']
	
	checksum = Digest::SHA256.new
	
	# Read each chunk at a time, to avoid buffering the entire file in memory:
	input.each do |chunk|
		checksum.update(chunk)
	end
	
	[200, {'content-type' => 'text/csv'}, [checksum.hexdigest]]
end
