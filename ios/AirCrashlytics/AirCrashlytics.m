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
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Constants.h"

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
    
//- (void)crashlyticsDidDetectReportForLastExecution:(CLSReport *)report completionHandler:(void (^)(BOOL submit))completionHandler {
//    
//    NSString* eventTime = [NSString stringWithFormat:@"%f", [report.crashedOnDate timeIntervalSince1970]];
//    NSString* sessionId = report.customKeys[@"sessionId"];
//    NSString* userId = report.customKeys[@"userId"];
//    if (sessionId == nil) {
//        sessionId = @"";
//    }
//    if (userId == nil) {
//        userId = @"";
//    }
//    
//           // You can choose to pass more info about the crash in the json string
//    NSString* stringInfo = [NSString stringWithFormat: @"{\"crashId\" : \"%@\", \"eventTime\" : \"%@\", \"sessionId\" : \"%@\", \"userId\" : \"%@\"}",
//                                report.identifier, eventTime, sessionId, userId];
//        
//    [self sendEvent:kAirCrashlyticsEvent_CRASH_DETECTED_DURING_PREVIOUS_EXECUTION level:stringInfo];
//    
//    
//    completionHandler(YES);
//}
    
-(void) crashlyticsDidDetectReportForLastExecution:(CLSReport *)report {
    NSString* eventTime = [NSString stringWithFormat:@"%f", [report.crashedOnDate timeIntervalSince1970]];
    NSString* sessionId = report.customKeys[@"sessionId"];
    NSString* userId = report.customKeys[@"userId"];
    if (sessionId == nil) {
        sessionId = @"";
    }
    if (userId == nil) {
        userId = @"";
    }
    
    // You can choose to pass more info about the crash in the json string
    NSString* stringInfo = [NSString stringWithFormat: @"{\"crashId\" : \"%@\", \"eventTime\" : \"%@\", \"sessionId\" : \"%@\", \"userId\" : \"%@\"}",
                            report.identifier, eventTime, sessionId, userId];
    
    [self sendEvent:kAirCrashlyticsEvent_CRASH_DETECTED_DURING_PREVIOUS_EXECUTION level:stringInfo];
}
    
- (BOOL)crashlyticsCanUseBackgroundSessions:(Crashlytics *)crashlytics {
    return NO;
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
        return FPANE_CreateError(@"context's AirCrashlytics is null", 0);
    
    @try {
        BOOL debugMode = FPANE_FREObjectToBool(argv[0]);
        [[Fabric sharedSDK] setDebug: debugMode];
        [[Crashlytics sharedInstance] setDelegate:controller];
        [Fabric with:@[[Crashlytics class]]];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to start Crashlytics : " stringByAppendingString:exception.reason]];
    }
    
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsCrash) {
    
    [[Crashlytics sharedInstance] crash];
    return FPANE_BOOLToFREObject(YES);
}

DEFINE_ANE_FUNCTION(AirCrashlyticsGetApiKey) {
    
    NSString *apiKey = [[Crashlytics sharedInstance] APIKey];
    return FPANE_NSStringToFREObject(apiKey);
}

DEFINE_ANE_FUNCTION(AirCrashlyticsGetVersion) {
    
    NSString *version = [[Crashlytics sharedInstance] version];
    return FPANE_NSStringToFREObject(version);
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetUserIdentifier) {
    
    AirCrashlytics* controller = GetAirCrashlyticsContextNativeData(context);
    
    if (!controller)
        return FPANE_CreateError(@"context's AirCrashlytics is null", 0);
    
    @try {
        NSString *userIdentifier = FPANE_FREObjectToNSString(argv[0]);
        [[Crashlytics sharedInstance] setUserIdentifier:userIdentifier];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to set user identifier : " stringByAppendingString:exception.reason]];
    }
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetBool) {
    
    AirCrashlytics* controller = GetAirCrashlyticsContextNativeData(context);
    
    if (!controller)
        return FPANE_CreateError(@"context's AirCrashlytics is null", 0);
    
    @try {
        NSString *key = FPANE_FREObjectToNSString(argv[0]);
        BOOL value = FPANE_FREObjectToBool(argv[1]);
    
        [[Crashlytics sharedInstance] setBoolValue:value forKey:key];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to set bool value : " stringByAppendingString:exception.reason]];
    }
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetInt) {
    
    AirCrashlytics* controller = GetAirCrashlyticsContextNativeData(context);
    
    if (!controller)
        return FPANE_CreateError(@"context's AirCrashlytics is null", 0);
    
    @try {
        NSString *key = FPANE_FREObjectToNSString(argv[0]);
        NSInteger value = FPANE_FREObjectToInt(argv[1]);
    
        [[Crashlytics sharedInstance] setIntValue:(int)value forKey:key];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to set bool value : " stringByAppendingString:exception.reason]];
    }
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetFloat) {
    
    AirCrashlytics* controller = GetAirCrashlyticsContextNativeData(context);
    
    if (!controller)
        return FPANE_CreateError(@"context's AirCrashlytics is null", 0);
    
    @try {
        NSString *key = FPANE_FREObjectToNSString(argv[0]);
        double value = FPANE_FREObjectToDouble(argv[1]);
    
        [[Crashlytics sharedInstance] setFloatValue:(float)value forKey:key];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to set float value : " stringByAppendingString:exception.reason]];
    }
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetString) {
    
    AirCrashlytics* controller = GetAirCrashlyticsContextNativeData(context);
    
    if (!controller)
        return FPANE_CreateError(@"context's AirCrashlytics is null", 0);
    
    @try {
        NSString *key = FPANE_FREObjectToNSString(argv[0]);
        NSString *value = FPANE_FREObjectToNSString(argv[1]);
        [[Crashlytics sharedInstance] setObjectValue:value forKey:key];
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

