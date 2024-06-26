FILESEXTRAPATHS:prepend := "${THISDIR}/files:\
${@bb.utils.contains('DISTRO_FEATURES', 'enable_virtio',\
'${THISDIR}/files/virtio:',\
'${THISDIR}/files/pvr:',\
d)}\
"

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git"

BRANCH = "v5.10.41/rcar-5.1.4.1-xt0.2"
SRCREV = "bf7d6bcdd618e5acb21118d87c76e5d8913f8dde"
LINUX_VERSION = "5.10.41"

SRC_URI:append = " \
    file://xen-chosen.dtsi;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://ulcb-ab.dtsi;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

ADDITIONAL_DEVICE_TREES ?= "${XT_DEVICE_TREES}"

# Ignore in-tree defconfig
KBUILD_DEFCONFIG = ""

# Don't build defaul DTBs
KERNEL_DEVICETREE = ""

# Add ADDITIONAL_DEVICE_TREES to SRC_URIs and to KERNEL_DEVICETREEs
python __anonymous () {
    for fname in (d.getVar("ADDITIONAL_DEVICE_TREES") or "").split():
        dts = fname[:-3] + "dts"
        d.appendVar("SRC_URI", " file://%s;subdir=git/arch/${ARCH}/boot/dts/renesas"%dts)
        dtb = fname[:-3] + "dtb"
        d.appendVar("KERNEL_DEVICETREE", " renesas/%s"%dtb)
}
