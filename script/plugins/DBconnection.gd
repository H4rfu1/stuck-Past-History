extends HTTPRequest

export var url = "https://gamedevtapesoft.000webhostapp.com/"
var session_path = "user://session.json"

var server_data
var default_data = {
			username = "Tester",
			password = "",
		}
var data = {}

func _ready():
	readSession()
	pass

func handleRequest(method: String, data : String):
	match method:
		"GET":  
			var site = url+"infish_request_get.php?query="+data
			var headers = ["User-Agent:Firefox/52.0"]
			print(site)
			request(site, headers, false)
		"POST":
			var query = "query="+data
			var site = url+"infish_request_post.php?"
			var headers = ["Content-Type: application/x-www-form-urlencoded", "Content-Length: "+str(query.length())]
			request(site, headers, false, HTTPClient.METHOD_POST, query)

func readSession():
	var data
	var file = File.new()

	if not file.file_exists(session_path):
		print('gaada yg di load bos')
		createSession()

	file.open(session_path, File.READ)
	data = JSON.parse(file.get_as_text())
	file.close()
	return data.result

func pushSession(key : Array, value : Array):
	var data
	var session = readSession()
	for n in range(len(key)):
		session[key[n]] = value[n]
	saveSession(session)
	return true

func saveSession(data):
	var file = File.new()
	
	file.open(session_path, File.WRITE)
	file.store_line(JSON.print(data))
	file.close()
	return true

func createSession():
	data = default_data.duplicate(true)
