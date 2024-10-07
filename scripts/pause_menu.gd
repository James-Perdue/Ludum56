extends Control

func _ready() -> void:
    %ResumeButton.connect("pressed", _on_resume_pressed)
    %ResetButton.connect("pressed", _on_reset_pressed)
    %ToBaseButton.connect("pressed", _on_to_base_pressed)
    self.process_mode = Node.PROCESS_MODE_ALWAYS
    GameManager.gameOver.connect(show_final)
    
func _on_resume_pressed():
    print("Resume")
    toggle_pause()

func toggle_pause():
    self.visible = !self.visible
    get_tree().paused = !get_tree().paused
    
func show_final(won: bool):
    self.visible = true
    %ResumeButton.queue_free()
    
    if won:
        $VBoxContainer/MarginContainer/Title.text = "You Won!"
    else:
        $VBoxContainer/MarginContainer/Title.text = "You Lost"

        
func _on_reset_pressed():
    print("Reset")
    GameManager.reset.emit()
    self.visible = false

    
func _on_to_base_pressed():
    SceneManager.change_scene("LevelSelect")
    self.visible = false
    
