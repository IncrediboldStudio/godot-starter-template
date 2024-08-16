extends BaseButton

@export var scene_to_load : String

func _ready():
    pressed.connect(_on_change_scene_button_pressed)

func _on_change_scene_button_pressed():
    SceneLoader.load_scene( scene_to_load )
            
