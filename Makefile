IMAGE = disk.img
VDI = disk.vdi

UNAME = ${shell uname}
ifeq ($(OS),Windows_NT)
	VNC = @echo windows is not supported; exit 1
else ifeq ($(UNAME),Linux)
	VNC = vncviewer localhost::15900
else ifeq ($(UNAME),Darwin)
	VNC = open vnc://localhost:15900
else
	VNC = @echo non supported OS; exit 1
endif

.PHONY: conv

vboxrun: vboxkill
	@vagrant ssh -c "cd Raph_Kernel; make cpimg"
	-vboxmanage unregistervm RK_Test --delete
	-rm $(VDI)
	vboxmanage createvm --name RK_Test --register
	vboxmanage modifyvm RK_Test --cpus 4 --ioapic on --chipset ich9 --hpet on --x2apic on --nic1 nat --nictype1 82540EM
	vboxmanage convertfromraw $(IMAGE) $(VDI)
	vboxmanage storagectl RK_Test --name SATAController --add sata --controller IntelAHCI --bootable on
	vboxmanage storageattach RK_Test --storagectl SATAController --port 0 --device 0 --type hdd --medium disk.vdi
	vboxmanage startvm RK_Test --type gui



updatepxeimg:
	@vagrant ssh -c "cd Raph_Kernel; make cpimg"
	gzip $(IMAGE)
	mv $(IMAGE).gz net/

burnipxe:
	./lan.sh local
	@vagrant ssh -c "cp /vagrant/load.cfg ipxe/; cd ipxe/src; make bin-x86_64-pcbios/ipxe.usb EMBED=../load.cfg; if [ ! -e /dev/sdb ]; then echo 'error: insert usb memory!'; exit -1; fi; sudo dd if=bin-x86_64-pcbios/ipxe.usb of=/dev/sdb"

burnipxe_remote:
	./lan.sh remote
	@vagrant ssh -c "cp /vagrant/load.cfg ipxe/; cd ipxe/src; make bin-x86_64-pcbios/ipxe.usb EMBED=../load.cfg; if [ ! -e /dev/sdb ]; then echo 'error: insert usb memory!'; exit -1; fi; sudo dd if=bin-x86_64-pcbios/ipxe.usb of=/dev/sdb"

vboxkill:
	-vboxmanage controlvm RK_Test poweroff

vnc:
	@echo vnc password is "a"
	$(VNC)
