extends Node
# Godot Script belum mendukung penggunaan overloading

var querry : String

#table
func select(table : String)->String:
	querry = "SELECT * FROM `"+table+"`"
	print(">> Query: "+querry)
	return querry

#table, operator ,attribute, value
func select_where(table : String,attr : String, operator : String, value)->String:
	#querry = "SELECT * FROM `"+str(table)+"`"+" WHERE `"+str(attr)+"` "+str(operator)+" '"+str(value)+"'"
	
	table = "`"+str(table)+"`"
	attr  = "`"+str(attr)+"`"
	#querry = "SELECT * FROM "+table.percent_encode()+" WHERE "+attr.percent_encode()+str(operator)+"'"+str(value)+"'"
	querry = "SELECT * FROM "+table+" WHERE "+attr+str(operator)+"'"+str(value)+"'"
	
	print(">> Query: "+querry)
	return querry

func select_where_join(table : String, ftable, pk, fk, attr : String, value)->String:
	#querry = "SELECT * FROM `"+str(table)+"`"+" WHERE `"+str(attr)+"` "+str(operator)+" '"+str(value)+"'"
	
	table = "`"+str(table)+"`"
	ftable  = "`"+str(ftable)+"`"
	attr  = "`"+str(attr)+"`"
	#querry = "SELECT * FROM "+table.percent_encode()+" WHERE "+attr.percent_encode()+str(operator)+"'"+str(value)+"'"
	querry = "SELECT * FROM "+table+" JOIN "+ftable+" ON "+pk+"="+fk+" WHERE "+attr+"="+"'"+str(value)+"'"
	
	print(">> Query: "+querry)
	return querry

#table, [attribute], [value]
func insert(table : String, attr : Array, value : Array)->String:
	var attrs : String = ""
	var values : String = ""
	for s in attr:
		attrs  += "`"+s+"`,"
	attrs   =  str(attrs).substr(0, len(attrs)-1)
	for s in value:
		values += "'"+str(s)+"',"
	values  =  str(values).substr(0, len(values)-1)
	querry = "INSERT INTO `"+table+"`("+attrs+") VALUES ("+values+")"
	print(">> Query: "+querry)
	return querry

#table, [attribute], [value], id
func update(table : String, attr : Array, value : Array, wattr, wvalue)->String:
	var set : String = ""
	for i in range(len(attr)):
		set += "`"+str(attr[i])+"` = '"+str(value[i])+"',"
	set  =  str(set).substr(0, len(set)-1)
	querry = "UPDATE `"+table+"` SET "+set+" WHERE "+wattr+"="+"'"+str(wvalue)+"'"
	print(">> Query: "+querry)
	return querry

func last(table : String)->String:
	querry = "SELECT id FROM `"+table+"` ORDER BY id DESC LIMIT 1"
	print(">last> Query: "+querry)
	return querry
