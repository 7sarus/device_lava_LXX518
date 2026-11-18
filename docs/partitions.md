# Partition layout

All values read from the device itself (GPT via EDL, `lpdump` on `super`).
Sizes are exact partition lengths, offsets are byte offsets on the UFS LUN.

## Physical — boot chain

| Partition | Offset | Size |
| :--- | :--- | ---: |
| `vbmeta_a` | 0x0000000013108000 | 8 MB |
| `vbmeta_system_a` | 0x0000000013908000 | 8 MB |
| `vbmeta_vendor_a` | 0x0000000014108000 | 8 MB |
| `metadata` | 0x0000000016108000 | 71.9 MB |
| `boot_a` | 0x000000003b200000 | 64 MB |
| `vendor_boot_a` | 0x000000003f200000 | 64 MB |
| `init_boot_a` | 0x0000000043200000 | 8 MB |
| `dtbo_a` | 0x0000000043a00000 | 8 MB |
| `vbmeta_b` | 0x0000000014908000 | 8 MB |
| `vbmeta_system_b` | 0x0000000015108000 | 8 MB |
| `vbmeta_vendor_b` | 0x0000000015908000 | 8 MB |
| `boot_b` | 0x0000000061200000 | 64 MB |
| `vendor_boot_b` | 0x0000000065200000 | 64 MB |
| `init_boot_b` | 0x0000000069200000 | 8 MB |
| `dtbo_b` | 0x000000006b200000 | 8 MB |
| `super` | 0x000000006d000000 | 9,663,676,416 B (9 GiB) |
| `userdata` | 0x00000002ad000000 | 116 GB |

Slot suffix is `_a` / `_b`; the phone shipped with `_a` active and switched to `_b` after the
`B_V08` (Android 16) update.

Notes:

- `boot` holds the GKI kernel and **no ramdisk** (header v4).
- `init_boot` holds the generic ramdisk — that is the partition to patch for KernelSU LKM and for
  root-on-boot changes.
- `vendor_boot` holds the vendor ramdisk (LZ4), containing the first-stage `fstab.mt6878`.

## Logical — `super`

`lpdump` reports metadata version 10.2, header flag `virtual_ab_device` (VABC snapshots), one group.

| Logical partition | Group |
| :--- | :--- |
| `system_a` | `main_a` |
| `system_ext_a` | `main_a` |
| `product_a` | `main_a` |
| `vendor_a` | `main_a` |
| `system_dlkm_a` | `main_a` |
| `vendor_dlkm_a` | `main_a` |
| `odm_dlkm_a` | `main_a` |

Group `main_a` maximum size: 9,661,579,264 B. The `_a-cow` entries are VABC snapshot devices.

## GPT artifacts

The raw tables live in the phone-notes repo under `firmware/dump_all/gpt.bin` and
`gpt_backup.bin` (gitignored, not published).
