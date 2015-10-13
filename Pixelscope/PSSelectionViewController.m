//
//  PSPixelSelectionViewController.m
//  Pixelscope
//
//  Created by Paul Moulton on 10/12/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

#import "PSSelectionViewController.h"

#import "PSStyling.h"

@interface PSSelectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property UIImagePickerController *pickerController;
@property UIImageView *pixelImageView;
@property UITableView *presetsTableView;

@end

@implementation PSSelectionViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Pixelscope";
        self.view.backgroundColor = [PSStyling lightAccentColor];

        _pickerController = [[UIImagePickerController alloc] init];
        _pixelImageView = [[UIImageView alloc] init];
        _presetsTableView = [[UITableView alloc] init];

        _pickerController.delegate = self;

        // ImageView Selector
        [_pixelImageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_pickPhotoFromGallery)];
        [singleTap setNumberOfTapsRequired:1];
        [_pixelImageView addGestureRecognizer:singleTap];

        [self.view addSubview:_pixelImageView];
        [self.view addSubview:_presetsTableView];

        [self _installConstraints];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark UIImagePicker

- (void)_pickPhotoFromGallery {
    self.pickerController.allowsEditing = NO;
    self.pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:self.pickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    self.pixelImageView.image = selectedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark InstallConstraints

- (void)_installConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_pixelImageView, _presetsTableView);
    _pixelImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _presetsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *metrics = @{@"vertPadding": @(15)};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vertPadding-[_pixelImageView]-[_presetsTableView]-vertPadding-|" options:0 metrics:metrics views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pixelImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_pixelImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_pixelImageView]-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_presetsTableView]-|" options:0 metrics:metrics views:views]];
}

@end
