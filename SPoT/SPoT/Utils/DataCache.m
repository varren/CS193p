//
//  DataSource.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "DataCache.h"
#import "FlickrFetcher.h"
#import "UIApplication+NetworkActivity.h"

@interface DataCache()
@property (strong, nonatomic) NSString * cachedPhotosDIR;
@property (strong, nonatomic) NSData * curentPhoto;
@property (strong, nonatomic) NSURL * currentPhotoURL;
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


#pragma mark - Cached Photos


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

    return dirSize;
}


- (NSArray*) listOfCachedPhotos{

    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSURL * photosDirURL = [NSURL fileURLWithPath:self.cachedPhotosDIR];

    NSArray * photos = [fm contentsOfDirectoryAtURL:photosDirURL includingPropertiesForKeys:@[NSURLNameKey, NSURLContentAccessDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    return photos;
}

-(NSDate*) accessDateForFile:(NSURL*) file{
    NSDate * accessTime = nil;
    
    [file getResourceValue:&accessTime forKey:NSURLContentAccessDateKey error:nil];
    return accessTime;
}

-(NSData*) getPhotoContentsOfURL:(NSURL *)photoURL{

    if(photoURL == self.currentPhotoURL) return self.curentPhoto;

    NSString* photoID = [[photoURL path] lastPathComponent];
    
    NSLog(@"Getting %@ photo ", photoID);
    
    NSData * neededPhoto = nil;
    
    NSString * photoHDDPath = [self.cachedPhotosDIR stringByAppendingPathComponent:photoID];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:photoHDDPath])
        neededPhoto = [NSData dataWithContentsOfFile:photoHDDPath];
    
    
    if(!neededPhoto) {
        neededPhoto = [self loadImageFromNet:photoURL];
        
        [self cachePhoto:neededPhoto withID: photoID];
    }
    
    self.currentPhotoURL = photoURL;
    self.curentPhoto = neededPhoto;
    
    return neededPhoto;

}

#define MAX_CACHE_SIZE 2 * 1024 * 1024
-(void) cachePhoto: (NSData*) photo withID:(NSString*) ID{

    NSLog(@"Setting cache for %@ photo", ID);
    
    //Remove oldest cached photo if needed

    while([self cachedDirSize] + photo.length >= MAX_CACHE_SIZE){
        
        NSArray * photos = [self listOfCachedPhotos] ;
        
        photos = [photos sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[self accessDateForFile:obj2] compare:[self accessDateForFile:obj1]];
        }];
        
        NSString * oldestPhotoPath = [((NSURL*)[photos lastObject]) path];
        
        NSLog(@"Removing: %@ \n Size of cache of (%d + 1): %lluKB + %dKB > %dKB limit", oldestPhotoPath, [[self listOfCachedPhotos] count], [self cachedDirSize]/1024,
              photo.length/1024, MAX_CACHE_SIZE/1024);
        
        [[NSFileManager defaultManager] removeItemAtPath: oldestPhotoPath error: NO];
    }


    // saving new photo
    [photo writeToFile: [[self cachedPhotosDIR] stringByAppendingPathComponent:ID] atomically:YES];
    


}

-(void)resetCache{
    [[NSFileManager defaultManager] removeItemAtPath:self.cachedPhotosDIR error:NO];
}


-(UIImage *) getImage: (NSURL *) imageURL{
  
    UIImage * image = nil;
    if(imageURL){
        NSData *imageData = nil;
        
        @synchronized(self){
            imageData = [self getPhotoContentsOfURL:imageURL];
        }
        
        image = [[UIImage alloc] initWithData:imageData];
    }
    return image;
}

-(NSData*)loadImageFromNet: (NSURL *) imageURL{
    
    [UIApplication showNetworkActivityIndicator];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    [UIApplication hideNetworkActivityIndicator];
    
    return imageData;
}

-(NSArray* )loadPhotosInfoFromNet{
    NSArray *flickrPhotos = nil;
    
    [UIApplication showNetworkActivityIndicator];
    flickrPhotos = [FlickrFetcher stanfordPhotos];
    [UIApplication hideNetworkActivityIndicator];
    

    return flickrPhotos;
}


@end
