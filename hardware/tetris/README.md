Welcome to my Tetris project!

- Implementing tetris logic to take inputs from a DE1-SoC FPGA board (Cyclone V from Altera) and visualizing the game with VGA display
- I think this has been (and will continue to be) a really fun project to work on. Working with VGA has been a great experience (and a struggle at the same time LOL) and I've learned a lot about working with other devices + following documentation as well as debugging code. Getting to implement tetris game logic with registers and an HDL has also been a really fun challenge, and I really enjoy getting to build something cool from really basic building blocks (once a Lego enjoyer always Lego enjoyer)
- I also really like this project because I feel like there will be a lot of ways to expand the project to increase the difficulty. Things like scoring system, speed increases with scores, queue with the pieces coming up, soft/hard drop (speeding up the piece to go down faster), holding + swapping (can hold a piece in storage and use later), and even fancier mechanics like wall kicks, T-spins, and other twist/spin moves.
- For a more detailed history of progress + errors, check out "project-log.txt"
- Some notes for VGA display notes, see "vga-notes.txt"

Currently working on:

- "tetris.sv", the logic and implementation of tetris
- "vga-test.sv", just a test file to get a display working on the display monitor

Current problems:

- VGA connection not displaying properly
  - Timings on the device are quite hard to find, a lot of sources don't agree on the numbers even for the same FPGA board
  - Using the DE1-SoC users manual also seems to not work, will try to find and consult some people who have worked with VGA

Next steps:

- Figure out how to connect an output from the tetris.sv module to display on VGA
- Look into testbench? .tb + how to use with .do files

Notes:

- A lot of small changes will not be reflected on the GitHub
  - For example, the .do files will be edited on the actual lab machines that I'm doing FPGA on, and will probably not be updated very often
  - Things that I write in my notes or SV files to try then delete within a work session probably won't be saved
  - Websites that I visit might be not written down (already happened, I need to try and find that file again...)
- I see some people doing a license or something(?) on their projects, if anyone wants to use this I give everyone free usage

Late updated:
October 4th, 2025
