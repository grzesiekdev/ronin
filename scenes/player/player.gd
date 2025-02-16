extends CharacterBody2D

enum PlayerState { IDLE, MOVING, ATTACKING }
var state: PlayerState = PlayerState.IDLE
var facing_right: bool = true
var player_speed_multiplier: float
var max_player_speed_multiplier: float = 2

func _ready() -> void:
	GameEvents.player_damage_received.connect(hit)
	$AnimationPlayer.play("idle")
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)
	player_speed_multiplier = max_player_speed_multiplier

func _physics_process(delta: float) -> void:
	handle_movement()
	handle_animations()
	move_and_slide()
	PlayerStats.global_position = global_position

func handle_movement() -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * PlayerStats.speed * player_speed_multiplier

	if input_direction.x != 0:
		facing_right = input_direction.x > 0
		$Sprite2D.scale.x = 1 if facing_right else -1

func handle_animations() -> void:
	if state == PlayerState.ATTACKING:
		return

	if Input.is_action_just_pressed("attack"):
		state = PlayerState.ATTACKING
		player_speed_multiplier = 0
		$AnimationPlayer.play("attack_1")
		await $AnimationPlayer.animation_finished
		player_speed_multiplier = max_player_speed_multiplier
		return
	
	if velocity.length() > 0:
		state = PlayerState.MOVING
		$AnimationPlayer.play("run")
	else:
		state = PlayerState.IDLE
		$AnimationPlayer.play("idle")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "attack_1":
		state = PlayerState.IDLE

func hit(amount: int) -> void:
	PlayerStats.health -= amount
	if PlayerStats.health > 0:
		$AnimationPlayer.play("hit")
	else:
		pass
		# TODO: later on add death animation


func attack() -> void:
	var in_area = $AttackRange.get_overlapping_bodies()
	for body in in_area:
		if body.is_in_group("Enemies") || body.is_in_group("Destructable objects"):
			if 'hit' in body:
				body.hit(PlayerStats.damage)
