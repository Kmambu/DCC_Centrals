# DCC_Centrals
Developped by Kevin Mambu

# What is DCC_Centrals?
The main objective of the project was to devellop a hardware architecture of a DCC Packet Generator, which would be able to send encoded DCC commands to model trains. [More information about the DCC protocol and its uses](https://en.wikipedia.org/wiki/Digital_Command_Control)
Our hardware implementation is developped in two versions :
* A pure hardware description, using VHDL
* An IP module inplementation, using a Microblaze architecture. The Microblaze is a softcore processor (which internal architecture doesn't actually exist, it is only described using HDLs).

# Validity of the project
Our teacher validated our design at the end of the term using a Nexys4DDR FPGA card.
