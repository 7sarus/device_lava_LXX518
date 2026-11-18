# Android device tree — LAVA LXX518 (device_lava_LXX518)

Skeleton device tree for the LAVA LXX518 (Agni 3 5G, MediaTek MT6878 / Dimensity 7300),
built from the phone's own partitions dumped over EDL.

- Phone notes, dumps and root work: https://github.com/7sarus/lava
- Partition dump used to derive this tree: Android 16 `LAVA_LXX518_SW_B_V08_HW_V1.0_20260901`,
  kernel `6.1.172-android14-11`, active slot `b`.

Clone into an AOSP tree as `device/lava/LXX518`:

```sh
git clone https://github.com/7sarus/device_lava_LXX518 device/lava/LXX518
. build/envsetup.sh && lunch aosp_LXX518-ap2a-userdebug
```

## What is verified from the dumps

| Item | Value | Source |
| :--- | :--- | :--- |
| SoC / platform | MT6878 | Preloader `MT6878(Dimensity 7300)` |
| Architecture | arm64-v8a | GKI `Image`, `aarch64` |
| Kernel | 6.1.172-android14-11 (GKI) | `uname -r`, `boot_b` |
| Boot header | v4, 4096 page size, no ramdisk in `boot` | `unpack_bootimg` |
| Ramdisk location | `init_boot` (generic), `vendor_boot` (vendor) | dumps + fstab |
| A/B | yes, 2 slots, `slotselect` in fstab | `fstab.mt6878`, GPT |
| Dynamic partitions | `super` (group `main`), VABC (`virtual_ab_device`) | `lpdump` |
| Filesystems | `erofs` (system/system_ext/product/vendor/dlkm), `f2fs` (data/metadata), `ext4` fallback | fstab |
| AVB | SHA256_RSA2048, chained `boot` / `vbmeta_system` / `vbmeta_vendor` | `avbtool info_image vbmeta_b` |
| Super size | 9,663,676,416 B (0x240000000) | GPT |
| `main` group max | 9,661,579,264 B | `lpdump` |

## What is still missing (not in this repo)

- Proprietary vendor/odm blobs and their `proprietary-files.txt`.
- Device-specific sepolicy.
- Working kernel build config (`vendor_kernel_boot` + GKI fragments).
- `/data` decryption in TWRP (FBE + MTK keymaster).

## TWRP

`lunch twrp_LXX518-ap2a-eng && m bootimage` — recovery goes into `boot.img`
(`BOARD_USES_RECOVERY_AS_BOOT`), because the phone has no recovery partition and its
`boot` has no ramdisk to conflict with. CI: `.github/workflows/twrp.yml` builds
`twrp-14.1` and uploads `boot.img`.

Flash with verity/verification off, since the image is not AVB-signed with the LAVA key:

```sh
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
fastboot flash boot boot.img
```

`prebuilt/` holds what CI cannot pull from a phone:

| File | Source |
| :--- | :--- |
| `prebuilt/Image.lz4` | `boot_b.img` (GKI kernel, LZ4, 16.7 MB) |
| `recovery/root/lib/modules/*.ko` | `synaptics_tcm2`, `hynitron_touch` from `/vendor_dlkm`, plus the 5 modules they depend on |

Display modules (`mediatek-drm`, `panel-*`, ...) are not bundled: they are already in
`vendor_boot`, which the bootloader loads alongside `boot`.

## Layout

| File | Purpose |
| :--- | :--- |
| `AndroidProducts.mk` | lunch target registration |
| `aosp_LXX518.mk` | product definition |
| `device.mk` | copies fstab, sets package/display props |
| `BoardConfig.mk` | platform, boot header, super, AVB, fs types |
| `fstab.mt6878` | unmodified first-stage fstab from the phone's `vendor_boot` |
| `docs/partitions.md` | GPT boot chain and `super` logical layout |

Verified values are marked with their source; anything guessed is called out as a TODO in the file.
