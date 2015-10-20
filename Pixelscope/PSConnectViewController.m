//
//  PSConnectViewController.m
//  Pixelscope
//
//  Created by Christian Le on 10/19/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

#import "PSConnectViewController.h"
#import "PSStyling.h"

@interface PSConnectViewController ()

@property UITableView *availableDevicesTableView;

@end

@implementation PSConnectViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Available Connections";
        self.view.backgroundColor = [PSStyling lightAccentColor];
        
        _availableDevicesTableView = [[UITableView alloc] init];
        
        [self.view addSubview:_availableDevicesTableView];
        
        [self _installConstraints];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
         
- (void)_installConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_availableDevicesTableView);
    _availableDevicesTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_availableDevicesTableView]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_availableDevicesTableView]-|" options:0 metrics:nil views:views]];
}

@end
