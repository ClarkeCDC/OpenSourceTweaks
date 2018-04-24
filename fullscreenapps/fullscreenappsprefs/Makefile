include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FullScreenAppsPrefs
FullScreenAppsPrefs_FILES = FSARootListController.m
FullScreenAppsPrefs_INSTALL_PATH = /Library/PreferenceBundles
FullScreenAppsPrefs_FRAMEWORKS = UIKit
FullScreenAppsPrefs_PRIVATE_FRAMEWORKS = Preferences
FullScreenAppsPrefs_LIBRARIES = sparkapplist
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FullScreenAppsPrefs.plist$(ECHO_END)
