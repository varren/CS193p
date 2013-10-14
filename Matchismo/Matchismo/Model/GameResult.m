//
//  GameResult.m
//  Matchismo
//
//  Created by mmh on 11/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "GameResult.h"
@interface GameResult()

@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;

@end
@implementation GameResult

#define START_KEY @"StartTime"
#define END_KEY @"EndTime"
#define SCORE_KEY @"ScoreKey"
#define GAME_TYPE @"GameType"
#define ALL_RESULTS_KEY @"GameResults_All"

+(NSArray *)allGameResults{
    NSMutableArray *allGameResults = [NSMutableArray array];
    
    for (id data in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        [allGameResults addObject:[[GameResult alloc] initFromPropertyList:data] ];
    }
    
    return allGameResults;
}

-(id)initFor: (NSString*)gameType{
    self = [super init];
    if(self){
        _start = [NSDate date];
        _end = _start;
        _gameType = gameType;
    }
    return self;
}

- (id) initFromPropertyList:(id)plist{
    self = [super init];
    if(self){
        if([plist isKindOfClass:[NSDictionary class]]){
            NSDictionary * data = plist;
            _start = data[START_KEY];
            _end = data [END_KEY];
            _score = [data[SCORE_KEY] integerValue];
            _gameType = data[GAME_TYPE];
            if(!_start || !_end) self = nil;
        }
    }
    return self;
}

-(void)synchronise{
    NSMutableDictionary *userDefaults = [[[NSUserDefaults standardUserDefaults]dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if(!userDefaults)userDefaults = [[NSMutableDictionary alloc]init];
    userDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:userDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(id)asPropertyList{
    return @{START_KEY :self.start,END_KEY : self.end, SCORE_KEY : @(self.score), GAME_TYPE : self.gameType};
}


-(NSTimeInterval)duration{
    return [self.end timeIntervalSinceDate:self.start];
}

-(void) setScore: (int) score{
    _score = score;
    self.end = [NSDate date];
    [self synchronise];
}

//sorting methods

-(NSComparisonResult) compareScoreToGameResult:(GameResult*)otherResult{
    if (self.score > otherResult.score)
        return NSOrderedAscending;
    else if(self.score < otherResult.score)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

-(NSComparisonResult) compareEndDateToGameResult:(GameResult*)otherResult{
    return [otherResult.end compare:self.end];
}

-(NSComparisonResult) compareDurationToGameResult:(GameResult*)otherResult{
    if (self.duration > otherResult.duration)
        return NSOrderedAscending;
    else if(self.duration < otherResult.duration)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

@end
