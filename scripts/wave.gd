extends Resource
class_name EnemyWave

@export var enemy_type: String
@export var total_size: int
@export var group_size: int
@export var initial_delay: float
@export var delay: float

func _init(p_enemy_type: String = "", p_total_size: int = 0, p_group_size: int = 1, p_initial_delay: float = 0.0, p_delay: float = 0.0):
    enemy_type = p_enemy_type
    total_size = p_total_size
    group_size = p_group_size
    initial_delay = p_initial_delay
    delay = p_delay
