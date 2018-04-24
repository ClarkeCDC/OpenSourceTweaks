#include <SparkAppList.h>


%hook UIStatusBarStyleRequest
NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
-(id)initWithStyle:(long long)arg1 legacy:(BOOL)arg2 legibilityStyle:(long long)arg3 foregroundColor:(id)arg4 foregroundAlpha:(double)arg5 overrideHeight:(id)arg6 {
	if([SparkAppList doesIdentifier:@"com.clarke1234.fullscreenappsprefs" andKey:@"allowedApps" containBundleIdentifier:bundleIdentifier]) {
			arg1 = -1;
			return %orig;
		}
		else{
			
    		return %orig;

		}
}


%end