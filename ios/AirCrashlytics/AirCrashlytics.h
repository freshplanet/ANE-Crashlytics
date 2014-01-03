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


// C interface
DEFINE_ANE_FUNCTION(AirCrashlyticsStart);
DEFINE_ANE_FUNCTION(AirCrashlyticsCrash);
DEFINE_ANE_FUNCTION(AirCrashlyticsGetApiKey);
DEFINE_ANE_FUNCTION(AirCrashlyticsGetVersion);
DEFINE_ANE_FUNCTION(AirCrashlyticsSetDebugMode);
DEFINE_ANE_FUNCTION(AirCrashlyticsSetUserIdentifier);
DEFINE_ANE_FUNCTION(AirCrashlyticsSetBool);
DEFINE_ANE_FUNCTION(AirCrashlyticsSetInt);
DEFINE_ANE_FUNCTION(AirCrashlyticsSetFloat);
DEFINE_ANE_FUNCTION(AirCrashlyticsSetString);


// ANE Setup
void AirCrashlyticsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void AirCrashlyticsContextFinalizer(FREContext ctx);
void AirCrashlyticsInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void AirCrashlyticsFinalizer(void *extData);