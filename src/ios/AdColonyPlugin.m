#import "AdColonyPlugin.h"

@implementation AdColonyPlugin

@synthesize adColonyInterstitial = _adColonyInterstitial;
@synthesize listener = _listener;
@synthesize adColonyAppOptions;
@synthesize adColonyAdOptions;
@synthesize adColonyUserMetaData;
@synthesize interstitialCallbackId;
@synthesize appID = _appID;
@synthesize zoneIDs = _zoneIDs;
@synthesize zone = _zone;

// Plugin methods
- (void) configure: (CDVInvokedUrlCommand*) command{
	rewardCallBackReady = false;
	NSMutableDictionary *adColonyPrefs = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AdColony"];
	_appID = [adColonyPrefs objectForKey:@"APP_ID"];
	_zoneIDs = [[NSArray alloc] initWithObjects:[adColonyPrefs objectForKey:@"ZONE_ID"], nil];
	adColonyAppOptions = [AdColony getAppOptions];
	adColonyAdOptions = [[AdColonyAdOptions alloc] init];
	adColonyUserMetaData = [[AdColonyUserMetadata alloc] init];
	[self configureWithAppID:_appID andZoneIDs:_zoneIDs withCallBackId:command.callbackId];
}

- (void) configureWithAppID: (CDVInvokedUrlCommand*) command{
	[self configureWithAppID:[command.arguments objectAtIndex:0]
				  andZoneIDs:[command.arguments objectAtIndex:1]
			  withCallBackId:command.callbackId];
}

- (void) setAppOptions: (CDVInvokedUrlCommand*) command{
	NSDictionary *appOptions = [command.arguments objectAtIndex:0];
	if (adColonyAppOptions == nil)
		adColonyAppOptions = [AdColony getAppOptions];
	if (adColonyAppOptions == nil)
		adColonyAppOptions = [[AdColonyAppOptions alloc] init];
	for (id key in appOptions) {
		NSString *val =[appOptions objectForKey:key];
		if ([key caseInsensitiveCompare:@"orientation"] == NSOrderedSame) {
			switch ([val integerValue]) {
				case 0:
					[adColonyAppOptions setAdOrientation:AdColonyOrientationPortrait];
					break;
				case 1:
					[adColonyAppOptions setAdOrientation:AdColonyOrientationLandscape];
					break;
				default:
					[adColonyAppOptions setAdOrientation:AdColonyOrientationAll];
					break;
			}
			continue;
		}
		if ([key caseInsensitiveCompare:@"app_orientation"] == NSOrderedSame) {
			continue;
		}
		if ([key caseInsensitiveCompare:@"origin_store"] == NSOrderedSame) {
			continue;
		}
		if ([key caseInsensitiveCompare:@"disable_logging"] == NSOrderedSame) {
			[adColonyAppOptions setDisableLogging:[val boolValue]];
			continue;
		}
		if ([key caseInsensitiveCompare:@"userid"] == NSOrderedSame) {
			[adColonyAppOptions setUserID:val];
			continue;
		}
		@try {
			[adColonyAppOptions setValue:val forKey:key];
		} @catch (NSException *ex) {

		}
	}
	[AdColony setAppOptions:adColonyAppOptions];
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
													  messageAsString:@"SetAppOptions"];
	[pluginResult setKeepCallback:[NSNumber numberWithInteger:0]];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setAdOptions: (CDVInvokedUrlCommand*) command{
	NSDictionary *adOptions = [command.arguments objectAtIndex:0];
	if (adColonyAdOptions == nil)
		adColonyAdOptions = [[AdColonyAdOptions alloc] init];

	for (id key in adOptions) {
		@try {
			NSString *val =[adOptions objectForKey:key];

			if ([key caseInsensitiveCompare:@"confirmation_enabled"] == NSOrderedSame) {
				[adColonyAdOptions setShowPrePopup:[val boolValue]];
				continue;
			}
			if ([key caseInsensitiveCompare:@"results_enabled"] == NSOrderedSame) {
				[adColonyAdOptions setShowPostPopup:[val boolValue]];
				continue;
			}
		} @catch (NSException *ex) {
			NSLog(@"Invalid key/value pair :%@:%@",key,[adOptions objectForKey:key]);
		}
	}
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
													  messageAsString:@"SetAdOptions"];
	[pluginResult setKeepCallback:[NSNumber numberWithInteger:0]];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setUserMetaData: (CDVInvokedUrlCommand*) command{
	NSDictionary *metadata = [command.arguments objectAtIndex:0];
	if (adColonyUserMetaData == nil)
		adColonyUserMetaData = [[AdColonyUserMetadata alloc] init];
	for (id key in metadata) {
		NSString *val = [metadata objectForKey:key];
		@try {
			if ([key caseInsensitiveCompare:@"adc_age"] == NSOrderedSame) {
				[adColonyUserMetaData setUserAge:[val integerValue]];
				continue;
			}
			if ([key caseInsensitiveCompare:@"adc_gender"] == NSOrderedSame) {
				[adColonyUserMetaData setUserGender:val];
				continue;
			}
			if ([key caseInsensitiveCompare:@"adc_marital_status"] == NSOrderedSame) {
				[adColonyUserMetaData setUserMaritalStatus:val];
				continue;
			}
			if ([key caseInsensitiveCompare:@"adc_education"] == NSOrderedSame) {
				[adColonyUserMetaData setUserEducationLevel:val];
				continue;
			}
			if ([key caseInsensitiveCompare:@"adc_household_income"] == NSOrderedSame) {
				[adColonyUserMetaData setUserHouseholdIncome:[NSNumber numberWithDouble:[val doubleValue]]];
				continue;
			}
			if ([key caseInsensitiveCompare:@"adc_zip"] == NSOrderedSame) {
				[adColonyUserMetaData setUserZipCode:val];
				continue;
			}
			if ([key caseInsensitiveCompare:@"adc_interests"] == NSOrderedSame) {
				[adColonyUserMetaData setUserInterests:[NSArray arrayWithObject:val]];
				continue;
			}
			if ([key caseInsensitiveCompare:@"adc_longitude"] == NSOrderedSame) {
				[adColonyUserMetaData setUserLongitude:[NSNumber numberWithDouble:[val doubleValue]]];
				continue;
			}
			if ([key caseInsensitiveCompare:@"adc_latitude"] == NSOrderedSame) {
				[adColonyUserMetaData setUserLatitude:[NSNumber numberWithDouble:[val doubleValue]]];
				continue;
			}
		} @catch (NSException *ex) {
			NSLog(@"Invalid key/value pair :%@:%@",key,[metadata objectForKey:key]);
		}
	}
	if (adColonyAdOptions == nil)
		adColonyAdOptions = [[AdColonyAdOptions alloc] init];
	[adColonyAdOptions setUserMetadata:adColonyUserMetaData];
	[adColonyAppOptions setUserMetadata:adColonyUserMetaData];
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
													  messageAsString:@"SetUserMetaData"];
	[pluginResult setKeepCallback:[NSNumber numberWithInteger:0]];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void) requestInterstitialInZone: (CDVInvokedUrlCommand*) command{
	[self requestInterstitialInZone:[command.arguments objectAtIndex:0]
				 withCallbackId:command.callbackId];
}

- (void) requestInterstitial: (CDVInvokedUrlCommand*) command{
	[self requestInterstitialInZone:nil
					 withCallbackId:command.callbackId];
}

- (void) showWithPresentingViewController: (CDVInvokedUrlCommand*) command{
    if (!_adColonyInterstitial.expired){
        interstitialCallbackId = command.callbackId;
        [_adColonyInterstitial showWithPresentingViewController:self.viewController];
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
														  messageAsString:@"ShowWithPresentingViewController"];
		[pluginResult setKeepCallback:[NSNumber numberWithInteger:1]];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
    }
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
													  messageAsString:@"AdColonyRequestExpiring"];
	[pluginResult setKeepCallback:[NSNumber numberWithInteger:1]];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) registerRewardReceiver:(CDVInvokedUrlCommand *)command {
	//Set the zone's reward handler
	//This implementation is designed for client-side virtual currency without a server
	//It returns the reward as a JSON string to the Cordova Plugin

	if (_zone == nil) {
		_zone = [AdColony zoneForID:[_zoneIDs firstObject]];
		if (_zone == nil) {
			CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
															  messageAsString:[NSString stringWithFormat:@"Invalid Zone %@",[_zoneIDs firstObject]]];
			[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
			return;
		}
	}
	NSString *zoneID = _zone.identifier;

	UIView *webView = self.webView;
	id <CDVWebViewEngineProtocol> webViewEngine = self.webViewEngine;

	_zone.reward = ^(BOOL success, NSString *name, int amount) {

		// The Zone handler sends this back to the calling app
		if (success) {
			NSError *error = nil;
			NSDictionary *reward = [[NSDictionary alloc] initWithObjectsAndKeys:
									name, @"rewardname",
									[NSNumber numberWithInt:amount], @"rewardamount",
									zoneID, @"rewardzoneid",
									[NSNumber numberWithBool:success], @"success",
									nil];
			NSData *payload = [NSJSONSerialization dataWithJSONObject:reward
															   options:0
																 error:&error];
			NSString *JSONString = [[NSString alloc] initWithBytes:[payload bytes] length:[payload length] encoding:NSUTF8StringEncoding];
			NSString *rewardJS = [NSString stringWithFormat:@"javascript:%@(%@);", rewardCallBack, JSONString];

			if ([webView respondsToSelector:@selector(stringByEvaluatingJavaScriptFromString:)]) {
				[(UIWebView *)webView stringByEvaluatingJavaScriptFromString:rewardJS];
			} else {
				[webViewEngine evaluateJavaScript:rewardJS completionHandler:nil];
			}
		}
	};
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
													  messageAsString:@"RegisterRewardReceiver"];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//
// Actual AdColony Calls with standard parameters here
//
- (void) configureWithAppID:(NSString *)appID andZoneIDs:(NSArray<NSString *> *)zoneIDs withCallBackId:(NSString *)callbackId {
	[self setAppID:appID];
	[self setZoneIDs:zoneIDs];
	[AdColony configureWithAppID: _appID
						 zoneIDs: _zoneIDs
						 options: adColonyAppOptions
					  completion: ^(NSArray<AdColonyZone*>* zones) {
						  [self setZone:[zones firstObject]];
						  //If the application has been inactive for a while, our ad might have expired so let's add a check for a nil ad object
						  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBecameActive) name:UIApplicationDidBecomeActiveNotification object:nil];
						  if (callbackId) {
							  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
																				messageAsString:@"ConfigureSuccess"];
							  [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
							  // Once we're configured, get an initial ad
							  [self requestInterstitialInZone:[[zones firstObject] identifier]
										   withCallbackId:callbackId];
						  }
					  }];

}

- (void) requestInterstitialInZone:(NSString *) zone withCallbackId:(NSString *)callbackId {
	if ([zone class] == [NSNull class] || zone == nil)
		zone = [_zoneIDs firstObject];
	[AdColony requestInterstitialInZone: zone
								options: adColonyAdOptions
								success: ^(AdColonyInterstitial* ad) {
									ad.close = ^{
										if (callbackId) {
											CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
																							  messageAsString:@"AdColonyRequestClosed"];
											[pluginResult setKeepCallback:[NSNumber numberWithInteger:1]];
											[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
											[self requestInterstitialInZone: zone withCallbackId:callbackId];
										}
									};

									ad.expire = ^{
										_adColonyInterstitial = nil;
										CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
																						  messageAsString:@"AdColonyRequestExpiring"];
										[pluginResult setKeepCallback:[NSNumber numberWithInteger:0]]; // Should be the end of this callback
										[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
										if (callbackId) {
											// Request a new advert pre-emptively
											[self requestInterstitialInZone: zone withCallbackId:callbackId];
										}
									};

									_adColonyInterstitial = ad;
									if (callbackId) {
										CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
																						  messageAsString:@"AdColonyRequestFilled"];
										[pluginResult setKeepCallback:[NSNumber numberWithInteger:1]];
										[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
									}
								}
								failure: ^(AdColonyAdRequestError* error){
									if (callbackId) {
										CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
																						  messageAsString:[error localizedDescription]];
										[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
									}
								}
	 ];
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT
													  messageAsString:@"AdColonyRequestSubmitted"];
	[pluginResult setKeepCallback:[NSNumber numberWithInteger:1]];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

#pragma mark - Event Handlers

-(void)onBecameActive {
	//If our ad has expired, request a new interstitial
	if (!_adColonyInterstitial) {
		[self requestInterstitialInZone:[_zoneIDs objectAtIndex:0]  withCallbackId:nil];
	}
}

@end
