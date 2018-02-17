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

.macro disable_lcd
	; wait for vblank
-	ldh a,(<ly_address)
	cp $90
	jr nz,-

	; turn off lcd
	ld hl,lcdc_address
	res 7,(hl)
.endm

.macro enable_lcd
	ld hl,lcdc_address
	set 7,(hl)
.endm

.macro write_to_register args register_address value
	ld a,value
	ldh (<register_address),a
.endm

.macro memcpy args destination source size
	ld hl,source
	ld bc,destination
	ld d,$00 ; counter
-		ld a,(hl+)
		ld (bc),a
		inc bc
		inc d
		ld a,d
		cp size
		jr nz,-
.endm
