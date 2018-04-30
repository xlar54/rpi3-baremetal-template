# rpi3-baremetal-template

This is a simple template for baremetal C programming for Raspberry Pi 3.

## Multi-core

Each core can run its own program.
The source code has to provide `main0`, `main1`, `main2`, `main3` functions as shown in `apps/main.c`.
They will run respectively on cores 0, 1, 2 and 3.

## Directories

 - `app`: contains the app code.
 - `core`: contains some assembly code, starting code and interrupt vector.
 - `drivers`: provides a handful of simple but uncomplete drivers.

## Backward compatibility with RPI 1 mod B+

The current version of the makefile does use the same object file names for RPI 3 and RPI 1.
To make sure that there is no remaining object file from RPI 3, a cleanup command is necessary, then you can build the kernel image by setting `RPI1` when invoking makefile:
```
make clean
make RPI1=1
```
The output image will be named `kernel.img`, so it can be directly copied onto the SD card.
