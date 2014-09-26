#
# This file was modified by DTS, Inc. The portions of the
# code that are surrounded by "DTS..." are copyrighted and
# licensed separately, as follows:
#
#  (C) 2013 DTS, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
#

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    ISchedulingPolicyService.cpp \
    SchedulingPolicyService.cpp

# FIXME Move this library to frameworks/native
LOCAL_MODULE := libscheduling_policy

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:=               \
    AudioFlinger.cpp            \
    Threads.cpp                 \
    Tracks.cpp                  \
    Effects.cpp                 \
    AudioMixer.cpp.arm          \
    AudioResampler.cpp.arm      \
    AudioPolicyService.cpp      \
    ServiceUtilities.cpp        \
    AudioResamplerCubic.cpp.arm \
    AudioResamplerSinc.cpp.arm

LOCAL_SRC_FILES += StateQueue.cpp

LOCAL_C_INCLUDES := \
    $(call include-path-for, audio-effects) \
    $(call include-path-for, audio-utils) \
    $(TOP)/frameworks-ext/av/include/media \
    hardware/mediatek/mt6592/audio/include \
    hardware/mediatek/common/audio/include \

LOCAL_SHARED_LIBRARIES := \
    libaudioutils \
    libcommon_time_client \
    libcutils \
    libutils \
    liblog \
    libbinder \
    libmedia \
    libnbaio \
    libhardware \
    libhardware_legacy \
    libeffects \
    libdl \
    libpowermanager

LOCAL_STATIC_LIBRARIES := \
    libscheduling_policy \
    libcpustats \
    libmedia_helper

#mtk added
ifeq ($(strip $(BOARD_USES_MTK_AUDIO)),true)
AudioDriverIncludePath := aud_drv
LOCAL_MTK_PATH:=../../../../mediatek/frameworks-ext/av/services/audioflinger

LOCAL_CFLAGS += -DMTK_AUDIO

LOCAL_C_INCLUDES += \
    frameworks-ext/av/include/media \
    frameworks-ext/av/services/audioflinger \
    hardware/mediatek/common/audio/include/aud_drv \
    hardware/mediatek/common/audio/ \
    hardware/mediatek/mt6592/audio/aud_drv \
    hardware/mediatek/mt6592/audio
    #$(TOP)/mediatek/kernel/include

LOCAL_SRC_FILES += \
    $(LOCAL_MTK_PATH)/AudioHeadsetDetect.cpp \
    $(LOCAL_MTK_PATH)/AudioResamplermtk.cpp \
    $(LOCAL_MTK_PATH)/AudioUtilmtk.cpp

LOCAL_SHARED_LIBRARIES += \
    libblisrc

# SRS Processing
ifeq ($(strip $(HAVE_SRSAUDIOEFFECT_FEATURE)),yes)
    LOCAL_CFLAGS += -DHAVE_SRSAUDIOEFFECT
    include mediatek/binary/3rd-party/free/SRS_AudioEffect/srs_processing/AF_PATCH.mk
endif
# SRS Processing

ifeq ($(strip $(TARGET_BUILD_VARIANT)),eng)
    LOCAL_CFLAGS += -DDEBUG_AUDIO_PCM
endif

# MATV ANALOG SUPPORT
ifeq ($(HAVE_MATV_FEATURE),yes)
ifeq ($(MTK_MATV_ANALOG_SUPPORT),yes)
LOCAL_CFLAGS += -DMATV_AUDIO_LINEIN_PATH
endif
endif
# MATV ANALOG SUPPORT

# MTKLOUDNESS_EFFECT
ifeq ($(strip $(HAVE_MTKLOUDNESS_EFFECT)),yes)
    LOCAL_CFLAGS += -DHAVE_MTKLOUDNESS_EFFECT
endif
# MTKLOUDNESS_EFFECT

# MTK_DOWNMIX_ENABLE
LOCAL_CFLAGS += -DMTK_DOWNMIX_ENABLE
# MTK_DOWNMIX_ENABLE
endif

LOCAL_MODULE:= libaudioflinger

LOCAL_SRC_FILES += FastMixer.cpp FastMixerState.cpp AudioWatchdog.cpp

LOCAL_CFLAGS += -DSTATE_QUEUE_INSTANTIATIONS='"StateQueueInstantiations.cpp"'

# Define ENABLE_RESAMPLE_IN_PCM_OFFLOAD_PATH
ifeq ($(strip $(BOARD_USE_RESAMPLER_IN_PCM_OFFLOAD_PATH)),true)
LOCAL_CFLAGS += -DENABLE_RESAMPLER_IN_PCM_OFFLOAD_PATH
endif

# Define ANDROID_SMP appropriately. Used to get inline tracing fast-path.
ifeq ($(TARGET_CPU_SMP),true)
    LOCAL_CFLAGS += -DANDROID_SMP=1
else
    LOCAL_CFLAGS += -DANDROID_SMP=0
endif

ifeq ($(BOARD_HAVE_PRE_KITKAT_AUDIO_BLOB),true)
    LOCAL_CFLAGS += -DHAVE_PRE_KITKAT_AUDIO_BLOB
endif

ifeq ($(BOARD_HAVE_PRE_KITKAT_AUDIO_POLICY_BLOB),true)
    LOCAL_CFLAGS += -DHAVE_PRE_KITKAT_AUDIO_POLICY_BLOB
endif

LOCAL_CFLAGS += -fvisibility=hidden
ifeq ($(strip $(BOARD_USES_SRS_TRUEMEDIA)),true)
LOCAL_SHARED_LIBRARIES += libsrsprocessing
LOCAL_CFLAGS += -DSRS_PROCESSING
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/mm-audio/audio-effects
endif
include $(BUILD_SHARED_LIBRARY)

#
# build audio resampler test tool
#
include $(CLEAR_VARS)

LOCAL_SRC_FILES:=               \
    test-resample.cpp 			\
    AudioResampler.cpp.arm      \
    AudioResamplerCubic.cpp.arm \
    AudioResamplerSinc.cpp.arm

LOCAL_SHARED_LIBRARIES := \
    libdl \
    libcutils \
    libutils \
    liblog

LOCAL_MODULE:= test-resample

LOCAL_MODULE_TAGS := optional

include $(BUILD_EXECUTABLE)

include $(call all-makefiles-under,$(LOCAL_PATH))
