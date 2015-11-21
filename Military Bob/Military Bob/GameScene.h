//
//  GameScene.h
//  Military Bob
//

//  Copyright (c) 2014 Josh Nussbaum. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import GameKit;

@interface GameScene : SKScene <SKPhysicsContactDelegate, GKGameCenterControllerDelegate>

-(void)pause;

-(void)checkAchievements;

@end
