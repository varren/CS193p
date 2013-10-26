//
//  PlayingCardView.m
//  Matchismo
//
//  Created by mmh on 16/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "PlayingCardView.h"
#import <QuartzCore/QuartzCore.h>
@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;

@end
@implementation PlayingCardView

#pragma mark - Properties

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.8
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
    
    [self drawCard];
    
    [super drawRect:rect];
    
}

-(void)drawCard{
    if(self.faceUp){
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg", [self rankAsString], self.suit]];
        
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
#define PIP_HOFFSET_PERSENTAGE 0.165
#define PIP_VOFFSET1_PERSENTAGE 0.090
#define PIP_VOFFSET2_PERSENTAGE 0.175
#define PIP_VOFFSET3_PERSENTAGE 0.270

-(void)drawPips{
    if(self.rank == 1 || self.rank == 5 || self.rank == 9 || self.rank == 3){
        [self drawPipsWithHorizontalOffset:0 verticalOffset:0 mirroredVertically:NO];
    }

    if(self.rank == 6 || self.rank == 7 || self.rank == 8){
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERSENTAGE verticalOffset:0 mirroredVertically:NO];
    }
    
    if(self.rank == 2 || self.rank == 3 || self.rank == 7 || self.rank == 8 || self.rank == 10){
        [self drawPipsWithHorizontalOffset:0 verticalOffset:PIP_VOFFSET2_PERSENTAGE mirroredVertically:(self.rank != 7)];
    }
    
    if(self.rank == 4 || self.rank == 5 || self.rank == 6 || self.rank == 7 || self.rank == 8 || self.rank == 9 || self.rank == 10){
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERSENTAGE verticalOffset:PIP_VOFFSET3_PERSENTAGE mirroredVertically:YES];
    }
    
    if(self.rank == 9 || self.rank == 10){
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERSENTAGE verticalOffset:PIP_VOFFSET1_PERSENTAGE mirroredVertically:YES];
    }
    
}
#define CENTER_PIP_FONT_SCALE_FACTOR 0.15
- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
    if (upsideDown) [self pushContextAndRotateUpsideDown];
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont systemFontOfSize:self.bounds.size.width * CENTER_PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{ NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(
                                    middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                    );
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
}
        


@end
