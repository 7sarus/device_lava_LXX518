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

LOCAL_PATH := device/lava/LXX518

# Copy the stock first-stage fstab, taken unchanged from vendor_boot
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/fstab.mt6878:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mt6878

# Telephony, no sdcard slot (verified: only USB OTG voldmanaged entries)
PRODUCT_CHARACTERISTICS := nosdcard,telephony

# Screen (verified from dumps/device-specs.md: 1200 x 2652, 520 dpi)
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi
PRODUCT_AAPT_PREBUILT_DPI := xxhdpi

# TODO: Soong namespaces for the MT6878 vendor blobs
# TODO: PRODUCT_SHIPPING_API_LEVEL, PRODUCT_PACKAGES for device-specific HALs
