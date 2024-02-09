class_name DamageComponent
extends Node


@export_group("Damage Info")
## The base amount of damage an entity deals
##
## NOTE: This does not include any bounses from items or pickups
@export var _damage_amount: float
@export_category("Attack Cooldown")
@export var cooldown_timer: Timer

var _can_deal_damage: bool = true

# Deal damage to any body that has take_damage method on hit
func deal_damage_on_hit(body: CharacterBody2D):
	if body.has_method("take_damage") and _can_deal_damage:
		body.take_damage(_damage_amount)
		cooldown_timer.start()

# 
func increase_damage_by_level(level: int) -> float:
	_damage_amount *= 1.2
	return _damage_amount


func _on_cooldown_timer_timeout():
	_can_deal_damage = true