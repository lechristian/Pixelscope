//
//  PSPixelImage.m
//  Pixelscope
//
//  Created by Paul Moulton on 10/19/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

#import "PSPixelImage.h"

#import "PSStyling.h"


@implementation PSPixelImage

- (instancetype)init
{
    if (self = [super init]) {
        _pattern = PatternNone;
    }
    return self;
}

#pragma mark Image

- (void)setImage:(UIImage *)image
{
    _pattern = PatternNone;
}

#pragma mark Pattern

+ (NSArray<NSString *> *)patternTitles
{
    return @[ @"None", @"Rainbow", @"Cal", @"Cow" ];
}

- (NSArray<UIColor *> *)getColors
{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:60];
    switch (self.pattern) {
        case PatternRainbow:
            ;
            float increment = 1.0 / 40.0;
            float hue = 0.0;
            for (int i = 0; i < 60; i++) {
                UIColor *color = [UIColor colorWithHue:fmodf(hue, 1.0) saturation:1.0 brightness:1.0 alpha:1.0];
                colors[i] = color;
                hue += increment;
            }
            break;

        case PatternCal:
            for (int i = 0; i < 60; i++) {
                if (i % 30 < 15) {
                    UIColor *color = [UIColor colorWithRed:4 / 255.0 green:30 / 255.0 blue:66 / 255.0 alpha:1.0];
                    colors[i] = color;
                } else {
                    UIColor *color = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:44 / 255.0 alpha:1.0];
                    colors[i] = color;
                }
            }
            break;

        case PatternCow:
            for (int i = 0; i < 60; i++) {
                if (i % 10 < 5) {
                    UIColor *color = [UIColor darkGrayColor];
                    colors[i] = color;
                } else {
                    UIColor *color = [UIColor whiteColor];
                    colors[i] = color;
                }
            }
            break;

        default:
            break;
    }
    return colors;
}


@end
