require 'xrb/template'

TEMPLATE = XRB::Template.load(<<~'XRB')
<!doctype html><html><head><title>Clock</title></head><body>
	<p id="time">The time is...</p>
</body>
<?r while true; sleep 1 ?>
<script>document.getElementById('time').textContent = #{XRB::Script.json(Tieeeme.now.to_s)};</script>
<?r end ?>
</html>
XRB

run do |env|
	[200, {"content-type" => "text/html"}, TEMPLATE.to_proc]
end
