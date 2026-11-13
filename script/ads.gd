extends Node

# معرفات الإعلانات التجريبية
var banner_id = "ca-app-pub-9696578935991691/1503178496"
var interstitial_id = "ca-app-pub-9696578935991691/1336279655"
var rewarded_id = "ca-app-pub-9696578935991691/7534148650"

var ad_view: AdView
var interstitial_ad: InterstitialAd
var rewarded_ad: RewardedAd

func _ready():
	# 1. تهيئة AdMob
	MobileAds.initialize()
	
	# 2. تحميل الإعلانات عند بدء التشغيل
	load_banner()
	load_interstitial()
	load_rewarded()

# --- 1. إعلان البانر (Banner) ---
func load_banner():
	ad_view = AdView.new(banner_id, AdSize.BANNER, AdPosition.TOP)
	ad_view.load_ad(AdRequest.new())

# --- 2. إعلان الشاشة الكاملة (Interstitial) ---
func load_interstitial():
	var load_callback := InterstitialAdLoadCallback.new()
	load_callback.on_ad_loaded = func(ad: InterstitialAd):
		interstitial_ad = ad
		print("Interstitial Ad Loaded successfully!")
		
	load_callback.on_ad_failed_to_load = func(error: LoadAdError):
		print("Failed to load Interstitial: ", error.message)
		
	InterstitialAdLoader.new().load(interstitial_id, AdRequest.new(), load_callback)

func show_interstitial():
	if interstitial_ad:
		interstitial_ad.show()
	else:
		print("Interstitial ad is not ready yet.")
		load_interstitial()

# --- 3. إعلان المكافأة (Rewarded) ---
func load_rewarded():
	var load_callback := RewardedAdLoadCallback.new()
	load_callback.on_ad_loaded = func(ad: RewardedAd):
		rewarded_ad = ad
		print("Rewarded Ad Loaded successfully!")
		
	load_callback.on_ad_failed_to_load = func(error: LoadAdError):
		print("Failed to load Rewarded Ad: ", error.message)
		
	RewardedAdLoader.new().load(rewarded_id, AdRequest.new(), load_callback)

func show_rewarded():
	if rewarded_ad:
		var listener := OnUserEarnedRewardListener.new()
		# تم إزالة تحديد نوع المتغير لتجنب أخطاء النطاق، وسيقوم Godot بالتعرف عليه تلقائياً
		listener.on_user_earned_reward = func(reward):
			print("User earned reward!")
			# 👉 حط كود إعطاء الجائزة هنا (مثلاً: زيادة العملات الذهبية)
			# مثال: Global.coins += 10
			
			# إعادة تحميل إعلان مكافأة جديد استعداداً للمرة القادمة
			load_rewarded()
			
		rewarded_ad.show(listener)
	else:
		print("Rewarded ad is not ready yet.")
		load_rewarded()
