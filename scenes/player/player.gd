class_name Player
extends CharacterBody2D

@export var health_comp: HealthComponent
@export var damage_comp: DamageComponent
@export var move_comp: MovementComponent
@export var jump_comp: AdvancedJumpComponent
@export var grav_comp: GravityComponent
@export var input_comp: InputComponent
@export var anim_comp: AnimationComponent

@onready var sprite_2d = $Sprite2D
@onready var cooldown_timer = $DamageComponent/CooldownTimer
@onready var hit_box_component = $HitBoxComponent
@onready var animation_player = $AnimationPlayer
@onready var hurt_timer = $HurtTimer
@onready var facing_collision_shape = $HitBoxComponent/FacingCollisionShape

signal facing_dir_changed(facing_right: bool)
signal adjust_ui_health(health: float)

var enemy= null
var is_hurt: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("adjust_ui_health", health_comp._health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	grav_comp.handle_gravity(self, delta)
	move_comp.player_movement(self, input_comp.input_horizontal)
	jump_comp.handle_jump(self, input_comp.get_jump_input(), input_comp.released_jump())
	anim_comp.handle_move_animation(input_comp.input_horizontal)
	anim_comp.handle_jump_animation(jump_comp.is_going_up, grav_comp.is_falling)
	emit_signal("facing_dir_changed", !sprite_2d.flip_h)
	
	if enemy != null and input_comp.get_attack_input():
		damage_comp.deal_damage_on_hit(enemy)

	move_and_slide()

func _on_hit_box_component_body_entered(body):
	enemy = body

func _on_hit_box_component_body_exited(body):
	if body == enemy:
		enemy = null

func take_damage(damage):
	health_comp.take_damage(damage)
	emit_signal("adjust_ui_health", health_comp._health)
	hurt_timer.start()
	is_hurt = true
	facing_collision_shape.visible = false
	set_physics_process(false) 
	anim_comp.handle_hurt_animation(is_hurt)

func _on_hurt_timer_timeout():
	is_hurt = false
	facing_collision_shape.visible = true
	set_physics_process(true)
