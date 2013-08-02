include theos/makefiles/common.mk

TWEAK_NAME = Slide2Dismiss
Slide2Dismiss_FILES = Tweak.xm
Slide2Dismiss_FRAMEWORKS = UIKit CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk
