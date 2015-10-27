//
//  PSPixelImage.h
//  Pixelscope
//
//  Created by Paul Moulton on 10/19/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

@import Foundation;
@import UIKit;

/* To add a new pattern
    * Add an entry to the enum Pattern.
    * Add the name to patternTitles.
    * Add the colors to getColors.
 */

typedef NS_ENUM(NSUInteger, Pattern) {
    PatternNone = 0,
    PatternRainbow = 1,
    PatternCal = 2,
    PatternCow = 3
};


@interface PSPixelImage : NSObject

@property (nonatomic) UIImage *image;
@property (nonatomic) Pattern pattern;

- (NSArray<UIColor *> *)getColors;
+ (NSArray<NSString *> *)patternTitles;

@end
