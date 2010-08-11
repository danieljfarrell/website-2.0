@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation Chart : CPView
{
    double fillFraction;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    fillFraction = 1.;
    return self;
}

- (double) fillFraction
{
    return fillFraction;
}

- (void) setFillFraction:(double) aNum
{
    fillFraction = aNum;
}

- (void) drawRect: (CGRect) aRect
{   
    var path1 = [CPBezierPath bezierPath];
    
    fillRect = CGRectMake( CGRectGetMinX([self bounds]),
                           CGRectGetMinY([self bounds]),
                           CGRectGetWidth([self bounds]) * fillFraction,
                           CGRectGetHeight([self bounds])/8. );
    
    [path1 appendBezierPathWithRect:fillRect];
    
    [[CPColor colorWithRed:0.1 green:0.3 blue:0.6 alpha:0.9] set];
    [path1 fill];
}

@end