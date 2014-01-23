//
//  PhotosCDTVC.m
//  SPoT
//
//  Created by mmh on 22/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "PhotosByTagCDTVC.h"

@implementation PhotosByTagCDTVC

-(void)setTag:(Tag*)tag{
    _tag = tag;
    self.title = tag.name;
    [self setupFetchResultsController];
}


-(void) setupFetchResultsController{
    
    if(self.tag.managedObjectContext){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"ANY tags == %@", self.tag];

        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.tag.managedObjectContext sectionNameKeyPath:nil cacheName:nil];

    }else{
        self.fetchedResultsController = nil;
    }
}

@end
