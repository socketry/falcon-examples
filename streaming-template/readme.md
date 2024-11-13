# Streaming Template

This example shows how to stream real time HTML (or anything really) templates.

## Usage

Start the server:

``` bash
$ bundle exec falcon
```

Check the streaming output:

``` bash
$ curl --insecure https://localhost:9292
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

## ERB Templates

You can modify this example to use streaming ERB templates:

``` ruby
require "erb"

class StreamingERB
	COMPILER = ERB::Compiler.new('<>').tap do |compiler|
		compiler.pre_cmd << "proc{|_erbout|"
		compiler.put_cmd = "_erbout<<"
		compiler.insert_cmd = "_erbout<<"
		compiler.post_cmd << "}"
	end
	
	def initialize(path)
		@path = path
		@code = nil
		@compiled = nil
	end
	
	def code
		@code ||= COMPILER.compile(File.read(@path)).first
	end
	
	def compiled(binding = self.binding)
		@compiled ||= eval(self.code, binding, @path, 0)
	end
	
	def to_proc(scope)
		proc do |stream|
			scope.instance_exec(stream, &compiled)
		rescue => error
		ensure
			stream.close(error)
		end
	end
end

TEMPLATE = StreamingERB.new("template.erb")
```
