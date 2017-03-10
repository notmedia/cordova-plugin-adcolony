#import <Cordova/CDV.h>
#import <AdColony/AdColony.h>

@interface AdColonyPlugin : CDVPlugin{
    AdColonyInterstitial *adColonyInterstitial;
}

@property AdColonyAppOptions *adColonyAppOptions;
@property NSString *interstitialCallbackId;

//AdColony
- (void) configureWithAppID:(CDVInvokedUrlCommand*) command;
- (void) requestInterstitialInZone:(CDVInvokedUrlCommand*) command;
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

@end
