

@import <Foundation/CPObject.j>
@import "Chart.j"
@import "HUDButton.j"
@import "Spectrum.j"
@import "Pie.j"

@implementation AppController : CPObject
{
	 //CPSlider slider2;
	 CPTextField eVlabel;
	 CPTextField efflabel;
	 CPTextField voltlabel;
	 CPTextField amplabel;
	 CPTextField scaleStartLabel;
	 CPTextField scaleEndLabel;
	 CPTextField panelTitle;
     CPPanel HUDPanel;
	 
	 CPString pe6;
	 CPString pe5;
	 CPString pe4;
	 CPString pe3;
	 CPString pe2;
	 CPString pe1;
	 CPString pe0;
	 CPString pescale;
	 
	 CPString pv6;
	 CPString pv5;
	 CPString pv4;
	 CPString pv3;
	 CPString pv2;
	 CPString pv1;
	 CPString pv0;
	 CPString pvscale;
	 
	 CPString pi6;
	 CPString pi5;
	 CPString pi4;
	 CPString pi3;
	 CPString pi2;
	 CPString pi1;
	 CPString pi0;
	 CPString piscale;
	 
	 CPString hotC;
	 
     Chart efficiency;
     Chart voltage;
	 Chart current;
	 
	 HUDButton SQButton;
	 	 
	 Spectrum spectrum;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    //Specifications of Main Window
	
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];
		[theWindow setBackgroundColor:[CPColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.9]];
		
		[theWindow setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

		

    // DJF: 29.5.2010
    //The image view
    var spectrumImage = [[CPImageView alloc] initWithFrame:CPMakeRect(10.0,60.0,580.,250.)];
    [spectrumImage setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/spectrum-small.png"]];
	
	[spectrumImage setAutoresizingMask: //CPViewMinXMargin  
                                    CPViewMaxXMargin |
                                //CPViewMinYMargin  ];
                                CPViewMaxYMargin];
    //[spectrumImage setBackgroundColor:[CPColor whiteColor]];
    
    //The fill view and slider
    spectrum = [[Spectrum alloc] initWithFrame:CPMakeRect(10.,60.0,580,250.0)];
    [contentView addSubview:spectrum];
    [contentView addSubview:spectrumImage];
    //var spectrumLabel = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    //var spectrumFont = [[CPFont alloc ] init];
    //[spectrumLabel setStringValue:@"Spectrum"]
    //[contentView]
    
    
    
	//HUD(Control)Panel
		HUDPanel = [[CPPanel alloc] 
		initWithContentRect:CGRectMake( 690, 107.0, 220, 180)
		styleMask:CPHUDBackgroundWindowMask];
		
		panelTitle =[CPString stringWithFormat:@"Shockley-Queisser"];
		
		[HUDPanel setFloatingPanel:YES];
		[HUDPanel setTitle:panelTitle];
		[HUDPanel orderFront:self];
		[HUDPanel setBackgroundColor:[CPColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9]];
		//[HUDPanel setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[HUDPanel setAutoresizingMask: //CPViewMinXMargin  
                                    CPViewMaxXMargin 
                                  //CPViewMinYMargin  ];
                                   |CPViewMaxYMargin];
		
		var panelContentView = [HUDPanel contentView],
		centerX = (CGRectGetWidth([panelContentView bounds]) - 135.0) / 2.0;
		
	//Slider
	var slider = [[CPSlider alloc] initWithFrame:CGRectMake(centerX, 30.0, 135.0, 60.0)];
	
	[slider setTarget:self];
    [slider setAction:@selector(sliderDidChange:)];
	[slider setMinValue:0];
	[slider setMaxValue:100];
	[slider setValue:50];

	var scaleStartLabel = [self labelWithTitle:"0 eV"];
    var scaleEndLabel = [self labelWithTitle:"4 eV"];

	[scaleStartLabel setFrameOrigin:CGPointMake(centerX - CGRectGetWidth([scaleStartLabel frame]), 20)];
	[scaleEndLabel setFrameOrigin:CGPointMake(CGRectGetMaxX([slider frame]), 20)];
	
	[panelContentView addSubview:scaleStartLabel];
	[panelContentView addSubview:scaleEndLabel];

	[panelContentView addSubview:slider];
		
		
	var efflabel2 = [self labelWithTitle:"Efficiency"]	
	[efflabel2 setFrameOrigin:CGPointMake(10.0,380)];
	[efflabel2 setFont:[CPFont boldSystemFontOfSize:24.0]];
	[efflabel2 sizeToFit];
	[contentView addSubview:efflabel2];
	
	var voltlabel2 = [self labelWithTitle:"Voltage"]	
	[voltlabel2 setFrameOrigin:CGPointMake(10.0,430)];
	[voltlabel2 setFont:[CPFont boldSystemFontOfSize:24.0]];
	[voltlabel2 sizeToFit];
	[contentView addSubview:voltlabel2];
	
	var amplabel2 = [self labelWithTitle:"Current"]	
	[amplabel2 setFrameOrigin:CGPointMake(10.0,480)];
	[amplabel2 setFont:[CPFont boldSystemFontOfSize:24.0]];
	[amplabel2 sizeToFit];
	[contentView addSubview:amplabel2];
	
	
	//Control Buttons
	SQButton = [[HUDButton alloc] initWithFrame: CGRectMake(centerX+20,80,130,30)];                 
	[SQButton setTitle:"Hot Carrier"]; 
	[SQButton sizeToFit];                        
	[panelContentView addSubview:SQButton];
	
	[SQButton setTarget:self];
	[SQButton setAction:@selector(swap:)];
	

	//Title
	var qos =[[CPTextField alloc] initWithFrame: CGRectMake(10,10)];
	[qos setFont:[CPFont boldSystemFontOfSize:20.0]];
	[qos setTextColor:[CPColor whiteColor]];
	[qos setStringValue:"Quantum of Sol Web-App"];
	[qos sizeToFit];
	[contentView addSubview:qos];
	
	//Labels
	
	var eVlabel = [[CPTextField alloc] initWithFrame:CGRectMake(90,20)];
	var efflabel = [[CPTextField alloc] initWithFrame:CGRectMake(550,380)];
	var voltlabel = [[CPTextField alloc] initWithFrame:CGRectMake(550,430)];
	var amplabel = [[CPTextField alloc] initWithFrame:CGRectMake(550,480)];
	
    
    [eVlabel setFont:[CPFont boldSystemFontOfSize:14.0]];
    [eVlabel setTextColor:[CPColor whiteColor]];
	[efflabel setFont:[CPFont boldSystemFontOfSize:24.0]];
	[efflabel setTextColor: [CPColor whiteColor]];
	[voltlabel setFont:[CPFont boldSystemFontOfSize:24.0]];
	[voltlabel setTextColor: [CPColor whiteColor]];
	[amplabel setFont:[CPFont boldSystemFontOfSize:24.0]];
	[amplabel setTextColor: [CPColor whiteColor]];
    
	[panelContentView addSubview:eVlabel];
	[contentView addSubview:efflabel];
	[contentView addSubview:voltlabel];
	[contentView addSubview:amplabel];
	
	
	var efflabel2 = [[CPTextField alloc] initWithFrame:CGRectMake(10,380)];
	efflabel2 = [CPString stringWithFormat:@"Efficiency"];
	
	
	var voltlabel2 = [[CPTextField alloc] initWithFrame:CGRectMake(10,430)];
	voltlabel2 = [CPString stringWithFormat:@"Voltage"];
	
	var amplabel2 = [[CPTextField alloc] initWithFrame:CGRectMake(10,480)];
	amplabel2 = [CPString stringWithFormat:@"Current"];
	
	//Bar Charts
	efficiency = [[Chart alloc] initWithFrame:CPMakeRect(150.0, 380, 400, 300)];
	[contentView addSubview:efficiency];
    [contentView setNeedsDisplay:YES];
	
	[efficiency setAutoresizingMask: CPViewMaxXMargin |CPViewMaxYMargin  ];
                                  
	
	voltage = [[Chart alloc] initWithFrame:CPMakeRect(150.0, 430, 400, 300)];
	[contentView addSubview:voltage];
    [contentView setNeedsDisplay:YES];
	
	[voltage setAutoresizingMask:  CPViewMaxXMargin |CPViewMaxYMargin  ];
                                  
	
	current = [[Chart alloc] initWithFrame:CPMakeRect(150.0, 480, 400, 300)];
	[contentView addSubview:current];
    [contentView setNeedsDisplay:YES];
	
	[current setAutoresizingMask: CPViewMaxXMargin |CPViewMaxYMargin  ];
                                   
    
   //Pie chart
   
   
    pie = [[Pie alloc] initWithFrame:CGRectMake(0.0,0.0,900,570)];
    
    
    [contentView addSubview:pie];
	  
	[theWindow orderFront:self];
	
	//Pie Chart explanotory Labels
	
	var PieEffLabel = [self labelWithTitle:"Efficiency"];
	[PieEffLabel setFrameOrigin:CGPointMake(27, 540)];
	[contentView addSubview:PieEffLabel];
	
	var PieTherLabel = [self labelWithTitle:"Thermalisation"];
	[PieTherLabel setFrameOrigin:CGPointMake(177, 540)];
	[contentView addSubview:PieTherLabel];
	
	var PieWorkLabel = [self labelWithTitle:"Other Losses"];
	[PieWorkLabel setFrameOrigin:CGPointMake(327, 540)];
	[contentView addSubview:PieWorkLabel];
	
	var solarSpectrumLabel = [self labelWithTitle:"Solarspectrum [Energy in eV]"];
	[solarSpectrumLabel setFrameOrigin:CGPointMake(10,320.0)];
	[contentView addSubview:solarSpectrumLabel];
	
	var energyDiagram =[self labelWithTitle:"Energy-Loss Diagram"];
	[energyDiagram setFrameOrigin:CGPointMake(720,310)];
	[contentView addSubview:energyDiagram];
	
	
	//Polynomial Variables
	
	//Efficiency Shockley
	pe6 = 0.007017691;
	pe5=-0.09415431;
	pe4=0.4799949;
	pe3=-1.112411;
	pe2=0.9997127;
	pe1=0.006306745;
	pe0=0;
	pescale=30.9;
	//Volt Shockley
	pv6 = 0.005359365;
	pv5 = -0.07085459;
	pv4 = 0.3672524;
	pv3 = -0.9473078;
	pv2 = 1.281019;
	pv1 = 0.04924844;
	pv0 = 0;
	pvscale=3.48;
	//Polyamp Shockley
	
	pi6 = -15.0963;
	pi5 = 223.7189;
	pi4 = -1317.474;
	pi3 = 3885.719;
	pi2 = -5829.221;
	pi1 = 3651.869;
	pi0 = 0;
	piscale=782;
	
	//Thermal/Scaling Factor
	hotC=1;
	
    // Uncomment the following line to turn on the standard menu bar.
   [CPMenu setMenuBarVisible:YES];
}

//Method to set Label of Scale Slider
- (CPTextField)labelWithTitle:(CPString)aTitle
{
    var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    
    [label setStringValue:aTitle];
    [label setTextColor:[CPColor whiteColor]];
	[label setFont:[CPFont systemFontOfSize:14.0]];
    
    [label sizeToFit];

    return label;
}

//Button Function

- (void)swap:(id)sender
{
    if (panelTitle == "Shockley-Queisser")
        {
			[panelTitle ="Hot Carrier"];
			[HUDPanel setTitle:panelTitle];
			
			
			[SQButton setTitle:"Shockley-Queisser"];
			[SQButton sizeToFit];
			
			
			pe6 = 0.001766508;
			pe5 = -0.02288501;
			pe4 = 0.1036312;
			pe3 = -0.1595574;
			pe2 = -0.06791501;
			pe1 = 0.08835511;
			pe0 = 0.6465231;
			pescale=66.37;
			
			pv6 = 0.001259357;
			pv5 = -0.01851973;
			pv4 = 0.1130553;
			pv3 = -0.3753707;
			pv2 = 0.7556839;
			pv1 = -0.05358689;
			pv0 = 0.9698921;
			pvscale=3.96;
			
			pi6 =-1.63943;
			pi5 = 27.6219;
			pi4 =-186.8072;
			pi3 = 624.6495;
			pi2 = -952.3383;
			pi1 =153.6631;
			pi0 =  908.9955;
			piscale=915.32;
			hotC=0;
		}			
		else
        {
			[panelTitle ="Shockley-Queisser"];
			[HUDPanel setTitle:panelTitle];
			
			[SQButton setTitle:"Hot Carrier"];
			[SQButton sizeToFit];
			
			pe6 = 0.007017691;
			pe5=-0.09415431;
			pe4=0.4799949;
			pe3=-1.112411;
			pe2=0.9997127;
			pe1=0.006306745;
			pe0=0;
			pescale=30.9;
			
			pv6 = 0.005359365;
			pv5 = -0.07085459;
			pv4 = 0.3672524;
			pv3 = -0.9473078;
			pv2 = 1.281019;
			pv1 = 0.04924844;
			pv0 = 0;
			pvscale=3.48;
			
			pi6 = -15.0963;
			pi5 = 223.7189;
			pi4 = -1317.474;
			pi3 = 3885.719;
			pi2 = -5829.221;
			pi1 = 3651.869;
			pi0 = 0;
			piscale=782;
			hotC=1;
		}
		
}


//Calculation Part
-(void)sliderDidChange:(id)sender
{
	
	var eV = (([sender floatValue]/25));
	
	var thermalisation =[((-0.0009249523*eV*eV*eV*eV*eV*eV) + (0.01386276*eV*eV*eV*eV*eV) + (-0.07918361*eV*eV*eV*eV) + (0.1924858*eV*eV*eV) + (-0.04701058*eV*eV) + (-0.6680612*eV)+0.9744178).toFixed(2)];
	
	
	var polyeff = [(((pe6*eV*eV*eV*eV*eV*eV) + (pe5*eV*eV*eV*eV*eV) + (pe4*eV*eV*eV*eV) + (pe3*eV*eV*eV) + (pe2*eV*eV) + (pe1*eV)+pe0)*100).toFixed(2)];
	var polyvolt = [((pv6*eV*eV*eV*eV*eV*eV) + (pv5*eV*eV*eV*eV*eV) + (pv4*eV*eV*eV*eV) + (pv3*eV*eV*eV) + (pv2*eV*eV) + (pv1*eV)+pv0).toFixed(2)];
	var polyamp = [((pi6*eV*eV*eV*eV*eV*eV) + (pi5*eV*eV*eV*eV*eV) + (pi4*eV*eV*eV*eV) + (pi3*eV*eV*eV) + (pi2*eV*eV) + (pi1*eV)+ pi0).toFixed(2)];
	var angleEff = polyeff*2*PI/100;
	var angleTherm = (2*PI -(thermalisation*2*PI))*hotC;
	
	
	[spectrum setXFillFraction:eV/(4.0)];
	[spectrum setNeedsDisplay:YES];
	[eVlabel setStringValue:(eV).toFixed(2)];
	[eVlabel sizeToFit];
	
	polyeff_label = [CPString stringWithFormat:@"%s %%", polyeff];
	[efflabel setStringValue:polyeff_label];
	[efflabel sizeToFit];
	
	polyvolt_label = [CPString stringWithFormat:@"%s V", polyvolt];
	[voltlabel setStringValue:(polyvolt_label)];
	[voltlabel sizeToFit];
	
	polyamp_label = [CPString stringWithFormat:@"%s A/m^2", polyamp];
	[amplabel setStringValue:(polyamp_label)];
	[amplabel sizeToFit];
	
    [efficiency setFillFraction:polyeff/pescale];
    [voltage setFillFraction:polyvolt/pvscale];
	[current setFillFraction:polyamp/piscale];
    [current setNeedsDisplay:YES];
    [efficiency setNeedsDisplay:YES];
	[voltage setNeedsDisplay:YES]
	
	
	//Pie Chart
	
	[pie setEffic:angleEff];
	[pie setThermal:angleTherm];
	[pie setNeedsDisplay:YES];
	
}
@end
