//
//  GameData.h
//  Military Bob
//
//  Created by Josh on 10/2/14.
//  Copyright (c) 2014 Josh Nussbaum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject

+(id)data;

-(void)save;
-(void)load;



@property int highscore;
@end
