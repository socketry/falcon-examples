# Sinatra SSE Pub/Sub Example

A simple pub/sub system using Sinatra and Server-Sent Events (SSE).

## Features

- Real-time message broadcasting using SSE
- Web interface for sending messages
- Automatic heartbeat messages every 5 seconds
- Multiple client support with connection management

## Usage

1. Install dependencies:
   ```
   bundle install
   ```

2. Start the server:
   ```
   falcon serve
   ```

3. Open your browser to `http://localhost:9292`

4. Open multiple browser tabs to see real-time message broadcasting

## How it works

- The `/events` endpoint provides server-sent events
- Clients connect and receive real-time updates
- The `/broadcast` endpoint accepts POST requests to send messages to all connected clients
- A background thread sends periodic heartbeat messages
- Connection management ensures cleanup when clients disconnect

## API Endpoints

- `GET /` - Web interface
- `GET /events` - SSE endpoint for real-time updates
- `POST /broadcast` - Send a message to all connected clients

## Testing with curl

You can also test the broadcast functionality with curl:

```bash
curl -X POST -d "Hello from curl!" http://localhost:9292/broadcast
```
