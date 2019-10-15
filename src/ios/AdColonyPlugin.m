/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

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
- (void) configureWithAppID: (CDVInvokedUrlCommand*) command{
	[self.commandDelegate runInBackground:^{

	self->rewardCallBackReady = false;
	self->adColonyAppOptions = [AdColony getAppOptions];
	if (self->adColonyAppOptions == nil)
		self->adColonyAppOptions = [[AdColonyAppOptions alloc] init];
	self->adColonyAdOptions = [[AdColonyAdOptions alloc] init];
	self->adColonyUserMetaData = [[AdColonyUserMetadata alloc] init];
		@try {
			[self setAppID:[command.arguments objectAtIndex:0]];
			[self setZoneIDs:[NSArray arrayWithObjects:[command.arguments objectAtIndex:1], nil]];
			[self processAppOptions:[[command.arguments objectAtIndex:2] objectAtIndex:0]];
		} @catch (NSException *e) {
			NSLog(@"Invalid configuration parameter");
		}

        [self configureWithAppID:self->_appID
                      andZoneIDs:self->_zoneIDs
				  withCallBackId:command.callbackId];

	}];
}

- (void) setAppOptions: (CDVInvokedUrlCommand*) command{
	[self.commandDelegate runInBackground:^{

		NSDictionary *appOptions = [command.arguments objectAtIndex:0];
        if (self->adColonyAppOptions == nil)
            self->adColonyAppOptions = [AdColony getAppOptions];
        if (self->adColonyAppOptions == nil)
            self->adColonyAppOptions = [[AdColonyAppOptions alloc] init];
		[self processAppOptions:appOptions];
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
														  messageAsString:@"SetAppOptions"];
		[pluginResult setKeepCallback:[NSNumber numberWithInteger:0]];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void) setAdOptions: (CDVInvokedUrlCommand*) command{
	[self.commandDelegate runInBackground:^{

		NSDictionary *adOptions = [command.arguments objectAtIndex:0];
        if (self->adColonyAdOptions == nil)
            self->adColonyAdOptions = [[AdColonyAdOptions alloc] init];

		for (id key in adOptions) {
			@try {
				NSString *val =[adOptions objectForKey:key];

				if ([key caseInsensitiveCompare:@"confirmation_enabled"] == NSOrderedSame) {
                    [self->adColonyAdOptions setShowPrePopup:[val boolValue]];
					continue;
				}
				if ([key caseInsensitiveCompare:@"results_enabled"] == NSOrderedSame) {
                    [self->adColonyAdOptions setShowPostPopup:[val boolValue]];
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
	}];
}

/**
 * @brief Sets User meta-data.
 *
 * Borrows heavily from the AdColony Android SDK for meaningful key names
 * 
 **/
- (void) setUserMetaData: (CDVInvokedUrlCommand*) command{
	[self.commandDelegate runInBackground:^{

		NSDictionary *metadata = [command.arguments objectAtIndex:0];
        if (self->adColonyUserMetaData == nil)
            self->adColonyUserMetaData = [[AdColonyUserMetadata alloc] init];
		for (id key in metadata) {
			NSString *val = [metadata objectForKey:key];
			@try {
				if ([key caseInsensitiveCompare:@"adc_age"] == NSOrderedSame) {
                    [self->adColonyUserMetaData setUserAge:[val integerValue]];
					continue;
				}
				if ([key caseInsensitiveCompare:@"adc_gender"] == NSOrderedSame) {
                    [self->adColonyUserMetaData setUserGender:val];
					continue;
				}
				if ([key caseInsensitiveCompare:@"adc_marital_status"] == NSOrderedSame) {
                    [self->adColonyUserMetaData setUserMaritalStatus:val];
					continue;
				}
				if ([key caseInsensitiveCompare:@"adc_education"] == NSOrderedSame) {
                    [self->adColonyUserMetaData setUserEducationLevel:val];
					continue;
				}
				if ([key caseInsensitiveCompare:@"adc_household_income"] == NSOrderedSame) {
                    [self->adColonyUserMetaData setUserHouseholdIncome:[NSNumber numberWithDouble:[val doubleValue]]];
					continue;
				}
				if ([key caseInsensitiveCompare:@"adc_zip"] == NSOrderedSame) {
                    [self->adColonyUserMetaData setUserZipCode:val];
					continue;
				}
				if ([key caseInsensitiveCompare:@"adc_interests"] == NSOrderedSame) {
                    [self->adColonyUserMetaData setUserInterests:[NSArray arrayWithObject:val]];
					continue;
				}
				if ([key caseInsensitiveCompare:@"adc_longitude"] == NSOrderedSame) {
                    [self->adColonyUserMetaData setUserLongitude:[NSNumber numberWithDouble:[val doubleValue]]];
					continue;
				}
				if ([key caseInsensitiveCompare:@"adc_latitude"] == NSOrderedSame) {
                    [self->adColonyUserMetaData setUserLatitude:[NSNumber numberWithDouble:[val doubleValue]]];
					continue;
				}
			} @catch (NSException *ex) {
				NSLog(@"Invalid key/value pair :%@:%@",key,[metadata objectForKey:key]);
			}
		}
        if (self->adColonyAdOptions == nil)
            self->adColonyAdOptions = [[AdColonyAdOptions alloc] init];
        [self->adColonyAdOptions setUserMetadata:self->adColonyUserMetaData];
        [self->adColonyAppOptions setUserMetadata:self->adColonyUserMetaData];
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
														  messageAsString:@"SetUserMetaData"];
		[pluginResult setKeepCallback:[NSNumber numberWithInteger:0]];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void) requestInterstitialInZone: (CDVInvokedUrlCommand*) command{
	[self.commandDelegate runInBackground:^{

		[self requestInterstitialInZone:[command.arguments objectAtIndex:0]
						 withCallbackId:command.callbackId];
	}];
}

- (void) requestInterstitial: (CDVInvokedUrlCommand*) command{
	[self.commandDelegate runInBackground:^{

        [self requestInterstitialInZone:[self->_zoneIDs objectAtIndex:0]
						 withCallbackId:command.callbackId];

	}];
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

	[self.commandDelegate runInBackground:^{

        if (self->_zone == nil) {
            self->_zone = [AdColony zoneForID:[self->_zoneIDs firstObject]];
            if (self->_zone == nil) {
				CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                  messageAsString:[NSString stringWithFormat:@"Invalid Zone %@",[self->_zoneIDs firstObject]]];
				[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
				return;
			}
		}
        NSString *zoneID = self->_zone.identifier;

		UIView *webView = self.webView;
		id <CDVWebViewEngineProtocol> webViewEngine = self.webViewEngine;

        self->_zone.reward = ^(BOOL success, NSString *name, int amount) {

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
	}];
}

//
// Actual AdColony Calls with standard parameters here
//
- (void) configureWithAppID:(NSString *)appID andZoneIDs:(NSArray<NSString *> *)zoneIDs withCallBackId:(NSString *)callbackId {
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
                                        self->_adColonyInterstitial = nil;
										CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
																						  messageAsString:@"AdColonyRequestExpiring"];
										[pluginResult setKeepCallback:[NSNumber numberWithInteger:0]]; // Should be the end of this callback
										[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
										if (callbackId) {
											// Request a new advert pre-emptively
											[self requestInterstitialInZone: zone withCallbackId:callbackId];
										}
									};

                                    self->_adColonyInterstitial = ad;
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

- (void) processAppOptions:(NSDictionary *) appOptions {
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
        if ([key caseInsensitiveCompare:@"gdpr_required"] == NSOrderedSame) {
            [adColonyAppOptions setGdprRequired:val];
            continue;
        }
        if ([key caseInsensitiveCompare:@"consent_string"] == NSOrderedSame) {
            [adColonyAppOptions setGdprConsentString:val];
            continue;
        }

		@try {
			[adColonyAppOptions setValue:val forKey:key];
		} @catch (NSException *ex) {

		}
	}
	[AdColony setAppOptions:adColonyAppOptions];

}
#pragma mark - Event Handlers

-(void)onBecameActive {
	//If our ad has expired, request a new interstitial
	if (!_adColonyInterstitial) {
		[self requestInterstitialInZone:[_zoneIDs objectAtIndex:0]  withCallbackId:nil];
	}
}

@end
