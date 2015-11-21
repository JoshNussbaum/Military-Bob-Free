//
//  GameKitHelper.h
//  Military Bob
//
//  Created by Josh on 4/19/15.
//  Copyright (c) 2015 Josh Nussbaum. All rights reserved.
//

@import GameKit;

extern NSString *const PresentAuthenticationViewController;

@interface GameKitHelper : NSObject

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

+ (instancetype)sharedGameKitHelper;

- (void)authenticateLocalPlayer;

-(void)reportScore:(float)score;


@end