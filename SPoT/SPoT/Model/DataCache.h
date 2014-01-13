//
//  DataSource.h
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCache : NSObject
+(DataCache*)instance; //singletone

-(NSArray *) recentlyViewedPhotos;
-(void) addRecentlyViewedPhoto:(NSDictionary *) photo;

-(NSArray *) favoritePhotos;
-(void)addFavoritePhoto:(NSDictionary *) photo;
-(void)removeFromFavorite:(NSDictionary *)photo;
-(UIImage *) getImage: (NSURL *) imageURL;

@end
