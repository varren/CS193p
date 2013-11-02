//
//  Settings.m
//  Matchismo
//
//  Created by mmh on 02/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "Settings.h"
@interface Settings()
@property (weak, nonatomic) NSDictionary * settings;

@end
@implementation Settings;

#pragma mark - Singletone

static Settings *sharedSingleton;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[Settings alloc] init];
    }
}
+(Settings *) instance{
    return sharedSingleton;
}

#pragma mark - Setting Scores

#define USER_DEFAULTS_SCORES_KEY @"GameResults_All"


-(NSDictionary*)scores{
    return [self defaultsForKey:USER_DEFAULTS_SCORES_KEY];
}

-(void)setScores:(NSDictionary *)scores{
    [self saveDefaults:scores forKey:USER_DEFAULTS_SCORES_KEY];
}

-(void)addScore:(NSDictionary *)score forGameID:(NSString *)key{
    NSMutableDictionary *scoresUserDefaults = [self.scores mutableCopy];
    scoresUserDefaults[key] = score;
    self.scores = scoresUserDefaults;
}

-(void) resetSavedScores{
    self.scores = @{};
}

#pragma mark - Setting Game Setup

#define USER_DEFAULTS_ALL_SETTINGS_KEY @"GameSettings_main"
#define NUMBER_OF_PLAYERS_KEY @"NumberOfPlayers"
#define DIFFICULTY_KEY @"Difficulty"

-(NSDictionary *)settings{
     return [self defaultsForKey:USER_DEFAULTS_ALL_SETTINGS_KEY];
}

-(void) setSettings:(NSDictionary *)settings{
    [self saveDefaults:settings forKey:USER_DEFAULTS_ALL_SETTINGS_KEY];
}

-(int) difficulty{
    return [self.settings[DIFFICULTY_KEY] integerValue];
}

-(void) setDifficulty:(int)difficulty{
    NSMutableDictionary *settingsUserDefaults = [self.settings mutableCopy];
    settingsUserDefaults[DIFFICULTY_KEY] = @(difficulty);
    self.settings = settingsUserDefaults;
}

-(int)numberOfPlayers{
    return [self.settings[NUMBER_OF_PLAYERS_KEY] integerValue];
}

-(void)setNumberOfPlayers:(int)numberOfPlayers{
    NSMutableDictionary *settingsUserDefaults = [self.settings mutableCopy];
    settingsUserDefaults[NUMBER_OF_PLAYERS_KEY] = @(numberOfPlayers);
    self.settings = settingsUserDefaults;
}

-(void) resetSettings{
    self.settings = [self defaultGameSettings];
}

-(NSDictionary*)defaultGameSettings{
    return @{DIFFICULTY_KEY: @(1), NUMBER_OF_PLAYERS_KEY : @(1)};
}

#pragma mark - Generic User Defaults Setter and Getter

-(void)saveDefaults:(id)value forKey:(id)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey: key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSDictionary*)defaultsForKey:(id)key{
    NSDictionary * userDefaults =  [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
    if(!userDefaults) userDefaults = [[NSMutableDictionary alloc]init];
    return userDefaults;
}
@end
