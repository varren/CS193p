//
//  DataSource.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "DataCache.h"

@interface DataCache()
@property (strong, nonatomic) NSArray* recentPhotos;
@property (strong, nonatomic) NSArray* favoritePhotos;
@property (atomic) NSInteger networkActivities;

@end

@implementation DataCache;

#pragma mark - Singletone

static DataCache *sharedSingleton;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[DataCache alloc] init];
    }
}

+(DataCache *) instance{
    return sharedSingleton;
}

#pragma mark - Properties


@synthesize recentPhotos = _recentPhotos;

#define RECENT_PHOTOS_KEY @"Recent Photos"

-(NSArray*) recentPhotos{
    if(!_recentPhotos)_recentPhotos = [[NSUserDefaults standardUserDefaults] valueForKey:RECENT_PHOTOS_KEY] ;
    return _recentPhotos;
}

-(void)setRecentPhotos:(NSArray *)recentPhotos{
    _recentPhotos = recentPhotos;
    [[NSUserDefaults standardUserDefaults] setObject:recentPhotos forKey:RECENT_PHOTOS_KEY];
}

@synthesize  favoritePhotos = _favoritePhotos;

#define FAVORITE_PHOTOS_KEY @"Favorite Photos"

-(NSArray*) favoritePhotos{
   
    if(!_favoritePhotos){
        _favoritePhotos = [[NSUserDefaults standardUserDefaults] valueForKey:FAVORITE_PHOTOS_KEY];
        if(!_favoritePhotos) _favoritePhotos = [NSArray array];
    }
    return _favoritePhotos;
}

-(void)setFavoritePhotos:(NSArray *)favoritePhotos{
    _favoritePhotos = favoritePhotos;
    [[NSUserDefaults standardUserDefaults] setObject:favoritePhotos forKey:FAVORITE_PHOTOS_KEY];
    
}

#pragma mark - Implementation


-(NSArray *) recentlyViewedPhotos{
    return self.recentPhotos;
}

#define MAX_RECENT_PHOTOS_SAVED 20
-(void) addRecentlyViewedPhoto:(NSDictionary *) photo{
    NSMutableArray * recent = [[NSMutableArray alloc] initWithObjects:photo, nil];

    for (NSDictionary * oldPhoto in self.recentPhotos) {
        if([recent count] >= MAX_RECENT_PHOTOS_SAVED) break;
        if(![oldPhoto isEqualToDictionary:photo])
            [recent addObject:oldPhoto];
    }

    self.recentPhotos = recent;
}

-(void)addFavoritePhoto:(NSDictionary *) photo{
    if(![self.favoritePhotos containsObject:photo]){
        NSMutableArray * mutableFavorit = [self.favoritePhotos mutableCopy];
        [mutableFavorit addObject:photo];
        self.favoritePhotos = mutableFavorit;
    }
}

-(void)removeFromFavorite:(NSDictionary *)photo{
    if([self.favoritePhotos containsObject:photo]){
        NSMutableArray * mutableFavorit = [self.favoritePhotos mutableCopy];
        [mutableFavorit removeObject:photo];	
        self.favoritePhotos = mutableFavorit;
    }
}

-(UIImage *) getImage: (NSURL *) imageURL{
    
    UIImage * image = nil;
    if(imageURL){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        self.networkActivities++;
        [NSThread sleepForTimeInterval:2.0];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
        self.networkActivities--;

        [UIApplication sharedApplication].networkActivityIndicatorVisible = self.networkActivities ? YES: NO;
    
        image = [[UIImage alloc] initWithData:imageData];
    }
    return image;
}

@end
