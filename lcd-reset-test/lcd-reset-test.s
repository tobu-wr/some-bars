.include "../common.s"

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
	memcpy $8010 character_datas $80

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
	memcpy $9821 success_string $07

done:
	enable_lcd

	; pause
-	jp -

fail:
	disable_lcd

	; print "fail" (set background code area)
	memcpy $9821 fail_string $04

	jp done

success_string:
	.db $01 $02 $03 $03 $04 $01 $01

fail_string:
	.db $05 $06 $07 $08

character_datas:
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
