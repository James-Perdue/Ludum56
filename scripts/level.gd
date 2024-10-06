extends Node2D

@export var initial_money: int = 100
var money: int
@export var json_file_path: String = "res://data.json"
var waveInfoJSON = JSON.new()

func _ready():
    money = initial_money
    load_json()

func load_json():
    var json_file = FileAccess.open(json_file_path, FileAccess.READ)
    if json_file:
        var json_text = json_file.get_as_text()
        json_file.close()
        var json = JSON.new()
        var error = json.parse(json_text)
        if error == OK:
            var data = json.get_data()
            return data
        else:
            print("Error parsing wave info: ", json.get_error_message())
            return null