//------------------------------------------------------------------------------------//
// MIT License
//
// Copyright (c) 2022 José Luis Jiménez Arévalo
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//------------------------------------------------------------------------------------//

#include "terasic_os_includes.h"
#include "LCD_Lib.h"
#include "lcd_graphic.h"
#include "font.h"
#include "hps_0.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )




unsigned short *aluMap = NULL;
void *virtual_base;

void delayMs(int n);

int main() {

       char str_a[12];
       char str_b[12];
       char str_op[12];
       char str_r[12];

       char op = ' ';

	void *virtual_base;
	int fd;


	LCD_CANVAS LcdCanvas;


	// map the address space for the LED registers into user space so we can interact with them.
	// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );



	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}



	//printf("Can you see LCD?(CTRL+C to terminate this program)\r\n");
	printf("Graphic LCD Demo\r\n");

		LcdCanvas.Width = LCD_WIDTH;
		LcdCanvas.Height = LCD_HEIGHT;
		LcdCanvas.BitPerPixel = 1;
		LcdCanvas.FrameSize = LcdCanvas.Width * LcdCanvas.Height / 8;
		LcdCanvas.pFrame = (void *)malloc(LcdCanvas.FrameSize);

	if (LcdCanvas.pFrame == NULL){
			printf("failed to allocate lcd frame buffer\r\n");
	}else{


		LCDHW_Init(virtual_base);
		LCDHW_BackLight(true); // turn on LCD backlight

    LCD_Init();

    // clear screen
    DRAW_Clear(&LcdCanvas, LCD_WHITE);

		// demo grphic api
    DRAW_Rect(&LcdCanvas, 0,0, LcdCanvas.Width-1, LcdCanvas.Height-1, LCD_BLACK); // retangle
    DRAW_Circle(&LcdCanvas, 10, 10, 6, LCD_BLACK);
    DRAW_Circle(&LcdCanvas, LcdCanvas.Width-10, 10, 6, LCD_BLACK);
    DRAW_Circle(&LcdCanvas, LcdCanvas.Width-10, LcdCanvas.Height-10, 6, LCD_BLACK);
    DRAW_Circle(&LcdCanvas, 10, LcdCanvas.Height-10, 6, LCD_BLACK);

    //aluMap = (unsigned char *)(virtual_base + ALU_TOP_0_BASE);
    aluMap = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + ALU_AVALON_0_BASE) & ( unsigned long)( HW_REGS_MASK ) );

    printf("ALU addr: %p\n", aluMap);
    printf("alt_lw: %x\n", ALT_LWFPGASLVS_OFST);
    printf("alt_lw: %x\n", ALT_STM_OFST);
    printf("alt_lw: %x\n", ALU_AVALON_0_BASE);
    //delayMs(800);

    while (1) {

      //volatile unsigned short *a = (unsigned short*)(aluMap + 0x0);
      //volatile unsigned short *b = (unsigned short*)(aluMap + 0x01);
      //volatile unsigned short *opcode =(unsigned short*)(aluMap + 0x02);
      //volatile unsigned short *result = (unsigned short*)(aluMap + 0x03);
      unsigned short *local_alumap = NULL;
      unsigned short *a = NULL;
      unsigned short *b = NULL;
      unsigned short *opcode = NULL;
      unsigned short *result = NULL;
      unsigned short *status = NULL;

      printf("Hola\n");
      local_alumap = aluMap;
      a = local_alumap;
      printf("Hola\n");
      printf("a: %p\n", a);
      local_alumap++;
      b = local_alumap;
      printf("b: %p\n", b);
      local_alumap++;
      opcode = local_alumap;
      printf("opcode: %p\n", opcode);
      local_alumap++;
      result = local_alumap;
      printf("result: %p\n", result);
      local_alumap++;
      status = local_alumap;
      printf("status: %p\n", status);

      unsigned short data_a;
      unsigned short data_b;
      unsigned short data_r;
      unsigned short data_op;
      unsigned short data_status;

      data_a = *a;
      sprintf(str_a, "%d", data_a);
      printf("%s \n", str_a);
      data_b = *b;
      sprintf(str_b, "%d", data_b);
      printf("%s \n", str_b);
      data_op = *opcode;
      sprintf(str_op, "%d", data_op);
      printf("%s \n", str_op);
      data_r = *result;
      sprintf(str_r, "%d", data_r);
      printf("%s \n", str_r);

      data_status = *status;



      if(data_op == 11){
            op = '+';
      }else if(data_op == 12){
            op = '-';
      }else if(data_op == 13){
            op = 'x';
      }else if(data_op == 14){
            op = '/';
      }else{
            op = ' ';
      }
      // demo font

      DRAW_Clear(&LcdCanvas, LCD_WHITE);

      DRAW_PrintString(&LcdCanvas, 10, 5, "SoC Calculator", LCD_BLACK, &font_16x16);

      DRAW_PrintString(&LcdCanvas, 0, 25, str_a, LCD_BLACK, &font_16x16);

      DRAW_PrintChar(&LcdCanvas, 35, 25, op, LCD_BLACK, &font_16x16);

      DRAW_PrintString(&LcdCanvas, 50, 25, str_b, LCD_BLACK, &font_16x16);

      DRAW_PrintString(&LcdCanvas, 80, 25, "=", LCD_BLACK, &font_16x16);
      //DRAW_PrintString(&LcdCanvas, 40, 5+32, str_op, LCD_BLACK, &font_16x16);

      if(data_status == 1){
        DRAW_PrintString(&LcdCanvas,95, 25, str_r, LCD_BLACK, &font_16x16);
      } else {
        DRAW_PrintString(&LcdCanvas,95, 25, " ", LCD_BLACK, &font_16x16);
      }



      //delayMs(800);
      //DRAW_Clear(&LcdCanvas, LCD_WHITE);
      DRAW_Refresh(&LcdCanvas);

    }




    free(LcdCanvas.pFrame);
	}

	// clean up our memory mapping and exit

	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

	return( 0 );
}

void delayMs(int n) {
  int i;
  int j;
  for(i = 0 ; i < n; i++)
  for(j = 0 ; j < 7000; j++) { }
}
