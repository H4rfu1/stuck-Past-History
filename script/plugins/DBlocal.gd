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
		c    = 3500,
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
		control = false,
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
			type = 'jawa',
			player_start = [0,0],
			artefak_pos  = [0,0],
			artefact_player_pos = [2,3], #setpoin
			artefact_tiles = [
							[1,0], [2,0], [3,0],
							[1,1], [3,1],[2,3], [2,2],
							[1,2], [3,2] ]
		},
		{
			jilid = 0,
			stage = "0-2",
			type = 'jawa',
			player_start = [0,0],
			artefak_pos  = [0,0],
			artefact_player_pos = [2,3], #setpoin
			artefact_tiles = [
							[1,0], [2,0], [3,0],
							[1,1], [3,1], [2,3], [2,2],
							[1,2], [3,2] ]
		},
		{
			jilid = 1,
			stage = "1",
			type = 'jawa',
			player_start = [0,0],
			artefak_pos  = [0,0],
			artefact_player_pos = [17,4], #setpoin
			artefact_tiles = [
							[14,1], [15,1], [16,1], [17,1],
							[14,2], [17,2],
							[14,3], [17,3],
							[14,4], [15,4],[16,4]
							 ]
		},
		{
			jilid = 1,
			stage = "2",
			type = 'jawa',
			player_start = [0,0],
			artefak_pos  = [0,0],
			artefact_player_pos = [35,56], #setpoin
			artefact_tiles = [
							[33,57],[34,57],[35,57],[36,57],[37,57],[38,57],
							[33,58],[34,58],[35,58],[36,58],[37,58],[38,58],
							[33,59],[34,59], [37,59],[38,59],
							[33,60],[34,60], [37,60],[38,60],
							[33,61],[34,61],[35,61],[36,61],[37,61],[38,61],
							 [34,62],[35,62],[36,62],[37,62]
							 ]
		},
		{
			jilid = 1,
			stage = "3",
			type = 'jawa',
			player_start = [0,0],
			artefak_pos  = [0,0],
			artefact_player_pos = [21,25], #setpoin
			artefact_tiles = [
							[21,22], [22,22], [23,22], [24,22], [25,22], [26,22], [27,22], [28,22],
							[21,23], [28,23],
							[21,24], [28,24],
							[21,25], [28,25],
							[21,26], [28,26],
							[21,27], [28,27],
							[21,28], [22,28], [23,28], [24,28], [25,28], [26,28], [27,28], [28,28]
							 ]
		},
		{
			jilid = 1,
			stage = "3-1",
			type = 'jawa',
			player_start = [0,0],
			artefak_pos  = [0,0],
			artefact_player_pos = [50,42], #setpoin
			artefact_tiles = [
							[46,42], [47,42], [48,42], [49,42], [50,42], [51,42], [52,42],
							[46,43], [47,43],   [50,43], [51,43], [52,43],
							[46,44], [47,44],   [50,44], [51,44], [52,44],
							[46,45], [47,45], [48,45], [49,45], [50,45], [51,45]
							 ]
		},
		{
			jilid = 1,
			stage = "3-2",
			type = 'jawa',
			player_start = [0,0],
			artefak_pos  = [0,0],
			artefact_player_pos = [61,24], #setpoin
			artefact_tiles = [
							[61,21], [62,21], [63,21], [64,21], [65,21],
							[61,22], [62,22],   [64,22], [65,22],
							[61,23], [62,23], [63,23], [64,23], [65,23],
							  [62,24], [63,24], [64,24], [65,24],
							[61,25], [62,25],    [65,25],
							[61,26], [62,26],    [65,26],
							  [62,27], [63,27], [64,27] 
							 ]
		},
		{
			jilid = 1,
			stage = "4",
			type = 'jawa',
			player_start = [0,0],
			artefak_pos  = [0,0],
			artefact_player_pos = [62,16], #setpoin
			artefact_tiles = [
							 [64,12],[65,12],[66,12],[67,12],[68,12],[69,12],[70,12] ,
							[63,13],[64,13],[65,13],[66,13],[67,13],[68,13],[69,13],[70,13],[71,13],
							[63,14],[64,14], [66,14],[67,14],[68,14], [70,14],[71,14],
							[63,15],[64,15],[65,15],[66,15],[67,15],[68,15],[69,15],[70,15],[71,15],
							[63,16],[64,16],[65,16],[66,16],[67,16],[68,16],[69,16],[70,16],[71,16],
							[63,17],[64,17],[65,17],[66,17],[67,17],[68,17],[69,17],[70,17],[71,17],
							[63,18],[64,18],[65,18],[66,18],[67,18],[68,18],[69,18],[70,18],[71,18],
							[63,19],[64,19],[66,19],[67,19],[68,19],[70,19],[71,19],
							[63,20],[64,20],[65,20],[66,20],[67,20],[68,20],[69,20],[70,20],[71,20],
							 [64,21],[65,21],[66,21],[67,21],[68,21],[69,21],[70,21] 
							 ]
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
		"stage_detail":
			return "user://stage_detail.json"
	return "null :("
