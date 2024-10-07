extends Node

var scenes = {
    "MainMenu": null,
    "LevelSelect": null,
    "root_level": null
}

func _ready():
    preload_scenes()

func preload_scenes():
    for scene_name in scenes.keys():
        var path = "res://scenes/" + scene_name + ".tscn"
        scenes[scene_name] = load(path)
        if scenes[scene_name] == null:
            printerr("Failed to load scene: " + path)

func get_scene(scene_name: String) -> PackedScene:
    if scenes.has(scene_name):
        return scenes[scene_name]
    else:
        printerr("Scene not found: " + scene_name)
        return null

func change_scene(scene_name: String):
    var scene = get_scene(scene_name)
    if scene != null:
        get_tree().change_scene_to_packed(scene)
    else:
        printerr("Failed to change to scene: " + scene_name)
