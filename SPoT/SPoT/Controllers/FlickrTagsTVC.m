//
//  FlickrTagsTVC.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "FlickrTagsTVC.h"
#import "DataSource.h"

@interface FlickrTagsTVC ()
@property (strong, nonatomic) NSArray * photosForTag;
@end
@implementation FlickrTagsTVC

@synthesize tags = _tags;
-(void)setTags:(NSArray *)tags{
    _tags = tags;
    self.photosForTag = nil;
    [self.tableView reloadData];
}

#define IGNORE_TAGS @[@"cs193pspot",@"portrait", @"landscape"]
-(NSArray *)tags{
    if(!_tags){
        NSMutableArray * tags =  [NSMutableArray array];
        
        for (NSString* tag in [[DataSource instance] possibleTags]) 
            if(![IGNORE_TAGS containsObject:tag])
                [tags addObject:tag];
            
        _tags = [tags sortedArrayUsingSelector:@selector(compare:)];
    }
    return _tags;
}

-(NSArray*) photosForTag{
    if(!_photosForTag)_photosForTag = [[DataSource instance] photosForTags:self.tags];
    return _photosForTag;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITableViewCell * senderCell = (UITableViewCell*)sender;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:senderCell];

    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:self.photosForTag[indexPath.row]];
    [segue.destinationViewController  setTitle:[self.tags[indexPath.row] capitalizedString]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.tags[indexPath.row] capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [self.photosForTag[indexPath.row] count]];
    
    return cell;
}


@end
