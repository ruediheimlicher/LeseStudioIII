#import <Cocoa/Cocoa.h>

@interface rAdminDS : NSObject <NSTableViewDataSource, NSTableViewDelegate>
{
   NSMutableArray *rowData;
	NSMutableArray* AufnahmeFiles;
	NSMutableArray* AuswahlArray;
	NSMutableArray* MarkArray;
	NSMutableArray* UserMarkArray;
    BOOL _editable;
}

- (id)initWithRowCount: (int)rowCount;


- (int)rowCount;
- (NSArray*)rowData;
- (BOOL)isEditable;
- (void)setEditable:(BOOL)b;


- (void)setData: (NSDictionary *)someData forRow: (int)rowIndex;
- (NSDictionary *)dataForRow: (int)rowIndex;
- (int)ZeileVonLeser:(NSString*)derLeser;

- (void)setAufnahmeFiles:(NSArray*)derArray forRow: (int)dieZeile;
- (NSArray*)AufnahmeFilesFuerZeile:(int)dieZeile;

- (void)setMarkArray:(NSArray*)derArray forRow:(int)dieZeile;
- (void)setMark:(BOOL)derStatus forRow:(int)dieZeile forItem:(int)dasItem;
- (NSArray*)MarkArrayForRow:(int)dieZeile;
- (BOOL)MarkForRow:(int)dieZeile forItem:(int)dasItem;

- (void)setAuswahl:(int)dasItem forRow:(int) rowIndex;
- (int)AuswahlFuerZeile:(int)dieZeile;



- (int)rowCount;

- (void) insertRowAt:(int)rowIndex;
- (void) insertRowAt:(int)rowIndex withData: (NSDictionary *)someData;
- (void) deleteRowAt:(int)rowIndex;
- (void)deleteDataZuName:(NSString*)derName;
- (void) deleteAllData;


@end
