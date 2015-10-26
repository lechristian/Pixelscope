//
//  PSSelectionViewController.h
//  Pixelscope
//
//  Created by Paul Moulton on 10/12/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

@import UIKit;

#import "PTDBean.h"


@interface PSSelectionViewController : UIViewController <PTDBeanDelegate>

@property (strong, nonatomic) PTDBean *bean;

@end
