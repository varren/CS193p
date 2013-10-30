//
//  SetGameViewController.m
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardCollectionViewCell.h"
#import "SetDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetGameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;
@end

@implementation SetGameViewController

#define SET_GAME_STARTING_CARDS_COUNT 12
#define SET_GAME_ID 2
#define SET_GAME_MATCHING_MODE 3
#define ACTIVE_ALPHA 1.0
#define INACTIVE_ALPHA 0.5
#define INVIS_ALPHA 0.0


-(Deck*) createDeck{
    Deck* deck = [[SetDeck alloc]init];
    return deck;
}

-(NSInteger)gameType       {return SET_GAME_ID;}
-(BOOL)saveMatches    {return NO;}

@synthesize startCardsCount = _startCardsCount;
-(NSInteger)startCardsCount{
    if (!_startCardsCount) _startCardsCount = SET_GAME_STARTING_CARDS_COUNT;
    return _startCardsCount ;
}

@synthesize mode = _mode;
-(int)mode{
    if(!_mode)_mode = SET_GAME_MATCHING_MODE;
    return _mode;        
}
-(int)currentPlayer{
    [self selectCurrentPlayerAlert];
}

-(void)startNewGame{
    self.addCardsButton.userInteractionEnabled = YES;
    self.addCardsButton.alpha = ACTIVE_ALPHA;
    [super startNewGame];
}

#define CARDS_TO_ADD 3
- (IBAction)addCards {
    int cardsAdded = [self addCards:CARDS_TO_ADD];
    if(cardsAdded != CARDS_TO_ADD){
        self.addCardsButton.userInteractionEnabled = NO;
        self.addCardsButton.alpha = INACTIVE_ALPHA;
    }
}

-(void)endTurnForPlayer:(NSInteger) currentPlayer{
    if(self.numberOfPlayers > 0){

    }else{
       [super endTurnForPlayer:currentPlayer];
    }
}

-(void)selectCurrentPlayerAlert{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Set Found By:" message:@"" delegate:self cancelButtonTitle:nil  otherButtonTitles:nil];
    
    for (int i = 1; i <= self.numberOfPlayers; i++)
        [alertView addButtonWithTitle:[NSString stringWithFormat:@"Player %d", i]];
    alertView.cancelButtonIndex = -1;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   [super endTurnForPlayer:buttonIndex];
}
#define DEFAULT_CARDBACK_TOP_INSERTS 6
#define DEFAULT_CARDBACK_SIDES_INSERTS 2
#define DEFAULT_TEXT_FONT_SIZE 20


-(void)updateView: (UIView*) cardView usingCard: (Card*)card{
        if([cardView isKindOfClass:[SetCardView class]]){
            SetCardView * setCardView = (SetCardView*)cardView;
            if ([card isKindOfClass:[SetCard class]]) {
                SetCard* setCard = (SetCard*) card;
                
                setCardView.shape   = setCard.shape;
                setCardView.shading = setCard.shading;
                setCardView.color   = setCard.color;
                setCardView.number  = setCard.number;

            }
        }
 
}

#define DEFAULT_STROKE_SIZE @-5
-(NSAttributedString*) arrtibutedCard:(Card*) card{
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:card.contents];
      /*
       SetCard *setCard = (SetCard*)card;
    
    NSRange range = NSMakeRange(0, aString.length);
  
    NSDictionary* attributes = @{ NSForegroundColorAttributeName: [[self colorFor:setCard.color]
                                        colorWithAlphaComponent: [@[@(1.0), @(0.5), @(0.0)][setCard.shading] floatValue]],
                                  NSStrokeWidthAttributeName : DEFAULT_STROKE_SIZE,
                                  NSStrokeColorAttributeName: [self colorFor:setCard.color] };
   
    if(range.location != NSNotFound)
        [aString setAttributes: attributes range:range];
     */
    return aString;
    
}

@end
