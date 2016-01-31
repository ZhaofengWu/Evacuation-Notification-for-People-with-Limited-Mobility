//
//  InformationTableViewController.m
//  Emercuate
//
//  Created by 吴肇锋 on 1/30/16.
//  Copyright © 2016 RescueBots. All rights reserved.
//

#import "InformationTableViewController.h"

#define LabelTag 1
#define TextFieldTag 2

typedef NS_ENUM(NSUInteger, CellType) {
    TextCell = 1,
    AddressCell = 2,
    IndividualAddressCell = 3,
    AddAddressCell = 4,
};

@interface InformationTableViewController ()

@property BOOL expanded;

@end

@implementation InformationTableViewController

- (void)viewDidLoad {
    self.expanded = NO;
    [Information initialize];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"unwind"]) {
        NSArray *entries = [Information entries];
        for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i++) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            UITextField *textField;
            for (UIView *view in cell.contentView.subviews) {
                if (view.tag == 2) {
                    textField = view;
                }
            }
            for (UIView *view in cell.contentView.subviews) {
                if (view.tag == 1) {
                    NSString *title = ((UILabel *)view).text;
                    NSLog(@"titltetttt: %@", title);
                    if (![title isEqualToString:@"Address"] && [entries containsObject:title]) {
                        [Information setValue:textField.text forEntry:title];
                    }
                }
            }
        }
        [Information save];
        [Information initialize];
    }
}

- (CellType)typeOfCellAtPath:(NSIndexPath *)indexPath {
    NSLog(@"check type");
    CellType type = TextCell;
    NSLog(@"expanded: %d", self.expanded);
    NSLog(@"type: %d", type);
    if (!self.expanded) {
        if ([((NSString *)[Information entries][indexPath.row]) isEqualToString:@"Address"]) {
            type = AddressCell;
        }
    } else {
        int count = [Information addressCount];
        NSLog(@"count: %d", count);
        NSLog(@"row: %d", indexPath.row);
        for (int i = 1; i <= count; i++) {
            NSLog(@"i: %d", i);
            //NSLog(@"%@", [Information entries][indexPath.row - i]);
            // TODO: fix!!!!
            if (indexPath.row >= i && indexPath.row - i < [[Information entries] count] && [((NSString *)[Information entries][indexPath.row - i]) isEqualToString:@"Address"]) {
                type = IndividualAddressCell;
                break;
            }
        }
        NSLog(@"type: %d", type);
        if (indexPath.row >= count + 1 && indexPath.row - count - 1 < [[Information entries] count] && [((NSString *)[Information entries][indexPath.row - count - 1]) isEqualToString:@"Address"]) {
            type = AddAddressCell;
        }
        if (indexPath.row == 1) {
            type = AddressCell;
        }
    }
    NSLog(@"type: %d", type);
    return type;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expanded ? [Information count] + [Information addressCount] + 1 : [Information count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    switch ([self typeOfCellAtPath:indexPath]) {
        case TextCell:
            identifier = @"TextCell";
            break;
        case AddressCell:
            identifier = @"AddressCell";
            break;
        case IndividualAddressCell:
            identifier = @"IndividualAddressCell";
            break;
        case AddAddressCell:
            identifier = @"AddAddressCell";
            break;
            
        default:
            break;
    }
    NSLog(@"mid1");
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:identifier
                             forIndexPath:indexPath];
    UILabel *label;
    UITextField *textField;
    for (UIView *view in cell.contentView.subviews) {
        switch (view.tag) {
            case LabelTag:
                label = (UILabel *)view;
                break;
            case TextFieldTag:
                textField = (UITextField *)view;
                break;
                
            default:
                break;
        }
    }
    NSLog(@"mid2");
    switch ([self typeOfCellAtPath:indexPath]) {
        case TextCell:
            NSLog(@"text");
            int idx = indexPath.row;
            NSLog(@"idx: %d", idx);
            if (self.expanded && idx > 1) {
                idx -= [Information addressCount] + 1;
            }
            label.text = [Information entries][idx];
            textField.text = [[Information information] valueForKey:[Information entries][idx]];
            break;
        case AddressCell:
            break;
        case IndividualAddressCell:
            // TODO: make this cleaner
            NSLog(@"break here");
            NSLog(@"%@", [[Information valueForEntry:@"Address"] allKeys][indexPath.row - 2]);
            label.text = [[Information valueForEntry:@"Address"] allKeys][indexPath.row - 2];
            //NSLog(@"chosen: %d", [Information chosenAddressIdx]);
            NSLog(@"row: %d", indexPath.row);
            cell.accessoryType = [label.text isEqualToString:[Information chosenAddressName]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            NSLog(@"no actually");
            break;
        case AddAddressCell:
            break;
            
        default:
            break;
    }
    NSLog(@"mid3");
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([self typeOfCellAtPath:indexPath]) {
        case AddressCell: {
            NSLog(@"select address");
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.tableView beginUpdates];
            NSMutableArray *paths = [NSMutableArray new];
            for (int i = 0; i < [Information addressCount]; i++) {
                [paths addObject:[NSIndexPath indexPathForRow:indexPath.row + i + 1 inSection:0]];
            }
            [paths addObject:[NSIndexPath indexPathForRow:indexPath.row + [Information addressCount] + 1 inSection:0]];
            if (self.expanded) {
                NSLog(@"expanded");
                self.expanded = NO;
                [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                NSLog(@"not expanded");
                self.expanded = YES;
                [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [self.tableView endUpdates];
            break;
        }
        case IndividualAddressCell: {
            NSLog(@"oho");
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *name;
            for (UIView *view in cell.contentView.subviews) {
                if (view.tag == 1) {
                    name = ((UILabel *)view).text;
                }
            }
            [Information chooseAddress:name];
            NSLog(@"hoo");
            [self.tableView reloadData];
            NSLog(@"ooh");
            break;
        }
        case AddAddressCell: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add an address" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"Name";
            }];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"Street";
            }];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"Room/Level";
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSArray *addresses = alert.textFields;
                [Information addAddressByName:((UITextField *)addresses[0]).text street:((UITextField *)addresses[1]).text room:((UITextField *)addresses[2]).text];
                NSLog(@"to reload");
                [self.tableView reloadData];
                NSLog(@"reloaded");
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES];
                NSLog(@"selected");
            }];
            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
            
        default:
            break;
    }
}

@end
