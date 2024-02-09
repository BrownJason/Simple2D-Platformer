class_name BaseEnemy
extends CharacterBody2D

@export var health_comp: HealthComponent
@export var damage_comp: DamageComponent
@export var move_comp: MovementComponent

var player: Player
@onready var sprite_2d = $Sprite2D
@onready var damage_label = $DamageLabel

func _ready():
	damage_label.value = health_comp._health
	damage_label.max_value = health_comp._health

func _process(delta):
	velocity = Vector2.ZERO
	if player:
		move_comp.enemy_chase(self, player, delta)
		velocity.y = 0
	
	if velocity.x < 0:
		sprite_2d.flip_h = false
	if velocity.x > 0:
		sprite_2d.flip_h = true
	
	if velocity.x != 0 and !player:
		move_toward(velocity.x, 0.0, delta)
	
	move_and_slide()

func take_damage(damage):
	health_comp.take_damage(damage)
	damage_label.value = health_comp._health

func _on_area_2d_body_entered(body):
	player = body

func _on_area_2d_body_exited(body):
	player = null
