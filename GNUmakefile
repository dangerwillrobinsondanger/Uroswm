#
# GNUmakefile - Generated by ProjectCenter
#
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

#
# Tool
#
VERSION = 0.1
PACKAGE_NAME = uroswm
TOOL_NAME = uroswm
uroswm_TOOL_ICON = 


#
# Resource files
#
uroswm_RESOURCE_FILES = \
Resources/Version \
titleback.xpm


#
# Header files
#
uroswm_HEADER_FILES = \
UrosWindowManager.h \
URNotificationHandler.h \
URWindow.h \
URFrame.h \
URTitleBar.h

#
# Objective-C Class files
#
uroswm_OBJC_FILES = \
UrosWindowManager.m \
URNotificationHandler.m \
URWindow.m \
URFrame.m \
URTitleBar.m

#
# Other sources
#
uroswm_OBJC_FILES += \
main.m 

# Additional flags to pass to Objective C compiler
ADDITIONAL_OBJCFLAGS += -g -std=c99 -fobjc-arc

# Additional flags to pass to C compiler
ADDITIONAL_LDFLAGS += -lX11 -lXpm

#
# Makefiles
#
include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/tool.make
-include GNUmakefile.postamble
