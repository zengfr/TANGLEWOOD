; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   **AUTOGENERATED WITH BEEHIVE** - the complete art tool for SEGA Mega Drive
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   http://www.bigevilcorporation.co.uk
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   Beehive and SEGA Genesis Framework (c) Matt Phillips 2015
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==


map_blockmap_L8A2_size_b	equ 0x0000072A	; Size in bytes
map_blockmap_L8A2_size_w	equ (map_blockmap_L8A2_size_b/2)	; Size in words
map_blockmap_L8A2_size_l	equ (map_blockmap_L8A2_size_b/4)	; Size in longwords
map_L8A2_width	equ 0xC0
map_L8A2_height	equ 0xA0
map_blockmap_L8A2_width	equ 0x30
map_blockmap_L8A2_height	equ 0x28

map_blockmap_L8A2_coloffsets:
	dc.w 0x0000
	dc.w 0x000A
	dc.w 0x0014
	dc.w 0x0030
	dc.w 0x004C
	dc.w 0x005A
	dc.w 0x0068
	dc.w 0x0084
	dc.w 0x00A4
	dc.w 0x00D0
	dc.w 0x00FC
	dc.w 0x011A
	dc.w 0x0138
	dc.w 0x0156
	dc.w 0x0182
	dc.w 0x01AE
	dc.w 0x01D6
	dc.w 0x01FE
	dc.w 0x022C
	dc.w 0x025A
	dc.w 0x0288
	dc.w 0x02B2
	dc.w 0x02DC
	dc.w 0x0306
	dc.w 0x0334
	dc.w 0x0362
	dc.w 0x0394
	dc.w 0x03C4
	dc.w 0x03F2
	dc.w 0x0420
	dc.w 0x044C
	dc.w 0x0478
	dc.w 0x04A4
	dc.w 0x04D0
	dc.w 0x050E
	dc.w 0x054C
	dc.w 0x058C
	dc.w 0x05C6
	dc.w 0x05E8
	dc.w 0x060A
	dc.w 0x062C
	dc.w 0x064C
	dc.w 0x067A
	dc.w 0x06A8
	dc.w 0x06C4
	dc.w 0x06DC
	dc.w 0x06FE
	dc.w 0x0720
