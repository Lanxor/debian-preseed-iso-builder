
ISOBASEFILE=debian-12.0.0-amd64-netinst.iso
DESTINATION=isofiles
PRESEEDFILE=preseed.cfg
ISOLINUXDIR=isolinux
TARGETISODIR=output
TARGETISO=$(TARGETISODIR)/preseed-$(ISOBASEFILE)

all: clean extract addcustomisolinux addpreseed generatemd5sum createiso

extract:
	7z x -o$(DESTINATION) $(ISOBASEFILE)

addpreseed:
	chmod +w -R $(DESTINATION)/install.amd/
	gunzip $(DESTINATION)/install.amd/initrd.gz
	echo $(PRESEEDFILE) | cpio -H newc -o -A -F $(DESTINATION)/install.amd/initrd
	gzip $(DESTINATION)/install.amd/initrd
	chmod -w -R $(DESTINATION)/install.amd/

addcustomisolinux:
	cp -R $(ISOLINUXDIR)/* $(DESTINATION)/isolinux/

generatemd5sum:
	chmod +w $(DESTINATION)/md5sum.txt
	cd $(DESTINATION) && find -follow -type f ! -name md5sum.txt -print0 | xargs -0 md5sum > md5sum.txt
	chmod -w $(DESTINATION)/md5sum.txt

createiso:
	mkdir -p $(TARGETISODIR)
	genisoimage -r -J -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o $(TARGETISO) $(DESTINATION)
	sudo rm -rf $(DESTINATION)

clean:
	sudo rm -rf $(DESTINATION)
