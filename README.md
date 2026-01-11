# FPGA VGA Basketball Game (Basys-3, Artix-7)

A real-time pixel-based basketball game implemented entirely in hardware on the
Digilent Basys-3 FPGA development board using VHDL.

The project demonstrates VGA signal generation, hardware-based graphics rendering,
parabolic motion using integer physics, and board-level I/O integration
(switches, buttons, and 7-segment display).

---

## 🎯 Features

- 640×480 VGA output @ 60 Hz
- Hardware-generated VGA timing (no framebuffer)
- MASK-based object rendering architecture
- Basketball with parabolic motion (gravity)
- Player and basket rendering
- Switch-controlled throw angle and power
- Button-controlled throw initiation
- Score display on 7-segment display (multiplexed)
- Fully synthesizable VHDL
- Designed for Digilent Basys-3 (Xilinx Artix-7)

---

## 🧠 Architecture Overview

The system is divided into independent hardware blocks:

- **Clock Divider**: 100 MHz → 25 MHz VGA pixel clock
- **VGA Sync Generator**: Produces HSYNC, VSYNC, pixel coordinates
- **Game Logic**: Ball physics, collision detection, scoring
- **Shape Modules**: Stateless MASK-based graphics objects
- **Pixel Renderer**: Shape composition with priority
- **7-Segment Driver**: Multiplexed score display

Rendering is performed in a *streaming* manner:  
each pixel’s color is computed on-the-fly without using a framebuffer.

---

## 🧩 Rendering Model (Key Design Idea)

Each on-screen object is implemented as a reusable **shape module** that outputs:

- `MASK` – indicates whether the object occupies the current pixel
- `RGB` – object color

Shapes are composed using priority logic in the pixel renderer, similar to a
simple hardware sprite engine.

---

## 🕹️ Controls (Basys-3)

| Input | Function |
|-----|---------|
| `btnC` | Throw ball / Reset |
| `sw[3:0]` | Throw power |
| `sw[7:4]` | Throw angle |

---

## 🖥️ Outputs

| Output | Description |
|------|-------------|
| VGA | Basketball game display |
| 7-segment | Score display |

---

## 🛠️ Build Instructions (Vivado)

1. Open **Vivado**
2. Create a new RTL project
3. Add all `.vhd` files from `src/`
4. Add `constraints/basys3.xdc`
5. Set `top_basys3.vhd` as top module
6. Synthesize → Implement → Generate Bitstream
7. Program the Basys-3 board

---

## 📦 File Descriptions

| File | Description |
|----|-------------|
| `clk_div.vhd` | Clock divider for VGA |
| `vga_sync.vhd` | VGA timing generator |
| `game_logic.vhd` | Physics, scoring |
| `shape_rect.vhd` | Rectangular shape module |
| `shape_circle.vhd` | Circular shape module |
| `pixel_renderer.vhd` | Object composition |
| `seven_seg.vhd` | Score display |
| `top_basys3.vhd` | Top-level integration |

---

## 📚 Educational Value

This project demonstrates:

- Digital design for real-time systems
- VGA protocol implementation
- Modular hardware architecture
- Resource-aware FPGA design
- Board-level integration

---

## 📜 License

MIT License


## 📌 basys3.xdc (Reminder)

Include:
- VGA pins
- Clock pin (100 MHz)
- Button & switch pins
- 7-segment pins

(Use Digilent’s official Basys-3 Master XDC as base.)


## 🏷️ GitHub Tags
```nginx
fpga
vhdl
basys3
artix7
vga
digital-design
embedded-hardware
hardware-graphics
```
