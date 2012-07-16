//
//  TestBenchLayer.m
//  testbench
//
//  Created by Neil Smith on 4/20/12.
//  Copyright TeamPlay 2012. All rights reserved.
//

#import "AppDelegate.h"
#import "TestBenchLayer.h"

#import <TeamPlay/TeamPlay.h>

NSString *apikey = @"shky-2x5i-1p2t-bvv3-hs8c-4itx";        // You'll want to put your actual API key here
NSString *apisecret = @"iq37-r4w5-6ec9-vj37-n73u-hdbo";     // You'll want to put your actual API secret here
NSString *trackedObjectId1 = @"points";                     // You'll want to put your actual tracked object id here
NSString *trackedObjectId2 = @"touchdowns";                 // You'll want to put your actual tracked object id here

// HelloWorldLayer implementation
@implementation TestBenchLayer
@synthesize rows;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];

	TestBenchLayer *layer = [TestBenchLayer node];
	[scene addChild: layer];

	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        self.rows = [[NSMutableArray alloc] init];
        [self authenticate];
	}
	return self;
}

- (void) authenticate
{
    TeamPlay *tp = [TeamPlay sharedTeamPlay];
//    [tp withLogger:self];
    [tp startSessionWithKey:apikey withSecret:apisecret authenticate:YES handleDisconnected:YES callback:^(int status, id result){
        switch (status) {
            case 200:
                // Authenticated
                [self buildTestBenchDisplay];
                break;
                
            case 401:
                // Authentication cancelled
                // Alert and try again
                [self showAlert:@"Authentication is required"];
                break;
                
            case 500:
                // Internal Error
                // Alert and try again
                [self showAlert:@"Internal Error"];
                break;
                
            case 503:
                // Network not reachable
                // Alert and try again
                [self showAlert:@"The network is unreachable right now. Try again later."];
                break;
            default:
            {
                // Unrecognised error code
                // Alert and try again
                NSString *msg = [NSString stringWithFormat:@"Unrecognised error code (%d) from startSessionInView", status];
                [self showAlert:msg];
                break;
            }
        }
        
    }];
}

- (void) showAlert:(NSString *)msg
{
    NSLog(@"Showing alert");
    UIAlertView *alert = [[UIAlertView alloc]
            initWithTitle:@"Fail"
            message:msg
            delegate:self
            cancelButtonTitle:nil
            otherButtonTitles:@"Try Again", nil];
    [alert show];
    [alert release];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    [self authenticate];
}

- (void) buildTestBenchDisplay
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    CGPoint midpoint = ccp(winsize.width/2, winsize.height/2);
    
    // Background
    //
    CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
    bg.position = midpoint;
    [self addChild:bg];
    
    // Header
    //
    CCSprite *hdr = [CCSprite spriteWithFile:@"header.png"];
    hdr.anchorPoint = ccp(0.0f, 1.0f);
    hdr.position = ccp(0.0f, winsize.height);
    [self addChild:hdr z:2.0f];
    
    
    // Buttons
    //
    int xalign = 285;
    int yalign = 260;
    int yoffset = 98;
    int y = yalign;
    int txtxalign = xalign + winsize.width/2.0f;
    int txtyoffset = winsize.height/2.0f;
    int gap = 10;
    
    CCMenuItem *pickerMenuItem = [CCMenuItemImage 
                                  itemFromNormalImage:@"menu_buttons.png" selectedImage:@"menu_buttons_down.png" 
                                  target:self selector:@selector(invokePicker)];
    pickerMenuItem.position = ccp(xalign, y);
    
    CCLabelTTF *pickerLabel = [CCLabelTTF labelWithString:@"Picker" fontName:@"Futura-Medium" fontSize:40];
    pickerLabel.position = ccp(txtxalign,y+txtyoffset);
    pickerLabel.color = ccc3(78,24,10);
    y -= (yoffset+gap);
    
    CCMenuItem *score10MenuItem = [CCMenuItemImage 
                                   itemFromNormalImage:@"menu_buttons.png" selectedImage:@"menu_buttons_down.png" 
                                   target:self selector:@selector(record10Points)];
    score10MenuItem.position = ccp(xalign, y);
    
    CCLabelTTF *score10Label = [CCLabelTTF labelWithString:@"Score 10" fontName:@"Futura-Medium" fontSize:40];
    score10Label.position = ccp(txtxalign,y+txtyoffset);
    score10Label.color = ccc3(78,24,10);
    y -= yoffset;
    
    CCMenuItem *score20MenuItem = [CCMenuItemImage 
                                   itemFromNormalImage:@"menu_buttons.png" selectedImage:@"menu_buttons_down.png" 
                                   target:self selector:@selector(record20Points)];
    score20MenuItem.position = ccp(xalign, y);
    
    CCLabelTTF *score20Label = [CCLabelTTF labelWithString:@"Score 20" fontName:@"Futura-Medium" fontSize:40];
    score20Label.position = ccp(txtxalign,y+txtyoffset);
    score20Label.color = ccc3(78,24,10);
    y -= yoffset;
    
    CCMenuItem *score50MenuItem = [CCMenuItemImage 
                                   itemFromNormalImage:@"menu_buttons.png" selectedImage:@"menu_buttons_down.png" 
                                   target:self selector:@selector(record50Points)];
    score50MenuItem.position = ccp(xalign, y);
    
    CCLabelTTF *score50Label = [CCLabelTTF labelWithString:@"50 points / 2 touchdowns" fontName:@"Futura-Medium" fontSize:30];
    score50Label.position = ccp(txtxalign,y+txtyoffset);
    score50Label.color = ccc3(78,24,10);
    y -= (yoffset+gap);
    
    CCMenuItem *statsMenuItem = [CCMenuItemImage 
                                 itemFromNormalImage:@"menu_buttons.png" selectedImage:@"menu_buttons_down.png" 
                                 target:self selector:@selector(invokeResults)];
    statsMenuItem.position = ccp(xalign, y);
    
    CCLabelTTF *statsLabel = [CCLabelTTF labelWithString:@"Stats" fontName:@"Futura-Medium" fontSize:40];
    statsLabel.position = ccp(txtxalign,y+txtyoffset);
    statsLabel.color = ccc3(78,24,10);
    y -= (yoffset+gap);

    CCMenuItem *logoutMenuItem = [CCMenuItemImage 
                                 itemFromNormalImage:@"menu_buttons.png" selectedImage:@"menu_buttons_down.png" 
                                 target:self selector:@selector(invokeLogout)];
    logoutMenuItem.position = ccp(xalign, y);
    
    CCLabelTTF *logoutLabel = [CCLabelTTF labelWithString:@"Logout" fontName:@"Futura-Medium" fontSize:40];
    logoutLabel.position = ccp(txtxalign,y+txtyoffset);
    logoutLabel.color = ccc3(78,24,10);
    y -= yoffset;

    
    CCMenu *menu = [CCMenu menuWithItems:pickerMenuItem, score10MenuItem, score20MenuItem, score50MenuItem, statsMenuItem, logoutMenuItem, nil];
    [self addChild:menu];
    [self addChild:statsLabel];
    [self addChild:pickerLabel];
    [self addChild:score10Label];
    [self addChild:score20Label];
    [self addChild:score50Label];
    [self addChild:logoutLabel];
}

- (void) invokePicker
{
    [self tp_log:@"Team picker"];
    [[CCDirector sharedDirector] pause];
    [[TeamPlay sharedTeamPlay] invokePicker:^(int status, id result) {
        [[CCDirector sharedDirector] resume];
    }];
}

- (void) recordPoints:(int)points
{
    [self tp_log:@"Record points"];
    NSNumber *value = [[NSNumber alloc] initWithInt:points];
    [[TeamPlay sharedTeamPlay] recordScore:value againstField:trackedObjectId1 callback:^(int status, id results){}];
}

- (void) recordPoints:(int)points andTouchdowns:(int)touchdowns
{
    [self tp_log:@"Record points and touchdowns"];
    NSNumber *npoints = [[NSNumber alloc] initWithInt:points];
    NSNumber *ntouchdowns = [[NSNumber alloc] initWithInt:touchdowns];
    [[TeamPlay sharedTeamPlay] recordScores:^(int status, id results){}, npoints, trackedObjectId1, ntouchdowns, trackedObjectId2, nil ];
}


- (void) record10Points { [self recordPoints:10]; }
- (void) record20Points { [self recordPoints:20]; }
- (void) record50Points { [self recordPoints:50 andTouchdowns:2]; }

- (void) invokeResults
{
    [self tp_log:@"Stats"];
    [[CCDirector sharedDirector] pause];
    [[TeamPlay sharedTeamPlay] invokeResults:^(int status, id result) {
        [[CCDirector sharedDirector] resume];
    }];
}

- (void) invokeLogout
{
    [self tp_log:@"Logout"];
    [[TeamPlay sharedTeamPlay] logout:^(int status, id result) {
        [self authenticate];
    }];
}

- (void) tp_log:(NSString *)msg
{
    int maxwidth = 70;
    
    NSArray *lines = [msg componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines)
    {
        NSMutableString *mline = [line mutableCopy];
        
        int l = [mline length];
        for (int i = maxwidth; i < l; i += maxwidth) {
            [mline insertString:@"\n" atIndex:i];
        }       

        NSArray *mlines = [mline componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        for (NSString *ml in mlines)
        {
            CCLabelTTF *row = [[CCLabelTTF alloc] initWithString:ml fontName:@"Courier" fontSize:12];
            row.anchorPoint = ccp(0.0f, 0.0f);
            row.position = ccp(3.0f, 3.0f);
            row.color = ccc3(121,198,122);
            
            for (int i = 0; i < [self.rows count]; i++) {
                CCLabelTTF *r = [self.rows objectAtIndex:i];
                r.position = ccp(r.position.x, r.position.y + row.boundingBox.size.height);
            }
            
            [self.rows insertObject:row atIndex:0];
            [self addChild:row z:1.0f];
        }
    }
    
    for (int i = 0; i < [self.rows count]; i++) {
        CCLabelTTF *r = [self.rows objectAtIndex:i];
        r.position = ccp(r.position.x, r.position.y + 3.0f);
    }

}


- (void) dealloc
{
	[super dealloc];
}
@end
