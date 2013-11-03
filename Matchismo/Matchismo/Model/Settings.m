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

//
// structure is:
//
// USER_DEFAULTS_SCORES_KEY       -> SCORES
//
// USER_DEFAULTS_ALL_SETTINGS_KEY -> NUMBER_OF_PLAYERS_KEY
//                                   DIFFICULTY_KEY
//                                   PLAYERS_SETTINGS -> PLAYER_NAME
//                                                       PLAYER_COLOR
//

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
#define PLAYERS_SETTINGS @"PlayersSettings"

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
    [self saveSettings: @(difficulty)forKey:DIFFICULTY_KEY];
}

-(void) resetSettings{
    self.settings = [self defaultGameSettings];
}

-(NSDictionary*)defaultGameSettings{
    return @{DIFFICULTY_KEY: @(1), NUMBER_OF_PLAYERS_KEY : @(1), PLAYERS_SETTINGS: @{}};
}

#pragma mark - Players Settings

-(int)numberOfPlayers{
    return [self.settings[NUMBER_OF_PLAYERS_KEY] integerValue];
}

-(void)setNumberOfPlayers:(int)numberOfPlayers{
    [self saveSettings: @(numberOfPlayers)forKey:NUMBER_OF_PLAYERS_KEY];
}

-(NSDictionary*)playersSettingsForPlayer: (NSInteger)player{
    NSDictionary * playersSettings = self.settings[PLAYERS_SETTINGS];
    if(!playersSettings) playersSettings = @{};
    
    NSDictionary *currentPlayerSettings =  playersSettings[[@(player) description]];

    if(!currentPlayerSettings) currentPlayerSettings =@{};
    
    return currentPlayerSettings;
}

-(void)setSettings: (NSDictionary*)playerSettings forPlayer:(NSInteger) player{
    NSMutableDictionary * allPlayersSettings = [self.settings[PLAYERS_SETTINGS] mutableCopy];
    allPlayersSettings[[@(player) description]] = playerSettings;
    
    [self saveSettings:allPlayersSettings forKey:PLAYERS_SETTINGS];
}

#define PLAYER_NAME_KEY @"PlayerName"
-(NSString*)nameForPlayer: (NSInteger)player{
    
    NSDictionary * curentPlayerSettings = [self playersSettingsForPlayer:player];
    
    NSString * name = curentPlayerSettings[PLAYER_NAME_KEY];

    if (!name) name = [NSString stringWithFormat: @"Player %d", player + 1];
    
    return name;
}

-(void)setName:(NSString*)name forPlayer:(NSInteger)player{
    NSMutableDictionary * curentPlayerSettings = [[self playersSettingsForPlayer: player] mutableCopy];
    
    if(!curentPlayerSettings) curentPlayerSettings = [NSMutableDictionary dictionary];
    
    curentPlayerSettings[PLAYER_NAME_KEY] = name;

    [self setSettings:curentPlayerSettings forPlayer:player];

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

-(void)saveSettings:(id)setting forKey:(NSString*) key{
    NSMutableDictionary *playerSettingsUserDefaults = [self.settings mutableCopy];
    
    playerSettingsUserDefaults[key] = setting;
    
    self.settings = playerSettingsUserDefaults;
}

@end
