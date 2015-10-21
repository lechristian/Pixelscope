//
//  PSPatternDataSource.h
//  Pixelscope
//
//  Created by Paul Moulton on 10/20/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

#import "PSPixelImage.h"

@import Foundation;
@import UIKit;

@protocol PSPatternDataSourceDelegate <NSObject>
- (void)updatePixelImageForPattern:(Pattern)pattern;
@end


@interface PSPatternDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSInteger previousIndex;
@property (weak, nonatomic) id<PSPatternDataSourceDelegate> delegate;

@end
