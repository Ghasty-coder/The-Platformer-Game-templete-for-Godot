extends Area2D

# متغير يتيح لك اختيار مشهد المرحلة التالية من الـ Inspector بسهولة
@export_file("*.tscn") var next_scene

func _ready():
	# سطر حماية ذكي: يفحص إذا كانت إشارة اللمس مرتبطة مسبقاً لمنع تكرار الربط وظهور الأخطاء الحمراء
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# التحقق من أن الجسم الذي لمس البوابة هو اللاعب الحقيقي
	if body.name == "Player" or body is CharacterBody2D:
		if next_scene:
			# السطر السحري المسؤول عن تغيير المشهد والانتقال للمرحلة التالية فوراً
			get_tree().change_scene_to_file(next_scene)
		else:
			print("تنبيه: لم يتم وضع ملف المرحلة التالية في الـ Inspector لهذه البوابة!")
