extends RigidBody2D

@export
var lvl := 0

var move_allowed := true
var move_limits:Vector2

var fusing := false

func set_extents(value: Vector2) -> void:
	move_limits = value

func _ready() -> void:
	GameManager.register(self)

func spawn() -> void:
	self.rotation = rad_to_deg(randf_range(-75, 75))
	self.freeze = true
	move_allowed = true
	self.position = Vector2(clamp(get_global_mouse_position().x, move_limits.x, move_limits.y), 37)

func despawn() -> void:
	GameManager.active_listeners.erase(self)
	queue_free()

func fall(launch_speed: float) -> void:
	move_allowed = false
	self.freeze = false
	self.apply_impulse(Vector2(0, launch_speed))

func _physics_process(delta: float) -> void:
	if move_allowed: self.position.x = clamp(get_global_mouse_position().x, move_limits.x, move_limits.y)
	pass

func _on_body_entered(body: Node) -> void:
	if(body is RigidBody2D and body.lvl == lvl):
		GameManager.register_collision(self, body)
