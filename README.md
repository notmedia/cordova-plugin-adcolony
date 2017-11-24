![AdColony](https://support.aerserv.com/hc/en-us/article_attachments/201552304/AdColony1.png)

Allows you to integrate AdColony monetization platform with your Apache Cordova app.

### Requirements
#### AdColony framework versions:

>iOS SDK version is 3.2.1.0 64bit production

>Android SDK version is 3.2.1

Please make sure that you read the AdColony Project setup guides for both Android and iOS if you're building on both platforms.

All the documentation is available from here:

[AdColony Android SDK 3](https://github.com/AdColony/AdColony-Android-SDK-3)

[AdColony iOS SDK 3](https://github.com/AdColony/AdColony-iOS-SDK-3)

## Installation

```
$ cordova plugin add cordova-plugin-adcolony
```

## Methods

#### AdColony.configureWithAppID(appID, zoneIDs, options)  
*Initial method wich connects to AdColony.*

| Argument | Type    | Description          |
|----------|--------|-----------------------|
| appID  | String |  App id in AdColony Dashboard |
| zoneIDs  | [String] | Ad zones ids |
| options  | String | [App options](https://adcolony-www-common.s3.amazonaws.com/Appledoc/3.1.0/Classes/AdColonyAppOptions.html)|

#### AdColony.setAppOptions(options)  
*Set App Options.*

| Argument | Type    | Description          |
|----------|--------|-----------------------|
| options  | Object |  JSON Array typically with ONE element a JSON object with the [app options](https://adcolony-www-common.s3.amazonaws.com/Appledoc/3.1.0/Classes/AdColonyAppOptions.html)|

#### AdColony.setAdOptions(options)  
*Set Ad options.*

| Argument | Type    | Description          |
|----------|--------|-----------------------|
| options  | Object | JSON Array typically with ONE element a JSON object with the [ad options](https://adcolony-www-common.s3.amazonaws.com/Appledoc/3.1.0/Classes/AdColonyAdOptions.html)|


#### AdColony.setUserMetaData(metadata)  
*Set User meta-data for ad retrieval. Calling this sets the user metadata for all future ad requests*

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
