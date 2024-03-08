extends CanvasLayer

func _ready():
	$MarginContainer/AnimationPlayer.play("Reveal")
	
func _process(delta):
	$MarginContainer/Label3.set_text("FPS: " + str(Engine.get_frames_per_second()))
	
	if Input.is_action_just_pressed("ReloadCell"):
		$MarginContainer/AnimationPlayer.play("Reveal")
