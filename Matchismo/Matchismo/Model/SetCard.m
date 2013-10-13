//
//  SetCard.m
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "SetCard.h"
@interface SetCard()
@property(strong,nonatomic)NSString *shape;
@property(strong,nonatomic)UIColor *color;
@property(nonatomic) NSInteger number;
@property(nonatomic)double shading;

@end
@implementation SetCard

-(id)initCardOf: (NSNumber *)number shape: (NSString*)shape color: (UIColor*)color shading:(NSNumber*) shading{
    self = [super init];
    if(self){
        _shape = shape;
        _color = color;
        _number = [number intValue];
        _shading = [shading doubleValue];
    }
    return self;
}
-(int)match:(NSArray *)otherCards{
    return 1;//
}

+(NSArray *)validShape{
    return @[@"▲", @"●", @"■"];
}

+(NSArray *)validColor{
    return @[[UIColor blueColor],[UIColor greenColor],[UIColor redColor]];
}
+(NSArray *)validShading{
    return @[@(0.0), @(0.2), @(1.0)]; //alpha
}

+(NSArray *)validNumbers{
    return @[@(1),@(2),@(3)];
}

-(NSString *)contents{
    return [self.shape stringByPaddingToLength:self.number withString:self.shape startingAtIndex:0];
}
#define DEFAULT_TEXT_FONT_SIZE 20
#define DEFAULT_STROKE_SIZE @-5
-(NSAttributedString *) attributedContents{
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:[self contents]];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:DEFAULT_TEXT_FONT_SIZE],
                                 NSForegroundColorAttributeName: [self.color colorWithAlphaComponent:(self.shading)],
                                 NSStrokeWidthAttributeName : DEFAULT_STROKE_SIZE,
                                 NSStrokeColorAttributeName: self.color};
    
    NSRange range = [[aString string] rangeOfString: [aString string]];
    
    if(range.location != NSNotFound && attributes)
        [aString setAttributes: attributes range:range];

     return aString;
}

@end
