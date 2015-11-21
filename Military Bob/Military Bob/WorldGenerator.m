//
//  WorldGenerator.m
//  Military Bob
//
//  Created by Josh on 10/1/14.
//  Copyright (c) 2014 Josh Nussbaum. All rights reserved.
//

#import "WorldGenerator.h"


static int phoneType;

@interface WorldGenerator ()
@property double currentGroundX;
@property double currentObstacleX;
@property SKNode *world;
@end

@implementation WorldGenerator

static const uint32_t heroCategory = 0x1 << 0;
static const uint32_t groundCategory = 0x1 << 1;
static const uint32_t obstacleCategory1 = 0x1 << 2;
static const uint32_t obstacleCategory2 = 0x1 << 3;
static const uint32_t obstacleCategory3 = 0x1 << 4;
static const uint32_t obstacleCategory4 = 0x1 << 5;
static const uint32_t obstacleCategory5 = 0x1 << 6;
static const uint32_t obstacleCategory6 = 0x1 << 7;
static const uint32_t obstacleCategory7 = 0x1 << 8;
static const uint32_t obstacleCategory8 = 0x1 << 9;



+(id)generatorWithWorld:(SKNode *)world {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float height = screenSize.width;
    if (height == 480)
    {
        phoneType = 0;
    }
    else if (height == 568)
    {
        phoneType = 1;
        
    }
    else if (height == 667)
    {
        phoneType = 2;
    }
    else if (height == 736)
    {
        phoneType = 3;
    }
    WorldGenerator *generator = [WorldGenerator node];
    generator.currentGroundX = 0;
    generator.currentObstacleX = 500;
    generator.world = world;
    return generator;
}

-(void)populate {
    for (int i=0; i<150; i++)
    {
        [self generate:i];
    }
}

-(float) randomNumber {
    float randomNumber = arc4random() % 50;
    int multiplier =  (rand() % 2) * 2 - 1;
    randomNumber *= multiplier;
    randomNumber += 90;
    return randomNumber;
    
}

-(void)generate:(int)i {
    
    int size = 100;
    if (phoneType == 0) size = 150;
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:70/255.0 green:160/255.0 blue:30.0/255.0 alpha:1.0] size:CGSizeMake(568, size)];
    ground.name=@"ground";
    CGPoint groundPos;
    if (phoneType == 0){
        groundPos = CGPointMake(self.currentGroundX - 500, -self.scene.frame.size.height/2 + ground.size.height/4.5 - 15);
    }
    else if (phoneType == 1){
        groundPos = CGPointMake(self.currentGroundX-500, -self.scene.frame.size.height/2 + ground.frame.size.height/2.0);
    }
    else if (phoneType == 2){
        groundPos = CGPointMake(self.currentGroundX-500, -self.scene.frame.size.height/2 + ground.frame.size.height/2.0);
    }
    else if (phoneType == 3){
        groundPos = CGPointMake(self.currentGroundX-500, -self.scene.frame.size.height/2 + ground.frame.size.height/2.0 - 10);
    }
    else{
        groundPos = CGPointMake(self.currentGroundX-500, -self.scene.frame.size.height/2 + ground.frame.size.height/2.0);
    }
    
    ground.position = groundPos;
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    
    ground.physicsBody.categoryBitMask = groundCategory;
    
    ground.physicsBody.dynamic = NO;
    ground.physicsBody.friction = 0.30;
    ground.physicsBody.restitution = 0.62;
    [self.world addChild:ground];
    self.currentGroundX += ground.frame.size.width;
    
    if (!((i+1) % 5 == 0)) {
        SKSpriteNode *obstacle1 = [SKSpriteNode spriteNodeWithImageNamed:@"grenade2.png"];
        obstacle1.name=@"obstacle";
        obstacle1.position = CGPointMake(self.currentObstacleX + 150, ground.position.y + ground.frame.size.height/2 + obstacle1.frame.size.height/2 );
        CGSize grenadeSize = CGSizeMake(obstacle1.size.width, obstacle1.size.height);
        obstacle1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:grenadeSize];
        obstacle1.physicsBody.categoryBitMask = obstacleCategory1;
        obstacle1.physicsBody.contactTestBitMask = heroCategory;
        obstacle1.physicsBody.dynamic = NO;
        [self.world addChild:obstacle1];
    }
    else {
        if (!((i+1) % 14 == 0)) {
            SKSpriteNode *obstacle8 = [SKSpriteNode spriteNodeWithImageNamed:@"ice.png"];
            obstacle8.name=@"obstacle";
            obstacle8.position = CGPointMake(self.currentObstacleX  + 140, -2 + ground.position.y + ground.frame.size.height/2 + obstacle8.frame.size.height/2);
            
            obstacle8.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:6+obstacle8.size.width/2];
            
            
            obstacle8.physicsBody.categoryBitMask = obstacleCategory8;
            obstacle8.physicsBody.contactTestBitMask = heroCategory;
            
            
            obstacle8.physicsBody.dynamic = NO;
            [self.world addChild:obstacle8];
        }
        
    }
    
    
    
    
    if (!((i+1) % 3 == 0)){
        SKSpriteNode *obstacle4 = [SKSpriteNode spriteNodeWithImageNamed:@"spikes.PNG"];
        obstacle4.name=@"obstacle";
        
        obstacle4.position = CGPointMake(self.currentObstacleX + 660, ground.position.y - 4 + ground.frame.size.height/2 + obstacle4.frame.size.height/2 );
        CGSize spikeSize = CGSizeMake(obstacle4.size.width-30, obstacle4.size.height-40);
        obstacle4.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spikeSize];
        obstacle4.physicsBody.categoryBitMask = obstacleCategory4;
        obstacle4.physicsBody.contactTestBitMask = heroCategory;
        obstacle4.physicsBody.dynamic = NO;
        [self.world addChild:obstacle4];
    }
    else {
        SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithImageNamed:@"cloud.png"];
        cloud.position = CGPointMake(self.currentObstacleX + 750, 140);
        cloud.zPosition = 1;
        [self.world addChild:cloud];
        
        SKSpriteNode *obstacle6 = [SKSpriteNode spriteNodeWithImageNamed:@"rifle2.png"];
        obstacle6.name=@"obstacle";
        obstacle6.position = CGPointMake(self.currentObstacleX + 750, ground.position.y + ground.frame.size.height/2 + obstacle6.frame.size.height);
        
        obstacle6.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(obstacle6.size.width-2, obstacle6.size.height)];
        
        obstacle6.physicsBody.categoryBitMask = obstacleCategory6;
        obstacle6.physicsBody.contactTestBitMask = heroCategory;
        
        obstacle6.physicsBody.dynamic = NO;
        [self.world addChild:obstacle6];
    }
    
    if (!((i+1) % 3 == 0)){
        // Floating Mine
        float randomNumber = [self randomNumber];
        if (i == 0){
            randomNumber = 130;
        }
        SKSpriteNode *obstacle2 = [SKSpriteNode spriteNodeWithImageNamed:@"floatingMine.png"];
        obstacle2.name=@"obstacle";
        obstacle2.position = CGPointMake(self.currentObstacleX + 1400, ground.position.y + ground.frame.size.height/2 + obstacle2.frame.size.height + randomNumber);
        
        obstacle2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(obstacle2.size.width - 43, obstacle2.size.height - 19)];
        
        obstacle2.physicsBody.categoryBitMask = obstacleCategory2;
        obstacle2.physicsBody.contactTestBitMask = heroCategory;
        
        obstacle2.physicsBody.dynamic = NO;
        [self.world addChild:obstacle2];
    }
    else {
        SKSpriteNode *obstacle5 = [SKSpriteNode spriteNodeWithImageNamed:@"volcano.PNG"];
        obstacle5.name=@"obstacle";
        obstacle5.position = CGPointMake(self.currentObstacleX + 1350, ground.position.y -2 + ground.frame.size.height/2 + obstacle5.frame.size.height/2 - 6);
        CGSize volcanoSize = CGSizeMake(obstacle5.size.width-50, obstacle5.size.height-75);
        obstacle5.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:volcanoSize];
        //obstacle5.zPosition = 2.0;
        obstacle5.physicsBody.categoryBitMask = obstacleCategory5;
        obstacle5.physicsBody.contactTestBitMask = heroCategory;
        
        obstacle5.physicsBody.dynamic = NO;
        [self.world addChild:obstacle5];
    }
    if ((i+1) % 14 == 0) {
        SKSpriteNode *star = [SKSpriteNode spriteNodeWithImageNamed:@"star.png"];
        star.position = CGPointMake(self.currentObstacleX + 1700, 150);
        star.zPosition = 0;
        [self.world addChild:star];
        
        SKSpriteNode *obstacle3 = [SKSpriteNode spriteNodeWithImageNamed:@"jetpack2.png"];
        obstacle3.name=@"obstacle";
        obstacle3.position = CGPointMake(self.currentObstacleX  + 1700, 5 + ground.position.y + ground.frame.size.height/2 + obstacle3.frame.size.height/2);
        
        obstacle3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(obstacle3.size.width -5 , obstacle3.size.height - 5)];
        
        
        obstacle3.physicsBody.categoryBitMask = obstacleCategory3;
        obstacle3.physicsBody.contactTestBitMask = heroCategory;
        
        
        obstacle3.physicsBody.dynamic = NO;
        [self.world addChild:obstacle3];
        
    }
    
    if (groundPos.x < 1000 && i== 0){
        SKSpriteNode *obstacle6 = [SKSpriteNode spriteNodeWithImageNamed:@"rifle2.png"];
        obstacle6.name=@"obstacle";
        obstacle6.position = CGPointMake(self.currentObstacleX + 1150, ground.position.y + ground.frame.size.height/2 + obstacle6.frame.size.height);
        
        obstacle6.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(obstacle6.size.width-2, obstacle6.size.height)];
        
        obstacle6.physicsBody.categoryBitMask = obstacleCategory6;
        obstacle6.physicsBody.contactTestBitMask = heroCategory;
        
        obstacle6.physicsBody.dynamic = NO;
        [self.world addChild:obstacle6];
        
        SKSpriteNode *obstacle3 = [SKSpriteNode spriteNodeWithImageNamed:@"jetpack2.png"];
        obstacle3.name=@"obstacle";
        obstacle3.position = CGPointMake(self.currentObstacleX  + 1750, 5 + ground.position.y + ground.frame.size.height/2 + obstacle3.frame.size.height/2);
        
        obstacle3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(obstacle3.size.width - 5, obstacle3.size.height - 5)];
        
        
        obstacle3.physicsBody.categoryBitMask = obstacleCategory3;
        obstacle3.physicsBody.contactTestBitMask = heroCategory;
        
        
        obstacle3.physicsBody.dynamic = NO;
        [self.world addChild:obstacle3];
        
        SKSpriteNode *obstacle8 = [SKSpriteNode spriteNodeWithImageNamed:@"ice.png"];
        obstacle8.name=@"obstacle";
        obstacle8.position = CGPointMake(self.currentObstacleX , -2 + ground.position.y + ground.frame.size.height/2 + obstacle8.frame.size.height/2);
        
        obstacle8.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:4+obstacle8.size.width/2];
        
        
        obstacle8.physicsBody.categoryBitMask = obstacleCategory8;
        obstacle8.physicsBody.contactTestBitMask = heroCategory;
        
        
        obstacle8.physicsBody.dynamic = NO;
        [self.world addChild:obstacle8];
    }
    
    if ((i+1) % 35 == 0) {
        
        SKSpriteNode *obstacle7 = [SKSpriteNode spriteNodeWithImageNamed:@"Bob.PNG"];
        obstacle7.name=@"obstacle";
        obstacle7.position = CGPointMake(self.currentObstacleX  + 1050, ground.position.y + ground.frame.size.height/2 + obstacle7.frame.size.height/4);
        
        obstacle7.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(obstacle7.size.width, obstacle7.size.height)];
        
        obstacle7.physicsBody.categoryBitMask = obstacleCategory7;
        obstacle7.physicsBody.contactTestBitMask = heroCategory;
        
        
        obstacle7.physicsBody.dynamic = NO;
        [self.world addChild:obstacle7];
        
    }
    self.currentObstacleX += 2000;
}

@end

