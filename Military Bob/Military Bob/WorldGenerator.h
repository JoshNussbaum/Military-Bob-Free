//
//  WorldGenerator.h
//  Military Bob
//
//  Created by Josh on 10/1/14.
//  Copyright (c) 2014 Josh Nussbaum. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WorldGenerator : SKNode

+(id)generatorWithWorld:(SKNode *)world;


-(void)populate;

-(void)generate:(int)i;

@end
