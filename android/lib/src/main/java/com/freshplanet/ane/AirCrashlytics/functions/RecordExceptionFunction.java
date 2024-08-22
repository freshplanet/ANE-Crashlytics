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
import com.google.firebase.crashlytics.FirebaseCrashlytics;

public class RecordExceptionFunction extends BaseFunction {
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);

		String callStackAll = getStringFromFREObject(args[0]);
		try {
			parseAndLogASError(callStackAll);
		} catch (Exception e) {
			FirebaseCrashlytics.getInstance().recordException(new Exception("Failed to parse callstack\n" + callStackAll + "\n" + e.getMessage()));
		}

		return null;
	}

	private void parseAndLogASError(String callStackAll) {
		/*
		 example as error:
		 TypeError: Error #1009: Cannot access a property or method of a null object reference.
		 at ui.screens::SettingsScreen()[/Users/Shared/Work/repo/SongPop/front-end-shared-lib/src/ui/screens/SettingsScreen.as:60]
		 at logic.managers::ScreenManager/showSettingsScreen()[/Users/Shared/Work/repo/SongPop/front-end-shared-lib/src/logic/managers/ScreenManager.as:1492]
		 at logic.controller::SettingsController/showSettingsScreen()[/Users/Shared/Work/repo/SongPop/front-end-shared-lib/src/logic/controller/SettingsController.as:85]
		 at ui.screens::ProfileScreen/showSettingsScreen()[/Users/Shared/Work/repo/SongPop/front-end-shared-lib/src/ui/screens/ProfileScreen.as:1798]
		 */
		String[] callStack = callStackAll.split("\\n");

		String message = callStack[0];
		Throwable t = new Throwable(message);
		StackTraceElement[] stackTraceElements = new StackTraceElement[callStack.length - 1];
		for (int i = 1; i < callStack.length; i++) {
			String stackString = callStack[i].trim().substring(3); // remove "at " prefix
			String[] split = stackString.split("\\(\\)");

			String[] classMethod = split[0].split("/");
			String className = classMethod[0];
			String methodName = classMethod.length > 1 ? classMethod[1] : "constructor";

			String fileName = null;
			int lineNumber = -1;

			if (split.length > 1) {
				String[] fileLocation = split[1].substring(1, split[1].length() - 2).split(":");
				fileName = fileLocation[0];
				if (fileLocation.length > 1) {
					try {
						lineNumber = Integer.parseInt(fileLocation[1]);
					} catch (Exception ignored) {}
				}
			}

			stackTraceElements[i-1] = new StackTraceElement(className, methodName, fileName, lineNumber);
		}

		t.setStackTrace(stackTraceElements);
		FirebaseCrashlytics.getInstance().recordException(t);
	}
}