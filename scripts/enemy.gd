extends CharacterBody2D
class_name Enemy

@export var speed: float = 100.0
@export var max_health: int = 100
@export var enemy_texture: Texture2D

@onready var enemy_sprite : Sprite2D = $Sprite2D

var health: int

func _ready():
	$Sprite2D.texture = enemy_texture
	health = max_health

func _physics_process(_delta: float) -> void:
	velocity = Vector2.UP * speed
	move_and_slide()

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		destroy()

func destroy():
	queue_free()
