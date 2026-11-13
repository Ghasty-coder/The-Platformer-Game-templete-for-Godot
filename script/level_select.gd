extends Control

# تصحيح الفلتر لجميع المراحل ليكون (*.tscn) ليعمل السحب والإفلات بشكل صحيح
@export_file("*.tscn") var level_1_scene
@export_file("*.tscn") var level_2_scene
@export_file("*.tscn") var level_3_scene
@export_file("*.tscn") var level_4_scene
@export_file("*.tscn") var level_5_scene
@export_file("*.tscn") var level_6_scene
@export_file("*.tscn") var level_7_scene
@export_file("*.tscn") var level_8_scene

@onready var grid_container = %GridContainer

func _ready():
	# مصفوفة تحتوي على مسارات المراحل الـ 8
	var level_paths = [
		level_1_scene, level_2_scene, level_3_scene, level_4_scene,
		level_5_scene, level_6_scene, level_7_scene, level_8_scene
	]
	
	var buttons = grid_container.get_children()
	
	for i in range(buttons.size()):
		var button = buttons[i]
		
		button.disabled = false
		button.modulate.a = 1.0 
		
		var path = level_paths[i]
		
		if path != null and path != "":
			# حماية إضافية: فحص ما إذا كان الزر مرتبطاً من قبل لمنع الأخطاء
			if not button.pressed.is_connected(func(): get_tree().change_scene_to_file(path)):
				button.pressed.connect(func(): get_tree().change_scene_to_file(path))
		else:
			print("تنبيه: الزر رقم ", i + 1, " غير مربوط بمشهد في الـ Inspector!")
