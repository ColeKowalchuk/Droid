extends Node2D

const BULLET = preload("res://laser_shot.tscn")

func _ready():
	var parent = get_parent()
	if parent.name == "RightHand":
		$RightHand.show()
	elif parent.name == "LeftHand":
		$LeftHand.show()

func _process(delta):
	if Input.is_action_just_pressed("FlipWeapon"):
		$RightHand.visible = not $RightHand.visible
		$LeftHand.visible = not $LeftHand.visible
		#play_animation(owner.get_node("AnimationPlayer").current_animation)
		play_animation(owner.last_animation) # This sets the sprite facing the right way even if stationary
	
	if Input.is_action_just_pressed("WeaponToggle"): # DEBUG ONLY
		visible = not visible # DEBUG ONLY
		
	if Input.is_action_pressed("left_click"):
		if visible and $AttackSpeed.is_stopped():
			var laser_shot = BULLET.instantiate()
			var player_animation = owner.last_animation
			
			if $RightHand.visible:
				if "Up" in player_animation:
					laser_shot.position = owner.position + Vector2(7,-9)
				elif "Down" in player_animation:
					laser_shot.position = owner.position + Vector2(-7,9)
				elif "Right" in player_animation:
					laser_shot.position = owner.position + Vector2(8,-1)
				elif "Left" in player_animation:
					laser_shot.position = owner.position + Vector2(-8,-1)
				else:
					laser_shot.position = owner.position + Vector2(8,2)
					
			elif $LeftHand.visible:
				if "Up" in player_animation:
					laser_shot.position = owner.position + Vector2(-7,-9)
				elif "Down" in player_animation:
					laser_shot.position = owner.position + Vector2(7,9)
				elif "Right" in player_animation:
					laser_shot.position = owner.position + Vector2(8,0) # Purposly 1 higher for duel weild effect
				elif "Left" in player_animation:
					laser_shot.position = owner.position + Vector2(-8,0)
				else:
					laser_shot.position = owner.position + Vector2(-8,-2)
			
					
			laser_shot.target = get_global_mouse_position()
			get_tree().get_current_scene().add_child(laser_shot)
			$AttackSpeed.start()
		
func play_animation(animation):
	#show()
	if $RightHand.visible:
		$RightHand/AnimationPlayer.play(animation)
	
	elif $LeftHand.visible:
		$LeftHand/AnimationPlayer.play(animation)

func stop_animation():
	#show()
	if $RightHand.visible:
		$RightHand/AnimationPlayer.stop()
		
	elif $LeftHand.visible:
		$LeftHand/AnimationPlayer.stop()
