# Streaming Bi-directinoal

This example shows how to use Falcon to create a bi-directional streaming connection between a client and a server, implementing a simple chat server.

## Usage

Start the server:

``` bash
$ bundle install
$ bundle exec falcon
```

Then run the client:

``` bash
$ ./client.rb https://localhost:9292
Hello!
> Hello!
```

Connect several clients to the server to see how the messages are broadcasted to all clients.
