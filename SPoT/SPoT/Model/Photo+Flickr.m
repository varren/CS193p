//
//  Photo+Flickr.m
//  SPoT
//
//  Created by mmh on 20/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Tag+Create.h"

@implementation Photo (Flickr)

+(Photo*) photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context{    

    Photo* photo = nil;
   
    //checking existing copy of this photo record in DB
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate =[NSPredicate predicateWithFormat:@"uniqueID = %@", [photoDictionary[FLICKR_PHOTO_ID] description]];
    NSError * error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    
    if(!matches || ([matches count] > 1)){
        //handle errors
    } else if (![matches count]){
        photo  = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        
        photo.title = [photoDictionary[FLICKR_PHOTO_TITLE] description];
        photo.subtitle = [[photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description];
        photo.imgURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        photo.thumbnailURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
        photo.uniqueID = [photoDictionary[FLICKR_PHOTO_ID] description];
        photo.favourite = NO;
        photo.accessDate = nil;
        photo.sectionName = [[photo.title substringToIndex: 1] uppercaseString];
        
        NSMutableArray * tags = [[photoDictionary[FLICKR_TAGS] componentsSeparatedByString:@" "] mutableCopy];
        [tags addObject:[Tag allTag]];
        [tags removeObjectsInArray:[Tag ignoredTags]];
        photo.mainTag = tags[0];
        for(NSString *tagName in tags){
            Tag *tag = [Tag tagWithName:tagName inManagedObjectContext:context];
            [photo addTagsObject:tag];
        }
        
    } else{
        photo = [matches lastObject];
    }
   
    return photo;
}


@end
