LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

ifeq ($(strip $(MTK_USE_ANDROID_MM_DEFAULT_CODE)),yes)
  LOCAL_CFLAGS += -DANDROID_DEFAULT_CODE
endif
LOCAL_SRC_FILES:= \
    AudioParameter.cpp
LOCAL_MODULE:= libmedia_helper
LOCAL_MODULE_TAGS := optional

include $(BUILD_STATIC_LIBRARY)

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include $(CLEAR_VARS)

LOCAL_SRC_FILES:= AudioParameter.cpp
LOCAL_MODULE:= libaudioparameter
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES := libutils libcutils

include $(BUILD_SHARED_LIBRARY)
endif

include $(CLEAR_VARS)

LOCAL_MTK_PATH:=../../../../mediatek/frameworks-ext/av/media/libmedia

ifeq ($(strip $(MTK_USE_ANDROID_MM_DEFAULT_CODE)),yes)
  LOCAL_CFLAGS += -DANDROID_DEFAULT_CODE
endif

LOCAL_SRC_FILES:= \
    AudioTrack.cpp \
    AudioTrackShared.cpp \
    IAudioFlinger.cpp \
    IAudioFlingerClient.cpp \
    IAudioTrack.cpp \
    IAudioRecord.cpp \
    ICrypto.cpp \
    IDrm.cpp \
    IDrmClient.cpp \
    IHDCP.cpp \
    AudioRecord.cpp \
    AudioSystem.cpp \
    mediaplayer.cpp \
    IMediaLogService.cpp \
    IMediaPlayerService.cpp \
    IMediaPlayerClient.cpp \
    IMediaRecorderClient.cpp \
    IMediaPlayer.cpp \
    IMediaRecorder.cpp \
    IRemoteDisplay.cpp \
    IRemoteDisplayClient.cpp \
    IStreamSource.cpp \
    Metadata.cpp \
    mediarecorder.cpp \
    IMediaMetadataRetriever.cpp \
    mediametadataretriever.cpp \
    ToneGenerator.cpp \
    JetPlayer.cpp \
    IOMX.cpp \
    IAudioPolicyService.cpp \
    MediaScanner.cpp \
    MediaScannerClient.cpp \
    autodetect.cpp \
    IMediaDeathNotifier.cpp \
    MediaProfiles.cpp \
    IEffect.cpp \
    IEffectClient.cpp \
    AudioEffect.cpp \
    Visualizer.cpp \
    MemoryLeakTrackUtil.cpp \
    SoundPool.cpp \
    SoundPoolThread.cpp \
    StringArray.cpp

LOCAL_SRC_FILES += ../libnbaio/roundup.c

ifeq ($(BOARD_USES_LIBMEDIA_WITH_AUDIOPARAMETER),true)
LOCAL_SRC_FILES+= \
    AudioParameter.cpp
endif

ifeq ($(BOARD_USE_SAMSUNG_SEPARATEDSTREAM),true)
LOCAL_CFLAGS += -DUSE_SAMSUNG_SEPARATEDSTREAM
endif

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
    ifneq ($(filter caf bfam,$(TARGET_QCOM_AUDIO_VARIANT)),)
        ifeq ($(BOARD_USES_LEGACY_ALSA_AUDIO),true)
            LOCAL_SRC_FILES += IDirectTrack.cpp IDirectTrackClient.cpp
        endif
    endif
endif

LOCAL_SRC_FILES += \
    $(LOCAL_MTK_PATH)/AudioPCMxWay.cpp \
    $(LOCAL_MTK_PATH)/ATVCtrl.cpp \
    $(LOCAL_MTK_PATH)/IATVCtrlClient.cpp \
    $(LOCAL_MTK_PATH)/IATVCtrlService.cpp \
    $(LOCAL_MTK_PATH)/AudioTrackCenter.cpp

# for <cutils/atomic-inline.h>
LOCAL_CFLAGS += -DANDROID_SMP=$(if $(findstring true,$(TARGET_CPU_SMP)),1,0)
LOCAL_SRC_FILES += SingleStateQueue.cpp
LOCAL_CFLAGS += -DSINGLE_STATE_QUEUE_INSTANTIATIONS='"SingleStateQueueInstantiations.cpp"'
# Consider a separate a library for SingleStateQueueInstantiations.
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS),true)
       LOCAL_CFLAGS     += -DENABLE_AV_ENHANCEMENTS
endif #TARGET_ENABLE_AV_ENHANCEMENTS

#QTI Resampler
ifeq ($(call is-vendor-board-platform,QCOM),true)
ifeq ($(strip $(AUDIO_FEATURE_ENABLED_EXTN_RESAMPLER)),true)
LOCAL_CFLAGS += -DQTI_RESAMPLER
endif
endif
#QTI Resampler

LOCAL_SHARED_LIBRARIES := \
	libui liblog libcutils libutils libbinder libsonivox libicuuc libexpat \
        libcamera_client libstagefright_foundation \
        libgui libdl libaudioutils

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
LOCAL_SHARED_LIBRARIES += libaudioparameter
endif

LOCAL_STATIC_LIBRARIES += \
        libmedia_helper
ifneq ($(strip $(MTK_USE_ANDROID_MM_DEFAULT_CODE)),yes)
LOCAL_SHARED_LIBRARIES += \
        libvcodecdrv
endif

LOCAL_WHOLE_STATIC_LIBRARY := libmedia_helper

LOCAL_MODULE:= libmedia

ifeq ($(strip $(BOARD_USES_MTK_AUDIO)),true)
  ifeq ($(strip $(MTK_HIGH_RESOLUTION_AUDIO_SUPPORT)),yes)
    LOCAL_CFLAGS += -DMTK_24BIT_AUDIO_SUPPORT
  endif
endif

LOCAL_C_INCLUDES := \
    $(call include-path-for, graphics corecg) \
    $(TOP)/frameworks/native/include/media/openmax \
    $(TOP)/mediatek-min/external/mhal/src/core/drv/inc \
    $(TOP)/bionic/libc/kernel/common/linux/vcodec \
    $(TOP)/hardware/mediatek/mt6592/vcodec/inc \
    external/icu4c/common \
    $(call include-path-for, audio-effects) \
    $(call include-path-for, audio-utils)   \
    $(TOP)/frameworks-ext/av/include
    # $(TOP)/$(MTK_PATH_SOURCE)/frameworks/av/include

ifeq ($(strip $(BOARD_USES_MTK_AUDIO)),true)

  LOCAL_C_INCLUDES+= \
   $(TOP)/hardware/mediatek/common/audio/aud_drv \
   $(TOP)/hardware/mediatek/common/audio/include \
   $(TOP)/hardware/mediatek/common/audio \
   $(TOP)/hardware/mediatek/mt6592/audio/aud_drv \
   $(TOP)/hardware/mediatek/mt6592/audio/include \
   $(TOP)/hardware/mediatek/mt6592/audio
endif

include $(BUILD_SHARED_LIBRARY)
