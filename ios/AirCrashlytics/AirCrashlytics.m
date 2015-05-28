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

#import "AirCrashlytics.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


static FREContext context;

DEFINE_ANE_FUNCTION(AirCrashlyticsStart)
{
    [Fabric with:@[CrashlyticsKit]];
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsCrash)
{
    [[Crashlytics sharedInstance] crash];
    return FPANE_BOOLToFREObject(YES);
}

DEFINE_ANE_FUNCTION(AirCrashlyticsGetApiKey)
{
    NSString *apiKey = [[Crashlytics sharedInstance] apiKey];
    return FPANE_NSStringToFREOBject(apiKey);
}

DEFINE_ANE_FUNCTION(AirCrashlyticsGetVersion)
{
    NSString *version = [[Crashlytics sharedInstance] version];
    return FPANE_NSStringToFREOBject(version);
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetDebugMode)
{
    BOOL debugMode = FPANE_FREObjectToBOOL(argv[0]);
    [[Crashlytics sharedInstance] setDebugMode:debugMode];
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetUserIdentifier)
{
    NSString *userIdentifier = FPANE_FREObjectToNSString(argv[0]);
    [Crashlytics setUserIdentifier:userIdentifier];
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetBool)
{
    NSString *key = FPANE_FREObjectToNSString(argv[0]);
    BOOL value = FPANE_FREObjectToBOOL(argv[1]);
    [Crashlytics setBoolValue:value forKey:key];
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetInt)
{
    NSString *key = FPANE_FREObjectToNSString(argv[0]);
    NSInteger value = FPANE_FREObjectToNSInteger(argv[1]);
    [Crashlytics setIntValue:(int)value forKey:key];
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetFloat)
{
    NSString *key = FPANE_FREObjectToNSString(argv[0]);
    double value = FPANE_FREObjectToDouble(argv[1]);
    [Crashlytics setFloatValue:(float)value forKey:key];
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetString)
{
    NSString *key = FPANE_FREObjectToNSString(argv[0]);
    NSString *value = FPANE_FREObjectToNSString(argv[1]);
    [Crashlytics setObjectValue:value forKey:key];
    return nil;
}


#pragma mark - ANE Setup

void AirCrashlyticsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                                   uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSDictionary *functions = @{
        @"start":               [NSValue valueWithPointer:&AirCrashlyticsStart],
        @"crash":               [NSValue valueWithPointer:&AirCrashlyticsCrash],
        @"getApiKey":           [NSValue valueWithPointer:&AirCrashlyticsGetApiKey],
        @"getVersion":          [NSValue valueWithPointer:&AirCrashlyticsGetVersion],
        @"setDebugMode":        [NSValue valueWithPointer:&AirCrashlyticsSetDebugMode],
        @"setUserIdentifier":   [NSValue valueWithPointer:&AirCrashlyticsSetUserIdentifier],
        @"setBool":             [NSValue valueWithPointer:&AirCrashlyticsSetBool],
        @"setInt":              [NSValue valueWithPointer:&AirCrashlyticsSetInt],
        @"setFloat":            [NSValue valueWithPointer:&AirCrashlyticsSetFloat],
        @"setString":           [NSValue valueWithPointer:&AirCrashlyticsSetString]
    };
    
    *numFunctionsToTest = (uint32_t)[functions count];
    
    FRENamedFunction *func = (FRENamedFunction *)malloc(sizeof(FRENamedFunction) * [functions count]);
    
    for (NSInteger i = 0; i < [functions count]; i++)
    {
        func[i].name = (const uint8_t *)[[[functions allKeys] objectAtIndex:i] UTF8String];
        func[i].functionData = NULL;
        func[i].function = [[[functions allValues] objectAtIndex:i] pointerValue];
    }
    
    *functionsToSet = func;
    
    context = ctx;
}

void AirCrashlyticsContextFinalizer(FREContext ctx) { }

void AirCrashlyticsInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &AirCrashlyticsContextInitializer;
	*ctxFinalizerToSet = &AirCrashlyticsContextFinalizer;
}

void AirCrashlyticsFinalizer(void *extData) { }