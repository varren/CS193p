//
//  PlayingCardView.m
//  Matchismo
//
//  Created by mmh on 16/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "PlayingCardView.h"
@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;

@end
@implementation PlayingCardView

#pragma mark - Properties

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.9
-(CGFloat)faceCardScaleFactor{
    if(!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

-(void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor{
    _faceCardScaleFactor =faceCardScaleFactor;
    [self setNeedsDisplay];
}

-(void)setSuit:(NSString *)suit{
    _suit = suit;
    [self setNeedsDisplay];
}

-(void)setRank:(NSUInteger)rank{
    _rank = rank;
    [self setNeedsDisplay];
}

-(void)setFaceUp:(BOOL)faceUp{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

-(NSString*) rankAsString{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

#pragma mark - Drawing

#define CORNER_RADIUS 12.0

 - (void)drawRect:(CGRect)rect
 {
     UIBezierPath * roundedRect = [UIBezierPath bezierPathWithRoundedRect: self.bounds  cornerRadius:CORNER_RADIUS];
     
     [roundedRect addClip];
     
     [[UIColor whiteColor]setFill];
     UIRectFill(self.bounds);
     
     if(self.faceUp){
         UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg", [self rankAsString],self.suit]];
         if(faceImage){
             CGRect imageRect = CGRectInset(self.bounds,
                                            self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                            self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
             [faceImage drawInRect:imageRect];
         } else{
             [self drawPips];
         }
         [self drawCorners];
     }else{
         [[UIImage imageNamed:@"cardBack.jpg"] drawInRect:self.bounds];
     }
 }
#define PIP_FONT_SCALE_FACTOR 0.2
#define CORNER_OFFSET 2.0

-(void)drawCorners{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont* cornerFont = [UIFont systemFontOfSize:self.bounds.size.width *PIP_FONT_SCALE_FACTOR];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc]
                                      initWithString:
                                      [NSString stringWithFormat:@"%@\n%@", [self rankAsString], self. suit]
                                      attributes:
                                      @{NSParagraphStyleAttributeName: paragraphStyle,
                                      NSFontAttributeName: cornerFont}];
    CGRect textBounds;
    textBounds.origin = CGPointMake(CORNER_OFFSET, CORNER_OFFSET);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

-(void)pushContextAndRotateUpsideDown{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

-(void)popContext{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Gesture Handlers
-(void)pinch:(UIPinchGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateChanged ||
       gesture.state == UIGestureRecognizerStateEnded){
        self.faceCardScaleFactor *=gesture.scale;
        gesture.scale = 1;
    }
}

#pragma mark - Draw Pips

-(void)drawPips{

}
-(void) drawPipsWithHorisontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)upsideDown{

}
-(void) drawPipsWithHorisontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)upsideDown{
    
}
        
#pragma mark - Initialisation
-(void)setup{
    //initial setup can be here
}

-(void)awakeFromNib{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
