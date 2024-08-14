extends Node

enum SfxName {
	EXAMPLE,
}

var AUDIOFILES = {
	#SfxName.EXAMPLE: preload ("res://src/audio/example.mp3"),
}


var reference_player = AudioStreamPlayer.new()

func _ready():
	reference_player.bus = &"Sfx"


func on_player_finished(player):
	remove_child(player)


func play_audio(sfx_name: SfxName):
	var player = reference_player.duplicate()
	var stream = AUDIOFILES.get(sfx_name)
	player.set_stream(stream)
	player.connect("finished", Callable(self,"on_player_finished").bind(player))
	add_child(player)
	player.play()
