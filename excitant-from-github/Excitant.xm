#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <FrontBoardServices/FBSSystemService.h>
#import <spawn.h>
#import <notify.h>
#import <sys/wait.h>
#import "AppList.h"

#include <Excitant.h>

#define PLIST_PATH @"/var/mobile/Library/Preferences/EXCITANTTAPS.plist"
#define EXCITANTTOUCHES_PATH @"/var/mobile/Library/Preferences/EXCITANTTOUCHES.plist"
// Status bar Prefs
inline bool GetPrefBool(NSString *key) {
return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}

inline int GetPrefInt(NSString *key) {
return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] intValue];
}

inline float GetPrefFloat(NSString *key) {
return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] floatValue];
}
static NSString *tapapp;
// static void loadPrefsTop() { //Triple Tap version
// NSDictionary *Tapprefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/EXCITANTTAPS.plist"];
// tapapp [Tapprefs objectForKey:@"launchAppTap"]; //Setting up variables
// }

//End Status Bar Prefs
//Mute Switch Prefs
NSString *switchpath = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.chilaxan.ezswitchprefs.plist"];
NSDictionary *switchsettings = [NSMutableDictionary dictionaryWithContentsOfFile:switchpath];

static BOOL isEzSwitchEnabled = (BOOL)[[switchsettings objectForKey:@"switchenabled"]?:@TRUE boolValue];
static NSInteger switchPreference = (NSInteger)[[switchsettings objectForKey:@"switchPreferences"]?:@9 integerValue];
//End Mute Switch Prefs

//Touches Prefs
inline bool GetPrefTouchesBool(NSString *key) {
return [[[NSDictionary dictionaryWithContentsOfFile:EXCITANTTOUCHES_PATH] valueForKey:key] boolValue]; //Looks for bool
}

//Touches Applist
static NSString *touchesLeft;
static NSString *touchesRight;

static void loadPrefsTouchesLeft() { //Triple Tap version
NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/EXCITANTTOUCHES.plist"];
touchesLeft = [prefs objectForKey:@"touchesAppLeft"]; //Setting up variables
}

static void loadPrefsTouchesRight() { //Triple Tap version
NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/EXCITANTTOUCHES.plist"];
touchesRight = [prefs objectForKey:@"touchesAppRight"]; //Setting up variables
}

@implementation ExcitantWindow
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIWindow *window in self.subviews) {
        if (!window.hidden && window.userInteractionEnabled && [window pointInside:[self convertPoint:point toView:window] withEvent:event])
            return YES;
    }
    return NO;
}
@end

@implementation ExcitantView
@end

@implementation Excitant

+(void)AUXtoggleFlash {
AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn]) {
	BOOL success = [flashLight lockForConfiguration:nil];
		if (success) {
			if (flashLight.torchMode == AVCaptureTorchModeOn) {
				[flashLight setTorchMode:AVCaptureTorchModeOff];
			} else {
				[flashLight setTorchMode:AVCaptureTorchModeOn];
			}
			[flashLight unlockForConfiguration];
		}
	}
}

+(void)AUXtoggleLPM {
	if([[objc_getClass("_CDBatterySaver") batterySaver] getPowerMode] == 1){
		[[objc_getClass("_CDBatterySaver") batterySaver] setPowerMode:0 error:nil];
	}else{
		[[objc_getClass("_CDBatterySaver") batterySaver] setPowerMode:1 error:nil];
	}
}

+(void)AUXtoggleAirplaneMode {
	SBAirplaneModeController *airplaneManager = [objc_getClass("SBAirplaneModeController") sharedInstance];
	if ([airplaneManager isInAirplaneMode]) {
		[airplaneManager setInAirplaneMode:0];
	} else {
		[airplaneManager setInAirplaneMode:1];

	}
}

+(void)AUXtoggleMute {
	MNRingerSwitchObserver *muteManager = [objc_getClass("MNRingerSwitchObserver") sharedInstance];
	if ([muteManager ringerSwitchEnabled]) {
		[muteManager setRingerSwitchEnabled:0];
	} else {
		[muteManager setRingerSwitchEnabled:1];
	}
}

+(void)AUXtoggleRotationLock {
	SBOrientationLockManager *orientationManager = [%c(SBOrientationLockManager) sharedInstance];
	if ([orientationManager isUserLocked]) {
		[orientationManager unlock];
	} else {
		[orientationManager lock];
	}
}

+(void)AUXcontrolCenter {
	[[%c(SBControlCenterController) sharedInstance] presentAnimated:TRUE];
}

+(void)AUXrespring {
	pid_t pid;
    int status;
    const char* args[] = {"killall", "-9", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
}

+(void)AUXlaunchApp:(id)arg1 {	//Before calling, save bundle id to (AUXapp)
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:arg1 suspended:FALSE];
}

+(void)AUXLockDevice{
	[[objc_getClass("SBBacklightController") sharedInstance] _startFadeOutAnimationFromLockSource:1];
}
/*-(void)AUXhomePress {
	[[objc_getClass("SpringBoard") sharedApplication] _simulateHomeButtonPress];
}*/

@end

// Example //
// %hook SBHomeHardwareButtonActions
// -(void)performTriplePressUpActions{
// 	[Excitant AUXtoggleFlash];
// }
// %end
// Example


// TapTapUtils Shit
// NSNumber* uicache;
// NSNumber* respring;
// NSNumber* rebootd;
// NSNumber* safemode;
// NSNumber* shutdownd;
// NSNumber* sleepdd;
//TapTapUtilsShit


//Just hard coding in some gesture recognizers
%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
    %orig;
		UIWindow * screen = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];

		ExcitantView * rightView=[[ExcitantView alloc]initWithFrame:CGRectMake(screen.bounds.size.width, screen.bounds.size.height, - 20, - 100)];
			if(GetPrefTouchesBool(@"setColor")){
				[rightView setBackgroundColor:[UIColor redColor]];
			}else{
				[rightView setBackgroundColor:[UIColor colorWithWhite:0.001 alpha:0.001]];
			}
	    [rightView setAlpha: 1];
			[rightView setHidden:NO];
	    rightView.userInteractionEnabled = TRUE;

		ExcitantView * leftView=[[ExcitantView alloc]initWithFrame:CGRectMake(screen.bounds.origin.x, screen.bounds.size.height, 20, - 100)];
			if(GetPrefTouchesBool(@"setColor")){
				[leftView setBackgroundColor:[UIColor redColor]];
			}else{
			[leftView setBackgroundColor:[UIColor colorWithWhite:0.001 alpha:0.001]];
		  }
	    [leftView setAlpha: 1];
			[leftView setHidden:NO];
	    leftView.userInteractionEnabled = TRUE;

		ExcitantWindow *window = [[ExcitantWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		window.windowLevel = 1005;
		[window setHidden:NO];
		[window setAlpha:1.0];
		[window setBackgroundColor:[UIColor clearColor]];
		[window addSubview:rightView];
		[window addSubview:leftView];


/*UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapTapUtils)];
tapRecognizer.numberOfTapsRequired = 2;
[self addGestureRecognizer:tapRecognizer];*/


		UITapGestureRecognizer *rightRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TouchRecognizerRight:)];
		if(GetPrefTouchesBool(@"taps2")){
	    rightRecognizer.numberOfTapsRequired = 2;
			[rightView addGestureRecognizer:rightRecognizer];
		}else if(GetPrefTouchesBool(@"taps3")){
			rightRecognizer.numberOfTapsRequired = 3;
			[rightView addGestureRecognizer:rightRecognizer];
		}else if (GetPrefTouchesBool(@"taps4")){
			rightRecognizer.numberOfTapsRequired = 4;
			[rightView addGestureRecognizer:rightRecognizer];
		}else{
			rightRecognizer.numberOfTapsRequired = 1;
	    [rightView addGestureRecognizer:rightRecognizer];
		}

		UITapGestureRecognizer *leftRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TouchRecognizerLeft:)];
		if(GetPrefTouchesBool(@"taps2")){
			leftRecognizer.numberOfTapsRequired = 2;
			[leftView addGestureRecognizer:leftRecognizer];
		}else if(GetPrefTouchesBool(@"taps3")){
			leftRecognizer.numberOfTapsRequired = 3;
			[leftView addGestureRecognizer:leftRecognizer];
		}else if (GetPrefTouchesBool(@"taps4")){
			leftRecognizer.numberOfTapsRequired = 4;
			[leftView addGestureRecognizer:leftRecognizer];
		}else{
			leftRecognizer.numberOfTapsRequired = 1;
			[leftView addGestureRecognizer:leftRecognizer];
		}
}

//Mute Switch Function
- (void)_updateRingerState:(int)arg1 withVisuals:(BOOL)arg2 updatePreferenceRegister:(BOOL)arg3 {
	if(arg1) {
		if (isEzSwitchEnabled) {
			if (switchPreference == 0) {		
				[Excitant AUXtoggleFlash];
				}	
			if (switchPreference == 1){
				[Excitant AUXtoggleLPM];
			}
			if (switchPreference == 2) {
                [Excitant AUXtoggleAirplaneMode];
			}
            if (switchPreference == 3) {
                [Excitant AUXtoggleMute]; //DOES NOT WORK YET
			}
			if (switchPreference == 4) {
                [Excitant AUXtoggleRotationLock];
			}            
		} else {
			%orig;
		}
	} 
}	
//End Mute Switch Function

%new
- (void) TouchRecognizerRight:(UITapGestureRecognizer *)sender {
	loadPrefsTouchesRight();
	[Excitant AUXlaunchApp:touchesRight];
}

%new
- (void) TouchRecognizerLeft:(UITapGestureRecognizer *)sender {
	loadPrefsTouchesLeft();
	[Excitant AUXlaunchApp:touchesLeft];
}
%end





//TapTapUtils
%hook UIStatusBarWindow

%new

-(void)TapTapUtils{
	UIAlertController *confirmationAlertController = [UIAlertController
                                    alertControllerWithTitle:@"TapTapUtils"
                                    message:@"Please pick an option"
                                    preferredStyle:UIAlertControllerStyleAlert];



        UIAlertAction* confirmRespring = [UIAlertAction
                                    actionWithTitle:@"Respring"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        notify_post("com.clarke1234.taptaprespring");
                                    }];

        UIAlertAction* confirmUiCache = [UIAlertAction
                                    actionWithTitle:@"Uicache"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        notify_post("com.clarke1234.taptapuicache");
                                    }];

		UIAlertAction* confirmReboot = [UIAlertAction
									actionWithTitle:@"Reboot"
									style:UIAlertActionStyleDefault
									handler:^(UIAlertAction * action)
									{
										notify_post("com.clarke1234.taptapreboot");
									}];

		UIAlertAction* confirmSafemode = [UIAlertAction
									actionWithTitle:@"Safemode"
									style:UIAlertActionStyleDefault
									handler:^(UIAlertAction * action)
									{
										notify_post("com.clarke1234.taptapsafemode");
									}];

		UIAlertAction* confirmShutdown = [UIAlertAction
									actionWithTitle:@"Shutdown"
									style:UIAlertActionStyleDefault
									handler:^(UIAlertAction * action)
									{
										notify_post("com.clarke1234.taptapshutdown");
									}];

		UIAlertAction* confirmCancel = [UIAlertAction
									actionWithTitle:@"Cancel"
									style:UIAlertActionStyleDefault
									handler:^(UIAlertAction * action)
									{
										//Do nothing
									}];

		UIAlertAction* confirmSleep = [UIAlertAction
                                    actionWithTitle:@"Sleep"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        notify_post("com.kietha.taptapsleep");
                                    }];

		if (GetPrefBool(@"uicache")){
        	[confirmationAlertController addAction:confirmUiCache];
		}
		if (GetPrefBool(@"respring")){
	        [confirmationAlertController addAction:confirmRespring];
		}
		if (GetPrefBool(@"reboot")){
			[confirmationAlertController addAction:confirmReboot];
		}
		if (GetPrefBool(@"safemode")){
			[confirmationAlertController addAction:confirmSafemode];
		}
		if (GetPrefBool(@"shutdown")){
			[confirmationAlertController addAction:confirmShutdown];
		}
		if (GetPrefBool(@"sleep")){
			[confirmationAlertController addAction:confirmSleep];
		}
		[confirmationAlertController addAction:confirmCancel];

        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:confirmationAlertController animated:YES completion:NULL];
}

%new

-(void)flash{
	[Excitant AUXtoggleFlash];
}

%new

-(void)lpm{
	[Excitant AUXtoggleLPM];
}

%new

-(void)apm{
	[Excitant AUXtoggleAirplaneMode];
}

%new

-(void)rotationLock{
	[Excitant AUXtoggleRotationLock];
}

%new

-(void)controlCenter{
	[Excitant AUXcontrolCenter];
}

%new

-(void)respring{
	[Excitant AUXrespring];
}


%new

- (void) TouchRecognizerTop:(UITapGestureRecognizer *)sender {
	NSDictionary *Tapprefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/EXCITANTTAPS.plist"];
	tapapp = [Tapprefs objectForKey:@"launchAppTap"]; //Setting up variables
	[Excitant AUXlaunchApp:tapapp];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig;
	int taps;
	if(GetPrefBool(@"taptaps2")){
		taps = 2;
	}
	else if(GetPrefBool(@"taptaps3")){
		taps = 3;
	}
	else if(GetPrefBool(@"taptaps4")){
		taps = 4;
	}
	else {
		taps = 2;
	}
    if(GetPrefBool(@"enableUtils")){
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapTapUtils)];
        tapRecognizer.numberOfTapsRequired = taps;
        [self addGestureRecognizer:tapRecognizer];

        //return self;
    }
	if(GetPrefBool(@"enableFlash")){
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flash)];
        tapRecognizer.numberOfTapsRequired = taps;
        [self addGestureRecognizer:tapRecognizer];
	}
	if(GetPrefBool(@"enableLPM")){
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lpm)];
        tapRecognizer.numberOfTapsRequired = taps;
        [self addGestureRecognizer:tapRecognizer];
	}
	if(GetPrefBool(@"enableAPM")){
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(apm)];
        tapRecognizer.numberOfTapsRequired = taps;
        [self addGestureRecognizer:tapRecognizer];
	}
	if(GetPrefBool(@"enableRL")){
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rotationLock)];
        tapRecognizer.numberOfTapsRequired = taps;
        [self addGestureRecognizer:tapRecognizer];
	}
	if(GetPrefBool(@"enableCC")){
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(controlCenter)];
        tapRecognizer.numberOfTapsRequired = taps;
        [self addGestureRecognizer:tapRecognizer];
	}
	if(GetPrefBool(@"enableRespring")){
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respring)];
        tapRecognizer.numberOfTapsRequired = taps;
        [self addGestureRecognizer:tapRecognizer];
	}
	if(GetPrefBool(@"enableSleep")){
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lockDevice)];
        tapRecognizer.numberOfTapsRequired = taps;
        [self addGestureRecognizer:tapRecognizer];
	}
	if(GetPrefBool(@"enableAppTap")){
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TouchRecognizerTop:)];
        tapRecognizer.numberOfTapsRequired = taps;
        [self addGestureRecognizer:tapRecognizer];
	}
    return self;
}


%end



//Prefs for TapTapUtils
%ctor{
	NSString *currentID = NSBundle.mainBundle.bundleIdentifier;
	//NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.clarke1234.taptivatorprefs.plist"];
	// uicache = [settings objectForKey:@"uicache"];
	// respring = [settings objectForKey:@"respring"];
	// rebootd = [settings objectForKey:@"reboot"];
	// safemode = [settings objectForKey:@"safemode"];
	// shutdownd = [settings objectForKey:@"shutdown"];
	// sleepdd = [settings objectForKey:@"sleep"];
	if ([currentID isEqualToString:@"com.apple.springboard"]) {
		int regToken;
		notify_register_dispatch("com.clarke1234.taptaprespring", &regToken, dispatch_get_main_queue(), ^(int token) {
			pid_t pid;
			int status;
			const char* args[] = {"killall", "-9", "backboardd", NULL};
			posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
			waitpid(pid, &status, WEXITED);

		});
		notify_register_dispatch("com.clarke1234.taptapuicache", &regToken, dispatch_get_main_queue(), ^(int token){
			pid_t pid;
			int status;
			const char* args[] = {"uicache", NULL, NULL, NULL};
			posix_spawn(&pid, "/usr/bin/uicache", NULL, NULL, (char* const*)args, NULL);
			waitpid(pid, &status, WEXITED);
				CFRunLoopRunInMode(kCFRunLoopDefaultMode, 20.0, false);
		});
		notify_register_dispatch("com.clarke1234.taptapreboot", &regToken, dispatch_get_main_queue(), ^(int token){
			[[%c(FBSystemService) sharedInstance] shutdownAndReboot:YES];
		});
		notify_register_dispatch("com.clarke1234.taptapsafemode", &regToken, dispatch_get_main_queue(), ^(int token){
			pid_t pid;
			int status;
			const char* args[] = {"killall", "-SEGV", "SpringBoard", NULL};
			posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
			waitpid(pid, &status, WEXITED);
		});
		notify_register_dispatch("com.clarke1234.taptapshutdown", &regToken, dispatch_get_main_queue(), ^(int token){
			[[%c(FBSystemService) sharedInstance] shutdownAndReboot:NO];
		});
		notify_register_dispatch("com.kietha.taptapsleep", &regToken, dispatch_get_main_queue(), ^(int token){
             [[objc_getClass("SBBacklightController") sharedInstance] _startFadeOutAnimationFromLockSource:1];
        });

}
}
