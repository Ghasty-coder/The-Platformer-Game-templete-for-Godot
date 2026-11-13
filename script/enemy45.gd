extends CharacterBody2D

const SPEED = 40.0
var direction = 1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var ray_cast = $RayCast2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var sound4 = $AudioStreamPlayer

func _physics_process(delta):
	# الجاذبية الطبيعية للوحش
	if not is_on_floor():
		velocity.y += gravity * delta

	# تغيير الاتجاه إذا اصطدم بجدار حقيقي أو وصل لحافة المنصة
	if is_on_wall() or not ray_cast.is_colliding():
		direction *= -1
		ray_cast.position.x *= -1
		animated_sprite.flip_h = (direction < 0)

	velocity.x = direction * SPEED
	move_and_slide()

# دالة الموت عند القفز فوقه
func die():
	sound4.play()
	queue_free()

# هذه هي الدالة التي تم ربطها من الإشارات (تأكد من وجود أيقونة الإشارة الخضراء بجانبها)
func _on_hurtbox_body_entered(body: Node2D) -> void:
	# التحقق من أن الجسم الذي دخل المنطقة هو اللاعب
	if body.name == "Player" or body.has_method("take_damage"):
		
		# إذا كان اللاعب يهبط لأسفل (يقفز فوق رأس الوحش)
		if body.velocity.y > 0 and (body.global_position.y < global_position.y):
			body.velocity.y = body.BOUNCE_VELOCITY # يرتد اللاعب لأعلى
		else:
			# إذا لمسه من الجنب، يتم دمج اللاعب
			body.take_damage(3)
