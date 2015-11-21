//
//  GameViewController.h
//  Military Bob
//

//  Copyright (c) 2014 Josh Nussbaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
@import GameKit;


@interface GameViewController : UIViewController <GKGameCenterControllerDelegate, ADBannerViewDelegate>{
    
}
@property (strong, nonatomic) IBOutlet ADBannerView *adBanner;



@end
