extends Node2D

@export var enemy_waves: Array[EnemyWave] = [EnemyWave.new("ANT",2,1,.5,.5)]

var initial_delay = 0
var delay = 0
var current_wave = 0
var spawning = false

func _ready():
    await get_tree().create_timer(initial_delay).timeout
    
func spawn_next_wave():
    if current_wave < enemy_waves.size():
        var wave = enemy_waves[current_wave]
        for i in range(wave.total_size):
            if i % wave.group_size == 0:
                await get_tree().create_timer(wave.delay).timeout
            await get_tree().create_timer(.1).timeout
            spawn_enemy(wave.enemy_type)
        current_wave += 1
        await get_tree().create_timer(wave.initial_delay).timeout
        spawn_next_wave()

func spawn_enemy(enemy_type):
    var enemy = Util.get_enemy(Util.EnemyType.get(enemy_type)).instantiate()
    add_child(enemy)
    enemy.position = Vector2(0,0)
