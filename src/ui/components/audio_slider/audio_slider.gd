extends HSlider

@export var bus: StringName = &"Master"

var bus_index: int


func _ready() -> void:
  bus_index = AudioServer.get_bus_index(bus)
  value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))


func _value_changed(new_value: float) -> void:
  AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_value))
