+++
title = 'Watt-Wise Game Jam'
date = 2023-12-09T12:25:45-05:00
draft = false
+++

## TL;DR

Build delightful games that use as little energy per second as possible in order to make games and computing more sustainable, and to discover new directions for software aesthetics.

## When

- **Submission**: March 22nd 2024 - April 22nd 2024
- **Evaluation**: April 23rd 2024 - April 28th 2024

## What?

Watt-Wise is a challenge to build low-energy games. Entries will be judged both for the quality of their gameplay experience **and** for the average energy consumed per second of gameplay (using a hardware monitor between the computer and the power outlet).

## Why?

Computers and video games have an enormous carbon footprint
<sup><a href="https://www.sciencedaily.com/releases/2021/09/210910121715.htm">1</a></sup>
<sup><a href="https://gtg.benabraham.net/can-we-put-a-number-on-the-game-industrys-annual-climate-footprint-part-1-game-development/">2</a></sup>
<sup><a href="https://news.mit.edu/2022/how-can-we-reduce-carbon-footprint-global-computing-0428">3</a></sup>.
We can minimize the carbon footprint of running games on non-renewable power grids by using less power, but this is actually the lesser goal.

By focusing our jam on low energy use, we also target the ability for older hardware to run it. How? Well, the physics definition of "energy" is the "capacity to do work". If program X uses more energy on my computer than program Y, it's because it actually does more computation. There are differences in the efficiencies of certain tasks enabled by hardware, of course. GPUs make lots of 2D and 3D math vastly more efficient that pure-CPU approaches. However, we can compare two programs on the same hardware (while holding factors like clock speeds constant) to compare how much energy is required for them to function. The program using less energy does less work on that hardware, and is likelier to run better on even older hardware.

The end goal isn't just to build some great games, but to discover which techniques of game and software design are both beautiful and efficient, and to apply those lessons to software beyond video games.

## How?

We are developing both hardware and software estimation techniques for measuring energy consumption. Participants can use our [open source power estimation tooling](https://github.com/wattwisegames/watt-wiser) while developing their games to optimize for using less power.
When it's time to judge games, the community will rank their favorite games, and then the judges will play those games and measure their hardware consumption using a more precise hardware monitor. The games that strike the best balance between fun gameplay and low energy consumption win!

You can find an explanation of the scoring rubric used to evaluate games [here](https://docs.google.com/document/d/1mHvB7PRph3zuOjNGy6VVAf8R_rcOzCOItSG3lyIKfW8/edit?usp=sharing).

## FAQ

### How do I join?

Join one of our online communities to get the latest news, discuss game ideas, find collaborators, and more. Join us on [Itch.io](https://itch.io/jam/watt-wise-game-jam) and [Discord](https://discord.gg/CCf27aJbYw) or [IRC](ircs://irc.libera.chat/#wattwise.games) to get involved.

### Can teams participate, or only solo game developers?

Teams are welcome!

### Can I submit an existing game, or does it need to be a new one?

We will accept two categories of submission:

- **From Scratch**: games built during the jam. These can incorporate pre-existing code, but the gameplay experience itself should be crafted during the jam.
- **Optimized**: games that existed before the jam, but were optimized for energy efficiency during the jam.

We'll evaluate the two categories separately and recognize excellence within each category. That way optimized games are only compared against other optimized games, and new games are only compared against other new games.

### What restrictions are there for submissions?

Games must:

- Be Safe-For-Work (like the ESRB Teen rating or below).
- Support running on Linux (we will be measuring game power efficiency from a specialized Linux environment where we can eliminate background processing).
- Either include any runtime dependencies, or rely solely on open source ones. Examples:
    - Web browsers for web-based games ([Chromium](https://www.chromium.org/Home/), [Firefox](https://www.mozilla.org/en-US/firefox/new/), etc...)
    - Console emulators for real consoles ([PCSX2](https://pcsx2.net/), [Dolphin](https://dolphin-emu.org/), [mGBA](https://mgba.io/), etc...)
    - Fantasy consoles ([WASM4](https://wasm4.org/), [TIC-80](https://tic80.com/), etc...)
    - Virtual machines ([UXN](https://100r.co/site/uxn.html), etc...)

### How do I make a game energy-efficient?

The simple answer is "make your game do less work," but there are many ways to go about that. Let's think about what your game does as it runs:

- Executes some state update each tick
- Draws a new frame of output per screen refresh

If we call your tick rate
<code>tps</code>
and your frame rate
<code>fps</code>,
and we call the cost of one tick and one frame
<code>C<sub>t</sub></code>
and
<code>C<sub>f</sub></code>
respectively, we can model your energy cost per second as:

<code>tps * C<sub>t</sub> + fps * C<sub>f</sub></code>.

The most obvious wins come from decreasing
<code>tps</code>
and/or
<code>fps</code>,
since they are static multipliers on the cost of running your game every second.

#### TPS and FPS Optimizations

In your game, you may be able to update some sub-states of your game world (physics, AI, networking, etc...) far less often than others. This lets you save work per-tick. There's a delicate balance here, espcially for physics-based games, but doing fewer game ticks saves energy.

- **Try running your physics (or other sub-system) tick loop slower than your frame loop.** For some games, 10TPS (or even 1TPS) may be sufficient. It all depends upon what kinds of interaction your player has with the game, and how quickly the game needs to react.
- **Explore input-driven tick processing.** For games that are driven primarily by user input, see if you can architect your update loop to not run unless the user gave input. Allowing this part of your game engine to sleep when it isn't needed saves a lot of work.

For FPS, a number of optimizations are available:

- **Find ways to put your render loop to sleep.** When your game is idle, you don't need to continously redraw. Figure out how to slow down rendering in your chosen tech stack and take advantage of this in menus and when the player seems AFK.
- **Render fewer FPS in menus and full-screen overlays.** The inventory page probably doesn't need the same FPS as the main game, so slow down the render loop when displaying it.
- **Target a lower frame rate.** It is not a crime to develop a game for 30FPS, even if the available display supports higher. You can do far, far less work per second across your game's runtime by doing so.

#### Cost of Tick Optimizations

However, there's a limit to how much you can decrease these while keeping your game feeling pleasant and interactive. Instead, let's focus on optimizing
<math><msub><mi>C</mi><mn>t</mn></msub></math>
and
<math><msub><mi>C</mi><mn>f</mn></msub></math>.

<math><msub><mi>C</mi><mn>t</mn></msub></math> is the cost of updating the state of your game. Depending on what kind of game you are building, there are many different things you could be doing. However, the best way to decrease this cost factor is always the same: make thoughtful choices about how much of work your game needs to do in order to be fun. If your game keeps track of physical objects, carefull consider how many of them you really need and how realistic their physical behavior needs to be.

Also, stop updating your world state when the player can't see it anyway, like when they're looking at a menu.

#### Cost of Frame Optimizations

<math><msub><mi>C</mi><mn>f</mn></msub></math> is the cost of drawing one frame. Here, we can consider many ways of doing less work that are relevant for many games:

- **Draw to a smaller output resolution.** Your game has to do work to render every pixel. Decreasing the output resolution and embracing the resulting pixelation decreases the work you do per frame quadratically. Consider the difference between rendering frames at 4K and 1080p. 4K displays have a resolution of
3,840&times;2,160&equals;8,294,400px,
whereas 1080p displays have a resolution of
1,920&times;1,080&equals;2,073,600px
(&frac14; the pixels). Thus, scaling down your render framebuffer by half results in doing one quarter the work. Even if you later upscale the rendered frame to the size of the monitor, rendering to the smaller framebuffer first saves a lot of work. This is the factor on which the smallest change has the biggest impact.
- **Draw with lower color depth.** The representation you use for color impacts how expensive it is to build frames. Smaller color representations allow more pixels worth of color to be fetched from VRAM at once (and more to reside in the same cache lines), leading to more overall efficient rendering. Switching your game to monochrome color (from 32-bit RGBA to 8-bit monochrome) leads to a 4x reduction in data per pixel. You can even explore going down to 1-bit color and the wild and wonderful world of [ditherpunk](https://surma.dev/things/ditherpunk/). This allows you to render entirely in [bit-blit](https://en.wikipedia.org/wiki/Bit_blit) operations, and is **very** fast.
- **Draw simpler geometry.** Another major part of your game (2D or 3D) is always going to be drawing individual game objects. Using fewer and simpler objects does less work. It's as simple as that. Think hard about what your game actually needs to display.

Some games may be able to combine many of these optimizations to great effect.

TODO: there's a lot more to say here. Check back later.
