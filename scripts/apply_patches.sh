#!/bin/bash

# General patches
echo "Copying General patches..."
cp -f $GITHUB_WORKSPACE/patch/config/* config/kernel/
cp -f $GITHUB_WORKSPACE/patch/sbin/* packages/bsp/common/usr/sbin/

# T4 Patches
echo "Copying T4 patches..."
cp -f $GITHUB_WORKSPACE/patch/T4/fix-CPU-information.patch patch/kernel/archive/rockchip64-6.14/
cp -f $GITHUB_WORKSPACE/patch/T4/fix-CPU-information.patch patch/kernel/archive/rockchip64-6.12/
cp -f $GITHUB_WORKSPACE/patch/T4/t4.patch patch/kernel/archive/rockchip64-6.14/
cp -f $GITHUB_WORKSPACE/patch/T4/t4.patch patch/kernel/archive/rockchip64-6.12/
rm -f patch/kernel/archive/rockchip64-6.12/rk3568-bugfix-amadeus_phy_rockchip_naneng_combphy_compatible_reset_with_old_dt.patch
sed -i 's/tag:v6\.14-rc4/tag:v6\.14-rc5/' config/sources/mainline-kernel.conf.sh

# 5C Patches
echo "Copying 5C patches..."
cp -f $GITHUB_WORKSPACE/patch/5C/rock-5c.conf config/boards/
cp -f $GITHUB_WORKSPACE/patch/5C/reopen_disabled_nodes.patch patch/u-boot/legacy/u-boot-radxa-rk35xx/board_rock-5c/
cp -f $GITHUB_WORKSPACE/patch/5C/fix-CPU-information.patch patch/kernel/rk35xx-vendor-6.1/
cp -f $GITHUB_WORKSPACE/patch/5C/diyfan.patch patch/kernel/rk35xx-vendor-6.1/

# N1 Patches
echo "Copying N1 patches..."
cp -f $GITHUB_WORKSPACE/patch/N1/fix-n1-1.patch patch/kernel/archive/meson64-6.12/
cp -f $GITHUB_WORKSPACE/patch/N1/fix-n1-2.patch patch/kernel/archive/meson64-6.12/
cp -f $GITHUB_WORKSPACE/patch/N1/fix-n1-1.patch patch/kernel/archive/meson64-6.13/
cp -f $GITHUB_WORKSPACE/patch/N1/fix-n1-2.patch patch/kernel/archive/meson64-6.13/
cp -f $GITHUB_WORKSPACE/patch/N1/aml-s9xx-box.tvb config/boards/
cp -f $GITHUB_WORKSPACE/patch/N1/u-boot.ext config/optional/boards/aml-s9xx-box/_packages/bsp-cli/boot/

# X2 Patches
echo "Copying X2 patches..."
cp -f $GITHUB_WORKSPACE/patch/X2/rk3566-panther-x2.dts patch/kernel/archive/rockchip64-6.12/dt/
cp -f $GITHUB_WORKSPACE/patch/X2/rk3566-panther-x2.dts patch/kernel/archive/rockchip64-6.14/dt/
cp -r $GITHUB_WORKSPACE/patch/X2/dt patch/kernel/rk35xx-vendor-6.1/
cp -f $GITHUB_WORKSPACE/patch/X2/panther-x2.csc config/boards/

# Remove '-unofficial' from the VENDOR name
sed -i 's/Armbian-unofficial/Armbian/g' lib/functions/configuration/main-config.sh

# Remove the suffix information from 'uname -r' in LOCALVERSION
sed -i 's/LOCALVERSION=-\${BRANCH}-\${LINUXFAMILY}/LOCALVERSION=/g' lib/functions/compilation/kernel-make.sh
sed -i 's/\${kernel_version}-\${BRANCH}-\${LINUXFAMILY}/\${kernel_version}/g' lib/functions/compilation/kernel-debs.sh

# Remove branch information from linux debs packages name in kernel-debs.sh
sed -i 's/linux-image-\${BRANCH}-\${LINUXFAMILY}/linux-image-\${LINUXFAMILY}/g' lib/functions/compilation/kernel-debs.sh
sed -i 's/linux-dtb-\${BRANCH}-\${LINUXFAMILY}/linux-dtb-\${LINUXFAMILY}/g' lib/functions/compilation/kernel-debs.sh
sed -i 's/linux-headers-\${BRANCH}-\${LINUXFAMILY}/linux-headers-\${LINUXFAMILY}/g' lib/functions/compilation/kernel-debs.sh
sed -i 's/linux-libc-dev-\${BRANCH}-\${LINUXFAMILY}/linux-libc-dev-\${LINUXFAMILY}/g' lib/functions/compilation/kernel-debs.sh

# Remove branch information from linux debs packages name in artifact-kernel.sh
sed -i 's/linux-image-\${BRANCH}-\${LINUXFAMILY}/linux-image-\${LINUXFAMILY}/g' lib/functions/artifacts/artifact-kernel.sh
sed -i 's/linux-dtb-\${BRANCH}-\${LINUXFAMILY}/linux-dtb-\${LINUXFAMILY}/g' lib/functions/artifacts/artifact-kernel.sh
sed -i 's/linux-headers-\${BRANCH}-\${LINUXFAMILY}/linux-headers-\${LINUXFAMILY}/g' lib/functions/artifacts/artifact-kernel.sh
sed -i 's/linux-libc-dev-\${BRANCH}-\${LINUXFAMILY}/linux-libc-dev-\${LINUXFAMILY}/g' lib/functions/artifacts/artifact-kernel.sh

# Change IMAGE_TYPE from user-built to stable
sed -i 's/IMAGE_TYPE=user-built/IMAGE_TYPE=stable/g' lib/functions/main/config-prepare.sh

# Change the maximum frequency of RK3566 from 1800000 to 1992000
sed -i 's/1800000/1992000/g' config/sources/families/include/rockchip64_common.inc

# Set custom version
echo "25.5.1" > VERSION

echo "Patches applied successfully."
