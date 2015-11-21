//
//  CustomProgressBar.m
//  Military Bob
//
//  Created by Josh on 4/11/15.
//  Copyright (c) 2015 Josh Nussbaum. All rights reserved.
//

#import "CustomProgressBar.h"


@implementation CustomProgressBar

- (id)init {
    if (self = [super init]) {
        self.maskNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(50,20)];
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(400, 100)];
        sprite.anchorPoint = CGPointMake(0, 0);
        [self addChild:sprite];
    }
    return self;
}

- (void) setProgress:(CGFloat) progress {
    self.maskNode.xScale = progress;
}

@end
