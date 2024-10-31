# Streaming Input

This example shows how to stream CSV records as input.

## Usage

Start the server:

``` bash
$ bundle install
$ bundle exec falcon
```

Then run the client:

``` bash
$ ./client.rb https://localhost:9292
Minimum,Maximum,Average
1,2,3
1.0,3.0,2.0
1,10,100
1.0,100.0,37.0
```

Type some numbers like `1,2,3` and press enter to see the minimum, maximum and average. Press `Ctrl-D` to finish the input.
