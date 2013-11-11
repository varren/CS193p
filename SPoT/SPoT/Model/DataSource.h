//
//  DataSource.h
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject
+(DataSource*)instance; //singletone

-(NSArray *)possibleTags;
-(NSArray *)photosForTags:(NSArray*) tags; //returns array of arrays of photos(dictionarys)

-(NSArray *) recentlyViewedPhotos;
-(void) addRecentlyViewedPhoto:(NSDictionary *) photo;

-(NSArray *) favoritePhotos;
-(void)addFavoritePhoto:(NSDictionary *) photo;
-(void)removeFromFavorite:(NSDictionary *)photo;
@end
