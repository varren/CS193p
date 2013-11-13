//
//  FlickrDataTVC.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "FlickrImagesTVC.h"
#import "DataSource.h"
#import "FlickrFetcher.h"

@interface FlickrImagesTVC ()

@end

@implementation FlickrImagesTVC

-(void)setPhotos:(NSArray *)photos{
    _photos = photos;
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITableViewCell * senderCell = (UITableViewCell*)sender;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:senderCell];
    NSDictionary * photoInfo = self.photos[indexPath.row];
    
    [[DataSource instance] addRecentlyViewedPhoto:photoInfo];
    
    [segue.destinationViewController setTitle:photoInfo[FLICKR_PHOTO_TITLE]];
    [segue.destinationViewController performSelector:@selector(setImage:) withObject:photoInfo];
  
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary * photoInfo = self.photos[indexPath.row];    
    cell.textLabel.text = photoInfo[FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photoInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}


@end
