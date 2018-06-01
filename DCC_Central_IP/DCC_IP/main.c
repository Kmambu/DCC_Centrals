/*
 * main.c
 *
 *  Created on: May 23, 2018
 *      Author: kevin
 */

#include "xparameters.h"
#include "xgpio.h"
#include "DCC_IP.h"
#include <stdio.h>

#define DCC_BASEADDR XPAR_DCC_IP_0_S00_AXI_BASEADDR
#define IN 1
#define OUT 0
#define BTN_L 0x1
#define BTN_C 0x2
#define BTN_R 0x4

#define int_to_bitmap(n) 1U << (n - 1)

u32 bitmap_to_int(int n)
{
	if (n)
		return 1 + bitmap_to_int(n >> 1);
	return 0;
}

u32 read_switch(XGpio *sw)
{
	u32 sw_state;
	sw_state = XGpio_DiscreteRead(sw, 1);
	return bitmap_to_int(sw_state);
}

int main()
{
	XGpio sw, button;
	u32 dcc_functions[14] = {
			0x00004000, // stop
			0x00006300, // Step 3  Forward
			0x00007500, // Step 8  Forward
			0x00006800, // Step 13 Forward
			0x00004300, // Step 3  Backwards
			0x00005500, // Step 8  Backwards
			0x00004800, // Step 13 Backwards
			0x00009000, // Lumiere ON
			0x00008200, // Cor francais
			0x0000a100, // Ventilateur
			0x0000de01, // Annonce station francaise
			0x0000de04, // Signal alerte francaise
			0x0000de40, // Liberation des freins
			0x0000deb8  // Ferroviaire Clank
	};
	u32 DCC_Param_1, DCC_Param_2, DCC_Control;
	u32 btn_state, sw_state;
	u8 end, pressed_L, pressed_C, pressed_R;

	XGpio_Initialize(&button, XPAR_BUTTONS_DEVICE_ID);
	XGpio_Initialize(&sw, XPAR_SW_DEVICE_ID);
	XGpio_SetDataDirection(&sw, 1, IN);
	XGpio_SetDataDirection(&button, 1, IN);
	DCC_Param_1 = DCC_Param_2 = DCC_Control = 0;
	end = pressed_L = pressed_C = pressed_R = 0;
	while(!end) {
		DCC_Control = 0;
		sw_state = read_switch(&sw);
		btn_state = XGpio_DiscreteRead(&button, 1);
		switch (btn_state) {
		case BTN_L :
			DCC_Param_1 = sw_state;
			pressed_L = 1;
			while (pressed_L) {
				btn_state = XGpio_DiscreteRead(&button, 1);
				if (!(btn_state & BTN_L)) pressed_L = 0;
			}
			break;
		case BTN_R :
			DCC_Param_2 = dcc_functions[sw_state];
			pressed_R = 1;
			while (pressed_R) {
				btn_state = XGpio_DiscreteRead(&button, 1);
				if (!(btn_state & BTN_R)) pressed_R = 0;
			}
			break;
		case BTN_C :
			DCC_Control = 1;
			pressed_C = 1;
			while (pressed_C) {
				btn_state = XGpio_DiscreteRead(&button, 1);
				if (!(btn_state & BTN_C)) pressed_C = 0;
			}
			break;
		default :
			break;
		}

		DCC_IP_mWriteReg(DCC_BASEADDR, DCC_IP_S00_AXI_SLV_REG0_OFFSET,
				0x3);
		DCC_IP_mWriteReg(DCC_BASEADDR, DCC_IP_S00_AXI_SLV_REG1_OFFSET,
				0x75);
		DCC_IP_mWriteReg(DCC_BASEADDR, DCC_IP_S00_AXI_SLV_REG2_OFFSET,
				DCC_Control);
	}
	return 0;
}
