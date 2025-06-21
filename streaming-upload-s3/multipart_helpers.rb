# Helper methods for handling multipart headers
def parse_content_disposition(header_value)
	return {} unless header_value
	
	parts = {}
	
	# Extract the main disposition type
	if header_value =~ /^([^;]+)/
		parts[:type] = $1.strip
	end
	
	# Extract parameters (filename, name, etc.)
	header_value.scan(/;\s*([^=]+)=(?:"([^"]+)"|([^;]+))/) do |name, quoted_value, unquoted_value|
		parts[name.strip.to_sym] = quoted_value || unquoted_value
	end
	
	parts
end

def parse_content_type(header_value)
	return nil unless header_value
	
	# Simple extraction of the MIME type
	if header_value =~ /^([^;]+)/
		$1.strip
	else
		header_value
	end
end

def extract_part_metadata(part)
	metadata = {}
	
	# Get the headers from the part
	headers = part.headers if part.respond_to?(:headers)
	
	if headers
		# Extract Content-Disposition
		if content_disposition = headers['content-disposition']
			disposition = parse_content_disposition(content_disposition)
			metadata[:filename] = disposition[:filename]
			metadata[:name] = disposition[:name]
		end
		
		# Extract Content-Type
		if content_type = headers['content-type']
			metadata[:mime_type] = parse_content_type(content_type)
		end
	end
	
	metadata
end
