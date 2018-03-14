#import "EzLoader.h"
#import <AppList/AppList.h>
#import "spawn.h"


@interface UIApplication (PrivateMethods)
- (BOOL)launchApplicationWithIdentifier:(NSString *)identifier suspended:(BOOL)suspend;
@end

@interface UIImage ()
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
@end

@implementation EzLoader
- (UIImage *)iconGlyph {
	return [UIImage imageNamed:@"Icon" inBundle:[NSBundle bundleForClass:[self class]]];
}


- (BOOL)isSelected {
	return self.EzLoader;
}

- (void)setSelected:(BOOL)selected {
  self.EzLoader = selected;
	[super refreshState];
    [self launchapp];
}

- (void)launchapp {

    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];

    // Either this or whatever works from link after this
    NSString *plistpath = @"/User/Library/Preferences/com.clarke1234.ezloaderpref.plist";
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistpath];
    if ([[plistDict objectForKey:bundleID] boolValue]) {
        [[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleID suspended:FALSE];
				};

	}

@end
