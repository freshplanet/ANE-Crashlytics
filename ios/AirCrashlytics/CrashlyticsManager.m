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

#import "CrashlyticsManager.h"

@interface CrashlyticsManager ()

@property (nonatomic, readonly) FREContext context;

@end

@implementation CrashlyticsManager

- (instancetype) initWithContext:(FREContext)extensionContext
{
    self = [super init];
    
    if( self )
    {
        _context = extensionContext;
    }
    return self;
}

#pragma mark - CrashlyticsDelegate

- (void)crashlytics:(Crashlytics *)crashlytics didDetectCrashDuringPreviousExecution:(id <CLSCrashReport>)crash
{
    // Format the NSDate
    NSString * eventTime = [NSString stringWithFormat:@"%f", [crash.crashedOnDate timeIntervalSince1970]];
    
    if(crash.customKeys[@"sessionId"])
    {
        // You can choose to pass more info about the crash in the json string
        NSString *stringInfo = [NSString stringWithFormat: @"{\"crashId\" : \"%@\", \"eventTime\" : \"%@\", \"sessionId\" : \"%@\", \"userId\" : \"%@\"}", crash.identifier, eventTime, crash.customKeys[@"sessionId"], crash.customKeys[@"userId"]];
        FREDispatchStatusEventAsync(_context, (uint8_t*)"CRASH DETECTED DURING PREVIOUS EXECUTION", (uint8_t*)[stringInfo UTF8String]);
    }
}

@end
