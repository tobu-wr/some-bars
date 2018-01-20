.include "../common/common.s"

.org $0100
	nop
	jp start

.org $0150
start:
	jr start
	