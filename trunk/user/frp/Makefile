THISDIR := $(shell pwd)
FRP_VER := 0.29.0
FRP_URL_BASE := https://github.com/fatedier/frp/releases/download

FRP_NAME := frp_$(FRP_VER)_linux_mipsle
FRP_URL := $(FRP_URL_BASE)/v$(FRP_VER)/$(FRP_NAME).tar.gz

all:

clean:

romfs:
ifeq ($(CONFIG_FIRMWARE_INCLUDE_FRPC),y)
	$(ROMFSINST) -p +x $(THISDIR)/frpc /usr/bin/frpc
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_FRPS),y)
	$(ROMFSINST) -p +x $(THISDIR)/frps /usr/bin/frps
endif
	$(ROMFSINST) -p +x $(THISDIR)/frp.sh /usr/bin/frp.sh
	$(ROMFSINST) /etc_ro/frp_script.sh
