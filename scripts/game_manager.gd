extends Node

var score := 0
var total_coins := 0

@onready var score_label: Label = $ScoreLabel
@onready var coins := %Coins


func _ready() -> void:
	total_coins = coins.get_child_count()


func add_point() -> void:
	score += 1
	score_label.text = "Collected\n" + str(score) + "/" + str(total_coins) + " souls"
	print(score, "/", total_coins)
