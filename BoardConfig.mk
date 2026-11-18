#
# Copyright (C) 2026 The Android Open Source Project
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
#

LOCAL_PATH := $(call my-dir)

DEVICE_PATH := device/lava/LXX518

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a78

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55

TARGET_USES_64_BIT_BINDER := true
TARGET_SUPPORTS_64_BIT_APPS := true

# Platform (verified: preloader reports MT6878, Dimensity 7300)
TARGET_BOARD_PLATFORM := mt6878
TARGET_BOOTLOADER_BOARD_NAME := mt6878
TARGET_NO_BOOTLOADER := true

# Boot image (verified with unpack_bootimg on boot_b)
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_IMAGE_NAME := Image.lz4
# Stock kernel, LZ4 compressed, taken from boot_b. No kernel is built here.
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.lz4
TARGET_KERNEL_ARCH := arm64
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# boots a separate init_boot ramdisk, kernel lives in boot
BOARD_USES_RECOVERY_AS_BOOT := false
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true

# vendor_boot ramdisk is LZ4 compressed on the stock image
BOARD_RAMDISK_USE_LZ4 := true

# Ramdisk size ceilings (partition sizes from GPT)
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_DTBOIMG_PARTITION_SIZE := 8388608

# A/B (verified: two slots in GPT, slotselect in fstab)
AB_OTA_UPDATES := true
TARGET_NO_RECOVERY := false

# Filesystems (verified from first-stage fstab)
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODM_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_METADATAIMAGE_FILE_SYSTEM_TYPE := f2fs

TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_ODM := odm
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
TARGET_COPY_OUT_ODM_DLKM := odm_dlkm
TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm

# Dynamic partitions (verified: GPT super size and lpdump group main_a)
BOARD_SUPER_PARTITION_SIZE := 9663676416
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE := 9661579264
BOARD_MAIN_PARTITION_LIST := \
    system \
    system_ext \
    product \
    vendor \
    vendor_dlkm \
    odm_dlkm \
    system_dlkm

# TODO: group/partition sizes for each logical partition once a build exists.
BOARD_SUPER_PARTITION_METADATA_DEVICE := super
BOARD_SUPER_PARTITION_BLOCK_DEVICES := super

# AVB (verified: avbtool info_image vbmeta_b)
BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA2048
BOARD_AVB_ROLLBACK_INDEX := 0
BOARD_AVB_VBMETA_SYSTEM := system system_ext product
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_VENDOR := vendor vendor_dlkm odm_dlkm
BOARD_AVB_VBMETA_VENDOR_ALGORITHM := SHA256_RSA2048
# TODO: replace with a project-owned key; the stock key is not recoverable.

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/fstab.mt6878
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USES_MKE2FS := true

# TWRP: no recovery partition, so recovery ramdisk goes into boot with the kernel.
ifneq ($(filter twrp_%,$(TARGET_PRODUCT)),)
BOARD_USES_RECOVERY_AS_BOOT := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := false
BOARD_AVB_ENABLE := false
BOARD_KERNEL_CMDLINE := androidboot.selinux=permissive

TW_THEME := portrait_hdpi
TW_DEVICE_VERSION := 1
TW_INCLUDE_FASTBOOTD := true
TW_INCLUDE_REPACKTOOLS := true
TW_EXCLUDE_TWRPAPP := true
TW_USE_TOOLBOX := true

# Touch modules ship in recovery/root/lib/modules; the rest come from vendor_boot.
TW_LOAD_VENDOR_BOOT_MODULES := true
TW_LOAD_VENDOR_MODULES := "cs_notifier.ko pri_common_node.ko pd_dbg_info.ko tcpc_class.ko hardware_info.ko synaptics_tcm2.ko hynitron_touch.ko mediatek-drm.ko mediatek-drm-panel-drv.ko mediatek-drm-gateic.ko mtk_panel_ext.ko panel-rayle-nt37701-cmd-120hz.ko"
endif

# TODO: BOARD_SEPOLICY_DIRS, BOARD_VENDOR_SEPOLICY_DIRS
