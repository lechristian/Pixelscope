//
//  PixelSelectionViewController.m
//  Pixelscope
//
//  Created by Paul Moulton on 10/12/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

#import "PixelSelectionViewController.h"

@interface PixelSelectionViewController ()

@property UIImageView *pixelImageView;
@property UITableView *presetsTableView;

@end

@implementation PixelSelectionViewController

- (instancetype)init {
    if (self = [super init]) {
        _pixelImageView = [[UIImageView alloc] init];
        _presetsTableView = [[UITableView alloc] init];
        
        [self.view addSubview:_pixelImageView];
        [self.view addSubview:_presetsTableView];
        
        [self _installConstraints];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)_installConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_pixelImageView, _presetsTableView);
    _pixelImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _presetsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_pixelImageView]-[_presetsTableView]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_pixelImageView]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_presetsTableView]-|" options:0 metrics:nil views:views]];
}

@end
