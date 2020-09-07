extends Node

func _ready():
	pass

func unique():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return str(rng.randi_range(1001, 9999))

#################
# DB Initiation #
#################

var default_pemain = {
		v    = '0-beta1',#versi database
		c    = 5000,
		slot = 1,
		username = 'tamu',
		uid  = '#'+unique()
	} setget , get_pemain

var upgrade_price = {
		radar = [[3000,6300,9600], ["Memberi petunjuk arah artefak dalam 3 detik dengan batas 3 kali penggunaan", "Memberi petunjuk arah artefak dalam 3 detik dengan batas 5 kali penggunaan", "Memberi petunjuk arah artefak dalam 3 detik dengan batas 7 kali penggunaan"]],
		timecontrol = [[3000,4800, 6900, 9300], ["Menambah durasi penjelajahan waktu sebanyak +20 detik", "Menambah durasi penjelajahan waktu sebanyak +40 detik", "Menambah durasi penjelajahan waktu sebanyak +1 menit", "Menambah durasi penjelajahan waktu sebanyak +1 menit 20 detik"]],
		foglamp = [[3000, 6300, 9600], ["Memperluas jangkauan membuka kabut dalam jarak sempit", "Memperluas jangkauan membuka kabut dalam jarak sedang", "Memperluas jangkauan membuka kabut dalam jarak luas", "Menghilangkan kabut penghalang pandangan"]]
	} setget , get_u_price

var upgrade_tier = {
		radar = 0,
		timecontrol = 0,
		foglamp = 0
	} setget , get_u_tier

var setting = {
		control = true,
		sound = true,
	}  setget , get_setting

var koleksi = [
		# id, stageid, name, desc, icon,own, jilid
		[1, '1',   'Koleksi 1', 'Deskripsi koleksi', 'res://assets/img/koleksi/koleksi_singhasari.png', 0, 1],
		[2, '2',   'Koleksi 2', 'Deskripsi koleksi', 'res://assets/skeleton.png', 0, 1],
		[3, '3',   'Koleksi 3', 'Deskripsi koleksi', 'res://assets/skeleton.png', 0, 1],
		[4, '3-1', 'Koleksi 4', 'Deskripsi koleksi', 'res://assets/skeleton.png', 0, 1],
		[5, '3-2', 'Koleksi 5', 'Deskripsi koleksi', 'res://assets/skeleton.png', 0, 1],
		[6, '4',   'Koleksi 6', 'Deskripsi koleksi', 'res://assets/skeleton.png', 0, 1]
	]  setget , get_koleksi

var jilid= [
		# id, name, image
		[1, 'Jilid satu', 'res://'],
		[2, 'Jilid Dua', 'res://']
	 ] setget , get_jilid

var stage = [
		# id, jilid, stageid, name, desc, score, done
		[1, 1, '1',   'StageName 1', 'desc', '0', '-'],
		[2, 1, '2',   'StageName 2', 'desc', '0', '-'],
		[3, 1, '3',   'StageName 3', 'desc', '0', '-'],
		[4, 1, '3-1', 'StageName 31', 'desc', '0', '-'],
		[5, 1, '3-2', 'StageName 32', 'desc', '0', '-'],
		[6, 1, '4',   'StageName 4', 'desc', '0', '-']
	]  setget , get_stage

var item = [
		# id , name, desc, price, image
		[1, 'Ramuan Interatom', 'Saat diminum dapat membuat penggunanya menembus objek diantara partikel.\n Aktif selama 10 detik', 1500, 'res://assets/img/item_atomic.png'],
		[2, 'Jubah Lenticular', 'Jubah yang mirip jas hujan tetapi dapat membiaskan cahaya sehingga penggunanya tampak tembus pandang.\n Aktif selama 20 detik', 800, 'res://assets/img/item_coat.png'],
		[3, 'Jam Penghenti Waktu', 'Jangan tanya sekarang pukul berapa, jam ini dapat menghentikan waktu selama 15 detik', 2200, 'res://assets/img/item_time.png'],
		[4, 'Baju Adat A', 'Seperti penduduk lokal? Ya, Baju adat membuat penggunanya membaur dengan masyarakat', 1000, 'res://assets/skeleton.png'],
		[5, 'Baju Adat B', 'Seperti penduduk lokal? Ya, Baju adat membuat penggunanya membaur dengan masyarakat', 1000, 'res://assets/skeleton.png'],
		[6, 'Baju Adat C', 'Seperti penduduk lokal? Ya, Baju adat membuat penggunanya membaur dengan masyarakat', 1000, 'res://assets/skeleton.png']
	]  setget , get_item

var inventory = [
		#itemid, amount
		[0, 0]
	]  setget , get_inventory

#var stage_detail = [
#		#jilid, stage_id, [spawn_pos], [[green_pos]]
#		[0, 0]
#	]  setget , get_stage_detail

func get_pemain():
	return default_pemain
func get_u_price():
	return upgrade_price
func get_u_tier():
	return upgrade_tier
func get_setting():
	return setting
func get_koleksi():
	return koleksi
func get_jilid():
	return jilid
func get_stage():
	return stage
func get_item():
	return item
func get_inventory():
	return inventory


func path4(target: String)->String:
	match target:
		"pemain":
			return "user://userdata.json"
		"u_price":
			return "user://upgrade_price.json"
		"u_tier":
			return "user://upgrade_tier.json"
		"setting":
			return "user://setting.json"
		"koleksi":
			return "user://koleksi.json"
		"jilid":
			return "user://jilid.json"
		"stage":
			return "user://stage.json"
		"item":
			return "user://item.json"
		"inventory":
			return "user://inventory.json"
	return "null :("
