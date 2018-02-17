.include "../common.s"

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

.org $0100
	nop
	jp start

.org $0150
start:
	disable_lcd

	; reset background code area
	ld hl,$9800
-		xor a
		ld (hl+),a
		ld a,h
		cp $9c
		jr nz,-

	; set background character data
	ld hl,characters
	ld bc,$8010
-		ld a,(hl+)
		ld (bc),a
		inc bc
		ld a,c
		cp $90
		jr nz,-

	; center (almost)
	ld a,$d8
	ldh (<scx_address),a
	ld a,$be
	ldh (<scy_address),a

	; check ly (should be 0)
	ldh a,(<ly_address)
	cp $00
	jp nz,fail

	; check mode (should be 0 ie hblank mode)
	ld hl,stat_address
	bit 0,(hl)
	jp nz,fail
	bit 1,(hl)
	jp nz,fail

	enable_lcd

	; check mode (should still be 0 ie hblank mode)
	ld hl,stat_address
	bit 0,(hl)
	jp nz,fail
	bit 1,(hl)
	jp nz,fail

	disable_lcd

	; print "success" (set background code area)
	ld hl,$9800
	ld a,$01
	ld (hl+),a ; s
	ld a,$02
	ld (hl+),a  ; u
	ld a,$03
	ld (hl+),a  ; c
	ld (hl+),a  ; c
	ld a,$04
	ld (hl+),a  ; e
	ld a,$01
	ld (hl+),a  ; s
	ld (hl+),a  ; s

done:
	enable_lcd

	; pause
-	jp -

fail:
	disable_lcd

	; print "fail" (set background code area)
	ld hl,$9800
	ld a,$05
	ld (hl+),a ; f
	ld a,$06
	ld (hl+),a  ; a
	ld a,$07
	ld (hl+),a  ; i
	ld a,$08
	ld (hl+),a  ; l

	jp done

characters:
	; s
	.db $00 $00
	.db $fc $fc
	.db $80 $80
	.db $80 $80
	.db $fc $fc
	.db $04 $04
	.db $04 $04
	.db $fc $fc

	; u
	.db $00 $00
	.db $84 $84
	.db $84 $84
	.db $84 $84
	.db $84 $84
	.db $84 $84
	.db $84 $84
	.db $fc $fc

	; c
	.db $00 $00
	.db $fc $fc
	.db $80 $80
	.db $80 $80
	.db $80 $80
	.db $80 $80
	.db $80 $80
	.db $fc $fc

	; e
	.db $00 $00
	.db $fc $fc
	.db $80 $80
	.db $80 $80
	.db $fc $fc
	.db $80 $80
	.db $80 $80
	.db $fc $fc

	; f
	.db $00 $00
	.db $fc $fc
	.db $80 $80
	.db $80 $80
	.db $fc $fc
	.db $80 $80
	.db $80 $80
	.db $80 $80

	; a
	.db $00 $00
	.db $fc $fc
	.db $84 $84
	.db $84 $84
	.db $fc $fc
	.db $84 $84
	.db $84 $84
	.db $84 $84

	; i
	.db $00 $00
	.db $7c $7c
	.db $10 $10
	.db $10 $10
	.db $10 $10
	.db $10 $10
	.db $10 $10
	.db $7c $7c

	; l
	.db $00 $00
	.db $80 $80
	.db $80 $80
	.db $80 $80
	.db $80 $80
	.db $80 $80
	.db $80 $80
	.db $fc $fc
