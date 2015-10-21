//
//  PSPatternDataSource.m
//  Pixelscope
//
//  Created by Paul Moulton on 10/20/15.
//  Copyright © 2015 innovativedesign. All rights reserved.
//

#import "PSPatternDataSource.h"

#import "PSPixelImage.h"
#import "PSStyling.h"


@interface PSPatternDataSource ()

@property (strong, nonatomic) UIImage *radioButtonChecked;
@property (strong, nonatomic) UIImage *radioButtonUnchecked;

@end


@implementation PSPatternDataSource

- (instancetype)init
{
    if (self = [super init]) {
        _previousIndex = 0;
        _radioButtonChecked = [UIImage imageNamed:@"radio_checked"];
        _radioButtonUnchecked = [UIImage imageNamed:@"radio_unchecked"];
    }
    return self;
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [PSPixelImage patternTitles].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [PSPixelImage patternTitles][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    UIImageView *radioButton;
    if (indexPath.row == self.previousIndex) {
        radioButton = [[UIImageView alloc] initWithImage:[self.radioButtonChecked imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    } else {
        radioButton = [[UIImageView alloc] initWithImage:[self.radioButtonUnchecked imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    radioButton.tintColor = [PSStyling accentColor];
    cell.accessoryView = radioButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *radioButton = [[UIImageView alloc] initWithImage:[self.radioButtonUnchecked imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    radioButton.tintColor = [PSStyling accentColor];
    cell.accessoryView = radioButton;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate updatePixelImageForPattern:(Pattern)indexPath.row];

    if (self.previousIndex == indexPath.row) {
        return;
    }

    UIImageView *radioButton;

    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    radioButton = [[UIImageView alloc] initWithImage:[self.radioButtonChecked imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    radioButton.tintColor = [PSStyling accentColor];
    newCell.accessoryView = radioButton;

    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.previousIndex inSection:0];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    radioButton = [[UIImageView alloc] initWithImage:[self.radioButtonUnchecked imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    radioButton.tintColor = [PSStyling accentColor];
    oldCell.accessoryView = radioButton;

    self.previousIndex = indexPath.row;
}

@end
