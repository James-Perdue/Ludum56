extends Node2D

@export var initial_money: int = 10
@export var json_file_path: String = "res://json/level1.json"

var money: int
var waveInfoJSON = JSON.new()
@onready var spawner = $Spawner
var showPreview = false
var previewSlot = 0

func _ready():
    GameManager.current_level = self
    money = initial_money
    waveInfoJSON = load_json(json_file_path)
    spawner.enemy_waves = parse_wave_json(waveInfoJSON)
    spawner.spawn_next_wave()

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
        print(item.total_size)
        items.append(item)
    return items

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("Slot1"):
        previewSlot = 0
        toggle_preview()
    if Input.is_action_just_pressed("Click"):
        if showPreview:
            build_tower()
        else:
            toggle_preview()
    #if Input.is_action_just_pressed("Slot2"):

func toggle_preview():
    if(showPreview):
        pass
        #$Preview.hide()
    else:
        previewSlot = 0
        #$Preview.show()
    showPreview = not showPreview

func build_tower():
    if(money < GameManager.tower_costs[previewSlot]):
        print("Tower not placed due to cost")
        return

    var tower = GameManager.towers[previewSlot].instantiate()
    money -= GameManager.tower_costs[previewSlot]

    tower.position = get_global_mouse_position()
    add_child(tower)

    showPreview = false
