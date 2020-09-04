extends HTTPRequest

export var url = "https://gamedevtapesoft.000webhostapp.com/"
var local      = preload("res://script/plugins/DBlocal.gd").new()
var json_path = "user://json.json"

var server_data
var default_data = {
			username = "Tester",
			password = "",
		}
var data = {}

func _ready():
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

### GENERIC JSON ###
func readJSON(path):
	var data
	var file = File.new()
	var target = local.path4(path)
	if not file.file_exists(target):
		print("OTW buat bos!")
		createJSON(path)
		pass
	
	file.open(target, File.READ)
	data = JSON.parse(file.get_as_text())
	file.close()
	return data.result

func pushJSON(key : Array, value : Array, path):
	var data
	var session = readJSON(path)
	print(session)
	for n in range(len(key)):
		session[key[n]] = value[n]
	saveJSON(session, path)
	return true

func appendJSON(value , path):
	var added = false
	var new_session = []
	var session     = readJSON(path)
	for n in session:
		if value[0] == n[0]:
			n = value
			added = true
		new_session.append(n)
	if(!added):
		new_session.append(value)
	saveJSON(new_session, path)
	return true

func saveJSON(data, path):
	var file = File.new()
	var target = local.path4(path)
	
	file.open(target, File.WRITE)
	file.store_line(JSON.print(data))
	file.close()
	return true

func createJSON(kind)->void:
	var data
	match kind:
		"pemain":
			data = local.get_pemain().duplicate(true)
			saveJSON(local.get_pemain(),"pemain")
		"u_price":
			data = local.get_u_price().duplicate(true)
			saveJSON(local.get_u_price(),"u_price")
		"u_tier":
			data = local.get_u_tier().duplicate(true)
			saveJSON(local.get_u_tier(),"u_tier")
		"setting":
			data = local.get_setting().duplicate(true)
			saveJSON(local.get_setting(),"setting")
		"koleksi":
			data = local.get_koleksi().duplicate(true)
			saveJSON(local.get_koleksi(),"koleksi")
		"jilid":
			data = local.get_jilid().duplicate(true)
			saveJSON(local.get_jilid(),"jilid")
		"stage":
			data = local.get_stage().duplicate(true)
			saveJSON(local.get_stage(),"stage")
		"item":
			data = local.get_item().duplicate(true)
			saveJSON(local.get_item(),"item")
		"inventory":
			data = local.get_inventory().duplicate(true)
			saveJSON(local.get_inventory(),"inventory")
	pass
