extends Node2D

@export var radius: float = 200.0
@export var shoot_interval: float = 0.5
@export var damage: float = 10.0

var target: Node2D = null
var shoot_timer: float = 0.0
var drawRange = true

@onready var detection_area: Area2D = $DetectionArea

func _ready():
    # Set up the detection area
    var circle_shape = CircleShape2D.new()
    circle_shape.radius = radius
    detection_area.get_node("CollisionShape2D").shape = circle_shape
    
    # Connect the area entered and exited signals
    detection_area.connect("area_entered", Callable(self, "_on_area_entered"))
    detection_area.connect("area_exited", Callable(self, "_on_area_exited"))

func _process(delta):
    if target and is_instance_valid(target):
        if not detection_area.overlaps_body(target):
            set_target(null)
        else:
            shoot_timer += delta
            if shoot_timer >= shoot_interval:
                shoot()
                shoot_timer = 0.0
    elif not target:
        get_new_target()
    
func _draw() -> void:
    if(!drawRange):
        return
    var color = Color("white", .25)
    draw_circle(Vector2.ZERO, radius, color)
    
func shoot():
    if target != null and is_instance_valid(target) and target.has_method("take_damage"):
        target.take_damage(damage)
        print("Tower shot at enemy, dealing ", damage, " damage")

func _on_area_entered(area):
    if not target and area.get_parent().is_in_group("enemies"):
        set_target(area.get_parent())

func _on_area_exited(area):
    if area.get_parent() == target:
        set_target(null)
        get_new_target()

func get_new_target():
    if(target != null and is_instance_valid(target)):
        return
    for area in detection_area.get_overlapping_areas():
        var parent = area.get_parent()
        if parent.is_in_group("enemies"):
            set_target(parent)
            break

func set_target(new_target):
    target = new_target
    #print("New target acquired: ", target.name if target else "None")
