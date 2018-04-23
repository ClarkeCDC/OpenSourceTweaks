include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NoStatusBarPrefs
NoStatusBarPrefs_FILES = NSBRootListController.m
NoStatusBarPrefs_INSTALL_PATH = /Library/PreferenceBundles
NoStatusBarPrefs_FRAMEWORKS = UIKit
NoStatusBarPrefs_PRIVATE_FRAMEWORKS = Preferences
NoStatusBarPrefs_LIBRARIES = sparkapplist

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NoStatusBarPrefs.plist$(ECHO_END)
