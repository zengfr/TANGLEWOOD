; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   **AUTOGENERATED WITH BEEHIVE** - the complete art tool for SEGA Mega Drive
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   http://www.bigevilcorporation.co.uk
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   Beehive and SEGA Genesis Framework (c) Matt Phillips 2015
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==


terrainmap_blockmap_tst1_size_b	equ 0x00000240	; Size in bytes
terrainmap_blockmap_tst1_size_w	equ (terrainmap_blockmap_tst1_size_b/2)	; Size in words
terrainmap_blockmap_tst1_size_l	equ (terrainmap_blockmap_tst1_size_b/4)	; Size in longwords
terrainmap_tst1_left	equ 0x00
terrainmap_tst1_top	equ 0x1C
terrainmap_tst1_width	equ 0x80
terrainmap_tst1_height	equ 0x24
terrainmap_blockmap_tst1_left	equ 0x00
terrainmap_blockmap_tst1_top	equ 0x07
terrainmap_blockmap_tst1_width	equ 0x20
terrainmap_blockmap_tst1_height	equ 0x09

collisionmap_blockmap_yoffs_tst1:
	dc.w 0x0000
	dc.w 0x0020
	dc.w 0x0040
	dc.w 0x0060
	dc.w 0x0080
	dc.w 0x00A0
	dc.w 0x00C0
	dc.w 0x00E0
	dc.w 0x0100

; Terrain bezier bounds
terrainmap_tst1_num_special_terrain_descs	equ 0x00
terrainmap_tst1_special_terrain_descs:
