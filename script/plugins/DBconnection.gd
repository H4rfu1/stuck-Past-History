extends HTTPRequest

export var url = "https://gamedevtapesoft.000webhostapp.com/"
var json_path = "user://json.json"

var server_data
var default_data = {
			username = "Tester",
			password = "",
		}
var data = {}

func _ready():
	readJson()
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

func readJson():
	var data
	var file = File.new()

	if not file.file_exists(json_path):
		print('gaada yg di load bos')
		createJson()

	file.open(json_path, File.READ)
	data = JSON.parse(file.get_as_text())
	file.close()
	return data.result

func pushJson(key : Array, value : Array):
	var data
	var json = readJson()
	for n in range(len(key)):
		json[key[n]] = value[n]
	saveJson(json)
	return true

func saveJson(data):
	var file = File.new()
	
	file.open(json_path, File.WRITE)
	file.store_line(JSON.print(data))
	file.close()
	return true

func createJson():
	data = default_data.duplicate(true)
