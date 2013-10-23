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

@interface CardGameViewController ()<UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (nonatomic) int mode;

@end

@implementation CardGameViewController

#pragma mark - Abstract functions

-(Deck*) createDeck{return nil;} //abstract
-(void)updateCell: (id) cardCell usingCard: (Card*)card{} //abstract
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



#pragma mark - Data Source protocol
#define COLLECTION_VIEW_BORDERS 10.0
-(void)setCardCollectionView:(UICollectionView *)cardCollectionView{
    _cardCollectionView = cardCollectionView;
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.cardCollectionView.collectionViewLayout;
    flow.sectionInset = UIEdgeInsetsMake(COLLECTION_VIEW_BORDERS, COLLECTION_VIEW_BORDERS, COLLECTION_VIEW_BORDERS, COLLECTION_VIEW_BORDERS);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.game.currentCardsCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d:: %d",indexPath.section , indexPath.item);
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card * card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

#pragma mark - UI functions
#define ACTIVE_ALPHA 1.0
#define INACTIVE_ALPHA 0.3

-(void)updateUI{
    
    for(UICollectionViewCell *cell in [self.cardCollectionView visibleCells]){
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
        
    }
    	
    self.modeControl.alpha =
    self.modeControl.isUserInteractionEnabled ? ACTIVE_ALPHA : INACTIVE_ALPHA;
    self.addCardsButton.alpha =
    self.addCardsButton.isUserInteractionEnabled	 ? ACTIVE_ALPHA : INACTIVE_ALPHA;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];

}


- (IBAction)deal{

    self.gameResult = nil;
    self.game = nil;
    [self.cardCollectionView reloadData];
    self.addCardsButton.userInteractionEnabled =YES;
    self.modeControl.userInteractionEnabled = YES;
    [self updateUI];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture {
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    
    if(indexPath){
    
        
        [self hideTabBar:self.tabBarController];   
        self.modeControl.userInteractionEnabled = NO;
        [self.game setMode: [self mode]];
        
        

        [self.game flipCardAtIndex:indexPath.item];
        self.gameResult.score = self.game.score;
        [self updateUI];
    }
}



- (IBAction)changeMode {
    [self.game setMode: [self mode]];
}
#define CARDS_TO_ADD 3
#define MAIN_CARDS_SECTION 0
- (IBAction)addCards {
    int countInitCards = [self.game addCards: CARDS_TO_ADD];
    
    NSMutableArray * indexPaths = [NSMutableArray array];
    
    for (int i = countInitCards; i > 0 ; i--) {
        NSIndexPath * nextCardPath = [NSIndexPath indexPathForItem:self.game.currentCardsCount - i inSection:MAIN_CARDS_SECTION];
        [indexPaths addObject:nextCardPath];
        NSLog(@"%d::%d <- cards to ad at, %d", nextCardPath.section, nextCardPath.item, self.game.currentCardsCount);
    }
    
    [self.cardCollectionView insertItemsAtIndexPaths:indexPaths];

    if(countInitCards!= CARDS_TO_ADD){
        [self.addCardsButton setUserInteractionEnabled:NO];
        
    }
    
    
    //[self.cardCollectionView reloadData];
    [self updateUI];
}

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
   
    if ([self.game.allFlippedCards count] == 0) // because there can be 0 cards only on start of a new game
        status = [[NSMutableAttributedString alloc] initWithString: @"New Game Started"];
    
    else if (self.game.lastTurnScore > 0){
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: @"Matched " ]];
        [status appendAttributedString: [self flippedCards]];
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@" for %d points", self.game.lastTurnScore]]];
                                         
    }else if (self.game.lastTurnScore < 0){
        [status appendAttributedString: [self flippedCards]];
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@" don't match! %d points penalty", self.game.lastTurnScore]]];
    
    }else if (self.game.lastTurnScore == 0){
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: @"Flipped " ]];
        [status appendAttributedString: [self flippedCards]];
    }

    return status;
}


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
