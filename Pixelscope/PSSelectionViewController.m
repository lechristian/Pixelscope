//
//  PSSelectionViewController.m
//  Pixelscope
//
//  Created by Paul Moulton on 10/12/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

#import "PSSelectionViewController.h"

#import "PSPatternDataSource.h"
#import "PSPixelImage.h"
#import "PSStyling.h"

#import "PTDBeanManager.h"

@import AVFoundation;
@import QuartzCore;


@interface PSSelectionViewController () <PSPatternDataSourceDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) PSPixelImage *pixelImage;
@property (strong, nonatomic) PSPatternDataSource *dataSource;

@property (strong, nonatomic) UIImageView *pixelView;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImagePickerController *pickerController;

@property (nonatomic, strong) UIButton *pixelStartButton;

@property (nonatomic, strong) PTDBeanManager *beanManager;

@end


@implementation PSSelectionViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"Pixelscope";
        self.view.backgroundColor = [PSStyling lightAccentColor];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_pickPhotoFromGallery)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        
        // Bean
        self.bean.delegate = self;
        [self.bean releaseSerialGate];

        _pixelImage = [[PSPixelImage alloc] init];
        _dataSource = [[PSPatternDataSource alloc] init];

        _pixelView = [[UIImageView alloc] init];
        _gradientLayer = [CAGradientLayer layer];
        _tableView = [[UITableView alloc] init];
        _pickerController = [[UIImagePickerController alloc] init];

        _pickerController.delegate = self;
        _dataSource.delegate = self;
        _tableView.delegate = _dataSource;
        _tableView.dataSource = _dataSource;
        
        _pixelStartButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_pixelStartButton setTitle:@"Start" forState:UIControlStateNormal];
        [_pixelStartButton setTitle:@"Started" forState:UIControlStateDisabled];
        [_pixelStartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pixelStartButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_pixelStartButton addTarget:self action:@selector(sendPixelImageToBean) forControlEvents:UIControlEventTouchUpInside];
        [_pixelStartButton setTranslatesAutoresizingMaskIntoConstraints:NO];

        // ImageView Selector
        [_pixelView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_pickPhotoFromGallery)];
        [singleTap setNumberOfTapsRequired:1];
        [_pixelView addGestureRecognizer:singleTap];
        _pixelView.contentMode = UIViewContentModeScaleAspectFill;

        [self.pixelView.layer insertSublayer:_gradientLayer atIndex:0];
        [self.view addSubview:_pixelView];
        [self.view addSubview:_tableView];
        [self.view addSubview:_pixelStartButton];

        [self _installConstraints];
    }
    return self;
}

#pragma mark PSPatternDataSourceDelegate

- (void)updatePixelImageForPattern:(Pattern)pattern
{
    self.pixelImage.pattern = pattern;
    self.pixelView.image = nil;

    if (pattern == PatternNone) {
        self.gradientLayer.colors = nil;
    } else {
        NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:60];
        for (UIColor *color in self.pixelImage.getColors) {
            [colors addObject:(id)color.CGColor];
        }
        self.gradientLayer.frame = self.pixelView.bounds;
        self.gradientLayer.colors = colors;
    }
}

#pragma mark UIImagePicker

- (void)_pickPhotoFromGallery
{
    self.pickerController.allowsEditing = NO;
    self.pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:self.pickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    self.pixelView.image = selectedImage;
    self.gradientLayer.colors = nil;

    [self.tableView.delegate tableView:self.tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.previousIndex inSection:0]];
    self.dataSource.previousIndex = -1;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Bean Delegate

- (void)bean:(PTDBean *)bean serialDataReceived:(NSData *)data {
    if (((uint8_t *)data.bytes)[0] == 0x01) {
        //TODO: Handle data receieved
    }
}

#pragma mark Selectors

- (void)sendPixelImageToBean {
    // Disable button until image is over
    _pixelStartButton.enabled = NO;
    // Send pixels to bean
}

#pragma mark Constraints

- (void)_installConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_pixelView, _tableView, _pixelStartButton);
    _pixelView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *metrics = @{
                              @"innerPadding" : @(15),
                              @"marginPadding" : @(20)
                              };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-marginPadding-[_pixelView]-marginPadding-[_tableView]-marginPadding-[_pixelStartButton]-marginPadding-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pixelView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_pixelView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_pixelView]-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_tableView]-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_pixelStartButton]-|" options:0 metrics:metrics views:views]];
}

@end
