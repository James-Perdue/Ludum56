extends Node2D

@export var initial_money: int = 10
@export var json_file_path: String = "res://json/level1.json"

var money: int
var waveInfoJSON = JSON.new()
var showPreview = false
var previewSlot = 0
var towers = []

@onready var spawner = $Spawner
@onready var pause_menu = $PauseMenu

func _ready():
    GameManager.current_level = self
    money = initial_money
    waveInfoJSON = load_json("res://json/" + GameManager.level_data + ".json")
    spawner.enemy_waves = parse_wave_json(waveInfoJSON)
    spawner.spawn_next_wave()
    GameManager.updateMoney.connect(update_money)
    AudioManager.play_music("music")
    GameManager.updateHUD.emit("money", money)
    
func load_json(file_path) -> JSON:
    var json_file = FileAccess.open(file_path, FileAccess.READ)
    if json_file:
        var json_text = json_file.get_as_text()
        json_file.close()
        var json = JSON.new()
        var error = json.parse(json_text)
        if error == OK:
            return json
        else:
            print("Error parsing wave info: ", json.get_error_message())
            return null
    else:
        printerr("Wave File does not exist")
        return null


func parse_wave_json(json) -> Array[EnemyWave]:
    var items: Array[EnemyWave] = []
    var data = json.get_data().get("waves")
    if not data is Array:
        printerr("Bad JSON: no array")
        return []
    
    for item_data in data:
        if not item_data is Dictionary:
            printerr("Bad JSON: item is not a dictionary")
            continue
        var item = EnemyWave.new()
        item.enemy_type = item_data.get("enemy_type", "ANT")
        item.total_size = item_data.get("total_size", 0)
        item.group_size = item_data.get("group_size", 1)
        item.initial_delay = item_data.get("initial_delay", 0.0)
        item.delay = item_data.get("delay", 0.0)
        item.hue = Color(item_data.get("hue", "#ffffff"))
        item.difficulty = item_data.get("difficulty", 1)
        items.append(item)
    return items

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("Slot1"):
        previewSlot = 0
        toggle_preview()
    if Input.is_action_just_pressed("Click") and pause_menu.visible == false:
        if showPreview:
            build_tower()
        else:
            toggle_preview()
    #if Input.is_action_just_pressed("Slot2"):
    if(Input.is_action_just_pressed("TogglePreview")):
        for tower in towers:
            tower.toggle_draw()
    if Input.is_action_just_pressed("Pause"):
        pause_menu.toggle_pause()
    if(showPreview):
        queue_redraw()


    
func toggle_preview():
    if(money < GameManager.tower_data[previewSlot].cost):
        return
    showPreview = not showPreview

func _draw() -> void:
    #print(showPreview)
    if(!showPreview):
        return
    #print("preview with radius " + GameManager.tower_data[previewSlot].radius)
    var color = Color("white", .25)
    draw_circle(get_global_mouse_position(), GameManager.tower_data[previewSlot].radius, color)
    
func build_tower():
    if(money < GameManager.tower_data[previewSlot].cost):
        print("Tower not placed due to cost")
        return

    var tower = GameManager.towers[previewSlot].instantiate()
    GameManager.updateMoney.emit(-GameManager.tower_data[previewSlot].cost)

    tower.position = get_global_mouse_position()
    add_child(tower)
    towers.append(tower)
    
    showPreview = false
    queue_redraw()

func update_money(amount : int) -> void:
    money += amount
    GameManager.updateHUD.emit("money", money)
