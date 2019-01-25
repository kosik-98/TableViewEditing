//
//  ViewController.h
//  Editing
//
//  Created by Admin on 14.01.19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)editButton:(id)sender;
- (IBAction)addButton:(id)sender;


@end

