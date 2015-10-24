//
//  PSConnectViewController.m
//  Pixelscope
//
//  Created by Christian Le on 10/19/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

@import AVFoundation;

#import "PSConnectViewController.h"
#import "PSStyling.h"
#import "PTDBeanManager.h"
#import "PTDBean.h"

static NSString *PSAvailableBeanCellIdentifier = @"PSAvailableBeanCellIdentifier";

@interface PSConnectViewController () <PTDBeanManagerDelegate, PTDBeanDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property UITableView *availableDevicesTableView;
@property PTDBeanManager *beanManager;
@property PTDBean *bean;
@property NSMutableArray *beans;

@end

@implementation PSConnectViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Available Connections";
        self.view.backgroundColor = [PSStyling lightAccentColor];
        self.beans = [NSMutableArray new];
        _availableDevicesTableView = [[UITableView alloc] init];
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_availableDevicesTableView];
        
        [self _installConstraints];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beanManager = [[PTDBeanManager alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.beanManager disconnectFromAllBeans:nil];
    [self reloadBeans:nil];
}

- (void)_installConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_availableDevicesTableView);
    _availableDevicesTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_availableDevicesTableView]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_availableDevicesTableView]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.beans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    PTDBean *bean;
    
    cell = [tableView dequeueReusableCellWithIdentifier:PSAvailableBeanCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PSAvailableBeanCellIdentifier];
    }
    
    bean = self.beans[indexPath.row];
    
    [cell.textLabel setText:bean.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self connectBean:self.beans[indexPath.row]];
    [self.availableDevicesTableView reloadData];
    [self.beanManager stopScanningForBeans_error:nil];
}

#pragma mark - Bean Manager Delegate
- (void)beanManagerDidUpdateState:(PTDBeanManager *)beanManager {
    if (self.beanManager.state == BeanManagerState_PoweredOn) {
        [self startScan];
    }
}

- (void)beanManager:(PTDBeanManager *)beanManager didDiscoverBean:(PTDBean *)bean error:(NSError *)error {
    if (![self.beans containsObject:bean]) {
        [self.beans addObject:bean];
        [self.availableDevicesTableView reloadData];
    }
}

#pragma mark - Bluetooth
- (void)startScan {
    NSError *error;
    [self.beanManager startScanningForBeans_error:&error];
    
    if (error && error.code == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Bluetooth Required"
                                                                       message:@"Enable Bluetooth in iOS Settings."
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)connectBean:(PTDBean *)bean {
    NSError *error;
    [self.beanManager connectToBean:bean error:&error];
    if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could not connect to bean"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSLog(@"connected to %@", bean.name);
    }
}

- (void)reloadBeans:(id)sender {
    self.beans = [NSMutableArray array];
    [self.availableDevicesTableView reloadData];
    if ([self.beanManager state] == BeanManagerState_PoweredOn) {
        [self startScan];
    }
}

@end
