; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   **AUTOGENERATED WITH BEEHIVE** - the complete art tool for SEGA Mega Drive
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   http://www.bigevilcorporation.co.uk
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   Beehive and SEGA Genesis Framework (c) Matt Phillips 2015
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==


actor_stalact:

actor_stalact_VRAM_size_b		equ 0x180	; VRAM size to alloc (size of largest frame, bytes)
actor_stalact_sheet_stalactite_width		equ 0x18	; Max width of largest frame in pixels
actor_stalact_sheet_stalactite_height		equ 0x20	; Max height of largest frame in pixels


actor_stalact_sheet_stalactite_frametable:
actor_stalact_sheet_stalactite_frame_0_header:
	dc.w 0x000C	; Frame size (tiles)
	dc.w actor_stalact_sheet_stalactite_frame_0_size_subsprites	; Frame size (subsprites)
	dc.l actor_stalact_sheet_stalactite_frame_0
	dc.l actor_stalact_sheet_stalactite_frame_0_subsprite_dimensions_bits
	dc.l actor_stalact_sheet_stalactite_frame_0_subsprite_pos_offsets

actor_stalact_sheet_stalactite_frame_0_size_b		equ 0x0180	; Size in bytes
actor_stalact_sheet_stalactite_frame_0_size_t		equ 0x000C	; Size in tiles
actor_stalact_sheet_stalactite_frame_0_size_subsprites		equ 0x0001	; Size in subsprites

; Subsprite offsets from 0,0 (in pixels) - unflipped (ww) and flipped X (ww)
actor_stalact_sheet_stalactite_frame_0_subsprite_pos_offsets:
	dc.l 0x00000000, 0x00000000
	Even

; Subsprite dimension bits (for sprite descs)
actor_stalact_sheet_stalactite_frame_0_subsprite_dimensions_bits:
	dc.b 0xB
	Even


spritesheets_stalact:

spritesheet_stalact_stalactite:

actor_stalact_sheet_stalactite_frame_0:
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000555
	dc.l	0x00005A55
	dc.l	0x00005A55
	dc.l	0x0000AA55
	dc.l	0x0000AAAA

	dc.l	0x0000AA5A
	dc.l	0x000CAA5A
	dc.l	0x000CA55A
	dc.l	0x000CAAAA
	dc.l	0x000AA5CC
	dc.l	0x000AA52A
	dc.l	0x0000A52C
	dc.l	0x000002CC

	dc.l	0x000000CA
	dc.l	0x000000CA
	dc.l	0x000000CA
	dc.l	0x000000CC
	dc.l	0x000000CC
	dc.l	0x000000CC
	dc.l	0x0000000C
	dc.l	0x0000000C

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x000055A5
	dc.l	0x00CAAAAA
	dc.l	0x0CAAAAAA
	dc.l	0xAAAAAAAA
	dc.l	0xAAAAACCC
	dc.l	0xAAAAACCC
	dc.l	0xAAAAAAA2
	dc.l	0xAAAAAAA5

	dc.l	0xAAAAA555
	dc.l	0xAAAA5552
	dc.l	0xAAAA5525
	dc.l	0xAAAC5255
	dc.l	0xC552A252
	dc.l	0xAAC522A5
	dc.l	0xCA555225
	dc.l	0xAA555222

	dc.l	0xCC555222
	dc.l	0xA5555552
	dc.l	0xCA555552
	dc.l	0xCC555552
	dc.l	0xCCC55522
	dc.l	0xCCCA5252
	dc.l	0xCCCCA222
	dc.l	0xCCCCC552

	dc.l	0xCCCC5522
	dc.l	0xCCCCAA22
	dc.l	0x0CCAAA25
	dc.l	0x0AAAAA25
	dc.l	0x00AAA222
	dc.l	0x00AAA220
	dc.l	0x000AC200
	dc.l	0x0000C000

	dc.l	0x50000000
	dc.l	0x55000000
	dc.l	0x55222000
	dc.l	0x55525000
	dc.l	0xC5A22220
	dc.l	0xCAAA2222
	dc.l	0x255A5222
	dc.l	0x25555222

	dc.l	0x2A552222
	dc.l	0x2A555222
	dc.l	0x2AA55522
	dc.l	0x2ACA52A2
	dc.l	0x22AC5252
	dc.l	0x52AAAA22
	dc.l	0x5525A550
	dc.l	0x55522000

	dc.l	0x22222000
	dc.l	0x22222000
	dc.l	0x22222000
	dc.l	0x22522000
	dc.l	0x22522000
	dc.l	0x25555000
	dc.l	0x22555000
	dc.l	0x22500000

	dc.l	0x22000000
	dc.l	0x22000000
	dc.l	0x20000000
	dc.l	0x50000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000




