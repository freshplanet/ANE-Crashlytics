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

#import "AirCrashlytics.h"
#import "Constants.h"
#import <FirebaseCore.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>
#import <FirebaseCrashlytics/FirebaseCrashlytics.h>

@interface AirCrashlytics ()
    @property (nonatomic, readonly) FREContext context;
@end

@implementation AirCrashlytics
    
    
    
- (instancetype)initWithContext:(FREContext)extensionContext {
    
    if ((self = [super init])) {
        
        _context = extensionContext;
    }
    
    return self;
}

- (void) sendLog:(NSString*)log {
    [self sendEvent:@"log" level:log];
}
    
- (void) sendEvent:(NSString*)code {
    [self sendEvent:code level:@""];
}
    
- (void) sendEvent:(NSString*)code level:(NSString*)level {
    FREDispatchStatusEventAsync(_context, (const uint8_t*)[code UTF8String], (const uint8_t*)[level UTF8String]);
}
    
@end

AirCrashlytics* GetAirCrashlyticsContextNativeData(FREContext context) {
    
    CFTypeRef controller;
    FREGetContextNativeData(context, (void**)&controller);
    return (__bridge AirCrashlytics*)controller;
}


DEFINE_ANE_FUNCTION(AirCrashlyticsStart) {
    AirCrashlytics* controller = GetAirCrashlyticsContextNativeData(context);
    
    if (!controller)
        return AirCrashlytics_FPANE_CreateError(@"context's AirCrashlytics is null", 0);
    
    @try {
        if(![FIRApp defaultApp]){
            [FIRApp configure];
        }
        
        [[FIRCrashlytics crashlytics] setCrashlyticsCollectionEnabled:true];

        if ([[FIRCrashlytics crashlytics] didCrashDuringPreviousExecution]) {
            [controller sendEvent:kAirCrashlyticsEvent_CRASH_DETECTED_DURING_PREVIOUS_EXECUTION];
            
        }
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to start Crashlytics : " stringByAppendingString:exception.reason]];
    }
    
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsCrash) {
    
    // Force a test crash
    @[][1];
    return AirCrashlytics_FPANE_BOOLToFREObject(YES);
}

DEFINE_ANE_FUNCTION(AirCrashlyticsGetApiKey) {
    

    return AirCrashlytics_FPANE_NSStringToFREObject(@"");
}

DEFINE_ANE_FUNCTION(AirCrashlyticsGetVersion) {

    return AirCrashlytics_FPANE_NSStringToFREObject(@"");
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetUserIdentifier) {
    
    AirCrashlytics* controller = GetAirCrashlyticsContextNativeData(context);
    
    if (!controller)
        return AirCrashlytics_FPANE_CreateError(@"context's AirCrashlytics is null", 0);
    
    @try {
        NSString *userIdentifier = AirCrashlytics_FPANE_FREObjectToNSString(argv[0]);
        [[FIRCrashlytics crashlytics] setUserID:userIdentifier];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to set user identifier : " stringByAppendingString:exception.reason]];
    }
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetBool) {
    
    AirCrashlytics* controller = GetAirCrashlyticsContextNativeData(context);
    
    if (!controller)
        return AirCrashlytics_FPANE_CreateError(@"context's AirCrashlytics is null", 0);
    
    @try {
        NSString *key = AirCrashlytics_FPANE_FREObjectToNSString(argv[0]);
        BOOL value = AirCrashlytics_FPANE_FREObjectToBool(argv[1]);
    
        [[FIRCrashlytics crashlytics] setCustomValue:@(value) forKey:key];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to set bool value : " stringByAppendingString:exception.reason]];
    }
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetInt) {
    
    AirCrashlytics* controller = GetAirCrashlyticsContextNativeData(context);
    
    if (!controller)
        return AirCrashlytics_FPANE_CreateError(@"context's AirCrashlytics is null", 0);
    
    @try {
        NSString *key = AirCrashlytics_FPANE_FREObjectToNSString(argv[0]);
        NSInteger value = AirCrashlytics_FPANE_FREObjectToInt(argv[1]);
    
        [[FIRCrashlytics crashlytics] setCustomValue:@(value) forKey:key];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to set bool value : " stringByAppendingString:exception.reason]];
    }
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetFloat) {
    
    AirCrashlytics* controller = GetAirCrashlyticsContextNativeData(context);
    
    if (!controller)
        return AirCrashlytics_FPANE_CreateError(@"context's AirCrashlytics is null", 0);
    
    @try {
        NSString *key = AirCrashlytics_FPANE_FREObjectToNSString(argv[0]);
        double value = AirCrashlytics_FPANE_FREObjectToDouble(argv[1]);
    
        [[FIRCrashlytics crashlytics] setCustomValue:@(value) forKey:key];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to set float value : " stringByAppendingString:exception.reason]];
    }
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetString) {
    
    AirCrashlytics* controller = GetAirCrashlyticsContextNativeData(context);
    
    if (!controller)
        return AirCrashlytics_FPANE_CreateError(@"context's AirCrashlytics is null", 0);
    
    @try {
        NSString *key = AirCrashlytics_FPANE_FREObjectToNSString(argv[0]);
        NSString *value = AirCrashlytics_FPANE_FREObjectToNSString(argv[1]);
        
        [[FIRCrashlytics crashlytics] setCustomValue:value forKey:key];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to set string value : " stringByAppendingString:exception.reason]];
    }

    return nil;
}


#pragma mark - ANE Setup

void AirCrashlyticsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    AirCrashlytics* controller = [[AirCrashlytics alloc] initWithContext:ctx];
    FRESetContextNativeData(ctx, (void*)CFBridgingRetain(controller));
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(AirCrashlyticsStart, NULL),
        MAP_FUNCTION(AirCrashlyticsCrash, NULL),
        MAP_FUNCTION(AirCrashlyticsGetApiKey, NULL),
        MAP_FUNCTION(AirCrashlyticsGetVersion, NULL),
        MAP_FUNCTION(AirCrashlyticsSetUserIdentifier, NULL),
        MAP_FUNCTION(AirCrashlyticsSetBool, NULL),
        MAP_FUNCTION(AirCrashlyticsSetInt, NULL),
        MAP_FUNCTION(AirCrashlyticsSetFloat, NULL),
        MAP_FUNCTION(AirCrashlyticsSetString, NULL)
    };
    
    *numFunctionsToTest = sizeof(functions) / sizeof(FRENamedFunction);
    *functionsToSet = functions;
}

void AirCrashlyticsContextFinalizer(FREContext ctx) {
    
    CFTypeRef controller;
    FREGetContextNativeData(ctx, (void **)&controller);
    CFBridgingRelease(controller);
}

void AirCrashlyticsInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &AirCrashlyticsContextInitializer;
    *ctxFinalizerToSet = &AirCrashlyticsContextFinalizer;
}

void AirCrashlyticsFinalizer(void *extData) {
    
}

