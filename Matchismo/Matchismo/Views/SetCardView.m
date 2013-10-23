//
//  SetCardView.m
//  Matchismo
//
//  Created by mmh on 19/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark - Properties

-(void)setShape:(NSString *)shape{
    _shape = shape;
    [self setNeedsDisplay];
}
-(void)setShading:(NSNumber *)shading{
    _shading = shading;
    [self setNeedsDisplay];
}

-(void)setColor:(UIColor *)color{
    _color = color;
    [self setNeedsDisplay];
}
-(void)setNumber:(NSInteger)number{
    _number = number;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_RADIUS 12.0
- (void)drawRect:(CGRect)rect
{
    UIBezierPath * roundedRect = [UIBezierPath bezierPathWithRoundedRect: self.bounds  cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
    
    UIColor *cardColor;
    
    if(self.faceUp){
        cardColor = [UIColor grayColor];
        
    }else{
        cardColor = [UIColor whiteColor];
    }
    
    [cardColor setFill];
     UIRectFill(self.bounds);
    [self drawCard];
    
}
#define BORDERS_PERCENT_SIZE 0.1
#define MAX_CARDS_NUMBER 3

-(void)drawCard{
    CGFloat sideBordersSize = self.bounds.size.width * BORDERS_PERCENT_SIZE;
    CGFloat topBordersSize = self.bounds.size.height * BORDERS_PERCENT_SIZE;
    CGFloat cardWidth = self.bounds.size.width - 2 * sideBordersSize;
    CGFloat cardHeight = (self.bounds.size.height - 4 * topBordersSize) / MAX_CARDS_NUMBER;
    
    if(self.number == 1 || self.number == 3) {
        CGRect center    = CGRectMake(sideBordersSize, 2 * topBordersSize + cardHeight, cardWidth, cardHeight);
        [self drawShapeInRect:center];
    }
    
    if(self.number ==2){
        CGRect top = CGRectMake(sideBordersSize,self.bounds.size.height/2 - cardHeight - topBordersSize/2, cardWidth, cardHeight);
        CGRect bottom = CGRectMake(sideBordersSize, self.bounds.size.height/2 + topBordersSize/2, cardWidth, cardHeight);
        
        [self drawShapeInRect:top];
        [self drawShapeInRect:bottom];
    }
    
    if(self.number == 3){
        CGRect top = CGRectMake(sideBordersSize, topBordersSize, cardWidth, cardHeight);
        CGRect bottom = CGRectMake(sideBordersSize, 3 * topBordersSize + 2 * cardHeight, cardWidth, cardHeight);
        
        [self drawShapeInRect:top];
        [self drawShapeInRect:bottom];
        
    }


}

-(void) drawShapeInRect: (CGRect) rect{
    UIBezierPath * shape;
    
    if ([self.shape isEqualToString: @"diamond"]) 
        shape = [self drawDiamondIn:rect];
    else if([self.shape isEqualToString: @"oval"])
        shape = [self drawOvalIn:rect];
    else
        shape = [self drawSquiggleIn:rect];
    
    [[self.color colorWithAlphaComponent:[self.shading doubleValue]] setFill];
    [self.color setStroke];
    [shape stroke];
    [shape fill];
}

-(UIBezierPath *)drawDiamondIn: (CGRect) rect{
    UIBezierPath * diamond = [[UIBezierPath alloc] init];

    
    [diamond moveToPoint:   CGPointMake(rect.origin.x,
                                        rect.origin.y + rect.size.height/2)];
    
    [diamond addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2,
                                        rect.origin.y)];
    
    [diamond addLineToPoint:CGPointMake(rect.origin.x + rect.size.width,
                                        rect.origin.y + rect.size.height/2)];
    
    [diamond addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2,
                                        rect.origin.y + rect.size.height)];
    
    [diamond closePath];
    return diamond;
}


-(UIBezierPath *)drawOvalIn: (CGRect) rect{
    UIBezierPath * oval = [UIBezierPath bezierPathWithOvalInRect:rect];
    return oval;
    
}

#define POINT1_X 0.25
#define POINT1_Y 0.00
#define POINT2_X 0.75
#define POINT2_Y 0.00

#define CURVE1_POINT1_X 0.50
#define CURVE1_POINT1_Y 0.00
#define CURVE1_POINT2_X 1.00
#define CURVE1_POINT2_Y 0.50
#define CURVE2_POINT1_X 1.00
#define CURVE2_POINT1_Y 0.00
#define CURVE2_POINT2_X 1.00
#define CURVE2_POINT2_Y 1.00

-(UIBezierPath *)drawSquiggleIn: (CGRect) rect{

    UIBezierPath * squiggle = [[UIBezierPath alloc] init];

    [squiggle moveToPoint:    [self pointIn: rect x: POINT1_X              y: POINT1_Y]];
    [squiggle addCurveToPoint:[self pointIn: rect x: POINT2_X              y: POINT2_Y]
                controlPoint1:[self pointIn: rect x: CURVE1_POINT1_X       y: CURVE1_POINT1_Y]
                controlPoint2:[self pointIn: rect x: CURVE1_POINT2_X       y: CURVE1_POINT2_X]];
    [squiggle addCurveToPoint:[self pointIn: rect x: (1 - POINT1_X)        y: (1 - POINT1_Y)]
                controlPoint1:[self pointIn: rect x: CURVE2_POINT1_X       y: CURVE2_POINT1_Y]
                controlPoint2:[self pointIn: rect x: CURVE2_POINT2_X       y: CURVE2_POINT2_X]];
    [squiggle addCurveToPoint:[self pointIn: rect x: (1 - POINT2_X)        y: (1 - POINT2_Y)]
                controlPoint1:[self pointIn: rect x: (1 - CURVE1_POINT1_X) y: (1 - CURVE1_POINT1_Y)]
                controlPoint2:[self pointIn: rect x: (1 - CURVE1_POINT2_X) y: (1 - CURVE1_POINT2_X)]];
    [squiggle addCurveToPoint:[self pointIn: rect x: POINT1_X              y: POINT1_Y]
                controlPoint1:[self pointIn: rect x: (1 - CURVE2_POINT1_X) y: (1 - CURVE2_POINT1_Y)]
                controlPoint2:[self pointIn: rect x: (1 - CURVE2_POINT2_X) y: (1 - CURVE2_POINT2_X)]];
    
    return squiggle;
    
}

-(CGPoint)pointIn:(CGRect)rect x: (CGFloat) xcoeff y: (CGFloat) ycoeff{
    return CGPointMake(rect.origin.x + rect.size.width * xcoeff, rect.origin.y + rect.size.height * ycoeff);

}
+(NSArray*) validShapes{
    return @[@"diamond",@"squiggle",@"oval"];
}
@end

