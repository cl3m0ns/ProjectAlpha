extends "res://Enemies/Enemy.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	idle_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	STATE = NEXT_STATE
	if STATE == states.idle:
		idle_state()
	elif STATE == states.attack:
		attack_state()
	elif STATE == states.hurt:
		hurt_state()
	elif STATE == states.roam:
		roam_state()

func idle_state():
	$AnimationPlayer.play("idle")
	pass

func attack_state():
	pass	

func hurt_state():
	pass

func roam_state():
	pass