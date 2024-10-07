extends Control

var inControls = false

func _ready() -> void:
    $VBoxContainer/PlayMargin/PlayButton.connect("pressed", _on_play_pressed)
    $VBoxContainer/ControlMargin/ControlButton.connect("pressed", _on_controls_pressed)
    
func _on_play_pressed():
    print("Play")
    SceneManager.change_scene("LevelSelect")
    
func _on_controls_pressed():
    print("Controls")
        
