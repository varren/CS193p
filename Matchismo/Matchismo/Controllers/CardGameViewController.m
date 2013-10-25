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
#import <QuartzCore/QuartzCore.h>
@interface CardGameViewController ()<UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;
@property (weak, nonatomic) IBOutlet UICollectionView *flippedCardCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *hintButton;

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (nonatomic) int mode;


@end

@implementation CardGameViewController

#pragma mark - Abstract functions

-(Deck*) createDeck{return nil;} //abstract

-(int)mode{
    return [[self.modeControl titleForSegmentAtIndex:[self.modeControl selectedSegmentIndex]] integerValue];
}

#pragma mark - Properties

-(CardMatchingGame *)game{
    if(!_game) {
        _game = [[CardMatchingGame alloc]
                 initWithCardCount:self.startCardsCount
                 usingDeck:[self createDeck]];
    }
    return _game;
}

-(GameResult*)gameResult{
    if (!_gameResult) {
        _gameResult = [[GameResult alloc] initFor: self.gameType];
    }
    return _gameResult;
}

-(BOOL)keepMatchedCards{
    if (!_keepMatchedCards)  _keepMatchedCards = YES;
    return _keepMatchedCards;
}

#pragma mark - Data Source protocol

#define MAIN_DISPLAY 0
#define FLIPPED_CARDS_DISPLAY 1

#define MAIN_CARDS_SECTION 0
#define MATCHED_CARDS_SECTION 1

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(collectionView.tag == MAIN_DISPLAY)
        return 2;
    else
        return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    NSInteger count = 0;
    
    if(collectionView.tag == MAIN_DISPLAY){
        if (section == MAIN_CARDS_SECTION){
            count =  self.game.currentCardsCount;
        } else if (section == MATCHED_CARDS_SECTION){
            count = [self.game.matchedCards count];
        }
    }
    else if (collectionView.tag == FLIPPED_CARDS_DISPLAY)
        count =  [[self.game allFlippedCards] count];
    
    return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    [self updateCell:cell
        inCollection:collectionView
             atIndex:indexPath];

    
    return cell;
}

#define COLLECTION_VIEW_BORDERS 10.0f
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if(collectionView.tag == MAIN_DISPLAY)
        return UIEdgeInsetsMake(COLLECTION_VIEW_BORDERS, COLLECTION_VIEW_BORDERS, COLLECTION_VIEW_BORDERS, COLLECTION_VIEW_BORDERS);
    else
        return UIEdgeInsetsMake(0,0,0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    if(collectionView.tag == FLIPPED_CARDS_DISPLAY)
        return 0.0f;
    else return COLLECTION_VIEW_BORDERS/2;
}

#pragma mark - UI functions
#define ACTIVE_ALPHA 1.0
#define INACTIVE_ALPHA 0.5
#define INVIS_ALPHA 0.0

-(void)updateUI{
    
    for(UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
        [self updateCell:cell
            inCollection:self.cardCollectionView
                 atIndex:[self.cardCollectionView indexPathForCell:cell]];


    
    self.hintButton.alpha = [[self.game allFlippedCards] count] == 0 ? ACTIVE_ALPHA : INVIS_ALPHA;
    self.modeControl.alpha =
    self.modeControl.isUserInteractionEnabled ? ACTIVE_ALPHA : INACTIVE_ALPHA;
    
    self.addCardsButton.alpha =
    self.addCardsButton.isUserInteractionEnabled ? ACTIVE_ALPHA : INACTIVE_ALPHA;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

-(void)updateCell:(UICollectionViewCell *)cell  inCollection: (UICollectionView *)collectionView atIndex: (NSIndexPath *)indexPath    {

    CardView *cardView = ((CardCollectionViewCell *)cell).cardView;
    
    Card * card;
    if(collectionView.tag == MAIN_DISPLAY){
     
        if(indexPath.section == MAIN_CARDS_SECTION){
            card = [self.game cardAtIndex:indexPath.item];
            cardView.faceUp = card.isFaceUp;
            cardView.alpha = card.isUnplayable ? INACTIVE_ALPHA : ACTIVE_ALPHA;
        }else if( indexPath.section == MATCHED_CARDS_SECTION){
            card = self.game.matchedCards[indexPath.item];
            cardView.faceUp = YES;
        }
    }else if(collectionView.tag == FLIPPED_CARDS_DISPLAY){
        card = [self.game allFlippedCards][indexPath.item];
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
     
    }
    
    [self updateCell:cell usingCard:card];
}

-(void)updateCell: (id) cardCell usingCard: (Card*)card {
    
    
} //abstract

- (IBAction)deal{

    self.gameResult = nil;
    self.game = nil;
    [self.cardCollectionView reloadData];
    [self.flippedCardCollectionView reloadData];
    self.addCardsButton.userInteractionEnabled = YES;
    self.modeControl.userInteractionEnabled = YES;
    [self updateUI];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture {
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    
    if(indexPath && indexPath.section == MAIN_CARDS_SECTION){
    
        if(self.game.status == NEW_GAME){
            [self hideTabBar:self.tabBarController];   
            self.modeControl.userInteractionEnabled = NO;
            [self.game setMode: [self mode]];
        }
        
        

        [self.game flipCardAtIndex:indexPath.item];
        [self.flippedCardCollectionView reloadData];
        if(self.game.status == GOT_MATCH && !self.keepMatchedCards)
            [self removeFlippedCards];
        
        self.gameResult.score = self.game.score;
        [self updateUI];
    }
}



- (IBAction)changeMode {
    [self.game setMode: [self mode]];
}

#define CARDS_TO_ADD 3
- (IBAction)addCards {
    int countInitCards = 0;
    
    NSMutableArray * indexPaths = [NSMutableArray array];
    int startingIndex = self.game.currentCardsCount;
    
    for (int i = startingIndex; i < startingIndex + CARDS_TO_ADD ; i++) {
        if([self.game addCard] == 1){
        countInitCards++;
 
        NSIndexPath * nextCardPath = [NSIndexPath indexPathForItem: i inSection:MAIN_CARDS_SECTION];
        
        [indexPaths addObject:nextCardPath];
        }
    }
    
    [self.cardCollectionView insertItemsAtIndexPaths:indexPaths];
    [self.cardCollectionView scrollToItemAtIndexPath:[indexPaths lastObject] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    if(countInitCards != CARDS_TO_ADD){
        [self.addCardsButton setUserInteractionEnabled:NO];
        [self updateUI];
    }
}



-(void)removeFlippedCards{
   
    for (int i = self.game.currentCardsCount - 1; i >= 0; i--) {
        Card * card = [self.game cardAtIndex:i];
        if (card.isUnplayable){
            NSIndexPath * from = [NSIndexPath indexPathForItem: i inSection:MAIN_CARDS_SECTION];
            NSIndexPath * to = [NSIndexPath indexPathForItem: [self.game.matchedCards count] inSection:MATCHED_CARDS_SECTION];
            [self.game saveAndRemoveMatchAtIndex: i];
            [self.cardCollectionView moveItemAtIndexPath:from toIndexPath:to ]; 
        }
    }

    
}

#pragma mark - Attributed String FNs

-(NSAttributedString*) flippedCards{
    NSMutableAttributedString * cards = [[NSMutableAttributedString alloc] init];
    
    for (int i = 0; i < [self.game.allFlippedCards count]; i++) {
        if(i) [cards appendAttributedString:[[NSMutableAttributedString alloc] initWithString: @" & " ]];
        Card * card = self.game.allFlippedCards[i];
        [cards appendAttributedString: [self arrtibutedCard:card]];
    }
    
    return cards;
}

-(NSAttributedString*) arrtibutedCard:(Card*) card {
    return [[NSMutableAttributedString alloc] initWithString: [card contents]];
}

-(NSAttributedString *) status{
    NSMutableAttributedString *status = [[NSMutableAttributedString alloc] initWithString: @""];
   
    if (self.game.status == NEW_GAME) // because there can be 0 cards only on start of a new game
        status = [[NSMutableAttributedString alloc] initWithString: @"New Game Started"];
    
    else if (self.game.status == GOT_MATCH){
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: @"Matched " ]];
        [status appendAttributedString: [self flippedCards]];
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@" for %d points", self.game.lastTurnScore]]];
                                         
    }else if (self.game.status == GOT_MISMATCH){
        [status appendAttributedString: [self flippedCards]];
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@" don't match! %d points penalty", self.game.lastTurnScore]]];
    
    }else if (self.game.status == FLIPPED_A_CARD){
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: @"Flipped " ]];
        [status appendAttributedString: [self flippedCards]];
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
