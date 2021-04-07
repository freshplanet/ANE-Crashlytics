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
package com.freshplanet.ane.AirCrashlytics.events {
import flash.events.Event;

public class AirCrashlyticsEvent extends Event {

	static public const CRASH_DETECTED_DURING_PREVIOUS_EXECUTION :String = "AirCrashlyticsEvent_crashDetectedDuringPreviousExecution";
	static public const RECEIVED_FCM_TOKEN :String = "AirCrashlyticsEvent_receivedFCMToken";
	static public const RECEIVED_FCM_TOKEN_ERROR :String = "AirCrashlyticsEvent_receivedFCMTokenError";

	private var _data:Object;
	public function AirCrashlyticsEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
		_data = data;
	}
	public function get data():Object {
		return _data;
	}
}
}
