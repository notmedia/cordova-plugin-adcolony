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
 * Defines the following JavaScript methods that can be called from within Cordova

 NB. See the AdColony SDK for valid values for parameters

 configure() - Configure the App using the APP_ID and ZONE_ID in the Cordova config.xml file
 configureWithAppID(appID, ZoneIDs, options) - Configure with the given AppID and Array ZoneIDs
 setAppOptions(appOptions) - Set App Options
 setAdOptions(adOptions) - set Ad options
 setUserMetaData(metadata) - set Ad User meta-data
 requestInterstitialInZone(zoneID) - Get a video in the given zone
 requestInterstitial() - Get a video in the current zone
 showWithPresentingViewController() - Display a video
 registerRewardReceiver(rewardHandler) - Register the given JavaScript method to handle rewards

 **/
cordova.define("cordova-plugin-adcolony.AdColony", function(require, exports, module) {
    var AdColony = {

        configureWithAppID: function(appID, zoneIDs, options) {
            cordova.exec(function(result) {
                if (result === "ConfigureSuccess") {
                    cordova.fireDocumentEvent(result, {});
                }
            }, null, 'AdColonyPlugin', 'configureWithAppID', [appID, zoneIDs, options]);
        },
        setAppOptions: function(appOptions) {
            cordova.exec(function(result) {
                if (result === "SetAppOptions") {
                    cordova.fireDocumentEvent(result, {});
                }
            }, null, 'AdColonyPlugin', 'setAppOptions', [appOptions]);
        },
        setAdOptions: function(adOptions) {
            cordova.exec(function(result) {
                if (result === "SetAdOptions") {
                    cordova.fireDocumentEvent(result, {});
                }
            }, null, 'AdColonyPlugin', 'setAdOptions', [adOptions]);
        },
        setUserMetaData: function(metadata) {
            cordova.exec(function(result) {
                if (result === "SetUserMetaData") {
                    cordova.fireDocumentEvent(result, {});
                }
            }, null, 'AdColonyPlugin', 'setUserMetaData', [metadata]);
        },
        requestInterstitialInZone: function(zoneID) {
            cordova.exec(function(result) {
                cordova.fireDocumentEvent(result, {});
            }, function(error) {
                cordova.fireDocumentEvent('AdColonyRequestNotFilled', error);
            }, 'AdColonyPlugin', 'requestInterstitialInZone', [zoneID]);
        },
        requestInterstitial: function() {
            cordova.exec(function(result) {
                cordova.fireDocumentEvent(result, {});
            }, function(error) {
                cordova.fireDocumentEvent('AdColonyRequestNotFilled', error);
            }, 'AdColonyPlugin', 'requestInterstitial', []);
        },
        showWithPresentingViewController: function() {
            cordova.exec(function(result) {
                cordova.fireDocumentEvent(result, {});
            }, null, 'AdColonyPlugin', 'showWithPresentingViewController', []);
        },
        registerRewardReceiver: function() {
            cordova.exec(function(result) {
                cordova.fireDocumentEvent(result, {});
            }, null, 'AdColonyPlugin', 'registerRewardReceiver', []);
        }
    };

    module.exports = AdColony;

});