FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://config_unsupp.cfg"

# for uboot-mkimage
DEPENDS += "u-boot-mkimage-native"

do_configure:append() {
    if [ ${XEN_TARGET_ARCH} = "arm64" -o ${XEN_TARGET_ARCH} = "arm" ]; then
        ${S}/xen/tools/kconfig/merge_config.sh -m -O \
            ${S}/xen ${S}/xen/.config ${S}/xen/arch/arm/configs/xt_defconfig
    fi
}

do_deploy:append () {
    if [ -f ${D}/boot/xen ]; then
        uboot-mkimage -A arm64 -C none -T kernel -a 0x88080000 -e 0x88080000 -n "XEN" -d ${D}/boot/xen ${DEPLOYDIR}/xen-${MACHINE}.uImage
        ln -sfr ${DEPLOYDIR}/xen-${MACHINE}.uImage ${DEPLOYDIR}/xen-uImage
    fi
}
