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

.macro wait_vblank
	; wait for LY = 144
-	ldh a,(<ly_address)
	cp $90
	jr nz,-
.endm

.macro disable_lcd
	; lcd should be turn off during vblank in dmg
	wait_vblank

	; turn off lcd
	ld hl,lcdc_address
	res 7,(hl)
.endm

.macro enable_lcd
	ld hl,lcdc_address
	set 7,(hl)
.endm

.macro set_register args register_address value
	.if value == 0
		xor a
	.else
		ld a,value
	.endif
	ldh (<register_address),a
.endm

.macro memcpy args destination source size
	ld hl,source
	ld bc,destination
	ld de,$0000 ; counter
-		ld a,(hl+)
		ld (bc),a
		inc bc
		inc de
		ld a,d
		cp >size
		jr nz,-
		ld a,e
		cp <size
		jr nz,-
.endm

.macro memset args destination value size
	ld hl,destination
	ld bc,size
	ld de,$0000; counter
-		ld (hl),value
		inc hl
		inc de
		ld a,d
		cp b
		jr nz,-
		ld a,e
		cp c
		jr nz,-
.endm
