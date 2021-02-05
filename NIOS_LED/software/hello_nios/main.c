#include "system.h"
#include "altera_avalon_pio_regs.h"

int main ()
{
    char leds = 0x1;
    int i = 0;
    while(1)
    {
        IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE, leds);
        for (i=0; i<(ALT_CPU_CPU_FREQ/500); i++);    // Delay
        // Johnson code counter on leds
        leds = ((leds<<1) & 0xE) | (!(leds>>3) & 0x1);
    }
    return 0;
}
