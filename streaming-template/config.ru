require 'xrb/template'

TEMPLATE = XRB::Template.load_file("template.xrb")

run do |env|
	scope = {
		count: env['QUERY_STRING'].then do |query_string|
			query_string.empty? ? 99 : Integer(query_string)
		end
	}
	
	[200, {"content-type" => "text/html"}, TEMPLATE.to_proc(scope)]
end
