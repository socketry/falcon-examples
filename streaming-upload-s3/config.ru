require 'protocol/multipart'
require 'json'
require_relative 'multipart_helpers'
require_relative 's3_client'

run do |env|
	request = Rack::Request.new(env)
	
	if request.post?
		begin
			# Get the Content-Type header to extract the boundary
			content_type = env['CONTENT_TYPE']
			boundary = content_type.split('boundary=').last
			
			# Create a multipart parser that will process the input stream
			parser = Protocol::Multipart::Parser.new(env['rack.input'], boundary)
			
			upload_results = []
			
			# Process each part of the multipart form data
			parser.each do |part|
				# Extract metadata from part headers
				metadata = extract_part_metadata(part)
				
				# Skip non-file parts or parts without filenames
				next unless metadata[:filename]
				
				# Generate a unique key for S3
				s3_key = "uploads/#{Time.now.to_i}-#{metadata[:filename]}"
				
				# Initialize multipart upload to S3
				create_response = S3_CLIENT.create_multipart_upload({
					bucket: S3_BUCKET,
					key: s3_key,
					content_type: metadata[:mime_type] || 'application/octet-stream'
				})
				
				upload_id = create_response.upload_id
				part_number = 1
				part_etags = []
				buffer = StringIO.new
				buffer_size = 0
				min_part_size = 5 * 1024 * 1024 # 5MB - S3 minimum part size
				
				# Stream file data in chunks to S3
				part.each do |chunk|
					buffer.write(chunk)
					buffer_size += chunk.bytesize
					
					# When buffer reaches min size, upload as a part
					if buffer_size >= min_part_size
						buffer.rewind
						
						part_response = S3_CLIENT.upload_part({
							bucket: S3_BUCKET,
							key: s3_key,
							upload_id: upload_id,
							part_number: part_number,
							body: buffer.read
						})
						
						part_etags << {
							etag: part_response.etag,
							part_number: part_number
						}
						
						part_number += 1
						buffer = StringIO.new
						buffer_size = 0
					end
				end
				
				# Upload any remaining data in the buffer
				if buffer_size > 0
					buffer.rewind
					
					part_response = S3_CLIENT.upload_part({
						bucket: S3_BUCKET,
						key: s3_key,
						upload_id: upload_id,
						part_number: part_number,
						body: buffer.read
					})
					
					part_etags << {
						etag: part_response.etag,
						part_number: part_number
					}
				end
				
				# Complete the multipart upload
				S3_CLIENT.complete_multipart_upload({
					bucket: S3_BUCKET,
					key: s3_key,
					upload_id: upload_id,
					multipart_upload: {
						parts: part_etags
					}
				})
				
				# Add to results
				upload_results << {
					filename: metadata[:filename],
					s3_key: s3_key,
					size: S3_CLIENT.is_a?(MockS3Client) ? S3_CLIENT.uploads[upload_id][:total_size] : part_etags.sum { |p| p[:size] || 0 }
				}
			end
			
			# Return success response with info about uploaded files
			[200, {'content-type' => 'application/json'}, [JSON.generate(upload_results)]]
			
		rescue => error
			Console.error(self, error)
			
			# Return error response
			[500, {'content-type' => 'text/plain'}, ["Upload failed: #{error.message}"]]
		end
	else
		# For GET requests, serve the upload form
		[200, {'content-type' => 'text/html'}, [File.read('index.html')]]
	end
end
