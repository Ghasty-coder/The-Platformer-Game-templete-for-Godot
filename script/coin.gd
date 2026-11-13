extends Area2D

func _ready():
	# التأكد من ربط الإشارة برمجياً
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# الفحص الأول: إذا كان اسم العقدة هو "Player" أو نوعها اللاعب المبرمج
	if body.name == "Player" or body is CharacterBody2D:
		# طباعة رسالة في نافذة الـ Output للتأكد من حدوث اللمس
		print("اللاعب جمع العملة!") 
		
		# استدعاء الدالة مباشرة مع استخدام اسم الدالة الصحيح
		if body.has_method("add_score"):
			body.add_score()
		else:
			# إذا لم يجد الدالة، سيطبع هذا التحذير بالأسفل لتعرف السبب
			print("تحذير: لم يتم العثور على دالة add_score داخل اللاعب")
			
		queue_free() # حذف العملة
