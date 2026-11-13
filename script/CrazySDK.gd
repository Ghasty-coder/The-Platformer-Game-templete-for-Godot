extends Node

signal ad_started
signal ad_finished
signal ad_error
signal ad_done # finished or error
signal adblock_result # error, result

var SDK = null

var adStartedCallback
var adErrorCallback
var adFinishedCallback
var adCallbacks
var adblockCallback

func hasSDK() -> bool:
	return SDK != null

func _ready() -> void:
	if not OS.has_feature("web") and not OS.has_feature("crazygames"): 
		return
	
	var window = JavaScriptBridge.get_interface("window")
	if not window or not window.CrazyGames:
		return
		
	SDK = window.CrazyGames.SDK

	# في Godot 4 نمرر الدالة مباشرة كـ Callable دون كلمة self
	adStartedCallback = JavaScriptBridge.create_callback(adStarted)
	adErrorCallback = JavaScriptBridge.create_callback(adError)
	adFinishedCallback = JavaScriptBridge.create_callback(adFinished)

	adCallbacks = JavaScriptBridge.create_object("Object")
	adCallbacks["adFinished"] = adFinishedCallback
	adCallbacks["adError"] = adErrorCallback
	adCallbacks["adStarted"] = adStartedCallback
	
	adblockCallback = JavaScriptBridge.create_callback(adblockResult)

# ad module

func adStarted(args: Array) -> void:
	print("[Godot] adStarted callback")
	emit_signal("ad_started")

func adError(args: Array) -> void:
	print("[Godot] adError callback")
	var error = args[0] if args.size() > 0 else null
	emit_signal("ad_error", error)
	emit_signal("ad_done")

func adFinished(args: Array) -> void:
	print("[Godot] adFinished callback")
	emit_signal("ad_finished")
	emit_signal("ad_done")

func midgameAd() -> void:
	if not SDK: return
	SDK.ad.requestAd("midgame", adCallbacks)

func rewardedAd() -> void:
	if not SDK: return
	SDK.ad.requestAd("rewarded", adCallbacks)

func detectAdblock() -> void:
	if not SDK: return
	SDK.ad.hasAdblock(adblockCallback)

func adblockResult(args: Array) -> void:
	var error = args[0] if args.size() > 0 else null
	var result = args[1] if args.size() > 1 else null
	emit_signal("adblock_result", error, result)

# game module

func gameplayStart() -> void:
	if not SDK: return
	SDK.game.gameplayStart()

func gameplayStop() -> void:
	if not SDK: return
	SDK.game.gameplayStop()

func happytime() -> void:
	if not SDK: return
	SDK.game.happytime()

func gameLoadingStart() -> void:
	if not SDK: return
	SDK.game.sdkGameLoadingStart()

func gameLoadingStop() -> void:
	if not SDK: return
	SDK.game.sdkGameLoadingStop()

# banner module

func requestBanner(width : int, height : int) -> void:
	if not SDK: return
	var params = JavaScriptBridge.create_object("Object")
	params["id"] = "banner-container"
	params["width"] = width
	params["height"] = height
	SDK.banner.requestBanner(params)

func requestResponsiveBanner() -> void:
	if not SDK: return
	SDK.banner.requestResponsiveBanner("responsive-banner-container")

func clearAllBanners() -> void:
	if not SDK: return
	SDK.banner.clearAllBanners()
