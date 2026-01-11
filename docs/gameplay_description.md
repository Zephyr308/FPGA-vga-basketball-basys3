# Gameplay Description – FPGA VGA Basketball Game

This document describes the gameplay mechanics, user interaction, and internal
hardware behavior of the FPGA-based VGA Basketball Game implemented on the
Digilent Basys-3 (Xilinx Artix-7).

The game is fully implemented in synthesizable VHDL and runs entirely in
hardware without a framebuffer or embedded processor.

---

## 1. Game Objective

The objective of the game is to score points by throwing a basketball into
a fixed hoop displayed on the VGA screen.

Each successful shot increments the score, which is displayed on the
Basys-3 7-segment display.

---

## 2. Screen Layout

The VGA display operates at **640×480 resolution (60 Hz)** and contains
the following static and dynamic elements:

### On-Screen Objects

| Object | Description |
|------|-------------|
| Player | Static rectangle located on the right side of the screen |
| Ball | Circular object launched from the player position |
| Hoop | Rectangular basket positioned on the left side |
| Background | Solid color background |

All objects are rendered using a MASK-based pixel rendering architecture.

---

## 3. User Controls

The game uses Basys-3 on-board switches and push buttons for input.

### Input Mapping

| Control | Function |
|-------|----------|
| `btnC` | Initiates ball throw / resets ball state |
| `sw[3:0]` | Controls throw power (horizontal velocity magnitude) |
| `sw[7:4]` | Controls throw angle (vertical velocity component) |

Switch inputs are sampled at the moment the throw button is pressed.

---

## 4. Throw Mechanism

When the user presses the throw button:

1. The ball is positioned at the player’s hand
2. Horizontal (`vx`) and vertical (`vy`) velocities are loaded based on switch values
3. Gravity is enabled
4. The ball enters the **FLYING** state

The ball remains in motion until it either:
- Enters the hoop (successful score)
- Falls below the bottom of the screen (miss)

---

## 5. Ball Physics Model

The ball follows a **discrete-time parabolic trajectory** implemented in hardware.

### Position Update

At each physics tick:
```yaml
x ← x + vx
y ← y + vy
vy ← vy + gravity
```

- Horizontal velocity remains constant
- Vertical velocity is incremented by a constant gravity value
- All arithmetic uses integers for FPGA compatibility

Physics updates are clock-enabled at a reduced rate relative to the pixel clock
to provide visually smooth motion.

---

## 6. Collision Detection

### Hoop Detection

A successful shot is detected when the ball’s center enters the hoop region:

- X coordinate within hoop horizontal bounds
- Y coordinate within hoop vertical bounds

On detection:
- Score is incremented
- Ball state is reset to the player position

### Miss Detection

If the ball’s Y coordinate exceeds the bottom of the visible area:
- The shot is considered a miss
- Ball is reset without incrementing the score

---

## 7. Scoring System

- Each successful basket increments the score by **1**
- The score is stored in a register inside the game logic module
- The score value is continuously displayed on the Basys-3 7-segment display

### 7-Segment Display

- Multiplexed 4-digit display
- Displays score in decimal format
- Driven by a dedicated display controller module

---

## 8. Rendering Pipeline

Rendering is performed on a **per-pixel basis** without using video memory.

### Rendering Steps per Pixel

1. VGA timing module provides `(X, Y)` pixel coordinates
2. Each shape module evaluates whether it occupies `(X, Y)`
3. Shape MASK signals are evaluated by priority
4. The RGB value of the highest-priority shape is selected
5. Final RGB output is sent to the VGA DAC

### Rendering Priority (Top → Bottom)

1. Ball
2. Hoop
3. Player
4. Background

This ensures that the ball appears in front of all other objects.

---

## 9. Shape Abstraction

Each object is implemented as an independent shape module with the following interface:

```vhdl
X, Y   : in  unsigned(10 downto 0);
RGB    : out std_logic_vector(11 downto 0);
MASK   : out std_logic;
```
This abstraction enables:
- Reusable graphics logic
- Clean object composition
- Easy expansion for future features

## 10. Reset Behavior

On system reset:
- Ball position is reset to player location
- Score is cleared to zero
- Ball state returns to IDLE

The system begins in a ready-to-play state.

## 11. Design Constraints
- Fully synthesizable VHDL
- No embedded processor
- No framebuffer or RAM usage
- Real-time rendering using combinational logic
- Designed specifically for the Basys-3 FPGA

## 12. Possible Extensions

Future improvements could include:
- Moving hoop
- Wind effect
- Multiple shot types
- Sound effects via PWM
- Animation for player movement

 ## 13. Summary

This project demonstrates a complete real-time game implemented purely in FPGA
hardware, combining VGA graphics, physics modeling, user input handling,
and score display in a modular and scalable design.
