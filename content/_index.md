+++
title = 'Foo'
date = 2023-12-09T12:25:45-05:00
draft = false
+++

## TL;DR

Build delightful games that use as little energy per second as possible in order to make games and computing more sustainable, and to discover new directions for software aesthetics.

## When

2024; precise dates TBD.

## What?

Watt-Wise is a challenge to build low-energy games. Entries will be judged both for the quality of their gameplay experience **and** for the average energy consumed per second of gameplay (using a hardware monitor between the computer and the power outlet).

## Why?

Computers and video games have an enormous carbon footprint [citation needed]. We can minimize the carbon footprint of running games on non-renewable power grids by using less power, but this is actually the lesser goal.

By focusing our jam on low energy use, we also target the ability for older hardware to run it. How? Well, the physics definition of "energy" is the "capacity to do work". If program X uses more energy on my computer than program Y, it's because it actually does more computation. There are differences in the efficiencies of certain tasks enabled by hardware, of course. GPUs make lots of 2D and 3D math vastly more efficient that pure-CPU approaches. However, we can compare two programs on the same hardware (while holding factors like clock speeds constant) to compare how much energy is required for them to function. The program using less energy does less work on that hardware, and is likelier to run better on even older hardware.

The end goal isn't just to build some great games, but to discover which techniques of game and software design are both beautiful and efficient, and to apply those lessons to software beyond video games.

## How?

We are developing both hardware and software estimation techniques for measuring energy consumption. Participants can use our open source power estimation tooling while developing their games to optimize for using less power.
When it's time to judge games, the community will rank their favorite games, and then the judges will play those games and measure their hardware consumption using a more precise hardware monitor. The game that strikes the best balance between fun gameplay and low energy consumption wins!

__Note:__ exact details of the judging process are still being worked out and are subject to change.

## FAQ

### What restrictions are there for submissions?

Games must:

- Support running on Linux (we will be measuring game power efficiency from a specialized Linux environment where we can eliminate background processing).
- Either include any runtime dependencies, or rely solely on open source onces. Examples:
    - Web browsers for web-based games ([Chromium](https://www.chromium.org/Home/), [Firefox](https://www.mozilla.org/en-US/firefox/new/), etc...)
    - Console emulators for real consoles ([PCSX2](https://pcsx2.net/), [Dolphin](https://dolphin-emu.org/), [mGBA](https://mgba.io/), etc...)
    - Fantasy consoles ([WASM4](https://wasm4.org/), [PICO-8](https://www.lexaloffle.com/pico-8.php), etc...)
    - Virtual machines ([UXN](https://100r.co/site/uxn.html), etc...)

### How do I make a game energy-efficient?

The simple answer is "make your game do less work," but there are many ways to go about that. Let's think about what your game does as it runs:

- Executes some state update each tick
- Draws a new frame of output per screen refresh

If we call your tick rate `T` and your frame rate `F`, we can model your energy cost per second as `T*<cost-of-tick> + F*<cost-of-drawing-frame>`.

The most obvious wins come from decreasing `T` and/or `F`, since they are static multipliers on the cost of running your game every second.

TODO: there's a lot more to say here. Check back later.
