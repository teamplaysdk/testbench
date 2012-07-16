//
//  TestBenchLayer.h
//  testbench
//
//  Created by Neil Smith on 4/20/12.
//  Copyright TeamPlay 2012. All rights reserved.
//

#import "cocos2d.h"
#import <TeamPlay/TeamPlay.h>

#define MAXROWS (20)

@interface TestBenchLayer : CCLayer <UIAlertViewDelegate>
{
    NSMutableArray *rows;
}

@property (nonatomic, retain) NSMutableArray *rows;

- (void) invokePicker;
- (void) recordPoints:(int)points;
- (void) record10Points;
- (void) record20Points;
- (void) record50Points;
- (void) invokeResults;

+(CCScene *) scene;

- (void) tp_log:(NSString *)msg;

@end
