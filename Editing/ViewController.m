//
//  ViewController.m
//  Editing
//
//  Created by Admin on 14.01.19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import "Group.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray* groupsArray;

@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groupsArray = [NSMutableArray array];
    
    for(int i = 0; i < 5; i++)
    {
        Group* group = [[Group alloc] init];
        group.name = [NSString stringWithFormat:@"Group %d", i];
        
        NSMutableArray* tempArray = [NSMutableArray array];
        
        for(int j = 0; j < 5; j++)
        {
            [tempArray addObject:[Student randomStudent]];
        }
        
        group.students = tempArray;
        
        [self.groupsArray addObject:group];
    }
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groupsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Group* group = [self.groupsArray objectAtIndex:section];
    return [group.students count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Group* group = [self.groupsArray objectAtIndex:section];
    return group.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* addIdentifier = @"Add cell";
    
    if(indexPath.row == 0)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addIdentifier];
        }
        cell.textLabel.text = @"Add student";
        cell.textLabel.textColor = [UIColor blueColor];
        
        return cell;
    }
    else
    {
        Group* group = [self.groupsArray objectAtIndex:indexPath.section];
        Student* student = [group.students objectAtIndex:indexPath.row - 1];
    
        static NSString* identifier = @"Cell";
    
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
    
        cell.textLabel.text = student.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)student.mark];
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? NO : YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Group* sourceGroup = [self.groupsArray objectAtIndex:sourceIndexPath.section];
    Student* sourceStudent = [sourceGroup.students objectAtIndex:sourceIndexPath.row - 1];
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
    
    if(sourceIndexPath.section == destinationIndexPath.section)
    {
        [tempArray exchangeObjectAtIndex:sourceIndexPath.row-1 withObjectAtIndex:destinationIndexPath.row-1];
        sourceGroup.students = tempArray;
    }
    else
    {
        [tempArray removeObject:sourceStudent];
        sourceGroup.students = tempArray;
        
        Group* destinationGroup = [self.groupsArray objectAtIndex:destinationIndexPath.section];
        
        tempArray = [NSMutableArray arrayWithArray:destinationGroup.students];
        [tempArray insertObject:sourceStudent atIndex:destinationIndexPath.row-1];
        
        destinationGroup.students = tempArray;
    }
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        Group* group = [self.groupsArray objectAtIndex:indexPath.section];
        Student* student = [group.students objectAtIndex:indexPath.row - 1];
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:group.students];
        
        [tempArray removeObject:student];
        group.students = tempArray;
        
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        [self.tableView endUpdates];
        
        
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if(proposedDestinationIndexPath.row == 0)
        return sourceIndexPath;
    else
        return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0)
    {
        Group* group = [self.groupsArray objectAtIndex:indexPath.section];
        Student* newStudent = [Student randomStudent];
        
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:group.students];
        [tempArray insertObject:newStudent atIndex:0];
        group.students = tempArray;
        
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        
        [self.tableView beginUpdates];
        
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.tableView endUpdates];
        
    }
}

#pragma mark - Actions

- (IBAction)editButton:(id)sender
{
    BOOL isEditing = [self.tableView isEditing];
    
    [self.tableView setEditing:!isEditing animated:YES];
}

- (IBAction)addButton:(id)sender
{
    NSMutableArray* tempArray = [NSMutableArray array];
    Group* newGroup = [[Group alloc] init];
    
    for(int i = 0; i < 5; i ++)
    {
        Student* student = [Student randomStudent];
        [tempArray addObject:student];
    }
    
    newGroup.name = [NSString stringWithFormat:@"Group %lu", (unsigned long)[self.groupsArray count]];
    newGroup.students = tempArray;
    
    [self.groupsArray insertObject:newGroup atIndex:0];
    
    [self.tableView beginUpdates];
    
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:0];
    
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
}
@end
