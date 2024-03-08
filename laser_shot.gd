extends Area2D

var velocity : Vector2
var speed = 2
var target : Vector2

func _ready():
	velocity = position.direction_to(target) * speed
	look_at(target)
	rotate(deg_to_rad(90))
	
func _physics_process(delta):
	position.x += velocity.x
	position.y += velocity.y

func destroy():
	$HitboxComponent/CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.hide()
	$HitEffect.process_material.set("direction", 1 * Vector3(velocity.x * -1, -100, 0))
	$HitEffect.emitting = true
	$Timer.start()


func _on_timer_timeout():
	queue_free()
