//
//  GameResult.h
//  Matchismo
//
//  Created by mmh on 11/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *) allGameResults;

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;

@property (nonatomic) int score;

//sorting options
-(NSComparisonResult) compareScoreToGameResult:(GameResult*)otherResult;
-(NSComparisonResult) compareEndDateToGameResult:(GameResult*)otherResult;
-(NSComparisonResult) compareDurationToGameResult:(GameResult*)otherResult;

@end
