extends Node2D


func get_extents() -> Vector2:
	return Vector2(find_child("LeftWall").global_position.x, find_child("RightWall").global_position.x)
