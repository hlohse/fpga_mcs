/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/fel/Desktop/mcs/rtl/cxgen_tb.vhd";



static void work_a_1121169477_2372691052_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    int64 t8;

LAB0:    t1 = (t0 + 1952U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(89, ng0);
    t2 = (t0 + 2304);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(90, ng0);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 1852);
    xsi_process_wait(t2, t8);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(91, ng0);
    t2 = (t0 + 2304);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(92, ng0);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 1852);
    xsi_process_wait(t2, t8);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    goto LAB2;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

}

static void work_a_1121169477_2372691052_p_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    int64 t8;
    char *t9;
    char *t10;
    unsigned char t11;
    unsigned int t12;
    unsigned char t13;

LAB0:    t1 = (t0 + 2088U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(100, ng0);
    t2 = (t0 + 2340);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(101, ng0);
    t7 = (100 * 1000LL);
    t2 = (t0 + 1988);
    xsi_process_wait(t2, t7);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(102, ng0);
    t2 = (t0 + 2340);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(103, ng0);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 * 10);
    t2 = (t0 + 1988);
    xsi_process_wait(t2, t8);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    xsi_set_current_line(107, ng0);
    t2 = (t0 + 4296);
    t4 = (t0 + 2376);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t9 = (t6 + 32U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 32U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(108, ng0);
    t2 = (t0 + 4328);
    t4 = (t0 + 2412);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t9 = (t6 + 32U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 32U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(109, ng0);
    t2 = (t0 + 2448);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(110, ng0);
    t2 = (t0 + 2484);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(112, ng0);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (1 * t7);
    t2 = (t0 + 1988);
    xsi_process_wait(t2, t8);

LAB14:    *((char **)t1) = &&LAB15;
    goto LAB1;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

LAB12:    xsi_set_current_line(113, ng0);
    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    t2 = (t0 + 4360);
    t11 = 1;
    if (32U == 32U)
        goto LAB18;

LAB19:    t11 = 0;

LAB20:    if (t11 == 0)
        goto LAB16;

LAB17:    xsi_set_current_line(114, ng0);
    t2 = (t0 + 1236U);
    t3 = *((char **)t2);
    t11 = *((unsigned char *)t3);
    t13 = (t11 == (unsigned char)2);
    if (t13 == 0)
        goto LAB24;

LAB25:    xsi_set_current_line(116, ng0);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (11 * t7);
    t2 = (t0 + 1988);
    xsi_process_wait(t2, t8);

LAB28:    *((char **)t1) = &&LAB29;
    goto LAB1;

LAB13:    goto LAB12;

LAB15:    goto LAB13;

LAB16:    t9 = (t0 + 4392);
    xsi_report(t9, 27U, 2);
    goto LAB17;

LAB18:    t12 = 0;

LAB21:    if (t12 < 32U)
        goto LAB22;
    else
        goto LAB20;

LAB22:    t5 = (t3 + t12);
    t6 = (t2 + t12);
    if (*((unsigned char *)t5) != *((unsigned char *)t6))
        goto LAB19;

LAB23:    t12 = (t12 + 1);
    goto LAB21;

LAB24:    t2 = (t0 + 4419);
    xsi_report(t2, 34U, 2);
    goto LAB25;

LAB26:    xsi_set_current_line(117, ng0);
    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    t2 = (t0 + 4453);
    t11 = 1;
    if (32U == 32U)
        goto LAB32;

LAB33:    t11 = 0;

LAB34:    if (t11 == 0)
        goto LAB30;

LAB31:    xsi_set_current_line(118, ng0);
    t2 = (t0 + 1236U);
    t3 = *((char **)t2);
    t11 = *((unsigned char *)t3);
    t13 = (t11 == (unsigned char)2);
    if (t13 == 0)
        goto LAB38;

LAB39:    xsi_set_current_line(120, ng0);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (1 * t7);
    t2 = (t0 + 1988);
    xsi_process_wait(t2, t8);

LAB42:    *((char **)t1) = &&LAB43;
    goto LAB1;

LAB27:    goto LAB26;

LAB29:    goto LAB27;

LAB30:    t9 = (t0 + 4485);
    xsi_report(t9, 29U, 2);
    goto LAB31;

LAB32:    t12 = 0;

LAB35:    if (t12 < 32U)
        goto LAB36;
    else
        goto LAB34;

LAB36:    t5 = (t3 + t12);
    t6 = (t2 + t12);
    if (*((unsigned char *)t5) != *((unsigned char *)t6))
        goto LAB33;

LAB37:    t12 = (t12 + 1);
    goto LAB35;

LAB38:    t2 = (t0 + 4514);
    xsi_report(t2, 36U, 2);
    goto LAB39;

LAB40:    xsi_set_current_line(121, ng0);
    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    t2 = (t0 + 4550);
    t11 = 1;
    if (32U == 32U)
        goto LAB46;

LAB47:    t11 = 0;

LAB48:    if (t11 == 0)
        goto LAB44;

LAB45:    xsi_set_current_line(122, ng0);
    t2 = (t0 + 1236U);
    t3 = *((char **)t2);
    t11 = *((unsigned char *)t3);
    t13 = (t11 == (unsigned char)3);
    if (t13 == 0)
        goto LAB52;

LAB53:    xsi_set_current_line(124, ng0);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (1 * t7);
    t2 = (t0 + 1988);
    xsi_process_wait(t2, t8);

LAB56:    *((char **)t1) = &&LAB57;
    goto LAB1;

LAB41:    goto LAB40;

LAB43:    goto LAB41;

LAB44:    t9 = (t0 + 4582);
    xsi_report(t9, 31U, 2);
    goto LAB45;

LAB46:    t12 = 0;

LAB49:    if (t12 < 32U)
        goto LAB50;
    else
        goto LAB48;

LAB50:    t5 = (t3 + t12);
    t6 = (t2 + t12);
    if (*((unsigned char *)t5) != *((unsigned char *)t6))
        goto LAB47;

LAB51:    t12 = (t12 + 1);
    goto LAB49;

LAB52:    t2 = (t0 + 4613);
    xsi_report(t2, 35U, 2);
    goto LAB53;

LAB54:    xsi_set_current_line(125, ng0);
    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    t2 = (t0 + 4648);
    t11 = 1;
    if (32U == 32U)
        goto LAB60;

LAB61:    t11 = 0;

LAB62:    if (t11 == 0)
        goto LAB58;

LAB59:    xsi_set_current_line(126, ng0);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (1 * t7);
    t2 = (t0 + 1988);
    xsi_process_wait(t2, t8);

LAB68:    *((char **)t1) = &&LAB69;
    goto LAB1;

LAB55:    goto LAB54;

LAB57:    goto LAB55;

LAB58:    t9 = (t0 + 4680);
    xsi_report(t9, 33U, 2);
    goto LAB59;

LAB60:    t12 = 0;

LAB63:    if (t12 < 32U)
        goto LAB64;
    else
        goto LAB62;

LAB64:    t5 = (t3 + t12);
    t6 = (t2 + t12);
    if (*((unsigned char *)t5) != *((unsigned char *)t6))
        goto LAB61;

LAB65:    t12 = (t12 + 1);
    goto LAB63;

LAB66:    xsi_set_current_line(127, ng0);
    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    t2 = (t0 + 4713);
    t11 = 1;
    if (32U == 32U)
        goto LAB72;

LAB73:    t11 = 0;

LAB74:    if (t11 == 0)
        goto LAB70;

LAB71:    xsi_set_current_line(128, ng0);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (1 * t7);
    t2 = (t0 + 1988);
    xsi_process_wait(t2, t8);

LAB80:    *((char **)t1) = &&LAB81;
    goto LAB1;

LAB67:    goto LAB66;

LAB69:    goto LAB67;

LAB70:    t9 = (t0 + 4745);
    xsi_report(t9, 33U, 2);
    goto LAB71;

LAB72:    t12 = 0;

LAB75:    if (t12 < 32U)
        goto LAB76;
    else
        goto LAB74;

LAB76:    t5 = (t3 + t12);
    t6 = (t2 + t12);
    if (*((unsigned char *)t5) != *((unsigned char *)t6))
        goto LAB73;

LAB77:    t12 = (t12 + 1);
    goto LAB75;

LAB78:    xsi_set_current_line(129, ng0);
    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    t2 = (t0 + 4778);
    t11 = 1;
    if (32U == 32U)
        goto LAB84;

LAB85:    t11 = 0;

LAB86:    if (t11 == 0)
        goto LAB82;

LAB83:    xsi_set_current_line(130, ng0);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (1 * t7);
    t2 = (t0 + 1988);
    xsi_process_wait(t2, t8);

LAB92:    *((char **)t1) = &&LAB93;
    goto LAB1;

LAB79:    goto LAB78;

LAB81:    goto LAB79;

LAB82:    t9 = (t0 + 4810);
    xsi_report(t9, 33U, 2);
    goto LAB83;

LAB84:    t12 = 0;

LAB87:    if (t12 < 32U)
        goto LAB88;
    else
        goto LAB86;

LAB88:    t5 = (t3 + t12);
    t6 = (t2 + t12);
    if (*((unsigned char *)t5) != *((unsigned char *)t6))
        goto LAB85;

LAB89:    t12 = (t12 + 1);
    goto LAB87;

LAB90:    xsi_set_current_line(131, ng0);
    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    t2 = (t0 + 4843);
    t11 = 1;
    if (32U == 32U)
        goto LAB96;

LAB97:    t11 = 0;

LAB98:    if (t11 == 0)
        goto LAB94;

LAB95:    xsi_set_current_line(133, ng0);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (795 * t7);
    t2 = (t0 + 1988);
    xsi_process_wait(t2, t8);

LAB104:    *((char **)t1) = &&LAB105;
    goto LAB1;

LAB91:    goto LAB90;

LAB93:    goto LAB91;

LAB94:    t9 = (t0 + 4875);
    xsi_report(t9, 33U, 2);
    goto LAB95;

LAB96:    t12 = 0;

LAB99:    if (t12 < 32U)
        goto LAB100;
    else
        goto LAB98;

LAB100:    t5 = (t3 + t12);
    t6 = (t2 + t12);
    if (*((unsigned char *)t5) != *((unsigned char *)t6))
        goto LAB97;

LAB101:    t12 = (t12 + 1);
    goto LAB99;

LAB102:    xsi_set_current_line(134, ng0);
    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    t2 = (t0 + 4908);
    t11 = 1;
    if (32U == 32U)
        goto LAB108;

LAB109:    t11 = 0;

LAB110:    if (t11 == 0)
        goto LAB106;

LAB107:    xsi_set_current_line(135, ng0);
    t2 = (t0 + 1408U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (1 * t7);
    t2 = (t0 + 1988);
    xsi_process_wait(t2, t8);

LAB116:    *((char **)t1) = &&LAB117;
    goto LAB1;

LAB103:    goto LAB102;

LAB105:    goto LAB103;

LAB106:    t9 = (t0 + 4940);
    xsi_report(t9, 35U, 2);
    goto LAB107;

LAB108:    t12 = 0;

LAB111:    if (t12 < 32U)
        goto LAB112;
    else
        goto LAB110;

LAB112:    t5 = (t3 + t12);
    t6 = (t2 + t12);
    if (*((unsigned char *)t5) != *((unsigned char *)t6))
        goto LAB109;

LAB113:    t12 = (t12 + 1);
    goto LAB111;

LAB114:    xsi_set_current_line(136, ng0);
    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    t2 = (t0 + 4975);
    t11 = 1;
    if (32U == 32U)
        goto LAB120;

LAB121:    t11 = 0;

LAB122:    if (t11 == 0)
        goto LAB118;

LAB119:    xsi_set_current_line(137, ng0);
    t2 = (t0 + 1236U);
    t3 = *((char **)t2);
    t11 = *((unsigned char *)t3);
    t13 = (t11 == (unsigned char)2);
    if (t13 == 0)
        goto LAB126;

LAB127:    xsi_set_current_line(139, ng0);

LAB130:    *((char **)t1) = &&LAB131;
    goto LAB1;

LAB115:    goto LAB114;

LAB117:    goto LAB115;

LAB118:    t9 = (t0 + 5007);
    xsi_report(t9, 30U, 2);
    goto LAB119;

LAB120:    t12 = 0;

LAB123:    if (t12 < 32U)
        goto LAB124;
    else
        goto LAB122;

LAB124:    t5 = (t3 + t12);
    t6 = (t2 + t12);
    if (*((unsigned char *)t5) != *((unsigned char *)t6))
        goto LAB121;

LAB125:    t12 = (t12 + 1);
    goto LAB123;

LAB126:    t2 = (t0 + 5037);
    xsi_report(t2, 37U, 2);
    goto LAB127;

LAB128:    goto LAB2;

LAB129:    goto LAB128;

LAB131:    goto LAB129;

}


extern void work_a_1121169477_2372691052_init()
{
	static char *pe[] = {(void *)work_a_1121169477_2372691052_p_0,(void *)work_a_1121169477_2372691052_p_1};
	xsi_register_didat("work_a_1121169477_2372691052", "isim/cxgen_tb_isim_beh.exe.sim/work/a_1121169477_2372691052.didat");
	xsi_register_executes(pe);
}
