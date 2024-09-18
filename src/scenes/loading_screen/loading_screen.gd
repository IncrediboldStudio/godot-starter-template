class_name LoadingScreen
extends CanvasLayer

@warning_ignore("unused_signal")
signal safe_to_load

signal loading_finished

@warning_ignore("unused_signal")
signal update_loading_progress(progress_value: float)

@onready var animation_player: AnimationPlayer = $FadeAnimationPlayer


func _ready() -> void:
  loading_finished.connect(fade_out_loading_screen)


func fade_out_loading_screen() -> void:
  animation_player.play("fade_out")
  await animation_player.animation_finished
  queue_free()
