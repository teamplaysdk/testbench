//
//  TeamPlay.h
//  TeamPlay
//
//  Created by Neil Smith on 3/22/12.
//  Copyright (c) 2012 TeamPlay. All rights reserved.
//

@interface TeamPlay : NSObject
+(TeamPlay *) sharedTeamPlay;
- (void) startSessionWithKey:(NSString *)key withSecret:(NSString *)secret authenticate:(BOOL)auth handleDisconnected:(BOOL)hdis callback:(void (^)(int status, id result))cb;
- (BOOL) hasSession;
- (BOOL) isAuthenticated;
- (void) invokePicker:(void (^)(int status, id result))cb;
- (void) invokeResults:(void (^)(int status, id result))cb;
- (void) recordScore:(NSNumber *)score againstField:(NSString *)fieldid callback:(void (^)(int status, id result))cb;
- (void) recordScores:(void (^)(int status, id result))cb, ...;
- (void) logout:(void (^)(int status, id result))cb;
- (BOOL) handleOpenURL:(NSURL *)url;
@end


