var AdColony = {
  configureWithAppID: function(appID, zondeIDs, options){
    cordova.exec(function(result){
      if (result === "Configuration successfully completed"){
        cordova.fireDocumentEvent(result ,{});
      }
    }, null, 'AdColonyPlugin', 'configureWithAppID', [appID, zondeIDs, options]);
  },
  requestInterstitialInZone: function(zoneID){
    cordova.exec(function(result){
      cordova.fireDocumentEvent(result, {});             
    }, function(error){
      cordova.fireDocumentEvent('Request interstitial failed with error', error);             
    }, 'AdColonyPlugin', 'requestInterstitialInZone', [zoneID]);
  },
  showWithPresentingViewController: function(){
    cordova.exec(function(result){
      cordova.fireDocumentEvent(result, {});   
    }, null, 'AdColonyPlugin', 'showWithPresentingViewController', []);
  }
};

module.exports = AdColony;
