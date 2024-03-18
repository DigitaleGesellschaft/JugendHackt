extends RigidBody2D

var contact: bool = false
const speed: int = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	var v = self.get_linear_velocity()
	if abs(v.x) > abs(v.y):
		self.set_angular_velocity(v.x / 100)
	else:
		self.set_angular_velocity(v.y / 100)

func _integrate_forces(state):
	var directionForwardBackward = Vector2(0.0, 1.0)
	var directionLeftRight = Vector2(1.0, 0.0)
	
	var force = Vector2()
	if Input.is_action_pressed("Left"):
		force -= directionLeftRight * speed
	if Input.is_action_pressed("Right"):
		force += directionLeftRight * speed
	if Input.is_action_pressed("Forward"):
		force -= directionForwardBackward * speed
	if Input.is_action_pressed("Backward"):
		force += directionForwardBackward * speed	
	
	state.apply_force(force)
