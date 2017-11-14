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

	/**
	* @brief A Cordova plugin for AdColony
	* @author Ferdi Ladeira SmartMobiWare Ltd
	*
	*/

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
