extends Control

# تأكد من كتابة مسار المرحلة الأولى الصحيح هنا (يمكنك سحب ملف المرحلة من الـ FileSystem وإفلاته هنا)
@export_file("*.tscn") var first_level_scene = "res://مشاهد/level_select.tscn"

func _ready():
	pass

# هذه الدالة تم إنشاؤها تلقائياً عند ربط إشارة pressed لـ PlayButton
func _on_play_button_pressed():
	if first_level_scene:
		# السطر السحري لتغيير المشهد والانتقال للمرحلة الأولى فوراً
		get_tree().change_scene_to_file(first_level_scene)
	else:
		push_error("خطأ: لم يتم تحديد مسار المرحلة الأولى في الكود!")

# دالة زر الخروج من اللعبة بالكامل
func _on_quit_button_pressed():
	get_tree().quit()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://مشاهد/about.tscn")
