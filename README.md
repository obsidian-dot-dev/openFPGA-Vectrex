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

## Phosphor Decay

When enabled, the "Phosphor Decay" option modifies pixel persistence behavior, giving a more natural and less "smudgy" appearance to the image.  This decay model stacks on-top of the decay provided by the persistence slider.  Because the two effects stack, a lower persistence value is recommended when this option is enabled.

## Audio Filter

To more accurately simulate the audio response of the original console, an optional 5kHz low-pass filter is provided.  This value was chosen to estimate the response of a 3" paper-cone driver like the one found in the Vectrex console.

Note: In looking at the original schematic, it appears the only audio filtering is provided by a 22kHz LPF network, applied before the signal is amplified by an LM386.  The impacts of either of these would be negligible relative to the frequency response of the speaker.

## BIOS

This core now relies on a BIOS ROM named `vectrex.bin` to be present in `Assets/vectrex/common`.  The core will fail to run without this dependency.

## ROMs and Overlays

ROM files are not included with this core.

ROMs in the standard `.vec` format are supported.  These can be placed in the standard `assets/vectrex/common` folder.

Where available, this core uses `.ovr` overlays in the same format as MiSTer.  Please copy the overlays assets from that package, and put them in `assets/vectrex/common/overlays`.   

These overlays are not included in this repo, but you can find a complete copy of compatible assets in the `overlays.zip` archive located in [MiSTer's Vectrex repo's overlay directory](https://github.com/MiSTer-devel/Vectrex_MiSTer/tree/master/overlays)

The use of overlay files is not required - users may manually select only a `.vec` file if desired.  Overlays can be swapped in-game by selecting the "Load Overlay" option in the interact menu.

## Auto-loading ROMs and Overlays via .json files

This core now uses `.json` instance files to simultaneous load ROMs along with their corresponding overlays.  Sets of `.json` files for the officially released games + prototypes are provided for reference images.

Two sets of auto-load json files are provided:
+ `0 - 2024 Romset` contains json data for the newet 2024 NoIntro images.
+ `0 - 2021 Romset` contains json data for the previous 2021 NoIntro images.

For the supported json data, it is expected that corresponding game data is stored under `Assets/vectrex/common/0 - 2021 Romset` or `Assets/vectrex/common/0 - 2024 Romset`, and the overlays are stored under `assets/vectrex/common/overlays`.

Within the `<instance>.json` files:
+ The `.vec` entries correspond to the filenames of ROMs as they appear in the Vectrex "No-Intro" romset.
+ The `.ovr` entries correspond to the filenames of overlays as they appear in the MiSTeR "overlays.zip" archive.

Additional auto-load entries can be added by replacing the filenames of the `.vec` and `.ovr` entries. 

## Compatibility

All 22 of the original 28 games not requiring 3d imager or light-pen have been tested as working.  Many popular homebrew titles also run correctly on this core.  Overall performance and compatibility should match the MiSTeR version.

## Release Notes

0.9.4:
+ Fix BIOS path.

0.9.3:
+ Added audio low-pass filter.
+ Moved cart loading to SRAM.
+ Removed built-in BIOS.
+ Moved the existing 2021 No-Intro .json's to the "0 - 2021 Romset" folder.
+ Added 2024 No-Intro .json's to the "0 - 2024 Romset" folder.
+ Increased vector dynamic range to 6 bits from 5 bits for slightly improved image quality.
+ Companding for improved dynamic-range.
+ Optional "Phosphor decay" mode that gives a less "smeary" persistence effect.
+ Persistence control now has 32 levels, with better granularity.
+ Roms can be loaded directly without requiring an overlay now.

0.9.2:
+ When manually loading games, overlays are no longer required to start the core.  Overlays can still be selected from the UI.

0.9.1:
+ Added .json instance files for auto-loading of games + overlays
+ Added support for analog joysticks when docked.
+ Fixed SDRAM refresh when overlays are disabled.

0.9.0:
+ Initial release

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
