extends RigidBody2D

@export
var lvl := 0


func _ready() -> void:
	GameManager.register(self)

func spawn() -> void:
	self.rotation = rad_to_deg(randf_range(-75, 75))
	self.freeze = true

func fall() -> void:
	reparent(get_tree().root.get_child(1))
	self.freeze = false

func _process(_delta: float) -> void:
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
