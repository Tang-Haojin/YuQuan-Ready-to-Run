
kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	84010113          	addi	sp,sp,-1984 # 80009840 <stack0>
    80000008:	00001537          	lui	a0,0x1
    8000000c:	f14025f3          	csrr	a1,mhartid
    80000010:	00158593          	addi	a1,a1,1
    80000014:	02b50533          	mul	a0,a0,a1
    80000018:	00a10133          	add	sp,sp,a0
    8000001c:	08c000ef          	jal	ra,800000a8 <start>

0000000080000020 <junk>:
    80000020:	0000006f          	j	80000020 <junk>

0000000080000024 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80000024:	ff010113          	addi	sp,sp,-16
    80000028:	00813423          	sd	s0,8(sp)
    8000002c:	01010413          	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000030:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000034:	0037969b          	slliw	a3,a5,0x3
    80000038:	02004737          	lui	a4,0x2004
    8000003c:	00e686b3          	add	a3,a3,a4
    80000040:	0200c737          	lui	a4,0x200c
    80000044:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000048:	000f4737          	lui	a4,0xf4
    8000004c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000050:	00e60633          	add	a2,a2,a4
    80000054:	00c6b023          	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000058:	0057979b          	slliw	a5,a5,0x5
    8000005c:	00379793          	slli	a5,a5,0x3
    80000060:	00009617          	auipc	a2,0x9
    80000064:	fe060613          	addi	a2,a2,-32 # 80009040 <mscratch0>
    80000068:	00c787b3          	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    8000006c:	02d7b023          	sd	a3,32(a5)
  scratch[5] = interval;
    80000070:	02e7b423          	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000074:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000078:	00008797          	auipc	a5,0x8
    8000007c:	d4878793          	addi	a5,a5,-696 # 80007dc0 <timervec>
    80000080:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000084:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000088:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000008c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000090:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000094:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000098:	30479073          	csrw	mie,a5
}
    8000009c:	00813403          	ld	s0,8(sp)
    800000a0:	01010113          	addi	sp,sp,16
    800000a4:	00008067          	ret

00000000800000a8 <start>:
{
    800000a8:	ff010113          	addi	sp,sp,-16
    800000ac:	00113423          	sd	ra,8(sp)
    800000b0:	00813023          	sd	s0,0(sp)
    800000b4:	01010413          	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800000b8:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800000bc:	ffffe737          	lui	a4,0xffffe
    800000c0:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdbd0b>
    800000c4:	00e7f7b3          	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000c8:	00001737          	lui	a4,0x1
    800000cc:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000d0:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000d4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000d8:	00001797          	auipc	a5,0x1
    800000dc:	17878793          	addi	a5,a5,376 # 80001250 <main>
    800000e0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000e4:	00000793          	li	a5,0
    800000e8:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000ec:	000107b7          	lui	a5,0x10
    800000f0:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000f4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000f8:	30379073          	csrw	mideleg,a5
  timerinit();
    800000fc:	00000097          	auipc	ra,0x0
    80000100:	f28080e7          	jalr	-216(ra) # 80000024 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000104:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80000108:	0007879b          	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    8000010c:	00078213          	mv	tp,a5
  asm volatile("mret");
    80000110:	30200073          	mret
}
    80000114:	00813083          	ld	ra,8(sp)
    80000118:	00013403          	ld	s0,0(sp)
    8000011c:	01010113          	addi	sp,sp,16
    80000120:	00008067          	ret

0000000080000124 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000124:	f9010113          	addi	sp,sp,-112
    80000128:	06113423          	sd	ra,104(sp)
    8000012c:	06813023          	sd	s0,96(sp)
    80000130:	04913c23          	sd	s1,88(sp)
    80000134:	05213823          	sd	s2,80(sp)
    80000138:	05313423          	sd	s3,72(sp)
    8000013c:	05413023          	sd	s4,64(sp)
    80000140:	03513c23          	sd	s5,56(sp)
    80000144:	03613823          	sd	s6,48(sp)
    80000148:	03713423          	sd	s7,40(sp)
    8000014c:	03813023          	sd	s8,32(sp)
    80000150:	01913c23          	sd	s9,24(sp)
    80000154:	01a13823          	sd	s10,16(sp)
    80000158:	07010413          	addi	s0,sp,112
    8000015c:	00050a93          	mv	s5,a0
    80000160:	00058a13          	mv	s4,a1
    80000164:	00060993          	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000168:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000016c:	00011517          	auipc	a0,0x11
    80000170:	6d450513          	addi	a0,a0,1748 # 80011840 <cons>
    80000174:	00001097          	auipc	ra,0x1
    80000178:	d64080e7          	jalr	-668(ra) # 80000ed8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000017c:	00011497          	auipc	s1,0x11
    80000180:	6c448493          	addi	s1,s1,1732 # 80011840 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000184:	00011917          	auipc	s2,0x11
    80000188:	75490913          	addi	s2,s2,1876 # 800118d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000018c:	00400b93          	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000190:	fff00c13          	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80000194:	00a00c93          	li	s9,10
  while(n > 0){
    80000198:	09305263          	blez	s3,8000021c <consoleread+0xf8>
    while(cons.r == cons.w){
    8000019c:	0984a783          	lw	a5,152(s1)
    800001a0:	09c4a703          	lw	a4,156(s1)
    800001a4:	02f71863          	bne	a4,a5,800001d4 <consoleread+0xb0>
      if(myproc()->killed){
    800001a8:	00002097          	auipc	ra,0x2
    800001ac:	1f0080e7          	jalr	496(ra) # 80002398 <myproc>
    800001b0:	03052783          	lw	a5,48(a0)
    800001b4:	08079063          	bnez	a5,80000234 <consoleread+0x110>
      sleep(&cons.r, &cons.lock);
    800001b8:	00048593          	mv	a1,s1
    800001bc:	00090513          	mv	a0,s2
    800001c0:	00003097          	auipc	ra,0x3
    800001c4:	c5c080e7          	jalr	-932(ra) # 80002e1c <sleep>
    while(cons.r == cons.w){
    800001c8:	0984a783          	lw	a5,152(s1)
    800001cc:	09c4a703          	lw	a4,156(s1)
    800001d0:	fcf70ce3          	beq	a4,a5,800001a8 <consoleread+0x84>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001d4:	0017871b          	addiw	a4,a5,1
    800001d8:	08e4ac23          	sw	a4,152(s1)
    800001dc:	07f7f713          	andi	a4,a5,127
    800001e0:	00e48733          	add	a4,s1,a4
    800001e4:	01874703          	lbu	a4,24(a4)
    800001e8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001ec:	097d0a63          	beq	s10,s7,80000280 <consoleread+0x15c>
    cbuf = c;
    800001f0:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001f4:	00100693          	li	a3,1
    800001f8:	f9f40613          	addi	a2,s0,-97
    800001fc:	000a0593          	mv	a1,s4
    80000200:	000a8513          	mv	a0,s5
    80000204:	00003097          	auipc	ra,0x3
    80000208:	f7c080e7          	jalr	-132(ra) # 80003180 <either_copyout>
    8000020c:	01850863          	beq	a0,s8,8000021c <consoleread+0xf8>
    dst++;
    80000210:	001a0a13          	addi	s4,s4,1
    --n;
    80000214:	fff9899b          	addiw	s3,s3,-1
    if(c == '\n'){
    80000218:	f99d10e3          	bne	s10,s9,80000198 <consoleread+0x74>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000021c:	00011517          	auipc	a0,0x11
    80000220:	62450513          	addi	a0,a0,1572 # 80011840 <cons>
    80000224:	00001097          	auipc	ra,0x1
    80000228:	d2c080e7          	jalr	-724(ra) # 80000f50 <release>

  return target - n;
    8000022c:	413b053b          	subw	a0,s6,s3
    80000230:	0180006f          	j	80000248 <consoleread+0x124>
        release(&cons.lock);
    80000234:	00011517          	auipc	a0,0x11
    80000238:	60c50513          	addi	a0,a0,1548 # 80011840 <cons>
    8000023c:	00001097          	auipc	ra,0x1
    80000240:	d14080e7          	jalr	-748(ra) # 80000f50 <release>
        return -1;
    80000244:	fff00513          	li	a0,-1
}
    80000248:	06813083          	ld	ra,104(sp)
    8000024c:	06013403          	ld	s0,96(sp)
    80000250:	05813483          	ld	s1,88(sp)
    80000254:	05013903          	ld	s2,80(sp)
    80000258:	04813983          	ld	s3,72(sp)
    8000025c:	04013a03          	ld	s4,64(sp)
    80000260:	03813a83          	ld	s5,56(sp)
    80000264:	03013b03          	ld	s6,48(sp)
    80000268:	02813b83          	ld	s7,40(sp)
    8000026c:	02013c03          	ld	s8,32(sp)
    80000270:	01813c83          	ld	s9,24(sp)
    80000274:	01013d03          	ld	s10,16(sp)
    80000278:	07010113          	addi	sp,sp,112
    8000027c:	00008067          	ret
      if(n < target){
    80000280:	0009871b          	sext.w	a4,s3
    80000284:	f9677ce3          	bgeu	a4,s6,8000021c <consoleread+0xf8>
        cons.r--;
    80000288:	00011717          	auipc	a4,0x11
    8000028c:	64f72823          	sw	a5,1616(a4) # 800118d8 <cons+0x98>
    80000290:	f8dff06f          	j	8000021c <consoleread+0xf8>

0000000080000294 <consputc>:
  if(panicked){
    80000294:	00023797          	auipc	a5,0x23
    80000298:	8447a783          	lw	a5,-1980(a5) # 80022ad8 <panicked>
    8000029c:	00078463          	beqz	a5,800002a4 <consputc+0x10>
    for(;;)
    800002a0:	0000006f          	j	800002a0 <consputc+0xc>
{
    800002a4:	ff010113          	addi	sp,sp,-16
    800002a8:	00113423          	sd	ra,8(sp)
    800002ac:	00813023          	sd	s0,0(sp)
    800002b0:	01010413          	addi	s0,sp,16
  if(c == BACKSPACE){
    800002b4:	10000793          	li	a5,256
    800002b8:	00f50e63          	beq	a0,a5,800002d4 <consputc+0x40>
    uartputc(c);
    800002bc:	00000097          	auipc	ra,0x0
    800002c0:	778080e7          	jalr	1912(ra) # 80000a34 <uartputc>
}
    800002c4:	00813083          	ld	ra,8(sp)
    800002c8:	00013403          	ld	s0,0(sp)
    800002cc:	01010113          	addi	sp,sp,16
    800002d0:	00008067          	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
    800002d4:	00800513          	li	a0,8
    800002d8:	00000097          	auipc	ra,0x0
    800002dc:	75c080e7          	jalr	1884(ra) # 80000a34 <uartputc>
    800002e0:	02000513          	li	a0,32
    800002e4:	00000097          	auipc	ra,0x0
    800002e8:	750080e7          	jalr	1872(ra) # 80000a34 <uartputc>
    800002ec:	00800513          	li	a0,8
    800002f0:	00000097          	auipc	ra,0x0
    800002f4:	744080e7          	jalr	1860(ra) # 80000a34 <uartputc>
    800002f8:	fcdff06f          	j	800002c4 <consputc+0x30>

00000000800002fc <consolewrite>:
{
    800002fc:	fb010113          	addi	sp,sp,-80
    80000300:	04113423          	sd	ra,72(sp)
    80000304:	04813023          	sd	s0,64(sp)
    80000308:	02913c23          	sd	s1,56(sp)
    8000030c:	03213823          	sd	s2,48(sp)
    80000310:	03313423          	sd	s3,40(sp)
    80000314:	03413023          	sd	s4,32(sp)
    80000318:	01513c23          	sd	s5,24(sp)
    8000031c:	05010413          	addi	s0,sp,80
    80000320:	00050993          	mv	s3,a0
    80000324:	00058493          	mv	s1,a1
    80000328:	00060a93          	mv	s5,a2
  acquire(&cons.lock);
    8000032c:	00011517          	auipc	a0,0x11
    80000330:	51450513          	addi	a0,a0,1300 # 80011840 <cons>
    80000334:	00001097          	auipc	ra,0x1
    80000338:	ba4080e7          	jalr	-1116(ra) # 80000ed8 <acquire>
  for(i = 0; i < n; i++){
    8000033c:	05505663          	blez	s5,80000388 <consolewrite+0x8c>
    80000340:	00148913          	addi	s2,s1,1
    80000344:	fffa879b          	addiw	a5,s5,-1
    80000348:	02079793          	slli	a5,a5,0x20
    8000034c:	0207d793          	srli	a5,a5,0x20
    80000350:	00f90933          	add	s2,s2,a5
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000354:	fff00a13          	li	s4,-1
    80000358:	00100693          	li	a3,1
    8000035c:	00048613          	mv	a2,s1
    80000360:	00098593          	mv	a1,s3
    80000364:	fbf40513          	addi	a0,s0,-65
    80000368:	00003097          	auipc	ra,0x3
    8000036c:	ea8080e7          	jalr	-344(ra) # 80003210 <either_copyin>
    80000370:	01450c63          	beq	a0,s4,80000388 <consolewrite+0x8c>
    consputc(c);
    80000374:	fbf44503          	lbu	a0,-65(s0)
    80000378:	00000097          	auipc	ra,0x0
    8000037c:	f1c080e7          	jalr	-228(ra) # 80000294 <consputc>
  for(i = 0; i < n; i++){
    80000380:	00148493          	addi	s1,s1,1
    80000384:	fd249ae3          	bne	s1,s2,80000358 <consolewrite+0x5c>
  release(&cons.lock);
    80000388:	00011517          	auipc	a0,0x11
    8000038c:	4b850513          	addi	a0,a0,1208 # 80011840 <cons>
    80000390:	00001097          	auipc	ra,0x1
    80000394:	bc0080e7          	jalr	-1088(ra) # 80000f50 <release>
}
    80000398:	000a8513          	mv	a0,s5
    8000039c:	04813083          	ld	ra,72(sp)
    800003a0:	04013403          	ld	s0,64(sp)
    800003a4:	03813483          	ld	s1,56(sp)
    800003a8:	03013903          	ld	s2,48(sp)
    800003ac:	02813983          	ld	s3,40(sp)
    800003b0:	02013a03          	ld	s4,32(sp)
    800003b4:	01813a83          	ld	s5,24(sp)
    800003b8:	05010113          	addi	sp,sp,80
    800003bc:	00008067          	ret

00000000800003c0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800003c0:	fe010113          	addi	sp,sp,-32
    800003c4:	00113c23          	sd	ra,24(sp)
    800003c8:	00813823          	sd	s0,16(sp)
    800003cc:	00913423          	sd	s1,8(sp)
    800003d0:	01213023          	sd	s2,0(sp)
    800003d4:	02010413          	addi	s0,sp,32
    800003d8:	00050493          	mv	s1,a0
  acquire(&cons.lock);
    800003dc:	00011517          	auipc	a0,0x11
    800003e0:	46450513          	addi	a0,a0,1124 # 80011840 <cons>
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	af4080e7          	jalr	-1292(ra) # 80000ed8 <acquire>

  switch(c){
    800003ec:	01500793          	li	a5,21
    800003f0:	0cf48663          	beq	s1,a5,800004bc <consoleintr+0xfc>
    800003f4:	0497c263          	blt	a5,s1,80000438 <consoleintr+0x78>
    800003f8:	00800793          	li	a5,8
    800003fc:	10f48a63          	beq	s1,a5,80000510 <consoleintr+0x150>
    80000400:	01000793          	li	a5,16
    80000404:	12f49e63          	bne	s1,a5,80000540 <consoleintr+0x180>
  case C('P'):  // Print process list.
    procdump();
    80000408:	00003097          	auipc	ra,0x3
    8000040c:	e98080e7          	jalr	-360(ra) # 800032a0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000410:	00011517          	auipc	a0,0x11
    80000414:	43050513          	addi	a0,a0,1072 # 80011840 <cons>
    80000418:	00001097          	auipc	ra,0x1
    8000041c:	b38080e7          	jalr	-1224(ra) # 80000f50 <release>
}
    80000420:	01813083          	ld	ra,24(sp)
    80000424:	01013403          	ld	s0,16(sp)
    80000428:	00813483          	ld	s1,8(sp)
    8000042c:	00013903          	ld	s2,0(sp)
    80000430:	02010113          	addi	sp,sp,32
    80000434:	00008067          	ret
  switch(c){
    80000438:	07f00793          	li	a5,127
    8000043c:	0cf48a63          	beq	s1,a5,80000510 <consoleintr+0x150>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000440:	00011717          	auipc	a4,0x11
    80000444:	40070713          	addi	a4,a4,1024 # 80011840 <cons>
    80000448:	0a072783          	lw	a5,160(a4)
    8000044c:	09872703          	lw	a4,152(a4)
    80000450:	40e787bb          	subw	a5,a5,a4
    80000454:	07f00713          	li	a4,127
    80000458:	faf76ce3          	bltu	a4,a5,80000410 <consoleintr+0x50>
      c = (c == '\r') ? '\n' : c;
    8000045c:	00d00793          	li	a5,13
    80000460:	0ef48463          	beq	s1,a5,80000548 <consoleintr+0x188>
      consputc(c);
    80000464:	00048513          	mv	a0,s1
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	e2c080e7          	jalr	-468(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000470:	00011797          	auipc	a5,0x11
    80000474:	3d078793          	addi	a5,a5,976 # 80011840 <cons>
    80000478:	0a07a703          	lw	a4,160(a5)
    8000047c:	0017069b          	addiw	a3,a4,1
    80000480:	0006861b          	sext.w	a2,a3
    80000484:	0ad7a023          	sw	a3,160(a5)
    80000488:	07f77713          	andi	a4,a4,127
    8000048c:	00e787b3          	add	a5,a5,a4
    80000490:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000494:	00a00793          	li	a5,10
    80000498:	0ef48263          	beq	s1,a5,8000057c <consoleintr+0x1bc>
    8000049c:	00400793          	li	a5,4
    800004a0:	0cf48e63          	beq	s1,a5,8000057c <consoleintr+0x1bc>
    800004a4:	00011797          	auipc	a5,0x11
    800004a8:	4347a783          	lw	a5,1076(a5) # 800118d8 <cons+0x98>
    800004ac:	0807879b          	addiw	a5,a5,128
    800004b0:	f6f610e3          	bne	a2,a5,80000410 <consoleintr+0x50>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800004b4:	00078613          	mv	a2,a5
    800004b8:	0c40006f          	j	8000057c <consoleintr+0x1bc>
    while(cons.e != cons.w &&
    800004bc:	00011717          	auipc	a4,0x11
    800004c0:	38470713          	addi	a4,a4,900 # 80011840 <cons>
    800004c4:	0a072783          	lw	a5,160(a4)
    800004c8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800004cc:	00011497          	auipc	s1,0x11
    800004d0:	37448493          	addi	s1,s1,884 # 80011840 <cons>
    while(cons.e != cons.w &&
    800004d4:	00a00913          	li	s2,10
    800004d8:	f2f70ce3          	beq	a4,a5,80000410 <consoleintr+0x50>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800004dc:	fff7879b          	addiw	a5,a5,-1
    800004e0:	07f7f713          	andi	a4,a5,127
    800004e4:	00e48733          	add	a4,s1,a4
    while(cons.e != cons.w &&
    800004e8:	01874703          	lbu	a4,24(a4)
    800004ec:	f32702e3          	beq	a4,s2,80000410 <consoleintr+0x50>
      cons.e--;
    800004f0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800004f4:	10000513          	li	a0,256
    800004f8:	00000097          	auipc	ra,0x0
    800004fc:	d9c080e7          	jalr	-612(ra) # 80000294 <consputc>
    while(cons.e != cons.w &&
    80000500:	0a04a783          	lw	a5,160(s1)
    80000504:	09c4a703          	lw	a4,156(s1)
    80000508:	fcf71ae3          	bne	a4,a5,800004dc <consoleintr+0x11c>
    8000050c:	f05ff06f          	j	80000410 <consoleintr+0x50>
    if(cons.e != cons.w){
    80000510:	00011717          	auipc	a4,0x11
    80000514:	33070713          	addi	a4,a4,816 # 80011840 <cons>
    80000518:	0a072783          	lw	a5,160(a4)
    8000051c:	09c72703          	lw	a4,156(a4)
    80000520:	eef708e3          	beq	a4,a5,80000410 <consoleintr+0x50>
      cons.e--;
    80000524:	fff7879b          	addiw	a5,a5,-1
    80000528:	00011717          	auipc	a4,0x11
    8000052c:	3af72c23          	sw	a5,952(a4) # 800118e0 <cons+0xa0>
      consputc(BACKSPACE);
    80000530:	10000513          	li	a0,256
    80000534:	00000097          	auipc	ra,0x0
    80000538:	d60080e7          	jalr	-672(ra) # 80000294 <consputc>
    8000053c:	ed5ff06f          	j	80000410 <consoleintr+0x50>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000540:	ec0488e3          	beqz	s1,80000410 <consoleintr+0x50>
    80000544:	efdff06f          	j	80000440 <consoleintr+0x80>
      consputc(c);
    80000548:	00a00513          	li	a0,10
    8000054c:	00000097          	auipc	ra,0x0
    80000550:	d48080e7          	jalr	-696(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000554:	00011797          	auipc	a5,0x11
    80000558:	2ec78793          	addi	a5,a5,748 # 80011840 <cons>
    8000055c:	0a07a703          	lw	a4,160(a5)
    80000560:	0017069b          	addiw	a3,a4,1
    80000564:	0006861b          	sext.w	a2,a3
    80000568:	0ad7a023          	sw	a3,160(a5)
    8000056c:	07f77713          	andi	a4,a4,127
    80000570:	00e787b3          	add	a5,a5,a4
    80000574:	00a00713          	li	a4,10
    80000578:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000057c:	00011797          	auipc	a5,0x11
    80000580:	36c7a023          	sw	a2,864(a5) # 800118dc <cons+0x9c>
        wakeup(&cons.r);
    80000584:	00011517          	auipc	a0,0x11
    80000588:	35450513          	addi	a0,a0,852 # 800118d8 <cons+0x98>
    8000058c:	00003097          	auipc	ra,0x3
    80000590:	aac080e7          	jalr	-1364(ra) # 80003038 <wakeup>
    80000594:	e7dff06f          	j	80000410 <consoleintr+0x50>

0000000080000598 <consoleinit>:

void
consoleinit(void)
{
    80000598:	ff010113          	addi	sp,sp,-16
    8000059c:	00113423          	sd	ra,8(sp)
    800005a0:	00813023          	sd	s0,0(sp)
    800005a4:	01010413          	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800005a8:	00008597          	auipc	a1,0x8
    800005ac:	b9058593          	addi	a1,a1,-1136 # 80008138 <userret+0x94>
    800005b0:	00011517          	auipc	a0,0x11
    800005b4:	29050513          	addi	a0,a0,656 # 80011840 <cons>
    800005b8:	00000097          	auipc	ra,0x0
    800005bc:	798080e7          	jalr	1944(ra) # 80000d50 <initlock>

  uartinit();
    800005c0:	00000097          	auipc	ra,0x0
    800005c4:	42c080e7          	jalr	1068(ra) # 800009ec <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800005c8:	00021797          	auipc	a5,0x21
    800005cc:	4b878793          	addi	a5,a5,1208 # 80021a80 <devsw>
    800005d0:	00000717          	auipc	a4,0x0
    800005d4:	b5470713          	addi	a4,a4,-1196 # 80000124 <consoleread>
    800005d8:	00e7b823          	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800005dc:	00000717          	auipc	a4,0x0
    800005e0:	d2070713          	addi	a4,a4,-736 # 800002fc <consolewrite>
    800005e4:	00e7bc23          	sd	a4,24(a5)
}
    800005e8:	00813083          	ld	ra,8(sp)
    800005ec:	00013403          	ld	s0,0(sp)
    800005f0:	01010113          	addi	sp,sp,16
    800005f4:	00008067          	ret

00000000800005f8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800005f8:	fd010113          	addi	sp,sp,-48
    800005fc:	02113423          	sd	ra,40(sp)
    80000600:	02813023          	sd	s0,32(sp)
    80000604:	00913c23          	sd	s1,24(sp)
    80000608:	01213823          	sd	s2,16(sp)
    8000060c:	03010413          	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80000610:	00060463          	beqz	a2,80000618 <printint+0x20>
    80000614:	0a054c63          	bltz	a0,800006cc <printint+0xd4>
    x = -xx;
  else
    x = xx;
    80000618:	0005051b          	sext.w	a0,a0
    8000061c:	00000893          	li	a7,0
    80000620:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000624:	00000713          	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80000628:	0005859b          	sext.w	a1,a1
    8000062c:	00008617          	auipc	a2,0x8
    80000630:	31c60613          	addi	a2,a2,796 # 80008948 <digits>
    80000634:	00070813          	mv	a6,a4
    80000638:	0017071b          	addiw	a4,a4,1
    8000063c:	02b577bb          	remuw	a5,a0,a1
    80000640:	02079793          	slli	a5,a5,0x20
    80000644:	0207d793          	srli	a5,a5,0x20
    80000648:	00f607b3          	add	a5,a2,a5
    8000064c:	0007c783          	lbu	a5,0(a5)
    80000650:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80000654:	0005079b          	sext.w	a5,a0
    80000658:	02b5553b          	divuw	a0,a0,a1
    8000065c:	00168693          	addi	a3,a3,1
    80000660:	fcb7fae3          	bgeu	a5,a1,80000634 <printint+0x3c>

  if(sign)
    80000664:	00088c63          	beqz	a7,8000067c <printint+0x84>
    buf[i++] = '-';
    80000668:	fe070793          	addi	a5,a4,-32
    8000066c:	00878733          	add	a4,a5,s0
    80000670:	02d00793          	li	a5,45
    80000674:	fef70823          	sb	a5,-16(a4)
    80000678:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000067c:	02e05c63          	blez	a4,800006b4 <printint+0xbc>
    80000680:	fd040793          	addi	a5,s0,-48
    80000684:	00e784b3          	add	s1,a5,a4
    80000688:	fff78913          	addi	s2,a5,-1
    8000068c:	00e90933          	add	s2,s2,a4
    80000690:	fff7071b          	addiw	a4,a4,-1
    80000694:	02071713          	slli	a4,a4,0x20
    80000698:	02075713          	srli	a4,a4,0x20
    8000069c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800006a0:	fff4c503          	lbu	a0,-1(s1)
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	bf0080e7          	jalr	-1040(ra) # 80000294 <consputc>
  while(--i >= 0)
    800006ac:	fff48493          	addi	s1,s1,-1
    800006b0:	ff2498e3          	bne	s1,s2,800006a0 <printint+0xa8>
}
    800006b4:	02813083          	ld	ra,40(sp)
    800006b8:	02013403          	ld	s0,32(sp)
    800006bc:	01813483          	ld	s1,24(sp)
    800006c0:	01013903          	ld	s2,16(sp)
    800006c4:	03010113          	addi	sp,sp,48
    800006c8:	00008067          	ret
    x = -xx;
    800006cc:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    800006d0:	00100893          	li	a7,1
    x = -xx;
    800006d4:	f4dff06f          	j	80000620 <printint+0x28>

00000000800006d8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800006d8:	fe010113          	addi	sp,sp,-32
    800006dc:	00113c23          	sd	ra,24(sp)
    800006e0:	00813823          	sd	s0,16(sp)
    800006e4:	00913423          	sd	s1,8(sp)
    800006e8:	02010413          	addi	s0,sp,32
    800006ec:	00050493          	mv	s1,a0
  pr.locking = 0;
    800006f0:	00011797          	auipc	a5,0x11
    800006f4:	2007a823          	sw	zero,528(a5) # 80011900 <pr+0x18>
  printf("panic: ");
    800006f8:	00008517          	auipc	a0,0x8
    800006fc:	a4850513          	addi	a0,a0,-1464 # 80008140 <userret+0x9c>
    80000700:	00000097          	auipc	ra,0x0
    80000704:	034080e7          	jalr	52(ra) # 80000734 <printf>
  printf(s);
    80000708:	00048513          	mv	a0,s1
    8000070c:	00000097          	auipc	ra,0x0
    80000710:	028080e7          	jalr	40(ra) # 80000734 <printf>
  printf("\n");
    80000714:	00008517          	auipc	a0,0x8
    80000718:	aa450513          	addi	a0,a0,-1372 # 800081b8 <userret+0x114>
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	018080e7          	jalr	24(ra) # 80000734 <printf>
  panicked = 1; // freeze other CPUs
    80000724:	00100793          	li	a5,1
    80000728:	00022717          	auipc	a4,0x22
    8000072c:	3af72823          	sw	a5,944(a4) # 80022ad8 <panicked>
  for(;;)
    80000730:	0000006f          	j	80000730 <panic+0x58>

0000000080000734 <printf>:
{
    80000734:	f4010113          	addi	sp,sp,-192
    80000738:	06113c23          	sd	ra,120(sp)
    8000073c:	06813823          	sd	s0,112(sp)
    80000740:	06913423          	sd	s1,104(sp)
    80000744:	07213023          	sd	s2,96(sp)
    80000748:	05313c23          	sd	s3,88(sp)
    8000074c:	05413823          	sd	s4,80(sp)
    80000750:	05513423          	sd	s5,72(sp)
    80000754:	05613023          	sd	s6,64(sp)
    80000758:	03713c23          	sd	s7,56(sp)
    8000075c:	03813823          	sd	s8,48(sp)
    80000760:	03913423          	sd	s9,40(sp)
    80000764:	03a13023          	sd	s10,32(sp)
    80000768:	01b13c23          	sd	s11,24(sp)
    8000076c:	08010413          	addi	s0,sp,128
    80000770:	00050a13          	mv	s4,a0
    80000774:	00b43423          	sd	a1,8(s0)
    80000778:	00c43823          	sd	a2,16(s0)
    8000077c:	00d43c23          	sd	a3,24(s0)
    80000780:	02e43023          	sd	a4,32(s0)
    80000784:	02f43423          	sd	a5,40(s0)
    80000788:	03043823          	sd	a6,48(s0)
    8000078c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80000790:	00011d97          	auipc	s11,0x11
    80000794:	170dad83          	lw	s11,368(s11) # 80011900 <pr+0x18>
  if(locking)
    80000798:	020d9e63          	bnez	s11,800007d4 <printf+0xa0>
  if (fmt == 0)
    8000079c:	040a0663          	beqz	s4,800007e8 <printf+0xb4>
  va_start(ap, fmt);
    800007a0:	00840793          	addi	a5,s0,8
    800007a4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800007a8:	000a4503          	lbu	a0,0(s4)
    800007ac:	1a050063          	beqz	a0,8000094c <printf+0x218>
    800007b0:	00000993          	li	s3,0
    if(c != '%'){
    800007b4:	02500a93          	li	s5,37
    switch(c){
    800007b8:	07000b93          	li	s7,112
  consputc('x');
    800007bc:	01000d13          	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800007c0:	00008b17          	auipc	s6,0x8
    800007c4:	188b0b13          	addi	s6,s6,392 # 80008948 <digits>
    switch(c){
    800007c8:	07300c93          	li	s9,115
    800007cc:	06400c13          	li	s8,100
    800007d0:	0400006f          	j	80000810 <printf+0xdc>
    acquire(&pr.lock);
    800007d4:	00011517          	auipc	a0,0x11
    800007d8:	11450513          	addi	a0,a0,276 # 800118e8 <pr>
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	6fc080e7          	jalr	1788(ra) # 80000ed8 <acquire>
    800007e4:	fb9ff06f          	j	8000079c <printf+0x68>
    panic("null fmt");
    800007e8:	00008517          	auipc	a0,0x8
    800007ec:	96850513          	addi	a0,a0,-1688 # 80008150 <userret+0xac>
    800007f0:	00000097          	auipc	ra,0x0
    800007f4:	ee8080e7          	jalr	-280(ra) # 800006d8 <panic>
      consputc(c);
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	a9c080e7          	jalr	-1380(ra) # 80000294 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000800:	0019899b          	addiw	s3,s3,1
    80000804:	013a07b3          	add	a5,s4,s3
    80000808:	0007c503          	lbu	a0,0(a5)
    8000080c:	14050063          	beqz	a0,8000094c <printf+0x218>
    if(c != '%'){
    80000810:	ff5514e3          	bne	a0,s5,800007f8 <printf+0xc4>
    c = fmt[++i] & 0xff;
    80000814:	0019899b          	addiw	s3,s3,1
    80000818:	013a07b3          	add	a5,s4,s3
    8000081c:	0007c783          	lbu	a5,0(a5)
    80000820:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000824:	12078463          	beqz	a5,8000094c <printf+0x218>
    switch(c){
    80000828:	07778263          	beq	a5,s7,8000088c <printf+0x158>
    8000082c:	02fbfa63          	bgeu	s7,a5,80000860 <printf+0x12c>
    80000830:	0b978663          	beq	a5,s9,800008dc <printf+0x1a8>
    80000834:	07800713          	li	a4,120
    80000838:	0ee79c63          	bne	a5,a4,80000930 <printf+0x1fc>
      printint(va_arg(ap, int), 16, 1);
    8000083c:	f8843783          	ld	a5,-120(s0)
    80000840:	00878713          	addi	a4,a5,8
    80000844:	f8e43423          	sd	a4,-120(s0)
    80000848:	00100613          	li	a2,1
    8000084c:	000d0593          	mv	a1,s10
    80000850:	0007a503          	lw	a0,0(a5)
    80000854:	00000097          	auipc	ra,0x0
    80000858:	da4080e7          	jalr	-604(ra) # 800005f8 <printint>
      break;
    8000085c:	fa5ff06f          	j	80000800 <printf+0xcc>
    switch(c){
    80000860:	0d578063          	beq	a5,s5,80000920 <printf+0x1ec>
    80000864:	0d879663          	bne	a5,s8,80000930 <printf+0x1fc>
      printint(va_arg(ap, int), 10, 1);
    80000868:	f8843783          	ld	a5,-120(s0)
    8000086c:	00878713          	addi	a4,a5,8
    80000870:	f8e43423          	sd	a4,-120(s0)
    80000874:	00100613          	li	a2,1
    80000878:	00a00593          	li	a1,10
    8000087c:	0007a503          	lw	a0,0(a5)
    80000880:	00000097          	auipc	ra,0x0
    80000884:	d78080e7          	jalr	-648(ra) # 800005f8 <printint>
      break;
    80000888:	f79ff06f          	j	80000800 <printf+0xcc>
      printptr(va_arg(ap, uint64));
    8000088c:	f8843783          	ld	a5,-120(s0)
    80000890:	00878713          	addi	a4,a5,8
    80000894:	f8e43423          	sd	a4,-120(s0)
    80000898:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000089c:	03000513          	li	a0,48
    800008a0:	00000097          	auipc	ra,0x0
    800008a4:	9f4080e7          	jalr	-1548(ra) # 80000294 <consputc>
  consputc('x');
    800008a8:	07800513          	li	a0,120
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	9e8080e7          	jalr	-1560(ra) # 80000294 <consputc>
    800008b4:	000d0493          	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800008b8:	03c95793          	srli	a5,s2,0x3c
    800008bc:	00fb07b3          	add	a5,s6,a5
    800008c0:	0007c503          	lbu	a0,0(a5)
    800008c4:	00000097          	auipc	ra,0x0
    800008c8:	9d0080e7          	jalr	-1584(ra) # 80000294 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800008cc:	00491913          	slli	s2,s2,0x4
    800008d0:	fff4849b          	addiw	s1,s1,-1
    800008d4:	fe0492e3          	bnez	s1,800008b8 <printf+0x184>
    800008d8:	f29ff06f          	j	80000800 <printf+0xcc>
      if((s = va_arg(ap, char*)) == 0)
    800008dc:	f8843783          	ld	a5,-120(s0)
    800008e0:	00878713          	addi	a4,a5,8
    800008e4:	f8e43423          	sd	a4,-120(s0)
    800008e8:	0007b483          	ld	s1,0(a5)
    800008ec:	02048263          	beqz	s1,80000910 <printf+0x1dc>
      for(; *s; s++)
    800008f0:	0004c503          	lbu	a0,0(s1)
    800008f4:	f00506e3          	beqz	a0,80000800 <printf+0xcc>
        consputc(*s);
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	99c080e7          	jalr	-1636(ra) # 80000294 <consputc>
      for(; *s; s++)
    80000900:	00148493          	addi	s1,s1,1
    80000904:	0004c503          	lbu	a0,0(s1)
    80000908:	fe0518e3          	bnez	a0,800008f8 <printf+0x1c4>
    8000090c:	ef5ff06f          	j	80000800 <printf+0xcc>
        s = "(null)";
    80000910:	00008497          	auipc	s1,0x8
    80000914:	83848493          	addi	s1,s1,-1992 # 80008148 <userret+0xa4>
      for(; *s; s++)
    80000918:	02800513          	li	a0,40
    8000091c:	fddff06f          	j	800008f8 <printf+0x1c4>
      consputc('%');
    80000920:	000a8513          	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	970080e7          	jalr	-1680(ra) # 80000294 <consputc>
      break;
    8000092c:	ed5ff06f          	j	80000800 <printf+0xcc>
      consputc('%');
    80000930:	000a8513          	mv	a0,s5
    80000934:	00000097          	auipc	ra,0x0
    80000938:	960080e7          	jalr	-1696(ra) # 80000294 <consputc>
      consputc(c);
    8000093c:	00048513          	mv	a0,s1
    80000940:	00000097          	auipc	ra,0x0
    80000944:	954080e7          	jalr	-1708(ra) # 80000294 <consputc>
      break;
    80000948:	eb9ff06f          	j	80000800 <printf+0xcc>
  if(locking)
    8000094c:	040d9063          	bnez	s11,8000098c <printf+0x258>
}
    80000950:	07813083          	ld	ra,120(sp)
    80000954:	07013403          	ld	s0,112(sp)
    80000958:	06813483          	ld	s1,104(sp)
    8000095c:	06013903          	ld	s2,96(sp)
    80000960:	05813983          	ld	s3,88(sp)
    80000964:	05013a03          	ld	s4,80(sp)
    80000968:	04813a83          	ld	s5,72(sp)
    8000096c:	04013b03          	ld	s6,64(sp)
    80000970:	03813b83          	ld	s7,56(sp)
    80000974:	03013c03          	ld	s8,48(sp)
    80000978:	02813c83          	ld	s9,40(sp)
    8000097c:	02013d03          	ld	s10,32(sp)
    80000980:	01813d83          	ld	s11,24(sp)
    80000984:	0c010113          	addi	sp,sp,192
    80000988:	00008067          	ret
    release(&pr.lock);
    8000098c:	00011517          	auipc	a0,0x11
    80000990:	f5c50513          	addi	a0,a0,-164 # 800118e8 <pr>
    80000994:	00000097          	auipc	ra,0x0
    80000998:	5bc080e7          	jalr	1468(ra) # 80000f50 <release>
}
    8000099c:	fb5ff06f          	j	80000950 <printf+0x21c>

00000000800009a0 <printfinit>:
    ;
}

void
printfinit(void)
{
    800009a0:	fe010113          	addi	sp,sp,-32
    800009a4:	00113c23          	sd	ra,24(sp)
    800009a8:	00813823          	sd	s0,16(sp)
    800009ac:	00913423          	sd	s1,8(sp)
    800009b0:	02010413          	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800009b4:	00011497          	auipc	s1,0x11
    800009b8:	f3448493          	addi	s1,s1,-204 # 800118e8 <pr>
    800009bc:	00007597          	auipc	a1,0x7
    800009c0:	7a458593          	addi	a1,a1,1956 # 80008160 <userret+0xbc>
    800009c4:	00048513          	mv	a0,s1
    800009c8:	00000097          	auipc	ra,0x0
    800009cc:	388080e7          	jalr	904(ra) # 80000d50 <initlock>
  pr.locking = 1;
    800009d0:	00100793          	li	a5,1
    800009d4:	00f4ac23          	sw	a5,24(s1)
}
    800009d8:	01813083          	ld	ra,24(sp)
    800009dc:	01013403          	ld	s0,16(sp)
    800009e0:	00813483          	ld	s1,8(sp)
    800009e4:	02010113          	addi	sp,sp,32
    800009e8:	00008067          	ret

00000000800009ec <uartinit>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void
uartinit(void)
{
    800009ec:	ff010113          	addi	sp,sp,-16
    800009f0:	00813423          	sd	s0,8(sp)
    800009f4:	01010413          	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800009f8:	100007b7          	lui	a5,0x10000
    800009fc:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, 0x80);
    80000a00:	f8000713          	li	a4,-128
    80000a04:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000a08:	00300713          	li	a4,3
    80000a0c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000a10:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, 0x03);
    80000a14:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, 0x07);
    80000a18:	00700713          	li	a4,7
    80000a1c:	00e78123          	sb	a4,2(a5)

  // enable receive interrupts.
  WriteReg(IER, 0x01);
    80000a20:	00100713          	li	a4,1
    80000a24:	00e780a3          	sb	a4,1(a5)
}
    80000a28:	00813403          	ld	s0,8(sp)
    80000a2c:	01010113          	addi	sp,sp,16
    80000a30:	00008067          	ret

0000000080000a34 <uartputc>:

// write one output character to the UART.
void
uartputc(int c)
{
    80000a34:	ff010113          	addi	sp,sp,-16
    80000a38:	00813423          	sd	s0,8(sp)
    80000a3c:	01010413          	addi	s0,sp,16
  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & (1 << 5)) == 0)
    80000a40:	10000737          	lui	a4,0x10000
    80000a44:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000a48:	0207f793          	andi	a5,a5,32
    80000a4c:	fe078ce3          	beqz	a5,80000a44 <uartputc+0x10>
    ;
  WriteReg(THR, c);
    80000a50:	0ff57513          	zext.b	a0,a0
    80000a54:	100007b7          	lui	a5,0x10000
    80000a58:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    80000a5c:	00813403          	ld	s0,8(sp)
    80000a60:	01010113          	addi	sp,sp,16
    80000a64:	00008067          	ret

0000000080000a68 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000a68:	ff010113          	addi	sp,sp,-16
    80000a6c:	00813423          	sd	s0,8(sp)
    80000a70:	01010413          	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000a74:	100007b7          	lui	a5,0x10000
    80000a78:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a7c:	0017f793          	andi	a5,a5,1
    80000a80:	00078c63          	beqz	a5,80000a98 <uartgetc+0x30>
    // input data is ready.
    return ReadReg(RHR);
    80000a84:	100007b7          	lui	a5,0x10000
    80000a88:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a8c:	00813403          	ld	s0,8(sp)
    80000a90:	01010113          	addi	sp,sp,16
    80000a94:	00008067          	ret
    return -1;
    80000a98:	fff00513          	li	a0,-1
    80000a9c:	ff1ff06f          	j	80000a8c <uartgetc+0x24>

0000000080000aa0 <uartintr>:

// trap.c calls here when the uart interrupts.
void
uartintr(void)
{
    80000aa0:	fe010113          	addi	sp,sp,-32
    80000aa4:	00113c23          	sd	ra,24(sp)
    80000aa8:	00813823          	sd	s0,16(sp)
    80000aac:	00913423          	sd	s1,8(sp)
    80000ab0:	02010413          	addi	s0,sp,32
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000ab4:	fff00493          	li	s1,-1
    80000ab8:	00c0006f          	j	80000ac4 <uartintr+0x24>
      break;
    consoleintr(c);
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	904080e7          	jalr	-1788(ra) # 800003c0 <consoleintr>
    int c = uartgetc();
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	fa4080e7          	jalr	-92(ra) # 80000a68 <uartgetc>
    if(c == -1)
    80000acc:	fe9518e3          	bne	a0,s1,80000abc <uartintr+0x1c>
  }
}
    80000ad0:	01813083          	ld	ra,24(sp)
    80000ad4:	01013403          	ld	s0,16(sp)
    80000ad8:	00813483          	ld	s1,8(sp)
    80000adc:	02010113          	addi	sp,sp,32
    80000ae0:	00008067          	ret

0000000080000ae4 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000ae4:	fe010113          	addi	sp,sp,-32
    80000ae8:	00113c23          	sd	ra,24(sp)
    80000aec:	00813823          	sd	s0,16(sp)
    80000af0:	00913423          	sd	s1,8(sp)
    80000af4:	01213023          	sd	s2,0(sp)
    80000af8:	02010413          	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000afc:	03451793          	slli	a5,a0,0x34
    80000b00:	06079263          	bnez	a5,80000b64 <kfree+0x80>
    80000b04:	00050493          	mv	s1,a0
    80000b08:	00022797          	auipc	a5,0x22
    80000b0c:	fec78793          	addi	a5,a5,-20 # 80022af4 <end>
    80000b10:	04f56a63          	bltu	a0,a5,80000b64 <kfree+0x80>
    80000b14:	01100793          	li	a5,17
    80000b18:	01b79793          	slli	a5,a5,0x1b
    80000b1c:	04f57463          	bgeu	a0,a5,80000b64 <kfree+0x80>
  // Fill with junk to catch dangling refs.
  //memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000b20:	00011917          	auipc	s2,0x11
    80000b24:	de890913          	addi	s2,s2,-536 # 80011908 <kmem>
    80000b28:	00090513          	mv	a0,s2
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	3ac080e7          	jalr	940(ra) # 80000ed8 <acquire>
  r->next = kmem.freelist;
    80000b34:	01893783          	ld	a5,24(s2)
    80000b38:	00f4b023          	sd	a5,0(s1)
  kmem.freelist = r;
    80000b3c:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000b40:	00090513          	mv	a0,s2
    80000b44:	00000097          	auipc	ra,0x0
    80000b48:	40c080e7          	jalr	1036(ra) # 80000f50 <release>
}
    80000b4c:	01813083          	ld	ra,24(sp)
    80000b50:	01013403          	ld	s0,16(sp)
    80000b54:	00813483          	ld	s1,8(sp)
    80000b58:	00013903          	ld	s2,0(sp)
    80000b5c:	02010113          	addi	sp,sp,32
    80000b60:	00008067          	ret
    panic("kfree");
    80000b64:	00007517          	auipc	a0,0x7
    80000b68:	60450513          	addi	a0,a0,1540 # 80008168 <userret+0xc4>
    80000b6c:	00000097          	auipc	ra,0x0
    80000b70:	b6c080e7          	jalr	-1172(ra) # 800006d8 <panic>

0000000080000b74 <freerange>:
{
    80000b74:	fb010113          	addi	sp,sp,-80
    80000b78:	04113423          	sd	ra,72(sp)
    80000b7c:	04813023          	sd	s0,64(sp)
    80000b80:	02913c23          	sd	s1,56(sp)
    80000b84:	03213823          	sd	s2,48(sp)
    80000b88:	03313423          	sd	s3,40(sp)
    80000b8c:	03413023          	sd	s4,32(sp)
    80000b90:	01513c23          	sd	s5,24(sp)
    80000b94:	01613823          	sd	s6,16(sp)
    80000b98:	01713423          	sd	s7,8(sp)
    80000b9c:	05010413          	addi	s0,sp,80
    80000ba0:	00058a13          	mv	s4,a1
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ba4:	000014b7          	lui	s1,0x1
    80000ba8:	fff48793          	addi	a5,s1,-1 # fff <_entry-0x7ffff001>
    80000bac:	00f50533          	add	a0,a0,a5
    80000bb0:	fffff7b7          	lui	a5,0xfffff
    80000bb4:	00f57933          	and	s2,a0,a5
  printf("Before kfree\n");
    80000bb8:	00007517          	auipc	a0,0x7
    80000bbc:	5b850513          	addi	a0,a0,1464 # 80008170 <userret+0xcc>
    80000bc0:	00000097          	auipc	ra,0x0
    80000bc4:	b74080e7          	jalr	-1164(ra) # 80000734 <printf>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE, i += 1, (i % 500) ?  : printf("i:%d\n",i))
    80000bc8:	009904b3          	add	s1,s2,s1
    80000bcc:	069a6063          	bltu	s4,s1,80000c2c <freerange+0xb8>
    kfree(p);
    80000bd0:	00090513          	mv	a0,s2
    80000bd4:	00000097          	auipc	ra,0x0
    80000bd8:	f10080e7          	jalr	-240(ra) # 80000ae4 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE, i += 1, (i % 500) ?  : printf("i:%d\n",i))
    80000bdc:	00100913          	li	s2,1
    80000be0:	00001ab7          	lui	s5,0x1
    80000be4:	1f400b13          	li	s6,500
    80000be8:	00007b97          	auipc	s7,0x7
    80000bec:	598b8b93          	addi	s7,s7,1432 # 80008180 <userret+0xdc>
    80000bf0:	0080006f          	j	80000bf8 <freerange+0x84>
    80000bf4:	00098493          	mv	s1,s3
    80000bf8:	015489b3          	add	s3,s1,s5
    80000bfc:	033a6863          	bltu	s4,s3,80000c2c <freerange+0xb8>
    kfree(p);
    80000c00:	00048513          	mv	a0,s1
    80000c04:	00000097          	auipc	ra,0x0
    80000c08:	ee0080e7          	jalr	-288(ra) # 80000ae4 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE, i += 1, (i % 500) ?  : printf("i:%d\n",i))
    80000c0c:	00190913          	addi	s2,s2,1
    80000c10:	036967b3          	rem	a5,s2,s6
    80000c14:	fe0790e3          	bnez	a5,80000bf4 <freerange+0x80>
    80000c18:	00090593          	mv	a1,s2
    80000c1c:	000b8513          	mv	a0,s7
    80000c20:	00000097          	auipc	ra,0x0
    80000c24:	b14080e7          	jalr	-1260(ra) # 80000734 <printf>
    80000c28:	fcdff06f          	j	80000bf4 <freerange+0x80>
}
    80000c2c:	04813083          	ld	ra,72(sp)
    80000c30:	04013403          	ld	s0,64(sp)
    80000c34:	03813483          	ld	s1,56(sp)
    80000c38:	03013903          	ld	s2,48(sp)
    80000c3c:	02813983          	ld	s3,40(sp)
    80000c40:	02013a03          	ld	s4,32(sp)
    80000c44:	01813a83          	ld	s5,24(sp)
    80000c48:	01013b03          	ld	s6,16(sp)
    80000c4c:	00813b83          	ld	s7,8(sp)
    80000c50:	05010113          	addi	sp,sp,80
    80000c54:	00008067          	ret

0000000080000c58 <kinit>:
{
    80000c58:	ff010113          	addi	sp,sp,-16
    80000c5c:	00113423          	sd	ra,8(sp)
    80000c60:	00813023          	sd	s0,0(sp)
    80000c64:	01010413          	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000c68:	00007597          	auipc	a1,0x7
    80000c6c:	52058593          	addi	a1,a1,1312 # 80008188 <userret+0xe4>
    80000c70:	00011517          	auipc	a0,0x11
    80000c74:	c9850513          	addi	a0,a0,-872 # 80011908 <kmem>
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	0d8080e7          	jalr	216(ra) # 80000d50 <initlock>
  printf("Finish initlock\n");
    80000c80:	00007517          	auipc	a0,0x7
    80000c84:	51050513          	addi	a0,a0,1296 # 80008190 <userret+0xec>
    80000c88:	00000097          	auipc	ra,0x0
    80000c8c:	aac080e7          	jalr	-1364(ra) # 80000734 <printf>
  freerange(end, (void*)PHYSTOP);
    80000c90:	01100593          	li	a1,17
    80000c94:	01b59593          	slli	a1,a1,0x1b
    80000c98:	00022517          	auipc	a0,0x22
    80000c9c:	e5c50513          	addi	a0,a0,-420 # 80022af4 <end>
    80000ca0:	00000097          	auipc	ra,0x0
    80000ca4:	ed4080e7          	jalr	-300(ra) # 80000b74 <freerange>
  printf("Finish freerange\n");
    80000ca8:	00007517          	auipc	a0,0x7
    80000cac:	50050513          	addi	a0,a0,1280 # 800081a8 <userret+0x104>
    80000cb0:	00000097          	auipc	ra,0x0
    80000cb4:	a84080e7          	jalr	-1404(ra) # 80000734 <printf>
}
    80000cb8:	00813083          	ld	ra,8(sp)
    80000cbc:	00013403          	ld	s0,0(sp)
    80000cc0:	01010113          	addi	sp,sp,16
    80000cc4:	00008067          	ret

0000000080000cc8 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000cc8:	fe010113          	addi	sp,sp,-32
    80000ccc:	00113c23          	sd	ra,24(sp)
    80000cd0:	00813823          	sd	s0,16(sp)
    80000cd4:	00913423          	sd	s1,8(sp)
    80000cd8:	02010413          	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000cdc:	00011497          	auipc	s1,0x11
    80000ce0:	c2c48493          	addi	s1,s1,-980 # 80011908 <kmem>
    80000ce4:	00048513          	mv	a0,s1
    80000ce8:	00000097          	auipc	ra,0x0
    80000cec:	1f0080e7          	jalr	496(ra) # 80000ed8 <acquire>
  r = kmem.freelist;
    80000cf0:	0184b483          	ld	s1,24(s1)
  if(r)
    80000cf4:	04048463          	beqz	s1,80000d3c <kalloc+0x74>
    kmem.freelist = r->next;
    80000cf8:	0004b783          	ld	a5,0(s1)
    80000cfc:	00011517          	auipc	a0,0x11
    80000d00:	c0c50513          	addi	a0,a0,-1012 # 80011908 <kmem>
    80000d04:	00f53c23          	sd	a5,24(a0)
  release(&kmem.lock);
    80000d08:	00000097          	auipc	ra,0x0
    80000d0c:	248080e7          	jalr	584(ra) # 80000f50 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000d10:	00001637          	lui	a2,0x1
    80000d14:	00500593          	li	a1,5
    80000d18:	00048513          	mv	a0,s1
    80000d1c:	00000097          	auipc	ra,0x0
    80000d20:	294080e7          	jalr	660(ra) # 80000fb0 <memset>
  return (void*)r;
}
    80000d24:	00048513          	mv	a0,s1
    80000d28:	01813083          	ld	ra,24(sp)
    80000d2c:	01013403          	ld	s0,16(sp)
    80000d30:	00813483          	ld	s1,8(sp)
    80000d34:	02010113          	addi	sp,sp,32
    80000d38:	00008067          	ret
  release(&kmem.lock);
    80000d3c:	00011517          	auipc	a0,0x11
    80000d40:	bcc50513          	addi	a0,a0,-1076 # 80011908 <kmem>
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	20c080e7          	jalr	524(ra) # 80000f50 <release>
  if(r)
    80000d4c:	fd9ff06f          	j	80000d24 <kalloc+0x5c>

0000000080000d50 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000d50:	ff010113          	addi	sp,sp,-16
    80000d54:	00813423          	sd	s0,8(sp)
    80000d58:	01010413          	addi	s0,sp,16
  lk->name = name;
    80000d5c:	00b53423          	sd	a1,8(a0)
  lk->locked = 0;
    80000d60:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000d64:	00053823          	sd	zero,16(a0)
}
    80000d68:	00813403          	ld	s0,8(sp)
    80000d6c:	01010113          	addi	sp,sp,16
    80000d70:	00008067          	ret

0000000080000d74 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000d74:	fe010113          	addi	sp,sp,-32
    80000d78:	00113c23          	sd	ra,24(sp)
    80000d7c:	00813823          	sd	s0,16(sp)
    80000d80:	00913423          	sd	s1,8(sp)
    80000d84:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d88:	100024f3          	csrr	s1,sstatus
    80000d8c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000d90:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d94:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000d98:	00001097          	auipc	ra,0x1
    80000d9c:	5d0080e7          	jalr	1488(ra) # 80002368 <mycpu>
    80000da0:	07852783          	lw	a5,120(a0)
    80000da4:	02078663          	beqz	a5,80000dd0 <push_off+0x5c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000da8:	00001097          	auipc	ra,0x1
    80000dac:	5c0080e7          	jalr	1472(ra) # 80002368 <mycpu>
    80000db0:	07852783          	lw	a5,120(a0)
    80000db4:	0017879b          	addiw	a5,a5,1
    80000db8:	06f52c23          	sw	a5,120(a0)
}
    80000dbc:	01813083          	ld	ra,24(sp)
    80000dc0:	01013403          	ld	s0,16(sp)
    80000dc4:	00813483          	ld	s1,8(sp)
    80000dc8:	02010113          	addi	sp,sp,32
    80000dcc:	00008067          	ret
    mycpu()->intena = old;
    80000dd0:	00001097          	auipc	ra,0x1
    80000dd4:	598080e7          	jalr	1432(ra) # 80002368 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000dd8:	0014d493          	srli	s1,s1,0x1
    80000ddc:	0014f493          	andi	s1,s1,1
    80000de0:	06952e23          	sw	s1,124(a0)
    80000de4:	fc5ff06f          	j	80000da8 <push_off+0x34>

0000000080000de8 <pop_off>:

void
pop_off(void)
{
    80000de8:	ff010113          	addi	sp,sp,-16
    80000dec:	00113423          	sd	ra,8(sp)
    80000df0:	00813023          	sd	s0,0(sp)
    80000df4:	01010413          	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000df8:	00001097          	auipc	ra,0x1
    80000dfc:	570080e7          	jalr	1392(ra) # 80002368 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000e00:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000e04:	0027f793          	andi	a5,a5,2
  if(intr_get())
    80000e08:	04079663          	bnez	a5,80000e54 <pop_off+0x6c>
    panic("pop_off - interruptible");
  c->noff -= 1;
    80000e0c:	07852783          	lw	a5,120(a0)
    80000e10:	fff7879b          	addiw	a5,a5,-1
    80000e14:	0007871b          	sext.w	a4,a5
    80000e18:	06f52c23          	sw	a5,120(a0)
  if(c->noff < 0)
    80000e1c:	04074463          	bltz	a4,80000e64 <pop_off+0x7c>
    panic("pop_off");
  if(c->noff == 0 && c->intena)
    80000e20:	02071263          	bnez	a4,80000e44 <pop_off+0x5c>
    80000e24:	07c52783          	lw	a5,124(a0)
    80000e28:	00078e63          	beqz	a5,80000e44 <pop_off+0x5c>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000e2c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000e30:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80000e34:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000e38:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000e3c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000e40:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000e44:	00813083          	ld	ra,8(sp)
    80000e48:	00013403          	ld	s0,0(sp)
    80000e4c:	01010113          	addi	sp,sp,16
    80000e50:	00008067          	ret
    panic("pop_off - interruptible");
    80000e54:	00007517          	auipc	a0,0x7
    80000e58:	36c50513          	addi	a0,a0,876 # 800081c0 <userret+0x11c>
    80000e5c:	00000097          	auipc	ra,0x0
    80000e60:	87c080e7          	jalr	-1924(ra) # 800006d8 <panic>
    panic("pop_off");
    80000e64:	00007517          	auipc	a0,0x7
    80000e68:	37450513          	addi	a0,a0,884 # 800081d8 <userret+0x134>
    80000e6c:	00000097          	auipc	ra,0x0
    80000e70:	86c080e7          	jalr	-1940(ra) # 800006d8 <panic>

0000000080000e74 <holding>:
{
    80000e74:	fe010113          	addi	sp,sp,-32
    80000e78:	00113c23          	sd	ra,24(sp)
    80000e7c:	00813823          	sd	s0,16(sp)
    80000e80:	00913423          	sd	s1,8(sp)
    80000e84:	02010413          	addi	s0,sp,32
    80000e88:	00050493          	mv	s1,a0
  push_off();
    80000e8c:	00000097          	auipc	ra,0x0
    80000e90:	ee8080e7          	jalr	-280(ra) # 80000d74 <push_off>
  r = (lk->locked && lk->cpu == mycpu());
    80000e94:	0004a783          	lw	a5,0(s1)
    80000e98:	02079463          	bnez	a5,80000ec0 <holding+0x4c>
    80000e9c:	00000493          	li	s1,0
  pop_off();
    80000ea0:	00000097          	auipc	ra,0x0
    80000ea4:	f48080e7          	jalr	-184(ra) # 80000de8 <pop_off>
}
    80000ea8:	00048513          	mv	a0,s1
    80000eac:	01813083          	ld	ra,24(sp)
    80000eb0:	01013403          	ld	s0,16(sp)
    80000eb4:	00813483          	ld	s1,8(sp)
    80000eb8:	02010113          	addi	sp,sp,32
    80000ebc:	00008067          	ret
  r = (lk->locked && lk->cpu == mycpu());
    80000ec0:	0104b483          	ld	s1,16(s1)
    80000ec4:	00001097          	auipc	ra,0x1
    80000ec8:	4a4080e7          	jalr	1188(ra) # 80002368 <mycpu>
    80000ecc:	40a484b3          	sub	s1,s1,a0
    80000ed0:	0014b493          	seqz	s1,s1
    80000ed4:	fcdff06f          	j	80000ea0 <holding+0x2c>

0000000080000ed8 <acquire>:
{
    80000ed8:	fe010113          	addi	sp,sp,-32
    80000edc:	00113c23          	sd	ra,24(sp)
    80000ee0:	00813823          	sd	s0,16(sp)
    80000ee4:	00913423          	sd	s1,8(sp)
    80000ee8:	02010413          	addi	s0,sp,32
    80000eec:	00050493          	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000ef0:	00000097          	auipc	ra,0x0
    80000ef4:	e84080e7          	jalr	-380(ra) # 80000d74 <push_off>
  if(holding(lk))
    80000ef8:	00048513          	mv	a0,s1
    80000efc:	00000097          	auipc	ra,0x0
    80000f00:	f78080e7          	jalr	-136(ra) # 80000e74 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000f04:	00100713          	li	a4,1
  if(holding(lk))
    80000f08:	02051c63          	bnez	a0,80000f40 <acquire+0x68>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000f0c:	00070793          	mv	a5,a4
    80000f10:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000f14:	0007879b          	sext.w	a5,a5
    80000f18:	fe079ae3          	bnez	a5,80000f0c <acquire+0x34>
  __sync_synchronize();
    80000f1c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000f20:	00001097          	auipc	ra,0x1
    80000f24:	448080e7          	jalr	1096(ra) # 80002368 <mycpu>
    80000f28:	00a4b823          	sd	a0,16(s1)
}
    80000f2c:	01813083          	ld	ra,24(sp)
    80000f30:	01013403          	ld	s0,16(sp)
    80000f34:	00813483          	ld	s1,8(sp)
    80000f38:	02010113          	addi	sp,sp,32
    80000f3c:	00008067          	ret
    panic("acquire");
    80000f40:	00007517          	auipc	a0,0x7
    80000f44:	2a050513          	addi	a0,a0,672 # 800081e0 <userret+0x13c>
    80000f48:	fffff097          	auipc	ra,0xfffff
    80000f4c:	790080e7          	jalr	1936(ra) # 800006d8 <panic>

0000000080000f50 <release>:
{
    80000f50:	fe010113          	addi	sp,sp,-32
    80000f54:	00113c23          	sd	ra,24(sp)
    80000f58:	00813823          	sd	s0,16(sp)
    80000f5c:	00913423          	sd	s1,8(sp)
    80000f60:	02010413          	addi	s0,sp,32
    80000f64:	00050493          	mv	s1,a0
  if(!holding(lk))
    80000f68:	00000097          	auipc	ra,0x0
    80000f6c:	f0c080e7          	jalr	-244(ra) # 80000e74 <holding>
    80000f70:	02050863          	beqz	a0,80000fa0 <release+0x50>
  lk->cpu = 0;
    80000f74:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000f78:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000f7c:	0f50000f          	fence	iorw,ow
    80000f80:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000f84:	00000097          	auipc	ra,0x0
    80000f88:	e64080e7          	jalr	-412(ra) # 80000de8 <pop_off>
}
    80000f8c:	01813083          	ld	ra,24(sp)
    80000f90:	01013403          	ld	s0,16(sp)
    80000f94:	00813483          	ld	s1,8(sp)
    80000f98:	02010113          	addi	sp,sp,32
    80000f9c:	00008067          	ret
    panic("release");
    80000fa0:	00007517          	auipc	a0,0x7
    80000fa4:	24850513          	addi	a0,a0,584 # 800081e8 <userret+0x144>
    80000fa8:	fffff097          	auipc	ra,0xfffff
    80000fac:	730080e7          	jalr	1840(ra) # 800006d8 <panic>

0000000080000fb0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000fb0:	ff010113          	addi	sp,sp,-16
    80000fb4:	00813423          	sd	s0,8(sp)
    80000fb8:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000fbc:	02060063          	beqz	a2,80000fdc <memset+0x2c>
    80000fc0:	00050793          	mv	a5,a0
    80000fc4:	02061613          	slli	a2,a2,0x20
    80000fc8:	02065613          	srli	a2,a2,0x20
    80000fcc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000fd0:	00b78023          	sb	a1,0(a5) # fffffffffffff000 <end+0xffffffff7ffdc50c>
  for(i = 0; i < n; i++){
    80000fd4:	00178793          	addi	a5,a5,1
    80000fd8:	fee79ce3          	bne	a5,a4,80000fd0 <memset+0x20>
  }
  return dst;
}
    80000fdc:	00813403          	ld	s0,8(sp)
    80000fe0:	01010113          	addi	sp,sp,16
    80000fe4:	00008067          	ret

0000000080000fe8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000fe8:	ff010113          	addi	sp,sp,-16
    80000fec:	00813423          	sd	s0,8(sp)
    80000ff0:	01010413          	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000ff4:	04060463          	beqz	a2,8000103c <memcmp+0x54>
    80000ff8:	fff6069b          	addiw	a3,a2,-1
    80000ffc:	02069693          	slli	a3,a3,0x20
    80001000:	0206d693          	srli	a3,a3,0x20
    80001004:	00168693          	addi	a3,a3,1
    80001008:	00d506b3          	add	a3,a0,a3
    if(*s1 != *s2)
    8000100c:	00054783          	lbu	a5,0(a0)
    80001010:	0005c703          	lbu	a4,0(a1)
    80001014:	00e79c63          	bne	a5,a4,8000102c <memcmp+0x44>
      return *s1 - *s2;
    s1++, s2++;
    80001018:	00150513          	addi	a0,a0,1
    8000101c:	00158593          	addi	a1,a1,1
  while(n-- > 0){
    80001020:	fed516e3          	bne	a0,a3,8000100c <memcmp+0x24>
  }

  return 0;
    80001024:	00000513          	li	a0,0
    80001028:	0080006f          	j	80001030 <memcmp+0x48>
      return *s1 - *s2;
    8000102c:	40e7853b          	subw	a0,a5,a4
}
    80001030:	00813403          	ld	s0,8(sp)
    80001034:	01010113          	addi	sp,sp,16
    80001038:	00008067          	ret
  return 0;
    8000103c:	00000513          	li	a0,0
    80001040:	ff1ff06f          	j	80001030 <memcmp+0x48>

0000000080001044 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80001044:	ff010113          	addi	sp,sp,-16
    80001048:	00813423          	sd	s0,8(sp)
    8000104c:	01010413          	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80001050:	04a5e063          	bltu	a1,a0,80001090 <memmove+0x4c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80001054:	fff6069b          	addiw	a3,a2,-1
    80001058:	02060663          	beqz	a2,80001084 <memmove+0x40>
    8000105c:	02069693          	slli	a3,a3,0x20
    80001060:	0206d693          	srli	a3,a3,0x20
    80001064:	00168693          	addi	a3,a3,1
    80001068:	00d586b3          	add	a3,a1,a3
    8000106c:	00050793          	mv	a5,a0
      *d++ = *s++;
    80001070:	00158593          	addi	a1,a1,1
    80001074:	00178793          	addi	a5,a5,1
    80001078:	fff5c703          	lbu	a4,-1(a1)
    8000107c:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80001080:	fed598e3          	bne	a1,a3,80001070 <memmove+0x2c>

  return dst;
}
    80001084:	00813403          	ld	s0,8(sp)
    80001088:	01010113          	addi	sp,sp,16
    8000108c:	00008067          	ret
  if(s < d && s + n > d){
    80001090:	02061713          	slli	a4,a2,0x20
    80001094:	02075713          	srli	a4,a4,0x20
    80001098:	00e587b3          	add	a5,a1,a4
    8000109c:	faf57ce3          	bgeu	a0,a5,80001054 <memmove+0x10>
    d += n;
    800010a0:	00e50733          	add	a4,a0,a4
    while(n-- > 0)
    800010a4:	fff6069b          	addiw	a3,a2,-1
    800010a8:	fc060ee3          	beqz	a2,80001084 <memmove+0x40>
    800010ac:	02069613          	slli	a2,a3,0x20
    800010b0:	02065613          	srli	a2,a2,0x20
    800010b4:	fff64613          	not	a2,a2
    800010b8:	00c78633          	add	a2,a5,a2
      *--d = *--s;
    800010bc:	fff78793          	addi	a5,a5,-1
    800010c0:	fff70713          	addi	a4,a4,-1
    800010c4:	0007c683          	lbu	a3,0(a5)
    800010c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    800010cc:	fef618e3          	bne	a2,a5,800010bc <memmove+0x78>
    800010d0:	fb5ff06f          	j	80001084 <memmove+0x40>

00000000800010d4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800010d4:	ff010113          	addi	sp,sp,-16
    800010d8:	00113423          	sd	ra,8(sp)
    800010dc:	00813023          	sd	s0,0(sp)
    800010e0:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	f60080e7          	jalr	-160(ra) # 80001044 <memmove>
}
    800010ec:	00813083          	ld	ra,8(sp)
    800010f0:	00013403          	ld	s0,0(sp)
    800010f4:	01010113          	addi	sp,sp,16
    800010f8:	00008067          	ret

00000000800010fc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800010fc:	ff010113          	addi	sp,sp,-16
    80001100:	00813423          	sd	s0,8(sp)
    80001104:	01010413          	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80001108:	02060663          	beqz	a2,80001134 <strncmp+0x38>
    8000110c:	00054783          	lbu	a5,0(a0)
    80001110:	02078663          	beqz	a5,8000113c <strncmp+0x40>
    80001114:	0005c703          	lbu	a4,0(a1)
    80001118:	02f71263          	bne	a4,a5,8000113c <strncmp+0x40>
    n--, p++, q++;
    8000111c:	fff6061b          	addiw	a2,a2,-1
    80001120:	00150513          	addi	a0,a0,1
    80001124:	00158593          	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80001128:	fe0612e3          	bnez	a2,8000110c <strncmp+0x10>
  if(n == 0)
    return 0;
    8000112c:	00000513          	li	a0,0
    80001130:	01c0006f          	j	8000114c <strncmp+0x50>
    80001134:	00000513          	li	a0,0
    80001138:	0140006f          	j	8000114c <strncmp+0x50>
  if(n == 0)
    8000113c:	00060e63          	beqz	a2,80001158 <strncmp+0x5c>
  return (uchar)*p - (uchar)*q;
    80001140:	00054503          	lbu	a0,0(a0)
    80001144:	0005c783          	lbu	a5,0(a1)
    80001148:	40f5053b          	subw	a0,a0,a5
}
    8000114c:	00813403          	ld	s0,8(sp)
    80001150:	01010113          	addi	sp,sp,16
    80001154:	00008067          	ret
    return 0;
    80001158:	00000513          	li	a0,0
    8000115c:	ff1ff06f          	j	8000114c <strncmp+0x50>

0000000080001160 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80001160:	ff010113          	addi	sp,sp,-16
    80001164:	00813423          	sd	s0,8(sp)
    80001168:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000116c:	00050713          	mv	a4,a0
    80001170:	00060813          	mv	a6,a2
    80001174:	fff6061b          	addiw	a2,a2,-1
    80001178:	01005c63          	blez	a6,80001190 <strncpy+0x30>
    8000117c:	00170713          	addi	a4,a4,1
    80001180:	0005c783          	lbu	a5,0(a1)
    80001184:	fef70fa3          	sb	a5,-1(a4)
    80001188:	00158593          	addi	a1,a1,1
    8000118c:	fe0792e3          	bnez	a5,80001170 <strncpy+0x10>
    ;
  while(n-- > 0)
    80001190:	00070693          	mv	a3,a4
    80001194:	00c05e63          	blez	a2,800011b0 <strncpy+0x50>
    *s++ = 0;
    80001198:	00168693          	addi	a3,a3,1
    8000119c:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800011a0:	40d707bb          	subw	a5,a4,a3
    800011a4:	fff7879b          	addiw	a5,a5,-1
    800011a8:	010787bb          	addw	a5,a5,a6
    800011ac:	fef046e3          	bgtz	a5,80001198 <strncpy+0x38>
  return os;
}
    800011b0:	00813403          	ld	s0,8(sp)
    800011b4:	01010113          	addi	sp,sp,16
    800011b8:	00008067          	ret

00000000800011bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800011bc:	ff010113          	addi	sp,sp,-16
    800011c0:	00813423          	sd	s0,8(sp)
    800011c4:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800011c8:	02c05a63          	blez	a2,800011fc <safestrcpy+0x40>
    800011cc:	fff6069b          	addiw	a3,a2,-1
    800011d0:	02069693          	slli	a3,a3,0x20
    800011d4:	0206d693          	srli	a3,a3,0x20
    800011d8:	00d586b3          	add	a3,a1,a3
    800011dc:	00050793          	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800011e0:	00d58c63          	beq	a1,a3,800011f8 <safestrcpy+0x3c>
    800011e4:	00158593          	addi	a1,a1,1
    800011e8:	00178793          	addi	a5,a5,1
    800011ec:	fff5c703          	lbu	a4,-1(a1)
    800011f0:	fee78fa3          	sb	a4,-1(a5)
    800011f4:	fe0716e3          	bnez	a4,800011e0 <safestrcpy+0x24>
    ;
  *s = 0;
    800011f8:	00078023          	sb	zero,0(a5)
  return os;
}
    800011fc:	00813403          	ld	s0,8(sp)
    80001200:	01010113          	addi	sp,sp,16
    80001204:	00008067          	ret

0000000080001208 <strlen>:

int
strlen(const char *s)
{
    80001208:	ff010113          	addi	sp,sp,-16
    8000120c:	00813423          	sd	s0,8(sp)
    80001210:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80001214:	00054783          	lbu	a5,0(a0)
    80001218:	02078863          	beqz	a5,80001248 <strlen+0x40>
    8000121c:	00150513          	addi	a0,a0,1
    80001220:	00050793          	mv	a5,a0
    80001224:	00100693          	li	a3,1
    80001228:	40a686bb          	subw	a3,a3,a0
    8000122c:	00f6853b          	addw	a0,a3,a5
    80001230:	00178793          	addi	a5,a5,1
    80001234:	fff7c703          	lbu	a4,-1(a5)
    80001238:	fe071ae3          	bnez	a4,8000122c <strlen+0x24>
    ;
  return n;
}
    8000123c:	00813403          	ld	s0,8(sp)
    80001240:	01010113          	addi	sp,sp,16
    80001244:	00008067          	ret
  for(n = 0; s[n]; n++)
    80001248:	00000513          	li	a0,0
    8000124c:	ff1ff06f          	j	8000123c <strlen+0x34>

0000000080001250 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80001250:	ff010113          	addi	sp,sp,-16
    80001254:	00113423          	sd	ra,8(sp)
    80001258:	00813023          	sd	s0,0(sp)
    8000125c:	01010413          	addi	s0,sp,16
  if(cpuid() == 0){
    80001260:	00001097          	auipc	ra,0x1
    80001264:	0e8080e7          	jalr	232(ra) # 80002348 <cpuid>
    __sync_synchronize();
    printf("\tFinish __sync_synchronize()\n");
    started = 1;
    printf("\tFinish started = 1\n");
  } else {
    while(started == 0)
    80001268:	00022717          	auipc	a4,0x22
    8000126c:	87470713          	addi	a4,a4,-1932 # 80022adc <started>
  if(cpuid() == 0){
    80001270:	04050463          	beqz	a0,800012b8 <main+0x68>
    while(started == 0)
    80001274:	00072783          	lw	a5,0(a4)
    80001278:	0007879b          	sext.w	a5,a5
    8000127c:	fe078ce3          	beqz	a5,80001274 <main+0x24>
      ;
    __sync_synchronize();
    80001280:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80001284:	00001097          	auipc	ra,0x1
    80001288:	0c4080e7          	jalr	196(ra) # 80002348 <cpuid>
    8000128c:	00050593          	mv	a1,a0
    80001290:	00007517          	auipc	a0,0x7
    80001294:	0a050513          	addi	a0,a0,160 # 80008330 <userret+0x28c>
    80001298:	fffff097          	auipc	ra,0xfffff
    8000129c:	49c080e7          	jalr	1180(ra) # 80000734 <printf>
    kvminithart();    // turn on paging
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	334080e7          	jalr	820(ra) # 800015d4 <kvminithart>
    trapinithart();   // install kernel trap vector
    800012a8:	00002097          	auipc	ra,0x2
    800012ac:	198080e7          	jalr	408(ra) # 80003440 <trapinithart>
    //plicinithart();   // ask PLIC for device interrupts
  }

  scheduler();        
    800012b0:	00001097          	auipc	ra,0x1
    800012b4:	7dc080e7          	jalr	2012(ra) # 80002a8c <scheduler>
    consoleinit();
    800012b8:	fffff097          	auipc	ra,0xfffff
    800012bc:	2e0080e7          	jalr	736(ra) # 80000598 <consoleinit>
    printfinit();
    800012c0:	fffff097          	auipc	ra,0xfffff
    800012c4:	6e0080e7          	jalr	1760(ra) # 800009a0 <printfinit>
    printf("\n");
    800012c8:	00007517          	auipc	a0,0x7
    800012cc:	ef050513          	addi	a0,a0,-272 # 800081b8 <userret+0x114>
    800012d0:	fffff097          	auipc	ra,0xfffff
    800012d4:	464080e7          	jalr	1124(ra) # 80000734 <printf>
    printf("xv6 kernel is booting\n");
    800012d8:	00007517          	auipc	a0,0x7
    800012dc:	f1850513          	addi	a0,a0,-232 # 800081f0 <userret+0x14c>
    800012e0:	fffff097          	auipc	ra,0xfffff
    800012e4:	454080e7          	jalr	1108(ra) # 80000734 <printf>
    printf("\n");
    800012e8:	00007517          	auipc	a0,0x7
    800012ec:	ed050513          	addi	a0,a0,-304 # 800081b8 <userret+0x114>
    800012f0:	fffff097          	auipc	ra,0xfffff
    800012f4:	444080e7          	jalr	1092(ra) # 80000734 <printf>
    kinit();         // physical page allocator
    800012f8:	00000097          	auipc	ra,0x0
    800012fc:	960080e7          	jalr	-1696(ra) # 80000c58 <kinit>
    printf("\tFinish kinit()\n");
    80001300:	00007517          	auipc	a0,0x7
    80001304:	f0850513          	addi	a0,a0,-248 # 80008208 <userret+0x164>
    80001308:	fffff097          	auipc	ra,0xfffff
    8000130c:	42c080e7          	jalr	1068(ra) # 80000734 <printf>
    kvminit();       // create kernel page table
    80001310:	00000097          	auipc	ra,0x0
    80001314:	520080e7          	jalr	1312(ra) # 80001830 <kvminit>
    printf("\tFinish kvminit()\n");
    80001318:	00007517          	auipc	a0,0x7
    8000131c:	f0850513          	addi	a0,a0,-248 # 80008220 <userret+0x17c>
    80001320:	fffff097          	auipc	ra,0xfffff
    80001324:	414080e7          	jalr	1044(ra) # 80000734 <printf>
    kvminithart();   // turn on paging
    80001328:	00000097          	auipc	ra,0x0
    8000132c:	2ac080e7          	jalr	684(ra) # 800015d4 <kvminithart>
    printf("\tFinish kvminithart()\n");
    80001330:	00007517          	auipc	a0,0x7
    80001334:	f0850513          	addi	a0,a0,-248 # 80008238 <userret+0x194>
    80001338:	fffff097          	auipc	ra,0xfffff
    8000133c:	3fc080e7          	jalr	1020(ra) # 80000734 <printf>
    procinit();      // process table
    80001340:	00001097          	auipc	ra,0x1
    80001344:	ef4080e7          	jalr	-268(ra) # 80002234 <procinit>
    printf("\tFinish procinit()\n");
    80001348:	00007517          	auipc	a0,0x7
    8000134c:	f0850513          	addi	a0,a0,-248 # 80008250 <userret+0x1ac>
    80001350:	fffff097          	auipc	ra,0xfffff
    80001354:	3e4080e7          	jalr	996(ra) # 80000734 <printf>
    trapinit();      // trap vectors
    80001358:	00002097          	auipc	ra,0x2
    8000135c:	0b0080e7          	jalr	176(ra) # 80003408 <trapinit>
    printf("\tFinish trapinit()\n");
    80001360:	00007517          	auipc	a0,0x7
    80001364:	f0850513          	addi	a0,a0,-248 # 80008268 <userret+0x1c4>
    80001368:	fffff097          	auipc	ra,0xfffff
    8000136c:	3cc080e7          	jalr	972(ra) # 80000734 <printf>
    trapinithart();  // install kernel trap vector
    80001370:	00002097          	auipc	ra,0x2
    80001374:	0d0080e7          	jalr	208(ra) # 80003440 <trapinithart>
    printf("\tFinish trapinithart()\n");
    80001378:	00007517          	auipc	a0,0x7
    8000137c:	f0850513          	addi	a0,a0,-248 # 80008280 <userret+0x1dc>
    80001380:	fffff097          	auipc	ra,0xfffff
    80001384:	3b4080e7          	jalr	948(ra) # 80000734 <printf>
    binit();         // buffer cache
    80001388:	00003097          	auipc	ra,0x3
    8000138c:	afc080e7          	jalr	-1284(ra) # 80003e84 <binit>
    printf("\tFinish binit()\n");
    80001390:	00007517          	auipc	a0,0x7
    80001394:	f0850513          	addi	a0,a0,-248 # 80008298 <userret+0x1f4>
    80001398:	fffff097          	auipc	ra,0xfffff
    8000139c:	39c080e7          	jalr	924(ra) # 80000734 <printf>
    iinit();         // inode cache
    800013a0:	00003097          	auipc	ra,0x3
    800013a4:	3cc080e7          	jalr	972(ra) # 8000476c <iinit>
    printf("\tFinish iinit()\n");
    800013a8:	00007517          	auipc	a0,0x7
    800013ac:	f0850513          	addi	a0,a0,-248 # 800082b0 <userret+0x20c>
    800013b0:	fffff097          	auipc	ra,0xfffff
    800013b4:	384080e7          	jalr	900(ra) # 80000734 <printf>
    fileinit();      // file table
    800013b8:	00005097          	auipc	ra,0x5
    800013bc:	958080e7          	jalr	-1704(ra) # 80005d10 <fileinit>
    printf("\tFinish iinit()\n");
    800013c0:	00007517          	auipc	a0,0x7
    800013c4:	ef050513          	addi	a0,a0,-272 # 800082b0 <userret+0x20c>
    800013c8:	fffff097          	auipc	ra,0xfffff
    800013cc:	36c080e7          	jalr	876(ra) # 80000734 <printf>
    ramdiskinit(); // emulated hard disk
    800013d0:	00005097          	auipc	ra,0x5
    800013d4:	398080e7          	jalr	920(ra) # 80006768 <ramdiskinit>
    printf("\tFinish ramdiskinit()\n");
    800013d8:	00007517          	auipc	a0,0x7
    800013dc:	ef050513          	addi	a0,a0,-272 # 800082c8 <userret+0x224>
    800013e0:	fffff097          	auipc	ra,0xfffff
    800013e4:	354080e7          	jalr	852(ra) # 80000734 <printf>
    userinit();      // first user process
    800013e8:	00001097          	auipc	ra,0x1
    800013ec:	344080e7          	jalr	836(ra) # 8000272c <userinit>
    printf("\tFinish userinit()\n");
    800013f0:	00007517          	auipc	a0,0x7
    800013f4:	ef050513          	addi	a0,a0,-272 # 800082e0 <userret+0x23c>
    800013f8:	fffff097          	auipc	ra,0xfffff
    800013fc:	33c080e7          	jalr	828(ra) # 80000734 <printf>
    __sync_synchronize();
    80001400:	0ff0000f          	fence
    printf("\tFinish __sync_synchronize()\n");
    80001404:	00007517          	auipc	a0,0x7
    80001408:	ef450513          	addi	a0,a0,-268 # 800082f8 <userret+0x254>
    8000140c:	fffff097          	auipc	ra,0xfffff
    80001410:	328080e7          	jalr	808(ra) # 80000734 <printf>
    started = 1;
    80001414:	00100793          	li	a5,1
    80001418:	00021717          	auipc	a4,0x21
    8000141c:	6cf72223          	sw	a5,1732(a4) # 80022adc <started>
    printf("\tFinish started = 1\n");
    80001420:	00007517          	auipc	a0,0x7
    80001424:	ef850513          	addi	a0,a0,-264 # 80008318 <userret+0x274>
    80001428:	fffff097          	auipc	ra,0xfffff
    8000142c:	30c080e7          	jalr	780(ra) # 80000734 <printf>
    80001430:	e81ff06f          	j	800012b0 <main+0x60>

0000000080001434 <walk>:
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001434:	fc010113          	addi	sp,sp,-64
    80001438:	02113c23          	sd	ra,56(sp)
    8000143c:	02813823          	sd	s0,48(sp)
    80001440:	02913423          	sd	s1,40(sp)
    80001444:	03213023          	sd	s2,32(sp)
    80001448:	01313c23          	sd	s3,24(sp)
    8000144c:	01413823          	sd	s4,16(sp)
    80001450:	01513423          	sd	s5,8(sp)
    80001454:	01613023          	sd	s6,0(sp)
    80001458:	04010413          	addi	s0,sp,64
    8000145c:	00050493          	mv	s1,a0
    80001460:	00058993          	mv	s3,a1
    80001464:	00060a93          	mv	s5,a2
  if(va >= MAXVA)
    80001468:	fff00793          	li	a5,-1
    8000146c:	01a7d793          	srli	a5,a5,0x1a
    80001470:	01e00a13          	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001474:	00c00b13          	li	s6,12
  if(va >= MAXVA)
    80001478:	04b7f863          	bgeu	a5,a1,800014c8 <walk+0x94>
    panic("walk");
    8000147c:	00007517          	auipc	a0,0x7
    80001480:	ecc50513          	addi	a0,a0,-308 # 80008348 <userret+0x2a4>
    80001484:	fffff097          	auipc	ra,0xfffff
    80001488:	254080e7          	jalr	596(ra) # 800006d8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000148c:	080a8e63          	beqz	s5,80001528 <walk+0xf4>
    80001490:	00000097          	auipc	ra,0x0
    80001494:	838080e7          	jalr	-1992(ra) # 80000cc8 <kalloc>
    80001498:	00050493          	mv	s1,a0
    8000149c:	06050263          	beqz	a0,80001500 <walk+0xcc>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800014a0:	00001637          	lui	a2,0x1
    800014a4:	00000593          	li	a1,0
    800014a8:	00000097          	auipc	ra,0x0
    800014ac:	b08080e7          	jalr	-1272(ra) # 80000fb0 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800014b0:	00c4d793          	srli	a5,s1,0xc
    800014b4:	00a79793          	slli	a5,a5,0xa
    800014b8:	0017e793          	ori	a5,a5,1
    800014bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800014c0:	ff7a0a1b          	addiw	s4,s4,-9
    800014c4:	036a0663          	beq	s4,s6,800014f0 <walk+0xbc>
    pte_t *pte = &pagetable[PX(level, va)];
    800014c8:	0149d933          	srl	s2,s3,s4
    800014cc:	1ff97913          	andi	s2,s2,511
    800014d0:	00391913          	slli	s2,s2,0x3
    800014d4:	01248933          	add	s2,s1,s2
    if(*pte & PTE_V) {
    800014d8:	00093483          	ld	s1,0(s2)
    800014dc:	0014f793          	andi	a5,s1,1
    800014e0:	fa0786e3          	beqz	a5,8000148c <walk+0x58>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800014e4:	00a4d493          	srli	s1,s1,0xa
    800014e8:	00c49493          	slli	s1,s1,0xc
    800014ec:	fd5ff06f          	j	800014c0 <walk+0x8c>
    }
  }
  return &pagetable[PX(0, va)];
    800014f0:	00c9d513          	srli	a0,s3,0xc
    800014f4:	1ff57513          	andi	a0,a0,511
    800014f8:	00351513          	slli	a0,a0,0x3
    800014fc:	00a48533          	add	a0,s1,a0
}
    80001500:	03813083          	ld	ra,56(sp)
    80001504:	03013403          	ld	s0,48(sp)
    80001508:	02813483          	ld	s1,40(sp)
    8000150c:	02013903          	ld	s2,32(sp)
    80001510:	01813983          	ld	s3,24(sp)
    80001514:	01013a03          	ld	s4,16(sp)
    80001518:	00813a83          	ld	s5,8(sp)
    8000151c:	00013b03          	ld	s6,0(sp)
    80001520:	04010113          	addi	sp,sp,64
    80001524:	00008067          	ret
        return 0;
    80001528:	00000513          	li	a0,0
    8000152c:	fd5ff06f          	j	80001500 <walk+0xcc>

0000000080001530 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    80001530:	fd010113          	addi	sp,sp,-48
    80001534:	02113423          	sd	ra,40(sp)
    80001538:	02813023          	sd	s0,32(sp)
    8000153c:	00913c23          	sd	s1,24(sp)
    80001540:	01213823          	sd	s2,16(sp)
    80001544:	01313423          	sd	s3,8(sp)
    80001548:	01413023          	sd	s4,0(sp)
    8000154c:	03010413          	addi	s0,sp,48
    80001550:	00050a13          	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001554:	00050493          	mv	s1,a0
    80001558:	00001937          	lui	s2,0x1
    8000155c:	01250933          	add	s2,a0,s2
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001560:	00100993          	li	s3,1
    80001564:	0200006f          	j	80001584 <freewalk+0x54>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001568:	00a7d793          	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000156c:	00c79513          	slli	a0,a5,0xc
    80001570:	00000097          	auipc	ra,0x0
    80001574:	fc0080e7          	jalr	-64(ra) # 80001530 <freewalk>
      pagetable[i] = 0;
    80001578:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000157c:	00848493          	addi	s1,s1,8
    80001580:	03248463          	beq	s1,s2,800015a8 <freewalk+0x78>
    pte_t pte = pagetable[i];
    80001584:	0004b783          	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001588:	00f7f713          	andi	a4,a5,15
    8000158c:	fd370ee3          	beq	a4,s3,80001568 <freewalk+0x38>
    } else if(pte & PTE_V){
    80001590:	0017f793          	andi	a5,a5,1
    80001594:	fe0784e3          	beqz	a5,8000157c <freewalk+0x4c>
      panic("freewalk: leaf");
    80001598:	00007517          	auipc	a0,0x7
    8000159c:	db850513          	addi	a0,a0,-584 # 80008350 <userret+0x2ac>
    800015a0:	fffff097          	auipc	ra,0xfffff
    800015a4:	138080e7          	jalr	312(ra) # 800006d8 <panic>
    }
  }
  kfree((void*)pagetable);
    800015a8:	000a0513          	mv	a0,s4
    800015ac:	fffff097          	auipc	ra,0xfffff
    800015b0:	538080e7          	jalr	1336(ra) # 80000ae4 <kfree>
}
    800015b4:	02813083          	ld	ra,40(sp)
    800015b8:	02013403          	ld	s0,32(sp)
    800015bc:	01813483          	ld	s1,24(sp)
    800015c0:	01013903          	ld	s2,16(sp)
    800015c4:	00813983          	ld	s3,8(sp)
    800015c8:	00013a03          	ld	s4,0(sp)
    800015cc:	03010113          	addi	sp,sp,48
    800015d0:	00008067          	ret

00000000800015d4 <kvminithart>:
{
    800015d4:	ff010113          	addi	sp,sp,-16
    800015d8:	00813423          	sd	s0,8(sp)
    800015dc:	01010413          	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800015e0:	00021797          	auipc	a5,0x21
    800015e4:	5007b783          	ld	a5,1280(a5) # 80022ae0 <kernel_pagetable>
    800015e8:	00c7d793          	srli	a5,a5,0xc
    800015ec:	fff00713          	li	a4,-1
    800015f0:	03f71713          	slli	a4,a4,0x3f
    800015f4:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800015f8:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800015fc:	12000073          	sfence.vma
}
    80001600:	00813403          	ld	s0,8(sp)
    80001604:	01010113          	addi	sp,sp,16
    80001608:	00008067          	ret

000000008000160c <walkaddr>:
  if(va >= MAXVA)
    8000160c:	fff00793          	li	a5,-1
    80001610:	01a7d793          	srli	a5,a5,0x1a
    80001614:	00b7f663          	bgeu	a5,a1,80001620 <walkaddr+0x14>
    return 0;
    80001618:	00000513          	li	a0,0
}
    8000161c:	00008067          	ret
{
    80001620:	ff010113          	addi	sp,sp,-16
    80001624:	00113423          	sd	ra,8(sp)
    80001628:	00813023          	sd	s0,0(sp)
    8000162c:	01010413          	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001630:	00000613          	li	a2,0
    80001634:	00000097          	auipc	ra,0x0
    80001638:	e00080e7          	jalr	-512(ra) # 80001434 <walk>
  if(pte == 0)
    8000163c:	02050a63          	beqz	a0,80001670 <walkaddr+0x64>
  if((*pte & PTE_V) == 0)
    80001640:	00053783          	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001644:	0117f693          	andi	a3,a5,17
    80001648:	01100713          	li	a4,17
    return 0;
    8000164c:	00000513          	li	a0,0
  if((*pte & PTE_U) == 0)
    80001650:	00e68a63          	beq	a3,a4,80001664 <walkaddr+0x58>
}
    80001654:	00813083          	ld	ra,8(sp)
    80001658:	00013403          	ld	s0,0(sp)
    8000165c:	01010113          	addi	sp,sp,16
    80001660:	00008067          	ret
  pa = PTE2PA(*pte);
    80001664:	00a7d793          	srli	a5,a5,0xa
    80001668:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000166c:	fe9ff06f          	j	80001654 <walkaddr+0x48>
    return 0;
    80001670:	00000513          	li	a0,0
    80001674:	fe1ff06f          	j	80001654 <walkaddr+0x48>

0000000080001678 <kvmpa>:
{
    80001678:	fe010113          	addi	sp,sp,-32
    8000167c:	00113c23          	sd	ra,24(sp)
    80001680:	00813823          	sd	s0,16(sp)
    80001684:	00913423          	sd	s1,8(sp)
    80001688:	02010413          	addi	s0,sp,32
    8000168c:	00050593          	mv	a1,a0
  uint64 off = va % PGSIZE;
    80001690:	03451513          	slli	a0,a0,0x34
    80001694:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    80001698:	00000613          	li	a2,0
    8000169c:	00021517          	auipc	a0,0x21
    800016a0:	44453503          	ld	a0,1092(a0) # 80022ae0 <kernel_pagetable>
    800016a4:	00000097          	auipc	ra,0x0
    800016a8:	d90080e7          	jalr	-624(ra) # 80001434 <walk>
  if(pte == 0)
    800016ac:	02050863          	beqz	a0,800016dc <kvmpa+0x64>
  if((*pte & PTE_V) == 0)
    800016b0:	00053503          	ld	a0,0(a0)
    800016b4:	00157793          	andi	a5,a0,1
    800016b8:	02078a63          	beqz	a5,800016ec <kvmpa+0x74>
  pa = PTE2PA(*pte);
    800016bc:	00a55513          	srli	a0,a0,0xa
    800016c0:	00c51513          	slli	a0,a0,0xc
}
    800016c4:	00950533          	add	a0,a0,s1
    800016c8:	01813083          	ld	ra,24(sp)
    800016cc:	01013403          	ld	s0,16(sp)
    800016d0:	00813483          	ld	s1,8(sp)
    800016d4:	02010113          	addi	sp,sp,32
    800016d8:	00008067          	ret
    panic("kvmpa");
    800016dc:	00007517          	auipc	a0,0x7
    800016e0:	c8450513          	addi	a0,a0,-892 # 80008360 <userret+0x2bc>
    800016e4:	fffff097          	auipc	ra,0xfffff
    800016e8:	ff4080e7          	jalr	-12(ra) # 800006d8 <panic>
    panic("kvmpa");
    800016ec:	00007517          	auipc	a0,0x7
    800016f0:	c7450513          	addi	a0,a0,-908 # 80008360 <userret+0x2bc>
    800016f4:	fffff097          	auipc	ra,0xfffff
    800016f8:	fe4080e7          	jalr	-28(ra) # 800006d8 <panic>

00000000800016fc <mappages>:
{
    800016fc:	fb010113          	addi	sp,sp,-80
    80001700:	04113423          	sd	ra,72(sp)
    80001704:	04813023          	sd	s0,64(sp)
    80001708:	02913c23          	sd	s1,56(sp)
    8000170c:	03213823          	sd	s2,48(sp)
    80001710:	03313423          	sd	s3,40(sp)
    80001714:	03413023          	sd	s4,32(sp)
    80001718:	01513c23          	sd	s5,24(sp)
    8000171c:	01613823          	sd	s6,16(sp)
    80001720:	01713423          	sd	s7,8(sp)
    80001724:	05010413          	addi	s0,sp,80
    80001728:	00050a93          	mv	s5,a0
    8000172c:	00070b13          	mv	s6,a4
  a = PGROUNDDOWN(va);
    80001730:	fffff737          	lui	a4,0xfffff
    80001734:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001738:	fff60993          	addi	s3,a2,-1 # fff <_entry-0x7ffff001>
    8000173c:	00b989b3          	add	s3,s3,a1
    80001740:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001744:	00078913          	mv	s2,a5
    80001748:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    8000174c:	00001bb7          	lui	s7,0x1
    80001750:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001754:	00100613          	li	a2,1
    80001758:	00090593          	mv	a1,s2
    8000175c:	000a8513          	mv	a0,s5
    80001760:	00000097          	auipc	ra,0x0
    80001764:	cd4080e7          	jalr	-812(ra) # 80001434 <walk>
    80001768:	04050063          	beqz	a0,800017a8 <mappages+0xac>
    if(*pte & PTE_V)
    8000176c:	00053783          	ld	a5,0(a0)
    80001770:	0017f793          	andi	a5,a5,1
    80001774:	02079263          	bnez	a5,80001798 <mappages+0x9c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001778:	00c4d493          	srli	s1,s1,0xc
    8000177c:	00a49493          	slli	s1,s1,0xa
    80001780:	0164e4b3          	or	s1,s1,s6
    80001784:	0014e493          	ori	s1,s1,1
    80001788:	00953023          	sd	s1,0(a0)
    if(a == last)
    8000178c:	05390663          	beq	s2,s3,800017d8 <mappages+0xdc>
    a += PGSIZE;
    80001790:	01790933          	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001794:	fbdff06f          	j	80001750 <mappages+0x54>
      panic("remap");
    80001798:	00007517          	auipc	a0,0x7
    8000179c:	bd050513          	addi	a0,a0,-1072 # 80008368 <userret+0x2c4>
    800017a0:	fffff097          	auipc	ra,0xfffff
    800017a4:	f38080e7          	jalr	-200(ra) # 800006d8 <panic>
      return -1;
    800017a8:	fff00513          	li	a0,-1
}
    800017ac:	04813083          	ld	ra,72(sp)
    800017b0:	04013403          	ld	s0,64(sp)
    800017b4:	03813483          	ld	s1,56(sp)
    800017b8:	03013903          	ld	s2,48(sp)
    800017bc:	02813983          	ld	s3,40(sp)
    800017c0:	02013a03          	ld	s4,32(sp)
    800017c4:	01813a83          	ld	s5,24(sp)
    800017c8:	01013b03          	ld	s6,16(sp)
    800017cc:	00813b83          	ld	s7,8(sp)
    800017d0:	05010113          	addi	sp,sp,80
    800017d4:	00008067          	ret
  return 0;
    800017d8:	00000513          	li	a0,0
    800017dc:	fd1ff06f          	j	800017ac <mappages+0xb0>

00000000800017e0 <kvmmap>:
{
    800017e0:	ff010113          	addi	sp,sp,-16
    800017e4:	00113423          	sd	ra,8(sp)
    800017e8:	00813023          	sd	s0,0(sp)
    800017ec:	01010413          	addi	s0,sp,16
    800017f0:	00068713          	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800017f4:	00058693          	mv	a3,a1
    800017f8:	00050593          	mv	a1,a0
    800017fc:	00021517          	auipc	a0,0x21
    80001800:	2e453503          	ld	a0,740(a0) # 80022ae0 <kernel_pagetable>
    80001804:	00000097          	auipc	ra,0x0
    80001808:	ef8080e7          	jalr	-264(ra) # 800016fc <mappages>
    8000180c:	00051a63          	bnez	a0,80001820 <kvmmap+0x40>
}
    80001810:	00813083          	ld	ra,8(sp)
    80001814:	00013403          	ld	s0,0(sp)
    80001818:	01010113          	addi	sp,sp,16
    8000181c:	00008067          	ret
    panic("kvmmap");
    80001820:	00007517          	auipc	a0,0x7
    80001824:	b5050513          	addi	a0,a0,-1200 # 80008370 <userret+0x2cc>
    80001828:	fffff097          	auipc	ra,0xfffff
    8000182c:	eb0080e7          	jalr	-336(ra) # 800006d8 <panic>

0000000080001830 <kvminit>:
{
    80001830:	fe010113          	addi	sp,sp,-32
    80001834:	00113c23          	sd	ra,24(sp)
    80001838:	00813823          	sd	s0,16(sp)
    8000183c:	00913423          	sd	s1,8(sp)
    80001840:	01213023          	sd	s2,0(sp)
    80001844:	02010413          	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    80001848:	fffff097          	auipc	ra,0xfffff
    8000184c:	480080e7          	jalr	1152(ra) # 80000cc8 <kalloc>
    80001850:	00021717          	auipc	a4,0x21
    80001854:	28a73823          	sd	a0,656(a4) # 80022ae0 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    80001858:	00001637          	lui	a2,0x1
    8000185c:	00000593          	li	a1,0
    80001860:	fffff097          	auipc	ra,0xfffff
    80001864:	750080e7          	jalr	1872(ra) # 80000fb0 <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001868:	00600693          	li	a3,6
    8000186c:	00001637          	lui	a2,0x1
    80001870:	100005b7          	lui	a1,0x10000
    80001874:	10000537          	lui	a0,0x10000
    80001878:	00000097          	auipc	ra,0x0
    8000187c:	f68080e7          	jalr	-152(ra) # 800017e0 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001880:	00600693          	li	a3,6
    80001884:	00001637          	lui	a2,0x1
    80001888:	100015b7          	lui	a1,0x10001
    8000188c:	10001537          	lui	a0,0x10001
    80001890:	00000097          	auipc	ra,0x0
    80001894:	f50080e7          	jalr	-176(ra) # 800017e0 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001898:	00600693          	li	a3,6
    8000189c:	00010637          	lui	a2,0x10
    800018a0:	020005b7          	lui	a1,0x2000
    800018a4:	02000537          	lui	a0,0x2000
    800018a8:	00000097          	auipc	ra,0x0
    800018ac:	f38080e7          	jalr	-200(ra) # 800017e0 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800018b0:	00600693          	li	a3,6
    800018b4:	00400637          	lui	a2,0x400
    800018b8:	0c0005b7          	lui	a1,0xc000
    800018bc:	0c000537          	lui	a0,0xc000
    800018c0:	00000097          	auipc	ra,0x0
    800018c4:	f20080e7          	jalr	-224(ra) # 800017e0 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800018c8:	00007917          	auipc	s2,0x7
    800018cc:	73890913          	addi	s2,s2,1848 # 80009000 <initcode>
    800018d0:	00a00693          	li	a3,10
    800018d4:	80007617          	auipc	a2,0x80007
    800018d8:	72c60613          	addi	a2,a2,1836 # 9000 <_entry-0x7fff7000>
    800018dc:	00100593          	li	a1,1
    800018e0:	01f59593          	slli	a1,a1,0x1f
    800018e4:	00058513          	mv	a0,a1
    800018e8:	00000097          	auipc	ra,0x0
    800018ec:	ef8080e7          	jalr	-264(ra) # 800017e0 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800018f0:	01100493          	li	s1,17
    800018f4:	01b49493          	slli	s1,s1,0x1b
    800018f8:	00600693          	li	a3,6
    800018fc:	41248633          	sub	a2,s1,s2
    80001900:	00090593          	mv	a1,s2
    80001904:	00090513          	mv	a0,s2
    80001908:	00000097          	auipc	ra,0x0
    8000190c:	ed8080e7          	jalr	-296(ra) # 800017e0 <kvmmap>
  kvmmap(RAMDISK, RAMDISK, FSSIZE * BSIZE, PTE_R | PTE_W);
    80001910:	00600693          	li	a3,6
    80001914:	000fa637          	lui	a2,0xfa
    80001918:	00048593          	mv	a1,s1
    8000191c:	00048513          	mv	a0,s1
    80001920:	00000097          	auipc	ra,0x0
    80001924:	ec0080e7          	jalr	-320(ra) # 800017e0 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001928:	00a00693          	li	a3,10
    8000192c:	00001637          	lui	a2,0x1
    80001930:	00006597          	auipc	a1,0x6
    80001934:	6d058593          	addi	a1,a1,1744 # 80008000 <trampoline>
    80001938:	04000537          	lui	a0,0x4000
    8000193c:	fff50513          	addi	a0,a0,-1 # 3ffffff <_entry-0x7c000001>
    80001940:	00c51513          	slli	a0,a0,0xc
    80001944:	00000097          	auipc	ra,0x0
    80001948:	e9c080e7          	jalr	-356(ra) # 800017e0 <kvmmap>
}
    8000194c:	01813083          	ld	ra,24(sp)
    80001950:	01013403          	ld	s0,16(sp)
    80001954:	00813483          	ld	s1,8(sp)
    80001958:	00013903          	ld	s2,0(sp)
    8000195c:	02010113          	addi	sp,sp,32
    80001960:	00008067          	ret

0000000080001964 <uvmunmap>:
{
    80001964:	fb010113          	addi	sp,sp,-80
    80001968:	04113423          	sd	ra,72(sp)
    8000196c:	04813023          	sd	s0,64(sp)
    80001970:	02913c23          	sd	s1,56(sp)
    80001974:	03213823          	sd	s2,48(sp)
    80001978:	03313423          	sd	s3,40(sp)
    8000197c:	03413023          	sd	s4,32(sp)
    80001980:	01513c23          	sd	s5,24(sp)
    80001984:	01613823          	sd	s6,16(sp)
    80001988:	01713423          	sd	s7,8(sp)
    8000198c:	05010413          	addi	s0,sp,80
    80001990:	00050a13          	mv	s4,a0
    80001994:	00068a93          	mv	s5,a3
  a = PGROUNDDOWN(va);
    80001998:	fffff7b7          	lui	a5,0xfffff
    8000199c:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800019a0:	fff60993          	addi	s3,a2,-1 # fff <_entry-0x7ffff001>
    800019a4:	00b989b3          	add	s3,s3,a1
    800019a8:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    800019ac:	00100b13          	li	s6,1
    a += PGSIZE;
    800019b0:	00001bb7          	lui	s7,0x1
    800019b4:	0540006f          	j	80001a08 <uvmunmap+0xa4>
      panic("uvmunmap: walk");
    800019b8:	00007517          	auipc	a0,0x7
    800019bc:	9c050513          	addi	a0,a0,-1600 # 80008378 <userret+0x2d4>
    800019c0:	fffff097          	auipc	ra,0xfffff
    800019c4:	d18080e7          	jalr	-744(ra) # 800006d8 <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800019c8:	00090593          	mv	a1,s2
    800019cc:	00007517          	auipc	a0,0x7
    800019d0:	9bc50513          	addi	a0,a0,-1604 # 80008388 <userret+0x2e4>
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	d60080e7          	jalr	-672(ra) # 80000734 <printf>
      panic("uvmunmap: not mapped");
    800019dc:	00007517          	auipc	a0,0x7
    800019e0:	9bc50513          	addi	a0,a0,-1604 # 80008398 <userret+0x2f4>
    800019e4:	fffff097          	auipc	ra,0xfffff
    800019e8:	cf4080e7          	jalr	-780(ra) # 800006d8 <panic>
      panic("uvmunmap: not a leaf");
    800019ec:	00007517          	auipc	a0,0x7
    800019f0:	9c450513          	addi	a0,a0,-1596 # 800083b0 <userret+0x30c>
    800019f4:	fffff097          	auipc	ra,0xfffff
    800019f8:	ce4080e7          	jalr	-796(ra) # 800006d8 <panic>
    *pte = 0;
    800019fc:	0004b023          	sd	zero,0(s1)
    if(a == last)
    80001a00:	05390863          	beq	s2,s3,80001a50 <uvmunmap+0xec>
    a += PGSIZE;
    80001a04:	01790933          	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    80001a08:	00000613          	li	a2,0
    80001a0c:	00090593          	mv	a1,s2
    80001a10:	000a0513          	mv	a0,s4
    80001a14:	00000097          	auipc	ra,0x0
    80001a18:	a20080e7          	jalr	-1504(ra) # 80001434 <walk>
    80001a1c:	00050493          	mv	s1,a0
    80001a20:	f8050ce3          	beqz	a0,800019b8 <uvmunmap+0x54>
    if((*pte & PTE_V) == 0){
    80001a24:	00053603          	ld	a2,0(a0)
    80001a28:	00167793          	andi	a5,a2,1
    80001a2c:	f8078ee3          	beqz	a5,800019c8 <uvmunmap+0x64>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001a30:	3ff67793          	andi	a5,a2,1023
    80001a34:	fb678ce3          	beq	a5,s6,800019ec <uvmunmap+0x88>
    if(do_free){
    80001a38:	fc0a82e3          	beqz	s5,800019fc <uvmunmap+0x98>
      pa = PTE2PA(*pte);
    80001a3c:	00a65613          	srli	a2,a2,0xa
      kfree((void*)pa);
    80001a40:	00c61513          	slli	a0,a2,0xc
    80001a44:	fffff097          	auipc	ra,0xfffff
    80001a48:	0a0080e7          	jalr	160(ra) # 80000ae4 <kfree>
    80001a4c:	fb1ff06f          	j	800019fc <uvmunmap+0x98>
}
    80001a50:	04813083          	ld	ra,72(sp)
    80001a54:	04013403          	ld	s0,64(sp)
    80001a58:	03813483          	ld	s1,56(sp)
    80001a5c:	03013903          	ld	s2,48(sp)
    80001a60:	02813983          	ld	s3,40(sp)
    80001a64:	02013a03          	ld	s4,32(sp)
    80001a68:	01813a83          	ld	s5,24(sp)
    80001a6c:	01013b03          	ld	s6,16(sp)
    80001a70:	00813b83          	ld	s7,8(sp)
    80001a74:	05010113          	addi	sp,sp,80
    80001a78:	00008067          	ret

0000000080001a7c <uvmcreate>:
{
    80001a7c:	fe010113          	addi	sp,sp,-32
    80001a80:	00113c23          	sd	ra,24(sp)
    80001a84:	00813823          	sd	s0,16(sp)
    80001a88:	00913423          	sd	s1,8(sp)
    80001a8c:	02010413          	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    80001a90:	fffff097          	auipc	ra,0xfffff
    80001a94:	238080e7          	jalr	568(ra) # 80000cc8 <kalloc>
  if(pagetable == 0)
    80001a98:	02050863          	beqz	a0,80001ac8 <uvmcreate+0x4c>
    80001a9c:	00050493          	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    80001aa0:	00001637          	lui	a2,0x1
    80001aa4:	00000593          	li	a1,0
    80001aa8:	fffff097          	auipc	ra,0xfffff
    80001aac:	508080e7          	jalr	1288(ra) # 80000fb0 <memset>
}
    80001ab0:	00048513          	mv	a0,s1
    80001ab4:	01813083          	ld	ra,24(sp)
    80001ab8:	01013403          	ld	s0,16(sp)
    80001abc:	00813483          	ld	s1,8(sp)
    80001ac0:	02010113          	addi	sp,sp,32
    80001ac4:	00008067          	ret
    panic("uvmcreate: out of memory");
    80001ac8:	00007517          	auipc	a0,0x7
    80001acc:	90050513          	addi	a0,a0,-1792 # 800083c8 <userret+0x324>
    80001ad0:	fffff097          	auipc	ra,0xfffff
    80001ad4:	c08080e7          	jalr	-1016(ra) # 800006d8 <panic>

0000000080001ad8 <uvminit>:
{
    80001ad8:	fd010113          	addi	sp,sp,-48
    80001adc:	02113423          	sd	ra,40(sp)
    80001ae0:	02813023          	sd	s0,32(sp)
    80001ae4:	00913c23          	sd	s1,24(sp)
    80001ae8:	01213823          	sd	s2,16(sp)
    80001aec:	01313423          	sd	s3,8(sp)
    80001af0:	01413023          	sd	s4,0(sp)
    80001af4:	03010413          	addi	s0,sp,48
  if(sz >= PGSIZE)
    80001af8:	000017b7          	lui	a5,0x1
    80001afc:	06f67e63          	bgeu	a2,a5,80001b78 <uvminit+0xa0>
    80001b00:	00050a13          	mv	s4,a0
    80001b04:	00058993          	mv	s3,a1
    80001b08:	00060493          	mv	s1,a2
  mem = kalloc();
    80001b0c:	fffff097          	auipc	ra,0xfffff
    80001b10:	1bc080e7          	jalr	444(ra) # 80000cc8 <kalloc>
    80001b14:	00050913          	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001b18:	00001637          	lui	a2,0x1
    80001b1c:	00000593          	li	a1,0
    80001b20:	fffff097          	auipc	ra,0xfffff
    80001b24:	490080e7          	jalr	1168(ra) # 80000fb0 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001b28:	01e00713          	li	a4,30
    80001b2c:	00090693          	mv	a3,s2
    80001b30:	00001637          	lui	a2,0x1
    80001b34:	00000593          	li	a1,0
    80001b38:	000a0513          	mv	a0,s4
    80001b3c:	00000097          	auipc	ra,0x0
    80001b40:	bc0080e7          	jalr	-1088(ra) # 800016fc <mappages>
  memmove(mem, src, sz);
    80001b44:	00048613          	mv	a2,s1
    80001b48:	00098593          	mv	a1,s3
    80001b4c:	00090513          	mv	a0,s2
    80001b50:	fffff097          	auipc	ra,0xfffff
    80001b54:	4f4080e7          	jalr	1268(ra) # 80001044 <memmove>
}
    80001b58:	02813083          	ld	ra,40(sp)
    80001b5c:	02013403          	ld	s0,32(sp)
    80001b60:	01813483          	ld	s1,24(sp)
    80001b64:	01013903          	ld	s2,16(sp)
    80001b68:	00813983          	ld	s3,8(sp)
    80001b6c:	00013a03          	ld	s4,0(sp)
    80001b70:	03010113          	addi	sp,sp,48
    80001b74:	00008067          	ret
    panic("inituvm: more than a page");
    80001b78:	00007517          	auipc	a0,0x7
    80001b7c:	87050513          	addi	a0,a0,-1936 # 800083e8 <userret+0x344>
    80001b80:	fffff097          	auipc	ra,0xfffff
    80001b84:	b58080e7          	jalr	-1192(ra) # 800006d8 <panic>

0000000080001b88 <uvmdealloc>:
{
    80001b88:	fe010113          	addi	sp,sp,-32
    80001b8c:	00113c23          	sd	ra,24(sp)
    80001b90:	00813823          	sd	s0,16(sp)
    80001b94:	00913423          	sd	s1,8(sp)
    80001b98:	02010413          	addi	s0,sp,32
    return oldsz;
    80001b9c:	00058493          	mv	s1,a1
  if(newsz >= oldsz)
    80001ba0:	02b67463          	bgeu	a2,a1,80001bc8 <uvmdealloc+0x40>
    80001ba4:	00060493          	mv	s1,a2
  uint64 newup = PGROUNDUP(newsz);
    80001ba8:	000017b7          	lui	a5,0x1
    80001bac:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001bb0:	00f60733          	add	a4,a2,a5
    80001bb4:	fffff6b7          	lui	a3,0xfffff
    80001bb8:	00d77733          	and	a4,a4,a3
  if(newup < PGROUNDUP(oldsz))
    80001bbc:	00f587b3          	add	a5,a1,a5
    80001bc0:	00d7f7b3          	and	a5,a5,a3
    80001bc4:	00f76e63          	bltu	a4,a5,80001be0 <uvmdealloc+0x58>
}
    80001bc8:	00048513          	mv	a0,s1
    80001bcc:	01813083          	ld	ra,24(sp)
    80001bd0:	01013403          	ld	s0,16(sp)
    80001bd4:	00813483          	ld	s1,8(sp)
    80001bd8:	02010113          	addi	sp,sp,32
    80001bdc:	00008067          	ret
    uvmunmap(pagetable, newup, oldsz - newup, 1);
    80001be0:	00100693          	li	a3,1
    80001be4:	40e58633          	sub	a2,a1,a4
    80001be8:	00070593          	mv	a1,a4
    80001bec:	00000097          	auipc	ra,0x0
    80001bf0:	d78080e7          	jalr	-648(ra) # 80001964 <uvmunmap>
    80001bf4:	fd5ff06f          	j	80001bc8 <uvmdealloc+0x40>

0000000080001bf8 <uvmalloc>:
  if(newsz < oldsz)
    80001bf8:	10b66263          	bltu	a2,a1,80001cfc <uvmalloc+0x104>
{
    80001bfc:	fc010113          	addi	sp,sp,-64
    80001c00:	02113c23          	sd	ra,56(sp)
    80001c04:	02813823          	sd	s0,48(sp)
    80001c08:	02913423          	sd	s1,40(sp)
    80001c0c:	03213023          	sd	s2,32(sp)
    80001c10:	01313c23          	sd	s3,24(sp)
    80001c14:	01413823          	sd	s4,16(sp)
    80001c18:	01513423          	sd	s5,8(sp)
    80001c1c:	04010413          	addi	s0,sp,64
    80001c20:	00050a93          	mv	s5,a0
    80001c24:	00060a13          	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001c28:	000017b7          	lui	a5,0x1
    80001c2c:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001c30:	00f585b3          	add	a1,a1,a5
    80001c34:	fffff7b7          	lui	a5,0xfffff
    80001c38:	00f5f9b3          	and	s3,a1,a5
  for(; a < newsz; a += PGSIZE){
    80001c3c:	0cc9f463          	bgeu	s3,a2,80001d04 <uvmalloc+0x10c>
  a = oldsz;
    80001c40:	00098913          	mv	s2,s3
    mem = kalloc();
    80001c44:	fffff097          	auipc	ra,0xfffff
    80001c48:	084080e7          	jalr	132(ra) # 80000cc8 <kalloc>
    80001c4c:	00050493          	mv	s1,a0
    if(mem == 0){
    80001c50:	04050463          	beqz	a0,80001c98 <uvmalloc+0xa0>
    memset(mem, 0, PGSIZE);
    80001c54:	00001637          	lui	a2,0x1
    80001c58:	00000593          	li	a1,0
    80001c5c:	fffff097          	auipc	ra,0xfffff
    80001c60:	354080e7          	jalr	852(ra) # 80000fb0 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001c64:	01e00713          	li	a4,30
    80001c68:	00048693          	mv	a3,s1
    80001c6c:	00001637          	lui	a2,0x1
    80001c70:	00090593          	mv	a1,s2
    80001c74:	000a8513          	mv	a0,s5
    80001c78:	00000097          	auipc	ra,0x0
    80001c7c:	a84080e7          	jalr	-1404(ra) # 800016fc <mappages>
    80001c80:	04051a63          	bnez	a0,80001cd4 <uvmalloc+0xdc>
  for(; a < newsz; a += PGSIZE){
    80001c84:	000017b7          	lui	a5,0x1
    80001c88:	00f90933          	add	s2,s2,a5
    80001c8c:	fb496ce3          	bltu	s2,s4,80001c44 <uvmalloc+0x4c>
  return newsz;
    80001c90:	000a0513          	mv	a0,s4
    80001c94:	01c0006f          	j	80001cb0 <uvmalloc+0xb8>
      uvmdealloc(pagetable, a, oldsz);
    80001c98:	00098613          	mv	a2,s3
    80001c9c:	00090593          	mv	a1,s2
    80001ca0:	000a8513          	mv	a0,s5
    80001ca4:	00000097          	auipc	ra,0x0
    80001ca8:	ee4080e7          	jalr	-284(ra) # 80001b88 <uvmdealloc>
      return 0;
    80001cac:	00000513          	li	a0,0
}
    80001cb0:	03813083          	ld	ra,56(sp)
    80001cb4:	03013403          	ld	s0,48(sp)
    80001cb8:	02813483          	ld	s1,40(sp)
    80001cbc:	02013903          	ld	s2,32(sp)
    80001cc0:	01813983          	ld	s3,24(sp)
    80001cc4:	01013a03          	ld	s4,16(sp)
    80001cc8:	00813a83          	ld	s5,8(sp)
    80001ccc:	04010113          	addi	sp,sp,64
    80001cd0:	00008067          	ret
      kfree(mem);
    80001cd4:	00048513          	mv	a0,s1
    80001cd8:	fffff097          	auipc	ra,0xfffff
    80001cdc:	e0c080e7          	jalr	-500(ra) # 80000ae4 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001ce0:	00098613          	mv	a2,s3
    80001ce4:	00090593          	mv	a1,s2
    80001ce8:	000a8513          	mv	a0,s5
    80001cec:	00000097          	auipc	ra,0x0
    80001cf0:	e9c080e7          	jalr	-356(ra) # 80001b88 <uvmdealloc>
      return 0;
    80001cf4:	00000513          	li	a0,0
    80001cf8:	fb9ff06f          	j	80001cb0 <uvmalloc+0xb8>
    return oldsz;
    80001cfc:	00058513          	mv	a0,a1
}
    80001d00:	00008067          	ret
  return newsz;
    80001d04:	00060513          	mv	a0,a2
    80001d08:	fa9ff06f          	j	80001cb0 <uvmalloc+0xb8>

0000000080001d0c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001d0c:	fe010113          	addi	sp,sp,-32
    80001d10:	00113c23          	sd	ra,24(sp)
    80001d14:	00813823          	sd	s0,16(sp)
    80001d18:	00913423          	sd	s1,8(sp)
    80001d1c:	02010413          	addi	s0,sp,32
    80001d20:	00050493          	mv	s1,a0
    80001d24:	00058613          	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    80001d28:	00100693          	li	a3,1
    80001d2c:	00000593          	li	a1,0
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	c34080e7          	jalr	-972(ra) # 80001964 <uvmunmap>
  freewalk(pagetable);
    80001d38:	00048513          	mv	a0,s1
    80001d3c:	fffff097          	auipc	ra,0xfffff
    80001d40:	7f4080e7          	jalr	2036(ra) # 80001530 <freewalk>
}
    80001d44:	01813083          	ld	ra,24(sp)
    80001d48:	01013403          	ld	s0,16(sp)
    80001d4c:	00813483          	ld	s1,8(sp)
    80001d50:	02010113          	addi	sp,sp,32
    80001d54:	00008067          	ret

0000000080001d58 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001d58:	12060a63          	beqz	a2,80001e8c <uvmcopy+0x134>
{
    80001d5c:	fb010113          	addi	sp,sp,-80
    80001d60:	04113423          	sd	ra,72(sp)
    80001d64:	04813023          	sd	s0,64(sp)
    80001d68:	02913c23          	sd	s1,56(sp)
    80001d6c:	03213823          	sd	s2,48(sp)
    80001d70:	03313423          	sd	s3,40(sp)
    80001d74:	03413023          	sd	s4,32(sp)
    80001d78:	01513c23          	sd	s5,24(sp)
    80001d7c:	01613823          	sd	s6,16(sp)
    80001d80:	01713423          	sd	s7,8(sp)
    80001d84:	05010413          	addi	s0,sp,80
    80001d88:	00050b13          	mv	s6,a0
    80001d8c:	00058a93          	mv	s5,a1
    80001d90:	00060a13          	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001d94:	00000993          	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001d98:	00000613          	li	a2,0
    80001d9c:	00098593          	mv	a1,s3
    80001da0:	000b0513          	mv	a0,s6
    80001da4:	fffff097          	auipc	ra,0xfffff
    80001da8:	690080e7          	jalr	1680(ra) # 80001434 <walk>
    80001dac:	06050663          	beqz	a0,80001e18 <uvmcopy+0xc0>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001db0:	00053703          	ld	a4,0(a0)
    80001db4:	00177793          	andi	a5,a4,1
    80001db8:	06078863          	beqz	a5,80001e28 <uvmcopy+0xd0>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001dbc:	00a75593          	srli	a1,a4,0xa
    80001dc0:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001dc4:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001dc8:	fffff097          	auipc	ra,0xfffff
    80001dcc:	f00080e7          	jalr	-256(ra) # 80000cc8 <kalloc>
    80001dd0:	00050913          	mv	s2,a0
    80001dd4:	06050863          	beqz	a0,80001e44 <uvmcopy+0xec>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001dd8:	00001637          	lui	a2,0x1
    80001ddc:	000b8593          	mv	a1,s7
    80001de0:	fffff097          	auipc	ra,0xfffff
    80001de4:	264080e7          	jalr	612(ra) # 80001044 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001de8:	00048713          	mv	a4,s1
    80001dec:	00090693          	mv	a3,s2
    80001df0:	00001637          	lui	a2,0x1
    80001df4:	00098593          	mv	a1,s3
    80001df8:	000a8513          	mv	a0,s5
    80001dfc:	00000097          	auipc	ra,0x0
    80001e00:	900080e7          	jalr	-1792(ra) # 800016fc <mappages>
    80001e04:	02051a63          	bnez	a0,80001e38 <uvmcopy+0xe0>
  for(i = 0; i < sz; i += PGSIZE){
    80001e08:	000017b7          	lui	a5,0x1
    80001e0c:	00f989b3          	add	s3,s3,a5
    80001e10:	f949e4e3          	bltu	s3,s4,80001d98 <uvmcopy+0x40>
    80001e14:	04c0006f          	j	80001e60 <uvmcopy+0x108>
      panic("uvmcopy: pte should exist");
    80001e18:	00006517          	auipc	a0,0x6
    80001e1c:	5f050513          	addi	a0,a0,1520 # 80008408 <userret+0x364>
    80001e20:	fffff097          	auipc	ra,0xfffff
    80001e24:	8b8080e7          	jalr	-1864(ra) # 800006d8 <panic>
      panic("uvmcopy: page not present");
    80001e28:	00006517          	auipc	a0,0x6
    80001e2c:	60050513          	addi	a0,a0,1536 # 80008428 <userret+0x384>
    80001e30:	fffff097          	auipc	ra,0xfffff
    80001e34:	8a8080e7          	jalr	-1880(ra) # 800006d8 <panic>
      kfree(mem);
    80001e38:	00090513          	mv	a0,s2
    80001e3c:	fffff097          	auipc	ra,0xfffff
    80001e40:	ca8080e7          	jalr	-856(ra) # 80000ae4 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    80001e44:	00100693          	li	a3,1
    80001e48:	00098613          	mv	a2,s3
    80001e4c:	00000593          	li	a1,0
    80001e50:	000a8513          	mv	a0,s5
    80001e54:	00000097          	auipc	ra,0x0
    80001e58:	b10080e7          	jalr	-1264(ra) # 80001964 <uvmunmap>
  return -1;
    80001e5c:	fff00513          	li	a0,-1
}
    80001e60:	04813083          	ld	ra,72(sp)
    80001e64:	04013403          	ld	s0,64(sp)
    80001e68:	03813483          	ld	s1,56(sp)
    80001e6c:	03013903          	ld	s2,48(sp)
    80001e70:	02813983          	ld	s3,40(sp)
    80001e74:	02013a03          	ld	s4,32(sp)
    80001e78:	01813a83          	ld	s5,24(sp)
    80001e7c:	01013b03          	ld	s6,16(sp)
    80001e80:	00813b83          	ld	s7,8(sp)
    80001e84:	05010113          	addi	sp,sp,80
    80001e88:	00008067          	ret
  return 0;
    80001e8c:	00000513          	li	a0,0
}
    80001e90:	00008067          	ret

0000000080001e94 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001e94:	ff010113          	addi	sp,sp,-16
    80001e98:	00113423          	sd	ra,8(sp)
    80001e9c:	00813023          	sd	s0,0(sp)
    80001ea0:	01010413          	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001ea4:	00000613          	li	a2,0
    80001ea8:	fffff097          	auipc	ra,0xfffff
    80001eac:	58c080e7          	jalr	1420(ra) # 80001434 <walk>
  if(pte == 0)
    80001eb0:	02050063          	beqz	a0,80001ed0 <uvmclear+0x3c>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001eb4:	00053783          	ld	a5,0(a0)
    80001eb8:	fef7f793          	andi	a5,a5,-17
    80001ebc:	00f53023          	sd	a5,0(a0)
}
    80001ec0:	00813083          	ld	ra,8(sp)
    80001ec4:	00013403          	ld	s0,0(sp)
    80001ec8:	01010113          	addi	sp,sp,16
    80001ecc:	00008067          	ret
    panic("uvmclear");
    80001ed0:	00006517          	auipc	a0,0x6
    80001ed4:	57850513          	addi	a0,a0,1400 # 80008448 <userret+0x3a4>
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	800080e7          	jalr	-2048(ra) # 800006d8 <panic>

0000000080001ee0 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001ee0:	0a068663          	beqz	a3,80001f8c <copyout+0xac>
{
    80001ee4:	fb010113          	addi	sp,sp,-80
    80001ee8:	04113423          	sd	ra,72(sp)
    80001eec:	04813023          	sd	s0,64(sp)
    80001ef0:	02913c23          	sd	s1,56(sp)
    80001ef4:	03213823          	sd	s2,48(sp)
    80001ef8:	03313423          	sd	s3,40(sp)
    80001efc:	03413023          	sd	s4,32(sp)
    80001f00:	01513c23          	sd	s5,24(sp)
    80001f04:	01613823          	sd	s6,16(sp)
    80001f08:	01713423          	sd	s7,8(sp)
    80001f0c:	01813023          	sd	s8,0(sp)
    80001f10:	05010413          	addi	s0,sp,80
    80001f14:	00050b13          	mv	s6,a0
    80001f18:	00058c13          	mv	s8,a1
    80001f1c:	00060a13          	mv	s4,a2
    80001f20:	00068993          	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001f24:	fffffbb7          	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001f28:	00001ab7          	lui	s5,0x1
    80001f2c:	02c0006f          	j	80001f58 <copyout+0x78>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001f30:	01850533          	add	a0,a0,s8
    80001f34:	0004861b          	sext.w	a2,s1
    80001f38:	000a0593          	mv	a1,s4
    80001f3c:	41250533          	sub	a0,a0,s2
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	104080e7          	jalr	260(ra) # 80001044 <memmove>

    len -= n;
    80001f48:	409989b3          	sub	s3,s3,s1
    src += n;
    80001f4c:	009a0a33          	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001f50:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001f54:	02098863          	beqz	s3,80001f84 <copyout+0xa4>
    va0 = PGROUNDDOWN(dstva);
    80001f58:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001f5c:	00090593          	mv	a1,s2
    80001f60:	000b0513          	mv	a0,s6
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	6a8080e7          	jalr	1704(ra) # 8000160c <walkaddr>
    if(pa0 == 0)
    80001f6c:	02050463          	beqz	a0,80001f94 <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80001f70:	418904b3          	sub	s1,s2,s8
    80001f74:	015484b3          	add	s1,s1,s5
    80001f78:	fa99fce3          	bgeu	s3,s1,80001f30 <copyout+0x50>
    80001f7c:	00098493          	mv	s1,s3
    80001f80:	fb1ff06f          	j	80001f30 <copyout+0x50>
  }
  return 0;
    80001f84:	00000513          	li	a0,0
    80001f88:	0100006f          	j	80001f98 <copyout+0xb8>
    80001f8c:	00000513          	li	a0,0
}
    80001f90:	00008067          	ret
      return -1;
    80001f94:	fff00513          	li	a0,-1
}
    80001f98:	04813083          	ld	ra,72(sp)
    80001f9c:	04013403          	ld	s0,64(sp)
    80001fa0:	03813483          	ld	s1,56(sp)
    80001fa4:	03013903          	ld	s2,48(sp)
    80001fa8:	02813983          	ld	s3,40(sp)
    80001fac:	02013a03          	ld	s4,32(sp)
    80001fb0:	01813a83          	ld	s5,24(sp)
    80001fb4:	01013b03          	ld	s6,16(sp)
    80001fb8:	00813b83          	ld	s7,8(sp)
    80001fbc:	00013c03          	ld	s8,0(sp)
    80001fc0:	05010113          	addi	sp,sp,80
    80001fc4:	00008067          	ret

0000000080001fc8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001fc8:	0a068663          	beqz	a3,80002074 <copyin+0xac>
{
    80001fcc:	fb010113          	addi	sp,sp,-80
    80001fd0:	04113423          	sd	ra,72(sp)
    80001fd4:	04813023          	sd	s0,64(sp)
    80001fd8:	02913c23          	sd	s1,56(sp)
    80001fdc:	03213823          	sd	s2,48(sp)
    80001fe0:	03313423          	sd	s3,40(sp)
    80001fe4:	03413023          	sd	s4,32(sp)
    80001fe8:	01513c23          	sd	s5,24(sp)
    80001fec:	01613823          	sd	s6,16(sp)
    80001ff0:	01713423          	sd	s7,8(sp)
    80001ff4:	01813023          	sd	s8,0(sp)
    80001ff8:	05010413          	addi	s0,sp,80
    80001ffc:	00050b13          	mv	s6,a0
    80002000:	00058a13          	mv	s4,a1
    80002004:	00060c13          	mv	s8,a2
    80002008:	00068993          	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000200c:	fffffbb7          	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80002010:	00001ab7          	lui	s5,0x1
    80002014:	02c0006f          	j	80002040 <copyin+0x78>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80002018:	018505b3          	add	a1,a0,s8
    8000201c:	0004861b          	sext.w	a2,s1
    80002020:	412585b3          	sub	a1,a1,s2
    80002024:	000a0513          	mv	a0,s4
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	01c080e7          	jalr	28(ra) # 80001044 <memmove>

    len -= n;
    80002030:	409989b3          	sub	s3,s3,s1
    dst += n;
    80002034:	009a0a33          	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80002038:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000203c:	02098863          	beqz	s3,8000206c <copyin+0xa4>
    va0 = PGROUNDDOWN(srcva);
    80002040:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80002044:	00090593          	mv	a1,s2
    80002048:	000b0513          	mv	a0,s6
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	5c0080e7          	jalr	1472(ra) # 8000160c <walkaddr>
    if(pa0 == 0)
    80002054:	02050463          	beqz	a0,8000207c <copyin+0xb4>
    n = PGSIZE - (srcva - va0);
    80002058:	418904b3          	sub	s1,s2,s8
    8000205c:	015484b3          	add	s1,s1,s5
    80002060:	fa99fce3          	bgeu	s3,s1,80002018 <copyin+0x50>
    80002064:	00098493          	mv	s1,s3
    80002068:	fb1ff06f          	j	80002018 <copyin+0x50>
  }
  return 0;
    8000206c:	00000513          	li	a0,0
    80002070:	0100006f          	j	80002080 <copyin+0xb8>
    80002074:	00000513          	li	a0,0
}
    80002078:	00008067          	ret
      return -1;
    8000207c:	fff00513          	li	a0,-1
}
    80002080:	04813083          	ld	ra,72(sp)
    80002084:	04013403          	ld	s0,64(sp)
    80002088:	03813483          	ld	s1,56(sp)
    8000208c:	03013903          	ld	s2,48(sp)
    80002090:	02813983          	ld	s3,40(sp)
    80002094:	02013a03          	ld	s4,32(sp)
    80002098:	01813a83          	ld	s5,24(sp)
    8000209c:	01013b03          	ld	s6,16(sp)
    800020a0:	00813b83          	ld	s7,8(sp)
    800020a4:	00013c03          	ld	s8,0(sp)
    800020a8:	05010113          	addi	sp,sp,80
    800020ac:	00008067          	ret

00000000800020b0 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800020b0:	10068663          	beqz	a3,800021bc <copyinstr+0x10c>
{
    800020b4:	fb010113          	addi	sp,sp,-80
    800020b8:	04113423          	sd	ra,72(sp)
    800020bc:	04813023          	sd	s0,64(sp)
    800020c0:	02913c23          	sd	s1,56(sp)
    800020c4:	03213823          	sd	s2,48(sp)
    800020c8:	03313423          	sd	s3,40(sp)
    800020cc:	03413023          	sd	s4,32(sp)
    800020d0:	01513c23          	sd	s5,24(sp)
    800020d4:	01613823          	sd	s6,16(sp)
    800020d8:	01713423          	sd	s7,8(sp)
    800020dc:	05010413          	addi	s0,sp,80
    800020e0:	00050a13          	mv	s4,a0
    800020e4:	00058b13          	mv	s6,a1
    800020e8:	00060b93          	mv	s7,a2
    800020ec:	00068493          	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800020f0:	fffffab7          	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800020f4:	000019b7          	lui	s3,0x1
    800020f8:	0480006f          	j	80002140 <copyinstr+0x90>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800020fc:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80002100:	00100793          	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80002104:	fff7879b          	addiw	a5,a5,-1
    80002108:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000210c:	04813083          	ld	ra,72(sp)
    80002110:	04013403          	ld	s0,64(sp)
    80002114:	03813483          	ld	s1,56(sp)
    80002118:	03013903          	ld	s2,48(sp)
    8000211c:	02813983          	ld	s3,40(sp)
    80002120:	02013a03          	ld	s4,32(sp)
    80002124:	01813a83          	ld	s5,24(sp)
    80002128:	01013b03          	ld	s6,16(sp)
    8000212c:	00813b83          	ld	s7,8(sp)
    80002130:	05010113          	addi	sp,sp,80
    80002134:	00008067          	ret
    srcva = va0 + PGSIZE;
    80002138:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000213c:	06048863          	beqz	s1,800021ac <copyinstr+0xfc>
    va0 = PGROUNDDOWN(srcva);
    80002140:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80002144:	00090593          	mv	a1,s2
    80002148:	000a0513          	mv	a0,s4
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	4c0080e7          	jalr	1216(ra) # 8000160c <walkaddr>
    if(pa0 == 0)
    80002154:	06050063          	beqz	a0,800021b4 <copyinstr+0x104>
    n = PGSIZE - (srcva - va0);
    80002158:	417906b3          	sub	a3,s2,s7
    8000215c:	013686b3          	add	a3,a3,s3
    80002160:	00d4f463          	bgeu	s1,a3,80002168 <copyinstr+0xb8>
    80002164:	00048693          	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80002168:	01750533          	add	a0,a0,s7
    8000216c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80002170:	fc0684e3          	beqz	a3,80002138 <copyinstr+0x88>
    80002174:	000b0793          	mv	a5,s6
      if(*p == '\0'){
    80002178:	41650633          	sub	a2,a0,s6
    8000217c:	fff48593          	addi	a1,s1,-1
    80002180:	00bb05b3          	add	a1,s6,a1
    while(n > 0){
    80002184:	00db06b3          	add	a3,s6,a3
      if(*p == '\0'){
    80002188:	00f60733          	add	a4,a2,a5
    8000218c:	00074703          	lbu	a4,0(a4)
    80002190:	f60706e3          	beqz	a4,800020fc <copyinstr+0x4c>
        *dst = *p;
    80002194:	00e78023          	sb	a4,0(a5)
      --max;
    80002198:	40f584b3          	sub	s1,a1,a5
      dst++;
    8000219c:	00178793          	addi	a5,a5,1
    while(n > 0){
    800021a0:	fed794e3          	bne	a5,a3,80002188 <copyinstr+0xd8>
      dst++;
    800021a4:	00078b13          	mv	s6,a5
    800021a8:	f91ff06f          	j	80002138 <copyinstr+0x88>
    800021ac:	00000793          	li	a5,0
    800021b0:	f55ff06f          	j	80002104 <copyinstr+0x54>
      return -1;
    800021b4:	fff00513          	li	a0,-1
    800021b8:	f55ff06f          	j	8000210c <copyinstr+0x5c>
  int got_null = 0;
    800021bc:	00000793          	li	a5,0
  if(got_null){
    800021c0:	fff7879b          	addiw	a5,a5,-1
    800021c4:	0007851b          	sext.w	a0,a5
}
    800021c8:	00008067          	ret

00000000800021cc <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    800021cc:	fe010113          	addi	sp,sp,-32
    800021d0:	00113c23          	sd	ra,24(sp)
    800021d4:	00813823          	sd	s0,16(sp)
    800021d8:	00913423          	sd	s1,8(sp)
    800021dc:	02010413          	addi	s0,sp,32
    800021e0:	00050493          	mv	s1,a0
  if(!holding(&p->lock))
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	c90080e7          	jalr	-880(ra) # 80000e74 <holding>
    800021ec:	02050063          	beqz	a0,8000220c <wakeup1+0x40>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    800021f0:	0284b783          	ld	a5,40(s1)
    800021f4:	02978463          	beq	a5,s1,8000221c <wakeup1+0x50>
    p->state = RUNNABLE;
  }
}
    800021f8:	01813083          	ld	ra,24(sp)
    800021fc:	01013403          	ld	s0,16(sp)
    80002200:	00813483          	ld	s1,8(sp)
    80002204:	02010113          	addi	sp,sp,32
    80002208:	00008067          	ret
    panic("wakeup1");
    8000220c:	00006517          	auipc	a0,0x6
    80002210:	24c50513          	addi	a0,a0,588 # 80008458 <userret+0x3b4>
    80002214:	ffffe097          	auipc	ra,0xffffe
    80002218:	4c4080e7          	jalr	1220(ra) # 800006d8 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    8000221c:	0184a703          	lw	a4,24(s1)
    80002220:	00100793          	li	a5,1
    80002224:	fcf71ae3          	bne	a4,a5,800021f8 <wakeup1+0x2c>
    p->state = RUNNABLE;
    80002228:	00200793          	li	a5,2
    8000222c:	00f4ac23          	sw	a5,24(s1)
}
    80002230:	fc9ff06f          	j	800021f8 <wakeup1+0x2c>

0000000080002234 <procinit>:
{
    80002234:	fb010113          	addi	sp,sp,-80
    80002238:	04113423          	sd	ra,72(sp)
    8000223c:	04813023          	sd	s0,64(sp)
    80002240:	02913c23          	sd	s1,56(sp)
    80002244:	03213823          	sd	s2,48(sp)
    80002248:	03313423          	sd	s3,40(sp)
    8000224c:	03413023          	sd	s4,32(sp)
    80002250:	01513c23          	sd	s5,24(sp)
    80002254:	01613823          	sd	s6,16(sp)
    80002258:	01713423          	sd	s7,8(sp)
    8000225c:	05010413          	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80002260:	00006597          	auipc	a1,0x6
    80002264:	20058593          	addi	a1,a1,512 # 80008460 <userret+0x3bc>
    80002268:	0000f517          	auipc	a0,0xf
    8000226c:	6c050513          	addi	a0,a0,1728 # 80011928 <pid_lock>
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	ae0080e7          	jalr	-1312(ra) # 80000d50 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002278:	00010917          	auipc	s2,0x10
    8000227c:	ac890913          	addi	s2,s2,-1336 # 80011d40 <proc>
      initlock(&p->lock, "proc");
    80002280:	00006b97          	auipc	s7,0x6
    80002284:	1e8b8b93          	addi	s7,s7,488 # 80008468 <userret+0x3c4>
      uint64 va = KSTACK((int) (p - proc));
    80002288:	00090b13          	mv	s6,s2
    8000228c:	00006a97          	auipc	s5,0x6
    80002290:	7c4a8a93          	addi	s5,s5,1988 # 80008a50 <syscalls+0xb0>
    80002294:	040009b7          	lui	s3,0x4000
    80002298:	fff98993          	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000229c:	00c99993          	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800022a0:	00015a17          	auipc	s4,0x15
    800022a4:	4a0a0a13          	addi	s4,s4,1184 # 80017740 <tickslock>
      initlock(&p->lock, "proc");
    800022a8:	000b8593          	mv	a1,s7
    800022ac:	00090513          	mv	a0,s2
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	aa0080e7          	jalr	-1376(ra) # 80000d50 <initlock>
      char *pa = kalloc();
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	a10080e7          	jalr	-1520(ra) # 80000cc8 <kalloc>
    800022c0:	00050593          	mv	a1,a0
      if(pa == 0)
    800022c4:	06050a63          	beqz	a0,80002338 <procinit+0x104>
      uint64 va = KSTACK((int) (p - proc));
    800022c8:	416904b3          	sub	s1,s2,s6
    800022cc:	4034d493          	srai	s1,s1,0x3
    800022d0:	000ab783          	ld	a5,0(s5)
    800022d4:	02f484b3          	mul	s1,s1,a5
    800022d8:	0014849b          	addiw	s1,s1,1
    800022dc:	00d4949b          	slliw	s1,s1,0xd
    800022e0:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800022e4:	00600693          	li	a3,6
    800022e8:	00001637          	lui	a2,0x1
    800022ec:	00048513          	mv	a0,s1
    800022f0:	fffff097          	auipc	ra,0xfffff
    800022f4:	4f0080e7          	jalr	1264(ra) # 800017e0 <kvmmap>
      p->kstack = va;
    800022f8:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800022fc:	16890913          	addi	s2,s2,360
    80002300:	fb4914e3          	bne	s2,s4,800022a8 <procinit+0x74>
  kvminithart();
    80002304:	fffff097          	auipc	ra,0xfffff
    80002308:	2d0080e7          	jalr	720(ra) # 800015d4 <kvminithart>
}
    8000230c:	04813083          	ld	ra,72(sp)
    80002310:	04013403          	ld	s0,64(sp)
    80002314:	03813483          	ld	s1,56(sp)
    80002318:	03013903          	ld	s2,48(sp)
    8000231c:	02813983          	ld	s3,40(sp)
    80002320:	02013a03          	ld	s4,32(sp)
    80002324:	01813a83          	ld	s5,24(sp)
    80002328:	01013b03          	ld	s6,16(sp)
    8000232c:	00813b83          	ld	s7,8(sp)
    80002330:	05010113          	addi	sp,sp,80
    80002334:	00008067          	ret
        panic("kalloc");
    80002338:	00006517          	auipc	a0,0x6
    8000233c:	13850513          	addi	a0,a0,312 # 80008470 <userret+0x3cc>
    80002340:	ffffe097          	auipc	ra,0xffffe
    80002344:	398080e7          	jalr	920(ra) # 800006d8 <panic>

0000000080002348 <cpuid>:
{
    80002348:	ff010113          	addi	sp,sp,-16
    8000234c:	00813423          	sd	s0,8(sp)
    80002350:	01010413          	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80002354:	00020513          	mv	a0,tp
}
    80002358:	0005051b          	sext.w	a0,a0
    8000235c:	00813403          	ld	s0,8(sp)
    80002360:	01010113          	addi	sp,sp,16
    80002364:	00008067          	ret

0000000080002368 <mycpu>:
mycpu(void) {
    80002368:	ff010113          	addi	sp,sp,-16
    8000236c:	00813423          	sd	s0,8(sp)
    80002370:	01010413          	addi	s0,sp,16
    80002374:	00020793          	mv	a5,tp
  struct cpu *c = &cpus[id];
    80002378:	0007879b          	sext.w	a5,a5
    8000237c:	00779793          	slli	a5,a5,0x7
}
    80002380:	0000f517          	auipc	a0,0xf
    80002384:	5c050513          	addi	a0,a0,1472 # 80011940 <cpus>
    80002388:	00f50533          	add	a0,a0,a5
    8000238c:	00813403          	ld	s0,8(sp)
    80002390:	01010113          	addi	sp,sp,16
    80002394:	00008067          	ret

0000000080002398 <myproc>:
myproc(void) {
    80002398:	fe010113          	addi	sp,sp,-32
    8000239c:	00113c23          	sd	ra,24(sp)
    800023a0:	00813823          	sd	s0,16(sp)
    800023a4:	00913423          	sd	s1,8(sp)
    800023a8:	02010413          	addi	s0,sp,32
  push_off();
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	9c8080e7          	jalr	-1592(ra) # 80000d74 <push_off>
    800023b4:	00020793          	mv	a5,tp
  struct proc *p = c->proc;
    800023b8:	0007879b          	sext.w	a5,a5
    800023bc:	00779793          	slli	a5,a5,0x7
    800023c0:	0000f717          	auipc	a4,0xf
    800023c4:	56870713          	addi	a4,a4,1384 # 80011928 <pid_lock>
    800023c8:	00f707b3          	add	a5,a4,a5
    800023cc:	0187b483          	ld	s1,24(a5)
  pop_off();
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	a18080e7          	jalr	-1512(ra) # 80000de8 <pop_off>
}
    800023d8:	00048513          	mv	a0,s1
    800023dc:	01813083          	ld	ra,24(sp)
    800023e0:	01013403          	ld	s0,16(sp)
    800023e4:	00813483          	ld	s1,8(sp)
    800023e8:	02010113          	addi	sp,sp,32
    800023ec:	00008067          	ret

00000000800023f0 <forkret>:
{
    800023f0:	ff010113          	addi	sp,sp,-16
    800023f4:	00113423          	sd	ra,8(sp)
    800023f8:	00813023          	sd	s0,0(sp)
    800023fc:	01010413          	addi	s0,sp,16
  release(&myproc()->lock);
    80002400:	00000097          	auipc	ra,0x0
    80002404:	f98080e7          	jalr	-104(ra) # 80002398 <myproc>
    80002408:	fffff097          	auipc	ra,0xfffff
    8000240c:	b48080e7          	jalr	-1208(ra) # 80000f50 <release>
  if (first) {
    80002410:	00007797          	auipc	a5,0x7
    80002414:	c247a783          	lw	a5,-988(a5) # 80009034 <first.1>
    80002418:	00079e63          	bnez	a5,80002434 <forkret+0x44>
  usertrapret();
    8000241c:	00001097          	auipc	ra,0x1
    80002420:	048080e7          	jalr	72(ra) # 80003464 <usertrapret>
}
    80002424:	00813083          	ld	ra,8(sp)
    80002428:	00013403          	ld	s0,0(sp)
    8000242c:	01010113          	addi	sp,sp,16
    80002430:	00008067          	ret
    first = 0;
    80002434:	00007797          	auipc	a5,0x7
    80002438:	c007a023          	sw	zero,-1024(a5) # 80009034 <first.1>
    fsinit(ROOTDEV);
    8000243c:	00100513          	li	a0,1
    80002440:	00002097          	auipc	ra,0x2
    80002444:	284080e7          	jalr	644(ra) # 800046c4 <fsinit>
    80002448:	fd5ff06f          	j	8000241c <forkret+0x2c>

000000008000244c <allocpid>:
allocpid() {
    8000244c:	fe010113          	addi	sp,sp,-32
    80002450:	00113c23          	sd	ra,24(sp)
    80002454:	00813823          	sd	s0,16(sp)
    80002458:	00913423          	sd	s1,8(sp)
    8000245c:	01213023          	sd	s2,0(sp)
    80002460:	02010413          	addi	s0,sp,32
  acquire(&pid_lock);
    80002464:	0000f917          	auipc	s2,0xf
    80002468:	4c490913          	addi	s2,s2,1220 # 80011928 <pid_lock>
    8000246c:	00090513          	mv	a0,s2
    80002470:	fffff097          	auipc	ra,0xfffff
    80002474:	a68080e7          	jalr	-1432(ra) # 80000ed8 <acquire>
  pid = nextpid;
    80002478:	00007797          	auipc	a5,0x7
    8000247c:	bc078793          	addi	a5,a5,-1088 # 80009038 <nextpid>
    80002480:	0007a483          	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80002484:	0014871b          	addiw	a4,s1,1
    80002488:	00e7a023          	sw	a4,0(a5)
  release(&pid_lock);
    8000248c:	00090513          	mv	a0,s2
    80002490:	fffff097          	auipc	ra,0xfffff
    80002494:	ac0080e7          	jalr	-1344(ra) # 80000f50 <release>
}
    80002498:	00048513          	mv	a0,s1
    8000249c:	01813083          	ld	ra,24(sp)
    800024a0:	01013403          	ld	s0,16(sp)
    800024a4:	00813483          	ld	s1,8(sp)
    800024a8:	00013903          	ld	s2,0(sp)
    800024ac:	02010113          	addi	sp,sp,32
    800024b0:	00008067          	ret

00000000800024b4 <proc_pagetable>:
{
    800024b4:	fe010113          	addi	sp,sp,-32
    800024b8:	00113c23          	sd	ra,24(sp)
    800024bc:	00813823          	sd	s0,16(sp)
    800024c0:	00913423          	sd	s1,8(sp)
    800024c4:	01213023          	sd	s2,0(sp)
    800024c8:	02010413          	addi	s0,sp,32
    800024cc:	00050913          	mv	s2,a0
  pagetable = uvmcreate();
    800024d0:	fffff097          	auipc	ra,0xfffff
    800024d4:	5ac080e7          	jalr	1452(ra) # 80001a7c <uvmcreate>
    800024d8:	00050493          	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    800024dc:	00a00713          	li	a4,10
    800024e0:	00006697          	auipc	a3,0x6
    800024e4:	b2068693          	addi	a3,a3,-1248 # 80008000 <trampoline>
    800024e8:	00001637          	lui	a2,0x1
    800024ec:	040005b7          	lui	a1,0x4000
    800024f0:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800024f4:	00c59593          	slli	a1,a1,0xc
    800024f8:	fffff097          	auipc	ra,0xfffff
    800024fc:	204080e7          	jalr	516(ra) # 800016fc <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    80002500:	00600713          	li	a4,6
    80002504:	05893683          	ld	a3,88(s2)
    80002508:	00001637          	lui	a2,0x1
    8000250c:	020005b7          	lui	a1,0x2000
    80002510:	fff58593          	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002514:	00d59593          	slli	a1,a1,0xd
    80002518:	00048513          	mv	a0,s1
    8000251c:	fffff097          	auipc	ra,0xfffff
    80002520:	1e0080e7          	jalr	480(ra) # 800016fc <mappages>
}
    80002524:	00048513          	mv	a0,s1
    80002528:	01813083          	ld	ra,24(sp)
    8000252c:	01013403          	ld	s0,16(sp)
    80002530:	00813483          	ld	s1,8(sp)
    80002534:	00013903          	ld	s2,0(sp)
    80002538:	02010113          	addi	sp,sp,32
    8000253c:	00008067          	ret

0000000080002540 <allocproc>:
{
    80002540:	fe010113          	addi	sp,sp,-32
    80002544:	00113c23          	sd	ra,24(sp)
    80002548:	00813823          	sd	s0,16(sp)
    8000254c:	00913423          	sd	s1,8(sp)
    80002550:	01213023          	sd	s2,0(sp)
    80002554:	02010413          	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80002558:	0000f497          	auipc	s1,0xf
    8000255c:	7e848493          	addi	s1,s1,2024 # 80011d40 <proc>
    80002560:	00015917          	auipc	s2,0x15
    80002564:	1e090913          	addi	s2,s2,480 # 80017740 <tickslock>
    acquire(&p->lock);
    80002568:	00048513          	mv	a0,s1
    8000256c:	fffff097          	auipc	ra,0xfffff
    80002570:	96c080e7          	jalr	-1684(ra) # 80000ed8 <acquire>
    if(p->state == UNUSED) {
    80002574:	0184a783          	lw	a5,24(s1)
    80002578:	02078063          	beqz	a5,80002598 <allocproc+0x58>
      release(&p->lock);
    8000257c:	00048513          	mv	a0,s1
    80002580:	fffff097          	auipc	ra,0xfffff
    80002584:	9d0080e7          	jalr	-1584(ra) # 80000f50 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002588:	16848493          	addi	s1,s1,360
    8000258c:	fd249ee3          	bne	s1,s2,80002568 <allocproc+0x28>
  return 0;
    80002590:	00000493          	li	s1,0
    80002594:	0640006f          	j	800025f8 <allocproc+0xb8>
  p->pid = allocpid();
    80002598:	00000097          	auipc	ra,0x0
    8000259c:	eb4080e7          	jalr	-332(ra) # 8000244c <allocpid>
    800025a0:	02a4ac23          	sw	a0,56(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    800025a4:	ffffe097          	auipc	ra,0xffffe
    800025a8:	724080e7          	jalr	1828(ra) # 80000cc8 <kalloc>
    800025ac:	00050913          	mv	s2,a0
    800025b0:	04a4bc23          	sd	a0,88(s1)
    800025b4:	06050063          	beqz	a0,80002614 <allocproc+0xd4>
  p->pagetable = proc_pagetable(p);
    800025b8:	00048513          	mv	a0,s1
    800025bc:	00000097          	auipc	ra,0x0
    800025c0:	ef8080e7          	jalr	-264(ra) # 800024b4 <proc_pagetable>
    800025c4:	04a4b823          	sd	a0,80(s1)
  memset(&p->context, 0, sizeof p->context);
    800025c8:	07000613          	li	a2,112
    800025cc:	00000593          	li	a1,0
    800025d0:	06048513          	addi	a0,s1,96
    800025d4:	fffff097          	auipc	ra,0xfffff
    800025d8:	9dc080e7          	jalr	-1572(ra) # 80000fb0 <memset>
  p->context.ra = (uint64)forkret;
    800025dc:	00000797          	auipc	a5,0x0
    800025e0:	e1478793          	addi	a5,a5,-492 # 800023f0 <forkret>
    800025e4:	06f4b023          	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800025e8:	0404b783          	ld	a5,64(s1)
    800025ec:	00001737          	lui	a4,0x1
    800025f0:	00e787b3          	add	a5,a5,a4
    800025f4:	06f4b423          	sd	a5,104(s1)
}
    800025f8:	00048513          	mv	a0,s1
    800025fc:	01813083          	ld	ra,24(sp)
    80002600:	01013403          	ld	s0,16(sp)
    80002604:	00813483          	ld	s1,8(sp)
    80002608:	00013903          	ld	s2,0(sp)
    8000260c:	02010113          	addi	sp,sp,32
    80002610:	00008067          	ret
    release(&p->lock);
    80002614:	00048513          	mv	a0,s1
    80002618:	fffff097          	auipc	ra,0xfffff
    8000261c:	938080e7          	jalr	-1736(ra) # 80000f50 <release>
    return 0;
    80002620:	00090493          	mv	s1,s2
    80002624:	fd5ff06f          	j	800025f8 <allocproc+0xb8>

0000000080002628 <proc_freepagetable>:
{
    80002628:	fe010113          	addi	sp,sp,-32
    8000262c:	00113c23          	sd	ra,24(sp)
    80002630:	00813823          	sd	s0,16(sp)
    80002634:	00913423          	sd	s1,8(sp)
    80002638:	01213023          	sd	s2,0(sp)
    8000263c:	02010413          	addi	s0,sp,32
    80002640:	00050493          	mv	s1,a0
    80002644:	00058913          	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80002648:	00000693          	li	a3,0
    8000264c:	00001637          	lui	a2,0x1
    80002650:	040005b7          	lui	a1,0x4000
    80002654:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002658:	00c59593          	slli	a1,a1,0xc
    8000265c:	fffff097          	auipc	ra,0xfffff
    80002660:	308080e7          	jalr	776(ra) # 80001964 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80002664:	00000693          	li	a3,0
    80002668:	00001637          	lui	a2,0x1
    8000266c:	020005b7          	lui	a1,0x2000
    80002670:	fff58593          	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002674:	00d59593          	slli	a1,a1,0xd
    80002678:	00048513          	mv	a0,s1
    8000267c:	fffff097          	auipc	ra,0xfffff
    80002680:	2e8080e7          	jalr	744(ra) # 80001964 <uvmunmap>
  if(sz > 0)
    80002684:	00091e63          	bnez	s2,800026a0 <proc_freepagetable+0x78>
}
    80002688:	01813083          	ld	ra,24(sp)
    8000268c:	01013403          	ld	s0,16(sp)
    80002690:	00813483          	ld	s1,8(sp)
    80002694:	00013903          	ld	s2,0(sp)
    80002698:	02010113          	addi	sp,sp,32
    8000269c:	00008067          	ret
    uvmfree(pagetable, sz);
    800026a0:	00090593          	mv	a1,s2
    800026a4:	00048513          	mv	a0,s1
    800026a8:	fffff097          	auipc	ra,0xfffff
    800026ac:	664080e7          	jalr	1636(ra) # 80001d0c <uvmfree>
}
    800026b0:	fd9ff06f          	j	80002688 <proc_freepagetable+0x60>

00000000800026b4 <freeproc>:
{
    800026b4:	fe010113          	addi	sp,sp,-32
    800026b8:	00113c23          	sd	ra,24(sp)
    800026bc:	00813823          	sd	s0,16(sp)
    800026c0:	00913423          	sd	s1,8(sp)
    800026c4:	02010413          	addi	s0,sp,32
    800026c8:	00050493          	mv	s1,a0
  if(p->tf)
    800026cc:	05853503          	ld	a0,88(a0)
    800026d0:	00050663          	beqz	a0,800026dc <freeproc+0x28>
    kfree((void*)p->tf);
    800026d4:	ffffe097          	auipc	ra,0xffffe
    800026d8:	410080e7          	jalr	1040(ra) # 80000ae4 <kfree>
  p->tf = 0;
    800026dc:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800026e0:	0504b503          	ld	a0,80(s1)
    800026e4:	00050863          	beqz	a0,800026f4 <freeproc+0x40>
    proc_freepagetable(p->pagetable, p->sz);
    800026e8:	0484b583          	ld	a1,72(s1)
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	f3c080e7          	jalr	-196(ra) # 80002628 <proc_freepagetable>
  p->pagetable = 0;
    800026f4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800026f8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800026fc:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80002700:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80002704:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80002708:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    8000270c:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80002710:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80002714:	0004ac23          	sw	zero,24(s1)
}
    80002718:	01813083          	ld	ra,24(sp)
    8000271c:	01013403          	ld	s0,16(sp)
    80002720:	00813483          	ld	s1,8(sp)
    80002724:	02010113          	addi	sp,sp,32
    80002728:	00008067          	ret

000000008000272c <userinit>:
{
    8000272c:	fe010113          	addi	sp,sp,-32
    80002730:	00113c23          	sd	ra,24(sp)
    80002734:	00813823          	sd	s0,16(sp)
    80002738:	00913423          	sd	s1,8(sp)
    8000273c:	02010413          	addi	s0,sp,32
  p = allocproc();
    80002740:	00000097          	auipc	ra,0x0
    80002744:	e00080e7          	jalr	-512(ra) # 80002540 <allocproc>
    80002748:	00050493          	mv	s1,a0
  initproc = p;
    8000274c:	00020797          	auipc	a5,0x20
    80002750:	38a7be23          	sd	a0,924(a5) # 80022ae8 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80002754:	03400613          	li	a2,52
    80002758:	00007597          	auipc	a1,0x7
    8000275c:	8a858593          	addi	a1,a1,-1880 # 80009000 <initcode>
    80002760:	05053503          	ld	a0,80(a0)
    80002764:	fffff097          	auipc	ra,0xfffff
    80002768:	374080e7          	jalr	884(ra) # 80001ad8 <uvminit>
  p->sz = PGSIZE;
    8000276c:	000017b7          	lui	a5,0x1
    80002770:	04f4b423          	sd	a5,72(s1)
  p->tf->epc = 0;      // user program counter
    80002774:	0584b703          	ld	a4,88(s1)
    80002778:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    8000277c:	0584b703          	ld	a4,88(s1)
    80002780:	02f73823          	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002784:	01000613          	li	a2,16
    80002788:	00006597          	auipc	a1,0x6
    8000278c:	cf058593          	addi	a1,a1,-784 # 80008478 <userret+0x3d4>
    80002790:	15848513          	addi	a0,s1,344
    80002794:	fffff097          	auipc	ra,0xfffff
    80002798:	a28080e7          	jalr	-1496(ra) # 800011bc <safestrcpy>
  p->cwd = namei("/");
    8000279c:	00006517          	auipc	a0,0x6
    800027a0:	cec50513          	addi	a0,a0,-788 # 80008488 <userret+0x3e4>
    800027a4:	00003097          	auipc	ra,0x3
    800027a8:	d3c080e7          	jalr	-708(ra) # 800054e0 <namei>
    800027ac:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800027b0:	00200793          	li	a5,2
    800027b4:	00f4ac23          	sw	a5,24(s1)
  release(&p->lock);
    800027b8:	00048513          	mv	a0,s1
    800027bc:	ffffe097          	auipc	ra,0xffffe
    800027c0:	794080e7          	jalr	1940(ra) # 80000f50 <release>
}
    800027c4:	01813083          	ld	ra,24(sp)
    800027c8:	01013403          	ld	s0,16(sp)
    800027cc:	00813483          	ld	s1,8(sp)
    800027d0:	02010113          	addi	sp,sp,32
    800027d4:	00008067          	ret

00000000800027d8 <growproc>:
{
    800027d8:	fe010113          	addi	sp,sp,-32
    800027dc:	00113c23          	sd	ra,24(sp)
    800027e0:	00813823          	sd	s0,16(sp)
    800027e4:	00913423          	sd	s1,8(sp)
    800027e8:	01213023          	sd	s2,0(sp)
    800027ec:	02010413          	addi	s0,sp,32
    800027f0:	00050493          	mv	s1,a0
  struct proc *p = myproc();
    800027f4:	00000097          	auipc	ra,0x0
    800027f8:	ba4080e7          	jalr	-1116(ra) # 80002398 <myproc>
    800027fc:	00050913          	mv	s2,a0
  sz = p->sz;
    80002800:	04853583          	ld	a1,72(a0)
    80002804:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80002808:	02904863          	bgtz	s1,80002838 <growproc+0x60>
  } else if(n < 0){
    8000280c:	0404ce63          	bltz	s1,80002868 <growproc+0x90>
  p->sz = sz;
    80002810:	02079793          	slli	a5,a5,0x20
    80002814:	0207d793          	srli	a5,a5,0x20
    80002818:	04f93423          	sd	a5,72(s2)
  return 0;
    8000281c:	00000513          	li	a0,0
}
    80002820:	01813083          	ld	ra,24(sp)
    80002824:	01013403          	ld	s0,16(sp)
    80002828:	00813483          	ld	s1,8(sp)
    8000282c:	00013903          	ld	s2,0(sp)
    80002830:	02010113          	addi	sp,sp,32
    80002834:	00008067          	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80002838:	00f4863b          	addw	a2,s1,a5
    8000283c:	02061613          	slli	a2,a2,0x20
    80002840:	02065613          	srli	a2,a2,0x20
    80002844:	02059593          	slli	a1,a1,0x20
    80002848:	0205d593          	srli	a1,a1,0x20
    8000284c:	05053503          	ld	a0,80(a0)
    80002850:	fffff097          	auipc	ra,0xfffff
    80002854:	3a8080e7          	jalr	936(ra) # 80001bf8 <uvmalloc>
    80002858:	0005079b          	sext.w	a5,a0
    8000285c:	fa079ae3          	bnez	a5,80002810 <growproc+0x38>
      return -1;
    80002860:	fff00513          	li	a0,-1
    80002864:	fbdff06f          	j	80002820 <growproc+0x48>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002868:	00f4863b          	addw	a2,s1,a5
    8000286c:	02061613          	slli	a2,a2,0x20
    80002870:	02065613          	srli	a2,a2,0x20
    80002874:	02059593          	slli	a1,a1,0x20
    80002878:	0205d593          	srli	a1,a1,0x20
    8000287c:	05053503          	ld	a0,80(a0)
    80002880:	fffff097          	auipc	ra,0xfffff
    80002884:	308080e7          	jalr	776(ra) # 80001b88 <uvmdealloc>
    80002888:	0005079b          	sext.w	a5,a0
    8000288c:	f85ff06f          	j	80002810 <growproc+0x38>

0000000080002890 <fork>:
{
    80002890:	fc010113          	addi	sp,sp,-64
    80002894:	02113c23          	sd	ra,56(sp)
    80002898:	02813823          	sd	s0,48(sp)
    8000289c:	02913423          	sd	s1,40(sp)
    800028a0:	03213023          	sd	s2,32(sp)
    800028a4:	01313c23          	sd	s3,24(sp)
    800028a8:	01413823          	sd	s4,16(sp)
    800028ac:	01513423          	sd	s5,8(sp)
    800028b0:	04010413          	addi	s0,sp,64
  struct proc *p = myproc();
    800028b4:	00000097          	auipc	ra,0x0
    800028b8:	ae4080e7          	jalr	-1308(ra) # 80002398 <myproc>
    800028bc:	00050a93          	mv	s5,a0
  if((np = allocproc()) == 0){
    800028c0:	00000097          	auipc	ra,0x0
    800028c4:	c80080e7          	jalr	-896(ra) # 80002540 <allocproc>
    800028c8:	12050463          	beqz	a0,800029f0 <fork+0x160>
    800028cc:	00050a13          	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800028d0:	048ab603          	ld	a2,72(s5)
    800028d4:	05053583          	ld	a1,80(a0)
    800028d8:	050ab503          	ld	a0,80(s5)
    800028dc:	fffff097          	auipc	ra,0xfffff
    800028e0:	47c080e7          	jalr	1148(ra) # 80001d58 <uvmcopy>
    800028e4:	06054263          	bltz	a0,80002948 <fork+0xb8>
  np->sz = p->sz;
    800028e8:	048ab783          	ld	a5,72(s5)
    800028ec:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    800028f0:	035a3023          	sd	s5,32(s4)
  *(np->tf) = *(p->tf);
    800028f4:	058ab683          	ld	a3,88(s5)
    800028f8:	00068793          	mv	a5,a3
    800028fc:	058a3703          	ld	a4,88(s4)
    80002900:	12068693          	addi	a3,a3,288
    80002904:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002908:	0087b503          	ld	a0,8(a5)
    8000290c:	0107b583          	ld	a1,16(a5)
    80002910:	0187b603          	ld	a2,24(a5)
    80002914:	01073023          	sd	a6,0(a4)
    80002918:	00a73423          	sd	a0,8(a4)
    8000291c:	00b73823          	sd	a1,16(a4)
    80002920:	00c73c23          	sd	a2,24(a4)
    80002924:	02078793          	addi	a5,a5,32
    80002928:	02070713          	addi	a4,a4,32
    8000292c:	fcd79ce3          	bne	a5,a3,80002904 <fork+0x74>
  np->tf->a0 = 0;
    80002930:	058a3783          	ld	a5,88(s4)
    80002934:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002938:	0d0a8493          	addi	s1,s5,208
    8000293c:	0d0a0913          	addi	s2,s4,208
    80002940:	150a8993          	addi	s3,s5,336
    80002944:	0300006f          	j	80002974 <fork+0xe4>
    freeproc(np);
    80002948:	000a0513          	mv	a0,s4
    8000294c:	00000097          	auipc	ra,0x0
    80002950:	d68080e7          	jalr	-664(ra) # 800026b4 <freeproc>
    release(&np->lock);
    80002954:	000a0513          	mv	a0,s4
    80002958:	ffffe097          	auipc	ra,0xffffe
    8000295c:	5f8080e7          	jalr	1528(ra) # 80000f50 <release>
    return -1;
    80002960:	fff00493          	li	s1,-1
    80002964:	0640006f          	j	800029c8 <fork+0x138>
  for(i = 0; i < NOFILE; i++)
    80002968:	00848493          	addi	s1,s1,8
    8000296c:	00890913          	addi	s2,s2,8
    80002970:	01348e63          	beq	s1,s3,8000298c <fork+0xfc>
    if(p->ofile[i])
    80002974:	0004b503          	ld	a0,0(s1)
    80002978:	fe0508e3          	beqz	a0,80002968 <fork+0xd8>
      np->ofile[i] = filedup(p->ofile[i]);
    8000297c:	00003097          	auipc	ra,0x3
    80002980:	458080e7          	jalr	1112(ra) # 80005dd4 <filedup>
    80002984:	00a93023          	sd	a0,0(s2)
    80002988:	fe1ff06f          	j	80002968 <fork+0xd8>
  np->cwd = idup(p->cwd);
    8000298c:	150ab503          	ld	a0,336(s5)
    80002990:	00002097          	auipc	ra,0x2
    80002994:	038080e7          	jalr	56(ra) # 800049c8 <idup>
    80002998:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000299c:	01000613          	li	a2,16
    800029a0:	158a8593          	addi	a1,s5,344
    800029a4:	158a0513          	addi	a0,s4,344
    800029a8:	fffff097          	auipc	ra,0xfffff
    800029ac:	814080e7          	jalr	-2028(ra) # 800011bc <safestrcpy>
  pid = np->pid;
    800029b0:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    800029b4:	00200793          	li	a5,2
    800029b8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800029bc:	000a0513          	mv	a0,s4
    800029c0:	ffffe097          	auipc	ra,0xffffe
    800029c4:	590080e7          	jalr	1424(ra) # 80000f50 <release>
}
    800029c8:	00048513          	mv	a0,s1
    800029cc:	03813083          	ld	ra,56(sp)
    800029d0:	03013403          	ld	s0,48(sp)
    800029d4:	02813483          	ld	s1,40(sp)
    800029d8:	02013903          	ld	s2,32(sp)
    800029dc:	01813983          	ld	s3,24(sp)
    800029e0:	01013a03          	ld	s4,16(sp)
    800029e4:	00813a83          	ld	s5,8(sp)
    800029e8:	04010113          	addi	sp,sp,64
    800029ec:	00008067          	ret
    return -1;
    800029f0:	fff00493          	li	s1,-1
    800029f4:	fd5ff06f          	j	800029c8 <fork+0x138>

00000000800029f8 <reparent>:
{
    800029f8:	fd010113          	addi	sp,sp,-48
    800029fc:	02113423          	sd	ra,40(sp)
    80002a00:	02813023          	sd	s0,32(sp)
    80002a04:	00913c23          	sd	s1,24(sp)
    80002a08:	01213823          	sd	s2,16(sp)
    80002a0c:	01313423          	sd	s3,8(sp)
    80002a10:	01413023          	sd	s4,0(sp)
    80002a14:	03010413          	addi	s0,sp,48
    80002a18:	00050913          	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002a1c:	0000f497          	auipc	s1,0xf
    80002a20:	32448493          	addi	s1,s1,804 # 80011d40 <proc>
      pp->parent = initproc;
    80002a24:	00020a17          	auipc	s4,0x20
    80002a28:	0c4a0a13          	addi	s4,s4,196 # 80022ae8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002a2c:	00015997          	auipc	s3,0x15
    80002a30:	d1498993          	addi	s3,s3,-748 # 80017740 <tickslock>
    80002a34:	00c0006f          	j	80002a40 <reparent+0x48>
    80002a38:	16848493          	addi	s1,s1,360
    80002a3c:	03348863          	beq	s1,s3,80002a6c <reparent+0x74>
    if(pp->parent == p){
    80002a40:	0204b783          	ld	a5,32(s1)
    80002a44:	ff279ae3          	bne	a5,s2,80002a38 <reparent+0x40>
      acquire(&pp->lock);
    80002a48:	00048513          	mv	a0,s1
    80002a4c:	ffffe097          	auipc	ra,0xffffe
    80002a50:	48c080e7          	jalr	1164(ra) # 80000ed8 <acquire>
      pp->parent = initproc;
    80002a54:	000a3783          	ld	a5,0(s4)
    80002a58:	02f4b023          	sd	a5,32(s1)
      release(&pp->lock);
    80002a5c:	00048513          	mv	a0,s1
    80002a60:	ffffe097          	auipc	ra,0xffffe
    80002a64:	4f0080e7          	jalr	1264(ra) # 80000f50 <release>
    80002a68:	fd1ff06f          	j	80002a38 <reparent+0x40>
}
    80002a6c:	02813083          	ld	ra,40(sp)
    80002a70:	02013403          	ld	s0,32(sp)
    80002a74:	01813483          	ld	s1,24(sp)
    80002a78:	01013903          	ld	s2,16(sp)
    80002a7c:	00813983          	ld	s3,8(sp)
    80002a80:	00013a03          	ld	s4,0(sp)
    80002a84:	03010113          	addi	sp,sp,48
    80002a88:	00008067          	ret

0000000080002a8c <scheduler>:
{
    80002a8c:	fc010113          	addi	sp,sp,-64
    80002a90:	02113c23          	sd	ra,56(sp)
    80002a94:	02813823          	sd	s0,48(sp)
    80002a98:	02913423          	sd	s1,40(sp)
    80002a9c:	03213023          	sd	s2,32(sp)
    80002aa0:	01313c23          	sd	s3,24(sp)
    80002aa4:	01413823          	sd	s4,16(sp)
    80002aa8:	01513423          	sd	s5,8(sp)
    80002aac:	01613023          	sd	s6,0(sp)
    80002ab0:	04010413          	addi	s0,sp,64
    80002ab4:	00020793          	mv	a5,tp
  int id = r_tp();
    80002ab8:	0007879b          	sext.w	a5,a5
  c->proc = 0;
    80002abc:	00779a93          	slli	s5,a5,0x7
    80002ac0:	0000f717          	auipc	a4,0xf
    80002ac4:	e6870713          	addi	a4,a4,-408 # 80011928 <pid_lock>
    80002ac8:	01570733          	add	a4,a4,s5
    80002acc:	00073c23          	sd	zero,24(a4)
        swtch(&c->scheduler, &p->context);
    80002ad0:	0000f717          	auipc	a4,0xf
    80002ad4:	e7870713          	addi	a4,a4,-392 # 80011948 <cpus+0x8>
    80002ad8:	00ea8ab3          	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80002adc:	00200993          	li	s3,2
        p->state = RUNNING;
    80002ae0:	00300b13          	li	s6,3
        c->proc = p;
    80002ae4:	00779793          	slli	a5,a5,0x7
    80002ae8:	0000fa17          	auipc	s4,0xf
    80002aec:	e40a0a13          	addi	s4,s4,-448 # 80011928 <pid_lock>
    80002af0:	00fa0a33          	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002af4:	00015917          	auipc	s2,0x15
    80002af8:	c4c90913          	addi	s2,s2,-948 # 80017740 <tickslock>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002afc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80002b00:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80002b04:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b08:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002b0c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b10:	10079073          	csrw	sstatus,a5
    80002b14:	0000f497          	auipc	s1,0xf
    80002b18:	22c48493          	addi	s1,s1,556 # 80011d40 <proc>
    80002b1c:	0180006f          	j	80002b34 <scheduler+0xa8>
      release(&p->lock);
    80002b20:	00048513          	mv	a0,s1
    80002b24:	ffffe097          	auipc	ra,0xffffe
    80002b28:	42c080e7          	jalr	1068(ra) # 80000f50 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002b2c:	16848493          	addi	s1,s1,360
    80002b30:	fd2486e3          	beq	s1,s2,80002afc <scheduler+0x70>
      acquire(&p->lock);
    80002b34:	00048513          	mv	a0,s1
    80002b38:	ffffe097          	auipc	ra,0xffffe
    80002b3c:	3a0080e7          	jalr	928(ra) # 80000ed8 <acquire>
      if(p->state == RUNNABLE) {
    80002b40:	0184a783          	lw	a5,24(s1)
    80002b44:	fd379ee3          	bne	a5,s3,80002b20 <scheduler+0x94>
        p->state = RUNNING;
    80002b48:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002b4c:	009a3c23          	sd	s1,24(s4)
        swtch(&c->scheduler, &p->context);
    80002b50:	06048593          	addi	a1,s1,96
    80002b54:	000a8513          	mv	a0,s5
    80002b58:	00001097          	auipc	ra,0x1
    80002b5c:	83c080e7          	jalr	-1988(ra) # 80003394 <swtch>
        c->proc = 0;
    80002b60:	000a3c23          	sd	zero,24(s4)
    80002b64:	fbdff06f          	j	80002b20 <scheduler+0x94>

0000000080002b68 <sched>:
{
    80002b68:	fd010113          	addi	sp,sp,-48
    80002b6c:	02113423          	sd	ra,40(sp)
    80002b70:	02813023          	sd	s0,32(sp)
    80002b74:	00913c23          	sd	s1,24(sp)
    80002b78:	01213823          	sd	s2,16(sp)
    80002b7c:	01313423          	sd	s3,8(sp)
    80002b80:	03010413          	addi	s0,sp,48
  struct proc *p = myproc();
    80002b84:	00000097          	auipc	ra,0x0
    80002b88:	814080e7          	jalr	-2028(ra) # 80002398 <myproc>
    80002b8c:	00050493          	mv	s1,a0
  if(!holding(&p->lock))
    80002b90:	ffffe097          	auipc	ra,0xffffe
    80002b94:	2e4080e7          	jalr	740(ra) # 80000e74 <holding>
    80002b98:	0a050863          	beqz	a0,80002c48 <sched+0xe0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002b9c:	00020793          	mv	a5,tp
  if(mycpu()->noff != 1)
    80002ba0:	0007879b          	sext.w	a5,a5
    80002ba4:	00779793          	slli	a5,a5,0x7
    80002ba8:	0000f717          	auipc	a4,0xf
    80002bac:	d8070713          	addi	a4,a4,-640 # 80011928 <pid_lock>
    80002bb0:	00f707b3          	add	a5,a4,a5
    80002bb4:	0907a703          	lw	a4,144(a5)
    80002bb8:	00100793          	li	a5,1
    80002bbc:	08f71e63          	bne	a4,a5,80002c58 <sched+0xf0>
  if(p->state == RUNNING)
    80002bc0:	0184a703          	lw	a4,24(s1)
    80002bc4:	00300793          	li	a5,3
    80002bc8:	0af70063          	beq	a4,a5,80002c68 <sched+0x100>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bcc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002bd0:	0027f793          	andi	a5,a5,2
  if(intr_get())
    80002bd4:	0a079263          	bnez	a5,80002c78 <sched+0x110>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002bd8:	00020793          	mv	a5,tp
  intena = mycpu()->intena;
    80002bdc:	0000f917          	auipc	s2,0xf
    80002be0:	d4c90913          	addi	s2,s2,-692 # 80011928 <pid_lock>
    80002be4:	0007879b          	sext.w	a5,a5
    80002be8:	00779793          	slli	a5,a5,0x7
    80002bec:	00f907b3          	add	a5,s2,a5
    80002bf0:	0947a983          	lw	s3,148(a5)
    80002bf4:	00020793          	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    80002bf8:	0007879b          	sext.w	a5,a5
    80002bfc:	00779793          	slli	a5,a5,0x7
    80002c00:	0000f597          	auipc	a1,0xf
    80002c04:	d4858593          	addi	a1,a1,-696 # 80011948 <cpus+0x8>
    80002c08:	00b785b3          	add	a1,a5,a1
    80002c0c:	06048513          	addi	a0,s1,96
    80002c10:	00000097          	auipc	ra,0x0
    80002c14:	784080e7          	jalr	1924(ra) # 80003394 <swtch>
    80002c18:	00020793          	mv	a5,tp
  mycpu()->intena = intena;
    80002c1c:	0007879b          	sext.w	a5,a5
    80002c20:	00779793          	slli	a5,a5,0x7
    80002c24:	00f90933          	add	s2,s2,a5
    80002c28:	09392a23          	sw	s3,148(s2)
}
    80002c2c:	02813083          	ld	ra,40(sp)
    80002c30:	02013403          	ld	s0,32(sp)
    80002c34:	01813483          	ld	s1,24(sp)
    80002c38:	01013903          	ld	s2,16(sp)
    80002c3c:	00813983          	ld	s3,8(sp)
    80002c40:	03010113          	addi	sp,sp,48
    80002c44:	00008067          	ret
    panic("sched p->lock");
    80002c48:	00006517          	auipc	a0,0x6
    80002c4c:	84850513          	addi	a0,a0,-1976 # 80008490 <userret+0x3ec>
    80002c50:	ffffe097          	auipc	ra,0xffffe
    80002c54:	a88080e7          	jalr	-1400(ra) # 800006d8 <panic>
    panic("sched locks");
    80002c58:	00006517          	auipc	a0,0x6
    80002c5c:	84850513          	addi	a0,a0,-1976 # 800084a0 <userret+0x3fc>
    80002c60:	ffffe097          	auipc	ra,0xffffe
    80002c64:	a78080e7          	jalr	-1416(ra) # 800006d8 <panic>
    panic("sched running");
    80002c68:	00006517          	auipc	a0,0x6
    80002c6c:	84850513          	addi	a0,a0,-1976 # 800084b0 <userret+0x40c>
    80002c70:	ffffe097          	auipc	ra,0xffffe
    80002c74:	a68080e7          	jalr	-1432(ra) # 800006d8 <panic>
    panic("sched interruptible");
    80002c78:	00006517          	auipc	a0,0x6
    80002c7c:	84850513          	addi	a0,a0,-1976 # 800084c0 <userret+0x41c>
    80002c80:	ffffe097          	auipc	ra,0xffffe
    80002c84:	a58080e7          	jalr	-1448(ra) # 800006d8 <panic>

0000000080002c88 <exit>:
{
    80002c88:	fd010113          	addi	sp,sp,-48
    80002c8c:	02113423          	sd	ra,40(sp)
    80002c90:	02813023          	sd	s0,32(sp)
    80002c94:	00913c23          	sd	s1,24(sp)
    80002c98:	01213823          	sd	s2,16(sp)
    80002c9c:	01313423          	sd	s3,8(sp)
    80002ca0:	01413023          	sd	s4,0(sp)
    80002ca4:	03010413          	addi	s0,sp,48
    80002ca8:	00050a13          	mv	s4,a0
  struct proc *p = myproc();
    80002cac:	fffff097          	auipc	ra,0xfffff
    80002cb0:	6ec080e7          	jalr	1772(ra) # 80002398 <myproc>
    80002cb4:	00050993          	mv	s3,a0
  if(p == initproc)
    80002cb8:	00020797          	auipc	a5,0x20
    80002cbc:	e307b783          	ld	a5,-464(a5) # 80022ae8 <initproc>
    80002cc0:	0d050493          	addi	s1,a0,208
    80002cc4:	15050913          	addi	s2,a0,336
    80002cc8:	02a79463          	bne	a5,a0,80002cf0 <exit+0x68>
    panic("init exiting");
    80002ccc:	00006517          	auipc	a0,0x6
    80002cd0:	80c50513          	addi	a0,a0,-2036 # 800084d8 <userret+0x434>
    80002cd4:	ffffe097          	auipc	ra,0xffffe
    80002cd8:	a04080e7          	jalr	-1532(ra) # 800006d8 <panic>
      fileclose(f);
    80002cdc:	00003097          	auipc	ra,0x3
    80002ce0:	168080e7          	jalr	360(ra) # 80005e44 <fileclose>
      p->ofile[fd] = 0;
    80002ce4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002ce8:	00848493          	addi	s1,s1,8
    80002cec:	01248863          	beq	s1,s2,80002cfc <exit+0x74>
    if(p->ofile[fd]){
    80002cf0:	0004b503          	ld	a0,0(s1)
    80002cf4:	fe0514e3          	bnez	a0,80002cdc <exit+0x54>
    80002cf8:	ff1ff06f          	j	80002ce8 <exit+0x60>
  begin_op();
    80002cfc:	00003097          	auipc	ra,0x3
    80002d00:	ab8080e7          	jalr	-1352(ra) # 800057b4 <begin_op>
  iput(p->cwd);
    80002d04:	1509b503          	ld	a0,336(s3)
    80002d08:	00002097          	auipc	ra,0x2
    80002d0c:	e90080e7          	jalr	-368(ra) # 80004b98 <iput>
  end_op();
    80002d10:	00003097          	auipc	ra,0x3
    80002d14:	b58080e7          	jalr	-1192(ra) # 80005868 <end_op>
  p->cwd = 0;
    80002d18:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    80002d1c:	00020497          	auipc	s1,0x20
    80002d20:	dcc48493          	addi	s1,s1,-564 # 80022ae8 <initproc>
    80002d24:	0004b503          	ld	a0,0(s1)
    80002d28:	ffffe097          	auipc	ra,0xffffe
    80002d2c:	1b0080e7          	jalr	432(ra) # 80000ed8 <acquire>
  wakeup1(initproc);
    80002d30:	0004b503          	ld	a0,0(s1)
    80002d34:	fffff097          	auipc	ra,0xfffff
    80002d38:	498080e7          	jalr	1176(ra) # 800021cc <wakeup1>
  release(&initproc->lock);
    80002d3c:	0004b503          	ld	a0,0(s1)
    80002d40:	ffffe097          	auipc	ra,0xffffe
    80002d44:	210080e7          	jalr	528(ra) # 80000f50 <release>
  acquire(&p->lock);
    80002d48:	00098513          	mv	a0,s3
    80002d4c:	ffffe097          	auipc	ra,0xffffe
    80002d50:	18c080e7          	jalr	396(ra) # 80000ed8 <acquire>
  struct proc *original_parent = p->parent;
    80002d54:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002d58:	00098513          	mv	a0,s3
    80002d5c:	ffffe097          	auipc	ra,0xffffe
    80002d60:	1f4080e7          	jalr	500(ra) # 80000f50 <release>
  acquire(&original_parent->lock);
    80002d64:	00048513          	mv	a0,s1
    80002d68:	ffffe097          	auipc	ra,0xffffe
    80002d6c:	170080e7          	jalr	368(ra) # 80000ed8 <acquire>
  acquire(&p->lock);
    80002d70:	00098513          	mv	a0,s3
    80002d74:	ffffe097          	auipc	ra,0xffffe
    80002d78:	164080e7          	jalr	356(ra) # 80000ed8 <acquire>
  reparent(p);
    80002d7c:	00098513          	mv	a0,s3
    80002d80:	00000097          	auipc	ra,0x0
    80002d84:	c78080e7          	jalr	-904(ra) # 800029f8 <reparent>
  wakeup1(original_parent);
    80002d88:	00048513          	mv	a0,s1
    80002d8c:	fffff097          	auipc	ra,0xfffff
    80002d90:	440080e7          	jalr	1088(ra) # 800021cc <wakeup1>
  p->xstate = status;
    80002d94:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002d98:	00400793          	li	a5,4
    80002d9c:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002da0:	00048513          	mv	a0,s1
    80002da4:	ffffe097          	auipc	ra,0xffffe
    80002da8:	1ac080e7          	jalr	428(ra) # 80000f50 <release>
  sched();
    80002dac:	00000097          	auipc	ra,0x0
    80002db0:	dbc080e7          	jalr	-580(ra) # 80002b68 <sched>
  panic("zombie exit");
    80002db4:	00005517          	auipc	a0,0x5
    80002db8:	73450513          	addi	a0,a0,1844 # 800084e8 <userret+0x444>
    80002dbc:	ffffe097          	auipc	ra,0xffffe
    80002dc0:	91c080e7          	jalr	-1764(ra) # 800006d8 <panic>

0000000080002dc4 <yield>:
{
    80002dc4:	fe010113          	addi	sp,sp,-32
    80002dc8:	00113c23          	sd	ra,24(sp)
    80002dcc:	00813823          	sd	s0,16(sp)
    80002dd0:	00913423          	sd	s1,8(sp)
    80002dd4:	02010413          	addi	s0,sp,32
  struct proc *p = myproc();
    80002dd8:	fffff097          	auipc	ra,0xfffff
    80002ddc:	5c0080e7          	jalr	1472(ra) # 80002398 <myproc>
    80002de0:	00050493          	mv	s1,a0
  acquire(&p->lock);
    80002de4:	ffffe097          	auipc	ra,0xffffe
    80002de8:	0f4080e7          	jalr	244(ra) # 80000ed8 <acquire>
  p->state = RUNNABLE;
    80002dec:	00200793          	li	a5,2
    80002df0:	00f4ac23          	sw	a5,24(s1)
  sched();
    80002df4:	00000097          	auipc	ra,0x0
    80002df8:	d74080e7          	jalr	-652(ra) # 80002b68 <sched>
  release(&p->lock);
    80002dfc:	00048513          	mv	a0,s1
    80002e00:	ffffe097          	auipc	ra,0xffffe
    80002e04:	150080e7          	jalr	336(ra) # 80000f50 <release>
}
    80002e08:	01813083          	ld	ra,24(sp)
    80002e0c:	01013403          	ld	s0,16(sp)
    80002e10:	00813483          	ld	s1,8(sp)
    80002e14:	02010113          	addi	sp,sp,32
    80002e18:	00008067          	ret

0000000080002e1c <sleep>:
{
    80002e1c:	fd010113          	addi	sp,sp,-48
    80002e20:	02113423          	sd	ra,40(sp)
    80002e24:	02813023          	sd	s0,32(sp)
    80002e28:	00913c23          	sd	s1,24(sp)
    80002e2c:	01213823          	sd	s2,16(sp)
    80002e30:	01313423          	sd	s3,8(sp)
    80002e34:	03010413          	addi	s0,sp,48
    80002e38:	00050993          	mv	s3,a0
    80002e3c:	00058913          	mv	s2,a1
  struct proc *p = myproc();
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	558080e7          	jalr	1368(ra) # 80002398 <myproc>
    80002e48:	00050493          	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002e4c:	07250263          	beq	a0,s2,80002eb0 <sleep+0x94>
    acquire(&p->lock);  //DOC: sleeplock1
    80002e50:	ffffe097          	auipc	ra,0xffffe
    80002e54:	088080e7          	jalr	136(ra) # 80000ed8 <acquire>
    release(lk);
    80002e58:	00090513          	mv	a0,s2
    80002e5c:	ffffe097          	auipc	ra,0xffffe
    80002e60:	0f4080e7          	jalr	244(ra) # 80000f50 <release>
  p->chan = chan;
    80002e64:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80002e68:	00100793          	li	a5,1
    80002e6c:	00f4ac23          	sw	a5,24(s1)
  sched();
    80002e70:	00000097          	auipc	ra,0x0
    80002e74:	cf8080e7          	jalr	-776(ra) # 80002b68 <sched>
  p->chan = 0;
    80002e78:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002e7c:	00048513          	mv	a0,s1
    80002e80:	ffffe097          	auipc	ra,0xffffe
    80002e84:	0d0080e7          	jalr	208(ra) # 80000f50 <release>
    acquire(lk);
    80002e88:	00090513          	mv	a0,s2
    80002e8c:	ffffe097          	auipc	ra,0xffffe
    80002e90:	04c080e7          	jalr	76(ra) # 80000ed8 <acquire>
}
    80002e94:	02813083          	ld	ra,40(sp)
    80002e98:	02013403          	ld	s0,32(sp)
    80002e9c:	01813483          	ld	s1,24(sp)
    80002ea0:	01013903          	ld	s2,16(sp)
    80002ea4:	00813983          	ld	s3,8(sp)
    80002ea8:	03010113          	addi	sp,sp,48
    80002eac:	00008067          	ret
  p->chan = chan;
    80002eb0:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002eb4:	00100793          	li	a5,1
    80002eb8:	00f52c23          	sw	a5,24(a0)
  sched();
    80002ebc:	00000097          	auipc	ra,0x0
    80002ec0:	cac080e7          	jalr	-852(ra) # 80002b68 <sched>
  p->chan = 0;
    80002ec4:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    80002ec8:	fcdff06f          	j	80002e94 <sleep+0x78>

0000000080002ecc <wait>:
{
    80002ecc:	fb010113          	addi	sp,sp,-80
    80002ed0:	04113423          	sd	ra,72(sp)
    80002ed4:	04813023          	sd	s0,64(sp)
    80002ed8:	02913c23          	sd	s1,56(sp)
    80002edc:	03213823          	sd	s2,48(sp)
    80002ee0:	03313423          	sd	s3,40(sp)
    80002ee4:	03413023          	sd	s4,32(sp)
    80002ee8:	01513c23          	sd	s5,24(sp)
    80002eec:	01613823          	sd	s6,16(sp)
    80002ef0:	01713423          	sd	s7,8(sp)
    80002ef4:	05010413          	addi	s0,sp,80
    80002ef8:	00050b13          	mv	s6,a0
  struct proc *p = myproc();
    80002efc:	fffff097          	auipc	ra,0xfffff
    80002f00:	49c080e7          	jalr	1180(ra) # 80002398 <myproc>
    80002f04:	00050913          	mv	s2,a0
  acquire(&p->lock);
    80002f08:	ffffe097          	auipc	ra,0xffffe
    80002f0c:	fd0080e7          	jalr	-48(ra) # 80000ed8 <acquire>
    havekids = 0;
    80002f10:	00000b93          	li	s7,0
        if(np->state == ZOMBIE){
    80002f14:	00400a13          	li	s4,4
        havekids = 1;
    80002f18:	00100a93          	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002f1c:	00015997          	auipc	s3,0x15
    80002f20:	82498993          	addi	s3,s3,-2012 # 80017740 <tickslock>
    havekids = 0;
    80002f24:	000b8713          	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002f28:	0000f497          	auipc	s1,0xf
    80002f2c:	e1848493          	addi	s1,s1,-488 # 80011d40 <proc>
    80002f30:	0780006f          	j	80002fa8 <wait+0xdc>
          pid = np->pid;
    80002f34:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002f38:	020b0063          	beqz	s6,80002f58 <wait+0x8c>
    80002f3c:	00400693          	li	a3,4
    80002f40:	03448613          	addi	a2,s1,52
    80002f44:	000b0593          	mv	a1,s6
    80002f48:	05093503          	ld	a0,80(s2)
    80002f4c:	fffff097          	auipc	ra,0xfffff
    80002f50:	f94080e7          	jalr	-108(ra) # 80001ee0 <copyout>
    80002f54:	02054663          	bltz	a0,80002f80 <wait+0xb4>
          freeproc(np);
    80002f58:	00048513          	mv	a0,s1
    80002f5c:	fffff097          	auipc	ra,0xfffff
    80002f60:	758080e7          	jalr	1880(ra) # 800026b4 <freeproc>
          release(&np->lock);
    80002f64:	00048513          	mv	a0,s1
    80002f68:	ffffe097          	auipc	ra,0xffffe
    80002f6c:	fe8080e7          	jalr	-24(ra) # 80000f50 <release>
          release(&p->lock);
    80002f70:	00090513          	mv	a0,s2
    80002f74:	ffffe097          	auipc	ra,0xffffe
    80002f78:	fdc080e7          	jalr	-36(ra) # 80000f50 <release>
          return pid;
    80002f7c:	0780006f          	j	80002ff4 <wait+0x128>
            release(&np->lock);
    80002f80:	00048513          	mv	a0,s1
    80002f84:	ffffe097          	auipc	ra,0xffffe
    80002f88:	fcc080e7          	jalr	-52(ra) # 80000f50 <release>
            release(&p->lock);
    80002f8c:	00090513          	mv	a0,s2
    80002f90:	ffffe097          	auipc	ra,0xffffe
    80002f94:	fc0080e7          	jalr	-64(ra) # 80000f50 <release>
            return -1;
    80002f98:	fff00993          	li	s3,-1
    80002f9c:	0580006f          	j	80002ff4 <wait+0x128>
    for(np = proc; np < &proc[NPROC]; np++){
    80002fa0:	16848493          	addi	s1,s1,360
    80002fa4:	03348a63          	beq	s1,s3,80002fd8 <wait+0x10c>
      if(np->parent == p){
    80002fa8:	0204b783          	ld	a5,32(s1)
    80002fac:	ff279ae3          	bne	a5,s2,80002fa0 <wait+0xd4>
        acquire(&np->lock);
    80002fb0:	00048513          	mv	a0,s1
    80002fb4:	ffffe097          	auipc	ra,0xffffe
    80002fb8:	f24080e7          	jalr	-220(ra) # 80000ed8 <acquire>
        if(np->state == ZOMBIE){
    80002fbc:	0184a783          	lw	a5,24(s1)
    80002fc0:	f7478ae3          	beq	a5,s4,80002f34 <wait+0x68>
        release(&np->lock);
    80002fc4:	00048513          	mv	a0,s1
    80002fc8:	ffffe097          	auipc	ra,0xffffe
    80002fcc:	f88080e7          	jalr	-120(ra) # 80000f50 <release>
        havekids = 1;
    80002fd0:	000a8713          	mv	a4,s5
    80002fd4:	fcdff06f          	j	80002fa0 <wait+0xd4>
    if(!havekids || p->killed){
    80002fd8:	00070663          	beqz	a4,80002fe4 <wait+0x118>
    80002fdc:	03092783          	lw	a5,48(s2)
    80002fe0:	04078263          	beqz	a5,80003024 <wait+0x158>
      release(&p->lock);
    80002fe4:	00090513          	mv	a0,s2
    80002fe8:	ffffe097          	auipc	ra,0xffffe
    80002fec:	f68080e7          	jalr	-152(ra) # 80000f50 <release>
      return -1;
    80002ff0:	fff00993          	li	s3,-1
}
    80002ff4:	00098513          	mv	a0,s3
    80002ff8:	04813083          	ld	ra,72(sp)
    80002ffc:	04013403          	ld	s0,64(sp)
    80003000:	03813483          	ld	s1,56(sp)
    80003004:	03013903          	ld	s2,48(sp)
    80003008:	02813983          	ld	s3,40(sp)
    8000300c:	02013a03          	ld	s4,32(sp)
    80003010:	01813a83          	ld	s5,24(sp)
    80003014:	01013b03          	ld	s6,16(sp)
    80003018:	00813b83          	ld	s7,8(sp)
    8000301c:	05010113          	addi	sp,sp,80
    80003020:	00008067          	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    80003024:	00090593          	mv	a1,s2
    80003028:	00090513          	mv	a0,s2
    8000302c:	00000097          	auipc	ra,0x0
    80003030:	df0080e7          	jalr	-528(ra) # 80002e1c <sleep>
    havekids = 0;
    80003034:	ef1ff06f          	j	80002f24 <wait+0x58>

0000000080003038 <wakeup>:
{
    80003038:	fc010113          	addi	sp,sp,-64
    8000303c:	02113c23          	sd	ra,56(sp)
    80003040:	02813823          	sd	s0,48(sp)
    80003044:	02913423          	sd	s1,40(sp)
    80003048:	03213023          	sd	s2,32(sp)
    8000304c:	01313c23          	sd	s3,24(sp)
    80003050:	01413823          	sd	s4,16(sp)
    80003054:	01513423          	sd	s5,8(sp)
    80003058:	04010413          	addi	s0,sp,64
    8000305c:	00050a13          	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80003060:	0000f497          	auipc	s1,0xf
    80003064:	ce048493          	addi	s1,s1,-800 # 80011d40 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80003068:	00100993          	li	s3,1
      p->state = RUNNABLE;
    8000306c:	00200a93          	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80003070:	00014917          	auipc	s2,0x14
    80003074:	6d090913          	addi	s2,s2,1744 # 80017740 <tickslock>
    80003078:	0180006f          	j	80003090 <wakeup+0x58>
    release(&p->lock);
    8000307c:	00048513          	mv	a0,s1
    80003080:	ffffe097          	auipc	ra,0xffffe
    80003084:	ed0080e7          	jalr	-304(ra) # 80000f50 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80003088:	16848493          	addi	s1,s1,360
    8000308c:	03248463          	beq	s1,s2,800030b4 <wakeup+0x7c>
    acquire(&p->lock);
    80003090:	00048513          	mv	a0,s1
    80003094:	ffffe097          	auipc	ra,0xffffe
    80003098:	e44080e7          	jalr	-444(ra) # 80000ed8 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    8000309c:	0184a783          	lw	a5,24(s1)
    800030a0:	fd379ee3          	bne	a5,s3,8000307c <wakeup+0x44>
    800030a4:	0284b783          	ld	a5,40(s1)
    800030a8:	fd479ae3          	bne	a5,s4,8000307c <wakeup+0x44>
      p->state = RUNNABLE;
    800030ac:	0154ac23          	sw	s5,24(s1)
    800030b0:	fcdff06f          	j	8000307c <wakeup+0x44>
}
    800030b4:	03813083          	ld	ra,56(sp)
    800030b8:	03013403          	ld	s0,48(sp)
    800030bc:	02813483          	ld	s1,40(sp)
    800030c0:	02013903          	ld	s2,32(sp)
    800030c4:	01813983          	ld	s3,24(sp)
    800030c8:	01013a03          	ld	s4,16(sp)
    800030cc:	00813a83          	ld	s5,8(sp)
    800030d0:	04010113          	addi	sp,sp,64
    800030d4:	00008067          	ret

00000000800030d8 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800030d8:	fd010113          	addi	sp,sp,-48
    800030dc:	02113423          	sd	ra,40(sp)
    800030e0:	02813023          	sd	s0,32(sp)
    800030e4:	00913c23          	sd	s1,24(sp)
    800030e8:	01213823          	sd	s2,16(sp)
    800030ec:	01313423          	sd	s3,8(sp)
    800030f0:	03010413          	addi	s0,sp,48
    800030f4:	00050913          	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800030f8:	0000f497          	auipc	s1,0xf
    800030fc:	c4848493          	addi	s1,s1,-952 # 80011d40 <proc>
    80003100:	00014997          	auipc	s3,0x14
    80003104:	64098993          	addi	s3,s3,1600 # 80017740 <tickslock>
    acquire(&p->lock);
    80003108:	00048513          	mv	a0,s1
    8000310c:	ffffe097          	auipc	ra,0xffffe
    80003110:	dcc080e7          	jalr	-564(ra) # 80000ed8 <acquire>
    if(p->pid == pid){
    80003114:	0384a783          	lw	a5,56(s1)
    80003118:	03278063          	beq	a5,s2,80003138 <kill+0x60>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000311c:	00048513          	mv	a0,s1
    80003120:	ffffe097          	auipc	ra,0xffffe
    80003124:	e30080e7          	jalr	-464(ra) # 80000f50 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80003128:	16848493          	addi	s1,s1,360
    8000312c:	fd349ee3          	bne	s1,s3,80003108 <kill+0x30>
  }
  return -1;
    80003130:	fff00513          	li	a0,-1
    80003134:	0240006f          	j	80003158 <kill+0x80>
      p->killed = 1;
    80003138:	00100793          	li	a5,1
    8000313c:	02f4a823          	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80003140:	0184a703          	lw	a4,24(s1)
    80003144:	02f70863          	beq	a4,a5,80003174 <kill+0x9c>
      release(&p->lock);
    80003148:	00048513          	mv	a0,s1
    8000314c:	ffffe097          	auipc	ra,0xffffe
    80003150:	e04080e7          	jalr	-508(ra) # 80000f50 <release>
      return 0;
    80003154:	00000513          	li	a0,0
}
    80003158:	02813083          	ld	ra,40(sp)
    8000315c:	02013403          	ld	s0,32(sp)
    80003160:	01813483          	ld	s1,24(sp)
    80003164:	01013903          	ld	s2,16(sp)
    80003168:	00813983          	ld	s3,8(sp)
    8000316c:	03010113          	addi	sp,sp,48
    80003170:	00008067          	ret
        p->state = RUNNABLE;
    80003174:	00200793          	li	a5,2
    80003178:	00f4ac23          	sw	a5,24(s1)
    8000317c:	fcdff06f          	j	80003148 <kill+0x70>

0000000080003180 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80003180:	fd010113          	addi	sp,sp,-48
    80003184:	02113423          	sd	ra,40(sp)
    80003188:	02813023          	sd	s0,32(sp)
    8000318c:	00913c23          	sd	s1,24(sp)
    80003190:	01213823          	sd	s2,16(sp)
    80003194:	01313423          	sd	s3,8(sp)
    80003198:	01413023          	sd	s4,0(sp)
    8000319c:	03010413          	addi	s0,sp,48
    800031a0:	00050493          	mv	s1,a0
    800031a4:	00058913          	mv	s2,a1
    800031a8:	00060993          	mv	s3,a2
    800031ac:	00068a13          	mv	s4,a3
  struct proc *p = myproc();
    800031b0:	fffff097          	auipc	ra,0xfffff
    800031b4:	1e8080e7          	jalr	488(ra) # 80002398 <myproc>
  if(user_dst){
    800031b8:	02048e63          	beqz	s1,800031f4 <either_copyout+0x74>
    return copyout(p->pagetable, dst, src, len);
    800031bc:	000a0693          	mv	a3,s4
    800031c0:	00098613          	mv	a2,s3
    800031c4:	00090593          	mv	a1,s2
    800031c8:	05053503          	ld	a0,80(a0)
    800031cc:	fffff097          	auipc	ra,0xfffff
    800031d0:	d14080e7          	jalr	-748(ra) # 80001ee0 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800031d4:	02813083          	ld	ra,40(sp)
    800031d8:	02013403          	ld	s0,32(sp)
    800031dc:	01813483          	ld	s1,24(sp)
    800031e0:	01013903          	ld	s2,16(sp)
    800031e4:	00813983          	ld	s3,8(sp)
    800031e8:	00013a03          	ld	s4,0(sp)
    800031ec:	03010113          	addi	sp,sp,48
    800031f0:	00008067          	ret
    memmove((char *)dst, src, len);
    800031f4:	000a061b          	sext.w	a2,s4
    800031f8:	00098593          	mv	a1,s3
    800031fc:	00090513          	mv	a0,s2
    80003200:	ffffe097          	auipc	ra,0xffffe
    80003204:	e44080e7          	jalr	-444(ra) # 80001044 <memmove>
    return 0;
    80003208:	00048513          	mv	a0,s1
    8000320c:	fc9ff06f          	j	800031d4 <either_copyout+0x54>

0000000080003210 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80003210:	fd010113          	addi	sp,sp,-48
    80003214:	02113423          	sd	ra,40(sp)
    80003218:	02813023          	sd	s0,32(sp)
    8000321c:	00913c23          	sd	s1,24(sp)
    80003220:	01213823          	sd	s2,16(sp)
    80003224:	01313423          	sd	s3,8(sp)
    80003228:	01413023          	sd	s4,0(sp)
    8000322c:	03010413          	addi	s0,sp,48
    80003230:	00050913          	mv	s2,a0
    80003234:	00058493          	mv	s1,a1
    80003238:	00060993          	mv	s3,a2
    8000323c:	00068a13          	mv	s4,a3
  struct proc *p = myproc();
    80003240:	fffff097          	auipc	ra,0xfffff
    80003244:	158080e7          	jalr	344(ra) # 80002398 <myproc>
  if(user_src){
    80003248:	02048e63          	beqz	s1,80003284 <either_copyin+0x74>
    return copyin(p->pagetable, dst, src, len);
    8000324c:	000a0693          	mv	a3,s4
    80003250:	00098613          	mv	a2,s3
    80003254:	00090593          	mv	a1,s2
    80003258:	05053503          	ld	a0,80(a0)
    8000325c:	fffff097          	auipc	ra,0xfffff
    80003260:	d6c080e7          	jalr	-660(ra) # 80001fc8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80003264:	02813083          	ld	ra,40(sp)
    80003268:	02013403          	ld	s0,32(sp)
    8000326c:	01813483          	ld	s1,24(sp)
    80003270:	01013903          	ld	s2,16(sp)
    80003274:	00813983          	ld	s3,8(sp)
    80003278:	00013a03          	ld	s4,0(sp)
    8000327c:	03010113          	addi	sp,sp,48
    80003280:	00008067          	ret
    memmove(dst, (char*)src, len);
    80003284:	000a061b          	sext.w	a2,s4
    80003288:	00098593          	mv	a1,s3
    8000328c:	00090513          	mv	a0,s2
    80003290:	ffffe097          	auipc	ra,0xffffe
    80003294:	db4080e7          	jalr	-588(ra) # 80001044 <memmove>
    return 0;
    80003298:	00048513          	mv	a0,s1
    8000329c:	fc9ff06f          	j	80003264 <either_copyin+0x54>

00000000800032a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800032a0:	fb010113          	addi	sp,sp,-80
    800032a4:	04113423          	sd	ra,72(sp)
    800032a8:	04813023          	sd	s0,64(sp)
    800032ac:	02913c23          	sd	s1,56(sp)
    800032b0:	03213823          	sd	s2,48(sp)
    800032b4:	03313423          	sd	s3,40(sp)
    800032b8:	03413023          	sd	s4,32(sp)
    800032bc:	01513c23          	sd	s5,24(sp)
    800032c0:	01613823          	sd	s6,16(sp)
    800032c4:	01713423          	sd	s7,8(sp)
    800032c8:	05010413          	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800032cc:	00005517          	auipc	a0,0x5
    800032d0:	eec50513          	addi	a0,a0,-276 # 800081b8 <userret+0x114>
    800032d4:	ffffd097          	auipc	ra,0xffffd
    800032d8:	460080e7          	jalr	1120(ra) # 80000734 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800032dc:	0000f497          	auipc	s1,0xf
    800032e0:	bbc48493          	addi	s1,s1,-1092 # 80011e98 <proc+0x158>
    800032e4:	00014917          	auipc	s2,0x14
    800032e8:	5b490913          	addi	s2,s2,1460 # 80017898 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800032ec:	00400b13          	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800032f0:	00005997          	auipc	s3,0x5
    800032f4:	20898993          	addi	s3,s3,520 # 800084f8 <userret+0x454>
    printf("%d %s %s", p->pid, state, p->name);
    800032f8:	00005a97          	auipc	s5,0x5
    800032fc:	208a8a93          	addi	s5,s5,520 # 80008500 <userret+0x45c>
    printf("\n");
    80003300:	00005a17          	auipc	s4,0x5
    80003304:	eb8a0a13          	addi	s4,s4,-328 # 800081b8 <userret+0x114>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003308:	00005b97          	auipc	s7,0x5
    8000330c:	658b8b93          	addi	s7,s7,1624 # 80008960 <states.0>
    80003310:	0280006f          	j	80003338 <procdump+0x98>
    printf("%d %s %s", p->pid, state, p->name);
    80003314:	ee06a583          	lw	a1,-288(a3)
    80003318:	000a8513          	mv	a0,s5
    8000331c:	ffffd097          	auipc	ra,0xffffd
    80003320:	418080e7          	jalr	1048(ra) # 80000734 <printf>
    printf("\n");
    80003324:	000a0513          	mv	a0,s4
    80003328:	ffffd097          	auipc	ra,0xffffd
    8000332c:	40c080e7          	jalr	1036(ra) # 80000734 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003330:	16848493          	addi	s1,s1,360
    80003334:	03248a63          	beq	s1,s2,80003368 <procdump+0xc8>
    if(p->state == UNUSED)
    80003338:	00048693          	mv	a3,s1
    8000333c:	ec04a783          	lw	a5,-320(s1)
    80003340:	fe0788e3          	beqz	a5,80003330 <procdump+0x90>
      state = "???";
    80003344:	00098613          	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003348:	fcfb66e3          	bltu	s6,a5,80003314 <procdump+0x74>
    8000334c:	02079713          	slli	a4,a5,0x20
    80003350:	01d75793          	srli	a5,a4,0x1d
    80003354:	00fb87b3          	add	a5,s7,a5
    80003358:	0007b603          	ld	a2,0(a5)
    8000335c:	fa061ce3          	bnez	a2,80003314 <procdump+0x74>
      state = "???";
    80003360:	00098613          	mv	a2,s3
    80003364:	fb1ff06f          	j	80003314 <procdump+0x74>
  }
}
    80003368:	04813083          	ld	ra,72(sp)
    8000336c:	04013403          	ld	s0,64(sp)
    80003370:	03813483          	ld	s1,56(sp)
    80003374:	03013903          	ld	s2,48(sp)
    80003378:	02813983          	ld	s3,40(sp)
    8000337c:	02013a03          	ld	s4,32(sp)
    80003380:	01813a83          	ld	s5,24(sp)
    80003384:	01013b03          	ld	s6,16(sp)
    80003388:	00813b83          	ld	s7,8(sp)
    8000338c:	05010113          	addi	sp,sp,80
    80003390:	00008067          	ret

0000000080003394 <swtch>:
    80003394:	00153023          	sd	ra,0(a0)
    80003398:	00253423          	sd	sp,8(a0)
    8000339c:	00853823          	sd	s0,16(a0)
    800033a0:	00953c23          	sd	s1,24(a0)
    800033a4:	03253023          	sd	s2,32(a0)
    800033a8:	03353423          	sd	s3,40(a0)
    800033ac:	03453823          	sd	s4,48(a0)
    800033b0:	03553c23          	sd	s5,56(a0)
    800033b4:	05653023          	sd	s6,64(a0)
    800033b8:	05753423          	sd	s7,72(a0)
    800033bc:	05853823          	sd	s8,80(a0)
    800033c0:	05953c23          	sd	s9,88(a0)
    800033c4:	07a53023          	sd	s10,96(a0)
    800033c8:	07b53423          	sd	s11,104(a0)
    800033cc:	0005b083          	ld	ra,0(a1)
    800033d0:	0085b103          	ld	sp,8(a1)
    800033d4:	0105b403          	ld	s0,16(a1)
    800033d8:	0185b483          	ld	s1,24(a1)
    800033dc:	0205b903          	ld	s2,32(a1)
    800033e0:	0285b983          	ld	s3,40(a1)
    800033e4:	0305ba03          	ld	s4,48(a1)
    800033e8:	0385ba83          	ld	s5,56(a1)
    800033ec:	0405bb03          	ld	s6,64(a1)
    800033f0:	0485bb83          	ld	s7,72(a1)
    800033f4:	0505bc03          	ld	s8,80(a1)
    800033f8:	0585bc83          	ld	s9,88(a1)
    800033fc:	0605bd03          	ld	s10,96(a1)
    80003400:	0685bd83          	ld	s11,104(a1)
    80003404:	00008067          	ret

0000000080003408 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003408:	ff010113          	addi	sp,sp,-16
    8000340c:	00113423          	sd	ra,8(sp)
    80003410:	00813023          	sd	s0,0(sp)
    80003414:	01010413          	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003418:	00005597          	auipc	a1,0x5
    8000341c:	12058593          	addi	a1,a1,288 # 80008538 <userret+0x494>
    80003420:	00014517          	auipc	a0,0x14
    80003424:	32050513          	addi	a0,a0,800 # 80017740 <tickslock>
    80003428:	ffffe097          	auipc	ra,0xffffe
    8000342c:	928080e7          	jalr	-1752(ra) # 80000d50 <initlock>
}
    80003430:	00813083          	ld	ra,8(sp)
    80003434:	00013403          	ld	s0,0(sp)
    80003438:	01010113          	addi	sp,sp,16
    8000343c:	00008067          	ret

0000000080003440 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003440:	ff010113          	addi	sp,sp,-16
    80003444:	00813423          	sd	s0,8(sp)
    80003448:	01010413          	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000344c:	00005797          	auipc	a5,0x5
    80003450:	86478793          	addi	a5,a5,-1948 # 80007cb0 <kernelvec>
    80003454:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80003458:	00813403          	ld	s0,8(sp)
    8000345c:	01010113          	addi	sp,sp,16
    80003460:	00008067          	ret

0000000080003464 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80003464:	ff010113          	addi	sp,sp,-16
    80003468:	00113423          	sd	ra,8(sp)
    8000346c:	00813023          	sd	s0,0(sp)
    80003470:	01010413          	addi	s0,sp,16
  struct proc *p = myproc();
    80003474:	fffff097          	auipc	ra,0xfffff
    80003478:	f24080e7          	jalr	-220(ra) # 80002398 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000347c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003480:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003484:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80003488:	00005697          	auipc	a3,0x5
    8000348c:	b7868693          	addi	a3,a3,-1160 # 80008000 <trampoline>
    80003490:	00005717          	auipc	a4,0x5
    80003494:	b7070713          	addi	a4,a4,-1168 # 80008000 <trampoline>
    80003498:	40d70733          	sub	a4,a4,a3
    8000349c:	040007b7          	lui	a5,0x4000
    800034a0:	fff78793          	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800034a4:	00c79793          	slli	a5,a5,0xc
    800034a8:	00f70733          	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800034ac:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
    800034b0:	05853703          	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800034b4:	18002673          	csrr	a2,satp
    800034b8:	00c73023          	sd	a2,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800034bc:	05853603          	ld	a2,88(a0)
    800034c0:	04053703          	ld	a4,64(a0)
    800034c4:	000015b7          	lui	a1,0x1
    800034c8:	00b70733          	add	a4,a4,a1
    800034cc:	00e63423          	sd	a4,8(a2) # 1008 <_entry-0x7fffeff8>
  p->tf->kernel_trap = (uint64)usertrap;
    800034d0:	05853703          	ld	a4,88(a0)
    800034d4:	00000617          	auipc	a2,0x0
    800034d8:	18c60613          	addi	a2,a2,396 # 80003660 <usertrap>
    800034dc:	00c73823          	sd	a2,16(a4)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    800034e0:	05853703          	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800034e4:	00020613          	mv	a2,tp
    800034e8:	02c73023          	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800034ec:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800034f0:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800034f4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800034f8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
    800034fc:	05853703          	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003500:	01873703          	ld	a4,24(a4)
    80003504:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80003508:	05053583          	ld	a1,80(a0)
    8000350c:	00c5d593          	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80003510:	00005717          	auipc	a4,0x5
    80003514:	b9470713          	addi	a4,a4,-1132 # 800080a4 <userret>
    80003518:	40d70733          	sub	a4,a4,a3
    8000351c:	00f707b3          	add	a5,a4,a5
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80003520:	fff00713          	li	a4,-1
    80003524:	03f71713          	slli	a4,a4,0x3f
    80003528:	00e5e5b3          	or	a1,a1,a4
    8000352c:	02000537          	lui	a0,0x2000
    80003530:	fff50513          	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80003534:	00d51513          	slli	a0,a0,0xd
    80003538:	000780e7          	jalr	a5
}
    8000353c:	00813083          	ld	ra,8(sp)
    80003540:	00013403          	ld	s0,0(sp)
    80003544:	01010113          	addi	sp,sp,16
    80003548:	00008067          	ret

000000008000354c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000354c:	fe010113          	addi	sp,sp,-32
    80003550:	00113c23          	sd	ra,24(sp)
    80003554:	00813823          	sd	s0,16(sp)
    80003558:	00913423          	sd	s1,8(sp)
    8000355c:	02010413          	addi	s0,sp,32
  acquire(&tickslock);
    80003560:	00014497          	auipc	s1,0x14
    80003564:	1e048493          	addi	s1,s1,480 # 80017740 <tickslock>
    80003568:	00048513          	mv	a0,s1
    8000356c:	ffffe097          	auipc	ra,0xffffe
    80003570:	96c080e7          	jalr	-1684(ra) # 80000ed8 <acquire>
  ticks++;
    80003574:	0001f517          	auipc	a0,0x1f
    80003578:	57c50513          	addi	a0,a0,1404 # 80022af0 <ticks>
    8000357c:	00052783          	lw	a5,0(a0)
    80003580:	0017879b          	addiw	a5,a5,1
    80003584:	00f52023          	sw	a5,0(a0)
  wakeup(&ticks);
    80003588:	00000097          	auipc	ra,0x0
    8000358c:	ab0080e7          	jalr	-1360(ra) # 80003038 <wakeup>
  release(&tickslock);
    80003590:	00048513          	mv	a0,s1
    80003594:	ffffe097          	auipc	ra,0xffffe
    80003598:	9bc080e7          	jalr	-1604(ra) # 80000f50 <release>
}
    8000359c:	01813083          	ld	ra,24(sp)
    800035a0:	01013403          	ld	s0,16(sp)
    800035a4:	00813483          	ld	s1,8(sp)
    800035a8:	02010113          	addi	sp,sp,32
    800035ac:	00008067          	ret

00000000800035b0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800035b0:	fe010113          	addi	sp,sp,-32
    800035b4:	00113c23          	sd	ra,24(sp)
    800035b8:	00813823          	sd	s0,16(sp)
    800035bc:	00913423          	sd	s1,8(sp)
    800035c0:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800035c4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800035c8:	02074663          	bltz	a4,800035f4 <devintr+0x44>
      virtio_disk_intr();
    }*/

    plic_complete(irq);
    return 1;
  } else if(scause == 0x8000000000000001L){
    800035cc:	fff00793          	li	a5,-1
    800035d0:	03f79793          	slli	a5,a5,0x3f
    800035d4:	00178793          	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800035d8:	00000513          	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800035dc:	04f70c63          	beq	a4,a5,80003634 <devintr+0x84>
  }
}
    800035e0:	01813083          	ld	ra,24(sp)
    800035e4:	01013403          	ld	s0,16(sp)
    800035e8:	00813483          	ld	s1,8(sp)
    800035ec:	02010113          	addi	sp,sp,32
    800035f0:	00008067          	ret
     (scause & 0xff) == 9){
    800035f4:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    800035f8:	00900693          	li	a3,9
    800035fc:	fcd798e3          	bne	a5,a3,800035cc <devintr+0x1c>
    int irq = plic_claim();
    80003600:	00005097          	auipc	ra,0x5
    80003604:	890080e7          	jalr	-1904(ra) # 80007e90 <plic_claim>
    80003608:	00050493          	mv	s1,a0
    if(irq == UART0_IRQ){
    8000360c:	00a00793          	li	a5,10
    80003610:	00f50c63          	beq	a0,a5,80003628 <devintr+0x78>
    plic_complete(irq);
    80003614:	00048513          	mv	a0,s1
    80003618:	00005097          	auipc	ra,0x5
    8000361c:	8b0080e7          	jalr	-1872(ra) # 80007ec8 <plic_complete>
    return 1;
    80003620:	00100513          	li	a0,1
    80003624:	fbdff06f          	j	800035e0 <devintr+0x30>
      uartintr();
    80003628:	ffffd097          	auipc	ra,0xffffd
    8000362c:	478080e7          	jalr	1144(ra) # 80000aa0 <uartintr>
    80003630:	fe5ff06f          	j	80003614 <devintr+0x64>
    if(cpuid() == 0){
    80003634:	fffff097          	auipc	ra,0xfffff
    80003638:	d14080e7          	jalr	-748(ra) # 80002348 <cpuid>
    8000363c:	00050c63          	beqz	a0,80003654 <devintr+0xa4>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003640:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80003644:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003648:	14479073          	csrw	sip,a5
    return 2;
    8000364c:	00200513          	li	a0,2
    80003650:	f91ff06f          	j	800035e0 <devintr+0x30>
      clockintr();
    80003654:	00000097          	auipc	ra,0x0
    80003658:	ef8080e7          	jalr	-264(ra) # 8000354c <clockintr>
    8000365c:	fe5ff06f          	j	80003640 <devintr+0x90>

0000000080003660 <usertrap>:
{
    80003660:	fe010113          	addi	sp,sp,-32
    80003664:	00113c23          	sd	ra,24(sp)
    80003668:	00813823          	sd	s0,16(sp)
    8000366c:	00913423          	sd	s1,8(sp)
    80003670:	01213023          	sd	s2,0(sp)
    80003674:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003678:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000367c:	1007f793          	andi	a5,a5,256
    80003680:	08079a63          	bnez	a5,80003714 <usertrap+0xb4>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003684:	00004797          	auipc	a5,0x4
    80003688:	62c78793          	addi	a5,a5,1580 # 80007cb0 <kernelvec>
    8000368c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80003690:	fffff097          	auipc	ra,0xfffff
    80003694:	d08080e7          	jalr	-760(ra) # 80002398 <myproc>
    80003698:	00050493          	mv	s1,a0
  p->tf->epc = r_sepc();
    8000369c:	05853783          	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800036a0:	14102773          	csrr	a4,sepc
    800036a4:	00e7bc23          	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800036a8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800036ac:	00800793          	li	a5,8
    800036b0:	08f71263          	bne	a4,a5,80003734 <usertrap+0xd4>
    if(p->killed)
    800036b4:	03052783          	lw	a5,48(a0)
    800036b8:	06079663          	bnez	a5,80003724 <usertrap+0xc4>
    p->tf->epc += 4;
    800036bc:	0584b703          	ld	a4,88(s1)
    800036c0:	01873783          	ld	a5,24(a4)
    800036c4:	00478793          	addi	a5,a5,4
    800036c8:	00f73c23          	sd	a5,24(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
    800036cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800036d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800036d4:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800036d8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800036dc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800036e0:	10079073          	csrw	sstatus,a5
    syscall();
    800036e4:	00000097          	auipc	ra,0x0
    800036e8:	430080e7          	jalr	1072(ra) # 80003b14 <syscall>
  if(p->killed)
    800036ec:	0304a783          	lw	a5,48(s1)
    800036f0:	0a079c63          	bnez	a5,800037a8 <usertrap+0x148>
  usertrapret();
    800036f4:	00000097          	auipc	ra,0x0
    800036f8:	d70080e7          	jalr	-656(ra) # 80003464 <usertrapret>
}
    800036fc:	01813083          	ld	ra,24(sp)
    80003700:	01013403          	ld	s0,16(sp)
    80003704:	00813483          	ld	s1,8(sp)
    80003708:	00013903          	ld	s2,0(sp)
    8000370c:	02010113          	addi	sp,sp,32
    80003710:	00008067          	ret
    panic("usertrap: not from user mode");
    80003714:	00005517          	auipc	a0,0x5
    80003718:	e2c50513          	addi	a0,a0,-468 # 80008540 <userret+0x49c>
    8000371c:	ffffd097          	auipc	ra,0xffffd
    80003720:	fbc080e7          	jalr	-68(ra) # 800006d8 <panic>
      exit(-1);
    80003724:	fff00513          	li	a0,-1
    80003728:	fffff097          	auipc	ra,0xfffff
    8000372c:	560080e7          	jalr	1376(ra) # 80002c88 <exit>
    80003730:	f8dff06f          	j	800036bc <usertrap+0x5c>
  } else if((which_dev = devintr()) != 0){
    80003734:	00000097          	auipc	ra,0x0
    80003738:	e7c080e7          	jalr	-388(ra) # 800035b0 <devintr>
    8000373c:	00050913          	mv	s2,a0
    80003740:	00050863          	beqz	a0,80003750 <usertrap+0xf0>
  if(p->killed)
    80003744:	0304a783          	lw	a5,48(s1)
    80003748:	04078663          	beqz	a5,80003794 <usertrap+0x134>
    8000374c:	03c0006f          	j	80003788 <usertrap+0x128>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003750:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003754:	0384a603          	lw	a2,56(s1)
    80003758:	00005517          	auipc	a0,0x5
    8000375c:	e0850513          	addi	a0,a0,-504 # 80008560 <userret+0x4bc>
    80003760:	ffffd097          	auipc	ra,0xffffd
    80003764:	fd4080e7          	jalr	-44(ra) # 80000734 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003768:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000376c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003770:	00005517          	auipc	a0,0x5
    80003774:	e2050513          	addi	a0,a0,-480 # 80008590 <userret+0x4ec>
    80003778:	ffffd097          	auipc	ra,0xffffd
    8000377c:	fbc080e7          	jalr	-68(ra) # 80000734 <printf>
    p->killed = 1;
    80003780:	00100793          	li	a5,1
    80003784:	02f4a823          	sw	a5,48(s1)
    exit(-1);
    80003788:	fff00513          	li	a0,-1
    8000378c:	fffff097          	auipc	ra,0xfffff
    80003790:	4fc080e7          	jalr	1276(ra) # 80002c88 <exit>
  if(which_dev == 2)
    80003794:	00200793          	li	a5,2
    80003798:	f4f91ee3          	bne	s2,a5,800036f4 <usertrap+0x94>
    yield();
    8000379c:	fffff097          	auipc	ra,0xfffff
    800037a0:	628080e7          	jalr	1576(ra) # 80002dc4 <yield>
    800037a4:	f51ff06f          	j	800036f4 <usertrap+0x94>
  int which_dev = 0;
    800037a8:	00000913          	li	s2,0
    800037ac:	fddff06f          	j	80003788 <usertrap+0x128>

00000000800037b0 <kerneltrap>:
{
    800037b0:	fd010113          	addi	sp,sp,-48
    800037b4:	02113423          	sd	ra,40(sp)
    800037b8:	02813023          	sd	s0,32(sp)
    800037bc:	00913c23          	sd	s1,24(sp)
    800037c0:	01213823          	sd	s2,16(sp)
    800037c4:	01313423          	sd	s3,8(sp)
    800037c8:	03010413          	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800037cc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800037d0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800037d4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800037d8:	1004f793          	andi	a5,s1,256
    800037dc:	04078463          	beqz	a5,80003824 <kerneltrap+0x74>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800037e0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800037e4:	0027f793          	andi	a5,a5,2
  if(intr_get() != 0)
    800037e8:	04079663          	bnez	a5,80003834 <kerneltrap+0x84>
  if((which_dev = devintr()) == 0){
    800037ec:	00000097          	auipc	ra,0x0
    800037f0:	dc4080e7          	jalr	-572(ra) # 800035b0 <devintr>
    800037f4:	04050863          	beqz	a0,80003844 <kerneltrap+0x94>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800037f8:	00200793          	li	a5,2
    800037fc:	08f50263          	beq	a0,a5,80003880 <kerneltrap+0xd0>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003800:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003804:	10049073          	csrw	sstatus,s1
}
    80003808:	02813083          	ld	ra,40(sp)
    8000380c:	02013403          	ld	s0,32(sp)
    80003810:	01813483          	ld	s1,24(sp)
    80003814:	01013903          	ld	s2,16(sp)
    80003818:	00813983          	ld	s3,8(sp)
    8000381c:	03010113          	addi	sp,sp,48
    80003820:	00008067          	ret
    panic("kerneltrap: not from supervisor mode");
    80003824:	00005517          	auipc	a0,0x5
    80003828:	d8c50513          	addi	a0,a0,-628 # 800085b0 <userret+0x50c>
    8000382c:	ffffd097          	auipc	ra,0xffffd
    80003830:	eac080e7          	jalr	-340(ra) # 800006d8 <panic>
    panic("kerneltrap: interrupts enabled");
    80003834:	00005517          	auipc	a0,0x5
    80003838:	da450513          	addi	a0,a0,-604 # 800085d8 <userret+0x534>
    8000383c:	ffffd097          	auipc	ra,0xffffd
    80003840:	e9c080e7          	jalr	-356(ra) # 800006d8 <panic>
    printf("scause %p\n", scause);
    80003844:	00098593          	mv	a1,s3
    80003848:	00005517          	auipc	a0,0x5
    8000384c:	db050513          	addi	a0,a0,-592 # 800085f8 <userret+0x554>
    80003850:	ffffd097          	auipc	ra,0xffffd
    80003854:	ee4080e7          	jalr	-284(ra) # 80000734 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003858:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000385c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003860:	00005517          	auipc	a0,0x5
    80003864:	da850513          	addi	a0,a0,-600 # 80008608 <userret+0x564>
    80003868:	ffffd097          	auipc	ra,0xffffd
    8000386c:	ecc080e7          	jalr	-308(ra) # 80000734 <printf>
    panic("kerneltrap");
    80003870:	00005517          	auipc	a0,0x5
    80003874:	db050513          	addi	a0,a0,-592 # 80008620 <userret+0x57c>
    80003878:	ffffd097          	auipc	ra,0xffffd
    8000387c:	e60080e7          	jalr	-416(ra) # 800006d8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003880:	fffff097          	auipc	ra,0xfffff
    80003884:	b18080e7          	jalr	-1256(ra) # 80002398 <myproc>
    80003888:	f6050ce3          	beqz	a0,80003800 <kerneltrap+0x50>
    8000388c:	fffff097          	auipc	ra,0xfffff
    80003890:	b0c080e7          	jalr	-1268(ra) # 80002398 <myproc>
    80003894:	01852703          	lw	a4,24(a0)
    80003898:	00300793          	li	a5,3
    8000389c:	f6f712e3          	bne	a4,a5,80003800 <kerneltrap+0x50>
    yield();
    800038a0:	fffff097          	auipc	ra,0xfffff
    800038a4:	524080e7          	jalr	1316(ra) # 80002dc4 <yield>
    800038a8:	f59ff06f          	j	80003800 <kerneltrap+0x50>

00000000800038ac <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800038ac:	fe010113          	addi	sp,sp,-32
    800038b0:	00113c23          	sd	ra,24(sp)
    800038b4:	00813823          	sd	s0,16(sp)
    800038b8:	00913423          	sd	s1,8(sp)
    800038bc:	02010413          	addi	s0,sp,32
    800038c0:	00050493          	mv	s1,a0
  struct proc *p = myproc();
    800038c4:	fffff097          	auipc	ra,0xfffff
    800038c8:	ad4080e7          	jalr	-1324(ra) # 80002398 <myproc>
  switch (n) {
    800038cc:	00500793          	li	a5,5
    800038d0:	0697ec63          	bltu	a5,s1,80003948 <argraw+0x9c>
    800038d4:	00249493          	slli	s1,s1,0x2
    800038d8:	00005717          	auipc	a4,0x5
    800038dc:	0b070713          	addi	a4,a4,176 # 80008988 <states.0+0x28>
    800038e0:	00e484b3          	add	s1,s1,a4
    800038e4:	0004a783          	lw	a5,0(s1)
    800038e8:	00e787b3          	add	a5,a5,a4
    800038ec:	00078067          	jr	a5
  case 0:
    return p->tf->a0;
    800038f0:	05853783          	ld	a5,88(a0)
    800038f4:	0707b503          	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    800038f8:	01813083          	ld	ra,24(sp)
    800038fc:	01013403          	ld	s0,16(sp)
    80003900:	00813483          	ld	s1,8(sp)
    80003904:	02010113          	addi	sp,sp,32
    80003908:	00008067          	ret
    return p->tf->a1;
    8000390c:	05853783          	ld	a5,88(a0)
    80003910:	0787b503          	ld	a0,120(a5)
    80003914:	fe5ff06f          	j	800038f8 <argraw+0x4c>
    return p->tf->a2;
    80003918:	05853783          	ld	a5,88(a0)
    8000391c:	0807b503          	ld	a0,128(a5)
    80003920:	fd9ff06f          	j	800038f8 <argraw+0x4c>
    return p->tf->a3;
    80003924:	05853783          	ld	a5,88(a0)
    80003928:	0887b503          	ld	a0,136(a5)
    8000392c:	fcdff06f          	j	800038f8 <argraw+0x4c>
    return p->tf->a4;
    80003930:	05853783          	ld	a5,88(a0)
    80003934:	0907b503          	ld	a0,144(a5)
    80003938:	fc1ff06f          	j	800038f8 <argraw+0x4c>
    return p->tf->a5;
    8000393c:	05853783          	ld	a5,88(a0)
    80003940:	0987b503          	ld	a0,152(a5)
    80003944:	fb5ff06f          	j	800038f8 <argraw+0x4c>
  panic("argraw");
    80003948:	00005517          	auipc	a0,0x5
    8000394c:	ce850513          	addi	a0,a0,-792 # 80008630 <userret+0x58c>
    80003950:	ffffd097          	auipc	ra,0xffffd
    80003954:	d88080e7          	jalr	-632(ra) # 800006d8 <panic>

0000000080003958 <fetchaddr>:
{
    80003958:	fe010113          	addi	sp,sp,-32
    8000395c:	00113c23          	sd	ra,24(sp)
    80003960:	00813823          	sd	s0,16(sp)
    80003964:	00913423          	sd	s1,8(sp)
    80003968:	01213023          	sd	s2,0(sp)
    8000396c:	02010413          	addi	s0,sp,32
    80003970:	00050493          	mv	s1,a0
    80003974:	00058913          	mv	s2,a1
  struct proc *p = myproc();
    80003978:	fffff097          	auipc	ra,0xfffff
    8000397c:	a20080e7          	jalr	-1504(ra) # 80002398 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80003980:	04853783          	ld	a5,72(a0)
    80003984:	04f4f263          	bgeu	s1,a5,800039c8 <fetchaddr+0x70>
    80003988:	00848713          	addi	a4,s1,8
    8000398c:	04e7e263          	bltu	a5,a4,800039d0 <fetchaddr+0x78>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003990:	00800693          	li	a3,8
    80003994:	00048613          	mv	a2,s1
    80003998:	00090593          	mv	a1,s2
    8000399c:	05053503          	ld	a0,80(a0)
    800039a0:	ffffe097          	auipc	ra,0xffffe
    800039a4:	628080e7          	jalr	1576(ra) # 80001fc8 <copyin>
    800039a8:	00a03533          	snez	a0,a0
    800039ac:	40a00533          	neg	a0,a0
}
    800039b0:	01813083          	ld	ra,24(sp)
    800039b4:	01013403          	ld	s0,16(sp)
    800039b8:	00813483          	ld	s1,8(sp)
    800039bc:	00013903          	ld	s2,0(sp)
    800039c0:	02010113          	addi	sp,sp,32
    800039c4:	00008067          	ret
    return -1;
    800039c8:	fff00513          	li	a0,-1
    800039cc:	fe5ff06f          	j	800039b0 <fetchaddr+0x58>
    800039d0:	fff00513          	li	a0,-1
    800039d4:	fddff06f          	j	800039b0 <fetchaddr+0x58>

00000000800039d8 <fetchstr>:
{
    800039d8:	fd010113          	addi	sp,sp,-48
    800039dc:	02113423          	sd	ra,40(sp)
    800039e0:	02813023          	sd	s0,32(sp)
    800039e4:	00913c23          	sd	s1,24(sp)
    800039e8:	01213823          	sd	s2,16(sp)
    800039ec:	01313423          	sd	s3,8(sp)
    800039f0:	03010413          	addi	s0,sp,48
    800039f4:	00050913          	mv	s2,a0
    800039f8:	00058493          	mv	s1,a1
    800039fc:	00060993          	mv	s3,a2
  struct proc *p = myproc();
    80003a00:	fffff097          	auipc	ra,0xfffff
    80003a04:	998080e7          	jalr	-1640(ra) # 80002398 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80003a08:	00098693          	mv	a3,s3
    80003a0c:	00090613          	mv	a2,s2
    80003a10:	00048593          	mv	a1,s1
    80003a14:	05053503          	ld	a0,80(a0)
    80003a18:	ffffe097          	auipc	ra,0xffffe
    80003a1c:	698080e7          	jalr	1688(ra) # 800020b0 <copyinstr>
  if(err < 0)
    80003a20:	00054863          	bltz	a0,80003a30 <fetchstr+0x58>
  return strlen(buf);
    80003a24:	00048513          	mv	a0,s1
    80003a28:	ffffd097          	auipc	ra,0xffffd
    80003a2c:	7e0080e7          	jalr	2016(ra) # 80001208 <strlen>
}
    80003a30:	02813083          	ld	ra,40(sp)
    80003a34:	02013403          	ld	s0,32(sp)
    80003a38:	01813483          	ld	s1,24(sp)
    80003a3c:	01013903          	ld	s2,16(sp)
    80003a40:	00813983          	ld	s3,8(sp)
    80003a44:	03010113          	addi	sp,sp,48
    80003a48:	00008067          	ret

0000000080003a4c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80003a4c:	fe010113          	addi	sp,sp,-32
    80003a50:	00113c23          	sd	ra,24(sp)
    80003a54:	00813823          	sd	s0,16(sp)
    80003a58:	00913423          	sd	s1,8(sp)
    80003a5c:	02010413          	addi	s0,sp,32
    80003a60:	00058493          	mv	s1,a1
  *ip = argraw(n);
    80003a64:	00000097          	auipc	ra,0x0
    80003a68:	e48080e7          	jalr	-440(ra) # 800038ac <argraw>
    80003a6c:	00a4a023          	sw	a0,0(s1)
  return 0;
}
    80003a70:	00000513          	li	a0,0
    80003a74:	01813083          	ld	ra,24(sp)
    80003a78:	01013403          	ld	s0,16(sp)
    80003a7c:	00813483          	ld	s1,8(sp)
    80003a80:	02010113          	addi	sp,sp,32
    80003a84:	00008067          	ret

0000000080003a88 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80003a88:	fe010113          	addi	sp,sp,-32
    80003a8c:	00113c23          	sd	ra,24(sp)
    80003a90:	00813823          	sd	s0,16(sp)
    80003a94:	00913423          	sd	s1,8(sp)
    80003a98:	02010413          	addi	s0,sp,32
    80003a9c:	00058493          	mv	s1,a1
  *ip = argraw(n);
    80003aa0:	00000097          	auipc	ra,0x0
    80003aa4:	e0c080e7          	jalr	-500(ra) # 800038ac <argraw>
    80003aa8:	00a4b023          	sd	a0,0(s1)
  return 0;
}
    80003aac:	00000513          	li	a0,0
    80003ab0:	01813083          	ld	ra,24(sp)
    80003ab4:	01013403          	ld	s0,16(sp)
    80003ab8:	00813483          	ld	s1,8(sp)
    80003abc:	02010113          	addi	sp,sp,32
    80003ac0:	00008067          	ret

0000000080003ac4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003ac4:	fe010113          	addi	sp,sp,-32
    80003ac8:	00113c23          	sd	ra,24(sp)
    80003acc:	00813823          	sd	s0,16(sp)
    80003ad0:	00913423          	sd	s1,8(sp)
    80003ad4:	01213023          	sd	s2,0(sp)
    80003ad8:	02010413          	addi	s0,sp,32
    80003adc:	00058493          	mv	s1,a1
    80003ae0:	00060913          	mv	s2,a2
  *ip = argraw(n);
    80003ae4:	00000097          	auipc	ra,0x0
    80003ae8:	dc8080e7          	jalr	-568(ra) # 800038ac <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80003aec:	00090613          	mv	a2,s2
    80003af0:	00048593          	mv	a1,s1
    80003af4:	00000097          	auipc	ra,0x0
    80003af8:	ee4080e7          	jalr	-284(ra) # 800039d8 <fetchstr>
}
    80003afc:	01813083          	ld	ra,24(sp)
    80003b00:	01013403          	ld	s0,16(sp)
    80003b04:	00813483          	ld	s1,8(sp)
    80003b08:	00013903          	ld	s2,0(sp)
    80003b0c:	02010113          	addi	sp,sp,32
    80003b10:	00008067          	ret

0000000080003b14 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80003b14:	fe010113          	addi	sp,sp,-32
    80003b18:	00113c23          	sd	ra,24(sp)
    80003b1c:	00813823          	sd	s0,16(sp)
    80003b20:	00913423          	sd	s1,8(sp)
    80003b24:	01213023          	sd	s2,0(sp)
    80003b28:	02010413          	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003b2c:	fffff097          	auipc	ra,0xfffff
    80003b30:	86c080e7          	jalr	-1940(ra) # 80002398 <myproc>
    80003b34:	00050493          	mv	s1,a0

  num = p->tf->a7;
    80003b38:	05853903          	ld	s2,88(a0)
    80003b3c:	0a893783          	ld	a5,168(s2)
    80003b40:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003b44:	fff7879b          	addiw	a5,a5,-1
    80003b48:	01400713          	li	a4,20
    80003b4c:	02f76463          	bltu	a4,a5,80003b74 <syscall+0x60>
    80003b50:	00369713          	slli	a4,a3,0x3
    80003b54:	00005797          	auipc	a5,0x5
    80003b58:	e4c78793          	addi	a5,a5,-436 # 800089a0 <syscalls>
    80003b5c:	00e787b3          	add	a5,a5,a4
    80003b60:	0007b783          	ld	a5,0(a5)
    80003b64:	00078863          	beqz	a5,80003b74 <syscall+0x60>
    p->tf->a0 = syscalls[num]();
    80003b68:	000780e7          	jalr	a5
    80003b6c:	06a93823          	sd	a0,112(s2)
    80003b70:	0280006f          	j	80003b98 <syscall+0x84>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003b74:	15848613          	addi	a2,s1,344
    80003b78:	0384a583          	lw	a1,56(s1)
    80003b7c:	00005517          	auipc	a0,0x5
    80003b80:	abc50513          	addi	a0,a0,-1348 # 80008638 <userret+0x594>
    80003b84:	ffffd097          	auipc	ra,0xffffd
    80003b88:	bb0080e7          	jalr	-1104(ra) # 80000734 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    80003b8c:	0584b783          	ld	a5,88(s1)
    80003b90:	fff00713          	li	a4,-1
    80003b94:	06e7b823          	sd	a4,112(a5)
  }
}
    80003b98:	01813083          	ld	ra,24(sp)
    80003b9c:	01013403          	ld	s0,16(sp)
    80003ba0:	00813483          	ld	s1,8(sp)
    80003ba4:	00013903          	ld	s2,0(sp)
    80003ba8:	02010113          	addi	sp,sp,32
    80003bac:	00008067          	ret

0000000080003bb0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003bb0:	fe010113          	addi	sp,sp,-32
    80003bb4:	00113c23          	sd	ra,24(sp)
    80003bb8:	00813823          	sd	s0,16(sp)
    80003bbc:	02010413          	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80003bc0:	fec40593          	addi	a1,s0,-20
    80003bc4:	00000513          	li	a0,0
    80003bc8:	00000097          	auipc	ra,0x0
    80003bcc:	e84080e7          	jalr	-380(ra) # 80003a4c <argint>
    return -1;
    80003bd0:	fff00793          	li	a5,-1
  if(argint(0, &n) < 0)
    80003bd4:	00054a63          	bltz	a0,80003be8 <sys_exit+0x38>
  exit(n);
    80003bd8:	fec42503          	lw	a0,-20(s0)
    80003bdc:	fffff097          	auipc	ra,0xfffff
    80003be0:	0ac080e7          	jalr	172(ra) # 80002c88 <exit>
  return 0;  // not reached
    80003be4:	00000793          	li	a5,0
}
    80003be8:	00078513          	mv	a0,a5
    80003bec:	01813083          	ld	ra,24(sp)
    80003bf0:	01013403          	ld	s0,16(sp)
    80003bf4:	02010113          	addi	sp,sp,32
    80003bf8:	00008067          	ret

0000000080003bfc <sys_getpid>:

uint64
sys_getpid(void)
{
    80003bfc:	ff010113          	addi	sp,sp,-16
    80003c00:	00113423          	sd	ra,8(sp)
    80003c04:	00813023          	sd	s0,0(sp)
    80003c08:	01010413          	addi	s0,sp,16
  return myproc()->pid;
    80003c0c:	ffffe097          	auipc	ra,0xffffe
    80003c10:	78c080e7          	jalr	1932(ra) # 80002398 <myproc>
}
    80003c14:	03852503          	lw	a0,56(a0)
    80003c18:	00813083          	ld	ra,8(sp)
    80003c1c:	00013403          	ld	s0,0(sp)
    80003c20:	01010113          	addi	sp,sp,16
    80003c24:	00008067          	ret

0000000080003c28 <sys_fork>:

uint64
sys_fork(void)
{
    80003c28:	ff010113          	addi	sp,sp,-16
    80003c2c:	00113423          	sd	ra,8(sp)
    80003c30:	00813023          	sd	s0,0(sp)
    80003c34:	01010413          	addi	s0,sp,16
  return fork();
    80003c38:	fffff097          	auipc	ra,0xfffff
    80003c3c:	c58080e7          	jalr	-936(ra) # 80002890 <fork>
}
    80003c40:	00813083          	ld	ra,8(sp)
    80003c44:	00013403          	ld	s0,0(sp)
    80003c48:	01010113          	addi	sp,sp,16
    80003c4c:	00008067          	ret

0000000080003c50 <sys_wait>:

uint64
sys_wait(void)
{
    80003c50:	fe010113          	addi	sp,sp,-32
    80003c54:	00113c23          	sd	ra,24(sp)
    80003c58:	00813823          	sd	s0,16(sp)
    80003c5c:	02010413          	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80003c60:	fe840593          	addi	a1,s0,-24
    80003c64:	00000513          	li	a0,0
    80003c68:	00000097          	auipc	ra,0x0
    80003c6c:	e20080e7          	jalr	-480(ra) # 80003a88 <argaddr>
    80003c70:	00050793          	mv	a5,a0
    return -1;
    80003c74:	fff00513          	li	a0,-1
  if(argaddr(0, &p) < 0)
    80003c78:	0007c863          	bltz	a5,80003c88 <sys_wait+0x38>
  return wait(p);
    80003c7c:	fe843503          	ld	a0,-24(s0)
    80003c80:	fffff097          	auipc	ra,0xfffff
    80003c84:	24c080e7          	jalr	588(ra) # 80002ecc <wait>
}
    80003c88:	01813083          	ld	ra,24(sp)
    80003c8c:	01013403          	ld	s0,16(sp)
    80003c90:	02010113          	addi	sp,sp,32
    80003c94:	00008067          	ret

0000000080003c98 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003c98:	fd010113          	addi	sp,sp,-48
    80003c9c:	02113423          	sd	ra,40(sp)
    80003ca0:	02813023          	sd	s0,32(sp)
    80003ca4:	00913c23          	sd	s1,24(sp)
    80003ca8:	03010413          	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80003cac:	fdc40593          	addi	a1,s0,-36
    80003cb0:	00000513          	li	a0,0
    80003cb4:	00000097          	auipc	ra,0x0
    80003cb8:	d98080e7          	jalr	-616(ra) # 80003a4c <argint>
    80003cbc:	00050793          	mv	a5,a0
    return -1;
    80003cc0:	fff00513          	li	a0,-1
  if(argint(0, &n) < 0)
    80003cc4:	0207c263          	bltz	a5,80003ce8 <sys_sbrk+0x50>
  addr = myproc()->sz;
    80003cc8:	ffffe097          	auipc	ra,0xffffe
    80003ccc:	6d0080e7          	jalr	1744(ra) # 80002398 <myproc>
    80003cd0:	04852483          	lw	s1,72(a0)
  if(growproc(n) < 0)
    80003cd4:	fdc42503          	lw	a0,-36(s0)
    80003cd8:	fffff097          	auipc	ra,0xfffff
    80003cdc:	b00080e7          	jalr	-1280(ra) # 800027d8 <growproc>
    80003ce0:	00054e63          	bltz	a0,80003cfc <sys_sbrk+0x64>
    return -1;
  return addr;
    80003ce4:	00048513          	mv	a0,s1
}
    80003ce8:	02813083          	ld	ra,40(sp)
    80003cec:	02013403          	ld	s0,32(sp)
    80003cf0:	01813483          	ld	s1,24(sp)
    80003cf4:	03010113          	addi	sp,sp,48
    80003cf8:	00008067          	ret
    return -1;
    80003cfc:	fff00513          	li	a0,-1
    80003d00:	fe9ff06f          	j	80003ce8 <sys_sbrk+0x50>

0000000080003d04 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003d04:	fc010113          	addi	sp,sp,-64
    80003d08:	02113c23          	sd	ra,56(sp)
    80003d0c:	02813823          	sd	s0,48(sp)
    80003d10:	02913423          	sd	s1,40(sp)
    80003d14:	03213023          	sd	s2,32(sp)
    80003d18:	01313c23          	sd	s3,24(sp)
    80003d1c:	04010413          	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80003d20:	fcc40593          	addi	a1,s0,-52
    80003d24:	00000513          	li	a0,0
    80003d28:	00000097          	auipc	ra,0x0
    80003d2c:	d24080e7          	jalr	-732(ra) # 80003a4c <argint>
    return -1;
    80003d30:	fff00793          	li	a5,-1
  if(argint(0, &n) < 0)
    80003d34:	06054c63          	bltz	a0,80003dac <sys_sleep+0xa8>
  acquire(&tickslock);
    80003d38:	00014517          	auipc	a0,0x14
    80003d3c:	a0850513          	addi	a0,a0,-1528 # 80017740 <tickslock>
    80003d40:	ffffd097          	auipc	ra,0xffffd
    80003d44:	198080e7          	jalr	408(ra) # 80000ed8 <acquire>
  ticks0 = ticks;
    80003d48:	0001f917          	auipc	s2,0x1f
    80003d4c:	da892903          	lw	s2,-600(s2) # 80022af0 <ticks>
  while(ticks - ticks0 < n){
    80003d50:	fcc42783          	lw	a5,-52(s0)
    80003d54:	04078263          	beqz	a5,80003d98 <sys_sleep+0x94>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003d58:	00014997          	auipc	s3,0x14
    80003d5c:	9e898993          	addi	s3,s3,-1560 # 80017740 <tickslock>
    80003d60:	0001f497          	auipc	s1,0x1f
    80003d64:	d9048493          	addi	s1,s1,-624 # 80022af0 <ticks>
    if(myproc()->killed){
    80003d68:	ffffe097          	auipc	ra,0xffffe
    80003d6c:	630080e7          	jalr	1584(ra) # 80002398 <myproc>
    80003d70:	03052783          	lw	a5,48(a0)
    80003d74:	04079c63          	bnez	a5,80003dcc <sys_sleep+0xc8>
    sleep(&ticks, &tickslock);
    80003d78:	00098593          	mv	a1,s3
    80003d7c:	00048513          	mv	a0,s1
    80003d80:	fffff097          	auipc	ra,0xfffff
    80003d84:	09c080e7          	jalr	156(ra) # 80002e1c <sleep>
  while(ticks - ticks0 < n){
    80003d88:	0004a783          	lw	a5,0(s1)
    80003d8c:	412787bb          	subw	a5,a5,s2
    80003d90:	fcc42703          	lw	a4,-52(s0)
    80003d94:	fce7eae3          	bltu	a5,a4,80003d68 <sys_sleep+0x64>
  }
  release(&tickslock);
    80003d98:	00014517          	auipc	a0,0x14
    80003d9c:	9a850513          	addi	a0,a0,-1624 # 80017740 <tickslock>
    80003da0:	ffffd097          	auipc	ra,0xffffd
    80003da4:	1b0080e7          	jalr	432(ra) # 80000f50 <release>
  return 0;
    80003da8:	00000793          	li	a5,0
}
    80003dac:	00078513          	mv	a0,a5
    80003db0:	03813083          	ld	ra,56(sp)
    80003db4:	03013403          	ld	s0,48(sp)
    80003db8:	02813483          	ld	s1,40(sp)
    80003dbc:	02013903          	ld	s2,32(sp)
    80003dc0:	01813983          	ld	s3,24(sp)
    80003dc4:	04010113          	addi	sp,sp,64
    80003dc8:	00008067          	ret
      release(&tickslock);
    80003dcc:	00014517          	auipc	a0,0x14
    80003dd0:	97450513          	addi	a0,a0,-1676 # 80017740 <tickslock>
    80003dd4:	ffffd097          	auipc	ra,0xffffd
    80003dd8:	17c080e7          	jalr	380(ra) # 80000f50 <release>
      return -1;
    80003ddc:	fff00793          	li	a5,-1
    80003de0:	fcdff06f          	j	80003dac <sys_sleep+0xa8>

0000000080003de4 <sys_kill>:

uint64
sys_kill(void)
{
    80003de4:	fe010113          	addi	sp,sp,-32
    80003de8:	00113c23          	sd	ra,24(sp)
    80003dec:	00813823          	sd	s0,16(sp)
    80003df0:	02010413          	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80003df4:	fec40593          	addi	a1,s0,-20
    80003df8:	00000513          	li	a0,0
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	c50080e7          	jalr	-944(ra) # 80003a4c <argint>
    80003e04:	00050793          	mv	a5,a0
    return -1;
    80003e08:	fff00513          	li	a0,-1
  if(argint(0, &pid) < 0)
    80003e0c:	0007c863          	bltz	a5,80003e1c <sys_kill+0x38>
  return kill(pid);
    80003e10:	fec42503          	lw	a0,-20(s0)
    80003e14:	fffff097          	auipc	ra,0xfffff
    80003e18:	2c4080e7          	jalr	708(ra) # 800030d8 <kill>
}
    80003e1c:	01813083          	ld	ra,24(sp)
    80003e20:	01013403          	ld	s0,16(sp)
    80003e24:	02010113          	addi	sp,sp,32
    80003e28:	00008067          	ret

0000000080003e2c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003e2c:	fe010113          	addi	sp,sp,-32
    80003e30:	00113c23          	sd	ra,24(sp)
    80003e34:	00813823          	sd	s0,16(sp)
    80003e38:	00913423          	sd	s1,8(sp)
    80003e3c:	02010413          	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003e40:	00014517          	auipc	a0,0x14
    80003e44:	90050513          	addi	a0,a0,-1792 # 80017740 <tickslock>
    80003e48:	ffffd097          	auipc	ra,0xffffd
    80003e4c:	090080e7          	jalr	144(ra) # 80000ed8 <acquire>
  xticks = ticks;
    80003e50:	0001f497          	auipc	s1,0x1f
    80003e54:	ca04a483          	lw	s1,-864(s1) # 80022af0 <ticks>
  release(&tickslock);
    80003e58:	00014517          	auipc	a0,0x14
    80003e5c:	8e850513          	addi	a0,a0,-1816 # 80017740 <tickslock>
    80003e60:	ffffd097          	auipc	ra,0xffffd
    80003e64:	0f0080e7          	jalr	240(ra) # 80000f50 <release>
  return xticks;
}
    80003e68:	02049513          	slli	a0,s1,0x20
    80003e6c:	02055513          	srli	a0,a0,0x20
    80003e70:	01813083          	ld	ra,24(sp)
    80003e74:	01013403          	ld	s0,16(sp)
    80003e78:	00813483          	ld	s1,8(sp)
    80003e7c:	02010113          	addi	sp,sp,32
    80003e80:	00008067          	ret

0000000080003e84 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003e84:	fd010113          	addi	sp,sp,-48
    80003e88:	02113423          	sd	ra,40(sp)
    80003e8c:	02813023          	sd	s0,32(sp)
    80003e90:	00913c23          	sd	s1,24(sp)
    80003e94:	01213823          	sd	s2,16(sp)
    80003e98:	01313423          	sd	s3,8(sp)
    80003e9c:	01413023          	sd	s4,0(sp)
    80003ea0:	03010413          	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003ea4:	00004597          	auipc	a1,0x4
    80003ea8:	7b458593          	addi	a1,a1,1972 # 80008658 <userret+0x5b4>
    80003eac:	00014517          	auipc	a0,0x14
    80003eb0:	8ac50513          	addi	a0,a0,-1876 # 80017758 <bcache>
    80003eb4:	ffffd097          	auipc	ra,0xffffd
    80003eb8:	e9c080e7          	jalr	-356(ra) # 80000d50 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003ebc:	0001c797          	auipc	a5,0x1c
    80003ec0:	89c78793          	addi	a5,a5,-1892 # 8001f758 <bcache+0x8000>
    80003ec4:	0001c717          	auipc	a4,0x1c
    80003ec8:	bec70713          	addi	a4,a4,-1044 # 8001fab0 <bcache+0x8358>
    80003ecc:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    80003ed0:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003ed4:	00014497          	auipc	s1,0x14
    80003ed8:	89c48493          	addi	s1,s1,-1892 # 80017770 <bcache+0x18>
    b->next = bcache.head.next;
    80003edc:	00078913          	mv	s2,a5
    b->prev = &bcache.head;
    80003ee0:	00070993          	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003ee4:	00004a17          	auipc	s4,0x4
    80003ee8:	77ca0a13          	addi	s4,s4,1916 # 80008660 <userret+0x5bc>
    b->next = bcache.head.next;
    80003eec:	3a893783          	ld	a5,936(s2)
    80003ef0:	04f4b823          	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003ef4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003ef8:	000a0593          	mv	a1,s4
    80003efc:	01048513          	addi	a0,s1,16
    80003f00:	00002097          	auipc	ra,0x2
    80003f04:	c48080e7          	jalr	-952(ra) # 80005b48 <initsleeplock>
    bcache.head.next->prev = b;
    80003f08:	3a893783          	ld	a5,936(s2)
    80003f0c:	0497b423          	sd	s1,72(a5)
    bcache.head.next = b;
    80003f10:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003f14:	46048493          	addi	s1,s1,1120
    80003f18:	fd349ae3          	bne	s1,s3,80003eec <binit+0x68>
  }
}
    80003f1c:	02813083          	ld	ra,40(sp)
    80003f20:	02013403          	ld	s0,32(sp)
    80003f24:	01813483          	ld	s1,24(sp)
    80003f28:	01013903          	ld	s2,16(sp)
    80003f2c:	00813983          	ld	s3,8(sp)
    80003f30:	00013a03          	ld	s4,0(sp)
    80003f34:	03010113          	addi	sp,sp,48
    80003f38:	00008067          	ret

0000000080003f3c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003f3c:	fd010113          	addi	sp,sp,-48
    80003f40:	02113423          	sd	ra,40(sp)
    80003f44:	02813023          	sd	s0,32(sp)
    80003f48:	00913c23          	sd	s1,24(sp)
    80003f4c:	01213823          	sd	s2,16(sp)
    80003f50:	01313423          	sd	s3,8(sp)
    80003f54:	03010413          	addi	s0,sp,48
    80003f58:	00050913          	mv	s2,a0
    80003f5c:	00058993          	mv	s3,a1
  acquire(&bcache.lock);
    80003f60:	00013517          	auipc	a0,0x13
    80003f64:	7f850513          	addi	a0,a0,2040 # 80017758 <bcache>
    80003f68:	ffffd097          	auipc	ra,0xffffd
    80003f6c:	f70080e7          	jalr	-144(ra) # 80000ed8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003f70:	0001c497          	auipc	s1,0x1c
    80003f74:	b904b483          	ld	s1,-1136(s1) # 8001fb00 <bcache+0x83a8>
    80003f78:	0001c797          	auipc	a5,0x1c
    80003f7c:	b3878793          	addi	a5,a5,-1224 # 8001fab0 <bcache+0x8358>
    80003f80:	04f48863          	beq	s1,a5,80003fd0 <bread+0x94>
    80003f84:	00078713          	mv	a4,a5
    80003f88:	00c0006f          	j	80003f94 <bread+0x58>
    80003f8c:	0504b483          	ld	s1,80(s1)
    80003f90:	04e48063          	beq	s1,a4,80003fd0 <bread+0x94>
    if(b->dev == dev && b->blockno == blockno){
    80003f94:	0044a783          	lw	a5,4(s1)
    80003f98:	ff279ae3          	bne	a5,s2,80003f8c <bread+0x50>
    80003f9c:	0084a783          	lw	a5,8(s1)
    80003fa0:	ff3796e3          	bne	a5,s3,80003f8c <bread+0x50>
      b->refcnt++;
    80003fa4:	0404a783          	lw	a5,64(s1)
    80003fa8:	0017879b          	addiw	a5,a5,1
    80003fac:	04f4a023          	sw	a5,64(s1)
      release(&bcache.lock);
    80003fb0:	00013517          	auipc	a0,0x13
    80003fb4:	7a850513          	addi	a0,a0,1960 # 80017758 <bcache>
    80003fb8:	ffffd097          	auipc	ra,0xffffd
    80003fbc:	f98080e7          	jalr	-104(ra) # 80000f50 <release>
      acquiresleep(&b->lock);
    80003fc0:	01048513          	addi	a0,s1,16
    80003fc4:	00002097          	auipc	ra,0x2
    80003fc8:	bdc080e7          	jalr	-1060(ra) # 80005ba0 <acquiresleep>
      return b;
    80003fcc:	06c0006f          	j	80004038 <bread+0xfc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003fd0:	0001c497          	auipc	s1,0x1c
    80003fd4:	b284b483          	ld	s1,-1240(s1) # 8001faf8 <bcache+0x83a0>
    80003fd8:	0001c797          	auipc	a5,0x1c
    80003fdc:	ad878793          	addi	a5,a5,-1320 # 8001fab0 <bcache+0x8358>
    80003fe0:	08f48263          	beq	s1,a5,80004064 <bread+0x128>
    80003fe4:	00078713          	mv	a4,a5
    80003fe8:	00c0006f          	j	80003ff4 <bread+0xb8>
    80003fec:	0484b483          	ld	s1,72(s1)
    80003ff0:	06e48a63          	beq	s1,a4,80004064 <bread+0x128>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
    80003ff4:	0404a783          	lw	a5,64(s1)
    80003ff8:	fe079ae3          	bnez	a5,80003fec <bread+0xb0>
    80003ffc:	0004a783          	lw	a5,0(s1)
    80004000:	0047f793          	andi	a5,a5,4
    80004004:	fe0794e3          	bnez	a5,80003fec <bread+0xb0>
      b->dev = dev;
    80004008:	0124a223          	sw	s2,4(s1)
      b->blockno = blockno;
    8000400c:	0134a423          	sw	s3,8(s1)
      b->flags = 0;
    80004010:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80004014:	00100793          	li	a5,1
    80004018:	04f4a023          	sw	a5,64(s1)
      release(&bcache.lock);
    8000401c:	00013517          	auipc	a0,0x13
    80004020:	73c50513          	addi	a0,a0,1852 # 80017758 <bcache>
    80004024:	ffffd097          	auipc	ra,0xffffd
    80004028:	f2c080e7          	jalr	-212(ra) # 80000f50 <release>
      acquiresleep(&b->lock);
    8000402c:	01048513          	addi	a0,s1,16
    80004030:	00002097          	auipc	ra,0x2
    80004034:	b70080e7          	jalr	-1168(ra) # 80005ba0 <acquiresleep>

  b = bget(dev, blockno);
  //if(!b->valid) {
    //virtio_disk_rw(b, 0);
    //b->valid = 1;
  if((b->flags & B_VALID) == 0) {
    80004038:	0004a783          	lw	a5,0(s1)
    8000403c:	0027f793          	andi	a5,a5,2
    80004040:	02078a63          	beqz	a5,80004074 <bread+0x138>
    ramdiskrw(b);
  }
  return b;
}
    80004044:	00048513          	mv	a0,s1
    80004048:	02813083          	ld	ra,40(sp)
    8000404c:	02013403          	ld	s0,32(sp)
    80004050:	01813483          	ld	s1,24(sp)
    80004054:	01013903          	ld	s2,16(sp)
    80004058:	00813983          	ld	s3,8(sp)
    8000405c:	03010113          	addi	sp,sp,48
    80004060:	00008067          	ret
  panic("bget: no buffers");
    80004064:	00004517          	auipc	a0,0x4
    80004068:	60450513          	addi	a0,a0,1540 # 80008668 <userret+0x5c4>
    8000406c:	ffffc097          	auipc	ra,0xffffc
    80004070:	66c080e7          	jalr	1644(ra) # 800006d8 <panic>
    ramdiskrw(b);
    80004074:	00048513          	mv	a0,s1
    80004078:	00002097          	auipc	ra,0x2
    8000407c:	708080e7          	jalr	1800(ra) # 80006780 <ramdiskrw>
  return b;
    80004080:	fc5ff06f          	j	80004044 <bread+0x108>

0000000080004084 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80004084:	fe010113          	addi	sp,sp,-32
    80004088:	00113c23          	sd	ra,24(sp)
    8000408c:	00813823          	sd	s0,16(sp)
    80004090:	00913423          	sd	s1,8(sp)
    80004094:	02010413          	addi	s0,sp,32
    80004098:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000409c:	01050513          	addi	a0,a0,16
    800040a0:	00002097          	auipc	ra,0x2
    800040a4:	bec080e7          	jalr	-1044(ra) # 80005c8c <holdingsleep>
    800040a8:	02050863          	beqz	a0,800040d8 <bwrite+0x54>
    panic("bwrite");
  //virtio_disk_rw(b, 1);
  b->flags |= B_DIRTY;
    800040ac:	0004a783          	lw	a5,0(s1)
    800040b0:	0047e793          	ori	a5,a5,4
    800040b4:	00f4a023          	sw	a5,0(s1)
  ramdiskrw(b);
    800040b8:	00048513          	mv	a0,s1
    800040bc:	00002097          	auipc	ra,0x2
    800040c0:	6c4080e7          	jalr	1732(ra) # 80006780 <ramdiskrw>
}
    800040c4:	01813083          	ld	ra,24(sp)
    800040c8:	01013403          	ld	s0,16(sp)
    800040cc:	00813483          	ld	s1,8(sp)
    800040d0:	02010113          	addi	sp,sp,32
    800040d4:	00008067          	ret
    panic("bwrite");
    800040d8:	00004517          	auipc	a0,0x4
    800040dc:	5a850513          	addi	a0,a0,1448 # 80008680 <userret+0x5dc>
    800040e0:	ffffc097          	auipc	ra,0xffffc
    800040e4:	5f8080e7          	jalr	1528(ra) # 800006d8 <panic>

00000000800040e8 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    800040e8:	fe010113          	addi	sp,sp,-32
    800040ec:	00113c23          	sd	ra,24(sp)
    800040f0:	00813823          	sd	s0,16(sp)
    800040f4:	00913423          	sd	s1,8(sp)
    800040f8:	01213023          	sd	s2,0(sp)
    800040fc:	02010413          	addi	s0,sp,32
    80004100:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80004104:	01050913          	addi	s2,a0,16
    80004108:	00090513          	mv	a0,s2
    8000410c:	00002097          	auipc	ra,0x2
    80004110:	b80080e7          	jalr	-1152(ra) # 80005c8c <holdingsleep>
    80004114:	08050e63          	beqz	a0,800041b0 <brelse+0xc8>
    panic("brelse");

  releasesleep(&b->lock);
    80004118:	00090513          	mv	a0,s2
    8000411c:	00002097          	auipc	ra,0x2
    80004120:	b0c080e7          	jalr	-1268(ra) # 80005c28 <releasesleep>

  acquire(&bcache.lock);
    80004124:	00013517          	auipc	a0,0x13
    80004128:	63450513          	addi	a0,a0,1588 # 80017758 <bcache>
    8000412c:	ffffd097          	auipc	ra,0xffffd
    80004130:	dac080e7          	jalr	-596(ra) # 80000ed8 <acquire>
  b->refcnt--;
    80004134:	0404a783          	lw	a5,64(s1)
    80004138:	fff7879b          	addiw	a5,a5,-1
    8000413c:	0007871b          	sext.w	a4,a5
    80004140:	04f4a023          	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80004144:	04071263          	bnez	a4,80004188 <brelse+0xa0>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80004148:	0504b783          	ld	a5,80(s1)
    8000414c:	0484b703          	ld	a4,72(s1)
    80004150:	04e7b423          	sd	a4,72(a5)
    b->prev->next = b->next;
    80004154:	0484b783          	ld	a5,72(s1)
    80004158:	0504b703          	ld	a4,80(s1)
    8000415c:	04e7b823          	sd	a4,80(a5)
    b->next = bcache.head.next;
    80004160:	0001b797          	auipc	a5,0x1b
    80004164:	5f878793          	addi	a5,a5,1528 # 8001f758 <bcache+0x8000>
    80004168:	3a87b703          	ld	a4,936(a5)
    8000416c:	04e4b823          	sd	a4,80(s1)
    b->prev = &bcache.head;
    80004170:	0001c717          	auipc	a4,0x1c
    80004174:	94070713          	addi	a4,a4,-1728 # 8001fab0 <bcache+0x8358>
    80004178:	04e4b423          	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000417c:	3a87b703          	ld	a4,936(a5)
    80004180:	04973423          	sd	s1,72(a4)
    bcache.head.next = b;
    80004184:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    80004188:	00013517          	auipc	a0,0x13
    8000418c:	5d050513          	addi	a0,a0,1488 # 80017758 <bcache>
    80004190:	ffffd097          	auipc	ra,0xffffd
    80004194:	dc0080e7          	jalr	-576(ra) # 80000f50 <release>
}
    80004198:	01813083          	ld	ra,24(sp)
    8000419c:	01013403          	ld	s0,16(sp)
    800041a0:	00813483          	ld	s1,8(sp)
    800041a4:	00013903          	ld	s2,0(sp)
    800041a8:	02010113          	addi	sp,sp,32
    800041ac:	00008067          	ret
    panic("brelse");
    800041b0:	00004517          	auipc	a0,0x4
    800041b4:	4d850513          	addi	a0,a0,1240 # 80008688 <userret+0x5e4>
    800041b8:	ffffc097          	auipc	ra,0xffffc
    800041bc:	520080e7          	jalr	1312(ra) # 800006d8 <panic>

00000000800041c0 <bpin>:

void
bpin(struct buf *b) {
    800041c0:	fe010113          	addi	sp,sp,-32
    800041c4:	00113c23          	sd	ra,24(sp)
    800041c8:	00813823          	sd	s0,16(sp)
    800041cc:	00913423          	sd	s1,8(sp)
    800041d0:	02010413          	addi	s0,sp,32
    800041d4:	00050493          	mv	s1,a0
  acquire(&bcache.lock);
    800041d8:	00013517          	auipc	a0,0x13
    800041dc:	58050513          	addi	a0,a0,1408 # 80017758 <bcache>
    800041e0:	ffffd097          	auipc	ra,0xffffd
    800041e4:	cf8080e7          	jalr	-776(ra) # 80000ed8 <acquire>
  b->refcnt++;
    800041e8:	0404a783          	lw	a5,64(s1)
    800041ec:	0017879b          	addiw	a5,a5,1
    800041f0:	04f4a023          	sw	a5,64(s1)
  release(&bcache.lock);
    800041f4:	00013517          	auipc	a0,0x13
    800041f8:	56450513          	addi	a0,a0,1380 # 80017758 <bcache>
    800041fc:	ffffd097          	auipc	ra,0xffffd
    80004200:	d54080e7          	jalr	-684(ra) # 80000f50 <release>
}
    80004204:	01813083          	ld	ra,24(sp)
    80004208:	01013403          	ld	s0,16(sp)
    8000420c:	00813483          	ld	s1,8(sp)
    80004210:	02010113          	addi	sp,sp,32
    80004214:	00008067          	ret

0000000080004218 <bunpin>:

void
bunpin(struct buf *b) {
    80004218:	fe010113          	addi	sp,sp,-32
    8000421c:	00113c23          	sd	ra,24(sp)
    80004220:	00813823          	sd	s0,16(sp)
    80004224:	00913423          	sd	s1,8(sp)
    80004228:	02010413          	addi	s0,sp,32
    8000422c:	00050493          	mv	s1,a0
  acquire(&bcache.lock);
    80004230:	00013517          	auipc	a0,0x13
    80004234:	52850513          	addi	a0,a0,1320 # 80017758 <bcache>
    80004238:	ffffd097          	auipc	ra,0xffffd
    8000423c:	ca0080e7          	jalr	-864(ra) # 80000ed8 <acquire>
  b->refcnt--;
    80004240:	0404a783          	lw	a5,64(s1)
    80004244:	fff7879b          	addiw	a5,a5,-1
    80004248:	04f4a023          	sw	a5,64(s1)
  release(&bcache.lock);
    8000424c:	00013517          	auipc	a0,0x13
    80004250:	50c50513          	addi	a0,a0,1292 # 80017758 <bcache>
    80004254:	ffffd097          	auipc	ra,0xffffd
    80004258:	cfc080e7          	jalr	-772(ra) # 80000f50 <release>
}
    8000425c:	01813083          	ld	ra,24(sp)
    80004260:	01013403          	ld	s0,16(sp)
    80004264:	00813483          	ld	s1,8(sp)
    80004268:	02010113          	addi	sp,sp,32
    8000426c:	00008067          	ret

0000000080004270 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80004270:	fe010113          	addi	sp,sp,-32
    80004274:	00113c23          	sd	ra,24(sp)
    80004278:	00813823          	sd	s0,16(sp)
    8000427c:	00913423          	sd	s1,8(sp)
    80004280:	01213023          	sd	s2,0(sp)
    80004284:	02010413          	addi	s0,sp,32
    80004288:	00058493          	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000428c:	00d5d59b          	srliw	a1,a1,0xd
    80004290:	0001c797          	auipc	a5,0x1c
    80004294:	c9c7a783          	lw	a5,-868(a5) # 8001ff2c <sb+0x1c>
    80004298:	00f585bb          	addw	a1,a1,a5
    8000429c:	00000097          	auipc	ra,0x0
    800042a0:	ca0080e7          	jalr	-864(ra) # 80003f3c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800042a4:	0074f713          	andi	a4,s1,7
    800042a8:	00100793          	li	a5,1
    800042ac:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800042b0:	03349493          	slli	s1,s1,0x33
    800042b4:	0364d493          	srli	s1,s1,0x36
    800042b8:	00950733          	add	a4,a0,s1
    800042bc:	06074703          	lbu	a4,96(a4)
    800042c0:	00e7f6b3          	and	a3,a5,a4
    800042c4:	04068263          	beqz	a3,80004308 <bfree+0x98>
    800042c8:	00050913          	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800042cc:	009504b3          	add	s1,a0,s1
    800042d0:	fff7c793          	not	a5,a5
    800042d4:	00f77733          	and	a4,a4,a5
    800042d8:	06e48023          	sb	a4,96(s1)
  log_write(bp);
    800042dc:	00001097          	auipc	ra,0x1
    800042e0:	738080e7          	jalr	1848(ra) # 80005a14 <log_write>
  brelse(bp);
    800042e4:	00090513          	mv	a0,s2
    800042e8:	00000097          	auipc	ra,0x0
    800042ec:	e00080e7          	jalr	-512(ra) # 800040e8 <brelse>
}
    800042f0:	01813083          	ld	ra,24(sp)
    800042f4:	01013403          	ld	s0,16(sp)
    800042f8:	00813483          	ld	s1,8(sp)
    800042fc:	00013903          	ld	s2,0(sp)
    80004300:	02010113          	addi	sp,sp,32
    80004304:	00008067          	ret
    panic("freeing free block");
    80004308:	00004517          	auipc	a0,0x4
    8000430c:	38850513          	addi	a0,a0,904 # 80008690 <userret+0x5ec>
    80004310:	ffffc097          	auipc	ra,0xffffc
    80004314:	3c8080e7          	jalr	968(ra) # 800006d8 <panic>

0000000080004318 <balloc>:
{
    80004318:	fa010113          	addi	sp,sp,-96
    8000431c:	04113c23          	sd	ra,88(sp)
    80004320:	04813823          	sd	s0,80(sp)
    80004324:	04913423          	sd	s1,72(sp)
    80004328:	05213023          	sd	s2,64(sp)
    8000432c:	03313c23          	sd	s3,56(sp)
    80004330:	03413823          	sd	s4,48(sp)
    80004334:	03513423          	sd	s5,40(sp)
    80004338:	03613023          	sd	s6,32(sp)
    8000433c:	01713c23          	sd	s7,24(sp)
    80004340:	01813823          	sd	s8,16(sp)
    80004344:	01913423          	sd	s9,8(sp)
    80004348:	06010413          	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000434c:	0001c797          	auipc	a5,0x1c
    80004350:	bc87a783          	lw	a5,-1080(a5) # 8001ff14 <sb+0x4>
    80004354:	0a078a63          	beqz	a5,80004408 <balloc+0xf0>
    80004358:	00050b93          	mv	s7,a0
    8000435c:	00000a93          	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80004360:	0001cb17          	auipc	s6,0x1c
    80004364:	bb0b0b13          	addi	s6,s6,-1104 # 8001ff10 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004368:	00000c13          	li	s8,0
      m = 1 << (bi % 8);
    8000436c:	00100993          	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004370:	00002a37          	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80004374:	00002cb7          	lui	s9,0x2
    80004378:	0200006f          	j	80004398 <balloc+0x80>
    brelse(bp);
    8000437c:	00090513          	mv	a0,s2
    80004380:	00000097          	auipc	ra,0x0
    80004384:	d68080e7          	jalr	-664(ra) # 800040e8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80004388:	015c87bb          	addw	a5,s9,s5
    8000438c:	00078a9b          	sext.w	s5,a5
    80004390:	004b2703          	lw	a4,4(s6)
    80004394:	06eafa63          	bgeu	s5,a4,80004408 <balloc+0xf0>
    bp = bread(dev, BBLOCK(b, sb));
    80004398:	41fad79b          	sraiw	a5,s5,0x1f
    8000439c:	0137d79b          	srliw	a5,a5,0x13
    800043a0:	015787bb          	addw	a5,a5,s5
    800043a4:	40d7d79b          	sraiw	a5,a5,0xd
    800043a8:	01cb2583          	lw	a1,28(s6)
    800043ac:	00b785bb          	addw	a1,a5,a1
    800043b0:	000b8513          	mv	a0,s7
    800043b4:	00000097          	auipc	ra,0x0
    800043b8:	b88080e7          	jalr	-1144(ra) # 80003f3c <bread>
    800043bc:	00050913          	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800043c0:	004b2503          	lw	a0,4(s6)
    800043c4:	000a849b          	sext.w	s1,s5
    800043c8:	000c0713          	mv	a4,s8
    800043cc:	faa4f8e3          	bgeu	s1,a0,8000437c <balloc+0x64>
      m = 1 << (bi % 8);
    800043d0:	00777693          	andi	a3,a4,7
    800043d4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800043d8:	41f7579b          	sraiw	a5,a4,0x1f
    800043dc:	01d7d79b          	srliw	a5,a5,0x1d
    800043e0:	00e787bb          	addw	a5,a5,a4
    800043e4:	4037d79b          	sraiw	a5,a5,0x3
    800043e8:	00f90633          	add	a2,s2,a5
    800043ec:	06064603          	lbu	a2,96(a2)
    800043f0:	00c6f5b3          	and	a1,a3,a2
    800043f4:	02058263          	beqz	a1,80004418 <balloc+0x100>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800043f8:	0017071b          	addiw	a4,a4,1
    800043fc:	0014849b          	addiw	s1,s1,1
    80004400:	fd4716e3          	bne	a4,s4,800043cc <balloc+0xb4>
    80004404:	f79ff06f          	j	8000437c <balloc+0x64>
  panic("balloc: out of blocks");
    80004408:	00004517          	auipc	a0,0x4
    8000440c:	2a050513          	addi	a0,a0,672 # 800086a8 <userret+0x604>
    80004410:	ffffc097          	auipc	ra,0xffffc
    80004414:	2c8080e7          	jalr	712(ra) # 800006d8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004418:	00f907b3          	add	a5,s2,a5
    8000441c:	00d66633          	or	a2,a2,a3
    80004420:	06c78023          	sb	a2,96(a5)
        log_write(bp);
    80004424:	00090513          	mv	a0,s2
    80004428:	00001097          	auipc	ra,0x1
    8000442c:	5ec080e7          	jalr	1516(ra) # 80005a14 <log_write>
        brelse(bp);
    80004430:	00090513          	mv	a0,s2
    80004434:	00000097          	auipc	ra,0x0
    80004438:	cb4080e7          	jalr	-844(ra) # 800040e8 <brelse>
  bp = bread(dev, bno);
    8000443c:	00048593          	mv	a1,s1
    80004440:	000b8513          	mv	a0,s7
    80004444:	00000097          	auipc	ra,0x0
    80004448:	af8080e7          	jalr	-1288(ra) # 80003f3c <bread>
    8000444c:	00050913          	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80004450:	40000613          	li	a2,1024
    80004454:	00000593          	li	a1,0
    80004458:	06050513          	addi	a0,a0,96
    8000445c:	ffffd097          	auipc	ra,0xffffd
    80004460:	b54080e7          	jalr	-1196(ra) # 80000fb0 <memset>
  log_write(bp);
    80004464:	00090513          	mv	a0,s2
    80004468:	00001097          	auipc	ra,0x1
    8000446c:	5ac080e7          	jalr	1452(ra) # 80005a14 <log_write>
  brelse(bp);
    80004470:	00090513          	mv	a0,s2
    80004474:	00000097          	auipc	ra,0x0
    80004478:	c74080e7          	jalr	-908(ra) # 800040e8 <brelse>
}
    8000447c:	00048513          	mv	a0,s1
    80004480:	05813083          	ld	ra,88(sp)
    80004484:	05013403          	ld	s0,80(sp)
    80004488:	04813483          	ld	s1,72(sp)
    8000448c:	04013903          	ld	s2,64(sp)
    80004490:	03813983          	ld	s3,56(sp)
    80004494:	03013a03          	ld	s4,48(sp)
    80004498:	02813a83          	ld	s5,40(sp)
    8000449c:	02013b03          	ld	s6,32(sp)
    800044a0:	01813b83          	ld	s7,24(sp)
    800044a4:	01013c03          	ld	s8,16(sp)
    800044a8:	00813c83          	ld	s9,8(sp)
    800044ac:	06010113          	addi	sp,sp,96
    800044b0:	00008067          	ret

00000000800044b4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800044b4:	fd010113          	addi	sp,sp,-48
    800044b8:	02113423          	sd	ra,40(sp)
    800044bc:	02813023          	sd	s0,32(sp)
    800044c0:	00913c23          	sd	s1,24(sp)
    800044c4:	01213823          	sd	s2,16(sp)
    800044c8:	01313423          	sd	s3,8(sp)
    800044cc:	01413023          	sd	s4,0(sp)
    800044d0:	03010413          	addi	s0,sp,48
    800044d4:	00050913          	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800044d8:	00b00793          	li	a5,11
    800044dc:	06b7fa63          	bgeu	a5,a1,80004550 <bmap+0x9c>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800044e0:	ff45849b          	addiw	s1,a1,-12
    800044e4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800044e8:	0ff00793          	li	a5,255
    800044ec:	0ce7e663          	bltu	a5,a4,800045b8 <bmap+0x104>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800044f0:	08052583          	lw	a1,128(a0)
    800044f4:	08058463          	beqz	a1,8000457c <bmap+0xc8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800044f8:	00092503          	lw	a0,0(s2)
    800044fc:	00000097          	auipc	ra,0x0
    80004500:	a40080e7          	jalr	-1472(ra) # 80003f3c <bread>
    80004504:	00050a13          	mv	s4,a0
    a = (uint*)bp->data;
    80004508:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    8000450c:	02049713          	slli	a4,s1,0x20
    80004510:	01e75593          	srli	a1,a4,0x1e
    80004514:	00b784b3          	add	s1,a5,a1
    80004518:	0004a983          	lw	s3,0(s1)
    8000451c:	06098c63          	beqz	s3,80004594 <bmap+0xe0>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80004520:	000a0513          	mv	a0,s4
    80004524:	00000097          	auipc	ra,0x0
    80004528:	bc4080e7          	jalr	-1084(ra) # 800040e8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000452c:	00098513          	mv	a0,s3
    80004530:	02813083          	ld	ra,40(sp)
    80004534:	02013403          	ld	s0,32(sp)
    80004538:	01813483          	ld	s1,24(sp)
    8000453c:	01013903          	ld	s2,16(sp)
    80004540:	00813983          	ld	s3,8(sp)
    80004544:	00013a03          	ld	s4,0(sp)
    80004548:	03010113          	addi	sp,sp,48
    8000454c:	00008067          	ret
    if((addr = ip->addrs[bn]) == 0)
    80004550:	02059793          	slli	a5,a1,0x20
    80004554:	01e7d593          	srli	a1,a5,0x1e
    80004558:	00b504b3          	add	s1,a0,a1
    8000455c:	0504a983          	lw	s3,80(s1)
    80004560:	fc0996e3          	bnez	s3,8000452c <bmap+0x78>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80004564:	00052503          	lw	a0,0(a0)
    80004568:	00000097          	auipc	ra,0x0
    8000456c:	db0080e7          	jalr	-592(ra) # 80004318 <balloc>
    80004570:	0005099b          	sext.w	s3,a0
    80004574:	0534a823          	sw	s3,80(s1)
    80004578:	fb5ff06f          	j	8000452c <bmap+0x78>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000457c:	00052503          	lw	a0,0(a0)
    80004580:	00000097          	auipc	ra,0x0
    80004584:	d98080e7          	jalr	-616(ra) # 80004318 <balloc>
    80004588:	0005059b          	sext.w	a1,a0
    8000458c:	08b92023          	sw	a1,128(s2)
    80004590:	f69ff06f          	j	800044f8 <bmap+0x44>
      a[bn] = addr = balloc(ip->dev);
    80004594:	00092503          	lw	a0,0(s2)
    80004598:	00000097          	auipc	ra,0x0
    8000459c:	d80080e7          	jalr	-640(ra) # 80004318 <balloc>
    800045a0:	0005099b          	sext.w	s3,a0
    800045a4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800045a8:	000a0513          	mv	a0,s4
    800045ac:	00001097          	auipc	ra,0x1
    800045b0:	468080e7          	jalr	1128(ra) # 80005a14 <log_write>
    800045b4:	f6dff06f          	j	80004520 <bmap+0x6c>
  panic("bmap: out of range");
    800045b8:	00004517          	auipc	a0,0x4
    800045bc:	10850513          	addi	a0,a0,264 # 800086c0 <userret+0x61c>
    800045c0:	ffffc097          	auipc	ra,0xffffc
    800045c4:	118080e7          	jalr	280(ra) # 800006d8 <panic>

00000000800045c8 <iget>:
{
    800045c8:	fd010113          	addi	sp,sp,-48
    800045cc:	02113423          	sd	ra,40(sp)
    800045d0:	02813023          	sd	s0,32(sp)
    800045d4:	00913c23          	sd	s1,24(sp)
    800045d8:	01213823          	sd	s2,16(sp)
    800045dc:	01313423          	sd	s3,8(sp)
    800045e0:	01413023          	sd	s4,0(sp)
    800045e4:	03010413          	addi	s0,sp,48
    800045e8:	00050993          	mv	s3,a0
    800045ec:	00058a13          	mv	s4,a1
  acquire(&icache.lock);
    800045f0:	0001c517          	auipc	a0,0x1c
    800045f4:	94050513          	addi	a0,a0,-1728 # 8001ff30 <icache>
    800045f8:	ffffd097          	auipc	ra,0xffffd
    800045fc:	8e0080e7          	jalr	-1824(ra) # 80000ed8 <acquire>
  empty = 0;
    80004600:	00000913          	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80004604:	0001c497          	auipc	s1,0x1c
    80004608:	94448493          	addi	s1,s1,-1724 # 8001ff48 <icache+0x18>
    8000460c:	0001d697          	auipc	a3,0x1d
    80004610:	3cc68693          	addi	a3,a3,972 # 800219d8 <log>
    80004614:	0100006f          	j	80004624 <iget+0x5c>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004618:	04090263          	beqz	s2,8000465c <iget+0x94>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000461c:	08848493          	addi	s1,s1,136
    80004620:	04d48463          	beq	s1,a3,80004668 <iget+0xa0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80004624:	0084a783          	lw	a5,8(s1)
    80004628:	fef058e3          	blez	a5,80004618 <iget+0x50>
    8000462c:	0004a703          	lw	a4,0(s1)
    80004630:	ff3714e3          	bne	a4,s3,80004618 <iget+0x50>
    80004634:	0044a703          	lw	a4,4(s1)
    80004638:	ff4710e3          	bne	a4,s4,80004618 <iget+0x50>
      ip->ref++;
    8000463c:	0017879b          	addiw	a5,a5,1
    80004640:	00f4a423          	sw	a5,8(s1)
      release(&icache.lock);
    80004644:	0001c517          	auipc	a0,0x1c
    80004648:	8ec50513          	addi	a0,a0,-1812 # 8001ff30 <icache>
    8000464c:	ffffd097          	auipc	ra,0xffffd
    80004650:	904080e7          	jalr	-1788(ra) # 80000f50 <release>
      return ip;
    80004654:	00048913          	mv	s2,s1
    80004658:	0380006f          	j	80004690 <iget+0xc8>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000465c:	fc0790e3          	bnez	a5,8000461c <iget+0x54>
    80004660:	00048913          	mv	s2,s1
    80004664:	fb9ff06f          	j	8000461c <iget+0x54>
  if(empty == 0)
    80004668:	04090663          	beqz	s2,800046b4 <iget+0xec>
  ip->dev = dev;
    8000466c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80004670:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80004674:	00100793          	li	a5,1
    80004678:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000467c:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80004680:	0001c517          	auipc	a0,0x1c
    80004684:	8b050513          	addi	a0,a0,-1872 # 8001ff30 <icache>
    80004688:	ffffd097          	auipc	ra,0xffffd
    8000468c:	8c8080e7          	jalr	-1848(ra) # 80000f50 <release>
}
    80004690:	00090513          	mv	a0,s2
    80004694:	02813083          	ld	ra,40(sp)
    80004698:	02013403          	ld	s0,32(sp)
    8000469c:	01813483          	ld	s1,24(sp)
    800046a0:	01013903          	ld	s2,16(sp)
    800046a4:	00813983          	ld	s3,8(sp)
    800046a8:	00013a03          	ld	s4,0(sp)
    800046ac:	03010113          	addi	sp,sp,48
    800046b0:	00008067          	ret
    panic("iget: no inodes");
    800046b4:	00004517          	auipc	a0,0x4
    800046b8:	02450513          	addi	a0,a0,36 # 800086d8 <userret+0x634>
    800046bc:	ffffc097          	auipc	ra,0xffffc
    800046c0:	01c080e7          	jalr	28(ra) # 800006d8 <panic>

00000000800046c4 <fsinit>:
fsinit(int dev) {
    800046c4:	fd010113          	addi	sp,sp,-48
    800046c8:	02113423          	sd	ra,40(sp)
    800046cc:	02813023          	sd	s0,32(sp)
    800046d0:	00913c23          	sd	s1,24(sp)
    800046d4:	01213823          	sd	s2,16(sp)
    800046d8:	01313423          	sd	s3,8(sp)
    800046dc:	03010413          	addi	s0,sp,48
    800046e0:	00050913          	mv	s2,a0
  bp = bread(dev, 1);
    800046e4:	00100593          	li	a1,1
    800046e8:	00000097          	auipc	ra,0x0
    800046ec:	854080e7          	jalr	-1964(ra) # 80003f3c <bread>
    800046f0:	00050493          	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800046f4:	0001c997          	auipc	s3,0x1c
    800046f8:	81c98993          	addi	s3,s3,-2020 # 8001ff10 <sb>
    800046fc:	02000613          	li	a2,32
    80004700:	06050593          	addi	a1,a0,96
    80004704:	00098513          	mv	a0,s3
    80004708:	ffffd097          	auipc	ra,0xffffd
    8000470c:	93c080e7          	jalr	-1732(ra) # 80001044 <memmove>
  brelse(bp);
    80004710:	00048513          	mv	a0,s1
    80004714:	00000097          	auipc	ra,0x0
    80004718:	9d4080e7          	jalr	-1580(ra) # 800040e8 <brelse>
  if(sb.magic != FSMAGIC)
    8000471c:	0009a703          	lw	a4,0(s3)
    80004720:	102037b7          	lui	a5,0x10203
    80004724:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004728:	02f71a63          	bne	a4,a5,8000475c <fsinit+0x98>
  initlog(dev, &sb);
    8000472c:	0001b597          	auipc	a1,0x1b
    80004730:	7e458593          	addi	a1,a1,2020 # 8001ff10 <sb>
    80004734:	00090513          	mv	a0,s2
    80004738:	00001097          	auipc	ra,0x1
    8000473c:	fa0080e7          	jalr	-96(ra) # 800056d8 <initlog>
}
    80004740:	02813083          	ld	ra,40(sp)
    80004744:	02013403          	ld	s0,32(sp)
    80004748:	01813483          	ld	s1,24(sp)
    8000474c:	01013903          	ld	s2,16(sp)
    80004750:	00813983          	ld	s3,8(sp)
    80004754:	03010113          	addi	sp,sp,48
    80004758:	00008067          	ret
    panic("invalid file system");
    8000475c:	00004517          	auipc	a0,0x4
    80004760:	f8c50513          	addi	a0,a0,-116 # 800086e8 <userret+0x644>
    80004764:	ffffc097          	auipc	ra,0xffffc
    80004768:	f74080e7          	jalr	-140(ra) # 800006d8 <panic>

000000008000476c <iinit>:
{
    8000476c:	fd010113          	addi	sp,sp,-48
    80004770:	02113423          	sd	ra,40(sp)
    80004774:	02813023          	sd	s0,32(sp)
    80004778:	00913c23          	sd	s1,24(sp)
    8000477c:	01213823          	sd	s2,16(sp)
    80004780:	01313423          	sd	s3,8(sp)
    80004784:	03010413          	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80004788:	00004597          	auipc	a1,0x4
    8000478c:	f7858593          	addi	a1,a1,-136 # 80008700 <userret+0x65c>
    80004790:	0001b517          	auipc	a0,0x1b
    80004794:	7a050513          	addi	a0,a0,1952 # 8001ff30 <icache>
    80004798:	ffffc097          	auipc	ra,0xffffc
    8000479c:	5b8080e7          	jalr	1464(ra) # 80000d50 <initlock>
  for(i = 0; i < NINODE; i++) {
    800047a0:	0001b497          	auipc	s1,0x1b
    800047a4:	7b848493          	addi	s1,s1,1976 # 8001ff58 <icache+0x28>
    800047a8:	0001d997          	auipc	s3,0x1d
    800047ac:	24098993          	addi	s3,s3,576 # 800219e8 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800047b0:	00004917          	auipc	s2,0x4
    800047b4:	f5890913          	addi	s2,s2,-168 # 80008708 <userret+0x664>
    800047b8:	00090593          	mv	a1,s2
    800047bc:	00048513          	mv	a0,s1
    800047c0:	00001097          	auipc	ra,0x1
    800047c4:	388080e7          	jalr	904(ra) # 80005b48 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800047c8:	08848493          	addi	s1,s1,136
    800047cc:	ff3496e3          	bne	s1,s3,800047b8 <iinit+0x4c>
}
    800047d0:	02813083          	ld	ra,40(sp)
    800047d4:	02013403          	ld	s0,32(sp)
    800047d8:	01813483          	ld	s1,24(sp)
    800047dc:	01013903          	ld	s2,16(sp)
    800047e0:	00813983          	ld	s3,8(sp)
    800047e4:	03010113          	addi	sp,sp,48
    800047e8:	00008067          	ret

00000000800047ec <ialloc>:
{
    800047ec:	fb010113          	addi	sp,sp,-80
    800047f0:	04113423          	sd	ra,72(sp)
    800047f4:	04813023          	sd	s0,64(sp)
    800047f8:	02913c23          	sd	s1,56(sp)
    800047fc:	03213823          	sd	s2,48(sp)
    80004800:	03313423          	sd	s3,40(sp)
    80004804:	03413023          	sd	s4,32(sp)
    80004808:	01513c23          	sd	s5,24(sp)
    8000480c:	01613823          	sd	s6,16(sp)
    80004810:	01713423          	sd	s7,8(sp)
    80004814:	05010413          	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80004818:	0001b717          	auipc	a4,0x1b
    8000481c:	70472703          	lw	a4,1796(a4) # 8001ff1c <sb+0xc>
    80004820:	00100793          	li	a5,1
    80004824:	06e7f463          	bgeu	a5,a4,8000488c <ialloc+0xa0>
    80004828:	00050a93          	mv	s5,a0
    8000482c:	00058b93          	mv	s7,a1
    80004830:	00100493          	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80004834:	0001ba17          	auipc	s4,0x1b
    80004838:	6dca0a13          	addi	s4,s4,1756 # 8001ff10 <sb>
    8000483c:	00048b1b          	sext.w	s6,s1
    80004840:	0044d593          	srli	a1,s1,0x4
    80004844:	018a2783          	lw	a5,24(s4)
    80004848:	00b785bb          	addw	a1,a5,a1
    8000484c:	000a8513          	mv	a0,s5
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	6ec080e7          	jalr	1772(ra) # 80003f3c <bread>
    80004858:	00050913          	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000485c:	06050993          	addi	s3,a0,96
    80004860:	00f4f793          	andi	a5,s1,15
    80004864:	00679793          	slli	a5,a5,0x6
    80004868:	00f989b3          	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000486c:	00099783          	lh	a5,0(s3)
    80004870:	02078663          	beqz	a5,8000489c <ialloc+0xb0>
    brelse(bp);
    80004874:	00000097          	auipc	ra,0x0
    80004878:	874080e7          	jalr	-1932(ra) # 800040e8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000487c:	00148493          	addi	s1,s1,1
    80004880:	00ca2703          	lw	a4,12(s4)
    80004884:	0004879b          	sext.w	a5,s1
    80004888:	fae7eae3          	bltu	a5,a4,8000483c <ialloc+0x50>
  panic("ialloc: no inodes");
    8000488c:	00004517          	auipc	a0,0x4
    80004890:	e8450513          	addi	a0,a0,-380 # 80008710 <userret+0x66c>
    80004894:	ffffc097          	auipc	ra,0xffffc
    80004898:	e44080e7          	jalr	-444(ra) # 800006d8 <panic>
      memset(dip, 0, sizeof(*dip));
    8000489c:	04000613          	li	a2,64
    800048a0:	00000593          	li	a1,0
    800048a4:	00098513          	mv	a0,s3
    800048a8:	ffffc097          	auipc	ra,0xffffc
    800048ac:	708080e7          	jalr	1800(ra) # 80000fb0 <memset>
      dip->type = type;
    800048b0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800048b4:	00090513          	mv	a0,s2
    800048b8:	00001097          	auipc	ra,0x1
    800048bc:	15c080e7          	jalr	348(ra) # 80005a14 <log_write>
      brelse(bp);
    800048c0:	00090513          	mv	a0,s2
    800048c4:	00000097          	auipc	ra,0x0
    800048c8:	824080e7          	jalr	-2012(ra) # 800040e8 <brelse>
      return iget(dev, inum);
    800048cc:	000b0593          	mv	a1,s6
    800048d0:	000a8513          	mv	a0,s5
    800048d4:	00000097          	auipc	ra,0x0
    800048d8:	cf4080e7          	jalr	-780(ra) # 800045c8 <iget>
}
    800048dc:	04813083          	ld	ra,72(sp)
    800048e0:	04013403          	ld	s0,64(sp)
    800048e4:	03813483          	ld	s1,56(sp)
    800048e8:	03013903          	ld	s2,48(sp)
    800048ec:	02813983          	ld	s3,40(sp)
    800048f0:	02013a03          	ld	s4,32(sp)
    800048f4:	01813a83          	ld	s5,24(sp)
    800048f8:	01013b03          	ld	s6,16(sp)
    800048fc:	00813b83          	ld	s7,8(sp)
    80004900:	05010113          	addi	sp,sp,80
    80004904:	00008067          	ret

0000000080004908 <iupdate>:
{
    80004908:	fe010113          	addi	sp,sp,-32
    8000490c:	00113c23          	sd	ra,24(sp)
    80004910:	00813823          	sd	s0,16(sp)
    80004914:	00913423          	sd	s1,8(sp)
    80004918:	01213023          	sd	s2,0(sp)
    8000491c:	02010413          	addi	s0,sp,32
    80004920:	00050493          	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004924:	00452783          	lw	a5,4(a0)
    80004928:	0047d79b          	srliw	a5,a5,0x4
    8000492c:	0001b597          	auipc	a1,0x1b
    80004930:	5fc5a583          	lw	a1,1532(a1) # 8001ff28 <sb+0x18>
    80004934:	00b785bb          	addw	a1,a5,a1
    80004938:	00052503          	lw	a0,0(a0)
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	600080e7          	jalr	1536(ra) # 80003f3c <bread>
    80004944:	00050913          	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004948:	06050793          	addi	a5,a0,96
    8000494c:	0044a703          	lw	a4,4(s1)
    80004950:	00f77713          	andi	a4,a4,15
    80004954:	00671713          	slli	a4,a4,0x6
    80004958:	00e787b3          	add	a5,a5,a4
  dip->type = ip->type;
    8000495c:	04449703          	lh	a4,68(s1)
    80004960:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80004964:	04649703          	lh	a4,70(s1)
    80004968:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000496c:	04849703          	lh	a4,72(s1)
    80004970:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80004974:	04a49703          	lh	a4,74(s1)
    80004978:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000497c:	04c4a703          	lw	a4,76(s1)
    80004980:	00e7a423          	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004984:	03400613          	li	a2,52
    80004988:	05048593          	addi	a1,s1,80
    8000498c:	00c78513          	addi	a0,a5,12
    80004990:	ffffc097          	auipc	ra,0xffffc
    80004994:	6b4080e7          	jalr	1716(ra) # 80001044 <memmove>
  log_write(bp);
    80004998:	00090513          	mv	a0,s2
    8000499c:	00001097          	auipc	ra,0x1
    800049a0:	078080e7          	jalr	120(ra) # 80005a14 <log_write>
  brelse(bp);
    800049a4:	00090513          	mv	a0,s2
    800049a8:	fffff097          	auipc	ra,0xfffff
    800049ac:	740080e7          	jalr	1856(ra) # 800040e8 <brelse>
}
    800049b0:	01813083          	ld	ra,24(sp)
    800049b4:	01013403          	ld	s0,16(sp)
    800049b8:	00813483          	ld	s1,8(sp)
    800049bc:	00013903          	ld	s2,0(sp)
    800049c0:	02010113          	addi	sp,sp,32
    800049c4:	00008067          	ret

00000000800049c8 <idup>:
{
    800049c8:	fe010113          	addi	sp,sp,-32
    800049cc:	00113c23          	sd	ra,24(sp)
    800049d0:	00813823          	sd	s0,16(sp)
    800049d4:	00913423          	sd	s1,8(sp)
    800049d8:	02010413          	addi	s0,sp,32
    800049dc:	00050493          	mv	s1,a0
  acquire(&icache.lock);
    800049e0:	0001b517          	auipc	a0,0x1b
    800049e4:	55050513          	addi	a0,a0,1360 # 8001ff30 <icache>
    800049e8:	ffffc097          	auipc	ra,0xffffc
    800049ec:	4f0080e7          	jalr	1264(ra) # 80000ed8 <acquire>
  ip->ref++;
    800049f0:	0084a783          	lw	a5,8(s1)
    800049f4:	0017879b          	addiw	a5,a5,1
    800049f8:	00f4a423          	sw	a5,8(s1)
  release(&icache.lock);
    800049fc:	0001b517          	auipc	a0,0x1b
    80004a00:	53450513          	addi	a0,a0,1332 # 8001ff30 <icache>
    80004a04:	ffffc097          	auipc	ra,0xffffc
    80004a08:	54c080e7          	jalr	1356(ra) # 80000f50 <release>
}
    80004a0c:	00048513          	mv	a0,s1
    80004a10:	01813083          	ld	ra,24(sp)
    80004a14:	01013403          	ld	s0,16(sp)
    80004a18:	00813483          	ld	s1,8(sp)
    80004a1c:	02010113          	addi	sp,sp,32
    80004a20:	00008067          	ret

0000000080004a24 <ilock>:
{
    80004a24:	fe010113          	addi	sp,sp,-32
    80004a28:	00113c23          	sd	ra,24(sp)
    80004a2c:	00813823          	sd	s0,16(sp)
    80004a30:	00913423          	sd	s1,8(sp)
    80004a34:	01213023          	sd	s2,0(sp)
    80004a38:	02010413          	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80004a3c:	02050e63          	beqz	a0,80004a78 <ilock+0x54>
    80004a40:	00050493          	mv	s1,a0
    80004a44:	00852783          	lw	a5,8(a0)
    80004a48:	02f05863          	blez	a5,80004a78 <ilock+0x54>
  acquiresleep(&ip->lock);
    80004a4c:	01050513          	addi	a0,a0,16
    80004a50:	00001097          	auipc	ra,0x1
    80004a54:	150080e7          	jalr	336(ra) # 80005ba0 <acquiresleep>
  if(ip->valid == 0){
    80004a58:	0404a783          	lw	a5,64(s1)
    80004a5c:	02078663          	beqz	a5,80004a88 <ilock+0x64>
}
    80004a60:	01813083          	ld	ra,24(sp)
    80004a64:	01013403          	ld	s0,16(sp)
    80004a68:	00813483          	ld	s1,8(sp)
    80004a6c:	00013903          	ld	s2,0(sp)
    80004a70:	02010113          	addi	sp,sp,32
    80004a74:	00008067          	ret
    panic("ilock");
    80004a78:	00004517          	auipc	a0,0x4
    80004a7c:	cb050513          	addi	a0,a0,-848 # 80008728 <userret+0x684>
    80004a80:	ffffc097          	auipc	ra,0xffffc
    80004a84:	c58080e7          	jalr	-936(ra) # 800006d8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004a88:	0044a783          	lw	a5,4(s1)
    80004a8c:	0047d79b          	srliw	a5,a5,0x4
    80004a90:	0001b597          	auipc	a1,0x1b
    80004a94:	4985a583          	lw	a1,1176(a1) # 8001ff28 <sb+0x18>
    80004a98:	00b785bb          	addw	a1,a5,a1
    80004a9c:	0004a503          	lw	a0,0(s1)
    80004aa0:	fffff097          	auipc	ra,0xfffff
    80004aa4:	49c080e7          	jalr	1180(ra) # 80003f3c <bread>
    80004aa8:	00050913          	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004aac:	06050593          	addi	a1,a0,96
    80004ab0:	0044a783          	lw	a5,4(s1)
    80004ab4:	00f7f793          	andi	a5,a5,15
    80004ab8:	00679793          	slli	a5,a5,0x6
    80004abc:	00f585b3          	add	a1,a1,a5
    ip->type = dip->type;
    80004ac0:	00059783          	lh	a5,0(a1)
    80004ac4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80004ac8:	00259783          	lh	a5,2(a1)
    80004acc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80004ad0:	00459783          	lh	a5,4(a1)
    80004ad4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80004ad8:	00659783          	lh	a5,6(a1)
    80004adc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004ae0:	0085a783          	lw	a5,8(a1)
    80004ae4:	04f4a623          	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004ae8:	03400613          	li	a2,52
    80004aec:	00c58593          	addi	a1,a1,12
    80004af0:	05048513          	addi	a0,s1,80
    80004af4:	ffffc097          	auipc	ra,0xffffc
    80004af8:	550080e7          	jalr	1360(ra) # 80001044 <memmove>
    brelse(bp);
    80004afc:	00090513          	mv	a0,s2
    80004b00:	fffff097          	auipc	ra,0xfffff
    80004b04:	5e8080e7          	jalr	1512(ra) # 800040e8 <brelse>
    ip->valid = 1;
    80004b08:	00100793          	li	a5,1
    80004b0c:	04f4a023          	sw	a5,64(s1)
    if(ip->type == 0)
    80004b10:	04449783          	lh	a5,68(s1)
    80004b14:	f40796e3          	bnez	a5,80004a60 <ilock+0x3c>
      panic("ilock: no type");
    80004b18:	00004517          	auipc	a0,0x4
    80004b1c:	c1850513          	addi	a0,a0,-1000 # 80008730 <userret+0x68c>
    80004b20:	ffffc097          	auipc	ra,0xffffc
    80004b24:	bb8080e7          	jalr	-1096(ra) # 800006d8 <panic>

0000000080004b28 <iunlock>:
{
    80004b28:	fe010113          	addi	sp,sp,-32
    80004b2c:	00113c23          	sd	ra,24(sp)
    80004b30:	00813823          	sd	s0,16(sp)
    80004b34:	00913423          	sd	s1,8(sp)
    80004b38:	01213023          	sd	s2,0(sp)
    80004b3c:	02010413          	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004b40:	04050463          	beqz	a0,80004b88 <iunlock+0x60>
    80004b44:	00050493          	mv	s1,a0
    80004b48:	01050913          	addi	s2,a0,16
    80004b4c:	00090513          	mv	a0,s2
    80004b50:	00001097          	auipc	ra,0x1
    80004b54:	13c080e7          	jalr	316(ra) # 80005c8c <holdingsleep>
    80004b58:	02050863          	beqz	a0,80004b88 <iunlock+0x60>
    80004b5c:	0084a783          	lw	a5,8(s1)
    80004b60:	02f05463          	blez	a5,80004b88 <iunlock+0x60>
  releasesleep(&ip->lock);
    80004b64:	00090513          	mv	a0,s2
    80004b68:	00001097          	auipc	ra,0x1
    80004b6c:	0c0080e7          	jalr	192(ra) # 80005c28 <releasesleep>
}
    80004b70:	01813083          	ld	ra,24(sp)
    80004b74:	01013403          	ld	s0,16(sp)
    80004b78:	00813483          	ld	s1,8(sp)
    80004b7c:	00013903          	ld	s2,0(sp)
    80004b80:	02010113          	addi	sp,sp,32
    80004b84:	00008067          	ret
    panic("iunlock");
    80004b88:	00004517          	auipc	a0,0x4
    80004b8c:	bb850513          	addi	a0,a0,-1096 # 80008740 <userret+0x69c>
    80004b90:	ffffc097          	auipc	ra,0xffffc
    80004b94:	b48080e7          	jalr	-1208(ra) # 800006d8 <panic>

0000000080004b98 <iput>:
{
    80004b98:	fc010113          	addi	sp,sp,-64
    80004b9c:	02113c23          	sd	ra,56(sp)
    80004ba0:	02813823          	sd	s0,48(sp)
    80004ba4:	02913423          	sd	s1,40(sp)
    80004ba8:	03213023          	sd	s2,32(sp)
    80004bac:	01313c23          	sd	s3,24(sp)
    80004bb0:	01413823          	sd	s4,16(sp)
    80004bb4:	01513423          	sd	s5,8(sp)
    80004bb8:	04010413          	addi	s0,sp,64
    80004bbc:	00050493          	mv	s1,a0
  acquire(&icache.lock);
    80004bc0:	0001b517          	auipc	a0,0x1b
    80004bc4:	37050513          	addi	a0,a0,880 # 8001ff30 <icache>
    80004bc8:	ffffc097          	auipc	ra,0xffffc
    80004bcc:	310080e7          	jalr	784(ra) # 80000ed8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004bd0:	0084a703          	lw	a4,8(s1)
    80004bd4:	00100793          	li	a5,1
    80004bd8:	04f70263          	beq	a4,a5,80004c1c <iput+0x84>
  ip->ref--;
    80004bdc:	0084a783          	lw	a5,8(s1)
    80004be0:	fff7879b          	addiw	a5,a5,-1
    80004be4:	00f4a423          	sw	a5,8(s1)
  release(&icache.lock);
    80004be8:	0001b517          	auipc	a0,0x1b
    80004bec:	34850513          	addi	a0,a0,840 # 8001ff30 <icache>
    80004bf0:	ffffc097          	auipc	ra,0xffffc
    80004bf4:	360080e7          	jalr	864(ra) # 80000f50 <release>
}
    80004bf8:	03813083          	ld	ra,56(sp)
    80004bfc:	03013403          	ld	s0,48(sp)
    80004c00:	02813483          	ld	s1,40(sp)
    80004c04:	02013903          	ld	s2,32(sp)
    80004c08:	01813983          	ld	s3,24(sp)
    80004c0c:	01013a03          	ld	s4,16(sp)
    80004c10:	00813a83          	ld	s5,8(sp)
    80004c14:	04010113          	addi	sp,sp,64
    80004c18:	00008067          	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004c1c:	0404a783          	lw	a5,64(s1)
    80004c20:	fa078ee3          	beqz	a5,80004bdc <iput+0x44>
    80004c24:	04a49783          	lh	a5,74(s1)
    80004c28:	fa079ae3          	bnez	a5,80004bdc <iput+0x44>
    acquiresleep(&ip->lock);
    80004c2c:	01048a13          	addi	s4,s1,16
    80004c30:	000a0513          	mv	a0,s4
    80004c34:	00001097          	auipc	ra,0x1
    80004c38:	f6c080e7          	jalr	-148(ra) # 80005ba0 <acquiresleep>
    release(&icache.lock);
    80004c3c:	0001b517          	auipc	a0,0x1b
    80004c40:	2f450513          	addi	a0,a0,756 # 8001ff30 <icache>
    80004c44:	ffffc097          	auipc	ra,0xffffc
    80004c48:	30c080e7          	jalr	780(ra) # 80000f50 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004c4c:	05048913          	addi	s2,s1,80
    80004c50:	08048993          	addi	s3,s1,128
    80004c54:	00c0006f          	j	80004c60 <iput+0xc8>
    80004c58:	00490913          	addi	s2,s2,4
    80004c5c:	03390063          	beq	s2,s3,80004c7c <iput+0xe4>
    if(ip->addrs[i]){
    80004c60:	00092583          	lw	a1,0(s2)
    80004c64:	fe058ae3          	beqz	a1,80004c58 <iput+0xc0>
      bfree(ip->dev, ip->addrs[i]);
    80004c68:	0004a503          	lw	a0,0(s1)
    80004c6c:	fffff097          	auipc	ra,0xfffff
    80004c70:	604080e7          	jalr	1540(ra) # 80004270 <bfree>
      ip->addrs[i] = 0;
    80004c74:	00092023          	sw	zero,0(s2)
    80004c78:	fe1ff06f          	j	80004c58 <iput+0xc0>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004c7c:	0804a583          	lw	a1,128(s1)
    80004c80:	04059463          	bnez	a1,80004cc8 <iput+0x130>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004c84:	0404a623          	sw	zero,76(s1)
  iupdate(ip);
    80004c88:	00048513          	mv	a0,s1
    80004c8c:	00000097          	auipc	ra,0x0
    80004c90:	c7c080e7          	jalr	-900(ra) # 80004908 <iupdate>
    ip->type = 0;
    80004c94:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004c98:	00048513          	mv	a0,s1
    80004c9c:	00000097          	auipc	ra,0x0
    80004ca0:	c6c080e7          	jalr	-916(ra) # 80004908 <iupdate>
    ip->valid = 0;
    80004ca4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004ca8:	000a0513          	mv	a0,s4
    80004cac:	00001097          	auipc	ra,0x1
    80004cb0:	f7c080e7          	jalr	-132(ra) # 80005c28 <releasesleep>
    acquire(&icache.lock);
    80004cb4:	0001b517          	auipc	a0,0x1b
    80004cb8:	27c50513          	addi	a0,a0,636 # 8001ff30 <icache>
    80004cbc:	ffffc097          	auipc	ra,0xffffc
    80004cc0:	21c080e7          	jalr	540(ra) # 80000ed8 <acquire>
    80004cc4:	f19ff06f          	j	80004bdc <iput+0x44>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004cc8:	0004a503          	lw	a0,0(s1)
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	270080e7          	jalr	624(ra) # 80003f3c <bread>
    80004cd4:	00050a93          	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    80004cd8:	06050913          	addi	s2,a0,96
    80004cdc:	46050993          	addi	s3,a0,1120
    80004ce0:	00c0006f          	j	80004cec <iput+0x154>
    80004ce4:	00490913          	addi	s2,s2,4
    80004ce8:	01390e63          	beq	s2,s3,80004d04 <iput+0x16c>
      if(a[j])
    80004cec:	00092583          	lw	a1,0(s2)
    80004cf0:	fe058ae3          	beqz	a1,80004ce4 <iput+0x14c>
        bfree(ip->dev, a[j]);
    80004cf4:	0004a503          	lw	a0,0(s1)
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	578080e7          	jalr	1400(ra) # 80004270 <bfree>
    80004d00:	fe5ff06f          	j	80004ce4 <iput+0x14c>
    brelse(bp);
    80004d04:	000a8513          	mv	a0,s5
    80004d08:	fffff097          	auipc	ra,0xfffff
    80004d0c:	3e0080e7          	jalr	992(ra) # 800040e8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004d10:	0804a583          	lw	a1,128(s1)
    80004d14:	0004a503          	lw	a0,0(s1)
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	558080e7          	jalr	1368(ra) # 80004270 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004d20:	0804a023          	sw	zero,128(s1)
    80004d24:	f61ff06f          	j	80004c84 <iput+0xec>

0000000080004d28 <iunlockput>:
{
    80004d28:	fe010113          	addi	sp,sp,-32
    80004d2c:	00113c23          	sd	ra,24(sp)
    80004d30:	00813823          	sd	s0,16(sp)
    80004d34:	00913423          	sd	s1,8(sp)
    80004d38:	02010413          	addi	s0,sp,32
    80004d3c:	00050493          	mv	s1,a0
  iunlock(ip);
    80004d40:	00000097          	auipc	ra,0x0
    80004d44:	de8080e7          	jalr	-536(ra) # 80004b28 <iunlock>
  iput(ip);
    80004d48:	00048513          	mv	a0,s1
    80004d4c:	00000097          	auipc	ra,0x0
    80004d50:	e4c080e7          	jalr	-436(ra) # 80004b98 <iput>
}
    80004d54:	01813083          	ld	ra,24(sp)
    80004d58:	01013403          	ld	s0,16(sp)
    80004d5c:	00813483          	ld	s1,8(sp)
    80004d60:	02010113          	addi	sp,sp,32
    80004d64:	00008067          	ret

0000000080004d68 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004d68:	ff010113          	addi	sp,sp,-16
    80004d6c:	00813423          	sd	s0,8(sp)
    80004d70:	01010413          	addi	s0,sp,16
  st->dev = ip->dev;
    80004d74:	00052783          	lw	a5,0(a0)
    80004d78:	00f5a023          	sw	a5,0(a1)
  st->ino = ip->inum;
    80004d7c:	00452783          	lw	a5,4(a0)
    80004d80:	00f5a223          	sw	a5,4(a1)
  st->type = ip->type;
    80004d84:	04451783          	lh	a5,68(a0)
    80004d88:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004d8c:	04a51783          	lh	a5,74(a0)
    80004d90:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004d94:	04c56783          	lwu	a5,76(a0)
    80004d98:	00f5b823          	sd	a5,16(a1)
}
    80004d9c:	00813403          	ld	s0,8(sp)
    80004da0:	01010113          	addi	sp,sp,16
    80004da4:	00008067          	ret

0000000080004da8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004da8:	04c52783          	lw	a5,76(a0)
    80004dac:	14d7ea63          	bltu	a5,a3,80004f00 <readi+0x158>
{
    80004db0:	f9010113          	addi	sp,sp,-112
    80004db4:	06113423          	sd	ra,104(sp)
    80004db8:	06813023          	sd	s0,96(sp)
    80004dbc:	04913c23          	sd	s1,88(sp)
    80004dc0:	05213823          	sd	s2,80(sp)
    80004dc4:	05313423          	sd	s3,72(sp)
    80004dc8:	05413023          	sd	s4,64(sp)
    80004dcc:	03513c23          	sd	s5,56(sp)
    80004dd0:	03613823          	sd	s6,48(sp)
    80004dd4:	03713423          	sd	s7,40(sp)
    80004dd8:	03813023          	sd	s8,32(sp)
    80004ddc:	01913c23          	sd	s9,24(sp)
    80004de0:	01a13823          	sd	s10,16(sp)
    80004de4:	01b13423          	sd	s11,8(sp)
    80004de8:	07010413          	addi	s0,sp,112
    80004dec:	00050b93          	mv	s7,a0
    80004df0:	00058c13          	mv	s8,a1
    80004df4:	00060a93          	mv	s5,a2
    80004df8:	00068913          	mv	s2,a3
    80004dfc:	00070b13          	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004e00:	00e6873b          	addw	a4,a3,a4
    80004e04:	10d76263          	bltu	a4,a3,80004f08 <readi+0x160>
    return -1;
  if(off + n > ip->size)
    80004e08:	00e7f463          	bgeu	a5,a4,80004e10 <readi+0x68>
    n = ip->size - off;
    80004e0c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004e10:	0a0b0863          	beqz	s6,80004ec0 <readi+0x118>
    80004e14:	00000a13          	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004e18:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004e1c:	fff00c93          	li	s9,-1
    80004e20:	0480006f          	j	80004e68 <readi+0xc0>
    80004e24:	02099d93          	slli	s11,s3,0x20
    80004e28:	020ddd93          	srli	s11,s11,0x20
    80004e2c:	06048613          	addi	a2,s1,96
    80004e30:	000d8693          	mv	a3,s11
    80004e34:	00e60633          	add	a2,a2,a4
    80004e38:	000a8593          	mv	a1,s5
    80004e3c:	000c0513          	mv	a0,s8
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	340080e7          	jalr	832(ra) # 80003180 <either_copyout>
    80004e48:	07950663          	beq	a0,s9,80004eb4 <readi+0x10c>
      brelse(bp);
      break;
    }
    brelse(bp);
    80004e4c:	00048513          	mv	a0,s1
    80004e50:	fffff097          	auipc	ra,0xfffff
    80004e54:	298080e7          	jalr	664(ra) # 800040e8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004e58:	01498a3b          	addw	s4,s3,s4
    80004e5c:	0129893b          	addw	s2,s3,s2
    80004e60:	01ba8ab3          	add	s5,s5,s11
    80004e64:	056a7e63          	bgeu	s4,s6,80004ec0 <readi+0x118>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004e68:	000ba483          	lw	s1,0(s7)
    80004e6c:	00a9559b          	srliw	a1,s2,0xa
    80004e70:	000b8513          	mv	a0,s7
    80004e74:	fffff097          	auipc	ra,0xfffff
    80004e78:	640080e7          	jalr	1600(ra) # 800044b4 <bmap>
    80004e7c:	0005059b          	sext.w	a1,a0
    80004e80:	00048513          	mv	a0,s1
    80004e84:	fffff097          	auipc	ra,0xfffff
    80004e88:	0b8080e7          	jalr	184(ra) # 80003f3c <bread>
    80004e8c:	00050493          	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004e90:	3ff97713          	andi	a4,s2,1023
    80004e94:	40ed07bb          	subw	a5,s10,a4
    80004e98:	414b06bb          	subw	a3,s6,s4
    80004e9c:	00078993          	mv	s3,a5
    80004ea0:	0007879b          	sext.w	a5,a5
    80004ea4:	0006861b          	sext.w	a2,a3
    80004ea8:	f6f67ee3          	bgeu	a2,a5,80004e24 <readi+0x7c>
    80004eac:	00068993          	mv	s3,a3
    80004eb0:	f75ff06f          	j	80004e24 <readi+0x7c>
      brelse(bp);
    80004eb4:	00048513          	mv	a0,s1
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	230080e7          	jalr	560(ra) # 800040e8 <brelse>
  }
  return n;
    80004ec0:	000b051b          	sext.w	a0,s6
}
    80004ec4:	06813083          	ld	ra,104(sp)
    80004ec8:	06013403          	ld	s0,96(sp)
    80004ecc:	05813483          	ld	s1,88(sp)
    80004ed0:	05013903          	ld	s2,80(sp)
    80004ed4:	04813983          	ld	s3,72(sp)
    80004ed8:	04013a03          	ld	s4,64(sp)
    80004edc:	03813a83          	ld	s5,56(sp)
    80004ee0:	03013b03          	ld	s6,48(sp)
    80004ee4:	02813b83          	ld	s7,40(sp)
    80004ee8:	02013c03          	ld	s8,32(sp)
    80004eec:	01813c83          	ld	s9,24(sp)
    80004ef0:	01013d03          	ld	s10,16(sp)
    80004ef4:	00813d83          	ld	s11,8(sp)
    80004ef8:	07010113          	addi	sp,sp,112
    80004efc:	00008067          	ret
    return -1;
    80004f00:	fff00513          	li	a0,-1
}
    80004f04:	00008067          	ret
    return -1;
    80004f08:	fff00513          	li	a0,-1
    80004f0c:	fb9ff06f          	j	80004ec4 <readi+0x11c>

0000000080004f10 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004f10:	04c52783          	lw	a5,76(a0)
    80004f14:	16d7ec63          	bltu	a5,a3,8000508c <writei+0x17c>
{
    80004f18:	f9010113          	addi	sp,sp,-112
    80004f1c:	06113423          	sd	ra,104(sp)
    80004f20:	06813023          	sd	s0,96(sp)
    80004f24:	04913c23          	sd	s1,88(sp)
    80004f28:	05213823          	sd	s2,80(sp)
    80004f2c:	05313423          	sd	s3,72(sp)
    80004f30:	05413023          	sd	s4,64(sp)
    80004f34:	03513c23          	sd	s5,56(sp)
    80004f38:	03613823          	sd	s6,48(sp)
    80004f3c:	03713423          	sd	s7,40(sp)
    80004f40:	03813023          	sd	s8,32(sp)
    80004f44:	01913c23          	sd	s9,24(sp)
    80004f48:	01a13823          	sd	s10,16(sp)
    80004f4c:	01b13423          	sd	s11,8(sp)
    80004f50:	07010413          	addi	s0,sp,112
    80004f54:	00050b93          	mv	s7,a0
    80004f58:	00058c13          	mv	s8,a1
    80004f5c:	00060a93          	mv	s5,a2
    80004f60:	00068913          	mv	s2,a3
    80004f64:	00070b13          	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004f68:	00e687bb          	addw	a5,a3,a4
    80004f6c:	12d7e463          	bltu	a5,a3,80005094 <writei+0x184>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004f70:	00043737          	lui	a4,0x43
    80004f74:	12f76463          	bltu	a4,a5,8000509c <writei+0x18c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004f78:	0c0b0a63          	beqz	s6,8000504c <writei+0x13c>
    80004f7c:	00000a13          	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004f80:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004f84:	fff00c93          	li	s9,-1
    80004f88:	0540006f          	j	80004fdc <writei+0xcc>
    80004f8c:	02099d93          	slli	s11,s3,0x20
    80004f90:	020ddd93          	srli	s11,s11,0x20
    80004f94:	06048513          	addi	a0,s1,96
    80004f98:	000d8693          	mv	a3,s11
    80004f9c:	000a8613          	mv	a2,s5
    80004fa0:	000c0593          	mv	a1,s8
    80004fa4:	00e50533          	add	a0,a0,a4
    80004fa8:	ffffe097          	auipc	ra,0xffffe
    80004fac:	268080e7          	jalr	616(ra) # 80003210 <either_copyin>
    80004fb0:	07950c63          	beq	a0,s9,80005028 <writei+0x118>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004fb4:	00048513          	mv	a0,s1
    80004fb8:	00001097          	auipc	ra,0x1
    80004fbc:	a5c080e7          	jalr	-1444(ra) # 80005a14 <log_write>
    brelse(bp);
    80004fc0:	00048513          	mv	a0,s1
    80004fc4:	fffff097          	auipc	ra,0xfffff
    80004fc8:	124080e7          	jalr	292(ra) # 800040e8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004fcc:	01498a3b          	addw	s4,s3,s4
    80004fd0:	0129893b          	addw	s2,s3,s2
    80004fd4:	01ba8ab3          	add	s5,s5,s11
    80004fd8:	056a7e63          	bgeu	s4,s6,80005034 <writei+0x124>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004fdc:	000ba483          	lw	s1,0(s7)
    80004fe0:	00a9559b          	srliw	a1,s2,0xa
    80004fe4:	000b8513          	mv	a0,s7
    80004fe8:	fffff097          	auipc	ra,0xfffff
    80004fec:	4cc080e7          	jalr	1228(ra) # 800044b4 <bmap>
    80004ff0:	0005059b          	sext.w	a1,a0
    80004ff4:	00048513          	mv	a0,s1
    80004ff8:	fffff097          	auipc	ra,0xfffff
    80004ffc:	f44080e7          	jalr	-188(ra) # 80003f3c <bread>
    80005000:	00050493          	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80005004:	3ff97713          	andi	a4,s2,1023
    80005008:	40ed07bb          	subw	a5,s10,a4
    8000500c:	414b06bb          	subw	a3,s6,s4
    80005010:	00078993          	mv	s3,a5
    80005014:	0007879b          	sext.w	a5,a5
    80005018:	0006861b          	sext.w	a2,a3
    8000501c:	f6f678e3          	bgeu	a2,a5,80004f8c <writei+0x7c>
    80005020:	00068993          	mv	s3,a3
    80005024:	f69ff06f          	j	80004f8c <writei+0x7c>
      brelse(bp);
    80005028:	00048513          	mv	a0,s1
    8000502c:	fffff097          	auipc	ra,0xfffff
    80005030:	0bc080e7          	jalr	188(ra) # 800040e8 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80005034:	04cba783          	lw	a5,76(s7)
    80005038:	0127f463          	bgeu	a5,s2,80005040 <writei+0x130>
      ip->size = off;
    8000503c:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80005040:	000b8513          	mv	a0,s7
    80005044:	00000097          	auipc	ra,0x0
    80005048:	8c4080e7          	jalr	-1852(ra) # 80004908 <iupdate>
  }

  return n;
    8000504c:	000b051b          	sext.w	a0,s6
}
    80005050:	06813083          	ld	ra,104(sp)
    80005054:	06013403          	ld	s0,96(sp)
    80005058:	05813483          	ld	s1,88(sp)
    8000505c:	05013903          	ld	s2,80(sp)
    80005060:	04813983          	ld	s3,72(sp)
    80005064:	04013a03          	ld	s4,64(sp)
    80005068:	03813a83          	ld	s5,56(sp)
    8000506c:	03013b03          	ld	s6,48(sp)
    80005070:	02813b83          	ld	s7,40(sp)
    80005074:	02013c03          	ld	s8,32(sp)
    80005078:	01813c83          	ld	s9,24(sp)
    8000507c:	01013d03          	ld	s10,16(sp)
    80005080:	00813d83          	ld	s11,8(sp)
    80005084:	07010113          	addi	sp,sp,112
    80005088:	00008067          	ret
    return -1;
    8000508c:	fff00513          	li	a0,-1
}
    80005090:	00008067          	ret
    return -1;
    80005094:	fff00513          	li	a0,-1
    80005098:	fb9ff06f          	j	80005050 <writei+0x140>
    return -1;
    8000509c:	fff00513          	li	a0,-1
    800050a0:	fb1ff06f          	j	80005050 <writei+0x140>

00000000800050a4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800050a4:	ff010113          	addi	sp,sp,-16
    800050a8:	00113423          	sd	ra,8(sp)
    800050ac:	00813023          	sd	s0,0(sp)
    800050b0:	01010413          	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800050b4:	00e00613          	li	a2,14
    800050b8:	ffffc097          	auipc	ra,0xffffc
    800050bc:	044080e7          	jalr	68(ra) # 800010fc <strncmp>
}
    800050c0:	00813083          	ld	ra,8(sp)
    800050c4:	00013403          	ld	s0,0(sp)
    800050c8:	01010113          	addi	sp,sp,16
    800050cc:	00008067          	ret

00000000800050d0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800050d0:	fc010113          	addi	sp,sp,-64
    800050d4:	02113c23          	sd	ra,56(sp)
    800050d8:	02813823          	sd	s0,48(sp)
    800050dc:	02913423          	sd	s1,40(sp)
    800050e0:	03213023          	sd	s2,32(sp)
    800050e4:	01313c23          	sd	s3,24(sp)
    800050e8:	01413823          	sd	s4,16(sp)
    800050ec:	04010413          	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800050f0:	04451703          	lh	a4,68(a0)
    800050f4:	00100793          	li	a5,1
    800050f8:	02f71263          	bne	a4,a5,8000511c <dirlookup+0x4c>
    800050fc:	00050913          	mv	s2,a0
    80005100:	00058993          	mv	s3,a1
    80005104:	00060a13          	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80005108:	04c52783          	lw	a5,76(a0)
    8000510c:	00000493          	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80005110:	00000513          	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005114:	02079a63          	bnez	a5,80005148 <dirlookup+0x78>
    80005118:	0900006f          	j	800051a8 <dirlookup+0xd8>
    panic("dirlookup not DIR");
    8000511c:	00003517          	auipc	a0,0x3
    80005120:	62c50513          	addi	a0,a0,1580 # 80008748 <userret+0x6a4>
    80005124:	ffffb097          	auipc	ra,0xffffb
    80005128:	5b4080e7          	jalr	1460(ra) # 800006d8 <panic>
      panic("dirlookup read");
    8000512c:	00003517          	auipc	a0,0x3
    80005130:	63450513          	addi	a0,a0,1588 # 80008760 <userret+0x6bc>
    80005134:	ffffb097          	auipc	ra,0xffffb
    80005138:	5a4080e7          	jalr	1444(ra) # 800006d8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000513c:	0104849b          	addiw	s1,s1,16
    80005140:	04c92783          	lw	a5,76(s2)
    80005144:	06f4f063          	bgeu	s1,a5,800051a4 <dirlookup+0xd4>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005148:	01000713          	li	a4,16
    8000514c:	00048693          	mv	a3,s1
    80005150:	fc040613          	addi	a2,s0,-64
    80005154:	00000593          	li	a1,0
    80005158:	00090513          	mv	a0,s2
    8000515c:	00000097          	auipc	ra,0x0
    80005160:	c4c080e7          	jalr	-948(ra) # 80004da8 <readi>
    80005164:	01000793          	li	a5,16
    80005168:	fcf512e3          	bne	a0,a5,8000512c <dirlookup+0x5c>
    if(de.inum == 0)
    8000516c:	fc045783          	lhu	a5,-64(s0)
    80005170:	fc0786e3          	beqz	a5,8000513c <dirlookup+0x6c>
    if(namecmp(name, de.name) == 0){
    80005174:	fc240593          	addi	a1,s0,-62
    80005178:	00098513          	mv	a0,s3
    8000517c:	00000097          	auipc	ra,0x0
    80005180:	f28080e7          	jalr	-216(ra) # 800050a4 <namecmp>
    80005184:	fa051ce3          	bnez	a0,8000513c <dirlookup+0x6c>
      if(poff)
    80005188:	000a0463          	beqz	s4,80005190 <dirlookup+0xc0>
        *poff = off;
    8000518c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80005190:	fc045583          	lhu	a1,-64(s0)
    80005194:	00092503          	lw	a0,0(s2)
    80005198:	fffff097          	auipc	ra,0xfffff
    8000519c:	430080e7          	jalr	1072(ra) # 800045c8 <iget>
    800051a0:	0080006f          	j	800051a8 <dirlookup+0xd8>
  return 0;
    800051a4:	00000513          	li	a0,0
}
    800051a8:	03813083          	ld	ra,56(sp)
    800051ac:	03013403          	ld	s0,48(sp)
    800051b0:	02813483          	ld	s1,40(sp)
    800051b4:	02013903          	ld	s2,32(sp)
    800051b8:	01813983          	ld	s3,24(sp)
    800051bc:	01013a03          	ld	s4,16(sp)
    800051c0:	04010113          	addi	sp,sp,64
    800051c4:	00008067          	ret

00000000800051c8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800051c8:	fa010113          	addi	sp,sp,-96
    800051cc:	04113c23          	sd	ra,88(sp)
    800051d0:	04813823          	sd	s0,80(sp)
    800051d4:	04913423          	sd	s1,72(sp)
    800051d8:	05213023          	sd	s2,64(sp)
    800051dc:	03313c23          	sd	s3,56(sp)
    800051e0:	03413823          	sd	s4,48(sp)
    800051e4:	03513423          	sd	s5,40(sp)
    800051e8:	03613023          	sd	s6,32(sp)
    800051ec:	01713c23          	sd	s7,24(sp)
    800051f0:	01813823          	sd	s8,16(sp)
    800051f4:	01913423          	sd	s9,8(sp)
    800051f8:	01a13023          	sd	s10,0(sp)
    800051fc:	06010413          	addi	s0,sp,96
    80005200:	00050493          	mv	s1,a0
    80005204:	00058b13          	mv	s6,a1
    80005208:	00060a93          	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000520c:	00054703          	lbu	a4,0(a0)
    80005210:	02f00793          	li	a5,47
    80005214:	02f70863          	beq	a4,a5,80005244 <namex+0x7c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80005218:	ffffd097          	auipc	ra,0xffffd
    8000521c:	180080e7          	jalr	384(ra) # 80002398 <myproc>
    80005220:	15053503          	ld	a0,336(a0)
    80005224:	fffff097          	auipc	ra,0xfffff
    80005228:	7a4080e7          	jalr	1956(ra) # 800049c8 <idup>
    8000522c:	00050a13          	mv	s4,a0
  while(*path == '/')
    80005230:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80005234:	00d00c93          	li	s9,13
  len = path - s;
    80005238:	00000b93          	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000523c:	00100c13          	li	s8,1
    80005240:	1100006f          	j	80005350 <namex+0x188>
    ip = iget(ROOTDEV, ROOTINO);
    80005244:	00100593          	li	a1,1
    80005248:	00100513          	li	a0,1
    8000524c:	fffff097          	auipc	ra,0xfffff
    80005250:	37c080e7          	jalr	892(ra) # 800045c8 <iget>
    80005254:	00050a13          	mv	s4,a0
    80005258:	fd9ff06f          	j	80005230 <namex+0x68>
      iunlockput(ip);
    8000525c:	000a0513          	mv	a0,s4
    80005260:	00000097          	auipc	ra,0x0
    80005264:	ac8080e7          	jalr	-1336(ra) # 80004d28 <iunlockput>
      return 0;
    80005268:	00000a13          	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000526c:	000a0513          	mv	a0,s4
    80005270:	05813083          	ld	ra,88(sp)
    80005274:	05013403          	ld	s0,80(sp)
    80005278:	04813483          	ld	s1,72(sp)
    8000527c:	04013903          	ld	s2,64(sp)
    80005280:	03813983          	ld	s3,56(sp)
    80005284:	03013a03          	ld	s4,48(sp)
    80005288:	02813a83          	ld	s5,40(sp)
    8000528c:	02013b03          	ld	s6,32(sp)
    80005290:	01813b83          	ld	s7,24(sp)
    80005294:	01013c03          	ld	s8,16(sp)
    80005298:	00813c83          	ld	s9,8(sp)
    8000529c:	00013d03          	ld	s10,0(sp)
    800052a0:	06010113          	addi	sp,sp,96
    800052a4:	00008067          	ret
      iunlock(ip);
    800052a8:	000a0513          	mv	a0,s4
    800052ac:	00000097          	auipc	ra,0x0
    800052b0:	87c080e7          	jalr	-1924(ra) # 80004b28 <iunlock>
      return ip;
    800052b4:	fb9ff06f          	j	8000526c <namex+0xa4>
      iunlockput(ip);
    800052b8:	000a0513          	mv	a0,s4
    800052bc:	00000097          	auipc	ra,0x0
    800052c0:	a6c080e7          	jalr	-1428(ra) # 80004d28 <iunlockput>
      return 0;
    800052c4:	00098a13          	mv	s4,s3
    800052c8:	fa5ff06f          	j	8000526c <namex+0xa4>
  len = path - s;
    800052cc:	40998633          	sub	a2,s3,s1
    800052d0:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800052d4:	0bacde63          	bge	s9,s10,80005390 <namex+0x1c8>
    memmove(name, s, DIRSIZ);
    800052d8:	00e00613          	li	a2,14
    800052dc:	00048593          	mv	a1,s1
    800052e0:	000a8513          	mv	a0,s5
    800052e4:	ffffc097          	auipc	ra,0xffffc
    800052e8:	d60080e7          	jalr	-672(ra) # 80001044 <memmove>
    800052ec:	00098493          	mv	s1,s3
  while(*path == '/')
    800052f0:	0004c783          	lbu	a5,0(s1)
    800052f4:	01279863          	bne	a5,s2,80005304 <namex+0x13c>
    path++;
    800052f8:	00148493          	addi	s1,s1,1
  while(*path == '/')
    800052fc:	0004c783          	lbu	a5,0(s1)
    80005300:	ff278ce3          	beq	a5,s2,800052f8 <namex+0x130>
    ilock(ip);
    80005304:	000a0513          	mv	a0,s4
    80005308:	fffff097          	auipc	ra,0xfffff
    8000530c:	71c080e7          	jalr	1820(ra) # 80004a24 <ilock>
    if(ip->type != T_DIR){
    80005310:	044a1783          	lh	a5,68(s4)
    80005314:	f58794e3          	bne	a5,s8,8000525c <namex+0x94>
    if(nameiparent && *path == '\0'){
    80005318:	000b0663          	beqz	s6,80005324 <namex+0x15c>
    8000531c:	0004c783          	lbu	a5,0(s1)
    80005320:	f80784e3          	beqz	a5,800052a8 <namex+0xe0>
    if((next = dirlookup(ip, name, 0)) == 0){
    80005324:	000b8613          	mv	a2,s7
    80005328:	000a8593          	mv	a1,s5
    8000532c:	000a0513          	mv	a0,s4
    80005330:	00000097          	auipc	ra,0x0
    80005334:	da0080e7          	jalr	-608(ra) # 800050d0 <dirlookup>
    80005338:	00050993          	mv	s3,a0
    8000533c:	f6050ee3          	beqz	a0,800052b8 <namex+0xf0>
    iunlockput(ip);
    80005340:	000a0513          	mv	a0,s4
    80005344:	00000097          	auipc	ra,0x0
    80005348:	9e4080e7          	jalr	-1564(ra) # 80004d28 <iunlockput>
    ip = next;
    8000534c:	00098a13          	mv	s4,s3
  while(*path == '/')
    80005350:	0004c783          	lbu	a5,0(s1)
    80005354:	01279863          	bne	a5,s2,80005364 <namex+0x19c>
    path++;
    80005358:	00148493          	addi	s1,s1,1
  while(*path == '/')
    8000535c:	0004c783          	lbu	a5,0(s1)
    80005360:	ff278ce3          	beq	a5,s2,80005358 <namex+0x190>
  if(*path == 0)
    80005364:	04078863          	beqz	a5,800053b4 <namex+0x1ec>
  while(*path != '/' && *path != 0)
    80005368:	0004c783          	lbu	a5,0(s1)
    8000536c:	00048993          	mv	s3,s1
  len = path - s;
    80005370:	000b8d13          	mv	s10,s7
    80005374:	000b8613          	mv	a2,s7
  while(*path != '/' && *path != 0)
    80005378:	01278c63          	beq	a5,s2,80005390 <namex+0x1c8>
    8000537c:	f40788e3          	beqz	a5,800052cc <namex+0x104>
    path++;
    80005380:	00198993          	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80005384:	0009c783          	lbu	a5,0(s3)
    80005388:	ff279ae3          	bne	a5,s2,8000537c <namex+0x1b4>
    8000538c:	f41ff06f          	j	800052cc <namex+0x104>
    memmove(name, s, len);
    80005390:	0006061b          	sext.w	a2,a2
    80005394:	00048593          	mv	a1,s1
    80005398:	000a8513          	mv	a0,s5
    8000539c:	ffffc097          	auipc	ra,0xffffc
    800053a0:	ca8080e7          	jalr	-856(ra) # 80001044 <memmove>
    name[len] = 0;
    800053a4:	01aa8d33          	add	s10,s5,s10
    800053a8:	000d0023          	sb	zero,0(s10)
    800053ac:	00098493          	mv	s1,s3
    800053b0:	f41ff06f          	j	800052f0 <namex+0x128>
  if(nameiparent){
    800053b4:	ea0b0ce3          	beqz	s6,8000526c <namex+0xa4>
    iput(ip);
    800053b8:	000a0513          	mv	a0,s4
    800053bc:	fffff097          	auipc	ra,0xfffff
    800053c0:	7dc080e7          	jalr	2012(ra) # 80004b98 <iput>
    return 0;
    800053c4:	00000a13          	li	s4,0
    800053c8:	ea5ff06f          	j	8000526c <namex+0xa4>

00000000800053cc <dirlink>:
{
    800053cc:	fc010113          	addi	sp,sp,-64
    800053d0:	02113c23          	sd	ra,56(sp)
    800053d4:	02813823          	sd	s0,48(sp)
    800053d8:	02913423          	sd	s1,40(sp)
    800053dc:	03213023          	sd	s2,32(sp)
    800053e0:	01313c23          	sd	s3,24(sp)
    800053e4:	01413823          	sd	s4,16(sp)
    800053e8:	04010413          	addi	s0,sp,64
    800053ec:	00050913          	mv	s2,a0
    800053f0:	00058a13          	mv	s4,a1
    800053f4:	00060993          	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800053f8:	00000613          	li	a2,0
    800053fc:	00000097          	auipc	ra,0x0
    80005400:	cd4080e7          	jalr	-812(ra) # 800050d0 <dirlookup>
    80005404:	0a051663          	bnez	a0,800054b0 <dirlink+0xe4>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005408:	04c92483          	lw	s1,76(s2)
    8000540c:	04048063          	beqz	s1,8000544c <dirlink+0x80>
    80005410:	00000493          	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005414:	01000713          	li	a4,16
    80005418:	00048693          	mv	a3,s1
    8000541c:	fc040613          	addi	a2,s0,-64
    80005420:	00000593          	li	a1,0
    80005424:	00090513          	mv	a0,s2
    80005428:	00000097          	auipc	ra,0x0
    8000542c:	980080e7          	jalr	-1664(ra) # 80004da8 <readi>
    80005430:	01000793          	li	a5,16
    80005434:	08f51663          	bne	a0,a5,800054c0 <dirlink+0xf4>
    if(de.inum == 0)
    80005438:	fc045783          	lhu	a5,-64(s0)
    8000543c:	00078863          	beqz	a5,8000544c <dirlink+0x80>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005440:	0104849b          	addiw	s1,s1,16
    80005444:	04c92783          	lw	a5,76(s2)
    80005448:	fcf4e6e3          	bltu	s1,a5,80005414 <dirlink+0x48>
  strncpy(de.name, name, DIRSIZ);
    8000544c:	00e00613          	li	a2,14
    80005450:	000a0593          	mv	a1,s4
    80005454:	fc240513          	addi	a0,s0,-62
    80005458:	ffffc097          	auipc	ra,0xffffc
    8000545c:	d08080e7          	jalr	-760(ra) # 80001160 <strncpy>
  de.inum = inum;
    80005460:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005464:	01000713          	li	a4,16
    80005468:	00048693          	mv	a3,s1
    8000546c:	fc040613          	addi	a2,s0,-64
    80005470:	00000593          	li	a1,0
    80005474:	00090513          	mv	a0,s2
    80005478:	00000097          	auipc	ra,0x0
    8000547c:	a98080e7          	jalr	-1384(ra) # 80004f10 <writei>
    80005480:	00050713          	mv	a4,a0
    80005484:	01000793          	li	a5,16
  return 0;
    80005488:	00000513          	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000548c:	04f71263          	bne	a4,a5,800054d0 <dirlink+0x104>
}
    80005490:	03813083          	ld	ra,56(sp)
    80005494:	03013403          	ld	s0,48(sp)
    80005498:	02813483          	ld	s1,40(sp)
    8000549c:	02013903          	ld	s2,32(sp)
    800054a0:	01813983          	ld	s3,24(sp)
    800054a4:	01013a03          	ld	s4,16(sp)
    800054a8:	04010113          	addi	sp,sp,64
    800054ac:	00008067          	ret
    iput(ip);
    800054b0:	fffff097          	auipc	ra,0xfffff
    800054b4:	6e8080e7          	jalr	1768(ra) # 80004b98 <iput>
    return -1;
    800054b8:	fff00513          	li	a0,-1
    800054bc:	fd5ff06f          	j	80005490 <dirlink+0xc4>
      panic("dirlink read");
    800054c0:	00003517          	auipc	a0,0x3
    800054c4:	2b050513          	addi	a0,a0,688 # 80008770 <userret+0x6cc>
    800054c8:	ffffb097          	auipc	ra,0xffffb
    800054cc:	210080e7          	jalr	528(ra) # 800006d8 <panic>
    panic("dirlink");
    800054d0:	00003517          	auipc	a0,0x3
    800054d4:	42050513          	addi	a0,a0,1056 # 800088f0 <userret+0x84c>
    800054d8:	ffffb097          	auipc	ra,0xffffb
    800054dc:	200080e7          	jalr	512(ra) # 800006d8 <panic>

00000000800054e0 <namei>:

struct inode*
namei(char *path)
{
    800054e0:	fe010113          	addi	sp,sp,-32
    800054e4:	00113c23          	sd	ra,24(sp)
    800054e8:	00813823          	sd	s0,16(sp)
    800054ec:	02010413          	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800054f0:	fe040613          	addi	a2,s0,-32
    800054f4:	00000593          	li	a1,0
    800054f8:	00000097          	auipc	ra,0x0
    800054fc:	cd0080e7          	jalr	-816(ra) # 800051c8 <namex>
}
    80005500:	01813083          	ld	ra,24(sp)
    80005504:	01013403          	ld	s0,16(sp)
    80005508:	02010113          	addi	sp,sp,32
    8000550c:	00008067          	ret

0000000080005510 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80005510:	ff010113          	addi	sp,sp,-16
    80005514:	00113423          	sd	ra,8(sp)
    80005518:	00813023          	sd	s0,0(sp)
    8000551c:	01010413          	addi	s0,sp,16
    80005520:	00058613          	mv	a2,a1
  return namex(path, 1, name);
    80005524:	00100593          	li	a1,1
    80005528:	00000097          	auipc	ra,0x0
    8000552c:	ca0080e7          	jalr	-864(ra) # 800051c8 <namex>
}
    80005530:	00813083          	ld	ra,8(sp)
    80005534:	00013403          	ld	s0,0(sp)
    80005538:	01010113          	addi	sp,sp,16
    8000553c:	00008067          	ret

0000000080005540 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80005540:	fe010113          	addi	sp,sp,-32
    80005544:	00113c23          	sd	ra,24(sp)
    80005548:	00813823          	sd	s0,16(sp)
    8000554c:	00913423          	sd	s1,8(sp)
    80005550:	01213023          	sd	s2,0(sp)
    80005554:	02010413          	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80005558:	0001c917          	auipc	s2,0x1c
    8000555c:	48090913          	addi	s2,s2,1152 # 800219d8 <log>
    80005560:	01892583          	lw	a1,24(s2)
    80005564:	02892503          	lw	a0,40(s2)
    80005568:	fffff097          	auipc	ra,0xfffff
    8000556c:	9d4080e7          	jalr	-1580(ra) # 80003f3c <bread>
    80005570:	00050493          	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80005574:	02c92683          	lw	a3,44(s2)
    80005578:	06d52023          	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000557c:	02d05e63          	blez	a3,800055b8 <write_head+0x78>
    80005580:	0001c797          	auipc	a5,0x1c
    80005584:	48878793          	addi	a5,a5,1160 # 80021a08 <log+0x30>
    80005588:	06450713          	addi	a4,a0,100
    8000558c:	fff6869b          	addiw	a3,a3,-1
    80005590:	02069613          	slli	a2,a3,0x20
    80005594:	01e65693          	srli	a3,a2,0x1e
    80005598:	0001c617          	auipc	a2,0x1c
    8000559c:	47460613          	addi	a2,a2,1140 # 80021a0c <log+0x34>
    800055a0:	00c686b3          	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800055a4:	0007a603          	lw	a2,0(a5)
    800055a8:	00c72023          	sw	a2,0(a4) # 43000 <_entry-0x7ffbd000>
  for (i = 0; i < log.lh.n; i++) {
    800055ac:	00478793          	addi	a5,a5,4
    800055b0:	00470713          	addi	a4,a4,4
    800055b4:	fed798e3          	bne	a5,a3,800055a4 <write_head+0x64>
  }
  bwrite(buf);
    800055b8:	00048513          	mv	a0,s1
    800055bc:	fffff097          	auipc	ra,0xfffff
    800055c0:	ac8080e7          	jalr	-1336(ra) # 80004084 <bwrite>
  brelse(buf);
    800055c4:	00048513          	mv	a0,s1
    800055c8:	fffff097          	auipc	ra,0xfffff
    800055cc:	b20080e7          	jalr	-1248(ra) # 800040e8 <brelse>
}
    800055d0:	01813083          	ld	ra,24(sp)
    800055d4:	01013403          	ld	s0,16(sp)
    800055d8:	00813483          	ld	s1,8(sp)
    800055dc:	00013903          	ld	s2,0(sp)
    800055e0:	02010113          	addi	sp,sp,32
    800055e4:	00008067          	ret

00000000800055e8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800055e8:	0001c797          	auipc	a5,0x1c
    800055ec:	41c7a783          	lw	a5,1052(a5) # 80021a04 <log+0x2c>
    800055f0:	0ef05263          	blez	a5,800056d4 <install_trans+0xec>
{
    800055f4:	fc010113          	addi	sp,sp,-64
    800055f8:	02113c23          	sd	ra,56(sp)
    800055fc:	02813823          	sd	s0,48(sp)
    80005600:	02913423          	sd	s1,40(sp)
    80005604:	03213023          	sd	s2,32(sp)
    80005608:	01313c23          	sd	s3,24(sp)
    8000560c:	01413823          	sd	s4,16(sp)
    80005610:	01513423          	sd	s5,8(sp)
    80005614:	04010413          	addi	s0,sp,64
    80005618:	0001ca97          	auipc	s5,0x1c
    8000561c:	3f0a8a93          	addi	s5,s5,1008 # 80021a08 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005620:	00000a13          	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005624:	0001c997          	auipc	s3,0x1c
    80005628:	3b498993          	addi	s3,s3,948 # 800219d8 <log>
    8000562c:	0189a583          	lw	a1,24(s3)
    80005630:	014585bb          	addw	a1,a1,s4
    80005634:	0015859b          	addiw	a1,a1,1
    80005638:	0289a503          	lw	a0,40(s3)
    8000563c:	fffff097          	auipc	ra,0xfffff
    80005640:	900080e7          	jalr	-1792(ra) # 80003f3c <bread>
    80005644:	00050913          	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80005648:	000aa583          	lw	a1,0(s5)
    8000564c:	0289a503          	lw	a0,40(s3)
    80005650:	fffff097          	auipc	ra,0xfffff
    80005654:	8ec080e7          	jalr	-1812(ra) # 80003f3c <bread>
    80005658:	00050493          	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000565c:	40000613          	li	a2,1024
    80005660:	06090593          	addi	a1,s2,96
    80005664:	06050513          	addi	a0,a0,96
    80005668:	ffffc097          	auipc	ra,0xffffc
    8000566c:	9dc080e7          	jalr	-1572(ra) # 80001044 <memmove>
    bwrite(dbuf);  // write dst to disk
    80005670:	00048513          	mv	a0,s1
    80005674:	fffff097          	auipc	ra,0xfffff
    80005678:	a10080e7          	jalr	-1520(ra) # 80004084 <bwrite>
    bunpin(dbuf);
    8000567c:	00048513          	mv	a0,s1
    80005680:	fffff097          	auipc	ra,0xfffff
    80005684:	b98080e7          	jalr	-1128(ra) # 80004218 <bunpin>
    brelse(lbuf);
    80005688:	00090513          	mv	a0,s2
    8000568c:	fffff097          	auipc	ra,0xfffff
    80005690:	a5c080e7          	jalr	-1444(ra) # 800040e8 <brelse>
    brelse(dbuf);
    80005694:	00048513          	mv	a0,s1
    80005698:	fffff097          	auipc	ra,0xfffff
    8000569c:	a50080e7          	jalr	-1456(ra) # 800040e8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800056a0:	001a0a1b          	addiw	s4,s4,1
    800056a4:	004a8a93          	addi	s5,s5,4
    800056a8:	02c9a783          	lw	a5,44(s3)
    800056ac:	f8fa40e3          	blt	s4,a5,8000562c <install_trans+0x44>
}
    800056b0:	03813083          	ld	ra,56(sp)
    800056b4:	03013403          	ld	s0,48(sp)
    800056b8:	02813483          	ld	s1,40(sp)
    800056bc:	02013903          	ld	s2,32(sp)
    800056c0:	01813983          	ld	s3,24(sp)
    800056c4:	01013a03          	ld	s4,16(sp)
    800056c8:	00813a83          	ld	s5,8(sp)
    800056cc:	04010113          	addi	sp,sp,64
    800056d0:	00008067          	ret
    800056d4:	00008067          	ret

00000000800056d8 <initlog>:
{
    800056d8:	fd010113          	addi	sp,sp,-48
    800056dc:	02113423          	sd	ra,40(sp)
    800056e0:	02813023          	sd	s0,32(sp)
    800056e4:	00913c23          	sd	s1,24(sp)
    800056e8:	01213823          	sd	s2,16(sp)
    800056ec:	01313423          	sd	s3,8(sp)
    800056f0:	03010413          	addi	s0,sp,48
    800056f4:	00050913          	mv	s2,a0
    800056f8:	00058993          	mv	s3,a1
  initlock(&log.lock, "log");
    800056fc:	0001c497          	auipc	s1,0x1c
    80005700:	2dc48493          	addi	s1,s1,732 # 800219d8 <log>
    80005704:	00003597          	auipc	a1,0x3
    80005708:	07c58593          	addi	a1,a1,124 # 80008780 <userret+0x6dc>
    8000570c:	00048513          	mv	a0,s1
    80005710:	ffffb097          	auipc	ra,0xffffb
    80005714:	640080e7          	jalr	1600(ra) # 80000d50 <initlock>
  log.start = sb->logstart;
    80005718:	0149a583          	lw	a1,20(s3)
    8000571c:	00b4ac23          	sw	a1,24(s1)
  log.size = sb->nlog;
    80005720:	0109a783          	lw	a5,16(s3)
    80005724:	00f4ae23          	sw	a5,28(s1)
  log.dev = dev;
    80005728:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000572c:	00090513          	mv	a0,s2
    80005730:	fffff097          	auipc	ra,0xfffff
    80005734:	80c080e7          	jalr	-2036(ra) # 80003f3c <bread>
  log.lh.n = lh->n;
    80005738:	06052683          	lw	a3,96(a0)
    8000573c:	02d4a623          	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80005740:	02d05c63          	blez	a3,80005778 <initlog+0xa0>
    80005744:	06450793          	addi	a5,a0,100
    80005748:	0001c717          	auipc	a4,0x1c
    8000574c:	2c070713          	addi	a4,a4,704 # 80021a08 <log+0x30>
    80005750:	fff6869b          	addiw	a3,a3,-1
    80005754:	02069613          	slli	a2,a3,0x20
    80005758:	01e65693          	srli	a3,a2,0x1e
    8000575c:	06850613          	addi	a2,a0,104
    80005760:	00c686b3          	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80005764:	0007a603          	lw	a2,0(a5)
    80005768:	00c72023          	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000576c:	00478793          	addi	a5,a5,4
    80005770:	00470713          	addi	a4,a4,4
    80005774:	fed798e3          	bne	a5,a3,80005764 <initlog+0x8c>
  brelse(buf);
    80005778:	fffff097          	auipc	ra,0xfffff
    8000577c:	970080e7          	jalr	-1680(ra) # 800040e8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    80005780:	00000097          	auipc	ra,0x0
    80005784:	e68080e7          	jalr	-408(ra) # 800055e8 <install_trans>
  log.lh.n = 0;
    80005788:	0001c797          	auipc	a5,0x1c
    8000578c:	2607ae23          	sw	zero,636(a5) # 80021a04 <log+0x2c>
  write_head(); // clear the log
    80005790:	00000097          	auipc	ra,0x0
    80005794:	db0080e7          	jalr	-592(ra) # 80005540 <write_head>
}
    80005798:	02813083          	ld	ra,40(sp)
    8000579c:	02013403          	ld	s0,32(sp)
    800057a0:	01813483          	ld	s1,24(sp)
    800057a4:	01013903          	ld	s2,16(sp)
    800057a8:	00813983          	ld	s3,8(sp)
    800057ac:	03010113          	addi	sp,sp,48
    800057b0:	00008067          	ret

00000000800057b4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800057b4:	fe010113          	addi	sp,sp,-32
    800057b8:	00113c23          	sd	ra,24(sp)
    800057bc:	00813823          	sd	s0,16(sp)
    800057c0:	00913423          	sd	s1,8(sp)
    800057c4:	01213023          	sd	s2,0(sp)
    800057c8:	02010413          	addi	s0,sp,32
  acquire(&log.lock);
    800057cc:	0001c517          	auipc	a0,0x1c
    800057d0:	20c50513          	addi	a0,a0,524 # 800219d8 <log>
    800057d4:	ffffb097          	auipc	ra,0xffffb
    800057d8:	704080e7          	jalr	1796(ra) # 80000ed8 <acquire>
  while(1){
    if(log.committing){
    800057dc:	0001c497          	auipc	s1,0x1c
    800057e0:	1fc48493          	addi	s1,s1,508 # 800219d8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800057e4:	01e00913          	li	s2,30
    800057e8:	0140006f          	j	800057fc <begin_op+0x48>
      sleep(&log, &log.lock);
    800057ec:	00048593          	mv	a1,s1
    800057f0:	00048513          	mv	a0,s1
    800057f4:	ffffd097          	auipc	ra,0xffffd
    800057f8:	628080e7          	jalr	1576(ra) # 80002e1c <sleep>
    if(log.committing){
    800057fc:	0244a783          	lw	a5,36(s1)
    80005800:	fe0796e3          	bnez	a5,800057ec <begin_op+0x38>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80005804:	0204a703          	lw	a4,32(s1)
    80005808:	0017071b          	addiw	a4,a4,1
    8000580c:	0007069b          	sext.w	a3,a4
    80005810:	0027179b          	slliw	a5,a4,0x2
    80005814:	00e787bb          	addw	a5,a5,a4
    80005818:	0017979b          	slliw	a5,a5,0x1
    8000581c:	02c4a703          	lw	a4,44(s1)
    80005820:	00e787bb          	addw	a5,a5,a4
    80005824:	00f95c63          	bge	s2,a5,8000583c <begin_op+0x88>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80005828:	00048593          	mv	a1,s1
    8000582c:	00048513          	mv	a0,s1
    80005830:	ffffd097          	auipc	ra,0xffffd
    80005834:	5ec080e7          	jalr	1516(ra) # 80002e1c <sleep>
    80005838:	fc5ff06f          	j	800057fc <begin_op+0x48>
    } else {
      log.outstanding += 1;
    8000583c:	0001c517          	auipc	a0,0x1c
    80005840:	19c50513          	addi	a0,a0,412 # 800219d8 <log>
    80005844:	02d52023          	sw	a3,32(a0)
      release(&log.lock);
    80005848:	ffffb097          	auipc	ra,0xffffb
    8000584c:	708080e7          	jalr	1800(ra) # 80000f50 <release>
      break;
    }
  }
}
    80005850:	01813083          	ld	ra,24(sp)
    80005854:	01013403          	ld	s0,16(sp)
    80005858:	00813483          	ld	s1,8(sp)
    8000585c:	00013903          	ld	s2,0(sp)
    80005860:	02010113          	addi	sp,sp,32
    80005864:	00008067          	ret

0000000080005868 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80005868:	fc010113          	addi	sp,sp,-64
    8000586c:	02113c23          	sd	ra,56(sp)
    80005870:	02813823          	sd	s0,48(sp)
    80005874:	02913423          	sd	s1,40(sp)
    80005878:	03213023          	sd	s2,32(sp)
    8000587c:	01313c23          	sd	s3,24(sp)
    80005880:	01413823          	sd	s4,16(sp)
    80005884:	01513423          	sd	s5,8(sp)
    80005888:	04010413          	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000588c:	0001c497          	auipc	s1,0x1c
    80005890:	14c48493          	addi	s1,s1,332 # 800219d8 <log>
    80005894:	00048513          	mv	a0,s1
    80005898:	ffffb097          	auipc	ra,0xffffb
    8000589c:	640080e7          	jalr	1600(ra) # 80000ed8 <acquire>
  log.outstanding -= 1;
    800058a0:	0204a783          	lw	a5,32(s1)
    800058a4:	fff7879b          	addiw	a5,a5,-1
    800058a8:	0007891b          	sext.w	s2,a5
    800058ac:	02f4a023          	sw	a5,32(s1)
  if(log.committing)
    800058b0:	0244a783          	lw	a5,36(s1)
    800058b4:	06079063          	bnez	a5,80005914 <end_op+0xac>
    panic("log.committing");
  if(log.outstanding == 0){
    800058b8:	06091663          	bnez	s2,80005924 <end_op+0xbc>
    do_commit = 1;
    log.committing = 1;
    800058bc:	0001c497          	auipc	s1,0x1c
    800058c0:	11c48493          	addi	s1,s1,284 # 800219d8 <log>
    800058c4:	00100793          	li	a5,1
    800058c8:	02f4a223          	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800058cc:	00048513          	mv	a0,s1
    800058d0:	ffffb097          	auipc	ra,0xffffb
    800058d4:	680080e7          	jalr	1664(ra) # 80000f50 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800058d8:	02c4a783          	lw	a5,44(s1)
    800058dc:	08f04663          	bgtz	a5,80005968 <end_op+0x100>
    acquire(&log.lock);
    800058e0:	0001c497          	auipc	s1,0x1c
    800058e4:	0f848493          	addi	s1,s1,248 # 800219d8 <log>
    800058e8:	00048513          	mv	a0,s1
    800058ec:	ffffb097          	auipc	ra,0xffffb
    800058f0:	5ec080e7          	jalr	1516(ra) # 80000ed8 <acquire>
    log.committing = 0;
    800058f4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800058f8:	00048513          	mv	a0,s1
    800058fc:	ffffd097          	auipc	ra,0xffffd
    80005900:	73c080e7          	jalr	1852(ra) # 80003038 <wakeup>
    release(&log.lock);
    80005904:	00048513          	mv	a0,s1
    80005908:	ffffb097          	auipc	ra,0xffffb
    8000590c:	648080e7          	jalr	1608(ra) # 80000f50 <release>
}
    80005910:	0340006f          	j	80005944 <end_op+0xdc>
    panic("log.committing");
    80005914:	00003517          	auipc	a0,0x3
    80005918:	e7450513          	addi	a0,a0,-396 # 80008788 <userret+0x6e4>
    8000591c:	ffffb097          	auipc	ra,0xffffb
    80005920:	dbc080e7          	jalr	-580(ra) # 800006d8 <panic>
    wakeup(&log);
    80005924:	0001c497          	auipc	s1,0x1c
    80005928:	0b448493          	addi	s1,s1,180 # 800219d8 <log>
    8000592c:	00048513          	mv	a0,s1
    80005930:	ffffd097          	auipc	ra,0xffffd
    80005934:	708080e7          	jalr	1800(ra) # 80003038 <wakeup>
  release(&log.lock);
    80005938:	00048513          	mv	a0,s1
    8000593c:	ffffb097          	auipc	ra,0xffffb
    80005940:	614080e7          	jalr	1556(ra) # 80000f50 <release>
}
    80005944:	03813083          	ld	ra,56(sp)
    80005948:	03013403          	ld	s0,48(sp)
    8000594c:	02813483          	ld	s1,40(sp)
    80005950:	02013903          	ld	s2,32(sp)
    80005954:	01813983          	ld	s3,24(sp)
    80005958:	01013a03          	ld	s4,16(sp)
    8000595c:	00813a83          	ld	s5,8(sp)
    80005960:	04010113          	addi	sp,sp,64
    80005964:	00008067          	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80005968:	0001ca97          	auipc	s5,0x1c
    8000596c:	0a0a8a93          	addi	s5,s5,160 # 80021a08 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80005970:	0001ca17          	auipc	s4,0x1c
    80005974:	068a0a13          	addi	s4,s4,104 # 800219d8 <log>
    80005978:	018a2583          	lw	a1,24(s4)
    8000597c:	012585bb          	addw	a1,a1,s2
    80005980:	0015859b          	addiw	a1,a1,1
    80005984:	028a2503          	lw	a0,40(s4)
    80005988:	ffffe097          	auipc	ra,0xffffe
    8000598c:	5b4080e7          	jalr	1460(ra) # 80003f3c <bread>
    80005990:	00050493          	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80005994:	000aa583          	lw	a1,0(s5)
    80005998:	028a2503          	lw	a0,40(s4)
    8000599c:	ffffe097          	auipc	ra,0xffffe
    800059a0:	5a0080e7          	jalr	1440(ra) # 80003f3c <bread>
    800059a4:	00050993          	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800059a8:	40000613          	li	a2,1024
    800059ac:	06050593          	addi	a1,a0,96
    800059b0:	06048513          	addi	a0,s1,96
    800059b4:	ffffb097          	auipc	ra,0xffffb
    800059b8:	690080e7          	jalr	1680(ra) # 80001044 <memmove>
    bwrite(to);  // write the log
    800059bc:	00048513          	mv	a0,s1
    800059c0:	ffffe097          	auipc	ra,0xffffe
    800059c4:	6c4080e7          	jalr	1732(ra) # 80004084 <bwrite>
    brelse(from);
    800059c8:	00098513          	mv	a0,s3
    800059cc:	ffffe097          	auipc	ra,0xffffe
    800059d0:	71c080e7          	jalr	1820(ra) # 800040e8 <brelse>
    brelse(to);
    800059d4:	00048513          	mv	a0,s1
    800059d8:	ffffe097          	auipc	ra,0xffffe
    800059dc:	710080e7          	jalr	1808(ra) # 800040e8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800059e0:	0019091b          	addiw	s2,s2,1
    800059e4:	004a8a93          	addi	s5,s5,4
    800059e8:	02ca2783          	lw	a5,44(s4)
    800059ec:	f8f946e3          	blt	s2,a5,80005978 <end_op+0x110>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800059f0:	00000097          	auipc	ra,0x0
    800059f4:	b50080e7          	jalr	-1200(ra) # 80005540 <write_head>
    install_trans(); // Now install writes to home locations
    800059f8:	00000097          	auipc	ra,0x0
    800059fc:	bf0080e7          	jalr	-1040(ra) # 800055e8 <install_trans>
    log.lh.n = 0;
    80005a00:	0001c797          	auipc	a5,0x1c
    80005a04:	0007a223          	sw	zero,4(a5) # 80021a04 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80005a08:	00000097          	auipc	ra,0x0
    80005a0c:	b38080e7          	jalr	-1224(ra) # 80005540 <write_head>
    80005a10:	ed1ff06f          	j	800058e0 <end_op+0x78>

0000000080005a14 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80005a14:	fe010113          	addi	sp,sp,-32
    80005a18:	00113c23          	sd	ra,24(sp)
    80005a1c:	00813823          	sd	s0,16(sp)
    80005a20:	00913423          	sd	s1,8(sp)
    80005a24:	01213023          	sd	s2,0(sp)
    80005a28:	02010413          	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80005a2c:	0001c717          	auipc	a4,0x1c
    80005a30:	fd872703          	lw	a4,-40(a4) # 80021a04 <log+0x2c>
    80005a34:	01d00793          	li	a5,29
    80005a38:	0ae7c263          	blt	a5,a4,80005adc <log_write+0xc8>
    80005a3c:	00050493          	mv	s1,a0
    80005a40:	0001c797          	auipc	a5,0x1c
    80005a44:	fb47a783          	lw	a5,-76(a5) # 800219f4 <log+0x1c>
    80005a48:	fff7879b          	addiw	a5,a5,-1
    80005a4c:	08f75863          	bge	a4,a5,80005adc <log_write+0xc8>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80005a50:	0001c797          	auipc	a5,0x1c
    80005a54:	fa87a783          	lw	a5,-88(a5) # 800219f8 <log+0x20>
    80005a58:	08f05a63          	blez	a5,80005aec <log_write+0xd8>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80005a5c:	0001c917          	auipc	s2,0x1c
    80005a60:	f7c90913          	addi	s2,s2,-132 # 800219d8 <log>
    80005a64:	00090513          	mv	a0,s2
    80005a68:	ffffb097          	auipc	ra,0xffffb
    80005a6c:	470080e7          	jalr	1136(ra) # 80000ed8 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    80005a70:	02c92603          	lw	a2,44(s2)
    80005a74:	08c05463          	blez	a2,80005afc <log_write+0xe8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80005a78:	0084a583          	lw	a1,8(s1)
    80005a7c:	0001c717          	auipc	a4,0x1c
    80005a80:	f8c70713          	addi	a4,a4,-116 # 80021a08 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80005a84:	00000793          	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80005a88:	00072683          	lw	a3,0(a4)
    80005a8c:	06b68a63          	beq	a3,a1,80005b00 <log_write+0xec>
  for (i = 0; i < log.lh.n; i++) {
    80005a90:	0017879b          	addiw	a5,a5,1
    80005a94:	00470713          	addi	a4,a4,4
    80005a98:	fec798e3          	bne	a5,a2,80005a88 <log_write+0x74>
      break;
  }
  log.lh.block[i] = b->blockno;
    80005a9c:	00860613          	addi	a2,a2,8
    80005aa0:	00261613          	slli	a2,a2,0x2
    80005aa4:	0001c797          	auipc	a5,0x1c
    80005aa8:	f3478793          	addi	a5,a5,-204 # 800219d8 <log>
    80005aac:	00c787b3          	add	a5,a5,a2
    80005ab0:	0084a703          	lw	a4,8(s1)
    80005ab4:	00e7a823          	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80005ab8:	00048513          	mv	a0,s1
    80005abc:	ffffe097          	auipc	ra,0xffffe
    80005ac0:	704080e7          	jalr	1796(ra) # 800041c0 <bpin>
    log.lh.n++;
    80005ac4:	0001c717          	auipc	a4,0x1c
    80005ac8:	f1470713          	addi	a4,a4,-236 # 800219d8 <log>
    80005acc:	02c72783          	lw	a5,44(a4)
    80005ad0:	0017879b          	addiw	a5,a5,1
    80005ad4:	02f72623          	sw	a5,44(a4)
    80005ad8:	0480006f          	j	80005b20 <log_write+0x10c>
    panic("too big a transaction");
    80005adc:	00003517          	auipc	a0,0x3
    80005ae0:	cbc50513          	addi	a0,a0,-836 # 80008798 <userret+0x6f4>
    80005ae4:	ffffb097          	auipc	ra,0xffffb
    80005ae8:	bf4080e7          	jalr	-1036(ra) # 800006d8 <panic>
    panic("log_write outside of trans");
    80005aec:	00003517          	auipc	a0,0x3
    80005af0:	cc450513          	addi	a0,a0,-828 # 800087b0 <userret+0x70c>
    80005af4:	ffffb097          	auipc	ra,0xffffb
    80005af8:	be4080e7          	jalr	-1052(ra) # 800006d8 <panic>
  for (i = 0; i < log.lh.n; i++) {
    80005afc:	00000793          	li	a5,0
  log.lh.block[i] = b->blockno;
    80005b00:	00878693          	addi	a3,a5,8
    80005b04:	00269693          	slli	a3,a3,0x2
    80005b08:	0001c717          	auipc	a4,0x1c
    80005b0c:	ed070713          	addi	a4,a4,-304 # 800219d8 <log>
    80005b10:	00d70733          	add	a4,a4,a3
    80005b14:	0084a683          	lw	a3,8(s1)
    80005b18:	00d72823          	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80005b1c:	f8f60ee3          	beq	a2,a5,80005ab8 <log_write+0xa4>
  }
  release(&log.lock);
    80005b20:	0001c517          	auipc	a0,0x1c
    80005b24:	eb850513          	addi	a0,a0,-328 # 800219d8 <log>
    80005b28:	ffffb097          	auipc	ra,0xffffb
    80005b2c:	428080e7          	jalr	1064(ra) # 80000f50 <release>
}
    80005b30:	01813083          	ld	ra,24(sp)
    80005b34:	01013403          	ld	s0,16(sp)
    80005b38:	00813483          	ld	s1,8(sp)
    80005b3c:	00013903          	ld	s2,0(sp)
    80005b40:	02010113          	addi	sp,sp,32
    80005b44:	00008067          	ret

0000000080005b48 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80005b48:	fe010113          	addi	sp,sp,-32
    80005b4c:	00113c23          	sd	ra,24(sp)
    80005b50:	00813823          	sd	s0,16(sp)
    80005b54:	00913423          	sd	s1,8(sp)
    80005b58:	01213023          	sd	s2,0(sp)
    80005b5c:	02010413          	addi	s0,sp,32
    80005b60:	00050493          	mv	s1,a0
    80005b64:	00058913          	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80005b68:	00003597          	auipc	a1,0x3
    80005b6c:	c6858593          	addi	a1,a1,-920 # 800087d0 <userret+0x72c>
    80005b70:	00850513          	addi	a0,a0,8
    80005b74:	ffffb097          	auipc	ra,0xffffb
    80005b78:	1dc080e7          	jalr	476(ra) # 80000d50 <initlock>
  lk->name = name;
    80005b7c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80005b80:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005b84:	0204a423          	sw	zero,40(s1)
}
    80005b88:	01813083          	ld	ra,24(sp)
    80005b8c:	01013403          	ld	s0,16(sp)
    80005b90:	00813483          	ld	s1,8(sp)
    80005b94:	00013903          	ld	s2,0(sp)
    80005b98:	02010113          	addi	sp,sp,32
    80005b9c:	00008067          	ret

0000000080005ba0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80005ba0:	fe010113          	addi	sp,sp,-32
    80005ba4:	00113c23          	sd	ra,24(sp)
    80005ba8:	00813823          	sd	s0,16(sp)
    80005bac:	00913423          	sd	s1,8(sp)
    80005bb0:	01213023          	sd	s2,0(sp)
    80005bb4:	02010413          	addi	s0,sp,32
    80005bb8:	00050493          	mv	s1,a0
  acquire(&lk->lk);
    80005bbc:	00850913          	addi	s2,a0,8
    80005bc0:	00090513          	mv	a0,s2
    80005bc4:	ffffb097          	auipc	ra,0xffffb
    80005bc8:	314080e7          	jalr	788(ra) # 80000ed8 <acquire>
  while (lk->locked) {
    80005bcc:	0004a783          	lw	a5,0(s1)
    80005bd0:	00078e63          	beqz	a5,80005bec <acquiresleep+0x4c>
    sleep(lk, &lk->lk);
    80005bd4:	00090593          	mv	a1,s2
    80005bd8:	00048513          	mv	a0,s1
    80005bdc:	ffffd097          	auipc	ra,0xffffd
    80005be0:	240080e7          	jalr	576(ra) # 80002e1c <sleep>
  while (lk->locked) {
    80005be4:	0004a783          	lw	a5,0(s1)
    80005be8:	fe0796e3          	bnez	a5,80005bd4 <acquiresleep+0x34>
  }
  lk->locked = 1;
    80005bec:	00100793          	li	a5,1
    80005bf0:	00f4a023          	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80005bf4:	ffffc097          	auipc	ra,0xffffc
    80005bf8:	7a4080e7          	jalr	1956(ra) # 80002398 <myproc>
    80005bfc:	03852783          	lw	a5,56(a0)
    80005c00:	02f4a423          	sw	a5,40(s1)
  release(&lk->lk);
    80005c04:	00090513          	mv	a0,s2
    80005c08:	ffffb097          	auipc	ra,0xffffb
    80005c0c:	348080e7          	jalr	840(ra) # 80000f50 <release>
}
    80005c10:	01813083          	ld	ra,24(sp)
    80005c14:	01013403          	ld	s0,16(sp)
    80005c18:	00813483          	ld	s1,8(sp)
    80005c1c:	00013903          	ld	s2,0(sp)
    80005c20:	02010113          	addi	sp,sp,32
    80005c24:	00008067          	ret

0000000080005c28 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80005c28:	fe010113          	addi	sp,sp,-32
    80005c2c:	00113c23          	sd	ra,24(sp)
    80005c30:	00813823          	sd	s0,16(sp)
    80005c34:	00913423          	sd	s1,8(sp)
    80005c38:	01213023          	sd	s2,0(sp)
    80005c3c:	02010413          	addi	s0,sp,32
    80005c40:	00050493          	mv	s1,a0
  acquire(&lk->lk);
    80005c44:	00850913          	addi	s2,a0,8
    80005c48:	00090513          	mv	a0,s2
    80005c4c:	ffffb097          	auipc	ra,0xffffb
    80005c50:	28c080e7          	jalr	652(ra) # 80000ed8 <acquire>
  lk->locked = 0;
    80005c54:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005c58:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80005c5c:	00048513          	mv	a0,s1
    80005c60:	ffffd097          	auipc	ra,0xffffd
    80005c64:	3d8080e7          	jalr	984(ra) # 80003038 <wakeup>
  release(&lk->lk);
    80005c68:	00090513          	mv	a0,s2
    80005c6c:	ffffb097          	auipc	ra,0xffffb
    80005c70:	2e4080e7          	jalr	740(ra) # 80000f50 <release>
}
    80005c74:	01813083          	ld	ra,24(sp)
    80005c78:	01013403          	ld	s0,16(sp)
    80005c7c:	00813483          	ld	s1,8(sp)
    80005c80:	00013903          	ld	s2,0(sp)
    80005c84:	02010113          	addi	sp,sp,32
    80005c88:	00008067          	ret

0000000080005c8c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80005c8c:	fd010113          	addi	sp,sp,-48
    80005c90:	02113423          	sd	ra,40(sp)
    80005c94:	02813023          	sd	s0,32(sp)
    80005c98:	00913c23          	sd	s1,24(sp)
    80005c9c:	01213823          	sd	s2,16(sp)
    80005ca0:	01313423          	sd	s3,8(sp)
    80005ca4:	03010413          	addi	s0,sp,48
    80005ca8:	00050493          	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80005cac:	00850913          	addi	s2,a0,8
    80005cb0:	00090513          	mv	a0,s2
    80005cb4:	ffffb097          	auipc	ra,0xffffb
    80005cb8:	224080e7          	jalr	548(ra) # 80000ed8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80005cbc:	0004a783          	lw	a5,0(s1)
    80005cc0:	02079a63          	bnez	a5,80005cf4 <holdingsleep+0x68>
    80005cc4:	00000493          	li	s1,0
  release(&lk->lk);
    80005cc8:	00090513          	mv	a0,s2
    80005ccc:	ffffb097          	auipc	ra,0xffffb
    80005cd0:	284080e7          	jalr	644(ra) # 80000f50 <release>
  return r;
}
    80005cd4:	00048513          	mv	a0,s1
    80005cd8:	02813083          	ld	ra,40(sp)
    80005cdc:	02013403          	ld	s0,32(sp)
    80005ce0:	01813483          	ld	s1,24(sp)
    80005ce4:	01013903          	ld	s2,16(sp)
    80005ce8:	00813983          	ld	s3,8(sp)
    80005cec:	03010113          	addi	sp,sp,48
    80005cf0:	00008067          	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80005cf4:	0284a983          	lw	s3,40(s1)
    80005cf8:	ffffc097          	auipc	ra,0xffffc
    80005cfc:	6a0080e7          	jalr	1696(ra) # 80002398 <myproc>
    80005d00:	03852483          	lw	s1,56(a0)
    80005d04:	413484b3          	sub	s1,s1,s3
    80005d08:	0014b493          	seqz	s1,s1
    80005d0c:	fbdff06f          	j	80005cc8 <holdingsleep+0x3c>

0000000080005d10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005d10:	ff010113          	addi	sp,sp,-16
    80005d14:	00113423          	sd	ra,8(sp)
    80005d18:	00813023          	sd	s0,0(sp)
    80005d1c:	01010413          	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005d20:	00003597          	auipc	a1,0x3
    80005d24:	ac058593          	addi	a1,a1,-1344 # 800087e0 <userret+0x73c>
    80005d28:	0001c517          	auipc	a0,0x1c
    80005d2c:	df850513          	addi	a0,a0,-520 # 80021b20 <ftable>
    80005d30:	ffffb097          	auipc	ra,0xffffb
    80005d34:	020080e7          	jalr	32(ra) # 80000d50 <initlock>
}
    80005d38:	00813083          	ld	ra,8(sp)
    80005d3c:	00013403          	ld	s0,0(sp)
    80005d40:	01010113          	addi	sp,sp,16
    80005d44:	00008067          	ret

0000000080005d48 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80005d48:	fe010113          	addi	sp,sp,-32
    80005d4c:	00113c23          	sd	ra,24(sp)
    80005d50:	00813823          	sd	s0,16(sp)
    80005d54:	00913423          	sd	s1,8(sp)
    80005d58:	02010413          	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80005d5c:	0001c517          	auipc	a0,0x1c
    80005d60:	dc450513          	addi	a0,a0,-572 # 80021b20 <ftable>
    80005d64:	ffffb097          	auipc	ra,0xffffb
    80005d68:	174080e7          	jalr	372(ra) # 80000ed8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005d6c:	0001c497          	auipc	s1,0x1c
    80005d70:	dcc48493          	addi	s1,s1,-564 # 80021b38 <ftable+0x18>
    80005d74:	0001d717          	auipc	a4,0x1d
    80005d78:	d6470713          	addi	a4,a4,-668 # 80022ad8 <panicked>
    if(f->ref == 0){
    80005d7c:	0044a783          	lw	a5,4(s1)
    80005d80:	02078263          	beqz	a5,80005da4 <filealloc+0x5c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005d84:	02848493          	addi	s1,s1,40
    80005d88:	fee49ae3          	bne	s1,a4,80005d7c <filealloc+0x34>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80005d8c:	0001c517          	auipc	a0,0x1c
    80005d90:	d9450513          	addi	a0,a0,-620 # 80021b20 <ftable>
    80005d94:	ffffb097          	auipc	ra,0xffffb
    80005d98:	1bc080e7          	jalr	444(ra) # 80000f50 <release>
  return 0;
    80005d9c:	00000493          	li	s1,0
    80005da0:	01c0006f          	j	80005dbc <filealloc+0x74>
      f->ref = 1;
    80005da4:	00100793          	li	a5,1
    80005da8:	00f4a223          	sw	a5,4(s1)
      release(&ftable.lock);
    80005dac:	0001c517          	auipc	a0,0x1c
    80005db0:	d7450513          	addi	a0,a0,-652 # 80021b20 <ftable>
    80005db4:	ffffb097          	auipc	ra,0xffffb
    80005db8:	19c080e7          	jalr	412(ra) # 80000f50 <release>
}
    80005dbc:	00048513          	mv	a0,s1
    80005dc0:	01813083          	ld	ra,24(sp)
    80005dc4:	01013403          	ld	s0,16(sp)
    80005dc8:	00813483          	ld	s1,8(sp)
    80005dcc:	02010113          	addi	sp,sp,32
    80005dd0:	00008067          	ret

0000000080005dd4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80005dd4:	fe010113          	addi	sp,sp,-32
    80005dd8:	00113c23          	sd	ra,24(sp)
    80005ddc:	00813823          	sd	s0,16(sp)
    80005de0:	00913423          	sd	s1,8(sp)
    80005de4:	02010413          	addi	s0,sp,32
    80005de8:	00050493          	mv	s1,a0
  acquire(&ftable.lock);
    80005dec:	0001c517          	auipc	a0,0x1c
    80005df0:	d3450513          	addi	a0,a0,-716 # 80021b20 <ftable>
    80005df4:	ffffb097          	auipc	ra,0xffffb
    80005df8:	0e4080e7          	jalr	228(ra) # 80000ed8 <acquire>
  if(f->ref < 1)
    80005dfc:	0044a783          	lw	a5,4(s1)
    80005e00:	02f05a63          	blez	a5,80005e34 <filedup+0x60>
    panic("filedup");
  f->ref++;
    80005e04:	0017879b          	addiw	a5,a5,1
    80005e08:	00f4a223          	sw	a5,4(s1)
  release(&ftable.lock);
    80005e0c:	0001c517          	auipc	a0,0x1c
    80005e10:	d1450513          	addi	a0,a0,-748 # 80021b20 <ftable>
    80005e14:	ffffb097          	auipc	ra,0xffffb
    80005e18:	13c080e7          	jalr	316(ra) # 80000f50 <release>
  return f;
}
    80005e1c:	00048513          	mv	a0,s1
    80005e20:	01813083          	ld	ra,24(sp)
    80005e24:	01013403          	ld	s0,16(sp)
    80005e28:	00813483          	ld	s1,8(sp)
    80005e2c:	02010113          	addi	sp,sp,32
    80005e30:	00008067          	ret
    panic("filedup");
    80005e34:	00003517          	auipc	a0,0x3
    80005e38:	9b450513          	addi	a0,a0,-1612 # 800087e8 <userret+0x744>
    80005e3c:	ffffb097          	auipc	ra,0xffffb
    80005e40:	89c080e7          	jalr	-1892(ra) # 800006d8 <panic>

0000000080005e44 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80005e44:	fc010113          	addi	sp,sp,-64
    80005e48:	02113c23          	sd	ra,56(sp)
    80005e4c:	02813823          	sd	s0,48(sp)
    80005e50:	02913423          	sd	s1,40(sp)
    80005e54:	03213023          	sd	s2,32(sp)
    80005e58:	01313c23          	sd	s3,24(sp)
    80005e5c:	01413823          	sd	s4,16(sp)
    80005e60:	01513423          	sd	s5,8(sp)
    80005e64:	04010413          	addi	s0,sp,64
    80005e68:	00050493          	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005e6c:	0001c517          	auipc	a0,0x1c
    80005e70:	cb450513          	addi	a0,a0,-844 # 80021b20 <ftable>
    80005e74:	ffffb097          	auipc	ra,0xffffb
    80005e78:	064080e7          	jalr	100(ra) # 80000ed8 <acquire>
  if(f->ref < 1)
    80005e7c:	0044a783          	lw	a5,4(s1)
    80005e80:	06f05863          	blez	a5,80005ef0 <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
    80005e84:	fff7879b          	addiw	a5,a5,-1
    80005e88:	0007871b          	sext.w	a4,a5
    80005e8c:	00f4a223          	sw	a5,4(s1)
    80005e90:	06e04863          	bgtz	a4,80005f00 <fileclose+0xbc>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80005e94:	0004a903          	lw	s2,0(s1)
    80005e98:	0094ca83          	lbu	s5,9(s1)
    80005e9c:	0104ba03          	ld	s4,16(s1)
    80005ea0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80005ea4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80005ea8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80005eac:	0001c517          	auipc	a0,0x1c
    80005eb0:	c7450513          	addi	a0,a0,-908 # 80021b20 <ftable>
    80005eb4:	ffffb097          	auipc	ra,0xffffb
    80005eb8:	09c080e7          	jalr	156(ra) # 80000f50 <release>

  if(ff.type == FD_PIPE){
    80005ebc:	00100793          	li	a5,1
    80005ec0:	06f90a63          	beq	s2,a5,80005f34 <fileclose+0xf0>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80005ec4:	ffe9091b          	addiw	s2,s2,-2
    80005ec8:	00100793          	li	a5,1
    80005ecc:	0527e263          	bltu	a5,s2,80005f10 <fileclose+0xcc>
    begin_op();
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	8e4080e7          	jalr	-1820(ra) # 800057b4 <begin_op>
    iput(ff.ip);
    80005ed8:	00098513          	mv	a0,s3
    80005edc:	fffff097          	auipc	ra,0xfffff
    80005ee0:	cbc080e7          	jalr	-836(ra) # 80004b98 <iput>
    end_op();
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	984080e7          	jalr	-1660(ra) # 80005868 <end_op>
    80005eec:	0240006f          	j	80005f10 <fileclose+0xcc>
    panic("fileclose");
    80005ef0:	00003517          	auipc	a0,0x3
    80005ef4:	90050513          	addi	a0,a0,-1792 # 800087f0 <userret+0x74c>
    80005ef8:	ffffa097          	auipc	ra,0xffffa
    80005efc:	7e0080e7          	jalr	2016(ra) # 800006d8 <panic>
    release(&ftable.lock);
    80005f00:	0001c517          	auipc	a0,0x1c
    80005f04:	c2050513          	addi	a0,a0,-992 # 80021b20 <ftable>
    80005f08:	ffffb097          	auipc	ra,0xffffb
    80005f0c:	048080e7          	jalr	72(ra) # 80000f50 <release>
  }
}
    80005f10:	03813083          	ld	ra,56(sp)
    80005f14:	03013403          	ld	s0,48(sp)
    80005f18:	02813483          	ld	s1,40(sp)
    80005f1c:	02013903          	ld	s2,32(sp)
    80005f20:	01813983          	ld	s3,24(sp)
    80005f24:	01013a03          	ld	s4,16(sp)
    80005f28:	00813a83          	ld	s5,8(sp)
    80005f2c:	04010113          	addi	sp,sp,64
    80005f30:	00008067          	ret
    pipeclose(ff.pipe, ff.writable);
    80005f34:	000a8593          	mv	a1,s5
    80005f38:	000a0513          	mv	a0,s4
    80005f3c:	00000097          	auipc	ra,0x0
    80005f40:	4e4080e7          	jalr	1252(ra) # 80006420 <pipeclose>
    80005f44:	fcdff06f          	j	80005f10 <fileclose+0xcc>

0000000080005f48 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80005f48:	fb010113          	addi	sp,sp,-80
    80005f4c:	04113423          	sd	ra,72(sp)
    80005f50:	04813023          	sd	s0,64(sp)
    80005f54:	02913c23          	sd	s1,56(sp)
    80005f58:	03213823          	sd	s2,48(sp)
    80005f5c:	03313423          	sd	s3,40(sp)
    80005f60:	05010413          	addi	s0,sp,80
    80005f64:	00050493          	mv	s1,a0
    80005f68:	00058993          	mv	s3,a1
  struct proc *p = myproc();
    80005f6c:	ffffc097          	auipc	ra,0xffffc
    80005f70:	42c080e7          	jalr	1068(ra) # 80002398 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80005f74:	0004a783          	lw	a5,0(s1)
    80005f78:	ffe7879b          	addiw	a5,a5,-2
    80005f7c:	00100713          	li	a4,1
    80005f80:	06f76463          	bltu	a4,a5,80005fe8 <filestat+0xa0>
    80005f84:	00050913          	mv	s2,a0
    ilock(f->ip);
    80005f88:	0184b503          	ld	a0,24(s1)
    80005f8c:	fffff097          	auipc	ra,0xfffff
    80005f90:	a98080e7          	jalr	-1384(ra) # 80004a24 <ilock>
    stati(f->ip, &st);
    80005f94:	fb840593          	addi	a1,s0,-72
    80005f98:	0184b503          	ld	a0,24(s1)
    80005f9c:	fffff097          	auipc	ra,0xfffff
    80005fa0:	dcc080e7          	jalr	-564(ra) # 80004d68 <stati>
    iunlock(f->ip);
    80005fa4:	0184b503          	ld	a0,24(s1)
    80005fa8:	fffff097          	auipc	ra,0xfffff
    80005fac:	b80080e7          	jalr	-1152(ra) # 80004b28 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80005fb0:	01800693          	li	a3,24
    80005fb4:	fb840613          	addi	a2,s0,-72
    80005fb8:	00098593          	mv	a1,s3
    80005fbc:	05093503          	ld	a0,80(s2)
    80005fc0:	ffffc097          	auipc	ra,0xffffc
    80005fc4:	f20080e7          	jalr	-224(ra) # 80001ee0 <copyout>
    80005fc8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80005fcc:	04813083          	ld	ra,72(sp)
    80005fd0:	04013403          	ld	s0,64(sp)
    80005fd4:	03813483          	ld	s1,56(sp)
    80005fd8:	03013903          	ld	s2,48(sp)
    80005fdc:	02813983          	ld	s3,40(sp)
    80005fe0:	05010113          	addi	sp,sp,80
    80005fe4:	00008067          	ret
  return -1;
    80005fe8:	fff00513          	li	a0,-1
    80005fec:	fe1ff06f          	j	80005fcc <filestat+0x84>

0000000080005ff0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80005ff0:	fd010113          	addi	sp,sp,-48
    80005ff4:	02113423          	sd	ra,40(sp)
    80005ff8:	02813023          	sd	s0,32(sp)
    80005ffc:	00913c23          	sd	s1,24(sp)
    80006000:	01213823          	sd	s2,16(sp)
    80006004:	01313423          	sd	s3,8(sp)
    80006008:	03010413          	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000600c:	00854783          	lbu	a5,8(a0)
    80006010:	0e078a63          	beqz	a5,80006104 <fileread+0x114>
    80006014:	00050493          	mv	s1,a0
    80006018:	00058993          	mv	s3,a1
    8000601c:	00060913          	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80006020:	00052783          	lw	a5,0(a0)
    80006024:	00100713          	li	a4,1
    80006028:	06e78e63          	beq	a5,a4,800060a4 <fileread+0xb4>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000602c:	00300713          	li	a4,3
    80006030:	08e78463          	beq	a5,a4,800060b8 <fileread+0xc8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80006034:	00200713          	li	a4,2
    80006038:	0ae79e63          	bne	a5,a4,800060f4 <fileread+0x104>
    ilock(f->ip);
    8000603c:	01853503          	ld	a0,24(a0)
    80006040:	fffff097          	auipc	ra,0xfffff
    80006044:	9e4080e7          	jalr	-1564(ra) # 80004a24 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80006048:	00090713          	mv	a4,s2
    8000604c:	0204a683          	lw	a3,32(s1)
    80006050:	00098613          	mv	a2,s3
    80006054:	00100593          	li	a1,1
    80006058:	0184b503          	ld	a0,24(s1)
    8000605c:	fffff097          	auipc	ra,0xfffff
    80006060:	d4c080e7          	jalr	-692(ra) # 80004da8 <readi>
    80006064:	00050913          	mv	s2,a0
    80006068:	00a05863          	blez	a0,80006078 <fileread+0x88>
      f->off += r;
    8000606c:	0204a783          	lw	a5,32(s1)
    80006070:	00a787bb          	addw	a5,a5,a0
    80006074:	02f4a023          	sw	a5,32(s1)
    iunlock(f->ip);
    80006078:	0184b503          	ld	a0,24(s1)
    8000607c:	fffff097          	auipc	ra,0xfffff
    80006080:	aac080e7          	jalr	-1364(ra) # 80004b28 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80006084:	00090513          	mv	a0,s2
    80006088:	02813083          	ld	ra,40(sp)
    8000608c:	02013403          	ld	s0,32(sp)
    80006090:	01813483          	ld	s1,24(sp)
    80006094:	01013903          	ld	s2,16(sp)
    80006098:	00813983          	ld	s3,8(sp)
    8000609c:	03010113          	addi	sp,sp,48
    800060a0:	00008067          	ret
    r = piperead(f->pipe, addr, n);
    800060a4:	01053503          	ld	a0,16(a0)
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	57c080e7          	jalr	1404(ra) # 80006624 <piperead>
    800060b0:	00050913          	mv	s2,a0
    800060b4:	fd1ff06f          	j	80006084 <fileread+0x94>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800060b8:	02451783          	lh	a5,36(a0)
    800060bc:	03079693          	slli	a3,a5,0x30
    800060c0:	0306d693          	srli	a3,a3,0x30
    800060c4:	00900713          	li	a4,9
    800060c8:	04d76263          	bltu	a4,a3,8000610c <fileread+0x11c>
    800060cc:	00479793          	slli	a5,a5,0x4
    800060d0:	0001c717          	auipc	a4,0x1c
    800060d4:	9b070713          	addi	a4,a4,-1616 # 80021a80 <devsw>
    800060d8:	00f707b3          	add	a5,a4,a5
    800060dc:	0007b783          	ld	a5,0(a5)
    800060e0:	02078a63          	beqz	a5,80006114 <fileread+0x124>
    r = devsw[f->major].read(1, addr, n);
    800060e4:	00100513          	li	a0,1
    800060e8:	000780e7          	jalr	a5
    800060ec:	00050913          	mv	s2,a0
    800060f0:	f95ff06f          	j	80006084 <fileread+0x94>
    panic("fileread");
    800060f4:	00002517          	auipc	a0,0x2
    800060f8:	70c50513          	addi	a0,a0,1804 # 80008800 <userret+0x75c>
    800060fc:	ffffa097          	auipc	ra,0xffffa
    80006100:	5dc080e7          	jalr	1500(ra) # 800006d8 <panic>
    return -1;
    80006104:	fff00913          	li	s2,-1
    80006108:	f7dff06f          	j	80006084 <fileread+0x94>
      return -1;
    8000610c:	fff00913          	li	s2,-1
    80006110:	f75ff06f          	j	80006084 <fileread+0x94>
    80006114:	fff00913          	li	s2,-1
    80006118:	f6dff06f          	j	80006084 <fileread+0x94>

000000008000611c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000611c:	00954783          	lbu	a5,9(a0)
    80006120:	1a078e63          	beqz	a5,800062dc <filewrite+0x1c0>
{
    80006124:	fb010113          	addi	sp,sp,-80
    80006128:	04113423          	sd	ra,72(sp)
    8000612c:	04813023          	sd	s0,64(sp)
    80006130:	02913c23          	sd	s1,56(sp)
    80006134:	03213823          	sd	s2,48(sp)
    80006138:	03313423          	sd	s3,40(sp)
    8000613c:	03413023          	sd	s4,32(sp)
    80006140:	01513c23          	sd	s5,24(sp)
    80006144:	01613823          	sd	s6,16(sp)
    80006148:	01713423          	sd	s7,8(sp)
    8000614c:	01813023          	sd	s8,0(sp)
    80006150:	05010413          	addi	s0,sp,80
    80006154:	00050913          	mv	s2,a0
    80006158:	00058b13          	mv	s6,a1
    8000615c:	00060a13          	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80006160:	00052783          	lw	a5,0(a0)
    80006164:	00100713          	li	a4,1
    80006168:	02e78863          	beq	a5,a4,80006198 <filewrite+0x7c>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000616c:	00300713          	li	a4,3
    80006170:	02e78c63          	beq	a5,a4,800061a8 <filewrite+0x8c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80006174:	00200713          	li	a4,2
    80006178:	14e79a63          	bne	a5,a4,800062cc <filewrite+0x1b0>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000617c:	14c05063          	blez	a2,800062bc <filewrite+0x1a0>
    int i = 0;
    80006180:	00000993          	li	s3,0
    80006184:	00001bb7          	lui	s7,0x1
    80006188:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000618c:	00001c37          	lui	s8,0x1
    80006190:	c00c0c1b          	addiw	s8,s8,-1024
    80006194:	0b40006f          	j	80006248 <filewrite+0x12c>
    ret = pipewrite(f->pipe, addr, n);
    80006198:	01053503          	ld	a0,16(a0)
    8000619c:	00000097          	auipc	ra,0x0
    800061a0:	31c080e7          	jalr	796(ra) # 800064b8 <pipewrite>
    800061a4:	0d80006f          	j	8000627c <filewrite+0x160>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800061a8:	02451783          	lh	a5,36(a0)
    800061ac:	03079693          	slli	a3,a5,0x30
    800061b0:	0306d693          	srli	a3,a3,0x30
    800061b4:	00900713          	li	a4,9
    800061b8:	12d76663          	bltu	a4,a3,800062e4 <filewrite+0x1c8>
    800061bc:	00479793          	slli	a5,a5,0x4
    800061c0:	0001c717          	auipc	a4,0x1c
    800061c4:	8c070713          	addi	a4,a4,-1856 # 80021a80 <devsw>
    800061c8:	00f707b3          	add	a5,a4,a5
    800061cc:	0087b783          	ld	a5,8(a5)
    800061d0:	10078e63          	beqz	a5,800062ec <filewrite+0x1d0>
    ret = devsw[f->major].write(1, addr, n);
    800061d4:	00100513          	li	a0,1
    800061d8:	000780e7          	jalr	a5
    800061dc:	0a00006f          	j	8000627c <filewrite+0x160>
    800061e0:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800061e4:	fffff097          	auipc	ra,0xfffff
    800061e8:	5d0080e7          	jalr	1488(ra) # 800057b4 <begin_op>
      ilock(f->ip);
    800061ec:	01893503          	ld	a0,24(s2)
    800061f0:	fffff097          	auipc	ra,0xfffff
    800061f4:	834080e7          	jalr	-1996(ra) # 80004a24 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800061f8:	000a8713          	mv	a4,s5
    800061fc:	02092683          	lw	a3,32(s2)
    80006200:	01698633          	add	a2,s3,s6
    80006204:	00100593          	li	a1,1
    80006208:	01893503          	ld	a0,24(s2)
    8000620c:	fffff097          	auipc	ra,0xfffff
    80006210:	d04080e7          	jalr	-764(ra) # 80004f10 <writei>
    80006214:	00050493          	mv	s1,a0
    80006218:	04a05263          	blez	a0,8000625c <filewrite+0x140>
        f->off += r;
    8000621c:	02092783          	lw	a5,32(s2)
    80006220:	00a787bb          	addw	a5,a5,a0
    80006224:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80006228:	01893503          	ld	a0,24(s2)
    8000622c:	fffff097          	auipc	ra,0xfffff
    80006230:	8fc080e7          	jalr	-1796(ra) # 80004b28 <iunlock>
      end_op();
    80006234:	fffff097          	auipc	ra,0xfffff
    80006238:	634080e7          	jalr	1588(ra) # 80005868 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    8000623c:	069a9863          	bne	s5,s1,800062ac <filewrite+0x190>
        panic("short filewrite");
      i += r;
    80006240:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80006244:	0349d863          	bge	s3,s4,80006274 <filewrite+0x158>
      int n1 = n - i;
    80006248:	413a04bb          	subw	s1,s4,s3
    8000624c:	0004879b          	sext.w	a5,s1
    80006250:	f8fbd8e3          	bge	s7,a5,800061e0 <filewrite+0xc4>
    80006254:	000c0493          	mv	s1,s8
    80006258:	f89ff06f          	j	800061e0 <filewrite+0xc4>
      iunlock(f->ip);
    8000625c:	01893503          	ld	a0,24(s2)
    80006260:	fffff097          	auipc	ra,0xfffff
    80006264:	8c8080e7          	jalr	-1848(ra) # 80004b28 <iunlock>
      end_op();
    80006268:	fffff097          	auipc	ra,0xfffff
    8000626c:	600080e7          	jalr	1536(ra) # 80005868 <end_op>
      if(r < 0)
    80006270:	fc04d6e3          	bgez	s1,8000623c <filewrite+0x120>
    }
    ret = (i == n ? n : -1);
    80006274:	000a0513          	mv	a0,s4
    80006278:	053a1663          	bne	s4,s3,800062c4 <filewrite+0x1a8>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000627c:	04813083          	ld	ra,72(sp)
    80006280:	04013403          	ld	s0,64(sp)
    80006284:	03813483          	ld	s1,56(sp)
    80006288:	03013903          	ld	s2,48(sp)
    8000628c:	02813983          	ld	s3,40(sp)
    80006290:	02013a03          	ld	s4,32(sp)
    80006294:	01813a83          	ld	s5,24(sp)
    80006298:	01013b03          	ld	s6,16(sp)
    8000629c:	00813b83          	ld	s7,8(sp)
    800062a0:	00013c03          	ld	s8,0(sp)
    800062a4:	05010113          	addi	sp,sp,80
    800062a8:	00008067          	ret
        panic("short filewrite");
    800062ac:	00002517          	auipc	a0,0x2
    800062b0:	56450513          	addi	a0,a0,1380 # 80008810 <userret+0x76c>
    800062b4:	ffffa097          	auipc	ra,0xffffa
    800062b8:	424080e7          	jalr	1060(ra) # 800006d8 <panic>
    int i = 0;
    800062bc:	00000993          	li	s3,0
    800062c0:	fb5ff06f          	j	80006274 <filewrite+0x158>
    ret = (i == n ? n : -1);
    800062c4:	fff00513          	li	a0,-1
    800062c8:	fb5ff06f          	j	8000627c <filewrite+0x160>
    panic("filewrite");
    800062cc:	00002517          	auipc	a0,0x2
    800062d0:	55450513          	addi	a0,a0,1364 # 80008820 <userret+0x77c>
    800062d4:	ffffa097          	auipc	ra,0xffffa
    800062d8:	404080e7          	jalr	1028(ra) # 800006d8 <panic>
    return -1;
    800062dc:	fff00513          	li	a0,-1
}
    800062e0:	00008067          	ret
      return -1;
    800062e4:	fff00513          	li	a0,-1
    800062e8:	f95ff06f          	j	8000627c <filewrite+0x160>
    800062ec:	fff00513          	li	a0,-1
    800062f0:	f8dff06f          	j	8000627c <filewrite+0x160>

00000000800062f4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800062f4:	fd010113          	addi	sp,sp,-48
    800062f8:	02113423          	sd	ra,40(sp)
    800062fc:	02813023          	sd	s0,32(sp)
    80006300:	00913c23          	sd	s1,24(sp)
    80006304:	01213823          	sd	s2,16(sp)
    80006308:	01313423          	sd	s3,8(sp)
    8000630c:	01413023          	sd	s4,0(sp)
    80006310:	03010413          	addi	s0,sp,48
    80006314:	00050493          	mv	s1,a0
    80006318:	00058a13          	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000631c:	0005b023          	sd	zero,0(a1)
    80006320:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80006324:	00000097          	auipc	ra,0x0
    80006328:	a24080e7          	jalr	-1500(ra) # 80005d48 <filealloc>
    8000632c:	00a4b023          	sd	a0,0(s1)
    80006330:	0a050663          	beqz	a0,800063dc <pipealloc+0xe8>
    80006334:	00000097          	auipc	ra,0x0
    80006338:	a14080e7          	jalr	-1516(ra) # 80005d48 <filealloc>
    8000633c:	00aa3023          	sd	a0,0(s4)
    80006340:	08050663          	beqz	a0,800063cc <pipealloc+0xd8>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80006344:	ffffb097          	auipc	ra,0xffffb
    80006348:	984080e7          	jalr	-1660(ra) # 80000cc8 <kalloc>
    8000634c:	00050913          	mv	s2,a0
    80006350:	06050863          	beqz	a0,800063c0 <pipealloc+0xcc>
    goto bad;
  pi->readopen = 1;
    80006354:	00100993          	li	s3,1
    80006358:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000635c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80006360:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80006364:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80006368:	00002597          	auipc	a1,0x2
    8000636c:	4c858593          	addi	a1,a1,1224 # 80008830 <userret+0x78c>
    80006370:	ffffb097          	auipc	ra,0xffffb
    80006374:	9e0080e7          	jalr	-1568(ra) # 80000d50 <initlock>
  (*f0)->type = FD_PIPE;
    80006378:	0004b783          	ld	a5,0(s1)
    8000637c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80006380:	0004b783          	ld	a5,0(s1)
    80006384:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80006388:	0004b783          	ld	a5,0(s1)
    8000638c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80006390:	0004b783          	ld	a5,0(s1)
    80006394:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80006398:	000a3783          	ld	a5,0(s4)
    8000639c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800063a0:	000a3783          	ld	a5,0(s4)
    800063a4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800063a8:	000a3783          	ld	a5,0(s4)
    800063ac:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800063b0:	000a3783          	ld	a5,0(s4)
    800063b4:	0127b823          	sd	s2,16(a5)
  return 0;
    800063b8:	00000513          	li	a0,0
    800063bc:	03c0006f          	j	800063f8 <pipealloc+0x104>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800063c0:	0004b503          	ld	a0,0(s1)
    800063c4:	00051863          	bnez	a0,800063d4 <pipealloc+0xe0>
    800063c8:	0140006f          	j	800063dc <pipealloc+0xe8>
    800063cc:	0004b503          	ld	a0,0(s1)
    800063d0:	04050463          	beqz	a0,80006418 <pipealloc+0x124>
    fileclose(*f0);
    800063d4:	00000097          	auipc	ra,0x0
    800063d8:	a70080e7          	jalr	-1424(ra) # 80005e44 <fileclose>
  if(*f1)
    800063dc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800063e0:	fff00513          	li	a0,-1
  if(*f1)
    800063e4:	00078a63          	beqz	a5,800063f8 <pipealloc+0x104>
    fileclose(*f1);
    800063e8:	00078513          	mv	a0,a5
    800063ec:	00000097          	auipc	ra,0x0
    800063f0:	a58080e7          	jalr	-1448(ra) # 80005e44 <fileclose>
  return -1;
    800063f4:	fff00513          	li	a0,-1
}
    800063f8:	02813083          	ld	ra,40(sp)
    800063fc:	02013403          	ld	s0,32(sp)
    80006400:	01813483          	ld	s1,24(sp)
    80006404:	01013903          	ld	s2,16(sp)
    80006408:	00813983          	ld	s3,8(sp)
    8000640c:	00013a03          	ld	s4,0(sp)
    80006410:	03010113          	addi	sp,sp,48
    80006414:	00008067          	ret
  return -1;
    80006418:	fff00513          	li	a0,-1
    8000641c:	fddff06f          	j	800063f8 <pipealloc+0x104>

0000000080006420 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80006420:	fe010113          	addi	sp,sp,-32
    80006424:	00113c23          	sd	ra,24(sp)
    80006428:	00813823          	sd	s0,16(sp)
    8000642c:	00913423          	sd	s1,8(sp)
    80006430:	01213023          	sd	s2,0(sp)
    80006434:	02010413          	addi	s0,sp,32
    80006438:	00050493          	mv	s1,a0
    8000643c:	00058913          	mv	s2,a1
  acquire(&pi->lock);
    80006440:	ffffb097          	auipc	ra,0xffffb
    80006444:	a98080e7          	jalr	-1384(ra) # 80000ed8 <acquire>
  if(writable){
    80006448:	04090663          	beqz	s2,80006494 <pipeclose+0x74>
    pi->writeopen = 0;
    8000644c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80006450:	21848513          	addi	a0,s1,536
    80006454:	ffffd097          	auipc	ra,0xffffd
    80006458:	be4080e7          	jalr	-1052(ra) # 80003038 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000645c:	2204b783          	ld	a5,544(s1)
    80006460:	04079463          	bnez	a5,800064a8 <pipeclose+0x88>
    release(&pi->lock);
    80006464:	00048513          	mv	a0,s1
    80006468:	ffffb097          	auipc	ra,0xffffb
    8000646c:	ae8080e7          	jalr	-1304(ra) # 80000f50 <release>
    kfree((char*)pi);
    80006470:	00048513          	mv	a0,s1
    80006474:	ffffa097          	auipc	ra,0xffffa
    80006478:	670080e7          	jalr	1648(ra) # 80000ae4 <kfree>
  } else
    release(&pi->lock);
}
    8000647c:	01813083          	ld	ra,24(sp)
    80006480:	01013403          	ld	s0,16(sp)
    80006484:	00813483          	ld	s1,8(sp)
    80006488:	00013903          	ld	s2,0(sp)
    8000648c:	02010113          	addi	sp,sp,32
    80006490:	00008067          	ret
    pi->readopen = 0;
    80006494:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80006498:	21c48513          	addi	a0,s1,540
    8000649c:	ffffd097          	auipc	ra,0xffffd
    800064a0:	b9c080e7          	jalr	-1124(ra) # 80003038 <wakeup>
    800064a4:	fb9ff06f          	j	8000645c <pipeclose+0x3c>
    release(&pi->lock);
    800064a8:	00048513          	mv	a0,s1
    800064ac:	ffffb097          	auipc	ra,0xffffb
    800064b0:	aa4080e7          	jalr	-1372(ra) # 80000f50 <release>
}
    800064b4:	fc9ff06f          	j	8000647c <pipeclose+0x5c>

00000000800064b8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800064b8:	fa010113          	addi	sp,sp,-96
    800064bc:	04113c23          	sd	ra,88(sp)
    800064c0:	04813823          	sd	s0,80(sp)
    800064c4:	04913423          	sd	s1,72(sp)
    800064c8:	05213023          	sd	s2,64(sp)
    800064cc:	03313c23          	sd	s3,56(sp)
    800064d0:	03413823          	sd	s4,48(sp)
    800064d4:	03513423          	sd	s5,40(sp)
    800064d8:	03613023          	sd	s6,32(sp)
    800064dc:	01713c23          	sd	s7,24(sp)
    800064e0:	01813823          	sd	s8,16(sp)
    800064e4:	06010413          	addi	s0,sp,96
    800064e8:	00050493          	mv	s1,a0
    800064ec:	00058a93          	mv	s5,a1
    800064f0:	00060a13          	mv	s4,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    800064f4:	ffffc097          	auipc	ra,0xffffc
    800064f8:	ea4080e7          	jalr	-348(ra) # 80002398 <myproc>
    800064fc:	00050b93          	mv	s7,a0

  acquire(&pi->lock);
    80006500:	00048513          	mv	a0,s1
    80006504:	ffffb097          	auipc	ra,0xffffb
    80006508:	9d4080e7          	jalr	-1580(ra) # 80000ed8 <acquire>
  for(i = 0; i < n; i++){
    8000650c:	0b405c63          	blez	s4,800065c4 <pipewrite+0x10c>
    80006510:	fffa0b1b          	addiw	s6,s4,-1
    80006514:	020b1b13          	slli	s6,s6,0x20
    80006518:	020b5b13          	srli	s6,s6,0x20
    8000651c:	001a8793          	addi	a5,s5,1
    80006520:	00fb0b33          	add	s6,s6,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80006524:	21848993          	addi	s3,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80006528:	21c48913          	addi	s2,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000652c:	fff00c13          	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80006530:	2184a783          	lw	a5,536(s1)
    80006534:	21c4a703          	lw	a4,540(s1)
    80006538:	2007879b          	addiw	a5,a5,512
    8000653c:	04f71463          	bne	a4,a5,80006584 <pipewrite+0xcc>
      if(pi->readopen == 0 || myproc()->killed){
    80006540:	2204a783          	lw	a5,544(s1)
    80006544:	0a078063          	beqz	a5,800065e4 <pipewrite+0x12c>
    80006548:	ffffc097          	auipc	ra,0xffffc
    8000654c:	e50080e7          	jalr	-432(ra) # 80002398 <myproc>
    80006550:	03052783          	lw	a5,48(a0)
    80006554:	08079863          	bnez	a5,800065e4 <pipewrite+0x12c>
      wakeup(&pi->nread);
    80006558:	00098513          	mv	a0,s3
    8000655c:	ffffd097          	auipc	ra,0xffffd
    80006560:	adc080e7          	jalr	-1316(ra) # 80003038 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80006564:	00048593          	mv	a1,s1
    80006568:	00090513          	mv	a0,s2
    8000656c:	ffffd097          	auipc	ra,0xffffd
    80006570:	8b0080e7          	jalr	-1872(ra) # 80002e1c <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80006574:	2184a783          	lw	a5,536(s1)
    80006578:	21c4a703          	lw	a4,540(s1)
    8000657c:	2007879b          	addiw	a5,a5,512
    80006580:	fcf700e3          	beq	a4,a5,80006540 <pipewrite+0x88>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80006584:	00100693          	li	a3,1
    80006588:	000a8613          	mv	a2,s5
    8000658c:	faf40593          	addi	a1,s0,-81
    80006590:	050bb503          	ld	a0,80(s7)
    80006594:	ffffc097          	auipc	ra,0xffffc
    80006598:	a34080e7          	jalr	-1484(ra) # 80001fc8 <copyin>
    8000659c:	03850463          	beq	a0,s8,800065c4 <pipewrite+0x10c>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800065a0:	21c4a783          	lw	a5,540(s1)
    800065a4:	0017871b          	addiw	a4,a5,1
    800065a8:	20e4ae23          	sw	a4,540(s1)
    800065ac:	1ff7f793          	andi	a5,a5,511
    800065b0:	00f487b3          	add	a5,s1,a5
    800065b4:	faf44703          	lbu	a4,-81(s0)
    800065b8:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    800065bc:	001a8a93          	addi	s5,s5,1
    800065c0:	f76a98e3          	bne	s5,s6,80006530 <pipewrite+0x78>
  }
  wakeup(&pi->nread);
    800065c4:	21848513          	addi	a0,s1,536
    800065c8:	ffffd097          	auipc	ra,0xffffd
    800065cc:	a70080e7          	jalr	-1424(ra) # 80003038 <wakeup>
  release(&pi->lock);
    800065d0:	00048513          	mv	a0,s1
    800065d4:	ffffb097          	auipc	ra,0xffffb
    800065d8:	97c080e7          	jalr	-1668(ra) # 80000f50 <release>
  return n;
    800065dc:	000a0513          	mv	a0,s4
    800065e0:	0140006f          	j	800065f4 <pipewrite+0x13c>
        release(&pi->lock);
    800065e4:	00048513          	mv	a0,s1
    800065e8:	ffffb097          	auipc	ra,0xffffb
    800065ec:	968080e7          	jalr	-1688(ra) # 80000f50 <release>
        return -1;
    800065f0:	fff00513          	li	a0,-1
}
    800065f4:	05813083          	ld	ra,88(sp)
    800065f8:	05013403          	ld	s0,80(sp)
    800065fc:	04813483          	ld	s1,72(sp)
    80006600:	04013903          	ld	s2,64(sp)
    80006604:	03813983          	ld	s3,56(sp)
    80006608:	03013a03          	ld	s4,48(sp)
    8000660c:	02813a83          	ld	s5,40(sp)
    80006610:	02013b03          	ld	s6,32(sp)
    80006614:	01813b83          	ld	s7,24(sp)
    80006618:	01013c03          	ld	s8,16(sp)
    8000661c:	06010113          	addi	sp,sp,96
    80006620:	00008067          	ret

0000000080006624 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80006624:	fb010113          	addi	sp,sp,-80
    80006628:	04113423          	sd	ra,72(sp)
    8000662c:	04813023          	sd	s0,64(sp)
    80006630:	02913c23          	sd	s1,56(sp)
    80006634:	03213823          	sd	s2,48(sp)
    80006638:	03313423          	sd	s3,40(sp)
    8000663c:	03413023          	sd	s4,32(sp)
    80006640:	01513c23          	sd	s5,24(sp)
    80006644:	01613823          	sd	s6,16(sp)
    80006648:	05010413          	addi	s0,sp,80
    8000664c:	00050493          	mv	s1,a0
    80006650:	00058913          	mv	s2,a1
    80006654:	00060a13          	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80006658:	ffffc097          	auipc	ra,0xffffc
    8000665c:	d40080e7          	jalr	-704(ra) # 80002398 <myproc>
    80006660:	00050a93          	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80006664:	00048513          	mv	a0,s1
    80006668:	ffffb097          	auipc	ra,0xffffb
    8000666c:	870080e7          	jalr	-1936(ra) # 80000ed8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80006670:	2184a703          	lw	a4,536(s1)
    80006674:	21c4a783          	lw	a5,540(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80006678:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000667c:	02f71c63          	bne	a4,a5,800066b4 <piperead+0x90>
    80006680:	2244a783          	lw	a5,548(s1)
    80006684:	02078863          	beqz	a5,800066b4 <piperead+0x90>
    if(myproc()->killed){
    80006688:	ffffc097          	auipc	ra,0xffffc
    8000668c:	d10080e7          	jalr	-752(ra) # 80002398 <myproc>
    80006690:	03052783          	lw	a5,48(a0)
    80006694:	0c079063          	bnez	a5,80006754 <piperead+0x130>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80006698:	00048593          	mv	a1,s1
    8000669c:	00098513          	mv	a0,s3
    800066a0:	ffffc097          	auipc	ra,0xffffc
    800066a4:	77c080e7          	jalr	1916(ra) # 80002e1c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800066a8:	2184a703          	lw	a4,536(s1)
    800066ac:	21c4a783          	lw	a5,540(s1)
    800066b0:	fcf708e3          	beq	a4,a5,80006680 <piperead+0x5c>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800066b4:	00000993          	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800066b8:	fff00b13          	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800066bc:	05405a63          	blez	s4,80006710 <piperead+0xec>
    if(pi->nread == pi->nwrite)
    800066c0:	2184a783          	lw	a5,536(s1)
    800066c4:	21c4a703          	lw	a4,540(s1)
    800066c8:	04f70463          	beq	a4,a5,80006710 <piperead+0xec>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800066cc:	0017871b          	addiw	a4,a5,1
    800066d0:	20e4ac23          	sw	a4,536(s1)
    800066d4:	1ff7f793          	andi	a5,a5,511
    800066d8:	00f487b3          	add	a5,s1,a5
    800066dc:	0187c783          	lbu	a5,24(a5)
    800066e0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800066e4:	00100693          	li	a3,1
    800066e8:	fbf40613          	addi	a2,s0,-65
    800066ec:	00090593          	mv	a1,s2
    800066f0:	050ab503          	ld	a0,80(s5)
    800066f4:	ffffb097          	auipc	ra,0xffffb
    800066f8:	7ec080e7          	jalr	2028(ra) # 80001ee0 <copyout>
    800066fc:	01650a63          	beq	a0,s6,80006710 <piperead+0xec>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80006700:	0019899b          	addiw	s3,s3,1
    80006704:	00190913          	addi	s2,s2,1
    80006708:	fb3a1ce3          	bne	s4,s3,800066c0 <piperead+0x9c>
    8000670c:	000a0993          	mv	s3,s4
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80006710:	21c48513          	addi	a0,s1,540
    80006714:	ffffd097          	auipc	ra,0xffffd
    80006718:	924080e7          	jalr	-1756(ra) # 80003038 <wakeup>
  release(&pi->lock);
    8000671c:	00048513          	mv	a0,s1
    80006720:	ffffb097          	auipc	ra,0xffffb
    80006724:	830080e7          	jalr	-2000(ra) # 80000f50 <release>
  return i;
}
    80006728:	00098513          	mv	a0,s3
    8000672c:	04813083          	ld	ra,72(sp)
    80006730:	04013403          	ld	s0,64(sp)
    80006734:	03813483          	ld	s1,56(sp)
    80006738:	03013903          	ld	s2,48(sp)
    8000673c:	02813983          	ld	s3,40(sp)
    80006740:	02013a03          	ld	s4,32(sp)
    80006744:	01813a83          	ld	s5,24(sp)
    80006748:	01013b03          	ld	s6,16(sp)
    8000674c:	05010113          	addi	sp,sp,80
    80006750:	00008067          	ret
      release(&pi->lock);
    80006754:	00048513          	mv	a0,s1
    80006758:	ffffa097          	auipc	ra,0xffffa
    8000675c:	7f8080e7          	jalr	2040(ra) # 80000f50 <release>
      return -1;
    80006760:	fff00993          	li	s3,-1
    80006764:	fc5ff06f          	j	80006728 <piperead+0x104>

0000000080006768 <ramdiskinit>:
#include "fs.h"
#include "buf.h"

void
ramdiskinit(void)
{
    80006768:	ff010113          	addi	sp,sp,-16
    8000676c:	00813423          	sd	s0,8(sp)
    80006770:	01010413          	addi	s0,sp,16
}
    80006774:	00813403          	ld	s0,8(sp)
    80006778:	01010113          	addi	sp,sp,16
    8000677c:	00008067          	ret

0000000080006780 <ramdiskrw>:

// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ramdiskrw(struct buf *b)
{
    80006780:	fe010113          	addi	sp,sp,-32
    80006784:	00113c23          	sd	ra,24(sp)
    80006788:	00813823          	sd	s0,16(sp)
    8000678c:	00913423          	sd	s1,8(sp)
    80006790:	02010413          	addi	s0,sp,32
    80006794:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80006798:	01050513          	addi	a0,a0,16
    8000679c:	fffff097          	auipc	ra,0xfffff
    800067a0:	4f0080e7          	jalr	1264(ra) # 80005c8c <holdingsleep>
    800067a4:	06050863          	beqz	a0,80006814 <ramdiskrw+0x94>
    panic("ramdiskrw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    800067a8:	0004a783          	lw	a5,0(s1)
    800067ac:	0067f693          	andi	a3,a5,6
    800067b0:	00200713          	li	a4,2
    800067b4:	06e68863          	beq	a3,a4,80006824 <ramdiskrw+0xa4>
    panic("ramdiskrw: nothing to do");

  if(b->blockno >= FSSIZE)
    800067b8:	0084a503          	lw	a0,8(s1)
    800067bc:	3e700713          	li	a4,999
    800067c0:	06a76a63          	bltu	a4,a0,80006834 <ramdiskrw+0xb4>
    panic("ramdiskrw: blockno too big");

  uint64 diskaddr = b->blockno * BSIZE;
    800067c4:	00a5151b          	slliw	a0,a0,0xa
    800067c8:	02051513          	slli	a0,a0,0x20
    800067cc:	02055513          	srli	a0,a0,0x20
  char *addr = (char *)RAMDISK + diskaddr;
    800067d0:	01100713          	li	a4,17
    800067d4:	01b71713          	slli	a4,a4,0x1b
    800067d8:	00e50533          	add	a0,a0,a4

  if(b->flags & B_DIRTY){
    800067dc:	0047f793          	andi	a5,a5,4
    800067e0:	06078263          	beqz	a5,80006844 <ramdiskrw+0xc4>
    // write
    memmove(addr, b->data, BSIZE);
    800067e4:	40000613          	li	a2,1024
    800067e8:	06048593          	addi	a1,s1,96
    800067ec:	ffffb097          	auipc	ra,0xffffb
    800067f0:	858080e7          	jalr	-1960(ra) # 80001044 <memmove>
    b->flags &= ~B_DIRTY;
    800067f4:	0004a783          	lw	a5,0(s1)
    800067f8:	ffb7f793          	andi	a5,a5,-5
    800067fc:	00f4a023          	sw	a5,0(s1)
  } else {
    // read
    memmove(b->data, addr, BSIZE);
    b->flags |= B_VALID;
  }
}
    80006800:	01813083          	ld	ra,24(sp)
    80006804:	01013403          	ld	s0,16(sp)
    80006808:	00813483          	ld	s1,8(sp)
    8000680c:	02010113          	addi	sp,sp,32
    80006810:	00008067          	ret
    panic("ramdiskrw: buf not locked");
    80006814:	00002517          	auipc	a0,0x2
    80006818:	02450513          	addi	a0,a0,36 # 80008838 <userret+0x794>
    8000681c:	ffffa097          	auipc	ra,0xffffa
    80006820:	ebc080e7          	jalr	-324(ra) # 800006d8 <panic>
    panic("ramdiskrw: nothing to do");
    80006824:	00002517          	auipc	a0,0x2
    80006828:	03450513          	addi	a0,a0,52 # 80008858 <userret+0x7b4>
    8000682c:	ffffa097          	auipc	ra,0xffffa
    80006830:	eac080e7          	jalr	-340(ra) # 800006d8 <panic>
    panic("ramdiskrw: blockno too big");
    80006834:	00002517          	auipc	a0,0x2
    80006838:	04450513          	addi	a0,a0,68 # 80008878 <userret+0x7d4>
    8000683c:	ffffa097          	auipc	ra,0xffffa
    80006840:	e9c080e7          	jalr	-356(ra) # 800006d8 <panic>
    memmove(b->data, addr, BSIZE);
    80006844:	40000613          	li	a2,1024
    80006848:	00050593          	mv	a1,a0
    8000684c:	06048513          	addi	a0,s1,96
    80006850:	ffffa097          	auipc	ra,0xffffa
    80006854:	7f4080e7          	jalr	2036(ra) # 80001044 <memmove>
    b->flags |= B_VALID;
    80006858:	0004a783          	lw	a5,0(s1)
    8000685c:	0027e793          	ori	a5,a5,2
    80006860:	f9dff06f          	j	800067fc <ramdiskrw+0x7c>

0000000080006864 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80006864:	de010113          	addi	sp,sp,-544
    80006868:	20113c23          	sd	ra,536(sp)
    8000686c:	20813823          	sd	s0,528(sp)
    80006870:	20913423          	sd	s1,520(sp)
    80006874:	21213023          	sd	s2,512(sp)
    80006878:	1f313c23          	sd	s3,504(sp)
    8000687c:	1f413823          	sd	s4,496(sp)
    80006880:	1f513423          	sd	s5,488(sp)
    80006884:	1f613023          	sd	s6,480(sp)
    80006888:	1d713c23          	sd	s7,472(sp)
    8000688c:	1d813823          	sd	s8,464(sp)
    80006890:	1d913423          	sd	s9,456(sp)
    80006894:	1da13023          	sd	s10,448(sp)
    80006898:	1bb13c23          	sd	s11,440(sp)
    8000689c:	22010413          	addi	s0,sp,544
    800068a0:	00050913          	mv	s2,a0
    800068a4:	dea43423          	sd	a0,-536(s0)
    800068a8:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800068ac:	ffffc097          	auipc	ra,0xffffc
    800068b0:	aec080e7          	jalr	-1300(ra) # 80002398 <myproc>
    800068b4:	00050493          	mv	s1,a0

  begin_op();
    800068b8:	fffff097          	auipc	ra,0xfffff
    800068bc:	efc080e7          	jalr	-260(ra) # 800057b4 <begin_op>

  if((ip = namei(path)) == 0){
    800068c0:	00090513          	mv	a0,s2
    800068c4:	fffff097          	auipc	ra,0xfffff
    800068c8:	c1c080e7          	jalr	-996(ra) # 800054e0 <namei>
    800068cc:	08050c63          	beqz	a0,80006964 <exec+0x100>
    800068d0:	00050a93          	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800068d4:	ffffe097          	auipc	ra,0xffffe
    800068d8:	150080e7          	jalr	336(ra) # 80004a24 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800068dc:	04000713          	li	a4,64
    800068e0:	00000693          	li	a3,0
    800068e4:	e4840613          	addi	a2,s0,-440
    800068e8:	00000593          	li	a1,0
    800068ec:	000a8513          	mv	a0,s5
    800068f0:	ffffe097          	auipc	ra,0xffffe
    800068f4:	4b8080e7          	jalr	1208(ra) # 80004da8 <readi>
    800068f8:	04000793          	li	a5,64
    800068fc:	00f51a63          	bne	a0,a5,80006910 <exec+0xac>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80006900:	e4842703          	lw	a4,-440(s0)
    80006904:	464c47b7          	lui	a5,0x464c4
    80006908:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000690c:	06f70463          	beq	a4,a5,80006974 <exec+0x110>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80006910:	000a8513          	mv	a0,s5
    80006914:	ffffe097          	auipc	ra,0xffffe
    80006918:	414080e7          	jalr	1044(ra) # 80004d28 <iunlockput>
    end_op();
    8000691c:	fffff097          	auipc	ra,0xfffff
    80006920:	f4c080e7          	jalr	-180(ra) # 80005868 <end_op>
  }
  return -1;
    80006924:	fff00513          	li	a0,-1
}
    80006928:	21813083          	ld	ra,536(sp)
    8000692c:	21013403          	ld	s0,528(sp)
    80006930:	20813483          	ld	s1,520(sp)
    80006934:	20013903          	ld	s2,512(sp)
    80006938:	1f813983          	ld	s3,504(sp)
    8000693c:	1f013a03          	ld	s4,496(sp)
    80006940:	1e813a83          	ld	s5,488(sp)
    80006944:	1e013b03          	ld	s6,480(sp)
    80006948:	1d813b83          	ld	s7,472(sp)
    8000694c:	1d013c03          	ld	s8,464(sp)
    80006950:	1c813c83          	ld	s9,456(sp)
    80006954:	1c013d03          	ld	s10,448(sp)
    80006958:	1b813d83          	ld	s11,440(sp)
    8000695c:	22010113          	addi	sp,sp,544
    80006960:	00008067          	ret
    end_op();
    80006964:	fffff097          	auipc	ra,0xfffff
    80006968:	f04080e7          	jalr	-252(ra) # 80005868 <end_op>
    return -1;
    8000696c:	fff00513          	li	a0,-1
    80006970:	fb9ff06f          	j	80006928 <exec+0xc4>
  if((pagetable = proc_pagetable(p)) == 0)
    80006974:	00048513          	mv	a0,s1
    80006978:	ffffc097          	auipc	ra,0xffffc
    8000697c:	b3c080e7          	jalr	-1220(ra) # 800024b4 <proc_pagetable>
    80006980:	00050b13          	mv	s6,a0
    80006984:	f80506e3          	beqz	a0,80006910 <exec+0xac>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006988:	e6842783          	lw	a5,-408(s0)
    8000698c:	e8045703          	lhu	a4,-384(s0)
    80006990:	12070e63          	beqz	a4,80006acc <exec+0x268>
  sz = 0;
    80006994:	de043c23          	sd	zero,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006998:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000699c:	00001a37          	lui	s4,0x1
    800069a0:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800069a4:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    800069a8:	00001db7          	lui	s11,0x1
    800069ac:	fffffd37          	lui	s10,0xfffff
    800069b0:	08c0006f          	j	80006a3c <exec+0x1d8>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800069b4:	00002517          	auipc	a0,0x2
    800069b8:	ee450513          	addi	a0,a0,-284 # 80008898 <userret+0x7f4>
    800069bc:	ffffa097          	auipc	ra,0xffffa
    800069c0:	d1c080e7          	jalr	-740(ra) # 800006d8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800069c4:	00090713          	mv	a4,s2
    800069c8:	009c86bb          	addw	a3,s9,s1
    800069cc:	00000593          	li	a1,0
    800069d0:	000a8513          	mv	a0,s5
    800069d4:	ffffe097          	auipc	ra,0xffffe
    800069d8:	3d4080e7          	jalr	980(ra) # 80004da8 <readi>
    800069dc:	0005051b          	sext.w	a0,a0
    800069e0:	14a91863          	bne	s2,a0,80006b30 <exec+0x2cc>
  for(i = 0; i < sz; i += PGSIZE){
    800069e4:	009d84bb          	addw	s1,s11,s1
    800069e8:	013d09bb          	addw	s3,s10,s3
    800069ec:	0374fa63          	bgeu	s1,s7,80006a20 <exec+0x1bc>
    pa = walkaddr(pagetable, va + i);
    800069f0:	02049593          	slli	a1,s1,0x20
    800069f4:	0205d593          	srli	a1,a1,0x20
    800069f8:	018585b3          	add	a1,a1,s8
    800069fc:	000b0513          	mv	a0,s6
    80006a00:	ffffb097          	auipc	ra,0xffffb
    80006a04:	c0c080e7          	jalr	-1012(ra) # 8000160c <walkaddr>
    80006a08:	00050613          	mv	a2,a0
    if(pa == 0)
    80006a0c:	fa0504e3          	beqz	a0,800069b4 <exec+0x150>
      n = PGSIZE;
    80006a10:	000a0913          	mv	s2,s4
    if(sz - i < PGSIZE)
    80006a14:	fb49f8e3          	bgeu	s3,s4,800069c4 <exec+0x160>
      n = sz - i;
    80006a18:	00098913          	mv	s2,s3
    80006a1c:	fa9ff06f          	j	800069c4 <exec+0x160>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006a20:	e0843783          	ld	a5,-504(s0)
    80006a24:	0017869b          	addiw	a3,a5,1
    80006a28:	e0d43423          	sd	a3,-504(s0)
    80006a2c:	e0043783          	ld	a5,-512(s0)
    80006a30:	0387879b          	addiw	a5,a5,56
    80006a34:	e8045703          	lhu	a4,-384(s0)
    80006a38:	08e6dc63          	bge	a3,a4,80006ad0 <exec+0x26c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80006a3c:	0007879b          	sext.w	a5,a5
    80006a40:	e0f43023          	sd	a5,-512(s0)
    80006a44:	03800713          	li	a4,56
    80006a48:	00078693          	mv	a3,a5
    80006a4c:	e1040613          	addi	a2,s0,-496
    80006a50:	00000593          	li	a1,0
    80006a54:	000a8513          	mv	a0,s5
    80006a58:	ffffe097          	auipc	ra,0xffffe
    80006a5c:	350080e7          	jalr	848(ra) # 80004da8 <readi>
    80006a60:	03800793          	li	a5,56
    80006a64:	0cf51663          	bne	a0,a5,80006b30 <exec+0x2cc>
    if(ph.type != ELF_PROG_LOAD)
    80006a68:	e1042783          	lw	a5,-496(s0)
    80006a6c:	00100713          	li	a4,1
    80006a70:	fae798e3          	bne	a5,a4,80006a20 <exec+0x1bc>
    if(ph.memsz < ph.filesz)
    80006a74:	e3843603          	ld	a2,-456(s0)
    80006a78:	e3043783          	ld	a5,-464(s0)
    80006a7c:	0af66a63          	bltu	a2,a5,80006b30 <exec+0x2cc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80006a80:	e2043783          	ld	a5,-480(s0)
    80006a84:	00f60633          	add	a2,a2,a5
    80006a88:	0af66463          	bltu	a2,a5,80006b30 <exec+0x2cc>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80006a8c:	df843583          	ld	a1,-520(s0)
    80006a90:	000b0513          	mv	a0,s6
    80006a94:	ffffb097          	auipc	ra,0xffffb
    80006a98:	164080e7          	jalr	356(ra) # 80001bf8 <uvmalloc>
    80006a9c:	dea43c23          	sd	a0,-520(s0)
    80006aa0:	08050863          	beqz	a0,80006b30 <exec+0x2cc>
    if(ph.vaddr % PGSIZE != 0)
    80006aa4:	e2043c03          	ld	s8,-480(s0)
    80006aa8:	de043783          	ld	a5,-544(s0)
    80006aac:	00fc77b3          	and	a5,s8,a5
    80006ab0:	08079063          	bnez	a5,80006b30 <exec+0x2cc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80006ab4:	e1842c83          	lw	s9,-488(s0)
    80006ab8:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80006abc:	f60b82e3          	beqz	s7,80006a20 <exec+0x1bc>
    80006ac0:	000b8993          	mv	s3,s7
    80006ac4:	00000493          	li	s1,0
    80006ac8:	f29ff06f          	j	800069f0 <exec+0x18c>
  sz = 0;
    80006acc:	de043c23          	sd	zero,-520(s0)
  iunlockput(ip);
    80006ad0:	000a8513          	mv	a0,s5
    80006ad4:	ffffe097          	auipc	ra,0xffffe
    80006ad8:	254080e7          	jalr	596(ra) # 80004d28 <iunlockput>
  end_op();
    80006adc:	fffff097          	auipc	ra,0xfffff
    80006ae0:	d8c080e7          	jalr	-628(ra) # 80005868 <end_op>
  p = myproc();
    80006ae4:	ffffc097          	auipc	ra,0xffffc
    80006ae8:	8b4080e7          	jalr	-1868(ra) # 80002398 <myproc>
    80006aec:	00050b93          	mv	s7,a0
  uint64 oldsz = p->sz;
    80006af0:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80006af4:	000015b7          	lui	a1,0x1
    80006af8:	fff58593          	addi	a1,a1,-1 # fff <_entry-0x7ffff001>
    80006afc:	df843783          	ld	a5,-520(s0)
    80006b00:	00b785b3          	add	a1,a5,a1
    80006b04:	fffff7b7          	lui	a5,0xfffff
    80006b08:	00f5f5b3          	and	a1,a1,a5
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80006b0c:	00002637          	lui	a2,0x2
    80006b10:	00c58633          	add	a2,a1,a2
    80006b14:	000b0513          	mv	a0,s6
    80006b18:	ffffb097          	auipc	ra,0xffffb
    80006b1c:	0e0080e7          	jalr	224(ra) # 80001bf8 <uvmalloc>
    80006b20:	dea43c23          	sd	a0,-520(s0)
  ip = 0;
    80006b24:	00000a93          	li	s5,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80006b28:	00050913          	mv	s2,a0
    80006b2c:	02051063          	bnez	a0,80006b4c <exec+0x2e8>
    proc_freepagetable(pagetable, sz);
    80006b30:	df843583          	ld	a1,-520(s0)
    80006b34:	000b0513          	mv	a0,s6
    80006b38:	ffffc097          	auipc	ra,0xffffc
    80006b3c:	af0080e7          	jalr	-1296(ra) # 80002628 <proc_freepagetable>
  if(ip){
    80006b40:	dc0a98e3          	bnez	s5,80006910 <exec+0xac>
  return -1;
    80006b44:	fff00513          	li	a0,-1
    80006b48:	de1ff06f          	j	80006928 <exec+0xc4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80006b4c:	ffffe5b7          	lui	a1,0xffffe
    80006b50:	00b505b3          	add	a1,a0,a1
    80006b54:	000b0513          	mv	a0,s6
    80006b58:	ffffb097          	auipc	ra,0xffffb
    80006b5c:	33c080e7          	jalr	828(ra) # 80001e94 <uvmclear>
  stackbase = sp - PGSIZE;
    80006b60:	fffffc37          	lui	s8,0xfffff
    80006b64:	01890c33          	add	s8,s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80006b68:	df043783          	ld	a5,-528(s0)
    80006b6c:	0007b503          	ld	a0,0(a5) # fffffffffffff000 <end+0xffffffff7ffdc50c>
    80006b70:	08050063          	beqz	a0,80006bf0 <exec+0x38c>
    80006b74:	e8840993          	addi	s3,s0,-376
    80006b78:	f8840a93          	addi	s5,s0,-120
    80006b7c:	00000493          	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80006b80:	ffffa097          	auipc	ra,0xffffa
    80006b84:	688080e7          	jalr	1672(ra) # 80001208 <strlen>
    80006b88:	0015079b          	addiw	a5,a0,1
    80006b8c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80006b90:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80006b94:	13896463          	bltu	s2,s8,80006cbc <exec+0x458>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80006b98:	df043d03          	ld	s10,-528(s0)
    80006b9c:	000d3a03          	ld	s4,0(s10) # fffffffffffff000 <end+0xffffffff7ffdc50c>
    80006ba0:	000a0513          	mv	a0,s4
    80006ba4:	ffffa097          	auipc	ra,0xffffa
    80006ba8:	664080e7          	jalr	1636(ra) # 80001208 <strlen>
    80006bac:	0015069b          	addiw	a3,a0,1
    80006bb0:	000a0613          	mv	a2,s4
    80006bb4:	00090593          	mv	a1,s2
    80006bb8:	000b0513          	mv	a0,s6
    80006bbc:	ffffb097          	auipc	ra,0xffffb
    80006bc0:	324080e7          	jalr	804(ra) # 80001ee0 <copyout>
    80006bc4:	10054063          	bltz	a0,80006cc4 <exec+0x460>
    ustack[argc] = sp;
    80006bc8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80006bcc:	00148493          	addi	s1,s1,1
    80006bd0:	008d0793          	addi	a5,s10,8
    80006bd4:	def43823          	sd	a5,-528(s0)
    80006bd8:	008d3503          	ld	a0,8(s10)
    80006bdc:	00050e63          	beqz	a0,80006bf8 <exec+0x394>
    if(argc >= MAXARG)
    80006be0:	00898993          	addi	s3,s3,8
    80006be4:	f93a9ee3          	bne	s5,s3,80006b80 <exec+0x31c>
  ip = 0;
    80006be8:	00000a93          	li	s5,0
    80006bec:	f45ff06f          	j	80006b30 <exec+0x2cc>
  sp = sz;
    80006bf0:	df843903          	ld	s2,-520(s0)
  for(argc = 0; argv[argc]; argc++) {
    80006bf4:	00000493          	li	s1,0
  ustack[argc] = 0;
    80006bf8:	00349793          	slli	a5,s1,0x3
    80006bfc:	f9078793          	addi	a5,a5,-112
    80006c00:	008787b3          	add	a5,a5,s0
    80006c04:	ee07bc23          	sd	zero,-264(a5)
  sp -= (argc+1) * sizeof(uint64);
    80006c08:	00148693          	addi	a3,s1,1
    80006c0c:	00369693          	slli	a3,a3,0x3
    80006c10:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80006c14:	ff097913          	andi	s2,s2,-16
  ip = 0;
    80006c18:	00000a93          	li	s5,0
  if(sp < stackbase)
    80006c1c:	f1896ae3          	bltu	s2,s8,80006b30 <exec+0x2cc>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80006c20:	e8840613          	addi	a2,s0,-376
    80006c24:	00090593          	mv	a1,s2
    80006c28:	000b0513          	mv	a0,s6
    80006c2c:	ffffb097          	auipc	ra,0xffffb
    80006c30:	2b4080e7          	jalr	692(ra) # 80001ee0 <copyout>
    80006c34:	08054c63          	bltz	a0,80006ccc <exec+0x468>
  p->tf->a1 = sp;
    80006c38:	058bb783          	ld	a5,88(s7)
    80006c3c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80006c40:	de843783          	ld	a5,-536(s0)
    80006c44:	0007c703          	lbu	a4,0(a5)
    80006c48:	02070463          	beqz	a4,80006c70 <exec+0x40c>
    80006c4c:	00178793          	addi	a5,a5,1
    if(*s == '/')
    80006c50:	02f00693          	li	a3,47
    80006c54:	0140006f          	j	80006c68 <exec+0x404>
      last = s+1;
    80006c58:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80006c5c:	00178793          	addi	a5,a5,1
    80006c60:	fff7c703          	lbu	a4,-1(a5)
    80006c64:	00070663          	beqz	a4,80006c70 <exec+0x40c>
    if(*s == '/')
    80006c68:	fed71ae3          	bne	a4,a3,80006c5c <exec+0x3f8>
    80006c6c:	fedff06f          	j	80006c58 <exec+0x3f4>
  safestrcpy(p->name, last, sizeof(p->name));
    80006c70:	01000613          	li	a2,16
    80006c74:	de843583          	ld	a1,-536(s0)
    80006c78:	158b8513          	addi	a0,s7,344
    80006c7c:	ffffa097          	auipc	ra,0xffffa
    80006c80:	540080e7          	jalr	1344(ra) # 800011bc <safestrcpy>
  oldpagetable = p->pagetable;
    80006c84:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80006c88:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80006c8c:	df843783          	ld	a5,-520(s0)
    80006c90:	04fbb423          	sd	a5,72(s7)
  p->tf->epc = elf.entry;  // initial program counter = main
    80006c94:	058bb783          	ld	a5,88(s7)
    80006c98:	e6043703          	ld	a4,-416(s0)
    80006c9c:	00e7bc23          	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    80006ca0:	058bb783          	ld	a5,88(s7)
    80006ca4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80006ca8:	000c8593          	mv	a1,s9
    80006cac:	ffffc097          	auipc	ra,0xffffc
    80006cb0:	97c080e7          	jalr	-1668(ra) # 80002628 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80006cb4:	0004851b          	sext.w	a0,s1
    80006cb8:	c71ff06f          	j	80006928 <exec+0xc4>
  ip = 0;
    80006cbc:	00000a93          	li	s5,0
    80006cc0:	e71ff06f          	j	80006b30 <exec+0x2cc>
    80006cc4:	00000a93          	li	s5,0
    80006cc8:	e69ff06f          	j	80006b30 <exec+0x2cc>
    80006ccc:	00000a93          	li	s5,0
    80006cd0:	e61ff06f          	j	80006b30 <exec+0x2cc>

0000000080006cd4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80006cd4:	fd010113          	addi	sp,sp,-48
    80006cd8:	02113423          	sd	ra,40(sp)
    80006cdc:	02813023          	sd	s0,32(sp)
    80006ce0:	00913c23          	sd	s1,24(sp)
    80006ce4:	01213823          	sd	s2,16(sp)
    80006ce8:	03010413          	addi	s0,sp,48
    80006cec:	00058913          	mv	s2,a1
    80006cf0:	00060493          	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80006cf4:	fdc40593          	addi	a1,s0,-36
    80006cf8:	ffffd097          	auipc	ra,0xffffd
    80006cfc:	d54080e7          	jalr	-684(ra) # 80003a4c <argint>
    80006d00:	04054e63          	bltz	a0,80006d5c <argfd+0x88>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80006d04:	fdc42703          	lw	a4,-36(s0)
    80006d08:	00f00793          	li	a5,15
    80006d0c:	04e7ec63          	bltu	a5,a4,80006d64 <argfd+0x90>
    80006d10:	ffffb097          	auipc	ra,0xffffb
    80006d14:	688080e7          	jalr	1672(ra) # 80002398 <myproc>
    80006d18:	fdc42703          	lw	a4,-36(s0)
    80006d1c:	01a70793          	addi	a5,a4,26
    80006d20:	00379793          	slli	a5,a5,0x3
    80006d24:	00f50533          	add	a0,a0,a5
    80006d28:	00053783          	ld	a5,0(a0)
    80006d2c:	04078063          	beqz	a5,80006d6c <argfd+0x98>
    return -1;
  if(pfd)
    80006d30:	00090463          	beqz	s2,80006d38 <argfd+0x64>
    *pfd = fd;
    80006d34:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80006d38:	00000513          	li	a0,0
  if(pf)
    80006d3c:	00048463          	beqz	s1,80006d44 <argfd+0x70>
    *pf = f;
    80006d40:	00f4b023          	sd	a5,0(s1)
}
    80006d44:	02813083          	ld	ra,40(sp)
    80006d48:	02013403          	ld	s0,32(sp)
    80006d4c:	01813483          	ld	s1,24(sp)
    80006d50:	01013903          	ld	s2,16(sp)
    80006d54:	03010113          	addi	sp,sp,48
    80006d58:	00008067          	ret
    return -1;
    80006d5c:	fff00513          	li	a0,-1
    80006d60:	fe5ff06f          	j	80006d44 <argfd+0x70>
    return -1;
    80006d64:	fff00513          	li	a0,-1
    80006d68:	fddff06f          	j	80006d44 <argfd+0x70>
    80006d6c:	fff00513          	li	a0,-1
    80006d70:	fd5ff06f          	j	80006d44 <argfd+0x70>

0000000080006d74 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80006d74:	fe010113          	addi	sp,sp,-32
    80006d78:	00113c23          	sd	ra,24(sp)
    80006d7c:	00813823          	sd	s0,16(sp)
    80006d80:	00913423          	sd	s1,8(sp)
    80006d84:	02010413          	addi	s0,sp,32
    80006d88:	00050493          	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80006d8c:	ffffb097          	auipc	ra,0xffffb
    80006d90:	60c080e7          	jalr	1548(ra) # 80002398 <myproc>
    80006d94:	00050613          	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80006d98:	0d050793          	addi	a5,a0,208
    80006d9c:	00000513          	li	a0,0
    80006da0:	01000693          	li	a3,16
    if(p->ofile[fd] == 0){
    80006da4:	0007b703          	ld	a4,0(a5)
    80006da8:	02070463          	beqz	a4,80006dd0 <fdalloc+0x5c>
  for(fd = 0; fd < NOFILE; fd++){
    80006dac:	0015051b          	addiw	a0,a0,1
    80006db0:	00878793          	addi	a5,a5,8
    80006db4:	fed518e3          	bne	a0,a3,80006da4 <fdalloc+0x30>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80006db8:	fff00513          	li	a0,-1
}
    80006dbc:	01813083          	ld	ra,24(sp)
    80006dc0:	01013403          	ld	s0,16(sp)
    80006dc4:	00813483          	ld	s1,8(sp)
    80006dc8:	02010113          	addi	sp,sp,32
    80006dcc:	00008067          	ret
      p->ofile[fd] = f;
    80006dd0:	01a50793          	addi	a5,a0,26
    80006dd4:	00379793          	slli	a5,a5,0x3
    80006dd8:	00f60633          	add	a2,a2,a5
    80006ddc:	00963023          	sd	s1,0(a2) # 2000 <_entry-0x7fffe000>
      return fd;
    80006de0:	fddff06f          	j	80006dbc <fdalloc+0x48>

0000000080006de4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80006de4:	fb010113          	addi	sp,sp,-80
    80006de8:	04113423          	sd	ra,72(sp)
    80006dec:	04813023          	sd	s0,64(sp)
    80006df0:	02913c23          	sd	s1,56(sp)
    80006df4:	03213823          	sd	s2,48(sp)
    80006df8:	03313423          	sd	s3,40(sp)
    80006dfc:	03413023          	sd	s4,32(sp)
    80006e00:	01513c23          	sd	s5,24(sp)
    80006e04:	05010413          	addi	s0,sp,80
    80006e08:	00058993          	mv	s3,a1
    80006e0c:	00060a93          	mv	s5,a2
    80006e10:	00068a13          	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80006e14:	fb040593          	addi	a1,s0,-80
    80006e18:	ffffe097          	auipc	ra,0xffffe
    80006e1c:	6f8080e7          	jalr	1784(ra) # 80005510 <nameiparent>
    80006e20:	00050913          	mv	s2,a0
    80006e24:	18050663          	beqz	a0,80006fb0 <create+0x1cc>
    return 0;

  ilock(dp);
    80006e28:	ffffe097          	auipc	ra,0xffffe
    80006e2c:	bfc080e7          	jalr	-1028(ra) # 80004a24 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80006e30:	00000613          	li	a2,0
    80006e34:	fb040593          	addi	a1,s0,-80
    80006e38:	00090513          	mv	a0,s2
    80006e3c:	ffffe097          	auipc	ra,0xffffe
    80006e40:	294080e7          	jalr	660(ra) # 800050d0 <dirlookup>
    80006e44:	00050493          	mv	s1,a0
    80006e48:	06050e63          	beqz	a0,80006ec4 <create+0xe0>
    iunlockput(dp);
    80006e4c:	00090513          	mv	a0,s2
    80006e50:	ffffe097          	auipc	ra,0xffffe
    80006e54:	ed8080e7          	jalr	-296(ra) # 80004d28 <iunlockput>
    ilock(ip);
    80006e58:	00048513          	mv	a0,s1
    80006e5c:	ffffe097          	auipc	ra,0xffffe
    80006e60:	bc8080e7          	jalr	-1080(ra) # 80004a24 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80006e64:	0009899b          	sext.w	s3,s3
    80006e68:	00200793          	li	a5,2
    80006e6c:	04f99263          	bne	s3,a5,80006eb0 <create+0xcc>
    80006e70:	0444d783          	lhu	a5,68(s1)
    80006e74:	ffe7879b          	addiw	a5,a5,-2
    80006e78:	03079793          	slli	a5,a5,0x30
    80006e7c:	0307d793          	srli	a5,a5,0x30
    80006e80:	00100713          	li	a4,1
    80006e84:	02f76663          	bltu	a4,a5,80006eb0 <create+0xcc>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80006e88:	00048513          	mv	a0,s1
    80006e8c:	04813083          	ld	ra,72(sp)
    80006e90:	04013403          	ld	s0,64(sp)
    80006e94:	03813483          	ld	s1,56(sp)
    80006e98:	03013903          	ld	s2,48(sp)
    80006e9c:	02813983          	ld	s3,40(sp)
    80006ea0:	02013a03          	ld	s4,32(sp)
    80006ea4:	01813a83          	ld	s5,24(sp)
    80006ea8:	05010113          	addi	sp,sp,80
    80006eac:	00008067          	ret
    iunlockput(ip);
    80006eb0:	00048513          	mv	a0,s1
    80006eb4:	ffffe097          	auipc	ra,0xffffe
    80006eb8:	e74080e7          	jalr	-396(ra) # 80004d28 <iunlockput>
    return 0;
    80006ebc:	00000493          	li	s1,0
    80006ec0:	fc9ff06f          	j	80006e88 <create+0xa4>
  if((ip = ialloc(dp->dev, type)) == 0)
    80006ec4:	00098593          	mv	a1,s3
    80006ec8:	00092503          	lw	a0,0(s2)
    80006ecc:	ffffe097          	auipc	ra,0xffffe
    80006ed0:	920080e7          	jalr	-1760(ra) # 800047ec <ialloc>
    80006ed4:	00050493          	mv	s1,a0
    80006ed8:	04050c63          	beqz	a0,80006f30 <create+0x14c>
  ilock(ip);
    80006edc:	ffffe097          	auipc	ra,0xffffe
    80006ee0:	b48080e7          	jalr	-1208(ra) # 80004a24 <ilock>
  ip->major = major;
    80006ee4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80006ee8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80006eec:	00100a13          	li	s4,1
    80006ef0:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80006ef4:	00048513          	mv	a0,s1
    80006ef8:	ffffe097          	auipc	ra,0xffffe
    80006efc:	a10080e7          	jalr	-1520(ra) # 80004908 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80006f00:	0009899b          	sext.w	s3,s3
    80006f04:	03498e63          	beq	s3,s4,80006f40 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80006f08:	0044a603          	lw	a2,4(s1)
    80006f0c:	fb040593          	addi	a1,s0,-80
    80006f10:	00090513          	mv	a0,s2
    80006f14:	ffffe097          	auipc	ra,0xffffe
    80006f18:	4b8080e7          	jalr	1208(ra) # 800053cc <dirlink>
    80006f1c:	08054263          	bltz	a0,80006fa0 <create+0x1bc>
  iunlockput(dp);
    80006f20:	00090513          	mv	a0,s2
    80006f24:	ffffe097          	auipc	ra,0xffffe
    80006f28:	e04080e7          	jalr	-508(ra) # 80004d28 <iunlockput>
  return ip;
    80006f2c:	f5dff06f          	j	80006e88 <create+0xa4>
    panic("create: ialloc");
    80006f30:	00002517          	auipc	a0,0x2
    80006f34:	98850513          	addi	a0,a0,-1656 # 800088b8 <userret+0x814>
    80006f38:	ffff9097          	auipc	ra,0xffff9
    80006f3c:	7a0080e7          	jalr	1952(ra) # 800006d8 <panic>
    dp->nlink++;  // for ".."
    80006f40:	04a95783          	lhu	a5,74(s2)
    80006f44:	0017879b          	addiw	a5,a5,1
    80006f48:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80006f4c:	00090513          	mv	a0,s2
    80006f50:	ffffe097          	auipc	ra,0xffffe
    80006f54:	9b8080e7          	jalr	-1608(ra) # 80004908 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80006f58:	0044a603          	lw	a2,4(s1)
    80006f5c:	00002597          	auipc	a1,0x2
    80006f60:	96c58593          	addi	a1,a1,-1684 # 800088c8 <userret+0x824>
    80006f64:	00048513          	mv	a0,s1
    80006f68:	ffffe097          	auipc	ra,0xffffe
    80006f6c:	464080e7          	jalr	1124(ra) # 800053cc <dirlink>
    80006f70:	02054063          	bltz	a0,80006f90 <create+0x1ac>
    80006f74:	00492603          	lw	a2,4(s2)
    80006f78:	00002597          	auipc	a1,0x2
    80006f7c:	95858593          	addi	a1,a1,-1704 # 800088d0 <userret+0x82c>
    80006f80:	00048513          	mv	a0,s1
    80006f84:	ffffe097          	auipc	ra,0xffffe
    80006f88:	448080e7          	jalr	1096(ra) # 800053cc <dirlink>
    80006f8c:	f6055ee3          	bgez	a0,80006f08 <create+0x124>
      panic("create dots");
    80006f90:	00002517          	auipc	a0,0x2
    80006f94:	94850513          	addi	a0,a0,-1720 # 800088d8 <userret+0x834>
    80006f98:	ffff9097          	auipc	ra,0xffff9
    80006f9c:	740080e7          	jalr	1856(ra) # 800006d8 <panic>
    panic("create: dirlink");
    80006fa0:	00002517          	auipc	a0,0x2
    80006fa4:	94850513          	addi	a0,a0,-1720 # 800088e8 <userret+0x844>
    80006fa8:	ffff9097          	auipc	ra,0xffff9
    80006fac:	730080e7          	jalr	1840(ra) # 800006d8 <panic>
    return 0;
    80006fb0:	00050493          	mv	s1,a0
    80006fb4:	ed5ff06f          	j	80006e88 <create+0xa4>

0000000080006fb8 <sys_dup>:
{
    80006fb8:	fd010113          	addi	sp,sp,-48
    80006fbc:	02113423          	sd	ra,40(sp)
    80006fc0:	02813023          	sd	s0,32(sp)
    80006fc4:	00913c23          	sd	s1,24(sp)
    80006fc8:	01213823          	sd	s2,16(sp)
    80006fcc:	03010413          	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80006fd0:	fd840613          	addi	a2,s0,-40
    80006fd4:	00000593          	li	a1,0
    80006fd8:	00000513          	li	a0,0
    80006fdc:	00000097          	auipc	ra,0x0
    80006fe0:	cf8080e7          	jalr	-776(ra) # 80006cd4 <argfd>
    return -1;
    80006fe4:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80006fe8:	02054863          	bltz	a0,80007018 <sys_dup+0x60>
  if((fd=fdalloc(f)) < 0)
    80006fec:	fd843903          	ld	s2,-40(s0)
    80006ff0:	00090513          	mv	a0,s2
    80006ff4:	00000097          	auipc	ra,0x0
    80006ff8:	d80080e7          	jalr	-640(ra) # 80006d74 <fdalloc>
    80006ffc:	00050493          	mv	s1,a0
    return -1;
    80007000:	fff00793          	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80007004:	00054a63          	bltz	a0,80007018 <sys_dup+0x60>
  filedup(f);
    80007008:	00090513          	mv	a0,s2
    8000700c:	fffff097          	auipc	ra,0xfffff
    80007010:	dc8080e7          	jalr	-568(ra) # 80005dd4 <filedup>
  return fd;
    80007014:	00048793          	mv	a5,s1
}
    80007018:	00078513          	mv	a0,a5
    8000701c:	02813083          	ld	ra,40(sp)
    80007020:	02013403          	ld	s0,32(sp)
    80007024:	01813483          	ld	s1,24(sp)
    80007028:	01013903          	ld	s2,16(sp)
    8000702c:	03010113          	addi	sp,sp,48
    80007030:	00008067          	ret

0000000080007034 <sys_read>:
{
    80007034:	fd010113          	addi	sp,sp,-48
    80007038:	02113423          	sd	ra,40(sp)
    8000703c:	02813023          	sd	s0,32(sp)
    80007040:	03010413          	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80007044:	fe840613          	addi	a2,s0,-24
    80007048:	00000593          	li	a1,0
    8000704c:	00000513          	li	a0,0
    80007050:	00000097          	auipc	ra,0x0
    80007054:	c84080e7          	jalr	-892(ra) # 80006cd4 <argfd>
    return -1;
    80007058:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000705c:	04054663          	bltz	a0,800070a8 <sys_read+0x74>
    80007060:	fe440593          	addi	a1,s0,-28
    80007064:	00200513          	li	a0,2
    80007068:	ffffd097          	auipc	ra,0xffffd
    8000706c:	9e4080e7          	jalr	-1564(ra) # 80003a4c <argint>
    return -1;
    80007070:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80007074:	02054a63          	bltz	a0,800070a8 <sys_read+0x74>
    80007078:	fd840593          	addi	a1,s0,-40
    8000707c:	00100513          	li	a0,1
    80007080:	ffffd097          	auipc	ra,0xffffd
    80007084:	a08080e7          	jalr	-1528(ra) # 80003a88 <argaddr>
    return -1;
    80007088:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000708c:	00054e63          	bltz	a0,800070a8 <sys_read+0x74>
  return fileread(f, p, n);
    80007090:	fe442603          	lw	a2,-28(s0)
    80007094:	fd843583          	ld	a1,-40(s0)
    80007098:	fe843503          	ld	a0,-24(s0)
    8000709c:	fffff097          	auipc	ra,0xfffff
    800070a0:	f54080e7          	jalr	-172(ra) # 80005ff0 <fileread>
    800070a4:	00050793          	mv	a5,a0
}
    800070a8:	00078513          	mv	a0,a5
    800070ac:	02813083          	ld	ra,40(sp)
    800070b0:	02013403          	ld	s0,32(sp)
    800070b4:	03010113          	addi	sp,sp,48
    800070b8:	00008067          	ret

00000000800070bc <sys_write>:
{
    800070bc:	fd010113          	addi	sp,sp,-48
    800070c0:	02113423          	sd	ra,40(sp)
    800070c4:	02813023          	sd	s0,32(sp)
    800070c8:	03010413          	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800070cc:	fe840613          	addi	a2,s0,-24
    800070d0:	00000593          	li	a1,0
    800070d4:	00000513          	li	a0,0
    800070d8:	00000097          	auipc	ra,0x0
    800070dc:	bfc080e7          	jalr	-1028(ra) # 80006cd4 <argfd>
    return -1;
    800070e0:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800070e4:	04054663          	bltz	a0,80007130 <sys_write+0x74>
    800070e8:	fe440593          	addi	a1,s0,-28
    800070ec:	00200513          	li	a0,2
    800070f0:	ffffd097          	auipc	ra,0xffffd
    800070f4:	95c080e7          	jalr	-1700(ra) # 80003a4c <argint>
    return -1;
    800070f8:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800070fc:	02054a63          	bltz	a0,80007130 <sys_write+0x74>
    80007100:	fd840593          	addi	a1,s0,-40
    80007104:	00100513          	li	a0,1
    80007108:	ffffd097          	auipc	ra,0xffffd
    8000710c:	980080e7          	jalr	-1664(ra) # 80003a88 <argaddr>
    return -1;
    80007110:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80007114:	00054e63          	bltz	a0,80007130 <sys_write+0x74>
  return filewrite(f, p, n);
    80007118:	fe442603          	lw	a2,-28(s0)
    8000711c:	fd843583          	ld	a1,-40(s0)
    80007120:	fe843503          	ld	a0,-24(s0)
    80007124:	fffff097          	auipc	ra,0xfffff
    80007128:	ff8080e7          	jalr	-8(ra) # 8000611c <filewrite>
    8000712c:	00050793          	mv	a5,a0
}
    80007130:	00078513          	mv	a0,a5
    80007134:	02813083          	ld	ra,40(sp)
    80007138:	02013403          	ld	s0,32(sp)
    8000713c:	03010113          	addi	sp,sp,48
    80007140:	00008067          	ret

0000000080007144 <sys_close>:
{
    80007144:	fe010113          	addi	sp,sp,-32
    80007148:	00113c23          	sd	ra,24(sp)
    8000714c:	00813823          	sd	s0,16(sp)
    80007150:	02010413          	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80007154:	fe040613          	addi	a2,s0,-32
    80007158:	fec40593          	addi	a1,s0,-20
    8000715c:	00000513          	li	a0,0
    80007160:	00000097          	auipc	ra,0x0
    80007164:	b74080e7          	jalr	-1164(ra) # 80006cd4 <argfd>
    return -1;
    80007168:	fff00793          	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000716c:	02054863          	bltz	a0,8000719c <sys_close+0x58>
  myproc()->ofile[fd] = 0;
    80007170:	ffffb097          	auipc	ra,0xffffb
    80007174:	228080e7          	jalr	552(ra) # 80002398 <myproc>
    80007178:	fec42783          	lw	a5,-20(s0)
    8000717c:	01a78793          	addi	a5,a5,26
    80007180:	00379793          	slli	a5,a5,0x3
    80007184:	00f50533          	add	a0,a0,a5
    80007188:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000718c:	fe043503          	ld	a0,-32(s0)
    80007190:	fffff097          	auipc	ra,0xfffff
    80007194:	cb4080e7          	jalr	-844(ra) # 80005e44 <fileclose>
  return 0;
    80007198:	00000793          	li	a5,0
}
    8000719c:	00078513          	mv	a0,a5
    800071a0:	01813083          	ld	ra,24(sp)
    800071a4:	01013403          	ld	s0,16(sp)
    800071a8:	02010113          	addi	sp,sp,32
    800071ac:	00008067          	ret

00000000800071b0 <sys_fstat>:
{
    800071b0:	fe010113          	addi	sp,sp,-32
    800071b4:	00113c23          	sd	ra,24(sp)
    800071b8:	00813823          	sd	s0,16(sp)
    800071bc:	02010413          	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800071c0:	fe840613          	addi	a2,s0,-24
    800071c4:	00000593          	li	a1,0
    800071c8:	00000513          	li	a0,0
    800071cc:	00000097          	auipc	ra,0x0
    800071d0:	b08080e7          	jalr	-1272(ra) # 80006cd4 <argfd>
    return -1;
    800071d4:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800071d8:	02054863          	bltz	a0,80007208 <sys_fstat+0x58>
    800071dc:	fe040593          	addi	a1,s0,-32
    800071e0:	00100513          	li	a0,1
    800071e4:	ffffd097          	auipc	ra,0xffffd
    800071e8:	8a4080e7          	jalr	-1884(ra) # 80003a88 <argaddr>
    return -1;
    800071ec:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800071f0:	00054c63          	bltz	a0,80007208 <sys_fstat+0x58>
  return filestat(f, st);
    800071f4:	fe043583          	ld	a1,-32(s0)
    800071f8:	fe843503          	ld	a0,-24(s0)
    800071fc:	fffff097          	auipc	ra,0xfffff
    80007200:	d4c080e7          	jalr	-692(ra) # 80005f48 <filestat>
    80007204:	00050793          	mv	a5,a0
}
    80007208:	00078513          	mv	a0,a5
    8000720c:	01813083          	ld	ra,24(sp)
    80007210:	01013403          	ld	s0,16(sp)
    80007214:	02010113          	addi	sp,sp,32
    80007218:	00008067          	ret

000000008000721c <sys_link>:
{
    8000721c:	ed010113          	addi	sp,sp,-304
    80007220:	12113423          	sd	ra,296(sp)
    80007224:	12813023          	sd	s0,288(sp)
    80007228:	10913c23          	sd	s1,280(sp)
    8000722c:	11213823          	sd	s2,272(sp)
    80007230:	13010413          	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80007234:	08000613          	li	a2,128
    80007238:	ed040593          	addi	a1,s0,-304
    8000723c:	00000513          	li	a0,0
    80007240:	ffffd097          	auipc	ra,0xffffd
    80007244:	884080e7          	jalr	-1916(ra) # 80003ac4 <argstr>
    return -1;
    80007248:	fff00793          	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000724c:	14054a63          	bltz	a0,800073a0 <sys_link+0x184>
    80007250:	08000613          	li	a2,128
    80007254:	f5040593          	addi	a1,s0,-176
    80007258:	00100513          	li	a0,1
    8000725c:	ffffd097          	auipc	ra,0xffffd
    80007260:	868080e7          	jalr	-1944(ra) # 80003ac4 <argstr>
    return -1;
    80007264:	fff00793          	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80007268:	12054c63          	bltz	a0,800073a0 <sys_link+0x184>
  begin_op();
    8000726c:	ffffe097          	auipc	ra,0xffffe
    80007270:	548080e7          	jalr	1352(ra) # 800057b4 <begin_op>
  if((ip = namei(old)) == 0){
    80007274:	ed040513          	addi	a0,s0,-304
    80007278:	ffffe097          	auipc	ra,0xffffe
    8000727c:	268080e7          	jalr	616(ra) # 800054e0 <namei>
    80007280:	00050493          	mv	s1,a0
    80007284:	0a050463          	beqz	a0,8000732c <sys_link+0x110>
  ilock(ip);
    80007288:	ffffd097          	auipc	ra,0xffffd
    8000728c:	79c080e7          	jalr	1948(ra) # 80004a24 <ilock>
  if(ip->type == T_DIR){
    80007290:	04449703          	lh	a4,68(s1)
    80007294:	00100793          	li	a5,1
    80007298:	0af70263          	beq	a4,a5,8000733c <sys_link+0x120>
  ip->nlink++;
    8000729c:	04a4d783          	lhu	a5,74(s1)
    800072a0:	0017879b          	addiw	a5,a5,1
    800072a4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800072a8:	00048513          	mv	a0,s1
    800072ac:	ffffd097          	auipc	ra,0xffffd
    800072b0:	65c080e7          	jalr	1628(ra) # 80004908 <iupdate>
  iunlock(ip);
    800072b4:	00048513          	mv	a0,s1
    800072b8:	ffffe097          	auipc	ra,0xffffe
    800072bc:	870080e7          	jalr	-1936(ra) # 80004b28 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800072c0:	fd040593          	addi	a1,s0,-48
    800072c4:	f5040513          	addi	a0,s0,-176
    800072c8:	ffffe097          	auipc	ra,0xffffe
    800072cc:	248080e7          	jalr	584(ra) # 80005510 <nameiparent>
    800072d0:	00050913          	mv	s2,a0
    800072d4:	08050863          	beqz	a0,80007364 <sys_link+0x148>
  ilock(dp);
    800072d8:	ffffd097          	auipc	ra,0xffffd
    800072dc:	74c080e7          	jalr	1868(ra) # 80004a24 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800072e0:	00092703          	lw	a4,0(s2)
    800072e4:	0004a783          	lw	a5,0(s1)
    800072e8:	06f71863          	bne	a4,a5,80007358 <sys_link+0x13c>
    800072ec:	0044a603          	lw	a2,4(s1)
    800072f0:	fd040593          	addi	a1,s0,-48
    800072f4:	00090513          	mv	a0,s2
    800072f8:	ffffe097          	auipc	ra,0xffffe
    800072fc:	0d4080e7          	jalr	212(ra) # 800053cc <dirlink>
    80007300:	04054c63          	bltz	a0,80007358 <sys_link+0x13c>
  iunlockput(dp);
    80007304:	00090513          	mv	a0,s2
    80007308:	ffffe097          	auipc	ra,0xffffe
    8000730c:	a20080e7          	jalr	-1504(ra) # 80004d28 <iunlockput>
  iput(ip);
    80007310:	00048513          	mv	a0,s1
    80007314:	ffffe097          	auipc	ra,0xffffe
    80007318:	884080e7          	jalr	-1916(ra) # 80004b98 <iput>
  end_op();
    8000731c:	ffffe097          	auipc	ra,0xffffe
    80007320:	54c080e7          	jalr	1356(ra) # 80005868 <end_op>
  return 0;
    80007324:	00000793          	li	a5,0
    80007328:	0780006f          	j	800073a0 <sys_link+0x184>
    end_op();
    8000732c:	ffffe097          	auipc	ra,0xffffe
    80007330:	53c080e7          	jalr	1340(ra) # 80005868 <end_op>
    return -1;
    80007334:	fff00793          	li	a5,-1
    80007338:	0680006f          	j	800073a0 <sys_link+0x184>
    iunlockput(ip);
    8000733c:	00048513          	mv	a0,s1
    80007340:	ffffe097          	auipc	ra,0xffffe
    80007344:	9e8080e7          	jalr	-1560(ra) # 80004d28 <iunlockput>
    end_op();
    80007348:	ffffe097          	auipc	ra,0xffffe
    8000734c:	520080e7          	jalr	1312(ra) # 80005868 <end_op>
    return -1;
    80007350:	fff00793          	li	a5,-1
    80007354:	04c0006f          	j	800073a0 <sys_link+0x184>
    iunlockput(dp);
    80007358:	00090513          	mv	a0,s2
    8000735c:	ffffe097          	auipc	ra,0xffffe
    80007360:	9cc080e7          	jalr	-1588(ra) # 80004d28 <iunlockput>
  ilock(ip);
    80007364:	00048513          	mv	a0,s1
    80007368:	ffffd097          	auipc	ra,0xffffd
    8000736c:	6bc080e7          	jalr	1724(ra) # 80004a24 <ilock>
  ip->nlink--;
    80007370:	04a4d783          	lhu	a5,74(s1)
    80007374:	fff7879b          	addiw	a5,a5,-1
    80007378:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000737c:	00048513          	mv	a0,s1
    80007380:	ffffd097          	auipc	ra,0xffffd
    80007384:	588080e7          	jalr	1416(ra) # 80004908 <iupdate>
  iunlockput(ip);
    80007388:	00048513          	mv	a0,s1
    8000738c:	ffffe097          	auipc	ra,0xffffe
    80007390:	99c080e7          	jalr	-1636(ra) # 80004d28 <iunlockput>
  end_op();
    80007394:	ffffe097          	auipc	ra,0xffffe
    80007398:	4d4080e7          	jalr	1236(ra) # 80005868 <end_op>
  return -1;
    8000739c:	fff00793          	li	a5,-1
}
    800073a0:	00078513          	mv	a0,a5
    800073a4:	12813083          	ld	ra,296(sp)
    800073a8:	12013403          	ld	s0,288(sp)
    800073ac:	11813483          	ld	s1,280(sp)
    800073b0:	11013903          	ld	s2,272(sp)
    800073b4:	13010113          	addi	sp,sp,304
    800073b8:	00008067          	ret

00000000800073bc <sys_unlink>:
{
    800073bc:	f1010113          	addi	sp,sp,-240
    800073c0:	0e113423          	sd	ra,232(sp)
    800073c4:	0e813023          	sd	s0,224(sp)
    800073c8:	0c913c23          	sd	s1,216(sp)
    800073cc:	0d213823          	sd	s2,208(sp)
    800073d0:	0d313423          	sd	s3,200(sp)
    800073d4:	0f010413          	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800073d8:	08000613          	li	a2,128
    800073dc:	f3040593          	addi	a1,s0,-208
    800073e0:	00000513          	li	a0,0
    800073e4:	ffffc097          	auipc	ra,0xffffc
    800073e8:	6e0080e7          	jalr	1760(ra) # 80003ac4 <argstr>
    800073ec:	1c054063          	bltz	a0,800075ac <sys_unlink+0x1f0>
  begin_op();
    800073f0:	ffffe097          	auipc	ra,0xffffe
    800073f4:	3c4080e7          	jalr	964(ra) # 800057b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800073f8:	fb040593          	addi	a1,s0,-80
    800073fc:	f3040513          	addi	a0,s0,-208
    80007400:	ffffe097          	auipc	ra,0xffffe
    80007404:	110080e7          	jalr	272(ra) # 80005510 <nameiparent>
    80007408:	00050493          	mv	s1,a0
    8000740c:	0e050c63          	beqz	a0,80007504 <sys_unlink+0x148>
  ilock(dp);
    80007410:	ffffd097          	auipc	ra,0xffffd
    80007414:	614080e7          	jalr	1556(ra) # 80004a24 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80007418:	00001597          	auipc	a1,0x1
    8000741c:	4b058593          	addi	a1,a1,1200 # 800088c8 <userret+0x824>
    80007420:	fb040513          	addi	a0,s0,-80
    80007424:	ffffe097          	auipc	ra,0xffffe
    80007428:	c80080e7          	jalr	-896(ra) # 800050a4 <namecmp>
    8000742c:	18050a63          	beqz	a0,800075c0 <sys_unlink+0x204>
    80007430:	00001597          	auipc	a1,0x1
    80007434:	4a058593          	addi	a1,a1,1184 # 800088d0 <userret+0x82c>
    80007438:	fb040513          	addi	a0,s0,-80
    8000743c:	ffffe097          	auipc	ra,0xffffe
    80007440:	c68080e7          	jalr	-920(ra) # 800050a4 <namecmp>
    80007444:	16050e63          	beqz	a0,800075c0 <sys_unlink+0x204>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80007448:	f2c40613          	addi	a2,s0,-212
    8000744c:	fb040593          	addi	a1,s0,-80
    80007450:	00048513          	mv	a0,s1
    80007454:	ffffe097          	auipc	ra,0xffffe
    80007458:	c7c080e7          	jalr	-900(ra) # 800050d0 <dirlookup>
    8000745c:	00050913          	mv	s2,a0
    80007460:	16050063          	beqz	a0,800075c0 <sys_unlink+0x204>
  ilock(ip);
    80007464:	ffffd097          	auipc	ra,0xffffd
    80007468:	5c0080e7          	jalr	1472(ra) # 80004a24 <ilock>
  if(ip->nlink < 1)
    8000746c:	04a91783          	lh	a5,74(s2)
    80007470:	0af05263          	blez	a5,80007514 <sys_unlink+0x158>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80007474:	04491703          	lh	a4,68(s2)
    80007478:	00100793          	li	a5,1
    8000747c:	0af70463          	beq	a4,a5,80007524 <sys_unlink+0x168>
  memset(&de, 0, sizeof(de));
    80007480:	01000613          	li	a2,16
    80007484:	00000593          	li	a1,0
    80007488:	fc040513          	addi	a0,s0,-64
    8000748c:	ffffa097          	auipc	ra,0xffffa
    80007490:	b24080e7          	jalr	-1244(ra) # 80000fb0 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007494:	01000713          	li	a4,16
    80007498:	f2c42683          	lw	a3,-212(s0)
    8000749c:	fc040613          	addi	a2,s0,-64
    800074a0:	00000593          	li	a1,0
    800074a4:	00048513          	mv	a0,s1
    800074a8:	ffffe097          	auipc	ra,0xffffe
    800074ac:	a68080e7          	jalr	-1432(ra) # 80004f10 <writei>
    800074b0:	01000793          	li	a5,16
    800074b4:	0cf51663          	bne	a0,a5,80007580 <sys_unlink+0x1c4>
  if(ip->type == T_DIR){
    800074b8:	04491703          	lh	a4,68(s2)
    800074bc:	00100793          	li	a5,1
    800074c0:	0cf70863          	beq	a4,a5,80007590 <sys_unlink+0x1d4>
  iunlockput(dp);
    800074c4:	00048513          	mv	a0,s1
    800074c8:	ffffe097          	auipc	ra,0xffffe
    800074cc:	860080e7          	jalr	-1952(ra) # 80004d28 <iunlockput>
  ip->nlink--;
    800074d0:	04a95783          	lhu	a5,74(s2)
    800074d4:	fff7879b          	addiw	a5,a5,-1
    800074d8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800074dc:	00090513          	mv	a0,s2
    800074e0:	ffffd097          	auipc	ra,0xffffd
    800074e4:	428080e7          	jalr	1064(ra) # 80004908 <iupdate>
  iunlockput(ip);
    800074e8:	00090513          	mv	a0,s2
    800074ec:	ffffe097          	auipc	ra,0xffffe
    800074f0:	83c080e7          	jalr	-1988(ra) # 80004d28 <iunlockput>
  end_op();
    800074f4:	ffffe097          	auipc	ra,0xffffe
    800074f8:	374080e7          	jalr	884(ra) # 80005868 <end_op>
  return 0;
    800074fc:	00000513          	li	a0,0
    80007500:	0d80006f          	j	800075d8 <sys_unlink+0x21c>
    end_op();
    80007504:	ffffe097          	auipc	ra,0xffffe
    80007508:	364080e7          	jalr	868(ra) # 80005868 <end_op>
    return -1;
    8000750c:	fff00513          	li	a0,-1
    80007510:	0c80006f          	j	800075d8 <sys_unlink+0x21c>
    panic("unlink: nlink < 1");
    80007514:	00001517          	auipc	a0,0x1
    80007518:	3e450513          	addi	a0,a0,996 # 800088f8 <userret+0x854>
    8000751c:	ffff9097          	auipc	ra,0xffff9
    80007520:	1bc080e7          	jalr	444(ra) # 800006d8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007524:	04c92703          	lw	a4,76(s2)
    80007528:	02000793          	li	a5,32
    8000752c:	f4e7fae3          	bgeu	a5,a4,80007480 <sys_unlink+0xc4>
    80007530:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007534:	01000713          	li	a4,16
    80007538:	00098693          	mv	a3,s3
    8000753c:	f1840613          	addi	a2,s0,-232
    80007540:	00000593          	li	a1,0
    80007544:	00090513          	mv	a0,s2
    80007548:	ffffe097          	auipc	ra,0xffffe
    8000754c:	860080e7          	jalr	-1952(ra) # 80004da8 <readi>
    80007550:	01000793          	li	a5,16
    80007554:	00f51e63          	bne	a0,a5,80007570 <sys_unlink+0x1b4>
    if(de.inum != 0)
    80007558:	f1845783          	lhu	a5,-232(s0)
    8000755c:	04079c63          	bnez	a5,800075b4 <sys_unlink+0x1f8>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007560:	0109899b          	addiw	s3,s3,16
    80007564:	04c92783          	lw	a5,76(s2)
    80007568:	fcf9e6e3          	bltu	s3,a5,80007534 <sys_unlink+0x178>
    8000756c:	f15ff06f          	j	80007480 <sys_unlink+0xc4>
      panic("isdirempty: readi");
    80007570:	00001517          	auipc	a0,0x1
    80007574:	3a050513          	addi	a0,a0,928 # 80008910 <userret+0x86c>
    80007578:	ffff9097          	auipc	ra,0xffff9
    8000757c:	160080e7          	jalr	352(ra) # 800006d8 <panic>
    panic("unlink: writei");
    80007580:	00001517          	auipc	a0,0x1
    80007584:	3a850513          	addi	a0,a0,936 # 80008928 <userret+0x884>
    80007588:	ffff9097          	auipc	ra,0xffff9
    8000758c:	150080e7          	jalr	336(ra) # 800006d8 <panic>
    dp->nlink--;
    80007590:	04a4d783          	lhu	a5,74(s1)
    80007594:	fff7879b          	addiw	a5,a5,-1
    80007598:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000759c:	00048513          	mv	a0,s1
    800075a0:	ffffd097          	auipc	ra,0xffffd
    800075a4:	368080e7          	jalr	872(ra) # 80004908 <iupdate>
    800075a8:	f1dff06f          	j	800074c4 <sys_unlink+0x108>
    return -1;
    800075ac:	fff00513          	li	a0,-1
    800075b0:	0280006f          	j	800075d8 <sys_unlink+0x21c>
    iunlockput(ip);
    800075b4:	00090513          	mv	a0,s2
    800075b8:	ffffd097          	auipc	ra,0xffffd
    800075bc:	770080e7          	jalr	1904(ra) # 80004d28 <iunlockput>
  iunlockput(dp);
    800075c0:	00048513          	mv	a0,s1
    800075c4:	ffffd097          	auipc	ra,0xffffd
    800075c8:	764080e7          	jalr	1892(ra) # 80004d28 <iunlockput>
  end_op();
    800075cc:	ffffe097          	auipc	ra,0xffffe
    800075d0:	29c080e7          	jalr	668(ra) # 80005868 <end_op>
  return -1;
    800075d4:	fff00513          	li	a0,-1
}
    800075d8:	0e813083          	ld	ra,232(sp)
    800075dc:	0e013403          	ld	s0,224(sp)
    800075e0:	0d813483          	ld	s1,216(sp)
    800075e4:	0d013903          	ld	s2,208(sp)
    800075e8:	0c813983          	ld	s3,200(sp)
    800075ec:	0f010113          	addi	sp,sp,240
    800075f0:	00008067          	ret

00000000800075f4 <sys_open>:

uint64
sys_open(void)
{
    800075f4:	f4010113          	addi	sp,sp,-192
    800075f8:	0a113c23          	sd	ra,184(sp)
    800075fc:	0a813823          	sd	s0,176(sp)
    80007600:	0a913423          	sd	s1,168(sp)
    80007604:	0b213023          	sd	s2,160(sp)
    80007608:	09313c23          	sd	s3,152(sp)
    8000760c:	0c010413          	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80007610:	08000613          	li	a2,128
    80007614:	f5040593          	addi	a1,s0,-176
    80007618:	00000513          	li	a0,0
    8000761c:	ffffc097          	auipc	ra,0xffffc
    80007620:	4a8080e7          	jalr	1192(ra) # 80003ac4 <argstr>
    return -1;
    80007624:	fff00493          	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80007628:	0c054863          	bltz	a0,800076f8 <sys_open+0x104>
    8000762c:	f4c40593          	addi	a1,s0,-180
    80007630:	00100513          	li	a0,1
    80007634:	ffffc097          	auipc	ra,0xffffc
    80007638:	418080e7          	jalr	1048(ra) # 80003a4c <argint>
    8000763c:	0a054e63          	bltz	a0,800076f8 <sys_open+0x104>

  begin_op();
    80007640:	ffffe097          	auipc	ra,0xffffe
    80007644:	174080e7          	jalr	372(ra) # 800057b4 <begin_op>

  if(omode & O_CREATE){
    80007648:	f4c42783          	lw	a5,-180(s0)
    8000764c:	2007f793          	andi	a5,a5,512
    80007650:	0c078a63          	beqz	a5,80007724 <sys_open+0x130>
    ip = create(path, T_FILE, 0, 0);
    80007654:	00000693          	li	a3,0
    80007658:	00000613          	li	a2,0
    8000765c:	00200593          	li	a1,2
    80007660:	f5040513          	addi	a0,s0,-176
    80007664:	fffff097          	auipc	ra,0xfffff
    80007668:	780080e7          	jalr	1920(ra) # 80006de4 <create>
    8000766c:	00050913          	mv	s2,a0
    if(ip == 0){
    80007670:	0a050463          	beqz	a0,80007718 <sys_open+0x124>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80007674:	04491703          	lh	a4,68(s2)
    80007678:	00300793          	li	a5,3
    8000767c:	00f71863          	bne	a4,a5,8000768c <sys_open+0x98>
    80007680:	04695703          	lhu	a4,70(s2)
    80007684:	00900793          	li	a5,9
    80007688:	0ee7ec63          	bltu	a5,a4,80007780 <sys_open+0x18c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000768c:	ffffe097          	auipc	ra,0xffffe
    80007690:	6bc080e7          	jalr	1724(ra) # 80005d48 <filealloc>
    80007694:	00050993          	mv	s3,a0
    80007698:	12050063          	beqz	a0,800077b8 <sys_open+0x1c4>
    8000769c:	fffff097          	auipc	ra,0xfffff
    800076a0:	6d8080e7          	jalr	1752(ra) # 80006d74 <fdalloc>
    800076a4:	00050493          	mv	s1,a0
    800076a8:	10054263          	bltz	a0,800077ac <sys_open+0x1b8>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800076ac:	04491703          	lh	a4,68(s2)
    800076b0:	00300793          	li	a5,3
    800076b4:	0ef70463          	beq	a4,a5,8000779c <sys_open+0x1a8>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800076b8:	00200793          	li	a5,2
    800076bc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800076c0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800076c4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800076c8:	f4c42783          	lw	a5,-180(s0)
    800076cc:	0017c713          	xori	a4,a5,1
    800076d0:	00177713          	andi	a4,a4,1
    800076d4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800076d8:	0037f793          	andi	a5,a5,3
    800076dc:	00f037b3          	snez	a5,a5
    800076e0:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    800076e4:	00090513          	mv	a0,s2
    800076e8:	ffffd097          	auipc	ra,0xffffd
    800076ec:	440080e7          	jalr	1088(ra) # 80004b28 <iunlock>
  end_op();
    800076f0:	ffffe097          	auipc	ra,0xffffe
    800076f4:	178080e7          	jalr	376(ra) # 80005868 <end_op>

  return fd;
}
    800076f8:	00048513          	mv	a0,s1
    800076fc:	0b813083          	ld	ra,184(sp)
    80007700:	0b013403          	ld	s0,176(sp)
    80007704:	0a813483          	ld	s1,168(sp)
    80007708:	0a013903          	ld	s2,160(sp)
    8000770c:	09813983          	ld	s3,152(sp)
    80007710:	0c010113          	addi	sp,sp,192
    80007714:	00008067          	ret
      end_op();
    80007718:	ffffe097          	auipc	ra,0xffffe
    8000771c:	150080e7          	jalr	336(ra) # 80005868 <end_op>
      return -1;
    80007720:	fd9ff06f          	j	800076f8 <sys_open+0x104>
    if((ip = namei(path)) == 0){
    80007724:	f5040513          	addi	a0,s0,-176
    80007728:	ffffe097          	auipc	ra,0xffffe
    8000772c:	db8080e7          	jalr	-584(ra) # 800054e0 <namei>
    80007730:	00050913          	mv	s2,a0
    80007734:	02050e63          	beqz	a0,80007770 <sys_open+0x17c>
    ilock(ip);
    80007738:	ffffd097          	auipc	ra,0xffffd
    8000773c:	2ec080e7          	jalr	748(ra) # 80004a24 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80007740:	04491703          	lh	a4,68(s2)
    80007744:	00100793          	li	a5,1
    80007748:	f2f716e3          	bne	a4,a5,80007674 <sys_open+0x80>
    8000774c:	f4c42783          	lw	a5,-180(s0)
    80007750:	f2078ee3          	beqz	a5,8000768c <sys_open+0x98>
      iunlockput(ip);
    80007754:	00090513          	mv	a0,s2
    80007758:	ffffd097          	auipc	ra,0xffffd
    8000775c:	5d0080e7          	jalr	1488(ra) # 80004d28 <iunlockput>
      end_op();
    80007760:	ffffe097          	auipc	ra,0xffffe
    80007764:	108080e7          	jalr	264(ra) # 80005868 <end_op>
      return -1;
    80007768:	fff00493          	li	s1,-1
    8000776c:	f8dff06f          	j	800076f8 <sys_open+0x104>
      end_op();
    80007770:	ffffe097          	auipc	ra,0xffffe
    80007774:	0f8080e7          	jalr	248(ra) # 80005868 <end_op>
      return -1;
    80007778:	fff00493          	li	s1,-1
    8000777c:	f7dff06f          	j	800076f8 <sys_open+0x104>
    iunlockput(ip);
    80007780:	00090513          	mv	a0,s2
    80007784:	ffffd097          	auipc	ra,0xffffd
    80007788:	5a4080e7          	jalr	1444(ra) # 80004d28 <iunlockput>
    end_op();
    8000778c:	ffffe097          	auipc	ra,0xffffe
    80007790:	0dc080e7          	jalr	220(ra) # 80005868 <end_op>
    return -1;
    80007794:	fff00493          	li	s1,-1
    80007798:	f61ff06f          	j	800076f8 <sys_open+0x104>
    f->type = FD_DEVICE;
    8000779c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800077a0:	04691783          	lh	a5,70(s2)
    800077a4:	02f99223          	sh	a5,36(s3)
    800077a8:	f1dff06f          	j	800076c4 <sys_open+0xd0>
      fileclose(f);
    800077ac:	00098513          	mv	a0,s3
    800077b0:	ffffe097          	auipc	ra,0xffffe
    800077b4:	694080e7          	jalr	1684(ra) # 80005e44 <fileclose>
    iunlockput(ip);
    800077b8:	00090513          	mv	a0,s2
    800077bc:	ffffd097          	auipc	ra,0xffffd
    800077c0:	56c080e7          	jalr	1388(ra) # 80004d28 <iunlockput>
    end_op();
    800077c4:	ffffe097          	auipc	ra,0xffffe
    800077c8:	0a4080e7          	jalr	164(ra) # 80005868 <end_op>
    return -1;
    800077cc:	fff00493          	li	s1,-1
    800077d0:	f29ff06f          	j	800076f8 <sys_open+0x104>

00000000800077d4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800077d4:	f7010113          	addi	sp,sp,-144
    800077d8:	08113423          	sd	ra,136(sp)
    800077dc:	08813023          	sd	s0,128(sp)
    800077e0:	09010413          	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800077e4:	ffffe097          	auipc	ra,0xffffe
    800077e8:	fd0080e7          	jalr	-48(ra) # 800057b4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800077ec:	08000613          	li	a2,128
    800077f0:	f7040593          	addi	a1,s0,-144
    800077f4:	00000513          	li	a0,0
    800077f8:	ffffc097          	auipc	ra,0xffffc
    800077fc:	2cc080e7          	jalr	716(ra) # 80003ac4 <argstr>
    80007800:	04054263          	bltz	a0,80007844 <sys_mkdir+0x70>
    80007804:	00000693          	li	a3,0
    80007808:	00000613          	li	a2,0
    8000780c:	00100593          	li	a1,1
    80007810:	f7040513          	addi	a0,s0,-144
    80007814:	fffff097          	auipc	ra,0xfffff
    80007818:	5d0080e7          	jalr	1488(ra) # 80006de4 <create>
    8000781c:	02050463          	beqz	a0,80007844 <sys_mkdir+0x70>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80007820:	ffffd097          	auipc	ra,0xffffd
    80007824:	508080e7          	jalr	1288(ra) # 80004d28 <iunlockput>
  end_op();
    80007828:	ffffe097          	auipc	ra,0xffffe
    8000782c:	040080e7          	jalr	64(ra) # 80005868 <end_op>
  return 0;
    80007830:	00000513          	li	a0,0
}
    80007834:	08813083          	ld	ra,136(sp)
    80007838:	08013403          	ld	s0,128(sp)
    8000783c:	09010113          	addi	sp,sp,144
    80007840:	00008067          	ret
    end_op();
    80007844:	ffffe097          	auipc	ra,0xffffe
    80007848:	024080e7          	jalr	36(ra) # 80005868 <end_op>
    return -1;
    8000784c:	fff00513          	li	a0,-1
    80007850:	fe5ff06f          	j	80007834 <sys_mkdir+0x60>

0000000080007854 <sys_mknod>:

uint64
sys_mknod(void)
{
    80007854:	f6010113          	addi	sp,sp,-160
    80007858:	08113c23          	sd	ra,152(sp)
    8000785c:	08813823          	sd	s0,144(sp)
    80007860:	0a010413          	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80007864:	ffffe097          	auipc	ra,0xffffe
    80007868:	f50080e7          	jalr	-176(ra) # 800057b4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000786c:	08000613          	li	a2,128
    80007870:	f7040593          	addi	a1,s0,-144
    80007874:	00000513          	li	a0,0
    80007878:	ffffc097          	auipc	ra,0xffffc
    8000787c:	24c080e7          	jalr	588(ra) # 80003ac4 <argstr>
    80007880:	06054063          	bltz	a0,800078e0 <sys_mknod+0x8c>
     argint(1, &major) < 0 ||
    80007884:	f6c40593          	addi	a1,s0,-148
    80007888:	00100513          	li	a0,1
    8000788c:	ffffc097          	auipc	ra,0xffffc
    80007890:	1c0080e7          	jalr	448(ra) # 80003a4c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80007894:	04054663          	bltz	a0,800078e0 <sys_mknod+0x8c>
     argint(2, &minor) < 0 ||
    80007898:	f6840593          	addi	a1,s0,-152
    8000789c:	00200513          	li	a0,2
    800078a0:	ffffc097          	auipc	ra,0xffffc
    800078a4:	1ac080e7          	jalr	428(ra) # 80003a4c <argint>
     argint(1, &major) < 0 ||
    800078a8:	02054c63          	bltz	a0,800078e0 <sys_mknod+0x8c>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800078ac:	f6841683          	lh	a3,-152(s0)
    800078b0:	f6c41603          	lh	a2,-148(s0)
    800078b4:	00300593          	li	a1,3
    800078b8:	f7040513          	addi	a0,s0,-144
    800078bc:	fffff097          	auipc	ra,0xfffff
    800078c0:	528080e7          	jalr	1320(ra) # 80006de4 <create>
     argint(2, &minor) < 0 ||
    800078c4:	00050e63          	beqz	a0,800078e0 <sys_mknod+0x8c>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800078c8:	ffffd097          	auipc	ra,0xffffd
    800078cc:	460080e7          	jalr	1120(ra) # 80004d28 <iunlockput>
  end_op();
    800078d0:	ffffe097          	auipc	ra,0xffffe
    800078d4:	f98080e7          	jalr	-104(ra) # 80005868 <end_op>
  return 0;
    800078d8:	00000513          	li	a0,0
    800078dc:	0100006f          	j	800078ec <sys_mknod+0x98>
    end_op();
    800078e0:	ffffe097          	auipc	ra,0xffffe
    800078e4:	f88080e7          	jalr	-120(ra) # 80005868 <end_op>
    return -1;
    800078e8:	fff00513          	li	a0,-1
}
    800078ec:	09813083          	ld	ra,152(sp)
    800078f0:	09013403          	ld	s0,144(sp)
    800078f4:	0a010113          	addi	sp,sp,160
    800078f8:	00008067          	ret

00000000800078fc <sys_chdir>:

uint64
sys_chdir(void)
{
    800078fc:	f6010113          	addi	sp,sp,-160
    80007900:	08113c23          	sd	ra,152(sp)
    80007904:	08813823          	sd	s0,144(sp)
    80007908:	08913423          	sd	s1,136(sp)
    8000790c:	09213023          	sd	s2,128(sp)
    80007910:	0a010413          	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80007914:	ffffb097          	auipc	ra,0xffffb
    80007918:	a84080e7          	jalr	-1404(ra) # 80002398 <myproc>
    8000791c:	00050913          	mv	s2,a0
  
  begin_op();
    80007920:	ffffe097          	auipc	ra,0xffffe
    80007924:	e94080e7          	jalr	-364(ra) # 800057b4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80007928:	08000613          	li	a2,128
    8000792c:	f6040593          	addi	a1,s0,-160
    80007930:	00000513          	li	a0,0
    80007934:	ffffc097          	auipc	ra,0xffffc
    80007938:	190080e7          	jalr	400(ra) # 80003ac4 <argstr>
    8000793c:	06054663          	bltz	a0,800079a8 <sys_chdir+0xac>
    80007940:	f6040513          	addi	a0,s0,-160
    80007944:	ffffe097          	auipc	ra,0xffffe
    80007948:	b9c080e7          	jalr	-1124(ra) # 800054e0 <namei>
    8000794c:	00050493          	mv	s1,a0
    80007950:	04050c63          	beqz	a0,800079a8 <sys_chdir+0xac>
    end_op();
    return -1;
  }
  ilock(ip);
    80007954:	ffffd097          	auipc	ra,0xffffd
    80007958:	0d0080e7          	jalr	208(ra) # 80004a24 <ilock>
  if(ip->type != T_DIR){
    8000795c:	04449703          	lh	a4,68(s1)
    80007960:	00100793          	li	a5,1
    80007964:	04f71a63          	bne	a4,a5,800079b8 <sys_chdir+0xbc>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80007968:	00048513          	mv	a0,s1
    8000796c:	ffffd097          	auipc	ra,0xffffd
    80007970:	1bc080e7          	jalr	444(ra) # 80004b28 <iunlock>
  iput(p->cwd);
    80007974:	15093503          	ld	a0,336(s2)
    80007978:	ffffd097          	auipc	ra,0xffffd
    8000797c:	220080e7          	jalr	544(ra) # 80004b98 <iput>
  end_op();
    80007980:	ffffe097          	auipc	ra,0xffffe
    80007984:	ee8080e7          	jalr	-280(ra) # 80005868 <end_op>
  p->cwd = ip;
    80007988:	14993823          	sd	s1,336(s2)
  return 0;
    8000798c:	00000513          	li	a0,0
}
    80007990:	09813083          	ld	ra,152(sp)
    80007994:	09013403          	ld	s0,144(sp)
    80007998:	08813483          	ld	s1,136(sp)
    8000799c:	08013903          	ld	s2,128(sp)
    800079a0:	0a010113          	addi	sp,sp,160
    800079a4:	00008067          	ret
    end_op();
    800079a8:	ffffe097          	auipc	ra,0xffffe
    800079ac:	ec0080e7          	jalr	-320(ra) # 80005868 <end_op>
    return -1;
    800079b0:	fff00513          	li	a0,-1
    800079b4:	fddff06f          	j	80007990 <sys_chdir+0x94>
    iunlockput(ip);
    800079b8:	00048513          	mv	a0,s1
    800079bc:	ffffd097          	auipc	ra,0xffffd
    800079c0:	36c080e7          	jalr	876(ra) # 80004d28 <iunlockput>
    end_op();
    800079c4:	ffffe097          	auipc	ra,0xffffe
    800079c8:	ea4080e7          	jalr	-348(ra) # 80005868 <end_op>
    return -1;
    800079cc:	fff00513          	li	a0,-1
    800079d0:	fc1ff06f          	j	80007990 <sys_chdir+0x94>

00000000800079d4 <sys_exec>:

uint64
sys_exec(void)
{
    800079d4:	e3010113          	addi	sp,sp,-464
    800079d8:	1c113423          	sd	ra,456(sp)
    800079dc:	1c813023          	sd	s0,448(sp)
    800079e0:	1a913c23          	sd	s1,440(sp)
    800079e4:	1b213823          	sd	s2,432(sp)
    800079e8:	1b313423          	sd	s3,424(sp)
    800079ec:	1b413023          	sd	s4,416(sp)
    800079f0:	19513c23          	sd	s5,408(sp)
    800079f4:	1d010413          	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800079f8:	08000613          	li	a2,128
    800079fc:	f4040593          	addi	a1,s0,-192
    80007a00:	00000513          	li	a0,0
    80007a04:	ffffc097          	auipc	ra,0xffffc
    80007a08:	0c0080e7          	jalr	192(ra) # 80003ac4 <argstr>
    80007a0c:	10054e63          	bltz	a0,80007b28 <sys_exec+0x154>
    80007a10:	e3840593          	addi	a1,s0,-456
    80007a14:	00100513          	li	a0,1
    80007a18:	ffffc097          	auipc	ra,0xffffc
    80007a1c:	070080e7          	jalr	112(ra) # 80003a88 <argaddr>
    80007a20:	12054863          	bltz	a0,80007b50 <sys_exec+0x17c>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    80007a24:	10000613          	li	a2,256
    80007a28:	00000593          	li	a1,0
    80007a2c:	e4040513          	addi	a0,s0,-448
    80007a30:	ffff9097          	auipc	ra,0xffff9
    80007a34:	580080e7          	jalr	1408(ra) # 80000fb0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80007a38:	e4040913          	addi	s2,s0,-448
  memset(argv, 0, sizeof(argv));
    80007a3c:	00090993          	mv	s3,s2
    80007a40:	00000493          	li	s1,0
    if(i >= NELEM(argv)){
    80007a44:	02000a13          	li	s4,32
    80007a48:	00048a9b          	sext.w	s5,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80007a4c:	00349513          	slli	a0,s1,0x3
    80007a50:	e3040593          	addi	a1,s0,-464
    80007a54:	e3843783          	ld	a5,-456(s0)
    80007a58:	00f50533          	add	a0,a0,a5
    80007a5c:	ffffc097          	auipc	ra,0xffffc
    80007a60:	efc080e7          	jalr	-260(ra) # 80003958 <fetchaddr>
    80007a64:	04054063          	bltz	a0,80007aa4 <sys_exec+0xd0>
      goto bad;
    }
    if(uarg == 0){
    80007a68:	e3043783          	ld	a5,-464(s0)
    80007a6c:	04078e63          	beqz	a5,80007ac8 <sys_exec+0xf4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80007a70:	ffff9097          	auipc	ra,0xffff9
    80007a74:	258080e7          	jalr	600(ra) # 80000cc8 <kalloc>
    80007a78:	00050593          	mv	a1,a0
    80007a7c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80007a80:	08050863          	beqz	a0,80007b10 <sys_exec+0x13c>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    80007a84:	00001637          	lui	a2,0x1
    80007a88:	e3043503          	ld	a0,-464(s0)
    80007a8c:	ffffc097          	auipc	ra,0xffffc
    80007a90:	f4c080e7          	jalr	-180(ra) # 800039d8 <fetchstr>
    80007a94:	00054863          	bltz	a0,80007aa4 <sys_exec+0xd0>
    if(i >= NELEM(argv)){
    80007a98:	00148493          	addi	s1,s1,1
    80007a9c:	00898993          	addi	s3,s3,8
    80007aa0:	fb4494e3          	bne	s1,s4,80007a48 <sys_exec+0x74>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007aa4:	f4040493          	addi	s1,s0,-192
    80007aa8:	00093503          	ld	a0,0(s2)
    80007aac:	06050a63          	beqz	a0,80007b20 <sys_exec+0x14c>
    kfree(argv[i]);
    80007ab0:	ffff9097          	auipc	ra,0xffff9
    80007ab4:	034080e7          	jalr	52(ra) # 80000ae4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007ab8:	00890913          	addi	s2,s2,8
    80007abc:	fe9916e3          	bne	s2,s1,80007aa8 <sys_exec+0xd4>
  return -1;
    80007ac0:	fff00513          	li	a0,-1
    80007ac4:	0680006f          	j	80007b2c <sys_exec+0x158>
      argv[i] = 0;
    80007ac8:	003a9a93          	slli	s5,s5,0x3
    80007acc:	fc0a8793          	addi	a5,s5,-64
    80007ad0:	00878ab3          	add	s5,a5,s0
    80007ad4:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80007ad8:	e4040593          	addi	a1,s0,-448
    80007adc:	f4040513          	addi	a0,s0,-192
    80007ae0:	fffff097          	auipc	ra,0xfffff
    80007ae4:	d84080e7          	jalr	-636(ra) # 80006864 <exec>
    80007ae8:	00050493          	mv	s1,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007aec:	f4040993          	addi	s3,s0,-192
    80007af0:	00093503          	ld	a0,0(s2)
    80007af4:	00050a63          	beqz	a0,80007b08 <sys_exec+0x134>
    kfree(argv[i]);
    80007af8:	ffff9097          	auipc	ra,0xffff9
    80007afc:	fec080e7          	jalr	-20(ra) # 80000ae4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007b00:	00890913          	addi	s2,s2,8
    80007b04:	ff3916e3          	bne	s2,s3,80007af0 <sys_exec+0x11c>
  return ret;
    80007b08:	00048513          	mv	a0,s1
    80007b0c:	0200006f          	j	80007b2c <sys_exec+0x158>
      panic("sys_exec kalloc");
    80007b10:	00001517          	auipc	a0,0x1
    80007b14:	e2850513          	addi	a0,a0,-472 # 80008938 <userret+0x894>
    80007b18:	ffff9097          	auipc	ra,0xffff9
    80007b1c:	bc0080e7          	jalr	-1088(ra) # 800006d8 <panic>
  return -1;
    80007b20:	fff00513          	li	a0,-1
    80007b24:	0080006f          	j	80007b2c <sys_exec+0x158>
    return -1;
    80007b28:	fff00513          	li	a0,-1
}
    80007b2c:	1c813083          	ld	ra,456(sp)
    80007b30:	1c013403          	ld	s0,448(sp)
    80007b34:	1b813483          	ld	s1,440(sp)
    80007b38:	1b013903          	ld	s2,432(sp)
    80007b3c:	1a813983          	ld	s3,424(sp)
    80007b40:	1a013a03          	ld	s4,416(sp)
    80007b44:	19813a83          	ld	s5,408(sp)
    80007b48:	1d010113          	addi	sp,sp,464
    80007b4c:	00008067          	ret
    return -1;
    80007b50:	fff00513          	li	a0,-1
    80007b54:	fd9ff06f          	j	80007b2c <sys_exec+0x158>

0000000080007b58 <sys_pipe>:

uint64
sys_pipe(void)
{
    80007b58:	fc010113          	addi	sp,sp,-64
    80007b5c:	02113c23          	sd	ra,56(sp)
    80007b60:	02813823          	sd	s0,48(sp)
    80007b64:	02913423          	sd	s1,40(sp)
    80007b68:	04010413          	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80007b6c:	ffffb097          	auipc	ra,0xffffb
    80007b70:	82c080e7          	jalr	-2004(ra) # 80002398 <myproc>
    80007b74:	00050493          	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80007b78:	fd840593          	addi	a1,s0,-40
    80007b7c:	00000513          	li	a0,0
    80007b80:	ffffc097          	auipc	ra,0xffffc
    80007b84:	f08080e7          	jalr	-248(ra) # 80003a88 <argaddr>
    return -1;
    80007b88:	fff00793          	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80007b8c:	10054263          	bltz	a0,80007c90 <sys_pipe+0x138>
  if(pipealloc(&rf, &wf) < 0)
    80007b90:	fc840593          	addi	a1,s0,-56
    80007b94:	fd040513          	addi	a0,s0,-48
    80007b98:	ffffe097          	auipc	ra,0xffffe
    80007b9c:	75c080e7          	jalr	1884(ra) # 800062f4 <pipealloc>
    return -1;
    80007ba0:	fff00793          	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80007ba4:	0e054663          	bltz	a0,80007c90 <sys_pipe+0x138>
  fd0 = -1;
    80007ba8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80007bac:	fd043503          	ld	a0,-48(s0)
    80007bb0:	fffff097          	auipc	ra,0xfffff
    80007bb4:	1c4080e7          	jalr	452(ra) # 80006d74 <fdalloc>
    80007bb8:	fca42223          	sw	a0,-60(s0)
    80007bbc:	0a054c63          	bltz	a0,80007c74 <sys_pipe+0x11c>
    80007bc0:	fc843503          	ld	a0,-56(s0)
    80007bc4:	fffff097          	auipc	ra,0xfffff
    80007bc8:	1b0080e7          	jalr	432(ra) # 80006d74 <fdalloc>
    80007bcc:	fca42023          	sw	a0,-64(s0)
    80007bd0:	08054663          	bltz	a0,80007c5c <sys_pipe+0x104>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80007bd4:	00400693          	li	a3,4
    80007bd8:	fc440613          	addi	a2,s0,-60
    80007bdc:	fd843583          	ld	a1,-40(s0)
    80007be0:	0504b503          	ld	a0,80(s1)
    80007be4:	ffffa097          	auipc	ra,0xffffa
    80007be8:	2fc080e7          	jalr	764(ra) # 80001ee0 <copyout>
    80007bec:	02054463          	bltz	a0,80007c14 <sys_pipe+0xbc>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80007bf0:	00400693          	li	a3,4
    80007bf4:	fc040613          	addi	a2,s0,-64
    80007bf8:	fd843583          	ld	a1,-40(s0)
    80007bfc:	00458593          	addi	a1,a1,4
    80007c00:	0504b503          	ld	a0,80(s1)
    80007c04:	ffffa097          	auipc	ra,0xffffa
    80007c08:	2dc080e7          	jalr	732(ra) # 80001ee0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80007c0c:	00000793          	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80007c10:	08055063          	bgez	a0,80007c90 <sys_pipe+0x138>
    p->ofile[fd0] = 0;
    80007c14:	fc442783          	lw	a5,-60(s0)
    80007c18:	01a78793          	addi	a5,a5,26
    80007c1c:	00379793          	slli	a5,a5,0x3
    80007c20:	00f487b3          	add	a5,s1,a5
    80007c24:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80007c28:	fc042783          	lw	a5,-64(s0)
    80007c2c:	01a78793          	addi	a5,a5,26
    80007c30:	00379793          	slli	a5,a5,0x3
    80007c34:	00f48533          	add	a0,s1,a5
    80007c38:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80007c3c:	fd043503          	ld	a0,-48(s0)
    80007c40:	ffffe097          	auipc	ra,0xffffe
    80007c44:	204080e7          	jalr	516(ra) # 80005e44 <fileclose>
    fileclose(wf);
    80007c48:	fc843503          	ld	a0,-56(s0)
    80007c4c:	ffffe097          	auipc	ra,0xffffe
    80007c50:	1f8080e7          	jalr	504(ra) # 80005e44 <fileclose>
    return -1;
    80007c54:	fff00793          	li	a5,-1
    80007c58:	0380006f          	j	80007c90 <sys_pipe+0x138>
    if(fd0 >= 0)
    80007c5c:	fc442783          	lw	a5,-60(s0)
    80007c60:	0007ca63          	bltz	a5,80007c74 <sys_pipe+0x11c>
      p->ofile[fd0] = 0;
    80007c64:	01a78793          	addi	a5,a5,26
    80007c68:	00379793          	slli	a5,a5,0x3
    80007c6c:	00f487b3          	add	a5,s1,a5
    80007c70:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80007c74:	fd043503          	ld	a0,-48(s0)
    80007c78:	ffffe097          	auipc	ra,0xffffe
    80007c7c:	1cc080e7          	jalr	460(ra) # 80005e44 <fileclose>
    fileclose(wf);
    80007c80:	fc843503          	ld	a0,-56(s0)
    80007c84:	ffffe097          	auipc	ra,0xffffe
    80007c88:	1c0080e7          	jalr	448(ra) # 80005e44 <fileclose>
    return -1;
    80007c8c:	fff00793          	li	a5,-1
}
    80007c90:	00078513          	mv	a0,a5
    80007c94:	03813083          	ld	ra,56(sp)
    80007c98:	03013403          	ld	s0,48(sp)
    80007c9c:	02813483          	ld	s1,40(sp)
    80007ca0:	04010113          	addi	sp,sp,64
    80007ca4:	00008067          	ret
	...

0000000080007cb0 <kernelvec>:
    80007cb0:	f0010113          	addi	sp,sp,-256
    80007cb4:	00113023          	sd	ra,0(sp)
    80007cb8:	00213423          	sd	sp,8(sp)
    80007cbc:	00313823          	sd	gp,16(sp)
    80007cc0:	00413c23          	sd	tp,24(sp)
    80007cc4:	02513023          	sd	t0,32(sp)
    80007cc8:	02613423          	sd	t1,40(sp)
    80007ccc:	02713823          	sd	t2,48(sp)
    80007cd0:	02813c23          	sd	s0,56(sp)
    80007cd4:	04913023          	sd	s1,64(sp)
    80007cd8:	04a13423          	sd	a0,72(sp)
    80007cdc:	04b13823          	sd	a1,80(sp)
    80007ce0:	04c13c23          	sd	a2,88(sp)
    80007ce4:	06d13023          	sd	a3,96(sp)
    80007ce8:	06e13423          	sd	a4,104(sp)
    80007cec:	06f13823          	sd	a5,112(sp)
    80007cf0:	07013c23          	sd	a6,120(sp)
    80007cf4:	09113023          	sd	a7,128(sp)
    80007cf8:	09213423          	sd	s2,136(sp)
    80007cfc:	09313823          	sd	s3,144(sp)
    80007d00:	09413c23          	sd	s4,152(sp)
    80007d04:	0b513023          	sd	s5,160(sp)
    80007d08:	0b613423          	sd	s6,168(sp)
    80007d0c:	0b713823          	sd	s7,176(sp)
    80007d10:	0b813c23          	sd	s8,184(sp)
    80007d14:	0d913023          	sd	s9,192(sp)
    80007d18:	0da13423          	sd	s10,200(sp)
    80007d1c:	0db13823          	sd	s11,208(sp)
    80007d20:	0dc13c23          	sd	t3,216(sp)
    80007d24:	0fd13023          	sd	t4,224(sp)
    80007d28:	0fe13423          	sd	t5,232(sp)
    80007d2c:	0ff13823          	sd	t6,240(sp)
    80007d30:	a81fb0ef          	jal	ra,800037b0 <kerneltrap>
    80007d34:	00013083          	ld	ra,0(sp)
    80007d38:	00813103          	ld	sp,8(sp)
    80007d3c:	01013183          	ld	gp,16(sp)
    80007d40:	02013283          	ld	t0,32(sp)
    80007d44:	02813303          	ld	t1,40(sp)
    80007d48:	03013383          	ld	t2,48(sp)
    80007d4c:	03813403          	ld	s0,56(sp)
    80007d50:	04013483          	ld	s1,64(sp)
    80007d54:	04813503          	ld	a0,72(sp)
    80007d58:	05013583          	ld	a1,80(sp)
    80007d5c:	05813603          	ld	a2,88(sp)
    80007d60:	06013683          	ld	a3,96(sp)
    80007d64:	06813703          	ld	a4,104(sp)
    80007d68:	07013783          	ld	a5,112(sp)
    80007d6c:	07813803          	ld	a6,120(sp)
    80007d70:	08013883          	ld	a7,128(sp)
    80007d74:	08813903          	ld	s2,136(sp)
    80007d78:	09013983          	ld	s3,144(sp)
    80007d7c:	09813a03          	ld	s4,152(sp)
    80007d80:	0a013a83          	ld	s5,160(sp)
    80007d84:	0a813b03          	ld	s6,168(sp)
    80007d88:	0b013b83          	ld	s7,176(sp)
    80007d8c:	0b813c03          	ld	s8,184(sp)
    80007d90:	0c013c83          	ld	s9,192(sp)
    80007d94:	0c813d03          	ld	s10,200(sp)
    80007d98:	0d013d83          	ld	s11,208(sp)
    80007d9c:	0d813e03          	ld	t3,216(sp)
    80007da0:	0e013e83          	ld	t4,224(sp)
    80007da4:	0e813f03          	ld	t5,232(sp)
    80007da8:	0f013f83          	ld	t6,240(sp)
    80007dac:	10010113          	addi	sp,sp,256
    80007db0:	10200073          	sret
    80007db4:	00000013          	nop
    80007db8:	00000013          	nop
    80007dbc:	00000013          	nop

0000000080007dc0 <timervec>:
    80007dc0:	34051573          	csrrw	a0,mscratch,a0
    80007dc4:	00b53023          	sd	a1,0(a0)
    80007dc8:	00c53423          	sd	a2,8(a0)
    80007dcc:	00d53823          	sd	a3,16(a0)
    80007dd0:	02053583          	ld	a1,32(a0)
    80007dd4:	02853603          	ld	a2,40(a0)
    80007dd8:	0005b683          	ld	a3,0(a1)
    80007ddc:	00c686b3          	add	a3,a3,a2
    80007de0:	00d5b023          	sd	a3,0(a1)
    80007de4:	00200593          	li	a1,2
    80007de8:	14459073          	csrw	sip,a1
    80007dec:	01053683          	ld	a3,16(a0)
    80007df0:	00853603          	ld	a2,8(a0)
    80007df4:	00053583          	ld	a1,0(a0)
    80007df8:	34051573          	csrrw	a0,mscratch,a0
    80007dfc:	30200073          	mret

0000000080007e00 <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80007e00:	ff010113          	addi	sp,sp,-16
    80007e04:	00813423          	sd	s0,8(sp)
    80007e08:	01010413          	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80007e0c:	0c0007b7          	lui	a5,0xc000
    80007e10:	00100713          	li	a4,1
    80007e14:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
  //*(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
}
    80007e18:	00813403          	ld	s0,8(sp)
    80007e1c:	01010113          	addi	sp,sp,16
    80007e20:	00008067          	ret

0000000080007e24 <plicinithart>:

void
plicinithart(void)
{
    80007e24:	ff010113          	addi	sp,sp,-16
    80007e28:	00113423          	sd	ra,8(sp)
    80007e2c:	00813023          	sd	s0,0(sp)
    80007e30:	01010413          	addi	s0,sp,16
  int hart = cpuid();
    80007e34:	ffffa097          	auipc	ra,0xffffa
    80007e38:	514080e7          	jalr	1300(ra) # 80002348 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  //*(uint32*)(PLIC + 0x2080)= (1 << UART0_IRQ);
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ);
    80007e3c:	0085171b          	slliw	a4,a0,0x8
    80007e40:	0c0027b7          	lui	a5,0xc002
    80007e44:	00e787b3          	add	a5,a5,a4
    80007e48:	40000713          	li	a4,1024
    80007e4c:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
  // | (1 << VIRTIO0_IRQ);

  // set this hart's S-mode priority threshold to 0.
  //*(uint32*)(PLIC + 0x201000) = 0;
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80007e50:	00d5151b          	slliw	a0,a0,0xd
    80007e54:	0c2017b7          	lui	a5,0xc201
    80007e58:	00a787b3          	add	a5,a5,a0
    80007e5c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80007e60:	00813083          	ld	ra,8(sp)
    80007e64:	00013403          	ld	s0,0(sp)
    80007e68:	01010113          	addi	sp,sp,16
    80007e6c:	00008067          	ret

0000000080007e70 <plic_pending>:

// return a bitmap of which IRQs are waiting
// to be served.
uint64
plic_pending(void)
{
    80007e70:	ff010113          	addi	sp,sp,-16
    80007e74:	00813423          	sd	s0,8(sp)
    80007e78:	01010413          	addi	s0,sp,16
  //mask = *(uint32*)(PLIC + 0x1000);
  //mask |= (uint64)*(uint32*)(PLIC + 0x1004) << 32;
  mask = *(uint64*)PLIC_PENDING;

  return mask;
}
    80007e7c:	0c0017b7          	lui	a5,0xc001
    80007e80:	0007b503          	ld	a0,0(a5) # c001000 <_entry-0x73fff000>
    80007e84:	00813403          	ld	s0,8(sp)
    80007e88:	01010113          	addi	sp,sp,16
    80007e8c:	00008067          	ret

0000000080007e90 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80007e90:	ff010113          	addi	sp,sp,-16
    80007e94:	00113423          	sd	ra,8(sp)
    80007e98:	00813023          	sd	s0,0(sp)
    80007e9c:	01010413          	addi	s0,sp,16
  int hart = cpuid();
    80007ea0:	ffffa097          	auipc	ra,0xffffa
    80007ea4:	4a8080e7          	jalr	1192(ra) # 80002348 <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80007ea8:	00d5151b          	slliw	a0,a0,0xd
    80007eac:	0c2017b7          	lui	a5,0xc201
    80007eb0:	00a787b3          	add	a5,a5,a0
  return irq;
}
    80007eb4:	0047a503          	lw	a0,4(a5) # c201004 <_entry-0x73dfeffc>
    80007eb8:	00813083          	ld	ra,8(sp)
    80007ebc:	00013403          	ld	s0,0(sp)
    80007ec0:	01010113          	addi	sp,sp,16
    80007ec4:	00008067          	ret

0000000080007ec8 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80007ec8:	fe010113          	addi	sp,sp,-32
    80007ecc:	00113c23          	sd	ra,24(sp)
    80007ed0:	00813823          	sd	s0,16(sp)
    80007ed4:	00913423          	sd	s1,8(sp)
    80007ed8:	02010413          	addi	s0,sp,32
    80007edc:	00050493          	mv	s1,a0
  int hart = cpuid();
    80007ee0:	ffffa097          	auipc	ra,0xffffa
    80007ee4:	468080e7          	jalr	1128(ra) # 80002348 <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80007ee8:	00d5151b          	slliw	a0,a0,0xd
    80007eec:	0c2017b7          	lui	a5,0xc201
    80007ef0:	00a787b3          	add	a5,a5,a0
    80007ef4:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
}
    80007ef8:	01813083          	ld	ra,24(sp)
    80007efc:	01013403          	ld	s0,16(sp)
    80007f00:	00813483          	ld	s1,8(sp)
    80007f04:	02010113          	addi	sp,sp,32
    80007f08:	00008067          	ret
	...

0000000080008000 <trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	06853023          	sd	s0,96(a0)
    80008024:	06953423          	sd	s1,104(a0)
    80008028:	06b53c23          	sd	a1,120(a0)
    8000802c:	08c53023          	sd	a2,128(a0)
    80008030:	08d53423          	sd	a3,136(a0)
    80008034:	08e53823          	sd	a4,144(a0)
    80008038:	08f53c23          	sd	a5,152(a0)
    8000803c:	0b053023          	sd	a6,160(a0)
    80008040:	0b153423          	sd	a7,168(a0)
    80008044:	0a853883          	ld	a7,168(a0)
    80008048:	0b253823          	sd	s2,176(a0)
    8000804c:	0b353c23          	sd	s3,184(a0)
    80008050:	0d453023          	sd	s4,192(a0)
    80008054:	0d553423          	sd	s5,200(a0)
    80008058:	0d653823          	sd	s6,208(a0)
    8000805c:	0d753c23          	sd	s7,216(a0)
    80008060:	0f853023          	sd	s8,224(a0)
    80008064:	0f953423          	sd	s9,232(a0)
    80008068:	0fa53823          	sd	s10,240(a0)
    8000806c:	0fb53c23          	sd	s11,248(a0)
    80008070:	11c53023          	sd	t3,256(a0)
    80008074:	11d53423          	sd	t4,264(a0)
    80008078:	11e53823          	sd	t5,272(a0)
    8000807c:	11f53c23          	sd	t6,280(a0)
    80008080:	140022f3          	csrr	t0,sscratch
    80008084:	06553823          	sd	t0,112(a0)
    80008088:	00853103          	ld	sp,8(a0)
    8000808c:	02053203          	ld	tp,32(a0)
    80008090:	01053283          	ld	t0,16(a0)
    80008094:	00053303          	ld	t1,0(a0)
    80008098:	18031073          	csrw	satp,t1
    8000809c:	12000073          	sfence.vma
    800080a0:	00028067          	jr	t0

00000000800080a4 <userret>:
    800080a4:	18059073          	csrw	satp,a1
    800080a8:	12000073          	sfence.vma
    800080ac:	07053283          	ld	t0,112(a0)
    800080b0:	14029073          	csrw	sscratch,t0
    800080b4:	02853083          	ld	ra,40(a0)
    800080b8:	03053103          	ld	sp,48(a0)
    800080bc:	03853183          	ld	gp,56(a0)
    800080c0:	04053203          	ld	tp,64(a0)
    800080c4:	04853283          	ld	t0,72(a0)
    800080c8:	05053303          	ld	t1,80(a0)
    800080cc:	05853383          	ld	t2,88(a0)
    800080d0:	06053403          	ld	s0,96(a0)
    800080d4:	06853483          	ld	s1,104(a0)
    800080d8:	07853583          	ld	a1,120(a0)
    800080dc:	08053603          	ld	a2,128(a0)
    800080e0:	08853683          	ld	a3,136(a0)
    800080e4:	09053703          	ld	a4,144(a0)
    800080e8:	09853783          	ld	a5,152(a0)
    800080ec:	0a053803          	ld	a6,160(a0)
    800080f0:	0a853883          	ld	a7,168(a0)
    800080f4:	0b053903          	ld	s2,176(a0)
    800080f8:	0b853983          	ld	s3,184(a0)
    800080fc:	0c053a03          	ld	s4,192(a0)
    80008100:	0c853a83          	ld	s5,200(a0)
    80008104:	0d053b03          	ld	s6,208(a0)
    80008108:	0d853b83          	ld	s7,216(a0)
    8000810c:	0e053c03          	ld	s8,224(a0)
    80008110:	0e853c83          	ld	s9,232(a0)
    80008114:	0f053d03          	ld	s10,240(a0)
    80008118:	0f853d83          	ld	s11,248(a0)
    8000811c:	10053e03          	ld	t3,256(a0)
    80008120:	10853e83          	ld	t4,264(a0)
    80008124:	11053f03          	ld	t5,272(a0)
    80008128:	11853f83          	ld	t6,280(a0)
    8000812c:	14051573          	csrrw	a0,sscratch,a0
    80008130:	10200073          	sret
