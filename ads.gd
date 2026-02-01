extends Node

var global_var = load("res://global_var.gd").new()

# Rewarded Ad
var rewarded_ad : RewardedAd

var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
var unit_id_android_rewarded = "ca-app-pub-5481742624574647/8031980714" # ad real

# Interstitial Ad
var interstitial_ad : InterstitialAd
var interstitial_ad_is_view : bool = false
var interstitial_ad_is_loaded : bool = false

var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
var unit_id_android_interstitial : String = "ca-app-pub-5481742624574647/8865731999" # ad real

# Full screen callbacks (compartidos)
var _full_screen_content_callback := FullScreenContentCallback.new()

func _ready() -> void:
	# Inicializar AdMob
	MobileAds.initialize()
	print("iniciando admob")
	
	# Rewarded Ads
	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
		var data = JSON.parse_string(global_var.load_data())
		data.money += rewarded_item.amount
		global_var.save_data(JSON.stringify(data))
		for item in get_parent().get_children():
			if item.name == "LobyRework":
				var loby = item
				var money_disp = loby.get_node("MainHud/CanvasLayer/MoneyDisplay")
				money_disp.reset_money()
	
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded
	
	# Interstitial Ads
	interstitial_ad_load_callback.on_ad_failed_to_load = on_interstitial_ad_failed_to_load
	interstitial_ad_load_callback.on_ad_loaded = on_interstitial_ad_loaded
	
	# Callbacks de pantalla completa
	_full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
		if interstitial_ad_is_view:
			free_memory_interstitial_ad()
			
		free_memory_rewarded_ad()
	
	_full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("Error al mostrar anuncio: %s" % ad_error.message)
		if interstitial_ad_is_view:
			free_memory_interstitial_ad()
			_load_interstitial_ad()
			
		free_memory_rewarded_ad()

# Rewarded Ads

func _load_and_show_rewarded_ad():
	RewardedAdLoader.new().load(unit_id_android_rewarded, AdRequest.new(), rewarded_ad_load_callback)
	

func on_rewarded_ad_failed_to_load(adError : LoadAdError) -> void:
	print("Error al cargar rewarded: %s" % adError.message)

func on_rewarded_ad_loaded(rewarded_ad_loaded : RewardedAd) -> void:
	rewarded_ad = rewarded_ad_loaded
	rewarded_ad.full_screen_content_callback = _full_screen_content_callback
	print("Rewarded cargado correctamente")
	#mostramos el rewarded ad, nada mas esta listo
	rewarded_ad.show(on_user_earned_reward_listener)

func free_memory_rewarded_ad():
	if rewarded_ad:
		rewarded_ad.destroy()
		rewarded_ad = null

# Interstitial Ads

func _load_interstitial_ad():
	if not interstitial_ad:
		InterstitialAdLoader.new().load(unit_id_android_interstitial, AdRequest.new(), interstitial_ad_load_callback)
		interstitial_ad_is_view = false
		interstitial_ad_is_loaded = false

func on_interstitial_ad_failed_to_load(adError : LoadAdError) -> void:
	print("Error al cargar interstitial: %s" % adError.message)
	_load_interstitial_ad()

func on_interstitial_ad_loaded(interstitial_ad_loaded : InterstitialAd) -> void:
	interstitial_ad = interstitial_ad_loaded
	interstitial_ad.full_screen_content_callback = _full_screen_content_callback
	interstitial_ad_is_loaded = true
	print("Interstitial cargado correctamente")

func _show_interstitial_ad():
	if interstitial_ad and interstitial_ad_is_loaded and not interstitial_ad_is_view:
		interstitial_ad.show()
		interstitial_ad_is_view = true
		interstitial_ad_is_loaded = false
	else:
		print("Interstitial aún no está listo")

func free_memory_interstitial_ad():
	if interstitial_ad:
		interstitial_ad.destroy()
		interstitial_ad = null
		interstitial_ad_is_loaded = false
