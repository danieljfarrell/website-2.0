/*
 * HUDButton.j
 *
 * Created by Aparajita Fishman on May 11, 2010.
 * Copyright 2010, Victory-Heart Productions All rights reserved.
 */


@import <AppKit/CPButton.j>


@implementation HUDButton : CPButton

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        [self fixTheme];
    }
    
    return self;
}


- (void)fixTheme
{
    [self setTheme:[CPTheme themeNamed:@"Aristo-HUD"]];
    
    var theme = [self theme],
        themeClass = [[CPButton class] themeClass];
        attribute = [theme _attributeWithName:@"font" forClass:themeClass],
        font = [attribute valueForState:CPThemeStateBordered];
        
    [self setValue:font forThemeAttribute:@"font" inState:CPThemeStateBordered];
}

@end


@implementation HUDButton (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];
    
    if (self)
    {
        [self fixTheme];
    }
    
    return self;
}

@end
