extends Node

enum MusicName {
  EXAMPLE,
}

var music_files: Dictionary = {
#MusicName.EXAMPLE: preload ("res://src/audio/example.mp3"),
}

var start_music: MusicName = MusicName.EXAMPLE
var music_player: AudioStreamPlayer


func _ready() -> void:
  music_player = AudioStreamPlayer.new()
  var stream: AudioStream = music_files.get(start_music)
  music_player.set_stream(stream)
  music_player.bus = &"Music"
  music_player.connect("finished", Callable(self, "on_music_finished"))
  add_child(music_player)
  music_player.play()


func on_music_finished() -> void:
  music_player.play()


func crossfade(music_name: MusicName) -> void:
  var new_player: AudioStreamPlayer = AudioStreamPlayer.new()
  var stream: AudioStream = music_files.get(music_name)
  new_player.set_stream(stream)
  new_player.volume_db = -80
  new_player.connect("finished", Callable(self, "on_music_finished"))
  add_child(new_player)

  var fade_out: Tween = create_tween()
  fade_out.tween_property(music_player, "volume_db", -80, 2).set_trans(Tween.TRANS_SINE)
  fade_out.tween_callback(on_fade_out_tween_completed.bind(music_player))
  fade_out.play()

  var fade_in: Tween = create_tween()
  fade_in.tween_property(new_player, "volume_db", 0, 2).set_trans(Tween.TRANS_SINE)
  fade_in.tween_callback(on_fade_in_tween_completed.bind(new_player))
  fade_in.play()

  new_player.play()


func on_fade_out_tween_completed(player: AudioStreamPlayer) -> void:
  player.stop()
  player.queue_free()


func on_fade_in_tween_completed(player: AudioStreamPlayer) -> void:
  remove_child(music_player)
  music_player = player.duplicate()
