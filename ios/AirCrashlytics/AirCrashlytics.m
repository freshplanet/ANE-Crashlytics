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

@interface AirCrashlytics ()
@property (nonatomic, readonly) FREContext context;
@end

@implementation AirCrashlytics

@synthesize context;

- (instancetype)initWithContext:(FREContext)extensionContext {
    
    if ((self = [super init])) {
        
        context = extensionContext;
        
        [[Crashlytics sharedInstance] setDelegate:self];
        [Fabric with:@[[Crashlytics class]]];
    }
    
    return self;
}

- (void)crashlyticsDidDetectReportForLastExecution:(CLSReport *)report completionHandler:(void (^)(BOOL submit))completionHandler {
    
    NSString* eventTime = [NSString stringWithFormat:@"%f", [report.crashedOnDate timeIntervalSince1970]];
    NSString* sessionId = report.customKeys[@"sessionId"];
    NSString* userId = report.customKeys[@"userId"];
    
    if (sessionId != nil) {
        
        // You can choose to pass more info about the crash in the json string
        NSString* stringInfo = [NSString stringWithFormat: @"{\"crashId\" : \"%@\", \"eventTime\" : \"%@\", \"sessionId\" : \"%@\", \"userId\" : \"%@\"}",
                                report.identifier, eventTime, sessionId, userId];
        
        FREDispatchStatusEventAsync(context, (uint8_t*)"CRASH DETECTED DURING PREVIOUS EXECUTION", (uint8_t*)[stringInfo UTF8String]);
    }
    
    completionHandler(YES);
}

- (BOOL)crashlyticsCanUseBackgroundSessions:(Crashlytics *)crashlytics {
    return NO;
}

@end

DEFINE_ANE_FUNCTION(AirCrashlyticsStart) {
    
    AirCrashlytics* controller = [[AirCrashlytics alloc] initWithContext:context];
    FRESetContextNativeData(context, (void*)CFBridgingRetain(controller));
    
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

DEFINE_ANE_FUNCTION(AirCrashlyticsSetDebugMode) {
    
    BOOL debugMode = FPANE_FREObjectToBOOL(argv[0]);
    [[Crashlytics sharedInstance] setDebugMode:debugMode];
    
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetUserIdentifier) {
    
    NSString *userIdentifier = FPANE_FREObjectToNSString(argv[0]);
    [[Crashlytics sharedInstance] setUserIdentifier:userIdentifier];
    
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetBool) {
    
    NSString *key = FPANE_FREObjectToNSString(argv[0]);
    BOOL value = FPANE_FREObjectToBOOL(argv[1]);
    
    [[Crashlytics sharedInstance] setBoolValue:value forKey:key];
    
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetInt) {
    
    NSString *key = FPANE_FREObjectToNSString(argv[0]);
    NSInteger value = FPANE_FREObjectToNSInteger(argv[1]);
    
    [[Crashlytics sharedInstance] setIntValue:(int)value forKey:key];
    
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetFloat) {
    
    NSString *key = FPANE_FREObjectToNSString(argv[0]);
    double value = FPANE_FREObjectToDouble(argv[1]);
    
    [[Crashlytics sharedInstance] setFloatValue:(float)value forKey:key];
    
    return nil;
}

DEFINE_ANE_FUNCTION(AirCrashlyticsSetString) {
    
    NSString *key = FPANE_FREObjectToNSString(argv[0]);
    NSString *value = FPANE_FREObjectToNSString(argv[1]);
    
    [[Crashlytics sharedInstance] setObjectValue:value forKey:key];
    
    return nil;
}


#pragma mark - ANE Setup

void AirCrashlyticsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    static FRENamedFunction functions[] = {
        (const uint8_t*)"start", NULL, &AirCrashlyticsStart,
        (const uint8_t*)"crash", NULL, &AirCrashlyticsCrash,
        (const uint8_t*)"getApiKey", NULL, &AirCrashlyticsGetApiKey,
        (const uint8_t*)"getVersion", NULL, &AirCrashlyticsGetVersion,
        (const uint8_t*)"setDebugMode", NULL, &AirCrashlyticsSetDebugMode,
        (const uint8_t*)"setUserIdentifier", NULL, &AirCrashlyticsSetUserIdentifier,
        (const uint8_t*)"setBool", NULL, &AirCrashlyticsSetBool,
        (const uint8_t*)"setInt", NULL, &AirCrashlyticsSetInt,
        (const uint8_t*)"setFloat", NULL, &AirCrashlyticsSetFloat,
        (const uint8_t*)"setString", NULL, &AirCrashlyticsSetString
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

