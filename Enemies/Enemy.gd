extends KinematicBody2D

# Declare member variables here
export (int) var speed = 75

var velocity = Vector2()
var lastVelocity = Vector2(0,0)
var lastAnimation = "Idle"

enum facings { up, down, left, right }
enum states { idle, attack, hurt, roam }


var FACING = facings.right
var STATE
var PREV_STATE
var NEXT_STATE = states.idle

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
	pass

func attack_state():
	pass	

func hurt_state():
	pass

func roam_state():
	pass