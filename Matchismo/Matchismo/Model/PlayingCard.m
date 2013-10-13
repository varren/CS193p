//
//  PlayingCard.m
//  Matchismo
//
//  Created by mmh on 05/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(int)match:(NSArray *)otherCards{
    int score = 0;
    
    if (otherCards.count == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString: self.suit]) {
            score = 1;
        } else if(otherCard.rank == self.rank) {
            score = 4;
        }
    }else if (otherCards.count > 1){
        //comparing this card with all the cards in otherCards and + comparing all the otherCards to each other
        /*for (int i = 0; i < [otherCards count]; i++){
            score+= [self match:@[otherCards[i]]];
            for (int j = i + 1; j < [otherCards count]; j++)
                score += [otherCards[i] match:@[otherCards[j]]];
        }
        */
        // same but recoursive
        /*for (PlayingCard* card in otherCards)
            score += [self match:@[card]];
        
        PlayingCard* nextCard = (PlayingCard *) [otherCards lastObject];
        score += [nextCard match:[otherCards subarrayWithRange:NSMakeRange(0, [otherCards count] - 2)]];*/
    }
    
    
    return score;
}

-(NSString *)contents{
    
    return [[PlayingCard rankStrings] [self.rank] stringByAppendingString:self.suit];
}

@synthesize suit =_suit;

+(NSArray *)validSuits{
    static NSArray *validSuits = nil;
    if (!validSuits) {
        validSuits = @[@"♥",@"♦",@"♠",@"♣"];
    }
    return validSuits;
}
-(void)setSuit:(NSString *)suit{
    if ([[PlayingCard validSuits] containsObject: suit]) {
        _suit = suit;
    }

}
-(NSString *)suit{
    return _suit ? _suit : @"?";
}
+(NSArray *)rankStrings{
    static NSArray *rankStrings = nil;
    if (!rankStrings) {
        rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    }
    return rankStrings;
}
+ (NSUInteger)maxRank {

    return [self rankStrings].count -1;
}
-(void)setRank:(NSUInteger)rank{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}


@end
