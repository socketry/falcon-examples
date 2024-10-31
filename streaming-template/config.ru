require 'xrb/template'

TEMPLATE = XRB::Template.load(<<~'XRB')
<!doctype html><html><head><title>Beer Song</title></head><body>
	<?r self[:count].downto(1) do |i| ?>
	<p>#{i} bottles of beer on the wall</br>
		<?r sleep 1 ?>#{i} bottles of beer</br>
		<?r sleep 1 ?>take one down, and pass it around</br>
		<?r sleep 1 ?>#{(i-1)} bottles of beer on the wall</br></p>
	<?r end ?>
</body></html>
XRB

run do |env|
	scope = {
		count: env['QUERY_STRING'].then do |query_string|
			query_string.empty? ? 99 : Integer(query_string)
		end
	}
	
	[200, {"content-type" => "text/html"}, TEMPLATE.to_proc(scope)]
end
