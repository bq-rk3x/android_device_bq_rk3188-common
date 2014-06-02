# Copyright (C) 2011 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


LOCAL_PATH := $(call my-dir)

# HAL module implemenation, not prelinked, and stored in
# hw/<AUDIO_HARDWARE_MODULE_ID>.<ro.product.board>.so

include $(CLEAR_VARS)
LOCAL_MODULE := audio.primary.$(TARGET_BOARD_HARDWARE)
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := \
    AudioHardwareInterface.cpp \
    AudioHardware.cpp \
    audio_hw_hal.cpp \
    alsa_mixer.c \
    alsa_pcm.c

ifeq ($(BOARD_HAVE_BLUETOOTH),true)
  LOCAL_CFLAGS += -DWITH_A2DP
endif

LOCAL_STATIC_LIBRARIES := libmedia_helper libspeex
LOCAL_C_INCLUDES := $(call include-path-for, speex)
LOCAL_SHARED_LIBRARIES:= libc libcutils libutils libmedia libhardware_legacy
include $(BUILD_SHARED_LIBRARY)


# Build the amix binary
include $(CLEAR_VARS)
LOCAL_SRC_FILES:= amix.c alsa_mixer.c
LOCAL_CFLAGS += -DSUPPORT_USB
LOCAL_MODULE:= amix
LOCAL_SHARED_LIBRARIES := libc libcutils
LOCAL_MODULE_TAGS:= debug
include $(BUILD_EXECUTABLE)


# Build the usb simple libaudio
include $(CLEAR_VARS)
LOCAL_MODULE := audio.usb.$(TARGET_BOARD_HARDWARE)
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := \
    AudioHardwareInterface.cpp \
    AudioHardware.cpp \
    audio_hw_hal.cpp \
    alsa_mixer.c \
    alsa_pcm.c

LOCAL_CFLAGS += -DSUPPORT_USB
LOCAL_STATIC_LIBRARIES := libmedia_helper libspeex
LOCAL_C_INCLUDES := $(call include-path-for, speex)
LOCAL_SHARED_LIBRARIES:= libc libcutils libutils libmedia libhardware_legacy
include $(BUILD_SHARED_LIBRARY)


# Build the policy static library
include $(CLEAR_VARS)
LOCAL_MODULE := libaudiopolicy_$(TARGET_BOARD_HARDWARE)
LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := \
    AudioPolicyManagerBase.cpp \
    AudioPolicyCompatClient.cpp \
    audio_policy_hal.cpp

ifeq ($(AUDIO_POLICY_TEST),true)
  LOCAL_CFLAGS += -DAUDIO_POLICY_TEST
endif

ifeq ($(BOARD_HAVE_BLUETOOTH),true)
  LOCAL_CFLAGS += -DWITH_A2DP
endif

LOCAL_STATIC_LIBRARIES := libmedia_helper
include $(BUILD_STATIC_LIBRARY)


# The default audio policy, for now still implemented on top of legacy
# policy code
include $(CLEAR_VARS)
LOCAL_MODULE := audio_policy.$(TARGET_BOARD_HARDWARE)
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := AudioPolicyManagerDefault.cpp
LOCAL_SHARED_LIBRARIES := libcutils libutils libmedia
LOCAL_STATIC_LIBRARIES := libmedia_helper
LOCAL_WHOLE_STATIC_LIBRARIES :=libaudiopolicy_$(TARGET_BOARD_HARDWARE)

ifeq ($(BOARD_HAVE_BLUETOOTH),true)
  LOCAL_CFLAGS += -DWITH_A2DP
endif

include $(BUILD_SHARED_LIBRARY)
