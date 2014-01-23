//
//  DemoTagCDTVC.m
//  SPoT
//
//  Created by mmh on 22/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "DemoTagCDTVC.h"
#import "DataCache.h"
#import "Photo+Flickr.h"

@implementation DemoTagCDTVC

-(IBAction)refresh{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t flickrFetchQueue = dispatch_queue_create("Flickr Fetch Queue", NULL);
    dispatch_async(flickrFetchQueue, ^{
        NSArray * photosInfo = [[DataCache instance] loadPhotosInfoFromNet];
        NSLog(@"Loaded photos fine");
        [self.managedObjectContext performBlock:^{
            for (NSDictionary* photoDictionary in photosInfo)
                [Photo photoWithFlickrInfo:photoDictionary inManagedObjectContext:self.managedObjectContext];
           
            NSLog(@"Saved Fine");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}

-(void) viewDidLoad{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.managedObjectContext)[self useDemoDocument];
    
}

-(void)useDemoDocument{
    NSURL * url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Demo Document"];
    UIManagedDocument* document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if(success){
                self.managedObjectContext = document.managedObjectContext;
                [self refresh];
            }
            
        }];
    }else if(document.documentState == UIDocumentStateClosed){
        [document openWithCompletionHandler:^(BOOL success) {
            if(success){
                self.managedObjectContext = document.managedObjectContext;

            }
        }];
    
    }else{
           self.managedObjectContext = document.managedObjectContext;
    }
}
@end
