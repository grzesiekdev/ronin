extends Node

signal player_damage_received(amount: int)

func emit_player_damage(amount: int) -> void:
	player_damage_received.emit(amount)
