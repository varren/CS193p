//
//  PhotosCDTVC.m
//  SPoT
//
//  Created by mmh on 22/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "PhotosCDTVC.h"
#import "Photo.h"
#import "DataCache.h"

@implementation PhotosCDTVC

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath * indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if([segue.identifier isEqualToString:@"setImageURL:"]){
            Photo * photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
            
            if([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]){
    
                NSURL* url = [NSURL URLWithString: photo.imgURL];
                photo.accessDate = [NSDate date];
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                
            }
            
            if([segue.destinationViewController respondsToSelector:@selector(setTitle:)]){
                [segue.destinationViewController performSelector:@selector(setTitle:)withObject:photo.title];
            }
            /*
            UIBarButtonItem * currentButtonItem = [[self.splitViewController.viewControllers lastObject] performSelector: @selector(splitViewBarButtonItem)];
            
            [segue.destinationViewController performSelector: @selector(setSplitViewBarButtonItem:) withObject:currentButtonItem];
            
            [segue.destinationViewController performSelector:@selector(setFavoriteButton:) withObject:[self favoriteTabBarItemForPhoto:photo]];
            */
        }
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    
    Photo* photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
    NSData * thumbImgData = photo.thumbnail;
    
    if(!thumbImgData){
        dispatch_queue_t fetchThumbnail = dispatch_queue_create("Fetch Thumbnail Queue", NULL);
        dispatch_async(fetchThumbnail, ^{        
            NSData * thumbImgData = [[DataCache instance] loadImageFromNet:[NSURL URLWithString: photo.thumbnailURL]];
            if(thumbImgData){
                photo.thumbnail = thumbImgData;
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = [[UIImage alloc] initWithData:thumbImgData];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }
    });
        
    } else{
        cell.imageView.image = [[UIImage alloc] initWithData:thumbImgData];
    }
    
    return cell;
}

/*
#pragma mark - Favorite Button

// kinda cool can create button and target action metod here and give this button to ImageScrollView to display
// probably overkill and there are better ways to do the same, but i decidet to practice segue
// done it here and not in ImageScrollView because ISV knows nothing about NSDictionary image data to save it
-(UIBarButtonItem*)favoriteTabBarItemForPhoto:(Photo*) photo{
    
    UIButton * favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoriteButton addTarget:self action:@selector(addToFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [favoriteButton setImage:[UIImage imageNamed:@"favorites-gray.png"]  forState:UIControlStateNormal];
    [favoriteButton setImage:[UIImage imageNamed:@"favorites-red.png"]  forState:UIControlStateSelected];
    [favoriteButton setFrame:CGRectMake(0, 0, 32, 32)];
    favoriteButton.selected = [photo.favourite boolValue];
    
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
*/
@end
