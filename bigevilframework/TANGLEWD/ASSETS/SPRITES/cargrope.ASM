; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   **AUTOGENERATED WITH BEEHIVE** - the complete art tool for SEGA Mega Drive
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   http://www.bigevilcorporation.co.uk
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   Beehive and SEGA Genesis Framework (c) Matt Phillips 2015
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==


actor_cargrope:

actor_cargrope_VRAM_size_b		equ 0x180	; VRAM size to alloc (size of largest frame, bytes)
actor_cargrope_sheet_cargo_rope_l4_width		equ 0x50	; Max width of largest frame in pixels
actor_cargrope_sheet_cargo_rope_l4_height		equ 0x10	; Max height of largest frame in pixels


actor_cargrope_sheet_cargo_rope_l5_width		equ 0x50	; Max width of largest frame in pixels
actor_cargrope_sheet_cargo_rope_l5_height		equ 0x10	; Max height of largest frame in pixels


actor_cargrope_sheet_cargo_rope_l4_frametable:
actor_cargrope_sheet_cargo_rope_l4_frame_0_header:
	dc.w 0x000C	; Frame size (tiles)
	dc.w actor_cargrope_sheet_cargo_rope_l4_frame_0_size_subsprites	; Frame size (subsprites)
	dc.l actor_cargrope_sheet_cargo_rope_l4_frame_0
	dc.l actor_cargrope_sheet_cargo_rope_l4_frame_0_subsprite_dimensions_bits
	dc.l actor_cargrope_sheet_cargo_rope_l4_frame_0_subsprite_pos_offsets

actor_cargrope_sheet_cargo_rope_l5_frametable:
actor_cargrope_sheet_cargo_rope_l5_frame_0_header:
	dc.w 0x000C	; Frame size (tiles)
	dc.w actor_cargrope_sheet_cargo_rope_l5_frame_0_size_subsprites	; Frame size (subsprites)
	dc.l actor_cargrope_sheet_cargo_rope_l5_frame_0
	dc.l actor_cargrope_sheet_cargo_rope_l5_frame_0_subsprite_dimensions_bits
	dc.l actor_cargrope_sheet_cargo_rope_l5_frame_0_subsprite_pos_offsets

actor_cargrope_sheet_cargo_rope_l4_frame_0_size_b		equ 0x0180	; Size in bytes
actor_cargrope_sheet_cargo_rope_l4_frame_0_size_t		equ 0x000C	; Size in tiles
actor_cargrope_sheet_cargo_rope_l4_frame_0_size_subsprites		equ 0x0002	; Size in subsprites

; Subsprite offsets from 0,0 (in pixels) - unflipped (ww) and flipped X (ww)
actor_cargrope_sheet_cargo_rope_l4_frame_0_subsprite_pos_offsets:
	dc.l 0x00100000, 0x00200000
	dc.l 0x00300000, 0x00100000
	Even

; Subsprite dimension bits (for sprite descs)
actor_cargrope_sheet_cargo_rope_l4_frame_0_subsprite_dimensions_bits:
	dc.b 0xD
	dc.b 0x5
	Even


actor_cargrope_sheet_cargo_rope_l5_frame_0_size_b		equ 0x0180	; Size in bytes
actor_cargrope_sheet_cargo_rope_l5_frame_0_size_t		equ 0x000C	; Size in tiles
actor_cargrope_sheet_cargo_rope_l5_frame_0_size_subsprites		equ 0x0002	; Size in subsprites

; Subsprite offsets from 0,0 (in pixels) - unflipped (ww) and flipped X (ww)
actor_cargrope_sheet_cargo_rope_l5_frame_0_subsprite_pos_offsets:
	dc.l 0x00100000, 0x00200000
	dc.l 0x00300000, 0x00100000
	Even

; Subsprite dimension bits (for sprite descs)
actor_cargrope_sheet_cargo_rope_l5_frame_0_subsprite_dimensions_bits:
	dc.b 0xD
	dc.b 0x5
	Even


spritesheets_cargrope:

spritesheet_cargrope_cargo_rope_l4:

actor_cargrope_sheet_cargo_rope_l4_frame_0:
	dc.l	0x00C8C000
	dc.l	0x00C88000
	dc.l	0x0088C000
	dc.l	0x00C8C000
	dc.l	0x0088C000
	dc.l	0x00C8C000
	dc.l	0x00C88000
	dc.l	0x0088C000

	dc.l	0x00C8C000
	dc.l	0x00C88000
	dc.l	0x0088C000
	dc.l	0x00C8C000
	dc.l	0x0088C000
	dc.l	0x00C8C000
	dc.l	0x00C88000
	dc.l	0x0088C000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00C8C000
	dc.l	0x00C88000
	dc.l	0x0088C000
	dc.l	0x00C8C000
	dc.l	0x0088C000
	dc.l	0x00C8C000
	dc.l	0x00C88000
	dc.l	0x0088C000

	dc.l	0x00C8C000
	dc.l	0x00C88000
	dc.l	0x0088C000
	dc.l	0x00C8C000
	dc.l	0x0088C000
	dc.l	0x00C8C000
	dc.l	0x00C88000
	dc.l	0x0088C000




spritesheet_cargrope_cargo_rope_l5:

actor_cargrope_sheet_cargo_rope_l5_frame_0:
	dc.l	0x00DAD000
	dc.l	0x00DAA000
	dc.l	0x00AAD000
	dc.l	0x00DAD000
	dc.l	0x00AAD000
	dc.l	0x00DAD000
	dc.l	0x00DAA000
	dc.l	0x00AAD000

	dc.l	0x00DAD000
	dc.l	0x00DAA000
	dc.l	0x00AAD000
	dc.l	0x00DAD000
	dc.l	0x00AAD000
	dc.l	0x00DAD000
	dc.l	0x00DAA000
	dc.l	0x00AAD000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000
	dc.l	0x00000000

	dc.l	0x00DAD000
	dc.l	0x00DAA000
	dc.l	0x00AAD000
	dc.l	0x00DAD000
	dc.l	0x00AAD000
	dc.l	0x00DAD000
	dc.l	0x00DAA000
	dc.l	0x00AAD000

	dc.l	0x00DAD000
	dc.l	0x00DAA000
	dc.l	0x00AAD000
	dc.l	0x00DAD000
	dc.l	0x00AAD000
	dc.l	0x00DAD000
	dc.l	0x00DAA000
	dc.l	0x00AAD000




