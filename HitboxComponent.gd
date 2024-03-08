extends Area2D

@export var health_component : HealthComponent
@export var damage_component : DamageComponent

func damage(attack):
	if health_component:
		health_component.damage(attack)

func _on_body_entered(body):
	if damage_component:
		# Do damage
		pass
		
	if health_component:
		pass
	
	else:
		owner.destroy()
