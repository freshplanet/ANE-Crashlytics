//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  
//////////////////////////////////////////////////////////////////////////////////////

package com.freshplanet.ane.AirCrashlytics
{
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;

	public class AirCrashlytics
	{
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		/** Crashlytics is supported on iOS and Android devices. */
		public static function get isSupported():Boolean
		{
			return Capabilities.manufacturer.indexOf("iOS") > -1 || Capabilities.manufacturer.indexOf("Android") > -1;
		}
		
		public static function start():void
		{
			call("start");
			
			log("Crashlytics " + version + " initialized with API key " + apiKey);
		}
		
		public static function crash():void
		{
			call("crash");
			
			if (Capabilities.manufacturer.indexOf("iOS") == -1)
			{
				log("The test crash method only works on iOS at the moment");
			}
		}
		
		public static function get apiKey():String
		{
			return call("getApiKey");
		}
		
		public static function get version():String
		{
			return call("getVersion");
		}
		
		public static function set debugMode(value:Boolean):void
		{
			call("setDebugMode", value);
		}
		
		public static function set userIdentifier(value:String):void
		{
			call("setUserIdentifier", value);
		}
		
		public static function setBool(key:String, value:Boolean):void
		{
			call("setBool", key, value);
		}
		
		public static function setInt(key:String, value:int):void
		{
			call("setInt", key, value);
		}
		
		public static function setFloat(key:String, value:Number):void
		{
			call("setFloat", key, value);
		}
		
		public static function setString(key:String, value:String):void
		{
			call("setString", key, value);
		}
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									 	PRIVATE API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		private static const EXTENSION_ID : String = "com.freshplanet.AirCrashlytics";
		
		private static var _context : ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
		
		private static function call(...args):*
		{
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