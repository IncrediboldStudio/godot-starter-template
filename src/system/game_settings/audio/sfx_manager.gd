extends Node

enum SfxName {
       EXAMPLE,
}

enum SfxVariation {
       NONE = 0,
       LOW = 1,
       MEDIUM = 3,
       HIGH = 5,
}

var AUDIOFILES = {
       #SfxName.EXAMPLE: preload ("res://src/audio/example.mp3"),
}


const MAX_SFX = 30

var next_player_id = 0
var player_pool = []
var next_player2d_id = 0
var player2d_pool = []

func _ready():
    var player = AudioStreamPlayer.new()
    player.bus = &"Sfx"
    var player2d = AudioStreamPlayer2D.new()
    player2d.bus = &"Sfx"

    for i in MAX_SFX:
        var new_player = player.duplicate()
        player_pool.append(new_player)
        add_child(new_player)
        #new_player.connect("finished", Callable(self,"on_player_finished").bind(new_player))
        var new_player2d = player2d.duplicate()
        player2d_pool.append(new_player2d)
        add_child(new_player2d)
        #new_player2d.connect("finished", Callable(self,"on_player_finished").bind(new_player2d))


# Example of connect call
#new_player.connect("finished", Callable(self,"on_player_finished").bind(new_player))
#func on_player_finished(player):
#    player.stop()


# This class shouldn't be called from outside
func _play(player, sfx_name: SfxName, variation: SfxVariation):
    var stream = AUDIOFILES.get(sfx_name)
    player.set_stream(stream)
    var pitch_range = variation / 100.0
    player.pitch_scale = randf_range(1 - pitch_range, 1 + pitch_range * 2)
    player.play()


func play_sfx(sfx_name: SfxName, variation: SfxVariation = SfxVariation.NONE):
    var player = player_pool[next_player_id]
    player.stop()
    next_player_id += 1
    if next_player_id == MAX_SFX:
        next_player_id = 0
        _play(player, sfx_name, variation)


# Need to add AudioListener2D and call make_current on it to define the point of listening
func play_sfx_at_position(sfx_name: SfxName, position: Vector2, variation: SfxVariation = SfxVariation.NONE):
    var player = player2d_pool[next_player_id]
    player.stop()
    next_player2d_id += 1
    if next_player2d_id == MAX_SFX:
        next_player2d_id = 0
    player.position = position
    _play(player, sfx_name, variation)
