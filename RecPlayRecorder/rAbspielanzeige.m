#import "rAbspielanzeige.h"

@implementation rAbspielanzeige

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) 
	{
		NSRect BalkenRect=[self frame];
		//BalkenRect.size.height-=2;
		Rahmenbreite=BalkenRect.size.width-1;
		Rahmenhoehe=BalkenRect.size.height-2;
		Feldbreite=0;
		Feldhoehe=Rahmenhoehe;
		Level=0;
		Max=Rahmenbreite;
		
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
	
	[self drawLevelmeter];
	
}
- (void)setLevel:(int) derLevel
{
	if (derLevel>Max)
		Level=Max;
	else
		Level=derLevel;
	//NSLog(@"Level ein: %d Level aus: %d",derLevel,Level);
	//[self drawLevelmeter];	
	[self display];
}
- (void)drawLevelmeter
{
	[self lockFocus];
	
	Feldbreite= Rahmenbreite/Max*Level;
	NSRect f;
	NSPoint Nullpunkt=NSMakePoint(1,2);
	f=NSMakeRect(Nullpunkt.x,Nullpunkt.y,Feldbreite,Feldhoehe-1);
	[[NSColor blackColor]set];
	//[NSBezierPath strokeRect:f];
	//[[NSColor greenColor] set];
	NSColor* BalkenFarbe=[NSColor colorWithDeviceRed:90.0/255 green:255.0/255 blue:130.0/255 alpha:1.0];
	[BalkenFarbe set];
	[NSBezierPath fillRect:f];
	f=NSMakeRect(Feldbreite+1,Nullpunkt.y,Rahmenbreite-1,Feldhoehe-1);
	[[NSColor blackColor]set];
	//[NSBezierPath strokeRect:f];
	[[NSColor whiteColor] set];
	[NSBezierPath fillRect:f];
	NSRect BalkenRect=[self bounds];
	BalkenRect.size.height-=1;
	BalkenRect.size.width-=1;
	[[NSColor grayColor]set];	

	[NSBezierPath strokeRect:BalkenRect];
	
	[self unlockFocus];
	
}
- (void)setMax:(int)dasMax
{
	Max=dasMax;
}

@end
