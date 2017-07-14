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

package com.freshplanet.ane.AirCrashlytics;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.freshplanet.ane.AirCrashlytics.functions.CrashFunction;
import com.freshplanet.ane.AirCrashlytics.functions.GetApiKeyFunction;
import com.freshplanet.ane.AirCrashlytics.functions.GetVersionFunction;
import com.freshplanet.ane.AirCrashlytics.functions.SetBoolFunction;
import com.freshplanet.ane.AirCrashlytics.functions.SetFloatFunction;
import com.freshplanet.ane.AirCrashlytics.functions.SetIntFunction;
import com.freshplanet.ane.AirCrashlytics.functions.SetStringFunction;
import com.freshplanet.ane.AirCrashlytics.functions.SetUserIdentifierFunction;
import com.freshplanet.ane.AirCrashlytics.functions.StartFunction;

public class AirCrashlyticsExtensionContext extends FREContext {
	@Override
	public void dispose()
	{
		AirCrashlyticsExtension.context = null;
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functions = new HashMap<String, FREFunction>();
		
		functions.put("AirCrashlyticsStart", new StartFunction());
		functions.put("AirCrashlyticsCrash", new CrashFunction());
		functions.put("AirCrashlyticsGetApiKey", new GetApiKeyFunction());
		functions.put("AirCrashlyticsGetVersion", new GetVersionFunction());
		functions.put("AirCrashlyticsSetUserIdentifier", new SetUserIdentifierFunction());
		functions.put("AirCrashlyticsSetBool", new SetBoolFunction());
		functions.put("AirCrashlyticsSetInt", new SetIntFunction());
		functions.put("AirCrashlyticsSetFloat", new SetFloatFunction());
		functions.put("AirCrashlyticsSetString", new SetStringFunction());
		return functions;	
	}
}