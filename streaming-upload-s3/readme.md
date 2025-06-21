# Streaming Upload to S3

This example demonstrates how to stream file uploads directly to Amazon S3 using the `protocol-multipart` gem, without loading the entire file into memory.

## Project Structure

- `config.ru` - Main application entry point
- `s3_client.rb` - S3 client implementation with mock capability
- `multipart_helpers.rb` - Helper functions for processing multipart data
- `index.html` - User interface for file uploads

## How It Works

1. The server receives a multipart form upload from a client
2. Using `Protocol::Multipart::Parser`, it processes the incoming stream in chunks
3. As chunks are received, they are buffered until reaching the minimum S3 part size (5MB)
4. Each buffer is uploaded as an S3 multipart upload part
5. When all chunks are processed, the multipart upload is completed

This approach allows handling large file uploads efficiently, as only small portions of the file are in memory at any given time.

## Configuration

Set the following environment variables:

```bash
export AWS_REGION=your-region
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
export S3_BUCKET=your-bucket-name
```

If `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are not provided, the application will use a mock S3 client that logs operations without actually uploading to S3, which is useful for development and testing.

## Usage

Start the server:

```bash
$ bundle install
$ bundle exec falcon
```

Then open your browser at https://localhost:9292 and use the upload form.

## Testing with curl

You can also test the upload with curl:

```bash
$ curl -X POST --insecure \
  -F "file=@/path/to/your/file.jpg" \
  https://localhost:9292/
```

## Notes

- In a production environment, you should implement proper authentication and authorization
- Consider adding progress reporting, checksum verification, and retry logic for improved reliability
- The example uses environment variables for AWS credentials, but in production you should use IAM roles or other secure credential management
