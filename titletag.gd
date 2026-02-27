extends RigidBody2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not self.freeze:
		angular_velocity += -0.2*delta


func _on_character_initialize_dialogue():
	self.freeze = false
	
	await get_tree().create_timer(2.0).timeout
	queue_free()
