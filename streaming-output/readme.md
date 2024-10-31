# Streaming Output

This example shows how to stream CSV records as output.

## Usage

Start the server:

``` bash
$ bundle install
$ bundle exec falcon
```

Then stream the output:

``` bash
$ curl --insecure -N https://localhost:9292
Time,1m Load Average,5m Load Average,15m Load Average
2024-10-16 16:39:07 +1300,1.91,1.39,1.26
2024-10-16 16:39:08 +1300,1.91,1.39,1.26
2024-10-16 16:39:09 +1300,1.91,1.39,1.26
2024-10-16 16:39:10 +1300,1.91,1.39,1.26
2024-10-16 16:39:11 +1300,1.76,1.36,1.25
^C⏎
```
