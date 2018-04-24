#include "FSARootListController.h"
#include <SparkAppListTableViewController.h>
@implementation FSARootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}
-(void)selectExcludeApps
{
    // Replace "com.spark.notchlessprefs" and "excludedApps" with your strings
    SparkAppListTableViewController* s = [[SparkAppListTableViewController alloc] initWithIdentifier:@"com.clarke1234.fullscreenappsprefs" andKey:@"allowedApps"];

    [self.navigationController pushViewController:s animated:YES];
    self.navigationItem.hidesBackButton = FALSE;
}
@end
