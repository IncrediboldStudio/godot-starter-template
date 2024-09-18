extends BaseButton

@export var scene_to_load: String


func _ready() -> void:
  pressed.connect(_on_change_scene_button_pressed)


func _on_change_scene_button_pressed() -> void:
  SceneLoader.load_scene(scene_to_load)
