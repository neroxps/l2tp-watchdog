include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-l2tp-watchdog
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=VPN Watchdog Team <noreply@example.com>
PKG_LICENSE:=Apache-2.0

LUCI_TITLE:=LuCI Support for L2TP VPN Watchdog
LUCI_DESCRIPTION:=Provides a web interface for managing the L2TP VPN Watchdog service
LUCI_DEPENDS:=+luci-base
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/conffiles
/etc/config/l2tp-watchdog
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
