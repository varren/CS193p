//
//  Tag+Create.m
//  SPoT
//
//  Created by mmh on 21/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)
+ (Tag *) tagWithName:(NSString*) name
inManagedObjectContext: (NSManagedObjectContext *) context{
    
    Tag *tag = nil;
    if(name.length){
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if(!matches || ([matches count] > 1)){
            //handle errors
        } else if (![matches count]){
            tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
            tag.name = name;
            
        } else{
            tag = [matches lastObject];
        }
    }
    
    return tag;

}
@end
