extends RigidBody2D

var speed : float = 0.0
onready var ray_cast : RayCast2D = $RayCast2D

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	if ray_cast.is_colliding() and linear_velocity.y >= 0:
		sleeping = true
		set_physics_process(false)
		get_parent().launched = false
		get_parent().start()
		print("nnfoi")

func jump():
	linear_velocity.y = -250
	sleeping = false
	set_physics_process(true)
	ray_cast.add_exception(get_parent().platform)