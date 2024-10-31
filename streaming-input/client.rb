#!/usr/bin/env ruby

require 'async/http'

url = ARGV.pop || "https://localhost:9292"
endpoint = Async::HTTP::Endpoint.parse(url)

Async do
	client = Async::HTTP::Client.new(endpoint)
	
	body = Protocol::HTTP::Body::Writable.new
	
	Async do
		while line = $stdin.gets
			body.write(line)
		end
	ensure
		body.close_write
	end
	
	response = client.post("/", body: body)
	
	response.each do |chunk|
		$stdout.write(chunk)
	end
ensure
	response&.close
end
