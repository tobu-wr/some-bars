.include "../../common.s"

.romgbconly

.org $0100
	nop
	jp start

.org $0150
start:
	disable_lcd

	; set background palettes
	set_register bcps_address $86
	reset_register bcpd_address
	reset_register bcpd_address

	; reset background code area
	memset $9800 $00 $0400

	; set background code area
	memcpy $9800 success_string $07

	; init hdma registers to set background character data
	set_register hdma1_address >character_data
	set_register hdma2_address <character_data
	set_register hdma3_address $80
	set_register hdma4_address $10

	; start gdma (first part)
	set_register hdma5_address $02

	; resume gdma (last part)
	set_register hdma5_address $03

	; draw
	enable_lcd

	; pause
-	jp -
	
success_string:
	.db $01 $02 $03 $04 $05 $06 $07

.org $0000
character_data:
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

	; s
	.db $00 $00
	.db $fc $fc
	.db $80 $80
	.db $80 $80
	.db $fc $fc
	.db $04 $04
	.db $04 $04
	.db $fc $fc

	; s
	.db $00 $00
	.db $fc $fc
	.db $80 $80
	.db $80 $80
	.db $fc $fc
	.db $04 $04
	.db $04 $04
	.db $fc $fc
