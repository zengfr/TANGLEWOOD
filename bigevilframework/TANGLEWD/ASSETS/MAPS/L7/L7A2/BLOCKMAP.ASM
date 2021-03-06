; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   **AUTOGENERATED WITH BEEHIVE** - the complete art tool for SEGA Mega Drive
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   http://www.bigevilcorporation.co.uk
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==
;   Beehive and SEGA Genesis Framework (c) Matt Phillips 2015
; == == == == == == == == == == == == == == == == == == == == == == == == == == == == == == ==


map_blockmap_L7A2_size_b	equ 0x00001CC4	; Size in bytes
map_blockmap_L7A2_size_w	equ (map_blockmap_L7A2_size_b/2)	; Size in words
map_blockmap_L7A2_size_l	equ (map_blockmap_L7A2_size_b/4)	; Size in longwords
map_L7A2_width	equ 0x44C
map_L7A2_height	equ 0xB4
map_blockmap_L7A2_width	equ 0x113
map_blockmap_L7A2_height	equ 0x2D

map_blockmap_L7A2_coloffsets:
	dc.w 0x0000
	dc.w 0x0010
	dc.w 0x0020
	dc.w 0x0030
	dc.w 0x0040
	dc.w 0x0050
	dc.w 0x0060
	dc.w 0x0070
	dc.w 0x0080
	dc.w 0x0092
	dc.w 0x00A4
	dc.w 0x00B6
	dc.w 0x00C8
	dc.w 0x00EC
	dc.w 0x0110
	dc.w 0x012A
	dc.w 0x0144
	dc.w 0x0168
	dc.w 0x018C
	dc.w 0x019E
	dc.w 0x01B0
	dc.w 0x01C0
	dc.w 0x01D2
	dc.w 0x01EC
	dc.w 0x0202
	dc.w 0x0218
	dc.w 0x0230
	dc.w 0x0246
	dc.w 0x0260
	dc.w 0x0278
	dc.w 0x0292
	dc.w 0x02AE
	dc.w 0x02CA
	dc.w 0x02E8
	dc.w 0x0308
	dc.w 0x0328
	dc.w 0x0346
	dc.w 0x0364
	dc.w 0x0380
	dc.w 0x0396
	dc.w 0x03A6
	dc.w 0x03CA
	dc.w 0x03F0
	dc.w 0x0408
	dc.w 0x0420
	dc.w 0x043C
	dc.w 0x045A
	dc.w 0x047A
	dc.w 0x0496
	dc.w 0x04AC
	dc.w 0x04BE
	dc.w 0x04D8
	dc.w 0x04F2
	dc.w 0x0516
	dc.w 0x053C
	dc.w 0x0554
	dc.w 0x056C
	dc.w 0x0580
	dc.w 0x0590
	dc.w 0x05A4
	dc.w 0x05B6
	dc.w 0x05C8
	dc.w 0x05DA
	dc.w 0x05EA
	dc.w 0x0600
	dc.w 0x061A
	dc.w 0x0634
	dc.w 0x064C
	dc.w 0x0666
	dc.w 0x067A
	dc.w 0x068C
	dc.w 0x06A0
	dc.w 0x06B4
	dc.w 0x06C6
	dc.w 0x06D8
	dc.w 0x06EA
	dc.w 0x06FE
	dc.w 0x0712
	dc.w 0x0724
	dc.w 0x0742
	dc.w 0x0760
	dc.w 0x0774
	dc.w 0x0786
	dc.w 0x0798
	dc.w 0x07AC
	dc.w 0x07C0
	dc.w 0x07D2
	dc.w 0x07E4
	dc.w 0x07F8
	dc.w 0x0812
	dc.w 0x0834
	dc.w 0x0848
	dc.w 0x0858
	dc.w 0x0868
	dc.w 0x0878
	dc.w 0x0888
	dc.w 0x0898
	dc.w 0x08A8
	dc.w 0x08BA
	dc.w 0x08D4
	dc.w 0x08F0
	dc.w 0x090A
	dc.w 0x0924
	dc.w 0x093E
	dc.w 0x095A
	dc.w 0x097A
	dc.w 0x0998
	dc.w 0x09B4
	dc.w 0x09D0
	dc.w 0x09EE
	dc.w 0x0A0C
	dc.w 0x0A2C
	dc.w 0x0A52
	dc.w 0x0A78
	dc.w 0x0AB0
	dc.w 0x0AEA
	dc.w 0x0B10
	dc.w 0x0B38
	dc.w 0x0B74
	dc.w 0x0BAE
	dc.w 0x0BCC
	dc.w 0x0BEC
	dc.w 0x0C18
	dc.w 0x0C44
	dc.w 0x0C62
	dc.w 0x0C80
	dc.w 0x0C90
	dc.w 0x0CA0
	dc.w 0x0CB2
	dc.w 0x0CC6
	dc.w 0x0CDC
	dc.w 0x0CF0
	dc.w 0x0D06
	dc.w 0x0D1A
	dc.w 0x0D2E
	dc.w 0x0D40
	dc.w 0x0D54
	dc.w 0x0D70
	dc.w 0x0D8A
	dc.w 0x0DA2
	dc.w 0x0DBC
	dc.w 0x0DD6
	dc.w 0x0DFC
	dc.w 0x0E20
	dc.w 0x0E44
	dc.w 0x0E68
	dc.w 0x0E9C
	dc.w 0x0ED0
	dc.w 0x0EF6
	dc.w 0x0F18
	dc.w 0x0F38
	dc.w 0x0F54
	dc.w 0x0F6C
	dc.w 0x0F84
	dc.w 0x0FB8
	dc.w 0x0FCA
	dc.w 0x0FDC
	dc.w 0x0FF0
	dc.w 0x1004
	dc.w 0x1018
	dc.w 0x102E
	dc.w 0x1042
	dc.w 0x1056
	dc.w 0x1068
	dc.w 0x107A
	dc.w 0x108E
	dc.w 0x10A2
	dc.w 0x10B6
	dc.w 0x10CC
	dc.w 0x10E0
	dc.w 0x10F4
	dc.w 0x1106
	dc.w 0x1118
	dc.w 0x112A
	dc.w 0x113E
	dc.w 0x1152
	dc.w 0x1166
	dc.w 0x1178
	dc.w 0x118C
	dc.w 0x119E
	dc.w 0x11B0
	dc.w 0x11C4
	dc.w 0x11DA
	dc.w 0x11EC
	dc.w 0x1200
	dc.w 0x1212
	dc.w 0x1226
	dc.w 0x123A
	dc.w 0x124E
	dc.w 0x1262
	dc.w 0x1278
	dc.w 0x128E
	dc.w 0x12A2
	dc.w 0x12B6
	dc.w 0x12CC
	dc.w 0x12DE
	dc.w 0x12F2
	dc.w 0x1304
	dc.w 0x1318
	dc.w 0x1330
	dc.w 0x134A
	dc.w 0x1364
	dc.w 0x1378
	dc.w 0x138C
	dc.w 0x139E
	dc.w 0x13B0
	dc.w 0x13C8
	dc.w 0x13F0
	dc.w 0x1418
	dc.w 0x1432
	dc.w 0x1450
	dc.w 0x1470
	dc.w 0x1498
	dc.w 0x14C2
	dc.w 0x14EA
	dc.w 0x1512
	dc.w 0x1538
	dc.w 0x1560
	dc.w 0x158C
	dc.w 0x15B4
	dc.w 0x15D6
	dc.w 0x15FA
	dc.w 0x161E
	dc.w 0x1644
	dc.w 0x1670
	dc.w 0x169A
	dc.w 0x16BC
	dc.w 0x16E0
	dc.w 0x1704
	dc.w 0x172A
	dc.w 0x1750
	dc.w 0x1774
	dc.w 0x1790
	dc.w 0x17AC
	dc.w 0x17E0
	dc.w 0x1816
	dc.w 0x183A
	dc.w 0x185E
	dc.w 0x1882
	dc.w 0x18A6
	dc.w 0x18CE
	dc.w 0x18F4
	dc.w 0x1914
	dc.w 0x1944
	dc.w 0x1974
	dc.w 0x1994
	dc.w 0x19B0
	dc.w 0x19CA
	dc.w 0x19E4
	dc.w 0x1A00
	dc.w 0x1A1C
	dc.w 0x1A38
	dc.w 0x1A52
	dc.w 0x1A6C
	dc.w 0x1A86
	dc.w 0x1AA4
	dc.w 0x1AC2
	dc.w 0x1ADE
	dc.w 0x1AFA
	dc.w 0x1B16
	dc.w 0x1B32
	dc.w 0x1B4E
	dc.w 0x1B6C
	dc.w 0x1B8A
	dc.w 0x1BA6
	dc.w 0x1BC2
	dc.w 0x1BDC
	dc.w 0x1BF8
	dc.w 0x1C2C
	dc.w 0x1C60
	dc.w 0x1C70
	dc.w 0x1C80
	dc.w 0x1C90
	dc.w 0x1CA0
	dc.w 0x1CB2
