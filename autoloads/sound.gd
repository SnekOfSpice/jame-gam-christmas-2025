extends Node


func sfx(file_name:String):
	var path := str("res://sounds/sfx/", file_name, ".wav")
	if not FileAccess.file_exists(path):
		push_warning(str(file_name, ".wav doesn't exist"))
	
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = load(path)
	player.play()
	player.pitch_scale = randf_range(0.75, (1.0 / 0.75))
	player.finished.connect(player.queue_free)
