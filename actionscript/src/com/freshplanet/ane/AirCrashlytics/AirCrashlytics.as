/*
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.freshplanet.ane.AirCrashlytics {
	import com.freshplanet.ane.AirCrashlytics.events.AirCrashlyticsEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;

	/**
	 *   The AirCrashlytics class provides support for Crashlytics SDK
	 *
	 *   The AirCrashlytics object is a singleton.
	 *   To get the single AirCrashlytics object, use the static AirCrashlytics.instance property.
	 *   Do not call the class constructor by calling new AirCrashlytics().
	 */
	public class AirCrashlytics extends EventDispatcher {
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		/**
		 * Is AirCrashlytics supported on the current platform
		 */
		public static function get isSupported():Boolean {
			return isIOS || Capabilities.manufacturer.indexOf("Android") > -1;
		}

		public static function get isIOS():Boolean {
			return Capabilities.manufacturer.indexOf("iOS") > -1 && Capabilities.os.indexOf("x86_64") < 0 && Capabilities.os.indexOf("i386") < 0;
		}

		/**
		 * AirCrashlytics instance
		 */
		static public function get instance():AirCrashlytics {
			return _instance != null ? _instance : new AirCrashlytics()
		}

		/**
		 * Start Crashlytics
		 */
        public function start(debugMode:Boolean):void {
			callNative("AirCrashlyticsStart", debugMode);

			log("Crashlytics " + version + " initialized with API key " + apiKey);
		}

		/**
		 * Start Crashlytics
		 */
		public function crash():void {
			var worked:Boolean = callNative("AirCrashlyticsCrash");

			if (!worked && Capabilities.manufacturer.indexOf("Android") > -1)
			{
				log("In order to force a crash on Android, you need to declare the following activity in your manifest: com.freshplanet.ane.AirCrashlytics.activities.CrashActivity");
			}
		}

		/**
		 * Get API key that was used
		 */
		public function get apiKey():String {
			return callNative("AirCrashlyticsGetApiKey");
		}

		/**
		 * Get Crashlytics version
		 */
		public function get version():String {
			return callNative("AirCrashlyticsGetVersion");
		}

		/**
		 * User defined properties - set user identifier
		 */
		public function set userIdentifier(value:String):void {
			if (value) {
				callNative("AirCrashlyticsSetUserIdentifier", value);
			}
		}

		/**
		 * User defined properties - set boolean value
		 */
		public function setBool(key:String, value:Boolean):void {
			callNative("AirCrashlyticsSetBool", key, value);
		}

		/**
		 * User defined properties - set integer value
		 */
		public function setInt(key:String, value:int):void {
			callNative("AirCrashlyticsSetInt", key, value);
		}

		/**
		 * User defined properties - set float value
		 */
		public function setFloat(key:String, value:Number):void {
			callNative("AirCrashlyticsSetFloat", key, value);
		}

		/**
		 * User defined properties - set string value
		 */
		public function setString(key:String, value:String):void {
			callNative("AirCrashlyticsSetString", key, value);
		}

		public function getFCMToken():void {
			if(!isIOS) {
				this.dispatchEvent(new AirCrashlyticsEvent(AirCrashlyticsEvent.RECEIVED_FCM_TOKEN_ERROR, "Not implemented on Android"));
				return;
			}
			callNative("AirCrashlyticsGetFCMToken");
		}
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									 	PRIVATE API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//

		private static const EXTENSION_ID : String = "com.freshplanet.ane.AirCrashlytics";
		private static var _instance:AirCrashlytics = null;
		private static var _context : ExtensionContext = null;

		/**
		 * "private" singleton constructor
		 */
		public function AirCrashlytics() {

			super();

			if (_instance)
				throw Error("this is a singleton, use .instance, do not call the constructor directly");

			_instance = this;
			_context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);

			if (!_context)
				trace("ERROR", "Extension context is null. Please check if extension.xml is setup correctly.");
			else
				_context.addEventListener(StatusEvent.STATUS, _onStatusEvent);
		}


		/**
		 * Status event listener
		 * @param e
		 */
		private function _onStatusEvent(e:StatusEvent):void {
			if(e.code == AirCrashlyticsEvent.CRASH_DETECTED_DURING_PREVIOUS_EXECUTION) {
				var crashData:Object = e.level;
				this.dispatchEvent(new AirCrashlyticsEvent(AirCrashlyticsEvent.CRASH_DETECTED_DURING_PREVIOUS_EXECUTION, crashData));
			}
			else if(e.code == AirCrashlyticsEvent.RECEIVED_FCM_TOKEN) {
				this.dispatchEvent(new AirCrashlyticsEvent(AirCrashlyticsEvent.RECEIVED_FCM_TOKEN, e.level));
			}
			else if(e.code == AirCrashlyticsEvent.RECEIVED_FCM_TOKEN_ERROR) {
				this.dispatchEvent(new AirCrashlyticsEvent(AirCrashlyticsEvent.RECEIVED_FCM_TOKEN_ERROR, e.level));
			}
			else {
				this.dispatchEvent(new Event(e.code));
			}
		}

		private static function callNative(...args):* {
			if (!isSupported) return null;
			
			if (!_context) throw new Error("Extension context is null. Please check if extension.xml is setup correctly.");
			
			return _context.call.apply(_context, args);
		}
		
		private static function log(msg:String):void
		{
			trace("[Crashlytics] " + msg);
		}
	}
}