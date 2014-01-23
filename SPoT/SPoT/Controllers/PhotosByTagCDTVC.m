//
//  PhotosCDTVC.m
//  SPoT
//
//  Created by mmh on 22/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "PhotosByTagCDTVC.h"
#import "Photo.h"
@implementation PhotosByTagCDTVC

-(void)setTag:(Tag*)tag{
    _tag = tag;
    [self setupFetchResultsController];
    
}
#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath * indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if([segue.identifier isEqualToString:@"setImageURL:"]
           && [segue.destinationViewController respondsToSelector:@selector(setImageURL:)]){
            
            Photo * photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
            NSURL* url = [NSURL URLWithString: photo.imgURL];
            
            [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
            
        }
    }
}

-(void) setupFetchResultsController{
    
    if(self.tag.managedObjectContext){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"ANY tags == %@", self.tag];
         NSLog(@"before fetch");
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.tag.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        NSLog(@"after fetch");
    }else{
        self.fetchedResultsController = nil;
    }
    
    
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    
    Photo* photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
    return cell;
}

@end
