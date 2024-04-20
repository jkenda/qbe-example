ENTRY(_start)

MEMORY
{
  ram (rx) : ORIGIN = 0x4000b0, LENGTH = 0x1000
}

SECTIONS
{
  . = 0x400000;
  .text : { *(.text) } >ram
  .data : { *(.data) } >ram

  /DISCARD/ : { *(*) }
}
