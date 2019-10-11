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

var AdColony = {
	configureWithAppID: function (appID, zoneIDs, options) {
		cordova.exec(function (result) {
			if (result === "ConfigureSuccess") {
				cordova.fireDocumentEvent(result, {});
			}
		}, null, 'AdColonyPlugin', 'configureWithAppID', [appID, zoneIDs, options]);
	},
	setAppOptions: function (appOptions) {
		cordova.exec(function (result) {
			if (result === "SetAppOptions") {
				cordova.fireDocumentEvent(result, {});
			}
		}, null, 'AdColonyPlugin', 'setAppOptions', [appOptions]);
	},
	setAdOptions: function (adOptions) {
		cordova.exec(function (result) {
			if (result === "SetAdOptions") {
				cordova.fireDocumentEvent(result, {});
			}
		}, null, 'AdColonyPlugin', 'setAdOptions', [adOptions]);
	},
	setUserMetaData: function (metadata) {
		cordova.exec(function (result) {
			if (result === "SetUserMetaData") {
				cordova.fireDocumentEvent(result, {});
			}
		}, null, 'AdColonyPlugin', 'setUserMetaData', [metadata]);
	},
	requestInterstitialInZone: function (zoneID) {
		cordova.exec(function (result) {
			cordova.fireDocumentEvent(result, {});
		}, function (error) {
			cordova.fireDocumentEvent('AdColonyRequestNotFilled', error);
		}, 'AdColonyPlugin', 'requestInterstitialInZone', [zoneID]);
	},
	requestInterstitial: function () {
		cordova.exec(function (result) {
			cordova.fireDocumentEvent(result, {});
		}, function (error) {
			cordova.fireDocumentEvent('AdColonyRequestNotFilled', error);
		}, 'AdColonyPlugin', 'requestInterstitial', []);
	},
	showWithPresentingViewController: function () {
		cordova.exec(function (result) {
			cordova.fireDocumentEvent(result, {});
		}, null, 'AdColonyPlugin', 'showWithPresentingViewController', []);
	},
	registerRewardReceiver: function () {
		cordova.exec(function (result) {
			cordova.fireDocumentEvent(result, {});
		}, null, 'AdColonyPlugin', 'registerRewardReceiver', []);
	}
};

module.exports = AdColony;
