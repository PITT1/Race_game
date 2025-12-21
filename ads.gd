extends Node

var admob_init = true
var _ad_view : AdView

#rewarded ad
var _rewarded_ad : RewardedAd

#intersticial ads
var _interstitial_ad : InterstitialAd

func destroy_ad_view() -> void:
	if _ad_view:
		#always call this method on all AdFormats to free memory on Android/iOS
		_ad_view.destroy()
		_ad_view = null

func _create_ad_banner() -> void:
	#free memory
	if _ad_view:
		destroy_ad_view()

	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-5481742624574647/4431647059" #este es un id real
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/2934735716"

	_ad_view = AdView.new(unit_id, AdSize.BANNER, AdPosition.Values.TOP)

func _on_load_pressed_rewarded_ad():
	#free memory
	if _rewarded_ad:
		#always call this method on all AdFormats to free memory on Android/iOS
		_rewarded_ad.destroy()
		_rewarded_ad = null
		
	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-5481742624574647/8031980714"
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
		unit_id = "ca-app-pub-5481742624574647/8865731999"
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
