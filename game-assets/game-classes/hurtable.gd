extends KinematicBody2D
class_name Hurtable

class RigidVariation extends RigidBody2D:
	func on_player_damage(player:PlayerPhysics):
		pass

	func push_player(player:PlayerPhysics):
		var distance = global_position.direction_to(player.global_position).sign()
		player.damage(distance);
		on_player_damage(player)

func on_player_damage(player:PlayerPhysics):
	pass

func push_player(player:PlayerPhysics):
	var distance = global_position.direction_to(player.global_position).sign()
	player.damage(distance);
	on_player_damage(player)