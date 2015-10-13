//
//  PSStyling.m
//  Pixelscope
//
//  Created by Paul Moulton on 10/12/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

#import "PSStyling.h"

@implementation PSStyling

+ (UIColor *)accentColor {
    return [UIColor colorWithRed:99/255.0 green:142/255.0 blue:171/255.0 alpha:1];
}

+ (UIColor *)lightAccentColor {
    return [UIColor colorWithRed:129/255.0 green:172/255.0 blue:201/255.0 alpha:1];
}

+ (UIColor *)darkAccentColor {
    return [UIColor colorWithRed:69/255.0 green:112/255.0 blue:141/255.0 alpha:1];
}

+ (UIColor *)navigationBarFontColor {
    return [UIColor whiteColor];
}

@end
