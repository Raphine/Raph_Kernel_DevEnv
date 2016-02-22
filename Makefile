IMAGE = disk.img
VDI = disk.vdi

.PHONY: conv

conv:
	-rm $(VDI)
	vboxmanage convertfromraw $(IMAGE) $(VDI)
