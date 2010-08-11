
@import <AppKit/CPView.j>



@implementation Pie : CPView
{
    float effic;
    float Thermal;
}

- (void) setEffic: (float) value {
    effic = value
}   

- (void) setThermal: (float) value {
    Thermal = value
}

- (float) effic {
    return effic
}

- (float) Thermal {
    return Thermal
}

- (void)drawRect:(CPRect)aRect
{
	var bounds = [self bounds];
	
	//Losses through thermalisation
	
	var context = [[CPGraphicsContext currentContext] graphicsPort];
	
	
	CGContextAddArc	(context,790,440, 100,0,2*PI);
	//CGContextClosePath(context);
	
	
	
	CGContextSetFillColor(context, [CPColor yellowColor]);
	CGContextFillPath(context);

	//CGContextSetStrokeColor(context, [CPColor blackColor]);
	//CGContextStrokePath(context);
	

	CGContextFillRect(context, CPMakeRect(310,540, 15,15));
	
	//Losses through other stuff
	
	var context2 = [[CPGraphicsContext currentContext] graphicsPort];
	
	CGContextBeginPath(context2);
	CGContextMoveToPoint(context2, 790, 440.0);
	CGContextAddLineToPoint(context2,790.0, 340.0);
	CGContextMoveToPoint(context2, 790.0, 440.0);
	CGContextAddArc(context2,790,440,100,3/2*PI-Thermal+0.0000001,3*PI/2);
	CGContextClosePath(context2);
	
	
	
	
	CGContextSetFillColor(context2, [CPColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:0.9]);
	CGContextFillPath(context2);
	
	//CGContextSetStrokeColor(context2, [CPColor blackColor]);
	//CGContextStrokePath(context2);
	
	CGContextFillRect(context2, CPMakeRect(160,540, 15,15));
	
	//Efficiency Segment
	
	var context3 = [[CPGraphicsContext currentContext] graphicsPort];
	
	CGContextBeginPath(context3);
	CGContextMoveToPoint(context3, 790.0, 440.0);
	CGContextAddLineToPoint(context3, 790.0, 340.0);
	CGContextMoveToPoint(context3,790,440);
	CGContextAddArc(context3,790,440,100,3*PI/2, ((-1)*effic + 3*PI/2))
	
	CGContextClosePath(context3);
	
	
	CGContextSetFillColor(context3,[CPColor colorWithRed:0.1 green:0.3 blue:0.8 alpha:0.9]);
	CGContextFillPath(context3);

	//CGContextSetStrokeColor(context3, [CPColor blackColor]);
	//CGContextStrokePath(context3);
	
	CGContextFillRect(context2, CPMakeRect(10,540, 15,15));
	
	
	
	
	
}
