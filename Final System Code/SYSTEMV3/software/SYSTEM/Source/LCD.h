/*
 * FILE: 				main.c
 * AUTHOR:				Ian HUA
 * DATE LAST MODIFIED:	9 October 2015
 *
 * DESCRIPTION:			LCD Control
 *
 *						Write:
 *						CMD to Register 0 @ Base
 *						DATA to Register 2 @ Base
 *
 *						Read:
 *						CMD from Register 1 @ Base
 *						DATA from Register 3 @ Base
 *
 */


#ifndef   __LCD_H__
#define   __LCD_H__

//===============================
// LCD Base Address
//===============================
volatile int *LCD;

//===============================
// LCD Control Functions
//===============================
void  LCD_Init();
void  LCD_LineSel(int line);
void  LCD_Display(char* text, int line);

#endif
