# Vectrex for Analogue Pocket

Vectrex for Analogue Pocket by Obsidian-dot-dev.

+ Based on Dar's FPGA Vectrex core [Dar](https://darfpga.blogspot.com/)
+ Based on the [Port to MiSTer by Sorgelig](https://github.com/MiSTer-devel/Vectrex_MiSTer)
+ Template code based on the Analogue Pocket port of Asteroids by [ericlewis](https://github.com/ericlewis/openfpga-asteroids)

## Supported

+ High-resolution 540x720 display for super crisp lines at perfect 2x integer scaling.
+ Screen overlays!
+ Auto-loading of overlays.
+ Variable beam "persistence" setting.  Lower values are less flickery, but more blurry.  Higher values are sharper but more flickery.
+ Selectable "overburn" setting to simulate the bright points that occur at the "Vertices" of lines drawn by the beam scanner.  Note that the rest of the line becomes dimmer when this is enabled.
+ Button remapping.
+ Analog controls on gamepads when docked.
+ Audio low-pass filter to approximate the frequency response of the 3" speaker in the original console

## Known Issues

+ Color mode and external peripherals are not currently supported.
+ Some games require analog controls; these are only playable in dock with a compatible joystick.

## Release Notes

0.9.3
+ Added audio low-pass filter at 5kHz to approximate the response of the 3" speaker in the original console.
+ Moved cart loading to SRAM.
+ Removed built-in BIOS, BIOS is now loaded from "vectrex.bin".
+ Moved the existing 2021 No-Intro .json's to the "2021 Romset" folder.
+ Added 2024 No-Intro .json's to the "2024 Romset" folder.
+ Increased vector dynamic range to 6 bits from 5 bits for slightly improved image quality.

0.9.2:
+ When manually loading games, overlays are no longer required to start the core.  Overlays can still be selected from the UI.

0.9.1:
+ Added .json instance files for auto-loading of games + overlays
+ Added support for analog joysticks when docked.
+ Fixed SDRAM refresh when overlays are disabled.

0.9.0:
+ Initial release

## Auto-loading Overlays

This core now uses `.json` instance files to simultaneous load ROMs along with their corresponding overlays.  A set of `.json` files for the officially released games + prototypes is provided for reference.

Within the `<instance>.json` files:
+ The `.vec` entries correspond to the filenames of ROMs as they appear in the Vectrex "No-Intro" romset.
+ The `.ovr` entries correspond to the filenames of overlays as they appear in the MiSTeR "overlays.zip" archive.

Additional auto-load entries can be added by replacing the filenames of the `.vec` and `.ovr` entries. 

## Manually selecting Roms and Overlays

A special `.json` instance file named `0 - Select ROM and Overlay.json` is provided, giving a user the ability to load a ROM and overlay file manually when the core is first started.  When selected, the file picker will prompt the user to select a ROM, followed by an overlay.  This effectively preserves the core's original behavior.

Once the core is running, ROMs and Overlay files can be loaded independently via the "Load Game" and "Load Overlay" core options.

## ROMs + Overlays

ROM files are not included with this core.

ROMs in the standard `.vec` format are supported.  These can be placed in the standard `assets/vectrex/common` folder.

Where available, this core uses `.ovr` overlays in the same format as MiSTer.  Please copy the overlays assets from that package, and put them in `assets/vectrex/common/overlays`.   

These overlays are not included in this repo, but you can find a complete copy of compatible assets in the `overlays.zip` archive located in [MiSTer's Vectrex repo's overlay directory](https://github.com/MiSTer-devel/Vectrex_MiSTer/tree/master/overlays)

## Compatibility

All 22 of the original 28 games not requiring 3d imager or light-pen have been tested as working.  Many popular homebrew titles also run correctly on this core.  Overall performance and compatibility should match the MiSTeR version.

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
