
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	9a010113          	addi	sp,sp,-1632 # 8000a9a0 <stack0>
    80000008:	00001537          	lui	a0,0x1
    8000000c:	f14025f3          	csrr	a1,mhartid
    80000010:	00158593          	addi	a1,a1,1
    80000014:	02b50533          	mul	a0,a0,a1
    80000018:	00a10133          	add	sp,sp,a0
    8000001c:	094000ef          	jal	ra,800000b0 <start>

0000000080000020 <spin>:
    80000020:	0000006f          	j	80000020 <spin>

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
    80000034:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000038:	0037979b          	slliw	a5,a5,0x3
    8000003c:	02004737          	lui	a4,0x2004
    80000040:	00e787b3          	add	a5,a5,a4
    80000044:	0200c737          	lui	a4,0x200c
    80000048:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000004c:	000f4637          	lui	a2,0xf4
    80000050:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	00c585b3          	add	a1,a1,a2
    80000058:	00b7b023          	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000005c:	00269713          	slli	a4,a3,0x2
    80000060:	00d70733          	add	a4,a4,a3
    80000064:	00371693          	slli	a3,a4,0x3
    80000068:	0000a717          	auipc	a4,0xa
    8000006c:	7f870713          	addi	a4,a4,2040 # 8000a860 <timer_scratch>
    80000070:	00d70733          	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80000074:	00f73c23          	sd	a5,24(a4)
  scratch[4] = interval;
    80000078:	02c73023          	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000007c:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000080:	00008797          	auipc	a5,0x8
    80000084:	ec078793          	addi	a5,a5,-320 # 80007f40 <timervec>
    80000088:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000090:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000094:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000098:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000009c:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800000a0:	30479073          	csrw	mie,a5
}
    800000a4:	00813403          	ld	s0,8(sp)
    800000a8:	01010113          	addi	sp,sp,16
    800000ac:	00008067          	ret

00000000800000b0 <start>:
{
    800000b0:	ff010113          	addi	sp,sp,-16
    800000b4:	00113423          	sd	ra,8(sp)
    800000b8:	00813023          	sd	s0,0(sp)
    800000bc:	01010413          	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800000c0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800000c4:	ffffe737          	lui	a4,0xffffe
    800000c8:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdab77>
    800000cc:	00e7f7b3          	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000d0:	00001737          	lui	a4,0x1
    800000d4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000d8:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000dc:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000e0:	00001797          	auipc	a5,0x1
    800000e4:	2d878793          	addi	a5,a5,728 # 800013b8 <main>
    800000e8:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ec:	00000793          	li	a5,0
    800000f0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000f4:	000107b7          	lui	a5,0x10
    800000f8:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000fc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80000100:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000104:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000108:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000010c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80000110:	fff00793          	li	a5,-1
    80000114:	00a7d793          	srli	a5,a5,0xa
    80000118:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000011c:	00f00793          	li	a5,15
    80000120:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80000124:	00000097          	auipc	ra,0x0
    80000128:	f00080e7          	jalr	-256(ra) # 80000024 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000012c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80000130:	0007879b          	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    80000134:	00078213          	mv	tp,a5
  asm volatile("mret");
    80000138:	30200073          	mret
}
    8000013c:	00813083          	ld	ra,8(sp)
    80000140:	00013403          	ld	s0,0(sp)
    80000144:	01010113          	addi	sp,sp,16
    80000148:	00008067          	ret

000000008000014c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000014c:	fb010113          	addi	sp,sp,-80
    80000150:	04113423          	sd	ra,72(sp)
    80000154:	04813023          	sd	s0,64(sp)
    80000158:	02913c23          	sd	s1,56(sp)
    8000015c:	03213823          	sd	s2,48(sp)
    80000160:	03313423          	sd	s3,40(sp)
    80000164:	03413023          	sd	s4,32(sp)
    80000168:	01513c23          	sd	s5,24(sp)
    8000016c:	05010413          	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000170:	06c05a63          	blez	a2,800001e4 <consolewrite+0x98>
    80000174:	00050a13          	mv	s4,a0
    80000178:	00058493          	mv	s1,a1
    8000017c:	00060993          	mv	s3,a2
    80000180:	00000913          	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000184:	fff00a93          	li	s5,-1
    80000188:	00100693          	li	a3,1
    8000018c:	00048613          	mv	a2,s1
    80000190:	000a0593          	mv	a1,s4
    80000194:	fbf40513          	addi	a0,s0,-65
    80000198:	00003097          	auipc	ra,0x3
    8000019c:	1b0080e7          	jalr	432(ra) # 80003348 <either_copyin>
    800001a0:	01550e63          	beq	a0,s5,800001bc <consolewrite+0x70>
      break;
    uartputc(c);
    800001a4:	fbf44503          	lbu	a0,-65(s0)
    800001a8:	00001097          	auipc	ra,0x1
    800001ac:	9bc080e7          	jalr	-1604(ra) # 80000b64 <uartputc>
  for(i = 0; i < n; i++){
    800001b0:	0019091b          	addiw	s2,s2,1
    800001b4:	00148493          	addi	s1,s1,1
    800001b8:	fd2998e3          	bne	s3,s2,80000188 <consolewrite+0x3c>
  }

  return i;
}
    800001bc:	00090513          	mv	a0,s2
    800001c0:	04813083          	ld	ra,72(sp)
    800001c4:	04013403          	ld	s0,64(sp)
    800001c8:	03813483          	ld	s1,56(sp)
    800001cc:	03013903          	ld	s2,48(sp)
    800001d0:	02813983          	ld	s3,40(sp)
    800001d4:	02013a03          	ld	s4,32(sp)
    800001d8:	01813a83          	ld	s5,24(sp)
    800001dc:	05010113          	addi	sp,sp,80
    800001e0:	00008067          	ret
  for(i = 0; i < n; i++){
    800001e4:	00000913          	li	s2,0
    800001e8:	fd5ff06f          	j	800001bc <consolewrite+0x70>

00000000800001ec <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800001ec:	f9010113          	addi	sp,sp,-112
    800001f0:	06113423          	sd	ra,104(sp)
    800001f4:	06813023          	sd	s0,96(sp)
    800001f8:	04913c23          	sd	s1,88(sp)
    800001fc:	05213823          	sd	s2,80(sp)
    80000200:	05313423          	sd	s3,72(sp)
    80000204:	05413023          	sd	s4,64(sp)
    80000208:	03513c23          	sd	s5,56(sp)
    8000020c:	03613823          	sd	s6,48(sp)
    80000210:	03713423          	sd	s7,40(sp)
    80000214:	03813023          	sd	s8,32(sp)
    80000218:	01913c23          	sd	s9,24(sp)
    8000021c:	01a13823          	sd	s10,16(sp)
    80000220:	07010413          	addi	s0,sp,112
    80000224:	00050a93          	mv	s5,a0
    80000228:	00058a13          	mv	s4,a1
    8000022c:	00060993          	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000230:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000234:	00012517          	auipc	a0,0x12
    80000238:	76c50513          	addi	a0,a0,1900 # 800129a0 <cons>
    8000023c:	00001097          	auipc	ra,0x1
    80000240:	d90080e7          	jalr	-624(ra) # 80000fcc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000244:	00012497          	auipc	s1,0x12
    80000248:	75c48493          	addi	s1,s1,1884 # 800129a0 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000024c:	00012917          	auipc	s2,0x12
    80000250:	7ec90913          	addi	s2,s2,2028 # 80012a38 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80000254:	00400b93          	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000258:	fff00c13          	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000025c:	00a00c93          	li	s9,10
  while(n > 0){
    80000260:	09305263          	blez	s3,800002e4 <consoleread+0xf8>
    while(cons.r == cons.w){
    80000264:	0984a783          	lw	a5,152(s1)
    80000268:	09c4a703          	lw	a4,156(s1)
    8000026c:	02f71863          	bne	a4,a5,8000029c <consoleread+0xb0>
      if(myproc()->killed){
    80000270:	00002097          	auipc	ra,0x2
    80000274:	1e0080e7          	jalr	480(ra) # 80002450 <myproc>
    80000278:	02852783          	lw	a5,40(a0)
    8000027c:	08079063          	bnez	a5,800002fc <consoleread+0x110>
      sleep(&cons.r, &cons.lock);
    80000280:	00048593          	mv	a1,s1
    80000284:	00090513          	mv	a0,s2
    80000288:	00003097          	auipc	ra,0x3
    8000028c:	b38080e7          	jalr	-1224(ra) # 80002dc0 <sleep>
    while(cons.r == cons.w){
    80000290:	0984a783          	lw	a5,152(s1)
    80000294:	09c4a703          	lw	a4,156(s1)
    80000298:	fcf70ce3          	beq	a4,a5,80000270 <consoleread+0x84>
    c = cons.buf[cons.r++ % INPUT_BUF];
    8000029c:	0017871b          	addiw	a4,a5,1
    800002a0:	08e4ac23          	sw	a4,152(s1)
    800002a4:	07f7f713          	andi	a4,a5,127
    800002a8:	00e48733          	add	a4,s1,a4
    800002ac:	01874703          	lbu	a4,24(a4)
    800002b0:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800002b4:	097d0a63          	beq	s10,s7,80000348 <consoleread+0x15c>
    cbuf = c;
    800002b8:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800002bc:	00100693          	li	a3,1
    800002c0:	f9f40613          	addi	a2,s0,-97
    800002c4:	000a0593          	mv	a1,s4
    800002c8:	000a8513          	mv	a0,s5
    800002cc:	00003097          	auipc	ra,0x3
    800002d0:	fec080e7          	jalr	-20(ra) # 800032b8 <either_copyout>
    800002d4:	01850863          	beq	a0,s8,800002e4 <consoleread+0xf8>
    dst++;
    800002d8:	001a0a13          	addi	s4,s4,1
    --n;
    800002dc:	fff9899b          	addiw	s3,s3,-1
    if(c == '\n'){
    800002e0:	f99d10e3          	bne	s10,s9,80000260 <consoleread+0x74>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800002e4:	00012517          	auipc	a0,0x12
    800002e8:	6bc50513          	addi	a0,a0,1724 # 800129a0 <cons>
    800002ec:	00001097          	auipc	ra,0x1
    800002f0:	dd8080e7          	jalr	-552(ra) # 800010c4 <release>

  return target - n;
    800002f4:	413b053b          	subw	a0,s6,s3
    800002f8:	0180006f          	j	80000310 <consoleread+0x124>
        release(&cons.lock);
    800002fc:	00012517          	auipc	a0,0x12
    80000300:	6a450513          	addi	a0,a0,1700 # 800129a0 <cons>
    80000304:	00001097          	auipc	ra,0x1
    80000308:	dc0080e7          	jalr	-576(ra) # 800010c4 <release>
        return -1;
    8000030c:	fff00513          	li	a0,-1
}
    80000310:	06813083          	ld	ra,104(sp)
    80000314:	06013403          	ld	s0,96(sp)
    80000318:	05813483          	ld	s1,88(sp)
    8000031c:	05013903          	ld	s2,80(sp)
    80000320:	04813983          	ld	s3,72(sp)
    80000324:	04013a03          	ld	s4,64(sp)
    80000328:	03813a83          	ld	s5,56(sp)
    8000032c:	03013b03          	ld	s6,48(sp)
    80000330:	02813b83          	ld	s7,40(sp)
    80000334:	02013c03          	ld	s8,32(sp)
    80000338:	01813c83          	ld	s9,24(sp)
    8000033c:	01013d03          	ld	s10,16(sp)
    80000340:	07010113          	addi	sp,sp,112
    80000344:	00008067          	ret
      if(n < target){
    80000348:	0009871b          	sext.w	a4,s3
    8000034c:	f9677ce3          	bgeu	a4,s6,800002e4 <consoleread+0xf8>
        cons.r--;
    80000350:	00012717          	auipc	a4,0x12
    80000354:	6ef72423          	sw	a5,1768(a4) # 80012a38 <cons+0x98>
    80000358:	f8dff06f          	j	800002e4 <consoleread+0xf8>

000000008000035c <consputc>:
{
    8000035c:	ff010113          	addi	sp,sp,-16
    80000360:	00113423          	sd	ra,8(sp)
    80000364:	00813023          	sd	s0,0(sp)
    80000368:	01010413          	addi	s0,sp,16
  if(c == BACKSPACE){
    8000036c:	10000793          	li	a5,256
    80000370:	00f50e63          	beq	a0,a5,8000038c <consputc+0x30>
    uartputc_sync(c);
    80000374:	00000097          	auipc	ra,0x0
    80000378:	6d0080e7          	jalr	1744(ra) # 80000a44 <uartputc_sync>
}
    8000037c:	00813083          	ld	ra,8(sp)
    80000380:	00013403          	ld	s0,0(sp)
    80000384:	01010113          	addi	sp,sp,16
    80000388:	00008067          	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000038c:	00800513          	li	a0,8
    80000390:	00000097          	auipc	ra,0x0
    80000394:	6b4080e7          	jalr	1716(ra) # 80000a44 <uartputc_sync>
    80000398:	02000513          	li	a0,32
    8000039c:	00000097          	auipc	ra,0x0
    800003a0:	6a8080e7          	jalr	1704(ra) # 80000a44 <uartputc_sync>
    800003a4:	00800513          	li	a0,8
    800003a8:	00000097          	auipc	ra,0x0
    800003ac:	69c080e7          	jalr	1692(ra) # 80000a44 <uartputc_sync>
    800003b0:	fcdff06f          	j	8000037c <consputc+0x20>

00000000800003b4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800003b4:	fe010113          	addi	sp,sp,-32
    800003b8:	00113c23          	sd	ra,24(sp)
    800003bc:	00813823          	sd	s0,16(sp)
    800003c0:	00913423          	sd	s1,8(sp)
    800003c4:	01213023          	sd	s2,0(sp)
    800003c8:	02010413          	addi	s0,sp,32
    800003cc:	00050493          	mv	s1,a0
  acquire(&cons.lock);
    800003d0:	00012517          	auipc	a0,0x12
    800003d4:	5d050513          	addi	a0,a0,1488 # 800129a0 <cons>
    800003d8:	00001097          	auipc	ra,0x1
    800003dc:	bf4080e7          	jalr	-1036(ra) # 80000fcc <acquire>

  switch(c){
    800003e0:	01500793          	li	a5,21
    800003e4:	0cf48663          	beq	s1,a5,800004b0 <consoleintr+0xfc>
    800003e8:	0497c263          	blt	a5,s1,8000042c <consoleintr+0x78>
    800003ec:	00800793          	li	a5,8
    800003f0:	10f48a63          	beq	s1,a5,80000504 <consoleintr+0x150>
    800003f4:	01000793          	li	a5,16
    800003f8:	12f49e63          	bne	s1,a5,80000534 <consoleintr+0x180>
  case C('P'):  // Print process list.
    procdump();
    800003fc:	00003097          	auipc	ra,0x3
    80000400:	fdc080e7          	jalr	-36(ra) # 800033d8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000404:	00012517          	auipc	a0,0x12
    80000408:	59c50513          	addi	a0,a0,1436 # 800129a0 <cons>
    8000040c:	00001097          	auipc	ra,0x1
    80000410:	cb8080e7          	jalr	-840(ra) # 800010c4 <release>
}
    80000414:	01813083          	ld	ra,24(sp)
    80000418:	01013403          	ld	s0,16(sp)
    8000041c:	00813483          	ld	s1,8(sp)
    80000420:	00013903          	ld	s2,0(sp)
    80000424:	02010113          	addi	sp,sp,32
    80000428:	00008067          	ret
  switch(c){
    8000042c:	07f00793          	li	a5,127
    80000430:	0cf48a63          	beq	s1,a5,80000504 <consoleintr+0x150>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000434:	00012717          	auipc	a4,0x12
    80000438:	56c70713          	addi	a4,a4,1388 # 800129a0 <cons>
    8000043c:	0a072783          	lw	a5,160(a4)
    80000440:	09872703          	lw	a4,152(a4)
    80000444:	40e787bb          	subw	a5,a5,a4
    80000448:	07f00713          	li	a4,127
    8000044c:	faf76ce3          	bltu	a4,a5,80000404 <consoleintr+0x50>
      c = (c == '\r') ? '\n' : c;
    80000450:	00d00793          	li	a5,13
    80000454:	0ef48463          	beq	s1,a5,8000053c <consoleintr+0x188>
      consputc(c);
    80000458:	00048513          	mv	a0,s1
    8000045c:	00000097          	auipc	ra,0x0
    80000460:	f00080e7          	jalr	-256(ra) # 8000035c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000464:	00012797          	auipc	a5,0x12
    80000468:	53c78793          	addi	a5,a5,1340 # 800129a0 <cons>
    8000046c:	0a07a703          	lw	a4,160(a5)
    80000470:	0017069b          	addiw	a3,a4,1
    80000474:	0006861b          	sext.w	a2,a3
    80000478:	0ad7a023          	sw	a3,160(a5)
    8000047c:	07f77713          	andi	a4,a4,127
    80000480:	00e787b3          	add	a5,a5,a4
    80000484:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000488:	00a00793          	li	a5,10
    8000048c:	0ef48263          	beq	s1,a5,80000570 <consoleintr+0x1bc>
    80000490:	00400793          	li	a5,4
    80000494:	0cf48e63          	beq	s1,a5,80000570 <consoleintr+0x1bc>
    80000498:	00012797          	auipc	a5,0x12
    8000049c:	5a07a783          	lw	a5,1440(a5) # 80012a38 <cons+0x98>
    800004a0:	0807879b          	addiw	a5,a5,128
    800004a4:	f6f610e3          	bne	a2,a5,80000404 <consoleintr+0x50>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800004a8:	00078613          	mv	a2,a5
    800004ac:	0c40006f          	j	80000570 <consoleintr+0x1bc>
    while(cons.e != cons.w &&
    800004b0:	00012717          	auipc	a4,0x12
    800004b4:	4f070713          	addi	a4,a4,1264 # 800129a0 <cons>
    800004b8:	0a072783          	lw	a5,160(a4)
    800004bc:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800004c0:	00012497          	auipc	s1,0x12
    800004c4:	4e048493          	addi	s1,s1,1248 # 800129a0 <cons>
    while(cons.e != cons.w &&
    800004c8:	00a00913          	li	s2,10
    800004cc:	f2f70ce3          	beq	a4,a5,80000404 <consoleintr+0x50>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800004d0:	fff7879b          	addiw	a5,a5,-1
    800004d4:	07f7f713          	andi	a4,a5,127
    800004d8:	00e48733          	add	a4,s1,a4
    while(cons.e != cons.w &&
    800004dc:	01874703          	lbu	a4,24(a4)
    800004e0:	f32702e3          	beq	a4,s2,80000404 <consoleintr+0x50>
      cons.e--;
    800004e4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800004e8:	10000513          	li	a0,256
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	e70080e7          	jalr	-400(ra) # 8000035c <consputc>
    while(cons.e != cons.w &&
    800004f4:	0a04a783          	lw	a5,160(s1)
    800004f8:	09c4a703          	lw	a4,156(s1)
    800004fc:	fcf71ae3          	bne	a4,a5,800004d0 <consoleintr+0x11c>
    80000500:	f05ff06f          	j	80000404 <consoleintr+0x50>
    if(cons.e != cons.w){
    80000504:	00012717          	auipc	a4,0x12
    80000508:	49c70713          	addi	a4,a4,1180 # 800129a0 <cons>
    8000050c:	0a072783          	lw	a5,160(a4)
    80000510:	09c72703          	lw	a4,156(a4)
    80000514:	eef708e3          	beq	a4,a5,80000404 <consoleintr+0x50>
      cons.e--;
    80000518:	fff7879b          	addiw	a5,a5,-1
    8000051c:	00012717          	auipc	a4,0x12
    80000520:	52f72223          	sw	a5,1316(a4) # 80012a40 <cons+0xa0>
      consputc(BACKSPACE);
    80000524:	10000513          	li	a0,256
    80000528:	00000097          	auipc	ra,0x0
    8000052c:	e34080e7          	jalr	-460(ra) # 8000035c <consputc>
    80000530:	ed5ff06f          	j	80000404 <consoleintr+0x50>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000534:	ec0488e3          	beqz	s1,80000404 <consoleintr+0x50>
    80000538:	efdff06f          	j	80000434 <consoleintr+0x80>
      consputc(c);
    8000053c:	00a00513          	li	a0,10
    80000540:	00000097          	auipc	ra,0x0
    80000544:	e1c080e7          	jalr	-484(ra) # 8000035c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000548:	00012797          	auipc	a5,0x12
    8000054c:	45878793          	addi	a5,a5,1112 # 800129a0 <cons>
    80000550:	0a07a703          	lw	a4,160(a5)
    80000554:	0017069b          	addiw	a3,a4,1
    80000558:	0006861b          	sext.w	a2,a3
    8000055c:	0ad7a023          	sw	a3,160(a5)
    80000560:	07f77713          	andi	a4,a4,127
    80000564:	00e787b3          	add	a5,a5,a4
    80000568:	00a00713          	li	a4,10
    8000056c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000570:	00012797          	auipc	a5,0x12
    80000574:	4cc7a623          	sw	a2,1228(a5) # 80012a3c <cons+0x9c>
        wakeup(&cons.r);
    80000578:	00012517          	auipc	a0,0x12
    8000057c:	4c050513          	addi	a0,a0,1216 # 80012a38 <cons+0x98>
    80000580:	00003097          	auipc	ra,0x3
    80000584:	a60080e7          	jalr	-1440(ra) # 80002fe0 <wakeup>
    80000588:	e7dff06f          	j	80000404 <consoleintr+0x50>

000000008000058c <consoleinit>:

void
consoleinit(void)
{
    8000058c:	ff010113          	addi	sp,sp,-16
    80000590:	00113423          	sd	ra,8(sp)
    80000594:	00813023          	sd	s0,0(sp)
    80000598:	01010413          	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000059c:	0000a597          	auipc	a1,0xa
    800005a0:	a7458593          	addi	a1,a1,-1420 # 8000a010 <etext+0x10>
    800005a4:	00012517          	auipc	a0,0x12
    800005a8:	3fc50513          	addi	a0,a0,1020 # 800129a0 <cons>
    800005ac:	00001097          	auipc	ra,0x1
    800005b0:	93c080e7          	jalr	-1732(ra) # 80000ee8 <initlock>

  uartinit();
    800005b4:	00000097          	auipc	ra,0x0
    800005b8:	42c080e7          	jalr	1068(ra) # 800009e0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800005bc:	00022797          	auipc	a5,0x22
    800005c0:	67478793          	addi	a5,a5,1652 # 80022c30 <devsw>
    800005c4:	00000717          	auipc	a4,0x0
    800005c8:	c2870713          	addi	a4,a4,-984 # 800001ec <consoleread>
    800005cc:	00e7b823          	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800005d0:	00000717          	auipc	a4,0x0
    800005d4:	b7c70713          	addi	a4,a4,-1156 # 8000014c <consolewrite>
    800005d8:	00e7bc23          	sd	a4,24(a5)
}
    800005dc:	00813083          	ld	ra,8(sp)
    800005e0:	00013403          	ld	s0,0(sp)
    800005e4:	01010113          	addi	sp,sp,16
    800005e8:	00008067          	ret

00000000800005ec <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800005ec:	fd010113          	addi	sp,sp,-48
    800005f0:	02113423          	sd	ra,40(sp)
    800005f4:	02813023          	sd	s0,32(sp)
    800005f8:	00913c23          	sd	s1,24(sp)
    800005fc:	01213823          	sd	s2,16(sp)
    80000600:	03010413          	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80000604:	00060463          	beqz	a2,8000060c <printint+0x20>
    80000608:	0a054c63          	bltz	a0,800006c0 <printint+0xd4>
    x = -xx;
  else
    x = xx;
    8000060c:	0005051b          	sext.w	a0,a0
    80000610:	00000893          	li	a7,0
    80000614:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000618:	00000713          	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000061c:	0005859b          	sext.w	a1,a1
    80000620:	0000a617          	auipc	a2,0xa
    80000624:	a2060613          	addi	a2,a2,-1504 # 8000a040 <digits>
    80000628:	00070813          	mv	a6,a4
    8000062c:	0017071b          	addiw	a4,a4,1
    80000630:	02b577bb          	remuw	a5,a0,a1
    80000634:	02079793          	slli	a5,a5,0x20
    80000638:	0207d793          	srli	a5,a5,0x20
    8000063c:	00f607b3          	add	a5,a2,a5
    80000640:	0007c783          	lbu	a5,0(a5)
    80000644:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80000648:	0005079b          	sext.w	a5,a0
    8000064c:	02b5553b          	divuw	a0,a0,a1
    80000650:	00168693          	addi	a3,a3,1
    80000654:	fcb7fae3          	bgeu	a5,a1,80000628 <printint+0x3c>

  if(sign)
    80000658:	00088c63          	beqz	a7,80000670 <printint+0x84>
    buf[i++] = '-';
    8000065c:	fe040793          	addi	a5,s0,-32
    80000660:	00e78733          	add	a4,a5,a4
    80000664:	02d00793          	li	a5,45
    80000668:	fef70823          	sb	a5,-16(a4)
    8000066c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000670:	02e05c63          	blez	a4,800006a8 <printint+0xbc>
    80000674:	fd040793          	addi	a5,s0,-48
    80000678:	00e784b3          	add	s1,a5,a4
    8000067c:	fff78913          	addi	s2,a5,-1
    80000680:	00e90933          	add	s2,s2,a4
    80000684:	fff7071b          	addiw	a4,a4,-1
    80000688:	02071713          	slli	a4,a4,0x20
    8000068c:	02075713          	srli	a4,a4,0x20
    80000690:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000694:	fff4c503          	lbu	a0,-1(s1)
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	cc4080e7          	jalr	-828(ra) # 8000035c <consputc>
  while(--i >= 0)
    800006a0:	fff48493          	addi	s1,s1,-1
    800006a4:	ff2498e3          	bne	s1,s2,80000694 <printint+0xa8>
}
    800006a8:	02813083          	ld	ra,40(sp)
    800006ac:	02013403          	ld	s0,32(sp)
    800006b0:	01813483          	ld	s1,24(sp)
    800006b4:	01013903          	ld	s2,16(sp)
    800006b8:	03010113          	addi	sp,sp,48
    800006bc:	00008067          	ret
    x = -xx;
    800006c0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    800006c4:	00100893          	li	a7,1
    x = -xx;
    800006c8:	f4dff06f          	j	80000614 <printint+0x28>

00000000800006cc <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800006cc:	fe010113          	addi	sp,sp,-32
    800006d0:	00113c23          	sd	ra,24(sp)
    800006d4:	00813823          	sd	s0,16(sp)
    800006d8:	00913423          	sd	s1,8(sp)
    800006dc:	02010413          	addi	s0,sp,32
    800006e0:	00050493          	mv	s1,a0
  pr.locking = 0;
    800006e4:	00012797          	auipc	a5,0x12
    800006e8:	3607ae23          	sw	zero,892(a5) # 80012a60 <pr+0x18>
  printf("panic: ");
    800006ec:	0000a517          	auipc	a0,0xa
    800006f0:	92c50513          	addi	a0,a0,-1748 # 8000a018 <etext+0x18>
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	034080e7          	jalr	52(ra) # 80000728 <printf>
  printf(s);
    800006fc:	00048513          	mv	a0,s1
    80000700:	00000097          	auipc	ra,0x0
    80000704:	028080e7          	jalr	40(ra) # 80000728 <printf>
  printf("\n");
    80000708:	0000a517          	auipc	a0,0xa
    8000070c:	9c050513          	addi	a0,a0,-1600 # 8000a0c8 <digits+0x88>
    80000710:	00000097          	auipc	ra,0x0
    80000714:	018080e7          	jalr	24(ra) # 80000728 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000718:	00100793          	li	a5,1
    8000071c:	0000a717          	auipc	a4,0xa
    80000720:	10f72223          	sw	a5,260(a4) # 8000a820 <panicked>
  for(;;)
    80000724:	0000006f          	j	80000724 <panic+0x58>

0000000080000728 <printf>:
{
    80000728:	f4010113          	addi	sp,sp,-192
    8000072c:	06113c23          	sd	ra,120(sp)
    80000730:	06813823          	sd	s0,112(sp)
    80000734:	06913423          	sd	s1,104(sp)
    80000738:	07213023          	sd	s2,96(sp)
    8000073c:	05313c23          	sd	s3,88(sp)
    80000740:	05413823          	sd	s4,80(sp)
    80000744:	05513423          	sd	s5,72(sp)
    80000748:	05613023          	sd	s6,64(sp)
    8000074c:	03713c23          	sd	s7,56(sp)
    80000750:	03813823          	sd	s8,48(sp)
    80000754:	03913423          	sd	s9,40(sp)
    80000758:	03a13023          	sd	s10,32(sp)
    8000075c:	01b13c23          	sd	s11,24(sp)
    80000760:	08010413          	addi	s0,sp,128
    80000764:	00050a13          	mv	s4,a0
    80000768:	00b43423          	sd	a1,8(s0)
    8000076c:	00c43823          	sd	a2,16(s0)
    80000770:	00d43c23          	sd	a3,24(s0)
    80000774:	02e43023          	sd	a4,32(s0)
    80000778:	02f43423          	sd	a5,40(s0)
    8000077c:	03043823          	sd	a6,48(s0)
    80000780:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80000784:	00012d97          	auipc	s11,0x12
    80000788:	2dcdad83          	lw	s11,732(s11) # 80012a60 <pr+0x18>
  if(locking)
    8000078c:	020d9e63          	bnez	s11,800007c8 <printf+0xa0>
  if (fmt == 0)
    80000790:	040a0663          	beqz	s4,800007dc <printf+0xb4>
  va_start(ap, fmt);
    80000794:	00840793          	addi	a5,s0,8
    80000798:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000079c:	000a4503          	lbu	a0,0(s4)
    800007a0:	1a050063          	beqz	a0,80000940 <printf+0x218>
    800007a4:	00000993          	li	s3,0
    if(c != '%'){
    800007a8:	02500a93          	li	s5,37
    switch(c){
    800007ac:	07000b93          	li	s7,112
  consputc('x');
    800007b0:	01000d13          	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800007b4:	0000ab17          	auipc	s6,0xa
    800007b8:	88cb0b13          	addi	s6,s6,-1908 # 8000a040 <digits>
    switch(c){
    800007bc:	07300c93          	li	s9,115
    800007c0:	06400c13          	li	s8,100
    800007c4:	0400006f          	j	80000804 <printf+0xdc>
    acquire(&pr.lock);
    800007c8:	00012517          	auipc	a0,0x12
    800007cc:	28050513          	addi	a0,a0,640 # 80012a48 <pr>
    800007d0:	00000097          	auipc	ra,0x0
    800007d4:	7fc080e7          	jalr	2044(ra) # 80000fcc <acquire>
    800007d8:	fb9ff06f          	j	80000790 <printf+0x68>
    panic("null fmt");
    800007dc:	0000a517          	auipc	a0,0xa
    800007e0:	84c50513          	addi	a0,a0,-1972 # 8000a028 <etext+0x28>
    800007e4:	00000097          	auipc	ra,0x0
    800007e8:	ee8080e7          	jalr	-280(ra) # 800006cc <panic>
      consputc(c);
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	b70080e7          	jalr	-1168(ra) # 8000035c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800007f4:	0019899b          	addiw	s3,s3,1
    800007f8:	013a07b3          	add	a5,s4,s3
    800007fc:	0007c503          	lbu	a0,0(a5)
    80000800:	14050063          	beqz	a0,80000940 <printf+0x218>
    if(c != '%'){
    80000804:	ff5514e3          	bne	a0,s5,800007ec <printf+0xc4>
    c = fmt[++i] & 0xff;
    80000808:	0019899b          	addiw	s3,s3,1
    8000080c:	013a07b3          	add	a5,s4,s3
    80000810:	0007c783          	lbu	a5,0(a5)
    80000814:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000818:	12078463          	beqz	a5,80000940 <printf+0x218>
    switch(c){
    8000081c:	07778263          	beq	a5,s7,80000880 <printf+0x158>
    80000820:	02fbfa63          	bgeu	s7,a5,80000854 <printf+0x12c>
    80000824:	0b978663          	beq	a5,s9,800008d0 <printf+0x1a8>
    80000828:	07800713          	li	a4,120
    8000082c:	0ee79c63          	bne	a5,a4,80000924 <printf+0x1fc>
      printint(va_arg(ap, int), 16, 1);
    80000830:	f8843783          	ld	a5,-120(s0)
    80000834:	00878713          	addi	a4,a5,8
    80000838:	f8e43423          	sd	a4,-120(s0)
    8000083c:	00100613          	li	a2,1
    80000840:	000d0593          	mv	a1,s10
    80000844:	0007a503          	lw	a0,0(a5)
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	da4080e7          	jalr	-604(ra) # 800005ec <printint>
      break;
    80000850:	fa5ff06f          	j	800007f4 <printf+0xcc>
    switch(c){
    80000854:	0d578063          	beq	a5,s5,80000914 <printf+0x1ec>
    80000858:	0d879663          	bne	a5,s8,80000924 <printf+0x1fc>
      printint(va_arg(ap, int), 10, 1);
    8000085c:	f8843783          	ld	a5,-120(s0)
    80000860:	00878713          	addi	a4,a5,8
    80000864:	f8e43423          	sd	a4,-120(s0)
    80000868:	00100613          	li	a2,1
    8000086c:	00a00593          	li	a1,10
    80000870:	0007a503          	lw	a0,0(a5)
    80000874:	00000097          	auipc	ra,0x0
    80000878:	d78080e7          	jalr	-648(ra) # 800005ec <printint>
      break;
    8000087c:	f79ff06f          	j	800007f4 <printf+0xcc>
      printptr(va_arg(ap, uint64));
    80000880:	f8843783          	ld	a5,-120(s0)
    80000884:	00878713          	addi	a4,a5,8
    80000888:	f8e43423          	sd	a4,-120(s0)
    8000088c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80000890:	03000513          	li	a0,48
    80000894:	00000097          	auipc	ra,0x0
    80000898:	ac8080e7          	jalr	-1336(ra) # 8000035c <consputc>
  consputc('x');
    8000089c:	07800513          	li	a0,120
    800008a0:	00000097          	auipc	ra,0x0
    800008a4:	abc080e7          	jalr	-1348(ra) # 8000035c <consputc>
    800008a8:	000d0493          	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800008ac:	03c95793          	srli	a5,s2,0x3c
    800008b0:	00fb07b3          	add	a5,s6,a5
    800008b4:	0007c503          	lbu	a0,0(a5)
    800008b8:	00000097          	auipc	ra,0x0
    800008bc:	aa4080e7          	jalr	-1372(ra) # 8000035c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800008c0:	00491913          	slli	s2,s2,0x4
    800008c4:	fff4849b          	addiw	s1,s1,-1
    800008c8:	fe0492e3          	bnez	s1,800008ac <printf+0x184>
    800008cc:	f29ff06f          	j	800007f4 <printf+0xcc>
      if((s = va_arg(ap, char*)) == 0)
    800008d0:	f8843783          	ld	a5,-120(s0)
    800008d4:	00878713          	addi	a4,a5,8
    800008d8:	f8e43423          	sd	a4,-120(s0)
    800008dc:	0007b483          	ld	s1,0(a5)
    800008e0:	02048263          	beqz	s1,80000904 <printf+0x1dc>
      for(; *s; s++)
    800008e4:	0004c503          	lbu	a0,0(s1)
    800008e8:	f00506e3          	beqz	a0,800007f4 <printf+0xcc>
        consputc(*s);
    800008ec:	00000097          	auipc	ra,0x0
    800008f0:	a70080e7          	jalr	-1424(ra) # 8000035c <consputc>
      for(; *s; s++)
    800008f4:	00148493          	addi	s1,s1,1
    800008f8:	0004c503          	lbu	a0,0(s1)
    800008fc:	fe0518e3          	bnez	a0,800008ec <printf+0x1c4>
    80000900:	ef5ff06f          	j	800007f4 <printf+0xcc>
        s = "(null)";
    80000904:	00009497          	auipc	s1,0x9
    80000908:	71c48493          	addi	s1,s1,1820 # 8000a020 <etext+0x20>
      for(; *s; s++)
    8000090c:	02800513          	li	a0,40
    80000910:	fddff06f          	j	800008ec <printf+0x1c4>
      consputc('%');
    80000914:	000a8513          	mv	a0,s5
    80000918:	00000097          	auipc	ra,0x0
    8000091c:	a44080e7          	jalr	-1468(ra) # 8000035c <consputc>
      break;
    80000920:	ed5ff06f          	j	800007f4 <printf+0xcc>
      consputc('%');
    80000924:	000a8513          	mv	a0,s5
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	a34080e7          	jalr	-1484(ra) # 8000035c <consputc>
      consputc(c);
    80000930:	00048513          	mv	a0,s1
    80000934:	00000097          	auipc	ra,0x0
    80000938:	a28080e7          	jalr	-1496(ra) # 8000035c <consputc>
      break;
    8000093c:	eb9ff06f          	j	800007f4 <printf+0xcc>
  if(locking)
    80000940:	040d9063          	bnez	s11,80000980 <printf+0x258>
}
    80000944:	07813083          	ld	ra,120(sp)
    80000948:	07013403          	ld	s0,112(sp)
    8000094c:	06813483          	ld	s1,104(sp)
    80000950:	06013903          	ld	s2,96(sp)
    80000954:	05813983          	ld	s3,88(sp)
    80000958:	05013a03          	ld	s4,80(sp)
    8000095c:	04813a83          	ld	s5,72(sp)
    80000960:	04013b03          	ld	s6,64(sp)
    80000964:	03813b83          	ld	s7,56(sp)
    80000968:	03013c03          	ld	s8,48(sp)
    8000096c:	02813c83          	ld	s9,40(sp)
    80000970:	02013d03          	ld	s10,32(sp)
    80000974:	01813d83          	ld	s11,24(sp)
    80000978:	0c010113          	addi	sp,sp,192
    8000097c:	00008067          	ret
    release(&pr.lock);
    80000980:	00012517          	auipc	a0,0x12
    80000984:	0c850513          	addi	a0,a0,200 # 80012a48 <pr>
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	73c080e7          	jalr	1852(ra) # 800010c4 <release>
}
    80000990:	fb5ff06f          	j	80000944 <printf+0x21c>

0000000080000994 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000994:	fe010113          	addi	sp,sp,-32
    80000998:	00113c23          	sd	ra,24(sp)
    8000099c:	00813823          	sd	s0,16(sp)
    800009a0:	00913423          	sd	s1,8(sp)
    800009a4:	02010413          	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800009a8:	00012497          	auipc	s1,0x12
    800009ac:	0a048493          	addi	s1,s1,160 # 80012a48 <pr>
    800009b0:	00009597          	auipc	a1,0x9
    800009b4:	68858593          	addi	a1,a1,1672 # 8000a038 <etext+0x38>
    800009b8:	00048513          	mv	a0,s1
    800009bc:	00000097          	auipc	ra,0x0
    800009c0:	52c080e7          	jalr	1324(ra) # 80000ee8 <initlock>
  pr.locking = 1;
    800009c4:	00100793          	li	a5,1
    800009c8:	00f4ac23          	sw	a5,24(s1)
}
    800009cc:	01813083          	ld	ra,24(sp)
    800009d0:	01013403          	ld	s0,16(sp)
    800009d4:	00813483          	ld	s1,8(sp)
    800009d8:	02010113          	addi	sp,sp,32
    800009dc:	00008067          	ret

00000000800009e0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800009e0:	ff010113          	addi	sp,sp,-16
    800009e4:	00113423          	sd	ra,8(sp)
    800009e8:	00813023          	sd	s0,0(sp)
    800009ec:	01010413          	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800009f0:	100007b7          	lui	a5,0x10000
    800009f4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800009f8:	f8000713          	li	a4,-128
    800009fc:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000a00:	00300713          	li	a4,3
    80000a04:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000a08:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000a0c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000a10:	00700693          	li	a3,7
    80000a14:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000a18:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000a1c:	00009597          	auipc	a1,0x9
    80000a20:	63c58593          	addi	a1,a1,1596 # 8000a058 <digits+0x18>
    80000a24:	00012517          	auipc	a0,0x12
    80000a28:	04450513          	addi	a0,a0,68 # 80012a68 <uart_tx_lock>
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	4bc080e7          	jalr	1212(ra) # 80000ee8 <initlock>
}
    80000a34:	00813083          	ld	ra,8(sp)
    80000a38:	00013403          	ld	s0,0(sp)
    80000a3c:	01010113          	addi	sp,sp,16
    80000a40:	00008067          	ret

0000000080000a44 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000a44:	fe010113          	addi	sp,sp,-32
    80000a48:	00113c23          	sd	ra,24(sp)
    80000a4c:	00813823          	sd	s0,16(sp)
    80000a50:	00913423          	sd	s1,8(sp)
    80000a54:	02010413          	addi	s0,sp,32
    80000a58:	00050493          	mv	s1,a0
  push_off();
    80000a5c:	00000097          	auipc	ra,0x0
    80000a60:	4fc080e7          	jalr	1276(ra) # 80000f58 <push_off>

  if(panicked){
    80000a64:	0000a797          	auipc	a5,0xa
    80000a68:	dbc7a783          	lw	a5,-580(a5) # 8000a820 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000a6c:	10000737          	lui	a4,0x10000
  if(panicked){
    80000a70:	00078463          	beqz	a5,80000a78 <uartputc_sync+0x34>
    for(;;)
    80000a74:	0000006f          	j	80000a74 <uartputc_sync+0x30>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000a78:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000a7c:	0207f793          	andi	a5,a5,32
    80000a80:	fe078ce3          	beqz	a5,80000a78 <uartputc_sync+0x34>
    ;
  WriteReg(THR, c);
    80000a84:	0ff4f513          	andi	a0,s1,255
    80000a88:	100007b7          	lui	a5,0x10000
    80000a8c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000a90:	00000097          	auipc	ra,0x0
    80000a94:	5b4080e7          	jalr	1460(ra) # 80001044 <pop_off>
}
    80000a98:	01813083          	ld	ra,24(sp)
    80000a9c:	01013403          	ld	s0,16(sp)
    80000aa0:	00813483          	ld	s1,8(sp)
    80000aa4:	02010113          	addi	sp,sp,32
    80000aa8:	00008067          	ret

0000000080000aac <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000aac:	0000a797          	auipc	a5,0xa
    80000ab0:	d7c7b783          	ld	a5,-644(a5) # 8000a828 <uart_tx_r>
    80000ab4:	0000a717          	auipc	a4,0xa
    80000ab8:	d7c73703          	ld	a4,-644(a4) # 8000a830 <uart_tx_w>
    80000abc:	0af70263          	beq	a4,a5,80000b60 <uartstart+0xb4>
{
    80000ac0:	fc010113          	addi	sp,sp,-64
    80000ac4:	02113c23          	sd	ra,56(sp)
    80000ac8:	02813823          	sd	s0,48(sp)
    80000acc:	02913423          	sd	s1,40(sp)
    80000ad0:	03213023          	sd	s2,32(sp)
    80000ad4:	01313c23          	sd	s3,24(sp)
    80000ad8:	01413823          	sd	s4,16(sp)
    80000adc:	01513423          	sd	s5,8(sp)
    80000ae0:	04010413          	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000ae4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000ae8:	00012a17          	auipc	s4,0x12
    80000aec:	f80a0a13          	addi	s4,s4,-128 # 80012a68 <uart_tx_lock>
    uart_tx_r += 1;
    80000af0:	0000a497          	auipc	s1,0xa
    80000af4:	d3848493          	addi	s1,s1,-712 # 8000a828 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000af8:	0000a997          	auipc	s3,0xa
    80000afc:	d3898993          	addi	s3,s3,-712 # 8000a830 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000b00:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000b04:	02077713          	andi	a4,a4,32
    80000b08:	02070a63          	beqz	a4,80000b3c <uartstart+0x90>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000b0c:	01f7f713          	andi	a4,a5,31
    80000b10:	00ea0733          	add	a4,s4,a4
    80000b14:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000b18:	00178793          	addi	a5,a5,1
    80000b1c:	00f4b023          	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000b20:	00048513          	mv	a0,s1
    80000b24:	00002097          	auipc	ra,0x2
    80000b28:	4bc080e7          	jalr	1212(ra) # 80002fe0 <wakeup>
    
    WriteReg(THR, c);
    80000b2c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80000b30:	0004b783          	ld	a5,0(s1)
    80000b34:	0009b703          	ld	a4,0(s3)
    80000b38:	fcf714e3          	bne	a4,a5,80000b00 <uartstart+0x54>
  }
}
    80000b3c:	03813083          	ld	ra,56(sp)
    80000b40:	03013403          	ld	s0,48(sp)
    80000b44:	02813483          	ld	s1,40(sp)
    80000b48:	02013903          	ld	s2,32(sp)
    80000b4c:	01813983          	ld	s3,24(sp)
    80000b50:	01013a03          	ld	s4,16(sp)
    80000b54:	00813a83          	ld	s5,8(sp)
    80000b58:	04010113          	addi	sp,sp,64
    80000b5c:	00008067          	ret
    80000b60:	00008067          	ret

0000000080000b64 <uartputc>:
{
    80000b64:	fd010113          	addi	sp,sp,-48
    80000b68:	02113423          	sd	ra,40(sp)
    80000b6c:	02813023          	sd	s0,32(sp)
    80000b70:	00913c23          	sd	s1,24(sp)
    80000b74:	01213823          	sd	s2,16(sp)
    80000b78:	01313423          	sd	s3,8(sp)
    80000b7c:	01413023          	sd	s4,0(sp)
    80000b80:	03010413          	addi	s0,sp,48
    80000b84:	00050a13          	mv	s4,a0
  acquire(&uart_tx_lock);
    80000b88:	00012517          	auipc	a0,0x12
    80000b8c:	ee050513          	addi	a0,a0,-288 # 80012a68 <uart_tx_lock>
    80000b90:	00000097          	auipc	ra,0x0
    80000b94:	43c080e7          	jalr	1084(ra) # 80000fcc <acquire>
  if(panicked){
    80000b98:	0000a797          	auipc	a5,0xa
    80000b9c:	c887a783          	lw	a5,-888(a5) # 8000a820 <panicked>
    80000ba0:	00078463          	beqz	a5,80000ba8 <uartputc+0x44>
    for(;;)
    80000ba4:	0000006f          	j	80000ba4 <uartputc+0x40>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000ba8:	0000a717          	auipc	a4,0xa
    80000bac:	c8873703          	ld	a4,-888(a4) # 8000a830 <uart_tx_w>
    80000bb0:	0000a797          	auipc	a5,0xa
    80000bb4:	c787b783          	ld	a5,-904(a5) # 8000a828 <uart_tx_r>
    80000bb8:	02078793          	addi	a5,a5,32
    80000bbc:	02e79e63          	bne	a5,a4,80000bf8 <uartputc+0x94>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000bc0:	00012997          	auipc	s3,0x12
    80000bc4:	ea898993          	addi	s3,s3,-344 # 80012a68 <uart_tx_lock>
    80000bc8:	0000a497          	auipc	s1,0xa
    80000bcc:	c6048493          	addi	s1,s1,-928 # 8000a828 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000bd0:	0000a917          	auipc	s2,0xa
    80000bd4:	c6090913          	addi	s2,s2,-928 # 8000a830 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000bd8:	00098593          	mv	a1,s3
    80000bdc:	00048513          	mv	a0,s1
    80000be0:	00002097          	auipc	ra,0x2
    80000be4:	1e0080e7          	jalr	480(ra) # 80002dc0 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000be8:	00093703          	ld	a4,0(s2)
    80000bec:	0004b783          	ld	a5,0(s1)
    80000bf0:	02078793          	addi	a5,a5,32
    80000bf4:	fee782e3          	beq	a5,a4,80000bd8 <uartputc+0x74>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000bf8:	00012497          	auipc	s1,0x12
    80000bfc:	e7048493          	addi	s1,s1,-400 # 80012a68 <uart_tx_lock>
    80000c00:	01f77793          	andi	a5,a4,31
    80000c04:	00f487b3          	add	a5,s1,a5
    80000c08:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000c0c:	00170713          	addi	a4,a4,1
    80000c10:	0000a797          	auipc	a5,0xa
    80000c14:	c2e7b023          	sd	a4,-992(a5) # 8000a830 <uart_tx_w>
      uartstart();
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	e94080e7          	jalr	-364(ra) # 80000aac <uartstart>
      release(&uart_tx_lock);
    80000c20:	00048513          	mv	a0,s1
    80000c24:	00000097          	auipc	ra,0x0
    80000c28:	4a0080e7          	jalr	1184(ra) # 800010c4 <release>
}
    80000c2c:	02813083          	ld	ra,40(sp)
    80000c30:	02013403          	ld	s0,32(sp)
    80000c34:	01813483          	ld	s1,24(sp)
    80000c38:	01013903          	ld	s2,16(sp)
    80000c3c:	00813983          	ld	s3,8(sp)
    80000c40:	00013a03          	ld	s4,0(sp)
    80000c44:	03010113          	addi	sp,sp,48
    80000c48:	00008067          	ret

0000000080000c4c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000c4c:	ff010113          	addi	sp,sp,-16
    80000c50:	00813423          	sd	s0,8(sp)
    80000c54:	01010413          	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000c58:	100007b7          	lui	a5,0x10000
    80000c5c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000c60:	0017f793          	andi	a5,a5,1
    80000c64:	00078e63          	beqz	a5,80000c80 <uartgetc+0x34>
    // input data is ready.
    return ReadReg(RHR);
    80000c68:	100007b7          	lui	a5,0x10000
    80000c6c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000c70:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80000c74:	00813403          	ld	s0,8(sp)
    80000c78:	01010113          	addi	sp,sp,16
    80000c7c:	00008067          	ret
    return -1;
    80000c80:	fff00513          	li	a0,-1
    80000c84:	ff1ff06f          	j	80000c74 <uartgetc+0x28>

0000000080000c88 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000c88:	fe010113          	addi	sp,sp,-32
    80000c8c:	00113c23          	sd	ra,24(sp)
    80000c90:	00813823          	sd	s0,16(sp)
    80000c94:	00913423          	sd	s1,8(sp)
    80000c98:	02010413          	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000c9c:	fff00493          	li	s1,-1
    80000ca0:	00c0006f          	j	80000cac <uartintr+0x24>
      break;
    consoleintr(c);
    80000ca4:	fffff097          	auipc	ra,0xfffff
    80000ca8:	710080e7          	jalr	1808(ra) # 800003b4 <consoleintr>
    int c = uartgetc();
    80000cac:	00000097          	auipc	ra,0x0
    80000cb0:	fa0080e7          	jalr	-96(ra) # 80000c4c <uartgetc>
    if(c == -1)
    80000cb4:	fe9518e3          	bne	a0,s1,80000ca4 <uartintr+0x1c>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000cb8:	00012497          	auipc	s1,0x12
    80000cbc:	db048493          	addi	s1,s1,-592 # 80012a68 <uart_tx_lock>
    80000cc0:	00048513          	mv	a0,s1
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	308080e7          	jalr	776(ra) # 80000fcc <acquire>
  uartstart();
    80000ccc:	00000097          	auipc	ra,0x0
    80000cd0:	de0080e7          	jalr	-544(ra) # 80000aac <uartstart>
  release(&uart_tx_lock);
    80000cd4:	00048513          	mv	a0,s1
    80000cd8:	00000097          	auipc	ra,0x0
    80000cdc:	3ec080e7          	jalr	1004(ra) # 800010c4 <release>
}
    80000ce0:	01813083          	ld	ra,24(sp)
    80000ce4:	01013403          	ld	s0,16(sp)
    80000ce8:	00813483          	ld	s1,8(sp)
    80000cec:	02010113          	addi	sp,sp,32
    80000cf0:	00008067          	ret

0000000080000cf4 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000cf4:	fe010113          	addi	sp,sp,-32
    80000cf8:	00113c23          	sd	ra,24(sp)
    80000cfc:	00813823          	sd	s0,16(sp)
    80000d00:	00913423          	sd	s1,8(sp)
    80000d04:	01213023          	sd	s2,0(sp)
    80000d08:	02010413          	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000d0c:	03451793          	slli	a5,a0,0x34
    80000d10:	06079a63          	bnez	a5,80000d84 <kfree+0x90>
    80000d14:	00050493          	mv	s1,a0
    80000d18:	00023797          	auipc	a5,0x23
    80000d1c:	f7078793          	addi	a5,a5,-144 # 80023c88 <end>
    80000d20:	06f56263          	bltu	a0,a5,80000d84 <kfree+0x90>
    80000d24:	01100793          	li	a5,17
    80000d28:	01b79793          	slli	a5,a5,0x1b
    80000d2c:	04f57c63          	bgeu	a0,a5,80000d84 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000d30:	00001637          	lui	a2,0x1
    80000d34:	00100593          	li	a1,1
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	3ec080e7          	jalr	1004(ra) # 80001124 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000d40:	00012917          	auipc	s2,0x12
    80000d44:	d6090913          	addi	s2,s2,-672 # 80012aa0 <kmem>
    80000d48:	00090513          	mv	a0,s2
    80000d4c:	00000097          	auipc	ra,0x0
    80000d50:	280080e7          	jalr	640(ra) # 80000fcc <acquire>
  r->next = kmem.freelist;
    80000d54:	01893783          	ld	a5,24(s2)
    80000d58:	00f4b023          	sd	a5,0(s1)
  kmem.freelist = r;
    80000d5c:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000d60:	00090513          	mv	a0,s2
    80000d64:	00000097          	auipc	ra,0x0
    80000d68:	360080e7          	jalr	864(ra) # 800010c4 <release>
}
    80000d6c:	01813083          	ld	ra,24(sp)
    80000d70:	01013403          	ld	s0,16(sp)
    80000d74:	00813483          	ld	s1,8(sp)
    80000d78:	00013903          	ld	s2,0(sp)
    80000d7c:	02010113          	addi	sp,sp,32
    80000d80:	00008067          	ret
    panic("kfree");
    80000d84:	00009517          	auipc	a0,0x9
    80000d88:	2dc50513          	addi	a0,a0,732 # 8000a060 <digits+0x20>
    80000d8c:	00000097          	auipc	ra,0x0
    80000d90:	940080e7          	jalr	-1728(ra) # 800006cc <panic>

0000000080000d94 <freerange>:
{
    80000d94:	fd010113          	addi	sp,sp,-48
    80000d98:	02113423          	sd	ra,40(sp)
    80000d9c:	02813023          	sd	s0,32(sp)
    80000da0:	00913c23          	sd	s1,24(sp)
    80000da4:	01213823          	sd	s2,16(sp)
    80000da8:	01313423          	sd	s3,8(sp)
    80000dac:	01413023          	sd	s4,0(sp)
    80000db0:	03010413          	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000db4:	000017b7          	lui	a5,0x1
    80000db8:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000dbc:	009504b3          	add	s1,a0,s1
    80000dc0:	fffff537          	lui	a0,0xfffff
    80000dc4:	00a4f4b3          	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000dc8:	00f484b3          	add	s1,s1,a5
    80000dcc:	0295e263          	bltu	a1,s1,80000df0 <freerange+0x5c>
    80000dd0:	00058913          	mv	s2,a1
    kfree(p);
    80000dd4:	fffffa37          	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000dd8:	000019b7          	lui	s3,0x1
    kfree(p);
    80000ddc:	01448533          	add	a0,s1,s4
    80000de0:	00000097          	auipc	ra,0x0
    80000de4:	f14080e7          	jalr	-236(ra) # 80000cf4 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000de8:	013484b3          	add	s1,s1,s3
    80000dec:	fe9978e3          	bgeu	s2,s1,80000ddc <freerange+0x48>
}
    80000df0:	02813083          	ld	ra,40(sp)
    80000df4:	02013403          	ld	s0,32(sp)
    80000df8:	01813483          	ld	s1,24(sp)
    80000dfc:	01013903          	ld	s2,16(sp)
    80000e00:	00813983          	ld	s3,8(sp)
    80000e04:	00013a03          	ld	s4,0(sp)
    80000e08:	03010113          	addi	sp,sp,48
    80000e0c:	00008067          	ret

0000000080000e10 <kinit>:
{
    80000e10:	ff010113          	addi	sp,sp,-16
    80000e14:	00113423          	sd	ra,8(sp)
    80000e18:	00813023          	sd	s0,0(sp)
    80000e1c:	01010413          	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000e20:	00009597          	auipc	a1,0x9
    80000e24:	24858593          	addi	a1,a1,584 # 8000a068 <digits+0x28>
    80000e28:	00012517          	auipc	a0,0x12
    80000e2c:	c7850513          	addi	a0,a0,-904 # 80012aa0 <kmem>
    80000e30:	00000097          	auipc	ra,0x0
    80000e34:	0b8080e7          	jalr	184(ra) # 80000ee8 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000e38:	01100593          	li	a1,17
    80000e3c:	01b59593          	slli	a1,a1,0x1b
    80000e40:	00023517          	auipc	a0,0x23
    80000e44:	e4850513          	addi	a0,a0,-440 # 80023c88 <end>
    80000e48:	00000097          	auipc	ra,0x0
    80000e4c:	f4c080e7          	jalr	-180(ra) # 80000d94 <freerange>
}
    80000e50:	00813083          	ld	ra,8(sp)
    80000e54:	00013403          	ld	s0,0(sp)
    80000e58:	01010113          	addi	sp,sp,16
    80000e5c:	00008067          	ret

0000000080000e60 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000e60:	fe010113          	addi	sp,sp,-32
    80000e64:	00113c23          	sd	ra,24(sp)
    80000e68:	00813823          	sd	s0,16(sp)
    80000e6c:	00913423          	sd	s1,8(sp)
    80000e70:	02010413          	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000e74:	00012497          	auipc	s1,0x12
    80000e78:	c2c48493          	addi	s1,s1,-980 # 80012aa0 <kmem>
    80000e7c:	00048513          	mv	a0,s1
    80000e80:	00000097          	auipc	ra,0x0
    80000e84:	14c080e7          	jalr	332(ra) # 80000fcc <acquire>
  r = kmem.freelist;
    80000e88:	0184b483          	ld	s1,24(s1)
  if(r)
    80000e8c:	04048463          	beqz	s1,80000ed4 <kalloc+0x74>
    kmem.freelist = r->next;
    80000e90:	0004b783          	ld	a5,0(s1)
    80000e94:	00012517          	auipc	a0,0x12
    80000e98:	c0c50513          	addi	a0,a0,-1012 # 80012aa0 <kmem>
    80000e9c:	00f53c23          	sd	a5,24(a0)
  release(&kmem.lock);
    80000ea0:	00000097          	auipc	ra,0x0
    80000ea4:	224080e7          	jalr	548(ra) # 800010c4 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000ea8:	00001637          	lui	a2,0x1
    80000eac:	00500593          	li	a1,5
    80000eb0:	00048513          	mv	a0,s1
    80000eb4:	00000097          	auipc	ra,0x0
    80000eb8:	270080e7          	jalr	624(ra) # 80001124 <memset>
  return (void*)r;
}
    80000ebc:	00048513          	mv	a0,s1
    80000ec0:	01813083          	ld	ra,24(sp)
    80000ec4:	01013403          	ld	s0,16(sp)
    80000ec8:	00813483          	ld	s1,8(sp)
    80000ecc:	02010113          	addi	sp,sp,32
    80000ed0:	00008067          	ret
  release(&kmem.lock);
    80000ed4:	00012517          	auipc	a0,0x12
    80000ed8:	bcc50513          	addi	a0,a0,-1076 # 80012aa0 <kmem>
    80000edc:	00000097          	auipc	ra,0x0
    80000ee0:	1e8080e7          	jalr	488(ra) # 800010c4 <release>
  if(r)
    80000ee4:	fd9ff06f          	j	80000ebc <kalloc+0x5c>

0000000080000ee8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000ee8:	ff010113          	addi	sp,sp,-16
    80000eec:	00813423          	sd	s0,8(sp)
    80000ef0:	01010413          	addi	s0,sp,16
  lk->name = name;
    80000ef4:	00b53423          	sd	a1,8(a0)
  lk->locked = 0;
    80000ef8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000efc:	00053823          	sd	zero,16(a0)
}
    80000f00:	00813403          	ld	s0,8(sp)
    80000f04:	01010113          	addi	sp,sp,16
    80000f08:	00008067          	ret

0000000080000f0c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000f0c:	00052783          	lw	a5,0(a0)
    80000f10:	00079663          	bnez	a5,80000f1c <holding+0x10>
    80000f14:	00000513          	li	a0,0
  return r;
}
    80000f18:	00008067          	ret
{
    80000f1c:	fe010113          	addi	sp,sp,-32
    80000f20:	00113c23          	sd	ra,24(sp)
    80000f24:	00813823          	sd	s0,16(sp)
    80000f28:	00913423          	sd	s1,8(sp)
    80000f2c:	02010413          	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000f30:	01053483          	ld	s1,16(a0)
    80000f34:	00001097          	auipc	ra,0x1
    80000f38:	4ec080e7          	jalr	1260(ra) # 80002420 <mycpu>
    80000f3c:	40a48533          	sub	a0,s1,a0
    80000f40:	00153513          	seqz	a0,a0
}
    80000f44:	01813083          	ld	ra,24(sp)
    80000f48:	01013403          	ld	s0,16(sp)
    80000f4c:	00813483          	ld	s1,8(sp)
    80000f50:	02010113          	addi	sp,sp,32
    80000f54:	00008067          	ret

0000000080000f58 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000f58:	fe010113          	addi	sp,sp,-32
    80000f5c:	00113c23          	sd	ra,24(sp)
    80000f60:	00813823          	sd	s0,16(sp)
    80000f64:	00913423          	sd	s1,8(sp)
    80000f68:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000f6c:	100024f3          	csrr	s1,sstatus
    80000f70:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000f74:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000f78:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000f7c:	00001097          	auipc	ra,0x1
    80000f80:	4a4080e7          	jalr	1188(ra) # 80002420 <mycpu>
    80000f84:	07852783          	lw	a5,120(a0)
    80000f88:	02078663          	beqz	a5,80000fb4 <push_off+0x5c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000f8c:	00001097          	auipc	ra,0x1
    80000f90:	494080e7          	jalr	1172(ra) # 80002420 <mycpu>
    80000f94:	07852783          	lw	a5,120(a0)
    80000f98:	0017879b          	addiw	a5,a5,1
    80000f9c:	06f52c23          	sw	a5,120(a0)
}
    80000fa0:	01813083          	ld	ra,24(sp)
    80000fa4:	01013403          	ld	s0,16(sp)
    80000fa8:	00813483          	ld	s1,8(sp)
    80000fac:	02010113          	addi	sp,sp,32
    80000fb0:	00008067          	ret
    mycpu()->intena = old;
    80000fb4:	00001097          	auipc	ra,0x1
    80000fb8:	46c080e7          	jalr	1132(ra) # 80002420 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000fbc:	0014d493          	srli	s1,s1,0x1
    80000fc0:	0014f493          	andi	s1,s1,1
    80000fc4:	06952e23          	sw	s1,124(a0)
    80000fc8:	fc5ff06f          	j	80000f8c <push_off+0x34>

0000000080000fcc <acquire>:
{
    80000fcc:	fe010113          	addi	sp,sp,-32
    80000fd0:	00113c23          	sd	ra,24(sp)
    80000fd4:	00813823          	sd	s0,16(sp)
    80000fd8:	00913423          	sd	s1,8(sp)
    80000fdc:	02010413          	addi	s0,sp,32
    80000fe0:	00050493          	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000fe4:	00000097          	auipc	ra,0x0
    80000fe8:	f74080e7          	jalr	-140(ra) # 80000f58 <push_off>
  if(holding(lk))
    80000fec:	00048513          	mv	a0,s1
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	f1c080e7          	jalr	-228(ra) # 80000f0c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000ff8:	00100713          	li	a4,1
  if(holding(lk))
    80000ffc:	02051c63          	bnez	a0,80001034 <acquire+0x68>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80001000:	00070793          	mv	a5,a4
    80001004:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80001008:	0007879b          	sext.w	a5,a5
    8000100c:	fe079ae3          	bnez	a5,80001000 <acquire+0x34>
  __sync_synchronize();
    80001010:	0ff0000f          	fence
  lk->cpu = mycpu();
    80001014:	00001097          	auipc	ra,0x1
    80001018:	40c080e7          	jalr	1036(ra) # 80002420 <mycpu>
    8000101c:	00a4b823          	sd	a0,16(s1)
}
    80001020:	01813083          	ld	ra,24(sp)
    80001024:	01013403          	ld	s0,16(sp)
    80001028:	00813483          	ld	s1,8(sp)
    8000102c:	02010113          	addi	sp,sp,32
    80001030:	00008067          	ret
    panic("acquire");
    80001034:	00009517          	auipc	a0,0x9
    80001038:	03c50513          	addi	a0,a0,60 # 8000a070 <digits+0x30>
    8000103c:	fffff097          	auipc	ra,0xfffff
    80001040:	690080e7          	jalr	1680(ra) # 800006cc <panic>

0000000080001044 <pop_off>:

void
pop_off(void)
{
    80001044:	ff010113          	addi	sp,sp,-16
    80001048:	00113423          	sd	ra,8(sp)
    8000104c:	00813023          	sd	s0,0(sp)
    80001050:	01010413          	addi	s0,sp,16
  struct cpu *c = mycpu();
    80001054:	00001097          	auipc	ra,0x1
    80001058:	3cc080e7          	jalr	972(ra) # 80002420 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000105c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001060:	0027f793          	andi	a5,a5,2
  if(intr_get())
    80001064:	04079063          	bnez	a5,800010a4 <pop_off+0x60>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80001068:	07852783          	lw	a5,120(a0)
    8000106c:	04f05463          	blez	a5,800010b4 <pop_off+0x70>
    panic("pop_off");
  c->noff -= 1;
    80001070:	fff7879b          	addiw	a5,a5,-1
    80001074:	0007871b          	sext.w	a4,a5
    80001078:	06f52c23          	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000107c:	00071c63          	bnez	a4,80001094 <pop_off+0x50>
    80001080:	07c52783          	lw	a5,124(a0)
    80001084:	00078863          	beqz	a5,80001094 <pop_off+0x50>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001088:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000108c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001090:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80001094:	00813083          	ld	ra,8(sp)
    80001098:	00013403          	ld	s0,0(sp)
    8000109c:	01010113          	addi	sp,sp,16
    800010a0:	00008067          	ret
    panic("pop_off - interruptible");
    800010a4:	00009517          	auipc	a0,0x9
    800010a8:	fd450513          	addi	a0,a0,-44 # 8000a078 <digits+0x38>
    800010ac:	fffff097          	auipc	ra,0xfffff
    800010b0:	620080e7          	jalr	1568(ra) # 800006cc <panic>
    panic("pop_off");
    800010b4:	00009517          	auipc	a0,0x9
    800010b8:	fdc50513          	addi	a0,a0,-36 # 8000a090 <digits+0x50>
    800010bc:	fffff097          	auipc	ra,0xfffff
    800010c0:	610080e7          	jalr	1552(ra) # 800006cc <panic>

00000000800010c4 <release>:
{
    800010c4:	fe010113          	addi	sp,sp,-32
    800010c8:	00113c23          	sd	ra,24(sp)
    800010cc:	00813823          	sd	s0,16(sp)
    800010d0:	00913423          	sd	s1,8(sp)
    800010d4:	02010413          	addi	s0,sp,32
    800010d8:	00050493          	mv	s1,a0
  if(!holding(lk))
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	e30080e7          	jalr	-464(ra) # 80000f0c <holding>
    800010e4:	02050863          	beqz	a0,80001114 <release+0x50>
  lk->cpu = 0;
    800010e8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800010ec:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800010f0:	0f50000f          	fence	iorw,ow
    800010f4:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800010f8:	00000097          	auipc	ra,0x0
    800010fc:	f4c080e7          	jalr	-180(ra) # 80001044 <pop_off>
}
    80001100:	01813083          	ld	ra,24(sp)
    80001104:	01013403          	ld	s0,16(sp)
    80001108:	00813483          	ld	s1,8(sp)
    8000110c:	02010113          	addi	sp,sp,32
    80001110:	00008067          	ret
    panic("release");
    80001114:	00009517          	auipc	a0,0x9
    80001118:	f8450513          	addi	a0,a0,-124 # 8000a098 <digits+0x58>
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	5b0080e7          	jalr	1456(ra) # 800006cc <panic>

0000000080001124 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80001124:	ff010113          	addi	sp,sp,-16
    80001128:	00813423          	sd	s0,8(sp)
    8000112c:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80001130:	02060063          	beqz	a2,80001150 <memset+0x2c>
    80001134:	00050793          	mv	a5,a0
    80001138:	02061613          	slli	a2,a2,0x20
    8000113c:	02065613          	srli	a2,a2,0x20
    80001140:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80001144:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80001148:	00178793          	addi	a5,a5,1
    8000114c:	fee79ce3          	bne	a5,a4,80001144 <memset+0x20>
  }
  return dst;
}
    80001150:	00813403          	ld	s0,8(sp)
    80001154:	01010113          	addi	sp,sp,16
    80001158:	00008067          	ret

000000008000115c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000115c:	ff010113          	addi	sp,sp,-16
    80001160:	00813423          	sd	s0,8(sp)
    80001164:	01010413          	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80001168:	04060463          	beqz	a2,800011b0 <memcmp+0x54>
    8000116c:	fff6069b          	addiw	a3,a2,-1
    80001170:	02069693          	slli	a3,a3,0x20
    80001174:	0206d693          	srli	a3,a3,0x20
    80001178:	00168693          	addi	a3,a3,1
    8000117c:	00d506b3          	add	a3,a0,a3
    if(*s1 != *s2)
    80001180:	00054783          	lbu	a5,0(a0)
    80001184:	0005c703          	lbu	a4,0(a1)
    80001188:	00e79c63          	bne	a5,a4,800011a0 <memcmp+0x44>
      return *s1 - *s2;
    s1++, s2++;
    8000118c:	00150513          	addi	a0,a0,1
    80001190:	00158593          	addi	a1,a1,1
  while(n-- > 0){
    80001194:	fed516e3          	bne	a0,a3,80001180 <memcmp+0x24>
  }

  return 0;
    80001198:	00000513          	li	a0,0
    8000119c:	0080006f          	j	800011a4 <memcmp+0x48>
      return *s1 - *s2;
    800011a0:	40e7853b          	subw	a0,a5,a4
}
    800011a4:	00813403          	ld	s0,8(sp)
    800011a8:	01010113          	addi	sp,sp,16
    800011ac:	00008067          	ret
  return 0;
    800011b0:	00000513          	li	a0,0
    800011b4:	ff1ff06f          	j	800011a4 <memcmp+0x48>

00000000800011b8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800011b8:	ff010113          	addi	sp,sp,-16
    800011bc:	00813423          	sd	s0,8(sp)
    800011c0:	01010413          	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800011c4:	02060663          	beqz	a2,800011f0 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800011c8:	02a5ea63          	bltu	a1,a0,800011fc <memmove+0x44>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800011cc:	02061613          	slli	a2,a2,0x20
    800011d0:	02065613          	srli	a2,a2,0x20
    800011d4:	00c587b3          	add	a5,a1,a2
{
    800011d8:	00050713          	mv	a4,a0
      *d++ = *s++;
    800011dc:	00158593          	addi	a1,a1,1
    800011e0:	00170713          	addi	a4,a4,1
    800011e4:	fff5c683          	lbu	a3,-1(a1)
    800011e8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800011ec:	fef598e3          	bne	a1,a5,800011dc <memmove+0x24>

  return dst;
}
    800011f0:	00813403          	ld	s0,8(sp)
    800011f4:	01010113          	addi	sp,sp,16
    800011f8:	00008067          	ret
  if(s < d && s + n > d){
    800011fc:	02061693          	slli	a3,a2,0x20
    80001200:	0206d693          	srli	a3,a3,0x20
    80001204:	00d58733          	add	a4,a1,a3
    80001208:	fce572e3          	bgeu	a0,a4,800011cc <memmove+0x14>
    d += n;
    8000120c:	00d506b3          	add	a3,a0,a3
    while(n-- > 0)
    80001210:	fff6079b          	addiw	a5,a2,-1
    80001214:	02079793          	slli	a5,a5,0x20
    80001218:	0207d793          	srli	a5,a5,0x20
    8000121c:	fff7c793          	not	a5,a5
    80001220:	00f707b3          	add	a5,a4,a5
      *--d = *--s;
    80001224:	fff70713          	addi	a4,a4,-1
    80001228:	fff68693          	addi	a3,a3,-1
    8000122c:	00074603          	lbu	a2,0(a4)
    80001230:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80001234:	fee798e3          	bne	a5,a4,80001224 <memmove+0x6c>
    80001238:	fb9ff06f          	j	800011f0 <memmove+0x38>

000000008000123c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000123c:	ff010113          	addi	sp,sp,-16
    80001240:	00113423          	sd	ra,8(sp)
    80001244:	00813023          	sd	s0,0(sp)
    80001248:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	f6c080e7          	jalr	-148(ra) # 800011b8 <memmove>
}
    80001254:	00813083          	ld	ra,8(sp)
    80001258:	00013403          	ld	s0,0(sp)
    8000125c:	01010113          	addi	sp,sp,16
    80001260:	00008067          	ret

0000000080001264 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80001264:	ff010113          	addi	sp,sp,-16
    80001268:	00813423          	sd	s0,8(sp)
    8000126c:	01010413          	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80001270:	02060663          	beqz	a2,8000129c <strncmp+0x38>
    80001274:	00054783          	lbu	a5,0(a0)
    80001278:	02078663          	beqz	a5,800012a4 <strncmp+0x40>
    8000127c:	0005c703          	lbu	a4,0(a1)
    80001280:	02f71263          	bne	a4,a5,800012a4 <strncmp+0x40>
    n--, p++, q++;
    80001284:	fff6061b          	addiw	a2,a2,-1
    80001288:	00150513          	addi	a0,a0,1
    8000128c:	00158593          	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80001290:	fe0612e3          	bnez	a2,80001274 <strncmp+0x10>
  if(n == 0)
    return 0;
    80001294:	00000513          	li	a0,0
    80001298:	01c0006f          	j	800012b4 <strncmp+0x50>
    8000129c:	00000513          	li	a0,0
    800012a0:	0140006f          	j	800012b4 <strncmp+0x50>
  if(n == 0)
    800012a4:	00060e63          	beqz	a2,800012c0 <strncmp+0x5c>
  return (uchar)*p - (uchar)*q;
    800012a8:	00054503          	lbu	a0,0(a0)
    800012ac:	0005c783          	lbu	a5,0(a1)
    800012b0:	40f5053b          	subw	a0,a0,a5
}
    800012b4:	00813403          	ld	s0,8(sp)
    800012b8:	01010113          	addi	sp,sp,16
    800012bc:	00008067          	ret
    return 0;
    800012c0:	00000513          	li	a0,0
    800012c4:	ff1ff06f          	j	800012b4 <strncmp+0x50>

00000000800012c8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800012c8:	ff010113          	addi	sp,sp,-16
    800012cc:	00813423          	sd	s0,8(sp)
    800012d0:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800012d4:	00050713          	mv	a4,a0
    800012d8:	00060813          	mv	a6,a2
    800012dc:	fff6061b          	addiw	a2,a2,-1
    800012e0:	01005c63          	blez	a6,800012f8 <strncpy+0x30>
    800012e4:	00170713          	addi	a4,a4,1
    800012e8:	0005c783          	lbu	a5,0(a1)
    800012ec:	fef70fa3          	sb	a5,-1(a4)
    800012f0:	00158593          	addi	a1,a1,1
    800012f4:	fe0792e3          	bnez	a5,800012d8 <strncpy+0x10>
    ;
  while(n-- > 0)
    800012f8:	00070693          	mv	a3,a4
    800012fc:	00c05e63          	blez	a2,80001318 <strncpy+0x50>
    *s++ = 0;
    80001300:	00168693          	addi	a3,a3,1
    80001304:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80001308:	fff6c793          	not	a5,a3
    8000130c:	00e787bb          	addw	a5,a5,a4
    80001310:	010787bb          	addw	a5,a5,a6
    80001314:	fef046e3          	bgtz	a5,80001300 <strncpy+0x38>
  return os;
}
    80001318:	00813403          	ld	s0,8(sp)
    8000131c:	01010113          	addi	sp,sp,16
    80001320:	00008067          	ret

0000000080001324 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80001324:	ff010113          	addi	sp,sp,-16
    80001328:	00813423          	sd	s0,8(sp)
    8000132c:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80001330:	02c05a63          	blez	a2,80001364 <safestrcpy+0x40>
    80001334:	fff6069b          	addiw	a3,a2,-1
    80001338:	02069693          	slli	a3,a3,0x20
    8000133c:	0206d693          	srli	a3,a3,0x20
    80001340:	00d586b3          	add	a3,a1,a3
    80001344:	00050793          	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80001348:	00d58c63          	beq	a1,a3,80001360 <safestrcpy+0x3c>
    8000134c:	00158593          	addi	a1,a1,1
    80001350:	00178793          	addi	a5,a5,1
    80001354:	fff5c703          	lbu	a4,-1(a1)
    80001358:	fee78fa3          	sb	a4,-1(a5)
    8000135c:	fe0716e3          	bnez	a4,80001348 <safestrcpy+0x24>
    ;
  *s = 0;
    80001360:	00078023          	sb	zero,0(a5)
  return os;
}
    80001364:	00813403          	ld	s0,8(sp)
    80001368:	01010113          	addi	sp,sp,16
    8000136c:	00008067          	ret

0000000080001370 <strlen>:

int
strlen(const char *s)
{
    80001370:	ff010113          	addi	sp,sp,-16
    80001374:	00813423          	sd	s0,8(sp)
    80001378:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000137c:	00054783          	lbu	a5,0(a0)
    80001380:	02078863          	beqz	a5,800013b0 <strlen+0x40>
    80001384:	00150513          	addi	a0,a0,1
    80001388:	00050793          	mv	a5,a0
    8000138c:	00100693          	li	a3,1
    80001390:	40a686bb          	subw	a3,a3,a0
    80001394:	00f6853b          	addw	a0,a3,a5
    80001398:	00178793          	addi	a5,a5,1
    8000139c:	fff7c703          	lbu	a4,-1(a5)
    800013a0:	fe071ae3          	bnez	a4,80001394 <strlen+0x24>
    ;
  return n;
}
    800013a4:	00813403          	ld	s0,8(sp)
    800013a8:	01010113          	addi	sp,sp,16
    800013ac:	00008067          	ret
  for(n = 0; s[n]; n++)
    800013b0:	00000513          	li	a0,0
    800013b4:	ff1ff06f          	j	800013a4 <strlen+0x34>

00000000800013b8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800013b8:	ff010113          	addi	sp,sp,-16
    800013bc:	00113423          	sd	ra,8(sp)
    800013c0:	00813023          	sd	s0,0(sp)
    800013c4:	01010413          	addi	s0,sp,16
  if(cpuid() == 0){
    800013c8:	00001097          	auipc	ra,0x1
    800013cc:	038080e7          	jalr	56(ra) # 80002400 <cpuid>
    ramdiskinit();   // disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800013d0:	00009717          	auipc	a4,0x9
    800013d4:	46870713          	addi	a4,a4,1128 # 8000a838 <started>
  if(cpuid() == 0){
    800013d8:	04050863          	beqz	a0,80001428 <main+0x70>
    while(started == 0)
    800013dc:	00072783          	lw	a5,0(a4)
    800013e0:	0007879b          	sext.w	a5,a5
    800013e4:	fe078ce3          	beqz	a5,800013dc <main+0x24>
      ;
    __sync_synchronize();
    800013e8:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800013ec:	00001097          	auipc	ra,0x1
    800013f0:	014080e7          	jalr	20(ra) # 80002400 <cpuid>
    800013f4:	00050593          	mv	a1,a0
    800013f8:	00009517          	auipc	a0,0x9
    800013fc:	cc050513          	addi	a0,a0,-832 # 8000a0b8 <digits+0x78>
    80001400:	fffff097          	auipc	ra,0xfffff
    80001404:	328080e7          	jalr	808(ra) # 80000728 <printf>
    kvminithart();    // turn on paging
    80001408:	00000097          	auipc	ra,0x0
    8000140c:	0dc080e7          	jalr	220(ra) # 800014e4 <kvminithart>
    trapinithart();   // install kernel trap vector
    80001410:	00002097          	auipc	ra,0x2
    80001414:	168080e7          	jalr	360(ra) # 80003578 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001418:	00007097          	auipc	ra,0x7
    8000141c:	b8c080e7          	jalr	-1140(ra) # 80007fa4 <plicinithart>
  }

  scheduler();        
    80001420:	00001097          	auipc	ra,0x1
    80001424:	758080e7          	jalr	1880(ra) # 80002b78 <scheduler>
    consoleinit();
    80001428:	fffff097          	auipc	ra,0xfffff
    8000142c:	164080e7          	jalr	356(ra) # 8000058c <consoleinit>
    printfinit();
    80001430:	fffff097          	auipc	ra,0xfffff
    80001434:	564080e7          	jalr	1380(ra) # 80000994 <printfinit>
    printf("\n");
    80001438:	00009517          	auipc	a0,0x9
    8000143c:	c9050513          	addi	a0,a0,-880 # 8000a0c8 <digits+0x88>
    80001440:	fffff097          	auipc	ra,0xfffff
    80001444:	2e8080e7          	jalr	744(ra) # 80000728 <printf>
    printf("xv6 kernel is booting\n");
    80001448:	00009517          	auipc	a0,0x9
    8000144c:	c5850513          	addi	a0,a0,-936 # 8000a0a0 <digits+0x60>
    80001450:	fffff097          	auipc	ra,0xfffff
    80001454:	2d8080e7          	jalr	728(ra) # 80000728 <printf>
    printf("\n");
    80001458:	00009517          	auipc	a0,0x9
    8000145c:	c7050513          	addi	a0,a0,-912 # 8000a0c8 <digits+0x88>
    80001460:	fffff097          	auipc	ra,0xfffff
    80001464:	2c8080e7          	jalr	712(ra) # 80000728 <printf>
    kinit();         // physical page allocator
    80001468:	00000097          	auipc	ra,0x0
    8000146c:	9a8080e7          	jalr	-1624(ra) # 80000e10 <kinit>
    kvminit();       // create kernel page table
    80001470:	00000097          	auipc	ra,0x0
    80001474:	484080e7          	jalr	1156(ra) # 800018f4 <kvminit>
    kvminithart();   // turn on paging
    80001478:	00000097          	auipc	ra,0x0
    8000147c:	06c080e7          	jalr	108(ra) # 800014e4 <kvminithart>
    procinit();      // process table
    80001480:	00001097          	auipc	ra,0x1
    80001484:	e98080e7          	jalr	-360(ra) # 80002318 <procinit>
    trapinit();      // trap vectors
    80001488:	00002097          	auipc	ra,0x2
    8000148c:	0b8080e7          	jalr	184(ra) # 80003540 <trapinit>
    trapinithart();  // install kernel trap vector
    80001490:	00002097          	auipc	ra,0x2
    80001494:	0e8080e7          	jalr	232(ra) # 80003578 <trapinithart>
    plicinit();      // set up interrupt controller
    80001498:	00007097          	auipc	ra,0x7
    8000149c:	ae8080e7          	jalr	-1304(ra) # 80007f80 <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800014a0:	00007097          	auipc	ra,0x7
    800014a4:	b04080e7          	jalr	-1276(ra) # 80007fa4 <plicinithart>
    binit();         // buffer cache
    800014a8:	00003097          	auipc	ra,0x3
    800014ac:	b20080e7          	jalr	-1248(ra) # 80003fc8 <binit>
    iinit();         // inode table
    800014b0:	00003097          	auipc	ra,0x3
    800014b4:	3f4080e7          	jalr	1012(ra) # 800048a4 <iinit>
    fileinit();      // file table
    800014b8:	00005097          	auipc	ra,0x5
    800014bc:	9e4080e7          	jalr	-1564(ra) # 80005e9c <fileinit>
    ramdiskinit();   // disk
    800014c0:	00005097          	auipc	ra,0x5
    800014c4:	3ec080e7          	jalr	1004(ra) # 800068ac <ramdiskinit>
    userinit();      // first user process
    800014c8:	00001097          	auipc	ra,0x1
    800014cc:	3ac080e7          	jalr	940(ra) # 80002874 <userinit>
    __sync_synchronize();
    800014d0:	0ff0000f          	fence
    started = 1;
    800014d4:	00100793          	li	a5,1
    800014d8:	00009717          	auipc	a4,0x9
    800014dc:	36f72023          	sw	a5,864(a4) # 8000a838 <started>
    800014e0:	f41ff06f          	j	80001420 <main+0x68>

00000000800014e4 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800014e4:	ff010113          	addi	sp,sp,-16
    800014e8:	00813423          	sd	s0,8(sp)
    800014ec:	01010413          	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800014f0:	00009797          	auipc	a5,0x9
    800014f4:	3507b783          	ld	a5,848(a5) # 8000a840 <kernel_pagetable>
    800014f8:	00c7d793          	srli	a5,a5,0xc
    800014fc:	fff00713          	li	a4,-1
    80001500:	03f71713          	slli	a4,a4,0x3f
    80001504:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001508:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000150c:	12000073          	sfence.vma
  sfence_vma();
}
    80001510:	00813403          	ld	s0,8(sp)
    80001514:	01010113          	addi	sp,sp,16
    80001518:	00008067          	ret

000000008000151c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000151c:	fc010113          	addi	sp,sp,-64
    80001520:	02113c23          	sd	ra,56(sp)
    80001524:	02813823          	sd	s0,48(sp)
    80001528:	02913423          	sd	s1,40(sp)
    8000152c:	03213023          	sd	s2,32(sp)
    80001530:	01313c23          	sd	s3,24(sp)
    80001534:	01413823          	sd	s4,16(sp)
    80001538:	01513423          	sd	s5,8(sp)
    8000153c:	01613023          	sd	s6,0(sp)
    80001540:	04010413          	addi	s0,sp,64
    80001544:	00050493          	mv	s1,a0
    80001548:	00058993          	mv	s3,a1
    8000154c:	00060a93          	mv	s5,a2
  if(va >= MAXVA)
    80001550:	fff00793          	li	a5,-1
    80001554:	01a7d793          	srli	a5,a5,0x1a
    80001558:	01e00a13          	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000155c:	00c00b13          	li	s6,12
  if(va >= MAXVA)
    80001560:	04b7f863          	bgeu	a5,a1,800015b0 <walk+0x94>
    panic("walk");
    80001564:	00009517          	auipc	a0,0x9
    80001568:	b6c50513          	addi	a0,a0,-1172 # 8000a0d0 <digits+0x90>
    8000156c:	fffff097          	auipc	ra,0xfffff
    80001570:	160080e7          	jalr	352(ra) # 800006cc <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001574:	080a8e63          	beqz	s5,80001610 <walk+0xf4>
    80001578:	00000097          	auipc	ra,0x0
    8000157c:	8e8080e7          	jalr	-1816(ra) # 80000e60 <kalloc>
    80001580:	00050493          	mv	s1,a0
    80001584:	06050263          	beqz	a0,800015e8 <walk+0xcc>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001588:	00001637          	lui	a2,0x1
    8000158c:	00000593          	li	a1,0
    80001590:	00000097          	auipc	ra,0x0
    80001594:	b94080e7          	jalr	-1132(ra) # 80001124 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001598:	00c4d793          	srli	a5,s1,0xc
    8000159c:	00a79793          	slli	a5,a5,0xa
    800015a0:	0017e793          	ori	a5,a5,1
    800015a4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800015a8:	ff7a0a1b          	addiw	s4,s4,-9
    800015ac:	036a0663          	beq	s4,s6,800015d8 <walk+0xbc>
    pte_t *pte = &pagetable[PX(level, va)];
    800015b0:	0149d933          	srl	s2,s3,s4
    800015b4:	1ff97913          	andi	s2,s2,511
    800015b8:	00391913          	slli	s2,s2,0x3
    800015bc:	01248933          	add	s2,s1,s2
    if(*pte & PTE_V) {
    800015c0:	00093483          	ld	s1,0(s2)
    800015c4:	0014f793          	andi	a5,s1,1
    800015c8:	fa0786e3          	beqz	a5,80001574 <walk+0x58>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800015cc:	00a4d493          	srli	s1,s1,0xa
    800015d0:	00c49493          	slli	s1,s1,0xc
    800015d4:	fd5ff06f          	j	800015a8 <walk+0x8c>
    }
  }
  return &pagetable[PX(0, va)];
    800015d8:	00c9d513          	srli	a0,s3,0xc
    800015dc:	1ff57513          	andi	a0,a0,511
    800015e0:	00351513          	slli	a0,a0,0x3
    800015e4:	00a48533          	add	a0,s1,a0
}
    800015e8:	03813083          	ld	ra,56(sp)
    800015ec:	03013403          	ld	s0,48(sp)
    800015f0:	02813483          	ld	s1,40(sp)
    800015f4:	02013903          	ld	s2,32(sp)
    800015f8:	01813983          	ld	s3,24(sp)
    800015fc:	01013a03          	ld	s4,16(sp)
    80001600:	00813a83          	ld	s5,8(sp)
    80001604:	00013b03          	ld	s6,0(sp)
    80001608:	04010113          	addi	sp,sp,64
    8000160c:	00008067          	ret
        return 0;
    80001610:	00000513          	li	a0,0
    80001614:	fd5ff06f          	j	800015e8 <walk+0xcc>

0000000080001618 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001618:	fff00793          	li	a5,-1
    8000161c:	01a7d793          	srli	a5,a5,0x1a
    80001620:	00b7f663          	bgeu	a5,a1,8000162c <walkaddr+0x14>
    return 0;
    80001624:	00000513          	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001628:	00008067          	ret
{
    8000162c:	ff010113          	addi	sp,sp,-16
    80001630:	00113423          	sd	ra,8(sp)
    80001634:	00813023          	sd	s0,0(sp)
    80001638:	01010413          	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000163c:	00000613          	li	a2,0
    80001640:	00000097          	auipc	ra,0x0
    80001644:	edc080e7          	jalr	-292(ra) # 8000151c <walk>
  if(pte == 0)
    80001648:	02050a63          	beqz	a0,8000167c <walkaddr+0x64>
  if((*pte & PTE_V) == 0)
    8000164c:	00053783          	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001650:	0117f693          	andi	a3,a5,17
    80001654:	01100713          	li	a4,17
    return 0;
    80001658:	00000513          	li	a0,0
  if((*pte & PTE_U) == 0)
    8000165c:	00e68a63          	beq	a3,a4,80001670 <walkaddr+0x58>
}
    80001660:	00813083          	ld	ra,8(sp)
    80001664:	00013403          	ld	s0,0(sp)
    80001668:	01010113          	addi	sp,sp,16
    8000166c:	00008067          	ret
  pa = PTE2PA(*pte);
    80001670:	00a7d513          	srli	a0,a5,0xa
    80001674:	00c51513          	slli	a0,a0,0xc
  return pa;
    80001678:	fe9ff06f          	j	80001660 <walkaddr+0x48>
    return 0;
    8000167c:	00000513          	li	a0,0
    80001680:	fe1ff06f          	j	80001660 <walkaddr+0x48>

0000000080001684 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001684:	fb010113          	addi	sp,sp,-80
    80001688:	04113423          	sd	ra,72(sp)
    8000168c:	04813023          	sd	s0,64(sp)
    80001690:	02913c23          	sd	s1,56(sp)
    80001694:	03213823          	sd	s2,48(sp)
    80001698:	03313423          	sd	s3,40(sp)
    8000169c:	03413023          	sd	s4,32(sp)
    800016a0:	01513c23          	sd	s5,24(sp)
    800016a4:	01613823          	sd	s6,16(sp)
    800016a8:	01713423          	sd	s7,8(sp)
    800016ac:	05010413          	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800016b0:	06060a63          	beqz	a2,80001724 <mappages+0xa0>
    800016b4:	00050a93          	mv	s5,a0
    800016b8:	00070b13          	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800016bc:	fffff7b7          	lui	a5,0xfffff
    800016c0:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800016c4:	fff58593          	addi	a1,a1,-1
    800016c8:	00c589b3          	add	s3,a1,a2
    800016cc:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800016d0:	000a0913          	mv	s2,s4
    800016d4:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800016d8:	00001bb7          	lui	s7,0x1
    800016dc:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800016e0:	00100613          	li	a2,1
    800016e4:	00090593          	mv	a1,s2
    800016e8:	000a8513          	mv	a0,s5
    800016ec:	00000097          	auipc	ra,0x0
    800016f0:	e30080e7          	jalr	-464(ra) # 8000151c <walk>
    800016f4:	04050863          	beqz	a0,80001744 <mappages+0xc0>
    if(*pte & PTE_V)
    800016f8:	00053783          	ld	a5,0(a0)
    800016fc:	0017f793          	andi	a5,a5,1
    80001700:	02079a63          	bnez	a5,80001734 <mappages+0xb0>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001704:	00c4d493          	srli	s1,s1,0xc
    80001708:	00a49493          	slli	s1,s1,0xa
    8000170c:	0164e4b3          	or	s1,s1,s6
    80001710:	0014e493          	ori	s1,s1,1
    80001714:	00953023          	sd	s1,0(a0)
    if(a == last)
    80001718:	05390e63          	beq	s2,s3,80001774 <mappages+0xf0>
    a += PGSIZE;
    8000171c:	01790933          	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001720:	fbdff06f          	j	800016dc <mappages+0x58>
    panic("mappages: size");
    80001724:	00009517          	auipc	a0,0x9
    80001728:	9b450513          	addi	a0,a0,-1612 # 8000a0d8 <digits+0x98>
    8000172c:	fffff097          	auipc	ra,0xfffff
    80001730:	fa0080e7          	jalr	-96(ra) # 800006cc <panic>
      panic("mappages: remap");
    80001734:	00009517          	auipc	a0,0x9
    80001738:	9b450513          	addi	a0,a0,-1612 # 8000a0e8 <digits+0xa8>
    8000173c:	fffff097          	auipc	ra,0xfffff
    80001740:	f90080e7          	jalr	-112(ra) # 800006cc <panic>
      return -1;
    80001744:	fff00513          	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001748:	04813083          	ld	ra,72(sp)
    8000174c:	04013403          	ld	s0,64(sp)
    80001750:	03813483          	ld	s1,56(sp)
    80001754:	03013903          	ld	s2,48(sp)
    80001758:	02813983          	ld	s3,40(sp)
    8000175c:	02013a03          	ld	s4,32(sp)
    80001760:	01813a83          	ld	s5,24(sp)
    80001764:	01013b03          	ld	s6,16(sp)
    80001768:	00813b83          	ld	s7,8(sp)
    8000176c:	05010113          	addi	sp,sp,80
    80001770:	00008067          	ret
  return 0;
    80001774:	00000513          	li	a0,0
    80001778:	fd1ff06f          	j	80001748 <mappages+0xc4>

000000008000177c <kvmmap>:
{
    8000177c:	ff010113          	addi	sp,sp,-16
    80001780:	00113423          	sd	ra,8(sp)
    80001784:	00813023          	sd	s0,0(sp)
    80001788:	01010413          	addi	s0,sp,16
    8000178c:	00068793          	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001790:	00060693          	mv	a3,a2
    80001794:	00078613          	mv	a2,a5
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	eec080e7          	jalr	-276(ra) # 80001684 <mappages>
    800017a0:	00051a63          	bnez	a0,800017b4 <kvmmap+0x38>
}
    800017a4:	00813083          	ld	ra,8(sp)
    800017a8:	00013403          	ld	s0,0(sp)
    800017ac:	01010113          	addi	sp,sp,16
    800017b0:	00008067          	ret
    panic("kvmmap");
    800017b4:	00009517          	auipc	a0,0x9
    800017b8:	94450513          	addi	a0,a0,-1724 # 8000a0f8 <digits+0xb8>
    800017bc:	fffff097          	auipc	ra,0xfffff
    800017c0:	f10080e7          	jalr	-240(ra) # 800006cc <panic>

00000000800017c4 <kvmmake>:
{
    800017c4:	fd010113          	addi	sp,sp,-48
    800017c8:	02113423          	sd	ra,40(sp)
    800017cc:	02813023          	sd	s0,32(sp)
    800017d0:	00913c23          	sd	s1,24(sp)
    800017d4:	01213823          	sd	s2,16(sp)
    800017d8:	01313423          	sd	s3,8(sp)
    800017dc:	03010413          	addi	s0,sp,48
  kpgtbl = (pagetable_t) kalloc();
    800017e0:	fffff097          	auipc	ra,0xfffff
    800017e4:	680080e7          	jalr	1664(ra) # 80000e60 <kalloc>
    800017e8:	00050493          	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800017ec:	00001637          	lui	a2,0x1
    800017f0:	00000593          	li	a1,0
    800017f4:	00000097          	auipc	ra,0x0
    800017f8:	930080e7          	jalr	-1744(ra) # 80001124 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800017fc:	00600713          	li	a4,6
    80001800:	000016b7          	lui	a3,0x1
    80001804:	10000637          	lui	a2,0x10000
    80001808:	100005b7          	lui	a1,0x10000
    8000180c:	00048513          	mv	a0,s1
    80001810:	00000097          	auipc	ra,0x0
    80001814:	f6c080e7          	jalr	-148(ra) # 8000177c <kvmmap>
  kvmmap(kpgtbl, RAMDISK, RAMDISK, FSSIZE * BSIZE, PTE_R | PTE_W);
    80001818:	00600713          	li	a4,6
    8000181c:	000fa6b7          	lui	a3,0xfa
    80001820:	01100913          	li	s2,17
    80001824:	01b91613          	slli	a2,s2,0x1b
    80001828:	00060593          	mv	a1,a2
    8000182c:	00048513          	mv	a0,s1
    80001830:	00000097          	auipc	ra,0x0
    80001834:	f4c080e7          	jalr	-180(ra) # 8000177c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001838:	00600713          	li	a4,6
    8000183c:	004006b7          	lui	a3,0x400
    80001840:	0c000637          	lui	a2,0xc000
    80001844:	0c0005b7          	lui	a1,0xc000
    80001848:	00048513          	mv	a0,s1
    8000184c:	00000097          	auipc	ra,0x0
    80001850:	f30080e7          	jalr	-208(ra) # 8000177c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001854:	00008997          	auipc	s3,0x8
    80001858:	7ac98993          	addi	s3,s3,1964 # 8000a000 <etext>
    8000185c:	00a00713          	li	a4,10
    80001860:	80008697          	auipc	a3,0x80008
    80001864:	7a068693          	addi	a3,a3,1952 # a000 <_entry-0x7fff6000>
    80001868:	00100613          	li	a2,1
    8000186c:	01f61613          	slli	a2,a2,0x1f
    80001870:	00060593          	mv	a1,a2
    80001874:	00048513          	mv	a0,s1
    80001878:	00000097          	auipc	ra,0x0
    8000187c:	f04080e7          	jalr	-252(ra) # 8000177c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001880:	01b91693          	slli	a3,s2,0x1b
    80001884:	00600713          	li	a4,6
    80001888:	413686b3          	sub	a3,a3,s3
    8000188c:	00098613          	mv	a2,s3
    80001890:	00098593          	mv	a1,s3
    80001894:	00048513          	mv	a0,s1
    80001898:	00000097          	auipc	ra,0x0
    8000189c:	ee4080e7          	jalr	-284(ra) # 8000177c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800018a0:	00a00713          	li	a4,10
    800018a4:	000016b7          	lui	a3,0x1
    800018a8:	00007617          	auipc	a2,0x7
    800018ac:	75860613          	addi	a2,a2,1880 # 80009000 <_trampoline>
    800018b0:	040005b7          	lui	a1,0x4000
    800018b4:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800018b8:	00c59593          	slli	a1,a1,0xc
    800018bc:	00048513          	mv	a0,s1
    800018c0:	00000097          	auipc	ra,0x0
    800018c4:	ebc080e7          	jalr	-324(ra) # 8000177c <kvmmap>
  proc_mapstacks(kpgtbl);
    800018c8:	00048513          	mv	a0,s1
    800018cc:	00001097          	auipc	ra,0x1
    800018d0:	978080e7          	jalr	-1672(ra) # 80002244 <proc_mapstacks>
}
    800018d4:	00048513          	mv	a0,s1
    800018d8:	02813083          	ld	ra,40(sp)
    800018dc:	02013403          	ld	s0,32(sp)
    800018e0:	01813483          	ld	s1,24(sp)
    800018e4:	01013903          	ld	s2,16(sp)
    800018e8:	00813983          	ld	s3,8(sp)
    800018ec:	03010113          	addi	sp,sp,48
    800018f0:	00008067          	ret

00000000800018f4 <kvminit>:
{
    800018f4:	ff010113          	addi	sp,sp,-16
    800018f8:	00113423          	sd	ra,8(sp)
    800018fc:	00813023          	sd	s0,0(sp)
    80001900:	01010413          	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001904:	00000097          	auipc	ra,0x0
    80001908:	ec0080e7          	jalr	-320(ra) # 800017c4 <kvmmake>
    8000190c:	00009797          	auipc	a5,0x9
    80001910:	f2a7ba23          	sd	a0,-204(a5) # 8000a840 <kernel_pagetable>
}
    80001914:	00813083          	ld	ra,8(sp)
    80001918:	00013403          	ld	s0,0(sp)
    8000191c:	01010113          	addi	sp,sp,16
    80001920:	00008067          	ret

0000000080001924 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001924:	fb010113          	addi	sp,sp,-80
    80001928:	04113423          	sd	ra,72(sp)
    8000192c:	04813023          	sd	s0,64(sp)
    80001930:	02913c23          	sd	s1,56(sp)
    80001934:	03213823          	sd	s2,48(sp)
    80001938:	03313423          	sd	s3,40(sp)
    8000193c:	03413023          	sd	s4,32(sp)
    80001940:	01513c23          	sd	s5,24(sp)
    80001944:	01613823          	sd	s6,16(sp)
    80001948:	01713423          	sd	s7,8(sp)
    8000194c:	05010413          	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001950:	03459793          	slli	a5,a1,0x34
    80001954:	04079863          	bnez	a5,800019a4 <uvmunmap+0x80>
    80001958:	00050a13          	mv	s4,a0
    8000195c:	00058913          	mv	s2,a1
    80001960:	00068a93          	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001964:	00c61613          	slli	a2,a2,0xc
    80001968:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000196c:	00100b93          	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001970:	00001b37          	lui	s6,0x1
    80001974:	0735ee63          	bltu	a1,s3,800019f0 <uvmunmap+0xcc>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001978:	04813083          	ld	ra,72(sp)
    8000197c:	04013403          	ld	s0,64(sp)
    80001980:	03813483          	ld	s1,56(sp)
    80001984:	03013903          	ld	s2,48(sp)
    80001988:	02813983          	ld	s3,40(sp)
    8000198c:	02013a03          	ld	s4,32(sp)
    80001990:	01813a83          	ld	s5,24(sp)
    80001994:	01013b03          	ld	s6,16(sp)
    80001998:	00813b83          	ld	s7,8(sp)
    8000199c:	05010113          	addi	sp,sp,80
    800019a0:	00008067          	ret
    panic("uvmunmap: not aligned");
    800019a4:	00008517          	auipc	a0,0x8
    800019a8:	75c50513          	addi	a0,a0,1884 # 8000a100 <digits+0xc0>
    800019ac:	fffff097          	auipc	ra,0xfffff
    800019b0:	d20080e7          	jalr	-736(ra) # 800006cc <panic>
      panic("uvmunmap: walk");
    800019b4:	00008517          	auipc	a0,0x8
    800019b8:	76450513          	addi	a0,a0,1892 # 8000a118 <digits+0xd8>
    800019bc:	fffff097          	auipc	ra,0xfffff
    800019c0:	d10080e7          	jalr	-752(ra) # 800006cc <panic>
      panic("uvmunmap: not mapped");
    800019c4:	00008517          	auipc	a0,0x8
    800019c8:	76450513          	addi	a0,a0,1892 # 8000a128 <digits+0xe8>
    800019cc:	fffff097          	auipc	ra,0xfffff
    800019d0:	d00080e7          	jalr	-768(ra) # 800006cc <panic>
      panic("uvmunmap: not a leaf");
    800019d4:	00008517          	auipc	a0,0x8
    800019d8:	76c50513          	addi	a0,a0,1900 # 8000a140 <digits+0x100>
    800019dc:	fffff097          	auipc	ra,0xfffff
    800019e0:	cf0080e7          	jalr	-784(ra) # 800006cc <panic>
    *pte = 0;
    800019e4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800019e8:	01690933          	add	s2,s2,s6
    800019ec:	f93976e3          	bgeu	s2,s3,80001978 <uvmunmap+0x54>
    if((pte = walk(pagetable, a, 0)) == 0)
    800019f0:	00000613          	li	a2,0
    800019f4:	00090593          	mv	a1,s2
    800019f8:	000a0513          	mv	a0,s4
    800019fc:	00000097          	auipc	ra,0x0
    80001a00:	b20080e7          	jalr	-1248(ra) # 8000151c <walk>
    80001a04:	00050493          	mv	s1,a0
    80001a08:	fa0506e3          	beqz	a0,800019b4 <uvmunmap+0x90>
    if((*pte & PTE_V) == 0)
    80001a0c:	00053503          	ld	a0,0(a0)
    80001a10:	00157793          	andi	a5,a0,1
    80001a14:	fa0788e3          	beqz	a5,800019c4 <uvmunmap+0xa0>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001a18:	3ff57793          	andi	a5,a0,1023
    80001a1c:	fb778ce3          	beq	a5,s7,800019d4 <uvmunmap+0xb0>
    if(do_free){
    80001a20:	fc0a82e3          	beqz	s5,800019e4 <uvmunmap+0xc0>
      uint64 pa = PTE2PA(*pte);
    80001a24:	00a55513          	srli	a0,a0,0xa
      kfree((void*)pa);
    80001a28:	00c51513          	slli	a0,a0,0xc
    80001a2c:	fffff097          	auipc	ra,0xfffff
    80001a30:	2c8080e7          	jalr	712(ra) # 80000cf4 <kfree>
    80001a34:	fb1ff06f          	j	800019e4 <uvmunmap+0xc0>

0000000080001a38 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001a38:	fe010113          	addi	sp,sp,-32
    80001a3c:	00113c23          	sd	ra,24(sp)
    80001a40:	00813823          	sd	s0,16(sp)
    80001a44:	00913423          	sd	s1,8(sp)
    80001a48:	02010413          	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001a4c:	fffff097          	auipc	ra,0xfffff
    80001a50:	414080e7          	jalr	1044(ra) # 80000e60 <kalloc>
    80001a54:	00050493          	mv	s1,a0
  if(pagetable == 0)
    80001a58:	00050a63          	beqz	a0,80001a6c <uvmcreate+0x34>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001a5c:	00001637          	lui	a2,0x1
    80001a60:	00000593          	li	a1,0
    80001a64:	fffff097          	auipc	ra,0xfffff
    80001a68:	6c0080e7          	jalr	1728(ra) # 80001124 <memset>
  return pagetable;
}
    80001a6c:	00048513          	mv	a0,s1
    80001a70:	01813083          	ld	ra,24(sp)
    80001a74:	01013403          	ld	s0,16(sp)
    80001a78:	00813483          	ld	s1,8(sp)
    80001a7c:	02010113          	addi	sp,sp,32
    80001a80:	00008067          	ret

0000000080001a84 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001a84:	fd010113          	addi	sp,sp,-48
    80001a88:	02113423          	sd	ra,40(sp)
    80001a8c:	02813023          	sd	s0,32(sp)
    80001a90:	00913c23          	sd	s1,24(sp)
    80001a94:	01213823          	sd	s2,16(sp)
    80001a98:	01313423          	sd	s3,8(sp)
    80001a9c:	01413023          	sd	s4,0(sp)
    80001aa0:	03010413          	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001aa4:	000017b7          	lui	a5,0x1
    80001aa8:	06f67e63          	bgeu	a2,a5,80001b24 <uvminit+0xa0>
    80001aac:	00050a13          	mv	s4,a0
    80001ab0:	00058993          	mv	s3,a1
    80001ab4:	00060493          	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001ab8:	fffff097          	auipc	ra,0xfffff
    80001abc:	3a8080e7          	jalr	936(ra) # 80000e60 <kalloc>
    80001ac0:	00050913          	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001ac4:	00001637          	lui	a2,0x1
    80001ac8:	00000593          	li	a1,0
    80001acc:	fffff097          	auipc	ra,0xfffff
    80001ad0:	658080e7          	jalr	1624(ra) # 80001124 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001ad4:	01e00713          	li	a4,30
    80001ad8:	00090693          	mv	a3,s2
    80001adc:	00001637          	lui	a2,0x1
    80001ae0:	00000593          	li	a1,0
    80001ae4:	000a0513          	mv	a0,s4
    80001ae8:	00000097          	auipc	ra,0x0
    80001aec:	b9c080e7          	jalr	-1124(ra) # 80001684 <mappages>
  memmove(mem, src, sz);
    80001af0:	00048613          	mv	a2,s1
    80001af4:	00098593          	mv	a1,s3
    80001af8:	00090513          	mv	a0,s2
    80001afc:	fffff097          	auipc	ra,0xfffff
    80001b00:	6bc080e7          	jalr	1724(ra) # 800011b8 <memmove>
}
    80001b04:	02813083          	ld	ra,40(sp)
    80001b08:	02013403          	ld	s0,32(sp)
    80001b0c:	01813483          	ld	s1,24(sp)
    80001b10:	01013903          	ld	s2,16(sp)
    80001b14:	00813983          	ld	s3,8(sp)
    80001b18:	00013a03          	ld	s4,0(sp)
    80001b1c:	03010113          	addi	sp,sp,48
    80001b20:	00008067          	ret
    panic("inituvm: more than a page");
    80001b24:	00008517          	auipc	a0,0x8
    80001b28:	63450513          	addi	a0,a0,1588 # 8000a158 <digits+0x118>
    80001b2c:	fffff097          	auipc	ra,0xfffff
    80001b30:	ba0080e7          	jalr	-1120(ra) # 800006cc <panic>

0000000080001b34 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001b34:	fe010113          	addi	sp,sp,-32
    80001b38:	00113c23          	sd	ra,24(sp)
    80001b3c:	00813823          	sd	s0,16(sp)
    80001b40:	00913423          	sd	s1,8(sp)
    80001b44:	02010413          	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001b48:	00058493          	mv	s1,a1
  if(newsz >= oldsz)
    80001b4c:	02b67463          	bgeu	a2,a1,80001b74 <uvmdealloc+0x40>
    80001b50:	00060493          	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001b54:	000017b7          	lui	a5,0x1
    80001b58:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001b5c:	00f60733          	add	a4,a2,a5
    80001b60:	fffff637          	lui	a2,0xfffff
    80001b64:	00c77733          	and	a4,a4,a2
    80001b68:	00f587b3          	add	a5,a1,a5
    80001b6c:	00c7f7b3          	and	a5,a5,a2
    80001b70:	00f76e63          	bltu	a4,a5,80001b8c <uvmdealloc+0x58>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001b74:	00048513          	mv	a0,s1
    80001b78:	01813083          	ld	ra,24(sp)
    80001b7c:	01013403          	ld	s0,16(sp)
    80001b80:	00813483          	ld	s1,8(sp)
    80001b84:	02010113          	addi	sp,sp,32
    80001b88:	00008067          	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001b8c:	40e787b3          	sub	a5,a5,a4
    80001b90:	00c7d793          	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001b94:	00100693          	li	a3,1
    80001b98:	0007861b          	sext.w	a2,a5
    80001b9c:	00070593          	mv	a1,a4
    80001ba0:	00000097          	auipc	ra,0x0
    80001ba4:	d84080e7          	jalr	-636(ra) # 80001924 <uvmunmap>
    80001ba8:	fcdff06f          	j	80001b74 <uvmdealloc+0x40>

0000000080001bac <uvmalloc>:
  if(newsz < oldsz)
    80001bac:	10b66263          	bltu	a2,a1,80001cb0 <uvmalloc+0x104>
{
    80001bb0:	fc010113          	addi	sp,sp,-64
    80001bb4:	02113c23          	sd	ra,56(sp)
    80001bb8:	02813823          	sd	s0,48(sp)
    80001bbc:	02913423          	sd	s1,40(sp)
    80001bc0:	03213023          	sd	s2,32(sp)
    80001bc4:	01313c23          	sd	s3,24(sp)
    80001bc8:	01413823          	sd	s4,16(sp)
    80001bcc:	01513423          	sd	s5,8(sp)
    80001bd0:	04010413          	addi	s0,sp,64
    80001bd4:	00050a93          	mv	s5,a0
    80001bd8:	00060a13          	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001bdc:	000019b7          	lui	s3,0x1
    80001be0:	fff98993          	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80001be4:	013585b3          	add	a1,a1,s3
    80001be8:	fffff9b7          	lui	s3,0xfffff
    80001bec:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001bf0:	0cc9f463          	bgeu	s3,a2,80001cb8 <uvmalloc+0x10c>
    80001bf4:	00098913          	mv	s2,s3
    mem = kalloc();
    80001bf8:	fffff097          	auipc	ra,0xfffff
    80001bfc:	268080e7          	jalr	616(ra) # 80000e60 <kalloc>
    80001c00:	00050493          	mv	s1,a0
    if(mem == 0){
    80001c04:	04050463          	beqz	a0,80001c4c <uvmalloc+0xa0>
    memset(mem, 0, PGSIZE);
    80001c08:	00001637          	lui	a2,0x1
    80001c0c:	00000593          	li	a1,0
    80001c10:	fffff097          	auipc	ra,0xfffff
    80001c14:	514080e7          	jalr	1300(ra) # 80001124 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001c18:	01e00713          	li	a4,30
    80001c1c:	00048693          	mv	a3,s1
    80001c20:	00001637          	lui	a2,0x1
    80001c24:	00090593          	mv	a1,s2
    80001c28:	000a8513          	mv	a0,s5
    80001c2c:	00000097          	auipc	ra,0x0
    80001c30:	a58080e7          	jalr	-1448(ra) # 80001684 <mappages>
    80001c34:	04051a63          	bnez	a0,80001c88 <uvmalloc+0xdc>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001c38:	000017b7          	lui	a5,0x1
    80001c3c:	00f90933          	add	s2,s2,a5
    80001c40:	fb496ce3          	bltu	s2,s4,80001bf8 <uvmalloc+0x4c>
  return newsz;
    80001c44:	000a0513          	mv	a0,s4
    80001c48:	01c0006f          	j	80001c64 <uvmalloc+0xb8>
      uvmdealloc(pagetable, a, oldsz);
    80001c4c:	00098613          	mv	a2,s3
    80001c50:	00090593          	mv	a1,s2
    80001c54:	000a8513          	mv	a0,s5
    80001c58:	00000097          	auipc	ra,0x0
    80001c5c:	edc080e7          	jalr	-292(ra) # 80001b34 <uvmdealloc>
      return 0;
    80001c60:	00000513          	li	a0,0
}
    80001c64:	03813083          	ld	ra,56(sp)
    80001c68:	03013403          	ld	s0,48(sp)
    80001c6c:	02813483          	ld	s1,40(sp)
    80001c70:	02013903          	ld	s2,32(sp)
    80001c74:	01813983          	ld	s3,24(sp)
    80001c78:	01013a03          	ld	s4,16(sp)
    80001c7c:	00813a83          	ld	s5,8(sp)
    80001c80:	04010113          	addi	sp,sp,64
    80001c84:	00008067          	ret
      kfree(mem);
    80001c88:	00048513          	mv	a0,s1
    80001c8c:	fffff097          	auipc	ra,0xfffff
    80001c90:	068080e7          	jalr	104(ra) # 80000cf4 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001c94:	00098613          	mv	a2,s3
    80001c98:	00090593          	mv	a1,s2
    80001c9c:	000a8513          	mv	a0,s5
    80001ca0:	00000097          	auipc	ra,0x0
    80001ca4:	e94080e7          	jalr	-364(ra) # 80001b34 <uvmdealloc>
      return 0;
    80001ca8:	00000513          	li	a0,0
    80001cac:	fb9ff06f          	j	80001c64 <uvmalloc+0xb8>
    return oldsz;
    80001cb0:	00058513          	mv	a0,a1
}
    80001cb4:	00008067          	ret
  return newsz;
    80001cb8:	00060513          	mv	a0,a2
    80001cbc:	fa9ff06f          	j	80001c64 <uvmalloc+0xb8>

0000000080001cc0 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001cc0:	fd010113          	addi	sp,sp,-48
    80001cc4:	02113423          	sd	ra,40(sp)
    80001cc8:	02813023          	sd	s0,32(sp)
    80001ccc:	00913c23          	sd	s1,24(sp)
    80001cd0:	01213823          	sd	s2,16(sp)
    80001cd4:	01313423          	sd	s3,8(sp)
    80001cd8:	01413023          	sd	s4,0(sp)
    80001cdc:	03010413          	addi	s0,sp,48
    80001ce0:	00050a13          	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001ce4:	00050493          	mv	s1,a0
    80001ce8:	00001937          	lui	s2,0x1
    80001cec:	01250933          	add	s2,a0,s2
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001cf0:	00100993          	li	s3,1
    80001cf4:	0200006f          	j	80001d14 <freewalk+0x54>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001cf8:	00a55513          	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001cfc:	00c51513          	slli	a0,a0,0xc
    80001d00:	00000097          	auipc	ra,0x0
    80001d04:	fc0080e7          	jalr	-64(ra) # 80001cc0 <freewalk>
      pagetable[i] = 0;
    80001d08:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001d0c:	00848493          	addi	s1,s1,8
    80001d10:	03248463          	beq	s1,s2,80001d38 <freewalk+0x78>
    pte_t pte = pagetable[i];
    80001d14:	0004b503          	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001d18:	00f57793          	andi	a5,a0,15
    80001d1c:	fd378ee3          	beq	a5,s3,80001cf8 <freewalk+0x38>
    } else if(pte & PTE_V){
    80001d20:	00157513          	andi	a0,a0,1
    80001d24:	fe0504e3          	beqz	a0,80001d0c <freewalk+0x4c>
      panic("freewalk: leaf");
    80001d28:	00008517          	auipc	a0,0x8
    80001d2c:	45050513          	addi	a0,a0,1104 # 8000a178 <digits+0x138>
    80001d30:	fffff097          	auipc	ra,0xfffff
    80001d34:	99c080e7          	jalr	-1636(ra) # 800006cc <panic>
    }
  }
  kfree((void*)pagetable);
    80001d38:	000a0513          	mv	a0,s4
    80001d3c:	fffff097          	auipc	ra,0xfffff
    80001d40:	fb8080e7          	jalr	-72(ra) # 80000cf4 <kfree>
}
    80001d44:	02813083          	ld	ra,40(sp)
    80001d48:	02013403          	ld	s0,32(sp)
    80001d4c:	01813483          	ld	s1,24(sp)
    80001d50:	01013903          	ld	s2,16(sp)
    80001d54:	00813983          	ld	s3,8(sp)
    80001d58:	00013a03          	ld	s4,0(sp)
    80001d5c:	03010113          	addi	sp,sp,48
    80001d60:	00008067          	ret

0000000080001d64 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001d64:	fe010113          	addi	sp,sp,-32
    80001d68:	00113c23          	sd	ra,24(sp)
    80001d6c:	00813823          	sd	s0,16(sp)
    80001d70:	00913423          	sd	s1,8(sp)
    80001d74:	02010413          	addi	s0,sp,32
    80001d78:	00050493          	mv	s1,a0
  if(sz > 0)
    80001d7c:	02059263          	bnez	a1,80001da0 <uvmfree+0x3c>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001d80:	00048513          	mv	a0,s1
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	f3c080e7          	jalr	-196(ra) # 80001cc0 <freewalk>
}
    80001d8c:	01813083          	ld	ra,24(sp)
    80001d90:	01013403          	ld	s0,16(sp)
    80001d94:	00813483          	ld	s1,8(sp)
    80001d98:	02010113          	addi	sp,sp,32
    80001d9c:	00008067          	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001da0:	00001637          	lui	a2,0x1
    80001da4:	fff60613          	addi	a2,a2,-1 # fff <_entry-0x7ffff001>
    80001da8:	00c58633          	add	a2,a1,a2
    80001dac:	00100693          	li	a3,1
    80001db0:	00c65613          	srli	a2,a2,0xc
    80001db4:	00000593          	li	a1,0
    80001db8:	00000097          	auipc	ra,0x0
    80001dbc:	b6c080e7          	jalr	-1172(ra) # 80001924 <uvmunmap>
    80001dc0:	fc1ff06f          	j	80001d80 <uvmfree+0x1c>

0000000080001dc4 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001dc4:	12060e63          	beqz	a2,80001f00 <uvmcopy+0x13c>
{
    80001dc8:	fb010113          	addi	sp,sp,-80
    80001dcc:	04113423          	sd	ra,72(sp)
    80001dd0:	04813023          	sd	s0,64(sp)
    80001dd4:	02913c23          	sd	s1,56(sp)
    80001dd8:	03213823          	sd	s2,48(sp)
    80001ddc:	03313423          	sd	s3,40(sp)
    80001de0:	03413023          	sd	s4,32(sp)
    80001de4:	01513c23          	sd	s5,24(sp)
    80001de8:	01613823          	sd	s6,16(sp)
    80001dec:	01713423          	sd	s7,8(sp)
    80001df0:	05010413          	addi	s0,sp,80
    80001df4:	00050b13          	mv	s6,a0
    80001df8:	00058a93          	mv	s5,a1
    80001dfc:	00060a13          	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001e00:	00000993          	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001e04:	00000613          	li	a2,0
    80001e08:	00098593          	mv	a1,s3
    80001e0c:	000b0513          	mv	a0,s6
    80001e10:	fffff097          	auipc	ra,0xfffff
    80001e14:	70c080e7          	jalr	1804(ra) # 8000151c <walk>
    80001e18:	06050a63          	beqz	a0,80001e8c <uvmcopy+0xc8>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001e1c:	00053703          	ld	a4,0(a0)
    80001e20:	00177793          	andi	a5,a4,1
    80001e24:	06078c63          	beqz	a5,80001e9c <uvmcopy+0xd8>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001e28:	00a75593          	srli	a1,a4,0xa
    80001e2c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001e30:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001e34:	fffff097          	auipc	ra,0xfffff
    80001e38:	02c080e7          	jalr	44(ra) # 80000e60 <kalloc>
    80001e3c:	00050913          	mv	s2,a0
    80001e40:	06050c63          	beqz	a0,80001eb8 <uvmcopy+0xf4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001e44:	00001637          	lui	a2,0x1
    80001e48:	000b8593          	mv	a1,s7
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	36c080e7          	jalr	876(ra) # 800011b8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001e54:	00048713          	mv	a4,s1
    80001e58:	00090693          	mv	a3,s2
    80001e5c:	00001637          	lui	a2,0x1
    80001e60:	00098593          	mv	a1,s3
    80001e64:	000a8513          	mv	a0,s5
    80001e68:	00000097          	auipc	ra,0x0
    80001e6c:	81c080e7          	jalr	-2020(ra) # 80001684 <mappages>
    80001e70:	02051e63          	bnez	a0,80001eac <uvmcopy+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
    80001e74:	000017b7          	lui	a5,0x1
    80001e78:	00f989b3          	add	s3,s3,a5
    80001e7c:	f949e4e3          	bltu	s3,s4,80001e04 <uvmcopy+0x40>
    }
  }

  // Synchronize the instruction and data streams,
  // since we may copy pages with instructions.
  asm volatile("fence.i");
    80001e80:	0000100f          	fence.i
  return 0;
    80001e84:	00000513          	li	a0,0
    80001e88:	04c0006f          	j	80001ed4 <uvmcopy+0x110>
      panic("uvmcopy: pte should exist");
    80001e8c:	00008517          	auipc	a0,0x8
    80001e90:	2fc50513          	addi	a0,a0,764 # 8000a188 <digits+0x148>
    80001e94:	fffff097          	auipc	ra,0xfffff
    80001e98:	838080e7          	jalr	-1992(ra) # 800006cc <panic>
      panic("uvmcopy: page not present");
    80001e9c:	00008517          	auipc	a0,0x8
    80001ea0:	30c50513          	addi	a0,a0,780 # 8000a1a8 <digits+0x168>
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	828080e7          	jalr	-2008(ra) # 800006cc <panic>
      kfree(mem);
    80001eac:	00090513          	mv	a0,s2
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	e44080e7          	jalr	-444(ra) # 80000cf4 <kfree>

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001eb8:	00100693          	li	a3,1
    80001ebc:	00c9d613          	srli	a2,s3,0xc
    80001ec0:	00000593          	li	a1,0
    80001ec4:	000a8513          	mv	a0,s5
    80001ec8:	00000097          	auipc	ra,0x0
    80001ecc:	a5c080e7          	jalr	-1444(ra) # 80001924 <uvmunmap>
  return -1;
    80001ed0:	fff00513          	li	a0,-1
}
    80001ed4:	04813083          	ld	ra,72(sp)
    80001ed8:	04013403          	ld	s0,64(sp)
    80001edc:	03813483          	ld	s1,56(sp)
    80001ee0:	03013903          	ld	s2,48(sp)
    80001ee4:	02813983          	ld	s3,40(sp)
    80001ee8:	02013a03          	ld	s4,32(sp)
    80001eec:	01813a83          	ld	s5,24(sp)
    80001ef0:	01013b03          	ld	s6,16(sp)
    80001ef4:	00813b83          	ld	s7,8(sp)
    80001ef8:	05010113          	addi	sp,sp,80
    80001efc:	00008067          	ret
  asm volatile("fence.i");
    80001f00:	0000100f          	fence.i
  return 0;
    80001f04:	00000513          	li	a0,0
}
    80001f08:	00008067          	ret

0000000080001f0c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001f0c:	ff010113          	addi	sp,sp,-16
    80001f10:	00113423          	sd	ra,8(sp)
    80001f14:	00813023          	sd	s0,0(sp)
    80001f18:	01010413          	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001f1c:	00000613          	li	a2,0
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	5fc080e7          	jalr	1532(ra) # 8000151c <walk>
  if(pte == 0)
    80001f28:	02050063          	beqz	a0,80001f48 <uvmclear+0x3c>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001f2c:	00053783          	ld	a5,0(a0)
    80001f30:	fef7f793          	andi	a5,a5,-17
    80001f34:	00f53023          	sd	a5,0(a0)
}
    80001f38:	00813083          	ld	ra,8(sp)
    80001f3c:	00013403          	ld	s0,0(sp)
    80001f40:	01010113          	addi	sp,sp,16
    80001f44:	00008067          	ret
    panic("uvmclear");
    80001f48:	00008517          	auipc	a0,0x8
    80001f4c:	28050513          	addi	a0,a0,640 # 8000a1c8 <digits+0x188>
    80001f50:	ffffe097          	auipc	ra,0xffffe
    80001f54:	77c080e7          	jalr	1916(ra) # 800006cc <panic>

0000000080001f58 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001f58:	0a068663          	beqz	a3,80002004 <copyout+0xac>
{
    80001f5c:	fb010113          	addi	sp,sp,-80
    80001f60:	04113423          	sd	ra,72(sp)
    80001f64:	04813023          	sd	s0,64(sp)
    80001f68:	02913c23          	sd	s1,56(sp)
    80001f6c:	03213823          	sd	s2,48(sp)
    80001f70:	03313423          	sd	s3,40(sp)
    80001f74:	03413023          	sd	s4,32(sp)
    80001f78:	01513c23          	sd	s5,24(sp)
    80001f7c:	01613823          	sd	s6,16(sp)
    80001f80:	01713423          	sd	s7,8(sp)
    80001f84:	01813023          	sd	s8,0(sp)
    80001f88:	05010413          	addi	s0,sp,80
    80001f8c:	00050b13          	mv	s6,a0
    80001f90:	00058c13          	mv	s8,a1
    80001f94:	00060a13          	mv	s4,a2
    80001f98:	00068993          	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001f9c:	fffffbb7          	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001fa0:	00001ab7          	lui	s5,0x1
    80001fa4:	02c0006f          	j	80001fd0 <copyout+0x78>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001fa8:	01850533          	add	a0,a0,s8
    80001fac:	0004861b          	sext.w	a2,s1
    80001fb0:	000a0593          	mv	a1,s4
    80001fb4:	41250533          	sub	a0,a0,s2
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	200080e7          	jalr	512(ra) # 800011b8 <memmove>

    len -= n;
    80001fc0:	409989b3          	sub	s3,s3,s1
    src += n;
    80001fc4:	009a0a33          	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001fc8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001fcc:	02098863          	beqz	s3,80001ffc <copyout+0xa4>
    va0 = PGROUNDDOWN(dstva);
    80001fd0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001fd4:	00090593          	mv	a1,s2
    80001fd8:	000b0513          	mv	a0,s6
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	63c080e7          	jalr	1596(ra) # 80001618 <walkaddr>
    if(pa0 == 0)
    80001fe4:	02050463          	beqz	a0,8000200c <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80001fe8:	418904b3          	sub	s1,s2,s8
    80001fec:	015484b3          	add	s1,s1,s5
    if(n > len)
    80001ff0:	fa99fce3          	bgeu	s3,s1,80001fa8 <copyout+0x50>
    80001ff4:	00098493          	mv	s1,s3
    80001ff8:	fb1ff06f          	j	80001fa8 <copyout+0x50>
  }
  return 0;
    80001ffc:	00000513          	li	a0,0
    80002000:	0100006f          	j	80002010 <copyout+0xb8>
    80002004:	00000513          	li	a0,0
}
    80002008:	00008067          	ret
      return -1;
    8000200c:	fff00513          	li	a0,-1
}
    80002010:	04813083          	ld	ra,72(sp)
    80002014:	04013403          	ld	s0,64(sp)
    80002018:	03813483          	ld	s1,56(sp)
    8000201c:	03013903          	ld	s2,48(sp)
    80002020:	02813983          	ld	s3,40(sp)
    80002024:	02013a03          	ld	s4,32(sp)
    80002028:	01813a83          	ld	s5,24(sp)
    8000202c:	01013b03          	ld	s6,16(sp)
    80002030:	00813b83          	ld	s7,8(sp)
    80002034:	00013c03          	ld	s8,0(sp)
    80002038:	05010113          	addi	sp,sp,80
    8000203c:	00008067          	ret

0000000080002040 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80002040:	0a068663          	beqz	a3,800020ec <copyin+0xac>
{
    80002044:	fb010113          	addi	sp,sp,-80
    80002048:	04113423          	sd	ra,72(sp)
    8000204c:	04813023          	sd	s0,64(sp)
    80002050:	02913c23          	sd	s1,56(sp)
    80002054:	03213823          	sd	s2,48(sp)
    80002058:	03313423          	sd	s3,40(sp)
    8000205c:	03413023          	sd	s4,32(sp)
    80002060:	01513c23          	sd	s5,24(sp)
    80002064:	01613823          	sd	s6,16(sp)
    80002068:	01713423          	sd	s7,8(sp)
    8000206c:	01813023          	sd	s8,0(sp)
    80002070:	05010413          	addi	s0,sp,80
    80002074:	00050b13          	mv	s6,a0
    80002078:	00058a13          	mv	s4,a1
    8000207c:	00060c13          	mv	s8,a2
    80002080:	00068993          	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80002084:	fffffbb7          	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80002088:	00001ab7          	lui	s5,0x1
    8000208c:	02c0006f          	j	800020b8 <copyin+0x78>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80002090:	018505b3          	add	a1,a0,s8
    80002094:	0004861b          	sext.w	a2,s1
    80002098:	412585b3          	sub	a1,a1,s2
    8000209c:	000a0513          	mv	a0,s4
    800020a0:	fffff097          	auipc	ra,0xfffff
    800020a4:	118080e7          	jalr	280(ra) # 800011b8 <memmove>

    len -= n;
    800020a8:	409989b3          	sub	s3,s3,s1
    dst += n;
    800020ac:	009a0a33          	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800020b0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800020b4:	02098863          	beqz	s3,800020e4 <copyin+0xa4>
    va0 = PGROUNDDOWN(srcva);
    800020b8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800020bc:	00090593          	mv	a1,s2
    800020c0:	000b0513          	mv	a0,s6
    800020c4:	fffff097          	auipc	ra,0xfffff
    800020c8:	554080e7          	jalr	1364(ra) # 80001618 <walkaddr>
    if(pa0 == 0)
    800020cc:	02050463          	beqz	a0,800020f4 <copyin+0xb4>
    n = PGSIZE - (srcva - va0);
    800020d0:	418904b3          	sub	s1,s2,s8
    800020d4:	015484b3          	add	s1,s1,s5
    if(n > len)
    800020d8:	fa99fce3          	bgeu	s3,s1,80002090 <copyin+0x50>
    800020dc:	00098493          	mv	s1,s3
    800020e0:	fb1ff06f          	j	80002090 <copyin+0x50>
  }
  return 0;
    800020e4:	00000513          	li	a0,0
    800020e8:	0100006f          	j	800020f8 <copyin+0xb8>
    800020ec:	00000513          	li	a0,0
}
    800020f0:	00008067          	ret
      return -1;
    800020f4:	fff00513          	li	a0,-1
}
    800020f8:	04813083          	ld	ra,72(sp)
    800020fc:	04013403          	ld	s0,64(sp)
    80002100:	03813483          	ld	s1,56(sp)
    80002104:	03013903          	ld	s2,48(sp)
    80002108:	02813983          	ld	s3,40(sp)
    8000210c:	02013a03          	ld	s4,32(sp)
    80002110:	01813a83          	ld	s5,24(sp)
    80002114:	01013b03          	ld	s6,16(sp)
    80002118:	00813b83          	ld	s7,8(sp)
    8000211c:	00013c03          	ld	s8,0(sp)
    80002120:	05010113          	addi	sp,sp,80
    80002124:	00008067          	ret

0000000080002128 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80002128:	10068663          	beqz	a3,80002234 <copyinstr+0x10c>
{
    8000212c:	fb010113          	addi	sp,sp,-80
    80002130:	04113423          	sd	ra,72(sp)
    80002134:	04813023          	sd	s0,64(sp)
    80002138:	02913c23          	sd	s1,56(sp)
    8000213c:	03213823          	sd	s2,48(sp)
    80002140:	03313423          	sd	s3,40(sp)
    80002144:	03413023          	sd	s4,32(sp)
    80002148:	01513c23          	sd	s5,24(sp)
    8000214c:	01613823          	sd	s6,16(sp)
    80002150:	01713423          	sd	s7,8(sp)
    80002154:	05010413          	addi	s0,sp,80
    80002158:	00050a13          	mv	s4,a0
    8000215c:	00058b13          	mv	s6,a1
    80002160:	00060b93          	mv	s7,a2
    80002164:	00068493          	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80002168:	fffffab7          	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000216c:	000019b7          	lui	s3,0x1
    80002170:	0480006f          	j	800021b8 <copyinstr+0x90>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80002174:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80002178:	00100793          	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000217c:	0017b793          	seqz	a5,a5
    80002180:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80002184:	04813083          	ld	ra,72(sp)
    80002188:	04013403          	ld	s0,64(sp)
    8000218c:	03813483          	ld	s1,56(sp)
    80002190:	03013903          	ld	s2,48(sp)
    80002194:	02813983          	ld	s3,40(sp)
    80002198:	02013a03          	ld	s4,32(sp)
    8000219c:	01813a83          	ld	s5,24(sp)
    800021a0:	01013b03          	ld	s6,16(sp)
    800021a4:	00813b83          	ld	s7,8(sp)
    800021a8:	05010113          	addi	sp,sp,80
    800021ac:	00008067          	ret
    srcva = va0 + PGSIZE;
    800021b0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800021b4:	06048863          	beqz	s1,80002224 <copyinstr+0xfc>
    va0 = PGROUNDDOWN(srcva);
    800021b8:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800021bc:	00090593          	mv	a1,s2
    800021c0:	000a0513          	mv	a0,s4
    800021c4:	fffff097          	auipc	ra,0xfffff
    800021c8:	454080e7          	jalr	1108(ra) # 80001618 <walkaddr>
    if(pa0 == 0)
    800021cc:	06050063          	beqz	a0,8000222c <copyinstr+0x104>
    n = PGSIZE - (srcva - va0);
    800021d0:	41790833          	sub	a6,s2,s7
    800021d4:	01380833          	add	a6,a6,s3
    if(n > max)
    800021d8:	0104f463          	bgeu	s1,a6,800021e0 <copyinstr+0xb8>
    800021dc:	00048813          	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800021e0:	01750533          	add	a0,a0,s7
    800021e4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800021e8:	fc0804e3          	beqz	a6,800021b0 <copyinstr+0x88>
    800021ec:	010b0833          	add	a6,s6,a6
    800021f0:	000b0793          	mv	a5,s6
      if(*p == '\0'){
    800021f4:	41650633          	sub	a2,a0,s6
    800021f8:	fff48493          	addi	s1,s1,-1
    800021fc:	009b0b33          	add	s6,s6,s1
    80002200:	00f60733          	add	a4,a2,a5
    80002204:	00074703          	lbu	a4,0(a4)
    80002208:	f60706e3          	beqz	a4,80002174 <copyinstr+0x4c>
        *dst = *p;
    8000220c:	00e78023          	sb	a4,0(a5)
      --max;
    80002210:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80002214:	00178793          	addi	a5,a5,1
    while(n > 0){
    80002218:	ff0794e3          	bne	a5,a6,80002200 <copyinstr+0xd8>
      dst++;
    8000221c:	00080b13          	mv	s6,a6
    80002220:	f91ff06f          	j	800021b0 <copyinstr+0x88>
    80002224:	00000793          	li	a5,0
    80002228:	f55ff06f          	j	8000217c <copyinstr+0x54>
      return -1;
    8000222c:	fff00513          	li	a0,-1
    80002230:	f55ff06f          	j	80002184 <copyinstr+0x5c>
  int got_null = 0;
    80002234:	00000793          	li	a5,0
  if(got_null){
    80002238:	0017b793          	seqz	a5,a5
    8000223c:	40f00533          	neg	a0,a5
}
    80002240:	00008067          	ret

0000000080002244 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80002244:	fc010113          	addi	sp,sp,-64
    80002248:	02113c23          	sd	ra,56(sp)
    8000224c:	02813823          	sd	s0,48(sp)
    80002250:	02913423          	sd	s1,40(sp)
    80002254:	03213023          	sd	s2,32(sp)
    80002258:	01313c23          	sd	s3,24(sp)
    8000225c:	01413823          	sd	s4,16(sp)
    80002260:	01513423          	sd	s5,8(sp)
    80002264:	01613023          	sd	s6,0(sp)
    80002268:	04010413          	addi	s0,sp,64
    8000226c:	00050993          	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80002270:	00011497          	auipc	s1,0x11
    80002274:	c8048493          	addi	s1,s1,-896 # 80012ef0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80002278:	00048b13          	mv	s6,s1
    8000227c:	00008a97          	auipc	s5,0x8
    80002280:	d84a8a93          	addi	s5,s5,-636 # 8000a000 <etext>
    80002284:	04000937          	lui	s2,0x4000
    80002288:	fff90913          	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000228c:	00c91913          	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80002290:	00016a17          	auipc	s4,0x16
    80002294:	660a0a13          	addi	s4,s4,1632 # 800188f0 <tickslock>
    char *pa = kalloc();
    80002298:	fffff097          	auipc	ra,0xfffff
    8000229c:	bc8080e7          	jalr	-1080(ra) # 80000e60 <kalloc>
    800022a0:	00050613          	mv	a2,a0
    if(pa == 0)
    800022a4:	06050263          	beqz	a0,80002308 <proc_mapstacks+0xc4>
    uint64 va = KSTACK((int) (p - proc));
    800022a8:	416485b3          	sub	a1,s1,s6
    800022ac:	4035d593          	srai	a1,a1,0x3
    800022b0:	000ab783          	ld	a5,0(s5)
    800022b4:	02f585b3          	mul	a1,a1,a5
    800022b8:	0015859b          	addiw	a1,a1,1
    800022bc:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800022c0:	00600713          	li	a4,6
    800022c4:	000016b7          	lui	a3,0x1
    800022c8:	40b905b3          	sub	a1,s2,a1
    800022cc:	00098513          	mv	a0,s3
    800022d0:	fffff097          	auipc	ra,0xfffff
    800022d4:	4ac080e7          	jalr	1196(ra) # 8000177c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800022d8:	16848493          	addi	s1,s1,360
    800022dc:	fb449ee3          	bne	s1,s4,80002298 <proc_mapstacks+0x54>
  }
}
    800022e0:	03813083          	ld	ra,56(sp)
    800022e4:	03013403          	ld	s0,48(sp)
    800022e8:	02813483          	ld	s1,40(sp)
    800022ec:	02013903          	ld	s2,32(sp)
    800022f0:	01813983          	ld	s3,24(sp)
    800022f4:	01013a03          	ld	s4,16(sp)
    800022f8:	00813a83          	ld	s5,8(sp)
    800022fc:	00013b03          	ld	s6,0(sp)
    80002300:	04010113          	addi	sp,sp,64
    80002304:	00008067          	ret
      panic("kalloc");
    80002308:	00008517          	auipc	a0,0x8
    8000230c:	ed050513          	addi	a0,a0,-304 # 8000a1d8 <digits+0x198>
    80002310:	ffffe097          	auipc	ra,0xffffe
    80002314:	3bc080e7          	jalr	956(ra) # 800006cc <panic>

0000000080002318 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80002318:	fc010113          	addi	sp,sp,-64
    8000231c:	02113c23          	sd	ra,56(sp)
    80002320:	02813823          	sd	s0,48(sp)
    80002324:	02913423          	sd	s1,40(sp)
    80002328:	03213023          	sd	s2,32(sp)
    8000232c:	01313c23          	sd	s3,24(sp)
    80002330:	01413823          	sd	s4,16(sp)
    80002334:	01513423          	sd	s5,8(sp)
    80002338:	01613023          	sd	s6,0(sp)
    8000233c:	04010413          	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80002340:	00008597          	auipc	a1,0x8
    80002344:	ea058593          	addi	a1,a1,-352 # 8000a1e0 <digits+0x1a0>
    80002348:	00010517          	auipc	a0,0x10
    8000234c:	77850513          	addi	a0,a0,1912 # 80012ac0 <pid_lock>
    80002350:	fffff097          	auipc	ra,0xfffff
    80002354:	b98080e7          	jalr	-1128(ra) # 80000ee8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80002358:	00008597          	auipc	a1,0x8
    8000235c:	e9058593          	addi	a1,a1,-368 # 8000a1e8 <digits+0x1a8>
    80002360:	00010517          	auipc	a0,0x10
    80002364:	77850513          	addi	a0,a0,1912 # 80012ad8 <wait_lock>
    80002368:	fffff097          	auipc	ra,0xfffff
    8000236c:	b80080e7          	jalr	-1152(ra) # 80000ee8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002370:	00011497          	auipc	s1,0x11
    80002374:	b8048493          	addi	s1,s1,-1152 # 80012ef0 <proc>
      initlock(&p->lock, "proc");
    80002378:	00008b17          	auipc	s6,0x8
    8000237c:	e80b0b13          	addi	s6,s6,-384 # 8000a1f8 <digits+0x1b8>
      p->kstack = KSTACK((int) (p - proc));
    80002380:	00048a93          	mv	s5,s1
    80002384:	00008a17          	auipc	s4,0x8
    80002388:	c7ca0a13          	addi	s4,s4,-900 # 8000a000 <etext>
    8000238c:	04000937          	lui	s2,0x4000
    80002390:	fff90913          	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80002394:	00c91913          	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80002398:	00016997          	auipc	s3,0x16
    8000239c:	55898993          	addi	s3,s3,1368 # 800188f0 <tickslock>
      initlock(&p->lock, "proc");
    800023a0:	000b0593          	mv	a1,s6
    800023a4:	00048513          	mv	a0,s1
    800023a8:	fffff097          	auipc	ra,0xfffff
    800023ac:	b40080e7          	jalr	-1216(ra) # 80000ee8 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    800023b0:	415487b3          	sub	a5,s1,s5
    800023b4:	4037d793          	srai	a5,a5,0x3
    800023b8:	000a3703          	ld	a4,0(s4)
    800023bc:	02e787b3          	mul	a5,a5,a4
    800023c0:	0017879b          	addiw	a5,a5,1
    800023c4:	00d7979b          	slliw	a5,a5,0xd
    800023c8:	40f907b3          	sub	a5,s2,a5
    800023cc:	04f4b023          	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800023d0:	16848493          	addi	s1,s1,360
    800023d4:	fd3496e3          	bne	s1,s3,800023a0 <procinit+0x88>
  }
}
    800023d8:	03813083          	ld	ra,56(sp)
    800023dc:	03013403          	ld	s0,48(sp)
    800023e0:	02813483          	ld	s1,40(sp)
    800023e4:	02013903          	ld	s2,32(sp)
    800023e8:	01813983          	ld	s3,24(sp)
    800023ec:	01013a03          	ld	s4,16(sp)
    800023f0:	00813a83          	ld	s5,8(sp)
    800023f4:	00013b03          	ld	s6,0(sp)
    800023f8:	04010113          	addi	sp,sp,64
    800023fc:	00008067          	ret

0000000080002400 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80002400:	ff010113          	addi	sp,sp,-16
    80002404:	00813423          	sd	s0,8(sp)
    80002408:	01010413          	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000240c:	00020513          	mv	a0,tp
  int id = r_tp();
  return id;
}
    80002410:	0005051b          	sext.w	a0,a0
    80002414:	00813403          	ld	s0,8(sp)
    80002418:	01010113          	addi	sp,sp,16
    8000241c:	00008067          	ret

0000000080002420 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80002420:	ff010113          	addi	sp,sp,-16
    80002424:	00813423          	sd	s0,8(sp)
    80002428:	01010413          	addi	s0,sp,16
    8000242c:	00020793          	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80002430:	0007879b          	sext.w	a5,a5
    80002434:	00779793          	slli	a5,a5,0x7
  return c;
}
    80002438:	00010517          	auipc	a0,0x10
    8000243c:	6b850513          	addi	a0,a0,1720 # 80012af0 <cpus>
    80002440:	00f50533          	add	a0,a0,a5
    80002444:	00813403          	ld	s0,8(sp)
    80002448:	01010113          	addi	sp,sp,16
    8000244c:	00008067          	ret

0000000080002450 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80002450:	fe010113          	addi	sp,sp,-32
    80002454:	00113c23          	sd	ra,24(sp)
    80002458:	00813823          	sd	s0,16(sp)
    8000245c:	00913423          	sd	s1,8(sp)
    80002460:	02010413          	addi	s0,sp,32
  push_off();
    80002464:	fffff097          	auipc	ra,0xfffff
    80002468:	af4080e7          	jalr	-1292(ra) # 80000f58 <push_off>
    8000246c:	00020793          	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80002470:	0007879b          	sext.w	a5,a5
    80002474:	00779793          	slli	a5,a5,0x7
    80002478:	00010717          	auipc	a4,0x10
    8000247c:	64870713          	addi	a4,a4,1608 # 80012ac0 <pid_lock>
    80002480:	00f707b3          	add	a5,a4,a5
    80002484:	0307b483          	ld	s1,48(a5)
  pop_off();
    80002488:	fffff097          	auipc	ra,0xfffff
    8000248c:	bbc080e7          	jalr	-1092(ra) # 80001044 <pop_off>
  return p;
}
    80002490:	00048513          	mv	a0,s1
    80002494:	01813083          	ld	ra,24(sp)
    80002498:	01013403          	ld	s0,16(sp)
    8000249c:	00813483          	ld	s1,8(sp)
    800024a0:	02010113          	addi	sp,sp,32
    800024a4:	00008067          	ret

00000000800024a8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800024a8:	ff010113          	addi	sp,sp,-16
    800024ac:	00113423          	sd	ra,8(sp)
    800024b0:	00813023          	sd	s0,0(sp)
    800024b4:	01010413          	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800024b8:	00000097          	auipc	ra,0x0
    800024bc:	f98080e7          	jalr	-104(ra) # 80002450 <myproc>
    800024c0:	fffff097          	auipc	ra,0xfffff
    800024c4:	c04080e7          	jalr	-1020(ra) # 800010c4 <release>

  if (first) {
    800024c8:	00008797          	auipc	a5,0x8
    800024cc:	3087a783          	lw	a5,776(a5) # 8000a7d0 <first.1>
    800024d0:	00079e63          	bnez	a5,800024ec <forkret+0x44>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800024d4:	00001097          	auipc	ra,0x1
    800024d8:	0c8080e7          	jalr	200(ra) # 8000359c <usertrapret>
}
    800024dc:	00813083          	ld	ra,8(sp)
    800024e0:	00013403          	ld	s0,0(sp)
    800024e4:	01010113          	addi	sp,sp,16
    800024e8:	00008067          	ret
    first = 0;
    800024ec:	00008797          	auipc	a5,0x8
    800024f0:	2e07a223          	sw	zero,740(a5) # 8000a7d0 <first.1>
    fsinit(ROOTDEV);
    800024f4:	00100513          	li	a0,1
    800024f8:	00002097          	auipc	ra,0x2
    800024fc:	304080e7          	jalr	772(ra) # 800047fc <fsinit>
    80002500:	fd5ff06f          	j	800024d4 <forkret+0x2c>

0000000080002504 <allocpid>:
allocpid() {
    80002504:	fe010113          	addi	sp,sp,-32
    80002508:	00113c23          	sd	ra,24(sp)
    8000250c:	00813823          	sd	s0,16(sp)
    80002510:	00913423          	sd	s1,8(sp)
    80002514:	01213023          	sd	s2,0(sp)
    80002518:	02010413          	addi	s0,sp,32
  acquire(&pid_lock);
    8000251c:	00010917          	auipc	s2,0x10
    80002520:	5a490913          	addi	s2,s2,1444 # 80012ac0 <pid_lock>
    80002524:	00090513          	mv	a0,s2
    80002528:	fffff097          	auipc	ra,0xfffff
    8000252c:	aa4080e7          	jalr	-1372(ra) # 80000fcc <acquire>
  pid = nextpid;
    80002530:	00008797          	auipc	a5,0x8
    80002534:	2a478793          	addi	a5,a5,676 # 8000a7d4 <nextpid>
    80002538:	0007a483          	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000253c:	0014871b          	addiw	a4,s1,1
    80002540:	00e7a023          	sw	a4,0(a5)
  release(&pid_lock);
    80002544:	00090513          	mv	a0,s2
    80002548:	fffff097          	auipc	ra,0xfffff
    8000254c:	b7c080e7          	jalr	-1156(ra) # 800010c4 <release>
}
    80002550:	00048513          	mv	a0,s1
    80002554:	01813083          	ld	ra,24(sp)
    80002558:	01013403          	ld	s0,16(sp)
    8000255c:	00813483          	ld	s1,8(sp)
    80002560:	00013903          	ld	s2,0(sp)
    80002564:	02010113          	addi	sp,sp,32
    80002568:	00008067          	ret

000000008000256c <proc_pagetable>:
{
    8000256c:	fe010113          	addi	sp,sp,-32
    80002570:	00113c23          	sd	ra,24(sp)
    80002574:	00813823          	sd	s0,16(sp)
    80002578:	00913423          	sd	s1,8(sp)
    8000257c:	01213023          	sd	s2,0(sp)
    80002580:	02010413          	addi	s0,sp,32
    80002584:	00050913          	mv	s2,a0
  pagetable = uvmcreate();
    80002588:	fffff097          	auipc	ra,0xfffff
    8000258c:	4b0080e7          	jalr	1200(ra) # 80001a38 <uvmcreate>
    80002590:	00050493          	mv	s1,a0
  if(pagetable == 0)
    80002594:	04050a63          	beqz	a0,800025e8 <proc_pagetable+0x7c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80002598:	00a00713          	li	a4,10
    8000259c:	00007697          	auipc	a3,0x7
    800025a0:	a6468693          	addi	a3,a3,-1436 # 80009000 <_trampoline>
    800025a4:	00001637          	lui	a2,0x1
    800025a8:	040005b7          	lui	a1,0x4000
    800025ac:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800025b0:	00c59593          	slli	a1,a1,0xc
    800025b4:	fffff097          	auipc	ra,0xfffff
    800025b8:	0d0080e7          	jalr	208(ra) # 80001684 <mappages>
    800025bc:	04054463          	bltz	a0,80002604 <proc_pagetable+0x98>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800025c0:	00600713          	li	a4,6
    800025c4:	05893683          	ld	a3,88(s2)
    800025c8:	00001637          	lui	a2,0x1
    800025cc:	020005b7          	lui	a1,0x2000
    800025d0:	fff58593          	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800025d4:	00d59593          	slli	a1,a1,0xd
    800025d8:	00048513          	mv	a0,s1
    800025dc:	fffff097          	auipc	ra,0xfffff
    800025e0:	0a8080e7          	jalr	168(ra) # 80001684 <mappages>
    800025e4:	02054c63          	bltz	a0,8000261c <proc_pagetable+0xb0>
}
    800025e8:	00048513          	mv	a0,s1
    800025ec:	01813083          	ld	ra,24(sp)
    800025f0:	01013403          	ld	s0,16(sp)
    800025f4:	00813483          	ld	s1,8(sp)
    800025f8:	00013903          	ld	s2,0(sp)
    800025fc:	02010113          	addi	sp,sp,32
    80002600:	00008067          	ret
    uvmfree(pagetable, 0);
    80002604:	00000593          	li	a1,0
    80002608:	00048513          	mv	a0,s1
    8000260c:	fffff097          	auipc	ra,0xfffff
    80002610:	758080e7          	jalr	1880(ra) # 80001d64 <uvmfree>
    return 0;
    80002614:	00000493          	li	s1,0
    80002618:	fd1ff06f          	j	800025e8 <proc_pagetable+0x7c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000261c:	00000693          	li	a3,0
    80002620:	00100613          	li	a2,1
    80002624:	040005b7          	lui	a1,0x4000
    80002628:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000262c:	00c59593          	slli	a1,a1,0xc
    80002630:	00048513          	mv	a0,s1
    80002634:	fffff097          	auipc	ra,0xfffff
    80002638:	2f0080e7          	jalr	752(ra) # 80001924 <uvmunmap>
    uvmfree(pagetable, 0);
    8000263c:	00000593          	li	a1,0
    80002640:	00048513          	mv	a0,s1
    80002644:	fffff097          	auipc	ra,0xfffff
    80002648:	720080e7          	jalr	1824(ra) # 80001d64 <uvmfree>
    return 0;
    8000264c:	00000493          	li	s1,0
    80002650:	f99ff06f          	j	800025e8 <proc_pagetable+0x7c>

0000000080002654 <proc_freepagetable>:
{
    80002654:	fe010113          	addi	sp,sp,-32
    80002658:	00113c23          	sd	ra,24(sp)
    8000265c:	00813823          	sd	s0,16(sp)
    80002660:	00913423          	sd	s1,8(sp)
    80002664:	01213023          	sd	s2,0(sp)
    80002668:	02010413          	addi	s0,sp,32
    8000266c:	00050493          	mv	s1,a0
    80002670:	00058913          	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002674:	00000693          	li	a3,0
    80002678:	00100613          	li	a2,1
    8000267c:	040005b7          	lui	a1,0x4000
    80002680:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002684:	00c59593          	slli	a1,a1,0xc
    80002688:	fffff097          	auipc	ra,0xfffff
    8000268c:	29c080e7          	jalr	668(ra) # 80001924 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002690:	00000693          	li	a3,0
    80002694:	00100613          	li	a2,1
    80002698:	020005b7          	lui	a1,0x2000
    8000269c:	fff58593          	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800026a0:	00d59593          	slli	a1,a1,0xd
    800026a4:	00048513          	mv	a0,s1
    800026a8:	fffff097          	auipc	ra,0xfffff
    800026ac:	27c080e7          	jalr	636(ra) # 80001924 <uvmunmap>
  uvmfree(pagetable, sz);
    800026b0:	00090593          	mv	a1,s2
    800026b4:	00048513          	mv	a0,s1
    800026b8:	fffff097          	auipc	ra,0xfffff
    800026bc:	6ac080e7          	jalr	1708(ra) # 80001d64 <uvmfree>
}
    800026c0:	01813083          	ld	ra,24(sp)
    800026c4:	01013403          	ld	s0,16(sp)
    800026c8:	00813483          	ld	s1,8(sp)
    800026cc:	00013903          	ld	s2,0(sp)
    800026d0:	02010113          	addi	sp,sp,32
    800026d4:	00008067          	ret

00000000800026d8 <freeproc>:
{
    800026d8:	fe010113          	addi	sp,sp,-32
    800026dc:	00113c23          	sd	ra,24(sp)
    800026e0:	00813823          	sd	s0,16(sp)
    800026e4:	00913423          	sd	s1,8(sp)
    800026e8:	02010413          	addi	s0,sp,32
    800026ec:	00050493          	mv	s1,a0
  if(p->trapframe)
    800026f0:	05853503          	ld	a0,88(a0)
    800026f4:	00050663          	beqz	a0,80002700 <freeproc+0x28>
    kfree((void*)p->trapframe);
    800026f8:	ffffe097          	auipc	ra,0xffffe
    800026fc:	5fc080e7          	jalr	1532(ra) # 80000cf4 <kfree>
  p->trapframe = 0;
    80002700:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80002704:	0504b503          	ld	a0,80(s1)
    80002708:	00050863          	beqz	a0,80002718 <freeproc+0x40>
    proc_freepagetable(p->pagetable, p->sz);
    8000270c:	0484b583          	ld	a1,72(s1)
    80002710:	00000097          	auipc	ra,0x0
    80002714:	f44080e7          	jalr	-188(ra) # 80002654 <proc_freepagetable>
  p->pagetable = 0;
    80002718:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000271c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80002720:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80002724:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80002728:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000272c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80002730:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80002734:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80002738:	0004ac23          	sw	zero,24(s1)
}
    8000273c:	01813083          	ld	ra,24(sp)
    80002740:	01013403          	ld	s0,16(sp)
    80002744:	00813483          	ld	s1,8(sp)
    80002748:	02010113          	addi	sp,sp,32
    8000274c:	00008067          	ret

0000000080002750 <allocproc>:
{
    80002750:	fe010113          	addi	sp,sp,-32
    80002754:	00113c23          	sd	ra,24(sp)
    80002758:	00813823          	sd	s0,16(sp)
    8000275c:	00913423          	sd	s1,8(sp)
    80002760:	01213023          	sd	s2,0(sp)
    80002764:	02010413          	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80002768:	00010497          	auipc	s1,0x10
    8000276c:	78848493          	addi	s1,s1,1928 # 80012ef0 <proc>
    80002770:	00016917          	auipc	s2,0x16
    80002774:	18090913          	addi	s2,s2,384 # 800188f0 <tickslock>
    acquire(&p->lock);
    80002778:	00048513          	mv	a0,s1
    8000277c:	fffff097          	auipc	ra,0xfffff
    80002780:	850080e7          	jalr	-1968(ra) # 80000fcc <acquire>
    if(p->state == UNUSED) {
    80002784:	0184a783          	lw	a5,24(s1)
    80002788:	02078063          	beqz	a5,800027a8 <allocproc+0x58>
      release(&p->lock);
    8000278c:	00048513          	mv	a0,s1
    80002790:	fffff097          	auipc	ra,0xfffff
    80002794:	934080e7          	jalr	-1740(ra) # 800010c4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002798:	16848493          	addi	s1,s1,360
    8000279c:	fd249ee3          	bne	s1,s2,80002778 <allocproc+0x28>
  return 0;
    800027a0:	00000493          	li	s1,0
    800027a4:	0740006f          	j	80002818 <allocproc+0xc8>
  p->pid = allocpid();
    800027a8:	00000097          	auipc	ra,0x0
    800027ac:	d5c080e7          	jalr	-676(ra) # 80002504 <allocpid>
    800027b0:	02a4a823          	sw	a0,48(s1)
  p->state = USED;
    800027b4:	00100793          	li	a5,1
    800027b8:	00f4ac23          	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800027bc:	ffffe097          	auipc	ra,0xffffe
    800027c0:	6a4080e7          	jalr	1700(ra) # 80000e60 <kalloc>
    800027c4:	00050913          	mv	s2,a0
    800027c8:	04a4bc23          	sd	a0,88(s1)
    800027cc:	06050463          	beqz	a0,80002834 <allocproc+0xe4>
  p->pagetable = proc_pagetable(p);
    800027d0:	00048513          	mv	a0,s1
    800027d4:	00000097          	auipc	ra,0x0
    800027d8:	d98080e7          	jalr	-616(ra) # 8000256c <proc_pagetable>
    800027dc:	00050913          	mv	s2,a0
    800027e0:	04a4b823          	sd	a0,80(s1)
  if(p->pagetable == 0){
    800027e4:	06050863          	beqz	a0,80002854 <allocproc+0x104>
  memset(&p->context, 0, sizeof(p->context));
    800027e8:	07000613          	li	a2,112
    800027ec:	00000593          	li	a1,0
    800027f0:	06048513          	addi	a0,s1,96
    800027f4:	fffff097          	auipc	ra,0xfffff
    800027f8:	930080e7          	jalr	-1744(ra) # 80001124 <memset>
  p->context.ra = (uint64)forkret;
    800027fc:	00000797          	auipc	a5,0x0
    80002800:	cac78793          	addi	a5,a5,-852 # 800024a8 <forkret>
    80002804:	06f4b023          	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80002808:	0404b783          	ld	a5,64(s1)
    8000280c:	00001737          	lui	a4,0x1
    80002810:	00e787b3          	add	a5,a5,a4
    80002814:	06f4b423          	sd	a5,104(s1)
}
    80002818:	00048513          	mv	a0,s1
    8000281c:	01813083          	ld	ra,24(sp)
    80002820:	01013403          	ld	s0,16(sp)
    80002824:	00813483          	ld	s1,8(sp)
    80002828:	00013903          	ld	s2,0(sp)
    8000282c:	02010113          	addi	sp,sp,32
    80002830:	00008067          	ret
    freeproc(p);
    80002834:	00048513          	mv	a0,s1
    80002838:	00000097          	auipc	ra,0x0
    8000283c:	ea0080e7          	jalr	-352(ra) # 800026d8 <freeproc>
    release(&p->lock);
    80002840:	00048513          	mv	a0,s1
    80002844:	fffff097          	auipc	ra,0xfffff
    80002848:	880080e7          	jalr	-1920(ra) # 800010c4 <release>
    return 0;
    8000284c:	00090493          	mv	s1,s2
    80002850:	fc9ff06f          	j	80002818 <allocproc+0xc8>
    freeproc(p);
    80002854:	00048513          	mv	a0,s1
    80002858:	00000097          	auipc	ra,0x0
    8000285c:	e80080e7          	jalr	-384(ra) # 800026d8 <freeproc>
    release(&p->lock);
    80002860:	00048513          	mv	a0,s1
    80002864:	fffff097          	auipc	ra,0xfffff
    80002868:	860080e7          	jalr	-1952(ra) # 800010c4 <release>
    return 0;
    8000286c:	00090493          	mv	s1,s2
    80002870:	fa9ff06f          	j	80002818 <allocproc+0xc8>

0000000080002874 <userinit>:
{
    80002874:	fe010113          	addi	sp,sp,-32
    80002878:	00113c23          	sd	ra,24(sp)
    8000287c:	00813823          	sd	s0,16(sp)
    80002880:	00913423          	sd	s1,8(sp)
    80002884:	02010413          	addi	s0,sp,32
  p = allocproc();
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	ec8080e7          	jalr	-312(ra) # 80002750 <allocproc>
    80002890:	00050493          	mv	s1,a0
  initproc = p;
    80002894:	00008797          	auipc	a5,0x8
    80002898:	faa7ba23          	sd	a0,-76(a5) # 8000a848 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000289c:	03400613          	li	a2,52
    800028a0:	00008597          	auipc	a1,0x8
    800028a4:	f4058593          	addi	a1,a1,-192 # 8000a7e0 <initcode>
    800028a8:	05053503          	ld	a0,80(a0)
    800028ac:	fffff097          	auipc	ra,0xfffff
    800028b0:	1d8080e7          	jalr	472(ra) # 80001a84 <uvminit>
  p->sz = PGSIZE;
    800028b4:	000017b7          	lui	a5,0x1
    800028b8:	04f4b423          	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800028bc:	0584b703          	ld	a4,88(s1)
    800028c0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800028c4:	0584b703          	ld	a4,88(s1)
    800028c8:	02f73823          	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800028cc:	01000613          	li	a2,16
    800028d0:	00008597          	auipc	a1,0x8
    800028d4:	93058593          	addi	a1,a1,-1744 # 8000a200 <digits+0x1c0>
    800028d8:	15848513          	addi	a0,s1,344
    800028dc:	fffff097          	auipc	ra,0xfffff
    800028e0:	a48080e7          	jalr	-1464(ra) # 80001324 <safestrcpy>
  p->cwd = namei("/");
    800028e4:	00008517          	auipc	a0,0x8
    800028e8:	92c50513          	addi	a0,a0,-1748 # 8000a210 <digits+0x1d0>
    800028ec:	00003097          	auipc	ra,0x3
    800028f0:	d68080e7          	jalr	-664(ra) # 80005654 <namei>
    800028f4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800028f8:	00300793          	li	a5,3
    800028fc:	00f4ac23          	sw	a5,24(s1)
  release(&p->lock);
    80002900:	00048513          	mv	a0,s1
    80002904:	ffffe097          	auipc	ra,0xffffe
    80002908:	7c0080e7          	jalr	1984(ra) # 800010c4 <release>
}
    8000290c:	01813083          	ld	ra,24(sp)
    80002910:	01013403          	ld	s0,16(sp)
    80002914:	00813483          	ld	s1,8(sp)
    80002918:	02010113          	addi	sp,sp,32
    8000291c:	00008067          	ret

0000000080002920 <growproc>:
{
    80002920:	fe010113          	addi	sp,sp,-32
    80002924:	00113c23          	sd	ra,24(sp)
    80002928:	00813823          	sd	s0,16(sp)
    8000292c:	00913423          	sd	s1,8(sp)
    80002930:	01213023          	sd	s2,0(sp)
    80002934:	02010413          	addi	s0,sp,32
    80002938:	00050493          	mv	s1,a0
  struct proc *p = myproc();
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	b14080e7          	jalr	-1260(ra) # 80002450 <myproc>
    80002944:	00050913          	mv	s2,a0
  sz = p->sz;
    80002948:	04853583          	ld	a1,72(a0)
    8000294c:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80002950:	02904863          	bgtz	s1,80002980 <growproc+0x60>
  } else if(n < 0){
    80002954:	0404ce63          	bltz	s1,800029b0 <growproc+0x90>
  p->sz = sz;
    80002958:	02061613          	slli	a2,a2,0x20
    8000295c:	02065613          	srli	a2,a2,0x20
    80002960:	04c93423          	sd	a2,72(s2)
  return 0;
    80002964:	00000513          	li	a0,0
}
    80002968:	01813083          	ld	ra,24(sp)
    8000296c:	01013403          	ld	s0,16(sp)
    80002970:	00813483          	ld	s1,8(sp)
    80002974:	00013903          	ld	s2,0(sp)
    80002978:	02010113          	addi	sp,sp,32
    8000297c:	00008067          	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80002980:	00c4863b          	addw	a2,s1,a2
    80002984:	02061613          	slli	a2,a2,0x20
    80002988:	02065613          	srli	a2,a2,0x20
    8000298c:	02059593          	slli	a1,a1,0x20
    80002990:	0205d593          	srli	a1,a1,0x20
    80002994:	05053503          	ld	a0,80(a0)
    80002998:	fffff097          	auipc	ra,0xfffff
    8000299c:	214080e7          	jalr	532(ra) # 80001bac <uvmalloc>
    800029a0:	0005061b          	sext.w	a2,a0
    800029a4:	fa061ae3          	bnez	a2,80002958 <growproc+0x38>
      return -1;
    800029a8:	fff00513          	li	a0,-1
    800029ac:	fbdff06f          	j	80002968 <growproc+0x48>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800029b0:	00c4863b          	addw	a2,s1,a2
    800029b4:	02061613          	slli	a2,a2,0x20
    800029b8:	02065613          	srli	a2,a2,0x20
    800029bc:	02059593          	slli	a1,a1,0x20
    800029c0:	0205d593          	srli	a1,a1,0x20
    800029c4:	05053503          	ld	a0,80(a0)
    800029c8:	fffff097          	auipc	ra,0xfffff
    800029cc:	16c080e7          	jalr	364(ra) # 80001b34 <uvmdealloc>
    800029d0:	0005061b          	sext.w	a2,a0
    800029d4:	f85ff06f          	j	80002958 <growproc+0x38>

00000000800029d8 <fork>:
{
    800029d8:	fc010113          	addi	sp,sp,-64
    800029dc:	02113c23          	sd	ra,56(sp)
    800029e0:	02813823          	sd	s0,48(sp)
    800029e4:	02913423          	sd	s1,40(sp)
    800029e8:	03213023          	sd	s2,32(sp)
    800029ec:	01313c23          	sd	s3,24(sp)
    800029f0:	01413823          	sd	s4,16(sp)
    800029f4:	01513423          	sd	s5,8(sp)
    800029f8:	04010413          	addi	s0,sp,64
  struct proc *p = myproc();
    800029fc:	00000097          	auipc	ra,0x0
    80002a00:	a54080e7          	jalr	-1452(ra) # 80002450 <myproc>
    80002a04:	00050a93          	mv	s5,a0
  if((np = allocproc()) == 0){
    80002a08:	00000097          	auipc	ra,0x0
    80002a0c:	d48080e7          	jalr	-696(ra) # 80002750 <allocproc>
    80002a10:	16050063          	beqz	a0,80002b70 <fork+0x198>
    80002a14:	00050a13          	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002a18:	048ab603          	ld	a2,72(s5)
    80002a1c:	05053583          	ld	a1,80(a0)
    80002a20:	050ab503          	ld	a0,80(s5)
    80002a24:	fffff097          	auipc	ra,0xfffff
    80002a28:	3a0080e7          	jalr	928(ra) # 80001dc4 <uvmcopy>
    80002a2c:	06054063          	bltz	a0,80002a8c <fork+0xb4>
  np->sz = p->sz;
    80002a30:	048ab783          	ld	a5,72(s5)
    80002a34:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80002a38:	058ab683          	ld	a3,88(s5)
    80002a3c:	00068793          	mv	a5,a3
    80002a40:	058a3703          	ld	a4,88(s4)
    80002a44:	12068693          	addi	a3,a3,288
    80002a48:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002a4c:	0087b503          	ld	a0,8(a5)
    80002a50:	0107b583          	ld	a1,16(a5)
    80002a54:	0187b603          	ld	a2,24(a5)
    80002a58:	01073023          	sd	a6,0(a4)
    80002a5c:	00a73423          	sd	a0,8(a4)
    80002a60:	00b73823          	sd	a1,16(a4)
    80002a64:	00c73c23          	sd	a2,24(a4)
    80002a68:	02078793          	addi	a5,a5,32
    80002a6c:	02070713          	addi	a4,a4,32
    80002a70:	fcd79ce3          	bne	a5,a3,80002a48 <fork+0x70>
  np->trapframe->a0 = 0;
    80002a74:	058a3783          	ld	a5,88(s4)
    80002a78:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002a7c:	0d0a8493          	addi	s1,s5,208
    80002a80:	0d0a0913          	addi	s2,s4,208
    80002a84:	150a8993          	addi	s3,s5,336
    80002a88:	0300006f          	j	80002ab8 <fork+0xe0>
    freeproc(np);
    80002a8c:	000a0513          	mv	a0,s4
    80002a90:	00000097          	auipc	ra,0x0
    80002a94:	c48080e7          	jalr	-952(ra) # 800026d8 <freeproc>
    release(&np->lock);
    80002a98:	000a0513          	mv	a0,s4
    80002a9c:	ffffe097          	auipc	ra,0xffffe
    80002aa0:	628080e7          	jalr	1576(ra) # 800010c4 <release>
    return -1;
    80002aa4:	fff00913          	li	s2,-1
    80002aa8:	0a00006f          	j	80002b48 <fork+0x170>
  for(i = 0; i < NOFILE; i++)
    80002aac:	00848493          	addi	s1,s1,8
    80002ab0:	00890913          	addi	s2,s2,8
    80002ab4:	01348e63          	beq	s1,s3,80002ad0 <fork+0xf8>
    if(p->ofile[i])
    80002ab8:	0004b503          	ld	a0,0(s1)
    80002abc:	fe0508e3          	beqz	a0,80002aac <fork+0xd4>
      np->ofile[i] = filedup(p->ofile[i]);
    80002ac0:	00003097          	auipc	ra,0x3
    80002ac4:	4a0080e7          	jalr	1184(ra) # 80005f60 <filedup>
    80002ac8:	00a93023          	sd	a0,0(s2)
    80002acc:	fe1ff06f          	j	80002aac <fork+0xd4>
  np->cwd = idup(p->cwd);
    80002ad0:	150ab503          	ld	a0,336(s5)
    80002ad4:	00002097          	auipc	ra,0x2
    80002ad8:	02c080e7          	jalr	44(ra) # 80004b00 <idup>
    80002adc:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002ae0:	01000613          	li	a2,16
    80002ae4:	158a8593          	addi	a1,s5,344
    80002ae8:	158a0513          	addi	a0,s4,344
    80002aec:	fffff097          	auipc	ra,0xfffff
    80002af0:	838080e7          	jalr	-1992(ra) # 80001324 <safestrcpy>
  pid = np->pid;
    80002af4:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80002af8:	000a0513          	mv	a0,s4
    80002afc:	ffffe097          	auipc	ra,0xffffe
    80002b00:	5c8080e7          	jalr	1480(ra) # 800010c4 <release>
  acquire(&wait_lock);
    80002b04:	00010497          	auipc	s1,0x10
    80002b08:	fd448493          	addi	s1,s1,-44 # 80012ad8 <wait_lock>
    80002b0c:	00048513          	mv	a0,s1
    80002b10:	ffffe097          	auipc	ra,0xffffe
    80002b14:	4bc080e7          	jalr	1212(ra) # 80000fcc <acquire>
  np->parent = p;
    80002b18:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80002b1c:	00048513          	mv	a0,s1
    80002b20:	ffffe097          	auipc	ra,0xffffe
    80002b24:	5a4080e7          	jalr	1444(ra) # 800010c4 <release>
  acquire(&np->lock);
    80002b28:	000a0513          	mv	a0,s4
    80002b2c:	ffffe097          	auipc	ra,0xffffe
    80002b30:	4a0080e7          	jalr	1184(ra) # 80000fcc <acquire>
  np->state = RUNNABLE;
    80002b34:	00300793          	li	a5,3
    80002b38:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80002b3c:	000a0513          	mv	a0,s4
    80002b40:	ffffe097          	auipc	ra,0xffffe
    80002b44:	584080e7          	jalr	1412(ra) # 800010c4 <release>
}
    80002b48:	00090513          	mv	a0,s2
    80002b4c:	03813083          	ld	ra,56(sp)
    80002b50:	03013403          	ld	s0,48(sp)
    80002b54:	02813483          	ld	s1,40(sp)
    80002b58:	02013903          	ld	s2,32(sp)
    80002b5c:	01813983          	ld	s3,24(sp)
    80002b60:	01013a03          	ld	s4,16(sp)
    80002b64:	00813a83          	ld	s5,8(sp)
    80002b68:	04010113          	addi	sp,sp,64
    80002b6c:	00008067          	ret
    return -1;
    80002b70:	fff00913          	li	s2,-1
    80002b74:	fd5ff06f          	j	80002b48 <fork+0x170>

0000000080002b78 <scheduler>:
{
    80002b78:	fc010113          	addi	sp,sp,-64
    80002b7c:	02113c23          	sd	ra,56(sp)
    80002b80:	02813823          	sd	s0,48(sp)
    80002b84:	02913423          	sd	s1,40(sp)
    80002b88:	03213023          	sd	s2,32(sp)
    80002b8c:	01313c23          	sd	s3,24(sp)
    80002b90:	01413823          	sd	s4,16(sp)
    80002b94:	01513423          	sd	s5,8(sp)
    80002b98:	01613023          	sd	s6,0(sp)
    80002b9c:	04010413          	addi	s0,sp,64
    80002ba0:	00020793          	mv	a5,tp
  int id = r_tp();
    80002ba4:	0007879b          	sext.w	a5,a5
  c->proc = 0;
    80002ba8:	00779a93          	slli	s5,a5,0x7
    80002bac:	00010717          	auipc	a4,0x10
    80002bb0:	f1470713          	addi	a4,a4,-236 # 80012ac0 <pid_lock>
    80002bb4:	01570733          	add	a4,a4,s5
    80002bb8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002bbc:	00010717          	auipc	a4,0x10
    80002bc0:	f3c70713          	addi	a4,a4,-196 # 80012af8 <cpus+0x8>
    80002bc4:	00ea8ab3          	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80002bc8:	00300993          	li	s3,3
        p->state = RUNNING;
    80002bcc:	00400b13          	li	s6,4
        c->proc = p;
    80002bd0:	00779793          	slli	a5,a5,0x7
    80002bd4:	00010a17          	auipc	s4,0x10
    80002bd8:	eeca0a13          	addi	s4,s4,-276 # 80012ac0 <pid_lock>
    80002bdc:	00fa0a33          	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002be0:	00016917          	auipc	s2,0x16
    80002be4:	d1090913          	addi	s2,s2,-752 # 800188f0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002be8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002bec:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bf0:	10079073          	csrw	sstatus,a5
    80002bf4:	00010497          	auipc	s1,0x10
    80002bf8:	2fc48493          	addi	s1,s1,764 # 80012ef0 <proc>
    80002bfc:	0180006f          	j	80002c14 <scheduler+0x9c>
      release(&p->lock);
    80002c00:	00048513          	mv	a0,s1
    80002c04:	ffffe097          	auipc	ra,0xffffe
    80002c08:	4c0080e7          	jalr	1216(ra) # 800010c4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002c0c:	16848493          	addi	s1,s1,360
    80002c10:	fd248ce3          	beq	s1,s2,80002be8 <scheduler+0x70>
      acquire(&p->lock);
    80002c14:	00048513          	mv	a0,s1
    80002c18:	ffffe097          	auipc	ra,0xffffe
    80002c1c:	3b4080e7          	jalr	948(ra) # 80000fcc <acquire>
      if(p->state == RUNNABLE) {
    80002c20:	0184a783          	lw	a5,24(s1)
    80002c24:	fd379ee3          	bne	a5,s3,80002c00 <scheduler+0x88>
        p->state = RUNNING;
    80002c28:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002c2c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80002c30:	06048593          	addi	a1,s1,96
    80002c34:	000a8513          	mv	a0,s5
    80002c38:	00001097          	auipc	ra,0x1
    80002c3c:	894080e7          	jalr	-1900(ra) # 800034cc <swtch>
        c->proc = 0;
    80002c40:	020a3823          	sd	zero,48(s4)
    80002c44:	fbdff06f          	j	80002c00 <scheduler+0x88>

0000000080002c48 <sched>:
{
    80002c48:	fd010113          	addi	sp,sp,-48
    80002c4c:	02113423          	sd	ra,40(sp)
    80002c50:	02813023          	sd	s0,32(sp)
    80002c54:	00913c23          	sd	s1,24(sp)
    80002c58:	01213823          	sd	s2,16(sp)
    80002c5c:	01313423          	sd	s3,8(sp)
    80002c60:	03010413          	addi	s0,sp,48
  struct proc *p = myproc();
    80002c64:	fffff097          	auipc	ra,0xfffff
    80002c68:	7ec080e7          	jalr	2028(ra) # 80002450 <myproc>
    80002c6c:	00050493          	mv	s1,a0
  if(!holding(&p->lock))
    80002c70:	ffffe097          	auipc	ra,0xffffe
    80002c74:	29c080e7          	jalr	668(ra) # 80000f0c <holding>
    80002c78:	0a050863          	beqz	a0,80002d28 <sched+0xe0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c7c:	00020793          	mv	a5,tp
  if(mycpu()->noff != 1)
    80002c80:	0007879b          	sext.w	a5,a5
    80002c84:	00779793          	slli	a5,a5,0x7
    80002c88:	00010717          	auipc	a4,0x10
    80002c8c:	e3870713          	addi	a4,a4,-456 # 80012ac0 <pid_lock>
    80002c90:	00f707b3          	add	a5,a4,a5
    80002c94:	0a87a703          	lw	a4,168(a5)
    80002c98:	00100793          	li	a5,1
    80002c9c:	08f71e63          	bne	a4,a5,80002d38 <sched+0xf0>
  if(p->state == RUNNING)
    80002ca0:	0184a703          	lw	a4,24(s1)
    80002ca4:	00400793          	li	a5,4
    80002ca8:	0af70063          	beq	a4,a5,80002d48 <sched+0x100>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cac:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002cb0:	0027f793          	andi	a5,a5,2
  if(intr_get())
    80002cb4:	0a079263          	bnez	a5,80002d58 <sched+0x110>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002cb8:	00020793          	mv	a5,tp
  intena = mycpu()->intena;
    80002cbc:	00010917          	auipc	s2,0x10
    80002cc0:	e0490913          	addi	s2,s2,-508 # 80012ac0 <pid_lock>
    80002cc4:	0007879b          	sext.w	a5,a5
    80002cc8:	00779793          	slli	a5,a5,0x7
    80002ccc:	00f907b3          	add	a5,s2,a5
    80002cd0:	0ac7a983          	lw	s3,172(a5)
    80002cd4:	00020793          	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002cd8:	0007879b          	sext.w	a5,a5
    80002cdc:	00779793          	slli	a5,a5,0x7
    80002ce0:	00010597          	auipc	a1,0x10
    80002ce4:	e1858593          	addi	a1,a1,-488 # 80012af8 <cpus+0x8>
    80002ce8:	00b785b3          	add	a1,a5,a1
    80002cec:	06048513          	addi	a0,s1,96
    80002cf0:	00000097          	auipc	ra,0x0
    80002cf4:	7dc080e7          	jalr	2012(ra) # 800034cc <swtch>
    80002cf8:	00020793          	mv	a5,tp
  mycpu()->intena = intena;
    80002cfc:	0007879b          	sext.w	a5,a5
    80002d00:	00779793          	slli	a5,a5,0x7
    80002d04:	00f907b3          	add	a5,s2,a5
    80002d08:	0b37a623          	sw	s3,172(a5)
}
    80002d0c:	02813083          	ld	ra,40(sp)
    80002d10:	02013403          	ld	s0,32(sp)
    80002d14:	01813483          	ld	s1,24(sp)
    80002d18:	01013903          	ld	s2,16(sp)
    80002d1c:	00813983          	ld	s3,8(sp)
    80002d20:	03010113          	addi	sp,sp,48
    80002d24:	00008067          	ret
    panic("sched p->lock");
    80002d28:	00007517          	auipc	a0,0x7
    80002d2c:	4f050513          	addi	a0,a0,1264 # 8000a218 <digits+0x1d8>
    80002d30:	ffffe097          	auipc	ra,0xffffe
    80002d34:	99c080e7          	jalr	-1636(ra) # 800006cc <panic>
    panic("sched locks");
    80002d38:	00007517          	auipc	a0,0x7
    80002d3c:	4f050513          	addi	a0,a0,1264 # 8000a228 <digits+0x1e8>
    80002d40:	ffffe097          	auipc	ra,0xffffe
    80002d44:	98c080e7          	jalr	-1652(ra) # 800006cc <panic>
    panic("sched running");
    80002d48:	00007517          	auipc	a0,0x7
    80002d4c:	4f050513          	addi	a0,a0,1264 # 8000a238 <digits+0x1f8>
    80002d50:	ffffe097          	auipc	ra,0xffffe
    80002d54:	97c080e7          	jalr	-1668(ra) # 800006cc <panic>
    panic("sched interruptible");
    80002d58:	00007517          	auipc	a0,0x7
    80002d5c:	4f050513          	addi	a0,a0,1264 # 8000a248 <digits+0x208>
    80002d60:	ffffe097          	auipc	ra,0xffffe
    80002d64:	96c080e7          	jalr	-1684(ra) # 800006cc <panic>

0000000080002d68 <yield>:
{
    80002d68:	fe010113          	addi	sp,sp,-32
    80002d6c:	00113c23          	sd	ra,24(sp)
    80002d70:	00813823          	sd	s0,16(sp)
    80002d74:	00913423          	sd	s1,8(sp)
    80002d78:	02010413          	addi	s0,sp,32
  struct proc *p = myproc();
    80002d7c:	fffff097          	auipc	ra,0xfffff
    80002d80:	6d4080e7          	jalr	1748(ra) # 80002450 <myproc>
    80002d84:	00050493          	mv	s1,a0
  acquire(&p->lock);
    80002d88:	ffffe097          	auipc	ra,0xffffe
    80002d8c:	244080e7          	jalr	580(ra) # 80000fcc <acquire>
  p->state = RUNNABLE;
    80002d90:	00300793          	li	a5,3
    80002d94:	00f4ac23          	sw	a5,24(s1)
  sched();
    80002d98:	00000097          	auipc	ra,0x0
    80002d9c:	eb0080e7          	jalr	-336(ra) # 80002c48 <sched>
  release(&p->lock);
    80002da0:	00048513          	mv	a0,s1
    80002da4:	ffffe097          	auipc	ra,0xffffe
    80002da8:	320080e7          	jalr	800(ra) # 800010c4 <release>
}
    80002dac:	01813083          	ld	ra,24(sp)
    80002db0:	01013403          	ld	s0,16(sp)
    80002db4:	00813483          	ld	s1,8(sp)
    80002db8:	02010113          	addi	sp,sp,32
    80002dbc:	00008067          	ret

0000000080002dc0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002dc0:	fd010113          	addi	sp,sp,-48
    80002dc4:	02113423          	sd	ra,40(sp)
    80002dc8:	02813023          	sd	s0,32(sp)
    80002dcc:	00913c23          	sd	s1,24(sp)
    80002dd0:	01213823          	sd	s2,16(sp)
    80002dd4:	01313423          	sd	s3,8(sp)
    80002dd8:	03010413          	addi	s0,sp,48
    80002ddc:	00050993          	mv	s3,a0
    80002de0:	00058913          	mv	s2,a1
  struct proc *p = myproc();
    80002de4:	fffff097          	auipc	ra,0xfffff
    80002de8:	66c080e7          	jalr	1644(ra) # 80002450 <myproc>
    80002dec:	00050493          	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002df0:	ffffe097          	auipc	ra,0xffffe
    80002df4:	1dc080e7          	jalr	476(ra) # 80000fcc <acquire>
  release(lk);
    80002df8:	00090513          	mv	a0,s2
    80002dfc:	ffffe097          	auipc	ra,0xffffe
    80002e00:	2c8080e7          	jalr	712(ra) # 800010c4 <release>

  // Go to sleep.
  p->chan = chan;
    80002e04:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002e08:	00200793          	li	a5,2
    80002e0c:	00f4ac23          	sw	a5,24(s1)

  sched();
    80002e10:	00000097          	auipc	ra,0x0
    80002e14:	e38080e7          	jalr	-456(ra) # 80002c48 <sched>

  // Tidy up.
  p->chan = 0;
    80002e18:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002e1c:	00048513          	mv	a0,s1
    80002e20:	ffffe097          	auipc	ra,0xffffe
    80002e24:	2a4080e7          	jalr	676(ra) # 800010c4 <release>
  acquire(lk);
    80002e28:	00090513          	mv	a0,s2
    80002e2c:	ffffe097          	auipc	ra,0xffffe
    80002e30:	1a0080e7          	jalr	416(ra) # 80000fcc <acquire>
}
    80002e34:	02813083          	ld	ra,40(sp)
    80002e38:	02013403          	ld	s0,32(sp)
    80002e3c:	01813483          	ld	s1,24(sp)
    80002e40:	01013903          	ld	s2,16(sp)
    80002e44:	00813983          	ld	s3,8(sp)
    80002e48:	03010113          	addi	sp,sp,48
    80002e4c:	00008067          	ret

0000000080002e50 <wait>:
{
    80002e50:	fb010113          	addi	sp,sp,-80
    80002e54:	04113423          	sd	ra,72(sp)
    80002e58:	04813023          	sd	s0,64(sp)
    80002e5c:	02913c23          	sd	s1,56(sp)
    80002e60:	03213823          	sd	s2,48(sp)
    80002e64:	03313423          	sd	s3,40(sp)
    80002e68:	03413023          	sd	s4,32(sp)
    80002e6c:	01513c23          	sd	s5,24(sp)
    80002e70:	01613823          	sd	s6,16(sp)
    80002e74:	01713423          	sd	s7,8(sp)
    80002e78:	01813023          	sd	s8,0(sp)
    80002e7c:	05010413          	addi	s0,sp,80
    80002e80:	00050b13          	mv	s6,a0
  struct proc *p = myproc();
    80002e84:	fffff097          	auipc	ra,0xfffff
    80002e88:	5cc080e7          	jalr	1484(ra) # 80002450 <myproc>
    80002e8c:	00050913          	mv	s2,a0
  acquire(&wait_lock);
    80002e90:	00010517          	auipc	a0,0x10
    80002e94:	c4850513          	addi	a0,a0,-952 # 80012ad8 <wait_lock>
    80002e98:	ffffe097          	auipc	ra,0xffffe
    80002e9c:	134080e7          	jalr	308(ra) # 80000fcc <acquire>
    havekids = 0;
    80002ea0:	00000b93          	li	s7,0
        if(np->state == ZOMBIE){
    80002ea4:	00500a13          	li	s4,5
        havekids = 1;
    80002ea8:	00100a93          	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002eac:	00016997          	auipc	s3,0x16
    80002eb0:	a4498993          	addi	s3,s3,-1468 # 800188f0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002eb4:	00010c17          	auipc	s8,0x10
    80002eb8:	c24c0c13          	addi	s8,s8,-988 # 80012ad8 <wait_lock>
    havekids = 0;
    80002ebc:	000b8713          	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002ec0:	00010497          	auipc	s1,0x10
    80002ec4:	03048493          	addi	s1,s1,48 # 80012ef0 <proc>
    80002ec8:	0800006f          	j	80002f48 <wait+0xf8>
          pid = np->pid;
    80002ecc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002ed0:	020b0063          	beqz	s6,80002ef0 <wait+0xa0>
    80002ed4:	00400693          	li	a3,4
    80002ed8:	02c48613          	addi	a2,s1,44
    80002edc:	000b0593          	mv	a1,s6
    80002ee0:	05093503          	ld	a0,80(s2)
    80002ee4:	fffff097          	auipc	ra,0xfffff
    80002ee8:	074080e7          	jalr	116(ra) # 80001f58 <copyout>
    80002eec:	02054863          	bltz	a0,80002f1c <wait+0xcc>
          freeproc(np);
    80002ef0:	00048513          	mv	a0,s1
    80002ef4:	fffff097          	auipc	ra,0xfffff
    80002ef8:	7e4080e7          	jalr	2020(ra) # 800026d8 <freeproc>
          release(&np->lock);
    80002efc:	00048513          	mv	a0,s1
    80002f00:	ffffe097          	auipc	ra,0xffffe
    80002f04:	1c4080e7          	jalr	452(ra) # 800010c4 <release>
          release(&wait_lock);
    80002f08:	00010517          	auipc	a0,0x10
    80002f0c:	bd050513          	addi	a0,a0,-1072 # 80012ad8 <wait_lock>
    80002f10:	ffffe097          	auipc	ra,0xffffe
    80002f14:	1b4080e7          	jalr	436(ra) # 800010c4 <release>
          return pid;
    80002f18:	0800006f          	j	80002f98 <wait+0x148>
            release(&np->lock);
    80002f1c:	00048513          	mv	a0,s1
    80002f20:	ffffe097          	auipc	ra,0xffffe
    80002f24:	1a4080e7          	jalr	420(ra) # 800010c4 <release>
            release(&wait_lock);
    80002f28:	00010517          	auipc	a0,0x10
    80002f2c:	bb050513          	addi	a0,a0,-1104 # 80012ad8 <wait_lock>
    80002f30:	ffffe097          	auipc	ra,0xffffe
    80002f34:	194080e7          	jalr	404(ra) # 800010c4 <release>
            return -1;
    80002f38:	fff00993          	li	s3,-1
    80002f3c:	05c0006f          	j	80002f98 <wait+0x148>
    for(np = proc; np < &proc[NPROC]; np++){
    80002f40:	16848493          	addi	s1,s1,360
    80002f44:	03348a63          	beq	s1,s3,80002f78 <wait+0x128>
      if(np->parent == p){
    80002f48:	0384b783          	ld	a5,56(s1)
    80002f4c:	ff279ae3          	bne	a5,s2,80002f40 <wait+0xf0>
        acquire(&np->lock);
    80002f50:	00048513          	mv	a0,s1
    80002f54:	ffffe097          	auipc	ra,0xffffe
    80002f58:	078080e7          	jalr	120(ra) # 80000fcc <acquire>
        if(np->state == ZOMBIE){
    80002f5c:	0184a783          	lw	a5,24(s1)
    80002f60:	f74786e3          	beq	a5,s4,80002ecc <wait+0x7c>
        release(&np->lock);
    80002f64:	00048513          	mv	a0,s1
    80002f68:	ffffe097          	auipc	ra,0xffffe
    80002f6c:	15c080e7          	jalr	348(ra) # 800010c4 <release>
        havekids = 1;
    80002f70:	000a8713          	mv	a4,s5
    80002f74:	fcdff06f          	j	80002f40 <wait+0xf0>
    if(!havekids || p->killed){
    80002f78:	00070663          	beqz	a4,80002f84 <wait+0x134>
    80002f7c:	02892783          	lw	a5,40(s2)
    80002f80:	04078663          	beqz	a5,80002fcc <wait+0x17c>
      release(&wait_lock);
    80002f84:	00010517          	auipc	a0,0x10
    80002f88:	b5450513          	addi	a0,a0,-1196 # 80012ad8 <wait_lock>
    80002f8c:	ffffe097          	auipc	ra,0xffffe
    80002f90:	138080e7          	jalr	312(ra) # 800010c4 <release>
      return -1;
    80002f94:	fff00993          	li	s3,-1
}
    80002f98:	00098513          	mv	a0,s3
    80002f9c:	04813083          	ld	ra,72(sp)
    80002fa0:	04013403          	ld	s0,64(sp)
    80002fa4:	03813483          	ld	s1,56(sp)
    80002fa8:	03013903          	ld	s2,48(sp)
    80002fac:	02813983          	ld	s3,40(sp)
    80002fb0:	02013a03          	ld	s4,32(sp)
    80002fb4:	01813a83          	ld	s5,24(sp)
    80002fb8:	01013b03          	ld	s6,16(sp)
    80002fbc:	00813b83          	ld	s7,8(sp)
    80002fc0:	00013c03          	ld	s8,0(sp)
    80002fc4:	05010113          	addi	sp,sp,80
    80002fc8:	00008067          	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002fcc:	000c0593          	mv	a1,s8
    80002fd0:	00090513          	mv	a0,s2
    80002fd4:	00000097          	auipc	ra,0x0
    80002fd8:	dec080e7          	jalr	-532(ra) # 80002dc0 <sleep>
    havekids = 0;
    80002fdc:	ee1ff06f          	j	80002ebc <wait+0x6c>

0000000080002fe0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002fe0:	fc010113          	addi	sp,sp,-64
    80002fe4:	02113c23          	sd	ra,56(sp)
    80002fe8:	02813823          	sd	s0,48(sp)
    80002fec:	02913423          	sd	s1,40(sp)
    80002ff0:	03213023          	sd	s2,32(sp)
    80002ff4:	01313c23          	sd	s3,24(sp)
    80002ff8:	01413823          	sd	s4,16(sp)
    80002ffc:	01513423          	sd	s5,8(sp)
    80003000:	04010413          	addi	s0,sp,64
    80003004:	00050a13          	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80003008:	00010497          	auipc	s1,0x10
    8000300c:	ee848493          	addi	s1,s1,-280 # 80012ef0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80003010:	00200993          	li	s3,2
        p->state = RUNNABLE;
    80003014:	00300a93          	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80003018:	00016917          	auipc	s2,0x16
    8000301c:	8d890913          	addi	s2,s2,-1832 # 800188f0 <tickslock>
    80003020:	0180006f          	j	80003038 <wakeup+0x58>
      }
      release(&p->lock);
    80003024:	00048513          	mv	a0,s1
    80003028:	ffffe097          	auipc	ra,0xffffe
    8000302c:	09c080e7          	jalr	156(ra) # 800010c4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80003030:	16848493          	addi	s1,s1,360
    80003034:	03248a63          	beq	s1,s2,80003068 <wakeup+0x88>
    if(p != myproc()){
    80003038:	fffff097          	auipc	ra,0xfffff
    8000303c:	418080e7          	jalr	1048(ra) # 80002450 <myproc>
    80003040:	fea488e3          	beq	s1,a0,80003030 <wakeup+0x50>
      acquire(&p->lock);
    80003044:	00048513          	mv	a0,s1
    80003048:	ffffe097          	auipc	ra,0xffffe
    8000304c:	f84080e7          	jalr	-124(ra) # 80000fcc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80003050:	0184a783          	lw	a5,24(s1)
    80003054:	fd3798e3          	bne	a5,s3,80003024 <wakeup+0x44>
    80003058:	0204b783          	ld	a5,32(s1)
    8000305c:	fd4794e3          	bne	a5,s4,80003024 <wakeup+0x44>
        p->state = RUNNABLE;
    80003060:	0154ac23          	sw	s5,24(s1)
    80003064:	fc1ff06f          	j	80003024 <wakeup+0x44>
    }
  }
}
    80003068:	03813083          	ld	ra,56(sp)
    8000306c:	03013403          	ld	s0,48(sp)
    80003070:	02813483          	ld	s1,40(sp)
    80003074:	02013903          	ld	s2,32(sp)
    80003078:	01813983          	ld	s3,24(sp)
    8000307c:	01013a03          	ld	s4,16(sp)
    80003080:	00813a83          	ld	s5,8(sp)
    80003084:	04010113          	addi	sp,sp,64
    80003088:	00008067          	ret

000000008000308c <reparent>:
{
    8000308c:	fd010113          	addi	sp,sp,-48
    80003090:	02113423          	sd	ra,40(sp)
    80003094:	02813023          	sd	s0,32(sp)
    80003098:	00913c23          	sd	s1,24(sp)
    8000309c:	01213823          	sd	s2,16(sp)
    800030a0:	01313423          	sd	s3,8(sp)
    800030a4:	01413023          	sd	s4,0(sp)
    800030a8:	03010413          	addi	s0,sp,48
    800030ac:	00050913          	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800030b0:	00010497          	auipc	s1,0x10
    800030b4:	e4048493          	addi	s1,s1,-448 # 80012ef0 <proc>
      pp->parent = initproc;
    800030b8:	00007a17          	auipc	s4,0x7
    800030bc:	790a0a13          	addi	s4,s4,1936 # 8000a848 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800030c0:	00016997          	auipc	s3,0x16
    800030c4:	83098993          	addi	s3,s3,-2000 # 800188f0 <tickslock>
    800030c8:	00c0006f          	j	800030d4 <reparent+0x48>
    800030cc:	16848493          	addi	s1,s1,360
    800030d0:	03348063          	beq	s1,s3,800030f0 <reparent+0x64>
    if(pp->parent == p){
    800030d4:	0384b783          	ld	a5,56(s1)
    800030d8:	ff279ae3          	bne	a5,s2,800030cc <reparent+0x40>
      pp->parent = initproc;
    800030dc:	000a3503          	ld	a0,0(s4)
    800030e0:	02a4bc23          	sd	a0,56(s1)
      wakeup(initproc);
    800030e4:	00000097          	auipc	ra,0x0
    800030e8:	efc080e7          	jalr	-260(ra) # 80002fe0 <wakeup>
    800030ec:	fe1ff06f          	j	800030cc <reparent+0x40>
}
    800030f0:	02813083          	ld	ra,40(sp)
    800030f4:	02013403          	ld	s0,32(sp)
    800030f8:	01813483          	ld	s1,24(sp)
    800030fc:	01013903          	ld	s2,16(sp)
    80003100:	00813983          	ld	s3,8(sp)
    80003104:	00013a03          	ld	s4,0(sp)
    80003108:	03010113          	addi	sp,sp,48
    8000310c:	00008067          	ret

0000000080003110 <exit>:
{
    80003110:	fd010113          	addi	sp,sp,-48
    80003114:	02113423          	sd	ra,40(sp)
    80003118:	02813023          	sd	s0,32(sp)
    8000311c:	00913c23          	sd	s1,24(sp)
    80003120:	01213823          	sd	s2,16(sp)
    80003124:	01313423          	sd	s3,8(sp)
    80003128:	01413023          	sd	s4,0(sp)
    8000312c:	03010413          	addi	s0,sp,48
    80003130:	00050a13          	mv	s4,a0
  struct proc *p = myproc();
    80003134:	fffff097          	auipc	ra,0xfffff
    80003138:	31c080e7          	jalr	796(ra) # 80002450 <myproc>
    8000313c:	00050993          	mv	s3,a0
  if(p == initproc)
    80003140:	00007797          	auipc	a5,0x7
    80003144:	7087b783          	ld	a5,1800(a5) # 8000a848 <initproc>
    80003148:	0d050493          	addi	s1,a0,208
    8000314c:	15050913          	addi	s2,a0,336
    80003150:	02a79463          	bne	a5,a0,80003178 <exit+0x68>
    panic("init exiting");
    80003154:	00007517          	auipc	a0,0x7
    80003158:	10c50513          	addi	a0,a0,268 # 8000a260 <digits+0x220>
    8000315c:	ffffd097          	auipc	ra,0xffffd
    80003160:	570080e7          	jalr	1392(ra) # 800006cc <panic>
      fileclose(f);
    80003164:	00003097          	auipc	ra,0x3
    80003168:	e6c080e7          	jalr	-404(ra) # 80005fd0 <fileclose>
      p->ofile[fd] = 0;
    8000316c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80003170:	00848493          	addi	s1,s1,8
    80003174:	01248863          	beq	s1,s2,80003184 <exit+0x74>
    if(p->ofile[fd]){
    80003178:	0004b503          	ld	a0,0(s1)
    8000317c:	fe0514e3          	bnez	a0,80003164 <exit+0x54>
    80003180:	ff1ff06f          	j	80003170 <exit+0x60>
  begin_op();
    80003184:	00002097          	auipc	ra,0x2
    80003188:	7c0080e7          	jalr	1984(ra) # 80005944 <begin_op>
  iput(p->cwd);
    8000318c:	1509b503          	ld	a0,336(s3)
    80003190:	00002097          	auipc	ra,0x2
    80003194:	c2c080e7          	jalr	-980(ra) # 80004dbc <iput>
  end_op();
    80003198:	00003097          	auipc	ra,0x3
    8000319c:	860080e7          	jalr	-1952(ra) # 800059f8 <end_op>
  p->cwd = 0;
    800031a0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800031a4:	00010497          	auipc	s1,0x10
    800031a8:	93448493          	addi	s1,s1,-1740 # 80012ad8 <wait_lock>
    800031ac:	00048513          	mv	a0,s1
    800031b0:	ffffe097          	auipc	ra,0xffffe
    800031b4:	e1c080e7          	jalr	-484(ra) # 80000fcc <acquire>
  reparent(p);
    800031b8:	00098513          	mv	a0,s3
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	ed0080e7          	jalr	-304(ra) # 8000308c <reparent>
  wakeup(p->parent);
    800031c4:	0389b503          	ld	a0,56(s3)
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	e18080e7          	jalr	-488(ra) # 80002fe0 <wakeup>
  acquire(&p->lock);
    800031d0:	00098513          	mv	a0,s3
    800031d4:	ffffe097          	auipc	ra,0xffffe
    800031d8:	df8080e7          	jalr	-520(ra) # 80000fcc <acquire>
  p->xstate = status;
    800031dc:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800031e0:	00500793          	li	a5,5
    800031e4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800031e8:	00048513          	mv	a0,s1
    800031ec:	ffffe097          	auipc	ra,0xffffe
    800031f0:	ed8080e7          	jalr	-296(ra) # 800010c4 <release>
  sched();
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	a54080e7          	jalr	-1452(ra) # 80002c48 <sched>
  panic("zombie exit");
    800031fc:	00007517          	auipc	a0,0x7
    80003200:	07450513          	addi	a0,a0,116 # 8000a270 <digits+0x230>
    80003204:	ffffd097          	auipc	ra,0xffffd
    80003208:	4c8080e7          	jalr	1224(ra) # 800006cc <panic>

000000008000320c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000320c:	fd010113          	addi	sp,sp,-48
    80003210:	02113423          	sd	ra,40(sp)
    80003214:	02813023          	sd	s0,32(sp)
    80003218:	00913c23          	sd	s1,24(sp)
    8000321c:	01213823          	sd	s2,16(sp)
    80003220:	01313423          	sd	s3,8(sp)
    80003224:	03010413          	addi	s0,sp,48
    80003228:	00050913          	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000322c:	00010497          	auipc	s1,0x10
    80003230:	cc448493          	addi	s1,s1,-828 # 80012ef0 <proc>
    80003234:	00015997          	auipc	s3,0x15
    80003238:	6bc98993          	addi	s3,s3,1724 # 800188f0 <tickslock>
    acquire(&p->lock);
    8000323c:	00048513          	mv	a0,s1
    80003240:	ffffe097          	auipc	ra,0xffffe
    80003244:	d8c080e7          	jalr	-628(ra) # 80000fcc <acquire>
    if(p->pid == pid){
    80003248:	0304a783          	lw	a5,48(s1)
    8000324c:	03278063          	beq	a5,s2,8000326c <kill+0x60>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80003250:	00048513          	mv	a0,s1
    80003254:	ffffe097          	auipc	ra,0xffffe
    80003258:	e70080e7          	jalr	-400(ra) # 800010c4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000325c:	16848493          	addi	s1,s1,360
    80003260:	fd349ee3          	bne	s1,s3,8000323c <kill+0x30>
  }
  return -1;
    80003264:	fff00513          	li	a0,-1
    80003268:	0280006f          	j	80003290 <kill+0x84>
      p->killed = 1;
    8000326c:	00100793          	li	a5,1
    80003270:	02f4a423          	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80003274:	0184a703          	lw	a4,24(s1)
    80003278:	00200793          	li	a5,2
    8000327c:	02f70863          	beq	a4,a5,800032ac <kill+0xa0>
      release(&p->lock);
    80003280:	00048513          	mv	a0,s1
    80003284:	ffffe097          	auipc	ra,0xffffe
    80003288:	e40080e7          	jalr	-448(ra) # 800010c4 <release>
      return 0;
    8000328c:	00000513          	li	a0,0
}
    80003290:	02813083          	ld	ra,40(sp)
    80003294:	02013403          	ld	s0,32(sp)
    80003298:	01813483          	ld	s1,24(sp)
    8000329c:	01013903          	ld	s2,16(sp)
    800032a0:	00813983          	ld	s3,8(sp)
    800032a4:	03010113          	addi	sp,sp,48
    800032a8:	00008067          	ret
        p->state = RUNNABLE;
    800032ac:	00300793          	li	a5,3
    800032b0:	00f4ac23          	sw	a5,24(s1)
    800032b4:	fcdff06f          	j	80003280 <kill+0x74>

00000000800032b8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800032b8:	fd010113          	addi	sp,sp,-48
    800032bc:	02113423          	sd	ra,40(sp)
    800032c0:	02813023          	sd	s0,32(sp)
    800032c4:	00913c23          	sd	s1,24(sp)
    800032c8:	01213823          	sd	s2,16(sp)
    800032cc:	01313423          	sd	s3,8(sp)
    800032d0:	01413023          	sd	s4,0(sp)
    800032d4:	03010413          	addi	s0,sp,48
    800032d8:	00050493          	mv	s1,a0
    800032dc:	00058913          	mv	s2,a1
    800032e0:	00060993          	mv	s3,a2
    800032e4:	00068a13          	mv	s4,a3
  struct proc *p = myproc();
    800032e8:	fffff097          	auipc	ra,0xfffff
    800032ec:	168080e7          	jalr	360(ra) # 80002450 <myproc>
  if(user_dst){
    800032f0:	02048e63          	beqz	s1,8000332c <either_copyout+0x74>
    return copyout(p->pagetable, dst, src, len);
    800032f4:	000a0693          	mv	a3,s4
    800032f8:	00098613          	mv	a2,s3
    800032fc:	00090593          	mv	a1,s2
    80003300:	05053503          	ld	a0,80(a0)
    80003304:	fffff097          	auipc	ra,0xfffff
    80003308:	c54080e7          	jalr	-940(ra) # 80001f58 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000330c:	02813083          	ld	ra,40(sp)
    80003310:	02013403          	ld	s0,32(sp)
    80003314:	01813483          	ld	s1,24(sp)
    80003318:	01013903          	ld	s2,16(sp)
    8000331c:	00813983          	ld	s3,8(sp)
    80003320:	00013a03          	ld	s4,0(sp)
    80003324:	03010113          	addi	sp,sp,48
    80003328:	00008067          	ret
    memmove((char *)dst, src, len);
    8000332c:	000a061b          	sext.w	a2,s4
    80003330:	00098593          	mv	a1,s3
    80003334:	00090513          	mv	a0,s2
    80003338:	ffffe097          	auipc	ra,0xffffe
    8000333c:	e80080e7          	jalr	-384(ra) # 800011b8 <memmove>
    return 0;
    80003340:	00048513          	mv	a0,s1
    80003344:	fc9ff06f          	j	8000330c <either_copyout+0x54>

0000000080003348 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80003348:	fd010113          	addi	sp,sp,-48
    8000334c:	02113423          	sd	ra,40(sp)
    80003350:	02813023          	sd	s0,32(sp)
    80003354:	00913c23          	sd	s1,24(sp)
    80003358:	01213823          	sd	s2,16(sp)
    8000335c:	01313423          	sd	s3,8(sp)
    80003360:	01413023          	sd	s4,0(sp)
    80003364:	03010413          	addi	s0,sp,48
    80003368:	00050913          	mv	s2,a0
    8000336c:	00058493          	mv	s1,a1
    80003370:	00060993          	mv	s3,a2
    80003374:	00068a13          	mv	s4,a3
  struct proc *p = myproc();
    80003378:	fffff097          	auipc	ra,0xfffff
    8000337c:	0d8080e7          	jalr	216(ra) # 80002450 <myproc>
  if(user_src){
    80003380:	02048e63          	beqz	s1,800033bc <either_copyin+0x74>
    return copyin(p->pagetable, dst, src, len);
    80003384:	000a0693          	mv	a3,s4
    80003388:	00098613          	mv	a2,s3
    8000338c:	00090593          	mv	a1,s2
    80003390:	05053503          	ld	a0,80(a0)
    80003394:	fffff097          	auipc	ra,0xfffff
    80003398:	cac080e7          	jalr	-852(ra) # 80002040 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000339c:	02813083          	ld	ra,40(sp)
    800033a0:	02013403          	ld	s0,32(sp)
    800033a4:	01813483          	ld	s1,24(sp)
    800033a8:	01013903          	ld	s2,16(sp)
    800033ac:	00813983          	ld	s3,8(sp)
    800033b0:	00013a03          	ld	s4,0(sp)
    800033b4:	03010113          	addi	sp,sp,48
    800033b8:	00008067          	ret
    memmove(dst, (char*)src, len);
    800033bc:	000a061b          	sext.w	a2,s4
    800033c0:	00098593          	mv	a1,s3
    800033c4:	00090513          	mv	a0,s2
    800033c8:	ffffe097          	auipc	ra,0xffffe
    800033cc:	df0080e7          	jalr	-528(ra) # 800011b8 <memmove>
    return 0;
    800033d0:	00048513          	mv	a0,s1
    800033d4:	fc9ff06f          	j	8000339c <either_copyin+0x54>

00000000800033d8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800033d8:	fb010113          	addi	sp,sp,-80
    800033dc:	04113423          	sd	ra,72(sp)
    800033e0:	04813023          	sd	s0,64(sp)
    800033e4:	02913c23          	sd	s1,56(sp)
    800033e8:	03213823          	sd	s2,48(sp)
    800033ec:	03313423          	sd	s3,40(sp)
    800033f0:	03413023          	sd	s4,32(sp)
    800033f4:	01513c23          	sd	s5,24(sp)
    800033f8:	01613823          	sd	s6,16(sp)
    800033fc:	01713423          	sd	s7,8(sp)
    80003400:	05010413          	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80003404:	00007517          	auipc	a0,0x7
    80003408:	cc450513          	addi	a0,a0,-828 # 8000a0c8 <digits+0x88>
    8000340c:	ffffd097          	auipc	ra,0xffffd
    80003410:	31c080e7          	jalr	796(ra) # 80000728 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003414:	00010497          	auipc	s1,0x10
    80003418:	c3448493          	addi	s1,s1,-972 # 80013048 <proc+0x158>
    8000341c:	00015917          	auipc	s2,0x15
    80003420:	62c90913          	addi	s2,s2,1580 # 80018a48 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003424:	00500b13          	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80003428:	00007997          	auipc	s3,0x7
    8000342c:	e5898993          	addi	s3,s3,-424 # 8000a280 <digits+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80003430:	00007a97          	auipc	s5,0x7
    80003434:	e58a8a93          	addi	s5,s5,-424 # 8000a288 <digits+0x248>
    printf("\n");
    80003438:	00007a17          	auipc	s4,0x7
    8000343c:	c90a0a13          	addi	s4,s4,-880 # 8000a0c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003440:	00007b97          	auipc	s7,0x7
    80003444:	e80b8b93          	addi	s7,s7,-384 # 8000a2c0 <states.0>
    80003448:	0280006f          	j	80003470 <procdump+0x98>
    printf("%d %s %s", p->pid, state, p->name);
    8000344c:	ed86a583          	lw	a1,-296(a3)
    80003450:	000a8513          	mv	a0,s5
    80003454:	ffffd097          	auipc	ra,0xffffd
    80003458:	2d4080e7          	jalr	724(ra) # 80000728 <printf>
    printf("\n");
    8000345c:	000a0513          	mv	a0,s4
    80003460:	ffffd097          	auipc	ra,0xffffd
    80003464:	2c8080e7          	jalr	712(ra) # 80000728 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003468:	16848493          	addi	s1,s1,360
    8000346c:	03248a63          	beq	s1,s2,800034a0 <procdump+0xc8>
    if(p->state == UNUSED)
    80003470:	00048693          	mv	a3,s1
    80003474:	ec04a783          	lw	a5,-320(s1)
    80003478:	fe0788e3          	beqz	a5,80003468 <procdump+0x90>
      state = "???";
    8000347c:	00098613          	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003480:	fcfb66e3          	bltu	s6,a5,8000344c <procdump+0x74>
    80003484:	02079713          	slli	a4,a5,0x20
    80003488:	01d75793          	srli	a5,a4,0x1d
    8000348c:	00fb87b3          	add	a5,s7,a5
    80003490:	0007b603          	ld	a2,0(a5)
    80003494:	fa061ce3          	bnez	a2,8000344c <procdump+0x74>
      state = "???";
    80003498:	00098613          	mv	a2,s3
    8000349c:	fb1ff06f          	j	8000344c <procdump+0x74>
  }
}
    800034a0:	04813083          	ld	ra,72(sp)
    800034a4:	04013403          	ld	s0,64(sp)
    800034a8:	03813483          	ld	s1,56(sp)
    800034ac:	03013903          	ld	s2,48(sp)
    800034b0:	02813983          	ld	s3,40(sp)
    800034b4:	02013a03          	ld	s4,32(sp)
    800034b8:	01813a83          	ld	s5,24(sp)
    800034bc:	01013b03          	ld	s6,16(sp)
    800034c0:	00813b83          	ld	s7,8(sp)
    800034c4:	05010113          	addi	sp,sp,80
    800034c8:	00008067          	ret

00000000800034cc <swtch>:
    800034cc:	00153023          	sd	ra,0(a0)
    800034d0:	00253423          	sd	sp,8(a0)
    800034d4:	00853823          	sd	s0,16(a0)
    800034d8:	00953c23          	sd	s1,24(a0)
    800034dc:	03253023          	sd	s2,32(a0)
    800034e0:	03353423          	sd	s3,40(a0)
    800034e4:	03453823          	sd	s4,48(a0)
    800034e8:	03553c23          	sd	s5,56(a0)
    800034ec:	05653023          	sd	s6,64(a0)
    800034f0:	05753423          	sd	s7,72(a0)
    800034f4:	05853823          	sd	s8,80(a0)
    800034f8:	05953c23          	sd	s9,88(a0)
    800034fc:	07a53023          	sd	s10,96(a0)
    80003500:	07b53423          	sd	s11,104(a0)
    80003504:	0005b083          	ld	ra,0(a1)
    80003508:	0085b103          	ld	sp,8(a1)
    8000350c:	0105b403          	ld	s0,16(a1)
    80003510:	0185b483          	ld	s1,24(a1)
    80003514:	0205b903          	ld	s2,32(a1)
    80003518:	0285b983          	ld	s3,40(a1)
    8000351c:	0305ba03          	ld	s4,48(a1)
    80003520:	0385ba83          	ld	s5,56(a1)
    80003524:	0405bb03          	ld	s6,64(a1)
    80003528:	0485bb83          	ld	s7,72(a1)
    8000352c:	0505bc03          	ld	s8,80(a1)
    80003530:	0585bc83          	ld	s9,88(a1)
    80003534:	0605bd03          	ld	s10,96(a1)
    80003538:	0685bd83          	ld	s11,104(a1)
    8000353c:	00008067          	ret

0000000080003540 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003540:	ff010113          	addi	sp,sp,-16
    80003544:	00113423          	sd	ra,8(sp)
    80003548:	00813023          	sd	s0,0(sp)
    8000354c:	01010413          	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003550:	00007597          	auipc	a1,0x7
    80003554:	da058593          	addi	a1,a1,-608 # 8000a2f0 <states.0+0x30>
    80003558:	00015517          	auipc	a0,0x15
    8000355c:	39850513          	addi	a0,a0,920 # 800188f0 <tickslock>
    80003560:	ffffe097          	auipc	ra,0xffffe
    80003564:	988080e7          	jalr	-1656(ra) # 80000ee8 <initlock>
}
    80003568:	00813083          	ld	ra,8(sp)
    8000356c:	00013403          	ld	s0,0(sp)
    80003570:	01010113          	addi	sp,sp,16
    80003574:	00008067          	ret

0000000080003578 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003578:	ff010113          	addi	sp,sp,-16
    8000357c:	00813423          	sd	s0,8(sp)
    80003580:	01010413          	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003584:	00005797          	auipc	a5,0x5
    80003588:	8ac78793          	addi	a5,a5,-1876 # 80007e30 <kernelvec>
    8000358c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80003590:	00813403          	ld	s0,8(sp)
    80003594:	01010113          	addi	sp,sp,16
    80003598:	00008067          	ret

000000008000359c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000359c:	ff010113          	addi	sp,sp,-16
    800035a0:	00113423          	sd	ra,8(sp)
    800035a4:	00813023          	sd	s0,0(sp)
    800035a8:	01010413          	addi	s0,sp,16
  struct proc *p = myproc();
    800035ac:	fffff097          	auipc	ra,0xfffff
    800035b0:	ea4080e7          	jalr	-348(ra) # 80002450 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800035b4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800035b8:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800035bc:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800035c0:	00006617          	auipc	a2,0x6
    800035c4:	a4060613          	addi	a2,a2,-1472 # 80009000 <_trampoline>
    800035c8:	00006697          	auipc	a3,0x6
    800035cc:	a3868693          	addi	a3,a3,-1480 # 80009000 <_trampoline>
    800035d0:	40c686b3          	sub	a3,a3,a2
    800035d4:	040007b7          	lui	a5,0x4000
    800035d8:	fff78793          	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800035dc:	00c79793          	slli	a5,a5,0xc
    800035e0:	00f686b3          	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800035e4:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800035e8:	05853703          	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800035ec:	180026f3          	csrr	a3,satp
    800035f0:	00d73023          	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800035f4:	05853703          	ld	a4,88(a0)
    800035f8:	04053683          	ld	a3,64(a0)
    800035fc:	000015b7          	lui	a1,0x1
    80003600:	00b686b3          	add	a3,a3,a1
    80003604:	00d73423          	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003608:	05853703          	ld	a4,88(a0)
    8000360c:	00000697          	auipc	a3,0x0
    80003610:	1a868693          	addi	a3,a3,424 # 800037b4 <usertrap>
    80003614:	00d73823          	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003618:	05853703          	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000361c:	00020693          	mv	a3,tp
    80003620:	02d73023          	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003624:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003628:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000362c:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003630:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003634:	05853703          	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003638:	01873703          	ld	a4,24(a4)
    8000363c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80003640:	05053583          	ld	a1,80(a0)
    80003644:	00c5d593          	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80003648:	00006717          	auipc	a4,0x6
    8000364c:	a5870713          	addi	a4,a4,-1448 # 800090a0 <userret>
    80003650:	40c70733          	sub	a4,a4,a2
    80003654:	00f707b3          	add	a5,a4,a5
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80003658:	fff00713          	li	a4,-1
    8000365c:	03f71713          	slli	a4,a4,0x3f
    80003660:	00e5e5b3          	or	a1,a1,a4
    80003664:	02000537          	lui	a0,0x2000
    80003668:	fff50513          	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000366c:	00d51513          	slli	a0,a0,0xd
    80003670:	000780e7          	jalr	a5
}
    80003674:	00813083          	ld	ra,8(sp)
    80003678:	00013403          	ld	s0,0(sp)
    8000367c:	01010113          	addi	sp,sp,16
    80003680:	00008067          	ret

0000000080003684 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80003684:	fe010113          	addi	sp,sp,-32
    80003688:	00113c23          	sd	ra,24(sp)
    8000368c:	00813823          	sd	s0,16(sp)
    80003690:	00913423          	sd	s1,8(sp)
    80003694:	02010413          	addi	s0,sp,32
  acquire(&tickslock);
    80003698:	00015497          	auipc	s1,0x15
    8000369c:	25848493          	addi	s1,s1,600 # 800188f0 <tickslock>
    800036a0:	00048513          	mv	a0,s1
    800036a4:	ffffe097          	auipc	ra,0xffffe
    800036a8:	928080e7          	jalr	-1752(ra) # 80000fcc <acquire>
  ticks++;
    800036ac:	00007517          	auipc	a0,0x7
    800036b0:	1a450513          	addi	a0,a0,420 # 8000a850 <ticks>
    800036b4:	00052783          	lw	a5,0(a0)
    800036b8:	0017879b          	addiw	a5,a5,1
    800036bc:	00f52023          	sw	a5,0(a0)
  wakeup(&ticks);
    800036c0:	00000097          	auipc	ra,0x0
    800036c4:	920080e7          	jalr	-1760(ra) # 80002fe0 <wakeup>
  release(&tickslock);
    800036c8:	00048513          	mv	a0,s1
    800036cc:	ffffe097          	auipc	ra,0xffffe
    800036d0:	9f8080e7          	jalr	-1544(ra) # 800010c4 <release>
}
    800036d4:	01813083          	ld	ra,24(sp)
    800036d8:	01013403          	ld	s0,16(sp)
    800036dc:	00813483          	ld	s1,8(sp)
    800036e0:	02010113          	addi	sp,sp,32
    800036e4:	00008067          	ret

00000000800036e8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800036e8:	fe010113          	addi	sp,sp,-32
    800036ec:	00113c23          	sd	ra,24(sp)
    800036f0:	00813823          	sd	s0,16(sp)
    800036f4:	00913423          	sd	s1,8(sp)
    800036f8:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800036fc:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80003700:	02074663          	bltz	a4,8000372c <devintr+0x44>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80003704:	fff00793          	li	a5,-1
    80003708:	03f79793          	slli	a5,a5,0x3f
    8000370c:	00178793          	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80003710:	00000513          	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80003714:	06f70a63          	beq	a4,a5,80003788 <devintr+0xa0>
  }
}
    80003718:	01813083          	ld	ra,24(sp)
    8000371c:	01013403          	ld	s0,16(sp)
    80003720:	00813483          	ld	s1,8(sp)
    80003724:	02010113          	addi	sp,sp,32
    80003728:	00008067          	ret
     (scause & 0xff) == 9){
    8000372c:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80003730:	00900693          	li	a3,9
    80003734:	fcd798e3          	bne	a5,a3,80003704 <devintr+0x1c>
    int irq = plic_claim();
    80003738:	00005097          	auipc	ra,0x5
    8000373c:	8b8080e7          	jalr	-1864(ra) # 80007ff0 <plic_claim>
    80003740:	00050493          	mv	s1,a0
    if(irq == UART0_IRQ){
    80003744:	00a00793          	li	a5,10
    80003748:	02f50a63          	beq	a0,a5,8000377c <devintr+0x94>
    return 1;
    8000374c:	00100513          	li	a0,1
    } else if(irq){
    80003750:	fc0484e3          	beqz	s1,80003718 <devintr+0x30>
      printf("unexpected interrupt irq=%d\n", irq);
    80003754:	00048593          	mv	a1,s1
    80003758:	00007517          	auipc	a0,0x7
    8000375c:	ba050513          	addi	a0,a0,-1120 # 8000a2f8 <states.0+0x38>
    80003760:	ffffd097          	auipc	ra,0xffffd
    80003764:	fc8080e7          	jalr	-56(ra) # 80000728 <printf>
      plic_complete(irq);
    80003768:	00048513          	mv	a0,s1
    8000376c:	00005097          	auipc	ra,0x5
    80003770:	8bc080e7          	jalr	-1860(ra) # 80008028 <plic_complete>
    return 1;
    80003774:	00100513          	li	a0,1
    80003778:	fa1ff06f          	j	80003718 <devintr+0x30>
      uartintr();
    8000377c:	ffffd097          	auipc	ra,0xffffd
    80003780:	50c080e7          	jalr	1292(ra) # 80000c88 <uartintr>
    80003784:	fe5ff06f          	j	80003768 <devintr+0x80>
    if(cpuid() == 0){
    80003788:	fffff097          	auipc	ra,0xfffff
    8000378c:	c78080e7          	jalr	-904(ra) # 80002400 <cpuid>
    80003790:	00050c63          	beqz	a0,800037a8 <devintr+0xc0>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003794:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80003798:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000379c:	14479073          	csrw	sip,a5
    return 2;
    800037a0:	00200513          	li	a0,2
    800037a4:	f75ff06f          	j	80003718 <devintr+0x30>
      clockintr();
    800037a8:	00000097          	auipc	ra,0x0
    800037ac:	edc080e7          	jalr	-292(ra) # 80003684 <clockintr>
    800037b0:	fe5ff06f          	j	80003794 <devintr+0xac>

00000000800037b4 <usertrap>:
{
    800037b4:	fe010113          	addi	sp,sp,-32
    800037b8:	00113c23          	sd	ra,24(sp)
    800037bc:	00813823          	sd	s0,16(sp)
    800037c0:	00913423          	sd	s1,8(sp)
    800037c4:	01213023          	sd	s2,0(sp)
    800037c8:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800037cc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800037d0:	1007f793          	andi	a5,a5,256
    800037d4:	08079463          	bnez	a5,8000385c <usertrap+0xa8>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800037d8:	00004797          	auipc	a5,0x4
    800037dc:	65878793          	addi	a5,a5,1624 # 80007e30 <kernelvec>
    800037e0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800037e4:	fffff097          	auipc	ra,0xfffff
    800037e8:	c6c080e7          	jalr	-916(ra) # 80002450 <myproc>
    800037ec:	00050493          	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800037f0:	05853783          	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800037f4:	14102773          	csrr	a4,sepc
    800037f8:	00e7bc23          	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800037fc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80003800:	00800793          	li	a5,8
    80003804:	06f71c63          	bne	a4,a5,8000387c <usertrap+0xc8>
    if(p->killed)
    80003808:	02852783          	lw	a5,40(a0)
    8000380c:	06079063          	bnez	a5,8000386c <usertrap+0xb8>
    p->trapframe->epc += 4;
    80003810:	0584b703          	ld	a4,88(s1)
    80003814:	01873783          	ld	a5,24(a4)
    80003818:	00478793          	addi	a5,a5,4
    8000381c:	00f73c23          	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003820:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003824:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003828:	10079073          	csrw	sstatus,a5
    syscall();
    8000382c:	00000097          	auipc	ra,0x0
    80003830:	430080e7          	jalr	1072(ra) # 80003c5c <syscall>
  if(p->killed)
    80003834:	0284a783          	lw	a5,40(s1)
    80003838:	0a079c63          	bnez	a5,800038f0 <usertrap+0x13c>
  usertrapret();
    8000383c:	00000097          	auipc	ra,0x0
    80003840:	d60080e7          	jalr	-672(ra) # 8000359c <usertrapret>
}
    80003844:	01813083          	ld	ra,24(sp)
    80003848:	01013403          	ld	s0,16(sp)
    8000384c:	00813483          	ld	s1,8(sp)
    80003850:	00013903          	ld	s2,0(sp)
    80003854:	02010113          	addi	sp,sp,32
    80003858:	00008067          	ret
    panic("usertrap: not from user mode");
    8000385c:	00007517          	auipc	a0,0x7
    80003860:	abc50513          	addi	a0,a0,-1348 # 8000a318 <states.0+0x58>
    80003864:	ffffd097          	auipc	ra,0xffffd
    80003868:	e68080e7          	jalr	-408(ra) # 800006cc <panic>
      exit(-1);
    8000386c:	fff00513          	li	a0,-1
    80003870:	00000097          	auipc	ra,0x0
    80003874:	8a0080e7          	jalr	-1888(ra) # 80003110 <exit>
    80003878:	f99ff06f          	j	80003810 <usertrap+0x5c>
  } else if((which_dev = devintr()) != 0){
    8000387c:	00000097          	auipc	ra,0x0
    80003880:	e6c080e7          	jalr	-404(ra) # 800036e8 <devintr>
    80003884:	00050913          	mv	s2,a0
    80003888:	00050863          	beqz	a0,80003898 <usertrap+0xe4>
  if(p->killed)
    8000388c:	0284a783          	lw	a5,40(s1)
    80003890:	04078663          	beqz	a5,800038dc <usertrap+0x128>
    80003894:	03c0006f          	j	800038d0 <usertrap+0x11c>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003898:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000389c:	0304a603          	lw	a2,48(s1)
    800038a0:	00007517          	auipc	a0,0x7
    800038a4:	a9850513          	addi	a0,a0,-1384 # 8000a338 <states.0+0x78>
    800038a8:	ffffd097          	auipc	ra,0xffffd
    800038ac:	e80080e7          	jalr	-384(ra) # 80000728 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800038b0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800038b4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800038b8:	00007517          	auipc	a0,0x7
    800038bc:	ab050513          	addi	a0,a0,-1360 # 8000a368 <states.0+0xa8>
    800038c0:	ffffd097          	auipc	ra,0xffffd
    800038c4:	e68080e7          	jalr	-408(ra) # 80000728 <printf>
    p->killed = 1;
    800038c8:	00100793          	li	a5,1
    800038cc:	02f4a423          	sw	a5,40(s1)
    exit(-1);
    800038d0:	fff00513          	li	a0,-1
    800038d4:	00000097          	auipc	ra,0x0
    800038d8:	83c080e7          	jalr	-1988(ra) # 80003110 <exit>
  if(which_dev == 2)
    800038dc:	00200793          	li	a5,2
    800038e0:	f4f91ee3          	bne	s2,a5,8000383c <usertrap+0x88>
    yield();
    800038e4:	fffff097          	auipc	ra,0xfffff
    800038e8:	484080e7          	jalr	1156(ra) # 80002d68 <yield>
    800038ec:	f51ff06f          	j	8000383c <usertrap+0x88>
  int which_dev = 0;
    800038f0:	00000913          	li	s2,0
    800038f4:	fddff06f          	j	800038d0 <usertrap+0x11c>

00000000800038f8 <kerneltrap>:
{
    800038f8:	fd010113          	addi	sp,sp,-48
    800038fc:	02113423          	sd	ra,40(sp)
    80003900:	02813023          	sd	s0,32(sp)
    80003904:	00913c23          	sd	s1,24(sp)
    80003908:	01213823          	sd	s2,16(sp)
    8000390c:	01313423          	sd	s3,8(sp)
    80003910:	03010413          	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003914:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003918:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000391c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80003920:	1004f793          	andi	a5,s1,256
    80003924:	04078463          	beqz	a5,8000396c <kerneltrap+0x74>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003928:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000392c:	0027f793          	andi	a5,a5,2
  if(intr_get() != 0)
    80003930:	04079663          	bnez	a5,8000397c <kerneltrap+0x84>
  if((which_dev = devintr()) == 0){
    80003934:	00000097          	auipc	ra,0x0
    80003938:	db4080e7          	jalr	-588(ra) # 800036e8 <devintr>
    8000393c:	04050863          	beqz	a0,8000398c <kerneltrap+0x94>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003940:	00200793          	li	a5,2
    80003944:	08f50263          	beq	a0,a5,800039c8 <kerneltrap+0xd0>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003948:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000394c:	10049073          	csrw	sstatus,s1
}
    80003950:	02813083          	ld	ra,40(sp)
    80003954:	02013403          	ld	s0,32(sp)
    80003958:	01813483          	ld	s1,24(sp)
    8000395c:	01013903          	ld	s2,16(sp)
    80003960:	00813983          	ld	s3,8(sp)
    80003964:	03010113          	addi	sp,sp,48
    80003968:	00008067          	ret
    panic("kerneltrap: not from supervisor mode");
    8000396c:	00007517          	auipc	a0,0x7
    80003970:	a1c50513          	addi	a0,a0,-1508 # 8000a388 <states.0+0xc8>
    80003974:	ffffd097          	auipc	ra,0xffffd
    80003978:	d58080e7          	jalr	-680(ra) # 800006cc <panic>
    panic("kerneltrap: interrupts enabled");
    8000397c:	00007517          	auipc	a0,0x7
    80003980:	a3450513          	addi	a0,a0,-1484 # 8000a3b0 <states.0+0xf0>
    80003984:	ffffd097          	auipc	ra,0xffffd
    80003988:	d48080e7          	jalr	-696(ra) # 800006cc <panic>
    printf("scause %p\n", scause);
    8000398c:	00098593          	mv	a1,s3
    80003990:	00007517          	auipc	a0,0x7
    80003994:	a4050513          	addi	a0,a0,-1472 # 8000a3d0 <states.0+0x110>
    80003998:	ffffd097          	auipc	ra,0xffffd
    8000399c:	d90080e7          	jalr	-624(ra) # 80000728 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800039a0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800039a4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800039a8:	00007517          	auipc	a0,0x7
    800039ac:	a3850513          	addi	a0,a0,-1480 # 8000a3e0 <states.0+0x120>
    800039b0:	ffffd097          	auipc	ra,0xffffd
    800039b4:	d78080e7          	jalr	-648(ra) # 80000728 <printf>
    panic("kerneltrap");
    800039b8:	00007517          	auipc	a0,0x7
    800039bc:	a4050513          	addi	a0,a0,-1472 # 8000a3f8 <states.0+0x138>
    800039c0:	ffffd097          	auipc	ra,0xffffd
    800039c4:	d0c080e7          	jalr	-756(ra) # 800006cc <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800039c8:	fffff097          	auipc	ra,0xfffff
    800039cc:	a88080e7          	jalr	-1400(ra) # 80002450 <myproc>
    800039d0:	f6050ce3          	beqz	a0,80003948 <kerneltrap+0x50>
    800039d4:	fffff097          	auipc	ra,0xfffff
    800039d8:	a7c080e7          	jalr	-1412(ra) # 80002450 <myproc>
    800039dc:	01852703          	lw	a4,24(a0)
    800039e0:	00400793          	li	a5,4
    800039e4:	f6f712e3          	bne	a4,a5,80003948 <kerneltrap+0x50>
    yield();
    800039e8:	fffff097          	auipc	ra,0xfffff
    800039ec:	380080e7          	jalr	896(ra) # 80002d68 <yield>
    800039f0:	f59ff06f          	j	80003948 <kerneltrap+0x50>

00000000800039f4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800039f4:	fe010113          	addi	sp,sp,-32
    800039f8:	00113c23          	sd	ra,24(sp)
    800039fc:	00813823          	sd	s0,16(sp)
    80003a00:	00913423          	sd	s1,8(sp)
    80003a04:	02010413          	addi	s0,sp,32
    80003a08:	00050493          	mv	s1,a0
  struct proc *p = myproc();
    80003a0c:	fffff097          	auipc	ra,0xfffff
    80003a10:	a44080e7          	jalr	-1468(ra) # 80002450 <myproc>
  switch (n) {
    80003a14:	00500793          	li	a5,5
    80003a18:	0697ec63          	bltu	a5,s1,80003a90 <argraw+0x9c>
    80003a1c:	00249493          	slli	s1,s1,0x2
    80003a20:	00007717          	auipc	a4,0x7
    80003a24:	a1070713          	addi	a4,a4,-1520 # 8000a430 <states.0+0x170>
    80003a28:	00e484b3          	add	s1,s1,a4
    80003a2c:	0004a783          	lw	a5,0(s1)
    80003a30:	00e787b3          	add	a5,a5,a4
    80003a34:	00078067          	jr	a5
  case 0:
    return p->trapframe->a0;
    80003a38:	05853783          	ld	a5,88(a0)
    80003a3c:	0707b503          	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003a40:	01813083          	ld	ra,24(sp)
    80003a44:	01013403          	ld	s0,16(sp)
    80003a48:	00813483          	ld	s1,8(sp)
    80003a4c:	02010113          	addi	sp,sp,32
    80003a50:	00008067          	ret
    return p->trapframe->a1;
    80003a54:	05853783          	ld	a5,88(a0)
    80003a58:	0787b503          	ld	a0,120(a5)
    80003a5c:	fe5ff06f          	j	80003a40 <argraw+0x4c>
    return p->trapframe->a2;
    80003a60:	05853783          	ld	a5,88(a0)
    80003a64:	0807b503          	ld	a0,128(a5)
    80003a68:	fd9ff06f          	j	80003a40 <argraw+0x4c>
    return p->trapframe->a3;
    80003a6c:	05853783          	ld	a5,88(a0)
    80003a70:	0887b503          	ld	a0,136(a5)
    80003a74:	fcdff06f          	j	80003a40 <argraw+0x4c>
    return p->trapframe->a4;
    80003a78:	05853783          	ld	a5,88(a0)
    80003a7c:	0907b503          	ld	a0,144(a5)
    80003a80:	fc1ff06f          	j	80003a40 <argraw+0x4c>
    return p->trapframe->a5;
    80003a84:	05853783          	ld	a5,88(a0)
    80003a88:	0987b503          	ld	a0,152(a5)
    80003a8c:	fb5ff06f          	j	80003a40 <argraw+0x4c>
  panic("argraw");
    80003a90:	00007517          	auipc	a0,0x7
    80003a94:	97850513          	addi	a0,a0,-1672 # 8000a408 <states.0+0x148>
    80003a98:	ffffd097          	auipc	ra,0xffffd
    80003a9c:	c34080e7          	jalr	-972(ra) # 800006cc <panic>

0000000080003aa0 <fetchaddr>:
{
    80003aa0:	fe010113          	addi	sp,sp,-32
    80003aa4:	00113c23          	sd	ra,24(sp)
    80003aa8:	00813823          	sd	s0,16(sp)
    80003aac:	00913423          	sd	s1,8(sp)
    80003ab0:	01213023          	sd	s2,0(sp)
    80003ab4:	02010413          	addi	s0,sp,32
    80003ab8:	00050493          	mv	s1,a0
    80003abc:	00058913          	mv	s2,a1
  struct proc *p = myproc();
    80003ac0:	fffff097          	auipc	ra,0xfffff
    80003ac4:	990080e7          	jalr	-1648(ra) # 80002450 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80003ac8:	04853783          	ld	a5,72(a0)
    80003acc:	04f4f263          	bgeu	s1,a5,80003b10 <fetchaddr+0x70>
    80003ad0:	00848713          	addi	a4,s1,8
    80003ad4:	04e7e263          	bltu	a5,a4,80003b18 <fetchaddr+0x78>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003ad8:	00800693          	li	a3,8
    80003adc:	00048613          	mv	a2,s1
    80003ae0:	00090593          	mv	a1,s2
    80003ae4:	05053503          	ld	a0,80(a0)
    80003ae8:	ffffe097          	auipc	ra,0xffffe
    80003aec:	558080e7          	jalr	1368(ra) # 80002040 <copyin>
    80003af0:	00a03533          	snez	a0,a0
    80003af4:	40a00533          	neg	a0,a0
}
    80003af8:	01813083          	ld	ra,24(sp)
    80003afc:	01013403          	ld	s0,16(sp)
    80003b00:	00813483          	ld	s1,8(sp)
    80003b04:	00013903          	ld	s2,0(sp)
    80003b08:	02010113          	addi	sp,sp,32
    80003b0c:	00008067          	ret
    return -1;
    80003b10:	fff00513          	li	a0,-1
    80003b14:	fe5ff06f          	j	80003af8 <fetchaddr+0x58>
    80003b18:	fff00513          	li	a0,-1
    80003b1c:	fddff06f          	j	80003af8 <fetchaddr+0x58>

0000000080003b20 <fetchstr>:
{
    80003b20:	fd010113          	addi	sp,sp,-48
    80003b24:	02113423          	sd	ra,40(sp)
    80003b28:	02813023          	sd	s0,32(sp)
    80003b2c:	00913c23          	sd	s1,24(sp)
    80003b30:	01213823          	sd	s2,16(sp)
    80003b34:	01313423          	sd	s3,8(sp)
    80003b38:	03010413          	addi	s0,sp,48
    80003b3c:	00050913          	mv	s2,a0
    80003b40:	00058493          	mv	s1,a1
    80003b44:	00060993          	mv	s3,a2
  struct proc *p = myproc();
    80003b48:	fffff097          	auipc	ra,0xfffff
    80003b4c:	908080e7          	jalr	-1784(ra) # 80002450 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80003b50:	00098693          	mv	a3,s3
    80003b54:	00090613          	mv	a2,s2
    80003b58:	00048593          	mv	a1,s1
    80003b5c:	05053503          	ld	a0,80(a0)
    80003b60:	ffffe097          	auipc	ra,0xffffe
    80003b64:	5c8080e7          	jalr	1480(ra) # 80002128 <copyinstr>
  if(err < 0)
    80003b68:	00054863          	bltz	a0,80003b78 <fetchstr+0x58>
  return strlen(buf);
    80003b6c:	00048513          	mv	a0,s1
    80003b70:	ffffe097          	auipc	ra,0xffffe
    80003b74:	800080e7          	jalr	-2048(ra) # 80001370 <strlen>
}
    80003b78:	02813083          	ld	ra,40(sp)
    80003b7c:	02013403          	ld	s0,32(sp)
    80003b80:	01813483          	ld	s1,24(sp)
    80003b84:	01013903          	ld	s2,16(sp)
    80003b88:	00813983          	ld	s3,8(sp)
    80003b8c:	03010113          	addi	sp,sp,48
    80003b90:	00008067          	ret

0000000080003b94 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80003b94:	fe010113          	addi	sp,sp,-32
    80003b98:	00113c23          	sd	ra,24(sp)
    80003b9c:	00813823          	sd	s0,16(sp)
    80003ba0:	00913423          	sd	s1,8(sp)
    80003ba4:	02010413          	addi	s0,sp,32
    80003ba8:	00058493          	mv	s1,a1
  *ip = argraw(n);
    80003bac:	00000097          	auipc	ra,0x0
    80003bb0:	e48080e7          	jalr	-440(ra) # 800039f4 <argraw>
    80003bb4:	00a4a023          	sw	a0,0(s1)
  return 0;
}
    80003bb8:	00000513          	li	a0,0
    80003bbc:	01813083          	ld	ra,24(sp)
    80003bc0:	01013403          	ld	s0,16(sp)
    80003bc4:	00813483          	ld	s1,8(sp)
    80003bc8:	02010113          	addi	sp,sp,32
    80003bcc:	00008067          	ret

0000000080003bd0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80003bd0:	fe010113          	addi	sp,sp,-32
    80003bd4:	00113c23          	sd	ra,24(sp)
    80003bd8:	00813823          	sd	s0,16(sp)
    80003bdc:	00913423          	sd	s1,8(sp)
    80003be0:	02010413          	addi	s0,sp,32
    80003be4:	00058493          	mv	s1,a1
  *ip = argraw(n);
    80003be8:	00000097          	auipc	ra,0x0
    80003bec:	e0c080e7          	jalr	-500(ra) # 800039f4 <argraw>
    80003bf0:	00a4b023          	sd	a0,0(s1)
  return 0;
}
    80003bf4:	00000513          	li	a0,0
    80003bf8:	01813083          	ld	ra,24(sp)
    80003bfc:	01013403          	ld	s0,16(sp)
    80003c00:	00813483          	ld	s1,8(sp)
    80003c04:	02010113          	addi	sp,sp,32
    80003c08:	00008067          	ret

0000000080003c0c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003c0c:	fe010113          	addi	sp,sp,-32
    80003c10:	00113c23          	sd	ra,24(sp)
    80003c14:	00813823          	sd	s0,16(sp)
    80003c18:	00913423          	sd	s1,8(sp)
    80003c1c:	01213023          	sd	s2,0(sp)
    80003c20:	02010413          	addi	s0,sp,32
    80003c24:	00058493          	mv	s1,a1
    80003c28:	00060913          	mv	s2,a2
  *ip = argraw(n);
    80003c2c:	00000097          	auipc	ra,0x0
    80003c30:	dc8080e7          	jalr	-568(ra) # 800039f4 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80003c34:	00090613          	mv	a2,s2
    80003c38:	00048593          	mv	a1,s1
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	ee4080e7          	jalr	-284(ra) # 80003b20 <fetchstr>
}
    80003c44:	01813083          	ld	ra,24(sp)
    80003c48:	01013403          	ld	s0,16(sp)
    80003c4c:	00813483          	ld	s1,8(sp)
    80003c50:	00013903          	ld	s2,0(sp)
    80003c54:	02010113          	addi	sp,sp,32
    80003c58:	00008067          	ret

0000000080003c5c <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80003c5c:	fe010113          	addi	sp,sp,-32
    80003c60:	00113c23          	sd	ra,24(sp)
    80003c64:	00813823          	sd	s0,16(sp)
    80003c68:	00913423          	sd	s1,8(sp)
    80003c6c:	01213023          	sd	s2,0(sp)
    80003c70:	02010413          	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003c74:	ffffe097          	auipc	ra,0xffffe
    80003c78:	7dc080e7          	jalr	2012(ra) # 80002450 <myproc>
    80003c7c:	00050493          	mv	s1,a0

  num = p->trapframe->a7;
    80003c80:	05853903          	ld	s2,88(a0)
    80003c84:	0a893783          	ld	a5,168(s2)
    80003c88:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003c8c:	fff7879b          	addiw	a5,a5,-1
    80003c90:	01400713          	li	a4,20
    80003c94:	02f76463          	bltu	a4,a5,80003cbc <syscall+0x60>
    80003c98:	00369713          	slli	a4,a3,0x3
    80003c9c:	00006797          	auipc	a5,0x6
    80003ca0:	7ac78793          	addi	a5,a5,1964 # 8000a448 <syscalls>
    80003ca4:	00e787b3          	add	a5,a5,a4
    80003ca8:	0007b783          	ld	a5,0(a5)
    80003cac:	00078863          	beqz	a5,80003cbc <syscall+0x60>
    p->trapframe->a0 = syscalls[num]();
    80003cb0:	000780e7          	jalr	a5
    80003cb4:	06a93823          	sd	a0,112(s2)
    80003cb8:	0280006f          	j	80003ce0 <syscall+0x84>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003cbc:	15848613          	addi	a2,s1,344
    80003cc0:	0304a583          	lw	a1,48(s1)
    80003cc4:	00006517          	auipc	a0,0x6
    80003cc8:	74c50513          	addi	a0,a0,1868 # 8000a410 <states.0+0x150>
    80003ccc:	ffffd097          	auipc	ra,0xffffd
    80003cd0:	a5c080e7          	jalr	-1444(ra) # 80000728 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003cd4:	0584b783          	ld	a5,88(s1)
    80003cd8:	fff00713          	li	a4,-1
    80003cdc:	06e7b823          	sd	a4,112(a5)
  }
}
    80003ce0:	01813083          	ld	ra,24(sp)
    80003ce4:	01013403          	ld	s0,16(sp)
    80003ce8:	00813483          	ld	s1,8(sp)
    80003cec:	00013903          	ld	s2,0(sp)
    80003cf0:	02010113          	addi	sp,sp,32
    80003cf4:	00008067          	ret

0000000080003cf8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003cf8:	fe010113          	addi	sp,sp,-32
    80003cfc:	00113c23          	sd	ra,24(sp)
    80003d00:	00813823          	sd	s0,16(sp)
    80003d04:	02010413          	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80003d08:	fec40593          	addi	a1,s0,-20
    80003d0c:	00000513          	li	a0,0
    80003d10:	00000097          	auipc	ra,0x0
    80003d14:	e84080e7          	jalr	-380(ra) # 80003b94 <argint>
    return -1;
    80003d18:	fff00793          	li	a5,-1
  if(argint(0, &n) < 0)
    80003d1c:	00054a63          	bltz	a0,80003d30 <sys_exit+0x38>
  exit(n);
    80003d20:	fec42503          	lw	a0,-20(s0)
    80003d24:	fffff097          	auipc	ra,0xfffff
    80003d28:	3ec080e7          	jalr	1004(ra) # 80003110 <exit>
  return 0;  // not reached
    80003d2c:	00000793          	li	a5,0
}
    80003d30:	00078513          	mv	a0,a5
    80003d34:	01813083          	ld	ra,24(sp)
    80003d38:	01013403          	ld	s0,16(sp)
    80003d3c:	02010113          	addi	sp,sp,32
    80003d40:	00008067          	ret

0000000080003d44 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003d44:	ff010113          	addi	sp,sp,-16
    80003d48:	00113423          	sd	ra,8(sp)
    80003d4c:	00813023          	sd	s0,0(sp)
    80003d50:	01010413          	addi	s0,sp,16
  return myproc()->pid;
    80003d54:	ffffe097          	auipc	ra,0xffffe
    80003d58:	6fc080e7          	jalr	1788(ra) # 80002450 <myproc>
}
    80003d5c:	03052503          	lw	a0,48(a0)
    80003d60:	00813083          	ld	ra,8(sp)
    80003d64:	00013403          	ld	s0,0(sp)
    80003d68:	01010113          	addi	sp,sp,16
    80003d6c:	00008067          	ret

0000000080003d70 <sys_fork>:

uint64
sys_fork(void)
{
    80003d70:	ff010113          	addi	sp,sp,-16
    80003d74:	00113423          	sd	ra,8(sp)
    80003d78:	00813023          	sd	s0,0(sp)
    80003d7c:	01010413          	addi	s0,sp,16
  return fork();
    80003d80:	fffff097          	auipc	ra,0xfffff
    80003d84:	c58080e7          	jalr	-936(ra) # 800029d8 <fork>
}
    80003d88:	00813083          	ld	ra,8(sp)
    80003d8c:	00013403          	ld	s0,0(sp)
    80003d90:	01010113          	addi	sp,sp,16
    80003d94:	00008067          	ret

0000000080003d98 <sys_wait>:

uint64
sys_wait(void)
{
    80003d98:	fe010113          	addi	sp,sp,-32
    80003d9c:	00113c23          	sd	ra,24(sp)
    80003da0:	00813823          	sd	s0,16(sp)
    80003da4:	02010413          	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80003da8:	fe840593          	addi	a1,s0,-24
    80003dac:	00000513          	li	a0,0
    80003db0:	00000097          	auipc	ra,0x0
    80003db4:	e20080e7          	jalr	-480(ra) # 80003bd0 <argaddr>
    80003db8:	00050793          	mv	a5,a0
    return -1;
    80003dbc:	fff00513          	li	a0,-1
  if(argaddr(0, &p) < 0)
    80003dc0:	0007c863          	bltz	a5,80003dd0 <sys_wait+0x38>
  return wait(p);
    80003dc4:	fe843503          	ld	a0,-24(s0)
    80003dc8:	fffff097          	auipc	ra,0xfffff
    80003dcc:	088080e7          	jalr	136(ra) # 80002e50 <wait>
}
    80003dd0:	01813083          	ld	ra,24(sp)
    80003dd4:	01013403          	ld	s0,16(sp)
    80003dd8:	02010113          	addi	sp,sp,32
    80003ddc:	00008067          	ret

0000000080003de0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003de0:	fd010113          	addi	sp,sp,-48
    80003de4:	02113423          	sd	ra,40(sp)
    80003de8:	02813023          	sd	s0,32(sp)
    80003dec:	00913c23          	sd	s1,24(sp)
    80003df0:	03010413          	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80003df4:	fdc40593          	addi	a1,s0,-36
    80003df8:	00000513          	li	a0,0
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	d98080e7          	jalr	-616(ra) # 80003b94 <argint>
    return -1;
    80003e04:	fff00493          	li	s1,-1
  if(argint(0, &n) < 0)
    80003e08:	02054063          	bltz	a0,80003e28 <sys_sbrk+0x48>
  addr = myproc()->sz;
    80003e0c:	ffffe097          	auipc	ra,0xffffe
    80003e10:	644080e7          	jalr	1604(ra) # 80002450 <myproc>
    80003e14:	04852483          	lw	s1,72(a0)
  if(growproc(n) < 0)
    80003e18:	fdc42503          	lw	a0,-36(s0)
    80003e1c:	fffff097          	auipc	ra,0xfffff
    80003e20:	b04080e7          	jalr	-1276(ra) # 80002920 <growproc>
    80003e24:	00054e63          	bltz	a0,80003e40 <sys_sbrk+0x60>
    return -1;
  return addr;
}
    80003e28:	00048513          	mv	a0,s1
    80003e2c:	02813083          	ld	ra,40(sp)
    80003e30:	02013403          	ld	s0,32(sp)
    80003e34:	01813483          	ld	s1,24(sp)
    80003e38:	03010113          	addi	sp,sp,48
    80003e3c:	00008067          	ret
    return -1;
    80003e40:	fff00493          	li	s1,-1
    80003e44:	fe5ff06f          	j	80003e28 <sys_sbrk+0x48>

0000000080003e48 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003e48:	fc010113          	addi	sp,sp,-64
    80003e4c:	02113c23          	sd	ra,56(sp)
    80003e50:	02813823          	sd	s0,48(sp)
    80003e54:	02913423          	sd	s1,40(sp)
    80003e58:	03213023          	sd	s2,32(sp)
    80003e5c:	01313c23          	sd	s3,24(sp)
    80003e60:	04010413          	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80003e64:	fcc40593          	addi	a1,s0,-52
    80003e68:	00000513          	li	a0,0
    80003e6c:	00000097          	auipc	ra,0x0
    80003e70:	d28080e7          	jalr	-728(ra) # 80003b94 <argint>
    return -1;
    80003e74:	fff00793          	li	a5,-1
  if(argint(0, &n) < 0)
    80003e78:	06054c63          	bltz	a0,80003ef0 <sys_sleep+0xa8>
  acquire(&tickslock);
    80003e7c:	00015517          	auipc	a0,0x15
    80003e80:	a7450513          	addi	a0,a0,-1420 # 800188f0 <tickslock>
    80003e84:	ffffd097          	auipc	ra,0xffffd
    80003e88:	148080e7          	jalr	328(ra) # 80000fcc <acquire>
  ticks0 = ticks;
    80003e8c:	00007917          	auipc	s2,0x7
    80003e90:	9c492903          	lw	s2,-1596(s2) # 8000a850 <ticks>
  while(ticks - ticks0 < n){
    80003e94:	fcc42783          	lw	a5,-52(s0)
    80003e98:	04078263          	beqz	a5,80003edc <sys_sleep+0x94>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003e9c:	00015997          	auipc	s3,0x15
    80003ea0:	a5498993          	addi	s3,s3,-1452 # 800188f0 <tickslock>
    80003ea4:	00007497          	auipc	s1,0x7
    80003ea8:	9ac48493          	addi	s1,s1,-1620 # 8000a850 <ticks>
    if(myproc()->killed){
    80003eac:	ffffe097          	auipc	ra,0xffffe
    80003eb0:	5a4080e7          	jalr	1444(ra) # 80002450 <myproc>
    80003eb4:	02852783          	lw	a5,40(a0)
    80003eb8:	04079c63          	bnez	a5,80003f10 <sys_sleep+0xc8>
    sleep(&ticks, &tickslock);
    80003ebc:	00098593          	mv	a1,s3
    80003ec0:	00048513          	mv	a0,s1
    80003ec4:	fffff097          	auipc	ra,0xfffff
    80003ec8:	efc080e7          	jalr	-260(ra) # 80002dc0 <sleep>
  while(ticks - ticks0 < n){
    80003ecc:	0004a783          	lw	a5,0(s1)
    80003ed0:	412787bb          	subw	a5,a5,s2
    80003ed4:	fcc42703          	lw	a4,-52(s0)
    80003ed8:	fce7eae3          	bltu	a5,a4,80003eac <sys_sleep+0x64>
  }
  release(&tickslock);
    80003edc:	00015517          	auipc	a0,0x15
    80003ee0:	a1450513          	addi	a0,a0,-1516 # 800188f0 <tickslock>
    80003ee4:	ffffd097          	auipc	ra,0xffffd
    80003ee8:	1e0080e7          	jalr	480(ra) # 800010c4 <release>
  return 0;
    80003eec:	00000793          	li	a5,0
}
    80003ef0:	00078513          	mv	a0,a5
    80003ef4:	03813083          	ld	ra,56(sp)
    80003ef8:	03013403          	ld	s0,48(sp)
    80003efc:	02813483          	ld	s1,40(sp)
    80003f00:	02013903          	ld	s2,32(sp)
    80003f04:	01813983          	ld	s3,24(sp)
    80003f08:	04010113          	addi	sp,sp,64
    80003f0c:	00008067          	ret
      release(&tickslock);
    80003f10:	00015517          	auipc	a0,0x15
    80003f14:	9e050513          	addi	a0,a0,-1568 # 800188f0 <tickslock>
    80003f18:	ffffd097          	auipc	ra,0xffffd
    80003f1c:	1ac080e7          	jalr	428(ra) # 800010c4 <release>
      return -1;
    80003f20:	fff00793          	li	a5,-1
    80003f24:	fcdff06f          	j	80003ef0 <sys_sleep+0xa8>

0000000080003f28 <sys_kill>:

uint64
sys_kill(void)
{
    80003f28:	fe010113          	addi	sp,sp,-32
    80003f2c:	00113c23          	sd	ra,24(sp)
    80003f30:	00813823          	sd	s0,16(sp)
    80003f34:	02010413          	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80003f38:	fec40593          	addi	a1,s0,-20
    80003f3c:	00000513          	li	a0,0
    80003f40:	00000097          	auipc	ra,0x0
    80003f44:	c54080e7          	jalr	-940(ra) # 80003b94 <argint>
    80003f48:	00050793          	mv	a5,a0
    return -1;
    80003f4c:	fff00513          	li	a0,-1
  if(argint(0, &pid) < 0)
    80003f50:	0007c863          	bltz	a5,80003f60 <sys_kill+0x38>
  return kill(pid);
    80003f54:	fec42503          	lw	a0,-20(s0)
    80003f58:	fffff097          	auipc	ra,0xfffff
    80003f5c:	2b4080e7          	jalr	692(ra) # 8000320c <kill>
}
    80003f60:	01813083          	ld	ra,24(sp)
    80003f64:	01013403          	ld	s0,16(sp)
    80003f68:	02010113          	addi	sp,sp,32
    80003f6c:	00008067          	ret

0000000080003f70 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003f70:	fe010113          	addi	sp,sp,-32
    80003f74:	00113c23          	sd	ra,24(sp)
    80003f78:	00813823          	sd	s0,16(sp)
    80003f7c:	00913423          	sd	s1,8(sp)
    80003f80:	02010413          	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003f84:	00015517          	auipc	a0,0x15
    80003f88:	96c50513          	addi	a0,a0,-1684 # 800188f0 <tickslock>
    80003f8c:	ffffd097          	auipc	ra,0xffffd
    80003f90:	040080e7          	jalr	64(ra) # 80000fcc <acquire>
  xticks = ticks;
    80003f94:	00007497          	auipc	s1,0x7
    80003f98:	8bc4a483          	lw	s1,-1860(s1) # 8000a850 <ticks>
  release(&tickslock);
    80003f9c:	00015517          	auipc	a0,0x15
    80003fa0:	95450513          	addi	a0,a0,-1708 # 800188f0 <tickslock>
    80003fa4:	ffffd097          	auipc	ra,0xffffd
    80003fa8:	120080e7          	jalr	288(ra) # 800010c4 <release>
  return xticks;
}
    80003fac:	02049513          	slli	a0,s1,0x20
    80003fb0:	02055513          	srli	a0,a0,0x20
    80003fb4:	01813083          	ld	ra,24(sp)
    80003fb8:	01013403          	ld	s0,16(sp)
    80003fbc:	00813483          	ld	s1,8(sp)
    80003fc0:	02010113          	addi	sp,sp,32
    80003fc4:	00008067          	ret

0000000080003fc8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003fc8:	fd010113          	addi	sp,sp,-48
    80003fcc:	02113423          	sd	ra,40(sp)
    80003fd0:	02813023          	sd	s0,32(sp)
    80003fd4:	00913c23          	sd	s1,24(sp)
    80003fd8:	01213823          	sd	s2,16(sp)
    80003fdc:	01313423          	sd	s3,8(sp)
    80003fe0:	01413023          	sd	s4,0(sp)
    80003fe4:	03010413          	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003fe8:	00006597          	auipc	a1,0x6
    80003fec:	51058593          	addi	a1,a1,1296 # 8000a4f8 <syscalls+0xb0>
    80003ff0:	00015517          	auipc	a0,0x15
    80003ff4:	91850513          	addi	a0,a0,-1768 # 80018908 <bcache>
    80003ff8:	ffffd097          	auipc	ra,0xffffd
    80003ffc:	ef0080e7          	jalr	-272(ra) # 80000ee8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80004000:	0001d797          	auipc	a5,0x1d
    80004004:	90878793          	addi	a5,a5,-1784 # 80020908 <bcache+0x8000>
    80004008:	0001d717          	auipc	a4,0x1d
    8000400c:	c5870713          	addi	a4,a4,-936 # 80020c60 <bcache+0x8358>
    80004010:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    80004014:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80004018:	00015497          	auipc	s1,0x15
    8000401c:	90848493          	addi	s1,s1,-1784 # 80018920 <bcache+0x18>
    b->next = bcache.head.next;
    80004020:	00078913          	mv	s2,a5
    b->prev = &bcache.head;
    80004024:	00070993          	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80004028:	00006a17          	auipc	s4,0x6
    8000402c:	4d8a0a13          	addi	s4,s4,1240 # 8000a500 <syscalls+0xb8>
    b->next = bcache.head.next;
    80004030:	3a893783          	ld	a5,936(s2)
    80004034:	04f4b823          	sd	a5,80(s1)
    b->prev = &bcache.head;
    80004038:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000403c:	000a0593          	mv	a1,s4
    80004040:	01048513          	addi	a0,s1,16
    80004044:	00002097          	auipc	ra,0x2
    80004048:	c90080e7          	jalr	-880(ra) # 80005cd4 <initsleeplock>
    bcache.head.next->prev = b;
    8000404c:	3a893783          	ld	a5,936(s2)
    80004050:	0497b423          	sd	s1,72(a5)
    bcache.head.next = b;
    80004054:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80004058:	46048493          	addi	s1,s1,1120
    8000405c:	fd349ae3          	bne	s1,s3,80004030 <binit+0x68>
  }
}
    80004060:	02813083          	ld	ra,40(sp)
    80004064:	02013403          	ld	s0,32(sp)
    80004068:	01813483          	ld	s1,24(sp)
    8000406c:	01013903          	ld	s2,16(sp)
    80004070:	00813983          	ld	s3,8(sp)
    80004074:	00013a03          	ld	s4,0(sp)
    80004078:	03010113          	addi	sp,sp,48
    8000407c:	00008067          	ret

0000000080004080 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80004080:	fd010113          	addi	sp,sp,-48
    80004084:	02113423          	sd	ra,40(sp)
    80004088:	02813023          	sd	s0,32(sp)
    8000408c:	00913c23          	sd	s1,24(sp)
    80004090:	01213823          	sd	s2,16(sp)
    80004094:	01313423          	sd	s3,8(sp)
    80004098:	03010413          	addi	s0,sp,48
    8000409c:	00050913          	mv	s2,a0
    800040a0:	00058993          	mv	s3,a1
  acquire(&bcache.lock);
    800040a4:	00015517          	auipc	a0,0x15
    800040a8:	86450513          	addi	a0,a0,-1948 # 80018908 <bcache>
    800040ac:	ffffd097          	auipc	ra,0xffffd
    800040b0:	f20080e7          	jalr	-224(ra) # 80000fcc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800040b4:	0001d497          	auipc	s1,0x1d
    800040b8:	bfc4b483          	ld	s1,-1028(s1) # 80020cb0 <bcache+0x83a8>
    800040bc:	0001d797          	auipc	a5,0x1d
    800040c0:	ba478793          	addi	a5,a5,-1116 # 80020c60 <bcache+0x8358>
    800040c4:	04f48863          	beq	s1,a5,80004114 <bread+0x94>
    800040c8:	00078713          	mv	a4,a5
    800040cc:	00c0006f          	j	800040d8 <bread+0x58>
    800040d0:	0504b483          	ld	s1,80(s1)
    800040d4:	04e48063          	beq	s1,a4,80004114 <bread+0x94>
    if(b->dev == dev && b->blockno == blockno){
    800040d8:	0044a783          	lw	a5,4(s1)
    800040dc:	ff279ae3          	bne	a5,s2,800040d0 <bread+0x50>
    800040e0:	0084a783          	lw	a5,8(s1)
    800040e4:	ff3796e3          	bne	a5,s3,800040d0 <bread+0x50>
      b->refcnt++;
    800040e8:	0404a783          	lw	a5,64(s1)
    800040ec:	0017879b          	addiw	a5,a5,1
    800040f0:	04f4a023          	sw	a5,64(s1)
      release(&bcache.lock);
    800040f4:	00015517          	auipc	a0,0x15
    800040f8:	81450513          	addi	a0,a0,-2028 # 80018908 <bcache>
    800040fc:	ffffd097          	auipc	ra,0xffffd
    80004100:	fc8080e7          	jalr	-56(ra) # 800010c4 <release>
      acquiresleep(&b->lock);
    80004104:	01048513          	addi	a0,s1,16
    80004108:	00002097          	auipc	ra,0x2
    8000410c:	c24080e7          	jalr	-988(ra) # 80005d2c <acquiresleep>
      return b;
    80004110:	06c0006f          	j	8000417c <bread+0xfc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004114:	0001d497          	auipc	s1,0x1d
    80004118:	b944b483          	ld	s1,-1132(s1) # 80020ca8 <bcache+0x83a0>
    8000411c:	0001d797          	auipc	a5,0x1d
    80004120:	b4478793          	addi	a5,a5,-1212 # 80020c60 <bcache+0x8358>
    80004124:	00f48c63          	beq	s1,a5,8000413c <bread+0xbc>
    80004128:	00078713          	mv	a4,a5
    if(b->refcnt == 0) {
    8000412c:	0404a783          	lw	a5,64(s1)
    80004130:	00078e63          	beqz	a5,8000414c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004134:	0484b483          	ld	s1,72(s1)
    80004138:	fee49ae3          	bne	s1,a4,8000412c <bread+0xac>
  panic("bget: no buffers");
    8000413c:	00006517          	auipc	a0,0x6
    80004140:	3cc50513          	addi	a0,a0,972 # 8000a508 <syscalls+0xc0>
    80004144:	ffffc097          	auipc	ra,0xffffc
    80004148:	588080e7          	jalr	1416(ra) # 800006cc <panic>
      b->dev = dev;
    8000414c:	0124a223          	sw	s2,4(s1)
      b->blockno = blockno;
    80004150:	0134a423          	sw	s3,8(s1)
      b->flags = 0;
    80004154:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80004158:	00100793          	li	a5,1
    8000415c:	04f4a023          	sw	a5,64(s1)
      release(&bcache.lock);
    80004160:	00014517          	auipc	a0,0x14
    80004164:	7a850513          	addi	a0,a0,1960 # 80018908 <bcache>
    80004168:	ffffd097          	auipc	ra,0xffffd
    8000416c:	f5c080e7          	jalr	-164(ra) # 800010c4 <release>
      acquiresleep(&b->lock);
    80004170:	01048513          	addi	a0,s1,16
    80004174:	00002097          	auipc	ra,0x2
    80004178:	bb8080e7          	jalr	-1096(ra) # 80005d2c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
    8000417c:	0004a783          	lw	a5,0(s1)
    80004180:	0027f793          	andi	a5,a5,2
    80004184:	02078263          	beqz	a5,800041a8 <bread+0x128>
    ramdiskrw(b);
  }
  return b;
}
    80004188:	00048513          	mv	a0,s1
    8000418c:	02813083          	ld	ra,40(sp)
    80004190:	02013403          	ld	s0,32(sp)
    80004194:	01813483          	ld	s1,24(sp)
    80004198:	01013903          	ld	s2,16(sp)
    8000419c:	00813983          	ld	s3,8(sp)
    800041a0:	03010113          	addi	sp,sp,48
    800041a4:	00008067          	ret
    ramdiskrw(b);
    800041a8:	00048513          	mv	a0,s1
    800041ac:	00002097          	auipc	ra,0x2
    800041b0:	718080e7          	jalr	1816(ra) # 800068c4 <ramdiskrw>
  return b;
    800041b4:	fd5ff06f          	j	80004188 <bread+0x108>

00000000800041b8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800041b8:	fe010113          	addi	sp,sp,-32
    800041bc:	00113c23          	sd	ra,24(sp)
    800041c0:	00813823          	sd	s0,16(sp)
    800041c4:	00913423          	sd	s1,8(sp)
    800041c8:	02010413          	addi	s0,sp,32
    800041cc:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800041d0:	01050513          	addi	a0,a0,16
    800041d4:	00002097          	auipc	ra,0x2
    800041d8:	c44080e7          	jalr	-956(ra) # 80005e18 <holdingsleep>
    800041dc:	02050863          	beqz	a0,8000420c <bwrite+0x54>
    panic("bwrite");
  b->flags |= B_DIRTY;
    800041e0:	0004a783          	lw	a5,0(s1)
    800041e4:	0047e793          	ori	a5,a5,4
    800041e8:	00f4a023          	sw	a5,0(s1)
  ramdiskrw(b);
    800041ec:	00048513          	mv	a0,s1
    800041f0:	00002097          	auipc	ra,0x2
    800041f4:	6d4080e7          	jalr	1748(ra) # 800068c4 <ramdiskrw>
}
    800041f8:	01813083          	ld	ra,24(sp)
    800041fc:	01013403          	ld	s0,16(sp)
    80004200:	00813483          	ld	s1,8(sp)
    80004204:	02010113          	addi	sp,sp,32
    80004208:	00008067          	ret
    panic("bwrite");
    8000420c:	00006517          	auipc	a0,0x6
    80004210:	31450513          	addi	a0,a0,788 # 8000a520 <syscalls+0xd8>
    80004214:	ffffc097          	auipc	ra,0xffffc
    80004218:	4b8080e7          	jalr	1208(ra) # 800006cc <panic>

000000008000421c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000421c:	fe010113          	addi	sp,sp,-32
    80004220:	00113c23          	sd	ra,24(sp)
    80004224:	00813823          	sd	s0,16(sp)
    80004228:	00913423          	sd	s1,8(sp)
    8000422c:	01213023          	sd	s2,0(sp)
    80004230:	02010413          	addi	s0,sp,32
    80004234:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80004238:	01050913          	addi	s2,a0,16
    8000423c:	00090513          	mv	a0,s2
    80004240:	00002097          	auipc	ra,0x2
    80004244:	bd8080e7          	jalr	-1064(ra) # 80005e18 <holdingsleep>
    80004248:	08050e63          	beqz	a0,800042e4 <brelse+0xc8>
    panic("brelse");

  releasesleep(&b->lock);
    8000424c:	00090513          	mv	a0,s2
    80004250:	00002097          	auipc	ra,0x2
    80004254:	b64080e7          	jalr	-1180(ra) # 80005db4 <releasesleep>

  acquire(&bcache.lock);
    80004258:	00014517          	auipc	a0,0x14
    8000425c:	6b050513          	addi	a0,a0,1712 # 80018908 <bcache>
    80004260:	ffffd097          	auipc	ra,0xffffd
    80004264:	d6c080e7          	jalr	-660(ra) # 80000fcc <acquire>
  b->refcnt--;
    80004268:	0404a783          	lw	a5,64(s1)
    8000426c:	fff7879b          	addiw	a5,a5,-1
    80004270:	0007871b          	sext.w	a4,a5
    80004274:	04f4a023          	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80004278:	04071263          	bnez	a4,800042bc <brelse+0xa0>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000427c:	0504b783          	ld	a5,80(s1)
    80004280:	0484b703          	ld	a4,72(s1)
    80004284:	04e7b423          	sd	a4,72(a5)
    b->prev->next = b->next;
    80004288:	0484b783          	ld	a5,72(s1)
    8000428c:	0504b703          	ld	a4,80(s1)
    80004290:	04e7b823          	sd	a4,80(a5)
    b->next = bcache.head.next;
    80004294:	0001c797          	auipc	a5,0x1c
    80004298:	67478793          	addi	a5,a5,1652 # 80020908 <bcache+0x8000>
    8000429c:	3a87b703          	ld	a4,936(a5)
    800042a0:	04e4b823          	sd	a4,80(s1)
    b->prev = &bcache.head;
    800042a4:	0001d717          	auipc	a4,0x1d
    800042a8:	9bc70713          	addi	a4,a4,-1604 # 80020c60 <bcache+0x8358>
    800042ac:	04e4b423          	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800042b0:	3a87b703          	ld	a4,936(a5)
    800042b4:	04973423          	sd	s1,72(a4)
    bcache.head.next = b;
    800042b8:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    800042bc:	00014517          	auipc	a0,0x14
    800042c0:	64c50513          	addi	a0,a0,1612 # 80018908 <bcache>
    800042c4:	ffffd097          	auipc	ra,0xffffd
    800042c8:	e00080e7          	jalr	-512(ra) # 800010c4 <release>
}
    800042cc:	01813083          	ld	ra,24(sp)
    800042d0:	01013403          	ld	s0,16(sp)
    800042d4:	00813483          	ld	s1,8(sp)
    800042d8:	00013903          	ld	s2,0(sp)
    800042dc:	02010113          	addi	sp,sp,32
    800042e0:	00008067          	ret
    panic("brelse");
    800042e4:	00006517          	auipc	a0,0x6
    800042e8:	24450513          	addi	a0,a0,580 # 8000a528 <syscalls+0xe0>
    800042ec:	ffffc097          	auipc	ra,0xffffc
    800042f0:	3e0080e7          	jalr	992(ra) # 800006cc <panic>

00000000800042f4 <bpin>:

void
bpin(struct buf *b) {
    800042f4:	fe010113          	addi	sp,sp,-32
    800042f8:	00113c23          	sd	ra,24(sp)
    800042fc:	00813823          	sd	s0,16(sp)
    80004300:	00913423          	sd	s1,8(sp)
    80004304:	02010413          	addi	s0,sp,32
    80004308:	00050493          	mv	s1,a0
  acquire(&bcache.lock);
    8000430c:	00014517          	auipc	a0,0x14
    80004310:	5fc50513          	addi	a0,a0,1532 # 80018908 <bcache>
    80004314:	ffffd097          	auipc	ra,0xffffd
    80004318:	cb8080e7          	jalr	-840(ra) # 80000fcc <acquire>
  b->refcnt++;
    8000431c:	0404a783          	lw	a5,64(s1)
    80004320:	0017879b          	addiw	a5,a5,1
    80004324:	04f4a023          	sw	a5,64(s1)
  release(&bcache.lock);
    80004328:	00014517          	auipc	a0,0x14
    8000432c:	5e050513          	addi	a0,a0,1504 # 80018908 <bcache>
    80004330:	ffffd097          	auipc	ra,0xffffd
    80004334:	d94080e7          	jalr	-620(ra) # 800010c4 <release>
}
    80004338:	01813083          	ld	ra,24(sp)
    8000433c:	01013403          	ld	s0,16(sp)
    80004340:	00813483          	ld	s1,8(sp)
    80004344:	02010113          	addi	sp,sp,32
    80004348:	00008067          	ret

000000008000434c <bunpin>:

void
bunpin(struct buf *b) {
    8000434c:	fe010113          	addi	sp,sp,-32
    80004350:	00113c23          	sd	ra,24(sp)
    80004354:	00813823          	sd	s0,16(sp)
    80004358:	00913423          	sd	s1,8(sp)
    8000435c:	02010413          	addi	s0,sp,32
    80004360:	00050493          	mv	s1,a0
  acquire(&bcache.lock);
    80004364:	00014517          	auipc	a0,0x14
    80004368:	5a450513          	addi	a0,a0,1444 # 80018908 <bcache>
    8000436c:	ffffd097          	auipc	ra,0xffffd
    80004370:	c60080e7          	jalr	-928(ra) # 80000fcc <acquire>
  b->refcnt--;
    80004374:	0404a783          	lw	a5,64(s1)
    80004378:	fff7879b          	addiw	a5,a5,-1
    8000437c:	04f4a023          	sw	a5,64(s1)
  release(&bcache.lock);
    80004380:	00014517          	auipc	a0,0x14
    80004384:	58850513          	addi	a0,a0,1416 # 80018908 <bcache>
    80004388:	ffffd097          	auipc	ra,0xffffd
    8000438c:	d3c080e7          	jalr	-708(ra) # 800010c4 <release>
}
    80004390:	01813083          	ld	ra,24(sp)
    80004394:	01013403          	ld	s0,16(sp)
    80004398:	00813483          	ld	s1,8(sp)
    8000439c:	02010113          	addi	sp,sp,32
    800043a0:	00008067          	ret

00000000800043a4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800043a4:	fe010113          	addi	sp,sp,-32
    800043a8:	00113c23          	sd	ra,24(sp)
    800043ac:	00813823          	sd	s0,16(sp)
    800043b0:	00913423          	sd	s1,8(sp)
    800043b4:	01213023          	sd	s2,0(sp)
    800043b8:	02010413          	addi	s0,sp,32
    800043bc:	00058493          	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800043c0:	00d5d59b          	srliw	a1,a1,0xd
    800043c4:	0001d797          	auipc	a5,0x1d
    800043c8:	d187a783          	lw	a5,-744(a5) # 800210dc <sb+0x1c>
    800043cc:	00f585bb          	addw	a1,a1,a5
    800043d0:	00000097          	auipc	ra,0x0
    800043d4:	cb0080e7          	jalr	-848(ra) # 80004080 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800043d8:	0074f713          	andi	a4,s1,7
    800043dc:	00100793          	li	a5,1
    800043e0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800043e4:	03349493          	slli	s1,s1,0x33
    800043e8:	0364d493          	srli	s1,s1,0x36
    800043ec:	00950733          	add	a4,a0,s1
    800043f0:	06074703          	lbu	a4,96(a4)
    800043f4:	00e7f6b3          	and	a3,a5,a4
    800043f8:	04068263          	beqz	a3,8000443c <bfree+0x98>
    800043fc:	00050913          	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80004400:	009504b3          	add	s1,a0,s1
    80004404:	fff7c793          	not	a5,a5
    80004408:	00e7f7b3          	and	a5,a5,a4
    8000440c:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    80004410:	00001097          	auipc	ra,0x1
    80004414:	798080e7          	jalr	1944(ra) # 80005ba8 <log_write>
  brelse(bp);
    80004418:	00090513          	mv	a0,s2
    8000441c:	00000097          	auipc	ra,0x0
    80004420:	e00080e7          	jalr	-512(ra) # 8000421c <brelse>
}
    80004424:	01813083          	ld	ra,24(sp)
    80004428:	01013403          	ld	s0,16(sp)
    8000442c:	00813483          	ld	s1,8(sp)
    80004430:	00013903          	ld	s2,0(sp)
    80004434:	02010113          	addi	sp,sp,32
    80004438:	00008067          	ret
    panic("freeing free block");
    8000443c:	00006517          	auipc	a0,0x6
    80004440:	0f450513          	addi	a0,a0,244 # 8000a530 <syscalls+0xe8>
    80004444:	ffffc097          	auipc	ra,0xffffc
    80004448:	288080e7          	jalr	648(ra) # 800006cc <panic>

000000008000444c <balloc>:
{
    8000444c:	fa010113          	addi	sp,sp,-96
    80004450:	04113c23          	sd	ra,88(sp)
    80004454:	04813823          	sd	s0,80(sp)
    80004458:	04913423          	sd	s1,72(sp)
    8000445c:	05213023          	sd	s2,64(sp)
    80004460:	03313c23          	sd	s3,56(sp)
    80004464:	03413823          	sd	s4,48(sp)
    80004468:	03513423          	sd	s5,40(sp)
    8000446c:	03613023          	sd	s6,32(sp)
    80004470:	01713c23          	sd	s7,24(sp)
    80004474:	01813823          	sd	s8,16(sp)
    80004478:	01913423          	sd	s9,8(sp)
    8000447c:	06010413          	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80004480:	0001d797          	auipc	a5,0x1d
    80004484:	c447a783          	lw	a5,-956(a5) # 800210c4 <sb+0x4>
    80004488:	0a078c63          	beqz	a5,80004540 <balloc+0xf4>
    8000448c:	00050b93          	mv	s7,a0
    80004490:	00000a93          	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80004494:	0001db17          	auipc	s6,0x1d
    80004498:	c2cb0b13          	addi	s6,s6,-980 # 800210c0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000449c:	00000c13          	li	s8,0
      m = 1 << (bi % 8);
    800044a0:	00100993          	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800044a4:	00002a37          	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800044a8:	00002cb7          	lui	s9,0x2
    800044ac:	0200006f          	j	800044cc <balloc+0x80>
    brelse(bp);
    800044b0:	00090513          	mv	a0,s2
    800044b4:	00000097          	auipc	ra,0x0
    800044b8:	d68080e7          	jalr	-664(ra) # 8000421c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800044bc:	015c87bb          	addw	a5,s9,s5
    800044c0:	00078a9b          	sext.w	s5,a5
    800044c4:	004b2703          	lw	a4,4(s6)
    800044c8:	06eafc63          	bgeu	s5,a4,80004540 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    800044cc:	41fad79b          	sraiw	a5,s5,0x1f
    800044d0:	0137d79b          	srliw	a5,a5,0x13
    800044d4:	015787bb          	addw	a5,a5,s5
    800044d8:	40d7d79b          	sraiw	a5,a5,0xd
    800044dc:	01cb2583          	lw	a1,28(s6)
    800044e0:	00b785bb          	addw	a1,a5,a1
    800044e4:	000b8513          	mv	a0,s7
    800044e8:	00000097          	auipc	ra,0x0
    800044ec:	b98080e7          	jalr	-1128(ra) # 80004080 <bread>
    800044f0:	00050913          	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800044f4:	004b2503          	lw	a0,4(s6)
    800044f8:	000a849b          	sext.w	s1,s5
    800044fc:	000c0613          	mv	a2,s8
    80004500:	faa4f8e3          	bgeu	s1,a0,800044b0 <balloc+0x64>
      m = 1 << (bi % 8);
    80004504:	41f6579b          	sraiw	a5,a2,0x1f
    80004508:	01d7d69b          	srliw	a3,a5,0x1d
    8000450c:	00c6873b          	addw	a4,a3,a2
    80004510:	00777793          	andi	a5,a4,7
    80004514:	40d787bb          	subw	a5,a5,a3
    80004518:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000451c:	4037571b          	sraiw	a4,a4,0x3
    80004520:	00e906b3          	add	a3,s2,a4
    80004524:	0606c683          	lbu	a3,96(a3)
    80004528:	00d7f5b3          	and	a1,a5,a3
    8000452c:	02058263          	beqz	a1,80004550 <balloc+0x104>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004530:	0016061b          	addiw	a2,a2,1
    80004534:	0014849b          	addiw	s1,s1,1
    80004538:	fd4614e3          	bne	a2,s4,80004500 <balloc+0xb4>
    8000453c:	f75ff06f          	j	800044b0 <balloc+0x64>
  panic("balloc: out of blocks");
    80004540:	00006517          	auipc	a0,0x6
    80004544:	00850513          	addi	a0,a0,8 # 8000a548 <syscalls+0x100>
    80004548:	ffffc097          	auipc	ra,0xffffc
    8000454c:	184080e7          	jalr	388(ra) # 800006cc <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004550:	00e90733          	add	a4,s2,a4
    80004554:	00f6e7b3          	or	a5,a3,a5
    80004558:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    8000455c:	00090513          	mv	a0,s2
    80004560:	00001097          	auipc	ra,0x1
    80004564:	648080e7          	jalr	1608(ra) # 80005ba8 <log_write>
        brelse(bp);
    80004568:	00090513          	mv	a0,s2
    8000456c:	00000097          	auipc	ra,0x0
    80004570:	cb0080e7          	jalr	-848(ra) # 8000421c <brelse>
  bp = bread(dev, bno);
    80004574:	00048593          	mv	a1,s1
    80004578:	000b8513          	mv	a0,s7
    8000457c:	00000097          	auipc	ra,0x0
    80004580:	b04080e7          	jalr	-1276(ra) # 80004080 <bread>
    80004584:	00050913          	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80004588:	40000613          	li	a2,1024
    8000458c:	00000593          	li	a1,0
    80004590:	06050513          	addi	a0,a0,96
    80004594:	ffffd097          	auipc	ra,0xffffd
    80004598:	b90080e7          	jalr	-1136(ra) # 80001124 <memset>
  log_write(bp);
    8000459c:	00090513          	mv	a0,s2
    800045a0:	00001097          	auipc	ra,0x1
    800045a4:	608080e7          	jalr	1544(ra) # 80005ba8 <log_write>
  brelse(bp);
    800045a8:	00090513          	mv	a0,s2
    800045ac:	00000097          	auipc	ra,0x0
    800045b0:	c70080e7          	jalr	-912(ra) # 8000421c <brelse>
}
    800045b4:	00048513          	mv	a0,s1
    800045b8:	05813083          	ld	ra,88(sp)
    800045bc:	05013403          	ld	s0,80(sp)
    800045c0:	04813483          	ld	s1,72(sp)
    800045c4:	04013903          	ld	s2,64(sp)
    800045c8:	03813983          	ld	s3,56(sp)
    800045cc:	03013a03          	ld	s4,48(sp)
    800045d0:	02813a83          	ld	s5,40(sp)
    800045d4:	02013b03          	ld	s6,32(sp)
    800045d8:	01813b83          	ld	s7,24(sp)
    800045dc:	01013c03          	ld	s8,16(sp)
    800045e0:	00813c83          	ld	s9,8(sp)
    800045e4:	06010113          	addi	sp,sp,96
    800045e8:	00008067          	ret

00000000800045ec <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800045ec:	fd010113          	addi	sp,sp,-48
    800045f0:	02113423          	sd	ra,40(sp)
    800045f4:	02813023          	sd	s0,32(sp)
    800045f8:	00913c23          	sd	s1,24(sp)
    800045fc:	01213823          	sd	s2,16(sp)
    80004600:	01313423          	sd	s3,8(sp)
    80004604:	01413023          	sd	s4,0(sp)
    80004608:	03010413          	addi	s0,sp,48
    8000460c:	00050913          	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80004610:	00b00793          	li	a5,11
    80004614:	06b7fa63          	bgeu	a5,a1,80004688 <bmap+0x9c>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80004618:	ff45849b          	addiw	s1,a1,-12
    8000461c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80004620:	0ff00793          	li	a5,255
    80004624:	0ce7e663          	bltu	a5,a4,800046f0 <bmap+0x104>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80004628:	08052583          	lw	a1,128(a0)
    8000462c:	08058463          	beqz	a1,800046b4 <bmap+0xc8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80004630:	00092503          	lw	a0,0(s2)
    80004634:	00000097          	auipc	ra,0x0
    80004638:	a4c080e7          	jalr	-1460(ra) # 80004080 <bread>
    8000463c:	00050a13          	mv	s4,a0
    a = (uint*)bp->data;
    80004640:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80004644:	02049713          	slli	a4,s1,0x20
    80004648:	01e75593          	srli	a1,a4,0x1e
    8000464c:	00b784b3          	add	s1,a5,a1
    80004650:	0004a983          	lw	s3,0(s1)
    80004654:	06098c63          	beqz	s3,800046cc <bmap+0xe0>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80004658:	000a0513          	mv	a0,s4
    8000465c:	00000097          	auipc	ra,0x0
    80004660:	bc0080e7          	jalr	-1088(ra) # 8000421c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80004664:	00098513          	mv	a0,s3
    80004668:	02813083          	ld	ra,40(sp)
    8000466c:	02013403          	ld	s0,32(sp)
    80004670:	01813483          	ld	s1,24(sp)
    80004674:	01013903          	ld	s2,16(sp)
    80004678:	00813983          	ld	s3,8(sp)
    8000467c:	00013a03          	ld	s4,0(sp)
    80004680:	03010113          	addi	sp,sp,48
    80004684:	00008067          	ret
    if((addr = ip->addrs[bn]) == 0)
    80004688:	02059793          	slli	a5,a1,0x20
    8000468c:	01e7d593          	srli	a1,a5,0x1e
    80004690:	00b504b3          	add	s1,a0,a1
    80004694:	0504a983          	lw	s3,80(s1)
    80004698:	fc0996e3          	bnez	s3,80004664 <bmap+0x78>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000469c:	00052503          	lw	a0,0(a0)
    800046a0:	00000097          	auipc	ra,0x0
    800046a4:	dac080e7          	jalr	-596(ra) # 8000444c <balloc>
    800046a8:	0005099b          	sext.w	s3,a0
    800046ac:	0534a823          	sw	s3,80(s1)
    800046b0:	fb5ff06f          	j	80004664 <bmap+0x78>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800046b4:	00052503          	lw	a0,0(a0)
    800046b8:	00000097          	auipc	ra,0x0
    800046bc:	d94080e7          	jalr	-620(ra) # 8000444c <balloc>
    800046c0:	0005059b          	sext.w	a1,a0
    800046c4:	08b92023          	sw	a1,128(s2)
    800046c8:	f69ff06f          	j	80004630 <bmap+0x44>
      a[bn] = addr = balloc(ip->dev);
    800046cc:	00092503          	lw	a0,0(s2)
    800046d0:	00000097          	auipc	ra,0x0
    800046d4:	d7c080e7          	jalr	-644(ra) # 8000444c <balloc>
    800046d8:	0005099b          	sext.w	s3,a0
    800046dc:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800046e0:	000a0513          	mv	a0,s4
    800046e4:	00001097          	auipc	ra,0x1
    800046e8:	4c4080e7          	jalr	1220(ra) # 80005ba8 <log_write>
    800046ec:	f6dff06f          	j	80004658 <bmap+0x6c>
  panic("bmap: out of range");
    800046f0:	00006517          	auipc	a0,0x6
    800046f4:	e7050513          	addi	a0,a0,-400 # 8000a560 <syscalls+0x118>
    800046f8:	ffffc097          	auipc	ra,0xffffc
    800046fc:	fd4080e7          	jalr	-44(ra) # 800006cc <panic>

0000000080004700 <iget>:
{
    80004700:	fd010113          	addi	sp,sp,-48
    80004704:	02113423          	sd	ra,40(sp)
    80004708:	02813023          	sd	s0,32(sp)
    8000470c:	00913c23          	sd	s1,24(sp)
    80004710:	01213823          	sd	s2,16(sp)
    80004714:	01313423          	sd	s3,8(sp)
    80004718:	01413023          	sd	s4,0(sp)
    8000471c:	03010413          	addi	s0,sp,48
    80004720:	00050993          	mv	s3,a0
    80004724:	00058a13          	mv	s4,a1
  acquire(&itable.lock);
    80004728:	0001d517          	auipc	a0,0x1d
    8000472c:	9b850513          	addi	a0,a0,-1608 # 800210e0 <itable>
    80004730:	ffffd097          	auipc	ra,0xffffd
    80004734:	89c080e7          	jalr	-1892(ra) # 80000fcc <acquire>
  empty = 0;
    80004738:	00000913          	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000473c:	0001d497          	auipc	s1,0x1d
    80004740:	9bc48493          	addi	s1,s1,-1604 # 800210f8 <itable+0x18>
    80004744:	0001e697          	auipc	a3,0x1e
    80004748:	44468693          	addi	a3,a3,1092 # 80022b88 <log>
    8000474c:	0100006f          	j	8000475c <iget+0x5c>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004750:	04090263          	beqz	s2,80004794 <iget+0x94>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004754:	08848493          	addi	s1,s1,136
    80004758:	04d48463          	beq	s1,a3,800047a0 <iget+0xa0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000475c:	0084a783          	lw	a5,8(s1)
    80004760:	fef058e3          	blez	a5,80004750 <iget+0x50>
    80004764:	0004a703          	lw	a4,0(s1)
    80004768:	ff3714e3          	bne	a4,s3,80004750 <iget+0x50>
    8000476c:	0044a703          	lw	a4,4(s1)
    80004770:	ff4710e3          	bne	a4,s4,80004750 <iget+0x50>
      ip->ref++;
    80004774:	0017879b          	addiw	a5,a5,1
    80004778:	00f4a423          	sw	a5,8(s1)
      release(&itable.lock);
    8000477c:	0001d517          	auipc	a0,0x1d
    80004780:	96450513          	addi	a0,a0,-1692 # 800210e0 <itable>
    80004784:	ffffd097          	auipc	ra,0xffffd
    80004788:	940080e7          	jalr	-1728(ra) # 800010c4 <release>
      return ip;
    8000478c:	00048913          	mv	s2,s1
    80004790:	0380006f          	j	800047c8 <iget+0xc8>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004794:	fc0790e3          	bnez	a5,80004754 <iget+0x54>
    80004798:	00048913          	mv	s2,s1
    8000479c:	fb9ff06f          	j	80004754 <iget+0x54>
  if(empty == 0)
    800047a0:	04090663          	beqz	s2,800047ec <iget+0xec>
  ip->dev = dev;
    800047a4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800047a8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800047ac:	00100793          	li	a5,1
    800047b0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800047b4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800047b8:	0001d517          	auipc	a0,0x1d
    800047bc:	92850513          	addi	a0,a0,-1752 # 800210e0 <itable>
    800047c0:	ffffd097          	auipc	ra,0xffffd
    800047c4:	904080e7          	jalr	-1788(ra) # 800010c4 <release>
}
    800047c8:	00090513          	mv	a0,s2
    800047cc:	02813083          	ld	ra,40(sp)
    800047d0:	02013403          	ld	s0,32(sp)
    800047d4:	01813483          	ld	s1,24(sp)
    800047d8:	01013903          	ld	s2,16(sp)
    800047dc:	00813983          	ld	s3,8(sp)
    800047e0:	00013a03          	ld	s4,0(sp)
    800047e4:	03010113          	addi	sp,sp,48
    800047e8:	00008067          	ret
    panic("iget: no inodes");
    800047ec:	00006517          	auipc	a0,0x6
    800047f0:	d8c50513          	addi	a0,a0,-628 # 8000a578 <syscalls+0x130>
    800047f4:	ffffc097          	auipc	ra,0xffffc
    800047f8:	ed8080e7          	jalr	-296(ra) # 800006cc <panic>

00000000800047fc <fsinit>:
fsinit(int dev) {
    800047fc:	fd010113          	addi	sp,sp,-48
    80004800:	02113423          	sd	ra,40(sp)
    80004804:	02813023          	sd	s0,32(sp)
    80004808:	00913c23          	sd	s1,24(sp)
    8000480c:	01213823          	sd	s2,16(sp)
    80004810:	01313423          	sd	s3,8(sp)
    80004814:	03010413          	addi	s0,sp,48
    80004818:	00050913          	mv	s2,a0
  bp = bread(dev, 1);
    8000481c:	00100593          	li	a1,1
    80004820:	00000097          	auipc	ra,0x0
    80004824:	860080e7          	jalr	-1952(ra) # 80004080 <bread>
    80004828:	00050493          	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000482c:	0001d997          	auipc	s3,0x1d
    80004830:	89498993          	addi	s3,s3,-1900 # 800210c0 <sb>
    80004834:	02000613          	li	a2,32
    80004838:	06050593          	addi	a1,a0,96
    8000483c:	00098513          	mv	a0,s3
    80004840:	ffffd097          	auipc	ra,0xffffd
    80004844:	978080e7          	jalr	-1672(ra) # 800011b8 <memmove>
  brelse(bp);
    80004848:	00048513          	mv	a0,s1
    8000484c:	00000097          	auipc	ra,0x0
    80004850:	9d0080e7          	jalr	-1584(ra) # 8000421c <brelse>
  if(sb.magic != FSMAGIC)
    80004854:	0009a703          	lw	a4,0(s3)
    80004858:	102037b7          	lui	a5,0x10203
    8000485c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004860:	02f71a63          	bne	a4,a5,80004894 <fsinit+0x98>
  initlog(dev, &sb);
    80004864:	0001d597          	auipc	a1,0x1d
    80004868:	85c58593          	addi	a1,a1,-1956 # 800210c0 <sb>
    8000486c:	00090513          	mv	a0,s2
    80004870:	00001097          	auipc	ra,0x1
    80004874:	ff4080e7          	jalr	-12(ra) # 80005864 <initlog>
}
    80004878:	02813083          	ld	ra,40(sp)
    8000487c:	02013403          	ld	s0,32(sp)
    80004880:	01813483          	ld	s1,24(sp)
    80004884:	01013903          	ld	s2,16(sp)
    80004888:	00813983          	ld	s3,8(sp)
    8000488c:	03010113          	addi	sp,sp,48
    80004890:	00008067          	ret
    panic("invalid file system");
    80004894:	00006517          	auipc	a0,0x6
    80004898:	cf450513          	addi	a0,a0,-780 # 8000a588 <syscalls+0x140>
    8000489c:	ffffc097          	auipc	ra,0xffffc
    800048a0:	e30080e7          	jalr	-464(ra) # 800006cc <panic>

00000000800048a4 <iinit>:
{
    800048a4:	fd010113          	addi	sp,sp,-48
    800048a8:	02113423          	sd	ra,40(sp)
    800048ac:	02813023          	sd	s0,32(sp)
    800048b0:	00913c23          	sd	s1,24(sp)
    800048b4:	01213823          	sd	s2,16(sp)
    800048b8:	01313423          	sd	s3,8(sp)
    800048bc:	03010413          	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800048c0:	00006597          	auipc	a1,0x6
    800048c4:	ce058593          	addi	a1,a1,-800 # 8000a5a0 <syscalls+0x158>
    800048c8:	0001d517          	auipc	a0,0x1d
    800048cc:	81850513          	addi	a0,a0,-2024 # 800210e0 <itable>
    800048d0:	ffffc097          	auipc	ra,0xffffc
    800048d4:	618080e7          	jalr	1560(ra) # 80000ee8 <initlock>
  for(i = 0; i < NINODE; i++) {
    800048d8:	0001d497          	auipc	s1,0x1d
    800048dc:	83048493          	addi	s1,s1,-2000 # 80021108 <itable+0x28>
    800048e0:	0001e997          	auipc	s3,0x1e
    800048e4:	2b898993          	addi	s3,s3,696 # 80022b98 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800048e8:	00006917          	auipc	s2,0x6
    800048ec:	cc090913          	addi	s2,s2,-832 # 8000a5a8 <syscalls+0x160>
    800048f0:	00090593          	mv	a1,s2
    800048f4:	00048513          	mv	a0,s1
    800048f8:	00001097          	auipc	ra,0x1
    800048fc:	3dc080e7          	jalr	988(ra) # 80005cd4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004900:	08848493          	addi	s1,s1,136
    80004904:	ff3496e3          	bne	s1,s3,800048f0 <iinit+0x4c>
}
    80004908:	02813083          	ld	ra,40(sp)
    8000490c:	02013403          	ld	s0,32(sp)
    80004910:	01813483          	ld	s1,24(sp)
    80004914:	01013903          	ld	s2,16(sp)
    80004918:	00813983          	ld	s3,8(sp)
    8000491c:	03010113          	addi	sp,sp,48
    80004920:	00008067          	ret

0000000080004924 <ialloc>:
{
    80004924:	fb010113          	addi	sp,sp,-80
    80004928:	04113423          	sd	ra,72(sp)
    8000492c:	04813023          	sd	s0,64(sp)
    80004930:	02913c23          	sd	s1,56(sp)
    80004934:	03213823          	sd	s2,48(sp)
    80004938:	03313423          	sd	s3,40(sp)
    8000493c:	03413023          	sd	s4,32(sp)
    80004940:	01513c23          	sd	s5,24(sp)
    80004944:	01613823          	sd	s6,16(sp)
    80004948:	01713423          	sd	s7,8(sp)
    8000494c:	05010413          	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80004950:	0001c717          	auipc	a4,0x1c
    80004954:	77c72703          	lw	a4,1916(a4) # 800210cc <sb+0xc>
    80004958:	00100793          	li	a5,1
    8000495c:	06e7f463          	bgeu	a5,a4,800049c4 <ialloc+0xa0>
    80004960:	00050a93          	mv	s5,a0
    80004964:	00058b93          	mv	s7,a1
    80004968:	00100493          	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000496c:	0001ca17          	auipc	s4,0x1c
    80004970:	754a0a13          	addi	s4,s4,1876 # 800210c0 <sb>
    80004974:	00048b1b          	sext.w	s6,s1
    80004978:	0044d793          	srli	a5,s1,0x4
    8000497c:	018a2583          	lw	a1,24(s4)
    80004980:	00f585bb          	addw	a1,a1,a5
    80004984:	000a8513          	mv	a0,s5
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	6f8080e7          	jalr	1784(ra) # 80004080 <bread>
    80004990:	00050913          	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80004994:	06050993          	addi	s3,a0,96
    80004998:	00f4f793          	andi	a5,s1,15
    8000499c:	00679793          	slli	a5,a5,0x6
    800049a0:	00f989b3          	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800049a4:	00099783          	lh	a5,0(s3)
    800049a8:	02078663          	beqz	a5,800049d4 <ialloc+0xb0>
    brelse(bp);
    800049ac:	00000097          	auipc	ra,0x0
    800049b0:	870080e7          	jalr	-1936(ra) # 8000421c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800049b4:	00148493          	addi	s1,s1,1
    800049b8:	00ca2703          	lw	a4,12(s4)
    800049bc:	0004879b          	sext.w	a5,s1
    800049c0:	fae7eae3          	bltu	a5,a4,80004974 <ialloc+0x50>
  panic("ialloc: no inodes");
    800049c4:	00006517          	auipc	a0,0x6
    800049c8:	bec50513          	addi	a0,a0,-1044 # 8000a5b0 <syscalls+0x168>
    800049cc:	ffffc097          	auipc	ra,0xffffc
    800049d0:	d00080e7          	jalr	-768(ra) # 800006cc <panic>
      memset(dip, 0, sizeof(*dip));
    800049d4:	04000613          	li	a2,64
    800049d8:	00000593          	li	a1,0
    800049dc:	00098513          	mv	a0,s3
    800049e0:	ffffc097          	auipc	ra,0xffffc
    800049e4:	744080e7          	jalr	1860(ra) # 80001124 <memset>
      dip->type = type;
    800049e8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800049ec:	00090513          	mv	a0,s2
    800049f0:	00001097          	auipc	ra,0x1
    800049f4:	1b8080e7          	jalr	440(ra) # 80005ba8 <log_write>
      brelse(bp);
    800049f8:	00090513          	mv	a0,s2
    800049fc:	00000097          	auipc	ra,0x0
    80004a00:	820080e7          	jalr	-2016(ra) # 8000421c <brelse>
      return iget(dev, inum);
    80004a04:	000b0593          	mv	a1,s6
    80004a08:	000a8513          	mv	a0,s5
    80004a0c:	00000097          	auipc	ra,0x0
    80004a10:	cf4080e7          	jalr	-780(ra) # 80004700 <iget>
}
    80004a14:	04813083          	ld	ra,72(sp)
    80004a18:	04013403          	ld	s0,64(sp)
    80004a1c:	03813483          	ld	s1,56(sp)
    80004a20:	03013903          	ld	s2,48(sp)
    80004a24:	02813983          	ld	s3,40(sp)
    80004a28:	02013a03          	ld	s4,32(sp)
    80004a2c:	01813a83          	ld	s5,24(sp)
    80004a30:	01013b03          	ld	s6,16(sp)
    80004a34:	00813b83          	ld	s7,8(sp)
    80004a38:	05010113          	addi	sp,sp,80
    80004a3c:	00008067          	ret

0000000080004a40 <iupdate>:
{
    80004a40:	fe010113          	addi	sp,sp,-32
    80004a44:	00113c23          	sd	ra,24(sp)
    80004a48:	00813823          	sd	s0,16(sp)
    80004a4c:	00913423          	sd	s1,8(sp)
    80004a50:	01213023          	sd	s2,0(sp)
    80004a54:	02010413          	addi	s0,sp,32
    80004a58:	00050493          	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004a5c:	00452783          	lw	a5,4(a0)
    80004a60:	0047d79b          	srliw	a5,a5,0x4
    80004a64:	0001c597          	auipc	a1,0x1c
    80004a68:	6745a583          	lw	a1,1652(a1) # 800210d8 <sb+0x18>
    80004a6c:	00b785bb          	addw	a1,a5,a1
    80004a70:	00052503          	lw	a0,0(a0)
    80004a74:	fffff097          	auipc	ra,0xfffff
    80004a78:	60c080e7          	jalr	1548(ra) # 80004080 <bread>
    80004a7c:	00050913          	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004a80:	06050793          	addi	a5,a0,96
    80004a84:	0044a503          	lw	a0,4(s1)
    80004a88:	00f57513          	andi	a0,a0,15
    80004a8c:	00651513          	slli	a0,a0,0x6
    80004a90:	00a78533          	add	a0,a5,a0
  dip->type = ip->type;
    80004a94:	04449703          	lh	a4,68(s1)
    80004a98:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80004a9c:	04649703          	lh	a4,70(s1)
    80004aa0:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80004aa4:	04849703          	lh	a4,72(s1)
    80004aa8:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80004aac:	04a49703          	lh	a4,74(s1)
    80004ab0:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80004ab4:	04c4a703          	lw	a4,76(s1)
    80004ab8:	00e52423          	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004abc:	03400613          	li	a2,52
    80004ac0:	05048593          	addi	a1,s1,80
    80004ac4:	00c50513          	addi	a0,a0,12
    80004ac8:	ffffc097          	auipc	ra,0xffffc
    80004acc:	6f0080e7          	jalr	1776(ra) # 800011b8 <memmove>
  log_write(bp);
    80004ad0:	00090513          	mv	a0,s2
    80004ad4:	00001097          	auipc	ra,0x1
    80004ad8:	0d4080e7          	jalr	212(ra) # 80005ba8 <log_write>
  brelse(bp);
    80004adc:	00090513          	mv	a0,s2
    80004ae0:	fffff097          	auipc	ra,0xfffff
    80004ae4:	73c080e7          	jalr	1852(ra) # 8000421c <brelse>
}
    80004ae8:	01813083          	ld	ra,24(sp)
    80004aec:	01013403          	ld	s0,16(sp)
    80004af0:	00813483          	ld	s1,8(sp)
    80004af4:	00013903          	ld	s2,0(sp)
    80004af8:	02010113          	addi	sp,sp,32
    80004afc:	00008067          	ret

0000000080004b00 <idup>:
{
    80004b00:	fe010113          	addi	sp,sp,-32
    80004b04:	00113c23          	sd	ra,24(sp)
    80004b08:	00813823          	sd	s0,16(sp)
    80004b0c:	00913423          	sd	s1,8(sp)
    80004b10:	02010413          	addi	s0,sp,32
    80004b14:	00050493          	mv	s1,a0
  acquire(&itable.lock);
    80004b18:	0001c517          	auipc	a0,0x1c
    80004b1c:	5c850513          	addi	a0,a0,1480 # 800210e0 <itable>
    80004b20:	ffffc097          	auipc	ra,0xffffc
    80004b24:	4ac080e7          	jalr	1196(ra) # 80000fcc <acquire>
  ip->ref++;
    80004b28:	0084a783          	lw	a5,8(s1)
    80004b2c:	0017879b          	addiw	a5,a5,1
    80004b30:	00f4a423          	sw	a5,8(s1)
  release(&itable.lock);
    80004b34:	0001c517          	auipc	a0,0x1c
    80004b38:	5ac50513          	addi	a0,a0,1452 # 800210e0 <itable>
    80004b3c:	ffffc097          	auipc	ra,0xffffc
    80004b40:	588080e7          	jalr	1416(ra) # 800010c4 <release>
}
    80004b44:	00048513          	mv	a0,s1
    80004b48:	01813083          	ld	ra,24(sp)
    80004b4c:	01013403          	ld	s0,16(sp)
    80004b50:	00813483          	ld	s1,8(sp)
    80004b54:	02010113          	addi	sp,sp,32
    80004b58:	00008067          	ret

0000000080004b5c <ilock>:
{
    80004b5c:	fe010113          	addi	sp,sp,-32
    80004b60:	00113c23          	sd	ra,24(sp)
    80004b64:	00813823          	sd	s0,16(sp)
    80004b68:	00913423          	sd	s1,8(sp)
    80004b6c:	01213023          	sd	s2,0(sp)
    80004b70:	02010413          	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80004b74:	02050e63          	beqz	a0,80004bb0 <ilock+0x54>
    80004b78:	00050493          	mv	s1,a0
    80004b7c:	00852783          	lw	a5,8(a0)
    80004b80:	02f05863          	blez	a5,80004bb0 <ilock+0x54>
  acquiresleep(&ip->lock);
    80004b84:	01050513          	addi	a0,a0,16
    80004b88:	00001097          	auipc	ra,0x1
    80004b8c:	1a4080e7          	jalr	420(ra) # 80005d2c <acquiresleep>
  if(ip->valid == 0){
    80004b90:	0404a783          	lw	a5,64(s1)
    80004b94:	02078663          	beqz	a5,80004bc0 <ilock+0x64>
}
    80004b98:	01813083          	ld	ra,24(sp)
    80004b9c:	01013403          	ld	s0,16(sp)
    80004ba0:	00813483          	ld	s1,8(sp)
    80004ba4:	00013903          	ld	s2,0(sp)
    80004ba8:	02010113          	addi	sp,sp,32
    80004bac:	00008067          	ret
    panic("ilock");
    80004bb0:	00006517          	auipc	a0,0x6
    80004bb4:	a1850513          	addi	a0,a0,-1512 # 8000a5c8 <syscalls+0x180>
    80004bb8:	ffffc097          	auipc	ra,0xffffc
    80004bbc:	b14080e7          	jalr	-1260(ra) # 800006cc <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004bc0:	0044a783          	lw	a5,4(s1)
    80004bc4:	0047d79b          	srliw	a5,a5,0x4
    80004bc8:	0001c597          	auipc	a1,0x1c
    80004bcc:	5105a583          	lw	a1,1296(a1) # 800210d8 <sb+0x18>
    80004bd0:	00b785bb          	addw	a1,a5,a1
    80004bd4:	0004a503          	lw	a0,0(s1)
    80004bd8:	fffff097          	auipc	ra,0xfffff
    80004bdc:	4a8080e7          	jalr	1192(ra) # 80004080 <bread>
    80004be0:	00050913          	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004be4:	06050593          	addi	a1,a0,96
    80004be8:	0044a783          	lw	a5,4(s1)
    80004bec:	00f7f793          	andi	a5,a5,15
    80004bf0:	00679793          	slli	a5,a5,0x6
    80004bf4:	00f585b3          	add	a1,a1,a5
    ip->type = dip->type;
    80004bf8:	00059783          	lh	a5,0(a1)
    80004bfc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80004c00:	00259783          	lh	a5,2(a1)
    80004c04:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80004c08:	00459783          	lh	a5,4(a1)
    80004c0c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80004c10:	00659783          	lh	a5,6(a1)
    80004c14:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004c18:	0085a783          	lw	a5,8(a1)
    80004c1c:	04f4a623          	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004c20:	03400613          	li	a2,52
    80004c24:	00c58593          	addi	a1,a1,12
    80004c28:	05048513          	addi	a0,s1,80
    80004c2c:	ffffc097          	auipc	ra,0xffffc
    80004c30:	58c080e7          	jalr	1420(ra) # 800011b8 <memmove>
    brelse(bp);
    80004c34:	00090513          	mv	a0,s2
    80004c38:	fffff097          	auipc	ra,0xfffff
    80004c3c:	5e4080e7          	jalr	1508(ra) # 8000421c <brelse>
    ip->valid = 1;
    80004c40:	00100793          	li	a5,1
    80004c44:	04f4a023          	sw	a5,64(s1)
    if(ip->type == 0)
    80004c48:	04449783          	lh	a5,68(s1)
    80004c4c:	f40796e3          	bnez	a5,80004b98 <ilock+0x3c>
      panic("ilock: no type");
    80004c50:	00006517          	auipc	a0,0x6
    80004c54:	98050513          	addi	a0,a0,-1664 # 8000a5d0 <syscalls+0x188>
    80004c58:	ffffc097          	auipc	ra,0xffffc
    80004c5c:	a74080e7          	jalr	-1420(ra) # 800006cc <panic>

0000000080004c60 <iunlock>:
{
    80004c60:	fe010113          	addi	sp,sp,-32
    80004c64:	00113c23          	sd	ra,24(sp)
    80004c68:	00813823          	sd	s0,16(sp)
    80004c6c:	00913423          	sd	s1,8(sp)
    80004c70:	01213023          	sd	s2,0(sp)
    80004c74:	02010413          	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004c78:	04050463          	beqz	a0,80004cc0 <iunlock+0x60>
    80004c7c:	00050493          	mv	s1,a0
    80004c80:	01050913          	addi	s2,a0,16
    80004c84:	00090513          	mv	a0,s2
    80004c88:	00001097          	auipc	ra,0x1
    80004c8c:	190080e7          	jalr	400(ra) # 80005e18 <holdingsleep>
    80004c90:	02050863          	beqz	a0,80004cc0 <iunlock+0x60>
    80004c94:	0084a783          	lw	a5,8(s1)
    80004c98:	02f05463          	blez	a5,80004cc0 <iunlock+0x60>
  releasesleep(&ip->lock);
    80004c9c:	00090513          	mv	a0,s2
    80004ca0:	00001097          	auipc	ra,0x1
    80004ca4:	114080e7          	jalr	276(ra) # 80005db4 <releasesleep>
}
    80004ca8:	01813083          	ld	ra,24(sp)
    80004cac:	01013403          	ld	s0,16(sp)
    80004cb0:	00813483          	ld	s1,8(sp)
    80004cb4:	00013903          	ld	s2,0(sp)
    80004cb8:	02010113          	addi	sp,sp,32
    80004cbc:	00008067          	ret
    panic("iunlock");
    80004cc0:	00006517          	auipc	a0,0x6
    80004cc4:	92050513          	addi	a0,a0,-1760 # 8000a5e0 <syscalls+0x198>
    80004cc8:	ffffc097          	auipc	ra,0xffffc
    80004ccc:	a04080e7          	jalr	-1532(ra) # 800006cc <panic>

0000000080004cd0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004cd0:	fd010113          	addi	sp,sp,-48
    80004cd4:	02113423          	sd	ra,40(sp)
    80004cd8:	02813023          	sd	s0,32(sp)
    80004cdc:	00913c23          	sd	s1,24(sp)
    80004ce0:	01213823          	sd	s2,16(sp)
    80004ce4:	01313423          	sd	s3,8(sp)
    80004ce8:	01413023          	sd	s4,0(sp)
    80004cec:	03010413          	addi	s0,sp,48
    80004cf0:	00050993          	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004cf4:	05050493          	addi	s1,a0,80
    80004cf8:	08050913          	addi	s2,a0,128
    80004cfc:	00c0006f          	j	80004d08 <itrunc+0x38>
    80004d00:	00448493          	addi	s1,s1,4
    80004d04:	03248063          	beq	s1,s2,80004d24 <itrunc+0x54>
    if(ip->addrs[i]){
    80004d08:	0004a583          	lw	a1,0(s1)
    80004d0c:	fe058ae3          	beqz	a1,80004d00 <itrunc+0x30>
      bfree(ip->dev, ip->addrs[i]);
    80004d10:	0009a503          	lw	a0,0(s3)
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	690080e7          	jalr	1680(ra) # 800043a4 <bfree>
      ip->addrs[i] = 0;
    80004d1c:	0004a023          	sw	zero,0(s1)
    80004d20:	fe1ff06f          	j	80004d00 <itrunc+0x30>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004d24:	0809a583          	lw	a1,128(s3)
    80004d28:	02059a63          	bnez	a1,80004d5c <itrunc+0x8c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004d2c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004d30:	00098513          	mv	a0,s3
    80004d34:	00000097          	auipc	ra,0x0
    80004d38:	d0c080e7          	jalr	-756(ra) # 80004a40 <iupdate>
}
    80004d3c:	02813083          	ld	ra,40(sp)
    80004d40:	02013403          	ld	s0,32(sp)
    80004d44:	01813483          	ld	s1,24(sp)
    80004d48:	01013903          	ld	s2,16(sp)
    80004d4c:	00813983          	ld	s3,8(sp)
    80004d50:	00013a03          	ld	s4,0(sp)
    80004d54:	03010113          	addi	sp,sp,48
    80004d58:	00008067          	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004d5c:	0009a503          	lw	a0,0(s3)
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	320080e7          	jalr	800(ra) # 80004080 <bread>
    80004d68:	00050a13          	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004d6c:	06050493          	addi	s1,a0,96
    80004d70:	46050913          	addi	s2,a0,1120
    80004d74:	00c0006f          	j	80004d80 <itrunc+0xb0>
    80004d78:	00448493          	addi	s1,s1,4
    80004d7c:	01248e63          	beq	s1,s2,80004d98 <itrunc+0xc8>
      if(a[j])
    80004d80:	0004a583          	lw	a1,0(s1)
    80004d84:	fe058ae3          	beqz	a1,80004d78 <itrunc+0xa8>
        bfree(ip->dev, a[j]);
    80004d88:	0009a503          	lw	a0,0(s3)
    80004d8c:	fffff097          	auipc	ra,0xfffff
    80004d90:	618080e7          	jalr	1560(ra) # 800043a4 <bfree>
    80004d94:	fe5ff06f          	j	80004d78 <itrunc+0xa8>
    brelse(bp);
    80004d98:	000a0513          	mv	a0,s4
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	480080e7          	jalr	1152(ra) # 8000421c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004da4:	0809a583          	lw	a1,128(s3)
    80004da8:	0009a503          	lw	a0,0(s3)
    80004dac:	fffff097          	auipc	ra,0xfffff
    80004db0:	5f8080e7          	jalr	1528(ra) # 800043a4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004db4:	0809a023          	sw	zero,128(s3)
    80004db8:	f75ff06f          	j	80004d2c <itrunc+0x5c>

0000000080004dbc <iput>:
{
    80004dbc:	fe010113          	addi	sp,sp,-32
    80004dc0:	00113c23          	sd	ra,24(sp)
    80004dc4:	00813823          	sd	s0,16(sp)
    80004dc8:	00913423          	sd	s1,8(sp)
    80004dcc:	01213023          	sd	s2,0(sp)
    80004dd0:	02010413          	addi	s0,sp,32
    80004dd4:	00050493          	mv	s1,a0
  acquire(&itable.lock);
    80004dd8:	0001c517          	auipc	a0,0x1c
    80004ddc:	30850513          	addi	a0,a0,776 # 800210e0 <itable>
    80004de0:	ffffc097          	auipc	ra,0xffffc
    80004de4:	1ec080e7          	jalr	492(ra) # 80000fcc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004de8:	0084a703          	lw	a4,8(s1)
    80004dec:	00100793          	li	a5,1
    80004df0:	02f70c63          	beq	a4,a5,80004e28 <iput+0x6c>
  ip->ref--;
    80004df4:	0084a783          	lw	a5,8(s1)
    80004df8:	fff7879b          	addiw	a5,a5,-1
    80004dfc:	00f4a423          	sw	a5,8(s1)
  release(&itable.lock);
    80004e00:	0001c517          	auipc	a0,0x1c
    80004e04:	2e050513          	addi	a0,a0,736 # 800210e0 <itable>
    80004e08:	ffffc097          	auipc	ra,0xffffc
    80004e0c:	2bc080e7          	jalr	700(ra) # 800010c4 <release>
}
    80004e10:	01813083          	ld	ra,24(sp)
    80004e14:	01013403          	ld	s0,16(sp)
    80004e18:	00813483          	ld	s1,8(sp)
    80004e1c:	00013903          	ld	s2,0(sp)
    80004e20:	02010113          	addi	sp,sp,32
    80004e24:	00008067          	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004e28:	0404a783          	lw	a5,64(s1)
    80004e2c:	fc0784e3          	beqz	a5,80004df4 <iput+0x38>
    80004e30:	04a49783          	lh	a5,74(s1)
    80004e34:	fc0790e3          	bnez	a5,80004df4 <iput+0x38>
    acquiresleep(&ip->lock);
    80004e38:	01048913          	addi	s2,s1,16
    80004e3c:	00090513          	mv	a0,s2
    80004e40:	00001097          	auipc	ra,0x1
    80004e44:	eec080e7          	jalr	-276(ra) # 80005d2c <acquiresleep>
    release(&itable.lock);
    80004e48:	0001c517          	auipc	a0,0x1c
    80004e4c:	29850513          	addi	a0,a0,664 # 800210e0 <itable>
    80004e50:	ffffc097          	auipc	ra,0xffffc
    80004e54:	274080e7          	jalr	628(ra) # 800010c4 <release>
    itrunc(ip);
    80004e58:	00048513          	mv	a0,s1
    80004e5c:	00000097          	auipc	ra,0x0
    80004e60:	e74080e7          	jalr	-396(ra) # 80004cd0 <itrunc>
    ip->type = 0;
    80004e64:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004e68:	00048513          	mv	a0,s1
    80004e6c:	00000097          	auipc	ra,0x0
    80004e70:	bd4080e7          	jalr	-1068(ra) # 80004a40 <iupdate>
    ip->valid = 0;
    80004e74:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004e78:	00090513          	mv	a0,s2
    80004e7c:	00001097          	auipc	ra,0x1
    80004e80:	f38080e7          	jalr	-200(ra) # 80005db4 <releasesleep>
    acquire(&itable.lock);
    80004e84:	0001c517          	auipc	a0,0x1c
    80004e88:	25c50513          	addi	a0,a0,604 # 800210e0 <itable>
    80004e8c:	ffffc097          	auipc	ra,0xffffc
    80004e90:	140080e7          	jalr	320(ra) # 80000fcc <acquire>
    80004e94:	f61ff06f          	j	80004df4 <iput+0x38>

0000000080004e98 <iunlockput>:
{
    80004e98:	fe010113          	addi	sp,sp,-32
    80004e9c:	00113c23          	sd	ra,24(sp)
    80004ea0:	00813823          	sd	s0,16(sp)
    80004ea4:	00913423          	sd	s1,8(sp)
    80004ea8:	02010413          	addi	s0,sp,32
    80004eac:	00050493          	mv	s1,a0
  iunlock(ip);
    80004eb0:	00000097          	auipc	ra,0x0
    80004eb4:	db0080e7          	jalr	-592(ra) # 80004c60 <iunlock>
  iput(ip);
    80004eb8:	00048513          	mv	a0,s1
    80004ebc:	00000097          	auipc	ra,0x0
    80004ec0:	f00080e7          	jalr	-256(ra) # 80004dbc <iput>
}
    80004ec4:	01813083          	ld	ra,24(sp)
    80004ec8:	01013403          	ld	s0,16(sp)
    80004ecc:	00813483          	ld	s1,8(sp)
    80004ed0:	02010113          	addi	sp,sp,32
    80004ed4:	00008067          	ret

0000000080004ed8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004ed8:	ff010113          	addi	sp,sp,-16
    80004edc:	00813423          	sd	s0,8(sp)
    80004ee0:	01010413          	addi	s0,sp,16
  st->dev = ip->dev;
    80004ee4:	00052783          	lw	a5,0(a0)
    80004ee8:	00f5a023          	sw	a5,0(a1)
  st->ino = ip->inum;
    80004eec:	00452783          	lw	a5,4(a0)
    80004ef0:	00f5a223          	sw	a5,4(a1)
  st->type = ip->type;
    80004ef4:	04451783          	lh	a5,68(a0)
    80004ef8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004efc:	04a51783          	lh	a5,74(a0)
    80004f00:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004f04:	04c56783          	lwu	a5,76(a0)
    80004f08:	00f5b823          	sd	a5,16(a1)
}
    80004f0c:	00813403          	ld	s0,8(sp)
    80004f10:	01010113          	addi	sp,sp,16
    80004f14:	00008067          	ret

0000000080004f18 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004f18:	04c52783          	lw	a5,76(a0)
    80004f1c:	16d7e263          	bltu	a5,a3,80005080 <readi+0x168>
{
    80004f20:	f9010113          	addi	sp,sp,-112
    80004f24:	06113423          	sd	ra,104(sp)
    80004f28:	06813023          	sd	s0,96(sp)
    80004f2c:	04913c23          	sd	s1,88(sp)
    80004f30:	05213823          	sd	s2,80(sp)
    80004f34:	05313423          	sd	s3,72(sp)
    80004f38:	05413023          	sd	s4,64(sp)
    80004f3c:	03513c23          	sd	s5,56(sp)
    80004f40:	03613823          	sd	s6,48(sp)
    80004f44:	03713423          	sd	s7,40(sp)
    80004f48:	03813023          	sd	s8,32(sp)
    80004f4c:	01913c23          	sd	s9,24(sp)
    80004f50:	01a13823          	sd	s10,16(sp)
    80004f54:	01b13423          	sd	s11,8(sp)
    80004f58:	07010413          	addi	s0,sp,112
    80004f5c:	00050b93          	mv	s7,a0
    80004f60:	00058c13          	mv	s8,a1
    80004f64:	00060a93          	mv	s5,a2
    80004f68:	00068493          	mv	s1,a3
    80004f6c:	00070b13          	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004f70:	00e6873b          	addw	a4,a3,a4
    return 0;
    80004f74:	00000513          	li	a0,0
  if(off > ip->size || off + n < off)
    80004f78:	0cd76263          	bltu	a4,a3,8000503c <readi+0x124>
  if(off + n > ip->size)
    80004f7c:	00e7f463          	bgeu	a5,a4,80004f84 <readi+0x6c>
    n = ip->size - off;
    80004f80:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004f84:	0e0b0a63          	beqz	s6,80005078 <readi+0x160>
    80004f88:	00000993          	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004f8c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004f90:	fff00c93          	li	s9,-1
    80004f94:	0480006f          	j	80004fdc <readi+0xc4>
    80004f98:	020a1d93          	slli	s11,s4,0x20
    80004f9c:	020ddd93          	srli	s11,s11,0x20
    80004fa0:	06090793          	addi	a5,s2,96
    80004fa4:	000d8693          	mv	a3,s11
    80004fa8:	00c78633          	add	a2,a5,a2
    80004fac:	000a8593          	mv	a1,s5
    80004fb0:	000c0513          	mv	a0,s8
    80004fb4:	ffffe097          	auipc	ra,0xffffe
    80004fb8:	304080e7          	jalr	772(ra) # 800032b8 <either_copyout>
    80004fbc:	07950663          	beq	a0,s9,80005028 <readi+0x110>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004fc0:	00090513          	mv	a0,s2
    80004fc4:	fffff097          	auipc	ra,0xfffff
    80004fc8:	258080e7          	jalr	600(ra) # 8000421c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004fcc:	013a09bb          	addw	s3,s4,s3
    80004fd0:	009a04bb          	addw	s1,s4,s1
    80004fd4:	01ba8ab3          	add	s5,s5,s11
    80004fd8:	0769f063          	bgeu	s3,s6,80005038 <readi+0x120>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004fdc:	000ba903          	lw	s2,0(s7)
    80004fe0:	00a4d59b          	srliw	a1,s1,0xa
    80004fe4:	000b8513          	mv	a0,s7
    80004fe8:	fffff097          	auipc	ra,0xfffff
    80004fec:	604080e7          	jalr	1540(ra) # 800045ec <bmap>
    80004ff0:	0005059b          	sext.w	a1,a0
    80004ff4:	00090513          	mv	a0,s2
    80004ff8:	fffff097          	auipc	ra,0xfffff
    80004ffc:	088080e7          	jalr	136(ra) # 80004080 <bread>
    80005000:	00050913          	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80005004:	3ff4f613          	andi	a2,s1,1023
    80005008:	40cd07bb          	subw	a5,s10,a2
    8000500c:	413b073b          	subw	a4,s6,s3
    80005010:	00078a13          	mv	s4,a5
    80005014:	0007879b          	sext.w	a5,a5
    80005018:	0007069b          	sext.w	a3,a4
    8000501c:	f6f6fee3          	bgeu	a3,a5,80004f98 <readi+0x80>
    80005020:	00070a13          	mv	s4,a4
    80005024:	f75ff06f          	j	80004f98 <readi+0x80>
      brelse(bp);
    80005028:	00090513          	mv	a0,s2
    8000502c:	fffff097          	auipc	ra,0xfffff
    80005030:	1f0080e7          	jalr	496(ra) # 8000421c <brelse>
      tot = -1;
    80005034:	fff00993          	li	s3,-1
  }
  return tot;
    80005038:	0009851b          	sext.w	a0,s3
}
    8000503c:	06813083          	ld	ra,104(sp)
    80005040:	06013403          	ld	s0,96(sp)
    80005044:	05813483          	ld	s1,88(sp)
    80005048:	05013903          	ld	s2,80(sp)
    8000504c:	04813983          	ld	s3,72(sp)
    80005050:	04013a03          	ld	s4,64(sp)
    80005054:	03813a83          	ld	s5,56(sp)
    80005058:	03013b03          	ld	s6,48(sp)
    8000505c:	02813b83          	ld	s7,40(sp)
    80005060:	02013c03          	ld	s8,32(sp)
    80005064:	01813c83          	ld	s9,24(sp)
    80005068:	01013d03          	ld	s10,16(sp)
    8000506c:	00813d83          	ld	s11,8(sp)
    80005070:	07010113          	addi	sp,sp,112
    80005074:	00008067          	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80005078:	000b0993          	mv	s3,s6
    8000507c:	fbdff06f          	j	80005038 <readi+0x120>
    return 0;
    80005080:	00000513          	li	a0,0
}
    80005084:	00008067          	ret

0000000080005088 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80005088:	04c52783          	lw	a5,76(a0)
    8000508c:	18d7e063          	bltu	a5,a3,8000520c <writei+0x184>
{
    80005090:	f9010113          	addi	sp,sp,-112
    80005094:	06113423          	sd	ra,104(sp)
    80005098:	06813023          	sd	s0,96(sp)
    8000509c:	04913c23          	sd	s1,88(sp)
    800050a0:	05213823          	sd	s2,80(sp)
    800050a4:	05313423          	sd	s3,72(sp)
    800050a8:	05413023          	sd	s4,64(sp)
    800050ac:	03513c23          	sd	s5,56(sp)
    800050b0:	03613823          	sd	s6,48(sp)
    800050b4:	03713423          	sd	s7,40(sp)
    800050b8:	03813023          	sd	s8,32(sp)
    800050bc:	01913c23          	sd	s9,24(sp)
    800050c0:	01a13823          	sd	s10,16(sp)
    800050c4:	01b13423          	sd	s11,8(sp)
    800050c8:	07010413          	addi	s0,sp,112
    800050cc:	00050b13          	mv	s6,a0
    800050d0:	00058c13          	mv	s8,a1
    800050d4:	00060a93          	mv	s5,a2
    800050d8:	00068913          	mv	s2,a3
    800050dc:	00070b93          	mv	s7,a4
  if(off > ip->size || off + n < off)
    800050e0:	00e687bb          	addw	a5,a3,a4
    800050e4:	12d7e863          	bltu	a5,a3,80005214 <writei+0x18c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800050e8:	00043737          	lui	a4,0x43
    800050ec:	12f76863          	bltu	a4,a5,8000521c <writei+0x194>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800050f0:	100b8a63          	beqz	s7,80005204 <writei+0x17c>
    800050f4:	00000a13          	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800050f8:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800050fc:	fff00c93          	li	s9,-1
    80005100:	0540006f          	j	80005154 <writei+0xcc>
    80005104:	02099d93          	slli	s11,s3,0x20
    80005108:	020ddd93          	srli	s11,s11,0x20
    8000510c:	06048793          	addi	a5,s1,96
    80005110:	000d8693          	mv	a3,s11
    80005114:	000a8613          	mv	a2,s5
    80005118:	000c0593          	mv	a1,s8
    8000511c:	00a78533          	add	a0,a5,a0
    80005120:	ffffe097          	auipc	ra,0xffffe
    80005124:	228080e7          	jalr	552(ra) # 80003348 <either_copyin>
    80005128:	07950c63          	beq	a0,s9,800051a0 <writei+0x118>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000512c:	00048513          	mv	a0,s1
    80005130:	00001097          	auipc	ra,0x1
    80005134:	a78080e7          	jalr	-1416(ra) # 80005ba8 <log_write>
    brelse(bp);
    80005138:	00048513          	mv	a0,s1
    8000513c:	fffff097          	auipc	ra,0xfffff
    80005140:	0e0080e7          	jalr	224(ra) # 8000421c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80005144:	01498a3b          	addw	s4,s3,s4
    80005148:	0129893b          	addw	s2,s3,s2
    8000514c:	01ba8ab3          	add	s5,s5,s11
    80005150:	057a7e63          	bgeu	s4,s7,800051ac <writei+0x124>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80005154:	000b2483          	lw	s1,0(s6)
    80005158:	00a9559b          	srliw	a1,s2,0xa
    8000515c:	000b0513          	mv	a0,s6
    80005160:	fffff097          	auipc	ra,0xfffff
    80005164:	48c080e7          	jalr	1164(ra) # 800045ec <bmap>
    80005168:	0005059b          	sext.w	a1,a0
    8000516c:	00048513          	mv	a0,s1
    80005170:	fffff097          	auipc	ra,0xfffff
    80005174:	f10080e7          	jalr	-240(ra) # 80004080 <bread>
    80005178:	00050493          	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000517c:	3ff97513          	andi	a0,s2,1023
    80005180:	40ad07bb          	subw	a5,s10,a0
    80005184:	414b873b          	subw	a4,s7,s4
    80005188:	00078993          	mv	s3,a5
    8000518c:	0007879b          	sext.w	a5,a5
    80005190:	0007069b          	sext.w	a3,a4
    80005194:	f6f6f8e3          	bgeu	a3,a5,80005104 <writei+0x7c>
    80005198:	00070993          	mv	s3,a4
    8000519c:	f69ff06f          	j	80005104 <writei+0x7c>
      brelse(bp);
    800051a0:	00048513          	mv	a0,s1
    800051a4:	fffff097          	auipc	ra,0xfffff
    800051a8:	078080e7          	jalr	120(ra) # 8000421c <brelse>
  }

  if(off > ip->size)
    800051ac:	04cb2783          	lw	a5,76(s6)
    800051b0:	0127f463          	bgeu	a5,s2,800051b8 <writei+0x130>
    ip->size = off;
    800051b4:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800051b8:	000b0513          	mv	a0,s6
    800051bc:	00000097          	auipc	ra,0x0
    800051c0:	884080e7          	jalr	-1916(ra) # 80004a40 <iupdate>

  return tot;
    800051c4:	000a051b          	sext.w	a0,s4
}
    800051c8:	06813083          	ld	ra,104(sp)
    800051cc:	06013403          	ld	s0,96(sp)
    800051d0:	05813483          	ld	s1,88(sp)
    800051d4:	05013903          	ld	s2,80(sp)
    800051d8:	04813983          	ld	s3,72(sp)
    800051dc:	04013a03          	ld	s4,64(sp)
    800051e0:	03813a83          	ld	s5,56(sp)
    800051e4:	03013b03          	ld	s6,48(sp)
    800051e8:	02813b83          	ld	s7,40(sp)
    800051ec:	02013c03          	ld	s8,32(sp)
    800051f0:	01813c83          	ld	s9,24(sp)
    800051f4:	01013d03          	ld	s10,16(sp)
    800051f8:	00813d83          	ld	s11,8(sp)
    800051fc:	07010113          	addi	sp,sp,112
    80005200:	00008067          	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80005204:	000b8a13          	mv	s4,s7
    80005208:	fb1ff06f          	j	800051b8 <writei+0x130>
    return -1;
    8000520c:	fff00513          	li	a0,-1
}
    80005210:	00008067          	ret
    return -1;
    80005214:	fff00513          	li	a0,-1
    80005218:	fb1ff06f          	j	800051c8 <writei+0x140>
    return -1;
    8000521c:	fff00513          	li	a0,-1
    80005220:	fa9ff06f          	j	800051c8 <writei+0x140>

0000000080005224 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80005224:	ff010113          	addi	sp,sp,-16
    80005228:	00113423          	sd	ra,8(sp)
    8000522c:	00813023          	sd	s0,0(sp)
    80005230:	01010413          	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80005234:	00e00613          	li	a2,14
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	02c080e7          	jalr	44(ra) # 80001264 <strncmp>
}
    80005240:	00813083          	ld	ra,8(sp)
    80005244:	00013403          	ld	s0,0(sp)
    80005248:	01010113          	addi	sp,sp,16
    8000524c:	00008067          	ret

0000000080005250 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80005250:	fc010113          	addi	sp,sp,-64
    80005254:	02113c23          	sd	ra,56(sp)
    80005258:	02813823          	sd	s0,48(sp)
    8000525c:	02913423          	sd	s1,40(sp)
    80005260:	03213023          	sd	s2,32(sp)
    80005264:	01313c23          	sd	s3,24(sp)
    80005268:	01413823          	sd	s4,16(sp)
    8000526c:	04010413          	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80005270:	04451703          	lh	a4,68(a0)
    80005274:	00100793          	li	a5,1
    80005278:	02f71263          	bne	a4,a5,8000529c <dirlookup+0x4c>
    8000527c:	00050913          	mv	s2,a0
    80005280:	00058993          	mv	s3,a1
    80005284:	00060a13          	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80005288:	04c52783          	lw	a5,76(a0)
    8000528c:	00000493          	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80005290:	00000513          	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005294:	02079a63          	bnez	a5,800052c8 <dirlookup+0x78>
    80005298:	0900006f          	j	80005328 <dirlookup+0xd8>
    panic("dirlookup not DIR");
    8000529c:	00005517          	auipc	a0,0x5
    800052a0:	34c50513          	addi	a0,a0,844 # 8000a5e8 <syscalls+0x1a0>
    800052a4:	ffffb097          	auipc	ra,0xffffb
    800052a8:	428080e7          	jalr	1064(ra) # 800006cc <panic>
      panic("dirlookup read");
    800052ac:	00005517          	auipc	a0,0x5
    800052b0:	35450513          	addi	a0,a0,852 # 8000a600 <syscalls+0x1b8>
    800052b4:	ffffb097          	auipc	ra,0xffffb
    800052b8:	418080e7          	jalr	1048(ra) # 800006cc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800052bc:	0104849b          	addiw	s1,s1,16
    800052c0:	04c92783          	lw	a5,76(s2)
    800052c4:	06f4f063          	bgeu	s1,a5,80005324 <dirlookup+0xd4>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800052c8:	01000713          	li	a4,16
    800052cc:	00048693          	mv	a3,s1
    800052d0:	fc040613          	addi	a2,s0,-64
    800052d4:	00000593          	li	a1,0
    800052d8:	00090513          	mv	a0,s2
    800052dc:	00000097          	auipc	ra,0x0
    800052e0:	c3c080e7          	jalr	-964(ra) # 80004f18 <readi>
    800052e4:	01000793          	li	a5,16
    800052e8:	fcf512e3          	bne	a0,a5,800052ac <dirlookup+0x5c>
    if(de.inum == 0)
    800052ec:	fc045783          	lhu	a5,-64(s0)
    800052f0:	fc0786e3          	beqz	a5,800052bc <dirlookup+0x6c>
    if(namecmp(name, de.name) == 0){
    800052f4:	fc240593          	addi	a1,s0,-62
    800052f8:	00098513          	mv	a0,s3
    800052fc:	00000097          	auipc	ra,0x0
    80005300:	f28080e7          	jalr	-216(ra) # 80005224 <namecmp>
    80005304:	fa051ce3          	bnez	a0,800052bc <dirlookup+0x6c>
      if(poff)
    80005308:	000a0463          	beqz	s4,80005310 <dirlookup+0xc0>
        *poff = off;
    8000530c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80005310:	fc045583          	lhu	a1,-64(s0)
    80005314:	00092503          	lw	a0,0(s2)
    80005318:	fffff097          	auipc	ra,0xfffff
    8000531c:	3e8080e7          	jalr	1000(ra) # 80004700 <iget>
    80005320:	0080006f          	j	80005328 <dirlookup+0xd8>
  return 0;
    80005324:	00000513          	li	a0,0
}
    80005328:	03813083          	ld	ra,56(sp)
    8000532c:	03013403          	ld	s0,48(sp)
    80005330:	02813483          	ld	s1,40(sp)
    80005334:	02013903          	ld	s2,32(sp)
    80005338:	01813983          	ld	s3,24(sp)
    8000533c:	01013a03          	ld	s4,16(sp)
    80005340:	04010113          	addi	sp,sp,64
    80005344:	00008067          	ret

0000000080005348 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80005348:	fa010113          	addi	sp,sp,-96
    8000534c:	04113c23          	sd	ra,88(sp)
    80005350:	04813823          	sd	s0,80(sp)
    80005354:	04913423          	sd	s1,72(sp)
    80005358:	05213023          	sd	s2,64(sp)
    8000535c:	03313c23          	sd	s3,56(sp)
    80005360:	03413823          	sd	s4,48(sp)
    80005364:	03513423          	sd	s5,40(sp)
    80005368:	03613023          	sd	s6,32(sp)
    8000536c:	01713c23          	sd	s7,24(sp)
    80005370:	01813823          	sd	s8,16(sp)
    80005374:	01913423          	sd	s9,8(sp)
    80005378:	06010413          	addi	s0,sp,96
    8000537c:	00050493          	mv	s1,a0
    80005380:	00058a93          	mv	s5,a1
    80005384:	00060a13          	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80005388:	00054703          	lbu	a4,0(a0)
    8000538c:	02f00793          	li	a5,47
    80005390:	02f70863          	beq	a4,a5,800053c0 <namex+0x78>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80005394:	ffffd097          	auipc	ra,0xffffd
    80005398:	0bc080e7          	jalr	188(ra) # 80002450 <myproc>
    8000539c:	15053503          	ld	a0,336(a0)
    800053a0:	fffff097          	auipc	ra,0xfffff
    800053a4:	760080e7          	jalr	1888(ra) # 80004b00 <idup>
    800053a8:	00050993          	mv	s3,a0
  while(*path == '/')
    800053ac:	02f00913          	li	s2,47
  len = path - s;
    800053b0:	00000b13          	li	s6,0
  if(len >= DIRSIZ)
    800053b4:	00d00c13          	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800053b8:	00100b93          	li	s7,1
    800053bc:	1040006f          	j	800054c0 <namex+0x178>
    ip = iget(ROOTDEV, ROOTINO);
    800053c0:	00100593          	li	a1,1
    800053c4:	00100513          	li	a0,1
    800053c8:	fffff097          	auipc	ra,0xfffff
    800053cc:	338080e7          	jalr	824(ra) # 80004700 <iget>
    800053d0:	00050993          	mv	s3,a0
    800053d4:	fd9ff06f          	j	800053ac <namex+0x64>
      iunlockput(ip);
    800053d8:	00098513          	mv	a0,s3
    800053dc:	00000097          	auipc	ra,0x0
    800053e0:	abc080e7          	jalr	-1348(ra) # 80004e98 <iunlockput>
      return 0;
    800053e4:	00000993          	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800053e8:	00098513          	mv	a0,s3
    800053ec:	05813083          	ld	ra,88(sp)
    800053f0:	05013403          	ld	s0,80(sp)
    800053f4:	04813483          	ld	s1,72(sp)
    800053f8:	04013903          	ld	s2,64(sp)
    800053fc:	03813983          	ld	s3,56(sp)
    80005400:	03013a03          	ld	s4,48(sp)
    80005404:	02813a83          	ld	s5,40(sp)
    80005408:	02013b03          	ld	s6,32(sp)
    8000540c:	01813b83          	ld	s7,24(sp)
    80005410:	01013c03          	ld	s8,16(sp)
    80005414:	00813c83          	ld	s9,8(sp)
    80005418:	06010113          	addi	sp,sp,96
    8000541c:	00008067          	ret
      iunlock(ip);
    80005420:	00098513          	mv	a0,s3
    80005424:	00000097          	auipc	ra,0x0
    80005428:	83c080e7          	jalr	-1988(ra) # 80004c60 <iunlock>
      return ip;
    8000542c:	fbdff06f          	j	800053e8 <namex+0xa0>
      iunlockput(ip);
    80005430:	00098513          	mv	a0,s3
    80005434:	00000097          	auipc	ra,0x0
    80005438:	a64080e7          	jalr	-1436(ra) # 80004e98 <iunlockput>
      return 0;
    8000543c:	000c8993          	mv	s3,s9
    80005440:	fa9ff06f          	j	800053e8 <namex+0xa0>
  len = path - s;
    80005444:	40b48633          	sub	a2,s1,a1
    80005448:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000544c:	0b9c5863          	bge	s8,s9,800054fc <namex+0x1b4>
    memmove(name, s, DIRSIZ);
    80005450:	00e00613          	li	a2,14
    80005454:	000a0513          	mv	a0,s4
    80005458:	ffffc097          	auipc	ra,0xffffc
    8000545c:	d60080e7          	jalr	-672(ra) # 800011b8 <memmove>
  while(*path == '/')
    80005460:	0004c783          	lbu	a5,0(s1)
    80005464:	01279863          	bne	a5,s2,80005474 <namex+0x12c>
    path++;
    80005468:	00148493          	addi	s1,s1,1
  while(*path == '/')
    8000546c:	0004c783          	lbu	a5,0(s1)
    80005470:	ff278ce3          	beq	a5,s2,80005468 <namex+0x120>
    ilock(ip);
    80005474:	00098513          	mv	a0,s3
    80005478:	fffff097          	auipc	ra,0xfffff
    8000547c:	6e4080e7          	jalr	1764(ra) # 80004b5c <ilock>
    if(ip->type != T_DIR){
    80005480:	04499783          	lh	a5,68(s3)
    80005484:	f5779ae3          	bne	a5,s7,800053d8 <namex+0x90>
    if(nameiparent && *path == '\0'){
    80005488:	000a8663          	beqz	s5,80005494 <namex+0x14c>
    8000548c:	0004c783          	lbu	a5,0(s1)
    80005490:	f80788e3          	beqz	a5,80005420 <namex+0xd8>
    if((next = dirlookup(ip, name, 0)) == 0){
    80005494:	000b0613          	mv	a2,s6
    80005498:	000a0593          	mv	a1,s4
    8000549c:	00098513          	mv	a0,s3
    800054a0:	00000097          	auipc	ra,0x0
    800054a4:	db0080e7          	jalr	-592(ra) # 80005250 <dirlookup>
    800054a8:	00050c93          	mv	s9,a0
    800054ac:	f80502e3          	beqz	a0,80005430 <namex+0xe8>
    iunlockput(ip);
    800054b0:	00098513          	mv	a0,s3
    800054b4:	00000097          	auipc	ra,0x0
    800054b8:	9e4080e7          	jalr	-1564(ra) # 80004e98 <iunlockput>
    ip = next;
    800054bc:	000c8993          	mv	s3,s9
  while(*path == '/')
    800054c0:	0004c783          	lbu	a5,0(s1)
    800054c4:	07279663          	bne	a5,s2,80005530 <namex+0x1e8>
    path++;
    800054c8:	00148493          	addi	s1,s1,1
  while(*path == '/')
    800054cc:	0004c783          	lbu	a5,0(s1)
    800054d0:	ff278ce3          	beq	a5,s2,800054c8 <namex+0x180>
  if(*path == 0)
    800054d4:	04078263          	beqz	a5,80005518 <namex+0x1d0>
    path++;
    800054d8:	00048593          	mv	a1,s1
  len = path - s;
    800054dc:	000b0c93          	mv	s9,s6
    800054e0:	000b0613          	mv	a2,s6
  while(*path != '/' && *path != 0)
    800054e4:	01278c63          	beq	a5,s2,800054fc <namex+0x1b4>
    800054e8:	f4078ee3          	beqz	a5,80005444 <namex+0xfc>
    path++;
    800054ec:	00148493          	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800054f0:	0004c783          	lbu	a5,0(s1)
    800054f4:	ff279ae3          	bne	a5,s2,800054e8 <namex+0x1a0>
    800054f8:	f4dff06f          	j	80005444 <namex+0xfc>
    memmove(name, s, len);
    800054fc:	0006061b          	sext.w	a2,a2
    80005500:	000a0513          	mv	a0,s4
    80005504:	ffffc097          	auipc	ra,0xffffc
    80005508:	cb4080e7          	jalr	-844(ra) # 800011b8 <memmove>
    name[len] = 0;
    8000550c:	019a0cb3          	add	s9,s4,s9
    80005510:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80005514:	f4dff06f          	j	80005460 <namex+0x118>
  if(nameiparent){
    80005518:	ec0a88e3          	beqz	s5,800053e8 <namex+0xa0>
    iput(ip);
    8000551c:	00098513          	mv	a0,s3
    80005520:	00000097          	auipc	ra,0x0
    80005524:	89c080e7          	jalr	-1892(ra) # 80004dbc <iput>
    return 0;
    80005528:	00000993          	li	s3,0
    8000552c:	ebdff06f          	j	800053e8 <namex+0xa0>
  if(*path == 0)
    80005530:	fe0784e3          	beqz	a5,80005518 <namex+0x1d0>
  while(*path != '/' && *path != 0)
    80005534:	0004c783          	lbu	a5,0(s1)
    80005538:	00048593          	mv	a1,s1
    8000553c:	fadff06f          	j	800054e8 <namex+0x1a0>

0000000080005540 <dirlink>:
{
    80005540:	fc010113          	addi	sp,sp,-64
    80005544:	02113c23          	sd	ra,56(sp)
    80005548:	02813823          	sd	s0,48(sp)
    8000554c:	02913423          	sd	s1,40(sp)
    80005550:	03213023          	sd	s2,32(sp)
    80005554:	01313c23          	sd	s3,24(sp)
    80005558:	01413823          	sd	s4,16(sp)
    8000555c:	04010413          	addi	s0,sp,64
    80005560:	00050913          	mv	s2,a0
    80005564:	00058a13          	mv	s4,a1
    80005568:	00060993          	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000556c:	00000613          	li	a2,0
    80005570:	00000097          	auipc	ra,0x0
    80005574:	ce0080e7          	jalr	-800(ra) # 80005250 <dirlookup>
    80005578:	0a051663          	bnez	a0,80005624 <dirlink+0xe4>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000557c:	04c92483          	lw	s1,76(s2)
    80005580:	04048063          	beqz	s1,800055c0 <dirlink+0x80>
    80005584:	00000493          	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005588:	01000713          	li	a4,16
    8000558c:	00048693          	mv	a3,s1
    80005590:	fc040613          	addi	a2,s0,-64
    80005594:	00000593          	li	a1,0
    80005598:	00090513          	mv	a0,s2
    8000559c:	00000097          	auipc	ra,0x0
    800055a0:	97c080e7          	jalr	-1668(ra) # 80004f18 <readi>
    800055a4:	01000793          	li	a5,16
    800055a8:	08f51663          	bne	a0,a5,80005634 <dirlink+0xf4>
    if(de.inum == 0)
    800055ac:	fc045783          	lhu	a5,-64(s0)
    800055b0:	00078863          	beqz	a5,800055c0 <dirlink+0x80>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800055b4:	0104849b          	addiw	s1,s1,16
    800055b8:	04c92783          	lw	a5,76(s2)
    800055bc:	fcf4e6e3          	bltu	s1,a5,80005588 <dirlink+0x48>
  strncpy(de.name, name, DIRSIZ);
    800055c0:	00e00613          	li	a2,14
    800055c4:	000a0593          	mv	a1,s4
    800055c8:	fc240513          	addi	a0,s0,-62
    800055cc:	ffffc097          	auipc	ra,0xffffc
    800055d0:	cfc080e7          	jalr	-772(ra) # 800012c8 <strncpy>
  de.inum = inum;
    800055d4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055d8:	01000713          	li	a4,16
    800055dc:	00048693          	mv	a3,s1
    800055e0:	fc040613          	addi	a2,s0,-64
    800055e4:	00000593          	li	a1,0
    800055e8:	00090513          	mv	a0,s2
    800055ec:	00000097          	auipc	ra,0x0
    800055f0:	a9c080e7          	jalr	-1380(ra) # 80005088 <writei>
    800055f4:	00050713          	mv	a4,a0
    800055f8:	01000793          	li	a5,16
  return 0;
    800055fc:	00000513          	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005600:	04f71263          	bne	a4,a5,80005644 <dirlink+0x104>
}
    80005604:	03813083          	ld	ra,56(sp)
    80005608:	03013403          	ld	s0,48(sp)
    8000560c:	02813483          	ld	s1,40(sp)
    80005610:	02013903          	ld	s2,32(sp)
    80005614:	01813983          	ld	s3,24(sp)
    80005618:	01013a03          	ld	s4,16(sp)
    8000561c:	04010113          	addi	sp,sp,64
    80005620:	00008067          	ret
    iput(ip);
    80005624:	fffff097          	auipc	ra,0xfffff
    80005628:	798080e7          	jalr	1944(ra) # 80004dbc <iput>
    return -1;
    8000562c:	fff00513          	li	a0,-1
    80005630:	fd5ff06f          	j	80005604 <dirlink+0xc4>
      panic("dirlink read");
    80005634:	00005517          	auipc	a0,0x5
    80005638:	fdc50513          	addi	a0,a0,-36 # 8000a610 <syscalls+0x1c8>
    8000563c:	ffffb097          	auipc	ra,0xffffb
    80005640:	090080e7          	jalr	144(ra) # 800006cc <panic>
    panic("dirlink");
    80005644:	00005517          	auipc	a0,0x5
    80005648:	13c50513          	addi	a0,a0,316 # 8000a780 <syscalls+0x338>
    8000564c:	ffffb097          	auipc	ra,0xffffb
    80005650:	080080e7          	jalr	128(ra) # 800006cc <panic>

0000000080005654 <namei>:

struct inode*
namei(char *path)
{
    80005654:	fe010113          	addi	sp,sp,-32
    80005658:	00113c23          	sd	ra,24(sp)
    8000565c:	00813823          	sd	s0,16(sp)
    80005660:	02010413          	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80005664:	fe040613          	addi	a2,s0,-32
    80005668:	00000593          	li	a1,0
    8000566c:	00000097          	auipc	ra,0x0
    80005670:	cdc080e7          	jalr	-804(ra) # 80005348 <namex>
}
    80005674:	01813083          	ld	ra,24(sp)
    80005678:	01013403          	ld	s0,16(sp)
    8000567c:	02010113          	addi	sp,sp,32
    80005680:	00008067          	ret

0000000080005684 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80005684:	ff010113          	addi	sp,sp,-16
    80005688:	00113423          	sd	ra,8(sp)
    8000568c:	00813023          	sd	s0,0(sp)
    80005690:	01010413          	addi	s0,sp,16
    80005694:	00058613          	mv	a2,a1
  return namex(path, 1, name);
    80005698:	00100593          	li	a1,1
    8000569c:	00000097          	auipc	ra,0x0
    800056a0:	cac080e7          	jalr	-852(ra) # 80005348 <namex>
}
    800056a4:	00813083          	ld	ra,8(sp)
    800056a8:	00013403          	ld	s0,0(sp)
    800056ac:	01010113          	addi	sp,sp,16
    800056b0:	00008067          	ret

00000000800056b4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800056b4:	fe010113          	addi	sp,sp,-32
    800056b8:	00113c23          	sd	ra,24(sp)
    800056bc:	00813823          	sd	s0,16(sp)
    800056c0:	00913423          	sd	s1,8(sp)
    800056c4:	01213023          	sd	s2,0(sp)
    800056c8:	02010413          	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800056cc:	0001d917          	auipc	s2,0x1d
    800056d0:	4bc90913          	addi	s2,s2,1212 # 80022b88 <log>
    800056d4:	01892583          	lw	a1,24(s2)
    800056d8:	02892503          	lw	a0,40(s2)
    800056dc:	fffff097          	auipc	ra,0xfffff
    800056e0:	9a4080e7          	jalr	-1628(ra) # 80004080 <bread>
    800056e4:	00050493          	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800056e8:	02c92683          	lw	a3,44(s2)
    800056ec:	06d52023          	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    800056f0:	02d05e63          	blez	a3,8000572c <write_head+0x78>
    800056f4:	0001d797          	auipc	a5,0x1d
    800056f8:	4c478793          	addi	a5,a5,1220 # 80022bb8 <log+0x30>
    800056fc:	06450713          	addi	a4,a0,100
    80005700:	fff6869b          	addiw	a3,a3,-1
    80005704:	02069613          	slli	a2,a3,0x20
    80005708:	01e65693          	srli	a3,a2,0x1e
    8000570c:	0001d617          	auipc	a2,0x1d
    80005710:	4b060613          	addi	a2,a2,1200 # 80022bbc <log+0x34>
    80005714:	00c686b3          	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80005718:	0007a603          	lw	a2,0(a5)
    8000571c:	00c72023          	sw	a2,0(a4) # 43000 <_entry-0x7ffbd000>
  for (i = 0; i < log.lh.n; i++) {
    80005720:	00478793          	addi	a5,a5,4
    80005724:	00470713          	addi	a4,a4,4
    80005728:	fed798e3          	bne	a5,a3,80005718 <write_head+0x64>
  }
  bwrite(buf);
    8000572c:	00048513          	mv	a0,s1
    80005730:	fffff097          	auipc	ra,0xfffff
    80005734:	a88080e7          	jalr	-1400(ra) # 800041b8 <bwrite>
  brelse(buf);
    80005738:	00048513          	mv	a0,s1
    8000573c:	fffff097          	auipc	ra,0xfffff
    80005740:	ae0080e7          	jalr	-1312(ra) # 8000421c <brelse>
}
    80005744:	01813083          	ld	ra,24(sp)
    80005748:	01013403          	ld	s0,16(sp)
    8000574c:	00813483          	ld	s1,8(sp)
    80005750:	00013903          	ld	s2,0(sp)
    80005754:	02010113          	addi	sp,sp,32
    80005758:	00008067          	ret

000000008000575c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000575c:	0001d797          	auipc	a5,0x1d
    80005760:	4587a783          	lw	a5,1112(a5) # 80022bb4 <log+0x2c>
    80005764:	0ef05e63          	blez	a5,80005860 <install_trans+0x104>
{
    80005768:	fc010113          	addi	sp,sp,-64
    8000576c:	02113c23          	sd	ra,56(sp)
    80005770:	02813823          	sd	s0,48(sp)
    80005774:	02913423          	sd	s1,40(sp)
    80005778:	03213023          	sd	s2,32(sp)
    8000577c:	01313c23          	sd	s3,24(sp)
    80005780:	01413823          	sd	s4,16(sp)
    80005784:	01513423          	sd	s5,8(sp)
    80005788:	01613023          	sd	s6,0(sp)
    8000578c:	04010413          	addi	s0,sp,64
    80005790:	00050b13          	mv	s6,a0
    80005794:	0001da97          	auipc	s5,0x1d
    80005798:	424a8a93          	addi	s5,s5,1060 # 80022bb8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000579c:	00000a13          	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800057a0:	0001d997          	auipc	s3,0x1d
    800057a4:	3e898993          	addi	s3,s3,1000 # 80022b88 <log>
    800057a8:	02c0006f          	j	800057d4 <install_trans+0x78>
    brelse(lbuf);
    800057ac:	00090513          	mv	a0,s2
    800057b0:	fffff097          	auipc	ra,0xfffff
    800057b4:	a6c080e7          	jalr	-1428(ra) # 8000421c <brelse>
    brelse(dbuf);
    800057b8:	00048513          	mv	a0,s1
    800057bc:	fffff097          	auipc	ra,0xfffff
    800057c0:	a60080e7          	jalr	-1440(ra) # 8000421c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800057c4:	001a0a1b          	addiw	s4,s4,1
    800057c8:	004a8a93          	addi	s5,s5,4
    800057cc:	02c9a783          	lw	a5,44(s3)
    800057d0:	06fa5463          	bge	s4,a5,80005838 <install_trans+0xdc>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800057d4:	0189a583          	lw	a1,24(s3)
    800057d8:	014585bb          	addw	a1,a1,s4
    800057dc:	0015859b          	addiw	a1,a1,1
    800057e0:	0289a503          	lw	a0,40(s3)
    800057e4:	fffff097          	auipc	ra,0xfffff
    800057e8:	89c080e7          	jalr	-1892(ra) # 80004080 <bread>
    800057ec:	00050913          	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800057f0:	000aa583          	lw	a1,0(s5)
    800057f4:	0289a503          	lw	a0,40(s3)
    800057f8:	fffff097          	auipc	ra,0xfffff
    800057fc:	888080e7          	jalr	-1912(ra) # 80004080 <bread>
    80005800:	00050493          	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80005804:	40000613          	li	a2,1024
    80005808:	06090593          	addi	a1,s2,96
    8000580c:	06050513          	addi	a0,a0,96
    80005810:	ffffc097          	auipc	ra,0xffffc
    80005814:	9a8080e7          	jalr	-1624(ra) # 800011b8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80005818:	00048513          	mv	a0,s1
    8000581c:	fffff097          	auipc	ra,0xfffff
    80005820:	99c080e7          	jalr	-1636(ra) # 800041b8 <bwrite>
    if(recovering == 0)
    80005824:	f80b14e3          	bnez	s6,800057ac <install_trans+0x50>
      bunpin(dbuf);
    80005828:	00048513          	mv	a0,s1
    8000582c:	fffff097          	auipc	ra,0xfffff
    80005830:	b20080e7          	jalr	-1248(ra) # 8000434c <bunpin>
    80005834:	f79ff06f          	j	800057ac <install_trans+0x50>
}
    80005838:	03813083          	ld	ra,56(sp)
    8000583c:	03013403          	ld	s0,48(sp)
    80005840:	02813483          	ld	s1,40(sp)
    80005844:	02013903          	ld	s2,32(sp)
    80005848:	01813983          	ld	s3,24(sp)
    8000584c:	01013a03          	ld	s4,16(sp)
    80005850:	00813a83          	ld	s5,8(sp)
    80005854:	00013b03          	ld	s6,0(sp)
    80005858:	04010113          	addi	sp,sp,64
    8000585c:	00008067          	ret
    80005860:	00008067          	ret

0000000080005864 <initlog>:
{
    80005864:	fd010113          	addi	sp,sp,-48
    80005868:	02113423          	sd	ra,40(sp)
    8000586c:	02813023          	sd	s0,32(sp)
    80005870:	00913c23          	sd	s1,24(sp)
    80005874:	01213823          	sd	s2,16(sp)
    80005878:	01313423          	sd	s3,8(sp)
    8000587c:	03010413          	addi	s0,sp,48
    80005880:	00050913          	mv	s2,a0
    80005884:	00058993          	mv	s3,a1
  initlock(&log.lock, "log");
    80005888:	0001d497          	auipc	s1,0x1d
    8000588c:	30048493          	addi	s1,s1,768 # 80022b88 <log>
    80005890:	00005597          	auipc	a1,0x5
    80005894:	d9058593          	addi	a1,a1,-624 # 8000a620 <syscalls+0x1d8>
    80005898:	00048513          	mv	a0,s1
    8000589c:	ffffb097          	auipc	ra,0xffffb
    800058a0:	64c080e7          	jalr	1612(ra) # 80000ee8 <initlock>
  log.start = sb->logstart;
    800058a4:	0149a583          	lw	a1,20(s3)
    800058a8:	00b4ac23          	sw	a1,24(s1)
  log.size = sb->nlog;
    800058ac:	0109a783          	lw	a5,16(s3)
    800058b0:	00f4ae23          	sw	a5,28(s1)
  log.dev = dev;
    800058b4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800058b8:	00090513          	mv	a0,s2
    800058bc:	ffffe097          	auipc	ra,0xffffe
    800058c0:	7c4080e7          	jalr	1988(ra) # 80004080 <bread>
  log.lh.n = lh->n;
    800058c4:	06052683          	lw	a3,96(a0)
    800058c8:	02d4a623          	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800058cc:	02d05c63          	blez	a3,80005904 <initlog+0xa0>
    800058d0:	06450793          	addi	a5,a0,100
    800058d4:	0001d717          	auipc	a4,0x1d
    800058d8:	2e470713          	addi	a4,a4,740 # 80022bb8 <log+0x30>
    800058dc:	fff6869b          	addiw	a3,a3,-1
    800058e0:	02069613          	slli	a2,a3,0x20
    800058e4:	01e65693          	srli	a3,a2,0x1e
    800058e8:	06850613          	addi	a2,a0,104
    800058ec:	00c686b3          	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800058f0:	0007a603          	lw	a2,0(a5)
    800058f4:	00c72023          	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800058f8:	00478793          	addi	a5,a5,4
    800058fc:	00470713          	addi	a4,a4,4
    80005900:	fed798e3          	bne	a5,a3,800058f0 <initlog+0x8c>
  brelse(buf);
    80005904:	fffff097          	auipc	ra,0xfffff
    80005908:	918080e7          	jalr	-1768(ra) # 8000421c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000590c:	00100513          	li	a0,1
    80005910:	00000097          	auipc	ra,0x0
    80005914:	e4c080e7          	jalr	-436(ra) # 8000575c <install_trans>
  log.lh.n = 0;
    80005918:	0001d797          	auipc	a5,0x1d
    8000591c:	2807ae23          	sw	zero,668(a5) # 80022bb4 <log+0x2c>
  write_head(); // clear the log
    80005920:	00000097          	auipc	ra,0x0
    80005924:	d94080e7          	jalr	-620(ra) # 800056b4 <write_head>
}
    80005928:	02813083          	ld	ra,40(sp)
    8000592c:	02013403          	ld	s0,32(sp)
    80005930:	01813483          	ld	s1,24(sp)
    80005934:	01013903          	ld	s2,16(sp)
    80005938:	00813983          	ld	s3,8(sp)
    8000593c:	03010113          	addi	sp,sp,48
    80005940:	00008067          	ret

0000000080005944 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80005944:	fe010113          	addi	sp,sp,-32
    80005948:	00113c23          	sd	ra,24(sp)
    8000594c:	00813823          	sd	s0,16(sp)
    80005950:	00913423          	sd	s1,8(sp)
    80005954:	01213023          	sd	s2,0(sp)
    80005958:	02010413          	addi	s0,sp,32
  acquire(&log.lock);
    8000595c:	0001d517          	auipc	a0,0x1d
    80005960:	22c50513          	addi	a0,a0,556 # 80022b88 <log>
    80005964:	ffffb097          	auipc	ra,0xffffb
    80005968:	668080e7          	jalr	1640(ra) # 80000fcc <acquire>
  while(1){
    if(log.committing){
    8000596c:	0001d497          	auipc	s1,0x1d
    80005970:	21c48493          	addi	s1,s1,540 # 80022b88 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80005974:	01e00913          	li	s2,30
    80005978:	0140006f          	j	8000598c <begin_op+0x48>
      sleep(&log, &log.lock);
    8000597c:	00048593          	mv	a1,s1
    80005980:	00048513          	mv	a0,s1
    80005984:	ffffd097          	auipc	ra,0xffffd
    80005988:	43c080e7          	jalr	1084(ra) # 80002dc0 <sleep>
    if(log.committing){
    8000598c:	0244a783          	lw	a5,36(s1)
    80005990:	fe0796e3          	bnez	a5,8000597c <begin_op+0x38>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80005994:	0204a783          	lw	a5,32(s1)
    80005998:	0017871b          	addiw	a4,a5,1
    8000599c:	0007069b          	sext.w	a3,a4
    800059a0:	0027179b          	slliw	a5,a4,0x2
    800059a4:	00e787bb          	addw	a5,a5,a4
    800059a8:	0017979b          	slliw	a5,a5,0x1
    800059ac:	02c4a703          	lw	a4,44(s1)
    800059b0:	00e787bb          	addw	a5,a5,a4
    800059b4:	00f95c63          	bge	s2,a5,800059cc <begin_op+0x88>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800059b8:	00048593          	mv	a1,s1
    800059bc:	00048513          	mv	a0,s1
    800059c0:	ffffd097          	auipc	ra,0xffffd
    800059c4:	400080e7          	jalr	1024(ra) # 80002dc0 <sleep>
    800059c8:	fc5ff06f          	j	8000598c <begin_op+0x48>
    } else {
      log.outstanding += 1;
    800059cc:	0001d517          	auipc	a0,0x1d
    800059d0:	1bc50513          	addi	a0,a0,444 # 80022b88 <log>
    800059d4:	02d52023          	sw	a3,32(a0)
      release(&log.lock);
    800059d8:	ffffb097          	auipc	ra,0xffffb
    800059dc:	6ec080e7          	jalr	1772(ra) # 800010c4 <release>
      break;
    }
  }
}
    800059e0:	01813083          	ld	ra,24(sp)
    800059e4:	01013403          	ld	s0,16(sp)
    800059e8:	00813483          	ld	s1,8(sp)
    800059ec:	00013903          	ld	s2,0(sp)
    800059f0:	02010113          	addi	sp,sp,32
    800059f4:	00008067          	ret

00000000800059f8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800059f8:	fc010113          	addi	sp,sp,-64
    800059fc:	02113c23          	sd	ra,56(sp)
    80005a00:	02813823          	sd	s0,48(sp)
    80005a04:	02913423          	sd	s1,40(sp)
    80005a08:	03213023          	sd	s2,32(sp)
    80005a0c:	01313c23          	sd	s3,24(sp)
    80005a10:	01413823          	sd	s4,16(sp)
    80005a14:	01513423          	sd	s5,8(sp)
    80005a18:	04010413          	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80005a1c:	0001d497          	auipc	s1,0x1d
    80005a20:	16c48493          	addi	s1,s1,364 # 80022b88 <log>
    80005a24:	00048513          	mv	a0,s1
    80005a28:	ffffb097          	auipc	ra,0xffffb
    80005a2c:	5a4080e7          	jalr	1444(ra) # 80000fcc <acquire>
  log.outstanding -= 1;
    80005a30:	0204a783          	lw	a5,32(s1)
    80005a34:	fff7879b          	addiw	a5,a5,-1
    80005a38:	0007891b          	sext.w	s2,a5
    80005a3c:	02f4a023          	sw	a5,32(s1)
  if(log.committing)
    80005a40:	0244a783          	lw	a5,36(s1)
    80005a44:	06079063          	bnez	a5,80005aa4 <end_op+0xac>
    panic("log.committing");
  if(log.outstanding == 0){
    80005a48:	06091663          	bnez	s2,80005ab4 <end_op+0xbc>
    do_commit = 1;
    log.committing = 1;
    80005a4c:	0001d497          	auipc	s1,0x1d
    80005a50:	13c48493          	addi	s1,s1,316 # 80022b88 <log>
    80005a54:	00100793          	li	a5,1
    80005a58:	02f4a223          	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80005a5c:	00048513          	mv	a0,s1
    80005a60:	ffffb097          	auipc	ra,0xffffb
    80005a64:	664080e7          	jalr	1636(ra) # 800010c4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80005a68:	02c4a783          	lw	a5,44(s1)
    80005a6c:	08f04663          	bgtz	a5,80005af8 <end_op+0x100>
    acquire(&log.lock);
    80005a70:	0001d497          	auipc	s1,0x1d
    80005a74:	11848493          	addi	s1,s1,280 # 80022b88 <log>
    80005a78:	00048513          	mv	a0,s1
    80005a7c:	ffffb097          	auipc	ra,0xffffb
    80005a80:	550080e7          	jalr	1360(ra) # 80000fcc <acquire>
    log.committing = 0;
    80005a84:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80005a88:	00048513          	mv	a0,s1
    80005a8c:	ffffd097          	auipc	ra,0xffffd
    80005a90:	554080e7          	jalr	1364(ra) # 80002fe0 <wakeup>
    release(&log.lock);
    80005a94:	00048513          	mv	a0,s1
    80005a98:	ffffb097          	auipc	ra,0xffffb
    80005a9c:	62c080e7          	jalr	1580(ra) # 800010c4 <release>
}
    80005aa0:	0340006f          	j	80005ad4 <end_op+0xdc>
    panic("log.committing");
    80005aa4:	00005517          	auipc	a0,0x5
    80005aa8:	b8450513          	addi	a0,a0,-1148 # 8000a628 <syscalls+0x1e0>
    80005aac:	ffffb097          	auipc	ra,0xffffb
    80005ab0:	c20080e7          	jalr	-992(ra) # 800006cc <panic>
    wakeup(&log);
    80005ab4:	0001d497          	auipc	s1,0x1d
    80005ab8:	0d448493          	addi	s1,s1,212 # 80022b88 <log>
    80005abc:	00048513          	mv	a0,s1
    80005ac0:	ffffd097          	auipc	ra,0xffffd
    80005ac4:	520080e7          	jalr	1312(ra) # 80002fe0 <wakeup>
  release(&log.lock);
    80005ac8:	00048513          	mv	a0,s1
    80005acc:	ffffb097          	auipc	ra,0xffffb
    80005ad0:	5f8080e7          	jalr	1528(ra) # 800010c4 <release>
}
    80005ad4:	03813083          	ld	ra,56(sp)
    80005ad8:	03013403          	ld	s0,48(sp)
    80005adc:	02813483          	ld	s1,40(sp)
    80005ae0:	02013903          	ld	s2,32(sp)
    80005ae4:	01813983          	ld	s3,24(sp)
    80005ae8:	01013a03          	ld	s4,16(sp)
    80005aec:	00813a83          	ld	s5,8(sp)
    80005af0:	04010113          	addi	sp,sp,64
    80005af4:	00008067          	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80005af8:	0001da97          	auipc	s5,0x1d
    80005afc:	0c0a8a93          	addi	s5,s5,192 # 80022bb8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80005b00:	0001da17          	auipc	s4,0x1d
    80005b04:	088a0a13          	addi	s4,s4,136 # 80022b88 <log>
    80005b08:	018a2583          	lw	a1,24(s4)
    80005b0c:	012585bb          	addw	a1,a1,s2
    80005b10:	0015859b          	addiw	a1,a1,1
    80005b14:	028a2503          	lw	a0,40(s4)
    80005b18:	ffffe097          	auipc	ra,0xffffe
    80005b1c:	568080e7          	jalr	1384(ra) # 80004080 <bread>
    80005b20:	00050493          	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80005b24:	000aa583          	lw	a1,0(s5)
    80005b28:	028a2503          	lw	a0,40(s4)
    80005b2c:	ffffe097          	auipc	ra,0xffffe
    80005b30:	554080e7          	jalr	1364(ra) # 80004080 <bread>
    80005b34:	00050993          	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80005b38:	40000613          	li	a2,1024
    80005b3c:	06050593          	addi	a1,a0,96
    80005b40:	06048513          	addi	a0,s1,96
    80005b44:	ffffb097          	auipc	ra,0xffffb
    80005b48:	674080e7          	jalr	1652(ra) # 800011b8 <memmove>
    bwrite(to);  // write the log
    80005b4c:	00048513          	mv	a0,s1
    80005b50:	ffffe097          	auipc	ra,0xffffe
    80005b54:	668080e7          	jalr	1640(ra) # 800041b8 <bwrite>
    brelse(from);
    80005b58:	00098513          	mv	a0,s3
    80005b5c:	ffffe097          	auipc	ra,0xffffe
    80005b60:	6c0080e7          	jalr	1728(ra) # 8000421c <brelse>
    brelse(to);
    80005b64:	00048513          	mv	a0,s1
    80005b68:	ffffe097          	auipc	ra,0xffffe
    80005b6c:	6b4080e7          	jalr	1716(ra) # 8000421c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005b70:	0019091b          	addiw	s2,s2,1
    80005b74:	004a8a93          	addi	s5,s5,4
    80005b78:	02ca2783          	lw	a5,44(s4)
    80005b7c:	f8f946e3          	blt	s2,a5,80005b08 <end_op+0x110>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80005b80:	00000097          	auipc	ra,0x0
    80005b84:	b34080e7          	jalr	-1228(ra) # 800056b4 <write_head>
    install_trans(0); // Now install writes to home locations
    80005b88:	00000513          	li	a0,0
    80005b8c:	00000097          	auipc	ra,0x0
    80005b90:	bd0080e7          	jalr	-1072(ra) # 8000575c <install_trans>
    log.lh.n = 0;
    80005b94:	0001d797          	auipc	a5,0x1d
    80005b98:	0207a023          	sw	zero,32(a5) # 80022bb4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80005b9c:	00000097          	auipc	ra,0x0
    80005ba0:	b18080e7          	jalr	-1256(ra) # 800056b4 <write_head>
    80005ba4:	ecdff06f          	j	80005a70 <end_op+0x78>

0000000080005ba8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80005ba8:	fe010113          	addi	sp,sp,-32
    80005bac:	00113c23          	sd	ra,24(sp)
    80005bb0:	00813823          	sd	s0,16(sp)
    80005bb4:	00913423          	sd	s1,8(sp)
    80005bb8:	01213023          	sd	s2,0(sp)
    80005bbc:	02010413          	addi	s0,sp,32
    80005bc0:	00050493          	mv	s1,a0
  int i;

  acquire(&log.lock);
    80005bc4:	0001d917          	auipc	s2,0x1d
    80005bc8:	fc490913          	addi	s2,s2,-60 # 80022b88 <log>
    80005bcc:	00090513          	mv	a0,s2
    80005bd0:	ffffb097          	auipc	ra,0xffffb
    80005bd4:	3fc080e7          	jalr	1020(ra) # 80000fcc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80005bd8:	02c92603          	lw	a2,44(s2)
    80005bdc:	01d00793          	li	a5,29
    80005be0:	08c7c663          	blt	a5,a2,80005c6c <log_write+0xc4>
    80005be4:	0001d797          	auipc	a5,0x1d
    80005be8:	fc07a783          	lw	a5,-64(a5) # 80022ba4 <log+0x1c>
    80005bec:	fff7879b          	addiw	a5,a5,-1
    80005bf0:	06f65e63          	bge	a2,a5,80005c6c <log_write+0xc4>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80005bf4:	0001d797          	auipc	a5,0x1d
    80005bf8:	fb47a783          	lw	a5,-76(a5) # 80022ba8 <log+0x20>
    80005bfc:	08f05063          	blez	a5,80005c7c <log_write+0xd4>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80005c00:	00000793          	li	a5,0
    80005c04:	08c05463          	blez	a2,80005c8c <log_write+0xe4>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80005c08:	0084a583          	lw	a1,8(s1)
    80005c0c:	0001d717          	auipc	a4,0x1d
    80005c10:	fac70713          	addi	a4,a4,-84 # 80022bb8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80005c14:	00000793          	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80005c18:	00072683          	lw	a3,0(a4)
    80005c1c:	06b68863          	beq	a3,a1,80005c8c <log_write+0xe4>
  for (i = 0; i < log.lh.n; i++) {
    80005c20:	0017879b          	addiw	a5,a5,1
    80005c24:	00470713          	addi	a4,a4,4
    80005c28:	fef618e3          	bne	a2,a5,80005c18 <log_write+0x70>
      break;
  }
  log.lh.block[i] = b->blockno;
    80005c2c:	00860613          	addi	a2,a2,8
    80005c30:	00261613          	slli	a2,a2,0x2
    80005c34:	0001d797          	auipc	a5,0x1d
    80005c38:	f5478793          	addi	a5,a5,-172 # 80022b88 <log>
    80005c3c:	00c78633          	add	a2,a5,a2
    80005c40:	0084a783          	lw	a5,8(s1)
    80005c44:	00f62823          	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80005c48:	00048513          	mv	a0,s1
    80005c4c:	ffffe097          	auipc	ra,0xffffe
    80005c50:	6a8080e7          	jalr	1704(ra) # 800042f4 <bpin>
    log.lh.n++;
    80005c54:	0001d717          	auipc	a4,0x1d
    80005c58:	f3470713          	addi	a4,a4,-204 # 80022b88 <log>
    80005c5c:	02c72783          	lw	a5,44(a4)
    80005c60:	0017879b          	addiw	a5,a5,1
    80005c64:	02f72623          	sw	a5,44(a4)
    80005c68:	0440006f          	j	80005cac <log_write+0x104>
    panic("too big a transaction");
    80005c6c:	00005517          	auipc	a0,0x5
    80005c70:	9cc50513          	addi	a0,a0,-1588 # 8000a638 <syscalls+0x1f0>
    80005c74:	ffffb097          	auipc	ra,0xffffb
    80005c78:	a58080e7          	jalr	-1448(ra) # 800006cc <panic>
    panic("log_write outside of trans");
    80005c7c:	00005517          	auipc	a0,0x5
    80005c80:	9d450513          	addi	a0,a0,-1580 # 8000a650 <syscalls+0x208>
    80005c84:	ffffb097          	auipc	ra,0xffffb
    80005c88:	a48080e7          	jalr	-1464(ra) # 800006cc <panic>
  log.lh.block[i] = b->blockno;
    80005c8c:	00878713          	addi	a4,a5,8
    80005c90:	00271693          	slli	a3,a4,0x2
    80005c94:	0001d717          	auipc	a4,0x1d
    80005c98:	ef470713          	addi	a4,a4,-268 # 80022b88 <log>
    80005c9c:	00d70733          	add	a4,a4,a3
    80005ca0:	0084a683          	lw	a3,8(s1)
    80005ca4:	00d72823          	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80005ca8:	faf600e3          	beq	a2,a5,80005c48 <log_write+0xa0>
  }
  release(&log.lock);
    80005cac:	0001d517          	auipc	a0,0x1d
    80005cb0:	edc50513          	addi	a0,a0,-292 # 80022b88 <log>
    80005cb4:	ffffb097          	auipc	ra,0xffffb
    80005cb8:	410080e7          	jalr	1040(ra) # 800010c4 <release>
}
    80005cbc:	01813083          	ld	ra,24(sp)
    80005cc0:	01013403          	ld	s0,16(sp)
    80005cc4:	00813483          	ld	s1,8(sp)
    80005cc8:	00013903          	ld	s2,0(sp)
    80005ccc:	02010113          	addi	sp,sp,32
    80005cd0:	00008067          	ret

0000000080005cd4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80005cd4:	fe010113          	addi	sp,sp,-32
    80005cd8:	00113c23          	sd	ra,24(sp)
    80005cdc:	00813823          	sd	s0,16(sp)
    80005ce0:	00913423          	sd	s1,8(sp)
    80005ce4:	01213023          	sd	s2,0(sp)
    80005ce8:	02010413          	addi	s0,sp,32
    80005cec:	00050493          	mv	s1,a0
    80005cf0:	00058913          	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80005cf4:	00005597          	auipc	a1,0x5
    80005cf8:	97c58593          	addi	a1,a1,-1668 # 8000a670 <syscalls+0x228>
    80005cfc:	00850513          	addi	a0,a0,8
    80005d00:	ffffb097          	auipc	ra,0xffffb
    80005d04:	1e8080e7          	jalr	488(ra) # 80000ee8 <initlock>
  lk->name = name;
    80005d08:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80005d0c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005d10:	0204a423          	sw	zero,40(s1)
}
    80005d14:	01813083          	ld	ra,24(sp)
    80005d18:	01013403          	ld	s0,16(sp)
    80005d1c:	00813483          	ld	s1,8(sp)
    80005d20:	00013903          	ld	s2,0(sp)
    80005d24:	02010113          	addi	sp,sp,32
    80005d28:	00008067          	ret

0000000080005d2c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80005d2c:	fe010113          	addi	sp,sp,-32
    80005d30:	00113c23          	sd	ra,24(sp)
    80005d34:	00813823          	sd	s0,16(sp)
    80005d38:	00913423          	sd	s1,8(sp)
    80005d3c:	01213023          	sd	s2,0(sp)
    80005d40:	02010413          	addi	s0,sp,32
    80005d44:	00050493          	mv	s1,a0
  acquire(&lk->lk);
    80005d48:	00850913          	addi	s2,a0,8
    80005d4c:	00090513          	mv	a0,s2
    80005d50:	ffffb097          	auipc	ra,0xffffb
    80005d54:	27c080e7          	jalr	636(ra) # 80000fcc <acquire>
  while (lk->locked) {
    80005d58:	0004a783          	lw	a5,0(s1)
    80005d5c:	00078e63          	beqz	a5,80005d78 <acquiresleep+0x4c>
    sleep(lk, &lk->lk);
    80005d60:	00090593          	mv	a1,s2
    80005d64:	00048513          	mv	a0,s1
    80005d68:	ffffd097          	auipc	ra,0xffffd
    80005d6c:	058080e7          	jalr	88(ra) # 80002dc0 <sleep>
  while (lk->locked) {
    80005d70:	0004a783          	lw	a5,0(s1)
    80005d74:	fe0796e3          	bnez	a5,80005d60 <acquiresleep+0x34>
  }
  lk->locked = 1;
    80005d78:	00100793          	li	a5,1
    80005d7c:	00f4a023          	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80005d80:	ffffc097          	auipc	ra,0xffffc
    80005d84:	6d0080e7          	jalr	1744(ra) # 80002450 <myproc>
    80005d88:	03052783          	lw	a5,48(a0)
    80005d8c:	02f4a423          	sw	a5,40(s1)
  release(&lk->lk);
    80005d90:	00090513          	mv	a0,s2
    80005d94:	ffffb097          	auipc	ra,0xffffb
    80005d98:	330080e7          	jalr	816(ra) # 800010c4 <release>
}
    80005d9c:	01813083          	ld	ra,24(sp)
    80005da0:	01013403          	ld	s0,16(sp)
    80005da4:	00813483          	ld	s1,8(sp)
    80005da8:	00013903          	ld	s2,0(sp)
    80005dac:	02010113          	addi	sp,sp,32
    80005db0:	00008067          	ret

0000000080005db4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80005db4:	fe010113          	addi	sp,sp,-32
    80005db8:	00113c23          	sd	ra,24(sp)
    80005dbc:	00813823          	sd	s0,16(sp)
    80005dc0:	00913423          	sd	s1,8(sp)
    80005dc4:	01213023          	sd	s2,0(sp)
    80005dc8:	02010413          	addi	s0,sp,32
    80005dcc:	00050493          	mv	s1,a0
  acquire(&lk->lk);
    80005dd0:	00850913          	addi	s2,a0,8
    80005dd4:	00090513          	mv	a0,s2
    80005dd8:	ffffb097          	auipc	ra,0xffffb
    80005ddc:	1f4080e7          	jalr	500(ra) # 80000fcc <acquire>
  lk->locked = 0;
    80005de0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005de4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80005de8:	00048513          	mv	a0,s1
    80005dec:	ffffd097          	auipc	ra,0xffffd
    80005df0:	1f4080e7          	jalr	500(ra) # 80002fe0 <wakeup>
  release(&lk->lk);
    80005df4:	00090513          	mv	a0,s2
    80005df8:	ffffb097          	auipc	ra,0xffffb
    80005dfc:	2cc080e7          	jalr	716(ra) # 800010c4 <release>
}
    80005e00:	01813083          	ld	ra,24(sp)
    80005e04:	01013403          	ld	s0,16(sp)
    80005e08:	00813483          	ld	s1,8(sp)
    80005e0c:	00013903          	ld	s2,0(sp)
    80005e10:	02010113          	addi	sp,sp,32
    80005e14:	00008067          	ret

0000000080005e18 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80005e18:	fd010113          	addi	sp,sp,-48
    80005e1c:	02113423          	sd	ra,40(sp)
    80005e20:	02813023          	sd	s0,32(sp)
    80005e24:	00913c23          	sd	s1,24(sp)
    80005e28:	01213823          	sd	s2,16(sp)
    80005e2c:	01313423          	sd	s3,8(sp)
    80005e30:	03010413          	addi	s0,sp,48
    80005e34:	00050493          	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80005e38:	00850913          	addi	s2,a0,8
    80005e3c:	00090513          	mv	a0,s2
    80005e40:	ffffb097          	auipc	ra,0xffffb
    80005e44:	18c080e7          	jalr	396(ra) # 80000fcc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80005e48:	0004a783          	lw	a5,0(s1)
    80005e4c:	02079a63          	bnez	a5,80005e80 <holdingsleep+0x68>
    80005e50:	00000493          	li	s1,0
  release(&lk->lk);
    80005e54:	00090513          	mv	a0,s2
    80005e58:	ffffb097          	auipc	ra,0xffffb
    80005e5c:	26c080e7          	jalr	620(ra) # 800010c4 <release>
  return r;
}
    80005e60:	00048513          	mv	a0,s1
    80005e64:	02813083          	ld	ra,40(sp)
    80005e68:	02013403          	ld	s0,32(sp)
    80005e6c:	01813483          	ld	s1,24(sp)
    80005e70:	01013903          	ld	s2,16(sp)
    80005e74:	00813983          	ld	s3,8(sp)
    80005e78:	03010113          	addi	sp,sp,48
    80005e7c:	00008067          	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80005e80:	0284a983          	lw	s3,40(s1)
    80005e84:	ffffc097          	auipc	ra,0xffffc
    80005e88:	5cc080e7          	jalr	1484(ra) # 80002450 <myproc>
    80005e8c:	03052483          	lw	s1,48(a0)
    80005e90:	413484b3          	sub	s1,s1,s3
    80005e94:	0014b493          	seqz	s1,s1
    80005e98:	fbdff06f          	j	80005e54 <holdingsleep+0x3c>

0000000080005e9c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005e9c:	ff010113          	addi	sp,sp,-16
    80005ea0:	00113423          	sd	ra,8(sp)
    80005ea4:	00813023          	sd	s0,0(sp)
    80005ea8:	01010413          	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005eac:	00004597          	auipc	a1,0x4
    80005eb0:	7d458593          	addi	a1,a1,2004 # 8000a680 <syscalls+0x238>
    80005eb4:	0001d517          	auipc	a0,0x1d
    80005eb8:	e1c50513          	addi	a0,a0,-484 # 80022cd0 <ftable>
    80005ebc:	ffffb097          	auipc	ra,0xffffb
    80005ec0:	02c080e7          	jalr	44(ra) # 80000ee8 <initlock>
}
    80005ec4:	00813083          	ld	ra,8(sp)
    80005ec8:	00013403          	ld	s0,0(sp)
    80005ecc:	01010113          	addi	sp,sp,16
    80005ed0:	00008067          	ret

0000000080005ed4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80005ed4:	fe010113          	addi	sp,sp,-32
    80005ed8:	00113c23          	sd	ra,24(sp)
    80005edc:	00813823          	sd	s0,16(sp)
    80005ee0:	00913423          	sd	s1,8(sp)
    80005ee4:	02010413          	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80005ee8:	0001d517          	auipc	a0,0x1d
    80005eec:	de850513          	addi	a0,a0,-536 # 80022cd0 <ftable>
    80005ef0:	ffffb097          	auipc	ra,0xffffb
    80005ef4:	0dc080e7          	jalr	220(ra) # 80000fcc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005ef8:	0001d497          	auipc	s1,0x1d
    80005efc:	df048493          	addi	s1,s1,-528 # 80022ce8 <ftable+0x18>
    80005f00:	0001e717          	auipc	a4,0x1e
    80005f04:	d8870713          	addi	a4,a4,-632 # 80023c88 <end>
    if(f->ref == 0){
    80005f08:	0044a783          	lw	a5,4(s1)
    80005f0c:	02078263          	beqz	a5,80005f30 <filealloc+0x5c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005f10:	02848493          	addi	s1,s1,40
    80005f14:	fee49ae3          	bne	s1,a4,80005f08 <filealloc+0x34>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80005f18:	0001d517          	auipc	a0,0x1d
    80005f1c:	db850513          	addi	a0,a0,-584 # 80022cd0 <ftable>
    80005f20:	ffffb097          	auipc	ra,0xffffb
    80005f24:	1a4080e7          	jalr	420(ra) # 800010c4 <release>
  return 0;
    80005f28:	00000493          	li	s1,0
    80005f2c:	01c0006f          	j	80005f48 <filealloc+0x74>
      f->ref = 1;
    80005f30:	00100793          	li	a5,1
    80005f34:	00f4a223          	sw	a5,4(s1)
      release(&ftable.lock);
    80005f38:	0001d517          	auipc	a0,0x1d
    80005f3c:	d9850513          	addi	a0,a0,-616 # 80022cd0 <ftable>
    80005f40:	ffffb097          	auipc	ra,0xffffb
    80005f44:	184080e7          	jalr	388(ra) # 800010c4 <release>
}
    80005f48:	00048513          	mv	a0,s1
    80005f4c:	01813083          	ld	ra,24(sp)
    80005f50:	01013403          	ld	s0,16(sp)
    80005f54:	00813483          	ld	s1,8(sp)
    80005f58:	02010113          	addi	sp,sp,32
    80005f5c:	00008067          	ret

0000000080005f60 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80005f60:	fe010113          	addi	sp,sp,-32
    80005f64:	00113c23          	sd	ra,24(sp)
    80005f68:	00813823          	sd	s0,16(sp)
    80005f6c:	00913423          	sd	s1,8(sp)
    80005f70:	02010413          	addi	s0,sp,32
    80005f74:	00050493          	mv	s1,a0
  acquire(&ftable.lock);
    80005f78:	0001d517          	auipc	a0,0x1d
    80005f7c:	d5850513          	addi	a0,a0,-680 # 80022cd0 <ftable>
    80005f80:	ffffb097          	auipc	ra,0xffffb
    80005f84:	04c080e7          	jalr	76(ra) # 80000fcc <acquire>
  if(f->ref < 1)
    80005f88:	0044a783          	lw	a5,4(s1)
    80005f8c:	02f05a63          	blez	a5,80005fc0 <filedup+0x60>
    panic("filedup");
  f->ref++;
    80005f90:	0017879b          	addiw	a5,a5,1
    80005f94:	00f4a223          	sw	a5,4(s1)
  release(&ftable.lock);
    80005f98:	0001d517          	auipc	a0,0x1d
    80005f9c:	d3850513          	addi	a0,a0,-712 # 80022cd0 <ftable>
    80005fa0:	ffffb097          	auipc	ra,0xffffb
    80005fa4:	124080e7          	jalr	292(ra) # 800010c4 <release>
  return f;
}
    80005fa8:	00048513          	mv	a0,s1
    80005fac:	01813083          	ld	ra,24(sp)
    80005fb0:	01013403          	ld	s0,16(sp)
    80005fb4:	00813483          	ld	s1,8(sp)
    80005fb8:	02010113          	addi	sp,sp,32
    80005fbc:	00008067          	ret
    panic("filedup");
    80005fc0:	00004517          	auipc	a0,0x4
    80005fc4:	6c850513          	addi	a0,a0,1736 # 8000a688 <syscalls+0x240>
    80005fc8:	ffffa097          	auipc	ra,0xffffa
    80005fcc:	704080e7          	jalr	1796(ra) # 800006cc <panic>

0000000080005fd0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80005fd0:	fc010113          	addi	sp,sp,-64
    80005fd4:	02113c23          	sd	ra,56(sp)
    80005fd8:	02813823          	sd	s0,48(sp)
    80005fdc:	02913423          	sd	s1,40(sp)
    80005fe0:	03213023          	sd	s2,32(sp)
    80005fe4:	01313c23          	sd	s3,24(sp)
    80005fe8:	01413823          	sd	s4,16(sp)
    80005fec:	01513423          	sd	s5,8(sp)
    80005ff0:	04010413          	addi	s0,sp,64
    80005ff4:	00050493          	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005ff8:	0001d517          	auipc	a0,0x1d
    80005ffc:	cd850513          	addi	a0,a0,-808 # 80022cd0 <ftable>
    80006000:	ffffb097          	auipc	ra,0xffffb
    80006004:	fcc080e7          	jalr	-52(ra) # 80000fcc <acquire>
  if(f->ref < 1)
    80006008:	0044a783          	lw	a5,4(s1)
    8000600c:	06f05863          	blez	a5,8000607c <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
    80006010:	fff7879b          	addiw	a5,a5,-1
    80006014:	0007871b          	sext.w	a4,a5
    80006018:	00f4a223          	sw	a5,4(s1)
    8000601c:	06e04863          	bgtz	a4,8000608c <fileclose+0xbc>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80006020:	0004a903          	lw	s2,0(s1)
    80006024:	0094ca83          	lbu	s5,9(s1)
    80006028:	0104ba03          	ld	s4,16(s1)
    8000602c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80006030:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80006034:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80006038:	0001d517          	auipc	a0,0x1d
    8000603c:	c9850513          	addi	a0,a0,-872 # 80022cd0 <ftable>
    80006040:	ffffb097          	auipc	ra,0xffffb
    80006044:	084080e7          	jalr	132(ra) # 800010c4 <release>

  if(ff.type == FD_PIPE){
    80006048:	00100793          	li	a5,1
    8000604c:	06f90a63          	beq	s2,a5,800060c0 <fileclose+0xf0>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80006050:	ffe9091b          	addiw	s2,s2,-2
    80006054:	00100793          	li	a5,1
    80006058:	0527e263          	bltu	a5,s2,8000609c <fileclose+0xcc>
    begin_op();
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	8e8080e7          	jalr	-1816(ra) # 80005944 <begin_op>
    iput(ff.ip);
    80006064:	00098513          	mv	a0,s3
    80006068:	fffff097          	auipc	ra,0xfffff
    8000606c:	d54080e7          	jalr	-684(ra) # 80004dbc <iput>
    end_op();
    80006070:	00000097          	auipc	ra,0x0
    80006074:	988080e7          	jalr	-1656(ra) # 800059f8 <end_op>
    80006078:	0240006f          	j	8000609c <fileclose+0xcc>
    panic("fileclose");
    8000607c:	00004517          	auipc	a0,0x4
    80006080:	61450513          	addi	a0,a0,1556 # 8000a690 <syscalls+0x248>
    80006084:	ffffa097          	auipc	ra,0xffffa
    80006088:	648080e7          	jalr	1608(ra) # 800006cc <panic>
    release(&ftable.lock);
    8000608c:	0001d517          	auipc	a0,0x1d
    80006090:	c4450513          	addi	a0,a0,-956 # 80022cd0 <ftable>
    80006094:	ffffb097          	auipc	ra,0xffffb
    80006098:	030080e7          	jalr	48(ra) # 800010c4 <release>
  }
}
    8000609c:	03813083          	ld	ra,56(sp)
    800060a0:	03013403          	ld	s0,48(sp)
    800060a4:	02813483          	ld	s1,40(sp)
    800060a8:	02013903          	ld	s2,32(sp)
    800060ac:	01813983          	ld	s3,24(sp)
    800060b0:	01013a03          	ld	s4,16(sp)
    800060b4:	00813a83          	ld	s5,8(sp)
    800060b8:	04010113          	addi	sp,sp,64
    800060bc:	00008067          	ret
    pipeclose(ff.pipe, ff.writable);
    800060c0:	000a8593          	mv	a1,s5
    800060c4:	000a0513          	mv	a0,s4
    800060c8:	00000097          	auipc	ra,0x0
    800060cc:	4c4080e7          	jalr	1220(ra) # 8000658c <pipeclose>
    800060d0:	fcdff06f          	j	8000609c <fileclose+0xcc>

00000000800060d4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800060d4:	fb010113          	addi	sp,sp,-80
    800060d8:	04113423          	sd	ra,72(sp)
    800060dc:	04813023          	sd	s0,64(sp)
    800060e0:	02913c23          	sd	s1,56(sp)
    800060e4:	03213823          	sd	s2,48(sp)
    800060e8:	03313423          	sd	s3,40(sp)
    800060ec:	05010413          	addi	s0,sp,80
    800060f0:	00050493          	mv	s1,a0
    800060f4:	00058993          	mv	s3,a1
  struct proc *p = myproc();
    800060f8:	ffffc097          	auipc	ra,0xffffc
    800060fc:	358080e7          	jalr	856(ra) # 80002450 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80006100:	0004a783          	lw	a5,0(s1)
    80006104:	ffe7879b          	addiw	a5,a5,-2
    80006108:	00100713          	li	a4,1
    8000610c:	06f76463          	bltu	a4,a5,80006174 <filestat+0xa0>
    80006110:	00050913          	mv	s2,a0
    ilock(f->ip);
    80006114:	0184b503          	ld	a0,24(s1)
    80006118:	fffff097          	auipc	ra,0xfffff
    8000611c:	a44080e7          	jalr	-1468(ra) # 80004b5c <ilock>
    stati(f->ip, &st);
    80006120:	fb840593          	addi	a1,s0,-72
    80006124:	0184b503          	ld	a0,24(s1)
    80006128:	fffff097          	auipc	ra,0xfffff
    8000612c:	db0080e7          	jalr	-592(ra) # 80004ed8 <stati>
    iunlock(f->ip);
    80006130:	0184b503          	ld	a0,24(s1)
    80006134:	fffff097          	auipc	ra,0xfffff
    80006138:	b2c080e7          	jalr	-1236(ra) # 80004c60 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000613c:	01800693          	li	a3,24
    80006140:	fb840613          	addi	a2,s0,-72
    80006144:	00098593          	mv	a1,s3
    80006148:	05093503          	ld	a0,80(s2)
    8000614c:	ffffc097          	auipc	ra,0xffffc
    80006150:	e0c080e7          	jalr	-500(ra) # 80001f58 <copyout>
    80006154:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80006158:	04813083          	ld	ra,72(sp)
    8000615c:	04013403          	ld	s0,64(sp)
    80006160:	03813483          	ld	s1,56(sp)
    80006164:	03013903          	ld	s2,48(sp)
    80006168:	02813983          	ld	s3,40(sp)
    8000616c:	05010113          	addi	sp,sp,80
    80006170:	00008067          	ret
  return -1;
    80006174:	fff00513          	li	a0,-1
    80006178:	fe1ff06f          	j	80006158 <filestat+0x84>

000000008000617c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000617c:	fd010113          	addi	sp,sp,-48
    80006180:	02113423          	sd	ra,40(sp)
    80006184:	02813023          	sd	s0,32(sp)
    80006188:	00913c23          	sd	s1,24(sp)
    8000618c:	01213823          	sd	s2,16(sp)
    80006190:	01313423          	sd	s3,8(sp)
    80006194:	03010413          	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80006198:	00854783          	lbu	a5,8(a0)
    8000619c:	0e078a63          	beqz	a5,80006290 <fileread+0x114>
    800061a0:	00050493          	mv	s1,a0
    800061a4:	00058993          	mv	s3,a1
    800061a8:	00060913          	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800061ac:	00052783          	lw	a5,0(a0)
    800061b0:	00100713          	li	a4,1
    800061b4:	06e78e63          	beq	a5,a4,80006230 <fileread+0xb4>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800061b8:	00300713          	li	a4,3
    800061bc:	08e78463          	beq	a5,a4,80006244 <fileread+0xc8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800061c0:	00200713          	li	a4,2
    800061c4:	0ae79e63          	bne	a5,a4,80006280 <fileread+0x104>
    ilock(f->ip);
    800061c8:	01853503          	ld	a0,24(a0)
    800061cc:	fffff097          	auipc	ra,0xfffff
    800061d0:	990080e7          	jalr	-1648(ra) # 80004b5c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800061d4:	00090713          	mv	a4,s2
    800061d8:	0204a683          	lw	a3,32(s1)
    800061dc:	00098613          	mv	a2,s3
    800061e0:	00100593          	li	a1,1
    800061e4:	0184b503          	ld	a0,24(s1)
    800061e8:	fffff097          	auipc	ra,0xfffff
    800061ec:	d30080e7          	jalr	-720(ra) # 80004f18 <readi>
    800061f0:	00050913          	mv	s2,a0
    800061f4:	00a05863          	blez	a0,80006204 <fileread+0x88>
      f->off += r;
    800061f8:	0204a783          	lw	a5,32(s1)
    800061fc:	00a787bb          	addw	a5,a5,a0
    80006200:	02f4a023          	sw	a5,32(s1)
    iunlock(f->ip);
    80006204:	0184b503          	ld	a0,24(s1)
    80006208:	fffff097          	auipc	ra,0xfffff
    8000620c:	a58080e7          	jalr	-1448(ra) # 80004c60 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80006210:	00090513          	mv	a0,s2
    80006214:	02813083          	ld	ra,40(sp)
    80006218:	02013403          	ld	s0,32(sp)
    8000621c:	01813483          	ld	s1,24(sp)
    80006220:	01013903          	ld	s2,16(sp)
    80006224:	00813983          	ld	s3,8(sp)
    80006228:	03010113          	addi	sp,sp,48
    8000622c:	00008067          	ret
    r = piperead(f->pipe, addr, n);
    80006230:	01053503          	ld	a0,16(a0)
    80006234:	00000097          	auipc	ra,0x0
    80006238:	540080e7          	jalr	1344(ra) # 80006774 <piperead>
    8000623c:	00050913          	mv	s2,a0
    80006240:	fd1ff06f          	j	80006210 <fileread+0x94>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80006244:	02451783          	lh	a5,36(a0)
    80006248:	03079693          	slli	a3,a5,0x30
    8000624c:	0306d693          	srli	a3,a3,0x30
    80006250:	00900713          	li	a4,9
    80006254:	04d76263          	bltu	a4,a3,80006298 <fileread+0x11c>
    80006258:	00479793          	slli	a5,a5,0x4
    8000625c:	0001d717          	auipc	a4,0x1d
    80006260:	9d470713          	addi	a4,a4,-1580 # 80022c30 <devsw>
    80006264:	00f707b3          	add	a5,a4,a5
    80006268:	0007b783          	ld	a5,0(a5)
    8000626c:	02078a63          	beqz	a5,800062a0 <fileread+0x124>
    r = devsw[f->major].read(1, addr, n);
    80006270:	00100513          	li	a0,1
    80006274:	000780e7          	jalr	a5
    80006278:	00050913          	mv	s2,a0
    8000627c:	f95ff06f          	j	80006210 <fileread+0x94>
    panic("fileread");
    80006280:	00004517          	auipc	a0,0x4
    80006284:	42050513          	addi	a0,a0,1056 # 8000a6a0 <syscalls+0x258>
    80006288:	ffffa097          	auipc	ra,0xffffa
    8000628c:	444080e7          	jalr	1092(ra) # 800006cc <panic>
    return -1;
    80006290:	fff00913          	li	s2,-1
    80006294:	f7dff06f          	j	80006210 <fileread+0x94>
      return -1;
    80006298:	fff00913          	li	s2,-1
    8000629c:	f75ff06f          	j	80006210 <fileread+0x94>
    800062a0:	fff00913          	li	s2,-1
    800062a4:	f6dff06f          	j	80006210 <fileread+0x94>

00000000800062a8 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800062a8:	fb010113          	addi	sp,sp,-80
    800062ac:	04113423          	sd	ra,72(sp)
    800062b0:	04813023          	sd	s0,64(sp)
    800062b4:	02913c23          	sd	s1,56(sp)
    800062b8:	03213823          	sd	s2,48(sp)
    800062bc:	03313423          	sd	s3,40(sp)
    800062c0:	03413023          	sd	s4,32(sp)
    800062c4:	01513c23          	sd	s5,24(sp)
    800062c8:	01613823          	sd	s6,16(sp)
    800062cc:	01713423          	sd	s7,8(sp)
    800062d0:	01813023          	sd	s8,0(sp)
    800062d4:	05010413          	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800062d8:	00954783          	lbu	a5,9(a0)
    800062dc:	16078663          	beqz	a5,80006448 <filewrite+0x1a0>
    800062e0:	00050913          	mv	s2,a0
    800062e4:	00058a93          	mv	s5,a1
    800062e8:	00060a13          	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800062ec:	00052783          	lw	a5,0(a0)
    800062f0:	00100713          	li	a4,1
    800062f4:	02e78863          	beq	a5,a4,80006324 <filewrite+0x7c>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800062f8:	00300713          	li	a4,3
    800062fc:	02e78e63          	beq	a5,a4,80006338 <filewrite+0x90>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80006300:	00200713          	li	a4,2
    80006304:	12e79a63          	bne	a5,a4,80006438 <filewrite+0x190>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80006308:	0ec05663          	blez	a2,800063f4 <filewrite+0x14c>
    int i = 0;
    8000630c:	00000993          	li	s3,0
    80006310:	00001b37          	lui	s6,0x1
    80006314:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80006318:	00001bb7          	lui	s7,0x1
    8000631c:	c00b8b9b          	addiw	s7,s7,-1024
    80006320:	0bc0006f          	j	800063dc <filewrite+0x134>
    ret = pipewrite(f->pipe, addr, n);
    80006324:	01053503          	ld	a0,16(a0)
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	2fc080e7          	jalr	764(ra) # 80006624 <pipewrite>
    80006330:	00050a13          	mv	s4,a0
    80006334:	0c80006f          	j	800063fc <filewrite+0x154>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80006338:	02451783          	lh	a5,36(a0)
    8000633c:	03079693          	slli	a3,a5,0x30
    80006340:	0306d693          	srli	a3,a3,0x30
    80006344:	00900713          	li	a4,9
    80006348:	10d76463          	bltu	a4,a3,80006450 <filewrite+0x1a8>
    8000634c:	00479793          	slli	a5,a5,0x4
    80006350:	0001d717          	auipc	a4,0x1d
    80006354:	8e070713          	addi	a4,a4,-1824 # 80022c30 <devsw>
    80006358:	00f707b3          	add	a5,a4,a5
    8000635c:	0087b783          	ld	a5,8(a5)
    80006360:	0e078c63          	beqz	a5,80006458 <filewrite+0x1b0>
    ret = devsw[f->major].write(1, addr, n);
    80006364:	00100513          	li	a0,1
    80006368:	000780e7          	jalr	a5
    8000636c:	00050a13          	mv	s4,a0
    80006370:	08c0006f          	j	800063fc <filewrite+0x154>
    80006374:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80006378:	fffff097          	auipc	ra,0xfffff
    8000637c:	5cc080e7          	jalr	1484(ra) # 80005944 <begin_op>
      ilock(f->ip);
    80006380:	01893503          	ld	a0,24(s2)
    80006384:	ffffe097          	auipc	ra,0xffffe
    80006388:	7d8080e7          	jalr	2008(ra) # 80004b5c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000638c:	000c0713          	mv	a4,s8
    80006390:	02092683          	lw	a3,32(s2)
    80006394:	01598633          	add	a2,s3,s5
    80006398:	00100593          	li	a1,1
    8000639c:	01893503          	ld	a0,24(s2)
    800063a0:	fffff097          	auipc	ra,0xfffff
    800063a4:	ce8080e7          	jalr	-792(ra) # 80005088 <writei>
    800063a8:	00050493          	mv	s1,a0
    800063ac:	00a05863          	blez	a0,800063bc <filewrite+0x114>
        f->off += r;
    800063b0:	02092783          	lw	a5,32(s2)
    800063b4:	00a787bb          	addw	a5,a5,a0
    800063b8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800063bc:	01893503          	ld	a0,24(s2)
    800063c0:	fffff097          	auipc	ra,0xfffff
    800063c4:	8a0080e7          	jalr	-1888(ra) # 80004c60 <iunlock>
      end_op();
    800063c8:	fffff097          	auipc	ra,0xfffff
    800063cc:	630080e7          	jalr	1584(ra) # 800059f8 <end_op>

      if(r != n1){
    800063d0:	029c1463          	bne	s8,s1,800063f8 <filewrite+0x150>
        // error from writei
        break;
      }
      i += r;
    800063d4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800063d8:	0349d063          	bge	s3,s4,800063f8 <filewrite+0x150>
      int n1 = n - i;
    800063dc:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800063e0:	00078493          	mv	s1,a5
    800063e4:	0007879b          	sext.w	a5,a5
    800063e8:	f8fb56e3          	bge	s6,a5,80006374 <filewrite+0xcc>
    800063ec:	000b8493          	mv	s1,s7
    800063f0:	f85ff06f          	j	80006374 <filewrite+0xcc>
    int i = 0;
    800063f4:	00000993          	li	s3,0
    }
    ret = (i == n ? n : -1);
    800063f8:	033a1c63          	bne	s4,s3,80006430 <filewrite+0x188>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800063fc:	000a0513          	mv	a0,s4
    80006400:	04813083          	ld	ra,72(sp)
    80006404:	04013403          	ld	s0,64(sp)
    80006408:	03813483          	ld	s1,56(sp)
    8000640c:	03013903          	ld	s2,48(sp)
    80006410:	02813983          	ld	s3,40(sp)
    80006414:	02013a03          	ld	s4,32(sp)
    80006418:	01813a83          	ld	s5,24(sp)
    8000641c:	01013b03          	ld	s6,16(sp)
    80006420:	00813b83          	ld	s7,8(sp)
    80006424:	00013c03          	ld	s8,0(sp)
    80006428:	05010113          	addi	sp,sp,80
    8000642c:	00008067          	ret
    ret = (i == n ? n : -1);
    80006430:	fff00a13          	li	s4,-1
    80006434:	fc9ff06f          	j	800063fc <filewrite+0x154>
    panic("filewrite");
    80006438:	00004517          	auipc	a0,0x4
    8000643c:	27850513          	addi	a0,a0,632 # 8000a6b0 <syscalls+0x268>
    80006440:	ffffa097          	auipc	ra,0xffffa
    80006444:	28c080e7          	jalr	652(ra) # 800006cc <panic>
    return -1;
    80006448:	fff00a13          	li	s4,-1
    8000644c:	fb1ff06f          	j	800063fc <filewrite+0x154>
      return -1;
    80006450:	fff00a13          	li	s4,-1
    80006454:	fa9ff06f          	j	800063fc <filewrite+0x154>
    80006458:	fff00a13          	li	s4,-1
    8000645c:	fa1ff06f          	j	800063fc <filewrite+0x154>

0000000080006460 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80006460:	fd010113          	addi	sp,sp,-48
    80006464:	02113423          	sd	ra,40(sp)
    80006468:	02813023          	sd	s0,32(sp)
    8000646c:	00913c23          	sd	s1,24(sp)
    80006470:	01213823          	sd	s2,16(sp)
    80006474:	01313423          	sd	s3,8(sp)
    80006478:	01413023          	sd	s4,0(sp)
    8000647c:	03010413          	addi	s0,sp,48
    80006480:	00050493          	mv	s1,a0
    80006484:	00058a13          	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80006488:	0005b023          	sd	zero,0(a1)
    8000648c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80006490:	00000097          	auipc	ra,0x0
    80006494:	a44080e7          	jalr	-1468(ra) # 80005ed4 <filealloc>
    80006498:	00a4b023          	sd	a0,0(s1)
    8000649c:	0a050663          	beqz	a0,80006548 <pipealloc+0xe8>
    800064a0:	00000097          	auipc	ra,0x0
    800064a4:	a34080e7          	jalr	-1484(ra) # 80005ed4 <filealloc>
    800064a8:	00aa3023          	sd	a0,0(s4)
    800064ac:	08050663          	beqz	a0,80006538 <pipealloc+0xd8>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800064b0:	ffffb097          	auipc	ra,0xffffb
    800064b4:	9b0080e7          	jalr	-1616(ra) # 80000e60 <kalloc>
    800064b8:	00050913          	mv	s2,a0
    800064bc:	06050863          	beqz	a0,8000652c <pipealloc+0xcc>
    goto bad;
  pi->readopen = 1;
    800064c0:	00100993          	li	s3,1
    800064c4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800064c8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800064cc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800064d0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800064d4:	00004597          	auipc	a1,0x4
    800064d8:	1ec58593          	addi	a1,a1,492 # 8000a6c0 <syscalls+0x278>
    800064dc:	ffffb097          	auipc	ra,0xffffb
    800064e0:	a0c080e7          	jalr	-1524(ra) # 80000ee8 <initlock>
  (*f0)->type = FD_PIPE;
    800064e4:	0004b783          	ld	a5,0(s1)
    800064e8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800064ec:	0004b783          	ld	a5,0(s1)
    800064f0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800064f4:	0004b783          	ld	a5,0(s1)
    800064f8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800064fc:	0004b783          	ld	a5,0(s1)
    80006500:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80006504:	000a3783          	ld	a5,0(s4)
    80006508:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000650c:	000a3783          	ld	a5,0(s4)
    80006510:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80006514:	000a3783          	ld	a5,0(s4)
    80006518:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000651c:	000a3783          	ld	a5,0(s4)
    80006520:	0127b823          	sd	s2,16(a5)
  return 0;
    80006524:	00000513          	li	a0,0
    80006528:	03c0006f          	j	80006564 <pipealloc+0x104>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000652c:	0004b503          	ld	a0,0(s1)
    80006530:	00051863          	bnez	a0,80006540 <pipealloc+0xe0>
    80006534:	0140006f          	j	80006548 <pipealloc+0xe8>
    80006538:	0004b503          	ld	a0,0(s1)
    8000653c:	04050463          	beqz	a0,80006584 <pipealloc+0x124>
    fileclose(*f0);
    80006540:	00000097          	auipc	ra,0x0
    80006544:	a90080e7          	jalr	-1392(ra) # 80005fd0 <fileclose>
  if(*f1)
    80006548:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000654c:	fff00513          	li	a0,-1
  if(*f1)
    80006550:	00078a63          	beqz	a5,80006564 <pipealloc+0x104>
    fileclose(*f1);
    80006554:	00078513          	mv	a0,a5
    80006558:	00000097          	auipc	ra,0x0
    8000655c:	a78080e7          	jalr	-1416(ra) # 80005fd0 <fileclose>
  return -1;
    80006560:	fff00513          	li	a0,-1
}
    80006564:	02813083          	ld	ra,40(sp)
    80006568:	02013403          	ld	s0,32(sp)
    8000656c:	01813483          	ld	s1,24(sp)
    80006570:	01013903          	ld	s2,16(sp)
    80006574:	00813983          	ld	s3,8(sp)
    80006578:	00013a03          	ld	s4,0(sp)
    8000657c:	03010113          	addi	sp,sp,48
    80006580:	00008067          	ret
  return -1;
    80006584:	fff00513          	li	a0,-1
    80006588:	fddff06f          	j	80006564 <pipealloc+0x104>

000000008000658c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000658c:	fe010113          	addi	sp,sp,-32
    80006590:	00113c23          	sd	ra,24(sp)
    80006594:	00813823          	sd	s0,16(sp)
    80006598:	00913423          	sd	s1,8(sp)
    8000659c:	01213023          	sd	s2,0(sp)
    800065a0:	02010413          	addi	s0,sp,32
    800065a4:	00050493          	mv	s1,a0
    800065a8:	00058913          	mv	s2,a1
  acquire(&pi->lock);
    800065ac:	ffffb097          	auipc	ra,0xffffb
    800065b0:	a20080e7          	jalr	-1504(ra) # 80000fcc <acquire>
  if(writable){
    800065b4:	04090663          	beqz	s2,80006600 <pipeclose+0x74>
    pi->writeopen = 0;
    800065b8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800065bc:	21848513          	addi	a0,s1,536
    800065c0:	ffffd097          	auipc	ra,0xffffd
    800065c4:	a20080e7          	jalr	-1504(ra) # 80002fe0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800065c8:	2204b783          	ld	a5,544(s1)
    800065cc:	04079463          	bnez	a5,80006614 <pipeclose+0x88>
    release(&pi->lock);
    800065d0:	00048513          	mv	a0,s1
    800065d4:	ffffb097          	auipc	ra,0xffffb
    800065d8:	af0080e7          	jalr	-1296(ra) # 800010c4 <release>
    kfree((char*)pi);
    800065dc:	00048513          	mv	a0,s1
    800065e0:	ffffa097          	auipc	ra,0xffffa
    800065e4:	714080e7          	jalr	1812(ra) # 80000cf4 <kfree>
  } else
    release(&pi->lock);
}
    800065e8:	01813083          	ld	ra,24(sp)
    800065ec:	01013403          	ld	s0,16(sp)
    800065f0:	00813483          	ld	s1,8(sp)
    800065f4:	00013903          	ld	s2,0(sp)
    800065f8:	02010113          	addi	sp,sp,32
    800065fc:	00008067          	ret
    pi->readopen = 0;
    80006600:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80006604:	21c48513          	addi	a0,s1,540
    80006608:	ffffd097          	auipc	ra,0xffffd
    8000660c:	9d8080e7          	jalr	-1576(ra) # 80002fe0 <wakeup>
    80006610:	fb9ff06f          	j	800065c8 <pipeclose+0x3c>
    release(&pi->lock);
    80006614:	00048513          	mv	a0,s1
    80006618:	ffffb097          	auipc	ra,0xffffb
    8000661c:	aac080e7          	jalr	-1364(ra) # 800010c4 <release>
}
    80006620:	fc9ff06f          	j	800065e8 <pipeclose+0x5c>

0000000080006624 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80006624:	fa010113          	addi	sp,sp,-96
    80006628:	04113c23          	sd	ra,88(sp)
    8000662c:	04813823          	sd	s0,80(sp)
    80006630:	04913423          	sd	s1,72(sp)
    80006634:	05213023          	sd	s2,64(sp)
    80006638:	03313c23          	sd	s3,56(sp)
    8000663c:	03413823          	sd	s4,48(sp)
    80006640:	03513423          	sd	s5,40(sp)
    80006644:	03613023          	sd	s6,32(sp)
    80006648:	01713c23          	sd	s7,24(sp)
    8000664c:	01813823          	sd	s8,16(sp)
    80006650:	06010413          	addi	s0,sp,96
    80006654:	00050493          	mv	s1,a0
    80006658:	00058a93          	mv	s5,a1
    8000665c:	00060a13          	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80006660:	ffffc097          	auipc	ra,0xffffc
    80006664:	df0080e7          	jalr	-528(ra) # 80002450 <myproc>
    80006668:	00050993          	mv	s3,a0

  acquire(&pi->lock);
    8000666c:	00048513          	mv	a0,s1
    80006670:	ffffb097          	auipc	ra,0xffffb
    80006674:	95c080e7          	jalr	-1700(ra) # 80000fcc <acquire>
  while(i < n){
    80006678:	0d405e63          	blez	s4,80006754 <pipewrite+0x130>
  int i = 0;
    8000667c:	00000913          	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80006680:	fff00b13          	li	s6,-1
      wakeup(&pi->nread);
    80006684:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80006688:	21c48b93          	addi	s7,s1,540
    8000668c:	0680006f          	j	800066f4 <pipewrite+0xd0>
      release(&pi->lock);
    80006690:	00048513          	mv	a0,s1
    80006694:	ffffb097          	auipc	ra,0xffffb
    80006698:	a30080e7          	jalr	-1488(ra) # 800010c4 <release>
      return -1;
    8000669c:	fff00913          	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800066a0:	00090513          	mv	a0,s2
    800066a4:	05813083          	ld	ra,88(sp)
    800066a8:	05013403          	ld	s0,80(sp)
    800066ac:	04813483          	ld	s1,72(sp)
    800066b0:	04013903          	ld	s2,64(sp)
    800066b4:	03813983          	ld	s3,56(sp)
    800066b8:	03013a03          	ld	s4,48(sp)
    800066bc:	02813a83          	ld	s5,40(sp)
    800066c0:	02013b03          	ld	s6,32(sp)
    800066c4:	01813b83          	ld	s7,24(sp)
    800066c8:	01013c03          	ld	s8,16(sp)
    800066cc:	06010113          	addi	sp,sp,96
    800066d0:	00008067          	ret
      wakeup(&pi->nread);
    800066d4:	000c0513          	mv	a0,s8
    800066d8:	ffffd097          	auipc	ra,0xffffd
    800066dc:	908080e7          	jalr	-1784(ra) # 80002fe0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800066e0:	00048593          	mv	a1,s1
    800066e4:	000b8513          	mv	a0,s7
    800066e8:	ffffc097          	auipc	ra,0xffffc
    800066ec:	6d8080e7          	jalr	1752(ra) # 80002dc0 <sleep>
  while(i < n){
    800066f0:	07495463          	bge	s2,s4,80006758 <pipewrite+0x134>
    if(pi->readopen == 0 || pr->killed){
    800066f4:	2204a783          	lw	a5,544(s1)
    800066f8:	f8078ce3          	beqz	a5,80006690 <pipewrite+0x6c>
    800066fc:	0289a783          	lw	a5,40(s3)
    80006700:	f80798e3          	bnez	a5,80006690 <pipewrite+0x6c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80006704:	2184a783          	lw	a5,536(s1)
    80006708:	21c4a703          	lw	a4,540(s1)
    8000670c:	2007879b          	addiw	a5,a5,512
    80006710:	fcf702e3          	beq	a4,a5,800066d4 <pipewrite+0xb0>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80006714:	00100693          	li	a3,1
    80006718:	01590633          	add	a2,s2,s5
    8000671c:	faf40593          	addi	a1,s0,-81
    80006720:	0509b503          	ld	a0,80(s3)
    80006724:	ffffc097          	auipc	ra,0xffffc
    80006728:	91c080e7          	jalr	-1764(ra) # 80002040 <copyin>
    8000672c:	03650663          	beq	a0,s6,80006758 <pipewrite+0x134>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80006730:	21c4a783          	lw	a5,540(s1)
    80006734:	0017871b          	addiw	a4,a5,1
    80006738:	20e4ae23          	sw	a4,540(s1)
    8000673c:	1ff7f793          	andi	a5,a5,511
    80006740:	00f487b3          	add	a5,s1,a5
    80006744:	faf44703          	lbu	a4,-81(s0)
    80006748:	00e78c23          	sb	a4,24(a5)
      i++;
    8000674c:	0019091b          	addiw	s2,s2,1
    80006750:	fa1ff06f          	j	800066f0 <pipewrite+0xcc>
  int i = 0;
    80006754:	00000913          	li	s2,0
  wakeup(&pi->nread);
    80006758:	21848513          	addi	a0,s1,536
    8000675c:	ffffd097          	auipc	ra,0xffffd
    80006760:	884080e7          	jalr	-1916(ra) # 80002fe0 <wakeup>
  release(&pi->lock);
    80006764:	00048513          	mv	a0,s1
    80006768:	ffffb097          	auipc	ra,0xffffb
    8000676c:	95c080e7          	jalr	-1700(ra) # 800010c4 <release>
  return i;
    80006770:	f31ff06f          	j	800066a0 <pipewrite+0x7c>

0000000080006774 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80006774:	fb010113          	addi	sp,sp,-80
    80006778:	04113423          	sd	ra,72(sp)
    8000677c:	04813023          	sd	s0,64(sp)
    80006780:	02913c23          	sd	s1,56(sp)
    80006784:	03213823          	sd	s2,48(sp)
    80006788:	03313423          	sd	s3,40(sp)
    8000678c:	03413023          	sd	s4,32(sp)
    80006790:	01513c23          	sd	s5,24(sp)
    80006794:	01613823          	sd	s6,16(sp)
    80006798:	05010413          	addi	s0,sp,80
    8000679c:	00050493          	mv	s1,a0
    800067a0:	00058913          	mv	s2,a1
    800067a4:	00060a93          	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800067a8:	ffffc097          	auipc	ra,0xffffc
    800067ac:	ca8080e7          	jalr	-856(ra) # 80002450 <myproc>
    800067b0:	00050a13          	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800067b4:	00048513          	mv	a0,s1
    800067b8:	ffffb097          	auipc	ra,0xffffb
    800067bc:	814080e7          	jalr	-2028(ra) # 80000fcc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800067c0:	2184a703          	lw	a4,536(s1)
    800067c4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800067c8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800067cc:	02f71863          	bne	a4,a5,800067fc <piperead+0x88>
    800067d0:	2244a783          	lw	a5,548(s1)
    800067d4:	02078463          	beqz	a5,800067fc <piperead+0x88>
    if(pr->killed){
    800067d8:	028a2783          	lw	a5,40(s4)
    800067dc:	0a079e63          	bnez	a5,80006898 <piperead+0x124>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800067e0:	00048593          	mv	a1,s1
    800067e4:	00098513          	mv	a0,s3
    800067e8:	ffffc097          	auipc	ra,0xffffc
    800067ec:	5d8080e7          	jalr	1496(ra) # 80002dc0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800067f0:	2184a703          	lw	a4,536(s1)
    800067f4:	21c4a783          	lw	a5,540(s1)
    800067f8:	fcf70ce3          	beq	a4,a5,800067d0 <piperead+0x5c>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800067fc:	00000993          	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80006800:	fff00b13          	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80006804:	05505863          	blez	s5,80006854 <piperead+0xe0>
    if(pi->nread == pi->nwrite)
    80006808:	2184a783          	lw	a5,536(s1)
    8000680c:	21c4a703          	lw	a4,540(s1)
    80006810:	04f70263          	beq	a4,a5,80006854 <piperead+0xe0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80006814:	0017871b          	addiw	a4,a5,1
    80006818:	20e4ac23          	sw	a4,536(s1)
    8000681c:	1ff7f793          	andi	a5,a5,511
    80006820:	00f487b3          	add	a5,s1,a5
    80006824:	0187c783          	lbu	a5,24(a5)
    80006828:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000682c:	00100693          	li	a3,1
    80006830:	fbf40613          	addi	a2,s0,-65
    80006834:	00090593          	mv	a1,s2
    80006838:	050a3503          	ld	a0,80(s4)
    8000683c:	ffffb097          	auipc	ra,0xffffb
    80006840:	71c080e7          	jalr	1820(ra) # 80001f58 <copyout>
    80006844:	01650863          	beq	a0,s6,80006854 <piperead+0xe0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80006848:	0019899b          	addiw	s3,s3,1
    8000684c:	00190913          	addi	s2,s2,1
    80006850:	fb3a9ce3          	bne	s5,s3,80006808 <piperead+0x94>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80006854:	21c48513          	addi	a0,s1,540
    80006858:	ffffc097          	auipc	ra,0xffffc
    8000685c:	788080e7          	jalr	1928(ra) # 80002fe0 <wakeup>
  release(&pi->lock);
    80006860:	00048513          	mv	a0,s1
    80006864:	ffffb097          	auipc	ra,0xffffb
    80006868:	860080e7          	jalr	-1952(ra) # 800010c4 <release>
  return i;
}
    8000686c:	00098513          	mv	a0,s3
    80006870:	04813083          	ld	ra,72(sp)
    80006874:	04013403          	ld	s0,64(sp)
    80006878:	03813483          	ld	s1,56(sp)
    8000687c:	03013903          	ld	s2,48(sp)
    80006880:	02813983          	ld	s3,40(sp)
    80006884:	02013a03          	ld	s4,32(sp)
    80006888:	01813a83          	ld	s5,24(sp)
    8000688c:	01013b03          	ld	s6,16(sp)
    80006890:	05010113          	addi	sp,sp,80
    80006894:	00008067          	ret
      release(&pi->lock);
    80006898:	00048513          	mv	a0,s1
    8000689c:	ffffb097          	auipc	ra,0xffffb
    800068a0:	828080e7          	jalr	-2008(ra) # 800010c4 <release>
      return -1;
    800068a4:	fff00993          	li	s3,-1
    800068a8:	fc5ff06f          	j	8000686c <piperead+0xf8>

00000000800068ac <ramdiskinit>:
#include "fs.h"
#include "buf.h"

void
ramdiskinit(void)
{
    800068ac:	ff010113          	addi	sp,sp,-16
    800068b0:	00813423          	sd	s0,8(sp)
    800068b4:	01010413          	addi	s0,sp,16
}
    800068b8:	00813403          	ld	s0,8(sp)
    800068bc:	01010113          	addi	sp,sp,16
    800068c0:	00008067          	ret

00000000800068c4 <ramdiskrw>:

// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ramdiskrw(struct buf *b)
{
    800068c4:	fe010113          	addi	sp,sp,-32
    800068c8:	00113c23          	sd	ra,24(sp)
    800068cc:	00813823          	sd	s0,16(sp)
    800068d0:	00913423          	sd	s1,8(sp)
    800068d4:	02010413          	addi	s0,sp,32
    800068d8:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800068dc:	01050513          	addi	a0,a0,16
    800068e0:	fffff097          	auipc	ra,0xfffff
    800068e4:	538080e7          	jalr	1336(ra) # 80005e18 <holdingsleep>
    800068e8:	06050863          	beqz	a0,80006958 <ramdiskrw+0x94>
    panic("ramdiskrw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    800068ec:	0004a783          	lw	a5,0(s1)
    800068f0:	0067f693          	andi	a3,a5,6
    800068f4:	00200713          	li	a4,2
    800068f8:	06e68863          	beq	a3,a4,80006968 <ramdiskrw+0xa4>
    panic("ramdiskrw: nothing to do");

  if(b->blockno >= FSSIZE)
    800068fc:	0084a503          	lw	a0,8(s1)
    80006900:	3e700713          	li	a4,999
    80006904:	06a76a63          	bltu	a4,a0,80006978 <ramdiskrw+0xb4>
    panic("ramdiskrw: blockno too big");

  uint64 diskaddr = b->blockno * BSIZE;
    80006908:	00a5151b          	slliw	a0,a0,0xa
    8000690c:	02051513          	slli	a0,a0,0x20
    80006910:	02055513          	srli	a0,a0,0x20
  char *addr = (char *)RAMDISK + diskaddr;
    80006914:	01100713          	li	a4,17
    80006918:	01b71713          	slli	a4,a4,0x1b
    8000691c:	00e50533          	add	a0,a0,a4

  if(b->flags & B_DIRTY){
    80006920:	0047f793          	andi	a5,a5,4
    80006924:	06078263          	beqz	a5,80006988 <ramdiskrw+0xc4>
    // write
    memmove(addr, b->data, BSIZE);
    80006928:	40000613          	li	a2,1024
    8000692c:	06048593          	addi	a1,s1,96
    80006930:	ffffb097          	auipc	ra,0xffffb
    80006934:	888080e7          	jalr	-1912(ra) # 800011b8 <memmove>
    b->flags &= ~B_DIRTY;
    80006938:	0004a783          	lw	a5,0(s1)
    8000693c:	ffb7f793          	andi	a5,a5,-5
    80006940:	00f4a023          	sw	a5,0(s1)
  } else {
    // read
    memmove(b->data, addr, BSIZE);
    b->flags |= B_VALID;
  }
}
    80006944:	01813083          	ld	ra,24(sp)
    80006948:	01013403          	ld	s0,16(sp)
    8000694c:	00813483          	ld	s1,8(sp)
    80006950:	02010113          	addi	sp,sp,32
    80006954:	00008067          	ret
    panic("ramdiskrw: buf not locked");
    80006958:	00004517          	auipc	a0,0x4
    8000695c:	d7050513          	addi	a0,a0,-656 # 8000a6c8 <syscalls+0x280>
    80006960:	ffffa097          	auipc	ra,0xffffa
    80006964:	d6c080e7          	jalr	-660(ra) # 800006cc <panic>
    panic("ramdiskrw: nothing to do");
    80006968:	00004517          	auipc	a0,0x4
    8000696c:	d8050513          	addi	a0,a0,-640 # 8000a6e8 <syscalls+0x2a0>
    80006970:	ffffa097          	auipc	ra,0xffffa
    80006974:	d5c080e7          	jalr	-676(ra) # 800006cc <panic>
    panic("ramdiskrw: blockno too big");
    80006978:	00004517          	auipc	a0,0x4
    8000697c:	d9050513          	addi	a0,a0,-624 # 8000a708 <syscalls+0x2c0>
    80006980:	ffffa097          	auipc	ra,0xffffa
    80006984:	d4c080e7          	jalr	-692(ra) # 800006cc <panic>
    memmove(b->data, addr, BSIZE);
    80006988:	40000613          	li	a2,1024
    8000698c:	00050593          	mv	a1,a0
    80006990:	06048513          	addi	a0,s1,96
    80006994:	ffffb097          	auipc	ra,0xffffb
    80006998:	824080e7          	jalr	-2012(ra) # 800011b8 <memmove>
    b->flags |= B_VALID;
    8000699c:	0004a783          	lw	a5,0(s1)
    800069a0:	0027e793          	ori	a5,a5,2
    800069a4:	00f4a023          	sw	a5,0(s1)
}
    800069a8:	f9dff06f          	j	80006944 <ramdiskrw+0x80>

00000000800069ac <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800069ac:	de010113          	addi	sp,sp,-544
    800069b0:	20113c23          	sd	ra,536(sp)
    800069b4:	20813823          	sd	s0,528(sp)
    800069b8:	20913423          	sd	s1,520(sp)
    800069bc:	21213023          	sd	s2,512(sp)
    800069c0:	1f313c23          	sd	s3,504(sp)
    800069c4:	1f413823          	sd	s4,496(sp)
    800069c8:	1f513423          	sd	s5,488(sp)
    800069cc:	1f613023          	sd	s6,480(sp)
    800069d0:	1d713c23          	sd	s7,472(sp)
    800069d4:	1d813823          	sd	s8,464(sp)
    800069d8:	1d913423          	sd	s9,456(sp)
    800069dc:	1da13023          	sd	s10,448(sp)
    800069e0:	1bb13c23          	sd	s11,440(sp)
    800069e4:	22010413          	addi	s0,sp,544
    800069e8:	00050913          	mv	s2,a0
    800069ec:	dea43423          	sd	a0,-536(s0)
    800069f0:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800069f4:	ffffc097          	auipc	ra,0xffffc
    800069f8:	a5c080e7          	jalr	-1444(ra) # 80002450 <myproc>
    800069fc:	00050493          	mv	s1,a0

  begin_op();
    80006a00:	fffff097          	auipc	ra,0xfffff
    80006a04:	f44080e7          	jalr	-188(ra) # 80005944 <begin_op>

  if((ip = namei(path)) == 0){
    80006a08:	00090513          	mv	a0,s2
    80006a0c:	fffff097          	auipc	ra,0xfffff
    80006a10:	c48080e7          	jalr	-952(ra) # 80005654 <namei>
    80006a14:	08050c63          	beqz	a0,80006aac <exec+0x100>
    80006a18:	00050a93          	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80006a1c:	ffffe097          	auipc	ra,0xffffe
    80006a20:	140080e7          	jalr	320(ra) # 80004b5c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80006a24:	04000713          	li	a4,64
    80006a28:	00000693          	li	a3,0
    80006a2c:	e5040613          	addi	a2,s0,-432
    80006a30:	00000593          	li	a1,0
    80006a34:	000a8513          	mv	a0,s5
    80006a38:	ffffe097          	auipc	ra,0xffffe
    80006a3c:	4e0080e7          	jalr	1248(ra) # 80004f18 <readi>
    80006a40:	04000793          	li	a5,64
    80006a44:	00f51a63          	bne	a0,a5,80006a58 <exec+0xac>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80006a48:	e5042703          	lw	a4,-432(s0)
    80006a4c:	464c47b7          	lui	a5,0x464c4
    80006a50:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80006a54:	06f70463          	beq	a4,a5,80006abc <exec+0x110>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80006a58:	000a8513          	mv	a0,s5
    80006a5c:	ffffe097          	auipc	ra,0xffffe
    80006a60:	43c080e7          	jalr	1084(ra) # 80004e98 <iunlockput>
    end_op();
    80006a64:	fffff097          	auipc	ra,0xfffff
    80006a68:	f94080e7          	jalr	-108(ra) # 800059f8 <end_op>
  }
  return -1;
    80006a6c:	fff00513          	li	a0,-1
}
    80006a70:	21813083          	ld	ra,536(sp)
    80006a74:	21013403          	ld	s0,528(sp)
    80006a78:	20813483          	ld	s1,520(sp)
    80006a7c:	20013903          	ld	s2,512(sp)
    80006a80:	1f813983          	ld	s3,504(sp)
    80006a84:	1f013a03          	ld	s4,496(sp)
    80006a88:	1e813a83          	ld	s5,488(sp)
    80006a8c:	1e013b03          	ld	s6,480(sp)
    80006a90:	1d813b83          	ld	s7,472(sp)
    80006a94:	1d013c03          	ld	s8,464(sp)
    80006a98:	1c813c83          	ld	s9,456(sp)
    80006a9c:	1c013d03          	ld	s10,448(sp)
    80006aa0:	1b813d83          	ld	s11,440(sp)
    80006aa4:	22010113          	addi	sp,sp,544
    80006aa8:	00008067          	ret
    end_op();
    80006aac:	fffff097          	auipc	ra,0xfffff
    80006ab0:	f4c080e7          	jalr	-180(ra) # 800059f8 <end_op>
    return -1;
    80006ab4:	fff00513          	li	a0,-1
    80006ab8:	fb9ff06f          	j	80006a70 <exec+0xc4>
  if((pagetable = proc_pagetable(p)) == 0)
    80006abc:	00048513          	mv	a0,s1
    80006ac0:	ffffc097          	auipc	ra,0xffffc
    80006ac4:	aac080e7          	jalr	-1364(ra) # 8000256c <proc_pagetable>
    80006ac8:	00050b13          	mv	s6,a0
    80006acc:	f80506e3          	beqz	a0,80006a58 <exec+0xac>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006ad0:	e7042783          	lw	a5,-400(s0)
    80006ad4:	e8845703          	lhu	a4,-376(s0)
    80006ad8:	08070863          	beqz	a4,80006b68 <exec+0x1bc>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80006adc:	00000493          	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006ae0:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80006ae4:	00001a37          	lui	s4,0x1
    80006ae8:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80006aec:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80006af0:	00001db7          	lui	s11,0x1
    80006af4:	fffffd37          	lui	s10,0xfffff
    80006af8:	2d00006f          	j	80006dc8 <exec+0x41c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80006afc:	00004517          	auipc	a0,0x4
    80006b00:	c2c50513          	addi	a0,a0,-980 # 8000a728 <syscalls+0x2e0>
    80006b04:	ffffa097          	auipc	ra,0xffffa
    80006b08:	bc8080e7          	jalr	-1080(ra) # 800006cc <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80006b0c:	00090713          	mv	a4,s2
    80006b10:	009c86bb          	addw	a3,s9,s1
    80006b14:	00000593          	li	a1,0
    80006b18:	000a8513          	mv	a0,s5
    80006b1c:	ffffe097          	auipc	ra,0xffffe
    80006b20:	3fc080e7          	jalr	1020(ra) # 80004f18 <readi>
    80006b24:	0005051b          	sext.w	a0,a0
    80006b28:	22a91463          	bne	s2,a0,80006d50 <exec+0x3a4>
  for(i = 0; i < sz; i += PGSIZE){
    80006b2c:	009d84bb          	addw	s1,s11,s1
    80006b30:	013d09bb          	addw	s3,s10,s3
    80006b34:	2774fa63          	bgeu	s1,s7,80006da8 <exec+0x3fc>
    pa = walkaddr(pagetable, va + i);
    80006b38:	02049593          	slli	a1,s1,0x20
    80006b3c:	0205d593          	srli	a1,a1,0x20
    80006b40:	018585b3          	add	a1,a1,s8
    80006b44:	000b0513          	mv	a0,s6
    80006b48:	ffffb097          	auipc	ra,0xffffb
    80006b4c:	ad0080e7          	jalr	-1328(ra) # 80001618 <walkaddr>
    80006b50:	00050613          	mv	a2,a0
    if(pa == 0)
    80006b54:	fa0504e3          	beqz	a0,80006afc <exec+0x150>
      n = PGSIZE;
    80006b58:	000a0913          	mv	s2,s4
    if(sz - i < PGSIZE)
    80006b5c:	fb49f8e3          	bgeu	s3,s4,80006b0c <exec+0x160>
      n = sz - i;
    80006b60:	00098913          	mv	s2,s3
    80006b64:	fa9ff06f          	j	80006b0c <exec+0x160>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80006b68:	00000493          	li	s1,0
  iunlockput(ip);
    80006b6c:	000a8513          	mv	a0,s5
    80006b70:	ffffe097          	auipc	ra,0xffffe
    80006b74:	328080e7          	jalr	808(ra) # 80004e98 <iunlockput>
  end_op();
    80006b78:	fffff097          	auipc	ra,0xfffff
    80006b7c:	e80080e7          	jalr	-384(ra) # 800059f8 <end_op>
  asm volatile("fence.i");
    80006b80:	0000100f          	fence.i
  p = myproc();
    80006b84:	ffffc097          	auipc	ra,0xffffc
    80006b88:	8cc080e7          	jalr	-1844(ra) # 80002450 <myproc>
    80006b8c:	00050b93          	mv	s7,a0
  uint64 oldsz = p->sz;
    80006b90:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80006b94:	000017b7          	lui	a5,0x1
    80006b98:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80006b9c:	00f484b3          	add	s1,s1,a5
    80006ba0:	fffff7b7          	lui	a5,0xfffff
    80006ba4:	00f4f7b3          	and	a5,s1,a5
    80006ba8:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80006bac:	00002637          	lui	a2,0x2
    80006bb0:	00c78633          	add	a2,a5,a2
    80006bb4:	00078593          	mv	a1,a5
    80006bb8:	000b0513          	mv	a0,s6
    80006bbc:	ffffb097          	auipc	ra,0xffffb
    80006bc0:	ff0080e7          	jalr	-16(ra) # 80001bac <uvmalloc>
    80006bc4:	00050c13          	mv	s8,a0
  ip = 0;
    80006bc8:	00000a93          	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80006bcc:	18050263          	beqz	a0,80006d50 <exec+0x3a4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80006bd0:	ffffe5b7          	lui	a1,0xffffe
    80006bd4:	00b505b3          	add	a1,a0,a1
    80006bd8:	000b0513          	mv	a0,s6
    80006bdc:	ffffb097          	auipc	ra,0xffffb
    80006be0:	330080e7          	jalr	816(ra) # 80001f0c <uvmclear>
  stackbase = sp - PGSIZE;
    80006be4:	fffffab7          	lui	s5,0xfffff
    80006be8:	015c0ab3          	add	s5,s8,s5
  for(argc = 0; argv[argc]; argc++) {
    80006bec:	df043783          	ld	a5,-528(s0)
    80006bf0:	0007b503          	ld	a0,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb378>
    80006bf4:	08050463          	beqz	a0,80006c7c <exec+0x2d0>
    80006bf8:	e9040993          	addi	s3,s0,-368
    80006bfc:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80006c00:	000c0913          	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80006c04:	00000493          	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80006c08:	ffffa097          	auipc	ra,0xffffa
    80006c0c:	768080e7          	jalr	1896(ra) # 80001370 <strlen>
    80006c10:	0015079b          	addiw	a5,a0,1
    80006c14:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80006c18:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80006c1c:	17596463          	bltu	s2,s5,80006d84 <exec+0x3d8>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80006c20:	df043d83          	ld	s11,-528(s0)
    80006c24:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80006c28:	000a0513          	mv	a0,s4
    80006c2c:	ffffa097          	auipc	ra,0xffffa
    80006c30:	744080e7          	jalr	1860(ra) # 80001370 <strlen>
    80006c34:	0015069b          	addiw	a3,a0,1
    80006c38:	000a0613          	mv	a2,s4
    80006c3c:	00090593          	mv	a1,s2
    80006c40:	000b0513          	mv	a0,s6
    80006c44:	ffffb097          	auipc	ra,0xffffb
    80006c48:	314080e7          	jalr	788(ra) # 80001f58 <copyout>
    80006c4c:	14054263          	bltz	a0,80006d90 <exec+0x3e4>
    ustack[argc] = sp;
    80006c50:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80006c54:	00148493          	addi	s1,s1,1
    80006c58:	008d8793          	addi	a5,s11,8
    80006c5c:	def43823          	sd	a5,-528(s0)
    80006c60:	008db503          	ld	a0,8(s11)
    80006c64:	02050063          	beqz	a0,80006c84 <exec+0x2d8>
    if(argc >= MAXARG)
    80006c68:	00898993          	addi	s3,s3,8
    80006c6c:	f93c9ee3          	bne	s9,s3,80006c08 <exec+0x25c>
  sz = sz1;
    80006c70:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80006c74:	00000a93          	li	s5,0
    80006c78:	0d80006f          	j	80006d50 <exec+0x3a4>
  sp = sz;
    80006c7c:	000c0913          	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80006c80:	00000493          	li	s1,0
  ustack[argc] = 0;
    80006c84:	00349793          	slli	a5,s1,0x3
    80006c88:	f9040713          	addi	a4,s0,-112
    80006c8c:	00f707b3          	add	a5,a4,a5
    80006c90:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80006c94:	00148693          	addi	a3,s1,1
    80006c98:	00369693          	slli	a3,a3,0x3
    80006c9c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80006ca0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80006ca4:	01597863          	bgeu	s2,s5,80006cb4 <exec+0x308>
  sz = sz1;
    80006ca8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80006cac:	00000a93          	li	s5,0
    80006cb0:	0a00006f          	j	80006d50 <exec+0x3a4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80006cb4:	e9040613          	addi	a2,s0,-368
    80006cb8:	00090593          	mv	a1,s2
    80006cbc:	000b0513          	mv	a0,s6
    80006cc0:	ffffb097          	auipc	ra,0xffffb
    80006cc4:	298080e7          	jalr	664(ra) # 80001f58 <copyout>
    80006cc8:	0c054a63          	bltz	a0,80006d9c <exec+0x3f0>
  p->trapframe->a1 = sp;
    80006ccc:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80006cd0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80006cd4:	de843783          	ld	a5,-536(s0)
    80006cd8:	0007c703          	lbu	a4,0(a5)
    80006cdc:	02070463          	beqz	a4,80006d04 <exec+0x358>
    80006ce0:	00178793          	addi	a5,a5,1
    if(*s == '/')
    80006ce4:	02f00693          	li	a3,47
    80006ce8:	0140006f          	j	80006cfc <exec+0x350>
      last = s+1;
    80006cec:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80006cf0:	00178793          	addi	a5,a5,1
    80006cf4:	fff7c703          	lbu	a4,-1(a5)
    80006cf8:	00070663          	beqz	a4,80006d04 <exec+0x358>
    if(*s == '/')
    80006cfc:	fed71ae3          	bne	a4,a3,80006cf0 <exec+0x344>
    80006d00:	fedff06f          	j	80006cec <exec+0x340>
  safestrcpy(p->name, last, sizeof(p->name));
    80006d04:	01000613          	li	a2,16
    80006d08:	de843583          	ld	a1,-536(s0)
    80006d0c:	158b8513          	addi	a0,s7,344
    80006d10:	ffffa097          	auipc	ra,0xffffa
    80006d14:	614080e7          	jalr	1556(ra) # 80001324 <safestrcpy>
  oldpagetable = p->pagetable;
    80006d18:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80006d1c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80006d20:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80006d24:	058bb783          	ld	a5,88(s7)
    80006d28:	e6843703          	ld	a4,-408(s0)
    80006d2c:	00e7bc23          	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80006d30:	058bb783          	ld	a5,88(s7)
    80006d34:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80006d38:	000d0593          	mv	a1,s10
    80006d3c:	ffffc097          	auipc	ra,0xffffc
    80006d40:	918080e7          	jalr	-1768(ra) # 80002654 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80006d44:	0004851b          	sext.w	a0,s1
    80006d48:	d29ff06f          	j	80006a70 <exec+0xc4>
    80006d4c:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80006d50:	df843583          	ld	a1,-520(s0)
    80006d54:	000b0513          	mv	a0,s6
    80006d58:	ffffc097          	auipc	ra,0xffffc
    80006d5c:	8fc080e7          	jalr	-1796(ra) # 80002654 <proc_freepagetable>
  if(ip){
    80006d60:	ce0a9ce3          	bnez	s5,80006a58 <exec+0xac>
  return -1;
    80006d64:	fff00513          	li	a0,-1
    80006d68:	d09ff06f          	j	80006a70 <exec+0xc4>
    80006d6c:	de943c23          	sd	s1,-520(s0)
    80006d70:	fe1ff06f          	j	80006d50 <exec+0x3a4>
    80006d74:	de943c23          	sd	s1,-520(s0)
    80006d78:	fd9ff06f          	j	80006d50 <exec+0x3a4>
    80006d7c:	de943c23          	sd	s1,-520(s0)
    80006d80:	fd1ff06f          	j	80006d50 <exec+0x3a4>
  sz = sz1;
    80006d84:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80006d88:	00000a93          	li	s5,0
    80006d8c:	fc5ff06f          	j	80006d50 <exec+0x3a4>
  sz = sz1;
    80006d90:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80006d94:	00000a93          	li	s5,0
    80006d98:	fb9ff06f          	j	80006d50 <exec+0x3a4>
  sz = sz1;
    80006d9c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80006da0:	00000a93          	li	s5,0
    80006da4:	fadff06f          	j	80006d50 <exec+0x3a4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80006da8:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006dac:	e0843783          	ld	a5,-504(s0)
    80006db0:	0017869b          	addiw	a3,a5,1
    80006db4:	e0d43423          	sd	a3,-504(s0)
    80006db8:	e0043783          	ld	a5,-512(s0)
    80006dbc:	0387879b          	addiw	a5,a5,56
    80006dc0:	e8845703          	lhu	a4,-376(s0)
    80006dc4:	dae6d4e3          	bge	a3,a4,80006b6c <exec+0x1c0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80006dc8:	0007879b          	sext.w	a5,a5
    80006dcc:	e0f43023          	sd	a5,-512(s0)
    80006dd0:	03800713          	li	a4,56
    80006dd4:	00078693          	mv	a3,a5
    80006dd8:	e1840613          	addi	a2,s0,-488
    80006ddc:	00000593          	li	a1,0
    80006de0:	000a8513          	mv	a0,s5
    80006de4:	ffffe097          	auipc	ra,0xffffe
    80006de8:	134080e7          	jalr	308(ra) # 80004f18 <readi>
    80006dec:	03800793          	li	a5,56
    80006df0:	f4f51ee3          	bne	a0,a5,80006d4c <exec+0x3a0>
    if(ph.type != ELF_PROG_LOAD)
    80006df4:	e1842783          	lw	a5,-488(s0)
    80006df8:	00100713          	li	a4,1
    80006dfc:	fae798e3          	bne	a5,a4,80006dac <exec+0x400>
    if(ph.memsz < ph.filesz)
    80006e00:	e4043603          	ld	a2,-448(s0)
    80006e04:	e3843783          	ld	a5,-456(s0)
    80006e08:	f6f662e3          	bltu	a2,a5,80006d6c <exec+0x3c0>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80006e0c:	e2843783          	ld	a5,-472(s0)
    80006e10:	00f60633          	add	a2,a2,a5
    80006e14:	f6f660e3          	bltu	a2,a5,80006d74 <exec+0x3c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80006e18:	00048593          	mv	a1,s1
    80006e1c:	000b0513          	mv	a0,s6
    80006e20:	ffffb097          	auipc	ra,0xffffb
    80006e24:	d8c080e7          	jalr	-628(ra) # 80001bac <uvmalloc>
    80006e28:	dea43c23          	sd	a0,-520(s0)
    80006e2c:	f40508e3          	beqz	a0,80006d7c <exec+0x3d0>
    if((ph.vaddr % PGSIZE) != 0)
    80006e30:	e2843c03          	ld	s8,-472(s0)
    80006e34:	de043783          	ld	a5,-544(s0)
    80006e38:	00fc77b3          	and	a5,s8,a5
    80006e3c:	f0079ae3          	bnez	a5,80006d50 <exec+0x3a4>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80006e40:	e2042c83          	lw	s9,-480(s0)
    80006e44:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80006e48:	f60b80e3          	beqz	s7,80006da8 <exec+0x3fc>
    80006e4c:	000b8993          	mv	s3,s7
    80006e50:	00000493          	li	s1,0
    80006e54:	ce5ff06f          	j	80006b38 <exec+0x18c>

0000000080006e58 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80006e58:	fd010113          	addi	sp,sp,-48
    80006e5c:	02113423          	sd	ra,40(sp)
    80006e60:	02813023          	sd	s0,32(sp)
    80006e64:	00913c23          	sd	s1,24(sp)
    80006e68:	01213823          	sd	s2,16(sp)
    80006e6c:	03010413          	addi	s0,sp,48
    80006e70:	00058913          	mv	s2,a1
    80006e74:	00060493          	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80006e78:	fdc40593          	addi	a1,s0,-36
    80006e7c:	ffffd097          	auipc	ra,0xffffd
    80006e80:	d18080e7          	jalr	-744(ra) # 80003b94 <argint>
    80006e84:	04054e63          	bltz	a0,80006ee0 <argfd+0x88>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80006e88:	fdc42703          	lw	a4,-36(s0)
    80006e8c:	00f00793          	li	a5,15
    80006e90:	04e7ec63          	bltu	a5,a4,80006ee8 <argfd+0x90>
    80006e94:	ffffb097          	auipc	ra,0xffffb
    80006e98:	5bc080e7          	jalr	1468(ra) # 80002450 <myproc>
    80006e9c:	fdc42703          	lw	a4,-36(s0)
    80006ea0:	01a70793          	addi	a5,a4,26
    80006ea4:	00379793          	slli	a5,a5,0x3
    80006ea8:	00f50533          	add	a0,a0,a5
    80006eac:	00053783          	ld	a5,0(a0)
    80006eb0:	04078063          	beqz	a5,80006ef0 <argfd+0x98>
    return -1;
  if(pfd)
    80006eb4:	00090463          	beqz	s2,80006ebc <argfd+0x64>
    *pfd = fd;
    80006eb8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80006ebc:	00000513          	li	a0,0
  if(pf)
    80006ec0:	00048463          	beqz	s1,80006ec8 <argfd+0x70>
    *pf = f;
    80006ec4:	00f4b023          	sd	a5,0(s1)
}
    80006ec8:	02813083          	ld	ra,40(sp)
    80006ecc:	02013403          	ld	s0,32(sp)
    80006ed0:	01813483          	ld	s1,24(sp)
    80006ed4:	01013903          	ld	s2,16(sp)
    80006ed8:	03010113          	addi	sp,sp,48
    80006edc:	00008067          	ret
    return -1;
    80006ee0:	fff00513          	li	a0,-1
    80006ee4:	fe5ff06f          	j	80006ec8 <argfd+0x70>
    return -1;
    80006ee8:	fff00513          	li	a0,-1
    80006eec:	fddff06f          	j	80006ec8 <argfd+0x70>
    80006ef0:	fff00513          	li	a0,-1
    80006ef4:	fd5ff06f          	j	80006ec8 <argfd+0x70>

0000000080006ef8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80006ef8:	fe010113          	addi	sp,sp,-32
    80006efc:	00113c23          	sd	ra,24(sp)
    80006f00:	00813823          	sd	s0,16(sp)
    80006f04:	00913423          	sd	s1,8(sp)
    80006f08:	02010413          	addi	s0,sp,32
    80006f0c:	00050493          	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80006f10:	ffffb097          	auipc	ra,0xffffb
    80006f14:	540080e7          	jalr	1344(ra) # 80002450 <myproc>
    80006f18:	00050613          	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80006f1c:	0d050793          	addi	a5,a0,208
    80006f20:	00000513          	li	a0,0
    80006f24:	01000693          	li	a3,16
    if(p->ofile[fd] == 0){
    80006f28:	0007b703          	ld	a4,0(a5)
    80006f2c:	02070463          	beqz	a4,80006f54 <fdalloc+0x5c>
  for(fd = 0; fd < NOFILE; fd++){
    80006f30:	0015051b          	addiw	a0,a0,1
    80006f34:	00878793          	addi	a5,a5,8
    80006f38:	fed518e3          	bne	a0,a3,80006f28 <fdalloc+0x30>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80006f3c:	fff00513          	li	a0,-1
}
    80006f40:	01813083          	ld	ra,24(sp)
    80006f44:	01013403          	ld	s0,16(sp)
    80006f48:	00813483          	ld	s1,8(sp)
    80006f4c:	02010113          	addi	sp,sp,32
    80006f50:	00008067          	ret
      p->ofile[fd] = f;
    80006f54:	01a50793          	addi	a5,a0,26
    80006f58:	00379793          	slli	a5,a5,0x3
    80006f5c:	00f60633          	add	a2,a2,a5
    80006f60:	00963023          	sd	s1,0(a2) # 2000 <_entry-0x7fffe000>
      return fd;
    80006f64:	fddff06f          	j	80006f40 <fdalloc+0x48>

0000000080006f68 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80006f68:	fb010113          	addi	sp,sp,-80
    80006f6c:	04113423          	sd	ra,72(sp)
    80006f70:	04813023          	sd	s0,64(sp)
    80006f74:	02913c23          	sd	s1,56(sp)
    80006f78:	03213823          	sd	s2,48(sp)
    80006f7c:	03313423          	sd	s3,40(sp)
    80006f80:	03413023          	sd	s4,32(sp)
    80006f84:	01513c23          	sd	s5,24(sp)
    80006f88:	05010413          	addi	s0,sp,80
    80006f8c:	00058993          	mv	s3,a1
    80006f90:	00060a93          	mv	s5,a2
    80006f94:	00068a13          	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80006f98:	fb040593          	addi	a1,s0,-80
    80006f9c:	ffffe097          	auipc	ra,0xffffe
    80006fa0:	6e8080e7          	jalr	1768(ra) # 80005684 <nameiparent>
    80006fa4:	00050913          	mv	s2,a0
    80006fa8:	18050663          	beqz	a0,80007134 <create+0x1cc>
    return 0;

  ilock(dp);
    80006fac:	ffffe097          	auipc	ra,0xffffe
    80006fb0:	bb0080e7          	jalr	-1104(ra) # 80004b5c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80006fb4:	00000613          	li	a2,0
    80006fb8:	fb040593          	addi	a1,s0,-80
    80006fbc:	00090513          	mv	a0,s2
    80006fc0:	ffffe097          	auipc	ra,0xffffe
    80006fc4:	290080e7          	jalr	656(ra) # 80005250 <dirlookup>
    80006fc8:	00050493          	mv	s1,a0
    80006fcc:	06050e63          	beqz	a0,80007048 <create+0xe0>
    iunlockput(dp);
    80006fd0:	00090513          	mv	a0,s2
    80006fd4:	ffffe097          	auipc	ra,0xffffe
    80006fd8:	ec4080e7          	jalr	-316(ra) # 80004e98 <iunlockput>
    ilock(ip);
    80006fdc:	00048513          	mv	a0,s1
    80006fe0:	ffffe097          	auipc	ra,0xffffe
    80006fe4:	b7c080e7          	jalr	-1156(ra) # 80004b5c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80006fe8:	0009899b          	sext.w	s3,s3
    80006fec:	00200793          	li	a5,2
    80006ff0:	04f99263          	bne	s3,a5,80007034 <create+0xcc>
    80006ff4:	0444d783          	lhu	a5,68(s1)
    80006ff8:	ffe7879b          	addiw	a5,a5,-2
    80006ffc:	03079793          	slli	a5,a5,0x30
    80007000:	0307d793          	srli	a5,a5,0x30
    80007004:	00100713          	li	a4,1
    80007008:	02f76663          	bltu	a4,a5,80007034 <create+0xcc>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000700c:	00048513          	mv	a0,s1
    80007010:	04813083          	ld	ra,72(sp)
    80007014:	04013403          	ld	s0,64(sp)
    80007018:	03813483          	ld	s1,56(sp)
    8000701c:	03013903          	ld	s2,48(sp)
    80007020:	02813983          	ld	s3,40(sp)
    80007024:	02013a03          	ld	s4,32(sp)
    80007028:	01813a83          	ld	s5,24(sp)
    8000702c:	05010113          	addi	sp,sp,80
    80007030:	00008067          	ret
    iunlockput(ip);
    80007034:	00048513          	mv	a0,s1
    80007038:	ffffe097          	auipc	ra,0xffffe
    8000703c:	e60080e7          	jalr	-416(ra) # 80004e98 <iunlockput>
    return 0;
    80007040:	00000493          	li	s1,0
    80007044:	fc9ff06f          	j	8000700c <create+0xa4>
  if((ip = ialloc(dp->dev, type)) == 0)
    80007048:	00098593          	mv	a1,s3
    8000704c:	00092503          	lw	a0,0(s2)
    80007050:	ffffe097          	auipc	ra,0xffffe
    80007054:	8d4080e7          	jalr	-1836(ra) # 80004924 <ialloc>
    80007058:	00050493          	mv	s1,a0
    8000705c:	04050c63          	beqz	a0,800070b4 <create+0x14c>
  ilock(ip);
    80007060:	ffffe097          	auipc	ra,0xffffe
    80007064:	afc080e7          	jalr	-1284(ra) # 80004b5c <ilock>
  ip->major = major;
    80007068:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000706c:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80007070:	00100a13          	li	s4,1
    80007074:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80007078:	00048513          	mv	a0,s1
    8000707c:	ffffe097          	auipc	ra,0xffffe
    80007080:	9c4080e7          	jalr	-1596(ra) # 80004a40 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80007084:	0009899b          	sext.w	s3,s3
    80007088:	03498e63          	beq	s3,s4,800070c4 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000708c:	0044a603          	lw	a2,4(s1)
    80007090:	fb040593          	addi	a1,s0,-80
    80007094:	00090513          	mv	a0,s2
    80007098:	ffffe097          	auipc	ra,0xffffe
    8000709c:	4a8080e7          	jalr	1192(ra) # 80005540 <dirlink>
    800070a0:	08054263          	bltz	a0,80007124 <create+0x1bc>
  iunlockput(dp);
    800070a4:	00090513          	mv	a0,s2
    800070a8:	ffffe097          	auipc	ra,0xffffe
    800070ac:	df0080e7          	jalr	-528(ra) # 80004e98 <iunlockput>
  return ip;
    800070b0:	f5dff06f          	j	8000700c <create+0xa4>
    panic("create: ialloc");
    800070b4:	00003517          	auipc	a0,0x3
    800070b8:	69450513          	addi	a0,a0,1684 # 8000a748 <syscalls+0x300>
    800070bc:	ffff9097          	auipc	ra,0xffff9
    800070c0:	610080e7          	jalr	1552(ra) # 800006cc <panic>
    dp->nlink++;  // for ".."
    800070c4:	04a95783          	lhu	a5,74(s2)
    800070c8:	0017879b          	addiw	a5,a5,1
    800070cc:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800070d0:	00090513          	mv	a0,s2
    800070d4:	ffffe097          	auipc	ra,0xffffe
    800070d8:	96c080e7          	jalr	-1684(ra) # 80004a40 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800070dc:	0044a603          	lw	a2,4(s1)
    800070e0:	00003597          	auipc	a1,0x3
    800070e4:	67858593          	addi	a1,a1,1656 # 8000a758 <syscalls+0x310>
    800070e8:	00048513          	mv	a0,s1
    800070ec:	ffffe097          	auipc	ra,0xffffe
    800070f0:	454080e7          	jalr	1108(ra) # 80005540 <dirlink>
    800070f4:	02054063          	bltz	a0,80007114 <create+0x1ac>
    800070f8:	00492603          	lw	a2,4(s2)
    800070fc:	00003597          	auipc	a1,0x3
    80007100:	66458593          	addi	a1,a1,1636 # 8000a760 <syscalls+0x318>
    80007104:	00048513          	mv	a0,s1
    80007108:	ffffe097          	auipc	ra,0xffffe
    8000710c:	438080e7          	jalr	1080(ra) # 80005540 <dirlink>
    80007110:	f6055ee3          	bgez	a0,8000708c <create+0x124>
      panic("create dots");
    80007114:	00003517          	auipc	a0,0x3
    80007118:	65450513          	addi	a0,a0,1620 # 8000a768 <syscalls+0x320>
    8000711c:	ffff9097          	auipc	ra,0xffff9
    80007120:	5b0080e7          	jalr	1456(ra) # 800006cc <panic>
    panic("create: dirlink");
    80007124:	00003517          	auipc	a0,0x3
    80007128:	65450513          	addi	a0,a0,1620 # 8000a778 <syscalls+0x330>
    8000712c:	ffff9097          	auipc	ra,0xffff9
    80007130:	5a0080e7          	jalr	1440(ra) # 800006cc <panic>
    return 0;
    80007134:	00050493          	mv	s1,a0
    80007138:	ed5ff06f          	j	8000700c <create+0xa4>

000000008000713c <sys_dup>:
{
    8000713c:	fd010113          	addi	sp,sp,-48
    80007140:	02113423          	sd	ra,40(sp)
    80007144:	02813023          	sd	s0,32(sp)
    80007148:	00913c23          	sd	s1,24(sp)
    8000714c:	03010413          	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80007150:	fd840613          	addi	a2,s0,-40
    80007154:	00000593          	li	a1,0
    80007158:	00000513          	li	a0,0
    8000715c:	00000097          	auipc	ra,0x0
    80007160:	cfc080e7          	jalr	-772(ra) # 80006e58 <argfd>
    return -1;
    80007164:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80007168:	02054663          	bltz	a0,80007194 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
    8000716c:	fd843503          	ld	a0,-40(s0)
    80007170:	00000097          	auipc	ra,0x0
    80007174:	d88080e7          	jalr	-632(ra) # 80006ef8 <fdalloc>
    80007178:	00050493          	mv	s1,a0
    return -1;
    8000717c:	fff00793          	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80007180:	00054a63          	bltz	a0,80007194 <sys_dup+0x58>
  filedup(f);
    80007184:	fd843503          	ld	a0,-40(s0)
    80007188:	fffff097          	auipc	ra,0xfffff
    8000718c:	dd8080e7          	jalr	-552(ra) # 80005f60 <filedup>
  return fd;
    80007190:	00048793          	mv	a5,s1
}
    80007194:	00078513          	mv	a0,a5
    80007198:	02813083          	ld	ra,40(sp)
    8000719c:	02013403          	ld	s0,32(sp)
    800071a0:	01813483          	ld	s1,24(sp)
    800071a4:	03010113          	addi	sp,sp,48
    800071a8:	00008067          	ret

00000000800071ac <sys_read>:
{
    800071ac:	fd010113          	addi	sp,sp,-48
    800071b0:	02113423          	sd	ra,40(sp)
    800071b4:	02813023          	sd	s0,32(sp)
    800071b8:	03010413          	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800071bc:	fe840613          	addi	a2,s0,-24
    800071c0:	00000593          	li	a1,0
    800071c4:	00000513          	li	a0,0
    800071c8:	00000097          	auipc	ra,0x0
    800071cc:	c90080e7          	jalr	-880(ra) # 80006e58 <argfd>
    return -1;
    800071d0:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800071d4:	04054663          	bltz	a0,80007220 <sys_read+0x74>
    800071d8:	fe440593          	addi	a1,s0,-28
    800071dc:	00200513          	li	a0,2
    800071e0:	ffffd097          	auipc	ra,0xffffd
    800071e4:	9b4080e7          	jalr	-1612(ra) # 80003b94 <argint>
    return -1;
    800071e8:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800071ec:	02054a63          	bltz	a0,80007220 <sys_read+0x74>
    800071f0:	fd840593          	addi	a1,s0,-40
    800071f4:	00100513          	li	a0,1
    800071f8:	ffffd097          	auipc	ra,0xffffd
    800071fc:	9d8080e7          	jalr	-1576(ra) # 80003bd0 <argaddr>
    return -1;
    80007200:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80007204:	00054e63          	bltz	a0,80007220 <sys_read+0x74>
  return fileread(f, p, n);
    80007208:	fe442603          	lw	a2,-28(s0)
    8000720c:	fd843583          	ld	a1,-40(s0)
    80007210:	fe843503          	ld	a0,-24(s0)
    80007214:	fffff097          	auipc	ra,0xfffff
    80007218:	f68080e7          	jalr	-152(ra) # 8000617c <fileread>
    8000721c:	00050793          	mv	a5,a0
}
    80007220:	00078513          	mv	a0,a5
    80007224:	02813083          	ld	ra,40(sp)
    80007228:	02013403          	ld	s0,32(sp)
    8000722c:	03010113          	addi	sp,sp,48
    80007230:	00008067          	ret

0000000080007234 <sys_write>:
{
    80007234:	fd010113          	addi	sp,sp,-48
    80007238:	02113423          	sd	ra,40(sp)
    8000723c:	02813023          	sd	s0,32(sp)
    80007240:	03010413          	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80007244:	fe840613          	addi	a2,s0,-24
    80007248:	00000593          	li	a1,0
    8000724c:	00000513          	li	a0,0
    80007250:	00000097          	auipc	ra,0x0
    80007254:	c08080e7          	jalr	-1016(ra) # 80006e58 <argfd>
    return -1;
    80007258:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000725c:	04054663          	bltz	a0,800072a8 <sys_write+0x74>
    80007260:	fe440593          	addi	a1,s0,-28
    80007264:	00200513          	li	a0,2
    80007268:	ffffd097          	auipc	ra,0xffffd
    8000726c:	92c080e7          	jalr	-1748(ra) # 80003b94 <argint>
    return -1;
    80007270:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80007274:	02054a63          	bltz	a0,800072a8 <sys_write+0x74>
    80007278:	fd840593          	addi	a1,s0,-40
    8000727c:	00100513          	li	a0,1
    80007280:	ffffd097          	auipc	ra,0xffffd
    80007284:	950080e7          	jalr	-1712(ra) # 80003bd0 <argaddr>
    return -1;
    80007288:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000728c:	00054e63          	bltz	a0,800072a8 <sys_write+0x74>
  return filewrite(f, p, n);
    80007290:	fe442603          	lw	a2,-28(s0)
    80007294:	fd843583          	ld	a1,-40(s0)
    80007298:	fe843503          	ld	a0,-24(s0)
    8000729c:	fffff097          	auipc	ra,0xfffff
    800072a0:	00c080e7          	jalr	12(ra) # 800062a8 <filewrite>
    800072a4:	00050793          	mv	a5,a0
}
    800072a8:	00078513          	mv	a0,a5
    800072ac:	02813083          	ld	ra,40(sp)
    800072b0:	02013403          	ld	s0,32(sp)
    800072b4:	03010113          	addi	sp,sp,48
    800072b8:	00008067          	ret

00000000800072bc <sys_close>:
{
    800072bc:	fe010113          	addi	sp,sp,-32
    800072c0:	00113c23          	sd	ra,24(sp)
    800072c4:	00813823          	sd	s0,16(sp)
    800072c8:	02010413          	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800072cc:	fe040613          	addi	a2,s0,-32
    800072d0:	fec40593          	addi	a1,s0,-20
    800072d4:	00000513          	li	a0,0
    800072d8:	00000097          	auipc	ra,0x0
    800072dc:	b80080e7          	jalr	-1152(ra) # 80006e58 <argfd>
    return -1;
    800072e0:	fff00793          	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800072e4:	02054863          	bltz	a0,80007314 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
    800072e8:	ffffb097          	auipc	ra,0xffffb
    800072ec:	168080e7          	jalr	360(ra) # 80002450 <myproc>
    800072f0:	fec42783          	lw	a5,-20(s0)
    800072f4:	01a78793          	addi	a5,a5,26
    800072f8:	00379793          	slli	a5,a5,0x3
    800072fc:	00f507b3          	add	a5,a0,a5
    80007300:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80007304:	fe043503          	ld	a0,-32(s0)
    80007308:	fffff097          	auipc	ra,0xfffff
    8000730c:	cc8080e7          	jalr	-824(ra) # 80005fd0 <fileclose>
  return 0;
    80007310:	00000793          	li	a5,0
}
    80007314:	00078513          	mv	a0,a5
    80007318:	01813083          	ld	ra,24(sp)
    8000731c:	01013403          	ld	s0,16(sp)
    80007320:	02010113          	addi	sp,sp,32
    80007324:	00008067          	ret

0000000080007328 <sys_fstat>:
{
    80007328:	fe010113          	addi	sp,sp,-32
    8000732c:	00113c23          	sd	ra,24(sp)
    80007330:	00813823          	sd	s0,16(sp)
    80007334:	02010413          	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80007338:	fe840613          	addi	a2,s0,-24
    8000733c:	00000593          	li	a1,0
    80007340:	00000513          	li	a0,0
    80007344:	00000097          	auipc	ra,0x0
    80007348:	b14080e7          	jalr	-1260(ra) # 80006e58 <argfd>
    return -1;
    8000734c:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80007350:	02054863          	bltz	a0,80007380 <sys_fstat+0x58>
    80007354:	fe040593          	addi	a1,s0,-32
    80007358:	00100513          	li	a0,1
    8000735c:	ffffd097          	auipc	ra,0xffffd
    80007360:	874080e7          	jalr	-1932(ra) # 80003bd0 <argaddr>
    return -1;
    80007364:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80007368:	00054c63          	bltz	a0,80007380 <sys_fstat+0x58>
  return filestat(f, st);
    8000736c:	fe043583          	ld	a1,-32(s0)
    80007370:	fe843503          	ld	a0,-24(s0)
    80007374:	fffff097          	auipc	ra,0xfffff
    80007378:	d60080e7          	jalr	-672(ra) # 800060d4 <filestat>
    8000737c:	00050793          	mv	a5,a0
}
    80007380:	00078513          	mv	a0,a5
    80007384:	01813083          	ld	ra,24(sp)
    80007388:	01013403          	ld	s0,16(sp)
    8000738c:	02010113          	addi	sp,sp,32
    80007390:	00008067          	ret

0000000080007394 <sys_link>:
{
    80007394:	ed010113          	addi	sp,sp,-304
    80007398:	12113423          	sd	ra,296(sp)
    8000739c:	12813023          	sd	s0,288(sp)
    800073a0:	10913c23          	sd	s1,280(sp)
    800073a4:	11213823          	sd	s2,272(sp)
    800073a8:	13010413          	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800073ac:	08000613          	li	a2,128
    800073b0:	ed040593          	addi	a1,s0,-304
    800073b4:	00000513          	li	a0,0
    800073b8:	ffffd097          	auipc	ra,0xffffd
    800073bc:	854080e7          	jalr	-1964(ra) # 80003c0c <argstr>
    return -1;
    800073c0:	fff00793          	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800073c4:	14054a63          	bltz	a0,80007518 <sys_link+0x184>
    800073c8:	08000613          	li	a2,128
    800073cc:	f5040593          	addi	a1,s0,-176
    800073d0:	00100513          	li	a0,1
    800073d4:	ffffd097          	auipc	ra,0xffffd
    800073d8:	838080e7          	jalr	-1992(ra) # 80003c0c <argstr>
    return -1;
    800073dc:	fff00793          	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800073e0:	12054c63          	bltz	a0,80007518 <sys_link+0x184>
  begin_op();
    800073e4:	ffffe097          	auipc	ra,0xffffe
    800073e8:	560080e7          	jalr	1376(ra) # 80005944 <begin_op>
  if((ip = namei(old)) == 0){
    800073ec:	ed040513          	addi	a0,s0,-304
    800073f0:	ffffe097          	auipc	ra,0xffffe
    800073f4:	264080e7          	jalr	612(ra) # 80005654 <namei>
    800073f8:	00050493          	mv	s1,a0
    800073fc:	0a050463          	beqz	a0,800074a4 <sys_link+0x110>
  ilock(ip);
    80007400:	ffffd097          	auipc	ra,0xffffd
    80007404:	75c080e7          	jalr	1884(ra) # 80004b5c <ilock>
  if(ip->type == T_DIR){
    80007408:	04449703          	lh	a4,68(s1)
    8000740c:	00100793          	li	a5,1
    80007410:	0af70263          	beq	a4,a5,800074b4 <sys_link+0x120>
  ip->nlink++;
    80007414:	04a4d783          	lhu	a5,74(s1)
    80007418:	0017879b          	addiw	a5,a5,1
    8000741c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80007420:	00048513          	mv	a0,s1
    80007424:	ffffd097          	auipc	ra,0xffffd
    80007428:	61c080e7          	jalr	1564(ra) # 80004a40 <iupdate>
  iunlock(ip);
    8000742c:	00048513          	mv	a0,s1
    80007430:	ffffe097          	auipc	ra,0xffffe
    80007434:	830080e7          	jalr	-2000(ra) # 80004c60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80007438:	fd040593          	addi	a1,s0,-48
    8000743c:	f5040513          	addi	a0,s0,-176
    80007440:	ffffe097          	auipc	ra,0xffffe
    80007444:	244080e7          	jalr	580(ra) # 80005684 <nameiparent>
    80007448:	00050913          	mv	s2,a0
    8000744c:	08050863          	beqz	a0,800074dc <sys_link+0x148>
  ilock(dp);
    80007450:	ffffd097          	auipc	ra,0xffffd
    80007454:	70c080e7          	jalr	1804(ra) # 80004b5c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80007458:	00092703          	lw	a4,0(s2)
    8000745c:	0004a783          	lw	a5,0(s1)
    80007460:	06f71863          	bne	a4,a5,800074d0 <sys_link+0x13c>
    80007464:	0044a603          	lw	a2,4(s1)
    80007468:	fd040593          	addi	a1,s0,-48
    8000746c:	00090513          	mv	a0,s2
    80007470:	ffffe097          	auipc	ra,0xffffe
    80007474:	0d0080e7          	jalr	208(ra) # 80005540 <dirlink>
    80007478:	04054c63          	bltz	a0,800074d0 <sys_link+0x13c>
  iunlockput(dp);
    8000747c:	00090513          	mv	a0,s2
    80007480:	ffffe097          	auipc	ra,0xffffe
    80007484:	a18080e7          	jalr	-1512(ra) # 80004e98 <iunlockput>
  iput(ip);
    80007488:	00048513          	mv	a0,s1
    8000748c:	ffffe097          	auipc	ra,0xffffe
    80007490:	930080e7          	jalr	-1744(ra) # 80004dbc <iput>
  end_op();
    80007494:	ffffe097          	auipc	ra,0xffffe
    80007498:	564080e7          	jalr	1380(ra) # 800059f8 <end_op>
  return 0;
    8000749c:	00000793          	li	a5,0
    800074a0:	0780006f          	j	80007518 <sys_link+0x184>
    end_op();
    800074a4:	ffffe097          	auipc	ra,0xffffe
    800074a8:	554080e7          	jalr	1364(ra) # 800059f8 <end_op>
    return -1;
    800074ac:	fff00793          	li	a5,-1
    800074b0:	0680006f          	j	80007518 <sys_link+0x184>
    iunlockput(ip);
    800074b4:	00048513          	mv	a0,s1
    800074b8:	ffffe097          	auipc	ra,0xffffe
    800074bc:	9e0080e7          	jalr	-1568(ra) # 80004e98 <iunlockput>
    end_op();
    800074c0:	ffffe097          	auipc	ra,0xffffe
    800074c4:	538080e7          	jalr	1336(ra) # 800059f8 <end_op>
    return -1;
    800074c8:	fff00793          	li	a5,-1
    800074cc:	04c0006f          	j	80007518 <sys_link+0x184>
    iunlockput(dp);
    800074d0:	00090513          	mv	a0,s2
    800074d4:	ffffe097          	auipc	ra,0xffffe
    800074d8:	9c4080e7          	jalr	-1596(ra) # 80004e98 <iunlockput>
  ilock(ip);
    800074dc:	00048513          	mv	a0,s1
    800074e0:	ffffd097          	auipc	ra,0xffffd
    800074e4:	67c080e7          	jalr	1660(ra) # 80004b5c <ilock>
  ip->nlink--;
    800074e8:	04a4d783          	lhu	a5,74(s1)
    800074ec:	fff7879b          	addiw	a5,a5,-1
    800074f0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800074f4:	00048513          	mv	a0,s1
    800074f8:	ffffd097          	auipc	ra,0xffffd
    800074fc:	548080e7          	jalr	1352(ra) # 80004a40 <iupdate>
  iunlockput(ip);
    80007500:	00048513          	mv	a0,s1
    80007504:	ffffe097          	auipc	ra,0xffffe
    80007508:	994080e7          	jalr	-1644(ra) # 80004e98 <iunlockput>
  end_op();
    8000750c:	ffffe097          	auipc	ra,0xffffe
    80007510:	4ec080e7          	jalr	1260(ra) # 800059f8 <end_op>
  return -1;
    80007514:	fff00793          	li	a5,-1
}
    80007518:	00078513          	mv	a0,a5
    8000751c:	12813083          	ld	ra,296(sp)
    80007520:	12013403          	ld	s0,288(sp)
    80007524:	11813483          	ld	s1,280(sp)
    80007528:	11013903          	ld	s2,272(sp)
    8000752c:	13010113          	addi	sp,sp,304
    80007530:	00008067          	ret

0000000080007534 <sys_unlink>:
{
    80007534:	f1010113          	addi	sp,sp,-240
    80007538:	0e113423          	sd	ra,232(sp)
    8000753c:	0e813023          	sd	s0,224(sp)
    80007540:	0c913c23          	sd	s1,216(sp)
    80007544:	0d213823          	sd	s2,208(sp)
    80007548:	0d313423          	sd	s3,200(sp)
    8000754c:	0f010413          	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80007550:	08000613          	li	a2,128
    80007554:	f3040593          	addi	a1,s0,-208
    80007558:	00000513          	li	a0,0
    8000755c:	ffffc097          	auipc	ra,0xffffc
    80007560:	6b0080e7          	jalr	1712(ra) # 80003c0c <argstr>
    80007564:	1c054063          	bltz	a0,80007724 <sys_unlink+0x1f0>
  begin_op();
    80007568:	ffffe097          	auipc	ra,0xffffe
    8000756c:	3dc080e7          	jalr	988(ra) # 80005944 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80007570:	fb040593          	addi	a1,s0,-80
    80007574:	f3040513          	addi	a0,s0,-208
    80007578:	ffffe097          	auipc	ra,0xffffe
    8000757c:	10c080e7          	jalr	268(ra) # 80005684 <nameiparent>
    80007580:	00050493          	mv	s1,a0
    80007584:	0e050c63          	beqz	a0,8000767c <sys_unlink+0x148>
  ilock(dp);
    80007588:	ffffd097          	auipc	ra,0xffffd
    8000758c:	5d4080e7          	jalr	1492(ra) # 80004b5c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80007590:	00003597          	auipc	a1,0x3
    80007594:	1c858593          	addi	a1,a1,456 # 8000a758 <syscalls+0x310>
    80007598:	fb040513          	addi	a0,s0,-80
    8000759c:	ffffe097          	auipc	ra,0xffffe
    800075a0:	c88080e7          	jalr	-888(ra) # 80005224 <namecmp>
    800075a4:	18050a63          	beqz	a0,80007738 <sys_unlink+0x204>
    800075a8:	00003597          	auipc	a1,0x3
    800075ac:	1b858593          	addi	a1,a1,440 # 8000a760 <syscalls+0x318>
    800075b0:	fb040513          	addi	a0,s0,-80
    800075b4:	ffffe097          	auipc	ra,0xffffe
    800075b8:	c70080e7          	jalr	-912(ra) # 80005224 <namecmp>
    800075bc:	16050e63          	beqz	a0,80007738 <sys_unlink+0x204>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800075c0:	f2c40613          	addi	a2,s0,-212
    800075c4:	fb040593          	addi	a1,s0,-80
    800075c8:	00048513          	mv	a0,s1
    800075cc:	ffffe097          	auipc	ra,0xffffe
    800075d0:	c84080e7          	jalr	-892(ra) # 80005250 <dirlookup>
    800075d4:	00050913          	mv	s2,a0
    800075d8:	16050063          	beqz	a0,80007738 <sys_unlink+0x204>
  ilock(ip);
    800075dc:	ffffd097          	auipc	ra,0xffffd
    800075e0:	580080e7          	jalr	1408(ra) # 80004b5c <ilock>
  if(ip->nlink < 1)
    800075e4:	04a91783          	lh	a5,74(s2)
    800075e8:	0af05263          	blez	a5,8000768c <sys_unlink+0x158>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800075ec:	04491703          	lh	a4,68(s2)
    800075f0:	00100793          	li	a5,1
    800075f4:	0af70463          	beq	a4,a5,8000769c <sys_unlink+0x168>
  memset(&de, 0, sizeof(de));
    800075f8:	01000613          	li	a2,16
    800075fc:	00000593          	li	a1,0
    80007600:	fc040513          	addi	a0,s0,-64
    80007604:	ffffa097          	auipc	ra,0xffffa
    80007608:	b20080e7          	jalr	-1248(ra) # 80001124 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000760c:	01000713          	li	a4,16
    80007610:	f2c42683          	lw	a3,-212(s0)
    80007614:	fc040613          	addi	a2,s0,-64
    80007618:	00000593          	li	a1,0
    8000761c:	00048513          	mv	a0,s1
    80007620:	ffffe097          	auipc	ra,0xffffe
    80007624:	a68080e7          	jalr	-1432(ra) # 80005088 <writei>
    80007628:	01000793          	li	a5,16
    8000762c:	0cf51663          	bne	a0,a5,800076f8 <sys_unlink+0x1c4>
  if(ip->type == T_DIR){
    80007630:	04491703          	lh	a4,68(s2)
    80007634:	00100793          	li	a5,1
    80007638:	0cf70863          	beq	a4,a5,80007708 <sys_unlink+0x1d4>
  iunlockput(dp);
    8000763c:	00048513          	mv	a0,s1
    80007640:	ffffe097          	auipc	ra,0xffffe
    80007644:	858080e7          	jalr	-1960(ra) # 80004e98 <iunlockput>
  ip->nlink--;
    80007648:	04a95783          	lhu	a5,74(s2)
    8000764c:	fff7879b          	addiw	a5,a5,-1
    80007650:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80007654:	00090513          	mv	a0,s2
    80007658:	ffffd097          	auipc	ra,0xffffd
    8000765c:	3e8080e7          	jalr	1000(ra) # 80004a40 <iupdate>
  iunlockput(ip);
    80007660:	00090513          	mv	a0,s2
    80007664:	ffffe097          	auipc	ra,0xffffe
    80007668:	834080e7          	jalr	-1996(ra) # 80004e98 <iunlockput>
  end_op();
    8000766c:	ffffe097          	auipc	ra,0xffffe
    80007670:	38c080e7          	jalr	908(ra) # 800059f8 <end_op>
  return 0;
    80007674:	00000513          	li	a0,0
    80007678:	0d80006f          	j	80007750 <sys_unlink+0x21c>
    end_op();
    8000767c:	ffffe097          	auipc	ra,0xffffe
    80007680:	37c080e7          	jalr	892(ra) # 800059f8 <end_op>
    return -1;
    80007684:	fff00513          	li	a0,-1
    80007688:	0c80006f          	j	80007750 <sys_unlink+0x21c>
    panic("unlink: nlink < 1");
    8000768c:	00003517          	auipc	a0,0x3
    80007690:	0fc50513          	addi	a0,a0,252 # 8000a788 <syscalls+0x340>
    80007694:	ffff9097          	auipc	ra,0xffff9
    80007698:	038080e7          	jalr	56(ra) # 800006cc <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000769c:	04c92703          	lw	a4,76(s2)
    800076a0:	02000793          	li	a5,32
    800076a4:	f4e7fae3          	bgeu	a5,a4,800075f8 <sys_unlink+0xc4>
    800076a8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800076ac:	01000713          	li	a4,16
    800076b0:	00098693          	mv	a3,s3
    800076b4:	f1840613          	addi	a2,s0,-232
    800076b8:	00000593          	li	a1,0
    800076bc:	00090513          	mv	a0,s2
    800076c0:	ffffe097          	auipc	ra,0xffffe
    800076c4:	858080e7          	jalr	-1960(ra) # 80004f18 <readi>
    800076c8:	01000793          	li	a5,16
    800076cc:	00f51e63          	bne	a0,a5,800076e8 <sys_unlink+0x1b4>
    if(de.inum != 0)
    800076d0:	f1845783          	lhu	a5,-232(s0)
    800076d4:	04079c63          	bnez	a5,8000772c <sys_unlink+0x1f8>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800076d8:	0109899b          	addiw	s3,s3,16
    800076dc:	04c92783          	lw	a5,76(s2)
    800076e0:	fcf9e6e3          	bltu	s3,a5,800076ac <sys_unlink+0x178>
    800076e4:	f15ff06f          	j	800075f8 <sys_unlink+0xc4>
      panic("isdirempty: readi");
    800076e8:	00003517          	auipc	a0,0x3
    800076ec:	0b850513          	addi	a0,a0,184 # 8000a7a0 <syscalls+0x358>
    800076f0:	ffff9097          	auipc	ra,0xffff9
    800076f4:	fdc080e7          	jalr	-36(ra) # 800006cc <panic>
    panic("unlink: writei");
    800076f8:	00003517          	auipc	a0,0x3
    800076fc:	0c050513          	addi	a0,a0,192 # 8000a7b8 <syscalls+0x370>
    80007700:	ffff9097          	auipc	ra,0xffff9
    80007704:	fcc080e7          	jalr	-52(ra) # 800006cc <panic>
    dp->nlink--;
    80007708:	04a4d783          	lhu	a5,74(s1)
    8000770c:	fff7879b          	addiw	a5,a5,-1
    80007710:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80007714:	00048513          	mv	a0,s1
    80007718:	ffffd097          	auipc	ra,0xffffd
    8000771c:	328080e7          	jalr	808(ra) # 80004a40 <iupdate>
    80007720:	f1dff06f          	j	8000763c <sys_unlink+0x108>
    return -1;
    80007724:	fff00513          	li	a0,-1
    80007728:	0280006f          	j	80007750 <sys_unlink+0x21c>
    iunlockput(ip);
    8000772c:	00090513          	mv	a0,s2
    80007730:	ffffd097          	auipc	ra,0xffffd
    80007734:	768080e7          	jalr	1896(ra) # 80004e98 <iunlockput>
  iunlockput(dp);
    80007738:	00048513          	mv	a0,s1
    8000773c:	ffffd097          	auipc	ra,0xffffd
    80007740:	75c080e7          	jalr	1884(ra) # 80004e98 <iunlockput>
  end_op();
    80007744:	ffffe097          	auipc	ra,0xffffe
    80007748:	2b4080e7          	jalr	692(ra) # 800059f8 <end_op>
  return -1;
    8000774c:	fff00513          	li	a0,-1
}
    80007750:	0e813083          	ld	ra,232(sp)
    80007754:	0e013403          	ld	s0,224(sp)
    80007758:	0d813483          	ld	s1,216(sp)
    8000775c:	0d013903          	ld	s2,208(sp)
    80007760:	0c813983          	ld	s3,200(sp)
    80007764:	0f010113          	addi	sp,sp,240
    80007768:	00008067          	ret

000000008000776c <sys_open>:

uint64
sys_open(void)
{
    8000776c:	f4010113          	addi	sp,sp,-192
    80007770:	0a113c23          	sd	ra,184(sp)
    80007774:	0a813823          	sd	s0,176(sp)
    80007778:	0a913423          	sd	s1,168(sp)
    8000777c:	0b213023          	sd	s2,160(sp)
    80007780:	09313c23          	sd	s3,152(sp)
    80007784:	0c010413          	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80007788:	08000613          	li	a2,128
    8000778c:	f5040593          	addi	a1,s0,-176
    80007790:	00000513          	li	a0,0
    80007794:	ffffc097          	auipc	ra,0xffffc
    80007798:	478080e7          	jalr	1144(ra) # 80003c0c <argstr>
    return -1;
    8000779c:	fff00493          	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800077a0:	0e054263          	bltz	a0,80007884 <sys_open+0x118>
    800077a4:	f4c40593          	addi	a1,s0,-180
    800077a8:	00100513          	li	a0,1
    800077ac:	ffffc097          	auipc	ra,0xffffc
    800077b0:	3e8080e7          	jalr	1000(ra) # 80003b94 <argint>
    800077b4:	0c054863          	bltz	a0,80007884 <sys_open+0x118>

  begin_op();
    800077b8:	ffffe097          	auipc	ra,0xffffe
    800077bc:	18c080e7          	jalr	396(ra) # 80005944 <begin_op>

  if(omode & O_CREATE){
    800077c0:	f4c42783          	lw	a5,-180(s0)
    800077c4:	2007f793          	andi	a5,a5,512
    800077c8:	0e078463          	beqz	a5,800078b0 <sys_open+0x144>
    ip = create(path, T_FILE, 0, 0);
    800077cc:	00000693          	li	a3,0
    800077d0:	00000613          	li	a2,0
    800077d4:	00200593          	li	a1,2
    800077d8:	f5040513          	addi	a0,s0,-176
    800077dc:	fffff097          	auipc	ra,0xfffff
    800077e0:	78c080e7          	jalr	1932(ra) # 80006f68 <create>
    800077e4:	00050913          	mv	s2,a0
    if(ip == 0){
    800077e8:	0a050e63          	beqz	a0,800078a4 <sys_open+0x138>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800077ec:	04491703          	lh	a4,68(s2)
    800077f0:	00300793          	li	a5,3
    800077f4:	00f71863          	bne	a4,a5,80007804 <sys_open+0x98>
    800077f8:	04695703          	lhu	a4,70(s2)
    800077fc:	00900793          	li	a5,9
    80007800:	10e7e663          	bltu	a5,a4,8000790c <sys_open+0x1a0>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80007804:	ffffe097          	auipc	ra,0xffffe
    80007808:	6d0080e7          	jalr	1744(ra) # 80005ed4 <filealloc>
    8000780c:	00050993          	mv	s3,a0
    80007810:	14050263          	beqz	a0,80007954 <sys_open+0x1e8>
    80007814:	fffff097          	auipc	ra,0xfffff
    80007818:	6e4080e7          	jalr	1764(ra) # 80006ef8 <fdalloc>
    8000781c:	00050493          	mv	s1,a0
    80007820:	12054463          	bltz	a0,80007948 <sys_open+0x1dc>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80007824:	04491703          	lh	a4,68(s2)
    80007828:	00300793          	li	a5,3
    8000782c:	0ef70e63          	beq	a4,a5,80007928 <sys_open+0x1bc>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80007830:	00200793          	li	a5,2
    80007834:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80007838:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000783c:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80007840:	f4c42783          	lw	a5,-180(s0)
    80007844:	0017c713          	xori	a4,a5,1
    80007848:	00177713          	andi	a4,a4,1
    8000784c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80007850:	0037f713          	andi	a4,a5,3
    80007854:	00e03733          	snez	a4,a4
    80007858:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000785c:	4007f793          	andi	a5,a5,1024
    80007860:	00078863          	beqz	a5,80007870 <sys_open+0x104>
    80007864:	04491703          	lh	a4,68(s2)
    80007868:	00200793          	li	a5,2
    8000786c:	0cf70663          	beq	a4,a5,80007938 <sys_open+0x1cc>
    itrunc(ip);
  }

  iunlock(ip);
    80007870:	00090513          	mv	a0,s2
    80007874:	ffffd097          	auipc	ra,0xffffd
    80007878:	3ec080e7          	jalr	1004(ra) # 80004c60 <iunlock>
  end_op();
    8000787c:	ffffe097          	auipc	ra,0xffffe
    80007880:	17c080e7          	jalr	380(ra) # 800059f8 <end_op>

  return fd;
}
    80007884:	00048513          	mv	a0,s1
    80007888:	0b813083          	ld	ra,184(sp)
    8000788c:	0b013403          	ld	s0,176(sp)
    80007890:	0a813483          	ld	s1,168(sp)
    80007894:	0a013903          	ld	s2,160(sp)
    80007898:	09813983          	ld	s3,152(sp)
    8000789c:	0c010113          	addi	sp,sp,192
    800078a0:	00008067          	ret
      end_op();
    800078a4:	ffffe097          	auipc	ra,0xffffe
    800078a8:	154080e7          	jalr	340(ra) # 800059f8 <end_op>
      return -1;
    800078ac:	fd9ff06f          	j	80007884 <sys_open+0x118>
    if((ip = namei(path)) == 0){
    800078b0:	f5040513          	addi	a0,s0,-176
    800078b4:	ffffe097          	auipc	ra,0xffffe
    800078b8:	da0080e7          	jalr	-608(ra) # 80005654 <namei>
    800078bc:	00050913          	mv	s2,a0
    800078c0:	02050e63          	beqz	a0,800078fc <sys_open+0x190>
    ilock(ip);
    800078c4:	ffffd097          	auipc	ra,0xffffd
    800078c8:	298080e7          	jalr	664(ra) # 80004b5c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800078cc:	04491703          	lh	a4,68(s2)
    800078d0:	00100793          	li	a5,1
    800078d4:	f0f71ce3          	bne	a4,a5,800077ec <sys_open+0x80>
    800078d8:	f4c42783          	lw	a5,-180(s0)
    800078dc:	f20784e3          	beqz	a5,80007804 <sys_open+0x98>
      iunlockput(ip);
    800078e0:	00090513          	mv	a0,s2
    800078e4:	ffffd097          	auipc	ra,0xffffd
    800078e8:	5b4080e7          	jalr	1460(ra) # 80004e98 <iunlockput>
      end_op();
    800078ec:	ffffe097          	auipc	ra,0xffffe
    800078f0:	10c080e7          	jalr	268(ra) # 800059f8 <end_op>
      return -1;
    800078f4:	fff00493          	li	s1,-1
    800078f8:	f8dff06f          	j	80007884 <sys_open+0x118>
      end_op();
    800078fc:	ffffe097          	auipc	ra,0xffffe
    80007900:	0fc080e7          	jalr	252(ra) # 800059f8 <end_op>
      return -1;
    80007904:	fff00493          	li	s1,-1
    80007908:	f7dff06f          	j	80007884 <sys_open+0x118>
    iunlockput(ip);
    8000790c:	00090513          	mv	a0,s2
    80007910:	ffffd097          	auipc	ra,0xffffd
    80007914:	588080e7          	jalr	1416(ra) # 80004e98 <iunlockput>
    end_op();
    80007918:	ffffe097          	auipc	ra,0xffffe
    8000791c:	0e0080e7          	jalr	224(ra) # 800059f8 <end_op>
    return -1;
    80007920:	fff00493          	li	s1,-1
    80007924:	f61ff06f          	j	80007884 <sys_open+0x118>
    f->type = FD_DEVICE;
    80007928:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000792c:	04691783          	lh	a5,70(s2)
    80007930:	02f99223          	sh	a5,36(s3)
    80007934:	f09ff06f          	j	8000783c <sys_open+0xd0>
    itrunc(ip);
    80007938:	00090513          	mv	a0,s2
    8000793c:	ffffd097          	auipc	ra,0xffffd
    80007940:	394080e7          	jalr	916(ra) # 80004cd0 <itrunc>
    80007944:	f2dff06f          	j	80007870 <sys_open+0x104>
      fileclose(f);
    80007948:	00098513          	mv	a0,s3
    8000794c:	ffffe097          	auipc	ra,0xffffe
    80007950:	684080e7          	jalr	1668(ra) # 80005fd0 <fileclose>
    iunlockput(ip);
    80007954:	00090513          	mv	a0,s2
    80007958:	ffffd097          	auipc	ra,0xffffd
    8000795c:	540080e7          	jalr	1344(ra) # 80004e98 <iunlockput>
    end_op();
    80007960:	ffffe097          	auipc	ra,0xffffe
    80007964:	098080e7          	jalr	152(ra) # 800059f8 <end_op>
    return -1;
    80007968:	fff00493          	li	s1,-1
    8000796c:	f19ff06f          	j	80007884 <sys_open+0x118>

0000000080007970 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80007970:	f7010113          	addi	sp,sp,-144
    80007974:	08113423          	sd	ra,136(sp)
    80007978:	08813023          	sd	s0,128(sp)
    8000797c:	09010413          	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80007980:	ffffe097          	auipc	ra,0xffffe
    80007984:	fc4080e7          	jalr	-60(ra) # 80005944 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80007988:	08000613          	li	a2,128
    8000798c:	f7040593          	addi	a1,s0,-144
    80007990:	00000513          	li	a0,0
    80007994:	ffffc097          	auipc	ra,0xffffc
    80007998:	278080e7          	jalr	632(ra) # 80003c0c <argstr>
    8000799c:	04054263          	bltz	a0,800079e0 <sys_mkdir+0x70>
    800079a0:	00000693          	li	a3,0
    800079a4:	00000613          	li	a2,0
    800079a8:	00100593          	li	a1,1
    800079ac:	f7040513          	addi	a0,s0,-144
    800079b0:	fffff097          	auipc	ra,0xfffff
    800079b4:	5b8080e7          	jalr	1464(ra) # 80006f68 <create>
    800079b8:	02050463          	beqz	a0,800079e0 <sys_mkdir+0x70>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800079bc:	ffffd097          	auipc	ra,0xffffd
    800079c0:	4dc080e7          	jalr	1244(ra) # 80004e98 <iunlockput>
  end_op();
    800079c4:	ffffe097          	auipc	ra,0xffffe
    800079c8:	034080e7          	jalr	52(ra) # 800059f8 <end_op>
  return 0;
    800079cc:	00000513          	li	a0,0
}
    800079d0:	08813083          	ld	ra,136(sp)
    800079d4:	08013403          	ld	s0,128(sp)
    800079d8:	09010113          	addi	sp,sp,144
    800079dc:	00008067          	ret
    end_op();
    800079e0:	ffffe097          	auipc	ra,0xffffe
    800079e4:	018080e7          	jalr	24(ra) # 800059f8 <end_op>
    return -1;
    800079e8:	fff00513          	li	a0,-1
    800079ec:	fe5ff06f          	j	800079d0 <sys_mkdir+0x60>

00000000800079f0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800079f0:	f6010113          	addi	sp,sp,-160
    800079f4:	08113c23          	sd	ra,152(sp)
    800079f8:	08813823          	sd	s0,144(sp)
    800079fc:	0a010413          	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80007a00:	ffffe097          	auipc	ra,0xffffe
    80007a04:	f44080e7          	jalr	-188(ra) # 80005944 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80007a08:	08000613          	li	a2,128
    80007a0c:	f7040593          	addi	a1,s0,-144
    80007a10:	00000513          	li	a0,0
    80007a14:	ffffc097          	auipc	ra,0xffffc
    80007a18:	1f8080e7          	jalr	504(ra) # 80003c0c <argstr>
    80007a1c:	06054063          	bltz	a0,80007a7c <sys_mknod+0x8c>
     argint(1, &major) < 0 ||
    80007a20:	f6c40593          	addi	a1,s0,-148
    80007a24:	00100513          	li	a0,1
    80007a28:	ffffc097          	auipc	ra,0xffffc
    80007a2c:	16c080e7          	jalr	364(ra) # 80003b94 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80007a30:	04054663          	bltz	a0,80007a7c <sys_mknod+0x8c>
     argint(2, &minor) < 0 ||
    80007a34:	f6840593          	addi	a1,s0,-152
    80007a38:	00200513          	li	a0,2
    80007a3c:	ffffc097          	auipc	ra,0xffffc
    80007a40:	158080e7          	jalr	344(ra) # 80003b94 <argint>
     argint(1, &major) < 0 ||
    80007a44:	02054c63          	bltz	a0,80007a7c <sys_mknod+0x8c>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80007a48:	f6841683          	lh	a3,-152(s0)
    80007a4c:	f6c41603          	lh	a2,-148(s0)
    80007a50:	00300593          	li	a1,3
    80007a54:	f7040513          	addi	a0,s0,-144
    80007a58:	fffff097          	auipc	ra,0xfffff
    80007a5c:	510080e7          	jalr	1296(ra) # 80006f68 <create>
     argint(2, &minor) < 0 ||
    80007a60:	00050e63          	beqz	a0,80007a7c <sys_mknod+0x8c>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80007a64:	ffffd097          	auipc	ra,0xffffd
    80007a68:	434080e7          	jalr	1076(ra) # 80004e98 <iunlockput>
  end_op();
    80007a6c:	ffffe097          	auipc	ra,0xffffe
    80007a70:	f8c080e7          	jalr	-116(ra) # 800059f8 <end_op>
  return 0;
    80007a74:	00000513          	li	a0,0
    80007a78:	0100006f          	j	80007a88 <sys_mknod+0x98>
    end_op();
    80007a7c:	ffffe097          	auipc	ra,0xffffe
    80007a80:	f7c080e7          	jalr	-132(ra) # 800059f8 <end_op>
    return -1;
    80007a84:	fff00513          	li	a0,-1
}
    80007a88:	09813083          	ld	ra,152(sp)
    80007a8c:	09013403          	ld	s0,144(sp)
    80007a90:	0a010113          	addi	sp,sp,160
    80007a94:	00008067          	ret

0000000080007a98 <sys_chdir>:

uint64
sys_chdir(void)
{
    80007a98:	f6010113          	addi	sp,sp,-160
    80007a9c:	08113c23          	sd	ra,152(sp)
    80007aa0:	08813823          	sd	s0,144(sp)
    80007aa4:	08913423          	sd	s1,136(sp)
    80007aa8:	09213023          	sd	s2,128(sp)
    80007aac:	0a010413          	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80007ab0:	ffffb097          	auipc	ra,0xffffb
    80007ab4:	9a0080e7          	jalr	-1632(ra) # 80002450 <myproc>
    80007ab8:	00050913          	mv	s2,a0
  
  begin_op();
    80007abc:	ffffe097          	auipc	ra,0xffffe
    80007ac0:	e88080e7          	jalr	-376(ra) # 80005944 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80007ac4:	08000613          	li	a2,128
    80007ac8:	f6040593          	addi	a1,s0,-160
    80007acc:	00000513          	li	a0,0
    80007ad0:	ffffc097          	auipc	ra,0xffffc
    80007ad4:	13c080e7          	jalr	316(ra) # 80003c0c <argstr>
    80007ad8:	06054663          	bltz	a0,80007b44 <sys_chdir+0xac>
    80007adc:	f6040513          	addi	a0,s0,-160
    80007ae0:	ffffe097          	auipc	ra,0xffffe
    80007ae4:	b74080e7          	jalr	-1164(ra) # 80005654 <namei>
    80007ae8:	00050493          	mv	s1,a0
    80007aec:	04050c63          	beqz	a0,80007b44 <sys_chdir+0xac>
    end_op();
    return -1;
  }
  ilock(ip);
    80007af0:	ffffd097          	auipc	ra,0xffffd
    80007af4:	06c080e7          	jalr	108(ra) # 80004b5c <ilock>
  if(ip->type != T_DIR){
    80007af8:	04449703          	lh	a4,68(s1)
    80007afc:	00100793          	li	a5,1
    80007b00:	04f71a63          	bne	a4,a5,80007b54 <sys_chdir+0xbc>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80007b04:	00048513          	mv	a0,s1
    80007b08:	ffffd097          	auipc	ra,0xffffd
    80007b0c:	158080e7          	jalr	344(ra) # 80004c60 <iunlock>
  iput(p->cwd);
    80007b10:	15093503          	ld	a0,336(s2)
    80007b14:	ffffd097          	auipc	ra,0xffffd
    80007b18:	2a8080e7          	jalr	680(ra) # 80004dbc <iput>
  end_op();
    80007b1c:	ffffe097          	auipc	ra,0xffffe
    80007b20:	edc080e7          	jalr	-292(ra) # 800059f8 <end_op>
  p->cwd = ip;
    80007b24:	14993823          	sd	s1,336(s2)
  return 0;
    80007b28:	00000513          	li	a0,0
}
    80007b2c:	09813083          	ld	ra,152(sp)
    80007b30:	09013403          	ld	s0,144(sp)
    80007b34:	08813483          	ld	s1,136(sp)
    80007b38:	08013903          	ld	s2,128(sp)
    80007b3c:	0a010113          	addi	sp,sp,160
    80007b40:	00008067          	ret
    end_op();
    80007b44:	ffffe097          	auipc	ra,0xffffe
    80007b48:	eb4080e7          	jalr	-332(ra) # 800059f8 <end_op>
    return -1;
    80007b4c:	fff00513          	li	a0,-1
    80007b50:	fddff06f          	j	80007b2c <sys_chdir+0x94>
    iunlockput(ip);
    80007b54:	00048513          	mv	a0,s1
    80007b58:	ffffd097          	auipc	ra,0xffffd
    80007b5c:	340080e7          	jalr	832(ra) # 80004e98 <iunlockput>
    end_op();
    80007b60:	ffffe097          	auipc	ra,0xffffe
    80007b64:	e98080e7          	jalr	-360(ra) # 800059f8 <end_op>
    return -1;
    80007b68:	fff00513          	li	a0,-1
    80007b6c:	fc1ff06f          	j	80007b2c <sys_chdir+0x94>

0000000080007b70 <sys_exec>:

uint64
sys_exec(void)
{
    80007b70:	e3010113          	addi	sp,sp,-464
    80007b74:	1c113423          	sd	ra,456(sp)
    80007b78:	1c813023          	sd	s0,448(sp)
    80007b7c:	1a913c23          	sd	s1,440(sp)
    80007b80:	1b213823          	sd	s2,432(sp)
    80007b84:	1b313423          	sd	s3,424(sp)
    80007b88:	1b413023          	sd	s4,416(sp)
    80007b8c:	19513c23          	sd	s5,408(sp)
    80007b90:	1d010413          	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80007b94:	08000613          	li	a2,128
    80007b98:	f4040593          	addi	a1,s0,-192
    80007b9c:	00000513          	li	a0,0
    80007ba0:	ffffc097          	auipc	ra,0xffffc
    80007ba4:	06c080e7          	jalr	108(ra) # 80003c0c <argstr>
    return -1;
    80007ba8:	fff00913          	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80007bac:	10054263          	bltz	a0,80007cb0 <sys_exec+0x140>
    80007bb0:	e3840593          	addi	a1,s0,-456
    80007bb4:	00100513          	li	a0,1
    80007bb8:	ffffc097          	auipc	ra,0xffffc
    80007bbc:	018080e7          	jalr	24(ra) # 80003bd0 <argaddr>
    80007bc0:	0e054863          	bltz	a0,80007cb0 <sys_exec+0x140>
  }
  memset(argv, 0, sizeof(argv));
    80007bc4:	10000613          	li	a2,256
    80007bc8:	00000593          	li	a1,0
    80007bcc:	e4040513          	addi	a0,s0,-448
    80007bd0:	ffff9097          	auipc	ra,0xffff9
    80007bd4:	554080e7          	jalr	1364(ra) # 80001124 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80007bd8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80007bdc:	00048993          	mv	s3,s1
    80007be0:	00000913          	li	s2,0
    if(i >= NELEM(argv)){
    80007be4:	02000a13          	li	s4,32
    80007be8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80007bec:	00391793          	slli	a5,s2,0x3
    80007bf0:	e3040593          	addi	a1,s0,-464
    80007bf4:	e3843503          	ld	a0,-456(s0)
    80007bf8:	00a78533          	add	a0,a5,a0
    80007bfc:	ffffc097          	auipc	ra,0xffffc
    80007c00:	ea4080e7          	jalr	-348(ra) # 80003aa0 <fetchaddr>
    80007c04:	04054063          	bltz	a0,80007c44 <sys_exec+0xd4>
      goto bad;
    }
    if(uarg == 0){
    80007c08:	e3043783          	ld	a5,-464(s0)
    80007c0c:	04078e63          	beqz	a5,80007c68 <sys_exec+0xf8>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80007c10:	ffff9097          	auipc	ra,0xffff9
    80007c14:	250080e7          	jalr	592(ra) # 80000e60 <kalloc>
    80007c18:	00050593          	mv	a1,a0
    80007c1c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80007c20:	02050263          	beqz	a0,80007c44 <sys_exec+0xd4>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80007c24:	00001637          	lui	a2,0x1
    80007c28:	e3043503          	ld	a0,-464(s0)
    80007c2c:	ffffc097          	auipc	ra,0xffffc
    80007c30:	ef4080e7          	jalr	-268(ra) # 80003b20 <fetchstr>
    80007c34:	00054863          	bltz	a0,80007c44 <sys_exec+0xd4>
    if(i >= NELEM(argv)){
    80007c38:	00190913          	addi	s2,s2,1
    80007c3c:	00898993          	addi	s3,s3,8
    80007c40:	fb4914e3          	bne	s2,s4,80007be8 <sys_exec+0x78>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007c44:	10048913          	addi	s2,s1,256
    80007c48:	0004b503          	ld	a0,0(s1)
    80007c4c:	06050063          	beqz	a0,80007cac <sys_exec+0x13c>
    kfree(argv[i]);
    80007c50:	ffff9097          	auipc	ra,0xffff9
    80007c54:	0a4080e7          	jalr	164(ra) # 80000cf4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007c58:	00848493          	addi	s1,s1,8
    80007c5c:	ff2496e3          	bne	s1,s2,80007c48 <sys_exec+0xd8>
  return -1;
    80007c60:	fff00913          	li	s2,-1
    80007c64:	04c0006f          	j	80007cb0 <sys_exec+0x140>
      argv[i] = 0;
    80007c68:	003a9a93          	slli	s5,s5,0x3
    80007c6c:	fc040793          	addi	a5,s0,-64
    80007c70:	01578ab3          	add	s5,a5,s5
    80007c74:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffdb1f8>
  int ret = exec(path, argv);
    80007c78:	e4040593          	addi	a1,s0,-448
    80007c7c:	f4040513          	addi	a0,s0,-192
    80007c80:	fffff097          	auipc	ra,0xfffff
    80007c84:	d2c080e7          	jalr	-724(ra) # 800069ac <exec>
    80007c88:	00050913          	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007c8c:	10048993          	addi	s3,s1,256
    80007c90:	0004b503          	ld	a0,0(s1)
    80007c94:	00050e63          	beqz	a0,80007cb0 <sys_exec+0x140>
    kfree(argv[i]);
    80007c98:	ffff9097          	auipc	ra,0xffff9
    80007c9c:	05c080e7          	jalr	92(ra) # 80000cf4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007ca0:	00848493          	addi	s1,s1,8
    80007ca4:	ff3496e3          	bne	s1,s3,80007c90 <sys_exec+0x120>
    80007ca8:	0080006f          	j	80007cb0 <sys_exec+0x140>
  return -1;
    80007cac:	fff00913          	li	s2,-1
}
    80007cb0:	00090513          	mv	a0,s2
    80007cb4:	1c813083          	ld	ra,456(sp)
    80007cb8:	1c013403          	ld	s0,448(sp)
    80007cbc:	1b813483          	ld	s1,440(sp)
    80007cc0:	1b013903          	ld	s2,432(sp)
    80007cc4:	1a813983          	ld	s3,424(sp)
    80007cc8:	1a013a03          	ld	s4,416(sp)
    80007ccc:	19813a83          	ld	s5,408(sp)
    80007cd0:	1d010113          	addi	sp,sp,464
    80007cd4:	00008067          	ret

0000000080007cd8 <sys_pipe>:

uint64
sys_pipe(void)
{
    80007cd8:	fc010113          	addi	sp,sp,-64
    80007cdc:	02113c23          	sd	ra,56(sp)
    80007ce0:	02813823          	sd	s0,48(sp)
    80007ce4:	02913423          	sd	s1,40(sp)
    80007ce8:	04010413          	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80007cec:	ffffa097          	auipc	ra,0xffffa
    80007cf0:	764080e7          	jalr	1892(ra) # 80002450 <myproc>
    80007cf4:	00050493          	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80007cf8:	fd840593          	addi	a1,s0,-40
    80007cfc:	00000513          	li	a0,0
    80007d00:	ffffc097          	auipc	ra,0xffffc
    80007d04:	ed0080e7          	jalr	-304(ra) # 80003bd0 <argaddr>
    return -1;
    80007d08:	fff00793          	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80007d0c:	10054263          	bltz	a0,80007e10 <sys_pipe+0x138>
  if(pipealloc(&rf, &wf) < 0)
    80007d10:	fc840593          	addi	a1,s0,-56
    80007d14:	fd040513          	addi	a0,s0,-48
    80007d18:	ffffe097          	auipc	ra,0xffffe
    80007d1c:	748080e7          	jalr	1864(ra) # 80006460 <pipealloc>
    return -1;
    80007d20:	fff00793          	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80007d24:	0e054663          	bltz	a0,80007e10 <sys_pipe+0x138>
  fd0 = -1;
    80007d28:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80007d2c:	fd043503          	ld	a0,-48(s0)
    80007d30:	fffff097          	auipc	ra,0xfffff
    80007d34:	1c8080e7          	jalr	456(ra) # 80006ef8 <fdalloc>
    80007d38:	fca42223          	sw	a0,-60(s0)
    80007d3c:	0a054c63          	bltz	a0,80007df4 <sys_pipe+0x11c>
    80007d40:	fc843503          	ld	a0,-56(s0)
    80007d44:	fffff097          	auipc	ra,0xfffff
    80007d48:	1b4080e7          	jalr	436(ra) # 80006ef8 <fdalloc>
    80007d4c:	fca42023          	sw	a0,-64(s0)
    80007d50:	08054663          	bltz	a0,80007ddc <sys_pipe+0x104>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80007d54:	00400693          	li	a3,4
    80007d58:	fc440613          	addi	a2,s0,-60
    80007d5c:	fd843583          	ld	a1,-40(s0)
    80007d60:	0504b503          	ld	a0,80(s1)
    80007d64:	ffffa097          	auipc	ra,0xffffa
    80007d68:	1f4080e7          	jalr	500(ra) # 80001f58 <copyout>
    80007d6c:	02054463          	bltz	a0,80007d94 <sys_pipe+0xbc>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80007d70:	00400693          	li	a3,4
    80007d74:	fc040613          	addi	a2,s0,-64
    80007d78:	fd843583          	ld	a1,-40(s0)
    80007d7c:	00458593          	addi	a1,a1,4
    80007d80:	0504b503          	ld	a0,80(s1)
    80007d84:	ffffa097          	auipc	ra,0xffffa
    80007d88:	1d4080e7          	jalr	468(ra) # 80001f58 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80007d8c:	00000793          	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80007d90:	08055063          	bgez	a0,80007e10 <sys_pipe+0x138>
    p->ofile[fd0] = 0;
    80007d94:	fc442783          	lw	a5,-60(s0)
    80007d98:	01a78793          	addi	a5,a5,26
    80007d9c:	00379793          	slli	a5,a5,0x3
    80007da0:	00f487b3          	add	a5,s1,a5
    80007da4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80007da8:	fc042503          	lw	a0,-64(s0)
    80007dac:	01a50513          	addi	a0,a0,26
    80007db0:	00351513          	slli	a0,a0,0x3
    80007db4:	00a48533          	add	a0,s1,a0
    80007db8:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80007dbc:	fd043503          	ld	a0,-48(s0)
    80007dc0:	ffffe097          	auipc	ra,0xffffe
    80007dc4:	210080e7          	jalr	528(ra) # 80005fd0 <fileclose>
    fileclose(wf);
    80007dc8:	fc843503          	ld	a0,-56(s0)
    80007dcc:	ffffe097          	auipc	ra,0xffffe
    80007dd0:	204080e7          	jalr	516(ra) # 80005fd0 <fileclose>
    return -1;
    80007dd4:	fff00793          	li	a5,-1
    80007dd8:	0380006f          	j	80007e10 <sys_pipe+0x138>
    if(fd0 >= 0)
    80007ddc:	fc442783          	lw	a5,-60(s0)
    80007de0:	0007ca63          	bltz	a5,80007df4 <sys_pipe+0x11c>
      p->ofile[fd0] = 0;
    80007de4:	01a78513          	addi	a0,a5,26
    80007de8:	00351513          	slli	a0,a0,0x3
    80007dec:	00a48533          	add	a0,s1,a0
    80007df0:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80007df4:	fd043503          	ld	a0,-48(s0)
    80007df8:	ffffe097          	auipc	ra,0xffffe
    80007dfc:	1d8080e7          	jalr	472(ra) # 80005fd0 <fileclose>
    fileclose(wf);
    80007e00:	fc843503          	ld	a0,-56(s0)
    80007e04:	ffffe097          	auipc	ra,0xffffe
    80007e08:	1cc080e7          	jalr	460(ra) # 80005fd0 <fileclose>
    return -1;
    80007e0c:	fff00793          	li	a5,-1
}
    80007e10:	00078513          	mv	a0,a5
    80007e14:	03813083          	ld	ra,56(sp)
    80007e18:	03013403          	ld	s0,48(sp)
    80007e1c:	02813483          	ld	s1,40(sp)
    80007e20:	04010113          	addi	sp,sp,64
    80007e24:	00008067          	ret
	...

0000000080007e30 <kernelvec>:
    80007e30:	f0010113          	addi	sp,sp,-256
    80007e34:	00113023          	sd	ra,0(sp)
    80007e38:	00213423          	sd	sp,8(sp)
    80007e3c:	00313823          	sd	gp,16(sp)
    80007e40:	00413c23          	sd	tp,24(sp)
    80007e44:	02513023          	sd	t0,32(sp)
    80007e48:	02613423          	sd	t1,40(sp)
    80007e4c:	02713823          	sd	t2,48(sp)
    80007e50:	02813c23          	sd	s0,56(sp)
    80007e54:	04913023          	sd	s1,64(sp)
    80007e58:	04a13423          	sd	a0,72(sp)
    80007e5c:	04b13823          	sd	a1,80(sp)
    80007e60:	04c13c23          	sd	a2,88(sp)
    80007e64:	06d13023          	sd	a3,96(sp)
    80007e68:	06e13423          	sd	a4,104(sp)
    80007e6c:	06f13823          	sd	a5,112(sp)
    80007e70:	07013c23          	sd	a6,120(sp)
    80007e74:	09113023          	sd	a7,128(sp)
    80007e78:	09213423          	sd	s2,136(sp)
    80007e7c:	09313823          	sd	s3,144(sp)
    80007e80:	09413c23          	sd	s4,152(sp)
    80007e84:	0b513023          	sd	s5,160(sp)
    80007e88:	0b613423          	sd	s6,168(sp)
    80007e8c:	0b713823          	sd	s7,176(sp)
    80007e90:	0b813c23          	sd	s8,184(sp)
    80007e94:	0d913023          	sd	s9,192(sp)
    80007e98:	0da13423          	sd	s10,200(sp)
    80007e9c:	0db13823          	sd	s11,208(sp)
    80007ea0:	0dc13c23          	sd	t3,216(sp)
    80007ea4:	0fd13023          	sd	t4,224(sp)
    80007ea8:	0fe13423          	sd	t5,232(sp)
    80007eac:	0ff13823          	sd	t6,240(sp)
    80007eb0:	a49fb0ef          	jal	ra,800038f8 <kerneltrap>
    80007eb4:	00013083          	ld	ra,0(sp)
    80007eb8:	00813103          	ld	sp,8(sp)
    80007ebc:	01013183          	ld	gp,16(sp)
    80007ec0:	02013283          	ld	t0,32(sp)
    80007ec4:	02813303          	ld	t1,40(sp)
    80007ec8:	03013383          	ld	t2,48(sp)
    80007ecc:	03813403          	ld	s0,56(sp)
    80007ed0:	04013483          	ld	s1,64(sp)
    80007ed4:	04813503          	ld	a0,72(sp)
    80007ed8:	05013583          	ld	a1,80(sp)
    80007edc:	05813603          	ld	a2,88(sp)
    80007ee0:	06013683          	ld	a3,96(sp)
    80007ee4:	06813703          	ld	a4,104(sp)
    80007ee8:	07013783          	ld	a5,112(sp)
    80007eec:	07813803          	ld	a6,120(sp)
    80007ef0:	08013883          	ld	a7,128(sp)
    80007ef4:	08813903          	ld	s2,136(sp)
    80007ef8:	09013983          	ld	s3,144(sp)
    80007efc:	09813a03          	ld	s4,152(sp)
    80007f00:	0a013a83          	ld	s5,160(sp)
    80007f04:	0a813b03          	ld	s6,168(sp)
    80007f08:	0b013b83          	ld	s7,176(sp)
    80007f0c:	0b813c03          	ld	s8,184(sp)
    80007f10:	0c013c83          	ld	s9,192(sp)
    80007f14:	0c813d03          	ld	s10,200(sp)
    80007f18:	0d013d83          	ld	s11,208(sp)
    80007f1c:	0d813e03          	ld	t3,216(sp)
    80007f20:	0e013e83          	ld	t4,224(sp)
    80007f24:	0e813f03          	ld	t5,232(sp)
    80007f28:	0f013f83          	ld	t6,240(sp)
    80007f2c:	10010113          	addi	sp,sp,256
    80007f30:	10200073          	sret
    80007f34:	00000013          	nop
    80007f38:	00000013          	nop
    80007f3c:	00000013          	nop

0000000080007f40 <timervec>:
    80007f40:	34051573          	csrrw	a0,mscratch,a0
    80007f44:	00b53023          	sd	a1,0(a0)
    80007f48:	00c53423          	sd	a2,8(a0)
    80007f4c:	00d53823          	sd	a3,16(a0)
    80007f50:	01853583          	ld	a1,24(a0)
    80007f54:	02053603          	ld	a2,32(a0)
    80007f58:	0005b683          	ld	a3,0(a1)
    80007f5c:	00c686b3          	add	a3,a3,a2
    80007f60:	00d5b023          	sd	a3,0(a1)
    80007f64:	00200593          	li	a1,2
    80007f68:	14459073          	csrw	sip,a1
    80007f6c:	01053683          	ld	a3,16(a0)
    80007f70:	00853603          	ld	a2,8(a0)
    80007f74:	00053583          	ld	a1,0(a0)
    80007f78:	34051573          	csrrw	a0,mscratch,a0
    80007f7c:	30200073          	mret

0000000080007f80 <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80007f80:	ff010113          	addi	sp,sp,-16
    80007f84:	00813423          	sd	s0,8(sp)
    80007f88:	01010413          	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80007f8c:	0c0007b7          	lui	a5,0xc000
    80007f90:	00100713          	li	a4,1
    80007f94:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
}
    80007f98:	00813403          	ld	s0,8(sp)
    80007f9c:	01010113          	addi	sp,sp,16
    80007fa0:	00008067          	ret

0000000080007fa4 <plicinithart>:

void
plicinithart(void)
{
    80007fa4:	ff010113          	addi	sp,sp,-16
    80007fa8:	00113423          	sd	ra,8(sp)
    80007fac:	00813023          	sd	s0,0(sp)
    80007fb0:	01010413          	addi	s0,sp,16
  int hart = cpuid();
    80007fb4:	ffffa097          	auipc	ra,0xffffa
    80007fb8:	44c080e7          	jalr	1100(ra) # 80002400 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ);
    80007fbc:	0085171b          	slliw	a4,a0,0x8
    80007fc0:	0c0027b7          	lui	a5,0xc002
    80007fc4:	00e787b3          	add	a5,a5,a4
    80007fc8:	40000713          	li	a4,1024
    80007fcc:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80007fd0:	00d5151b          	slliw	a0,a0,0xd
    80007fd4:	0c2017b7          	lui	a5,0xc201
    80007fd8:	00a78533          	add	a0,a5,a0
    80007fdc:	00052023          	sw	zero,0(a0)
}
    80007fe0:	00813083          	ld	ra,8(sp)
    80007fe4:	00013403          	ld	s0,0(sp)
    80007fe8:	01010113          	addi	sp,sp,16
    80007fec:	00008067          	ret

0000000080007ff0 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80007ff0:	ff010113          	addi	sp,sp,-16
    80007ff4:	00113423          	sd	ra,8(sp)
    80007ff8:	00813023          	sd	s0,0(sp)
    80007ffc:	01010413          	addi	s0,sp,16
  int hart = cpuid();
    80008000:	ffffa097          	auipc	ra,0xffffa
    80008004:	400080e7          	jalr	1024(ra) # 80002400 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80008008:	00d5179b          	slliw	a5,a0,0xd
    8000800c:	0c201537          	lui	a0,0xc201
    80008010:	00f50533          	add	a0,a0,a5
  return irq;
}
    80008014:	00452503          	lw	a0,4(a0) # c201004 <_entry-0x73dfeffc>
    80008018:	00813083          	ld	ra,8(sp)
    8000801c:	00013403          	ld	s0,0(sp)
    80008020:	01010113          	addi	sp,sp,16
    80008024:	00008067          	ret

0000000080008028 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80008028:	fe010113          	addi	sp,sp,-32
    8000802c:	00113c23          	sd	ra,24(sp)
    80008030:	00813823          	sd	s0,16(sp)
    80008034:	00913423          	sd	s1,8(sp)
    80008038:	02010413          	addi	s0,sp,32
    8000803c:	00050493          	mv	s1,a0
  int hart = cpuid();
    80008040:	ffffa097          	auipc	ra,0xffffa
    80008044:	3c0080e7          	jalr	960(ra) # 80002400 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80008048:	00d5151b          	slliw	a0,a0,0xd
    8000804c:	0c2017b7          	lui	a5,0xc201
    80008050:	00a787b3          	add	a5,a5,a0
    80008054:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
}
    80008058:	01813083          	ld	ra,24(sp)
    8000805c:	01013403          	ld	s0,16(sp)
    80008060:	00813483          	ld	s1,8(sp)
    80008064:	02010113          	addi	sp,sp,32
    80008068:	00008067          	ret
	...

0000000080009000 <_trampoline>:
    80009000:	14051573          	csrrw	a0,sscratch,a0
    80009004:	02153423          	sd	ra,40(a0)
    80009008:	02253823          	sd	sp,48(a0)
    8000900c:	02353c23          	sd	gp,56(a0)
    80009010:	04453023          	sd	tp,64(a0)
    80009014:	04553423          	sd	t0,72(a0)
    80009018:	04653823          	sd	t1,80(a0)
    8000901c:	04753c23          	sd	t2,88(a0)
    80009020:	06853023          	sd	s0,96(a0)
    80009024:	06953423          	sd	s1,104(a0)
    80009028:	06b53c23          	sd	a1,120(a0)
    8000902c:	08c53023          	sd	a2,128(a0)
    80009030:	08d53423          	sd	a3,136(a0)
    80009034:	08e53823          	sd	a4,144(a0)
    80009038:	08f53c23          	sd	a5,152(a0)
    8000903c:	0b053023          	sd	a6,160(a0)
    80009040:	0b153423          	sd	a7,168(a0)
    80009044:	0b253823          	sd	s2,176(a0)
    80009048:	0b353c23          	sd	s3,184(a0)
    8000904c:	0d453023          	sd	s4,192(a0)
    80009050:	0d553423          	sd	s5,200(a0)
    80009054:	0d653823          	sd	s6,208(a0)
    80009058:	0d753c23          	sd	s7,216(a0)
    8000905c:	0f853023          	sd	s8,224(a0)
    80009060:	0f953423          	sd	s9,232(a0)
    80009064:	0fa53823          	sd	s10,240(a0)
    80009068:	0fb53c23          	sd	s11,248(a0)
    8000906c:	11c53023          	sd	t3,256(a0)
    80009070:	11d53423          	sd	t4,264(a0)
    80009074:	11e53823          	sd	t5,272(a0)
    80009078:	11f53c23          	sd	t6,280(a0)
    8000907c:	140022f3          	csrr	t0,sscratch
    80009080:	06553823          	sd	t0,112(a0)
    80009084:	00853103          	ld	sp,8(a0)
    80009088:	02053203          	ld	tp,32(a0)
    8000908c:	01053283          	ld	t0,16(a0)
    80009090:	00053303          	ld	t1,0(a0)
    80009094:	18031073          	csrw	satp,t1
    80009098:	12000073          	sfence.vma
    8000909c:	00028067          	jr	t0

00000000800090a0 <userret>:
    800090a0:	18059073          	csrw	satp,a1
    800090a4:	12000073          	sfence.vma
    800090a8:	07053283          	ld	t0,112(a0)
    800090ac:	14029073          	csrw	sscratch,t0
    800090b0:	02853083          	ld	ra,40(a0)
    800090b4:	03053103          	ld	sp,48(a0)
    800090b8:	03853183          	ld	gp,56(a0)
    800090bc:	04053203          	ld	tp,64(a0)
    800090c0:	04853283          	ld	t0,72(a0)
    800090c4:	05053303          	ld	t1,80(a0)
    800090c8:	05853383          	ld	t2,88(a0)
    800090cc:	06053403          	ld	s0,96(a0)
    800090d0:	06853483          	ld	s1,104(a0)
    800090d4:	07853583          	ld	a1,120(a0)
    800090d8:	08053603          	ld	a2,128(a0)
    800090dc:	08853683          	ld	a3,136(a0)
    800090e0:	09053703          	ld	a4,144(a0)
    800090e4:	09853783          	ld	a5,152(a0)
    800090e8:	0a053803          	ld	a6,160(a0)
    800090ec:	0a853883          	ld	a7,168(a0)
    800090f0:	0b053903          	ld	s2,176(a0)
    800090f4:	0b853983          	ld	s3,184(a0)
    800090f8:	0c053a03          	ld	s4,192(a0)
    800090fc:	0c853a83          	ld	s5,200(a0)
    80009100:	0d053b03          	ld	s6,208(a0)
    80009104:	0d853b83          	ld	s7,216(a0)
    80009108:	0e053c03          	ld	s8,224(a0)
    8000910c:	0e853c83          	ld	s9,232(a0)
    80009110:	0f053d03          	ld	s10,240(a0)
    80009114:	0f853d83          	ld	s11,248(a0)
    80009118:	10053e03          	ld	t3,256(a0)
    8000911c:	10853e83          	ld	t4,264(a0)
    80009120:	11053f03          	ld	t5,272(a0)
    80009124:	11853f83          	ld	t6,280(a0)
    80009128:	14051573          	csrrw	a0,sscratch,a0
    8000912c:	10200073          	sret
	...
