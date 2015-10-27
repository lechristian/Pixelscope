//
//  PSPixelImage.m
//  Pixelscope
//
//  Created by Paul Moulton on 10/19/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

#import "PSPixelImage.h"

#import "PSStyling.h"

@interface PSPixelImage ()

@property (nonatomic, strong) NSMutableArray *imageColors;

@end

@implementation PSPixelImage

- (instancetype)init
{
    if (self = [super init]) {
        _pattern = PatternNone;
        _image = nil;
        _imageColors = nil;
    }
    return self;
}

#pragma mark Image

- (void)setImage:(UIImage *)image {
    _pattern = PatternNone;
    _image = image;
    _imageColors = [self getImageAsPixels];
}

- (BOOL)hasImage {
    return _image ? YES : NO;
}

- (NSMutableArray *)getImageAsPixels {
    if (!_image) {
        return nil;
    }
    
    CGImageRef imageRef = [self resizeImage];
    int width = (int) CGImageGetWidth(imageRef);
    int height = (int) CGImageGetHeight(imageRef);
    
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:(width * height)];
    
    CGContextRef ctx = [self createARGBBitmapContextFromImage:imageRef];
    unsigned char *data = CGBitmapContextGetData(ctx);
    
    if (data != NULL) {
        for (int y = 0; y < height; y += 1) {
            for (int x = 0; x < width; x += 1) {
                int offset = 4 * ((y * width) + x);
                int red = data[offset + 1];
                int green = data[offset + 2];
                int blue = data[offset + 3];
                [colors addObject:[UIColor colorWithRed:red
                                                 green:green
                                                  blue:blue
                                                  alpha:1]];
            }
        }
    }
    
    CGContextRelease(ctx);
    if (data) {
        free(data);
    }
    
    return colors;
}

- (CGImageRef)resizeImage {
    CGImageRef imageRef = _image.CGImage;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    int scale = 60 / height;
    
    CGColorSpaceRef colorspace = CGImageGetColorSpace(imageRef);
    CGContextRef ctx = CGBitmapContextCreate(NULL, width * scale, 60,
                                             CGImageGetBitsPerComponent(imageRef),
                                             CGImageGetBytesPerRow(imageRef),
                                             colorspace,
                                             CGImageGetAlphaInfo(imageRef)
                                             );
    CGColorSpaceRelease(colorspace);
    
    if (ctx == NULL) {
        return nil;
    }
    
    CGContextDrawImage(ctx, CGRectMake(0, 0, width * scale, 60), imageRef);
    CGImageRef imgRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    return imgRef;
}

- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow = ((int) pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * (int) pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL) {
        fprintf(stderr,"Error allocating color space\n");
        return NULL;
    }
    
    bitmapData = malloc(bitmapByteCount);
    if (bitmapData == NULL) {
        fprintf(stderr, "Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    context = CGBitmapContextCreate(bitmapData,
                                    pixelsWide,
                                    pixelsHigh,
                                    8,
                                    bitmapBytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        free(bitmapData);
        fprintf(stderr,"Context not created!");
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

#pragma mark Pattern

+ (NSArray<NSString *> *)patternTitles
{
    return @[ @"None", @"Rainbow", @"Cal", @"Cow" ];
}

- (NSArray<UIColor *> *)getColors
{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:60];
    switch (_pattern) {
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
        
        case PatternNone:
            if ([self hasImage]) {
                colors = _imageColors;
            }
            break;

        default:
            break;
    }
    return colors;
}


@end
