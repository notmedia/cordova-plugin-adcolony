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
  * Added License
  *
  */

package com.adcolony.plugin;

import android.content.pm.PackageManager;
import android.util.Log;

import org.apache.cordova.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.adcolony.sdk.*;

import java.util.Iterator;

public class AdColonyPlugin extends CordovaPlugin {

	final private String TAG = "ACPlugin";

	private static CordovaWebView gWebView;

	private String APP_ID = "app185a7e71e1714831a49ec7"; // Demo Android APP_ID
	private String ZONE_ID = "vz1fd5a8b2bf6841a0a4b826"; // Demo Android ZONE_ID

	private Boolean rewardCallBackReady = false;
	private String rewardCallBack = "AdColony.onRewardReceived";
	private AdColonyInterstitial ad;
	private AdColonyInterstitialListener listener;
	private AdColonyAdOptions ad_options = null;
	private AdColonyAppOptions app_options = null;
	private AdColonyReward lastReward = null;
	private JSONArray requestArgs;
	private CallbackContext requestCallbackContext;


	public AdColonyPlugin() {
	}

	public void onRequestPermissionResult(int requestCode, String[] permissions,
										  int[] grantResults) throws JSONException {
		for (int r : grantResults) {
			if (r == PackageManager.PERMISSION_DENIED) {
				this.requestCallbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "Permission Denied"));
				return;
			}
		}
		switch (requestCode) {
			default:
				break;
		}
	}

	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		super.initialize(cordova, webView);
		gWebView = webView;
		Log.d(TAG, "AdColonyPlugin initialize");

		/*
		 * Set up listener for interstitial ad callbacks. You only need to implement the callbacks
		 * that you care about. The only required callback is onRequestFilled, as this is the only
		 * way to get an ad object.
		 */
		listener = new AdColonyInterstitialListener() {
			/** Ad passed back in request filled callback, ad can now be shown */
			@Override
			public void onRequestFilled(AdColonyInterstitial ad) {
				Log.d(TAG, "AdColonyInterstitialListener onRequestFilled");
				AdColonyPlugin.this.ad = ad;
				PluginResult reqResult = new PluginResult(PluginResult.Status.OK, "AdColonyRequestFilled");
				reqResult.setKeepCallback(true);
				requestCallbackContext.sendPluginResult(reqResult);
			}

			/** Ad request was not filled */
			@Override
			public void onRequestNotFilled(AdColonyZone zone) {
				Log.d(TAG, " AdColonyInterstitialListener onRequestNotFilled");
				PluginResult reqResult = new PluginResult(PluginResult.Status.ERROR, "AdColonyRequestNotFilled");
				reqResult.setKeepCallback(false);
				requestCallbackContext.sendPluginResult(reqResult);
			}

			/** Ad opened, reset UI to reflect state change */
			@Override
			public void onOpened(AdColonyInterstitial ad) {
				Log.d(TAG, "AdColonyInterstitialListener onOpened");
				PluginResult reqResult = new PluginResult(PluginResult.Status.OK, "AdColonyRequestOpened");
				reqResult.setKeepCallback(true);
				requestCallbackContext.sendPluginResult(reqResult);
			}

			/** Ad closed, reset UI to reflect state change */
			@Override
			public void onClosed(AdColonyInterstitial ad) {
				Log.d(TAG, "AdColonyInterstitialListener onClosed");
				PluginResult reqResult = new PluginResult(PluginResult.Status.OK, "AdColonyRequestClosed");
				reqResult.setKeepCallback(true);
				requestCallbackContext.sendPluginResult(reqResult);
			}

			/** Request a new ad if ad is expiring */
			@Override
			public void onExpiring(AdColonyInterstitial ad) {
				Log.d(TAG, "AdColonyInterstitialListener onExpiring");
				AdColony.requestInterstitial(ZONE_ID, this, ad_options);
				PluginResult reqResult = new PluginResult(PluginResult.Status.OK, "AdColonyRequestExpiring");
				reqResult.setKeepCallback(false);
				requestCallbackContext.sendPluginResult(reqResult);
			}
		};
	}

	/**
	 * Entry point for Cordova calls to the plugin
	 *
	 * @param action          The action to execute.
	 * @param args            The exec() arguments.
	 * @param callbackContext The callback context used when calling back into JavaScript.
	 * @return true if handled
	 * @throws JSONException - NB the parameter args must be a JSONARRAY !
	 */
	public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {

		Log.d(TAG, "AdColonyPlugin execute: " + action);

		try {
			if (action.equals("configureWithAppID")) {
				requestArgs = args;
				cordova.getThreadPool().execute(new Runnable() {
					public void run() {
						try {
							Log.d(TAG, "configure: " + requestArgs);
							// Configure AdColony so that cached ads can be available as soon as possible.
							// Use given APP_ID and ZONE_ID
							APP_ID = args.getString(0);
							ZONE_ID = args.getString(1);
							JSONArray jsonOptions = args.getJSONArray(2);
							AdColony.configure(
									cordova.getActivity(),
									APP_ID, ZONE_ID);
							if (jsonOptions != null) {
								processJSONOptions(jsonOptions.getJSONObject(0));
							}
							callbackContext.success("ConfigureSuccess");
						} catch (Exception ex) {
							callbackContext.error(ex.getMessage());
						}
					}
				});
				return true;
			}
			if (action.equals("setAdOptions")) {
				cordova.getThreadPool().execute(new Runnable() {
					public void run() {
						try {
							Log.d(TAG, "setAdOptions: " + args);
							setAdOptions(args, callbackContext);
						} catch (Exception ex) {
							callbackContext.error(ex.getMessage());
						}
					}
				});
				return true;
			}
			if (action.equals("setAppOptions")) {
				cordova.getThreadPool().execute(new Runnable() {
					public void run() {
						try {
							Log.d(TAG, "setAppOptions: " + args);
							setAppOptions(args, callbackContext);
						} catch (Exception ex) {
							callbackContext.error(ex.getMessage());
						}
					}
				});
				return true;
			}
			if (action.equals("setUserMetaData")) {
				cordova.getThreadPool().execute(new Runnable() {
					public void run() {
						try {
							Log.d(TAG, "setUserMetaData: " + args);
							setUserMetaData(args, callbackContext);
						} catch (Exception ex) {
							callbackContext.error(ex.getMessage());
						}
					}
				});
				return true;
			}
			if (action.equals("requestInterstitialInZone")) {
				//Retain the Arguments and the callback context
				requestArgs = args;
				requestCallbackContext = callbackContext; // Retain for callback when the ad is loaded
				cordova.getThreadPool().execute(new Runnable() {
					public void run() {
						try {
							String zoneID = args.getString(0);
							requestInterstitialInZone(zoneID);
						} catch (Exception ex) {
							callbackContext.error(ex.getMessage());
						}
					}
				});
				return true;
			}
			if (action.equals("requestInterstitial")) {
				//Retain the Arguments and the callback context
				requestCallbackContext = callbackContext; // Retain for callback when the ad is loaded
				cordova.getThreadPool().execute(new Runnable() {
					public void run() {
						try {
							requestInterstitialInZone();
						} catch (Exception ex) {
							callbackContext.error(ex.getMessage());
						}
					}
				});
				return true;
			}
			if (action.equals("showWithPresentingViewController")) {
				// Need to run this on the UI Thread
				cordova.getActivity().runOnUiThread(new Runnable() {
					public void run() {
						try {
							Log.d(TAG, "showWithPresentingViewController: " + args);
							if (ad == null || ad.isExpired()) {
								requestInterstitialInZone();
								callbackContext.error("No Ad available");
								return;
							}
							ad.show();
							callbackContext.success("ShowWithPresentingViewController");
						} catch (Exception e) {
							callbackContext.error(e.getMessage());
						}
					}
				});
				return true;
			}
			if (action.equals("registerRewardReceiver")) {
				// Create and set a reward listener
				AdColony.setRewardListener(new AdColonyRewardListener() {
					@Override
					public void onReward(AdColonyReward reward) {
						Log.d(TAG, "onReward");
						if (rewardCallBackReady)
							sendReward(reward);
					}
				});

				rewardCallBackReady = true;
				if (args.length()>0)
					rewardCallBack = args.get(0).toString();
				cordova.getActivity().runOnUiThread(new Runnable() {
					public void run() {
						if (lastReward != null)
							sendReward(lastReward);
						lastReward = null;
						callbackContext.success("RegisterRewardReceiver");
					}
				});
				return true;
			}
			callbackContext.error("AdColonyPlugin Method " + action + " not found");
			return false;
		} catch (Exception e) {
			Log.d(TAG, "ERROR: AdColonyPlugin Exception: " + e.getMessage());
			callbackContext.error(e.getMessage());
			return false;
		}
	}

	@Override
	public void onDestroy() {
		gWebView = null;
	}


	/**
	 * Package the reward in a JSON object and send it back to the JavaScript method configured
	 *
	 * @param reward - AdColonyReward object
	 */
	private void sendReward(AdColonyReward reward) {
		try {
			JSONObject jo = new JSONObject();
			jo.put("rewardname", reward.getRewardName());
			jo.put("rewardamount", reward.getRewardAmount());
			jo.put("rewardzoneid", reward.getZoneID());
			jo.put("success", reward.success() ? true : false);

			String callBack = "javascript:" + rewardCallBack + "(" + jo.toString() + ");";
			if (rewardCallBackReady && gWebView != null) {
				Log.d(TAG, "\tSendReward to: " + callBack);
				gWebView.sendJavascript(callBack);
			} else {
				Log.d(TAG, "\tView not ready. SAVED Reward: " + callBack);
				lastReward = reward;
			}
		} catch (Exception e) {
			Log.d(TAG, "\tsendReward Exception (Reward Saved): " + e.getMessage());
			lastReward = reward;
		}

	}

	/**
	 * Request an Ad in a background thread pool
	 */
	private void requestInterstitialInZone(final String zoneID) {
		cordova.getThreadPool().execute(new Runnable() {
			public void run() {
				Log.d(TAG, "requestInterstitialInZone: " + requestArgs);
				if (ad == null || ad.isExpired()) {
					//NB - Remember to set any options first
					String zone = zoneID;
					if (zone == "null" || zone == null)
						zone = ZONE_ID;
					AdColony.requestInterstitial(zone, listener, ad_options);
				}
				PluginResult reqResult = new PluginResult(PluginResult.Status.NO_RESULT, "AdColonyRequestSubmitted");
				reqResult.setKeepCallback(true);
				requestCallbackContext.sendPluginResult(reqResult);
			}
		});
	}

	private void requestInterstitialInZone() {
		requestInterstitialInZone(ZONE_ID);
	}

	/**
	 * Set the user metadata in the ad_options which is then sent with each request
	 * See
	 *
	 * @param args            - JSON Array typeically with ONE element a JSON object with the options
	 * @param callbackContext - THe context to notify
	 */
	private void setUserMetaData(final JSONArray args, final CallbackContext callbackContext) {
		try {
			JSONObject jsonArgs = args.getJSONObject(0);
			Iterator<?> keys = jsonArgs.keys();
			AdColonyUserMetadata metadata = new AdColonyUserMetadata();
			if (ad_options == null)
				ad_options = new AdColonyAdOptions();

			// Go through all options
			while (keys.hasNext()) {
				try {
					String key = (String) keys.next();
					String val = jsonArgs.getString(key);
					metadata.setMetadata(key, val);
				} catch (Exception ex) {
					// Ignore invalid data
				}
			}
			ad_options.setUserMetadata(metadata);
		/*
		 * Optionally update location info in the ad options for each request:
		 * LocationManager location_manager = (LocationManager) getSystemService( Context.LOCATION_SERVICE );
		 * Location location = location_manager.getLastKnownLocation( LocationManager.GPS_PROVIDER );
		 * ad_options.setUserMetadata( ad_options.getUserMetadata().setUserLocation( location ) );
		 * ad_options.setUserLocation( location );
		 */

			callbackContext.success("SetUserMetaData");

		} catch (Exception e) {
			callbackContext.error(e.getMessage());
		}
	}

	/**
	 * Set the ad options for the interaction to AdColony
	 * See
	 *
	 * @param args            - JSON Array typically with ONE element a JSON object with the options
	 * @param callbackContext - THe context to notify
	 */
	private void setAdOptions(final JSONArray args, final CallbackContext callbackContext) {
		try {
			JSONObject jsonArgs = args.getJSONObject(0);
			Iterator<?> keys = jsonArgs.keys();
			if (ad_options == null)
				ad_options = new AdColonyAdOptions();

			// Go through all options
			while (keys.hasNext())
				try {
					String key = (String) keys.next();
					String val = jsonArgs.getString(key);
					ad_options.setOption(key, val);
				} catch (Exception ex) {
					// Ignore invalid data
				}
			callbackContext.success("SetAdOptions");

		} catch (Exception e) {
			callbackContext.error(e.getMessage());
		}
	}

	/**
	 * Set the ad options for the interaction to AdColony
	 * See
	 *
	 * @param args            - JSON Array typically with ONE element a JSON object with the options
	 * @param callbackContext - THe context to notify
	 */
	private void setAppOptions(final JSONArray args, final CallbackContext callbackContext) {
		try {
			JSONObject jsonArgs = args.getJSONObject(0);
			processJSONOptions(jsonArgs);
			callbackContext.success("SetAppOptions");
		} catch (Exception e) {
			callbackContext.error(e.getMessage());
		}
	}

	private void processJSONOptions(JSONObject jsonArgs) throws JSONException {
		Iterator<?> keys = jsonArgs.keys();
		if (app_options == null)
			app_options = AdColony.getAppOptions();

		// Go through all options
		while (keys.hasNext()) {
			try {
				String key = (String) keys.next();
				String val = jsonArgs.getString(key);
				app_options.setOption(key, val);
			} catch (Exception ex) {
				// Ignore invalid data
			}
		}
		AdColony.setAppOptions(app_options);

	}
}
