#import "AdColonyPlugin.h"

@implementation AdColonyPlugin

@synthesize adColonyAppOptions;
@synthesize interstitialCallbackId;

- (void) configureWithAppID: (CDVInvokedUrlCommand*) command{
    [AdColony configureWithAppID: [command.arguments objectAtIndex:0]
                         zoneIDs: [command.arguments objectAtIndex:1]
                         options: nil
                      completion: ^(NSArray<AdColonyZone*>* zones) {
                          CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                            messageAsString:@"Configuration successfully completed"];
                          [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                      }];
}

- (void) requestInterstitialInZone: (CDVInvokedUrlCommand*) command{
    [AdColony requestInterstitialInZone: [command.arguments objectAtIndex:0]
                                options: nil
                                success: ^(AdColonyInterstitial* ad) {
                                    ad.close = ^{
                                        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                                          messageAsString:@"Interstitial ad closed"];
                                        [self.commandDelegate sendPluginResult:pluginResult callbackId:interstitialCallbackId];
                                    };
                                    
                                    ad.expire = ^{
                                        adColonyInterstitial = nil;
                                        [self requestInterstitialInZone: command];
                                    };
                                    
                                    adColonyInterstitial = ad;
                                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                                      messageAsString:@"Interstitial ad loaded"];
                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                }
                                failure: ^(AdColonyAdRequestError* error){
                                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                                      messageAsString:[error localizedDescription]];
                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                }
     ];
}

- (void) showWithPresentingViewController: (CDVInvokedUrlCommand*) command{
    if (!adColonyInterstitial.expired){
        interstitialCallbackId = command.callbackId;
        [adColonyInterstitial showWithPresentingViewController:self.viewController];
    }
}

@end
