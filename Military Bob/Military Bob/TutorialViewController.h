//
//  TutorialViewController.h
//  Military Bob
//
//  Created by Josh on 5/3/15.
//  Copyright (c) 2015 Josh Nussbaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface TutorialViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end
