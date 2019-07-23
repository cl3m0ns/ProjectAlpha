extends KinematicBody2D

# Declare member variables here
export (int) var speed = 75

var velocity = Vector2()
var lastVelocity = Vector2(0,0)
var lastAnimation = "Idle"

enum facings { up, down, left, right }
enum states { idle, attack, hurt, roam }

export var idle_time = 1.5
var idle_time_timer = null
var idle_time_over = false

export var wander_time = 0.7
var wander_time_timer = null

var FACING = facings.right
var STATE
var PREV_STATE
var NEXT_STATE = states.idle