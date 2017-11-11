# cordova-plugin-adcolony
AdColony ads for Apache Cordova

iOS SDK version is 3.2.1.0 64bit production
Android SDK version is 3.2.1

# Install plugin

```
$ cordova plugin add cordova-plugin-adcolony --variable APP_ID=xxxx --variable ZONE_ID=xxxx
```

For the Android Plugin, use the following demo APP_ID and ZONE_ID:
cordova plugin add cordova-plugin-adcolony --variable APP_ID=app185a7e71e1714831a49ec7 --variable ZONE_ID=vz1fd5a8b2bf6841a0a4b826

For the iOS Plugin, use the following demo APP_ID and ZONE_ID:
cordova plugin add cordova-plugin-adcolony --variable APP_ID=appbdee68ae27024084bb334a --variable ZONE_ID=vzf8e4e97704c4445c87504e

If you use both, then you need to use the configureWithAppID method and pass the correct variables in your code
# Methods

#### AdColony.configure()  
Initial method wich connects to AdColony using the variables defined in the config.xml file.  

#### AdColony.configureWithAppID(appID, zoneIDs, options)  
Initial method wich connects to AdColony.  
(string) appID - the appID of your app in AdColony Dashboard  
([strings]) zoneIDs - array of your ad zones ids  
options - app options defined [here](https://adcolony-www-common.s3.amazonaws.com/Appledoc/3.1.0/Classes/AdColonyAppOptions.html)

#### AdColony.setAppOptions(options)  
Set App Options.
options - JSON Array typically with ONE element a JSON object with the options. Options defined [here](https://adcolony-www-common.s3.amazonaws.com/Appledoc/3.1.0/Classes/AdColonyAppOptions.html)

#### AdColony.setAdOptions(options)  
Set Ad options.
options - JSON Array typically with ONE element a JSON object with the options. Options defined [here](https://adcolony-www-common.s3.amazonaws.com/Appledoc/3.1.0/Classes/AdColonyAdOptions.html)

#### AdColony.setUserMetaData(metadata)  
Set User meta-data for ad retrieval. Calling this sets the user metadata for all future ad requests 
metadata - JSON Array typically with ONE element a JSON object with the user meta-data. User meta-data defined [here](https://adcolony-www-common.s3.amazonaws.com/Appledoc/3.1.0/Classes/AdColonyUserMetadata.html)


#### AdColony.requestInterstitialInZone(zoneID)  
Request ad with given zoneID

#### AdColony.requestInterstitialInZone()
Request ad with current zoneID

#### AdColony.registerRewardReceiver(rewardHandler)  
Register the given Javascript method to handle rewards (Demo uses 'AdColony.onRewardReceived)

#### AdColony.showWithPresentingViewController()
After ad is loaded you can show it by calling this method.

# Events

```
document.addEventListener('ConfigureSuccess', () => {  
  console.log('AdColonyPlugin: Configuration successfully completed.');
});
```
```
document.addEventListener('AdColonyRequestSubmitted', () => {
 console.log('AdColonyPlugin: Interstitial ad requested.');
});
```
```
document.addEventListener('AdColonyRequestFilled', () => {
 console.log('AdColonyPlugin: Interstitial ad loaded.');
});
```
```
document.addEventListener('AdColonyRequestNotFilled', (error) => {
  console.log('AdColonyPlugin: Request interstitial failed with error: ' + error);
});
```
```
document.addEventListener('AdColonyRequestOpened', () => {
  console.log('AdColonyPlugin: Interstitial ad opened.');
});
```
```
document.addEventListener('AdColonyRequestClosed', () => {
  console.log('AdColonyPlugin: Interstitial ad closed.');
});
```
```
document.addEventListener('AdColonyRequestExpiring', () => {
  console.log('AdColonyPlugin: Interstitial ad expiring.');
});
```

# Example

```
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

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QVU9KQVD2VZML)
