//
//  PointsLabel.h
//  Military Bob
//
//  Created by Josh on 10/2/14.
//  Copyright (c) 2014 Josh Nussbaum. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PointsLabel : SKLabelNode
@property NSInteger number;

+(id)pointsLabelWithFontNamed:(NSString *)fontName;

-(void) increment:(NSInteger)score;

-(void)setPoints:(int)points;

@end
