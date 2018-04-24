ARCHS = armv7 arm64
TARGET=iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FullScreenApps
FullScreenApps_FILES = Tweak.xm
FullScreenApps_LIBRARIES = sparkapplist
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += fullscreenappsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
