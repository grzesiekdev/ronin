extends Node2D
class_name Enemy

enum EnemyState { IDLE, MOVING, ATTACKING, CASTING }

# Base stats with default values
@export var health: int = 10
@export var speed: int = 200
@export var death_animation: String = "default_death"
@export var base_damage: int = 10

var is_invulnerable: bool = false
var can_attack: bool = false

func _ready() -> void:
	pass

func hit(damage: int) -> void:
	health -= damage
	if health <= 0 and not is_invulnerable:
		$AnimationPlayer.play(death_animation)
		await $AnimationPlayer.animation_finished
		queue_free()
	is_invulnerable = true
	$Timers/InvulnerabilityTimer.start()

func attack() -> void:
	if can_attack:
		$AnimationPlayer.play("attack")
		GameEvents.emit_player_damage(base_damage)
		can_attack = false
		$Timers/AttackTimer.start()
