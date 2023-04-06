################################################################################
#
# unipi-tools
#
################################################################################

UNIPI_TOOLS_VERSION = 1.2.46
UNIPI_TOOLS_SOURCE = $(UNIPI_TOOLS_VERSION).tar.gz
UNIPI_TOOLS_SITE = https://github.com/UniPiTechnology/unipi-tools/archive/refs/tags

UNIPI_TOOLS_DEPENDENCIES += libmodbus libtool unipi-kernel-modules-v1

BINFILES = unipi_tcp_server fwspi fwserial unipihostname unipicheck

define UNIPI_TOOLS_BUILD_CMDS
	cd $(@D)/src; $(MAKE) $(TARGET_CONFIGURE_OPTS) LDFLAGS="-L$(STAGING_DIR)/usr/lib -lmodbus -lm" PROJECT_VERSION=$(UNIPI_TOOLS_VERSION)
	cd $(@D)/overlays; $(MAKE) $(TARGET_CONFIGURE_OPTS) LINUX_DIR_PATH=$(LINUX_DIR)
endef

define UNIPI_TOOLS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(BINFILES:%=$(@D)/src/%) -t $(TARGET_DIR)/opt/unipi/tools
	$(INSTALL) -D -m 0644 $(@D)/overlays/*.dtbo -t $(BINARIES_DIR)/rpi-firmware/overlays
	$(INSTALL) -D -m 0644 $(@D)/unipi-common/etc/modprobe.d/neuron-blacklist.conf -t $(TARGET_DIR)/etc/modprobe.d
	$(INSTALL) -D -m 0644 $(@D)/unipi-common/etc/initramfs/modules.d/unipi $(TARGET_DIR)/etc/modules-load.d/unipi.conf
	$(INSTALL) -D -m 0644 $(@D)/unipi-common/udev/* -t $(TARGET_DIR)/etc/udev/rules.d
	$(INSTALL) -D -m 0755 $(UNIPI_TOOLS_PKGDIR)opt/unipi/tools/unipiconfig.sh -t $(TARGET_DIR)/opt/unipi/tools
	$(INSTALL) -D -m 0644 $(@D)/unipi-common/etc/tmpfiles.d/cpufreq.conf -t $(TARGET_DIR)/etc/tmpfiles.d
	$(INSTALL) -D -m 0644 $(@D)/unipi-modbus-tools/etc/default/unipitcp -t $(TARGET_DIR)/etc/default
endef

define UNIPI_TOOLS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(UNIPI_TOOLS_PKGDIR)usr/lib/systemd/system/unipitcp.service -t $(TARGET_DIR)/usr/lib/systemd/system
	$(INSTALL) -D -m 0644 $(UNIPI_TOOLS_PKGDIR)usr/lib/systemd/system/hwclock.service -t $(TARGET_DIR)/usr/lib/systemd/system
endef

$(eval $(generic-package))
