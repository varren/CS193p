//
//  FavoritePhotosCDTVC.m
//  SPoT
//
//  Created by mmh on 22/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "FavoritePhotosCDTVC.h"
#import "SharedDocument.h"

@implementation FavoritePhotosCDTVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchResultsController];
    
}

#define RECENT_PHOTOS_LIMIT 20

-(void) setupFetchResultsController{
    
    if([SharedDocument instance].document.managedObjectContext){
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"accessDate" ascending:NO selector:@selector(compare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"favourite == YES AND tags.@count > 0"];
        request.fetchLimit = RECENT_PHOTOS_LIMIT;
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[SharedDocument instance].document.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        
    }else{
        
        
        self.fetchedResultsController = nil;
    }
}
@end
