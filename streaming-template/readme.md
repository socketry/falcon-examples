# Streaming Template

This example shows how to stream real time HTML (or anything really) templates.

## Usage

Start the server:

``` bash
$ bundle exec falcon
```

Check the streaming output:

``` bash
$ curl --insecure -N https://localhost:9292
<!doctype html><html><head><title>Green Bottles Song</title></head><body>
	<p>10 green bottles hanging on the wall,</br>
		10 green bottles hanging on the wall,</br>
		and if one green bottle should accidentally fall,</br>
		there'll be 9 green bottles hanging on the wall.</br>
	</p>
	<p>9 green bottles hanging on the wall,</br>
		9 green bottles hanging on the wall,</br>
		and if one green bottle should accidentally fall,</br>
		there'll be 8 green bottles hanging on the wall.</br>
	</p>
...
```
