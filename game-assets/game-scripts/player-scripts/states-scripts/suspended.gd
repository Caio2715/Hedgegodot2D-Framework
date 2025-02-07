extends State

var target_pos = null
var side = 0
var main_anim_name = 'Suspended'

func state_enter(host: PlayerPhysics, prev_state:String):
	host.speed = Vector2.ZERO
	host.audio_player.play('grab')
	host.rotation = 0
	host.character.rotation = 0
	host.snap_margin = 0

func state_physics_process(host: PlayerPhysics, delta: float):
	#print(target_pos)
	if host.direction.x != 0:
		var left = host.direction.x < 0 && host.suspended_can_left
		var right = host.direction.x > 0 && host.suspended_can_right
		if left or right:
			if target_pos == null:
				target_pos = host.global_position.x + (24 * host.direction.x)
				host.speed.x = (target_pos - host.global_position.x) * 3.25
				host.side = sign(host.speed.x)
				side = host.side
		else:
			side = 0
	else:
		if host.speed.x == 0:
			side = 0
	if target_pos != null:
		#print(target_pos - host.global_position.x)
		#print(target_pos)
		#print(host.suspended_can_left, host.suspended_can_right)
		if abs(target_pos - host.global_position.x) < 1:
			host.global_position.x = target_pos
			target_pos = null
			if host.direction.x == 0:
				side = 0
			host.speed.x = 0

func state_exit(host: PlayerPhysics, next_state:String):
	target_pos = null
	side = 0
	host.suspended_can_left = true
	host.suspended_can_right = true

func state_animation_process(host, delta:float, animator: CharacterAnimator):
	#print(main_anim_name)
	var playback_speed = 1.59
	if side == 0:
		main_anim_name = "Suspended"
	else:
		main_anim_name = 'SuspendedMove'
	animator.animate(main_anim_name, playback_speed, true)


func _on_animation_finished(host, anim_name: String):
	pass

func get_class():
	return "State"

func is_class(name:String):
	return get_class() == name || .is_class(name)

func state_input(host, event):
	if event.is_action_pressed('ui_jump_i%d' % host.player_index):
		host.has_jumped = true
		host.speed.y -= host.jmp
		host.is_grounded = false
		host.spring_loaded = false
		host.is_floating = false
		host.has_jumped = true
		host.snap_margin = 0
		host.audio_player.play('jump')
		host.suspended_jump = true
		finish("OnAir")
