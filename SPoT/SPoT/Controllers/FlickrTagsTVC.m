//
//  FlickrTagsTVC.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "FlickrTagsTVC.h"
#import "FlickrFetcher.h"

@interface FlickrTagsTVC ()
@property (strong,nonatomic) NSArray * tags;
@property (strong,nonatomic) NSArray * taggedPhotos; // of Arrays of photos taged by tags above

@end
@implementation FlickrTagsTVC;
#pragma mark - Life Cicle

-(void)viewDidLoad{
    [super viewDidLoad];
    [self reloadData];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
}

-(void)reloadData{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t flickrFetchQueue = dispatch_queue_create("Flickr Fetch Queue", NULL);
    dispatch_async(flickrFetchQueue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
        NSArray *flickrPhotos = [FlickrFetcher stanfordPhotos];
        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tags = nil;
            self.taggedPhotos = nil;
            self.photos = flickrPhotos;
            [self.refreshControl endRefreshing];
        });
    });
}

#pragma mark - Properties

#define IGNORE_TAGS @[@"cs193pspot",@"portrait", @"landscape"]

-(NSArray *)tags{
    if(!_tags){
        NSMutableArray * tags =  [NSMutableArray array];
        
        for(NSDictionary * photoInfo in self.photos){
            NSArray * currentTags = [photoInfo[FLICKR_TAGS] componentsSeparatedByString:@" "];
            for (NSString* tag in currentTags)
                if(![tags containsObject:tag] && ![IGNORE_TAGS containsObject:tag])
                    [tags addObject:tag];
        }
        
        _tags = [tags sortedArrayUsingSelector:@selector(compare:)];
    }
    return _tags;
}

-(NSArray *)taggedPhotos{
    if(!_taggedPhotos){
        NSMutableArray * tagsArray = [NSMutableArray  array];
    
        for(NSString* tag in self.tags){
            NSMutableArray * taggedPhotos = [NSMutableArray array];
        
            for(NSDictionary * photoInfo in self.photos){
                NSArray * currentTags = [photoInfo[FLICKR_TAGS] componentsSeparatedByString:@" "];
                if([currentTags containsObject:tag])
                    [taggedPhotos addObject: photoInfo];
            }

            [tagsArray addObject: taggedPhotos];
        }
        _taggedPhotos = tagsArray;
    }
    return _taggedPhotos;
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITableViewCell * senderCell = (UITableViewCell*)sender;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:senderCell];
    
    NSArray * taggedPhotosSorted =[self.taggedPhotos[indexPath.row] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:FLICKR_PHOTO_TITLE ascending:YES]]];
    
    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:taggedPhotosSorted];
    [segue.destinationViewController  setTitle:[self.tags[indexPath.row] capitalizedString]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"InfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.tags[indexPath.row] capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [self.taggedPhotos[indexPath.row] count]];
    
    return cell;
}


@end
