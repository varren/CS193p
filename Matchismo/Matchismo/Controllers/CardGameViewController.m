//
//  CardGameViewController.m
//  Matchismo
//
//  Created by mmh on 31/07/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "CardGameViewController.h"
#import "GameResult.h"
#import "CardMatchingGame.h" 
#import "CardCollectionViewCell.h"
#import "MatchedCardsCollectionViewCell.h"

#import <QuartzCore/QuartzCore.h>
@interface CardGameViewController ()<UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *flippedCardCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *hintButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (strong, nonatomic) NSArray * highlitedCards;


@end

@implementation CardGameViewController

-(void)viewDidLoad{

}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.flippedCardCollectionView.collectionViewLayout invalidateLayout];
}


-(Deck*) createDeck{return nil;} //abstract

#pragma mark - Properties

-(CardMatchingGame *)game{
    if(!_game) {
        _game = [[CardMatchingGame alloc]
                 initWithCardCount: self.startCardsCount
                 numOfPlayers: self.numberOfPlayers
                 usingDeck:[self createDeck]
                 andMode: self.mode];
    }
    return _game;
}

-(int)numberOfPlayers{
    if(!_numberOfPlayers) _numberOfPlayers = 2;
    return _numberOfPlayers;
}

-(GameResult*)gameResult{
    if (!_gameResult) _gameResult = [[GameResult alloc] initFor: self.gameType];
    return _gameResult;
}

-(BOOL)saveMatches{
    if (!_saveMatches)  _saveMatches = YES;
    return _saveMatches;
}

-(void)setMode:(int)mode{
    self.game.mode = mode;
    _mode = mode;
}

-(int) currentPlayer{
    return self.game.currentPlayer;
}

#pragma mark - UICollectionViewDataSource protocol

#define MAIN_DISPLAY 0
#define FLIPPED_CARDS_DISPLAY 1

#define MAIN_CARDS_SECTION 0
#define MATCHED_CARDS_SECTION 1

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return collectionView.tag == MAIN_DISPLAY ? self.numberOfPlayers + 1 : 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    NSInteger count = 0;
    
    if(collectionView.tag == MAIN_DISPLAY){
        if (section == MAIN_CARDS_SECTION)
            count =  self.game.currentCardsCount;
        else if (section >= MATCHED_CARDS_SECTION)
            count = [[self.game matchedCardsForPlayer:section - 1] count];
    } else if (collectionView.tag == FLIPPED_CARDS_DISPLAY)
        count =  [[self.game flippedCards] count];
    
    return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    NSString *cellIdentifier = @"PlayingCard";
    if(collectionView.tag == MAIN_DISPLAY && indexPath.section > MAIN_CARDS_SECTION){
        cellIdentifier = @"MatchedCards";
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: cellIdentifier forIndexPath:indexPath];
    
    [self updateCell:cell inCollection:collectionView atIndex:indexPath animate:NO];
    
    return cell;
}
/*
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
}
*/
#define COLLECTION_VIEW_BORDERS 10.0f
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if(collectionView.tag == MAIN_DISPLAY)
        return UIEdgeInsetsMake(COLLECTION_VIEW_BORDERS, COLLECTION_VIEW_BORDERS, COLLECTION_VIEW_BORDERS, COLLECTION_VIEW_BORDERS);
    else {
        return UIEdgeInsetsMake(0, self.padding, 0, self.padding);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    if(collectionView.tag == MAIN_DISPLAY) return COLLECTION_VIEW_BORDERS/2;
    else return self.padding;
    
}

#define MAIN_CARD_CELL_WIDTH 60
#define MAIN_CARD_CELL_HEIGHT 75

#define MATCHED_CELL_WIDTH 140
#define MATCHED_CELL_HEIGHT 60

#define FLIPPED_CELL_WIDTH 50
#define FLIPPED_CELL_HEIGHT 65
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size;
    if(collectionView.tag == MAIN_DISPLAY){
        if (indexPath.section == MAIN_CARDS_SECTION)
            size = CGSizeMake(MAIN_CARD_CELL_WIDTH, MAIN_CARD_CELL_HEIGHT);
        else if (indexPath.section >= MATCHED_CARDS_SECTION)
            size = CGSizeMake(MATCHED_CELL_WIDTH, MATCHED_CELL_HEIGHT);
    } else if (collectionView.tag == FLIPPED_CARDS_DISPLAY)
            size = CGSizeMake(FLIPPED_CELL_WIDTH, FLIPPED_CELL_HEIGHT);
    
    
    return size;
}
// need to figure out how to detect cell size

-(CGFloat)padding{
    return (self.flippedCardCollectionView.bounds.size.width - FLIPPED_CELL_WIDTH * self.mode) / (self.mode + 1) - 1;
}

#pragma mark - Update UI functions

#define ACTIVE_ALPHA 1.0
#define INACTIVE_ALPHA 0.5
#define INVIS_ALPHA 0.0

-(void)updateUI{
    
    for(UICollectionViewCell *cell in [self.cardCollectionView visibleCells]){
        [self updateCell:cell inCollection:self.cardCollectionView atIndex:[self.cardCollectionView indexPathForCell:cell] animate:YES];
    }

    [self.flippedCardCollectionView reloadData];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Scores: %@",[self stringScores]];
    [self.statusLabel setAttributedText:[self status]];
}

-(NSString*)stringScores{
    NSString * scores = @"";
    
    for (int i = 0; i < self.numberOfPlayers; i++) {
      scores = [scores stringByAppendingFormat:@"P%d = %d ",    i + 1, [self.game scoreForPlayer:i]];
    }
    
    return scores;
}

-(void)updateCell:(UICollectionViewCell *)cell  inCollection: (UICollectionView *)collectionView atIndex: (NSIndexPath *)indexPath animate:(BOOL)animate   {
    
    if (collectionView.tag == MAIN_DISPLAY){
     
        if(indexPath.section == MAIN_CARDS_SECTION){
            [self updateMainCardsDisplayCell:cell forIndex:indexPath.item animate:animate];
        }else if( indexPath.section >= MATCHED_CARDS_SECTION){
            [self updateMatchedCardsDisplayCell:cell forPlayer: indexPath.section-1 andIndex:indexPath.item animate:animate];
        }
        
    } else if (collectionView.tag == FLIPPED_CARDS_DISPLAY){
        [self updateFlippedCardsDisplayCell:cell forIndex:indexPath.item animate:animate];
    }
}

-(void) updateMainCardsDisplayCell: (id) cell forIndex:(NSInteger)index animate: (BOOL) animate{
    Card *card = [self.game cardAtIndex:index];
    CardView *cardView = ((CardCollectionViewCell *)cell).cardView;
    if(animate && cardView.faceUp != card.isFaceUp){
        [UIView transitionWithView:cardView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            cardView.faceUp = card.isFaceUp;

                        }
                        completion:NULL];
        
    }else{
        cardView.faceUp = card.isFaceUp;
        
    }
    
    if(animate && [self.highlitedCards containsObject:card] && !cardView.hintHighlighted)
        [UIView transitionWithView:cardView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromBottom
                        animations:^{
                            cardView.hintHighlighted = [self.highlitedCards containsObject:card];
                            
                        }
                        completion:NULL];
    else{
        cardView.hintHighlighted = [self.highlitedCards containsObject:card];
    }
    
    
    cardView.unplayable = card.unplayable;
    
    [self updateView:cardView usingCard:card];

}


-(void) updateMatchedCardsDisplayCell: (id) cell forPlayer: (NSInteger)player andIndex:(NSInteger)index animate: (BOOL) animate{
    MatchedCardsCollectionViewCell * matchedCell = (MatchedCardsCollectionViewCell *)cell;
    NSArray* cards = [self.game matchedCardsForPlayer:player][index];
    NSArray* cardViews = matchedCell.cardViews;
    NSLog(@"cardViews %d, cards %d",[cardViews count], [cards count]);
    for (int i = 0; i < [cardViews count]; i++) {
        CardView *cardView = cardViews[i];

        if( i < [cards count]){
            [self updateView:cardView usingCard:cards[i]];
            cardView.faceUp = YES;
           // cardView.unplayable = YES;

        } else{
            cardView = nil;
        }
    }



}

-(void) updateFlippedCardsDisplayCell: (id) cell forIndex:(NSInteger)index animate: (BOOL) animate{
    Card * card = [self.game flippedCards][index];
    CardView *cardView = ((CardCollectionViewCell *)cell).cardView;

    cardView.faceUp = YES;
    
    UIColor * color = [UIColor grayColor];
    if(self.game.status == GOT_MATCH)
        color = [UIColor greenColor];
    else if(self.game.status == GOT_MISMATCH)
        color = [UIColor redColor];
    
    CALayer * layer = [cell layer];
    layer.borderColor = color.CGColor;
    layer.borderWidth = 3.0;
    layer.cornerRadius = 6.0;
    
    [self updateView:cardView usingCard:card];
}
    
-(void)updateView: (UIView*) cardView usingCard: (Card*)card {} //abstract

#pragma mark - Action Listeners

- (IBAction)deal{
    [self startNewGame];
}

-(void)startNewGame{
    self.gameResult = nil;
    self.game = nil;
    [self.cardCollectionView reloadData];
    [self updateUI];
}

- (IBAction)highlightHintCards {
    self.highlitedCards = [self.game findPossibleSolution];

    [self updateUI];
}
- (IBAction)changeMode {
    self.game.mode = self.mode;
}

#pragma mark Flipping Cards

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture {
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    if(indexPath && indexPath.section == MAIN_CARDS_SECTION)
        [self flipCardAtIndex:indexPath.item];
    
    [self updateUI];
}

-(void)flipCardAtIndex: (NSInteger) index{
    if(self.game.status == NEW_GAME){
        [self hideTabBar:self.tabBarController];
        self.game.mode = self.mode;
    }
    
    [self.game flipCardAtIndex:index];
    if(self.game.status == GOT_MATCH){
        [self endTurnForPlayer:self.currentPlayer];
        
    }
    
    
    self.gameResult.score = [self.game scoreForPlayer:self.game.currentPlayer];

    
}

-(void)endTurnForPlayer:(NSInteger) currentPlayer{
    [self.game endOfTurnForPlayer: currentPlayer];
    
    NSMutableArray * matchedCardsindexPaths = [NSMutableArray array];
    NSArray* flippedCards = [self.game matchedCardsForPlayer:currentPlayer];
    [self debugLogArrayOfMatches:flippedCards];
    NSLog(@"%d, %d",[flippedCards count], currentPlayer + 1);
    NSIndexPath * matcheCardIndex = [NSIndexPath indexPathForItem: [flippedCards count] - 1 inSection:currentPlayer + 1];
    [matchedCardsindexPaths addObject:matcheCardIndex];
    [self.cardCollectionView insertItemsAtIndexPaths:matchedCardsindexPaths];
    
    if(!self.saveMatches) [self removeFlippedCards];
}

-(void)debugLogArrayOfMatches:(NSArray*) matches{
    NSString *text = [NSString stringWithFormat:@"matches: %d ",[matches count]];
    for (NSArray* match in matches) {
        text =[text stringByAppendingFormat:@" | %d", [match count]];
    }
    NSLog(@"%@",text);
}
- (int) addCards: (NSInteger) numCardsToAdd {

    NSMutableArray * indexPaths = [NSMutableArray array];
    
    int startingIndex = self.game.currentCardsCount;
    int cardsAdded = [self.game addCards: numCardsToAdd];
    
    for (int i = startingIndex; i < startingIndex + cardsAdded ; i++) {
        NSIndexPath * nextCardPath = [NSIndexPath indexPathForItem: i inSection:MAIN_CARDS_SECTION];
        [indexPaths addObject:nextCardPath];
    }
    
    if(cardsAdded){
        [self.cardCollectionView insertItemsAtIndexPaths:indexPaths];
        [self.cardCollectionView scrollToItemAtIndexPath:[indexPaths lastObject] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
    [self updateUI];
    return cardsAdded;
}

-(void)removeFlippedCards{
    
    NSMutableArray * indexPaths = [NSMutableArray array];
    
    for (int i = self.game.currentCardsCount - 1; i >= 0; i--) {
        Card * card = [self.game cardAtIndex:i];
        if (card.isUnplayable){
            NSIndexPath * nextCardPath = [NSIndexPath indexPathForItem: i inSection:MAIN_CARDS_SECTION];
            [self.game removeCardAtIndex: i];
            [indexPaths addObject:nextCardPath];
        }
    }
   
    [self.cardCollectionView deleteItemsAtIndexPaths:indexPaths];
    
    [self updateUI];
}

#pragma mark - Attributed String FNs
-(NSAttributedString*) flippedCards{
    NSMutableAttributedString * cards = [[NSMutableAttributedString alloc] init];
    
    for (int i = 0; i < [[self.game flippedCards] count]; i++) {
        if(i) [cards appendAttributedString:[[NSMutableAttributedString alloc] initWithString: @" & " ]];
        Card * card = [self.game flippedCards][i];
        [cards appendAttributedString: [self arrtibutedCard:card]];
    }
    
    return cards;
}

-(NSAttributedString*) arrtibutedCard:(Card*) card {
    return [[NSMutableAttributedString alloc] initWithString: [card contents]];
}

-(NSAttributedString*) status{
    NSMutableAttributedString *status = [[NSMutableAttributedString alloc] initWithString: @""];
   
    if (self.game.status == NEW_GAME) 
        status = [[NSMutableAttributedString alloc] initWithString: @"New Game Started"];
    
    else if (self.game.status == GOT_MATCH){
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: @"Matched " ]];
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@" +%d points", self.game.lastTurnScore]]];
                                         
    }else if (self.game.status == GOT_MISMATCH){
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"Mismatch! %d points ", self.game.lastTurnScore]]];
    
    }else if (self.game.status == FLIPPED_A_CARD){
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: @"Flipped a card" ]];
    }

    return status;
}

#pragma  mark - TabBar hide 
- (IBAction)toggleMenu {
    self.tabBarController.tabBar.isAccessibilityElement ?
    [self showTabBar:self.tabBarController]:
    [self hideTabBar:self.tabBarController];
}

// Method implementations FROM http://stackoverflow.com/questions/5272290/how-to-hide-uitabbarcontroller/5272334#5272334
// How to hide uitabbarcontroller
- (void) hideTabBar:(UITabBarController *) tabbarcontroller
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    float fHeight = screenRect.size.height;
    if(  UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) )
    {
        fHeight = screenRect.size.width;
    }
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
            view.backgroundColor = [UIColor blackColor];
        }
    }
    [UIView commitAnimations];
    tabbarcontroller.tabBar.isAccessibilityElement = YES;

}

- (void) showTabBar:(UITabBarController *) tabbarcontroller
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float fHeight = screenRect.size.height - tabbarcontroller.tabBar.frame.size.height;
    
    if(  UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) )
    {
        fHeight = screenRect.size.width - tabbarcontroller.tabBar.frame.size.height;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
        }
    }
    [UIView commitAnimations];
    tabbarcontroller.tabBar.isAccessibilityElement = NO;
 
}
@end
