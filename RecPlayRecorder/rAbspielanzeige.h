/* rAbspielanzeige */

#import <Cocoa/Cocoa.h>

@interface rAbspielanzeige : NSView
{
	float Max;
	int Rahmenhoehe, Rahmenbreite;
	float Feldbreite;
	int Feldhoehe;
	//int AnzFelder;
	float Level;
	//int Grenze;
}
- (void)setLevel:(int) derLevel;
- (void)drawLevelmeter;
- (void)setMax:(int)dasMax;
@end
