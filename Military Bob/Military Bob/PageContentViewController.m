//
//  PageContentViewController.m
//  Military Bob
//
//  Created by Josh on 5/3/15.
//  Copyright (c) 2015 Josh Nussbaum. All rights reserved.
//

#import "PageContentViewController.h"


@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImage.image = [UIImage imageNamed:self.imageFile];
}

@end
