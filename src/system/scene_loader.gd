## Inspired by https://github.com/MASSHUU12/godot-scene-loader/blob/master/addons/scene_loader/autoloads/scene_loader.gd

extends Node

var scenes: Dictionary = {}
var loading_screen: Resource = preload ("res://src/scenes/loading_screen/scn_loading_screen.tscn")

var last_loaded_scene = null

enum ThreadStatus {
    INVALID_RESOURCE = 0, # THREAD_LOAD_INVALID_RESOURCE
    IN_PROGRESS = 1, # THREAD_LOAD_IN_PROGRESS
    FAILED = 2, # THREAD_LOAD_FAILED
    LOADED = 3 # THREAD_LOAD_LOADED
}

## Sets the configuration for the scene loader.
##
## Arguments:
## - config: A dictionary containing the configuration for the scene loader.
##    - scenes: A dictionary containing the scene names and paths.
##    - path_to_progress_bar: The path to the progress bar node in the loading screen.
##
## Returns: None
func set_configuration(config: Dictionary) -> void:
    if config.has("scenes"):
        scenes = config["scenes"]

    if config.has("loading_screen"):
        loading_screen = load(config["loading_screen"])

## Loads a scene asynchronously and replaces the current scene with it.
##
## Arguments:
## - next_scene: The path to the scene to be loaded.
## - current_scene: The current scene to be replaced.
##
## Returns: None
func load_scene(next_scene: String, current_scene: Node = null) -> void:
    var loading_screen_instance: Node = _initialize_loading_screen()
    var path: String = _find_scene_path(next_scene)

    # Start loading scene
    if ResourceLoader.load_threaded_request(path) != OK:
        printerr("Scene %s does not exist." % path)
        return

    # Wait for loading screen to be ready
    await loading_screen_instance.safe_to_load

    # Unload current scene or last loaded scene if not specified
    if current_scene == null:
        current_scene = last_loaded_scene

    if is_instance_valid(current_scene):
        current_scene.queue_free()

    while true:
        var load_progress = []
        var load_status = ResourceLoader.load_threaded_get_status(path, load_progress)

        match load_status:
            ThreadStatus.INVALID_RESOURCE:
                printerr("Can not load the resource.")
                return
            ThreadStatus.IN_PROGRESS:
                loading_screen_instance.update_loading_progress.emit(load_progress[0])
                printerr("Scene loaded at %s%%" % load_progress[0])
            ThreadStatus.FAILED:
                printerr("Loading failed.")
                return
            ThreadStatus.LOADED:
                loading_screen_instance.update_loading_progress.emit(load_progress[0])
                _load_next_scene(path, loading_screen_instance)
                return

## Loads a scene asynchronously and adds it to the current scene.
##
## Returns: Loading screen instance
func _initialize_loading_screen() -> Node:
    var loading_screen_instance: Node = loading_screen.instantiate()
    get_tree().get_root().call_deferred("add_child", loading_screen_instance)

    return loading_screen_instance

## Finds the path to the scene file.
##
## Arguments:
## - next_scene: The path to the scene to be loaded.
##
## Returns: The path to the scene file.
func _find_scene_path(next_scene: String) -> String:
    # Find path to the scene file
    var path: String = scenes[next_scene] if scenes.has(next_scene) else next_scene

    # Validate path
    if not ResourceLoader.exists(path):
        printerr("Scene %s does not exist." % path)
        return ""

    return path
    
## Finds the path to the scene file.
##
## Arguments:
## - next_scene: The path to the scene to be loaded.
##
## Returns: The path to the scene file.
func _get_last_string(last_scene: Node) -> Node:
    # Find path to the scene file
    if last_scene:
        return last_scene
    
    return last_loaded_scene

## Loads the next scene.
##
## Arguments:
## - path: The path to the scene file.
## - loading_screen_instance: The loading screen instance.
##
## Returns: None
func _load_next_scene(path: String, loading_screen_instance: Node) -> void:
    var next_scene_instance = ResourceLoader.load_threaded_get(path).instantiate()
    get_tree().get_root().call_deferred("add_child", next_scene_instance)
    loading_screen_instance.loading_finished.emit()
    last_loaded_scene = next_scene_instance
