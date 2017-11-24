#import <Cordova/CDV.h>
#import <AdColony/AdColony.h>

static NSString *rewardCallBack = @"AdColony.onRewardReceived"; // The JavaScript Call back method name

@interface AdColonyPlugin : CDVPlugin{

	Boolean rewardCallBackReady;

}

@property AdColonyInterstitial *adColonyInterstitial;
@property AdColonyIAPEngagement *listener;
@property AdColonyAppOptions *adColonyAppOptions;
@property AdColonyAdOptions *adColonyAdOptions;
@property AdColonyUserMetadata *adColonyUserMetaData;
@property AdColonyZone *zone;
@property NSString *appID;
@property NSArray<NSString *> *zoneIDs;
@property NSString *interstitialCallbackId;

//AdColony
- (void) configureWithAppID:(CDVInvokedUrlCommand*) command;
- (void) setAppOptions: (CDVInvokedUrlCommand*) command;
- (void) setAdOptions: (CDVInvokedUrlCommand*) command;
- (void) setUserMetaData: (CDVInvokedUrlCommand*) command;
- (void) requestInterstitialInZone:(CDVInvokedUrlCommand*) command;
- (void) requestInterstitial:(CDVInvokedUrlCommand*) command;
//- (void) requestNativeAdViewInZone(CDVInvokedUrlCommand*) command;
//- (void) zoneForID(CDVInvokedUrlCommand*) command;
//- (void) getAdvertisingID(CDVInvokedUrlCommand*) command;
//- (void) getUserID(CDVInvokedUrlCommand*) command;
//- (void) setAppOptions(CDVInvokedUrlCommand*) command;
//- (void) getAppOptions(CDVInvokedUrlCommand*) command;
//- (void) sendCustomMessageOfType(CDVInvokedUrlCommand*) command;
//- (void) iapCompleteWithTransactionID(CDVInvokedUrlCommand*) command;
//- (void) getSDKVersion(CDVInvokedUrlCommand*) command;

//AdColonyInterstitial
- (void) showWithPresentingViewController:(CDVInvokedUrlCommand*) command;
- (void) registerRewardReceiver:(CDVInvokedUrlCommand*) command;

@end
