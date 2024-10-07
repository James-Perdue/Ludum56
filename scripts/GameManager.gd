extends Node

var current_level = null
var towers : Array[PackedScene] = [Refs.basic_tower]
var tower_data : Array[Dictionary] = []   
var kills := 0
var health := 100
var waves_done = false
var level_data = ""
var game_over = false

signal updateMoney(int)
signal updateKills(int)
signal damagePlayer(int)
signal gameOver(bool)
signal wavesDone
signal reset
signal updateHUD(type: String, value: int)

func _ready() -> void:
    for tower in towers:
        var tempTower = tower.instantiate()
        var tower_entry = {
            cost = tempTower.cost,
            radius = tempTower.radius
        }
        tower_data.append(tower_entry)
        tempTower.queue_free()
    updateKills.connect(_on_update_kills)
    updateMoney.connect(_on_update_money)
    damagePlayer.connect(_on_damage_player)
    gameOver.connect(_on_game_over)
    wavesDone.connect(_on_waves_done)
    reset.connect(_on_reset)
    AudioManager.preload_audio("music", "res://art/music.mp3")
    updateHUD.emit("kills", kills)


func _on_update_kills(amount : int) -> void:
    kills += amount
    updateHUD.emit("kills", kills)
    updateHUD.emit("health", health)

func _on_update_money(_amount : int) -> void:
    pass

func _on_reset():
    kills = 0
    health = 100
    waves_done = false
    game_over = false
    get_tree().paused = false
    get_tree().reload_current_scene()

func _on_damage_player(damage : int):
    print("Player hit for " + str(damage) + ", new Health: " + str(health))
    health -= damage
    if(!game_over):
        updateHUD.emit("health", health)
        if(health <= 0):
            gameOver.emit(false)

func _on_game_over(won : bool):
    game_over = true
    for tower in current_level.towers:
        tower.drawRange = false
        tower.queue_redraw()
    print("You " + "Won!" if won else "Lost :(")

func _on_waves_done():
    waves_done = true

func _process(_delta: float) -> void:
    if(waves_done and !game_over):
        if(get_tree().get_nodes_in_group("enemies").size() <= 0):
            gameOver.emit(true)
