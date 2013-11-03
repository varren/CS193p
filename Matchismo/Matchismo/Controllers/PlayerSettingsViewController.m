//
//  PlayerSettingsViewController.m
//  Matchismo
//
//  Created by mmh on 03/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "PlayerSettingsViewController.h"
#import "Settings.h"

@interface PlayerSettingsViewController ()

@end

@implementation PlayerSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [Settings instance].numberOfPlayers;
}
#define NUMBER_OF_ROWS_IN_SECTION 1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return NUMBER_OF_ROWS_IN_SECTION;
}

#define NAME_ROW 0
#define COLOR_ROW 1

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if(indexPath.row == NAME_ROW){
        cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerNameCell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"Player %d:", indexPath.section + 1];
        cell.detailTextLabel.text = [[Settings instance] nameForPlayer:indexPath.section];
    }
    

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

#define INPUT_TEXTFIELD_INDEX 0
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * inputTitle = nil;
    NSString * predefinedText = nil;
    
    if(indexPath.row == NAME_ROW){
        inputTitle = [NSString stringWithFormat:@"Enter Player %d Name", indexPath.section + 1];
        predefinedText = [NSString stringWithFormat:@"%@", [[Settings instance] nameForPlayer: indexPath.section]];
    }
    
    
    [self askForUserInput:inputTitle
       withPredefinedText:predefinedText
                 andIDTag:indexPath.row + indexPath.section * NUMBER_OF_ROWS_IN_SECTION];
}

-(void)askForUserInput:(NSString*) inputTitle withPredefinedText:(NSString*)predefinedText andIDTag:(NSInteger) tag {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:inputTitle message:@"" delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Select", nil];
    
    alertView.tag = tag;
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alertView textFieldAtIndex:INPUT_TEXTFIELD_INDEX];
    
    alertTextField.text = predefinedText;
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex){
        NSInteger section = alertView.tag / NUMBER_OF_ROWS_IN_SECTION;
        NSInteger row = alertView.tag % NUMBER_OF_ROWS_IN_SECTION;
        if(row == NAME_ROW){
            NSString * name = [alertView textFieldAtIndex:INPUT_TEXTFIELD_INDEX].text;
            NSLog(@"Setting name: %@ in section %d for row: %d", name, section, row);
            [[Settings instance] setName:name forPlayer:section];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:row inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }
}

@end
