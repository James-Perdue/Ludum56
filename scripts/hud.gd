extends Control

@onready var money_label = $Money/MoneyLabel
@onready var health_label = $Health/HealthLabel
@onready var kills_label = $TextureRect2/KillsLabel

func _ready():
    GameManager.updateHUD.connect(_on_hud_update)

func _on_hud_update(type: String, value: int):
    match type:
        "money":
            money_label.text = str(value)
        "health":
            health_label.text = str(value)
        "kills":
            kills_label.text = str(value)
