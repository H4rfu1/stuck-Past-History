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
		c    = 0,
		slot = 1,
		username = 'tamu',
		uid  = '#'+unique(),
		tutorial = true
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
		# id, stageid, name, desc, icon, own, jilid
		[1, '1',   'Candi Brahu', 'Dibangun sekitar abad ke-15 M, Candi ini dibuat oleh Mpu Sendok yang memakai kultur Buddha. Bangunan ini berfungsi sebagai tempat pembakaran jenazah dari raja-raja Majapahit.', 
		'res://assets/img/koleksi/koleksi_candibrahhu.png', 0, 1],
		[2, '2',   'Prasasti Singhasari', 'Prasasti ini ditulis untuk mengenang pembangunan sebuah caitya atau sebuah bangunan/monumen untuk penghormatan para brahmana dan raja Krtanagara yang telah gugur saat terjadinya pemberontakan Jayakatwang di kerajaan Singhasari.', 
		'res://assets/img/koleksi/koleksi_singhasari.png', 0, 1],
		[3, '3',   'Candi Tikus', 'Candi Tikus adalah sebuah peninggalan dari kerajaan yang bercorak hindu yang terletak di Kompleks Trowulan, Kabupaten Mojokerto, Jawa Timur. Nama ‘Tikus’ hanya merupakan sebutan yang digunakan masyarakat setempat. Konon, pada saat ditemukan, tempat Candi tersebut berada merupakan sarang tikus.', 
		'res://assets/img/koleksi/koleksi_canditikus.png', 0, 1],
		[4, '3-1', 'Kitab Sutasoma', 'Kitab Sutasoma ini berisi tentang kisah perjalanan Sutasoma, anak raja yang memilih keluar dari kerajaan untuk belajar menjadi pendeta Buddha. Dalam kitab ini juga, asal dari semboyan Negara Kesatuan Republik Indonesia, yaitu “Bhinneka Tunggal Ika, Tan Hana Dharma Mangrawa”.', 
		'res://assets/img/koleksi/koleksi_sutasoma.png', 0, 1],
		[5, '3-2', 'Kitab Negara Kertagama', 'Kitab Negarakertagama berkisah mengenai sejarah para raja Nusantara, baik raja Singasari maupun raja Majapahit.', 
		'res://assets/img/koleksi/koleksi_negarakertagama.png', 0, 1],
		[6, '4',   'Candi Surawana', 'Candi ini dibangun untuk memuliakan Bhre Wengker. Bhre Wengker adalah seorang raja Kerajaan Wengker yang berada dibawah kekuasaan Majapahit.', 
		'res://assets/img/koleksi/koleksi_candisurawana.png', 0, 1]
	]  setget , get_koleksi

var jilid= [
		# id, name, image
		[1, 'Jilid satu', 'res://'],
		[2, 'Jilid Dua', 'res://']
	 ] setget , get_jilid

var stage = [
		# id, jilid, stageid, name, desc, score, done
		[0, 0, '0-1', 'Panduan Awal', 'Bagai pribahasa tak kenal maka tak sayang, kamu harus tahu bagaimana cara Harul tidak mengusik sejarah.', '0', '-', 'icon' ],
		[0, 0, '0-2', 'Perkakas Masa Depan', 'Tidak ada yang mengira bahwa komunikasi dengan toko masa depan masih terbuka. Apakah alat-alat masa depan dapat membantu?.', '0', '-', 'icon' ],
		[1, 1, '1',   'Candi Brahu', 'Dibangun pada abad ke-15 Masehi, bangunan megah yang dapatditemukan di Mojokerto, Jawa Timur.', '0', '-', 'res://assets/img/koleksi/koleksi_candibrahhu.png'],
		[2, 1, '2',   'Prasasti Singhasari', 'Sebuah prasasti bertarikh tahun 1351 Masehi yang ditulis dengan aksara jawa.', '0', '-', 'res://assets/img/koleksi/koleksi_singhasari.png'],
		[3, 1, '3',   'Candi Tikus', 'Dibangun sekitar abad 13 – 14 Masehi, bangunan unik yang berada di tengah sebuah kolam.', '0', '-', 'res://assets/img/koleksi/koleksi_canditikus.png'],
		[4, 1, '3-1', 'Kitab Sutasoma', 'Karya sastra Empu Tantular selama masa Kerajaan Majapahit.', '0', '-', 'res://assets/img/koleksi/koleksi_sutasoma.png'],
		[5, 1, '3-2', 'Kitab Negarakertagama', 'Karya sastra yang ditulis oleh Empu Prapanca pada tahun 1365 Masehi.', '0', '-', 'res://assets/img/koleksi/koleksi_negarakertagama.png'],
		[6, 1, '4',   'Candi Suwarna', 'Sekitar abad ke-14 Masehi, bangunan yang melambangkan kemuliaan dibangun di Kabupaten Kediri, Jawa Timur.', '0', '-', 'res://assets/img/koleksi/koleksi_candisurawana.png']
	]  setget , get_stage

var item = [
		# id , name, desc, price, image, hide
		[1, 'Ramuan Interatom', 'Saat diminum dapat membuat penggunanya menembus objek diantara partikel.\n Aktif selama 10 detik', 1500, 
		'res://assets/img/item_atomic.png', 0],
		[2, 'Jubah Lenticular', 'Jubah yang mirip jas hujan tetapi dapat membiaskan cahaya sehingga penggunanya tampak tembus pandang.\n Aktif selama 20 detik', 800, 
		'res://assets/img/item_coat.png', 0],
		[3, 'Jam Penghenti Waktu', 'Jangan tanya sekarang pukul berapa, jam ini dapat menghentikan waktu selama 15 detik', 2200, 
		'res://assets/img/item_time.png', 0],
		[4, 'Odheng', 'Aksesoris kepala untuk laki-laki yang sarat akan makna juga sebagai simbolis', 1000, 
		'res://assets/img/material_odheng.png', 1],
		[5, 'Sarong', 'Kain serupa sarung berwarna dan bermotif daerah yang dapat dikenakan sebagai pakaian', 1000, 
		'res://assets/img/material_sarong.png', 1],
		[6, "Pese'an", 'Baju kombinasi hitam sebagai rompi dan baju merah-putih pada bagian dalam', 1000, 
		'res://assets/img/material_pesean.png', 1],
		[7, "Baju Adat Jawa, Pese'an", 'Seperti penduduk lokal? Ya, Baju adat membuat penggunanya membaur dengan masyarakat', 50000, 
		'res://assets/img/item_baju_jawa.png', 0],
		[8, 'Kunci Warp Jilid 2', 'Menuju dimensi baru yang belum dikenali', 0,
		'res://assets/img/material_key2.png', 1]
	]  setget , get_item

var inventory = [
		#itemid, amount
		[0, 0]
	]  setget , get_inventory

var stage_detail = [
		#jilid, stage_id, [spawn_pos], [[green_pos]]
		{
			jilid = 0,
			stage = "0-1",
			player_start = [0,0],
			artefak_pos  = [0,0],
			artefact_player_pos = [], #setpoin
			artefact_tiles = []
		}
	]  setget , get_stage_detail

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
func get_stage_detail():
	return stage_detail

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
