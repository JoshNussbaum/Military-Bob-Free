//
//  Hero.h
//  Military Bob
//
//  Created by Josh on 10/1/14.
//  Copyright (c) 2014 Josh Nussbaum. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Hero : SKSpriteNode

+(id)hero;

-(void)boost1;

-(void)boost2;

-(void)boost4;

-(void)boost5;

-(void)slow;

-(void)start:(double)angle :(float)multiplier;

-(void)stop;

- (void)attachDebugRectWithSize:(CGSize)s;

- (void)attachDebugFrameFromPath:(CGPathRef)bodyPath;

@end
