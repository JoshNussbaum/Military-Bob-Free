//
//  PointsLabel.m
//  Military Bob
//
//  Created by Josh on 10/2/14.
//  Copyright (c) 2014 Josh Nussbaum. All rights reserved.
//

#import "PointsLabel.h"

@implementation PointsLabel

+ (id)pointsLabelWithFontNamed:(NSString *)fontName{
    PointsLabel *pointsLabel = [PointsLabel labelNodeWithFontNamed:fontName];
    pointsLabel.text = @"0";
    pointsLabel.number = 0;
    return pointsLabel;
    
}

-(void)increment:(NSInteger )score{
    self.number = score;
    self.text = [NSString stringWithFormat:@"%zi", self.number];
    
}

-(void)setPoints:(int)points{
    self.number = points;
    self.text = [NSString stringWithFormat:@"%zi", self.number];
}

@end
