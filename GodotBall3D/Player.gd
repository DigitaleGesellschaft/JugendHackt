extends RigidBody3D

var contact: bool = false
const speed: int = 20

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(1)

func _integrate_forces(state):
	var directionForwardBackward = Vector3(0.0, 0.0, 1.0)
	var directionLeftRight = Vector3(1.0, 0.0, 0.0)
	
	var force = Vector3()
	if Input.is_action_pressed("Left"):
		force -= directionLeftRight * speed
	if Input.is_action_pressed("Right"):
		force += directionLeftRight * speed
	if Input.is_action_pressed("Forward"):
		force -= directionForwardBackward * speed
	if Input.is_action_pressed("Backward"):
		force += directionForwardBackward * speed
		
	if self.contact:
		state.apply_force(force)

func _on_body_entered(body):
	self.contact = true
	if body is Chi:
		body.queue_free()

func _on_body_exited(body):
	self.contact = false
