#import "EzLoader.h"
#import <AppList/AppList.h>
#import "spawn.h"
@interface NSUserDefaults (Tweak_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static NSString *nsDomainString = @"com.clarke1234.ezloaderpref";
static NSString *nsNotificationString = @"com.clarke1234.ezloaderpref/preferences.changed";
static BOOL enabled;

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber *n = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
	enabled = (n)? [n boolValue]:YES;
}

%ctor {
	// Set variables on start up
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	// Register for 'PostNotification' notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		notificationCallback,
		(CFStringRef)nsNotificationString,
		NULL,
		CFNotificationSuspensionBehaviorCoalesce);

	// Add any personal initializations
}
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
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleID suspended:FALSE];
				};

	}
}
@end
