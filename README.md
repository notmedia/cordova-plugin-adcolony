![AdColony](https://support.aerserv.com/hc/en-us/article_attachments/201552304/AdColony1.png)

Allows you to integrate AdColony monetization platform with your Apache Cordova app.

### Requirements

#### AdColony framework versions:

iOS SDK version is 4.1.0

Android SDK version is 4.1.0

Please make sure that you read the AdColony Project setup guides for both Android and iOS if you're building on both platforms.

All the documentation is available from here:

[AdColony Android SDK](https://github.com/AdColony/AdColony-Android-SDK)

[AdColony iOS SDK](https://github.com/AdColony/AdColony-iOS-SDK)

This update integrates AdColony using a podspec in the plugin definition

# Install plugin

```
$ cordova plugin add cordova-plugin-adcolony
```

See the AdColonyDemoApp code for how to configure and provide an APP\_ID and a ZONE\_ID within your JavaScript

### Android

You will need to manually merge the contents of the file platforms/android/proguard-adcolony.txt to your existing project proguard-project.txt file (I need to figure out how to do this via a script still)

### iOS

Please note that you must follow steps 2 onwards in the AdColony Project Setup notes (https://github.com/AdColony/AdColony-iOS-SDK/wiki/Project-Setup)

# Methods

#### AdColony.configureWithAppID(appID, zoneIDs, options)  
*Initial method wich connects to AdColony.*

#### AdColony.setAppOptions(options)  
*Set App Options.*

| Argument | Type    | Description          |
|----------|--------|-----------------------|
| options  | Object |  JSON Array typically with ONE element a JSON object with the [app options](https://adcolony-www-common.s3.amazonaws.com/Appledoc/3.1.0/Classes/AdColonyAppOptions.html)|

#### AdColony.configureWithAppID(appID, zoneIDs, options)  
Initial method wich connects to AdColony.  

| Argument | Type    | Description          |
|----------|--------|-----------------------|
| appID    | string |  the appID of your app in AdColony Dashboard |
| zoneIDs    | [strings] |  array of your ad zones ids |
| options    | Object |  arapp options defined [here](https://adcolony-www-common.s3.amazonaws.com/Appledoc/4.1.0/Classes/AdColonyAppOptions.html) |


#### AdColony.setAppOptions(options)  
Set App Options.

| Argument | Type    | Description          |
|----------|--------|-----------------------|
| options    | Object |  JSON Array typically with ONE element a JSON object with the options. Options defined [here](https://adcolony-www-common.s3.amazonaws.com/Appledoc/4.1.0/Classes/AdColonyAppOptions.html) |


Note that I use the following strings from the Android SDK for cross-platform compatability

```
orientation
app_orientation
origin_store
disable_logging
user_id
gdpr_required
consent_string
test_mode
multi_window_enabled
mediation_network
mediation_network_version
plugin
plugin_version
keep_screen_on
```

#### AdColony.setAdOptions(options)  
Set Ad options.
options - JSON Array typically with ONE element a JSON object with the options. Options defined [here](https://adcolony-www-common.s3.amazonaws.com/Appledoc/4.1.0/Classes/AdColonyAdOptions.html)

#### AdColony.setUserMetaData(metadata)  
Set User meta-data for ad retrieval. Calling this sets the user metadata for all future ad requests 
metadata - JSON Array typically with ONE element a JSON object with the user meta-data. User meta-data defined [here](https://adcolony-www-common.s3.amazonaws.com/Appledoc/4.1.0/Classes/AdColonyUserMetadata.html)

| Argument | Type    | Description          |
|----------|--------|-----------------------|
| metadata  | Object | JSON Array typically with ONE element a JSON object with the user [meta-data](https://adcolony-www-common.s3.amazonaws.com/Appledoc/3.1.0/Classes/AdColonyUserMetadata.html)|

#### AdColony.requestInterstitialInZone(zoneID)  
*Request ad with given zoneID*

| Argument | Type    | Description          |
|----------|-------- |-----------------------|
| zoneId  | String | Your ad zone id|

#### AdColony.requestInterstitial()
*Request ad with current zoneID*

#### AdColony.registerRewardReceiver(rewardHandler)  
*Register the given Javascript method to handle rewards (Demo uses 'AdColony.onRewardReceived'*

| Argument | Type    | Description          |
|----------|-------- |-----------------------|
| rewardHandler  | Function | Reward handler|

#### AdColony.showWithPresentingViewController()
*After ad is loaded you can show it by calling this method.*

## Events

```js
document.addEventListener('ConfigureSuccess', () => {  
  console.log('AdColonyPlugin: Configuration successfully completed.');
});

document.addEventListener('AdColonyRequestSubmitted', () => {
 console.log('AdColonyPlugin: Interstitial ad requested.');
});

document.addEventListener('AdColonyRequestFilled', () => {
 console.log('AdColonyPlugin: Interstitial ad loaded.');
});

document.addEventListener('AdColonyRequestNotFilled', (error) => {
  console.log('AdColonyPlugin: Request interstitial failed with error: ' + error);
});

document.addEventListener('AdColonyRequestOpened', () => {
  console.log('AdColonyPlugin: Interstitial ad opened.');
});

document.addEventListener('AdColonyRequestClosed', () => {
  console.log('AdColonyPlugin: Interstitial ad closed.');
});

document.addEventListener('AdColonyRequestExpiring', () => {
  console.log('AdColonyPlugin: Interstitial ad expiring.');
});
```

## Example

```js
let appID = 'AdColonyAppID';
let zoneIDs = ['myZoneID1', 'myZoneID2'];
let options = null;

AdColony.configureWithAppID(appID, zoneIDs, options);

document.addEventListener('ConfigureSuccess', () => {  
   AdColony.requestInterstitialInZone(zoneIDs[0]);
});

document.addEventListener('AdColonyRequestFilled', () => {
 AdColony.showWithPresentingViewController();
});

document.addEventListener('AdColonyRequestClosed', () => {
  console.log('AdColonyPlugin: Interstitial ad closed.');
});

document.addEventListener('AdColonyRequestNotFilled', (error) => {
  console.log('AdColonyPlugin: Request interstitial failed with error: ' + error);
});

```

Also, [Ferdil](https://github.com/ferdil) created great full [working demo](https://github.com/ferdil/AdColonyCordovaDemo).

## Thanks
> [Ferdil](https://github.com/ferdil) for the big [PR #1](https://github.com/notmedia/cordova-plugin-adcolony/pull/1)


If you have saved some time using our work, do consider donating us something :) All donations I'll devide between all contributors.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.me/notmedia)
