THISDIR = $(shell pwd)
all:

clean:

romfs:
	$(ROMFSINST) -p +x $(THISDIR)/adguardhome.sh /usr/bin/adguardhome.sh
ifeq ($(CONFIG_FIRMWARE_INCLUDE_WYYBIN),y)
	$(ROMFSINST) -p +x $(THISDIR)/AdGuardHome /usr/bin/AdGuardHome
endif
