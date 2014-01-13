//
//  FlickrDataTVC.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "FlickrImagesTVC.h"
#import "DataCache.h"
#import "FlickrFetcher.h"

@interface FlickrImagesTVC ()

@end

@implementation FlickrImagesTVC

#pragma mark - Seque

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITableViewCell * senderCell = (UITableViewCell*)sender;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:senderCell];
    NSDictionary * photoInfo = self.photos[indexPath.row];
    
    [[DataCache instance] addRecentlyViewedPhoto:photoInfo];
    
    UIBarButtonItem * currentButtonItem = [[self.splitViewController.viewControllers lastObject] performSelector: @selector(splitViewBarButtonItem)];

    [segue.destinationViewController performSelector: @selector(setSplitViewBarButtonItem:) withObject:currentButtonItem];
    
    [segue.destinationViewController setTitle:photoInfo[FLICKR_PHOTO_TITLE]];
    
    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:[FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge]];
    
    [segue.destinationViewController performSelector:@selector(setFavoriteButton:) withObject:[self favoriteTabBarItemForPhoto:photoInfo]];
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

#pragma mark - Favorite Button

// kinda cool can create button and target action metod here and give this button to ImageScrollView to display
// probably overkill and there are better ways to do the same, but i decidet to practice segue
// done it here and not in ImageScrollView because ISV knows nothing about NSDictionary image data to save it
-(UIBarButtonItem*)favoriteTabBarItemForPhoto:(NSDictionary*) photo{

    UIButton * favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoriteButton addTarget:self action:@selector(addToFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [favoriteButton setImage:[UIImage imageNamed:@"favorites-gray.png"]  forState:UIControlStateNormal];
    [favoriteButton setImage:[UIImage imageNamed:@"favorites-red.png"]  forState:UIControlStateSelected];
    [favoriteButton setFrame:CGRectMake(0, 0, 32, 32)];
    favoriteButton.selected = [[[DataCache instance] favoritePhotos] containsObject:photo];

    UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:favoriteButton];
    
    return favorite;
}


- (IBAction)addToFavorite:(id)sender {
    
    if([sender isKindOfClass:[UIButton class]]){
        UIButton * favoriteButton = sender;
        NSDictionary * latestPhoto = [[DataCache instance] recentlyViewedPhotos][0];
        favoriteButton.selected ?
        [[DataCache instance] removeFromFavorite:latestPhoto]
        : [[DataCache instance] addFavoritePhoto:latestPhoto];
    
        favoriteButton.selected = !favoriteButton.selected;
    }
}


@end
