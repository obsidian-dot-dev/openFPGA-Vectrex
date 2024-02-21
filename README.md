# Vectrex for Analogue Pocket

Vectrex for Analogue Pocket by Obsidian-dot-dev

+ Port of the FPGA Vectrex implementation by [Dar](https://darfpga.blogspot.com/)
+ Based on the [Port to MiSTer by Sorgelig](https://github.com/MiSTer-devel/Vectrex_MiSTer)
+ Template code based on the Analogue Pocket port of Asteroids by [ericlewis](https://github.com/ericlewis/openfpga-asteroids)

Note:  *This core is currently in BETA*.  
If you encounter issues, it's likely with my porting/integration work, and not with the original core itself.  Please file tickets on the github tracker, and I will look at them.

## Supported

+ High-resolution 540x720 display for super crisp lines at perfect 2x integer scaling.
+ Screen overlays!
+ Variable beam "persistence" setting.
+ Selectable "overburn" setting to simulate the bright points that occur at the "Vertices" of lines drawn by the beam scanner.  Note that the rest of the line becomes dimmer when this is enabled.
+ Button remapping.

## Known Issues

+ Color mode and external peripherals are not currently supported.
+ Games requiring analog controls don't play well with the dpad.

## Release Notes

0.9.0:
+ Initial release

## ROM Instructions

ROM files are not included.  ROMs in the standard `.vec` format are supported by the core.  These can be placed in the standard `Assets/vectrex/common` folder.

## Overlays

This core requires `.ovr` overlays in the same format as MiSTer.  Please copy the overlays assets from that package, and put them in `Assets/vectrex/common`.   These overlays aren't included in the release, but you can find a complete copy in the MiSTer repo listed above.

Just like in Real Life, the core lets you choose different overlays from the game you wanted to play for fun.  When starting a game, the core will also prompt you to choose a new overlay as well.

## Compatibility

All 22 of the original 28 games not requiring 3d imager or light-pen have been tested as working.  Homebrew/color roms have not been tested, but should behave as on MiSTer.

## Attribution

```
---------------------------------------------------------------------------------
-- Vectrex by Dar (darfpga@aol.fr) (27/12/2017)
-- http://darfpga.blogspot.fr
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- SP0256-al2 prom decoding scheme and speech synthesis algorithm are from :
--
-- Copyright Joseph Zbiciak, all rights reserved.
-- Copyright tim lindner, all rights reserved.
--
-- See C source code and license in sp0256.c from MAME source
--
-- VHDL code is by Dar.
---------------------------------------------------------------------------------
-- gen_ram.vhd & io_ps2_keyboard
-- Copyright 2005-2008 by Peter Wendrich (pwsoft@syntiac.com)
-- http://www.syntiac.com/fpga64.html
---------------------------------------------------------------------------------
-- VIA m6522
-- Copyright (c) MikeJ - March 2003
-- + modification
---------------------------------------------------------------------------------
-- YM2149 (AY-3-8910)
-- Copyright (c) MikeJ - Jan 2005
---------------------------------------------------------------------------------
-- cpu09l_128
-- Copyright (C) 2003 - 2010 John Kent
-- + modification
```