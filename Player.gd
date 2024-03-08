extends CharacterBody2D
# Layer is exists on, mask is collides with

@export var TILEMAP : TileMap
var SPEED := 120
var ACCELERATION := 10
var FRICTION := -1.5

# vars for tracking tile particle tracks
var ON_PUDDLE := false
var ON_GOO := false
var GOO_DISTANCE = -1

var last_animation : String

func _ready():
	pass

func get_input_direction():
	var input_direction = Vector2.ZERO
	
	
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_direction = input_direction.normalized()
	
	return input_direction
	
func accelerate(direction: Vector2):
	velocity = velocity.move_toward(SPEED * direction, ACCELERATION)
	
func apply_friction():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
func _physics_process(delta):
	var input_dir: Vector2 = get_input_direction()
	# Moving
	_animate_player(input_dir)
	_animate_weapons($AnimationPlayer.current_animation, input_dir)
	
	if $AnimationPlayer.current_animation:
		_animate_visor($AnimationPlayer.current_animation)
		
	accelerate(input_dir)
	apply_friction()
	move_and_slide()
	
func _animate_player(input_dir):
	if abs(input_dir.x) > abs(input_dir.y):
		# We are accelerating left or right
		if input_dir.x > 0:
			$AnimationPlayer.play("Sprint_Right")
		elif input_dir.x < 0:
			$AnimationPlayer.play("Sprint_Left")
	
	elif abs(input_dir.x) < abs(input_dir.y):
		# We are accelerating up or down
		if input_dir.y > 0:
			$AnimationPlayer.play("Sprint_Down")
			$VisorLight.offset.y = -52
		elif input_dir.y < 0:
			$AnimationPlayer.play("Sprint_Up")
			$VisorLight.offset.y = -2
	
	elif abs(velocity.x) > abs(velocity.y):
		# We are coasting
		if velocity.x > 0:
			$AnimationPlayer.play("Coast_Right")
		elif velocity.x < 0:
			$AnimationPlayer.play("Coast_Left")
	
	elif abs(velocity.x) < abs(velocity.y):
		if velocity.y > 0:
			$AnimationPlayer.play("Coast_Down")
		elif velocity.y < 0:
			$AnimationPlayer.play("Coast_Up")
	
	elif input_dir.length() == 0:
		$AnimationPlayer.stop()
	
func _animate_weapons(animation, input_dir):
	for slot in $Weapons.get_children():
		for weapon in slot.get_children():
			if animation:
				weapon.play_animation(animation)
			if velocity.length() == 0:
				weapon.stop_animation()
			
func _animate_visor(animation):
	if "Up" in animation:
		$VisorLight.rotation = deg_to_rad(0)
		$VisorLight.offset.x = 0
		
		if animation == "Coast_Up":
			$VisorLight.offset.y = -25
		elif animation == "Sprint_Up":
			$VisorLight.offset.y = -27
		
	elif "Down" in animation:
		$VisorLight.rotation = deg_to_rad(180)
		$VisorLight.offset.x = 0
		
		if animation == "Coast_Down":
			$VisorLight.offset.y = -25
		elif animation == "Sprint_Down":
			$VisorLight.offset.y = -27
	
	elif "Right" in animation:
		$VisorLight.rotation = deg_to_rad(90)
		$VisorLight.offset.x = -5
		
		if animation == "Coast_Right":
			$VisorLight.offset.y = -24
		elif animation == "Sprint_Right":
			$VisorLight.offset.y = -26
	
	elif "Left" in animation:
		$VisorLight.rotation = deg_to_rad(-90)
		$VisorLight.offset.x = 5
		
		if animation == "Coast_Left":
			$VisorLight.offset.y = -24
		elif animation == "Sprint_Left":
			$VisorLight.offset.y = -26
		
func _calculate_goo_direction():
	if "Right" in $AnimationPlayer.current_animation or "Left" in $AnimationPlayer.current_animation:
		$Particles/GooTracksH.emitting = true
		$Particles/GooTracksV.emitting = false
	else:
		$Particles/GooTracksV.emitting = true
		$Particles/GooTracksH.emitting = false
				
func _process(delta):
	# Camera offset
	var mouse_pos = get_global_mouse_position()
	var offset_h = (mouse_pos.x - global_position.x) / (640.0 / 85.0)
	var offset_v = (mouse_pos.y - global_position.y) / (360.0 / 85.0) 
	$Camera2D.offset = Vector2(offset_h, offset_v)
	
	# TOGGLE VISOR
	if Input.is_action_just_pressed("VisorToggle"):
		$VisorLight.visible = not $VisorLight.visible
		
	if Input.is_action_just_pressed("EquipWeapon"):
		$Weapons/LeftHand/PlasmaPistol.visible = not $Weapons/LeftHand/PlasmaPistol.visible
		
	# PLAYER TERRAIN TRACKS
	#print(ON_PUDDLE, velocity != Vector2.ZERO)
	if ON_PUDDLE and velocity != Vector2.ZERO:
		$Particles/WaterSplash.process_material.set("direction", Vector3(velocity.x * -1, -100, 0))
		$Particles/WaterSplash.emitting = true
	
	else:
		$Particles/WaterSplash.emitting = false
	
	if ON_GOO:
			_calculate_goo_direction()
			GOO_DISTANCE = 0
	
	if GOO_DISTANCE >= 0:
		_calculate_goo_direction()
			
		GOO_DISTANCE += velocity.length()
		
	if GOO_DISTANCE >= 80000:
		GOO_DISTANCE = -1
		$Particles/GooTracksV.emitting = false
		$Particles/GooTracksH.emitting = false
			
	if $AnimationPlayer.current_animation:
		last_animation = $AnimationPlayer.current_animation
	"""
	# If the player clicks/holds Mouse1 and the attack speed timer has finished its count, shoot
	if Input.is_action_pressed("left_click") and $AttackSpeed.is_stopped():
			
		# Shoot, intitiate a BulletPlayer and set its velocity
		var bullet = Game.PLAYERBULLET.instantiate()
		# Set to player position
	
		bullet.velocity = (get_global_mouse_position() - position).normalized() * bullet_speed
		bullet.position.x = position.x + bullet.velocity.x/10
		bullet.position.y = position.y + bullet.velocity.y/10
			
		bullet.pierce = self.pierce
		if self.pierce >= 1:
			# For piercing bullets 
			bullet.get_node("Sprite2D").look_at(get_global_mouse_position())
			bullet.get_node("Sprite2D").rotation += deg_to_rad(90)
			
		current_bubble.call_deferred("add_child", bullet)
		$SoundShoot.play()
			
		# Start attack_speed timer
		$AttackSpeed.start()
	"""
	if Input.is_action_just_pressed("ReloadCell"):
		pass

func enter_terrain(tile_data : String):
	if tile_data == "puddle":
		ON_PUDDLE = true
	elif tile_data == "goo":
		ON_GOO = true

func leave_terrain(tile_data : String):
	if tile_data == "puddle":
		ON_PUDDLE = false
	elif tile_data == "goo":
		ON_GOO = false
