//
//  Photo.h
//  SPoT
//
//  Created by mmh on 22/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSNumber * favourite;
@property (nonatomic, retain) NSString * imgURL;
@property (nonatomic, retain) NSDate * accessDate;
@property (nonatomic, retain) NSNumber * removed;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
