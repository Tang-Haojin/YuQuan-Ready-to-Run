
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	99010113          	addi	sp,sp,-1648 # 8000a990 <stack0>
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
    8000006c:	7e870713          	addi	a4,a4,2024 # 8000a850 <timer_scratch>
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
    80000084:	e6078793          	addi	a5,a5,-416 # 80007ee0 <timervec>
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
    800000c8:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdab87>
    800000cc:	00e7f7b3          	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000d0:	00001737          	lui	a4,0x1
    800000d4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000d8:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000dc:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000e0:	00001797          	auipc	a5,0x1
    800000e4:	27478793          	addi	a5,a5,628 # 80001354 <main>
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
    8000019c:	14c080e7          	jalr	332(ra) # 800032e4 <either_copyin>
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
    80000238:	75c50513          	addi	a0,a0,1884 # 80012990 <cons>
    8000023c:	00001097          	auipc	ra,0x1
    80000240:	d2c080e7          	jalr	-724(ra) # 80000f68 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000244:	00012497          	auipc	s1,0x12
    80000248:	74c48493          	addi	s1,s1,1868 # 80012990 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000024c:	00012917          	auipc	s2,0x12
    80000250:	7dc90913          	addi	s2,s2,2012 # 80012a28 <cons+0x98>
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
    80000274:	17c080e7          	jalr	380(ra) # 800023ec <myproc>
    80000278:	02852783          	lw	a5,40(a0)
    8000027c:	08079063          	bnez	a5,800002fc <consoleread+0x110>
      sleep(&cons.r, &cons.lock);
    80000280:	00048593          	mv	a1,s1
    80000284:	00090513          	mv	a0,s2
    80000288:	00003097          	auipc	ra,0x3
    8000028c:	ad4080e7          	jalr	-1324(ra) # 80002d5c <sleep>
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
    800002d0:	f88080e7          	jalr	-120(ra) # 80003254 <either_copyout>
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
    800002e8:	6ac50513          	addi	a0,a0,1708 # 80012990 <cons>
    800002ec:	00001097          	auipc	ra,0x1
    800002f0:	d74080e7          	jalr	-652(ra) # 80001060 <release>

  return target - n;
    800002f4:	413b053b          	subw	a0,s6,s3
    800002f8:	0180006f          	j	80000310 <consoleread+0x124>
        release(&cons.lock);
    800002fc:	00012517          	auipc	a0,0x12
    80000300:	69450513          	addi	a0,a0,1684 # 80012990 <cons>
    80000304:	00001097          	auipc	ra,0x1
    80000308:	d5c080e7          	jalr	-676(ra) # 80001060 <release>
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
    80000354:	6cf72c23          	sw	a5,1752(a4) # 80012a28 <cons+0x98>
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
    800003d4:	5c050513          	addi	a0,a0,1472 # 80012990 <cons>
    800003d8:	00001097          	auipc	ra,0x1
    800003dc:	b90080e7          	jalr	-1136(ra) # 80000f68 <acquire>

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
    80000400:	f78080e7          	jalr	-136(ra) # 80003374 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000404:	00012517          	auipc	a0,0x12
    80000408:	58c50513          	addi	a0,a0,1420 # 80012990 <cons>
    8000040c:	00001097          	auipc	ra,0x1
    80000410:	c54080e7          	jalr	-940(ra) # 80001060 <release>
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
    80000438:	55c70713          	addi	a4,a4,1372 # 80012990 <cons>
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
    80000468:	52c78793          	addi	a5,a5,1324 # 80012990 <cons>
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
    8000049c:	5907a783          	lw	a5,1424(a5) # 80012a28 <cons+0x98>
    800004a0:	0807879b          	addiw	a5,a5,128
    800004a4:	f6f610e3          	bne	a2,a5,80000404 <consoleintr+0x50>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800004a8:	00078613          	mv	a2,a5
    800004ac:	0c40006f          	j	80000570 <consoleintr+0x1bc>
    while(cons.e != cons.w &&
    800004b0:	00012717          	auipc	a4,0x12
    800004b4:	4e070713          	addi	a4,a4,1248 # 80012990 <cons>
    800004b8:	0a072783          	lw	a5,160(a4)
    800004bc:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800004c0:	00012497          	auipc	s1,0x12
    800004c4:	4d048493          	addi	s1,s1,1232 # 80012990 <cons>
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
    80000508:	48c70713          	addi	a4,a4,1164 # 80012990 <cons>
    8000050c:	0a072783          	lw	a5,160(a4)
    80000510:	09c72703          	lw	a4,156(a4)
    80000514:	eef708e3          	beq	a4,a5,80000404 <consoleintr+0x50>
      cons.e--;
    80000518:	fff7879b          	addiw	a5,a5,-1
    8000051c:	00012717          	auipc	a4,0x12
    80000520:	50f72a23          	sw	a5,1300(a4) # 80012a30 <cons+0xa0>
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
    8000054c:	44878793          	addi	a5,a5,1096 # 80012990 <cons>
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
    80000574:	4ac7ae23          	sw	a2,1212(a5) # 80012a2c <cons+0x9c>
        wakeup(&cons.r);
    80000578:	00012517          	auipc	a0,0x12
    8000057c:	4b050513          	addi	a0,a0,1200 # 80012a28 <cons+0x98>
    80000580:	00003097          	auipc	ra,0x3
    80000584:	9fc080e7          	jalr	-1540(ra) # 80002f7c <wakeup>
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
    800005a8:	3ec50513          	addi	a0,a0,1004 # 80012990 <cons>
    800005ac:	00001097          	auipc	ra,0x1
    800005b0:	8d8080e7          	jalr	-1832(ra) # 80000e84 <initlock>

  uartinit();
    800005b4:	00000097          	auipc	ra,0x0
    800005b8:	42c080e7          	jalr	1068(ra) # 800009e0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800005bc:	00022797          	auipc	a5,0x22
    800005c0:	66478793          	addi	a5,a5,1636 # 80022c20 <devsw>
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
    800006e8:	3607a623          	sw	zero,876(a5) # 80012a50 <pr+0x18>
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
    8000070c:	9b850513          	addi	a0,a0,-1608 # 8000a0c0 <digits+0x80>
    80000710:	00000097          	auipc	ra,0x0
    80000714:	018080e7          	jalr	24(ra) # 80000728 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000718:	00100793          	li	a5,1
    8000071c:	0000a717          	auipc	a4,0xa
    80000720:	0ef72a23          	sw	a5,244(a4) # 8000a810 <panicked>
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
    80000788:	2ccdad83          	lw	s11,716(s11) # 80012a50 <pr+0x18>
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
    800007cc:	27050513          	addi	a0,a0,624 # 80012a38 <pr>
    800007d0:	00000097          	auipc	ra,0x0
    800007d4:	798080e7          	jalr	1944(ra) # 80000f68 <acquire>
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
    80000984:	0b850513          	addi	a0,a0,184 # 80012a38 <pr>
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	6d8080e7          	jalr	1752(ra) # 80001060 <release>
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
    800009ac:	09048493          	addi	s1,s1,144 # 80012a38 <pr>
    800009b0:	00009597          	auipc	a1,0x9
    800009b4:	68858593          	addi	a1,a1,1672 # 8000a038 <etext+0x38>
    800009b8:	00048513          	mv	a0,s1
    800009bc:	00000097          	auipc	ra,0x0
    800009c0:	4c8080e7          	jalr	1224(ra) # 80000e84 <initlock>
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
    80000a28:	03450513          	addi	a0,a0,52 # 80012a58 <uart_tx_lock>
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	458080e7          	jalr	1112(ra) # 80000e84 <initlock>
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
    80000a60:	498080e7          	jalr	1176(ra) # 80000ef4 <push_off>

  if(panicked){
    80000a64:	0000a797          	auipc	a5,0xa
    80000a68:	dac7a783          	lw	a5,-596(a5) # 8000a810 <panicked>
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
    80000a94:	550080e7          	jalr	1360(ra) # 80000fe0 <pop_off>
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
    80000ab0:	d6c7b783          	ld	a5,-660(a5) # 8000a818 <uart_tx_r>
    80000ab4:	0000a717          	auipc	a4,0xa
    80000ab8:	d6c73703          	ld	a4,-660(a4) # 8000a820 <uart_tx_w>
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
    80000aec:	f70a0a13          	addi	s4,s4,-144 # 80012a58 <uart_tx_lock>
    uart_tx_r += 1;
    80000af0:	0000a497          	auipc	s1,0xa
    80000af4:	d2848493          	addi	s1,s1,-728 # 8000a818 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000af8:	0000a997          	auipc	s3,0xa
    80000afc:	d2898993          	addi	s3,s3,-728 # 8000a820 <uart_tx_w>
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
    80000b28:	458080e7          	jalr	1112(ra) # 80002f7c <wakeup>
    
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
    80000b8c:	ed050513          	addi	a0,a0,-304 # 80012a58 <uart_tx_lock>
    80000b90:	00000097          	auipc	ra,0x0
    80000b94:	3d8080e7          	jalr	984(ra) # 80000f68 <acquire>
  if(panicked){
    80000b98:	0000a797          	auipc	a5,0xa
    80000b9c:	c787a783          	lw	a5,-904(a5) # 8000a810 <panicked>
    80000ba0:	00078463          	beqz	a5,80000ba8 <uartputc+0x44>
    for(;;)
    80000ba4:	0000006f          	j	80000ba4 <uartputc+0x40>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000ba8:	0000a717          	auipc	a4,0xa
    80000bac:	c7873703          	ld	a4,-904(a4) # 8000a820 <uart_tx_w>
    80000bb0:	0000a797          	auipc	a5,0xa
    80000bb4:	c687b783          	ld	a5,-920(a5) # 8000a818 <uart_tx_r>
    80000bb8:	02078793          	addi	a5,a5,32
    80000bbc:	02e79e63          	bne	a5,a4,80000bf8 <uartputc+0x94>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000bc0:	00012997          	auipc	s3,0x12
    80000bc4:	e9898993          	addi	s3,s3,-360 # 80012a58 <uart_tx_lock>
    80000bc8:	0000a497          	auipc	s1,0xa
    80000bcc:	c5048493          	addi	s1,s1,-944 # 8000a818 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000bd0:	0000a917          	auipc	s2,0xa
    80000bd4:	c5090913          	addi	s2,s2,-944 # 8000a820 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000bd8:	00098593          	mv	a1,s3
    80000bdc:	00048513          	mv	a0,s1
    80000be0:	00002097          	auipc	ra,0x2
    80000be4:	17c080e7          	jalr	380(ra) # 80002d5c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000be8:	00093703          	ld	a4,0(s2)
    80000bec:	0004b783          	ld	a5,0(s1)
    80000bf0:	02078793          	addi	a5,a5,32
    80000bf4:	fee782e3          	beq	a5,a4,80000bd8 <uartputc+0x74>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000bf8:	00012497          	auipc	s1,0x12
    80000bfc:	e6048493          	addi	s1,s1,-416 # 80012a58 <uart_tx_lock>
    80000c00:	01f77793          	andi	a5,a4,31
    80000c04:	00f487b3          	add	a5,s1,a5
    80000c08:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000c0c:	00170713          	addi	a4,a4,1
    80000c10:	0000a797          	auipc	a5,0xa
    80000c14:	c0e7b823          	sd	a4,-1008(a5) # 8000a820 <uart_tx_w>
      uartstart();
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	e94080e7          	jalr	-364(ra) # 80000aac <uartstart>
      release(&uart_tx_lock);
    80000c20:	00048513          	mv	a0,s1
    80000c24:	00000097          	auipc	ra,0x0
    80000c28:	43c080e7          	jalr	1084(ra) # 80001060 <release>
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
    80000cbc:	da048493          	addi	s1,s1,-608 # 80012a58 <uart_tx_lock>
    80000cc0:	00048513          	mv	a0,s1
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	2a4080e7          	jalr	676(ra) # 80000f68 <acquire>
  uartstart();
    80000ccc:	00000097          	auipc	ra,0x0
    80000cd0:	de0080e7          	jalr	-544(ra) # 80000aac <uartstart>
  release(&uart_tx_lock);
    80000cd4:	00048513          	mv	a0,s1
    80000cd8:	00000097          	auipc	ra,0x0
    80000cdc:	388080e7          	jalr	904(ra) # 80001060 <release>
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
    80000d0c:	00050913          	mv	s2,a0
  // Fill with junk to catch dangling refs.
  // memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000d10:	00012497          	auipc	s1,0x12
    80000d14:	d8048493          	addi	s1,s1,-640 # 80012a90 <kmem>
    80000d18:	00048513          	mv	a0,s1
    80000d1c:	00000097          	auipc	ra,0x0
    80000d20:	24c080e7          	jalr	588(ra) # 80000f68 <acquire>
  r->next = kmem.freelist;
    80000d24:	0184b783          	ld	a5,24(s1)
    80000d28:	00f93023          	sd	a5,0(s2)
  kmem.freelist = r;
    80000d2c:	0124bc23          	sd	s2,24(s1)
  release(&kmem.lock);
    80000d30:	00048513          	mv	a0,s1
    80000d34:	00000097          	auipc	ra,0x0
    80000d38:	32c080e7          	jalr	812(ra) # 80001060 <release>
}
    80000d3c:	01813083          	ld	ra,24(sp)
    80000d40:	01013403          	ld	s0,16(sp)
    80000d44:	00813483          	ld	s1,8(sp)
    80000d48:	00013903          	ld	s2,0(sp)
    80000d4c:	02010113          	addi	sp,sp,32
    80000d50:	00008067          	ret

0000000080000d54 <freerange>:
{
    80000d54:	fd010113          	addi	sp,sp,-48
    80000d58:	02113423          	sd	ra,40(sp)
    80000d5c:	02813023          	sd	s0,32(sp)
    80000d60:	00913c23          	sd	s1,24(sp)
    80000d64:	01213823          	sd	s2,16(sp)
    80000d68:	01313423          	sd	s3,8(sp)
    80000d6c:	01413023          	sd	s4,0(sp)
    80000d70:	03010413          	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000d74:	000017b7          	lui	a5,0x1
    80000d78:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000d7c:	009504b3          	add	s1,a0,s1
    80000d80:	fffff537          	lui	a0,0xfffff
    80000d84:	00a4f4b3          	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000d88:	00f484b3          	add	s1,s1,a5
    80000d8c:	0295e263          	bltu	a1,s1,80000db0 <freerange+0x5c>
    80000d90:	00058913          	mv	s2,a1
    kfree(p);
    80000d94:	fffffa37          	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000d98:	000019b7          	lui	s3,0x1
    kfree(p);
    80000d9c:	01448533          	add	a0,s1,s4
    80000da0:	00000097          	auipc	ra,0x0
    80000da4:	f54080e7          	jalr	-172(ra) # 80000cf4 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000da8:	013484b3          	add	s1,s1,s3
    80000dac:	fe9978e3          	bgeu	s2,s1,80000d9c <freerange+0x48>
}
    80000db0:	02813083          	ld	ra,40(sp)
    80000db4:	02013403          	ld	s0,32(sp)
    80000db8:	01813483          	ld	s1,24(sp)
    80000dbc:	01013903          	ld	s2,16(sp)
    80000dc0:	00813983          	ld	s3,8(sp)
    80000dc4:	00013a03          	ld	s4,0(sp)
    80000dc8:	03010113          	addi	sp,sp,48
    80000dcc:	00008067          	ret

0000000080000dd0 <kinit>:
{
    80000dd0:	ff010113          	addi	sp,sp,-16
    80000dd4:	00113423          	sd	ra,8(sp)
    80000dd8:	00813023          	sd	s0,0(sp)
    80000ddc:	01010413          	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000de0:	00009597          	auipc	a1,0x9
    80000de4:	28058593          	addi	a1,a1,640 # 8000a060 <digits+0x20>
    80000de8:	00012517          	auipc	a0,0x12
    80000dec:	ca850513          	addi	a0,a0,-856 # 80012a90 <kmem>
    80000df0:	00000097          	auipc	ra,0x0
    80000df4:	094080e7          	jalr	148(ra) # 80000e84 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000df8:	01100593          	li	a1,17
    80000dfc:	01b59593          	slli	a1,a1,0x1b
    80000e00:	00023517          	auipc	a0,0x23
    80000e04:	e7850513          	addi	a0,a0,-392 # 80023c78 <end>
    80000e08:	00000097          	auipc	ra,0x0
    80000e0c:	f4c080e7          	jalr	-180(ra) # 80000d54 <freerange>
}
    80000e10:	00813083          	ld	ra,8(sp)
    80000e14:	00013403          	ld	s0,0(sp)
    80000e18:	01010113          	addi	sp,sp,16
    80000e1c:	00008067          	ret

0000000080000e20 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000e20:	fe010113          	addi	sp,sp,-32
    80000e24:	00113c23          	sd	ra,24(sp)
    80000e28:	00813823          	sd	s0,16(sp)
    80000e2c:	00913423          	sd	s1,8(sp)
    80000e30:	02010413          	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000e34:	00012497          	auipc	s1,0x12
    80000e38:	c5c48493          	addi	s1,s1,-932 # 80012a90 <kmem>
    80000e3c:	00048513          	mv	a0,s1
    80000e40:	00000097          	auipc	ra,0x0
    80000e44:	128080e7          	jalr	296(ra) # 80000f68 <acquire>
  r = kmem.freelist;
    80000e48:	0184b483          	ld	s1,24(s1)
  if(r)
    80000e4c:	00048863          	beqz	s1,80000e5c <kalloc+0x3c>
    kmem.freelist = r->next;
    80000e50:	0004b783          	ld	a5,0(s1)
    80000e54:	00012717          	auipc	a4,0x12
    80000e58:	c4f73a23          	sd	a5,-940(a4) # 80012aa8 <kmem+0x18>
  release(&kmem.lock);
    80000e5c:	00012517          	auipc	a0,0x12
    80000e60:	c3450513          	addi	a0,a0,-972 # 80012a90 <kmem>
    80000e64:	00000097          	auipc	ra,0x0
    80000e68:	1fc080e7          	jalr	508(ra) # 80001060 <release>

  // if(r)
  //   memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
    80000e6c:	00048513          	mv	a0,s1
    80000e70:	01813083          	ld	ra,24(sp)
    80000e74:	01013403          	ld	s0,16(sp)
    80000e78:	00813483          	ld	s1,8(sp)
    80000e7c:	02010113          	addi	sp,sp,32
    80000e80:	00008067          	ret

0000000080000e84 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000e84:	ff010113          	addi	sp,sp,-16
    80000e88:	00813423          	sd	s0,8(sp)
    80000e8c:	01010413          	addi	s0,sp,16
  lk->name = name;
    80000e90:	00b53423          	sd	a1,8(a0)
  lk->locked = 0;
    80000e94:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000e98:	00053823          	sd	zero,16(a0)
}
    80000e9c:	00813403          	ld	s0,8(sp)
    80000ea0:	01010113          	addi	sp,sp,16
    80000ea4:	00008067          	ret

0000000080000ea8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000ea8:	00052783          	lw	a5,0(a0)
    80000eac:	00079663          	bnez	a5,80000eb8 <holding+0x10>
    80000eb0:	00000513          	li	a0,0
  return r;
}
    80000eb4:	00008067          	ret
{
    80000eb8:	fe010113          	addi	sp,sp,-32
    80000ebc:	00113c23          	sd	ra,24(sp)
    80000ec0:	00813823          	sd	s0,16(sp)
    80000ec4:	00913423          	sd	s1,8(sp)
    80000ec8:	02010413          	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ecc:	01053483          	ld	s1,16(a0)
    80000ed0:	00001097          	auipc	ra,0x1
    80000ed4:	4ec080e7          	jalr	1260(ra) # 800023bc <mycpu>
    80000ed8:	40a48533          	sub	a0,s1,a0
    80000edc:	00153513          	seqz	a0,a0
}
    80000ee0:	01813083          	ld	ra,24(sp)
    80000ee4:	01013403          	ld	s0,16(sp)
    80000ee8:	00813483          	ld	s1,8(sp)
    80000eec:	02010113          	addi	sp,sp,32
    80000ef0:	00008067          	ret

0000000080000ef4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000ef4:	fe010113          	addi	sp,sp,-32
    80000ef8:	00113c23          	sd	ra,24(sp)
    80000efc:	00813823          	sd	s0,16(sp)
    80000f00:	00913423          	sd	s1,8(sp)
    80000f04:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000f08:	100024f3          	csrr	s1,sstatus
    80000f0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000f10:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000f14:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000f18:	00001097          	auipc	ra,0x1
    80000f1c:	4a4080e7          	jalr	1188(ra) # 800023bc <mycpu>
    80000f20:	07852783          	lw	a5,120(a0)
    80000f24:	02078663          	beqz	a5,80000f50 <push_off+0x5c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	494080e7          	jalr	1172(ra) # 800023bc <mycpu>
    80000f30:	07852783          	lw	a5,120(a0)
    80000f34:	0017879b          	addiw	a5,a5,1
    80000f38:	06f52c23          	sw	a5,120(a0)
}
    80000f3c:	01813083          	ld	ra,24(sp)
    80000f40:	01013403          	ld	s0,16(sp)
    80000f44:	00813483          	ld	s1,8(sp)
    80000f48:	02010113          	addi	sp,sp,32
    80000f4c:	00008067          	ret
    mycpu()->intena = old;
    80000f50:	00001097          	auipc	ra,0x1
    80000f54:	46c080e7          	jalr	1132(ra) # 800023bc <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000f58:	0014d493          	srli	s1,s1,0x1
    80000f5c:	0014f493          	andi	s1,s1,1
    80000f60:	06952e23          	sw	s1,124(a0)
    80000f64:	fc5ff06f          	j	80000f28 <push_off+0x34>

0000000080000f68 <acquire>:
{
    80000f68:	fe010113          	addi	sp,sp,-32
    80000f6c:	00113c23          	sd	ra,24(sp)
    80000f70:	00813823          	sd	s0,16(sp)
    80000f74:	00913423          	sd	s1,8(sp)
    80000f78:	02010413          	addi	s0,sp,32
    80000f7c:	00050493          	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	f74080e7          	jalr	-140(ra) # 80000ef4 <push_off>
  if(holding(lk))
    80000f88:	00048513          	mv	a0,s1
    80000f8c:	00000097          	auipc	ra,0x0
    80000f90:	f1c080e7          	jalr	-228(ra) # 80000ea8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000f94:	00100713          	li	a4,1
  if(holding(lk))
    80000f98:	02051c63          	bnez	a0,80000fd0 <acquire+0x68>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000f9c:	00070793          	mv	a5,a4
    80000fa0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000fa4:	0007879b          	sext.w	a5,a5
    80000fa8:	fe079ae3          	bnez	a5,80000f9c <acquire+0x34>
  __sync_synchronize();
    80000fac:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000fb0:	00001097          	auipc	ra,0x1
    80000fb4:	40c080e7          	jalr	1036(ra) # 800023bc <mycpu>
    80000fb8:	00a4b823          	sd	a0,16(s1)
}
    80000fbc:	01813083          	ld	ra,24(sp)
    80000fc0:	01013403          	ld	s0,16(sp)
    80000fc4:	00813483          	ld	s1,8(sp)
    80000fc8:	02010113          	addi	sp,sp,32
    80000fcc:	00008067          	ret
    panic("acquire");
    80000fd0:	00009517          	auipc	a0,0x9
    80000fd4:	09850513          	addi	a0,a0,152 # 8000a068 <digits+0x28>
    80000fd8:	fffff097          	auipc	ra,0xfffff
    80000fdc:	6f4080e7          	jalr	1780(ra) # 800006cc <panic>

0000000080000fe0 <pop_off>:

void
pop_off(void)
{
    80000fe0:	ff010113          	addi	sp,sp,-16
    80000fe4:	00113423          	sd	ra,8(sp)
    80000fe8:	00813023          	sd	s0,0(sp)
    80000fec:	01010413          	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000ff0:	00001097          	auipc	ra,0x1
    80000ff4:	3cc080e7          	jalr	972(ra) # 800023bc <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ff8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000ffc:	0027f793          	andi	a5,a5,2
  if(intr_get())
    80001000:	04079063          	bnez	a5,80001040 <pop_off+0x60>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80001004:	07852783          	lw	a5,120(a0)
    80001008:	04f05463          	blez	a5,80001050 <pop_off+0x70>
    panic("pop_off");
  c->noff -= 1;
    8000100c:	fff7879b          	addiw	a5,a5,-1
    80001010:	0007871b          	sext.w	a4,a5
    80001014:	06f52c23          	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80001018:	00071c63          	bnez	a4,80001030 <pop_off+0x50>
    8000101c:	07c52783          	lw	a5,124(a0)
    80001020:	00078863          	beqz	a5,80001030 <pop_off+0x50>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001024:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001028:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000102c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80001030:	00813083          	ld	ra,8(sp)
    80001034:	00013403          	ld	s0,0(sp)
    80001038:	01010113          	addi	sp,sp,16
    8000103c:	00008067          	ret
    panic("pop_off - interruptible");
    80001040:	00009517          	auipc	a0,0x9
    80001044:	03050513          	addi	a0,a0,48 # 8000a070 <digits+0x30>
    80001048:	fffff097          	auipc	ra,0xfffff
    8000104c:	684080e7          	jalr	1668(ra) # 800006cc <panic>
    panic("pop_off");
    80001050:	00009517          	auipc	a0,0x9
    80001054:	03850513          	addi	a0,a0,56 # 8000a088 <digits+0x48>
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	674080e7          	jalr	1652(ra) # 800006cc <panic>

0000000080001060 <release>:
{
    80001060:	fe010113          	addi	sp,sp,-32
    80001064:	00113c23          	sd	ra,24(sp)
    80001068:	00813823          	sd	s0,16(sp)
    8000106c:	00913423          	sd	s1,8(sp)
    80001070:	02010413          	addi	s0,sp,32
    80001074:	00050493          	mv	s1,a0
  if(!holding(lk))
    80001078:	00000097          	auipc	ra,0x0
    8000107c:	e30080e7          	jalr	-464(ra) # 80000ea8 <holding>
    80001080:	02050863          	beqz	a0,800010b0 <release+0x50>
  lk->cpu = 0;
    80001084:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80001088:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000108c:	0f50000f          	fence	iorw,ow
    80001090:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80001094:	00000097          	auipc	ra,0x0
    80001098:	f4c080e7          	jalr	-180(ra) # 80000fe0 <pop_off>
}
    8000109c:	01813083          	ld	ra,24(sp)
    800010a0:	01013403          	ld	s0,16(sp)
    800010a4:	00813483          	ld	s1,8(sp)
    800010a8:	02010113          	addi	sp,sp,32
    800010ac:	00008067          	ret
    panic("release");
    800010b0:	00009517          	auipc	a0,0x9
    800010b4:	fe050513          	addi	a0,a0,-32 # 8000a090 <digits+0x50>
    800010b8:	fffff097          	auipc	ra,0xfffff
    800010bc:	614080e7          	jalr	1556(ra) # 800006cc <panic>

00000000800010c0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800010c0:	ff010113          	addi	sp,sp,-16
    800010c4:	00813423          	sd	s0,8(sp)
    800010c8:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800010cc:	02060063          	beqz	a2,800010ec <memset+0x2c>
    800010d0:	00050793          	mv	a5,a0
    800010d4:	02061613          	slli	a2,a2,0x20
    800010d8:	02065613          	srli	a2,a2,0x20
    800010dc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800010e0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800010e4:	00178793          	addi	a5,a5,1
    800010e8:	fee79ce3          	bne	a5,a4,800010e0 <memset+0x20>
  }
  return dst;
}
    800010ec:	00813403          	ld	s0,8(sp)
    800010f0:	01010113          	addi	sp,sp,16
    800010f4:	00008067          	ret

00000000800010f8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800010f8:	ff010113          	addi	sp,sp,-16
    800010fc:	00813423          	sd	s0,8(sp)
    80001100:	01010413          	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80001104:	04060463          	beqz	a2,8000114c <memcmp+0x54>
    80001108:	fff6069b          	addiw	a3,a2,-1
    8000110c:	02069693          	slli	a3,a3,0x20
    80001110:	0206d693          	srli	a3,a3,0x20
    80001114:	00168693          	addi	a3,a3,1
    80001118:	00d506b3          	add	a3,a0,a3
    if(*s1 != *s2)
    8000111c:	00054783          	lbu	a5,0(a0)
    80001120:	0005c703          	lbu	a4,0(a1)
    80001124:	00e79c63          	bne	a5,a4,8000113c <memcmp+0x44>
      return *s1 - *s2;
    s1++, s2++;
    80001128:	00150513          	addi	a0,a0,1
    8000112c:	00158593          	addi	a1,a1,1
  while(n-- > 0){
    80001130:	fed516e3          	bne	a0,a3,8000111c <memcmp+0x24>
  }

  return 0;
    80001134:	00000513          	li	a0,0
    80001138:	0080006f          	j	80001140 <memcmp+0x48>
      return *s1 - *s2;
    8000113c:	40e7853b          	subw	a0,a5,a4
}
    80001140:	00813403          	ld	s0,8(sp)
    80001144:	01010113          	addi	sp,sp,16
    80001148:	00008067          	ret
  return 0;
    8000114c:	00000513          	li	a0,0
    80001150:	ff1ff06f          	j	80001140 <memcmp+0x48>

0000000080001154 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80001154:	ff010113          	addi	sp,sp,-16
    80001158:	00813423          	sd	s0,8(sp)
    8000115c:	01010413          	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80001160:	02060663          	beqz	a2,8000118c <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80001164:	02a5ea63          	bltu	a1,a0,80001198 <memmove+0x44>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80001168:	02061613          	slli	a2,a2,0x20
    8000116c:	02065613          	srli	a2,a2,0x20
    80001170:	00c587b3          	add	a5,a1,a2
{
    80001174:	00050713          	mv	a4,a0
      *d++ = *s++;
    80001178:	00158593          	addi	a1,a1,1
    8000117c:	00170713          	addi	a4,a4,1
    80001180:	fff5c683          	lbu	a3,-1(a1)
    80001184:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80001188:	fef598e3          	bne	a1,a5,80001178 <memmove+0x24>

  return dst;
}
    8000118c:	00813403          	ld	s0,8(sp)
    80001190:	01010113          	addi	sp,sp,16
    80001194:	00008067          	ret
  if(s < d && s + n > d){
    80001198:	02061693          	slli	a3,a2,0x20
    8000119c:	0206d693          	srli	a3,a3,0x20
    800011a0:	00d58733          	add	a4,a1,a3
    800011a4:	fce572e3          	bgeu	a0,a4,80001168 <memmove+0x14>
    d += n;
    800011a8:	00d506b3          	add	a3,a0,a3
    while(n-- > 0)
    800011ac:	fff6079b          	addiw	a5,a2,-1
    800011b0:	02079793          	slli	a5,a5,0x20
    800011b4:	0207d793          	srli	a5,a5,0x20
    800011b8:	fff7c793          	not	a5,a5
    800011bc:	00f707b3          	add	a5,a4,a5
      *--d = *--s;
    800011c0:	fff70713          	addi	a4,a4,-1
    800011c4:	fff68693          	addi	a3,a3,-1
    800011c8:	00074603          	lbu	a2,0(a4)
    800011cc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800011d0:	fee798e3          	bne	a5,a4,800011c0 <memmove+0x6c>
    800011d4:	fb9ff06f          	j	8000118c <memmove+0x38>

00000000800011d8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800011d8:	ff010113          	addi	sp,sp,-16
    800011dc:	00113423          	sd	ra,8(sp)
    800011e0:	00813023          	sd	s0,0(sp)
    800011e4:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
    800011e8:	00000097          	auipc	ra,0x0
    800011ec:	f6c080e7          	jalr	-148(ra) # 80001154 <memmove>
}
    800011f0:	00813083          	ld	ra,8(sp)
    800011f4:	00013403          	ld	s0,0(sp)
    800011f8:	01010113          	addi	sp,sp,16
    800011fc:	00008067          	ret

0000000080001200 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80001200:	ff010113          	addi	sp,sp,-16
    80001204:	00813423          	sd	s0,8(sp)
    80001208:	01010413          	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000120c:	02060663          	beqz	a2,80001238 <strncmp+0x38>
    80001210:	00054783          	lbu	a5,0(a0)
    80001214:	02078663          	beqz	a5,80001240 <strncmp+0x40>
    80001218:	0005c703          	lbu	a4,0(a1)
    8000121c:	02f71263          	bne	a4,a5,80001240 <strncmp+0x40>
    n--, p++, q++;
    80001220:	fff6061b          	addiw	a2,a2,-1
    80001224:	00150513          	addi	a0,a0,1
    80001228:	00158593          	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000122c:	fe0612e3          	bnez	a2,80001210 <strncmp+0x10>
  if(n == 0)
    return 0;
    80001230:	00000513          	li	a0,0
    80001234:	01c0006f          	j	80001250 <strncmp+0x50>
    80001238:	00000513          	li	a0,0
    8000123c:	0140006f          	j	80001250 <strncmp+0x50>
  if(n == 0)
    80001240:	00060e63          	beqz	a2,8000125c <strncmp+0x5c>
  return (uchar)*p - (uchar)*q;
    80001244:	00054503          	lbu	a0,0(a0)
    80001248:	0005c783          	lbu	a5,0(a1)
    8000124c:	40f5053b          	subw	a0,a0,a5
}
    80001250:	00813403          	ld	s0,8(sp)
    80001254:	01010113          	addi	sp,sp,16
    80001258:	00008067          	ret
    return 0;
    8000125c:	00000513          	li	a0,0
    80001260:	ff1ff06f          	j	80001250 <strncmp+0x50>

0000000080001264 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80001264:	ff010113          	addi	sp,sp,-16
    80001268:	00813423          	sd	s0,8(sp)
    8000126c:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80001270:	00050713          	mv	a4,a0
    80001274:	00060813          	mv	a6,a2
    80001278:	fff6061b          	addiw	a2,a2,-1
    8000127c:	01005c63          	blez	a6,80001294 <strncpy+0x30>
    80001280:	00170713          	addi	a4,a4,1
    80001284:	0005c783          	lbu	a5,0(a1)
    80001288:	fef70fa3          	sb	a5,-1(a4)
    8000128c:	00158593          	addi	a1,a1,1
    80001290:	fe0792e3          	bnez	a5,80001274 <strncpy+0x10>
    ;
  while(n-- > 0)
    80001294:	00070693          	mv	a3,a4
    80001298:	00c05e63          	blez	a2,800012b4 <strncpy+0x50>
    *s++ = 0;
    8000129c:	00168693          	addi	a3,a3,1
    800012a0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800012a4:	fff6c793          	not	a5,a3
    800012a8:	00e787bb          	addw	a5,a5,a4
    800012ac:	010787bb          	addw	a5,a5,a6
    800012b0:	fef046e3          	bgtz	a5,8000129c <strncpy+0x38>
  return os;
}
    800012b4:	00813403          	ld	s0,8(sp)
    800012b8:	01010113          	addi	sp,sp,16
    800012bc:	00008067          	ret

00000000800012c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800012c0:	ff010113          	addi	sp,sp,-16
    800012c4:	00813423          	sd	s0,8(sp)
    800012c8:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800012cc:	02c05a63          	blez	a2,80001300 <safestrcpy+0x40>
    800012d0:	fff6069b          	addiw	a3,a2,-1
    800012d4:	02069693          	slli	a3,a3,0x20
    800012d8:	0206d693          	srli	a3,a3,0x20
    800012dc:	00d586b3          	add	a3,a1,a3
    800012e0:	00050793          	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800012e4:	00d58c63          	beq	a1,a3,800012fc <safestrcpy+0x3c>
    800012e8:	00158593          	addi	a1,a1,1
    800012ec:	00178793          	addi	a5,a5,1
    800012f0:	fff5c703          	lbu	a4,-1(a1)
    800012f4:	fee78fa3          	sb	a4,-1(a5)
    800012f8:	fe0716e3          	bnez	a4,800012e4 <safestrcpy+0x24>
    ;
  *s = 0;
    800012fc:	00078023          	sb	zero,0(a5)
  return os;
}
    80001300:	00813403          	ld	s0,8(sp)
    80001304:	01010113          	addi	sp,sp,16
    80001308:	00008067          	ret

000000008000130c <strlen>:

int
strlen(const char *s)
{
    8000130c:	ff010113          	addi	sp,sp,-16
    80001310:	00813423          	sd	s0,8(sp)
    80001314:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80001318:	00054783          	lbu	a5,0(a0)
    8000131c:	02078863          	beqz	a5,8000134c <strlen+0x40>
    80001320:	00150513          	addi	a0,a0,1
    80001324:	00050793          	mv	a5,a0
    80001328:	00100693          	li	a3,1
    8000132c:	40a686bb          	subw	a3,a3,a0
    80001330:	00f6853b          	addw	a0,a3,a5
    80001334:	00178793          	addi	a5,a5,1
    80001338:	fff7c703          	lbu	a4,-1(a5)
    8000133c:	fe071ae3          	bnez	a4,80001330 <strlen+0x24>
    ;
  return n;
}
    80001340:	00813403          	ld	s0,8(sp)
    80001344:	01010113          	addi	sp,sp,16
    80001348:	00008067          	ret
  for(n = 0; s[n]; n++)
    8000134c:	00000513          	li	a0,0
    80001350:	ff1ff06f          	j	80001340 <strlen+0x34>

0000000080001354 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80001354:	ff010113          	addi	sp,sp,-16
    80001358:	00113423          	sd	ra,8(sp)
    8000135c:	00813023          	sd	s0,0(sp)
    80001360:	01010413          	addi	s0,sp,16
  if(cpuid() == 0){
    80001364:	00001097          	auipc	ra,0x1
    80001368:	038080e7          	jalr	56(ra) # 8000239c <cpuid>
    ramdiskinit();   // disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000136c:	00009717          	auipc	a4,0x9
    80001370:	4bc70713          	addi	a4,a4,1212 # 8000a828 <started>
  if(cpuid() == 0){
    80001374:	04050863          	beqz	a0,800013c4 <main+0x70>
    while(started == 0)
    80001378:	00072783          	lw	a5,0(a4)
    8000137c:	0007879b          	sext.w	a5,a5
    80001380:	fe078ce3          	beqz	a5,80001378 <main+0x24>
      ;
    __sync_synchronize();
    80001384:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80001388:	00001097          	auipc	ra,0x1
    8000138c:	014080e7          	jalr	20(ra) # 8000239c <cpuid>
    80001390:	00050593          	mv	a1,a0
    80001394:	00009517          	auipc	a0,0x9
    80001398:	d1c50513          	addi	a0,a0,-740 # 8000a0b0 <digits+0x70>
    8000139c:	fffff097          	auipc	ra,0xfffff
    800013a0:	38c080e7          	jalr	908(ra) # 80000728 <printf>
    kvminithart();    // turn on paging
    800013a4:	00000097          	auipc	ra,0x0
    800013a8:	0dc080e7          	jalr	220(ra) # 80001480 <kvminithart>
    trapinithart();   // install kernel trap vector
    800013ac:	00002097          	auipc	ra,0x2
    800013b0:	168080e7          	jalr	360(ra) # 80003514 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800013b4:	00007097          	auipc	ra,0x7
    800013b8:	b90080e7          	jalr	-1136(ra) # 80007f44 <plicinithart>
  }

  scheduler();        
    800013bc:	00001097          	auipc	ra,0x1
    800013c0:	758080e7          	jalr	1880(ra) # 80002b14 <scheduler>
    consoleinit();
    800013c4:	fffff097          	auipc	ra,0xfffff
    800013c8:	1c8080e7          	jalr	456(ra) # 8000058c <consoleinit>
    printfinit();
    800013cc:	fffff097          	auipc	ra,0xfffff
    800013d0:	5c8080e7          	jalr	1480(ra) # 80000994 <printfinit>
    printf("\n");
    800013d4:	00009517          	auipc	a0,0x9
    800013d8:	cec50513          	addi	a0,a0,-788 # 8000a0c0 <digits+0x80>
    800013dc:	fffff097          	auipc	ra,0xfffff
    800013e0:	34c080e7          	jalr	844(ra) # 80000728 <printf>
    printf("xv6 kernel is booting\n");
    800013e4:	00009517          	auipc	a0,0x9
    800013e8:	cb450513          	addi	a0,a0,-844 # 8000a098 <digits+0x58>
    800013ec:	fffff097          	auipc	ra,0xfffff
    800013f0:	33c080e7          	jalr	828(ra) # 80000728 <printf>
    printf("\n");
    800013f4:	00009517          	auipc	a0,0x9
    800013f8:	ccc50513          	addi	a0,a0,-820 # 8000a0c0 <digits+0x80>
    800013fc:	fffff097          	auipc	ra,0xfffff
    80001400:	32c080e7          	jalr	812(ra) # 80000728 <printf>
    kinit();         // physical page allocator
    80001404:	00000097          	auipc	ra,0x0
    80001408:	9cc080e7          	jalr	-1588(ra) # 80000dd0 <kinit>
    kvminit();       // create kernel page table
    8000140c:	00000097          	auipc	ra,0x0
    80001410:	484080e7          	jalr	1156(ra) # 80001890 <kvminit>
    kvminithart();   // turn on paging
    80001414:	00000097          	auipc	ra,0x0
    80001418:	06c080e7          	jalr	108(ra) # 80001480 <kvminithart>
    procinit();      // process table
    8000141c:	00001097          	auipc	ra,0x1
    80001420:	e98080e7          	jalr	-360(ra) # 800022b4 <procinit>
    trapinit();      // trap vectors
    80001424:	00002097          	auipc	ra,0x2
    80001428:	0b8080e7          	jalr	184(ra) # 800034dc <trapinit>
    trapinithart();  // install kernel trap vector
    8000142c:	00002097          	auipc	ra,0x2
    80001430:	0e8080e7          	jalr	232(ra) # 80003514 <trapinithart>
    plicinit();      // set up interrupt controller
    80001434:	00007097          	auipc	ra,0x7
    80001438:	aec080e7          	jalr	-1300(ra) # 80007f20 <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000143c:	00007097          	auipc	ra,0x7
    80001440:	b08080e7          	jalr	-1272(ra) # 80007f44 <plicinithart>
    binit();         // buffer cache
    80001444:	00003097          	auipc	ra,0x3
    80001448:	b20080e7          	jalr	-1248(ra) # 80003f64 <binit>
    iinit();         // inode table
    8000144c:	00003097          	auipc	ra,0x3
    80001450:	3f4080e7          	jalr	1012(ra) # 80004840 <iinit>
    fileinit();      // file table
    80001454:	00005097          	auipc	ra,0x5
    80001458:	9e4080e7          	jalr	-1564(ra) # 80005e38 <fileinit>
    ramdiskinit();   // disk
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	3ec080e7          	jalr	1004(ra) # 80006848 <ramdiskinit>
    userinit();      // first user process
    80001464:	00001097          	auipc	ra,0x1
    80001468:	3ac080e7          	jalr	940(ra) # 80002810 <userinit>
    __sync_synchronize();
    8000146c:	0ff0000f          	fence
    started = 1;
    80001470:	00100793          	li	a5,1
    80001474:	00009717          	auipc	a4,0x9
    80001478:	3af72a23          	sw	a5,948(a4) # 8000a828 <started>
    8000147c:	f41ff06f          	j	800013bc <main+0x68>

0000000080001480 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001480:	ff010113          	addi	sp,sp,-16
    80001484:	00813423          	sd	s0,8(sp)
    80001488:	01010413          	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000148c:	00009797          	auipc	a5,0x9
    80001490:	3a47b783          	ld	a5,932(a5) # 8000a830 <kernel_pagetable>
    80001494:	00c7d793          	srli	a5,a5,0xc
    80001498:	fff00713          	li	a4,-1
    8000149c:	03f71713          	slli	a4,a4,0x3f
    800014a0:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800014a4:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800014a8:	12000073          	sfence.vma
  sfence_vma();
}
    800014ac:	00813403          	ld	s0,8(sp)
    800014b0:	01010113          	addi	sp,sp,16
    800014b4:	00008067          	ret

00000000800014b8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800014b8:	fc010113          	addi	sp,sp,-64
    800014bc:	02113c23          	sd	ra,56(sp)
    800014c0:	02813823          	sd	s0,48(sp)
    800014c4:	02913423          	sd	s1,40(sp)
    800014c8:	03213023          	sd	s2,32(sp)
    800014cc:	01313c23          	sd	s3,24(sp)
    800014d0:	01413823          	sd	s4,16(sp)
    800014d4:	01513423          	sd	s5,8(sp)
    800014d8:	01613023          	sd	s6,0(sp)
    800014dc:	04010413          	addi	s0,sp,64
    800014e0:	00050493          	mv	s1,a0
    800014e4:	00058993          	mv	s3,a1
    800014e8:	00060a93          	mv	s5,a2
  if(va >= MAXVA)
    800014ec:	fff00793          	li	a5,-1
    800014f0:	01a7d793          	srli	a5,a5,0x1a
    800014f4:	01e00a13          	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800014f8:	00c00b13          	li	s6,12
  if(va >= MAXVA)
    800014fc:	04b7f863          	bgeu	a5,a1,8000154c <walk+0x94>
    panic("walk");
    80001500:	00009517          	auipc	a0,0x9
    80001504:	bc850513          	addi	a0,a0,-1080 # 8000a0c8 <digits+0x88>
    80001508:	fffff097          	auipc	ra,0xfffff
    8000150c:	1c4080e7          	jalr	452(ra) # 800006cc <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001510:	080a8e63          	beqz	s5,800015ac <walk+0xf4>
    80001514:	00000097          	auipc	ra,0x0
    80001518:	90c080e7          	jalr	-1780(ra) # 80000e20 <kalloc>
    8000151c:	00050493          	mv	s1,a0
    80001520:	06050263          	beqz	a0,80001584 <walk+0xcc>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001524:	00001637          	lui	a2,0x1
    80001528:	00000593          	li	a1,0
    8000152c:	00000097          	auipc	ra,0x0
    80001530:	b94080e7          	jalr	-1132(ra) # 800010c0 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001534:	00c4d793          	srli	a5,s1,0xc
    80001538:	00a79793          	slli	a5,a5,0xa
    8000153c:	0017e793          	ori	a5,a5,1
    80001540:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001544:	ff7a0a1b          	addiw	s4,s4,-9
    80001548:	036a0663          	beq	s4,s6,80001574 <walk+0xbc>
    pte_t *pte = &pagetable[PX(level, va)];
    8000154c:	0149d933          	srl	s2,s3,s4
    80001550:	1ff97913          	andi	s2,s2,511
    80001554:	00391913          	slli	s2,s2,0x3
    80001558:	01248933          	add	s2,s1,s2
    if(*pte & PTE_V) {
    8000155c:	00093483          	ld	s1,0(s2)
    80001560:	0014f793          	andi	a5,s1,1
    80001564:	fa0786e3          	beqz	a5,80001510 <walk+0x58>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001568:	00a4d493          	srli	s1,s1,0xa
    8000156c:	00c49493          	slli	s1,s1,0xc
    80001570:	fd5ff06f          	j	80001544 <walk+0x8c>
    }
  }
  return &pagetable[PX(0, va)];
    80001574:	00c9d513          	srli	a0,s3,0xc
    80001578:	1ff57513          	andi	a0,a0,511
    8000157c:	00351513          	slli	a0,a0,0x3
    80001580:	00a48533          	add	a0,s1,a0
}
    80001584:	03813083          	ld	ra,56(sp)
    80001588:	03013403          	ld	s0,48(sp)
    8000158c:	02813483          	ld	s1,40(sp)
    80001590:	02013903          	ld	s2,32(sp)
    80001594:	01813983          	ld	s3,24(sp)
    80001598:	01013a03          	ld	s4,16(sp)
    8000159c:	00813a83          	ld	s5,8(sp)
    800015a0:	00013b03          	ld	s6,0(sp)
    800015a4:	04010113          	addi	sp,sp,64
    800015a8:	00008067          	ret
        return 0;
    800015ac:	00000513          	li	a0,0
    800015b0:	fd5ff06f          	j	80001584 <walk+0xcc>

00000000800015b4 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800015b4:	fff00793          	li	a5,-1
    800015b8:	01a7d793          	srli	a5,a5,0x1a
    800015bc:	00b7f663          	bgeu	a5,a1,800015c8 <walkaddr+0x14>
    return 0;
    800015c0:	00000513          	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800015c4:	00008067          	ret
{
    800015c8:	ff010113          	addi	sp,sp,-16
    800015cc:	00113423          	sd	ra,8(sp)
    800015d0:	00813023          	sd	s0,0(sp)
    800015d4:	01010413          	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800015d8:	00000613          	li	a2,0
    800015dc:	00000097          	auipc	ra,0x0
    800015e0:	edc080e7          	jalr	-292(ra) # 800014b8 <walk>
  if(pte == 0)
    800015e4:	02050a63          	beqz	a0,80001618 <walkaddr+0x64>
  if((*pte & PTE_V) == 0)
    800015e8:	00053783          	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800015ec:	0117f693          	andi	a3,a5,17
    800015f0:	01100713          	li	a4,17
    return 0;
    800015f4:	00000513          	li	a0,0
  if((*pte & PTE_U) == 0)
    800015f8:	00e68a63          	beq	a3,a4,8000160c <walkaddr+0x58>
}
    800015fc:	00813083          	ld	ra,8(sp)
    80001600:	00013403          	ld	s0,0(sp)
    80001604:	01010113          	addi	sp,sp,16
    80001608:	00008067          	ret
  pa = PTE2PA(*pte);
    8000160c:	00a7d513          	srli	a0,a5,0xa
    80001610:	00c51513          	slli	a0,a0,0xc
  return pa;
    80001614:	fe9ff06f          	j	800015fc <walkaddr+0x48>
    return 0;
    80001618:	00000513          	li	a0,0
    8000161c:	fe1ff06f          	j	800015fc <walkaddr+0x48>

0000000080001620 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001620:	fb010113          	addi	sp,sp,-80
    80001624:	04113423          	sd	ra,72(sp)
    80001628:	04813023          	sd	s0,64(sp)
    8000162c:	02913c23          	sd	s1,56(sp)
    80001630:	03213823          	sd	s2,48(sp)
    80001634:	03313423          	sd	s3,40(sp)
    80001638:	03413023          	sd	s4,32(sp)
    8000163c:	01513c23          	sd	s5,24(sp)
    80001640:	01613823          	sd	s6,16(sp)
    80001644:	01713423          	sd	s7,8(sp)
    80001648:	05010413          	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000164c:	06060a63          	beqz	a2,800016c0 <mappages+0xa0>
    80001650:	00050a93          	mv	s5,a0
    80001654:	00070b13          	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001658:	fffff7b7          	lui	a5,0xfffff
    8000165c:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80001660:	fff58593          	addi	a1,a1,-1
    80001664:	00c589b3          	add	s3,a1,a2
    80001668:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000166c:	000a0913          	mv	s2,s4
    80001670:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001674:	00001bb7          	lui	s7,0x1
    80001678:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000167c:	00100613          	li	a2,1
    80001680:	00090593          	mv	a1,s2
    80001684:	000a8513          	mv	a0,s5
    80001688:	00000097          	auipc	ra,0x0
    8000168c:	e30080e7          	jalr	-464(ra) # 800014b8 <walk>
    80001690:	04050863          	beqz	a0,800016e0 <mappages+0xc0>
    if(*pte & PTE_V)
    80001694:	00053783          	ld	a5,0(a0)
    80001698:	0017f793          	andi	a5,a5,1
    8000169c:	02079a63          	bnez	a5,800016d0 <mappages+0xb0>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800016a0:	00c4d493          	srli	s1,s1,0xc
    800016a4:	00a49493          	slli	s1,s1,0xa
    800016a8:	0164e4b3          	or	s1,s1,s6
    800016ac:	0014e493          	ori	s1,s1,1
    800016b0:	00953023          	sd	s1,0(a0)
    if(a == last)
    800016b4:	05390e63          	beq	s2,s3,80001710 <mappages+0xf0>
    a += PGSIZE;
    800016b8:	01790933          	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800016bc:	fbdff06f          	j	80001678 <mappages+0x58>
    panic("mappages: size");
    800016c0:	00009517          	auipc	a0,0x9
    800016c4:	a1050513          	addi	a0,a0,-1520 # 8000a0d0 <digits+0x90>
    800016c8:	fffff097          	auipc	ra,0xfffff
    800016cc:	004080e7          	jalr	4(ra) # 800006cc <panic>
      panic("mappages: remap");
    800016d0:	00009517          	auipc	a0,0x9
    800016d4:	a1050513          	addi	a0,a0,-1520 # 8000a0e0 <digits+0xa0>
    800016d8:	fffff097          	auipc	ra,0xfffff
    800016dc:	ff4080e7          	jalr	-12(ra) # 800006cc <panic>
      return -1;
    800016e0:	fff00513          	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800016e4:	04813083          	ld	ra,72(sp)
    800016e8:	04013403          	ld	s0,64(sp)
    800016ec:	03813483          	ld	s1,56(sp)
    800016f0:	03013903          	ld	s2,48(sp)
    800016f4:	02813983          	ld	s3,40(sp)
    800016f8:	02013a03          	ld	s4,32(sp)
    800016fc:	01813a83          	ld	s5,24(sp)
    80001700:	01013b03          	ld	s6,16(sp)
    80001704:	00813b83          	ld	s7,8(sp)
    80001708:	05010113          	addi	sp,sp,80
    8000170c:	00008067          	ret
  return 0;
    80001710:	00000513          	li	a0,0
    80001714:	fd1ff06f          	j	800016e4 <mappages+0xc4>

0000000080001718 <kvmmap>:
{
    80001718:	ff010113          	addi	sp,sp,-16
    8000171c:	00113423          	sd	ra,8(sp)
    80001720:	00813023          	sd	s0,0(sp)
    80001724:	01010413          	addi	s0,sp,16
    80001728:	00068793          	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000172c:	00060693          	mv	a3,a2
    80001730:	00078613          	mv	a2,a5
    80001734:	00000097          	auipc	ra,0x0
    80001738:	eec080e7          	jalr	-276(ra) # 80001620 <mappages>
    8000173c:	00051a63          	bnez	a0,80001750 <kvmmap+0x38>
}
    80001740:	00813083          	ld	ra,8(sp)
    80001744:	00013403          	ld	s0,0(sp)
    80001748:	01010113          	addi	sp,sp,16
    8000174c:	00008067          	ret
    panic("kvmmap");
    80001750:	00009517          	auipc	a0,0x9
    80001754:	9a050513          	addi	a0,a0,-1632 # 8000a0f0 <digits+0xb0>
    80001758:	fffff097          	auipc	ra,0xfffff
    8000175c:	f74080e7          	jalr	-140(ra) # 800006cc <panic>

0000000080001760 <kvmmake>:
{
    80001760:	fd010113          	addi	sp,sp,-48
    80001764:	02113423          	sd	ra,40(sp)
    80001768:	02813023          	sd	s0,32(sp)
    8000176c:	00913c23          	sd	s1,24(sp)
    80001770:	01213823          	sd	s2,16(sp)
    80001774:	01313423          	sd	s3,8(sp)
    80001778:	03010413          	addi	s0,sp,48
  kpgtbl = (pagetable_t) kalloc();
    8000177c:	fffff097          	auipc	ra,0xfffff
    80001780:	6a4080e7          	jalr	1700(ra) # 80000e20 <kalloc>
    80001784:	00050493          	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001788:	00001637          	lui	a2,0x1
    8000178c:	00000593          	li	a1,0
    80001790:	00000097          	auipc	ra,0x0
    80001794:	930080e7          	jalr	-1744(ra) # 800010c0 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001798:	00600713          	li	a4,6
    8000179c:	000016b7          	lui	a3,0x1
    800017a0:	10000637          	lui	a2,0x10000
    800017a4:	100005b7          	lui	a1,0x10000
    800017a8:	00048513          	mv	a0,s1
    800017ac:	00000097          	auipc	ra,0x0
    800017b0:	f6c080e7          	jalr	-148(ra) # 80001718 <kvmmap>
  kvmmap(kpgtbl, RAMDISK, RAMDISK, FSSIZE * BSIZE, PTE_R | PTE_W);
    800017b4:	00600713          	li	a4,6
    800017b8:	000fa6b7          	lui	a3,0xfa
    800017bc:	01100913          	li	s2,17
    800017c0:	01b91613          	slli	a2,s2,0x1b
    800017c4:	00060593          	mv	a1,a2
    800017c8:	00048513          	mv	a0,s1
    800017cc:	00000097          	auipc	ra,0x0
    800017d0:	f4c080e7          	jalr	-180(ra) # 80001718 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800017d4:	00600713          	li	a4,6
    800017d8:	004006b7          	lui	a3,0x400
    800017dc:	0c000637          	lui	a2,0xc000
    800017e0:	0c0005b7          	lui	a1,0xc000
    800017e4:	00048513          	mv	a0,s1
    800017e8:	00000097          	auipc	ra,0x0
    800017ec:	f30080e7          	jalr	-208(ra) # 80001718 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800017f0:	00009997          	auipc	s3,0x9
    800017f4:	81098993          	addi	s3,s3,-2032 # 8000a000 <etext>
    800017f8:	00a00713          	li	a4,10
    800017fc:	80009697          	auipc	a3,0x80009
    80001800:	80468693          	addi	a3,a3,-2044 # a000 <_entry-0x7fff6000>
    80001804:	00100613          	li	a2,1
    80001808:	01f61613          	slli	a2,a2,0x1f
    8000180c:	00060593          	mv	a1,a2
    80001810:	00048513          	mv	a0,s1
    80001814:	00000097          	auipc	ra,0x0
    80001818:	f04080e7          	jalr	-252(ra) # 80001718 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000181c:	01b91693          	slli	a3,s2,0x1b
    80001820:	00600713          	li	a4,6
    80001824:	413686b3          	sub	a3,a3,s3
    80001828:	00098613          	mv	a2,s3
    8000182c:	00098593          	mv	a1,s3
    80001830:	00048513          	mv	a0,s1
    80001834:	00000097          	auipc	ra,0x0
    80001838:	ee4080e7          	jalr	-284(ra) # 80001718 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000183c:	00a00713          	li	a4,10
    80001840:	000016b7          	lui	a3,0x1
    80001844:	00007617          	auipc	a2,0x7
    80001848:	7bc60613          	addi	a2,a2,1980 # 80009000 <_trampoline>
    8000184c:	040005b7          	lui	a1,0x4000
    80001850:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001854:	00c59593          	slli	a1,a1,0xc
    80001858:	00048513          	mv	a0,s1
    8000185c:	00000097          	auipc	ra,0x0
    80001860:	ebc080e7          	jalr	-324(ra) # 80001718 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001864:	00048513          	mv	a0,s1
    80001868:	00001097          	auipc	ra,0x1
    8000186c:	978080e7          	jalr	-1672(ra) # 800021e0 <proc_mapstacks>
}
    80001870:	00048513          	mv	a0,s1
    80001874:	02813083          	ld	ra,40(sp)
    80001878:	02013403          	ld	s0,32(sp)
    8000187c:	01813483          	ld	s1,24(sp)
    80001880:	01013903          	ld	s2,16(sp)
    80001884:	00813983          	ld	s3,8(sp)
    80001888:	03010113          	addi	sp,sp,48
    8000188c:	00008067          	ret

0000000080001890 <kvminit>:
{
    80001890:	ff010113          	addi	sp,sp,-16
    80001894:	00113423          	sd	ra,8(sp)
    80001898:	00813023          	sd	s0,0(sp)
    8000189c:	01010413          	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800018a0:	00000097          	auipc	ra,0x0
    800018a4:	ec0080e7          	jalr	-320(ra) # 80001760 <kvmmake>
    800018a8:	00009797          	auipc	a5,0x9
    800018ac:	f8a7b423          	sd	a0,-120(a5) # 8000a830 <kernel_pagetable>
}
    800018b0:	00813083          	ld	ra,8(sp)
    800018b4:	00013403          	ld	s0,0(sp)
    800018b8:	01010113          	addi	sp,sp,16
    800018bc:	00008067          	ret

00000000800018c0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800018c0:	fb010113          	addi	sp,sp,-80
    800018c4:	04113423          	sd	ra,72(sp)
    800018c8:	04813023          	sd	s0,64(sp)
    800018cc:	02913c23          	sd	s1,56(sp)
    800018d0:	03213823          	sd	s2,48(sp)
    800018d4:	03313423          	sd	s3,40(sp)
    800018d8:	03413023          	sd	s4,32(sp)
    800018dc:	01513c23          	sd	s5,24(sp)
    800018e0:	01613823          	sd	s6,16(sp)
    800018e4:	01713423          	sd	s7,8(sp)
    800018e8:	05010413          	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800018ec:	03459793          	slli	a5,a1,0x34
    800018f0:	04079863          	bnez	a5,80001940 <uvmunmap+0x80>
    800018f4:	00050a13          	mv	s4,a0
    800018f8:	00058913          	mv	s2,a1
    800018fc:	00068a93          	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001900:	00c61613          	slli	a2,a2,0xc
    80001904:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001908:	00100b93          	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000190c:	00001b37          	lui	s6,0x1
    80001910:	0735ee63          	bltu	a1,s3,8000198c <uvmunmap+0xcc>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001914:	04813083          	ld	ra,72(sp)
    80001918:	04013403          	ld	s0,64(sp)
    8000191c:	03813483          	ld	s1,56(sp)
    80001920:	03013903          	ld	s2,48(sp)
    80001924:	02813983          	ld	s3,40(sp)
    80001928:	02013a03          	ld	s4,32(sp)
    8000192c:	01813a83          	ld	s5,24(sp)
    80001930:	01013b03          	ld	s6,16(sp)
    80001934:	00813b83          	ld	s7,8(sp)
    80001938:	05010113          	addi	sp,sp,80
    8000193c:	00008067          	ret
    panic("uvmunmap: not aligned");
    80001940:	00008517          	auipc	a0,0x8
    80001944:	7b850513          	addi	a0,a0,1976 # 8000a0f8 <digits+0xb8>
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	d84080e7          	jalr	-636(ra) # 800006cc <panic>
      panic("uvmunmap: walk");
    80001950:	00008517          	auipc	a0,0x8
    80001954:	7c050513          	addi	a0,a0,1984 # 8000a110 <digits+0xd0>
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	d74080e7          	jalr	-652(ra) # 800006cc <panic>
      panic("uvmunmap: not mapped");
    80001960:	00008517          	auipc	a0,0x8
    80001964:	7c050513          	addi	a0,a0,1984 # 8000a120 <digits+0xe0>
    80001968:	fffff097          	auipc	ra,0xfffff
    8000196c:	d64080e7          	jalr	-668(ra) # 800006cc <panic>
      panic("uvmunmap: not a leaf");
    80001970:	00008517          	auipc	a0,0x8
    80001974:	7c850513          	addi	a0,a0,1992 # 8000a138 <digits+0xf8>
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	d54080e7          	jalr	-684(ra) # 800006cc <panic>
    *pte = 0;
    80001980:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001984:	01690933          	add	s2,s2,s6
    80001988:	f93976e3          	bgeu	s2,s3,80001914 <uvmunmap+0x54>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000198c:	00000613          	li	a2,0
    80001990:	00090593          	mv	a1,s2
    80001994:	000a0513          	mv	a0,s4
    80001998:	00000097          	auipc	ra,0x0
    8000199c:	b20080e7          	jalr	-1248(ra) # 800014b8 <walk>
    800019a0:	00050493          	mv	s1,a0
    800019a4:	fa0506e3          	beqz	a0,80001950 <uvmunmap+0x90>
    if((*pte & PTE_V) == 0)
    800019a8:	00053503          	ld	a0,0(a0)
    800019ac:	00157793          	andi	a5,a0,1
    800019b0:	fa0788e3          	beqz	a5,80001960 <uvmunmap+0xa0>
    if(PTE_FLAGS(*pte) == PTE_V)
    800019b4:	3ff57793          	andi	a5,a0,1023
    800019b8:	fb778ce3          	beq	a5,s7,80001970 <uvmunmap+0xb0>
    if(do_free){
    800019bc:	fc0a82e3          	beqz	s5,80001980 <uvmunmap+0xc0>
      uint64 pa = PTE2PA(*pte);
    800019c0:	00a55513          	srli	a0,a0,0xa
      kfree((void*)pa);
    800019c4:	00c51513          	slli	a0,a0,0xc
    800019c8:	fffff097          	auipc	ra,0xfffff
    800019cc:	32c080e7          	jalr	812(ra) # 80000cf4 <kfree>
    800019d0:	fb1ff06f          	j	80001980 <uvmunmap+0xc0>

00000000800019d4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800019d4:	fe010113          	addi	sp,sp,-32
    800019d8:	00113c23          	sd	ra,24(sp)
    800019dc:	00813823          	sd	s0,16(sp)
    800019e0:	00913423          	sd	s1,8(sp)
    800019e4:	02010413          	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800019e8:	fffff097          	auipc	ra,0xfffff
    800019ec:	438080e7          	jalr	1080(ra) # 80000e20 <kalloc>
    800019f0:	00050493          	mv	s1,a0
  if(pagetable == 0)
    800019f4:	00050a63          	beqz	a0,80001a08 <uvmcreate+0x34>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800019f8:	00001637          	lui	a2,0x1
    800019fc:	00000593          	li	a1,0
    80001a00:	fffff097          	auipc	ra,0xfffff
    80001a04:	6c0080e7          	jalr	1728(ra) # 800010c0 <memset>
  return pagetable;
}
    80001a08:	00048513          	mv	a0,s1
    80001a0c:	01813083          	ld	ra,24(sp)
    80001a10:	01013403          	ld	s0,16(sp)
    80001a14:	00813483          	ld	s1,8(sp)
    80001a18:	02010113          	addi	sp,sp,32
    80001a1c:	00008067          	ret

0000000080001a20 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001a20:	fd010113          	addi	sp,sp,-48
    80001a24:	02113423          	sd	ra,40(sp)
    80001a28:	02813023          	sd	s0,32(sp)
    80001a2c:	00913c23          	sd	s1,24(sp)
    80001a30:	01213823          	sd	s2,16(sp)
    80001a34:	01313423          	sd	s3,8(sp)
    80001a38:	01413023          	sd	s4,0(sp)
    80001a3c:	03010413          	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001a40:	000017b7          	lui	a5,0x1
    80001a44:	06f67e63          	bgeu	a2,a5,80001ac0 <uvminit+0xa0>
    80001a48:	00050a13          	mv	s4,a0
    80001a4c:	00058993          	mv	s3,a1
    80001a50:	00060493          	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	3cc080e7          	jalr	972(ra) # 80000e20 <kalloc>
    80001a5c:	00050913          	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001a60:	00001637          	lui	a2,0x1
    80001a64:	00000593          	li	a1,0
    80001a68:	fffff097          	auipc	ra,0xfffff
    80001a6c:	658080e7          	jalr	1624(ra) # 800010c0 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001a70:	01e00713          	li	a4,30
    80001a74:	00090693          	mv	a3,s2
    80001a78:	00001637          	lui	a2,0x1
    80001a7c:	00000593          	li	a1,0
    80001a80:	000a0513          	mv	a0,s4
    80001a84:	00000097          	auipc	ra,0x0
    80001a88:	b9c080e7          	jalr	-1124(ra) # 80001620 <mappages>
  memmove(mem, src, sz);
    80001a8c:	00048613          	mv	a2,s1
    80001a90:	00098593          	mv	a1,s3
    80001a94:	00090513          	mv	a0,s2
    80001a98:	fffff097          	auipc	ra,0xfffff
    80001a9c:	6bc080e7          	jalr	1724(ra) # 80001154 <memmove>
}
    80001aa0:	02813083          	ld	ra,40(sp)
    80001aa4:	02013403          	ld	s0,32(sp)
    80001aa8:	01813483          	ld	s1,24(sp)
    80001aac:	01013903          	ld	s2,16(sp)
    80001ab0:	00813983          	ld	s3,8(sp)
    80001ab4:	00013a03          	ld	s4,0(sp)
    80001ab8:	03010113          	addi	sp,sp,48
    80001abc:	00008067          	ret
    panic("inituvm: more than a page");
    80001ac0:	00008517          	auipc	a0,0x8
    80001ac4:	69050513          	addi	a0,a0,1680 # 8000a150 <digits+0x110>
    80001ac8:	fffff097          	auipc	ra,0xfffff
    80001acc:	c04080e7          	jalr	-1020(ra) # 800006cc <panic>

0000000080001ad0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001ad0:	fe010113          	addi	sp,sp,-32
    80001ad4:	00113c23          	sd	ra,24(sp)
    80001ad8:	00813823          	sd	s0,16(sp)
    80001adc:	00913423          	sd	s1,8(sp)
    80001ae0:	02010413          	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001ae4:	00058493          	mv	s1,a1
  if(newsz >= oldsz)
    80001ae8:	02b67463          	bgeu	a2,a1,80001b10 <uvmdealloc+0x40>
    80001aec:	00060493          	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001af0:	000017b7          	lui	a5,0x1
    80001af4:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001af8:	00f60733          	add	a4,a2,a5
    80001afc:	fffff637          	lui	a2,0xfffff
    80001b00:	00c77733          	and	a4,a4,a2
    80001b04:	00f587b3          	add	a5,a1,a5
    80001b08:	00c7f7b3          	and	a5,a5,a2
    80001b0c:	00f76e63          	bltu	a4,a5,80001b28 <uvmdealloc+0x58>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001b10:	00048513          	mv	a0,s1
    80001b14:	01813083          	ld	ra,24(sp)
    80001b18:	01013403          	ld	s0,16(sp)
    80001b1c:	00813483          	ld	s1,8(sp)
    80001b20:	02010113          	addi	sp,sp,32
    80001b24:	00008067          	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001b28:	40e787b3          	sub	a5,a5,a4
    80001b2c:	00c7d793          	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001b30:	00100693          	li	a3,1
    80001b34:	0007861b          	sext.w	a2,a5
    80001b38:	00070593          	mv	a1,a4
    80001b3c:	00000097          	auipc	ra,0x0
    80001b40:	d84080e7          	jalr	-636(ra) # 800018c0 <uvmunmap>
    80001b44:	fcdff06f          	j	80001b10 <uvmdealloc+0x40>

0000000080001b48 <uvmalloc>:
  if(newsz < oldsz)
    80001b48:	10b66263          	bltu	a2,a1,80001c4c <uvmalloc+0x104>
{
    80001b4c:	fc010113          	addi	sp,sp,-64
    80001b50:	02113c23          	sd	ra,56(sp)
    80001b54:	02813823          	sd	s0,48(sp)
    80001b58:	02913423          	sd	s1,40(sp)
    80001b5c:	03213023          	sd	s2,32(sp)
    80001b60:	01313c23          	sd	s3,24(sp)
    80001b64:	01413823          	sd	s4,16(sp)
    80001b68:	01513423          	sd	s5,8(sp)
    80001b6c:	04010413          	addi	s0,sp,64
    80001b70:	00050a93          	mv	s5,a0
    80001b74:	00060a13          	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001b78:	000019b7          	lui	s3,0x1
    80001b7c:	fff98993          	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80001b80:	013585b3          	add	a1,a1,s3
    80001b84:	fffff9b7          	lui	s3,0xfffff
    80001b88:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001b8c:	0cc9f463          	bgeu	s3,a2,80001c54 <uvmalloc+0x10c>
    80001b90:	00098913          	mv	s2,s3
    mem = kalloc();
    80001b94:	fffff097          	auipc	ra,0xfffff
    80001b98:	28c080e7          	jalr	652(ra) # 80000e20 <kalloc>
    80001b9c:	00050493          	mv	s1,a0
    if(mem == 0){
    80001ba0:	04050463          	beqz	a0,80001be8 <uvmalloc+0xa0>
    memset(mem, 0, PGSIZE);
    80001ba4:	00001637          	lui	a2,0x1
    80001ba8:	00000593          	li	a1,0
    80001bac:	fffff097          	auipc	ra,0xfffff
    80001bb0:	514080e7          	jalr	1300(ra) # 800010c0 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001bb4:	01e00713          	li	a4,30
    80001bb8:	00048693          	mv	a3,s1
    80001bbc:	00001637          	lui	a2,0x1
    80001bc0:	00090593          	mv	a1,s2
    80001bc4:	000a8513          	mv	a0,s5
    80001bc8:	00000097          	auipc	ra,0x0
    80001bcc:	a58080e7          	jalr	-1448(ra) # 80001620 <mappages>
    80001bd0:	04051a63          	bnez	a0,80001c24 <uvmalloc+0xdc>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001bd4:	000017b7          	lui	a5,0x1
    80001bd8:	00f90933          	add	s2,s2,a5
    80001bdc:	fb496ce3          	bltu	s2,s4,80001b94 <uvmalloc+0x4c>
  return newsz;
    80001be0:	000a0513          	mv	a0,s4
    80001be4:	01c0006f          	j	80001c00 <uvmalloc+0xb8>
      uvmdealloc(pagetable, a, oldsz);
    80001be8:	00098613          	mv	a2,s3
    80001bec:	00090593          	mv	a1,s2
    80001bf0:	000a8513          	mv	a0,s5
    80001bf4:	00000097          	auipc	ra,0x0
    80001bf8:	edc080e7          	jalr	-292(ra) # 80001ad0 <uvmdealloc>
      return 0;
    80001bfc:	00000513          	li	a0,0
}
    80001c00:	03813083          	ld	ra,56(sp)
    80001c04:	03013403          	ld	s0,48(sp)
    80001c08:	02813483          	ld	s1,40(sp)
    80001c0c:	02013903          	ld	s2,32(sp)
    80001c10:	01813983          	ld	s3,24(sp)
    80001c14:	01013a03          	ld	s4,16(sp)
    80001c18:	00813a83          	ld	s5,8(sp)
    80001c1c:	04010113          	addi	sp,sp,64
    80001c20:	00008067          	ret
      kfree(mem);
    80001c24:	00048513          	mv	a0,s1
    80001c28:	fffff097          	auipc	ra,0xfffff
    80001c2c:	0cc080e7          	jalr	204(ra) # 80000cf4 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001c30:	00098613          	mv	a2,s3
    80001c34:	00090593          	mv	a1,s2
    80001c38:	000a8513          	mv	a0,s5
    80001c3c:	00000097          	auipc	ra,0x0
    80001c40:	e94080e7          	jalr	-364(ra) # 80001ad0 <uvmdealloc>
      return 0;
    80001c44:	00000513          	li	a0,0
    80001c48:	fb9ff06f          	j	80001c00 <uvmalloc+0xb8>
    return oldsz;
    80001c4c:	00058513          	mv	a0,a1
}
    80001c50:	00008067          	ret
  return newsz;
    80001c54:	00060513          	mv	a0,a2
    80001c58:	fa9ff06f          	j	80001c00 <uvmalloc+0xb8>

0000000080001c5c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001c5c:	fd010113          	addi	sp,sp,-48
    80001c60:	02113423          	sd	ra,40(sp)
    80001c64:	02813023          	sd	s0,32(sp)
    80001c68:	00913c23          	sd	s1,24(sp)
    80001c6c:	01213823          	sd	s2,16(sp)
    80001c70:	01313423          	sd	s3,8(sp)
    80001c74:	01413023          	sd	s4,0(sp)
    80001c78:	03010413          	addi	s0,sp,48
    80001c7c:	00050a13          	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001c80:	00050493          	mv	s1,a0
    80001c84:	00001937          	lui	s2,0x1
    80001c88:	01250933          	add	s2,a0,s2
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001c8c:	00100993          	li	s3,1
    80001c90:	0200006f          	j	80001cb0 <freewalk+0x54>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001c94:	00a55513          	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001c98:	00c51513          	slli	a0,a0,0xc
    80001c9c:	00000097          	auipc	ra,0x0
    80001ca0:	fc0080e7          	jalr	-64(ra) # 80001c5c <freewalk>
      pagetable[i] = 0;
    80001ca4:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001ca8:	00848493          	addi	s1,s1,8
    80001cac:	03248463          	beq	s1,s2,80001cd4 <freewalk+0x78>
    pte_t pte = pagetable[i];
    80001cb0:	0004b503          	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001cb4:	00f57793          	andi	a5,a0,15
    80001cb8:	fd378ee3          	beq	a5,s3,80001c94 <freewalk+0x38>
    } else if(pte & PTE_V){
    80001cbc:	00157513          	andi	a0,a0,1
    80001cc0:	fe0504e3          	beqz	a0,80001ca8 <freewalk+0x4c>
      panic("freewalk: leaf");
    80001cc4:	00008517          	auipc	a0,0x8
    80001cc8:	4ac50513          	addi	a0,a0,1196 # 8000a170 <digits+0x130>
    80001ccc:	fffff097          	auipc	ra,0xfffff
    80001cd0:	a00080e7          	jalr	-1536(ra) # 800006cc <panic>
    }
  }
  kfree((void*)pagetable);
    80001cd4:	000a0513          	mv	a0,s4
    80001cd8:	fffff097          	auipc	ra,0xfffff
    80001cdc:	01c080e7          	jalr	28(ra) # 80000cf4 <kfree>
}
    80001ce0:	02813083          	ld	ra,40(sp)
    80001ce4:	02013403          	ld	s0,32(sp)
    80001ce8:	01813483          	ld	s1,24(sp)
    80001cec:	01013903          	ld	s2,16(sp)
    80001cf0:	00813983          	ld	s3,8(sp)
    80001cf4:	00013a03          	ld	s4,0(sp)
    80001cf8:	03010113          	addi	sp,sp,48
    80001cfc:	00008067          	ret

0000000080001d00 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001d00:	fe010113          	addi	sp,sp,-32
    80001d04:	00113c23          	sd	ra,24(sp)
    80001d08:	00813823          	sd	s0,16(sp)
    80001d0c:	00913423          	sd	s1,8(sp)
    80001d10:	02010413          	addi	s0,sp,32
    80001d14:	00050493          	mv	s1,a0
  if(sz > 0)
    80001d18:	02059263          	bnez	a1,80001d3c <uvmfree+0x3c>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001d1c:	00048513          	mv	a0,s1
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	f3c080e7          	jalr	-196(ra) # 80001c5c <freewalk>
}
    80001d28:	01813083          	ld	ra,24(sp)
    80001d2c:	01013403          	ld	s0,16(sp)
    80001d30:	00813483          	ld	s1,8(sp)
    80001d34:	02010113          	addi	sp,sp,32
    80001d38:	00008067          	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001d3c:	00001637          	lui	a2,0x1
    80001d40:	fff60613          	addi	a2,a2,-1 # fff <_entry-0x7ffff001>
    80001d44:	00c58633          	add	a2,a1,a2
    80001d48:	00100693          	li	a3,1
    80001d4c:	00c65613          	srli	a2,a2,0xc
    80001d50:	00000593          	li	a1,0
    80001d54:	00000097          	auipc	ra,0x0
    80001d58:	b6c080e7          	jalr	-1172(ra) # 800018c0 <uvmunmap>
    80001d5c:	fc1ff06f          	j	80001d1c <uvmfree+0x1c>

0000000080001d60 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001d60:	12060e63          	beqz	a2,80001e9c <uvmcopy+0x13c>
{
    80001d64:	fb010113          	addi	sp,sp,-80
    80001d68:	04113423          	sd	ra,72(sp)
    80001d6c:	04813023          	sd	s0,64(sp)
    80001d70:	02913c23          	sd	s1,56(sp)
    80001d74:	03213823          	sd	s2,48(sp)
    80001d78:	03313423          	sd	s3,40(sp)
    80001d7c:	03413023          	sd	s4,32(sp)
    80001d80:	01513c23          	sd	s5,24(sp)
    80001d84:	01613823          	sd	s6,16(sp)
    80001d88:	01713423          	sd	s7,8(sp)
    80001d8c:	05010413          	addi	s0,sp,80
    80001d90:	00050b13          	mv	s6,a0
    80001d94:	00058a93          	mv	s5,a1
    80001d98:	00060a13          	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001d9c:	00000993          	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001da0:	00000613          	li	a2,0
    80001da4:	00098593          	mv	a1,s3
    80001da8:	000b0513          	mv	a0,s6
    80001dac:	fffff097          	auipc	ra,0xfffff
    80001db0:	70c080e7          	jalr	1804(ra) # 800014b8 <walk>
    80001db4:	06050a63          	beqz	a0,80001e28 <uvmcopy+0xc8>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001db8:	00053703          	ld	a4,0(a0)
    80001dbc:	00177793          	andi	a5,a4,1
    80001dc0:	06078c63          	beqz	a5,80001e38 <uvmcopy+0xd8>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001dc4:	00a75593          	srli	a1,a4,0xa
    80001dc8:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001dcc:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001dd0:	fffff097          	auipc	ra,0xfffff
    80001dd4:	050080e7          	jalr	80(ra) # 80000e20 <kalloc>
    80001dd8:	00050913          	mv	s2,a0
    80001ddc:	06050c63          	beqz	a0,80001e54 <uvmcopy+0xf4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001de0:	00001637          	lui	a2,0x1
    80001de4:	000b8593          	mv	a1,s7
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	36c080e7          	jalr	876(ra) # 80001154 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001df0:	00048713          	mv	a4,s1
    80001df4:	00090693          	mv	a3,s2
    80001df8:	00001637          	lui	a2,0x1
    80001dfc:	00098593          	mv	a1,s3
    80001e00:	000a8513          	mv	a0,s5
    80001e04:	00000097          	auipc	ra,0x0
    80001e08:	81c080e7          	jalr	-2020(ra) # 80001620 <mappages>
    80001e0c:	02051e63          	bnez	a0,80001e48 <uvmcopy+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
    80001e10:	000017b7          	lui	a5,0x1
    80001e14:	00f989b3          	add	s3,s3,a5
    80001e18:	f949e4e3          	bltu	s3,s4,80001da0 <uvmcopy+0x40>
      kfree(mem);
      goto err;
    }
  }

  asm volatile("fence.i");
    80001e1c:	0000100f          	fence.i
  return 0;
    80001e20:	00000513          	li	a0,0
    80001e24:	04c0006f          	j	80001e70 <uvmcopy+0x110>
      panic("uvmcopy: pte should exist");
    80001e28:	00008517          	auipc	a0,0x8
    80001e2c:	35850513          	addi	a0,a0,856 # 8000a180 <digits+0x140>
    80001e30:	fffff097          	auipc	ra,0xfffff
    80001e34:	89c080e7          	jalr	-1892(ra) # 800006cc <panic>
      panic("uvmcopy: page not present");
    80001e38:	00008517          	auipc	a0,0x8
    80001e3c:	36850513          	addi	a0,a0,872 # 8000a1a0 <digits+0x160>
    80001e40:	fffff097          	auipc	ra,0xfffff
    80001e44:	88c080e7          	jalr	-1908(ra) # 800006cc <panic>
      kfree(mem);
    80001e48:	00090513          	mv	a0,s2
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	ea8080e7          	jalr	-344(ra) # 80000cf4 <kfree>

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001e54:	00100693          	li	a3,1
    80001e58:	00c9d613          	srli	a2,s3,0xc
    80001e5c:	00000593          	li	a1,0
    80001e60:	000a8513          	mv	a0,s5
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	a5c080e7          	jalr	-1444(ra) # 800018c0 <uvmunmap>
  return -1;
    80001e6c:	fff00513          	li	a0,-1
}
    80001e70:	04813083          	ld	ra,72(sp)
    80001e74:	04013403          	ld	s0,64(sp)
    80001e78:	03813483          	ld	s1,56(sp)
    80001e7c:	03013903          	ld	s2,48(sp)
    80001e80:	02813983          	ld	s3,40(sp)
    80001e84:	02013a03          	ld	s4,32(sp)
    80001e88:	01813a83          	ld	s5,24(sp)
    80001e8c:	01013b03          	ld	s6,16(sp)
    80001e90:	00813b83          	ld	s7,8(sp)
    80001e94:	05010113          	addi	sp,sp,80
    80001e98:	00008067          	ret
  asm volatile("fence.i");
    80001e9c:	0000100f          	fence.i
  return 0;
    80001ea0:	00000513          	li	a0,0
}
    80001ea4:	00008067          	ret

0000000080001ea8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001ea8:	ff010113          	addi	sp,sp,-16
    80001eac:	00113423          	sd	ra,8(sp)
    80001eb0:	00813023          	sd	s0,0(sp)
    80001eb4:	01010413          	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001eb8:	00000613          	li	a2,0
    80001ebc:	fffff097          	auipc	ra,0xfffff
    80001ec0:	5fc080e7          	jalr	1532(ra) # 800014b8 <walk>
  if(pte == 0)
    80001ec4:	02050063          	beqz	a0,80001ee4 <uvmclear+0x3c>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001ec8:	00053783          	ld	a5,0(a0)
    80001ecc:	fef7f793          	andi	a5,a5,-17
    80001ed0:	00f53023          	sd	a5,0(a0)
}
    80001ed4:	00813083          	ld	ra,8(sp)
    80001ed8:	00013403          	ld	s0,0(sp)
    80001edc:	01010113          	addi	sp,sp,16
    80001ee0:	00008067          	ret
    panic("uvmclear");
    80001ee4:	00008517          	auipc	a0,0x8
    80001ee8:	2dc50513          	addi	a0,a0,732 # 8000a1c0 <digits+0x180>
    80001eec:	ffffe097          	auipc	ra,0xffffe
    80001ef0:	7e0080e7          	jalr	2016(ra) # 800006cc <panic>

0000000080001ef4 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001ef4:	0a068663          	beqz	a3,80001fa0 <copyout+0xac>
{
    80001ef8:	fb010113          	addi	sp,sp,-80
    80001efc:	04113423          	sd	ra,72(sp)
    80001f00:	04813023          	sd	s0,64(sp)
    80001f04:	02913c23          	sd	s1,56(sp)
    80001f08:	03213823          	sd	s2,48(sp)
    80001f0c:	03313423          	sd	s3,40(sp)
    80001f10:	03413023          	sd	s4,32(sp)
    80001f14:	01513c23          	sd	s5,24(sp)
    80001f18:	01613823          	sd	s6,16(sp)
    80001f1c:	01713423          	sd	s7,8(sp)
    80001f20:	01813023          	sd	s8,0(sp)
    80001f24:	05010413          	addi	s0,sp,80
    80001f28:	00050b13          	mv	s6,a0
    80001f2c:	00058c13          	mv	s8,a1
    80001f30:	00060a13          	mv	s4,a2
    80001f34:	00068993          	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001f38:	fffffbb7          	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001f3c:	00001ab7          	lui	s5,0x1
    80001f40:	02c0006f          	j	80001f6c <copyout+0x78>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001f44:	01850533          	add	a0,a0,s8
    80001f48:	0004861b          	sext.w	a2,s1
    80001f4c:	000a0593          	mv	a1,s4
    80001f50:	41250533          	sub	a0,a0,s2
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	200080e7          	jalr	512(ra) # 80001154 <memmove>

    len -= n;
    80001f5c:	409989b3          	sub	s3,s3,s1
    src += n;
    80001f60:	009a0a33          	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001f64:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001f68:	02098863          	beqz	s3,80001f98 <copyout+0xa4>
    va0 = PGROUNDDOWN(dstva);
    80001f6c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001f70:	00090593          	mv	a1,s2
    80001f74:	000b0513          	mv	a0,s6
    80001f78:	fffff097          	auipc	ra,0xfffff
    80001f7c:	63c080e7          	jalr	1596(ra) # 800015b4 <walkaddr>
    if(pa0 == 0)
    80001f80:	02050463          	beqz	a0,80001fa8 <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80001f84:	418904b3          	sub	s1,s2,s8
    80001f88:	015484b3          	add	s1,s1,s5
    if(n > len)
    80001f8c:	fa99fce3          	bgeu	s3,s1,80001f44 <copyout+0x50>
    80001f90:	00098493          	mv	s1,s3
    80001f94:	fb1ff06f          	j	80001f44 <copyout+0x50>
  }
  return 0;
    80001f98:	00000513          	li	a0,0
    80001f9c:	0100006f          	j	80001fac <copyout+0xb8>
    80001fa0:	00000513          	li	a0,0
}
    80001fa4:	00008067          	ret
      return -1;
    80001fa8:	fff00513          	li	a0,-1
}
    80001fac:	04813083          	ld	ra,72(sp)
    80001fb0:	04013403          	ld	s0,64(sp)
    80001fb4:	03813483          	ld	s1,56(sp)
    80001fb8:	03013903          	ld	s2,48(sp)
    80001fbc:	02813983          	ld	s3,40(sp)
    80001fc0:	02013a03          	ld	s4,32(sp)
    80001fc4:	01813a83          	ld	s5,24(sp)
    80001fc8:	01013b03          	ld	s6,16(sp)
    80001fcc:	00813b83          	ld	s7,8(sp)
    80001fd0:	00013c03          	ld	s8,0(sp)
    80001fd4:	05010113          	addi	sp,sp,80
    80001fd8:	00008067          	ret

0000000080001fdc <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001fdc:	0a068663          	beqz	a3,80002088 <copyin+0xac>
{
    80001fe0:	fb010113          	addi	sp,sp,-80
    80001fe4:	04113423          	sd	ra,72(sp)
    80001fe8:	04813023          	sd	s0,64(sp)
    80001fec:	02913c23          	sd	s1,56(sp)
    80001ff0:	03213823          	sd	s2,48(sp)
    80001ff4:	03313423          	sd	s3,40(sp)
    80001ff8:	03413023          	sd	s4,32(sp)
    80001ffc:	01513c23          	sd	s5,24(sp)
    80002000:	01613823          	sd	s6,16(sp)
    80002004:	01713423          	sd	s7,8(sp)
    80002008:	01813023          	sd	s8,0(sp)
    8000200c:	05010413          	addi	s0,sp,80
    80002010:	00050b13          	mv	s6,a0
    80002014:	00058a13          	mv	s4,a1
    80002018:	00060c13          	mv	s8,a2
    8000201c:	00068993          	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80002020:	fffffbb7          	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80002024:	00001ab7          	lui	s5,0x1
    80002028:	02c0006f          	j	80002054 <copyin+0x78>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000202c:	018505b3          	add	a1,a0,s8
    80002030:	0004861b          	sext.w	a2,s1
    80002034:	412585b3          	sub	a1,a1,s2
    80002038:	000a0513          	mv	a0,s4
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	118080e7          	jalr	280(ra) # 80001154 <memmove>

    len -= n;
    80002044:	409989b3          	sub	s3,s3,s1
    dst += n;
    80002048:	009a0a33          	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000204c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80002050:	02098863          	beqz	s3,80002080 <copyin+0xa4>
    va0 = PGROUNDDOWN(srcva);
    80002054:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80002058:	00090593          	mv	a1,s2
    8000205c:	000b0513          	mv	a0,s6
    80002060:	fffff097          	auipc	ra,0xfffff
    80002064:	554080e7          	jalr	1364(ra) # 800015b4 <walkaddr>
    if(pa0 == 0)
    80002068:	02050463          	beqz	a0,80002090 <copyin+0xb4>
    n = PGSIZE - (srcva - va0);
    8000206c:	418904b3          	sub	s1,s2,s8
    80002070:	015484b3          	add	s1,s1,s5
    if(n > len)
    80002074:	fa99fce3          	bgeu	s3,s1,8000202c <copyin+0x50>
    80002078:	00098493          	mv	s1,s3
    8000207c:	fb1ff06f          	j	8000202c <copyin+0x50>
  }
  return 0;
    80002080:	00000513          	li	a0,0
    80002084:	0100006f          	j	80002094 <copyin+0xb8>
    80002088:	00000513          	li	a0,0
}
    8000208c:	00008067          	ret
      return -1;
    80002090:	fff00513          	li	a0,-1
}
    80002094:	04813083          	ld	ra,72(sp)
    80002098:	04013403          	ld	s0,64(sp)
    8000209c:	03813483          	ld	s1,56(sp)
    800020a0:	03013903          	ld	s2,48(sp)
    800020a4:	02813983          	ld	s3,40(sp)
    800020a8:	02013a03          	ld	s4,32(sp)
    800020ac:	01813a83          	ld	s5,24(sp)
    800020b0:	01013b03          	ld	s6,16(sp)
    800020b4:	00813b83          	ld	s7,8(sp)
    800020b8:	00013c03          	ld	s8,0(sp)
    800020bc:	05010113          	addi	sp,sp,80
    800020c0:	00008067          	ret

00000000800020c4 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800020c4:	10068663          	beqz	a3,800021d0 <copyinstr+0x10c>
{
    800020c8:	fb010113          	addi	sp,sp,-80
    800020cc:	04113423          	sd	ra,72(sp)
    800020d0:	04813023          	sd	s0,64(sp)
    800020d4:	02913c23          	sd	s1,56(sp)
    800020d8:	03213823          	sd	s2,48(sp)
    800020dc:	03313423          	sd	s3,40(sp)
    800020e0:	03413023          	sd	s4,32(sp)
    800020e4:	01513c23          	sd	s5,24(sp)
    800020e8:	01613823          	sd	s6,16(sp)
    800020ec:	01713423          	sd	s7,8(sp)
    800020f0:	05010413          	addi	s0,sp,80
    800020f4:	00050a13          	mv	s4,a0
    800020f8:	00058b13          	mv	s6,a1
    800020fc:	00060b93          	mv	s7,a2
    80002100:	00068493          	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80002104:	fffffab7          	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80002108:	000019b7          	lui	s3,0x1
    8000210c:	0480006f          	j	80002154 <copyinstr+0x90>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80002110:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80002114:	00100793          	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80002118:	0017b793          	seqz	a5,a5
    8000211c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80002120:	04813083          	ld	ra,72(sp)
    80002124:	04013403          	ld	s0,64(sp)
    80002128:	03813483          	ld	s1,56(sp)
    8000212c:	03013903          	ld	s2,48(sp)
    80002130:	02813983          	ld	s3,40(sp)
    80002134:	02013a03          	ld	s4,32(sp)
    80002138:	01813a83          	ld	s5,24(sp)
    8000213c:	01013b03          	ld	s6,16(sp)
    80002140:	00813b83          	ld	s7,8(sp)
    80002144:	05010113          	addi	sp,sp,80
    80002148:	00008067          	ret
    srcva = va0 + PGSIZE;
    8000214c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80002150:	06048863          	beqz	s1,800021c0 <copyinstr+0xfc>
    va0 = PGROUNDDOWN(srcva);
    80002154:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80002158:	00090593          	mv	a1,s2
    8000215c:	000a0513          	mv	a0,s4
    80002160:	fffff097          	auipc	ra,0xfffff
    80002164:	454080e7          	jalr	1108(ra) # 800015b4 <walkaddr>
    if(pa0 == 0)
    80002168:	06050063          	beqz	a0,800021c8 <copyinstr+0x104>
    n = PGSIZE - (srcva - va0);
    8000216c:	41790833          	sub	a6,s2,s7
    80002170:	01380833          	add	a6,a6,s3
    if(n > max)
    80002174:	0104f463          	bgeu	s1,a6,8000217c <copyinstr+0xb8>
    80002178:	00048813          	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000217c:	01750533          	add	a0,a0,s7
    80002180:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80002184:	fc0804e3          	beqz	a6,8000214c <copyinstr+0x88>
    80002188:	010b0833          	add	a6,s6,a6
    8000218c:	000b0793          	mv	a5,s6
      if(*p == '\0'){
    80002190:	41650633          	sub	a2,a0,s6
    80002194:	fff48493          	addi	s1,s1,-1
    80002198:	009b0b33          	add	s6,s6,s1
    8000219c:	00f60733          	add	a4,a2,a5
    800021a0:	00074703          	lbu	a4,0(a4)
    800021a4:	f60706e3          	beqz	a4,80002110 <copyinstr+0x4c>
        *dst = *p;
    800021a8:	00e78023          	sb	a4,0(a5)
      --max;
    800021ac:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800021b0:	00178793          	addi	a5,a5,1
    while(n > 0){
    800021b4:	ff0794e3          	bne	a5,a6,8000219c <copyinstr+0xd8>
      dst++;
    800021b8:	00080b13          	mv	s6,a6
    800021bc:	f91ff06f          	j	8000214c <copyinstr+0x88>
    800021c0:	00000793          	li	a5,0
    800021c4:	f55ff06f          	j	80002118 <copyinstr+0x54>
      return -1;
    800021c8:	fff00513          	li	a0,-1
    800021cc:	f55ff06f          	j	80002120 <copyinstr+0x5c>
  int got_null = 0;
    800021d0:	00000793          	li	a5,0
  if(got_null){
    800021d4:	0017b793          	seqz	a5,a5
    800021d8:	40f00533          	neg	a0,a5
}
    800021dc:	00008067          	ret

00000000800021e0 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    800021e0:	fc010113          	addi	sp,sp,-64
    800021e4:	02113c23          	sd	ra,56(sp)
    800021e8:	02813823          	sd	s0,48(sp)
    800021ec:	02913423          	sd	s1,40(sp)
    800021f0:	03213023          	sd	s2,32(sp)
    800021f4:	01313c23          	sd	s3,24(sp)
    800021f8:	01413823          	sd	s4,16(sp)
    800021fc:	01513423          	sd	s5,8(sp)
    80002200:	01613023          	sd	s6,0(sp)
    80002204:	04010413          	addi	s0,sp,64
    80002208:	00050993          	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000220c:	00011497          	auipc	s1,0x11
    80002210:	cd448493          	addi	s1,s1,-812 # 80012ee0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80002214:	00048b13          	mv	s6,s1
    80002218:	00008a97          	auipc	s5,0x8
    8000221c:	de8a8a93          	addi	s5,s5,-536 # 8000a000 <etext>
    80002220:	04000937          	lui	s2,0x4000
    80002224:	fff90913          	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80002228:	00c91913          	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000222c:	00016a17          	auipc	s4,0x16
    80002230:	6b4a0a13          	addi	s4,s4,1716 # 800188e0 <tickslock>
    char *pa = kalloc();
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	bec080e7          	jalr	-1044(ra) # 80000e20 <kalloc>
    8000223c:	00050613          	mv	a2,a0
    if(pa == 0)
    80002240:	06050263          	beqz	a0,800022a4 <proc_mapstacks+0xc4>
    uint64 va = KSTACK((int) (p - proc));
    80002244:	416485b3          	sub	a1,s1,s6
    80002248:	4035d593          	srai	a1,a1,0x3
    8000224c:	000ab783          	ld	a5,0(s5)
    80002250:	02f585b3          	mul	a1,a1,a5
    80002254:	0015859b          	addiw	a1,a1,1
    80002258:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000225c:	00600713          	li	a4,6
    80002260:	000016b7          	lui	a3,0x1
    80002264:	40b905b3          	sub	a1,s2,a1
    80002268:	00098513          	mv	a0,s3
    8000226c:	fffff097          	auipc	ra,0xfffff
    80002270:	4ac080e7          	jalr	1196(ra) # 80001718 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002274:	16848493          	addi	s1,s1,360
    80002278:	fb449ee3          	bne	s1,s4,80002234 <proc_mapstacks+0x54>
  }
}
    8000227c:	03813083          	ld	ra,56(sp)
    80002280:	03013403          	ld	s0,48(sp)
    80002284:	02813483          	ld	s1,40(sp)
    80002288:	02013903          	ld	s2,32(sp)
    8000228c:	01813983          	ld	s3,24(sp)
    80002290:	01013a03          	ld	s4,16(sp)
    80002294:	00813a83          	ld	s5,8(sp)
    80002298:	00013b03          	ld	s6,0(sp)
    8000229c:	04010113          	addi	sp,sp,64
    800022a0:	00008067          	ret
      panic("kalloc");
    800022a4:	00008517          	auipc	a0,0x8
    800022a8:	f2c50513          	addi	a0,a0,-212 # 8000a1d0 <digits+0x190>
    800022ac:	ffffe097          	auipc	ra,0xffffe
    800022b0:	420080e7          	jalr	1056(ra) # 800006cc <panic>

00000000800022b4 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    800022b4:	fc010113          	addi	sp,sp,-64
    800022b8:	02113c23          	sd	ra,56(sp)
    800022bc:	02813823          	sd	s0,48(sp)
    800022c0:	02913423          	sd	s1,40(sp)
    800022c4:	03213023          	sd	s2,32(sp)
    800022c8:	01313c23          	sd	s3,24(sp)
    800022cc:	01413823          	sd	s4,16(sp)
    800022d0:	01513423          	sd	s5,8(sp)
    800022d4:	01613023          	sd	s6,0(sp)
    800022d8:	04010413          	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800022dc:	00008597          	auipc	a1,0x8
    800022e0:	efc58593          	addi	a1,a1,-260 # 8000a1d8 <digits+0x198>
    800022e4:	00010517          	auipc	a0,0x10
    800022e8:	7cc50513          	addi	a0,a0,1996 # 80012ab0 <pid_lock>
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	b98080e7          	jalr	-1128(ra) # 80000e84 <initlock>
  initlock(&wait_lock, "wait_lock");
    800022f4:	00008597          	auipc	a1,0x8
    800022f8:	eec58593          	addi	a1,a1,-276 # 8000a1e0 <digits+0x1a0>
    800022fc:	00010517          	auipc	a0,0x10
    80002300:	7cc50513          	addi	a0,a0,1996 # 80012ac8 <wait_lock>
    80002304:	fffff097          	auipc	ra,0xfffff
    80002308:	b80080e7          	jalr	-1152(ra) # 80000e84 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000230c:	00011497          	auipc	s1,0x11
    80002310:	bd448493          	addi	s1,s1,-1068 # 80012ee0 <proc>
      initlock(&p->lock, "proc");
    80002314:	00008b17          	auipc	s6,0x8
    80002318:	edcb0b13          	addi	s6,s6,-292 # 8000a1f0 <digits+0x1b0>
      p->kstack = KSTACK((int) (p - proc));
    8000231c:	00048a93          	mv	s5,s1
    80002320:	00008a17          	auipc	s4,0x8
    80002324:	ce0a0a13          	addi	s4,s4,-800 # 8000a000 <etext>
    80002328:	04000937          	lui	s2,0x4000
    8000232c:	fff90913          	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80002330:	00c91913          	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80002334:	00016997          	auipc	s3,0x16
    80002338:	5ac98993          	addi	s3,s3,1452 # 800188e0 <tickslock>
      initlock(&p->lock, "proc");
    8000233c:	000b0593          	mv	a1,s6
    80002340:	00048513          	mv	a0,s1
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	b40080e7          	jalr	-1216(ra) # 80000e84 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    8000234c:	415487b3          	sub	a5,s1,s5
    80002350:	4037d793          	srai	a5,a5,0x3
    80002354:	000a3703          	ld	a4,0(s4)
    80002358:	02e787b3          	mul	a5,a5,a4
    8000235c:	0017879b          	addiw	a5,a5,1
    80002360:	00d7979b          	slliw	a5,a5,0xd
    80002364:	40f907b3          	sub	a5,s2,a5
    80002368:	04f4b023          	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000236c:	16848493          	addi	s1,s1,360
    80002370:	fd3496e3          	bne	s1,s3,8000233c <procinit+0x88>
  }
}
    80002374:	03813083          	ld	ra,56(sp)
    80002378:	03013403          	ld	s0,48(sp)
    8000237c:	02813483          	ld	s1,40(sp)
    80002380:	02013903          	ld	s2,32(sp)
    80002384:	01813983          	ld	s3,24(sp)
    80002388:	01013a03          	ld	s4,16(sp)
    8000238c:	00813a83          	ld	s5,8(sp)
    80002390:	00013b03          	ld	s6,0(sp)
    80002394:	04010113          	addi	sp,sp,64
    80002398:	00008067          	ret

000000008000239c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000239c:	ff010113          	addi	sp,sp,-16
    800023a0:	00813423          	sd	s0,8(sp)
    800023a4:	01010413          	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800023a8:	00020513          	mv	a0,tp
  int id = r_tp();
  return id;
}
    800023ac:	0005051b          	sext.w	a0,a0
    800023b0:	00813403          	ld	s0,8(sp)
    800023b4:	01010113          	addi	sp,sp,16
    800023b8:	00008067          	ret

00000000800023bc <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    800023bc:	ff010113          	addi	sp,sp,-16
    800023c0:	00813423          	sd	s0,8(sp)
    800023c4:	01010413          	addi	s0,sp,16
    800023c8:	00020793          	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800023cc:	0007879b          	sext.w	a5,a5
    800023d0:	00779793          	slli	a5,a5,0x7
  return c;
}
    800023d4:	00010517          	auipc	a0,0x10
    800023d8:	70c50513          	addi	a0,a0,1804 # 80012ae0 <cpus>
    800023dc:	00f50533          	add	a0,a0,a5
    800023e0:	00813403          	ld	s0,8(sp)
    800023e4:	01010113          	addi	sp,sp,16
    800023e8:	00008067          	ret

00000000800023ec <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    800023ec:	fe010113          	addi	sp,sp,-32
    800023f0:	00113c23          	sd	ra,24(sp)
    800023f4:	00813823          	sd	s0,16(sp)
    800023f8:	00913423          	sd	s1,8(sp)
    800023fc:	02010413          	addi	s0,sp,32
  push_off();
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	af4080e7          	jalr	-1292(ra) # 80000ef4 <push_off>
    80002408:	00020793          	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000240c:	0007879b          	sext.w	a5,a5
    80002410:	00779793          	slli	a5,a5,0x7
    80002414:	00010717          	auipc	a4,0x10
    80002418:	69c70713          	addi	a4,a4,1692 # 80012ab0 <pid_lock>
    8000241c:	00f707b3          	add	a5,a4,a5
    80002420:	0307b483          	ld	s1,48(a5)
  pop_off();
    80002424:	fffff097          	auipc	ra,0xfffff
    80002428:	bbc080e7          	jalr	-1092(ra) # 80000fe0 <pop_off>
  return p;
}
    8000242c:	00048513          	mv	a0,s1
    80002430:	01813083          	ld	ra,24(sp)
    80002434:	01013403          	ld	s0,16(sp)
    80002438:	00813483          	ld	s1,8(sp)
    8000243c:	02010113          	addi	sp,sp,32
    80002440:	00008067          	ret

0000000080002444 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80002444:	ff010113          	addi	sp,sp,-16
    80002448:	00113423          	sd	ra,8(sp)
    8000244c:	00813023          	sd	s0,0(sp)
    80002450:	01010413          	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80002454:	00000097          	auipc	ra,0x0
    80002458:	f98080e7          	jalr	-104(ra) # 800023ec <myproc>
    8000245c:	fffff097          	auipc	ra,0xfffff
    80002460:	c04080e7          	jalr	-1020(ra) # 80001060 <release>

  if (first) {
    80002464:	00008797          	auipc	a5,0x8
    80002468:	35c7a783          	lw	a5,860(a5) # 8000a7c0 <first.1>
    8000246c:	00079e63          	bnez	a5,80002488 <forkret+0x44>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80002470:	00001097          	auipc	ra,0x1
    80002474:	0c8080e7          	jalr	200(ra) # 80003538 <usertrapret>
}
    80002478:	00813083          	ld	ra,8(sp)
    8000247c:	00013403          	ld	s0,0(sp)
    80002480:	01010113          	addi	sp,sp,16
    80002484:	00008067          	ret
    first = 0;
    80002488:	00008797          	auipc	a5,0x8
    8000248c:	3207ac23          	sw	zero,824(a5) # 8000a7c0 <first.1>
    fsinit(ROOTDEV);
    80002490:	00100513          	li	a0,1
    80002494:	00002097          	auipc	ra,0x2
    80002498:	304080e7          	jalr	772(ra) # 80004798 <fsinit>
    8000249c:	fd5ff06f          	j	80002470 <forkret+0x2c>

00000000800024a0 <allocpid>:
allocpid() {
    800024a0:	fe010113          	addi	sp,sp,-32
    800024a4:	00113c23          	sd	ra,24(sp)
    800024a8:	00813823          	sd	s0,16(sp)
    800024ac:	00913423          	sd	s1,8(sp)
    800024b0:	01213023          	sd	s2,0(sp)
    800024b4:	02010413          	addi	s0,sp,32
  acquire(&pid_lock);
    800024b8:	00010917          	auipc	s2,0x10
    800024bc:	5f890913          	addi	s2,s2,1528 # 80012ab0 <pid_lock>
    800024c0:	00090513          	mv	a0,s2
    800024c4:	fffff097          	auipc	ra,0xfffff
    800024c8:	aa4080e7          	jalr	-1372(ra) # 80000f68 <acquire>
  pid = nextpid;
    800024cc:	00008797          	auipc	a5,0x8
    800024d0:	2f878793          	addi	a5,a5,760 # 8000a7c4 <nextpid>
    800024d4:	0007a483          	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800024d8:	0014871b          	addiw	a4,s1,1
    800024dc:	00e7a023          	sw	a4,0(a5)
  release(&pid_lock);
    800024e0:	00090513          	mv	a0,s2
    800024e4:	fffff097          	auipc	ra,0xfffff
    800024e8:	b7c080e7          	jalr	-1156(ra) # 80001060 <release>
}
    800024ec:	00048513          	mv	a0,s1
    800024f0:	01813083          	ld	ra,24(sp)
    800024f4:	01013403          	ld	s0,16(sp)
    800024f8:	00813483          	ld	s1,8(sp)
    800024fc:	00013903          	ld	s2,0(sp)
    80002500:	02010113          	addi	sp,sp,32
    80002504:	00008067          	ret

0000000080002508 <proc_pagetable>:
{
    80002508:	fe010113          	addi	sp,sp,-32
    8000250c:	00113c23          	sd	ra,24(sp)
    80002510:	00813823          	sd	s0,16(sp)
    80002514:	00913423          	sd	s1,8(sp)
    80002518:	01213023          	sd	s2,0(sp)
    8000251c:	02010413          	addi	s0,sp,32
    80002520:	00050913          	mv	s2,a0
  pagetable = uvmcreate();
    80002524:	fffff097          	auipc	ra,0xfffff
    80002528:	4b0080e7          	jalr	1200(ra) # 800019d4 <uvmcreate>
    8000252c:	00050493          	mv	s1,a0
  if(pagetable == 0)
    80002530:	04050a63          	beqz	a0,80002584 <proc_pagetable+0x7c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80002534:	00a00713          	li	a4,10
    80002538:	00007697          	auipc	a3,0x7
    8000253c:	ac868693          	addi	a3,a3,-1336 # 80009000 <_trampoline>
    80002540:	00001637          	lui	a2,0x1
    80002544:	040005b7          	lui	a1,0x4000
    80002548:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000254c:	00c59593          	slli	a1,a1,0xc
    80002550:	fffff097          	auipc	ra,0xfffff
    80002554:	0d0080e7          	jalr	208(ra) # 80001620 <mappages>
    80002558:	04054463          	bltz	a0,800025a0 <proc_pagetable+0x98>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000255c:	00600713          	li	a4,6
    80002560:	05893683          	ld	a3,88(s2)
    80002564:	00001637          	lui	a2,0x1
    80002568:	020005b7          	lui	a1,0x2000
    8000256c:	fff58593          	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002570:	00d59593          	slli	a1,a1,0xd
    80002574:	00048513          	mv	a0,s1
    80002578:	fffff097          	auipc	ra,0xfffff
    8000257c:	0a8080e7          	jalr	168(ra) # 80001620 <mappages>
    80002580:	02054c63          	bltz	a0,800025b8 <proc_pagetable+0xb0>
}
    80002584:	00048513          	mv	a0,s1
    80002588:	01813083          	ld	ra,24(sp)
    8000258c:	01013403          	ld	s0,16(sp)
    80002590:	00813483          	ld	s1,8(sp)
    80002594:	00013903          	ld	s2,0(sp)
    80002598:	02010113          	addi	sp,sp,32
    8000259c:	00008067          	ret
    uvmfree(pagetable, 0);
    800025a0:	00000593          	li	a1,0
    800025a4:	00048513          	mv	a0,s1
    800025a8:	fffff097          	auipc	ra,0xfffff
    800025ac:	758080e7          	jalr	1880(ra) # 80001d00 <uvmfree>
    return 0;
    800025b0:	00000493          	li	s1,0
    800025b4:	fd1ff06f          	j	80002584 <proc_pagetable+0x7c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800025b8:	00000693          	li	a3,0
    800025bc:	00100613          	li	a2,1
    800025c0:	040005b7          	lui	a1,0x4000
    800025c4:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800025c8:	00c59593          	slli	a1,a1,0xc
    800025cc:	00048513          	mv	a0,s1
    800025d0:	fffff097          	auipc	ra,0xfffff
    800025d4:	2f0080e7          	jalr	752(ra) # 800018c0 <uvmunmap>
    uvmfree(pagetable, 0);
    800025d8:	00000593          	li	a1,0
    800025dc:	00048513          	mv	a0,s1
    800025e0:	fffff097          	auipc	ra,0xfffff
    800025e4:	720080e7          	jalr	1824(ra) # 80001d00 <uvmfree>
    return 0;
    800025e8:	00000493          	li	s1,0
    800025ec:	f99ff06f          	j	80002584 <proc_pagetable+0x7c>

00000000800025f0 <proc_freepagetable>:
{
    800025f0:	fe010113          	addi	sp,sp,-32
    800025f4:	00113c23          	sd	ra,24(sp)
    800025f8:	00813823          	sd	s0,16(sp)
    800025fc:	00913423          	sd	s1,8(sp)
    80002600:	01213023          	sd	s2,0(sp)
    80002604:	02010413          	addi	s0,sp,32
    80002608:	00050493          	mv	s1,a0
    8000260c:	00058913          	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002610:	00000693          	li	a3,0
    80002614:	00100613          	li	a2,1
    80002618:	040005b7          	lui	a1,0x4000
    8000261c:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002620:	00c59593          	slli	a1,a1,0xc
    80002624:	fffff097          	auipc	ra,0xfffff
    80002628:	29c080e7          	jalr	668(ra) # 800018c0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000262c:	00000693          	li	a3,0
    80002630:	00100613          	li	a2,1
    80002634:	020005b7          	lui	a1,0x2000
    80002638:	fff58593          	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000263c:	00d59593          	slli	a1,a1,0xd
    80002640:	00048513          	mv	a0,s1
    80002644:	fffff097          	auipc	ra,0xfffff
    80002648:	27c080e7          	jalr	636(ra) # 800018c0 <uvmunmap>
  uvmfree(pagetable, sz);
    8000264c:	00090593          	mv	a1,s2
    80002650:	00048513          	mv	a0,s1
    80002654:	fffff097          	auipc	ra,0xfffff
    80002658:	6ac080e7          	jalr	1708(ra) # 80001d00 <uvmfree>
}
    8000265c:	01813083          	ld	ra,24(sp)
    80002660:	01013403          	ld	s0,16(sp)
    80002664:	00813483          	ld	s1,8(sp)
    80002668:	00013903          	ld	s2,0(sp)
    8000266c:	02010113          	addi	sp,sp,32
    80002670:	00008067          	ret

0000000080002674 <freeproc>:
{
    80002674:	fe010113          	addi	sp,sp,-32
    80002678:	00113c23          	sd	ra,24(sp)
    8000267c:	00813823          	sd	s0,16(sp)
    80002680:	00913423          	sd	s1,8(sp)
    80002684:	02010413          	addi	s0,sp,32
    80002688:	00050493          	mv	s1,a0
  if(p->trapframe)
    8000268c:	05853503          	ld	a0,88(a0)
    80002690:	00050663          	beqz	a0,8000269c <freeproc+0x28>
    kfree((void*)p->trapframe);
    80002694:	ffffe097          	auipc	ra,0xffffe
    80002698:	660080e7          	jalr	1632(ra) # 80000cf4 <kfree>
  p->trapframe = 0;
    8000269c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800026a0:	0504b503          	ld	a0,80(s1)
    800026a4:	00050863          	beqz	a0,800026b4 <freeproc+0x40>
    proc_freepagetable(p->pagetable, p->sz);
    800026a8:	0484b583          	ld	a1,72(s1)
    800026ac:	00000097          	auipc	ra,0x0
    800026b0:	f44080e7          	jalr	-188(ra) # 800025f0 <proc_freepagetable>
  p->pagetable = 0;
    800026b4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800026b8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800026bc:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800026c0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800026c4:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800026c8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800026cc:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800026d0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800026d4:	0004ac23          	sw	zero,24(s1)
}
    800026d8:	01813083          	ld	ra,24(sp)
    800026dc:	01013403          	ld	s0,16(sp)
    800026e0:	00813483          	ld	s1,8(sp)
    800026e4:	02010113          	addi	sp,sp,32
    800026e8:	00008067          	ret

00000000800026ec <allocproc>:
{
    800026ec:	fe010113          	addi	sp,sp,-32
    800026f0:	00113c23          	sd	ra,24(sp)
    800026f4:	00813823          	sd	s0,16(sp)
    800026f8:	00913423          	sd	s1,8(sp)
    800026fc:	01213023          	sd	s2,0(sp)
    80002700:	02010413          	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80002704:	00010497          	auipc	s1,0x10
    80002708:	7dc48493          	addi	s1,s1,2012 # 80012ee0 <proc>
    8000270c:	00016917          	auipc	s2,0x16
    80002710:	1d490913          	addi	s2,s2,468 # 800188e0 <tickslock>
    acquire(&p->lock);
    80002714:	00048513          	mv	a0,s1
    80002718:	fffff097          	auipc	ra,0xfffff
    8000271c:	850080e7          	jalr	-1968(ra) # 80000f68 <acquire>
    if(p->state == UNUSED) {
    80002720:	0184a783          	lw	a5,24(s1)
    80002724:	02078063          	beqz	a5,80002744 <allocproc+0x58>
      release(&p->lock);
    80002728:	00048513          	mv	a0,s1
    8000272c:	fffff097          	auipc	ra,0xfffff
    80002730:	934080e7          	jalr	-1740(ra) # 80001060 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002734:	16848493          	addi	s1,s1,360
    80002738:	fd249ee3          	bne	s1,s2,80002714 <allocproc+0x28>
  return 0;
    8000273c:	00000493          	li	s1,0
    80002740:	0740006f          	j	800027b4 <allocproc+0xc8>
  p->pid = allocpid();
    80002744:	00000097          	auipc	ra,0x0
    80002748:	d5c080e7          	jalr	-676(ra) # 800024a0 <allocpid>
    8000274c:	02a4a823          	sw	a0,48(s1)
  p->state = USED;
    80002750:	00100793          	li	a5,1
    80002754:	00f4ac23          	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80002758:	ffffe097          	auipc	ra,0xffffe
    8000275c:	6c8080e7          	jalr	1736(ra) # 80000e20 <kalloc>
    80002760:	00050913          	mv	s2,a0
    80002764:	04a4bc23          	sd	a0,88(s1)
    80002768:	06050463          	beqz	a0,800027d0 <allocproc+0xe4>
  p->pagetable = proc_pagetable(p);
    8000276c:	00048513          	mv	a0,s1
    80002770:	00000097          	auipc	ra,0x0
    80002774:	d98080e7          	jalr	-616(ra) # 80002508 <proc_pagetable>
    80002778:	00050913          	mv	s2,a0
    8000277c:	04a4b823          	sd	a0,80(s1)
  if(p->pagetable == 0){
    80002780:	06050863          	beqz	a0,800027f0 <allocproc+0x104>
  memset(&p->context, 0, sizeof(p->context));
    80002784:	07000613          	li	a2,112
    80002788:	00000593          	li	a1,0
    8000278c:	06048513          	addi	a0,s1,96
    80002790:	fffff097          	auipc	ra,0xfffff
    80002794:	930080e7          	jalr	-1744(ra) # 800010c0 <memset>
  p->context.ra = (uint64)forkret;
    80002798:	00000797          	auipc	a5,0x0
    8000279c:	cac78793          	addi	a5,a5,-852 # 80002444 <forkret>
    800027a0:	06f4b023          	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800027a4:	0404b783          	ld	a5,64(s1)
    800027a8:	00001737          	lui	a4,0x1
    800027ac:	00e787b3          	add	a5,a5,a4
    800027b0:	06f4b423          	sd	a5,104(s1)
}
    800027b4:	00048513          	mv	a0,s1
    800027b8:	01813083          	ld	ra,24(sp)
    800027bc:	01013403          	ld	s0,16(sp)
    800027c0:	00813483          	ld	s1,8(sp)
    800027c4:	00013903          	ld	s2,0(sp)
    800027c8:	02010113          	addi	sp,sp,32
    800027cc:	00008067          	ret
    freeproc(p);
    800027d0:	00048513          	mv	a0,s1
    800027d4:	00000097          	auipc	ra,0x0
    800027d8:	ea0080e7          	jalr	-352(ra) # 80002674 <freeproc>
    release(&p->lock);
    800027dc:	00048513          	mv	a0,s1
    800027e0:	fffff097          	auipc	ra,0xfffff
    800027e4:	880080e7          	jalr	-1920(ra) # 80001060 <release>
    return 0;
    800027e8:	00090493          	mv	s1,s2
    800027ec:	fc9ff06f          	j	800027b4 <allocproc+0xc8>
    freeproc(p);
    800027f0:	00048513          	mv	a0,s1
    800027f4:	00000097          	auipc	ra,0x0
    800027f8:	e80080e7          	jalr	-384(ra) # 80002674 <freeproc>
    release(&p->lock);
    800027fc:	00048513          	mv	a0,s1
    80002800:	fffff097          	auipc	ra,0xfffff
    80002804:	860080e7          	jalr	-1952(ra) # 80001060 <release>
    return 0;
    80002808:	00090493          	mv	s1,s2
    8000280c:	fa9ff06f          	j	800027b4 <allocproc+0xc8>

0000000080002810 <userinit>:
{
    80002810:	fe010113          	addi	sp,sp,-32
    80002814:	00113c23          	sd	ra,24(sp)
    80002818:	00813823          	sd	s0,16(sp)
    8000281c:	00913423          	sd	s1,8(sp)
    80002820:	02010413          	addi	s0,sp,32
  p = allocproc();
    80002824:	00000097          	auipc	ra,0x0
    80002828:	ec8080e7          	jalr	-312(ra) # 800026ec <allocproc>
    8000282c:	00050493          	mv	s1,a0
  initproc = p;
    80002830:	00008797          	auipc	a5,0x8
    80002834:	00a7b423          	sd	a0,8(a5) # 8000a838 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80002838:	03400613          	li	a2,52
    8000283c:	00008597          	auipc	a1,0x8
    80002840:	f9458593          	addi	a1,a1,-108 # 8000a7d0 <initcode>
    80002844:	05053503          	ld	a0,80(a0)
    80002848:	fffff097          	auipc	ra,0xfffff
    8000284c:	1d8080e7          	jalr	472(ra) # 80001a20 <uvminit>
  p->sz = PGSIZE;
    80002850:	000017b7          	lui	a5,0x1
    80002854:	04f4b423          	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80002858:	0584b703          	ld	a4,88(s1)
    8000285c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80002860:	0584b703          	ld	a4,88(s1)
    80002864:	02f73823          	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002868:	01000613          	li	a2,16
    8000286c:	00008597          	auipc	a1,0x8
    80002870:	98c58593          	addi	a1,a1,-1652 # 8000a1f8 <digits+0x1b8>
    80002874:	15848513          	addi	a0,s1,344
    80002878:	fffff097          	auipc	ra,0xfffff
    8000287c:	a48080e7          	jalr	-1464(ra) # 800012c0 <safestrcpy>
  p->cwd = namei("/");
    80002880:	00008517          	auipc	a0,0x8
    80002884:	98850513          	addi	a0,a0,-1656 # 8000a208 <digits+0x1c8>
    80002888:	00003097          	auipc	ra,0x3
    8000288c:	d68080e7          	jalr	-664(ra) # 800055f0 <namei>
    80002890:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80002894:	00300793          	li	a5,3
    80002898:	00f4ac23          	sw	a5,24(s1)
  release(&p->lock);
    8000289c:	00048513          	mv	a0,s1
    800028a0:	ffffe097          	auipc	ra,0xffffe
    800028a4:	7c0080e7          	jalr	1984(ra) # 80001060 <release>
}
    800028a8:	01813083          	ld	ra,24(sp)
    800028ac:	01013403          	ld	s0,16(sp)
    800028b0:	00813483          	ld	s1,8(sp)
    800028b4:	02010113          	addi	sp,sp,32
    800028b8:	00008067          	ret

00000000800028bc <growproc>:
{
    800028bc:	fe010113          	addi	sp,sp,-32
    800028c0:	00113c23          	sd	ra,24(sp)
    800028c4:	00813823          	sd	s0,16(sp)
    800028c8:	00913423          	sd	s1,8(sp)
    800028cc:	01213023          	sd	s2,0(sp)
    800028d0:	02010413          	addi	s0,sp,32
    800028d4:	00050493          	mv	s1,a0
  struct proc *p = myproc();
    800028d8:	00000097          	auipc	ra,0x0
    800028dc:	b14080e7          	jalr	-1260(ra) # 800023ec <myproc>
    800028e0:	00050913          	mv	s2,a0
  sz = p->sz;
    800028e4:	04853583          	ld	a1,72(a0)
    800028e8:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800028ec:	02904863          	bgtz	s1,8000291c <growproc+0x60>
  } else if(n < 0){
    800028f0:	0404ce63          	bltz	s1,8000294c <growproc+0x90>
  p->sz = sz;
    800028f4:	02061613          	slli	a2,a2,0x20
    800028f8:	02065613          	srli	a2,a2,0x20
    800028fc:	04c93423          	sd	a2,72(s2)
  return 0;
    80002900:	00000513          	li	a0,0
}
    80002904:	01813083          	ld	ra,24(sp)
    80002908:	01013403          	ld	s0,16(sp)
    8000290c:	00813483          	ld	s1,8(sp)
    80002910:	00013903          	ld	s2,0(sp)
    80002914:	02010113          	addi	sp,sp,32
    80002918:	00008067          	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000291c:	00c4863b          	addw	a2,s1,a2
    80002920:	02061613          	slli	a2,a2,0x20
    80002924:	02065613          	srli	a2,a2,0x20
    80002928:	02059593          	slli	a1,a1,0x20
    8000292c:	0205d593          	srli	a1,a1,0x20
    80002930:	05053503          	ld	a0,80(a0)
    80002934:	fffff097          	auipc	ra,0xfffff
    80002938:	214080e7          	jalr	532(ra) # 80001b48 <uvmalloc>
    8000293c:	0005061b          	sext.w	a2,a0
    80002940:	fa061ae3          	bnez	a2,800028f4 <growproc+0x38>
      return -1;
    80002944:	fff00513          	li	a0,-1
    80002948:	fbdff06f          	j	80002904 <growproc+0x48>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000294c:	00c4863b          	addw	a2,s1,a2
    80002950:	02061613          	slli	a2,a2,0x20
    80002954:	02065613          	srli	a2,a2,0x20
    80002958:	02059593          	slli	a1,a1,0x20
    8000295c:	0205d593          	srli	a1,a1,0x20
    80002960:	05053503          	ld	a0,80(a0)
    80002964:	fffff097          	auipc	ra,0xfffff
    80002968:	16c080e7          	jalr	364(ra) # 80001ad0 <uvmdealloc>
    8000296c:	0005061b          	sext.w	a2,a0
    80002970:	f85ff06f          	j	800028f4 <growproc+0x38>

0000000080002974 <fork>:
{
    80002974:	fc010113          	addi	sp,sp,-64
    80002978:	02113c23          	sd	ra,56(sp)
    8000297c:	02813823          	sd	s0,48(sp)
    80002980:	02913423          	sd	s1,40(sp)
    80002984:	03213023          	sd	s2,32(sp)
    80002988:	01313c23          	sd	s3,24(sp)
    8000298c:	01413823          	sd	s4,16(sp)
    80002990:	01513423          	sd	s5,8(sp)
    80002994:	04010413          	addi	s0,sp,64
  struct proc *p = myproc();
    80002998:	00000097          	auipc	ra,0x0
    8000299c:	a54080e7          	jalr	-1452(ra) # 800023ec <myproc>
    800029a0:	00050a93          	mv	s5,a0
  if((np = allocproc()) == 0){
    800029a4:	00000097          	auipc	ra,0x0
    800029a8:	d48080e7          	jalr	-696(ra) # 800026ec <allocproc>
    800029ac:	16050063          	beqz	a0,80002b0c <fork+0x198>
    800029b0:	00050a13          	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800029b4:	048ab603          	ld	a2,72(s5)
    800029b8:	05053583          	ld	a1,80(a0)
    800029bc:	050ab503          	ld	a0,80(s5)
    800029c0:	fffff097          	auipc	ra,0xfffff
    800029c4:	3a0080e7          	jalr	928(ra) # 80001d60 <uvmcopy>
    800029c8:	06054063          	bltz	a0,80002a28 <fork+0xb4>
  np->sz = p->sz;
    800029cc:	048ab783          	ld	a5,72(s5)
    800029d0:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800029d4:	058ab683          	ld	a3,88(s5)
    800029d8:	00068793          	mv	a5,a3
    800029dc:	058a3703          	ld	a4,88(s4)
    800029e0:	12068693          	addi	a3,a3,288
    800029e4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800029e8:	0087b503          	ld	a0,8(a5)
    800029ec:	0107b583          	ld	a1,16(a5)
    800029f0:	0187b603          	ld	a2,24(a5)
    800029f4:	01073023          	sd	a6,0(a4)
    800029f8:	00a73423          	sd	a0,8(a4)
    800029fc:	00b73823          	sd	a1,16(a4)
    80002a00:	00c73c23          	sd	a2,24(a4)
    80002a04:	02078793          	addi	a5,a5,32
    80002a08:	02070713          	addi	a4,a4,32
    80002a0c:	fcd79ce3          	bne	a5,a3,800029e4 <fork+0x70>
  np->trapframe->a0 = 0;
    80002a10:	058a3783          	ld	a5,88(s4)
    80002a14:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002a18:	0d0a8493          	addi	s1,s5,208
    80002a1c:	0d0a0913          	addi	s2,s4,208
    80002a20:	150a8993          	addi	s3,s5,336
    80002a24:	0300006f          	j	80002a54 <fork+0xe0>
    freeproc(np);
    80002a28:	000a0513          	mv	a0,s4
    80002a2c:	00000097          	auipc	ra,0x0
    80002a30:	c48080e7          	jalr	-952(ra) # 80002674 <freeproc>
    release(&np->lock);
    80002a34:	000a0513          	mv	a0,s4
    80002a38:	ffffe097          	auipc	ra,0xffffe
    80002a3c:	628080e7          	jalr	1576(ra) # 80001060 <release>
    return -1;
    80002a40:	fff00913          	li	s2,-1
    80002a44:	0a00006f          	j	80002ae4 <fork+0x170>
  for(i = 0; i < NOFILE; i++)
    80002a48:	00848493          	addi	s1,s1,8
    80002a4c:	00890913          	addi	s2,s2,8
    80002a50:	01348e63          	beq	s1,s3,80002a6c <fork+0xf8>
    if(p->ofile[i])
    80002a54:	0004b503          	ld	a0,0(s1)
    80002a58:	fe0508e3          	beqz	a0,80002a48 <fork+0xd4>
      np->ofile[i] = filedup(p->ofile[i]);
    80002a5c:	00003097          	auipc	ra,0x3
    80002a60:	4a0080e7          	jalr	1184(ra) # 80005efc <filedup>
    80002a64:	00a93023          	sd	a0,0(s2)
    80002a68:	fe1ff06f          	j	80002a48 <fork+0xd4>
  np->cwd = idup(p->cwd);
    80002a6c:	150ab503          	ld	a0,336(s5)
    80002a70:	00002097          	auipc	ra,0x2
    80002a74:	02c080e7          	jalr	44(ra) # 80004a9c <idup>
    80002a78:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002a7c:	01000613          	li	a2,16
    80002a80:	158a8593          	addi	a1,s5,344
    80002a84:	158a0513          	addi	a0,s4,344
    80002a88:	fffff097          	auipc	ra,0xfffff
    80002a8c:	838080e7          	jalr	-1992(ra) # 800012c0 <safestrcpy>
  pid = np->pid;
    80002a90:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80002a94:	000a0513          	mv	a0,s4
    80002a98:	ffffe097          	auipc	ra,0xffffe
    80002a9c:	5c8080e7          	jalr	1480(ra) # 80001060 <release>
  acquire(&wait_lock);
    80002aa0:	00010497          	auipc	s1,0x10
    80002aa4:	02848493          	addi	s1,s1,40 # 80012ac8 <wait_lock>
    80002aa8:	00048513          	mv	a0,s1
    80002aac:	ffffe097          	auipc	ra,0xffffe
    80002ab0:	4bc080e7          	jalr	1212(ra) # 80000f68 <acquire>
  np->parent = p;
    80002ab4:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80002ab8:	00048513          	mv	a0,s1
    80002abc:	ffffe097          	auipc	ra,0xffffe
    80002ac0:	5a4080e7          	jalr	1444(ra) # 80001060 <release>
  acquire(&np->lock);
    80002ac4:	000a0513          	mv	a0,s4
    80002ac8:	ffffe097          	auipc	ra,0xffffe
    80002acc:	4a0080e7          	jalr	1184(ra) # 80000f68 <acquire>
  np->state = RUNNABLE;
    80002ad0:	00300793          	li	a5,3
    80002ad4:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80002ad8:	000a0513          	mv	a0,s4
    80002adc:	ffffe097          	auipc	ra,0xffffe
    80002ae0:	584080e7          	jalr	1412(ra) # 80001060 <release>
}
    80002ae4:	00090513          	mv	a0,s2
    80002ae8:	03813083          	ld	ra,56(sp)
    80002aec:	03013403          	ld	s0,48(sp)
    80002af0:	02813483          	ld	s1,40(sp)
    80002af4:	02013903          	ld	s2,32(sp)
    80002af8:	01813983          	ld	s3,24(sp)
    80002afc:	01013a03          	ld	s4,16(sp)
    80002b00:	00813a83          	ld	s5,8(sp)
    80002b04:	04010113          	addi	sp,sp,64
    80002b08:	00008067          	ret
    return -1;
    80002b0c:	fff00913          	li	s2,-1
    80002b10:	fd5ff06f          	j	80002ae4 <fork+0x170>

0000000080002b14 <scheduler>:
{
    80002b14:	fc010113          	addi	sp,sp,-64
    80002b18:	02113c23          	sd	ra,56(sp)
    80002b1c:	02813823          	sd	s0,48(sp)
    80002b20:	02913423          	sd	s1,40(sp)
    80002b24:	03213023          	sd	s2,32(sp)
    80002b28:	01313c23          	sd	s3,24(sp)
    80002b2c:	01413823          	sd	s4,16(sp)
    80002b30:	01513423          	sd	s5,8(sp)
    80002b34:	01613023          	sd	s6,0(sp)
    80002b38:	04010413          	addi	s0,sp,64
    80002b3c:	00020793          	mv	a5,tp
  int id = r_tp();
    80002b40:	0007879b          	sext.w	a5,a5
  c->proc = 0;
    80002b44:	00779a93          	slli	s5,a5,0x7
    80002b48:	00010717          	auipc	a4,0x10
    80002b4c:	f6870713          	addi	a4,a4,-152 # 80012ab0 <pid_lock>
    80002b50:	01570733          	add	a4,a4,s5
    80002b54:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002b58:	00010717          	auipc	a4,0x10
    80002b5c:	f9070713          	addi	a4,a4,-112 # 80012ae8 <cpus+0x8>
    80002b60:	00ea8ab3          	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80002b64:	00300993          	li	s3,3
        p->state = RUNNING;
    80002b68:	00400b13          	li	s6,4
        c->proc = p;
    80002b6c:	00779793          	slli	a5,a5,0x7
    80002b70:	00010a17          	auipc	s4,0x10
    80002b74:	f40a0a13          	addi	s4,s4,-192 # 80012ab0 <pid_lock>
    80002b78:	00fa0a33          	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002b7c:	00016917          	auipc	s2,0x16
    80002b80:	d6490913          	addi	s2,s2,-668 # 800188e0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002b88:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b8c:	10079073          	csrw	sstatus,a5
    80002b90:	00010497          	auipc	s1,0x10
    80002b94:	35048493          	addi	s1,s1,848 # 80012ee0 <proc>
    80002b98:	0180006f          	j	80002bb0 <scheduler+0x9c>
      release(&p->lock);
    80002b9c:	00048513          	mv	a0,s1
    80002ba0:	ffffe097          	auipc	ra,0xffffe
    80002ba4:	4c0080e7          	jalr	1216(ra) # 80001060 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002ba8:	16848493          	addi	s1,s1,360
    80002bac:	fd248ce3          	beq	s1,s2,80002b84 <scheduler+0x70>
      acquire(&p->lock);
    80002bb0:	00048513          	mv	a0,s1
    80002bb4:	ffffe097          	auipc	ra,0xffffe
    80002bb8:	3b4080e7          	jalr	948(ra) # 80000f68 <acquire>
      if(p->state == RUNNABLE) {
    80002bbc:	0184a783          	lw	a5,24(s1)
    80002bc0:	fd379ee3          	bne	a5,s3,80002b9c <scheduler+0x88>
        p->state = RUNNING;
    80002bc4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002bc8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80002bcc:	06048593          	addi	a1,s1,96
    80002bd0:	000a8513          	mv	a0,s5
    80002bd4:	00001097          	auipc	ra,0x1
    80002bd8:	894080e7          	jalr	-1900(ra) # 80003468 <swtch>
        c->proc = 0;
    80002bdc:	020a3823          	sd	zero,48(s4)
    80002be0:	fbdff06f          	j	80002b9c <scheduler+0x88>

0000000080002be4 <sched>:
{
    80002be4:	fd010113          	addi	sp,sp,-48
    80002be8:	02113423          	sd	ra,40(sp)
    80002bec:	02813023          	sd	s0,32(sp)
    80002bf0:	00913c23          	sd	s1,24(sp)
    80002bf4:	01213823          	sd	s2,16(sp)
    80002bf8:	01313423          	sd	s3,8(sp)
    80002bfc:	03010413          	addi	s0,sp,48
  struct proc *p = myproc();
    80002c00:	fffff097          	auipc	ra,0xfffff
    80002c04:	7ec080e7          	jalr	2028(ra) # 800023ec <myproc>
    80002c08:	00050493          	mv	s1,a0
  if(!holding(&p->lock))
    80002c0c:	ffffe097          	auipc	ra,0xffffe
    80002c10:	29c080e7          	jalr	668(ra) # 80000ea8 <holding>
    80002c14:	0a050863          	beqz	a0,80002cc4 <sched+0xe0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c18:	00020793          	mv	a5,tp
  if(mycpu()->noff != 1)
    80002c1c:	0007879b          	sext.w	a5,a5
    80002c20:	00779793          	slli	a5,a5,0x7
    80002c24:	00010717          	auipc	a4,0x10
    80002c28:	e8c70713          	addi	a4,a4,-372 # 80012ab0 <pid_lock>
    80002c2c:	00f707b3          	add	a5,a4,a5
    80002c30:	0a87a703          	lw	a4,168(a5)
    80002c34:	00100793          	li	a5,1
    80002c38:	08f71e63          	bne	a4,a5,80002cd4 <sched+0xf0>
  if(p->state == RUNNING)
    80002c3c:	0184a703          	lw	a4,24(s1)
    80002c40:	00400793          	li	a5,4
    80002c44:	0af70063          	beq	a4,a5,80002ce4 <sched+0x100>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c48:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002c4c:	0027f793          	andi	a5,a5,2
  if(intr_get())
    80002c50:	0a079263          	bnez	a5,80002cf4 <sched+0x110>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c54:	00020793          	mv	a5,tp
  intena = mycpu()->intena;
    80002c58:	00010917          	auipc	s2,0x10
    80002c5c:	e5890913          	addi	s2,s2,-424 # 80012ab0 <pid_lock>
    80002c60:	0007879b          	sext.w	a5,a5
    80002c64:	00779793          	slli	a5,a5,0x7
    80002c68:	00f907b3          	add	a5,s2,a5
    80002c6c:	0ac7a983          	lw	s3,172(a5)
    80002c70:	00020793          	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002c74:	0007879b          	sext.w	a5,a5
    80002c78:	00779793          	slli	a5,a5,0x7
    80002c7c:	00010597          	auipc	a1,0x10
    80002c80:	e6c58593          	addi	a1,a1,-404 # 80012ae8 <cpus+0x8>
    80002c84:	00b785b3          	add	a1,a5,a1
    80002c88:	06048513          	addi	a0,s1,96
    80002c8c:	00000097          	auipc	ra,0x0
    80002c90:	7dc080e7          	jalr	2012(ra) # 80003468 <swtch>
    80002c94:	00020793          	mv	a5,tp
  mycpu()->intena = intena;
    80002c98:	0007879b          	sext.w	a5,a5
    80002c9c:	00779793          	slli	a5,a5,0x7
    80002ca0:	00f907b3          	add	a5,s2,a5
    80002ca4:	0b37a623          	sw	s3,172(a5)
}
    80002ca8:	02813083          	ld	ra,40(sp)
    80002cac:	02013403          	ld	s0,32(sp)
    80002cb0:	01813483          	ld	s1,24(sp)
    80002cb4:	01013903          	ld	s2,16(sp)
    80002cb8:	00813983          	ld	s3,8(sp)
    80002cbc:	03010113          	addi	sp,sp,48
    80002cc0:	00008067          	ret
    panic("sched p->lock");
    80002cc4:	00007517          	auipc	a0,0x7
    80002cc8:	54c50513          	addi	a0,a0,1356 # 8000a210 <digits+0x1d0>
    80002ccc:	ffffe097          	auipc	ra,0xffffe
    80002cd0:	a00080e7          	jalr	-1536(ra) # 800006cc <panic>
    panic("sched locks");
    80002cd4:	00007517          	auipc	a0,0x7
    80002cd8:	54c50513          	addi	a0,a0,1356 # 8000a220 <digits+0x1e0>
    80002cdc:	ffffe097          	auipc	ra,0xffffe
    80002ce0:	9f0080e7          	jalr	-1552(ra) # 800006cc <panic>
    panic("sched running");
    80002ce4:	00007517          	auipc	a0,0x7
    80002ce8:	54c50513          	addi	a0,a0,1356 # 8000a230 <digits+0x1f0>
    80002cec:	ffffe097          	auipc	ra,0xffffe
    80002cf0:	9e0080e7          	jalr	-1568(ra) # 800006cc <panic>
    panic("sched interruptible");
    80002cf4:	00007517          	auipc	a0,0x7
    80002cf8:	54c50513          	addi	a0,a0,1356 # 8000a240 <digits+0x200>
    80002cfc:	ffffe097          	auipc	ra,0xffffe
    80002d00:	9d0080e7          	jalr	-1584(ra) # 800006cc <panic>

0000000080002d04 <yield>:
{
    80002d04:	fe010113          	addi	sp,sp,-32
    80002d08:	00113c23          	sd	ra,24(sp)
    80002d0c:	00813823          	sd	s0,16(sp)
    80002d10:	00913423          	sd	s1,8(sp)
    80002d14:	02010413          	addi	s0,sp,32
  struct proc *p = myproc();
    80002d18:	fffff097          	auipc	ra,0xfffff
    80002d1c:	6d4080e7          	jalr	1748(ra) # 800023ec <myproc>
    80002d20:	00050493          	mv	s1,a0
  acquire(&p->lock);
    80002d24:	ffffe097          	auipc	ra,0xffffe
    80002d28:	244080e7          	jalr	580(ra) # 80000f68 <acquire>
  p->state = RUNNABLE;
    80002d2c:	00300793          	li	a5,3
    80002d30:	00f4ac23          	sw	a5,24(s1)
  sched();
    80002d34:	00000097          	auipc	ra,0x0
    80002d38:	eb0080e7          	jalr	-336(ra) # 80002be4 <sched>
  release(&p->lock);
    80002d3c:	00048513          	mv	a0,s1
    80002d40:	ffffe097          	auipc	ra,0xffffe
    80002d44:	320080e7          	jalr	800(ra) # 80001060 <release>
}
    80002d48:	01813083          	ld	ra,24(sp)
    80002d4c:	01013403          	ld	s0,16(sp)
    80002d50:	00813483          	ld	s1,8(sp)
    80002d54:	02010113          	addi	sp,sp,32
    80002d58:	00008067          	ret

0000000080002d5c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002d5c:	fd010113          	addi	sp,sp,-48
    80002d60:	02113423          	sd	ra,40(sp)
    80002d64:	02813023          	sd	s0,32(sp)
    80002d68:	00913c23          	sd	s1,24(sp)
    80002d6c:	01213823          	sd	s2,16(sp)
    80002d70:	01313423          	sd	s3,8(sp)
    80002d74:	03010413          	addi	s0,sp,48
    80002d78:	00050993          	mv	s3,a0
    80002d7c:	00058913          	mv	s2,a1
  struct proc *p = myproc();
    80002d80:	fffff097          	auipc	ra,0xfffff
    80002d84:	66c080e7          	jalr	1644(ra) # 800023ec <myproc>
    80002d88:	00050493          	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002d8c:	ffffe097          	auipc	ra,0xffffe
    80002d90:	1dc080e7          	jalr	476(ra) # 80000f68 <acquire>
  release(lk);
    80002d94:	00090513          	mv	a0,s2
    80002d98:	ffffe097          	auipc	ra,0xffffe
    80002d9c:	2c8080e7          	jalr	712(ra) # 80001060 <release>

  // Go to sleep.
  p->chan = chan;
    80002da0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002da4:	00200793          	li	a5,2
    80002da8:	00f4ac23          	sw	a5,24(s1)

  sched();
    80002dac:	00000097          	auipc	ra,0x0
    80002db0:	e38080e7          	jalr	-456(ra) # 80002be4 <sched>

  // Tidy up.
  p->chan = 0;
    80002db4:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002db8:	00048513          	mv	a0,s1
    80002dbc:	ffffe097          	auipc	ra,0xffffe
    80002dc0:	2a4080e7          	jalr	676(ra) # 80001060 <release>
  acquire(lk);
    80002dc4:	00090513          	mv	a0,s2
    80002dc8:	ffffe097          	auipc	ra,0xffffe
    80002dcc:	1a0080e7          	jalr	416(ra) # 80000f68 <acquire>
}
    80002dd0:	02813083          	ld	ra,40(sp)
    80002dd4:	02013403          	ld	s0,32(sp)
    80002dd8:	01813483          	ld	s1,24(sp)
    80002ddc:	01013903          	ld	s2,16(sp)
    80002de0:	00813983          	ld	s3,8(sp)
    80002de4:	03010113          	addi	sp,sp,48
    80002de8:	00008067          	ret

0000000080002dec <wait>:
{
    80002dec:	fb010113          	addi	sp,sp,-80
    80002df0:	04113423          	sd	ra,72(sp)
    80002df4:	04813023          	sd	s0,64(sp)
    80002df8:	02913c23          	sd	s1,56(sp)
    80002dfc:	03213823          	sd	s2,48(sp)
    80002e00:	03313423          	sd	s3,40(sp)
    80002e04:	03413023          	sd	s4,32(sp)
    80002e08:	01513c23          	sd	s5,24(sp)
    80002e0c:	01613823          	sd	s6,16(sp)
    80002e10:	01713423          	sd	s7,8(sp)
    80002e14:	01813023          	sd	s8,0(sp)
    80002e18:	05010413          	addi	s0,sp,80
    80002e1c:	00050b13          	mv	s6,a0
  struct proc *p = myproc();
    80002e20:	fffff097          	auipc	ra,0xfffff
    80002e24:	5cc080e7          	jalr	1484(ra) # 800023ec <myproc>
    80002e28:	00050913          	mv	s2,a0
  acquire(&wait_lock);
    80002e2c:	00010517          	auipc	a0,0x10
    80002e30:	c9c50513          	addi	a0,a0,-868 # 80012ac8 <wait_lock>
    80002e34:	ffffe097          	auipc	ra,0xffffe
    80002e38:	134080e7          	jalr	308(ra) # 80000f68 <acquire>
    havekids = 0;
    80002e3c:	00000b93          	li	s7,0
        if(np->state == ZOMBIE){
    80002e40:	00500a13          	li	s4,5
        havekids = 1;
    80002e44:	00100a93          	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002e48:	00016997          	auipc	s3,0x16
    80002e4c:	a9898993          	addi	s3,s3,-1384 # 800188e0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002e50:	00010c17          	auipc	s8,0x10
    80002e54:	c78c0c13          	addi	s8,s8,-904 # 80012ac8 <wait_lock>
    havekids = 0;
    80002e58:	000b8713          	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002e5c:	00010497          	auipc	s1,0x10
    80002e60:	08448493          	addi	s1,s1,132 # 80012ee0 <proc>
    80002e64:	0800006f          	j	80002ee4 <wait+0xf8>
          pid = np->pid;
    80002e68:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002e6c:	020b0063          	beqz	s6,80002e8c <wait+0xa0>
    80002e70:	00400693          	li	a3,4
    80002e74:	02c48613          	addi	a2,s1,44
    80002e78:	000b0593          	mv	a1,s6
    80002e7c:	05093503          	ld	a0,80(s2)
    80002e80:	fffff097          	auipc	ra,0xfffff
    80002e84:	074080e7          	jalr	116(ra) # 80001ef4 <copyout>
    80002e88:	02054863          	bltz	a0,80002eb8 <wait+0xcc>
          freeproc(np);
    80002e8c:	00048513          	mv	a0,s1
    80002e90:	fffff097          	auipc	ra,0xfffff
    80002e94:	7e4080e7          	jalr	2020(ra) # 80002674 <freeproc>
          release(&np->lock);
    80002e98:	00048513          	mv	a0,s1
    80002e9c:	ffffe097          	auipc	ra,0xffffe
    80002ea0:	1c4080e7          	jalr	452(ra) # 80001060 <release>
          release(&wait_lock);
    80002ea4:	00010517          	auipc	a0,0x10
    80002ea8:	c2450513          	addi	a0,a0,-988 # 80012ac8 <wait_lock>
    80002eac:	ffffe097          	auipc	ra,0xffffe
    80002eb0:	1b4080e7          	jalr	436(ra) # 80001060 <release>
          return pid;
    80002eb4:	0800006f          	j	80002f34 <wait+0x148>
            release(&np->lock);
    80002eb8:	00048513          	mv	a0,s1
    80002ebc:	ffffe097          	auipc	ra,0xffffe
    80002ec0:	1a4080e7          	jalr	420(ra) # 80001060 <release>
            release(&wait_lock);
    80002ec4:	00010517          	auipc	a0,0x10
    80002ec8:	c0450513          	addi	a0,a0,-1020 # 80012ac8 <wait_lock>
    80002ecc:	ffffe097          	auipc	ra,0xffffe
    80002ed0:	194080e7          	jalr	404(ra) # 80001060 <release>
            return -1;
    80002ed4:	fff00993          	li	s3,-1
    80002ed8:	05c0006f          	j	80002f34 <wait+0x148>
    for(np = proc; np < &proc[NPROC]; np++){
    80002edc:	16848493          	addi	s1,s1,360
    80002ee0:	03348a63          	beq	s1,s3,80002f14 <wait+0x128>
      if(np->parent == p){
    80002ee4:	0384b783          	ld	a5,56(s1)
    80002ee8:	ff279ae3          	bne	a5,s2,80002edc <wait+0xf0>
        acquire(&np->lock);
    80002eec:	00048513          	mv	a0,s1
    80002ef0:	ffffe097          	auipc	ra,0xffffe
    80002ef4:	078080e7          	jalr	120(ra) # 80000f68 <acquire>
        if(np->state == ZOMBIE){
    80002ef8:	0184a783          	lw	a5,24(s1)
    80002efc:	f74786e3          	beq	a5,s4,80002e68 <wait+0x7c>
        release(&np->lock);
    80002f00:	00048513          	mv	a0,s1
    80002f04:	ffffe097          	auipc	ra,0xffffe
    80002f08:	15c080e7          	jalr	348(ra) # 80001060 <release>
        havekids = 1;
    80002f0c:	000a8713          	mv	a4,s5
    80002f10:	fcdff06f          	j	80002edc <wait+0xf0>
    if(!havekids || p->killed){
    80002f14:	00070663          	beqz	a4,80002f20 <wait+0x134>
    80002f18:	02892783          	lw	a5,40(s2)
    80002f1c:	04078663          	beqz	a5,80002f68 <wait+0x17c>
      release(&wait_lock);
    80002f20:	00010517          	auipc	a0,0x10
    80002f24:	ba850513          	addi	a0,a0,-1112 # 80012ac8 <wait_lock>
    80002f28:	ffffe097          	auipc	ra,0xffffe
    80002f2c:	138080e7          	jalr	312(ra) # 80001060 <release>
      return -1;
    80002f30:	fff00993          	li	s3,-1
}
    80002f34:	00098513          	mv	a0,s3
    80002f38:	04813083          	ld	ra,72(sp)
    80002f3c:	04013403          	ld	s0,64(sp)
    80002f40:	03813483          	ld	s1,56(sp)
    80002f44:	03013903          	ld	s2,48(sp)
    80002f48:	02813983          	ld	s3,40(sp)
    80002f4c:	02013a03          	ld	s4,32(sp)
    80002f50:	01813a83          	ld	s5,24(sp)
    80002f54:	01013b03          	ld	s6,16(sp)
    80002f58:	00813b83          	ld	s7,8(sp)
    80002f5c:	00013c03          	ld	s8,0(sp)
    80002f60:	05010113          	addi	sp,sp,80
    80002f64:	00008067          	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002f68:	000c0593          	mv	a1,s8
    80002f6c:	00090513          	mv	a0,s2
    80002f70:	00000097          	auipc	ra,0x0
    80002f74:	dec080e7          	jalr	-532(ra) # 80002d5c <sleep>
    havekids = 0;
    80002f78:	ee1ff06f          	j	80002e58 <wait+0x6c>

0000000080002f7c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002f7c:	fc010113          	addi	sp,sp,-64
    80002f80:	02113c23          	sd	ra,56(sp)
    80002f84:	02813823          	sd	s0,48(sp)
    80002f88:	02913423          	sd	s1,40(sp)
    80002f8c:	03213023          	sd	s2,32(sp)
    80002f90:	01313c23          	sd	s3,24(sp)
    80002f94:	01413823          	sd	s4,16(sp)
    80002f98:	01513423          	sd	s5,8(sp)
    80002f9c:	04010413          	addi	s0,sp,64
    80002fa0:	00050a13          	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002fa4:	00010497          	auipc	s1,0x10
    80002fa8:	f3c48493          	addi	s1,s1,-196 # 80012ee0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002fac:	00200993          	li	s3,2
        p->state = RUNNABLE;
    80002fb0:	00300a93          	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002fb4:	00016917          	auipc	s2,0x16
    80002fb8:	92c90913          	addi	s2,s2,-1748 # 800188e0 <tickslock>
    80002fbc:	0180006f          	j	80002fd4 <wakeup+0x58>
      }
      release(&p->lock);
    80002fc0:	00048513          	mv	a0,s1
    80002fc4:	ffffe097          	auipc	ra,0xffffe
    80002fc8:	09c080e7          	jalr	156(ra) # 80001060 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002fcc:	16848493          	addi	s1,s1,360
    80002fd0:	03248a63          	beq	s1,s2,80003004 <wakeup+0x88>
    if(p != myproc()){
    80002fd4:	fffff097          	auipc	ra,0xfffff
    80002fd8:	418080e7          	jalr	1048(ra) # 800023ec <myproc>
    80002fdc:	fea488e3          	beq	s1,a0,80002fcc <wakeup+0x50>
      acquire(&p->lock);
    80002fe0:	00048513          	mv	a0,s1
    80002fe4:	ffffe097          	auipc	ra,0xffffe
    80002fe8:	f84080e7          	jalr	-124(ra) # 80000f68 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002fec:	0184a783          	lw	a5,24(s1)
    80002ff0:	fd3798e3          	bne	a5,s3,80002fc0 <wakeup+0x44>
    80002ff4:	0204b783          	ld	a5,32(s1)
    80002ff8:	fd4794e3          	bne	a5,s4,80002fc0 <wakeup+0x44>
        p->state = RUNNABLE;
    80002ffc:	0154ac23          	sw	s5,24(s1)
    80003000:	fc1ff06f          	j	80002fc0 <wakeup+0x44>
    }
  }
}
    80003004:	03813083          	ld	ra,56(sp)
    80003008:	03013403          	ld	s0,48(sp)
    8000300c:	02813483          	ld	s1,40(sp)
    80003010:	02013903          	ld	s2,32(sp)
    80003014:	01813983          	ld	s3,24(sp)
    80003018:	01013a03          	ld	s4,16(sp)
    8000301c:	00813a83          	ld	s5,8(sp)
    80003020:	04010113          	addi	sp,sp,64
    80003024:	00008067          	ret

0000000080003028 <reparent>:
{
    80003028:	fd010113          	addi	sp,sp,-48
    8000302c:	02113423          	sd	ra,40(sp)
    80003030:	02813023          	sd	s0,32(sp)
    80003034:	00913c23          	sd	s1,24(sp)
    80003038:	01213823          	sd	s2,16(sp)
    8000303c:	01313423          	sd	s3,8(sp)
    80003040:	01413023          	sd	s4,0(sp)
    80003044:	03010413          	addi	s0,sp,48
    80003048:	00050913          	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000304c:	00010497          	auipc	s1,0x10
    80003050:	e9448493          	addi	s1,s1,-364 # 80012ee0 <proc>
      pp->parent = initproc;
    80003054:	00007a17          	auipc	s4,0x7
    80003058:	7e4a0a13          	addi	s4,s4,2020 # 8000a838 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000305c:	00016997          	auipc	s3,0x16
    80003060:	88498993          	addi	s3,s3,-1916 # 800188e0 <tickslock>
    80003064:	00c0006f          	j	80003070 <reparent+0x48>
    80003068:	16848493          	addi	s1,s1,360
    8000306c:	03348063          	beq	s1,s3,8000308c <reparent+0x64>
    if(pp->parent == p){
    80003070:	0384b783          	ld	a5,56(s1)
    80003074:	ff279ae3          	bne	a5,s2,80003068 <reparent+0x40>
      pp->parent = initproc;
    80003078:	000a3503          	ld	a0,0(s4)
    8000307c:	02a4bc23          	sd	a0,56(s1)
      wakeup(initproc);
    80003080:	00000097          	auipc	ra,0x0
    80003084:	efc080e7          	jalr	-260(ra) # 80002f7c <wakeup>
    80003088:	fe1ff06f          	j	80003068 <reparent+0x40>
}
    8000308c:	02813083          	ld	ra,40(sp)
    80003090:	02013403          	ld	s0,32(sp)
    80003094:	01813483          	ld	s1,24(sp)
    80003098:	01013903          	ld	s2,16(sp)
    8000309c:	00813983          	ld	s3,8(sp)
    800030a0:	00013a03          	ld	s4,0(sp)
    800030a4:	03010113          	addi	sp,sp,48
    800030a8:	00008067          	ret

00000000800030ac <exit>:
{
    800030ac:	fd010113          	addi	sp,sp,-48
    800030b0:	02113423          	sd	ra,40(sp)
    800030b4:	02813023          	sd	s0,32(sp)
    800030b8:	00913c23          	sd	s1,24(sp)
    800030bc:	01213823          	sd	s2,16(sp)
    800030c0:	01313423          	sd	s3,8(sp)
    800030c4:	01413023          	sd	s4,0(sp)
    800030c8:	03010413          	addi	s0,sp,48
    800030cc:	00050a13          	mv	s4,a0
  struct proc *p = myproc();
    800030d0:	fffff097          	auipc	ra,0xfffff
    800030d4:	31c080e7          	jalr	796(ra) # 800023ec <myproc>
    800030d8:	00050993          	mv	s3,a0
  if(p == initproc)
    800030dc:	00007797          	auipc	a5,0x7
    800030e0:	75c7b783          	ld	a5,1884(a5) # 8000a838 <initproc>
    800030e4:	0d050493          	addi	s1,a0,208
    800030e8:	15050913          	addi	s2,a0,336
    800030ec:	02a79463          	bne	a5,a0,80003114 <exit+0x68>
    panic("init exiting");
    800030f0:	00007517          	auipc	a0,0x7
    800030f4:	16850513          	addi	a0,a0,360 # 8000a258 <digits+0x218>
    800030f8:	ffffd097          	auipc	ra,0xffffd
    800030fc:	5d4080e7          	jalr	1492(ra) # 800006cc <panic>
      fileclose(f);
    80003100:	00003097          	auipc	ra,0x3
    80003104:	e6c080e7          	jalr	-404(ra) # 80005f6c <fileclose>
      p->ofile[fd] = 0;
    80003108:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000310c:	00848493          	addi	s1,s1,8
    80003110:	01248863          	beq	s1,s2,80003120 <exit+0x74>
    if(p->ofile[fd]){
    80003114:	0004b503          	ld	a0,0(s1)
    80003118:	fe0514e3          	bnez	a0,80003100 <exit+0x54>
    8000311c:	ff1ff06f          	j	8000310c <exit+0x60>
  begin_op();
    80003120:	00002097          	auipc	ra,0x2
    80003124:	7c0080e7          	jalr	1984(ra) # 800058e0 <begin_op>
  iput(p->cwd);
    80003128:	1509b503          	ld	a0,336(s3)
    8000312c:	00002097          	auipc	ra,0x2
    80003130:	c2c080e7          	jalr	-980(ra) # 80004d58 <iput>
  end_op();
    80003134:	00003097          	auipc	ra,0x3
    80003138:	860080e7          	jalr	-1952(ra) # 80005994 <end_op>
  p->cwd = 0;
    8000313c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80003140:	00010497          	auipc	s1,0x10
    80003144:	98848493          	addi	s1,s1,-1656 # 80012ac8 <wait_lock>
    80003148:	00048513          	mv	a0,s1
    8000314c:	ffffe097          	auipc	ra,0xffffe
    80003150:	e1c080e7          	jalr	-484(ra) # 80000f68 <acquire>
  reparent(p);
    80003154:	00098513          	mv	a0,s3
    80003158:	00000097          	auipc	ra,0x0
    8000315c:	ed0080e7          	jalr	-304(ra) # 80003028 <reparent>
  wakeup(p->parent);
    80003160:	0389b503          	ld	a0,56(s3)
    80003164:	00000097          	auipc	ra,0x0
    80003168:	e18080e7          	jalr	-488(ra) # 80002f7c <wakeup>
  acquire(&p->lock);
    8000316c:	00098513          	mv	a0,s3
    80003170:	ffffe097          	auipc	ra,0xffffe
    80003174:	df8080e7          	jalr	-520(ra) # 80000f68 <acquire>
  p->xstate = status;
    80003178:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000317c:	00500793          	li	a5,5
    80003180:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80003184:	00048513          	mv	a0,s1
    80003188:	ffffe097          	auipc	ra,0xffffe
    8000318c:	ed8080e7          	jalr	-296(ra) # 80001060 <release>
  sched();
    80003190:	00000097          	auipc	ra,0x0
    80003194:	a54080e7          	jalr	-1452(ra) # 80002be4 <sched>
  panic("zombie exit");
    80003198:	00007517          	auipc	a0,0x7
    8000319c:	0d050513          	addi	a0,a0,208 # 8000a268 <digits+0x228>
    800031a0:	ffffd097          	auipc	ra,0xffffd
    800031a4:	52c080e7          	jalr	1324(ra) # 800006cc <panic>

00000000800031a8 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800031a8:	fd010113          	addi	sp,sp,-48
    800031ac:	02113423          	sd	ra,40(sp)
    800031b0:	02813023          	sd	s0,32(sp)
    800031b4:	00913c23          	sd	s1,24(sp)
    800031b8:	01213823          	sd	s2,16(sp)
    800031bc:	01313423          	sd	s3,8(sp)
    800031c0:	03010413          	addi	s0,sp,48
    800031c4:	00050913          	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800031c8:	00010497          	auipc	s1,0x10
    800031cc:	d1848493          	addi	s1,s1,-744 # 80012ee0 <proc>
    800031d0:	00015997          	auipc	s3,0x15
    800031d4:	71098993          	addi	s3,s3,1808 # 800188e0 <tickslock>
    acquire(&p->lock);
    800031d8:	00048513          	mv	a0,s1
    800031dc:	ffffe097          	auipc	ra,0xffffe
    800031e0:	d8c080e7          	jalr	-628(ra) # 80000f68 <acquire>
    if(p->pid == pid){
    800031e4:	0304a783          	lw	a5,48(s1)
    800031e8:	03278063          	beq	a5,s2,80003208 <kill+0x60>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800031ec:	00048513          	mv	a0,s1
    800031f0:	ffffe097          	auipc	ra,0xffffe
    800031f4:	e70080e7          	jalr	-400(ra) # 80001060 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800031f8:	16848493          	addi	s1,s1,360
    800031fc:	fd349ee3          	bne	s1,s3,800031d8 <kill+0x30>
  }
  return -1;
    80003200:	fff00513          	li	a0,-1
    80003204:	0280006f          	j	8000322c <kill+0x84>
      p->killed = 1;
    80003208:	00100793          	li	a5,1
    8000320c:	02f4a423          	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80003210:	0184a703          	lw	a4,24(s1)
    80003214:	00200793          	li	a5,2
    80003218:	02f70863          	beq	a4,a5,80003248 <kill+0xa0>
      release(&p->lock);
    8000321c:	00048513          	mv	a0,s1
    80003220:	ffffe097          	auipc	ra,0xffffe
    80003224:	e40080e7          	jalr	-448(ra) # 80001060 <release>
      return 0;
    80003228:	00000513          	li	a0,0
}
    8000322c:	02813083          	ld	ra,40(sp)
    80003230:	02013403          	ld	s0,32(sp)
    80003234:	01813483          	ld	s1,24(sp)
    80003238:	01013903          	ld	s2,16(sp)
    8000323c:	00813983          	ld	s3,8(sp)
    80003240:	03010113          	addi	sp,sp,48
    80003244:	00008067          	ret
        p->state = RUNNABLE;
    80003248:	00300793          	li	a5,3
    8000324c:	00f4ac23          	sw	a5,24(s1)
    80003250:	fcdff06f          	j	8000321c <kill+0x74>

0000000080003254 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80003254:	fd010113          	addi	sp,sp,-48
    80003258:	02113423          	sd	ra,40(sp)
    8000325c:	02813023          	sd	s0,32(sp)
    80003260:	00913c23          	sd	s1,24(sp)
    80003264:	01213823          	sd	s2,16(sp)
    80003268:	01313423          	sd	s3,8(sp)
    8000326c:	01413023          	sd	s4,0(sp)
    80003270:	03010413          	addi	s0,sp,48
    80003274:	00050493          	mv	s1,a0
    80003278:	00058913          	mv	s2,a1
    8000327c:	00060993          	mv	s3,a2
    80003280:	00068a13          	mv	s4,a3
  struct proc *p = myproc();
    80003284:	fffff097          	auipc	ra,0xfffff
    80003288:	168080e7          	jalr	360(ra) # 800023ec <myproc>
  if(user_dst){
    8000328c:	02048e63          	beqz	s1,800032c8 <either_copyout+0x74>
    return copyout(p->pagetable, dst, src, len);
    80003290:	000a0693          	mv	a3,s4
    80003294:	00098613          	mv	a2,s3
    80003298:	00090593          	mv	a1,s2
    8000329c:	05053503          	ld	a0,80(a0)
    800032a0:	fffff097          	auipc	ra,0xfffff
    800032a4:	c54080e7          	jalr	-940(ra) # 80001ef4 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800032a8:	02813083          	ld	ra,40(sp)
    800032ac:	02013403          	ld	s0,32(sp)
    800032b0:	01813483          	ld	s1,24(sp)
    800032b4:	01013903          	ld	s2,16(sp)
    800032b8:	00813983          	ld	s3,8(sp)
    800032bc:	00013a03          	ld	s4,0(sp)
    800032c0:	03010113          	addi	sp,sp,48
    800032c4:	00008067          	ret
    memmove((char *)dst, src, len);
    800032c8:	000a061b          	sext.w	a2,s4
    800032cc:	00098593          	mv	a1,s3
    800032d0:	00090513          	mv	a0,s2
    800032d4:	ffffe097          	auipc	ra,0xffffe
    800032d8:	e80080e7          	jalr	-384(ra) # 80001154 <memmove>
    return 0;
    800032dc:	00048513          	mv	a0,s1
    800032e0:	fc9ff06f          	j	800032a8 <either_copyout+0x54>

00000000800032e4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800032e4:	fd010113          	addi	sp,sp,-48
    800032e8:	02113423          	sd	ra,40(sp)
    800032ec:	02813023          	sd	s0,32(sp)
    800032f0:	00913c23          	sd	s1,24(sp)
    800032f4:	01213823          	sd	s2,16(sp)
    800032f8:	01313423          	sd	s3,8(sp)
    800032fc:	01413023          	sd	s4,0(sp)
    80003300:	03010413          	addi	s0,sp,48
    80003304:	00050913          	mv	s2,a0
    80003308:	00058493          	mv	s1,a1
    8000330c:	00060993          	mv	s3,a2
    80003310:	00068a13          	mv	s4,a3
  struct proc *p = myproc();
    80003314:	fffff097          	auipc	ra,0xfffff
    80003318:	0d8080e7          	jalr	216(ra) # 800023ec <myproc>
  if(user_src){
    8000331c:	02048e63          	beqz	s1,80003358 <either_copyin+0x74>
    return copyin(p->pagetable, dst, src, len);
    80003320:	000a0693          	mv	a3,s4
    80003324:	00098613          	mv	a2,s3
    80003328:	00090593          	mv	a1,s2
    8000332c:	05053503          	ld	a0,80(a0)
    80003330:	fffff097          	auipc	ra,0xfffff
    80003334:	cac080e7          	jalr	-852(ra) # 80001fdc <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80003338:	02813083          	ld	ra,40(sp)
    8000333c:	02013403          	ld	s0,32(sp)
    80003340:	01813483          	ld	s1,24(sp)
    80003344:	01013903          	ld	s2,16(sp)
    80003348:	00813983          	ld	s3,8(sp)
    8000334c:	00013a03          	ld	s4,0(sp)
    80003350:	03010113          	addi	sp,sp,48
    80003354:	00008067          	ret
    memmove(dst, (char*)src, len);
    80003358:	000a061b          	sext.w	a2,s4
    8000335c:	00098593          	mv	a1,s3
    80003360:	00090513          	mv	a0,s2
    80003364:	ffffe097          	auipc	ra,0xffffe
    80003368:	df0080e7          	jalr	-528(ra) # 80001154 <memmove>
    return 0;
    8000336c:	00048513          	mv	a0,s1
    80003370:	fc9ff06f          	j	80003338 <either_copyin+0x54>

0000000080003374 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80003374:	fb010113          	addi	sp,sp,-80
    80003378:	04113423          	sd	ra,72(sp)
    8000337c:	04813023          	sd	s0,64(sp)
    80003380:	02913c23          	sd	s1,56(sp)
    80003384:	03213823          	sd	s2,48(sp)
    80003388:	03313423          	sd	s3,40(sp)
    8000338c:	03413023          	sd	s4,32(sp)
    80003390:	01513c23          	sd	s5,24(sp)
    80003394:	01613823          	sd	s6,16(sp)
    80003398:	01713423          	sd	s7,8(sp)
    8000339c:	05010413          	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800033a0:	00007517          	auipc	a0,0x7
    800033a4:	d2050513          	addi	a0,a0,-736 # 8000a0c0 <digits+0x80>
    800033a8:	ffffd097          	auipc	ra,0xffffd
    800033ac:	380080e7          	jalr	896(ra) # 80000728 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800033b0:	00010497          	auipc	s1,0x10
    800033b4:	c8848493          	addi	s1,s1,-888 # 80013038 <proc+0x158>
    800033b8:	00015917          	auipc	s2,0x15
    800033bc:	68090913          	addi	s2,s2,1664 # 80018a38 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800033c0:	00500b13          	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800033c4:	00007997          	auipc	s3,0x7
    800033c8:	eb498993          	addi	s3,s3,-332 # 8000a278 <digits+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    800033cc:	00007a97          	auipc	s5,0x7
    800033d0:	eb4a8a93          	addi	s5,s5,-332 # 8000a280 <digits+0x240>
    printf("\n");
    800033d4:	00007a17          	auipc	s4,0x7
    800033d8:	ceca0a13          	addi	s4,s4,-788 # 8000a0c0 <digits+0x80>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800033dc:	00007b97          	auipc	s7,0x7
    800033e0:	edcb8b93          	addi	s7,s7,-292 # 8000a2b8 <states.0>
    800033e4:	0280006f          	j	8000340c <procdump+0x98>
    printf("%d %s %s", p->pid, state, p->name);
    800033e8:	ed86a583          	lw	a1,-296(a3)
    800033ec:	000a8513          	mv	a0,s5
    800033f0:	ffffd097          	auipc	ra,0xffffd
    800033f4:	338080e7          	jalr	824(ra) # 80000728 <printf>
    printf("\n");
    800033f8:	000a0513          	mv	a0,s4
    800033fc:	ffffd097          	auipc	ra,0xffffd
    80003400:	32c080e7          	jalr	812(ra) # 80000728 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003404:	16848493          	addi	s1,s1,360
    80003408:	03248a63          	beq	s1,s2,8000343c <procdump+0xc8>
    if(p->state == UNUSED)
    8000340c:	00048693          	mv	a3,s1
    80003410:	ec04a783          	lw	a5,-320(s1)
    80003414:	fe0788e3          	beqz	a5,80003404 <procdump+0x90>
      state = "???";
    80003418:	00098613          	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000341c:	fcfb66e3          	bltu	s6,a5,800033e8 <procdump+0x74>
    80003420:	02079713          	slli	a4,a5,0x20
    80003424:	01d75793          	srli	a5,a4,0x1d
    80003428:	00fb87b3          	add	a5,s7,a5
    8000342c:	0007b603          	ld	a2,0(a5)
    80003430:	fa061ce3          	bnez	a2,800033e8 <procdump+0x74>
      state = "???";
    80003434:	00098613          	mv	a2,s3
    80003438:	fb1ff06f          	j	800033e8 <procdump+0x74>
  }
}
    8000343c:	04813083          	ld	ra,72(sp)
    80003440:	04013403          	ld	s0,64(sp)
    80003444:	03813483          	ld	s1,56(sp)
    80003448:	03013903          	ld	s2,48(sp)
    8000344c:	02813983          	ld	s3,40(sp)
    80003450:	02013a03          	ld	s4,32(sp)
    80003454:	01813a83          	ld	s5,24(sp)
    80003458:	01013b03          	ld	s6,16(sp)
    8000345c:	00813b83          	ld	s7,8(sp)
    80003460:	05010113          	addi	sp,sp,80
    80003464:	00008067          	ret

0000000080003468 <swtch>:
    80003468:	00153023          	sd	ra,0(a0)
    8000346c:	00253423          	sd	sp,8(a0)
    80003470:	00853823          	sd	s0,16(a0)
    80003474:	00953c23          	sd	s1,24(a0)
    80003478:	03253023          	sd	s2,32(a0)
    8000347c:	03353423          	sd	s3,40(a0)
    80003480:	03453823          	sd	s4,48(a0)
    80003484:	03553c23          	sd	s5,56(a0)
    80003488:	05653023          	sd	s6,64(a0)
    8000348c:	05753423          	sd	s7,72(a0)
    80003490:	05853823          	sd	s8,80(a0)
    80003494:	05953c23          	sd	s9,88(a0)
    80003498:	07a53023          	sd	s10,96(a0)
    8000349c:	07b53423          	sd	s11,104(a0)
    800034a0:	0005b083          	ld	ra,0(a1)
    800034a4:	0085b103          	ld	sp,8(a1)
    800034a8:	0105b403          	ld	s0,16(a1)
    800034ac:	0185b483          	ld	s1,24(a1)
    800034b0:	0205b903          	ld	s2,32(a1)
    800034b4:	0285b983          	ld	s3,40(a1)
    800034b8:	0305ba03          	ld	s4,48(a1)
    800034bc:	0385ba83          	ld	s5,56(a1)
    800034c0:	0405bb03          	ld	s6,64(a1)
    800034c4:	0485bb83          	ld	s7,72(a1)
    800034c8:	0505bc03          	ld	s8,80(a1)
    800034cc:	0585bc83          	ld	s9,88(a1)
    800034d0:	0605bd03          	ld	s10,96(a1)
    800034d4:	0685bd83          	ld	s11,104(a1)
    800034d8:	00008067          	ret

00000000800034dc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800034dc:	ff010113          	addi	sp,sp,-16
    800034e0:	00113423          	sd	ra,8(sp)
    800034e4:	00813023          	sd	s0,0(sp)
    800034e8:	01010413          	addi	s0,sp,16
  initlock(&tickslock, "time");
    800034ec:	00007597          	auipc	a1,0x7
    800034f0:	dfc58593          	addi	a1,a1,-516 # 8000a2e8 <states.0+0x30>
    800034f4:	00015517          	auipc	a0,0x15
    800034f8:	3ec50513          	addi	a0,a0,1004 # 800188e0 <tickslock>
    800034fc:	ffffe097          	auipc	ra,0xffffe
    80003500:	988080e7          	jalr	-1656(ra) # 80000e84 <initlock>
}
    80003504:	00813083          	ld	ra,8(sp)
    80003508:	00013403          	ld	s0,0(sp)
    8000350c:	01010113          	addi	sp,sp,16
    80003510:	00008067          	ret

0000000080003514 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003514:	ff010113          	addi	sp,sp,-16
    80003518:	00813423          	sd	s0,8(sp)
    8000351c:	01010413          	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003520:	00005797          	auipc	a5,0x5
    80003524:	8b078793          	addi	a5,a5,-1872 # 80007dd0 <kernelvec>
    80003528:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000352c:	00813403          	ld	s0,8(sp)
    80003530:	01010113          	addi	sp,sp,16
    80003534:	00008067          	ret

0000000080003538 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80003538:	ff010113          	addi	sp,sp,-16
    8000353c:	00113423          	sd	ra,8(sp)
    80003540:	00813023          	sd	s0,0(sp)
    80003544:	01010413          	addi	s0,sp,16
  struct proc *p = myproc();
    80003548:	fffff097          	auipc	ra,0xfffff
    8000354c:	ea4080e7          	jalr	-348(ra) # 800023ec <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003550:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003554:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003558:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    8000355c:	00006617          	auipc	a2,0x6
    80003560:	aa460613          	addi	a2,a2,-1372 # 80009000 <_trampoline>
    80003564:	00006697          	auipc	a3,0x6
    80003568:	a9c68693          	addi	a3,a3,-1380 # 80009000 <_trampoline>
    8000356c:	40c686b3          	sub	a3,a3,a2
    80003570:	040007b7          	lui	a5,0x4000
    80003574:	fff78793          	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003578:	00c79793          	slli	a5,a5,0xc
    8000357c:	00f686b3          	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003580:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80003584:	05853703          	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003588:	180026f3          	csrr	a3,satp
    8000358c:	00d73023          	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80003590:	05853703          	ld	a4,88(a0)
    80003594:	04053683          	ld	a3,64(a0)
    80003598:	000015b7          	lui	a1,0x1
    8000359c:	00b686b3          	add	a3,a3,a1
    800035a0:	00d73423          	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800035a4:	05853703          	ld	a4,88(a0)
    800035a8:	00000697          	auipc	a3,0x0
    800035ac:	1a868693          	addi	a3,a3,424 # 80003750 <usertrap>
    800035b0:	00d73823          	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800035b4:	05853703          	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800035b8:	00020693          	mv	a3,tp
    800035bc:	02d73023          	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800035c0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800035c4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800035c8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800035cc:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800035d0:	05853703          	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800035d4:	01873703          	ld	a4,24(a4)
    800035d8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800035dc:	05053583          	ld	a1,80(a0)
    800035e0:	00c5d593          	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800035e4:	00006717          	auipc	a4,0x6
    800035e8:	abc70713          	addi	a4,a4,-1348 # 800090a0 <userret>
    800035ec:	40c70733          	sub	a4,a4,a2
    800035f0:	00f707b3          	add	a5,a4,a5
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800035f4:	fff00713          	li	a4,-1
    800035f8:	03f71713          	slli	a4,a4,0x3f
    800035fc:	00e5e5b3          	or	a1,a1,a4
    80003600:	02000537          	lui	a0,0x2000
    80003604:	fff50513          	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80003608:	00d51513          	slli	a0,a0,0xd
    8000360c:	000780e7          	jalr	a5
}
    80003610:	00813083          	ld	ra,8(sp)
    80003614:	00013403          	ld	s0,0(sp)
    80003618:	01010113          	addi	sp,sp,16
    8000361c:	00008067          	ret

0000000080003620 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80003620:	fe010113          	addi	sp,sp,-32
    80003624:	00113c23          	sd	ra,24(sp)
    80003628:	00813823          	sd	s0,16(sp)
    8000362c:	00913423          	sd	s1,8(sp)
    80003630:	02010413          	addi	s0,sp,32
  acquire(&tickslock);
    80003634:	00015497          	auipc	s1,0x15
    80003638:	2ac48493          	addi	s1,s1,684 # 800188e0 <tickslock>
    8000363c:	00048513          	mv	a0,s1
    80003640:	ffffe097          	auipc	ra,0xffffe
    80003644:	928080e7          	jalr	-1752(ra) # 80000f68 <acquire>
  ticks++;
    80003648:	00007517          	auipc	a0,0x7
    8000364c:	1f850513          	addi	a0,a0,504 # 8000a840 <ticks>
    80003650:	00052783          	lw	a5,0(a0)
    80003654:	0017879b          	addiw	a5,a5,1
    80003658:	00f52023          	sw	a5,0(a0)
  wakeup(&ticks);
    8000365c:	00000097          	auipc	ra,0x0
    80003660:	920080e7          	jalr	-1760(ra) # 80002f7c <wakeup>
  release(&tickslock);
    80003664:	00048513          	mv	a0,s1
    80003668:	ffffe097          	auipc	ra,0xffffe
    8000366c:	9f8080e7          	jalr	-1544(ra) # 80001060 <release>
}
    80003670:	01813083          	ld	ra,24(sp)
    80003674:	01013403          	ld	s0,16(sp)
    80003678:	00813483          	ld	s1,8(sp)
    8000367c:	02010113          	addi	sp,sp,32
    80003680:	00008067          	ret

0000000080003684 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80003684:	fe010113          	addi	sp,sp,-32
    80003688:	00113c23          	sd	ra,24(sp)
    8000368c:	00813823          	sd	s0,16(sp)
    80003690:	00913423          	sd	s1,8(sp)
    80003694:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003698:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000369c:	02074663          	bltz	a4,800036c8 <devintr+0x44>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800036a0:	fff00793          	li	a5,-1
    800036a4:	03f79793          	slli	a5,a5,0x3f
    800036a8:	00178793          	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800036ac:	00000513          	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800036b0:	06f70a63          	beq	a4,a5,80003724 <devintr+0xa0>
  }
}
    800036b4:	01813083          	ld	ra,24(sp)
    800036b8:	01013403          	ld	s0,16(sp)
    800036bc:	00813483          	ld	s1,8(sp)
    800036c0:	02010113          	addi	sp,sp,32
    800036c4:	00008067          	ret
     (scause & 0xff) == 9){
    800036c8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800036cc:	00900693          	li	a3,9
    800036d0:	fcd798e3          	bne	a5,a3,800036a0 <devintr+0x1c>
    int irq = plic_claim();
    800036d4:	00005097          	auipc	ra,0x5
    800036d8:	8bc080e7          	jalr	-1860(ra) # 80007f90 <plic_claim>
    800036dc:	00050493          	mv	s1,a0
    if(irq == UART0_IRQ){
    800036e0:	00a00793          	li	a5,10
    800036e4:	02f50a63          	beq	a0,a5,80003718 <devintr+0x94>
    return 1;
    800036e8:	00100513          	li	a0,1
    } else if(irq){
    800036ec:	fc0484e3          	beqz	s1,800036b4 <devintr+0x30>
      printf("unexpected interrupt irq=%d\n", irq);
    800036f0:	00048593          	mv	a1,s1
    800036f4:	00007517          	auipc	a0,0x7
    800036f8:	bfc50513          	addi	a0,a0,-1028 # 8000a2f0 <states.0+0x38>
    800036fc:	ffffd097          	auipc	ra,0xffffd
    80003700:	02c080e7          	jalr	44(ra) # 80000728 <printf>
      plic_complete(irq);
    80003704:	00048513          	mv	a0,s1
    80003708:	00005097          	auipc	ra,0x5
    8000370c:	8c0080e7          	jalr	-1856(ra) # 80007fc8 <plic_complete>
    return 1;
    80003710:	00100513          	li	a0,1
    80003714:	fa1ff06f          	j	800036b4 <devintr+0x30>
      uartintr();
    80003718:	ffffd097          	auipc	ra,0xffffd
    8000371c:	570080e7          	jalr	1392(ra) # 80000c88 <uartintr>
    80003720:	fe5ff06f          	j	80003704 <devintr+0x80>
    if(cpuid() == 0){
    80003724:	fffff097          	auipc	ra,0xfffff
    80003728:	c78080e7          	jalr	-904(ra) # 8000239c <cpuid>
    8000372c:	00050c63          	beqz	a0,80003744 <devintr+0xc0>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003730:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80003734:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003738:	14479073          	csrw	sip,a5
    return 2;
    8000373c:	00200513          	li	a0,2
    80003740:	f75ff06f          	j	800036b4 <devintr+0x30>
      clockintr();
    80003744:	00000097          	auipc	ra,0x0
    80003748:	edc080e7          	jalr	-292(ra) # 80003620 <clockintr>
    8000374c:	fe5ff06f          	j	80003730 <devintr+0xac>

0000000080003750 <usertrap>:
{
    80003750:	fe010113          	addi	sp,sp,-32
    80003754:	00113c23          	sd	ra,24(sp)
    80003758:	00813823          	sd	s0,16(sp)
    8000375c:	00913423          	sd	s1,8(sp)
    80003760:	01213023          	sd	s2,0(sp)
    80003764:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003768:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000376c:	1007f793          	andi	a5,a5,256
    80003770:	08079463          	bnez	a5,800037f8 <usertrap+0xa8>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003774:	00004797          	auipc	a5,0x4
    80003778:	65c78793          	addi	a5,a5,1628 # 80007dd0 <kernelvec>
    8000377c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80003780:	fffff097          	auipc	ra,0xfffff
    80003784:	c6c080e7          	jalr	-916(ra) # 800023ec <myproc>
    80003788:	00050493          	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000378c:	05853783          	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003790:	14102773          	csrr	a4,sepc
    80003794:	00e7bc23          	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003798:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000379c:	00800793          	li	a5,8
    800037a0:	06f71c63          	bne	a4,a5,80003818 <usertrap+0xc8>
    if(p->killed)
    800037a4:	02852783          	lw	a5,40(a0)
    800037a8:	06079063          	bnez	a5,80003808 <usertrap+0xb8>
    p->trapframe->epc += 4;
    800037ac:	0584b703          	ld	a4,88(s1)
    800037b0:	01873783          	ld	a5,24(a4)
    800037b4:	00478793          	addi	a5,a5,4
    800037b8:	00f73c23          	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800037bc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800037c0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800037c4:	10079073          	csrw	sstatus,a5
    syscall();
    800037c8:	00000097          	auipc	ra,0x0
    800037cc:	430080e7          	jalr	1072(ra) # 80003bf8 <syscall>
  if(p->killed)
    800037d0:	0284a783          	lw	a5,40(s1)
    800037d4:	0a079c63          	bnez	a5,8000388c <usertrap+0x13c>
  usertrapret();
    800037d8:	00000097          	auipc	ra,0x0
    800037dc:	d60080e7          	jalr	-672(ra) # 80003538 <usertrapret>
}
    800037e0:	01813083          	ld	ra,24(sp)
    800037e4:	01013403          	ld	s0,16(sp)
    800037e8:	00813483          	ld	s1,8(sp)
    800037ec:	00013903          	ld	s2,0(sp)
    800037f0:	02010113          	addi	sp,sp,32
    800037f4:	00008067          	ret
    panic("usertrap: not from user mode");
    800037f8:	00007517          	auipc	a0,0x7
    800037fc:	b1850513          	addi	a0,a0,-1256 # 8000a310 <states.0+0x58>
    80003800:	ffffd097          	auipc	ra,0xffffd
    80003804:	ecc080e7          	jalr	-308(ra) # 800006cc <panic>
      exit(-1);
    80003808:	fff00513          	li	a0,-1
    8000380c:	00000097          	auipc	ra,0x0
    80003810:	8a0080e7          	jalr	-1888(ra) # 800030ac <exit>
    80003814:	f99ff06f          	j	800037ac <usertrap+0x5c>
  } else if((which_dev = devintr()) != 0){
    80003818:	00000097          	auipc	ra,0x0
    8000381c:	e6c080e7          	jalr	-404(ra) # 80003684 <devintr>
    80003820:	00050913          	mv	s2,a0
    80003824:	00050863          	beqz	a0,80003834 <usertrap+0xe4>
  if(p->killed)
    80003828:	0284a783          	lw	a5,40(s1)
    8000382c:	04078663          	beqz	a5,80003878 <usertrap+0x128>
    80003830:	03c0006f          	j	8000386c <usertrap+0x11c>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003834:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003838:	0304a603          	lw	a2,48(s1)
    8000383c:	00007517          	auipc	a0,0x7
    80003840:	af450513          	addi	a0,a0,-1292 # 8000a330 <states.0+0x78>
    80003844:	ffffd097          	auipc	ra,0xffffd
    80003848:	ee4080e7          	jalr	-284(ra) # 80000728 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000384c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003850:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003854:	00007517          	auipc	a0,0x7
    80003858:	b0c50513          	addi	a0,a0,-1268 # 8000a360 <states.0+0xa8>
    8000385c:	ffffd097          	auipc	ra,0xffffd
    80003860:	ecc080e7          	jalr	-308(ra) # 80000728 <printf>
    p->killed = 1;
    80003864:	00100793          	li	a5,1
    80003868:	02f4a423          	sw	a5,40(s1)
    exit(-1);
    8000386c:	fff00513          	li	a0,-1
    80003870:	00000097          	auipc	ra,0x0
    80003874:	83c080e7          	jalr	-1988(ra) # 800030ac <exit>
  if(which_dev == 2)
    80003878:	00200793          	li	a5,2
    8000387c:	f4f91ee3          	bne	s2,a5,800037d8 <usertrap+0x88>
    yield();
    80003880:	fffff097          	auipc	ra,0xfffff
    80003884:	484080e7          	jalr	1156(ra) # 80002d04 <yield>
    80003888:	f51ff06f          	j	800037d8 <usertrap+0x88>
  int which_dev = 0;
    8000388c:	00000913          	li	s2,0
    80003890:	fddff06f          	j	8000386c <usertrap+0x11c>

0000000080003894 <kerneltrap>:
{
    80003894:	fd010113          	addi	sp,sp,-48
    80003898:	02113423          	sd	ra,40(sp)
    8000389c:	02813023          	sd	s0,32(sp)
    800038a0:	00913c23          	sd	s1,24(sp)
    800038a4:	01213823          	sd	s2,16(sp)
    800038a8:	01313423          	sd	s3,8(sp)
    800038ac:	03010413          	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800038b0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800038b4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800038b8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800038bc:	1004f793          	andi	a5,s1,256
    800038c0:	04078463          	beqz	a5,80003908 <kerneltrap+0x74>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800038c4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800038c8:	0027f793          	andi	a5,a5,2
  if(intr_get() != 0)
    800038cc:	04079663          	bnez	a5,80003918 <kerneltrap+0x84>
  if((which_dev = devintr()) == 0){
    800038d0:	00000097          	auipc	ra,0x0
    800038d4:	db4080e7          	jalr	-588(ra) # 80003684 <devintr>
    800038d8:	04050863          	beqz	a0,80003928 <kerneltrap+0x94>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800038dc:	00200793          	li	a5,2
    800038e0:	08f50263          	beq	a0,a5,80003964 <kerneltrap+0xd0>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800038e4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800038e8:	10049073          	csrw	sstatus,s1
}
    800038ec:	02813083          	ld	ra,40(sp)
    800038f0:	02013403          	ld	s0,32(sp)
    800038f4:	01813483          	ld	s1,24(sp)
    800038f8:	01013903          	ld	s2,16(sp)
    800038fc:	00813983          	ld	s3,8(sp)
    80003900:	03010113          	addi	sp,sp,48
    80003904:	00008067          	ret
    panic("kerneltrap: not from supervisor mode");
    80003908:	00007517          	auipc	a0,0x7
    8000390c:	a7850513          	addi	a0,a0,-1416 # 8000a380 <states.0+0xc8>
    80003910:	ffffd097          	auipc	ra,0xffffd
    80003914:	dbc080e7          	jalr	-580(ra) # 800006cc <panic>
    panic("kerneltrap: interrupts enabled");
    80003918:	00007517          	auipc	a0,0x7
    8000391c:	a9050513          	addi	a0,a0,-1392 # 8000a3a8 <states.0+0xf0>
    80003920:	ffffd097          	auipc	ra,0xffffd
    80003924:	dac080e7          	jalr	-596(ra) # 800006cc <panic>
    printf("scause %p\n", scause);
    80003928:	00098593          	mv	a1,s3
    8000392c:	00007517          	auipc	a0,0x7
    80003930:	a9c50513          	addi	a0,a0,-1380 # 8000a3c8 <states.0+0x110>
    80003934:	ffffd097          	auipc	ra,0xffffd
    80003938:	df4080e7          	jalr	-524(ra) # 80000728 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000393c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003940:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003944:	00007517          	auipc	a0,0x7
    80003948:	a9450513          	addi	a0,a0,-1388 # 8000a3d8 <states.0+0x120>
    8000394c:	ffffd097          	auipc	ra,0xffffd
    80003950:	ddc080e7          	jalr	-548(ra) # 80000728 <printf>
    panic("kerneltrap");
    80003954:	00007517          	auipc	a0,0x7
    80003958:	a9c50513          	addi	a0,a0,-1380 # 8000a3f0 <states.0+0x138>
    8000395c:	ffffd097          	auipc	ra,0xffffd
    80003960:	d70080e7          	jalr	-656(ra) # 800006cc <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003964:	fffff097          	auipc	ra,0xfffff
    80003968:	a88080e7          	jalr	-1400(ra) # 800023ec <myproc>
    8000396c:	f6050ce3          	beqz	a0,800038e4 <kerneltrap+0x50>
    80003970:	fffff097          	auipc	ra,0xfffff
    80003974:	a7c080e7          	jalr	-1412(ra) # 800023ec <myproc>
    80003978:	01852703          	lw	a4,24(a0)
    8000397c:	00400793          	li	a5,4
    80003980:	f6f712e3          	bne	a4,a5,800038e4 <kerneltrap+0x50>
    yield();
    80003984:	fffff097          	auipc	ra,0xfffff
    80003988:	380080e7          	jalr	896(ra) # 80002d04 <yield>
    8000398c:	f59ff06f          	j	800038e4 <kerneltrap+0x50>

0000000080003990 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003990:	fe010113          	addi	sp,sp,-32
    80003994:	00113c23          	sd	ra,24(sp)
    80003998:	00813823          	sd	s0,16(sp)
    8000399c:	00913423          	sd	s1,8(sp)
    800039a0:	02010413          	addi	s0,sp,32
    800039a4:	00050493          	mv	s1,a0
  struct proc *p = myproc();
    800039a8:	fffff097          	auipc	ra,0xfffff
    800039ac:	a44080e7          	jalr	-1468(ra) # 800023ec <myproc>
  switch (n) {
    800039b0:	00500793          	li	a5,5
    800039b4:	0697ec63          	bltu	a5,s1,80003a2c <argraw+0x9c>
    800039b8:	00249493          	slli	s1,s1,0x2
    800039bc:	00007717          	auipc	a4,0x7
    800039c0:	a6c70713          	addi	a4,a4,-1428 # 8000a428 <states.0+0x170>
    800039c4:	00e484b3          	add	s1,s1,a4
    800039c8:	0004a783          	lw	a5,0(s1)
    800039cc:	00e787b3          	add	a5,a5,a4
    800039d0:	00078067          	jr	a5
  case 0:
    return p->trapframe->a0;
    800039d4:	05853783          	ld	a5,88(a0)
    800039d8:	0707b503          	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800039dc:	01813083          	ld	ra,24(sp)
    800039e0:	01013403          	ld	s0,16(sp)
    800039e4:	00813483          	ld	s1,8(sp)
    800039e8:	02010113          	addi	sp,sp,32
    800039ec:	00008067          	ret
    return p->trapframe->a1;
    800039f0:	05853783          	ld	a5,88(a0)
    800039f4:	0787b503          	ld	a0,120(a5)
    800039f8:	fe5ff06f          	j	800039dc <argraw+0x4c>
    return p->trapframe->a2;
    800039fc:	05853783          	ld	a5,88(a0)
    80003a00:	0807b503          	ld	a0,128(a5)
    80003a04:	fd9ff06f          	j	800039dc <argraw+0x4c>
    return p->trapframe->a3;
    80003a08:	05853783          	ld	a5,88(a0)
    80003a0c:	0887b503          	ld	a0,136(a5)
    80003a10:	fcdff06f          	j	800039dc <argraw+0x4c>
    return p->trapframe->a4;
    80003a14:	05853783          	ld	a5,88(a0)
    80003a18:	0907b503          	ld	a0,144(a5)
    80003a1c:	fc1ff06f          	j	800039dc <argraw+0x4c>
    return p->trapframe->a5;
    80003a20:	05853783          	ld	a5,88(a0)
    80003a24:	0987b503          	ld	a0,152(a5)
    80003a28:	fb5ff06f          	j	800039dc <argraw+0x4c>
  panic("argraw");
    80003a2c:	00007517          	auipc	a0,0x7
    80003a30:	9d450513          	addi	a0,a0,-1580 # 8000a400 <states.0+0x148>
    80003a34:	ffffd097          	auipc	ra,0xffffd
    80003a38:	c98080e7          	jalr	-872(ra) # 800006cc <panic>

0000000080003a3c <fetchaddr>:
{
    80003a3c:	fe010113          	addi	sp,sp,-32
    80003a40:	00113c23          	sd	ra,24(sp)
    80003a44:	00813823          	sd	s0,16(sp)
    80003a48:	00913423          	sd	s1,8(sp)
    80003a4c:	01213023          	sd	s2,0(sp)
    80003a50:	02010413          	addi	s0,sp,32
    80003a54:	00050493          	mv	s1,a0
    80003a58:	00058913          	mv	s2,a1
  struct proc *p = myproc();
    80003a5c:	fffff097          	auipc	ra,0xfffff
    80003a60:	990080e7          	jalr	-1648(ra) # 800023ec <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80003a64:	04853783          	ld	a5,72(a0)
    80003a68:	04f4f263          	bgeu	s1,a5,80003aac <fetchaddr+0x70>
    80003a6c:	00848713          	addi	a4,s1,8
    80003a70:	04e7e263          	bltu	a5,a4,80003ab4 <fetchaddr+0x78>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003a74:	00800693          	li	a3,8
    80003a78:	00048613          	mv	a2,s1
    80003a7c:	00090593          	mv	a1,s2
    80003a80:	05053503          	ld	a0,80(a0)
    80003a84:	ffffe097          	auipc	ra,0xffffe
    80003a88:	558080e7          	jalr	1368(ra) # 80001fdc <copyin>
    80003a8c:	00a03533          	snez	a0,a0
    80003a90:	40a00533          	neg	a0,a0
}
    80003a94:	01813083          	ld	ra,24(sp)
    80003a98:	01013403          	ld	s0,16(sp)
    80003a9c:	00813483          	ld	s1,8(sp)
    80003aa0:	00013903          	ld	s2,0(sp)
    80003aa4:	02010113          	addi	sp,sp,32
    80003aa8:	00008067          	ret
    return -1;
    80003aac:	fff00513          	li	a0,-1
    80003ab0:	fe5ff06f          	j	80003a94 <fetchaddr+0x58>
    80003ab4:	fff00513          	li	a0,-1
    80003ab8:	fddff06f          	j	80003a94 <fetchaddr+0x58>

0000000080003abc <fetchstr>:
{
    80003abc:	fd010113          	addi	sp,sp,-48
    80003ac0:	02113423          	sd	ra,40(sp)
    80003ac4:	02813023          	sd	s0,32(sp)
    80003ac8:	00913c23          	sd	s1,24(sp)
    80003acc:	01213823          	sd	s2,16(sp)
    80003ad0:	01313423          	sd	s3,8(sp)
    80003ad4:	03010413          	addi	s0,sp,48
    80003ad8:	00050913          	mv	s2,a0
    80003adc:	00058493          	mv	s1,a1
    80003ae0:	00060993          	mv	s3,a2
  struct proc *p = myproc();
    80003ae4:	fffff097          	auipc	ra,0xfffff
    80003ae8:	908080e7          	jalr	-1784(ra) # 800023ec <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80003aec:	00098693          	mv	a3,s3
    80003af0:	00090613          	mv	a2,s2
    80003af4:	00048593          	mv	a1,s1
    80003af8:	05053503          	ld	a0,80(a0)
    80003afc:	ffffe097          	auipc	ra,0xffffe
    80003b00:	5c8080e7          	jalr	1480(ra) # 800020c4 <copyinstr>
  if(err < 0)
    80003b04:	00054863          	bltz	a0,80003b14 <fetchstr+0x58>
  return strlen(buf);
    80003b08:	00048513          	mv	a0,s1
    80003b0c:	ffffe097          	auipc	ra,0xffffe
    80003b10:	800080e7          	jalr	-2048(ra) # 8000130c <strlen>
}
    80003b14:	02813083          	ld	ra,40(sp)
    80003b18:	02013403          	ld	s0,32(sp)
    80003b1c:	01813483          	ld	s1,24(sp)
    80003b20:	01013903          	ld	s2,16(sp)
    80003b24:	00813983          	ld	s3,8(sp)
    80003b28:	03010113          	addi	sp,sp,48
    80003b2c:	00008067          	ret

0000000080003b30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80003b30:	fe010113          	addi	sp,sp,-32
    80003b34:	00113c23          	sd	ra,24(sp)
    80003b38:	00813823          	sd	s0,16(sp)
    80003b3c:	00913423          	sd	s1,8(sp)
    80003b40:	02010413          	addi	s0,sp,32
    80003b44:	00058493          	mv	s1,a1
  *ip = argraw(n);
    80003b48:	00000097          	auipc	ra,0x0
    80003b4c:	e48080e7          	jalr	-440(ra) # 80003990 <argraw>
    80003b50:	00a4a023          	sw	a0,0(s1)
  return 0;
}
    80003b54:	00000513          	li	a0,0
    80003b58:	01813083          	ld	ra,24(sp)
    80003b5c:	01013403          	ld	s0,16(sp)
    80003b60:	00813483          	ld	s1,8(sp)
    80003b64:	02010113          	addi	sp,sp,32
    80003b68:	00008067          	ret

0000000080003b6c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80003b6c:	fe010113          	addi	sp,sp,-32
    80003b70:	00113c23          	sd	ra,24(sp)
    80003b74:	00813823          	sd	s0,16(sp)
    80003b78:	00913423          	sd	s1,8(sp)
    80003b7c:	02010413          	addi	s0,sp,32
    80003b80:	00058493          	mv	s1,a1
  *ip = argraw(n);
    80003b84:	00000097          	auipc	ra,0x0
    80003b88:	e0c080e7          	jalr	-500(ra) # 80003990 <argraw>
    80003b8c:	00a4b023          	sd	a0,0(s1)
  return 0;
}
    80003b90:	00000513          	li	a0,0
    80003b94:	01813083          	ld	ra,24(sp)
    80003b98:	01013403          	ld	s0,16(sp)
    80003b9c:	00813483          	ld	s1,8(sp)
    80003ba0:	02010113          	addi	sp,sp,32
    80003ba4:	00008067          	ret

0000000080003ba8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003ba8:	fe010113          	addi	sp,sp,-32
    80003bac:	00113c23          	sd	ra,24(sp)
    80003bb0:	00813823          	sd	s0,16(sp)
    80003bb4:	00913423          	sd	s1,8(sp)
    80003bb8:	01213023          	sd	s2,0(sp)
    80003bbc:	02010413          	addi	s0,sp,32
    80003bc0:	00058493          	mv	s1,a1
    80003bc4:	00060913          	mv	s2,a2
  *ip = argraw(n);
    80003bc8:	00000097          	auipc	ra,0x0
    80003bcc:	dc8080e7          	jalr	-568(ra) # 80003990 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80003bd0:	00090613          	mv	a2,s2
    80003bd4:	00048593          	mv	a1,s1
    80003bd8:	00000097          	auipc	ra,0x0
    80003bdc:	ee4080e7          	jalr	-284(ra) # 80003abc <fetchstr>
}
    80003be0:	01813083          	ld	ra,24(sp)
    80003be4:	01013403          	ld	s0,16(sp)
    80003be8:	00813483          	ld	s1,8(sp)
    80003bec:	00013903          	ld	s2,0(sp)
    80003bf0:	02010113          	addi	sp,sp,32
    80003bf4:	00008067          	ret

0000000080003bf8 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80003bf8:	fe010113          	addi	sp,sp,-32
    80003bfc:	00113c23          	sd	ra,24(sp)
    80003c00:	00813823          	sd	s0,16(sp)
    80003c04:	00913423          	sd	s1,8(sp)
    80003c08:	01213023          	sd	s2,0(sp)
    80003c0c:	02010413          	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003c10:	ffffe097          	auipc	ra,0xffffe
    80003c14:	7dc080e7          	jalr	2012(ra) # 800023ec <myproc>
    80003c18:	00050493          	mv	s1,a0

  num = p->trapframe->a7;
    80003c1c:	05853903          	ld	s2,88(a0)
    80003c20:	0a893783          	ld	a5,168(s2)
    80003c24:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003c28:	fff7879b          	addiw	a5,a5,-1
    80003c2c:	01400713          	li	a4,20
    80003c30:	02f76463          	bltu	a4,a5,80003c58 <syscall+0x60>
    80003c34:	00369713          	slli	a4,a3,0x3
    80003c38:	00007797          	auipc	a5,0x7
    80003c3c:	80878793          	addi	a5,a5,-2040 # 8000a440 <syscalls>
    80003c40:	00e787b3          	add	a5,a5,a4
    80003c44:	0007b783          	ld	a5,0(a5)
    80003c48:	00078863          	beqz	a5,80003c58 <syscall+0x60>
    p->trapframe->a0 = syscalls[num]();
    80003c4c:	000780e7          	jalr	a5
    80003c50:	06a93823          	sd	a0,112(s2)
    80003c54:	0280006f          	j	80003c7c <syscall+0x84>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003c58:	15848613          	addi	a2,s1,344
    80003c5c:	0304a583          	lw	a1,48(s1)
    80003c60:	00006517          	auipc	a0,0x6
    80003c64:	7a850513          	addi	a0,a0,1960 # 8000a408 <states.0+0x150>
    80003c68:	ffffd097          	auipc	ra,0xffffd
    80003c6c:	ac0080e7          	jalr	-1344(ra) # 80000728 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003c70:	0584b783          	ld	a5,88(s1)
    80003c74:	fff00713          	li	a4,-1
    80003c78:	06e7b823          	sd	a4,112(a5)
  }
}
    80003c7c:	01813083          	ld	ra,24(sp)
    80003c80:	01013403          	ld	s0,16(sp)
    80003c84:	00813483          	ld	s1,8(sp)
    80003c88:	00013903          	ld	s2,0(sp)
    80003c8c:	02010113          	addi	sp,sp,32
    80003c90:	00008067          	ret

0000000080003c94 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003c94:	fe010113          	addi	sp,sp,-32
    80003c98:	00113c23          	sd	ra,24(sp)
    80003c9c:	00813823          	sd	s0,16(sp)
    80003ca0:	02010413          	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80003ca4:	fec40593          	addi	a1,s0,-20
    80003ca8:	00000513          	li	a0,0
    80003cac:	00000097          	auipc	ra,0x0
    80003cb0:	e84080e7          	jalr	-380(ra) # 80003b30 <argint>
    return -1;
    80003cb4:	fff00793          	li	a5,-1
  if(argint(0, &n) < 0)
    80003cb8:	00054a63          	bltz	a0,80003ccc <sys_exit+0x38>
  exit(n);
    80003cbc:	fec42503          	lw	a0,-20(s0)
    80003cc0:	fffff097          	auipc	ra,0xfffff
    80003cc4:	3ec080e7          	jalr	1004(ra) # 800030ac <exit>
  return 0;  // not reached
    80003cc8:	00000793          	li	a5,0
}
    80003ccc:	00078513          	mv	a0,a5
    80003cd0:	01813083          	ld	ra,24(sp)
    80003cd4:	01013403          	ld	s0,16(sp)
    80003cd8:	02010113          	addi	sp,sp,32
    80003cdc:	00008067          	ret

0000000080003ce0 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003ce0:	ff010113          	addi	sp,sp,-16
    80003ce4:	00113423          	sd	ra,8(sp)
    80003ce8:	00813023          	sd	s0,0(sp)
    80003cec:	01010413          	addi	s0,sp,16
  return myproc()->pid;
    80003cf0:	ffffe097          	auipc	ra,0xffffe
    80003cf4:	6fc080e7          	jalr	1788(ra) # 800023ec <myproc>
}
    80003cf8:	03052503          	lw	a0,48(a0)
    80003cfc:	00813083          	ld	ra,8(sp)
    80003d00:	00013403          	ld	s0,0(sp)
    80003d04:	01010113          	addi	sp,sp,16
    80003d08:	00008067          	ret

0000000080003d0c <sys_fork>:

uint64
sys_fork(void)
{
    80003d0c:	ff010113          	addi	sp,sp,-16
    80003d10:	00113423          	sd	ra,8(sp)
    80003d14:	00813023          	sd	s0,0(sp)
    80003d18:	01010413          	addi	s0,sp,16
  return fork();
    80003d1c:	fffff097          	auipc	ra,0xfffff
    80003d20:	c58080e7          	jalr	-936(ra) # 80002974 <fork>
}
    80003d24:	00813083          	ld	ra,8(sp)
    80003d28:	00013403          	ld	s0,0(sp)
    80003d2c:	01010113          	addi	sp,sp,16
    80003d30:	00008067          	ret

0000000080003d34 <sys_wait>:

uint64
sys_wait(void)
{
    80003d34:	fe010113          	addi	sp,sp,-32
    80003d38:	00113c23          	sd	ra,24(sp)
    80003d3c:	00813823          	sd	s0,16(sp)
    80003d40:	02010413          	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80003d44:	fe840593          	addi	a1,s0,-24
    80003d48:	00000513          	li	a0,0
    80003d4c:	00000097          	auipc	ra,0x0
    80003d50:	e20080e7          	jalr	-480(ra) # 80003b6c <argaddr>
    80003d54:	00050793          	mv	a5,a0
    return -1;
    80003d58:	fff00513          	li	a0,-1
  if(argaddr(0, &p) < 0)
    80003d5c:	0007c863          	bltz	a5,80003d6c <sys_wait+0x38>
  return wait(p);
    80003d60:	fe843503          	ld	a0,-24(s0)
    80003d64:	fffff097          	auipc	ra,0xfffff
    80003d68:	088080e7          	jalr	136(ra) # 80002dec <wait>
}
    80003d6c:	01813083          	ld	ra,24(sp)
    80003d70:	01013403          	ld	s0,16(sp)
    80003d74:	02010113          	addi	sp,sp,32
    80003d78:	00008067          	ret

0000000080003d7c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003d7c:	fd010113          	addi	sp,sp,-48
    80003d80:	02113423          	sd	ra,40(sp)
    80003d84:	02813023          	sd	s0,32(sp)
    80003d88:	00913c23          	sd	s1,24(sp)
    80003d8c:	03010413          	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80003d90:	fdc40593          	addi	a1,s0,-36
    80003d94:	00000513          	li	a0,0
    80003d98:	00000097          	auipc	ra,0x0
    80003d9c:	d98080e7          	jalr	-616(ra) # 80003b30 <argint>
    return -1;
    80003da0:	fff00493          	li	s1,-1
  if(argint(0, &n) < 0)
    80003da4:	02054063          	bltz	a0,80003dc4 <sys_sbrk+0x48>
  addr = myproc()->sz;
    80003da8:	ffffe097          	auipc	ra,0xffffe
    80003dac:	644080e7          	jalr	1604(ra) # 800023ec <myproc>
    80003db0:	04852483          	lw	s1,72(a0)
  if(growproc(n) < 0)
    80003db4:	fdc42503          	lw	a0,-36(s0)
    80003db8:	fffff097          	auipc	ra,0xfffff
    80003dbc:	b04080e7          	jalr	-1276(ra) # 800028bc <growproc>
    80003dc0:	00054e63          	bltz	a0,80003ddc <sys_sbrk+0x60>
    return -1;
  return addr;
}
    80003dc4:	00048513          	mv	a0,s1
    80003dc8:	02813083          	ld	ra,40(sp)
    80003dcc:	02013403          	ld	s0,32(sp)
    80003dd0:	01813483          	ld	s1,24(sp)
    80003dd4:	03010113          	addi	sp,sp,48
    80003dd8:	00008067          	ret
    return -1;
    80003ddc:	fff00493          	li	s1,-1
    80003de0:	fe5ff06f          	j	80003dc4 <sys_sbrk+0x48>

0000000080003de4 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003de4:	fc010113          	addi	sp,sp,-64
    80003de8:	02113c23          	sd	ra,56(sp)
    80003dec:	02813823          	sd	s0,48(sp)
    80003df0:	02913423          	sd	s1,40(sp)
    80003df4:	03213023          	sd	s2,32(sp)
    80003df8:	01313c23          	sd	s3,24(sp)
    80003dfc:	04010413          	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80003e00:	fcc40593          	addi	a1,s0,-52
    80003e04:	00000513          	li	a0,0
    80003e08:	00000097          	auipc	ra,0x0
    80003e0c:	d28080e7          	jalr	-728(ra) # 80003b30 <argint>
    return -1;
    80003e10:	fff00793          	li	a5,-1
  if(argint(0, &n) < 0)
    80003e14:	06054c63          	bltz	a0,80003e8c <sys_sleep+0xa8>
  acquire(&tickslock);
    80003e18:	00015517          	auipc	a0,0x15
    80003e1c:	ac850513          	addi	a0,a0,-1336 # 800188e0 <tickslock>
    80003e20:	ffffd097          	auipc	ra,0xffffd
    80003e24:	148080e7          	jalr	328(ra) # 80000f68 <acquire>
  ticks0 = ticks;
    80003e28:	00007917          	auipc	s2,0x7
    80003e2c:	a1892903          	lw	s2,-1512(s2) # 8000a840 <ticks>
  while(ticks - ticks0 < n){
    80003e30:	fcc42783          	lw	a5,-52(s0)
    80003e34:	04078263          	beqz	a5,80003e78 <sys_sleep+0x94>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003e38:	00015997          	auipc	s3,0x15
    80003e3c:	aa898993          	addi	s3,s3,-1368 # 800188e0 <tickslock>
    80003e40:	00007497          	auipc	s1,0x7
    80003e44:	a0048493          	addi	s1,s1,-1536 # 8000a840 <ticks>
    if(myproc()->killed){
    80003e48:	ffffe097          	auipc	ra,0xffffe
    80003e4c:	5a4080e7          	jalr	1444(ra) # 800023ec <myproc>
    80003e50:	02852783          	lw	a5,40(a0)
    80003e54:	04079c63          	bnez	a5,80003eac <sys_sleep+0xc8>
    sleep(&ticks, &tickslock);
    80003e58:	00098593          	mv	a1,s3
    80003e5c:	00048513          	mv	a0,s1
    80003e60:	fffff097          	auipc	ra,0xfffff
    80003e64:	efc080e7          	jalr	-260(ra) # 80002d5c <sleep>
  while(ticks - ticks0 < n){
    80003e68:	0004a783          	lw	a5,0(s1)
    80003e6c:	412787bb          	subw	a5,a5,s2
    80003e70:	fcc42703          	lw	a4,-52(s0)
    80003e74:	fce7eae3          	bltu	a5,a4,80003e48 <sys_sleep+0x64>
  }
  release(&tickslock);
    80003e78:	00015517          	auipc	a0,0x15
    80003e7c:	a6850513          	addi	a0,a0,-1432 # 800188e0 <tickslock>
    80003e80:	ffffd097          	auipc	ra,0xffffd
    80003e84:	1e0080e7          	jalr	480(ra) # 80001060 <release>
  return 0;
    80003e88:	00000793          	li	a5,0
}
    80003e8c:	00078513          	mv	a0,a5
    80003e90:	03813083          	ld	ra,56(sp)
    80003e94:	03013403          	ld	s0,48(sp)
    80003e98:	02813483          	ld	s1,40(sp)
    80003e9c:	02013903          	ld	s2,32(sp)
    80003ea0:	01813983          	ld	s3,24(sp)
    80003ea4:	04010113          	addi	sp,sp,64
    80003ea8:	00008067          	ret
      release(&tickslock);
    80003eac:	00015517          	auipc	a0,0x15
    80003eb0:	a3450513          	addi	a0,a0,-1484 # 800188e0 <tickslock>
    80003eb4:	ffffd097          	auipc	ra,0xffffd
    80003eb8:	1ac080e7          	jalr	428(ra) # 80001060 <release>
      return -1;
    80003ebc:	fff00793          	li	a5,-1
    80003ec0:	fcdff06f          	j	80003e8c <sys_sleep+0xa8>

0000000080003ec4 <sys_kill>:

uint64
sys_kill(void)
{
    80003ec4:	fe010113          	addi	sp,sp,-32
    80003ec8:	00113c23          	sd	ra,24(sp)
    80003ecc:	00813823          	sd	s0,16(sp)
    80003ed0:	02010413          	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80003ed4:	fec40593          	addi	a1,s0,-20
    80003ed8:	00000513          	li	a0,0
    80003edc:	00000097          	auipc	ra,0x0
    80003ee0:	c54080e7          	jalr	-940(ra) # 80003b30 <argint>
    80003ee4:	00050793          	mv	a5,a0
    return -1;
    80003ee8:	fff00513          	li	a0,-1
  if(argint(0, &pid) < 0)
    80003eec:	0007c863          	bltz	a5,80003efc <sys_kill+0x38>
  return kill(pid);
    80003ef0:	fec42503          	lw	a0,-20(s0)
    80003ef4:	fffff097          	auipc	ra,0xfffff
    80003ef8:	2b4080e7          	jalr	692(ra) # 800031a8 <kill>
}
    80003efc:	01813083          	ld	ra,24(sp)
    80003f00:	01013403          	ld	s0,16(sp)
    80003f04:	02010113          	addi	sp,sp,32
    80003f08:	00008067          	ret

0000000080003f0c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003f0c:	fe010113          	addi	sp,sp,-32
    80003f10:	00113c23          	sd	ra,24(sp)
    80003f14:	00813823          	sd	s0,16(sp)
    80003f18:	00913423          	sd	s1,8(sp)
    80003f1c:	02010413          	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003f20:	00015517          	auipc	a0,0x15
    80003f24:	9c050513          	addi	a0,a0,-1600 # 800188e0 <tickslock>
    80003f28:	ffffd097          	auipc	ra,0xffffd
    80003f2c:	040080e7          	jalr	64(ra) # 80000f68 <acquire>
  xticks = ticks;
    80003f30:	00007497          	auipc	s1,0x7
    80003f34:	9104a483          	lw	s1,-1776(s1) # 8000a840 <ticks>
  release(&tickslock);
    80003f38:	00015517          	auipc	a0,0x15
    80003f3c:	9a850513          	addi	a0,a0,-1624 # 800188e0 <tickslock>
    80003f40:	ffffd097          	auipc	ra,0xffffd
    80003f44:	120080e7          	jalr	288(ra) # 80001060 <release>
  return xticks;
}
    80003f48:	02049513          	slli	a0,s1,0x20
    80003f4c:	02055513          	srli	a0,a0,0x20
    80003f50:	01813083          	ld	ra,24(sp)
    80003f54:	01013403          	ld	s0,16(sp)
    80003f58:	00813483          	ld	s1,8(sp)
    80003f5c:	02010113          	addi	sp,sp,32
    80003f60:	00008067          	ret

0000000080003f64 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003f64:	fd010113          	addi	sp,sp,-48
    80003f68:	02113423          	sd	ra,40(sp)
    80003f6c:	02813023          	sd	s0,32(sp)
    80003f70:	00913c23          	sd	s1,24(sp)
    80003f74:	01213823          	sd	s2,16(sp)
    80003f78:	01313423          	sd	s3,8(sp)
    80003f7c:	01413023          	sd	s4,0(sp)
    80003f80:	03010413          	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003f84:	00006597          	auipc	a1,0x6
    80003f88:	56c58593          	addi	a1,a1,1388 # 8000a4f0 <syscalls+0xb0>
    80003f8c:	00015517          	auipc	a0,0x15
    80003f90:	96c50513          	addi	a0,a0,-1684 # 800188f8 <bcache>
    80003f94:	ffffd097          	auipc	ra,0xffffd
    80003f98:	ef0080e7          	jalr	-272(ra) # 80000e84 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003f9c:	0001d797          	auipc	a5,0x1d
    80003fa0:	95c78793          	addi	a5,a5,-1700 # 800208f8 <bcache+0x8000>
    80003fa4:	0001d717          	auipc	a4,0x1d
    80003fa8:	cac70713          	addi	a4,a4,-852 # 80020c50 <bcache+0x8358>
    80003fac:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    80003fb0:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003fb4:	00015497          	auipc	s1,0x15
    80003fb8:	95c48493          	addi	s1,s1,-1700 # 80018910 <bcache+0x18>
    b->next = bcache.head.next;
    80003fbc:	00078913          	mv	s2,a5
    b->prev = &bcache.head;
    80003fc0:	00070993          	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003fc4:	00006a17          	auipc	s4,0x6
    80003fc8:	534a0a13          	addi	s4,s4,1332 # 8000a4f8 <syscalls+0xb8>
    b->next = bcache.head.next;
    80003fcc:	3a893783          	ld	a5,936(s2)
    80003fd0:	04f4b823          	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003fd4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003fd8:	000a0593          	mv	a1,s4
    80003fdc:	01048513          	addi	a0,s1,16
    80003fe0:	00002097          	auipc	ra,0x2
    80003fe4:	c90080e7          	jalr	-880(ra) # 80005c70 <initsleeplock>
    bcache.head.next->prev = b;
    80003fe8:	3a893783          	ld	a5,936(s2)
    80003fec:	0497b423          	sd	s1,72(a5)
    bcache.head.next = b;
    80003ff0:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003ff4:	46048493          	addi	s1,s1,1120
    80003ff8:	fd349ae3          	bne	s1,s3,80003fcc <binit+0x68>
  }
}
    80003ffc:	02813083          	ld	ra,40(sp)
    80004000:	02013403          	ld	s0,32(sp)
    80004004:	01813483          	ld	s1,24(sp)
    80004008:	01013903          	ld	s2,16(sp)
    8000400c:	00813983          	ld	s3,8(sp)
    80004010:	00013a03          	ld	s4,0(sp)
    80004014:	03010113          	addi	sp,sp,48
    80004018:	00008067          	ret

000000008000401c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000401c:	fd010113          	addi	sp,sp,-48
    80004020:	02113423          	sd	ra,40(sp)
    80004024:	02813023          	sd	s0,32(sp)
    80004028:	00913c23          	sd	s1,24(sp)
    8000402c:	01213823          	sd	s2,16(sp)
    80004030:	01313423          	sd	s3,8(sp)
    80004034:	03010413          	addi	s0,sp,48
    80004038:	00050913          	mv	s2,a0
    8000403c:	00058993          	mv	s3,a1
  acquire(&bcache.lock);
    80004040:	00015517          	auipc	a0,0x15
    80004044:	8b850513          	addi	a0,a0,-1864 # 800188f8 <bcache>
    80004048:	ffffd097          	auipc	ra,0xffffd
    8000404c:	f20080e7          	jalr	-224(ra) # 80000f68 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80004050:	0001d497          	auipc	s1,0x1d
    80004054:	c504b483          	ld	s1,-944(s1) # 80020ca0 <bcache+0x83a8>
    80004058:	0001d797          	auipc	a5,0x1d
    8000405c:	bf878793          	addi	a5,a5,-1032 # 80020c50 <bcache+0x8358>
    80004060:	04f48863          	beq	s1,a5,800040b0 <bread+0x94>
    80004064:	00078713          	mv	a4,a5
    80004068:	00c0006f          	j	80004074 <bread+0x58>
    8000406c:	0504b483          	ld	s1,80(s1)
    80004070:	04e48063          	beq	s1,a4,800040b0 <bread+0x94>
    if(b->dev == dev && b->blockno == blockno){
    80004074:	0044a783          	lw	a5,4(s1)
    80004078:	ff279ae3          	bne	a5,s2,8000406c <bread+0x50>
    8000407c:	0084a783          	lw	a5,8(s1)
    80004080:	ff3796e3          	bne	a5,s3,8000406c <bread+0x50>
      b->refcnt++;
    80004084:	0404a783          	lw	a5,64(s1)
    80004088:	0017879b          	addiw	a5,a5,1
    8000408c:	04f4a023          	sw	a5,64(s1)
      release(&bcache.lock);
    80004090:	00015517          	auipc	a0,0x15
    80004094:	86850513          	addi	a0,a0,-1944 # 800188f8 <bcache>
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	fc8080e7          	jalr	-56(ra) # 80001060 <release>
      acquiresleep(&b->lock);
    800040a0:	01048513          	addi	a0,s1,16
    800040a4:	00002097          	auipc	ra,0x2
    800040a8:	c24080e7          	jalr	-988(ra) # 80005cc8 <acquiresleep>
      return b;
    800040ac:	06c0006f          	j	80004118 <bread+0xfc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800040b0:	0001d497          	auipc	s1,0x1d
    800040b4:	be84b483          	ld	s1,-1048(s1) # 80020c98 <bcache+0x83a0>
    800040b8:	0001d797          	auipc	a5,0x1d
    800040bc:	b9878793          	addi	a5,a5,-1128 # 80020c50 <bcache+0x8358>
    800040c0:	00f48c63          	beq	s1,a5,800040d8 <bread+0xbc>
    800040c4:	00078713          	mv	a4,a5
    if(b->refcnt == 0) {
    800040c8:	0404a783          	lw	a5,64(s1)
    800040cc:	00078e63          	beqz	a5,800040e8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800040d0:	0484b483          	ld	s1,72(s1)
    800040d4:	fee49ae3          	bne	s1,a4,800040c8 <bread+0xac>
  panic("bget: no buffers");
    800040d8:	00006517          	auipc	a0,0x6
    800040dc:	42850513          	addi	a0,a0,1064 # 8000a500 <syscalls+0xc0>
    800040e0:	ffffc097          	auipc	ra,0xffffc
    800040e4:	5ec080e7          	jalr	1516(ra) # 800006cc <panic>
      b->dev = dev;
    800040e8:	0124a223          	sw	s2,4(s1)
      b->blockno = blockno;
    800040ec:	0134a423          	sw	s3,8(s1)
      b->flags = 0;
    800040f0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800040f4:	00100793          	li	a5,1
    800040f8:	04f4a023          	sw	a5,64(s1)
      release(&bcache.lock);
    800040fc:	00014517          	auipc	a0,0x14
    80004100:	7fc50513          	addi	a0,a0,2044 # 800188f8 <bcache>
    80004104:	ffffd097          	auipc	ra,0xffffd
    80004108:	f5c080e7          	jalr	-164(ra) # 80001060 <release>
      acquiresleep(&b->lock);
    8000410c:	01048513          	addi	a0,s1,16
    80004110:	00002097          	auipc	ra,0x2
    80004114:	bb8080e7          	jalr	-1096(ra) # 80005cc8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
    80004118:	0004a783          	lw	a5,0(s1)
    8000411c:	0027f793          	andi	a5,a5,2
    80004120:	02078263          	beqz	a5,80004144 <bread+0x128>
    ramdiskrw(b);
  }
  return b;
}
    80004124:	00048513          	mv	a0,s1
    80004128:	02813083          	ld	ra,40(sp)
    8000412c:	02013403          	ld	s0,32(sp)
    80004130:	01813483          	ld	s1,24(sp)
    80004134:	01013903          	ld	s2,16(sp)
    80004138:	00813983          	ld	s3,8(sp)
    8000413c:	03010113          	addi	sp,sp,48
    80004140:	00008067          	ret
    ramdiskrw(b);
    80004144:	00048513          	mv	a0,s1
    80004148:	00002097          	auipc	ra,0x2
    8000414c:	718080e7          	jalr	1816(ra) # 80006860 <ramdiskrw>
  return b;
    80004150:	fd5ff06f          	j	80004124 <bread+0x108>

0000000080004154 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80004154:	fe010113          	addi	sp,sp,-32
    80004158:	00113c23          	sd	ra,24(sp)
    8000415c:	00813823          	sd	s0,16(sp)
    80004160:	00913423          	sd	s1,8(sp)
    80004164:	02010413          	addi	s0,sp,32
    80004168:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000416c:	01050513          	addi	a0,a0,16
    80004170:	00002097          	auipc	ra,0x2
    80004174:	c44080e7          	jalr	-956(ra) # 80005db4 <holdingsleep>
    80004178:	02050863          	beqz	a0,800041a8 <bwrite+0x54>
    panic("bwrite");
  b->flags |= B_DIRTY;
    8000417c:	0004a783          	lw	a5,0(s1)
    80004180:	0047e793          	ori	a5,a5,4
    80004184:	00f4a023          	sw	a5,0(s1)
  ramdiskrw(b);
    80004188:	00048513          	mv	a0,s1
    8000418c:	00002097          	auipc	ra,0x2
    80004190:	6d4080e7          	jalr	1748(ra) # 80006860 <ramdiskrw>
}
    80004194:	01813083          	ld	ra,24(sp)
    80004198:	01013403          	ld	s0,16(sp)
    8000419c:	00813483          	ld	s1,8(sp)
    800041a0:	02010113          	addi	sp,sp,32
    800041a4:	00008067          	ret
    panic("bwrite");
    800041a8:	00006517          	auipc	a0,0x6
    800041ac:	37050513          	addi	a0,a0,880 # 8000a518 <syscalls+0xd8>
    800041b0:	ffffc097          	auipc	ra,0xffffc
    800041b4:	51c080e7          	jalr	1308(ra) # 800006cc <panic>

00000000800041b8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800041b8:	fe010113          	addi	sp,sp,-32
    800041bc:	00113c23          	sd	ra,24(sp)
    800041c0:	00813823          	sd	s0,16(sp)
    800041c4:	00913423          	sd	s1,8(sp)
    800041c8:	01213023          	sd	s2,0(sp)
    800041cc:	02010413          	addi	s0,sp,32
    800041d0:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800041d4:	01050913          	addi	s2,a0,16
    800041d8:	00090513          	mv	a0,s2
    800041dc:	00002097          	auipc	ra,0x2
    800041e0:	bd8080e7          	jalr	-1064(ra) # 80005db4 <holdingsleep>
    800041e4:	08050e63          	beqz	a0,80004280 <brelse+0xc8>
    panic("brelse");

  releasesleep(&b->lock);
    800041e8:	00090513          	mv	a0,s2
    800041ec:	00002097          	auipc	ra,0x2
    800041f0:	b64080e7          	jalr	-1180(ra) # 80005d50 <releasesleep>

  acquire(&bcache.lock);
    800041f4:	00014517          	auipc	a0,0x14
    800041f8:	70450513          	addi	a0,a0,1796 # 800188f8 <bcache>
    800041fc:	ffffd097          	auipc	ra,0xffffd
    80004200:	d6c080e7          	jalr	-660(ra) # 80000f68 <acquire>
  b->refcnt--;
    80004204:	0404a783          	lw	a5,64(s1)
    80004208:	fff7879b          	addiw	a5,a5,-1
    8000420c:	0007871b          	sext.w	a4,a5
    80004210:	04f4a023          	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80004214:	04071263          	bnez	a4,80004258 <brelse+0xa0>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80004218:	0504b783          	ld	a5,80(s1)
    8000421c:	0484b703          	ld	a4,72(s1)
    80004220:	04e7b423          	sd	a4,72(a5)
    b->prev->next = b->next;
    80004224:	0484b783          	ld	a5,72(s1)
    80004228:	0504b703          	ld	a4,80(s1)
    8000422c:	04e7b823          	sd	a4,80(a5)
    b->next = bcache.head.next;
    80004230:	0001c797          	auipc	a5,0x1c
    80004234:	6c878793          	addi	a5,a5,1736 # 800208f8 <bcache+0x8000>
    80004238:	3a87b703          	ld	a4,936(a5)
    8000423c:	04e4b823          	sd	a4,80(s1)
    b->prev = &bcache.head;
    80004240:	0001d717          	auipc	a4,0x1d
    80004244:	a1070713          	addi	a4,a4,-1520 # 80020c50 <bcache+0x8358>
    80004248:	04e4b423          	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000424c:	3a87b703          	ld	a4,936(a5)
    80004250:	04973423          	sd	s1,72(a4)
    bcache.head.next = b;
    80004254:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    80004258:	00014517          	auipc	a0,0x14
    8000425c:	6a050513          	addi	a0,a0,1696 # 800188f8 <bcache>
    80004260:	ffffd097          	auipc	ra,0xffffd
    80004264:	e00080e7          	jalr	-512(ra) # 80001060 <release>
}
    80004268:	01813083          	ld	ra,24(sp)
    8000426c:	01013403          	ld	s0,16(sp)
    80004270:	00813483          	ld	s1,8(sp)
    80004274:	00013903          	ld	s2,0(sp)
    80004278:	02010113          	addi	sp,sp,32
    8000427c:	00008067          	ret
    panic("brelse");
    80004280:	00006517          	auipc	a0,0x6
    80004284:	2a050513          	addi	a0,a0,672 # 8000a520 <syscalls+0xe0>
    80004288:	ffffc097          	auipc	ra,0xffffc
    8000428c:	444080e7          	jalr	1092(ra) # 800006cc <panic>

0000000080004290 <bpin>:

void
bpin(struct buf *b) {
    80004290:	fe010113          	addi	sp,sp,-32
    80004294:	00113c23          	sd	ra,24(sp)
    80004298:	00813823          	sd	s0,16(sp)
    8000429c:	00913423          	sd	s1,8(sp)
    800042a0:	02010413          	addi	s0,sp,32
    800042a4:	00050493          	mv	s1,a0
  acquire(&bcache.lock);
    800042a8:	00014517          	auipc	a0,0x14
    800042ac:	65050513          	addi	a0,a0,1616 # 800188f8 <bcache>
    800042b0:	ffffd097          	auipc	ra,0xffffd
    800042b4:	cb8080e7          	jalr	-840(ra) # 80000f68 <acquire>
  b->refcnt++;
    800042b8:	0404a783          	lw	a5,64(s1)
    800042bc:	0017879b          	addiw	a5,a5,1
    800042c0:	04f4a023          	sw	a5,64(s1)
  release(&bcache.lock);
    800042c4:	00014517          	auipc	a0,0x14
    800042c8:	63450513          	addi	a0,a0,1588 # 800188f8 <bcache>
    800042cc:	ffffd097          	auipc	ra,0xffffd
    800042d0:	d94080e7          	jalr	-620(ra) # 80001060 <release>
}
    800042d4:	01813083          	ld	ra,24(sp)
    800042d8:	01013403          	ld	s0,16(sp)
    800042dc:	00813483          	ld	s1,8(sp)
    800042e0:	02010113          	addi	sp,sp,32
    800042e4:	00008067          	ret

00000000800042e8 <bunpin>:

void
bunpin(struct buf *b) {
    800042e8:	fe010113          	addi	sp,sp,-32
    800042ec:	00113c23          	sd	ra,24(sp)
    800042f0:	00813823          	sd	s0,16(sp)
    800042f4:	00913423          	sd	s1,8(sp)
    800042f8:	02010413          	addi	s0,sp,32
    800042fc:	00050493          	mv	s1,a0
  acquire(&bcache.lock);
    80004300:	00014517          	auipc	a0,0x14
    80004304:	5f850513          	addi	a0,a0,1528 # 800188f8 <bcache>
    80004308:	ffffd097          	auipc	ra,0xffffd
    8000430c:	c60080e7          	jalr	-928(ra) # 80000f68 <acquire>
  b->refcnt--;
    80004310:	0404a783          	lw	a5,64(s1)
    80004314:	fff7879b          	addiw	a5,a5,-1
    80004318:	04f4a023          	sw	a5,64(s1)
  release(&bcache.lock);
    8000431c:	00014517          	auipc	a0,0x14
    80004320:	5dc50513          	addi	a0,a0,1500 # 800188f8 <bcache>
    80004324:	ffffd097          	auipc	ra,0xffffd
    80004328:	d3c080e7          	jalr	-708(ra) # 80001060 <release>
}
    8000432c:	01813083          	ld	ra,24(sp)
    80004330:	01013403          	ld	s0,16(sp)
    80004334:	00813483          	ld	s1,8(sp)
    80004338:	02010113          	addi	sp,sp,32
    8000433c:	00008067          	ret

0000000080004340 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80004340:	fe010113          	addi	sp,sp,-32
    80004344:	00113c23          	sd	ra,24(sp)
    80004348:	00813823          	sd	s0,16(sp)
    8000434c:	00913423          	sd	s1,8(sp)
    80004350:	01213023          	sd	s2,0(sp)
    80004354:	02010413          	addi	s0,sp,32
    80004358:	00058493          	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000435c:	00d5d59b          	srliw	a1,a1,0xd
    80004360:	0001d797          	auipc	a5,0x1d
    80004364:	d6c7a783          	lw	a5,-660(a5) # 800210cc <sb+0x1c>
    80004368:	00f585bb          	addw	a1,a1,a5
    8000436c:	00000097          	auipc	ra,0x0
    80004370:	cb0080e7          	jalr	-848(ra) # 8000401c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80004374:	0074f713          	andi	a4,s1,7
    80004378:	00100793          	li	a5,1
    8000437c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80004380:	03349493          	slli	s1,s1,0x33
    80004384:	0364d493          	srli	s1,s1,0x36
    80004388:	00950733          	add	a4,a0,s1
    8000438c:	06074703          	lbu	a4,96(a4)
    80004390:	00e7f6b3          	and	a3,a5,a4
    80004394:	04068263          	beqz	a3,800043d8 <bfree+0x98>
    80004398:	00050913          	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000439c:	009504b3          	add	s1,a0,s1
    800043a0:	fff7c793          	not	a5,a5
    800043a4:	00e7f7b3          	and	a5,a5,a4
    800043a8:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    800043ac:	00001097          	auipc	ra,0x1
    800043b0:	798080e7          	jalr	1944(ra) # 80005b44 <log_write>
  brelse(bp);
    800043b4:	00090513          	mv	a0,s2
    800043b8:	00000097          	auipc	ra,0x0
    800043bc:	e00080e7          	jalr	-512(ra) # 800041b8 <brelse>
}
    800043c0:	01813083          	ld	ra,24(sp)
    800043c4:	01013403          	ld	s0,16(sp)
    800043c8:	00813483          	ld	s1,8(sp)
    800043cc:	00013903          	ld	s2,0(sp)
    800043d0:	02010113          	addi	sp,sp,32
    800043d4:	00008067          	ret
    panic("freeing free block");
    800043d8:	00006517          	auipc	a0,0x6
    800043dc:	15050513          	addi	a0,a0,336 # 8000a528 <syscalls+0xe8>
    800043e0:	ffffc097          	auipc	ra,0xffffc
    800043e4:	2ec080e7          	jalr	748(ra) # 800006cc <panic>

00000000800043e8 <balloc>:
{
    800043e8:	fa010113          	addi	sp,sp,-96
    800043ec:	04113c23          	sd	ra,88(sp)
    800043f0:	04813823          	sd	s0,80(sp)
    800043f4:	04913423          	sd	s1,72(sp)
    800043f8:	05213023          	sd	s2,64(sp)
    800043fc:	03313c23          	sd	s3,56(sp)
    80004400:	03413823          	sd	s4,48(sp)
    80004404:	03513423          	sd	s5,40(sp)
    80004408:	03613023          	sd	s6,32(sp)
    8000440c:	01713c23          	sd	s7,24(sp)
    80004410:	01813823          	sd	s8,16(sp)
    80004414:	01913423          	sd	s9,8(sp)
    80004418:	06010413          	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000441c:	0001d797          	auipc	a5,0x1d
    80004420:	c987a783          	lw	a5,-872(a5) # 800210b4 <sb+0x4>
    80004424:	0a078c63          	beqz	a5,800044dc <balloc+0xf4>
    80004428:	00050b93          	mv	s7,a0
    8000442c:	00000a93          	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80004430:	0001db17          	auipc	s6,0x1d
    80004434:	c80b0b13          	addi	s6,s6,-896 # 800210b0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004438:	00000c13          	li	s8,0
      m = 1 << (bi % 8);
    8000443c:	00100993          	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004440:	00002a37          	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80004444:	00002cb7          	lui	s9,0x2
    80004448:	0200006f          	j	80004468 <balloc+0x80>
    brelse(bp);
    8000444c:	00090513          	mv	a0,s2
    80004450:	00000097          	auipc	ra,0x0
    80004454:	d68080e7          	jalr	-664(ra) # 800041b8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80004458:	015c87bb          	addw	a5,s9,s5
    8000445c:	00078a9b          	sext.w	s5,a5
    80004460:	004b2703          	lw	a4,4(s6)
    80004464:	06eafc63          	bgeu	s5,a4,800044dc <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    80004468:	41fad79b          	sraiw	a5,s5,0x1f
    8000446c:	0137d79b          	srliw	a5,a5,0x13
    80004470:	015787bb          	addw	a5,a5,s5
    80004474:	40d7d79b          	sraiw	a5,a5,0xd
    80004478:	01cb2583          	lw	a1,28(s6)
    8000447c:	00b785bb          	addw	a1,a5,a1
    80004480:	000b8513          	mv	a0,s7
    80004484:	00000097          	auipc	ra,0x0
    80004488:	b98080e7          	jalr	-1128(ra) # 8000401c <bread>
    8000448c:	00050913          	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004490:	004b2503          	lw	a0,4(s6)
    80004494:	000a849b          	sext.w	s1,s5
    80004498:	000c0613          	mv	a2,s8
    8000449c:	faa4f8e3          	bgeu	s1,a0,8000444c <balloc+0x64>
      m = 1 << (bi % 8);
    800044a0:	41f6579b          	sraiw	a5,a2,0x1f
    800044a4:	01d7d69b          	srliw	a3,a5,0x1d
    800044a8:	00c6873b          	addw	a4,a3,a2
    800044ac:	00777793          	andi	a5,a4,7
    800044b0:	40d787bb          	subw	a5,a5,a3
    800044b4:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800044b8:	4037571b          	sraiw	a4,a4,0x3
    800044bc:	00e906b3          	add	a3,s2,a4
    800044c0:	0606c683          	lbu	a3,96(a3)
    800044c4:	00d7f5b3          	and	a1,a5,a3
    800044c8:	02058263          	beqz	a1,800044ec <balloc+0x104>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800044cc:	0016061b          	addiw	a2,a2,1
    800044d0:	0014849b          	addiw	s1,s1,1
    800044d4:	fd4614e3          	bne	a2,s4,8000449c <balloc+0xb4>
    800044d8:	f75ff06f          	j	8000444c <balloc+0x64>
  panic("balloc: out of blocks");
    800044dc:	00006517          	auipc	a0,0x6
    800044e0:	06450513          	addi	a0,a0,100 # 8000a540 <syscalls+0x100>
    800044e4:	ffffc097          	auipc	ra,0xffffc
    800044e8:	1e8080e7          	jalr	488(ra) # 800006cc <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800044ec:	00e90733          	add	a4,s2,a4
    800044f0:	00f6e7b3          	or	a5,a3,a5
    800044f4:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    800044f8:	00090513          	mv	a0,s2
    800044fc:	00001097          	auipc	ra,0x1
    80004500:	648080e7          	jalr	1608(ra) # 80005b44 <log_write>
        brelse(bp);
    80004504:	00090513          	mv	a0,s2
    80004508:	00000097          	auipc	ra,0x0
    8000450c:	cb0080e7          	jalr	-848(ra) # 800041b8 <brelse>
  bp = bread(dev, bno);
    80004510:	00048593          	mv	a1,s1
    80004514:	000b8513          	mv	a0,s7
    80004518:	00000097          	auipc	ra,0x0
    8000451c:	b04080e7          	jalr	-1276(ra) # 8000401c <bread>
    80004520:	00050913          	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80004524:	40000613          	li	a2,1024
    80004528:	00000593          	li	a1,0
    8000452c:	06050513          	addi	a0,a0,96
    80004530:	ffffd097          	auipc	ra,0xffffd
    80004534:	b90080e7          	jalr	-1136(ra) # 800010c0 <memset>
  log_write(bp);
    80004538:	00090513          	mv	a0,s2
    8000453c:	00001097          	auipc	ra,0x1
    80004540:	608080e7          	jalr	1544(ra) # 80005b44 <log_write>
  brelse(bp);
    80004544:	00090513          	mv	a0,s2
    80004548:	00000097          	auipc	ra,0x0
    8000454c:	c70080e7          	jalr	-912(ra) # 800041b8 <brelse>
}
    80004550:	00048513          	mv	a0,s1
    80004554:	05813083          	ld	ra,88(sp)
    80004558:	05013403          	ld	s0,80(sp)
    8000455c:	04813483          	ld	s1,72(sp)
    80004560:	04013903          	ld	s2,64(sp)
    80004564:	03813983          	ld	s3,56(sp)
    80004568:	03013a03          	ld	s4,48(sp)
    8000456c:	02813a83          	ld	s5,40(sp)
    80004570:	02013b03          	ld	s6,32(sp)
    80004574:	01813b83          	ld	s7,24(sp)
    80004578:	01013c03          	ld	s8,16(sp)
    8000457c:	00813c83          	ld	s9,8(sp)
    80004580:	06010113          	addi	sp,sp,96
    80004584:	00008067          	ret

0000000080004588 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80004588:	fd010113          	addi	sp,sp,-48
    8000458c:	02113423          	sd	ra,40(sp)
    80004590:	02813023          	sd	s0,32(sp)
    80004594:	00913c23          	sd	s1,24(sp)
    80004598:	01213823          	sd	s2,16(sp)
    8000459c:	01313423          	sd	s3,8(sp)
    800045a0:	01413023          	sd	s4,0(sp)
    800045a4:	03010413          	addi	s0,sp,48
    800045a8:	00050913          	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800045ac:	00b00793          	li	a5,11
    800045b0:	06b7fa63          	bgeu	a5,a1,80004624 <bmap+0x9c>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800045b4:	ff45849b          	addiw	s1,a1,-12
    800045b8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800045bc:	0ff00793          	li	a5,255
    800045c0:	0ce7e663          	bltu	a5,a4,8000468c <bmap+0x104>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800045c4:	08052583          	lw	a1,128(a0)
    800045c8:	08058463          	beqz	a1,80004650 <bmap+0xc8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800045cc:	00092503          	lw	a0,0(s2)
    800045d0:	00000097          	auipc	ra,0x0
    800045d4:	a4c080e7          	jalr	-1460(ra) # 8000401c <bread>
    800045d8:	00050a13          	mv	s4,a0
    a = (uint*)bp->data;
    800045dc:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    800045e0:	02049713          	slli	a4,s1,0x20
    800045e4:	01e75593          	srli	a1,a4,0x1e
    800045e8:	00b784b3          	add	s1,a5,a1
    800045ec:	0004a983          	lw	s3,0(s1)
    800045f0:	06098c63          	beqz	s3,80004668 <bmap+0xe0>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800045f4:	000a0513          	mv	a0,s4
    800045f8:	00000097          	auipc	ra,0x0
    800045fc:	bc0080e7          	jalr	-1088(ra) # 800041b8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80004600:	00098513          	mv	a0,s3
    80004604:	02813083          	ld	ra,40(sp)
    80004608:	02013403          	ld	s0,32(sp)
    8000460c:	01813483          	ld	s1,24(sp)
    80004610:	01013903          	ld	s2,16(sp)
    80004614:	00813983          	ld	s3,8(sp)
    80004618:	00013a03          	ld	s4,0(sp)
    8000461c:	03010113          	addi	sp,sp,48
    80004620:	00008067          	ret
    if((addr = ip->addrs[bn]) == 0)
    80004624:	02059793          	slli	a5,a1,0x20
    80004628:	01e7d593          	srli	a1,a5,0x1e
    8000462c:	00b504b3          	add	s1,a0,a1
    80004630:	0504a983          	lw	s3,80(s1)
    80004634:	fc0996e3          	bnez	s3,80004600 <bmap+0x78>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80004638:	00052503          	lw	a0,0(a0)
    8000463c:	00000097          	auipc	ra,0x0
    80004640:	dac080e7          	jalr	-596(ra) # 800043e8 <balloc>
    80004644:	0005099b          	sext.w	s3,a0
    80004648:	0534a823          	sw	s3,80(s1)
    8000464c:	fb5ff06f          	j	80004600 <bmap+0x78>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80004650:	00052503          	lw	a0,0(a0)
    80004654:	00000097          	auipc	ra,0x0
    80004658:	d94080e7          	jalr	-620(ra) # 800043e8 <balloc>
    8000465c:	0005059b          	sext.w	a1,a0
    80004660:	08b92023          	sw	a1,128(s2)
    80004664:	f69ff06f          	j	800045cc <bmap+0x44>
      a[bn] = addr = balloc(ip->dev);
    80004668:	00092503          	lw	a0,0(s2)
    8000466c:	00000097          	auipc	ra,0x0
    80004670:	d7c080e7          	jalr	-644(ra) # 800043e8 <balloc>
    80004674:	0005099b          	sext.w	s3,a0
    80004678:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000467c:	000a0513          	mv	a0,s4
    80004680:	00001097          	auipc	ra,0x1
    80004684:	4c4080e7          	jalr	1220(ra) # 80005b44 <log_write>
    80004688:	f6dff06f          	j	800045f4 <bmap+0x6c>
  panic("bmap: out of range");
    8000468c:	00006517          	auipc	a0,0x6
    80004690:	ecc50513          	addi	a0,a0,-308 # 8000a558 <syscalls+0x118>
    80004694:	ffffc097          	auipc	ra,0xffffc
    80004698:	038080e7          	jalr	56(ra) # 800006cc <panic>

000000008000469c <iget>:
{
    8000469c:	fd010113          	addi	sp,sp,-48
    800046a0:	02113423          	sd	ra,40(sp)
    800046a4:	02813023          	sd	s0,32(sp)
    800046a8:	00913c23          	sd	s1,24(sp)
    800046ac:	01213823          	sd	s2,16(sp)
    800046b0:	01313423          	sd	s3,8(sp)
    800046b4:	01413023          	sd	s4,0(sp)
    800046b8:	03010413          	addi	s0,sp,48
    800046bc:	00050993          	mv	s3,a0
    800046c0:	00058a13          	mv	s4,a1
  acquire(&itable.lock);
    800046c4:	0001d517          	auipc	a0,0x1d
    800046c8:	a0c50513          	addi	a0,a0,-1524 # 800210d0 <itable>
    800046cc:	ffffd097          	auipc	ra,0xffffd
    800046d0:	89c080e7          	jalr	-1892(ra) # 80000f68 <acquire>
  empty = 0;
    800046d4:	00000913          	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800046d8:	0001d497          	auipc	s1,0x1d
    800046dc:	a1048493          	addi	s1,s1,-1520 # 800210e8 <itable+0x18>
    800046e0:	0001e697          	auipc	a3,0x1e
    800046e4:	49868693          	addi	a3,a3,1176 # 80022b78 <log>
    800046e8:	0100006f          	j	800046f8 <iget+0x5c>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800046ec:	04090263          	beqz	s2,80004730 <iget+0x94>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800046f0:	08848493          	addi	s1,s1,136
    800046f4:	04d48463          	beq	s1,a3,8000473c <iget+0xa0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800046f8:	0084a783          	lw	a5,8(s1)
    800046fc:	fef058e3          	blez	a5,800046ec <iget+0x50>
    80004700:	0004a703          	lw	a4,0(s1)
    80004704:	ff3714e3          	bne	a4,s3,800046ec <iget+0x50>
    80004708:	0044a703          	lw	a4,4(s1)
    8000470c:	ff4710e3          	bne	a4,s4,800046ec <iget+0x50>
      ip->ref++;
    80004710:	0017879b          	addiw	a5,a5,1
    80004714:	00f4a423          	sw	a5,8(s1)
      release(&itable.lock);
    80004718:	0001d517          	auipc	a0,0x1d
    8000471c:	9b850513          	addi	a0,a0,-1608 # 800210d0 <itable>
    80004720:	ffffd097          	auipc	ra,0xffffd
    80004724:	940080e7          	jalr	-1728(ra) # 80001060 <release>
      return ip;
    80004728:	00048913          	mv	s2,s1
    8000472c:	0380006f          	j	80004764 <iget+0xc8>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004730:	fc0790e3          	bnez	a5,800046f0 <iget+0x54>
    80004734:	00048913          	mv	s2,s1
    80004738:	fb9ff06f          	j	800046f0 <iget+0x54>
  if(empty == 0)
    8000473c:	04090663          	beqz	s2,80004788 <iget+0xec>
  ip->dev = dev;
    80004740:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80004744:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80004748:	00100793          	li	a5,1
    8000474c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80004750:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80004754:	0001d517          	auipc	a0,0x1d
    80004758:	97c50513          	addi	a0,a0,-1668 # 800210d0 <itable>
    8000475c:	ffffd097          	auipc	ra,0xffffd
    80004760:	904080e7          	jalr	-1788(ra) # 80001060 <release>
}
    80004764:	00090513          	mv	a0,s2
    80004768:	02813083          	ld	ra,40(sp)
    8000476c:	02013403          	ld	s0,32(sp)
    80004770:	01813483          	ld	s1,24(sp)
    80004774:	01013903          	ld	s2,16(sp)
    80004778:	00813983          	ld	s3,8(sp)
    8000477c:	00013a03          	ld	s4,0(sp)
    80004780:	03010113          	addi	sp,sp,48
    80004784:	00008067          	ret
    panic("iget: no inodes");
    80004788:	00006517          	auipc	a0,0x6
    8000478c:	de850513          	addi	a0,a0,-536 # 8000a570 <syscalls+0x130>
    80004790:	ffffc097          	auipc	ra,0xffffc
    80004794:	f3c080e7          	jalr	-196(ra) # 800006cc <panic>

0000000080004798 <fsinit>:
fsinit(int dev) {
    80004798:	fd010113          	addi	sp,sp,-48
    8000479c:	02113423          	sd	ra,40(sp)
    800047a0:	02813023          	sd	s0,32(sp)
    800047a4:	00913c23          	sd	s1,24(sp)
    800047a8:	01213823          	sd	s2,16(sp)
    800047ac:	01313423          	sd	s3,8(sp)
    800047b0:	03010413          	addi	s0,sp,48
    800047b4:	00050913          	mv	s2,a0
  bp = bread(dev, 1);
    800047b8:	00100593          	li	a1,1
    800047bc:	00000097          	auipc	ra,0x0
    800047c0:	860080e7          	jalr	-1952(ra) # 8000401c <bread>
    800047c4:	00050493          	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800047c8:	0001d997          	auipc	s3,0x1d
    800047cc:	8e898993          	addi	s3,s3,-1816 # 800210b0 <sb>
    800047d0:	02000613          	li	a2,32
    800047d4:	06050593          	addi	a1,a0,96
    800047d8:	00098513          	mv	a0,s3
    800047dc:	ffffd097          	auipc	ra,0xffffd
    800047e0:	978080e7          	jalr	-1672(ra) # 80001154 <memmove>
  brelse(bp);
    800047e4:	00048513          	mv	a0,s1
    800047e8:	00000097          	auipc	ra,0x0
    800047ec:	9d0080e7          	jalr	-1584(ra) # 800041b8 <brelse>
  if(sb.magic != FSMAGIC)
    800047f0:	0009a703          	lw	a4,0(s3)
    800047f4:	102037b7          	lui	a5,0x10203
    800047f8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800047fc:	02f71a63          	bne	a4,a5,80004830 <fsinit+0x98>
  initlog(dev, &sb);
    80004800:	0001d597          	auipc	a1,0x1d
    80004804:	8b058593          	addi	a1,a1,-1872 # 800210b0 <sb>
    80004808:	00090513          	mv	a0,s2
    8000480c:	00001097          	auipc	ra,0x1
    80004810:	ff4080e7          	jalr	-12(ra) # 80005800 <initlog>
}
    80004814:	02813083          	ld	ra,40(sp)
    80004818:	02013403          	ld	s0,32(sp)
    8000481c:	01813483          	ld	s1,24(sp)
    80004820:	01013903          	ld	s2,16(sp)
    80004824:	00813983          	ld	s3,8(sp)
    80004828:	03010113          	addi	sp,sp,48
    8000482c:	00008067          	ret
    panic("invalid file system");
    80004830:	00006517          	auipc	a0,0x6
    80004834:	d5050513          	addi	a0,a0,-688 # 8000a580 <syscalls+0x140>
    80004838:	ffffc097          	auipc	ra,0xffffc
    8000483c:	e94080e7          	jalr	-364(ra) # 800006cc <panic>

0000000080004840 <iinit>:
{
    80004840:	fd010113          	addi	sp,sp,-48
    80004844:	02113423          	sd	ra,40(sp)
    80004848:	02813023          	sd	s0,32(sp)
    8000484c:	00913c23          	sd	s1,24(sp)
    80004850:	01213823          	sd	s2,16(sp)
    80004854:	01313423          	sd	s3,8(sp)
    80004858:	03010413          	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000485c:	00006597          	auipc	a1,0x6
    80004860:	d3c58593          	addi	a1,a1,-708 # 8000a598 <syscalls+0x158>
    80004864:	0001d517          	auipc	a0,0x1d
    80004868:	86c50513          	addi	a0,a0,-1940 # 800210d0 <itable>
    8000486c:	ffffc097          	auipc	ra,0xffffc
    80004870:	618080e7          	jalr	1560(ra) # 80000e84 <initlock>
  for(i = 0; i < NINODE; i++) {
    80004874:	0001d497          	auipc	s1,0x1d
    80004878:	88448493          	addi	s1,s1,-1916 # 800210f8 <itable+0x28>
    8000487c:	0001e997          	auipc	s3,0x1e
    80004880:	30c98993          	addi	s3,s3,780 # 80022b88 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80004884:	00006917          	auipc	s2,0x6
    80004888:	d1c90913          	addi	s2,s2,-740 # 8000a5a0 <syscalls+0x160>
    8000488c:	00090593          	mv	a1,s2
    80004890:	00048513          	mv	a0,s1
    80004894:	00001097          	auipc	ra,0x1
    80004898:	3dc080e7          	jalr	988(ra) # 80005c70 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000489c:	08848493          	addi	s1,s1,136
    800048a0:	ff3496e3          	bne	s1,s3,8000488c <iinit+0x4c>
}
    800048a4:	02813083          	ld	ra,40(sp)
    800048a8:	02013403          	ld	s0,32(sp)
    800048ac:	01813483          	ld	s1,24(sp)
    800048b0:	01013903          	ld	s2,16(sp)
    800048b4:	00813983          	ld	s3,8(sp)
    800048b8:	03010113          	addi	sp,sp,48
    800048bc:	00008067          	ret

00000000800048c0 <ialloc>:
{
    800048c0:	fb010113          	addi	sp,sp,-80
    800048c4:	04113423          	sd	ra,72(sp)
    800048c8:	04813023          	sd	s0,64(sp)
    800048cc:	02913c23          	sd	s1,56(sp)
    800048d0:	03213823          	sd	s2,48(sp)
    800048d4:	03313423          	sd	s3,40(sp)
    800048d8:	03413023          	sd	s4,32(sp)
    800048dc:	01513c23          	sd	s5,24(sp)
    800048e0:	01613823          	sd	s6,16(sp)
    800048e4:	01713423          	sd	s7,8(sp)
    800048e8:	05010413          	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800048ec:	0001c717          	auipc	a4,0x1c
    800048f0:	7d072703          	lw	a4,2000(a4) # 800210bc <sb+0xc>
    800048f4:	00100793          	li	a5,1
    800048f8:	06e7f463          	bgeu	a5,a4,80004960 <ialloc+0xa0>
    800048fc:	00050a93          	mv	s5,a0
    80004900:	00058b93          	mv	s7,a1
    80004904:	00100493          	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80004908:	0001ca17          	auipc	s4,0x1c
    8000490c:	7a8a0a13          	addi	s4,s4,1960 # 800210b0 <sb>
    80004910:	00048b1b          	sext.w	s6,s1
    80004914:	0044d793          	srli	a5,s1,0x4
    80004918:	018a2583          	lw	a1,24(s4)
    8000491c:	00f585bb          	addw	a1,a1,a5
    80004920:	000a8513          	mv	a0,s5
    80004924:	fffff097          	auipc	ra,0xfffff
    80004928:	6f8080e7          	jalr	1784(ra) # 8000401c <bread>
    8000492c:	00050913          	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80004930:	06050993          	addi	s3,a0,96
    80004934:	00f4f793          	andi	a5,s1,15
    80004938:	00679793          	slli	a5,a5,0x6
    8000493c:	00f989b3          	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80004940:	00099783          	lh	a5,0(s3)
    80004944:	02078663          	beqz	a5,80004970 <ialloc+0xb0>
    brelse(bp);
    80004948:	00000097          	auipc	ra,0x0
    8000494c:	870080e7          	jalr	-1936(ra) # 800041b8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004950:	00148493          	addi	s1,s1,1
    80004954:	00ca2703          	lw	a4,12(s4)
    80004958:	0004879b          	sext.w	a5,s1
    8000495c:	fae7eae3          	bltu	a5,a4,80004910 <ialloc+0x50>
  panic("ialloc: no inodes");
    80004960:	00006517          	auipc	a0,0x6
    80004964:	c4850513          	addi	a0,a0,-952 # 8000a5a8 <syscalls+0x168>
    80004968:	ffffc097          	auipc	ra,0xffffc
    8000496c:	d64080e7          	jalr	-668(ra) # 800006cc <panic>
      memset(dip, 0, sizeof(*dip));
    80004970:	04000613          	li	a2,64
    80004974:	00000593          	li	a1,0
    80004978:	00098513          	mv	a0,s3
    8000497c:	ffffc097          	auipc	ra,0xffffc
    80004980:	744080e7          	jalr	1860(ra) # 800010c0 <memset>
      dip->type = type;
    80004984:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80004988:	00090513          	mv	a0,s2
    8000498c:	00001097          	auipc	ra,0x1
    80004990:	1b8080e7          	jalr	440(ra) # 80005b44 <log_write>
      brelse(bp);
    80004994:	00090513          	mv	a0,s2
    80004998:	00000097          	auipc	ra,0x0
    8000499c:	820080e7          	jalr	-2016(ra) # 800041b8 <brelse>
      return iget(dev, inum);
    800049a0:	000b0593          	mv	a1,s6
    800049a4:	000a8513          	mv	a0,s5
    800049a8:	00000097          	auipc	ra,0x0
    800049ac:	cf4080e7          	jalr	-780(ra) # 8000469c <iget>
}
    800049b0:	04813083          	ld	ra,72(sp)
    800049b4:	04013403          	ld	s0,64(sp)
    800049b8:	03813483          	ld	s1,56(sp)
    800049bc:	03013903          	ld	s2,48(sp)
    800049c0:	02813983          	ld	s3,40(sp)
    800049c4:	02013a03          	ld	s4,32(sp)
    800049c8:	01813a83          	ld	s5,24(sp)
    800049cc:	01013b03          	ld	s6,16(sp)
    800049d0:	00813b83          	ld	s7,8(sp)
    800049d4:	05010113          	addi	sp,sp,80
    800049d8:	00008067          	ret

00000000800049dc <iupdate>:
{
    800049dc:	fe010113          	addi	sp,sp,-32
    800049e0:	00113c23          	sd	ra,24(sp)
    800049e4:	00813823          	sd	s0,16(sp)
    800049e8:	00913423          	sd	s1,8(sp)
    800049ec:	01213023          	sd	s2,0(sp)
    800049f0:	02010413          	addi	s0,sp,32
    800049f4:	00050493          	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800049f8:	00452783          	lw	a5,4(a0)
    800049fc:	0047d79b          	srliw	a5,a5,0x4
    80004a00:	0001c597          	auipc	a1,0x1c
    80004a04:	6c85a583          	lw	a1,1736(a1) # 800210c8 <sb+0x18>
    80004a08:	00b785bb          	addw	a1,a5,a1
    80004a0c:	00052503          	lw	a0,0(a0)
    80004a10:	fffff097          	auipc	ra,0xfffff
    80004a14:	60c080e7          	jalr	1548(ra) # 8000401c <bread>
    80004a18:	00050913          	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004a1c:	06050793          	addi	a5,a0,96
    80004a20:	0044a503          	lw	a0,4(s1)
    80004a24:	00f57513          	andi	a0,a0,15
    80004a28:	00651513          	slli	a0,a0,0x6
    80004a2c:	00a78533          	add	a0,a5,a0
  dip->type = ip->type;
    80004a30:	04449703          	lh	a4,68(s1)
    80004a34:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80004a38:	04649703          	lh	a4,70(s1)
    80004a3c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80004a40:	04849703          	lh	a4,72(s1)
    80004a44:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80004a48:	04a49703          	lh	a4,74(s1)
    80004a4c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80004a50:	04c4a703          	lw	a4,76(s1)
    80004a54:	00e52423          	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004a58:	03400613          	li	a2,52
    80004a5c:	05048593          	addi	a1,s1,80
    80004a60:	00c50513          	addi	a0,a0,12
    80004a64:	ffffc097          	auipc	ra,0xffffc
    80004a68:	6f0080e7          	jalr	1776(ra) # 80001154 <memmove>
  log_write(bp);
    80004a6c:	00090513          	mv	a0,s2
    80004a70:	00001097          	auipc	ra,0x1
    80004a74:	0d4080e7          	jalr	212(ra) # 80005b44 <log_write>
  brelse(bp);
    80004a78:	00090513          	mv	a0,s2
    80004a7c:	fffff097          	auipc	ra,0xfffff
    80004a80:	73c080e7          	jalr	1852(ra) # 800041b8 <brelse>
}
    80004a84:	01813083          	ld	ra,24(sp)
    80004a88:	01013403          	ld	s0,16(sp)
    80004a8c:	00813483          	ld	s1,8(sp)
    80004a90:	00013903          	ld	s2,0(sp)
    80004a94:	02010113          	addi	sp,sp,32
    80004a98:	00008067          	ret

0000000080004a9c <idup>:
{
    80004a9c:	fe010113          	addi	sp,sp,-32
    80004aa0:	00113c23          	sd	ra,24(sp)
    80004aa4:	00813823          	sd	s0,16(sp)
    80004aa8:	00913423          	sd	s1,8(sp)
    80004aac:	02010413          	addi	s0,sp,32
    80004ab0:	00050493          	mv	s1,a0
  acquire(&itable.lock);
    80004ab4:	0001c517          	auipc	a0,0x1c
    80004ab8:	61c50513          	addi	a0,a0,1564 # 800210d0 <itable>
    80004abc:	ffffc097          	auipc	ra,0xffffc
    80004ac0:	4ac080e7          	jalr	1196(ra) # 80000f68 <acquire>
  ip->ref++;
    80004ac4:	0084a783          	lw	a5,8(s1)
    80004ac8:	0017879b          	addiw	a5,a5,1
    80004acc:	00f4a423          	sw	a5,8(s1)
  release(&itable.lock);
    80004ad0:	0001c517          	auipc	a0,0x1c
    80004ad4:	60050513          	addi	a0,a0,1536 # 800210d0 <itable>
    80004ad8:	ffffc097          	auipc	ra,0xffffc
    80004adc:	588080e7          	jalr	1416(ra) # 80001060 <release>
}
    80004ae0:	00048513          	mv	a0,s1
    80004ae4:	01813083          	ld	ra,24(sp)
    80004ae8:	01013403          	ld	s0,16(sp)
    80004aec:	00813483          	ld	s1,8(sp)
    80004af0:	02010113          	addi	sp,sp,32
    80004af4:	00008067          	ret

0000000080004af8 <ilock>:
{
    80004af8:	fe010113          	addi	sp,sp,-32
    80004afc:	00113c23          	sd	ra,24(sp)
    80004b00:	00813823          	sd	s0,16(sp)
    80004b04:	00913423          	sd	s1,8(sp)
    80004b08:	01213023          	sd	s2,0(sp)
    80004b0c:	02010413          	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80004b10:	02050e63          	beqz	a0,80004b4c <ilock+0x54>
    80004b14:	00050493          	mv	s1,a0
    80004b18:	00852783          	lw	a5,8(a0)
    80004b1c:	02f05863          	blez	a5,80004b4c <ilock+0x54>
  acquiresleep(&ip->lock);
    80004b20:	01050513          	addi	a0,a0,16
    80004b24:	00001097          	auipc	ra,0x1
    80004b28:	1a4080e7          	jalr	420(ra) # 80005cc8 <acquiresleep>
  if(ip->valid == 0){
    80004b2c:	0404a783          	lw	a5,64(s1)
    80004b30:	02078663          	beqz	a5,80004b5c <ilock+0x64>
}
    80004b34:	01813083          	ld	ra,24(sp)
    80004b38:	01013403          	ld	s0,16(sp)
    80004b3c:	00813483          	ld	s1,8(sp)
    80004b40:	00013903          	ld	s2,0(sp)
    80004b44:	02010113          	addi	sp,sp,32
    80004b48:	00008067          	ret
    panic("ilock");
    80004b4c:	00006517          	auipc	a0,0x6
    80004b50:	a7450513          	addi	a0,a0,-1420 # 8000a5c0 <syscalls+0x180>
    80004b54:	ffffc097          	auipc	ra,0xffffc
    80004b58:	b78080e7          	jalr	-1160(ra) # 800006cc <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004b5c:	0044a783          	lw	a5,4(s1)
    80004b60:	0047d79b          	srliw	a5,a5,0x4
    80004b64:	0001c597          	auipc	a1,0x1c
    80004b68:	5645a583          	lw	a1,1380(a1) # 800210c8 <sb+0x18>
    80004b6c:	00b785bb          	addw	a1,a5,a1
    80004b70:	0004a503          	lw	a0,0(s1)
    80004b74:	fffff097          	auipc	ra,0xfffff
    80004b78:	4a8080e7          	jalr	1192(ra) # 8000401c <bread>
    80004b7c:	00050913          	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004b80:	06050593          	addi	a1,a0,96
    80004b84:	0044a783          	lw	a5,4(s1)
    80004b88:	00f7f793          	andi	a5,a5,15
    80004b8c:	00679793          	slli	a5,a5,0x6
    80004b90:	00f585b3          	add	a1,a1,a5
    ip->type = dip->type;
    80004b94:	00059783          	lh	a5,0(a1)
    80004b98:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80004b9c:	00259783          	lh	a5,2(a1)
    80004ba0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80004ba4:	00459783          	lh	a5,4(a1)
    80004ba8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80004bac:	00659783          	lh	a5,6(a1)
    80004bb0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004bb4:	0085a783          	lw	a5,8(a1)
    80004bb8:	04f4a623          	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004bbc:	03400613          	li	a2,52
    80004bc0:	00c58593          	addi	a1,a1,12
    80004bc4:	05048513          	addi	a0,s1,80
    80004bc8:	ffffc097          	auipc	ra,0xffffc
    80004bcc:	58c080e7          	jalr	1420(ra) # 80001154 <memmove>
    brelse(bp);
    80004bd0:	00090513          	mv	a0,s2
    80004bd4:	fffff097          	auipc	ra,0xfffff
    80004bd8:	5e4080e7          	jalr	1508(ra) # 800041b8 <brelse>
    ip->valid = 1;
    80004bdc:	00100793          	li	a5,1
    80004be0:	04f4a023          	sw	a5,64(s1)
    if(ip->type == 0)
    80004be4:	04449783          	lh	a5,68(s1)
    80004be8:	f40796e3          	bnez	a5,80004b34 <ilock+0x3c>
      panic("ilock: no type");
    80004bec:	00006517          	auipc	a0,0x6
    80004bf0:	9dc50513          	addi	a0,a0,-1572 # 8000a5c8 <syscalls+0x188>
    80004bf4:	ffffc097          	auipc	ra,0xffffc
    80004bf8:	ad8080e7          	jalr	-1320(ra) # 800006cc <panic>

0000000080004bfc <iunlock>:
{
    80004bfc:	fe010113          	addi	sp,sp,-32
    80004c00:	00113c23          	sd	ra,24(sp)
    80004c04:	00813823          	sd	s0,16(sp)
    80004c08:	00913423          	sd	s1,8(sp)
    80004c0c:	01213023          	sd	s2,0(sp)
    80004c10:	02010413          	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004c14:	04050463          	beqz	a0,80004c5c <iunlock+0x60>
    80004c18:	00050493          	mv	s1,a0
    80004c1c:	01050913          	addi	s2,a0,16
    80004c20:	00090513          	mv	a0,s2
    80004c24:	00001097          	auipc	ra,0x1
    80004c28:	190080e7          	jalr	400(ra) # 80005db4 <holdingsleep>
    80004c2c:	02050863          	beqz	a0,80004c5c <iunlock+0x60>
    80004c30:	0084a783          	lw	a5,8(s1)
    80004c34:	02f05463          	blez	a5,80004c5c <iunlock+0x60>
  releasesleep(&ip->lock);
    80004c38:	00090513          	mv	a0,s2
    80004c3c:	00001097          	auipc	ra,0x1
    80004c40:	114080e7          	jalr	276(ra) # 80005d50 <releasesleep>
}
    80004c44:	01813083          	ld	ra,24(sp)
    80004c48:	01013403          	ld	s0,16(sp)
    80004c4c:	00813483          	ld	s1,8(sp)
    80004c50:	00013903          	ld	s2,0(sp)
    80004c54:	02010113          	addi	sp,sp,32
    80004c58:	00008067          	ret
    panic("iunlock");
    80004c5c:	00006517          	auipc	a0,0x6
    80004c60:	97c50513          	addi	a0,a0,-1668 # 8000a5d8 <syscalls+0x198>
    80004c64:	ffffc097          	auipc	ra,0xffffc
    80004c68:	a68080e7          	jalr	-1432(ra) # 800006cc <panic>

0000000080004c6c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004c6c:	fd010113          	addi	sp,sp,-48
    80004c70:	02113423          	sd	ra,40(sp)
    80004c74:	02813023          	sd	s0,32(sp)
    80004c78:	00913c23          	sd	s1,24(sp)
    80004c7c:	01213823          	sd	s2,16(sp)
    80004c80:	01313423          	sd	s3,8(sp)
    80004c84:	01413023          	sd	s4,0(sp)
    80004c88:	03010413          	addi	s0,sp,48
    80004c8c:	00050993          	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004c90:	05050493          	addi	s1,a0,80
    80004c94:	08050913          	addi	s2,a0,128
    80004c98:	00c0006f          	j	80004ca4 <itrunc+0x38>
    80004c9c:	00448493          	addi	s1,s1,4
    80004ca0:	03248063          	beq	s1,s2,80004cc0 <itrunc+0x54>
    if(ip->addrs[i]){
    80004ca4:	0004a583          	lw	a1,0(s1)
    80004ca8:	fe058ae3          	beqz	a1,80004c9c <itrunc+0x30>
      bfree(ip->dev, ip->addrs[i]);
    80004cac:	0009a503          	lw	a0,0(s3)
    80004cb0:	fffff097          	auipc	ra,0xfffff
    80004cb4:	690080e7          	jalr	1680(ra) # 80004340 <bfree>
      ip->addrs[i] = 0;
    80004cb8:	0004a023          	sw	zero,0(s1)
    80004cbc:	fe1ff06f          	j	80004c9c <itrunc+0x30>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004cc0:	0809a583          	lw	a1,128(s3)
    80004cc4:	02059a63          	bnez	a1,80004cf8 <itrunc+0x8c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004cc8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004ccc:	00098513          	mv	a0,s3
    80004cd0:	00000097          	auipc	ra,0x0
    80004cd4:	d0c080e7          	jalr	-756(ra) # 800049dc <iupdate>
}
    80004cd8:	02813083          	ld	ra,40(sp)
    80004cdc:	02013403          	ld	s0,32(sp)
    80004ce0:	01813483          	ld	s1,24(sp)
    80004ce4:	01013903          	ld	s2,16(sp)
    80004ce8:	00813983          	ld	s3,8(sp)
    80004cec:	00013a03          	ld	s4,0(sp)
    80004cf0:	03010113          	addi	sp,sp,48
    80004cf4:	00008067          	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004cf8:	0009a503          	lw	a0,0(s3)
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	320080e7          	jalr	800(ra) # 8000401c <bread>
    80004d04:	00050a13          	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004d08:	06050493          	addi	s1,a0,96
    80004d0c:	46050913          	addi	s2,a0,1120
    80004d10:	00c0006f          	j	80004d1c <itrunc+0xb0>
    80004d14:	00448493          	addi	s1,s1,4
    80004d18:	01248e63          	beq	s1,s2,80004d34 <itrunc+0xc8>
      if(a[j])
    80004d1c:	0004a583          	lw	a1,0(s1)
    80004d20:	fe058ae3          	beqz	a1,80004d14 <itrunc+0xa8>
        bfree(ip->dev, a[j]);
    80004d24:	0009a503          	lw	a0,0(s3)
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	618080e7          	jalr	1560(ra) # 80004340 <bfree>
    80004d30:	fe5ff06f          	j	80004d14 <itrunc+0xa8>
    brelse(bp);
    80004d34:	000a0513          	mv	a0,s4
    80004d38:	fffff097          	auipc	ra,0xfffff
    80004d3c:	480080e7          	jalr	1152(ra) # 800041b8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004d40:	0809a583          	lw	a1,128(s3)
    80004d44:	0009a503          	lw	a0,0(s3)
    80004d48:	fffff097          	auipc	ra,0xfffff
    80004d4c:	5f8080e7          	jalr	1528(ra) # 80004340 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004d50:	0809a023          	sw	zero,128(s3)
    80004d54:	f75ff06f          	j	80004cc8 <itrunc+0x5c>

0000000080004d58 <iput>:
{
    80004d58:	fe010113          	addi	sp,sp,-32
    80004d5c:	00113c23          	sd	ra,24(sp)
    80004d60:	00813823          	sd	s0,16(sp)
    80004d64:	00913423          	sd	s1,8(sp)
    80004d68:	01213023          	sd	s2,0(sp)
    80004d6c:	02010413          	addi	s0,sp,32
    80004d70:	00050493          	mv	s1,a0
  acquire(&itable.lock);
    80004d74:	0001c517          	auipc	a0,0x1c
    80004d78:	35c50513          	addi	a0,a0,860 # 800210d0 <itable>
    80004d7c:	ffffc097          	auipc	ra,0xffffc
    80004d80:	1ec080e7          	jalr	492(ra) # 80000f68 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004d84:	0084a703          	lw	a4,8(s1)
    80004d88:	00100793          	li	a5,1
    80004d8c:	02f70c63          	beq	a4,a5,80004dc4 <iput+0x6c>
  ip->ref--;
    80004d90:	0084a783          	lw	a5,8(s1)
    80004d94:	fff7879b          	addiw	a5,a5,-1
    80004d98:	00f4a423          	sw	a5,8(s1)
  release(&itable.lock);
    80004d9c:	0001c517          	auipc	a0,0x1c
    80004da0:	33450513          	addi	a0,a0,820 # 800210d0 <itable>
    80004da4:	ffffc097          	auipc	ra,0xffffc
    80004da8:	2bc080e7          	jalr	700(ra) # 80001060 <release>
}
    80004dac:	01813083          	ld	ra,24(sp)
    80004db0:	01013403          	ld	s0,16(sp)
    80004db4:	00813483          	ld	s1,8(sp)
    80004db8:	00013903          	ld	s2,0(sp)
    80004dbc:	02010113          	addi	sp,sp,32
    80004dc0:	00008067          	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004dc4:	0404a783          	lw	a5,64(s1)
    80004dc8:	fc0784e3          	beqz	a5,80004d90 <iput+0x38>
    80004dcc:	04a49783          	lh	a5,74(s1)
    80004dd0:	fc0790e3          	bnez	a5,80004d90 <iput+0x38>
    acquiresleep(&ip->lock);
    80004dd4:	01048913          	addi	s2,s1,16
    80004dd8:	00090513          	mv	a0,s2
    80004ddc:	00001097          	auipc	ra,0x1
    80004de0:	eec080e7          	jalr	-276(ra) # 80005cc8 <acquiresleep>
    release(&itable.lock);
    80004de4:	0001c517          	auipc	a0,0x1c
    80004de8:	2ec50513          	addi	a0,a0,748 # 800210d0 <itable>
    80004dec:	ffffc097          	auipc	ra,0xffffc
    80004df0:	274080e7          	jalr	628(ra) # 80001060 <release>
    itrunc(ip);
    80004df4:	00048513          	mv	a0,s1
    80004df8:	00000097          	auipc	ra,0x0
    80004dfc:	e74080e7          	jalr	-396(ra) # 80004c6c <itrunc>
    ip->type = 0;
    80004e00:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004e04:	00048513          	mv	a0,s1
    80004e08:	00000097          	auipc	ra,0x0
    80004e0c:	bd4080e7          	jalr	-1068(ra) # 800049dc <iupdate>
    ip->valid = 0;
    80004e10:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004e14:	00090513          	mv	a0,s2
    80004e18:	00001097          	auipc	ra,0x1
    80004e1c:	f38080e7          	jalr	-200(ra) # 80005d50 <releasesleep>
    acquire(&itable.lock);
    80004e20:	0001c517          	auipc	a0,0x1c
    80004e24:	2b050513          	addi	a0,a0,688 # 800210d0 <itable>
    80004e28:	ffffc097          	auipc	ra,0xffffc
    80004e2c:	140080e7          	jalr	320(ra) # 80000f68 <acquire>
    80004e30:	f61ff06f          	j	80004d90 <iput+0x38>

0000000080004e34 <iunlockput>:
{
    80004e34:	fe010113          	addi	sp,sp,-32
    80004e38:	00113c23          	sd	ra,24(sp)
    80004e3c:	00813823          	sd	s0,16(sp)
    80004e40:	00913423          	sd	s1,8(sp)
    80004e44:	02010413          	addi	s0,sp,32
    80004e48:	00050493          	mv	s1,a0
  iunlock(ip);
    80004e4c:	00000097          	auipc	ra,0x0
    80004e50:	db0080e7          	jalr	-592(ra) # 80004bfc <iunlock>
  iput(ip);
    80004e54:	00048513          	mv	a0,s1
    80004e58:	00000097          	auipc	ra,0x0
    80004e5c:	f00080e7          	jalr	-256(ra) # 80004d58 <iput>
}
    80004e60:	01813083          	ld	ra,24(sp)
    80004e64:	01013403          	ld	s0,16(sp)
    80004e68:	00813483          	ld	s1,8(sp)
    80004e6c:	02010113          	addi	sp,sp,32
    80004e70:	00008067          	ret

0000000080004e74 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004e74:	ff010113          	addi	sp,sp,-16
    80004e78:	00813423          	sd	s0,8(sp)
    80004e7c:	01010413          	addi	s0,sp,16
  st->dev = ip->dev;
    80004e80:	00052783          	lw	a5,0(a0)
    80004e84:	00f5a023          	sw	a5,0(a1)
  st->ino = ip->inum;
    80004e88:	00452783          	lw	a5,4(a0)
    80004e8c:	00f5a223          	sw	a5,4(a1)
  st->type = ip->type;
    80004e90:	04451783          	lh	a5,68(a0)
    80004e94:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004e98:	04a51783          	lh	a5,74(a0)
    80004e9c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004ea0:	04c56783          	lwu	a5,76(a0)
    80004ea4:	00f5b823          	sd	a5,16(a1)
}
    80004ea8:	00813403          	ld	s0,8(sp)
    80004eac:	01010113          	addi	sp,sp,16
    80004eb0:	00008067          	ret

0000000080004eb4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004eb4:	04c52783          	lw	a5,76(a0)
    80004eb8:	16d7e263          	bltu	a5,a3,8000501c <readi+0x168>
{
    80004ebc:	f9010113          	addi	sp,sp,-112
    80004ec0:	06113423          	sd	ra,104(sp)
    80004ec4:	06813023          	sd	s0,96(sp)
    80004ec8:	04913c23          	sd	s1,88(sp)
    80004ecc:	05213823          	sd	s2,80(sp)
    80004ed0:	05313423          	sd	s3,72(sp)
    80004ed4:	05413023          	sd	s4,64(sp)
    80004ed8:	03513c23          	sd	s5,56(sp)
    80004edc:	03613823          	sd	s6,48(sp)
    80004ee0:	03713423          	sd	s7,40(sp)
    80004ee4:	03813023          	sd	s8,32(sp)
    80004ee8:	01913c23          	sd	s9,24(sp)
    80004eec:	01a13823          	sd	s10,16(sp)
    80004ef0:	01b13423          	sd	s11,8(sp)
    80004ef4:	07010413          	addi	s0,sp,112
    80004ef8:	00050b93          	mv	s7,a0
    80004efc:	00058c13          	mv	s8,a1
    80004f00:	00060a93          	mv	s5,a2
    80004f04:	00068493          	mv	s1,a3
    80004f08:	00070b13          	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004f0c:	00e6873b          	addw	a4,a3,a4
    return 0;
    80004f10:	00000513          	li	a0,0
  if(off > ip->size || off + n < off)
    80004f14:	0cd76263          	bltu	a4,a3,80004fd8 <readi+0x124>
  if(off + n > ip->size)
    80004f18:	00e7f463          	bgeu	a5,a4,80004f20 <readi+0x6c>
    n = ip->size - off;
    80004f1c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004f20:	0e0b0a63          	beqz	s6,80005014 <readi+0x160>
    80004f24:	00000993          	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004f28:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004f2c:	fff00c93          	li	s9,-1
    80004f30:	0480006f          	j	80004f78 <readi+0xc4>
    80004f34:	020a1d93          	slli	s11,s4,0x20
    80004f38:	020ddd93          	srli	s11,s11,0x20
    80004f3c:	06090793          	addi	a5,s2,96
    80004f40:	000d8693          	mv	a3,s11
    80004f44:	00c78633          	add	a2,a5,a2
    80004f48:	000a8593          	mv	a1,s5
    80004f4c:	000c0513          	mv	a0,s8
    80004f50:	ffffe097          	auipc	ra,0xffffe
    80004f54:	304080e7          	jalr	772(ra) # 80003254 <either_copyout>
    80004f58:	07950663          	beq	a0,s9,80004fc4 <readi+0x110>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004f5c:	00090513          	mv	a0,s2
    80004f60:	fffff097          	auipc	ra,0xfffff
    80004f64:	258080e7          	jalr	600(ra) # 800041b8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004f68:	013a09bb          	addw	s3,s4,s3
    80004f6c:	009a04bb          	addw	s1,s4,s1
    80004f70:	01ba8ab3          	add	s5,s5,s11
    80004f74:	0769f063          	bgeu	s3,s6,80004fd4 <readi+0x120>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004f78:	000ba903          	lw	s2,0(s7)
    80004f7c:	00a4d59b          	srliw	a1,s1,0xa
    80004f80:	000b8513          	mv	a0,s7
    80004f84:	fffff097          	auipc	ra,0xfffff
    80004f88:	604080e7          	jalr	1540(ra) # 80004588 <bmap>
    80004f8c:	0005059b          	sext.w	a1,a0
    80004f90:	00090513          	mv	a0,s2
    80004f94:	fffff097          	auipc	ra,0xfffff
    80004f98:	088080e7          	jalr	136(ra) # 8000401c <bread>
    80004f9c:	00050913          	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004fa0:	3ff4f613          	andi	a2,s1,1023
    80004fa4:	40cd07bb          	subw	a5,s10,a2
    80004fa8:	413b073b          	subw	a4,s6,s3
    80004fac:	00078a13          	mv	s4,a5
    80004fb0:	0007879b          	sext.w	a5,a5
    80004fb4:	0007069b          	sext.w	a3,a4
    80004fb8:	f6f6fee3          	bgeu	a3,a5,80004f34 <readi+0x80>
    80004fbc:	00070a13          	mv	s4,a4
    80004fc0:	f75ff06f          	j	80004f34 <readi+0x80>
      brelse(bp);
    80004fc4:	00090513          	mv	a0,s2
    80004fc8:	fffff097          	auipc	ra,0xfffff
    80004fcc:	1f0080e7          	jalr	496(ra) # 800041b8 <brelse>
      tot = -1;
    80004fd0:	fff00993          	li	s3,-1
  }
  return tot;
    80004fd4:	0009851b          	sext.w	a0,s3
}
    80004fd8:	06813083          	ld	ra,104(sp)
    80004fdc:	06013403          	ld	s0,96(sp)
    80004fe0:	05813483          	ld	s1,88(sp)
    80004fe4:	05013903          	ld	s2,80(sp)
    80004fe8:	04813983          	ld	s3,72(sp)
    80004fec:	04013a03          	ld	s4,64(sp)
    80004ff0:	03813a83          	ld	s5,56(sp)
    80004ff4:	03013b03          	ld	s6,48(sp)
    80004ff8:	02813b83          	ld	s7,40(sp)
    80004ffc:	02013c03          	ld	s8,32(sp)
    80005000:	01813c83          	ld	s9,24(sp)
    80005004:	01013d03          	ld	s10,16(sp)
    80005008:	00813d83          	ld	s11,8(sp)
    8000500c:	07010113          	addi	sp,sp,112
    80005010:	00008067          	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80005014:	000b0993          	mv	s3,s6
    80005018:	fbdff06f          	j	80004fd4 <readi+0x120>
    return 0;
    8000501c:	00000513          	li	a0,0
}
    80005020:	00008067          	ret

0000000080005024 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80005024:	04c52783          	lw	a5,76(a0)
    80005028:	18d7e063          	bltu	a5,a3,800051a8 <writei+0x184>
{
    8000502c:	f9010113          	addi	sp,sp,-112
    80005030:	06113423          	sd	ra,104(sp)
    80005034:	06813023          	sd	s0,96(sp)
    80005038:	04913c23          	sd	s1,88(sp)
    8000503c:	05213823          	sd	s2,80(sp)
    80005040:	05313423          	sd	s3,72(sp)
    80005044:	05413023          	sd	s4,64(sp)
    80005048:	03513c23          	sd	s5,56(sp)
    8000504c:	03613823          	sd	s6,48(sp)
    80005050:	03713423          	sd	s7,40(sp)
    80005054:	03813023          	sd	s8,32(sp)
    80005058:	01913c23          	sd	s9,24(sp)
    8000505c:	01a13823          	sd	s10,16(sp)
    80005060:	01b13423          	sd	s11,8(sp)
    80005064:	07010413          	addi	s0,sp,112
    80005068:	00050b13          	mv	s6,a0
    8000506c:	00058c13          	mv	s8,a1
    80005070:	00060a93          	mv	s5,a2
    80005074:	00068913          	mv	s2,a3
    80005078:	00070b93          	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000507c:	00e687bb          	addw	a5,a3,a4
    80005080:	12d7e863          	bltu	a5,a3,800051b0 <writei+0x18c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80005084:	00043737          	lui	a4,0x43
    80005088:	12f76863          	bltu	a4,a5,800051b8 <writei+0x194>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000508c:	100b8a63          	beqz	s7,800051a0 <writei+0x17c>
    80005090:	00000a13          	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80005094:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80005098:	fff00c93          	li	s9,-1
    8000509c:	0540006f          	j	800050f0 <writei+0xcc>
    800050a0:	02099d93          	slli	s11,s3,0x20
    800050a4:	020ddd93          	srli	s11,s11,0x20
    800050a8:	06048793          	addi	a5,s1,96
    800050ac:	000d8693          	mv	a3,s11
    800050b0:	000a8613          	mv	a2,s5
    800050b4:	000c0593          	mv	a1,s8
    800050b8:	00a78533          	add	a0,a5,a0
    800050bc:	ffffe097          	auipc	ra,0xffffe
    800050c0:	228080e7          	jalr	552(ra) # 800032e4 <either_copyin>
    800050c4:	07950c63          	beq	a0,s9,8000513c <writei+0x118>
      brelse(bp);
      break;
    }
    log_write(bp);
    800050c8:	00048513          	mv	a0,s1
    800050cc:	00001097          	auipc	ra,0x1
    800050d0:	a78080e7          	jalr	-1416(ra) # 80005b44 <log_write>
    brelse(bp);
    800050d4:	00048513          	mv	a0,s1
    800050d8:	fffff097          	auipc	ra,0xfffff
    800050dc:	0e0080e7          	jalr	224(ra) # 800041b8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800050e0:	01498a3b          	addw	s4,s3,s4
    800050e4:	0129893b          	addw	s2,s3,s2
    800050e8:	01ba8ab3          	add	s5,s5,s11
    800050ec:	057a7e63          	bgeu	s4,s7,80005148 <writei+0x124>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800050f0:	000b2483          	lw	s1,0(s6)
    800050f4:	00a9559b          	srliw	a1,s2,0xa
    800050f8:	000b0513          	mv	a0,s6
    800050fc:	fffff097          	auipc	ra,0xfffff
    80005100:	48c080e7          	jalr	1164(ra) # 80004588 <bmap>
    80005104:	0005059b          	sext.w	a1,a0
    80005108:	00048513          	mv	a0,s1
    8000510c:	fffff097          	auipc	ra,0xfffff
    80005110:	f10080e7          	jalr	-240(ra) # 8000401c <bread>
    80005114:	00050493          	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80005118:	3ff97513          	andi	a0,s2,1023
    8000511c:	40ad07bb          	subw	a5,s10,a0
    80005120:	414b873b          	subw	a4,s7,s4
    80005124:	00078993          	mv	s3,a5
    80005128:	0007879b          	sext.w	a5,a5
    8000512c:	0007069b          	sext.w	a3,a4
    80005130:	f6f6f8e3          	bgeu	a3,a5,800050a0 <writei+0x7c>
    80005134:	00070993          	mv	s3,a4
    80005138:	f69ff06f          	j	800050a0 <writei+0x7c>
      brelse(bp);
    8000513c:	00048513          	mv	a0,s1
    80005140:	fffff097          	auipc	ra,0xfffff
    80005144:	078080e7          	jalr	120(ra) # 800041b8 <brelse>
  }

  if(off > ip->size)
    80005148:	04cb2783          	lw	a5,76(s6)
    8000514c:	0127f463          	bgeu	a5,s2,80005154 <writei+0x130>
    ip->size = off;
    80005150:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80005154:	000b0513          	mv	a0,s6
    80005158:	00000097          	auipc	ra,0x0
    8000515c:	884080e7          	jalr	-1916(ra) # 800049dc <iupdate>

  return tot;
    80005160:	000a051b          	sext.w	a0,s4
}
    80005164:	06813083          	ld	ra,104(sp)
    80005168:	06013403          	ld	s0,96(sp)
    8000516c:	05813483          	ld	s1,88(sp)
    80005170:	05013903          	ld	s2,80(sp)
    80005174:	04813983          	ld	s3,72(sp)
    80005178:	04013a03          	ld	s4,64(sp)
    8000517c:	03813a83          	ld	s5,56(sp)
    80005180:	03013b03          	ld	s6,48(sp)
    80005184:	02813b83          	ld	s7,40(sp)
    80005188:	02013c03          	ld	s8,32(sp)
    8000518c:	01813c83          	ld	s9,24(sp)
    80005190:	01013d03          	ld	s10,16(sp)
    80005194:	00813d83          	ld	s11,8(sp)
    80005198:	07010113          	addi	sp,sp,112
    8000519c:	00008067          	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800051a0:	000b8a13          	mv	s4,s7
    800051a4:	fb1ff06f          	j	80005154 <writei+0x130>
    return -1;
    800051a8:	fff00513          	li	a0,-1
}
    800051ac:	00008067          	ret
    return -1;
    800051b0:	fff00513          	li	a0,-1
    800051b4:	fb1ff06f          	j	80005164 <writei+0x140>
    return -1;
    800051b8:	fff00513          	li	a0,-1
    800051bc:	fa9ff06f          	j	80005164 <writei+0x140>

00000000800051c0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800051c0:	ff010113          	addi	sp,sp,-16
    800051c4:	00113423          	sd	ra,8(sp)
    800051c8:	00813023          	sd	s0,0(sp)
    800051cc:	01010413          	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800051d0:	00e00613          	li	a2,14
    800051d4:	ffffc097          	auipc	ra,0xffffc
    800051d8:	02c080e7          	jalr	44(ra) # 80001200 <strncmp>
}
    800051dc:	00813083          	ld	ra,8(sp)
    800051e0:	00013403          	ld	s0,0(sp)
    800051e4:	01010113          	addi	sp,sp,16
    800051e8:	00008067          	ret

00000000800051ec <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800051ec:	fc010113          	addi	sp,sp,-64
    800051f0:	02113c23          	sd	ra,56(sp)
    800051f4:	02813823          	sd	s0,48(sp)
    800051f8:	02913423          	sd	s1,40(sp)
    800051fc:	03213023          	sd	s2,32(sp)
    80005200:	01313c23          	sd	s3,24(sp)
    80005204:	01413823          	sd	s4,16(sp)
    80005208:	04010413          	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000520c:	04451703          	lh	a4,68(a0)
    80005210:	00100793          	li	a5,1
    80005214:	02f71263          	bne	a4,a5,80005238 <dirlookup+0x4c>
    80005218:	00050913          	mv	s2,a0
    8000521c:	00058993          	mv	s3,a1
    80005220:	00060a13          	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80005224:	04c52783          	lw	a5,76(a0)
    80005228:	00000493          	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000522c:	00000513          	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005230:	02079a63          	bnez	a5,80005264 <dirlookup+0x78>
    80005234:	0900006f          	j	800052c4 <dirlookup+0xd8>
    panic("dirlookup not DIR");
    80005238:	00005517          	auipc	a0,0x5
    8000523c:	3a850513          	addi	a0,a0,936 # 8000a5e0 <syscalls+0x1a0>
    80005240:	ffffb097          	auipc	ra,0xffffb
    80005244:	48c080e7          	jalr	1164(ra) # 800006cc <panic>
      panic("dirlookup read");
    80005248:	00005517          	auipc	a0,0x5
    8000524c:	3b050513          	addi	a0,a0,944 # 8000a5f8 <syscalls+0x1b8>
    80005250:	ffffb097          	auipc	ra,0xffffb
    80005254:	47c080e7          	jalr	1148(ra) # 800006cc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005258:	0104849b          	addiw	s1,s1,16
    8000525c:	04c92783          	lw	a5,76(s2)
    80005260:	06f4f063          	bgeu	s1,a5,800052c0 <dirlookup+0xd4>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005264:	01000713          	li	a4,16
    80005268:	00048693          	mv	a3,s1
    8000526c:	fc040613          	addi	a2,s0,-64
    80005270:	00000593          	li	a1,0
    80005274:	00090513          	mv	a0,s2
    80005278:	00000097          	auipc	ra,0x0
    8000527c:	c3c080e7          	jalr	-964(ra) # 80004eb4 <readi>
    80005280:	01000793          	li	a5,16
    80005284:	fcf512e3          	bne	a0,a5,80005248 <dirlookup+0x5c>
    if(de.inum == 0)
    80005288:	fc045783          	lhu	a5,-64(s0)
    8000528c:	fc0786e3          	beqz	a5,80005258 <dirlookup+0x6c>
    if(namecmp(name, de.name) == 0){
    80005290:	fc240593          	addi	a1,s0,-62
    80005294:	00098513          	mv	a0,s3
    80005298:	00000097          	auipc	ra,0x0
    8000529c:	f28080e7          	jalr	-216(ra) # 800051c0 <namecmp>
    800052a0:	fa051ce3          	bnez	a0,80005258 <dirlookup+0x6c>
      if(poff)
    800052a4:	000a0463          	beqz	s4,800052ac <dirlookup+0xc0>
        *poff = off;
    800052a8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800052ac:	fc045583          	lhu	a1,-64(s0)
    800052b0:	00092503          	lw	a0,0(s2)
    800052b4:	fffff097          	auipc	ra,0xfffff
    800052b8:	3e8080e7          	jalr	1000(ra) # 8000469c <iget>
    800052bc:	0080006f          	j	800052c4 <dirlookup+0xd8>
  return 0;
    800052c0:	00000513          	li	a0,0
}
    800052c4:	03813083          	ld	ra,56(sp)
    800052c8:	03013403          	ld	s0,48(sp)
    800052cc:	02813483          	ld	s1,40(sp)
    800052d0:	02013903          	ld	s2,32(sp)
    800052d4:	01813983          	ld	s3,24(sp)
    800052d8:	01013a03          	ld	s4,16(sp)
    800052dc:	04010113          	addi	sp,sp,64
    800052e0:	00008067          	ret

00000000800052e4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800052e4:	fa010113          	addi	sp,sp,-96
    800052e8:	04113c23          	sd	ra,88(sp)
    800052ec:	04813823          	sd	s0,80(sp)
    800052f0:	04913423          	sd	s1,72(sp)
    800052f4:	05213023          	sd	s2,64(sp)
    800052f8:	03313c23          	sd	s3,56(sp)
    800052fc:	03413823          	sd	s4,48(sp)
    80005300:	03513423          	sd	s5,40(sp)
    80005304:	03613023          	sd	s6,32(sp)
    80005308:	01713c23          	sd	s7,24(sp)
    8000530c:	01813823          	sd	s8,16(sp)
    80005310:	01913423          	sd	s9,8(sp)
    80005314:	06010413          	addi	s0,sp,96
    80005318:	00050493          	mv	s1,a0
    8000531c:	00058a93          	mv	s5,a1
    80005320:	00060a13          	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80005324:	00054703          	lbu	a4,0(a0)
    80005328:	02f00793          	li	a5,47
    8000532c:	02f70863          	beq	a4,a5,8000535c <namex+0x78>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80005330:	ffffd097          	auipc	ra,0xffffd
    80005334:	0bc080e7          	jalr	188(ra) # 800023ec <myproc>
    80005338:	15053503          	ld	a0,336(a0)
    8000533c:	fffff097          	auipc	ra,0xfffff
    80005340:	760080e7          	jalr	1888(ra) # 80004a9c <idup>
    80005344:	00050993          	mv	s3,a0
  while(*path == '/')
    80005348:	02f00913          	li	s2,47
  len = path - s;
    8000534c:	00000b13          	li	s6,0
  if(len >= DIRSIZ)
    80005350:	00d00c13          	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80005354:	00100b93          	li	s7,1
    80005358:	1040006f          	j	8000545c <namex+0x178>
    ip = iget(ROOTDEV, ROOTINO);
    8000535c:	00100593          	li	a1,1
    80005360:	00100513          	li	a0,1
    80005364:	fffff097          	auipc	ra,0xfffff
    80005368:	338080e7          	jalr	824(ra) # 8000469c <iget>
    8000536c:	00050993          	mv	s3,a0
    80005370:	fd9ff06f          	j	80005348 <namex+0x64>
      iunlockput(ip);
    80005374:	00098513          	mv	a0,s3
    80005378:	00000097          	auipc	ra,0x0
    8000537c:	abc080e7          	jalr	-1348(ra) # 80004e34 <iunlockput>
      return 0;
    80005380:	00000993          	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80005384:	00098513          	mv	a0,s3
    80005388:	05813083          	ld	ra,88(sp)
    8000538c:	05013403          	ld	s0,80(sp)
    80005390:	04813483          	ld	s1,72(sp)
    80005394:	04013903          	ld	s2,64(sp)
    80005398:	03813983          	ld	s3,56(sp)
    8000539c:	03013a03          	ld	s4,48(sp)
    800053a0:	02813a83          	ld	s5,40(sp)
    800053a4:	02013b03          	ld	s6,32(sp)
    800053a8:	01813b83          	ld	s7,24(sp)
    800053ac:	01013c03          	ld	s8,16(sp)
    800053b0:	00813c83          	ld	s9,8(sp)
    800053b4:	06010113          	addi	sp,sp,96
    800053b8:	00008067          	ret
      iunlock(ip);
    800053bc:	00098513          	mv	a0,s3
    800053c0:	00000097          	auipc	ra,0x0
    800053c4:	83c080e7          	jalr	-1988(ra) # 80004bfc <iunlock>
      return ip;
    800053c8:	fbdff06f          	j	80005384 <namex+0xa0>
      iunlockput(ip);
    800053cc:	00098513          	mv	a0,s3
    800053d0:	00000097          	auipc	ra,0x0
    800053d4:	a64080e7          	jalr	-1436(ra) # 80004e34 <iunlockput>
      return 0;
    800053d8:	000c8993          	mv	s3,s9
    800053dc:	fa9ff06f          	j	80005384 <namex+0xa0>
  len = path - s;
    800053e0:	40b48633          	sub	a2,s1,a1
    800053e4:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800053e8:	0b9c5863          	bge	s8,s9,80005498 <namex+0x1b4>
    memmove(name, s, DIRSIZ);
    800053ec:	00e00613          	li	a2,14
    800053f0:	000a0513          	mv	a0,s4
    800053f4:	ffffc097          	auipc	ra,0xffffc
    800053f8:	d60080e7          	jalr	-672(ra) # 80001154 <memmove>
  while(*path == '/')
    800053fc:	0004c783          	lbu	a5,0(s1)
    80005400:	01279863          	bne	a5,s2,80005410 <namex+0x12c>
    path++;
    80005404:	00148493          	addi	s1,s1,1
  while(*path == '/')
    80005408:	0004c783          	lbu	a5,0(s1)
    8000540c:	ff278ce3          	beq	a5,s2,80005404 <namex+0x120>
    ilock(ip);
    80005410:	00098513          	mv	a0,s3
    80005414:	fffff097          	auipc	ra,0xfffff
    80005418:	6e4080e7          	jalr	1764(ra) # 80004af8 <ilock>
    if(ip->type != T_DIR){
    8000541c:	04499783          	lh	a5,68(s3)
    80005420:	f5779ae3          	bne	a5,s7,80005374 <namex+0x90>
    if(nameiparent && *path == '\0'){
    80005424:	000a8663          	beqz	s5,80005430 <namex+0x14c>
    80005428:	0004c783          	lbu	a5,0(s1)
    8000542c:	f80788e3          	beqz	a5,800053bc <namex+0xd8>
    if((next = dirlookup(ip, name, 0)) == 0){
    80005430:	000b0613          	mv	a2,s6
    80005434:	000a0593          	mv	a1,s4
    80005438:	00098513          	mv	a0,s3
    8000543c:	00000097          	auipc	ra,0x0
    80005440:	db0080e7          	jalr	-592(ra) # 800051ec <dirlookup>
    80005444:	00050c93          	mv	s9,a0
    80005448:	f80502e3          	beqz	a0,800053cc <namex+0xe8>
    iunlockput(ip);
    8000544c:	00098513          	mv	a0,s3
    80005450:	00000097          	auipc	ra,0x0
    80005454:	9e4080e7          	jalr	-1564(ra) # 80004e34 <iunlockput>
    ip = next;
    80005458:	000c8993          	mv	s3,s9
  while(*path == '/')
    8000545c:	0004c783          	lbu	a5,0(s1)
    80005460:	07279663          	bne	a5,s2,800054cc <namex+0x1e8>
    path++;
    80005464:	00148493          	addi	s1,s1,1
  while(*path == '/')
    80005468:	0004c783          	lbu	a5,0(s1)
    8000546c:	ff278ce3          	beq	a5,s2,80005464 <namex+0x180>
  if(*path == 0)
    80005470:	04078263          	beqz	a5,800054b4 <namex+0x1d0>
    path++;
    80005474:	00048593          	mv	a1,s1
  len = path - s;
    80005478:	000b0c93          	mv	s9,s6
    8000547c:	000b0613          	mv	a2,s6
  while(*path != '/' && *path != 0)
    80005480:	01278c63          	beq	a5,s2,80005498 <namex+0x1b4>
    80005484:	f4078ee3          	beqz	a5,800053e0 <namex+0xfc>
    path++;
    80005488:	00148493          	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000548c:	0004c783          	lbu	a5,0(s1)
    80005490:	ff279ae3          	bne	a5,s2,80005484 <namex+0x1a0>
    80005494:	f4dff06f          	j	800053e0 <namex+0xfc>
    memmove(name, s, len);
    80005498:	0006061b          	sext.w	a2,a2
    8000549c:	000a0513          	mv	a0,s4
    800054a0:	ffffc097          	auipc	ra,0xffffc
    800054a4:	cb4080e7          	jalr	-844(ra) # 80001154 <memmove>
    name[len] = 0;
    800054a8:	019a0cb3          	add	s9,s4,s9
    800054ac:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800054b0:	f4dff06f          	j	800053fc <namex+0x118>
  if(nameiparent){
    800054b4:	ec0a88e3          	beqz	s5,80005384 <namex+0xa0>
    iput(ip);
    800054b8:	00098513          	mv	a0,s3
    800054bc:	00000097          	auipc	ra,0x0
    800054c0:	89c080e7          	jalr	-1892(ra) # 80004d58 <iput>
    return 0;
    800054c4:	00000993          	li	s3,0
    800054c8:	ebdff06f          	j	80005384 <namex+0xa0>
  if(*path == 0)
    800054cc:	fe0784e3          	beqz	a5,800054b4 <namex+0x1d0>
  while(*path != '/' && *path != 0)
    800054d0:	0004c783          	lbu	a5,0(s1)
    800054d4:	00048593          	mv	a1,s1
    800054d8:	fadff06f          	j	80005484 <namex+0x1a0>

00000000800054dc <dirlink>:
{
    800054dc:	fc010113          	addi	sp,sp,-64
    800054e0:	02113c23          	sd	ra,56(sp)
    800054e4:	02813823          	sd	s0,48(sp)
    800054e8:	02913423          	sd	s1,40(sp)
    800054ec:	03213023          	sd	s2,32(sp)
    800054f0:	01313c23          	sd	s3,24(sp)
    800054f4:	01413823          	sd	s4,16(sp)
    800054f8:	04010413          	addi	s0,sp,64
    800054fc:	00050913          	mv	s2,a0
    80005500:	00058a13          	mv	s4,a1
    80005504:	00060993          	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80005508:	00000613          	li	a2,0
    8000550c:	00000097          	auipc	ra,0x0
    80005510:	ce0080e7          	jalr	-800(ra) # 800051ec <dirlookup>
    80005514:	0a051663          	bnez	a0,800055c0 <dirlink+0xe4>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005518:	04c92483          	lw	s1,76(s2)
    8000551c:	04048063          	beqz	s1,8000555c <dirlink+0x80>
    80005520:	00000493          	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005524:	01000713          	li	a4,16
    80005528:	00048693          	mv	a3,s1
    8000552c:	fc040613          	addi	a2,s0,-64
    80005530:	00000593          	li	a1,0
    80005534:	00090513          	mv	a0,s2
    80005538:	00000097          	auipc	ra,0x0
    8000553c:	97c080e7          	jalr	-1668(ra) # 80004eb4 <readi>
    80005540:	01000793          	li	a5,16
    80005544:	08f51663          	bne	a0,a5,800055d0 <dirlink+0xf4>
    if(de.inum == 0)
    80005548:	fc045783          	lhu	a5,-64(s0)
    8000554c:	00078863          	beqz	a5,8000555c <dirlink+0x80>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005550:	0104849b          	addiw	s1,s1,16
    80005554:	04c92783          	lw	a5,76(s2)
    80005558:	fcf4e6e3          	bltu	s1,a5,80005524 <dirlink+0x48>
  strncpy(de.name, name, DIRSIZ);
    8000555c:	00e00613          	li	a2,14
    80005560:	000a0593          	mv	a1,s4
    80005564:	fc240513          	addi	a0,s0,-62
    80005568:	ffffc097          	auipc	ra,0xffffc
    8000556c:	cfc080e7          	jalr	-772(ra) # 80001264 <strncpy>
  de.inum = inum;
    80005570:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005574:	01000713          	li	a4,16
    80005578:	00048693          	mv	a3,s1
    8000557c:	fc040613          	addi	a2,s0,-64
    80005580:	00000593          	li	a1,0
    80005584:	00090513          	mv	a0,s2
    80005588:	00000097          	auipc	ra,0x0
    8000558c:	a9c080e7          	jalr	-1380(ra) # 80005024 <writei>
    80005590:	00050713          	mv	a4,a0
    80005594:	01000793          	li	a5,16
  return 0;
    80005598:	00000513          	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000559c:	04f71263          	bne	a4,a5,800055e0 <dirlink+0x104>
}
    800055a0:	03813083          	ld	ra,56(sp)
    800055a4:	03013403          	ld	s0,48(sp)
    800055a8:	02813483          	ld	s1,40(sp)
    800055ac:	02013903          	ld	s2,32(sp)
    800055b0:	01813983          	ld	s3,24(sp)
    800055b4:	01013a03          	ld	s4,16(sp)
    800055b8:	04010113          	addi	sp,sp,64
    800055bc:	00008067          	ret
    iput(ip);
    800055c0:	fffff097          	auipc	ra,0xfffff
    800055c4:	798080e7          	jalr	1944(ra) # 80004d58 <iput>
    return -1;
    800055c8:	fff00513          	li	a0,-1
    800055cc:	fd5ff06f          	j	800055a0 <dirlink+0xc4>
      panic("dirlink read");
    800055d0:	00005517          	auipc	a0,0x5
    800055d4:	03850513          	addi	a0,a0,56 # 8000a608 <syscalls+0x1c8>
    800055d8:	ffffb097          	auipc	ra,0xffffb
    800055dc:	0f4080e7          	jalr	244(ra) # 800006cc <panic>
    panic("dirlink");
    800055e0:	00005517          	auipc	a0,0x5
    800055e4:	19850513          	addi	a0,a0,408 # 8000a778 <syscalls+0x338>
    800055e8:	ffffb097          	auipc	ra,0xffffb
    800055ec:	0e4080e7          	jalr	228(ra) # 800006cc <panic>

00000000800055f0 <namei>:

struct inode*
namei(char *path)
{
    800055f0:	fe010113          	addi	sp,sp,-32
    800055f4:	00113c23          	sd	ra,24(sp)
    800055f8:	00813823          	sd	s0,16(sp)
    800055fc:	02010413          	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80005600:	fe040613          	addi	a2,s0,-32
    80005604:	00000593          	li	a1,0
    80005608:	00000097          	auipc	ra,0x0
    8000560c:	cdc080e7          	jalr	-804(ra) # 800052e4 <namex>
}
    80005610:	01813083          	ld	ra,24(sp)
    80005614:	01013403          	ld	s0,16(sp)
    80005618:	02010113          	addi	sp,sp,32
    8000561c:	00008067          	ret

0000000080005620 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80005620:	ff010113          	addi	sp,sp,-16
    80005624:	00113423          	sd	ra,8(sp)
    80005628:	00813023          	sd	s0,0(sp)
    8000562c:	01010413          	addi	s0,sp,16
    80005630:	00058613          	mv	a2,a1
  return namex(path, 1, name);
    80005634:	00100593          	li	a1,1
    80005638:	00000097          	auipc	ra,0x0
    8000563c:	cac080e7          	jalr	-852(ra) # 800052e4 <namex>
}
    80005640:	00813083          	ld	ra,8(sp)
    80005644:	00013403          	ld	s0,0(sp)
    80005648:	01010113          	addi	sp,sp,16
    8000564c:	00008067          	ret

0000000080005650 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80005650:	fe010113          	addi	sp,sp,-32
    80005654:	00113c23          	sd	ra,24(sp)
    80005658:	00813823          	sd	s0,16(sp)
    8000565c:	00913423          	sd	s1,8(sp)
    80005660:	01213023          	sd	s2,0(sp)
    80005664:	02010413          	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80005668:	0001d917          	auipc	s2,0x1d
    8000566c:	51090913          	addi	s2,s2,1296 # 80022b78 <log>
    80005670:	01892583          	lw	a1,24(s2)
    80005674:	02892503          	lw	a0,40(s2)
    80005678:	fffff097          	auipc	ra,0xfffff
    8000567c:	9a4080e7          	jalr	-1628(ra) # 8000401c <bread>
    80005680:	00050493          	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80005684:	02c92683          	lw	a3,44(s2)
    80005688:	06d52023          	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000568c:	02d05e63          	blez	a3,800056c8 <write_head+0x78>
    80005690:	0001d797          	auipc	a5,0x1d
    80005694:	51878793          	addi	a5,a5,1304 # 80022ba8 <log+0x30>
    80005698:	06450713          	addi	a4,a0,100
    8000569c:	fff6869b          	addiw	a3,a3,-1
    800056a0:	02069613          	slli	a2,a3,0x20
    800056a4:	01e65693          	srli	a3,a2,0x1e
    800056a8:	0001d617          	auipc	a2,0x1d
    800056ac:	50460613          	addi	a2,a2,1284 # 80022bac <log+0x34>
    800056b0:	00c686b3          	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800056b4:	0007a603          	lw	a2,0(a5)
    800056b8:	00c72023          	sw	a2,0(a4) # 43000 <_entry-0x7ffbd000>
  for (i = 0; i < log.lh.n; i++) {
    800056bc:	00478793          	addi	a5,a5,4
    800056c0:	00470713          	addi	a4,a4,4
    800056c4:	fed798e3          	bne	a5,a3,800056b4 <write_head+0x64>
  }
  bwrite(buf);
    800056c8:	00048513          	mv	a0,s1
    800056cc:	fffff097          	auipc	ra,0xfffff
    800056d0:	a88080e7          	jalr	-1400(ra) # 80004154 <bwrite>
  brelse(buf);
    800056d4:	00048513          	mv	a0,s1
    800056d8:	fffff097          	auipc	ra,0xfffff
    800056dc:	ae0080e7          	jalr	-1312(ra) # 800041b8 <brelse>
}
    800056e0:	01813083          	ld	ra,24(sp)
    800056e4:	01013403          	ld	s0,16(sp)
    800056e8:	00813483          	ld	s1,8(sp)
    800056ec:	00013903          	ld	s2,0(sp)
    800056f0:	02010113          	addi	sp,sp,32
    800056f4:	00008067          	ret

00000000800056f8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800056f8:	0001d797          	auipc	a5,0x1d
    800056fc:	4ac7a783          	lw	a5,1196(a5) # 80022ba4 <log+0x2c>
    80005700:	0ef05e63          	blez	a5,800057fc <install_trans+0x104>
{
    80005704:	fc010113          	addi	sp,sp,-64
    80005708:	02113c23          	sd	ra,56(sp)
    8000570c:	02813823          	sd	s0,48(sp)
    80005710:	02913423          	sd	s1,40(sp)
    80005714:	03213023          	sd	s2,32(sp)
    80005718:	01313c23          	sd	s3,24(sp)
    8000571c:	01413823          	sd	s4,16(sp)
    80005720:	01513423          	sd	s5,8(sp)
    80005724:	01613023          	sd	s6,0(sp)
    80005728:	04010413          	addi	s0,sp,64
    8000572c:	00050b13          	mv	s6,a0
    80005730:	0001da97          	auipc	s5,0x1d
    80005734:	478a8a93          	addi	s5,s5,1144 # 80022ba8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005738:	00000a13          	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000573c:	0001d997          	auipc	s3,0x1d
    80005740:	43c98993          	addi	s3,s3,1084 # 80022b78 <log>
    80005744:	02c0006f          	j	80005770 <install_trans+0x78>
    brelse(lbuf);
    80005748:	00090513          	mv	a0,s2
    8000574c:	fffff097          	auipc	ra,0xfffff
    80005750:	a6c080e7          	jalr	-1428(ra) # 800041b8 <brelse>
    brelse(dbuf);
    80005754:	00048513          	mv	a0,s1
    80005758:	fffff097          	auipc	ra,0xfffff
    8000575c:	a60080e7          	jalr	-1440(ra) # 800041b8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005760:	001a0a1b          	addiw	s4,s4,1
    80005764:	004a8a93          	addi	s5,s5,4
    80005768:	02c9a783          	lw	a5,44(s3)
    8000576c:	06fa5463          	bge	s4,a5,800057d4 <install_trans+0xdc>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005770:	0189a583          	lw	a1,24(s3)
    80005774:	014585bb          	addw	a1,a1,s4
    80005778:	0015859b          	addiw	a1,a1,1
    8000577c:	0289a503          	lw	a0,40(s3)
    80005780:	fffff097          	auipc	ra,0xfffff
    80005784:	89c080e7          	jalr	-1892(ra) # 8000401c <bread>
    80005788:	00050913          	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000578c:	000aa583          	lw	a1,0(s5)
    80005790:	0289a503          	lw	a0,40(s3)
    80005794:	fffff097          	auipc	ra,0xfffff
    80005798:	888080e7          	jalr	-1912(ra) # 8000401c <bread>
    8000579c:	00050493          	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800057a0:	40000613          	li	a2,1024
    800057a4:	06090593          	addi	a1,s2,96
    800057a8:	06050513          	addi	a0,a0,96
    800057ac:	ffffc097          	auipc	ra,0xffffc
    800057b0:	9a8080e7          	jalr	-1624(ra) # 80001154 <memmove>
    bwrite(dbuf);  // write dst to disk
    800057b4:	00048513          	mv	a0,s1
    800057b8:	fffff097          	auipc	ra,0xfffff
    800057bc:	99c080e7          	jalr	-1636(ra) # 80004154 <bwrite>
    if(recovering == 0)
    800057c0:	f80b14e3          	bnez	s6,80005748 <install_trans+0x50>
      bunpin(dbuf);
    800057c4:	00048513          	mv	a0,s1
    800057c8:	fffff097          	auipc	ra,0xfffff
    800057cc:	b20080e7          	jalr	-1248(ra) # 800042e8 <bunpin>
    800057d0:	f79ff06f          	j	80005748 <install_trans+0x50>
}
    800057d4:	03813083          	ld	ra,56(sp)
    800057d8:	03013403          	ld	s0,48(sp)
    800057dc:	02813483          	ld	s1,40(sp)
    800057e0:	02013903          	ld	s2,32(sp)
    800057e4:	01813983          	ld	s3,24(sp)
    800057e8:	01013a03          	ld	s4,16(sp)
    800057ec:	00813a83          	ld	s5,8(sp)
    800057f0:	00013b03          	ld	s6,0(sp)
    800057f4:	04010113          	addi	sp,sp,64
    800057f8:	00008067          	ret
    800057fc:	00008067          	ret

0000000080005800 <initlog>:
{
    80005800:	fd010113          	addi	sp,sp,-48
    80005804:	02113423          	sd	ra,40(sp)
    80005808:	02813023          	sd	s0,32(sp)
    8000580c:	00913c23          	sd	s1,24(sp)
    80005810:	01213823          	sd	s2,16(sp)
    80005814:	01313423          	sd	s3,8(sp)
    80005818:	03010413          	addi	s0,sp,48
    8000581c:	00050913          	mv	s2,a0
    80005820:	00058993          	mv	s3,a1
  initlock(&log.lock, "log");
    80005824:	0001d497          	auipc	s1,0x1d
    80005828:	35448493          	addi	s1,s1,852 # 80022b78 <log>
    8000582c:	00005597          	auipc	a1,0x5
    80005830:	dec58593          	addi	a1,a1,-532 # 8000a618 <syscalls+0x1d8>
    80005834:	00048513          	mv	a0,s1
    80005838:	ffffb097          	auipc	ra,0xffffb
    8000583c:	64c080e7          	jalr	1612(ra) # 80000e84 <initlock>
  log.start = sb->logstart;
    80005840:	0149a583          	lw	a1,20(s3)
    80005844:	00b4ac23          	sw	a1,24(s1)
  log.size = sb->nlog;
    80005848:	0109a783          	lw	a5,16(s3)
    8000584c:	00f4ae23          	sw	a5,28(s1)
  log.dev = dev;
    80005850:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80005854:	00090513          	mv	a0,s2
    80005858:	ffffe097          	auipc	ra,0xffffe
    8000585c:	7c4080e7          	jalr	1988(ra) # 8000401c <bread>
  log.lh.n = lh->n;
    80005860:	06052683          	lw	a3,96(a0)
    80005864:	02d4a623          	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80005868:	02d05c63          	blez	a3,800058a0 <initlog+0xa0>
    8000586c:	06450793          	addi	a5,a0,100
    80005870:	0001d717          	auipc	a4,0x1d
    80005874:	33870713          	addi	a4,a4,824 # 80022ba8 <log+0x30>
    80005878:	fff6869b          	addiw	a3,a3,-1
    8000587c:	02069613          	slli	a2,a3,0x20
    80005880:	01e65693          	srli	a3,a2,0x1e
    80005884:	06850613          	addi	a2,a0,104
    80005888:	00c686b3          	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000588c:	0007a603          	lw	a2,0(a5)
    80005890:	00c72023          	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80005894:	00478793          	addi	a5,a5,4
    80005898:	00470713          	addi	a4,a4,4
    8000589c:	fed798e3          	bne	a5,a3,8000588c <initlog+0x8c>
  brelse(buf);
    800058a0:	fffff097          	auipc	ra,0xfffff
    800058a4:	918080e7          	jalr	-1768(ra) # 800041b8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800058a8:	00100513          	li	a0,1
    800058ac:	00000097          	auipc	ra,0x0
    800058b0:	e4c080e7          	jalr	-436(ra) # 800056f8 <install_trans>
  log.lh.n = 0;
    800058b4:	0001d797          	auipc	a5,0x1d
    800058b8:	2e07a823          	sw	zero,752(a5) # 80022ba4 <log+0x2c>
  write_head(); // clear the log
    800058bc:	00000097          	auipc	ra,0x0
    800058c0:	d94080e7          	jalr	-620(ra) # 80005650 <write_head>
}
    800058c4:	02813083          	ld	ra,40(sp)
    800058c8:	02013403          	ld	s0,32(sp)
    800058cc:	01813483          	ld	s1,24(sp)
    800058d0:	01013903          	ld	s2,16(sp)
    800058d4:	00813983          	ld	s3,8(sp)
    800058d8:	03010113          	addi	sp,sp,48
    800058dc:	00008067          	ret

00000000800058e0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800058e0:	fe010113          	addi	sp,sp,-32
    800058e4:	00113c23          	sd	ra,24(sp)
    800058e8:	00813823          	sd	s0,16(sp)
    800058ec:	00913423          	sd	s1,8(sp)
    800058f0:	01213023          	sd	s2,0(sp)
    800058f4:	02010413          	addi	s0,sp,32
  acquire(&log.lock);
    800058f8:	0001d517          	auipc	a0,0x1d
    800058fc:	28050513          	addi	a0,a0,640 # 80022b78 <log>
    80005900:	ffffb097          	auipc	ra,0xffffb
    80005904:	668080e7          	jalr	1640(ra) # 80000f68 <acquire>
  while(1){
    if(log.committing){
    80005908:	0001d497          	auipc	s1,0x1d
    8000590c:	27048493          	addi	s1,s1,624 # 80022b78 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80005910:	01e00913          	li	s2,30
    80005914:	0140006f          	j	80005928 <begin_op+0x48>
      sleep(&log, &log.lock);
    80005918:	00048593          	mv	a1,s1
    8000591c:	00048513          	mv	a0,s1
    80005920:	ffffd097          	auipc	ra,0xffffd
    80005924:	43c080e7          	jalr	1084(ra) # 80002d5c <sleep>
    if(log.committing){
    80005928:	0244a783          	lw	a5,36(s1)
    8000592c:	fe0796e3          	bnez	a5,80005918 <begin_op+0x38>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80005930:	0204a783          	lw	a5,32(s1)
    80005934:	0017871b          	addiw	a4,a5,1
    80005938:	0007069b          	sext.w	a3,a4
    8000593c:	0027179b          	slliw	a5,a4,0x2
    80005940:	00e787bb          	addw	a5,a5,a4
    80005944:	0017979b          	slliw	a5,a5,0x1
    80005948:	02c4a703          	lw	a4,44(s1)
    8000594c:	00e787bb          	addw	a5,a5,a4
    80005950:	00f95c63          	bge	s2,a5,80005968 <begin_op+0x88>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80005954:	00048593          	mv	a1,s1
    80005958:	00048513          	mv	a0,s1
    8000595c:	ffffd097          	auipc	ra,0xffffd
    80005960:	400080e7          	jalr	1024(ra) # 80002d5c <sleep>
    80005964:	fc5ff06f          	j	80005928 <begin_op+0x48>
    } else {
      log.outstanding += 1;
    80005968:	0001d517          	auipc	a0,0x1d
    8000596c:	21050513          	addi	a0,a0,528 # 80022b78 <log>
    80005970:	02d52023          	sw	a3,32(a0)
      release(&log.lock);
    80005974:	ffffb097          	auipc	ra,0xffffb
    80005978:	6ec080e7          	jalr	1772(ra) # 80001060 <release>
      break;
    }
  }
}
    8000597c:	01813083          	ld	ra,24(sp)
    80005980:	01013403          	ld	s0,16(sp)
    80005984:	00813483          	ld	s1,8(sp)
    80005988:	00013903          	ld	s2,0(sp)
    8000598c:	02010113          	addi	sp,sp,32
    80005990:	00008067          	ret

0000000080005994 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80005994:	fc010113          	addi	sp,sp,-64
    80005998:	02113c23          	sd	ra,56(sp)
    8000599c:	02813823          	sd	s0,48(sp)
    800059a0:	02913423          	sd	s1,40(sp)
    800059a4:	03213023          	sd	s2,32(sp)
    800059a8:	01313c23          	sd	s3,24(sp)
    800059ac:	01413823          	sd	s4,16(sp)
    800059b0:	01513423          	sd	s5,8(sp)
    800059b4:	04010413          	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800059b8:	0001d497          	auipc	s1,0x1d
    800059bc:	1c048493          	addi	s1,s1,448 # 80022b78 <log>
    800059c0:	00048513          	mv	a0,s1
    800059c4:	ffffb097          	auipc	ra,0xffffb
    800059c8:	5a4080e7          	jalr	1444(ra) # 80000f68 <acquire>
  log.outstanding -= 1;
    800059cc:	0204a783          	lw	a5,32(s1)
    800059d0:	fff7879b          	addiw	a5,a5,-1
    800059d4:	0007891b          	sext.w	s2,a5
    800059d8:	02f4a023          	sw	a5,32(s1)
  if(log.committing)
    800059dc:	0244a783          	lw	a5,36(s1)
    800059e0:	06079063          	bnez	a5,80005a40 <end_op+0xac>
    panic("log.committing");
  if(log.outstanding == 0){
    800059e4:	06091663          	bnez	s2,80005a50 <end_op+0xbc>
    do_commit = 1;
    log.committing = 1;
    800059e8:	0001d497          	auipc	s1,0x1d
    800059ec:	19048493          	addi	s1,s1,400 # 80022b78 <log>
    800059f0:	00100793          	li	a5,1
    800059f4:	02f4a223          	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800059f8:	00048513          	mv	a0,s1
    800059fc:	ffffb097          	auipc	ra,0xffffb
    80005a00:	664080e7          	jalr	1636(ra) # 80001060 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80005a04:	02c4a783          	lw	a5,44(s1)
    80005a08:	08f04663          	bgtz	a5,80005a94 <end_op+0x100>
    acquire(&log.lock);
    80005a0c:	0001d497          	auipc	s1,0x1d
    80005a10:	16c48493          	addi	s1,s1,364 # 80022b78 <log>
    80005a14:	00048513          	mv	a0,s1
    80005a18:	ffffb097          	auipc	ra,0xffffb
    80005a1c:	550080e7          	jalr	1360(ra) # 80000f68 <acquire>
    log.committing = 0;
    80005a20:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80005a24:	00048513          	mv	a0,s1
    80005a28:	ffffd097          	auipc	ra,0xffffd
    80005a2c:	554080e7          	jalr	1364(ra) # 80002f7c <wakeup>
    release(&log.lock);
    80005a30:	00048513          	mv	a0,s1
    80005a34:	ffffb097          	auipc	ra,0xffffb
    80005a38:	62c080e7          	jalr	1580(ra) # 80001060 <release>
}
    80005a3c:	0340006f          	j	80005a70 <end_op+0xdc>
    panic("log.committing");
    80005a40:	00005517          	auipc	a0,0x5
    80005a44:	be050513          	addi	a0,a0,-1056 # 8000a620 <syscalls+0x1e0>
    80005a48:	ffffb097          	auipc	ra,0xffffb
    80005a4c:	c84080e7          	jalr	-892(ra) # 800006cc <panic>
    wakeup(&log);
    80005a50:	0001d497          	auipc	s1,0x1d
    80005a54:	12848493          	addi	s1,s1,296 # 80022b78 <log>
    80005a58:	00048513          	mv	a0,s1
    80005a5c:	ffffd097          	auipc	ra,0xffffd
    80005a60:	520080e7          	jalr	1312(ra) # 80002f7c <wakeup>
  release(&log.lock);
    80005a64:	00048513          	mv	a0,s1
    80005a68:	ffffb097          	auipc	ra,0xffffb
    80005a6c:	5f8080e7          	jalr	1528(ra) # 80001060 <release>
}
    80005a70:	03813083          	ld	ra,56(sp)
    80005a74:	03013403          	ld	s0,48(sp)
    80005a78:	02813483          	ld	s1,40(sp)
    80005a7c:	02013903          	ld	s2,32(sp)
    80005a80:	01813983          	ld	s3,24(sp)
    80005a84:	01013a03          	ld	s4,16(sp)
    80005a88:	00813a83          	ld	s5,8(sp)
    80005a8c:	04010113          	addi	sp,sp,64
    80005a90:	00008067          	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80005a94:	0001da97          	auipc	s5,0x1d
    80005a98:	114a8a93          	addi	s5,s5,276 # 80022ba8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80005a9c:	0001da17          	auipc	s4,0x1d
    80005aa0:	0dca0a13          	addi	s4,s4,220 # 80022b78 <log>
    80005aa4:	018a2583          	lw	a1,24(s4)
    80005aa8:	012585bb          	addw	a1,a1,s2
    80005aac:	0015859b          	addiw	a1,a1,1
    80005ab0:	028a2503          	lw	a0,40(s4)
    80005ab4:	ffffe097          	auipc	ra,0xffffe
    80005ab8:	568080e7          	jalr	1384(ra) # 8000401c <bread>
    80005abc:	00050493          	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80005ac0:	000aa583          	lw	a1,0(s5)
    80005ac4:	028a2503          	lw	a0,40(s4)
    80005ac8:	ffffe097          	auipc	ra,0xffffe
    80005acc:	554080e7          	jalr	1364(ra) # 8000401c <bread>
    80005ad0:	00050993          	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80005ad4:	40000613          	li	a2,1024
    80005ad8:	06050593          	addi	a1,a0,96
    80005adc:	06048513          	addi	a0,s1,96
    80005ae0:	ffffb097          	auipc	ra,0xffffb
    80005ae4:	674080e7          	jalr	1652(ra) # 80001154 <memmove>
    bwrite(to);  // write the log
    80005ae8:	00048513          	mv	a0,s1
    80005aec:	ffffe097          	auipc	ra,0xffffe
    80005af0:	668080e7          	jalr	1640(ra) # 80004154 <bwrite>
    brelse(from);
    80005af4:	00098513          	mv	a0,s3
    80005af8:	ffffe097          	auipc	ra,0xffffe
    80005afc:	6c0080e7          	jalr	1728(ra) # 800041b8 <brelse>
    brelse(to);
    80005b00:	00048513          	mv	a0,s1
    80005b04:	ffffe097          	auipc	ra,0xffffe
    80005b08:	6b4080e7          	jalr	1716(ra) # 800041b8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005b0c:	0019091b          	addiw	s2,s2,1
    80005b10:	004a8a93          	addi	s5,s5,4
    80005b14:	02ca2783          	lw	a5,44(s4)
    80005b18:	f8f946e3          	blt	s2,a5,80005aa4 <end_op+0x110>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80005b1c:	00000097          	auipc	ra,0x0
    80005b20:	b34080e7          	jalr	-1228(ra) # 80005650 <write_head>
    install_trans(0); // Now install writes to home locations
    80005b24:	00000513          	li	a0,0
    80005b28:	00000097          	auipc	ra,0x0
    80005b2c:	bd0080e7          	jalr	-1072(ra) # 800056f8 <install_trans>
    log.lh.n = 0;
    80005b30:	0001d797          	auipc	a5,0x1d
    80005b34:	0607aa23          	sw	zero,116(a5) # 80022ba4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80005b38:	00000097          	auipc	ra,0x0
    80005b3c:	b18080e7          	jalr	-1256(ra) # 80005650 <write_head>
    80005b40:	ecdff06f          	j	80005a0c <end_op+0x78>

0000000080005b44 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80005b44:	fe010113          	addi	sp,sp,-32
    80005b48:	00113c23          	sd	ra,24(sp)
    80005b4c:	00813823          	sd	s0,16(sp)
    80005b50:	00913423          	sd	s1,8(sp)
    80005b54:	01213023          	sd	s2,0(sp)
    80005b58:	02010413          	addi	s0,sp,32
    80005b5c:	00050493          	mv	s1,a0
  int i;

  acquire(&log.lock);
    80005b60:	0001d917          	auipc	s2,0x1d
    80005b64:	01890913          	addi	s2,s2,24 # 80022b78 <log>
    80005b68:	00090513          	mv	a0,s2
    80005b6c:	ffffb097          	auipc	ra,0xffffb
    80005b70:	3fc080e7          	jalr	1020(ra) # 80000f68 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80005b74:	02c92603          	lw	a2,44(s2)
    80005b78:	01d00793          	li	a5,29
    80005b7c:	08c7c663          	blt	a5,a2,80005c08 <log_write+0xc4>
    80005b80:	0001d797          	auipc	a5,0x1d
    80005b84:	0147a783          	lw	a5,20(a5) # 80022b94 <log+0x1c>
    80005b88:	fff7879b          	addiw	a5,a5,-1
    80005b8c:	06f65e63          	bge	a2,a5,80005c08 <log_write+0xc4>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80005b90:	0001d797          	auipc	a5,0x1d
    80005b94:	0087a783          	lw	a5,8(a5) # 80022b98 <log+0x20>
    80005b98:	08f05063          	blez	a5,80005c18 <log_write+0xd4>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80005b9c:	00000793          	li	a5,0
    80005ba0:	08c05463          	blez	a2,80005c28 <log_write+0xe4>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80005ba4:	0084a583          	lw	a1,8(s1)
    80005ba8:	0001d717          	auipc	a4,0x1d
    80005bac:	00070713          	mv	a4,a4
  for (i = 0; i < log.lh.n; i++) {
    80005bb0:	00000793          	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80005bb4:	00072683          	lw	a3,0(a4) # 80022ba8 <log+0x30>
    80005bb8:	06b68863          	beq	a3,a1,80005c28 <log_write+0xe4>
  for (i = 0; i < log.lh.n; i++) {
    80005bbc:	0017879b          	addiw	a5,a5,1
    80005bc0:	00470713          	addi	a4,a4,4
    80005bc4:	fef618e3          	bne	a2,a5,80005bb4 <log_write+0x70>
      break;
  }
  log.lh.block[i] = b->blockno;
    80005bc8:	00860613          	addi	a2,a2,8
    80005bcc:	00261613          	slli	a2,a2,0x2
    80005bd0:	0001d797          	auipc	a5,0x1d
    80005bd4:	fa878793          	addi	a5,a5,-88 # 80022b78 <log>
    80005bd8:	00c78633          	add	a2,a5,a2
    80005bdc:	0084a783          	lw	a5,8(s1)
    80005be0:	00f62823          	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80005be4:	00048513          	mv	a0,s1
    80005be8:	ffffe097          	auipc	ra,0xffffe
    80005bec:	6a8080e7          	jalr	1704(ra) # 80004290 <bpin>
    log.lh.n++;
    80005bf0:	0001d717          	auipc	a4,0x1d
    80005bf4:	f8870713          	addi	a4,a4,-120 # 80022b78 <log>
    80005bf8:	02c72783          	lw	a5,44(a4)
    80005bfc:	0017879b          	addiw	a5,a5,1
    80005c00:	02f72623          	sw	a5,44(a4)
    80005c04:	0440006f          	j	80005c48 <log_write+0x104>
    panic("too big a transaction");
    80005c08:	00005517          	auipc	a0,0x5
    80005c0c:	a2850513          	addi	a0,a0,-1496 # 8000a630 <syscalls+0x1f0>
    80005c10:	ffffb097          	auipc	ra,0xffffb
    80005c14:	abc080e7          	jalr	-1348(ra) # 800006cc <panic>
    panic("log_write outside of trans");
    80005c18:	00005517          	auipc	a0,0x5
    80005c1c:	a3050513          	addi	a0,a0,-1488 # 8000a648 <syscalls+0x208>
    80005c20:	ffffb097          	auipc	ra,0xffffb
    80005c24:	aac080e7          	jalr	-1364(ra) # 800006cc <panic>
  log.lh.block[i] = b->blockno;
    80005c28:	00878713          	addi	a4,a5,8
    80005c2c:	00271693          	slli	a3,a4,0x2
    80005c30:	0001d717          	auipc	a4,0x1d
    80005c34:	f4870713          	addi	a4,a4,-184 # 80022b78 <log>
    80005c38:	00d70733          	add	a4,a4,a3
    80005c3c:	0084a683          	lw	a3,8(s1)
    80005c40:	00d72823          	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80005c44:	faf600e3          	beq	a2,a5,80005be4 <log_write+0xa0>
  }
  release(&log.lock);
    80005c48:	0001d517          	auipc	a0,0x1d
    80005c4c:	f3050513          	addi	a0,a0,-208 # 80022b78 <log>
    80005c50:	ffffb097          	auipc	ra,0xffffb
    80005c54:	410080e7          	jalr	1040(ra) # 80001060 <release>
}
    80005c58:	01813083          	ld	ra,24(sp)
    80005c5c:	01013403          	ld	s0,16(sp)
    80005c60:	00813483          	ld	s1,8(sp)
    80005c64:	00013903          	ld	s2,0(sp)
    80005c68:	02010113          	addi	sp,sp,32
    80005c6c:	00008067          	ret

0000000080005c70 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80005c70:	fe010113          	addi	sp,sp,-32
    80005c74:	00113c23          	sd	ra,24(sp)
    80005c78:	00813823          	sd	s0,16(sp)
    80005c7c:	00913423          	sd	s1,8(sp)
    80005c80:	01213023          	sd	s2,0(sp)
    80005c84:	02010413          	addi	s0,sp,32
    80005c88:	00050493          	mv	s1,a0
    80005c8c:	00058913          	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80005c90:	00005597          	auipc	a1,0x5
    80005c94:	9d858593          	addi	a1,a1,-1576 # 8000a668 <syscalls+0x228>
    80005c98:	00850513          	addi	a0,a0,8
    80005c9c:	ffffb097          	auipc	ra,0xffffb
    80005ca0:	1e8080e7          	jalr	488(ra) # 80000e84 <initlock>
  lk->name = name;
    80005ca4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80005ca8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005cac:	0204a423          	sw	zero,40(s1)
}
    80005cb0:	01813083          	ld	ra,24(sp)
    80005cb4:	01013403          	ld	s0,16(sp)
    80005cb8:	00813483          	ld	s1,8(sp)
    80005cbc:	00013903          	ld	s2,0(sp)
    80005cc0:	02010113          	addi	sp,sp,32
    80005cc4:	00008067          	ret

0000000080005cc8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80005cc8:	fe010113          	addi	sp,sp,-32
    80005ccc:	00113c23          	sd	ra,24(sp)
    80005cd0:	00813823          	sd	s0,16(sp)
    80005cd4:	00913423          	sd	s1,8(sp)
    80005cd8:	01213023          	sd	s2,0(sp)
    80005cdc:	02010413          	addi	s0,sp,32
    80005ce0:	00050493          	mv	s1,a0
  acquire(&lk->lk);
    80005ce4:	00850913          	addi	s2,a0,8
    80005ce8:	00090513          	mv	a0,s2
    80005cec:	ffffb097          	auipc	ra,0xffffb
    80005cf0:	27c080e7          	jalr	636(ra) # 80000f68 <acquire>
  while (lk->locked) {
    80005cf4:	0004a783          	lw	a5,0(s1)
    80005cf8:	00078e63          	beqz	a5,80005d14 <acquiresleep+0x4c>
    sleep(lk, &lk->lk);
    80005cfc:	00090593          	mv	a1,s2
    80005d00:	00048513          	mv	a0,s1
    80005d04:	ffffd097          	auipc	ra,0xffffd
    80005d08:	058080e7          	jalr	88(ra) # 80002d5c <sleep>
  while (lk->locked) {
    80005d0c:	0004a783          	lw	a5,0(s1)
    80005d10:	fe0796e3          	bnez	a5,80005cfc <acquiresleep+0x34>
  }
  lk->locked = 1;
    80005d14:	00100793          	li	a5,1
    80005d18:	00f4a023          	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80005d1c:	ffffc097          	auipc	ra,0xffffc
    80005d20:	6d0080e7          	jalr	1744(ra) # 800023ec <myproc>
    80005d24:	03052783          	lw	a5,48(a0)
    80005d28:	02f4a423          	sw	a5,40(s1)
  release(&lk->lk);
    80005d2c:	00090513          	mv	a0,s2
    80005d30:	ffffb097          	auipc	ra,0xffffb
    80005d34:	330080e7          	jalr	816(ra) # 80001060 <release>
}
    80005d38:	01813083          	ld	ra,24(sp)
    80005d3c:	01013403          	ld	s0,16(sp)
    80005d40:	00813483          	ld	s1,8(sp)
    80005d44:	00013903          	ld	s2,0(sp)
    80005d48:	02010113          	addi	sp,sp,32
    80005d4c:	00008067          	ret

0000000080005d50 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80005d50:	fe010113          	addi	sp,sp,-32
    80005d54:	00113c23          	sd	ra,24(sp)
    80005d58:	00813823          	sd	s0,16(sp)
    80005d5c:	00913423          	sd	s1,8(sp)
    80005d60:	01213023          	sd	s2,0(sp)
    80005d64:	02010413          	addi	s0,sp,32
    80005d68:	00050493          	mv	s1,a0
  acquire(&lk->lk);
    80005d6c:	00850913          	addi	s2,a0,8
    80005d70:	00090513          	mv	a0,s2
    80005d74:	ffffb097          	auipc	ra,0xffffb
    80005d78:	1f4080e7          	jalr	500(ra) # 80000f68 <acquire>
  lk->locked = 0;
    80005d7c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005d80:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80005d84:	00048513          	mv	a0,s1
    80005d88:	ffffd097          	auipc	ra,0xffffd
    80005d8c:	1f4080e7          	jalr	500(ra) # 80002f7c <wakeup>
  release(&lk->lk);
    80005d90:	00090513          	mv	a0,s2
    80005d94:	ffffb097          	auipc	ra,0xffffb
    80005d98:	2cc080e7          	jalr	716(ra) # 80001060 <release>
}
    80005d9c:	01813083          	ld	ra,24(sp)
    80005da0:	01013403          	ld	s0,16(sp)
    80005da4:	00813483          	ld	s1,8(sp)
    80005da8:	00013903          	ld	s2,0(sp)
    80005dac:	02010113          	addi	sp,sp,32
    80005db0:	00008067          	ret

0000000080005db4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80005db4:	fd010113          	addi	sp,sp,-48
    80005db8:	02113423          	sd	ra,40(sp)
    80005dbc:	02813023          	sd	s0,32(sp)
    80005dc0:	00913c23          	sd	s1,24(sp)
    80005dc4:	01213823          	sd	s2,16(sp)
    80005dc8:	01313423          	sd	s3,8(sp)
    80005dcc:	03010413          	addi	s0,sp,48
    80005dd0:	00050493          	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80005dd4:	00850913          	addi	s2,a0,8
    80005dd8:	00090513          	mv	a0,s2
    80005ddc:	ffffb097          	auipc	ra,0xffffb
    80005de0:	18c080e7          	jalr	396(ra) # 80000f68 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80005de4:	0004a783          	lw	a5,0(s1)
    80005de8:	02079a63          	bnez	a5,80005e1c <holdingsleep+0x68>
    80005dec:	00000493          	li	s1,0
  release(&lk->lk);
    80005df0:	00090513          	mv	a0,s2
    80005df4:	ffffb097          	auipc	ra,0xffffb
    80005df8:	26c080e7          	jalr	620(ra) # 80001060 <release>
  return r;
}
    80005dfc:	00048513          	mv	a0,s1
    80005e00:	02813083          	ld	ra,40(sp)
    80005e04:	02013403          	ld	s0,32(sp)
    80005e08:	01813483          	ld	s1,24(sp)
    80005e0c:	01013903          	ld	s2,16(sp)
    80005e10:	00813983          	ld	s3,8(sp)
    80005e14:	03010113          	addi	sp,sp,48
    80005e18:	00008067          	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80005e1c:	0284a983          	lw	s3,40(s1)
    80005e20:	ffffc097          	auipc	ra,0xffffc
    80005e24:	5cc080e7          	jalr	1484(ra) # 800023ec <myproc>
    80005e28:	03052483          	lw	s1,48(a0)
    80005e2c:	413484b3          	sub	s1,s1,s3
    80005e30:	0014b493          	seqz	s1,s1
    80005e34:	fbdff06f          	j	80005df0 <holdingsleep+0x3c>

0000000080005e38 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005e38:	ff010113          	addi	sp,sp,-16
    80005e3c:	00113423          	sd	ra,8(sp)
    80005e40:	00813023          	sd	s0,0(sp)
    80005e44:	01010413          	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005e48:	00005597          	auipc	a1,0x5
    80005e4c:	83058593          	addi	a1,a1,-2000 # 8000a678 <syscalls+0x238>
    80005e50:	0001d517          	auipc	a0,0x1d
    80005e54:	e7050513          	addi	a0,a0,-400 # 80022cc0 <ftable>
    80005e58:	ffffb097          	auipc	ra,0xffffb
    80005e5c:	02c080e7          	jalr	44(ra) # 80000e84 <initlock>
}
    80005e60:	00813083          	ld	ra,8(sp)
    80005e64:	00013403          	ld	s0,0(sp)
    80005e68:	01010113          	addi	sp,sp,16
    80005e6c:	00008067          	ret

0000000080005e70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80005e70:	fe010113          	addi	sp,sp,-32
    80005e74:	00113c23          	sd	ra,24(sp)
    80005e78:	00813823          	sd	s0,16(sp)
    80005e7c:	00913423          	sd	s1,8(sp)
    80005e80:	02010413          	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80005e84:	0001d517          	auipc	a0,0x1d
    80005e88:	e3c50513          	addi	a0,a0,-452 # 80022cc0 <ftable>
    80005e8c:	ffffb097          	auipc	ra,0xffffb
    80005e90:	0dc080e7          	jalr	220(ra) # 80000f68 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005e94:	0001d497          	auipc	s1,0x1d
    80005e98:	e4448493          	addi	s1,s1,-444 # 80022cd8 <ftable+0x18>
    80005e9c:	0001e717          	auipc	a4,0x1e
    80005ea0:	ddc70713          	addi	a4,a4,-548 # 80023c78 <end>
    if(f->ref == 0){
    80005ea4:	0044a783          	lw	a5,4(s1)
    80005ea8:	02078263          	beqz	a5,80005ecc <filealloc+0x5c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005eac:	02848493          	addi	s1,s1,40
    80005eb0:	fee49ae3          	bne	s1,a4,80005ea4 <filealloc+0x34>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80005eb4:	0001d517          	auipc	a0,0x1d
    80005eb8:	e0c50513          	addi	a0,a0,-500 # 80022cc0 <ftable>
    80005ebc:	ffffb097          	auipc	ra,0xffffb
    80005ec0:	1a4080e7          	jalr	420(ra) # 80001060 <release>
  return 0;
    80005ec4:	00000493          	li	s1,0
    80005ec8:	01c0006f          	j	80005ee4 <filealloc+0x74>
      f->ref = 1;
    80005ecc:	00100793          	li	a5,1
    80005ed0:	00f4a223          	sw	a5,4(s1)
      release(&ftable.lock);
    80005ed4:	0001d517          	auipc	a0,0x1d
    80005ed8:	dec50513          	addi	a0,a0,-532 # 80022cc0 <ftable>
    80005edc:	ffffb097          	auipc	ra,0xffffb
    80005ee0:	184080e7          	jalr	388(ra) # 80001060 <release>
}
    80005ee4:	00048513          	mv	a0,s1
    80005ee8:	01813083          	ld	ra,24(sp)
    80005eec:	01013403          	ld	s0,16(sp)
    80005ef0:	00813483          	ld	s1,8(sp)
    80005ef4:	02010113          	addi	sp,sp,32
    80005ef8:	00008067          	ret

0000000080005efc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80005efc:	fe010113          	addi	sp,sp,-32
    80005f00:	00113c23          	sd	ra,24(sp)
    80005f04:	00813823          	sd	s0,16(sp)
    80005f08:	00913423          	sd	s1,8(sp)
    80005f0c:	02010413          	addi	s0,sp,32
    80005f10:	00050493          	mv	s1,a0
  acquire(&ftable.lock);
    80005f14:	0001d517          	auipc	a0,0x1d
    80005f18:	dac50513          	addi	a0,a0,-596 # 80022cc0 <ftable>
    80005f1c:	ffffb097          	auipc	ra,0xffffb
    80005f20:	04c080e7          	jalr	76(ra) # 80000f68 <acquire>
  if(f->ref < 1)
    80005f24:	0044a783          	lw	a5,4(s1)
    80005f28:	02f05a63          	blez	a5,80005f5c <filedup+0x60>
    panic("filedup");
  f->ref++;
    80005f2c:	0017879b          	addiw	a5,a5,1
    80005f30:	00f4a223          	sw	a5,4(s1)
  release(&ftable.lock);
    80005f34:	0001d517          	auipc	a0,0x1d
    80005f38:	d8c50513          	addi	a0,a0,-628 # 80022cc0 <ftable>
    80005f3c:	ffffb097          	auipc	ra,0xffffb
    80005f40:	124080e7          	jalr	292(ra) # 80001060 <release>
  return f;
}
    80005f44:	00048513          	mv	a0,s1
    80005f48:	01813083          	ld	ra,24(sp)
    80005f4c:	01013403          	ld	s0,16(sp)
    80005f50:	00813483          	ld	s1,8(sp)
    80005f54:	02010113          	addi	sp,sp,32
    80005f58:	00008067          	ret
    panic("filedup");
    80005f5c:	00004517          	auipc	a0,0x4
    80005f60:	72450513          	addi	a0,a0,1828 # 8000a680 <syscalls+0x240>
    80005f64:	ffffa097          	auipc	ra,0xffffa
    80005f68:	768080e7          	jalr	1896(ra) # 800006cc <panic>

0000000080005f6c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80005f6c:	fc010113          	addi	sp,sp,-64
    80005f70:	02113c23          	sd	ra,56(sp)
    80005f74:	02813823          	sd	s0,48(sp)
    80005f78:	02913423          	sd	s1,40(sp)
    80005f7c:	03213023          	sd	s2,32(sp)
    80005f80:	01313c23          	sd	s3,24(sp)
    80005f84:	01413823          	sd	s4,16(sp)
    80005f88:	01513423          	sd	s5,8(sp)
    80005f8c:	04010413          	addi	s0,sp,64
    80005f90:	00050493          	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005f94:	0001d517          	auipc	a0,0x1d
    80005f98:	d2c50513          	addi	a0,a0,-724 # 80022cc0 <ftable>
    80005f9c:	ffffb097          	auipc	ra,0xffffb
    80005fa0:	fcc080e7          	jalr	-52(ra) # 80000f68 <acquire>
  if(f->ref < 1)
    80005fa4:	0044a783          	lw	a5,4(s1)
    80005fa8:	06f05863          	blez	a5,80006018 <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
    80005fac:	fff7879b          	addiw	a5,a5,-1
    80005fb0:	0007871b          	sext.w	a4,a5
    80005fb4:	00f4a223          	sw	a5,4(s1)
    80005fb8:	06e04863          	bgtz	a4,80006028 <fileclose+0xbc>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80005fbc:	0004a903          	lw	s2,0(s1)
    80005fc0:	0094ca83          	lbu	s5,9(s1)
    80005fc4:	0104ba03          	ld	s4,16(s1)
    80005fc8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80005fcc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80005fd0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80005fd4:	0001d517          	auipc	a0,0x1d
    80005fd8:	cec50513          	addi	a0,a0,-788 # 80022cc0 <ftable>
    80005fdc:	ffffb097          	auipc	ra,0xffffb
    80005fe0:	084080e7          	jalr	132(ra) # 80001060 <release>

  if(ff.type == FD_PIPE){
    80005fe4:	00100793          	li	a5,1
    80005fe8:	06f90a63          	beq	s2,a5,8000605c <fileclose+0xf0>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80005fec:	ffe9091b          	addiw	s2,s2,-2
    80005ff0:	00100793          	li	a5,1
    80005ff4:	0527e263          	bltu	a5,s2,80006038 <fileclose+0xcc>
    begin_op();
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	8e8080e7          	jalr	-1816(ra) # 800058e0 <begin_op>
    iput(ff.ip);
    80006000:	00098513          	mv	a0,s3
    80006004:	fffff097          	auipc	ra,0xfffff
    80006008:	d54080e7          	jalr	-684(ra) # 80004d58 <iput>
    end_op();
    8000600c:	00000097          	auipc	ra,0x0
    80006010:	988080e7          	jalr	-1656(ra) # 80005994 <end_op>
    80006014:	0240006f          	j	80006038 <fileclose+0xcc>
    panic("fileclose");
    80006018:	00004517          	auipc	a0,0x4
    8000601c:	67050513          	addi	a0,a0,1648 # 8000a688 <syscalls+0x248>
    80006020:	ffffa097          	auipc	ra,0xffffa
    80006024:	6ac080e7          	jalr	1708(ra) # 800006cc <panic>
    release(&ftable.lock);
    80006028:	0001d517          	auipc	a0,0x1d
    8000602c:	c9850513          	addi	a0,a0,-872 # 80022cc0 <ftable>
    80006030:	ffffb097          	auipc	ra,0xffffb
    80006034:	030080e7          	jalr	48(ra) # 80001060 <release>
  }
}
    80006038:	03813083          	ld	ra,56(sp)
    8000603c:	03013403          	ld	s0,48(sp)
    80006040:	02813483          	ld	s1,40(sp)
    80006044:	02013903          	ld	s2,32(sp)
    80006048:	01813983          	ld	s3,24(sp)
    8000604c:	01013a03          	ld	s4,16(sp)
    80006050:	00813a83          	ld	s5,8(sp)
    80006054:	04010113          	addi	sp,sp,64
    80006058:	00008067          	ret
    pipeclose(ff.pipe, ff.writable);
    8000605c:	000a8593          	mv	a1,s5
    80006060:	000a0513          	mv	a0,s4
    80006064:	00000097          	auipc	ra,0x0
    80006068:	4c4080e7          	jalr	1220(ra) # 80006528 <pipeclose>
    8000606c:	fcdff06f          	j	80006038 <fileclose+0xcc>

0000000080006070 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80006070:	fb010113          	addi	sp,sp,-80
    80006074:	04113423          	sd	ra,72(sp)
    80006078:	04813023          	sd	s0,64(sp)
    8000607c:	02913c23          	sd	s1,56(sp)
    80006080:	03213823          	sd	s2,48(sp)
    80006084:	03313423          	sd	s3,40(sp)
    80006088:	05010413          	addi	s0,sp,80
    8000608c:	00050493          	mv	s1,a0
    80006090:	00058993          	mv	s3,a1
  struct proc *p = myproc();
    80006094:	ffffc097          	auipc	ra,0xffffc
    80006098:	358080e7          	jalr	856(ra) # 800023ec <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000609c:	0004a783          	lw	a5,0(s1)
    800060a0:	ffe7879b          	addiw	a5,a5,-2
    800060a4:	00100713          	li	a4,1
    800060a8:	06f76463          	bltu	a4,a5,80006110 <filestat+0xa0>
    800060ac:	00050913          	mv	s2,a0
    ilock(f->ip);
    800060b0:	0184b503          	ld	a0,24(s1)
    800060b4:	fffff097          	auipc	ra,0xfffff
    800060b8:	a44080e7          	jalr	-1468(ra) # 80004af8 <ilock>
    stati(f->ip, &st);
    800060bc:	fb840593          	addi	a1,s0,-72
    800060c0:	0184b503          	ld	a0,24(s1)
    800060c4:	fffff097          	auipc	ra,0xfffff
    800060c8:	db0080e7          	jalr	-592(ra) # 80004e74 <stati>
    iunlock(f->ip);
    800060cc:	0184b503          	ld	a0,24(s1)
    800060d0:	fffff097          	auipc	ra,0xfffff
    800060d4:	b2c080e7          	jalr	-1236(ra) # 80004bfc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800060d8:	01800693          	li	a3,24
    800060dc:	fb840613          	addi	a2,s0,-72
    800060e0:	00098593          	mv	a1,s3
    800060e4:	05093503          	ld	a0,80(s2)
    800060e8:	ffffc097          	auipc	ra,0xffffc
    800060ec:	e0c080e7          	jalr	-500(ra) # 80001ef4 <copyout>
    800060f0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800060f4:	04813083          	ld	ra,72(sp)
    800060f8:	04013403          	ld	s0,64(sp)
    800060fc:	03813483          	ld	s1,56(sp)
    80006100:	03013903          	ld	s2,48(sp)
    80006104:	02813983          	ld	s3,40(sp)
    80006108:	05010113          	addi	sp,sp,80
    8000610c:	00008067          	ret
  return -1;
    80006110:	fff00513          	li	a0,-1
    80006114:	fe1ff06f          	j	800060f4 <filestat+0x84>

0000000080006118 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80006118:	fd010113          	addi	sp,sp,-48
    8000611c:	02113423          	sd	ra,40(sp)
    80006120:	02813023          	sd	s0,32(sp)
    80006124:	00913c23          	sd	s1,24(sp)
    80006128:	01213823          	sd	s2,16(sp)
    8000612c:	01313423          	sd	s3,8(sp)
    80006130:	03010413          	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80006134:	00854783          	lbu	a5,8(a0)
    80006138:	0e078a63          	beqz	a5,8000622c <fileread+0x114>
    8000613c:	00050493          	mv	s1,a0
    80006140:	00058993          	mv	s3,a1
    80006144:	00060913          	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80006148:	00052783          	lw	a5,0(a0)
    8000614c:	00100713          	li	a4,1
    80006150:	06e78e63          	beq	a5,a4,800061cc <fileread+0xb4>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80006154:	00300713          	li	a4,3
    80006158:	08e78463          	beq	a5,a4,800061e0 <fileread+0xc8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000615c:	00200713          	li	a4,2
    80006160:	0ae79e63          	bne	a5,a4,8000621c <fileread+0x104>
    ilock(f->ip);
    80006164:	01853503          	ld	a0,24(a0)
    80006168:	fffff097          	auipc	ra,0xfffff
    8000616c:	990080e7          	jalr	-1648(ra) # 80004af8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80006170:	00090713          	mv	a4,s2
    80006174:	0204a683          	lw	a3,32(s1)
    80006178:	00098613          	mv	a2,s3
    8000617c:	00100593          	li	a1,1
    80006180:	0184b503          	ld	a0,24(s1)
    80006184:	fffff097          	auipc	ra,0xfffff
    80006188:	d30080e7          	jalr	-720(ra) # 80004eb4 <readi>
    8000618c:	00050913          	mv	s2,a0
    80006190:	00a05863          	blez	a0,800061a0 <fileread+0x88>
      f->off += r;
    80006194:	0204a783          	lw	a5,32(s1)
    80006198:	00a787bb          	addw	a5,a5,a0
    8000619c:	02f4a023          	sw	a5,32(s1)
    iunlock(f->ip);
    800061a0:	0184b503          	ld	a0,24(s1)
    800061a4:	fffff097          	auipc	ra,0xfffff
    800061a8:	a58080e7          	jalr	-1448(ra) # 80004bfc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800061ac:	00090513          	mv	a0,s2
    800061b0:	02813083          	ld	ra,40(sp)
    800061b4:	02013403          	ld	s0,32(sp)
    800061b8:	01813483          	ld	s1,24(sp)
    800061bc:	01013903          	ld	s2,16(sp)
    800061c0:	00813983          	ld	s3,8(sp)
    800061c4:	03010113          	addi	sp,sp,48
    800061c8:	00008067          	ret
    r = piperead(f->pipe, addr, n);
    800061cc:	01053503          	ld	a0,16(a0)
    800061d0:	00000097          	auipc	ra,0x0
    800061d4:	540080e7          	jalr	1344(ra) # 80006710 <piperead>
    800061d8:	00050913          	mv	s2,a0
    800061dc:	fd1ff06f          	j	800061ac <fileread+0x94>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800061e0:	02451783          	lh	a5,36(a0)
    800061e4:	03079693          	slli	a3,a5,0x30
    800061e8:	0306d693          	srli	a3,a3,0x30
    800061ec:	00900713          	li	a4,9
    800061f0:	04d76263          	bltu	a4,a3,80006234 <fileread+0x11c>
    800061f4:	00479793          	slli	a5,a5,0x4
    800061f8:	0001d717          	auipc	a4,0x1d
    800061fc:	a2870713          	addi	a4,a4,-1496 # 80022c20 <devsw>
    80006200:	00f707b3          	add	a5,a4,a5
    80006204:	0007b783          	ld	a5,0(a5)
    80006208:	02078a63          	beqz	a5,8000623c <fileread+0x124>
    r = devsw[f->major].read(1, addr, n);
    8000620c:	00100513          	li	a0,1
    80006210:	000780e7          	jalr	a5
    80006214:	00050913          	mv	s2,a0
    80006218:	f95ff06f          	j	800061ac <fileread+0x94>
    panic("fileread");
    8000621c:	00004517          	auipc	a0,0x4
    80006220:	47c50513          	addi	a0,a0,1148 # 8000a698 <syscalls+0x258>
    80006224:	ffffa097          	auipc	ra,0xffffa
    80006228:	4a8080e7          	jalr	1192(ra) # 800006cc <panic>
    return -1;
    8000622c:	fff00913          	li	s2,-1
    80006230:	f7dff06f          	j	800061ac <fileread+0x94>
      return -1;
    80006234:	fff00913          	li	s2,-1
    80006238:	f75ff06f          	j	800061ac <fileread+0x94>
    8000623c:	fff00913          	li	s2,-1
    80006240:	f6dff06f          	j	800061ac <fileread+0x94>

0000000080006244 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80006244:	fb010113          	addi	sp,sp,-80
    80006248:	04113423          	sd	ra,72(sp)
    8000624c:	04813023          	sd	s0,64(sp)
    80006250:	02913c23          	sd	s1,56(sp)
    80006254:	03213823          	sd	s2,48(sp)
    80006258:	03313423          	sd	s3,40(sp)
    8000625c:	03413023          	sd	s4,32(sp)
    80006260:	01513c23          	sd	s5,24(sp)
    80006264:	01613823          	sd	s6,16(sp)
    80006268:	01713423          	sd	s7,8(sp)
    8000626c:	01813023          	sd	s8,0(sp)
    80006270:	05010413          	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80006274:	00954783          	lbu	a5,9(a0)
    80006278:	16078663          	beqz	a5,800063e4 <filewrite+0x1a0>
    8000627c:	00050913          	mv	s2,a0
    80006280:	00058a93          	mv	s5,a1
    80006284:	00060a13          	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80006288:	00052783          	lw	a5,0(a0)
    8000628c:	00100713          	li	a4,1
    80006290:	02e78863          	beq	a5,a4,800062c0 <filewrite+0x7c>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80006294:	00300713          	li	a4,3
    80006298:	02e78e63          	beq	a5,a4,800062d4 <filewrite+0x90>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000629c:	00200713          	li	a4,2
    800062a0:	12e79a63          	bne	a5,a4,800063d4 <filewrite+0x190>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800062a4:	0ec05663          	blez	a2,80006390 <filewrite+0x14c>
    int i = 0;
    800062a8:	00000993          	li	s3,0
    800062ac:	00001b37          	lui	s6,0x1
    800062b0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800062b4:	00001bb7          	lui	s7,0x1
    800062b8:	c00b8b9b          	addiw	s7,s7,-1024
    800062bc:	0bc0006f          	j	80006378 <filewrite+0x134>
    ret = pipewrite(f->pipe, addr, n);
    800062c0:	01053503          	ld	a0,16(a0)
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	2fc080e7          	jalr	764(ra) # 800065c0 <pipewrite>
    800062cc:	00050a13          	mv	s4,a0
    800062d0:	0c80006f          	j	80006398 <filewrite+0x154>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800062d4:	02451783          	lh	a5,36(a0)
    800062d8:	03079693          	slli	a3,a5,0x30
    800062dc:	0306d693          	srli	a3,a3,0x30
    800062e0:	00900713          	li	a4,9
    800062e4:	10d76463          	bltu	a4,a3,800063ec <filewrite+0x1a8>
    800062e8:	00479793          	slli	a5,a5,0x4
    800062ec:	0001d717          	auipc	a4,0x1d
    800062f0:	93470713          	addi	a4,a4,-1740 # 80022c20 <devsw>
    800062f4:	00f707b3          	add	a5,a4,a5
    800062f8:	0087b783          	ld	a5,8(a5)
    800062fc:	0e078c63          	beqz	a5,800063f4 <filewrite+0x1b0>
    ret = devsw[f->major].write(1, addr, n);
    80006300:	00100513          	li	a0,1
    80006304:	000780e7          	jalr	a5
    80006308:	00050a13          	mv	s4,a0
    8000630c:	08c0006f          	j	80006398 <filewrite+0x154>
    80006310:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80006314:	fffff097          	auipc	ra,0xfffff
    80006318:	5cc080e7          	jalr	1484(ra) # 800058e0 <begin_op>
      ilock(f->ip);
    8000631c:	01893503          	ld	a0,24(s2)
    80006320:	ffffe097          	auipc	ra,0xffffe
    80006324:	7d8080e7          	jalr	2008(ra) # 80004af8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80006328:	000c0713          	mv	a4,s8
    8000632c:	02092683          	lw	a3,32(s2)
    80006330:	01598633          	add	a2,s3,s5
    80006334:	00100593          	li	a1,1
    80006338:	01893503          	ld	a0,24(s2)
    8000633c:	fffff097          	auipc	ra,0xfffff
    80006340:	ce8080e7          	jalr	-792(ra) # 80005024 <writei>
    80006344:	00050493          	mv	s1,a0
    80006348:	00a05863          	blez	a0,80006358 <filewrite+0x114>
        f->off += r;
    8000634c:	02092783          	lw	a5,32(s2)
    80006350:	00a787bb          	addw	a5,a5,a0
    80006354:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80006358:	01893503          	ld	a0,24(s2)
    8000635c:	fffff097          	auipc	ra,0xfffff
    80006360:	8a0080e7          	jalr	-1888(ra) # 80004bfc <iunlock>
      end_op();
    80006364:	fffff097          	auipc	ra,0xfffff
    80006368:	630080e7          	jalr	1584(ra) # 80005994 <end_op>

      if(r != n1){
    8000636c:	029c1463          	bne	s8,s1,80006394 <filewrite+0x150>
        // error from writei
        break;
      }
      i += r;
    80006370:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80006374:	0349d063          	bge	s3,s4,80006394 <filewrite+0x150>
      int n1 = n - i;
    80006378:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    8000637c:	00078493          	mv	s1,a5
    80006380:	0007879b          	sext.w	a5,a5
    80006384:	f8fb56e3          	bge	s6,a5,80006310 <filewrite+0xcc>
    80006388:	000b8493          	mv	s1,s7
    8000638c:	f85ff06f          	j	80006310 <filewrite+0xcc>
    int i = 0;
    80006390:	00000993          	li	s3,0
    }
    ret = (i == n ? n : -1);
    80006394:	033a1c63          	bne	s4,s3,800063cc <filewrite+0x188>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80006398:	000a0513          	mv	a0,s4
    8000639c:	04813083          	ld	ra,72(sp)
    800063a0:	04013403          	ld	s0,64(sp)
    800063a4:	03813483          	ld	s1,56(sp)
    800063a8:	03013903          	ld	s2,48(sp)
    800063ac:	02813983          	ld	s3,40(sp)
    800063b0:	02013a03          	ld	s4,32(sp)
    800063b4:	01813a83          	ld	s5,24(sp)
    800063b8:	01013b03          	ld	s6,16(sp)
    800063bc:	00813b83          	ld	s7,8(sp)
    800063c0:	00013c03          	ld	s8,0(sp)
    800063c4:	05010113          	addi	sp,sp,80
    800063c8:	00008067          	ret
    ret = (i == n ? n : -1);
    800063cc:	fff00a13          	li	s4,-1
    800063d0:	fc9ff06f          	j	80006398 <filewrite+0x154>
    panic("filewrite");
    800063d4:	00004517          	auipc	a0,0x4
    800063d8:	2d450513          	addi	a0,a0,724 # 8000a6a8 <syscalls+0x268>
    800063dc:	ffffa097          	auipc	ra,0xffffa
    800063e0:	2f0080e7          	jalr	752(ra) # 800006cc <panic>
    return -1;
    800063e4:	fff00a13          	li	s4,-1
    800063e8:	fb1ff06f          	j	80006398 <filewrite+0x154>
      return -1;
    800063ec:	fff00a13          	li	s4,-1
    800063f0:	fa9ff06f          	j	80006398 <filewrite+0x154>
    800063f4:	fff00a13          	li	s4,-1
    800063f8:	fa1ff06f          	j	80006398 <filewrite+0x154>

00000000800063fc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800063fc:	fd010113          	addi	sp,sp,-48
    80006400:	02113423          	sd	ra,40(sp)
    80006404:	02813023          	sd	s0,32(sp)
    80006408:	00913c23          	sd	s1,24(sp)
    8000640c:	01213823          	sd	s2,16(sp)
    80006410:	01313423          	sd	s3,8(sp)
    80006414:	01413023          	sd	s4,0(sp)
    80006418:	03010413          	addi	s0,sp,48
    8000641c:	00050493          	mv	s1,a0
    80006420:	00058a13          	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80006424:	0005b023          	sd	zero,0(a1)
    80006428:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000642c:	00000097          	auipc	ra,0x0
    80006430:	a44080e7          	jalr	-1468(ra) # 80005e70 <filealloc>
    80006434:	00a4b023          	sd	a0,0(s1)
    80006438:	0a050663          	beqz	a0,800064e4 <pipealloc+0xe8>
    8000643c:	00000097          	auipc	ra,0x0
    80006440:	a34080e7          	jalr	-1484(ra) # 80005e70 <filealloc>
    80006444:	00aa3023          	sd	a0,0(s4)
    80006448:	08050663          	beqz	a0,800064d4 <pipealloc+0xd8>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000644c:	ffffb097          	auipc	ra,0xffffb
    80006450:	9d4080e7          	jalr	-1580(ra) # 80000e20 <kalloc>
    80006454:	00050913          	mv	s2,a0
    80006458:	06050863          	beqz	a0,800064c8 <pipealloc+0xcc>
    goto bad;
  pi->readopen = 1;
    8000645c:	00100993          	li	s3,1
    80006460:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80006464:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80006468:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000646c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80006470:	00004597          	auipc	a1,0x4
    80006474:	24858593          	addi	a1,a1,584 # 8000a6b8 <syscalls+0x278>
    80006478:	ffffb097          	auipc	ra,0xffffb
    8000647c:	a0c080e7          	jalr	-1524(ra) # 80000e84 <initlock>
  (*f0)->type = FD_PIPE;
    80006480:	0004b783          	ld	a5,0(s1)
    80006484:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80006488:	0004b783          	ld	a5,0(s1)
    8000648c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80006490:	0004b783          	ld	a5,0(s1)
    80006494:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80006498:	0004b783          	ld	a5,0(s1)
    8000649c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800064a0:	000a3783          	ld	a5,0(s4)
    800064a4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800064a8:	000a3783          	ld	a5,0(s4)
    800064ac:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800064b0:	000a3783          	ld	a5,0(s4)
    800064b4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800064b8:	000a3783          	ld	a5,0(s4)
    800064bc:	0127b823          	sd	s2,16(a5)
  return 0;
    800064c0:	00000513          	li	a0,0
    800064c4:	03c0006f          	j	80006500 <pipealloc+0x104>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800064c8:	0004b503          	ld	a0,0(s1)
    800064cc:	00051863          	bnez	a0,800064dc <pipealloc+0xe0>
    800064d0:	0140006f          	j	800064e4 <pipealloc+0xe8>
    800064d4:	0004b503          	ld	a0,0(s1)
    800064d8:	04050463          	beqz	a0,80006520 <pipealloc+0x124>
    fileclose(*f0);
    800064dc:	00000097          	auipc	ra,0x0
    800064e0:	a90080e7          	jalr	-1392(ra) # 80005f6c <fileclose>
  if(*f1)
    800064e4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800064e8:	fff00513          	li	a0,-1
  if(*f1)
    800064ec:	00078a63          	beqz	a5,80006500 <pipealloc+0x104>
    fileclose(*f1);
    800064f0:	00078513          	mv	a0,a5
    800064f4:	00000097          	auipc	ra,0x0
    800064f8:	a78080e7          	jalr	-1416(ra) # 80005f6c <fileclose>
  return -1;
    800064fc:	fff00513          	li	a0,-1
}
    80006500:	02813083          	ld	ra,40(sp)
    80006504:	02013403          	ld	s0,32(sp)
    80006508:	01813483          	ld	s1,24(sp)
    8000650c:	01013903          	ld	s2,16(sp)
    80006510:	00813983          	ld	s3,8(sp)
    80006514:	00013a03          	ld	s4,0(sp)
    80006518:	03010113          	addi	sp,sp,48
    8000651c:	00008067          	ret
  return -1;
    80006520:	fff00513          	li	a0,-1
    80006524:	fddff06f          	j	80006500 <pipealloc+0x104>

0000000080006528 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80006528:	fe010113          	addi	sp,sp,-32
    8000652c:	00113c23          	sd	ra,24(sp)
    80006530:	00813823          	sd	s0,16(sp)
    80006534:	00913423          	sd	s1,8(sp)
    80006538:	01213023          	sd	s2,0(sp)
    8000653c:	02010413          	addi	s0,sp,32
    80006540:	00050493          	mv	s1,a0
    80006544:	00058913          	mv	s2,a1
  acquire(&pi->lock);
    80006548:	ffffb097          	auipc	ra,0xffffb
    8000654c:	a20080e7          	jalr	-1504(ra) # 80000f68 <acquire>
  if(writable){
    80006550:	04090663          	beqz	s2,8000659c <pipeclose+0x74>
    pi->writeopen = 0;
    80006554:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80006558:	21848513          	addi	a0,s1,536
    8000655c:	ffffd097          	auipc	ra,0xffffd
    80006560:	a20080e7          	jalr	-1504(ra) # 80002f7c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80006564:	2204b783          	ld	a5,544(s1)
    80006568:	04079463          	bnez	a5,800065b0 <pipeclose+0x88>
    release(&pi->lock);
    8000656c:	00048513          	mv	a0,s1
    80006570:	ffffb097          	auipc	ra,0xffffb
    80006574:	af0080e7          	jalr	-1296(ra) # 80001060 <release>
    kfree((char*)pi);
    80006578:	00048513          	mv	a0,s1
    8000657c:	ffffa097          	auipc	ra,0xffffa
    80006580:	778080e7          	jalr	1912(ra) # 80000cf4 <kfree>
  } else
    release(&pi->lock);
}
    80006584:	01813083          	ld	ra,24(sp)
    80006588:	01013403          	ld	s0,16(sp)
    8000658c:	00813483          	ld	s1,8(sp)
    80006590:	00013903          	ld	s2,0(sp)
    80006594:	02010113          	addi	sp,sp,32
    80006598:	00008067          	ret
    pi->readopen = 0;
    8000659c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800065a0:	21c48513          	addi	a0,s1,540
    800065a4:	ffffd097          	auipc	ra,0xffffd
    800065a8:	9d8080e7          	jalr	-1576(ra) # 80002f7c <wakeup>
    800065ac:	fb9ff06f          	j	80006564 <pipeclose+0x3c>
    release(&pi->lock);
    800065b0:	00048513          	mv	a0,s1
    800065b4:	ffffb097          	auipc	ra,0xffffb
    800065b8:	aac080e7          	jalr	-1364(ra) # 80001060 <release>
}
    800065bc:	fc9ff06f          	j	80006584 <pipeclose+0x5c>

00000000800065c0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800065c0:	fa010113          	addi	sp,sp,-96
    800065c4:	04113c23          	sd	ra,88(sp)
    800065c8:	04813823          	sd	s0,80(sp)
    800065cc:	04913423          	sd	s1,72(sp)
    800065d0:	05213023          	sd	s2,64(sp)
    800065d4:	03313c23          	sd	s3,56(sp)
    800065d8:	03413823          	sd	s4,48(sp)
    800065dc:	03513423          	sd	s5,40(sp)
    800065e0:	03613023          	sd	s6,32(sp)
    800065e4:	01713c23          	sd	s7,24(sp)
    800065e8:	01813823          	sd	s8,16(sp)
    800065ec:	06010413          	addi	s0,sp,96
    800065f0:	00050493          	mv	s1,a0
    800065f4:	00058a93          	mv	s5,a1
    800065f8:	00060a13          	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800065fc:	ffffc097          	auipc	ra,0xffffc
    80006600:	df0080e7          	jalr	-528(ra) # 800023ec <myproc>
    80006604:	00050993          	mv	s3,a0

  acquire(&pi->lock);
    80006608:	00048513          	mv	a0,s1
    8000660c:	ffffb097          	auipc	ra,0xffffb
    80006610:	95c080e7          	jalr	-1700(ra) # 80000f68 <acquire>
  while(i < n){
    80006614:	0d405e63          	blez	s4,800066f0 <pipewrite+0x130>
  int i = 0;
    80006618:	00000913          	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000661c:	fff00b13          	li	s6,-1
      wakeup(&pi->nread);
    80006620:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80006624:	21c48b93          	addi	s7,s1,540
    80006628:	0680006f          	j	80006690 <pipewrite+0xd0>
      release(&pi->lock);
    8000662c:	00048513          	mv	a0,s1
    80006630:	ffffb097          	auipc	ra,0xffffb
    80006634:	a30080e7          	jalr	-1488(ra) # 80001060 <release>
      return -1;
    80006638:	fff00913          	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000663c:	00090513          	mv	a0,s2
    80006640:	05813083          	ld	ra,88(sp)
    80006644:	05013403          	ld	s0,80(sp)
    80006648:	04813483          	ld	s1,72(sp)
    8000664c:	04013903          	ld	s2,64(sp)
    80006650:	03813983          	ld	s3,56(sp)
    80006654:	03013a03          	ld	s4,48(sp)
    80006658:	02813a83          	ld	s5,40(sp)
    8000665c:	02013b03          	ld	s6,32(sp)
    80006660:	01813b83          	ld	s7,24(sp)
    80006664:	01013c03          	ld	s8,16(sp)
    80006668:	06010113          	addi	sp,sp,96
    8000666c:	00008067          	ret
      wakeup(&pi->nread);
    80006670:	000c0513          	mv	a0,s8
    80006674:	ffffd097          	auipc	ra,0xffffd
    80006678:	908080e7          	jalr	-1784(ra) # 80002f7c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000667c:	00048593          	mv	a1,s1
    80006680:	000b8513          	mv	a0,s7
    80006684:	ffffc097          	auipc	ra,0xffffc
    80006688:	6d8080e7          	jalr	1752(ra) # 80002d5c <sleep>
  while(i < n){
    8000668c:	07495463          	bge	s2,s4,800066f4 <pipewrite+0x134>
    if(pi->readopen == 0 || pr->killed){
    80006690:	2204a783          	lw	a5,544(s1)
    80006694:	f8078ce3          	beqz	a5,8000662c <pipewrite+0x6c>
    80006698:	0289a783          	lw	a5,40(s3)
    8000669c:	f80798e3          	bnez	a5,8000662c <pipewrite+0x6c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800066a0:	2184a783          	lw	a5,536(s1)
    800066a4:	21c4a703          	lw	a4,540(s1)
    800066a8:	2007879b          	addiw	a5,a5,512
    800066ac:	fcf702e3          	beq	a4,a5,80006670 <pipewrite+0xb0>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800066b0:	00100693          	li	a3,1
    800066b4:	01590633          	add	a2,s2,s5
    800066b8:	faf40593          	addi	a1,s0,-81
    800066bc:	0509b503          	ld	a0,80(s3)
    800066c0:	ffffc097          	auipc	ra,0xffffc
    800066c4:	91c080e7          	jalr	-1764(ra) # 80001fdc <copyin>
    800066c8:	03650663          	beq	a0,s6,800066f4 <pipewrite+0x134>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800066cc:	21c4a783          	lw	a5,540(s1)
    800066d0:	0017871b          	addiw	a4,a5,1
    800066d4:	20e4ae23          	sw	a4,540(s1)
    800066d8:	1ff7f793          	andi	a5,a5,511
    800066dc:	00f487b3          	add	a5,s1,a5
    800066e0:	faf44703          	lbu	a4,-81(s0)
    800066e4:	00e78c23          	sb	a4,24(a5)
      i++;
    800066e8:	0019091b          	addiw	s2,s2,1
    800066ec:	fa1ff06f          	j	8000668c <pipewrite+0xcc>
  int i = 0;
    800066f0:	00000913          	li	s2,0
  wakeup(&pi->nread);
    800066f4:	21848513          	addi	a0,s1,536
    800066f8:	ffffd097          	auipc	ra,0xffffd
    800066fc:	884080e7          	jalr	-1916(ra) # 80002f7c <wakeup>
  release(&pi->lock);
    80006700:	00048513          	mv	a0,s1
    80006704:	ffffb097          	auipc	ra,0xffffb
    80006708:	95c080e7          	jalr	-1700(ra) # 80001060 <release>
  return i;
    8000670c:	f31ff06f          	j	8000663c <pipewrite+0x7c>

0000000080006710 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80006710:	fb010113          	addi	sp,sp,-80
    80006714:	04113423          	sd	ra,72(sp)
    80006718:	04813023          	sd	s0,64(sp)
    8000671c:	02913c23          	sd	s1,56(sp)
    80006720:	03213823          	sd	s2,48(sp)
    80006724:	03313423          	sd	s3,40(sp)
    80006728:	03413023          	sd	s4,32(sp)
    8000672c:	01513c23          	sd	s5,24(sp)
    80006730:	01613823          	sd	s6,16(sp)
    80006734:	05010413          	addi	s0,sp,80
    80006738:	00050493          	mv	s1,a0
    8000673c:	00058913          	mv	s2,a1
    80006740:	00060a93          	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80006744:	ffffc097          	auipc	ra,0xffffc
    80006748:	ca8080e7          	jalr	-856(ra) # 800023ec <myproc>
    8000674c:	00050a13          	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80006750:	00048513          	mv	a0,s1
    80006754:	ffffb097          	auipc	ra,0xffffb
    80006758:	814080e7          	jalr	-2028(ra) # 80000f68 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000675c:	2184a703          	lw	a4,536(s1)
    80006760:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80006764:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80006768:	02f71863          	bne	a4,a5,80006798 <piperead+0x88>
    8000676c:	2244a783          	lw	a5,548(s1)
    80006770:	02078463          	beqz	a5,80006798 <piperead+0x88>
    if(pr->killed){
    80006774:	028a2783          	lw	a5,40(s4)
    80006778:	0a079e63          	bnez	a5,80006834 <piperead+0x124>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000677c:	00048593          	mv	a1,s1
    80006780:	00098513          	mv	a0,s3
    80006784:	ffffc097          	auipc	ra,0xffffc
    80006788:	5d8080e7          	jalr	1496(ra) # 80002d5c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000678c:	2184a703          	lw	a4,536(s1)
    80006790:	21c4a783          	lw	a5,540(s1)
    80006794:	fcf70ce3          	beq	a4,a5,8000676c <piperead+0x5c>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80006798:	00000993          	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000679c:	fff00b13          	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800067a0:	05505863          	blez	s5,800067f0 <piperead+0xe0>
    if(pi->nread == pi->nwrite)
    800067a4:	2184a783          	lw	a5,536(s1)
    800067a8:	21c4a703          	lw	a4,540(s1)
    800067ac:	04f70263          	beq	a4,a5,800067f0 <piperead+0xe0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800067b0:	0017871b          	addiw	a4,a5,1
    800067b4:	20e4ac23          	sw	a4,536(s1)
    800067b8:	1ff7f793          	andi	a5,a5,511
    800067bc:	00f487b3          	add	a5,s1,a5
    800067c0:	0187c783          	lbu	a5,24(a5)
    800067c4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800067c8:	00100693          	li	a3,1
    800067cc:	fbf40613          	addi	a2,s0,-65
    800067d0:	00090593          	mv	a1,s2
    800067d4:	050a3503          	ld	a0,80(s4)
    800067d8:	ffffb097          	auipc	ra,0xffffb
    800067dc:	71c080e7          	jalr	1820(ra) # 80001ef4 <copyout>
    800067e0:	01650863          	beq	a0,s6,800067f0 <piperead+0xe0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800067e4:	0019899b          	addiw	s3,s3,1
    800067e8:	00190913          	addi	s2,s2,1
    800067ec:	fb3a9ce3          	bne	s5,s3,800067a4 <piperead+0x94>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800067f0:	21c48513          	addi	a0,s1,540
    800067f4:	ffffc097          	auipc	ra,0xffffc
    800067f8:	788080e7          	jalr	1928(ra) # 80002f7c <wakeup>
  release(&pi->lock);
    800067fc:	00048513          	mv	a0,s1
    80006800:	ffffb097          	auipc	ra,0xffffb
    80006804:	860080e7          	jalr	-1952(ra) # 80001060 <release>
  return i;
}
    80006808:	00098513          	mv	a0,s3
    8000680c:	04813083          	ld	ra,72(sp)
    80006810:	04013403          	ld	s0,64(sp)
    80006814:	03813483          	ld	s1,56(sp)
    80006818:	03013903          	ld	s2,48(sp)
    8000681c:	02813983          	ld	s3,40(sp)
    80006820:	02013a03          	ld	s4,32(sp)
    80006824:	01813a83          	ld	s5,24(sp)
    80006828:	01013b03          	ld	s6,16(sp)
    8000682c:	05010113          	addi	sp,sp,80
    80006830:	00008067          	ret
      release(&pi->lock);
    80006834:	00048513          	mv	a0,s1
    80006838:	ffffb097          	auipc	ra,0xffffb
    8000683c:	828080e7          	jalr	-2008(ra) # 80001060 <release>
      return -1;
    80006840:	fff00993          	li	s3,-1
    80006844:	fc5ff06f          	j	80006808 <piperead+0xf8>

0000000080006848 <ramdiskinit>:
#include "fs.h"
#include "buf.h"

void
ramdiskinit(void)
{
    80006848:	ff010113          	addi	sp,sp,-16
    8000684c:	00813423          	sd	s0,8(sp)
    80006850:	01010413          	addi	s0,sp,16
}
    80006854:	00813403          	ld	s0,8(sp)
    80006858:	01010113          	addi	sp,sp,16
    8000685c:	00008067          	ret

0000000080006860 <ramdiskrw>:

// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ramdiskrw(struct buf *b)
{
    80006860:	fe010113          	addi	sp,sp,-32
    80006864:	00113c23          	sd	ra,24(sp)
    80006868:	00813823          	sd	s0,16(sp)
    8000686c:	00913423          	sd	s1,8(sp)
    80006870:	02010413          	addi	s0,sp,32
    80006874:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80006878:	01050513          	addi	a0,a0,16
    8000687c:	fffff097          	auipc	ra,0xfffff
    80006880:	538080e7          	jalr	1336(ra) # 80005db4 <holdingsleep>
    80006884:	06050863          	beqz	a0,800068f4 <ramdiskrw+0x94>
    panic("ramdiskrw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    80006888:	0004a783          	lw	a5,0(s1)
    8000688c:	0067f693          	andi	a3,a5,6
    80006890:	00200713          	li	a4,2
    80006894:	06e68863          	beq	a3,a4,80006904 <ramdiskrw+0xa4>
    panic("ramdiskrw: nothing to do");

  if(b->blockno >= FSSIZE)
    80006898:	0084a503          	lw	a0,8(s1)
    8000689c:	3e700713          	li	a4,999
    800068a0:	06a76a63          	bltu	a4,a0,80006914 <ramdiskrw+0xb4>
    panic("ramdiskrw: blockno too big");

  uint64 diskaddr = b->blockno * BSIZE;
    800068a4:	00a5151b          	slliw	a0,a0,0xa
    800068a8:	02051513          	slli	a0,a0,0x20
    800068ac:	02055513          	srli	a0,a0,0x20
  char *addr = (char *)RAMDISK + diskaddr;
    800068b0:	01100713          	li	a4,17
    800068b4:	01b71713          	slli	a4,a4,0x1b
    800068b8:	00e50533          	add	a0,a0,a4

  if(b->flags & B_DIRTY){
    800068bc:	0047f793          	andi	a5,a5,4
    800068c0:	06078263          	beqz	a5,80006924 <ramdiskrw+0xc4>
    // write
    memmove(addr, b->data, BSIZE);
    800068c4:	40000613          	li	a2,1024
    800068c8:	06048593          	addi	a1,s1,96
    800068cc:	ffffb097          	auipc	ra,0xffffb
    800068d0:	888080e7          	jalr	-1912(ra) # 80001154 <memmove>
    b->flags &= ~B_DIRTY;
    800068d4:	0004a783          	lw	a5,0(s1)
    800068d8:	ffb7f793          	andi	a5,a5,-5
    800068dc:	00f4a023          	sw	a5,0(s1)
  } else {
    // read
    memmove(b->data, addr, BSIZE);
    b->flags |= B_VALID;
  }
}
    800068e0:	01813083          	ld	ra,24(sp)
    800068e4:	01013403          	ld	s0,16(sp)
    800068e8:	00813483          	ld	s1,8(sp)
    800068ec:	02010113          	addi	sp,sp,32
    800068f0:	00008067          	ret
    panic("ramdiskrw: buf not locked");
    800068f4:	00004517          	auipc	a0,0x4
    800068f8:	dcc50513          	addi	a0,a0,-564 # 8000a6c0 <syscalls+0x280>
    800068fc:	ffffa097          	auipc	ra,0xffffa
    80006900:	dd0080e7          	jalr	-560(ra) # 800006cc <panic>
    panic("ramdiskrw: nothing to do");
    80006904:	00004517          	auipc	a0,0x4
    80006908:	ddc50513          	addi	a0,a0,-548 # 8000a6e0 <syscalls+0x2a0>
    8000690c:	ffffa097          	auipc	ra,0xffffa
    80006910:	dc0080e7          	jalr	-576(ra) # 800006cc <panic>
    panic("ramdiskrw: blockno too big");
    80006914:	00004517          	auipc	a0,0x4
    80006918:	dec50513          	addi	a0,a0,-532 # 8000a700 <syscalls+0x2c0>
    8000691c:	ffffa097          	auipc	ra,0xffffa
    80006920:	db0080e7          	jalr	-592(ra) # 800006cc <panic>
    memmove(b->data, addr, BSIZE);
    80006924:	40000613          	li	a2,1024
    80006928:	00050593          	mv	a1,a0
    8000692c:	06048513          	addi	a0,s1,96
    80006930:	ffffb097          	auipc	ra,0xffffb
    80006934:	824080e7          	jalr	-2012(ra) # 80001154 <memmove>
    b->flags |= B_VALID;
    80006938:	0004a783          	lw	a5,0(s1)
    8000693c:	0027e793          	ori	a5,a5,2
    80006940:	00f4a023          	sw	a5,0(s1)
}
    80006944:	f9dff06f          	j	800068e0 <ramdiskrw+0x80>

0000000080006948 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80006948:	de010113          	addi	sp,sp,-544
    8000694c:	20113c23          	sd	ra,536(sp)
    80006950:	20813823          	sd	s0,528(sp)
    80006954:	20913423          	sd	s1,520(sp)
    80006958:	21213023          	sd	s2,512(sp)
    8000695c:	1f313c23          	sd	s3,504(sp)
    80006960:	1f413823          	sd	s4,496(sp)
    80006964:	1f513423          	sd	s5,488(sp)
    80006968:	1f613023          	sd	s6,480(sp)
    8000696c:	1d713c23          	sd	s7,472(sp)
    80006970:	1d813823          	sd	s8,464(sp)
    80006974:	1d913423          	sd	s9,456(sp)
    80006978:	1da13023          	sd	s10,448(sp)
    8000697c:	1bb13c23          	sd	s11,440(sp)
    80006980:	22010413          	addi	s0,sp,544
    80006984:	00050913          	mv	s2,a0
    80006988:	dea43423          	sd	a0,-536(s0)
    8000698c:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80006990:	ffffc097          	auipc	ra,0xffffc
    80006994:	a5c080e7          	jalr	-1444(ra) # 800023ec <myproc>
    80006998:	00050493          	mv	s1,a0

  begin_op();
    8000699c:	fffff097          	auipc	ra,0xfffff
    800069a0:	f44080e7          	jalr	-188(ra) # 800058e0 <begin_op>

  if((ip = namei(path)) == 0){
    800069a4:	00090513          	mv	a0,s2
    800069a8:	fffff097          	auipc	ra,0xfffff
    800069ac:	c48080e7          	jalr	-952(ra) # 800055f0 <namei>
    800069b0:	08050c63          	beqz	a0,80006a48 <exec+0x100>
    800069b4:	00050a93          	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800069b8:	ffffe097          	auipc	ra,0xffffe
    800069bc:	140080e7          	jalr	320(ra) # 80004af8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800069c0:	04000713          	li	a4,64
    800069c4:	00000693          	li	a3,0
    800069c8:	e5040613          	addi	a2,s0,-432
    800069cc:	00000593          	li	a1,0
    800069d0:	000a8513          	mv	a0,s5
    800069d4:	ffffe097          	auipc	ra,0xffffe
    800069d8:	4e0080e7          	jalr	1248(ra) # 80004eb4 <readi>
    800069dc:	04000793          	li	a5,64
    800069e0:	00f51a63          	bne	a0,a5,800069f4 <exec+0xac>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800069e4:	e5042703          	lw	a4,-432(s0)
    800069e8:	464c47b7          	lui	a5,0x464c4
    800069ec:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800069f0:	06f70463          	beq	a4,a5,80006a58 <exec+0x110>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800069f4:	000a8513          	mv	a0,s5
    800069f8:	ffffe097          	auipc	ra,0xffffe
    800069fc:	43c080e7          	jalr	1084(ra) # 80004e34 <iunlockput>
    end_op();
    80006a00:	fffff097          	auipc	ra,0xfffff
    80006a04:	f94080e7          	jalr	-108(ra) # 80005994 <end_op>
  }
  return -1;
    80006a08:	fff00513          	li	a0,-1
}
    80006a0c:	21813083          	ld	ra,536(sp)
    80006a10:	21013403          	ld	s0,528(sp)
    80006a14:	20813483          	ld	s1,520(sp)
    80006a18:	20013903          	ld	s2,512(sp)
    80006a1c:	1f813983          	ld	s3,504(sp)
    80006a20:	1f013a03          	ld	s4,496(sp)
    80006a24:	1e813a83          	ld	s5,488(sp)
    80006a28:	1e013b03          	ld	s6,480(sp)
    80006a2c:	1d813b83          	ld	s7,472(sp)
    80006a30:	1d013c03          	ld	s8,464(sp)
    80006a34:	1c813c83          	ld	s9,456(sp)
    80006a38:	1c013d03          	ld	s10,448(sp)
    80006a3c:	1b813d83          	ld	s11,440(sp)
    80006a40:	22010113          	addi	sp,sp,544
    80006a44:	00008067          	ret
    end_op();
    80006a48:	fffff097          	auipc	ra,0xfffff
    80006a4c:	f4c080e7          	jalr	-180(ra) # 80005994 <end_op>
    return -1;
    80006a50:	fff00513          	li	a0,-1
    80006a54:	fb9ff06f          	j	80006a0c <exec+0xc4>
  if((pagetable = proc_pagetable(p)) == 0)
    80006a58:	00048513          	mv	a0,s1
    80006a5c:	ffffc097          	auipc	ra,0xffffc
    80006a60:	aac080e7          	jalr	-1364(ra) # 80002508 <proc_pagetable>
    80006a64:	00050b13          	mv	s6,a0
    80006a68:	f80506e3          	beqz	a0,800069f4 <exec+0xac>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006a6c:	e7042783          	lw	a5,-400(s0)
    80006a70:	e8845703          	lhu	a4,-376(s0)
    80006a74:	08070863          	beqz	a4,80006b04 <exec+0x1bc>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80006a78:	00000493          	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006a7c:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80006a80:	00001a37          	lui	s4,0x1
    80006a84:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80006a88:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80006a8c:	00001db7          	lui	s11,0x1
    80006a90:	fffffd37          	lui	s10,0xfffff
    80006a94:	2d00006f          	j	80006d64 <exec+0x41c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80006a98:	00004517          	auipc	a0,0x4
    80006a9c:	c8850513          	addi	a0,a0,-888 # 8000a720 <syscalls+0x2e0>
    80006aa0:	ffffa097          	auipc	ra,0xffffa
    80006aa4:	c2c080e7          	jalr	-980(ra) # 800006cc <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80006aa8:	00090713          	mv	a4,s2
    80006aac:	009c86bb          	addw	a3,s9,s1
    80006ab0:	00000593          	li	a1,0
    80006ab4:	000a8513          	mv	a0,s5
    80006ab8:	ffffe097          	auipc	ra,0xffffe
    80006abc:	3fc080e7          	jalr	1020(ra) # 80004eb4 <readi>
    80006ac0:	0005051b          	sext.w	a0,a0
    80006ac4:	22a91463          	bne	s2,a0,80006cec <exec+0x3a4>
  for(i = 0; i < sz; i += PGSIZE){
    80006ac8:	009d84bb          	addw	s1,s11,s1
    80006acc:	013d09bb          	addw	s3,s10,s3
    80006ad0:	2774fa63          	bgeu	s1,s7,80006d44 <exec+0x3fc>
    pa = walkaddr(pagetable, va + i);
    80006ad4:	02049593          	slli	a1,s1,0x20
    80006ad8:	0205d593          	srli	a1,a1,0x20
    80006adc:	018585b3          	add	a1,a1,s8
    80006ae0:	000b0513          	mv	a0,s6
    80006ae4:	ffffb097          	auipc	ra,0xffffb
    80006ae8:	ad0080e7          	jalr	-1328(ra) # 800015b4 <walkaddr>
    80006aec:	00050613          	mv	a2,a0
    if(pa == 0)
    80006af0:	fa0504e3          	beqz	a0,80006a98 <exec+0x150>
      n = PGSIZE;
    80006af4:	000a0913          	mv	s2,s4
    if(sz - i < PGSIZE)
    80006af8:	fb49f8e3          	bgeu	s3,s4,80006aa8 <exec+0x160>
      n = sz - i;
    80006afc:	00098913          	mv	s2,s3
    80006b00:	fa9ff06f          	j	80006aa8 <exec+0x160>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80006b04:	00000493          	li	s1,0
  iunlockput(ip);
    80006b08:	000a8513          	mv	a0,s5
    80006b0c:	ffffe097          	auipc	ra,0xffffe
    80006b10:	328080e7          	jalr	808(ra) # 80004e34 <iunlockput>
  end_op();
    80006b14:	fffff097          	auipc	ra,0xfffff
    80006b18:	e80080e7          	jalr	-384(ra) # 80005994 <end_op>
  asm volatile("fence.i");
    80006b1c:	0000100f          	fence.i
  p = myproc();
    80006b20:	ffffc097          	auipc	ra,0xffffc
    80006b24:	8cc080e7          	jalr	-1844(ra) # 800023ec <myproc>
    80006b28:	00050b93          	mv	s7,a0
  uint64 oldsz = p->sz;
    80006b2c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80006b30:	000017b7          	lui	a5,0x1
    80006b34:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80006b38:	00f484b3          	add	s1,s1,a5
    80006b3c:	fffff7b7          	lui	a5,0xfffff
    80006b40:	00f4f7b3          	and	a5,s1,a5
    80006b44:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80006b48:	00002637          	lui	a2,0x2
    80006b4c:	00c78633          	add	a2,a5,a2
    80006b50:	00078593          	mv	a1,a5
    80006b54:	000b0513          	mv	a0,s6
    80006b58:	ffffb097          	auipc	ra,0xffffb
    80006b5c:	ff0080e7          	jalr	-16(ra) # 80001b48 <uvmalloc>
    80006b60:	00050c13          	mv	s8,a0
  ip = 0;
    80006b64:	00000a93          	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80006b68:	18050263          	beqz	a0,80006cec <exec+0x3a4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80006b6c:	ffffe5b7          	lui	a1,0xffffe
    80006b70:	00b505b3          	add	a1,a0,a1
    80006b74:	000b0513          	mv	a0,s6
    80006b78:	ffffb097          	auipc	ra,0xffffb
    80006b7c:	330080e7          	jalr	816(ra) # 80001ea8 <uvmclear>
  stackbase = sp - PGSIZE;
    80006b80:	fffffab7          	lui	s5,0xfffff
    80006b84:	015c0ab3          	add	s5,s8,s5
  for(argc = 0; argv[argc]; argc++) {
    80006b88:	df043783          	ld	a5,-528(s0)
    80006b8c:	0007b503          	ld	a0,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb388>
    80006b90:	08050463          	beqz	a0,80006c18 <exec+0x2d0>
    80006b94:	e9040993          	addi	s3,s0,-368
    80006b98:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80006b9c:	000c0913          	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80006ba0:	00000493          	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80006ba4:	ffffa097          	auipc	ra,0xffffa
    80006ba8:	768080e7          	jalr	1896(ra) # 8000130c <strlen>
    80006bac:	0015079b          	addiw	a5,a0,1
    80006bb0:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80006bb4:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80006bb8:	17596463          	bltu	s2,s5,80006d20 <exec+0x3d8>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80006bbc:	df043d83          	ld	s11,-528(s0)
    80006bc0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80006bc4:	000a0513          	mv	a0,s4
    80006bc8:	ffffa097          	auipc	ra,0xffffa
    80006bcc:	744080e7          	jalr	1860(ra) # 8000130c <strlen>
    80006bd0:	0015069b          	addiw	a3,a0,1
    80006bd4:	000a0613          	mv	a2,s4
    80006bd8:	00090593          	mv	a1,s2
    80006bdc:	000b0513          	mv	a0,s6
    80006be0:	ffffb097          	auipc	ra,0xffffb
    80006be4:	314080e7          	jalr	788(ra) # 80001ef4 <copyout>
    80006be8:	14054263          	bltz	a0,80006d2c <exec+0x3e4>
    ustack[argc] = sp;
    80006bec:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80006bf0:	00148493          	addi	s1,s1,1
    80006bf4:	008d8793          	addi	a5,s11,8
    80006bf8:	def43823          	sd	a5,-528(s0)
    80006bfc:	008db503          	ld	a0,8(s11)
    80006c00:	02050063          	beqz	a0,80006c20 <exec+0x2d8>
    if(argc >= MAXARG)
    80006c04:	00898993          	addi	s3,s3,8
    80006c08:	f93c9ee3          	bne	s9,s3,80006ba4 <exec+0x25c>
  sz = sz1;
    80006c0c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80006c10:	00000a93          	li	s5,0
    80006c14:	0d80006f          	j	80006cec <exec+0x3a4>
  sp = sz;
    80006c18:	000c0913          	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80006c1c:	00000493          	li	s1,0
  ustack[argc] = 0;
    80006c20:	00349793          	slli	a5,s1,0x3
    80006c24:	f9040713          	addi	a4,s0,-112
    80006c28:	00f707b3          	add	a5,a4,a5
    80006c2c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80006c30:	00148693          	addi	a3,s1,1
    80006c34:	00369693          	slli	a3,a3,0x3
    80006c38:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80006c3c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80006c40:	01597863          	bgeu	s2,s5,80006c50 <exec+0x308>
  sz = sz1;
    80006c44:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80006c48:	00000a93          	li	s5,0
    80006c4c:	0a00006f          	j	80006cec <exec+0x3a4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80006c50:	e9040613          	addi	a2,s0,-368
    80006c54:	00090593          	mv	a1,s2
    80006c58:	000b0513          	mv	a0,s6
    80006c5c:	ffffb097          	auipc	ra,0xffffb
    80006c60:	298080e7          	jalr	664(ra) # 80001ef4 <copyout>
    80006c64:	0c054a63          	bltz	a0,80006d38 <exec+0x3f0>
  p->trapframe->a1 = sp;
    80006c68:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80006c6c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80006c70:	de843783          	ld	a5,-536(s0)
    80006c74:	0007c703          	lbu	a4,0(a5)
    80006c78:	02070463          	beqz	a4,80006ca0 <exec+0x358>
    80006c7c:	00178793          	addi	a5,a5,1
    if(*s == '/')
    80006c80:	02f00693          	li	a3,47
    80006c84:	0140006f          	j	80006c98 <exec+0x350>
      last = s+1;
    80006c88:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80006c8c:	00178793          	addi	a5,a5,1
    80006c90:	fff7c703          	lbu	a4,-1(a5)
    80006c94:	00070663          	beqz	a4,80006ca0 <exec+0x358>
    if(*s == '/')
    80006c98:	fed71ae3          	bne	a4,a3,80006c8c <exec+0x344>
    80006c9c:	fedff06f          	j	80006c88 <exec+0x340>
  safestrcpy(p->name, last, sizeof(p->name));
    80006ca0:	01000613          	li	a2,16
    80006ca4:	de843583          	ld	a1,-536(s0)
    80006ca8:	158b8513          	addi	a0,s7,344
    80006cac:	ffffa097          	auipc	ra,0xffffa
    80006cb0:	614080e7          	jalr	1556(ra) # 800012c0 <safestrcpy>
  oldpagetable = p->pagetable;
    80006cb4:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80006cb8:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80006cbc:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80006cc0:	058bb783          	ld	a5,88(s7)
    80006cc4:	e6843703          	ld	a4,-408(s0)
    80006cc8:	00e7bc23          	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80006ccc:	058bb783          	ld	a5,88(s7)
    80006cd0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80006cd4:	000d0593          	mv	a1,s10
    80006cd8:	ffffc097          	auipc	ra,0xffffc
    80006cdc:	918080e7          	jalr	-1768(ra) # 800025f0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80006ce0:	0004851b          	sext.w	a0,s1
    80006ce4:	d29ff06f          	j	80006a0c <exec+0xc4>
    80006ce8:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80006cec:	df843583          	ld	a1,-520(s0)
    80006cf0:	000b0513          	mv	a0,s6
    80006cf4:	ffffc097          	auipc	ra,0xffffc
    80006cf8:	8fc080e7          	jalr	-1796(ra) # 800025f0 <proc_freepagetable>
  if(ip){
    80006cfc:	ce0a9ce3          	bnez	s5,800069f4 <exec+0xac>
  return -1;
    80006d00:	fff00513          	li	a0,-1
    80006d04:	d09ff06f          	j	80006a0c <exec+0xc4>
    80006d08:	de943c23          	sd	s1,-520(s0)
    80006d0c:	fe1ff06f          	j	80006cec <exec+0x3a4>
    80006d10:	de943c23          	sd	s1,-520(s0)
    80006d14:	fd9ff06f          	j	80006cec <exec+0x3a4>
    80006d18:	de943c23          	sd	s1,-520(s0)
    80006d1c:	fd1ff06f          	j	80006cec <exec+0x3a4>
  sz = sz1;
    80006d20:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80006d24:	00000a93          	li	s5,0
    80006d28:	fc5ff06f          	j	80006cec <exec+0x3a4>
  sz = sz1;
    80006d2c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80006d30:	00000a93          	li	s5,0
    80006d34:	fb9ff06f          	j	80006cec <exec+0x3a4>
  sz = sz1;
    80006d38:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80006d3c:	00000a93          	li	s5,0
    80006d40:	fadff06f          	j	80006cec <exec+0x3a4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80006d44:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006d48:	e0843783          	ld	a5,-504(s0)
    80006d4c:	0017869b          	addiw	a3,a5,1
    80006d50:	e0d43423          	sd	a3,-504(s0)
    80006d54:	e0043783          	ld	a5,-512(s0)
    80006d58:	0387879b          	addiw	a5,a5,56
    80006d5c:	e8845703          	lhu	a4,-376(s0)
    80006d60:	dae6d4e3          	bge	a3,a4,80006b08 <exec+0x1c0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80006d64:	0007879b          	sext.w	a5,a5
    80006d68:	e0f43023          	sd	a5,-512(s0)
    80006d6c:	03800713          	li	a4,56
    80006d70:	00078693          	mv	a3,a5
    80006d74:	e1840613          	addi	a2,s0,-488
    80006d78:	00000593          	li	a1,0
    80006d7c:	000a8513          	mv	a0,s5
    80006d80:	ffffe097          	auipc	ra,0xffffe
    80006d84:	134080e7          	jalr	308(ra) # 80004eb4 <readi>
    80006d88:	03800793          	li	a5,56
    80006d8c:	f4f51ee3          	bne	a0,a5,80006ce8 <exec+0x3a0>
    if(ph.type != ELF_PROG_LOAD)
    80006d90:	e1842783          	lw	a5,-488(s0)
    80006d94:	00100713          	li	a4,1
    80006d98:	fae798e3          	bne	a5,a4,80006d48 <exec+0x400>
    if(ph.memsz < ph.filesz)
    80006d9c:	e4043603          	ld	a2,-448(s0)
    80006da0:	e3843783          	ld	a5,-456(s0)
    80006da4:	f6f662e3          	bltu	a2,a5,80006d08 <exec+0x3c0>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80006da8:	e2843783          	ld	a5,-472(s0)
    80006dac:	00f60633          	add	a2,a2,a5
    80006db0:	f6f660e3          	bltu	a2,a5,80006d10 <exec+0x3c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80006db4:	00048593          	mv	a1,s1
    80006db8:	000b0513          	mv	a0,s6
    80006dbc:	ffffb097          	auipc	ra,0xffffb
    80006dc0:	d8c080e7          	jalr	-628(ra) # 80001b48 <uvmalloc>
    80006dc4:	dea43c23          	sd	a0,-520(s0)
    80006dc8:	f40508e3          	beqz	a0,80006d18 <exec+0x3d0>
    if((ph.vaddr % PGSIZE) != 0)
    80006dcc:	e2843c03          	ld	s8,-472(s0)
    80006dd0:	de043783          	ld	a5,-544(s0)
    80006dd4:	00fc77b3          	and	a5,s8,a5
    80006dd8:	f0079ae3          	bnez	a5,80006cec <exec+0x3a4>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80006ddc:	e2042c83          	lw	s9,-480(s0)
    80006de0:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80006de4:	f60b80e3          	beqz	s7,80006d44 <exec+0x3fc>
    80006de8:	000b8993          	mv	s3,s7
    80006dec:	00000493          	li	s1,0
    80006df0:	ce5ff06f          	j	80006ad4 <exec+0x18c>

0000000080006df4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80006df4:	fd010113          	addi	sp,sp,-48
    80006df8:	02113423          	sd	ra,40(sp)
    80006dfc:	02813023          	sd	s0,32(sp)
    80006e00:	00913c23          	sd	s1,24(sp)
    80006e04:	01213823          	sd	s2,16(sp)
    80006e08:	03010413          	addi	s0,sp,48
    80006e0c:	00058913          	mv	s2,a1
    80006e10:	00060493          	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80006e14:	fdc40593          	addi	a1,s0,-36
    80006e18:	ffffd097          	auipc	ra,0xffffd
    80006e1c:	d18080e7          	jalr	-744(ra) # 80003b30 <argint>
    80006e20:	04054e63          	bltz	a0,80006e7c <argfd+0x88>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80006e24:	fdc42703          	lw	a4,-36(s0)
    80006e28:	00f00793          	li	a5,15
    80006e2c:	04e7ec63          	bltu	a5,a4,80006e84 <argfd+0x90>
    80006e30:	ffffb097          	auipc	ra,0xffffb
    80006e34:	5bc080e7          	jalr	1468(ra) # 800023ec <myproc>
    80006e38:	fdc42703          	lw	a4,-36(s0)
    80006e3c:	01a70793          	addi	a5,a4,26
    80006e40:	00379793          	slli	a5,a5,0x3
    80006e44:	00f50533          	add	a0,a0,a5
    80006e48:	00053783          	ld	a5,0(a0)
    80006e4c:	04078063          	beqz	a5,80006e8c <argfd+0x98>
    return -1;
  if(pfd)
    80006e50:	00090463          	beqz	s2,80006e58 <argfd+0x64>
    *pfd = fd;
    80006e54:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80006e58:	00000513          	li	a0,0
  if(pf)
    80006e5c:	00048463          	beqz	s1,80006e64 <argfd+0x70>
    *pf = f;
    80006e60:	00f4b023          	sd	a5,0(s1)
}
    80006e64:	02813083          	ld	ra,40(sp)
    80006e68:	02013403          	ld	s0,32(sp)
    80006e6c:	01813483          	ld	s1,24(sp)
    80006e70:	01013903          	ld	s2,16(sp)
    80006e74:	03010113          	addi	sp,sp,48
    80006e78:	00008067          	ret
    return -1;
    80006e7c:	fff00513          	li	a0,-1
    80006e80:	fe5ff06f          	j	80006e64 <argfd+0x70>
    return -1;
    80006e84:	fff00513          	li	a0,-1
    80006e88:	fddff06f          	j	80006e64 <argfd+0x70>
    80006e8c:	fff00513          	li	a0,-1
    80006e90:	fd5ff06f          	j	80006e64 <argfd+0x70>

0000000080006e94 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80006e94:	fe010113          	addi	sp,sp,-32
    80006e98:	00113c23          	sd	ra,24(sp)
    80006e9c:	00813823          	sd	s0,16(sp)
    80006ea0:	00913423          	sd	s1,8(sp)
    80006ea4:	02010413          	addi	s0,sp,32
    80006ea8:	00050493          	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80006eac:	ffffb097          	auipc	ra,0xffffb
    80006eb0:	540080e7          	jalr	1344(ra) # 800023ec <myproc>
    80006eb4:	00050613          	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80006eb8:	0d050793          	addi	a5,a0,208
    80006ebc:	00000513          	li	a0,0
    80006ec0:	01000693          	li	a3,16
    if(p->ofile[fd] == 0){
    80006ec4:	0007b703          	ld	a4,0(a5)
    80006ec8:	02070463          	beqz	a4,80006ef0 <fdalloc+0x5c>
  for(fd = 0; fd < NOFILE; fd++){
    80006ecc:	0015051b          	addiw	a0,a0,1
    80006ed0:	00878793          	addi	a5,a5,8
    80006ed4:	fed518e3          	bne	a0,a3,80006ec4 <fdalloc+0x30>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80006ed8:	fff00513          	li	a0,-1
}
    80006edc:	01813083          	ld	ra,24(sp)
    80006ee0:	01013403          	ld	s0,16(sp)
    80006ee4:	00813483          	ld	s1,8(sp)
    80006ee8:	02010113          	addi	sp,sp,32
    80006eec:	00008067          	ret
      p->ofile[fd] = f;
    80006ef0:	01a50793          	addi	a5,a0,26
    80006ef4:	00379793          	slli	a5,a5,0x3
    80006ef8:	00f60633          	add	a2,a2,a5
    80006efc:	00963023          	sd	s1,0(a2) # 2000 <_entry-0x7fffe000>
      return fd;
    80006f00:	fddff06f          	j	80006edc <fdalloc+0x48>

0000000080006f04 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80006f04:	fb010113          	addi	sp,sp,-80
    80006f08:	04113423          	sd	ra,72(sp)
    80006f0c:	04813023          	sd	s0,64(sp)
    80006f10:	02913c23          	sd	s1,56(sp)
    80006f14:	03213823          	sd	s2,48(sp)
    80006f18:	03313423          	sd	s3,40(sp)
    80006f1c:	03413023          	sd	s4,32(sp)
    80006f20:	01513c23          	sd	s5,24(sp)
    80006f24:	05010413          	addi	s0,sp,80
    80006f28:	00058993          	mv	s3,a1
    80006f2c:	00060a93          	mv	s5,a2
    80006f30:	00068a13          	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80006f34:	fb040593          	addi	a1,s0,-80
    80006f38:	ffffe097          	auipc	ra,0xffffe
    80006f3c:	6e8080e7          	jalr	1768(ra) # 80005620 <nameiparent>
    80006f40:	00050913          	mv	s2,a0
    80006f44:	18050663          	beqz	a0,800070d0 <create+0x1cc>
    return 0;

  ilock(dp);
    80006f48:	ffffe097          	auipc	ra,0xffffe
    80006f4c:	bb0080e7          	jalr	-1104(ra) # 80004af8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80006f50:	00000613          	li	a2,0
    80006f54:	fb040593          	addi	a1,s0,-80
    80006f58:	00090513          	mv	a0,s2
    80006f5c:	ffffe097          	auipc	ra,0xffffe
    80006f60:	290080e7          	jalr	656(ra) # 800051ec <dirlookup>
    80006f64:	00050493          	mv	s1,a0
    80006f68:	06050e63          	beqz	a0,80006fe4 <create+0xe0>
    iunlockput(dp);
    80006f6c:	00090513          	mv	a0,s2
    80006f70:	ffffe097          	auipc	ra,0xffffe
    80006f74:	ec4080e7          	jalr	-316(ra) # 80004e34 <iunlockput>
    ilock(ip);
    80006f78:	00048513          	mv	a0,s1
    80006f7c:	ffffe097          	auipc	ra,0xffffe
    80006f80:	b7c080e7          	jalr	-1156(ra) # 80004af8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80006f84:	0009899b          	sext.w	s3,s3
    80006f88:	00200793          	li	a5,2
    80006f8c:	04f99263          	bne	s3,a5,80006fd0 <create+0xcc>
    80006f90:	0444d783          	lhu	a5,68(s1)
    80006f94:	ffe7879b          	addiw	a5,a5,-2
    80006f98:	03079793          	slli	a5,a5,0x30
    80006f9c:	0307d793          	srli	a5,a5,0x30
    80006fa0:	00100713          	li	a4,1
    80006fa4:	02f76663          	bltu	a4,a5,80006fd0 <create+0xcc>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80006fa8:	00048513          	mv	a0,s1
    80006fac:	04813083          	ld	ra,72(sp)
    80006fb0:	04013403          	ld	s0,64(sp)
    80006fb4:	03813483          	ld	s1,56(sp)
    80006fb8:	03013903          	ld	s2,48(sp)
    80006fbc:	02813983          	ld	s3,40(sp)
    80006fc0:	02013a03          	ld	s4,32(sp)
    80006fc4:	01813a83          	ld	s5,24(sp)
    80006fc8:	05010113          	addi	sp,sp,80
    80006fcc:	00008067          	ret
    iunlockput(ip);
    80006fd0:	00048513          	mv	a0,s1
    80006fd4:	ffffe097          	auipc	ra,0xffffe
    80006fd8:	e60080e7          	jalr	-416(ra) # 80004e34 <iunlockput>
    return 0;
    80006fdc:	00000493          	li	s1,0
    80006fe0:	fc9ff06f          	j	80006fa8 <create+0xa4>
  if((ip = ialloc(dp->dev, type)) == 0)
    80006fe4:	00098593          	mv	a1,s3
    80006fe8:	00092503          	lw	a0,0(s2)
    80006fec:	ffffe097          	auipc	ra,0xffffe
    80006ff0:	8d4080e7          	jalr	-1836(ra) # 800048c0 <ialloc>
    80006ff4:	00050493          	mv	s1,a0
    80006ff8:	04050c63          	beqz	a0,80007050 <create+0x14c>
  ilock(ip);
    80006ffc:	ffffe097          	auipc	ra,0xffffe
    80007000:	afc080e7          	jalr	-1284(ra) # 80004af8 <ilock>
  ip->major = major;
    80007004:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80007008:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000700c:	00100a13          	li	s4,1
    80007010:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80007014:	00048513          	mv	a0,s1
    80007018:	ffffe097          	auipc	ra,0xffffe
    8000701c:	9c4080e7          	jalr	-1596(ra) # 800049dc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80007020:	0009899b          	sext.w	s3,s3
    80007024:	03498e63          	beq	s3,s4,80007060 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80007028:	0044a603          	lw	a2,4(s1)
    8000702c:	fb040593          	addi	a1,s0,-80
    80007030:	00090513          	mv	a0,s2
    80007034:	ffffe097          	auipc	ra,0xffffe
    80007038:	4a8080e7          	jalr	1192(ra) # 800054dc <dirlink>
    8000703c:	08054263          	bltz	a0,800070c0 <create+0x1bc>
  iunlockput(dp);
    80007040:	00090513          	mv	a0,s2
    80007044:	ffffe097          	auipc	ra,0xffffe
    80007048:	df0080e7          	jalr	-528(ra) # 80004e34 <iunlockput>
  return ip;
    8000704c:	f5dff06f          	j	80006fa8 <create+0xa4>
    panic("create: ialloc");
    80007050:	00003517          	auipc	a0,0x3
    80007054:	6f050513          	addi	a0,a0,1776 # 8000a740 <syscalls+0x300>
    80007058:	ffff9097          	auipc	ra,0xffff9
    8000705c:	674080e7          	jalr	1652(ra) # 800006cc <panic>
    dp->nlink++;  // for ".."
    80007060:	04a95783          	lhu	a5,74(s2)
    80007064:	0017879b          	addiw	a5,a5,1
    80007068:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000706c:	00090513          	mv	a0,s2
    80007070:	ffffe097          	auipc	ra,0xffffe
    80007074:	96c080e7          	jalr	-1684(ra) # 800049dc <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80007078:	0044a603          	lw	a2,4(s1)
    8000707c:	00003597          	auipc	a1,0x3
    80007080:	6d458593          	addi	a1,a1,1748 # 8000a750 <syscalls+0x310>
    80007084:	00048513          	mv	a0,s1
    80007088:	ffffe097          	auipc	ra,0xffffe
    8000708c:	454080e7          	jalr	1108(ra) # 800054dc <dirlink>
    80007090:	02054063          	bltz	a0,800070b0 <create+0x1ac>
    80007094:	00492603          	lw	a2,4(s2)
    80007098:	00003597          	auipc	a1,0x3
    8000709c:	6c058593          	addi	a1,a1,1728 # 8000a758 <syscalls+0x318>
    800070a0:	00048513          	mv	a0,s1
    800070a4:	ffffe097          	auipc	ra,0xffffe
    800070a8:	438080e7          	jalr	1080(ra) # 800054dc <dirlink>
    800070ac:	f6055ee3          	bgez	a0,80007028 <create+0x124>
      panic("create dots");
    800070b0:	00003517          	auipc	a0,0x3
    800070b4:	6b050513          	addi	a0,a0,1712 # 8000a760 <syscalls+0x320>
    800070b8:	ffff9097          	auipc	ra,0xffff9
    800070bc:	614080e7          	jalr	1556(ra) # 800006cc <panic>
    panic("create: dirlink");
    800070c0:	00003517          	auipc	a0,0x3
    800070c4:	6b050513          	addi	a0,a0,1712 # 8000a770 <syscalls+0x330>
    800070c8:	ffff9097          	auipc	ra,0xffff9
    800070cc:	604080e7          	jalr	1540(ra) # 800006cc <panic>
    return 0;
    800070d0:	00050493          	mv	s1,a0
    800070d4:	ed5ff06f          	j	80006fa8 <create+0xa4>

00000000800070d8 <sys_dup>:
{
    800070d8:	fd010113          	addi	sp,sp,-48
    800070dc:	02113423          	sd	ra,40(sp)
    800070e0:	02813023          	sd	s0,32(sp)
    800070e4:	00913c23          	sd	s1,24(sp)
    800070e8:	03010413          	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800070ec:	fd840613          	addi	a2,s0,-40
    800070f0:	00000593          	li	a1,0
    800070f4:	00000513          	li	a0,0
    800070f8:	00000097          	auipc	ra,0x0
    800070fc:	cfc080e7          	jalr	-772(ra) # 80006df4 <argfd>
    return -1;
    80007100:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80007104:	02054663          	bltz	a0,80007130 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
    80007108:	fd843503          	ld	a0,-40(s0)
    8000710c:	00000097          	auipc	ra,0x0
    80007110:	d88080e7          	jalr	-632(ra) # 80006e94 <fdalloc>
    80007114:	00050493          	mv	s1,a0
    return -1;
    80007118:	fff00793          	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000711c:	00054a63          	bltz	a0,80007130 <sys_dup+0x58>
  filedup(f);
    80007120:	fd843503          	ld	a0,-40(s0)
    80007124:	fffff097          	auipc	ra,0xfffff
    80007128:	dd8080e7          	jalr	-552(ra) # 80005efc <filedup>
  return fd;
    8000712c:	00048793          	mv	a5,s1
}
    80007130:	00078513          	mv	a0,a5
    80007134:	02813083          	ld	ra,40(sp)
    80007138:	02013403          	ld	s0,32(sp)
    8000713c:	01813483          	ld	s1,24(sp)
    80007140:	03010113          	addi	sp,sp,48
    80007144:	00008067          	ret

0000000080007148 <sys_read>:
{
    80007148:	fd010113          	addi	sp,sp,-48
    8000714c:	02113423          	sd	ra,40(sp)
    80007150:	02813023          	sd	s0,32(sp)
    80007154:	03010413          	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80007158:	fe840613          	addi	a2,s0,-24
    8000715c:	00000593          	li	a1,0
    80007160:	00000513          	li	a0,0
    80007164:	00000097          	auipc	ra,0x0
    80007168:	c90080e7          	jalr	-880(ra) # 80006df4 <argfd>
    return -1;
    8000716c:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80007170:	04054663          	bltz	a0,800071bc <sys_read+0x74>
    80007174:	fe440593          	addi	a1,s0,-28
    80007178:	00200513          	li	a0,2
    8000717c:	ffffd097          	auipc	ra,0xffffd
    80007180:	9b4080e7          	jalr	-1612(ra) # 80003b30 <argint>
    return -1;
    80007184:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80007188:	02054a63          	bltz	a0,800071bc <sys_read+0x74>
    8000718c:	fd840593          	addi	a1,s0,-40
    80007190:	00100513          	li	a0,1
    80007194:	ffffd097          	auipc	ra,0xffffd
    80007198:	9d8080e7          	jalr	-1576(ra) # 80003b6c <argaddr>
    return -1;
    8000719c:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800071a0:	00054e63          	bltz	a0,800071bc <sys_read+0x74>
  return fileread(f, p, n);
    800071a4:	fe442603          	lw	a2,-28(s0)
    800071a8:	fd843583          	ld	a1,-40(s0)
    800071ac:	fe843503          	ld	a0,-24(s0)
    800071b0:	fffff097          	auipc	ra,0xfffff
    800071b4:	f68080e7          	jalr	-152(ra) # 80006118 <fileread>
    800071b8:	00050793          	mv	a5,a0
}
    800071bc:	00078513          	mv	a0,a5
    800071c0:	02813083          	ld	ra,40(sp)
    800071c4:	02013403          	ld	s0,32(sp)
    800071c8:	03010113          	addi	sp,sp,48
    800071cc:	00008067          	ret

00000000800071d0 <sys_write>:
{
    800071d0:	fd010113          	addi	sp,sp,-48
    800071d4:	02113423          	sd	ra,40(sp)
    800071d8:	02813023          	sd	s0,32(sp)
    800071dc:	03010413          	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800071e0:	fe840613          	addi	a2,s0,-24
    800071e4:	00000593          	li	a1,0
    800071e8:	00000513          	li	a0,0
    800071ec:	00000097          	auipc	ra,0x0
    800071f0:	c08080e7          	jalr	-1016(ra) # 80006df4 <argfd>
    return -1;
    800071f4:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800071f8:	04054663          	bltz	a0,80007244 <sys_write+0x74>
    800071fc:	fe440593          	addi	a1,s0,-28
    80007200:	00200513          	li	a0,2
    80007204:	ffffd097          	auipc	ra,0xffffd
    80007208:	92c080e7          	jalr	-1748(ra) # 80003b30 <argint>
    return -1;
    8000720c:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80007210:	02054a63          	bltz	a0,80007244 <sys_write+0x74>
    80007214:	fd840593          	addi	a1,s0,-40
    80007218:	00100513          	li	a0,1
    8000721c:	ffffd097          	auipc	ra,0xffffd
    80007220:	950080e7          	jalr	-1712(ra) # 80003b6c <argaddr>
    return -1;
    80007224:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80007228:	00054e63          	bltz	a0,80007244 <sys_write+0x74>
  return filewrite(f, p, n);
    8000722c:	fe442603          	lw	a2,-28(s0)
    80007230:	fd843583          	ld	a1,-40(s0)
    80007234:	fe843503          	ld	a0,-24(s0)
    80007238:	fffff097          	auipc	ra,0xfffff
    8000723c:	00c080e7          	jalr	12(ra) # 80006244 <filewrite>
    80007240:	00050793          	mv	a5,a0
}
    80007244:	00078513          	mv	a0,a5
    80007248:	02813083          	ld	ra,40(sp)
    8000724c:	02013403          	ld	s0,32(sp)
    80007250:	03010113          	addi	sp,sp,48
    80007254:	00008067          	ret

0000000080007258 <sys_close>:
{
    80007258:	fe010113          	addi	sp,sp,-32
    8000725c:	00113c23          	sd	ra,24(sp)
    80007260:	00813823          	sd	s0,16(sp)
    80007264:	02010413          	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80007268:	fe040613          	addi	a2,s0,-32
    8000726c:	fec40593          	addi	a1,s0,-20
    80007270:	00000513          	li	a0,0
    80007274:	00000097          	auipc	ra,0x0
    80007278:	b80080e7          	jalr	-1152(ra) # 80006df4 <argfd>
    return -1;
    8000727c:	fff00793          	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80007280:	02054863          	bltz	a0,800072b0 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
    80007284:	ffffb097          	auipc	ra,0xffffb
    80007288:	168080e7          	jalr	360(ra) # 800023ec <myproc>
    8000728c:	fec42783          	lw	a5,-20(s0)
    80007290:	01a78793          	addi	a5,a5,26
    80007294:	00379793          	slli	a5,a5,0x3
    80007298:	00f507b3          	add	a5,a0,a5
    8000729c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800072a0:	fe043503          	ld	a0,-32(s0)
    800072a4:	fffff097          	auipc	ra,0xfffff
    800072a8:	cc8080e7          	jalr	-824(ra) # 80005f6c <fileclose>
  return 0;
    800072ac:	00000793          	li	a5,0
}
    800072b0:	00078513          	mv	a0,a5
    800072b4:	01813083          	ld	ra,24(sp)
    800072b8:	01013403          	ld	s0,16(sp)
    800072bc:	02010113          	addi	sp,sp,32
    800072c0:	00008067          	ret

00000000800072c4 <sys_fstat>:
{
    800072c4:	fe010113          	addi	sp,sp,-32
    800072c8:	00113c23          	sd	ra,24(sp)
    800072cc:	00813823          	sd	s0,16(sp)
    800072d0:	02010413          	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800072d4:	fe840613          	addi	a2,s0,-24
    800072d8:	00000593          	li	a1,0
    800072dc:	00000513          	li	a0,0
    800072e0:	00000097          	auipc	ra,0x0
    800072e4:	b14080e7          	jalr	-1260(ra) # 80006df4 <argfd>
    return -1;
    800072e8:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800072ec:	02054863          	bltz	a0,8000731c <sys_fstat+0x58>
    800072f0:	fe040593          	addi	a1,s0,-32
    800072f4:	00100513          	li	a0,1
    800072f8:	ffffd097          	auipc	ra,0xffffd
    800072fc:	874080e7          	jalr	-1932(ra) # 80003b6c <argaddr>
    return -1;
    80007300:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80007304:	00054c63          	bltz	a0,8000731c <sys_fstat+0x58>
  return filestat(f, st);
    80007308:	fe043583          	ld	a1,-32(s0)
    8000730c:	fe843503          	ld	a0,-24(s0)
    80007310:	fffff097          	auipc	ra,0xfffff
    80007314:	d60080e7          	jalr	-672(ra) # 80006070 <filestat>
    80007318:	00050793          	mv	a5,a0
}
    8000731c:	00078513          	mv	a0,a5
    80007320:	01813083          	ld	ra,24(sp)
    80007324:	01013403          	ld	s0,16(sp)
    80007328:	02010113          	addi	sp,sp,32
    8000732c:	00008067          	ret

0000000080007330 <sys_link>:
{
    80007330:	ed010113          	addi	sp,sp,-304
    80007334:	12113423          	sd	ra,296(sp)
    80007338:	12813023          	sd	s0,288(sp)
    8000733c:	10913c23          	sd	s1,280(sp)
    80007340:	11213823          	sd	s2,272(sp)
    80007344:	13010413          	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80007348:	08000613          	li	a2,128
    8000734c:	ed040593          	addi	a1,s0,-304
    80007350:	00000513          	li	a0,0
    80007354:	ffffd097          	auipc	ra,0xffffd
    80007358:	854080e7          	jalr	-1964(ra) # 80003ba8 <argstr>
    return -1;
    8000735c:	fff00793          	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80007360:	14054a63          	bltz	a0,800074b4 <sys_link+0x184>
    80007364:	08000613          	li	a2,128
    80007368:	f5040593          	addi	a1,s0,-176
    8000736c:	00100513          	li	a0,1
    80007370:	ffffd097          	auipc	ra,0xffffd
    80007374:	838080e7          	jalr	-1992(ra) # 80003ba8 <argstr>
    return -1;
    80007378:	fff00793          	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000737c:	12054c63          	bltz	a0,800074b4 <sys_link+0x184>
  begin_op();
    80007380:	ffffe097          	auipc	ra,0xffffe
    80007384:	560080e7          	jalr	1376(ra) # 800058e0 <begin_op>
  if((ip = namei(old)) == 0){
    80007388:	ed040513          	addi	a0,s0,-304
    8000738c:	ffffe097          	auipc	ra,0xffffe
    80007390:	264080e7          	jalr	612(ra) # 800055f0 <namei>
    80007394:	00050493          	mv	s1,a0
    80007398:	0a050463          	beqz	a0,80007440 <sys_link+0x110>
  ilock(ip);
    8000739c:	ffffd097          	auipc	ra,0xffffd
    800073a0:	75c080e7          	jalr	1884(ra) # 80004af8 <ilock>
  if(ip->type == T_DIR){
    800073a4:	04449703          	lh	a4,68(s1)
    800073a8:	00100793          	li	a5,1
    800073ac:	0af70263          	beq	a4,a5,80007450 <sys_link+0x120>
  ip->nlink++;
    800073b0:	04a4d783          	lhu	a5,74(s1)
    800073b4:	0017879b          	addiw	a5,a5,1
    800073b8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800073bc:	00048513          	mv	a0,s1
    800073c0:	ffffd097          	auipc	ra,0xffffd
    800073c4:	61c080e7          	jalr	1564(ra) # 800049dc <iupdate>
  iunlock(ip);
    800073c8:	00048513          	mv	a0,s1
    800073cc:	ffffe097          	auipc	ra,0xffffe
    800073d0:	830080e7          	jalr	-2000(ra) # 80004bfc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800073d4:	fd040593          	addi	a1,s0,-48
    800073d8:	f5040513          	addi	a0,s0,-176
    800073dc:	ffffe097          	auipc	ra,0xffffe
    800073e0:	244080e7          	jalr	580(ra) # 80005620 <nameiparent>
    800073e4:	00050913          	mv	s2,a0
    800073e8:	08050863          	beqz	a0,80007478 <sys_link+0x148>
  ilock(dp);
    800073ec:	ffffd097          	auipc	ra,0xffffd
    800073f0:	70c080e7          	jalr	1804(ra) # 80004af8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800073f4:	00092703          	lw	a4,0(s2)
    800073f8:	0004a783          	lw	a5,0(s1)
    800073fc:	06f71863          	bne	a4,a5,8000746c <sys_link+0x13c>
    80007400:	0044a603          	lw	a2,4(s1)
    80007404:	fd040593          	addi	a1,s0,-48
    80007408:	00090513          	mv	a0,s2
    8000740c:	ffffe097          	auipc	ra,0xffffe
    80007410:	0d0080e7          	jalr	208(ra) # 800054dc <dirlink>
    80007414:	04054c63          	bltz	a0,8000746c <sys_link+0x13c>
  iunlockput(dp);
    80007418:	00090513          	mv	a0,s2
    8000741c:	ffffe097          	auipc	ra,0xffffe
    80007420:	a18080e7          	jalr	-1512(ra) # 80004e34 <iunlockput>
  iput(ip);
    80007424:	00048513          	mv	a0,s1
    80007428:	ffffe097          	auipc	ra,0xffffe
    8000742c:	930080e7          	jalr	-1744(ra) # 80004d58 <iput>
  end_op();
    80007430:	ffffe097          	auipc	ra,0xffffe
    80007434:	564080e7          	jalr	1380(ra) # 80005994 <end_op>
  return 0;
    80007438:	00000793          	li	a5,0
    8000743c:	0780006f          	j	800074b4 <sys_link+0x184>
    end_op();
    80007440:	ffffe097          	auipc	ra,0xffffe
    80007444:	554080e7          	jalr	1364(ra) # 80005994 <end_op>
    return -1;
    80007448:	fff00793          	li	a5,-1
    8000744c:	0680006f          	j	800074b4 <sys_link+0x184>
    iunlockput(ip);
    80007450:	00048513          	mv	a0,s1
    80007454:	ffffe097          	auipc	ra,0xffffe
    80007458:	9e0080e7          	jalr	-1568(ra) # 80004e34 <iunlockput>
    end_op();
    8000745c:	ffffe097          	auipc	ra,0xffffe
    80007460:	538080e7          	jalr	1336(ra) # 80005994 <end_op>
    return -1;
    80007464:	fff00793          	li	a5,-1
    80007468:	04c0006f          	j	800074b4 <sys_link+0x184>
    iunlockput(dp);
    8000746c:	00090513          	mv	a0,s2
    80007470:	ffffe097          	auipc	ra,0xffffe
    80007474:	9c4080e7          	jalr	-1596(ra) # 80004e34 <iunlockput>
  ilock(ip);
    80007478:	00048513          	mv	a0,s1
    8000747c:	ffffd097          	auipc	ra,0xffffd
    80007480:	67c080e7          	jalr	1660(ra) # 80004af8 <ilock>
  ip->nlink--;
    80007484:	04a4d783          	lhu	a5,74(s1)
    80007488:	fff7879b          	addiw	a5,a5,-1
    8000748c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80007490:	00048513          	mv	a0,s1
    80007494:	ffffd097          	auipc	ra,0xffffd
    80007498:	548080e7          	jalr	1352(ra) # 800049dc <iupdate>
  iunlockput(ip);
    8000749c:	00048513          	mv	a0,s1
    800074a0:	ffffe097          	auipc	ra,0xffffe
    800074a4:	994080e7          	jalr	-1644(ra) # 80004e34 <iunlockput>
  end_op();
    800074a8:	ffffe097          	auipc	ra,0xffffe
    800074ac:	4ec080e7          	jalr	1260(ra) # 80005994 <end_op>
  return -1;
    800074b0:	fff00793          	li	a5,-1
}
    800074b4:	00078513          	mv	a0,a5
    800074b8:	12813083          	ld	ra,296(sp)
    800074bc:	12013403          	ld	s0,288(sp)
    800074c0:	11813483          	ld	s1,280(sp)
    800074c4:	11013903          	ld	s2,272(sp)
    800074c8:	13010113          	addi	sp,sp,304
    800074cc:	00008067          	ret

00000000800074d0 <sys_unlink>:
{
    800074d0:	f1010113          	addi	sp,sp,-240
    800074d4:	0e113423          	sd	ra,232(sp)
    800074d8:	0e813023          	sd	s0,224(sp)
    800074dc:	0c913c23          	sd	s1,216(sp)
    800074e0:	0d213823          	sd	s2,208(sp)
    800074e4:	0d313423          	sd	s3,200(sp)
    800074e8:	0f010413          	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800074ec:	08000613          	li	a2,128
    800074f0:	f3040593          	addi	a1,s0,-208
    800074f4:	00000513          	li	a0,0
    800074f8:	ffffc097          	auipc	ra,0xffffc
    800074fc:	6b0080e7          	jalr	1712(ra) # 80003ba8 <argstr>
    80007500:	1c054063          	bltz	a0,800076c0 <sys_unlink+0x1f0>
  begin_op();
    80007504:	ffffe097          	auipc	ra,0xffffe
    80007508:	3dc080e7          	jalr	988(ra) # 800058e0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000750c:	fb040593          	addi	a1,s0,-80
    80007510:	f3040513          	addi	a0,s0,-208
    80007514:	ffffe097          	auipc	ra,0xffffe
    80007518:	10c080e7          	jalr	268(ra) # 80005620 <nameiparent>
    8000751c:	00050493          	mv	s1,a0
    80007520:	0e050c63          	beqz	a0,80007618 <sys_unlink+0x148>
  ilock(dp);
    80007524:	ffffd097          	auipc	ra,0xffffd
    80007528:	5d4080e7          	jalr	1492(ra) # 80004af8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000752c:	00003597          	auipc	a1,0x3
    80007530:	22458593          	addi	a1,a1,548 # 8000a750 <syscalls+0x310>
    80007534:	fb040513          	addi	a0,s0,-80
    80007538:	ffffe097          	auipc	ra,0xffffe
    8000753c:	c88080e7          	jalr	-888(ra) # 800051c0 <namecmp>
    80007540:	18050a63          	beqz	a0,800076d4 <sys_unlink+0x204>
    80007544:	00003597          	auipc	a1,0x3
    80007548:	21458593          	addi	a1,a1,532 # 8000a758 <syscalls+0x318>
    8000754c:	fb040513          	addi	a0,s0,-80
    80007550:	ffffe097          	auipc	ra,0xffffe
    80007554:	c70080e7          	jalr	-912(ra) # 800051c0 <namecmp>
    80007558:	16050e63          	beqz	a0,800076d4 <sys_unlink+0x204>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000755c:	f2c40613          	addi	a2,s0,-212
    80007560:	fb040593          	addi	a1,s0,-80
    80007564:	00048513          	mv	a0,s1
    80007568:	ffffe097          	auipc	ra,0xffffe
    8000756c:	c84080e7          	jalr	-892(ra) # 800051ec <dirlookup>
    80007570:	00050913          	mv	s2,a0
    80007574:	16050063          	beqz	a0,800076d4 <sys_unlink+0x204>
  ilock(ip);
    80007578:	ffffd097          	auipc	ra,0xffffd
    8000757c:	580080e7          	jalr	1408(ra) # 80004af8 <ilock>
  if(ip->nlink < 1)
    80007580:	04a91783          	lh	a5,74(s2)
    80007584:	0af05263          	blez	a5,80007628 <sys_unlink+0x158>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80007588:	04491703          	lh	a4,68(s2)
    8000758c:	00100793          	li	a5,1
    80007590:	0af70463          	beq	a4,a5,80007638 <sys_unlink+0x168>
  memset(&de, 0, sizeof(de));
    80007594:	01000613          	li	a2,16
    80007598:	00000593          	li	a1,0
    8000759c:	fc040513          	addi	a0,s0,-64
    800075a0:	ffffa097          	auipc	ra,0xffffa
    800075a4:	b20080e7          	jalr	-1248(ra) # 800010c0 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800075a8:	01000713          	li	a4,16
    800075ac:	f2c42683          	lw	a3,-212(s0)
    800075b0:	fc040613          	addi	a2,s0,-64
    800075b4:	00000593          	li	a1,0
    800075b8:	00048513          	mv	a0,s1
    800075bc:	ffffe097          	auipc	ra,0xffffe
    800075c0:	a68080e7          	jalr	-1432(ra) # 80005024 <writei>
    800075c4:	01000793          	li	a5,16
    800075c8:	0cf51663          	bne	a0,a5,80007694 <sys_unlink+0x1c4>
  if(ip->type == T_DIR){
    800075cc:	04491703          	lh	a4,68(s2)
    800075d0:	00100793          	li	a5,1
    800075d4:	0cf70863          	beq	a4,a5,800076a4 <sys_unlink+0x1d4>
  iunlockput(dp);
    800075d8:	00048513          	mv	a0,s1
    800075dc:	ffffe097          	auipc	ra,0xffffe
    800075e0:	858080e7          	jalr	-1960(ra) # 80004e34 <iunlockput>
  ip->nlink--;
    800075e4:	04a95783          	lhu	a5,74(s2)
    800075e8:	fff7879b          	addiw	a5,a5,-1
    800075ec:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800075f0:	00090513          	mv	a0,s2
    800075f4:	ffffd097          	auipc	ra,0xffffd
    800075f8:	3e8080e7          	jalr	1000(ra) # 800049dc <iupdate>
  iunlockput(ip);
    800075fc:	00090513          	mv	a0,s2
    80007600:	ffffe097          	auipc	ra,0xffffe
    80007604:	834080e7          	jalr	-1996(ra) # 80004e34 <iunlockput>
  end_op();
    80007608:	ffffe097          	auipc	ra,0xffffe
    8000760c:	38c080e7          	jalr	908(ra) # 80005994 <end_op>
  return 0;
    80007610:	00000513          	li	a0,0
    80007614:	0d80006f          	j	800076ec <sys_unlink+0x21c>
    end_op();
    80007618:	ffffe097          	auipc	ra,0xffffe
    8000761c:	37c080e7          	jalr	892(ra) # 80005994 <end_op>
    return -1;
    80007620:	fff00513          	li	a0,-1
    80007624:	0c80006f          	j	800076ec <sys_unlink+0x21c>
    panic("unlink: nlink < 1");
    80007628:	00003517          	auipc	a0,0x3
    8000762c:	15850513          	addi	a0,a0,344 # 8000a780 <syscalls+0x340>
    80007630:	ffff9097          	auipc	ra,0xffff9
    80007634:	09c080e7          	jalr	156(ra) # 800006cc <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007638:	04c92703          	lw	a4,76(s2)
    8000763c:	02000793          	li	a5,32
    80007640:	f4e7fae3          	bgeu	a5,a4,80007594 <sys_unlink+0xc4>
    80007644:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007648:	01000713          	li	a4,16
    8000764c:	00098693          	mv	a3,s3
    80007650:	f1840613          	addi	a2,s0,-232
    80007654:	00000593          	li	a1,0
    80007658:	00090513          	mv	a0,s2
    8000765c:	ffffe097          	auipc	ra,0xffffe
    80007660:	858080e7          	jalr	-1960(ra) # 80004eb4 <readi>
    80007664:	01000793          	li	a5,16
    80007668:	00f51e63          	bne	a0,a5,80007684 <sys_unlink+0x1b4>
    if(de.inum != 0)
    8000766c:	f1845783          	lhu	a5,-232(s0)
    80007670:	04079c63          	bnez	a5,800076c8 <sys_unlink+0x1f8>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007674:	0109899b          	addiw	s3,s3,16
    80007678:	04c92783          	lw	a5,76(s2)
    8000767c:	fcf9e6e3          	bltu	s3,a5,80007648 <sys_unlink+0x178>
    80007680:	f15ff06f          	j	80007594 <sys_unlink+0xc4>
      panic("isdirempty: readi");
    80007684:	00003517          	auipc	a0,0x3
    80007688:	11450513          	addi	a0,a0,276 # 8000a798 <syscalls+0x358>
    8000768c:	ffff9097          	auipc	ra,0xffff9
    80007690:	040080e7          	jalr	64(ra) # 800006cc <panic>
    panic("unlink: writei");
    80007694:	00003517          	auipc	a0,0x3
    80007698:	11c50513          	addi	a0,a0,284 # 8000a7b0 <syscalls+0x370>
    8000769c:	ffff9097          	auipc	ra,0xffff9
    800076a0:	030080e7          	jalr	48(ra) # 800006cc <panic>
    dp->nlink--;
    800076a4:	04a4d783          	lhu	a5,74(s1)
    800076a8:	fff7879b          	addiw	a5,a5,-1
    800076ac:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800076b0:	00048513          	mv	a0,s1
    800076b4:	ffffd097          	auipc	ra,0xffffd
    800076b8:	328080e7          	jalr	808(ra) # 800049dc <iupdate>
    800076bc:	f1dff06f          	j	800075d8 <sys_unlink+0x108>
    return -1;
    800076c0:	fff00513          	li	a0,-1
    800076c4:	0280006f          	j	800076ec <sys_unlink+0x21c>
    iunlockput(ip);
    800076c8:	00090513          	mv	a0,s2
    800076cc:	ffffd097          	auipc	ra,0xffffd
    800076d0:	768080e7          	jalr	1896(ra) # 80004e34 <iunlockput>
  iunlockput(dp);
    800076d4:	00048513          	mv	a0,s1
    800076d8:	ffffd097          	auipc	ra,0xffffd
    800076dc:	75c080e7          	jalr	1884(ra) # 80004e34 <iunlockput>
  end_op();
    800076e0:	ffffe097          	auipc	ra,0xffffe
    800076e4:	2b4080e7          	jalr	692(ra) # 80005994 <end_op>
  return -1;
    800076e8:	fff00513          	li	a0,-1
}
    800076ec:	0e813083          	ld	ra,232(sp)
    800076f0:	0e013403          	ld	s0,224(sp)
    800076f4:	0d813483          	ld	s1,216(sp)
    800076f8:	0d013903          	ld	s2,208(sp)
    800076fc:	0c813983          	ld	s3,200(sp)
    80007700:	0f010113          	addi	sp,sp,240
    80007704:	00008067          	ret

0000000080007708 <sys_open>:

uint64
sys_open(void)
{
    80007708:	f4010113          	addi	sp,sp,-192
    8000770c:	0a113c23          	sd	ra,184(sp)
    80007710:	0a813823          	sd	s0,176(sp)
    80007714:	0a913423          	sd	s1,168(sp)
    80007718:	0b213023          	sd	s2,160(sp)
    8000771c:	09313c23          	sd	s3,152(sp)
    80007720:	0c010413          	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80007724:	08000613          	li	a2,128
    80007728:	f5040593          	addi	a1,s0,-176
    8000772c:	00000513          	li	a0,0
    80007730:	ffffc097          	auipc	ra,0xffffc
    80007734:	478080e7          	jalr	1144(ra) # 80003ba8 <argstr>
    return -1;
    80007738:	fff00493          	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000773c:	0e054263          	bltz	a0,80007820 <sys_open+0x118>
    80007740:	f4c40593          	addi	a1,s0,-180
    80007744:	00100513          	li	a0,1
    80007748:	ffffc097          	auipc	ra,0xffffc
    8000774c:	3e8080e7          	jalr	1000(ra) # 80003b30 <argint>
    80007750:	0c054863          	bltz	a0,80007820 <sys_open+0x118>

  begin_op();
    80007754:	ffffe097          	auipc	ra,0xffffe
    80007758:	18c080e7          	jalr	396(ra) # 800058e0 <begin_op>

  if(omode & O_CREATE){
    8000775c:	f4c42783          	lw	a5,-180(s0)
    80007760:	2007f793          	andi	a5,a5,512
    80007764:	0e078463          	beqz	a5,8000784c <sys_open+0x144>
    ip = create(path, T_FILE, 0, 0);
    80007768:	00000693          	li	a3,0
    8000776c:	00000613          	li	a2,0
    80007770:	00200593          	li	a1,2
    80007774:	f5040513          	addi	a0,s0,-176
    80007778:	fffff097          	auipc	ra,0xfffff
    8000777c:	78c080e7          	jalr	1932(ra) # 80006f04 <create>
    80007780:	00050913          	mv	s2,a0
    if(ip == 0){
    80007784:	0a050e63          	beqz	a0,80007840 <sys_open+0x138>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80007788:	04491703          	lh	a4,68(s2)
    8000778c:	00300793          	li	a5,3
    80007790:	00f71863          	bne	a4,a5,800077a0 <sys_open+0x98>
    80007794:	04695703          	lhu	a4,70(s2)
    80007798:	00900793          	li	a5,9
    8000779c:	10e7e663          	bltu	a5,a4,800078a8 <sys_open+0x1a0>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800077a0:	ffffe097          	auipc	ra,0xffffe
    800077a4:	6d0080e7          	jalr	1744(ra) # 80005e70 <filealloc>
    800077a8:	00050993          	mv	s3,a0
    800077ac:	14050263          	beqz	a0,800078f0 <sys_open+0x1e8>
    800077b0:	fffff097          	auipc	ra,0xfffff
    800077b4:	6e4080e7          	jalr	1764(ra) # 80006e94 <fdalloc>
    800077b8:	00050493          	mv	s1,a0
    800077bc:	12054463          	bltz	a0,800078e4 <sys_open+0x1dc>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800077c0:	04491703          	lh	a4,68(s2)
    800077c4:	00300793          	li	a5,3
    800077c8:	0ef70e63          	beq	a4,a5,800078c4 <sys_open+0x1bc>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800077cc:	00200793          	li	a5,2
    800077d0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800077d4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800077d8:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800077dc:	f4c42783          	lw	a5,-180(s0)
    800077e0:	0017c713          	xori	a4,a5,1
    800077e4:	00177713          	andi	a4,a4,1
    800077e8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800077ec:	0037f713          	andi	a4,a5,3
    800077f0:	00e03733          	snez	a4,a4
    800077f4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800077f8:	4007f793          	andi	a5,a5,1024
    800077fc:	00078863          	beqz	a5,8000780c <sys_open+0x104>
    80007800:	04491703          	lh	a4,68(s2)
    80007804:	00200793          	li	a5,2
    80007808:	0cf70663          	beq	a4,a5,800078d4 <sys_open+0x1cc>
    itrunc(ip);
  }

  iunlock(ip);
    8000780c:	00090513          	mv	a0,s2
    80007810:	ffffd097          	auipc	ra,0xffffd
    80007814:	3ec080e7          	jalr	1004(ra) # 80004bfc <iunlock>
  end_op();
    80007818:	ffffe097          	auipc	ra,0xffffe
    8000781c:	17c080e7          	jalr	380(ra) # 80005994 <end_op>

  return fd;
}
    80007820:	00048513          	mv	a0,s1
    80007824:	0b813083          	ld	ra,184(sp)
    80007828:	0b013403          	ld	s0,176(sp)
    8000782c:	0a813483          	ld	s1,168(sp)
    80007830:	0a013903          	ld	s2,160(sp)
    80007834:	09813983          	ld	s3,152(sp)
    80007838:	0c010113          	addi	sp,sp,192
    8000783c:	00008067          	ret
      end_op();
    80007840:	ffffe097          	auipc	ra,0xffffe
    80007844:	154080e7          	jalr	340(ra) # 80005994 <end_op>
      return -1;
    80007848:	fd9ff06f          	j	80007820 <sys_open+0x118>
    if((ip = namei(path)) == 0){
    8000784c:	f5040513          	addi	a0,s0,-176
    80007850:	ffffe097          	auipc	ra,0xffffe
    80007854:	da0080e7          	jalr	-608(ra) # 800055f0 <namei>
    80007858:	00050913          	mv	s2,a0
    8000785c:	02050e63          	beqz	a0,80007898 <sys_open+0x190>
    ilock(ip);
    80007860:	ffffd097          	auipc	ra,0xffffd
    80007864:	298080e7          	jalr	664(ra) # 80004af8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80007868:	04491703          	lh	a4,68(s2)
    8000786c:	00100793          	li	a5,1
    80007870:	f0f71ce3          	bne	a4,a5,80007788 <sys_open+0x80>
    80007874:	f4c42783          	lw	a5,-180(s0)
    80007878:	f20784e3          	beqz	a5,800077a0 <sys_open+0x98>
      iunlockput(ip);
    8000787c:	00090513          	mv	a0,s2
    80007880:	ffffd097          	auipc	ra,0xffffd
    80007884:	5b4080e7          	jalr	1460(ra) # 80004e34 <iunlockput>
      end_op();
    80007888:	ffffe097          	auipc	ra,0xffffe
    8000788c:	10c080e7          	jalr	268(ra) # 80005994 <end_op>
      return -1;
    80007890:	fff00493          	li	s1,-1
    80007894:	f8dff06f          	j	80007820 <sys_open+0x118>
      end_op();
    80007898:	ffffe097          	auipc	ra,0xffffe
    8000789c:	0fc080e7          	jalr	252(ra) # 80005994 <end_op>
      return -1;
    800078a0:	fff00493          	li	s1,-1
    800078a4:	f7dff06f          	j	80007820 <sys_open+0x118>
    iunlockput(ip);
    800078a8:	00090513          	mv	a0,s2
    800078ac:	ffffd097          	auipc	ra,0xffffd
    800078b0:	588080e7          	jalr	1416(ra) # 80004e34 <iunlockput>
    end_op();
    800078b4:	ffffe097          	auipc	ra,0xffffe
    800078b8:	0e0080e7          	jalr	224(ra) # 80005994 <end_op>
    return -1;
    800078bc:	fff00493          	li	s1,-1
    800078c0:	f61ff06f          	j	80007820 <sys_open+0x118>
    f->type = FD_DEVICE;
    800078c4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800078c8:	04691783          	lh	a5,70(s2)
    800078cc:	02f99223          	sh	a5,36(s3)
    800078d0:	f09ff06f          	j	800077d8 <sys_open+0xd0>
    itrunc(ip);
    800078d4:	00090513          	mv	a0,s2
    800078d8:	ffffd097          	auipc	ra,0xffffd
    800078dc:	394080e7          	jalr	916(ra) # 80004c6c <itrunc>
    800078e0:	f2dff06f          	j	8000780c <sys_open+0x104>
      fileclose(f);
    800078e4:	00098513          	mv	a0,s3
    800078e8:	ffffe097          	auipc	ra,0xffffe
    800078ec:	684080e7          	jalr	1668(ra) # 80005f6c <fileclose>
    iunlockput(ip);
    800078f0:	00090513          	mv	a0,s2
    800078f4:	ffffd097          	auipc	ra,0xffffd
    800078f8:	540080e7          	jalr	1344(ra) # 80004e34 <iunlockput>
    end_op();
    800078fc:	ffffe097          	auipc	ra,0xffffe
    80007900:	098080e7          	jalr	152(ra) # 80005994 <end_op>
    return -1;
    80007904:	fff00493          	li	s1,-1
    80007908:	f19ff06f          	j	80007820 <sys_open+0x118>

000000008000790c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000790c:	f7010113          	addi	sp,sp,-144
    80007910:	08113423          	sd	ra,136(sp)
    80007914:	08813023          	sd	s0,128(sp)
    80007918:	09010413          	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000791c:	ffffe097          	auipc	ra,0xffffe
    80007920:	fc4080e7          	jalr	-60(ra) # 800058e0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80007924:	08000613          	li	a2,128
    80007928:	f7040593          	addi	a1,s0,-144
    8000792c:	00000513          	li	a0,0
    80007930:	ffffc097          	auipc	ra,0xffffc
    80007934:	278080e7          	jalr	632(ra) # 80003ba8 <argstr>
    80007938:	04054263          	bltz	a0,8000797c <sys_mkdir+0x70>
    8000793c:	00000693          	li	a3,0
    80007940:	00000613          	li	a2,0
    80007944:	00100593          	li	a1,1
    80007948:	f7040513          	addi	a0,s0,-144
    8000794c:	fffff097          	auipc	ra,0xfffff
    80007950:	5b8080e7          	jalr	1464(ra) # 80006f04 <create>
    80007954:	02050463          	beqz	a0,8000797c <sys_mkdir+0x70>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80007958:	ffffd097          	auipc	ra,0xffffd
    8000795c:	4dc080e7          	jalr	1244(ra) # 80004e34 <iunlockput>
  end_op();
    80007960:	ffffe097          	auipc	ra,0xffffe
    80007964:	034080e7          	jalr	52(ra) # 80005994 <end_op>
  return 0;
    80007968:	00000513          	li	a0,0
}
    8000796c:	08813083          	ld	ra,136(sp)
    80007970:	08013403          	ld	s0,128(sp)
    80007974:	09010113          	addi	sp,sp,144
    80007978:	00008067          	ret
    end_op();
    8000797c:	ffffe097          	auipc	ra,0xffffe
    80007980:	018080e7          	jalr	24(ra) # 80005994 <end_op>
    return -1;
    80007984:	fff00513          	li	a0,-1
    80007988:	fe5ff06f          	j	8000796c <sys_mkdir+0x60>

000000008000798c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000798c:	f6010113          	addi	sp,sp,-160
    80007990:	08113c23          	sd	ra,152(sp)
    80007994:	08813823          	sd	s0,144(sp)
    80007998:	0a010413          	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000799c:	ffffe097          	auipc	ra,0xffffe
    800079a0:	f44080e7          	jalr	-188(ra) # 800058e0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800079a4:	08000613          	li	a2,128
    800079a8:	f7040593          	addi	a1,s0,-144
    800079ac:	00000513          	li	a0,0
    800079b0:	ffffc097          	auipc	ra,0xffffc
    800079b4:	1f8080e7          	jalr	504(ra) # 80003ba8 <argstr>
    800079b8:	06054063          	bltz	a0,80007a18 <sys_mknod+0x8c>
     argint(1, &major) < 0 ||
    800079bc:	f6c40593          	addi	a1,s0,-148
    800079c0:	00100513          	li	a0,1
    800079c4:	ffffc097          	auipc	ra,0xffffc
    800079c8:	16c080e7          	jalr	364(ra) # 80003b30 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800079cc:	04054663          	bltz	a0,80007a18 <sys_mknod+0x8c>
     argint(2, &minor) < 0 ||
    800079d0:	f6840593          	addi	a1,s0,-152
    800079d4:	00200513          	li	a0,2
    800079d8:	ffffc097          	auipc	ra,0xffffc
    800079dc:	158080e7          	jalr	344(ra) # 80003b30 <argint>
     argint(1, &major) < 0 ||
    800079e0:	02054c63          	bltz	a0,80007a18 <sys_mknod+0x8c>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800079e4:	f6841683          	lh	a3,-152(s0)
    800079e8:	f6c41603          	lh	a2,-148(s0)
    800079ec:	00300593          	li	a1,3
    800079f0:	f7040513          	addi	a0,s0,-144
    800079f4:	fffff097          	auipc	ra,0xfffff
    800079f8:	510080e7          	jalr	1296(ra) # 80006f04 <create>
     argint(2, &minor) < 0 ||
    800079fc:	00050e63          	beqz	a0,80007a18 <sys_mknod+0x8c>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80007a00:	ffffd097          	auipc	ra,0xffffd
    80007a04:	434080e7          	jalr	1076(ra) # 80004e34 <iunlockput>
  end_op();
    80007a08:	ffffe097          	auipc	ra,0xffffe
    80007a0c:	f8c080e7          	jalr	-116(ra) # 80005994 <end_op>
  return 0;
    80007a10:	00000513          	li	a0,0
    80007a14:	0100006f          	j	80007a24 <sys_mknod+0x98>
    end_op();
    80007a18:	ffffe097          	auipc	ra,0xffffe
    80007a1c:	f7c080e7          	jalr	-132(ra) # 80005994 <end_op>
    return -1;
    80007a20:	fff00513          	li	a0,-1
}
    80007a24:	09813083          	ld	ra,152(sp)
    80007a28:	09013403          	ld	s0,144(sp)
    80007a2c:	0a010113          	addi	sp,sp,160
    80007a30:	00008067          	ret

0000000080007a34 <sys_chdir>:

uint64
sys_chdir(void)
{
    80007a34:	f6010113          	addi	sp,sp,-160
    80007a38:	08113c23          	sd	ra,152(sp)
    80007a3c:	08813823          	sd	s0,144(sp)
    80007a40:	08913423          	sd	s1,136(sp)
    80007a44:	09213023          	sd	s2,128(sp)
    80007a48:	0a010413          	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80007a4c:	ffffb097          	auipc	ra,0xffffb
    80007a50:	9a0080e7          	jalr	-1632(ra) # 800023ec <myproc>
    80007a54:	00050913          	mv	s2,a0
  
  begin_op();
    80007a58:	ffffe097          	auipc	ra,0xffffe
    80007a5c:	e88080e7          	jalr	-376(ra) # 800058e0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80007a60:	08000613          	li	a2,128
    80007a64:	f6040593          	addi	a1,s0,-160
    80007a68:	00000513          	li	a0,0
    80007a6c:	ffffc097          	auipc	ra,0xffffc
    80007a70:	13c080e7          	jalr	316(ra) # 80003ba8 <argstr>
    80007a74:	06054663          	bltz	a0,80007ae0 <sys_chdir+0xac>
    80007a78:	f6040513          	addi	a0,s0,-160
    80007a7c:	ffffe097          	auipc	ra,0xffffe
    80007a80:	b74080e7          	jalr	-1164(ra) # 800055f0 <namei>
    80007a84:	00050493          	mv	s1,a0
    80007a88:	04050c63          	beqz	a0,80007ae0 <sys_chdir+0xac>
    end_op();
    return -1;
  }
  ilock(ip);
    80007a8c:	ffffd097          	auipc	ra,0xffffd
    80007a90:	06c080e7          	jalr	108(ra) # 80004af8 <ilock>
  if(ip->type != T_DIR){
    80007a94:	04449703          	lh	a4,68(s1)
    80007a98:	00100793          	li	a5,1
    80007a9c:	04f71a63          	bne	a4,a5,80007af0 <sys_chdir+0xbc>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80007aa0:	00048513          	mv	a0,s1
    80007aa4:	ffffd097          	auipc	ra,0xffffd
    80007aa8:	158080e7          	jalr	344(ra) # 80004bfc <iunlock>
  iput(p->cwd);
    80007aac:	15093503          	ld	a0,336(s2)
    80007ab0:	ffffd097          	auipc	ra,0xffffd
    80007ab4:	2a8080e7          	jalr	680(ra) # 80004d58 <iput>
  end_op();
    80007ab8:	ffffe097          	auipc	ra,0xffffe
    80007abc:	edc080e7          	jalr	-292(ra) # 80005994 <end_op>
  p->cwd = ip;
    80007ac0:	14993823          	sd	s1,336(s2)
  return 0;
    80007ac4:	00000513          	li	a0,0
}
    80007ac8:	09813083          	ld	ra,152(sp)
    80007acc:	09013403          	ld	s0,144(sp)
    80007ad0:	08813483          	ld	s1,136(sp)
    80007ad4:	08013903          	ld	s2,128(sp)
    80007ad8:	0a010113          	addi	sp,sp,160
    80007adc:	00008067          	ret
    end_op();
    80007ae0:	ffffe097          	auipc	ra,0xffffe
    80007ae4:	eb4080e7          	jalr	-332(ra) # 80005994 <end_op>
    return -1;
    80007ae8:	fff00513          	li	a0,-1
    80007aec:	fddff06f          	j	80007ac8 <sys_chdir+0x94>
    iunlockput(ip);
    80007af0:	00048513          	mv	a0,s1
    80007af4:	ffffd097          	auipc	ra,0xffffd
    80007af8:	340080e7          	jalr	832(ra) # 80004e34 <iunlockput>
    end_op();
    80007afc:	ffffe097          	auipc	ra,0xffffe
    80007b00:	e98080e7          	jalr	-360(ra) # 80005994 <end_op>
    return -1;
    80007b04:	fff00513          	li	a0,-1
    80007b08:	fc1ff06f          	j	80007ac8 <sys_chdir+0x94>

0000000080007b0c <sys_exec>:

uint64
sys_exec(void)
{
    80007b0c:	e3010113          	addi	sp,sp,-464
    80007b10:	1c113423          	sd	ra,456(sp)
    80007b14:	1c813023          	sd	s0,448(sp)
    80007b18:	1a913c23          	sd	s1,440(sp)
    80007b1c:	1b213823          	sd	s2,432(sp)
    80007b20:	1b313423          	sd	s3,424(sp)
    80007b24:	1b413023          	sd	s4,416(sp)
    80007b28:	19513c23          	sd	s5,408(sp)
    80007b2c:	1d010413          	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80007b30:	08000613          	li	a2,128
    80007b34:	f4040593          	addi	a1,s0,-192
    80007b38:	00000513          	li	a0,0
    80007b3c:	ffffc097          	auipc	ra,0xffffc
    80007b40:	06c080e7          	jalr	108(ra) # 80003ba8 <argstr>
    return -1;
    80007b44:	fff00913          	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80007b48:	10054263          	bltz	a0,80007c4c <sys_exec+0x140>
    80007b4c:	e3840593          	addi	a1,s0,-456
    80007b50:	00100513          	li	a0,1
    80007b54:	ffffc097          	auipc	ra,0xffffc
    80007b58:	018080e7          	jalr	24(ra) # 80003b6c <argaddr>
    80007b5c:	0e054863          	bltz	a0,80007c4c <sys_exec+0x140>
  }
  memset(argv, 0, sizeof(argv));
    80007b60:	10000613          	li	a2,256
    80007b64:	00000593          	li	a1,0
    80007b68:	e4040513          	addi	a0,s0,-448
    80007b6c:	ffff9097          	auipc	ra,0xffff9
    80007b70:	554080e7          	jalr	1364(ra) # 800010c0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80007b74:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80007b78:	00048993          	mv	s3,s1
    80007b7c:	00000913          	li	s2,0
    if(i >= NELEM(argv)){
    80007b80:	02000a13          	li	s4,32
    80007b84:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80007b88:	00391793          	slli	a5,s2,0x3
    80007b8c:	e3040593          	addi	a1,s0,-464
    80007b90:	e3843503          	ld	a0,-456(s0)
    80007b94:	00a78533          	add	a0,a5,a0
    80007b98:	ffffc097          	auipc	ra,0xffffc
    80007b9c:	ea4080e7          	jalr	-348(ra) # 80003a3c <fetchaddr>
    80007ba0:	04054063          	bltz	a0,80007be0 <sys_exec+0xd4>
      goto bad;
    }
    if(uarg == 0){
    80007ba4:	e3043783          	ld	a5,-464(s0)
    80007ba8:	04078e63          	beqz	a5,80007c04 <sys_exec+0xf8>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80007bac:	ffff9097          	auipc	ra,0xffff9
    80007bb0:	274080e7          	jalr	628(ra) # 80000e20 <kalloc>
    80007bb4:	00050593          	mv	a1,a0
    80007bb8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80007bbc:	02050263          	beqz	a0,80007be0 <sys_exec+0xd4>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80007bc0:	00001637          	lui	a2,0x1
    80007bc4:	e3043503          	ld	a0,-464(s0)
    80007bc8:	ffffc097          	auipc	ra,0xffffc
    80007bcc:	ef4080e7          	jalr	-268(ra) # 80003abc <fetchstr>
    80007bd0:	00054863          	bltz	a0,80007be0 <sys_exec+0xd4>
    if(i >= NELEM(argv)){
    80007bd4:	00190913          	addi	s2,s2,1
    80007bd8:	00898993          	addi	s3,s3,8
    80007bdc:	fb4914e3          	bne	s2,s4,80007b84 <sys_exec+0x78>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007be0:	10048913          	addi	s2,s1,256
    80007be4:	0004b503          	ld	a0,0(s1)
    80007be8:	06050063          	beqz	a0,80007c48 <sys_exec+0x13c>
    kfree(argv[i]);
    80007bec:	ffff9097          	auipc	ra,0xffff9
    80007bf0:	108080e7          	jalr	264(ra) # 80000cf4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007bf4:	00848493          	addi	s1,s1,8
    80007bf8:	ff2496e3          	bne	s1,s2,80007be4 <sys_exec+0xd8>
  return -1;
    80007bfc:	fff00913          	li	s2,-1
    80007c00:	04c0006f          	j	80007c4c <sys_exec+0x140>
      argv[i] = 0;
    80007c04:	003a9a93          	slli	s5,s5,0x3
    80007c08:	fc040793          	addi	a5,s0,-64
    80007c0c:	01578ab3          	add	s5,a5,s5
    80007c10:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffdb208>
  int ret = exec(path, argv);
    80007c14:	e4040593          	addi	a1,s0,-448
    80007c18:	f4040513          	addi	a0,s0,-192
    80007c1c:	fffff097          	auipc	ra,0xfffff
    80007c20:	d2c080e7          	jalr	-724(ra) # 80006948 <exec>
    80007c24:	00050913          	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007c28:	10048993          	addi	s3,s1,256
    80007c2c:	0004b503          	ld	a0,0(s1)
    80007c30:	00050e63          	beqz	a0,80007c4c <sys_exec+0x140>
    kfree(argv[i]);
    80007c34:	ffff9097          	auipc	ra,0xffff9
    80007c38:	0c0080e7          	jalr	192(ra) # 80000cf4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007c3c:	00848493          	addi	s1,s1,8
    80007c40:	ff3496e3          	bne	s1,s3,80007c2c <sys_exec+0x120>
    80007c44:	0080006f          	j	80007c4c <sys_exec+0x140>
  return -1;
    80007c48:	fff00913          	li	s2,-1
}
    80007c4c:	00090513          	mv	a0,s2
    80007c50:	1c813083          	ld	ra,456(sp)
    80007c54:	1c013403          	ld	s0,448(sp)
    80007c58:	1b813483          	ld	s1,440(sp)
    80007c5c:	1b013903          	ld	s2,432(sp)
    80007c60:	1a813983          	ld	s3,424(sp)
    80007c64:	1a013a03          	ld	s4,416(sp)
    80007c68:	19813a83          	ld	s5,408(sp)
    80007c6c:	1d010113          	addi	sp,sp,464
    80007c70:	00008067          	ret

0000000080007c74 <sys_pipe>:

uint64
sys_pipe(void)
{
    80007c74:	fc010113          	addi	sp,sp,-64
    80007c78:	02113c23          	sd	ra,56(sp)
    80007c7c:	02813823          	sd	s0,48(sp)
    80007c80:	02913423          	sd	s1,40(sp)
    80007c84:	04010413          	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80007c88:	ffffa097          	auipc	ra,0xffffa
    80007c8c:	764080e7          	jalr	1892(ra) # 800023ec <myproc>
    80007c90:	00050493          	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80007c94:	fd840593          	addi	a1,s0,-40
    80007c98:	00000513          	li	a0,0
    80007c9c:	ffffc097          	auipc	ra,0xffffc
    80007ca0:	ed0080e7          	jalr	-304(ra) # 80003b6c <argaddr>
    return -1;
    80007ca4:	fff00793          	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80007ca8:	10054263          	bltz	a0,80007dac <sys_pipe+0x138>
  if(pipealloc(&rf, &wf) < 0)
    80007cac:	fc840593          	addi	a1,s0,-56
    80007cb0:	fd040513          	addi	a0,s0,-48
    80007cb4:	ffffe097          	auipc	ra,0xffffe
    80007cb8:	748080e7          	jalr	1864(ra) # 800063fc <pipealloc>
    return -1;
    80007cbc:	fff00793          	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80007cc0:	0e054663          	bltz	a0,80007dac <sys_pipe+0x138>
  fd0 = -1;
    80007cc4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80007cc8:	fd043503          	ld	a0,-48(s0)
    80007ccc:	fffff097          	auipc	ra,0xfffff
    80007cd0:	1c8080e7          	jalr	456(ra) # 80006e94 <fdalloc>
    80007cd4:	fca42223          	sw	a0,-60(s0)
    80007cd8:	0a054c63          	bltz	a0,80007d90 <sys_pipe+0x11c>
    80007cdc:	fc843503          	ld	a0,-56(s0)
    80007ce0:	fffff097          	auipc	ra,0xfffff
    80007ce4:	1b4080e7          	jalr	436(ra) # 80006e94 <fdalloc>
    80007ce8:	fca42023          	sw	a0,-64(s0)
    80007cec:	08054663          	bltz	a0,80007d78 <sys_pipe+0x104>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80007cf0:	00400693          	li	a3,4
    80007cf4:	fc440613          	addi	a2,s0,-60
    80007cf8:	fd843583          	ld	a1,-40(s0)
    80007cfc:	0504b503          	ld	a0,80(s1)
    80007d00:	ffffa097          	auipc	ra,0xffffa
    80007d04:	1f4080e7          	jalr	500(ra) # 80001ef4 <copyout>
    80007d08:	02054463          	bltz	a0,80007d30 <sys_pipe+0xbc>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80007d0c:	00400693          	li	a3,4
    80007d10:	fc040613          	addi	a2,s0,-64
    80007d14:	fd843583          	ld	a1,-40(s0)
    80007d18:	00458593          	addi	a1,a1,4
    80007d1c:	0504b503          	ld	a0,80(s1)
    80007d20:	ffffa097          	auipc	ra,0xffffa
    80007d24:	1d4080e7          	jalr	468(ra) # 80001ef4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80007d28:	00000793          	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80007d2c:	08055063          	bgez	a0,80007dac <sys_pipe+0x138>
    p->ofile[fd0] = 0;
    80007d30:	fc442783          	lw	a5,-60(s0)
    80007d34:	01a78793          	addi	a5,a5,26
    80007d38:	00379793          	slli	a5,a5,0x3
    80007d3c:	00f487b3          	add	a5,s1,a5
    80007d40:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80007d44:	fc042503          	lw	a0,-64(s0)
    80007d48:	01a50513          	addi	a0,a0,26
    80007d4c:	00351513          	slli	a0,a0,0x3
    80007d50:	00a48533          	add	a0,s1,a0
    80007d54:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80007d58:	fd043503          	ld	a0,-48(s0)
    80007d5c:	ffffe097          	auipc	ra,0xffffe
    80007d60:	210080e7          	jalr	528(ra) # 80005f6c <fileclose>
    fileclose(wf);
    80007d64:	fc843503          	ld	a0,-56(s0)
    80007d68:	ffffe097          	auipc	ra,0xffffe
    80007d6c:	204080e7          	jalr	516(ra) # 80005f6c <fileclose>
    return -1;
    80007d70:	fff00793          	li	a5,-1
    80007d74:	0380006f          	j	80007dac <sys_pipe+0x138>
    if(fd0 >= 0)
    80007d78:	fc442783          	lw	a5,-60(s0)
    80007d7c:	0007ca63          	bltz	a5,80007d90 <sys_pipe+0x11c>
      p->ofile[fd0] = 0;
    80007d80:	01a78513          	addi	a0,a5,26
    80007d84:	00351513          	slli	a0,a0,0x3
    80007d88:	00a48533          	add	a0,s1,a0
    80007d8c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80007d90:	fd043503          	ld	a0,-48(s0)
    80007d94:	ffffe097          	auipc	ra,0xffffe
    80007d98:	1d8080e7          	jalr	472(ra) # 80005f6c <fileclose>
    fileclose(wf);
    80007d9c:	fc843503          	ld	a0,-56(s0)
    80007da0:	ffffe097          	auipc	ra,0xffffe
    80007da4:	1cc080e7          	jalr	460(ra) # 80005f6c <fileclose>
    return -1;
    80007da8:	fff00793          	li	a5,-1
}
    80007dac:	00078513          	mv	a0,a5
    80007db0:	03813083          	ld	ra,56(sp)
    80007db4:	03013403          	ld	s0,48(sp)
    80007db8:	02813483          	ld	s1,40(sp)
    80007dbc:	04010113          	addi	sp,sp,64
    80007dc0:	00008067          	ret
	...

0000000080007dd0 <kernelvec>:
    80007dd0:	f0010113          	addi	sp,sp,-256
    80007dd4:	00113023          	sd	ra,0(sp)
    80007dd8:	00213423          	sd	sp,8(sp)
    80007ddc:	00313823          	sd	gp,16(sp)
    80007de0:	00413c23          	sd	tp,24(sp)
    80007de4:	02513023          	sd	t0,32(sp)
    80007de8:	02613423          	sd	t1,40(sp)
    80007dec:	02713823          	sd	t2,48(sp)
    80007df0:	02813c23          	sd	s0,56(sp)
    80007df4:	04913023          	sd	s1,64(sp)
    80007df8:	04a13423          	sd	a0,72(sp)
    80007dfc:	04b13823          	sd	a1,80(sp)
    80007e00:	04c13c23          	sd	a2,88(sp)
    80007e04:	06d13023          	sd	a3,96(sp)
    80007e08:	06e13423          	sd	a4,104(sp)
    80007e0c:	06f13823          	sd	a5,112(sp)
    80007e10:	07013c23          	sd	a6,120(sp)
    80007e14:	09113023          	sd	a7,128(sp)
    80007e18:	09213423          	sd	s2,136(sp)
    80007e1c:	09313823          	sd	s3,144(sp)
    80007e20:	09413c23          	sd	s4,152(sp)
    80007e24:	0b513023          	sd	s5,160(sp)
    80007e28:	0b613423          	sd	s6,168(sp)
    80007e2c:	0b713823          	sd	s7,176(sp)
    80007e30:	0b813c23          	sd	s8,184(sp)
    80007e34:	0d913023          	sd	s9,192(sp)
    80007e38:	0da13423          	sd	s10,200(sp)
    80007e3c:	0db13823          	sd	s11,208(sp)
    80007e40:	0dc13c23          	sd	t3,216(sp)
    80007e44:	0fd13023          	sd	t4,224(sp)
    80007e48:	0fe13423          	sd	t5,232(sp)
    80007e4c:	0ff13823          	sd	t6,240(sp)
    80007e50:	a45fb0ef          	jal	ra,80003894 <kerneltrap>
    80007e54:	00013083          	ld	ra,0(sp)
    80007e58:	00813103          	ld	sp,8(sp)
    80007e5c:	01013183          	ld	gp,16(sp)
    80007e60:	02013283          	ld	t0,32(sp)
    80007e64:	02813303          	ld	t1,40(sp)
    80007e68:	03013383          	ld	t2,48(sp)
    80007e6c:	03813403          	ld	s0,56(sp)
    80007e70:	04013483          	ld	s1,64(sp)
    80007e74:	04813503          	ld	a0,72(sp)
    80007e78:	05013583          	ld	a1,80(sp)
    80007e7c:	05813603          	ld	a2,88(sp)
    80007e80:	06013683          	ld	a3,96(sp)
    80007e84:	06813703          	ld	a4,104(sp)
    80007e88:	07013783          	ld	a5,112(sp)
    80007e8c:	07813803          	ld	a6,120(sp)
    80007e90:	08013883          	ld	a7,128(sp)
    80007e94:	08813903          	ld	s2,136(sp)
    80007e98:	09013983          	ld	s3,144(sp)
    80007e9c:	09813a03          	ld	s4,152(sp)
    80007ea0:	0a013a83          	ld	s5,160(sp)
    80007ea4:	0a813b03          	ld	s6,168(sp)
    80007ea8:	0b013b83          	ld	s7,176(sp)
    80007eac:	0b813c03          	ld	s8,184(sp)
    80007eb0:	0c013c83          	ld	s9,192(sp)
    80007eb4:	0c813d03          	ld	s10,200(sp)
    80007eb8:	0d013d83          	ld	s11,208(sp)
    80007ebc:	0d813e03          	ld	t3,216(sp)
    80007ec0:	0e013e83          	ld	t4,224(sp)
    80007ec4:	0e813f03          	ld	t5,232(sp)
    80007ec8:	0f013f83          	ld	t6,240(sp)
    80007ecc:	10010113          	addi	sp,sp,256
    80007ed0:	10200073          	sret
    80007ed4:	00000013          	nop
    80007ed8:	00000013          	nop
    80007edc:	00000013          	nop

0000000080007ee0 <timervec>:
    80007ee0:	34051573          	csrrw	a0,mscratch,a0
    80007ee4:	00b53023          	sd	a1,0(a0)
    80007ee8:	00c53423          	sd	a2,8(a0)
    80007eec:	00d53823          	sd	a3,16(a0)
    80007ef0:	01853583          	ld	a1,24(a0)
    80007ef4:	02053603          	ld	a2,32(a0)
    80007ef8:	0005b683          	ld	a3,0(a1)
    80007efc:	00c686b3          	add	a3,a3,a2
    80007f00:	00d5b023          	sd	a3,0(a1)
    80007f04:	00200593          	li	a1,2
    80007f08:	14459073          	csrw	sip,a1
    80007f0c:	01053683          	ld	a3,16(a0)
    80007f10:	00853603          	ld	a2,8(a0)
    80007f14:	00053583          	ld	a1,0(a0)
    80007f18:	34051573          	csrrw	a0,mscratch,a0
    80007f1c:	30200073          	mret

0000000080007f20 <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80007f20:	ff010113          	addi	sp,sp,-16
    80007f24:	00813423          	sd	s0,8(sp)
    80007f28:	01010413          	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80007f2c:	0c0007b7          	lui	a5,0xc000
    80007f30:	00100713          	li	a4,1
    80007f34:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
}
    80007f38:	00813403          	ld	s0,8(sp)
    80007f3c:	01010113          	addi	sp,sp,16
    80007f40:	00008067          	ret

0000000080007f44 <plicinithart>:

void
plicinithart(void)
{
    80007f44:	ff010113          	addi	sp,sp,-16
    80007f48:	00113423          	sd	ra,8(sp)
    80007f4c:	00813023          	sd	s0,0(sp)
    80007f50:	01010413          	addi	s0,sp,16
  int hart = cpuid();
    80007f54:	ffffa097          	auipc	ra,0xffffa
    80007f58:	448080e7          	jalr	1096(ra) # 8000239c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ);
    80007f5c:	0085171b          	slliw	a4,a0,0x8
    80007f60:	0c0027b7          	lui	a5,0xc002
    80007f64:	00e787b3          	add	a5,a5,a4
    80007f68:	40000713          	li	a4,1024
    80007f6c:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80007f70:	00d5151b          	slliw	a0,a0,0xd
    80007f74:	0c2017b7          	lui	a5,0xc201
    80007f78:	00a78533          	add	a0,a5,a0
    80007f7c:	00052023          	sw	zero,0(a0)
}
    80007f80:	00813083          	ld	ra,8(sp)
    80007f84:	00013403          	ld	s0,0(sp)
    80007f88:	01010113          	addi	sp,sp,16
    80007f8c:	00008067          	ret

0000000080007f90 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80007f90:	ff010113          	addi	sp,sp,-16
    80007f94:	00113423          	sd	ra,8(sp)
    80007f98:	00813023          	sd	s0,0(sp)
    80007f9c:	01010413          	addi	s0,sp,16
  int hart = cpuid();
    80007fa0:	ffffa097          	auipc	ra,0xffffa
    80007fa4:	3fc080e7          	jalr	1020(ra) # 8000239c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80007fa8:	00d5179b          	slliw	a5,a0,0xd
    80007fac:	0c201537          	lui	a0,0xc201
    80007fb0:	00f50533          	add	a0,a0,a5
  return irq;
}
    80007fb4:	00452503          	lw	a0,4(a0) # c201004 <_entry-0x73dfeffc>
    80007fb8:	00813083          	ld	ra,8(sp)
    80007fbc:	00013403          	ld	s0,0(sp)
    80007fc0:	01010113          	addi	sp,sp,16
    80007fc4:	00008067          	ret

0000000080007fc8 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80007fc8:	fe010113          	addi	sp,sp,-32
    80007fcc:	00113c23          	sd	ra,24(sp)
    80007fd0:	00813823          	sd	s0,16(sp)
    80007fd4:	00913423          	sd	s1,8(sp)
    80007fd8:	02010413          	addi	s0,sp,32
    80007fdc:	00050493          	mv	s1,a0
  int hart = cpuid();
    80007fe0:	ffffa097          	auipc	ra,0xffffa
    80007fe4:	3bc080e7          	jalr	956(ra) # 8000239c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80007fe8:	00d5151b          	slliw	a0,a0,0xd
    80007fec:	0c2017b7          	lui	a5,0xc201
    80007ff0:	00a787b3          	add	a5,a5,a0
    80007ff4:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
}
    80007ff8:	01813083          	ld	ra,24(sp)
    80007ffc:	01013403          	ld	s0,16(sp)
    80008000:	00813483          	ld	s1,8(sp)
    80008004:	02010113          	addi	sp,sp,32
    80008008:	00008067          	ret
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
