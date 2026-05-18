extends Node2D

var Golds = preload("res://Gold/Gold.tscn")
var goldcount = 0


func _ready():
	spawn_coins(5)


func spawn_coins(amount):
	for i in amount:
		var goldtemp = Golds.instantiate()

		var rand = RandomNumberGenerator.new()
		var randx = rand.randi_range(155, 1550)

		goldtemp.position = Vector2(randx, 525)

		# connect signal when coin is collected
		goldtemp.connect("tree_exited", _on_gold_collected)

		get_node("Node2D").add_child(goldtemp)

		goldcount += 1


func _on_gold_collected():
	goldcount -= 1

	#if goldcount <= 0:
		#spawn_coins(5)
