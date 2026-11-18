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

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

$(call inherit-product, device/lava/LXX518/device.mk)

PRODUCT_NAME := aosp_LXX518
PRODUCT_DEVICE := LXX518
PRODUCT_BRAND := LAVA
PRODUCT_MODEL := LXX518
PRODUCT_MANUFACTURER := LAVA
PRODUCT_GMS_CLIENTID_BASE := android-lava

# Verified from ro.build.fingerprint of the running build
PRODUCT_SHIPPING_API_LEVEL := 36
