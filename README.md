# cordova-plugin-adcolony
AdColony ads for Apache Cordova

iOS SDK version is 3.0.4.1

WARNING: This plugin available only for iOS.

# Install plugin

```
$ cordova plugin add cordova-plugin-adcolony
```

# Methods

#### AdColony.configureWithAppID(appID, zoneIDs, options)  
Initial method wich connects to AdColony.  
(string) appID - the appID of your app in AdColony Dashboard  
([strings]) zoneIDs - array of your ad zones ids  
options - app options defined [here](https://adcolony-www-common.s3.amazonaws.com/Appledoc/3.1.0/Classes/AdColonyAppOptions.html) - I will implement this in next updates, now it should be null.

#### AdColony.requestInterstitialInZone(zoneID)  
Request ad with current zoneID

#### AdColony.showWithPresentingViewController()
After ad is loaded you can show it by calling this method.

# Events

```
document.addEventListener('Configuration successfully completed', (data) => {  
  console.log('AdColonyPlugin: Configuration successfully completed.');
});
```
```
document.addEventListener('Interstitial ad loaded', (data) => {
 console.log('AdColonyPlugin: Interstitial ad loaded.');
});
```
```
document.addEventListener('Request interstitial failed with error', (error) => {
  console.log('AdColonyPlugin: Request interstitial failed with error: ' + error);
});
```
```
document.addEventListener('Interstitial ad closed', (data) => {
  console.log('AdColonyPlugin: Interstitial ad closed.');
});
```

# Example

```
let appID = 'AdColonyAppID';
let zoneIDs = ['myZoneID1', 'myZoneID2'];
let options = null;

AdColony.configureWithAppID(appID, zoneIDs, options);

document.addEventListener('Configuration successfully completed', (data) => {  
   AdColony.requestInterstitialInZone(zoneIDs[0]);
});

document.addEventListener('Interstitial ad loaded', (data) => {
 AdColony.showWithPresentingViewController();
});

document.addEventListener('Interstitial ad closed', (data) => {
  console.log('AdColonyPlugin: Interstitial ad closed.');
});

document.addEventListener('Request interstitial failed with error', (error) => {
  console.log('AdColonyPlugin: Request interstitial failed with error: ' + error);
});

```

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QVU9KQVD2VZML)