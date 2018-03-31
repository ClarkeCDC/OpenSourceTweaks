#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <FrontBoardServices/FBSSystemService.h>
#import <spawn.h>
#import <notify.h>

/*
pid_t pid;
    									int status;
										const char* args[] = {"killall", "-9", "backboardd", NULL};
										posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
										waitpid(pid, &status, WEXITED);
*/

@interface UIStatusBarWindow : UIWindow
//-(void)respring;
-(void)check;
@end



%hook UIStatusBarWindow

%new

-(void)check{
	UIAlertController *confirmationAlertController = [UIAlertController
                                    alertControllerWithTitle:@"Confirm Respring"
                                    message:@"Are you sure you want to Respring?"
                                    preferredStyle:UIAlertControllerStyleAlert];



        UIAlertAction* confirmYes = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {	
                                        notify_post("com.clarke1234.taptaprespring");
                                    }];

        UIAlertAction* confirmNo = [UIAlertAction
                                    actionWithTitle:@"No"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //do nothing lmao
                                    }];

        [confirmationAlertController addAction:confirmNo];
        [confirmationAlertController addAction:confirmYes];

        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:confirmationAlertController animated:YES completion:NULL];
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(check)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapRecognizer];
    
    return self;
}

%end
%ctor{
	NSString *currentID = NSBundle.mainBundle.bundleIdentifier;
	if ([currentID isEqualToString:@"com.apple.springboard"]) {
		int regToken;
		notify_register_dispatch("com.clarke1234.taptaprespring", &regToken, dispatch_get_main_queue(), ^(int token) {
			pid_t pid;
			int status;
			const char* args[] = {"killall", "-9", "backboardd", NULL};
			posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
			waitpid(pid, &status, WEXITED);
										
		});
}
}