extends Area2D

@export var heal_amount = 1 # كمية الصحة التي تعيدها الفاكهة

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# التأكد من أن الذي أكل الفاكهة هو اللاعب ويمتلك دالة العلاج
	if body.has_method("heal"):
		body.heal(heal_amount) # معالجة اللاعب
		queue_free() # اختفاء الفاكهة
