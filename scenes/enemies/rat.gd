extends Enemy

func _ready():
	super._ready()
	health = 20
	speed = 150
	death_animation = "death"
	base_damage = 5

	$AnimationPlayer.play("idle")


func _on_attack_timer_timeout() -> void:
	can_attack = true


func _on_invulnerability_timer_timeout() -> void:
	is_invulnerable = false
