//
//  SetCard.h
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card
-(id)initCardOf: (NSNumber *)number shape: (NSString*)shape color: (UIColor*)color shading:(NSString*)shading;

-(NSString *)contents;
-(NSAttributedString *) attributedContents;

+(NSArray *)validShape; //of NSString
+(NSArray *)validColor; //of UIColor
+(NSArray *)validShading; //of float (alpha)
+(NSArray *)validNumbers; //of int

@end
