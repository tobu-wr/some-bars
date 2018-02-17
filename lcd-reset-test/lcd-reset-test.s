.include "../common.s"

.enum $c000
	irq_triggered db
.ende

; stat interrupt
.org $0048
	ld a,$01
	ld (irq_triggered),a
	ret

.org $0100
	nop
	jp start

.org $0150
start:
	; lyc = 0
	set_register lyc_address $00

	; ly = 144
	wait_vblank

	; reset irq_triggered
	xor a
	ld (irq_triggered),a

	; enable ly=lyc interrupt
	set_register stat_address $40
	set_register ie_address $02
	ei

	disable_lcd

	; reset background code area
	memset $9800 $00 $0400

	; set background character data
	memcpy $8010 character_datas $80

	; check ly (should be 0)
	ldh a,(<ly_address)
	cp $00
	jp nz,fail

	; check mode (should be 0 ie hblank mode)
	ldh a,(<stat_address)
	bit 0,a
	jp nz,fail
	bit 1,a
	jp nz,fail

	; check match flag (should be 0)
	ldh a,(<stat_address)
	bit 2,a
	jp nz,fail

	; check ly=lyc interrupt (shouldn't be triggered)
	ld a,(irq_triggered)
	cp $00
	jp nz,fail

	enable_lcd

	; check mode (should still be 0 ie hblank mode)
	ldh a,(<stat_address)
	bit 0,a
	jp nz,fail
	bit 1,a
	jp nz,fail

	; check match flag (should be 1)
	ldh a,(<stat_address)
	bit 2,a
	jp z,fail

	; check ly=lyc interrupt (should be triggered)
	ld a,(irq_triggered)
	cp $01
	jp nz,fail

	wait_vblank

	; reset irq_triggered
	xor a
	ld (irq_triggered),a

	; enable hblank interrupt
	set_register stat_address $08
	ei

	disable_lcd

	; check hblank interrupt (shouldn't be triggered)
	ld a,(irq_triggered)
	cp $00
	jp nz,fail

	enable_lcd

	; recheck hblank interrupt (shouldn't be triggered)
	ld a,(irq_triggered)
	cp $00
	jp nz,fail

	disable_lcd

	; print "success" (set background code area)
	memcpy $9821 success_string $07

done:
	enable_lcd

	; pause
-	jp -

fail:
	; check if lcd is already off
	ld hl,lcdc_address
	bit 7,(hl)
	jr z,+

	disable_lcd

	; print "fail" (set background code area)
+	memcpy $9821 fail_string $04

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
