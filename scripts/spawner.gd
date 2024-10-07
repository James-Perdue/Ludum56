extends Node2D

@export var enemy_waves: Array[EnemyWave] = [EnemyWave.new("ANT",2,1,.5,.5)]

var initial_delay = 0
var delay = 0
var current_wave = 0
var spawning = false

func _ready():
    pass
    
func spawn_next_wave():
    if current_wave < enemy_waves.size():
        var wave = enemy_waves[current_wave]
        await get_tree().create_timer(wave.initial_delay).timeout
        
        for i in range(wave.total_size):
            if i % wave.group_size == 0:
                await get_tree().create_timer(wave.delay).timeout
            await get_tree().create_timer(.1).timeout
            spawn_enemy(wave)
        current_wave += 1
        spawn_next_wave()
    else:
        GameManager.wavesDone.emit()
        
func spawn_enemy(wave):
    var enemy = Util.get_enemy(Util.EnemyType.get(wave.enemy_type)).instantiate()
    GameManager.current_level.get_node("Path2D").add_child(enemy)
    enemy.position = Vector2(-20,-20)
    enemy.set_values(wave.hue, wave.difficulty)
