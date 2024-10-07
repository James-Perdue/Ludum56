extends Control

var inControls = false
var levels = [{name = "Level 1", file = "level1"},{name = "Level 2", file = "level2"}]
func _ready() -> void:
    for level in levels:
        var level_button = Button.new()
        level_button.text = level.name
        level_button.pressed.connect(func(): 
            GameManager.level_data = level.file
            SceneManager.change_scene("root_level")
        )
        $VBoxContainer.add_child(level_button)
        
