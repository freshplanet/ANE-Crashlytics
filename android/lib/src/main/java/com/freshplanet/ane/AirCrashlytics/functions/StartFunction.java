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

package com.freshplanet.ane.AirCrashlytics.functions;



import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirCrashlytics.Constants;
import com.google.firebase.crashlytics.FirebaseCrashlytics;

public class StartFunction extends BaseFunction {
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);

        final FREContext cont = context;

		FirebaseCrashlytics.getInstance().setCrashlyticsCollectionEnabled(true);
		FirebaseCrashlytics.getInstance().log("start ane");
        if(FirebaseCrashlytics.getInstance().didCrashOnPreviousExecution()) {
			cont.dispatchStatusEventAsync(Constants.AirCrashlyticsEvent_CRASH_DETECTED_DURING_PREVIOUS_EXECUTION, "No crash data");
		}



		return null;
	}
}