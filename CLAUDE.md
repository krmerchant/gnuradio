# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

GNU Radio uses CMake. Out-of-tree builds are required (in-tree builds are blocked):

```bash
# Configure and build
mkdir build && cd build
cmake ..
make -j$(nproc)

# Install
sudo make install

# Run tests
ctest
ctest -R <test_pattern>  # Run specific tests

# Run a single Python test directly
python -m pytest gr-blocks/python/blocks/qa_delay.py -v
```

## Code Formatting

- C++: Use clang-format with the `.clang-format` file at repo root
- Python: Follow PEP8
- CMake: Use cmake-format with `.cmake-format.py`

Run `clang-format -i <file>` to format C++ files.

## Architecture Overview

GNU Radio is a signal processing framework with C++ core and Python bindings.

### Core Components

- **gnuradio-runtime**: Core runtime library containing the scheduler, block base classes, PMT (Polymorphic Message Types), and flowgraph infrastructure
- **grc**: GNU Radio Companion - graphical flowgraph editor (GTK GUI in `grc/gui/`, Qt GUI in `grc/gui_qt/`)
- **gr-utils/modtool**: Tool for creating and managing out-of-tree modules

### Signal Processing Modules (gr-*)

Each `gr-*` directory is a component with consistent structure:
- `include/gnuradio/<module>/`: Public C++ headers
- `lib/`: C++ implementation (`*_impl.cc` files)
- `python/<module>/`: Python module and bindings
- `python/<module>/bindings/`: pybind11 bindings
- `grc/`: GRC block definitions (`.block.yml` files)
- `examples/`: Example flowgraphs

Key modules: gr-blocks (basic ops), gr-analog (signal sources/sinks), gr-digital (modulation/demod), gr-filter, gr-fft, gr-qtgui (Qt visualizations), gr-uhd (USRP hardware)

### Block Development Pattern

Blocks follow a consistent pattern:
1. Public header in `include/`: abstract class with `static sptr make(...)` factory
2. Implementation in `lib/`: `*_impl.h` and `*_impl.cc` with actual `work()` function
3. Python bindings in `python/<module>/bindings/`
4. GRC definition in `grc/<block>.block.yml`

Base classes: `gr::block`, `gr::sync_block`, `gr::sync_decimator`, `gr::sync_interpolator`, `gr::tagged_stream_block`

### Key Concepts

- **Flowgraph**: Directed graph of blocks connected via streams
- **work() function**: Where signal processing happens; processes items from input to output buffers
- **Tags**: Metadata attached to stream items for synchronization
- **Message passing**: Asynchronous communication between blocks via PMT

## Commit Message Convention

Use component prefix: `runtime:`, `blocks:`, `digital:`, `grc:`, `qtgui:`, etc.

Sign commits with DCO: `git commit -s`
