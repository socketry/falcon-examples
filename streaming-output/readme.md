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
$  curl --insecure -N https://localhost:9292
Date,Time
2024-11-11,16:58:13
2024-11-11,16:58:14
2024-11-11,16:58:15
2024-11-11,16:58:16
2024-11-11,16:58:17
^C
```
