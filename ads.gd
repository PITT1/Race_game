extends Node

var global_var = load("res://global_var.gd").new()

#rewarded ad
var _rewarded_ad : RewardedAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()

#intersticial ads
var _interstitial_ad : InterstitialAd

func _ready() -> void:
	#iniciando ads
	MobileAds.initialize()
	print("iniciando admob")
	
	#callback de recompensa al jugador 1500 de dinero
	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
		var data = JSON.parse_string(global_var.load_data())
		data.money += rewarded_item.amount
		global_var.save_data(JSON.stringify(data))

func _on_load_pressed_rewarded_ad():
	#free memory
	if _rewarded_ad:
		#always call this method on all AdFormats to free memory on Android/iOS
		_rewarded_ad.destroy()
		_rewarded_ad = null
		
	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/5224354917" #ad de prueba
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/1712485313"
	
	var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
	rewarded_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)
	
	rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
		print("rewarded ad loaded" + str(rewarded_ad._uid))
		_rewarded_ad = rewarded_ad
	
	RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_ad_load_callback)

# button signal on scene
func _on_show_pressed_rewarded_ad():
	if _rewarded_ad:
		_rewarded_ad.show()

func _load_interstitial_ad():
	#free memory
	if _interstitial_ad:
		#always call this method on all AdFormats to free memory on Android/iOS
		_interstitial_ad.destroy()
		_interstitial_ad = null
	
	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/1033173712" #ad de prueba
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/4411468910"
	
	var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
	interstitial_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)
	
	interstitial_ad_load_callback.on_ad_loaded = func(interstitial_ad : InterstitialAd) -> void:
		print("interstitial ad loaded" + str(interstitial_ad._uid))
		_interstitial_ad = interstitial_ad
	
	InterstitialAdLoader.new().load(unit_id, AdRequest.new(), interstitial_ad_load_callback)

func _show_interstitial_ad():
	if _interstitial_ad:
		_interstitial_ad.show()
