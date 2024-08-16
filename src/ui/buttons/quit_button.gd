extends BaseButton

func _ready():
    pressed.connect(_on_quit_button_pressed)

func _on_quit_button_pressed():
    get_tree().quit()