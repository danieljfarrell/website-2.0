@import <AppKit/CPView.j>

var GoogleChartURL = @"http://chart.apis.google.com/chart";

NMDGoogleVeriticalStackedBarChart  = @"bvs";
NMDGoogleHorizontalStackedBarChart = @"bhs";
NMDGoogleVeriticalGroupedBarChart  = @"bvg";
NMDGoogleHorizontalGroupedBarChart = @"bhg";
NMDGoogleLineChart                 = @"lc";
NMDGooglePieChart                  = @"p";
NMDGooglePieChart3D                = @"p3";

@implementation NMDGoogleChart : CPView
{
    CPString type @accessors;
    CPArray colors @accessors;
    CPString title @accessors;
    CPString backgroundFill @accessors;
    CPString chartAreaFill @accessors;
    CPArray chartAreaLinearGradientFill @accessors;
    CPArray backgroundLinearGradientFill @accessors;
    CPArray axisLabels @accessors;
    CPArray pieLabels @accessors;
}

+ (id)withFrame:(CGRect)aFrame type:(CPString)aType
{
    return [[self alloc] initWithFrame:aFrame type:aType];
}

- (id)initWithFrame:(CGRect)aFrame type:(CPString)aType
{
    self = [super initWithFrame:aFrame];

    if (self) {
        [self setType:aType];
        [self setAxisLabels:[[CPArray alloc] init]];
    }
    
    return self;
}

-(CPNumber)width
{
    return CGRectGetWidth([self frame]);
}

-(CPNumber)height
{
    h = CGRectGetHeight([self frame]);
    if (type == NMDGooglePieChart3D) {
        return h / 2;
    }
    return h;    
}

- (CPString)formattedSize
{
    return [CPString stringWithFormat:@"%@x%@", [self width], [self height]];
}

- (CPString)formattedColors
{
    if([self colors]){
        var results = [];
        for (var i=0; i < [colors count]; i++) {
            item = [colors objectAtIndex:i];
            if ([[item class] isKindOfClass:CPArray]) {
                item = [item componentsJoinedByString:@"|"];
            }
            [results addObject:item];
        }
        return [CPString stringWithFormat:"chco=%@", [results componentsJoinedByString:@","]];
    }
}

- (CPString)formattedBackgroundFill
{
    return [CPString stringWithFormat:@"bg,s,%@", [self backgroundFill]];
}

- (CPString)formattedChartAreaFill
{
    return [CPString stringWithFormat:@"c,s,%@", [self chartAreaFill]];
}

- (CPArray)formattedChartAreaLinearGradientFill
{
    return [CPString stringWithFormat:@"c,lg,%@,%@,%@,%@,%@", [chartAreaLinearGradientFill objectAtIndex:0],
                                                              [chartAreaLinearGradientFill objectAtIndex:1],
                                                              [chartAreaLinearGradientFill objectAtIndex:2],
                                                              [chartAreaLinearGradientFill objectAtIndex:3],
                                                              [chartAreaLinearGradientFill objectAtIndex:4]];
}

- (CPArray)formattedBackgroundLinearGradientFill
{
    return [CPString stringWithFormat:@"bg,lg,%@,%@,%@,%@,%@", [backgroundLinearGradientFill objectAtIndex:0],
                                                               [backgroundLinearGradientFill objectAtIndex:1],
                                                               [backgroundLinearGradientFill objectAtIndex:2],
                                                               [backgroundLinearGradientFill objectAtIndex:3],
                                                               [backgroundLinearGradientFill objectAtIndex:4]];
}

- (CPString)formattedFills
{
    var results = [];
    if ([self backgroundFill])
        [results addObject:[self formattedBackgroundFill]];
    if ([self chartAreaFill])
        [results addObject:[self formattedChartAreaFill]];
    if ([self chartAreaLinearGradientFill])
        [results addObject:[self formattedChartAreaLinearGradientFill]];
    if ([self backgroundLinearGradientFill])
        [results addObject:[self formattedBackgroundLinearGradientFill]];
    if([results count]){
        return [CPString stringWithFormat:@"chf=%@", [results componentsJoinedByString:@"|"]];
    }
}

- (void)addXAxisLabels:(CPArray)anArray
{
    [axisLabels addObject:[@"x", anArray]];
}

- (void)addYAxisLabels:(CPArray)anArray
{
    [axisLabels addObject:[@"y", anArray]];
}

- (void)addTopAxisLabels:(CPArray)anArray
{
    [axisLabels addObject:[@"t", anArray]];
}

- (void)addRightAxisLabels:(CPArray)anArray
{
    [axisLabels addObject:[@"r", anArray]];
}

- (CPString)formattedAxisLabels
{
    if ([axisLabels count]) {
        arr = [];
        types = [];
        for (var i=0; i < [axisLabels count]; i++) {
            item = [axisLabels objectAtIndex:i];
            [types addObject: [item objectAtIndex:0]];
            labels = [item objectAtIndex:1];
            if ([labels count])
                [arr addObject:[CPString stringWithFormat:@"%@:|%@|", i, [labels componentsJoinedByString:@"|"]]];
        };
        typesQueryString = [CPString stringWithFormat:@"chxt=%@", [types componentsJoinedByString:@","]];
        labelsQueryString =  [CPString stringWithFormat:@"chxl=%@", [arr componentsJoinedByString:@""]];
        return [CPString stringWithFormat:@"%@&%@", typesQueryString, labelsQueryString];
    };
}


- (CPString)formattedPieLabels
{
    // TODO: Throw exception of not a Pie chart
    if ([pieLabels count]) {
        return [CPString stringWithFormat:@"chl=%@", [pieLabels componentsJoinedByString:@"|"]];
    };
}

- (CPString)formattedChartTitle
{
    if (title) {
        return [CPString stringWithFormat:@"chtt=%@", title];
    };
}

- (CPArray)formattedOptions
{
    options = [@selector(formattedChartTitle),
               @selector(formattedPieLabels),
               @selector(formattedAxisLabels),
               @selector(formattedColors),
               @selector(formattedFills)];
    var results = [];
    for (var i=0; i < [options count]; i++) {
        selector = [options objectAtIndex:i];
        result = [self performSelector:selector];
        if(result) { 
            [results addObject:result]; 
        }
    };
    if([results count]) {
        return [CPString stringWithFormat:@"&%@", [results componentsJoinedByString:@"&"]];
    }
    
    return @"";
}

- (CPImage)renderData:(CPArray)data withMaxValue:(NSNumber)maxValue
{
    var file = [CPString stringWithFormat:"%@?chs=%@&cht=%@&chd=%@%@", GoogleChartURL, [self formattedSize], [self type], [self encodeData:data withMaxValue:maxValue], [self formattedOptions]];
    return [[CPImage alloc] initWithContentsOfFile:file];
}

- (CPString)encodeData:(CPArray)data withMaxValue:(NSNumber)maxValue
{
    if ([[[data objectAtIndex:0] class] isKindOfClass:CPArray]) {
        var arr = [];
        for (var i=0; i < [data count]; i++) {
            [arr addObject:[[data objectAtIndex:i] simpleEncodeWithMaxValue:maxValue]];
        };
        encoded = [arr componentsJoinedByString:@","];
    } else {
        encoded = [data simpleEncodeWithMaxValue:maxValue];
    };
    
    return [CPString stringWithFormat:"s:%@", encoded];
}

@end

var simpleEncoding = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

@implementation CPArray (SimpleEncode)

// Cappuccino implementation of http://code.google.com/apis/chart/formats.html#encoding_data
- (CPString)simpleEncodeWithMaxValue:(CPNumber)maxValue
{
    var chartData = [];
    for (var i = 0; i < [self count]; i++) {
        var currentValue = [self objectAtIndex:i];
        if (!isNaN(currentValue) && currentValue >= 0) {
            encoded = simpleEncoding.charAt(Math.round((simpleEncoding.length-1) * currentValue / maxValue));
            [chartData addObject:encoded];
        }
        else {
            [chartData addObject:@"_"];
        }
    }
    
    return [chartData componentsJoinedByString:@""];
}
@end
