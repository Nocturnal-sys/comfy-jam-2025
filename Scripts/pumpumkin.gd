extends CharacterBody2D

const TILE : Vector2 = Vector2(16,16)

@onready var pumpi: CharacterBody2D = $"."
@onready var up: RayCast2D = $Up
@onready var down: RayCast2D = $Down
@onready var left: RayCast2D = $Left
@onready var right: RayCast2D = $Right
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed: int

var sprite_tween: Tween
var tween_running: bool = false
var input_buffer: Array[Vector2] = [Vector2.ZERO]
var input_buffer_readout: Vector2


func _ready() -> void:
	animation_player.play("glow")


func _physics_process(_delta: float) -> void:
	if sprite_tween and sprite_tween.is_running():
		tween_running = true
		return
	else:
		tween_running = false
	_handle_movement()
	move_and_slide()
	pass


func _handle_movement() -> void:
	if Input.is_action_pressed("move_up") and not up.is_colliding():
		_move(Vector2(0,-1))
	elif Input.is_action_pressed("move_down") and not down.is_colliding():
		_move(Vector2(0,1))
	elif Input.is_action_pressed("move_left") and not left.is_colliding():
		_move(Vector2(-1,0))
	elif Input.is_action_pressed("move_right") and not right.is_colliding():
		_move(Vector2(1,0))
	
	pass


func _move(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		return
	pumpi.global_position += direction * TILE
	sprite.global_position -= direction * TILE
	
	if sprite_tween:
		sprite_tween.kill()
	sprite_tween = create_tween()
	sprite_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_tween.tween_property(sprite,"global_position", global_position, 1).set_trans(Tween.TRANS_SINE)
	pass
