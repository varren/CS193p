//
//  DataSource.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "DataSource.h"
#import "FlickrFetcher.h"
@interface DataSource()
@property (strong, nonatomic) NSArray* latestUpdateCachedResults;
@property (strong, nonatomic) NSMutableArray* recentPhotos;
@property (strong, nonatomic) NSMutableArray* internalFavoritePhotos;

@end

@implementation DataSource;

#pragma mark - Singletone

static DataSource *sharedSingleton;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[DataSource alloc] init];
    }
}

+(DataSource *) instance{
    return sharedSingleton;
}

#pragma mark - Properties

-(NSArray *) latestUpdateCachedResults{
    if(!_latestUpdateCachedResults){
        _latestUpdateCachedResults = [FlickrFetcher stanfordPhotos];
        NSLog(@"%@", _latestUpdateCachedResults);
    }
    
    return _latestUpdateCachedResults;
}

-(NSMutableArray*) recentPhotos{
    if(!_recentPhotos)_recentPhotos = [NSMutableArray array];
    return _recentPhotos;
}

-(NSMutableArray*) internalFavoritePhotos{
    if(!_internalFavoritePhotos)_internalFavoritePhotos = [NSMutableArray array];
    return _internalFavoritePhotos;
}
#pragma mark - Implementation

-(NSArray *)possibleTags{
    NSMutableArray * tags = [NSMutableArray array];
    
    for(NSDictionary * photoInfo in self.latestUpdateCachedResults){
        NSArray * currentTags = [photoInfo[FLICKR_TAGS] componentsSeparatedByString:@" "];
        for (NSString* tag in currentTags) 
            if(![tags containsObject:tag])
                [tags addObject:tag];
    }
    
    return tags;
}
-(NSArray *)photosForTags: (NSArray*) tags{
    
    NSMutableArray * tagedPhotos = [NSMutableArray  array];
    
    for(NSString* tag in tags)
        [tagedPhotos addObject: [self photosForTag:tag from: self.latestUpdateCachedResults]];
    
    return tagedPhotos;
}


-(NSArray*) photosForTag:(NSString*) tag from:(NSArray*) allPhotos{
    
    NSMutableArray * taggedPhotos = [NSMutableArray array];
    
    for(NSDictionary * photoInfo in allPhotos){
        NSArray * currentTags = [photoInfo[FLICKR_TAGS] componentsSeparatedByString:@" "];
        if([currentTags containsObject:tag])
            [taggedPhotos addObject: photoInfo];
    }
    
    return taggedPhotos;

}

-(NSArray *) recentlyViewedPhotos{
    return self.recentPhotos;
}

#define MAX_RECENT_PHOTOS_SAVED 20
-(void) addRecentlyViewedPhoto:(NSDictionary *) photo{
    NSMutableArray * recent = [[NSMutableArray alloc] initWithObjects:photo, nil];

    if([self.recentPhotos containsObject:photo])
        [self.recentPhotos removeObject:photo];

    if([self.recentPhotos count] >= MAX_RECENT_PHOTOS_SAVED)
         [self.recentPhotos removeObject:[self.recentPhotos lastObject]];

    [recent addObjectsFromArray: self.recentPhotos];
    
    self.recentPhotos = recent;
}


-(NSArray *) favoritePhotos{
    return self.internalFavoritePhotos;
}

-(void)addFavoritePhoto:(NSDictionary *) photo{
    if(![self.internalFavoritePhotos containsObject:photo])
        [self.internalFavoritePhotos addObject:photo];
}

-(void)removeFromFavorite:(NSDictionary *)photo{
    if([self.internalFavoritePhotos containsObject:photo])
        [self.internalFavoritePhotos removeObject:photo];
}
@end
