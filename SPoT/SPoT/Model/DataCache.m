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
@property (strong, nonatomic) NSArray *listOfCachedPhotos;

@property (atomic) NSInteger networkActivities;

@property (strong, nonatomic) NSString * cachedPhotosDIR;
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

#pragma mark - Cached Photos

@synthesize listOfCachedPhotos = _listOfCachedPhotos;

#define CACHED_PHOTOS_KEY @"ListOfCachedPhotos"
-(void) setListOfCachedPhotos:(NSArray *)listOfCachedPhotos{
    _listOfCachedPhotos = listOfCachedPhotos;
    [[NSUserDefaults standardUserDefaults] setObject:listOfCachedPhotos forKey:CACHED_PHOTOS_KEY];
}

-(NSArray*)listOfCachedPhotos{
    if(!_listOfCachedPhotos){
        _listOfCachedPhotos = [[NSUserDefaults standardUserDefaults] valueForKey:CACHED_PHOTOS_KEY];
        if(!_listOfCachedPhotos) _listOfCachedPhotos = [NSArray array];
    }
    return _listOfCachedPhotos;
}

#define CACHED_PHOTOS_DIR_NAME @"CachedPhotos"
-(NSString*) cachedPhotosDIR{
    if(!_cachedPhotosDIR){
        NSString * cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        _cachedPhotosDIR =  [cache stringByAppendingPathComponent:CACHED_PHOTOS_DIR_NAME];
    
        NSFileManager * fileManager = [NSFileManager defaultManager];
    
        if (![fileManager fileExistsAtPath:_cachedPhotosDIR]) {
            [fileManager createDirectoryAtPath:_cachedPhotosDIR withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    
    return _cachedPhotosDIR;
}

-(unsigned long long) cachedDirSize{
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSArray * photos = [fm contentsOfDirectoryAtPath:self.cachedPhotosDIR error:NO];
    unsigned long long dirSize = 0;
    for (NSString * photoName in photos) {
        NSString* photoPath = [self.cachedPhotosDIR stringByAppendingPathComponent:photoName];
        dirSize += [[fm attributesOfItemAtPath:photoPath error:NO] fileSize];

    }
    NSLog(@"Cache size is: %llu KB",dirSize/1024);
    return dirSize;
}

-(NSData*) getPhotoFromCacheByID:(NSString *)ID{
    NSData * neededPhoto = nil;
    
    if([self.listOfCachedPhotos containsObject:ID]){
        NSString * photoPath = [self.cachedPhotosDIR stringByAppendingPathComponent:ID];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:photoPath])
            neededPhoto = [NSData dataWithContentsOfFile:photoPath];
    }
    NSLog(@"Getting %@ photo \n result is %@", ID, neededPhoto ? @"cached" : @"not cached");
    NSLog(@"%@", self.listOfCachedPhotos);
    return neededPhoto;
}

#define MAX_CACHE_SIZE 2 * 1024 * 1024
-(void) cachePhoto: (NSData*) photo withID:(NSString*) ID{
    if(![self.listOfCachedPhotos containsObject:ID]){
        NSLog(@"Saving %@ photo", ID);
        NSLog(@"%@", self.listOfCachedPhotos);
    
    
    
    NSMutableArray* mutablePhotosList =  [self.listOfCachedPhotos mutableCopy];
    [mutablePhotosList addObject:ID];
    self.listOfCachedPhotos = mutablePhotosList;
    
    NSString * photoPath = [[self cachedPhotosDIR] stringByAppendingPathComponent:ID];
    [photo writeToFile: photoPath atomically:YES];

    
    //Remove oldest cached photo if needed
    while([self cachedDirSize] > MAX_CACHE_SIZE){
        if([self.listOfCachedPhotos count] > 0){
            NSString * oldestPhotoPath = [[self cachedPhotosDIR] stringByAppendingPathComponent:self.listOfCachedPhotos[0]];
            [[NSFileManager defaultManager] removeItemAtPath:oldestPhotoPath error: NO];
        
            NSMutableArray* mutablePhotosList = [self.listOfCachedPhotos mutableCopy];
            [mutablePhotosList removeObjectAtIndex:0];
            self.listOfCachedPhotos = mutablePhotosList;
        }

    }
    
    
    }
}

-(void)resetCache{
    [[NSFileManager defaultManager] removeItemAtPath:self.cachedPhotosDIR error:NO];
    self.listOfCachedPhotos = nil;
}


#pragma mark - Recent Photos
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
#pragma mark - Favorite Photos
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
        NSData *imageData = [self getPhotoFromCacheByID:[[imageURL path] lastPathComponent]];
        
        if(!imageData) {
            imageData = [self loadImageFromNet:imageURL];
            [self cachePhoto:imageData withID: [[imageURL path] lastPathComponent]];
        }
       
        image = [[UIImage alloc] initWithData:imageData];
    }
    return image;
}

-(NSData*)loadImageFromNet: (NSURL *) imageURL{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.networkActivities++;
    [NSThread sleepForTimeInterval:2.0];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    self.networkActivities--;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = self.networkActivities ? YES: NO;
    
    return imageData;
}

@end
