require 'aws-sdk-s3'
require 'console'

# Mock S3 client for development without AWS credentials
class MockS3Client
	attr_reader :uploads
	
	def initialize
		@uploads = {}
		@next_upload_id = 1
		Console.info(self, "Initialized Mock S3 Client - uploads will be logged but not sent to S3")
	end
	
	def create_multipart_upload(params)
		bucket = params[:bucket]
		key = params[:key]
		content_type = params[:content_type]
		
		upload_id = "mock-upload-#{@next_upload_id}"
		@next_upload_id += 1
		
		@uploads[upload_id] = {
			bucket: bucket,
			key: key,
			content_type: content_type,
			parts: [],
			total_size: 0
		}
		
		Console.info(self, "Creating multipart upload: #{bucket}/#{key} (#{content_type}) -> #{upload_id}")
		
		Aws::S3::Types::CreateMultipartUploadOutput.new(
			bucket: bucket,
			key: key,
			upload_id: upload_id
		)
	end
	
	def upload_part(params)
		bucket = params[:bucket]
		key = params[:key]
		upload_id = params[:upload_id]
		part_number = params[:part_number]
		body = params[:body]
		
		# Calculate size and create mock etag
		size = body.bytesize
		etag = "\"mock-etag-#{upload_id}-#{part_number}\""
		
		# Store part info
		@uploads[upload_id][:parts] << {
			part_number: part_number,
			size: size,
			etag: etag
		}
		
		@uploads[upload_id][:total_size] += size
		
		Console.info(self, "Uploading part #{part_number} for #{upload_id}: #{size} bytes")
		
		Aws::S3::Types::UploadPartOutput.new(
			etag: etag
		)
	end
	
	def complete_multipart_upload(params)
		bucket = params[:bucket]
		key = params[:key]
		upload_id = params[:upload_id]
		
		upload = @uploads[upload_id]
		total_parts = upload[:parts].count
		total_size = upload[:total_size]
		Console.info(self, "Completing multipart upload #{upload_id}:")
		Console.info(self, "- Destination: #{bucket}/#{key}")
		Console.info(self, "- Parts: #{total_parts}")
		Console.info(self, "- Total size: #{total_size} bytes (#{(total_size.to_f / 1024 / 1024).round(2)} MB)")
		
		Aws::S3::Types::CompleteMultipartUploadOutput.new(
			bucket: bucket,
			key: key,
			etag: "\"mock-complete-etag-#{upload_id}\""
		)
	end
end

# Use real or mock S3 client based on credential availability
if ENV['AWS_ACCESS_KEY_ID'] && ENV['AWS_SECRET_ACCESS_KEY']
	S3_CLIENT = Aws::S3::Client.new(
		region: ENV.fetch('AWS_REGION', 'us-east-1'),
		access_key_id: ENV['AWS_ACCESS_KEY_ID'],
		secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
	)
	Console.info(self, "Using real AWS S3 client")
else
	S3_CLIENT = MockS3Client.new
	Console.info(self, "Using mock S3 client (AWS credentials not provided)")
end

S3_BUCKET = ENV.fetch('S3_BUCKET', 'example-bucket')
