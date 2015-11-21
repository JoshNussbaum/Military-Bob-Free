//
//  Hero.m
//  Military Bob
//
//  Created by Josh on 10/1/14.
//  Copyright (c) 2014 Josh Nussbaum. All rights reserved.
//

#import "Hero.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface Hero ()
@end


@implementation Hero

static const uint32_t heroCategory = 0x1 << 0;
static const uint32_t groundCategory = 0x1 << 1;
static const uint32_t obstacleCategory1 = 0x1 << 2;
static const uint32_t obstacleCategory2 = 0x1 << 3;
static const uint32_t obstacleCategory3 = 0x1 << 4;
static const uint32_t obstacleCategory4 = 0x1 << 5;
static const uint32_t obstacleCategory5 = 0x1 << 6;
static const uint32_t obstacleCategory6 = 0x1 << 7;
static const uint32_t obstacleCategory7 = 0x1 << 8;


+(id)hero{
    Hero *hero = [Hero spriteNodeWithImageNamed:@"bob4.png"];
    hero.name=@"hero";
    hero.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:35.0];
    hero.physicsBody.usesPreciseCollisionDetection = YES;
    hero.physicsBody.categoryBitMask = heroCategory;
    hero.physicsBody.collisionBitMask = groundCategory; // obstacleCategory4 | obstacleCategory5 |
    hero.physicsBody.contactTestBitMask = obstacleCategory1 | obstacleCategory2 | obstacleCategory3 | obstacleCategory4| obstacleCategory5 |obstacleCategory6 | obstacleCategory7 | groundCategory;
    hero.physicsBody.dynamic = NO;
    //hero.physicsBody.restitution = 0.25;
    hero.physicsBody.friction = 0.28;
    hero.physicsBody.density = 1.33;
    hero.hidden = YES;
    hero.physicsBody.allowsRotation = NO;
    return hero;
    
}

-(void)start:(double)angle :(float)multiplier{
    float multVal = 4 * multiplier / 10;
    
    if (multVal < 1) multVal = 1;
    
    self.hidden = NO;
    self.physicsBody.dynamic = YES;
    double xmult = cos(angle);
    double ymult = 1 - xmult;
    
    double xvelocity = (xmult * multVal) * 170;
    double yvelocity = (ymult * multVal) * 125;
    
    float count = 0;
    if (multiplier < 5.0){
        count = 2;
    }
    else count = 3;
    
    [self.physicsBody applyImpulse:CGVectorMake(xvelocity, yvelocity)];
    SKAction *rotation = [SKAction rotateByAngle: -2.0*M_PI duration:0.30];
    SKAction *repeat = [SKAction repeatAction:rotation count:count];
    [self runAction: repeat];
}

-(void)boost1{
    float yvelocity = fabs(self.physicsBody.velocity.dy);
    float xvelocity = fabs(self.physicsBody.velocity.dx);
    // Make the vector
    float newx;
    float newy;
    
    // Set Y Velocity
    if (yvelocity < 100){
        newy = 100;
    }
    if (yvelocity < 200) {
        newy = 150;
    }else if (yvelocity < 300){
        newy = 300;
    } else if (yvelocity < 500){
        newy = 400;
    } else if (yvelocity < 700){
        newy = 400;
    }
    else if (yvelocity < 100){
        newy = 500;
    }
    else if (yvelocity < 1200){
        newy = 600;
    }
    else if (yvelocity < 1400){
        newy = 800;
    }
    else if (yvelocity < 2000){
        newy = 1000;
    }
    else if (yvelocity < 2500){
        newy = 1300;
    }
    else if (yvelocity < 3000){
        newy = 1600;
    }
    else if (yvelocity < 3600){
        newy = 2000;
    }
    else if (yvelocity < 4300){
        newy = 2100;
    }
    else if (yvelocity < 5000){
        newy = 2400;
    }
    else newy = 2500;
    
    // Set X Velocity
    if (xvelocity < 100){
        newx = 250;
    }
    if (xvelocity < 200) {
        newx = 300;
    }else if (xvelocity < 300){
        newx = 400;
    } else if (xvelocity < 500){
        newx = 600;
    } else if (xvelocity < 700){
        newx = 800;
    }
    else if (xvelocity < 1000){
        newx = 900;
    }
    else if (xvelocity < 1400){
        newx = 1350;
    }
    else if (xvelocity < 1800){
        newx = 1750;
    }
    else if (xvelocity < 2200){
        newx = 2200;
    }
    else if (xvelocity < 3000){
        newx = 3000;
    }
    else if (xvelocity < 4000){
        newx = 3750;
    }
    else if (xvelocity < 5000){
        newx = 4250;
    }
    else if (xvelocity < 6000){
        newx = 4750;
    }
    else if (xvelocity < 7000){
        newx = 5250;
    }
    else if (xvelocity < 8000){
        newx = 5500;
    }
    else newx = 6000;
    
    self.physicsBody.velocity = CGVectorMake(newx, newy);
    
    SKAction *rotation = [SKAction rotateByAngle: -2.0*M_PI duration:0.4];
    SKAction *repeat = [SKAction repeatAction:rotation count:6];
    [self runAction: repeat];
    [self.physicsBody applyImpulse:CGVectorMake(320, 250)];
}

-(void)boost2{
    float yvelocity = fabs(self.physicsBody.velocity.dy);
    float xvelocity = fabs(self.physicsBody.velocity.dx);
    // Make the vectoy
    float newx;
    float newy;
    
    // Set Y Velocity
    if (yvelocity < 100){
        newy = 100;
    }
    if (yvelocity < 200) {
        newy = 150;
    }else if (yvelocity < 300){
        newy = 300;
    } else if (yvelocity < 500){
        newy = 400;
    } else if (yvelocity < 800){
        newy = 600;
    }
    else if (yvelocity < 1200){
        newy = 1000;
    }
    else if (yvelocity < 1600){
        newy = 1200;
    } else newy = 1400;
    
    // Set X Velocity
    if (xvelocity < 100){
        newx = 150;
    }
    if (xvelocity < 200) {
        newx = 200;
    }else if (xvelocity < 300){
        newx = 250;
    } else if (xvelocity < 500){
        newx = 450;
    } else if (xvelocity < 800){
        newx = 650;
    }
    else if (xvelocity < 1200){
        newx = 850;
    }
    else if (xvelocity < 1600){
        newx = 1050;
    } if (xvelocity < 2000){
        newx = 1250;
    }else newx = 1450;
    NSLog(@"Old velocity mine -> (%f, %f)", xvelocity, yvelocity);
    
    NSLog(@"New velocity mine -> (%f, %f)", newx, newy);
    
    self.physicsBody.velocity = CGVectorMake(newx, newy);
    
    SKAction *rotation = [SKAction rotateByAngle: -2.0*M_PI duration:0.4];
    SKAction *repeat = [SKAction repeatAction:rotation count:8];
    [self runAction: repeat];
    [self.physicsBody applyImpulse:CGVectorMake(260, 210)];
    
    
    
    
}

-(void)boost4{
    [self.physicsBody applyImpulse:CGVectorMake(5, 0)];
}

-(void)boost5{
    SKAction *rotation = [SKAction rotateByAngle: -2.0*M_PI duration:0.16];
    SKAction *repeat = [SKAction repeatAction:rotation count:7];
    [self runAction: repeat];
    [self.physicsBody applyImpulse:CGVectorMake(350, 280)];
}

-(void)slow{
    // Don't know what node we hit - slow down?
}

-(void)stop{
    [self removeAllActions];
    self.physicsBody.dynamic = NO;
}

@end
