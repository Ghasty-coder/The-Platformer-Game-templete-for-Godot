extends CharacterBody2D
@onready var timer: Timer = $Timer

@onready var score_label = $Label
@onready var animated_sprite = $AnimatedSprite2D
@onready var sound = $"Jump sound"
@onready var sound1 = $coin
@onready var sound2 = $hurt
@onready var sound3 = $powerup

@export var SPEED = 150.0
@export var JUMP_VELOCITY = -320.0
@export var MAX_HEALTH = 3
@export var BOUNCE_VELOCITY = -300.0
var score = 0
var health = MAX_HEALTH
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false
var is_invincible = false # متغير لفترة المناعة بعد تلقي الضرب

func _ready():
	update_health_ui()
func bounce(force: float) -> void:
	velocity.y = force

func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if is_dead:
		if not is_on_floor():
			velocity.y += gravity * delta
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sound.play()
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if not is_dead:
		update_animations(direction)

func update_animations(direction):
	if not is_on_floor():
		animated_sprite.play("Jump")
	else:
		if direction != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("Idie")
		
# دالة تلقي الضرر (تدميج اللاعب)
func take_damage(amount):
	if is_dead or is_invincible: return
	
	health -= amount
	sound2.play()
	update_health_ui()
	
	if health <= 0:
		die()
	else:
		# تشغيل أنيميشن الإصابة وعمل وميض مناعة مؤقت
		if animated_sprite.sprite_frames.has_animation("Hit"):
			animated_sprite.play("Hit")
		
		start_invincibility()

# دالة تفعيل المناعة المؤقتة (حتى لا يموت اللاعب بضربة واحدة مستمرة)
func start_invincibility():
	is_invincible = true
	# جعل اللاعب يومض بشكل شفاف لبيان أنه لا يتضرر حالياً
	animated_sprite.modulate.a = 0.5 
	
	# الانتظار لمدة ثانية واحدة (فترة المناعة)
	await get_tree().create_timer(1.0).timeout
	
	is_invincible = false
	animated_sprite.modulate.a = 1.0 # إعادة مظهر اللاعب الطبيعي

func heal(amount):
	if is_dead: return
	health = min(health + amount, MAX_HEALTH)
	sound3.play()
	update_health_ui()

func update_health_ui():
	if score_label: 
		score_label.text = "🪙: " + str(score) +" ❤️: " + str(health)

func add_score():
	score += 1
	update_health_ui()
	sound1.play()

func die():
	animated_sprite.play("Death")
	await animated_sprite.animation_finished
	get_tree().reload_current_scene()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
