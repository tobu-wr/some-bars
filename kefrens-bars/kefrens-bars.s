.include "../common.s"

.macro set_pixel0 args tile_address
	ld hl,tile_address
	set 7,(hl)
	res 6,(hl)
	set 5,(hl)
	res 4,(hl)
	inc hl
	set 7,(hl)
	set 6,(hl)
	res 5,(hl)
	set 4,(hl)
	jp hblank_end
.endm

.macro set_pixel1 args tile_address
	ld hl,tile_address
	set 6,(hl)
	res 5,(hl)
	set 4,(hl)
	res 3,(hl)
	inc hl
	set 6,(hl)
	set 5,(hl)
	res 4,(hl)
	set 3,(hl)
	jp hblank_end
.endm

.macro set_pixel2 args tile_address
	ld hl,tile_address
	set 5,(hl)
	res 4,(hl)
	set 3,(hl)
	res 2,(hl)
	inc hl
	set 5,(hl)
	set 4,(hl)
	res 3,(hl)
	set 2,(hl)
	jp hblank_end
.endm

.macro set_pixel3 args tile_address
	ld hl,tile_address
	set 4,(hl)
	res 3,(hl)
	set 2,(hl)
	res 1,(hl)
	inc hl
	set 4,(hl)
	set 3,(hl)
	res 2,(hl)
	set 1,(hl)
	jp hblank_end
.endm

.macro set_pixel4 args tile_address
	ld hl,tile_address
	set 3,(hl)
	res 2,(hl)
	set 1,(hl)
	res 0,(hl)
	inc hl
	set 3,(hl)
	set 2,(hl)
	res 1,(hl)
	set 0,(hl)
	jp hblank_end
.endm

.macro set_pixel5 args tile_address
	ld hl,tile_address
	set 2,(hl)
	res 1,(hl)
	set 0,(hl)
	inc hl
	set 2,(hl)
	set 1,(hl)
	res 0,(hl)
	ld hl,tile_address+$10
	res 7,(hl)
	inc hl
	set 7,(hl)
	jp hblank_end
.endm

.macro set_pixel6 args tile_address
	ld hl,tile_address
	set 1,(hl)
	res 0,(hl)
	inc hl
	set 1,(hl)
	set 0,(hl)
	ld hl,tile_address+$10
	set 7,(hl)
	res 6,(hl)
	inc hl
	res 7,(hl)
	set 6,(hl)
	jp hblank_end
.endm

.macro set_pixel7 args tile_address
	ld hl,tile_address
	set 0,(hl)
	inc hl
	set 0,(hl)
	ld hl,tile_address+$10
	res 7,(hl)
	set 6,(hl) 
	res 5,(hl)
	inc hl
	set 7,(hl)
	res 6,(hl)
	set 5,(hl)
	jp hblank_end
.endm

.org $0040
	jp vblank

.org $0048
	jp hblank

.org $0100
	nop
	jp start

.org $0150
start:
	wait_vblank

	; init background palette
	set_register bgp_address $93

	; init background code area
	ld hl,$9800
	xor a
-		ld (hl+),a
		inc a
		cp $14
		jr nz,-

	; enable hblank and vblank interrupts
	set_register if_address $00
	set_register stat_address $08
	set_register ie_address $03
	ei

	; prepare first hblank jump
	ld hl,hblank_end

main_loop:
	jr main_loop

vblank:
	; reset scy register
	set_register scy_address $00

	; clean first pixel line
	ld hl,$8000
	ld bc,$000f
-		ld (hl),$00
		inc hl
		ld (hl),$00
		add hl,bc
		inc a
		cp $14
		jr nz,-

	; increment d for the next frame
	inc d

	; first sine curve
	ld hl,sine_table
	ld b,$00
	ld c,d
	add hl,bc
	ld e,(hl) ; save

	; second sine curve
	ld hl,sine_table
	ld a,d
	add d
	rlca ; frequency * 2
	ld c,a
	add hl,bc
	ld a,(hl)
	srl a ; amplitude / 2

	; add sine curves
	add e

	; prepare next hblank jump
	ld c,a
	sla c
	jr nc,+
	inc b
+	ld hl,jump_table
	add hl,bc
	ld a,(hl+)
	ld h,(hl)
	ld l,a

	reti

hblank:
	jp hl

hblank_end:
	; decrement scy register
	ld hl,scy_address
	dec (hl)

	; first sine curve
	ld hl,sine_table
	ld b,$00
	ldh a,(<ly_address)
	add d
	ld c,a
	add hl,bc
	ld e,(hl) ; save

	; second sine curve
	ld hl,sine_table
	add d
	rlca ; frequency * 2
	ld c,a
	add hl,bc
	ld a,(hl)
	srl a ; amplitude / 2

	; add sine curves
	add e

	; prepare next hblank jump
	ld c,a
	sla c
	jr nc,+
	inc b
+	ld hl,jump_table
	add hl,bc
	ld a,(hl+)
	ld h,(hl)
	ld l,a

	reti

jump0:
	set_pixel0 $8000
jump1:
	set_pixel1 $8000
jump2:
	set_pixel2 $8000
jump3:
	set_pixel3 $8000
jump4:
	set_pixel4 $8000
jump5:
	set_pixel5 $8000
jump6:
	set_pixel6 $8000
jump7:
	set_pixel7 $8000
jump8:
	set_pixel0 $8010
jump9:
	set_pixel1 $8010
jump10:
	set_pixel2 $8010
jump11:
	set_pixel3 $8010
jump12:
	set_pixel4 $8010
jump13:
	set_pixel5 $8010
jump14:
	set_pixel6 $8010
jump15:
	set_pixel7 $8010
jump16:
	set_pixel0 $8020
jump17:
	set_pixel1 $8020
jump18:
	set_pixel2 $8020
jump19:
	set_pixel3 $8020
jump20:
	set_pixel4 $8020
jump21:
	set_pixel5 $8020
jump22:
	set_pixel6 $8020
jump23:
	set_pixel7 $8020
jump24:
	set_pixel0 $8030
jump25:
	set_pixel1 $8030
jump26:
	set_pixel2 $8030
jump27:
	set_pixel3 $8030
jump28:
	set_pixel4 $8030
jump29:
	set_pixel5 $8030
jump30:
	set_pixel6 $8030
jump31:
	set_pixel7 $8030
jump32:
	set_pixel0 $8040
jump33:
	set_pixel1 $8040
jump34:
	set_pixel2 $8040
jump35:
	set_pixel3 $8040
jump36:
	set_pixel4 $8040
jump37:
	set_pixel5 $8040
jump38:
	set_pixel6 $8040
jump39:
	set_pixel7 $8040
jump40:
	set_pixel0 $8050
jump41:
	set_pixel1 $8050
jump42:
	set_pixel2 $8050
jump43:
	set_pixel3 $8050
jump44:
	set_pixel4 $8050
jump45:
	set_pixel5 $8050
jump46:
	set_pixel6 $8050
jump47:
	set_pixel7 $8050
jump48:
	set_pixel0 $8060
jump49:
	set_pixel1 $8060
jump50:
	set_pixel2 $8060
jump51:
	set_pixel3 $8060
jump52:
	set_pixel4 $8060
jump53:
	set_pixel5 $8060
jump54:
	set_pixel6 $8060
jump55:
	set_pixel7 $8060
jump56:
	set_pixel0 $8070
jump57:
	set_pixel1 $8070
jump58:
	set_pixel2 $8070
jump59:
	set_pixel3 $8070
jump60:
	set_pixel4 $8070
jump61:
	set_pixel5 $8070
jump62:
	set_pixel6 $8070
jump63:
	set_pixel7 $8070
jump64:
	set_pixel0 $8080
jump65:
	set_pixel1 $8080
jump66:
	set_pixel2 $8080
jump67:
	set_pixel3 $8080
jump68:
	set_pixel4 $8080
jump69:
	set_pixel5 $8080
jump70:
	set_pixel6 $8080
jump71:
	set_pixel7 $8080
jump72:
	set_pixel0 $8090
jump73:
	set_pixel1 $8090
jump74:
	set_pixel2 $8090
jump75:
	set_pixel3 $8090
jump76:
	set_pixel4 $8090
jump77:
	set_pixel5 $8090
jump78:
	set_pixel6 $8090
jump79:
	set_pixel7 $8090
jump80:
	set_pixel0 $80a0
jump81:
	set_pixel1 $80a0
jump82:
	set_pixel2 $80a0
jump83:
	set_pixel3 $80a0
jump84:
	set_pixel4 $80a0
jump85:
	set_pixel5 $80a0
jump86:
	set_pixel6 $80a0
jump87:
	set_pixel7 $80a0
jump88:
	set_pixel0 $80b0
jump89:
	set_pixel1 $80b0
jump90:
	set_pixel2 $80b0
jump91:
	set_pixel3 $80b0
jump92:
	set_pixel4 $80b0
jump93:
	set_pixel5 $80b0
jump94:
	set_pixel6 $80b0
jump95:
	set_pixel7 $80b0
jump96:
	set_pixel0 $80c0
jump97:
	set_pixel1 $80c0
jump98:
	set_pixel2 $80c0
jump99:
	set_pixel3 $80c0
jump100:
	set_pixel4 $80c0
jump101:
	set_pixel5 $80c0
jump102:
	set_pixel6 $80c0
jump103:
	set_pixel7 $80c0
jump104:
	set_pixel0 $80d0
jump105:
	set_pixel1 $80d0
jump106:
	set_pixel2 $80d0
jump107:
	set_pixel3 $80d0
jump108:
	set_pixel4 $80d0
jump109:
	set_pixel5 $80d0
jump110:
	set_pixel6 $80d0
jump111:
	set_pixel7 $80d0
jump112:
	set_pixel0 $80e0
jump113:
	set_pixel1 $80e0
jump114:
	set_pixel2 $80e0
jump115:
	set_pixel3 $80e0
jump116:
	set_pixel4 $80e0
jump117:
	set_pixel5 $80e0
jump118:
	set_pixel6 $80e0
jump119:
	set_pixel7 $80e0
jump120:
	set_pixel0 $80f0
jump121:
	set_pixel1 $80f0
jump122:
	set_pixel2 $80f0
jump123:
	set_pixel3 $80f0
jump124:
	set_pixel4 $80f0
jump125:
	set_pixel5 $80f0
jump126:
	set_pixel6 $80f0
jump127:
	set_pixel7 $80f0
jump128:
	set_pixel0 $8100
jump129:
	set_pixel1 $8100
jump130:
	set_pixel2 $8100
jump131:
	set_pixel3 $8100
jump132:
	set_pixel4 $8100
jump133:
	set_pixel5 $8100
jump134:
	set_pixel6 $8100
jump135:
	set_pixel7 $8100
jump136:
	set_pixel0 $8110
jump137:
	set_pixel1 $8110
jump138:
	set_pixel2 $8110
jump139:
	set_pixel3 $8110
jump140:
	set_pixel4 $8110
jump141:
	set_pixel5 $8110
jump142:
	set_pixel6 $8110
jump143:
	set_pixel7 $8110
jump144:
	set_pixel0 $8120
jump145:
	set_pixel1 $8120
jump146:
	set_pixel2 $8120
jump147:
	set_pixel3 $8120
jump148:
	set_pixel4 $8120
jump149:
	set_pixel5 $8120
jump150:
	set_pixel6 $8120
jump151:
	set_pixel7 $8120
jump152:
	set_pixel0 $8130
jump153:
	set_pixel1 $8130
jump154:
	set_pixel2 $8130
jump155:
	set_pixel3 $8130
jump156:
	set_pixel4 $8130
jump157:
	set_pixel5 $8130
jump158:
	set_pixel6 $8130
jump159:
	set_pixel7 $8130

jump_table:
	.dw jump0 jump1 jump2 jump3 jump4 jump5 jump6 jump7
	.dw jump8 jump9 jump10 jump11 jump12 jump13 jump14 jump15
	.dw jump16 jump17 jump18 jump19 jump20 jump21 jump22 jump23
	.dw jump24 jump25 jump26 jump27 jump28 jump29 jump30 jump31
	.dw jump32 jump33 jump34 jump35 jump36 jump37 jump38 jump39
	.dw jump40 jump41 jump42 jump43 jump44 jump45 jump46 jump47
	.dw jump48 jump49 jump50 jump51 jump52 jump53 jump54 jump55
	.dw jump56 jump57 jump58 jump59 jump60 jump61 jump62 jump63
	.dw jump64 jump65 jump66 jump67 jump68 jump69 jump70 jump71
	.dw jump72 jump73 jump74 jump75 jump76 jump77 jump78 jump79
	.dw jump80 jump81 jump82 jump83 jump84 jump85 jump86 jump87
	.dw jump88 jump89 jump90 jump91 jump92 jump93 jump94 jump95
	.dw jump96 jump97 jump98 jump99 jump100 jump101 jump102 jump103
	.dw jump104 jump105 jump106 jump107 jump108 jump109 jump110 jump111
	.dw jump112 jump113 jump114 jump115 jump116 jump117 jump118 jump119
	.dw jump120 jump121 jump122 jump123 jump124 jump125 jump126 jump127
	.dw jump128 jump129 jump130 jump131 jump132 jump133 jump134 jump135
	.dw jump136 jump137 jump138 jump139 jump140 jump141 jump142 jump143
	.dw jump144 jump145 jump146 jump147 jump148 jump149 jump150 jump151
	.dw jump152 jump153 jump154 jump155 jump156 jump157 jump158 jump159
	.dw hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end
	.dw hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end
	.dw hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end
	.dw hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end
	.dw hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end
	.dw hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end
	.dw hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end
	.dw hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end
	.dw hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end
	.dw hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end
	.dw hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end
	.dw hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end hblank_end

sine_table:
	.incbin "sine_table.bin"

