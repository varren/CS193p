//
//  TagCDTVC.m
//  SPoT
//
//  Created by mmh on 22/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "TagCDTVC.h"
#import "Tag.h"

@implementation TagCDTVC

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath * indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if([segue.identifier isEqualToString:@"setTag:"]){
           if([segue.destinationViewController respondsToSelector:@selector(setTag:)]){
               
            Tag * tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [segue.destinationViewController performSelector:@selector(setTag:) withObject:tag];
               
           }
        }
    }
    
}

-(void)setManagedObjectContext:(NSManagedObjectContext*) managedObjectContext{
    _managedObjectContext = managedObjectContext;

    if(managedObjectContext){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil;
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }else{
        self.fetchedResultsController = nil;
    }
    
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    
    Tag* tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tag.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@" %d photos", [tag.photos count]];

    return cell;
}

@end
