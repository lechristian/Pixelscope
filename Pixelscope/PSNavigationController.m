//
//  PSNavigationController.m
//  Pixelscope
//
//  Created by Paul Moulton on 10/12/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

#import "PSNavigationController.h"

#import "PSStyling.h"

@implementation PSNavigationController

- (void)viewDidLoad {
    self.navigationBar.barTintColor = [PSStyling darkAccentColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[PSStyling navigationBarFontColor]};
    self.navigationBar.translucent = NO;
    self.navigationBar.barStyle = UIBarStyleBlack;
}

@end
