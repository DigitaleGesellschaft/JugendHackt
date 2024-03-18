extends Node3D

#@export var Target: Node3D = null
@export var sensitivity: float = 0.005

var mouse_relative: Vector2 = Vector2(0.0, 0.0)

func _ready():
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event): 
	if event is InputEventMouseMotion:
		mouse_relative = event.relative
		#phi += event.relative.x * self.sensitivity

func _process(delta):
	#rotate_y(-mouse_relative.x * sensitivity)
	mouse_relative = Vector2(0.0, 0.0)
