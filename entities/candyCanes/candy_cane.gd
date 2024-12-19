extends RigidBody2D

@export
var lvl := 0

var move_allowed := true
var move_limits:Vector2

func set_extents(value: Vector2) -> void:
	move_limits = value

func _ready() -> void:
	GameManager.register(self)

func spawn() -> void:
	self.rotation = rad_to_deg(randf_range(-75, 75))
	self.freeze = true
	move_allowed = true
	self.position = Vector2(clamp(get_global_mouse_position().x, move_limits.x, move_limits.y), 37)

func fall() -> void:
	self.freeze = false
	move_allowed = false

func _physics_process(delta: float) -> void:
	if move_allowed: self.position.x = clamp(get_global_mouse_position().x, move_limits.x, move_limits.y)
	pass

#func merge(partner: Node) -> void:
	##kill partner
	#partner.get_parent().queue_free()
	##instantiate next level
	#var next_cane = next_levels[lvl].instantiate()
	#next_cane.global_position = self.global_position
	#get_tree().root.get_child(0).add_child(next_cane)
	##kill self
	#queue_free()
	#pass


func _on_body_entered(body: Node) -> void:
	if(body is RigidBody2D and body.lvl == lvl):
		GameManager.register_collision(self, body)
