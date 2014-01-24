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
        if(self.tag.name == [Tag allTag]){
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
            request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"mainTag" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
            request.predicate = [NSPredicate predicateWithFormat:@"ANY tags == %@", self.tag];
            
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.tag.managedObjectContext sectionNameKeyPath:@"mainTag" cacheName:nil];
            
        }else{
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
            request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
            request.predicate = [NSPredicate predicateWithFormat:@"ANY tags == %@", self.tag];
            
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.tag.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
        }
    }else{
        self.fetchedResultsController = nil;
    }
}

@end
