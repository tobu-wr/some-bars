.gbheader
	nintendologo
.endgb

.memorymap
	slotsize $4000
	defaultslot 0
	slot 0 $0000
.endme

.rombanksize $4000
.rombanks 2

.define if_address $ff0f
.define lcdc_address $ff40
.define stat_address $ff41
.define scy_address $ff42
.define scx_address $ff43
.define ly_address $ff44
.define bgp_address $ff47
.define ie_address $ffff
