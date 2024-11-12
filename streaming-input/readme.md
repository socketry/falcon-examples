# Streaming Input

This example shows how to upload a file to compute it's checksum.

## Usage

Start the server:

``` bash
$ bundle install
$ bundle exec falcon
```

Then run the client:

``` bash
$ curl --insecure -X POST --data-binary @config.ru httpss://localhost:9292
f97a5502301d41c3ca77599468e40d186e4d245f83c925e08f731e8276b008a0
```
