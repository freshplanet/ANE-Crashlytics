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

import java.util.EnumMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.analytics.FirebaseAnalytics.ConsentStatus;
import com.google.firebase.analytics.FirebaseAnalytics.ConsentType;


public class SetConsentFunction extends BaseFunction {
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);
		
		Boolean isAnalyticsConsent = getBooleanFromFREObject(args[0]);
		Boolean isAdStorageConsent = getBooleanFromFREObject(args[1]);
		Boolean isAdUserDataConsent = getBooleanFromFREObject(args[2]);
		Boolean isAdPersonalizationConsent = getBooleanFromFREObject(args[3]);

		Map<ConsentType, ConsentStatus> consentMap = new EnumMap<>(ConsentType.class);
		consentMap.put(ConsentType.ANALYTICS_STORAGE, isAnalyticsConsent ? ConsentStatus.GRANTED : ConsentStatus.DENIED);
		consentMap.put(ConsentType.AD_STORAGE, isAdStorageConsent ? ConsentStatus.GRANTED : ConsentStatus.DENIED);
		consentMap.put(ConsentType.AD_USER_DATA, isAdUserDataConsent ? ConsentStatus.GRANTED : ConsentStatus.DENIED);
		consentMap.put(ConsentType.AD_PERSONALIZATION, isAdPersonalizationConsent ? ConsentStatus.GRANTED : ConsentStatus.DENIED);

		FirebaseAnalytics.getInstance(context.getActivity().getApplicationContext()).setConsent(consentMap);
		
		return null;
	}
}