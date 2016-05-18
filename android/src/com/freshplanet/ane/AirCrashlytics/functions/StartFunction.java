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

package com.freshplanet.ane.AirCrashlytics.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.crashlytics.android.Crashlytics;
import io.fabric.sdk.android.Fabric;
import com.crashlytics.android.core.CrashlyticsListener;
import com.crashlytics.android.core.CrashlyticsCore;

public class StartFunction extends BaseFunction
{
	public FREObject call(FREContext context, FREObject[] args)
	{
		super.call(context, args);

        final FREContext cont = context;

        final CrashlyticsListener crashlyticsListener = new CrashlyticsListener() {
            @Override
            public void crashlyticsDidDetectCrashDuringPreviousExecution(){
                cont.dispatchStatusEventAsync("CRASH DETECTED IN LAST SESSION", "No crash data...");
            }
        };

        final CrashlyticsCore crashlyticsCore = new CrashlyticsCore
                .Builder()
                .listener(crashlyticsListener)
                .build();


        Fabric.with(context.getActivity().getApplicationContext(), new Crashlytics.Builder().core(crashlyticsCore).build());

		return null;
	}
}