//
//  PSPixelSelectionViewController.m
//  Pixelscope
//
//  Created by Paul Moulton on 10/12/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

#import "PSPixelSelectionViewController.h"

#import "PSStyling.h"

@interface PSPixelSelectionViewController () <UIImagePickerControllerDelegate>

@property UIImagePickerController *pickerController;
@property UIImageView *pixelImageView;
@property UITableView *presetsTableView;

@end

@implementation PSPixelSelectionViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Pixelscope";
        self.view.backgroundColor = [PSStyling lightAccentColor];

        _pickerController = [[UIImagePickerController alloc] init];
        _pixelImageView = [[UIImageView alloc] init];
        _presetsTableView = [[UITableView alloc] init];

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

}

#pragma mark InstallConstraints

- (void)_installConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_pixelImageView, _presetsTableView);
    _pixelImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _presetsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_pixelImageView]-[_presetsTableView]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_pixelImageView]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_presetsTableView]-|" options:0 metrics:nil views:views]];
}

@end
