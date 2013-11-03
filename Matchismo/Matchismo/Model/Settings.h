//
//  Settings.h
//  Matchismo
//
//  Created by mmh on 02/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

+(Settings *) instance; //singletone

@property(weak, nonatomic) NSDictionary * scores;
-(void) addScore:(NSDictionary *)score forGameID:(NSString *)key;
-(void) resetSavedScores;

@property(nonatomic) int numberOfPlayers;
@property(nonatomic) int difficulty;

-(NSString*)nameForPlayer: (NSInteger)player;
-(void)setName:(NSString*)name forPlayer:(NSInteger)player;

-(void) resetSettings;
@end
