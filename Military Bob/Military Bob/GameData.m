//
//  GameData.m
//  Military Bob
//
//  Created by Josh on 10/2/14.
//  Copyright (c) 2014 Josh Nussbaum. All rights reserved.
//

#import "GameData.h"

@interface GameData()
@property NSString *filepath;
@end

@implementation GameData

+(id)data{
    GameData *data = [GameData new];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = @"archive.data";
    data.filepath = [path stringByAppendingPathComponent:fileName];
    //data.highscore = 0;
    return data;
}

-(void)save{
    NSNumber *highscoreObject = [NSNumber numberWithInteger:self.highscore];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:highscoreObject];
    [data writeToFile:self.filepath atomically:YES];
}

-(void)load{
    NSData *data = [NSData dataWithContentsOfFile:self.filepath];
    NSNumber *highscoreObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.highscore = highscoreObject.intValue;
}

@end
