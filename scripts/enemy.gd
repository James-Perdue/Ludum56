extends PathFollow2D
class_name Enemy

@export var speed: float = 100.0
@export var max_health: int = 100
@export var enemy_frames: SpriteFrames
@export var reward = 1
@export var damage := 10
@onready var enemy_sprite : AnimatedSprite2D = $AnimatedSprite2D

signal died

var health: int

func _ready():
    enemy_sprite.sprite_frames = enemy_frames
    health = max_health
    enemy_sprite.play()
    
func _process(_delta: float) -> void:
    progress_ratio = progress_ratio + speed / 10000 
    
    if(progress_ratio > .99):   
        complete_path()

func take_damage(amount: int):
    health -= amount
    if health <= 0:
        died.emit()
        destroy()

func destroy():
    GameManager.updateMoney.emit(reward)
    GameManager.updateKills.emit(1)
    queue_free()

func complete_path():
    GameManager.damagePlayer.emit(damage)
    queue_free()

func set_values(hue: Color, difficulty: float):
    enemy_sprite.modulate = hue
    damage = floor(damage * difficulty)
    health = floor(health * difficulty)
    
