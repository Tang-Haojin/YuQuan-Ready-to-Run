
rtthread.elf:     file format elf64-littleriscv


Disassembly of section .start:

0000000080000000 <_start>:
    80000000:	f14022f3          	csrr	t0,mhartid
    80000004:	00a29293          	slli	t0,t0,0xa
    80000008:	f1402573          	csrr	a0,mhartid
    8000000c:	02051e63          	bnez	a0,80000048 <park>
    80000010:	30405073          	csrwi	mie,0
    80000014:	34405073          	csrwi	mip,0
    80000018:	00009297          	auipc	t0,0x9
    8000001c:	c8c28293          	addi	t0,t0,-884 # 80008ca4 <trap_entry>
    80000020:	30529073          	csrw	mtvec,t0
    80000024:	000062b7          	lui	t0,0x6
    80000028:	3002b073          	csrc	mstatus,t0
    8000002c:	00016197          	auipc	gp,0x16
    80000030:	f7418193          	addi	gp,gp,-140 # 80015fa0 <__global_pointer$>
    80000034:	82018113          	addi	sp,gp,-2016 # 800157c0 <__stack_start__>
    80000038:	000042b7          	lui	t0,0x4
    8000003c:	00510133          	add	sp,sp,t0
    80000040:	34011073          	csrw	mscratch,sp
    80000044:	0590306f          	j	8000389c <primary_cpu_entry>

0000000080000048 <park>:
    80000048:	10500073          	wfi
    8000004c:	ffdff06f          	j	80000048 <park>

Disassembly of section .text:

0000000080000050 <rt_hw_interrupt_disable>:
    80000050:	30047573          	csrrci	a0,mstatus,8
    80000054:	00008067          	ret

0000000080000058 <rt_hw_interrupt_enable>:
    80000058:	30051073          	csrw	mstatus,a0
    8000005c:	00008067          	ret

0000000080000060 <rt_hw_context_switch_to>:
    80000060:	00053103          	ld	sp,0(a0)
    80000064:	01013503          	ld	a0,16(sp)
    80000068:	30051073          	csrw	mstatus,a0
    8000006c:	0a00006f          	j	8000010c <rt_hw_context_switch_exit>

0000000080000070 <rt_hw_context_switch>:
    80000070:	f0010113          	addi	sp,sp,-256
    80000074:	00253023          	sd	sp,0(a0)
    80000078:	00113023          	sd	ra,0(sp)
    8000007c:	00113423          	sd	ra,8(sp)
    80000080:	30002573          	csrr	a0,mstatus
    80000084:	00857513          	andi	a0,a0,8
    80000088:	00050463          	beqz	a0,80000090 <save_mpie>
    8000008c:	08000513          	li	a0,128

0000000080000090 <save_mpie>:
    80000090:	00a13823          	sd	a0,16(sp)
    80000094:	02413023          	sd	tp,32(sp)
    80000098:	02513423          	sd	t0,40(sp)
    8000009c:	02613823          	sd	t1,48(sp)
    800000a0:	02713c23          	sd	t2,56(sp)
    800000a4:	04813023          	sd	s0,64(sp)
    800000a8:	04913423          	sd	s1,72(sp)
    800000ac:	04a13823          	sd	a0,80(sp)
    800000b0:	04b13c23          	sd	a1,88(sp)
    800000b4:	06c13023          	sd	a2,96(sp)
    800000b8:	06d13423          	sd	a3,104(sp)
    800000bc:	06e13823          	sd	a4,112(sp)
    800000c0:	06f13c23          	sd	a5,120(sp)
    800000c4:	09013023          	sd	a6,128(sp)
    800000c8:	09113423          	sd	a7,136(sp)
    800000cc:	09213823          	sd	s2,144(sp)
    800000d0:	09313c23          	sd	s3,152(sp)
    800000d4:	0b413023          	sd	s4,160(sp)
    800000d8:	0b513423          	sd	s5,168(sp)
    800000dc:	0b613823          	sd	s6,176(sp)
    800000e0:	0b713c23          	sd	s7,184(sp)
    800000e4:	0d813023          	sd	s8,192(sp)
    800000e8:	0d913423          	sd	s9,200(sp)
    800000ec:	0da13823          	sd	s10,208(sp)
    800000f0:	0db13c23          	sd	s11,216(sp)
    800000f4:	0fc13023          	sd	t3,224(sp)
    800000f8:	0fd13423          	sd	t4,232(sp)
    800000fc:	0fe13823          	sd	t5,240(sp)
    80000100:	0ff13c23          	sd	t6,248(sp)
    80000104:	0005b103          	ld	sp,0(a1)
    80000108:	0040006f          	j	8000010c <rt_hw_context_switch_exit>

000000008000010c <rt_hw_context_switch_exit>:
    8000010c:	00013503          	ld	a0,0(sp)
    80000110:	34151073          	csrw	mepc,a0
    80000114:	00813083          	ld	ra,8(sp)
    80000118:	000082b7          	lui	t0,0x8
    8000011c:	8002829b          	addiw	t0,t0,-2048
    80000120:	30029073          	csrw	mstatus,t0
    80000124:	01013503          	ld	a0,16(sp)
    80000128:	30052073          	csrs	mstatus,a0
    8000012c:	02013203          	ld	tp,32(sp)
    80000130:	02813283          	ld	t0,40(sp)
    80000134:	03013303          	ld	t1,48(sp)
    80000138:	03813383          	ld	t2,56(sp)
    8000013c:	04013403          	ld	s0,64(sp)
    80000140:	04813483          	ld	s1,72(sp)
    80000144:	05013503          	ld	a0,80(sp)
    80000148:	05813583          	ld	a1,88(sp)
    8000014c:	06013603          	ld	a2,96(sp)
    80000150:	06813683          	ld	a3,104(sp)
    80000154:	07013703          	ld	a4,112(sp)
    80000158:	07813783          	ld	a5,120(sp)
    8000015c:	08013803          	ld	a6,128(sp)
    80000160:	08813883          	ld	a7,136(sp)
    80000164:	09013903          	ld	s2,144(sp)
    80000168:	09813983          	ld	s3,152(sp)
    8000016c:	0a013a03          	ld	s4,160(sp)
    80000170:	0a813a83          	ld	s5,168(sp)
    80000174:	0b013b03          	ld	s6,176(sp)
    80000178:	0b813b83          	ld	s7,184(sp)
    8000017c:	0c013c03          	ld	s8,192(sp)
    80000180:	0c813c83          	ld	s9,200(sp)
    80000184:	0d013d03          	ld	s10,208(sp)
    80000188:	0d813d83          	ld	s11,216(sp)
    8000018c:	0e013e03          	ld	t3,224(sp)
    80000190:	0e813e83          	ld	t4,232(sp)
    80000194:	0f013f03          	ld	t5,240(sp)
    80000198:	0f813f83          	ld	t6,248(sp)
    8000019c:	10010113          	addi	sp,sp,256
    800001a0:	30200073          	mret

00000000800001a4 <main>:
    800001a4:	ff010113          	addi	sp,sp,-16
    800001a8:	00010517          	auipc	a0,0x10
    800001ac:	25850513          	addi	a0,a0,600 # 80010400 <rt_pin_get+0x9c>
    800001b0:	00113423          	sd	ra,8(sp)
    800001b4:	1a4020ef          	jal	ra,80002358 <call_microbench>
    800001b8:	0000006b          	0x6b
    800001bc:	00813083          	ld	ra,8(sp)
    800001c0:	00000513          	li	a0,0
    800001c4:	01010113          	addi	sp,sp,16
    800001c8:	00008067          	ret

00000000800001cc <_ZN14Updatable_heapI8N_puzzleILi4EEE4swapEii.isra.0>:
    800001cc:	00359693          	slli	a3,a1,0x3
    800001d0:	00361793          	slli	a5,a2,0x3
    800001d4:	00f507b3          	add	a5,a0,a5
    800001d8:	00d50533          	add	a0,a0,a3
    800001dc:	00053683          	ld	a3,0(a0)
    800001e0:	0007b703          	ld	a4,0(a5)
    800001e4:	00d7b023          	sd	a3,0(a5)
    800001e8:	00e53023          	sd	a4,0(a0)
    800001ec:	0007b783          	ld	a5,0(a5)
    800001f0:	02b72023          	sw	a1,32(a4)
    800001f4:	02c7a023          	sw	a2,32(a5)
    800001f8:	00008067          	ret

00000000800001fc <_ZN8N_puzzleILi4EEaSERKS0_.isra.0>:
    800001fc:	0005c783          	lbu	a5,0(a1)
    80000200:	00450513          	addi	a0,a0,4
    80000204:	fef50e23          	sb	a5,-4(a0)
    80000208:	0015c783          	lbu	a5,1(a1)
    8000020c:	fef50ea3          	sb	a5,-3(a0)
    80000210:	0025c783          	lbu	a5,2(a1)
    80000214:	fef50f23          	sb	a5,-2(a0)
    80000218:	00358783          	lb	a5,3(a1)
    8000021c:	fef50fa3          	sb	a5,-1(a0)
    80000220:	0145a783          	lw	a5,20(a1)
    80000224:	00f52823          	sw	a5,16(a0)
    80000228:	00458793          	addi	a5,a1,4
    8000022c:	01458593          	addi	a1,a1,20
    80000230:	00078703          	lb	a4,0(a5)
    80000234:	00478793          	addi	a5,a5,4
    80000238:	00450513          	addi	a0,a0,4
    8000023c:	fee50e23          	sb	a4,-4(a0)
    80000240:	ffd78703          	lb	a4,-3(a5)
    80000244:	fee50ea3          	sb	a4,-3(a0)
    80000248:	ffe78703          	lb	a4,-2(a5)
    8000024c:	fee50f23          	sb	a4,-2(a0)
    80000250:	fff78703          	lb	a4,-1(a5)
    80000254:	fee50fa3          	sb	a4,-1(a0)
    80000258:	fcb79ce3          	bne	a5,a1,80000230 <_ZN8N_puzzleILi4EEaSERKS0_.isra.0+0x34>
    8000025c:	00008067          	ret

0000000080000260 <bench_15pz_prepare>:
    80000260:	00008067          	ret

0000000080000264 <bench_15pz_validate>:
    80000264:	0001d797          	auipc	a5,0x1d
    80000268:	5bc7b783          	ld	a5,1468(a5) # 8001d820 <setting>
    8000026c:	0187a503          	lw	a0,24(a5)
    80000270:	0001d797          	auipc	a5,0x1d
    80000274:	5507a783          	lw	a5,1360(a5) # 8001d7c0 <_ZL3ans>
    80000278:	40f50533          	sub	a0,a0,a5
    8000027c:	00153513          	seqz	a0,a0
    80000280:	00008067          	ret

0000000080000284 <_ZN8N_puzzleILi4EEC1ERKS0_>:
    80000284:	0005a783          	lw	a5,0(a1)
    80000288:	00450513          	addi	a0,a0,4
    8000028c:	fef52e23          	sw	a5,-4(a0)
    80000290:	0145a783          	lw	a5,20(a1)
    80000294:	00f52823          	sw	a5,16(a0)
    80000298:	00458793          	addi	a5,a1,4
    8000029c:	01458593          	addi	a1,a1,20
    800002a0:	00078703          	lb	a4,0(a5)
    800002a4:	00478793          	addi	a5,a5,4
    800002a8:	00450513          	addi	a0,a0,4
    800002ac:	fee50e23          	sb	a4,-4(a0)
    800002b0:	ffd78703          	lb	a4,-3(a5)
    800002b4:	fee50ea3          	sb	a4,-3(a0)
    800002b8:	ffe78703          	lb	a4,-2(a5)
    800002bc:	fee50f23          	sb	a4,-2(a0)
    800002c0:	fff78703          	lb	a4,-1(a5)
    800002c4:	fee50fa3          	sb	a4,-1(a0)
    800002c8:	fcb79ce3          	bne	a5,a1,800002a0 <_ZN8N_puzzleILi4EEC1ERKS0_+0x1c>
    800002cc:	00008067          	ret

00000000800002d0 <_ZNK8N_puzzleILi4EEeqERKS0_>:
    800002d0:	00050793          	mv	a5,a0
    800002d4:	00054503          	lbu	a0,0(a0)
    800002d8:	04050c63          	beqz	a0,80000330 <_ZNK8N_puzzleILi4EEeqERKS0_+0x60>
    800002dc:	0005c503          	lbu	a0,0(a1)
    800002e0:	04050863          	beqz	a0,80000330 <_ZNK8N_puzzleILi4EEeqERKS0_+0x60>
    800002e4:	0145a683          	lw	a3,20(a1)
    800002e8:	0147a703          	lw	a4,20(a5)
    800002ec:	04e69063          	bne	a3,a4,8000032c <_ZNK8N_puzzleILi4EEeqERKS0_+0x5c>
    800002f0:	00400713          	li	a4,4
    800002f4:	01400313          	li	t1,20
    800002f8:	00070693          	mv	a3,a4
    800002fc:	00400613          	li	a2,4
    80000300:	00d788b3          	add	a7,a5,a3
    80000304:	00d58833          	add	a6,a1,a3
    80000308:	0008c883          	lbu	a7,0(a7)
    8000030c:	00084803          	lbu	a6,0(a6)
    80000310:	01089e63          	bne	a7,a6,8000032c <_ZNK8N_puzzleILi4EEeqERKS0_+0x5c>
    80000314:	fff6061b          	addiw	a2,a2,-1
    80000318:	00168693          	addi	a3,a3,1
    8000031c:	fe0612e3          	bnez	a2,80000300 <_ZNK8N_puzzleILi4EEeqERKS0_+0x30>
    80000320:	00470713          	addi	a4,a4,4
    80000324:	fc671ae3          	bne	a4,t1,800002f8 <_ZNK8N_puzzleILi4EEeqERKS0_+0x28>
    80000328:	00008067          	ret
    8000032c:	00000513          	li	a0,0
    80000330:	00008067          	ret

0000000080000334 <_ZN8N_puzzleILi4EE14determine_hashEv>:
    80000334:	00052a23          	sw	zero,20(a0)
    80000338:	00050713          	mv	a4,a0
    8000033c:	01050593          	addi	a1,a0,16
    80000340:	00000793          	li	a5,0
    80000344:	7b500813          	li	a6,1973
    80000348:	00070613          	mv	a2,a4
    8000034c:	00400693          	li	a3,4
    80000350:	02f807bb          	mulw	a5,a6,a5
    80000354:	00460883          	lb	a7,4(a2)
    80000358:	fff6869b          	addiw	a3,a3,-1
    8000035c:	00160613          	addi	a2,a2,1
    80000360:	011787bb          	addw	a5,a5,a7
    80000364:	fe0696e3          	bnez	a3,80000350 <_ZN8N_puzzleILi4EE14determine_hashEv+0x1c>
    80000368:	00470713          	addi	a4,a4,4
    8000036c:	fcb71ee3          	bne	a4,a1,80000348 <_ZN8N_puzzleILi4EE14determine_hashEv+0x14>
    80000370:	00f52a23          	sw	a5,20(a0)
    80000374:	00008067          	ret

0000000080000378 <_ZN8N_puzzleILi4EEC1Ev>:
    80000378:	f6010113          	addi	sp,sp,-160
    8000037c:	08813823          	sd	s0,144(sp)
    80000380:	08113c23          	sd	ra,152(sp)
    80000384:	08913423          	sd	s1,136(sp)
    80000388:	09213023          	sd	s2,128(sp)
    8000038c:	07313c23          	sd	s3,120(sp)
    80000390:	07413823          	sd	s4,112(sp)
    80000394:	07513423          	sd	s5,104(sp)
    80000398:	07613023          	sd	s6,96(sp)
    8000039c:	05713c23          	sd	s7,88(sp)
    800003a0:	05813823          	sd	s8,80(sp)
    800003a4:	05913423          	sd	s9,72(sp)
    800003a8:	05a13023          	sd	s10,64(sp)
    800003ac:	00100793          	li	a5,1
    800003b0:	00f50023          	sb	a5,0(a0)
    800003b4:	00050413          	mv	s0,a0
    800003b8:	000501a3          	sb	zero,3(a0)
    800003bc:	00010713          	mv	a4,sp
    800003c0:	00000793          	li	a5,0
    800003c4:	01000693          	li	a3,16
    800003c8:	00f72023          	sw	a5,0(a4)
    800003cc:	0017879b          	addiw	a5,a5,1
    800003d0:	00470713          	addi	a4,a4,4
    800003d4:	fed79ae3          	bne	a5,a3,800003c8 <_ZN8N_puzzleILi4EEC1Ev+0x50>
    800003d8:	03c10a93          	addi	s5,sp,60
    800003dc:	00000913          	li	s2,0
    800003e0:	ffc00c13          	li	s8,-4
    800003e4:	00400b93          	li	s7,4
    800003e8:	00400c93          	li	s9,4
    800003ec:	032c0a3b          	mulw	s4,s8,s2
    800003f0:	00291993          	slli	s3,s2,0x2
    800003f4:	00090d1b          	sext.w	s10,s2
    800003f8:	013409b3          	add	s3,s0,s3
    800003fc:	000a8b13          	mv	s6,s5
    80000400:	00000493          	li	s1,0
    80000404:	010a0a1b          	addiw	s4,s4,16
    80000408:	2b4020ef          	jal	ra,800026bc <bench_rand>
    8000040c:	409a07bb          	subw	a5,s4,s1
    80000410:	02f5753b          	remuw	a0,a0,a5
    80000414:	00251513          	slli	a0,a0,0x2
    80000418:	04050793          	addi	a5,a0,64
    8000041c:	002787b3          	add	a5,a5,sp
    80000420:	fc07a783          	lw	a5,-64(a5)
    80000424:	00f98223          	sb	a5,4(s3)
    80000428:	06079a63          	bnez	a5,8000049c <_ZN8N_puzzleILi4EEC1Ev+0x124>
    8000042c:	012400a3          	sb	s2,1(s0)
    80000430:	00940123          	sb	s1,2(s0)
    80000434:	000b2783          	lw	a5,0(s6)
    80000438:	04050713          	addi	a4,a0,64
    8000043c:	00270533          	add	a0,a4,sp
    80000440:	fcf52023          	sw	a5,-64(a0)
    80000444:	0014849b          	addiw	s1,s1,1
    80000448:	00198993          	addi	s3,s3,1
    8000044c:	ffcb0b13          	addi	s6,s6,-4
    80000450:	fb949ce3          	bne	s1,s9,80000408 <_ZN8N_puzzleILi4EEC1Ev+0x90>
    80000454:	00190913          	addi	s2,s2,1
    80000458:	ff0a8a93          	addi	s5,s5,-16
    8000045c:	f89918e3          	bne	s2,s1,800003ec <_ZN8N_puzzleILi4EEC1Ev+0x74>
    80000460:	00040513          	mv	a0,s0
    80000464:	09013403          	ld	s0,144(sp)
    80000468:	09813083          	ld	ra,152(sp)
    8000046c:	08813483          	ld	s1,136(sp)
    80000470:	08013903          	ld	s2,128(sp)
    80000474:	07813983          	ld	s3,120(sp)
    80000478:	07013a03          	ld	s4,112(sp)
    8000047c:	06813a83          	ld	s5,104(sp)
    80000480:	06013b03          	ld	s6,96(sp)
    80000484:	05813b83          	ld	s7,88(sp)
    80000488:	05013c03          	ld	s8,80(sp)
    8000048c:	04813c83          	ld	s9,72(sp)
    80000490:	04013d03          	ld	s10,64(sp)
    80000494:	0a010113          	addi	sp,sp,160
    80000498:	e9dff06f          	j	80000334 <_ZN8N_puzzleILi4EE14determine_hashEv>
    8000049c:	fff7879b          	addiw	a5,a5,-1
    800004a0:	0377c73b          	divw	a4,a5,s7
    800004a4:	0377e7bb          	remw	a5,a5,s7
    800004a8:	41a7073b          	subw	a4,a4,s10
    800004ac:	41f7569b          	sraiw	a3,a4,0x1f
    800004b0:	00e6c733          	xor	a4,a3,a4
    800004b4:	40d7073b          	subw	a4,a4,a3
    800004b8:	409787bb          	subw	a5,a5,s1
    800004bc:	41f7d69b          	sraiw	a3,a5,0x1f
    800004c0:	00f6c7b3          	xor	a5,a3,a5
    800004c4:	40d787bb          	subw	a5,a5,a3
    800004c8:	00f707bb          	addw	a5,a4,a5
    800004cc:	00344703          	lbu	a4,3(s0)
    800004d0:	00e787bb          	addw	a5,a5,a4
    800004d4:	00f401a3          	sb	a5,3(s0)
    800004d8:	f5dff06f          	j	80000434 <_ZN8N_puzzleILi4EEC1Ev+0xbc>

00000000800004dc <_ZN8N_puzzleILi4EEC1EPi>:
    800004dc:	00100793          	li	a5,1
    800004e0:	00f50023          	sb	a5,0(a0)
    800004e4:	ff010113          	addi	sp,sp,-16
    800004e8:	000501a3          	sb	zero,3(a0)
    800004ec:	00000793          	li	a5,0
    800004f0:	01000713          	li	a4,16
    800004f4:	00f106b3          	add	a3,sp,a5
    800004f8:	00068023          	sb	zero,0(a3)
    800004fc:	00178793          	addi	a5,a5,1
    80000500:	fee79ae3          	bne	a5,a4,800004f4 <_ZN8N_puzzleILi4EEC1EPi+0x18>
    80000504:	00000693          	li	a3,0
    80000508:	00100e93          	li	t4,1
    8000050c:	00400313          	li	t1,4
    80000510:	00400f13          	li	t5,4
    80000514:	00469893          	slli	a7,a3,0x4
    80000518:	00269813          	slli	a6,a3,0x2
    8000051c:	00068f9b          	sext.w	t6,a3
    80000520:	011588b3          	add	a7,a1,a7
    80000524:	01050833          	add	a6,a0,a6
    80000528:	00000613          	li	a2,0
    8000052c:	0008a783          	lw	a5,0(a7)
    80000530:	01078713          	addi	a4,a5,16
    80000534:	00270733          	add	a4,a4,sp
    80000538:	00f80223          	sb	a5,4(a6)
    8000053c:	ffd70823          	sb	t4,-16(a4)
    80000540:	04079263          	bnez	a5,80000584 <_ZN8N_puzzleILi4EEC1EPi+0xa8>
    80000544:	00d500a3          	sb	a3,1(a0)
    80000548:	00c50123          	sb	a2,2(a0)
    8000054c:	0016061b          	addiw	a2,a2,1
    80000550:	00488893          	addi	a7,a7,4
    80000554:	00180813          	addi	a6,a6,1
    80000558:	fde61ae3          	bne	a2,t5,8000052c <_ZN8N_puzzleILi4EEC1EPi+0x50>
    8000055c:	00168693          	addi	a3,a3,1
    80000560:	fac69ae3          	bne	a3,a2,80000514 <_ZN8N_puzzleILi4EEC1EPi+0x38>
    80000564:	00000793          	li	a5,0
    80000568:	01000713          	li	a4,16
    8000056c:	00f106b3          	add	a3,sp,a5
    80000570:	0006c683          	lbu	a3,0(a3)
    80000574:	04069863          	bnez	a3,800005c4 <_ZN8N_puzzleILi4EEC1EPi+0xe8>
    80000578:	00050023          	sb	zero,0(a0)
    8000057c:	01010113          	addi	sp,sp,16
    80000580:	00008067          	ret
    80000584:	fff7879b          	addiw	a5,a5,-1
    80000588:	0267c73b          	divw	a4,a5,t1
    8000058c:	0267e7bb          	remw	a5,a5,t1
    80000590:	41f7073b          	subw	a4,a4,t6
    80000594:	41f75e1b          	sraiw	t3,a4,0x1f
    80000598:	00ee4733          	xor	a4,t3,a4
    8000059c:	41c7073b          	subw	a4,a4,t3
    800005a0:	40c787bb          	subw	a5,a5,a2
    800005a4:	41f7de1b          	sraiw	t3,a5,0x1f
    800005a8:	00fe47b3          	xor	a5,t3,a5
    800005ac:	41c787bb          	subw	a5,a5,t3
    800005b0:	00f707bb          	addw	a5,a4,a5
    800005b4:	00354703          	lbu	a4,3(a0)
    800005b8:	00e787bb          	addw	a5,a5,a4
    800005bc:	00f501a3          	sb	a5,3(a0)
    800005c0:	f8dff06f          	j	8000054c <_ZN8N_puzzleILi4EEC1EPi+0x70>
    800005c4:	00178793          	addi	a5,a5,1
    800005c8:	fae792e3          	bne	a5,a4,8000056c <_ZN8N_puzzleILi4EEC1EPi+0x90>
    800005cc:	01010113          	addi	sp,sp,16
    800005d0:	d65ff06f          	j	80000334 <_ZN8N_puzzleILi4EE14determine_hashEv>

00000000800005d4 <_ZNK14Updatable_heapI8N_puzzleILi4EEE7pointerERKS1_>:
    800005d4:	0005c683          	lbu	a3,0(a1)
    800005d8:	fe010113          	addi	sp,sp,-32
    800005dc:	00913423          	sd	s1,8(sp)
    800005e0:	00113c23          	sd	ra,24(sp)
    800005e4:	00813823          	sd	s0,16(sp)
    800005e8:	00853703          	ld	a4,8(a0)
    800005ec:	00058493          	mv	s1,a1
    800005f0:	00000793          	li	a5,0
    800005f4:	00068463          	beqz	a3,800005fc <_ZNK14Updatable_heapI8N_puzzleILi4EEE7pointerERKS1_+0x28>
    800005f8:	0145a783          	lw	a5,20(a1)
    800005fc:	00052683          	lw	a3,0(a0)
    80000600:	fff6869b          	addiw	a3,a3,-1
    80000604:	00d7f7b3          	and	a5,a5,a3
    80000608:	02079793          	slli	a5,a5,0x20
    8000060c:	01d7d793          	srli	a5,a5,0x1d
    80000610:	00f707b3          	add	a5,a4,a5
    80000614:	0007b403          	ld	s0,0(a5)
    80000618:	00040e63          	beqz	s0,80000634 <_ZNK14Updatable_heapI8N_puzzleILi4EEE7pointerERKS1_+0x60>
    8000061c:	00048593          	mv	a1,s1
    80000620:	00040513          	mv	a0,s0
    80000624:	cadff0ef          	jal	ra,800002d0 <_ZNK8N_puzzleILi4EEeqERKS0_>
    80000628:	00051663          	bnez	a0,80000634 <_ZNK14Updatable_heapI8N_puzzleILi4EEE7pointerERKS1_+0x60>
    8000062c:	01843403          	ld	s0,24(s0)
    80000630:	fe9ff06f          	j	80000618 <_ZNK14Updatable_heapI8N_puzzleILi4EEE7pointerERKS1_+0x44>
    80000634:	01813083          	ld	ra,24(sp)
    80000638:	00040513          	mv	a0,s0
    8000063c:	01013403          	ld	s0,16(sp)
    80000640:	00813483          	ld	s1,8(sp)
    80000644:	02010113          	addi	sp,sp,32
    80000648:	00008067          	ret

000000008000064c <_ZNK14Updatable_heapI8N_puzzleILi4EEE6lengthERKS1_>:
    8000064c:	ff010113          	addi	sp,sp,-16
    80000650:	00113423          	sd	ra,8(sp)
    80000654:	f81ff0ef          	jal	ra,800005d4 <_ZNK14Updatable_heapI8N_puzzleILi4EEE7pointerERKS1_>
    80000658:	00050a63          	beqz	a0,8000066c <_ZNK14Updatable_heapI8N_puzzleILi4EEE6lengthERKS1_+0x20>
    8000065c:	02452503          	lw	a0,36(a0)
    80000660:	00813083          	ld	ra,8(sp)
    80000664:	01010113          	addi	sp,sp,16
    80000668:	00008067          	ret
    8000066c:	80000537          	lui	a0,0x80000
    80000670:	fff54513          	not	a0,a0
    80000674:	fedff06f          	j	80000660 <_ZNK14Updatable_heapI8N_puzzleILi4EEE6lengthERKS1_+0x14>

0000000080000678 <_ZN14Updatable_heapI8N_puzzleILi4EEE12percolate_upEi>:
    80000678:	fd010113          	addi	sp,sp,-48
    8000067c:	00913c23          	sd	s1,24(sp)
    80000680:	01213823          	sd	s2,16(sp)
    80000684:	01313423          	sd	s3,8(sp)
    80000688:	02113423          	sd	ra,40(sp)
    8000068c:	02813023          	sd	s0,32(sp)
    80000690:	00050493          	mv	s1,a0
    80000694:	00058613          	mv	a2,a1
    80000698:	00100913          	li	s2,1
    8000069c:	00200993          	li	s3,2
    800006a0:	05260063          	beq	a2,s2,800006e0 <_ZN14Updatable_heapI8N_puzzleILi4EEE12percolate_upEi+0x68>
    800006a4:	0336443b          	divw	s0,a2,s3
    800006a8:	0104b503          	ld	a0,16(s1)
    800006ac:	00341793          	slli	a5,s0,0x3
    800006b0:	00f507b3          	add	a5,a0,a5
    800006b4:	0007b703          	ld	a4,0(a5)
    800006b8:	00361793          	slli	a5,a2,0x3
    800006bc:	00f507b3          	add	a5,a0,a5
    800006c0:	0007b783          	ld	a5,0(a5)
    800006c4:	02872703          	lw	a4,40(a4)
    800006c8:	0287a783          	lw	a5,40(a5)
    800006cc:	00e7da63          	bge	a5,a4,800006e0 <_ZN14Updatable_heapI8N_puzzleILi4EEE12percolate_upEi+0x68>
    800006d0:	00040593          	mv	a1,s0
    800006d4:	af9ff0ef          	jal	ra,800001cc <_ZN14Updatable_heapI8N_puzzleILi4EEE4swapEii.isra.0>
    800006d8:	00040613          	mv	a2,s0
    800006dc:	fc5ff06f          	j	800006a0 <_ZN14Updatable_heapI8N_puzzleILi4EEE12percolate_upEi+0x28>
    800006e0:	02813083          	ld	ra,40(sp)
    800006e4:	02013403          	ld	s0,32(sp)
    800006e8:	01813483          	ld	s1,24(sp)
    800006ec:	01013903          	ld	s2,16(sp)
    800006f0:	00813983          	ld	s3,8(sp)
    800006f4:	03010113          	addi	sp,sp,48
    800006f8:	00008067          	ret

00000000800006fc <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i>:
    800006fc:	fc010113          	addi	sp,sp,-64
    80000700:	02813823          	sd	s0,48(sp)
    80000704:	03213023          	sd	s2,32(sp)
    80000708:	01313c23          	sd	s3,24(sp)
    8000070c:	02113c23          	sd	ra,56(sp)
    80000710:	02913423          	sd	s1,40(sp)
    80000714:	01413823          	sd	s4,16(sp)
    80000718:	01513423          	sd	s5,8(sp)
    8000071c:	00050413          	mv	s0,a0
    80000720:	00058993          	mv	s3,a1
    80000724:	00060913          	mv	s2,a2
    80000728:	eadff0ef          	jal	ra,800005d4 <_ZNK14Updatable_heapI8N_puzzleILi4EEE7pointerERKS1_>
    8000072c:	10051a63          	bnez	a0,80000840 <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i+0x144>
    80000730:	01842783          	lw	a5,24(s0)
    80000734:	03800513          	li	a0,56
    80000738:	0017879b          	addiw	a5,a5,1
    8000073c:	00f42c23          	sw	a5,24(s0)
    80000740:	731010ef          	jal	ra,80002670 <bench_alloc>
    80000744:	0009c683          	lbu	a3,0(s3)
    80000748:	00843703          	ld	a4,8(s0)
    8000074c:	00050493          	mv	s1,a0
    80000750:	00000793          	li	a5,0
    80000754:	00068463          	beqz	a3,8000075c <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i+0x60>
    80000758:	0149a783          	lw	a5,20(s3)
    8000075c:	00042683          	lw	a3,0(s0)
    80000760:	00098593          	mv	a1,s3
    80000764:	00048513          	mv	a0,s1
    80000768:	fff6869b          	addiw	a3,a3,-1
    8000076c:	00d7f7b3          	and	a5,a5,a3
    80000770:	02079793          	slli	a5,a5,0x20
    80000774:	01d7d793          	srli	a5,a5,0x1d
    80000778:	00f707b3          	add	a5,a4,a5
    8000077c:	0007ba83          	ld	s5,0(a5)
    80000780:	01842a03          	lw	s4,24(s0)
    80000784:	a79ff0ef          	jal	ra,800001fc <_ZN8N_puzzleILi4EEaSERKS0_.isra.0>
    80000788:	0004c783          	lbu	a5,0(s1)
    8000078c:	0154bc23          	sd	s5,24(s1)
    80000790:	0344a023          	sw	s4,32(s1)
    80000794:	0324a223          	sw	s2,36(s1)
    80000798:	04000613          	li	a2,64
    8000079c:	00078463          	beqz	a5,800007a4 <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i+0xa8>
    800007a0:	00348603          	lb	a2,3(s1)
    800007a4:	02048623          	sb	zero,44(s1)
    800007a8:	0009c683          	lbu	a3,0(s3)
    800007ac:	00c9063b          	addw	a2,s2,a2
    800007b0:	02c4a423          	sw	a2,40(s1)
    800007b4:	0204b823          	sd	zero,48(s1)
    800007b8:	00843703          	ld	a4,8(s0)
    800007bc:	00000793          	li	a5,0
    800007c0:	00068463          	beqz	a3,800007c8 <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i+0xcc>
    800007c4:	0149a783          	lw	a5,20(s3)
    800007c8:	00042683          	lw	a3,0(s0)
    800007cc:	01842583          	lw	a1,24(s0)
    800007d0:	00040513          	mv	a0,s0
    800007d4:	fff6869b          	addiw	a3,a3,-1
    800007d8:	00d7f7b3          	and	a5,a5,a3
    800007dc:	02079793          	slli	a5,a5,0x20
    800007e0:	01d7d793          	srli	a5,a5,0x1d
    800007e4:	00f707b3          	add	a5,a4,a5
    800007e8:	0097b023          	sd	s1,0(a5)
    800007ec:	01043783          	ld	a5,16(s0)
    800007f0:	00359713          	slli	a4,a1,0x3
    800007f4:	00e787b3          	add	a5,a5,a4
    800007f8:	0097b023          	sd	s1,0(a5)
    800007fc:	e7dff0ef          	jal	ra,80000678 <_ZN14Updatable_heapI8N_puzzleILi4EEE12percolate_upEi>
    80000800:	01842703          	lw	a4,24(s0)
    80000804:	01c42783          	lw	a5,28(s0)
    80000808:	0007069b          	sext.w	a3,a4
    8000080c:	0007861b          	sext.w	a2,a5
    80000810:	00d65463          	bge	a2,a3,80000818 <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i+0x11c>
    80000814:	00070793          	mv	a5,a4
    80000818:	00f42e23          	sw	a5,28(s0)
    8000081c:	03813083          	ld	ra,56(sp)
    80000820:	03013403          	ld	s0,48(sp)
    80000824:	02813483          	ld	s1,40(sp)
    80000828:	02013903          	ld	s2,32(sp)
    8000082c:	01813983          	ld	s3,24(sp)
    80000830:	01013a03          	ld	s4,16(sp)
    80000834:	00813a83          	ld	s5,8(sp)
    80000838:	04010113          	addi	sp,sp,64
    8000083c:	00008067          	ret
    80000840:	02c54783          	lbu	a5,44(a0) # ffffffff8000002c <__bss_end+0xfffffffefffd946c>
    80000844:	fc079ce3          	bnez	a5,8000081c <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i+0x120>
    80000848:	00054783          	lbu	a5,0(a0)
    8000084c:	04000613          	li	a2,64
    80000850:	00078463          	beqz	a5,80000858 <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i+0x15c>
    80000854:	00350603          	lb	a2,3(a0)
    80000858:	02852703          	lw	a4,40(a0)
    8000085c:	00c907bb          	addw	a5,s2,a2
    80000860:	fae7dee3          	bge	a5,a4,8000081c <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i+0x120>
    80000864:	02052583          	lw	a1,32(a0)
    80000868:	02f52423          	sw	a5,40(a0)
    8000086c:	00040513          	mv	a0,s0
    80000870:	03013403          	ld	s0,48(sp)
    80000874:	03813083          	ld	ra,56(sp)
    80000878:	02813483          	ld	s1,40(sp)
    8000087c:	02013903          	ld	s2,32(sp)
    80000880:	01813983          	ld	s3,24(sp)
    80000884:	01013a03          	ld	s4,16(sp)
    80000888:	00813a83          	ld	s5,8(sp)
    8000088c:	04010113          	addi	sp,sp,64
    80000890:	de9ff06f          	j	80000678 <_ZN14Updatable_heapI8N_puzzleILi4EEE12percolate_upEi>

0000000080000894 <_ZN14Updatable_heapI8N_puzzleILi4EEE14percolate_downEv>:
    80000894:	fe010113          	addi	sp,sp,-32
    80000898:	00813823          	sd	s0,16(sp)
    8000089c:	00113c23          	sd	ra,24(sp)
    800008a0:	00050413          	mv	s0,a0
    800008a4:	00100593          	li	a1,1
    800008a8:	01842783          	lw	a5,24(s0)
    800008ac:	0015961b          	slliw	a2,a1,0x1
    800008b0:	00060713          	mv	a4,a2
    800008b4:	06f65863          	bge	a2,a5,80000924 <_ZN14Updatable_heapI8N_puzzleILi4EEE14percolate_downEv+0x90>
    800008b8:	01043503          	ld	a0,16(s0)
    800008bc:	00359693          	slli	a3,a1,0x3
    800008c0:	00d507b3          	add	a5,a0,a3
    800008c4:	0007b803          	ld	a6,0(a5)
    800008c8:	00d787b3          	add	a5,a5,a3
    800008cc:	0007b783          	ld	a5,0(a5)
    800008d0:	02882803          	lw	a6,40(a6)
    800008d4:	0287a683          	lw	a3,40(a5)
    800008d8:	00160793          	addi	a5,a2,1
    800008dc:	00379793          	slli	a5,a5,0x3
    800008e0:	00f507b3          	add	a5,a0,a5
    800008e4:	0007b783          	ld	a5,0(a5)
    800008e8:	0287a783          	lw	a5,40(a5)
    800008ec:	00d85c63          	bge	a6,a3,80000904 <_ZN14Updatable_heapI8N_puzzleILi4EEE14percolate_downEv+0x70>
    800008f0:	02f85663          	bge	a6,a5,8000091c <_ZN14Updatable_heapI8N_puzzleILi4EEE14percolate_downEv+0x88>
    800008f4:	01813083          	ld	ra,24(sp)
    800008f8:	01013403          	ld	s0,16(sp)
    800008fc:	02010113          	addi	sp,sp,32
    80000900:	00008067          	ret
    80000904:	00f6dc63          	bge	a3,a5,8000091c <_ZN14Updatable_heapI8N_puzzleILi4EEE14percolate_downEv+0x88>
    80000908:	00c13423          	sd	a2,8(sp)
    8000090c:	8c1ff0ef          	jal	ra,800001cc <_ZN14Updatable_heapI8N_puzzleILi4EEE4swapEii.isra.0>
    80000910:	00813603          	ld	a2,8(sp)
    80000914:	00060593          	mv	a1,a2
    80000918:	f91ff06f          	j	800008a8 <_ZN14Updatable_heapI8N_puzzleILi4EEE14percolate_downEv+0x14>
    8000091c:	0017061b          	addiw	a2,a4,1
    80000920:	fe9ff06f          	j	80000908 <_ZN14Updatable_heapI8N_puzzleILi4EEE14percolate_downEv+0x74>
    80000924:	fcf618e3          	bne	a2,a5,800008f4 <_ZN14Updatable_heapI8N_puzzleILi4EEE14percolate_downEv+0x60>
    80000928:	01043503          	ld	a0,16(s0)
    8000092c:	00361793          	slli	a5,a2,0x3
    80000930:	00f507b3          	add	a5,a0,a5
    80000934:	0007b703          	ld	a4,0(a5)
    80000938:	00359793          	slli	a5,a1,0x3
    8000093c:	00f507b3          	add	a5,a0,a5
    80000940:	0007b783          	ld	a5,0(a5)
    80000944:	02872703          	lw	a4,40(a4)
    80000948:	0287a783          	lw	a5,40(a5)
    8000094c:	faf754e3          	bge	a4,a5,800008f4 <_ZN14Updatable_heapI8N_puzzleILi4EEE14percolate_downEv+0x60>
    80000950:	01013403          	ld	s0,16(sp)
    80000954:	01813083          	ld	ra,24(sp)
    80000958:	02010113          	addi	sp,sp,32
    8000095c:	871ff06f          	j	800001cc <_ZN14Updatable_heapI8N_puzzleILi4EEE4swapEii.isra.0>

0000000080000960 <bench_15pz_run>:
    80000960:	f2010113          	addi	sp,sp,-224
    80000964:	00810513          	addi	a0,sp,8
    80000968:	0c113c23          	sd	ra,216(sp)
    8000096c:	0c813823          	sd	s0,208(sp)
    80000970:	0c913423          	sd	s1,200(sp)
    80000974:	0d213023          	sd	s2,192(sp)
    80000978:	0b313c23          	sd	s3,184(sp)
    8000097c:	0b413823          	sd	s4,176(sp)
    80000980:	0b513423          	sd	s5,168(sp)
    80000984:	0b613023          	sd	s6,160(sp)
    80000988:	09713c23          	sd	s7,152(sp)
    8000098c:	9edff0ef          	jal	ra,80000378 <_ZN8N_puzzleILi4EEC1Ev>
    80000990:	0001d797          	auipc	a5,0x1d
    80000994:	e907b783          	ld	a5,-368(a5) # 8001d820 <setting>
    80000998:	0007a783          	lw	a5,0(a5)
    8000099c:	00200713          	li	a4,2
    800009a0:	0ee78463          	beq	a5,a4,80000a88 <bench_15pz_run+0x128>
    800009a4:	00000493          	li	s1,0
    800009a8:	06f74463          	blt	a4,a5,80000a10 <bench_15pz_run+0xb0>
    800009ac:	08078863          	beqz	a5,80000a3c <bench_15pz_run+0xdc>
    800009b0:	00100713          	li	a4,1
    800009b4:	0ae78663          	beq	a5,a4,80000a60 <bench_15pz_run+0x100>
    800009b8:	02000513          	li	a0,32
    800009bc:	4b5010ef          	jal	ra,80002670 <bench_alloc>
    800009c0:	00050413          	mv	s0,a0
    800009c4:	00952023          	sw	s1,0(a0)
    800009c8:	00349513          	slli	a0,s1,0x3
    800009cc:	4a5010ef          	jal	ra,80002670 <bench_alloc>
    800009d0:	00a43823          	sd	a0,16(s0)
    800009d4:	00042503          	lw	a0,0(s0)
    800009d8:	0015051b          	addiw	a0,a0,1
    800009dc:	00351513          	slli	a0,a0,0x3
    800009e0:	491010ef          	jal	ra,80002670 <bench_alloc>
    800009e4:	00042683          	lw	a3,0(s0)
    800009e8:	00a43423          	sd	a0,8(s0)
    800009ec:	00043c23          	sd	zero,24(s0)
    800009f0:	00000793          	li	a5,0
    800009f4:	0007871b          	sext.w	a4,a5
    800009f8:	0ad75a63          	bge	a4,a3,80000aac <bench_15pz_run+0x14c>
    800009fc:	00379713          	slli	a4,a5,0x3
    80000a00:	00e50733          	add	a4,a0,a4
    80000a04:	00073023          	sd	zero,0(a4)
    80000a08:	00178793          	addi	a5,a5,1
    80000a0c:	fe9ff06f          	j	800009f4 <bench_15pz_run+0x94>
    80000a10:	00300713          	li	a4,3
    80000a14:	fae792e3          	bne	a5,a4,800009b8 <bench_15pz_run+0x58>
    80000a18:	00014597          	auipc	a1,0x14
    80000a1c:	3c858593          	addi	a1,a1,968 # 80014de0 <_ZL8PUZZLE_H>
    80000a20:	05010513          	addi	a0,sp,80
    80000a24:	ab9ff0ef          	jal	ra,800004dc <_ZN8N_puzzleILi4EEC1EPi>
    80000a28:	05010593          	addi	a1,sp,80
    80000a2c:	00810513          	addi	a0,sp,8
    80000a30:	fccff0ef          	jal	ra,800001fc <_ZN8N_puzzleILi4EEaSERKS0_.isra.0>
    80000a34:	000c04b7          	lui	s1,0xc0
    80000a38:	f81ff06f          	j	800009b8 <bench_15pz_run+0x58>
    80000a3c:	00014597          	auipc	a1,0x14
    80000a40:	46458593          	addi	a1,a1,1124 # 80014ea0 <_ZL8PUZZLE_S>
    80000a44:	05010513          	addi	a0,sp,80
    80000a48:	a95ff0ef          	jal	ra,800004dc <_ZN8N_puzzleILi4EEC1EPi>
    80000a4c:	05010593          	addi	a1,sp,80
    80000a50:	00810513          	addi	a0,sp,8
    80000a54:	fa8ff0ef          	jal	ra,800001fc <_ZN8N_puzzleILi4EEaSERKS0_.isra.0>
    80000a58:	00a00493          	li	s1,10
    80000a5c:	f5dff06f          	j	800009b8 <bench_15pz_run+0x58>
    80000a60:	00014597          	auipc	a1,0x14
    80000a64:	40058593          	addi	a1,a1,1024 # 80014e60 <_ZL8PUZZLE_M>
    80000a68:	05010513          	addi	a0,sp,80
    80000a6c:	a71ff0ef          	jal	ra,800004dc <_ZN8N_puzzleILi4EEC1EPi>
    80000a70:	05010593          	addi	a1,sp,80
    80000a74:	00810513          	addi	a0,sp,8
    80000a78:	000014b7          	lui	s1,0x1
    80000a7c:	f80ff0ef          	jal	ra,800001fc <_ZN8N_puzzleILi4EEaSERKS0_.isra.0>
    80000a80:	80048493          	addi	s1,s1,-2048 # 800 <__STACKSIZE__-0x3800>
    80000a84:	f35ff06f          	j	800009b8 <bench_15pz_run+0x58>
    80000a88:	00014597          	auipc	a1,0x14
    80000a8c:	39858593          	addi	a1,a1,920 # 80014e20 <_ZL8PUZZLE_L>
    80000a90:	05010513          	addi	a0,sp,80
    80000a94:	a49ff0ef          	jal	ra,800004dc <_ZN8N_puzzleILi4EEC1EPi>
    80000a98:	05010593          	addi	a1,sp,80
    80000a9c:	00810513          	addi	a0,sp,8
    80000aa0:	f5cff0ef          	jal	ra,800001fc <_ZN8N_puzzleILi4EEaSERKS0_.isra.0>
    80000aa4:	000044b7          	lui	s1,0x4
    80000aa8:	f11ff06f          	j	800009b8 <bench_15pz_run+0x58>
    80000aac:	00000613          	li	a2,0
    80000ab0:	00810593          	addi	a1,sp,8
    80000ab4:	00040513          	mv	a0,s0
    80000ab8:	c45ff0ef          	jal	ra,800006fc <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i>
    80000abc:	0001da97          	auipc	s5,0x1d
    80000ac0:	d04a8a93          	addi	s5,s5,-764 # 8001d7c0 <_ZL3ans>
    80000ac4:	fff00793          	li	a5,-1
    80000ac8:	00faa023          	sw	a5,0(s5)
    80000acc:	00000913          	li	s2,0
    80000ad0:	00100b13          	li	s6,1
    80000ad4:	00f00b93          	li	s7,15
    80000ad8:	00300993          	li	s3,3
    80000adc:	00400a13          	li	s4,4
    80000ae0:	01842783          	lw	a5,24(s0)
    80000ae4:	08078063          	beqz	a5,80000b64 <bench_15pz_run+0x204>
    80000ae8:	07248e63          	beq	s1,s2,80000b64 <bench_15pz_run+0x204>
    80000aec:	01043783          	ld	a5,16(s0)
    80000af0:	05010513          	addi	a0,sp,80
    80000af4:	0087b583          	ld	a1,8(a5)
    80000af8:	f8cff0ef          	jal	ra,80000284 <_ZN8N_puzzleILi4EEC1ERKS0_>
    80000afc:	01842783          	lw	a5,24(s0)
    80000b00:	09679863          	bne	a5,s6,80000b90 <bench_15pz_run+0x230>
    80000b04:	00042c23          	sw	zero,24(s0)
    80000b08:	05010593          	addi	a1,sp,80
    80000b0c:	02010513          	addi	a0,sp,32
    80000b10:	f74ff0ef          	jal	ra,80000284 <_ZN8N_puzzleILi4EEC1ERKS0_>
    80000b14:	0019091b          	addiw	s2,s2,1
    80000b18:	05010713          	addi	a4,sp,80
    80000b1c:	00000793          	li	a5,0
    80000b20:	0017879b          	addiw	a5,a5,1
    80000b24:	00f72023          	sw	a5,0(a4)
    80000b28:	00470713          	addi	a4,a4,4
    80000b2c:	ff779ae3          	bne	a5,s7,80000b20 <bench_15pz_run+0x1c0>
    80000b30:	05010593          	addi	a1,sp,80
    80000b34:	03810513          	addi	a0,sp,56
    80000b38:	08012623          	sw	zero,140(sp)
    80000b3c:	9a1ff0ef          	jal	ra,800004dc <_ZN8N_puzzleILi4EEC1EPi>
    80000b40:	03810593          	addi	a1,sp,56
    80000b44:	02010513          	addi	a0,sp,32
    80000b48:	f88ff0ef          	jal	ra,800002d0 <_ZNK8N_puzzleILi4EEeqERKS0_>
    80000b4c:	06050a63          	beqz	a0,80000bc0 <bench_15pz_run+0x260>
    80000b50:	02010593          	addi	a1,sp,32
    80000b54:	00040513          	mv	a0,s0
    80000b58:	af5ff0ef          	jal	ra,8000064c <_ZNK14Updatable_heapI8N_puzzleILi4EEE6lengthERKS1_>
    80000b5c:	02a9093b          	mulw	s2,s2,a0
    80000b60:	012aa023          	sw	s2,0(s5)
    80000b64:	0d813083          	ld	ra,216(sp)
    80000b68:	0d013403          	ld	s0,208(sp)
    80000b6c:	0c813483          	ld	s1,200(sp)
    80000b70:	0c013903          	ld	s2,192(sp)
    80000b74:	0b813983          	ld	s3,184(sp)
    80000b78:	0b013a03          	ld	s4,176(sp)
    80000b7c:	0a813a83          	ld	s5,168(sp)
    80000b80:	0a013b03          	ld	s6,160(sp)
    80000b84:	09813b83          	ld	s7,152(sp)
    80000b88:	0e010113          	addi	sp,sp,224
    80000b8c:	00008067          	ret
    80000b90:	01043703          	ld	a4,16(s0)
    80000b94:	00379793          	slli	a5,a5,0x3
    80000b98:	00040513          	mv	a0,s0
    80000b9c:	00f707b3          	add	a5,a4,a5
    80000ba0:	0007b783          	ld	a5,0(a5)
    80000ba4:	00f73423          	sd	a5,8(a4)
    80000ba8:	0367a023          	sw	s6,32(a5)
    80000bac:	01842783          	lw	a5,24(s0)
    80000bb0:	fff7879b          	addiw	a5,a5,-1
    80000bb4:	00f42c23          	sw	a5,24(s0)
    80000bb8:	cddff0ef          	jal	ra,80000894 <_ZN14Updatable_heapI8N_puzzleILi4EEE14percolate_downEv>
    80000bbc:	f4dff06f          	j	80000b08 <bench_15pz_run+0x1a8>
    80000bc0:	02014783          	lbu	a5,32(sp)
    80000bc4:	f0078ee3          	beqz	a5,80000ae0 <bench_15pz_run+0x180>
    80000bc8:	02214783          	lbu	a5,34(sp)
    80000bcc:	05379863          	bne	a5,s3,80000c1c <bench_15pz_run+0x2bc>
    80000bd0:	02010593          	addi	a1,sp,32
    80000bd4:	05010513          	addi	a0,sp,80
    80000bd8:	eacff0ef          	jal	ra,80000284 <_ZN8N_puzzleILi4EEC1ERKS0_>
    80000bdc:	02214603          	lbu	a2,34(sp)
    80000be0:	14061c63          	bnez	a2,80000d38 <bench_15pz_run+0x3d8>
    80000be4:	04010823          	sb	zero,80(sp)
    80000be8:	05010593          	addi	a1,sp,80
    80000bec:	03810513          	addi	a0,sp,56
    80000bf0:	e94ff0ef          	jal	ra,80000284 <_ZN8N_puzzleILi4EEC1ERKS0_>
    80000bf4:	02010593          	addi	a1,sp,32
    80000bf8:	00040513          	mv	a0,s0
    80000bfc:	a51ff0ef          	jal	ra,8000064c <_ZNK14Updatable_heapI8N_puzzleILi4EEE6lengthERKS1_>
    80000c00:	0015061b          	addiw	a2,a0,1
    80000c04:	03810593          	addi	a1,sp,56
    80000c08:	00040513          	mv	a0,s0
    80000c0c:	af1ff0ef          	jal	ra,800006fc <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i>
    80000c10:	02014783          	lbu	a5,32(sp)
    80000c14:	04079c63          	bnez	a5,80000c6c <bench_15pz_run+0x30c>
    80000c18:	ec9ff06f          	j	80000ae0 <bench_15pz_run+0x180>
    80000c1c:	02010593          	addi	a1,sp,32
    80000c20:	05010513          	addi	a0,sp,80
    80000c24:	e60ff0ef          	jal	ra,80000284 <_ZN8N_puzzleILi4EEC1ERKS0_>
    80000c28:	02214603          	lbu	a2,34(sp)
    80000c2c:	09361663          	bne	a2,s3,80000cb8 <bench_15pz_run+0x358>
    80000c30:	04010823          	sb	zero,80(sp)
    80000c34:	05010593          	addi	a1,sp,80
    80000c38:	03810513          	addi	a0,sp,56
    80000c3c:	e48ff0ef          	jal	ra,80000284 <_ZN8N_puzzleILi4EEC1ERKS0_>
    80000c40:	02010593          	addi	a1,sp,32
    80000c44:	00040513          	mv	a0,s0
    80000c48:	a05ff0ef          	jal	ra,8000064c <_ZNK14Updatable_heapI8N_puzzleILi4EEE6lengthERKS1_>
    80000c4c:	0015061b          	addiw	a2,a0,1
    80000c50:	03810593          	addi	a1,sp,56
    80000c54:	00040513          	mv	a0,s0
    80000c58:	aa5ff0ef          	jal	ra,800006fc <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i>
    80000c5c:	02014783          	lbu	a5,32(sp)
    80000c60:	e80780e3          	beqz	a5,80000ae0 <bench_15pz_run+0x180>
    80000c64:	02214783          	lbu	a5,34(sp)
    80000c68:	f60794e3          	bnez	a5,80000bd0 <bench_15pz_run+0x270>
    80000c6c:	02114783          	lbu	a5,33(sp)
    80000c70:	15379663          	bne	a5,s3,80000dbc <bench_15pz_run+0x45c>
    80000c74:	02010593          	addi	a1,sp,32
    80000c78:	05010513          	addi	a0,sp,80
    80000c7c:	e08ff0ef          	jal	ra,80000284 <_ZN8N_puzzleILi4EEC1ERKS0_>
    80000c80:	02114683          	lbu	a3,33(sp)
    80000c84:	22069463          	bnez	a3,80000eac <bench_15pz_run+0x54c>
    80000c88:	04010823          	sb	zero,80(sp)
    80000c8c:	05010593          	addi	a1,sp,80
    80000c90:	03810513          	addi	a0,sp,56
    80000c94:	df0ff0ef          	jal	ra,80000284 <_ZN8N_puzzleILi4EEC1ERKS0_>
    80000c98:	02010593          	addi	a1,sp,32
    80000c9c:	00040513          	mv	a0,s0
    80000ca0:	9adff0ef          	jal	ra,8000064c <_ZNK14Updatable_heapI8N_puzzleILi4EEE6lengthERKS1_>
    80000ca4:	0015061b          	addiw	a2,a0,1
    80000ca8:	03810593          	addi	a1,sp,56
    80000cac:	00040513          	mv	a0,s0
    80000cb0:	a4dff0ef          	jal	ra,800006fc <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i>
    80000cb4:	e2dff06f          	j	80000ae0 <bench_15pz_run+0x180>
    80000cb8:	02114683          	lbu	a3,33(sp)
    80000cbc:	0016081b          	addiw	a6,a2,1
    80000cc0:	00269693          	slli	a3,a3,0x2
    80000cc4:	09068793          	addi	a5,a3,144
    80000cc8:	002786b3          	add	a3,a5,sp
    80000ccc:	00d607b3          	add	a5,a2,a3
    80000cd0:	f9578583          	lb	a1,-107(a5)
    80000cd4:	fff5879b          	addiw	a5,a1,-1
    80000cd8:	0347e7bb          	remw	a5,a5,s4
    80000cdc:	40c7873b          	subw	a4,a5,a2
    80000ce0:	41f7551b          	sraiw	a0,a4,0x1f
    80000ce4:	410787bb          	subw	a5,a5,a6
    80000ce8:	00e54733          	xor	a4,a0,a4
    80000cec:	40a7073b          	subw	a4,a4,a0
    80000cf0:	41f7d51b          	sraiw	a0,a5,0x1f
    80000cf4:	00f547b3          	xor	a5,a0,a5
    80000cf8:	40a787bb          	subw	a5,a5,a0
    80000cfc:	40f707bb          	subw	a5,a4,a5
    80000d00:	05314703          	lbu	a4,83(sp)
    80000d04:	00c68633          	add	a2,a3,a2
    80000d08:	05010513          	addi	a0,sp,80
    80000d0c:	00e787bb          	addw	a5,a5,a4
    80000d10:	04f109a3          	sb	a5,83(sp)
    80000d14:	fcb60223          	sb	a1,-60(a2)
    80000d18:	05214783          	lbu	a5,82(sp)
    80000d1c:	0017879b          	addiw	a5,a5,1
    80000d20:	0ff7f793          	zext.b	a5,a5
    80000d24:	04f10923          	sb	a5,82(sp)
    80000d28:	00f687b3          	add	a5,a3,a5
    80000d2c:	fc078223          	sb	zero,-60(a5)
    80000d30:	e04ff0ef          	jal	ra,80000334 <_ZN8N_puzzleILi4EE14determine_hashEv>
    80000d34:	f01ff06f          	j	80000c34 <bench_15pz_run+0x2d4>
    80000d38:	02114683          	lbu	a3,33(sp)
    80000d3c:	fff6071b          	addiw	a4,a2,-1
    80000d40:	00070513          	mv	a0,a4
    80000d44:	00269693          	slli	a3,a3,0x2
    80000d48:	09068793          	addi	a5,a3,144
    80000d4c:	002786b3          	add	a3,a5,sp
    80000d50:	00e68733          	add	a4,a3,a4
    80000d54:	f9470583          	lb	a1,-108(a4)
    80000d58:	fff5879b          	addiw	a5,a1,-1
    80000d5c:	0347e7bb          	remw	a5,a5,s4
    80000d60:	40c7873b          	subw	a4,a5,a2
    80000d64:	40a787bb          	subw	a5,a5,a0
    80000d68:	41f7581b          	sraiw	a6,a4,0x1f
    80000d6c:	41f7d51b          	sraiw	a0,a5,0x1f
    80000d70:	00e84733          	xor	a4,a6,a4
    80000d74:	00f547b3          	xor	a5,a0,a5
    80000d78:	4107073b          	subw	a4,a4,a6
    80000d7c:	40a787bb          	subw	a5,a5,a0
    80000d80:	40f707bb          	subw	a5,a4,a5
    80000d84:	05314703          	lbu	a4,83(sp)
    80000d88:	05010513          	addi	a0,sp,80
    80000d8c:	00e787bb          	addw	a5,a5,a4
    80000d90:	04f109a3          	sb	a5,83(sp)
    80000d94:	00c687b3          	add	a5,a3,a2
    80000d98:	fcb78223          	sb	a1,-60(a5)
    80000d9c:	05214783          	lbu	a5,82(sp)
    80000da0:	fff7879b          	addiw	a5,a5,-1
    80000da4:	0ff7f793          	zext.b	a5,a5
    80000da8:	04f10923          	sb	a5,82(sp)
    80000dac:	00f687b3          	add	a5,a3,a5
    80000db0:	fc078223          	sb	zero,-60(a5)
    80000db4:	d80ff0ef          	jal	ra,80000334 <_ZN8N_puzzleILi4EE14determine_hashEv>
    80000db8:	e31ff06f          	j	80000be8 <bench_15pz_run+0x288>
    80000dbc:	02010593          	addi	a1,sp,32
    80000dc0:	05010513          	addi	a0,sp,80
    80000dc4:	cc0ff0ef          	jal	ra,80000284 <_ZN8N_puzzleILi4EEC1ERKS0_>
    80000dc8:	02114703          	lbu	a4,33(sp)
    80000dcc:	05371263          	bne	a4,s3,80000e10 <bench_15pz_run+0x4b0>
    80000dd0:	04010823          	sb	zero,80(sp)
    80000dd4:	05010593          	addi	a1,sp,80
    80000dd8:	03810513          	addi	a0,sp,56
    80000ddc:	ca8ff0ef          	jal	ra,80000284 <_ZN8N_puzzleILi4EEC1ERKS0_>
    80000de0:	02010593          	addi	a1,sp,32
    80000de4:	00040513          	mv	a0,s0
    80000de8:	865ff0ef          	jal	ra,8000064c <_ZNK14Updatable_heapI8N_puzzleILi4EEE6lengthERKS1_>
    80000dec:	0015061b          	addiw	a2,a0,1
    80000df0:	03810593          	addi	a1,sp,56
    80000df4:	00040513          	mv	a0,s0
    80000df8:	905ff0ef          	jal	ra,800006fc <_ZN14Updatable_heapI8N_puzzleILi4EEE4pushERKS1_i>
    80000dfc:	02014783          	lbu	a5,32(sp)
    80000e00:	ce0780e3          	beqz	a5,80000ae0 <bench_15pz_run+0x180>
    80000e04:	02114783          	lbu	a5,33(sp)
    80000e08:	cc078ce3          	beqz	a5,80000ae0 <bench_15pz_run+0x180>
    80000e0c:	e69ff06f          	j	80000c74 <bench_15pz_run+0x314>
    80000e10:	00170793          	addi	a5,a4,1
    80000e14:	02214583          	lbu	a1,34(sp)
    80000e18:	00279793          	slli	a5,a5,0x2
    80000e1c:	09078793          	addi	a5,a5,144
    80000e20:	002787b3          	add	a5,a5,sp
    80000e24:	00b787b3          	add	a5,a5,a1
    80000e28:	f9478783          	lb	a5,-108(a5)
    80000e2c:	0017081b          	addiw	a6,a4,1
    80000e30:	fff7869b          	addiw	a3,a5,-1
    80000e34:	0346c6bb          	divw	a3,a3,s4
    80000e38:	40e6863b          	subw	a2,a3,a4
    80000e3c:	41f6551b          	sraiw	a0,a2,0x1f
    80000e40:	410686bb          	subw	a3,a3,a6
    80000e44:	00c54633          	xor	a2,a0,a2
    80000e48:	40a6063b          	subw	a2,a2,a0
    80000e4c:	41f6d51b          	sraiw	a0,a3,0x1f
    80000e50:	00d546b3          	xor	a3,a0,a3
    80000e54:	40a686bb          	subw	a3,a3,a0
    80000e58:	40d606bb          	subw	a3,a2,a3
    80000e5c:	05314603          	lbu	a2,83(sp)
    80000e60:	00271713          	slli	a4,a4,0x2
    80000e64:	09070713          	addi	a4,a4,144
    80000e68:	00c686bb          	addw	a3,a3,a2
    80000e6c:	00270733          	add	a4,a4,sp
    80000e70:	04d109a3          	sb	a3,83(sp)
    80000e74:	00b70733          	add	a4,a4,a1
    80000e78:	fcf70223          	sb	a5,-60(a4)
    80000e7c:	05114783          	lbu	a5,81(sp)
    80000e80:	05010513          	addi	a0,sp,80
    80000e84:	0017879b          	addiw	a5,a5,1
    80000e88:	0ff7f793          	zext.b	a5,a5
    80000e8c:	04f108a3          	sb	a5,81(sp)
    80000e90:	00279793          	slli	a5,a5,0x2
    80000e94:	09078793          	addi	a5,a5,144
    80000e98:	002787b3          	add	a5,a5,sp
    80000e9c:	00b787b3          	add	a5,a5,a1
    80000ea0:	fc078223          	sb	zero,-60(a5)
    80000ea4:	c90ff0ef          	jal	ra,80000334 <_ZN8N_puzzleILi4EE14determine_hashEv>
    80000ea8:	f2dff06f          	j	80000dd4 <bench_15pz_run+0x474>
    80000eac:	fff6879b          	addiw	a5,a3,-1
    80000eb0:	02214583          	lbu	a1,34(sp)
    80000eb4:	00078513          	mv	a0,a5
    80000eb8:	00279793          	slli	a5,a5,0x2
    80000ebc:	09078793          	addi	a5,a5,144
    80000ec0:	002787b3          	add	a5,a5,sp
    80000ec4:	00b787b3          	add	a5,a5,a1
    80000ec8:	f9478783          	lb	a5,-108(a5)
    80000ecc:	fff7871b          	addiw	a4,a5,-1
    80000ed0:	0347473b          	divw	a4,a4,s4
    80000ed4:	40d7063b          	subw	a2,a4,a3
    80000ed8:	40a7073b          	subw	a4,a4,a0
    80000edc:	41f6581b          	sraiw	a6,a2,0x1f
    80000ee0:	41f7551b          	sraiw	a0,a4,0x1f
    80000ee4:	00c84633          	xor	a2,a6,a2
    80000ee8:	00e54733          	xor	a4,a0,a4
    80000eec:	4106063b          	subw	a2,a2,a6
    80000ef0:	40a7073b          	subw	a4,a4,a0
    80000ef4:	40e6073b          	subw	a4,a2,a4
    80000ef8:	05314603          	lbu	a2,83(sp)
    80000efc:	00269693          	slli	a3,a3,0x2
    80000f00:	05010513          	addi	a0,sp,80
    80000f04:	00c7073b          	addw	a4,a4,a2
    80000f08:	04e109a3          	sb	a4,83(sp)
    80000f0c:	09068713          	addi	a4,a3,144
    80000f10:	002706b3          	add	a3,a4,sp
    80000f14:	00b686b3          	add	a3,a3,a1
    80000f18:	fcf68223          	sb	a5,-60(a3)
    80000f1c:	05114783          	lbu	a5,81(sp)
    80000f20:	fff7879b          	addiw	a5,a5,-1
    80000f24:	0ff7f793          	zext.b	a5,a5
    80000f28:	04f108a3          	sb	a5,81(sp)
    80000f2c:	00279793          	slli	a5,a5,0x2
    80000f30:	09078793          	addi	a5,a5,144
    80000f34:	002787b3          	add	a5,a5,sp
    80000f38:	00b787b3          	add	a5,a5,a1
    80000f3c:	fc078223          	sb	zero,-60(a5)
    80000f40:	bf4ff0ef          	jal	ra,80000334 <_ZN8N_puzzleILi4EE14determine_hashEv>
    80000f44:	d49ff06f          	j	80000c8c <bench_15pz_run+0x32c>

0000000080000f48 <_ZL9radixPassPiS_S_ii>:
    80000f48:	fd010113          	addi	sp,sp,-48
    80000f4c:	02813023          	sd	s0,32(sp)
    80000f50:	00050413          	mv	s0,a0
    80000f54:	0017051b          	addiw	a0,a4,1
    80000f58:	00251513          	slli	a0,a0,0x2
    80000f5c:	00913c23          	sd	s1,24(sp)
    80000f60:	01213823          	sd	s2,16(sp)
    80000f64:	01313423          	sd	s3,8(sp)
    80000f68:	01413023          	sd	s4,0(sp)
    80000f6c:	02113423          	sd	ra,40(sp)
    80000f70:	00058a13          	mv	s4,a1
    80000f74:	00060913          	mv	s2,a2
    80000f78:	00068993          	mv	s3,a3
    80000f7c:	00070493          	mv	s1,a4
    80000f80:	6f0010ef          	jal	ra,80002670 <bench_alloc>
    80000f84:	00000793          	li	a5,0
    80000f88:	0007871b          	sext.w	a4,a5
    80000f8c:	00e4cc63          	blt	s1,a4,80000fa4 <_ZL9radixPassPiS_S_ii+0x5c>
    80000f90:	00279713          	slli	a4,a5,0x2
    80000f94:	00e50733          	add	a4,a0,a4
    80000f98:	00072023          	sw	zero,0(a4)
    80000f9c:	00178793          	addi	a5,a5,1
    80000fa0:	fe9ff06f          	j	80000f88 <_ZL9radixPassPiS_S_ii+0x40>
    80000fa4:	00000713          	li	a4,0
    80000fa8:	0007079b          	sext.w	a5,a4
    80000fac:	0737c063          	blt	a5,s3,8000100c <_ZL9radixPassPiS_S_ii+0xc4>
    80000fb0:	00050793          	mv	a5,a0
    80000fb4:	00000693          	li	a3,0
    80000fb8:	00000713          	li	a4,0
    80000fbc:	08e4d263          	bge	s1,a4,80001040 <_ZL9radixPassPiS_S_ii+0xf8>
    80000fc0:	00040793          	mv	a5,s0
    80000fc4:	00000693          	li	a3,0
    80000fc8:	0936d863          	bge	a3,s3,80001058 <_ZL9radixPassPiS_S_ii+0x110>
    80000fcc:	0007a703          	lw	a4,0(a5)
    80000fd0:	0016869b          	addiw	a3,a3,1
    80000fd4:	00478793          	addi	a5,a5,4
    80000fd8:	00271713          	slli	a4,a4,0x2
    80000fdc:	00e90733          	add	a4,s2,a4
    80000fe0:	00072803          	lw	a6,0(a4)
    80000fe4:	00281813          	slli	a6,a6,0x2
    80000fe8:	01050833          	add	a6,a0,a6
    80000fec:	00082703          	lw	a4,0(a6)
    80000ff0:	0017061b          	addiw	a2,a4,1
    80000ff4:	00c82023          	sw	a2,0(a6)
    80000ff8:	ffc7a603          	lw	a2,-4(a5)
    80000ffc:	00271713          	slli	a4,a4,0x2
    80001000:	00ea0733          	add	a4,s4,a4
    80001004:	00c72023          	sw	a2,0(a4)
    80001008:	fc1ff06f          	j	80000fc8 <_ZL9radixPassPiS_S_ii+0x80>
    8000100c:	00271793          	slli	a5,a4,0x2
    80001010:	00f407b3          	add	a5,s0,a5
    80001014:	0007a783          	lw	a5,0(a5)
    80001018:	00170713          	addi	a4,a4,1
    8000101c:	00279793          	slli	a5,a5,0x2
    80001020:	00f907b3          	add	a5,s2,a5
    80001024:	0007a783          	lw	a5,0(a5)
    80001028:	00279793          	slli	a5,a5,0x2
    8000102c:	00f507b3          	add	a5,a0,a5
    80001030:	0007a683          	lw	a3,0(a5)
    80001034:	0016869b          	addiw	a3,a3,1
    80001038:	00d7a023          	sw	a3,0(a5)
    8000103c:	f6dff06f          	j	80000fa8 <_ZL9radixPassPiS_S_ii+0x60>
    80001040:	0007a603          	lw	a2,0(a5)
    80001044:	0017071b          	addiw	a4,a4,1
    80001048:	00d7a023          	sw	a3,0(a5)
    8000104c:	00c686bb          	addw	a3,a3,a2
    80001050:	00478793          	addi	a5,a5,4
    80001054:	f69ff06f          	j	80000fbc <_ZL9radixPassPiS_S_ii+0x74>
    80001058:	02813083          	ld	ra,40(sp)
    8000105c:	02013403          	ld	s0,32(sp)
    80001060:	01813483          	ld	s1,24(sp)
    80001064:	01013903          	ld	s2,16(sp)
    80001068:	00813983          	ld	s3,8(sp)
    8000106c:	00013a03          	ld	s4,0(sp)
    80001070:	03010113          	addi	sp,sp,48
    80001074:	00008067          	ret

0000000080001078 <_Z11suffixArrayPiS_ii>:
    80001078:	f8010113          	addi	sp,sp,-128
    8000107c:	00300793          	li	a5,3
    80001080:	06813823          	sd	s0,112(sp)
    80001084:	0026041b          	addiw	s0,a2,2
    80001088:	05513423          	sd	s5,72(sp)
    8000108c:	02f44abb          	divw	s5,s0,a5
    80001090:	03913423          	sd	s9,40(sp)
    80001094:	00160c9b          	addiw	s9,a2,1
    80001098:	03813823          	sd	s8,48(sp)
    8000109c:	06913423          	sd	s1,104(sp)
    800010a0:	00050493          	mv	s1,a0
    800010a4:	06113c23          	sd	ra,120(sp)
    800010a8:	07213023          	sd	s2,96(sp)
    800010ac:	05313c23          	sd	s3,88(sp)
    800010b0:	00060913          	mv	s2,a2
    800010b4:	00058993          	mv	s3,a1
    800010b8:	05413823          	sd	s4,80(sp)
    800010bc:	05613023          	sd	s6,64(sp)
    800010c0:	03713c23          	sd	s7,56(sp)
    800010c4:	03a13023          	sd	s10,32(sp)
    800010c8:	00068b93          	mv	s7,a3
    800010cc:	01b13c23          	sd	s11,24(sp)
    800010d0:	02fcccbb          	divw	s9,s9,a5
    800010d4:	02f647bb          	divw	a5,a2,a5
    800010d8:	01578c3b          	addw	s8,a5,s5
    800010dc:	003c079b          	addiw	a5,s8,3
    800010e0:	00279413          	slli	s0,a5,0x2
    800010e4:	00040513          	mv	a0,s0
    800010e8:	588010ef          	jal	ra,80002670 <bench_alloc>
    800010ec:	ffc40793          	addi	a5,s0,-4
    800010f0:	00f50733          	add	a4,a0,a5
    800010f4:	ff840d93          	addi	s11,s0,-8
    800010f8:	00072023          	sw	zero,0(a4)
    800010fc:	002c1d13          	slli	s10,s8,0x2
    80001100:	01b50733          	add	a4,a0,s11
    80001104:	00072023          	sw	zero,0(a4)
    80001108:	01a50733          	add	a4,a0,s10
    8000110c:	00072023          	sw	zero,0(a4)
    80001110:	00050a13          	mv	s4,a0
    80001114:	00040513          	mv	a0,s0
    80001118:	00f13423          	sd	a5,8(sp)
    8000111c:	554010ef          	jal	ra,80002670 <bench_alloc>
    80001120:	00813783          	ld	a5,8(sp)
    80001124:	01b50db3          	add	s11,a0,s11
    80001128:	01a50d33          	add	s10,a0,s10
    8000112c:	00f507b3          	add	a5,a0,a5
    80001130:	0007a023          	sw	zero,0(a5)
    80001134:	002a9413          	slli	s0,s5,0x2
    80001138:	000da023          	sw	zero,0(s11)
    8000113c:	000d2023          	sw	zero,0(s10)
    80001140:	00050b13          	mv	s6,a0
    80001144:	00040513          	mv	a0,s0
    80001148:	528010ef          	jal	ra,80002670 <bench_alloc>
    8000114c:	00050d13          	mv	s10,a0
    80001150:	00040513          	mv	a0,s0
    80001154:	51c010ef          	jal	ra,80002670 <bench_alloc>
    80001158:	419a85bb          	subw	a1,s5,s9
    8000115c:	00050413          	mv	s0,a0
    80001160:	00000693          	li	a3,0
    80001164:	00000713          	li	a4,0
    80001168:	012587bb          	addw	a5,a1,s2
    8000116c:	00300513          	li	a0,3
    80001170:	00058c93          	mv	s9,a1
    80001174:	02f75263          	bge	a4,a5,80001198 <_Z11suffixArrayPiS_ii+0x120>
    80001178:	02a7663b          	remw	a2,a4,a0
    8000117c:	00060a63          	beqz	a2,80001190 <_Z11suffixArrayPiS_ii+0x118>
    80001180:	00269613          	slli	a2,a3,0x2
    80001184:	00ca0633          	add	a2,s4,a2
    80001188:	00e62023          	sw	a4,0(a2)
    8000118c:	0016869b          	addiw	a3,a3,1
    80001190:	0017071b          	addiw	a4,a4,1
    80001194:	fddff06f          	j	80001170 <_Z11suffixArrayPiS_ii+0xf8>
    80001198:	000b8713          	mv	a4,s7
    8000119c:	000c0693          	mv	a3,s8
    800011a0:	00848613          	addi	a2,s1,8 # 4008 <__STACKSIZE__+0x8>
    800011a4:	000b0593          	mv	a1,s6
    800011a8:	000a0513          	mv	a0,s4
    800011ac:	d9dff0ef          	jal	ra,80000f48 <_ZL9radixPassPiS_S_ii>
    800011b0:	000b8713          	mv	a4,s7
    800011b4:	000c0693          	mv	a3,s8
    800011b8:	00448613          	addi	a2,s1,4
    800011bc:	000a0593          	mv	a1,s4
    800011c0:	000b0513          	mv	a0,s6
    800011c4:	d85ff0ef          	jal	ra,80000f48 <_ZL9radixPassPiS_S_ii>
    800011c8:	000b8713          	mv	a4,s7
    800011cc:	000c0693          	mv	a3,s8
    800011d0:	000b0593          	mv	a1,s6
    800011d4:	000a0513          	mv	a0,s4
    800011d8:	00048613          	mv	a2,s1
    800011dc:	d6dff0ef          	jal	ra,80000f48 <_ZL9radixPassPiS_S_ii>
    800011e0:	00000593          	li	a1,0
    800011e4:	fff00e93          	li	t4,-1
    800011e8:	fff00713          	li	a4,-1
    800011ec:	fff00513          	li	a0,-1
    800011f0:	00000693          	li	a3,0
    800011f4:	00300813          	li	a6,3
    800011f8:	00100893          	li	a7,1
    800011fc:	0005879b          	sext.w	a5,a1
    80001200:	0787d663          	bge	a5,s8,8000126c <_Z11suffixArrayPiS_ii+0x1f4>
    80001204:	00259793          	slli	a5,a1,0x2
    80001208:	00fb07b3          	add	a5,s6,a5
    8000120c:	0007a603          	lw	a2,0(a5)
    80001210:	00261793          	slli	a5,a2,0x2
    80001214:	00f487b3          	add	a5,s1,a5
    80001218:	0007af03          	lw	t5,0(a5)
    8000121c:	0047a303          	lw	t1,4(a5)
    80001220:	0087ae03          	lw	t3,8(a5)
    80001224:	00af1663          	bne	t5,a0,80001230 <_Z11suffixArrayPiS_ii+0x1b8>
    80001228:	00671463          	bne	a4,t1,80001230 <_Z11suffixArrayPiS_ii+0x1b8>
    8000122c:	01ce8663          	beq	t4,t3,80001238 <_Z11suffixArrayPiS_ii+0x1c0>
    80001230:	0016869b          	addiw	a3,a3,1
    80001234:	000f0513          	mv	a0,t5
    80001238:	0306473b          	divw	a4,a2,a6
    8000123c:	0306663b          	remw	a2,a2,a6
    80001240:	03161063          	bne	a2,a7,80001260 <_Z11suffixArrayPiS_ii+0x1e8>
    80001244:	00271793          	slli	a5,a4,0x2
    80001248:	00fa07b3          	add	a5,s4,a5
    8000124c:	00d7a023          	sw	a3,0(a5)
    80001250:	00158593          	addi	a1,a1,1
    80001254:	000e0e93          	mv	t4,t3
    80001258:	00030713          	mv	a4,t1
    8000125c:	fa1ff06f          	j	800011fc <_Z11suffixArrayPiS_ii+0x184>
    80001260:	015707bb          	addw	a5,a4,s5
    80001264:	00279793          	slli	a5,a5,0x2
    80001268:	fe1ff06f          	j	80001248 <_Z11suffixArrayPiS_ii+0x1d0>
    8000126c:	00000713          	li	a4,0
    80001270:	0786dc63          	bge	a3,s8,800012e8 <_Z11suffixArrayPiS_ii+0x270>
    80001274:	000c0613          	mv	a2,s8
    80001278:	000b0593          	mv	a1,s6
    8000127c:	000a0513          	mv	a0,s4
    80001280:	df9ff0ef          	jal	ra,80001078 <_Z11suffixArrayPiS_ii>
    80001284:	000b0693          	mv	a3,s6
    80001288:	00000713          	li	a4,0
    8000128c:	0006a783          	lw	a5,0(a3)
    80001290:	0017071b          	addiw	a4,a4,1
    80001294:	00468693          	addi	a3,a3,4
    80001298:	00279793          	slli	a5,a5,0x2
    8000129c:	00fa07b3          	add	a5,s4,a5
    800012a0:	00e7a023          	sw	a4,0(a5)
    800012a4:	ff8714e3          	bne	a4,s8,8000128c <_Z11suffixArrayPiS_ii+0x214>
    800012a8:	00000793          	li	a5,0
    800012ac:	00000693          	li	a3,0
    800012b0:	00300593          	li	a1,3
    800012b4:	0007871b          	sext.w	a4,a5
    800012b8:	05875c63          	bge	a4,s8,80001310 <_Z11suffixArrayPiS_ii+0x298>
    800012bc:	00279713          	slli	a4,a5,0x2
    800012c0:	00eb0733          	add	a4,s6,a4
    800012c4:	00072703          	lw	a4,0(a4)
    800012c8:	01575c63          	bge	a4,s5,800012e0 <_Z11suffixArrayPiS_ii+0x268>
    800012cc:	02e5873b          	mulw	a4,a1,a4
    800012d0:	00269613          	slli	a2,a3,0x2
    800012d4:	00cd0633          	add	a2,s10,a2
    800012d8:	0016869b          	addiw	a3,a3,1
    800012dc:	00e62023          	sw	a4,0(a2)
    800012e0:	00178793          	addi	a5,a5,1
    800012e4:	fd1ff06f          	j	800012b4 <_Z11suffixArrayPiS_ii+0x23c>
    800012e8:	0007069b          	sext.w	a3,a4
    800012ec:	fb86dee3          	bge	a3,s8,800012a8 <_Z11suffixArrayPiS_ii+0x230>
    800012f0:	00271793          	slli	a5,a4,0x2
    800012f4:	00fa07b3          	add	a5,s4,a5
    800012f8:	0007a783          	lw	a5,0(a5)
    800012fc:	00170713          	addi	a4,a4,1
    80001300:	00279793          	slli	a5,a5,0x2
    80001304:	00fb07b3          	add	a5,s6,a5
    80001308:	fed7ae23          	sw	a3,-4(a5)
    8000130c:	fddff06f          	j	800012e8 <_Z11suffixArrayPiS_ii+0x270>
    80001310:	000a8693          	mv	a3,s5
    80001314:	00048613          	mv	a2,s1
    80001318:	000b8713          	mv	a4,s7
    8000131c:	00040593          	mv	a1,s0
    80001320:	000d0513          	mv	a0,s10
    80001324:	c25ff0ef          	jal	ra,80000f48 <_ZL9radixPassPiS_S_ii>
    80001328:	00000693          	li	a3,0
    8000132c:	00000613          	li	a2,0
    80001330:	00300813          	li	a6,3
    80001334:	1926dc63          	bge	a3,s2,800014cc <_Z11suffixArrayPiS_ii+0x454>
    80001338:	002c9793          	slli	a5,s9,0x2
    8000133c:	00fb07b3          	add	a5,s6,a5
    80001340:	0007a783          	lw	a5,0(a5)
    80001344:	000c8893          	mv	a7,s9
    80001348:	0b57d263          	bge	a5,s5,800013ec <_Z11suffixArrayPiS_ii+0x374>
    8000134c:	02f805bb          	mulw	a1,a6,a5
    80001350:	0015859b          	addiw	a1,a1,1
    80001354:	00261713          	slli	a4,a2,0x2
    80001358:	00e40733          	add	a4,s0,a4
    8000135c:	00072f83          	lw	t6,0(a4)
    80001360:	00259b93          	slli	s7,a1,0x2
    80001364:	01748bb3          	add	s7,s1,s7
    80001368:	030fc3bb          	divw	t2,t6,a6
    8000136c:	002f9f13          	slli	t5,t6,0x2
    80001370:	01e48f33          	add	t5,s1,t5
    80001374:	000bae03          	lw	t3,0(s7)
    80001378:	000f2e83          	lw	t4,0(t5)
    8000137c:	00060313          	mv	t1,a2
    80001380:	00269713          	slli	a4,a3,0x2
    80001384:	0016829b          	addiw	t0,a3,1
    80001388:	00038513          	mv	a0,t2
    8000138c:	0757d863          	bge	a5,s5,800013fc <_Z11suffixArrayPiS_ii+0x384>
    80001390:	0157853b          	addw	a0,a5,s5
    80001394:	00251513          	slli	a0,a0,0x2
    80001398:	00239793          	slli	a5,t2,0x2
    8000139c:	00aa0533          	add	a0,s4,a0
    800013a0:	00fa07b3          	add	a5,s4,a5
    800013a4:	00052503          	lw	a0,0(a0)
    800013a8:	0007a783          	lw	a5,0(a5)
    800013ac:	09de4863          	blt	t3,t4,8000143c <_Z11suffixArrayPiS_ii+0x3c4>
    800013b0:	01ce9463          	bne	t4,t3,800013b8 <_Z11suffixArrayPiS_ii+0x340>
    800013b4:	08a7d463          	bge	a5,a0,8000143c <_Z11suffixArrayPiS_ii+0x3c4>
    800013b8:	00e987b3          	add	a5,s3,a4
    800013bc:	01f7a023          	sw	t6,0(a5)
    800013c0:	0016061b          	addiw	a2,a2,1
    800013c4:	0aca9663          	bne	s5,a2,80001470 <_Z11suffixArrayPiS_ii+0x3f8>
    800013c8:	00470713          	addi	a4,a4,4
    800013cc:	00e98733          	add	a4,s3,a4
    800013d0:	0008879b          	sext.w	a5,a7
    800013d4:	0d87c063          	blt	a5,s8,80001494 <_Z11suffixArrayPiS_ii+0x41c>
    800013d8:	00000693          	li	a3,0
    800013dc:	019c4463          	blt	s8,s9,800013e4 <_Z11suffixArrayPiS_ii+0x36c>
    800013e0:	419c06bb          	subw	a3,s8,s9
    800013e4:	01968cbb          	addw	s9,a3,s9
    800013e8:	0840006f          	j	8000146c <_Z11suffixArrayPiS_ii+0x3f4>
    800013ec:	415785bb          	subw	a1,a5,s5
    800013f0:	030585bb          	mulw	a1,a1,a6
    800013f4:	0025859b          	addiw	a1,a1,2
    800013f8:	f5dff06f          	j	80001354 <_Z11suffixArrayPiS_ii+0x2dc>
    800013fc:	415787bb          	subw	a5,a5,s5
    80001400:	00178793          	addi	a5,a5,1
    80001404:	0155053b          	addw	a0,a0,s5
    80001408:	00279793          	slli	a5,a5,0x2
    8000140c:	00251513          	slli	a0,a0,0x2
    80001410:	00fa07b3          	add	a5,s4,a5
    80001414:	00aa0533          	add	a0,s4,a0
    80001418:	004ba383          	lw	t2,4(s7)
    8000141c:	0007a783          	lw	a5,0(a5)
    80001420:	004f2f03          	lw	t5,4(t5)
    80001424:	00052503          	lw	a0,0(a0)
    80001428:	01de4a63          	blt	t3,t4,8000143c <_Z11suffixArrayPiS_ii+0x3c4>
    8000142c:	f9ce96e3          	bne	t4,t3,800013b8 <_Z11suffixArrayPiS_ii+0x340>
    80001430:	01e3c663          	blt	t2,t5,8000143c <_Z11suffixArrayPiS_ii+0x3c4>
    80001434:	f9e392e3          	bne	t2,t5,800013b8 <_Z11suffixArrayPiS_ii+0x340>
    80001438:	f8f540e3          	blt	a0,a5,800013b8 <_Z11suffixArrayPiS_ii+0x340>
    8000143c:	00e987b3          	add	a5,s3,a4
    80001440:	00b7a023          	sw	a1,0(a5)
    80001444:	001c8c9b          	addiw	s9,s9,1
    80001448:	039c1463          	bne	s8,s9,80001470 <_Z11suffixArrayPiS_ii+0x3f8>
    8000144c:	00470713          	addi	a4,a4,4
    80001450:	00e98733          	add	a4,s3,a4
    80001454:	0003079b          	sext.w	a5,t1
    80001458:	0357c063          	blt	a5,s5,80001478 <_Z11suffixArrayPiS_ii+0x400>
    8000145c:	00000693          	li	a3,0
    80001460:	00cac463          	blt	s5,a2,80001468 <_Z11suffixArrayPiS_ii+0x3f0>
    80001464:	40ca86bb          	subw	a3,s5,a2
    80001468:	00c6863b          	addw	a2,a3,a2
    8000146c:	00d286bb          	addw	a3,t0,a3
    80001470:	0016869b          	addiw	a3,a3,1
    80001474:	ec1ff06f          	j	80001334 <_Z11suffixArrayPiS_ii+0x2bc>
    80001478:	00231793          	slli	a5,t1,0x2
    8000147c:	00f407b3          	add	a5,s0,a5
    80001480:	0007a783          	lw	a5,0(a5)
    80001484:	00130313          	addi	t1,t1,1
    80001488:	00470713          	addi	a4,a4,4
    8000148c:	fef72e23          	sw	a5,-4(a4)
    80001490:	fc5ff06f          	j	80001454 <_Z11suffixArrayPiS_ii+0x3dc>
    80001494:	00289793          	slli	a5,a7,0x2
    80001498:	00fb07b3          	add	a5,s6,a5
    8000149c:	0007a783          	lw	a5,0(a5)
    800014a0:	0157de63          	bge	a5,s5,800014bc <_Z11suffixArrayPiS_ii+0x444>
    800014a4:	02f807bb          	mulw	a5,a6,a5
    800014a8:	0017879b          	addiw	a5,a5,1
    800014ac:	00f72023          	sw	a5,0(a4)
    800014b0:	00188893          	addi	a7,a7,1
    800014b4:	00470713          	addi	a4,a4,4
    800014b8:	f19ff06f          	j	800013d0 <_Z11suffixArrayPiS_ii+0x358>
    800014bc:	415787bb          	subw	a5,a5,s5
    800014c0:	030787bb          	mulw	a5,a5,a6
    800014c4:	0027879b          	addiw	a5,a5,2
    800014c8:	fe5ff06f          	j	800014ac <_Z11suffixArrayPiS_ii+0x434>
    800014cc:	07813083          	ld	ra,120(sp)
    800014d0:	07013403          	ld	s0,112(sp)
    800014d4:	06813483          	ld	s1,104(sp)
    800014d8:	06013903          	ld	s2,96(sp)
    800014dc:	05813983          	ld	s3,88(sp)
    800014e0:	05013a03          	ld	s4,80(sp)
    800014e4:	04813a83          	ld	s5,72(sp)
    800014e8:	04013b03          	ld	s6,64(sp)
    800014ec:	03813b83          	ld	s7,56(sp)
    800014f0:	03013c03          	ld	s8,48(sp)
    800014f4:	02813c83          	ld	s9,40(sp)
    800014f8:	02013d03          	ld	s10,32(sp)
    800014fc:	01813d83          	ld	s11,24(sp)
    80001500:	08010113          	addi	sp,sp,128
    80001504:	00008067          	ret

0000000080001508 <bench_ssort_prepare>:
    80001508:	0001c797          	auipc	a5,0x1c
    8000150c:	3187b783          	ld	a5,792(a5) # 8001d820 <setting>
    80001510:	0007a783          	lw	a5,0(a5)
    80001514:	fd010113          	addi	sp,sp,-48
    80001518:	00913c23          	sd	s1,24(sp)
    8000151c:	00100513          	li	a0,1
    80001520:	0001c497          	auipc	s1,0x1c
    80001524:	2a448493          	addi	s1,s1,676 # 8001d7c4 <_ZL1N>
    80001528:	00f4a023          	sw	a5,0(s1)
    8000152c:	02113423          	sd	ra,40(sp)
    80001530:	02813023          	sd	s0,32(sp)
    80001534:	01213823          	sd	s2,16(sp)
    80001538:	01313423          	sd	s3,8(sp)
    8000153c:	16c010ef          	jal	ra,800026a8 <bench_srand>
    80001540:	0004a503          	lw	a0,0(s1)
    80001544:	0001c917          	auipc	s2,0x1c
    80001548:	28490913          	addi	s2,s2,644 # 8001d7c8 <_ZL1s>
    8000154c:	00000413          	li	s0,0
    80001550:	00a5051b          	addiw	a0,a0,10
    80001554:	00251513          	slli	a0,a0,0x2
    80001558:	118010ef          	jal	ra,80002670 <bench_alloc>
    8000155c:	00a93023          	sd	a0,0(s2)
    80001560:	0004a503          	lw	a0,0(s1)
    80001564:	01a00993          	li	s3,26
    80001568:	00a5051b          	addiw	a0,a0,10
    8000156c:	00251513          	slli	a0,a0,0x2
    80001570:	100010ef          	jal	ra,80002670 <bench_alloc>
    80001574:	0001c797          	auipc	a5,0x1c
    80001578:	24a7be23          	sd	a0,604(a5) # 8001d7d0 <_ZL2sa>
    8000157c:	0004a703          	lw	a4,0(s1)
    80001580:	0004079b          	sext.w	a5,s0
    80001584:	02e7d263          	bge	a5,a4,800015a8 <bench_ssort_prepare+0xa0>
    80001588:	134010ef          	jal	ra,800026bc <bench_rand>
    8000158c:	0335753b          	remuw	a0,a0,s3
    80001590:	00093783          	ld	a5,0(s2)
    80001594:	00241713          	slli	a4,s0,0x2
    80001598:	00140413          	addi	s0,s0,1
    8000159c:	00e787b3          	add	a5,a5,a4
    800015a0:	00a7a023          	sw	a0,0(a5)
    800015a4:	fd9ff06f          	j	8000157c <bench_ssort_prepare+0x74>
    800015a8:	02813083          	ld	ra,40(sp)
    800015ac:	02013403          	ld	s0,32(sp)
    800015b0:	01813483          	ld	s1,24(sp)
    800015b4:	01013903          	ld	s2,16(sp)
    800015b8:	00813983          	ld	s3,8(sp)
    800015bc:	03010113          	addi	sp,sp,48
    800015c0:	00008067          	ret

00000000800015c4 <bench_ssort_run>:
    800015c4:	01a00693          	li	a3,26
    800015c8:	0001c617          	auipc	a2,0x1c
    800015cc:	1fc62603          	lw	a2,508(a2) # 8001d7c4 <_ZL1N>
    800015d0:	0001c597          	auipc	a1,0x1c
    800015d4:	2005b583          	ld	a1,512(a1) # 8001d7d0 <_ZL2sa>
    800015d8:	0001c517          	auipc	a0,0x1c
    800015dc:	1f053503          	ld	a0,496(a0) # 8001d7c8 <_ZL1s>
    800015e0:	a99ff06f          	j	80001078 <_Z11suffixArrayPiS_ii>

00000000800015e4 <bench_ssort_validate>:
    800015e4:	0001c597          	auipc	a1,0x1c
    800015e8:	1e05a583          	lw	a1,480(a1) # 8001d7c4 <_ZL1N>
    800015ec:	0001c517          	auipc	a0,0x1c
    800015f0:	1e453503          	ld	a0,484(a0) # 8001d7d0 <_ZL2sa>
    800015f4:	00259593          	slli	a1,a1,0x2
    800015f8:	ff010113          	addi	sp,sp,-16
    800015fc:	00b505b3          	add	a1,a0,a1
    80001600:	00113423          	sd	ra,8(sp)
    80001604:	0ec010ef          	jal	ra,800026f0 <checksum>
    80001608:	0001c717          	auipc	a4,0x1c
    8000160c:	21873703          	ld	a4,536(a4) # 8001d820 <setting>
    80001610:	0005079b          	sext.w	a5,a0
    80001614:	01872503          	lw	a0,24(a4)
    80001618:	00813083          	ld	ra,8(sp)
    8000161c:	40f50533          	sub	a0,a0,a5
    80001620:	00153513          	seqz	a0,a0
    80001624:	01010113          	addi	sp,sp,16
    80001628:	00008067          	ret

000000008000162c <assign>:
    8000162c:	0001c697          	auipc	a3,0x1c
    80001630:	1b46a683          	lw	a3,436(a3) # 8001d7e0 <M>
    80001634:	00269893          	slli	a7,a3,0x2
    80001638:	00000613          	li	a2,0
    8000163c:	00000713          	li	a4,0
    80001640:	00d74463          	blt	a4,a3,80001648 <assign+0x1c>
    80001644:	00008067          	ret
    80001648:	00060793          	mv	a5,a2
    8000164c:	00000813          	li	a6,0
    80001650:	00f58333          	add	t1,a1,a5
    80001654:	00032e03          	lw	t3,0(t1)
    80001658:	00f50333          	add	t1,a0,a5
    8000165c:	0018081b          	addiw	a6,a6,1
    80001660:	01c32023          	sw	t3,0(t1)
    80001664:	00478793          	addi	a5,a5,4
    80001668:	ff0694e3          	bne	a3,a6,80001650 <assign+0x24>
    8000166c:	0017071b          	addiw	a4,a4,1
    80001670:	01160633          	add	a2,a2,a7
    80001674:	fcdff06f          	j	80001640 <assign+0x14>

0000000080001678 <mult>:
    80001678:	0001c697          	auipc	a3,0x1c
    8000167c:	1686a683          	lw	a3,360(a3) # 8001d7e0 <M>
    80001680:	00269293          	slli	t0,a3,0x2
    80001684:	00000813          	li	a6,0
    80001688:	00000313          	li	t1,0
    8000168c:	00d34463          	blt	t1,a3,80001694 <mult+0x1c>
    80001690:	00008067          	ret
    80001694:	010507b3          	add	a5,a0,a6
    80001698:	00000893          	li	a7,0
    8000169c:	00289713          	slli	a4,a7,0x2
    800016a0:	0007a023          	sw	zero,0(a5)
    800016a4:	01058eb3          	add	t4,a1,a6
    800016a8:	00e60733          	add	a4,a2,a4
    800016ac:	00000e13          	li	t3,0
    800016b0:	00072f03          	lw	t5,0(a4)
    800016b4:	000eaf83          	lw	t6,0(t4)
    800016b8:	001e0e1b          	addiw	t3,t3,1
    800016bc:	004e8e93          	addi	t4,t4,4
    800016c0:	03ff0fbb          	mulw	t6,t5,t6
    800016c4:	0007af03          	lw	t5,0(a5)
    800016c8:	00570733          	add	a4,a4,t0
    800016cc:	01ff0f3b          	addw	t5,t5,t6
    800016d0:	01e7a023          	sw	t5,0(a5)
    800016d4:	fdc69ee3          	bne	a3,t3,800016b0 <mult+0x38>
    800016d8:	00188893          	addi	a7,a7,1
    800016dc:	0008871b          	sext.w	a4,a7
    800016e0:	00478793          	addi	a5,a5,4
    800016e4:	fad74ce3          	blt	a4,a3,8000169c <mult+0x24>
    800016e8:	0013031b          	addiw	t1,t1,1
    800016ec:	00580833          	add	a6,a6,t0
    800016f0:	f9dff06f          	j	8000168c <mult+0x14>

00000000800016f4 <bench_fib_prepare>:
    800016f4:	ff010113          	addi	sp,sp,-16
    800016f8:	0001c797          	auipc	a5,0x1c
    800016fc:	1287b783          	ld	a5,296(a5) # 8001d820 <setting>
    80001700:	00813023          	sd	s0,0(sp)
    80001704:	0007a403          	lw	s0,0(a5)
    80001708:	00113423          	sd	ra,8(sp)
    8000170c:	0001c797          	auipc	a5,0x1c
    80001710:	0c87aa23          	sw	s0,212(a5) # 8001d7e0 <M>
    80001714:	0284043b          	mulw	s0,s0,s0
    80001718:	0024141b          	slliw	s0,s0,0x2
    8000171c:	00040513          	mv	a0,s0
    80001720:	751000ef          	jal	ra,80002670 <bench_alloc>
    80001724:	0001c797          	auipc	a5,0x1c
    80001728:	0aa7ba23          	sd	a0,180(a5) # 8001d7d8 <A>
    8000172c:	00040513          	mv	a0,s0
    80001730:	741000ef          	jal	ra,80002670 <bench_alloc>
    80001734:	0001c797          	auipc	a5,0x1c
    80001738:	0aa7ba23          	sd	a0,180(a5) # 8001d7e8 <T>
    8000173c:	00040513          	mv	a0,s0
    80001740:	731000ef          	jal	ra,80002670 <bench_alloc>
    80001744:	0001c797          	auipc	a5,0x1c
    80001748:	0aa7b623          	sd	a0,172(a5) # 8001d7f0 <ans>
    8000174c:	00040513          	mv	a0,s0
    80001750:	721000ef          	jal	ra,80002670 <bench_alloc>
    80001754:	00813083          	ld	ra,8(sp)
    80001758:	00013403          	ld	s0,0(sp)
    8000175c:	0001c797          	auipc	a5,0x1c
    80001760:	08a7be23          	sd	a0,156(a5) # 8001d7f8 <tmp>
    80001764:	01010113          	addi	sp,sp,16
    80001768:	00008067          	ret

000000008000176c <bench_fib_run>:
    8000176c:	fc010113          	addi	sp,sp,-64
    80001770:	0001c597          	auipc	a1,0x1c
    80001774:	0705a583          	lw	a1,112(a1) # 8001d7e0 <M>
    80001778:	02913423          	sd	s1,40(sp)
    8000177c:	01313c23          	sd	s3,24(sp)
    80001780:	02113c23          	sd	ra,56(sp)
    80001784:	02813823          	sd	s0,48(sp)
    80001788:	03213023          	sd	s2,32(sp)
    8000178c:	01413823          	sd	s4,16(sp)
    80001790:	01513423          	sd	s5,8(sp)
    80001794:	0001c817          	auipc	a6,0x1c
    80001798:	04483803          	ld	a6,68(a6) # 8001d7d8 <A>
    8000179c:	0001c497          	auipc	s1,0x1c
    800017a0:	04c4b483          	ld	s1,76(s1) # 8001d7e8 <T>
    800017a4:	0001c997          	auipc	s3,0x1c
    800017a8:	04c9b983          	ld	s3,76(s3) # 8001d7f0 <ans>
    800017ac:	00259893          	slli	a7,a1,0x2
    800017b0:	00000513          	li	a0,0
    800017b4:	00000713          	li	a4,0
    800017b8:	fff5831b          	addiw	t1,a1,-1
    800017bc:	08b74663          	blt	a4,a1,80001848 <bench_fib_run+0xdc>
    800017c0:	80000437          	lui	s0,0x80000
    800017c4:	01f00a13          	li	s4,31
    800017c8:	fd344413          	xori	s0,s0,-45
    800017cc:	0001ca97          	auipc	s5,0x1c
    800017d0:	02ca8a93          	addi	s5,s5,44 # 8001d7f8 <tmp>
    800017d4:	00147793          	andi	a5,s0,1
    800017d8:	000ab903          	ld	s2,0(s5)
    800017dc:	02078063          	beqz	a5,800017fc <bench_fib_run+0x90>
    800017e0:	00098593          	mv	a1,s3
    800017e4:	00090513          	mv	a0,s2
    800017e8:	00048613          	mv	a2,s1
    800017ec:	e8dff0ef          	jal	ra,80001678 <mult>
    800017f0:	00090593          	mv	a1,s2
    800017f4:	00098513          	mv	a0,s3
    800017f8:	e35ff0ef          	jal	ra,8000162c <assign>
    800017fc:	00048613          	mv	a2,s1
    80001800:	00048593          	mv	a1,s1
    80001804:	00090513          	mv	a0,s2
    80001808:	e71ff0ef          	jal	ra,80001678 <mult>
    8000180c:	00090593          	mv	a1,s2
    80001810:	00048513          	mv	a0,s1
    80001814:	fffa0a1b          	addiw	s4,s4,-1
    80001818:	e15ff0ef          	jal	ra,8000162c <assign>
    8000181c:	40145413          	srai	s0,s0,0x1
    80001820:	fa0a1ae3          	bnez	s4,800017d4 <bench_fib_run+0x68>
    80001824:	03813083          	ld	ra,56(sp)
    80001828:	03013403          	ld	s0,48(sp)
    8000182c:	02813483          	ld	s1,40(sp)
    80001830:	02013903          	ld	s2,32(sp)
    80001834:	01813983          	ld	s3,24(sp)
    80001838:	01013a03          	ld	s4,16(sp)
    8000183c:	00813a83          	ld	s5,8(sp)
    80001840:	04010113          	addi	sp,sp,64
    80001844:	00008067          	ret
    80001848:	00050613          	mv	a2,a0
    8000184c:	00000693          	li	a3,0
    80001850:	00170e9b          	addiw	t4,a4,1
    80001854:	00100793          	li	a5,1
    80001858:	00e30663          	beq	t1,a4,80001864 <bench_fib_run+0xf8>
    8000185c:	40de87b3          	sub	a5,t4,a3
    80001860:	0017b793          	seqz	a5,a5
    80001864:	0007879b          	sext.w	a5,a5
    80001868:	00c80e33          	add	t3,a6,a2
    8000186c:	00fe2023          	sw	a5,0(t3)
    80001870:	00c48e33          	add	t3,s1,a2
    80001874:	00fe2023          	sw	a5,0(t3)
    80001878:	40d707b3          	sub	a5,a4,a3
    8000187c:	00c98e33          	add	t3,s3,a2
    80001880:	0017b793          	seqz	a5,a5
    80001884:	00fe2023          	sw	a5,0(t3)
    80001888:	0016869b          	addiw	a3,a3,1
    8000188c:	00460613          	addi	a2,a2,4
    80001890:	fcd592e3          	bne	a1,a3,80001854 <bench_fib_run+0xe8>
    80001894:	0017071b          	addiw	a4,a4,1
    80001898:	01150533          	add	a0,a0,a7
    8000189c:	f21ff06f          	j	800017bc <bench_fib_run+0x50>

00000000800018a0 <bench_fib_validate>:
    800018a0:	0001c797          	auipc	a5,0x1c
    800018a4:	f407a783          	lw	a5,-192(a5) # 8001d7e0 <M>
    800018a8:	fff7871b          	addiw	a4,a5,-1
    800018ac:	02e787bb          	mulw	a5,a5,a4
    800018b0:	00e787bb          	addw	a5,a5,a4
    800018b4:	00279793          	slli	a5,a5,0x2
    800018b8:	0001c717          	auipc	a4,0x1c
    800018bc:	f3873703          	ld	a4,-200(a4) # 8001d7f0 <ans>
    800018c0:	00f707b3          	add	a5,a4,a5
    800018c4:	0007a503          	lw	a0,0(a5)
    800018c8:	0001c797          	auipc	a5,0x1c
    800018cc:	f587b783          	ld	a5,-168(a5) # 8001d820 <setting>
    800018d0:	0187a783          	lw	a5,24(a5)
    800018d4:	40f50533          	sub	a0,a0,a5
    800018d8:	00153513          	seqz	a0,a0
    800018dc:	00008067          	ret

00000000800018e0 <fast_write>:
    800018e0:	ff010113          	addi	sp,sp,-16
    800018e4:	00a12623          	sw	a0,12(sp)
    800018e8:	00000793          	li	a5,0
    800018ec:	00c10693          	addi	a3,sp,12
    800018f0:	00f686b3          	add	a3,a3,a5
    800018f4:	0006c683          	lbu	a3,0(a3)
    800018f8:	00f58733          	add	a4,a1,a5
    800018fc:	00178793          	addi	a5,a5,1
    80001900:	00d70023          	sb	a3,0(a4)
    80001904:	fef614e3          	bne	a2,a5,800018ec <fast_write+0xc>
    80001908:	01010113          	addi	sp,sp,16
    8000190c:	00008067          	ret

0000000080001910 <fast_read.part.0>:
    80001910:	00050693          	mv	a3,a0
    80001914:	00000793          	li	a5,0
    80001918:	00000513          	li	a0,0
    8000191c:	00f68733          	add	a4,a3,a5
    80001920:	00074703          	lbu	a4,0(a4)
    80001924:	0037961b          	slliw	a2,a5,0x3
    80001928:	00178793          	addi	a5,a5,1
    8000192c:	00c7173b          	sllw	a4,a4,a2
    80001930:	00e56533          	or	a0,a0,a4
    80001934:	0007871b          	sext.w	a4,a5
    80001938:	0005051b          	sext.w	a0,a0
    8000193c:	feb760e3          	bltu	a4,a1,8000191c <fast_read.part.0+0xc>
    80001940:	00008067          	ret

0000000080001944 <bench_memcpy.isra.0>:
    80001944:	00c586b3          	add	a3,a1,a2
    80001948:	04d57863          	bgeu	a0,a3,80001998 <bench_memcpy.isra.0+0x54>
    8000194c:	04a5f663          	bgeu	a1,a0,80001998 <bench_memcpy.isra.0+0x54>
    80001950:	fff64593          	not	a1,a2
    80001954:	00000793          	li	a5,0
    80001958:	fff78793          	addi	a5,a5,-1
    8000195c:	00b79463          	bne	a5,a1,80001964 <bench_memcpy.isra.0+0x20>
    80001960:	00008067          	ret
    80001964:	00f68733          	add	a4,a3,a5
    80001968:	00074803          	lbu	a6,0(a4)
    8000196c:	00f60733          	add	a4,a2,a5
    80001970:	00e50733          	add	a4,a0,a4
    80001974:	01070023          	sb	a6,0(a4)
    80001978:	fe1ff06f          	j	80001958 <bench_memcpy.isra.0+0x14>
    8000197c:	00f58733          	add	a4,a1,a5
    80001980:	00074683          	lbu	a3,0(a4)
    80001984:	00f50733          	add	a4,a0,a5
    80001988:	00178793          	addi	a5,a5,1
    8000198c:	00d70023          	sb	a3,0(a4)
    80001990:	fef616e3          	bne	a2,a5,8000197c <bench_memcpy.isra.0+0x38>
    80001994:	00008067          	ret
    80001998:	00000793          	li	a5,0
    8000199c:	ff5ff06f          	j	80001990 <bench_memcpy.isra.0+0x4c>

00000000800019a0 <qlz_compress>:
    800019a0:	00100793          	li	a5,1
    800019a4:	f1010113          	addi	sp,sp,-240
    800019a8:	02079793          	slli	a5,a5,0x20
    800019ac:	0b513c23          	sd	s5,184(sp)
    800019b0:	0e113423          	sd	ra,232(sp)
    800019b4:	0e813023          	sd	s0,224(sp)
    800019b8:	0c913c23          	sd	s1,216(sp)
    800019bc:	0d213823          	sd	s2,208(sp)
    800019c0:	0d313423          	sd	s3,200(sp)
    800019c4:	0d413023          	sd	s4,192(sp)
    800019c8:	0b613823          	sd	s6,176(sp)
    800019cc:	0b713423          	sd	s7,168(sp)
    800019d0:	0b813023          	sd	s8,160(sp)
    800019d4:	09913c23          	sd	s9,152(sp)
    800019d8:	09a13823          	sd	s10,144(sp)
    800019dc:	09b13423          	sd	s11,136(sp)
    800019e0:	fff60a93          	addi	s5,a2,-1
    800019e4:	e6e78793          	addi	a5,a5,-402
    800019e8:	5357e463          	bltu	a5,s5,80001f10 <qlz_compress+0x570>
    800019ec:	0d700793          	li	a5,215
    800019f0:	00050a13          	mv	s4,a0
    800019f4:	00058493          	mv	s1,a1
    800019f8:	00060913          	mv	s2,a2
    800019fc:	00068413          	mv	s0,a3
    80001a00:	00300993          	li	s3,3
    80001a04:	00c7f463          	bgeu	a5,a2,80001a0c <qlz_compress+0x6c>
    80001a08:	00900993          	li	s3,9
    80001a0c:	000107b7          	lui	a5,0x10
    80001a10:	00011737          	lui	a4,0x11
    80001a14:	00878793          	addi	a5,a5,8 # 10008 <__STACKSIZE__+0xc008>
    80001a18:	80870713          	addi	a4,a4,-2040 # 10808 <__STACKSIZE__+0xc808>
    80001a1c:	00f407b3          	add	a5,s0,a5
    80001a20:	00e40733          	add	a4,s0,a4
    80001a24:	00078023          	sb	zero,0(a5)
    80001a28:	00178793          	addi	a5,a5,1
    80001a2c:	fef71ce3          	bne	a4,a5,80001a24 <qlz_compress+0x84>
    80001a30:	015a07b3          	add	a5,s4,s5
    80001a34:	00f13423          	sd	a5,8(sp)
    80001a38:	00195713          	srli	a4,s2,0x1
    80001a3c:	ff678793          	addi	a5,a5,-10
    80001a40:	02f13023          	sd	a5,32(sp)
    80001a44:	00ea07b3          	add	a5,s4,a4
    80001a48:	02f13423          	sd	a5,40(sp)
    80001a4c:	00813783          	ld	a5,8(sp)
    80001a50:	01000cb7          	lui	s9,0x1000
    80001a54:	01348bb3          	add	s7,s1,s3
    80001a58:	ffc78793          	addi	a5,a5,-4
    80001a5c:	04f13423          	sd	a5,72(sp)
    80001a60:	fffc8793          	addi	a5,s9,-1 # ffffff <__STACKSIZE__+0xffbfff>
    80001a64:	004b8d93          	addi	s11,s7,4
    80001a68:	000b8c13          	mv	s8,s7
    80001a6c:	000a0a93          	mv	s5,s4
    80001a70:	80000d37          	lui	s10,0x80000
    80001a74:	00f13c23          	sd	a5,24(sp)
    80001a78:	02013783          	ld	a5,32(sp)
    80001a7c:	001d7613          	andi	a2,s10,1
    80001a80:	0d57fa63          	bgeu	a5,s5,80001b54 <qlz_compress+0x1b4>
    80001a84:	00813783          	ld	a5,8(sp)
    80001a88:	00010b37          	lui	s6,0x10
    80001a8c:	ffd78c93          	addi	s9,a5,-3
    80001a90:	00813783          	ld	a5,8(sp)
    80001a94:	001d7613          	andi	a2,s10,1
    80001a98:	3b57f863          	bgeu	a5,s5,80001e48 <qlz_compress+0x4a8>
    80001a9c:	001d7693          	andi	a3,s10,1
    80001aa0:	001d5d1b          	srliw	s10,s10,0x1
    80001aa4:	fe068ce3          	beqz	a3,80001a9c <qlz_compress+0xfc>
    80001aa8:	80000537          	lui	a0,0x80000
    80001aac:	00400613          	li	a2,4
    80001ab0:	000c0593          	mv	a1,s8
    80001ab4:	00ad6533          	or	a0,s10,a0
    80001ab8:	e29ff0ef          	jal	ra,800018e0 <fast_write>
    80001abc:	417d87b3          	sub	a5,s11,s7
    80001ac0:	00900713          	li	a4,9
    80001ac4:	00998a93          	addi	s5,s3,9
    80001ac8:	40e7ca63          	blt	a5,a4,80001edc <qlz_compress+0x53c>
    80001acc:	00f98ab3          	add	s5,s3,a5
    80001ad0:	41599663          	bne	s3,s5,80001edc <qlz_compress+0x53c>
    80001ad4:	00090613          	mv	a2,s2
    80001ad8:	000a0593          	mv	a1,s4
    80001adc:	000b8513          	mv	a0,s7
    80001ae0:	e65ff0ef          	jal	ra,80001944 <bench_memcpy.isra.0>
    80001ae4:	01298ab3          	add	s5,s3,s2
    80001ae8:	00000793          	li	a5,0
    80001aec:	00043023          	sd	zero,0(s0) # ffffffff80000000 <__bss_end+0xfffffffefffd9440>
    80001af0:	00300713          	li	a4,3
    80001af4:	0ff7f793          	zext.b	a5,a5
    80001af8:	3ee99663          	bne	s3,a4,80001ee4 <qlz_compress+0x544>
    80001afc:	00f48023          	sb	a5,0(s1)
    80001b00:	015480a3          	sb	s5,1(s1)
    80001b04:	01248123          	sb	s2,2(s1)
    80001b08:	0004c783          	lbu	a5,0(s1)
    80001b0c:	0487e793          	ori	a5,a5,72
    80001b10:	00f48023          	sb	a5,0(s1)
    80001b14:	0e813083          	ld	ra,232(sp)
    80001b18:	0e013403          	ld	s0,224(sp)
    80001b1c:	0d813483          	ld	s1,216(sp)
    80001b20:	0d013903          	ld	s2,208(sp)
    80001b24:	0c813983          	ld	s3,200(sp)
    80001b28:	0c013a03          	ld	s4,192(sp)
    80001b2c:	0b013b03          	ld	s6,176(sp)
    80001b30:	0a813b83          	ld	s7,168(sp)
    80001b34:	0a013c03          	ld	s8,160(sp)
    80001b38:	09813c83          	ld	s9,152(sp)
    80001b3c:	09013d03          	ld	s10,144(sp)
    80001b40:	08813d83          	ld	s11,136(sp)
    80001b44:	000a8513          	mv	a0,s5
    80001b48:	0b813a83          	ld	s5,184(sp)
    80001b4c:	0f010113          	addi	sp,sp,240
    80001b50:	00008067          	ret
    80001b54:	04060463          	beqz	a2,80001b9c <qlz_compress+0x1fc>
    80001b58:	02813783          	ld	a5,40(sp)
    80001b5c:	0157fc63          	bgeu	a5,s5,80001b74 <qlz_compress+0x1d4>
    80001b60:	414a8633          	sub	a2,s5,s4
    80001b64:	40565513          	srai	a0,a2,0x5
    80001b68:	417d85b3          	sub	a1,s11,s7
    80001b6c:	40a60633          	sub	a2,a2,a0
    80001b70:	f6b642e3          	blt	a2,a1,80001ad4 <qlz_compress+0x134>
    80001b74:	001d551b          	srliw	a0,s10,0x1
    80001b78:	800007b7          	lui	a5,0x80000
    80001b7c:	00f56533          	or	a0,a0,a5
    80001b80:	000c0593          	mv	a1,s8
    80001b84:	00400613          	li	a2,4
    80001b88:	0005051b          	sext.w	a0,a0
    80001b8c:	000d8c13          	mv	s8,s11
    80001b90:	d51ff0ef          	jal	ra,800018e0 <fast_write>
    80001b94:	004d8d93          	addi	s11,s11,4
    80001b98:	80000d37          	lui	s10,0x80000
    80001b9c:	04813783          	ld	a5,72(sp)
    80001ba0:	41578b33          	sub	s6,a5,s5
    80001ba4:	0fe00793          	li	a5,254
    80001ba8:	0167d463          	bge	a5,s6,80001bb0 <qlz_compress+0x210>
    80001bac:	0fe00b13          	li	s6,254
    80001bb0:	001b0793          	addi	a5,s6,1 # 10001 <__STACKSIZE__+0xc001>
    80001bb4:	00300593          	li	a1,3
    80001bb8:	000a8513          	mv	a0,s5
    80001bbc:	00f13823          	sd	a5,16(sp)
    80001bc0:	d51ff0ef          	jal	ra,80001910 <fast_read.part.0>
    80001bc4:	00050f9b          	sext.w	t6,a0
    80001bc8:	0095581b          	srliw	a6,a0,0x9
    80001bcc:	00d5551b          	srliw	a0,a0,0xd
    80001bd0:	00a84833          	xor	a6,a6,a0
    80001bd4:	01f84833          	xor	a6,a6,t6
    80001bd8:	7ff87793          	andi	a5,a6,2047
    80001bdc:	00078c93          	mv	s9,a5
    80001be0:	00f40633          	add	a2,s0,a5
    80001be4:	02f13c23          	sd	a5,56(sp)
    80001be8:	000107b7          	lui	a5,0x10
    80001bec:	00c78633          	add	a2,a5,a2
    80001bf0:	00864b03          	lbu	s6,8(a2)
    80001bf4:	005c9613          	slli	a2,s9,0x5
    80001bf8:	00c40633          	add	a2,s0,a2
    80001bfc:	00863883          	ld	a7,8(a2)
    80001c00:	ffea8793          	addi	a5,s5,-2
    80001c04:	02f13823          	sd	a5,48(sp)
    80001c08:	1ef8fc63          	bgeu	a7,a5,80001e00 <qlz_compress+0x460>
    80001c0c:	05f13823          	sd	t6,80(sp)
    80001c10:	1e0b0c63          	beqz	s6,80001e08 <qlz_compress+0x468>
    80001c14:	00300593          	li	a1,3
    80001c18:	00088513          	mv	a0,a7
    80001c1c:	05113023          	sd	a7,64(sp)
    80001c20:	cf1ff0ef          	jal	ra,80001910 <fast_read.part.0>
    80001c24:	05013f83          	ld	t6,80(sp)
    80001c28:	01813783          	ld	a5,24(sp)
    80001c2c:	0005051b          	sext.w	a0,a0
    80001c30:	00afc533          	xor	a0,t6,a0
    80001c34:	00f57533          	and	a0,a0,a5
    80001c38:	00000613          	li	a2,0
    80001c3c:	00051c63          	bnez	a0,80001c54 <qlz_compress+0x2b4>
    80001c40:	04013883          	ld	a7,64(sp)
    80001c44:	003ac603          	lbu	a2,3(s5)
    80001c48:	0038c583          	lbu	a1,3(a7)
    80001c4c:	0cc58e63          	beq	a1,a2,80001d28 <qlz_compress+0x388>
    80001c50:	00300613          	li	a2,3
    80001c54:	005c9e93          	slli	t4,s9,0x5
    80001c58:	000b079b          	sext.w	a5,s6
    80001c5c:	01d40eb3          	add	t4,s0,t4
    80001c60:	00000893          	li	a7,0
    80001c64:	00100e13          	li	t3,1
    80001c68:	04f13023          	sd	a5,64(sp)
    80001c6c:	00400293          	li	t0,4
    80001c70:	04013783          	ld	a5,64(sp)
    80001c74:	0efe7e63          	bgeu	t3,a5,80001d70 <qlz_compress+0x3d0>
    80001c78:	010ebf03          	ld	t5,16(t4)
    80001c7c:	02061593          	slli	a1,a2,0x20
    80001c80:	0205d593          	srli	a1,a1,0x20
    80001c84:	00ba8533          	add	a0,s5,a1
    80001c88:	00bf05b3          	add	a1,t5,a1
    80001c8c:	00054503          	lbu	a0,0(a0) # ffffffff80000000 <__bss_end+0xfffffffefffd9440>
    80001c90:	0005c583          	lbu	a1,0(a1)
    80001c94:	0cb51863          	bne	a0,a1,80001d64 <qlz_compress+0x3c4>
    80001c98:	00300593          	li	a1,3
    80001c9c:	000f0513          	mv	a0,t5
    80001ca0:	07d13c23          	sd	t4,120(sp)
    80001ca4:	07113823          	sd	a7,112(sp)
    80001ca8:	06c13423          	sd	a2,104(sp)
    80001cac:	07c13023          	sd	t3,96(sp)
    80001cb0:	05f13c23          	sd	t6,88(sp)
    80001cb4:	05e13823          	sd	t5,80(sp)
    80001cb8:	c59ff0ef          	jal	ra,80001910 <fast_read.part.0>
    80001cbc:	05813f83          	ld	t6,88(sp)
    80001cc0:	01813783          	ld	a5,24(sp)
    80001cc4:	0005051b          	sext.w	a0,a0
    80001cc8:	00afc533          	xor	a0,t6,a0
    80001ccc:	00f57533          	and	a0,a0,a5
    80001cd0:	06013e03          	ld	t3,96(sp)
    80001cd4:	06813603          	ld	a2,104(sp)
    80001cd8:	07013883          	ld	a7,112(sp)
    80001cdc:	07813e83          	ld	t4,120(sp)
    80001ce0:	00400293          	li	t0,4
    80001ce4:	08051063          	bnez	a0,80001d64 <qlz_compress+0x3c4>
    80001ce8:	03013783          	ld	a5,48(sp)
    80001cec:	05013f03          	ld	t5,80(sp)
    80001cf0:	06ff7a63          	bgeu	t5,a5,80001d64 <qlz_compress+0x3c4>
    80001cf4:	00300593          	li	a1,3
    80001cf8:	03c0006f          	j	80001d34 <qlz_compress+0x394>
    80001cfc:	0016061b          	addiw	a2,a2,1
    80001d00:	02061593          	slli	a1,a2,0x20
    80001d04:	0205d593          	srli	a1,a1,0x20
    80001d08:	00b88e33          	add	t3,a7,a1
    80001d0c:	00ba8533          	add	a0,s5,a1
    80001d10:	000e4e03          	lbu	t3,0(t3)
    80001d14:	00054503          	lbu	a0,0(a0)
    80001d18:	f2ae1ee3          	bne	t3,a0,80001c54 <qlz_compress+0x2b4>
    80001d1c:	01013783          	ld	a5,16(sp)
    80001d20:	fcf5eee3          	bltu	a1,a5,80001cfc <qlz_compress+0x35c>
    80001d24:	f31ff06f          	j	80001c54 <qlz_compress+0x2b4>
    80001d28:	00400613          	li	a2,4
    80001d2c:	fd5ff06f          	j	80001d00 <qlz_compress+0x360>
    80001d30:	0015859b          	addiw	a1,a1,1
    80001d34:	02059513          	slli	a0,a1,0x20
    80001d38:	02055513          	srli	a0,a0,0x20
    80001d3c:	00af00b3          	add	ra,t5,a0
    80001d40:	00aa83b3          	add	t2,s5,a0
    80001d44:	0000c083          	lbu	ra,0(ra)
    80001d48:	0003c383          	lbu	t2,0(t2)
    80001d4c:	00709663          	bne	ra,t2,80001d58 <qlz_compress+0x3b8>
    80001d50:	01013783          	ld	a5,16(sp)
    80001d54:	fcf56ee3          	bltu	a0,a5,80001d30 <qlz_compress+0x390>
    80001d58:	00b67663          	bgeu	a2,a1,80001d64 <qlz_compress+0x3c4>
    80001d5c:	000e0893          	mv	a7,t3
    80001d60:	00058613          	mv	a2,a1
    80001d64:	001e0e1b          	addiw	t3,t3,1
    80001d68:	008e8e93          	addi	t4,t4,8
    80001d6c:	f05e12e3          	bne	t3,t0,80001c70 <qlz_compress+0x2d0>
    80001d70:	003b7513          	andi	a0,s6,3
    80001d74:	002c9593          	slli	a1,s9,0x2
    80001d78:	00a585b3          	add	a1,a1,a0
    80001d7c:	00359593          	slli	a1,a1,0x3
    80001d80:	00b405b3          	add	a1,s0,a1
    80001d84:	01940833          	add	a6,s0,s9
    80001d88:	000107b7          	lui	a5,0x10
    80001d8c:	0155b423          	sd	s5,8(a1)
    80001d90:	01078833          	add	a6,a5,a6
    80001d94:	001b031b          	addiw	t1,s6,1
    80001d98:	001d559b          	srliw	a1,s10,0x1
    80001d9c:	00680423          	sb	t1,8(a6)
    80001da0:	00200513          	li	a0,2
    80001da4:	00058d1b          	sext.w	s10,a1
    80001da8:	08c57663          	bgeu	a0,a2,80001e34 <qlz_compress+0x494>
    80001dac:	800007b7          	lui	a5,0x80000
    80001db0:	00f5e733          	or	a4,a1,a5
    80001db4:	03813783          	ld	a5,56(sp)
    80001db8:	02061593          	slli	a1,a2,0x20
    80001dbc:	0205d593          	srli	a1,a1,0x20
    80001dc0:	0057951b          	slliw	a0,a5,0x5
    80001dc4:	00ba8ab3          	add	s5,s5,a1
    80001dc8:	00a8e533          	or	a0,a7,a0
    80001dcc:	00900593          	li	a1,9
    80001dd0:	00070d1b          	sext.w	s10,a4
    80001dd4:	0005051b          	sext.w	a0,a0
    80001dd8:	02c5ee63          	bltu	a1,a2,80001e14 <qlz_compress+0x474>
    80001ddc:	ffe6061b          	addiw	a2,a2,-2
    80001de0:	0026161b          	slliw	a2,a2,0x2
    80001de4:	00c56533          	or	a0,a0,a2
    80001de8:	000d8593          	mv	a1,s11
    80001dec:	00200613          	li	a2,2
    80001df0:	0005051b          	sext.w	a0,a0
    80001df4:	aedff0ef          	jal	ra,800018e0 <fast_write>
    80001df8:	002d8d93          	addi	s11,s11,2
    80001dfc:	c7dff06f          	j	80001a78 <qlz_compress+0xd8>
    80001e00:	00000613          	li	a2,0
    80001e04:	e51ff06f          	j	80001c54 <qlz_compress+0x2b4>
    80001e08:	00000893          	li	a7,0
    80001e0c:	00000613          	li	a2,0
    80001e10:	f61ff06f          	j	80001d70 <qlz_compress+0x3d0>
    80001e14:	0106161b          	slliw	a2,a2,0x10
    80001e18:	00c56533          	or	a0,a0,a2
    80001e1c:	000d8593          	mv	a1,s11
    80001e20:	00300613          	li	a2,3
    80001e24:	0005051b          	sext.w	a0,a0
    80001e28:	ab9ff0ef          	jal	ra,800018e0 <fast_write>
    80001e2c:	003d8d93          	addi	s11,s11,3
    80001e30:	c49ff06f          	j	80001a78 <qlz_compress+0xd8>
    80001e34:	000ac603          	lbu	a2,0(s5)
    80001e38:	001d8d93          	addi	s11,s11,1
    80001e3c:	001a8a93          	addi	s5,s5,1
    80001e40:	fecd8fa3          	sb	a2,-1(s11)
    80001e44:	c35ff06f          	j	80001a78 <qlz_compress+0xd8>
    80001e48:	02060663          	beqz	a2,80001e74 <qlz_compress+0x4d4>
    80001e4c:	001d551b          	srliw	a0,s10,0x1
    80001e50:	800007b7          	lui	a5,0x80000
    80001e54:	00f56533          	or	a0,a0,a5
    80001e58:	000c0593          	mv	a1,s8
    80001e5c:	00400613          	li	a2,4
    80001e60:	0005051b          	sext.w	a0,a0
    80001e64:	000d8c13          	mv	s8,s11
    80001e68:	a79ff0ef          	jal	ra,800018e0 <fast_write>
    80001e6c:	004d8d93          	addi	s11,s11,4
    80001e70:	80000d37          	lui	s10,0x80000
    80001e74:	055ce863          	bltu	s9,s5,80001ec4 <qlz_compress+0x524>
    80001e78:	00300593          	li	a1,3
    80001e7c:	000a8513          	mv	a0,s5
    80001e80:	a91ff0ef          	jal	ra,80001910 <fast_read.part.0>
    80001e84:	00d5559b          	srliw	a1,a0,0xd
    80001e88:	0095561b          	srliw	a2,a0,0x9
    80001e8c:	00b64633          	xor	a2,a2,a1
    80001e90:	00c54533          	xor	a0,a0,a2
    80001e94:	7ff57513          	andi	a0,a0,2047
    80001e98:	00a40633          	add	a2,s0,a0
    80001e9c:	00cb0633          	add	a2,s6,a2
    80001ea0:	00864583          	lbu	a1,8(a2)
    80001ea4:	00251513          	slli	a0,a0,0x2
    80001ea8:	0035f813          	andi	a6,a1,3
    80001eac:	01050533          	add	a0,a0,a6
    80001eb0:	00351513          	slli	a0,a0,0x3
    80001eb4:	00a40533          	add	a0,s0,a0
    80001eb8:	01553423          	sd	s5,8(a0)
    80001ebc:	0015859b          	addiw	a1,a1,1
    80001ec0:	00b60423          	sb	a1,8(a2)
    80001ec4:	000ac603          	lbu	a2,0(s5)
    80001ec8:	001d8d93          	addi	s11,s11,1
    80001ecc:	001a8a93          	addi	s5,s5,1
    80001ed0:	fecd8fa3          	sb	a2,-1(s11)
    80001ed4:	001d5d1b          	srliw	s10,s10,0x1
    80001ed8:	bb9ff06f          	j	80001a90 <qlz_compress+0xf0>
    80001edc:	00100793          	li	a5,1
    80001ee0:	c0dff06f          	j	80001aec <qlz_compress+0x14c>
    80001ee4:	0027e793          	ori	a5,a5,2
    80001ee8:	00148593          	addi	a1,s1,1
    80001eec:	000a851b          	sext.w	a0,s5
    80001ef0:	00f48023          	sb	a5,0(s1)
    80001ef4:	00400613          	li	a2,4
    80001ef8:	9e9ff0ef          	jal	ra,800018e0 <fast_write>
    80001efc:	00400613          	li	a2,4
    80001f00:	00548593          	addi	a1,s1,5
    80001f04:	0009051b          	sext.w	a0,s2
    80001f08:	9d9ff0ef          	jal	ra,800018e0 <fast_write>
    80001f0c:	bfdff06f          	j	80001b08 <qlz_compress+0x168>
    80001f10:	00000a93          	li	s5,0
    80001f14:	c01ff06f          	j	80001b14 <qlz_compress+0x174>

0000000080001f18 <to_bytes>:
    80001f18:	0085579b          	srliw	a5,a0,0x8
    80001f1c:	00a58023          	sb	a0,0(a1)
    80001f20:	00f580a3          	sb	a5,1(a1)
    80001f24:	0105579b          	srliw	a5,a0,0x10
    80001f28:	0185551b          	srliw	a0,a0,0x18
    80001f2c:	00f58123          	sb	a5,2(a1)
    80001f30:	00a581a3          	sb	a0,3(a1)
    80001f34:	00008067          	ret

0000000080001f38 <bench_md5_prepare>:
    80001f38:	0001c797          	auipc	a5,0x1c
    80001f3c:	8e87b783          	ld	a5,-1816(a5) # 8001d820 <setting>
    80001f40:	0007a783          	lw	a5,0(a5)
    80001f44:	fe010113          	addi	sp,sp,-32
    80001f48:	00913423          	sd	s1,8(sp)
    80001f4c:	00100513          	li	a0,1
    80001f50:	0001c497          	auipc	s1,0x1c
    80001f54:	8b048493          	addi	s1,s1,-1872 # 8001d800 <N>
    80001f58:	00113c23          	sd	ra,24(sp)
    80001f5c:	00813823          	sd	s0,16(sp)
    80001f60:	01213023          	sd	s2,0(sp)
    80001f64:	00f4a023          	sw	a5,0(s1)
    80001f68:	740000ef          	jal	ra,800026a8 <bench_srand>
    80001f6c:	0004a503          	lw	a0,0(s1)
    80001f70:	0001c917          	auipc	s2,0x1c
    80001f74:	8a090913          	addi	s2,s2,-1888 # 8001d810 <str>
    80001f78:	00000413          	li	s0,0
    80001f7c:	6f4000ef          	jal	ra,80002670 <bench_alloc>
    80001f80:	00a93023          	sd	a0,0(s2)
    80001f84:	0004a703          	lw	a4,0(s1)
    80001f88:	0004079b          	sext.w	a5,s0
    80001f8c:	02e7c663          	blt	a5,a4,80001fb8 <bench_md5_prepare+0x80>
    80001f90:	01000513          	li	a0,16
    80001f94:	6dc000ef          	jal	ra,80002670 <bench_alloc>
    80001f98:	01813083          	ld	ra,24(sp)
    80001f9c:	01013403          	ld	s0,16(sp)
    80001fa0:	0001c797          	auipc	a5,0x1c
    80001fa4:	86a7b423          	sd	a0,-1944(a5) # 8001d808 <digest>
    80001fa8:	00813483          	ld	s1,8(sp)
    80001fac:	00013903          	ld	s2,0(sp)
    80001fb0:	02010113          	addi	sp,sp,32
    80001fb4:	00008067          	ret
    80001fb8:	704000ef          	jal	ra,800026bc <bench_rand>
    80001fbc:	00093783          	ld	a5,0(s2)
    80001fc0:	008787b3          	add	a5,a5,s0
    80001fc4:	00a78023          	sb	a0,0(a5)
    80001fc8:	00140413          	addi	s0,s0,1
    80001fcc:	fb9ff06f          	j	80001f84 <bench_md5_prepare+0x4c>

0000000080001fd0 <bench_md5_run>:
    80001fd0:	f7010113          	addi	sp,sp,-144
    80001fd4:	07213823          	sd	s2,112(sp)
    80001fd8:	0001c917          	auipc	s2,0x1c
    80001fdc:	82892903          	lw	s2,-2008(s2) # 8001d800 <N>
    80001fe0:	08813023          	sd	s0,128(sp)
    80001fe4:	06913c23          	sd	s1,120(sp)
    80001fe8:	05513c23          	sd	s5,88(sp)
    80001fec:	08113423          	sd	ra,136(sp)
    80001ff0:	07313423          	sd	s3,104(sp)
    80001ff4:	07413023          	sd	s4,96(sp)
    80001ff8:	05613823          	sd	s6,80(sp)
    80001ffc:	05713423          	sd	s7,72(sp)
    80002000:	05813023          	sd	s8,64(sp)
    80002004:	0001ca97          	auipc	s5,0x1c
    80002008:	80caba83          	ld	s5,-2036(s5) # 8001d810 <str>
    8000200c:	0001b497          	auipc	s1,0x1b
    80002010:	7fc4b483          	ld	s1,2044(s1) # 8001d808 <digest>
    80002014:	00190413          	addi	s0,s2,1
    80002018:	03800793          	li	a5,56
    8000201c:	03f47713          	andi	a4,s0,63
    80002020:	1cf71063          	bne	a4,a5,800021e0 <bench_md5_run+0x210>
    80002024:	012a87b3          	add	a5,s5,s2
    80002028:	f8000713          	li	a4,-128
    8000202c:	00e78023          	sb	a4,0(a5)
    80002030:	00090793          	mv	a5,s2
    80002034:	00178793          	addi	a5,a5,1
    80002038:	1a87e863          	bltu	a5,s0,800021e8 <bench_md5_run+0x218>
    8000203c:	0039151b          	slliw	a0,s2,0x3
    80002040:	008a85b3          	add	a1,s5,s0
    80002044:	ed5ff0ef          	jal	ra,80001f18 <to_bytes>
    80002048:	00440593          	addi	a1,s0,4
    8000204c:	41d95513          	srai	a0,s2,0x1d
    80002050:	00ba85b3          	add	a1,s5,a1
    80002054:	ec5ff0ef          	jal	ra,80001f18 <to_bytes>
    80002058:	10325937          	lui	s2,0x10325
    8000205c:	98bae9b7          	lui	s3,0x98bae
    80002060:	efcdba37          	lui	s4,0xefcdb
    80002064:	67452537          	lui	a0,0x67452
    80002068:	47690913          	addi	s2,s2,1142 # 10325476 <__STACKSIZE__+0x10321476>
    8000206c:	cfe98993          	addi	s3,s3,-770 # ffffffff98badcfe <__bss_end+0xffffffff18b8713e>
    80002070:	b89a0a13          	addi	s4,s4,-1143 # ffffffffefcdab89 <__bss_end+0xffffffff6fcb3fc9>
    80002074:	30150513          	addi	a0,a0,769 # 67452301 <__STACKSIZE__+0x6744e301>
    80002078:	00000893          	li	a7,0
    8000207c:	04000e93          	li	t4,64
    80002080:	00f00f93          	li	t6,15
    80002084:	01f00293          	li	t0,31
    80002088:	02f00393          	li	t2,47
    8000208c:	00700093          	li	ra,7
    80002090:	00300b13          	li	s6,3
    80002094:	00500b93          	li	s7,5
    80002098:	00000793          	li	a5,0
    8000209c:	011a85b3          	add	a1,s5,a7
    800020a0:	00f58633          	add	a2,a1,a5
    800020a4:	00164683          	lbu	a3,1(a2)
    800020a8:	00064703          	lbu	a4,0(a2)
    800020ac:	00f10833          	add	a6,sp,a5
    800020b0:	00869693          	slli	a3,a3,0x8
    800020b4:	00e6e6b3          	or	a3,a3,a4
    800020b8:	00264703          	lbu	a4,2(a2)
    800020bc:	00478793          	addi	a5,a5,4
    800020c0:	01071713          	slli	a4,a4,0x10
    800020c4:	00d766b3          	or	a3,a4,a3
    800020c8:	00364703          	lbu	a4,3(a2)
    800020cc:	01871713          	slli	a4,a4,0x18
    800020d0:	00d76733          	or	a4,a4,a3
    800020d4:	00e82023          	sw	a4,0(a6)
    800020d8:	fdd794e3          	bne	a5,t4,800020a0 <bench_md5_run+0xd0>
    800020dc:	0000ee17          	auipc	t3,0xe
    800020e0:	32ce0e13          	addi	t3,t3,812 # 80010408 <k>
    800020e4:	0000e317          	auipc	t1,0xe
    800020e8:	42430313          	addi	t1,t1,1060 # 80010508 <r>
    800020ec:	00050f13          	mv	t5,a0
    800020f0:	000a0613          	mv	a2,s4
    800020f4:	00090813          	mv	a6,s2
    800020f8:	00098693          	mv	a3,s3
    800020fc:	00000593          	li	a1,0
    80002100:	10bfe263          	bltu	t6,a1,80002204 <bench_md5_run+0x234>
    80002104:	0106c7b3          	xor	a5,a3,a6
    80002108:	00c7f7b3          	and	a5,a5,a2
    8000210c:	00f847b3          	xor	a5,a6,a5
    80002110:	0007879b          	sext.w	a5,a5
    80002114:	00058713          	mv	a4,a1
    80002118:	02071713          	slli	a4,a4,0x20
    8000211c:	01e75713          	srli	a4,a4,0x1e
    80002120:	04070713          	addi	a4,a4,64
    80002124:	000e2c03          	lw	s8,0(t3)
    80002128:	00270733          	add	a4,a4,sp
    8000212c:	fc072703          	lw	a4,-64(a4)
    80002130:	00fc07bb          	addw	a5,s8,a5
    80002134:	0015859b          	addiw	a1,a1,1
    80002138:	00e787bb          	addw	a5,a5,a4
    8000213c:	00032703          	lw	a4,0(t1)
    80002140:	01e78f3b          	addw	t5,a5,t5
    80002144:	004e0e13          	addi	t3,t3,4
    80002148:	00ef17bb          	sllw	a5,t5,a4
    8000214c:	40e0073b          	negw	a4,a4
    80002150:	00ef5f3b          	srlw	t5,t5,a4
    80002154:	01e7ef33          	or	t5,a5,t5
    80002158:	00cf07bb          	addw	a5,t5,a2
    8000215c:	00430313          	addi	t1,t1,4
    80002160:	0006061b          	sext.w	a2,a2
    80002164:	0006869b          	sext.w	a3,a3
    80002168:	00080f1b          	sext.w	t5,a6
    8000216c:	09d59463          	bne	a1,t4,800021f4 <bench_md5_run+0x224>
    80002170:	04088893          	addi	a7,a7,64
    80002174:	00a8053b          	addw	a0,a6,a0
    80002178:	01478a3b          	addw	s4,a5,s4
    8000217c:	013609bb          	addw	s3,a2,s3
    80002180:	0126893b          	addw	s2,a3,s2
    80002184:	f088eae3          	bltu	a7,s0,80002098 <bench_md5_run+0xc8>
    80002188:	00048593          	mv	a1,s1
    8000218c:	d8dff0ef          	jal	ra,80001f18 <to_bytes>
    80002190:	00448593          	addi	a1,s1,4
    80002194:	000a0513          	mv	a0,s4
    80002198:	d81ff0ef          	jal	ra,80001f18 <to_bytes>
    8000219c:	00848593          	addi	a1,s1,8
    800021a0:	00098513          	mv	a0,s3
    800021a4:	d75ff0ef          	jal	ra,80001f18 <to_bytes>
    800021a8:	08013403          	ld	s0,128(sp)
    800021ac:	08813083          	ld	ra,136(sp)
    800021b0:	06813983          	ld	s3,104(sp)
    800021b4:	06013a03          	ld	s4,96(sp)
    800021b8:	05813a83          	ld	s5,88(sp)
    800021bc:	05013b03          	ld	s6,80(sp)
    800021c0:	04813b83          	ld	s7,72(sp)
    800021c4:	04013c03          	ld	s8,64(sp)
    800021c8:	00c48593          	addi	a1,s1,12
    800021cc:	00090513          	mv	a0,s2
    800021d0:	07813483          	ld	s1,120(sp)
    800021d4:	07013903          	ld	s2,112(sp)
    800021d8:	09010113          	addi	sp,sp,144
    800021dc:	d3dff06f          	j	80001f18 <to_bytes>
    800021e0:	00140413          	addi	s0,s0,1
    800021e4:	e39ff06f          	j	8000201c <bench_md5_run+0x4c>
    800021e8:	00fa8733          	add	a4,s5,a5
    800021ec:	00070023          	sb	zero,0(a4)
    800021f0:	e45ff06f          	j	80002034 <bench_md5_run+0x64>
    800021f4:	00068813          	mv	a6,a3
    800021f8:	00060693          	mv	a3,a2
    800021fc:	00078613          	mv	a2,a5
    80002200:	f01ff06f          	j	80002100 <bench_md5_run+0x130>
    80002204:	02b2e263          	bltu	t0,a1,80002228 <bench_md5_run+0x258>
    80002208:	02bb873b          	mulw	a4,s7,a1
    8000220c:	00c6c7b3          	xor	a5,a3,a2
    80002210:	0107f7b3          	and	a5,a5,a6
    80002214:	00f6c7b3          	xor	a5,a3,a5
    80002218:	0007879b          	sext.w	a5,a5
    8000221c:	0017071b          	addiw	a4,a4,1
    80002220:	00f77713          	andi	a4,a4,15
    80002224:	ef5ff06f          	j	80002118 <bench_md5_run+0x148>
    80002228:	00b3ee63          	bltu	t2,a1,80002244 <bench_md5_run+0x274>
    8000222c:	02bb073b          	mulw	a4,s6,a1
    80002230:	0106c7b3          	xor	a5,a3,a6
    80002234:	00c7c7b3          	xor	a5,a5,a2
    80002238:	0007879b          	sext.w	a5,a5
    8000223c:	0057071b          	addiw	a4,a4,5
    80002240:	fe1ff06f          	j	80002220 <bench_md5_run+0x250>
    80002244:	fff84793          	not	a5,a6
    80002248:	00c7e7b3          	or	a5,a5,a2
    8000224c:	00d7c7b3          	xor	a5,a5,a3
    80002250:	02b0873b          	mulw	a4,ra,a1
    80002254:	0007879b          	sext.w	a5,a5
    80002258:	fc9ff06f          	j	80002220 <bench_md5_run+0x250>

000000008000225c <bench_md5_validate>:
    8000225c:	0001b517          	auipc	a0,0x1b
    80002260:	5ac53503          	ld	a0,1452(a0) # 8001d808 <digest>
    80002264:	ff010113          	addi	sp,sp,-16
    80002268:	01050593          	addi	a1,a0,16
    8000226c:	00113423          	sd	ra,8(sp)
    80002270:	480000ef          	jal	ra,800026f0 <checksum>
    80002274:	0001b717          	auipc	a4,0x1b
    80002278:	5ac73703          	ld	a4,1452(a4) # 8001d820 <setting>
    8000227c:	0005079b          	sext.w	a5,a0
    80002280:	01872503          	lw	a0,24(a4)
    80002284:	00813083          	ld	ra,8(sp)
    80002288:	40f50533          	sub	a0,a0,a5
    8000228c:	00153513          	seqz	a0,a0
    80002290:	01010113          	addi	sp,sp,16
    80002294:	00008067          	ret

0000000080002298 <uptime>:
    80002298:	ff010113          	addi	sp,sp,-16
    8000229c:	00113423          	sd	ra,8(sp)
    800022a0:	129040ef          	jal	ra,80006bc8 <rt_tick_get>
    800022a4:	000f47b7          	lui	a5,0xf4
    800022a8:	2407879b          	addiw	a5,a5,576
    800022ac:	02a7853b          	mulw	a0,a5,a0
    800022b0:	06400793          	li	a5,100
    800022b4:	00813083          	ld	ra,8(sp)
    800022b8:	01010113          	addi	sp,sp,16
    800022bc:	02f5553b          	divuw	a0,a0,a5
    800022c0:	02051513          	slli	a0,a0,0x20
    800022c4:	02055513          	srli	a0,a0,0x20
    800022c8:	00008067          	ret

00000000800022cc <format_time>:
    800022cc:	3e800613          	li	a2,1000
    800022d0:	02c55633          	divu	a2,a0,a2
    800022d4:	fe010113          	addi	sp,sp,-32
    800022d8:	00813823          	sd	s0,16(sp)
    800022dc:	3e800413          	li	s0,1000
    800022e0:	00913423          	sd	s1,8(sp)
    800022e4:	0001b497          	auipc	s1,0x1b
    800022e8:	73448493          	addi	s1,s1,1844 # 8001da18 <buf.0>
    800022ec:	0000e597          	auipc	a1,0xe
    800022f0:	31c58593          	addi	a1,a1,796 # 80010608 <r+0x100>
    800022f4:	00113c23          	sd	ra,24(sp)
    800022f8:	02c4043b          	mulw	s0,s0,a2
    800022fc:	0006061b          	sext.w	a2,a2
    80002300:	02041413          	slli	s0,s0,0x20
    80002304:	02045413          	srli	s0,s0,0x20
    80002308:	40850433          	sub	s0,a0,s0
    8000230c:	00048513          	mv	a0,s1
    80002310:	089010ef          	jal	ra,80003b98 <sprintf>
    80002314:	fff5051b          	addiw	a0,a0,-1
    80002318:	00a48533          	add	a0,s1,a0
    8000231c:	00a00713          	li	a4,10
    80002320:	02041063          	bnez	s0,80002340 <format_time+0x74>
    80002324:	01813083          	ld	ra,24(sp)
    80002328:	01013403          	ld	s0,16(sp)
    8000232c:	00813483          	ld	s1,8(sp)
    80002330:	0001b517          	auipc	a0,0x1b
    80002334:	6e850513          	addi	a0,a0,1768 # 8001da18 <buf.0>
    80002338:	02010113          	addi	sp,sp,32
    8000233c:	00008067          	ret
    80002340:	02e477b3          	remu	a5,s0,a4
    80002344:	fff50513          	addi	a0,a0,-1
    80002348:	0307879b          	addiw	a5,a5,48
    8000234c:	02e45433          	divu	s0,s0,a4
    80002350:	00f500a3          	sb	a5,1(a0)
    80002354:	fcdff06f          	j	80002320 <format_time+0x54>

0000000080002358 <call_microbench>:
    80002358:	f8010113          	addi	sp,sp,-128
    8000235c:	06113c23          	sd	ra,120(sp)
    80002360:	06813823          	sd	s0,112(sp)
    80002364:	06913423          	sd	s1,104(sp)
    80002368:	07213023          	sd	s2,96(sp)
    8000236c:	05313c23          	sd	s3,88(sp)
    80002370:	05413823          	sd	s4,80(sp)
    80002374:	05513423          	sd	s5,72(sp)
    80002378:	05613023          	sd	s6,64(sp)
    8000237c:	03713c23          	sd	s7,56(sp)
    80002380:	03813823          	sd	s8,48(sp)
    80002384:	03913423          	sd	s9,40(sp)
    80002388:	03a13023          	sd	s10,32(sp)
    8000238c:	01b13c23          	sd	s11,24(sp)
    80002390:	00050c63          	beqz	a0,800023a8 <call_microbench+0x50>
    80002394:	00010597          	auipc	a1,0x10
    80002398:	1d458593          	addi	a1,a1,468 # 80012568 <__fsym___cmd_help_name+0x1f0>
    8000239c:	00050493          	mv	s1,a0
    800023a0:	7b4010ef          	jal	ra,80003b54 <strcmp>
    800023a4:	00051c63          	bnez	a0,800023bc <call_microbench+0x64>
    800023a8:	0000e517          	auipc	a0,0xe
    800023ac:	28850513          	addi	a0,a0,648 # 80010630 <r+0x128>
    800023b0:	63c040ef          	jal	ra,800069ec <rt_kprintf>
    800023b4:	0000e497          	auipc	s1,0xe
    800023b8:	25c48493          	addi	s1,s1,604 # 80010610 <r+0x108>
    800023bc:	0000e597          	auipc	a1,0xe
    800023c0:	04458593          	addi	a1,a1,68 # 80010400 <rt_pin_get+0x9c>
    800023c4:	00048513          	mv	a0,s1
    800023c8:	78c010ef          	jal	ra,80003b54 <strcmp>
    800023cc:	00050413          	mv	s0,a0
    800023d0:	06050063          	beqz	a0,80002430 <call_microbench+0xd8>
    800023d4:	0000e597          	auipc	a1,0xe
    800023d8:	28458593          	addi	a1,a1,644 # 80010658 <r+0x150>
    800023dc:	00048513          	mv	a0,s1
    800023e0:	774010ef          	jal	ra,80003b54 <strcmp>
    800023e4:	00100413          	li	s0,1
    800023e8:	04050463          	beqz	a0,80002430 <call_microbench+0xd8>
    800023ec:	0000e597          	auipc	a1,0xe
    800023f0:	22458593          	addi	a1,a1,548 # 80010610 <r+0x108>
    800023f4:	00048513          	mv	a0,s1
    800023f8:	75c010ef          	jal	ra,80003b54 <strcmp>
    800023fc:	00200413          	li	s0,2
    80002400:	02050863          	beqz	a0,80002430 <call_microbench+0xd8>
    80002404:	0000e597          	auipc	a1,0xe
    80002408:	25c58593          	addi	a1,a1,604 # 80010660 <r+0x158>
    8000240c:	00048513          	mv	a0,s1
    80002410:	744010ef          	jal	ra,80003b54 <strcmp>
    80002414:	00300413          	li	s0,3
    80002418:	00050c63          	beqz	a0,80002430 <call_microbench+0xd8>
    8000241c:	00048593          	mv	a1,s1
    80002420:	0000e517          	auipc	a0,0xe
    80002424:	24850513          	addi	a0,a0,584 # 80010668 <r+0x160>
    80002428:	5c4040ef          	jal	ra,800069ec <rt_kprintf>
    8000242c:	fff00413          	li	s0,-1
    80002430:	00048593          	mv	a1,s1
    80002434:	0000e517          	auipc	a0,0xe
    80002438:	27450513          	addi	a0,a0,628 # 800106a8 <r+0x1a0>
    8000243c:	5b0040ef          	jal	ra,800069ec <rt_kprintf>
    80002440:	e59ff0ef          	jal	ra,80002298 <uptime>
    80002444:	0014079b          	addiw	a5,s0,1
    80002448:	00579793          	slli	a5,a5,0x5
    8000244c:	00878793          	addi	a5,a5,8 # f4008 <__STACKSIZE__+0xf0008>
    80002450:	00018c37          	lui	s8,0x18
    80002454:	00a13023          	sd	a0,0(sp)
    80002458:	00013917          	auipc	s2,0x13
    8000245c:	a8890913          	addi	s2,s2,-1400 # 80014ee0 <benchmarks>
    80002460:	00000b13          	li	s6,0
    80002464:	00100a13          	li	s4,1
    80002468:	00000b93          	li	s7,0
    8000246c:	0001ba97          	auipc	s5,0x1b
    80002470:	3aca8a93          	addi	s5,s5,940 # 8001d818 <current>
    80002474:	0001bc97          	auipc	s9,0x1b
    80002478:	3acc8c93          	addi	s9,s9,940 # 8001d820 <setting>
    8000247c:	00f13423          	sd	a5,8(sp)
    80002480:	0000fd97          	auipc	s11,0xf
    80002484:	0e0d8d93          	addi	s11,s11,224 # 80011560 <small_digits.1+0x38>
    80002488:	6a0c0c13          	addi	s8,s8,1696 # 186a0 <__STACKSIZE__+0x146a0>
    8000248c:	00813783          	ld	a5,8(sp)
    80002490:	02093603          	ld	a2,32(s2)
    80002494:	01893583          	ld	a1,24(s2)
    80002498:	012787b3          	add	a5,a5,s2
    8000249c:	0000e517          	auipc	a0,0xe
    800024a0:	24450513          	addi	a0,a0,580 # 800106e0 <r+0x1d8>
    800024a4:	00fcb023          	sd	a5,0(s9)
    800024a8:	012ab023          	sd	s2,0(s5)
    800024ac:	540040ef          	jal	ra,800069ec <rt_kprintf>
    800024b0:	000ab783          	ld	a5,0(s5)
    800024b4:	0007b783          	ld	a5,0(a5)
    800024b8:	000780e7          	jalr	a5
    800024bc:	dddff0ef          	jal	ra,80002298 <uptime>
    800024c0:	000ab783          	ld	a5,0(s5)
    800024c4:	00050993          	mv	s3,a0
    800024c8:	0087b783          	ld	a5,8(a5)
    800024cc:	000780e7          	jalr	a5
    800024d0:	dc9ff0ef          	jal	ra,80002298 <uptime>
    800024d4:	000ab783          	ld	a5,0(s5)
    800024d8:	413509b3          	sub	s3,a0,s3
    800024dc:	0107b783          	ld	a5,16(a5)
    800024e0:	000780e7          	jalr	a5
    800024e4:	00050d13          	mv	s10,a0
    800024e8:	0000e517          	auipc	a0,0xe
    800024ec:	13050513          	addi	a0,a0,304 # 80010618 <r+0x110>
    800024f0:	000d1463          	bnez	s10,800024f8 <call_microbench+0x1a0>
    800024f4:	000d8513          	mv	a0,s11
    800024f8:	4f4040ef          	jal	ra,800069ec <rt_kprintf>
    800024fc:	001d7d13          	andi	s10,s10,1
    80002500:	013b0b33          	add	s6,s6,s3
    80002504:	0000e517          	auipc	a0,0xe
    80002508:	1ec50513          	addi	a0,a0,492 # 800106f0 <r+0x1e8>
    8000250c:	000d1663          	bnez	s10,80002518 <call_microbench+0x1c0>
    80002510:	0000e517          	auipc	a0,0xe
    80002514:	1f050513          	addi	a0,a0,496 # 80010700 <r+0x1f8>
    80002518:	4d4040ef          	jal	ra,800069ec <rt_kprintf>
    8000251c:	014d7a33          	and	s4,s10,s4
    80002520:	00000493          	li	s1,0
    80002524:	000d0e63          	beqz	s10,80002540 <call_microbench+0x1e8>
    80002528:	00098c63          	beqz	s3,80002540 <call_microbench+0x1e8>
    8000252c:	000cb783          	ld	a5,0(s9)
    80002530:	0107b483          	ld	s1,16(a5)
    80002534:	038484b3          	mul	s1,s1,s8
    80002538:	0334d4b3          	divu	s1,s1,s3
    8000253c:	0004849b          	sext.w	s1,s1
    80002540:	00010517          	auipc	a0,0x10
    80002544:	6d050513          	addi	a0,a0,1744 # 80012c10 <__FUNCTION__.6+0x28>
    80002548:	4a4040ef          	jal	ra,800069ec <rt_kprintf>
    8000254c:	02040063          	beqz	s0,8000256c <call_microbench+0x214>
    80002550:	00098513          	mv	a0,s3
    80002554:	d79ff0ef          	jal	ra,800022cc <format_time>
    80002558:	00050593          	mv	a1,a0
    8000255c:	00048613          	mv	a2,s1
    80002560:	0000e517          	auipc	a0,0xe
    80002564:	1b050513          	addi	a0,a0,432 # 80010710 <r+0x208>
    80002568:	484040ef          	jal	ra,800069ec <rt_kprintf>
    8000256c:	0a890913          	addi	s2,s2,168
    80002570:	00013797          	auipc	a5,0x13
    80002574:	00078793          	mv	a5,a5
    80002578:	009b8bbb          	addw	s7,s7,s1
    8000257c:	f12798e3          	bne	a5,s2,8000248c <call_microbench+0x134>
    80002580:	d19ff0ef          	jal	ra,80002298 <uptime>
    80002584:	00013783          	ld	a5,0(sp)
    80002588:	40f504b3          	sub	s1,a0,a5
    8000258c:	0000e517          	auipc	a0,0xe
    80002590:	19c50513          	addi	a0,a0,412 # 80010728 <r+0x220>
    80002594:	458040ef          	jal	ra,800069ec <rt_kprintf>
    80002598:	0000e597          	auipc	a1,0xe
    8000259c:	08858593          	addi	a1,a1,136 # 80010620 <r+0x118>
    800025a0:	000a1663          	bnez	s4,800025ac <call_microbench+0x254>
    800025a4:	0000e597          	auipc	a1,0xe
    800025a8:	08458593          	addi	a1,a1,132 # 80010628 <r+0x120>
    800025ac:	0000e517          	auipc	a0,0xe
    800025b0:	1b450513          	addi	a0,a0,436 # 80010760 <r+0x258>
    800025b4:	438040ef          	jal	ra,800069ec <rt_kprintf>
    800025b8:	00100793          	li	a5,1
    800025bc:	0a87d263          	bge	a5,s0,80002660 <call_microbench+0x308>
    800025c0:	00a00593          	li	a1,10
    800025c4:	02bbd5bb          	divuw	a1,s7,a1
    800025c8:	0000e517          	auipc	a0,0xe
    800025cc:	1a850513          	addi	a0,a0,424 # 80010770 <r+0x268>
    800025d0:	41c040ef          	jal	ra,800069ec <rt_kprintf>
    800025d4:	000185b7          	lui	a1,0x18
    800025d8:	0000e617          	auipc	a2,0xe
    800025dc:	1b060613          	addi	a2,a2,432 # 80010788 <r+0x280>
    800025e0:	6a058593          	addi	a1,a1,1696 # 186a0 <__STACKSIZE__+0x146a0>
    800025e4:	0000e517          	auipc	a0,0xe
    800025e8:	1bc50513          	addi	a0,a0,444 # 800107a0 <r+0x298>
    800025ec:	400040ef          	jal	ra,800069ec <rt_kprintf>
    800025f0:	000b0513          	mv	a0,s6
    800025f4:	cd9ff0ef          	jal	ra,800022cc <format_time>
    800025f8:	00050593          	mv	a1,a0
    800025fc:	0000e517          	auipc	a0,0xe
    80002600:	1cc50513          	addi	a0,a0,460 # 800107c8 <r+0x2c0>
    80002604:	3e8040ef          	jal	ra,800069ec <rt_kprintf>
    80002608:	00048513          	mv	a0,s1
    8000260c:	cc1ff0ef          	jal	ra,800022cc <format_time>
    80002610:	00050593          	mv	a1,a0
    80002614:	0000e517          	auipc	a0,0xe
    80002618:	1cc50513          	addi	a0,a0,460 # 800107e0 <r+0x2d8>
    8000261c:	3d0040ef          	jal	ra,800069ec <rt_kprintf>
    80002620:	07813083          	ld	ra,120(sp)
    80002624:	07013403          	ld	s0,112(sp)
    80002628:	06813483          	ld	s1,104(sp)
    8000262c:	06013903          	ld	s2,96(sp)
    80002630:	05813983          	ld	s3,88(sp)
    80002634:	04813a83          	ld	s5,72(sp)
    80002638:	04013b03          	ld	s6,64(sp)
    8000263c:	03813b83          	ld	s7,56(sp)
    80002640:	03013c03          	ld	s8,48(sp)
    80002644:	02813c83          	ld	s9,40(sp)
    80002648:	02013d03          	ld	s10,32(sp)
    8000264c:	01813d83          	ld	s11,24(sp)
    80002650:	001a4513          	xori	a0,s4,1
    80002654:	05013a03          	ld	s4,80(sp)
    80002658:	08010113          	addi	sp,sp,128
    8000265c:	00008067          	ret
    80002660:	00010517          	auipc	a0,0x10
    80002664:	5b050513          	addi	a0,a0,1456 # 80012c10 <__FUNCTION__.6+0x28>
    80002668:	384040ef          	jal	ra,800069ec <rt_kprintf>
    8000266c:	f85ff06f          	j	800025f0 <call_microbench+0x298>

0000000080002670 <bench_alloc>:
    80002670:	fe010113          	addi	sp,sp,-32
    80002674:	00113c23          	sd	ra,24(sp)
    80002678:	00813823          	sd	s0,16(sp)
    8000267c:	00a13423          	sd	a0,8(sp)
    80002680:	5a0010ef          	jal	ra,80003c20 <malloc>
    80002684:	00813603          	ld	a2,8(sp)
    80002688:	00000593          	li	a1,0
    8000268c:	00050413          	mv	s0,a0
    80002690:	4cc010ef          	jal	ra,80003b5c <memset>
    80002694:	01813083          	ld	ra,24(sp)
    80002698:	00040513          	mv	a0,s0
    8000269c:	01013403          	ld	s0,16(sp)
    800026a0:	02010113          	addi	sp,sp,32
    800026a4:	00008067          	ret

00000000800026a8 <bench_srand>:
    800026a8:	03151513          	slli	a0,a0,0x31
    800026ac:	03155513          	srli	a0,a0,0x31
    800026b0:	00013797          	auipc	a5,0x13
    800026b4:	0ea7a823          	sw	a0,240(a5) # 800157a0 <seed>
    800026b8:	00008067          	ret

00000000800026bc <bench_rand>:
    800026bc:	00013717          	auipc	a4,0x13
    800026c0:	0e470713          	addi	a4,a4,228 # 800157a0 <seed>
    800026c4:	00072503          	lw	a0,0(a4)
    800026c8:	000347b7          	lui	a5,0x34
    800026cc:	3fd7879b          	addiw	a5,a5,1021
    800026d0:	02f5053b          	mulw	a0,a0,a5
    800026d4:	0026a7b7          	lui	a5,0x26a
    800026d8:	ec37879b          	addiw	a5,a5,-317
    800026dc:	00f5053b          	addw	a0,a0,a5
    800026e0:	00a72023          	sw	a0,0(a4)
    800026e4:	02151513          	slli	a0,a0,0x21
    800026e8:	03155513          	srli	a0,a0,0x31
    800026ec:	00008067          	ret

00000000800026f0 <checksum>:
    800026f0:	811ca7b7          	lui	a5,0x811ca
    800026f4:	010006b7          	lui	a3,0x1000
    800026f8:	dc578793          	addi	a5,a5,-571 # ffffffff811c9dc5 <__bss_end+0xffffffff011a3205>
    800026fc:	1936869b          	addiw	a3,a3,403
    80002700:	00400813          	li	a6,4
    80002704:	00050613          	mv	a2,a0
    80002708:	00450513          	addi	a0,a0,4
    8000270c:	02b56863          	bltu	a0,a1,8000273c <checksum+0x4c>
    80002710:	00d7951b          	slliw	a0,a5,0xd
    80002714:	00f507bb          	addw	a5,a0,a5
    80002718:	4077d51b          	sraiw	a0,a5,0x7
    8000271c:	00f547b3          	xor	a5,a0,a5
    80002720:	0037951b          	slliw	a0,a5,0x3
    80002724:	00f507bb          	addw	a5,a0,a5
    80002728:	4117d51b          	sraiw	a0,a5,0x11
    8000272c:	00f547b3          	xor	a5,a0,a5
    80002730:	0057951b          	slliw	a0,a5,0x5
    80002734:	00f5053b          	addw	a0,a0,a5
    80002738:	00008067          	ret
    8000273c:	00000713          	li	a4,0
    80002740:	00e608b3          	add	a7,a2,a4
    80002744:	0008c883          	lbu	a7,0(a7)
    80002748:	00170713          	addi	a4,a4,1
    8000274c:	0117c7b3          	xor	a5,a5,a7
    80002750:	02f687bb          	mulw	a5,a3,a5
    80002754:	ff0716e3          	bne	a4,a6,80002740 <checksum+0x50>
    80002758:	fadff06f          	j	80002704 <checksum+0x14>

000000008000275c <_ZN5Dinic7AddEdgeEiii>:
    8000275c:	08068c63          	beqz	a3,800027f4 <_ZN5Dinic7AddEdgeEiii+0x98>
    80002760:	00452703          	lw	a4,4(a0)
    80002764:	01053783          	ld	a5,16(a0)
    80002768:	00259893          	slli	a7,a1,0x2
    8000276c:	00471813          	slli	a6,a4,0x4
    80002770:	01078833          	add	a6,a5,a6
    80002774:	00d82423          	sw	a3,8(a6)
    80002778:	01853683          	ld	a3,24(a0)
    8000277c:	00b82023          	sw	a1,0(a6)
    80002780:	00c82223          	sw	a2,4(a6)
    80002784:	00082623          	sw	zero,12(a6)
    80002788:	011688b3          	add	a7,a3,a7
    8000278c:	02053803          	ld	a6,32(a0)
    80002790:	0008a303          	lw	t1,0(a7)
    80002794:	00271713          	slli	a4,a4,0x2
    80002798:	00e80733          	add	a4,a6,a4
    8000279c:	00672023          	sw	t1,0(a4)
    800027a0:	00452703          	lw	a4,4(a0)
    800027a4:	0017031b          	addiw	t1,a4,1
    800027a8:	00652223          	sw	t1,4(a0)
    800027ac:	00e8a023          	sw	a4,0(a7)
    800027b0:	00452703          	lw	a4,4(a0)
    800027b4:	00471893          	slli	a7,a4,0x4
    800027b8:	011787b3          	add	a5,a5,a7
    800027bc:	00c7a023          	sw	a2,0(a5)
    800027c0:	00261613          	slli	a2,a2,0x2
    800027c4:	00b7a223          	sw	a1,4(a5)
    800027c8:	0007a423          	sw	zero,8(a5)
    800027cc:	0007a623          	sw	zero,12(a5)
    800027d0:	00c68633          	add	a2,a3,a2
    800027d4:	00062783          	lw	a5,0(a2)
    800027d8:	00271713          	slli	a4,a4,0x2
    800027dc:	00e80833          	add	a6,a6,a4
    800027e0:	00f82023          	sw	a5,0(a6)
    800027e4:	00452783          	lw	a5,4(a0)
    800027e8:	0017871b          	addiw	a4,a5,1
    800027ec:	00e52223          	sw	a4,4(a0)
    800027f0:	00f62023          	sw	a5,0(a2)
    800027f4:	00008067          	ret

00000000800027f8 <_ZN5Dinic3BFSEv>:
    800027f8:	00052603          	lw	a2,0(a0)
    800027fc:	04053783          	ld	a5,64(a0)
    80002800:	00000713          	li	a4,0
    80002804:	0007069b          	sext.w	a3,a4
    80002808:	00c6da63          	bge	a3,a2,8000281c <_ZN5Dinic3BFSEv+0x24>
    8000280c:	00e786b3          	add	a3,a5,a4
    80002810:	00068023          	sb	zero,0(a3) # 1000000 <__STACKSIZE__+0xffc000>
    80002814:	00170713          	addi	a4,a4,1
    80002818:	fedff06f          	j	80002804 <_ZN5Dinic3BFSEv+0xc>
    8000281c:	00852703          	lw	a4,8(a0)
    80002820:	03853883          	ld	a7,56(a0)
    80002824:	02853303          	ld	t1,40(a0)
    80002828:	01853e83          	ld	t4,24(a0)
    8000282c:	00e8a023          	sw	a4,0(a7)
    80002830:	00852703          	lw	a4,8(a0)
    80002834:	00100693          	li	a3,1
    80002838:	00000813          	li	a6,0
    8000283c:	00271713          	slli	a4,a4,0x2
    80002840:	00e30733          	add	a4,t1,a4
    80002844:	00072023          	sw	zero,0(a4)
    80002848:	00852703          	lw	a4,8(a0)
    8000284c:	00100593          	li	a1,1
    80002850:	fff00f13          	li	t5,-1
    80002854:	00e78733          	add	a4,a5,a4
    80002858:	00d70023          	sb	a3,0(a4)
    8000285c:	00100f93          	li	t6,1
    80002860:	00281713          	slli	a4,a6,0x2
    80002864:	00e88733          	add	a4,a7,a4
    80002868:	00072683          	lw	a3,0(a4)
    8000286c:	00269693          	slli	a3,a3,0x2
    80002870:	00de8733          	add	a4,t4,a3
    80002874:	00072703          	lw	a4,0(a4)
    80002878:	00d302b3          	add	t0,t1,a3
    8000287c:	0de71663          	bne	a4,t5,80002948 <_ZN5Dinic3BFSEv+0x150>
    80002880:	00180813          	addi	a6,a6,1
    80002884:	0008071b          	sext.w	a4,a6
    80002888:	fce59ce3          	bne	a1,a4,80002860 <_ZN5Dinic3BFSEv+0x68>
    8000288c:	00c52703          	lw	a4,12(a0)
    80002890:	00e787b3          	add	a5,a5,a4
    80002894:	0007c503          	lbu	a0,0(a5)
    80002898:	00008067          	ret
    8000289c:	00281713          	slli	a4,a6,0x2
    800028a0:	00e88733          	add	a4,a7,a4
    800028a4:	00072683          	lw	a3,0(a4)
    800028a8:	00269693          	slli	a3,a3,0x2
    800028ac:	00de8733          	add	a4,t4,a3
    800028b0:	00072703          	lw	a4,0(a4)
    800028b4:	00d302b3          	add	t0,t1,a3
    800028b8:	03e71463          	bne	a4,t5,800028e0 <_ZN5Dinic3BFSEv+0xe8>
    800028bc:	00180813          	addi	a6,a6,1
    800028c0:	0008071b          	sext.w	a4,a6
    800028c4:	fce59ce3          	bne	a1,a4,8000289c <_ZN5Dinic3BFSEv+0xa4>
    800028c8:	00c52703          	lw	a4,12(a0)
    800028cc:	00813403          	ld	s0,8(sp)
    800028d0:	00e787b3          	add	a5,a5,a4
    800028d4:	0007c503          	lbu	a0,0(a5)
    800028d8:	01010113          	addi	sp,sp,16
    800028dc:	00008067          	ret
    800028e0:	01053603          	ld	a2,16(a0)
    800028e4:	00471693          	slli	a3,a4,0x4
    800028e8:	00d606b3          	add	a3,a2,a3
    800028ec:	0046a603          	lw	a2,4(a3)
    800028f0:	00c78e33          	add	t3,a5,a2
    800028f4:	000e4383          	lbu	t2,0(t3)
    800028f8:	02039e63          	bnez	t2,80002934 <_ZN5Dinic3BFSEv+0x13c>
    800028fc:	0086a403          	lw	s0,8(a3)
    80002900:	00c6a383          	lw	t2,12(a3)
    80002904:	0283d863          	bge	t2,s0,80002934 <_ZN5Dinic3BFSEv+0x13c>
    80002908:	01fe0023          	sb	t6,0(t3)
    8000290c:	0002ae03          	lw	t3,0(t0) # 8000 <__STACKSIZE__+0x4000>
    80002910:	00261613          	slli	a2,a2,0x2
    80002914:	00c30633          	add	a2,t1,a2
    80002918:	001e0e1b          	addiw	t3,t3,1
    8000291c:	01c62023          	sw	t3,0(a2)
    80002920:	0046a683          	lw	a3,4(a3)
    80002924:	00259613          	slli	a2,a1,0x2
    80002928:	00c88633          	add	a2,a7,a2
    8000292c:	00d62023          	sw	a3,0(a2)
    80002930:	0015859b          	addiw	a1,a1,1
    80002934:	02053603          	ld	a2,32(a0)
    80002938:	00271713          	slli	a4,a4,0x2
    8000293c:	00e60733          	add	a4,a2,a4
    80002940:	00072703          	lw	a4,0(a4)
    80002944:	f75ff06f          	j	800028b8 <_ZN5Dinic3BFSEv+0xc0>
    80002948:	01053603          	ld	a2,16(a0)
    8000294c:	00471693          	slli	a3,a4,0x4
    80002950:	00d606b3          	add	a3,a2,a3
    80002954:	0046a603          	lw	a2,4(a3)
    80002958:	00c78e33          	add	t3,a5,a2
    8000295c:	000e4383          	lbu	t2,0(t3)
    80002960:	00038c63          	beqz	t2,80002978 <_ZN5Dinic3BFSEv+0x180>
    80002964:	02053603          	ld	a2,32(a0)
    80002968:	00271713          	slli	a4,a4,0x2
    8000296c:	00e60733          	add	a4,a2,a4
    80002970:	00072703          	lw	a4,0(a4)
    80002974:	f09ff06f          	j	8000287c <_ZN5Dinic3BFSEv+0x84>
    80002978:	ff010113          	addi	sp,sp,-16
    8000297c:	00813423          	sd	s0,8(sp)
    80002980:	f7dff06f          	j	800028fc <_ZN5Dinic3BFSEv+0x104>

0000000080002984 <_ZN5Dinic3DFSEii>:
    80002984:	00c52783          	lw	a5,12(a0)
    80002988:	fc010113          	addi	sp,sp,-64
    8000298c:	02913423          	sd	s1,40(sp)
    80002990:	02113c23          	sd	ra,56(sp)
    80002994:	02813823          	sd	s0,48(sp)
    80002998:	03213023          	sd	s2,32(sp)
    8000299c:	01313c23          	sd	s3,24(sp)
    800029a0:	01413823          	sd	s4,16(sp)
    800029a4:	01513423          	sd	s5,8(sp)
    800029a8:	01613023          	sd	s6,0(sp)
    800029ac:	00060493          	mv	s1,a2
    800029b0:	0cb78463          	beq	a5,a1,80002a78 <_ZN5Dinic3DFSEii+0xf4>
    800029b4:	0c060263          	beqz	a2,80002a78 <_ZN5Dinic3DFSEii+0xf4>
    800029b8:	03053783          	ld	a5,48(a0)
    800029bc:	00259993          	slli	s3,a1,0x2
    800029c0:	00050413          	mv	s0,a0
    800029c4:	013787b3          	add	a5,a5,s3
    800029c8:	0007a903          	lw	s2,0(a5)
    800029cc:	00060a93          	mv	s5,a2
    800029d0:	00000493          	li	s1,0
    800029d4:	fff00b13          	li	s6,-1
    800029d8:	0b690063          	beq	s2,s6,80002a78 <_ZN5Dinic3DFSEii+0xf4>
    800029dc:	01043783          	ld	a5,16(s0)
    800029e0:	00491a13          	slli	s4,s2,0x4
    800029e4:	01478a33          	add	s4,a5,s4
    800029e8:	004a2583          	lw	a1,4(s4)
    800029ec:	02843783          	ld	a5,40(s0)
    800029f0:	00259693          	slli	a3,a1,0x2
    800029f4:	01378733          	add	a4,a5,s3
    800029f8:	00072703          	lw	a4,0(a4)
    800029fc:	00d787b3          	add	a5,a5,a3
    80002a00:	0007a783          	lw	a5,0(a5)
    80002a04:	0017071b          	addiw	a4,a4,1
    80002a08:	04f71e63          	bne	a4,a5,80002a64 <_ZN5Dinic3DFSEii+0xe0>
    80002a0c:	008a2603          	lw	a2,8(s4)
    80002a10:	00ca2783          	lw	a5,12(s4)
    80002a14:	40f607bb          	subw	a5,a2,a5
    80002a18:	00078613          	mv	a2,a5
    80002a1c:	00fad463          	bge	s5,a5,80002a24 <_ZN5Dinic3DFSEii+0xa0>
    80002a20:	000a861b          	sext.w	a2,s5
    80002a24:	00040513          	mv	a0,s0
    80002a28:	f5dff0ef          	jal	ra,80002984 <_ZN5Dinic3DFSEii>
    80002a2c:	02a05c63          	blez	a0,80002a64 <_ZN5Dinic3DFSEii+0xe0>
    80002a30:	00ca2783          	lw	a5,12(s4)
    80002a34:	40aa8abb          	subw	s5,s5,a0
    80002a38:	00a484bb          	addw	s1,s1,a0
    80002a3c:	00a787bb          	addw	a5,a5,a0
    80002a40:	00fa2623          	sw	a5,12(s4)
    80002a44:	00194793          	xori	a5,s2,1
    80002a48:	00479713          	slli	a4,a5,0x4
    80002a4c:	01043783          	ld	a5,16(s0)
    80002a50:	00e787b3          	add	a5,a5,a4
    80002a54:	00c7a703          	lw	a4,12(a5)
    80002a58:	40a7073b          	subw	a4,a4,a0
    80002a5c:	00e7a623          	sw	a4,12(a5)
    80002a60:	000a8c63          	beqz	s5,80002a78 <_ZN5Dinic3DFSEii+0xf4>
    80002a64:	02043783          	ld	a5,32(s0)
    80002a68:	00291913          	slli	s2,s2,0x2
    80002a6c:	01278933          	add	s2,a5,s2
    80002a70:	00092903          	lw	s2,0(s2)
    80002a74:	f65ff06f          	j	800029d8 <_ZN5Dinic3DFSEii+0x54>
    80002a78:	03813083          	ld	ra,56(sp)
    80002a7c:	03013403          	ld	s0,48(sp)
    80002a80:	02013903          	ld	s2,32(sp)
    80002a84:	01813983          	ld	s3,24(sp)
    80002a88:	01013a03          	ld	s4,16(sp)
    80002a8c:	00813a83          	ld	s5,8(sp)
    80002a90:	00013b03          	ld	s6,0(sp)
    80002a94:	00048513          	mv	a0,s1
    80002a98:	02813483          	ld	s1,40(sp)
    80002a9c:	04010113          	addi	sp,sp,64
    80002aa0:	00008067          	ret

0000000080002aa4 <bench_dinic_prepare>:
    80002aa4:	0001b797          	auipc	a5,0x1b
    80002aa8:	d7c7b783          	ld	a5,-644(a5) # 8001d820 <setting>
    80002aac:	0007a783          	lw	a5,0(a5)
    80002ab0:	fa010113          	addi	sp,sp,-96
    80002ab4:	04913423          	sd	s1,72(sp)
    80002ab8:	00100513          	li	a0,1
    80002abc:	0001b497          	auipc	s1,0x1b
    80002ac0:	d7448493          	addi	s1,s1,-652 # 8001d830 <_ZL1N>
    80002ac4:	04113c23          	sd	ra,88(sp)
    80002ac8:	00f4a023          	sw	a5,0(s1)
    80002acc:	04813823          	sd	s0,80(sp)
    80002ad0:	05213023          	sd	s2,64(sp)
    80002ad4:	03313c23          	sd	s3,56(sp)
    80002ad8:	03413823          	sd	s4,48(sp)
    80002adc:	03513423          	sd	s5,40(sp)
    80002ae0:	03613023          	sd	s6,32(sp)
    80002ae4:	01713c23          	sd	s7,24(sp)
    80002ae8:	01813823          	sd	s8,16(sp)
    80002aec:	bbdff0ef          	jal	ra,800026a8 <bench_srand>
    80002af0:	04800513          	li	a0,72
    80002af4:	0004a983          	lw	s3,0(s1)
    80002af8:	b79ff0ef          	jal	ra,80002670 <bench_alloc>
    80002afc:	0004a903          	lw	s2,0(s1)
    80002b00:	00200713          	li	a4,2
    80002b04:	0001ba97          	auipc	s5,0x1b
    80002b08:	d24a8a93          	addi	s5,s5,-732 # 8001d828 <_ZL1G>
    80002b0c:	0019091b          	addiw	s2,s2,1
    80002b10:	00191b9b          	slliw	s7,s2,0x1
    80002b14:	ffeb879b          	addiw	a5,s7,-2
    80002b18:	02e7c7bb          	divw	a5,a5,a4
    80002b1c:	00050413          	mv	s0,a0
    80002b20:	00aab023          	sd	a0,0(s5)
    80002b24:	002b9c13          	slli	s8,s7,0x2
    80002b28:	00199b1b          	slliw	s6,s3,0x1
    80002b2c:	001b099b          	addiw	s3,s6,1
    80002b30:	02f78a3b          	mulw	s4,a5,a5
    80002b34:	0017979b          	slliw	a5,a5,0x1
    80002b38:	00fa07bb          	addw	a5,s4,a5
    80002b3c:	00179a1b          	slliw	s4,a5,0x1
    80002b40:	004a1513          	slli	a0,s4,0x4
    80002b44:	b2dff0ef          	jal	ra,80002670 <bench_alloc>
    80002b48:	00a43823          	sd	a0,16(s0)
    80002b4c:	000c0513          	mv	a0,s8
    80002b50:	b21ff0ef          	jal	ra,80002670 <bench_alloc>
    80002b54:	00a43c23          	sd	a0,24(s0)
    80002b58:	002a1513          	slli	a0,s4,0x2
    80002b5c:	b15ff0ef          	jal	ra,80002670 <bench_alloc>
    80002b60:	02a43023          	sd	a0,32(s0)
    80002b64:	000b8513          	mv	a0,s7
    80002b68:	b09ff0ef          	jal	ra,80002670 <bench_alloc>
    80002b6c:	04a43023          	sd	a0,64(s0)
    80002b70:	000c0513          	mv	a0,s8
    80002b74:	afdff0ef          	jal	ra,80002670 <bench_alloc>
    80002b78:	02a43423          	sd	a0,40(s0)
    80002b7c:	000c0513          	mv	a0,s8
    80002b80:	af1ff0ef          	jal	ra,80002670 <bench_alloc>
    80002b84:	02a43823          	sd	a0,48(s0)
    80002b88:	000c0513          	mv	a0,s8
    80002b8c:	ae5ff0ef          	jal	ra,80002670 <bench_alloc>
    80002b90:	02a43c23          	sd	a0,56(s0)
    80002b94:	01742023          	sw	s7,0(s0)
    80002b98:	00000793          	li	a5,0
    80002b9c:	fff00693          	li	a3,-1
    80002ba0:	0007871b          	sext.w	a4,a5
    80002ba4:	01775e63          	bge	a4,s7,80002bc0 <bench_dinic_prepare+0x11c>
    80002ba8:	01843703          	ld	a4,24(s0)
    80002bac:	00279613          	slli	a2,a5,0x2
    80002bb0:	00178793          	addi	a5,a5,1
    80002bb4:	00c70733          	add	a4,a4,a2
    80002bb8:	00d72023          	sw	a3,0(a4)
    80002bbc:	fe5ff06f          	j	80002ba0 <bench_dinic_prepare+0xfc>
    80002bc0:	00042223          	sw	zero,4(s0)
    80002bc4:	00a00a13          	li	s4,10
    80002bc8:	00000413          	li	s0,0
    80002bcc:	0004a783          	lw	a5,0(s1)
    80002bd0:	04f45263          	bge	s0,a5,80002c14 <bench_dinic_prepare+0x170>
    80002bd4:	00000913          	li	s2,0
    80002bd8:	0004a603          	lw	a2,0(s1)
    80002bdc:	02c95863          	bge	s2,a2,80002c0c <bench_dinic_prepare+0x168>
    80002be0:	0126063b          	addw	a2,a2,s2
    80002be4:	000abb83          	ld	s7,0(s5)
    80002be8:	00c13423          	sd	a2,8(sp)
    80002bec:	ad1ff0ef          	jal	ra,800026bc <bench_rand>
    80002bf0:	034576bb          	remuw	a3,a0,s4
    80002bf4:	00813603          	ld	a2,8(sp)
    80002bf8:	00040593          	mv	a1,s0
    80002bfc:	000b8513          	mv	a0,s7
    80002c00:	0019091b          	addiw	s2,s2,1
    80002c04:	b59ff0ef          	jal	ra,8000275c <_ZN5Dinic7AddEdgeEiii>
    80002c08:	fd1ff06f          	j	80002bd8 <bench_dinic_prepare+0x134>
    80002c0c:	0014041b          	addiw	s0,s0,1
    80002c10:	fbdff06f          	j	80002bcc <bench_dinic_prepare+0x128>
    80002c14:	00000413          	li	s0,0
    80002c18:	3e800913          	li	s2,1000
    80002c1c:	0004a783          	lw	a5,0(s1)
    80002c20:	04f45863          	bge	s0,a5,80002c70 <bench_dinic_prepare+0x1cc>
    80002c24:	000aba03          	ld	s4,0(s5)
    80002c28:	a95ff0ef          	jal	ra,800026bc <bench_rand>
    80002c2c:	032576bb          	remuw	a3,a0,s2
    80002c30:	00040613          	mv	a2,s0
    80002c34:	000a0513          	mv	a0,s4
    80002c38:	000b0593          	mv	a1,s6
    80002c3c:	b21ff0ef          	jal	ra,8000275c <_ZN5Dinic7AddEdgeEiii>
    80002c40:	0004a583          	lw	a1,0(s1)
    80002c44:	000aba03          	ld	s4,0(s5)
    80002c48:	008585bb          	addw	a1,a1,s0
    80002c4c:	00b13423          	sd	a1,8(sp)
    80002c50:	a6dff0ef          	jal	ra,800026bc <bench_rand>
    80002c54:	032576bb          	remuw	a3,a0,s2
    80002c58:	00813583          	ld	a1,8(sp)
    80002c5c:	00098613          	mv	a2,s3
    80002c60:	000a0513          	mv	a0,s4
    80002c64:	0014041b          	addiw	s0,s0,1
    80002c68:	af5ff0ef          	jal	ra,8000275c <_ZN5Dinic7AddEdgeEiii>
    80002c6c:	fb1ff06f          	j	80002c1c <bench_dinic_prepare+0x178>
    80002c70:	05813083          	ld	ra,88(sp)
    80002c74:	05013403          	ld	s0,80(sp)
    80002c78:	04813483          	ld	s1,72(sp)
    80002c7c:	04013903          	ld	s2,64(sp)
    80002c80:	03813983          	ld	s3,56(sp)
    80002c84:	03013a03          	ld	s4,48(sp)
    80002c88:	02813a83          	ld	s5,40(sp)
    80002c8c:	02013b03          	ld	s6,32(sp)
    80002c90:	01813b83          	ld	s7,24(sp)
    80002c94:	01013c03          	ld	s8,16(sp)
    80002c98:	06010113          	addi	sp,sp,96
    80002c9c:	00008067          	ret

0000000080002ca0 <bench_dinic_run>:
    80002ca0:	fd010113          	addi	sp,sp,-48
    80002ca4:	0001b797          	auipc	a5,0x1b
    80002ca8:	b8c7a783          	lw	a5,-1140(a5) # 8001d830 <_ZL1N>
    80002cac:	01313423          	sd	s3,8(sp)
    80002cb0:	0017999b          	slliw	s3,a5,0x1
    80002cb4:	02813023          	sd	s0,32(sp)
    80002cb8:	00913c23          	sd	s1,24(sp)
    80002cbc:	01213823          	sd	s2,16(sp)
    80002cc0:	02113423          	sd	ra,40(sp)
    80002cc4:	0001b417          	auipc	s0,0x1b
    80002cc8:	b6443403          	ld	s0,-1180(s0) # 8001d828 <_ZL1G>
    80002ccc:	0019879b          	addiw	a5,s3,1
    80002cd0:	003f4937          	lui	s2,0x3f4
    80002cd4:	01342423          	sw	s3,8(s0)
    80002cd8:	00f42623          	sw	a5,12(s0)
    80002cdc:	00000493          	li	s1,0
    80002ce0:	f3f90913          	addi	s2,s2,-193 # 3f3f3f <__STACKSIZE__+0x3eff3f>
    80002ce4:	00040513          	mv	a0,s0
    80002ce8:	b11ff0ef          	jal	ra,800027f8 <_ZN5Dinic3BFSEv>
    80002cec:	04050863          	beqz	a0,80002d3c <bench_dinic_run+0x9c>
    80002cf0:	00000793          	li	a5,0
    80002cf4:	00042683          	lw	a3,0(s0)
    80002cf8:	0007871b          	sext.w	a4,a5
    80002cfc:	02d75463          	bge	a4,a3,80002d24 <bench_dinic_run+0x84>
    80002d00:	01843683          	ld	a3,24(s0)
    80002d04:	00279613          	slli	a2,a5,0x2
    80002d08:	03043703          	ld	a4,48(s0)
    80002d0c:	00c686b3          	add	a3,a3,a2
    80002d10:	0006a683          	lw	a3,0(a3)
    80002d14:	00c70733          	add	a4,a4,a2
    80002d18:	00178793          	addi	a5,a5,1
    80002d1c:	00d72023          	sw	a3,0(a4)
    80002d20:	fd5ff06f          	j	80002cf4 <bench_dinic_run+0x54>
    80002d24:	00090613          	mv	a2,s2
    80002d28:	00098593          	mv	a1,s3
    80002d2c:	00040513          	mv	a0,s0
    80002d30:	c55ff0ef          	jal	ra,80002984 <_ZN5Dinic3DFSEii>
    80002d34:	009504bb          	addw	s1,a0,s1
    80002d38:	fadff06f          	j	80002ce4 <bench_dinic_run+0x44>
    80002d3c:	02813083          	ld	ra,40(sp)
    80002d40:	02013403          	ld	s0,32(sp)
    80002d44:	0001b797          	auipc	a5,0x1b
    80002d48:	ae97a823          	sw	s1,-1296(a5) # 8001d834 <_ZL3ans>
    80002d4c:	01013903          	ld	s2,16(sp)
    80002d50:	01813483          	ld	s1,24(sp)
    80002d54:	00813983          	ld	s3,8(sp)
    80002d58:	03010113          	addi	sp,sp,48
    80002d5c:	00008067          	ret

0000000080002d60 <bench_dinic_validate>:
    80002d60:	0001b797          	auipc	a5,0x1b
    80002d64:	ac07b783          	ld	a5,-1344(a5) # 8001d820 <setting>
    80002d68:	0187a503          	lw	a0,24(a5)
    80002d6c:	0001b797          	auipc	a5,0x1b
    80002d70:	ac87a783          	lw	a5,-1336(a5) # 8001d834 <_ZL3ans>
    80002d74:	40f50533          	sub	a0,a0,a5
    80002d78:	00153513          	seqz	a0,a0
    80002d7c:	00008067          	ret

0000000080002d80 <myqsort>:
    80002d80:	fe010113          	addi	sp,sp,-32
    80002d84:	00813823          	sd	s0,16(sp)
    80002d88:	00913423          	sd	s1,8(sp)
    80002d8c:	00113c23          	sd	ra,24(sp)
    80002d90:	01213023          	sd	s2,0(sp)
    80002d94:	00050413          	mv	s0,a0
    80002d98:	00060493          	mv	s1,a2
    80002d9c:	0695de63          	bge	a1,s1,80002e18 <myqsort+0x98>
    80002da0:	00259793          	slli	a5,a1,0x2
    80002da4:	00f407b3          	add	a5,s0,a5
    80002da8:	0007a803          	lw	a6,0(a5)
    80002dac:	0015871b          	addiw	a4,a1,1
    80002db0:	00058613          	mv	a2,a1
    80002db4:	0007069b          	sext.w	a3,a4
    80002db8:	0016091b          	addiw	s2,a2,1
    80002dbc:	0296c663          	blt	a3,s1,80002de8 <myqsort+0x68>
    80002dc0:	00261713          	slli	a4,a2,0x2
    80002dc4:	0007a503          	lw	a0,0(a5)
    80002dc8:	00e40733          	add	a4,s0,a4
    80002dcc:	00072683          	lw	a3,0(a4)
    80002dd0:	00a72023          	sw	a0,0(a4)
    80002dd4:	00040513          	mv	a0,s0
    80002dd8:	00d7a023          	sw	a3,0(a5)
    80002ddc:	fa5ff0ef          	jal	ra,80002d80 <myqsort>
    80002de0:	00090593          	mv	a1,s2
    80002de4:	fb9ff06f          	j	80002d9c <myqsort+0x1c>
    80002de8:	00271693          	slli	a3,a4,0x2
    80002dec:	00d406b3          	add	a3,s0,a3
    80002df0:	0006a503          	lw	a0,0(a3)
    80002df4:	01055e63          	bge	a0,a6,80002e10 <myqsort+0x90>
    80002df8:	00291613          	slli	a2,s2,0x2
    80002dfc:	00c40633          	add	a2,s0,a2
    80002e00:	00062883          	lw	a7,0(a2)
    80002e04:	00a62023          	sw	a0,0(a2)
    80002e08:	00090613          	mv	a2,s2
    80002e0c:	0116a023          	sw	a7,0(a3)
    80002e10:	00170713          	addi	a4,a4,1
    80002e14:	fa1ff06f          	j	80002db4 <myqsort+0x34>
    80002e18:	01813083          	ld	ra,24(sp)
    80002e1c:	01013403          	ld	s0,16(sp)
    80002e20:	00813483          	ld	s1,8(sp)
    80002e24:	00013903          	ld	s2,0(sp)
    80002e28:	02010113          	addi	sp,sp,32
    80002e2c:	00008067          	ret

0000000080002e30 <bench_qsort_prepare>:
    80002e30:	fd010113          	addi	sp,sp,-48
    80002e34:	00100513          	li	a0,1
    80002e38:	02113423          	sd	ra,40(sp)
    80002e3c:	00913c23          	sd	s1,24(sp)
    80002e40:	01213823          	sd	s2,16(sp)
    80002e44:	01313423          	sd	s3,8(sp)
    80002e48:	02813023          	sd	s0,32(sp)
    80002e4c:	85dff0ef          	jal	ra,800026a8 <bench_srand>
    80002e50:	0001b797          	auipc	a5,0x1b
    80002e54:	9d07b783          	ld	a5,-1584(a5) # 8001d820 <setting>
    80002e58:	0007a503          	lw	a0,0(a5)
    80002e5c:	0001b917          	auipc	s2,0x1b
    80002e60:	9dc90913          	addi	s2,s2,-1572 # 8001d838 <N>
    80002e64:	0001b997          	auipc	s3,0x1b
    80002e68:	9dc98993          	addi	s3,s3,-1572 # 8001d840 <data>
    80002e6c:	00a92023          	sw	a0,0(s2)
    80002e70:	00251513          	slli	a0,a0,0x2
    80002e74:	ffcff0ef          	jal	ra,80002670 <bench_alloc>
    80002e78:	00a9b023          	sd	a0,0(s3)
    80002e7c:	00000493          	li	s1,0
    80002e80:	00092703          	lw	a4,0(s2)
    80002e84:	0004879b          	sext.w	a5,s1
    80002e88:	02e7c063          	blt	a5,a4,80002ea8 <bench_qsort_prepare+0x78>
    80002e8c:	02813083          	ld	ra,40(sp)
    80002e90:	02013403          	ld	s0,32(sp)
    80002e94:	01813483          	ld	s1,24(sp)
    80002e98:	01013903          	ld	s2,16(sp)
    80002e9c:	00813983          	ld	s3,8(sp)
    80002ea0:	03010113          	addi	sp,sp,48
    80002ea4:	00008067          	ret
    80002ea8:	815ff0ef          	jal	ra,800026bc <bench_rand>
    80002eac:	0005041b          	sext.w	s0,a0
    80002eb0:	80dff0ef          	jal	ra,800026bc <bench_rand>
    80002eb4:	0009b783          	ld	a5,0(s3)
    80002eb8:	00249713          	slli	a4,s1,0x2
    80002ebc:	0104141b          	slliw	s0,s0,0x10
    80002ec0:	00e787b3          	add	a5,a5,a4
    80002ec4:	00856433          	or	s0,a0,s0
    80002ec8:	0087a023          	sw	s0,0(a5)
    80002ecc:	00148493          	addi	s1,s1,1
    80002ed0:	fb1ff06f          	j	80002e80 <bench_qsort_prepare+0x50>

0000000080002ed4 <bench_qsort_run>:
    80002ed4:	0001b617          	auipc	a2,0x1b
    80002ed8:	96462603          	lw	a2,-1692(a2) # 8001d838 <N>
    80002edc:	00000593          	li	a1,0
    80002ee0:	0001b517          	auipc	a0,0x1b
    80002ee4:	96053503          	ld	a0,-1696(a0) # 8001d840 <data>
    80002ee8:	e99ff06f          	j	80002d80 <myqsort>

0000000080002eec <bench_qsort_validate>:
    80002eec:	0001b597          	auipc	a1,0x1b
    80002ef0:	94c5a583          	lw	a1,-1716(a1) # 8001d838 <N>
    80002ef4:	0001b517          	auipc	a0,0x1b
    80002ef8:	94c53503          	ld	a0,-1716(a0) # 8001d840 <data>
    80002efc:	00259593          	slli	a1,a1,0x2
    80002f00:	ff010113          	addi	sp,sp,-16
    80002f04:	00b505b3          	add	a1,a0,a1
    80002f08:	00113423          	sd	ra,8(sp)
    80002f0c:	fe4ff0ef          	jal	ra,800026f0 <checksum>
    80002f10:	0001b717          	auipc	a4,0x1b
    80002f14:	91073703          	ld	a4,-1776(a4) # 8001d820 <setting>
    80002f18:	0005079b          	sext.w	a5,a0
    80002f1c:	01872503          	lw	a0,24(a4)
    80002f20:	00813083          	ld	ra,8(sp)
    80002f24:	40f50533          	sub	a0,a0,a5
    80002f28:	00153513          	seqz	a0,a0
    80002f2c:	01010113          	addi	sp,sp,16
    80002f30:	00008067          	ret

0000000080002f34 <bench_lzip_prepare>:
    80002f34:	0001b797          	auipc	a5,0x1b
    80002f38:	8ec7b783          	ld	a5,-1812(a5) # 8001d820 <setting>
    80002f3c:	0007a783          	lw	a5,0(a5)
    80002f40:	fd010113          	addi	sp,sp,-48
    80002f44:	00913c23          	sd	s1,24(sp)
    80002f48:	00100513          	li	a0,1
    80002f4c:	0001b497          	auipc	s1,0x1b
    80002f50:	8fc48493          	addi	s1,s1,-1796 # 8001d848 <SIZE>
    80002f54:	00f4a023          	sw	a5,0(s1)
    80002f58:	02113423          	sd	ra,40(sp)
    80002f5c:	02813023          	sd	s0,32(sp)
    80002f60:	01213823          	sd	s2,16(sp)
    80002f64:	01313423          	sd	s3,8(sp)
    80002f68:	f40ff0ef          	jal	ra,800026a8 <bench_srand>
    80002f6c:	00011537          	lui	a0,0x11
    80002f70:	80850513          	addi	a0,a0,-2040 # 10808 <__STACKSIZE__+0xc808>
    80002f74:	efcff0ef          	jal	ra,80002670 <bench_alloc>
    80002f78:	0001b797          	auipc	a5,0x1b
    80002f7c:	8ea7b823          	sd	a0,-1808(a5) # 8001d868 <state>
    80002f80:	0004a503          	lw	a0,0(s1)
    80002f84:	0001b917          	auipc	s2,0x1b
    80002f88:	8cc90913          	addi	s2,s2,-1844 # 8001d850 <blk>
    80002f8c:	00000413          	li	s0,0
    80002f90:	ee0ff0ef          	jal	ra,80002670 <bench_alloc>
    80002f94:	00a93023          	sd	a0,0(s2)
    80002f98:	0004a503          	lw	a0,0(s1)
    80002f9c:	01a00993          	li	s3,26
    80002fa0:	1905051b          	addiw	a0,a0,400
    80002fa4:	eccff0ef          	jal	ra,80002670 <bench_alloc>
    80002fa8:	0001b797          	auipc	a5,0x1b
    80002fac:	8aa7b823          	sd	a0,-1872(a5) # 8001d858 <compress>
    80002fb0:	0004a703          	lw	a4,0(s1)
    80002fb4:	0004079b          	sext.w	a5,s0
    80002fb8:	02e7c063          	blt	a5,a4,80002fd8 <bench_lzip_prepare+0xa4>
    80002fbc:	02813083          	ld	ra,40(sp)
    80002fc0:	02013403          	ld	s0,32(sp)
    80002fc4:	01813483          	ld	s1,24(sp)
    80002fc8:	01013903          	ld	s2,16(sp)
    80002fcc:	00813983          	ld	s3,8(sp)
    80002fd0:	03010113          	addi	sp,sp,48
    80002fd4:	00008067          	ret
    80002fd8:	ee4ff0ef          	jal	ra,800026bc <bench_rand>
    80002fdc:	0335753b          	remuw	a0,a0,s3
    80002fe0:	00093783          	ld	a5,0(s2)
    80002fe4:	008787b3          	add	a5,a5,s0
    80002fe8:	00140413          	addi	s0,s0,1
    80002fec:	0615051b          	addiw	a0,a0,97
    80002ff0:	00a78023          	sb	a0,0(a5)
    80002ff4:	fbdff06f          	j	80002fb0 <bench_lzip_prepare+0x7c>

0000000080002ff8 <bench_lzip_run>:
    80002ff8:	ff010113          	addi	sp,sp,-16
    80002ffc:	0001b697          	auipc	a3,0x1b
    80003000:	86c6b683          	ld	a3,-1940(a3) # 8001d868 <state>
    80003004:	0001b617          	auipc	a2,0x1b
    80003008:	84462603          	lw	a2,-1980(a2) # 8001d848 <SIZE>
    8000300c:	0001b597          	auipc	a1,0x1b
    80003010:	84c5b583          	ld	a1,-1972(a1) # 8001d858 <compress>
    80003014:	0001b517          	auipc	a0,0x1b
    80003018:	83c53503          	ld	a0,-1988(a0) # 8001d850 <blk>
    8000301c:	00113423          	sd	ra,8(sp)
    80003020:	981fe0ef          	jal	ra,800019a0 <qlz_compress>
    80003024:	00813083          	ld	ra,8(sp)
    80003028:	0001b797          	auipc	a5,0x1b
    8000302c:	82a7ac23          	sw	a0,-1992(a5) # 8001d860 <len>
    80003030:	01010113          	addi	sp,sp,16
    80003034:	00008067          	ret

0000000080003038 <bench_lzip_validate>:
    80003038:	0001b517          	auipc	a0,0x1b
    8000303c:	82053503          	ld	a0,-2016(a0) # 8001d858 <compress>
    80003040:	0001b597          	auipc	a1,0x1b
    80003044:	8205a583          	lw	a1,-2016(a1) # 8001d860 <len>
    80003048:	ff010113          	addi	sp,sp,-16
    8000304c:	00b505b3          	add	a1,a0,a1
    80003050:	00113423          	sd	ra,8(sp)
    80003054:	e9cff0ef          	jal	ra,800026f0 <checksum>
    80003058:	0001a717          	auipc	a4,0x1a
    8000305c:	7c873703          	ld	a4,1992(a4) # 8001d820 <setting>
    80003060:	0005079b          	sext.w	a5,a0
    80003064:	01872503          	lw	a0,24(a4)
    80003068:	00813083          	ld	ra,8(sp)
    8000306c:	40f50533          	sub	a0,a0,a5
    80003070:	00153513          	seqz	a0,a0
    80003074:	01010113          	addi	sp,sp,16
    80003078:	00008067          	ret

000000008000307c <dfs>:
    8000307c:	fd010113          	addi	sp,sp,-48
    80003080:	01213823          	sd	s2,16(sp)
    80003084:	02113423          	sd	ra,40(sp)
    80003088:	02813023          	sd	s0,32(sp)
    8000308c:	00913c23          	sd	s1,24(sp)
    80003090:	01313423          	sd	s3,8(sp)
    80003094:	01413023          	sd	s4,0(sp)
    80003098:	0001a797          	auipc	a5,0x1a
    8000309c:	7d87a783          	lw	a5,2008(a5) # 8001d870 <FULL>
    800030a0:	00100913          	li	s2,1
    800030a4:	02a78463          	beq	a5,a0,800030cc <dfs+0x50>
    800030a8:	00c5e433          	or	s0,a1,a2
    800030ac:	00a46433          	or	s0,s0,a0
    800030b0:	fff44413          	not	s0,s0
    800030b4:	00050493          	mv	s1,a0
    800030b8:	00058993          	mv	s3,a1
    800030bc:	00060a13          	mv	s4,a2
    800030c0:	00f47433          	and	s0,s0,a5
    800030c4:	00000913          	li	s2,0
    800030c8:	02041463          	bnez	s0,800030f0 <dfs+0x74>
    800030cc:	02813083          	ld	ra,40(sp)
    800030d0:	02013403          	ld	s0,32(sp)
    800030d4:	01813483          	ld	s1,24(sp)
    800030d8:	00813983          	ld	s3,8(sp)
    800030dc:	00013a03          	ld	s4,0(sp)
    800030e0:	00090513          	mv	a0,s2
    800030e4:	01013903          	ld	s2,16(sp)
    800030e8:	03010113          	addi	sp,sp,48
    800030ec:	00008067          	ret
    800030f0:	408007bb          	negw	a5,s0
    800030f4:	00f477b3          	and	a5,s0,a5
    800030f8:	0007851b          	sext.w	a0,a5
    800030fc:	00aa6633          	or	a2,s4,a0
    80003100:	013565b3          	or	a1,a0,s3
    80003104:	0015959b          	slliw	a1,a1,0x1
    80003108:	0016561b          	srliw	a2,a2,0x1
    8000310c:	00956533          	or	a0,a0,s1
    80003110:	40f4043b          	subw	s0,s0,a5
    80003114:	f69ff0ef          	jal	ra,8000307c <dfs>
    80003118:	0125093b          	addw	s2,a0,s2
    8000311c:	fadff06f          	j	800030c8 <dfs+0x4c>

0000000080003120 <bench_queen_prepare>:
    80003120:	0001a797          	auipc	a5,0x1a
    80003124:	7407aa23          	sw	zero,1876(a5) # 8001d874 <ans>
    80003128:	0001a797          	auipc	a5,0x1a
    8000312c:	6f87b783          	ld	a5,1784(a5) # 8001d820 <setting>
    80003130:	0007a703          	lw	a4,0(a5)
    80003134:	00100793          	li	a5,1
    80003138:	00e797bb          	sllw	a5,a5,a4
    8000313c:	fff7879b          	addiw	a5,a5,-1
    80003140:	0001a717          	auipc	a4,0x1a
    80003144:	72f72823          	sw	a5,1840(a4) # 8001d870 <FULL>
    80003148:	00008067          	ret

000000008000314c <bench_queen_run>:
    8000314c:	ff010113          	addi	sp,sp,-16
    80003150:	00000613          	li	a2,0
    80003154:	00000593          	li	a1,0
    80003158:	00000513          	li	a0,0
    8000315c:	00113423          	sd	ra,8(sp)
    80003160:	f1dff0ef          	jal	ra,8000307c <dfs>
    80003164:	00813083          	ld	ra,8(sp)
    80003168:	0001a797          	auipc	a5,0x1a
    8000316c:	70a7a623          	sw	a0,1804(a5) # 8001d874 <ans>
    80003170:	01010113          	addi	sp,sp,16
    80003174:	00008067          	ret

0000000080003178 <bench_queen_validate>:
    80003178:	0001a797          	auipc	a5,0x1a
    8000317c:	6a87b783          	ld	a5,1704(a5) # 8001d820 <setting>
    80003180:	0187a503          	lw	a0,24(a5)
    80003184:	0001a797          	auipc	a5,0x1a
    80003188:	6f07a783          	lw	a5,1776(a5) # 8001d874 <ans>
    8000318c:	40f50533          	sub	a0,a0,a5
    80003190:	00153513          	seqz	a0,a0
    80003194:	00008067          	ret

0000000080003198 <get>:
    80003198:	40555793          	srai	a5,a0,0x5
    8000319c:	00279713          	slli	a4,a5,0x2
    800031a0:	0001a797          	auipc	a5,0x1a
    800031a4:	6e07b783          	ld	a5,1760(a5) # 8001d880 <primes>
    800031a8:	00e787b3          	add	a5,a5,a4
    800031ac:	0007a783          	lw	a5,0(a5)
    800031b0:	00a7d53b          	srlw	a0,a5,a0
    800031b4:	00157513          	andi	a0,a0,1
    800031b8:	00008067          	ret

00000000800031bc <bench_sieve_prepare>:
    800031bc:	0001a797          	auipc	a5,0x1a
    800031c0:	6647b783          	ld	a5,1636(a5) # 8001d820 <setting>
    800031c4:	0007a503          	lw	a0,0(a5)
    800031c8:	ff010113          	addi	sp,sp,-16
    800031cc:	00800793          	li	a5,8
    800031d0:	00813023          	sd	s0,0(sp)
    800031d4:	0001a417          	auipc	s0,0x1a
    800031d8:	6a440413          	addi	s0,s0,1700 # 8001d878 <N>
    800031dc:	00a42023          	sw	a0,0(s0)
    800031e0:	02f5453b          	divw	a0,a0,a5
    800031e4:	00113423          	sd	ra,8(sp)
    800031e8:	0805051b          	addiw	a0,a0,128
    800031ec:	c84ff0ef          	jal	ra,80002670 <bench_alloc>
    800031f0:	00042703          	lw	a4,0(s0)
    800031f4:	0001a797          	auipc	a5,0x1a
    800031f8:	68a7b623          	sd	a0,1676(a5) # 8001d880 <primes>
    800031fc:	02000793          	li	a5,32
    80003200:	02f7473b          	divw	a4,a4,a5
    80003204:	fff00613          	li	a2,-1
    80003208:	00000793          	li	a5,0
    8000320c:	0007869b          	sext.w	a3,a5
    80003210:	00d75a63          	bge	a4,a3,80003224 <bench_sieve_prepare+0x68>
    80003214:	00813083          	ld	ra,8(sp)
    80003218:	00013403          	ld	s0,0(sp)
    8000321c:	01010113          	addi	sp,sp,16
    80003220:	00008067          	ret
    80003224:	00279693          	slli	a3,a5,0x2
    80003228:	00d506b3          	add	a3,a0,a3
    8000322c:	00c6a023          	sw	a2,0(a3)
    80003230:	00178793          	addi	a5,a5,1
    80003234:	fd9ff06f          	j	8000320c <bench_sieve_prepare+0x50>

0000000080003238 <bench_sieve_run>:
    80003238:	fd010113          	addi	sp,sp,-48
    8000323c:	02813023          	sd	s0,32(sp)
    80003240:	00913c23          	sd	s1,24(sp)
    80003244:	02113423          	sd	ra,40(sp)
    80003248:	01213823          	sd	s2,16(sp)
    8000324c:	01313423          	sd	s3,8(sp)
    80003250:	0001a497          	auipc	s1,0x1a
    80003254:	6284a483          	lw	s1,1576(s1) # 8001d878 <N>
    80003258:	00100413          	li	s0,1
    8000325c:	0484d863          	bge	s1,s0,800032ac <bench_sieve_run+0x74>
    80003260:	0001a917          	auipc	s2,0x1a
    80003264:	62093903          	ld	s2,1568(s2) # 8001d880 <primes>
    80003268:	00200413          	li	s0,2
    8000326c:	00100993          	li	s3,1
    80003270:	028407bb          	mulw	a5,s0,s0
    80003274:	04f4d663          	bge	s1,a5,800032c0 <bench_sieve_run+0x88>
    80003278:	0001a797          	auipc	a5,0x1a
    8000327c:	6007a223          	sw	zero,1540(a5) # 8001d87c <ans>
    80003280:	00200413          	li	s0,2
    80003284:	0001a917          	auipc	s2,0x1a
    80003288:	5f890913          	addi	s2,s2,1528 # 8001d87c <ans>
    8000328c:	0684de63          	bge	s1,s0,80003308 <bench_sieve_run+0xd0>
    80003290:	02813083          	ld	ra,40(sp)
    80003294:	02013403          	ld	s0,32(sp)
    80003298:	01813483          	ld	s1,24(sp)
    8000329c:	01013903          	ld	s2,16(sp)
    800032a0:	00813983          	ld	s3,8(sp)
    800032a4:	03010113          	addi	sp,sp,48
    800032a8:	00008067          	ret
    800032ac:	00040513          	mv	a0,s0
    800032b0:	ee9ff0ef          	jal	ra,80003198 <get>
    800032b4:	fc050ee3          	beqz	a0,80003290 <bench_sieve_run+0x58>
    800032b8:	0014041b          	addiw	s0,s0,1
    800032bc:	fa1ff06f          	j	8000325c <bench_sieve_run+0x24>
    800032c0:	00040513          	mv	a0,s0
    800032c4:	ed5ff0ef          	jal	ra,80003198 <get>
    800032c8:	00051663          	bnez	a0,800032d4 <bench_sieve_run+0x9c>
    800032cc:	0014041b          	addiw	s0,s0,1
    800032d0:	fa1ff06f          	j	80003270 <bench_sieve_run+0x38>
    800032d4:	0014179b          	slliw	a5,s0,0x1
    800032d8:	fef4cae3          	blt	s1,a5,800032cc <bench_sieve_run+0x94>
    800032dc:	4057d693          	srai	a3,a5,0x5
    800032e0:	00269693          	slli	a3,a3,0x2
    800032e4:	00d906b3          	add	a3,s2,a3
    800032e8:	0006a603          	lw	a2,0(a3)
    800032ec:	01f7f713          	andi	a4,a5,31
    800032f0:	00e99733          	sll	a4,s3,a4
    800032f4:	fff74713          	not	a4,a4
    800032f8:	00c77733          	and	a4,a4,a2
    800032fc:	00e6a023          	sw	a4,0(a3)
    80003300:	00f407bb          	addw	a5,s0,a5
    80003304:	fd5ff06f          	j	800032d8 <bench_sieve_run+0xa0>
    80003308:	00040513          	mv	a0,s0
    8000330c:	e8dff0ef          	jal	ra,80003198 <get>
    80003310:	00050863          	beqz	a0,80003320 <bench_sieve_run+0xe8>
    80003314:	00092783          	lw	a5,0(s2)
    80003318:	0017879b          	addiw	a5,a5,1
    8000331c:	00f92023          	sw	a5,0(s2)
    80003320:	0014041b          	addiw	s0,s0,1
    80003324:	f69ff06f          	j	8000328c <bench_sieve_run+0x54>

0000000080003328 <bench_sieve_validate>:
    80003328:	0001a797          	auipc	a5,0x1a
    8000332c:	4f87b783          	ld	a5,1272(a5) # 8001d820 <setting>
    80003330:	0187a503          	lw	a0,24(a5)
    80003334:	0001a797          	auipc	a5,0x1a
    80003338:	5487a783          	lw	a5,1352(a5) # 8001d87c <ans>
    8000333c:	40f50533          	sub	a0,a0,a5
    80003340:	00153513          	seqz	a0,a0
    80003344:	00008067          	ret

0000000080003348 <bench_bf_prepare>:
    80003348:	0001a797          	auipc	a5,0x1a
    8000334c:	4d87b783          	ld	a5,1240(a5) # 8001d820 <setting>
    80003350:	0007a783          	lw	a5,0(a5)
    80003354:	fd010113          	addi	sp,sp,-48
    80003358:	00913c23          	sd	s1,24(sp)
    8000335c:	00004537          	lui	a0,0x4
    80003360:	0001a497          	auipc	s1,0x1a
    80003364:	52848493          	addi	s1,s1,1320 # 8001d888 <ARR_SIZE>
    80003368:	00f4a023          	sw	a5,0(s1)
    8000336c:	02113423          	sd	ra,40(sp)
    80003370:	02813023          	sd	s0,32(sp)
    80003374:	01213823          	sd	s2,16(sp)
    80003378:	01313423          	sd	s3,8(sp)
    8000337c:	01413023          	sd	s4,0(sp)
    80003380:	0001a797          	auipc	a5,0x1a
    80003384:	5007ac23          	sw	zero,1304(a5) # 8001d898 <SP>
    80003388:	ae8ff0ef          	jal	ra,80002670 <bench_alloc>
    8000338c:	0001a797          	auipc	a5,0x1a
    80003390:	50a7b223          	sd	a0,1284(a5) # 8001d890 <PROGRAM>
    80003394:	40000513          	li	a0,1024
    80003398:	ad8ff0ef          	jal	ra,80002670 <bench_alloc>
    8000339c:	0001a797          	auipc	a5,0x1a
    800033a0:	50a7b223          	sd	a0,1284(a5) # 8001d8a0 <STACK>
    800033a4:	00002537          	lui	a0,0x2
    800033a8:	ac8ff0ef          	jal	ra,80002670 <bench_alloc>
    800033ac:	0001a797          	auipc	a5,0x1a
    800033b0:	50a7b223          	sd	a0,1284(a5) # 8001d8b0 <data>
    800033b4:	0004a503          	lw	a0,0(s1)
    800033b8:	0000d797          	auipc	a5,0xd
    800033bc:	56878793          	addi	a5,a5,1384 # 80010920 <r+0x418>
    800033c0:	0001a717          	auipc	a4,0x1a
    800033c4:	4ef73423          	sd	a5,1256(a4) # 8001d8a8 <code>
    800033c8:	0015051b          	addiw	a0,a0,1
    800033cc:	aa4ff0ef          	jal	ra,80002670 <bench_alloc>
    800033d0:	0001a917          	auipc	s2,0x1a
    800033d4:	4e890913          	addi	s2,s2,1256 # 8001d8b8 <input>
    800033d8:	00a93023          	sd	a0,0(s2)
    800033dc:	00001537          	lui	a0,0x1
    800033e0:	a90ff0ef          	jal	ra,80002670 <bench_alloc>
    800033e4:	0001a797          	auipc	a5,0x1a
    800033e8:	4ea7b223          	sd	a0,1252(a5) # 8001d8c8 <output>
    800033ec:	00100513          	li	a0,1
    800033f0:	0001a797          	auipc	a5,0x1a
    800033f4:	4c07a823          	sw	zero,1232(a5) # 8001d8c0 <noutput>
    800033f8:	00000413          	li	s0,0
    800033fc:	aacff0ef          	jal	ra,800026a8 <bench_srand>
    80003400:	0000d997          	auipc	s3,0xd
    80003404:	5d898993          	addi	s3,s3,1496 # 800109d8 <r+0x4d0>
    80003408:	03e00a13          	li	s4,62
    8000340c:	0004a703          	lw	a4,0(s1)
    80003410:	0004079b          	sext.w	a5,s0
    80003414:	02e7c263          	blt	a5,a4,80003438 <bench_bf_prepare+0xf0>
    80003418:	02813083          	ld	ra,40(sp)
    8000341c:	02013403          	ld	s0,32(sp)
    80003420:	01813483          	ld	s1,24(sp)
    80003424:	01013903          	ld	s2,16(sp)
    80003428:	00813983          	ld	s3,8(sp)
    8000342c:	00013a03          	ld	s4,0(sp)
    80003430:	03010113          	addi	sp,sp,48
    80003434:	00008067          	ret
    80003438:	a84ff0ef          	jal	ra,800026bc <bench_rand>
    8000343c:	0345753b          	remuw	a0,a0,s4
    80003440:	00093783          	ld	a5,0(s2)
    80003444:	008787b3          	add	a5,a5,s0
    80003448:	00140413          	addi	s0,s0,1
    8000344c:	02051513          	slli	a0,a0,0x20
    80003450:	02055513          	srli	a0,a0,0x20
    80003454:	00a98533          	add	a0,s3,a0
    80003458:	00054703          	lbu	a4,0(a0) # 1000 <__STACKSIZE__-0x3000>
    8000345c:	00e78023          	sb	a4,0(a5)
    80003460:	fadff06f          	j	8000340c <bench_bf_prepare+0xc4>

0000000080003464 <bench_bf_run>:
    80003464:	0001a817          	auipc	a6,0x1a
    80003468:	43480813          	addi	a6,a6,1076 # 8001d898 <SP>
    8000346c:	0001a897          	auipc	a7,0x1a
    80003470:	43c88893          	addi	a7,a7,1084 # 8001d8a8 <code>
    80003474:	00082603          	lw	a2,0(a6)
    80003478:	0008b583          	ld	a1,0(a7)
    8000347c:	fa010113          	addi	sp,sp,-96
    80003480:	04813c23          	sd	s0,88(sp)
    80003484:	04913823          	sd	s1,80(sp)
    80003488:	05213423          	sd	s2,72(sp)
    8000348c:	05313023          	sd	s3,64(sp)
    80003490:	03413c23          	sd	s4,56(sp)
    80003494:	03513823          	sd	s5,48(sp)
    80003498:	03613423          	sd	s6,40(sp)
    8000349c:	03713023          	sd	s7,32(sp)
    800034a0:	01813c23          	sd	s8,24(sp)
    800034a4:	01913823          	sd	s9,16(sp)
    800034a8:	01a13423          	sd	s10,8(sp)
    800034ac:	01b13023          	sd	s11,0(sp)
    800034b0:	0001ae17          	auipc	t3,0x1a
    800034b4:	3f0e3e03          	ld	t3,1008(t3) # 8001d8a0 <STACK>
    800034b8:	0001a717          	auipc	a4,0x1a
    800034bc:	3d873703          	ld	a4,984(a4) # 8001d890 <PROGRAM>
    800034c0:	00000313          	li	t1,0
    800034c4:	00000513          	li	a0,0
    800034c8:	00000793          	li	a5,0
    800034cc:	03c00e93          	li	t4,60
    800034d0:	05b00293          	li	t0,91
    800034d4:	00700393          	li	t2,7
    800034d8:	20000413          	li	s0,512
    800034dc:	00100493          	li	s1,1
    800034e0:	05d00913          	li	s2,93
    800034e4:	00800993          	li	s3,8
    800034e8:	03e00a13          	li	s4,62
    800034ec:	02d00f13          	li	t5,45
    800034f0:	00400a93          	li	s5,4
    800034f4:	02e00b13          	li	s6,46
    800034f8:	00500b93          	li	s7,5
    800034fc:	02b00c13          	li	s8,43
    80003500:	00300c93          	li	s9,3
    80003504:	02c00d13          	li	s10,44
    80003508:	00600d93          	li	s11,6
    8000350c:	0005c683          	lbu	a3,0(a1)
    80003510:	00068663          	beqz	a3,8000351c <bench_bf_run+0xb8>
    80003514:	00001fb7          	lui	t6,0x1
    80003518:	03f7ea63          	bltu	a5,t6,8000354c <bench_bf_run+0xe8>
    8000351c:	00050463          	beqz	a0,80003524 <bench_bf_run+0xc0>
    80003520:	00c82023          	sw	a2,0(a6)
    80003524:	00030463          	beqz	t1,8000352c <bench_bf_run+0xc8>
    80003528:	00b8b023          	sd	a1,0(a7)
    8000352c:	00082683          	lw	a3,0(a6)
    80003530:	0e069663          	bnez	a3,8000361c <bench_bf_run+0x1b8>
    80003534:	000016b7          	lui	a3,0x1
    80003538:	0ed78263          	beq	a5,a3,8000361c <bench_bf_run+0x1b8>
    8000353c:	00279793          	slli	a5,a5,0x2
    80003540:	00f707b3          	add	a5,a4,a5
    80003544:	00079023          	sh	zero,0(a5)
    80003548:	0d40006f          	j	8000361c <bench_bf_run+0x1b8>
    8000354c:	07d68663          	beq	a3,t4,800035b8 <bench_bf_run+0x154>
    80003550:	02deec63          	bltu	t4,a3,80003588 <bench_bf_run+0x124>
    80003554:	09e68463          	beq	a3,t5,800035dc <bench_bf_run+0x178>
    80003558:	00df6e63          	bltu	t5,a3,80003574 <bench_bf_run+0x110>
    8000355c:	07868863          	beq	a3,s8,800035cc <bench_bf_run+0x168>
    80003560:	09a68663          	beq	a3,s10,800035ec <bench_bf_run+0x188>
    80003564:	fff7879b          	addiw	a5,a5,-1
    80003568:	03079793          	slli	a5,a5,0x30
    8000356c:	0307d793          	srli	a5,a5,0x30
    80003570:	0300006f          	j	800035a0 <bench_bf_run+0x13c>
    80003574:	ff6698e3          	bne	a3,s6,80003564 <bench_bf_run+0x100>
    80003578:	00279693          	slli	a3,a5,0x2
    8000357c:	00d706b3          	add	a3,a4,a3
    80003580:	01769023          	sh	s7,0(a3) # 1000 <__STACKSIZE__-0x3000>
    80003584:	01c0006f          	j	800035a0 <bench_bf_run+0x13c>
    80003588:	06568a63          	beq	a3,t0,800035fc <bench_bf_run+0x198>
    8000358c:	15268863          	beq	a3,s2,800036dc <bench_bf_run+0x278>
    80003590:	fd469ae3          	bne	a3,s4,80003564 <bench_bf_run+0x100>
    80003594:	00279693          	slli	a3,a5,0x2
    80003598:	00d706b3          	add	a3,a4,a3
    8000359c:	00969023          	sh	s1,0(a3)
    800035a0:	0017879b          	addiw	a5,a5,1
    800035a4:	03079793          	slli	a5,a5,0x30
    800035a8:	0307d793          	srli	a5,a5,0x30
    800035ac:	00158593          	addi	a1,a1,1
    800035b0:	00100313          	li	t1,1
    800035b4:	f59ff06f          	j	8000350c <bench_bf_run+0xa8>
    800035b8:	00279693          	slli	a3,a5,0x2
    800035bc:	00d706b3          	add	a3,a4,a3
    800035c0:	00200313          	li	t1,2
    800035c4:	00669023          	sh	t1,0(a3)
    800035c8:	fd9ff06f          	j	800035a0 <bench_bf_run+0x13c>
    800035cc:	00279693          	slli	a3,a5,0x2
    800035d0:	00d706b3          	add	a3,a4,a3
    800035d4:	01969023          	sh	s9,0(a3)
    800035d8:	fc9ff06f          	j	800035a0 <bench_bf_run+0x13c>
    800035dc:	00279693          	slli	a3,a5,0x2
    800035e0:	00d706b3          	add	a3,a4,a3
    800035e4:	01569023          	sh	s5,0(a3)
    800035e8:	fb9ff06f          	j	800035a0 <bench_bf_run+0x13c>
    800035ec:	00279693          	slli	a3,a5,0x2
    800035f0:	00d706b3          	add	a3,a4,a3
    800035f4:	01b69023          	sh	s11,0(a3)
    800035f8:	fa9ff06f          	j	800035a0 <bench_bf_run+0x13c>
    800035fc:	00279693          	slli	a3,a5,0x2
    80003600:	00d706b3          	add	a3,a4,a3
    80003604:	00769023          	sh	t2,0(a3)
    80003608:	0a861c63          	bne	a2,s0,800036c0 <bench_bf_run+0x25c>
    8000360c:	00050463          	beqz	a0,80003614 <bench_bf_run+0x1b0>
    80003610:	00c82023          	sw	a2,0(a6)
    80003614:	00030463          	beqz	t1,8000361c <bench_bf_run+0x1b8>
    80003618:	00b8b023          	sd	a1,0(a7)
    8000361c:	0001a317          	auipc	t1,0x1a
    80003620:	29c30313          	addi	t1,t1,668 # 8001d8b8 <input>
    80003624:	0001ae97          	auipc	t4,0x1a
    80003628:	29ce8e93          	addi	t4,t4,668 # 8001d8c0 <noutput>
    8000362c:	00033583          	ld	a1,0(t1)
    80003630:	000ea503          	lw	a0,0(t4)
    80003634:	0001a817          	auipc	a6,0x1a
    80003638:	27c83803          	ld	a6,636(a6) # 8001d8b0 <data>
    8000363c:	0001a397          	auipc	t2,0x1a
    80003640:	28c3b383          	ld	t2,652(t2) # 8001d8c8 <output>
    80003644:	00000e13          	li	t3,0
    80003648:	00000f13          	li	t5,0
    8000364c:	00000793          	li	a5,0
    80003650:	00000893          	li	a7,0
    80003654:	000012b7          	lui	t0,0x1
    80003658:	00700413          	li	s0,7
    8000365c:	0000df97          	auipc	t6,0xd
    80003660:	3bcf8f93          	addi	t6,t6,956 # 80010a18 <r+0x510>
    80003664:	02089613          	slli	a2,a7,0x20
    80003668:	01e65613          	srli	a2,a2,0x1e
    8000366c:	00c70633          	add	a2,a4,a2
    80003670:	00065683          	lhu	a3,0(a2)
    80003674:	16069a63          	bnez	a3,800037e8 <bench_bf_run+0x384>
    80003678:	000f0463          	beqz	t5,80003680 <bench_bf_run+0x21c>
    8000367c:	00aea023          	sw	a0,0(t4)
    80003680:	000e0463          	beqz	t3,80003688 <bench_bf_run+0x224>
    80003684:	00b33023          	sd	a1,0(t1)
    80003688:	05813403          	ld	s0,88(sp)
    8000368c:	05013483          	ld	s1,80(sp)
    80003690:	04813903          	ld	s2,72(sp)
    80003694:	04013983          	ld	s3,64(sp)
    80003698:	03813a03          	ld	s4,56(sp)
    8000369c:	03013a83          	ld	s5,48(sp)
    800036a0:	02813b03          	ld	s6,40(sp)
    800036a4:	02013b83          	ld	s7,32(sp)
    800036a8:	01813c03          	ld	s8,24(sp)
    800036ac:	01013c83          	ld	s9,16(sp)
    800036b0:	00813d03          	ld	s10,8(sp)
    800036b4:	00013d83          	ld	s11,0(sp)
    800036b8:	06010113          	addi	sp,sp,96
    800036bc:	00008067          	ret
    800036c0:	02061693          	slli	a3,a2,0x20
    800036c4:	01f6d693          	srli	a3,a3,0x1f
    800036c8:	00de06b3          	add	a3,t3,a3
    800036cc:	00f69023          	sh	a5,0(a3)
    800036d0:	0016061b          	addiw	a2,a2,1
    800036d4:	00100513          	li	a0,1
    800036d8:	ec9ff06f          	j	800035a0 <bench_bf_run+0x13c>
    800036dc:	00061a63          	bnez	a2,800036f0 <bench_bf_run+0x28c>
    800036e0:	f2050ae3          	beqz	a0,80003614 <bench_bf_run+0x1b0>
    800036e4:	0001a797          	auipc	a5,0x1a
    800036e8:	1a07aa23          	sw	zero,436(a5) # 8001d898 <SP>
    800036ec:	f29ff06f          	j	80003614 <bench_bf_run+0x1b0>
    800036f0:	fff6069b          	addiw	a3,a2,-1
    800036f4:	0006861b          	sext.w	a2,a3
    800036f8:	02069693          	slli	a3,a3,0x20
    800036fc:	01f6d693          	srli	a3,a3,0x1f
    80003700:	00de06b3          	add	a3,t3,a3
    80003704:	0006d683          	lhu	a3,0(a3)
    80003708:	00279513          	slli	a0,a5,0x2
    8000370c:	00a70533          	add	a0,a4,a0
    80003710:	00d51123          	sh	a3,2(a0)
    80003714:	00269693          	slli	a3,a3,0x2
    80003718:	01351023          	sh	s3,0(a0)
    8000371c:	00d706b3          	add	a3,a4,a3
    80003720:	00f69123          	sh	a5,2(a3)
    80003724:	fb1ff06f          	j	800036d4 <bench_bf_run+0x270>
    80003728:	0017879b          	addiw	a5,a5,1
    8000372c:	0018889b          	addiw	a7,a7,1
    80003730:	f35ff06f          	j	80003664 <bench_bf_run+0x200>
    80003734:	fff7879b          	addiw	a5,a5,-1
    80003738:	ff5ff06f          	j	8000372c <bench_bf_run+0x2c8>
    8000373c:	02079693          	slli	a3,a5,0x20
    80003740:	01f6d693          	srli	a3,a3,0x1f
    80003744:	00d806b3          	add	a3,a6,a3
    80003748:	0006d603          	lhu	a2,0(a3)
    8000374c:	0016061b          	addiw	a2,a2,1
    80003750:	00c69023          	sh	a2,0(a3)
    80003754:	fd9ff06f          	j	8000372c <bench_bf_run+0x2c8>
    80003758:	02079693          	slli	a3,a5,0x20
    8000375c:	01f6d693          	srli	a3,a3,0x1f
    80003760:	00d806b3          	add	a3,a6,a3
    80003764:	0006d603          	lhu	a2,0(a3)
    80003768:	fff6061b          	addiw	a2,a2,-1
    8000376c:	fe5ff06f          	j	80003750 <bench_bf_run+0x2ec>
    80003770:	02079693          	slli	a3,a5,0x20
    80003774:	01f6d693          	srli	a3,a3,0x1f
    80003778:	00d806b3          	add	a3,a6,a3
    8000377c:	0006d683          	lhu	a3,0(a3)
    80003780:	00a38633          	add	a2,t2,a0
    80003784:	00100f13          	li	t5,1
    80003788:	00d60023          	sb	a3,0(a2)
    8000378c:	0015051b          	addiw	a0,a0,1
    80003790:	f9dff06f          	j	8000372c <bench_bf_run+0x2c8>
    80003794:	0005c603          	lbu	a2,0(a1)
    80003798:	02079693          	slli	a3,a5,0x20
    8000379c:	01f6d693          	srli	a3,a3,0x1f
    800037a0:	00d806b3          	add	a3,a6,a3
    800037a4:	00c69023          	sh	a2,0(a3)
    800037a8:	00158593          	addi	a1,a1,1
    800037ac:	00100e13          	li	t3,1
    800037b0:	f7dff06f          	j	8000372c <bench_bf_run+0x2c8>
    800037b4:	02079693          	slli	a3,a5,0x20
    800037b8:	01f6d693          	srli	a3,a3,0x1f
    800037bc:	00d806b3          	add	a3,a6,a3
    800037c0:	0006d683          	lhu	a3,0(a3)
    800037c4:	f60694e3          	bnez	a3,8000372c <bench_bf_run+0x2c8>
    800037c8:	00265883          	lhu	a7,2(a2)
    800037cc:	f61ff06f          	j	8000372c <bench_bf_run+0x2c8>
    800037d0:	02079693          	slli	a3,a5,0x20
    800037d4:	01f6d693          	srli	a3,a3,0x1f
    800037d8:	00d806b3          	add	a3,a6,a3
    800037dc:	0006d683          	lhu	a3,0(a3)
    800037e0:	f40686e3          	beqz	a3,8000372c <bench_bf_run+0x2c8>
    800037e4:	fe5ff06f          	j	800037c8 <bench_bf_run+0x364>
    800037e8:	e857f8e3          	bgeu	a5,t0,80003678 <bench_bf_run+0x214>
    800037ec:	fff6869b          	addiw	a3,a3,-1
    800037f0:	03069493          	slli	s1,a3,0x30
    800037f4:	0304d493          	srli	s1,s1,0x30
    800037f8:	e89460e3          	bltu	s0,s1,80003678 <bench_bf_run+0x214>
    800037fc:	00249693          	slli	a3,s1,0x2
    80003800:	01f686b3          	add	a3,a3,t6
    80003804:	0006a683          	lw	a3,0(a3)
    80003808:	01f686b3          	add	a3,a3,t6
    8000380c:	00068067          	jr	a3

0000000080003810 <bench_bf_validate>:
    80003810:	ff010113          	addi	sp,sp,-16
    80003814:	00813023          	sd	s0,0(sp)
    80003818:	0001a417          	auipc	s0,0x1a
    8000381c:	0a840413          	addi	s0,s0,168 # 8001d8c0 <noutput>
    80003820:	00042583          	lw	a1,0(s0)
    80003824:	0001a517          	auipc	a0,0x1a
    80003828:	0a453503          	ld	a0,164(a0) # 8001d8c8 <output>
    8000382c:	00113423          	sd	ra,8(sp)
    80003830:	00b505b3          	add	a1,a0,a1
    80003834:	ebdfe0ef          	jal	ra,800026f0 <checksum>
    80003838:	00042683          	lw	a3,0(s0)
    8000383c:	0001a717          	auipc	a4,0x1a
    80003840:	04c72703          	lw	a4,76(a4) # 8001d888 <ARR_SIZE>
    80003844:	02e69663          	bne	a3,a4,80003870 <bench_bf_validate+0x60>
    80003848:	0001a717          	auipc	a4,0x1a
    8000384c:	fd873703          	ld	a4,-40(a4) # 8001d820 <setting>
    80003850:	0005079b          	sext.w	a5,a0
    80003854:	01872503          	lw	a0,24(a4)
    80003858:	40f50533          	sub	a0,a0,a5
    8000385c:	00153513          	seqz	a0,a0
    80003860:	00813083          	ld	ra,8(sp)
    80003864:	00013403          	ld	s0,0(sp)
    80003868:	01010113          	addi	sp,sp,16
    8000386c:	00008067          	ret
    80003870:	00000513          	li	a0,0
    80003874:	fedff06f          	j	80003860 <bench_bf_validate+0x50>

0000000080003878 <rt_hw_cpu_reset>:
    80003878:	00000513          	li	a0,0
    8000387c:	00000593          	li	a1,0
    80003880:	00000613          	li	a2,0
    80003884:	00000693          	li	a3,0
    80003888:	00000713          	li	a4,0
    8000388c:	00000813          	li	a6,0
    80003890:	00800893          	li	a7,8
    80003894:	00000073          	ecall
    80003898:	0000006f          	j	80003898 <rt_hw_cpu_reset+0x20>

000000008000389c <primary_cpu_entry>:
    8000389c:	0001a517          	auipc	a0,0x1a
    800038a0:	f2450513          	addi	a0,a0,-220 # 8001d7c0 <_ZL3ans>
    800038a4:	00023617          	auipc	a2,0x23
    800038a8:	31c60613          	addi	a2,a2,796 # 80026bc0 <__bss_end>
    800038ac:	ff010113          	addi	sp,sp,-16
    800038b0:	40a60633          	sub	a2,a2,a0
    800038b4:	00000593          	li	a1,0
    800038b8:	00113423          	sd	ra,8(sp)
    800038bc:	754020ef          	jal	ra,80006010 <rt_memset>
    800038c0:	f90fc0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    800038c4:	00813083          	ld	ra,8(sp)
    800038c8:	01010113          	addi	sp,sp,16
    800038cc:	0000406f          	j	800078cc <entry>

00000000800038d0 <rt_hw_board_init>:
    800038d0:	ff010113          	addi	sp,sp,-16
    800038d4:	00113423          	sd	ra,8(sp)
    800038d8:	00813023          	sd	s0,0(sp)
    800038dc:	659040ef          	jal	ra,80008734 <rt_hw_interrupt_init>
    800038e0:	16c000ef          	jal	ra,80003a4c <rt_hw_uart_init>
    800038e4:	06423617          	auipc	a2,0x6423
    800038e8:	2dc60613          	addi	a2,a2,732 # 86426bc0 <__bss_end+0x6400000>
    800038ec:	00023417          	auipc	s0,0x23
    800038f0:	2d440413          	addi	s0,s0,724 # 80026bc0 <__bss_end>
    800038f4:	00060593          	mv	a1,a2
    800038f8:	00040513          	mv	a0,s0
    800038fc:	4b8010ef          	jal	ra,80004db4 <rt_system_heap_init>
    80003900:	0000d517          	auipc	a0,0xd
    80003904:	13850513          	addi	a0,a0,312 # 80010a38 <r+0x530>
    80003908:	070030ef          	jal	ra,80006978 <rt_console_set_device>
    8000390c:	350050ef          	jal	ra,80008c5c <rt_hw_tick_init>
    80003910:	00040593          	mv	a1,s0
    80003914:	06423617          	auipc	a2,0x6423
    80003918:	2ac60613          	addi	a2,a2,684 # 86426bc0 <__bss_end+0x6400000>
    8000391c:	0000d517          	auipc	a0,0xd
    80003920:	12450513          	addi	a0,a0,292 # 80010a40 <r+0x538>
    80003924:	0c8030ef          	jal	ra,800069ec <rt_kprintf>
    80003928:	00013403          	ld	s0,0(sp)
    8000392c:	00813083          	ld	ra,8(sp)
    80003930:	01010113          	addi	sp,sp,16
    80003934:	6510306f          	j	80007784 <rt_components_board_init>

0000000080003938 <drv_uart_putc>:
    80003938:	00058513          	mv	a0,a1
    8000393c:	10000737          	lui	a4,0x10000
    80003940:	00574783          	lbu	a5,5(a4) # 10000005 <__STACKSIZE__+0xfffc005>
    80003944:	0207f793          	andi	a5,a5,32
    80003948:	fe078ce3          	beqz	a5,80003940 <drv_uart_putc+0x8>
    8000394c:	00a70023          	sb	a0,0(a4)
    80003950:	00008067          	ret

0000000080003954 <drv_uart_getc>:
    80003954:	10000737          	lui	a4,0x10000
    80003958:	00574783          	lbu	a5,5(a4) # 10000005 <__STACKSIZE__+0xfffc005>
    8000395c:	fff00513          	li	a0,-1
    80003960:	0017f793          	andi	a5,a5,1
    80003964:	00078663          	beqz	a5,80003970 <drv_uart_getc+0x1c>
    80003968:	00074503          	lbu	a0,0(a4)
    8000396c:	0ff57513          	zext.b	a0,a0
    80003970:	00008067          	ret

0000000080003974 <rt_uart_configure>:
    80003974:	fe010113          	addi	sp,sp,-32
    80003978:	00813823          	sd	s0,16(sp)
    8000397c:	00913423          	sd	s1,8(sp)
    80003980:	00113c23          	sd	ra,24(sp)
    80003984:	00050413          	mv	s0,a0
    80003988:	00058493          	mv	s1,a1
    8000398c:	00051e63          	bnez	a0,800039a8 <rt_uart_configure+0x34>
    80003990:	03a00613          	li	a2,58
    80003994:	0000d597          	auipc	a1,0xd
    80003998:	11458593          	addi	a1,a1,276 # 80010aa8 <__FUNCTION__.0>
    8000399c:	0000d517          	auipc	a0,0xd
    800039a0:	0e450513          	addi	a0,a0,228 # 80010a80 <__fsym___cmd_reboot_name+0x10>
    800039a4:	1d0030ef          	jal	ra,80006b74 <rt_assert_handler>
    800039a8:	0004a783          	lw	a5,0(s1)
    800039ac:	01813083          	ld	ra,24(sp)
    800039b0:	00000513          	li	a0,0
    800039b4:	08f42423          	sw	a5,136(s0)
    800039b8:	0044a783          	lw	a5,4(s1)
    800039bc:	00813483          	ld	s1,8(sp)
    800039c0:	08f42623          	sw	a5,140(s0)
    800039c4:	01013403          	ld	s0,16(sp)
    800039c8:	02010113          	addi	sp,sp,32
    800039cc:	00008067          	ret

00000000800039d0 <uart_control>:
    800039d0:	07853783          	ld	a5,120(a0)
    800039d4:	02079a63          	bnez	a5,80003a08 <uart_control+0x38>
    800039d8:	ff010113          	addi	sp,sp,-16
    800039dc:	0000d517          	auipc	a0,0xd
    800039e0:	0bc50513          	addi	a0,a0,188 # 80010a98 <__fsym___cmd_reboot_name+0x28>
    800039e4:	04700613          	li	a2,71
    800039e8:	0000d597          	auipc	a1,0xd
    800039ec:	0d858593          	addi	a1,a1,216 # 80010ac0 <__FUNCTION__.1>
    800039f0:	00113423          	sd	ra,8(sp)
    800039f4:	180030ef          	jal	ra,80006b74 <rt_assert_handler>
    800039f8:	00813083          	ld	ra,8(sp)
    800039fc:	00000513          	li	a0,0
    80003a00:	01010113          	addi	sp,sp,16
    80003a04:	00008067          	ret
    80003a08:	00000513          	li	a0,0
    80003a0c:	00008067          	ret

0000000080003a10 <virt_uart_init>:
    80003a10:	100007b7          	lui	a5,0x10000
    80003a14:	000780a3          	sb	zero,1(a5) # 10000001 <__STACKSIZE__+0xfffc001>
    80003a18:	0037c703          	lbu	a4,3(a5)
    80003a1c:	f8076713          	ori	a4,a4,-128
    80003a20:	0ff77713          	zext.b	a4,a4
    80003a24:	00e781a3          	sb	a4,3(a5)
    80003a28:	00300713          	li	a4,3
    80003a2c:	00e78023          	sb	a4,0(a5)
    80003a30:	000780a3          	sb	zero,1(a5)
    80003a34:	00e781a3          	sb	a4,3(a5)
    80003a38:	0017c703          	lbu	a4,1(a5)
    80003a3c:	0ff77713          	zext.b	a4,a4
    80003a40:	00176713          	ori	a4,a4,1
    80003a44:	00e780a3          	sb	a4,1(a5)
    80003a48:	00008067          	ret

0000000080003a4c <rt_hw_uart_init>:
    80003a4c:	ff010113          	addi	sp,sp,-16
    80003a50:	00113423          	sd	ra,8(sp)
    80003a54:	0001a517          	auipc	a0,0x1a
    80003a58:	fe450513          	addi	a0,a0,-28 # 8001da38 <serial1>
    80003a5c:	0000d797          	auipc	a5,0xd
    80003a60:	07478793          	addi	a5,a5,116 # 80010ad0 <_uart_ops>
    80003a64:	08f53023          	sd	a5,128(a0)
    80003a68:	00011797          	auipc	a5,0x11
    80003a6c:	3607b783          	ld	a5,864(a5) # 80014dc8 <__rt_init_end+0x440>
    80003a70:	0001a697          	auipc	a3,0x1a
    80003a74:	06868693          	addi	a3,a3,104 # 8001dad8 <uart1>
    80003a78:	08f53423          	sd	a5,136(a0)
    80003a7c:	100007b7          	lui	a5,0x10000
    80003a80:	00f6b023          	sd	a5,0(a3)
    80003a84:	00a00793          	li	a5,10
    80003a88:	00f6a423          	sw	a5,8(a3)
    80003a8c:	f85ff0ef          	jal	ra,80003a10 <virt_uart_init>
    80003a90:	0001a697          	auipc	a3,0x1a
    80003a94:	04868693          	addi	a3,a3,72 # 8001dad8 <uart1>
    80003a98:	04300613          	li	a2,67
    80003a9c:	0000d597          	auipc	a1,0xd
    80003aa0:	f9c58593          	addi	a1,a1,-100 # 80010a38 <r+0x530>
    80003aa4:	0001a517          	auipc	a0,0x1a
    80003aa8:	f9450513          	addi	a0,a0,-108 # 8001da38 <serial1>
    80003aac:	6a40c0ef          	jal	ra,80010150 <rt_hw_serial_register>
    80003ab0:	00813083          	ld	ra,8(sp)
    80003ab4:	00000513          	li	a0,0
    80003ab8:	01010113          	addi	sp,sp,16
    80003abc:	00008067          	ret

0000000080003ac0 <plic_claim>:
    80003ac0:	f14027f3          	csrr	a5,mhartid
    80003ac4:	00c7971b          	slliw	a4,a5,0xc
    80003ac8:	0c2007b7          	lui	a5,0xc200
    80003acc:	00e787b3          	add	a5,a5,a4
    80003ad0:	0047a503          	lw	a0,4(a5) # c200004 <__STACKSIZE__+0xc1fc004>
    80003ad4:	00008067          	ret

0000000080003ad8 <plic_complete>:
    80003ad8:	f14027f3          	csrr	a5,mhartid
    80003adc:	00c7971b          	slliw	a4,a5,0xc
    80003ae0:	0c2007b7          	lui	a5,0xc200
    80003ae4:	00e787b3          	add	a5,a5,a4
    80003ae8:	00a7a223          	sw	a0,4(a5) # c200004 <__STACKSIZE__+0xc1fc004>
    80003aec:	00008067          	ret

0000000080003af0 <strlen>:
    80003af0:	00d0206f          	j	800062fc <rt_strlen>

0000000080003af4 <strcpy>:
    80003af4:	00050793          	mv	a5,a0
    80003af8:	0005c703          	lbu	a4,0(a1)
    80003afc:	00071663          	bnez	a4,80003b08 <strcpy+0x14>
    80003b00:	00078023          	sb	zero,0(a5)
    80003b04:	00008067          	ret
    80003b08:	00e78023          	sb	a4,0(a5)
    80003b0c:	00158593          	addi	a1,a1,1
    80003b10:	00178793          	addi	a5,a5,1
    80003b14:	fe5ff06f          	j	80003af8 <strcpy+0x4>

0000000080003b18 <strncpy>:
    80003b18:	73c0206f          	j	80006254 <rt_strncpy>

0000000080003b1c <strcat>:
    80003b1c:	fe010113          	addi	sp,sp,-32
    80003b20:	00113c23          	sd	ra,24(sp)
    80003b24:	00813823          	sd	s0,16(sp)
    80003b28:	00b13423          	sd	a1,8(sp)
    80003b2c:	00050413          	mv	s0,a0
    80003b30:	7cc020ef          	jal	ra,800062fc <rt_strlen>
    80003b34:	00813583          	ld	a1,8(sp)
    80003b38:	00a40533          	add	a0,s0,a0
    80003b3c:	fb9ff0ef          	jal	ra,80003af4 <strcpy>
    80003b40:	01813083          	ld	ra,24(sp)
    80003b44:	00040513          	mv	a0,s0
    80003b48:	01013403          	ld	s0,16(sp)
    80003b4c:	02010113          	addi	sp,sp,32
    80003b50:	00008067          	ret

0000000080003b54 <strcmp>:
    80003b54:	7840206f          	j	800062d8 <rt_strcmp>

0000000080003b58 <strncmp>:
    80003b58:	7400206f          	j	80006298 <rt_strncmp>

0000000080003b5c <memset>:
    80003b5c:	4b40206f          	j	80006010 <rt_memset>

0000000080003b60 <memcpy>:
    80003b60:	5740206f          	j	800060d4 <rt_memcpy>

0000000080003b64 <memcmp>:
    80003b64:	6bc0206f          	j	80006220 <rt_memcmp>

0000000080003b68 <strstr>:
    80003b68:	7b00206f          	j	80006318 <rt_strstr>

0000000080003b6c <strrchr>:
    80003b6c:	00050c63          	beqz	a0,80003b84 <strrchr+0x18>
    80003b70:	00050793          	mv	a5,a0
    80003b74:	0ff5f593          	zext.b	a1,a1
    80003b78:	00000513          	li	a0,0
    80003b7c:	0007c703          	lbu	a4,0(a5)
    80003b80:	00071463          	bnez	a4,80003b88 <strrchr+0x1c>
    80003b84:	00008067          	ret
    80003b88:	00e59463          	bne	a1,a4,80003b90 <strrchr+0x24>
    80003b8c:	00078513          	mv	a0,a5
    80003b90:	00178793          	addi	a5,a5,1
    80003b94:	fe9ff06f          	j	80003b7c <strrchr+0x10>

0000000080003b98 <sprintf>:
    80003b98:	fb010113          	addi	sp,sp,-80
    80003b9c:	02c13023          	sd	a2,32(sp)
    80003ba0:	02010613          	addi	a2,sp,32
    80003ba4:	00113c23          	sd	ra,24(sp)
    80003ba8:	02d13423          	sd	a3,40(sp)
    80003bac:	02e13823          	sd	a4,48(sp)
    80003bb0:	02f13c23          	sd	a5,56(sp)
    80003bb4:	05013023          	sd	a6,64(sp)
    80003bb8:	05113423          	sd	a7,72(sp)
    80003bbc:	00c13423          	sd	a2,8(sp)
    80003bc0:	565020ef          	jal	ra,80006924 <rt_vsprintf>
    80003bc4:	01813083          	ld	ra,24(sp)
    80003bc8:	00000513          	li	a0,0
    80003bcc:	05010113          	addi	sp,sp,80
    80003bd0:	00008067          	ret

0000000080003bd4 <atoi>:
    80003bd4:	00050793          	mv	a5,a0
    80003bd8:	02000713          	li	a4,32
    80003bdc:	0007c683          	lbu	a3,0(a5)
    80003be0:	02e68263          	beq	a3,a4,80003c04 <atoi+0x30>
    80003be4:	00000513          	li	a0,0
    80003be8:	00900613          	li	a2,9
    80003bec:	00a00593          	li	a1,10
    80003bf0:	0007c683          	lbu	a3,0(a5)
    80003bf4:	fd06871b          	addiw	a4,a3,-48
    80003bf8:	0ff77713          	zext.b	a4,a4
    80003bfc:	00e67863          	bgeu	a2,a4,80003c0c <atoi+0x38>
    80003c00:	00008067          	ret
    80003c04:	00178793          	addi	a5,a5,1
    80003c08:	fd5ff06f          	j	80003bdc <atoi+0x8>
    80003c0c:	02a5853b          	mulw	a0,a1,a0
    80003c10:	00178793          	addi	a5,a5,1
    80003c14:	00d5053b          	addw	a0,a0,a3
    80003c18:	fd05051b          	addiw	a0,a0,-48
    80003c1c:	fd5ff06f          	j	80003bf0 <atoi+0x1c>

0000000080003c20 <malloc>:
    80003c20:	3040106f          	j	80004f24 <rt_malloc>

0000000080003c24 <rt_interrupt_enter>:
    80003c24:	fe010113          	addi	sp,sp,-32
    80003c28:	00113c23          	sd	ra,24(sp)
    80003c2c:	c24fc0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80003c30:	0001a797          	auipc	a5,0x1a
    80003c34:	cb07c783          	lbu	a5,-848(a5) # 8001d8e0 <rt_interrupt_nest>
    80003c38:	0017879b          	addiw	a5,a5,1
    80003c3c:	0001a717          	auipc	a4,0x1a
    80003c40:	caf70223          	sb	a5,-860(a4) # 8001d8e0 <rt_interrupt_nest>
    80003c44:	0001a797          	auipc	a5,0x1a
    80003c48:	c8c7b783          	ld	a5,-884(a5) # 8001d8d0 <rt_interrupt_enter_hook>
    80003c4c:	00078863          	beqz	a5,80003c5c <rt_interrupt_enter+0x38>
    80003c50:	00a13423          	sd	a0,8(sp)
    80003c54:	000780e7          	jalr	a5
    80003c58:	00813503          	ld	a0,8(sp)
    80003c5c:	01813083          	ld	ra,24(sp)
    80003c60:	02010113          	addi	sp,sp,32
    80003c64:	bf4fc06f          	j	80000058 <rt_hw_interrupt_enable>

0000000080003c68 <rt_interrupt_leave>:
    80003c68:	fe010113          	addi	sp,sp,-32
    80003c6c:	00113c23          	sd	ra,24(sp)
    80003c70:	be0fc0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80003c74:	0001a797          	auipc	a5,0x1a
    80003c78:	c647b783          	ld	a5,-924(a5) # 8001d8d8 <rt_interrupt_leave_hook>
    80003c7c:	00078863          	beqz	a5,80003c8c <rt_interrupt_leave+0x24>
    80003c80:	00a13423          	sd	a0,8(sp)
    80003c84:	000780e7          	jalr	a5
    80003c88:	00813503          	ld	a0,8(sp)
    80003c8c:	0001a797          	auipc	a5,0x1a
    80003c90:	c547c783          	lbu	a5,-940(a5) # 8001d8e0 <rt_interrupt_nest>
    80003c94:	01813083          	ld	ra,24(sp)
    80003c98:	fff7879b          	addiw	a5,a5,-1
    80003c9c:	0001a717          	auipc	a4,0x1a
    80003ca0:	c4f70223          	sb	a5,-956(a4) # 8001d8e0 <rt_interrupt_nest>
    80003ca4:	02010113          	addi	sp,sp,32
    80003ca8:	bb0fc06f          	j	80000058 <rt_hw_interrupt_enable>

0000000080003cac <rt_interrupt_get_nest>:
    80003cac:	ff010113          	addi	sp,sp,-16
    80003cb0:	00113423          	sd	ra,8(sp)
    80003cb4:	00813023          	sd	s0,0(sp)
    80003cb8:	b98fc0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80003cbc:	0001a417          	auipc	s0,0x1a
    80003cc0:	c2444403          	lbu	s0,-988(s0) # 8001d8e0 <rt_interrupt_nest>
    80003cc4:	b94fc0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80003cc8:	00813083          	ld	ra,8(sp)
    80003ccc:	00040513          	mv	a0,s0
    80003cd0:	00013403          	ld	s0,0(sp)
    80003cd4:	01010113          	addi	sp,sp,16
    80003cd8:	00008067          	ret

0000000080003cdc <_rt_timer_remove>:
    80003cdc:	02853683          	ld	a3,40(a0)
    80003ce0:	03053703          	ld	a4,48(a0)
    80003ce4:	02850793          	addi	a5,a0,40
    80003ce8:	00e6b423          	sd	a4,8(a3)
    80003cec:	00d73023          	sd	a3,0(a4)
    80003cf0:	02f53823          	sd	a5,48(a0)
    80003cf4:	02f53423          	sd	a5,40(a0)
    80003cf8:	00008067          	ret

0000000080003cfc <rt_timer_init>:
    80003cfc:	fc010113          	addi	sp,sp,-64
    80003d00:	02813823          	sd	s0,48(sp)
    80003d04:	02913423          	sd	s1,40(sp)
    80003d08:	03213023          	sd	s2,32(sp)
    80003d0c:	01313c23          	sd	s3,24(sp)
    80003d10:	01413823          	sd	s4,16(sp)
    80003d14:	01513423          	sd	s5,8(sp)
    80003d18:	02113c23          	sd	ra,56(sp)
    80003d1c:	00050413          	mv	s0,a0
    80003d20:	00058a93          	mv	s5,a1
    80003d24:	00060a13          	mv	s4,a2
    80003d28:	00068993          	mv	s3,a3
    80003d2c:	00070913          	mv	s2,a4
    80003d30:	00078493          	mv	s1,a5
    80003d34:	00051e63          	bnez	a0,80003d50 <rt_timer_init+0x54>
    80003d38:	0c900613          	li	a2,201
    80003d3c:	0000d597          	auipc	a1,0xd
    80003d40:	ecc58593          	addi	a1,a1,-308 # 80010c08 <__FUNCTION__.6>
    80003d44:	0000d517          	auipc	a0,0xd
    80003d48:	db450513          	addi	a0,a0,-588 # 80010af8 <_uart_ops+0x28>
    80003d4c:	629020ef          	jal	ra,80006b74 <rt_assert_handler>
    80003d50:	000a8613          	mv	a2,s5
    80003d54:	00040513          	mv	a0,s0
    80003d58:	00a00593          	li	a1,10
    80003d5c:	3c9030ef          	jal	ra,80007924 <rt_object_init>
    80003d60:	02840793          	addi	a5,s0,40
    80003d64:	ffe4f493          	andi	s1,s1,-2
    80003d68:	00940aa3          	sb	s1,21(s0)
    80003d6c:	03443c23          	sd	s4,56(s0)
    80003d70:	05343023          	sd	s3,64(s0)
    80003d74:	05242423          	sw	s2,72(s0)
    80003d78:	03813083          	ld	ra,56(sp)
    80003d7c:	04042623          	sw	zero,76(s0)
    80003d80:	02f43823          	sd	a5,48(s0)
    80003d84:	02f43423          	sd	a5,40(s0)
    80003d88:	03013403          	ld	s0,48(sp)
    80003d8c:	02813483          	ld	s1,40(sp)
    80003d90:	02013903          	ld	s2,32(sp)
    80003d94:	01813983          	ld	s3,24(sp)
    80003d98:	01013a03          	ld	s4,16(sp)
    80003d9c:	00813a83          	ld	s5,8(sp)
    80003da0:	04010113          	addi	sp,sp,64
    80003da4:	00008067          	ret

0000000080003da8 <rt_timer_detach>:
    80003da8:	fe010113          	addi	sp,sp,-32
    80003dac:	00813823          	sd	s0,16(sp)
    80003db0:	00113c23          	sd	ra,24(sp)
    80003db4:	00913423          	sd	s1,8(sp)
    80003db8:	00050413          	mv	s0,a0
    80003dbc:	00051e63          	bnez	a0,80003dd8 <rt_timer_detach+0x30>
    80003dc0:	0de00613          	li	a2,222
    80003dc4:	0000d597          	auipc	a1,0xd
    80003dc8:	e3458593          	addi	a1,a1,-460 # 80010bf8 <__FUNCTION__.5>
    80003dcc:	0000d517          	auipc	a0,0xd
    80003dd0:	d2c50513          	addi	a0,a0,-724 # 80010af8 <_uart_ops+0x28>
    80003dd4:	5a1020ef          	jal	ra,80006b74 <rt_assert_handler>
    80003dd8:	00040513          	mv	a0,s0
    80003ddc:	6c9030ef          	jal	ra,80007ca4 <rt_object_get_type>
    80003de0:	00a00793          	li	a5,10
    80003de4:	00f50e63          	beq	a0,a5,80003e00 <rt_timer_detach+0x58>
    80003de8:	0df00613          	li	a2,223
    80003dec:	0000d597          	auipc	a1,0xd
    80003df0:	e0c58593          	addi	a1,a1,-500 # 80010bf8 <__FUNCTION__.5>
    80003df4:	0000d517          	auipc	a0,0xd
    80003df8:	d1c50513          	addi	a0,a0,-740 # 80010b10 <_uart_ops+0x40>
    80003dfc:	579020ef          	jal	ra,80006b74 <rt_assert_handler>
    80003e00:	00040513          	mv	a0,s0
    80003e04:	65d030ef          	jal	ra,80007c60 <rt_object_is_systemobject>
    80003e08:	00051e63          	bnez	a0,80003e24 <rt_timer_detach+0x7c>
    80003e0c:	0e000613          	li	a2,224
    80003e10:	0000d597          	auipc	a1,0xd
    80003e14:	de858593          	addi	a1,a1,-536 # 80010bf8 <__FUNCTION__.5>
    80003e18:	0000d517          	auipc	a0,0xd
    80003e1c:	d3850513          	addi	a0,a0,-712 # 80010b50 <_uart_ops+0x80>
    80003e20:	555020ef          	jal	ra,80006b74 <rt_assert_handler>
    80003e24:	a2cfc0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80003e28:	00050493          	mv	s1,a0
    80003e2c:	00040513          	mv	a0,s0
    80003e30:	eadff0ef          	jal	ra,80003cdc <_rt_timer_remove>
    80003e34:	01544783          	lbu	a5,21(s0)
    80003e38:	00048513          	mv	a0,s1
    80003e3c:	ffe7f793          	andi	a5,a5,-2
    80003e40:	00f40aa3          	sb	a5,21(s0)
    80003e44:	a14fc0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80003e48:	00040513          	mv	a0,s0
    80003e4c:	3ed030ef          	jal	ra,80007a38 <rt_object_detach>
    80003e50:	01813083          	ld	ra,24(sp)
    80003e54:	01013403          	ld	s0,16(sp)
    80003e58:	00813483          	ld	s1,8(sp)
    80003e5c:	00000513          	li	a0,0
    80003e60:	02010113          	addi	sp,sp,32
    80003e64:	00008067          	ret

0000000080003e68 <rt_timer_start>:
    80003e68:	fe010113          	addi	sp,sp,-32
    80003e6c:	00813823          	sd	s0,16(sp)
    80003e70:	00113c23          	sd	ra,24(sp)
    80003e74:	00913423          	sd	s1,8(sp)
    80003e78:	00050413          	mv	s0,a0
    80003e7c:	00051e63          	bnez	a0,80003e98 <rt_timer_start+0x30>
    80003e80:	14500613          	li	a2,325
    80003e84:	0000d597          	auipc	a1,0xd
    80003e88:	d6458593          	addi	a1,a1,-668 # 80010be8 <__FUNCTION__.3>
    80003e8c:	0000d517          	auipc	a0,0xd
    80003e90:	c6c50513          	addi	a0,a0,-916 # 80010af8 <_uart_ops+0x28>
    80003e94:	4e1020ef          	jal	ra,80006b74 <rt_assert_handler>
    80003e98:	00040513          	mv	a0,s0
    80003e9c:	609030ef          	jal	ra,80007ca4 <rt_object_get_type>
    80003ea0:	00a00793          	li	a5,10
    80003ea4:	00f50e63          	beq	a0,a5,80003ec0 <rt_timer_start+0x58>
    80003ea8:	14600613          	li	a2,326
    80003eac:	0000d597          	auipc	a1,0xd
    80003eb0:	d3c58593          	addi	a1,a1,-708 # 80010be8 <__FUNCTION__.3>
    80003eb4:	0000d517          	auipc	a0,0xd
    80003eb8:	c5c50513          	addi	a0,a0,-932 # 80010b10 <_uart_ops+0x40>
    80003ebc:	4b9020ef          	jal	ra,80006b74 <rt_assert_handler>
    80003ec0:	990fc0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80003ec4:	00050493          	mv	s1,a0
    80003ec8:	00040513          	mv	a0,s0
    80003ecc:	e11ff0ef          	jal	ra,80003cdc <_rt_timer_remove>
    80003ed0:	01544783          	lbu	a5,21(s0)
    80003ed4:	ffe7f793          	andi	a5,a5,-2
    80003ed8:	00f40aa3          	sb	a5,21(s0)
    80003edc:	0001a797          	auipc	a5,0x1a
    80003ee0:	adc7b783          	ld	a5,-1316(a5) # 8001d9b8 <rt_object_take_hook>
    80003ee4:	00078663          	beqz	a5,80003ef0 <rt_timer_start+0x88>
    80003ee8:	00040513          	mv	a0,s0
    80003eec:	000780e7          	jalr	a5
    80003ef0:	04842703          	lw	a4,72(s0)
    80003ef4:	800007b7          	lui	a5,0x80000
    80003ef8:	ffe7c793          	xori	a5,a5,-2
    80003efc:	00e7fe63          	bgeu	a5,a4,80003f18 <rt_timer_start+0xb0>
    80003f00:	15500613          	li	a2,341
    80003f04:	0000d597          	auipc	a1,0xd
    80003f08:	ce458593          	addi	a1,a1,-796 # 80010be8 <__FUNCTION__.3>
    80003f0c:	0000d517          	auipc	a0,0xd
    80003f10:	c7450513          	addi	a0,a0,-908 # 80010b80 <_uart_ops+0xb0>
    80003f14:	461020ef          	jal	ra,80006b74 <rt_assert_handler>
    80003f18:	4b1020ef          	jal	ra,80006bc8 <rt_tick_get>
    80003f1c:	04842783          	lw	a5,72(s0)
    80003f20:	01544703          	lbu	a4,21(s0)
    80003f24:	00a7853b          	addw	a0,a5,a0
    80003f28:	04a42623          	sw	a0,76(s0)
    80003f2c:	00477693          	andi	a3,a4,4
    80003f30:	0001a797          	auipc	a5,0x1a
    80003f34:	bb878793          	addi	a5,a5,-1096 # 8001dae8 <rt_soft_timer_list>
    80003f38:	00069663          	bnez	a3,80003f44 <rt_timer_start+0xdc>
    80003f3c:	0001a797          	auipc	a5,0x1a
    80003f40:	bbc78793          	addi	a5,a5,-1092 # 8001daf8 <rt_timer_list>
    80003f44:	0087b803          	ld	a6,8(a5)
    80003f48:	800005b7          	lui	a1,0x80000
    80003f4c:	ffe5c593          	xori	a1,a1,-2
    80003f50:	00078613          	mv	a2,a5
    80003f54:	0007b783          	ld	a5,0(a5)
    80003f58:	00c80a63          	beq	a6,a2,80003f6c <rt_timer_start+0x104>
    80003f5c:	0247a683          	lw	a3,36(a5)
    80003f60:	fed508e3          	beq	a0,a3,80003f50 <rt_timer_start+0xe8>
    80003f64:	40a686bb          	subw	a3,a3,a0
    80003f68:	fed5e4e3          	bltu	a1,a3,80003f50 <rt_timer_start+0xe8>
    80003f6c:	0001a597          	auipc	a1,0x1a
    80003f70:	97858593          	addi	a1,a1,-1672 # 8001d8e4 <random_nr.2>
    80003f74:	0005a683          	lw	a3,0(a1)
    80003f78:	00176713          	ori	a4,a4,1
    80003f7c:	00048513          	mv	a0,s1
    80003f80:	0016869b          	addiw	a3,a3,1
    80003f84:	00d5a023          	sw	a3,0(a1)
    80003f88:	02840693          	addi	a3,s0,40
    80003f8c:	00d7b423          	sd	a3,8(a5)
    80003f90:	02f43423          	sd	a5,40(s0)
    80003f94:	00d63023          	sd	a3,0(a2)
    80003f98:	02c43823          	sd	a2,48(s0)
    80003f9c:	00e40aa3          	sb	a4,21(s0)
    80003fa0:	8b8fc0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80003fa4:	01544783          	lbu	a5,21(s0)
    80003fa8:	0047f793          	andi	a5,a5,4
    80003fac:	02078a63          	beqz	a5,80003fe0 <rt_timer_start+0x178>
    80003fb0:	00011717          	auipc	a4,0x11
    80003fb4:	7f474703          	lbu	a4,2036(a4) # 800157a4 <soft_timer_status>
    80003fb8:	00100793          	li	a5,1
    80003fbc:	02f71263          	bne	a4,a5,80003fe0 <rt_timer_start+0x178>
    80003fc0:	0001a517          	auipc	a0,0x1a
    80003fc4:	b4850513          	addi	a0,a0,-1208 # 8001db08 <timer_thread>
    80003fc8:	06854783          	lbu	a5,104(a0)
    80003fcc:	00200713          	li	a4,2
    80003fd0:	0077f793          	andi	a5,a5,7
    80003fd4:	00e79663          	bne	a5,a4,80003fe0 <rt_timer_start+0x178>
    80003fd8:	4ac030ef          	jal	ra,80007484 <rt_thread_resume>
    80003fdc:	77c000ef          	jal	ra,80004758 <rt_schedule>
    80003fe0:	01813083          	ld	ra,24(sp)
    80003fe4:	01013403          	ld	s0,16(sp)
    80003fe8:	00813483          	ld	s1,8(sp)
    80003fec:	00000513          	li	a0,0
    80003ff0:	02010113          	addi	sp,sp,32
    80003ff4:	00008067          	ret

0000000080003ff8 <rt_timer_stop>:
    80003ff8:	fe010113          	addi	sp,sp,-32
    80003ffc:	00813823          	sd	s0,16(sp)
    80004000:	00113c23          	sd	ra,24(sp)
    80004004:	00913423          	sd	s1,8(sp)
    80004008:	00050413          	mv	s0,a0
    8000400c:	00051e63          	bnez	a0,80004028 <rt_timer_stop+0x30>
    80004010:	1bb00613          	li	a2,443
    80004014:	0000d597          	auipc	a1,0xd
    80004018:	bc458593          	addi	a1,a1,-1084 # 80010bd8 <__FUNCTION__.1>
    8000401c:	0000d517          	auipc	a0,0xd
    80004020:	adc50513          	addi	a0,a0,-1316 # 80010af8 <_uart_ops+0x28>
    80004024:	351020ef          	jal	ra,80006b74 <rt_assert_handler>
    80004028:	00040513          	mv	a0,s0
    8000402c:	479030ef          	jal	ra,80007ca4 <rt_object_get_type>
    80004030:	00a00793          	li	a5,10
    80004034:	00f50e63          	beq	a0,a5,80004050 <rt_timer_stop+0x58>
    80004038:	1bc00613          	li	a2,444
    8000403c:	0000d597          	auipc	a1,0xd
    80004040:	b9c58593          	addi	a1,a1,-1124 # 80010bd8 <__FUNCTION__.1>
    80004044:	0000d517          	auipc	a0,0xd
    80004048:	acc50513          	addi	a0,a0,-1332 # 80010b10 <_uart_ops+0x40>
    8000404c:	329020ef          	jal	ra,80006b74 <rt_assert_handler>
    80004050:	01544783          	lbu	a5,21(s0)
    80004054:	fff00513          	li	a0,-1
    80004058:	0017f793          	andi	a5,a5,1
    8000405c:	04078063          	beqz	a5,8000409c <rt_timer_stop+0xa4>
    80004060:	0001a797          	auipc	a5,0x1a
    80004064:	9507b783          	ld	a5,-1712(a5) # 8001d9b0 <rt_object_put_hook>
    80004068:	00078663          	beqz	a5,80004074 <rt_timer_stop+0x7c>
    8000406c:	00040513          	mv	a0,s0
    80004070:	000780e7          	jalr	a5
    80004074:	fddfb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80004078:	00050493          	mv	s1,a0
    8000407c:	00040513          	mv	a0,s0
    80004080:	c5dff0ef          	jal	ra,80003cdc <_rt_timer_remove>
    80004084:	01544783          	lbu	a5,21(s0)
    80004088:	00048513          	mv	a0,s1
    8000408c:	ffe7f793          	andi	a5,a5,-2
    80004090:	00f40aa3          	sb	a5,21(s0)
    80004094:	fc5fb0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80004098:	00000513          	li	a0,0
    8000409c:	01813083          	ld	ra,24(sp)
    800040a0:	01013403          	ld	s0,16(sp)
    800040a4:	00813483          	ld	s1,8(sp)
    800040a8:	02010113          	addi	sp,sp,32
    800040ac:	00008067          	ret

00000000800040b0 <rt_timer_control>:
    800040b0:	fe010113          	addi	sp,sp,-32
    800040b4:	00813823          	sd	s0,16(sp)
    800040b8:	00913423          	sd	s1,8(sp)
    800040bc:	01213023          	sd	s2,0(sp)
    800040c0:	00113c23          	sd	ra,24(sp)
    800040c4:	00050413          	mv	s0,a0
    800040c8:	00058493          	mv	s1,a1
    800040cc:	00060913          	mv	s2,a2
    800040d0:	00051e63          	bnez	a0,800040ec <rt_timer_control+0x3c>
    800040d4:	1df00613          	li	a2,479
    800040d8:	0000d597          	auipc	a1,0xd
    800040dc:	ae858593          	addi	a1,a1,-1304 # 80010bc0 <__FUNCTION__.0>
    800040e0:	0000d517          	auipc	a0,0xd
    800040e4:	a1850513          	addi	a0,a0,-1512 # 80010af8 <_uart_ops+0x28>
    800040e8:	28d020ef          	jal	ra,80006b74 <rt_assert_handler>
    800040ec:	00040513          	mv	a0,s0
    800040f0:	3b5030ef          	jal	ra,80007ca4 <rt_object_get_type>
    800040f4:	00a00793          	li	a5,10
    800040f8:	00f50e63          	beq	a0,a5,80004114 <rt_timer_control+0x64>
    800040fc:	1e000613          	li	a2,480
    80004100:	0000d597          	auipc	a1,0xd
    80004104:	ac058593          	addi	a1,a1,-1344 # 80010bc0 <__FUNCTION__.0>
    80004108:	0000d517          	auipc	a0,0xd
    8000410c:	a0850513          	addi	a0,a0,-1528 # 80010b10 <_uart_ops+0x40>
    80004110:	265020ef          	jal	ra,80006b74 <rt_assert_handler>
    80004114:	f3dfb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80004118:	00400793          	li	a5,4
    8000411c:	0297ea63          	bltu	a5,s1,80004150 <rt_timer_control+0xa0>
    80004120:	0000d717          	auipc	a4,0xd
    80004124:	a8470713          	addi	a4,a4,-1404 # 80010ba4 <_uart_ops+0xd4>
    80004128:	00249493          	slli	s1,s1,0x2
    8000412c:	00e484b3          	add	s1,s1,a4
    80004130:	0004a783          	lw	a5,0(s1)
    80004134:	00e787b3          	add	a5,a5,a4
    80004138:	00078067          	jr	a5
    8000413c:	04842783          	lw	a5,72(s0)
    80004140:	00f92023          	sw	a5,0(s2)
    80004144:	00c0006f          	j	80004150 <rt_timer_control+0xa0>
    80004148:	00092783          	lw	a5,0(s2)
    8000414c:	04f42423          	sw	a5,72(s0)
    80004150:	f09fb0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80004154:	01813083          	ld	ra,24(sp)
    80004158:	01013403          	ld	s0,16(sp)
    8000415c:	00813483          	ld	s1,8(sp)
    80004160:	00013903          	ld	s2,0(sp)
    80004164:	00000513          	li	a0,0
    80004168:	02010113          	addi	sp,sp,32
    8000416c:	00008067          	ret
    80004170:	01544783          	lbu	a5,21(s0)
    80004174:	ffd7f793          	andi	a5,a5,-3
    80004178:	00f40aa3          	sb	a5,21(s0)
    8000417c:	fd5ff06f          	j	80004150 <rt_timer_control+0xa0>
    80004180:	01544783          	lbu	a5,21(s0)
    80004184:	0027e793          	ori	a5,a5,2
    80004188:	ff1ff06f          	j	80004178 <rt_timer_control+0xc8>
    8000418c:	01544783          	lbu	a5,21(s0)
    80004190:	0017f793          	andi	a5,a5,1
    80004194:	00078663          	beqz	a5,800041a0 <rt_timer_control+0xf0>
    80004198:	00100793          	li	a5,1
    8000419c:	fa5ff06f          	j	80004140 <rt_timer_control+0x90>
    800041a0:	00092023          	sw	zero,0(s2)
    800041a4:	fadff06f          	j	80004150 <rt_timer_control+0xa0>

00000000800041a8 <rt_timer_check>:
    800041a8:	f9010113          	addi	sp,sp,-112
    800041ac:	05213823          	sd	s2,80(sp)
    800041b0:	00010913          	mv	s2,sp
    800041b4:	06113423          	sd	ra,104(sp)
    800041b8:	04913c23          	sd	s1,88(sp)
    800041bc:	05413023          	sd	s4,64(sp)
    800041c0:	03513c23          	sd	s5,56(sp)
    800041c4:	03613823          	sd	s6,48(sp)
    800041c8:	03713423          	sd	s7,40(sp)
    800041cc:	03813023          	sd	s8,32(sp)
    800041d0:	01913c23          	sd	s9,24(sp)
    800041d4:	06813023          	sd	s0,96(sp)
    800041d8:	05313423          	sd	s3,72(sp)
    800041dc:	01213423          	sd	s2,8(sp)
    800041e0:	01213023          	sd	s2,0(sp)
    800041e4:	1e5020ef          	jal	ra,80006bc8 <rt_tick_get>
    800041e8:	0005049b          	sext.w	s1,a0
    800041ec:	80000ab7          	lui	s5,0x80000
    800041f0:	e61fb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    800041f4:	00050a13          	mv	s4,a0
    800041f8:	0001ab17          	auipc	s6,0x1a
    800041fc:	900b0b13          	addi	s6,s6,-1792 # 8001daf8 <rt_timer_list>
    80004200:	ffeaca93          	xori	s5,s5,-2
    80004204:	00019b97          	auipc	s7,0x19
    80004208:	6e4b8b93          	addi	s7,s7,1764 # 8001d8e8 <rt_timer_enter_hook>
    8000420c:	00019c17          	auipc	s8,0x19
    80004210:	6e4c0c13          	addi	s8,s8,1764 # 8001d8f0 <rt_timer_exit_hook>
    80004214:	00300c93          	li	s9,3
    80004218:	000b3403          	ld	s0,0(s6)
    8000421c:	05641063          	bne	s0,s6,8000425c <rt_timer_check+0xb4>
    80004220:	000a0513          	mv	a0,s4
    80004224:	e35fb0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80004228:	06813083          	ld	ra,104(sp)
    8000422c:	06013403          	ld	s0,96(sp)
    80004230:	05813483          	ld	s1,88(sp)
    80004234:	05013903          	ld	s2,80(sp)
    80004238:	04813983          	ld	s3,72(sp)
    8000423c:	04013a03          	ld	s4,64(sp)
    80004240:	03813a83          	ld	s5,56(sp)
    80004244:	03013b03          	ld	s6,48(sp)
    80004248:	02813b83          	ld	s7,40(sp)
    8000424c:	02013c03          	ld	s8,32(sp)
    80004250:	01813c83          	ld	s9,24(sp)
    80004254:	07010113          	addi	sp,sp,112
    80004258:	00008067          	ret
    8000425c:	02442503          	lw	a0,36(s0)
    80004260:	fd840993          	addi	s3,s0,-40
    80004264:	40a484bb          	subw	s1,s1,a0
    80004268:	fa9aece3          	bltu	s5,s1,80004220 <rt_timer_check+0x78>
    8000426c:	000bb783          	ld	a5,0(s7)
    80004270:	00078663          	beqz	a5,8000427c <rt_timer_check+0xd4>
    80004274:	00098513          	mv	a0,s3
    80004278:	000780e7          	jalr	a5
    8000427c:	00098513          	mv	a0,s3
    80004280:	a5dff0ef          	jal	ra,80003cdc <_rt_timer_remove>
    80004284:	fed44783          	lbu	a5,-19(s0)
    80004288:	0027f713          	andi	a4,a5,2
    8000428c:	00071663          	bnez	a4,80004298 <rt_timer_check+0xf0>
    80004290:	ffe7f793          	andi	a5,a5,-2
    80004294:	fef406a3          	sb	a5,-19(s0)
    80004298:	00013783          	ld	a5,0(sp)
    8000429c:	01843503          	ld	a0,24(s0)
    800042a0:	0087b423          	sd	s0,8(a5)
    800042a4:	00f43023          	sd	a5,0(s0)
    800042a8:	01043783          	ld	a5,16(s0)
    800042ac:	00813023          	sd	s0,0(sp)
    800042b0:	01243423          	sd	s2,8(s0)
    800042b4:	000780e7          	jalr	a5
    800042b8:	111020ef          	jal	ra,80006bc8 <rt_tick_get>
    800042bc:	000c3783          	ld	a5,0(s8)
    800042c0:	0005049b          	sext.w	s1,a0
    800042c4:	00078663          	beqz	a5,800042d0 <rt_timer_check+0x128>
    800042c8:	00098513          	mv	a0,s3
    800042cc:	000780e7          	jalr	a5
    800042d0:	00013783          	ld	a5,0(sp)
    800042d4:	f52782e3          	beq	a5,s2,80004218 <rt_timer_check+0x70>
    800042d8:	00043703          	ld	a4,0(s0)
    800042dc:	00843783          	ld	a5,8(s0)
    800042e0:	00f73423          	sd	a5,8(a4)
    800042e4:	00e7b023          	sd	a4,0(a5)
    800042e8:	fed44783          	lbu	a5,-19(s0)
    800042ec:	00843423          	sd	s0,8(s0)
    800042f0:	00843023          	sd	s0,0(s0)
    800042f4:	0037f713          	andi	a4,a5,3
    800042f8:	f39710e3          	bne	a4,s9,80004218 <rt_timer_check+0x70>
    800042fc:	ffe7f793          	andi	a5,a5,-2
    80004300:	fef406a3          	sb	a5,-19(s0)
    80004304:	00098513          	mv	a0,s3
    80004308:	b61ff0ef          	jal	ra,80003e68 <rt_timer_start>
    8000430c:	f0dff06f          	j	80004218 <rt_timer_check+0x70>

0000000080004310 <rt_soft_timer_check>:
    80004310:	f9010113          	addi	sp,sp,-112
    80004314:	05213823          	sd	s2,80(sp)
    80004318:	00010913          	mv	s2,sp
    8000431c:	04913c23          	sd	s1,88(sp)
    80004320:	05413023          	sd	s4,64(sp)
    80004324:	03513c23          	sd	s5,56(sp)
    80004328:	03613823          	sd	s6,48(sp)
    8000432c:	03713423          	sd	s7,40(sp)
    80004330:	03813023          	sd	s8,32(sp)
    80004334:	01913c23          	sd	s9,24(sp)
    80004338:	01a13823          	sd	s10,16(sp)
    8000433c:	06113423          	sd	ra,104(sp)
    80004340:	06813023          	sd	s0,96(sp)
    80004344:	05313423          	sd	s3,72(sp)
    80004348:	01213423          	sd	s2,8(sp)
    8000434c:	01213023          	sd	s2,0(sp)
    80004350:	80000a37          	lui	s4,0x80000
    80004354:	cfdfb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80004358:	00050493          	mv	s1,a0
    8000435c:	00019a97          	auipc	s5,0x19
    80004360:	78ca8a93          	addi	s5,s5,1932 # 8001dae8 <rt_soft_timer_list>
    80004364:	ffea4a13          	xori	s4,s4,-2
    80004368:	00019b17          	auipc	s6,0x19
    8000436c:	580b0b13          	addi	s6,s6,1408 # 8001d8e8 <rt_timer_enter_hook>
    80004370:	00019b97          	auipc	s7,0x19
    80004374:	580b8b93          	addi	s7,s7,1408 # 8001d8f0 <rt_timer_exit_hook>
    80004378:	00011c17          	auipc	s8,0x11
    8000437c:	42cc0c13          	addi	s8,s8,1068 # 800157a4 <soft_timer_status>
    80004380:	00100c93          	li	s9,1
    80004384:	00300d13          	li	s10,3
    80004388:	000ab403          	ld	s0,0(s5)
    8000438c:	01540c63          	beq	s0,s5,800043a4 <rt_soft_timer_check+0x94>
    80004390:	039020ef          	jal	ra,80006bc8 <rt_tick_get>
    80004394:	02442783          	lw	a5,36(s0)
    80004398:	fd840993          	addi	s3,s0,-40
    8000439c:	40f5053b          	subw	a0,a0,a5
    800043a0:	04aa7263          	bgeu	s4,a0,800043e4 <rt_soft_timer_check+0xd4>
    800043a4:	00048513          	mv	a0,s1
    800043a8:	cb1fb0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    800043ac:	06813083          	ld	ra,104(sp)
    800043b0:	06013403          	ld	s0,96(sp)
    800043b4:	05813483          	ld	s1,88(sp)
    800043b8:	05013903          	ld	s2,80(sp)
    800043bc:	04813983          	ld	s3,72(sp)
    800043c0:	04013a03          	ld	s4,64(sp)
    800043c4:	03813a83          	ld	s5,56(sp)
    800043c8:	03013b03          	ld	s6,48(sp)
    800043cc:	02813b83          	ld	s7,40(sp)
    800043d0:	02013c03          	ld	s8,32(sp)
    800043d4:	01813c83          	ld	s9,24(sp)
    800043d8:	01013d03          	ld	s10,16(sp)
    800043dc:	07010113          	addi	sp,sp,112
    800043e0:	00008067          	ret
    800043e4:	000b3783          	ld	a5,0(s6)
    800043e8:	00078663          	beqz	a5,800043f4 <rt_soft_timer_check+0xe4>
    800043ec:	00098513          	mv	a0,s3
    800043f0:	000780e7          	jalr	a5
    800043f4:	00098513          	mv	a0,s3
    800043f8:	8e5ff0ef          	jal	ra,80003cdc <_rt_timer_remove>
    800043fc:	fed44783          	lbu	a5,-19(s0)
    80004400:	0027f713          	andi	a4,a5,2
    80004404:	00071663          	bnez	a4,80004410 <rt_soft_timer_check+0x100>
    80004408:	ffe7f793          	andi	a5,a5,-2
    8000440c:	fef406a3          	sb	a5,-19(s0)
    80004410:	00013783          	ld	a5,0(sp)
    80004414:	00048513          	mv	a0,s1
    80004418:	0087b423          	sd	s0,8(a5)
    8000441c:	00f43023          	sd	a5,0(s0)
    80004420:	01243423          	sd	s2,8(s0)
    80004424:	00011797          	auipc	a5,0x11
    80004428:	38078023          	sb	zero,896(a5) # 800157a4 <soft_timer_status>
    8000442c:	00813023          	sd	s0,0(sp)
    80004430:	c29fb0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80004434:	01043783          	ld	a5,16(s0)
    80004438:	01843503          	ld	a0,24(s0)
    8000443c:	000780e7          	jalr	a5
    80004440:	000bb783          	ld	a5,0(s7)
    80004444:	00078663          	beqz	a5,80004450 <rt_soft_timer_check+0x140>
    80004448:	00098513          	mv	a0,s3
    8000444c:	000780e7          	jalr	a5
    80004450:	c01fb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80004454:	00013783          	ld	a5,0(sp)
    80004458:	019c0023          	sb	s9,0(s8)
    8000445c:	00050493          	mv	s1,a0
    80004460:	f32784e3          	beq	a5,s2,80004388 <rt_soft_timer_check+0x78>
    80004464:	00043703          	ld	a4,0(s0)
    80004468:	00843783          	ld	a5,8(s0)
    8000446c:	00f73423          	sd	a5,8(a4)
    80004470:	00e7b023          	sd	a4,0(a5)
    80004474:	fed44783          	lbu	a5,-19(s0)
    80004478:	00843423          	sd	s0,8(s0)
    8000447c:	00843023          	sd	s0,0(s0)
    80004480:	0037f713          	andi	a4,a5,3
    80004484:	f1a712e3          	bne	a4,s10,80004388 <rt_soft_timer_check+0x78>
    80004488:	ffe7f793          	andi	a5,a5,-2
    8000448c:	fef406a3          	sb	a5,-19(s0)
    80004490:	00098513          	mv	a0,s3
    80004494:	9d5ff0ef          	jal	ra,80003e68 <rt_timer_start>
    80004498:	ef1ff06f          	j	80004388 <rt_soft_timer_check+0x78>

000000008000449c <rt_thread_timer_entry>:
    8000449c:	fd010113          	addi	sp,sp,-48
    800044a0:	00913c23          	sd	s1,24(sp)
    800044a4:	800004b7          	lui	s1,0x80000
    800044a8:	01213823          	sd	s2,16(sp)
    800044ac:	01313423          	sd	s3,8(sp)
    800044b0:	02113423          	sd	ra,40(sp)
    800044b4:	02813023          	sd	s0,32(sp)
    800044b8:	00019917          	auipc	s2,0x19
    800044bc:	63090913          	addi	s2,s2,1584 # 8001dae8 <rt_soft_timer_list>
    800044c0:	fff00993          	li	s3,-1
    800044c4:	ffe4c493          	xori	s1,s1,-2
    800044c8:	b89fb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    800044cc:	00093783          	ld	a5,0(s2)
    800044d0:	fff00413          	li	s0,-1
    800044d4:	01278463          	beq	a5,s2,800044dc <rt_thread_timer_entry+0x40>
    800044d8:	0247a403          	lw	s0,36(a5)
    800044dc:	b7dfb0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    800044e0:	01341c63          	bne	s0,s3,800044f8 <rt_thread_timer_entry+0x5c>
    800044e4:	31d020ef          	jal	ra,80007000 <rt_thread_self>
    800044e8:	5b1020ef          	jal	ra,80007298 <rt_thread_suspend>
    800044ec:	26c000ef          	jal	ra,80004758 <rt_schedule>
    800044f0:	e21ff0ef          	jal	ra,80004310 <rt_soft_timer_check>
    800044f4:	fd5ff06f          	j	800044c8 <rt_thread_timer_entry+0x2c>
    800044f8:	6d0020ef          	jal	ra,80006bc8 <rt_tick_get>
    800044fc:	40a4053b          	subw	a0,s0,a0
    80004500:	fea4e8e3          	bltu	s1,a0,800044f0 <rt_thread_timer_entry+0x54>
    80004504:	761020ef          	jal	ra,80007464 <rt_thread_delay>
    80004508:	fe9ff06f          	j	800044f0 <rt_thread_timer_entry+0x54>

000000008000450c <rt_system_timer_init>:
    8000450c:	00019797          	auipc	a5,0x19
    80004510:	5ec78793          	addi	a5,a5,1516 # 8001daf8 <rt_timer_list>
    80004514:	00f7b423          	sd	a5,8(a5)
    80004518:	00f7b023          	sd	a5,0(a5)
    8000451c:	00008067          	ret

0000000080004520 <rt_system_timer_thread_init>:
    80004520:	ff010113          	addi	sp,sp,-16
    80004524:	00813023          	sd	s0,0(sp)
    80004528:	00113423          	sd	ra,8(sp)
    8000452c:	00019797          	auipc	a5,0x19
    80004530:	5bc78793          	addi	a5,a5,1468 # 8001dae8 <rt_soft_timer_list>
    80004534:	00019417          	auipc	s0,0x19
    80004538:	5d440413          	addi	s0,s0,1492 # 8001db08 <timer_thread>
    8000453c:	00f7b423          	sd	a5,8(a5)
    80004540:	00f7b023          	sd	a5,0(a5)
    80004544:	00040513          	mv	a0,s0
    80004548:	00a00893          	li	a7,10
    8000454c:	00400813          	li	a6,4
    80004550:	000047b7          	lui	a5,0x4
    80004554:	00019717          	auipc	a4,0x19
    80004558:	69c70713          	addi	a4,a4,1692 # 8001dbf0 <timer_thread_stack>
    8000455c:	00000693          	li	a3,0
    80004560:	00000617          	auipc	a2,0x0
    80004564:	f3c60613          	addi	a2,a2,-196 # 8000449c <rt_thread_timer_entry>
    80004568:	0000c597          	auipc	a1,0xc
    8000456c:	65058593          	addi	a1,a1,1616 # 80010bb8 <_uart_ops+0xe8>
    80004570:	1b9020ef          	jal	ra,80006f28 <rt_thread_init>
    80004574:	00040513          	mv	a0,s0
    80004578:	00013403          	ld	s0,0(sp)
    8000457c:	00813083          	ld	ra,8(sp)
    80004580:	01010113          	addi	sp,sp,16
    80004584:	7d90206f          	j	8000755c <rt_thread_startup>

0000000080004588 <rt_system_scheduler_init>:
    80004588:	00019797          	auipc	a5,0x19
    8000458c:	38079423          	sh	zero,904(a5) # 8001d910 <rt_scheduler_lock_nest>
    80004590:	0001d797          	auipc	a5,0x1d
    80004594:	66078793          	addi	a5,a5,1632 # 80021bf0 <rt_thread_priority_table>
    80004598:	0001e717          	auipc	a4,0x1e
    8000459c:	85870713          	addi	a4,a4,-1960 # 80021df0 <heap_sem>
    800045a0:	00f7b423          	sd	a5,8(a5)
    800045a4:	00f7b023          	sd	a5,0(a5)
    800045a8:	01078793          	addi	a5,a5,16
    800045ac:	fee79ae3          	bne	a5,a4,800045a0 <rt_system_scheduler_init+0x18>
    800045b0:	00019797          	auipc	a5,0x19
    800045b4:	3607a823          	sw	zero,880(a5) # 8001d920 <rt_thread_ready_priority_group>
    800045b8:	00008067          	ret

00000000800045bc <rt_schedule_insert_thread>:
    800045bc:	ff010113          	addi	sp,sp,-16
    800045c0:	00813023          	sd	s0,0(sp)
    800045c4:	00113423          	sd	ra,8(sp)
    800045c8:	00050413          	mv	s0,a0
    800045cc:	00051e63          	bnez	a0,800045e8 <rt_schedule_insert_thread+0x2c>
    800045d0:	2c700613          	li	a2,711
    800045d4:	0000c597          	auipc	a1,0xc
    800045d8:	67c58593          	addi	a1,a1,1660 # 80010c50 <__FUNCTION__.1>
    800045dc:	0000c517          	auipc	a0,0xc
    800045e0:	63c50513          	addi	a0,a0,1596 # 80010c18 <__FUNCTION__.6+0x10>
    800045e4:	590020ef          	jal	ra,80006b74 <rt_assert_handler>
    800045e8:	a69fb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    800045ec:	06844783          	lbu	a5,104(s0)
    800045f0:	00019717          	auipc	a4,0x19
    800045f4:	31073703          	ld	a4,784(a4) # 8001d900 <rt_current_thread>
    800045f8:	ff87f793          	andi	a5,a5,-8
    800045fc:	00871e63          	bne	a4,s0,80004618 <rt_schedule_insert_thread+0x5c>
    80004600:	0037e793          	ori	a5,a5,3
    80004604:	06f40423          	sb	a5,104(s0)
    80004608:	00013403          	ld	s0,0(sp)
    8000460c:	00813083          	ld	ra,8(sp)
    80004610:	01010113          	addi	sp,sp,16
    80004614:	a45fb06f          	j	80000058 <rt_hw_interrupt_enable>
    80004618:	06944703          	lbu	a4,105(s0)
    8000461c:	0017e793          	ori	a5,a5,1
    80004620:	06f40423          	sb	a5,104(s0)
    80004624:	00471693          	slli	a3,a4,0x4
    80004628:	0001d797          	auipc	a5,0x1d
    8000462c:	5c878793          	addi	a5,a5,1480 # 80021bf0 <rt_thread_priority_table>
    80004630:	00d786b3          	add	a3,a5,a3
    80004634:	0086b583          	ld	a1,8(a3)
    80004638:	02840613          	addi	a2,s0,40
    8000463c:	00019717          	auipc	a4,0x19
    80004640:	2e470713          	addi	a4,a4,740 # 8001d920 <rt_thread_ready_priority_group>
    80004644:	00c5b023          	sd	a2,0(a1)
    80004648:	02b43823          	sd	a1,48(s0)
    8000464c:	00c6b423          	sd	a2,8(a3)
    80004650:	06c42783          	lw	a5,108(s0)
    80004654:	02d43423          	sd	a3,40(s0)
    80004658:	00072683          	lw	a3,0(a4)
    8000465c:	00d7e7b3          	or	a5,a5,a3
    80004660:	00f72023          	sw	a5,0(a4)
    80004664:	fa5ff06f          	j	80004608 <rt_schedule_insert_thread+0x4c>

0000000080004668 <rt_schedule_remove_thread>:
    80004668:	ff010113          	addi	sp,sp,-16
    8000466c:	00813023          	sd	s0,0(sp)
    80004670:	00113423          	sd	ra,8(sp)
    80004674:	00050413          	mv	s0,a0
    80004678:	00051e63          	bnez	a0,80004694 <rt_schedule_remove_thread+0x2c>
    8000467c:	32800613          	li	a2,808
    80004680:	0000c597          	auipc	a1,0xc
    80004684:	5b058593          	addi	a1,a1,1456 # 80010c30 <__FUNCTION__.0>
    80004688:	0000c517          	auipc	a0,0xc
    8000468c:	59050513          	addi	a0,a0,1424 # 80010c18 <__FUNCTION__.6+0x10>
    80004690:	4e4020ef          	jal	ra,80006b74 <rt_assert_handler>
    80004694:	9bdfb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80004698:	02843683          	ld	a3,40(s0)
    8000469c:	03043703          	ld	a4,48(s0)
    800046a0:	02840793          	addi	a5,s0,40
    800046a4:	00e6b423          	sd	a4,8(a3)
    800046a8:	00d73023          	sd	a3,0(a4)
    800046ac:	06944703          	lbu	a4,105(s0)
    800046b0:	02f43823          	sd	a5,48(s0)
    800046b4:	02f43423          	sd	a5,40(s0)
    800046b8:	00471693          	slli	a3,a4,0x4
    800046bc:	0001d797          	auipc	a5,0x1d
    800046c0:	53478793          	addi	a5,a5,1332 # 80021bf0 <rt_thread_priority_table>
    800046c4:	00d786b3          	add	a3,a5,a3
    800046c8:	0006b783          	ld	a5,0(a3)
    800046cc:	02d79063          	bne	a5,a3,800046ec <rt_schedule_remove_thread+0x84>
    800046d0:	00019717          	auipc	a4,0x19
    800046d4:	25070713          	addi	a4,a4,592 # 8001d920 <rt_thread_ready_priority_group>
    800046d8:	06c42783          	lw	a5,108(s0)
    800046dc:	00072683          	lw	a3,0(a4)
    800046e0:	fff7c793          	not	a5,a5
    800046e4:	00d7f7b3          	and	a5,a5,a3
    800046e8:	00f72023          	sw	a5,0(a4)
    800046ec:	00013403          	ld	s0,0(sp)
    800046f0:	00813083          	ld	ra,8(sp)
    800046f4:	01010113          	addi	sp,sp,16
    800046f8:	961fb06f          	j	80000058 <rt_hw_interrupt_enable>

00000000800046fc <rt_system_scheduler_start>:
    800046fc:	ff010113          	addi	sp,sp,-16
    80004700:	00019517          	auipc	a0,0x19
    80004704:	22052503          	lw	a0,544(a0) # 8001d920 <rt_thread_ready_priority_group>
    80004708:	00113423          	sd	ra,8(sp)
    8000470c:	00813023          	sd	s0,0(sp)
    80004710:	3e0020ef          	jal	ra,80006af0 <__rt_ffs>
    80004714:	fff5051b          	addiw	a0,a0,-1
    80004718:	0001d797          	auipc	a5,0x1d
    8000471c:	4d878793          	addi	a5,a5,1240 # 80021bf0 <rt_thread_priority_table>
    80004720:	00451513          	slli	a0,a0,0x4
    80004724:	00a78533          	add	a0,a5,a0
    80004728:	00053403          	ld	s0,0(a0)
    8000472c:	fd840513          	addi	a0,s0,-40
    80004730:	00019797          	auipc	a5,0x19
    80004734:	1ca7b823          	sd	a0,464(a5) # 8001d900 <rt_current_thread>
    80004738:	f31ff0ef          	jal	ra,80004668 <rt_schedule_remove_thread>
    8000473c:	00300793          	li	a5,3
    80004740:	04f40023          	sb	a5,64(s0)
    80004744:	01040513          	addi	a0,s0,16
    80004748:	00013403          	ld	s0,0(sp)
    8000474c:	00813083          	ld	ra,8(sp)
    80004750:	01010113          	addi	sp,sp,16
    80004754:	90dfb06f          	j	80000060 <rt_hw_context_switch_to>

0000000080004758 <rt_schedule>:
    80004758:	fc010113          	addi	sp,sp,-64
    8000475c:	03213023          	sd	s2,32(sp)
    80004760:	02113c23          	sd	ra,56(sp)
    80004764:	02813823          	sd	s0,48(sp)
    80004768:	02913423          	sd	s1,40(sp)
    8000476c:	01313c23          	sd	s3,24(sp)
    80004770:	01413823          	sd	s4,16(sp)
    80004774:	8ddfb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80004778:	00019797          	auipc	a5,0x19
    8000477c:	19879783          	lh	a5,408(a5) # 8001d910 <rt_scheduler_lock_nest>
    80004780:	00050913          	mv	s2,a0
    80004784:	0e079e63          	bnez	a5,80004880 <rt_schedule+0x128>
    80004788:	00019517          	auipc	a0,0x19
    8000478c:	19852503          	lw	a0,408(a0) # 8001d920 <rt_thread_ready_priority_group>
    80004790:	0e050863          	beqz	a0,80004880 <rt_schedule+0x128>
    80004794:	35c020ef          	jal	ra,80006af0 <__rt_ffs>
    80004798:	00019997          	auipc	s3,0x19
    8000479c:	16898993          	addi	s3,s3,360 # 8001d900 <rt_current_thread>
    800047a0:	0009b483          	ld	s1,0(s3)
    800047a4:	fff5079b          	addiw	a5,a0,-1
    800047a8:	00479693          	slli	a3,a5,0x4
    800047ac:	0001d717          	auipc	a4,0x1d
    800047b0:	44470713          	addi	a4,a4,1092 # 80021bf0 <rt_thread_priority_table>
    800047b4:	00d70733          	add	a4,a4,a3
    800047b8:	00073403          	ld	s0,0(a4)
    800047bc:	0684c703          	lbu	a4,104(s1) # ffffffff80000068 <__bss_end+0xfffffffefffd94a8>
    800047c0:	00300693          	li	a3,3
    800047c4:	fd840413          	addi	s0,s0,-40
    800047c8:	00777613          	andi	a2,a4,7
    800047cc:	00000a13          	li	s4,0
    800047d0:	02d61663          	bne	a2,a3,800047fc <rt_schedule+0xa4>
    800047d4:	0694c683          	lbu	a3,105(s1)
    800047d8:	0cf6e663          	bltu	a3,a5,800048a4 <rt_schedule+0x14c>
    800047dc:	00100a13          	li	s4,1
    800047e0:	00f69a63          	bne	a3,a5,800047f4 <rt_schedule+0x9c>
    800047e4:	00877693          	andi	a3,a4,8
    800047e8:	00069663          	bnez	a3,800047f4 <rt_schedule+0x9c>
    800047ec:	00048413          	mv	s0,s1
    800047f0:	00000a13          	li	s4,0
    800047f4:	ff777713          	andi	a4,a4,-9
    800047f8:	06e48423          	sb	a4,104(s1)
    800047fc:	0a848e63          	beq	s1,s0,800048b8 <rt_schedule+0x160>
    80004800:	00019717          	auipc	a4,0x19
    80004804:	0ef70c23          	sb	a5,248(a4) # 8001d8f8 <rt_current_priority>
    80004808:	0089b023          	sd	s0,0(s3)
    8000480c:	00019797          	auipc	a5,0x19
    80004810:	0fc7b783          	ld	a5,252(a5) # 8001d908 <rt_scheduler_hook>
    80004814:	00078863          	beqz	a5,80004824 <rt_schedule+0xcc>
    80004818:	00040593          	mv	a1,s0
    8000481c:	00048513          	mv	a0,s1
    80004820:	000780e7          	jalr	a5
    80004824:	000a0663          	beqz	s4,80004830 <rt_schedule+0xd8>
    80004828:	00048513          	mv	a0,s1
    8000482c:	d91ff0ef          	jal	ra,800045bc <rt_schedule_insert_thread>
    80004830:	00040513          	mv	a0,s0
    80004834:	e35ff0ef          	jal	ra,80004668 <rt_schedule_remove_thread>
    80004838:	06844783          	lbu	a5,104(s0)
    8000483c:	03848993          	addi	s3,s1,56
    80004840:	03840593          	addi	a1,s0,56
    80004844:	ff87f793          	andi	a5,a5,-8
    80004848:	0037e793          	ori	a5,a5,3
    8000484c:	06f40423          	sb	a5,104(s0)
    80004850:	00019797          	auipc	a5,0x19
    80004854:	0907c783          	lbu	a5,144(a5) # 8001d8e0 <rt_interrupt_nest>
    80004858:	04079a63          	bnez	a5,800048ac <rt_schedule+0x154>
    8000485c:	00019797          	auipc	a5,0x19
    80004860:	0bc7b783          	ld	a5,188(a5) # 8001d918 <rt_scheduler_switch_hook>
    80004864:	00078a63          	beqz	a5,80004878 <rt_schedule+0x120>
    80004868:	00048513          	mv	a0,s1
    8000486c:	00b13423          	sd	a1,8(sp)
    80004870:	000780e7          	jalr	a5
    80004874:	00813583          	ld	a1,8(sp)
    80004878:	00098513          	mv	a0,s3
    8000487c:	ff4fb0ef          	jal	ra,80000070 <rt_hw_context_switch>
    80004880:	03013403          	ld	s0,48(sp)
    80004884:	03813083          	ld	ra,56(sp)
    80004888:	02813483          	ld	s1,40(sp)
    8000488c:	01813983          	ld	s3,24(sp)
    80004890:	01013a03          	ld	s4,16(sp)
    80004894:	00090513          	mv	a0,s2
    80004898:	02013903          	ld	s2,32(sp)
    8000489c:	04010113          	addi	sp,sp,64
    800048a0:	fb8fb06f          	j	80000058 <rt_hw_interrupt_enable>
    800048a4:	00048413          	mv	s0,s1
    800048a8:	f4dff06f          	j	800047f4 <rt_schedule+0x9c>
    800048ac:	00098513          	mv	a0,s3
    800048b0:	631030ef          	jal	ra,800086e0 <rt_hw_context_switch_interrupt>
    800048b4:	fcdff06f          	j	80004880 <rt_schedule+0x128>
    800048b8:	00048513          	mv	a0,s1
    800048bc:	dadff0ef          	jal	ra,80004668 <rt_schedule_remove_thread>
    800048c0:	0009b703          	ld	a4,0(s3)
    800048c4:	06874783          	lbu	a5,104(a4)
    800048c8:	ff87f793          	andi	a5,a5,-8
    800048cc:	0037e793          	ori	a5,a5,3
    800048d0:	06f70423          	sb	a5,104(a4)
    800048d4:	fadff06f          	j	80004880 <rt_schedule+0x128>

00000000800048d8 <rt_enter_critical>:
    800048d8:	ff010113          	addi	sp,sp,-16
    800048dc:	00113423          	sd	ra,8(sp)
    800048e0:	f70fb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    800048e4:	00019717          	auipc	a4,0x19
    800048e8:	02c70713          	addi	a4,a4,44 # 8001d910 <rt_scheduler_lock_nest>
    800048ec:	00075783          	lhu	a5,0(a4)
    800048f0:	00813083          	ld	ra,8(sp)
    800048f4:	0017879b          	addiw	a5,a5,1
    800048f8:	00f71023          	sh	a5,0(a4)
    800048fc:	01010113          	addi	sp,sp,16
    80004900:	f58fb06f          	j	80000058 <rt_hw_interrupt_enable>

0000000080004904 <rt_exit_critical>:
    80004904:	ff010113          	addi	sp,sp,-16
    80004908:	00113423          	sd	ra,8(sp)
    8000490c:	f44fb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80004910:	00019717          	auipc	a4,0x19
    80004914:	00070713          	mv	a4,a4
    80004918:	00075783          	lhu	a5,0(a4) # 8001d910 <rt_scheduler_lock_nest>
    8000491c:	fff7879b          	addiw	a5,a5,-1
    80004920:	0107979b          	slliw	a5,a5,0x10
    80004924:	4107d79b          	sraiw	a5,a5,0x10
    80004928:	00f71023          	sh	a5,0(a4)
    8000492c:	02f04463          	bgtz	a5,80004954 <rt_exit_critical+0x50>
    80004930:	00019797          	auipc	a5,0x19
    80004934:	fe079023          	sh	zero,-32(a5) # 8001d910 <rt_scheduler_lock_nest>
    80004938:	f20fb0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000493c:	00019797          	auipc	a5,0x19
    80004940:	fc47b783          	ld	a5,-60(a5) # 8001d900 <rt_current_thread>
    80004944:	00078e63          	beqz	a5,80004960 <rt_exit_critical+0x5c>
    80004948:	00813083          	ld	ra,8(sp)
    8000494c:	01010113          	addi	sp,sp,16
    80004950:	e09ff06f          	j	80004758 <rt_schedule>
    80004954:	00813083          	ld	ra,8(sp)
    80004958:	01010113          	addi	sp,sp,16
    8000495c:	efcfb06f          	j	80000058 <rt_hw_interrupt_enable>
    80004960:	00813083          	ld	ra,8(sp)
    80004964:	01010113          	addi	sp,sp,16
    80004968:	00008067          	ret

000000008000496c <rt_mem_setname>:
    8000496c:	00000713          	li	a4,0
    80004970:	00800613          	li	a2,8
    80004974:	00e586b3          	add	a3,a1,a4
    80004978:	0006c683          	lbu	a3,0(a3)
    8000497c:	0007079b          	sext.w	a5,a4
    80004980:	00069c63          	bnez	a3,80004998 <rt_mem_setname+0x2c>
    80004984:	00700713          	li	a4,7
    80004988:	02000613          	li	a2,32
    8000498c:	0007869b          	sext.w	a3,a5
    80004990:	00d75e63          	bge	a4,a3,800049ac <rt_mem_setname+0x40>
    80004994:	00008067          	ret
    80004998:	00e507b3          	add	a5,a0,a4
    8000499c:	00d78c23          	sb	a3,24(a5)
    800049a0:	00170713          	addi	a4,a4,1
    800049a4:	fcc718e3          	bne	a4,a2,80004974 <rt_mem_setname+0x8>
    800049a8:	00008067          	ret
    800049ac:	00f506b3          	add	a3,a0,a5
    800049b0:	00c68c23          	sb	a2,24(a3)
    800049b4:	00178793          	addi	a5,a5,1
    800049b8:	fd5ff06f          	j	8000498c <rt_mem_setname+0x20>

00000000800049bc <list_mem>:
    800049bc:	ff010113          	addi	sp,sp,-16
    800049c0:	00019597          	auipc	a1,0x19
    800049c4:	f885b583          	ld	a1,-120(a1) # 8001d948 <mem_size_aligned>
    800049c8:	0000c517          	auipc	a0,0xc
    800049cc:	2a850513          	addi	a0,a0,680 # 80010c70 <__FUNCTION__.1+0x20>
    800049d0:	00113423          	sd	ra,8(sp)
    800049d4:	018020ef          	jal	ra,800069ec <rt_kprintf>
    800049d8:	00019597          	auipc	a1,0x19
    800049dc:	f885b583          	ld	a1,-120(a1) # 8001d960 <used_mem>
    800049e0:	0000c517          	auipc	a0,0xc
    800049e4:	2a850513          	addi	a0,a0,680 # 80010c88 <__FUNCTION__.1+0x38>
    800049e8:	004020ef          	jal	ra,800069ec <rt_kprintf>
    800049ec:	00813083          	ld	ra,8(sp)
    800049f0:	00019597          	auipc	a1,0x19
    800049f4:	f505b583          	ld	a1,-176(a1) # 8001d940 <max_mem>
    800049f8:	0000c517          	auipc	a0,0xc
    800049fc:	2a850513          	addi	a0,a0,680 # 80010ca0 <__FUNCTION__.1+0x50>
    80004a00:	01010113          	addi	sp,sp,16
    80004a04:	7e90106f          	j	800069ec <rt_kprintf>

0000000080004a08 <memtrace>:
    80004a08:	fa010113          	addi	sp,sp,-96
    80004a0c:	04113c23          	sd	ra,88(sp)
    80004a10:	04813823          	sd	s0,80(sp)
    80004a14:	04913423          	sd	s1,72(sp)
    80004a18:	05213023          	sd	s2,64(sp)
    80004a1c:	03313c23          	sd	s3,56(sp)
    80004a20:	03413823          	sd	s4,48(sp)
    80004a24:	03513423          	sd	s5,40(sp)
    80004a28:	03613023          	sd	s6,32(sp)
    80004a2c:	01713c23          	sd	s7,24(sp)
    80004a30:	01813823          	sd	s8,16(sp)
    80004a34:	01913423          	sd	s9,8(sp)
    80004a38:	01a13023          	sd	s10,0(sp)
    80004a3c:	f81ff0ef          	jal	ra,800049bc <list_mem>
    80004a40:	0000c517          	auipc	a0,0xc
    80004a44:	28050513          	addi	a0,a0,640 # 80010cc0 <__FUNCTION__.1+0x70>
    80004a48:	7a5010ef          	jal	ra,800069ec <rt_kprintf>
    80004a4c:	00019497          	auipc	s1,0x19
    80004a50:	ee448493          	addi	s1,s1,-284 # 8001d930 <heap_ptr>
    80004a54:	0004b583          	ld	a1,0(s1)
    80004a58:	0000c517          	auipc	a0,0xc
    80004a5c:	28050513          	addi	a0,a0,640 # 80010cd8 <__FUNCTION__.1+0x88>
    80004a60:	00019997          	auipc	s3,0x19
    80004a64:	ec898993          	addi	s3,s3,-312 # 8001d928 <heap_end>
    80004a68:	785010ef          	jal	ra,800069ec <rt_kprintf>
    80004a6c:	00019597          	auipc	a1,0x19
    80004a70:	ecc5b583          	ld	a1,-308(a1) # 8001d938 <lfree>
    80004a74:	0000c517          	auipc	a0,0xc
    80004a78:	27c50513          	addi	a0,a0,636 # 80010cf0 <__FUNCTION__.1+0xa0>
    80004a7c:	771010ef          	jal	ra,800069ec <rt_kprintf>
    80004a80:	0009b583          	ld	a1,0(s3)
    80004a84:	0000c517          	auipc	a0,0xc
    80004a88:	28450513          	addi	a0,a0,644 # 80010d08 <__FUNCTION__.1+0xb8>
    80004a8c:	00002937          	lui	s2,0x2
    80004a90:	75d010ef          	jal	ra,800069ec <rt_kprintf>
    80004a94:	0000c517          	auipc	a0,0xc
    80004a98:	28c50513          	addi	a0,a0,652 # 80010d20 <__FUNCTION__.1+0xd0>
    80004a9c:	751010ef          	jal	ra,800069ec <rt_kprintf>
    80004aa0:	0004b403          	ld	s0,0(s1)
    80004aa4:	0000ca17          	auipc	s4,0xc
    80004aa8:	29ca0a13          	addi	s4,s4,668 # 80010d40 <__FUNCTION__.1+0xf0>
    80004aac:	3ff00a93          	li	s5,1023
    80004ab0:	00100b37          	lui	s6,0x100
    80004ab4:	0000cb97          	auipc	s7,0xc
    80004ab8:	2acb8b93          	addi	s7,s7,684 # 80010d60 <__FUNCTION__.1+0x110>
    80004abc:	0000cc17          	auipc	s8,0xc
    80004ac0:	29cc0c13          	addi	s8,s8,668 # 80010d58 <__FUNCTION__.1+0x108>
    80004ac4:	0000cc97          	auipc	s9,0xc
    80004ac8:	28cc8c93          	addi	s9,s9,652 # 80010d50 <__FUNCTION__.1+0x100>
    80004acc:	ea090913          	addi	s2,s2,-352 # 1ea0 <__STACKSIZE__-0x2160>
    80004ad0:	0009b783          	ld	a5,0(s3)
    80004ad4:	04879063          	bne	a5,s0,80004b14 <memtrace+0x10c>
    80004ad8:	05813083          	ld	ra,88(sp)
    80004adc:	05013403          	ld	s0,80(sp)
    80004ae0:	04813483          	ld	s1,72(sp)
    80004ae4:	04013903          	ld	s2,64(sp)
    80004ae8:	03813983          	ld	s3,56(sp)
    80004aec:	03013a03          	ld	s4,48(sp)
    80004af0:	02813a83          	ld	s5,40(sp)
    80004af4:	02013b03          	ld	s6,32(sp)
    80004af8:	01813b83          	ld	s7,24(sp)
    80004afc:	01013c03          	ld	s8,16(sp)
    80004b00:	00813c83          	ld	s9,8(sp)
    80004b04:	00013d03          	ld	s10,0(sp)
    80004b08:	00000513          	li	a0,0
    80004b0c:	06010113          	addi	sp,sp,96
    80004b10:	00008067          	ret
    80004b14:	0004b783          	ld	a5,0(s1)
    80004b18:	00040593          	mv	a1,s0
    80004b1c:	000a0513          	mv	a0,s4
    80004b20:	40f40d33          	sub	s10,s0,a5
    80004b24:	6c9010ef          	jal	ra,800069ec <rt_kprintf>
    80004b28:	00843783          	ld	a5,8(s0)
    80004b2c:	000c8513          	mv	a0,s9
    80004b30:	fe07879b          	addiw	a5,a5,-32
    80004b34:	41a785bb          	subw	a1,a5,s10
    80004b38:	00bad863          	bge	s5,a1,80004b48 <memtrace+0x140>
    80004b3c:	0565dc63          	bge	a1,s6,80004b94 <memtrace+0x18c>
    80004b40:	40a5d59b          	sraiw	a1,a1,0xa
    80004b44:	000c0513          	mv	a0,s8
    80004b48:	6a5010ef          	jal	ra,800069ec <rt_kprintf>
    80004b4c:	01b44703          	lbu	a4,27(s0)
    80004b50:	01a44683          	lbu	a3,26(s0)
    80004b54:	01944603          	lbu	a2,25(s0)
    80004b58:	01844583          	lbu	a1,24(s0)
    80004b5c:	0000c517          	auipc	a0,0xc
    80004b60:	20c50513          	addi	a0,a0,524 # 80010d68 <__FUNCTION__.1+0x118>
    80004b64:	689010ef          	jal	ra,800069ec <rt_kprintf>
    80004b68:	00045783          	lhu	a5,0(s0)
    80004b6c:	0000c517          	auipc	a0,0xc
    80004b70:	20c50513          	addi	a0,a0,524 # 80010d78 <__FUNCTION__.1+0x128>
    80004b74:	01279663          	bne	a5,s2,80004b80 <memtrace+0x178>
    80004b78:	0000e517          	auipc	a0,0xe
    80004b7c:	09850513          	addi	a0,a0,152 # 80012c10 <__FUNCTION__.6+0x28>
    80004b80:	66d010ef          	jal	ra,800069ec <rt_kprintf>
    80004b84:	00843783          	ld	a5,8(s0)
    80004b88:	0004b403          	ld	s0,0(s1)
    80004b8c:	00f40433          	add	s0,s0,a5
    80004b90:	f41ff06f          	j	80004ad0 <memtrace+0xc8>
    80004b94:	4145d59b          	sraiw	a1,a1,0x14
    80004b98:	000b8513          	mv	a0,s7
    80004b9c:	fadff06f          	j	80004b48 <memtrace+0x140>

0000000080004ba0 <plug_holes>:
    80004ba0:	fe010113          	addi	sp,sp,-32
    80004ba4:	01213023          	sd	s2,0(sp)
    80004ba8:	00019917          	auipc	s2,0x19
    80004bac:	d8890913          	addi	s2,s2,-632 # 8001d930 <heap_ptr>
    80004bb0:	00093783          	ld	a5,0(s2)
    80004bb4:	00813823          	sd	s0,16(sp)
    80004bb8:	00113c23          	sd	ra,24(sp)
    80004bbc:	00913423          	sd	s1,8(sp)
    80004bc0:	00050413          	mv	s0,a0
    80004bc4:	00f57e63          	bgeu	a0,a5,80004be0 <plug_holes+0x40>
    80004bc8:	0a100613          	li	a2,161
    80004bcc:	0000c597          	auipc	a1,0xc
    80004bd0:	4e458593          	addi	a1,a1,1252 # 800110b0 <__FUNCTION__.1>
    80004bd4:	0000c517          	auipc	a0,0xc
    80004bd8:	1ac50513          	addi	a0,a0,428 # 80010d80 <__FUNCTION__.1+0x130>
    80004bdc:	799010ef          	jal	ra,80006b74 <rt_assert_handler>
    80004be0:	00019497          	auipc	s1,0x19
    80004be4:	d4848493          	addi	s1,s1,-696 # 8001d928 <heap_end>
    80004be8:	0004b783          	ld	a5,0(s1)
    80004bec:	00f46e63          	bltu	s0,a5,80004c08 <plug_holes+0x68>
    80004bf0:	0a200613          	li	a2,162
    80004bf4:	0000c597          	auipc	a1,0xc
    80004bf8:	4bc58593          	addi	a1,a1,1212 # 800110b0 <__FUNCTION__.1>
    80004bfc:	0000c517          	auipc	a0,0xc
    80004c00:	1a450513          	addi	a0,a0,420 # 80010da0 <__FUNCTION__.1+0x150>
    80004c04:	771010ef          	jal	ra,80006b74 <rt_assert_handler>
    80004c08:	00245783          	lhu	a5,2(s0)
    80004c0c:	00078e63          	beqz	a5,80004c28 <plug_holes+0x88>
    80004c10:	0a300613          	li	a2,163
    80004c14:	0000c597          	auipc	a1,0xc
    80004c18:	49c58593          	addi	a1,a1,1180 # 800110b0 <__FUNCTION__.1>
    80004c1c:	0000c517          	auipc	a0,0xc
    80004c20:	1b450513          	addi	a0,a0,436 # 80010dd0 <__FUNCTION__.1+0x180>
    80004c24:	751010ef          	jal	ra,80006b74 <rt_assert_handler>
    80004c28:	00093703          	ld	a4,0(s2)
    80004c2c:	00843783          	ld	a5,8(s0)
    80004c30:	00f707b3          	add	a5,a4,a5
    80004c34:	04f40063          	beq	s0,a5,80004c74 <plug_holes+0xd4>
    80004c38:	0027d683          	lhu	a3,2(a5)
    80004c3c:	02069c63          	bnez	a3,80004c74 <plug_holes+0xd4>
    80004c40:	0004b683          	ld	a3,0(s1)
    80004c44:	02f68863          	beq	a3,a5,80004c74 <plug_holes+0xd4>
    80004c48:	00019697          	auipc	a3,0x19
    80004c4c:	cf068693          	addi	a3,a3,-784 # 8001d938 <lfree>
    80004c50:	0006b603          	ld	a2,0(a3)
    80004c54:	00f61463          	bne	a2,a5,80004c5c <plug_holes+0xbc>
    80004c58:	0086b023          	sd	s0,0(a3)
    80004c5c:	0087b683          	ld	a3,8(a5)
    80004c60:	00d43423          	sd	a3,8(s0)
    80004c64:	0087b783          	ld	a5,8(a5)
    80004c68:	40e406b3          	sub	a3,s0,a4
    80004c6c:	00f707b3          	add	a5,a4,a5
    80004c70:	00d7b823          	sd	a3,16(a5)
    80004c74:	01043683          	ld	a3,16(s0)
    80004c78:	00d707b3          	add	a5,a4,a3
    80004c7c:	02f40a63          	beq	s0,a5,80004cb0 <plug_holes+0x110>
    80004c80:	0027d603          	lhu	a2,2(a5)
    80004c84:	02061663          	bnez	a2,80004cb0 <plug_holes+0x110>
    80004c88:	00019617          	auipc	a2,0x19
    80004c8c:	cb060613          	addi	a2,a2,-848 # 8001d938 <lfree>
    80004c90:	00063583          	ld	a1,0(a2)
    80004c94:	00859463          	bne	a1,s0,80004c9c <plug_holes+0xfc>
    80004c98:	00f63023          	sd	a5,0(a2)
    80004c9c:	00843603          	ld	a2,8(s0)
    80004ca0:	00c7b423          	sd	a2,8(a5)
    80004ca4:	00843783          	ld	a5,8(s0)
    80004ca8:	00f70733          	add	a4,a4,a5
    80004cac:	00d73823          	sd	a3,16(a4)
    80004cb0:	01813083          	ld	ra,24(sp)
    80004cb4:	01013403          	ld	s0,16(sp)
    80004cb8:	00813483          	ld	s1,8(sp)
    80004cbc:	00013903          	ld	s2,0(sp)
    80004cc0:	02010113          	addi	sp,sp,32
    80004cc4:	00008067          	ret

0000000080004cc8 <memcheck>:
    80004cc8:	fe010113          	addi	sp,sp,-32
    80004ccc:	00813823          	sd	s0,16(sp)
    80004cd0:	00913423          	sd	s1,8(sp)
    80004cd4:	00113c23          	sd	ra,24(sp)
    80004cd8:	01213023          	sd	s2,0(sp)
    80004cdc:	b74fb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80004ce0:	00019797          	auipc	a5,0x19
    80004ce4:	c507b783          	ld	a5,-944(a5) # 8001d930 <heap_ptr>
    80004ce8:	00002737          	lui	a4,0x2
    80004cec:	00050493          	mv	s1,a0
    80004cf0:	00019697          	auipc	a3,0x19
    80004cf4:	c386b683          	ld	a3,-968(a3) # 8001d928 <heap_end>
    80004cf8:	00019617          	auipc	a2,0x19
    80004cfc:	c5062603          	lw	a2,-944(a2) # 8001d948 <mem_size_aligned>
    80004d00:	00078413          	mv	s0,a5
    80004d04:	ea070713          	addi	a4,a4,-352 # 1ea0 <__STACKSIZE__-0x2160>
    80004d08:	00100593          	li	a1,1
    80004d0c:	02869463          	bne	a3,s0,80004d34 <memcheck+0x6c>
    80004d10:	00048513          	mv	a0,s1
    80004d14:	b44fb0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80004d18:	01813083          	ld	ra,24(sp)
    80004d1c:	01013403          	ld	s0,16(sp)
    80004d20:	00813483          	ld	s1,8(sp)
    80004d24:	00013903          	ld	s2,0(sp)
    80004d28:	00000513          	li	a0,0
    80004d2c:	02010113          	addi	sp,sp,32
    80004d30:	00008067          	ret
    80004d34:	40f4093b          	subw	s2,s0,a5
    80004d38:	02094263          	bltz	s2,80004d5c <memcheck+0x94>
    80004d3c:	03264063          	blt	a2,s2,80004d5c <memcheck+0x94>
    80004d40:	00045503          	lhu	a0,0(s0)
    80004d44:	00e51c63          	bne	a0,a4,80004d5c <memcheck+0x94>
    80004d48:	00245503          	lhu	a0,2(s0)
    80004d4c:	00a5e863          	bltu	a1,a0,80004d5c <memcheck+0x94>
    80004d50:	00843403          	ld	s0,8(s0)
    80004d54:	00878433          	add	s0,a5,s0
    80004d58:	fb5ff06f          	j	80004d0c <memcheck+0x44>
    80004d5c:	0000c517          	auipc	a0,0xc
    80004d60:	08450513          	addi	a0,a0,132 # 80010de0 <__FUNCTION__.1+0x190>
    80004d64:	489010ef          	jal	ra,800069ec <rt_kprintf>
    80004d68:	00040593          	mv	a1,s0
    80004d6c:	0000c517          	auipc	a0,0xc
    80004d70:	08c50513          	addi	a0,a0,140 # 80010df8 <__FUNCTION__.1+0x1a8>
    80004d74:	479010ef          	jal	ra,800069ec <rt_kprintf>
    80004d78:	00045583          	lhu	a1,0(s0)
    80004d7c:	0000c517          	auipc	a0,0xc
    80004d80:	09450513          	addi	a0,a0,148 # 80010e10 <__FUNCTION__.1+0x1c0>
    80004d84:	469010ef          	jal	ra,800069ec <rt_kprintf>
    80004d88:	00245583          	lhu	a1,2(s0)
    80004d8c:	0000c517          	auipc	a0,0xc
    80004d90:	09c50513          	addi	a0,a0,156 # 80010e28 <__FUNCTION__.1+0x1d8>
    80004d94:	459010ef          	jal	ra,800069ec <rt_kprintf>
    80004d98:	00843583          	ld	a1,8(s0)
    80004d9c:	0000c517          	auipc	a0,0xc
    80004da0:	09c50513          	addi	a0,a0,156 # 80010e38 <__FUNCTION__.1+0x1e8>
    80004da4:	fe058593          	addi	a1,a1,-32
    80004da8:	412585b3          	sub	a1,a1,s2
    80004dac:	441010ef          	jal	ra,800069ec <rt_kprintf>
    80004db0:	f61ff06f          	j	80004d10 <memcheck+0x48>

0000000080004db4 <rt_system_heap_init>:
    80004db4:	fd010113          	addi	sp,sp,-48
    80004db8:	02813023          	sd	s0,32(sp)
    80004dbc:	00913c23          	sd	s1,24(sp)
    80004dc0:	01213823          	sd	s2,16(sp)
    80004dc4:	01313423          	sd	s3,8(sp)
    80004dc8:	01413023          	sd	s4,0(sp)
    80004dcc:	02113423          	sd	ra,40(sp)
    80004dd0:	00750413          	addi	s0,a0,7
    80004dd4:	00050913          	mv	s2,a0
    80004dd8:	00058993          	mv	s3,a1
    80004ddc:	ff85f493          	andi	s1,a1,-8
    80004de0:	a70fb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80004de4:	ff847413          	andi	s0,s0,-8
    80004de8:	00050a13          	mv	s4,a0
    80004dec:	ec1fe0ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    80004df0:	02050863          	beqz	a0,80004e20 <rt_system_heap_init+0x6c>
    80004df4:	0000c597          	auipc	a1,0xc
    80004df8:	2ec58593          	addi	a1,a1,748 # 800110e0 <__FUNCTION__.4>
    80004dfc:	0000c517          	auipc	a0,0xc
    80004e00:	04c50513          	addi	a0,a0,76 # 80010e48 <__FUNCTION__.1+0x1f8>
    80004e04:	3e9010ef          	jal	ra,800069ec <rt_kprintf>
    80004e08:	0d200613          	li	a2,210
    80004e0c:	0000c597          	auipc	a1,0xc
    80004e10:	2d458593          	addi	a1,a1,724 # 800110e0 <__FUNCTION__.4>
    80004e14:	0000c517          	auipc	a0,0xc
    80004e18:	05c50513          	addi	a0,a0,92 # 80010e70 <__FUNCTION__.1+0x220>
    80004e1c:	559010ef          	jal	ra,80006b74 <rt_assert_handler>
    80004e20:	000a0513          	mv	a0,s4
    80004e24:	a34fb0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80004e28:	04000793          	li	a5,64
    80004e2c:	0c97f463          	bgeu	a5,s1,80004ef4 <rt_system_heap_init+0x140>
    80004e30:	fc048793          	addi	a5,s1,-64
    80004e34:	0c87e063          	bltu	a5,s0,80004ef4 <rt_system_heap_init+0x140>
    80004e38:	408484b3          	sub	s1,s1,s0
    80004e3c:	fc048793          	addi	a5,s1,-64
    80004e40:	00019717          	auipc	a4,0x19
    80004e44:	b0f73423          	sd	a5,-1272(a4) # 8001d948 <mem_size_aligned>
    80004e48:	000027b7          	lui	a5,0x2
    80004e4c:	fe048493          	addi	s1,s1,-32
    80004e50:	ea078793          	addi	a5,a5,-352 # 1ea0 <__STACKSIZE__-0x2160>
    80004e54:	00f42023          	sw	a5,0(s0)
    80004e58:	00019917          	auipc	s2,0x19
    80004e5c:	ad890913          	addi	s2,s2,-1320 # 8001d930 <heap_ptr>
    80004e60:	00943423          	sd	s1,8(s0)
    80004e64:	00040513          	mv	a0,s0
    80004e68:	00043823          	sd	zero,16(s0)
    80004e6c:	0000c597          	auipc	a1,0xc
    80004e70:	00c58593          	addi	a1,a1,12 # 80010e78 <__FUNCTION__.1+0x228>
    80004e74:	00893023          	sd	s0,0(s2)
    80004e78:	af5ff0ef          	jal	ra,8000496c <rt_mem_setname>
    80004e7c:	00843503          	ld	a0,8(s0)
    80004e80:	0000c597          	auipc	a1,0xc
    80004e84:	ff858593          	addi	a1,a1,-8 # 80010e78 <__FUNCTION__.1+0x228>
    80004e88:	00a40533          	add	a0,s0,a0
    80004e8c:	00019797          	auipc	a5,0x19
    80004e90:	a8a7be23          	sd	a0,-1380(a5) # 8001d928 <heap_end>
    80004e94:	000127b7          	lui	a5,0x12
    80004e98:	ea078793          	addi	a5,a5,-352 # 11ea0 <__STACKSIZE__+0xdea0>
    80004e9c:	00f52023          	sw	a5,0(a0)
    80004ea0:	00953423          	sd	s1,8(a0)
    80004ea4:	00953823          	sd	s1,16(a0)
    80004ea8:	ac5ff0ef          	jal	ra,8000496c <rt_mem_setname>
    80004eac:	00100693          	li	a3,1
    80004eb0:	00100613          	li	a2,1
    80004eb4:	0000c597          	auipc	a1,0xc
    80004eb8:	fcc58593          	addi	a1,a1,-52 # 80010e80 <__FUNCTION__.1+0x230>
    80004ebc:	0001d517          	auipc	a0,0x1d
    80004ec0:	f3450513          	addi	a0,a0,-204 # 80021df0 <heap_sem>
    80004ec4:	7c9020ef          	jal	ra,80007e8c <rt_sem_init>
    80004ec8:	00093783          	ld	a5,0(s2)
    80004ecc:	02813083          	ld	ra,40(sp)
    80004ed0:	02013403          	ld	s0,32(sp)
    80004ed4:	00019717          	auipc	a4,0x19
    80004ed8:	a6f73223          	sd	a5,-1436(a4) # 8001d938 <lfree>
    80004edc:	01813483          	ld	s1,24(sp)
    80004ee0:	01013903          	ld	s2,16(sp)
    80004ee4:	00813983          	ld	s3,8(sp)
    80004ee8:	00013a03          	ld	s4,0(sp)
    80004eec:	03010113          	addi	sp,sp,48
    80004ef0:	00008067          	ret
    80004ef4:	02013403          	ld	s0,32(sp)
    80004ef8:	02813083          	ld	ra,40(sp)
    80004efc:	01813483          	ld	s1,24(sp)
    80004f00:	00013a03          	ld	s4,0(sp)
    80004f04:	00098613          	mv	a2,s3
    80004f08:	00090593          	mv	a1,s2
    80004f0c:	00813983          	ld	s3,8(sp)
    80004f10:	01013903          	ld	s2,16(sp)
    80004f14:	0000c517          	auipc	a0,0xc
    80004f18:	f7450513          	addi	a0,a0,-140 # 80010e88 <__FUNCTION__.1+0x238>
    80004f1c:	03010113          	addi	sp,sp,48
    80004f20:	2cd0106f          	j	800069ec <rt_kprintf>

0000000080004f24 <rt_malloc>:
    80004f24:	f8010113          	addi	sp,sp,-128
    80004f28:	06113c23          	sd	ra,120(sp)
    80004f2c:	06813823          	sd	s0,112(sp)
    80004f30:	06913423          	sd	s1,104(sp)
    80004f34:	07213023          	sd	s2,96(sp)
    80004f38:	05313c23          	sd	s3,88(sp)
    80004f3c:	05413823          	sd	s4,80(sp)
    80004f40:	05513423          	sd	s5,72(sp)
    80004f44:	05613023          	sd	s6,64(sp)
    80004f48:	03713c23          	sd	s7,56(sp)
    80004f4c:	03813823          	sd	s8,48(sp)
    80004f50:	03913423          	sd	s9,40(sp)
    80004f54:	03a13023          	sd	s10,32(sp)
    80004f58:	01b13c23          	sd	s11,24(sp)
    80004f5c:	00051663          	bnez	a0,80004f68 <rt_malloc+0x44>
    80004f60:	00000913          	li	s2,0
    80004f64:	2440006f          	j	800051a8 <rt_malloc+0x284>
    80004f68:	00050413          	mv	s0,a0
    80004f6c:	8e4fb0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80004f70:	00050493          	mv	s1,a0
    80004f74:	d39fe0ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    80004f78:	02050863          	beqz	a0,80004fa8 <rt_malloc+0x84>
    80004f7c:	0000c597          	auipc	a1,0xc
    80004f80:	15458593          	addi	a1,a1,340 # 800110d0 <__FUNCTION__.3>
    80004f84:	0000c517          	auipc	a0,0xc
    80004f88:	ec450513          	addi	a0,a0,-316 # 80010e48 <__FUNCTION__.1+0x1f8>
    80004f8c:	261010ef          	jal	ra,800069ec <rt_kprintf>
    80004f90:	11800613          	li	a2,280
    80004f94:	0000c597          	auipc	a1,0xc
    80004f98:	13c58593          	addi	a1,a1,316 # 800110d0 <__FUNCTION__.3>
    80004f9c:	0000c517          	auipc	a0,0xc
    80004fa0:	ed450513          	addi	a0,a0,-300 # 80010e70 <__FUNCTION__.1+0x220>
    80004fa4:	3d1010ef          	jal	ra,80006b74 <rt_assert_handler>
    80004fa8:	00048513          	mv	a0,s1
    80004fac:	8acfb0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80004fb0:	00019497          	auipc	s1,0x19
    80004fb4:	99848493          	addi	s1,s1,-1640 # 8001d948 <mem_size_aligned>
    80004fb8:	0004b783          	ld	a5,0(s1)
    80004fbc:	00740413          	addi	s0,s0,7
    80004fc0:	ff847413          	andi	s0,s0,-8
    80004fc4:	f887eee3          	bltu	a5,s0,80004f60 <rt_malloc+0x3c>
    80004fc8:	01800793          	li	a5,24
    80004fcc:	00f47463          	bgeu	s0,a5,80004fd4 <rt_malloc+0xb0>
    80004fd0:	01800413          	li	s0,24
    80004fd4:	fff00593          	li	a1,-1
    80004fd8:	0001d517          	auipc	a0,0x1d
    80004fdc:	e1850513          	addi	a0,a0,-488 # 80021df0 <heap_sem>
    80004fe0:	755020ef          	jal	ra,80007f34 <rt_sem_take>
    80004fe4:	00019a97          	auipc	s5,0x19
    80004fe8:	94ca8a93          	addi	s5,s5,-1716 # 8001d930 <heap_ptr>
    80004fec:	00019997          	auipc	s3,0x19
    80004ff0:	94c98993          	addi	s3,s3,-1716 # 8001d938 <lfree>
    80004ff4:	000abb83          	ld	s7,0(s5)
    80004ff8:	0009b783          	ld	a5,0(s3)
    80004ffc:	0004bc03          	ld	s8,0(s1)
    80005000:	417787b3          	sub	a5,a5,s7
    80005004:	408c0633          	sub	a2,s8,s0
    80005008:	00c7ea63          	bltu	a5,a2,8000501c <rt_malloc+0xf8>
    8000500c:	0001d517          	auipc	a0,0x1d
    80005010:	de450513          	addi	a0,a0,-540 # 80021df0 <heap_sem>
    80005014:	0e0030ef          	jal	ra,800080f4 <rt_sem_release>
    80005018:	f49ff06f          	j	80004f60 <rt_malloc+0x3c>
    8000501c:	00fb84b3          	add	s1,s7,a5
    80005020:	0024d703          	lhu	a4,2(s1)
    80005024:	0084b683          	ld	a3,8(s1)
    80005028:	1e071e63          	bnez	a4,80005224 <rt_malloc+0x300>
    8000502c:	40f68733          	sub	a4,a3,a5
    80005030:	fe070593          	addi	a1,a4,-32
    80005034:	1e85e863          	bltu	a1,s0,80005224 <rt_malloc+0x300>
    80005038:	00019d17          	auipc	s10,0x19
    8000503c:	928d0d13          	addi	s10,s10,-1752 # 8001d960 <used_mem>
    80005040:	00019c97          	auipc	s9,0x19
    80005044:	900c8c93          	addi	s9,s9,-1792 # 8001d940 <max_mem>
    80005048:	03840513          	addi	a0,s0,56
    8000504c:	000d3903          	ld	s2,0(s10)
    80005050:	000cb603          	ld	a2,0(s9)
    80005054:	02040a13          	addi	s4,s0,32
    80005058:	18a5e863          	bltu	a1,a0,800051e8 <rt_malloc+0x2c4>
    8000505c:	01478db3          	add	s11,a5,s4
    80005060:	00002737          	lui	a4,0x2
    80005064:	01bb8b33          	add	s6,s7,s11
    80005068:	ea070713          	addi	a4,a4,-352 # 1ea0 <__STACKSIZE__-0x2160>
    8000506c:	00fb3823          	sd	a5,16(s6) # 100010 <__STACKSIZE__+0xfc010>
    80005070:	00eb2023          	sw	a4,0(s6)
    80005074:	00db3423          	sd	a3,8(s6)
    80005078:	0000c597          	auipc	a1,0xc
    8000507c:	e5058593          	addi	a1,a1,-432 # 80010ec8 <__FUNCTION__.1+0x278>
    80005080:	000b0513          	mv	a0,s6
    80005084:	00c13423          	sd	a2,8(sp)
    80005088:	8e5ff0ef          	jal	ra,8000496c <rt_mem_setname>
    8000508c:	00100793          	li	a5,1
    80005090:	01b4b423          	sd	s11,8(s1)
    80005094:	00f49123          	sh	a5,2(s1)
    80005098:	008b3783          	ld	a5,8(s6)
    8000509c:	020c0c13          	addi	s8,s8,32
    800050a0:	00813603          	ld	a2,8(sp)
    800050a4:	01878663          	beq	a5,s8,800050b0 <rt_malloc+0x18c>
    800050a8:	00fb87b3          	add	a5,s7,a5
    800050ac:	01b7b823          	sd	s11,16(a5)
    800050b0:	02090793          	addi	a5,s2,32
    800050b4:	008787b3          	add	a5,a5,s0
    800050b8:	00fd3023          	sd	a5,0(s10)
    800050bc:	00f67463          	bgeu	a2,a5,800050c4 <rt_malloc+0x1a0>
    800050c0:	00fcb023          	sd	a5,0(s9)
    800050c4:	000027b7          	lui	a5,0x2
    800050c8:	ea078793          	addi	a5,a5,-352 # 1ea0 <__STACKSIZE__-0x2160>
    800050cc:	00f49023          	sh	a5,0(s1)
    800050d0:	731010ef          	jal	ra,80007000 <rt_thread_self>
    800050d4:	0000c597          	auipc	a1,0xc
    800050d8:	dfc58593          	addi	a1,a1,-516 # 80010ed0 <__FUNCTION__.1+0x280>
    800050dc:	00050663          	beqz	a0,800050e8 <rt_malloc+0x1c4>
    800050e0:	721010ef          	jal	ra,80007000 <rt_thread_self>
    800050e4:	00050593          	mv	a1,a0
    800050e8:	00048513          	mv	a0,s1
    800050ec:	881ff0ef          	jal	ra,8000496c <rt_mem_setname>
    800050f0:	0009b783          	ld	a5,0(s3)
    800050f4:	00019917          	auipc	s2,0x19
    800050f8:	83490913          	addi	s2,s2,-1996 # 8001d928 <heap_end>
    800050fc:	02979063          	bne	a5,s1,8000511c <rt_malloc+0x1f8>
    80005100:	00093683          	ld	a3,0(s2)
    80005104:	000ab603          	ld	a2,0(s5)
    80005108:	00000713          	li	a4,0
    8000510c:	0027d583          	lhu	a1,2(a5)
    80005110:	10059263          	bnez	a1,80005214 <rt_malloc+0x2f0>
    80005114:	00070463          	beqz	a4,8000511c <rt_malloc+0x1f8>
    80005118:	00f9b023          	sd	a5,0(s3)
    8000511c:	0001d517          	auipc	a0,0x1d
    80005120:	cd450513          	addi	a0,a0,-812 # 80021df0 <heap_sem>
    80005124:	7d1020ef          	jal	ra,800080f4 <rt_sem_release>
    80005128:	00093783          	ld	a5,0(s2)
    8000512c:	01448a33          	add	s4,s1,s4
    80005130:	0147fe63          	bgeu	a5,s4,8000514c <rt_malloc+0x228>
    80005134:	18600613          	li	a2,390
    80005138:	0000c597          	auipc	a1,0xc
    8000513c:	f9858593          	addi	a1,a1,-104 # 800110d0 <__FUNCTION__.3>
    80005140:	0000c517          	auipc	a0,0xc
    80005144:	d9850513          	addi	a0,a0,-616 # 80010ed8 <__FUNCTION__.1+0x288>
    80005148:	22d010ef          	jal	ra,80006b74 <rt_assert_handler>
    8000514c:	0074f793          	andi	a5,s1,7
    80005150:	02048913          	addi	s2,s1,32
    80005154:	00078e63          	beqz	a5,80005170 <rt_malloc+0x24c>
    80005158:	18700613          	li	a2,391
    8000515c:	0000c597          	auipc	a1,0xc
    80005160:	f7458593          	addi	a1,a1,-140 # 800110d0 <__FUNCTION__.3>
    80005164:	0000c517          	auipc	a0,0xc
    80005168:	dbc50513          	addi	a0,a0,-580 # 80010f20 <__FUNCTION__.1+0x2d0>
    8000516c:	209010ef          	jal	ra,80006b74 <rt_assert_handler>
    80005170:	0074f493          	andi	s1,s1,7
    80005174:	00048e63          	beqz	s1,80005190 <rt_malloc+0x26c>
    80005178:	18800613          	li	a2,392
    8000517c:	0000c597          	auipc	a1,0xc
    80005180:	f5458593          	addi	a1,a1,-172 # 800110d0 <__FUNCTION__.3>
    80005184:	0000c517          	auipc	a0,0xc
    80005188:	dec50513          	addi	a0,a0,-532 # 80010f70 <__FUNCTION__.1+0x320>
    8000518c:	1e9010ef          	jal	ra,80006b74 <rt_assert_handler>
    80005190:	00018797          	auipc	a5,0x18
    80005194:	7c87b783          	ld	a5,1992(a5) # 8001d958 <rt_malloc_hook>
    80005198:	00078863          	beqz	a5,800051a8 <rt_malloc+0x284>
    8000519c:	00040593          	mv	a1,s0
    800051a0:	00090513          	mv	a0,s2
    800051a4:	000780e7          	jalr	a5
    800051a8:	07813083          	ld	ra,120(sp)
    800051ac:	07013403          	ld	s0,112(sp)
    800051b0:	06813483          	ld	s1,104(sp)
    800051b4:	05813983          	ld	s3,88(sp)
    800051b8:	05013a03          	ld	s4,80(sp)
    800051bc:	04813a83          	ld	s5,72(sp)
    800051c0:	04013b03          	ld	s6,64(sp)
    800051c4:	03813b83          	ld	s7,56(sp)
    800051c8:	03013c03          	ld	s8,48(sp)
    800051cc:	02813c83          	ld	s9,40(sp)
    800051d0:	02013d03          	ld	s10,32(sp)
    800051d4:	01813d83          	ld	s11,24(sp)
    800051d8:	00090513          	mv	a0,s2
    800051dc:	06013903          	ld	s2,96(sp)
    800051e0:	08010113          	addi	sp,sp,128
    800051e4:	00008067          	ret
    800051e8:	00100793          	li	a5,1
    800051ec:	01270933          	add	s2,a4,s2
    800051f0:	00f49123          	sh	a5,2(s1)
    800051f4:	012d3023          	sd	s2,0(s10)
    800051f8:	ed2676e3          	bgeu	a2,s2,800050c4 <rt_malloc+0x1a0>
    800051fc:	012cb023          	sd	s2,0(s9)
    80005200:	ec5ff06f          	j	800050c4 <rt_malloc+0x1a0>
    80005204:	0087b783          	ld	a5,8(a5)
    80005208:	00100713          	li	a4,1
    8000520c:	00f607b3          	add	a5,a2,a5
    80005210:	efdff06f          	j	8000510c <rt_malloc+0x1e8>
    80005214:	fef698e3          	bne	a3,a5,80005204 <rt_malloc+0x2e0>
    80005218:	f00702e3          	beqz	a4,8000511c <rt_malloc+0x1f8>
    8000521c:	00d9b023          	sd	a3,0(s3)
    80005220:	efdff06f          	j	8000511c <rt_malloc+0x1f8>
    80005224:	00068793          	mv	a5,a3
    80005228:	de1ff06f          	j	80005008 <rt_malloc+0xe4>

000000008000522c <rt_calloc>:
    8000522c:	02b50633          	mul	a2,a0,a1
    80005230:	fe010113          	addi	sp,sp,-32
    80005234:	00813823          	sd	s0,16(sp)
    80005238:	00113c23          	sd	ra,24(sp)
    8000523c:	00060513          	mv	a0,a2
    80005240:	00c13423          	sd	a2,8(sp)
    80005244:	ce1ff0ef          	jal	ra,80004f24 <rt_malloc>
    80005248:	00050413          	mv	s0,a0
    8000524c:	00050863          	beqz	a0,8000525c <rt_calloc+0x30>
    80005250:	00813603          	ld	a2,8(sp)
    80005254:	00000593          	li	a1,0
    80005258:	5b9000ef          	jal	ra,80006010 <rt_memset>
    8000525c:	01813083          	ld	ra,24(sp)
    80005260:	00040513          	mv	a0,s0
    80005264:	01013403          	ld	s0,16(sp)
    80005268:	02010113          	addi	sp,sp,32
    8000526c:	00008067          	ret

0000000080005270 <rt_free>:
    80005270:	20050663          	beqz	a0,8000547c <rt_free+0x20c>
    80005274:	fe010113          	addi	sp,sp,-32
    80005278:	00813823          	sd	s0,16(sp)
    8000527c:	00913423          	sd	s1,8(sp)
    80005280:	00113c23          	sd	ra,24(sp)
    80005284:	01213023          	sd	s2,0(sp)
    80005288:	00050413          	mv	s0,a0
    8000528c:	dc5fa0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80005290:	00050493          	mv	s1,a0
    80005294:	a19fe0ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    80005298:	02050863          	beqz	a0,800052c8 <rt_free+0x58>
    8000529c:	00010597          	auipc	a1,0x10
    800052a0:	b3458593          	addi	a1,a1,-1228 # 80014dd0 <__FUNCTION__.0>
    800052a4:	0000c517          	auipc	a0,0xc
    800052a8:	ba450513          	addi	a0,a0,-1116 # 80010e48 <__FUNCTION__.1+0x1f8>
    800052ac:	740010ef          	jal	ra,800069ec <rt_kprintf>
    800052b0:	22f00613          	li	a2,559
    800052b4:	00010597          	auipc	a1,0x10
    800052b8:	b1c58593          	addi	a1,a1,-1252 # 80014dd0 <__FUNCTION__.0>
    800052bc:	0000c517          	auipc	a0,0xc
    800052c0:	bb450513          	addi	a0,a0,-1100 # 80010e70 <__FUNCTION__.1+0x220>
    800052c4:	0b1010ef          	jal	ra,80006b74 <rt_assert_handler>
    800052c8:	00048513          	mv	a0,s1
    800052cc:	d8dfa0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    800052d0:	00747793          	andi	a5,s0,7
    800052d4:	00078e63          	beqz	a5,800052f0 <rt_free+0x80>
    800052d8:	23100613          	li	a2,561
    800052dc:	00010597          	auipc	a1,0x10
    800052e0:	af458593          	addi	a1,a1,-1292 # 80014dd0 <__FUNCTION__.0>
    800052e4:	0000c517          	auipc	a0,0xc
    800052e8:	cbc50513          	addi	a0,a0,-836 # 80010fa0 <__FUNCTION__.1+0x350>
    800052ec:	089010ef          	jal	ra,80006b74 <rt_assert_handler>
    800052f0:	00018917          	auipc	s2,0x18
    800052f4:	64090913          	addi	s2,s2,1600 # 8001d930 <heap_ptr>
    800052f8:	00093783          	ld	a5,0(s2)
    800052fc:	00f46863          	bltu	s0,a5,8000530c <rt_free+0x9c>
    80005300:	00018797          	auipc	a5,0x18
    80005304:	6287b783          	ld	a5,1576(a5) # 8001d928 <heap_end>
    80005308:	00f46e63          	bltu	s0,a5,80005324 <rt_free+0xb4>
    8000530c:	23200613          	li	a2,562
    80005310:	00010597          	auipc	a1,0x10
    80005314:	ac058593          	addi	a1,a1,-1344 # 80014dd0 <__FUNCTION__.0>
    80005318:	0000c517          	auipc	a0,0xc
    8000531c:	cb850513          	addi	a0,a0,-840 # 80010fd0 <__FUNCTION__.1+0x380>
    80005320:	055010ef          	jal	ra,80006b74 <rt_assert_handler>
    80005324:	00018797          	auipc	a5,0x18
    80005328:	62c7b783          	ld	a5,1580(a5) # 8001d950 <rt_free_hook>
    8000532c:	00078663          	beqz	a5,80005338 <rt_free+0xc8>
    80005330:	00040513          	mv	a0,s0
    80005334:	000780e7          	jalr	a5
    80005338:	00093783          	ld	a5,0(s2)
    8000533c:	12f46463          	bltu	s0,a5,80005464 <rt_free+0x1f4>
    80005340:	00018797          	auipc	a5,0x18
    80005344:	5e87b783          	ld	a5,1512(a5) # 8001d928 <heap_end>
    80005348:	10f47e63          	bgeu	s0,a5,80005464 <rt_free+0x1f4>
    8000534c:	fff00593          	li	a1,-1
    80005350:	0001d517          	auipc	a0,0x1d
    80005354:	aa050513          	addi	a0,a0,-1376 # 80021df0 <heap_sem>
    80005358:	3dd020ef          	jal	ra,80007f34 <rt_sem_take>
    8000535c:	fe245783          	lhu	a5,-30(s0)
    80005360:	fe040493          	addi	s1,s0,-32
    80005364:	00078a63          	beqz	a5,80005378 <rt_free+0x108>
    80005368:	fe045703          	lhu	a4,-32(s0)
    8000536c:	000027b7          	lui	a5,0x2
    80005370:	ea078793          	addi	a5,a5,-352 # 1ea0 <__STACKSIZE__-0x2160>
    80005374:	06f70863          	beq	a4,a5,800053e4 <rt_free+0x174>
    80005378:	0000c517          	auipc	a0,0xc
    8000537c:	cb850513          	addi	a0,a0,-840 # 80011030 <__FUNCTION__.1+0x3e0>
    80005380:	66c010ef          	jal	ra,800069ec <rt_kprintf>
    80005384:	fe045683          	lhu	a3,-32(s0)
    80005388:	fe245603          	lhu	a2,-30(s0)
    8000538c:	00048593          	mv	a1,s1
    80005390:	0000c517          	auipc	a0,0xc
    80005394:	cc050513          	addi	a0,a0,-832 # 80011050 <__FUNCTION__.1+0x400>
    80005398:	654010ef          	jal	ra,800069ec <rt_kprintf>
    8000539c:	fe245783          	lhu	a5,-30(s0)
    800053a0:	00079e63          	bnez	a5,800053bc <rt_free+0x14c>
    800053a4:	25100613          	li	a2,593
    800053a8:	00010597          	auipc	a1,0x10
    800053ac:	a2858593          	addi	a1,a1,-1496 # 80014dd0 <__FUNCTION__.0>
    800053b0:	0000c517          	auipc	a0,0xc
    800053b4:	cd050513          	addi	a0,a0,-816 # 80011080 <__FUNCTION__.1+0x430>
    800053b8:	7bc010ef          	jal	ra,80006b74 <rt_assert_handler>
    800053bc:	fe045703          	lhu	a4,-32(s0)
    800053c0:	000027b7          	lui	a5,0x2
    800053c4:	ea078793          	addi	a5,a5,-352 # 1ea0 <__STACKSIZE__-0x2160>
    800053c8:	00f70e63          	beq	a4,a5,800053e4 <rt_free+0x174>
    800053cc:	25200613          	li	a2,594
    800053d0:	00010597          	auipc	a1,0x10
    800053d4:	a0058593          	addi	a1,a1,-1536 # 80014dd0 <__FUNCTION__.0>
    800053d8:	0000c517          	auipc	a0,0xc
    800053dc:	cb850513          	addi	a0,a0,-840 # 80011090 <__FUNCTION__.1+0x440>
    800053e0:	794010ef          	jal	ra,80006b74 <rt_assert_handler>
    800053e4:	000027b7          	lui	a5,0x2
    800053e8:	ea078793          	addi	a5,a5,-352 # 1ea0 <__STACKSIZE__-0x2160>
    800053ec:	fef41023          	sh	a5,-32(s0)
    800053f0:	fe041123          	sh	zero,-30(s0)
    800053f4:	0000c597          	auipc	a1,0xc
    800053f8:	ad458593          	addi	a1,a1,-1324 # 80010ec8 <__FUNCTION__.1+0x278>
    800053fc:	00048513          	mv	a0,s1
    80005400:	d6cff0ef          	jal	ra,8000496c <rt_mem_setname>
    80005404:	00018797          	auipc	a5,0x18
    80005408:	53478793          	addi	a5,a5,1332 # 8001d938 <lfree>
    8000540c:	0007b703          	ld	a4,0(a5)
    80005410:	00e4f463          	bgeu	s1,a4,80005418 <rt_free+0x1a8>
    80005414:	0097b023          	sd	s1,0(a5)
    80005418:	00018697          	auipc	a3,0x18
    8000541c:	54868693          	addi	a3,a3,1352 # 8001d960 <used_mem>
    80005420:	fe843703          	ld	a4,-24(s0)
    80005424:	0006b783          	ld	a5,0(a3)
    80005428:	00048513          	mv	a0,s1
    8000542c:	40e787b3          	sub	a5,a5,a4
    80005430:	00093703          	ld	a4,0(s2)
    80005434:	40e48733          	sub	a4,s1,a4
    80005438:	00e787b3          	add	a5,a5,a4
    8000543c:	00f6b023          	sd	a5,0(a3)
    80005440:	f60ff0ef          	jal	ra,80004ba0 <plug_holes>
    80005444:	01013403          	ld	s0,16(sp)
    80005448:	01813083          	ld	ra,24(sp)
    8000544c:	00813483          	ld	s1,8(sp)
    80005450:	00013903          	ld	s2,0(sp)
    80005454:	0001d517          	auipc	a0,0x1d
    80005458:	99c50513          	addi	a0,a0,-1636 # 80021df0 <heap_sem>
    8000545c:	02010113          	addi	sp,sp,32
    80005460:	4950206f          	j	800080f4 <rt_sem_release>
    80005464:	01813083          	ld	ra,24(sp)
    80005468:	01013403          	ld	s0,16(sp)
    8000546c:	00813483          	ld	s1,8(sp)
    80005470:	00013903          	ld	s2,0(sp)
    80005474:	02010113          	addi	sp,sp,32
    80005478:	00008067          	ret
    8000547c:	00008067          	ret

0000000080005480 <rt_realloc>:
    80005480:	fc010113          	addi	sp,sp,-64
    80005484:	02813823          	sd	s0,48(sp)
    80005488:	02913423          	sd	s1,40(sp)
    8000548c:	03213023          	sd	s2,32(sp)
    80005490:	02113c23          	sd	ra,56(sp)
    80005494:	01313c23          	sd	s3,24(sp)
    80005498:	01413823          	sd	s4,16(sp)
    8000549c:	00050493          	mv	s1,a0
    800054a0:	00058413          	mv	s0,a1
    800054a4:	badfa0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    800054a8:	00050913          	mv	s2,a0
    800054ac:	801fe0ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    800054b0:	02050863          	beqz	a0,800054e0 <rt_realloc+0x60>
    800054b4:	0000c597          	auipc	a1,0xc
    800054b8:	c0c58593          	addi	a1,a1,-1012 # 800110c0 <__FUNCTION__.2>
    800054bc:	0000c517          	auipc	a0,0xc
    800054c0:	98c50513          	addi	a0,a0,-1652 # 80010e48 <__FUNCTION__.1+0x1f8>
    800054c4:	528010ef          	jal	ra,800069ec <rt_kprintf>
    800054c8:	1ac00613          	li	a2,428
    800054cc:	0000c597          	auipc	a1,0xc
    800054d0:	bf458593          	addi	a1,a1,-1036 # 800110c0 <__FUNCTION__.2>
    800054d4:	0000c517          	auipc	a0,0xc
    800054d8:	99c50513          	addi	a0,a0,-1636 # 80010e70 <__FUNCTION__.1+0x220>
    800054dc:	698010ef          	jal	ra,80006b74 <rt_assert_handler>
    800054e0:	00090513          	mv	a0,s2
    800054e4:	b75fa0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    800054e8:	00018a17          	auipc	s4,0x18
    800054ec:	460a0a13          	addi	s4,s4,1120 # 8001d948 <mem_size_aligned>
    800054f0:	000a3783          	ld	a5,0(s4)
    800054f4:	00740413          	addi	s0,s0,7
    800054f8:	ff847413          	andi	s0,s0,-8
    800054fc:	0087e863          	bltu	a5,s0,8000550c <rt_realloc+0x8c>
    80005500:	00041a63          	bnez	s0,80005514 <rt_realloc+0x94>
    80005504:	00048513          	mv	a0,s1
    80005508:	d69ff0ef          	jal	ra,80005270 <rt_free>
    8000550c:	00000913          	li	s2,0
    80005510:	0640006f          	j	80005574 <rt_realloc+0xf4>
    80005514:	02049463          	bnez	s1,8000553c <rt_realloc+0xbc>
    80005518:	00040513          	mv	a0,s0
    8000551c:	03013403          	ld	s0,48(sp)
    80005520:	03813083          	ld	ra,56(sp)
    80005524:	02813483          	ld	s1,40(sp)
    80005528:	02013903          	ld	s2,32(sp)
    8000552c:	01813983          	ld	s3,24(sp)
    80005530:	01013a03          	ld	s4,16(sp)
    80005534:	04010113          	addi	sp,sp,64
    80005538:	9edff06f          	j	80004f24 <rt_malloc>
    8000553c:	fff00593          	li	a1,-1
    80005540:	0001d517          	auipc	a0,0x1d
    80005544:	8b050513          	addi	a0,a0,-1872 # 80021df0 <heap_sem>
    80005548:	1ed020ef          	jal	ra,80007f34 <rt_sem_take>
    8000554c:	00018917          	auipc	s2,0x18
    80005550:	3e493903          	ld	s2,996(s2) # 8001d930 <heap_ptr>
    80005554:	0124e863          	bltu	s1,s2,80005564 <rt_realloc+0xe4>
    80005558:	00018797          	auipc	a5,0x18
    8000555c:	3d07b783          	ld	a5,976(a5) # 8001d928 <heap_end>
    80005560:	02f4ec63          	bltu	s1,a5,80005598 <rt_realloc+0x118>
    80005564:	0001d517          	auipc	a0,0x1d
    80005568:	88c50513          	addi	a0,a0,-1908 # 80021df0 <heap_sem>
    8000556c:	389020ef          	jal	ra,800080f4 <rt_sem_release>
    80005570:	00048913          	mv	s2,s1
    80005574:	03813083          	ld	ra,56(sp)
    80005578:	03013403          	ld	s0,48(sp)
    8000557c:	02813483          	ld	s1,40(sp)
    80005580:	01813983          	ld	s3,24(sp)
    80005584:	01013a03          	ld	s4,16(sp)
    80005588:	00090513          	mv	a0,s2
    8000558c:	02013903          	ld	s2,32(sp)
    80005590:	04010113          	addi	sp,sp,64
    80005594:	00008067          	ret
    80005598:	fe84b683          	ld	a3,-24(s1)
    8000559c:	fe048793          	addi	a5,s1,-32
    800055a0:	412787b3          	sub	a5,a5,s2
    800055a4:	fe068593          	addi	a1,a3,-32
    800055a8:	40f589b3          	sub	s3,a1,a5
    800055ac:	fb340ce3          	beq	s0,s3,80005564 <rt_realloc+0xe4>
    800055b0:	03840713          	addi	a4,s0,56
    800055b4:	09377463          	bgeu	a4,s3,8000563c <rt_realloc+0x1bc>
    800055b8:	00018617          	auipc	a2,0x18
    800055bc:	3a860613          	addi	a2,a2,936 # 8001d960 <used_mem>
    800055c0:	00063703          	ld	a4,0(a2)
    800055c4:	00f40433          	add	s0,s0,a5
    800055c8:	00e40733          	add	a4,s0,a4
    800055cc:	40b70733          	sub	a4,a4,a1
    800055d0:	00e63023          	sd	a4,0(a2)
    800055d4:	02040413          	addi	s0,s0,32
    800055d8:	00002737          	lui	a4,0x2
    800055dc:	00890533          	add	a0,s2,s0
    800055e0:	ea070713          	addi	a4,a4,-352 # 1ea0 <__STACKSIZE__-0x2160>
    800055e4:	00e52023          	sw	a4,0(a0)
    800055e8:	00f53823          	sd	a5,16(a0)
    800055ec:	00d53423          	sd	a3,8(a0)
    800055f0:	0000c597          	auipc	a1,0xc
    800055f4:	8d858593          	addi	a1,a1,-1832 # 80010ec8 <__FUNCTION__.1+0x278>
    800055f8:	00a13423          	sd	a0,8(sp)
    800055fc:	b70ff0ef          	jal	ra,8000496c <rt_mem_setname>
    80005600:	00813503          	ld	a0,8(sp)
    80005604:	000a3783          	ld	a5,0(s4)
    80005608:	fe84b423          	sd	s0,-24(s1)
    8000560c:	00853703          	ld	a4,8(a0)
    80005610:	02078793          	addi	a5,a5,32
    80005614:	00f70663          	beq	a4,a5,80005620 <rt_realloc+0x1a0>
    80005618:	00e90933          	add	s2,s2,a4
    8000561c:	00893823          	sd	s0,16(s2)
    80005620:	00018797          	auipc	a5,0x18
    80005624:	31878793          	addi	a5,a5,792 # 8001d938 <lfree>
    80005628:	0007b703          	ld	a4,0(a5)
    8000562c:	00e57463          	bgeu	a0,a4,80005634 <rt_realloc+0x1b4>
    80005630:	00a7b023          	sd	a0,0(a5)
    80005634:	d6cff0ef          	jal	ra,80004ba0 <plug_holes>
    80005638:	f2dff06f          	j	80005564 <rt_realloc+0xe4>
    8000563c:	0001c517          	auipc	a0,0x1c
    80005640:	7b450513          	addi	a0,a0,1972 # 80021df0 <heap_sem>
    80005644:	2b1020ef          	jal	ra,800080f4 <rt_sem_release>
    80005648:	00040513          	mv	a0,s0
    8000564c:	8d9ff0ef          	jal	ra,80004f24 <rt_malloc>
    80005650:	00050913          	mv	s2,a0
    80005654:	f20500e3          	beqz	a0,80005574 <rt_realloc+0xf4>
    80005658:	00040613          	mv	a2,s0
    8000565c:	0089f463          	bgeu	s3,s0,80005664 <rt_realloc+0x1e4>
    80005660:	00098613          	mv	a2,s3
    80005664:	00048593          	mv	a1,s1
    80005668:	00090513          	mv	a0,s2
    8000566c:	269000ef          	jal	ra,800060d4 <rt_memcpy>
    80005670:	00048513          	mv	a0,s1
    80005674:	bfdff0ef          	jal	ra,80005270 <rt_free>
    80005678:	efdff06f          	j	80005574 <rt_realloc+0xf4>

000000008000567c <rt_device_find>:
    8000567c:	00900593          	li	a1,9
    80005680:	6680206f          	j	80007ce8 <rt_object_find>

0000000080005684 <rt_device_register>:
    80005684:	02051463          	bnez	a0,800056ac <rt_device_register+0x28>
    80005688:	fff00513          	li	a0,-1
    8000568c:	00008067          	ret
    80005690:	fff00513          	li	a0,-1
    80005694:	01813083          	ld	ra,24(sp)
    80005698:	01013403          	ld	s0,16(sp)
    8000569c:	00813483          	ld	s1,8(sp)
    800056a0:	00013903          	ld	s2,0(sp)
    800056a4:	02010113          	addi	sp,sp,32
    800056a8:	00008067          	ret
    800056ac:	fe010113          	addi	sp,sp,-32
    800056b0:	00813823          	sd	s0,16(sp)
    800056b4:	00050413          	mv	s0,a0
    800056b8:	00058513          	mv	a0,a1
    800056bc:	00913423          	sd	s1,8(sp)
    800056c0:	01213023          	sd	s2,0(sp)
    800056c4:	00113c23          	sd	ra,24(sp)
    800056c8:	00058493          	mv	s1,a1
    800056cc:	00060913          	mv	s2,a2
    800056d0:	fadff0ef          	jal	ra,8000567c <rt_device_find>
    800056d4:	fa051ee3          	bnez	a0,80005690 <rt_device_register+0xc>
    800056d8:	00040513          	mv	a0,s0
    800056dc:	00048613          	mv	a2,s1
    800056e0:	00900593          	li	a1,9
    800056e4:	240020ef          	jal	ra,80007924 <rt_object_init>
    800056e8:	00000513          	li	a0,0
    800056ec:	03241623          	sh	s2,44(s0)
    800056f0:	02040823          	sb	zero,48(s0)
    800056f4:	02041723          	sh	zero,46(s0)
    800056f8:	f9dff06f          	j	80005694 <rt_device_register+0x10>

00000000800056fc <rt_device_open>:
    800056fc:	fe010113          	addi	sp,sp,-32
    80005700:	00813823          	sd	s0,16(sp)
    80005704:	01213023          	sd	s2,0(sp)
    80005708:	00113c23          	sd	ra,24(sp)
    8000570c:	00913423          	sd	s1,8(sp)
    80005710:	00050413          	mv	s0,a0
    80005714:	00058913          	mv	s2,a1
    80005718:	00051e63          	bnez	a0,80005734 <rt_device_open+0x38>
    8000571c:	0c900613          	li	a2,201
    80005720:	0000c597          	auipc	a1,0xc
    80005724:	b9058593          	addi	a1,a1,-1136 # 800112b0 <__FUNCTION__.6>
    80005728:	0000c517          	auipc	a0,0xc
    8000572c:	a5850513          	addi	a0,a0,-1448 # 80011180 <__fsym_list_mem_name+0x10>
    80005730:	444010ef          	jal	ra,80006b74 <rt_assert_handler>
    80005734:	00040513          	mv	a0,s0
    80005738:	56c020ef          	jal	ra,80007ca4 <rt_object_get_type>
    8000573c:	00900793          	li	a5,9
    80005740:	00f50e63          	beq	a0,a5,8000575c <rt_device_open+0x60>
    80005744:	0ca00613          	li	a2,202
    80005748:	0000c597          	auipc	a1,0xc
    8000574c:	b6858593          	addi	a1,a1,-1176 # 800112b0 <__FUNCTION__.6>
    80005750:	0000c517          	auipc	a0,0xc
    80005754:	a4050513          	addi	a0,a0,-1472 # 80011190 <__fsym_list_mem_name+0x20>
    80005758:	41c010ef          	jal	ra,80006b74 <rt_assert_handler>
    8000575c:	02c45783          	lhu	a5,44(s0)
    80005760:	0107f793          	andi	a5,a5,16
    80005764:	04079c63          	bnez	a5,800057bc <rt_device_open+0xc0>
    80005768:	04843783          	ld	a5,72(s0)
    8000576c:	04078263          	beqz	a5,800057b0 <rt_device_open+0xb4>
    80005770:	00040513          	mv	a0,s0
    80005774:	000780e7          	jalr	a5
    80005778:	00050493          	mv	s1,a0
    8000577c:	02050a63          	beqz	a0,800057b0 <rt_device_open+0xb4>
    80005780:	00050613          	mv	a2,a0
    80005784:	00040593          	mv	a1,s0
    80005788:	0000c517          	auipc	a0,0xc
    8000578c:	a7050513          	addi	a0,a0,-1424 # 800111f8 <__fsym_list_mem_name+0x88>
    80005790:	25c010ef          	jal	ra,800069ec <rt_kprintf>
    80005794:	01813083          	ld	ra,24(sp)
    80005798:	01013403          	ld	s0,16(sp)
    8000579c:	00013903          	ld	s2,0(sp)
    800057a0:	00048513          	mv	a0,s1
    800057a4:	00813483          	ld	s1,8(sp)
    800057a8:	02010113          	addi	sp,sp,32
    800057ac:	00008067          	ret
    800057b0:	02c45783          	lhu	a5,44(s0)
    800057b4:	0107e793          	ori	a5,a5,16
    800057b8:	02f41623          	sh	a5,44(s0)
    800057bc:	02c45783          	lhu	a5,44(s0)
    800057c0:	0087f793          	andi	a5,a5,8
    800057c4:	00078a63          	beqz	a5,800057d8 <rt_device_open+0xdc>
    800057c8:	02e45783          	lhu	a5,46(s0)
    800057cc:	ff900493          	li	s1,-7
    800057d0:	0087f793          	andi	a5,a5,8
    800057d4:	fc0790e3          	bnez	a5,80005794 <rt_device_open+0x98>
    800057d8:	05043783          	ld	a5,80(s0)
    800057dc:	04078a63          	beqz	a5,80005830 <rt_device_open+0x134>
    800057e0:	00090593          	mv	a1,s2
    800057e4:	00040513          	mv	a0,s0
    800057e8:	000780e7          	jalr	a5
    800057ec:	00050493          	mv	s1,a0
    800057f0:	04051c63          	bnez	a0,80005848 <rt_device_open+0x14c>
    800057f4:	02e45783          	lhu	a5,46(s0)
    800057f8:	0087e793          	ori	a5,a5,8
    800057fc:	02f41723          	sh	a5,46(s0)
    80005800:	03044783          	lbu	a5,48(s0)
    80005804:	0017879b          	addiw	a5,a5,1
    80005808:	0ff7f793          	zext.b	a5,a5
    8000580c:	02f40823          	sb	a5,48(s0)
    80005810:	f80792e3          	bnez	a5,80005794 <rt_device_open+0x98>
    80005814:	0f800613          	li	a2,248
    80005818:	0000c597          	auipc	a1,0xc
    8000581c:	a9858593          	addi	a1,a1,-1384 # 800112b0 <__FUNCTION__.6>
    80005820:	0000c517          	auipc	a0,0xc
    80005824:	a1050513          	addi	a0,a0,-1520 # 80011230 <__fsym_list_mem_name+0xc0>
    80005828:	34c010ef          	jal	ra,80006b74 <rt_assert_handler>
    8000582c:	f69ff06f          	j	80005794 <rt_device_open+0x98>
    80005830:	000015b7          	lui	a1,0x1
    80005834:	f0f58593          	addi	a1,a1,-241 # f0f <__STACKSIZE__-0x30f1>
    80005838:	00b97933          	and	s2,s2,a1
    8000583c:	03241723          	sh	s2,46(s0)
    80005840:	00000493          	li	s1,0
    80005844:	fb1ff06f          	j	800057f4 <rt_device_open+0xf8>
    80005848:	ffa00793          	li	a5,-6
    8000584c:	f4f514e3          	bne	a0,a5,80005794 <rt_device_open+0x98>
    80005850:	fa5ff06f          	j	800057f4 <rt_device_open+0xf8>

0000000080005854 <rt_device_close>:
    80005854:	ff010113          	addi	sp,sp,-16
    80005858:	00813023          	sd	s0,0(sp)
    8000585c:	00113423          	sd	ra,8(sp)
    80005860:	00050413          	mv	s0,a0
    80005864:	00051e63          	bnez	a0,80005880 <rt_device_close+0x2c>
    80005868:	10a00613          	li	a2,266
    8000586c:	0000c597          	auipc	a1,0xc
    80005870:	a3458593          	addi	a1,a1,-1484 # 800112a0 <__FUNCTION__.5>
    80005874:	0000c517          	auipc	a0,0xc
    80005878:	90c50513          	addi	a0,a0,-1780 # 80011180 <__fsym_list_mem_name+0x10>
    8000587c:	2f8010ef          	jal	ra,80006b74 <rt_assert_handler>
    80005880:	00040513          	mv	a0,s0
    80005884:	420020ef          	jal	ra,80007ca4 <rt_object_get_type>
    80005888:	00900793          	li	a5,9
    8000588c:	00f50e63          	beq	a0,a5,800058a8 <rt_device_close+0x54>
    80005890:	10b00613          	li	a2,267
    80005894:	0000c597          	auipc	a1,0xc
    80005898:	a0c58593          	addi	a1,a1,-1524 # 800112a0 <__FUNCTION__.5>
    8000589c:	0000c517          	auipc	a0,0xc
    800058a0:	8f450513          	addi	a0,a0,-1804 # 80011190 <__fsym_list_mem_name+0x20>
    800058a4:	2d0010ef          	jal	ra,80006b74 <rt_assert_handler>
    800058a8:	03044783          	lbu	a5,48(s0)
    800058ac:	fff00513          	li	a0,-1
    800058b0:	04078063          	beqz	a5,800058f0 <rt_device_close+0x9c>
    800058b4:	fff7879b          	addiw	a5,a5,-1
    800058b8:	0ff7f793          	zext.b	a5,a5
    800058bc:	02f40823          	sb	a5,48(s0)
    800058c0:	00000513          	li	a0,0
    800058c4:	02079663          	bnez	a5,800058f0 <rt_device_close+0x9c>
    800058c8:	05843783          	ld	a5,88(s0)
    800058cc:	00079863          	bnez	a5,800058dc <rt_device_close+0x88>
    800058d0:	00000513          	li	a0,0
    800058d4:	02041723          	sh	zero,46(s0)
    800058d8:	0180006f          	j	800058f0 <rt_device_close+0x9c>
    800058dc:	00040513          	mv	a0,s0
    800058e0:	000780e7          	jalr	a5
    800058e4:	fe0506e3          	beqz	a0,800058d0 <rt_device_close+0x7c>
    800058e8:	ffa00793          	li	a5,-6
    800058ec:	fef504e3          	beq	a0,a5,800058d4 <rt_device_close+0x80>
    800058f0:	00813083          	ld	ra,8(sp)
    800058f4:	00013403          	ld	s0,0(sp)
    800058f8:	01010113          	addi	sp,sp,16
    800058fc:	00008067          	ret

0000000080005900 <rt_device_read>:
    80005900:	fd010113          	addi	sp,sp,-48
    80005904:	02813023          	sd	s0,32(sp)
    80005908:	00913c23          	sd	s1,24(sp)
    8000590c:	01213823          	sd	s2,16(sp)
    80005910:	01313423          	sd	s3,8(sp)
    80005914:	02113423          	sd	ra,40(sp)
    80005918:	00050413          	mv	s0,a0
    8000591c:	00058493          	mv	s1,a1
    80005920:	00060913          	mv	s2,a2
    80005924:	00068993          	mv	s3,a3
    80005928:	00051e63          	bnez	a0,80005944 <rt_device_read+0x44>
    8000592c:	13400613          	li	a2,308
    80005930:	0000c597          	auipc	a1,0xc
    80005934:	96058593          	addi	a1,a1,-1696 # 80011290 <__FUNCTION__.4>
    80005938:	0000c517          	auipc	a0,0xc
    8000593c:	84850513          	addi	a0,a0,-1976 # 80011180 <__fsym_list_mem_name+0x10>
    80005940:	234010ef          	jal	ra,80006b74 <rt_assert_handler>
    80005944:	00040513          	mv	a0,s0
    80005948:	35c020ef          	jal	ra,80007ca4 <rt_object_get_type>
    8000594c:	00900793          	li	a5,9
    80005950:	00f50e63          	beq	a0,a5,8000596c <rt_device_read+0x6c>
    80005954:	13500613          	li	a2,309
    80005958:	0000c597          	auipc	a1,0xc
    8000595c:	93858593          	addi	a1,a1,-1736 # 80011290 <__FUNCTION__.4>
    80005960:	0000c517          	auipc	a0,0xc
    80005964:	83050513          	addi	a0,a0,-2000 # 80011190 <__fsym_list_mem_name+0x20>
    80005968:	20c010ef          	jal	ra,80006b74 <rt_assert_handler>
    8000596c:	03044783          	lbu	a5,48(s0)
    80005970:	fff00513          	li	a0,-1
    80005974:	02078e63          	beqz	a5,800059b0 <rt_device_read+0xb0>
    80005978:	06043783          	ld	a5,96(s0)
    8000597c:	02078863          	beqz	a5,800059ac <rt_device_read+0xac>
    80005980:	00040513          	mv	a0,s0
    80005984:	02013403          	ld	s0,32(sp)
    80005988:	02813083          	ld	ra,40(sp)
    8000598c:	00098693          	mv	a3,s3
    80005990:	00090613          	mv	a2,s2
    80005994:	00813983          	ld	s3,8(sp)
    80005998:	01013903          	ld	s2,16(sp)
    8000599c:	00048593          	mv	a1,s1
    800059a0:	01813483          	ld	s1,24(sp)
    800059a4:	03010113          	addi	sp,sp,48
    800059a8:	00078067          	jr	a5
    800059ac:	ffa00513          	li	a0,-6
    800059b0:	620000ef          	jal	ra,80005fd0 <rt_set_errno>
    800059b4:	02813083          	ld	ra,40(sp)
    800059b8:	02013403          	ld	s0,32(sp)
    800059bc:	01813483          	ld	s1,24(sp)
    800059c0:	01013903          	ld	s2,16(sp)
    800059c4:	00813983          	ld	s3,8(sp)
    800059c8:	00000513          	li	a0,0
    800059cc:	03010113          	addi	sp,sp,48
    800059d0:	00008067          	ret

00000000800059d4 <rt_device_write>:
    800059d4:	fd010113          	addi	sp,sp,-48
    800059d8:	02813023          	sd	s0,32(sp)
    800059dc:	00913c23          	sd	s1,24(sp)
    800059e0:	01213823          	sd	s2,16(sp)
    800059e4:	01313423          	sd	s3,8(sp)
    800059e8:	02113423          	sd	ra,40(sp)
    800059ec:	00050413          	mv	s0,a0
    800059f0:	00058493          	mv	s1,a1
    800059f4:	00060913          	mv	s2,a2
    800059f8:	00068993          	mv	s3,a3
    800059fc:	00051e63          	bnez	a0,80005a18 <rt_device_write+0x44>
    80005a00:	15b00613          	li	a2,347
    80005a04:	0000c597          	auipc	a1,0xc
    80005a08:	87c58593          	addi	a1,a1,-1924 # 80011280 <__FUNCTION__.3>
    80005a0c:	0000b517          	auipc	a0,0xb
    80005a10:	77450513          	addi	a0,a0,1908 # 80011180 <__fsym_list_mem_name+0x10>
    80005a14:	160010ef          	jal	ra,80006b74 <rt_assert_handler>
    80005a18:	00040513          	mv	a0,s0
    80005a1c:	288020ef          	jal	ra,80007ca4 <rt_object_get_type>
    80005a20:	00900793          	li	a5,9
    80005a24:	00f50e63          	beq	a0,a5,80005a40 <rt_device_write+0x6c>
    80005a28:	15c00613          	li	a2,348
    80005a2c:	0000c597          	auipc	a1,0xc
    80005a30:	85458593          	addi	a1,a1,-1964 # 80011280 <__FUNCTION__.3>
    80005a34:	0000b517          	auipc	a0,0xb
    80005a38:	75c50513          	addi	a0,a0,1884 # 80011190 <__fsym_list_mem_name+0x20>
    80005a3c:	138010ef          	jal	ra,80006b74 <rt_assert_handler>
    80005a40:	03044783          	lbu	a5,48(s0)
    80005a44:	fff00513          	li	a0,-1
    80005a48:	02078e63          	beqz	a5,80005a84 <rt_device_write+0xb0>
    80005a4c:	06843783          	ld	a5,104(s0)
    80005a50:	02078863          	beqz	a5,80005a80 <rt_device_write+0xac>
    80005a54:	00040513          	mv	a0,s0
    80005a58:	02013403          	ld	s0,32(sp)
    80005a5c:	02813083          	ld	ra,40(sp)
    80005a60:	00098693          	mv	a3,s3
    80005a64:	00090613          	mv	a2,s2
    80005a68:	00813983          	ld	s3,8(sp)
    80005a6c:	01013903          	ld	s2,16(sp)
    80005a70:	00048593          	mv	a1,s1
    80005a74:	01813483          	ld	s1,24(sp)
    80005a78:	03010113          	addi	sp,sp,48
    80005a7c:	00078067          	jr	a5
    80005a80:	ffa00513          	li	a0,-6
    80005a84:	54c000ef          	jal	ra,80005fd0 <rt_set_errno>
    80005a88:	02813083          	ld	ra,40(sp)
    80005a8c:	02013403          	ld	s0,32(sp)
    80005a90:	01813483          	ld	s1,24(sp)
    80005a94:	01013903          	ld	s2,16(sp)
    80005a98:	00813983          	ld	s3,8(sp)
    80005a9c:	00000513          	li	a0,0
    80005aa0:	03010113          	addi	sp,sp,48
    80005aa4:	00008067          	ret

0000000080005aa8 <rt_device_control>:
    80005aa8:	fe010113          	addi	sp,sp,-32
    80005aac:	00813823          	sd	s0,16(sp)
    80005ab0:	00913423          	sd	s1,8(sp)
    80005ab4:	01213023          	sd	s2,0(sp)
    80005ab8:	00113c23          	sd	ra,24(sp)
    80005abc:	00050413          	mv	s0,a0
    80005ac0:	00058493          	mv	s1,a1
    80005ac4:	00060913          	mv	s2,a2
    80005ac8:	00051e63          	bnez	a0,80005ae4 <rt_device_control+0x3c>
    80005acc:	17c00613          	li	a2,380
    80005ad0:	0000b597          	auipc	a1,0xb
    80005ad4:	79858593          	addi	a1,a1,1944 # 80011268 <__FUNCTION__.2>
    80005ad8:	0000b517          	auipc	a0,0xb
    80005adc:	6a850513          	addi	a0,a0,1704 # 80011180 <__fsym_list_mem_name+0x10>
    80005ae0:	094010ef          	jal	ra,80006b74 <rt_assert_handler>
    80005ae4:	00040513          	mv	a0,s0
    80005ae8:	1bc020ef          	jal	ra,80007ca4 <rt_object_get_type>
    80005aec:	00900793          	li	a5,9
    80005af0:	00f50e63          	beq	a0,a5,80005b0c <rt_device_control+0x64>
    80005af4:	17d00613          	li	a2,381
    80005af8:	0000b597          	auipc	a1,0xb
    80005afc:	77058593          	addi	a1,a1,1904 # 80011268 <__FUNCTION__.2>
    80005b00:	0000b517          	auipc	a0,0xb
    80005b04:	69050513          	addi	a0,a0,1680 # 80011190 <__fsym_list_mem_name+0x20>
    80005b08:	06c010ef          	jal	ra,80006b74 <rt_assert_handler>
    80005b0c:	07043783          	ld	a5,112(s0)
    80005b10:	02078463          	beqz	a5,80005b38 <rt_device_control+0x90>
    80005b14:	00040513          	mv	a0,s0
    80005b18:	01013403          	ld	s0,16(sp)
    80005b1c:	01813083          	ld	ra,24(sp)
    80005b20:	00090613          	mv	a2,s2
    80005b24:	00048593          	mv	a1,s1
    80005b28:	00013903          	ld	s2,0(sp)
    80005b2c:	00813483          	ld	s1,8(sp)
    80005b30:	02010113          	addi	sp,sp,32
    80005b34:	00078067          	jr	a5
    80005b38:	01813083          	ld	ra,24(sp)
    80005b3c:	01013403          	ld	s0,16(sp)
    80005b40:	00813483          	ld	s1,8(sp)
    80005b44:	00013903          	ld	s2,0(sp)
    80005b48:	ffa00513          	li	a0,-6
    80005b4c:	02010113          	addi	sp,sp,32
    80005b50:	00008067          	ret

0000000080005b54 <rt_device_set_rx_indicate>:
    80005b54:	fe010113          	addi	sp,sp,-32
    80005b58:	00813823          	sd	s0,16(sp)
    80005b5c:	00913423          	sd	s1,8(sp)
    80005b60:	00113c23          	sd	ra,24(sp)
    80005b64:	00050413          	mv	s0,a0
    80005b68:	00058493          	mv	s1,a1
    80005b6c:	00051e63          	bnez	a0,80005b88 <rt_device_set_rx_indicate+0x34>
    80005b70:	19600613          	li	a2,406
    80005b74:	0000b597          	auipc	a1,0xb
    80005b78:	6d458593          	addi	a1,a1,1748 # 80011248 <__FUNCTION__.1>
    80005b7c:	0000b517          	auipc	a0,0xb
    80005b80:	60450513          	addi	a0,a0,1540 # 80011180 <__fsym_list_mem_name+0x10>
    80005b84:	7f1000ef          	jal	ra,80006b74 <rt_assert_handler>
    80005b88:	00040513          	mv	a0,s0
    80005b8c:	118020ef          	jal	ra,80007ca4 <rt_object_get_type>
    80005b90:	00900793          	li	a5,9
    80005b94:	00f50e63          	beq	a0,a5,80005bb0 <rt_device_set_rx_indicate+0x5c>
    80005b98:	19700613          	li	a2,407
    80005b9c:	0000b597          	auipc	a1,0xb
    80005ba0:	6ac58593          	addi	a1,a1,1708 # 80011248 <__FUNCTION__.1>
    80005ba4:	0000b517          	auipc	a0,0xb
    80005ba8:	5ec50513          	addi	a0,a0,1516 # 80011190 <__fsym_list_mem_name+0x20>
    80005bac:	7c9000ef          	jal	ra,80006b74 <rt_assert_handler>
    80005bb0:	02943c23          	sd	s1,56(s0)
    80005bb4:	01813083          	ld	ra,24(sp)
    80005bb8:	01013403          	ld	s0,16(sp)
    80005bbc:	00813483          	ld	s1,8(sp)
    80005bc0:	00000513          	li	a0,0
    80005bc4:	02010113          	addi	sp,sp,32
    80005bc8:	00008067          	ret

0000000080005bcc <rt_thread_defunct_enqueue>:
    80005bcc:	00010797          	auipc	a5,0x10
    80005bd0:	9a478793          	addi	a5,a5,-1628 # 80015570 <_rt_thread_defunct>
    80005bd4:	0007b683          	ld	a3,0(a5)
    80005bd8:	02850713          	addi	a4,a0,40
    80005bdc:	00e7b023          	sd	a4,0(a5)
    80005be0:	00e6b423          	sd	a4,8(a3)
    80005be4:	02d53423          	sd	a3,40(a0)
    80005be8:	02f53823          	sd	a5,48(a0)
    80005bec:	00008067          	ret

0000000080005bf0 <rt_thread_defunct_dequeue>:
    80005bf0:	00010717          	auipc	a4,0x10
    80005bf4:	98070713          	addi	a4,a4,-1664 # 80015570 <_rt_thread_defunct>
    80005bf8:	00073783          	ld	a5,0(a4)
    80005bfc:	00000513          	li	a0,0
    80005c00:	02e78063          	beq	a5,a4,80005c20 <rt_thread_defunct_dequeue+0x30>
    80005c04:	0007b683          	ld	a3,0(a5)
    80005c08:	0087b703          	ld	a4,8(a5)
    80005c0c:	fd878513          	addi	a0,a5,-40
    80005c10:	00e6b423          	sd	a4,8(a3)
    80005c14:	00d73023          	sd	a3,0(a4)
    80005c18:	00f7b423          	sd	a5,8(a5)
    80005c1c:	00f7b023          	sd	a5,0(a5)
    80005c20:	00008067          	ret

0000000080005c24 <rt_thread_idle_entry>:
    80005c24:	fb010113          	addi	sp,sp,-80
    80005c28:	03213823          	sd	s2,48(sp)
    80005c2c:	03313423          	sd	s3,40(sp)
    80005c30:	03413023          	sd	s4,32(sp)
    80005c34:	01513c23          	sd	s5,24(sp)
    80005c38:	01613823          	sd	s6,16(sp)
    80005c3c:	04113423          	sd	ra,72(sp)
    80005c40:	04813023          	sd	s0,64(sp)
    80005c44:	02913c23          	sd	s1,56(sp)
    80005c48:	01713423          	sd	s7,8(sp)
    80005c4c:	0001c997          	auipc	s3,0x1c
    80005c50:	2ec98993          	addi	s3,s3,748 # 80021f38 <rt_thread_stack>
    80005c54:	0000b917          	auipc	s2,0xb
    80005c58:	67490913          	addi	s2,s2,1652 # 800112c8 <__FUNCTION__.0>
    80005c5c:	0000ba17          	auipc	s4,0xb
    80005c60:	1eca0a13          	addi	s4,s4,492 # 80010e48 <__FUNCTION__.1+0x1f8>
    80005c64:	0000ba97          	auipc	s5,0xb
    80005c68:	20ca8a93          	addi	s5,s5,524 # 80010e70 <__FUNCTION__.1+0x220>
    80005c6c:	00100b13          	li	s6,1
    80005c70:	0001c417          	auipc	s0,0x1c
    80005c74:	2a840413          	addi	s0,s0,680 # 80021f18 <idle_hook_list>
    80005c78:	00043783          	ld	a5,0(s0)
    80005c7c:	00078463          	beqz	a5,80005c84 <rt_thread_idle_entry+0x60>
    80005c80:	000780e7          	jalr	a5
    80005c84:	00840413          	addi	s0,s0,8
    80005c88:	fe8998e3          	bne	s3,s0,80005c78 <rt_thread_idle_entry+0x54>
    80005c8c:	bc4fa0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80005c90:	00050413          	mv	s0,a0
    80005c94:	818fe0ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    80005c98:	02050063          	beqz	a0,80005cb8 <rt_thread_idle_entry+0x94>
    80005c9c:	00090593          	mv	a1,s2
    80005ca0:	000a0513          	mv	a0,s4
    80005ca4:	549000ef          	jal	ra,800069ec <rt_kprintf>
    80005ca8:	0cb00613          	li	a2,203
    80005cac:	00090593          	mv	a1,s2
    80005cb0:	000a8513          	mv	a0,s5
    80005cb4:	6c1000ef          	jal	ra,80006b74 <rt_assert_handler>
    80005cb8:	00040513          	mv	a0,s0
    80005cbc:	b9cfa0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80005cc0:	b90fa0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80005cc4:	00050493          	mv	s1,a0
    80005cc8:	f29ff0ef          	jal	ra,80005bf0 <rt_thread_defunct_dequeue>
    80005ccc:	00050413          	mv	s0,a0
    80005cd0:	00051863          	bnez	a0,80005ce0 <rt_thread_idle_entry+0xbc>
    80005cd4:	00048513          	mv	a0,s1
    80005cd8:	b80fa0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80005cdc:	f95ff06f          	j	80005c70 <rt_thread_idle_entry+0x4c>
    80005ce0:	0d853b83          	ld	s7,216(a0)
    80005ce4:	000b8e63          	beqz	s7,80005d00 <rt_thread_idle_entry+0xdc>
    80005ce8:	00048513          	mv	a0,s1
    80005cec:	b6cfa0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80005cf0:	00040513          	mv	a0,s0
    80005cf4:	000b80e7          	jalr	s7
    80005cf8:	b58fa0ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80005cfc:	00050493          	mv	s1,a0
    80005d00:	00040513          	mv	a0,s0
    80005d04:	75d010ef          	jal	ra,80007c60 <rt_object_is_systemobject>
    80005d08:	01651c63          	bne	a0,s6,80005d20 <rt_thread_idle_entry+0xfc>
    80005d0c:	00040513          	mv	a0,s0
    80005d10:	529010ef          	jal	ra,80007a38 <rt_object_detach>
    80005d14:	00048513          	mv	a0,s1
    80005d18:	b40fa0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80005d1c:	f71ff06f          	j	80005c8c <rt_thread_idle_entry+0x68>
    80005d20:	00048513          	mv	a0,s1
    80005d24:	b34fa0ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80005d28:	05043503          	ld	a0,80(s0)
    80005d2c:	d44ff0ef          	jal	ra,80005270 <rt_free>
    80005d30:	00040513          	mv	a0,s0
    80005d34:	691010ef          	jal	ra,80007bc4 <rt_object_delete>
    80005d38:	f55ff06f          	j	80005c8c <rt_thread_idle_entry+0x68>

0000000080005d3c <rt_thread_idle_init>:
    80005d3c:	fd010113          	addi	sp,sp,-48
    80005d40:	00000613          	li	a2,0
    80005d44:	0000b597          	auipc	a1,0xb
    80005d48:	57c58593          	addi	a1,a1,1404 # 800112c0 <__FUNCTION__.6+0x10>
    80005d4c:	00810513          	addi	a0,sp,8
    80005d50:	02113423          	sd	ra,40(sp)
    80005d54:	02813023          	sd	s0,32(sp)
    80005d58:	3dd000ef          	jal	ra,80006934 <rt_sprintf>
    80005d5c:	0001c417          	auipc	s0,0x1c
    80005d60:	0d440413          	addi	s0,s0,212 # 80021e30 <idle>
    80005d64:	00810593          	addi	a1,sp,8
    80005d68:	02000893          	li	a7,32
    80005d6c:	01f00813          	li	a6,31
    80005d70:	000047b7          	lui	a5,0x4
    80005d74:	0001c717          	auipc	a4,0x1c
    80005d78:	1c470713          	addi	a4,a4,452 # 80021f38 <rt_thread_stack>
    80005d7c:	00000693          	li	a3,0
    80005d80:	00000617          	auipc	a2,0x0
    80005d84:	ea460613          	addi	a2,a2,-348 # 80005c24 <rt_thread_idle_entry>
    80005d88:	00040513          	mv	a0,s0
    80005d8c:	19c010ef          	jal	ra,80006f28 <rt_thread_init>
    80005d90:	00040513          	mv	a0,s0
    80005d94:	7c8010ef          	jal	ra,8000755c <rt_thread_startup>
    80005d98:	02813083          	ld	ra,40(sp)
    80005d9c:	02013403          	ld	s0,32(sp)
    80005da0:	03010113          	addi	sp,sp,48
    80005da4:	00008067          	ret

0000000080005da8 <print_number>:
    80005da8:	04087893          	andi	a7,a6,64
    80005dac:	ff010113          	addi	sp,sp,-16
    80005db0:	0000b297          	auipc	t0,0xb
    80005db4:	77828293          	addi	t0,t0,1912 # 80011528 <small_digits.1>
    80005db8:	00088663          	beqz	a7,80005dc4 <print_number+0x1c>
    80005dbc:	0000b297          	auipc	t0,0xb
    80005dc0:	75428293          	addi	t0,t0,1876 # 80011510 <large_digits.2>
    80005dc4:	01087f93          	andi	t6,a6,16
    80005dc8:	040f8c63          	beqz	t6,80005e20 <print_number+0x78>
    80005dcc:	ffe87813          	andi	a6,a6,-2
    80005dd0:	02000e93          	li	t4,32
    80005dd4:	00287893          	andi	a7,a6,2
    80005dd8:	10088263          	beqz	a7,80005edc <print_number+0x134>
    80005ddc:	04065c63          	bgez	a2,80005e34 <print_number+0x8c>
    80005de0:	40c00633          	neg	a2,a2
    80005de4:	02d00313          	li	t1,45
    80005de8:	00010f13          	mv	t5,sp
    80005dec:	00000893          	li	a7,0
    80005df0:	00a00393          	li	t2,10
    80005df4:	0e769863          	bne	a3,t2,80005ee4 <print_number+0x13c>
    80005df8:	02d67e33          	remu	t3,a2,a3
    80005dfc:	02d65633          	divu	a2,a2,a3
    80005e00:	000e0e1b          	sext.w	t3,t3
    80005e04:	01c28e33          	add	t3,t0,t3
    80005e08:	000e4e03          	lbu	t3,0(t3)
    80005e0c:	0018889b          	addiw	a7,a7,1
    80005e10:	001f0f13          	addi	t5,t5,1
    80005e14:	ffcf0fa3          	sb	t3,-1(t5)
    80005e18:	fc061ee3          	bnez	a2,80005df4 <print_number+0x4c>
    80005e1c:	03c0006f          	j	80005e58 <print_number+0xb0>
    80005e20:	00187893          	andi	a7,a6,1
    80005e24:	02000e93          	li	t4,32
    80005e28:	fa0886e3          	beqz	a7,80005dd4 <print_number+0x2c>
    80005e2c:	03000e93          	li	t4,48
    80005e30:	fa5ff06f          	j	80005dd4 <print_number+0x2c>
    80005e34:	00487893          	andi	a7,a6,4
    80005e38:	02b00313          	li	t1,43
    80005e3c:	00089663          	bnez	a7,80005e48 <print_number+0xa0>
    80005e40:	00281313          	slli	t1,a6,0x2
    80005e44:	02037313          	andi	t1,t1,32
    80005e48:	fa0610e3          	bnez	a2,80005de8 <print_number+0x40>
    80005e4c:	03000693          	li	a3,48
    80005e50:	00d10023          	sb	a3,0(sp)
    80005e54:	00100893          	li	a7,1
    80005e58:	00088693          	mv	a3,a7
    80005e5c:	00f8d463          	bge	a7,a5,80005e64 <print_number+0xbc>
    80005e60:	00078693          	mv	a3,a5
    80005e64:	01187813          	andi	a6,a6,17
    80005e68:	00068e1b          	sext.w	t3,a3
    80005e6c:	40d7073b          	subw	a4,a4,a3
    80005e70:	04081063          	bnez	a6,80005eb0 <print_number+0x108>
    80005e74:	00030663          	beqz	t1,80005e80 <print_number+0xd8>
    80005e78:	00e05463          	blez	a4,80005e80 <print_number+0xd8>
    80005e7c:	fff7071b          	addiw	a4,a4,-1
    80005e80:	00050693          	mv	a3,a0
    80005e84:	00a7083b          	addw	a6,a4,a0
    80005e88:	02000f13          	li	t5,32
    80005e8c:	40d8063b          	subw	a2,a6,a3
    80005e90:	06c04063          	bgtz	a2,80005ef0 <print_number+0x148>
    80005e94:	00070693          	mv	a3,a4
    80005e98:	00075463          	bgez	a4,80005ea0 <print_number+0xf8>
    80005e9c:	00000693          	li	a3,0
    80005ea0:	0006861b          	sext.w	a2,a3
    80005ea4:	fff7071b          	addiw	a4,a4,-1
    80005ea8:	00c50533          	add	a0,a0,a2
    80005eac:	40d7073b          	subw	a4,a4,a3
    80005eb0:	00030a63          	beqz	t1,80005ec4 <print_number+0x11c>
    80005eb4:	00b57463          	bgeu	a0,a1,80005ebc <print_number+0x114>
    80005eb8:	00650023          	sb	t1,0(a0)
    80005ebc:	fff7071b          	addiw	a4,a4,-1
    80005ec0:	00150513          	addi	a0,a0,1
    80005ec4:	060f8863          	beqz	t6,80005f34 <print_number+0x18c>
    80005ec8:	00050693          	mv	a3,a0
    80005ecc:	000e061b          	sext.w	a2,t3
    80005ed0:	01c5033b          	addw	t1,a0,t3
    80005ed4:	03000e93          	li	t4,48
    80005ed8:	0740006f          	j	80005f4c <print_number+0x1a4>
    80005edc:	00000313          	li	t1,0
    80005ee0:	f69ff06f          	j	80005e48 <print_number+0xa0>
    80005ee4:	00f67e13          	andi	t3,a2,15
    80005ee8:	00465613          	srli	a2,a2,0x4
    80005eec:	f19ff06f          	j	80005e04 <print_number+0x5c>
    80005ef0:	00b6f463          	bgeu	a3,a1,80005ef8 <print_number+0x150>
    80005ef4:	01e68023          	sb	t5,0(a3)
    80005ef8:	00168693          	addi	a3,a3,1
    80005efc:	f91ff06f          	j	80005e8c <print_number+0xe4>
    80005f00:	00b6f463          	bgeu	a3,a1,80005f08 <print_number+0x160>
    80005f04:	01d68023          	sb	t4,0(a3)
    80005f08:	00168693          	addi	a3,a3,1
    80005f0c:	40d8063b          	subw	a2,a6,a3
    80005f10:	fec048e3          	bgtz	a2,80005f00 <print_number+0x158>
    80005f14:	00070693          	mv	a3,a4
    80005f18:	00075463          	bgez	a4,80005f20 <print_number+0x178>
    80005f1c:	00000693          	li	a3,0
    80005f20:	0006861b          	sext.w	a2,a3
    80005f24:	fff7071b          	addiw	a4,a4,-1
    80005f28:	00c50533          	add	a0,a0,a2
    80005f2c:	40d7073b          	subw	a4,a4,a3
    80005f30:	f99ff06f          	j	80005ec8 <print_number+0x120>
    80005f34:	00050693          	mv	a3,a0
    80005f38:	00a7083b          	addw	a6,a4,a0
    80005f3c:	fd1ff06f          	j	80005f0c <print_number+0x164>
    80005f40:	00b6f463          	bgeu	a3,a1,80005f48 <print_number+0x1a0>
    80005f44:	01d68023          	sb	t4,0(a3)
    80005f48:	00168693          	addi	a3,a3,1
    80005f4c:	40d3083b          	subw	a6,t1,a3
    80005f50:	ff08c8e3          	blt	a7,a6,80005f40 <print_number+0x198>
    80005f54:	00000693          	li	a3,0
    80005f58:	011e4863          	blt	t3,a7,80005f68 <print_number+0x1c0>
    80005f5c:	411606bb          	subw	a3,a2,a7
    80005f60:	02069693          	slli	a3,a3,0x20
    80005f64:	0206d693          	srli	a3,a3,0x20
    80005f68:	00d50533          	add	a0,a0,a3
    80005f6c:	0008869b          	sext.w	a3,a7
    80005f70:	00d05463          	blez	a3,80005f78 <print_number+0x1d0>
    80005f74:	00079a63          	bnez	a5,80005f88 <print_number+0x1e0>
    80005f78:	00050793          	mv	a5,a0
    80005f7c:	00e5063b          	addw	a2,a0,a4
    80005f80:	02000813          	li	a6,32
    80005f84:	02c0006f          	j	80005fb0 <print_number+0x208>
    80005f88:	00b57863          	bgeu	a0,a1,80005f98 <print_number+0x1f0>
    80005f8c:	011106b3          	add	a3,sp,a7
    80005f90:	fff6c683          	lbu	a3,-1(a3)
    80005f94:	00d50023          	sb	a3,0(a0)
    80005f98:	00150513          	addi	a0,a0,1
    80005f9c:	fff88893          	addi	a7,a7,-1
    80005fa0:	fcdff06f          	j	80005f6c <print_number+0x1c4>
    80005fa4:	00b7f463          	bgeu	a5,a1,80005fac <print_number+0x204>
    80005fa8:	01078023          	sb	a6,0(a5) # 4000 <__STACKSIZE__>
    80005fac:	00178793          	addi	a5,a5,1
    80005fb0:	40f606bb          	subw	a3,a2,a5
    80005fb4:	fed048e3          	bgtz	a3,80005fa4 <print_number+0x1fc>
    80005fb8:	0007079b          	sext.w	a5,a4
    80005fbc:	00075463          	bgez	a4,80005fc4 <print_number+0x21c>
    80005fc0:	00000793          	li	a5,0
    80005fc4:	00f50533          	add	a0,a0,a5
    80005fc8:	01010113          	addi	sp,sp,16
    80005fcc:	00008067          	ret

0000000080005fd0 <rt_set_errno>:
    80005fd0:	ff010113          	addi	sp,sp,-16
    80005fd4:	00813023          	sd	s0,0(sp)
    80005fd8:	00113423          	sd	ra,8(sp)
    80005fdc:	00050413          	mv	s0,a0
    80005fe0:	ccdfd0ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    80005fe4:	00050e63          	beqz	a0,80006000 <rt_set_errno+0x30>
    80005fe8:	00018797          	auipc	a5,0x18
    80005fec:	9887a023          	sw	s0,-1664(a5) # 8001d968 <__rt_errno>
    80005ff0:	00813083          	ld	ra,8(sp)
    80005ff4:	00013403          	ld	s0,0(sp)
    80005ff8:	01010113          	addi	sp,sp,16
    80005ffc:	00008067          	ret
    80006000:	000010ef          	jal	ra,80007000 <rt_thread_self>
    80006004:	fe0502e3          	beqz	a0,80005fe8 <rt_set_errno+0x18>
    80006008:	06853023          	sd	s0,96(a0)
    8000600c:	fe5ff06f          	j	80005ff0 <rt_set_errno+0x20>

0000000080006010 <rt_memset>:
    80006010:	00700713          	li	a4,7
    80006014:	00050793          	mv	a5,a0
    80006018:	00c77663          	bgeu	a4,a2,80006024 <rt_memset+0x14>
    8000601c:	00757713          	andi	a4,a0,7
    80006020:	00070863          	beqz	a4,80006030 <rt_memset+0x20>
    80006024:	00c78633          	add	a2,a5,a2
    80006028:	0ac79063          	bne	a5,a2,800060c8 <rt_memset+0xb8>
    8000602c:	00008067          	ret
    80006030:	00800793          	li	a5,8
    80006034:	0ff5f693          	zext.b	a3,a1
    80006038:	00871713          	slli	a4,a4,0x8
    8000603c:	fff7879b          	addiw	a5,a5,-1
    80006040:	00e6e733          	or	a4,a3,a4
    80006044:	fe079ae3          	bnez	a5,80006038 <rt_memset+0x28>
    80006048:	00050793          	mv	a5,a0
    8000604c:	00c508b3          	add	a7,a0,a2
    80006050:	01f00693          	li	a3,31
    80006054:	40f88833          	sub	a6,a7,a5
    80006058:	0506e663          	bltu	a3,a6,800060a4 <rt_memset+0x94>
    8000605c:	00565793          	srli	a5,a2,0x5
    80006060:	fe000693          	li	a3,-32
    80006064:	02d786b3          	mul	a3,a5,a3
    80006068:	00579793          	slli	a5,a5,0x5
    8000606c:	00f507b3          	add	a5,a0,a5
    80006070:	00700813          	li	a6,7
    80006074:	00c68633          	add	a2,a3,a2
    80006078:	00c78333          	add	t1,a5,a2
    8000607c:	00078693          	mv	a3,a5
    80006080:	40d308b3          	sub	a7,t1,a3
    80006084:	03186c63          	bltu	a6,a7,800060bc <rt_memset+0xac>
    80006088:	00365713          	srli	a4,a2,0x3
    8000608c:	ff800693          	li	a3,-8
    80006090:	02d706b3          	mul	a3,a4,a3
    80006094:	00371713          	slli	a4,a4,0x3
    80006098:	00e787b3          	add	a5,a5,a4
    8000609c:	00c68633          	add	a2,a3,a2
    800060a0:	f85ff06f          	j	80006024 <rt_memset+0x14>
    800060a4:	00e7b023          	sd	a4,0(a5)
    800060a8:	00e7b423          	sd	a4,8(a5)
    800060ac:	00e7b823          	sd	a4,16(a5)
    800060b0:	00e7bc23          	sd	a4,24(a5)
    800060b4:	02078793          	addi	a5,a5,32
    800060b8:	f9dff06f          	j	80006054 <rt_memset+0x44>
    800060bc:	00868693          	addi	a3,a3,8
    800060c0:	fee6bc23          	sd	a4,-8(a3)
    800060c4:	fbdff06f          	j	80006080 <rt_memset+0x70>
    800060c8:	00178793          	addi	a5,a5,1
    800060cc:	feb78fa3          	sb	a1,-1(a5)
    800060d0:	f59ff06f          	j	80006028 <rt_memset+0x18>

00000000800060d4 <rt_memcpy>:
    800060d4:	0006061b          	sext.w	a2,a2
    800060d8:	01f00793          	li	a5,31
    800060dc:	00050713          	mv	a4,a0
    800060e0:	00c7f863          	bgeu	a5,a2,800060f0 <rt_memcpy+0x1c>
    800060e4:	00a5e833          	or	a6,a1,a0
    800060e8:	00787813          	andi	a6,a6,7
    800060ec:	08080c63          	beqz	a6,80006184 <rt_memcpy+0xb0>
    800060f0:	00000793          	li	a5,0
    800060f4:	0007869b          	sext.w	a3,a5
    800060f8:	0ad61a63          	bne	a2,a3,800061ac <rt_memcpy+0xd8>
    800060fc:	00008067          	ret
    80006100:	0007b883          	ld	a7,0(a5)
    80006104:	02078793          	addi	a5,a5,32
    80006108:	02070713          	addi	a4,a4,32
    8000610c:	ff173023          	sd	a7,-32(a4)
    80006110:	fe87b883          	ld	a7,-24(a5)
    80006114:	ff173423          	sd	a7,-24(a4)
    80006118:	ff07b883          	ld	a7,-16(a5)
    8000611c:	ff173823          	sd	a7,-16(a4)
    80006120:	ff87b883          	ld	a7,-8(a5)
    80006124:	ff173c23          	sd	a7,-8(a4)
    80006128:	40f308bb          	subw	a7,t1,a5
    8000612c:	fd16eae3          	bltu	a3,a7,80006100 <rt_memcpy+0x2c>
    80006130:	0056589b          	srliw	a7,a2,0x5
    80006134:	fe000793          	li	a5,-32
    80006138:	031787bb          	mulw	a5,a5,a7
    8000613c:	0056571b          	srliw	a4,a2,0x5
    80006140:	00571713          	slli	a4,a4,0x5
    80006144:	00e506b3          	add	a3,a0,a4
    80006148:	00e585b3          	add	a1,a1,a4
    8000614c:	00c7863b          	addw	a2,a5,a2
    80006150:	0006089b          	sext.w	a7,a2
    80006154:	00700793          	li	a5,7
    80006158:	4108873b          	subw	a4,a7,a6
    8000615c:	02e7cc63          	blt	a5,a4,80006194 <rt_memcpy+0xc0>
    80006160:	0036579b          	srliw	a5,a2,0x3
    80006164:	00379793          	slli	a5,a5,0x3
    80006168:	0036581b          	srliw	a6,a2,0x3
    8000616c:	00f68733          	add	a4,a3,a5
    80006170:	ff800693          	li	a3,-8
    80006174:	030686bb          	mulw	a3,a3,a6
    80006178:	00f585b3          	add	a1,a1,a5
    8000617c:	00c6863b          	addw	a2,a3,a2
    80006180:	f71ff06f          	j	800060f0 <rt_memcpy+0x1c>
    80006184:	00058793          	mv	a5,a1
    80006188:	00c5833b          	addw	t1,a1,a2
    8000618c:	01f00693          	li	a3,31
    80006190:	f99ff06f          	j	80006128 <rt_memcpy+0x54>
    80006194:	01058733          	add	a4,a1,a6
    80006198:	00073303          	ld	t1,0(a4)
    8000619c:	01068733          	add	a4,a3,a6
    800061a0:	00880813          	addi	a6,a6,8
    800061a4:	00673023          	sd	t1,0(a4)
    800061a8:	fb1ff06f          	j	80006158 <rt_memcpy+0x84>
    800061ac:	00f586b3          	add	a3,a1,a5
    800061b0:	0006c803          	lbu	a6,0(a3)
    800061b4:	00f706b3          	add	a3,a4,a5
    800061b8:	00178793          	addi	a5,a5,1
    800061bc:	01068023          	sb	a6,0(a3)
    800061c0:	f35ff06f          	j	800060f4 <rt_memcpy+0x20>

00000000800061c4 <rt_memmove>:
    800061c4:	04a5fa63          	bgeu	a1,a0,80006218 <rt_memmove+0x54>
    800061c8:	00c586b3          	add	a3,a1,a2
    800061cc:	04d57663          	bgeu	a0,a3,80006218 <rt_memmove+0x54>
    800061d0:	fff64593          	not	a1,a2
    800061d4:	00000793          	li	a5,0
    800061d8:	fff78793          	addi	a5,a5,-1
    800061dc:	00f59463          	bne	a1,a5,800061e4 <rt_memmove+0x20>
    800061e0:	00008067          	ret
    800061e4:	00f68733          	add	a4,a3,a5
    800061e8:	00074803          	lbu	a6,0(a4)
    800061ec:	00f60733          	add	a4,a2,a5
    800061f0:	00e50733          	add	a4,a0,a4
    800061f4:	01070023          	sb	a6,0(a4)
    800061f8:	fe1ff06f          	j	800061d8 <rt_memmove+0x14>
    800061fc:	00f58733          	add	a4,a1,a5
    80006200:	00074683          	lbu	a3,0(a4)
    80006204:	00f50733          	add	a4,a0,a5
    80006208:	00178793          	addi	a5,a5,1
    8000620c:	00d70023          	sb	a3,0(a4)
    80006210:	fef616e3          	bne	a2,a5,800061fc <rt_memmove+0x38>
    80006214:	00008067          	ret
    80006218:	00000793          	li	a5,0
    8000621c:	ff5ff06f          	j	80006210 <rt_memmove+0x4c>

0000000080006220 <rt_memcmp>:
    80006220:	00050693          	mv	a3,a0
    80006224:	00000713          	li	a4,0
    80006228:	00e61663          	bne	a2,a4,80006234 <rt_memcmp+0x14>
    8000622c:	00000513          	li	a0,0
    80006230:	0200006f          	j	80006250 <rt_memcmp+0x30>
    80006234:	00e687b3          	add	a5,a3,a4
    80006238:	00e58533          	add	a0,a1,a4
    8000623c:	0007c783          	lbu	a5,0(a5)
    80006240:	00054503          	lbu	a0,0(a0)
    80006244:	00170713          	addi	a4,a4,1
    80006248:	40a7853b          	subw	a0,a5,a0
    8000624c:	fc050ee3          	beqz	a0,80006228 <rt_memcmp+0x8>
    80006250:	00008067          	ret

0000000080006254 <rt_strncpy>:
    80006254:	04060063          	beqz	a2,80006294 <rt_strncpy+0x40>
    80006258:	00050793          	mv	a5,a0
    8000625c:	0005c683          	lbu	a3,0(a1)
    80006260:	00158593          	addi	a1,a1,1
    80006264:	00178793          	addi	a5,a5,1
    80006268:	fed78fa3          	sb	a3,-1(a5)
    8000626c:	00060713          	mv	a4,a2
    80006270:	fff60613          	addi	a2,a2,-1
    80006274:	00069e63          	bnez	a3,80006290 <rt_strncpy+0x3c>
    80006278:	00e78733          	add	a4,a5,a4
    8000627c:	00178793          	addi	a5,a5,1
    80006280:	00e79463          	bne	a5,a4,80006288 <rt_strncpy+0x34>
    80006284:	00008067          	ret
    80006288:	fe078fa3          	sb	zero,-1(a5)
    8000628c:	ff1ff06f          	j	8000627c <rt_strncpy+0x28>
    80006290:	fc0616e3          	bnez	a2,8000625c <rt_strncpy+0x8>
    80006294:	00008067          	ret

0000000080006298 <rt_strncmp>:
    80006298:	00050693          	mv	a3,a0
    8000629c:	00000713          	li	a4,0
    800062a0:	00e61663          	bne	a2,a4,800062ac <rt_strncmp+0x14>
    800062a4:	00000513          	li	a0,0
    800062a8:	02c0006f          	j	800062d4 <rt_strncmp+0x3c>
    800062ac:	00e687b3          	add	a5,a3,a4
    800062b0:	0007c803          	lbu	a6,0(a5)
    800062b4:	00e587b3          	add	a5,a1,a4
    800062b8:	0007c783          	lbu	a5,0(a5)
    800062bc:	40f807bb          	subw	a5,a6,a5
    800062c0:	0187951b          	slliw	a0,a5,0x18
    800062c4:	4185551b          	sraiw	a0,a0,0x18
    800062c8:	00051663          	bnez	a0,800062d4 <rt_strncmp+0x3c>
    800062cc:	00170713          	addi	a4,a4,1
    800062d0:	fc0818e3          	bnez	a6,800062a0 <rt_strncmp+0x8>
    800062d4:	00008067          	ret

00000000800062d8 <rt_strcmp>:
    800062d8:	00054783          	lbu	a5,0(a0)
    800062dc:	0005c703          	lbu	a4,0(a1)
    800062e0:	00078463          	beqz	a5,800062e8 <rt_strcmp+0x10>
    800062e4:	00e78663          	beq	a5,a4,800062f0 <rt_strcmp+0x18>
    800062e8:	40e7853b          	subw	a0,a5,a4
    800062ec:	00008067          	ret
    800062f0:	00150513          	addi	a0,a0,1
    800062f4:	00158593          	addi	a1,a1,1
    800062f8:	fe1ff06f          	j	800062d8 <rt_strcmp>

00000000800062fc <rt_strlen>:
    800062fc:	00050793          	mv	a5,a0
    80006300:	0007c703          	lbu	a4,0(a5)
    80006304:	00071663          	bnez	a4,80006310 <rt_strlen+0x14>
    80006308:	40a78533          	sub	a0,a5,a0
    8000630c:	00008067          	ret
    80006310:	00178793          	addi	a5,a5,1
    80006314:	fedff06f          	j	80006300 <rt_strlen+0x4>

0000000080006318 <rt_strstr>:
    80006318:	fd010113          	addi	sp,sp,-48
    8000631c:	02813023          	sd	s0,32(sp)
    80006320:	00050413          	mv	s0,a0
    80006324:	00058513          	mv	a0,a1
    80006328:	00913c23          	sd	s1,24(sp)
    8000632c:	01213823          	sd	s2,16(sp)
    80006330:	02113423          	sd	ra,40(sp)
    80006334:	01313423          	sd	s3,8(sp)
    80006338:	00058913          	mv	s2,a1
    8000633c:	fc1ff0ef          	jal	ra,800062fc <rt_strlen>
    80006340:	0005049b          	sext.w	s1,a0
    80006344:	00048e63          	beqz	s1,80006360 <rt_strstr+0x48>
    80006348:	00040513          	mv	a0,s0
    8000634c:	fb1ff0ef          	jal	ra,800062fc <rt_strlen>
    80006350:	008509bb          	addw	s3,a0,s0
    80006354:	408987bb          	subw	a5,s3,s0
    80006358:	0297d463          	bge	a5,s1,80006380 <rt_strstr+0x68>
    8000635c:	00000413          	li	s0,0
    80006360:	02813083          	ld	ra,40(sp)
    80006364:	00040513          	mv	a0,s0
    80006368:	02013403          	ld	s0,32(sp)
    8000636c:	01813483          	ld	s1,24(sp)
    80006370:	01013903          	ld	s2,16(sp)
    80006374:	00813983          	ld	s3,8(sp)
    80006378:	03010113          	addi	sp,sp,48
    8000637c:	00008067          	ret
    80006380:	00048613          	mv	a2,s1
    80006384:	00090593          	mv	a1,s2
    80006388:	00040513          	mv	a0,s0
    8000638c:	e95ff0ef          	jal	ra,80006220 <rt_memcmp>
    80006390:	fc0508e3          	beqz	a0,80006360 <rt_strstr+0x48>
    80006394:	00140413          	addi	s0,s0,1
    80006398:	fbdff06f          	j	80006354 <rt_strstr+0x3c>

000000008000639c <rt_strdup>:
    8000639c:	fe010113          	addi	sp,sp,-32
    800063a0:	00113c23          	sd	ra,24(sp)
    800063a4:	00813823          	sd	s0,16(sp)
    800063a8:	00a13423          	sd	a0,8(sp)
    800063ac:	f51ff0ef          	jal	ra,800062fc <rt_strlen>
    800063b0:	00150613          	addi	a2,a0,1
    800063b4:	00060513          	mv	a0,a2
    800063b8:	00c13023          	sd	a2,0(sp)
    800063bc:	b69fe0ef          	jal	ra,80004f24 <rt_malloc>
    800063c0:	00050413          	mv	s0,a0
    800063c4:	00050863          	beqz	a0,800063d4 <rt_strdup+0x38>
    800063c8:	00013603          	ld	a2,0(sp)
    800063cc:	00813583          	ld	a1,8(sp)
    800063d0:	d05ff0ef          	jal	ra,800060d4 <rt_memcpy>
    800063d4:	01813083          	ld	ra,24(sp)
    800063d8:	00040513          	mv	a0,s0
    800063dc:	01013403          	ld	s0,16(sp)
    800063e0:	02010113          	addi	sp,sp,32
    800063e4:	00008067          	ret

00000000800063e8 <rt_vsnprintf>:
    800063e8:	fa010113          	addi	sp,sp,-96
    800063ec:	04813823          	sd	s0,80(sp)
    800063f0:	03513423          	sd	s5,40(sp)
    800063f4:	03613023          	sd	s6,32(sp)
    800063f8:	01713c23          	sd	s7,24(sp)
    800063fc:	04113c23          	sd	ra,88(sp)
    80006400:	04913423          	sd	s1,72(sp)
    80006404:	05213023          	sd	s2,64(sp)
    80006408:	03313c23          	sd	s3,56(sp)
    8000640c:	03413823          	sd	s4,48(sp)
    80006410:	01813823          	sd	s8,16(sp)
    80006414:	01913423          	sd	s9,8(sp)
    80006418:	00b50ab3          	add	s5,a0,a1
    8000641c:	00050b13          	mv	s6,a0
    80006420:	00068413          	mv	s0,a3
    80006424:	00058b93          	mv	s7,a1
    80006428:	00aaf663          	bgeu	s5,a0,80006434 <rt_vsnprintf+0x4c>
    8000642c:	fff54b93          	not	s7,a0
    80006430:	fff00a93          	li	s5,-1
    80006434:	000104b7          	lui	s1,0x10
    80006438:	000b0513          	mv	a0,s6
    8000643c:	02b00913          	li	s2,43
    80006440:	02000c13          	li	s8,32
    80006444:	02300993          	li	s3,35
    80006448:	fff48493          	addi	s1,s1,-1 # ffff <__STACKSIZE__+0xbfff>
    8000644c:	0240006f          	j	80006470 <rt_vsnprintf+0x88>
    80006450:	02500713          	li	a4,37
    80006454:	06e78463          	beq	a5,a4,800064bc <rt_vsnprintf+0xd4>
    80006458:	01557463          	bgeu	a0,s5,80006460 <rt_vsnprintf+0x78>
    8000645c:	00f50023          	sb	a5,0(a0)
    80006460:	00150793          	addi	a5,a0,1
    80006464:	00060a13          	mv	s4,a2
    80006468:	001a0613          	addi	a2,s4,1
    8000646c:	00078513          	mv	a0,a5
    80006470:	00064783          	lbu	a5,0(a2)
    80006474:	fc079ee3          	bnez	a5,80006450 <rt_vsnprintf+0x68>
    80006478:	000b8663          	beqz	s7,80006484 <rt_vsnprintf+0x9c>
    8000647c:	47557663          	bgeu	a0,s5,800068e8 <rt_vsnprintf+0x500>
    80006480:	00050023          	sb	zero,0(a0)
    80006484:	05813083          	ld	ra,88(sp)
    80006488:	05013403          	ld	s0,80(sp)
    8000648c:	04813483          	ld	s1,72(sp)
    80006490:	04013903          	ld	s2,64(sp)
    80006494:	03813983          	ld	s3,56(sp)
    80006498:	03013a03          	ld	s4,48(sp)
    8000649c:	02813a83          	ld	s5,40(sp)
    800064a0:	01813b83          	ld	s7,24(sp)
    800064a4:	01013c03          	ld	s8,16(sp)
    800064a8:	00813c83          	ld	s9,8(sp)
    800064ac:	4165053b          	subw	a0,a0,s6
    800064b0:	02013b03          	ld	s6,32(sp)
    800064b4:	06010113          	addi	sp,sp,96
    800064b8:	00008067          	ret
    800064bc:	00000813          	li	a6,0
    800064c0:	02d00713          	li	a4,45
    800064c4:	03000693          	li	a3,48
    800064c8:	0100006f          	j	800064d8 <rt_vsnprintf+0xf0>
    800064cc:	03279063          	bne	a5,s2,800064ec <rt_vsnprintf+0x104>
    800064d0:	00486813          	ori	a6,a6,4
    800064d4:	000a0613          	mv	a2,s4
    800064d8:	00164783          	lbu	a5,1(a2)
    800064dc:	00160a13          	addi	s4,a2,1
    800064e0:	fee796e3          	bne	a5,a4,800064cc <rt_vsnprintf+0xe4>
    800064e4:	01086813          	ori	a6,a6,16
    800064e8:	fedff06f          	j	800064d4 <rt_vsnprintf+0xec>
    800064ec:	01879663          	bne	a5,s8,800064f8 <rt_vsnprintf+0x110>
    800064f0:	00886813          	ori	a6,a6,8
    800064f4:	fe1ff06f          	j	800064d4 <rt_vsnprintf+0xec>
    800064f8:	01379663          	bne	a5,s3,80006504 <rt_vsnprintf+0x11c>
    800064fc:	02086813          	ori	a6,a6,32
    80006500:	fd5ff06f          	j	800064d4 <rt_vsnprintf+0xec>
    80006504:	00d79663          	bne	a5,a3,80006510 <rt_vsnprintf+0x128>
    80006508:	00186813          	ori	a6,a6,1
    8000650c:	fc9ff06f          	j	800064d4 <rt_vsnprintf+0xec>
    80006510:	fd07871b          	addiw	a4,a5,-48
    80006514:	00900693          	li	a3,9
    80006518:	06e6e263          	bltu	a3,a4,8000657c <rt_vsnprintf+0x194>
    8000651c:	00000713          	li	a4,0
    80006520:	00900693          	li	a3,9
    80006524:	00a00593          	li	a1,10
    80006528:	0140006f          	j	8000653c <rt_vsnprintf+0x154>
    8000652c:	02e5873b          	mulw	a4,a1,a4
    80006530:	001a0a13          	addi	s4,s4,1
    80006534:	00f7073b          	addw	a4,a4,a5
    80006538:	fd07071b          	addiw	a4,a4,-48
    8000653c:	000a4783          	lbu	a5,0(s4)
    80006540:	fd07861b          	addiw	a2,a5,-48
    80006544:	fec6f4e3          	bgeu	a3,a2,8000652c <rt_vsnprintf+0x144>
    80006548:	000a4603          	lbu	a2,0(s4)
    8000654c:	02e00693          	li	a3,46
    80006550:	fff00793          	li	a5,-1
    80006554:	06d61e63          	bne	a2,a3,800065d0 <rt_vsnprintf+0x1e8>
    80006558:	001a4783          	lbu	a5,1(s4)
    8000655c:	00900693          	li	a3,9
    80006560:	001a0613          	addi	a2,s4,1
    80006564:	fd07859b          	addiw	a1,a5,-48
    80006568:	0cb6e663          	bltu	a3,a1,80006634 <rt_vsnprintf+0x24c>
    8000656c:	00000693          	li	a3,0
    80006570:	00900593          	li	a1,9
    80006574:	00a00313          	li	t1,10
    80006578:	03c0006f          	j	800065b4 <rt_vsnprintf+0x1cc>
    8000657c:	02a00693          	li	a3,42
    80006580:	fff00713          	li	a4,-1
    80006584:	fcd792e3          	bne	a5,a3,80006548 <rt_vsnprintf+0x160>
    80006588:	00042703          	lw	a4,0(s0)
    8000658c:	00260a13          	addi	s4,a2,2
    80006590:	00840413          	addi	s0,s0,8
    80006594:	fa075ae3          	bgez	a4,80006548 <rt_vsnprintf+0x160>
    80006598:	40e0073b          	negw	a4,a4
    8000659c:	01086813          	ori	a6,a6,16
    800065a0:	fa9ff06f          	j	80006548 <rt_vsnprintf+0x160>
    800065a4:	02d306bb          	mulw	a3,t1,a3
    800065a8:	00160613          	addi	a2,a2,1
    800065ac:	00f686bb          	addw	a3,a3,a5
    800065b0:	fd06869b          	addiw	a3,a3,-48
    800065b4:	00064783          	lbu	a5,0(a2)
    800065b8:	fd07889b          	addiw	a7,a5,-48
    800065bc:	ff15f4e3          	bgeu	a1,a7,800065a4 <rt_vsnprintf+0x1bc>
    800065c0:	0006879b          	sext.w	a5,a3
    800065c4:	0006d463          	bgez	a3,800065cc <rt_vsnprintf+0x1e4>
    800065c8:	00000793          	li	a5,0
    800065cc:	00060a13          	mv	s4,a2
    800065d0:	000a4583          	lbu	a1,0(s4)
    800065d4:	06800693          	li	a3,104
    800065d8:	0fb5f613          	andi	a2,a1,251
    800065dc:	06d61e63          	bne	a2,a3,80006658 <rt_vsnprintf+0x270>
    800065e0:	001a0a13          	addi	s4,s4,1
    800065e4:	000a4683          	lbu	a3,0(s4)
    800065e8:	07800613          	li	a2,120
    800065ec:	02d66063          	bltu	a2,a3,8000660c <rt_vsnprintf+0x224>
    800065f0:	06200613          	li	a2,98
    800065f4:	06d66663          	bltu	a2,a3,80006660 <rt_vsnprintf+0x278>
    800065f8:	02500613          	li	a2,37
    800065fc:	26c68c63          	beq	a3,a2,80006874 <rt_vsnprintf+0x48c>
    80006600:	05800613          	li	a2,88
    80006604:	04086813          	ori	a6,a6,64
    80006608:	26c68e63          	beq	a3,a2,80006884 <rt_vsnprintf+0x49c>
    8000660c:	01557663          	bgeu	a0,s5,80006618 <rt_vsnprintf+0x230>
    80006610:	02500793          	li	a5,37
    80006614:	00f50023          	sb	a5,0(a0)
    80006618:	000a4703          	lbu	a4,0(s4)
    8000661c:	00150793          	addi	a5,a0,1
    80006620:	2a070663          	beqz	a4,800068cc <rt_vsnprintf+0x4e4>
    80006624:	0157f463          	bgeu	a5,s5,8000662c <rt_vsnprintf+0x244>
    80006628:	00e500a3          	sb	a4,1(a0)
    8000662c:	00250793          	addi	a5,a0,2
    80006630:	e39ff06f          	j	80006468 <rt_vsnprintf+0x80>
    80006634:	02a00693          	li	a3,42
    80006638:	00d79a63          	bne	a5,a3,8000664c <rt_vsnprintf+0x264>
    8000663c:	00042683          	lw	a3,0(s0)
    80006640:	002a0613          	addi	a2,s4,2
    80006644:	00840413          	addi	s0,s0,8
    80006648:	f79ff06f          	j	800065c0 <rt_vsnprintf+0x1d8>
    8000664c:	00060a13          	mv	s4,a2
    80006650:	00000793          	li	a5,0
    80006654:	f7dff06f          	j	800065d0 <rt_vsnprintf+0x1e8>
    80006658:	00000593          	li	a1,0
    8000665c:	f89ff06f          	j	800065e4 <rt_vsnprintf+0x1fc>
    80006660:	f9d6869b          	addiw	a3,a3,-99
    80006664:	0ff6f693          	zext.b	a3,a3
    80006668:	01500613          	li	a2,21
    8000666c:	fad660e3          	bltu	a2,a3,8000660c <rt_vsnprintf+0x224>
    80006670:	0000b617          	auipc	a2,0xb
    80006674:	c7860613          	addi	a2,a2,-904 # 800112e8 <__FUNCTION__.0+0x20>
    80006678:	00269693          	slli	a3,a3,0x2
    8000667c:	00c686b3          	add	a3,a3,a2
    80006680:	0006a683          	lw	a3,0(a3)
    80006684:	00c686b3          	add	a3,a3,a2
    80006688:	00068067          	jr	a3
    8000668c:	01087813          	andi	a6,a6,16
    80006690:	04081863          	bnez	a6,800066e0 <rt_vsnprintf+0x2f8>
    80006694:	00070693          	mv	a3,a4
    80006698:	00050793          	mv	a5,a0
    8000669c:	0100006f          	j	800066ac <rt_vsnprintf+0x2c4>
    800066a0:	0157f463          	bgeu	a5,s5,800066a8 <rt_vsnprintf+0x2c0>
    800066a4:	01878023          	sb	s8,0(a5)
    800066a8:	00178793          	addi	a5,a5,1
    800066ac:	fff6869b          	addiw	a3,a3,-1
    800066b0:	fed048e3          	bgtz	a3,800066a0 <rt_vsnprintf+0x2b8>
    800066b4:	fff7079b          	addiw	a5,a4,-1
    800066b8:	00000693          	li	a3,0
    800066bc:	00e05663          	blez	a4,800066c8 <rt_vsnprintf+0x2e0>
    800066c0:	02079693          	slli	a3,a5,0x20
    800066c4:	0206d693          	srli	a3,a3,0x20
    800066c8:	00d50533          	add	a0,a0,a3
    800066cc:	00070693          	mv	a3,a4
    800066d0:	00e04463          	bgtz	a4,800066d8 <rt_vsnprintf+0x2f0>
    800066d4:	00100693          	li	a3,1
    800066d8:	40d7873b          	subw	a4,a5,a3
    800066dc:	0017071b          	addiw	a4,a4,1
    800066e0:	00840593          	addi	a1,s0,8
    800066e4:	01557663          	bgeu	a0,s5,800066f0 <rt_vsnprintf+0x308>
    800066e8:	00042783          	lw	a5,0(s0)
    800066ec:	00f50023          	sb	a5,0(a0)
    800066f0:	00150793          	addi	a5,a0,1
    800066f4:	00070613          	mv	a2,a4
    800066f8:	00078693          	mv	a3,a5
    800066fc:	fff6061b          	addiw	a2,a2,-1
    80006700:	02c04263          	bgtz	a2,80006724 <rt_vsnprintf+0x33c>
    80006704:	00000513          	li	a0,0
    80006708:	00e05863          	blez	a4,80006718 <rt_vsnprintf+0x330>
    8000670c:	fff7071b          	addiw	a4,a4,-1
    80006710:	02071513          	slli	a0,a4,0x20
    80006714:	02055513          	srli	a0,a0,0x20
    80006718:	00a787b3          	add	a5,a5,a0
    8000671c:	00058413          	mv	s0,a1
    80006720:	d49ff06f          	j	80006468 <rt_vsnprintf+0x80>
    80006724:	0156f463          	bgeu	a3,s5,8000672c <rt_vsnprintf+0x344>
    80006728:	01868023          	sb	s8,0(a3)
    8000672c:	00168693          	addi	a3,a3,1
    80006730:	fcdff06f          	j	800066fc <rt_vsnprintf+0x314>
    80006734:	00043603          	ld	a2,0(s0)
    80006738:	00840893          	addi	a7,s0,8
    8000673c:	00061663          	bnez	a2,80006748 <rt_vsnprintf+0x360>
    80006740:	0000b617          	auipc	a2,0xb
    80006744:	ba060613          	addi	a2,a2,-1120 # 800112e0 <__FUNCTION__.0+0x18>
    80006748:	00000593          	li	a1,0
    8000674c:	0005869b          	sext.w	a3,a1
    80006750:	00d70a63          	beq	a4,a3,80006764 <rt_vsnprintf+0x37c>
    80006754:	00158593          	addi	a1,a1,1
    80006758:	00b60333          	add	t1,a2,a1
    8000675c:	fff34303          	lbu	t1,-1(t1)
    80006760:	fe0316e3          	bnez	t1,8000674c <rt_vsnprintf+0x364>
    80006764:	00f05a63          	blez	a5,80006778 <rt_vsnprintf+0x390>
    80006768:	00068593          	mv	a1,a3
    8000676c:	00d7d463          	bge	a5,a3,80006774 <rt_vsnprintf+0x38c>
    80006770:	00078593          	mv	a1,a5
    80006774:	0005869b          	sext.w	a3,a1
    80006778:	01087813          	andi	a6,a6,16
    8000677c:	04081a63          	bnez	a6,800067d0 <rt_vsnprintf+0x3e8>
    80006780:	00050793          	mv	a5,a0
    80006784:	0007059b          	sext.w	a1,a4
    80006788:	00e5033b          	addw	t1,a0,a4
    8000678c:	0100006f          	j	8000679c <rt_vsnprintf+0x3b4>
    80006790:	0157f463          	bgeu	a5,s5,80006798 <rt_vsnprintf+0x3b0>
    80006794:	01878023          	sb	s8,0(a5)
    80006798:	00178793          	addi	a5,a5,1
    8000679c:	40f3083b          	subw	a6,t1,a5
    800067a0:	ff06c8e3          	blt	a3,a6,80006790 <rt_vsnprintf+0x3a8>
    800067a4:	40d587bb          	subw	a5,a1,a3
    800067a8:	00000593          	li	a1,0
    800067ac:	00d74663          	blt	a4,a3,800067b8 <rt_vsnprintf+0x3d0>
    800067b0:	02079593          	slli	a1,a5,0x20
    800067b4:	0205d593          	srli	a1,a1,0x20
    800067b8:	00b50533          	add	a0,a0,a1
    800067bc:	fff7081b          	addiw	a6,a4,-1
    800067c0:	00000593          	li	a1,0
    800067c4:	00d74463          	blt	a4,a3,800067cc <rt_vsnprintf+0x3e4>
    800067c8:	40f005bb          	negw	a1,a5
    800067cc:	00b8073b          	addw	a4,a6,a1
    800067d0:	00000793          	li	a5,0
    800067d4:	0007859b          	sext.w	a1,a5
    800067d8:	04d5c063          	blt	a1,a3,80006818 <rt_vsnprintf+0x430>
    800067dc:	00d507b3          	add	a5,a0,a3
    800067e0:	0006881b          	sext.w	a6,a3
    800067e4:	00078613          	mv	a2,a5
    800067e8:	0007059b          	sext.w	a1,a4
    800067ec:	00e7833b          	addw	t1,a5,a4
    800067f0:	40c3053b          	subw	a0,t1,a2
    800067f4:	04a6c063          	blt	a3,a0,80006834 <rt_vsnprintf+0x44c>
    800067f8:	00000513          	li	a0,0
    800067fc:	00d74863          	blt	a4,a3,8000680c <rt_vsnprintf+0x424>
    80006800:	410585bb          	subw	a1,a1,a6
    80006804:	02059513          	slli	a0,a1,0x20
    80006808:	02055513          	srli	a0,a0,0x20
    8000680c:	00a787b3          	add	a5,a5,a0
    80006810:	00088413          	mv	s0,a7
    80006814:	c55ff06f          	j	80006468 <rt_vsnprintf+0x80>
    80006818:	00f505b3          	add	a1,a0,a5
    8000681c:	0155f863          	bgeu	a1,s5,8000682c <rt_vsnprintf+0x444>
    80006820:	00f60833          	add	a6,a2,a5
    80006824:	00084803          	lbu	a6,0(a6)
    80006828:	01058023          	sb	a6,0(a1)
    8000682c:	00178793          	addi	a5,a5,1
    80006830:	fa5ff06f          	j	800067d4 <rt_vsnprintf+0x3ec>
    80006834:	01567463          	bgeu	a2,s5,8000683c <rt_vsnprintf+0x454>
    80006838:	01860023          	sb	s8,0(a2)
    8000683c:	00160613          	addi	a2,a2,1
    80006840:	fb1ff06f          	j	800067f0 <rt_vsnprintf+0x408>
    80006844:	fff00693          	li	a3,-1
    80006848:	00d71663          	bne	a4,a3,80006854 <rt_vsnprintf+0x46c>
    8000684c:	00186813          	ori	a6,a6,1
    80006850:	01000713          	li	a4,16
    80006854:	00043603          	ld	a2,0(s0)
    80006858:	01000693          	li	a3,16
    8000685c:	000a8593          	mv	a1,s5
    80006860:	00840c93          	addi	s9,s0,8
    80006864:	d44ff0ef          	jal	ra,80005da8 <print_number>
    80006868:	00050793          	mv	a5,a0
    8000686c:	000c8413          	mv	s0,s9
    80006870:	bf9ff06f          	j	80006468 <rt_vsnprintf+0x80>
    80006874:	01557463          	bgeu	a0,s5,8000687c <rt_vsnprintf+0x494>
    80006878:	00d50023          	sb	a3,0(a0)
    8000687c:	00150793          	addi	a5,a0,1
    80006880:	be9ff06f          	j	80006468 <rt_vsnprintf+0x80>
    80006884:	01000693          	li	a3,16
    80006888:	06800893          	li	a7,104
    8000688c:	00042603          	lw	a2,0(s0)
    80006890:	00840413          	addi	s0,s0,8
    80006894:	01159a63          	bne	a1,a7,800068a8 <rt_vsnprintf+0x4c0>
    80006898:	00287893          	andi	a7,a6,2
    8000689c:	0006059b          	sext.w	a1,a2
    800068a0:	02089e63          	bnez	a7,800068dc <rt_vsnprintf+0x4f4>
    800068a4:	0095f633          	and	a2,a1,s1
    800068a8:	02061613          	slli	a2,a2,0x20
    800068ac:	02065613          	srli	a2,a2,0x20
    800068b0:	000a8593          	mv	a1,s5
    800068b4:	cf4ff0ef          	jal	ra,80005da8 <print_number>
    800068b8:	00050793          	mv	a5,a0
    800068bc:	badff06f          	j	80006468 <rt_vsnprintf+0x80>
    800068c0:	00286813          	ori	a6,a6,2
    800068c4:	00a00693          	li	a3,10
    800068c8:	fc1ff06f          	j	80006888 <rt_vsnprintf+0x4a0>
    800068cc:	fffa0a13          	addi	s4,s4,-1
    800068d0:	b99ff06f          	j	80006468 <rt_vsnprintf+0x80>
    800068d4:	00800693          	li	a3,8
    800068d8:	fb1ff06f          	j	80006888 <rt_vsnprintf+0x4a0>
    800068dc:	0106161b          	slliw	a2,a2,0x10
    800068e0:	4106561b          	sraiw	a2,a2,0x10
    800068e4:	fc5ff06f          	j	800068a8 <rt_vsnprintf+0x4c0>
    800068e8:	fe0a8fa3          	sb	zero,-1(s5)
    800068ec:	b99ff06f          	j	80006484 <rt_vsnprintf+0x9c>

00000000800068f0 <rt_snprintf>:
    800068f0:	fb010113          	addi	sp,sp,-80
    800068f4:	02d13423          	sd	a3,40(sp)
    800068f8:	02810693          	addi	a3,sp,40
    800068fc:	00113c23          	sd	ra,24(sp)
    80006900:	02e13823          	sd	a4,48(sp)
    80006904:	02f13c23          	sd	a5,56(sp)
    80006908:	05013023          	sd	a6,64(sp)
    8000690c:	05113423          	sd	a7,72(sp)
    80006910:	00d13423          	sd	a3,8(sp)
    80006914:	ad5ff0ef          	jal	ra,800063e8 <rt_vsnprintf>
    80006918:	01813083          	ld	ra,24(sp)
    8000691c:	05010113          	addi	sp,sp,80
    80006920:	00008067          	ret

0000000080006924 <rt_vsprintf>:
    80006924:	00060693          	mv	a3,a2
    80006928:	00058613          	mv	a2,a1
    8000692c:	fff00593          	li	a1,-1
    80006930:	ab9ff06f          	j	800063e8 <rt_vsnprintf>

0000000080006934 <rt_sprintf>:
    80006934:	fb010113          	addi	sp,sp,-80
    80006938:	02c13023          	sd	a2,32(sp)
    8000693c:	02010613          	addi	a2,sp,32
    80006940:	00113c23          	sd	ra,24(sp)
    80006944:	02d13423          	sd	a3,40(sp)
    80006948:	02e13823          	sd	a4,48(sp)
    8000694c:	02f13c23          	sd	a5,56(sp)
    80006950:	05013023          	sd	a6,64(sp)
    80006954:	05113423          	sd	a7,72(sp)
    80006958:	00c13423          	sd	a2,8(sp)
    8000695c:	fc9ff0ef          	jal	ra,80006924 <rt_vsprintf>
    80006960:	01813083          	ld	ra,24(sp)
    80006964:	05010113          	addi	sp,sp,80
    80006968:	00008067          	ret

000000008000696c <rt_console_get_device>:
    8000696c:	00017517          	auipc	a0,0x17
    80006970:	00453503          	ld	a0,4(a0) # 8001d970 <_console_device>
    80006974:	00008067          	ret

0000000080006978 <rt_console_set_device>:
    80006978:	fe010113          	addi	sp,sp,-32
    8000697c:	01213023          	sd	s2,0(sp)
    80006980:	00017917          	auipc	s2,0x17
    80006984:	ff090913          	addi	s2,s2,-16 # 8001d970 <_console_device>
    80006988:	00913423          	sd	s1,8(sp)
    8000698c:	00093483          	ld	s1,0(s2)
    80006990:	00113c23          	sd	ra,24(sp)
    80006994:	00813823          	sd	s0,16(sp)
    80006998:	ce5fe0ef          	jal	ra,8000567c <rt_device_find>
    8000699c:	04a48263          	beq	s1,a0,800069e0 <rt_console_set_device+0x68>
    800069a0:	00050413          	mv	s0,a0
    800069a4:	02050063          	beqz	a0,800069c4 <rt_console_set_device+0x4c>
    800069a8:	00093503          	ld	a0,0(s2)
    800069ac:	00050463          	beqz	a0,800069b4 <rt_console_set_device+0x3c>
    800069b0:	ea5fe0ef          	jal	ra,80005854 <rt_device_close>
    800069b4:	04300593          	li	a1,67
    800069b8:	00040513          	mv	a0,s0
    800069bc:	d41fe0ef          	jal	ra,800056fc <rt_device_open>
    800069c0:	00893023          	sd	s0,0(s2)
    800069c4:	01813083          	ld	ra,24(sp)
    800069c8:	01013403          	ld	s0,16(sp)
    800069cc:	00013903          	ld	s2,0(sp)
    800069d0:	00048513          	mv	a0,s1
    800069d4:	00813483          	ld	s1,8(sp)
    800069d8:	02010113          	addi	sp,sp,32
    800069dc:	00008067          	ret
    800069e0:	00000493          	li	s1,0
    800069e4:	fe1ff06f          	j	800069c4 <rt_console_set_device+0x4c>

00000000800069e8 <rt_hw_console_output>:
    800069e8:	00008067          	ret

00000000800069ec <rt_kprintf>:
    800069ec:	f9010113          	addi	sp,sp,-112
    800069f0:	02b13c23          	sd	a1,56(sp)
    800069f4:	04c13023          	sd	a2,64(sp)
    800069f8:	04d13423          	sd	a3,72(sp)
    800069fc:	00050613          	mv	a2,a0
    80006a00:	03810693          	addi	a3,sp,56
    80006a04:	0ff00593          	li	a1,255
    80006a08:	0001f517          	auipc	a0,0x1f
    80006a0c:	53050513          	addi	a0,a0,1328 # 80025f38 <rt_log_buf.0>
    80006a10:	00913c23          	sd	s1,24(sp)
    80006a14:	00d13423          	sd	a3,8(sp)
    80006a18:	02113423          	sd	ra,40(sp)
    80006a1c:	02813023          	sd	s0,32(sp)
    80006a20:	04e13823          	sd	a4,80(sp)
    80006a24:	04f13c23          	sd	a5,88(sp)
    80006a28:	07013023          	sd	a6,96(sp)
    80006a2c:	07113423          	sd	a7,104(sp)
    80006a30:	00017497          	auipc	s1,0x17
    80006a34:	f4048493          	addi	s1,s1,-192 # 8001d970 <_console_device>
    80006a38:	9b1ff0ef          	jal	ra,800063e8 <rt_vsnprintf>
    80006a3c:	00050693          	mv	a3,a0
    80006a40:	0004b503          	ld	a0,0(s1)
    80006a44:	02051263          	bnez	a0,80006a68 <rt_kprintf+0x7c>
    80006a48:	0001f517          	auipc	a0,0x1f
    80006a4c:	4f050513          	addi	a0,a0,1264 # 80025f38 <rt_log_buf.0>
    80006a50:	f99ff0ef          	jal	ra,800069e8 <rt_hw_console_output>
    80006a54:	02813083          	ld	ra,40(sp)
    80006a58:	02013403          	ld	s0,32(sp)
    80006a5c:	01813483          	ld	s1,24(sp)
    80006a60:	07010113          	addi	sp,sp,112
    80006a64:	00008067          	ret
    80006a68:	02e55403          	lhu	s0,46(a0)
    80006a6c:	04046793          	ori	a5,s0,64
    80006a70:	02f51723          	sh	a5,46(a0)
    80006a74:	0ff00793          	li	a5,255
    80006a78:	00d7f463          	bgeu	a5,a3,80006a80 <rt_kprintf+0x94>
    80006a7c:	0ff00693          	li	a3,255
    80006a80:	0001f617          	auipc	a2,0x1f
    80006a84:	4b860613          	addi	a2,a2,1208 # 80025f38 <rt_log_buf.0>
    80006a88:	00000593          	li	a1,0
    80006a8c:	f49fe0ef          	jal	ra,800059d4 <rt_device_write>
    80006a90:	0004b783          	ld	a5,0(s1)
    80006a94:	02879723          	sh	s0,46(a5)
    80006a98:	fbdff06f          	j	80006a54 <rt_kprintf+0x68>

0000000080006a9c <rt_show_version>:
    80006a9c:	ff010113          	addi	sp,sp,-16
    80006aa0:	0000b517          	auipc	a0,0xb
    80006aa4:	8a050513          	addi	a0,a0,-1888 # 80011340 <__FUNCTION__.0+0x78>
    80006aa8:	00113423          	sd	ra,8(sp)
    80006aac:	f41ff0ef          	jal	ra,800069ec <rt_kprintf>
    80006ab0:	0000b517          	auipc	a0,0xb
    80006ab4:	8a050513          	addi	a0,a0,-1888 # 80011350 <__FUNCTION__.0+0x88>
    80006ab8:	f35ff0ef          	jal	ra,800069ec <rt_kprintf>
    80006abc:	0000b517          	auipc	a0,0xb
    80006ac0:	8cc50513          	addi	a0,a0,-1844 # 80011388 <__FUNCTION__.0+0xc0>
    80006ac4:	0000b717          	auipc	a4,0xb
    80006ac8:	8b470713          	addi	a4,a4,-1868 # 80011378 <__FUNCTION__.0+0xb0>
    80006acc:	00400693          	li	a3,4
    80006ad0:	00000613          	li	a2,0
    80006ad4:	00400593          	li	a1,4
    80006ad8:	f15ff0ef          	jal	ra,800069ec <rt_kprintf>
    80006adc:	00813083          	ld	ra,8(sp)
    80006ae0:	0000b517          	auipc	a0,0xb
    80006ae4:	8c850513          	addi	a0,a0,-1848 # 800113a8 <__FUNCTION__.0+0xe0>
    80006ae8:	01010113          	addi	sp,sp,16
    80006aec:	f01ff06f          	j	800069ec <rt_kprintf>

0000000080006af0 <__rt_ffs>:
    80006af0:	08050063          	beqz	a0,80006b70 <__rt_ffs+0x80>
    80006af4:	0ff57713          	zext.b	a4,a0
    80006af8:	0000b797          	auipc	a5,0xb
    80006afc:	91878793          	addi	a5,a5,-1768 # 80011410 <__lowest_bit_bitmap>
    80006b00:	00070a63          	beqz	a4,80006b14 <__rt_ffs+0x24>
    80006b04:	00e787b3          	add	a5,a5,a4
    80006b08:	0007c503          	lbu	a0,0(a5)
    80006b0c:	0015051b          	addiw	a0,a0,1
    80006b10:	00008067          	ret
    80006b14:	00010737          	lui	a4,0x10
    80006b18:	f0070713          	addi	a4,a4,-256 # ff00 <__STACKSIZE__+0xbf00>
    80006b1c:	00e57733          	and	a4,a0,a4
    80006b20:	00070e63          	beqz	a4,80006b3c <__rt_ffs+0x4c>
    80006b24:	4085551b          	sraiw	a0,a0,0x8
    80006b28:	0ff57513          	zext.b	a0,a0
    80006b2c:	00a78533          	add	a0,a5,a0
    80006b30:	00054503          	lbu	a0,0(a0)
    80006b34:	0095051b          	addiw	a0,a0,9
    80006b38:	00008067          	ret
    80006b3c:	00ff0737          	lui	a4,0xff0
    80006b40:	00e57733          	and	a4,a0,a4
    80006b44:	00070e63          	beqz	a4,80006b60 <__rt_ffs+0x70>
    80006b48:	4105551b          	sraiw	a0,a0,0x10
    80006b4c:	0ff57513          	zext.b	a0,a0
    80006b50:	00a78533          	add	a0,a5,a0
    80006b54:	00054503          	lbu	a0,0(a0)
    80006b58:	0115051b          	addiw	a0,a0,17
    80006b5c:	00008067          	ret
    80006b60:	0185551b          	srliw	a0,a0,0x18
    80006b64:	00a78533          	add	a0,a5,a0
    80006b68:	00054503          	lbu	a0,0(a0)
    80006b6c:	0195051b          	addiw	a0,a0,25
    80006b70:	00008067          	ret

0000000080006b74 <rt_assert_handler>:
    80006b74:	fe010113          	addi	sp,sp,-32
    80006b78:	00113c23          	sd	ra,24(sp)
    80006b7c:	000107a3          	sb	zero,15(sp)
    80006b80:	00017817          	auipc	a6,0x17
    80006b84:	df883803          	ld	a6,-520(a6) # 8001d978 <rt_assert_hook>
    80006b88:	02081a63          	bnez	a6,80006bbc <rt_assert_handler+0x48>
    80006b8c:	00060693          	mv	a3,a2
    80006b90:	00058613          	mv	a2,a1
    80006b94:	00050593          	mv	a1,a0
    80006b98:	0000b517          	auipc	a0,0xb
    80006b9c:	84050513          	addi	a0,a0,-1984 # 800113d8 <__FUNCTION__.0+0x110>
    80006ba0:	e4dff0ef          	jal	ra,800069ec <rt_kprintf>
    80006ba4:	00f14783          	lbu	a5,15(sp)
    80006ba8:	0ff7f793          	zext.b	a5,a5
    80006bac:	fe078ce3          	beqz	a5,80006ba4 <rt_assert_handler+0x30>
    80006bb0:	01813083          	ld	ra,24(sp)
    80006bb4:	02010113          	addi	sp,sp,32
    80006bb8:	00008067          	ret
    80006bbc:	01813083          	ld	ra,24(sp)
    80006bc0:	02010113          	addi	sp,sp,32
    80006bc4:	00080067          	jr	a6

0000000080006bc8 <rt_tick_get>:
    80006bc8:	00017517          	auipc	a0,0x17
    80006bcc:	db852503          	lw	a0,-584(a0) # 8001d980 <rt_tick>
    80006bd0:	00008067          	ret

0000000080006bd4 <rt_tick_increase>:
    80006bd4:	ff010113          	addi	sp,sp,-16
    80006bd8:	00113423          	sd	ra,8(sp)
    80006bdc:	00813023          	sd	s0,0(sp)
    80006be0:	c70f90ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80006be4:	00017797          	auipc	a5,0x17
    80006be8:	d9c7a783          	lw	a5,-612(a5) # 8001d980 <rt_tick>
    80006bec:	0017879b          	addiw	a5,a5,1
    80006bf0:	00017717          	auipc	a4,0x17
    80006bf4:	d8f72823          	sw	a5,-624(a4) # 8001d980 <rt_tick>
    80006bf8:	00050413          	mv	s0,a0
    80006bfc:	404000ef          	jal	ra,80007000 <rt_thread_self>
    80006c00:	08053783          	ld	a5,128(a0)
    80006c04:	fff78793          	addi	a5,a5,-1
    80006c08:	08f53023          	sd	a5,128(a0)
    80006c0c:	02079a63          	bnez	a5,80006c40 <rt_tick_increase+0x6c>
    80006c10:	07853783          	ld	a5,120(a0)
    80006c14:	08f53023          	sd	a5,128(a0)
    80006c18:	06854783          	lbu	a5,104(a0)
    80006c1c:	0087e793          	ori	a5,a5,8
    80006c20:	06f50423          	sb	a5,104(a0)
    80006c24:	00040513          	mv	a0,s0
    80006c28:	c30f90ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80006c2c:	b2dfd0ef          	jal	ra,80004758 <rt_schedule>
    80006c30:	00013403          	ld	s0,0(sp)
    80006c34:	00813083          	ld	ra,8(sp)
    80006c38:	01010113          	addi	sp,sp,16
    80006c3c:	d6cfd06f          	j	800041a8 <rt_timer_check>
    80006c40:	00040513          	mv	a0,s0
    80006c44:	c14f90ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80006c48:	fe9ff06f          	j	80006c30 <rt_tick_increase+0x5c>

0000000080006c4c <rt_tick_from_millisecond>:
    80006c4c:	02054663          	bltz	a0,80006c78 <rt_tick_from_millisecond+0x2c>
    80006c50:	3e800713          	li	a4,1000
    80006c54:	02e547bb          	divw	a5,a0,a4
    80006c58:	06400693          	li	a3,100
    80006c5c:	02e5653b          	remw	a0,a0,a4
    80006c60:	02d5053b          	mulw	a0,a0,a3
    80006c64:	3e75051b          	addiw	a0,a0,999
    80006c68:	02e5453b          	divw	a0,a0,a4
    80006c6c:	02d787bb          	mulw	a5,a5,a3
    80006c70:	00f5053b          	addw	a0,a0,a5
    80006c74:	00008067          	ret
    80006c78:	fff00513          	li	a0,-1
    80006c7c:	00008067          	ret

0000000080006c80 <_rt_thread_cleanup_execute>:
    80006c80:	fe010113          	addi	sp,sp,-32
    80006c84:	00813823          	sd	s0,16(sp)
    80006c88:	00913423          	sd	s1,8(sp)
    80006c8c:	00050413          	mv	s0,a0
    80006c90:	00113c23          	sd	ra,24(sp)
    80006c94:	bbcf90ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80006c98:	0d843783          	ld	a5,216(s0)
    80006c9c:	00050493          	mv	s1,a0
    80006ca0:	00078663          	beqz	a5,80006cac <_rt_thread_cleanup_execute+0x2c>
    80006ca4:	00040513          	mv	a0,s0
    80006ca8:	000780e7          	jalr	a5
    80006cac:	01013403          	ld	s0,16(sp)
    80006cb0:	01813083          	ld	ra,24(sp)
    80006cb4:	00048513          	mv	a0,s1
    80006cb8:	00813483          	ld	s1,8(sp)
    80006cbc:	02010113          	addi	sp,sp,32
    80006cc0:	b98f906f          	j	80000058 <rt_hw_interrupt_enable>

0000000080006cc4 <_rt_thread_exit>:
    80006cc4:	fe010113          	addi	sp,sp,-32
    80006cc8:	00113c23          	sd	ra,24(sp)
    80006ccc:	00813823          	sd	s0,16(sp)
    80006cd0:	00913423          	sd	s1,8(sp)
    80006cd4:	00017417          	auipc	s0,0x17
    80006cd8:	c2c43403          	ld	s0,-980(s0) # 8001d900 <rt_current_thread>
    80006cdc:	b74f90ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80006ce0:	00050493          	mv	s1,a0
    80006ce4:	00040513          	mv	a0,s0
    80006ce8:	f99ff0ef          	jal	ra,80006c80 <_rt_thread_cleanup_execute>
    80006cec:	00040513          	mv	a0,s0
    80006cf0:	979fd0ef          	jal	ra,80004668 <rt_schedule_remove_thread>
    80006cf4:	00400793          	li	a5,4
    80006cf8:	06f40423          	sb	a5,104(s0)
    80006cfc:	08840513          	addi	a0,s0,136
    80006d00:	8a8fd0ef          	jal	ra,80003da8 <rt_timer_detach>
    80006d04:	00040513          	mv	a0,s0
    80006d08:	759000ef          	jal	ra,80007c60 <rt_object_is_systemobject>
    80006d0c:	00100793          	li	a5,1
    80006d10:	02f51463          	bne	a0,a5,80006d38 <_rt_thread_exit+0x74>
    80006d14:	00040513          	mv	a0,s0
    80006d18:	521000ef          	jal	ra,80007a38 <rt_object_detach>
    80006d1c:	a3dfd0ef          	jal	ra,80004758 <rt_schedule>
    80006d20:	01013403          	ld	s0,16(sp)
    80006d24:	01813083          	ld	ra,24(sp)
    80006d28:	00048513          	mv	a0,s1
    80006d2c:	00813483          	ld	s1,8(sp)
    80006d30:	02010113          	addi	sp,sp,32
    80006d34:	b24f906f          	j	80000058 <rt_hw_interrupt_enable>
    80006d38:	00040513          	mv	a0,s0
    80006d3c:	e91fe0ef          	jal	ra,80005bcc <rt_thread_defunct_enqueue>
    80006d40:	fddff06f          	j	80006d1c <_rt_thread_exit+0x58>

0000000080006d44 <_rt_thread_init.constprop.0>:
    80006d44:	fe010113          	addi	sp,sp,-32
    80006d48:	00813823          	sd	s0,16(sp)
    80006d4c:	00050413          	mv	s0,a0
    80006d50:	00913423          	sd	s1,8(sp)
    80006d54:	04c43423          	sd	a2,72(s0)
    80006d58:	00078493          	mv	s1,a5
    80006d5c:	02071613          	slli	a2,a4,0x20
    80006d60:	02840793          	addi	a5,s0,40
    80006d64:	00068513          	mv	a0,a3
    80006d68:	02f43823          	sd	a5,48(s0)
    80006d6c:	02f43423          	sd	a5,40(s0)
    80006d70:	04b43023          	sd	a1,64(s0)
    80006d74:	04d43823          	sd	a3,80(s0)
    80006d78:	04e42c23          	sw	a4,88(s0)
    80006d7c:	02065613          	srli	a2,a2,0x20
    80006d80:	02300593          	li	a1,35
    80006d84:	00113c23          	sd	ra,24(sp)
    80006d88:	01213023          	sd	s2,0(sp)
    80006d8c:	00080913          	mv	s2,a6
    80006d90:	a80ff0ef          	jal	ra,80006010 <rt_memset>
    80006d94:	05846783          	lwu	a5,88(s0)
    80006d98:	05043603          	ld	a2,80(s0)
    80006d9c:	04843583          	ld	a1,72(s0)
    80006da0:	04043503          	ld	a0,64(s0)
    80006da4:	ff878793          	addi	a5,a5,-8
    80006da8:	00f60633          	add	a2,a2,a5
    80006dac:	00000697          	auipc	a3,0x0
    80006db0:	f1868693          	addi	a3,a3,-232 # 80006cc4 <_rt_thread_exit>
    80006db4:	0d5010ef          	jal	ra,80008688 <rt_hw_stack_init>
    80006db8:	02a43c23          	sd	a0,56(s0)
    80006dbc:	01f00793          	li	a5,31
    80006dc0:	0097fe63          	bgeu	a5,s1,80006ddc <_rt_thread_init.constprop.0+0x98>
    80006dc4:	0ae00613          	li	a2,174
    80006dc8:	0000b597          	auipc	a1,0xb
    80006dcc:	9d058593          	addi	a1,a1,-1584 # 80011798 <__FUNCTION__.9>
    80006dd0:	0000a517          	auipc	a0,0xa
    80006dd4:	77050513          	addi	a0,a0,1904 # 80011540 <small_digits.1+0x18>
    80006dd8:	d9dff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80006ddc:	02091813          	slli	a6,s2,0x20
    80006de0:	02085813          	srli	a6,a6,0x20
    80006de4:	00000793          	li	a5,0
    80006de8:	06940523          	sb	s1,106(s0)
    80006dec:	069404a3          	sb	s1,105(s0)
    80006df0:	06042623          	sw	zero,108(s0)
    80006df4:	07043c23          	sd	a6,120(s0)
    80006df8:	09043023          	sd	a6,128(s0)
    80006dfc:	06043023          	sd	zero,96(s0)
    80006e00:	06040423          	sb	zero,104(s0)
    80006e04:	0c043c23          	sd	zero,216(s0)
    80006e08:	0e043023          	sd	zero,224(s0)
    80006e0c:	00000713          	li	a4,0
    80006e10:	00040693          	mv	a3,s0
    80006e14:	00000617          	auipc	a2,0x0
    80006e18:	04460613          	addi	a2,a2,68 # 80006e58 <rt_thread_timeout>
    80006e1c:	00040593          	mv	a1,s0
    80006e20:	08840513          	addi	a0,s0,136
    80006e24:	ed9fc0ef          	jal	ra,80003cfc <rt_timer_init>
    80006e28:	00017797          	auipc	a5,0x17
    80006e2c:	b607b783          	ld	a5,-1184(a5) # 8001d988 <rt_thread_inited_hook>
    80006e30:	00078663          	beqz	a5,80006e3c <_rt_thread_init.constprop.0+0xf8>
    80006e34:	00040513          	mv	a0,s0
    80006e38:	000780e7          	jalr	a5
    80006e3c:	01813083          	ld	ra,24(sp)
    80006e40:	01013403          	ld	s0,16(sp)
    80006e44:	00813483          	ld	s1,8(sp)
    80006e48:	00013903          	ld	s2,0(sp)
    80006e4c:	00000513          	li	a0,0
    80006e50:	02010113          	addi	sp,sp,32
    80006e54:	00008067          	ret

0000000080006e58 <rt_thread_timeout>:
    80006e58:	fe010113          	addi	sp,sp,-32
    80006e5c:	00813823          	sd	s0,16(sp)
    80006e60:	00113c23          	sd	ra,24(sp)
    80006e64:	00913423          	sd	s1,8(sp)
    80006e68:	00050413          	mv	s0,a0
    80006e6c:	00051e63          	bnez	a0,80006e88 <rt_thread_timeout+0x30>
    80006e70:	37200613          	li	a2,882
    80006e74:	0000b597          	auipc	a1,0xb
    80006e78:	85c58593          	addi	a1,a1,-1956 # 800116d0 <__FUNCTION__.0>
    80006e7c:	0000a517          	auipc	a0,0xa
    80006e80:	d9c50513          	addi	a0,a0,-612 # 80010c18 <__FUNCTION__.6+0x10>
    80006e84:	cf1ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80006e88:	06844783          	lbu	a5,104(s0)
    80006e8c:	00200713          	li	a4,2
    80006e90:	0077f793          	andi	a5,a5,7
    80006e94:	00e78e63          	beq	a5,a4,80006eb0 <rt_thread_timeout+0x58>
    80006e98:	37300613          	li	a2,883
    80006e9c:	0000b597          	auipc	a1,0xb
    80006ea0:	83458593          	addi	a1,a1,-1996 # 800116d0 <__FUNCTION__.0>
    80006ea4:	0000a517          	auipc	a0,0xa
    80006ea8:	6c450513          	addi	a0,a0,1732 # 80011568 <small_digits.1+0x40>
    80006eac:	cc9ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80006eb0:	00040513          	mv	a0,s0
    80006eb4:	5f1000ef          	jal	ra,80007ca4 <rt_object_get_type>
    80006eb8:	00100793          	li	a5,1
    80006ebc:	00f50e63          	beq	a0,a5,80006ed8 <rt_thread_timeout+0x80>
    80006ec0:	37400613          	li	a2,884
    80006ec4:	0000b597          	auipc	a1,0xb
    80006ec8:	80c58593          	addi	a1,a1,-2036 # 800116d0 <__FUNCTION__.0>
    80006ecc:	0000a517          	auipc	a0,0xa
    80006ed0:	6dc50513          	addi	a0,a0,1756 # 800115a8 <small_digits.1+0x80>
    80006ed4:	ca1ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80006ed8:	978f90ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80006edc:	02843683          	ld	a3,40(s0)
    80006ee0:	03043703          	ld	a4,48(s0)
    80006ee4:	ffe00793          	li	a5,-2
    80006ee8:	06f43023          	sd	a5,96(s0)
    80006eec:	00e6b423          	sd	a4,8(a3)
    80006ef0:	02840793          	addi	a5,s0,40
    80006ef4:	00d73023          	sd	a3,0(a4)
    80006ef8:	00050493          	mv	s1,a0
    80006efc:	02f43823          	sd	a5,48(s0)
    80006f00:	02f43423          	sd	a5,40(s0)
    80006f04:	00040513          	mv	a0,s0
    80006f08:	eb4fd0ef          	jal	ra,800045bc <rt_schedule_insert_thread>
    80006f0c:	00048513          	mv	a0,s1
    80006f10:	948f90ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80006f14:	01013403          	ld	s0,16(sp)
    80006f18:	01813083          	ld	ra,24(sp)
    80006f1c:	00813483          	ld	s1,8(sp)
    80006f20:	02010113          	addi	sp,sp,32
    80006f24:	835fd06f          	j	80004758 <rt_schedule>

0000000080006f28 <rt_thread_init>:
    80006f28:	fb010113          	addi	sp,sp,-80
    80006f2c:	04813023          	sd	s0,64(sp)
    80006f30:	02913c23          	sd	s1,56(sp)
    80006f34:	03213823          	sd	s2,48(sp)
    80006f38:	03313423          	sd	s3,40(sp)
    80006f3c:	03413023          	sd	s4,32(sp)
    80006f40:	01513c23          	sd	s5,24(sp)
    80006f44:	01613823          	sd	s6,16(sp)
    80006f48:	01713423          	sd	s7,8(sp)
    80006f4c:	04113423          	sd	ra,72(sp)
    80006f50:	00050413          	mv	s0,a0
    80006f54:	00058b93          	mv	s7,a1
    80006f58:	00060913          	mv	s2,a2
    80006f5c:	00068993          	mv	s3,a3
    80006f60:	00070493          	mv	s1,a4
    80006f64:	00078a13          	mv	s4,a5
    80006f68:	00080a93          	mv	s5,a6
    80006f6c:	00088b13          	mv	s6,a7
    80006f70:	00051e63          	bnez	a0,80006f8c <rt_thread_init+0x64>
    80006f74:	10f00613          	li	a2,271
    80006f78:	0000a597          	auipc	a1,0xa
    80006f7c:	78858593          	addi	a1,a1,1928 # 80011700 <__FUNCTION__.10>
    80006f80:	0000a517          	auipc	a0,0xa
    80006f84:	c9850513          	addi	a0,a0,-872 # 80010c18 <__FUNCTION__.6+0x10>
    80006f88:	bedff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80006f8c:	00049e63          	bnez	s1,80006fa8 <rt_thread_init+0x80>
    80006f90:	11000613          	li	a2,272
    80006f94:	0000a597          	auipc	a1,0xa
    80006f98:	76c58593          	addi	a1,a1,1900 # 80011700 <__FUNCTION__.10>
    80006f9c:	0000a517          	auipc	a0,0xa
    80006fa0:	65450513          	addi	a0,a0,1620 # 800115f0 <small_digits.1+0xc8>
    80006fa4:	bd1ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80006fa8:	000b8613          	mv	a2,s7
    80006fac:	00040513          	mv	a0,s0
    80006fb0:	00100593          	li	a1,1
    80006fb4:	171000ef          	jal	ra,80007924 <rt_object_init>
    80006fb8:	00040513          	mv	a0,s0
    80006fbc:	04013403          	ld	s0,64(sp)
    80006fc0:	04813083          	ld	ra,72(sp)
    80006fc4:	00813b83          	ld	s7,8(sp)
    80006fc8:	000b0813          	mv	a6,s6
    80006fcc:	000a8793          	mv	a5,s5
    80006fd0:	01013b03          	ld	s6,16(sp)
    80006fd4:	01813a83          	ld	s5,24(sp)
    80006fd8:	000a0713          	mv	a4,s4
    80006fdc:	00048693          	mv	a3,s1
    80006fe0:	02013a03          	ld	s4,32(sp)
    80006fe4:	03813483          	ld	s1,56(sp)
    80006fe8:	00098613          	mv	a2,s3
    80006fec:	00090593          	mv	a1,s2
    80006ff0:	02813983          	ld	s3,40(sp)
    80006ff4:	03013903          	ld	s2,48(sp)
    80006ff8:	05010113          	addi	sp,sp,80
    80006ffc:	d49ff06f          	j	80006d44 <_rt_thread_init.constprop.0>

0000000080007000 <rt_thread_self>:
    80007000:	00017517          	auipc	a0,0x17
    80007004:	90053503          	ld	a0,-1792(a0) # 8001d900 <rt_current_thread>
    80007008:	00008067          	ret

000000008000700c <rt_thread_detach>:
    8000700c:	fe010113          	addi	sp,sp,-32
    80007010:	00813823          	sd	s0,16(sp)
    80007014:	00113c23          	sd	ra,24(sp)
    80007018:	00913423          	sd	s1,8(sp)
    8000701c:	00050413          	mv	s0,a0
    80007020:	00051e63          	bnez	a0,8000703c <rt_thread_detach+0x30>
    80007024:	16e00613          	li	a2,366
    80007028:	0000a597          	auipc	a1,0xa
    8000702c:	74058593          	addi	a1,a1,1856 # 80011768 <__FUNCTION__.7>
    80007030:	0000a517          	auipc	a0,0xa
    80007034:	be850513          	addi	a0,a0,-1048 # 80010c18 <__FUNCTION__.6+0x10>
    80007038:	b3dff0ef          	jal	ra,80006b74 <rt_assert_handler>
    8000703c:	00040513          	mv	a0,s0
    80007040:	465000ef          	jal	ra,80007ca4 <rt_object_get_type>
    80007044:	00100793          	li	a5,1
    80007048:	00f50e63          	beq	a0,a5,80007064 <rt_thread_detach+0x58>
    8000704c:	16f00613          	li	a2,367
    80007050:	0000a597          	auipc	a1,0xa
    80007054:	71858593          	addi	a1,a1,1816 # 80011768 <__FUNCTION__.7>
    80007058:	0000a517          	auipc	a0,0xa
    8000705c:	55050513          	addi	a0,a0,1360 # 800115a8 <small_digits.1+0x80>
    80007060:	b15ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007064:	00040513          	mv	a0,s0
    80007068:	3f9000ef          	jal	ra,80007c60 <rt_object_is_systemobject>
    8000706c:	00051e63          	bnez	a0,80007088 <rt_thread_detach+0x7c>
    80007070:	17000613          	li	a2,368
    80007074:	0000a597          	auipc	a1,0xa
    80007078:	6f458593          	addi	a1,a1,1780 # 80011768 <__FUNCTION__.7>
    8000707c:	0000a517          	auipc	a0,0xa
    80007080:	58c50513          	addi	a0,a0,1420 # 80011608 <small_digits.1+0xe0>
    80007084:	af1ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007088:	06844783          	lbu	a5,104(s0)
    8000708c:	00400713          	li	a4,4
    80007090:	0077f793          	andi	a5,a5,7
    80007094:	04e78063          	beq	a5,a4,800070d4 <rt_thread_detach+0xc8>
    80007098:	00078663          	beqz	a5,800070a4 <rt_thread_detach+0x98>
    8000709c:	00040513          	mv	a0,s0
    800070a0:	dc8fd0ef          	jal	ra,80004668 <rt_schedule_remove_thread>
    800070a4:	00040513          	mv	a0,s0
    800070a8:	bd9ff0ef          	jal	ra,80006c80 <_rt_thread_cleanup_execute>
    800070ac:	08840513          	addi	a0,s0,136
    800070b0:	cf9fc0ef          	jal	ra,80003da8 <rt_timer_detach>
    800070b4:	00400793          	li	a5,4
    800070b8:	06f40423          	sb	a5,104(s0)
    800070bc:	00040513          	mv	a0,s0
    800070c0:	3a1000ef          	jal	ra,80007c60 <rt_object_is_systemobject>
    800070c4:	00100793          	li	a5,1
    800070c8:	02f51263          	bne	a0,a5,800070ec <rt_thread_detach+0xe0>
    800070cc:	00040513          	mv	a0,s0
    800070d0:	169000ef          	jal	ra,80007a38 <rt_object_detach>
    800070d4:	01813083          	ld	ra,24(sp)
    800070d8:	01013403          	ld	s0,16(sp)
    800070dc:	00813483          	ld	s1,8(sp)
    800070e0:	00000513          	li	a0,0
    800070e4:	02010113          	addi	sp,sp,32
    800070e8:	00008067          	ret
    800070ec:	f65f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    800070f0:	00050493          	mv	s1,a0
    800070f4:	00040513          	mv	a0,s0
    800070f8:	ad5fe0ef          	jal	ra,80005bcc <rt_thread_defunct_enqueue>
    800070fc:	00048513          	mv	a0,s1
    80007100:	f59f80ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80007104:	fd1ff06f          	j	800070d4 <rt_thread_detach+0xc8>

0000000080007108 <rt_thread_create>:
    80007108:	fc010113          	addi	sp,sp,-64
    8000710c:	03213023          	sd	s2,32(sp)
    80007110:	00058913          	mv	s2,a1
    80007114:	00050593          	mv	a1,a0
    80007118:	00100513          	li	a0,1
    8000711c:	02813823          	sd	s0,48(sp)
    80007120:	02913423          	sd	s1,40(sp)
    80007124:	01313c23          	sd	s3,24(sp)
    80007128:	01413823          	sd	s4,16(sp)
    8000712c:	01513423          	sd	s5,8(sp)
    80007130:	02113c23          	sd	ra,56(sp)
    80007134:	00060993          	mv	s3,a2
    80007138:	00068493          	mv	s1,a3
    8000713c:	00070a13          	mv	s4,a4
    80007140:	00078a93          	mv	s5,a5
    80007144:	169000ef          	jal	ra,80007aac <rt_object_allocate>
    80007148:	00050413          	mv	s0,a0
    8000714c:	02050263          	beqz	a0,80007170 <rt_thread_create+0x68>
    80007150:	02049513          	slli	a0,s1,0x20
    80007154:	02055513          	srli	a0,a0,0x20
    80007158:	dcdfd0ef          	jal	ra,80004f24 <rt_malloc>
    8000715c:	00050693          	mv	a3,a0
    80007160:	02051c63          	bnez	a0,80007198 <rt_thread_create+0x90>
    80007164:	00040513          	mv	a0,s0
    80007168:	25d000ef          	jal	ra,80007bc4 <rt_object_delete>
    8000716c:	00000413          	li	s0,0
    80007170:	03813083          	ld	ra,56(sp)
    80007174:	00040513          	mv	a0,s0
    80007178:	03013403          	ld	s0,48(sp)
    8000717c:	02813483          	ld	s1,40(sp)
    80007180:	02013903          	ld	s2,32(sp)
    80007184:	01813983          	ld	s3,24(sp)
    80007188:	01013a03          	ld	s4,16(sp)
    8000718c:	00813a83          	ld	s5,8(sp)
    80007190:	04010113          	addi	sp,sp,64
    80007194:	00008067          	ret
    80007198:	000a8813          	mv	a6,s5
    8000719c:	000a0793          	mv	a5,s4
    800071a0:	00048713          	mv	a4,s1
    800071a4:	00098613          	mv	a2,s3
    800071a8:	00090593          	mv	a1,s2
    800071ac:	00040513          	mv	a0,s0
    800071b0:	b95ff0ef          	jal	ra,80006d44 <_rt_thread_init.constprop.0>
    800071b4:	fbdff06f          	j	80007170 <rt_thread_create+0x68>

00000000800071b8 <rt_thread_delete>:
    800071b8:	fe010113          	addi	sp,sp,-32
    800071bc:	00813823          	sd	s0,16(sp)
    800071c0:	00113c23          	sd	ra,24(sp)
    800071c4:	00913423          	sd	s1,8(sp)
    800071c8:	00050413          	mv	s0,a0
    800071cc:	00051e63          	bnez	a0,800071e8 <rt_thread_delete+0x30>
    800071d0:	1d500613          	li	a2,469
    800071d4:	0000a597          	auipc	a1,0xa
    800071d8:	57c58593          	addi	a1,a1,1404 # 80011750 <__FUNCTION__.6>
    800071dc:	0000a517          	auipc	a0,0xa
    800071e0:	a3c50513          	addi	a0,a0,-1476 # 80010c18 <__FUNCTION__.6+0x10>
    800071e4:	991ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    800071e8:	00040513          	mv	a0,s0
    800071ec:	2b9000ef          	jal	ra,80007ca4 <rt_object_get_type>
    800071f0:	00100793          	li	a5,1
    800071f4:	00f50e63          	beq	a0,a5,80007210 <rt_thread_delete+0x58>
    800071f8:	1d600613          	li	a2,470
    800071fc:	0000a597          	auipc	a1,0xa
    80007200:	55458593          	addi	a1,a1,1364 # 80011750 <__FUNCTION__.6>
    80007204:	0000a517          	auipc	a0,0xa
    80007208:	3a450513          	addi	a0,a0,932 # 800115a8 <small_digits.1+0x80>
    8000720c:	969ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007210:	00040513          	mv	a0,s0
    80007214:	24d000ef          	jal	ra,80007c60 <rt_object_is_systemobject>
    80007218:	00050e63          	beqz	a0,80007234 <rt_thread_delete+0x7c>
    8000721c:	1d700613          	li	a2,471
    80007220:	0000a597          	auipc	a1,0xa
    80007224:	53058593          	addi	a1,a1,1328 # 80011750 <__FUNCTION__.6>
    80007228:	0000a517          	auipc	a0,0xa
    8000722c:	41050513          	addi	a0,a0,1040 # 80011638 <small_digits.1+0x110>
    80007230:	945ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007234:	06844783          	lbu	a5,104(s0)
    80007238:	00400713          	li	a4,4
    8000723c:	0077f793          	andi	a5,a5,7
    80007240:	04e78063          	beq	a5,a4,80007280 <rt_thread_delete+0xc8>
    80007244:	00078663          	beqz	a5,80007250 <rt_thread_delete+0x98>
    80007248:	00040513          	mv	a0,s0
    8000724c:	c1cfd0ef          	jal	ra,80004668 <rt_schedule_remove_thread>
    80007250:	00040513          	mv	a0,s0
    80007254:	a2dff0ef          	jal	ra,80006c80 <_rt_thread_cleanup_execute>
    80007258:	08840513          	addi	a0,s0,136
    8000725c:	b4dfc0ef          	jal	ra,80003da8 <rt_timer_detach>
    80007260:	df1f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80007264:	00400793          	li	a5,4
    80007268:	00050493          	mv	s1,a0
    8000726c:	06f40423          	sb	a5,104(s0)
    80007270:	00040513          	mv	a0,s0
    80007274:	959fe0ef          	jal	ra,80005bcc <rt_thread_defunct_enqueue>
    80007278:	00048513          	mv	a0,s1
    8000727c:	dddf80ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80007280:	01813083          	ld	ra,24(sp)
    80007284:	01013403          	ld	s0,16(sp)
    80007288:	00813483          	ld	s1,8(sp)
    8000728c:	00000513          	li	a0,0
    80007290:	02010113          	addi	sp,sp,32
    80007294:	00008067          	ret

0000000080007298 <rt_thread_suspend>:
    80007298:	fe010113          	addi	sp,sp,-32
    8000729c:	00813823          	sd	s0,16(sp)
    800072a0:	00113c23          	sd	ra,24(sp)
    800072a4:	00913423          	sd	s1,8(sp)
    800072a8:	01213023          	sd	s2,0(sp)
    800072ac:	00050413          	mv	s0,a0
    800072b0:	00051e63          	bnez	a0,800072cc <rt_thread_suspend+0x34>
    800072b4:	31400613          	li	a2,788
    800072b8:	0000a597          	auipc	a1,0xa
    800072bc:	45858593          	addi	a1,a1,1112 # 80011710 <__FUNCTION__.2>
    800072c0:	0000a517          	auipc	a0,0xa
    800072c4:	95850513          	addi	a0,a0,-1704 # 80010c18 <__FUNCTION__.6+0x10>
    800072c8:	8adff0ef          	jal	ra,80006b74 <rt_assert_handler>
    800072cc:	00040513          	mv	a0,s0
    800072d0:	1d5000ef          	jal	ra,80007ca4 <rt_object_get_type>
    800072d4:	00100793          	li	a5,1
    800072d8:	00f50e63          	beq	a0,a5,800072f4 <rt_thread_suspend+0x5c>
    800072dc:	31500613          	li	a2,789
    800072e0:	0000a597          	auipc	a1,0xa
    800072e4:	43058593          	addi	a1,a1,1072 # 80011710 <__FUNCTION__.2>
    800072e8:	0000a517          	auipc	a0,0xa
    800072ec:	2c050513          	addi	a0,a0,704 # 800115a8 <small_digits.1+0x80>
    800072f0:	885ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    800072f4:	06844783          	lbu	a5,104(s0)
    800072f8:	00100713          	li	a4,1
    800072fc:	fff00513          	li	a0,-1
    80007300:	0077f913          	andi	s2,a5,7
    80007304:	0057f793          	andi	a5,a5,5
    80007308:	06e79e63          	bne	a5,a4,80007384 <rt_thread_suspend+0xec>
    8000730c:	d45f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80007310:	00300793          	li	a5,3
    80007314:	00050493          	mv	s1,a0
    80007318:	02f91463          	bne	s2,a5,80007340 <rt_thread_suspend+0xa8>
    8000731c:	00016797          	auipc	a5,0x16
    80007320:	5e47b783          	ld	a5,1508(a5) # 8001d900 <rt_current_thread>
    80007324:	00f40e63          	beq	s0,a5,80007340 <rt_thread_suspend+0xa8>
    80007328:	32600613          	li	a2,806
    8000732c:	0000a597          	auipc	a1,0xa
    80007330:	3e458593          	addi	a1,a1,996 # 80011710 <__FUNCTION__.2>
    80007334:	0000a517          	auipc	a0,0xa
    80007338:	34450513          	addi	a0,a0,836 # 80011678 <small_digits.1+0x150>
    8000733c:	839ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007340:	00040513          	mv	a0,s0
    80007344:	b24fd0ef          	jal	ra,80004668 <rt_schedule_remove_thread>
    80007348:	06844783          	lbu	a5,104(s0)
    8000734c:	08840513          	addi	a0,s0,136
    80007350:	ff87f793          	andi	a5,a5,-8
    80007354:	0027e793          	ori	a5,a5,2
    80007358:	06f40423          	sb	a5,104(s0)
    8000735c:	c9dfc0ef          	jal	ra,80003ff8 <rt_timer_stop>
    80007360:	00048513          	mv	a0,s1
    80007364:	cf5f80ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80007368:	00016797          	auipc	a5,0x16
    8000736c:	6307b783          	ld	a5,1584(a5) # 8001d998 <rt_thread_suspend_hook>
    80007370:	00000513          	li	a0,0
    80007374:	00078863          	beqz	a5,80007384 <rt_thread_suspend+0xec>
    80007378:	00040513          	mv	a0,s0
    8000737c:	000780e7          	jalr	a5
    80007380:	00000513          	li	a0,0
    80007384:	01813083          	ld	ra,24(sp)
    80007388:	01013403          	ld	s0,16(sp)
    8000738c:	00813483          	ld	s1,8(sp)
    80007390:	00013903          	ld	s2,0(sp)
    80007394:	02010113          	addi	sp,sp,32
    80007398:	00008067          	ret

000000008000739c <rt_thread_sleep>:
    8000739c:	fd010113          	addi	sp,sp,-48
    800073a0:	02813023          	sd	s0,32(sp)
    800073a4:	02113423          	sd	ra,40(sp)
    800073a8:	00913c23          	sd	s1,24(sp)
    800073ac:	01213823          	sd	s2,16(sp)
    800073b0:	00a12623          	sw	a0,12(sp)
    800073b4:	00016417          	auipc	s0,0x16
    800073b8:	54c43403          	ld	s0,1356(s0) # 8001d900 <rt_current_thread>
    800073bc:	00041e63          	bnez	s0,800073d8 <rt_thread_sleep+0x3c>
    800073c0:	21d00613          	li	a2,541
    800073c4:	0000a597          	auipc	a1,0xa
    800073c8:	37c58593          	addi	a1,a1,892 # 80011740 <__FUNCTION__.5>
    800073cc:	0000a517          	auipc	a0,0xa
    800073d0:	84c50513          	addi	a0,a0,-1972 # 80010c18 <__FUNCTION__.6+0x10>
    800073d4:	fa0ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    800073d8:	00040513          	mv	a0,s0
    800073dc:	0c9000ef          	jal	ra,80007ca4 <rt_object_get_type>
    800073e0:	00100793          	li	a5,1
    800073e4:	00f50e63          	beq	a0,a5,80007400 <rt_thread_sleep+0x64>
    800073e8:	21e00613          	li	a2,542
    800073ec:	0000a597          	auipc	a1,0xa
    800073f0:	35458593          	addi	a1,a1,852 # 80011740 <__FUNCTION__.5>
    800073f4:	0000a517          	auipc	a0,0xa
    800073f8:	1b450513          	addi	a0,a0,436 # 800115a8 <small_digits.1+0x80>
    800073fc:	f78ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007400:	c51f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80007404:	00050913          	mv	s2,a0
    80007408:	00040513          	mv	a0,s0
    8000740c:	e8dff0ef          	jal	ra,80007298 <rt_thread_suspend>
    80007410:	08840493          	addi	s1,s0,136
    80007414:	00c10613          	addi	a2,sp,12
    80007418:	00000593          	li	a1,0
    8000741c:	00048513          	mv	a0,s1
    80007420:	c91fc0ef          	jal	ra,800040b0 <rt_timer_control>
    80007424:	00048513          	mv	a0,s1
    80007428:	a41fc0ef          	jal	ra,80003e68 <rt_timer_start>
    8000742c:	00090513          	mv	a0,s2
    80007430:	c29f80ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80007434:	b24fd0ef          	jal	ra,80004758 <rt_schedule>
    80007438:	06043703          	ld	a4,96(s0)
    8000743c:	ffe00793          	li	a5,-2
    80007440:	00f71463          	bne	a4,a5,80007448 <rt_thread_sleep+0xac>
    80007444:	06043023          	sd	zero,96(s0)
    80007448:	02813083          	ld	ra,40(sp)
    8000744c:	02013403          	ld	s0,32(sp)
    80007450:	01813483          	ld	s1,24(sp)
    80007454:	01013903          	ld	s2,16(sp)
    80007458:	00000513          	li	a0,0
    8000745c:	03010113          	addi	sp,sp,48
    80007460:	00008067          	ret

0000000080007464 <rt_thread_delay>:
    80007464:	f39ff06f          	j	8000739c <rt_thread_sleep>

0000000080007468 <rt_thread_mdelay>:
    80007468:	ff010113          	addi	sp,sp,-16
    8000746c:	00113423          	sd	ra,8(sp)
    80007470:	fdcff0ef          	jal	ra,80006c4c <rt_tick_from_millisecond>
    80007474:	00813083          	ld	ra,8(sp)
    80007478:	0005051b          	sext.w	a0,a0
    8000747c:	01010113          	addi	sp,sp,16
    80007480:	f1dff06f          	j	8000739c <rt_thread_sleep>

0000000080007484 <rt_thread_resume>:
    80007484:	fe010113          	addi	sp,sp,-32
    80007488:	00813823          	sd	s0,16(sp)
    8000748c:	00113c23          	sd	ra,24(sp)
    80007490:	00913423          	sd	s1,8(sp)
    80007494:	00050413          	mv	s0,a0
    80007498:	00051e63          	bnez	a0,800074b4 <rt_thread_resume+0x30>
    8000749c:	34400613          	li	a2,836
    800074a0:	0000a597          	auipc	a1,0xa
    800074a4:	24858593          	addi	a1,a1,584 # 800116e8 <__FUNCTION__.1>
    800074a8:	00009517          	auipc	a0,0x9
    800074ac:	77050513          	addi	a0,a0,1904 # 80010c18 <__FUNCTION__.6+0x10>
    800074b0:	ec4ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    800074b4:	00040513          	mv	a0,s0
    800074b8:	7ec000ef          	jal	ra,80007ca4 <rt_object_get_type>
    800074bc:	00100793          	li	a5,1
    800074c0:	00f50e63          	beq	a0,a5,800074dc <rt_thread_resume+0x58>
    800074c4:	34500613          	li	a2,837
    800074c8:	0000a597          	auipc	a1,0xa
    800074cc:	22058593          	addi	a1,a1,544 # 800116e8 <__FUNCTION__.1>
    800074d0:	0000a517          	auipc	a0,0xa
    800074d4:	0d850513          	addi	a0,a0,216 # 800115a8 <small_digits.1+0x80>
    800074d8:	e9cff0ef          	jal	ra,80006b74 <rt_assert_handler>
    800074dc:	06844783          	lbu	a5,104(s0)
    800074e0:	00200713          	li	a4,2
    800074e4:	fff00513          	li	a0,-1
    800074e8:	0077f793          	andi	a5,a5,7
    800074ec:	04e79e63          	bne	a5,a4,80007548 <rt_thread_resume+0xc4>
    800074f0:	b61f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    800074f4:	02843683          	ld	a3,40(s0)
    800074f8:	03043703          	ld	a4,48(s0)
    800074fc:	02840793          	addi	a5,s0,40
    80007500:	00050493          	mv	s1,a0
    80007504:	00e6b423          	sd	a4,8(a3)
    80007508:	00d73023          	sd	a3,0(a4)
    8000750c:	02f43823          	sd	a5,48(s0)
    80007510:	02f43423          	sd	a5,40(s0)
    80007514:	08840513          	addi	a0,s0,136
    80007518:	ae1fc0ef          	jal	ra,80003ff8 <rt_timer_stop>
    8000751c:	00040513          	mv	a0,s0
    80007520:	89cfd0ef          	jal	ra,800045bc <rt_schedule_insert_thread>
    80007524:	00048513          	mv	a0,s1
    80007528:	b31f80ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000752c:	00016797          	auipc	a5,0x16
    80007530:	4647b783          	ld	a5,1124(a5) # 8001d990 <rt_thread_resume_hook>
    80007534:	00000513          	li	a0,0
    80007538:	00078863          	beqz	a5,80007548 <rt_thread_resume+0xc4>
    8000753c:	00040513          	mv	a0,s0
    80007540:	000780e7          	jalr	a5
    80007544:	00000513          	li	a0,0
    80007548:	01813083          	ld	ra,24(sp)
    8000754c:	01013403          	ld	s0,16(sp)
    80007550:	00813483          	ld	s1,8(sp)
    80007554:	02010113          	addi	sp,sp,32
    80007558:	00008067          	ret

000000008000755c <rt_thread_startup>:
    8000755c:	ff010113          	addi	sp,sp,-16
    80007560:	00813023          	sd	s0,0(sp)
    80007564:	00113423          	sd	ra,8(sp)
    80007568:	00050413          	mv	s0,a0
    8000756c:	00051e63          	bnez	a0,80007588 <rt_thread_startup+0x2c>
    80007570:	14100613          	li	a2,321
    80007574:	0000a597          	auipc	a1,0xa
    80007578:	20c58593          	addi	a1,a1,524 # 80011780 <__FUNCTION__.8>
    8000757c:	00009517          	auipc	a0,0x9
    80007580:	69c50513          	addi	a0,a0,1692 # 80010c18 <__FUNCTION__.6+0x10>
    80007584:	df0ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007588:	06844783          	lbu	a5,104(s0)
    8000758c:	0077f793          	andi	a5,a5,7
    80007590:	00078e63          	beqz	a5,800075ac <rt_thread_startup+0x50>
    80007594:	14200613          	li	a2,322
    80007598:	0000a597          	auipc	a1,0xa
    8000759c:	1e858593          	addi	a1,a1,488 # 80011780 <__FUNCTION__.8>
    800075a0:	0000a517          	auipc	a0,0xa
    800075a4:	0f850513          	addi	a0,a0,248 # 80011698 <small_digits.1+0x170>
    800075a8:	dccff0ef          	jal	ra,80006b74 <rt_assert_handler>
    800075ac:	00040513          	mv	a0,s0
    800075b0:	6f4000ef          	jal	ra,80007ca4 <rt_object_get_type>
    800075b4:	00100793          	li	a5,1
    800075b8:	00f50e63          	beq	a0,a5,800075d4 <rt_thread_startup+0x78>
    800075bc:	14300613          	li	a2,323
    800075c0:	0000a597          	auipc	a1,0xa
    800075c4:	1c058593          	addi	a1,a1,448 # 80011780 <__FUNCTION__.8>
    800075c8:	0000a517          	auipc	a0,0xa
    800075cc:	fe050513          	addi	a0,a0,-32 # 800115a8 <small_digits.1+0x80>
    800075d0:	da4ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    800075d4:	06a44703          	lbu	a4,106(s0)
    800075d8:	00100793          	li	a5,1
    800075dc:	00040513          	mv	a0,s0
    800075e0:	00e797b3          	sll	a5,a5,a4
    800075e4:	06f42623          	sw	a5,108(s0)
    800075e8:	00200793          	li	a5,2
    800075ec:	06f40423          	sb	a5,104(s0)
    800075f0:	06e404a3          	sb	a4,105(s0)
    800075f4:	e91ff0ef          	jal	ra,80007484 <rt_thread_resume>
    800075f8:	00016797          	auipc	a5,0x16
    800075fc:	3087b783          	ld	a5,776(a5) # 8001d900 <rt_current_thread>
    80007600:	00078463          	beqz	a5,80007608 <rt_thread_startup+0xac>
    80007604:	954fd0ef          	jal	ra,80004758 <rt_schedule>
    80007608:	00813083          	ld	ra,8(sp)
    8000760c:	00013403          	ld	s0,0(sp)
    80007610:	00000513          	li	a0,0
    80007614:	01010113          	addi	sp,sp,16
    80007618:	00008067          	ret

000000008000761c <rt_thread_control>:
    8000761c:	fc010113          	addi	sp,sp,-64
    80007620:	02813823          	sd	s0,48(sp)
    80007624:	02913423          	sd	s1,40(sp)
    80007628:	03213023          	sd	s2,32(sp)
    8000762c:	02113c23          	sd	ra,56(sp)
    80007630:	01313c23          	sd	s3,24(sp)
    80007634:	00050413          	mv	s0,a0
    80007638:	00058493          	mv	s1,a1
    8000763c:	00060913          	mv	s2,a2
    80007640:	00051e63          	bnez	a0,8000765c <rt_thread_control+0x40>
    80007644:	2a200613          	li	a2,674
    80007648:	0000a597          	auipc	a1,0xa
    8000764c:	0e058593          	addi	a1,a1,224 # 80011728 <__FUNCTION__.3>
    80007650:	00009517          	auipc	a0,0x9
    80007654:	5c850513          	addi	a0,a0,1480 # 80010c18 <__FUNCTION__.6+0x10>
    80007658:	d1cff0ef          	jal	ra,80006b74 <rt_assert_handler>
    8000765c:	00040513          	mv	a0,s0
    80007660:	644000ef          	jal	ra,80007ca4 <rt_object_get_type>
    80007664:	00100793          	li	a5,1
    80007668:	00f50e63          	beq	a0,a5,80007684 <rt_thread_control+0x68>
    8000766c:	2a300613          	li	a2,675
    80007670:	0000a597          	auipc	a1,0xa
    80007674:	0b858593          	addi	a1,a1,184 # 80011728 <__FUNCTION__.3>
    80007678:	0000a517          	auipc	a0,0xa
    8000767c:	f3050513          	addi	a0,a0,-208 # 800115a8 <small_digits.1+0x80>
    80007680:	cf4ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007684:	00100993          	li	s3,1
    80007688:	0b348663          	beq	s1,s3,80007734 <rt_thread_control+0x118>
    8000768c:	00200793          	li	a5,2
    80007690:	02f48463          	beq	s1,a5,800076b8 <rt_thread_control+0x9c>
    80007694:	08048063          	beqz	s1,80007714 <rt_thread_control+0xf8>
    80007698:	00000513          	li	a0,0
    8000769c:	03813083          	ld	ra,56(sp)
    800076a0:	03013403          	ld	s0,48(sp)
    800076a4:	02813483          	ld	s1,40(sp)
    800076a8:	02013903          	ld	s2,32(sp)
    800076ac:	01813983          	ld	s3,24(sp)
    800076b0:	04010113          	addi	sp,sp,64
    800076b4:	00008067          	ret
    800076b8:	999f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    800076bc:	06844783          	lbu	a5,104(s0)
    800076c0:	00050493          	mv	s1,a0
    800076c4:	0077f793          	andi	a5,a5,7
    800076c8:	03379a63          	bne	a5,s3,800076fc <rt_thread_control+0xe0>
    800076cc:	00040513          	mv	a0,s0
    800076d0:	f99fc0ef          	jal	ra,80004668 <rt_schedule_remove_thread>
    800076d4:	00094703          	lbu	a4,0(s2)
    800076d8:	00100793          	li	a5,1
    800076dc:	00040513          	mv	a0,s0
    800076e0:	00e797bb          	sllw	a5,a5,a4
    800076e4:	06e404a3          	sb	a4,105(s0)
    800076e8:	06f42623          	sw	a5,108(s0)
    800076ec:	ed1fc0ef          	jal	ra,800045bc <rt_schedule_insert_thread>
    800076f0:	00048513          	mv	a0,s1
    800076f4:	965f80ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    800076f8:	fa1ff06f          	j	80007698 <rt_thread_control+0x7c>
    800076fc:	00094703          	lbu	a4,0(s2)
    80007700:	00100793          	li	a5,1
    80007704:	00e797bb          	sllw	a5,a5,a4
    80007708:	06e404a3          	sb	a4,105(s0)
    8000770c:	06f42623          	sw	a5,108(s0)
    80007710:	fe1ff06f          	j	800076f0 <rt_thread_control+0xd4>
    80007714:	00040513          	mv	a0,s0
    80007718:	03013403          	ld	s0,48(sp)
    8000771c:	03813083          	ld	ra,56(sp)
    80007720:	02813483          	ld	s1,40(sp)
    80007724:	02013903          	ld	s2,32(sp)
    80007728:	01813983          	ld	s3,24(sp)
    8000772c:	04010113          	addi	sp,sp,64
    80007730:	e2dff06f          	j	8000755c <rt_thread_startup>
    80007734:	00040513          	mv	a0,s0
    80007738:	528000ef          	jal	ra,80007c60 <rt_object_is_systemobject>
    8000773c:	00951e63          	bne	a0,s1,80007758 <rt_thread_control+0x13c>
    80007740:	00040513          	mv	a0,s0
    80007744:	8c9ff0ef          	jal	ra,8000700c <rt_thread_detach>
    80007748:	00a13423          	sd	a0,8(sp)
    8000774c:	80cfd0ef          	jal	ra,80004758 <rt_schedule>
    80007750:	00813503          	ld	a0,8(sp)
    80007754:	f49ff06f          	j	8000769c <rt_thread_control+0x80>
    80007758:	00040513          	mv	a0,s0
    8000775c:	a5dff0ef          	jal	ra,800071b8 <rt_thread_delete>
    80007760:	fe9ff06f          	j	80007748 <rt_thread_control+0x12c>

0000000080007764 <rti_start>:
    80007764:	00000513          	li	a0,0
    80007768:	00008067          	ret

000000008000776c <rti_end>:
    8000776c:	00000513          	li	a0,0
    80007770:	00008067          	ret

0000000080007774 <rti_board_start>:
    80007774:	00000513          	li	a0,0
    80007778:	00008067          	ret

000000008000777c <rti_board_end>:
    8000777c:	00000513          	li	a0,0
    80007780:	00008067          	ret

0000000080007784 <rt_components_board_init>:
    80007784:	fe010113          	addi	sp,sp,-32
    80007788:	00813823          	sd	s0,16(sp)
    8000778c:	00913423          	sd	s1,8(sp)
    80007790:	00113c23          	sd	ra,24(sp)
    80007794:	0000d417          	auipc	s0,0xd
    80007798:	1c440413          	addi	s0,s0,452 # 80014958 <__rt_init_rti_board_start>
    8000779c:	0000d497          	auipc	s1,0xd
    800077a0:	1c448493          	addi	s1,s1,452 # 80014960 <__rt_init_rti_board_end>
    800077a4:	00946c63          	bltu	s0,s1,800077bc <rt_components_board_init+0x38>
    800077a8:	01813083          	ld	ra,24(sp)
    800077ac:	01013403          	ld	s0,16(sp)
    800077b0:	00813483          	ld	s1,8(sp)
    800077b4:	02010113          	addi	sp,sp,32
    800077b8:	00008067          	ret
    800077bc:	00043783          	ld	a5,0(s0)
    800077c0:	00840413          	addi	s0,s0,8
    800077c4:	000780e7          	jalr	a5
    800077c8:	fddff06f          	j	800077a4 <rt_components_board_init+0x20>

00000000800077cc <rt_components_init>:
    800077cc:	fe010113          	addi	sp,sp,-32
    800077d0:	00813823          	sd	s0,16(sp)
    800077d4:	00913423          	sd	s1,8(sp)
    800077d8:	00113c23          	sd	ra,24(sp)
    800077dc:	0000d417          	auipc	s0,0xd
    800077e0:	18440413          	addi	s0,s0,388 # 80014960 <__rt_init_rti_board_end>
    800077e4:	0000d497          	auipc	s1,0xd
    800077e8:	19c48493          	addi	s1,s1,412 # 80014980 <__rt_init_rti_end>
    800077ec:	00946c63          	bltu	s0,s1,80007804 <rt_components_init+0x38>
    800077f0:	01813083          	ld	ra,24(sp)
    800077f4:	01013403          	ld	s0,16(sp)
    800077f8:	00813483          	ld	s1,8(sp)
    800077fc:	02010113          	addi	sp,sp,32
    80007800:	00008067          	ret
    80007804:	00043783          	ld	a5,0(s0)
    80007808:	00840413          	addi	s0,s0,8
    8000780c:	000780e7          	jalr	a5
    80007810:	fddff06f          	j	800077ec <rt_components_init+0x20>

0000000080007814 <main_thread_entry>:
    80007814:	ff010113          	addi	sp,sp,-16
    80007818:	00113423          	sd	ra,8(sp)
    8000781c:	fb1ff0ef          	jal	ra,800077cc <rt_components_init>
    80007820:	00813083          	ld	ra,8(sp)
    80007824:	01010113          	addi	sp,sp,16
    80007828:	97df806f          	j	800001a4 <main>

000000008000782c <rt_application_init>:
    8000782c:	ff010113          	addi	sp,sp,-16
    80007830:	01400793          	li	a5,20
    80007834:	00a00713          	li	a4,10
    80007838:	000046b7          	lui	a3,0x4
    8000783c:	00000613          	li	a2,0
    80007840:	00000597          	auipc	a1,0x0
    80007844:	fd458593          	addi	a1,a1,-44 # 80007814 <main_thread_entry>
    80007848:	0000a517          	auipc	a0,0xa
    8000784c:	f6050513          	addi	a0,a0,-160 # 800117a8 <__FUNCTION__.9+0x10>
    80007850:	00813023          	sd	s0,0(sp)
    80007854:	00113423          	sd	ra,8(sp)
    80007858:	8b1ff0ef          	jal	ra,80007108 <rt_thread_create>
    8000785c:	00050413          	mv	s0,a0
    80007860:	00051e63          	bnez	a0,8000787c <rt_application_init+0x50>
    80007864:	0cb00613          	li	a2,203
    80007868:	0000a597          	auipc	a1,0xa
    8000786c:	f5858593          	addi	a1,a1,-168 # 800117c0 <__FUNCTION__.0>
    80007870:	0000a517          	auipc	a0,0xa
    80007874:	f4050513          	addi	a0,a0,-192 # 800117b0 <__FUNCTION__.9+0x18>
    80007878:	afcff0ef          	jal	ra,80006b74 <rt_assert_handler>
    8000787c:	00040513          	mv	a0,s0
    80007880:	00013403          	ld	s0,0(sp)
    80007884:	00813083          	ld	ra,8(sp)
    80007888:	01010113          	addi	sp,sp,16
    8000788c:	cd1ff06f          	j	8000755c <rt_thread_startup>

0000000080007890 <rtthread_startup>:
    80007890:	ff010113          	addi	sp,sp,-16
    80007894:	00113423          	sd	ra,8(sp)
    80007898:	fb8f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000789c:	834fc0ef          	jal	ra,800038d0 <rt_hw_board_init>
    800078a0:	9fcff0ef          	jal	ra,80006a9c <rt_show_version>
    800078a4:	c69fc0ef          	jal	ra,8000450c <rt_system_timer_init>
    800078a8:	ce1fc0ef          	jal	ra,80004588 <rt_system_scheduler_init>
    800078ac:	f81ff0ef          	jal	ra,8000782c <rt_application_init>
    800078b0:	c71fc0ef          	jal	ra,80004520 <rt_system_timer_thread_init>
    800078b4:	c88fe0ef          	jal	ra,80005d3c <rt_thread_idle_init>
    800078b8:	e45fc0ef          	jal	ra,800046fc <rt_system_scheduler_start>
    800078bc:	00813083          	ld	ra,8(sp)
    800078c0:	00000513          	li	a0,0
    800078c4:	01010113          	addi	sp,sp,16
    800078c8:	00008067          	ret

00000000800078cc <entry>:
    800078cc:	ff010113          	addi	sp,sp,-16
    800078d0:	00113423          	sd	ra,8(sp)
    800078d4:	fbdff0ef          	jal	ra,80007890 <rtthread_startup>
    800078d8:	00813083          	ld	ra,8(sp)
    800078dc:	00000513          	li	a0,0
    800078e0:	01010113          	addi	sp,sp,16
    800078e4:	00008067          	ret

00000000800078e8 <rt_object_get_information>:
    800078e8:	0000e697          	auipc	a3,0xe
    800078ec:	c9868693          	addi	a3,a3,-872 # 80015580 <rt_object_container>
    800078f0:	00000793          	li	a5,0
    800078f4:	00068713          	mv	a4,a3
    800078f8:	00900613          	li	a2,9
    800078fc:	0006a583          	lw	a1,0(a3)
    80007900:	00a59863          	bne	a1,a0,80007910 <rt_object_get_information+0x28>
    80007904:	00579793          	slli	a5,a5,0x5
    80007908:	00f70533          	add	a0,a4,a5
    8000790c:	00008067          	ret
    80007910:	0017879b          	addiw	a5,a5,1
    80007914:	02068693          	addi	a3,a3,32
    80007918:	fec792e3          	bne	a5,a2,800078fc <rt_object_get_information+0x14>
    8000791c:	00000513          	li	a0,0
    80007920:	00008067          	ret

0000000080007924 <rt_object_init>:
    80007924:	fb010113          	addi	sp,sp,-80
    80007928:	04813023          	sd	s0,64(sp)
    8000792c:	00050413          	mv	s0,a0
    80007930:	00058513          	mv	a0,a1
    80007934:	02913c23          	sd	s1,56(sp)
    80007938:	03213823          	sd	s2,48(sp)
    8000793c:	03413023          	sd	s4,32(sp)
    80007940:	04113423          	sd	ra,72(sp)
    80007944:	03313423          	sd	s3,40(sp)
    80007948:	01513c23          	sd	s5,24(sp)
    8000794c:	01613823          	sd	s6,16(sp)
    80007950:	01713423          	sd	s7,8(sp)
    80007954:	00058913          	mv	s2,a1
    80007958:	00060a13          	mv	s4,a2
    8000795c:	f8dff0ef          	jal	ra,800078e8 <rt_object_get_information>
    80007960:	00050493          	mv	s1,a0
    80007964:	00051e63          	bnez	a0,80007980 <rt_object_init+0x5c>
    80007968:	13800613          	li	a2,312
    8000796c:	0000a597          	auipc	a1,0xa
    80007970:	f6c58593          	addi	a1,a1,-148 # 800118d8 <__FUNCTION__.6>
    80007974:	0000a517          	auipc	a0,0xa
    80007978:	e6450513          	addi	a0,a0,-412 # 800117d8 <__FUNCTION__.0+0x18>
    8000797c:	9f8ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007980:	f59fc0ef          	jal	ra,800048d8 <rt_enter_critical>
    80007984:	0084b983          	ld	s3,8(s1)
    80007988:	00848a93          	addi	s5,s1,8
    8000798c:	0000ab17          	auipc	s6,0xa
    80007990:	f4cb0b13          	addi	s6,s6,-180 # 800118d8 <__FUNCTION__.6>
    80007994:	0000ab97          	auipc	s7,0xa
    80007998:	e5cb8b93          	addi	s7,s7,-420 # 800117f0 <__FUNCTION__.0+0x30>
    8000799c:	073a9e63          	bne	s5,s3,80007a18 <rt_object_init+0xf4>
    800079a0:	f65fc0ef          	jal	ra,80004904 <rt_exit_critical>
    800079a4:	f8096913          	ori	s2,s2,-128
    800079a8:	01240a23          	sb	s2,20(s0)
    800079ac:	01400613          	li	a2,20
    800079b0:	000a0593          	mv	a1,s4
    800079b4:	00040513          	mv	a0,s0
    800079b8:	89dfe0ef          	jal	ra,80006254 <rt_strncpy>
    800079bc:	00016797          	auipc	a5,0x16
    800079c0:	fe47b783          	ld	a5,-28(a5) # 8001d9a0 <rt_object_attach_hook>
    800079c4:	00078663          	beqz	a5,800079d0 <rt_object_init+0xac>
    800079c8:	00040513          	mv	a0,s0
    800079cc:	000780e7          	jalr	a5
    800079d0:	e80f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    800079d4:	0084b703          	ld	a4,8(s1)
    800079d8:	01840793          	addi	a5,s0,24
    800079dc:	04813083          	ld	ra,72(sp)
    800079e0:	00f73423          	sd	a5,8(a4)
    800079e4:	00e43c23          	sd	a4,24(s0)
    800079e8:	00f4b423          	sd	a5,8(s1)
    800079ec:	03543023          	sd	s5,32(s0)
    800079f0:	04013403          	ld	s0,64(sp)
    800079f4:	03813483          	ld	s1,56(sp)
    800079f8:	03013903          	ld	s2,48(sp)
    800079fc:	02813983          	ld	s3,40(sp)
    80007a00:	02013a03          	ld	s4,32(sp)
    80007a04:	01813a83          	ld	s5,24(sp)
    80007a08:	01013b03          	ld	s6,16(sp)
    80007a0c:	00813b83          	ld	s7,8(sp)
    80007a10:	05010113          	addi	sp,sp,80
    80007a14:	e44f806f          	j	80000058 <rt_hw_interrupt_enable>
    80007a18:	fe898793          	addi	a5,s3,-24
    80007a1c:	00f41a63          	bne	s0,a5,80007a30 <rt_object_init+0x10c>
    80007a20:	14800613          	li	a2,328
    80007a24:	000b0593          	mv	a1,s6
    80007a28:	000b8513          	mv	a0,s7
    80007a2c:	948ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007a30:	0009b983          	ld	s3,0(s3)
    80007a34:	f69ff06f          	j	8000799c <rt_object_init+0x78>

0000000080007a38 <rt_object_detach>:
    80007a38:	ff010113          	addi	sp,sp,-16
    80007a3c:	00813023          	sd	s0,0(sp)
    80007a40:	00113423          	sd	ra,8(sp)
    80007a44:	00050413          	mv	s0,a0
    80007a48:	00051e63          	bnez	a0,80007a64 <rt_object_detach+0x2c>
    80007a4c:	17500613          	li	a2,373
    80007a50:	0000a597          	auipc	a1,0xa
    80007a54:	e7058593          	addi	a1,a1,-400 # 800118c0 <__FUNCTION__.5>
    80007a58:	0000a517          	auipc	a0,0xa
    80007a5c:	da850513          	addi	a0,a0,-600 # 80011800 <__FUNCTION__.0+0x40>
    80007a60:	914ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007a64:	00016797          	auipc	a5,0x16
    80007a68:	f447b783          	ld	a5,-188(a5) # 8001d9a8 <rt_object_detach_hook>
    80007a6c:	00078663          	beqz	a5,80007a78 <rt_object_detach+0x40>
    80007a70:	00040513          	mv	a0,s0
    80007a74:	000780e7          	jalr	a5
    80007a78:	00040a23          	sb	zero,20(s0)
    80007a7c:	dd4f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80007a80:	01843683          	ld	a3,24(s0)
    80007a84:	02043703          	ld	a4,32(s0)
    80007a88:	01840793          	addi	a5,s0,24
    80007a8c:	00813083          	ld	ra,8(sp)
    80007a90:	00e6b423          	sd	a4,8(a3)
    80007a94:	00d73023          	sd	a3,0(a4)
    80007a98:	02f43023          	sd	a5,32(s0)
    80007a9c:	00f43c23          	sd	a5,24(s0)
    80007aa0:	00013403          	ld	s0,0(sp)
    80007aa4:	01010113          	addi	sp,sp,16
    80007aa8:	db0f806f          	j	80000058 <rt_hw_interrupt_enable>

0000000080007aac <rt_object_allocate>:
    80007aac:	fd010113          	addi	sp,sp,-48
    80007ab0:	02813023          	sd	s0,32(sp)
    80007ab4:	01213823          	sd	s2,16(sp)
    80007ab8:	01313423          	sd	s3,8(sp)
    80007abc:	02113423          	sd	ra,40(sp)
    80007ac0:	00913c23          	sd	s1,24(sp)
    80007ac4:	00050913          	mv	s2,a0
    80007ac8:	00058993          	mv	s3,a1
    80007acc:	d84f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80007ad0:	00050413          	mv	s0,a0
    80007ad4:	9d8fc0ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    80007ad8:	02050863          	beqz	a0,80007b08 <rt_object_allocate+0x5c>
    80007adc:	0000a597          	auipc	a1,0xa
    80007ae0:	dcc58593          	addi	a1,a1,-564 # 800118a8 <__FUNCTION__.4>
    80007ae4:	00009517          	auipc	a0,0x9
    80007ae8:	36450513          	addi	a0,a0,868 # 80010e48 <__FUNCTION__.1+0x1f8>
    80007aec:	f01fe0ef          	jal	ra,800069ec <rt_kprintf>
    80007af0:	19800613          	li	a2,408
    80007af4:	0000a597          	auipc	a1,0xa
    80007af8:	db458593          	addi	a1,a1,-588 # 800118a8 <__FUNCTION__.4>
    80007afc:	00009517          	auipc	a0,0x9
    80007b00:	37450513          	addi	a0,a0,884 # 80010e70 <__FUNCTION__.1+0x220>
    80007b04:	870ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007b08:	00040513          	mv	a0,s0
    80007b0c:	d4cf80ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80007b10:	00090513          	mv	a0,s2
    80007b14:	dd5ff0ef          	jal	ra,800078e8 <rt_object_get_information>
    80007b18:	00050493          	mv	s1,a0
    80007b1c:	00051e63          	bnez	a0,80007b38 <rt_object_allocate+0x8c>
    80007b20:	19c00613          	li	a2,412
    80007b24:	0000a597          	auipc	a1,0xa
    80007b28:	d8458593          	addi	a1,a1,-636 # 800118a8 <__FUNCTION__.4>
    80007b2c:	0000a517          	auipc	a0,0xa
    80007b30:	cac50513          	addi	a0,a0,-852 # 800117d8 <__FUNCTION__.0+0x18>
    80007b34:	840ff0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007b38:	0184b503          	ld	a0,24(s1)
    80007b3c:	be8fd0ef          	jal	ra,80004f24 <rt_malloc>
    80007b40:	00050413          	mv	s0,a0
    80007b44:	06050063          	beqz	a0,80007ba4 <rt_object_allocate+0xf8>
    80007b48:	0184b603          	ld	a2,24(s1)
    80007b4c:	00000593          	li	a1,0
    80007b50:	cc0fe0ef          	jal	ra,80006010 <rt_memset>
    80007b54:	01400613          	li	a2,20
    80007b58:	01240a23          	sb	s2,20(s0)
    80007b5c:	00040aa3          	sb	zero,21(s0)
    80007b60:	00098593          	mv	a1,s3
    80007b64:	00040513          	mv	a0,s0
    80007b68:	eecfe0ef          	jal	ra,80006254 <rt_strncpy>
    80007b6c:	00016797          	auipc	a5,0x16
    80007b70:	e347b783          	ld	a5,-460(a5) # 8001d9a0 <rt_object_attach_hook>
    80007b74:	00078663          	beqz	a5,80007b80 <rt_object_allocate+0xd4>
    80007b78:	00040513          	mv	a0,s0
    80007b7c:	000780e7          	jalr	a5
    80007b80:	cd0f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80007b84:	0084b703          	ld	a4,8(s1)
    80007b88:	01840793          	addi	a5,s0,24
    80007b8c:	00848493          	addi	s1,s1,8
    80007b90:	00f73423          	sd	a5,8(a4)
    80007b94:	00e43c23          	sd	a4,24(s0)
    80007b98:	00f4b023          	sd	a5,0(s1)
    80007b9c:	02943023          	sd	s1,32(s0)
    80007ba0:	cb8f80ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80007ba4:	02813083          	ld	ra,40(sp)
    80007ba8:	00040513          	mv	a0,s0
    80007bac:	02013403          	ld	s0,32(sp)
    80007bb0:	01813483          	ld	s1,24(sp)
    80007bb4:	01013903          	ld	s2,16(sp)
    80007bb8:	00813983          	ld	s3,8(sp)
    80007bbc:	03010113          	addi	sp,sp,48
    80007bc0:	00008067          	ret

0000000080007bc4 <rt_object_delete>:
    80007bc4:	ff010113          	addi	sp,sp,-16
    80007bc8:	00813023          	sd	s0,0(sp)
    80007bcc:	00113423          	sd	ra,8(sp)
    80007bd0:	00050413          	mv	s0,a0
    80007bd4:	00051e63          	bnez	a0,80007bf0 <rt_object_delete+0x2c>
    80007bd8:	1d600613          	li	a2,470
    80007bdc:	0000a597          	auipc	a1,0xa
    80007be0:	cb458593          	addi	a1,a1,-844 # 80011890 <__FUNCTION__.3>
    80007be4:	0000a517          	auipc	a0,0xa
    80007be8:	c1c50513          	addi	a0,a0,-996 # 80011800 <__FUNCTION__.0+0x40>
    80007bec:	f89fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007bf0:	01440783          	lb	a5,20(s0)
    80007bf4:	0007de63          	bgez	a5,80007c10 <rt_object_delete+0x4c>
    80007bf8:	1d700613          	li	a2,471
    80007bfc:	0000a597          	auipc	a1,0xa
    80007c00:	c9458593          	addi	a1,a1,-876 # 80011890 <__FUNCTION__.3>
    80007c04:	0000a517          	auipc	a0,0xa
    80007c08:	c1450513          	addi	a0,a0,-1004 # 80011818 <__FUNCTION__.0+0x58>
    80007c0c:	f69fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007c10:	00016797          	auipc	a5,0x16
    80007c14:	d987b783          	ld	a5,-616(a5) # 8001d9a8 <rt_object_detach_hook>
    80007c18:	00078663          	beqz	a5,80007c24 <rt_object_delete+0x60>
    80007c1c:	00040513          	mv	a0,s0
    80007c20:	000780e7          	jalr	a5
    80007c24:	00040a23          	sb	zero,20(s0)
    80007c28:	c28f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80007c2c:	01843683          	ld	a3,24(s0)
    80007c30:	02043703          	ld	a4,32(s0)
    80007c34:	01840793          	addi	a5,s0,24
    80007c38:	00e6b423          	sd	a4,8(a3)
    80007c3c:	00d73023          	sd	a3,0(a4)
    80007c40:	02f43023          	sd	a5,32(s0)
    80007c44:	00f43c23          	sd	a5,24(s0)
    80007c48:	c10f80ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80007c4c:	00040513          	mv	a0,s0
    80007c50:	00013403          	ld	s0,0(sp)
    80007c54:	00813083          	ld	ra,8(sp)
    80007c58:	01010113          	addi	sp,sp,16
    80007c5c:	e14fd06f          	j	80005270 <rt_free>

0000000080007c60 <rt_object_is_systemobject>:
    80007c60:	ff010113          	addi	sp,sp,-16
    80007c64:	00813023          	sd	s0,0(sp)
    80007c68:	00113423          	sd	ra,8(sp)
    80007c6c:	00050413          	mv	s0,a0
    80007c70:	00051e63          	bnez	a0,80007c8c <rt_object_is_systemobject+0x2c>
    80007c74:	1f800613          	li	a2,504
    80007c78:	0000a597          	auipc	a1,0xa
    80007c7c:	bf858593          	addi	a1,a1,-1032 # 80011870 <__FUNCTION__.2>
    80007c80:	0000a517          	auipc	a0,0xa
    80007c84:	b8050513          	addi	a0,a0,-1152 # 80011800 <__FUNCTION__.0+0x40>
    80007c88:	eedfe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007c8c:	01440503          	lb	a0,20(s0)
    80007c90:	00813083          	ld	ra,8(sp)
    80007c94:	00013403          	ld	s0,0(sp)
    80007c98:	01f5551b          	srliw	a0,a0,0x1f
    80007c9c:	01010113          	addi	sp,sp,16
    80007ca0:	00008067          	ret

0000000080007ca4 <rt_object_get_type>:
    80007ca4:	ff010113          	addi	sp,sp,-16
    80007ca8:	00813023          	sd	s0,0(sp)
    80007cac:	00113423          	sd	ra,8(sp)
    80007cb0:	00050413          	mv	s0,a0
    80007cb4:	00051e63          	bnez	a0,80007cd0 <rt_object_get_type+0x2c>
    80007cb8:	20b00613          	li	a2,523
    80007cbc:	0000a597          	auipc	a1,0xa
    80007cc0:	b9c58593          	addi	a1,a1,-1124 # 80011858 <__FUNCTION__.1>
    80007cc4:	0000a517          	auipc	a0,0xa
    80007cc8:	b3c50513          	addi	a0,a0,-1220 # 80011800 <__FUNCTION__.0+0x40>
    80007ccc:	ea9fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007cd0:	01444503          	lbu	a0,20(s0)
    80007cd4:	00813083          	ld	ra,8(sp)
    80007cd8:	00013403          	ld	s0,0(sp)
    80007cdc:	07f57513          	andi	a0,a0,127
    80007ce0:	01010113          	addi	sp,sp,16
    80007ce4:	00008067          	ret

0000000080007ce8 <rt_object_find>:
    80007ce8:	fd010113          	addi	sp,sp,-48
    80007cec:	01213823          	sd	s2,16(sp)
    80007cf0:	00050913          	mv	s2,a0
    80007cf4:	00058513          	mv	a0,a1
    80007cf8:	02113423          	sd	ra,40(sp)
    80007cfc:	02813023          	sd	s0,32(sp)
    80007d00:	00913c23          	sd	s1,24(sp)
    80007d04:	01313423          	sd	s3,8(sp)
    80007d08:	be1ff0ef          	jal	ra,800078e8 <rt_object_get_information>
    80007d0c:	06090263          	beqz	s2,80007d70 <rt_object_find+0x88>
    80007d10:	00050413          	mv	s0,a0
    80007d14:	08050063          	beqz	a0,80007d94 <rt_object_find+0xac>
    80007d18:	b38f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80007d1c:	00050493          	mv	s1,a0
    80007d20:	f8dfb0ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    80007d24:	02050863          	beqz	a0,80007d54 <rt_object_find+0x6c>
    80007d28:	0000a597          	auipc	a1,0xa
    80007d2c:	b2058593          	addi	a1,a1,-1248 # 80011848 <__FUNCTION__.0>
    80007d30:	00009517          	auipc	a0,0x9
    80007d34:	11850513          	addi	a0,a0,280 # 80010e48 <__FUNCTION__.1+0x1f8>
    80007d38:	cb5fe0ef          	jal	ra,800069ec <rt_kprintf>
    80007d3c:	22800613          	li	a2,552
    80007d40:	0000a597          	auipc	a1,0xa
    80007d44:	b0858593          	addi	a1,a1,-1272 # 80011848 <__FUNCTION__.0>
    80007d48:	00009517          	auipc	a0,0x9
    80007d4c:	12850513          	addi	a0,a0,296 # 80010e70 <__FUNCTION__.1+0x220>
    80007d50:	e25fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007d54:	00048513          	mv	a0,s1
    80007d58:	b00f80ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80007d5c:	b7dfc0ef          	jal	ra,800048d8 <rt_enter_critical>
    80007d60:	00843483          	ld	s1,8(s0)
    80007d64:	00840993          	addi	s3,s0,8
    80007d68:	01349863          	bne	s1,s3,80007d78 <rt_object_find+0x90>
    80007d6c:	b99fc0ef          	jal	ra,80004904 <rt_exit_critical>
    80007d70:	00000413          	li	s0,0
    80007d74:	0200006f          	j	80007d94 <rt_object_find+0xac>
    80007d78:	fe848413          	addi	s0,s1,-24
    80007d7c:	01400613          	li	a2,20
    80007d80:	00090593          	mv	a1,s2
    80007d84:	00040513          	mv	a0,s0
    80007d88:	d10fe0ef          	jal	ra,80006298 <rt_strncmp>
    80007d8c:	02051463          	bnez	a0,80007db4 <rt_object_find+0xcc>
    80007d90:	b75fc0ef          	jal	ra,80004904 <rt_exit_critical>
    80007d94:	02813083          	ld	ra,40(sp)
    80007d98:	00040513          	mv	a0,s0
    80007d9c:	02013403          	ld	s0,32(sp)
    80007da0:	01813483          	ld	s1,24(sp)
    80007da4:	01013903          	ld	s2,16(sp)
    80007da8:	00813983          	ld	s3,8(sp)
    80007dac:	03010113          	addi	sp,sp,48
    80007db0:	00008067          	ret
    80007db4:	0004b483          	ld	s1,0(s1)
    80007db8:	fb1ff06f          	j	80007d68 <rt_object_find+0x80>

0000000080007dbc <rt_ipc_list_resume.isra.0>:
    80007dbc:	fd850513          	addi	a0,a0,-40
    80007dc0:	ec4ff06f          	j	80007484 <rt_thread_resume>

0000000080007dc4 <rt_ipc_list_suspend.isra.0>:
    80007dc4:	fe010113          	addi	sp,sp,-32
    80007dc8:	00913423          	sd	s1,8(sp)
    80007dcc:	01213023          	sd	s2,0(sp)
    80007dd0:	00050493          	mv	s1,a0
    80007dd4:	00060913          	mv	s2,a2
    80007dd8:	00058513          	mv	a0,a1
    80007ddc:	00813823          	sd	s0,16(sp)
    80007de0:	00113c23          	sd	ra,24(sp)
    80007de4:	00058413          	mv	s0,a1
    80007de8:	cb0ff0ef          	jal	ra,80007298 <rt_thread_suspend>
    80007dec:	04090063          	beqz	s2,80007e2c <rt_ipc_list_suspend.isra.0+0x68>
    80007df0:	00100793          	li	a5,1
    80007df4:	02f90863          	beq	s2,a5,80007e24 <rt_ipc_list_suspend.isra.0+0x60>
    80007df8:	01013403          	ld	s0,16(sp)
    80007dfc:	01813083          	ld	ra,24(sp)
    80007e00:	00813483          	ld	s1,8(sp)
    80007e04:	00013903          	ld	s2,0(sp)
    80007e08:	07f00613          	li	a2,127
    80007e0c:	0000a597          	auipc	a1,0xa
    80007e10:	c9458593          	addi	a1,a1,-876 # 80011aa0 <__FUNCTION__.32>
    80007e14:	00009517          	auipc	a0,0x9
    80007e18:	05c50513          	addi	a0,a0,92 # 80010e70 <__FUNCTION__.1+0x220>
    80007e1c:	02010113          	addi	sp,sp,32
    80007e20:	d55fe06f          	j	80006b74 <rt_assert_handler>
    80007e24:	0004b783          	ld	a5,0(s1)
    80007e28:	02f49063          	bne	s1,a5,80007e48 <rt_ipc_list_suspend.isra.0+0x84>
    80007e2c:	0084b703          	ld	a4,8(s1)
    80007e30:	02840793          	addi	a5,s0,40
    80007e34:	00f73023          	sd	a5,0(a4)
    80007e38:	02e43823          	sd	a4,48(s0)
    80007e3c:	00f4b423          	sd	a5,8(s1)
    80007e40:	02943423          	sd	s1,40(s0)
    80007e44:	0280006f          	j	80007e6c <rt_ipc_list_suspend.isra.0+0xa8>
    80007e48:	06944683          	lbu	a3,105(s0)
    80007e4c:	0417c703          	lbu	a4,65(a5)
    80007e50:	02e6fa63          	bgeu	a3,a4,80007e84 <rt_ipc_list_suspend.isra.0+0xc0>
    80007e54:	0087b683          	ld	a3,8(a5)
    80007e58:	02840713          	addi	a4,s0,40
    80007e5c:	00e6b023          	sd	a4,0(a3)
    80007e60:	02d43823          	sd	a3,48(s0)
    80007e64:	00e7b423          	sd	a4,8(a5)
    80007e68:	02f43423          	sd	a5,40(s0)
    80007e6c:	01813083          	ld	ra,24(sp)
    80007e70:	01013403          	ld	s0,16(sp)
    80007e74:	00813483          	ld	s1,8(sp)
    80007e78:	00013903          	ld	s2,0(sp)
    80007e7c:	02010113          	addi	sp,sp,32
    80007e80:	00008067          	ret
    80007e84:	0007b783          	ld	a5,0(a5)
    80007e88:	fa1ff06f          	j	80007e28 <rt_ipc_list_suspend.isra.0+0x64>

0000000080007e8c <rt_sem_init>:
    80007e8c:	fd010113          	addi	sp,sp,-48
    80007e90:	02813023          	sd	s0,32(sp)
    80007e94:	00913c23          	sd	s1,24(sp)
    80007e98:	01213823          	sd	s2,16(sp)
    80007e9c:	01313423          	sd	s3,8(sp)
    80007ea0:	02113423          	sd	ra,40(sp)
    80007ea4:	00050413          	mv	s0,a0
    80007ea8:	00058993          	mv	s3,a1
    80007eac:	00060493          	mv	s1,a2
    80007eb0:	00068913          	mv	s2,a3
    80007eb4:	00051e63          	bnez	a0,80007ed0 <rt_sem_init+0x44>
    80007eb8:	0d500613          	li	a2,213
    80007ebc:	0000a597          	auipc	a1,0xa
    80007ec0:	c0c58593          	addi	a1,a1,-1012 # 80011ac8 <__FUNCTION__.37>
    80007ec4:	0000a517          	auipc	a0,0xa
    80007ec8:	a2450513          	addi	a0,a0,-1500 # 800118e8 <__FUNCTION__.6+0x10>
    80007ecc:	ca9fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007ed0:	000107b7          	lui	a5,0x10
    80007ed4:	00f4ee63          	bltu	s1,a5,80007ef0 <rt_sem_init+0x64>
    80007ed8:	0d600613          	li	a2,214
    80007edc:	0000a597          	auipc	a1,0xa
    80007ee0:	bec58593          	addi	a1,a1,-1044 # 80011ac8 <__FUNCTION__.37>
    80007ee4:	0000a517          	auipc	a0,0xa
    80007ee8:	a1450513          	addi	a0,a0,-1516 # 800118f8 <__FUNCTION__.6+0x20>
    80007eec:	c89fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007ef0:	00040513          	mv	a0,s0
    80007ef4:	00098613          	mv	a2,s3
    80007ef8:	00200593          	li	a1,2
    80007efc:	a29ff0ef          	jal	ra,80007924 <rt_object_init>
    80007f00:	02840793          	addi	a5,s0,40
    80007f04:	02941c23          	sh	s1,56(s0)
    80007f08:	01240aa3          	sb	s2,21(s0)
    80007f0c:	02813083          	ld	ra,40(sp)
    80007f10:	02f43823          	sd	a5,48(s0)
    80007f14:	02f43423          	sd	a5,40(s0)
    80007f18:	02013403          	ld	s0,32(sp)
    80007f1c:	01813483          	ld	s1,24(sp)
    80007f20:	01013903          	ld	s2,16(sp)
    80007f24:	00813983          	ld	s3,8(sp)
    80007f28:	00000513          	li	a0,0
    80007f2c:	03010113          	addi	sp,sp,48
    80007f30:	00008067          	ret

0000000080007f34 <rt_sem_take>:
    80007f34:	fc010113          	addi	sp,sp,-64
    80007f38:	02813823          	sd	s0,48(sp)
    80007f3c:	02113c23          	sd	ra,56(sp)
    80007f40:	02913423          	sd	s1,40(sp)
    80007f44:	03213023          	sd	s2,32(sp)
    80007f48:	01313c23          	sd	s3,24(sp)
    80007f4c:	00b12623          	sw	a1,12(sp)
    80007f50:	00050413          	mv	s0,a0
    80007f54:	00051e63          	bnez	a0,80007f70 <rt_sem_take+0x3c>
    80007f58:	15300613          	li	a2,339
    80007f5c:	0000a597          	auipc	a1,0xa
    80007f60:	b5c58593          	addi	a1,a1,-1188 # 80011ab8 <__FUNCTION__.33>
    80007f64:	0000a517          	auipc	a0,0xa
    80007f68:	98450513          	addi	a0,a0,-1660 # 800118e8 <__FUNCTION__.6+0x10>
    80007f6c:	c09fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007f70:	00040513          	mv	a0,s0
    80007f74:	d31ff0ef          	jal	ra,80007ca4 <rt_object_get_type>
    80007f78:	00200793          	li	a5,2
    80007f7c:	00f50e63          	beq	a0,a5,80007f98 <rt_sem_take+0x64>
    80007f80:	15400613          	li	a2,340
    80007f84:	0000a597          	auipc	a1,0xa
    80007f88:	b3458593          	addi	a1,a1,-1228 # 80011ab8 <__FUNCTION__.33>
    80007f8c:	0000a517          	auipc	a0,0xa
    80007f90:	98450513          	addi	a0,a0,-1660 # 80011910 <__FUNCTION__.6+0x38>
    80007f94:	be1fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80007f98:	00016797          	auipc	a5,0x16
    80007f9c:	a287b783          	ld	a5,-1496(a5) # 8001d9c0 <rt_object_trytake_hook>
    80007fa0:	00078663          	beqz	a5,80007fac <rt_sem_take+0x78>
    80007fa4:	00040513          	mv	a0,s0
    80007fa8:	000780e7          	jalr	a5
    80007fac:	8a4f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80007fb0:	03845783          	lhu	a5,56(s0)
    80007fb4:	00050993          	mv	s3,a0
    80007fb8:	02078863          	beqz	a5,80007fe8 <rt_sem_take+0xb4>
    80007fbc:	fff7879b          	addiw	a5,a5,-1
    80007fc0:	02f41c23          	sh	a5,56(s0)
    80007fc4:	894f80ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80007fc8:	00016797          	auipc	a5,0x16
    80007fcc:	9f07b783          	ld	a5,-1552(a5) # 8001d9b8 <rt_object_take_hook>
    80007fd0:	00000513          	li	a0,0
    80007fd4:	02078263          	beqz	a5,80007ff8 <rt_sem_take+0xc4>
    80007fd8:	00040513          	mv	a0,s0
    80007fdc:	000780e7          	jalr	a5
    80007fe0:	00000513          	li	a0,0
    80007fe4:	0140006f          	j	80007ff8 <rt_sem_take+0xc4>
    80007fe8:	00c12783          	lw	a5,12(sp)
    80007fec:	02079463          	bnez	a5,80008014 <rt_sem_take+0xe0>
    80007ff0:	868f80ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80007ff4:	ffe00513          	li	a0,-2
    80007ff8:	03813083          	ld	ra,56(sp)
    80007ffc:	03013403          	ld	s0,48(sp)
    80008000:	02813483          	ld	s1,40(sp)
    80008004:	02013903          	ld	s2,32(sp)
    80008008:	01813983          	ld	s3,24(sp)
    8000800c:	04010113          	addi	sp,sp,64
    80008010:	00008067          	ret
    80008014:	83cf80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80008018:	00050493          	mv	s1,a0
    8000801c:	fe5fe0ef          	jal	ra,80007000 <rt_thread_self>
    80008020:	02051863          	bnez	a0,80008050 <rt_sem_take+0x11c>
    80008024:	0000a597          	auipc	a1,0xa
    80008028:	a9458593          	addi	a1,a1,-1388 # 80011ab8 <__FUNCTION__.33>
    8000802c:	0000a517          	auipc	a0,0xa
    80008030:	95c50513          	addi	a0,a0,-1700 # 80011988 <__FUNCTION__.6+0xb0>
    80008034:	9b9fe0ef          	jal	ra,800069ec <rt_kprintf>
    80008038:	17400613          	li	a2,372
    8000803c:	0000a597          	auipc	a1,0xa
    80008040:	a7c58593          	addi	a1,a1,-1412 # 80011ab8 <__FUNCTION__.33>
    80008044:	00009517          	auipc	a0,0x9
    80008048:	e2c50513          	addi	a0,a0,-468 # 80010e70 <__FUNCTION__.1+0x220>
    8000804c:	b29fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80008050:	800f80ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80008054:	00050913          	mv	s2,a0
    80008058:	c55fb0ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    8000805c:	02050863          	beqz	a0,8000808c <rt_sem_take+0x158>
    80008060:	0000a597          	auipc	a1,0xa
    80008064:	a5858593          	addi	a1,a1,-1448 # 80011ab8 <__FUNCTION__.33>
    80008068:	00009517          	auipc	a0,0x9
    8000806c:	de050513          	addi	a0,a0,-544 # 80010e48 <__FUNCTION__.1+0x1f8>
    80008070:	97dfe0ef          	jal	ra,800069ec <rt_kprintf>
    80008074:	17400613          	li	a2,372
    80008078:	0000a597          	auipc	a1,0xa
    8000807c:	a4058593          	addi	a1,a1,-1472 # 80011ab8 <__FUNCTION__.33>
    80008080:	00009517          	auipc	a0,0x9
    80008084:	df050513          	addi	a0,a0,-528 # 80010e70 <__FUNCTION__.1+0x220>
    80008088:	aedfe0ef          	jal	ra,80006b74 <rt_assert_handler>
    8000808c:	00090513          	mv	a0,s2
    80008090:	fc9f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80008094:	00048513          	mv	a0,s1
    80008098:	fc1f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000809c:	f65fe0ef          	jal	ra,80007000 <rt_thread_self>
    800080a0:	06053023          	sd	zero,96(a0)
    800080a4:	01544603          	lbu	a2,21(s0)
    800080a8:	00050593          	mv	a1,a0
    800080ac:	00050493          	mv	s1,a0
    800080b0:	02840513          	addi	a0,s0,40
    800080b4:	d11ff0ef          	jal	ra,80007dc4 <rt_ipc_list_suspend.isra.0>
    800080b8:	00c12783          	lw	a5,12(sp)
    800080bc:	02f05063          	blez	a5,800080dc <rt_sem_take+0x1a8>
    800080c0:	08848913          	addi	s2,s1,136
    800080c4:	00c10613          	addi	a2,sp,12
    800080c8:	00000593          	li	a1,0
    800080cc:	00090513          	mv	a0,s2
    800080d0:	fe1fb0ef          	jal	ra,800040b0 <rt_timer_control>
    800080d4:	00090513          	mv	a0,s2
    800080d8:	d91fb0ef          	jal	ra,80003e68 <rt_timer_start>
    800080dc:	00098513          	mv	a0,s3
    800080e0:	f79f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    800080e4:	e74fc0ef          	jal	ra,80004758 <rt_schedule>
    800080e8:	0604b503          	ld	a0,96(s1)
    800080ec:	ec050ee3          	beqz	a0,80007fc8 <rt_sem_take+0x94>
    800080f0:	f09ff06f          	j	80007ff8 <rt_sem_take+0xc4>

00000000800080f4 <rt_sem_release>:
    800080f4:	fd010113          	addi	sp,sp,-48
    800080f8:	02813023          	sd	s0,32(sp)
    800080fc:	02113423          	sd	ra,40(sp)
    80008100:	00913c23          	sd	s1,24(sp)
    80008104:	00050413          	mv	s0,a0
    80008108:	00051e63          	bnez	a0,80008124 <rt_sem_release+0x30>
    8000810c:	1c000613          	li	a2,448
    80008110:	0000a597          	auipc	a1,0xa
    80008114:	98058593          	addi	a1,a1,-1664 # 80011a90 <__FUNCTION__.31>
    80008118:	00009517          	auipc	a0,0x9
    8000811c:	7d050513          	addi	a0,a0,2000 # 800118e8 <__FUNCTION__.6+0x10>
    80008120:	a55fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80008124:	00040513          	mv	a0,s0
    80008128:	b7dff0ef          	jal	ra,80007ca4 <rt_object_get_type>
    8000812c:	00200793          	li	a5,2
    80008130:	00f50e63          	beq	a0,a5,8000814c <rt_sem_release+0x58>
    80008134:	1c100613          	li	a2,449
    80008138:	0000a597          	auipc	a1,0xa
    8000813c:	95858593          	addi	a1,a1,-1704 # 80011a90 <__FUNCTION__.31>
    80008140:	00009517          	auipc	a0,0x9
    80008144:	7d050513          	addi	a0,a0,2000 # 80011910 <__FUNCTION__.6+0x38>
    80008148:	a2dfe0ef          	jal	ra,80006b74 <rt_assert_handler>
    8000814c:	00016797          	auipc	a5,0x16
    80008150:	8647b783          	ld	a5,-1948(a5) # 8001d9b0 <rt_object_put_hook>
    80008154:	00078663          	beqz	a5,80008160 <rt_sem_release+0x6c>
    80008158:	00040513          	mv	a0,s0
    8000815c:	000780e7          	jalr	a5
    80008160:	ef1f70ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80008164:	02843783          	ld	a5,40(s0)
    80008168:	02840713          	addi	a4,s0,40
    8000816c:	00050493          	mv	s1,a0
    80008170:	02e78863          	beq	a5,a4,800081a0 <rt_sem_release+0xac>
    80008174:	00078513          	mv	a0,a5
    80008178:	c45ff0ef          	jal	ra,80007dbc <rt_ipc_list_resume.isra.0>
    8000817c:	00100413          	li	s0,1
    80008180:	00048513          	mv	a0,s1
    80008184:	ed5f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80008188:	00000513          	li	a0,0
    8000818c:	02040e63          	beqz	s0,800081c8 <rt_sem_release+0xd4>
    80008190:	00a13423          	sd	a0,8(sp)
    80008194:	dc4fc0ef          	jal	ra,80004758 <rt_schedule>
    80008198:	00813503          	ld	a0,8(sp)
    8000819c:	02c0006f          	j	800081c8 <rt_sem_release+0xd4>
    800081a0:	03845783          	lhu	a5,56(s0)
    800081a4:	00010737          	lui	a4,0x10
    800081a8:	fff70713          	addi	a4,a4,-1 # ffff <__STACKSIZE__+0xbfff>
    800081ac:	00e78a63          	beq	a5,a4,800081c0 <rt_sem_release+0xcc>
    800081b0:	0017879b          	addiw	a5,a5,1
    800081b4:	02f41c23          	sh	a5,56(s0)
    800081b8:	00000413          	li	s0,0
    800081bc:	fc5ff06f          	j	80008180 <rt_sem_release+0x8c>
    800081c0:	e99f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    800081c4:	ffd00513          	li	a0,-3
    800081c8:	02813083          	ld	ra,40(sp)
    800081cc:	02013403          	ld	s0,32(sp)
    800081d0:	01813483          	ld	s1,24(sp)
    800081d4:	03010113          	addi	sp,sp,48
    800081d8:	00008067          	ret

00000000800081dc <rt_mutex_init>:
    800081dc:	fe010113          	addi	sp,sp,-32
    800081e0:	00813823          	sd	s0,16(sp)
    800081e4:	00913423          	sd	s1,8(sp)
    800081e8:	00113c23          	sd	ra,24(sp)
    800081ec:	00050413          	mv	s0,a0
    800081f0:	00058493          	mv	s1,a1
    800081f4:	00051e63          	bnez	a0,80008210 <rt_mutex_init+0x34>
    800081f8:	22a00613          	li	a2,554
    800081fc:	0000a597          	auipc	a1,0xa
    80008200:	88458593          	addi	a1,a1,-1916 # 80011a80 <__FUNCTION__.29>
    80008204:	00009517          	auipc	a0,0x9
    80008208:	7bc50513          	addi	a0,a0,1980 # 800119c0 <__FUNCTION__.6+0xe8>
    8000820c:	969fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80008210:	00040513          	mv	a0,s0
    80008214:	00048613          	mv	a2,s1
    80008218:	00300593          	li	a1,3
    8000821c:	f08ff0ef          	jal	ra,80007924 <rt_object_init>
    80008220:	02840793          	addi	a5,s0,40
    80008224:	02f43823          	sd	a5,48(s0)
    80008228:	02f43423          	sd	a5,40(s0)
    8000822c:	00ff07b7          	lui	a5,0xff0
    80008230:	00178793          	addi	a5,a5,1 # ff0001 <__STACKSIZE__+0xfec001>
    80008234:	02f42c23          	sw	a5,56(s0)
    80008238:	00100793          	li	a5,1
    8000823c:	01813083          	ld	ra,24(sp)
    80008240:	04043023          	sd	zero,64(s0)
    80008244:	00f40aa3          	sb	a5,21(s0)
    80008248:	01013403          	ld	s0,16(sp)
    8000824c:	00813483          	ld	s1,8(sp)
    80008250:	00000513          	li	a0,0
    80008254:	02010113          	addi	sp,sp,32
    80008258:	00008067          	ret

000000008000825c <rt_mutex_take>:
    8000825c:	fc010113          	addi	sp,sp,-64
    80008260:	02813823          	sd	s0,48(sp)
    80008264:	02913423          	sd	s1,40(sp)
    80008268:	02113c23          	sd	ra,56(sp)
    8000826c:	03213023          	sd	s2,32(sp)
    80008270:	01313c23          	sd	s3,24(sp)
    80008274:	00050413          	mv	s0,a0
    80008278:	00b12623          	sw	a1,12(sp)
    8000827c:	dd5f70ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80008280:	00050493          	mv	s1,a0
    80008284:	d7dfe0ef          	jal	ra,80007000 <rt_thread_self>
    80008288:	02051863          	bnez	a0,800082b8 <rt_mutex_take+0x5c>
    8000828c:	00009597          	auipc	a1,0x9
    80008290:	7e458593          	addi	a1,a1,2020 # 80011a70 <__FUNCTION__.25>
    80008294:	00009517          	auipc	a0,0x9
    80008298:	6f450513          	addi	a0,a0,1780 # 80011988 <__FUNCTION__.6+0xb0>
    8000829c:	f50fe0ef          	jal	ra,800069ec <rt_kprintf>
    800082a0:	2aa00613          	li	a2,682
    800082a4:	00009597          	auipc	a1,0x9
    800082a8:	7cc58593          	addi	a1,a1,1996 # 80011a70 <__FUNCTION__.25>
    800082ac:	00009517          	auipc	a0,0x9
    800082b0:	bc450513          	addi	a0,a0,-1084 # 80010e70 <__FUNCTION__.1+0x220>
    800082b4:	8c1fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    800082b8:	d99f70ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    800082bc:	00050913          	mv	s2,a0
    800082c0:	9edfb0ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    800082c4:	02050863          	beqz	a0,800082f4 <rt_mutex_take+0x98>
    800082c8:	00009597          	auipc	a1,0x9
    800082cc:	7a858593          	addi	a1,a1,1960 # 80011a70 <__FUNCTION__.25>
    800082d0:	00009517          	auipc	a0,0x9
    800082d4:	b7850513          	addi	a0,a0,-1160 # 80010e48 <__FUNCTION__.1+0x1f8>
    800082d8:	f14fe0ef          	jal	ra,800069ec <rt_kprintf>
    800082dc:	2aa00613          	li	a2,682
    800082e0:	00009597          	auipc	a1,0x9
    800082e4:	79058593          	addi	a1,a1,1936 # 80011a70 <__FUNCTION__.25>
    800082e8:	00009517          	auipc	a0,0x9
    800082ec:	b8850513          	addi	a0,a0,-1144 # 80010e70 <__FUNCTION__.1+0x220>
    800082f0:	885fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    800082f4:	00090513          	mv	a0,s2
    800082f8:	d61f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    800082fc:	00048513          	mv	a0,s1
    80008300:	d59f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80008304:	00041e63          	bnez	s0,80008320 <rt_mutex_take+0xc4>
    80008308:	2ad00613          	li	a2,685
    8000830c:	00009597          	auipc	a1,0x9
    80008310:	76458593          	addi	a1,a1,1892 # 80011a70 <__FUNCTION__.25>
    80008314:	00009517          	auipc	a0,0x9
    80008318:	6ac50513          	addi	a0,a0,1708 # 800119c0 <__FUNCTION__.6+0xe8>
    8000831c:	859fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80008320:	00040513          	mv	a0,s0
    80008324:	981ff0ef          	jal	ra,80007ca4 <rt_object_get_type>
    80008328:	00300793          	li	a5,3
    8000832c:	00f50e63          	beq	a0,a5,80008348 <rt_mutex_take+0xec>
    80008330:	2ae00613          	li	a2,686
    80008334:	00009597          	auipc	a1,0x9
    80008338:	73c58593          	addi	a1,a1,1852 # 80011a70 <__FUNCTION__.25>
    8000833c:	00009517          	auipc	a0,0x9
    80008340:	69c50513          	addi	a0,a0,1692 # 800119d8 <__FUNCTION__.6+0x100>
    80008344:	831fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80008348:	cb9fe0ef          	jal	ra,80007000 <rt_thread_self>
    8000834c:	00050493          	mv	s1,a0
    80008350:	d01f70ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80008354:	00015797          	auipc	a5,0x15
    80008358:	66c7b783          	ld	a5,1644(a5) # 8001d9c0 <rt_object_trytake_hook>
    8000835c:	00050913          	mv	s2,a0
    80008360:	00078663          	beqz	a5,8000836c <rt_mutex_take+0x110>
    80008364:	00040513          	mv	a0,s0
    80008368:	000780e7          	jalr	a5
    8000836c:	04043503          	ld	a0,64(s0)
    80008370:	0604b023          	sd	zero,96(s1)
    80008374:	04951063          	bne	a0,s1,800083b4 <rt_mutex_take+0x158>
    80008378:	03b44783          	lbu	a5,59(s0)
    8000837c:	0ff00713          	li	a4,255
    80008380:	04e78a63          	beq	a5,a4,800083d4 <rt_mutex_take+0x178>
    80008384:	0017879b          	addiw	a5,a5,1
    80008388:	02f40da3          	sb	a5,59(s0)
    8000838c:	00090513          	mv	a0,s2
    80008390:	cc9f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80008394:	00015797          	auipc	a5,0x15
    80008398:	6247b783          	ld	a5,1572(a5) # 8001d9b8 <rt_object_take_hook>
    8000839c:	00000513          	li	a0,0
    800083a0:	04078063          	beqz	a5,800083e0 <rt_mutex_take+0x184>
    800083a4:	00040513          	mv	a0,s0
    800083a8:	000780e7          	jalr	a5
    800083ac:	00000513          	li	a0,0
    800083b0:	0300006f          	j	800083e0 <rt_mutex_take+0x184>
    800083b4:	03845783          	lhu	a5,56(s0)
    800083b8:	04078263          	beqz	a5,800083fc <rt_mutex_take+0x1a0>
    800083bc:	fff7879b          	addiw	a5,a5,-1
    800083c0:	02f41c23          	sh	a5,56(s0)
    800083c4:	04943023          	sd	s1,64(s0)
    800083c8:	0694c783          	lbu	a5,105(s1)
    800083cc:	02f40d23          	sb	a5,58(s0)
    800083d0:	fa9ff06f          	j	80008378 <rt_mutex_take+0x11c>
    800083d4:	00090513          	mv	a0,s2
    800083d8:	c81f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    800083dc:	ffd00513          	li	a0,-3
    800083e0:	03813083          	ld	ra,56(sp)
    800083e4:	03013403          	ld	s0,48(sp)
    800083e8:	02813483          	ld	s1,40(sp)
    800083ec:	02013903          	ld	s2,32(sp)
    800083f0:	01813983          	ld	s3,24(sp)
    800083f4:	04010113          	addi	sp,sp,64
    800083f8:	00008067          	ret
    800083fc:	00c12783          	lw	a5,12(sp)
    80008400:	00079e63          	bnez	a5,8000841c <rt_mutex_take+0x1c0>
    80008404:	ffe00793          	li	a5,-2
    80008408:	00090513          	mv	a0,s2
    8000840c:	06f4b023          	sd	a5,96(s1)
    80008410:	c49f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80008414:	ffe00513          	li	a0,-2
    80008418:	fc9ff06f          	j	800083e0 <rt_mutex_take+0x184>
    8000841c:	0694c703          	lbu	a4,105(s1)
    80008420:	06954783          	lbu	a5,105(a0)
    80008424:	00f77863          	bgeu	a4,a5,80008434 <rt_mutex_take+0x1d8>
    80008428:	06948613          	addi	a2,s1,105
    8000842c:	00200593          	li	a1,2
    80008430:	9ecff0ef          	jal	ra,8000761c <rt_thread_control>
    80008434:	01544603          	lbu	a2,21(s0)
    80008438:	00048593          	mv	a1,s1
    8000843c:	02840513          	addi	a0,s0,40
    80008440:	985ff0ef          	jal	ra,80007dc4 <rt_ipc_list_suspend.isra.0>
    80008444:	00c12783          	lw	a5,12(sp)
    80008448:	02f05063          	blez	a5,80008468 <rt_mutex_take+0x20c>
    8000844c:	08848993          	addi	s3,s1,136
    80008450:	00c10613          	addi	a2,sp,12
    80008454:	00000593          	li	a1,0
    80008458:	00098513          	mv	a0,s3
    8000845c:	c55fb0ef          	jal	ra,800040b0 <rt_timer_control>
    80008460:	00098513          	mv	a0,s3
    80008464:	a05fb0ef          	jal	ra,80003e68 <rt_timer_start>
    80008468:	00090513          	mv	a0,s2
    8000846c:	bedf70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80008470:	ae8fc0ef          	jal	ra,80004758 <rt_schedule>
    80008474:	0604b503          	ld	a0,96(s1)
    80008478:	f60514e3          	bnez	a0,800083e0 <rt_mutex_take+0x184>
    8000847c:	bd5f70ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80008480:	00050913          	mv	s2,a0
    80008484:	f09ff06f          	j	8000838c <rt_mutex_take+0x130>

0000000080008488 <rt_mutex_release>:
    80008488:	fd010113          	addi	sp,sp,-48
    8000848c:	02813023          	sd	s0,32(sp)
    80008490:	02113423          	sd	ra,40(sp)
    80008494:	00913c23          	sd	s1,24(sp)
    80008498:	01213823          	sd	s2,16(sp)
    8000849c:	00050413          	mv	s0,a0
    800084a0:	00051e63          	bnez	a0,800084bc <rt_mutex_release+0x34>
    800084a4:	35400613          	li	a2,852
    800084a8:	00009597          	auipc	a1,0x9
    800084ac:	5b058593          	addi	a1,a1,1456 # 80011a58 <__FUNCTION__.24>
    800084b0:	00009517          	auipc	a0,0x9
    800084b4:	51050513          	addi	a0,a0,1296 # 800119c0 <__FUNCTION__.6+0xe8>
    800084b8:	ebcfe0ef          	jal	ra,80006b74 <rt_assert_handler>
    800084bc:	00040513          	mv	a0,s0
    800084c0:	fe4ff0ef          	jal	ra,80007ca4 <rt_object_get_type>
    800084c4:	00300793          	li	a5,3
    800084c8:	00f50e63          	beq	a0,a5,800084e4 <rt_mutex_release+0x5c>
    800084cc:	35500613          	li	a2,853
    800084d0:	00009597          	auipc	a1,0x9
    800084d4:	58858593          	addi	a1,a1,1416 # 80011a58 <__FUNCTION__.24>
    800084d8:	00009517          	auipc	a0,0x9
    800084dc:	50050513          	addi	a0,a0,1280 # 800119d8 <__FUNCTION__.6+0x100>
    800084e0:	e94fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    800084e4:	b6df70ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    800084e8:	00050493          	mv	s1,a0
    800084ec:	b15fe0ef          	jal	ra,80007000 <rt_thread_self>
    800084f0:	02051863          	bnez	a0,80008520 <rt_mutex_release+0x98>
    800084f4:	00009597          	auipc	a1,0x9
    800084f8:	56458593          	addi	a1,a1,1380 # 80011a58 <__FUNCTION__.24>
    800084fc:	00009517          	auipc	a0,0x9
    80008500:	48c50513          	addi	a0,a0,1164 # 80011988 <__FUNCTION__.6+0xb0>
    80008504:	ce8fe0ef          	jal	ra,800069ec <rt_kprintf>
    80008508:	35a00613          	li	a2,858
    8000850c:	00009597          	auipc	a1,0x9
    80008510:	54c58593          	addi	a1,a1,1356 # 80011a58 <__FUNCTION__.24>
    80008514:	00009517          	auipc	a0,0x9
    80008518:	95c50513          	addi	a0,a0,-1700 # 80010e70 <__FUNCTION__.1+0x220>
    8000851c:	e58fe0ef          	jal	ra,80006b74 <rt_assert_handler>
    80008520:	b31f70ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80008524:	00050913          	mv	s2,a0
    80008528:	f84fb0ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    8000852c:	02050863          	beqz	a0,8000855c <rt_mutex_release+0xd4>
    80008530:	00009597          	auipc	a1,0x9
    80008534:	52858593          	addi	a1,a1,1320 # 80011a58 <__FUNCTION__.24>
    80008538:	00009517          	auipc	a0,0x9
    8000853c:	91050513          	addi	a0,a0,-1776 # 80010e48 <__FUNCTION__.1+0x1f8>
    80008540:	cacfe0ef          	jal	ra,800069ec <rt_kprintf>
    80008544:	35a00613          	li	a2,858
    80008548:	00009597          	auipc	a1,0x9
    8000854c:	51058593          	addi	a1,a1,1296 # 80011a58 <__FUNCTION__.24>
    80008550:	00009517          	auipc	a0,0x9
    80008554:	92050513          	addi	a0,a0,-1760 # 80010e70 <__FUNCTION__.1+0x220>
    80008558:	e1cfe0ef          	jal	ra,80006b74 <rt_assert_handler>
    8000855c:	00090513          	mv	a0,s2
    80008560:	af9f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80008564:	00048513          	mv	a0,s1
    80008568:	af1f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000856c:	a95fe0ef          	jal	ra,80007000 <rt_thread_self>
    80008570:	00050913          	mv	s2,a0
    80008574:	addf70ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80008578:	00015797          	auipc	a5,0x15
    8000857c:	4387b783          	ld	a5,1080(a5) # 8001d9b0 <rt_object_put_hook>
    80008580:	00050493          	mv	s1,a0
    80008584:	00078663          	beqz	a5,80008590 <rt_mutex_release+0x108>
    80008588:	00040513          	mv	a0,s0
    8000858c:	000780e7          	jalr	a5
    80008590:	04043783          	ld	a5,64(s0)
    80008594:	03278863          	beq	a5,s2,800085c4 <rt_mutex_release+0x13c>
    80008598:	fff00793          	li	a5,-1
    8000859c:	00048513          	mv	a0,s1
    800085a0:	06f93023          	sd	a5,96(s2)
    800085a4:	ab5f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    800085a8:	fff00513          	li	a0,-1
    800085ac:	02813083          	ld	ra,40(sp)
    800085b0:	02013403          	ld	s0,32(sp)
    800085b4:	01813483          	ld	s1,24(sp)
    800085b8:	01013903          	ld	s2,16(sp)
    800085bc:	03010113          	addi	sp,sp,48
    800085c0:	00008067          	ret
    800085c4:	03b44783          	lbu	a5,59(s0)
    800085c8:	fff7879b          	addiw	a5,a5,-1
    800085cc:	0ff7f793          	zext.b	a5,a5
    800085d0:	02f40da3          	sb	a5,59(s0)
    800085d4:	08079e63          	bnez	a5,80008670 <rt_mutex_release+0x1e8>
    800085d8:	03a44703          	lbu	a4,58(s0)
    800085dc:	06994783          	lbu	a5,105(s2)
    800085e0:	00f70a63          	beq	a4,a5,800085f4 <rt_mutex_release+0x16c>
    800085e4:	03a40613          	addi	a2,s0,58
    800085e8:	00200593          	li	a1,2
    800085ec:	00090513          	mv	a0,s2
    800085f0:	82cff0ef          	jal	ra,8000761c <rt_thread_control>
    800085f4:	02843503          	ld	a0,40(s0)
    800085f8:	02840793          	addi	a5,s0,40
    800085fc:	04f50863          	beq	a0,a5,8000864c <rt_mutex_release+0x1c4>
    80008600:	fd850793          	addi	a5,a0,-40
    80008604:	04f43023          	sd	a5,64(s0)
    80008608:	04154783          	lbu	a5,65(a0)
    8000860c:	0ff00713          	li	a4,255
    80008610:	02f40d23          	sb	a5,58(s0)
    80008614:	03b44783          	lbu	a5,59(s0)
    80008618:	06e78063          	beq	a5,a4,80008678 <rt_mutex_release+0x1f0>
    8000861c:	0017879b          	addiw	a5,a5,1
    80008620:	02f40da3          	sb	a5,59(s0)
    80008624:	f98ff0ef          	jal	ra,80007dbc <rt_ipc_list_resume.isra.0>
    80008628:	00100413          	li	s0,1
    8000862c:	00048513          	mv	a0,s1
    80008630:	a29f70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80008634:	00000513          	li	a0,0
    80008638:	f6040ae3          	beqz	s0,800085ac <rt_mutex_release+0x124>
    8000863c:	00a13423          	sd	a0,8(sp)
    80008640:	918fc0ef          	jal	ra,80004758 <rt_schedule>
    80008644:	00813503          	ld	a0,8(sp)
    80008648:	f65ff06f          	j	800085ac <rt_mutex_release+0x124>
    8000864c:	03845783          	lhu	a5,56(s0)
    80008650:	00010737          	lui	a4,0x10
    80008654:	fff70713          	addi	a4,a4,-1 # ffff <__STACKSIZE__+0xbfff>
    80008658:	02e78063          	beq	a5,a4,80008678 <rt_mutex_release+0x1f0>
    8000865c:	0017879b          	addiw	a5,a5,1
    80008660:	02f41c23          	sh	a5,56(s0)
    80008664:	fff00793          	li	a5,-1
    80008668:	04043023          	sd	zero,64(s0)
    8000866c:	02f40d23          	sb	a5,58(s0)
    80008670:	00000413          	li	s0,0
    80008674:	fb9ff06f          	j	8000862c <rt_mutex_release+0x1a4>
    80008678:	00048513          	mv	a0,s1
    8000867c:	9ddf70ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    80008680:	ffd00513          	li	a0,-3
    80008684:	f29ff06f          	j	800085ac <rt_mutex_release+0x124>

0000000080008688 <rt_hw_stack_init>:
    80008688:	00860613          	addi	a2,a2,8
    8000868c:	ff867613          	andi	a2,a2,-8
    80008690:	37ab77b7          	lui	a5,0x37ab7
    80008694:	00050813          	mv	a6,a0
    80008698:	00279793          	slli	a5,a5,0x2
    8000869c:	ef860513          	addi	a0,a2,-264
    800086a0:	00050713          	mv	a4,a0
    800086a4:	eef78793          	addi	a5,a5,-273 # 37ab6eef <__STACKSIZE__+0x37ab2eef>
    800086a8:	00f73023          	sd	a5,0(a4)
    800086ac:	00870713          	addi	a4,a4,8
    800086b0:	fee61ce3          	bne	a2,a4,800086a8 <rt_hw_stack_init+0x20>
    800086b4:	00018793          	mv	a5,gp
    800086b8:	f0f63823          	sd	a5,-240(a2)
    800086bc:	10850793          	addi	a5,a0,264
    800086c0:	fef63c23          	sd	a5,-8(a2)
    800086c4:	000087b7          	lui	a5,0x8
    800086c8:	88078793          	addi	a5,a5,-1920 # 7880 <__STACKSIZE__+0x3880>
    800086cc:	f0d63023          	sd	a3,-256(a2)
    800086d0:	f4b63423          	sd	a1,-184(a2)
    800086d4:	ef063c23          	sd	a6,-264(a2)
    800086d8:	f0f63423          	sd	a5,-248(a2)
    800086dc:	00008067          	ret

00000000800086e0 <rt_hw_context_switch_interrupt>:
    800086e0:	00015797          	auipc	a5,0x15
    800086e4:	2f878793          	addi	a5,a5,760 # 8001d9d8 <rt_thread_switch_interrupt_flag>
    800086e8:	0007b703          	ld	a4,0(a5)
    800086ec:	00071663          	bnez	a4,800086f8 <rt_hw_context_switch_interrupt+0x18>
    800086f0:	00015717          	auipc	a4,0x15
    800086f4:	2ca73c23          	sd	a0,728(a4) # 8001d9c8 <rt_interrupt_from_thread>
    800086f8:	00015717          	auipc	a4,0x15
    800086fc:	2cb73c23          	sd	a1,728(a4) # 8001d9d0 <rt_interrupt_to_thread>
    80008700:	00100713          	li	a4,1
    80008704:	00e7b023          	sd	a4,0(a5)
    80008708:	00008067          	ret

000000008000870c <rt_hw_interrupt_handle>:
    8000870c:	ff010113          	addi	sp,sp,-16
    80008710:	00050593          	mv	a1,a0
    80008714:	00009517          	auipc	a0,0x9
    80008718:	3c450513          	addi	a0,a0,964 # 80011ad8 <__FUNCTION__.37+0x10>
    8000871c:	00113423          	sd	ra,8(sp)
    80008720:	accfe0ef          	jal	ra,800069ec <rt_kprintf>
    80008724:	00813083          	ld	ra,8(sp)
    80008728:	00000513          	li	a0,0
    8000872c:	01010113          	addi	sp,sp,16
    80008730:	00008067          	ret

0000000080008734 <rt_hw_interrupt_init>:
    80008734:	0001e797          	auipc	a5,0x1e
    80008738:	90478793          	addi	a5,a5,-1788 # 80026038 <irq_desc>
    8000873c:	0001e717          	auipc	a4,0x1e
    80008740:	0fc70713          	addi	a4,a4,252 # 80026838 <finsh_prompt.8>
    80008744:	00000697          	auipc	a3,0x0
    80008748:	fc868693          	addi	a3,a3,-56 # 8000870c <rt_hw_interrupt_handle>
    8000874c:	00d7b023          	sd	a3,0(a5)
    80008750:	0007b423          	sd	zero,8(a5)
    80008754:	01078793          	addi	a5,a5,16
    80008758:	fee79ae3          	bne	a5,a4,8000874c <rt_hw_interrupt_init+0x18>
    8000875c:	00008067          	ret

0000000080008760 <dump_regs>:
    80008760:	ff010113          	addi	sp,sp,-16
    80008764:	00813023          	sd	s0,0(sp)
    80008768:	00050413          	mv	s0,a0
    8000876c:	00009517          	auipc	a0,0x9
    80008770:	52c50513          	addi	a0,a0,1324 # 80011c98 <__FUNCTION__.37+0x1d0>
    80008774:	00113423          	sd	ra,8(sp)
    80008778:	a74fe0ef          	jal	ra,800069ec <rt_kprintf>
    8000877c:	00009517          	auipc	a0,0x9
    80008780:	54c50513          	addi	a0,a0,1356 # 80011cc8 <__FUNCTION__.37+0x200>
    80008784:	a68fe0ef          	jal	ra,800069ec <rt_kprintf>
    80008788:	10043603          	ld	a2,256(s0)
    8000878c:	00843583          	ld	a1,8(s0)
    80008790:	00009517          	auipc	a0,0x9
    80008794:	55050513          	addi	a0,a0,1360 # 80011ce0 <__FUNCTION__.37+0x218>
    80008798:	a54fe0ef          	jal	ra,800069ec <rt_kprintf>
    8000879c:	02043603          	ld	a2,32(s0)
    800087a0:	01843583          	ld	a1,24(s0)
    800087a4:	00009517          	auipc	a0,0x9
    800087a8:	55c50513          	addi	a0,a0,1372 # 80011d00 <__FUNCTION__.37+0x238>
    800087ac:	a40fe0ef          	jal	ra,800069ec <rt_kprintf>
    800087b0:	00009517          	auipc	a0,0x9
    800087b4:	57050513          	addi	a0,a0,1392 # 80011d20 <__FUNCTION__.37+0x258>
    800087b8:	a34fe0ef          	jal	ra,800069ec <rt_kprintf>
    800087bc:	03043603          	ld	a2,48(s0)
    800087c0:	02843583          	ld	a1,40(s0)
    800087c4:	00009517          	auipc	a0,0x9
    800087c8:	57450513          	addi	a0,a0,1396 # 80011d38 <__FUNCTION__.37+0x270>
    800087cc:	a20fe0ef          	jal	ra,800069ec <rt_kprintf>
    800087d0:	03843583          	ld	a1,56(s0)
    800087d4:	00009517          	auipc	a0,0x9
    800087d8:	58450513          	addi	a0,a0,1412 # 80011d58 <__FUNCTION__.37+0x290>
    800087dc:	a10fe0ef          	jal	ra,800069ec <rt_kprintf>
    800087e0:	0e843603          	ld	a2,232(s0)
    800087e4:	0e043583          	ld	a1,224(s0)
    800087e8:	00009517          	auipc	a0,0x9
    800087ec:	58050513          	addi	a0,a0,1408 # 80011d68 <__FUNCTION__.37+0x2a0>
    800087f0:	9fcfe0ef          	jal	ra,800069ec <rt_kprintf>
    800087f4:	0f843603          	ld	a2,248(s0)
    800087f8:	0f043583          	ld	a1,240(s0)
    800087fc:	00009517          	auipc	a0,0x9
    80008800:	58c50513          	addi	a0,a0,1420 # 80011d88 <__FUNCTION__.37+0x2c0>
    80008804:	9e8fe0ef          	jal	ra,800069ec <rt_kprintf>
    80008808:	00009517          	auipc	a0,0x9
    8000880c:	5a050513          	addi	a0,a0,1440 # 80011da8 <__FUNCTION__.37+0x2e0>
    80008810:	9dcfe0ef          	jal	ra,800069ec <rt_kprintf>
    80008814:	04843603          	ld	a2,72(s0)
    80008818:	04043583          	ld	a1,64(s0)
    8000881c:	00009517          	auipc	a0,0x9
    80008820:	5a450513          	addi	a0,a0,1444 # 80011dc0 <__FUNCTION__.37+0x2f8>
    80008824:	9c8fe0ef          	jal	ra,800069ec <rt_kprintf>
    80008828:	09843603          	ld	a2,152(s0)
    8000882c:	09043583          	ld	a1,144(s0)
    80008830:	00009517          	auipc	a0,0x9
    80008834:	5b850513          	addi	a0,a0,1464 # 80011de8 <__FUNCTION__.37+0x320>
    80008838:	9b4fe0ef          	jal	ra,800069ec <rt_kprintf>
    8000883c:	0a843603          	ld	a2,168(s0)
    80008840:	0a043583          	ld	a1,160(s0)
    80008844:	00009517          	auipc	a0,0x9
    80008848:	5c450513          	addi	a0,a0,1476 # 80011e08 <__FUNCTION__.37+0x340>
    8000884c:	9a0fe0ef          	jal	ra,800069ec <rt_kprintf>
    80008850:	0b843603          	ld	a2,184(s0)
    80008854:	0b043583          	ld	a1,176(s0)
    80008858:	00009517          	auipc	a0,0x9
    8000885c:	5d050513          	addi	a0,a0,1488 # 80011e28 <__FUNCTION__.37+0x360>
    80008860:	98cfe0ef          	jal	ra,800069ec <rt_kprintf>
    80008864:	0c843603          	ld	a2,200(s0)
    80008868:	0c043583          	ld	a1,192(s0)
    8000886c:	00009517          	auipc	a0,0x9
    80008870:	5dc50513          	addi	a0,a0,1500 # 80011e48 <__FUNCTION__.37+0x380>
    80008874:	978fe0ef          	jal	ra,800069ec <rt_kprintf>
    80008878:	0d843603          	ld	a2,216(s0)
    8000887c:	0d043583          	ld	a1,208(s0)
    80008880:	00009517          	auipc	a0,0x9
    80008884:	5e850513          	addi	a0,a0,1512 # 80011e68 <__FUNCTION__.37+0x3a0>
    80008888:	964fe0ef          	jal	ra,800069ec <rt_kprintf>
    8000888c:	00009517          	auipc	a0,0x9
    80008890:	60450513          	addi	a0,a0,1540 # 80011e90 <__FUNCTION__.37+0x3c8>
    80008894:	958fe0ef          	jal	ra,800069ec <rt_kprintf>
    80008898:	05843603          	ld	a2,88(s0)
    8000889c:	05043583          	ld	a1,80(s0)
    800088a0:	00009517          	auipc	a0,0x9
    800088a4:	61050513          	addi	a0,a0,1552 # 80011eb0 <__FUNCTION__.37+0x3e8>
    800088a8:	944fe0ef          	jal	ra,800069ec <rt_kprintf>
    800088ac:	06843603          	ld	a2,104(s0)
    800088b0:	06043583          	ld	a1,96(s0)
    800088b4:	00009517          	auipc	a0,0x9
    800088b8:	61c50513          	addi	a0,a0,1564 # 80011ed0 <__FUNCTION__.37+0x408>
    800088bc:	930fe0ef          	jal	ra,800069ec <rt_kprintf>
    800088c0:	07843603          	ld	a2,120(s0)
    800088c4:	07043583          	ld	a1,112(s0)
    800088c8:	00009517          	auipc	a0,0x9
    800088cc:	62850513          	addi	a0,a0,1576 # 80011ef0 <__FUNCTION__.37+0x428>
    800088d0:	91cfe0ef          	jal	ra,800069ec <rt_kprintf>
    800088d4:	08843603          	ld	a2,136(s0)
    800088d8:	08043583          	ld	a1,128(s0)
    800088dc:	00009517          	auipc	a0,0x9
    800088e0:	63450513          	addi	a0,a0,1588 # 80011f10 <__FUNCTION__.37+0x448>
    800088e4:	908fe0ef          	jal	ra,800069ec <rt_kprintf>
    800088e8:	01043583          	ld	a1,16(s0)
    800088ec:	00009517          	auipc	a0,0x9
    800088f0:	64450513          	addi	a0,a0,1604 # 80011f30 <__FUNCTION__.37+0x468>
    800088f4:	8f8fe0ef          	jal	ra,800069ec <rt_kprintf>
    800088f8:	01043783          	ld	a5,16(s0)
    800088fc:	00009597          	auipc	a1,0x9
    80008900:	22458593          	addi	a1,a1,548 # 80011b20 <__FUNCTION__.37+0x58>
    80008904:	0027f793          	andi	a5,a5,2
    80008908:	00078663          	beqz	a5,80008914 <dump_regs+0x1b4>
    8000890c:	00009597          	auipc	a1,0x9
    80008910:	1f458593          	addi	a1,a1,500 # 80011b00 <__FUNCTION__.37+0x38>
    80008914:	00009517          	auipc	a0,0x9
    80008918:	62c50513          	addi	a0,a0,1580 # 80011f40 <__FUNCTION__.37+0x478>
    8000891c:	8d0fe0ef          	jal	ra,800069ec <rt_kprintf>
    80008920:	01043783          	ld	a5,16(s0)
    80008924:	00009597          	auipc	a1,0x9
    80008928:	21c58593          	addi	a1,a1,540 # 80011b40 <__FUNCTION__.37+0x78>
    8000892c:	0207f793          	andi	a5,a5,32
    80008930:	00079663          	bnez	a5,8000893c <dump_regs+0x1dc>
    80008934:	00009597          	auipc	a1,0x9
    80008938:	23458593          	addi	a1,a1,564 # 80011b68 <__FUNCTION__.37+0xa0>
    8000893c:	00009517          	auipc	a0,0x9
    80008940:	60450513          	addi	a0,a0,1540 # 80011f40 <__FUNCTION__.37+0x478>
    80008944:	8a8fe0ef          	jal	ra,800069ec <rt_kprintf>
    80008948:	01043783          	ld	a5,16(s0)
    8000894c:	00009597          	auipc	a1,0x9
    80008950:	24458593          	addi	a1,a1,580 # 80011b90 <__FUNCTION__.37+0xc8>
    80008954:	1007f793          	andi	a5,a5,256
    80008958:	00079663          	bnez	a5,80008964 <dump_regs+0x204>
    8000895c:	00009597          	auipc	a1,0x9
    80008960:	25c58593          	addi	a1,a1,604 # 80011bb8 <__FUNCTION__.37+0xf0>
    80008964:	00009517          	auipc	a0,0x9
    80008968:	5dc50513          	addi	a0,a0,1500 # 80011f40 <__FUNCTION__.37+0x478>
    8000896c:	880fe0ef          	jal	ra,800069ec <rt_kprintf>
    80008970:	01043703          	ld	a4,16(s0)
    80008974:	000407b7          	lui	a5,0x40
    80008978:	00009597          	auipc	a1,0x9
    8000897c:	26058593          	addi	a1,a1,608 # 80011bd8 <__FUNCTION__.37+0x110>
    80008980:	00e7f7b3          	and	a5,a5,a4
    80008984:	00079663          	bnez	a5,80008990 <dump_regs+0x230>
    80008988:	00009597          	auipc	a1,0x9
    8000898c:	27058593          	addi	a1,a1,624 # 80011bf8 <__FUNCTION__.37+0x130>
    80008990:	00009517          	auipc	a0,0x9
    80008994:	5b050513          	addi	a0,a0,1456 # 80011f40 <__FUNCTION__.37+0x478>
    80008998:	854fe0ef          	jal	ra,800069ec <rt_kprintf>
    8000899c:	01043703          	ld	a4,16(s0)
    800089a0:	000807b7          	lui	a5,0x80
    800089a4:	00009597          	auipc	a1,0x9
    800089a8:	27458593          	addi	a1,a1,628 # 80011c18 <__FUNCTION__.37+0x150>
    800089ac:	00e7f7b3          	and	a5,a5,a4
    800089b0:	00079663          	bnez	a5,800089bc <dump_regs+0x25c>
    800089b4:	00009597          	auipc	a1,0x9
    800089b8:	28c58593          	addi	a1,a1,652 # 80011c40 <__FUNCTION__.37+0x178>
    800089bc:	00009517          	auipc	a0,0x9
    800089c0:	58450513          	addi	a0,a0,1412 # 80011f40 <__FUNCTION__.37+0x478>
    800089c4:	828fe0ef          	jal	ra,800069ec <rt_kprintf>
    800089c8:	18002473          	csrr	s0,satp
    800089cc:	00009517          	auipc	a0,0x9
    800089d0:	57c50513          	addi	a0,a0,1404 # 80011f48 <__FUNCTION__.37+0x480>
    800089d4:	00040593          	mv	a1,s0
    800089d8:	814fe0ef          	jal	ra,800069ec <rt_kprintf>
    800089dc:	03c45413          	srli	s0,s0,0x3c
    800089e0:	00900793          	li	a5,9
    800089e4:	00009597          	auipc	a1,0x9
    800089e8:	28458593          	addi	a1,a1,644 # 80011c68 <__FUNCTION__.37+0x1a0>
    800089ec:	0087ec63          	bltu	a5,s0,80008a04 <dump_regs+0x2a4>
    800089f0:	0000a597          	auipc	a1,0xa
    800089f4:	83858593          	addi	a1,a1,-1992 # 80012228 <CSWTCH.17>
    800089f8:	00341413          	slli	s0,s0,0x3
    800089fc:	00858433          	add	s0,a1,s0
    80008a00:	00043583          	ld	a1,0(s0)
    80008a04:	00009517          	auipc	a0,0x9
    80008a08:	55450513          	addi	a0,a0,1364 # 80011f58 <__FUNCTION__.37+0x490>
    80008a0c:	fe1fd0ef          	jal	ra,800069ec <rt_kprintf>
    80008a10:	00013403          	ld	s0,0(sp)
    80008a14:	00813083          	ld	ra,8(sp)
    80008a18:	00009517          	auipc	a0,0x9
    80008a1c:	55050513          	addi	a0,a0,1360 # 80011f68 <__FUNCTION__.37+0x4a0>
    80008a20:	01010113          	addi	sp,sp,16
    80008a24:	fc9fd06f          	j	800069ec <rt_kprintf>

0000000080008a28 <handle_trap>:
    80008a28:	fd010113          	addi	sp,sp,-48
    80008a2c:	02813023          	sd	s0,32(sp)
    80008a30:	02113423          	sd	ra,40(sp)
    80008a34:	00913c23          	sd	s1,24(sp)
    80008a38:	01213823          	sd	s2,16(sp)
    80008a3c:	01313423          	sd	s3,8(sp)
    80008a40:	01413023          	sd	s4,0(sp)
    80008a44:	0005041b          	sext.w	s0,a0
    80008a48:	08055063          	bgez	a0,80008ac8 <handle_trap+0xa0>
    80008a4c:	00900793          	li	a5,9
    80008a50:	04f40463          	beq	s0,a5,80008a98 <handle_trap+0x70>
    80008a54:	0087cc63          	blt	a5,s0,80008a6c <handle_trap+0x44>
    80008a58:	ffd47413          	andi	s0,s0,-3
    80008a5c:	00500793          	li	a5,5
    80008a60:	00f41a63          	bne	s0,a5,80008a74 <handle_trap+0x4c>
    80008a64:	1ac000ef          	jal	ra,80008c10 <tick_isr>
    80008a68:	00c0006f          	j	80008a74 <handle_trap+0x4c>
    80008a6c:	00b00793          	li	a5,11
    80008a70:	02f40463          	beq	s0,a5,80008a98 <handle_trap+0x70>
    80008a74:	02013403          	ld	s0,32(sp)
    80008a78:	02813083          	ld	ra,40(sp)
    80008a7c:	01813483          	ld	s1,24(sp)
    80008a80:	01013903          	ld	s2,16(sp)
    80008a84:	00813983          	ld	s3,8(sp)
    80008a88:	00013a03          	ld	s4,0(sp)
    80008a8c:	00000513          	li	a0,0
    80008a90:	03010113          	addi	sp,sp,48
    80008a94:	dc4f706f          	j	80000058 <rt_hw_interrupt_enable>
    80008a98:	828fb0ef          	jal	ra,80003ac0 <plic_claim>
    80008a9c:	00050413          	mv	s0,a0
    80008aa0:	838fb0ef          	jal	ra,80003ad8 <plic_complete>
    80008aa4:	00441713          	slli	a4,s0,0x4
    80008aa8:	0001d797          	auipc	a5,0x1d
    80008aac:	59078793          	addi	a5,a5,1424 # 80026038 <irq_desc>
    80008ab0:	00e787b3          	add	a5,a5,a4
    80008ab4:	0007b703          	ld	a4,0(a5)
    80008ab8:	0087b583          	ld	a1,8(a5)
    80008abc:	00040513          	mv	a0,s0
    80008ac0:	000700e7          	jalr	a4
    80008ac4:	fb1ff06f          	j	80008a74 <handle_trap+0x4c>
    80008ac8:	00050493          	mv	s1,a0
    80008acc:	00058a13          	mv	s4,a1
    80008ad0:	00060913          	mv	s2,a2
    80008ad4:	00068993          	mv	s3,a3
    80008ad8:	d78f70ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    80008adc:	00048593          	mv	a1,s1
    80008ae0:	00090693          	mv	a3,s2
    80008ae4:	000a0613          	mv	a2,s4
    80008ae8:	00009517          	auipc	a0,0x9
    80008aec:	4b050513          	addi	a0,a0,1200 # 80011f98 <__FUNCTION__.37+0x4d0>
    80008af0:	efdfd0ef          	jal	ra,800069ec <rt_kprintf>
    80008af4:	d0cfe0ef          	jal	ra,80007000 <rt_thread_self>
    80008af8:	00050493          	mv	s1,a0
    80008afc:	00009517          	auipc	a0,0x9
    80008b00:	4c450513          	addi	a0,a0,1220 # 80011fc0 <__FUNCTION__.37+0x4f8>
    80008b04:	ee9fd0ef          	jal	ra,800069ec <rt_kprintf>
    80008b08:	00b00793          	li	a5,11
    80008b0c:	0e87e863          	bltu	a5,s0,80008bfc <handle_trap+0x1d4>
    80008b10:	00009717          	auipc	a4,0x9
    80008b14:	66070713          	addi	a4,a4,1632 # 80012170 <__FUNCTION__.37+0x6a8>
    80008b18:	00241413          	slli	s0,s0,0x2
    80008b1c:	00e40433          	add	s0,s0,a4
    80008b20:	00042783          	lw	a5,0(s0)
    80008b24:	00e787b3          	add	a5,a5,a4
    80008b28:	00078067          	jr	a5
    80008b2c:	00009517          	auipc	a0,0x9
    80008b30:	4a450513          	addi	a0,a0,1188 # 80011fd0 <__FUNCTION__.37+0x508>
    80008b34:	eb9fd0ef          	jal	ra,800069ec <rt_kprintf>
    80008b38:	0000a517          	auipc	a0,0xa
    80008b3c:	0d850513          	addi	a0,a0,216 # 80012c10 <__FUNCTION__.6+0x28>
    80008b40:	eadfd0ef          	jal	ra,800069ec <rt_kprintf>
    80008b44:	00098513          	mv	a0,s3
    80008b48:	c19ff0ef          	jal	ra,80008760 <dump_regs>
    80008b4c:	00090593          	mv	a1,s2
    80008b50:	00009517          	auipc	a0,0x9
    80008b54:	5f050513          	addi	a0,a0,1520 # 80012140 <__FUNCTION__.37+0x678>
    80008b58:	e95fd0ef          	jal	ra,800069ec <rt_kprintf>
    80008b5c:	00048613          	mv	a2,s1
    80008b60:	01400593          	li	a1,20
    80008b64:	00009517          	auipc	a0,0x9
    80008b68:	5f450513          	addi	a0,a0,1524 # 80012158 <__FUNCTION__.37+0x690>
    80008b6c:	e81fd0ef          	jal	ra,800069ec <rt_kprintf>
    80008b70:	5dc020ef          	jal	ra,8000b14c <list_thread>
    80008b74:	0000006f          	j	80008b74 <handle_trap+0x14c>
    80008b78:	00009517          	auipc	a0,0x9
    80008b7c:	47850513          	addi	a0,a0,1144 # 80011ff0 <__FUNCTION__.37+0x528>
    80008b80:	fb5ff06f          	j	80008b34 <handle_trap+0x10c>
    80008b84:	00009517          	auipc	a0,0x9
    80008b88:	48c50513          	addi	a0,a0,1164 # 80012010 <__FUNCTION__.37+0x548>
    80008b8c:	fa9ff06f          	j	80008b34 <handle_trap+0x10c>
    80008b90:	00009517          	auipc	a0,0x9
    80008b94:	49850513          	addi	a0,a0,1176 # 80012028 <__FUNCTION__.37+0x560>
    80008b98:	f9dff06f          	j	80008b34 <handle_trap+0x10c>
    80008b9c:	00009517          	auipc	a0,0x9
    80008ba0:	49c50513          	addi	a0,a0,1180 # 80012038 <__FUNCTION__.37+0x570>
    80008ba4:	f91ff06f          	j	80008b34 <handle_trap+0x10c>
    80008ba8:	00009517          	auipc	a0,0x9
    80008bac:	4a850513          	addi	a0,a0,1192 # 80012050 <__FUNCTION__.37+0x588>
    80008bb0:	f85ff06f          	j	80008b34 <handle_trap+0x10c>
    80008bb4:	00009517          	auipc	a0,0x9
    80008bb8:	4b450513          	addi	a0,a0,1204 # 80012068 <__FUNCTION__.37+0x5a0>
    80008bbc:	f79ff06f          	j	80008b34 <handle_trap+0x10c>
    80008bc0:	00009517          	auipc	a0,0x9
    80008bc4:	4c850513          	addi	a0,a0,1224 # 80012088 <__FUNCTION__.37+0x5c0>
    80008bc8:	f6dff06f          	j	80008b34 <handle_trap+0x10c>
    80008bcc:	00009517          	auipc	a0,0x9
    80008bd0:	4d450513          	addi	a0,a0,1236 # 800120a0 <__FUNCTION__.37+0x5d8>
    80008bd4:	f61ff06f          	j	80008b34 <handle_trap+0x10c>
    80008bd8:	00009517          	auipc	a0,0x9
    80008bdc:	4e850513          	addi	a0,a0,1256 # 800120c0 <__FUNCTION__.37+0x5f8>
    80008be0:	f55ff06f          	j	80008b34 <handle_trap+0x10c>
    80008be4:	00009517          	auipc	a0,0x9
    80008be8:	4fc50513          	addi	a0,a0,1276 # 800120e0 <__FUNCTION__.37+0x618>
    80008bec:	f49ff06f          	j	80008b34 <handle_trap+0x10c>
    80008bf0:	00009517          	auipc	a0,0x9
    80008bf4:	51050513          	addi	a0,a0,1296 # 80012100 <__FUNCTION__.37+0x638>
    80008bf8:	f3dff06f          	j	80008b34 <handle_trap+0x10c>
    80008bfc:	00040593          	mv	a1,s0
    80008c00:	00009517          	auipc	a0,0x9
    80008c04:	52050513          	addi	a0,a0,1312 # 80012120 <__FUNCTION__.37+0x658>
    80008c08:	de5fd0ef          	jal	ra,800069ec <rt_kprintf>
    80008c0c:	f2dff06f          	j	80008b38 <handle_trap+0x110>

0000000080008c10 <tick_isr>:
    80008c10:	ff010113          	addi	sp,sp,-16
    80008c14:	00113423          	sd	ra,8(sp)
    80008c18:	fbdfd0ef          	jal	ra,80006bd4 <rt_tick_increase>
    80008c1c:	f14027f3          	csrr	a5,mhartid
    80008c20:	0027979b          	slliw	a5,a5,0x2
    80008c24:	02079793          	slli	a5,a5,0x20
    80008c28:	02004737          	lui	a4,0x2004
    80008c2c:	0207d793          	srli	a5,a5,0x20
    80008c30:	00f707b3          	add	a5,a4,a5
    80008c34:	0200c737          	lui	a4,0x200c
    80008c38:	ff873703          	ld	a4,-8(a4) # 200bff8 <__STACKSIZE__+0x2007ff8>
    80008c3c:	000186b7          	lui	a3,0x18
    80008c40:	00813083          	ld	ra,8(sp)
    80008c44:	6a068693          	addi	a3,a3,1696 # 186a0 <__STACKSIZE__+0x146a0>
    80008c48:	00d70733          	add	a4,a4,a3
    80008c4c:	00e7b023          	sd	a4,0(a5)
    80008c50:	00000513          	li	a0,0
    80008c54:	01010113          	addi	sp,sp,16
    80008c58:	00008067          	ret

0000000080008c5c <rt_hw_tick_init>:
    80008c5c:	08000713          	li	a4,128
    80008c60:	304737f3          	csrrc	a5,mie,a4
    80008c64:	344737f3          	csrrc	a5,mip,a4
    80008c68:	f14027f3          	csrr	a5,mhartid
    80008c6c:	0027979b          	slliw	a5,a5,0x2
    80008c70:	02079793          	slli	a5,a5,0x20
    80008c74:	020046b7          	lui	a3,0x2004
    80008c78:	0207d793          	srli	a5,a5,0x20
    80008c7c:	00f687b3          	add	a5,a3,a5
    80008c80:	0200c6b7          	lui	a3,0x200c
    80008c84:	ff86b683          	ld	a3,-8(a3) # 200bff8 <__STACKSIZE__+0x2007ff8>
    80008c88:	00018637          	lui	a2,0x18
    80008c8c:	6a060613          	addi	a2,a2,1696 # 186a0 <__STACKSIZE__+0x146a0>
    80008c90:	00c686b3          	add	a3,a3,a2
    80008c94:	00d7b023          	sd	a3,0(a5)
    80008c98:	30472773          	csrrs	a4,mie,a4
    80008c9c:	00000513          	li	a0,0
    80008ca0:	00008067          	ret

0000000080008ca4 <trap_entry>:
    80008ca4:	f0010113          	addi	sp,sp,-256
    80008ca8:	00113423          	sd	ra,8(sp)
    80008cac:	300020f3          	csrr	ra,mstatus
    80008cb0:	00113823          	sd	ra,16(sp)
    80008cb4:	341020f3          	csrr	ra,mepc
    80008cb8:	00113023          	sd	ra,0(sp)
    80008cbc:	02413023          	sd	tp,32(sp)
    80008cc0:	02513423          	sd	t0,40(sp)
    80008cc4:	02613823          	sd	t1,48(sp)
    80008cc8:	02713c23          	sd	t2,56(sp)
    80008ccc:	04813023          	sd	s0,64(sp)
    80008cd0:	04913423          	sd	s1,72(sp)
    80008cd4:	04a13823          	sd	a0,80(sp)
    80008cd8:	04b13c23          	sd	a1,88(sp)
    80008cdc:	06c13023          	sd	a2,96(sp)
    80008ce0:	06d13423          	sd	a3,104(sp)
    80008ce4:	06e13823          	sd	a4,112(sp)
    80008ce8:	06f13c23          	sd	a5,120(sp)
    80008cec:	09013023          	sd	a6,128(sp)
    80008cf0:	09113423          	sd	a7,136(sp)
    80008cf4:	09213823          	sd	s2,144(sp)
    80008cf8:	09313c23          	sd	s3,152(sp)
    80008cfc:	0b413023          	sd	s4,160(sp)
    80008d00:	0b513423          	sd	s5,168(sp)
    80008d04:	0b613823          	sd	s6,176(sp)
    80008d08:	0b713c23          	sd	s7,184(sp)
    80008d0c:	0d813023          	sd	s8,192(sp)
    80008d10:	0d913423          	sd	s9,200(sp)
    80008d14:	0da13823          	sd	s10,208(sp)
    80008d18:	0db13c23          	sd	s11,216(sp)
    80008d1c:	0fc13023          	sd	t3,224(sp)
    80008d20:	0fd13423          	sd	t4,232(sp)
    80008d24:	0fe13823          	sd	t5,240(sp)
    80008d28:	0ff13c23          	sd	t6,248(sp)
    80008d2c:	00010413          	mv	s0,sp
    80008d30:	f14022f3          	csrr	t0,mhartid
    80008d34:	82018113          	addi	sp,gp,-2016 # 800157c0 <__stack_start__>
    80008d38:	00128313          	addi	t1,t0,1
    80008d3c:	000043b7          	lui	t2,0x4
    80008d40:	00000e13          	li	t3,0

0000000080008d44 <mul_begin>:
    80008d44:	007e0e33          	add	t3,t3,t2
    80008d48:	fff30313          	addi	t1,t1,-1
    80008d4c:	fe031ce3          	bnez	t1,80008d44 <mul_begin>
    80008d50:	000e0313          	mv	t1,t3
    80008d54:	00610133          	add	sp,sp,t1
    80008d58:	ecdfa0ef          	jal	ra,80003c24 <rt_interrupt_enter>
    80008d5c:	34202573          	csrr	a0,mcause
    80008d60:	341025f3          	csrr	a1,mepc
    80008d64:	00040613          	mv	a2,s0
    80008d68:	cc1ff0ef          	jal	ra,80008a28 <handle_trap>
    80008d6c:	efdfa0ef          	jal	ra,80003c68 <rt_interrupt_leave>
    80008d70:	00040113          	mv	sp,s0
    80008d74:	00015417          	auipc	s0,0x15
    80008d78:	c6440413          	addi	s0,s0,-924 # 8001d9d8 <rt_thread_switch_interrupt_flag>
    80008d7c:	00042903          	lw	s2,0(s0)
    80008d80:	02090463          	beqz	s2,80008da8 <spurious_interrupt>
    80008d84:	00042023          	sw	zero,0(s0)
    80008d88:	00015417          	auipc	s0,0x15
    80008d8c:	c4040413          	addi	s0,s0,-960 # 8001d9c8 <rt_interrupt_from_thread>
    80008d90:	00043483          	ld	s1,0(s0)
    80008d94:	0024b023          	sd	sp,0(s1)
    80008d98:	00015417          	auipc	s0,0x15
    80008d9c:	c3840413          	addi	s0,s0,-968 # 8001d9d0 <rt_interrupt_to_thread>
    80008da0:	00043483          	ld	s1,0(s0)
    80008da4:	0004b103          	ld	sp,0(s1)

0000000080008da8 <spurious_interrupt>:
    80008da8:	b64f706f          	j	8000010c <rt_hw_context_switch_exit>

0000000080008dac <msh_help>:
    80008dac:	fd010113          	addi	sp,sp,-48
    80008db0:	00009517          	auipc	a0,0x9
    80008db4:	4c850513          	addi	a0,a0,1224 # 80012278 <CSWTCH.17+0x50>
    80008db8:	02813023          	sd	s0,32(sp)
    80008dbc:	01213823          	sd	s2,16(sp)
    80008dc0:	01313423          	sd	s3,8(sp)
    80008dc4:	01413023          	sd	s4,0(sp)
    80008dc8:	02113423          	sd	ra,40(sp)
    80008dcc:	00913c23          	sd	s1,24(sp)
    80008dd0:	00015917          	auipc	s2,0x15
    80008dd4:	c1890913          	addi	s2,s2,-1000 # 8001d9e8 <_syscall_table_end>
    80008dd8:	c15fd0ef          	jal	ra,800069ec <rt_kprintf>
    80008ddc:	00009997          	auipc	s3,0x9
    80008de0:	4bc98993          	addi	s3,s3,1212 # 80012298 <CSWTCH.17+0x70>
    80008de4:	00015417          	auipc	s0,0x15
    80008de8:	bfc43403          	ld	s0,-1028(s0) # 8001d9e0 <_syscall_table_begin>
    80008dec:	00009a17          	auipc	s4,0x9
    80008df0:	4b4a0a13          	addi	s4,s4,1204 # 800122a0 <CSWTCH.17+0x78>
    80008df4:	00093783          	ld	a5,0(s2)
    80008df8:	02f46a63          	bltu	s0,a5,80008e2c <msh_help+0x80>
    80008dfc:	0000a517          	auipc	a0,0xa
    80008e00:	e1450513          	addi	a0,a0,-492 # 80012c10 <__FUNCTION__.6+0x28>
    80008e04:	be9fd0ef          	jal	ra,800069ec <rt_kprintf>
    80008e08:	02813083          	ld	ra,40(sp)
    80008e0c:	02013403          	ld	s0,32(sp)
    80008e10:	01813483          	ld	s1,24(sp)
    80008e14:	01013903          	ld	s2,16(sp)
    80008e18:	00813983          	ld	s3,8(sp)
    80008e1c:	00013a03          	ld	s4,0(sp)
    80008e20:	00000513          	li	a0,0
    80008e24:	03010113          	addi	sp,sp,48
    80008e28:	00008067          	ret
    80008e2c:	00043483          	ld	s1,0(s0)
    80008e30:	00600613          	li	a2,6
    80008e34:	00098593          	mv	a1,s3
    80008e38:	00048513          	mv	a0,s1
    80008e3c:	d1dfa0ef          	jal	ra,80003b58 <strncmp>
    80008e40:	00051a63          	bnez	a0,80008e54 <msh_help+0xa8>
    80008e44:	00843603          	ld	a2,8(s0)
    80008e48:	00648593          	addi	a1,s1,6
    80008e4c:	000a0513          	mv	a0,s4
    80008e50:	b9dfd0ef          	jal	ra,800069ec <rt_kprintf>
    80008e54:	01840413          	addi	s0,s0,24
    80008e58:	f9dff06f          	j	80008df4 <msh_help+0x48>

0000000080008e5c <cmd_ps>:
    80008e5c:	ff010113          	addi	sp,sp,-16
    80008e60:	00113423          	sd	ra,8(sp)
    80008e64:	2e8020ef          	jal	ra,8000b14c <list_thread>
    80008e68:	00813083          	ld	ra,8(sp)
    80008e6c:	00000513          	li	a0,0
    80008e70:	01010113          	addi	sp,sp,16
    80008e74:	00008067          	ret

0000000080008e78 <cmd_free>:
    80008e78:	ff010113          	addi	sp,sp,-16
    80008e7c:	00113423          	sd	ra,8(sp)
    80008e80:	b3dfb0ef          	jal	ra,800049bc <list_mem>
    80008e84:	00813083          	ld	ra,8(sp)
    80008e88:	00000513          	li	a0,0
    80008e8c:	01010113          	addi	sp,sp,16
    80008e90:	00008067          	ret

0000000080008e94 <msh_is_used>:
    80008e94:	00100513          	li	a0,1
    80008e98:	00008067          	ret

0000000080008e9c <msh_exec>:
    80008e9c:	f6010113          	addi	sp,sp,-160
    80008ea0:	08813823          	sd	s0,144(sp)
    80008ea4:	08913423          	sd	s1,136(sp)
    80008ea8:	08113c23          	sd	ra,152(sp)
    80008eac:	09213023          	sd	s2,128(sp)
    80008eb0:	07313c23          	sd	s3,120(sp)
    80008eb4:	07413823          	sd	s4,112(sp)
    80008eb8:	07513423          	sd	s5,104(sp)
    80008ebc:	07613023          	sd	s6,96(sp)
    80008ec0:	05713c23          	sd	s7,88(sp)
    80008ec4:	00050493          	mv	s1,a0
    80008ec8:	00058413          	mv	s0,a1
    80008ecc:	02000693          	li	a3,32
    80008ed0:	00900713          	li	a4,9
    80008ed4:	04041063          	bnez	s0,80008f14 <msh_exec+0x78>
    80008ed8:	00000513          	li	a0,0
    80008edc:	09813083          	ld	ra,152(sp)
    80008ee0:	09013403          	ld	s0,144(sp)
    80008ee4:	08813483          	ld	s1,136(sp)
    80008ee8:	08013903          	ld	s2,128(sp)
    80008eec:	07813983          	ld	s3,120(sp)
    80008ef0:	07013a03          	ld	s4,112(sp)
    80008ef4:	06813a83          	ld	s5,104(sp)
    80008ef8:	06013b03          	ld	s6,96(sp)
    80008efc:	05813b83          	ld	s7,88(sp)
    80008f00:	0a010113          	addi	sp,sp,160
    80008f04:	00008067          	ret
    80008f08:	00148493          	addi	s1,s1,1
    80008f0c:	fff40413          	addi	s0,s0,-1
    80008f10:	fc5ff06f          	j	80008ed4 <msh_exec+0x38>
    80008f14:	0004c783          	lbu	a5,0(s1)
    80008f18:	fed788e3          	beq	a5,a3,80008f08 <msh_exec+0x6c>
    80008f1c:	fee786e3          	beq	a5,a4,80008f08 <msh_exec+0x6c>
    80008f20:	00000793          	li	a5,0
    80008f24:	02000693          	li	a3,32
    80008f28:	00900613          	li	a2,9
    80008f2c:	00f48733          	add	a4,s1,a5
    80008f30:	00074703          	lbu	a4,0(a4)
    80008f34:	0cd70663          	beq	a4,a3,80009000 <msh_exec+0x164>
    80008f38:	0cc70463          	beq	a4,a2,80009000 <msh_exec+0x164>
    80008f3c:	0af41e63          	bne	s0,a5,80008ff8 <msh_exec+0x15c>
    80008f40:	00078b1b          	sext.w	s6,a5
    80008f44:	00015997          	auipc	s3,0x15
    80008f48:	a9c9b983          	ld	s3,-1380(s3) # 8001d9e0 <_syscall_table_begin>
    80008f4c:	00015a97          	auipc	s5,0x15
    80008f50:	a9caba83          	ld	s5,-1380(s5) # 8001d9e8 <_syscall_table_end>
    80008f54:	00009b97          	auipc	s7,0x9
    80008f58:	344b8b93          	addi	s7,s7,836 # 80012298 <CSWTCH.17+0x70>
    80008f5c:	0067891b          	addiw	s2,a5,6
    80008f60:	0b59f263          	bgeu	s3,s5,80009004 <msh_exec+0x168>
    80008f64:	0009ba03          	ld	s4,0(s3)
    80008f68:	00600613          	li	a2,6
    80008f6c:	000b8593          	mv	a1,s7
    80008f70:	000a0513          	mv	a0,s4
    80008f74:	be5fa0ef          	jal	ra,80003b58 <strncmp>
    80008f78:	0c051463          	bnez	a0,80009040 <msh_exec+0x1a4>
    80008f7c:	000b0613          	mv	a2,s6
    80008f80:	00048593          	mv	a1,s1
    80008f84:	006a0513          	addi	a0,s4,6
    80008f88:	bd1fa0ef          	jal	ra,80003b58 <strncmp>
    80008f8c:	0a051a63          	bnez	a0,80009040 <msh_exec+0x1a4>
    80008f90:	012a0a33          	add	s4,s4,s2
    80008f94:	000a4783          	lbu	a5,0(s4)
    80008f98:	0a079463          	bnez	a5,80009040 <msh_exec+0x1a4>
    80008f9c:	0109b983          	ld	s3,16(s3)
    80008fa0:	06098263          	beqz	s3,80009004 <msh_exec+0x168>
    80008fa4:	05000613          	li	a2,80
    80008fa8:	00000593          	li	a1,0
    80008fac:	00010513          	mv	a0,sp
    80008fb0:	badfa0ef          	jal	ra,80003b5c <memset>
    80008fb4:	00010913          	mv	s2,sp
    80008fb8:	00010613          	mv	a2,sp
    80008fbc:	00048793          	mv	a5,s1
    80008fc0:	00000713          	li	a4,0
    80008fc4:	00000693          	li	a3,0
    80008fc8:	02000813          	li	a6,32
    80008fcc:	00900893          	li	a7,9
    80008fd0:	00a00313          	li	t1,10
    80008fd4:	02200593          	li	a1,34
    80008fd8:	05c00e13          	li	t3,92
    80008fdc:	0007c503          	lbu	a0,0(a5)
    80008fe0:	01050463          	beq	a0,a6,80008fe8 <msh_exec+0x14c>
    80008fe4:	07151a63          	bne	a0,a7,80009058 <msh_exec+0x1bc>
    80008fe8:	06876063          	bltu	a4,s0,80009048 <msh_exec+0x1ac>
    80008fec:	00a00793          	li	a5,10
    80008ff0:	06f68663          	beq	a3,a5,8000905c <msh_exec+0x1c0>
    80008ff4:	0d40006f          	j	800090c8 <msh_exec+0x22c>
    80008ff8:	00178793          	addi	a5,a5,1
    80008ffc:	f31ff06f          	j	80008f2c <msh_exec+0x90>
    80009000:	f40790e3          	bnez	a5,80008f40 <msh_exec+0xa4>
    80009004:	0004059b          	sext.w	a1,s0
    80009008:	00048513          	mv	a0,s1
    8000900c:	174010ef          	jal	ra,8000a180 <msh_exec_script>
    80009010:	00048793          	mv	a5,s1
    80009014:	ec0502e3          	beqz	a0,80008ed8 <msh_exec+0x3c>
    80009018:	0007c703          	lbu	a4,0(a5)
    8000901c:	0df77713          	andi	a4,a4,223
    80009020:	10071863          	bnez	a4,80009130 <msh_exec+0x294>
    80009024:	00009517          	auipc	a0,0x9
    80009028:	2b450513          	addi	a0,a0,692 # 800122d8 <CSWTCH.17+0xb0>
    8000902c:	00078023          	sb	zero,0(a5)
    80009030:	00048593          	mv	a1,s1
    80009034:	9b9fd0ef          	jal	ra,800069ec <rt_kprintf>
    80009038:	fff00513          	li	a0,-1
    8000903c:	ea1ff06f          	j	80008edc <msh_exec+0x40>
    80009040:	01898993          	addi	s3,s3,24
    80009044:	f1dff06f          	j	80008f60 <msh_exec+0xc4>
    80009048:	00078023          	sb	zero,0(a5)
    8000904c:	00170713          	addi	a4,a4,1
    80009050:	00178793          	addi	a5,a5,1
    80009054:	f89ff06f          	j	80008fdc <msh_exec+0x140>
    80009058:	04669663          	bne	a3,t1,800090a4 <msh_exec+0x208>
    8000905c:	00009517          	auipc	a0,0x9
    80009060:	25450513          	addi	a0,a0,596 # 800122b0 <CSWTCH.17+0x88>
    80009064:	989fd0ef          	jal	ra,800069ec <rt_kprintf>
    80009068:	05010413          	addi	s0,sp,80
    8000906c:	00009497          	auipc	s1,0x9
    80009070:	26448493          	addi	s1,s1,612 # 800122d0 <CSWTCH.17+0xa8>
    80009074:	00093583          	ld	a1,0(s2)
    80009078:	00048513          	mv	a0,s1
    8000907c:	00890913          	addi	s2,s2,8
    80009080:	96dfd0ef          	jal	ra,800069ec <rt_kprintf>
    80009084:	fe8918e3          	bne	s2,s0,80009074 <msh_exec+0x1d8>
    80009088:	0000a517          	auipc	a0,0xa
    8000908c:	b8850513          	addi	a0,a0,-1144 # 80012c10 <__FUNCTION__.6+0x28>
    80009090:	95dfd0ef          	jal	ra,800069ec <rt_kprintf>
    80009094:	00a00513          	li	a0,10
    80009098:	00010593          	mv	a1,sp
    8000909c:	000980e7          	jalr	s3
    800090a0:	e3dff06f          	j	80008edc <msh_exec+0x40>
    800090a4:	02877263          	bgeu	a4,s0,800090c8 <msh_exec+0x22c>
    800090a8:	00168693          	addi	a3,a3,1
    800090ac:	06b51263          	bne	a0,a1,80009110 <msh_exec+0x274>
    800090b0:	00178793          	addi	a5,a5,1
    800090b4:	00170713          	addi	a4,a4,1
    800090b8:	00f63023          	sd	a5,0(a2)
    800090bc:	0007c503          	lbu	a0,0(a5)
    800090c0:	02b50a63          	beq	a0,a1,800090f4 <msh_exec+0x258>
    800090c4:	00876863          	bltu	a4,s0,800090d4 <msh_exec+0x238>
    800090c8:	0006851b          	sext.w	a0,a3
    800090cc:	fc0696e3          	bnez	a3,80009098 <msh_exec+0x1fc>
    800090d0:	f35ff06f          	j	80009004 <msh_exec+0x168>
    800090d4:	0017ce83          	lbu	t4,1(a5)
    800090d8:	01c51863          	bne	a0,t3,800090e8 <msh_exec+0x24c>
    800090dc:	00be9663          	bne	t4,a1,800090e8 <msh_exec+0x24c>
    800090e0:	00178793          	addi	a5,a5,1
    800090e4:	00170713          	addi	a4,a4,1
    800090e8:	00178793          	addi	a5,a5,1
    800090ec:	00170713          	addi	a4,a4,1
    800090f0:	fcdff06f          	j	800090bc <msh_exec+0x220>
    800090f4:	fc877ae3          	bgeu	a4,s0,800090c8 <msh_exec+0x22c>
    800090f8:	00078023          	sb	zero,0(a5)
    800090fc:	00170713          	addi	a4,a4,1
    80009100:	00178793          	addi	a5,a5,1
    80009104:	fc8772e3          	bgeu	a4,s0,800090c8 <msh_exec+0x22c>
    80009108:	00860613          	addi	a2,a2,8
    8000910c:	ed1ff06f          	j	80008fdc <msh_exec+0x140>
    80009110:	00f63023          	sd	a5,0(a2)
    80009114:	0007c503          	lbu	a0,0(a5)
    80009118:	ff0506e3          	beq	a0,a6,80009104 <msh_exec+0x268>
    8000911c:	ff1504e3          	beq	a0,a7,80009104 <msh_exec+0x268>
    80009120:	fae404e3          	beq	s0,a4,800090c8 <msh_exec+0x22c>
    80009124:	00178793          	addi	a5,a5,1
    80009128:	00170713          	addi	a4,a4,1
    8000912c:	fe9ff06f          	j	80009114 <msh_exec+0x278>
    80009130:	00178793          	addi	a5,a5,1
    80009134:	ee5ff06f          	j	80009018 <msh_exec+0x17c>

0000000080009138 <msh_auto_complete_path>:
    80009138:	26050c63          	beqz	a0,800093b0 <msh_auto_complete_path+0x278>
    8000913c:	fc010113          	addi	sp,sp,-64
    80009140:	02913423          	sd	s1,40(sp)
    80009144:	00050493          	mv	s1,a0
    80009148:	10000513          	li	a0,256
    8000914c:	02813823          	sd	s0,48(sp)
    80009150:	02113c23          	sd	ra,56(sp)
    80009154:	03213023          	sd	s2,32(sp)
    80009158:	01313c23          	sd	s3,24(sp)
    8000915c:	01413823          	sd	s4,16(sp)
    80009160:	01513423          	sd	s5,8(sp)
    80009164:	dc1fb0ef          	jal	ra,80004f24 <rt_malloc>
    80009168:	00050413          	mv	s0,a0
    8000916c:	22050063          	beqz	a0,8000938c <msh_auto_complete_path+0x254>
    80009170:	0004c783          	lbu	a5,0(s1)
    80009174:	02f00913          	li	s2,47
    80009178:	05278e63          	beq	a5,s2,800091d4 <msh_auto_complete_path+0x9c>
    8000917c:	10000593          	li	a1,256
    80009180:	145040ef          	jal	ra,8000dac4 <getcwd>
    80009184:	00040513          	mv	a0,s0
    80009188:	974fd0ef          	jal	ra,800062fc <rt_strlen>
    8000918c:	00a40533          	add	a0,s0,a0
    80009190:	fff54783          	lbu	a5,-1(a0)
    80009194:	01278a63          	beq	a5,s2,800091a8 <msh_auto_complete_path+0x70>
    80009198:	00009597          	auipc	a1,0x9
    8000919c:	15858593          	addi	a1,a1,344 # 800122f0 <CSWTCH.17+0xc8>
    800091a0:	00040513          	mv	a0,s0
    800091a4:	979fa0ef          	jal	ra,80003b1c <strcat>
    800091a8:	00148793          	addi	a5,s1,1
    800091ac:	00000913          	li	s2,0
    800091b0:	02f00613          	li	a2,47
    800091b4:	fff7c683          	lbu	a3,-1(a5)
    800091b8:	00078713          	mv	a4,a5
    800091bc:	00c68663          	beq	a3,a2,800091c8 <msh_auto_complete_path+0x90>
    800091c0:	00068e63          	beqz	a3,800091dc <msh_auto_complete_path+0xa4>
    800091c4:	00090713          	mv	a4,s2
    800091c8:	00178793          	addi	a5,a5,1
    800091cc:	00070913          	mv	s2,a4
    800091d0:	fe5ff06f          	j	800091b4 <msh_auto_complete_path+0x7c>
    800091d4:	00050023          	sb	zero,0(a0)
    800091d8:	fd1ff06f          	j	800091a8 <msh_auto_complete_path+0x70>
    800091dc:	00091463          	bnez	s2,800091e4 <msh_auto_complete_path+0xac>
    800091e0:	00048913          	mv	s2,s1
    800091e4:	00040793          	mv	a5,s0
    800091e8:	0080006f          	j	800091f0 <msh_auto_complete_path+0xb8>
    800091ec:	00178793          	addi	a5,a5,1
    800091f0:	0007c703          	lbu	a4,0(a5)
    800091f4:	fe071ce3          	bnez	a4,800091ec <msh_auto_complete_path+0xb4>
    800091f8:	00078713          	mv	a4,a5
    800091fc:	00048993          	mv	s3,s1
    80009200:	05299463          	bne	s3,s2,80009248 <msh_auto_complete_path+0x110>
    80009204:	409984b3          	sub	s1,s3,s1
    80009208:	009784b3          	add	s1,a5,s1
    8000920c:	00048023          	sb	zero,0(s1)
    80009210:	00040513          	mv	a0,s0
    80009214:	588040ef          	jal	ra,8000d79c <opendir>
    80009218:	00050a13          	mv	s4,a0
    8000921c:	04051063          	bnez	a0,8000925c <msh_auto_complete_path+0x124>
    80009220:	00040513          	mv	a0,s0
    80009224:	03013403          	ld	s0,48(sp)
    80009228:	03813083          	ld	ra,56(sp)
    8000922c:	02813483          	ld	s1,40(sp)
    80009230:	02013903          	ld	s2,32(sp)
    80009234:	01813983          	ld	s3,24(sp)
    80009238:	01013a03          	ld	s4,16(sp)
    8000923c:	00813a83          	ld	s5,8(sp)
    80009240:	04010113          	addi	sp,sp,64
    80009244:	82cfc06f          	j	80005270 <rt_free>
    80009248:	0009c683          	lbu	a3,0(s3)
    8000924c:	00198993          	addi	s3,s3,1
    80009250:	00170713          	addi	a4,a4,1
    80009254:	fed70fa3          	sb	a3,-1(a4)
    80009258:	fa9ff06f          	j	80009200 <msh_auto_complete_path+0xc8>
    8000925c:	0009c783          	lbu	a5,0(s3)
    80009260:	02079463          	bnez	a5,80009288 <msh_auto_complete_path+0x150>
    80009264:	00009497          	auipc	s1,0x9
    80009268:	04448493          	addi	s1,s1,68 # 800122a8 <CSWTCH.17+0x80>
    8000926c:	000a0513          	mv	a0,s4
    80009270:	5f0040ef          	jal	ra,8000d860 <readdir>
    80009274:	10050663          	beqz	a0,80009380 <msh_auto_complete_path+0x248>
    80009278:	00450593          	addi	a1,a0,4
    8000927c:	00048513          	mv	a0,s1
    80009280:	f6cfd0ef          	jal	ra,800069ec <rt_kprintf>
    80009284:	fe9ff06f          	j	8000926c <msh_auto_complete_path+0x134>
    80009288:	00000493          	li	s1,0
    8000928c:	000a0513          	mv	a0,s4
    80009290:	5d0040ef          	jal	ra,8000d860 <readdir>
    80009294:	06050c63          	beqz	a0,8000930c <msh_auto_complete_path+0x1d4>
    80009298:	00450993          	addi	s3,a0,4
    8000929c:	00090513          	mv	a0,s2
    800092a0:	85cfd0ef          	jal	ra,800062fc <rt_strlen>
    800092a4:	00050613          	mv	a2,a0
    800092a8:	00098593          	mv	a1,s3
    800092ac:	00090513          	mv	a0,s2
    800092b0:	8a9fa0ef          	jal	ra,80003b58 <strncmp>
    800092b4:	fc051ce3          	bnez	a0,8000928c <msh_auto_complete_path+0x154>
    800092b8:	00049e63          	bnez	s1,800092d4 <msh_auto_complete_path+0x19c>
    800092bc:	00098513          	mv	a0,s3
    800092c0:	83cfd0ef          	jal	ra,800062fc <rt_strlen>
    800092c4:	00050493          	mv	s1,a0
    800092c8:	00098593          	mv	a1,s3
    800092cc:	00040513          	mv	a0,s0
    800092d0:	825fa0ef          	jal	ra,80003af4 <strcpy>
    800092d4:	00098793          	mv	a5,s3
    800092d8:	00040713          	mv	a4,s0
    800092dc:	0007c603          	lbu	a2,0(a5)
    800092e0:	00060863          	beqz	a2,800092f0 <msh_auto_complete_path+0x1b8>
    800092e4:	00074683          	lbu	a3,0(a4)
    800092e8:	00068463          	beqz	a3,800092f0 <msh_auto_complete_path+0x1b8>
    800092ec:	00d60a63          	beq	a2,a3,80009300 <msh_auto_complete_path+0x1c8>
    800092f0:	413787bb          	subw	a5,a5,s3
    800092f4:	f897fce3          	bgeu	a5,s1,8000928c <msh_auto_complete_path+0x154>
    800092f8:	00078493          	mv	s1,a5
    800092fc:	f91ff06f          	j	8000928c <msh_auto_complete_path+0x154>
    80009300:	00178793          	addi	a5,a5,1
    80009304:	00170713          	addi	a4,a4,1
    80009308:	fd5ff06f          	j	800092dc <msh_auto_complete_path+0x1a4>
    8000930c:	06048a63          	beqz	s1,80009380 <msh_auto_complete_path+0x248>
    80009310:	00040513          	mv	a0,s0
    80009314:	fe9fc0ef          	jal	ra,800062fc <rt_strlen>
    80009318:	04a4f863          	bgeu	s1,a0,80009368 <msh_auto_complete_path+0x230>
    8000931c:	000a0513          	mv	a0,s4
    80009320:	608040ef          	jal	ra,8000d928 <rewinddir>
    80009324:	00009a97          	auipc	s5,0x9
    80009328:	f84a8a93          	addi	s5,s5,-124 # 800122a8 <CSWTCH.17+0x80>
    8000932c:	000a0513          	mv	a0,s4
    80009330:	530040ef          	jal	ra,8000d860 <readdir>
    80009334:	02050a63          	beqz	a0,80009368 <msh_auto_complete_path+0x230>
    80009338:	00450993          	addi	s3,a0,4
    8000933c:	00090513          	mv	a0,s2
    80009340:	fbdfc0ef          	jal	ra,800062fc <rt_strlen>
    80009344:	00050613          	mv	a2,a0
    80009348:	00098593          	mv	a1,s3
    8000934c:	00090513          	mv	a0,s2
    80009350:	809fa0ef          	jal	ra,80003b58 <strncmp>
    80009354:	fc051ce3          	bnez	a0,8000932c <msh_auto_complete_path+0x1f4>
    80009358:	00098593          	mv	a1,s3
    8000935c:	000a8513          	mv	a0,s5
    80009360:	e8cfd0ef          	jal	ra,800069ec <rt_kprintf>
    80009364:	fc9ff06f          	j	8000932c <msh_auto_complete_path+0x1f4>
    80009368:	00048613          	mv	a2,s1
    8000936c:	00040593          	mv	a1,s0
    80009370:	00090513          	mv	a0,s2
    80009374:	009904b3          	add	s1,s2,s1
    80009378:	fe8fa0ef          	jal	ra,80003b60 <memcpy>
    8000937c:	00048023          	sb	zero,0(s1)
    80009380:	000a0513          	mv	a0,s4
    80009384:	60c040ef          	jal	ra,8000d990 <closedir>
    80009388:	e99ff06f          	j	80009220 <msh_auto_complete_path+0xe8>
    8000938c:	03813083          	ld	ra,56(sp)
    80009390:	03013403          	ld	s0,48(sp)
    80009394:	02813483          	ld	s1,40(sp)
    80009398:	02013903          	ld	s2,32(sp)
    8000939c:	01813983          	ld	s3,24(sp)
    800093a0:	01013a03          	ld	s4,16(sp)
    800093a4:	00813a83          	ld	s5,8(sp)
    800093a8:	04010113          	addi	sp,sp,64
    800093ac:	00008067          	ret
    800093b0:	00008067          	ret

00000000800093b4 <msh_auto_complete>:
    800093b4:	00054783          	lbu	a5,0(a0)
    800093b8:	00079863          	bnez	a5,800093c8 <msh_auto_complete+0x14>
    800093bc:	00000593          	li	a1,0
    800093c0:	00000513          	li	a0,0
    800093c4:	9e9ff06f          	j	80008dac <msh_help>
    800093c8:	fb010113          	addi	sp,sp,-80
    800093cc:	04813023          	sd	s0,64(sp)
    800093d0:	04113423          	sd	ra,72(sp)
    800093d4:	00050413          	mv	s0,a0
    800093d8:	02913c23          	sd	s1,56(sp)
    800093dc:	03213823          	sd	s2,48(sp)
    800093e0:	03313423          	sd	s3,40(sp)
    800093e4:	03413023          	sd	s4,32(sp)
    800093e8:	01513c23          	sd	s5,24(sp)
    800093ec:	01613823          	sd	s6,16(sp)
    800093f0:	01713423          	sd	s7,8(sp)
    800093f4:	f09fc0ef          	jal	ra,800062fc <rt_strlen>
    800093f8:	00a40533          	add	a0,s0,a0
    800093fc:	02000793          	li	a5,32
    80009400:	00850a63          	beq	a0,s0,80009414 <msh_auto_complete+0x60>
    80009404:	00054703          	lbu	a4,0(a0)
    80009408:	06f71c63          	bne	a4,a5,80009480 <msh_auto_complete+0xcc>
    8000940c:	00150513          	addi	a0,a0,1
    80009410:	d29ff0ef          	jal	ra,80009138 <msh_auto_complete_path>
    80009414:	00014997          	auipc	s3,0x14
    80009418:	5cc9b983          	ld	s3,1484(s3) # 8001d9e0 <_syscall_table_begin>
    8000941c:	00000b93          	li	s7,0
    80009420:	00000493          	li	s1,0
    80009424:	00014a17          	auipc	s4,0x14
    80009428:	5c4a0a13          	addi	s4,s4,1476 # 8001d9e8 <_syscall_table_end>
    8000942c:	00009a97          	auipc	s5,0x9
    80009430:	e6ca8a93          	addi	s5,s5,-404 # 80012298 <CSWTCH.17+0x70>
    80009434:	00009b17          	auipc	s6,0x9
    80009438:	e74b0b13          	addi	s6,s6,-396 # 800122a8 <CSWTCH.17+0x80>
    8000943c:	000a3783          	ld	a5,0(s4)
    80009440:	04f9e463          	bltu	s3,a5,80009488 <msh_auto_complete+0xd4>
    80009444:	0e0b8263          	beqz	s7,80009528 <msh_auto_complete+0x174>
    80009448:	00040513          	mv	a0,s0
    8000944c:	04013403          	ld	s0,64(sp)
    80009450:	04813083          	ld	ra,72(sp)
    80009454:	03013903          	ld	s2,48(sp)
    80009458:	02813983          	ld	s3,40(sp)
    8000945c:	02013a03          	ld	s4,32(sp)
    80009460:	01813a83          	ld	s5,24(sp)
    80009464:	01013b03          	ld	s6,16(sp)
    80009468:	00048613          	mv	a2,s1
    8000946c:	000b8593          	mv	a1,s7
    80009470:	03813483          	ld	s1,56(sp)
    80009474:	00813b83          	ld	s7,8(sp)
    80009478:	05010113          	addi	sp,sp,80
    8000947c:	dd9fc06f          	j	80006254 <rt_strncpy>
    80009480:	fff50513          	addi	a0,a0,-1
    80009484:	f7dff06f          	j	80009400 <msh_auto_complete+0x4c>
    80009488:	0009b903          	ld	s2,0(s3)
    8000948c:	00600613          	li	a2,6
    80009490:	000a8593          	mv	a1,s5
    80009494:	00090513          	mv	a0,s2
    80009498:	ec0fa0ef          	jal	ra,80003b58 <strncmp>
    8000949c:	06051663          	bnez	a0,80009508 <msh_auto_complete+0x154>
    800094a0:	00040513          	mv	a0,s0
    800094a4:	e4cfa0ef          	jal	ra,80003af0 <strlen>
    800094a8:	00690913          	addi	s2,s2,6
    800094ac:	00050613          	mv	a2,a0
    800094b0:	00090593          	mv	a1,s2
    800094b4:	00040513          	mv	a0,s0
    800094b8:	ea0fa0ef          	jal	ra,80003b58 <strncmp>
    800094bc:	04051663          	bnez	a0,80009508 <msh_auto_complete+0x154>
    800094c0:	00049a63          	bnez	s1,800094d4 <msh_auto_complete+0x120>
    800094c4:	00090513          	mv	a0,s2
    800094c8:	e28fa0ef          	jal	ra,80003af0 <strlen>
    800094cc:	0005049b          	sext.w	s1,a0
    800094d0:	00090b93          	mv	s7,s2
    800094d4:	000b8793          	mv	a5,s7
    800094d8:	00090713          	mv	a4,s2
    800094dc:	0007c603          	lbu	a2,0(a5)
    800094e0:	02061863          	bnez	a2,80009510 <msh_auto_complete+0x15c>
    800094e4:	417787b3          	sub	a5,a5,s7
    800094e8:	00078713          	mv	a4,a5
    800094ec:	0007879b          	sext.w	a5,a5
    800094f0:	00f4d463          	bge	s1,a5,800094f8 <msh_auto_complete+0x144>
    800094f4:	00048713          	mv	a4,s1
    800094f8:	00090593          	mv	a1,s2
    800094fc:	000b0513          	mv	a0,s6
    80009500:	0007049b          	sext.w	s1,a4
    80009504:	ce8fd0ef          	jal	ra,800069ec <rt_kprintf>
    80009508:	01898993          	addi	s3,s3,24
    8000950c:	f31ff06f          	j	8000943c <msh_auto_complete+0x88>
    80009510:	00074683          	lbu	a3,0(a4)
    80009514:	fc0688e3          	beqz	a3,800094e4 <msh_auto_complete+0x130>
    80009518:	fcd616e3          	bne	a2,a3,800094e4 <msh_auto_complete+0x130>
    8000951c:	00178793          	addi	a5,a5,1
    80009520:	00170713          	addi	a4,a4,1
    80009524:	fb9ff06f          	j	800094dc <msh_auto_complete+0x128>
    80009528:	04813083          	ld	ra,72(sp)
    8000952c:	04013403          	ld	s0,64(sp)
    80009530:	03813483          	ld	s1,56(sp)
    80009534:	03013903          	ld	s2,48(sp)
    80009538:	02813983          	ld	s3,40(sp)
    8000953c:	02013a03          	ld	s4,32(sp)
    80009540:	01813a83          	ld	s5,24(sp)
    80009544:	01013b03          	ld	s6,16(sp)
    80009548:	00813b83          	ld	s7,8(sp)
    8000954c:	05010113          	addi	sp,sp,80
    80009550:	00008067          	ret

0000000080009554 <cmd_ls>:
    80009554:	ff010113          	addi	sp,sp,-16
    80009558:	00113423          	sd	ra,8(sp)
    8000955c:	00100793          	li	a5,1
    80009560:	02f51063          	bne	a0,a5,80009580 <cmd_ls+0x2c>
    80009564:	0000c517          	auipc	a0,0xc
    80009568:	13c50513          	addi	a0,a0,316 # 800156a0 <working_directory>
    8000956c:	069030ef          	jal	ra,8000cdd4 <ls>
    80009570:	00813083          	ld	ra,8(sp)
    80009574:	00000513          	li	a0,0
    80009578:	01010113          	addi	sp,sp,16
    8000957c:	00008067          	ret
    80009580:	0085b503          	ld	a0,8(a1)
    80009584:	fe9ff06f          	j	8000956c <cmd_ls+0x18>

0000000080009588 <cmd_pwd>:
    80009588:	ff010113          	addi	sp,sp,-16
    8000958c:	00009517          	auipc	a0,0x9
    80009590:	d1c50513          	addi	a0,a0,-740 # 800122a8 <CSWTCH.17+0x80>
    80009594:	0000c597          	auipc	a1,0xc
    80009598:	10c58593          	addi	a1,a1,268 # 800156a0 <working_directory>
    8000959c:	00113423          	sd	ra,8(sp)
    800095a0:	c4cfd0ef          	jal	ra,800069ec <rt_kprintf>
    800095a4:	00813083          	ld	ra,8(sp)
    800095a8:	00000513          	li	a0,0
    800095ac:	01010113          	addi	sp,sp,16
    800095b0:	00008067          	ret

00000000800095b4 <directory_delete_for_msh>:
    800095b4:	24050063          	beqz	a0,800097f4 <directory_delete_for_msh+0x240>
    800095b8:	f8010113          	addi	sp,sp,-128
    800095bc:	06913423          	sd	s1,104(sp)
    800095c0:	00050493          	mv	s1,a0
    800095c4:	10000513          	li	a0,256
    800095c8:	06813823          	sd	s0,112(sp)
    800095cc:	07213023          	sd	s2,96(sp)
    800095d0:	05313c23          	sd	s3,88(sp)
    800095d4:	06113c23          	sd	ra,120(sp)
    800095d8:	05413823          	sd	s4,80(sp)
    800095dc:	05513423          	sd	s5,72(sp)
    800095e0:	05613023          	sd	s6,64(sp)
    800095e4:	03713c23          	sd	s7,56(sp)
    800095e8:	03813823          	sd	s8,48(sp)
    800095ec:	03913423          	sd	s9,40(sp)
    800095f0:	03a13023          	sd	s10,32(sp)
    800095f4:	01b13c23          	sd	s11,24(sp)
    800095f8:	00058913          	mv	s2,a1
    800095fc:	00060993          	mv	s3,a2
    80009600:	925fb0ef          	jal	ra,80004f24 <rt_malloc>
    80009604:	00050413          	mv	s0,a0
    80009608:	1a050863          	beqz	a0,800097b8 <directory_delete_for_msh+0x204>
    8000960c:	00048513          	mv	a0,s1
    80009610:	18c040ef          	jal	ra,8000d79c <opendir>
    80009614:	00050a13          	mv	s4,a0
    80009618:	0a050463          	beqz	a0,800096c0 <directory_delete_for_msh+0x10c>
    8000961c:	00009b17          	auipc	s6,0x9
    80009620:	d84b0b13          	addi	s6,s6,-636 # 800123a0 <__fsym___cmd_help_name+0x28>
    80009624:	00009b97          	auipc	s7,0x9
    80009628:	d84b8b93          	addi	s7,s7,-636 # 800123a8 <__fsym___cmd_help_name+0x30>
    8000962c:	00100c13          	li	s8,1
    80009630:	00200c93          	li	s9,2
    80009634:	00009d17          	auipc	s10,0x9
    80009638:	d7cd0d13          	addi	s10,s10,-644 # 800123b0 <__fsym___cmd_help_name+0x38>
    8000963c:	00009d97          	auipc	s11,0x9
    80009640:	d4cd8d93          	addi	s11,s11,-692 # 80012388 <__fsym___cmd_help_name+0x10>
    80009644:	000a0513          	mv	a0,s4
    80009648:	218040ef          	jal	ra,8000d860 <readdir>
    8000964c:	00050a93          	mv	s5,a0
    80009650:	0e050663          	beqz	a0,8000973c <directory_delete_for_msh+0x188>
    80009654:	00450693          	addi	a3,a0,4
    80009658:	00068593          	mv	a1,a3
    8000965c:	0000a517          	auipc	a0,0xa
    80009660:	5ec50513          	addi	a0,a0,1516 # 80013c48 <__fsym_mkdir_name+0x90>
    80009664:	00d13423          	sd	a3,8(sp)
    80009668:	c71fc0ef          	jal	ra,800062d8 <rt_strcmp>
    8000966c:	00813683          	ld	a3,8(sp)
    80009670:	fc050ae3          	beqz	a0,80009644 <directory_delete_for_msh+0x90>
    80009674:	00068593          	mv	a1,a3
    80009678:	000b0513          	mv	a0,s6
    8000967c:	c5dfc0ef          	jal	ra,800062d8 <rt_strcmp>
    80009680:	00813683          	ld	a3,8(sp)
    80009684:	fc0500e3          	beqz	a0,80009644 <directory_delete_for_msh+0x90>
    80009688:	00048613          	mv	a2,s1
    8000968c:	000b8593          	mv	a1,s7
    80009690:	00040513          	mv	a0,s0
    80009694:	aa0fd0ef          	jal	ra,80006934 <rt_sprintf>
    80009698:	000ac783          	lbu	a5,0(s5)
    8000969c:	09879463          	bne	a5,s8,80009724 <directory_delete_for_msh+0x170>
    800096a0:	00040513          	mv	a0,s0
    800096a4:	0a0040ef          	jal	ra,8000d744 <unlink>
    800096a8:	06050663          	beqz	a0,80009714 <directory_delete_for_msh+0x160>
    800096ac:	f8091ce3          	bnez	s2,80009644 <directory_delete_for_msh+0x90>
    800096b0:	00040593          	mv	a1,s0
    800096b4:	000d8513          	mv	a0,s11
    800096b8:	b34fd0ef          	jal	ra,800069ec <rt_kprintf>
    800096bc:	f89ff06f          	j	80009644 <directory_delete_for_msh+0x90>
    800096c0:	00091a63          	bnez	s2,800096d4 <directory_delete_for_msh+0x120>
    800096c4:	00048593          	mv	a1,s1
    800096c8:	00009517          	auipc	a0,0x9
    800096cc:	cc050513          	addi	a0,a0,-832 # 80012388 <__fsym___cmd_help_name+0x10>
    800096d0:	b1cfd0ef          	jal	ra,800069ec <rt_kprintf>
    800096d4:	00040513          	mv	a0,s0
    800096d8:	07013403          	ld	s0,112(sp)
    800096dc:	07813083          	ld	ra,120(sp)
    800096e0:	06813483          	ld	s1,104(sp)
    800096e4:	06013903          	ld	s2,96(sp)
    800096e8:	05813983          	ld	s3,88(sp)
    800096ec:	05013a03          	ld	s4,80(sp)
    800096f0:	04813a83          	ld	s5,72(sp)
    800096f4:	04013b03          	ld	s6,64(sp)
    800096f8:	03813b83          	ld	s7,56(sp)
    800096fc:	03013c03          	ld	s8,48(sp)
    80009700:	02813c83          	ld	s9,40(sp)
    80009704:	02013d03          	ld	s10,32(sp)
    80009708:	01813d83          	ld	s11,24(sp)
    8000970c:	08010113          	addi	sp,sp,128
    80009710:	b61fb06f          	j	80005270 <rt_free>
    80009714:	f20988e3          	beqz	s3,80009644 <directory_delete_for_msh+0x90>
    80009718:	00040593          	mv	a1,s0
    8000971c:	000d0513          	mv	a0,s10
    80009720:	f99ff06f          	j	800096b8 <directory_delete_for_msh+0x104>
    80009724:	f39790e3          	bne	a5,s9,80009644 <directory_delete_for_msh+0x90>
    80009728:	00098613          	mv	a2,s3
    8000972c:	00090593          	mv	a1,s2
    80009730:	00040513          	mv	a0,s0
    80009734:	e81ff0ef          	jal	ra,800095b4 <directory_delete_for_msh>
    80009738:	f0dff06f          	j	80009644 <directory_delete_for_msh+0x90>
    8000973c:	000a0513          	mv	a0,s4
    80009740:	250040ef          	jal	ra,8000d990 <closedir>
    80009744:	00040513          	mv	a0,s0
    80009748:	b29fb0ef          	jal	ra,80005270 <rt_free>
    8000974c:	00048513          	mv	a0,s1
    80009750:	7f5030ef          	jal	ra,8000d744 <unlink>
    80009754:	04050863          	beqz	a0,800097a4 <directory_delete_for_msh+0x1f0>
    80009758:	06091063          	bnez	s2,800097b8 <directory_delete_for_msh+0x204>
    8000975c:	00048593          	mv	a1,s1
    80009760:	00009517          	auipc	a0,0x9
    80009764:	c2850513          	addi	a0,a0,-984 # 80012388 <__fsym___cmd_help_name+0x10>
    80009768:	07013403          	ld	s0,112(sp)
    8000976c:	07813083          	ld	ra,120(sp)
    80009770:	06813483          	ld	s1,104(sp)
    80009774:	06013903          	ld	s2,96(sp)
    80009778:	05813983          	ld	s3,88(sp)
    8000977c:	05013a03          	ld	s4,80(sp)
    80009780:	04813a83          	ld	s5,72(sp)
    80009784:	04013b03          	ld	s6,64(sp)
    80009788:	03813b83          	ld	s7,56(sp)
    8000978c:	03013c03          	ld	s8,48(sp)
    80009790:	02813c83          	ld	s9,40(sp)
    80009794:	02013d03          	ld	s10,32(sp)
    80009798:	01813d83          	ld	s11,24(sp)
    8000979c:	08010113          	addi	sp,sp,128
    800097a0:	a4cfd06f          	j	800069ec <rt_kprintf>
    800097a4:	00098a63          	beqz	s3,800097b8 <directory_delete_for_msh+0x204>
    800097a8:	00048593          	mv	a1,s1
    800097ac:	00009517          	auipc	a0,0x9
    800097b0:	c1450513          	addi	a0,a0,-1004 # 800123c0 <__fsym___cmd_help_name+0x48>
    800097b4:	fb5ff06f          	j	80009768 <directory_delete_for_msh+0x1b4>
    800097b8:	07813083          	ld	ra,120(sp)
    800097bc:	07013403          	ld	s0,112(sp)
    800097c0:	06813483          	ld	s1,104(sp)
    800097c4:	06013903          	ld	s2,96(sp)
    800097c8:	05813983          	ld	s3,88(sp)
    800097cc:	05013a03          	ld	s4,80(sp)
    800097d0:	04813a83          	ld	s5,72(sp)
    800097d4:	04013b03          	ld	s6,64(sp)
    800097d8:	03813b83          	ld	s7,56(sp)
    800097dc:	03013c03          	ld	s8,48(sp)
    800097e0:	02813c83          	ld	s9,40(sp)
    800097e4:	02013d03          	ld	s10,32(sp)
    800097e8:	01813d83          	ld	s11,24(sp)
    800097ec:	08010113          	addi	sp,sp,128
    800097f0:	00008067          	ret
    800097f4:	00008067          	ret

00000000800097f8 <cmd_rm>:
    800097f8:	f1010113          	addi	sp,sp,-240
    800097fc:	0e113423          	sd	ra,232(sp)
    80009800:	0e813023          	sd	s0,224(sp)
    80009804:	0c913c23          	sd	s1,216(sp)
    80009808:	0d213823          	sd	s2,208(sp)
    8000980c:	0d313423          	sd	s3,200(sp)
    80009810:	0d413023          	sd	s4,192(sp)
    80009814:	0b513c23          	sd	s5,184(sp)
    80009818:	0b613823          	sd	s6,176(sp)
    8000981c:	0b713423          	sd	s7,168(sp)
    80009820:	0b813023          	sd	s8,160(sp)
    80009824:	09913c23          	sd	s9,152(sp)
    80009828:	09a13823          	sd	s10,144(sp)
    8000982c:	09b13423          	sd	s11,136(sp)
    80009830:	00100793          	li	a5,1
    80009834:	04f51e63          	bne	a0,a5,80009890 <cmd_rm+0x98>
    80009838:	00009517          	auipc	a0,0x9
    8000983c:	ba050513          	addi	a0,a0,-1120 # 800123d8 <__fsym___cmd_help_name+0x60>
    80009840:	9acfd0ef          	jal	ra,800069ec <rt_kprintf>
    80009844:	00009517          	auipc	a0,0x9
    80009848:	bb450513          	addi	a0,a0,-1100 # 800123f8 <__fsym___cmd_help_name+0x80>
    8000984c:	9a0fd0ef          	jal	ra,800069ec <rt_kprintf>
    80009850:	0e813083          	ld	ra,232(sp)
    80009854:	0e013403          	ld	s0,224(sp)
    80009858:	0d813483          	ld	s1,216(sp)
    8000985c:	0d013903          	ld	s2,208(sp)
    80009860:	0c813983          	ld	s3,200(sp)
    80009864:	0c013a03          	ld	s4,192(sp)
    80009868:	0b813a83          	ld	s5,184(sp)
    8000986c:	0b013b03          	ld	s6,176(sp)
    80009870:	0a813b83          	ld	s7,168(sp)
    80009874:	0a013c03          	ld	s8,160(sp)
    80009878:	09813c83          	ld	s9,152(sp)
    8000987c:	09013d03          	ld	s10,144(sp)
    80009880:	08813d83          	ld	s11,136(sp)
    80009884:	00000513          	li	a0,0
    80009888:	0f010113          	addi	sp,sp,240
    8000988c:	00008067          	ret
    80009890:	0085b783          	ld	a5,8(a1)
    80009894:	02d00713          	li	a4,45
    80009898:	00050493          	mv	s1,a0
    8000989c:	0007c683          	lbu	a3,0(a5)
    800098a0:	00058413          	mv	s0,a1
    800098a4:	00000993          	li	s3,0
    800098a8:	00000a93          	li	s5,0
    800098ac:	00000913          	li	s2,0
    800098b0:	02e69263          	bne	a3,a4,800098d4 <cmd_rm+0xdc>
    800098b4:	07200713          	li	a4,114
    800098b8:	07600693          	li	a3,118
    800098bc:	02d00613          	li	a2,45
    800098c0:	06600513          	li	a0,102
    800098c4:	0007c583          	lbu	a1,0(a5)
    800098c8:	06059c63          	bnez	a1,80009940 <cmd_rm+0x148>
    800098cc:	fff4849b          	addiw	s1,s1,-1
    800098d0:	00840413          	addi	s0,s0,8
    800098d4:	00840413          	addi	s0,s0,8
    800098d8:	00100a13          	li	s4,1
    800098dc:	00009b17          	auipc	s6,0x9
    800098e0:	b7cb0b13          	addi	s6,s6,-1156 # 80012458 <__fsym___cmd_help_name+0xe0>
    800098e4:	00004bb7          	lui	s7,0x4
    800098e8:	00008c37          	lui	s8,0x8
    800098ec:	00009c97          	auipc	s9,0x9
    800098f0:	ac4c8c93          	addi	s9,s9,-1340 # 800123b0 <__fsym___cmd_help_name+0x38>
    800098f4:	00009d17          	auipc	s10,0x9
    800098f8:	a94d0d13          	addi	s10,s10,-1388 # 80012388 <__fsym___cmd_help_name+0x10>
    800098fc:	00009d97          	auipc	s11,0x9
    80009900:	b34d8d93          	addi	s11,s11,-1228 # 80012430 <__fsym___cmd_help_name+0xb8>
    80009904:	f49a56e3          	bge	s4,s1,80009850 <cmd_rm+0x58>
    80009908:	00043503          	ld	a0,0(s0)
    8000990c:	00010593          	mv	a1,sp
    80009910:	661030ef          	jal	ra,8000d770 <stat>
    80009914:	0a051e63          	bnez	a0,800099d0 <cmd_rm+0x1d8>
    80009918:	01012783          	lw	a5,16(sp)
    8000991c:	0177f733          	and	a4,a5,s7
    80009920:	0007071b          	sext.w	a4,a4
    80009924:	06070a63          	beqz	a4,80009998 <cmd_rm+0x1a0>
    80009928:	00043503          	ld	a0,0(s0)
    8000992c:	040a9a63          	bnez	s5,80009980 <cmd_rm+0x188>
    80009930:	00050593          	mv	a1,a0
    80009934:	000d8513          	mv	a0,s11
    80009938:	8b4fd0ef          	jal	ra,800069ec <rt_kprintf>
    8000993c:	0500006f          	j	8000998c <cmd_rm+0x194>
    80009940:	02e58663          	beq	a1,a4,8000996c <cmd_rm+0x174>
    80009944:	00b76e63          	bltu	a4,a1,80009960 <cmd_rm+0x168>
    80009948:	02c58463          	beq	a1,a2,80009970 <cmd_rm+0x178>
    8000994c:	02a58663          	beq	a1,a0,80009978 <cmd_rm+0x180>
    80009950:	00009517          	auipc	a0,0x9
    80009954:	ac850513          	addi	a0,a0,-1336 # 80012418 <__fsym___cmd_help_name+0xa0>
    80009958:	894fd0ef          	jal	ra,800069ec <rt_kprintf>
    8000995c:	ef5ff06f          	j	80009850 <cmd_rm+0x58>
    80009960:	fed598e3          	bne	a1,a3,80009950 <cmd_rm+0x158>
    80009964:	00100993          	li	s3,1
    80009968:	0080006f          	j	80009970 <cmd_rm+0x178>
    8000996c:	00100a93          	li	s5,1
    80009970:	00178793          	addi	a5,a5,1
    80009974:	f51ff06f          	j	800098c4 <cmd_rm+0xcc>
    80009978:	00100913          	li	s2,1
    8000997c:	ff5ff06f          	j	80009970 <cmd_rm+0x178>
    80009980:	00098613          	mv	a2,s3
    80009984:	00090593          	mv	a1,s2
    80009988:	c2dff0ef          	jal	ra,800095b4 <directory_delete_for_msh>
    8000998c:	001a0a1b          	addiw	s4,s4,1
    80009990:	00840413          	addi	s0,s0,8
    80009994:	f71ff06f          	j	80009904 <cmd_rm+0x10c>
    80009998:	0187f7b3          	and	a5,a5,s8
    8000999c:	0007879b          	sext.w	a5,a5
    800099a0:	fe0786e3          	beqz	a5,8000998c <cmd_rm+0x194>
    800099a4:	00043503          	ld	a0,0(s0)
    800099a8:	59d030ef          	jal	ra,8000d744 <unlink>
    800099ac:	00050a63          	beqz	a0,800099c0 <cmd_rm+0x1c8>
    800099b0:	fc091ee3          	bnez	s2,8000998c <cmd_rm+0x194>
    800099b4:	00043583          	ld	a1,0(s0)
    800099b8:	000d0513          	mv	a0,s10
    800099bc:	f7dff06f          	j	80009938 <cmd_rm+0x140>
    800099c0:	fc0986e3          	beqz	s3,8000998c <cmd_rm+0x194>
    800099c4:	00043583          	ld	a1,0(s0)
    800099c8:	000c8513          	mv	a0,s9
    800099cc:	f6dff06f          	j	80009938 <cmd_rm+0x140>
    800099d0:	fa091ee3          	bnez	s2,8000998c <cmd_rm+0x194>
    800099d4:	00043583          	ld	a1,0(s0)
    800099d8:	000b0513          	mv	a0,s6
    800099dc:	f5dff06f          	j	80009938 <cmd_rm+0x140>

00000000800099e0 <cmd_mkfs>:
    800099e0:	ff010113          	addi	sp,sp,-16
    800099e4:	00813023          	sd	s0,0(sp)
    800099e8:	00113423          	sd	ra,8(sp)
    800099ec:	00200793          	li	a5,2
    800099f0:	00058413          	mv	s0,a1
    800099f4:	02f51663          	bne	a0,a5,80009a20 <cmd_mkfs+0x40>
    800099f8:	0085b583          	ld	a1,8(a1)
    800099fc:	00009517          	auipc	a0,0x9
    80009a00:	a8c50513          	addi	a0,a0,-1396 # 80012488 <__fsym___cmd_help_name+0x110>
    80009a04:	668040ef          	jal	ra,8000e06c <dfs_mkfs>
    80009a08:	00050593          	mv	a1,a0
    80009a0c:	04050463          	beqz	a0,80009a54 <cmd_mkfs+0x74>
    80009a10:	00009517          	auipc	a0,0x9
    80009a14:	aa850513          	addi	a0,a0,-1368 # 800124b8 <__fsym___cmd_help_name+0x140>
    80009a18:	fd5fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009a1c:	0380006f          	j	80009a54 <cmd_mkfs+0x74>
    80009a20:	00400793          	li	a5,4
    80009a24:	02f51263          	bne	a0,a5,80009a48 <cmd_mkfs+0x68>
    80009a28:	00843503          	ld	a0,8(s0)
    80009a2c:	00009597          	auipc	a1,0x9
    80009a30:	a6458593          	addi	a1,a1,-1436 # 80012490 <__fsym___cmd_help_name+0x118>
    80009a34:	920fa0ef          	jal	ra,80003b54 <strcmp>
    80009a38:	00051e63          	bnez	a0,80009a54 <cmd_mkfs+0x74>
    80009a3c:	01843583          	ld	a1,24(s0)
    80009a40:	01043503          	ld	a0,16(s0)
    80009a44:	fc1ff06f          	j	80009a04 <cmd_mkfs+0x24>
    80009a48:	00009517          	auipc	a0,0x9
    80009a4c:	a5050513          	addi	a0,a0,-1456 # 80012498 <__fsym___cmd_help_name+0x120>
    80009a50:	f9dfc0ef          	jal	ra,800069ec <rt_kprintf>
    80009a54:	00813083          	ld	ra,8(sp)
    80009a58:	00013403          	ld	s0,0(sp)
    80009a5c:	00000513          	li	a0,0
    80009a60:	01010113          	addi	sp,sp,16
    80009a64:	00008067          	ret

0000000080009a68 <cmd_mount>:
    80009a68:	fd010113          	addi	sp,sp,-48
    80009a6c:	02113423          	sd	ra,40(sp)
    80009a70:	02813023          	sd	s0,32(sp)
    80009a74:	00913c23          	sd	s1,24(sp)
    80009a78:	01213823          	sd	s2,16(sp)
    80009a7c:	00100793          	li	a5,1
    80009a80:	06f51c63          	bne	a0,a5,80009af8 <cmd_mount+0x90>
    80009a84:	00009517          	auipc	a0,0x9
    80009a88:	a4c50513          	addi	a0,a0,-1460 # 800124d0 <__fsym___cmd_help_name+0x158>
    80009a8c:	f61fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009a90:	00009517          	auipc	a0,0x9
    80009a94:	a6050513          	addi	a0,a0,-1440 # 800124f0 <__fsym___cmd_help_name+0x178>
    80009a98:	f55fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009a9c:	0001d417          	auipc	s0,0x1d
    80009aa0:	ec440413          	addi	s0,s0,-316 # 80026960 <filesystem_table>
    80009aa4:	00009917          	auipc	s2,0x9
    80009aa8:	a6c90913          	addi	s2,s2,-1428 # 80012510 <__fsym___cmd_help_name+0x198>
    80009aac:	0001d497          	auipc	s1,0x1d
    80009ab0:	ef448493          	addi	s1,s1,-268 # 800269a0 <fslock>
    80009ab4:	00843683          	ld	a3,8(s0)
    80009ab8:	00068c63          	beqz	a3,80009ad0 <cmd_mount+0x68>
    80009abc:	01043783          	ld	a5,16(s0)
    80009ac0:	00043603          	ld	a2,0(s0)
    80009ac4:	00090513          	mv	a0,s2
    80009ac8:	0007b583          	ld	a1,0(a5)
    80009acc:	f21fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009ad0:	02040413          	addi	s0,s0,32
    80009ad4:	fe9410e3          	bne	s0,s1,80009ab4 <cmd_mount+0x4c>
    80009ad8:	00000413          	li	s0,0
    80009adc:	02813083          	ld	ra,40(sp)
    80009ae0:	00040513          	mv	a0,s0
    80009ae4:	02013403          	ld	s0,32(sp)
    80009ae8:	01813483          	ld	s1,24(sp)
    80009aec:	01013903          	ld	s2,16(sp)
    80009af0:	03010113          	addi	sp,sp,48
    80009af4:	00008067          	ret
    80009af8:	00400793          	li	a5,4
    80009afc:	06f51663          	bne	a0,a5,80009b68 <cmd_mount+0x100>
    80009b00:	0085b403          	ld	s0,8(a1)
    80009b04:	0105b483          	ld	s1,16(a1)
    80009b08:	0185b603          	ld	a2,24(a1)
    80009b0c:	00009517          	auipc	a0,0x9
    80009b10:	a1c50513          	addi	a0,a0,-1508 # 80012528 <__fsym___cmd_help_name+0x1b0>
    80009b14:	00040593          	mv	a1,s0
    80009b18:	00048693          	mv	a3,s1
    80009b1c:	00c13423          	sd	a2,8(sp)
    80009b20:	ecdfc0ef          	jal	ra,800069ec <rt_kprintf>
    80009b24:	00813603          	ld	a2,8(sp)
    80009b28:	00040513          	mv	a0,s0
    80009b2c:	00000713          	li	a4,0
    80009b30:	00000693          	li	a3,0
    80009b34:	00048593          	mv	a1,s1
    80009b38:	1d0040ef          	jal	ra,8000dd08 <dfs_mount>
    80009b3c:	00050413          	mv	s0,a0
    80009b40:	00051a63          	bnez	a0,80009b54 <cmd_mount+0xec>
    80009b44:	00009517          	auipc	a0,0x9
    80009b48:	a0c50513          	addi	a0,a0,-1524 # 80012550 <__fsym___cmd_help_name+0x1d8>
    80009b4c:	ea1fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009b50:	f8dff06f          	j	80009adc <cmd_mount+0x74>
    80009b54:	00009517          	auipc	a0,0x9
    80009b58:	a0c50513          	addi	a0,a0,-1524 # 80012560 <__fsym___cmd_help_name+0x1e8>
    80009b5c:	e91fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009b60:	fff00413          	li	s0,-1
    80009b64:	f79ff06f          	j	80009adc <cmd_mount+0x74>
    80009b68:	00009517          	auipc	a0,0x9
    80009b6c:	a0850513          	addi	a0,a0,-1528 # 80012570 <__fsym___cmd_help_name+0x1f8>
    80009b70:	fedff06f          	j	80009b5c <cmd_mount+0xf4>

0000000080009b74 <cmd_umount>:
    80009b74:	ff010113          	addi	sp,sp,-16
    80009b78:	00813023          	sd	s0,0(sp)
    80009b7c:	00113423          	sd	ra,8(sp)
    80009b80:	00200793          	li	a5,2
    80009b84:	0085b403          	ld	s0,8(a1)
    80009b88:	02f50263          	beq	a0,a5,80009bac <cmd_umount+0x38>
    80009b8c:	00009517          	auipc	a0,0x9
    80009b90:	a1450513          	addi	a0,a0,-1516 # 800125a0 <__fsym___cmd_help_name+0x228>
    80009b94:	e59fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009b98:	fff00513          	li	a0,-1
    80009b9c:	00813083          	ld	ra,8(sp)
    80009ba0:	00013403          	ld	s0,0(sp)
    80009ba4:	01010113          	addi	sp,sp,16
    80009ba8:	00008067          	ret
    80009bac:	00009517          	auipc	a0,0x9
    80009bb0:	a1450513          	addi	a0,a0,-1516 # 800125c0 <__fsym___cmd_help_name+0x248>
    80009bb4:	00040593          	mv	a1,s0
    80009bb8:	e35fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009bbc:	00040513          	mv	a0,s0
    80009bc0:	3c8040ef          	jal	ra,8000df88 <dfs_unmount>
    80009bc4:	00055863          	bgez	a0,80009bd4 <cmd_umount+0x60>
    80009bc8:	00009517          	auipc	a0,0x9
    80009bcc:	99850513          	addi	a0,a0,-1640 # 80012560 <__fsym___cmd_help_name+0x1e8>
    80009bd0:	fc5ff06f          	j	80009b94 <cmd_umount+0x20>
    80009bd4:	00009517          	auipc	a0,0x9
    80009bd8:	97c50513          	addi	a0,a0,-1668 # 80012550 <__fsym___cmd_help_name+0x1d8>
    80009bdc:	e11fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009be0:	00000513          	li	a0,0
    80009be4:	fb9ff06f          	j	80009b9c <cmd_umount+0x28>

0000000080009be8 <cmd_tail>:
    80009be8:	fc010113          	addi	sp,sp,-64
    80009bec:	02113c23          	sd	ra,56(sp)
    80009bf0:	02813823          	sd	s0,48(sp)
    80009bf4:	02913423          	sd	s1,40(sp)
    80009bf8:	03213023          	sd	s2,32(sp)
    80009bfc:	01313c23          	sd	s3,24(sp)
    80009c00:	01413823          	sd	s4,16(sp)
    80009c04:	000107a3          	sb	zero,15(sp)
    80009c08:	00100713          	li	a4,1
    80009c0c:	02a74a63          	blt	a4,a0,80009c40 <cmd_tail+0x58>
    80009c10:	00009517          	auipc	a0,0x9
    80009c14:	9c050513          	addi	a0,a0,-1600 # 800125d0 <__fsym___cmd_help_name+0x258>
    80009c18:	dd5fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009c1c:	fff00513          	li	a0,-1
    80009c20:	03813083          	ld	ra,56(sp)
    80009c24:	03013403          	ld	s0,48(sp)
    80009c28:	02813483          	ld	s1,40(sp)
    80009c2c:	02013903          	ld	s2,32(sp)
    80009c30:	01813983          	ld	s3,24(sp)
    80009c34:	01013a03          	ld	s4,16(sp)
    80009c38:	04010113          	addi	sp,sp,64
    80009c3c:	00008067          	ret
    80009c40:	00050793          	mv	a5,a0
    80009c44:	00200713          	li	a4,2
    80009c48:	0085b503          	ld	a0,8(a1)
    80009c4c:	00058413          	mv	s0,a1
    80009c50:	06e78663          	beq	a5,a4,80009cbc <cmd_tail+0xd4>
    80009c54:	00009597          	auipc	a1,0x9
    80009c58:	9a458593          	addi	a1,a1,-1628 # 800125f8 <__fsym___cmd_help_name+0x280>
    80009c5c:	e7cfc0ef          	jal	ra,800062d8 <rt_strcmp>
    80009c60:	fa0518e3          	bnez	a0,80009c10 <cmd_tail+0x28>
    80009c64:	01043503          	ld	a0,16(s0)
    80009c68:	02b00793          	li	a5,43
    80009c6c:	00054703          	lbu	a4,0(a0)
    80009c70:	02f70c63          	beq	a4,a5,80009ca8 <cmd_tail+0xc0>
    80009c74:	f61f90ef          	jal	ra,80003bd4 <atoi>
    80009c78:	0005091b          	sext.w	s2,a0
    80009c7c:	00000993          	li	s3,0
    80009c80:	01843503          	ld	a0,24(s0)
    80009c84:	00000593          	li	a1,0
    80009c88:	7e0030ef          	jal	ra,8000d468 <open>
    80009c8c:	00050413          	mv	s0,a0
    80009c90:	00000493          	li	s1,0
    80009c94:	00a00a13          	li	s4,10
    80009c98:	02055e63          	bgez	a0,80009cd4 <cmd_tail+0xec>
    80009c9c:	00009517          	auipc	a0,0x9
    80009ca0:	96450513          	addi	a0,a0,-1692 # 80012600 <__fsym___cmd_help_name+0x288>
    80009ca4:	f75ff06f          	j	80009c18 <cmd_tail+0x30>
    80009ca8:	00150513          	addi	a0,a0,1
    80009cac:	f29f90ef          	jal	ra,80003bd4 <atoi>
    80009cb0:	0005099b          	sext.w	s3,a0
    80009cb4:	00000913          	li	s2,0
    80009cb8:	fc9ff06f          	j	80009c80 <cmd_tail+0x98>
    80009cbc:	00000993          	li	s3,0
    80009cc0:	00a00913          	li	s2,10
    80009cc4:	fc1ff06f          	j	80009c84 <cmd_tail+0x9c>
    80009cc8:	00f14783          	lbu	a5,15(sp)
    80009ccc:	01479463          	bne	a5,s4,80009cd4 <cmd_tail+0xec>
    80009cd0:	0014849b          	addiw	s1,s1,1
    80009cd4:	00100613          	li	a2,1
    80009cd8:	00f10593          	addi	a1,sp,15
    80009cdc:	00040513          	mv	a0,s0
    80009ce0:	09d030ef          	jal	ra,8000d57c <read>
    80009ce4:	fea042e3          	bgtz	a0,80009cc8 <cmd_tail+0xe0>
    80009ce8:	00048593          	mv	a1,s1
    80009cec:	00009517          	auipc	a0,0x9
    80009cf0:	92c50513          	addi	a0,a0,-1748 # 80012618 <__fsym___cmd_help_name+0x2a0>
    80009cf4:	cf9fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009cf8:	00098663          	beqz	s3,80009d04 <cmd_tail+0x11c>
    80009cfc:	0099f663          	bgeu	s3,s1,80009d08 <cmd_tail+0x120>
    80009d00:	4134893b          	subw	s2,s1,s3
    80009d04:	0124fe63          	bgeu	s1,s2,80009d20 <cmd_tail+0x138>
    80009d08:	00009517          	auipc	a0,0x9
    80009d0c:	93050513          	addi	a0,a0,-1744 # 80012638 <__fsym___cmd_help_name+0x2c0>
    80009d10:	cddfc0ef          	jal	ra,800069ec <rt_kprintf>
    80009d14:	00040513          	mv	a0,s0
    80009d18:	7fc030ef          	jal	ra,8000d514 <close>
    80009d1c:	f01ff06f          	j	80009c1c <cmd_tail+0x34>
    80009d20:	00090593          	mv	a1,s2
    80009d24:	00009517          	auipc	a0,0x9
    80009d28:	95450513          	addi	a0,a0,-1708 # 80012678 <__fsym___cmd_help_name+0x300>
    80009d2c:	cc1fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009d30:	00000613          	li	a2,0
    80009d34:	00000593          	li	a1,0
    80009d38:	00040513          	mv	a0,s0
    80009d3c:	412484bb          	subw	s1,s1,s2
    80009d40:	125030ef          	jal	ra,8000d664 <lseek>
    80009d44:	00000913          	li	s2,0
    80009d48:	00a00993          	li	s3,10
    80009d4c:	00007a17          	auipc	s4,0x7
    80009d50:	024a0a13          	addi	s4,s4,36 # 80010d70 <__FUNCTION__.1+0x120>
    80009d54:	00100613          	li	a2,1
    80009d58:	00f10593          	addi	a1,sp,15
    80009d5c:	00040513          	mv	a0,s0
    80009d60:	01d030ef          	jal	ra,8000d57c <read>
    80009d64:	02a04063          	bgtz	a0,80009d84 <cmd_tail+0x19c>
    80009d68:	00009517          	auipc	a0,0x9
    80009d6c:	ea850513          	addi	a0,a0,-344 # 80012c10 <__FUNCTION__.6+0x28>
    80009d70:	c7dfc0ef          	jal	ra,800069ec <rt_kprintf>
    80009d74:	00040513          	mv	a0,s0
    80009d78:	79c030ef          	jal	ra,8000d514 <close>
    80009d7c:	00000513          	li	a0,0
    80009d80:	ea1ff06f          	j	80009c20 <cmd_tail+0x38>
    80009d84:	00f14583          	lbu	a1,15(sp)
    80009d88:	01359463          	bne	a1,s3,80009d90 <cmd_tail+0x1a8>
    80009d8c:	0019091b          	addiw	s2,s2,1
    80009d90:	fd24f2e3          	bgeu	s1,s2,80009d54 <cmd_tail+0x16c>
    80009d94:	000a0513          	mv	a0,s4
    80009d98:	c55fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009d9c:	fb9ff06f          	j	80009d54 <cmd_tail+0x16c>

0000000080009da0 <cmd_cp>:
    80009da0:	ff010113          	addi	sp,sp,-16
    80009da4:	00113423          	sd	ra,8(sp)
    80009da8:	00300713          	li	a4,3
    80009dac:	02e50663          	beq	a0,a4,80009dd8 <cmd_cp+0x38>
    80009db0:	00009517          	auipc	a0,0x9
    80009db4:	8e850513          	addi	a0,a0,-1816 # 80012698 <__fsym___cmd_help_name+0x320>
    80009db8:	c35fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009dbc:	00009517          	auipc	a0,0x9
    80009dc0:	8f450513          	addi	a0,a0,-1804 # 800126b0 <__fsym___cmd_help_name+0x338>
    80009dc4:	c29fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009dc8:	00813083          	ld	ra,8(sp)
    80009dcc:	00000513          	li	a0,0
    80009dd0:	01010113          	addi	sp,sp,16
    80009dd4:	00008067          	ret
    80009dd8:	00058793          	mv	a5,a1
    80009ddc:	0087b503          	ld	a0,8(a5)
    80009de0:	0105b583          	ld	a1,16(a1)
    80009de4:	35c030ef          	jal	ra,8000d140 <copy>
    80009de8:	fe1ff06f          	j	80009dc8 <cmd_cp+0x28>

0000000080009dec <cmd_mv>:
    80009dec:	fe010113          	addi	sp,sp,-32
    80009df0:	00113c23          	sd	ra,24(sp)
    80009df4:	00813823          	sd	s0,16(sp)
    80009df8:	00913423          	sd	s1,8(sp)
    80009dfc:	01213023          	sd	s2,0(sp)
    80009e00:	00300793          	li	a5,3
    80009e04:	02f50e63          	beq	a0,a5,80009e40 <cmd_mv+0x54>
    80009e08:	00009517          	auipc	a0,0x9
    80009e0c:	8c050513          	addi	a0,a0,-1856 # 800126c8 <__fsym___cmd_help_name+0x350>
    80009e10:	bddfc0ef          	jal	ra,800069ec <rt_kprintf>
    80009e14:	00009517          	auipc	a0,0x9
    80009e18:	8cc50513          	addi	a0,a0,-1844 # 800126e0 <__fsym___cmd_help_name+0x368>
    80009e1c:	bd1fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009e20:	00000913          	li	s2,0
    80009e24:	01813083          	ld	ra,24(sp)
    80009e28:	01013403          	ld	s0,16(sp)
    80009e2c:	00813483          	ld	s1,8(sp)
    80009e30:	00090513          	mv	a0,s2
    80009e34:	00013903          	ld	s2,0(sp)
    80009e38:	02010113          	addi	sp,sp,32
    80009e3c:	00008067          	ret
    80009e40:	0105b603          	ld	a2,16(a1)
    80009e44:	00058413          	mv	s0,a1
    80009e48:	0085b583          	ld	a1,8(a1)
    80009e4c:	00009517          	auipc	a0,0x9
    80009e50:	8cc50513          	addi	a0,a0,-1844 # 80012718 <__fsym___cmd_help_name+0x3a0>
    80009e54:	b99fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009e58:	01043503          	ld	a0,16(s0)
    80009e5c:	00000613          	li	a2,0
    80009e60:	000105b7          	lui	a1,0x10
    80009e64:	604030ef          	jal	ra,8000d468 <open>
    80009e68:	08054c63          	bltz	a0,80009f00 <cmd_mv+0x114>
    80009e6c:	6a8030ef          	jal	ra,8000d514 <close>
    80009e70:	10000513          	li	a0,256
    80009e74:	8b0fb0ef          	jal	ra,80004f24 <rt_malloc>
    80009e78:	00050493          	mv	s1,a0
    80009e7c:	00051c63          	bnez	a0,80009e94 <cmd_mv+0xa8>
    80009e80:	00009517          	auipc	a0,0x9
    80009e84:	8a850513          	addi	a0,a0,-1880 # 80012728 <__fsym___cmd_help_name+0x3b0>
    80009e88:	b65fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009e8c:	ffb00913          	li	s2,-5
    80009e90:	f95ff06f          	j	80009e24 <cmd_mv+0x38>
    80009e94:	00843903          	ld	s2,8(s0)
    80009e98:	00090513          	mv	a0,s2
    80009e9c:	c60fc0ef          	jal	ra,800062fc <rt_strlen>
    80009ea0:	00843783          	ld	a5,8(s0)
    80009ea4:	00a90733          	add	a4,s2,a0
    80009ea8:	02f00693          	li	a3,47
    80009eac:	00f70663          	beq	a4,a5,80009eb8 <cmd_mv+0xcc>
    80009eb0:	00074603          	lbu	a2,0(a4)
    80009eb4:	04d61263          	bne	a2,a3,80009ef8 <cmd_mv+0x10c>
    80009eb8:	01043683          	ld	a3,16(s0)
    80009ebc:	00008617          	auipc	a2,0x8
    80009ec0:	4ec60613          	addi	a2,a2,1260 # 800123a8 <__fsym___cmd_help_name+0x30>
    80009ec4:	0ff00593          	li	a1,255
    80009ec8:	00048513          	mv	a0,s1
    80009ecc:	a25fc0ef          	jal	ra,800068f0 <rt_snprintf>
    80009ed0:	00843503          	ld	a0,8(s0)
    80009ed4:	00048593          	mv	a1,s1
    80009ed8:	00000913          	li	s2,0
    80009edc:	03d030ef          	jal	ra,8000d718 <rename>
    80009ee0:	f40482e3          	beqz	s1,80009e24 <cmd_mv+0x38>
    80009ee4:	01043783          	ld	a5,16(s0)
    80009ee8:	f2f48ee3          	beq	s1,a5,80009e24 <cmd_mv+0x38>
    80009eec:	00048513          	mv	a0,s1
    80009ef0:	b80fb0ef          	jal	ra,80005270 <rt_free>
    80009ef4:	f31ff06f          	j	80009e24 <cmd_mv+0x38>
    80009ef8:	fff70713          	addi	a4,a4,-1
    80009efc:	fb1ff06f          	j	80009eac <cmd_mv+0xc0>
    80009f00:	01043503          	ld	a0,16(s0)
    80009f04:	00000613          	li	a2,0
    80009f08:	00000593          	li	a1,0
    80009f0c:	55c030ef          	jal	ra,8000d468 <open>
    80009f10:	00054863          	bltz	a0,80009f20 <cmd_mv+0x134>
    80009f14:	600030ef          	jal	ra,8000d514 <close>
    80009f18:	01043503          	ld	a0,16(s0)
    80009f1c:	029030ef          	jal	ra,8000d744 <unlink>
    80009f20:	01043483          	ld	s1,16(s0)
    80009f24:	fadff06f          	j	80009ed0 <cmd_mv+0xe4>

0000000080009f28 <cmd_cat>:
    80009f28:	fe010113          	addi	sp,sp,-32
    80009f2c:	00113c23          	sd	ra,24(sp)
    80009f30:	00813823          	sd	s0,16(sp)
    80009f34:	00913423          	sd	s1,8(sp)
    80009f38:	01213023          	sd	s2,0(sp)
    80009f3c:	00100793          	li	a5,1
    80009f40:	04f51c63          	bne	a0,a5,80009f98 <cmd_cat+0x70>
    80009f44:	00008517          	auipc	a0,0x8
    80009f48:	7f450513          	addi	a0,a0,2036 # 80012738 <__fsym___cmd_help_name+0x3c0>
    80009f4c:	aa1fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009f50:	00009517          	auipc	a0,0x9
    80009f54:	80050513          	addi	a0,a0,-2048 # 80012750 <__fsym___cmd_help_name+0x3d8>
    80009f58:	a95fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009f5c:	01813083          	ld	ra,24(sp)
    80009f60:	01013403          	ld	s0,16(sp)
    80009f64:	00813483          	ld	s1,8(sp)
    80009f68:	00013903          	ld	s2,0(sp)
    80009f6c:	00000513          	li	a0,0
    80009f70:	02010113          	addi	sp,sp,32
    80009f74:	00008067          	ret
    80009f78:	00349793          	slli	a5,s1,0x3
    80009f7c:	00f907b3          	add	a5,s2,a5
    80009f80:	0007b503          	ld	a0,0(a5)
    80009f84:	14d020ef          	jal	ra,8000c8d0 <cat>
    80009f88:	00148493          	addi	s1,s1,1
    80009f8c:	0004879b          	sext.w	a5,s1
    80009f90:	fe87c4e3          	blt	a5,s0,80009f78 <cmd_cat+0x50>
    80009f94:	fc9ff06f          	j	80009f5c <cmd_cat+0x34>
    80009f98:	00050413          	mv	s0,a0
    80009f9c:	00058913          	mv	s2,a1
    80009fa0:	00000493          	li	s1,0
    80009fa4:	fe5ff06f          	j	80009f88 <cmd_cat+0x60>

0000000080009fa8 <cmd_cd>:
    80009fa8:	ff010113          	addi	sp,sp,-16
    80009fac:	00113423          	sd	ra,8(sp)
    80009fb0:	00813023          	sd	s0,0(sp)
    80009fb4:	00100793          	li	a5,1
    80009fb8:	02f51663          	bne	a0,a5,80009fe4 <cmd_cd+0x3c>
    80009fbc:	0000b597          	auipc	a1,0xb
    80009fc0:	6e458593          	addi	a1,a1,1764 # 800156a0 <working_directory>
    80009fc4:	00008517          	auipc	a0,0x8
    80009fc8:	2e450513          	addi	a0,a0,740 # 800122a8 <CSWTCH.17+0x80>
    80009fcc:	a21fc0ef          	jal	ra,800069ec <rt_kprintf>
    80009fd0:	00813083          	ld	ra,8(sp)
    80009fd4:	00013403          	ld	s0,0(sp)
    80009fd8:	00000513          	li	a0,0
    80009fdc:	01010113          	addi	sp,sp,16
    80009fe0:	00008067          	ret
    80009fe4:	00200793          	li	a5,2
    80009fe8:	fef514e3          	bne	a0,a5,80009fd0 <cmd_cd+0x28>
    80009fec:	0085b503          	ld	a0,8(a1)
    80009ff0:	00058413          	mv	s0,a1
    80009ff4:	219030ef          	jal	ra,8000da0c <chdir>
    80009ff8:	fc050ce3          	beqz	a0,80009fd0 <cmd_cd+0x28>
    80009ffc:	00843583          	ld	a1,8(s0)
    8000a000:	00008517          	auipc	a0,0x8
    8000a004:	76850513          	addi	a0,a0,1896 # 80012768 <__fsym___cmd_help_name+0x3f0>
    8000a008:	fc5ff06f          	j	80009fcc <cmd_cd+0x24>

000000008000a00c <cmd_mkdir>:
    8000a00c:	ff010113          	addi	sp,sp,-16
    8000a010:	00113423          	sd	ra,8(sp)
    8000a014:	00100713          	li	a4,1
    8000a018:	02e51663          	bne	a0,a4,8000a044 <cmd_mkdir+0x38>
    8000a01c:	00008517          	auipc	a0,0x8
    8000a020:	76450513          	addi	a0,a0,1892 # 80012780 <__fsym___cmd_help_name+0x408>
    8000a024:	9c9fc0ef          	jal	ra,800069ec <rt_kprintf>
    8000a028:	00008517          	auipc	a0,0x8
    8000a02c:	78050513          	addi	a0,a0,1920 # 800127a8 <__fsym___cmd_help_name+0x430>
    8000a030:	9bdfc0ef          	jal	ra,800069ec <rt_kprintf>
    8000a034:	00813083          	ld	ra,8(sp)
    8000a038:	00000513          	li	a0,0
    8000a03c:	01010113          	addi	sp,sp,16
    8000a040:	00008067          	ret
    8000a044:	00058793          	mv	a5,a1
    8000a048:	0087b503          	ld	a0,8(a5)
    8000a04c:	00000593          	li	a1,0
    8000a050:	378030ef          	jal	ra,8000d3c8 <mkdir>
    8000a054:	fe1ff06f          	j	8000a034 <cmd_mkdir+0x28>

000000008000a058 <cmd_df>:
    8000a058:	ff010113          	addi	sp,sp,-16
    8000a05c:	00113423          	sd	ra,8(sp)
    8000a060:	00813023          	sd	s0,0(sp)
    8000a064:	00200793          	li	a5,2
    8000a068:	00f50a63          	beq	a0,a5,8000a07c <cmd_df+0x24>
    8000a06c:	00008517          	auipc	a0,0x8
    8000a070:	28450513          	addi	a0,a0,644 # 800122f0 <CSWTCH.17+0xc8>
    8000a074:	198040ef          	jal	ra,8000e20c <df>
    8000a078:	03c0006f          	j	8000a0b4 <cmd_df+0x5c>
    8000a07c:	0085b403          	ld	s0,8(a1)
    8000a080:	00008597          	auipc	a1,0x8
    8000a084:	76058593          	addi	a1,a1,1888 # 800127e0 <__fsym___cmd_help_name+0x468>
    8000a088:	00040513          	mv	a0,s0
    8000a08c:	ac9f90ef          	jal	ra,80003b54 <strcmp>
    8000a090:	00050c63          	beqz	a0,8000a0a8 <cmd_df+0x50>
    8000a094:	00008597          	auipc	a1,0x8
    8000a098:	75458593          	addi	a1,a1,1876 # 800127e8 <__fsym___cmd_help_name+0x470>
    8000a09c:	00040513          	mv	a0,s0
    8000a0a0:	ab5f90ef          	jal	ra,80003b54 <strcmp>
    8000a0a4:	02051263          	bnez	a0,8000a0c8 <cmd_df+0x70>
    8000a0a8:	00008517          	auipc	a0,0x8
    8000a0ac:	74850513          	addi	a0,a0,1864 # 800127f0 <__fsym___cmd_help_name+0x478>
    8000a0b0:	93dfc0ef          	jal	ra,800069ec <rt_kprintf>
    8000a0b4:	00813083          	ld	ra,8(sp)
    8000a0b8:	00013403          	ld	s0,0(sp)
    8000a0bc:	00000513          	li	a0,0
    8000a0c0:	01010113          	addi	sp,sp,16
    8000a0c4:	00008067          	ret
    8000a0c8:	00040513          	mv	a0,s0
    8000a0cc:	fa9ff06f          	j	8000a074 <cmd_df+0x1c>

000000008000a0d0 <cmd_echo>:
    8000a0d0:	fd010113          	addi	sp,sp,-48
    8000a0d4:	02813023          	sd	s0,32(sp)
    8000a0d8:	02113423          	sd	ra,40(sp)
    8000a0dc:	00913c23          	sd	s1,24(sp)
    8000a0e0:	00200793          	li	a5,2
    8000a0e4:	00058413          	mv	s0,a1
    8000a0e8:	00f51c63          	bne	a0,a5,8000a100 <cmd_echo+0x30>
    8000a0ec:	0085b583          	ld	a1,8(a1)
    8000a0f0:	00008517          	auipc	a0,0x8
    8000a0f4:	1b850513          	addi	a0,a0,440 # 800122a8 <CSWTCH.17+0x80>
    8000a0f8:	8f5fc0ef          	jal	ra,800069ec <rt_kprintf>
    8000a0fc:	04c0006f          	j	8000a148 <cmd_echo+0x78>
    8000a100:	00300793          	li	a5,3
    8000a104:	06f51663          	bne	a0,a5,8000a170 <cmd_echo+0xa0>
    8000a108:	01043503          	ld	a0,16(s0)
    8000a10c:	00000613          	li	a2,0
    8000a110:	44200593          	li	a1,1090
    8000a114:	354030ef          	jal	ra,8000d468 <open>
    8000a118:	00050493          	mv	s1,a0
    8000a11c:	04054263          	bltz	a0,8000a160 <cmd_echo+0x90>
    8000a120:	00843583          	ld	a1,8(s0)
    8000a124:	00058513          	mv	a0,a1
    8000a128:	00b13423          	sd	a1,8(sp)
    8000a12c:	9c5f90ef          	jal	ra,80003af0 <strlen>
    8000a130:	00813583          	ld	a1,8(sp)
    8000a134:	00050613          	mv	a2,a0
    8000a138:	00048513          	mv	a0,s1
    8000a13c:	4b4030ef          	jal	ra,8000d5f0 <write>
    8000a140:	00048513          	mv	a0,s1
    8000a144:	3d0030ef          	jal	ra,8000d514 <close>
    8000a148:	02813083          	ld	ra,40(sp)
    8000a14c:	02013403          	ld	s0,32(sp)
    8000a150:	01813483          	ld	s1,24(sp)
    8000a154:	00000513          	li	a0,0
    8000a158:	03010113          	addi	sp,sp,48
    8000a15c:	00008067          	ret
    8000a160:	01043583          	ld	a1,16(s0)
    8000a164:	00008517          	auipc	a0,0x8
    8000a168:	69c50513          	addi	a0,a0,1692 # 80012800 <__fsym___cmd_help_name+0x488>
    8000a16c:	f8dff06f          	j	8000a0f8 <cmd_echo+0x28>
    8000a170:	00008517          	auipc	a0,0x8
    8000a174:	6a850513          	addi	a0,a0,1704 # 80012818 <__fsym___cmd_help_name+0x4a0>
    8000a178:	875fc0ef          	jal	ra,800069ec <rt_kprintf>
    8000a17c:	fcdff06f          	j	8000a148 <cmd_echo+0x78>

000000008000a180 <msh_exec_script>:
    8000a180:	22058463          	beqz	a1,8000a3a8 <msh_exec_script+0x228>
    8000a184:	fa010113          	addi	sp,sp,-96
    8000a188:	04813823          	sd	s0,80(sp)
    8000a18c:	05213023          	sd	s2,64(sp)
    8000a190:	04113c23          	sd	ra,88(sp)
    8000a194:	04913423          	sd	s1,72(sp)
    8000a198:	03313c23          	sd	s3,56(sp)
    8000a19c:	03413823          	sd	s4,48(sp)
    8000a1a0:	03513423          	sd	s5,40(sp)
    8000a1a4:	03613023          	sd	s6,32(sp)
    8000a1a8:	01713c23          	sd	s7,24(sp)
    8000a1ac:	00050913          	mv	s2,a0
    8000a1b0:	00000413          	li	s0,0
    8000a1b4:	02000713          	li	a4,32
    8000a1b8:	00900693          	li	a3,9
    8000a1bc:	008907b3          	add	a5,s2,s0
    8000a1c0:	0007c783          	lbu	a5,0(a5)
    8000a1c4:	0004099b          	sext.w	s3,s0
    8000a1c8:	00e78663          	beq	a5,a4,8000a1d4 <msh_exec_script+0x54>
    8000a1cc:	00d78463          	beq	a5,a3,8000a1d4 <msh_exec_script+0x54>
    8000a1d0:	12b9c863          	blt	s3,a1,8000a300 <msh_exec_script+0x180>
    8000a1d4:	0209851b          	addiw	a0,s3,32
    8000a1d8:	d4dfa0ef          	jal	ra,80004f24 <rt_malloc>
    8000a1dc:	00050493          	mv	s1,a0
    8000a1e0:	ffb00793          	li	a5,-5
    8000a1e4:	12050863          	beqz	a0,8000a314 <msh_exec_script+0x194>
    8000a1e8:	00040613          	mv	a2,s0
    8000a1ec:	00090593          	mv	a1,s2
    8000a1f0:	971f90ef          	jal	ra,80003b60 <memcpy>
    8000a1f4:	00848433          	add	s0,s1,s0
    8000a1f8:	00040023          	sb	zero,0(s0)
    8000a1fc:	00008597          	auipc	a1,0x8
    8000a200:	64458593          	addi	a1,a1,1604 # 80012840 <__fsym___cmd_help_name+0x4c8>
    8000a204:	00048513          	mv	a0,s1
    8000a208:	961f90ef          	jal	ra,80003b68 <strstr>
    8000a20c:	00051e63          	bnez	a0,8000a228 <msh_exec_script+0xa8>
    8000a210:	00008597          	auipc	a1,0x8
    8000a214:	63858593          	addi	a1,a1,1592 # 80012848 <__fsym___cmd_help_name+0x4d0>
    8000a218:	00048513          	mv	a0,s1
    8000a21c:	94df90ef          	jal	ra,80003b68 <strstr>
    8000a220:	fff00413          	li	s0,-1
    8000a224:	04050663          	beqz	a0,8000a270 <msh_exec_script+0xf0>
    8000a228:	00000613          	li	a2,0
    8000a22c:	00000593          	li	a1,0
    8000a230:	00048513          	mv	a0,s1
    8000a234:	234030ef          	jal	ra,8000d468 <open>
    8000a238:	00050413          	mv	s0,a0
    8000a23c:	02055a63          	bgez	a0,8000a270 <msh_exec_script+0xf0>
    8000a240:	00090713          	mv	a4,s2
    8000a244:	00098693          	mv	a3,s3
    8000a248:	00008617          	auipc	a2,0x8
    8000a24c:	60860613          	addi	a2,a2,1544 # 80012850 <__fsym___cmd_help_name+0x4d8>
    8000a250:	01f9859b          	addiw	a1,s3,31
    8000a254:	00048513          	mv	a0,s1
    8000a258:	e98fc0ef          	jal	ra,800068f0 <rt_snprintf>
    8000a25c:	00000613          	li	a2,0
    8000a260:	00000593          	li	a1,0
    8000a264:	00048513          	mv	a0,s1
    8000a268:	200030ef          	jal	ra,8000d468 <open>
    8000a26c:	00050413          	mv	s0,a0
    8000a270:	00048513          	mv	a0,s1
    8000a274:	ffdfa0ef          	jal	ra,80005270 <rt_free>
    8000a278:	fff00793          	li	a5,-1
    8000a27c:	08044c63          	bltz	s0,8000a314 <msh_exec_script+0x194>
    8000a280:	10000513          	li	a0,256
    8000a284:	ca1fa0ef          	jal	ra,80004f24 <rt_malloc>
    8000a288:	00050493          	mv	s1,a0
    8000a28c:	06050e63          	beqz	a0,8000a308 <msh_exec_script+0x188>
    8000a290:	00a00a13          	li	s4,10
    8000a294:	00d00a93          	li	s5,13
    8000a298:	10000b13          	li	s6,256
    8000a29c:	02000b93          	li	s7,32
    8000a2a0:	00100613          	li	a2,1
    8000a2a4:	00f10593          	addi	a1,sp,15
    8000a2a8:	00040513          	mv	a0,s0
    8000a2ac:	2d0030ef          	jal	ra,8000d57c <read>
    8000a2b0:	00100793          	li	a5,1
    8000a2b4:	0cf51e63          	bne	a0,a5,8000a390 <msh_exec_script+0x210>
    8000a2b8:	00f14783          	lbu	a5,15(sp)
    8000a2bc:	ff4782e3          	beq	a5,s4,8000a2a0 <msh_exec_script+0x120>
    8000a2c0:	ff5780e3          	beq	a5,s5,8000a2a0 <msh_exec_script+0x120>
    8000a2c4:	00f48023          	sb	a5,0(s1)
    8000a2c8:	00100913          	li	s2,1
    8000a2cc:	00100613          	li	a2,1
    8000a2d0:	00f10593          	addi	a1,sp,15
    8000a2d4:	00040513          	mv	a0,s0
    8000a2d8:	2a4030ef          	jal	ra,8000d57c <read>
    8000a2dc:	00100713          	li	a4,1
    8000a2e0:	0009099b          	sext.w	s3,s2
    8000a2e4:	012487b3          	add	a5,s1,s2
    8000a2e8:	00e51863          	bne	a0,a4,8000a2f8 <msh_exec_script+0x178>
    8000a2ec:	00f14703          	lbu	a4,15(sp)
    8000a2f0:	01470463          	beq	a4,s4,8000a2f8 <msh_exec_script+0x178>
    8000a2f4:	05571863          	bne	a4,s5,8000a344 <msh_exec_script+0x1c4>
    8000a2f8:	00078023          	sb	zero,0(a5)
    8000a2fc:	0580006f          	j	8000a354 <msh_exec_script+0x1d4>
    8000a300:	00140413          	addi	s0,s0,1
    8000a304:	eb9ff06f          	j	8000a1bc <msh_exec_script+0x3c>
    8000a308:	00040513          	mv	a0,s0
    8000a30c:	208030ef          	jal	ra,8000d514 <close>
    8000a310:	ffb00793          	li	a5,-5
    8000a314:	05813083          	ld	ra,88(sp)
    8000a318:	05013403          	ld	s0,80(sp)
    8000a31c:	04813483          	ld	s1,72(sp)
    8000a320:	04013903          	ld	s2,64(sp)
    8000a324:	03813983          	ld	s3,56(sp)
    8000a328:	03013a03          	ld	s4,48(sp)
    8000a32c:	02813a83          	ld	s5,40(sp)
    8000a330:	02013b03          	ld	s6,32(sp)
    8000a334:	01813b83          	ld	s7,24(sp)
    8000a338:	00078513          	mv	a0,a5
    8000a33c:	06010113          	addi	sp,sp,96
    8000a340:	00008067          	ret
    8000a344:	00e78023          	sb	a4,0(a5)
    8000a348:	00190913          	addi	s2,s2,1
    8000a34c:	f96910e3          	bne	s2,s6,8000a2cc <msh_exec_script+0x14c>
    8000a350:	10000993          	li	s3,256
    8000a354:	00000793          	li	a5,0
    8000a358:	00900693          	li	a3,9
    8000a35c:	00f48733          	add	a4,s1,a5
    8000a360:	00074703          	lbu	a4,0(a4)
    8000a364:	01770463          	beq	a4,s7,8000a36c <msh_exec_script+0x1ec>
    8000a368:	00d71863          	bne	a4,a3,8000a378 <msh_exec_script+0x1f8>
    8000a36c:	00178793          	addi	a5,a5,1
    8000a370:	0007861b          	sext.w	a2,a5
    8000a374:	ff3644e3          	blt	a2,s3,8000a35c <msh_exec_script+0x1dc>
    8000a378:	02300793          	li	a5,35
    8000a37c:	f2f702e3          	beq	a4,a5,8000a2a0 <msh_exec_script+0x120>
    8000a380:	00098593          	mv	a1,s3
    8000a384:	00048513          	mv	a0,s1
    8000a388:	b15fe0ef          	jal	ra,80008e9c <msh_exec>
    8000a38c:	f11ff06f          	j	8000a29c <msh_exec_script+0x11c>
    8000a390:	00040513          	mv	a0,s0
    8000a394:	180030ef          	jal	ra,8000d514 <close>
    8000a398:	00048513          	mv	a0,s1
    8000a39c:	ed5fa0ef          	jal	ra,80005270 <rt_free>
    8000a3a0:	00000793          	li	a5,0
    8000a3a4:	f71ff06f          	j	8000a314 <msh_exec_script+0x194>
    8000a3a8:	fff00793          	li	a5,-1
    8000a3ac:	00078513          	mv	a0,a5
    8000a3b0:	00008067          	ret

000000008000a3b4 <finsh_rx_ind>:
    8000a3b4:	ff010113          	addi	sp,sp,-16
    8000a3b8:	00813023          	sd	s0,0(sp)
    8000a3bc:	00013417          	auipc	s0,0x13
    8000a3c0:	64c40413          	addi	s0,s0,1612 # 8001da08 <shell>
    8000a3c4:	00043783          	ld	a5,0(s0)
    8000a3c8:	00113423          	sd	ra,8(sp)
    8000a3cc:	00079e63          	bnez	a5,8000a3e8 <finsh_rx_ind+0x34>
    8000a3d0:	0bf00613          	li	a2,191
    8000a3d4:	00008597          	auipc	a1,0x8
    8000a3d8:	7ec58593          	addi	a1,a1,2028 # 80012bc0 <__FUNCTION__.4>
    8000a3dc:	00008517          	auipc	a0,0x8
    8000a3e0:	72c50513          	addi	a0,a0,1836 # 80012b08 <__fsym___cmd_ls_name+0x10>
    8000a3e4:	f90fc0ef          	jal	ra,80006b74 <rt_assert_handler>
    8000a3e8:	00043503          	ld	a0,0(s0)
    8000a3ec:	d09fd0ef          	jal	ra,800080f4 <rt_sem_release>
    8000a3f0:	00813083          	ld	ra,8(sp)
    8000a3f4:	00013403          	ld	s0,0(sp)
    8000a3f8:	00000513          	li	a0,0
    8000a3fc:	01010113          	addi	sp,sp,16
    8000a400:	00008067          	ret

000000008000a404 <finsh_get_prompt>:
    8000a404:	00013797          	auipc	a5,0x13
    8000a408:	6047b783          	ld	a5,1540(a5) # 8001da08 <shell>
    8000a40c:	0447c783          	lbu	a5,68(a5)
    8000a410:	0027f793          	andi	a5,a5,2
    8000a414:	00079c63          	bnez	a5,8000a42c <finsh_get_prompt+0x28>
    8000a418:	0001c797          	auipc	a5,0x1c
    8000a41c:	42078023          	sb	zero,1056(a5) # 80026838 <finsh_prompt.8>
    8000a420:	0001c517          	auipc	a0,0x1c
    8000a424:	41850513          	addi	a0,a0,1048 # 80026838 <finsh_prompt.8>
    8000a428:	00008067          	ret
    8000a42c:	fe010113          	addi	sp,sp,-32
    8000a430:	00113c23          	sd	ra,24(sp)
    8000a434:	00813823          	sd	s0,16(sp)
    8000a438:	00913423          	sd	s1,8(sp)
    8000a43c:	00013597          	auipc	a1,0x13
    8000a440:	5c45b583          	ld	a1,1476(a1) # 8001da00 <finsh_prompt_custom>
    8000a444:	02058863          	beqz	a1,8000a474 <finsh_get_prompt+0x70>
    8000a448:	10000613          	li	a2,256
    8000a44c:	0001c517          	auipc	a0,0x1c
    8000a450:	3ec50513          	addi	a0,a0,1004 # 80026838 <finsh_prompt.8>
    8000a454:	ec4f90ef          	jal	ra,80003b18 <strncpy>
    8000a458:	01813083          	ld	ra,24(sp)
    8000a45c:	01013403          	ld	s0,16(sp)
    8000a460:	00813483          	ld	s1,8(sp)
    8000a464:	0001c517          	auipc	a0,0x1c
    8000a468:	3d450513          	addi	a0,a0,980 # 80026838 <finsh_prompt.8>
    8000a46c:	02010113          	addi	sp,sp,32
    8000a470:	00008067          	ret
    8000a474:	a21fe0ef          	jal	ra,80008e94 <msh_is_used>
    8000a478:	00008597          	auipc	a1,0x8
    8000a47c:	6a858593          	addi	a1,a1,1704 # 80012b20 <__fsym___cmd_ls_name+0x28>
    8000a480:	00051663          	bnez	a0,8000a48c <finsh_get_prompt+0x88>
    8000a484:	00008597          	auipc	a1,0x8
    8000a488:	6a458593          	addi	a1,a1,1700 # 80012b28 <__fsym___cmd_ls_name+0x30>
    8000a48c:	0001c517          	auipc	a0,0x1c
    8000a490:	3ac50513          	addi	a0,a0,940 # 80026838 <finsh_prompt.8>
    8000a494:	e60f90ef          	jal	ra,80003af4 <strcpy>
    8000a498:	0001c417          	auipc	s0,0x1c
    8000a49c:	3a040413          	addi	s0,s0,928 # 80026838 <finsh_prompt.8>
    8000a4a0:	00040513          	mv	a0,s0
    8000a4a4:	e59fb0ef          	jal	ra,800062fc <rt_strlen>
    8000a4a8:	00050493          	mv	s1,a0
    8000a4ac:	00040513          	mv	a0,s0
    8000a4b0:	e4dfb0ef          	jal	ra,800062fc <rt_strlen>
    8000a4b4:	10000593          	li	a1,256
    8000a4b8:	40a585b3          	sub	a1,a1,a0
    8000a4bc:	00940533          	add	a0,s0,s1
    8000a4c0:	604030ef          	jal	ra,8000dac4 <getcwd>
    8000a4c4:	00008597          	auipc	a1,0x8
    8000a4c8:	66c58593          	addi	a1,a1,1644 # 80012b30 <__fsym___cmd_ls_name+0x38>
    8000a4cc:	00040513          	mv	a0,s0
    8000a4d0:	e4cf90ef          	jal	ra,80003b1c <strcat>
    8000a4d4:	f85ff06f          	j	8000a458 <finsh_get_prompt+0x54>

000000008000a4d8 <shell_handle_history.isra.0>:
    8000a4d8:	ff010113          	addi	sp,sp,-16
    8000a4dc:	00813023          	sd	s0,0(sp)
    8000a4e0:	00050413          	mv	s0,a0
    8000a4e4:	00008517          	auipc	a0,0x8
    8000a4e8:	65450513          	addi	a0,a0,1620 # 80012b38 <__fsym___cmd_ls_name+0x40>
    8000a4ec:	00113423          	sd	ra,8(sp)
    8000a4f0:	cfcfc0ef          	jal	ra,800069ec <rt_kprintf>
    8000a4f4:	f11ff0ef          	jal	ra,8000a404 <finsh_get_prompt>
    8000a4f8:	1da40613          	addi	a2,s0,474
    8000a4fc:	00013403          	ld	s0,0(sp)
    8000a500:	00813083          	ld	ra,8(sp)
    8000a504:	00050593          	mv	a1,a0
    8000a508:	00008517          	auipc	a0,0x8
    8000a50c:	63850513          	addi	a0,a0,1592 # 80012b40 <__fsym___cmd_ls_name+0x48>
    8000a510:	01010113          	addi	sp,sp,16
    8000a514:	cd8fc06f          	j	800069ec <rt_kprintf>

000000008000a518 <finsh_set_prompt_mode>:
    8000a518:	fe010113          	addi	sp,sp,-32
    8000a51c:	00913423          	sd	s1,8(sp)
    8000a520:	00013497          	auipc	s1,0x13
    8000a524:	4e848493          	addi	s1,s1,1256 # 8001da08 <shell>
    8000a528:	0004b783          	ld	a5,0(s1)
    8000a52c:	00813823          	sd	s0,16(sp)
    8000a530:	00113c23          	sd	ra,24(sp)
    8000a534:	00050413          	mv	s0,a0
    8000a538:	00079e63          	bnez	a5,8000a554 <finsh_set_prompt_mode+0x3c>
    8000a53c:	0a300613          	li	a2,163
    8000a540:	00008597          	auipc	a1,0x8
    8000a544:	6a858593          	addi	a1,a1,1704 # 80012be8 <__FUNCTION__.6>
    8000a548:	00008517          	auipc	a0,0x8
    8000a54c:	5c050513          	addi	a0,a0,1472 # 80012b08 <__fsym___cmd_ls_name+0x10>
    8000a550:	e24fc0ef          	jal	ra,80006b74 <rt_assert_handler>
    8000a554:	0004b703          	ld	a4,0(s1)
    8000a558:	00147413          	andi	s0,s0,1
    8000a55c:	0014141b          	slliw	s0,s0,0x1
    8000a560:	04474783          	lbu	a5,68(a4)
    8000a564:	01813083          	ld	ra,24(sp)
    8000a568:	00813483          	ld	s1,8(sp)
    8000a56c:	ffd7f793          	andi	a5,a5,-3
    8000a570:	0087e433          	or	s0,a5,s0
    8000a574:	04870223          	sb	s0,68(a4)
    8000a578:	01013403          	ld	s0,16(sp)
    8000a57c:	02010113          	addi	sp,sp,32
    8000a580:	00008067          	ret

000000008000a584 <finsh_system_init>:
    8000a584:	0000a797          	auipc	a5,0xa
    8000a588:	e5c78793          	addi	a5,a5,-420 # 800143e0 <__fsym___cmd_reboot>
    8000a58c:	00013717          	auipc	a4,0x13
    8000a590:	44f73a23          	sd	a5,1108(a4) # 8001d9e0 <_syscall_table_begin>
    8000a594:	0000a797          	auipc	a5,0xa
    8000a598:	3bc78793          	addi	a5,a5,956 # 80014950 <__rt_init_rti_start>
    8000a59c:	00013717          	auipc	a4,0x13
    8000a5a0:	44f73623          	sd	a5,1100(a4) # 8001d9e8 <_syscall_table_end>
    8000a5a4:	0000a797          	auipc	a5,0xa
    8000a5a8:	3ac78793          	addi	a5,a5,940 # 80014950 <__rt_init_rti_start>
    8000a5ac:	fe010113          	addi	sp,sp,-32
    8000a5b0:	00013717          	auipc	a4,0x13
    8000a5b4:	44f73023          	sd	a5,1088(a4) # 8001d9f0 <_sysvar_table_begin>
    8000a5b8:	23800593          	li	a1,568
    8000a5bc:	0000a797          	auipc	a5,0xa
    8000a5c0:	39478793          	addi	a5,a5,916 # 80014950 <__rt_init_rti_start>
    8000a5c4:	00100513          	li	a0,1
    8000a5c8:	00913423          	sd	s1,8(sp)
    8000a5cc:	00113c23          	sd	ra,24(sp)
    8000a5d0:	00813823          	sd	s0,16(sp)
    8000a5d4:	00013717          	auipc	a4,0x13
    8000a5d8:	42f73223          	sd	a5,1060(a4) # 8001d9f8 <_sysvar_table_end>
    8000a5dc:	00013497          	auipc	s1,0x13
    8000a5e0:	42c48493          	addi	s1,s1,1068 # 8001da08 <shell>
    8000a5e4:	c49fa0ef          	jal	ra,8000522c <rt_calloc>
    8000a5e8:	00a4b023          	sd	a0,0(s1)
    8000a5ec:	02051663          	bnez	a0,8000a618 <finsh_system_init+0x94>
    8000a5f0:	00008517          	auipc	a0,0x8
    8000a5f4:	55850513          	addi	a0,a0,1368 # 80012b48 <__fsym___cmd_ls_name+0x50>
    8000a5f8:	bf4fc0ef          	jal	ra,800069ec <rt_kprintf>
    8000a5fc:	fff00493          	li	s1,-1
    8000a600:	01813083          	ld	ra,24(sp)
    8000a604:	01013403          	ld	s0,16(sp)
    8000a608:	00048513          	mv	a0,s1
    8000a60c:	00813483          	ld	s1,8(sp)
    8000a610:	02010113          	addi	sp,sp,32
    8000a614:	00008067          	ret
    8000a618:	00a00793          	li	a5,10
    8000a61c:	01400713          	li	a4,20
    8000a620:	000016b7          	lui	a3,0x1
    8000a624:	00000613          	li	a2,0
    8000a628:	00000597          	auipc	a1,0x0
    8000a62c:	15458593          	addi	a1,a1,340 # 8000a77c <finsh_thread_entry>
    8000a630:	00008517          	auipc	a0,0x8
    8000a634:	53050513          	addi	a0,a0,1328 # 80012b60 <__fsym___cmd_ls_name+0x68>
    8000a638:	ad1fc0ef          	jal	ra,80007108 <rt_thread_create>
    8000a63c:	00050413          	mv	s0,a0
    8000a640:	0004b503          	ld	a0,0(s1)
    8000a644:	00000693          	li	a3,0
    8000a648:	00000613          	li	a2,0
    8000a64c:	00008597          	auipc	a1,0x8
    8000a650:	51c58593          	addi	a1,a1,1308 # 80012b68 <__fsym___cmd_ls_name+0x70>
    8000a654:	839fd0ef          	jal	ra,80007e8c <rt_sem_init>
    8000a658:	00100513          	li	a0,1
    8000a65c:	ebdff0ef          	jal	ra,8000a518 <finsh_set_prompt_mode>
    8000a660:	00000493          	li	s1,0
    8000a664:	f8040ee3          	beqz	s0,8000a600 <finsh_system_init+0x7c>
    8000a668:	00040513          	mv	a0,s0
    8000a66c:	ef1fc0ef          	jal	ra,8000755c <rt_thread_startup>
    8000a670:	f91ff06f          	j	8000a600 <finsh_system_init+0x7c>

000000008000a674 <finsh_set_device>:
    8000a674:	fe010113          	addi	sp,sp,-32
    8000a678:	00913423          	sd	s1,8(sp)
    8000a67c:	00013497          	auipc	s1,0x13
    8000a680:	38c48493          	addi	s1,s1,908 # 8001da08 <shell>
    8000a684:	0004b783          	ld	a5,0(s1)
    8000a688:	01213023          	sd	s2,0(sp)
    8000a68c:	00113c23          	sd	ra,24(sp)
    8000a690:	00813823          	sd	s0,16(sp)
    8000a694:	00050913          	mv	s2,a0
    8000a698:	00079e63          	bnez	a5,8000a6b4 <finsh_set_device+0x40>
    8000a69c:	0d200613          	li	a2,210
    8000a6a0:	00008597          	auipc	a1,0x8
    8000a6a4:	53058593          	addi	a1,a1,1328 # 80012bd0 <__FUNCTION__.5>
    8000a6a8:	00008517          	auipc	a0,0x8
    8000a6ac:	46050513          	addi	a0,a0,1120 # 80012b08 <__fsym___cmd_ls_name+0x10>
    8000a6b0:	cc4fc0ef          	jal	ra,80006b74 <rt_assert_handler>
    8000a6b4:	00090513          	mv	a0,s2
    8000a6b8:	fc5fa0ef          	jal	ra,8000567c <rt_device_find>
    8000a6bc:	00050413          	mv	s0,a0
    8000a6c0:	02051463          	bnez	a0,8000a6e8 <finsh_set_device+0x74>
    8000a6c4:	01013403          	ld	s0,16(sp)
    8000a6c8:	01813083          	ld	ra,24(sp)
    8000a6cc:	00813483          	ld	s1,8(sp)
    8000a6d0:	00090593          	mv	a1,s2
    8000a6d4:	00013903          	ld	s2,0(sp)
    8000a6d8:	00008517          	auipc	a0,0x8
    8000a6dc:	49850513          	addi	a0,a0,1176 # 80012b70 <__fsym___cmd_ls_name+0x78>
    8000a6e0:	02010113          	addi	sp,sp,32
    8000a6e4:	b08fc06f          	j	800069ec <rt_kprintf>
    8000a6e8:	0004b783          	ld	a5,0(s1)
    8000a6ec:	2307b783          	ld	a5,560(a5)
    8000a6f0:	06a78a63          	beq	a5,a0,8000a764 <finsh_set_device+0xf0>
    8000a6f4:	04300593          	li	a1,67
    8000a6f8:	804fb0ef          	jal	ra,800056fc <rt_device_open>
    8000a6fc:	06051463          	bnez	a0,8000a764 <finsh_set_device+0xf0>
    8000a700:	0004b783          	ld	a5,0(s1)
    8000a704:	2307b503          	ld	a0,560(a5)
    8000a708:	00050c63          	beqz	a0,8000a720 <finsh_set_device+0xac>
    8000a70c:	948fb0ef          	jal	ra,80005854 <rt_device_close>
    8000a710:	0004b783          	ld	a5,0(s1)
    8000a714:	00000593          	li	a1,0
    8000a718:	2307b503          	ld	a0,560(a5)
    8000a71c:	c38fb0ef          	jal	ra,80005b54 <rt_device_set_rx_indicate>
    8000a720:	0004b503          	ld	a0,0(s1)
    8000a724:	00000593          	li	a1,0
    8000a728:	05100613          	li	a2,81
    8000a72c:	1da50513          	addi	a0,a0,474
    8000a730:	c2cf90ef          	jal	ra,80003b5c <memset>
    8000a734:	0004b783          	ld	a5,0(s1)
    8000a738:	00040513          	mv	a0,s0
    8000a73c:	01813083          	ld	ra,24(sp)
    8000a740:	2287b823          	sd	s0,560(a5)
    8000a744:	01013403          	ld	s0,16(sp)
    8000a748:	00813483          	ld	s1,8(sp)
    8000a74c:	00013903          	ld	s2,0(sp)
    8000a750:	2207a623          	sw	zero,556(a5)
    8000a754:	00000597          	auipc	a1,0x0
    8000a758:	c6058593          	addi	a1,a1,-928 # 8000a3b4 <finsh_rx_ind>
    8000a75c:	02010113          	addi	sp,sp,32
    8000a760:	bf4fb06f          	j	80005b54 <rt_device_set_rx_indicate>
    8000a764:	01813083          	ld	ra,24(sp)
    8000a768:	01013403          	ld	s0,16(sp)
    8000a76c:	00813483          	ld	s1,8(sp)
    8000a770:	00013903          	ld	s2,0(sp)
    8000a774:	02010113          	addi	sp,sp,32
    8000a778:	00008067          	ret

000000008000a77c <finsh_thread_entry>:
    8000a77c:	f8010113          	addi	sp,sp,-128
    8000a780:	06913423          	sd	s1,104(sp)
    8000a784:	00013497          	auipc	s1,0x13
    8000a788:	28448493          	addi	s1,s1,644 # 8001da08 <shell>
    8000a78c:	0004b783          	ld	a5,0(s1)
    8000a790:	06113c23          	sd	ra,120(sp)
    8000a794:	06813823          	sd	s0,112(sp)
    8000a798:	0447c703          	lbu	a4,68(a5)
    8000a79c:	07213023          	sd	s2,96(sp)
    8000a7a0:	05313c23          	sd	s3,88(sp)
    8000a7a4:	05413823          	sd	s4,80(sp)
    8000a7a8:	05513423          	sd	s5,72(sp)
    8000a7ac:	05613023          	sd	s6,64(sp)
    8000a7b0:	03713c23          	sd	s7,56(sp)
    8000a7b4:	03813823          	sd	s8,48(sp)
    8000a7b8:	03913423          	sd	s9,40(sp)
    8000a7bc:	03a13023          	sd	s10,32(sp)
    8000a7c0:	01b13c23          	sd	s11,24(sp)
    8000a7c4:	00176713          	ori	a4,a4,1
    8000a7c8:	04e78223          	sb	a4,68(a5)
    8000a7cc:	2307b783          	ld	a5,560(a5)
    8000a7d0:	00079863          	bnez	a5,8000a7e0 <finsh_thread_entry+0x64>
    8000a7d4:	998fc0ef          	jal	ra,8000696c <rt_console_get_device>
    8000a7d8:	00050463          	beqz	a0,8000a7e0 <finsh_thread_entry+0x64>
    8000a7dc:	e99ff0ef          	jal	ra,8000a674 <finsh_set_device>
    8000a7e0:	c25ff0ef          	jal	ra,8000a404 <finsh_get_prompt>
    8000a7e4:	a08fc0ef          	jal	ra,800069ec <rt_kprintf>
    8000a7e8:	00008a17          	auipc	s4,0x8
    8000a7ec:	3c8a0a13          	addi	s4,s4,968 # 80012bb0 <__FUNCTION__.0>
    8000a7f0:	00008a97          	auipc	s5,0x8
    8000a7f4:	318a8a93          	addi	s5,s5,792 # 80012b08 <__fsym___cmd_ls_name+0x10>
    8000a7f8:	01b00993          	li	s3,27
    8000a7fc:	0fd00b13          	li	s6,253
    8000a800:	00900b93          	li	s7,9
    8000a804:	07f00c13          	li	s8,127
    8000a808:	00008917          	auipc	s2,0x8
    8000a80c:	38890913          	addi	s2,s2,904 # 80012b90 <__fsym___cmd_ls_name+0x98>
    8000a810:	0004b783          	ld	a5,0(s1)
    8000a814:	000107a3          	sb	zero,15(sp)
    8000a818:	00079a63          	bnez	a5,8000a82c <finsh_thread_entry+0xb0>
    8000a81c:	0af00613          	li	a2,175
    8000a820:	000a0593          	mv	a1,s4
    8000a824:	000a8513          	mv	a0,s5
    8000a828:	b4cfc0ef          	jal	ra,80006b74 <rt_assert_handler>
    8000a82c:	0004b783          	ld	a5,0(s1)
    8000a830:	00100693          	li	a3,1
    8000a834:	00f10613          	addi	a2,sp,15
    8000a838:	2307b503          	ld	a0,560(a5)
    8000a83c:	fff00593          	li	a1,-1
    8000a840:	8c0fb0ef          	jal	ra,80005900 <rt_device_read>
    8000a844:	00100793          	li	a5,1
    8000a848:	00f51e63          	bne	a0,a5,8000a864 <finsh_thread_entry+0xe8>
    8000a84c:	00f14c83          	lbu	s9,15(sp)
    8000a850:	0004b403          	ld	s0,0(s1)
    8000a854:	000c859b          	sext.w	a1,s9
    8000a858:	013c9c63          	bne	s9,s3,8000a870 <finsh_thread_entry+0xf4>
    8000a85c:	04a42023          	sw	a0,64(s0)
    8000a860:	fb1ff06f          	j	8000a810 <finsh_thread_entry+0x94>
    8000a864:	01400513          	li	a0,20
    8000a868:	c01fc0ef          	jal	ra,80007468 <rt_thread_mdelay>
    8000a86c:	fc1ff06f          	j	8000a82c <finsh_thread_entry+0xb0>
    8000a870:	04042783          	lw	a5,64(s0)
    8000a874:	02a79a63          	bne	a5,a0,8000a8a8 <finsh_thread_entry+0x12c>
    8000a878:	05b00793          	li	a5,91
    8000a87c:	00f59863          	bne	a1,a5,8000a88c <finsh_thread_entry+0x110>
    8000a880:	00200793          	li	a5,2
    8000a884:	04f42023          	sw	a5,64(s0)
    8000a888:	f89ff06f          	j	8000a810 <finsh_thread_entry+0x94>
    8000a88c:	04042023          	sw	zero,64(s0)
    8000a890:	fffc879b          	addiw	a5,s9,-1
    8000a894:	0ff7f793          	zext.b	a5,a5
    8000a898:	f6fb6ce3          	bltu	s6,a5,8000a810 <finsh_thread_entry+0x94>
    8000a89c:	19759463          	bne	a1,s7,8000aa24 <finsh_thread_entry+0x2a8>
    8000a8a0:	00000c93          	li	s9,0
    8000a8a4:	1180006f          	j	8000a9bc <finsh_thread_entry+0x240>
    8000a8a8:	00200713          	li	a4,2
    8000a8ac:	fee792e3          	bne	a5,a4,8000a890 <finsh_thread_entry+0x114>
    8000a8b0:	04042023          	sw	zero,64(s0)
    8000a8b4:	04100793          	li	a5,65
    8000a8b8:	06f59063          	bne	a1,a5,8000a918 <finsh_thread_entry+0x19c>
    8000a8bc:	04645583          	lhu	a1,70(s0)
    8000a8c0:	f40588e3          	beqz	a1,8000a810 <finsh_thread_entry+0x94>
    8000a8c4:	fff5859b          	addiw	a1,a1,-1
    8000a8c8:	03059593          	slli	a1,a1,0x30
    8000a8cc:	0305d593          	srli	a1,a1,0x30
    8000a8d0:	04b41323          	sh	a1,70(s0)
    8000a8d4:	05000793          	li	a5,80
    8000a8d8:	02f585b3          	mul	a1,a1,a5
    8000a8dc:	05000613          	li	a2,80
    8000a8e0:	1da40513          	addi	a0,s0,474
    8000a8e4:	04a58593          	addi	a1,a1,74
    8000a8e8:	00b405b3          	add	a1,s0,a1
    8000a8ec:	a74f90ef          	jal	ra,80003b60 <memcpy>
    8000a8f0:	0004b403          	ld	s0,0(s1)
    8000a8f4:	1da40513          	addi	a0,s0,474
    8000a8f8:	9f8f90ef          	jal	ra,80003af0 <strlen>
    8000a8fc:	03051513          	slli	a0,a0,0x30
    8000a900:	03055513          	srli	a0,a0,0x30
    8000a904:	22a41623          	sh	a0,556(s0)
    8000a908:	22a41723          	sh	a0,558(s0)
    8000a90c:	00040513          	mv	a0,s0
    8000a910:	bc9ff0ef          	jal	ra,8000a4d8 <shell_handle_history.isra.0>
    8000a914:	efdff06f          	j	8000a810 <finsh_thread_entry+0x94>
    8000a918:	04200793          	li	a5,66
    8000a91c:	02f59863          	bne	a1,a5,8000a94c <finsh_thread_entry+0x1d0>
    8000a920:	04845683          	lhu	a3,72(s0)
    8000a924:	04645783          	lhu	a5,70(s0)
    8000a928:	fff6861b          	addiw	a2,a3,-1
    8000a92c:	00c7da63          	bge	a5,a2,8000a940 <finsh_thread_entry+0x1c4>
    8000a930:	0017879b          	addiw	a5,a5,1
    8000a934:	04f41323          	sh	a5,70(s0)
    8000a938:	04645583          	lhu	a1,70(s0)
    8000a93c:	f99ff06f          	j	8000a8d4 <finsh_thread_entry+0x158>
    8000a940:	ec0688e3          	beqz	a3,8000a810 <finsh_thread_entry+0x94>
    8000a944:	04c41323          	sh	a2,70(s0)
    8000a948:	ff1ff06f          	j	8000a938 <finsh_thread_entry+0x1bc>
    8000a94c:	04400793          	li	a5,68
    8000a950:	02f59463          	bne	a1,a5,8000a978 <finsh_thread_entry+0x1fc>
    8000a954:	22e45783          	lhu	a5,558(s0)
    8000a958:	ea078ce3          	beqz	a5,8000a810 <finsh_thread_entry+0x94>
    8000a95c:	00090513          	mv	a0,s2
    8000a960:	88cfc0ef          	jal	ra,800069ec <rt_kprintf>
    8000a964:	0004b703          	ld	a4,0(s1)
    8000a968:	22e75783          	lhu	a5,558(a4)
    8000a96c:	fff7879b          	addiw	a5,a5,-1
    8000a970:	22f71723          	sh	a5,558(a4)
    8000a974:	e9dff06f          	j	8000a810 <finsh_thread_entry+0x94>
    8000a978:	04300793          	li	a5,67
    8000a97c:	f0f59ae3          	bne	a1,a5,8000a890 <finsh_thread_entry+0x114>
    8000a980:	22c45703          	lhu	a4,556(s0)
    8000a984:	22e45783          	lhu	a5,558(s0)
    8000a988:	e8e7f4e3          	bgeu	a5,a4,8000a810 <finsh_thread_entry+0x94>
    8000a98c:	00f407b3          	add	a5,s0,a5
    8000a990:	1da7c583          	lbu	a1,474(a5)
    8000a994:	00006517          	auipc	a0,0x6
    8000a998:	3dc50513          	addi	a0,a0,988 # 80010d70 <__FUNCTION__.1+0x120>
    8000a99c:	850fc0ef          	jal	ra,800069ec <rt_kprintf>
    8000a9a0:	0004b703          	ld	a4,0(s1)
    8000a9a4:	22e75783          	lhu	a5,558(a4)
    8000a9a8:	0017879b          	addiw	a5,a5,1
    8000a9ac:	fc5ff06f          	j	8000a970 <finsh_thread_entry+0x1f4>
    8000a9b0:	00090513          	mv	a0,s2
    8000a9b4:	838fc0ef          	jal	ra,800069ec <rt_kprintf>
    8000a9b8:	001c8c9b          	addiw	s9,s9,1
    8000a9bc:	0004b403          	ld	s0,0(s1)
    8000a9c0:	22e45783          	lhu	a5,558(s0)
    8000a9c4:	fefcc6e3          	blt	s9,a5,8000a9b0 <finsh_thread_entry+0x234>
    8000a9c8:	00008517          	auipc	a0,0x8
    8000a9cc:	24850513          	addi	a0,a0,584 # 80012c10 <__FUNCTION__.6+0x28>
    8000a9d0:	81cfc0ef          	jal	ra,800069ec <rt_kprintf>
    8000a9d4:	cc0fe0ef          	jal	ra,80008e94 <msh_is_used>
    8000a9d8:	00100793          	li	a5,1
    8000a9dc:	1da40413          	addi	s0,s0,474
    8000a9e0:	00f51663          	bne	a0,a5,8000a9ec <finsh_thread_entry+0x270>
    8000a9e4:	00040513          	mv	a0,s0
    8000a9e8:	9cdfe0ef          	jal	ra,800093b4 <msh_auto_complete>
    8000a9ec:	a19ff0ef          	jal	ra,8000a404 <finsh_get_prompt>
    8000a9f0:	00050593          	mv	a1,a0
    8000a9f4:	00040613          	mv	a2,s0
    8000a9f8:	00008517          	auipc	a0,0x8
    8000a9fc:	14850513          	addi	a0,a0,328 # 80012b40 <__fsym___cmd_ls_name+0x48>
    8000aa00:	fedfb0ef          	jal	ra,800069ec <rt_kprintf>
    8000aa04:	0004b403          	ld	s0,0(s1)
    8000aa08:	1da40513          	addi	a0,s0,474
    8000aa0c:	8e4f90ef          	jal	ra,80003af0 <strlen>
    8000aa10:	03051513          	slli	a0,a0,0x30
    8000aa14:	03055513          	srli	a0,a0,0x30
    8000aa18:	22a41623          	sh	a0,556(s0)
    8000aa1c:	22a41723          	sh	a0,558(s0)
    8000aa20:	df1ff06f          	j	8000a810 <finsh_thread_entry+0x94>
    8000aa24:	01858663          	beq	a1,s8,8000aa30 <finsh_thread_entry+0x2b4>
    8000aa28:	00800793          	li	a5,8
    8000aa2c:	0af59c63          	bne	a1,a5,8000aae4 <finsh_thread_entry+0x368>
    8000aa30:	22e45583          	lhu	a1,558(s0)
    8000aa34:	dc058ee3          	beqz	a1,8000a810 <finsh_thread_entry+0x94>
    8000aa38:	22c45783          	lhu	a5,556(s0)
    8000aa3c:	fff5861b          	addiw	a2,a1,-1
    8000aa40:	03061613          	slli	a2,a2,0x30
    8000aa44:	fff7879b          	addiw	a5,a5,-1
    8000aa48:	03079793          	slli	a5,a5,0x30
    8000aa4c:	0307d793          	srli	a5,a5,0x30
    8000aa50:	03065613          	srli	a2,a2,0x30
    8000aa54:	22f41623          	sh	a5,556(s0)
    8000aa58:	22c41723          	sh	a2,558(s0)
    8000aa5c:	06f67463          	bgeu	a2,a5,8000aac4 <finsh_thread_entry+0x348>
    8000aa60:	1da60513          	addi	a0,a2,474
    8000aa64:	1da58593          	addi	a1,a1,474
    8000aa68:	40c7863b          	subw	a2,a5,a2
    8000aa6c:	00b405b3          	add	a1,s0,a1
    8000aa70:	00a40533          	add	a0,s0,a0
    8000aa74:	f50fb0ef          	jal	ra,800061c4 <rt_memmove>
    8000aa78:	0004b783          	ld	a5,0(s1)
    8000aa7c:	00008517          	auipc	a0,0x8
    8000aa80:	11c50513          	addi	a0,a0,284 # 80012b98 <__fsym___cmd_ls_name+0xa0>
    8000aa84:	22c7d703          	lhu	a4,556(a5)
    8000aa88:	00e78733          	add	a4,a5,a4
    8000aa8c:	1c070d23          	sb	zero,474(a4)
    8000aa90:	22e7d583          	lhu	a1,558(a5)
    8000aa94:	1da58593          	addi	a1,a1,474
    8000aa98:	00b785b3          	add	a1,a5,a1
    8000aa9c:	f51fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000aaa0:	0004b783          	ld	a5,0(s1)
    8000aaa4:	22e7d403          	lhu	s0,558(a5)
    8000aaa8:	0004b783          	ld	a5,0(s1)
    8000aaac:	22c7d783          	lhu	a5,556(a5)
    8000aab0:	d687c0e3          	blt	a5,s0,8000a810 <finsh_thread_entry+0x94>
    8000aab4:	00090513          	mv	a0,s2
    8000aab8:	f35fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000aabc:	0014041b          	addiw	s0,s0,1
    8000aac0:	fe9ff06f          	j	8000aaa8 <finsh_thread_entry+0x32c>
    8000aac4:	00008517          	auipc	a0,0x8
    8000aac8:	0dc50513          	addi	a0,a0,220 # 80012ba0 <__fsym___cmd_ls_name+0xa8>
    8000aacc:	f21fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000aad0:	0004b783          	ld	a5,0(s1)
    8000aad4:	22c7d703          	lhu	a4,556(a5)
    8000aad8:	00e787b3          	add	a5,a5,a4
    8000aadc:	1c078d23          	sb	zero,474(a5)
    8000aae0:	d31ff06f          	j	8000a810 <finsh_thread_entry+0x94>
    8000aae4:	00d00713          	li	a4,13
    8000aae8:	22c45783          	lhu	a5,556(s0)
    8000aaec:	00e58663          	beq	a1,a4,8000aaf8 <finsh_thread_entry+0x37c>
    8000aaf0:	00a00713          	li	a4,10
    8000aaf4:	14e59863          	bne	a1,a4,8000ac44 <finsh_thread_entry+0x4c8>
    8000aaf8:	06078a63          	beqz	a5,8000ab6c <finsh_thread_entry+0x3f0>
    8000aafc:	04845c83          	lhu	s9,72(s0)
    8000ab00:	00400793          	li	a5,4
    8000ab04:	1da40d13          	addi	s10,s0,474
    8000ab08:	000c851b          	sext.w	a0,s9
    8000ab0c:	0d97f463          	bgeu	a5,s9,8000abd4 <finsh_thread_entry+0x458>
    8000ab10:	18a40d93          	addi	s11,s0,394
    8000ab14:	05000613          	li	a2,80
    8000ab18:	000d0593          	mv	a1,s10
    8000ab1c:	000d8513          	mv	a0,s11
    8000ab20:	844f90ef          	jal	ra,80003b64 <memcmp>
    8000ab24:	04050463          	beqz	a0,8000ab6c <finsh_thread_entry+0x3f0>
    8000ab28:	04a40c93          	addi	s9,s0,74
    8000ab2c:	000c8513          	mv	a0,s9
    8000ab30:	050c8c93          	addi	s9,s9,80
    8000ab34:	05000613          	li	a2,80
    8000ab38:	000c8593          	mv	a1,s9
    8000ab3c:	824f90ef          	jal	ra,80003b60 <memcpy>
    8000ab40:	ff9d96e3          	bne	s11,s9,8000ab2c <finsh_thread_entry+0x3b0>
    8000ab44:	05000613          	li	a2,80
    8000ab48:	00000593          	li	a1,0
    8000ab4c:	000d8513          	mv	a0,s11
    8000ab50:	80cf90ef          	jal	ra,80003b5c <memset>
    8000ab54:	22c45603          	lhu	a2,556(s0)
    8000ab58:	000d0593          	mv	a1,s10
    8000ab5c:	000d8513          	mv	a0,s11
    8000ab60:	800f90ef          	jal	ra,80003b60 <memcpy>
    8000ab64:	00500793          	li	a5,5
    8000ab68:	04f41423          	sh	a5,72(s0)
    8000ab6c:	04845783          	lhu	a5,72(s0)
    8000ab70:	04f41323          	sh	a5,70(s0)
    8000ab74:	b20fe0ef          	jal	ra,80008e94 <msh_is_used>
    8000ab78:	00100793          	li	a5,1
    8000ab7c:	02f51863          	bne	a0,a5,8000abac <finsh_thread_entry+0x430>
    8000ab80:	0004b783          	ld	a5,0(s1)
    8000ab84:	0447c783          	lbu	a5,68(a5)
    8000ab88:	0017f793          	andi	a5,a5,1
    8000ab8c:	00078863          	beqz	a5,8000ab9c <finsh_thread_entry+0x420>
    8000ab90:	00008517          	auipc	a0,0x8
    8000ab94:	08050513          	addi	a0,a0,128 # 80012c10 <__FUNCTION__.6+0x28>
    8000ab98:	e55fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000ab9c:	0004b503          	ld	a0,0(s1)
    8000aba0:	22c55583          	lhu	a1,556(a0)
    8000aba4:	1da50513          	addi	a0,a0,474
    8000aba8:	af4fe0ef          	jal	ra,80008e9c <msh_exec>
    8000abac:	859ff0ef          	jal	ra,8000a404 <finsh_get_prompt>
    8000abb0:	e3dfb0ef          	jal	ra,800069ec <rt_kprintf>
    8000abb4:	0004b503          	ld	a0,0(s1)
    8000abb8:	05100613          	li	a2,81
    8000abbc:	00000593          	li	a1,0
    8000abc0:	1da50513          	addi	a0,a0,474
    8000abc4:	f99f80ef          	jal	ra,80003b5c <memset>
    8000abc8:	0004b783          	ld	a5,0(s1)
    8000abcc:	2207a623          	sw	zero,556(a5)
    8000abd0:	c41ff06f          	j	8000a810 <finsh_thread_entry+0x94>
    8000abd4:	020c8463          	beqz	s9,8000abfc <finsh_thread_entry+0x480>
    8000abd8:	fff5051b          	addiw	a0,a0,-1
    8000abdc:	05000793          	li	a5,80
    8000abe0:	02f50533          	mul	a0,a0,a5
    8000abe4:	05000613          	li	a2,80
    8000abe8:	000d0593          	mv	a1,s10
    8000abec:	04a50513          	addi	a0,a0,74
    8000abf0:	00a40533          	add	a0,s0,a0
    8000abf4:	f71f80ef          	jal	ra,80003b64 <memcmp>
    8000abf8:	f6050ae3          	beqz	a0,8000ab6c <finsh_thread_entry+0x3f0>
    8000abfc:	05000d93          	li	s11,80
    8000ac00:	03bc8533          	mul	a0,s9,s11
    8000ac04:	05000613          	li	a2,80
    8000ac08:	00000593          	li	a1,0
    8000ac0c:	05941323          	sh	s9,70(s0)
    8000ac10:	04a50513          	addi	a0,a0,74
    8000ac14:	00a40533          	add	a0,s0,a0
    8000ac18:	f45f80ef          	jal	ra,80003b5c <memset>
    8000ac1c:	04845503          	lhu	a0,72(s0)
    8000ac20:	22c45603          	lhu	a2,556(s0)
    8000ac24:	000d0593          	mv	a1,s10
    8000ac28:	03b50533          	mul	a0,a0,s11
    8000ac2c:	04a50513          	addi	a0,a0,74
    8000ac30:	00a40533          	add	a0,s0,a0
    8000ac34:	f2df80ef          	jal	ra,80003b60 <memcpy>
    8000ac38:	04845783          	lhu	a5,72(s0)
    8000ac3c:	0017879b          	addiw	a5,a5,1
    8000ac40:	f29ff06f          	j	8000ab68 <finsh_thread_entry+0x3ec>
    8000ac44:	04f00713          	li	a4,79
    8000ac48:	00f77463          	bgeu	a4,a5,8000ac50 <finsh_thread_entry+0x4d4>
    8000ac4c:	22041623          	sh	zero,556(s0)
    8000ac50:	22e45503          	lhu	a0,558(s0)
    8000ac54:	22c45783          	lhu	a5,556(s0)
    8000ac58:	0005061b          	sext.w	a2,a0
    8000ac5c:	0af57463          	bgeu	a0,a5,8000ad04 <finsh_thread_entry+0x588>
    8000ac60:	1da60593          	addi	a1,a2,474
    8000ac64:	1db50513          	addi	a0,a0,475
    8000ac68:	40c7863b          	subw	a2,a5,a2
    8000ac6c:	00b405b3          	add	a1,s0,a1
    8000ac70:	00a40533          	add	a0,s0,a0
    8000ac74:	d50fb0ef          	jal	ra,800061c4 <rt_memmove>
    8000ac78:	0004b583          	ld	a1,0(s1)
    8000ac7c:	22e5d703          	lhu	a4,558(a1)
    8000ac80:	00070793          	mv	a5,a4
    8000ac84:	00e58733          	add	a4,a1,a4
    8000ac88:	1d970d23          	sb	s9,474(a4)
    8000ac8c:	0445c703          	lbu	a4,68(a1)
    8000ac90:	00177713          	andi	a4,a4,1
    8000ac94:	00070c63          	beqz	a4,8000acac <finsh_thread_entry+0x530>
    8000ac98:	1da7879b          	addiw	a5,a5,474
    8000ac9c:	00f585b3          	add	a1,a1,a5
    8000aca0:	00008517          	auipc	a0,0x8
    8000aca4:	f0850513          	addi	a0,a0,-248 # 80012ba8 <__fsym___cmd_ls_name+0xb0>
    8000aca8:	d45fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000acac:	0004b783          	ld	a5,0(s1)
    8000acb0:	22e7d403          	lhu	s0,558(a5)
    8000acb4:	0004b783          	ld	a5,0(s1)
    8000acb8:	22c7d783          	lhu	a5,556(a5)
    8000acbc:	02f44c63          	blt	s0,a5,8000acf4 <finsh_thread_entry+0x578>
    8000acc0:	0004b703          	ld	a4,0(s1)
    8000acc4:	22c75783          	lhu	a5,556(a4)
    8000acc8:	22e75683          	lhu	a3,558(a4)
    8000accc:	0017879b          	addiw	a5,a5,1
    8000acd0:	03079793          	slli	a5,a5,0x30
    8000acd4:	0016869b          	addiw	a3,a3,1
    8000acd8:	0307d793          	srli	a5,a5,0x30
    8000acdc:	22d71723          	sh	a3,558(a4)
    8000ace0:	22f71623          	sh	a5,556(a4)
    8000ace4:	04f00693          	li	a3,79
    8000ace8:	b2f6f4e3          	bgeu	a3,a5,8000a810 <finsh_thread_entry+0x94>
    8000acec:	22072623          	sw	zero,556(a4)
    8000acf0:	b21ff06f          	j	8000a810 <finsh_thread_entry+0x94>
    8000acf4:	00090513          	mv	a0,s2
    8000acf8:	cf5fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000acfc:	0014041b          	addiw	s0,s0,1
    8000ad00:	fb5ff06f          	j	8000acb4 <finsh_thread_entry+0x538>
    8000ad04:	00f407b3          	add	a5,s0,a5
    8000ad08:	1d978d23          	sb	s9,474(a5)
    8000ad0c:	04444783          	lbu	a5,68(s0)
    8000ad10:	0017f793          	andi	a5,a5,1
    8000ad14:	fa0786e3          	beqz	a5,8000acc0 <finsh_thread_entry+0x544>
    8000ad18:	00006517          	auipc	a0,0x6
    8000ad1c:	05850513          	addi	a0,a0,88 # 80010d70 <__FUNCTION__.1+0x120>
    8000ad20:	ccdfb0ef          	jal	ra,800069ec <rt_kprintf>
    8000ad24:	f9dff06f          	j	8000acc0 <finsh_thread_entry+0x544>

000000008000ad28 <rt_list_len>:
    8000ad28:	00050793          	mv	a5,a0
    8000ad2c:	00050713          	mv	a4,a0
    8000ad30:	00000513          	li	a0,0
    8000ad34:	00073703          	ld	a4,0(a4)
    8000ad38:	00f71463          	bne	a4,a5,8000ad40 <rt_list_len+0x18>
    8000ad3c:	00008067          	ret
    8000ad40:	0015051b          	addiw	a0,a0,1
    8000ad44:	ff1ff06f          	j	8000ad34 <rt_list_len+0xc>

000000008000ad48 <hello>:
    8000ad48:	ff010113          	addi	sp,sp,-16
    8000ad4c:	00008517          	auipc	a0,0x8
    8000ad50:	eb450513          	addi	a0,a0,-332 # 80012c00 <__FUNCTION__.6+0x18>
    8000ad54:	00113423          	sd	ra,8(sp)
    8000ad58:	c95fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000ad5c:	00813083          	ld	ra,8(sp)
    8000ad60:	00000513          	li	a0,0
    8000ad64:	01010113          	addi	sp,sp,16
    8000ad68:	00008067          	ret

000000008000ad6c <clear>:
    8000ad6c:	ff010113          	addi	sp,sp,-16
    8000ad70:	00008517          	auipc	a0,0x8
    8000ad74:	ea850513          	addi	a0,a0,-344 # 80012c18 <__FUNCTION__.6+0x30>
    8000ad78:	00113423          	sd	ra,8(sp)
    8000ad7c:	c71fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000ad80:	00813083          	ld	ra,8(sp)
    8000ad84:	00000513          	li	a0,0
    8000ad88:	01010113          	addi	sp,sp,16
    8000ad8c:	00008067          	ret

000000008000ad90 <show_wait_queue>:
    8000ad90:	fd010113          	addi	sp,sp,-48
    8000ad94:	00913c23          	sd	s1,24(sp)
    8000ad98:	00053483          	ld	s1,0(a0)
    8000ad9c:	02813023          	sd	s0,32(sp)
    8000ada0:	01213823          	sd	s2,16(sp)
    8000ada4:	01313423          	sd	s3,8(sp)
    8000ada8:	02113423          	sd	ra,40(sp)
    8000adac:	00050413          	mv	s0,a0
    8000adb0:	00008917          	auipc	s2,0x8
    8000adb4:	df890913          	addi	s2,s2,-520 # 80012ba8 <__fsym___cmd_ls_name+0xb0>
    8000adb8:	00007997          	auipc	s3,0x7
    8000adbc:	53898993          	addi	s3,s3,1336 # 800122f0 <CSWTCH.17+0xc8>
    8000adc0:	02849063          	bne	s1,s0,8000ade0 <show_wait_queue+0x50>
    8000adc4:	02813083          	ld	ra,40(sp)
    8000adc8:	02013403          	ld	s0,32(sp)
    8000adcc:	01813483          	ld	s1,24(sp)
    8000add0:	01013903          	ld	s2,16(sp)
    8000add4:	00813983          	ld	s3,8(sp)
    8000add8:	03010113          	addi	sp,sp,48
    8000addc:	00008067          	ret
    8000ade0:	fd848593          	addi	a1,s1,-40
    8000ade4:	00090513          	mv	a0,s2
    8000ade8:	c05fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000adec:	0004b783          	ld	a5,0(s1)
    8000adf0:	00878663          	beq	a5,s0,8000adfc <show_wait_queue+0x6c>
    8000adf4:	00098513          	mv	a0,s3
    8000adf8:	bf5fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000adfc:	0004b483          	ld	s1,0(s1)
    8000ae00:	fc1ff06f          	j	8000adc0 <show_wait_queue+0x30>

000000008000ae04 <version>:
    8000ae04:	ff010113          	addi	sp,sp,-16
    8000ae08:	00113423          	sd	ra,8(sp)
    8000ae0c:	c91fb0ef          	jal	ra,80006a9c <rt_show_version>
    8000ae10:	00813083          	ld	ra,8(sp)
    8000ae14:	00000513          	li	a0,0
    8000ae18:	01010113          	addi	sp,sp,16
    8000ae1c:	00008067          	ret

000000008000ae20 <list>:
    8000ae20:	fd010113          	addi	sp,sp,-48
    8000ae24:	00008517          	auipc	a0,0x8
    8000ae28:	dfc50513          	addi	a0,a0,-516 # 80012c20 <__FUNCTION__.6+0x38>
    8000ae2c:	02813023          	sd	s0,32(sp)
    8000ae30:	01213823          	sd	s2,16(sp)
    8000ae34:	01313423          	sd	s3,8(sp)
    8000ae38:	01413023          	sd	s4,0(sp)
    8000ae3c:	02113423          	sd	ra,40(sp)
    8000ae40:	00913c23          	sd	s1,24(sp)
    8000ae44:	00013917          	auipc	s2,0x13
    8000ae48:	ba490913          	addi	s2,s2,-1116 # 8001d9e8 <_syscall_table_end>
    8000ae4c:	ba1fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000ae50:	00008997          	auipc	s3,0x8
    8000ae54:	de898993          	addi	s3,s3,-536 # 80012c38 <__FUNCTION__.6+0x50>
    8000ae58:	00013417          	auipc	s0,0x13
    8000ae5c:	b8843403          	ld	s0,-1144(s0) # 8001d9e0 <_syscall_table_begin>
    8000ae60:	00008a17          	auipc	s4,0x8
    8000ae64:	de0a0a13          	addi	s4,s4,-544 # 80012c40 <__FUNCTION__.6+0x58>
    8000ae68:	00093783          	ld	a5,0(s2)
    8000ae6c:	02f46463          	bltu	s0,a5,8000ae94 <list+0x74>
    8000ae70:	02813083          	ld	ra,40(sp)
    8000ae74:	02013403          	ld	s0,32(sp)
    8000ae78:	01813483          	ld	s1,24(sp)
    8000ae7c:	01013903          	ld	s2,16(sp)
    8000ae80:	00813983          	ld	s3,8(sp)
    8000ae84:	00013a03          	ld	s4,0(sp)
    8000ae88:	00000513          	li	a0,0
    8000ae8c:	03010113          	addi	sp,sp,48
    8000ae90:	00008067          	ret
    8000ae94:	00043483          	ld	s1,0(s0)
    8000ae98:	00200613          	li	a2,2
    8000ae9c:	00098593          	mv	a1,s3
    8000aea0:	00048513          	mv	a0,s1
    8000aea4:	cb5f80ef          	jal	ra,80003b58 <strncmp>
    8000aea8:	00050a63          	beqz	a0,8000aebc <list+0x9c>
    8000aeac:	00843603          	ld	a2,8(s0)
    8000aeb0:	00048593          	mv	a1,s1
    8000aeb4:	000a0513          	mv	a0,s4
    8000aeb8:	b35fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000aebc:	01840413          	addi	s0,s0,24
    8000aec0:	fa9ff06f          	j	8000ae68 <list+0x48>

000000008000aec4 <list_get_next>:
    8000aec4:	0145a783          	lw	a5,20(a1)
    8000aec8:	0005ac23          	sw	zero,24(a1)
    8000aecc:	0c078863          	beqz	a5,8000af9c <list_get_next+0xd8>
    8000aed0:	0105c783          	lbu	a5,16(a1)
    8000aed4:	fd010113          	addi	sp,sp,-48
    8000aed8:	02813023          	sd	s0,32(sp)
    8000aedc:	00913c23          	sd	s1,24(sp)
    8000aee0:	02113423          	sd	ra,40(sp)
    8000aee4:	01213823          	sd	s2,16(sp)
    8000aee8:	01313423          	sd	s3,8(sp)
    8000aeec:	00050413          	mv	s0,a0
    8000aef0:	00058493          	mv	s1,a1
    8000aef4:	00000513          	li	a0,0
    8000aef8:	02078e63          	beqz	a5,8000af34 <list_get_next+0x70>
    8000aefc:	0005b983          	ld	s3,0(a1)
    8000af00:	00000913          	li	s2,0
    8000af04:	00041663          	bnez	s0,8000af10 <list_get_next+0x4c>
    8000af08:	00098413          	mv	s0,s3
    8000af0c:	00100913          	li	s2,1
    8000af10:	940f50ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000af14:	00050713          	mv	a4,a0
    8000af18:	02091c63          	bnez	s2,8000af50 <list_get_next+0x8c>
    8000af1c:	ffc44783          	lbu	a5,-4(s0)
    8000af20:	0104c683          	lbu	a3,16(s1)
    8000af24:	07f7f793          	andi	a5,a5,127
    8000af28:	02f68463          	beq	a3,a5,8000af50 <list_get_next+0x8c>
    8000af2c:	92cf50ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000af30:	00000513          	li	a0,0
    8000af34:	02813083          	ld	ra,40(sp)
    8000af38:	02013403          	ld	s0,32(sp)
    8000af3c:	01813483          	ld	s1,24(sp)
    8000af40:	01013903          	ld	s2,16(sp)
    8000af44:	00813983          	ld	s3,8(sp)
    8000af48:	03010113          	addi	sp,sp,48
    8000af4c:	00008067          	ret
    8000af50:	0084b603          	ld	a2,8(s1)
    8000af54:	00000793          	li	a5,0
    8000af58:	00043403          	ld	s0,0(s0)
    8000af5c:	0007891b          	sext.w	s2,a5
    8000af60:	02898a63          	beq	s3,s0,8000af94 <list_get_next+0xd0>
    8000af64:	00379693          	slli	a3,a5,0x3
    8000af68:	0144a903          	lw	s2,20(s1)
    8000af6c:	00d606b3          	add	a3,a2,a3
    8000af70:	00178793          	addi	a5,a5,1
    8000af74:	0086b023          	sd	s0,0(a3) # 1000 <__STACKSIZE__-0x3000>
    8000af78:	0007869b          	sext.w	a3,a5
    8000af7c:	fcd91ee3          	bne	s2,a3,8000af58 <list_get_next+0x94>
    8000af80:	00070513          	mv	a0,a4
    8000af84:	8d4f50ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000af88:	00040513          	mv	a0,s0
    8000af8c:	0124ac23          	sw	s2,24(s1)
    8000af90:	fa5ff06f          	j	8000af34 <list_get_next+0x70>
    8000af94:	00000413          	li	s0,0
    8000af98:	fe9ff06f          	j	8000af80 <list_get_next+0xbc>
    8000af9c:	00000513          	li	a0,0
    8000afa0:	00008067          	ret

000000008000afa4 <object_split.constprop.0>:
    8000afa4:	fe010113          	addi	sp,sp,-32
    8000afa8:	00813823          	sd	s0,16(sp)
    8000afac:	00913423          	sd	s1,8(sp)
    8000afb0:	00113c23          	sd	ra,24(sp)
    8000afb4:	01500413          	li	s0,21
    8000afb8:	00008497          	auipc	s1,0x8
    8000afbc:	c9848493          	addi	s1,s1,-872 # 80012c50 <__FUNCTION__.6+0x68>
    8000afc0:	fff4041b          	addiw	s0,s0,-1
    8000afc4:	00041c63          	bnez	s0,8000afdc <object_split.constprop.0+0x38>
    8000afc8:	01813083          	ld	ra,24(sp)
    8000afcc:	01013403          	ld	s0,16(sp)
    8000afd0:	00813483          	ld	s1,8(sp)
    8000afd4:	02010113          	addi	sp,sp,32
    8000afd8:	00008067          	ret
    8000afdc:	00048513          	mv	a0,s1
    8000afe0:	a0dfb0ef          	jal	ra,800069ec <rt_kprintf>
    8000afe4:	fddff06f          	j	8000afc0 <object_split.constprop.0+0x1c>

000000008000afe8 <list_timer>:
    8000afe8:	f5010113          	addi	sp,sp,-176
    8000afec:	00a00513          	li	a0,10
    8000aff0:	0a113423          	sd	ra,168(sp)
    8000aff4:	0a813023          	sd	s0,160(sp)
    8000aff8:	09413023          	sd	s4,128(sp)
    8000affc:	07513c23          	sd	s5,120(sp)
    8000b000:	07613823          	sd	s6,112(sp)
    8000b004:	07713423          	sd	s7,104(sp)
    8000b008:	08913c23          	sd	s1,152(sp)
    8000b00c:	09213823          	sd	s2,144(sp)
    8000b010:	09313423          	sd	s3,136(sp)
    8000b014:	8d5fc0ef          	jal	ra,800078e8 <rt_object_get_information>
    8000b018:	00850513          	addi	a0,a0,8
    8000b01c:	00a00793          	li	a5,10
    8000b020:	00006617          	auipc	a2,0x6
    8000b024:	b9860613          	addi	a2,a2,-1128 # 80010bb8 <_uart_ops+0xe8>
    8000b028:	01400593          	li	a1,20
    8000b02c:	00a13023          	sd	a0,0(sp)
    8000b030:	00f10823          	sb	a5,16(sp)
    8000b034:	00008517          	auipc	a0,0x8
    8000b038:	c2450513          	addi	a0,a0,-988 # 80012c58 <__FUNCTION__.6+0x70>
    8000b03c:	00800793          	li	a5,8
    8000b040:	02010a13          	addi	s4,sp,32
    8000b044:	00f12a23          	sw	a5,20(sp)
    8000b048:	01413423          	sd	s4,8(sp)
    8000b04c:	00012c23          	sw	zero,24(sp)
    8000b050:	99dfb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b054:	f51ff0ef          	jal	ra,8000afa4 <object_split.constprop.0>
    8000b058:	00008517          	auipc	a0,0x8
    8000b05c:	c2850513          	addi	a0,a0,-984 # 80012c80 <__FUNCTION__.6+0x98>
    8000b060:	98dfb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b064:	00000413          	li	s0,0
    8000b068:	00008a97          	auipc	s5,0x8
    8000b06c:	c40a8a93          	addi	s5,s5,-960 # 80012ca8 <__FUNCTION__.6+0xc0>
    8000b070:	00008b17          	auipc	s6,0x8
    8000b074:	c60b0b13          	addi	s6,s6,-928 # 80012cd0 <__FUNCTION__.6+0xe8>
    8000b078:	00008b97          	auipc	s7,0x8
    8000b07c:	c48b8b93          	addi	s7,s7,-952 # 80012cc0 <__FUNCTION__.6+0xd8>
    8000b080:	00040513          	mv	a0,s0
    8000b084:	00010593          	mv	a1,sp
    8000b088:	e3dff0ef          	jal	ra,8000aec4 <list_get_next>
    8000b08c:	00050413          	mv	s0,a0
    8000b090:	000a0993          	mv	s3,s4
    8000b094:	00000913          	li	s2,0
    8000b098:	01812783          	lw	a5,24(sp)
    8000b09c:	04f94663          	blt	s2,a5,8000b0e8 <list_timer+0x100>
    8000b0a0:	fe0410e3          	bnez	s0,8000b080 <list_timer+0x98>
    8000b0a4:	b25fb0ef          	jal	ra,80006bc8 <rt_tick_get>
    8000b0a8:	0005059b          	sext.w	a1,a0
    8000b0ac:	00008517          	auipc	a0,0x8
    8000b0b0:	c3450513          	addi	a0,a0,-972 # 80012ce0 <__FUNCTION__.6+0xf8>
    8000b0b4:	939fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b0b8:	0a813083          	ld	ra,168(sp)
    8000b0bc:	0a013403          	ld	s0,160(sp)
    8000b0c0:	09813483          	ld	s1,152(sp)
    8000b0c4:	09013903          	ld	s2,144(sp)
    8000b0c8:	08813983          	ld	s3,136(sp)
    8000b0cc:	08013a03          	ld	s4,128(sp)
    8000b0d0:	07813a83          	ld	s5,120(sp)
    8000b0d4:	07013b03          	ld	s6,112(sp)
    8000b0d8:	06813b83          	ld	s7,104(sp)
    8000b0dc:	00000513          	li	a0,0
    8000b0e0:	0b010113          	addi	sp,sp,176
    8000b0e4:	00008067          	ret
    8000b0e8:	0009b483          	ld	s1,0(s3)
    8000b0ec:	f65f40ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000b0f0:	01014703          	lbu	a4,16(sp)
    8000b0f4:	ffc4c783          	lbu	a5,-4(s1)
    8000b0f8:	07f7f793          	andi	a5,a5,127
    8000b0fc:	00f70a63          	beq	a4,a5,8000b110 <list_timer+0x128>
    8000b100:	f59f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000b104:	0019091b          	addiw	s2,s2,1
    8000b108:	00898993          	addi	s3,s3,8
    8000b10c:	f8dff06f          	j	8000b098 <list_timer+0xb0>
    8000b110:	f49f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000b114:	0344a783          	lw	a5,52(s1)
    8000b118:	0304a703          	lw	a4,48(s1)
    8000b11c:	000a8513          	mv	a0,s5
    8000b120:	fe848693          	addi	a3,s1,-24
    8000b124:	01400613          	li	a2,20
    8000b128:	01400593          	li	a1,20
    8000b12c:	8c1fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b130:	ffd4c783          	lbu	a5,-3(s1)
    8000b134:	000b8513          	mv	a0,s7
    8000b138:	0017f793          	andi	a5,a5,1
    8000b13c:	00079463          	bnez	a5,8000b144 <list_timer+0x15c>
    8000b140:	000b0513          	mv	a0,s6
    8000b144:	8a9fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b148:	fbdff06f          	j	8000b104 <list_timer+0x11c>

000000008000b14c <list_thread>:
    8000b14c:	e3010113          	addi	sp,sp,-464
    8000b150:	00100513          	li	a0,1
    8000b154:	1c113423          	sd	ra,456(sp)
    8000b158:	1a913c23          	sd	s1,440(sp)
    8000b15c:	1b413023          	sd	s4,416(sp)
    8000b160:	19513c23          	sd	s5,408(sp)
    8000b164:	19613823          	sd	s6,400(sp)
    8000b168:	19713423          	sd	s7,392(sp)
    8000b16c:	1c813023          	sd	s0,448(sp)
    8000b170:	1b213823          	sd	s2,432(sp)
    8000b174:	1b313423          	sd	s3,424(sp)
    8000b178:	19813023          	sd	s8,384(sp)
    8000b17c:	17913c23          	sd	s9,376(sp)
    8000b180:	17a13823          	sd	s10,368(sp)
    8000b184:	17b13423          	sd	s11,360(sp)
    8000b188:	f60fc0ef          	jal	ra,800078e8 <rt_object_get_information>
    8000b18c:	00850513          	addi	a0,a0,8
    8000b190:	00100793          	li	a5,1
    8000b194:	00008617          	auipc	a2,0x8
    8000b198:	b6460613          	addi	a2,a2,-1180 # 80012cf8 <__FUNCTION__.6+0x110>
    8000b19c:	01400593          	li	a1,20
    8000b1a0:	00a13c23          	sd	a0,24(sp)
    8000b1a4:	02f10423          	sb	a5,40(sp)
    8000b1a8:	00008517          	auipc	a0,0x8
    8000b1ac:	b5850513          	addi	a0,a0,-1192 # 80012d00 <__FUNCTION__.6+0x118>
    8000b1b0:	00800793          	li	a5,8
    8000b1b4:	03810a13          	addi	s4,sp,56
    8000b1b8:	02f12623          	sw	a5,44(sp)
    8000b1bc:	03413023          	sd	s4,32(sp)
    8000b1c0:	02012823          	sw	zero,48(sp)
    8000b1c4:	829fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b1c8:	dddff0ef          	jal	ra,8000afa4 <object_split.constprop.0>
    8000b1cc:	00008517          	auipc	a0,0x8
    8000b1d0:	b7c50513          	addi	a0,a0,-1156 # 80012d48 <__FUNCTION__.6+0x160>
    8000b1d4:	819fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b1d8:	00000493          	li	s1,0
    8000b1dc:	00008a97          	auipc	s5,0x8
    8000b1e0:	baca8a93          	addi	s5,s5,-1108 # 80012d88 <__FUNCTION__.6+0x1a0>
    8000b1e4:	00100b13          	li	s6,1
    8000b1e8:	00008b97          	auipc	s7,0x8
    8000b1ec:	c00b8b93          	addi	s7,s7,-1024 # 80012de8 <__FUNCTION__.6+0x200>
    8000b1f0:	00048513          	mv	a0,s1
    8000b1f4:	01810593          	addi	a1,sp,24
    8000b1f8:	ccdff0ef          	jal	ra,8000aec4 <list_get_next>
    8000b1fc:	00050493          	mv	s1,a0
    8000b200:	000a0993          	mv	s3,s4
    8000b204:	00000913          	li	s2,0
    8000b208:	02300c13          	li	s8,35
    8000b20c:	06400c93          	li	s9,100
    8000b210:	00200d13          	li	s10,2
    8000b214:	00400d93          	li	s11,4
    8000b218:	03012783          	lw	a5,48(sp)
    8000b21c:	04f94463          	blt	s2,a5,8000b264 <list_thread+0x118>
    8000b220:	fc0498e3          	bnez	s1,8000b1f0 <list_thread+0xa4>
    8000b224:	1c813083          	ld	ra,456(sp)
    8000b228:	1c013403          	ld	s0,448(sp)
    8000b22c:	1b813483          	ld	s1,440(sp)
    8000b230:	1b013903          	ld	s2,432(sp)
    8000b234:	1a813983          	ld	s3,424(sp)
    8000b238:	1a013a03          	ld	s4,416(sp)
    8000b23c:	19813a83          	ld	s5,408(sp)
    8000b240:	19013b03          	ld	s6,400(sp)
    8000b244:	18813b83          	ld	s7,392(sp)
    8000b248:	18013c03          	ld	s8,384(sp)
    8000b24c:	17813c83          	ld	s9,376(sp)
    8000b250:	17013d03          	ld	s10,368(sp)
    8000b254:	16813d83          	ld	s11,360(sp)
    8000b258:	00000513          	li	a0,0
    8000b25c:	1d010113          	addi	sp,sp,464
    8000b260:	00008067          	ret
    8000b264:	0009b403          	ld	s0,0(s3)
    8000b268:	de9f40ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000b26c:	02814683          	lbu	a3,40(sp)
    8000b270:	ffc44703          	lbu	a4,-4(s0)
    8000b274:	07f77713          	andi	a4,a4,127
    8000b278:	00e68a63          	beq	a3,a4,8000b28c <list_thread+0x140>
    8000b27c:	dddf40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000b280:	0019091b          	addiw	s2,s2,1
    8000b284:	00898993          	addi	s3,s3,8
    8000b288:	f91ff06f          	j	8000b218 <list_thread+0xcc>
    8000b28c:	fe840693          	addi	a3,s0,-24
    8000b290:	00068593          	mv	a1,a3
    8000b294:	0e800613          	li	a2,232
    8000b298:	00a13423          	sd	a0,8(sp)
    8000b29c:	07810513          	addi	a0,sp,120
    8000b2a0:	00d13023          	sd	a3,0(sp)
    8000b2a4:	8bdf80ef          	jal	ra,80003b60 <memcpy>
    8000b2a8:	00813783          	ld	a5,8(sp)
    8000b2ac:	00078513          	mv	a0,a5
    8000b2b0:	da9f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000b2b4:	05144703          	lbu	a4,81(s0)
    8000b2b8:	00013683          	ld	a3,0(sp)
    8000b2bc:	000a8513          	mv	a0,s5
    8000b2c0:	01400613          	li	a2,20
    8000b2c4:	01400593          	li	a1,20
    8000b2c8:	f24fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b2cc:	05044783          	lbu	a5,80(s0)
    8000b2d0:	00008517          	auipc	a0,0x8
    8000b2d4:	ac850513          	addi	a0,a0,-1336 # 80012d98 <__FUNCTION__.6+0x1b0>
    8000b2d8:	0077f793          	andi	a5,a5,7
    8000b2dc:	03678c63          	beq	a5,s6,8000b314 <list_thread+0x1c8>
    8000b2e0:	00008517          	auipc	a0,0x8
    8000b2e4:	ac850513          	addi	a0,a0,-1336 # 80012da8 <__FUNCTION__.6+0x1c0>
    8000b2e8:	03a78663          	beq	a5,s10,8000b314 <list_thread+0x1c8>
    8000b2ec:	00008517          	auipc	a0,0x8
    8000b2f0:	acc50513          	addi	a0,a0,-1332 # 80012db8 <__FUNCTION__.6+0x1d0>
    8000b2f4:	02078063          	beqz	a5,8000b314 <list_thread+0x1c8>
    8000b2f8:	00008517          	auipc	a0,0x8
    8000b2fc:	ad050513          	addi	a0,a0,-1328 # 80012dc8 <__FUNCTION__.6+0x1e0>
    8000b300:	01b78a63          	beq	a5,s11,8000b314 <list_thread+0x1c8>
    8000b304:	00300713          	li	a4,3
    8000b308:	00e79863          	bne	a5,a4,8000b318 <list_thread+0x1cc>
    8000b30c:	00008517          	auipc	a0,0x8
    8000b310:	acc50513          	addi	a0,a0,-1332 # 80012dd8 <__FUNCTION__.6+0x1f0>
    8000b314:	ed8fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b318:	03843583          	ld	a1,56(s0)
    8000b31c:	00058793          	mv	a5,a1
    8000b320:	0007c703          	lbu	a4,0(a5)
    8000b324:	03870e63          	beq	a4,s8,8000b360 <list_thread+0x214>
    8000b328:	04042603          	lw	a2,64(s0)
    8000b32c:	02043803          	ld	a6,32(s0)
    8000b330:	06843703          	ld	a4,104(s0)
    8000b334:	02061513          	slli	a0,a2,0x20
    8000b338:	02055513          	srli	a0,a0,0x20
    8000b33c:	00a585b3          	add	a1,a1,a0
    8000b340:	40f587b3          	sub	a5,a1,a5
    8000b344:	039786b3          	mul	a3,a5,s9
    8000b348:	04843783          	ld	a5,72(s0)
    8000b34c:	410585b3          	sub	a1,a1,a6
    8000b350:	02a6d6b3          	divu	a3,a3,a0
    8000b354:	000b8513          	mv	a0,s7
    8000b358:	e94fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b35c:	f25ff06f          	j	8000b280 <list_thread+0x134>
    8000b360:	00178793          	addi	a5,a5,1
    8000b364:	fbdff06f          	j	8000b320 <list_thread+0x1d4>

000000008000b368 <list_sem>:
    8000b368:	f4010113          	addi	sp,sp,-192
    8000b36c:	00200513          	li	a0,2
    8000b370:	0a113c23          	sd	ra,184(sp)
    8000b374:	0a913423          	sd	s1,168(sp)
    8000b378:	09513423          	sd	s5,136(sp)
    8000b37c:	09613023          	sd	s6,128(sp)
    8000b380:	07713c23          	sd	s7,120(sp)
    8000b384:	07813823          	sd	s8,112(sp)
    8000b388:	0a813823          	sd	s0,176(sp)
    8000b38c:	0b213023          	sd	s2,160(sp)
    8000b390:	09313c23          	sd	s3,152(sp)
    8000b394:	09413823          	sd	s4,144(sp)
    8000b398:	d50fc0ef          	jal	ra,800078e8 <rt_object_get_information>
    8000b39c:	00850513          	addi	a0,a0,8
    8000b3a0:	00200793          	li	a5,2
    8000b3a4:	00008617          	auipc	a2,0x8
    8000b3a8:	a6c60613          	addi	a2,a2,-1428 # 80012e10 <__FUNCTION__.6+0x228>
    8000b3ac:	01400593          	li	a1,20
    8000b3b0:	00a13823          	sd	a0,16(sp)
    8000b3b4:	02f10023          	sb	a5,32(sp)
    8000b3b8:	00008517          	auipc	a0,0x8
    8000b3bc:	a6850513          	addi	a0,a0,-1432 # 80012e20 <__FUNCTION__.6+0x238>
    8000b3c0:	00800793          	li	a5,8
    8000b3c4:	03010a93          	addi	s5,sp,48
    8000b3c8:	02f12223          	sw	a5,36(sp)
    8000b3cc:	01513c23          	sd	s5,24(sp)
    8000b3d0:	02012423          	sw	zero,40(sp)
    8000b3d4:	e18fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b3d8:	bcdff0ef          	jal	ra,8000afa4 <object_split.constprop.0>
    8000b3dc:	00008517          	auipc	a0,0x8
    8000b3e0:	a6450513          	addi	a0,a0,-1436 # 80012e40 <__FUNCTION__.6+0x258>
    8000b3e4:	e08fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b3e8:	00000493          	li	s1,0
    8000b3ec:	00008b17          	auipc	s6,0x8
    8000b3f0:	a7cb0b13          	addi	s6,s6,-1412 # 80012e68 <__FUNCTION__.6+0x280>
    8000b3f4:	00008b97          	auipc	s7,0x8
    8000b3f8:	a64b8b93          	addi	s7,s7,-1436 # 80012e58 <__FUNCTION__.6+0x270>
    8000b3fc:	00008c17          	auipc	s8,0x8
    8000b400:	814c0c13          	addi	s8,s8,-2028 # 80012c10 <__FUNCTION__.6+0x28>
    8000b404:	00048513          	mv	a0,s1
    8000b408:	01010593          	addi	a1,sp,16
    8000b40c:	ab9ff0ef          	jal	ra,8000aec4 <list_get_next>
    8000b410:	00050493          	mv	s1,a0
    8000b414:	000a8a13          	mv	s4,s5
    8000b418:	00000993          	li	s3,0
    8000b41c:	02812783          	lw	a5,40(sp)
    8000b420:	02f9ce63          	blt	s3,a5,8000b45c <list_sem+0xf4>
    8000b424:	fe0490e3          	bnez	s1,8000b404 <list_sem+0x9c>
    8000b428:	0b813083          	ld	ra,184(sp)
    8000b42c:	0b013403          	ld	s0,176(sp)
    8000b430:	0a813483          	ld	s1,168(sp)
    8000b434:	0a013903          	ld	s2,160(sp)
    8000b438:	09813983          	ld	s3,152(sp)
    8000b43c:	09013a03          	ld	s4,144(sp)
    8000b440:	08813a83          	ld	s5,136(sp)
    8000b444:	08013b03          	ld	s6,128(sp)
    8000b448:	07813b83          	ld	s7,120(sp)
    8000b44c:	07013c03          	ld	s8,112(sp)
    8000b450:	00000513          	li	a0,0
    8000b454:	0c010113          	addi	sp,sp,192
    8000b458:	00008067          	ret
    8000b45c:	000a3403          	ld	s0,0(s4)
    8000b460:	bf1f40ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000b464:	02014703          	lbu	a4,32(sp)
    8000b468:	ffc44783          	lbu	a5,-4(s0)
    8000b46c:	07f7f793          	andi	a5,a5,127
    8000b470:	00f70a63          	beq	a4,a5,8000b484 <list_sem+0x11c>
    8000b474:	be5f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000b478:	0019899b          	addiw	s3,s3,1
    8000b47c:	008a0a13          	addi	s4,s4,8
    8000b480:	f9dff06f          	j	8000b41c <list_sem+0xb4>
    8000b484:	bd5f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000b488:	01043783          	ld	a5,16(s0)
    8000b48c:	fe840693          	addi	a3,s0,-24
    8000b490:	01040913          	addi	s2,s0,16
    8000b494:	00d13423          	sd	a3,8(sp)
    8000b498:	00090513          	mv	a0,s2
    8000b49c:	02f90c63          	beq	s2,a5,8000b4d4 <list_sem+0x16c>
    8000b4a0:	889ff0ef          	jal	ra,8000ad28 <rt_list_len>
    8000b4a4:	02045703          	lhu	a4,32(s0)
    8000b4a8:	00813683          	ld	a3,8(sp)
    8000b4ac:	0005079b          	sext.w	a5,a0
    8000b4b0:	01400613          	li	a2,20
    8000b4b4:	01400593          	li	a1,20
    8000b4b8:	000b8513          	mv	a0,s7
    8000b4bc:	d30fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b4c0:	00090513          	mv	a0,s2
    8000b4c4:	8cdff0ef          	jal	ra,8000ad90 <show_wait_queue>
    8000b4c8:	000c0513          	mv	a0,s8
    8000b4cc:	d20fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b4d0:	fa9ff06f          	j	8000b478 <list_sem+0x110>
    8000b4d4:	855ff0ef          	jal	ra,8000ad28 <rt_list_len>
    8000b4d8:	02045703          	lhu	a4,32(s0)
    8000b4dc:	00813683          	ld	a3,8(sp)
    8000b4e0:	0005079b          	sext.w	a5,a0
    8000b4e4:	01400613          	li	a2,20
    8000b4e8:	01400593          	li	a1,20
    8000b4ec:	000b0513          	mv	a0,s6
    8000b4f0:	cfcfb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b4f4:	f85ff06f          	j	8000b478 <list_sem+0x110>

000000008000b4f8 <list_event>:
    8000b4f8:	f4010113          	addi	sp,sp,-192
    8000b4fc:	00400513          	li	a0,4
    8000b500:	0a113c23          	sd	ra,184(sp)
    8000b504:	0a913423          	sd	s1,168(sp)
    8000b508:	09513423          	sd	s5,136(sp)
    8000b50c:	09613023          	sd	s6,128(sp)
    8000b510:	07713c23          	sd	s7,120(sp)
    8000b514:	07813823          	sd	s8,112(sp)
    8000b518:	0a813823          	sd	s0,176(sp)
    8000b51c:	0b213023          	sd	s2,160(sp)
    8000b520:	09313c23          	sd	s3,152(sp)
    8000b524:	09413823          	sd	s4,144(sp)
    8000b528:	bc0fc0ef          	jal	ra,800078e8 <rt_object_get_information>
    8000b52c:	00850513          	addi	a0,a0,8
    8000b530:	00400793          	li	a5,4
    8000b534:	00008617          	auipc	a2,0x8
    8000b538:	94460613          	addi	a2,a2,-1724 # 80012e78 <__FUNCTION__.6+0x290>
    8000b53c:	01400593          	li	a1,20
    8000b540:	00a13823          	sd	a0,16(sp)
    8000b544:	02f10023          	sb	a5,32(sp)
    8000b548:	00008517          	auipc	a0,0x8
    8000b54c:	93850513          	addi	a0,a0,-1736 # 80012e80 <__FUNCTION__.6+0x298>
    8000b550:	00800793          	li	a5,8
    8000b554:	03010a93          	addi	s5,sp,48
    8000b558:	02f12223          	sw	a5,36(sp)
    8000b55c:	01513c23          	sd	s5,24(sp)
    8000b560:	02012423          	sw	zero,40(sp)
    8000b564:	c88fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b568:	a3dff0ef          	jal	ra,8000afa4 <object_split.constprop.0>
    8000b56c:	00008517          	auipc	a0,0x8
    8000b570:	93c50513          	addi	a0,a0,-1732 # 80012ea8 <__FUNCTION__.6+0x2c0>
    8000b574:	c78fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b578:	00000493          	li	s1,0
    8000b57c:	00008b17          	auipc	s6,0x8
    8000b580:	964b0b13          	addi	s6,s6,-1692 # 80012ee0 <__FUNCTION__.6+0x2f8>
    8000b584:	00008b97          	auipc	s7,0x8
    8000b588:	944b8b93          	addi	s7,s7,-1724 # 80012ec8 <__FUNCTION__.6+0x2e0>
    8000b58c:	00007c17          	auipc	s8,0x7
    8000b590:	684c0c13          	addi	s8,s8,1668 # 80012c10 <__FUNCTION__.6+0x28>
    8000b594:	00048513          	mv	a0,s1
    8000b598:	01010593          	addi	a1,sp,16
    8000b59c:	929ff0ef          	jal	ra,8000aec4 <list_get_next>
    8000b5a0:	00050493          	mv	s1,a0
    8000b5a4:	000a8993          	mv	s3,s5
    8000b5a8:	00000913          	li	s2,0
    8000b5ac:	02812783          	lw	a5,40(sp)
    8000b5b0:	02f94e63          	blt	s2,a5,8000b5ec <list_event+0xf4>
    8000b5b4:	fe0490e3          	bnez	s1,8000b594 <list_event+0x9c>
    8000b5b8:	0b813083          	ld	ra,184(sp)
    8000b5bc:	0b013403          	ld	s0,176(sp)
    8000b5c0:	0a813483          	ld	s1,168(sp)
    8000b5c4:	0a013903          	ld	s2,160(sp)
    8000b5c8:	09813983          	ld	s3,152(sp)
    8000b5cc:	09013a03          	ld	s4,144(sp)
    8000b5d0:	08813a83          	ld	s5,136(sp)
    8000b5d4:	08013b03          	ld	s6,128(sp)
    8000b5d8:	07813b83          	ld	s7,120(sp)
    8000b5dc:	07013c03          	ld	s8,112(sp)
    8000b5e0:	00000513          	li	a0,0
    8000b5e4:	0c010113          	addi	sp,sp,192
    8000b5e8:	00008067          	ret
    8000b5ec:	0009b403          	ld	s0,0(s3)
    8000b5f0:	a61f40ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000b5f4:	02014703          	lbu	a4,32(sp)
    8000b5f8:	ffc44783          	lbu	a5,-4(s0)
    8000b5fc:	07f7f793          	andi	a5,a5,127
    8000b600:	00f70a63          	beq	a4,a5,8000b614 <list_event+0x11c>
    8000b604:	a55f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000b608:	0019091b          	addiw	s2,s2,1
    8000b60c:	00898993          	addi	s3,s3,8
    8000b610:	f9dff06f          	j	8000b5ac <list_event+0xb4>
    8000b614:	a45f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000b618:	01043783          	ld	a5,16(s0)
    8000b61c:	01040a13          	addi	s4,s0,16
    8000b620:	fe840693          	addi	a3,s0,-24
    8000b624:	04fa0063          	beq	s4,a5,8000b664 <list_event+0x16c>
    8000b628:	000a0513          	mv	a0,s4
    8000b62c:	00d13423          	sd	a3,8(sp)
    8000b630:	ef8ff0ef          	jal	ra,8000ad28 <rt_list_len>
    8000b634:	02042703          	lw	a4,32(s0)
    8000b638:	00813683          	ld	a3,8(sp)
    8000b63c:	0005079b          	sext.w	a5,a0
    8000b640:	01400613          	li	a2,20
    8000b644:	01400593          	li	a1,20
    8000b648:	000b8513          	mv	a0,s7
    8000b64c:	ba0fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b650:	000a0513          	mv	a0,s4
    8000b654:	f3cff0ef          	jal	ra,8000ad90 <show_wait_queue>
    8000b658:	000c0513          	mv	a0,s8
    8000b65c:	b90fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b660:	fa9ff06f          	j	8000b608 <list_event+0x110>
    8000b664:	02042703          	lw	a4,32(s0)
    8000b668:	01400613          	li	a2,20
    8000b66c:	01400593          	li	a1,20
    8000b670:	000b0513          	mv	a0,s6
    8000b674:	b78fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b678:	f91ff06f          	j	8000b608 <list_event+0x110>

000000008000b67c <list_mutex>:
    8000b67c:	f5010113          	addi	sp,sp,-176
    8000b680:	00300513          	li	a0,3
    8000b684:	0a113423          	sd	ra,168(sp)
    8000b688:	0a813023          	sd	s0,160(sp)
    8000b68c:	09413023          	sd	s4,128(sp)
    8000b690:	07513c23          	sd	s5,120(sp)
    8000b694:	08913c23          	sd	s1,152(sp)
    8000b698:	09213823          	sd	s2,144(sp)
    8000b69c:	09313423          	sd	s3,136(sp)
    8000b6a0:	a48fc0ef          	jal	ra,800078e8 <rt_object_get_information>
    8000b6a4:	00850513          	addi	a0,a0,8
    8000b6a8:	00300793          	li	a5,3
    8000b6ac:	00008617          	auipc	a2,0x8
    8000b6b0:	84c60613          	addi	a2,a2,-1972 # 80012ef8 <__FUNCTION__.6+0x310>
    8000b6b4:	01400593          	li	a1,20
    8000b6b8:	00a13823          	sd	a0,16(sp)
    8000b6bc:	02f10023          	sb	a5,32(sp)
    8000b6c0:	00008517          	auipc	a0,0x8
    8000b6c4:	84050513          	addi	a0,a0,-1984 # 80012f00 <__FUNCTION__.6+0x318>
    8000b6c8:	00800793          	li	a5,8
    8000b6cc:	03010a13          	addi	s4,sp,48
    8000b6d0:	02f12223          	sw	a5,36(sp)
    8000b6d4:	01413c23          	sd	s4,24(sp)
    8000b6d8:	02012423          	sw	zero,40(sp)
    8000b6dc:	b10fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b6e0:	8c5ff0ef          	jal	ra,8000afa4 <object_split.constprop.0>
    8000b6e4:	00008517          	auipc	a0,0x8
    8000b6e8:	84450513          	addi	a0,a0,-1980 # 80012f28 <__FUNCTION__.6+0x340>
    8000b6ec:	b00fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b6f0:	00000413          	li	s0,0
    8000b6f4:	00008a97          	auipc	s5,0x8
    8000b6f8:	854a8a93          	addi	s5,s5,-1964 # 80012f48 <__FUNCTION__.6+0x360>
    8000b6fc:	00040513          	mv	a0,s0
    8000b700:	01010593          	addi	a1,sp,16
    8000b704:	fc0ff0ef          	jal	ra,8000aec4 <list_get_next>
    8000b708:	00050413          	mv	s0,a0
    8000b70c:	000a0993          	mv	s3,s4
    8000b710:	00000913          	li	s2,0
    8000b714:	02812783          	lw	a5,40(sp)
    8000b718:	02f94863          	blt	s2,a5,8000b748 <list_mutex+0xcc>
    8000b71c:	fe0410e3          	bnez	s0,8000b6fc <list_mutex+0x80>
    8000b720:	0a813083          	ld	ra,168(sp)
    8000b724:	0a013403          	ld	s0,160(sp)
    8000b728:	09813483          	ld	s1,152(sp)
    8000b72c:	09013903          	ld	s2,144(sp)
    8000b730:	08813983          	ld	s3,136(sp)
    8000b734:	08013a03          	ld	s4,128(sp)
    8000b738:	07813a83          	ld	s5,120(sp)
    8000b73c:	00000513          	li	a0,0
    8000b740:	0b010113          	addi	sp,sp,176
    8000b744:	00008067          	ret
    8000b748:	0009b483          	ld	s1,0(s3)
    8000b74c:	905f40ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000b750:	02014703          	lbu	a4,32(sp)
    8000b754:	ffc4c783          	lbu	a5,-4(s1)
    8000b758:	07f7f793          	andi	a5,a5,127
    8000b75c:	00f70a63          	beq	a4,a5,8000b770 <list_mutex+0xf4>
    8000b760:	8f9f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000b764:	0019091b          	addiw	s2,s2,1
    8000b768:	00898993          	addi	s3,s3,8
    8000b76c:	fa9ff06f          	j	8000b714 <list_mutex+0x98>
    8000b770:	8e9f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000b774:	fe848693          	addi	a3,s1,-24
    8000b778:	01048513          	addi	a0,s1,16
    8000b77c:	00d13423          	sd	a3,8(sp)
    8000b780:	da8ff0ef          	jal	ra,8000ad28 <rt_list_len>
    8000b784:	0234c803          	lbu	a6,35(s1)
    8000b788:	0284b783          	ld	a5,40(s1)
    8000b78c:	00813683          	ld	a3,8(sp)
    8000b790:	0005089b          	sext.w	a7,a0
    8000b794:	01400713          	li	a4,20
    8000b798:	01400613          	li	a2,20
    8000b79c:	01400593          	li	a1,20
    8000b7a0:	000a8513          	mv	a0,s5
    8000b7a4:	a48fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b7a8:	fbdff06f          	j	8000b764 <list_mutex+0xe8>

000000008000b7ac <list_mailbox>:
    8000b7ac:	f4010113          	addi	sp,sp,-192
    8000b7b0:	00500513          	li	a0,5
    8000b7b4:	0a113c23          	sd	ra,184(sp)
    8000b7b8:	0a913423          	sd	s1,168(sp)
    8000b7bc:	09513423          	sd	s5,136(sp)
    8000b7c0:	09613023          	sd	s6,128(sp)
    8000b7c4:	07713c23          	sd	s7,120(sp)
    8000b7c8:	07813823          	sd	s8,112(sp)
    8000b7cc:	0a813823          	sd	s0,176(sp)
    8000b7d0:	0b213023          	sd	s2,160(sp)
    8000b7d4:	09313c23          	sd	s3,152(sp)
    8000b7d8:	09413823          	sd	s4,144(sp)
    8000b7dc:	90cfc0ef          	jal	ra,800078e8 <rt_object_get_information>
    8000b7e0:	00850513          	addi	a0,a0,8
    8000b7e4:	00500793          	li	a5,5
    8000b7e8:	00007617          	auipc	a2,0x7
    8000b7ec:	77860613          	addi	a2,a2,1912 # 80012f60 <__FUNCTION__.6+0x378>
    8000b7f0:	01400593          	li	a1,20
    8000b7f4:	00a13823          	sd	a0,16(sp)
    8000b7f8:	02f10023          	sb	a5,32(sp)
    8000b7fc:	00007517          	auipc	a0,0x7
    8000b800:	76c50513          	addi	a0,a0,1900 # 80012f68 <__FUNCTION__.6+0x380>
    8000b804:	00800793          	li	a5,8
    8000b808:	03010a93          	addi	s5,sp,48
    8000b80c:	02f12223          	sw	a5,36(sp)
    8000b810:	01513c23          	sd	s5,24(sp)
    8000b814:	02012423          	sw	zero,40(sp)
    8000b818:	9d4fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b81c:	f88ff0ef          	jal	ra,8000afa4 <object_split.constprop.0>
    8000b820:	00007517          	auipc	a0,0x7
    8000b824:	77050513          	addi	a0,a0,1904 # 80012f90 <__FUNCTION__.6+0x3a8>
    8000b828:	9c4fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b82c:	00000493          	li	s1,0
    8000b830:	00007b17          	auipc	s6,0x7
    8000b834:	798b0b13          	addi	s6,s6,1944 # 80012fc8 <__FUNCTION__.6+0x3e0>
    8000b838:	00007b97          	auipc	s7,0x7
    8000b83c:	778b8b93          	addi	s7,s7,1912 # 80012fb0 <__FUNCTION__.6+0x3c8>
    8000b840:	00007c17          	auipc	s8,0x7
    8000b844:	3d0c0c13          	addi	s8,s8,976 # 80012c10 <__FUNCTION__.6+0x28>
    8000b848:	00048513          	mv	a0,s1
    8000b84c:	01010593          	addi	a1,sp,16
    8000b850:	e74ff0ef          	jal	ra,8000aec4 <list_get_next>
    8000b854:	00050493          	mv	s1,a0
    8000b858:	000a8a13          	mv	s4,s5
    8000b85c:	00000993          	li	s3,0
    8000b860:	02812783          	lw	a5,40(sp)
    8000b864:	02f9ce63          	blt	s3,a5,8000b8a0 <list_mailbox+0xf4>
    8000b868:	fe0490e3          	bnez	s1,8000b848 <list_mailbox+0x9c>
    8000b86c:	0b813083          	ld	ra,184(sp)
    8000b870:	0b013403          	ld	s0,176(sp)
    8000b874:	0a813483          	ld	s1,168(sp)
    8000b878:	0a013903          	ld	s2,160(sp)
    8000b87c:	09813983          	ld	s3,152(sp)
    8000b880:	09013a03          	ld	s4,144(sp)
    8000b884:	08813a83          	ld	s5,136(sp)
    8000b888:	08013b03          	ld	s6,128(sp)
    8000b88c:	07813b83          	ld	s7,120(sp)
    8000b890:	07013c03          	ld	s8,112(sp)
    8000b894:	00000513          	li	a0,0
    8000b898:	0c010113          	addi	sp,sp,192
    8000b89c:	00008067          	ret
    8000b8a0:	000a3403          	ld	s0,0(s4)
    8000b8a4:	facf40ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000b8a8:	02014703          	lbu	a4,32(sp)
    8000b8ac:	ffc44783          	lbu	a5,-4(s0)
    8000b8b0:	07f7f793          	andi	a5,a5,127
    8000b8b4:	00f70a63          	beq	a4,a5,8000b8c8 <list_mailbox+0x11c>
    8000b8b8:	fa0f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000b8bc:	0019899b          	addiw	s3,s3,1
    8000b8c0:	008a0a13          	addi	s4,s4,8
    8000b8c4:	f9dff06f          	j	8000b860 <list_mailbox+0xb4>
    8000b8c8:	f90f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000b8cc:	01043783          	ld	a5,16(s0)
    8000b8d0:	fe840693          	addi	a3,s0,-24
    8000b8d4:	01040913          	addi	s2,s0,16
    8000b8d8:	00d13423          	sd	a3,8(sp)
    8000b8dc:	00090513          	mv	a0,s2
    8000b8e0:	02f90e63          	beq	s2,a5,8000b91c <list_mailbox+0x170>
    8000b8e4:	c44ff0ef          	jal	ra,8000ad28 <rt_list_len>
    8000b8e8:	02845783          	lhu	a5,40(s0)
    8000b8ec:	02a45703          	lhu	a4,42(s0)
    8000b8f0:	00813683          	ld	a3,8(sp)
    8000b8f4:	0005081b          	sext.w	a6,a0
    8000b8f8:	01400613          	li	a2,20
    8000b8fc:	01400593          	li	a1,20
    8000b900:	000b8513          	mv	a0,s7
    8000b904:	8e8fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b908:	00090513          	mv	a0,s2
    8000b90c:	c84ff0ef          	jal	ra,8000ad90 <show_wait_queue>
    8000b910:	000c0513          	mv	a0,s8
    8000b914:	8d8fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b918:	fa5ff06f          	j	8000b8bc <list_mailbox+0x110>
    8000b91c:	c0cff0ef          	jal	ra,8000ad28 <rt_list_len>
    8000b920:	02845783          	lhu	a5,40(s0)
    8000b924:	02a45703          	lhu	a4,42(s0)
    8000b928:	00813683          	ld	a3,8(sp)
    8000b92c:	0005081b          	sext.w	a6,a0
    8000b930:	01400613          	li	a2,20
    8000b934:	01400593          	li	a1,20
    8000b938:	000b0513          	mv	a0,s6
    8000b93c:	8b0fb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b940:	f7dff06f          	j	8000b8bc <list_mailbox+0x110>

000000008000b944 <list_msgqueue>:
    8000b944:	f4010113          	addi	sp,sp,-192
    8000b948:	00600513          	li	a0,6
    8000b94c:	0a113c23          	sd	ra,184(sp)
    8000b950:	0a913423          	sd	s1,168(sp)
    8000b954:	09513423          	sd	s5,136(sp)
    8000b958:	09613023          	sd	s6,128(sp)
    8000b95c:	07713c23          	sd	s7,120(sp)
    8000b960:	07813823          	sd	s8,112(sp)
    8000b964:	0a813823          	sd	s0,176(sp)
    8000b968:	0b213023          	sd	s2,160(sp)
    8000b96c:	09313c23          	sd	s3,152(sp)
    8000b970:	09413823          	sd	s4,144(sp)
    8000b974:	f75fb0ef          	jal	ra,800078e8 <rt_object_get_information>
    8000b978:	00850513          	addi	a0,a0,8
    8000b97c:	00600793          	li	a5,6
    8000b980:	00007617          	auipc	a2,0x7
    8000b984:	66060613          	addi	a2,a2,1632 # 80012fe0 <__FUNCTION__.6+0x3f8>
    8000b988:	01400593          	li	a1,20
    8000b98c:	00a13823          	sd	a0,16(sp)
    8000b990:	02f10023          	sb	a5,32(sp)
    8000b994:	00007517          	auipc	a0,0x7
    8000b998:	65c50513          	addi	a0,a0,1628 # 80012ff0 <__FUNCTION__.6+0x408>
    8000b99c:	00800793          	li	a5,8
    8000b9a0:	03010a93          	addi	s5,sp,48
    8000b9a4:	02f12223          	sw	a5,36(sp)
    8000b9a8:	01513c23          	sd	s5,24(sp)
    8000b9ac:	02012423          	sw	zero,40(sp)
    8000b9b0:	83cfb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b9b4:	df0ff0ef          	jal	ra,8000afa4 <object_split.constprop.0>
    8000b9b8:	00007517          	auipc	a0,0x7
    8000b9bc:	65850513          	addi	a0,a0,1624 # 80013010 <__FUNCTION__.6+0x428>
    8000b9c0:	82cfb0ef          	jal	ra,800069ec <rt_kprintf>
    8000b9c4:	00000493          	li	s1,0
    8000b9c8:	00007b17          	auipc	s6,0x7
    8000b9cc:	678b0b13          	addi	s6,s6,1656 # 80013040 <__FUNCTION__.6+0x458>
    8000b9d0:	00007b97          	auipc	s7,0x7
    8000b9d4:	658b8b93          	addi	s7,s7,1624 # 80013028 <__FUNCTION__.6+0x440>
    8000b9d8:	00007c17          	auipc	s8,0x7
    8000b9dc:	238c0c13          	addi	s8,s8,568 # 80012c10 <__FUNCTION__.6+0x28>
    8000b9e0:	00048513          	mv	a0,s1
    8000b9e4:	01010593          	addi	a1,sp,16
    8000b9e8:	cdcff0ef          	jal	ra,8000aec4 <list_get_next>
    8000b9ec:	00050493          	mv	s1,a0
    8000b9f0:	000a8a13          	mv	s4,s5
    8000b9f4:	00000993          	li	s3,0
    8000b9f8:	02812783          	lw	a5,40(sp)
    8000b9fc:	02f9ce63          	blt	s3,a5,8000ba38 <list_msgqueue+0xf4>
    8000ba00:	fe0490e3          	bnez	s1,8000b9e0 <list_msgqueue+0x9c>
    8000ba04:	0b813083          	ld	ra,184(sp)
    8000ba08:	0b013403          	ld	s0,176(sp)
    8000ba0c:	0a813483          	ld	s1,168(sp)
    8000ba10:	0a013903          	ld	s2,160(sp)
    8000ba14:	09813983          	ld	s3,152(sp)
    8000ba18:	09013a03          	ld	s4,144(sp)
    8000ba1c:	08813a83          	ld	s5,136(sp)
    8000ba20:	08013b03          	ld	s6,128(sp)
    8000ba24:	07813b83          	ld	s7,120(sp)
    8000ba28:	07013c03          	ld	s8,112(sp)
    8000ba2c:	00000513          	li	a0,0
    8000ba30:	0c010113          	addi	sp,sp,192
    8000ba34:	00008067          	ret
    8000ba38:	000a3403          	ld	s0,0(s4)
    8000ba3c:	e14f40ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000ba40:	02014703          	lbu	a4,32(sp)
    8000ba44:	ffc44783          	lbu	a5,-4(s0)
    8000ba48:	07f7f793          	andi	a5,a5,127
    8000ba4c:	00f70a63          	beq	a4,a5,8000ba60 <list_msgqueue+0x11c>
    8000ba50:	e08f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000ba54:	0019899b          	addiw	s3,s3,1
    8000ba58:	008a0a13          	addi	s4,s4,8
    8000ba5c:	f9dff06f          	j	8000b9f8 <list_msgqueue+0xb4>
    8000ba60:	df8f40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000ba64:	01043783          	ld	a5,16(s0)
    8000ba68:	fe840693          	addi	a3,s0,-24
    8000ba6c:	01040913          	addi	s2,s0,16
    8000ba70:	00d13423          	sd	a3,8(sp)
    8000ba74:	00090513          	mv	a0,s2
    8000ba78:	02f90c63          	beq	s2,a5,8000bab0 <list_msgqueue+0x16c>
    8000ba7c:	aacff0ef          	jal	ra,8000ad28 <rt_list_len>
    8000ba80:	02c45703          	lhu	a4,44(s0)
    8000ba84:	00813683          	ld	a3,8(sp)
    8000ba88:	0005079b          	sext.w	a5,a0
    8000ba8c:	01400613          	li	a2,20
    8000ba90:	01400593          	li	a1,20
    8000ba94:	000b8513          	mv	a0,s7
    8000ba98:	f55fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000ba9c:	00090513          	mv	a0,s2
    8000baa0:	af0ff0ef          	jal	ra,8000ad90 <show_wait_queue>
    8000baa4:	000c0513          	mv	a0,s8
    8000baa8:	f45fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000baac:	fa9ff06f          	j	8000ba54 <list_msgqueue+0x110>
    8000bab0:	a78ff0ef          	jal	ra,8000ad28 <rt_list_len>
    8000bab4:	02c45703          	lhu	a4,44(s0)
    8000bab8:	00813683          	ld	a3,8(sp)
    8000babc:	0005079b          	sext.w	a5,a0
    8000bac0:	01400613          	li	a2,20
    8000bac4:	01400593          	li	a1,20
    8000bac8:	000b0513          	mv	a0,s6
    8000bacc:	f21fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bad0:	f85ff06f          	j	8000ba54 <list_msgqueue+0x110>

000000008000bad4 <list_mempool>:
    8000bad4:	f5010113          	addi	sp,sp,-176
    8000bad8:	00800513          	li	a0,8
    8000badc:	0a113423          	sd	ra,168(sp)
    8000bae0:	08913c23          	sd	s1,152(sp)
    8000bae4:	09413023          	sd	s4,128(sp)
    8000bae8:	07513c23          	sd	s5,120(sp)
    8000baec:	07613823          	sd	s6,112(sp)
    8000baf0:	07713423          	sd	s7,104(sp)
    8000baf4:	0a813023          	sd	s0,160(sp)
    8000baf8:	09213823          	sd	s2,144(sp)
    8000bafc:	09313423          	sd	s3,136(sp)
    8000bb00:	07813023          	sd	s8,96(sp)
    8000bb04:	de5fb0ef          	jal	ra,800078e8 <rt_object_get_information>
    8000bb08:	00850513          	addi	a0,a0,8
    8000bb0c:	00800793          	li	a5,8
    8000bb10:	00007617          	auipc	a2,0x7
    8000bb14:	54860613          	addi	a2,a2,1352 # 80013058 <__FUNCTION__.6+0x470>
    8000bb18:	01400593          	li	a1,20
    8000bb1c:	00a13023          	sd	a0,0(sp)
    8000bb20:	02010a13          	addi	s4,sp,32
    8000bb24:	00007517          	auipc	a0,0x7
    8000bb28:	53c50513          	addi	a0,a0,1340 # 80013060 <__FUNCTION__.6+0x478>
    8000bb2c:	00f10823          	sb	a5,16(sp)
    8000bb30:	00f12a23          	sw	a5,20(sp)
    8000bb34:	01413423          	sd	s4,8(sp)
    8000bb38:	00012c23          	sw	zero,24(sp)
    8000bb3c:	eb1fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bb40:	c64ff0ef          	jal	ra,8000afa4 <object_split.constprop.0>
    8000bb44:	00007517          	auipc	a0,0x7
    8000bb48:	54450513          	addi	a0,a0,1348 # 80013088 <__FUNCTION__.6+0x4a0>
    8000bb4c:	ea1fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bb50:	00000493          	li	s1,0
    8000bb54:	00007a97          	auipc	s5,0x7
    8000bb58:	57ca8a93          	addi	s5,s5,1404 # 800130d0 <__FUNCTION__.6+0x4e8>
    8000bb5c:	00007b17          	auipc	s6,0x7
    8000bb60:	554b0b13          	addi	s6,s6,1364 # 800130b0 <__FUNCTION__.6+0x4c8>
    8000bb64:	00007b97          	auipc	s7,0x7
    8000bb68:	0acb8b93          	addi	s7,s7,172 # 80012c10 <__FUNCTION__.6+0x28>
    8000bb6c:	00048513          	mv	a0,s1
    8000bb70:	00010593          	mv	a1,sp
    8000bb74:	b50ff0ef          	jal	ra,8000aec4 <list_get_next>
    8000bb78:	00050493          	mv	s1,a0
    8000bb7c:	000a0993          	mv	s3,s4
    8000bb80:	00000913          	li	s2,0
    8000bb84:	01812783          	lw	a5,24(sp)
    8000bb88:	02f94e63          	blt	s2,a5,8000bbc4 <list_mempool+0xf0>
    8000bb8c:	fe0490e3          	bnez	s1,8000bb6c <list_mempool+0x98>
    8000bb90:	0a813083          	ld	ra,168(sp)
    8000bb94:	0a013403          	ld	s0,160(sp)
    8000bb98:	09813483          	ld	s1,152(sp)
    8000bb9c:	09013903          	ld	s2,144(sp)
    8000bba0:	08813983          	ld	s3,136(sp)
    8000bba4:	08013a03          	ld	s4,128(sp)
    8000bba8:	07813a83          	ld	s5,120(sp)
    8000bbac:	07013b03          	ld	s6,112(sp)
    8000bbb0:	06813b83          	ld	s7,104(sp)
    8000bbb4:	06013c03          	ld	s8,96(sp)
    8000bbb8:	00000513          	li	a0,0
    8000bbbc:	0b010113          	addi	sp,sp,176
    8000bbc0:	00008067          	ret
    8000bbc4:	0009b403          	ld	s0,0(s3)
    8000bbc8:	c88f40ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000bbcc:	01014703          	lbu	a4,16(sp)
    8000bbd0:	ffc44783          	lbu	a5,-4(s0)
    8000bbd4:	07f7f793          	andi	a5,a5,127
    8000bbd8:	00f70a63          	beq	a4,a5,8000bbec <list_mempool+0x118>
    8000bbdc:	c7cf40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000bbe0:	0019091b          	addiw	s2,s2,1
    8000bbe4:	00898993          	addi	s3,s3,8
    8000bbe8:	f9dff06f          	j	8000bb84 <list_mempool+0xb0>
    8000bbec:	c6cf40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000bbf0:	04043783          	ld	a5,64(s0)
    8000bbf4:	00000893          	li	a7,0
    8000bbf8:	fe840693          	addi	a3,s0,-24
    8000bbfc:	04040c13          	addi	s8,s0,64
    8000bc00:	02fc1c63          	bne	s8,a5,8000bc38 <list_mempool+0x164>
    8000bc04:	02043703          	ld	a4,32(s0)
    8000bc08:	03043783          	ld	a5,48(s0)
    8000bc0c:	03843803          	ld	a6,56(s0)
    8000bc10:	02088a63          	beqz	a7,8000bc44 <list_mempool+0x170>
    8000bc14:	01400613          	li	a2,20
    8000bc18:	01400593          	li	a1,20
    8000bc1c:	000b0513          	mv	a0,s6
    8000bc20:	dcdfa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bc24:	000c0513          	mv	a0,s8
    8000bc28:	968ff0ef          	jal	ra,8000ad90 <show_wait_queue>
    8000bc2c:	000b8513          	mv	a0,s7
    8000bc30:	dbdfa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bc34:	fadff06f          	j	8000bbe0 <list_mempool+0x10c>
    8000bc38:	0007b783          	ld	a5,0(a5)
    8000bc3c:	0018889b          	addiw	a7,a7,1
    8000bc40:	fc1ff06f          	j	8000bc00 <list_mempool+0x12c>
    8000bc44:	00000893          	li	a7,0
    8000bc48:	01400613          	li	a2,20
    8000bc4c:	01400593          	li	a1,20
    8000bc50:	000a8513          	mv	a0,s5
    8000bc54:	d99fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bc58:	f89ff06f          	j	8000bbe0 <list_mempool+0x10c>

000000008000bc5c <list_device>:
    8000bc5c:	f5010113          	addi	sp,sp,-176
    8000bc60:	00900513          	li	a0,9
    8000bc64:	0a113423          	sd	ra,168(sp)
    8000bc68:	0a813023          	sd	s0,160(sp)
    8000bc6c:	09313423          	sd	s3,136(sp)
    8000bc70:	09413023          	sd	s4,128(sp)
    8000bc74:	07513c23          	sd	s5,120(sp)
    8000bc78:	07613823          	sd	s6,112(sp)
    8000bc7c:	07713423          	sd	s7,104(sp)
    8000bc80:	08913c23          	sd	s1,152(sp)
    8000bc84:	09213823          	sd	s2,144(sp)
    8000bc88:	07813023          	sd	s8,96(sp)
    8000bc8c:	c5dfb0ef          	jal	ra,800078e8 <rt_object_get_information>
    8000bc90:	00850513          	addi	a0,a0,8
    8000bc94:	00900793          	li	a5,9
    8000bc98:	00007617          	auipc	a2,0x7
    8000bc9c:	46060613          	addi	a2,a2,1120 # 800130f8 <__FUNCTION__.6+0x510>
    8000bca0:	01400593          	li	a1,20
    8000bca4:	00a13023          	sd	a0,0(sp)
    8000bca8:	00f10823          	sb	a5,16(sp)
    8000bcac:	00007517          	auipc	a0,0x7
    8000bcb0:	45450513          	addi	a0,a0,1108 # 80013100 <__FUNCTION__.6+0x518>
    8000bcb4:	00800793          	li	a5,8
    8000bcb8:	02010993          	addi	s3,sp,32
    8000bcbc:	00f12a23          	sw	a5,20(sp)
    8000bcc0:	01313423          	sd	s3,8(sp)
    8000bcc4:	00012c23          	sw	zero,24(sp)
    8000bcc8:	d25fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bccc:	ad8ff0ef          	jal	ra,8000afa4 <object_split.constprop.0>
    8000bcd0:	00007517          	auipc	a0,0x7
    8000bcd4:	45850513          	addi	a0,a0,1112 # 80013128 <__FUNCTION__.6+0x540>
    8000bcd8:	d15fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bcdc:	00000413          	li	s0,0
    8000bce0:	01600a13          	li	s4,22
    8000bce4:	00007a97          	auipc	s5,0x7
    8000bce8:	40ca8a93          	addi	s5,s5,1036 # 800130f0 <__FUNCTION__.6+0x508>
    8000bcec:	00007b17          	auipc	s6,0x7
    8000bcf0:	464b0b13          	addi	s6,s6,1124 # 80013150 <__FUNCTION__.6+0x568>
    8000bcf4:	00007b97          	auipc	s7,0x7
    8000bcf8:	5dcb8b93          	addi	s7,s7,1500 # 800132d0 <device_type_str>
    8000bcfc:	00040513          	mv	a0,s0
    8000bd00:	00010593          	mv	a1,sp
    8000bd04:	9c0ff0ef          	jal	ra,8000aec4 <list_get_next>
    8000bd08:	00050413          	mv	s0,a0
    8000bd0c:	00098913          	mv	s2,s3
    8000bd10:	00000493          	li	s1,0
    8000bd14:	01812783          	lw	a5,24(sp)
    8000bd18:	02f4ce63          	blt	s1,a5,8000bd54 <list_device+0xf8>
    8000bd1c:	fe0410e3          	bnez	s0,8000bcfc <list_device+0xa0>
    8000bd20:	0a813083          	ld	ra,168(sp)
    8000bd24:	0a013403          	ld	s0,160(sp)
    8000bd28:	09813483          	ld	s1,152(sp)
    8000bd2c:	09013903          	ld	s2,144(sp)
    8000bd30:	08813983          	ld	s3,136(sp)
    8000bd34:	08013a03          	ld	s4,128(sp)
    8000bd38:	07813a83          	ld	s5,120(sp)
    8000bd3c:	07013b03          	ld	s6,112(sp)
    8000bd40:	06813b83          	ld	s7,104(sp)
    8000bd44:	06013c03          	ld	s8,96(sp)
    8000bd48:	00000513          	li	a0,0
    8000bd4c:	0b010113          	addi	sp,sp,176
    8000bd50:	00008067          	ret
    8000bd54:	00093c03          	ld	s8,0(s2)
    8000bd58:	af8f40ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000bd5c:	01014703          	lbu	a4,16(sp)
    8000bd60:	ffcc4783          	lbu	a5,-4(s8)
    8000bd64:	07f7f793          	andi	a5,a5,127
    8000bd68:	00f70a63          	beq	a4,a5,8000bd7c <list_device+0x120>
    8000bd6c:	aecf40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000bd70:	0014849b          	addiw	s1,s1,1
    8000bd74:	00890913          	addi	s2,s2,8
    8000bd78:	f9dff06f          	j	8000bd14 <list_device+0xb8>
    8000bd7c:	adcf40ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000bd80:	010c2783          	lw	a5,16(s8)
    8000bd84:	fe8c0693          	addi	a3,s8,-24
    8000bd88:	000a8713          	mv	a4,s5
    8000bd8c:	00fa6a63          	bltu	s4,a5,8000bda0 <list_device+0x144>
    8000bd90:	02079793          	slli	a5,a5,0x20
    8000bd94:	01d7d793          	srli	a5,a5,0x1d
    8000bd98:	00fb87b3          	add	a5,s7,a5
    8000bd9c:	0007b703          	ld	a4,0(a5)
    8000bda0:	018c4783          	lbu	a5,24(s8)
    8000bda4:	01400613          	li	a2,20
    8000bda8:	01400593          	li	a1,20
    8000bdac:	000b0513          	mv	a0,s6
    8000bdb0:	c3dfa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bdb4:	fbdff06f          	j	8000bd70 <list_device+0x114>

000000008000bdb8 <list_fd>:
    8000bdb8:	fa010113          	addi	sp,sp,-96
    8000bdbc:	04113c23          	sd	ra,88(sp)
    8000bdc0:	04913423          	sd	s1,72(sp)
    8000bdc4:	05213023          	sd	s2,64(sp)
    8000bdc8:	03313c23          	sd	s3,56(sp)
    8000bdcc:	03413823          	sd	s4,48(sp)
    8000bdd0:	03513423          	sd	s5,40(sp)
    8000bdd4:	03613023          	sd	s6,32(sp)
    8000bdd8:	01713c23          	sd	s7,24(sp)
    8000bddc:	01813823          	sd	s8,16(sp)
    8000bde0:	01913423          	sd	s9,8(sp)
    8000bde4:	04813823          	sd	s0,80(sp)
    8000bde8:	af1f80ef          	jal	ra,800048d8 <rt_enter_critical>
    8000bdec:	00008517          	auipc	a0,0x8
    8000bdf0:	9cc50513          	addi	a0,a0,-1588 # 800137b8 <__fsym_hello_name+0x8>
    8000bdf4:	bf9fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bdf8:	00008517          	auipc	a0,0x8
    8000bdfc:	9e050513          	addi	a0,a0,-1568 # 800137d8 <__fsym_hello_name+0x28>
    8000be00:	bedfa0ef          	jal	ra,800069ec <rt_kprintf>
    8000be04:	00000493          	li	s1,0
    8000be08:	0001b917          	auipc	s2,0x1b
    8000be0c:	b3890913          	addi	s2,s2,-1224 # 80026940 <_fdtab>
    8000be10:	00008997          	auipc	s3,0x8
    8000be14:	9e898993          	addi	s3,s3,-1560 # 800137f8 <__fsym_hello_name+0x48>
    8000be18:	00200a13          	li	s4,2
    8000be1c:	00008a97          	auipc	s5,0x8
    8000be20:	a1ca8a93          	addi	s5,s5,-1508 # 80013838 <__fsym_hello_name+0x88>
    8000be24:	00008b17          	auipc	s6,0x8
    8000be28:	a1cb0b13          	addi	s6,s6,-1508 # 80013840 <__fsym_hello_name+0x90>
    8000be2c:	00007b97          	auipc	s7,0x7
    8000be30:	de4b8b93          	addi	s7,s7,-540 # 80012c10 <__FUNCTION__.6+0x28>
    8000be34:	00006c17          	auipc	s8,0x6
    8000be38:	474c0c13          	addi	s8,s8,1140 # 800122a8 <CSWTCH.17+0x80>
    8000be3c:	00100c93          	li	s9,1
    8000be40:	00092703          	lw	a4,0(s2)
    8000be44:	0004879b          	sext.w	a5,s1
    8000be48:	04e7c063          	blt	a5,a4,8000be88 <list_fd+0xd0>
    8000be4c:	ab9f80ef          	jal	ra,80004904 <rt_exit_critical>
    8000be50:	05813083          	ld	ra,88(sp)
    8000be54:	05013403          	ld	s0,80(sp)
    8000be58:	04813483          	ld	s1,72(sp)
    8000be5c:	04013903          	ld	s2,64(sp)
    8000be60:	03813983          	ld	s3,56(sp)
    8000be64:	03013a03          	ld	s4,48(sp)
    8000be68:	02813a83          	ld	s5,40(sp)
    8000be6c:	02013b03          	ld	s6,32(sp)
    8000be70:	01813b83          	ld	s7,24(sp)
    8000be74:	01013c03          	ld	s8,16(sp)
    8000be78:	00813c83          	ld	s9,8(sp)
    8000be7c:	00000513          	li	a0,0
    8000be80:	06010113          	addi	sp,sp,96
    8000be84:	00008067          	ret
    8000be88:	00893783          	ld	a5,8(s2)
    8000be8c:	00349713          	slli	a4,s1,0x3
    8000be90:	00e787b3          	add	a5,a5,a4
    8000be94:	0007b403          	ld	s0,0(a5)
    8000be98:	08040c63          	beqz	s0,8000bf30 <list_fd+0x178>
    8000be9c:	02043783          	ld	a5,32(s0)
    8000bea0:	08078863          	beqz	a5,8000bf30 <list_fd+0x178>
    8000bea4:	0034859b          	addiw	a1,s1,3
    8000bea8:	00098513          	mv	a0,s3
    8000beac:	b41fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000beb0:	00245703          	lhu	a4,2(s0)
    8000beb4:	00008597          	auipc	a1,0x8
    8000beb8:	94c58593          	addi	a1,a1,-1716 # 80013800 <__fsym_hello_name+0x50>
    8000bebc:	0007079b          	sext.w	a5,a4
    8000bec0:	03470e63          	beq	a4,s4,8000befc <list_fd+0x144>
    8000bec4:	00008597          	auipc	a1,0x8
    8000bec8:	94c58593          	addi	a1,a1,-1716 # 80013810 <__fsym_hello_name+0x60>
    8000becc:	02070863          	beqz	a4,8000befc <list_fd+0x144>
    8000bed0:	00008597          	auipc	a1,0x8
    8000bed4:	94858593          	addi	a1,a1,-1720 # 80013818 <__fsym_hello_name+0x68>
    8000bed8:	03978263          	beq	a5,s9,8000befc <list_fd+0x144>
    8000bedc:	00300713          	li	a4,3
    8000bee0:	00008597          	auipc	a1,0x8
    8000bee4:	94058593          	addi	a1,a1,-1728 # 80013820 <__fsym_hello_name+0x70>
    8000bee8:	00e78a63          	beq	a5,a4,8000befc <list_fd+0x144>
    8000beec:	00400713          	li	a4,4
    8000bef0:	04e79463          	bne	a5,a4,8000bf38 <list_fd+0x180>
    8000bef4:	00007597          	auipc	a1,0x7
    8000bef8:	20458593          	addi	a1,a1,516 # 800130f8 <__FUNCTION__.6+0x510>
    8000befc:	00008517          	auipc	a0,0x8
    8000bf00:	90c50513          	addi	a0,a0,-1780 # 80013808 <__fsym_hello_name+0x58>
    8000bf04:	ae9fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bf08:	01042583          	lw	a1,16(s0)
    8000bf0c:	000a8513          	mv	a0,s5
    8000bf10:	addfa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bf14:	00045583          	lhu	a1,0(s0)
    8000bf18:	000b0513          	mv	a0,s6
    8000bf1c:	ad1fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bf20:	00843583          	ld	a1,8(s0)
    8000bf24:	02058463          	beqz	a1,8000bf4c <list_fd+0x194>
    8000bf28:	000c0513          	mv	a0,s8
    8000bf2c:	ac1fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bf30:	00148493          	addi	s1,s1,1
    8000bf34:	f0dff06f          	j	8000be40 <list_fd+0x88>
    8000bf38:	00008597          	auipc	a1,0x8
    8000bf3c:	8f058593          	addi	a1,a1,-1808 # 80013828 <__fsym_hello_name+0x78>
    8000bf40:	00008517          	auipc	a0,0x8
    8000bf44:	8f050513          	addi	a0,a0,-1808 # 80013830 <__fsym_hello_name+0x80>
    8000bf48:	fbdff06f          	j	8000bf04 <list_fd+0x14c>
    8000bf4c:	000b8513          	mv	a0,s7
    8000bf50:	a9dfa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bf54:	fddff06f          	j	8000bf30 <list_fd+0x178>

000000008000bf58 <dfs_init>:
    8000bf58:	fe010113          	addi	sp,sp,-32
    8000bf5c:	00813823          	sd	s0,16(sp)
    8000bf60:	00012417          	auipc	s0,0x12
    8000bf64:	ab040413          	addi	s0,s0,-1360 # 8001da10 <init_ok.3>
    8000bf68:	00042783          	lw	a5,0(s0)
    8000bf6c:	00113c23          	sd	ra,24(sp)
    8000bf70:	00913423          	sd	s1,8(sp)
    8000bf74:	02078463          	beqz	a5,8000bf9c <dfs_init+0x44>
    8000bf78:	00008517          	auipc	a0,0x8
    8000bf7c:	8d050513          	addi	a0,a0,-1840 # 80013848 <__fsym_hello_name+0x98>
    8000bf80:	a6dfa0ef          	jal	ra,800069ec <rt_kprintf>
    8000bf84:	01813083          	ld	ra,24(sp)
    8000bf88:	01013403          	ld	s0,16(sp)
    8000bf8c:	00813483          	ld	s1,8(sp)
    8000bf90:	00000513          	li	a0,0
    8000bf94:	02010113          	addi	sp,sp,32
    8000bf98:	00008067          	ret
    8000bf9c:	01000613          	li	a2,16
    8000bfa0:	00000593          	li	a1,0
    8000bfa4:	0001b517          	auipc	a0,0x1b
    8000bfa8:	9ac50513          	addi	a0,a0,-1620 # 80026950 <filesystem_operation_table>
    8000bfac:	bb1f70ef          	jal	ra,80003b5c <memset>
    8000bfb0:	04000613          	li	a2,64
    8000bfb4:	00000593          	li	a1,0
    8000bfb8:	0001b517          	auipc	a0,0x1b
    8000bfbc:	9a850513          	addi	a0,a0,-1624 # 80026960 <filesystem_table>
    8000bfc0:	b9df70ef          	jal	ra,80003b5c <memset>
    8000bfc4:	01000613          	li	a2,16
    8000bfc8:	00000593          	li	a1,0
    8000bfcc:	0001b517          	auipc	a0,0x1b
    8000bfd0:	97450513          	addi	a0,a0,-1676 # 80026940 <_fdtab>
    8000bfd4:	b89f70ef          	jal	ra,80003b5c <memset>
    8000bfd8:	00000613          	li	a2,0
    8000bfdc:	00008597          	auipc	a1,0x8
    8000bfe0:	88458593          	addi	a1,a1,-1916 # 80013860 <__fsym_hello_name+0xb0>
    8000bfe4:	0001b517          	auipc	a0,0x1b
    8000bfe8:	9bc50513          	addi	a0,a0,-1604 # 800269a0 <fslock>
    8000bfec:	9f0fc0ef          	jal	ra,800081dc <rt_mutex_init>
    8000bff0:	00009497          	auipc	s1,0x9
    8000bff4:	6b048493          	addi	s1,s1,1712 # 800156a0 <working_directory>
    8000bff8:	10000613          	li	a2,256
    8000bffc:	00000593          	li	a1,0
    8000c000:	00048513          	mv	a0,s1
    8000c004:	b59f70ef          	jal	ra,80003b5c <memset>
    8000c008:	02f00793          	li	a5,47
    8000c00c:	00f48023          	sb	a5,0(s1)
    8000c010:	585020ef          	jal	ra,8000ed94 <devfs_init>
    8000c014:	00000713          	li	a4,0
    8000c018:	00000693          	li	a3,0
    8000c01c:	00008617          	auipc	a2,0x8
    8000c020:	84c60613          	addi	a2,a2,-1972 # 80013868 <__fsym_hello_name+0xb8>
    8000c024:	00008597          	auipc	a1,0x8
    8000c028:	84c58593          	addi	a1,a1,-1972 # 80013870 <__fsym_hello_name+0xc0>
    8000c02c:	00000513          	li	a0,0
    8000c030:	4d9010ef          	jal	ra,8000dd08 <dfs_mount>
    8000c034:	00100793          	li	a5,1
    8000c038:	00f42023          	sw	a5,0(s0)
    8000c03c:	f49ff06f          	j	8000bf84 <dfs_init+0x2c>

000000008000c040 <dfs_lock>:
    8000c040:	fe010113          	addi	sp,sp,-32
    8000c044:	00813823          	sd	s0,16(sp)
    8000c048:	00913423          	sd	s1,8(sp)
    8000c04c:	00113c23          	sd	ra,24(sp)
    8000c050:	0001b497          	auipc	s1,0x1b
    8000c054:	95048493          	addi	s1,s1,-1712 # 800269a0 <fslock>
    8000c058:	ff900413          	li	s0,-7
    8000c05c:	fff00593          	li	a1,-1
    8000c060:	00048513          	mv	a0,s1
    8000c064:	9f8fc0ef          	jal	ra,8000825c <rt_mutex_take>
    8000c068:	fe850ae3          	beq	a0,s0,8000c05c <dfs_lock+0x1c>
    8000c06c:	02050663          	beqz	a0,8000c098 <dfs_lock+0x58>
    8000c070:	01013403          	ld	s0,16(sp)
    8000c074:	01813083          	ld	ra,24(sp)
    8000c078:	00813483          	ld	s1,8(sp)
    8000c07c:	06b00613          	li	a2,107
    8000c080:	00008597          	auipc	a1,0x8
    8000c084:	88858593          	addi	a1,a1,-1912 # 80013908 <__FUNCTION__.2>
    8000c088:	00005517          	auipc	a0,0x5
    8000c08c:	de850513          	addi	a0,a0,-536 # 80010e70 <__FUNCTION__.1+0x220>
    8000c090:	02010113          	addi	sp,sp,32
    8000c094:	ae1fa06f          	j	80006b74 <rt_assert_handler>
    8000c098:	01813083          	ld	ra,24(sp)
    8000c09c:	01013403          	ld	s0,16(sp)
    8000c0a0:	00813483          	ld	s1,8(sp)
    8000c0a4:	02010113          	addi	sp,sp,32
    8000c0a8:	00008067          	ret

000000008000c0ac <dfs_unlock>:
    8000c0ac:	0001b517          	auipc	a0,0x1b
    8000c0b0:	8f450513          	addi	a0,a0,-1804 # 800269a0 <fslock>
    8000c0b4:	bd4fc06f          	j	80008488 <rt_mutex_release>

000000008000c0b8 <fd_new>:
    8000c0b8:	fd010113          	addi	sp,sp,-48
    8000c0bc:	02813023          	sd	s0,32(sp)
    8000c0c0:	02113423          	sd	ra,40(sp)
    8000c0c4:	0001b417          	auipc	s0,0x1b
    8000c0c8:	87c40413          	addi	s0,s0,-1924 # 80026940 <_fdtab>
    8000c0cc:	00913c23          	sd	s1,24(sp)
    8000c0d0:	01213823          	sd	s2,16(sp)
    8000c0d4:	01313423          	sd	s3,8(sp)
    8000c0d8:	f69ff0ef          	jal	ra,8000c040 <dfs_lock>
    8000c0dc:	00042683          	lw	a3,0(s0)
    8000c0e0:	00843503          	ld	a0,8(s0)
    8000c0e4:	00000793          	li	a5,0
    8000c0e8:	0006861b          	sext.w	a2,a3
    8000c0ec:	0007849b          	sext.w	s1,a5
    8000c0f0:	00048993          	mv	s3,s1
    8000c0f4:	02c4d063          	bge	s1,a2,8000c114 <fd_new+0x5c>
    8000c0f8:	00379713          	slli	a4,a5,0x3
    8000c0fc:	00e50733          	add	a4,a0,a4
    8000c100:	00073703          	ld	a4,0(a4)
    8000c104:	00070863          	beqz	a4,8000c114 <fd_new+0x5c>
    8000c108:	01072703          	lw	a4,16(a4)
    8000c10c:	00178793          	addi	a5,a5,1
    8000c110:	fc071ee3          	bnez	a4,8000c0ec <fd_new+0x34>
    8000c114:	04969063          	bne	a3,s1,8000c154 <fd_new+0x9c>
    8000c118:	01f00793          	li	a5,31
    8000c11c:	0697ec63          	bltu	a5,s1,8000c194 <fd_new+0xdc>
    8000c120:	0044871b          	addiw	a4,s1,4
    8000c124:	02000793          	li	a5,32
    8000c128:	00070913          	mv	s2,a4
    8000c12c:	00e7d463          	bge	a5,a4,8000c134 <fd_new+0x7c>
    8000c130:	02000913          	li	s2,32
    8000c134:	00391593          	slli	a1,s2,0x3
    8000c138:	b48f90ef          	jal	ra,80005480 <rt_realloc>
    8000c13c:	04050c63          	beqz	a0,8000c194 <fd_new+0xdc>
    8000c140:	00042783          	lw	a5,0(s0)
    8000c144:	0007871b          	sext.w	a4,a5
    8000c148:	0b274063          	blt	a4,s2,8000c1e8 <fd_new+0x130>
    8000c14c:	00a43423          	sd	a0,8(s0)
    8000c150:	01242023          	sw	s2,0(s0)
    8000c154:	00042783          	lw	a5,0(s0)
    8000c158:	02f4de63          	bge	s1,a5,8000c194 <fd_new+0xdc>
    8000c15c:	00843903          	ld	s2,8(s0)
    8000c160:	00349493          	slli	s1,s1,0x3
    8000c164:	00990933          	add	s2,s2,s1
    8000c168:	00093783          	ld	a5,0(s2)
    8000c16c:	02079463          	bnez	a5,8000c194 <fd_new+0xdc>
    8000c170:	04800593          	li	a1,72
    8000c174:	00100513          	li	a0,1
    8000c178:	8b4f90ef          	jal	ra,8000522c <rt_calloc>
    8000c17c:	00843783          	ld	a5,8(s0)
    8000c180:	00a93023          	sd	a0,0(s2)
    8000c184:	009784b3          	add	s1,a5,s1
    8000c188:	0004b783          	ld	a5,0(s1)
    8000c18c:	00079463          	bnez	a5,8000c194 <fd_new+0xdc>
    8000c190:	00042983          	lw	s3,0(s0)
    8000c194:	00042783          	lw	a5,0(s0)
    8000c198:	07379263          	bne	a5,s3,8000c1fc <fd_new+0x144>
    8000c19c:	00007517          	auipc	a0,0x7
    8000c1a0:	6dc50513          	addi	a0,a0,1756 # 80013878 <__fsym_hello_name+0xc8>
    8000c1a4:	849fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000c1a8:	00007517          	auipc	a0,0x7
    8000c1ac:	6e050513          	addi	a0,a0,1760 # 80013888 <__fsym_hello_name+0xd8>
    8000c1b0:	83dfa0ef          	jal	ra,800069ec <rt_kprintf>
    8000c1b4:	00007517          	auipc	a0,0x7
    8000c1b8:	a5c50513          	addi	a0,a0,-1444 # 80012c10 <__FUNCTION__.6+0x28>
    8000c1bc:	831fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000c1c0:	ffc00993          	li	s3,-4
    8000c1c4:	ee9ff0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000c1c8:	02813083          	ld	ra,40(sp)
    8000c1cc:	02013403          	ld	s0,32(sp)
    8000c1d0:	01813483          	ld	s1,24(sp)
    8000c1d4:	01013903          	ld	s2,16(sp)
    8000c1d8:	0039851b          	addiw	a0,s3,3
    8000c1dc:	00813983          	ld	s3,8(sp)
    8000c1e0:	03010113          	addi	sp,sp,48
    8000c1e4:	00008067          	ret
    8000c1e8:	00379713          	slli	a4,a5,0x3
    8000c1ec:	00e50733          	add	a4,a0,a4
    8000c1f0:	00073023          	sd	zero,0(a4)
    8000c1f4:	00178793          	addi	a5,a5,1
    8000c1f8:	f4dff06f          	j	8000c144 <fd_new+0x8c>
    8000c1fc:	00843783          	ld	a5,8(s0)
    8000c200:	00399713          	slli	a4,s3,0x3
    8000c204:	00e787b3          	add	a5,a5,a4
    8000c208:	0007b783          	ld	a5,0(a5)
    8000c20c:	00100713          	li	a4,1
    8000c210:	00e7a823          	sw	a4,16(a5)
    8000c214:	dfd00713          	li	a4,-515
    8000c218:	00e79023          	sh	a4,0(a5)
    8000c21c:	fa9ff06f          	j	8000c1c4 <fd_new+0x10c>

000000008000c220 <fd_get>:
    8000c220:	fe010113          	addi	sp,sp,-32
    8000c224:	00913423          	sd	s1,8(sp)
    8000c228:	00113c23          	sd	ra,24(sp)
    8000c22c:	00813823          	sd	s0,16(sp)
    8000c230:	01213023          	sd	s2,0(sp)
    8000c234:	ffd5049b          	addiw	s1,a0,-3
    8000c238:	0404c263          	bltz	s1,8000c27c <fd_get+0x5c>
    8000c23c:	0001a917          	auipc	s2,0x1a
    8000c240:	70490913          	addi	s2,s2,1796 # 80026940 <_fdtab>
    8000c244:	00092783          	lw	a5,0(s2)
    8000c248:	00000413          	li	s0,0
    8000c24c:	04f4d463          	bge	s1,a5,8000c294 <fd_get+0x74>
    8000c250:	df1ff0ef          	jal	ra,8000c040 <dfs_lock>
    8000c254:	00893503          	ld	a0,8(s2)
    8000c258:	00349493          	slli	s1,s1,0x3
    8000c25c:	009504b3          	add	s1,a0,s1
    8000c260:	0004b403          	ld	s0,0(s1)
    8000c264:	00040a63          	beqz	s0,8000c278 <fd_get+0x58>
    8000c268:	00045703          	lhu	a4,0(s0)
    8000c26c:	000107b7          	lui	a5,0x10
    8000c270:	dfd78793          	addi	a5,a5,-515 # fdfd <__STACKSIZE__+0xbdfd>
    8000c274:	00f70863          	beq	a4,a5,8000c284 <fd_get+0x64>
    8000c278:	e35ff0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000c27c:	00000413          	li	s0,0
    8000c280:	0140006f          	j	8000c294 <fd_get+0x74>
    8000c284:	01042783          	lw	a5,16(s0)
    8000c288:	0017879b          	addiw	a5,a5,1
    8000c28c:	00f42823          	sw	a5,16(s0)
    8000c290:	e1dff0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000c294:	01813083          	ld	ra,24(sp)
    8000c298:	00040513          	mv	a0,s0
    8000c29c:	01013403          	ld	s0,16(sp)
    8000c2a0:	00813483          	ld	s1,8(sp)
    8000c2a4:	00013903          	ld	s2,0(sp)
    8000c2a8:	02010113          	addi	sp,sp,32
    8000c2ac:	00008067          	ret

000000008000c2b0 <fd_put>:
    8000c2b0:	fe010113          	addi	sp,sp,-32
    8000c2b4:	00813823          	sd	s0,16(sp)
    8000c2b8:	00113c23          	sd	ra,24(sp)
    8000c2bc:	00913423          	sd	s1,8(sp)
    8000c2c0:	01213023          	sd	s2,0(sp)
    8000c2c4:	00050413          	mv	s0,a0
    8000c2c8:	00051e63          	bnez	a0,8000c2e4 <fd_put+0x34>
    8000c2cc:	0fd00613          	li	a2,253
    8000c2d0:	00009597          	auipc	a1,0x9
    8000c2d4:	b0858593          	addi	a1,a1,-1272 # 80014dd8 <__FUNCTION__.1>
    8000c2d8:	00007517          	auipc	a0,0x7
    8000c2dc:	5f050513          	addi	a0,a0,1520 # 800138c8 <__fsym_hello_name+0x118>
    8000c2e0:	895fa0ef          	jal	ra,80006b74 <rt_assert_handler>
    8000c2e4:	d5dff0ef          	jal	ra,8000c040 <dfs_lock>
    8000c2e8:	01042783          	lw	a5,16(s0)
    8000c2ec:	fff7871b          	addiw	a4,a5,-1
    8000c2f0:	00e42823          	sw	a4,16(s0)
    8000c2f4:	04071663          	bnez	a4,8000c340 <fd_put+0x90>
    8000c2f8:	0001a497          	auipc	s1,0x1a
    8000c2fc:	64848493          	addi	s1,s1,1608 # 80026940 <_fdtab>
    8000c300:	0004a683          	lw	a3,0(s1)
    8000c304:	0084b603          	ld	a2,8(s1)
    8000c308:	00000793          	li	a5,0
    8000c30c:	0007871b          	sext.w	a4,a5
    8000c310:	02d75863          	bge	a4,a3,8000c340 <fd_put+0x90>
    8000c314:	00379913          	slli	s2,a5,0x3
    8000c318:	00890713          	addi	a4,s2,8
    8000c31c:	00e60733          	add	a4,a2,a4
    8000c320:	ff873703          	ld	a4,-8(a4)
    8000c324:	00178793          	addi	a5,a5,1
    8000c328:	fe8712e3          	bne	a4,s0,8000c30c <fd_put+0x5c>
    8000c32c:	00040513          	mv	a0,s0
    8000c330:	f41f80ef          	jal	ra,80005270 <rt_free>
    8000c334:	0084b783          	ld	a5,8(s1)
    8000c338:	012787b3          	add	a5,a5,s2
    8000c33c:	0007b023          	sd	zero,0(a5)
    8000c340:	01013403          	ld	s0,16(sp)
    8000c344:	01813083          	ld	ra,24(sp)
    8000c348:	00813483          	ld	s1,8(sp)
    8000c34c:	00013903          	ld	s2,0(sp)
    8000c350:	02010113          	addi	sp,sp,32
    8000c354:	d59ff06f          	j	8000c0ac <dfs_unlock>

000000008000c358 <dfs_subdir>:
    8000c358:	fe010113          	addi	sp,sp,-32
    8000c35c:	00813823          	sd	s0,16(sp)
    8000c360:	00913423          	sd	s1,8(sp)
    8000c364:	00113c23          	sd	ra,24(sp)
    8000c368:	00058493          	mv	s1,a1
    8000c36c:	f84f70ef          	jal	ra,80003af0 <strlen>
    8000c370:	00050413          	mv	s0,a0
    8000c374:	00048513          	mv	a0,s1
    8000c378:	f78f70ef          	jal	ra,80003af0 <strlen>
    8000c37c:	02a40863          	beq	s0,a0,8000c3ac <dfs_subdir+0x54>
    8000c380:	00848533          	add	a0,s1,s0
    8000c384:	00054703          	lbu	a4,0(a0)
    8000c388:	02f00793          	li	a5,47
    8000c38c:	00f70663          	beq	a4,a5,8000c398 <dfs_subdir+0x40>
    8000c390:	00a48463          	beq	s1,a0,8000c398 <dfs_subdir+0x40>
    8000c394:	fff50513          	addi	a0,a0,-1
    8000c398:	01813083          	ld	ra,24(sp)
    8000c39c:	01013403          	ld	s0,16(sp)
    8000c3a0:	00813483          	ld	s1,8(sp)
    8000c3a4:	02010113          	addi	sp,sp,32
    8000c3a8:	00008067          	ret
    8000c3ac:	00000513          	li	a0,0
    8000c3b0:	fe9ff06f          	j	8000c398 <dfs_subdir+0x40>

000000008000c3b4 <dfs_normalize_path>:
    8000c3b4:	fd010113          	addi	sp,sp,-48
    8000c3b8:	00913c23          	sd	s1,24(sp)
    8000c3bc:	01213823          	sd	s2,16(sp)
    8000c3c0:	02113423          	sd	ra,40(sp)
    8000c3c4:	02813023          	sd	s0,32(sp)
    8000c3c8:	01313423          	sd	s3,8(sp)
    8000c3cc:	00050913          	mv	s2,a0
    8000c3d0:	00058493          	mv	s1,a1
    8000c3d4:	00059e63          	bnez	a1,8000c3f0 <dfs_normalize_path+0x3c>
    8000c3d8:	17c00613          	li	a2,380
    8000c3dc:	00007597          	auipc	a1,0x7
    8000c3e0:	51458593          	addi	a1,a1,1300 # 800138f0 <__FUNCTION__.0>
    8000c3e4:	00007517          	auipc	a0,0x7
    8000c3e8:	4f450513          	addi	a0,a0,1268 # 800138d8 <__fsym_hello_name+0x128>
    8000c3ec:	f88fa0ef          	jal	ra,80006b74 <rt_assert_handler>
    8000c3f0:	00091663          	bnez	s2,8000c3fc <dfs_normalize_path+0x48>
    8000c3f4:	00009917          	auipc	s2,0x9
    8000c3f8:	2ac90913          	addi	s2,s2,684 # 800156a0 <working_directory>
    8000c3fc:	0004c703          	lbu	a4,0(s1)
    8000c400:	02f00793          	li	a5,47
    8000c404:	0cf70c63          	beq	a4,a5,8000c4dc <dfs_normalize_path+0x128>
    8000c408:	00090513          	mv	a0,s2
    8000c40c:	ee4f70ef          	jal	ra,80003af0 <strlen>
    8000c410:	00050413          	mv	s0,a0
    8000c414:	00048513          	mv	a0,s1
    8000c418:	ed8f70ef          	jal	ra,80003af0 <strlen>
    8000c41c:	00a40533          	add	a0,s0,a0
    8000c420:	00250513          	addi	a0,a0,2
    8000c424:	b01f80ef          	jal	ra,80004f24 <rt_malloc>
    8000c428:	00050413          	mv	s0,a0
    8000c42c:	02051463          	bnez	a0,8000c454 <dfs_normalize_path+0xa0>
    8000c430:	00000413          	li	s0,0
    8000c434:	02813083          	ld	ra,40(sp)
    8000c438:	00040513          	mv	a0,s0
    8000c43c:	02013403          	ld	s0,32(sp)
    8000c440:	01813483          	ld	s1,24(sp)
    8000c444:	01013903          	ld	s2,16(sp)
    8000c448:	00813983          	ld	s3,8(sp)
    8000c44c:	03010113          	addi	sp,sp,48
    8000c450:	00008067          	ret
    8000c454:	00090513          	mv	a0,s2
    8000c458:	e98f70ef          	jal	ra,80003af0 <strlen>
    8000c45c:	00050993          	mv	s3,a0
    8000c460:	00048513          	mv	a0,s1
    8000c464:	e8cf70ef          	jal	ra,80003af0 <strlen>
    8000c468:	00a985b3          	add	a1,s3,a0
    8000c46c:	00048713          	mv	a4,s1
    8000c470:	00090693          	mv	a3,s2
    8000c474:	00006617          	auipc	a2,0x6
    8000c478:	f3460613          	addi	a2,a2,-204 # 800123a8 <__fsym___cmd_help_name+0x30>
    8000c47c:	00258593          	addi	a1,a1,2
    8000c480:	00040513          	mv	a0,s0
    8000c484:	c6cfa0ef          	jal	ra,800068f0 <rt_snprintf>
    8000c488:	00040713          	mv	a4,s0
    8000c48c:	00040793          	mv	a5,s0
    8000c490:	02e00513          	li	a0,46
    8000c494:	02f00613          	li	a2,47
    8000c498:	00074683          	lbu	a3,0(a4)
    8000c49c:	00a69863          	bne	a3,a0,8000c4ac <dfs_normalize_path+0xf8>
    8000c4a0:	00174683          	lbu	a3,1(a4)
    8000c4a4:	04069663          	bnez	a3,8000c4f0 <dfs_normalize_path+0x13c>
    8000c4a8:	00170713          	addi	a4,a4,1
    8000c4ac:	00074683          	lbu	a3,0(a4)
    8000c4b0:	00170713          	addi	a4,a4,1
    8000c4b4:	00078593          	mv	a1,a5
    8000c4b8:	0a068863          	beqz	a3,8000c568 <dfs_normalize_path+0x1b4>
    8000c4bc:	00178793          	addi	a5,a5,1
    8000c4c0:	08c69663          	bne	a3,a2,8000c54c <dfs_normalize_path+0x198>
    8000c4c4:	00c58023          	sb	a2,0(a1)
    8000c4c8:	00070693          	mv	a3,a4
    8000c4cc:	00074583          	lbu	a1,0(a4)
    8000c4d0:	00170713          	addi	a4,a4,1
    8000c4d4:	fec58ae3          	beq	a1,a2,8000c4c8 <dfs_normalize_path+0x114>
    8000c4d8:	0280006f          	j	8000c500 <dfs_normalize_path+0x14c>
    8000c4dc:	00048513          	mv	a0,s1
    8000c4e0:	ebdf90ef          	jal	ra,8000639c <rt_strdup>
    8000c4e4:	00050413          	mv	s0,a0
    8000c4e8:	fa0510e3          	bnez	a0,8000c488 <dfs_normalize_path+0xd4>
    8000c4ec:	f45ff06f          	j	8000c430 <dfs_normalize_path+0x7c>
    8000c4f0:	02c69063          	bne	a3,a2,8000c510 <dfs_normalize_path+0x15c>
    8000c4f4:	00270693          	addi	a3,a4,2
    8000c4f8:	0006c703          	lbu	a4,0(a3)
    8000c4fc:	00c70663          	beq	a4,a2,8000c508 <dfs_normalize_path+0x154>
    8000c500:	00068713          	mv	a4,a3
    8000c504:	f95ff06f          	j	8000c498 <dfs_normalize_path+0xe4>
    8000c508:	00168693          	addi	a3,a3,1
    8000c50c:	fedff06f          	j	8000c4f8 <dfs_normalize_path+0x144>
    8000c510:	f8a69ee3          	bne	a3,a0,8000c4ac <dfs_normalize_path+0xf8>
    8000c514:	00274683          	lbu	a3,2(a4)
    8000c518:	00069e63          	bnez	a3,8000c534 <dfs_normalize_path+0x180>
    8000c51c:	00270693          	addi	a3,a4,2
    8000c520:	fff78793          	addi	a5,a5,-1
    8000c524:	0287fa63          	bgeu	a5,s0,8000c558 <dfs_normalize_path+0x1a4>
    8000c528:	00040513          	mv	a0,s0
    8000c52c:	d45f80ef          	jal	ra,80005270 <rt_free>
    8000c530:	f01ff06f          	j	8000c430 <dfs_normalize_path+0x7c>
    8000c534:	f6c69ce3          	bne	a3,a2,8000c4ac <dfs_normalize_path+0xf8>
    8000c538:	00370693          	addi	a3,a4,3
    8000c53c:	0006c703          	lbu	a4,0(a3)
    8000c540:	fec710e3          	bne	a4,a2,8000c520 <dfs_normalize_path+0x16c>
    8000c544:	00168693          	addi	a3,a3,1
    8000c548:	ff5ff06f          	j	8000c53c <dfs_normalize_path+0x188>
    8000c54c:	fed78fa3          	sb	a3,-1(a5)
    8000c550:	f5dff06f          	j	8000c4ac <dfs_normalize_path+0xf8>
    8000c554:	fff78793          	addi	a5,a5,-1
    8000c558:	faf404e3          	beq	s0,a5,8000c500 <dfs_normalize_path+0x14c>
    8000c55c:	fff7c703          	lbu	a4,-1(a5)
    8000c560:	fec71ae3          	bne	a4,a2,8000c554 <dfs_normalize_path+0x1a0>
    8000c564:	f9dff06f          	j	8000c500 <dfs_normalize_path+0x14c>
    8000c568:	00078023          	sb	zero,0(a5)
    8000c56c:	fff78713          	addi	a4,a5,-1
    8000c570:	00e40a63          	beq	s0,a4,8000c584 <dfs_normalize_path+0x1d0>
    8000c574:	fff7c683          	lbu	a3,-1(a5)
    8000c578:	02f00713          	li	a4,47
    8000c57c:	00e69463          	bne	a3,a4,8000c584 <dfs_normalize_path+0x1d0>
    8000c580:	fe078fa3          	sb	zero,-1(a5)
    8000c584:	00044783          	lbu	a5,0(s0)
    8000c588:	ea0796e3          	bnez	a5,8000c434 <dfs_normalize_path+0x80>
    8000c58c:	02f00793          	li	a5,47
    8000c590:	00f40023          	sb	a5,0(s0)
    8000c594:	000400a3          	sb	zero,1(s0)
    8000c598:	e9dff06f          	j	8000c434 <dfs_normalize_path+0x80>

000000008000c59c <fd_is_open>:
    8000c59c:	fc010113          	addi	sp,sp,-64
    8000c5a0:	00050593          	mv	a1,a0
    8000c5a4:	00000513          	li	a0,0
    8000c5a8:	02113c23          	sd	ra,56(sp)
    8000c5ac:	02813823          	sd	s0,48(sp)
    8000c5b0:	02913423          	sd	s1,40(sp)
    8000c5b4:	03213023          	sd	s2,32(sp)
    8000c5b8:	01313c23          	sd	s3,24(sp)
    8000c5bc:	01413823          	sd	s4,16(sp)
    8000c5c0:	01513423          	sd	s5,8(sp)
    8000c5c4:	01613023          	sd	s6,0(sp)
    8000c5c8:	dedff0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000c5cc:	00050e63          	beqz	a0,8000c5e8 <fd_is_open+0x4c>
    8000c5d0:	00050413          	mv	s0,a0
    8000c5d4:	60c010ef          	jal	ra,8000dbe0 <dfs_filesystem_lookup>
    8000c5d8:	00050913          	mv	s2,a0
    8000c5dc:	00051a63          	bnez	a0,8000c5f0 <fd_is_open+0x54>
    8000c5e0:	00040513          	mv	a0,s0
    8000c5e4:	c8df80ef          	jal	ra,80005270 <rt_free>
    8000c5e8:	fff00493          	li	s1,-1
    8000c5ec:	0940006f          	j	8000c680 <fd_is_open+0xe4>
    8000c5f0:	00853503          	ld	a0,8(a0)
    8000c5f4:	02f00793          	li	a5,47
    8000c5f8:	00054703          	lbu	a4,0(a0)
    8000c5fc:	00f71863          	bne	a4,a5,8000c60c <fd_is_open+0x70>
    8000c600:	00154783          	lbu	a5,1(a0)
    8000c604:	00040a13          	mv	s4,s0
    8000c608:	00078663          	beqz	a5,8000c614 <fd_is_open+0x78>
    8000c60c:	ce4f70ef          	jal	ra,80003af0 <strlen>
    8000c610:	00a40a33          	add	s4,s0,a0
    8000c614:	a2dff0ef          	jal	ra,8000c040 <dfs_lock>
    8000c618:	0001a797          	auipc	a5,0x1a
    8000c61c:	32878793          	addi	a5,a5,808 # 80026940 <_fdtab>
    8000c620:	0007aa83          	lw	s5,0(a5)
    8000c624:	0087bb03          	ld	s6,8(a5)
    8000c628:	00000993          	li	s3,0
    8000c62c:	0009879b          	sext.w	a5,s3
    8000c630:	0157e663          	bltu	a5,s5,8000c63c <fd_is_open+0xa0>
    8000c634:	a79ff0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000c638:	fa9ff06f          	j	8000c5e0 <fd_is_open+0x44>
    8000c63c:	00399793          	slli	a5,s3,0x3
    8000c640:	00fb07b3          	add	a5,s6,a5
    8000c644:	0007b783          	ld	a5,0(a5)
    8000c648:	06078263          	beqz	a5,8000c6ac <fd_is_open+0x110>
    8000c64c:	0207b703          	ld	a4,32(a5)
    8000c650:	04070e63          	beqz	a4,8000c6ac <fd_is_open+0x110>
    8000c654:	0087b503          	ld	a0,8(a5)
    8000c658:	04050a63          	beqz	a0,8000c6ac <fd_is_open+0x110>
    8000c65c:	0187b783          	ld	a5,24(a5)
    8000c660:	05279663          	bne	a5,s2,8000c6ac <fd_is_open+0x110>
    8000c664:	000a0593          	mv	a1,s4
    8000c668:	cecf70ef          	jal	ra,80003b54 <strcmp>
    8000c66c:	00050493          	mv	s1,a0
    8000c670:	02051e63          	bnez	a0,8000c6ac <fd_is_open+0x110>
    8000c674:	00040513          	mv	a0,s0
    8000c678:	bf9f80ef          	jal	ra,80005270 <rt_free>
    8000c67c:	a31ff0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000c680:	03813083          	ld	ra,56(sp)
    8000c684:	03013403          	ld	s0,48(sp)
    8000c688:	02013903          	ld	s2,32(sp)
    8000c68c:	01813983          	ld	s3,24(sp)
    8000c690:	01013a03          	ld	s4,16(sp)
    8000c694:	00813a83          	ld	s5,8(sp)
    8000c698:	00013b03          	ld	s6,0(sp)
    8000c69c:	00048513          	mv	a0,s1
    8000c6a0:	02813483          	ld	s1,40(sp)
    8000c6a4:	04010113          	addi	sp,sp,64
    8000c6a8:	00008067          	ret
    8000c6ac:	00198993          	addi	s3,s3,1
    8000c6b0:	f7dff06f          	j	8000c62c <fd_is_open+0x90>

000000008000c6b4 <dfs_file_open>:
    8000c6b4:	fd010113          	addi	sp,sp,-48
    8000c6b8:	00913c23          	sd	s1,24(sp)
    8000c6bc:	02113423          	sd	ra,40(sp)
    8000c6c0:	02813023          	sd	s0,32(sp)
    8000c6c4:	01213823          	sd	s2,16(sp)
    8000c6c8:	01313423          	sd	s3,8(sp)
    8000c6cc:	fea00493          	li	s1,-22
    8000c6d0:	02050c63          	beqz	a0,8000c708 <dfs_file_open+0x54>
    8000c6d4:	00050413          	mv	s0,a0
    8000c6d8:	00000513          	li	a0,0
    8000c6dc:	00060993          	mv	s3,a2
    8000c6e0:	cd5ff0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000c6e4:	00050913          	mv	s2,a0
    8000c6e8:	ff400493          	li	s1,-12
    8000c6ec:	00050e63          	beqz	a0,8000c708 <dfs_file_open+0x54>
    8000c6f0:	4f0010ef          	jal	ra,8000dbe0 <dfs_filesystem_lookup>
    8000c6f4:	00050493          	mv	s1,a0
    8000c6f8:	02051863          	bnez	a0,8000c728 <dfs_file_open+0x74>
    8000c6fc:	00090513          	mv	a0,s2
    8000c700:	b71f80ef          	jal	ra,80005270 <rt_free>
    8000c704:	ffe00493          	li	s1,-2
    8000c708:	02813083          	ld	ra,40(sp)
    8000c70c:	02013403          	ld	s0,32(sp)
    8000c710:	01013903          	ld	s2,16(sp)
    8000c714:	00813983          	ld	s3,8(sp)
    8000c718:	00048513          	mv	a0,s1
    8000c71c:	01813483          	ld	s1,24(sp)
    8000c720:	03010113          	addi	sp,sp,48
    8000c724:	00008067          	ret
    8000c728:	01053783          	ld	a5,16(a0)
    8000c72c:	00a43c23          	sd	a0,24(s0)
    8000c730:	0107b703          	ld	a4,16(a5)
    8000c734:	0087a783          	lw	a5,8(a5)
    8000c738:	00041123          	sh	zero,2(s0)
    8000c73c:	02e43023          	sd	a4,32(s0)
    8000c740:	03342423          	sw	s3,40(s0)
    8000c744:	02043823          	sd	zero,48(s0)
    8000c748:	02043c23          	sd	zero,56(s0)
    8000c74c:	04a43023          	sd	a0,64(s0)
    8000c750:	0017f793          	andi	a5,a5,1
    8000c754:	04079e63          	bnez	a5,8000c7b0 <dfs_file_open+0xfc>
    8000c758:	00853503          	ld	a0,8(a0)
    8000c75c:	00090593          	mv	a1,s2
    8000c760:	bf9ff0ef          	jal	ra,8000c358 <dfs_subdir>
    8000c764:	02051e63          	bnez	a0,8000c7a0 <dfs_file_open+0xec>
    8000c768:	00006517          	auipc	a0,0x6
    8000c76c:	b8850513          	addi	a0,a0,-1144 # 800122f0 <CSWTCH.17+0xc8>
    8000c770:	c2df90ef          	jal	ra,8000639c <rt_strdup>
    8000c774:	00a43423          	sd	a0,8(s0)
    8000c778:	00090513          	mv	a0,s2
    8000c77c:	af5f80ef          	jal	ra,80005270 <rt_free>
    8000c780:	02043783          	ld	a5,32(s0)
    8000c784:	0007b783          	ld	a5,0(a5)
    8000c788:	02079863          	bnez	a5,8000c7b8 <dfs_file_open+0x104>
    8000c78c:	00843503          	ld	a0,8(s0)
    8000c790:	fda00493          	li	s1,-38
    8000c794:	addf80ef          	jal	ra,80005270 <rt_free>
    8000c798:	00043423          	sd	zero,8(s0)
    8000c79c:	f6dff06f          	j	8000c708 <dfs_file_open+0x54>
    8000c7a0:	0084b503          	ld	a0,8(s1)
    8000c7a4:	00090593          	mv	a1,s2
    8000c7a8:	bb1ff0ef          	jal	ra,8000c358 <dfs_subdir>
    8000c7ac:	fc5ff06f          	j	8000c770 <dfs_file_open+0xbc>
    8000c7b0:	01243423          	sd	s2,8(s0)
    8000c7b4:	fcdff06f          	j	8000c780 <dfs_file_open+0xcc>
    8000c7b8:	00040513          	mv	a0,s0
    8000c7bc:	000780e7          	jalr	a5
    8000c7c0:	00050493          	mv	s1,a0
    8000c7c4:	00055a63          	bgez	a0,8000c7d8 <dfs_file_open+0x124>
    8000c7c8:	00843503          	ld	a0,8(s0)
    8000c7cc:	aa5f80ef          	jal	ra,80005270 <rt_free>
    8000c7d0:	00043423          	sd	zero,8(s0)
    8000c7d4:	f35ff06f          	j	8000c708 <dfs_file_open+0x54>
    8000c7d8:	02842783          	lw	a5,40(s0)
    8000c7dc:	01000737          	lui	a4,0x1000
    8000c7e0:	000104b7          	lui	s1,0x10
    8000c7e4:	00e7e733          	or	a4,a5,a4
    8000c7e8:	02e42423          	sw	a4,40(s0)
    8000c7ec:	0099f4b3          	and	s1,s3,s1
    8000c7f0:	f0048ce3          	beqz	s1,8000c708 <dfs_file_open+0x54>
    8000c7f4:	00200713          	li	a4,2
    8000c7f8:	00e41123          	sh	a4,2(s0)
    8000c7fc:	03000737          	lui	a4,0x3000
    8000c800:	00e7e7b3          	or	a5,a5,a4
    8000c804:	02f42423          	sw	a5,40(s0)
    8000c808:	00000493          	li	s1,0
    8000c80c:	efdff06f          	j	8000c708 <dfs_file_open+0x54>

000000008000c810 <dfs_file_close>:
    8000c810:	fe010113          	addi	sp,sp,-32
    8000c814:	00813823          	sd	s0,16(sp)
    8000c818:	00113c23          	sd	ra,24(sp)
    8000c81c:	00913423          	sd	s1,8(sp)
    8000c820:	ffa00413          	li	s0,-6
    8000c824:	02050063          	beqz	a0,8000c844 <dfs_file_close+0x34>
    8000c828:	02053783          	ld	a5,32(a0)
    8000c82c:	00050493          	mv	s1,a0
    8000c830:	0087b783          	ld	a5,8(a5)
    8000c834:	02078463          	beqz	a5,8000c85c <dfs_file_close+0x4c>
    8000c838:	000780e7          	jalr	a5
    8000c83c:	00050413          	mv	s0,a0
    8000c840:	02055063          	bgez	a0,8000c860 <dfs_file_close+0x50>
    8000c844:	01813083          	ld	ra,24(sp)
    8000c848:	00040513          	mv	a0,s0
    8000c84c:	01013403          	ld	s0,16(sp)
    8000c850:	00813483          	ld	s1,8(sp)
    8000c854:	02010113          	addi	sp,sp,32
    8000c858:	00008067          	ret
    8000c85c:	00000413          	li	s0,0
    8000c860:	0084b503          	ld	a0,8(s1) # 10008 <__STACKSIZE__+0xc008>
    8000c864:	a0df80ef          	jal	ra,80005270 <rt_free>
    8000c868:	0004b423          	sd	zero,8(s1)
    8000c86c:	fd9ff06f          	j	8000c844 <dfs_file_close+0x34>

000000008000c870 <dfs_file_read>:
    8000c870:	04050a63          	beqz	a0,8000c8c4 <dfs_file_read+0x54>
    8000c874:	02053783          	ld	a5,32(a0)
    8000c878:	ff010113          	addi	sp,sp,-16
    8000c87c:	00813023          	sd	s0,0(sp)
    8000c880:	0187b703          	ld	a4,24(a5)
    8000c884:	00113423          	sd	ra,8(sp)
    8000c888:	00050413          	mv	s0,a0
    8000c88c:	fda00793          	li	a5,-38
    8000c890:	02070063          	beqz	a4,8000c8b0 <dfs_file_read+0x40>
    8000c894:	000700e7          	jalr	a4 # 3000000 <__STACKSIZE__+0x2ffc000>
    8000c898:	00050793          	mv	a5,a0
    8000c89c:	00055a63          	bgez	a0,8000c8b0 <dfs_file_read+0x40>
    8000c8a0:	02842703          	lw	a4,40(s0)
    8000c8a4:	040006b7          	lui	a3,0x4000
    8000c8a8:	00d76733          	or	a4,a4,a3
    8000c8ac:	02e42423          	sw	a4,40(s0)
    8000c8b0:	00813083          	ld	ra,8(sp)
    8000c8b4:	00013403          	ld	s0,0(sp)
    8000c8b8:	00078513          	mv	a0,a5
    8000c8bc:	01010113          	addi	sp,sp,16
    8000c8c0:	00008067          	ret
    8000c8c4:	fea00793          	li	a5,-22
    8000c8c8:	00078513          	mv	a0,a5
    8000c8cc:	00008067          	ret

000000008000c8d0 <cat>:
    8000c8d0:	f8010113          	addi	sp,sp,-128
    8000c8d4:	00050593          	mv	a1,a0
    8000c8d8:	00a13423          	sd	a0,8(sp)
    8000c8dc:	00000613          	li	a2,0
    8000c8e0:	0001a517          	auipc	a0,0x1a
    8000c8e4:	21050513          	addi	a0,a0,528 # 80026af0 <fd>
    8000c8e8:	06813823          	sd	s0,112(sp)
    8000c8ec:	06113c23          	sd	ra,120(sp)
    8000c8f0:	dc5ff0ef          	jal	ra,8000c6b4 <dfs_file_open>
    8000c8f4:	00813583          	ld	a1,8(sp)
    8000c8f8:	00006417          	auipc	s0,0x6
    8000c8fc:	2b040413          	addi	s0,s0,688 # 80012ba8 <__fsym___cmd_ls_name+0xb0>
    8000c900:	00055e63          	bgez	a0,8000c91c <cat+0x4c>
    8000c904:	07013403          	ld	s0,112(sp)
    8000c908:	07813083          	ld	ra,120(sp)
    8000c90c:	00007517          	auipc	a0,0x7
    8000c910:	03450513          	addi	a0,a0,52 # 80013940 <__fsym___cmd_list_fd_name+0x10>
    8000c914:	08010113          	addi	sp,sp,128
    8000c918:	8d4fa06f          	j	800069ec <rt_kprintf>
    8000c91c:	05100613          	li	a2,81
    8000c920:	00000593          	li	a1,0
    8000c924:	01810513          	addi	a0,sp,24
    8000c928:	a34f70ef          	jal	ra,80003b5c <memset>
    8000c92c:	05000613          	li	a2,80
    8000c930:	01810593          	addi	a1,sp,24
    8000c934:	0001a517          	auipc	a0,0x1a
    8000c938:	1bc50513          	addi	a0,a0,444 # 80026af0 <fd>
    8000c93c:	f35ff0ef          	jal	ra,8000c870 <dfs_file_read>
    8000c940:	00050a63          	beqz	a0,8000c954 <cat+0x84>
    8000c944:	01810593          	addi	a1,sp,24
    8000c948:	00040513          	mv	a0,s0
    8000c94c:	8a0fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000c950:	fcdff06f          	j	8000c91c <cat+0x4c>
    8000c954:	00006517          	auipc	a0,0x6
    8000c958:	2bc50513          	addi	a0,a0,700 # 80012c10 <__FUNCTION__.6+0x28>
    8000c95c:	890fa0ef          	jal	ra,800069ec <rt_kprintf>
    8000c960:	0001a517          	auipc	a0,0x1a
    8000c964:	19050513          	addi	a0,a0,400 # 80026af0 <fd>
    8000c968:	ea9ff0ef          	jal	ra,8000c810 <dfs_file_close>
    8000c96c:	07813083          	ld	ra,120(sp)
    8000c970:	07013403          	ld	s0,112(sp)
    8000c974:	08010113          	addi	sp,sp,128
    8000c978:	00008067          	ret

000000008000c97c <dfs_file_getdents>:
    8000c97c:	02050263          	beqz	a0,8000c9a0 <dfs_file_getdents+0x24>
    8000c980:	00255683          	lhu	a3,2(a0)
    8000c984:	00200713          	li	a4,2
    8000c988:	00e69c63          	bne	a3,a4,8000c9a0 <dfs_file_getdents+0x24>
    8000c98c:	02053783          	ld	a5,32(a0)
    8000c990:	0387b783          	ld	a5,56(a5)
    8000c994:	00078a63          	beqz	a5,8000c9a8 <dfs_file_getdents+0x2c>
    8000c998:	0006061b          	sext.w	a2,a2
    8000c99c:	00078067          	jr	a5
    8000c9a0:	fea00513          	li	a0,-22
    8000c9a4:	00008067          	ret
    8000c9a8:	fda00513          	li	a0,-38
    8000c9ac:	00008067          	ret

000000008000c9b0 <dfs_file_unlink>:
    8000c9b0:	fe010113          	addi	sp,sp,-32
    8000c9b4:	00050593          	mv	a1,a0
    8000c9b8:	00000513          	li	a0,0
    8000c9bc:	00813823          	sd	s0,16(sp)
    8000c9c0:	00113c23          	sd	ra,24(sp)
    8000c9c4:	00913423          	sd	s1,8(sp)
    8000c9c8:	01213023          	sd	s2,0(sp)
    8000c9cc:	9e9ff0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000c9d0:	fea00413          	li	s0,-22
    8000c9d4:	06050c63          	beqz	a0,8000ca4c <dfs_file_unlink+0x9c>
    8000c9d8:	00050913          	mv	s2,a0
    8000c9dc:	204010ef          	jal	ra,8000dbe0 <dfs_filesystem_lookup>
    8000c9e0:	00050493          	mv	s1,a0
    8000c9e4:	ffe00413          	li	s0,-2
    8000c9e8:	04050e63          	beqz	a0,8000ca44 <dfs_file_unlink+0x94>
    8000c9ec:	00090513          	mv	a0,s2
    8000c9f0:	badff0ef          	jal	ra,8000c59c <fd_is_open>
    8000c9f4:	ff000413          	li	s0,-16
    8000c9f8:	04050663          	beqz	a0,8000ca44 <dfs_file_unlink+0x94>
    8000c9fc:	0104b783          	ld	a5,16(s1)
    8000ca00:	fda00413          	li	s0,-38
    8000ca04:	0387b703          	ld	a4,56(a5)
    8000ca08:	02070e63          	beqz	a4,8000ca44 <dfs_file_unlink+0x94>
    8000ca0c:	0087a783          	lw	a5,8(a5)
    8000ca10:	00090593          	mv	a1,s2
    8000ca14:	0017f793          	andi	a5,a5,1
    8000ca18:	06079863          	bnez	a5,8000ca88 <dfs_file_unlink+0xd8>
    8000ca1c:	0084b503          	ld	a0,8(s1)
    8000ca20:	939ff0ef          	jal	ra,8000c358 <dfs_subdir>
    8000ca24:	0104b783          	ld	a5,16(s1)
    8000ca28:	04051063          	bnez	a0,8000ca68 <dfs_file_unlink+0xb8>
    8000ca2c:	0387b783          	ld	a5,56(a5)
    8000ca30:	00006597          	auipc	a1,0x6
    8000ca34:	8c058593          	addi	a1,a1,-1856 # 800122f0 <CSWTCH.17+0xc8>
    8000ca38:	00048513          	mv	a0,s1
    8000ca3c:	000780e7          	jalr	a5
    8000ca40:	00050413          	mv	s0,a0
    8000ca44:	00090513          	mv	a0,s2
    8000ca48:	829f80ef          	jal	ra,80005270 <rt_free>
    8000ca4c:	01813083          	ld	ra,24(sp)
    8000ca50:	00040513          	mv	a0,s0
    8000ca54:	01013403          	ld	s0,16(sp)
    8000ca58:	00813483          	ld	s1,8(sp)
    8000ca5c:	00013903          	ld	s2,0(sp)
    8000ca60:	02010113          	addi	sp,sp,32
    8000ca64:	00008067          	ret
    8000ca68:	0084b503          	ld	a0,8(s1)
    8000ca6c:	00090593          	mv	a1,s2
    8000ca70:	0387b403          	ld	s0,56(a5)
    8000ca74:	8e5ff0ef          	jal	ra,8000c358 <dfs_subdir>
    8000ca78:	00050593          	mv	a1,a0
    8000ca7c:	00048513          	mv	a0,s1
    8000ca80:	000400e7          	jalr	s0
    8000ca84:	fbdff06f          	j	8000ca40 <dfs_file_unlink+0x90>
    8000ca88:	00048513          	mv	a0,s1
    8000ca8c:	000700e7          	jalr	a4
    8000ca90:	fb1ff06f          	j	8000ca40 <dfs_file_unlink+0x90>

000000008000ca94 <rm>:
    8000ca94:	fe010113          	addi	sp,sp,-32
    8000ca98:	00113c23          	sd	ra,24(sp)
    8000ca9c:	00a13423          	sd	a0,8(sp)
    8000caa0:	f11ff0ef          	jal	ra,8000c9b0 <dfs_file_unlink>
    8000caa4:	00813583          	ld	a1,8(sp)
    8000caa8:	00055c63          	bgez	a0,8000cac0 <rm+0x2c>
    8000caac:	01813083          	ld	ra,24(sp)
    8000cab0:	00007517          	auipc	a0,0x7
    8000cab4:	ea050513          	addi	a0,a0,-352 # 80013950 <__fsym___cmd_list_fd_name+0x20>
    8000cab8:	02010113          	addi	sp,sp,32
    8000cabc:	f31f906f          	j	800069ec <rt_kprintf>
    8000cac0:	01813083          	ld	ra,24(sp)
    8000cac4:	02010113          	addi	sp,sp,32
    8000cac8:	00008067          	ret

000000008000cacc <dfs_file_write>:
    8000cacc:	00050a63          	beqz	a0,8000cae0 <dfs_file_write+0x14>
    8000cad0:	02053783          	ld	a5,32(a0)
    8000cad4:	0207b783          	ld	a5,32(a5)
    8000cad8:	00078863          	beqz	a5,8000cae8 <dfs_file_write+0x1c>
    8000cadc:	00078067          	jr	a5
    8000cae0:	fea00513          	li	a0,-22
    8000cae4:	00008067          	ret
    8000cae8:	fda00513          	li	a0,-38
    8000caec:	00008067          	ret

000000008000caf0 <copyfile>:
    8000caf0:	f9010113          	addi	sp,sp,-112
    8000caf4:	05213823          	sd	s2,80(sp)
    8000caf8:	00050913          	mv	s2,a0
    8000cafc:	00001537          	lui	a0,0x1
    8000cb00:	04913c23          	sd	s1,88(sp)
    8000cb04:	06113423          	sd	ra,104(sp)
    8000cb08:	06813023          	sd	s0,96(sp)
    8000cb0c:	00058493          	mv	s1,a1
    8000cb10:	c14f80ef          	jal	ra,80004f24 <rt_malloc>
    8000cb14:	02051263          	bnez	a0,8000cb38 <copyfile+0x48>
    8000cb18:	06013403          	ld	s0,96(sp)
    8000cb1c:	06813083          	ld	ra,104(sp)
    8000cb20:	05813483          	ld	s1,88(sp)
    8000cb24:	05013903          	ld	s2,80(sp)
    8000cb28:	00006517          	auipc	a0,0x6
    8000cb2c:	c0050513          	addi	a0,a0,-1024 # 80012728 <__fsym___cmd_help_name+0x3b0>
    8000cb30:	07010113          	addi	sp,sp,112
    8000cb34:	eb9f906f          	j	800069ec <rt_kprintf>
    8000cb38:	00050413          	mv	s0,a0
    8000cb3c:	00000613          	li	a2,0
    8000cb40:	00090593          	mv	a1,s2
    8000cb44:	00810513          	addi	a0,sp,8
    8000cb48:	b6dff0ef          	jal	ra,8000c6b4 <dfs_file_open>
    8000cb4c:	02055a63          	bgez	a0,8000cb80 <copyfile+0x90>
    8000cb50:	00040513          	mv	a0,s0
    8000cb54:	f1cf80ef          	jal	ra,80005270 <rt_free>
    8000cb58:	00090593          	mv	a1,s2
    8000cb5c:	00007517          	auipc	a0,0x7
    8000cb60:	e0c50513          	addi	a0,a0,-500 # 80013968 <__fsym___cmd_list_fd_name+0x38>
    8000cb64:	e89f90ef          	jal	ra,800069ec <rt_kprintf>
    8000cb68:	06813083          	ld	ra,104(sp)
    8000cb6c:	06013403          	ld	s0,96(sp)
    8000cb70:	05813483          	ld	s1,88(sp)
    8000cb74:	05013903          	ld	s2,80(sp)
    8000cb78:	07010113          	addi	sp,sp,112
    8000cb7c:	00008067          	ret
    8000cb80:	04100613          	li	a2,65
    8000cb84:	00048593          	mv	a1,s1
    8000cb88:	0001a517          	auipc	a0,0x1a
    8000cb8c:	f6850513          	addi	a0,a0,-152 # 80026af0 <fd>
    8000cb90:	b25ff0ef          	jal	ra,8000c6b4 <dfs_file_open>
    8000cb94:	0001a917          	auipc	s2,0x1a
    8000cb98:	f5c90913          	addi	s2,s2,-164 # 80026af0 <fd>
    8000cb9c:	02055263          	bgez	a0,8000cbc0 <copyfile+0xd0>
    8000cba0:	00040513          	mv	a0,s0
    8000cba4:	eccf80ef          	jal	ra,80005270 <rt_free>
    8000cba8:	00810513          	addi	a0,sp,8
    8000cbac:	c65ff0ef          	jal	ra,8000c810 <dfs_file_close>
    8000cbb0:	00048593          	mv	a1,s1
    8000cbb4:	00007517          	auipc	a0,0x7
    8000cbb8:	dc450513          	addi	a0,a0,-572 # 80013978 <__fsym___cmd_list_fd_name+0x48>
    8000cbbc:	fa9ff06f          	j	8000cb64 <copyfile+0x74>
    8000cbc0:	00001637          	lui	a2,0x1
    8000cbc4:	00040593          	mv	a1,s0
    8000cbc8:	00810513          	addi	a0,sp,8
    8000cbcc:	ca5ff0ef          	jal	ra,8000c870 <dfs_file_read>
    8000cbd0:	00050493          	mv	s1,a0
    8000cbd4:	02a05463          	blez	a0,8000cbfc <copyfile+0x10c>
    8000cbd8:	00050613          	mv	a2,a0
    8000cbdc:	00040593          	mv	a1,s0
    8000cbe0:	00090513          	mv	a0,s2
    8000cbe4:	ee9ff0ef          	jal	ra,8000cacc <dfs_file_write>
    8000cbe8:	00050593          	mv	a1,a0
    8000cbec:	fca48ae3          	beq	s1,a0,8000cbc0 <copyfile+0xd0>
    8000cbf0:	00007517          	auipc	a0,0x7
    8000cbf4:	da050513          	addi	a0,a0,-608 # 80013990 <__fsym___cmd_list_fd_name+0x60>
    8000cbf8:	df5f90ef          	jal	ra,800069ec <rt_kprintf>
    8000cbfc:	00810513          	addi	a0,sp,8
    8000cc00:	c11ff0ef          	jal	ra,8000c810 <dfs_file_close>
    8000cc04:	0001a517          	auipc	a0,0x1a
    8000cc08:	eec50513          	addi	a0,a0,-276 # 80026af0 <fd>
    8000cc0c:	c05ff0ef          	jal	ra,8000c810 <dfs_file_close>
    8000cc10:	00040513          	mv	a0,s0
    8000cc14:	e5cf80ef          	jal	ra,80005270 <rt_free>
    8000cc18:	f51ff06f          	j	8000cb68 <copyfile+0x78>

000000008000cc1c <dfs_file_lseek>:
    8000cc1c:	04050463          	beqz	a0,8000cc64 <dfs_file_lseek+0x48>
    8000cc20:	02053783          	ld	a5,32(a0)
    8000cc24:	ff010113          	addi	sp,sp,-16
    8000cc28:	00813023          	sd	s0,0(sp)
    8000cc2c:	0307b703          	ld	a4,48(a5)
    8000cc30:	00113423          	sd	ra,8(sp)
    8000cc34:	00050413          	mv	s0,a0
    8000cc38:	fda00793          	li	a5,-38
    8000cc3c:	00070a63          	beqz	a4,8000cc50 <dfs_file_lseek+0x34>
    8000cc40:	000700e7          	jalr	a4
    8000cc44:	00050793          	mv	a5,a0
    8000cc48:	00054463          	bltz	a0,8000cc50 <dfs_file_lseek+0x34>
    8000cc4c:	02a43c23          	sd	a0,56(s0)
    8000cc50:	00813083          	ld	ra,8(sp)
    8000cc54:	00013403          	ld	s0,0(sp)
    8000cc58:	00078513          	mv	a0,a5
    8000cc5c:	01010113          	addi	sp,sp,16
    8000cc60:	00008067          	ret
    8000cc64:	fea00793          	li	a5,-22
    8000cc68:	00078513          	mv	a0,a5
    8000cc6c:	00008067          	ret

000000008000cc70 <dfs_file_stat>:
    8000cc70:	fd010113          	addi	sp,sp,-48
    8000cc74:	01213823          	sd	s2,16(sp)
    8000cc78:	00058913          	mv	s2,a1
    8000cc7c:	00050593          	mv	a1,a0
    8000cc80:	00000513          	li	a0,0
    8000cc84:	00913c23          	sd	s1,24(sp)
    8000cc88:	02113423          	sd	ra,40(sp)
    8000cc8c:	02813023          	sd	s0,32(sp)
    8000cc90:	01313423          	sd	s3,8(sp)
    8000cc94:	f20ff0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000cc98:	fff00493          	li	s1,-1
    8000cc9c:	04050463          	beqz	a0,8000cce4 <dfs_file_stat+0x74>
    8000cca0:	00050413          	mv	s0,a0
    8000cca4:	73d000ef          	jal	ra,8000dbe0 <dfs_filesystem_lookup>
    8000cca8:	00050493          	mv	s1,a0
    8000ccac:	04051c63          	bnez	a0,8000cd04 <dfs_file_stat+0x94>
    8000ccb0:	00007517          	auipc	a0,0x7
    8000ccb4:	bc850513          	addi	a0,a0,-1080 # 80013878 <__fsym_hello_name+0xc8>
    8000ccb8:	d35f90ef          	jal	ra,800069ec <rt_kprintf>
    8000ccbc:	00040593          	mv	a1,s0
    8000ccc0:	00007517          	auipc	a0,0x7
    8000ccc4:	cf850513          	addi	a0,a0,-776 # 800139b8 <__fsym___cmd_list_fd_name+0x88>
    8000ccc8:	d25f90ef          	jal	ra,800069ec <rt_kprintf>
    8000cccc:	00006517          	auipc	a0,0x6
    8000ccd0:	f4450513          	addi	a0,a0,-188 # 80012c10 <__FUNCTION__.6+0x28>
    8000ccd4:	d19f90ef          	jal	ra,800069ec <rt_kprintf>
    8000ccd8:	00040513          	mv	a0,s0
    8000ccdc:	d94f80ef          	jal	ra,80005270 <rt_free>
    8000cce0:	ffe00493          	li	s1,-2
    8000cce4:	02813083          	ld	ra,40(sp)
    8000cce8:	02013403          	ld	s0,32(sp)
    8000ccec:	01013903          	ld	s2,16(sp)
    8000ccf0:	00813983          	ld	s3,8(sp)
    8000ccf4:	00048513          	mv	a0,s1
    8000ccf8:	01813483          	ld	s1,24(sp)
    8000ccfc:	03010113          	addi	sp,sp,48
    8000cd00:	00008067          	ret
    8000cd04:	00044703          	lbu	a4,0(s0)
    8000cd08:	02f00793          	li	a5,47
    8000cd0c:	02f71a63          	bne	a4,a5,8000cd40 <dfs_file_stat+0xd0>
    8000cd10:	00144783          	lbu	a5,1(s0)
    8000cd14:	02079663          	bnez	a5,8000cd40 <dfs_file_stat+0xd0>
    8000cd18:	000047b7          	lui	a5,0x4
    8000cd1c:	1ff78793          	addi	a5,a5,511 # 41ff <__STACKSIZE__+0x1ff>
    8000cd20:	00093023          	sd	zero,0(s2)
    8000cd24:	00f92823          	sw	a5,16(s2)
    8000cd28:	02093823          	sd	zero,48(s2)
    8000cd2c:	04093c23          	sd	zero,88(s2)
    8000cd30:	00040513          	mv	a0,s0
    8000cd34:	d3cf80ef          	jal	ra,80005270 <rt_free>
    8000cd38:	00000493          	li	s1,0
    8000cd3c:	fa9ff06f          	j	8000cce4 <dfs_file_stat+0x74>
    8000cd40:	0084b503          	ld	a0,8(s1)
    8000cd44:	00040593          	mv	a1,s0
    8000cd48:	e10ff0ef          	jal	ra,8000c358 <dfs_subdir>
    8000cd4c:	fc0506e3          	beqz	a0,8000cd18 <dfs_file_stat+0xa8>
    8000cd50:	0104b783          	ld	a5,16(s1)
    8000cd54:	0407b983          	ld	s3,64(a5)
    8000cd58:	02099c63          	bnez	s3,8000cd90 <dfs_file_stat+0x120>
    8000cd5c:	00040513          	mv	a0,s0
    8000cd60:	d10f80ef          	jal	ra,80005270 <rt_free>
    8000cd64:	00007517          	auipc	a0,0x7
    8000cd68:	b1450513          	addi	a0,a0,-1260 # 80013878 <__fsym_hello_name+0xc8>
    8000cd6c:	c81f90ef          	jal	ra,800069ec <rt_kprintf>
    8000cd70:	00007517          	auipc	a0,0x7
    8000cd74:	c7850513          	addi	a0,a0,-904 # 800139e8 <__fsym___cmd_list_fd_name+0xb8>
    8000cd78:	c75f90ef          	jal	ra,800069ec <rt_kprintf>
    8000cd7c:	00006517          	auipc	a0,0x6
    8000cd80:	e9450513          	addi	a0,a0,-364 # 80012c10 <__FUNCTION__.6+0x28>
    8000cd84:	c69f90ef          	jal	ra,800069ec <rt_kprintf>
    8000cd88:	fda00493          	li	s1,-38
    8000cd8c:	f59ff06f          	j	8000cce4 <dfs_file_stat+0x74>
    8000cd90:	0087a783          	lw	a5,8(a5)
    8000cd94:	0017f793          	andi	a5,a5,1
    8000cd98:	02078263          	beqz	a5,8000cdbc <dfs_file_stat+0x14c>
    8000cd9c:	00090613          	mv	a2,s2
    8000cda0:	00040593          	mv	a1,s0
    8000cda4:	00048513          	mv	a0,s1
    8000cda8:	000980e7          	jalr	s3
    8000cdac:	00050493          	mv	s1,a0
    8000cdb0:	00040513          	mv	a0,s0
    8000cdb4:	cbcf80ef          	jal	ra,80005270 <rt_free>
    8000cdb8:	f2dff06f          	j	8000cce4 <dfs_file_stat+0x74>
    8000cdbc:	0084b503          	ld	a0,8(s1)
    8000cdc0:	00040593          	mv	a1,s0
    8000cdc4:	d94ff0ef          	jal	ra,8000c358 <dfs_subdir>
    8000cdc8:	00050593          	mv	a1,a0
    8000cdcc:	00090613          	mv	a2,s2
    8000cdd0:	fd5ff06f          	j	8000cda4 <dfs_file_stat+0x134>

000000008000cdd4 <ls>:
    8000cdd4:	f2010113          	addi	sp,sp,-224
    8000cdd8:	0c813823          	sd	s0,208(sp)
    8000cddc:	0c913423          	sd	s1,200(sp)
    8000cde0:	0c113c23          	sd	ra,216(sp)
    8000cde4:	0d213023          	sd	s2,192(sp)
    8000cde8:	0b313c23          	sd	s3,184(sp)
    8000cdec:	0b413823          	sd	s4,176(sp)
    8000cdf0:	0b513423          	sd	s5,168(sp)
    8000cdf4:	0b613023          	sd	s6,160(sp)
    8000cdf8:	09713c23          	sd	s7,152(sp)
    8000cdfc:	09813823          	sd	s8,144(sp)
    8000ce00:	09913423          	sd	s9,136(sp)
    8000ce04:	00050493          	mv	s1,a0
    8000ce08:	00050413          	mv	s0,a0
    8000ce0c:	00051c63          	bnez	a0,8000ce24 <ls+0x50>
    8000ce10:	00009517          	auipc	a0,0x9
    8000ce14:	89050513          	addi	a0,a0,-1904 # 800156a0 <working_directory>
    8000ce18:	d84f90ef          	jal	ra,8000639c <rt_strdup>
    8000ce1c:	00050413          	mv	s0,a0
    8000ce20:	10050e63          	beqz	a0,8000cf3c <ls+0x168>
    8000ce24:	00010637          	lui	a2,0x10
    8000ce28:	00040593          	mv	a1,s0
    8000ce2c:	0001a517          	auipc	a0,0x1a
    8000ce30:	cc450513          	addi	a0,a0,-828 # 80026af0 <fd>
    8000ce34:	881ff0ef          	jal	ra,8000c6b4 <dfs_file_open>
    8000ce38:	12051c63          	bnez	a0,8000cf70 <ls+0x19c>
    8000ce3c:	00040593          	mv	a1,s0
    8000ce40:	00007517          	auipc	a0,0x7
    8000ce44:	bd850513          	addi	a0,a0,-1064 # 80013a18 <__fsym___cmd_list_fd_name+0xe8>
    8000ce48:	ba5f90ef          	jal	ra,800069ec <rt_kprintf>
    8000ce4c:	0001aa17          	auipc	s4,0x1a
    8000ce50:	b9ca0a13          	addi	s4,s4,-1124 # 800269e8 <dirent>
    8000ce54:	0001aa97          	auipc	s5,0x1a
    8000ce58:	c9ca8a93          	addi	s5,s5,-868 # 80026af0 <fd>
    8000ce5c:	0001a997          	auipc	s3,0x1a
    8000ce60:	b9098993          	addi	s3,s3,-1136 # 800269ec <dirent+0x4>
    8000ce64:	00007b17          	auipc	s6,0x7
    8000ce68:	be4b0b13          	addi	s6,s6,-1052 # 80013a48 <__fsym___cmd_list_fd_name+0x118>
    8000ce6c:	00007b97          	auipc	s7,0x7
    8000ce70:	bbcb8b93          	addi	s7,s7,-1092 # 80013a28 <__fsym___cmd_list_fd_name+0xf8>
    8000ce74:	0000fc37          	lui	s8,0xf
    8000ce78:	00004cb7          	lui	s9,0x4
    8000ce7c:	10400613          	li	a2,260
    8000ce80:	00000593          	li	a1,0
    8000ce84:	000a0513          	mv	a0,s4
    8000ce88:	cd5f60ef          	jal	ra,80003b5c <memset>
    8000ce8c:	10400613          	li	a2,260
    8000ce90:	000a0593          	mv	a1,s4
    8000ce94:	000a8513          	mv	a0,s5
    8000ce98:	ae5ff0ef          	jal	ra,8000c97c <dfs_file_getdents>
    8000ce9c:	08a05463          	blez	a0,8000cf24 <ls+0x150>
    8000cea0:	08000613          	li	a2,128
    8000cea4:	00000593          	li	a1,0
    8000cea8:	00010513          	mv	a0,sp
    8000ceac:	cb1f60ef          	jal	ra,80003b5c <memset>
    8000ceb0:	00098593          	mv	a1,s3
    8000ceb4:	00040513          	mv	a0,s0
    8000ceb8:	cfcff0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000cebc:	00050913          	mv	s2,a0
    8000cec0:	06050263          	beqz	a0,8000cf24 <ls+0x150>
    8000cec4:	00010593          	mv	a1,sp
    8000cec8:	da9ff0ef          	jal	ra,8000cc70 <dfs_file_stat>
    8000cecc:	00098593          	mv	a1,s3
    8000ced0:	04051663          	bnez	a0,8000cf1c <ls+0x148>
    8000ced4:	000b8513          	mv	a0,s7
    8000ced8:	b15f90ef          	jal	ra,800069ec <rt_kprintf>
    8000cedc:	01012783          	lw	a5,16(sp)
    8000cee0:	0187f7b3          	and	a5,a5,s8
    8000cee4:	0007879b          	sext.w	a5,a5
    8000cee8:	03979263          	bne	a5,s9,8000cf0c <ls+0x138>
    8000ceec:	00007597          	auipc	a1,0x7
    8000cef0:	b4458593          	addi	a1,a1,-1212 # 80013a30 <__fsym___cmd_list_fd_name+0x100>
    8000cef4:	00007517          	auipc	a0,0x7
    8000cef8:	b4450513          	addi	a0,a0,-1212 # 80013a38 <__fsym___cmd_list_fd_name+0x108>
    8000cefc:	af1f90ef          	jal	ra,800069ec <rt_kprintf>
    8000cf00:	00090513          	mv	a0,s2
    8000cf04:	b6cf80ef          	jal	ra,80005270 <rt_free>
    8000cf08:	f75ff06f          	j	8000ce7c <ls+0xa8>
    8000cf0c:	03013583          	ld	a1,48(sp)
    8000cf10:	00007517          	auipc	a0,0x7
    8000cf14:	b3050513          	addi	a0,a0,-1232 # 80013a40 <__fsym___cmd_list_fd_name+0x110>
    8000cf18:	fe5ff06f          	j	8000cefc <ls+0x128>
    8000cf1c:	000b0513          	mv	a0,s6
    8000cf20:	fddff06f          	j	8000cefc <ls+0x128>
    8000cf24:	0001a517          	auipc	a0,0x1a
    8000cf28:	bcc50513          	addi	a0,a0,-1076 # 80026af0 <fd>
    8000cf2c:	8e5ff0ef          	jal	ra,8000c810 <dfs_file_close>
    8000cf30:	00049663          	bnez	s1,8000cf3c <ls+0x168>
    8000cf34:	00040513          	mv	a0,s0
    8000cf38:	b38f80ef          	jal	ra,80005270 <rt_free>
    8000cf3c:	0d813083          	ld	ra,216(sp)
    8000cf40:	0d013403          	ld	s0,208(sp)
    8000cf44:	0c813483          	ld	s1,200(sp)
    8000cf48:	0c013903          	ld	s2,192(sp)
    8000cf4c:	0b813983          	ld	s3,184(sp)
    8000cf50:	0b013a03          	ld	s4,176(sp)
    8000cf54:	0a813a83          	ld	s5,168(sp)
    8000cf58:	0a013b03          	ld	s6,160(sp)
    8000cf5c:	09813b83          	ld	s7,152(sp)
    8000cf60:	09013c03          	ld	s8,144(sp)
    8000cf64:	08813c83          	ld	s9,136(sp)
    8000cf68:	0e010113          	addi	sp,sp,224
    8000cf6c:	00008067          	ret
    8000cf70:	00007517          	auipc	a0,0x7
    8000cf74:	ae850513          	addi	a0,a0,-1304 # 80013a58 <__fsym___cmd_list_fd_name+0x128>
    8000cf78:	a75f90ef          	jal	ra,800069ec <rt_kprintf>
    8000cf7c:	fb5ff06f          	j	8000cf30 <ls+0x15c>

000000008000cf80 <copydir>:
    8000cf80:	de010113          	addi	sp,sp,-544
    8000cf84:	21213023          	sd	s2,512(sp)
    8000cf88:	1f313c23          	sd	s3,504(sp)
    8000cf8c:	00050913          	mv	s2,a0
    8000cf90:	00058993          	mv	s3,a1
    8000cf94:	00010637          	lui	a2,0x10
    8000cf98:	00050593          	mv	a1,a0
    8000cf9c:	00010513          	mv	a0,sp
    8000cfa0:	20113c23          	sd	ra,536(sp)
    8000cfa4:	20813823          	sd	s0,528(sp)
    8000cfa8:	20913423          	sd	s1,520(sp)
    8000cfac:	1f413823          	sd	s4,496(sp)
    8000cfb0:	1f513423          	sd	s5,488(sp)
    8000cfb4:	1f613023          	sd	s6,480(sp)
    8000cfb8:	1d713c23          	sd	s7,472(sp)
    8000cfbc:	1d813823          	sd	s8,464(sp)
    8000cfc0:	ef4ff0ef          	jal	ra,8000c6b4 <dfs_file_open>
    8000cfc4:	08054a63          	bltz	a0,8000d058 <copydir+0xd8>
    8000cfc8:	00005a17          	auipc	s4,0x5
    8000cfcc:	3d8a0a13          	addi	s4,s4,984 # 800123a0 <__fsym___cmd_help_name+0x28>
    8000cfd0:	00007a97          	auipc	s5,0x7
    8000cfd4:	c78a8a93          	addi	s5,s5,-904 # 80013c48 <__fsym_mkdir_name+0x90>
    8000cfd8:	0000fb37          	lui	s6,0xf
    8000cfdc:	00004bb7          	lui	s7,0x4
    8000cfe0:	00007c17          	auipc	s8,0x7
    8000cfe4:	ab0c0c13          	addi	s8,s8,-1360 # 80013a90 <__fsym___cmd_list_fd_name+0x160>
    8000cfe8:	10400613          	li	a2,260
    8000cfec:	00000593          	li	a1,0
    8000cff0:	0c810513          	addi	a0,sp,200
    8000cff4:	b69f60ef          	jal	ra,80003b5c <memset>
    8000cff8:	10400613          	li	a2,260
    8000cffc:	0c810593          	addi	a1,sp,200
    8000d000:	00010513          	mv	a0,sp
    8000d004:	979ff0ef          	jal	ra,8000c97c <dfs_file_getdents>
    8000d008:	04a05263          	blez	a0,8000d04c <copydir+0xcc>
    8000d00c:	000a0593          	mv	a1,s4
    8000d010:	0cc10513          	addi	a0,sp,204
    8000d014:	b41f60ef          	jal	ra,80003b54 <strcmp>
    8000d018:	fc0508e3          	beqz	a0,8000cfe8 <copydir+0x68>
    8000d01c:	000a8593          	mv	a1,s5
    8000d020:	0cc10513          	addi	a0,sp,204
    8000d024:	b31f60ef          	jal	ra,80003b54 <strcmp>
    8000d028:	fc0500e3          	beqz	a0,8000cfe8 <copydir+0x68>
    8000d02c:	0cc10593          	addi	a1,sp,204
    8000d030:	00090513          	mv	a0,s2
    8000d034:	b80ff0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000d038:	00050413          	mv	s0,a0
    8000d03c:	04051e63          	bnez	a0,8000d098 <copydir+0x118>
    8000d040:	00007517          	auipc	a0,0x7
    8000d044:	a4050513          	addi	a0,a0,-1472 # 80013a80 <__fsym___cmd_list_fd_name+0x150>
    8000d048:	9a5f90ef          	jal	ra,800069ec <rt_kprintf>
    8000d04c:	00010513          	mv	a0,sp
    8000d050:	fc0ff0ef          	jal	ra,8000c810 <dfs_file_close>
    8000d054:	0140006f          	j	8000d068 <copydir+0xe8>
    8000d058:	00090593          	mv	a1,s2
    8000d05c:	00007517          	auipc	a0,0x7
    8000d060:	a1450513          	addi	a0,a0,-1516 # 80013a70 <__fsym___cmd_list_fd_name+0x140>
    8000d064:	989f90ef          	jal	ra,800069ec <rt_kprintf>
    8000d068:	21813083          	ld	ra,536(sp)
    8000d06c:	21013403          	ld	s0,528(sp)
    8000d070:	20813483          	ld	s1,520(sp)
    8000d074:	20013903          	ld	s2,512(sp)
    8000d078:	1f813983          	ld	s3,504(sp)
    8000d07c:	1f013a03          	ld	s4,496(sp)
    8000d080:	1e813a83          	ld	s5,488(sp)
    8000d084:	1e013b03          	ld	s6,480(sp)
    8000d088:	1d813b83          	ld	s7,472(sp)
    8000d08c:	1d013c03          	ld	s8,464(sp)
    8000d090:	22010113          	addi	sp,sp,544
    8000d094:	00008067          	ret
    8000d098:	0cc10593          	addi	a1,sp,204
    8000d09c:	00098513          	mv	a0,s3
    8000d0a0:	b14ff0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000d0a4:	00050493          	mv	s1,a0
    8000d0a8:	00051e63          	bnez	a0,8000d0c4 <copydir+0x144>
    8000d0ac:	00007517          	auipc	a0,0x7
    8000d0b0:	9d450513          	addi	a0,a0,-1580 # 80013a80 <__fsym___cmd_list_fd_name+0x150>
    8000d0b4:	939f90ef          	jal	ra,800069ec <rt_kprintf>
    8000d0b8:	00040513          	mv	a0,s0
    8000d0bc:	9b4f80ef          	jal	ra,80005270 <rt_free>
    8000d0c0:	f8dff06f          	j	8000d04c <copydir+0xcc>
    8000d0c4:	00000593          	li	a1,0
    8000d0c8:	08000613          	li	a2,128
    8000d0cc:	04810513          	addi	a0,sp,72
    8000d0d0:	a8df60ef          	jal	ra,80003b5c <memset>
    8000d0d4:	04810593          	addi	a1,sp,72
    8000d0d8:	00040513          	mv	a0,s0
    8000d0dc:	b95ff0ef          	jal	ra,8000cc70 <dfs_file_stat>
    8000d0e0:	00050a63          	beqz	a0,8000d0f4 <copydir+0x174>
    8000d0e4:	0cc10593          	addi	a1,sp,204
    8000d0e8:	000c0513          	mv	a0,s8
    8000d0ec:	901f90ef          	jal	ra,800069ec <rt_kprintf>
    8000d0f0:	ef9ff06f          	j	8000cfe8 <copydir+0x68>
    8000d0f4:	05812783          	lw	a5,88(sp)
    8000d0f8:	0167f7b3          	and	a5,a5,s6
    8000d0fc:	0007879b          	sext.w	a5,a5
    8000d100:	03779863          	bne	a5,s7,8000d130 <copydir+0x1b0>
    8000d104:	00000593          	li	a1,0
    8000d108:	00048513          	mv	a0,s1
    8000d10c:	2bc000ef          	jal	ra,8000d3c8 <mkdir>
    8000d110:	00048593          	mv	a1,s1
    8000d114:	00040513          	mv	a0,s0
    8000d118:	e69ff0ef          	jal	ra,8000cf80 <copydir>
    8000d11c:	00040513          	mv	a0,s0
    8000d120:	950f80ef          	jal	ra,80005270 <rt_free>
    8000d124:	00048513          	mv	a0,s1
    8000d128:	948f80ef          	jal	ra,80005270 <rt_free>
    8000d12c:	ebdff06f          	j	8000cfe8 <copydir+0x68>
    8000d130:	00048593          	mv	a1,s1
    8000d134:	00040513          	mv	a0,s0
    8000d138:	9b9ff0ef          	jal	ra,8000caf0 <copyfile>
    8000d13c:	fe1ff06f          	j	8000d11c <copydir+0x19c>

000000008000d140 <copy>:
    8000d140:	f6010113          	addi	sp,sp,-160
    8000d144:	09213023          	sd	s2,128(sp)
    8000d148:	00058913          	mv	s2,a1
    8000d14c:	00010593          	mv	a1,sp
    8000d150:	08813823          	sd	s0,144(sp)
    8000d154:	08113c23          	sd	ra,152(sp)
    8000d158:	08913423          	sd	s1,136(sp)
    8000d15c:	00050413          	mv	s0,a0
    8000d160:	b11ff0ef          	jal	ra,8000cc70 <dfs_file_stat>
    8000d164:	02055663          	bgez	a0,8000d190 <copy+0x50>
    8000d168:	00040593          	mv	a1,s0
    8000d16c:	00007517          	auipc	a0,0x7
    8000d170:	93c50513          	addi	a0,a0,-1732 # 80013aa8 <__fsym___cmd_list_fd_name+0x178>
    8000d174:	879f90ef          	jal	ra,800069ec <rt_kprintf>
    8000d178:	09813083          	ld	ra,152(sp)
    8000d17c:	09013403          	ld	s0,144(sp)
    8000d180:	08813483          	ld	s1,136(sp)
    8000d184:	08013903          	ld	s2,128(sp)
    8000d188:	0a010113          	addi	sp,sp,160
    8000d18c:	00008067          	ret
    8000d190:	01012783          	lw	a5,16(sp)
    8000d194:	0000f737          	lui	a4,0xf
    8000d198:	00100493          	li	s1,1
    8000d19c:	00e7f7b3          	and	a5,a5,a4
    8000d1a0:	00004737          	lui	a4,0x4
    8000d1a4:	00e78463          	beq	a5,a4,8000d1ac <copy+0x6c>
    8000d1a8:	00200493          	li	s1,2
    8000d1ac:	00010593          	mv	a1,sp
    8000d1b0:	00090513          	mv	a0,s2
    8000d1b4:	abdff0ef          	jal	ra,8000cc70 <dfs_file_stat>
    8000d1b8:	00054e63          	bltz	a0,8000d1d4 <copy+0x94>
    8000d1bc:	01012783          	lw	a5,16(sp)
    8000d1c0:	0000f737          	lui	a4,0xf
    8000d1c4:	00e7f7b3          	and	a5,a5,a4
    8000d1c8:	00004737          	lui	a4,0x4
    8000d1cc:	06e79463          	bne	a5,a4,8000d234 <copy+0xf4>
    8000d1d0:	0044e493          	ori	s1,s1,4
    8000d1d4:	0094f713          	andi	a4,s1,9
    8000d1d8:	00900693          	li	a3,9
    8000d1dc:	00048793          	mv	a5,s1
    8000d1e0:	00007517          	auipc	a0,0x7
    8000d1e4:	8e050513          	addi	a0,a0,-1824 # 80013ac0 <__fsym___cmd_list_fd_name+0x190>
    8000d1e8:	04d70263          	beq	a4,a3,8000d22c <copy+0xec>
    8000d1ec:	0044f713          	andi	a4,s1,4
    8000d1f0:	0024f493          	andi	s1,s1,2
    8000d1f4:	06048863          	beqz	s1,8000d264 <copy+0x124>
    8000d1f8:	04070e63          	beqz	a4,8000d254 <copy+0x114>
    8000d1fc:	02f00593          	li	a1,47
    8000d200:	00040513          	mv	a0,s0
    8000d204:	969f60ef          	jal	ra,80003b6c <strrchr>
    8000d208:	00040593          	mv	a1,s0
    8000d20c:	00050463          	beqz	a0,8000d214 <copy+0xd4>
    8000d210:	00150593          	addi	a1,a0,1
    8000d214:	00090513          	mv	a0,s2
    8000d218:	99cff0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000d21c:	00050493          	mv	s1,a0
    8000d220:	00051e63          	bnez	a0,8000d23c <copy+0xfc>
    8000d224:	00005517          	auipc	a0,0x5
    8000d228:	50450513          	addi	a0,a0,1284 # 80012728 <__fsym___cmd_help_name+0x3b0>
    8000d22c:	fc0f90ef          	jal	ra,800069ec <rt_kprintf>
    8000d230:	f49ff06f          	j	8000d178 <copy+0x38>
    8000d234:	0084e493          	ori	s1,s1,8
    8000d238:	f9dff06f          	j	8000d1d4 <copy+0x94>
    8000d23c:	00050593          	mv	a1,a0
    8000d240:	00040513          	mv	a0,s0
    8000d244:	8adff0ef          	jal	ra,8000caf0 <copyfile>
    8000d248:	00048513          	mv	a0,s1
    8000d24c:	824f80ef          	jal	ra,80005270 <rt_free>
    8000d250:	f29ff06f          	j	8000d178 <copy+0x38>
    8000d254:	00090593          	mv	a1,s2
    8000d258:	00040513          	mv	a0,s0
    8000d25c:	895ff0ef          	jal	ra,8000caf0 <copyfile>
    8000d260:	f19ff06f          	j	8000d178 <copy+0x38>
    8000d264:	04070263          	beqz	a4,8000d2a8 <copy+0x168>
    8000d268:	02f00593          	li	a1,47
    8000d26c:	00040513          	mv	a0,s0
    8000d270:	8fdf60ef          	jal	ra,80003b6c <strrchr>
    8000d274:	00040593          	mv	a1,s0
    8000d278:	00050463          	beqz	a0,8000d280 <copy+0x140>
    8000d27c:	00150593          	addi	a1,a0,1
    8000d280:	00090513          	mv	a0,s2
    8000d284:	930ff0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000d288:	00050493          	mv	s1,a0
    8000d28c:	f8050ce3          	beqz	a0,8000d224 <copy+0xe4>
    8000d290:	00000593          	li	a1,0
    8000d294:	134000ef          	jal	ra,8000d3c8 <mkdir>
    8000d298:	00048593          	mv	a1,s1
    8000d29c:	00040513          	mv	a0,s0
    8000d2a0:	ce1ff0ef          	jal	ra,8000cf80 <copydir>
    8000d2a4:	fa5ff06f          	j	8000d248 <copy+0x108>
    8000d2a8:	00c7f793          	andi	a5,a5,12
    8000d2ac:	00079863          	bnez	a5,8000d2bc <copy+0x17c>
    8000d2b0:	00000593          	li	a1,0
    8000d2b4:	00090513          	mv	a0,s2
    8000d2b8:	110000ef          	jal	ra,8000d3c8 <mkdir>
    8000d2bc:	00090593          	mv	a1,s2
    8000d2c0:	00040513          	mv	a0,s0
    8000d2c4:	cbdff0ef          	jal	ra,8000cf80 <copydir>
    8000d2c8:	eb1ff06f          	j	8000d178 <copy+0x38>

000000008000d2cc <dfs_file_rename>:
    8000d2cc:	fd010113          	addi	sp,sp,-48
    8000d2d0:	02813023          	sd	s0,32(sp)
    8000d2d4:	00058413          	mv	s0,a1
    8000d2d8:	00050593          	mv	a1,a0
    8000d2dc:	00000513          	li	a0,0
    8000d2e0:	01213823          	sd	s2,16(sp)
    8000d2e4:	02113423          	sd	ra,40(sp)
    8000d2e8:	00913c23          	sd	s1,24(sp)
    8000d2ec:	01313423          	sd	s3,8(sp)
    8000d2f0:	01413023          	sd	s4,0(sp)
    8000d2f4:	8c0ff0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000d2f8:	00050913          	mv	s2,a0
    8000d2fc:	04051063          	bnez	a0,8000d33c <dfs_file_rename+0x70>
    8000d300:	00000493          	li	s1,0
    8000d304:	ffe00413          	li	s0,-2
    8000d308:	00090513          	mv	a0,s2
    8000d30c:	f65f70ef          	jal	ra,80005270 <rt_free>
    8000d310:	00048513          	mv	a0,s1
    8000d314:	f5df70ef          	jal	ra,80005270 <rt_free>
    8000d318:	02813083          	ld	ra,40(sp)
    8000d31c:	00040513          	mv	a0,s0
    8000d320:	02013403          	ld	s0,32(sp)
    8000d324:	01813483          	ld	s1,24(sp)
    8000d328:	01013903          	ld	s2,16(sp)
    8000d32c:	00813983          	ld	s3,8(sp)
    8000d330:	00013a03          	ld	s4,0(sp)
    8000d334:	03010113          	addi	sp,sp,48
    8000d338:	00008067          	ret
    8000d33c:	00040593          	mv	a1,s0
    8000d340:	00000513          	li	a0,0
    8000d344:	870ff0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000d348:	00050493          	mv	s1,a0
    8000d34c:	fa050ae3          	beqz	a0,8000d300 <dfs_file_rename+0x34>
    8000d350:	00090513          	mv	a0,s2
    8000d354:	08d000ef          	jal	ra,8000dbe0 <dfs_filesystem_lookup>
    8000d358:	00050993          	mv	s3,a0
    8000d35c:	00048513          	mv	a0,s1
    8000d360:	081000ef          	jal	ra,8000dbe0 <dfs_filesystem_lookup>
    8000d364:	fee00413          	li	s0,-18
    8000d368:	faa990e3          	bne	s3,a0,8000d308 <dfs_file_rename+0x3c>
    8000d36c:	0109b783          	ld	a5,16(s3)
    8000d370:	fda00413          	li	s0,-38
    8000d374:	0487ba03          	ld	s4,72(a5)
    8000d378:	f80a08e3          	beqz	s4,8000d308 <dfs_file_rename+0x3c>
    8000d37c:	0087a783          	lw	a5,8(a5)
    8000d380:	0017f793          	andi	a5,a5,1
    8000d384:	00078c63          	beqz	a5,8000d39c <dfs_file_rename+0xd0>
    8000d388:	00048613          	mv	a2,s1
    8000d38c:	00090593          	mv	a1,s2
    8000d390:	000a00e7          	jalr	s4
    8000d394:	00050413          	mv	s0,a0
    8000d398:	f71ff06f          	j	8000d308 <dfs_file_rename+0x3c>
    8000d39c:	0089b503          	ld	a0,8(s3)
    8000d3a0:	00090593          	mv	a1,s2
    8000d3a4:	fb5fe0ef          	jal	ra,8000c358 <dfs_subdir>
    8000d3a8:	00050413          	mv	s0,a0
    8000d3ac:	0089b503          	ld	a0,8(s3)
    8000d3b0:	00048593          	mv	a1,s1
    8000d3b4:	fa5fe0ef          	jal	ra,8000c358 <dfs_subdir>
    8000d3b8:	00050613          	mv	a2,a0
    8000d3bc:	00040593          	mv	a1,s0
    8000d3c0:	00098513          	mv	a0,s3
    8000d3c4:	fcdff06f          	j	8000d390 <dfs_file_rename+0xc4>

000000008000d3c8 <mkdir>:
    8000d3c8:	fe010113          	addi	sp,sp,-32
    8000d3cc:	00913423          	sd	s1,8(sp)
    8000d3d0:	00113c23          	sd	ra,24(sp)
    8000d3d4:	00813823          	sd	s0,16(sp)
    8000d3d8:	00050493          	mv	s1,a0
    8000d3dc:	cddfe0ef          	jal	ra,8000c0b8 <fd_new>
    8000d3e0:	fff00793          	li	a5,-1
    8000d3e4:	02f51463          	bne	a0,a5,8000d40c <mkdir+0x44>
    8000d3e8:	00050413          	mv	s0,a0
    8000d3ec:	ff400513          	li	a0,-12
    8000d3f0:	be1f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d3f4:	01813083          	ld	ra,24(sp)
    8000d3f8:	00040513          	mv	a0,s0
    8000d3fc:	01013403          	ld	s0,16(sp)
    8000d400:	00813483          	ld	s1,8(sp)
    8000d404:	02010113          	addi	sp,sp,32
    8000d408:	00008067          	ret
    8000d40c:	e15fe0ef          	jal	ra,8000c220 <fd_get>
    8000d410:	00010637          	lui	a2,0x10
    8000d414:	00048593          	mv	a1,s1
    8000d418:	04060613          	addi	a2,a2,64 # 10040 <__STACKSIZE__+0xc040>
    8000d41c:	00050413          	mv	s0,a0
    8000d420:	a94ff0ef          	jal	ra,8000c6b4 <dfs_file_open>
    8000d424:	00050493          	mv	s1,a0
    8000d428:	00040513          	mv	a0,s0
    8000d42c:	0204d063          	bgez	s1,8000d44c <mkdir+0x84>
    8000d430:	e81fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d434:	00040513          	mv	a0,s0
    8000d438:	e79fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d43c:	00048513          	mv	a0,s1
    8000d440:	b91f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d444:	fff00413          	li	s0,-1
    8000d448:	fadff06f          	j	8000d3f4 <mkdir+0x2c>
    8000d44c:	bc4ff0ef          	jal	ra,8000c810 <dfs_file_close>
    8000d450:	00040513          	mv	a0,s0
    8000d454:	e5dfe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d458:	00040513          	mv	a0,s0
    8000d45c:	e55fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d460:	00000413          	li	s0,0
    8000d464:	f91ff06f          	j	8000d3f4 <mkdir+0x2c>

000000008000d468 <open>:
    8000d468:	fa010113          	addi	sp,sp,-96
    8000d46c:	01213823          	sd	s2,16(sp)
    8000d470:	01313423          	sd	s3,8(sp)
    8000d474:	02113423          	sd	ra,40(sp)
    8000d478:	02813023          	sd	s0,32(sp)
    8000d47c:	00913c23          	sd	s1,24(sp)
    8000d480:	00050913          	mv	s2,a0
    8000d484:	00058993          	mv	s3,a1
    8000d488:	02c13823          	sd	a2,48(sp)
    8000d48c:	02d13c23          	sd	a3,56(sp)
    8000d490:	04e13023          	sd	a4,64(sp)
    8000d494:	04f13423          	sd	a5,72(sp)
    8000d498:	05013823          	sd	a6,80(sp)
    8000d49c:	05113c23          	sd	a7,88(sp)
    8000d4a0:	c19fe0ef          	jal	ra,8000c0b8 <fd_new>
    8000d4a4:	02055863          	bgez	a0,8000d4d4 <open+0x6c>
    8000d4a8:	ff400513          	li	a0,-12
    8000d4ac:	b25f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d4b0:	fff00413          	li	s0,-1
    8000d4b4:	02813083          	ld	ra,40(sp)
    8000d4b8:	00040513          	mv	a0,s0
    8000d4bc:	02013403          	ld	s0,32(sp)
    8000d4c0:	01813483          	ld	s1,24(sp)
    8000d4c4:	01013903          	ld	s2,16(sp)
    8000d4c8:	00813983          	ld	s3,8(sp)
    8000d4cc:	06010113          	addi	sp,sp,96
    8000d4d0:	00008067          	ret
    8000d4d4:	00050413          	mv	s0,a0
    8000d4d8:	d49fe0ef          	jal	ra,8000c220 <fd_get>
    8000d4dc:	00090593          	mv	a1,s2
    8000d4e0:	00098613          	mv	a2,s3
    8000d4e4:	00050493          	mv	s1,a0
    8000d4e8:	9ccff0ef          	jal	ra,8000c6b4 <dfs_file_open>
    8000d4ec:	00050913          	mv	s2,a0
    8000d4f0:	00048513          	mv	a0,s1
    8000d4f4:	00095c63          	bgez	s2,8000d50c <open+0xa4>
    8000d4f8:	db9fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d4fc:	00048513          	mv	a0,s1
    8000d500:	db1fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d504:	00090513          	mv	a0,s2
    8000d508:	fa5ff06f          	j	8000d4ac <open+0x44>
    8000d50c:	da5fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d510:	fa5ff06f          	j	8000d4b4 <open+0x4c>

000000008000d514 <close>:
    8000d514:	fe010113          	addi	sp,sp,-32
    8000d518:	00113c23          	sd	ra,24(sp)
    8000d51c:	00813823          	sd	s0,16(sp)
    8000d520:	00913423          	sd	s1,8(sp)
    8000d524:	cfdfe0ef          	jal	ra,8000c220 <fd_get>
    8000d528:	02051263          	bnez	a0,8000d54c <close+0x38>
    8000d52c:	ff700513          	li	a0,-9
    8000d530:	aa1f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d534:	fff00513          	li	a0,-1
    8000d538:	01813083          	ld	ra,24(sp)
    8000d53c:	01013403          	ld	s0,16(sp)
    8000d540:	00813483          	ld	s1,8(sp)
    8000d544:	02010113          	addi	sp,sp,32
    8000d548:	00008067          	ret
    8000d54c:	00050413          	mv	s0,a0
    8000d550:	ac0ff0ef          	jal	ra,8000c810 <dfs_file_close>
    8000d554:	00050493          	mv	s1,a0
    8000d558:	00040513          	mv	a0,s0
    8000d55c:	d55fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d560:	0004d663          	bgez	s1,8000d56c <close+0x58>
    8000d564:	00048513          	mv	a0,s1
    8000d568:	fc9ff06f          	j	8000d530 <close+0x1c>
    8000d56c:	00040513          	mv	a0,s0
    8000d570:	d41fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d574:	00000513          	li	a0,0
    8000d578:	fc1ff06f          	j	8000d538 <close+0x24>

000000008000d57c <read>:
    8000d57c:	fd010113          	addi	sp,sp,-48
    8000d580:	00b13423          	sd	a1,8(sp)
    8000d584:	00c13023          	sd	a2,0(sp)
    8000d588:	02113423          	sd	ra,40(sp)
    8000d58c:	02813023          	sd	s0,32(sp)
    8000d590:	00913c23          	sd	s1,24(sp)
    8000d594:	c8dfe0ef          	jal	ra,8000c220 <fd_get>
    8000d598:	00013603          	ld	a2,0(sp)
    8000d59c:	00813583          	ld	a1,8(sp)
    8000d5a0:	02051463          	bnez	a0,8000d5c8 <read+0x4c>
    8000d5a4:	ff700513          	li	a0,-9
    8000d5a8:	a29f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d5ac:	fff00413          	li	s0,-1
    8000d5b0:	02813083          	ld	ra,40(sp)
    8000d5b4:	00040513          	mv	a0,s0
    8000d5b8:	02013403          	ld	s0,32(sp)
    8000d5bc:	01813483          	ld	s1,24(sp)
    8000d5c0:	03010113          	addi	sp,sp,48
    8000d5c4:	00008067          	ret
    8000d5c8:	00050493          	mv	s1,a0
    8000d5cc:	aa4ff0ef          	jal	ra,8000c870 <dfs_file_read>
    8000d5d0:	00050413          	mv	s0,a0
    8000d5d4:	00048513          	mv	a0,s1
    8000d5d8:	00045863          	bgez	s0,8000d5e8 <read+0x6c>
    8000d5dc:	cd5fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d5e0:	00040513          	mv	a0,s0
    8000d5e4:	fc5ff06f          	j	8000d5a8 <read+0x2c>
    8000d5e8:	cc9fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d5ec:	fc5ff06f          	j	8000d5b0 <read+0x34>

000000008000d5f0 <write>:
    8000d5f0:	fd010113          	addi	sp,sp,-48
    8000d5f4:	00b13423          	sd	a1,8(sp)
    8000d5f8:	00c13023          	sd	a2,0(sp)
    8000d5fc:	02113423          	sd	ra,40(sp)
    8000d600:	02813023          	sd	s0,32(sp)
    8000d604:	00913c23          	sd	s1,24(sp)
    8000d608:	c19fe0ef          	jal	ra,8000c220 <fd_get>
    8000d60c:	00013603          	ld	a2,0(sp)
    8000d610:	00813583          	ld	a1,8(sp)
    8000d614:	02051463          	bnez	a0,8000d63c <write+0x4c>
    8000d618:	ff700513          	li	a0,-9
    8000d61c:	9b5f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d620:	fff00413          	li	s0,-1
    8000d624:	02813083          	ld	ra,40(sp)
    8000d628:	00040513          	mv	a0,s0
    8000d62c:	02013403          	ld	s0,32(sp)
    8000d630:	01813483          	ld	s1,24(sp)
    8000d634:	03010113          	addi	sp,sp,48
    8000d638:	00008067          	ret
    8000d63c:	00050493          	mv	s1,a0
    8000d640:	c8cff0ef          	jal	ra,8000cacc <dfs_file_write>
    8000d644:	00050413          	mv	s0,a0
    8000d648:	00048513          	mv	a0,s1
    8000d64c:	00045863          	bgez	s0,8000d65c <write+0x6c>
    8000d650:	c61fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d654:	00040513          	mv	a0,s0
    8000d658:	fc5ff06f          	j	8000d61c <write+0x2c>
    8000d65c:	c55fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d660:	fc5ff06f          	j	8000d624 <write+0x34>

000000008000d664 <lseek>:
    8000d664:	fe010113          	addi	sp,sp,-32
    8000d668:	00813823          	sd	s0,16(sp)
    8000d66c:	01213023          	sd	s2,0(sp)
    8000d670:	00113c23          	sd	ra,24(sp)
    8000d674:	00913423          	sd	s1,8(sp)
    8000d678:	00058413          	mv	s0,a1
    8000d67c:	00060913          	mv	s2,a2
    8000d680:	ba1fe0ef          	jal	ra,8000c220 <fd_get>
    8000d684:	02051663          	bnez	a0,8000d6b0 <lseek+0x4c>
    8000d688:	ff700513          	li	a0,-9
    8000d68c:	945f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d690:	fff00413          	li	s0,-1
    8000d694:	01813083          	ld	ra,24(sp)
    8000d698:	00040513          	mv	a0,s0
    8000d69c:	01013403          	ld	s0,16(sp)
    8000d6a0:	00813483          	ld	s1,8(sp)
    8000d6a4:	00013903          	ld	s2,0(sp)
    8000d6a8:	02010113          	addi	sp,sp,32
    8000d6ac:	00008067          	ret
    8000d6b0:	00100793          	li	a5,1
    8000d6b4:	00050493          	mv	s1,a0
    8000d6b8:	02f90c63          	beq	s2,a5,8000d6f0 <lseek+0x8c>
    8000d6bc:	00200793          	li	a5,2
    8000d6c0:	02f90e63          	beq	s2,a5,8000d6fc <lseek+0x98>
    8000d6c4:	04091063          	bnez	s2,8000d704 <lseek+0xa0>
    8000d6c8:	00048513          	mv	a0,s1
    8000d6cc:	02044c63          	bltz	s0,8000d704 <lseek+0xa0>
    8000d6d0:	00040593          	mv	a1,s0
    8000d6d4:	d48ff0ef          	jal	ra,8000cc1c <dfs_file_lseek>
    8000d6d8:	00050913          	mv	s2,a0
    8000d6dc:	00048513          	mv	a0,s1
    8000d6e0:	02095863          	bgez	s2,8000d710 <lseek+0xac>
    8000d6e4:	bcdfe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d6e8:	00090513          	mv	a0,s2
    8000d6ec:	fa1ff06f          	j	8000d68c <lseek+0x28>
    8000d6f0:	03853783          	ld	a5,56(a0)
    8000d6f4:	00f40433          	add	s0,s0,a5
    8000d6f8:	fd1ff06f          	j	8000d6c8 <lseek+0x64>
    8000d6fc:	03053783          	ld	a5,48(a0)
    8000d700:	ff5ff06f          	j	8000d6f4 <lseek+0x90>
    8000d704:	badfe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d708:	fea00513          	li	a0,-22
    8000d70c:	f81ff06f          	j	8000d68c <lseek+0x28>
    8000d710:	ba1fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d714:	f81ff06f          	j	8000d694 <lseek+0x30>

000000008000d718 <rename>:
    8000d718:	ff010113          	addi	sp,sp,-16
    8000d71c:	00113423          	sd	ra,8(sp)
    8000d720:	badff0ef          	jal	ra,8000d2cc <dfs_file_rename>
    8000d724:	00055c63          	bgez	a0,8000d73c <rename+0x24>
    8000d728:	8a9f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d72c:	fff00513          	li	a0,-1
    8000d730:	00813083          	ld	ra,8(sp)
    8000d734:	01010113          	addi	sp,sp,16
    8000d738:	00008067          	ret
    8000d73c:	00000513          	li	a0,0
    8000d740:	ff1ff06f          	j	8000d730 <rename+0x18>

000000008000d744 <unlink>:
    8000d744:	ff010113          	addi	sp,sp,-16
    8000d748:	00113423          	sd	ra,8(sp)
    8000d74c:	a64ff0ef          	jal	ra,8000c9b0 <dfs_file_unlink>
    8000d750:	00055c63          	bgez	a0,8000d768 <unlink+0x24>
    8000d754:	87df80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d758:	fff00513          	li	a0,-1
    8000d75c:	00813083          	ld	ra,8(sp)
    8000d760:	01010113          	addi	sp,sp,16
    8000d764:	00008067          	ret
    8000d768:	00000513          	li	a0,0
    8000d76c:	ff1ff06f          	j	8000d75c <unlink+0x18>

000000008000d770 <stat>:
    8000d770:	ff010113          	addi	sp,sp,-16
    8000d774:	00113423          	sd	ra,8(sp)
    8000d778:	cf8ff0ef          	jal	ra,8000cc70 <dfs_file_stat>
    8000d77c:	00050793          	mv	a5,a0
    8000d780:	00055663          	bgez	a0,8000d78c <stat+0x1c>
    8000d784:	84df80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d788:	fff00793          	li	a5,-1
    8000d78c:	00813083          	ld	ra,8(sp)
    8000d790:	00078513          	mv	a0,a5
    8000d794:	01010113          	addi	sp,sp,16
    8000d798:	00008067          	ret

000000008000d79c <opendir>:
    8000d79c:	fe010113          	addi	sp,sp,-32
    8000d7a0:	00813823          	sd	s0,16(sp)
    8000d7a4:	00113c23          	sd	ra,24(sp)
    8000d7a8:	00913423          	sd	s1,8(sp)
    8000d7ac:	01213023          	sd	s2,0(sp)
    8000d7b0:	00050413          	mv	s0,a0
    8000d7b4:	905fe0ef          	jal	ra,8000c0b8 <fd_new>
    8000d7b8:	fff00793          	li	a5,-1
    8000d7bc:	00f51a63          	bne	a0,a5,8000d7d0 <opendir+0x34>
    8000d7c0:	ff400513          	li	a0,-12
    8000d7c4:	80df80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d7c8:	00000413          	li	s0,0
    8000d7cc:	04c0006f          	j	8000d818 <opendir+0x7c>
    8000d7d0:	00050913          	mv	s2,a0
    8000d7d4:	a4dfe0ef          	jal	ra,8000c220 <fd_get>
    8000d7d8:	00040593          	mv	a1,s0
    8000d7dc:	00010637          	lui	a2,0x10
    8000d7e0:	00050493          	mv	s1,a0
    8000d7e4:	ed1fe0ef          	jal	ra,8000c6b4 <dfs_file_open>
    8000d7e8:	00050413          	mv	s0,a0
    8000d7ec:	04054e63          	bltz	a0,8000d848 <opendir+0xac>
    8000d7f0:	20c00513          	li	a0,524
    8000d7f4:	f30f70ef          	jal	ra,80004f24 <rt_malloc>
    8000d7f8:	00050413          	mv	s0,a0
    8000d7fc:	02051c63          	bnez	a0,8000d834 <opendir+0x98>
    8000d800:	00048513          	mv	a0,s1
    8000d804:	80cff0ef          	jal	ra,8000c810 <dfs_file_close>
    8000d808:	00048513          	mv	a0,s1
    8000d80c:	aa5fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d810:	00048513          	mv	a0,s1
    8000d814:	a9dfe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d818:	01813083          	ld	ra,24(sp)
    8000d81c:	00040513          	mv	a0,s0
    8000d820:	01013403          	ld	s0,16(sp)
    8000d824:	00813483          	ld	s1,8(sp)
    8000d828:	00013903          	ld	s2,0(sp)
    8000d82c:	02010113          	addi	sp,sp,32
    8000d830:	00008067          	ret
    8000d834:	20c00613          	li	a2,524
    8000d838:	00000593          	li	a1,0
    8000d83c:	b20f60ef          	jal	ra,80003b5c <memset>
    8000d840:	01242023          	sw	s2,0(s0)
    8000d844:	fcdff06f          	j	8000d810 <opendir+0x74>
    8000d848:	00048513          	mv	a0,s1
    8000d84c:	a65fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d850:	00048513          	mv	a0,s1
    8000d854:	a5dfe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d858:	00040513          	mv	a0,s0
    8000d85c:	f69ff06f          	j	8000d7c4 <opendir+0x28>

000000008000d860 <readdir>:
    8000d860:	fd010113          	addi	sp,sp,-48
    8000d864:	00913c23          	sd	s1,24(sp)
    8000d868:	00050493          	mv	s1,a0
    8000d86c:	00052503          	lw	a0,0(a0)
    8000d870:	02813023          	sd	s0,32(sp)
    8000d874:	02113423          	sd	ra,40(sp)
    8000d878:	01213823          	sd	s2,16(sp)
    8000d87c:	01313423          	sd	s3,8(sp)
    8000d880:	9a1fe0ef          	jal	ra,8000c220 <fd_get>
    8000d884:	00050413          	mv	s0,a0
    8000d888:	02051663          	bnez	a0,8000d8b4 <readdir+0x54>
    8000d88c:	ff700513          	li	a0,-9
    8000d890:	f40f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d894:	02813083          	ld	ra,40(sp)
    8000d898:	00040513          	mv	a0,s0
    8000d89c:	02013403          	ld	s0,32(sp)
    8000d8a0:	01813483          	ld	s1,24(sp)
    8000d8a4:	01013903          	ld	s2,16(sp)
    8000d8a8:	00813983          	ld	s3,8(sp)
    8000d8ac:	03010113          	addi	sp,sp,48
    8000d8b0:	00008067          	ret
    8000d8b4:	2044a703          	lw	a4,516(s1)
    8000d8b8:	00448993          	addi	s3,s1,4
    8000d8bc:	02071a63          	bnez	a4,8000d8f0 <readdir+0x90>
    8000d8c0:	1ff00613          	li	a2,511
    8000d8c4:	00098593          	mv	a1,s3
    8000d8c8:	00040513          	mv	a0,s0
    8000d8cc:	8b0ff0ef          	jal	ra,8000c97c <dfs_file_getdents>
    8000d8d0:	00050913          	mv	s2,a0
    8000d8d4:	04a04463          	bgtz	a0,8000d91c <readdir+0xbc>
    8000d8d8:	00040513          	mv	a0,s0
    8000d8dc:	9d5fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d8e0:	00090513          	mv	a0,s2
    8000d8e4:	eecf80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d8e8:	00000413          	li	s0,0
    8000d8ec:	fa9ff06f          	j	8000d894 <readdir+0x34>
    8000d8f0:	2084a683          	lw	a3,520(s1)
    8000d8f4:	00d487b3          	add	a5,s1,a3
    8000d8f8:	0067d783          	lhu	a5,6(a5)
    8000d8fc:	00d786bb          	addw	a3,a5,a3
    8000d900:	20d4a423          	sw	a3,520(s1)
    8000d904:	fae6dee3          	bge	a3,a4,8000d8c0 <readdir+0x60>
    8000d908:	00040513          	mv	a0,s0
    8000d90c:	9a5fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d910:	2084a403          	lw	s0,520(s1)
    8000d914:	00898433          	add	s0,s3,s0
    8000d918:	f7dff06f          	j	8000d894 <readdir+0x34>
    8000d91c:	20a4a223          	sw	a0,516(s1)
    8000d920:	2004a423          	sw	zero,520(s1)
    8000d924:	fe5ff06f          	j	8000d908 <readdir+0xa8>

000000008000d928 <rewinddir>:
    8000d928:	fe010113          	addi	sp,sp,-32
    8000d92c:	00813823          	sd	s0,16(sp)
    8000d930:	00050413          	mv	s0,a0
    8000d934:	00052503          	lw	a0,0(a0)
    8000d938:	00113c23          	sd	ra,24(sp)
    8000d93c:	00913423          	sd	s1,8(sp)
    8000d940:	8e1fe0ef          	jal	ra,8000c220 <fd_get>
    8000d944:	00051e63          	bnez	a0,8000d960 <rewinddir+0x38>
    8000d948:	01013403          	ld	s0,16(sp)
    8000d94c:	01813083          	ld	ra,24(sp)
    8000d950:	00813483          	ld	s1,8(sp)
    8000d954:	ff700513          	li	a0,-9
    8000d958:	02010113          	addi	sp,sp,32
    8000d95c:	e74f806f          	j	80005fd0 <rt_set_errno>
    8000d960:	00000593          	li	a1,0
    8000d964:	00050493          	mv	s1,a0
    8000d968:	ab4ff0ef          	jal	ra,8000cc1c <dfs_file_lseek>
    8000d96c:	00054663          	bltz	a0,8000d978 <rewinddir+0x50>
    8000d970:	20042423          	sw	zero,520(s0)
    8000d974:	20042223          	sw	zero,516(s0)
    8000d978:	01013403          	ld	s0,16(sp)
    8000d97c:	01813083          	ld	ra,24(sp)
    8000d980:	00048513          	mv	a0,s1
    8000d984:	00813483          	ld	s1,8(sp)
    8000d988:	02010113          	addi	sp,sp,32
    8000d98c:	925fe06f          	j	8000c2b0 <fd_put>

000000008000d990 <closedir>:
    8000d990:	fe010113          	addi	sp,sp,-32
    8000d994:	01213023          	sd	s2,0(sp)
    8000d998:	00050913          	mv	s2,a0
    8000d99c:	00052503          	lw	a0,0(a0)
    8000d9a0:	00113c23          	sd	ra,24(sp)
    8000d9a4:	00813823          	sd	s0,16(sp)
    8000d9a8:	00913423          	sd	s1,8(sp)
    8000d9ac:	875fe0ef          	jal	ra,8000c220 <fd_get>
    8000d9b0:	02051463          	bnez	a0,8000d9d8 <closedir+0x48>
    8000d9b4:	ff700513          	li	a0,-9
    8000d9b8:	e18f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000d9bc:	fff00513          	li	a0,-1
    8000d9c0:	01813083          	ld	ra,24(sp)
    8000d9c4:	01013403          	ld	s0,16(sp)
    8000d9c8:	00813483          	ld	s1,8(sp)
    8000d9cc:	00013903          	ld	s2,0(sp)
    8000d9d0:	02010113          	addi	sp,sp,32
    8000d9d4:	00008067          	ret
    8000d9d8:	00050413          	mv	s0,a0
    8000d9dc:	e35fe0ef          	jal	ra,8000c810 <dfs_file_close>
    8000d9e0:	00050493          	mv	s1,a0
    8000d9e4:	00040513          	mv	a0,s0
    8000d9e8:	8c9fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d9ec:	00040513          	mv	a0,s0
    8000d9f0:	8c1fe0ef          	jal	ra,8000c2b0 <fd_put>
    8000d9f4:	00090513          	mv	a0,s2
    8000d9f8:	879f70ef          	jal	ra,80005270 <rt_free>
    8000d9fc:	00000513          	li	a0,0
    8000da00:	fc04d0e3          	bgez	s1,8000d9c0 <closedir+0x30>
    8000da04:	00048513          	mv	a0,s1
    8000da08:	fb1ff06f          	j	8000d9b8 <closedir+0x28>

000000008000da0c <chdir>:
    8000da0c:	fe010113          	addi	sp,sp,-32
    8000da10:	00113c23          	sd	ra,24(sp)
    8000da14:	00813823          	sd	s0,16(sp)
    8000da18:	02051463          	bnez	a0,8000da40 <chdir+0x34>
    8000da1c:	e24fe0ef          	jal	ra,8000c040 <dfs_lock>
    8000da20:	00008597          	auipc	a1,0x8
    8000da24:	c8058593          	addi	a1,a1,-896 # 800156a0 <working_directory>
    8000da28:	00005517          	auipc	a0,0x5
    8000da2c:	88050513          	addi	a0,a0,-1920 # 800122a8 <CSWTCH.17+0x80>
    8000da30:	fbdf80ef          	jal	ra,800069ec <rt_kprintf>
    8000da34:	e78fe0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000da38:	00000513          	li	a0,0
    8000da3c:	0240006f          	j	8000da60 <chdir+0x54>
    8000da40:	00a13423          	sd	a0,8(sp)
    8000da44:	8acf60ef          	jal	ra,80003af0 <strlen>
    8000da48:	10000793          	li	a5,256
    8000da4c:	00813583          	ld	a1,8(sp)
    8000da50:	02a7f063          	bgeu	a5,a0,8000da70 <chdir+0x64>
    8000da54:	fec00513          	li	a0,-20
    8000da58:	d78f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000da5c:	fff00513          	li	a0,-1
    8000da60:	01813083          	ld	ra,24(sp)
    8000da64:	01013403          	ld	s0,16(sp)
    8000da68:	02010113          	addi	sp,sp,32
    8000da6c:	00008067          	ret
    8000da70:	00000513          	li	a0,0
    8000da74:	941fe0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000da78:	00050413          	mv	s0,a0
    8000da7c:	fc050ce3          	beqz	a0,8000da54 <chdir+0x48>
    8000da80:	dc0fe0ef          	jal	ra,8000c040 <dfs_lock>
    8000da84:	00040513          	mv	a0,s0
    8000da88:	d15ff0ef          	jal	ra,8000d79c <opendir>
    8000da8c:	00051a63          	bnez	a0,8000daa0 <chdir+0x94>
    8000da90:	00040513          	mv	a0,s0
    8000da94:	fdcf70ef          	jal	ra,80005270 <rt_free>
    8000da98:	e14fe0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000da9c:	fc1ff06f          	j	8000da5c <chdir+0x50>
    8000daa0:	ef1ff0ef          	jal	ra,8000d990 <closedir>
    8000daa4:	10000613          	li	a2,256
    8000daa8:	00040593          	mv	a1,s0
    8000daac:	00008517          	auipc	a0,0x8
    8000dab0:	bf450513          	addi	a0,a0,-1036 # 800156a0 <working_directory>
    8000dab4:	864f60ef          	jal	ra,80003b18 <strncpy>
    8000dab8:	00040513          	mv	a0,s0
    8000dabc:	fb4f70ef          	jal	ra,80005270 <rt_free>
    8000dac0:	f75ff06f          	j	8000da34 <chdir+0x28>

000000008000dac4 <getcwd>:
    8000dac4:	fe010113          	addi	sp,sp,-32
    8000dac8:	00113c23          	sd	ra,24(sp)
    8000dacc:	00813823          	sd	s0,16(sp)
    8000dad0:	00b13423          	sd	a1,8(sp)
    8000dad4:	00050413          	mv	s0,a0
    8000dad8:	d68fe0ef          	jal	ra,8000c040 <dfs_lock>
    8000dadc:	00813603          	ld	a2,8(sp)
    8000dae0:	00008597          	auipc	a1,0x8
    8000dae4:	bc058593          	addi	a1,a1,-1088 # 800156a0 <working_directory>
    8000dae8:	00040513          	mv	a0,s0
    8000daec:	82cf60ef          	jal	ra,80003b18 <strncpy>
    8000daf0:	dbcfe0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000daf4:	01813083          	ld	ra,24(sp)
    8000daf8:	00040513          	mv	a0,s0
    8000dafc:	01013403          	ld	s0,16(sp)
    8000db00:	02010113          	addi	sp,sp,32
    8000db04:	00008067          	ret

000000008000db08 <dfs_register>:
    8000db08:	fc010113          	addi	sp,sp,-64
    8000db0c:	02813823          	sd	s0,48(sp)
    8000db10:	02913423          	sd	s1,40(sp)
    8000db14:	03213023          	sd	s2,32(sp)
    8000db18:	01313c23          	sd	s3,24(sp)
    8000db1c:	02113c23          	sd	ra,56(sp)
    8000db20:	00050413          	mv	s0,a0
    8000db24:	00019917          	auipc	s2,0x19
    8000db28:	e2c90913          	addi	s2,s2,-468 # 80026950 <filesystem_operation_table>
    8000db2c:	d14fe0ef          	jal	ra,8000c040 <dfs_lock>
    8000db30:	00000493          	li	s1,0
    8000db34:	00019997          	auipc	s3,0x19
    8000db38:	e2c98993          	addi	s3,s3,-468 # 80026960 <filesystem_table>
    8000db3c:	00093783          	ld	a5,0(s2)
    8000db40:	04079663          	bnez	a5,8000db8c <dfs_register+0x84>
    8000db44:	00049463          	bnez	s1,8000db4c <dfs_register+0x44>
    8000db48:	00090493          	mv	s1,s2
    8000db4c:	00890913          	addi	s2,s2,8
    8000db50:	ff3916e3          	bne	s2,s3,8000db3c <dfs_register+0x34>
    8000db54:	08049063          	bnez	s1,8000dbd4 <dfs_register+0xcc>
    8000db58:	fe400513          	li	a0,-28
    8000db5c:	c74f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000db60:	00006517          	auipc	a0,0x6
    8000db64:	d1850513          	addi	a0,a0,-744 # 80013878 <__fsym_hello_name+0xc8>
    8000db68:	e85f80ef          	jal	ra,800069ec <rt_kprintf>
    8000db6c:	00043583          	ld	a1,0(s0)
    8000db70:	00006517          	auipc	a0,0x6
    8000db74:	06850513          	addi	a0,a0,104 # 80013bd8 <__fsym_mkdir_name+0x20>
    8000db78:	e75f80ef          	jal	ra,800069ec <rt_kprintf>
    8000db7c:	00005517          	auipc	a0,0x5
    8000db80:	09450513          	addi	a0,a0,148 # 80012c10 <__FUNCTION__.6+0x28>
    8000db84:	e69f80ef          	jal	ra,800069ec <rt_kprintf>
    8000db88:	0200006f          	j	8000dba8 <dfs_register+0xa0>
    8000db8c:	00043583          	ld	a1,0(s0)
    8000db90:	0007b503          	ld	a0,0(a5)
    8000db94:	fc1f50ef          	jal	ra,80003b54 <strcmp>
    8000db98:	fa051ae3          	bnez	a0,8000db4c <dfs_register+0x44>
    8000db9c:	fef00513          	li	a0,-17
    8000dba0:	c30f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000dba4:	fa048ae3          	beqz	s1,8000db58 <dfs_register+0x50>
    8000dba8:	fff00513          	li	a0,-1
    8000dbac:	00a13423          	sd	a0,8(sp)
    8000dbb0:	cfcfe0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000dbb4:	03813083          	ld	ra,56(sp)
    8000dbb8:	03013403          	ld	s0,48(sp)
    8000dbbc:	00813503          	ld	a0,8(sp)
    8000dbc0:	02813483          	ld	s1,40(sp)
    8000dbc4:	02013903          	ld	s2,32(sp)
    8000dbc8:	01813983          	ld	s3,24(sp)
    8000dbcc:	04010113          	addi	sp,sp,64
    8000dbd0:	00008067          	ret
    8000dbd4:	0084b023          	sd	s0,0(s1)
    8000dbd8:	00000513          	li	a0,0
    8000dbdc:	fd1ff06f          	j	8000dbac <dfs_register+0xa4>

000000008000dbe0 <dfs_filesystem_lookup>:
    8000dbe0:	fa010113          	addi	sp,sp,-96
    8000dbe4:	05213023          	sd	s2,64(sp)
    8000dbe8:	04113c23          	sd	ra,88(sp)
    8000dbec:	04813823          	sd	s0,80(sp)
    8000dbf0:	04913423          	sd	s1,72(sp)
    8000dbf4:	03313c23          	sd	s3,56(sp)
    8000dbf8:	03413823          	sd	s4,48(sp)
    8000dbfc:	03513423          	sd	s5,40(sp)
    8000dc00:	03613023          	sd	s6,32(sp)
    8000dc04:	01713c23          	sd	s7,24(sp)
    8000dc08:	01813823          	sd	s8,16(sp)
    8000dc0c:	01913423          	sd	s9,8(sp)
    8000dc10:	01a13023          	sd	s10,0(sp)
    8000dc14:	00050913          	mv	s2,a0
    8000dc18:	00051e63          	bnez	a0,8000dc34 <dfs_filesystem_lookup+0x54>
    8000dc1c:	05600613          	li	a2,86
    8000dc20:	00006597          	auipc	a1,0x6
    8000dc24:	0f858593          	addi	a1,a1,248 # 80013d18 <__FUNCTION__.1>
    8000dc28:	00006517          	auipc	a0,0x6
    8000dc2c:	fe850513          	addi	a0,a0,-24 # 80013c10 <__fsym_mkdir_name+0x58>
    8000dc30:	f45f80ef          	jal	ra,80006b74 <rt_assert_handler>
    8000dc34:	fff00a93          	li	s5,-1
    8000dc38:	c08fe0ef          	jal	ra,8000c040 <dfs_lock>
    8000dc3c:	00000a13          	li	s4,0
    8000dc40:	00000993          	li	s3,0
    8000dc44:	00019497          	auipc	s1,0x19
    8000dc48:	d1c48493          	addi	s1,s1,-740 # 80026960 <filesystem_table>
    8000dc4c:	020ada93          	srli	s5,s5,0x20
    8000dc50:	00100b93          	li	s7,1
    8000dc54:	02f00c13          	li	s8,47
    8000dc58:	00019b17          	auipc	s6,0x19
    8000dc5c:	d48b0b13          	addi	s6,s6,-696 # 800269a0 <fslock>
    8000dc60:	0084bd03          	ld	s10,8(s1)
    8000dc64:	040d0863          	beqz	s10,8000dcb4 <dfs_filesystem_lookup+0xd4>
    8000dc68:	0104b783          	ld	a5,16(s1)
    8000dc6c:	04078463          	beqz	a5,8000dcb4 <dfs_filesystem_lookup+0xd4>
    8000dc70:	000d0513          	mv	a0,s10
    8000dc74:	e7df50ef          	jal	ra,80003af0 <strlen>
    8000dc78:	00050c9b          	sext.w	s9,a0
    8000dc7c:	034cec63          	bltu	s9,s4,8000dcb4 <dfs_filesystem_lookup+0xd4>
    8000dc80:	01557433          	and	s0,a0,s5
    8000dc84:	00040613          	mv	a2,s0
    8000dc88:	00090593          	mv	a1,s2
    8000dc8c:	000d0513          	mv	a0,s10
    8000dc90:	ec9f50ef          	jal	ra,80003b58 <strncmp>
    8000dc94:	02051063          	bnez	a0,8000dcb4 <dfs_filesystem_lookup+0xd4>
    8000dc98:	079bf263          	bgeu	s7,s9,8000dcfc <dfs_filesystem_lookup+0x11c>
    8000dc9c:	00090513          	mv	a0,s2
    8000dca0:	e51f50ef          	jal	ra,80003af0 <strlen>
    8000dca4:	04a47c63          	bgeu	s0,a0,8000dcfc <dfs_filesystem_lookup+0x11c>
    8000dca8:	00890433          	add	s0,s2,s0
    8000dcac:	00044783          	lbu	a5,0(s0)
    8000dcb0:	05878663          	beq	a5,s8,8000dcfc <dfs_filesystem_lookup+0x11c>
    8000dcb4:	02048493          	addi	s1,s1,32
    8000dcb8:	fb6494e3          	bne	s1,s6,8000dc60 <dfs_filesystem_lookup+0x80>
    8000dcbc:	bf0fe0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000dcc0:	05813083          	ld	ra,88(sp)
    8000dcc4:	05013403          	ld	s0,80(sp)
    8000dcc8:	04813483          	ld	s1,72(sp)
    8000dccc:	04013903          	ld	s2,64(sp)
    8000dcd0:	03013a03          	ld	s4,48(sp)
    8000dcd4:	02813a83          	ld	s5,40(sp)
    8000dcd8:	02013b03          	ld	s6,32(sp)
    8000dcdc:	01813b83          	ld	s7,24(sp)
    8000dce0:	01013c03          	ld	s8,16(sp)
    8000dce4:	00813c83          	ld	s9,8(sp)
    8000dce8:	00013d03          	ld	s10,0(sp)
    8000dcec:	00098513          	mv	a0,s3
    8000dcf0:	03813983          	ld	s3,56(sp)
    8000dcf4:	06010113          	addi	sp,sp,96
    8000dcf8:	00008067          	ret
    8000dcfc:	000c8a13          	mv	s4,s9
    8000dd00:	00048993          	mv	s3,s1
    8000dd04:	fb1ff06f          	j	8000dcb4 <dfs_filesystem_lookup+0xd4>

000000008000dd08 <dfs_mount>:
    8000dd08:	f5010113          	addi	sp,sp,-176
    8000dd0c:	07513c23          	sd	s5,120(sp)
    8000dd10:	07613823          	sd	s6,112(sp)
    8000dd14:	07713423          	sd	s7,104(sp)
    8000dd18:	07813023          	sd	s8,96(sp)
    8000dd1c:	0a113423          	sd	ra,168(sp)
    8000dd20:	0a813023          	sd	s0,160(sp)
    8000dd24:	08913c23          	sd	s1,152(sp)
    8000dd28:	09213823          	sd	s2,144(sp)
    8000dd2c:	09313423          	sd	s3,136(sp)
    8000dd30:	09413023          	sd	s4,128(sp)
    8000dd34:	05913c23          	sd	s9,88(sp)
    8000dd38:	00058b13          	mv	s6,a1
    8000dd3c:	00060a93          	mv	s5,a2
    8000dd40:	00068b93          	mv	s7,a3
    8000dd44:	00070c13          	mv	s8,a4
    8000dd48:	04050a63          	beqz	a0,8000dd9c <dfs_mount+0x94>
    8000dd4c:	931f70ef          	jal	ra,8000567c <rt_device_find>
    8000dd50:	00050493          	mv	s1,a0
    8000dd54:	04051663          	bnez	a0,8000dda0 <dfs_mount+0x98>
    8000dd58:	fed00513          	li	a0,-19
    8000dd5c:	a74f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000dd60:	fff00793          	li	a5,-1
    8000dd64:	0a813083          	ld	ra,168(sp)
    8000dd68:	0a013403          	ld	s0,160(sp)
    8000dd6c:	09813483          	ld	s1,152(sp)
    8000dd70:	09013903          	ld	s2,144(sp)
    8000dd74:	08813983          	ld	s3,136(sp)
    8000dd78:	08013a03          	ld	s4,128(sp)
    8000dd7c:	07813a83          	ld	s5,120(sp)
    8000dd80:	07013b03          	ld	s6,112(sp)
    8000dd84:	06813b83          	ld	s7,104(sp)
    8000dd88:	06013c03          	ld	s8,96(sp)
    8000dd8c:	05813c83          	ld	s9,88(sp)
    8000dd90:	00078513          	mv	a0,a5
    8000dd94:	0b010113          	addi	sp,sp,176
    8000dd98:	00008067          	ret
    8000dd9c:	00050493          	mv	s1,a0
    8000dda0:	aa0fe0ef          	jal	ra,8000c040 <dfs_lock>
    8000dda4:	00019417          	auipc	s0,0x19
    8000dda8:	bac40413          	addi	s0,s0,-1108 # 80026950 <filesystem_operation_table>
    8000ddac:	00043783          	ld	a5,0(s0)
    8000ddb0:	00019917          	auipc	s2,0x19
    8000ddb4:	bb090913          	addi	s2,s2,-1104 # 80026960 <filesystem_table>
    8000ddb8:	00078c63          	beqz	a5,8000ddd0 <dfs_mount+0xc8>
    8000ddbc:	0007b503          	ld	a0,0(a5)
    8000ddc0:	000a8593          	mv	a1,s5
    8000ddc4:	00040993          	mv	s3,s0
    8000ddc8:	d8df50ef          	jal	ra,80003b54 <strcmp>
    8000ddcc:	02050a63          	beqz	a0,8000de00 <dfs_mount+0xf8>
    8000ddd0:	00843783          	ld	a5,8(s0)
    8000ddd4:	00019997          	auipc	s3,0x19
    8000ddd8:	b8c98993          	addi	s3,s3,-1140 # 80026960 <filesystem_table>
    8000dddc:	02078263          	beqz	a5,8000de00 <dfs_mount+0xf8>
    8000dde0:	0007b503          	ld	a0,0(a5)
    8000dde4:	000a8593          	mv	a1,s5
    8000dde8:	00019997          	auipc	s3,0x19
    8000ddec:	b7098993          	addi	s3,s3,-1168 # 80026958 <filesystem_operation_table+0x8>
    8000ddf0:	d65f50ef          	jal	ra,80003b54 <strcmp>
    8000ddf4:	00050663          	beqz	a0,8000de00 <dfs_mount+0xf8>
    8000ddf8:	00019997          	auipc	s3,0x19
    8000ddfc:	b6898993          	addi	s3,s3,-1176 # 80026960 <filesystem_table>
    8000de00:	aacfe0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000de04:	f5298ae3          	beq	s3,s2,8000dd58 <dfs_mount+0x50>
    8000de08:	0009b783          	ld	a5,0(s3)
    8000de0c:	00078663          	beqz	a5,8000de18 <dfs_mount+0x110>
    8000de10:	0187b783          	ld	a5,24(a5)
    8000de14:	00079663          	bnez	a5,8000de20 <dfs_mount+0x118>
    8000de18:	fda00513          	li	a0,-38
    8000de1c:	f41ff06f          	j	8000dd5c <dfs_mount+0x54>
    8000de20:	000b0593          	mv	a1,s6
    8000de24:	00000513          	li	a0,0
    8000de28:	d8cfe0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000de2c:	00050913          	mv	s2,a0
    8000de30:	00051663          	bnez	a0,8000de3c <dfs_mount+0x134>
    8000de34:	fec00513          	li	a0,-20
    8000de38:	f25ff06f          	j	8000dd5c <dfs_mount+0x54>
    8000de3c:	00004597          	auipc	a1,0x4
    8000de40:	4b458593          	addi	a1,a1,1204 # 800122f0 <CSWTCH.17+0xc8>
    8000de44:	d11f50ef          	jal	ra,80003b54 <strcmp>
    8000de48:	04050063          	beqz	a0,8000de88 <dfs_mount+0x180>
    8000de4c:	00006597          	auipc	a1,0x6
    8000de50:	a2458593          	addi	a1,a1,-1500 # 80013870 <__fsym_hello_name+0xc0>
    8000de54:	00090513          	mv	a0,s2
    8000de58:	cfdf50ef          	jal	ra,80003b54 <strcmp>
    8000de5c:	02050663          	beqz	a0,8000de88 <dfs_mount+0x180>
    8000de60:	00010637          	lui	a2,0x10
    8000de64:	00090593          	mv	a1,s2
    8000de68:	00810513          	addi	a0,sp,8
    8000de6c:	849fe0ef          	jal	ra,8000c6b4 <dfs_file_open>
    8000de70:	00055863          	bgez	a0,8000de80 <dfs_mount+0x178>
    8000de74:	00090513          	mv	a0,s2
    8000de78:	bf8f70ef          	jal	ra,80005270 <rt_free>
    8000de7c:	fb9ff06f          	j	8000de34 <dfs_mount+0x12c>
    8000de80:	00810513          	addi	a0,sp,8
    8000de84:	98dfe0ef          	jal	ra,8000c810 <dfs_file_close>
    8000de88:	9b8fe0ef          	jal	ra,8000c040 <dfs_lock>
    8000de8c:	00000413          	li	s0,0
    8000de90:	00019a17          	auipc	s4,0x19
    8000de94:	ad0a0a13          	addi	s4,s4,-1328 # 80026960 <filesystem_table>
    8000de98:	00019c97          	auipc	s9,0x19
    8000de9c:	b08c8c93          	addi	s9,s9,-1272 # 800269a0 <fslock>
    8000dea0:	010a3783          	ld	a5,16(s4)
    8000dea4:	04079663          	bnez	a5,8000def0 <dfs_mount+0x1e8>
    8000dea8:	00041463          	bnez	s0,8000deb0 <dfs_mount+0x1a8>
    8000deac:	000a0413          	mv	s0,s4
    8000deb0:	020a0a13          	addi	s4,s4,32
    8000deb4:	ff9a16e3          	bne	s4,s9,8000dea0 <dfs_mount+0x198>
    8000deb8:	06041063          	bnez	s0,8000df18 <dfs_mount+0x210>
    8000debc:	fe400513          	li	a0,-28
    8000dec0:	910f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000dec4:	00006517          	auipc	a0,0x6
    8000dec8:	9b450513          	addi	a0,a0,-1612 # 80013878 <__fsym_hello_name+0xc8>
    8000decc:	b21f80ef          	jal	ra,800069ec <rt_kprintf>
    8000ded0:	000a8593          	mv	a1,s5
    8000ded4:	00006517          	auipc	a0,0x6
    8000ded8:	d4450513          	addi	a0,a0,-700 # 80013c18 <__fsym_mkdir_name+0x60>
    8000dedc:	b11f80ef          	jal	ra,800069ec <rt_kprintf>
    8000dee0:	00005517          	auipc	a0,0x5
    8000dee4:	d3050513          	addi	a0,a0,-720 # 80012c10 <__FUNCTION__.6+0x28>
    8000dee8:	b05f80ef          	jal	ra,800069ec <rt_kprintf>
    8000deec:	01c0006f          	j	8000df08 <dfs_mount+0x200>
    8000def0:	008a3503          	ld	a0,8(s4)
    8000def4:	000b0593          	mv	a1,s6
    8000def8:	c5df50ef          	jal	ra,80003b54 <strcmp>
    8000defc:	fa051ae3          	bnez	a0,8000deb0 <dfs_mount+0x1a8>
    8000df00:	fea00513          	li	a0,-22
    8000df04:	8ccf80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000df08:	9a4fe0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000df0c:	00090513          	mv	a0,s2
    8000df10:	b60f70ef          	jal	ra,80005270 <rt_free>
    8000df14:	e4dff06f          	j	8000dd60 <dfs_mount+0x58>
    8000df18:	0009b783          	ld	a5,0(s3)
    8000df1c:	01243423          	sd	s2,8(s0)
    8000df20:	00943023          	sd	s1,0(s0)
    8000df24:	00f43823          	sd	a5,16(s0)
    8000df28:	984fe0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000df2c:	02048663          	beqz	s1,8000df58 <dfs_mount+0x250>
    8000df30:	00043503          	ld	a0,0(s0)
    8000df34:	00300593          	li	a1,3
    8000df38:	fc4f70ef          	jal	ra,800056fc <rt_device_open>
    8000df3c:	00050e63          	beqz	a0,8000df58 <dfs_mount+0x250>
    8000df40:	900fe0ef          	jal	ra,8000c040 <dfs_lock>
    8000df44:	02000613          	li	a2,32
    8000df48:	00000593          	li	a1,0
    8000df4c:	00040513          	mv	a0,s0
    8000df50:	c0df50ef          	jal	ra,80003b5c <memset>
    8000df54:	fb5ff06f          	j	8000df08 <dfs_mount+0x200>
    8000df58:	0009b783          	ld	a5,0(s3)
    8000df5c:	000c0613          	mv	a2,s8
    8000df60:	000b8593          	mv	a1,s7
    8000df64:	0187b783          	ld	a5,24(a5)
    8000df68:	00040513          	mv	a0,s0
    8000df6c:	000780e7          	jalr	a5
    8000df70:	00000793          	li	a5,0
    8000df74:	de0558e3          	bgez	a0,8000dd64 <dfs_mount+0x5c>
    8000df78:	fc0484e3          	beqz	s1,8000df40 <dfs_mount+0x238>
    8000df7c:	00043503          	ld	a0,0(s0)
    8000df80:	8d5f70ef          	jal	ra,80005854 <rt_device_close>
    8000df84:	fbdff06f          	j	8000df40 <dfs_mount+0x238>

000000008000df88 <dfs_unmount>:
    8000df88:	fe010113          	addi	sp,sp,-32
    8000df8c:	00050593          	mv	a1,a0
    8000df90:	00000513          	li	a0,0
    8000df94:	00113c23          	sd	ra,24(sp)
    8000df98:	00813823          	sd	s0,16(sp)
    8000df9c:	00913423          	sd	s1,8(sp)
    8000dfa0:	c14fe0ef          	jal	ra,8000c3b4 <dfs_normalize_path>
    8000dfa4:	02051263          	bnez	a0,8000dfc8 <dfs_unmount+0x40>
    8000dfa8:	fec00513          	li	a0,-20
    8000dfac:	824f80ef          	jal	ra,80005fd0 <rt_set_errno>
    8000dfb0:	fff00513          	li	a0,-1
    8000dfb4:	01813083          	ld	ra,24(sp)
    8000dfb8:	01013403          	ld	s0,16(sp)
    8000dfbc:	00813483          	ld	s1,8(sp)
    8000dfc0:	02010113          	addi	sp,sp,32
    8000dfc4:	00008067          	ret
    8000dfc8:	00050493          	mv	s1,a0
    8000dfcc:	00019417          	auipc	s0,0x19
    8000dfd0:	99440413          	addi	s0,s0,-1644 # 80026960 <filesystem_table>
    8000dfd4:	86cfe0ef          	jal	ra,8000c040 <dfs_lock>
    8000dfd8:	00843503          	ld	a0,8(s0)
    8000dfdc:	00050863          	beqz	a0,8000dfec <dfs_unmount+0x64>
    8000dfe0:	00048593          	mv	a1,s1
    8000dfe4:	b71f50ef          	jal	ra,80003b54 <strcmp>
    8000dfe8:	02050863          	beqz	a0,8000e018 <dfs_unmount+0x90>
    8000dfec:	02843503          	ld	a0,40(s0)
    8000dff0:	00050863          	beqz	a0,8000e000 <dfs_unmount+0x78>
    8000dff4:	00048593          	mv	a1,s1
    8000dff8:	b5df50ef          	jal	ra,80003b54 <strcmp>
    8000dffc:	00050a63          	beqz	a0,8000e010 <dfs_unmount+0x88>
    8000e000:	8acfe0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000e004:	00048513          	mv	a0,s1
    8000e008:	a68f70ef          	jal	ra,80005270 <rt_free>
    8000e00c:	fa5ff06f          	j	8000dfb0 <dfs_unmount+0x28>
    8000e010:	00019417          	auipc	s0,0x19
    8000e014:	97040413          	addi	s0,s0,-1680 # 80026980 <filesystem_table+0x20>
    8000e018:	01043783          	ld	a5,16(s0)
    8000e01c:	0207b783          	ld	a5,32(a5)
    8000e020:	fe0780e3          	beqz	a5,8000e000 <dfs_unmount+0x78>
    8000e024:	00040513          	mv	a0,s0
    8000e028:	000780e7          	jalr	a5
    8000e02c:	fc054ae3          	bltz	a0,8000e000 <dfs_unmount+0x78>
    8000e030:	00043503          	ld	a0,0(s0)
    8000e034:	00050463          	beqz	a0,8000e03c <dfs_unmount+0xb4>
    8000e038:	81df70ef          	jal	ra,80005854 <rt_device_close>
    8000e03c:	00843503          	ld	a0,8(s0)
    8000e040:	00050463          	beqz	a0,8000e048 <dfs_unmount+0xc0>
    8000e044:	a2cf70ef          	jal	ra,80005270 <rt_free>
    8000e048:	02000613          	li	a2,32
    8000e04c:	00000593          	li	a1,0
    8000e050:	00040513          	mv	a0,s0
    8000e054:	b09f50ef          	jal	ra,80003b5c <memset>
    8000e058:	854fe0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000e05c:	00048513          	mv	a0,s1
    8000e060:	a10f70ef          	jal	ra,80005270 <rt_free>
    8000e064:	00000513          	li	a0,0
    8000e068:	f4dff06f          	j	8000dfb4 <dfs_unmount+0x2c>

000000008000e06c <dfs_mkfs>:
    8000e06c:	fd010113          	addi	sp,sp,-48
    8000e070:	02813023          	sd	s0,32(sp)
    8000e074:	02113423          	sd	ra,40(sp)
    8000e078:	00913c23          	sd	s1,24(sp)
    8000e07c:	01213823          	sd	s2,16(sp)
    8000e080:	01313423          	sd	s3,8(sp)
    8000e084:	00058413          	mv	s0,a1
    8000e088:	04059a63          	bnez	a1,8000e0dc <dfs_mkfs+0x70>
    8000e08c:	fed00513          	li	a0,-19
    8000e090:	f41f70ef          	jal	ra,80005fd0 <rt_set_errno>
    8000e094:	00005517          	auipc	a0,0x5
    8000e098:	7e450513          	addi	a0,a0,2020 # 80013878 <__fsym_hello_name+0xc8>
    8000e09c:	951f80ef          	jal	ra,800069ec <rt_kprintf>
    8000e0a0:	00040593          	mv	a1,s0
    8000e0a4:	00006517          	auipc	a0,0x6
    8000e0a8:	bac50513          	addi	a0,a0,-1108 # 80013c50 <__fsym_mkdir_name+0x98>
    8000e0ac:	941f80ef          	jal	ra,800069ec <rt_kprintf>
    8000e0b0:	00005517          	auipc	a0,0x5
    8000e0b4:	b6050513          	addi	a0,a0,-1184 # 80012c10 <__FUNCTION__.6+0x28>
    8000e0b8:	935f80ef          	jal	ra,800069ec <rt_kprintf>
    8000e0bc:	02813083          	ld	ra,40(sp)
    8000e0c0:	02013403          	ld	s0,32(sp)
    8000e0c4:	01813483          	ld	s1,24(sp)
    8000e0c8:	01013903          	ld	s2,16(sp)
    8000e0cc:	00813983          	ld	s3,8(sp)
    8000e0d0:	fff00513          	li	a0,-1
    8000e0d4:	03010113          	addi	sp,sp,48
    8000e0d8:	00008067          	ret
    8000e0dc:	00050493          	mv	s1,a0
    8000e0e0:	00058513          	mv	a0,a1
    8000e0e4:	d98f70ef          	jal	ra,8000567c <rt_device_find>
    8000e0e8:	00050993          	mv	s3,a0
    8000e0ec:	fa0500e3          	beqz	a0,8000e08c <dfs_mkfs+0x20>
    8000e0f0:	f51fd0ef          	jal	ra,8000c040 <dfs_lock>
    8000e0f4:	00019917          	auipc	s2,0x19
    8000e0f8:	85c90913          	addi	s2,s2,-1956 # 80026950 <filesystem_operation_table>
    8000e0fc:	00093783          	ld	a5,0(s2)
    8000e100:	06078263          	beqz	a5,8000e164 <dfs_mkfs+0xf8>
    8000e104:	0007b503          	ld	a0,0(a5)
    8000e108:	00048593          	mv	a1,s1
    8000e10c:	a49f50ef          	jal	ra,80003b54 <strcmp>
    8000e110:	00050413          	mv	s0,a0
    8000e114:	04051863          	bnez	a0,8000e164 <dfs_mkfs+0xf8>
    8000e118:	f95fd0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000e11c:	00341413          	slli	s0,s0,0x3
    8000e120:	00890433          	add	s0,s2,s0
    8000e124:	00043783          	ld	a5,0(s0)
    8000e128:	0287b783          	ld	a5,40(a5)
    8000e12c:	06079e63          	bnez	a5,8000e1a8 <dfs_mkfs+0x13c>
    8000e130:	00005517          	auipc	a0,0x5
    8000e134:	74850513          	addi	a0,a0,1864 # 80013878 <__fsym_hello_name+0xc8>
    8000e138:	8b5f80ef          	jal	ra,800069ec <rt_kprintf>
    8000e13c:	00048593          	mv	a1,s1
    8000e140:	00006517          	auipc	a0,0x6
    8000e144:	b5050513          	addi	a0,a0,-1200 # 80013c90 <__fsym_mkdir_name+0xd8>
    8000e148:	8a5f80ef          	jal	ra,800069ec <rt_kprintf>
    8000e14c:	00005517          	auipc	a0,0x5
    8000e150:	ac450513          	addi	a0,a0,-1340 # 80012c10 <__FUNCTION__.6+0x28>
    8000e154:	899f80ef          	jal	ra,800069ec <rt_kprintf>
    8000e158:	fda00513          	li	a0,-38
    8000e15c:	e75f70ef          	jal	ra,80005fd0 <rt_set_errno>
    8000e160:	f5dff06f          	j	8000e0bc <dfs_mkfs+0x50>
    8000e164:	00893783          	ld	a5,8(s2)
    8000e168:	02078063          	beqz	a5,8000e188 <dfs_mkfs+0x11c>
    8000e16c:	0007b503          	ld	a0,0(a5)
    8000e170:	00048593          	mv	a1,s1
    8000e174:	9e1f50ef          	jal	ra,80003b54 <strcmp>
    8000e178:	00051863          	bnez	a0,8000e188 <dfs_mkfs+0x11c>
    8000e17c:	f31fd0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000e180:	00100413          	li	s0,1
    8000e184:	f99ff06f          	j	8000e11c <dfs_mkfs+0xb0>
    8000e188:	f25fd0ef          	jal	ra,8000c0ac <dfs_unlock>
    8000e18c:	00005517          	auipc	a0,0x5
    8000e190:	6ec50513          	addi	a0,a0,1772 # 80013878 <__fsym_hello_name+0xc8>
    8000e194:	859f80ef          	jal	ra,800069ec <rt_kprintf>
    8000e198:	00048593          	mv	a1,s1
    8000e19c:	00006517          	auipc	a0,0x6
    8000e1a0:	ad450513          	addi	a0,a0,-1324 # 80013c70 <__fsym_mkdir_name+0xb8>
    8000e1a4:	f09ff06f          	j	8000e0ac <dfs_mkfs+0x40>
    8000e1a8:	02013403          	ld	s0,32(sp)
    8000e1ac:	02813083          	ld	ra,40(sp)
    8000e1b0:	01813483          	ld	s1,24(sp)
    8000e1b4:	01013903          	ld	s2,16(sp)
    8000e1b8:	00098513          	mv	a0,s3
    8000e1bc:	00813983          	ld	s3,8(sp)
    8000e1c0:	03010113          	addi	sp,sp,48
    8000e1c4:	00078067          	jr	a5

000000008000e1c8 <mkfs>:
    8000e1c8:	ea5ff06f          	j	8000e06c <dfs_mkfs>

000000008000e1cc <dfs_statfs>:
    8000e1cc:	fe010113          	addi	sp,sp,-32
    8000e1d0:	00113c23          	sd	ra,24(sp)
    8000e1d4:	00b13423          	sd	a1,8(sp)
    8000e1d8:	a09ff0ef          	jal	ra,8000dbe0 <dfs_filesystem_lookup>
    8000e1dc:	02050063          	beqz	a0,8000e1fc <dfs_statfs+0x30>
    8000e1e0:	01053783          	ld	a5,16(a0)
    8000e1e4:	0307b783          	ld	a5,48(a5)
    8000e1e8:	00078a63          	beqz	a5,8000e1fc <dfs_statfs+0x30>
    8000e1ec:	00813583          	ld	a1,8(sp)
    8000e1f0:	01813083          	ld	ra,24(sp)
    8000e1f4:	02010113          	addi	sp,sp,32
    8000e1f8:	00078067          	jr	a5
    8000e1fc:	01813083          	ld	ra,24(sp)
    8000e200:	fff00513          	li	a0,-1
    8000e204:	02010113          	addi	sp,sp,32
    8000e208:	00008067          	ret

000000008000e20c <df>:
    8000e20c:	fc010113          	addi	sp,sp,-64
    8000e210:	00006797          	auipc	a5,0x6
    8000e214:	9b078793          	addi	a5,a5,-1616 # 80013bc0 <__fsym_mkdir_name+0x8>
    8000e218:	00f13c23          	sd	a5,24(sp)
    8000e21c:	00006797          	auipc	a5,0x6
    8000e220:	9ac78793          	addi	a5,a5,-1620 # 80013bc8 <__fsym_mkdir_name+0x10>
    8000e224:	02f13023          	sd	a5,32(sp)
    8000e228:	00010593          	mv	a1,sp
    8000e22c:	00006797          	auipc	a5,0x6
    8000e230:	9a478793          	addi	a5,a5,-1628 # 80013bd0 <__fsym_mkdir_name+0x18>
    8000e234:	02113c23          	sd	ra,56(sp)
    8000e238:	02813823          	sd	s0,48(sp)
    8000e23c:	02f13423          	sd	a5,40(sp)
    8000e240:	f8dff0ef          	jal	ra,8000e1cc <dfs_statfs>
    8000e244:	02050463          	beqz	a0,8000e26c <df+0x60>
    8000e248:	00006517          	auipc	a0,0x6
    8000e24c:	a8050513          	addi	a0,a0,-1408 # 80013cc8 <__fsym_mkdir_name+0x110>
    8000e250:	f9cf80ef          	jal	ra,800069ec <rt_kprintf>
    8000e254:	fff00413          	li	s0,-1
    8000e258:	03813083          	ld	ra,56(sp)
    8000e25c:	00040513          	mv	a0,s0
    8000e260:	03013403          	ld	s0,48(sp)
    8000e264:	04010113          	addi	sp,sp,64
    8000e268:	00008067          	ret
    8000e26c:	00013783          	ld	a5,0(sp)
    8000e270:	01013703          	ld	a4,16(sp)
    8000e274:	40000593          	li	a1,1024
    8000e278:	00100637          	lui	a2,0x100
    8000e27c:	02e786b3          	mul	a3,a5,a4
    8000e280:	00050413          	mv	s0,a0
    8000e284:	02b6c5b3          	div	a1,a3,a1
    8000e288:	06c6c263          	blt	a3,a2,8000e2ec <df+0xe0>
    8000e28c:	40a5d693          	srai	a3,a1,0xa
    8000e290:	3ff00613          	li	a2,1023
    8000e294:	02d64e63          	blt	a2,a3,8000e2d0 <df+0xc4>
    8000e298:	3ff5f593          	andi	a1,a1,1023
    8000e29c:	00a00613          	li	a2,10
    8000e2a0:	02c58633          	mul	a2,a1,a2
    8000e2a4:	00068593          	mv	a1,a3
    8000e2a8:	00100693          	li	a3,1
    8000e2ac:	00a65613          	srli	a2,a2,0xa
    8000e2b0:	00369693          	slli	a3,a3,0x3
    8000e2b4:	03068693          	addi	a3,a3,48 # 4000030 <__STACKSIZE__+0x3ffc030>
    8000e2b8:	002686b3          	add	a3,a3,sp
    8000e2bc:	fe86b683          	ld	a3,-24(a3)
    8000e2c0:	00006517          	auipc	a0,0x6
    8000e2c4:	a2050513          	addi	a0,a0,-1504 # 80013ce0 <__fsym_mkdir_name+0x128>
    8000e2c8:	f24f80ef          	jal	ra,800069ec <rt_kprintf>
    8000e2cc:	f8dff06f          	j	8000e258 <df+0x4c>
    8000e2d0:	3ff6f613          	andi	a2,a3,1023
    8000e2d4:	00a00693          	li	a3,10
    8000e2d8:	02d60633          	mul	a2,a2,a3
    8000e2dc:	4145d593          	srai	a1,a1,0x14
    8000e2e0:	00200693          	li	a3,2
    8000e2e4:	00a65613          	srli	a2,a2,0xa
    8000e2e8:	fc9ff06f          	j	8000e2b0 <df+0xa4>
    8000e2ec:	00000693          	li	a3,0
    8000e2f0:	00000613          	li	a2,0
    8000e2f4:	fbdff06f          	j	8000e2b0 <df+0xa4>

000000008000e2f8 <dfs_romfs_mount>:
    8000e2f8:	00060863          	beqz	a2,8000e308 <dfs_romfs_mount+0x10>
    8000e2fc:	00c53c23          	sd	a2,24(a0)
    8000e300:	00000513          	li	a0,0
    8000e304:	00008067          	ret
    8000e308:	ffb00513          	li	a0,-5
    8000e30c:	00008067          	ret

000000008000e310 <dfs_romfs_unmount>:
    8000e310:	00000513          	li	a0,0
    8000e314:	00008067          	ret

000000008000e318 <dfs_romfs_ioctl>:
    8000e318:	ffb00513          	li	a0,-5
    8000e31c:	00008067          	ret

000000008000e320 <check_dirent>:
    8000e320:	00052703          	lw	a4,0(a0)
    8000e324:	00100793          	li	a5,1
    8000e328:	00e7ec63          	bltu	a5,a4,8000e340 <check_dirent+0x20>
    8000e32c:	01853503          	ld	a0,24(a0)
    8000e330:	00150513          	addi	a0,a0,1
    8000e334:	00153513          	seqz	a0,a0
    8000e338:	40a00533          	neg	a0,a0
    8000e33c:	00008067          	ret
    8000e340:	fff00513          	li	a0,-1
    8000e344:	00008067          	ret

000000008000e348 <dfs_romfs_lseek>:
    8000e348:	03053783          	ld	a5,48(a0)
    8000e34c:	00b7e863          	bltu	a5,a1,8000e35c <dfs_romfs_lseek+0x14>
    8000e350:	02b53c23          	sd	a1,56(a0)
    8000e354:	0005851b          	sext.w	a0,a1
    8000e358:	00008067          	ret
    8000e35c:	ffb00513          	li	a0,-5
    8000e360:	00008067          	ret

000000008000e364 <dfs_romfs_close>:
    8000e364:	04053023          	sd	zero,64(a0)
    8000e368:	00000513          	li	a0,0
    8000e36c:	00008067          	ret

000000008000e370 <dfs_romfs_read>:
    8000e370:	fd010113          	addi	sp,sp,-48
    8000e374:	01413023          	sd	s4,0(sp)
    8000e378:	04053a03          	ld	s4,64(a0)
    8000e37c:	00913c23          	sd	s1,24(sp)
    8000e380:	01213823          	sd	s2,16(sp)
    8000e384:	01313423          	sd	s3,8(sp)
    8000e388:	02113423          	sd	ra,40(sp)
    8000e38c:	02813023          	sd	s0,32(sp)
    8000e390:	00050493          	mv	s1,a0
    8000e394:	00058993          	mv	s3,a1
    8000e398:	00060913          	mv	s2,a2
    8000e39c:	000a1e63          	bnez	s4,8000e3b8 <dfs_romfs_read+0x48>
    8000e3a0:	08900613          	li	a2,137
    8000e3a4:	00006597          	auipc	a1,0x6
    8000e3a8:	a1c58593          	addi	a1,a1,-1508 # 80013dc0 <__FUNCTION__.1>
    8000e3ac:	00006517          	auipc	a0,0x6
    8000e3b0:	9bc50513          	addi	a0,a0,-1604 # 80013d68 <__fsym_mkfs_name+0x8>
    8000e3b4:	fc0f80ef          	jal	ra,80006b74 <rt_assert_handler>
    8000e3b8:	000a0513          	mv	a0,s4
    8000e3bc:	f65ff0ef          	jal	ra,8000e320 <check_dirent>
    8000e3c0:	ffb00413          	li	s0,-5
    8000e3c4:	04051063          	bnez	a0,8000e404 <dfs_romfs_read+0x94>
    8000e3c8:	0384b783          	ld	a5,56(s1)
    8000e3cc:	0304b403          	ld	s0,48(s1)
    8000e3d0:	40f40433          	sub	s0,s0,a5
    8000e3d4:	00897463          	bgeu	s2,s0,8000e3dc <dfs_romfs_read+0x6c>
    8000e3d8:	00090413          	mv	s0,s2
    8000e3dc:	00040c63          	beqz	s0,8000e3f4 <dfs_romfs_read+0x84>
    8000e3e0:	010a3583          	ld	a1,16(s4)
    8000e3e4:	00040613          	mv	a2,s0
    8000e3e8:	00098513          	mv	a0,s3
    8000e3ec:	00f585b3          	add	a1,a1,a5
    8000e3f0:	f70f50ef          	jal	ra,80003b60 <memcpy>
    8000e3f4:	0384b783          	ld	a5,56(s1)
    8000e3f8:	008787b3          	add	a5,a5,s0
    8000e3fc:	02f4bc23          	sd	a5,56(s1)
    8000e400:	0004041b          	sext.w	s0,s0
    8000e404:	02813083          	ld	ra,40(sp)
    8000e408:	00040513          	mv	a0,s0
    8000e40c:	02013403          	ld	s0,32(sp)
    8000e410:	01813483          	ld	s1,24(sp)
    8000e414:	01013903          	ld	s2,16(sp)
    8000e418:	00813983          	ld	s3,8(sp)
    8000e41c:	00013a03          	ld	s4,0(sp)
    8000e420:	03010113          	addi	sp,sp,48
    8000e424:	00008067          	ret

000000008000e428 <dfs_romfs_getdents>:
    8000e428:	fb010113          	addi	sp,sp,-80
    8000e42c:	03213823          	sd	s2,48(sp)
    8000e430:	04053903          	ld	s2,64(a0)
    8000e434:	02913c23          	sd	s1,56(sp)
    8000e438:	00050493          	mv	s1,a0
    8000e43c:	00090513          	mv	a0,s2
    8000e440:	04813023          	sd	s0,64(sp)
    8000e444:	03313423          	sd	s3,40(sp)
    8000e448:	04113423          	sd	ra,72(sp)
    8000e44c:	03413023          	sd	s4,32(sp)
    8000e450:	01513c23          	sd	s5,24(sp)
    8000e454:	01613823          	sd	s6,16(sp)
    8000e458:	00058413          	mv	s0,a1
    8000e45c:	00060993          	mv	s3,a2
    8000e460:	ec1ff0ef          	jal	ra,8000e320 <check_dirent>
    8000e464:	0e051a63          	bnez	a0,8000e558 <dfs_romfs_getdents+0x130>
    8000e468:	00092703          	lw	a4,0(s2)
    8000e46c:	00100793          	li	a5,1
    8000e470:	00f70e63          	beq	a4,a5,8000e48c <dfs_romfs_getdents+0x64>
    8000e474:	0fd00613          	li	a2,253
    8000e478:	00006597          	auipc	a1,0x6
    8000e47c:	93058593          	addi	a1,a1,-1744 # 80013da8 <__FUNCTION__.0>
    8000e480:	00006517          	auipc	a0,0x6
    8000e484:	8f850513          	addi	a0,a0,-1800 # 80013d78 <__fsym_mkfs_name+0x18>
    8000e488:	eecf80ef          	jal	ra,80006b74 <rt_assert_handler>
    8000e48c:	01093a83          	ld	s5,16(s2)
    8000e490:	10300793          	li	a5,259
    8000e494:	10400913          	li	s2,260
    8000e498:	0329d93b          	divuw	s2,s3,s2
    8000e49c:	fea00513          	li	a0,-22
    8000e4a0:	0337f463          	bgeu	a5,s3,8000e4c8 <dfs_romfs_getdents+0xa0>
    8000e4a4:	02091913          	slli	s2,s2,0x20
    8000e4a8:	00440413          	addi	s0,s0,4
    8000e4ac:	00000993          	li	s3,0
    8000e4b0:	02095913          	srli	s2,s2,0x20
    8000e4b4:	00100b13          	li	s6,1
    8000e4b8:	10400a13          	li	s4,260
    8000e4bc:	0329ea63          	bltu	s3,s2,8000e4f0 <dfs_romfs_getdents+0xc8>
    8000e4c0:	10400513          	li	a0,260
    8000e4c4:	0335053b          	mulw	a0,a0,s3
    8000e4c8:	04813083          	ld	ra,72(sp)
    8000e4cc:	04013403          	ld	s0,64(sp)
    8000e4d0:	03813483          	ld	s1,56(sp)
    8000e4d4:	03013903          	ld	s2,48(sp)
    8000e4d8:	02813983          	ld	s3,40(sp)
    8000e4dc:	02013a03          	ld	s4,32(sp)
    8000e4e0:	01813a83          	ld	s5,24(sp)
    8000e4e4:	01013b03          	ld	s6,16(sp)
    8000e4e8:	05010113          	addi	sp,sp,80
    8000e4ec:	00008067          	ret
    8000e4f0:	0384b783          	ld	a5,56(s1)
    8000e4f4:	0304b703          	ld	a4,48(s1)
    8000e4f8:	fce7f4e3          	bgeu	a5,a4,8000e4c0 <dfs_romfs_getdents+0x98>
    8000e4fc:	00579793          	slli	a5,a5,0x5
    8000e500:	00fa87b3          	add	a5,s5,a5
    8000e504:	0007a703          	lw	a4,0(a5)
    8000e508:	0087b583          	ld	a1,8(a5)
    8000e50c:	00200793          	li	a5,2
    8000e510:	01670463          	beq	a4,s6,8000e518 <dfs_romfs_getdents+0xf0>
    8000e514:	00100793          	li	a5,1
    8000e518:	fef40e23          	sb	a5,-4(s0)
    8000e51c:	00058513          	mv	a0,a1
    8000e520:	00b13423          	sd	a1,8(sp)
    8000e524:	dd9f70ef          	jal	ra,800062fc <rt_strlen>
    8000e528:	00813583          	ld	a1,8(sp)
    8000e52c:	fea40ea3          	sb	a0,-3(s0)
    8000e530:	ff441f23          	sh	s4,-2(s0)
    8000e534:	00040513          	mv	a0,s0
    8000e538:	10000613          	li	a2,256
    8000e53c:	d19f70ef          	jal	ra,80006254 <rt_strncpy>
    8000e540:	0384b783          	ld	a5,56(s1)
    8000e544:	00198993          	addi	s3,s3,1
    8000e548:	10440413          	addi	s0,s0,260
    8000e54c:	00178793          	addi	a5,a5,1
    8000e550:	02f4bc23          	sd	a5,56(s1)
    8000e554:	f69ff06f          	j	8000e4bc <dfs_romfs_getdents+0x94>
    8000e558:	ffb00513          	li	a0,-5
    8000e55c:	f6dff06f          	j	8000e4c8 <dfs_romfs_getdents+0xa0>

000000008000e560 <dfs_romfs_init>:
    8000e560:	ff010113          	addi	sp,sp,-16
    8000e564:	00006517          	auipc	a0,0x6
    8000e568:	8b450513          	addi	a0,a0,-1868 # 80013e18 <_romfs>
    8000e56c:	00113423          	sd	ra,8(sp)
    8000e570:	d98ff0ef          	jal	ra,8000db08 <dfs_register>
    8000e574:	00813083          	ld	ra,8(sp)
    8000e578:	00000513          	li	a0,0
    8000e57c:	01010113          	addi	sp,sp,16
    8000e580:	00008067          	ret

000000008000e584 <dfs_romfs_lookup>:
    8000e584:	fa010113          	addi	sp,sp,-96
    8000e588:	04813823          	sd	s0,80(sp)
    8000e58c:	03313c23          	sd	s3,56(sp)
    8000e590:	03513423          	sd	s5,40(sp)
    8000e594:	04113c23          	sd	ra,88(sp)
    8000e598:	04913423          	sd	s1,72(sp)
    8000e59c:	05213023          	sd	s2,64(sp)
    8000e5a0:	03413823          	sd	s4,48(sp)
    8000e5a4:	03613023          	sd	s6,32(sp)
    8000e5a8:	01713c23          	sd	s7,24(sp)
    8000e5ac:	01813823          	sd	s8,16(sp)
    8000e5b0:	01913423          	sd	s9,8(sp)
    8000e5b4:	00050993          	mv	s3,a0
    8000e5b8:	00058413          	mv	s0,a1
    8000e5bc:	00060a93          	mv	s5,a2
    8000e5c0:	d61ff0ef          	jal	ra,8000e320 <check_dirent>
    8000e5c4:	04050063          	beqz	a0,8000e604 <dfs_romfs_lookup+0x80>
    8000e5c8:	00000993          	li	s3,0
    8000e5cc:	05813083          	ld	ra,88(sp)
    8000e5d0:	05013403          	ld	s0,80(sp)
    8000e5d4:	04813483          	ld	s1,72(sp)
    8000e5d8:	04013903          	ld	s2,64(sp)
    8000e5dc:	03013a03          	ld	s4,48(sp)
    8000e5e0:	02813a83          	ld	s5,40(sp)
    8000e5e4:	02013b03          	ld	s6,32(sp)
    8000e5e8:	01813b83          	ld	s7,24(sp)
    8000e5ec:	01013c03          	ld	s8,16(sp)
    8000e5f0:	00813c83          	ld	s9,8(sp)
    8000e5f4:	00098513          	mv	a0,s3
    8000e5f8:	03813983          	ld	s3,56(sp)
    8000e5fc:	06010113          	addi	sp,sp,96
    8000e600:	00008067          	ret
    8000e604:	00044703          	lbu	a4,0(s0)
    8000e608:	02f00793          	li	a5,47
    8000e60c:	0189ba03          	ld	s4,24(s3)
    8000e610:	00f71a63          	bne	a4,a5,8000e624 <dfs_romfs_lookup+0xa0>
    8000e614:	00144783          	lbu	a5,1(s0)
    8000e618:	00079663          	bnez	a5,8000e624 <dfs_romfs_lookup+0xa0>
    8000e61c:	014ab023          	sd	s4,0(s5)
    8000e620:	fadff06f          	j	8000e5cc <dfs_romfs_lookup+0x48>
    8000e624:	0109b483          	ld	s1,16(s3)
    8000e628:	02f00793          	li	a5,47
    8000e62c:	00044703          	lbu	a4,0(s0)
    8000e630:	02f70263          	beq	a4,a5,8000e654 <dfs_romfs_lookup+0xd0>
    8000e634:	00040913          	mv	s2,s0
    8000e638:	02f00713          	li	a4,47
    8000e63c:	00094783          	lbu	a5,0(s2)
    8000e640:	00e78463          	beq	a5,a4,8000e648 <dfs_romfs_lookup+0xc4>
    8000e644:	00079c63          	bnez	a5,8000e65c <dfs_romfs_lookup+0xd8>
    8000e648:	02f00c13          	li	s8,47
    8000e64c:	00100c93          	li	s9,1
    8000e650:	0900006f          	j	8000e6e0 <dfs_romfs_lookup+0x15c>
    8000e654:	00140413          	addi	s0,s0,1
    8000e658:	fd5ff06f          	j	8000e62c <dfs_romfs_lookup+0xa8>
    8000e65c:	00190913          	addi	s2,s2,1
    8000e660:	fddff06f          	j	8000e63c <dfs_romfs_lookup+0xb8>
    8000e664:	00140413          	addi	s0,s0,1
    8000e668:	0500006f          	j	8000e6b8 <dfs_romfs_lookup+0x134>
    8000e66c:	00190913          	addi	s2,s2,1
    8000e670:	0540006f          	j	8000e6c4 <dfs_romfs_lookup+0x140>
    8000e674:	001b0b13          	addi	s6,s6,1
    8000e678:	02048493          	addi	s1,s1,32
    8000e67c:	f54b06e3          	beq	s6,s4,8000e5c8 <dfs_romfs_lookup+0x44>
    8000e680:	00048513          	mv	a0,s1
    8000e684:	00048993          	mv	s3,s1
    8000e688:	c99ff0ef          	jal	ra,8000e320 <check_dirent>
    8000e68c:	f2051ee3          	bnez	a0,8000e5c8 <dfs_romfs_lookup+0x44>
    8000e690:	0084b503          	ld	a0,8(s1)
    8000e694:	c69f70ef          	jal	ra,800062fc <rt_strlen>
    8000e698:	fd751ee3          	bne	a0,s7,8000e674 <dfs_romfs_lookup+0xf0>
    8000e69c:	0084b503          	ld	a0,8(s1)
    8000e6a0:	000b8613          	mv	a2,s7
    8000e6a4:	00040593          	mv	a1,s0
    8000e6a8:	bf1f70ef          	jal	ra,80006298 <rt_strncmp>
    8000e6ac:	fc0514e3          	bnez	a0,8000e674 <dfs_romfs_lookup+0xf0>
    8000e6b0:	0184ba03          	ld	s4,24(s1)
    8000e6b4:	00090413          	mv	s0,s2
    8000e6b8:	00044783          	lbu	a5,0(s0)
    8000e6bc:	fb8784e3          	beq	a5,s8,8000e664 <dfs_romfs_lookup+0xe0>
    8000e6c0:	00040913          	mv	s2,s0
    8000e6c4:	00094703          	lbu	a4,0(s2)
    8000e6c8:	01870463          	beq	a4,s8,8000e6d0 <dfs_romfs_lookup+0x14c>
    8000e6cc:	fa0710e3          	bnez	a4,8000e66c <dfs_romfs_lookup+0xe8>
    8000e6d0:	f40786e3          	beqz	a5,8000e61c <dfs_romfs_lookup+0x98>
    8000e6d4:	0004a783          	lw	a5,0(s1)
    8000e6d8:	ef9798e3          	bne	a5,s9,8000e5c8 <dfs_romfs_lookup+0x44>
    8000e6dc:	0104b483          	ld	s1,16(s1)
    8000e6e0:	ee0484e3          	beqz	s1,8000e5c8 <dfs_romfs_lookup+0x44>
    8000e6e4:	00000b13          	li	s6,0
    8000e6e8:	40890bb3          	sub	s7,s2,s0
    8000e6ec:	f91ff06f          	j	8000e67c <dfs_romfs_lookup+0xf8>

000000008000e6f0 <dfs_romfs_open>:
    8000e6f0:	04053783          	ld	a5,64(a0)
    8000e6f4:	fd010113          	addi	sp,sp,-48
    8000e6f8:	01213823          	sd	s2,16(sp)
    8000e6fc:	0187b903          	ld	s2,24(a5)
    8000e700:	00913c23          	sd	s1,24(sp)
    8000e704:	00050493          	mv	s1,a0
    8000e708:	00090513          	mv	a0,s2
    8000e70c:	02813023          	sd	s0,32(sp)
    8000e710:	02113423          	sd	ra,40(sp)
    8000e714:	c0dff0ef          	jal	ra,8000e320 <check_dirent>
    8000e718:	ffb00413          	li	s0,-5
    8000e71c:	06051263          	bnez	a0,8000e780 <dfs_romfs_open+0x90>
    8000e720:	0284a783          	lw	a5,40(s1)
    8000e724:	fea00413          	li	s0,-22
    8000e728:	6437f793          	andi	a5,a5,1603
    8000e72c:	04079a63          	bnez	a5,8000e780 <dfs_romfs_open+0x90>
    8000e730:	0084b583          	ld	a1,8(s1)
    8000e734:	00050413          	mv	s0,a0
    8000e738:	00810613          	addi	a2,sp,8
    8000e73c:	00090513          	mv	a0,s2
    8000e740:	e45ff0ef          	jal	ra,8000e584 <dfs_romfs_lookup>
    8000e744:	02050063          	beqz	a0,8000e764 <dfs_romfs_open+0x74>
    8000e748:	0284a783          	lw	a5,40(s1)
    8000e74c:	00052683          	lw	a3,0(a0)
    8000e750:	00010737          	lui	a4,0x10
    8000e754:	00e7f7b3          	and	a5,a5,a4
    8000e758:	00100713          	li	a4,1
    8000e75c:	00e69863          	bne	a3,a4,8000e76c <dfs_romfs_open+0x7c>
    8000e760:	00079863          	bnez	a5,8000e770 <dfs_romfs_open+0x80>
    8000e764:	ffe00413          	li	s0,-2
    8000e768:	0180006f          	j	8000e780 <dfs_romfs_open+0x90>
    8000e76c:	fe079ce3          	bnez	a5,8000e764 <dfs_romfs_open+0x74>
    8000e770:	00813783          	ld	a5,8(sp)
    8000e774:	04a4b023          	sd	a0,64(s1)
    8000e778:	0204bc23          	sd	zero,56(s1)
    8000e77c:	02f4b823          	sd	a5,48(s1)
    8000e780:	02813083          	ld	ra,40(sp)
    8000e784:	00040513          	mv	a0,s0
    8000e788:	02013403          	ld	s0,32(sp)
    8000e78c:	01813483          	ld	s1,24(sp)
    8000e790:	01013903          	ld	s2,16(sp)
    8000e794:	03010113          	addi	sp,sp,48
    8000e798:	00008067          	ret

000000008000e79c <dfs_romfs_stat>:
    8000e79c:	01853503          	ld	a0,24(a0)
    8000e7a0:	fe010113          	addi	sp,sp,-32
    8000e7a4:	00813823          	sd	s0,16(sp)
    8000e7a8:	00060413          	mv	s0,a2
    8000e7ac:	00810613          	addi	a2,sp,8
    8000e7b0:	00113c23          	sd	ra,24(sp)
    8000e7b4:	dd1ff0ef          	jal	ra,8000e584 <dfs_romfs_lookup>
    8000e7b8:	04050663          	beqz	a0,8000e804 <dfs_romfs_stat+0x68>
    8000e7bc:	000087b7          	lui	a5,0x8
    8000e7c0:	00052703          	lw	a4,0(a0)
    8000e7c4:	1b678793          	addi	a5,a5,438 # 81b6 <__STACKSIZE__+0x41b6>
    8000e7c8:	00f42823          	sw	a5,16(s0)
    8000e7cc:	00043023          	sd	zero,0(s0)
    8000e7d0:	00100793          	li	a5,1
    8000e7d4:	00f71863          	bne	a4,a5,8000e7e4 <dfs_romfs_stat+0x48>
    8000e7d8:	000047b7          	lui	a5,0x4
    8000e7dc:	1ff78793          	addi	a5,a5,511 # 41ff <__STACKSIZE__+0x1ff>
    8000e7e0:	00f42823          	sw	a5,16(s0)
    8000e7e4:	01853783          	ld	a5,24(a0)
    8000e7e8:	04043c23          	sd	zero,88(s0)
    8000e7ec:	00000513          	li	a0,0
    8000e7f0:	02f43823          	sd	a5,48(s0)
    8000e7f4:	01813083          	ld	ra,24(sp)
    8000e7f8:	01013403          	ld	s0,16(sp)
    8000e7fc:	02010113          	addi	sp,sp,32
    8000e800:	00008067          	ret
    8000e804:	ffe00513          	li	a0,-2
    8000e808:	fedff06f          	j	8000e7f4 <dfs_romfs_stat+0x58>

000000008000e80c <dfs_device_fs_mount>:
    8000e80c:	00000513          	li	a0,0
    8000e810:	00008067          	ret

000000008000e814 <dfs_device_fs_poll>:
    8000e814:	00000513          	li	a0,0
    8000e818:	00008067          	ret

000000008000e81c <dfs_device_fs_ioctl>:
    8000e81c:	fe010113          	addi	sp,sp,-32
    8000e820:	00813823          	sd	s0,16(sp)
    8000e824:	00913423          	sd	s1,8(sp)
    8000e828:	01213023          	sd	s2,0(sp)
    8000e82c:	00113c23          	sd	ra,24(sp)
    8000e830:	00050413          	mv	s0,a0
    8000e834:	00058493          	mv	s1,a1
    8000e838:	00060913          	mv	s2,a2
    8000e83c:	00051e63          	bnez	a0,8000e858 <dfs_device_fs_ioctl+0x3c>
    8000e840:	02500613          	li	a2,37
    8000e844:	00005597          	auipc	a1,0x5
    8000e848:	6dc58593          	addi	a1,a1,1756 # 80013f20 <__FUNCTION__.5>
    8000e84c:	00005517          	auipc	a0,0x5
    8000e850:	61c50513          	addi	a0,a0,1564 # 80013e68 <_romfs+0x50>
    8000e854:	b20f80ef          	jal	ra,80006b74 <rt_assert_handler>
    8000e858:	04043403          	ld	s0,64(s0)
    8000e85c:	00041e63          	bnez	s0,8000e878 <dfs_device_fs_ioctl+0x5c>
    8000e860:	02900613          	li	a2,41
    8000e864:	00005597          	auipc	a1,0x5
    8000e868:	6bc58593          	addi	a1,a1,1724 # 80013f20 <__FUNCTION__.5>
    8000e86c:	00005517          	auipc	a0,0x5
    8000e870:	60c50513          	addi	a0,a0,1548 # 80013e78 <_romfs+0x60>
    8000e874:	b00f80ef          	jal	ra,80006b74 <rt_assert_handler>
    8000e878:	00090613          	mv	a2,s2
    8000e87c:	00048593          	mv	a1,s1
    8000e880:	00040513          	mv	a0,s0
    8000e884:	a24f70ef          	jal	ra,80005aa8 <rt_device_control>
    8000e888:	01813083          	ld	ra,24(sp)
    8000e88c:	01013403          	ld	s0,16(sp)
    8000e890:	00813483          	ld	s1,8(sp)
    8000e894:	00013903          	ld	s2,0(sp)
    8000e898:	0005051b          	sext.w	a0,a0
    8000e89c:	02010113          	addi	sp,sp,32
    8000e8a0:	00008067          	ret

000000008000e8a4 <dfs_device_fs_read>:
    8000e8a4:	fd010113          	addi	sp,sp,-48
    8000e8a8:	02813023          	sd	s0,32(sp)
    8000e8ac:	00913c23          	sd	s1,24(sp)
    8000e8b0:	01213823          	sd	s2,16(sp)
    8000e8b4:	02113423          	sd	ra,40(sp)
    8000e8b8:	01313423          	sd	s3,8(sp)
    8000e8bc:	00050413          	mv	s0,a0
    8000e8c0:	00058493          	mv	s1,a1
    8000e8c4:	00060913          	mv	s2,a2
    8000e8c8:	00051e63          	bnez	a0,8000e8e4 <dfs_device_fs_read+0x40>
    8000e8cc:	03800613          	li	a2,56
    8000e8d0:	00005597          	auipc	a1,0x5
    8000e8d4:	63858593          	addi	a1,a1,1592 # 80013f08 <__FUNCTION__.4>
    8000e8d8:	00005517          	auipc	a0,0x5
    8000e8dc:	59050513          	addi	a0,a0,1424 # 80013e68 <_romfs+0x50>
    8000e8e0:	a94f80ef          	jal	ra,80006b74 <rt_assert_handler>
    8000e8e4:	04043983          	ld	s3,64(s0)
    8000e8e8:	00099e63          	bnez	s3,8000e904 <dfs_device_fs_read+0x60>
    8000e8ec:	03c00613          	li	a2,60
    8000e8f0:	00005597          	auipc	a1,0x5
    8000e8f4:	61858593          	addi	a1,a1,1560 # 80013f08 <__FUNCTION__.4>
    8000e8f8:	00005517          	auipc	a0,0x5
    8000e8fc:	58050513          	addi	a0,a0,1408 # 80013e78 <_romfs+0x60>
    8000e900:	a74f80ef          	jal	ra,80006b74 <rt_assert_handler>
    8000e904:	03843583          	ld	a1,56(s0)
    8000e908:	00090693          	mv	a3,s2
    8000e90c:	00048613          	mv	a2,s1
    8000e910:	00098513          	mv	a0,s3
    8000e914:	fedf60ef          	jal	ra,80005900 <rt_device_read>
    8000e918:	03843783          	ld	a5,56(s0)
    8000e91c:	0005051b          	sext.w	a0,a0
    8000e920:	02813083          	ld	ra,40(sp)
    8000e924:	00a787b3          	add	a5,a5,a0
    8000e928:	02f43c23          	sd	a5,56(s0)
    8000e92c:	02013403          	ld	s0,32(sp)
    8000e930:	01813483          	ld	s1,24(sp)
    8000e934:	01013903          	ld	s2,16(sp)
    8000e938:	00813983          	ld	s3,8(sp)
    8000e93c:	03010113          	addi	sp,sp,48
    8000e940:	00008067          	ret

000000008000e944 <dfs_device_fs_write>:
    8000e944:	fd010113          	addi	sp,sp,-48
    8000e948:	02813023          	sd	s0,32(sp)
    8000e94c:	00913c23          	sd	s1,24(sp)
    8000e950:	01213823          	sd	s2,16(sp)
    8000e954:	02113423          	sd	ra,40(sp)
    8000e958:	01313423          	sd	s3,8(sp)
    8000e95c:	00050413          	mv	s0,a0
    8000e960:	00058493          	mv	s1,a1
    8000e964:	00060913          	mv	s2,a2
    8000e968:	00051e63          	bnez	a0,8000e984 <dfs_device_fs_write+0x40>
    8000e96c:	04a00613          	li	a2,74
    8000e970:	00005597          	auipc	a1,0x5
    8000e974:	58058593          	addi	a1,a1,1408 # 80013ef0 <__FUNCTION__.3>
    8000e978:	00005517          	auipc	a0,0x5
    8000e97c:	4f050513          	addi	a0,a0,1264 # 80013e68 <_romfs+0x50>
    8000e980:	9f4f80ef          	jal	ra,80006b74 <rt_assert_handler>
    8000e984:	04043983          	ld	s3,64(s0)
    8000e988:	00099e63          	bnez	s3,8000e9a4 <dfs_device_fs_write+0x60>
    8000e98c:	04e00613          	li	a2,78
    8000e990:	00005597          	auipc	a1,0x5
    8000e994:	56058593          	addi	a1,a1,1376 # 80013ef0 <__FUNCTION__.3>
    8000e998:	00005517          	auipc	a0,0x5
    8000e99c:	4e050513          	addi	a0,a0,1248 # 80013e78 <_romfs+0x60>
    8000e9a0:	9d4f80ef          	jal	ra,80006b74 <rt_assert_handler>
    8000e9a4:	03843583          	ld	a1,56(s0)
    8000e9a8:	00090693          	mv	a3,s2
    8000e9ac:	00048613          	mv	a2,s1
    8000e9b0:	00098513          	mv	a0,s3
    8000e9b4:	820f70ef          	jal	ra,800059d4 <rt_device_write>
    8000e9b8:	03843783          	ld	a5,56(s0)
    8000e9bc:	0005051b          	sext.w	a0,a0
    8000e9c0:	02813083          	ld	ra,40(sp)
    8000e9c4:	00a787b3          	add	a5,a5,a0
    8000e9c8:	02f43c23          	sd	a5,56(s0)
    8000e9cc:	02013403          	ld	s0,32(sp)
    8000e9d0:	01813483          	ld	s1,24(sp)
    8000e9d4:	01013903          	ld	s2,16(sp)
    8000e9d8:	00813983          	ld	s3,8(sp)
    8000e9dc:	03010113          	addi	sp,sp,48
    8000e9e0:	00008067          	ret

000000008000e9e4 <dfs_device_fs_close>:
    8000e9e4:	fe010113          	addi	sp,sp,-32
    8000e9e8:	00813823          	sd	s0,16(sp)
    8000e9ec:	00113c23          	sd	ra,24(sp)
    8000e9f0:	00913423          	sd	s1,8(sp)
    8000e9f4:	00050413          	mv	s0,a0
    8000e9f8:	00051e63          	bnez	a0,8000ea14 <dfs_device_fs_close+0x30>
    8000e9fc:	05c00613          	li	a2,92
    8000ea00:	00005597          	auipc	a1,0x5
    8000ea04:	4d858593          	addi	a1,a1,1240 # 80013ed8 <__FUNCTION__.2>
    8000ea08:	00005517          	auipc	a0,0x5
    8000ea0c:	46050513          	addi	a0,a0,1120 # 80013e68 <_romfs+0x50>
    8000ea10:	964f80ef          	jal	ra,80006b74 <rt_assert_handler>
    8000ea14:	00245703          	lhu	a4,2(s0)
    8000ea18:	00200793          	li	a5,2
    8000ea1c:	04043483          	ld	s1,64(s0)
    8000ea20:	04f71263          	bne	a4,a5,8000ea64 <dfs_device_fs_close+0x80>
    8000ea24:	00049e63          	bnez	s1,8000ea40 <dfs_device_fs_close+0x5c>
    8000ea28:	06300613          	li	a2,99
    8000ea2c:	00005597          	auipc	a1,0x5
    8000ea30:	4ac58593          	addi	a1,a1,1196 # 80013ed8 <__FUNCTION__.2>
    8000ea34:	00005517          	auipc	a0,0x5
    8000ea38:	45c50513          	addi	a0,a0,1116 # 80013e90 <_romfs+0x78>
    8000ea3c:	938f80ef          	jal	ra,80006b74 <rt_assert_handler>
    8000ea40:	00048513          	mv	a0,s1
    8000ea44:	82df60ef          	jal	ra,80005270 <rt_free>
    8000ea48:	00000793          	li	a5,0
    8000ea4c:	01813083          	ld	ra,24(sp)
    8000ea50:	01013403          	ld	s0,16(sp)
    8000ea54:	00813483          	ld	s1,8(sp)
    8000ea58:	00078513          	mv	a0,a5
    8000ea5c:	02010113          	addi	sp,sp,32
    8000ea60:	00008067          	ret
    8000ea64:	00049e63          	bnez	s1,8000ea80 <dfs_device_fs_close+0x9c>
    8000ea68:	06c00613          	li	a2,108
    8000ea6c:	00005597          	auipc	a1,0x5
    8000ea70:	46c58593          	addi	a1,a1,1132 # 80013ed8 <__FUNCTION__.2>
    8000ea74:	00005517          	auipc	a0,0x5
    8000ea78:	40450513          	addi	a0,a0,1028 # 80013e78 <_romfs+0x60>
    8000ea7c:	8f8f80ef          	jal	ra,80006b74 <rt_assert_handler>
    8000ea80:	00048513          	mv	a0,s1
    8000ea84:	dd1f60ef          	jal	ra,80005854 <rt_device_close>
    8000ea88:	ffb00793          	li	a5,-5
    8000ea8c:	fc0510e3          	bnez	a0,8000ea4c <dfs_device_fs_close+0x68>
    8000ea90:	04043023          	sd	zero,64(s0)
    8000ea94:	fb5ff06f          	j	8000ea48 <dfs_device_fs_close+0x64>

000000008000ea98 <dfs_device_fs_stat>:
    8000ea98:	0005c703          	lbu	a4,0(a1)
    8000ea9c:	ff010113          	addi	sp,sp,-16
    8000eaa0:	00813023          	sd	s0,0(sp)
    8000eaa4:	00113423          	sd	ra,8(sp)
    8000eaa8:	02f00793          	li	a5,47
    8000eaac:	00060413          	mv	s0,a2
    8000eab0:	02f71c63          	bne	a4,a5,8000eae8 <dfs_device_fs_stat+0x50>
    8000eab4:	0015c783          	lbu	a5,1(a1)
    8000eab8:	02079863          	bnez	a5,8000eae8 <dfs_device_fs_stat+0x50>
    8000eabc:	000047b7          	lui	a5,0x4
    8000eac0:	00063023          	sd	zero,0(a2) # 100000 <__STACKSIZE__+0xfc000>
    8000eac4:	1ff78793          	addi	a5,a5,511 # 41ff <__STACKSIZE__+0x1ff>
    8000eac8:	00f42823          	sw	a5,16(s0)
    8000eacc:	02043823          	sd	zero,48(s0)
    8000ead0:	04043c23          	sd	zero,88(s0)
    8000ead4:	00000513          	li	a0,0
    8000ead8:	00813083          	ld	ra,8(sp)
    8000eadc:	00013403          	ld	s0,0(sp)
    8000eae0:	01010113          	addi	sp,sp,16
    8000eae4:	00008067          	ret
    8000eae8:	00158513          	addi	a0,a1,1
    8000eaec:	b91f60ef          	jal	ra,8000567c <rt_device_find>
    8000eaf0:	00050793          	mv	a5,a0
    8000eaf4:	ffe00513          	li	a0,-2
    8000eaf8:	fe0780e3          	beqz	a5,8000ead8 <dfs_device_fs_stat+0x40>
    8000eafc:	0287a783          	lw	a5,40(a5)
    8000eb00:	00043023          	sd	zero,0(s0)
    8000eb04:	00079863          	bnez	a5,8000eb14 <dfs_device_fs_stat+0x7c>
    8000eb08:	000027b7          	lui	a5,0x2
    8000eb0c:	1b678793          	addi	a5,a5,438 # 21b6 <__STACKSIZE__-0x1e4a>
    8000eb10:	fb9ff06f          	j	8000eac8 <dfs_device_fs_stat+0x30>
    8000eb14:	00100713          	li	a4,1
    8000eb18:	00e79663          	bne	a5,a4,8000eb24 <dfs_device_fs_stat+0x8c>
    8000eb1c:	000067b7          	lui	a5,0x6
    8000eb20:	fedff06f          	j	8000eb0c <dfs_device_fs_stat+0x74>
    8000eb24:	00f00713          	li	a4,15
    8000eb28:	00e79663          	bne	a5,a4,8000eb34 <dfs_device_fs_stat+0x9c>
    8000eb2c:	000017b7          	lui	a5,0x1
    8000eb30:	fddff06f          	j	8000eb0c <dfs_device_fs_stat+0x74>
    8000eb34:	000087b7          	lui	a5,0x8
    8000eb38:	fd5ff06f          	j	8000eb0c <dfs_device_fs_stat+0x74>

000000008000eb3c <dfs_device_fs_open>:
    8000eb3c:	fd010113          	addi	sp,sp,-48
    8000eb40:	02813023          	sd	s0,32(sp)
    8000eb44:	00050413          	mv	s0,a0
    8000eb48:	00853503          	ld	a0,8(a0)
    8000eb4c:	02113423          	sd	ra,40(sp)
    8000eb50:	00913c23          	sd	s1,24(sp)
    8000eb54:	01213823          	sd	s2,16(sp)
    8000eb58:	01313423          	sd	s3,8(sp)
    8000eb5c:	01413023          	sd	s4,0(sp)
    8000eb60:	00054703          	lbu	a4,0(a0)
    8000eb64:	02f00793          	li	a5,47
    8000eb68:	0ef71663          	bne	a4,a5,8000ec54 <dfs_device_fs_open+0x118>
    8000eb6c:	00154783          	lbu	a5,1(a0)
    8000eb70:	0e079263          	bnez	a5,8000ec54 <dfs_device_fs_open+0x118>
    8000eb74:	02842783          	lw	a5,40(s0)
    8000eb78:	00010737          	lui	a4,0x10
    8000eb7c:	00e7f7b3          	and	a5,a5,a4
    8000eb80:	0c078a63          	beqz	a5,8000ec54 <dfs_device_fs_open+0x118>
    8000eb84:	d55f50ef          	jal	ra,800048d8 <rt_enter_critical>
    8000eb88:	00900513          	li	a0,9
    8000eb8c:	d5df80ef          	jal	ra,800078e8 <rt_object_get_information>
    8000eb90:	00050913          	mv	s2,a0
    8000eb94:	00051e63          	bnez	a0,8000ebb0 <dfs_device_fs_open+0x74>
    8000eb98:	08e00613          	li	a2,142
    8000eb9c:	00005597          	auipc	a1,0x5
    8000eba0:	32458593          	addi	a1,a1,804 # 80013ec0 <__FUNCTION__.1>
    8000eba4:	00003517          	auipc	a0,0x3
    8000eba8:	c3450513          	addi	a0,a0,-972 # 800117d8 <__FUNCTION__.0+0x18>
    8000ebac:	fc9f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000ebb0:	00893783          	ld	a5,8(s2)
    8000ebb4:	00000993          	li	s3,0
    8000ebb8:	00890a13          	addi	s4,s2,8
    8000ebbc:	04fa1863          	bne	s4,a5,8000ec0c <dfs_device_fs_open+0xd0>
    8000ebc0:	02099513          	slli	a0,s3,0x20
    8000ebc4:	02055513          	srli	a0,a0,0x20
    8000ebc8:	00250513          	addi	a0,a0,2
    8000ebcc:	00351513          	slli	a0,a0,0x3
    8000ebd0:	b54f60ef          	jal	ra,80004f24 <rt_malloc>
    8000ebd4:	00050493          	mv	s1,a0
    8000ebd8:	04051063          	bnez	a0,8000ec18 <dfs_device_fs_open+0xdc>
    8000ebdc:	d29f50ef          	jal	ra,80004904 <rt_exit_critical>
    8000ebe0:	04943023          	sd	s1,64(s0)
    8000ebe4:	00000793          	li	a5,0
    8000ebe8:	02813083          	ld	ra,40(sp)
    8000ebec:	02013403          	ld	s0,32(sp)
    8000ebf0:	01813483          	ld	s1,24(sp)
    8000ebf4:	01013903          	ld	s2,16(sp)
    8000ebf8:	00813983          	ld	s3,8(sp)
    8000ebfc:	00013a03          	ld	s4,0(sp)
    8000ec00:	00078513          	mv	a0,a5
    8000ec04:	03010113          	addi	sp,sp,48
    8000ec08:	00008067          	ret
    8000ec0c:	0007b783          	ld	a5,0(a5) # 8000 <__STACKSIZE__+0x4000>
    8000ec10:	0019899b          	addiw	s3,s3,1
    8000ec14:	fa9ff06f          	j	8000ebbc <dfs_device_fs_open+0x80>
    8000ec18:	00893703          	ld	a4,8(s2)
    8000ec1c:	01050613          	addi	a2,a0,16
    8000ec20:	00c53023          	sd	a2,0(a0)
    8000ec24:	00051423          	sh	zero,8(a0)
    8000ec28:	01351523          	sh	s3,10(a0)
    8000ec2c:	00000693          	li	a3,0
    8000ec30:	faea06e3          	beq	s4,a4,8000ebdc <dfs_device_fs_open+0xa0>
    8000ec34:	02069793          	slli	a5,a3,0x20
    8000ec38:	01d7d793          	srli	a5,a5,0x1d
    8000ec3c:	fe870593          	addi	a1,a4,-24 # ffe8 <__STACKSIZE__+0xbfe8>
    8000ec40:	00f607b3          	add	a5,a2,a5
    8000ec44:	00073703          	ld	a4,0(a4)
    8000ec48:	00b7b023          	sd	a1,0(a5)
    8000ec4c:	0016869b          	addiw	a3,a3,1
    8000ec50:	fe1ff06f          	j	8000ec30 <dfs_device_fs_open+0xf4>
    8000ec54:	00150513          	addi	a0,a0,1
    8000ec58:	a25f60ef          	jal	ra,8000567c <rt_device_find>
    8000ec5c:	00050493          	mv	s1,a0
    8000ec60:	fed00793          	li	a5,-19
    8000ec64:	f80502e3          	beqz	a0,8000ebe8 <dfs_device_fs_open+0xac>
    8000ec68:	00300593          	li	a1,3
    8000ec6c:	a91f60ef          	jal	ra,800056fc <rt_device_open>
    8000ec70:	00050663          	beqz	a0,8000ec7c <dfs_device_fs_open+0x140>
    8000ec74:	ffa00793          	li	a5,-6
    8000ec78:	00f51a63          	bne	a0,a5,8000ec8c <dfs_device_fs_open+0x150>
    8000ec7c:	00400793          	li	a5,4
    8000ec80:	04943023          	sd	s1,64(s0)
    8000ec84:	00f41123          	sh	a5,2(s0)
    8000ec88:	f5dff06f          	j	8000ebe4 <dfs_device_fs_open+0xa8>
    8000ec8c:	04043023          	sd	zero,64(s0)
    8000ec90:	ffb00793          	li	a5,-5
    8000ec94:	f55ff06f          	j	8000ebe8 <dfs_device_fs_open+0xac>

000000008000ec98 <dfs_device_fs_getdents>:
    8000ec98:	fc010113          	addi	sp,sp,-64
    8000ec9c:	03213023          	sd	s2,32(sp)
    8000eca0:	04053903          	ld	s2,64(a0)
    8000eca4:	02813823          	sd	s0,48(sp)
    8000eca8:	02913423          	sd	s1,40(sp)
    8000ecac:	02113c23          	sd	ra,56(sp)
    8000ecb0:	01313c23          	sd	s3,24(sp)
    8000ecb4:	01413823          	sd	s4,16(sp)
    8000ecb8:	01513423          	sd	s5,8(sp)
    8000ecbc:	01613023          	sd	s6,0(sp)
    8000ecc0:	00058413          	mv	s0,a1
    8000ecc4:	00060493          	mv	s1,a2
    8000ecc8:	00091e63          	bnez	s2,8000ece4 <dfs_device_fs_getdents+0x4c>
    8000eccc:	10b00613          	li	a2,267
    8000ecd0:	00005597          	auipc	a1,0x5
    8000ecd4:	1d858593          	addi	a1,a1,472 # 80013ea8 <__FUNCTION__.0>
    8000ecd8:	00005517          	auipc	a0,0x5
    8000ecdc:	1b850513          	addi	a0,a0,440 # 80013e90 <_romfs+0x78>
    8000ece0:	e95f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000ece4:	10400993          	li	s3,260
    8000ece8:	10300793          	li	a5,259
    8000ecec:	0334d9bb          	divuw	s3,s1,s3
    8000ecf0:	fea00513          	li	a0,-22
    8000ecf4:	0297fe63          	bgeu	a5,s1,8000ed30 <dfs_device_fs_getdents+0x98>
    8000ecf8:	00440413          	addi	s0,s0,4
    8000ecfc:	00000493          	li	s1,0
    8000ed00:	00100a13          	li	s4,1
    8000ed04:	01400a93          	li	s5,20
    8000ed08:	10400b13          	li	s6,260
    8000ed0c:	00895783          	lhu	a5,8(s2)
    8000ed10:	009787bb          	addw	a5,a5,s1
    8000ed14:	01348863          	beq	s1,s3,8000ed24 <dfs_device_fs_getdents+0x8c>
    8000ed18:	00a95683          	lhu	a3,10(s2)
    8000ed1c:	0007871b          	sext.w	a4,a5
    8000ed20:	02d76c63          	bltu	a4,a3,8000ed58 <dfs_device_fs_getdents+0xc0>
    8000ed24:	10400513          	li	a0,260
    8000ed28:	0295053b          	mulw	a0,a0,s1
    8000ed2c:	00f91423          	sh	a5,8(s2)
    8000ed30:	03813083          	ld	ra,56(sp)
    8000ed34:	03013403          	ld	s0,48(sp)
    8000ed38:	02813483          	ld	s1,40(sp)
    8000ed3c:	02013903          	ld	s2,32(sp)
    8000ed40:	01813983          	ld	s3,24(sp)
    8000ed44:	01013a03          	ld	s4,16(sp)
    8000ed48:	00813a83          	ld	s5,8(sp)
    8000ed4c:	00013b03          	ld	s6,0(sp)
    8000ed50:	04010113          	addi	sp,sp,64
    8000ed54:	00008067          	ret
    8000ed58:	00093703          	ld	a4,0(s2)
    8000ed5c:	02079793          	slli	a5,a5,0x20
    8000ed60:	0207d793          	srli	a5,a5,0x20
    8000ed64:	00379793          	slli	a5,a5,0x3
    8000ed68:	00f707b3          	add	a5,a4,a5
    8000ed6c:	0007b583          	ld	a1,0(a5)
    8000ed70:	00040513          	mv	a0,s0
    8000ed74:	ff440e23          	sb	s4,-4(s0)
    8000ed78:	ff540ea3          	sb	s5,-3(s0)
    8000ed7c:	ff641f23          	sh	s6,-2(s0)
    8000ed80:	01400613          	li	a2,20
    8000ed84:	cd0f70ef          	jal	ra,80006254 <rt_strncpy>
    8000ed88:	0014849b          	addiw	s1,s1,1
    8000ed8c:	10440413          	addi	s0,s0,260
    8000ed90:	f7dff06f          	j	8000ed0c <dfs_device_fs_getdents+0x74>

000000008000ed94 <devfs_init>:
    8000ed94:	ff010113          	addi	sp,sp,-16
    8000ed98:	00005517          	auipc	a0,0x5
    8000ed9c:	1e850513          	addi	a0,a0,488 # 80013f80 <_device_fs>
    8000eda0:	00113423          	sd	ra,8(sp)
    8000eda4:	d65fe0ef          	jal	ra,8000db08 <dfs_register>
    8000eda8:	00813083          	ld	ra,8(sp)
    8000edac:	00000513          	li	a0,0
    8000edb0:	01010113          	addi	sp,sp,16
    8000edb4:	00008067          	ret

000000008000edb8 <rt_completion_init>:
    8000edb8:	ff010113          	addi	sp,sp,-16
    8000edbc:	00813023          	sd	s0,0(sp)
    8000edc0:	00113423          	sd	ra,8(sp)
    8000edc4:	00050413          	mv	s0,a0
    8000edc8:	00051e63          	bnez	a0,8000ede4 <rt_completion_init+0x2c>
    8000edcc:	01500613          	li	a2,21
    8000edd0:	00005597          	auipc	a1,0x5
    8000edd4:	26058593          	addi	a1,a1,608 # 80014030 <__FUNCTION__.2>
    8000edd8:	00005517          	auipc	a0,0x5
    8000eddc:	1f850513          	addi	a0,a0,504 # 80013fd0 <_device_fs+0x50>
    8000ede0:	d95f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000ede4:	a6cf10ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000ede8:	00840793          	addi	a5,s0,8
    8000edec:	00042023          	sw	zero,0(s0)
    8000edf0:	00f43823          	sd	a5,16(s0)
    8000edf4:	00f43423          	sd	a5,8(s0)
    8000edf8:	00013403          	ld	s0,0(sp)
    8000edfc:	00813083          	ld	ra,8(sp)
    8000ee00:	01010113          	addi	sp,sp,16
    8000ee04:	a54f106f          	j	80000058 <rt_hw_interrupt_enable>

000000008000ee08 <rt_completion_wait>:
    8000ee08:	fc010113          	addi	sp,sp,-64
    8000ee0c:	02813823          	sd	s0,48(sp)
    8000ee10:	02113c23          	sd	ra,56(sp)
    8000ee14:	02913423          	sd	s1,40(sp)
    8000ee18:	03213023          	sd	s2,32(sp)
    8000ee1c:	01313c23          	sd	s3,24(sp)
    8000ee20:	01413823          	sd	s4,16(sp)
    8000ee24:	00b12623          	sw	a1,12(sp)
    8000ee28:	00050413          	mv	s0,a0
    8000ee2c:	00051e63          	bnez	a0,8000ee48 <rt_completion_wait+0x40>
    8000ee30:	02400613          	li	a2,36
    8000ee34:	00005597          	auipc	a1,0x5
    8000ee38:	1e458593          	addi	a1,a1,484 # 80014018 <__FUNCTION__.1>
    8000ee3c:	00005517          	auipc	a0,0x5
    8000ee40:	19450513          	addi	a0,a0,404 # 80013fd0 <_device_fs+0x50>
    8000ee44:	d31f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000ee48:	9b8f80ef          	jal	ra,80007000 <rt_thread_self>
    8000ee4c:	00050493          	mv	s1,a0
    8000ee50:	a00f10ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000ee54:	00042703          	lw	a4,0(s0)
    8000ee58:	00100793          	li	a5,1
    8000ee5c:	00050913          	mv	s2,a0
    8000ee60:	10f70463          	beq	a4,a5,8000ef68 <rt_completion_wait+0x160>
    8000ee64:	00843783          	ld	a5,8(s0)
    8000ee68:	00840a13          	addi	s4,s0,8
    8000ee6c:	00fa0e63          	beq	s4,a5,8000ee88 <rt_completion_wait+0x80>
    8000ee70:	02d00613          	li	a2,45
    8000ee74:	00005597          	auipc	a1,0x5
    8000ee78:	1a458593          	addi	a1,a1,420 # 80014018 <__FUNCTION__.1>
    8000ee7c:	00005517          	auipc	a0,0x5
    8000ee80:	16c50513          	addi	a0,a0,364 # 80013fe8 <_device_fs+0x68>
    8000ee84:	cf1f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000ee88:	00c12783          	lw	a5,12(sp)
    8000ee8c:	ffe00993          	li	s3,-2
    8000ee90:	0a078663          	beqz	a5,8000ef3c <rt_completion_wait+0x134>
    8000ee94:	0604b023          	sd	zero,96(s1)
    8000ee98:	00048513          	mv	a0,s1
    8000ee9c:	bfcf80ef          	jal	ra,80007298 <rt_thread_suspend>
    8000eea0:	01043703          	ld	a4,16(s0)
    8000eea4:	02848793          	addi	a5,s1,40
    8000eea8:	00f73023          	sd	a5,0(a4)
    8000eeac:	02e4b823          	sd	a4,48(s1)
    8000eeb0:	00f43823          	sd	a5,16(s0)
    8000eeb4:	0344b423          	sd	s4,40(s1)
    8000eeb8:	998f10ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000eebc:	00050993          	mv	s3,a0
    8000eec0:	dedf40ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    8000eec4:	02050863          	beqz	a0,8000eef4 <rt_completion_wait+0xec>
    8000eec8:	00005597          	auipc	a1,0x5
    8000eecc:	15058593          	addi	a1,a1,336 # 80014018 <__FUNCTION__.1>
    8000eed0:	00002517          	auipc	a0,0x2
    8000eed4:	f7850513          	addi	a0,a0,-136 # 80010e48 <__FUNCTION__.1+0x1f8>
    8000eed8:	b15f70ef          	jal	ra,800069ec <rt_kprintf>
    8000eedc:	04000613          	li	a2,64
    8000eee0:	00005597          	auipc	a1,0x5
    8000eee4:	13858593          	addi	a1,a1,312 # 80014018 <__FUNCTION__.1>
    8000eee8:	00002517          	auipc	a0,0x2
    8000eeec:	f8850513          	addi	a0,a0,-120 # 80010e70 <__FUNCTION__.1+0x220>
    8000eef0:	c85f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000eef4:	00098513          	mv	a0,s3
    8000eef8:	960f10ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000eefc:	00c12783          	lw	a5,12(sp)
    8000ef00:	02f05063          	blez	a5,8000ef20 <rt_completion_wait+0x118>
    8000ef04:	08848993          	addi	s3,s1,136
    8000ef08:	00c10613          	addi	a2,sp,12
    8000ef0c:	00000593          	li	a1,0
    8000ef10:	00098513          	mv	a0,s3
    8000ef14:	99cf50ef          	jal	ra,800040b0 <rt_timer_control>
    8000ef18:	00098513          	mv	a0,s3
    8000ef1c:	f4df40ef          	jal	ra,80003e68 <rt_timer_start>
    8000ef20:	00090513          	mv	a0,s2
    8000ef24:	934f10ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000ef28:	831f50ef          	jal	ra,80004758 <rt_schedule>
    8000ef2c:	0604b983          	ld	s3,96(s1)
    8000ef30:	920f10ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000ef34:	00050913          	mv	s2,a0
    8000ef38:	00042023          	sw	zero,0(s0)
    8000ef3c:	00090513          	mv	a0,s2
    8000ef40:	918f10ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000ef44:	03813083          	ld	ra,56(sp)
    8000ef48:	03013403          	ld	s0,48(sp)
    8000ef4c:	02813483          	ld	s1,40(sp)
    8000ef50:	02013903          	ld	s2,32(sp)
    8000ef54:	01013a03          	ld	s4,16(sp)
    8000ef58:	00098513          	mv	a0,s3
    8000ef5c:	01813983          	ld	s3,24(sp)
    8000ef60:	04010113          	addi	sp,sp,64
    8000ef64:	00008067          	ret
    8000ef68:	00000993          	li	s3,0
    8000ef6c:	fcdff06f          	j	8000ef38 <rt_completion_wait+0x130>

000000008000ef70 <rt_data_queue_init>:
    8000ef70:	fd010113          	addi	sp,sp,-48
    8000ef74:	02813023          	sd	s0,32(sp)
    8000ef78:	00913c23          	sd	s1,24(sp)
    8000ef7c:	01213823          	sd	s2,16(sp)
    8000ef80:	01313423          	sd	s3,8(sp)
    8000ef84:	02113423          	sd	ra,40(sp)
    8000ef88:	00050413          	mv	s0,a0
    8000ef8c:	00058493          	mv	s1,a1
    8000ef90:	00060913          	mv	s2,a2
    8000ef94:	00068993          	mv	s3,a3
    8000ef98:	00051e63          	bnez	a0,8000efb4 <rt_data_queue_init+0x44>
    8000ef9c:	01e00613          	li	a2,30
    8000efa0:	00005597          	auipc	a1,0x5
    8000efa4:	13858593          	addi	a1,a1,312 # 800140d8 <__FUNCTION__.6>
    8000efa8:	00005517          	auipc	a0,0x5
    8000efac:	0a050513          	addi	a0,a0,160 # 80014048 <__FUNCTION__.2+0x18>
    8000efb0:	bc5f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000efb4:	00049e63          	bnez	s1,8000efd0 <rt_data_queue_init+0x60>
    8000efb8:	01f00613          	li	a2,31
    8000efbc:	00005597          	auipc	a1,0x5
    8000efc0:	11c58593          	addi	a1,a1,284 # 800140d8 <__FUNCTION__.6>
    8000efc4:	00005517          	auipc	a0,0x5
    8000efc8:	09c50513          	addi	a0,a0,156 # 80014060 <__FUNCTION__.2+0x30>
    8000efcc:	ba9f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000efd0:	bead17b7          	lui	a5,0xbead1
    8000efd4:	e0e78793          	addi	a5,a5,-498 # ffffffffbead0e0e <__bss_end+0xffffffff3eaaa24e>
    8000efd8:	00f42023          	sw	a5,0(s0)
    8000efdc:	000087b7          	lui	a5,0x8
    8000efe0:	00f42423          	sw	a5,8(s0)
    8000efe4:	01840793          	addi	a5,s0,24
    8000efe8:	02f43023          	sd	a5,32(s0)
    8000efec:	00f43c23          	sd	a5,24(s0)
    8000eff0:	02840793          	addi	a5,s0,40
    8000eff4:	02f43823          	sd	a5,48(s0)
    8000eff8:	02f43423          	sd	a5,40(s0)
    8000effc:	03343c23          	sd	s3,56(s0)
    8000f000:	00941223          	sh	s1,4(s0)
    8000f004:	01241323          	sh	s2,6(s0)
    8000f008:	00449513          	slli	a0,s1,0x4
    8000f00c:	f19f50ef          	jal	ra,80004f24 <rt_malloc>
    8000f010:	00050793          	mv	a5,a0
    8000f014:	00a43823          	sd	a0,16(s0)
    8000f018:	00000513          	li	a0,0
    8000f01c:	00079463          	bnez	a5,8000f024 <rt_data_queue_init+0xb4>
    8000f020:	ffb00513          	li	a0,-5
    8000f024:	02813083          	ld	ra,40(sp)
    8000f028:	02013403          	ld	s0,32(sp)
    8000f02c:	01813483          	ld	s1,24(sp)
    8000f030:	01013903          	ld	s2,16(sp)
    8000f034:	00813983          	ld	s3,8(sp)
    8000f038:	03010113          	addi	sp,sp,48
    8000f03c:	00008067          	ret

000000008000f040 <rt_data_queue_push>:
    8000f040:	f8010113          	addi	sp,sp,-128
    8000f044:	06813823          	sd	s0,112(sp)
    8000f048:	05413823          	sd	s4,80(sp)
    8000f04c:	05513423          	sd	s5,72(sp)
    8000f050:	06113c23          	sd	ra,120(sp)
    8000f054:	06913423          	sd	s1,104(sp)
    8000f058:	07213023          	sd	s2,96(sp)
    8000f05c:	05313c23          	sd	s3,88(sp)
    8000f060:	05613023          	sd	s6,64(sp)
    8000f064:	03713c23          	sd	s7,56(sp)
    8000f068:	03813823          	sd	s8,48(sp)
    8000f06c:	03913423          	sd	s9,40(sp)
    8000f070:	03a13023          	sd	s10,32(sp)
    8000f074:	01b13c23          	sd	s11,24(sp)
    8000f078:	00d12623          	sw	a3,12(sp)
    8000f07c:	00050413          	mv	s0,a0
    8000f080:	00058a93          	mv	s5,a1
    8000f084:	00060a13          	mv	s4,a2
    8000f088:	00051e63          	bnez	a0,8000f0a4 <rt_data_queue_push+0x64>
    8000f08c:	04200613          	li	a2,66
    8000f090:	00005597          	auipc	a1,0x5
    8000f094:	03058593          	addi	a1,a1,48 # 800140c0 <__FUNCTION__.5>
    8000f098:	00005517          	auipc	a0,0x5
    8000f09c:	fb050513          	addi	a0,a0,-80 # 80014048 <__FUNCTION__.2+0x18>
    8000f0a0:	ad5f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f0a4:	00042703          	lw	a4,0(s0)
    8000f0a8:	bead17b7          	lui	a5,0xbead1
    8000f0ac:	e0e78793          	addi	a5,a5,-498 # ffffffffbead0e0e <__bss_end+0xffffffff3eaaa24e>
    8000f0b0:	00f70e63          	beq	a4,a5,8000f0cc <rt_data_queue_push+0x8c>
    8000f0b4:	04300613          	li	a2,67
    8000f0b8:	00005597          	auipc	a1,0x5
    8000f0bc:	00858593          	addi	a1,a1,8 # 800140c0 <__FUNCTION__.5>
    8000f0c0:	00005517          	auipc	a0,0x5
    8000f0c4:	fb050513          	addi	a0,a0,-80 # 80014070 <__FUNCTION__.2+0x40>
    8000f0c8:	aadf70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f0cc:	f35f70ef          	jal	ra,80007000 <rt_thread_self>
    8000f0d0:	00050913          	mv	s2,a0
    8000f0d4:	f7df00ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000f0d8:	00050493          	mv	s1,a0
    8000f0dc:	00005b17          	auipc	s6,0x5
    8000f0e0:	fe4b0b13          	addi	s6,s6,-28 # 800140c0 <__FUNCTION__.5>
    8000f0e4:	00002c97          	auipc	s9,0x2
    8000f0e8:	d64c8c93          	addi	s9,s9,-668 # 80010e48 <__FUNCTION__.1+0x1f8>
    8000f0ec:	00002d17          	auipc	s10,0x2
    8000f0f0:	d84d0d13          	addi	s10,s10,-636 # 80010e70 <__FUNCTION__.1+0x220>
    8000f0f4:	02890b93          	addi	s7,s2,40
    8000f0f8:	01840d93          	addi	s11,s0,24
    8000f0fc:	08890c13          	addi	s8,s2,136
    8000f100:	00842783          	lw	a5,8(s0)
    8000f104:	1207c263          	bltz	a5,8000f228 <rt_data_queue_push+0x1e8>
    8000f108:	00843783          	ld	a5,8(s0)
    8000f10c:	00008737          	lui	a4,0x8
    8000f110:	fff70713          	addi	a4,a4,-1 # 7fff <__STACKSIZE__+0x3fff>
    8000f114:	0107d793          	srli	a5,a5,0x10
    8000f118:	00e7f7b3          	and	a5,a5,a4
    8000f11c:	01043683          	ld	a3,16(s0)
    8000f120:	03079793          	slli	a5,a5,0x30
    8000f124:	0307d793          	srli	a5,a5,0x30
    8000f128:	00479613          	slli	a2,a5,0x4
    8000f12c:	00c686b3          	add	a3,a3,a2
    8000f130:	0017879b          	addiw	a5,a5,1
    8000f134:	0156b023          	sd	s5,0(a3)
    8000f138:	0146b423          	sd	s4,8(a3)
    8000f13c:	00f777b3          	and	a5,a4,a5
    8000f140:	00842683          	lw	a3,8(s0)
    8000f144:	03079793          	slli	a5,a5,0x30
    8000f148:	0307d793          	srli	a5,a5,0x30
    8000f14c:	80010637          	lui	a2,0x80010
    8000f150:	00e7f733          	and	a4,a5,a4
    8000f154:	fff60613          	addi	a2,a2,-1 # ffffffff8000ffff <__bss_end+0xfffffffefffe943f>
    8000f158:	00c6f6b3          	and	a3,a3,a2
    8000f15c:	0107171b          	slliw	a4,a4,0x10
    8000f160:	00e6e733          	or	a4,a3,a4
    8000f164:	00445683          	lhu	a3,4(s0)
    8000f168:	00e42423          	sw	a4,8(s0)
    8000f16c:	00f69663          	bne	a3,a5,8000f178 <rt_data_queue_push+0x138>
    8000f170:	00c77733          	and	a4,a4,a2
    8000f174:	00e42423          	sw	a4,8(s0)
    8000f178:	00842783          	lw	a5,8(s0)
    8000f17c:	ffff8737          	lui	a4,0xffff8
    8000f180:	fff70713          	addi	a4,a4,-1 # ffffffffffff7fff <__bss_end+0xffffffff7ffd143f>
    8000f184:	00e7f7b3          	and	a5,a5,a4
    8000f188:	00f42423          	sw	a5,8(s0)
    8000f18c:	00843703          	ld	a4,8(s0)
    8000f190:	00008637          	lui	a2,0x8
    8000f194:	fff60613          	addi	a2,a2,-1 # 7fff <__STACKSIZE__+0x3fff>
    8000f198:	01075693          	srli	a3,a4,0x10
    8000f19c:	00c6f6b3          	and	a3,a3,a2
    8000f1a0:	00c77733          	and	a4,a4,a2
    8000f1a4:	03069693          	slli	a3,a3,0x30
    8000f1a8:	03071713          	slli	a4,a4,0x30
    8000f1ac:	0306d693          	srli	a3,a3,0x30
    8000f1b0:	03075713          	srli	a4,a4,0x30
    8000f1b4:	00e69863          	bne	a3,a4,8000f1c4 <rt_data_queue_push+0x184>
    8000f1b8:	80000737          	lui	a4,0x80000
    8000f1bc:	00e7e7b3          	or	a5,a5,a4
    8000f1c0:	00f42423          	sw	a5,8(s0)
    8000f1c4:	02843503          	ld	a0,40(s0)
    8000f1c8:	02840793          	addi	a5,s0,40
    8000f1cc:	00000993          	li	s3,0
    8000f1d0:	0ef50863          	beq	a0,a5,8000f2c0 <rt_data_queue_push+0x280>
    8000f1d4:	fd850513          	addi	a0,a0,-40
    8000f1d8:	aacf80ef          	jal	ra,80007484 <rt_thread_resume>
    8000f1dc:	00048513          	mv	a0,s1
    8000f1e0:	e79f00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000f1e4:	d74f50ef          	jal	ra,80004758 <rt_schedule>
    8000f1e8:	07813083          	ld	ra,120(sp)
    8000f1ec:	07013403          	ld	s0,112(sp)
    8000f1f0:	06813483          	ld	s1,104(sp)
    8000f1f4:	06013903          	ld	s2,96(sp)
    8000f1f8:	05013a03          	ld	s4,80(sp)
    8000f1fc:	04813a83          	ld	s5,72(sp)
    8000f200:	04013b03          	ld	s6,64(sp)
    8000f204:	03813b83          	ld	s7,56(sp)
    8000f208:	03013c03          	ld	s8,48(sp)
    8000f20c:	02813c83          	ld	s9,40(sp)
    8000f210:	02013d03          	ld	s10,32(sp)
    8000f214:	01813d83          	ld	s11,24(sp)
    8000f218:	00098513          	mv	a0,s3
    8000f21c:	05813983          	ld	s3,88(sp)
    8000f220:	08010113          	addi	sp,sp,128
    8000f224:	00008067          	ret
    8000f228:	00c12783          	lw	a5,12(sp)
    8000f22c:	0a078c63          	beqz	a5,8000f2e4 <rt_data_queue_push+0x2a4>
    8000f230:	e21f00ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000f234:	00050993          	mv	s3,a0
    8000f238:	a75f40ef          	jal	ra,80003cac <rt_interrupt_get_nest>
    8000f23c:	02050063          	beqz	a0,8000f25c <rt_data_queue_push+0x21c>
    8000f240:	000b0593          	mv	a1,s6
    8000f244:	000c8513          	mv	a0,s9
    8000f248:	fa4f70ef          	jal	ra,800069ec <rt_kprintf>
    8000f24c:	05400613          	li	a2,84
    8000f250:	000b0593          	mv	a1,s6
    8000f254:	000d0513          	mv	a0,s10
    8000f258:	91df70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f25c:	00098513          	mv	a0,s3
    8000f260:	df9f00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000f264:	00090513          	mv	a0,s2
    8000f268:	06093023          	sd	zero,96(s2)
    8000f26c:	82cf80ef          	jal	ra,80007298 <rt_thread_suspend>
    8000f270:	02043783          	ld	a5,32(s0)
    8000f274:	0177b023          	sd	s7,0(a5)
    8000f278:	02f93823          	sd	a5,48(s2)
    8000f27c:	00c12783          	lw	a5,12(sp)
    8000f280:	03743023          	sd	s7,32(s0)
    8000f284:	03b93423          	sd	s11,40(s2)
    8000f288:	00f05e63          	blez	a5,8000f2a4 <rt_data_queue_push+0x264>
    8000f28c:	00c10613          	addi	a2,sp,12
    8000f290:	00000593          	li	a1,0
    8000f294:	000c0513          	mv	a0,s8
    8000f298:	e19f40ef          	jal	ra,800040b0 <rt_timer_control>
    8000f29c:	000c0513          	mv	a0,s8
    8000f2a0:	bc9f40ef          	jal	ra,80003e68 <rt_timer_start>
    8000f2a4:	00048513          	mv	a0,s1
    8000f2a8:	db1f00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000f2ac:	cacf50ef          	jal	ra,80004758 <rt_schedule>
    8000f2b0:	06093983          	ld	s3,96(s2)
    8000f2b4:	d9df00ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000f2b8:	00050493          	mv	s1,a0
    8000f2bc:	e40982e3          	beqz	s3,8000f100 <rt_data_queue_push+0xc0>
    8000f2c0:	00048513          	mv	a0,s1
    8000f2c4:	d95f00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000f2c8:	f20990e3          	bnez	s3,8000f1e8 <rt_data_queue_push+0x1a8>
    8000f2cc:	03843783          	ld	a5,56(s0)
    8000f2d0:	f0078ce3          	beqz	a5,8000f1e8 <rt_data_queue_push+0x1a8>
    8000f2d4:	00200593          	li	a1,2
    8000f2d8:	00040513          	mv	a0,s0
    8000f2dc:	000780e7          	jalr	a5
    8000f2e0:	f09ff06f          	j	8000f1e8 <rt_data_queue_push+0x1a8>
    8000f2e4:	ffe00993          	li	s3,-2
    8000f2e8:	fd9ff06f          	j	8000f2c0 <rt_data_queue_push+0x280>

000000008000f2ec <rt_data_queue_reset>:
    8000f2ec:	fd010113          	addi	sp,sp,-48
    8000f2f0:	02813023          	sd	s0,32(sp)
    8000f2f4:	02113423          	sd	ra,40(sp)
    8000f2f8:	00913c23          	sd	s1,24(sp)
    8000f2fc:	01213823          	sd	s2,16(sp)
    8000f300:	01313423          	sd	s3,8(sp)
    8000f304:	00050413          	mv	s0,a0
    8000f308:	00051e63          	bnez	a0,8000f324 <rt_data_queue_reset+0x38>
    8000f30c:	12900613          	li	a2,297
    8000f310:	00005597          	auipc	a1,0x5
    8000f314:	d9858593          	addi	a1,a1,-616 # 800140a8 <__FUNCTION__.2>
    8000f318:	00005517          	auipc	a0,0x5
    8000f31c:	d3050513          	addi	a0,a0,-720 # 80014048 <__FUNCTION__.2+0x18>
    8000f320:	855f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f324:	00042703          	lw	a4,0(s0)
    8000f328:	bead17b7          	lui	a5,0xbead1
    8000f32c:	e0e78793          	addi	a5,a5,-498 # ffffffffbead0e0e <__bss_end+0xffffffff3eaaa24e>
    8000f330:	00f70e63          	beq	a4,a5,8000f34c <rt_data_queue_reset+0x60>
    8000f334:	12a00613          	li	a2,298
    8000f338:	00005597          	auipc	a1,0x5
    8000f33c:	d7058593          	addi	a1,a1,-656 # 800140a8 <__FUNCTION__.2>
    8000f340:	00005517          	auipc	a0,0x5
    8000f344:	d3050513          	addi	a0,a0,-720 # 80014070 <__FUNCTION__.2+0x40>
    8000f348:	82df70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f34c:	d05f00ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000f350:	000087b7          	lui	a5,0x8
    8000f354:	00f42423          	sw	a5,8(s0)
    8000f358:	d01f00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000f35c:	02840913          	addi	s2,s0,40
    8000f360:	d78f50ef          	jal	ra,800048d8 <rt_enter_critical>
    8000f364:	fff00993          	li	s3,-1
    8000f368:	02843783          	ld	a5,40(s0)
    8000f36c:	03279a63          	bne	a5,s2,8000f3a0 <rt_data_queue_reset+0xb4>
    8000f370:	01840913          	addi	s2,s0,24
    8000f374:	fff00993          	li	s3,-1
    8000f378:	01843783          	ld	a5,24(s0)
    8000f37c:	05279463          	bne	a5,s2,8000f3c4 <rt_data_queue_reset+0xd8>
    8000f380:	d84f50ef          	jal	ra,80004904 <rt_exit_critical>
    8000f384:	02013403          	ld	s0,32(sp)
    8000f388:	02813083          	ld	ra,40(sp)
    8000f38c:	01813483          	ld	s1,24(sp)
    8000f390:	01013903          	ld	s2,16(sp)
    8000f394:	00813983          	ld	s3,8(sp)
    8000f398:	03010113          	addi	sp,sp,48
    8000f39c:	bbcf506f          	j	80004758 <rt_schedule>
    8000f3a0:	cb1f00ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000f3a4:	00050493          	mv	s1,a0
    8000f3a8:	02843503          	ld	a0,40(s0)
    8000f3ac:	03353c23          	sd	s3,56(a0)
    8000f3b0:	fd850513          	addi	a0,a0,-40
    8000f3b4:	8d0f80ef          	jal	ra,80007484 <rt_thread_resume>
    8000f3b8:	00048513          	mv	a0,s1
    8000f3bc:	c9df00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000f3c0:	fa9ff06f          	j	8000f368 <rt_data_queue_reset+0x7c>
    8000f3c4:	c8df00ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000f3c8:	00050493          	mv	s1,a0
    8000f3cc:	01843503          	ld	a0,24(s0)
    8000f3d0:	03353c23          	sd	s3,56(a0)
    8000f3d4:	fd850513          	addi	a0,a0,-40
    8000f3d8:	8acf80ef          	jal	ra,80007484 <rt_thread_resume>
    8000f3dc:	00048513          	mv	a0,s1
    8000f3e0:	c79f00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000f3e4:	f95ff06f          	j	8000f378 <rt_data_queue_reset+0x8c>

000000008000f3e8 <rt_data_queue_deinit>:
    8000f3e8:	ff010113          	addi	sp,sp,-16
    8000f3ec:	00813023          	sd	s0,0(sp)
    8000f3f0:	00113423          	sd	ra,8(sp)
    8000f3f4:	00050413          	mv	s0,a0
    8000f3f8:	00051e63          	bnez	a0,8000f414 <rt_data_queue_deinit+0x2c>
    8000f3fc:	17100613          	li	a2,369
    8000f400:	00005597          	auipc	a1,0x5
    8000f404:	c9058593          	addi	a1,a1,-880 # 80014090 <__FUNCTION__.1>
    8000f408:	00005517          	auipc	a0,0x5
    8000f40c:	c4050513          	addi	a0,a0,-960 # 80014048 <__FUNCTION__.2+0x18>
    8000f410:	f64f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f414:	00042703          	lw	a4,0(s0)
    8000f418:	bead17b7          	lui	a5,0xbead1
    8000f41c:	e0e78793          	addi	a5,a5,-498 # ffffffffbead0e0e <__bss_end+0xffffffff3eaaa24e>
    8000f420:	00f70e63          	beq	a4,a5,8000f43c <rt_data_queue_deinit+0x54>
    8000f424:	17200613          	li	a2,370
    8000f428:	00005597          	auipc	a1,0x5
    8000f42c:	c6858593          	addi	a1,a1,-920 # 80014090 <__FUNCTION__.1>
    8000f430:	00005517          	auipc	a0,0x5
    8000f434:	c4050513          	addi	a0,a0,-960 # 80014070 <__FUNCTION__.2+0x40>
    8000f438:	f3cf70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f43c:	00040513          	mv	a0,s0
    8000f440:	eadff0ef          	jal	ra,8000f2ec <rt_data_queue_reset>
    8000f444:	c0df00ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000f448:	00042023          	sw	zero,0(s0)
    8000f44c:	c0df00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000f450:	01043503          	ld	a0,16(s0)
    8000f454:	e1df50ef          	jal	ra,80005270 <rt_free>
    8000f458:	00813083          	ld	ra,8(sp)
    8000f45c:	00013403          	ld	s0,0(sp)
    8000f460:	00000513          	li	a0,0
    8000f464:	01010113          	addi	sp,sp,16
    8000f468:	00008067          	ret

000000008000f46c <rt_serial_control>:
    8000f46c:	fe010113          	addi	sp,sp,-32
    8000f470:	00813823          	sd	s0,16(sp)
    8000f474:	00913423          	sd	s1,8(sp)
    8000f478:	01213023          	sd	s2,0(sp)
    8000f47c:	00113c23          	sd	ra,24(sp)
    8000f480:	00050413          	mv	s0,a0
    8000f484:	00058913          	mv	s2,a1
    8000f488:	00060493          	mv	s1,a2
    8000f48c:	00051e63          	bnez	a0,8000f4a8 <rt_serial_control+0x3c>
    8000f490:	3dc00613          	li	a2,988
    8000f494:	00005597          	auipc	a1,0x5
    8000f498:	d8c58593          	addi	a1,a1,-628 # 80014220 <__FUNCTION__.15>
    8000f49c:	00002517          	auipc	a0,0x2
    8000f4a0:	ce450513          	addi	a0,a0,-796 # 80011180 <__fsym_list_mem_name+0x10>
    8000f4a4:	ed0f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f4a8:	00200793          	li	a5,2
    8000f4ac:	02f90063          	beq	s2,a5,8000f4cc <rt_serial_control+0x60>
    8000f4b0:	00300793          	li	a5,3
    8000f4b4:	04f90063          	beq	s2,a5,8000f4f4 <rt_serial_control+0x88>
    8000f4b8:	00100793          	li	a5,1
    8000f4bc:	08f91c63          	bne	s2,a5,8000f554 <rt_serial_control+0xe8>
    8000f4c0:	02c45783          	lhu	a5,44(s0)
    8000f4c4:	fdf7f793          	andi	a5,a5,-33
    8000f4c8:	00c0006f          	j	8000f4d4 <rt_serial_control+0x68>
    8000f4cc:	02c45783          	lhu	a5,44(s0)
    8000f4d0:	0207e793          	ori	a5,a5,32
    8000f4d4:	02f41623          	sh	a5,44(s0)
    8000f4d8:	00000513          	li	a0,0
    8000f4dc:	01813083          	ld	ra,24(sp)
    8000f4e0:	01013403          	ld	s0,16(sp)
    8000f4e4:	00813483          	ld	s1,8(sp)
    8000f4e8:	00013903          	ld	s2,0(sp)
    8000f4ec:	02010113          	addi	sp,sp,32
    8000f4f0:	00008067          	ret
    8000f4f4:	fe0482e3          	beqz	s1,8000f4d8 <rt_serial_control+0x6c>
    8000f4f8:	0044a703          	lw	a4,4(s1)
    8000f4fc:	08843783          	ld	a5,136(s0)
    8000f500:	03044683          	lbu	a3,48(s0)
    8000f504:	00a7571b          	srliw	a4,a4,0xa
    8000f508:	02a7d793          	srli	a5,a5,0x2a
    8000f50c:	03071713          	slli	a4,a4,0x30
    8000f510:	03079793          	slli	a5,a5,0x30
    8000f514:	03075713          	srli	a4,a4,0x30
    8000f518:	0307d793          	srli	a5,a5,0x30
    8000f51c:	00f70663          	beq	a4,a5,8000f528 <rt_serial_control+0xbc>
    8000f520:	00700513          	li	a0,7
    8000f524:	fa069ce3          	bnez	a3,8000f4dc <rt_serial_control+0x70>
    8000f528:	0004a783          	lw	a5,0(s1)
    8000f52c:	08f42423          	sw	a5,136(s0)
    8000f530:	0044a783          	lw	a5,4(s1)
    8000f534:	08f42623          	sw	a5,140(s0)
    8000f538:	fa0680e3          	beqz	a3,8000f4d8 <rt_serial_control+0x6c>
    8000f53c:	08043783          	ld	a5,128(s0)
    8000f540:	00048593          	mv	a1,s1
    8000f544:	00040513          	mv	a0,s0
    8000f548:	0007b783          	ld	a5,0(a5)
    8000f54c:	000780e7          	jalr	a5
    8000f550:	f89ff06f          	j	8000f4d8 <rt_serial_control+0x6c>
    8000f554:	08043783          	ld	a5,128(s0)
    8000f558:	00040513          	mv	a0,s0
    8000f55c:	01013403          	ld	s0,16(sp)
    8000f560:	01813083          	ld	ra,24(sp)
    8000f564:	0087b783          	ld	a5,8(a5)
    8000f568:	00048613          	mv	a2,s1
    8000f56c:	00090593          	mv	a1,s2
    8000f570:	00813483          	ld	s1,8(sp)
    8000f574:	00013903          	ld	s2,0(sp)
    8000f578:	02010113          	addi	sp,sp,32
    8000f57c:	00078067          	jr	a5

000000008000f580 <_serial_fifo_calc_recved_len>:
    8000f580:	fe010113          	addi	sp,sp,-32
    8000f584:	00913423          	sd	s1,8(sp)
    8000f588:	09053483          	ld	s1,144(a0)
    8000f58c:	00813823          	sd	s0,16(sp)
    8000f590:	00113c23          	sd	ra,24(sp)
    8000f594:	00050413          	mv	s0,a0
    8000f598:	00049e63          	bnez	s1,8000f5b4 <_serial_fifo_calc_recved_len+0x34>
    8000f59c:	17100613          	li	a2,369
    8000f5a0:	00005597          	auipc	a1,0x5
    8000f5a4:	d0058593          	addi	a1,a1,-768 # 800142a0 <__FUNCTION__.8>
    8000f5a8:	00005517          	auipc	a0,0x5
    8000f5ac:	b4850513          	addi	a0,a0,-1208 # 800140f0 <__FUNCTION__.6+0x18>
    8000f5b0:	dc4f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f5b4:	0084d503          	lhu	a0,8(s1)
    8000f5b8:	00a4d703          	lhu	a4,10(s1)
    8000f5bc:	02e51a63          	bne	a0,a4,8000f5f0 <_serial_fifo_calc_recved_len+0x70>
    8000f5c0:	00c4a783          	lw	a5,12(s1)
    8000f5c4:	00000513          	li	a0,0
    8000f5c8:	00078a63          	beqz	a5,8000f5dc <_serial_fifo_calc_recved_len+0x5c>
    8000f5cc:	08843503          	ld	a0,136(s0)
    8000f5d0:	02a55513          	srli	a0,a0,0x2a
    8000f5d4:	03051513          	slli	a0,a0,0x30
    8000f5d8:	03055513          	srli	a0,a0,0x30
    8000f5dc:	01813083          	ld	ra,24(sp)
    8000f5e0:	01013403          	ld	s0,16(sp)
    8000f5e4:	00813483          	ld	s1,8(sp)
    8000f5e8:	02010113          	addi	sp,sp,32
    8000f5ec:	00008067          	ret
    8000f5f0:	00a77663          	bgeu	a4,a0,8000f5fc <_serial_fifo_calc_recved_len+0x7c>
    8000f5f4:	40e5053b          	subw	a0,a0,a4
    8000f5f8:	fe5ff06f          	j	8000f5dc <_serial_fifo_calc_recved_len+0x5c>
    8000f5fc:	08843783          	ld	a5,136(s0)
    8000f600:	40a7053b          	subw	a0,a4,a0
    8000f604:	02a7d793          	srli	a5,a5,0x2a
    8000f608:	0107979b          	slliw	a5,a5,0x10
    8000f60c:	0107d79b          	srliw	a5,a5,0x10
    8000f610:	40a7853b          	subw	a0,a5,a0
    8000f614:	fc9ff06f          	j	8000f5dc <_serial_fifo_calc_recved_len+0x5c>

000000008000f618 <rt_serial_init>:
    8000f618:	ff010113          	addi	sp,sp,-16
    8000f61c:	00813023          	sd	s0,0(sp)
    8000f620:	00113423          	sd	ra,8(sp)
    8000f624:	00050413          	mv	s0,a0
    8000f628:	00051e63          	bnez	a0,8000f644 <rt_serial_init+0x2c>
    8000f62c:	24000613          	li	a2,576
    8000f630:	00005597          	auipc	a1,0x5
    8000f634:	c2058593          	addi	a1,a1,-992 # 80014250 <__FUNCTION__.3>
    8000f638:	00002517          	auipc	a0,0x2
    8000f63c:	b4850513          	addi	a0,a0,-1208 # 80011180 <__fsym_list_mem_name+0x10>
    8000f640:	d34f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f644:	08043783          	ld	a5,128(s0)
    8000f648:	08043823          	sd	zero,144(s0)
    8000f64c:	08043c23          	sd	zero,152(s0)
    8000f650:	0007b783          	ld	a5,0(a5)
    8000f654:	00078e63          	beqz	a5,8000f670 <rt_serial_init+0x58>
    8000f658:	08840593          	addi	a1,s0,136
    8000f65c:	00040513          	mv	a0,s0
    8000f660:	00013403          	ld	s0,0(sp)
    8000f664:	00813083          	ld	ra,8(sp)
    8000f668:	01010113          	addi	sp,sp,16
    8000f66c:	00078067          	jr	a5
    8000f670:	00813083          	ld	ra,8(sp)
    8000f674:	00013403          	ld	s0,0(sp)
    8000f678:	00000513          	li	a0,0
    8000f67c:	01010113          	addi	sp,sp,16
    8000f680:	00008067          	ret

000000008000f684 <rt_serial_open>:
    8000f684:	fd010113          	addi	sp,sp,-48
    8000f688:	02813023          	sd	s0,32(sp)
    8000f68c:	00913c23          	sd	s1,24(sp)
    8000f690:	02113423          	sd	ra,40(sp)
    8000f694:	01213823          	sd	s2,16(sp)
    8000f698:	01313423          	sd	s3,8(sp)
    8000f69c:	01413023          	sd	s4,0(sp)
    8000f6a0:	00050413          	mv	s0,a0
    8000f6a4:	00058493          	mv	s1,a1
    8000f6a8:	00051e63          	bnez	a0,8000f6c4 <rt_serial_open+0x40>
    8000f6ac:	25300613          	li	a2,595
    8000f6b0:	00005597          	auipc	a1,0x5
    8000f6b4:	bb058593          	addi	a1,a1,-1104 # 80014260 <__FUNCTION__.4>
    8000f6b8:	00002517          	auipc	a0,0x2
    8000f6bc:	ac850513          	addi	a0,a0,-1336 # 80011180 <__fsym_list_mem_name+0x10>
    8000f6c0:	cb4f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f6c4:	2004f713          	andi	a4,s1,512
    8000f6c8:	00070a63          	beqz	a4,8000f6dc <rt_serial_open+0x58>
    8000f6cc:	02c45783          	lhu	a5,44(s0)
    8000f6d0:	ff800513          	li	a0,-8
    8000f6d4:	2007f793          	andi	a5,a5,512
    8000f6d8:	16078e63          	beqz	a5,8000f854 <rt_serial_open+0x1d0>
    8000f6dc:	000017b7          	lui	a5,0x1
    8000f6e0:	80078793          	addi	a5,a5,-2048 # 800 <__STACKSIZE__-0x3800>
    8000f6e4:	00f4f9b3          	and	s3,s1,a5
    8000f6e8:	00098a63          	beqz	s3,8000f6fc <rt_serial_open+0x78>
    8000f6ec:	02c45683          	lhu	a3,44(s0)
    8000f6f0:	ff800513          	li	a0,-8
    8000f6f4:	00d7f7b3          	and	a5,a5,a3
    8000f6f8:	14078e63          	beqz	a5,8000f854 <rt_serial_open+0x1d0>
    8000f6fc:	1004f793          	andi	a5,s1,256
    8000f700:	00078a63          	beqz	a5,8000f714 <rt_serial_open+0x90>
    8000f704:	02c45683          	lhu	a3,44(s0)
    8000f708:	ff800513          	li	a0,-8
    8000f70c:	1006f693          	andi	a3,a3,256
    8000f710:	14068263          	beqz	a3,8000f854 <rt_serial_open+0x1d0>
    8000f714:	4004fa13          	andi	s4,s1,1024
    8000f718:	000a0a63          	beqz	s4,8000f72c <rt_serial_open+0xa8>
    8000f71c:	02c45683          	lhu	a3,44(s0)
    8000f720:	ff800513          	li	a0,-8
    8000f724:	4006f693          	andi	a3,a3,1024
    8000f728:	12068663          	beqz	a3,8000f854 <rt_serial_open+0x1d0>
    8000f72c:	0404f693          	andi	a3,s1,64
    8000f730:	04000913          	li	s2,64
    8000f734:	00069a63          	bnez	a3,8000f748 <rt_serial_open+0xc4>
    8000f738:	02e45903          	lhu	s2,46(s0)
    8000f73c:	04097913          	andi	s2,s2,64
    8000f740:	00090463          	beqz	s2,8000f748 <rt_serial_open+0xc4>
    8000f744:	04000913          	li	s2,64
    8000f748:	09043683          	ld	a3,144(s0)
    8000f74c:	0ff4f493          	zext.b	s1,s1
    8000f750:	02941723          	sh	s1,46(s0)
    8000f754:	1e069a63          	bnez	a3,8000f948 <rt_serial_open+0x2c4>
    8000f758:	10078e63          	beqz	a5,8000f874 <rt_serial_open+0x1f0>
    8000f75c:	08843503          	ld	a0,136(s0)
    8000f760:	02a55513          	srli	a0,a0,0x2a
    8000f764:	03051513          	slli	a0,a0,0x30
    8000f768:	03055513          	srli	a0,a0,0x30
    8000f76c:	01050513          	addi	a0,a0,16
    8000f770:	fb4f50ef          	jal	ra,80004f24 <rt_malloc>
    8000f774:	00050493          	mv	s1,a0
    8000f778:	00051e63          	bnez	a0,8000f794 <rt_serial_open+0x110>
    8000f77c:	27200613          	li	a2,626
    8000f780:	00005597          	auipc	a1,0x5
    8000f784:	ae058593          	addi	a1,a1,-1312 # 80014260 <__FUNCTION__.4>
    8000f788:	00005517          	auipc	a0,0x5
    8000f78c:	96850513          	addi	a0,a0,-1688 # 800140f0 <__FUNCTION__.6+0x18>
    8000f790:	be4f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f794:	08843603          	ld	a2,136(s0)
    8000f798:	01048513          	addi	a0,s1,16
    8000f79c:	00000593          	li	a1,0
    8000f7a0:	02a65613          	srli	a2,a2,0x2a
    8000f7a4:	03061613          	slli	a2,a2,0x30
    8000f7a8:	03065613          	srli	a2,a2,0x30
    8000f7ac:	00a4b023          	sd	a0,0(s1)
    8000f7b0:	861f60ef          	jal	ra,80006010 <rt_memset>
    8000f7b4:	0004b423          	sd	zero,8(s1)
    8000f7b8:	02e45783          	lhu	a5,46(s0)
    8000f7bc:	08943823          	sd	s1,144(s0)
    8000f7c0:	10000613          	li	a2,256
    8000f7c4:	1007e793          	ori	a5,a5,256
    8000f7c8:	02f41723          	sh	a5,46(s0)
    8000f7cc:	08043783          	ld	a5,128(s0)
    8000f7d0:	01000593          	li	a1,16
    8000f7d4:	00040513          	mv	a0,s0
    8000f7d8:	0087b783          	ld	a5,8(a5)
    8000f7dc:	000780e7          	jalr	a5
    8000f7e0:	09843783          	ld	a5,152(s0)
    8000f7e4:	1e079663          	bnez	a5,8000f9d0 <rt_serial_open+0x34c>
    8000f7e8:	160a0e63          	beqz	s4,8000f964 <rt_serial_open+0x2e0>
    8000f7ec:	01800513          	li	a0,24
    8000f7f0:	f34f50ef          	jal	ra,80004f24 <rt_malloc>
    8000f7f4:	00050493          	mv	s1,a0
    8000f7f8:	00051e63          	bnez	a0,8000f814 <rt_serial_open+0x190>
    8000f7fc:	2b100613          	li	a2,689
    8000f800:	00005597          	auipc	a1,0x5
    8000f804:	a6058593          	addi	a1,a1,-1440 # 80014260 <__FUNCTION__.4>
    8000f808:	00005517          	auipc	a0,0x5
    8000f80c:	91850513          	addi	a0,a0,-1768 # 80014120 <__FUNCTION__.6+0x48>
    8000f810:	b64f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f814:	00048513          	mv	a0,s1
    8000f818:	da0ff0ef          	jal	ra,8000edb8 <rt_completion_init>
    8000f81c:	02e45783          	lhu	a5,46(s0)
    8000f820:	08943c23          	sd	s1,152(s0)
    8000f824:	40000613          	li	a2,1024
    8000f828:	4007e793          	ori	a5,a5,1024
    8000f82c:	02f41723          	sh	a5,46(s0)
    8000f830:	08043783          	ld	a5,128(s0)
    8000f834:	01000593          	li	a1,16
    8000f838:	0087b783          	ld	a5,8(a5)
    8000f83c:	00040513          	mv	a0,s0
    8000f840:	000780e7          	jalr	a5
    8000f844:	02e45783          	lhu	a5,46(s0)
    8000f848:	00000513          	li	a0,0
    8000f84c:	00f96933          	or	s2,s2,a5
    8000f850:	03241723          	sh	s2,46(s0)
    8000f854:	02813083          	ld	ra,40(sp)
    8000f858:	02013403          	ld	s0,32(sp)
    8000f85c:	01813483          	ld	s1,24(sp)
    8000f860:	01013903          	ld	s2,16(sp)
    8000f864:	00813983          	ld	s3,8(sp)
    8000f868:	00013a03          	ld	s4,0(sp)
    8000f86c:	03010113          	addi	sp,sp,48
    8000f870:	00008067          	ret
    8000f874:	f60706e3          	beqz	a4,8000f7e0 <rt_serial_open+0x15c>
    8000f878:	08c42703          	lw	a4,140(s0)
    8000f87c:	040007b7          	lui	a5,0x4000
    8000f880:	c0078793          	addi	a5,a5,-1024 # 3fffc00 <__STACKSIZE__+0x3ffbc00>
    8000f884:	00e7f7b3          	and	a5,a5,a4
    8000f888:	04079263          	bnez	a5,8000f8cc <rt_serial_open+0x248>
    8000f88c:	00400513          	li	a0,4
    8000f890:	e94f50ef          	jal	ra,80004f24 <rt_malloc>
    8000f894:	00050493          	mv	s1,a0
    8000f898:	00051e63          	bnez	a0,8000f8b4 <rt_serial_open+0x230>
    8000f89c:	28500613          	li	a2,645
    8000f8a0:	00005597          	auipc	a1,0x5
    8000f8a4:	9c058593          	addi	a1,a1,-1600 # 80014260 <__FUNCTION__.4>
    8000f8a8:	00005517          	auipc	a0,0x5
    8000f8ac:	86050513          	addi	a0,a0,-1952 # 80014108 <__FUNCTION__.6+0x30>
    8000f8b0:	ac4f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f8b4:	0004a023          	sw	zero,0(s1)
    8000f8b8:	08943823          	sd	s1,144(s0)
    8000f8bc:	02e45783          	lhu	a5,46(s0)
    8000f8c0:	2007e793          	ori	a5,a5,512
    8000f8c4:	02f41723          	sh	a5,46(s0)
    8000f8c8:	f19ff06f          	j	8000f7e0 <rt_serial_open+0x15c>
    8000f8cc:	08843503          	ld	a0,136(s0)
    8000f8d0:	02a55513          	srli	a0,a0,0x2a
    8000f8d4:	03051513          	slli	a0,a0,0x30
    8000f8d8:	03055513          	srli	a0,a0,0x30
    8000f8dc:	01050513          	addi	a0,a0,16
    8000f8e0:	e44f50ef          	jal	ra,80004f24 <rt_malloc>
    8000f8e4:	00050493          	mv	s1,a0
    8000f8e8:	00051e63          	bnez	a0,8000f904 <rt_serial_open+0x280>
    8000f8ec:	28e00613          	li	a2,654
    8000f8f0:	00005597          	auipc	a1,0x5
    8000f8f4:	97058593          	addi	a1,a1,-1680 # 80014260 <__FUNCTION__.4>
    8000f8f8:	00004517          	auipc	a0,0x4
    8000f8fc:	7f850513          	addi	a0,a0,2040 # 800140f0 <__FUNCTION__.6+0x18>
    8000f900:	a74f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f904:	08843603          	ld	a2,136(s0)
    8000f908:	01048513          	addi	a0,s1,16
    8000f90c:	00a4b023          	sd	a0,0(s1)
    8000f910:	02a65613          	srli	a2,a2,0x2a
    8000f914:	03061613          	slli	a2,a2,0x30
    8000f918:	03065613          	srli	a2,a2,0x30
    8000f91c:	00000593          	li	a1,0
    8000f920:	ef0f60ef          	jal	ra,80006010 <rt_memset>
    8000f924:	0004b423          	sd	zero,8(s1)
    8000f928:	08043783          	ld	a5,128(s0)
    8000f92c:	08943823          	sd	s1,144(s0)
    8000f930:	20000613          	li	a2,512
    8000f934:	0087b783          	ld	a5,8(a5)
    8000f938:	00300593          	li	a1,3
    8000f93c:	00040513          	mv	a0,s0
    8000f940:	000780e7          	jalr	a5
    8000f944:	f79ff06f          	j	8000f8bc <rt_serial_open+0x238>
    8000f948:	00078863          	beqz	a5,8000f958 <rt_serial_open+0x2d4>
    8000f94c:	1004e493          	ori	s1,s1,256
    8000f950:	02941723          	sh	s1,46(s0)
    8000f954:	e8dff06f          	j	8000f7e0 <rt_serial_open+0x15c>
    8000f958:	e80704e3          	beqz	a4,8000f7e0 <rt_serial_open+0x15c>
    8000f95c:	2004e493          	ori	s1,s1,512
    8000f960:	ff1ff06f          	j	8000f950 <rt_serial_open+0x2cc>
    8000f964:	ee0980e3          	beqz	s3,8000f844 <rt_serial_open+0x1c0>
    8000f968:	04800513          	li	a0,72
    8000f96c:	db8f50ef          	jal	ra,80004f24 <rt_malloc>
    8000f970:	00050493          	mv	s1,a0
    8000f974:	00051e63          	bnez	a0,8000f990 <rt_serial_open+0x30c>
    8000f978:	2c000613          	li	a2,704
    8000f97c:	00005597          	auipc	a1,0x5
    8000f980:	8e458593          	addi	a1,a1,-1820 # 80014260 <__FUNCTION__.4>
    8000f984:	00004517          	auipc	a0,0x4
    8000f988:	7b450513          	addi	a0,a0,1972 # 80014138 <__FUNCTION__.6+0x60>
    8000f98c:	9e8f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000f990:	00400613          	li	a2,4
    8000f994:	00800593          	li	a1,8
    8000f998:	0004a023          	sw	zero,0(s1)
    8000f99c:	00000693          	li	a3,0
    8000f9a0:	00848513          	addi	a0,s1,8
    8000f9a4:	dccff0ef          	jal	ra,8000ef70 <rt_data_queue_init>
    8000f9a8:	02e45783          	lhu	a5,46(s0)
    8000f9ac:	00001637          	lui	a2,0x1
    8000f9b0:	80060613          	addi	a2,a2,-2048 # 800 <__STACKSIZE__-0x3800>
    8000f9b4:	00c7e7b3          	or	a5,a5,a2
    8000f9b8:	02f41723          	sh	a5,46(s0)
    8000f9bc:	08043783          	ld	a5,128(s0)
    8000f9c0:	08943c23          	sd	s1,152(s0)
    8000f9c4:	00300593          	li	a1,3
    8000f9c8:	0087b783          	ld	a5,8(a5)
    8000f9cc:	e71ff06f          	j	8000f83c <rt_serial_open+0x1b8>
    8000f9d0:	02e45783          	lhu	a5,46(s0)
    8000f9d4:	000a0863          	beqz	s4,8000f9e4 <rt_serial_open+0x360>
    8000f9d8:	4007e793          	ori	a5,a5,1024
    8000f9dc:	02f41723          	sh	a5,46(s0)
    8000f9e0:	e65ff06f          	j	8000f844 <rt_serial_open+0x1c0>
    8000f9e4:	e60980e3          	beqz	s3,8000f844 <rt_serial_open+0x1c0>
    8000f9e8:	00001737          	lui	a4,0x1
    8000f9ec:	80070713          	addi	a4,a4,-2048 # 800 <__STACKSIZE__-0x3800>
    8000f9f0:	00e7e7b3          	or	a5,a5,a4
    8000f9f4:	fe9ff06f          	j	8000f9dc <rt_serial_open+0x358>

000000008000f9f8 <rt_serial_write>:
    8000f9f8:	fc010113          	addi	sp,sp,-64
    8000f9fc:	02813823          	sd	s0,48(sp)
    8000fa00:	02913423          	sd	s1,40(sp)
    8000fa04:	01313c23          	sd	s3,24(sp)
    8000fa08:	02113c23          	sd	ra,56(sp)
    8000fa0c:	03213023          	sd	s2,32(sp)
    8000fa10:	01413823          	sd	s4,16(sp)
    8000fa14:	01513423          	sd	s5,8(sp)
    8000fa18:	01613023          	sd	s6,0(sp)
    8000fa1c:	00050413          	mv	s0,a0
    8000fa20:	00060493          	mv	s1,a2
    8000fa24:	00068993          	mv	s3,a3
    8000fa28:	00051e63          	bnez	a0,8000fa44 <rt_serial_write+0x4c>
    8000fa2c:	36100613          	li	a2,865
    8000fa30:	00004597          	auipc	a1,0x4
    8000fa34:	7e058593          	addi	a1,a1,2016 # 80014210 <__FUNCTION__.14>
    8000fa38:	00001517          	auipc	a0,0x1
    8000fa3c:	74850513          	addi	a0,a0,1864 # 80011180 <__fsym_list_mem_name+0x10>
    8000fa40:	934f70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000fa44:	04098263          	beqz	s3,8000fa88 <rt_serial_write+0x90>
    8000fa48:	02e45783          	lhu	a5,46(s0)
    8000fa4c:	0009899b          	sext.w	s3,s3
    8000fa50:	00098913          	mv	s2,s3
    8000fa54:	4007f713          	andi	a4,a5,1024
    8000fa58:	0a070e63          	beqz	a4,8000fb14 <rt_serial_write+0x11c>
    8000fa5c:	09843a03          	ld	s4,152(s0)
    8000fa60:	000a1e63          	bnez	s4,8000fa7c <rt_serial_write+0x84>
    8000fa64:	14100613          	li	a2,321
    8000fa68:	00004597          	auipc	a1,0x4
    8000fa6c:	79858593          	addi	a1,a1,1944 # 80014200 <__FUNCTION__.13>
    8000fa70:	00004517          	auipc	a0,0x4
    8000fa74:	6e050513          	addi	a0,a0,1760 # 80014150 <__FUNCTION__.6+0x78>
    8000fa78:	8fcf70ef          	jal	ra,80006b74 <rt_assert_handler>
    8000fa7c:	00a00b13          	li	s6,10
    8000fa80:	fff00a93          	li	s5,-1
    8000fa84:	02091863          	bnez	s2,8000fab4 <rt_serial_write+0xbc>
    8000fa88:	03813083          	ld	ra,56(sp)
    8000fa8c:	03013403          	ld	s0,48(sp)
    8000fa90:	02813483          	ld	s1,40(sp)
    8000fa94:	02013903          	ld	s2,32(sp)
    8000fa98:	01013a03          	ld	s4,16(sp)
    8000fa9c:	00813a83          	ld	s5,8(sp)
    8000faa0:	00013b03          	ld	s6,0(sp)
    8000faa4:	00098513          	mv	a0,s3
    8000faa8:	01813983          	ld	s3,24(sp)
    8000faac:	04010113          	addi	sp,sp,64
    8000fab0:	00008067          	ret
    8000fab4:	0004c783          	lbu	a5,0(s1)
    8000fab8:	03679c63          	bne	a5,s6,8000faf0 <rt_serial_write+0xf8>
    8000fabc:	02e45783          	lhu	a5,46(s0)
    8000fac0:	0407f793          	andi	a5,a5,64
    8000fac4:	02078663          	beqz	a5,8000faf0 <rt_serial_write+0xf8>
    8000fac8:	08043783          	ld	a5,128(s0)
    8000facc:	00d00593          	li	a1,13
    8000fad0:	00040513          	mv	a0,s0
    8000fad4:	0107b783          	ld	a5,16(a5)
    8000fad8:	000780e7          	jalr	a5
    8000fadc:	01551a63          	bne	a0,s5,8000faf0 <rt_serial_write+0xf8>
    8000fae0:	fff00593          	li	a1,-1
    8000fae4:	000a0513          	mv	a0,s4
    8000fae8:	b20ff0ef          	jal	ra,8000ee08 <rt_completion_wait>
    8000faec:	f99ff06f          	j	8000fa84 <rt_serial_write+0x8c>
    8000faf0:	08043783          	ld	a5,128(s0)
    8000faf4:	0004c583          	lbu	a1,0(s1)
    8000faf8:	00040513          	mv	a0,s0
    8000fafc:	0107b783          	ld	a5,16(a5)
    8000fb00:	000780e7          	jalr	a5
    8000fb04:	fd550ee3          	beq	a0,s5,8000fae0 <rt_serial_write+0xe8>
    8000fb08:	00148493          	addi	s1,s1,1
    8000fb0c:	fff9091b          	addiw	s2,s2,-1
    8000fb10:	f75ff06f          	j	8000fa84 <rt_serial_write+0x8c>
    8000fb14:	00b7d793          	srli	a5,a5,0xb
    8000fb18:	0017f793          	andi	a5,a5,1
    8000fb1c:	00a00a13          	li	s4,10
    8000fb20:	0a078a63          	beqz	a5,8000fbd4 <rt_serial_write+0x1dc>
    8000fb24:	09843983          	ld	s3,152(s0)
    8000fb28:	fff00693          	li	a3,-1
    8000fb2c:	00090613          	mv	a2,s2
    8000fb30:	00048593          	mv	a1,s1
    8000fb34:	00898513          	addi	a0,s3,8
    8000fb38:	d08ff0ef          	jal	ra,8000f040 <rt_data_queue_push>
    8000fb3c:	04051463          	bnez	a0,8000fb84 <rt_serial_write+0x18c>
    8000fb40:	d10f00ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000fb44:	0009a703          	lw	a4,0(s3)
    8000fb48:	00100793          	li	a5,1
    8000fb4c:	02f70863          	beq	a4,a5,8000fb7c <rt_serial_write+0x184>
    8000fb50:	00f9a023          	sw	a5,0(s3)
    8000fb54:	d04f00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000fb58:	08043783          	ld	a5,128(s0)
    8000fb5c:	00200693          	li	a3,2
    8000fb60:	00090613          	mv	a2,s2
    8000fb64:	0207b783          	ld	a5,32(a5)
    8000fb68:	00048593          	mv	a1,s1
    8000fb6c:	00040513          	mv	a0,s0
    8000fb70:	000780e7          	jalr	a5
    8000fb74:	00090993          	mv	s3,s2
    8000fb78:	f11ff06f          	j	8000fa88 <rt_serial_write+0x90>
    8000fb7c:	cdcf00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000fb80:	ff5ff06f          	j	8000fb74 <rt_serial_write+0x17c>
    8000fb84:	c4cf60ef          	jal	ra,80005fd0 <rt_set_errno>
    8000fb88:	00000913          	li	s2,0
    8000fb8c:	fe9ff06f          	j	8000fb74 <rt_serial_write+0x17c>
    8000fb90:	0004c783          	lbu	a5,0(s1)
    8000fb94:	03479263          	bne	a5,s4,8000fbb8 <rt_serial_write+0x1c0>
    8000fb98:	02e45783          	lhu	a5,46(s0)
    8000fb9c:	0407f793          	andi	a5,a5,64
    8000fba0:	00078c63          	beqz	a5,8000fbb8 <rt_serial_write+0x1c0>
    8000fba4:	08043783          	ld	a5,128(s0)
    8000fba8:	00d00593          	li	a1,13
    8000fbac:	00040513          	mv	a0,s0
    8000fbb0:	0107b783          	ld	a5,16(a5)
    8000fbb4:	000780e7          	jalr	a5
    8000fbb8:	08043783          	ld	a5,128(s0)
    8000fbbc:	0004c583          	lbu	a1,0(s1)
    8000fbc0:	00040513          	mv	a0,s0
    8000fbc4:	0107b783          	ld	a5,16(a5)
    8000fbc8:	00148493          	addi	s1,s1,1
    8000fbcc:	fff9091b          	addiw	s2,s2,-1
    8000fbd0:	000780e7          	jalr	a5
    8000fbd4:	fa091ee3          	bnez	s2,8000fb90 <rt_serial_write+0x198>
    8000fbd8:	eb1ff06f          	j	8000fa88 <rt_serial_write+0x90>

000000008000fbdc <rt_serial_read>:
    8000fbdc:	fc010113          	addi	sp,sp,-64
    8000fbe0:	02813823          	sd	s0,48(sp)
    8000fbe4:	02913423          	sd	s1,40(sp)
    8000fbe8:	03213023          	sd	s2,32(sp)
    8000fbec:	02113c23          	sd	ra,56(sp)
    8000fbf0:	01313c23          	sd	s3,24(sp)
    8000fbf4:	01413823          	sd	s4,16(sp)
    8000fbf8:	01513423          	sd	s5,8(sp)
    8000fbfc:	01613023          	sd	s6,0(sp)
    8000fc00:	00050413          	mv	s0,a0
    8000fc04:	00060913          	mv	s2,a2
    8000fc08:	00068493          	mv	s1,a3
    8000fc0c:	00051e63          	bnez	a0,8000fc28 <rt_serial_read+0x4c>
    8000fc10:	34700613          	li	a2,839
    8000fc14:	00004597          	auipc	a1,0x4
    8000fc18:	5dc58593          	addi	a1,a1,1500 # 800141f0 <__FUNCTION__.11>
    8000fc1c:	00001517          	auipc	a0,0x1
    8000fc20:	56450513          	addi	a0,a0,1380 # 80011180 <__fsym_list_mem_name+0x10>
    8000fc24:	f51f60ef          	jal	ra,80006b74 <rt_assert_handler>
    8000fc28:	06048463          	beqz	s1,8000fc90 <rt_serial_read+0xb4>
    8000fc2c:	02e45783          	lhu	a5,46(s0)
    8000fc30:	0004849b          	sext.w	s1,s1
    8000fc34:	1007f713          	andi	a4,a5,256
    8000fc38:	0c070e63          	beqz	a4,8000fd14 <rt_serial_read+0x138>
    8000fc3c:	09043983          	ld	s3,144(s0)
    8000fc40:	00099e63          	bnez	s3,8000fc5c <rt_serial_read+0x80>
    8000fc44:	11100613          	li	a2,273
    8000fc48:	00004597          	auipc	a1,0x4
    8000fc4c:	59858593          	addi	a1,a1,1432 # 800141e0 <__FUNCTION__.10>
    8000fc50:	00004517          	auipc	a0,0x4
    8000fc54:	4a050513          	addi	a0,a0,1184 # 800140f0 <__FUNCTION__.6+0x18>
    8000fc58:	f1df60ef          	jal	ra,80006b74 <rt_assert_handler>
    8000fc5c:	00048a13          	mv	s4,s1
    8000fc60:	00100a93          	li	s5,1
    8000fc64:	020a0463          	beqz	s4,8000fc8c <rt_serial_read+0xb0>
    8000fc68:	be8f00ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000fc6c:	00a9d783          	lhu	a5,10(s3)
    8000fc70:	0089d703          	lhu	a4,8(s3)
    8000fc74:	00c9a683          	lw	a3,12(s3)
    8000fc78:	00050613          	mv	a2,a0
    8000fc7c:	04f71063          	bne	a4,a5,8000fcbc <rt_serial_read+0xe0>
    8000fc80:	0006871b          	sext.w	a4,a3
    8000fc84:	02071c63          	bnez	a4,8000fcbc <rt_serial_read+0xe0>
    8000fc88:	bd0f00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000fc8c:	414484bb          	subw	s1,s1,s4
    8000fc90:	03813083          	ld	ra,56(sp)
    8000fc94:	03013403          	ld	s0,48(sp)
    8000fc98:	02013903          	ld	s2,32(sp)
    8000fc9c:	01813983          	ld	s3,24(sp)
    8000fca0:	01013a03          	ld	s4,16(sp)
    8000fca4:	00813a83          	ld	s5,8(sp)
    8000fca8:	00013b03          	ld	s6,0(sp)
    8000fcac:	00048513          	mv	a0,s1
    8000fcb0:	02813483          	ld	s1,40(sp)
    8000fcb4:	04010113          	addi	sp,sp,64
    8000fcb8:	00008067          	ret
    8000fcbc:	0009b703          	ld	a4,0(s3)
    8000fcc0:	00f70733          	add	a4,a4,a5
    8000fcc4:	00074b03          	lbu	s6,0(a4)
    8000fcc8:	08843703          	ld	a4,136(s0)
    8000fccc:	0017879b          	addiw	a5,a5,1
    8000fcd0:	03079793          	slli	a5,a5,0x30
    8000fcd4:	02a75713          	srli	a4,a4,0x2a
    8000fcd8:	0307d793          	srli	a5,a5,0x30
    8000fcdc:	03071713          	slli	a4,a4,0x30
    8000fce0:	00f99523          	sh	a5,10(s3)
    8000fce4:	03075713          	srli	a4,a4,0x30
    8000fce8:	00e7e463          	bltu	a5,a4,8000fcf0 <rt_serial_read+0x114>
    8000fcec:	00099523          	sh	zero,10(s3)
    8000fcf0:	0006869b          	sext.w	a3,a3
    8000fcf4:	01569463          	bne	a3,s5,8000fcfc <rt_serial_read+0x120>
    8000fcf8:	0009a623          	sw	zero,12(s3)
    8000fcfc:	00060513          	mv	a0,a2
    8000fd00:	b58f00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000fd04:	00190913          	addi	s2,s2,1
    8000fd08:	ff690fa3          	sb	s6,-1(s2)
    8000fd0c:	fffa0a1b          	addiw	s4,s4,-1
    8000fd10:	f55ff06f          	j	8000fc64 <rt_serial_read+0x88>
    8000fd14:	2007f793          	andi	a5,a5,512
    8000fd18:	00048993          	mv	s3,s1
    8000fd1c:	04079463          	bnez	a5,8000fd64 <rt_serial_read+0x188>
    8000fd20:	fff00a13          	li	s4,-1
    8000fd24:	00a00a93          	li	s5,10
    8000fd28:	02098a63          	beqz	s3,8000fd5c <rt_serial_read+0x180>
    8000fd2c:	08043783          	ld	a5,128(s0)
    8000fd30:	00040513          	mv	a0,s0
    8000fd34:	0187b783          	ld	a5,24(a5)
    8000fd38:	000780e7          	jalr	a5
    8000fd3c:	03450063          	beq	a0,s4,8000fd5c <rt_serial_read+0x180>
    8000fd40:	00a90023          	sb	a0,0(s2)
    8000fd44:	02e45783          	lhu	a5,46(s0)
    8000fd48:	00190913          	addi	s2,s2,1
    8000fd4c:	fff9899b          	addiw	s3,s3,-1
    8000fd50:	0407f793          	andi	a5,a5,64
    8000fd54:	fc078ae3          	beqz	a5,8000fd28 <rt_serial_read+0x14c>
    8000fd58:	fd5518e3          	bne	a0,s5,8000fd28 <rt_serial_read+0x14c>
    8000fd5c:	413484bb          	subw	s1,s1,s3
    8000fd60:	f31ff06f          	j	8000fc90 <rt_serial_read+0xb4>
    8000fd64:	00091e63          	bnez	s2,8000fd80 <rt_serial_read+0x1a4>
    8000fd68:	1df00613          	li	a2,479
    8000fd6c:	00004597          	auipc	a1,0x4
    8000fd70:	55458593          	addi	a1,a1,1364 # 800142c0 <__FUNCTION__.9>
    8000fd74:	00004517          	auipc	a0,0x4
    8000fd78:	3ec50513          	addi	a0,a0,1004 # 80014160 <__FUNCTION__.6+0x88>
    8000fd7c:	df9f60ef          	jal	ra,80006b74 <rt_assert_handler>
    8000fd80:	ad0f00ef          	jal	ra,80000050 <rt_hw_interrupt_disable>
    8000fd84:	08c42703          	lw	a4,140(s0)
    8000fd88:	040007b7          	lui	a5,0x4000
    8000fd8c:	c0078793          	addi	a5,a5,-1024 # 3fffc00 <__STACKSIZE__+0x3ffbc00>
    8000fd90:	00e7f7b3          	and	a5,a5,a4
    8000fd94:	09043a83          	ld	s5,144(s0)
    8000fd98:	00050a13          	mv	s4,a0
    8000fd9c:	08079a63          	bnez	a5,8000fe30 <rt_serial_read+0x254>
    8000fda0:	000a9e63          	bnez	s5,8000fdbc <rt_serial_read+0x1e0>
    8000fda4:	1e900613          	li	a2,489
    8000fda8:	00004597          	auipc	a1,0x4
    8000fdac:	51858593          	addi	a1,a1,1304 # 800142c0 <__FUNCTION__.9>
    8000fdb0:	00004517          	auipc	a0,0x4
    8000fdb4:	35850513          	addi	a0,a0,856 # 80014108 <__FUNCTION__.6+0x30>
    8000fdb8:	dbdf60ef          	jal	ra,80006b74 <rt_assert_handler>
    8000fdbc:	000aa703          	lw	a4,0(s5)
    8000fdc0:	00100793          	li	a5,1
    8000fdc4:	ff900993          	li	s3,-7
    8000fdc8:	04f70663          	beq	a4,a5,8000fe14 <rt_serial_read+0x238>
    8000fdcc:	00faa023          	sw	a5,0(s5)
    8000fdd0:	08043783          	ld	a5,128(s0)
    8000fdd4:	0207b783          	ld	a5,32(a5)
    8000fdd8:	00079e63          	bnez	a5,8000fdf4 <rt_serial_read+0x218>
    8000fddc:	1ee00613          	li	a2,494
    8000fde0:	00004597          	auipc	a1,0x4
    8000fde4:	4e058593          	addi	a1,a1,1248 # 800142c0 <__FUNCTION__.9>
    8000fde8:	00004517          	auipc	a0,0x4
    8000fdec:	3a850513          	addi	a0,a0,936 # 80014190 <__FUNCTION__.6+0xb8>
    8000fdf0:	d85f60ef          	jal	ra,80006b74 <rt_assert_handler>
    8000fdf4:	08043783          	ld	a5,128(s0)
    8000fdf8:	00100693          	li	a3,1
    8000fdfc:	00048613          	mv	a2,s1
    8000fe00:	0207b783          	ld	a5,32(a5)
    8000fe04:	00090593          	mv	a1,s2
    8000fe08:	00040513          	mv	a0,s0
    8000fe0c:	000780e7          	jalr	a5
    8000fe10:	00000993          	li	s3,0
    8000fe14:	000a0513          	mv	a0,s4
    8000fe18:	a40f00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000fe1c:	e6098ae3          	beqz	s3,8000fc90 <rt_serial_read+0xb4>
    8000fe20:	00098513          	mv	a0,s3
    8000fe24:	9acf60ef          	jal	ra,80005fd0 <rt_set_errno>
    8000fe28:	00000493          	li	s1,0
    8000fe2c:	e65ff06f          	j	8000fc90 <rt_serial_read+0xb4>
    8000fe30:	00040513          	mv	a0,s0
    8000fe34:	f4cff0ef          	jal	ra,8000f580 <_serial_fifo_calc_recved_len>
    8000fe38:	00050993          	mv	s3,a0
    8000fe3c:	000a9e63          	bnez	s5,8000fe58 <rt_serial_read+0x27c>
    8000fe40:	1fe00613          	li	a2,510
    8000fe44:	00004597          	auipc	a1,0x4
    8000fe48:	47c58593          	addi	a1,a1,1148 # 800142c0 <__FUNCTION__.9>
    8000fe4c:	00004517          	auipc	a0,0x4
    8000fe50:	2a450513          	addi	a0,a0,676 # 800140f0 <__FUNCTION__.6+0x18>
    8000fe54:	d21f60ef          	jal	ra,80006b74 <rt_assert_handler>
    8000fe58:	0009879b          	sext.w	a5,s3
    8000fe5c:	00f4d463          	bge	s1,a5,8000fe64 <rt_serial_read+0x288>
    8000fe60:	00048993          	mv	s3,s1
    8000fe64:	08843783          	ld	a5,136(s0)
    8000fe68:	00aad603          	lhu	a2,10(s5)
    8000fe6c:	000ab583          	ld	a1,0(s5)
    8000fe70:	02a7d793          	srli	a5,a5,0x2a
    8000fe74:	03079793          	slli	a5,a5,0x30
    8000fe78:	0307d793          	srli	a5,a5,0x30
    8000fe7c:	01360733          	add	a4,a2,s3
    8000fe80:	00c585b3          	add	a1,a1,a2
    8000fe84:	0af77263          	bgeu	a4,a5,8000ff28 <rt_serial_read+0x34c>
    8000fe88:	00098613          	mv	a2,s3
    8000fe8c:	00090513          	mv	a0,s2
    8000fe90:	a44f60ef          	jal	ra,800060d4 <rt_memcpy>
    8000fe94:	09043483          	ld	s1,144(s0)
    8000fe98:	00049e63          	bnez	s1,8000feb4 <rt_serial_read+0x2d8>
    8000fe9c:	19c00613          	li	a2,412
    8000fea0:	00004597          	auipc	a1,0x4
    8000fea4:	3e058593          	addi	a1,a1,992 # 80014280 <__FUNCTION__.7>
    8000fea8:	00004517          	auipc	a0,0x4
    8000feac:	24850513          	addi	a0,a0,584 # 800140f0 <__FUNCTION__.6+0x18>
    8000feb0:	cc5f60ef          	jal	ra,80006b74 <rt_assert_handler>
    8000feb4:	00040513          	mv	a0,s0
    8000feb8:	ec8ff0ef          	jal	ra,8000f580 <_serial_fifo_calc_recved_len>
    8000febc:	01357e63          	bgeu	a0,s3,8000fed8 <rt_serial_read+0x2fc>
    8000fec0:	19d00613          	li	a2,413
    8000fec4:	00004597          	auipc	a1,0x4
    8000fec8:	3bc58593          	addi	a1,a1,956 # 80014280 <__FUNCTION__.7>
    8000fecc:	00004517          	auipc	a0,0x4
    8000fed0:	2ec50513          	addi	a0,a0,748 # 800141b8 <__FUNCTION__.6+0xe0>
    8000fed4:	ca1f60ef          	jal	ra,80006b74 <rt_assert_handler>
    8000fed8:	00c4a783          	lw	a5,12(s1)
    8000fedc:	00078663          	beqz	a5,8000fee8 <rt_serial_read+0x30c>
    8000fee0:	00098463          	beqz	s3,8000fee8 <rt_serial_read+0x30c>
    8000fee4:	0004a623          	sw	zero,12(s1)
    8000fee8:	00a4d783          	lhu	a5,10(s1)
    8000feec:	08843703          	ld	a4,136(s0)
    8000fef0:	013787bb          	addw	a5,a5,s3
    8000fef4:	03079793          	slli	a5,a5,0x30
    8000fef8:	02a75713          	srli	a4,a4,0x2a
    8000fefc:	0307d793          	srli	a5,a5,0x30
    8000ff00:	03071713          	slli	a4,a4,0x30
    8000ff04:	00f49523          	sh	a5,10(s1)
    8000ff08:	03075713          	srli	a4,a4,0x30
    8000ff0c:	00e7e663          	bltu	a5,a4,8000ff18 <rt_serial_read+0x33c>
    8000ff10:	02e7f7bb          	remuw	a5,a5,a4
    8000ff14:	00f49523          	sh	a5,10(s1)
    8000ff18:	000a0513          	mv	a0,s4
    8000ff1c:	93cf00ef          	jal	ra,80000058 <rt_hw_interrupt_enable>
    8000ff20:	0009849b          	sext.w	s1,s3
    8000ff24:	d6dff06f          	j	8000fc90 <rt_serial_read+0xb4>
    8000ff28:	40c7863b          	subw	a2,a5,a2
    8000ff2c:	00090513          	mv	a0,s2
    8000ff30:	9a4f60ef          	jal	ra,800060d4 <rt_memcpy>
    8000ff34:	08843783          	ld	a5,136(s0)
    8000ff38:	00aad503          	lhu	a0,10(s5)
    8000ff3c:	000ab583          	ld	a1,0(s5)
    8000ff40:	02a7d793          	srli	a5,a5,0x2a
    8000ff44:	03079793          	slli	a5,a5,0x30
    8000ff48:	0307d793          	srli	a5,a5,0x30
    8000ff4c:	40f50633          	sub	a2,a0,a5
    8000ff50:	40a78533          	sub	a0,a5,a0
    8000ff54:	01360633          	add	a2,a2,s3
    8000ff58:	00a90533          	add	a0,s2,a0
    8000ff5c:	f35ff06f          	j	8000fe90 <rt_serial_read+0x2b4>

000000008000ff60 <rt_serial_close>:
    8000ff60:	fe010113          	addi	sp,sp,-32
    8000ff64:	00813823          	sd	s0,16(sp)
    8000ff68:	00113c23          	sd	ra,24(sp)
    8000ff6c:	00913423          	sd	s1,8(sp)
    8000ff70:	00050413          	mv	s0,a0
    8000ff74:	00051e63          	bnez	a0,8000ff90 <rt_serial_close+0x30>
    8000ff78:	2e400613          	li	a2,740
    8000ff7c:	00004597          	auipc	a1,0x4
    8000ff80:	2f458593          	addi	a1,a1,756 # 80014270 <__FUNCTION__.5>
    8000ff84:	00001517          	auipc	a0,0x1
    8000ff88:	1fc50513          	addi	a0,a0,508 # 80011180 <__fsym_list_mem_name+0x10>
    8000ff8c:	be9f60ef          	jal	ra,80006b74 <rt_assert_handler>
    8000ff90:	03044703          	lbu	a4,48(s0)
    8000ff94:	00100793          	li	a5,1
    8000ff98:	0ce7e663          	bltu	a5,a4,80010064 <rt_serial_close+0x104>
    8000ff9c:	02e45783          	lhu	a5,46(s0)
    8000ffa0:	08043703          	ld	a4,128(s0)
    8000ffa4:	1007f693          	andi	a3,a5,256
    8000ffa8:	00873703          	ld	a4,8(a4)
    8000ffac:	0c068863          	beqz	a3,8001007c <rt_serial_close+0x11c>
    8000ffb0:	10000613          	li	a2,256
    8000ffb4:	01100593          	li	a1,17
    8000ffb8:	00040513          	mv	a0,s0
    8000ffbc:	000700e7          	jalr	a4
    8000ffc0:	02e45783          	lhu	a5,46(s0)
    8000ffc4:	09043483          	ld	s1,144(s0)
    8000ffc8:	2f300613          	li	a2,755
    8000ffcc:	eff7f793          	andi	a5,a5,-257
    8000ffd0:	02f41723          	sh	a5,46(s0)
    8000ffd4:	10048663          	beqz	s1,800100e0 <rt_serial_close+0x180>
    8000ffd8:	00048513          	mv	a0,s1
    8000ffdc:	a94f50ef          	jal	ra,80005270 <rt_free>
    8000ffe0:	08043823          	sd	zero,144(s0)
    8000ffe4:	02e45783          	lhu	a5,46(s0)
    8000ffe8:	08043703          	ld	a4,128(s0)
    8000ffec:	4007f693          	andi	a3,a5,1024
    8000fff0:	00873703          	ld	a4,8(a4)
    8000fff4:	10068063          	beqz	a3,800100f4 <rt_serial_close+0x194>
    8000fff8:	40000613          	li	a2,1024
    8000fffc:	01100593          	li	a1,17
    80010000:	00040513          	mv	a0,s0
    80010004:	000700e7          	jalr	a4
    80010008:	02e45783          	lhu	a5,46(s0)
    8001000c:	09843483          	ld	s1,152(s0)
    80010010:	bff7f793          	andi	a5,a5,-1025
    80010014:	02f41723          	sh	a5,46(s0)
    80010018:	00049e63          	bnez	s1,80010034 <rt_serial_close+0xd4>
    8001001c:	31f00613          	li	a2,799
    80010020:	00004597          	auipc	a1,0x4
    80010024:	25058593          	addi	a1,a1,592 # 80014270 <__FUNCTION__.5>
    80010028:	00004517          	auipc	a0,0x4
    8001002c:	0f850513          	addi	a0,a0,248 # 80014120 <__FUNCTION__.6+0x48>
    80010030:	b45f60ef          	jal	ra,80006b74 <rt_assert_handler>
    80010034:	00048513          	mv	a0,s1
    80010038:	a38f50ef          	jal	ra,80005270 <rt_free>
    8001003c:	08043c23          	sd	zero,152(s0)
    80010040:	08043783          	ld	a5,128(s0)
    80010044:	00000613          	li	a2,0
    80010048:	00400593          	li	a1,4
    8001004c:	0087b783          	ld	a5,8(a5)
    80010050:	00040513          	mv	a0,s0
    80010054:	000780e7          	jalr	a5
    80010058:	02c45783          	lhu	a5,44(s0)
    8001005c:	fef7f793          	andi	a5,a5,-17
    80010060:	02f41623          	sh	a5,44(s0)
    80010064:	01813083          	ld	ra,24(sp)
    80010068:	01013403          	ld	s0,16(sp)
    8001006c:	00813483          	ld	s1,8(sp)
    80010070:	00000513          	li	a0,0
    80010074:	02010113          	addi	sp,sp,32
    80010078:	00008067          	ret
    8001007c:	2007f793          	andi	a5,a5,512
    80010080:	f60782e3          	beqz	a5,8000ffe4 <rt_serial_close+0x84>
    80010084:	20000613          	li	a2,512
    80010088:	01100593          	li	a1,17
    8001008c:	00040513          	mv	a0,s0
    80010090:	000700e7          	jalr	a4
    80010094:	02e45783          	lhu	a5,46(s0)
    80010098:	08c42703          	lw	a4,140(s0)
    8001009c:	09043483          	ld	s1,144(s0)
    800100a0:	dff7f793          	andi	a5,a5,-513
    800100a4:	02f41723          	sh	a5,46(s0)
    800100a8:	040007b7          	lui	a5,0x4000
    800100ac:	c0078793          	addi	a5,a5,-1024 # 3fffc00 <__STACKSIZE__+0x3ffbc00>
    800100b0:	00e7f7b3          	and	a5,a5,a4
    800100b4:	02079263          	bnez	a5,800100d8 <rt_serial_close+0x178>
    800100b8:	f20490e3          	bnez	s1,8000ffd8 <rt_serial_close+0x78>
    800100bc:	30500613          	li	a2,773
    800100c0:	00004597          	auipc	a1,0x4
    800100c4:	1b058593          	addi	a1,a1,432 # 80014270 <__FUNCTION__.5>
    800100c8:	00004517          	auipc	a0,0x4
    800100cc:	04050513          	addi	a0,a0,64 # 80014108 <__FUNCTION__.6+0x30>
    800100d0:	aa5f60ef          	jal	ra,80006b74 <rt_assert_handler>
    800100d4:	f05ff06f          	j	8000ffd8 <rt_serial_close+0x78>
    800100d8:	f00490e3          	bnez	s1,8000ffd8 <rt_serial_close+0x78>
    800100dc:	30e00613          	li	a2,782
    800100e0:	00004597          	auipc	a1,0x4
    800100e4:	19058593          	addi	a1,a1,400 # 80014270 <__FUNCTION__.5>
    800100e8:	00004517          	auipc	a0,0x4
    800100ec:	00850513          	addi	a0,a0,8 # 800140f0 <__FUNCTION__.6+0x18>
    800100f0:	fe1ff06f          	j	800100d0 <rt_serial_close+0x170>
    800100f4:	00001637          	lui	a2,0x1
    800100f8:	80060613          	addi	a2,a2,-2048 # 800 <__STACKSIZE__-0x3800>
    800100fc:	00c7f7b3          	and	a5,a5,a2
    80010100:	f40780e3          	beqz	a5,80010040 <rt_serial_close+0xe0>
    80010104:	01100593          	li	a1,17
    80010108:	00040513          	mv	a0,s0
    8001010c:	000700e7          	jalr	a4
    80010110:	02e45783          	lhu	a5,46(s0)
    80010114:	fffff737          	lui	a4,0xfffff
    80010118:	7ff70713          	addi	a4,a4,2047 # fffffffffffff7ff <__bss_end+0xffffffff7ffd8c3f>
    8001011c:	09843483          	ld	s1,152(s0)
    80010120:	00e7f7b3          	and	a5,a5,a4
    80010124:	02f41723          	sh	a5,46(s0)
    80010128:	00049e63          	bnez	s1,80010144 <rt_serial_close+0x1e4>
    8001012c:	33000613          	li	a2,816
    80010130:	00004597          	auipc	a1,0x4
    80010134:	14058593          	addi	a1,a1,320 # 80014270 <__FUNCTION__.5>
    80010138:	00004517          	auipc	a0,0x4
    8001013c:	00050513          	mv	a0,a0
    80010140:	a35f60ef          	jal	ra,80006b74 <rt_assert_handler>
    80010144:	00848513          	addi	a0,s1,8
    80010148:	aa0ff0ef          	jal	ra,8000f3e8 <rt_data_queue_deinit>
    8001014c:	ee9ff06f          	j	80010034 <rt_serial_close+0xd4>

0000000080010150 <rt_hw_serial_register>:
    80010150:	fd010113          	addi	sp,sp,-48
    80010154:	02813023          	sd	s0,32(sp)
    80010158:	00913c23          	sd	s1,24(sp)
    8001015c:	01213823          	sd	s2,16(sp)
    80010160:	01313423          	sd	s3,8(sp)
    80010164:	02113423          	sd	ra,40(sp)
    80010168:	00050413          	mv	s0,a0
    8001016c:	00058493          	mv	s1,a1
    80010170:	00060913          	mv	s2,a2
    80010174:	00068993          	mv	s3,a3
    80010178:	00051e63          	bnez	a0,80010194 <rt_hw_serial_register+0x44>
    8001017c:	49b00613          	li	a2,1179
    80010180:	00004597          	auipc	a1,0x4
    80010184:	0b858593          	addi	a1,a1,184 # 80014238 <__FUNCTION__.16>
    80010188:	00001517          	auipc	a0,0x1
    8001018c:	8f850513          	addi	a0,a0,-1800 # 80010a80 <__fsym___cmd_reboot_name+0x10>
    80010190:	9e5f60ef          	jal	ra,80006b74 <rt_assert_handler>
    80010194:	fffff797          	auipc	a5,0xfffff
    80010198:	48478793          	addi	a5,a5,1156 # 8000f618 <rt_serial_init>
    8001019c:	04f43423          	sd	a5,72(s0)
    800101a0:	fffff797          	auipc	a5,0xfffff
    800101a4:	4e478793          	addi	a5,a5,1252 # 8000f684 <rt_serial_open>
    800101a8:	04f43823          	sd	a5,80(s0)
    800101ac:	00000797          	auipc	a5,0x0
    800101b0:	db478793          	addi	a5,a5,-588 # 8000ff60 <rt_serial_close>
    800101b4:	04f43c23          	sd	a5,88(s0)
    800101b8:	00000797          	auipc	a5,0x0
    800101bc:	a2478793          	addi	a5,a5,-1500 # 8000fbdc <rt_serial_read>
    800101c0:	06f43023          	sd	a5,96(s0)
    800101c4:	00000797          	auipc	a5,0x0
    800101c8:	83478793          	addi	a5,a5,-1996 # 8000f9f8 <rt_serial_write>
    800101cc:	06f43423          	sd	a5,104(s0)
    800101d0:	fffff797          	auipc	a5,0xfffff
    800101d4:	29c78793          	addi	a5,a5,668 # 8000f46c <rt_serial_control>
    800101d8:	07343c23          	sd	s3,120(s0)
    800101dc:	02042423          	sw	zero,40(s0)
    800101e0:	02043c23          	sd	zero,56(s0)
    800101e4:	04043023          	sd	zero,64(s0)
    800101e8:	06f43823          	sd	a5,112(s0)
    800101ec:	00040513          	mv	a0,s0
    800101f0:	02013403          	ld	s0,32(sp)
    800101f4:	02813083          	ld	ra,40(sp)
    800101f8:	00813983          	ld	s3,8(sp)
    800101fc:	03091613          	slli	a2,s2,0x30
    80010200:	00048593          	mv	a1,s1
    80010204:	01013903          	ld	s2,16(sp)
    80010208:	01813483          	ld	s1,24(sp)
    8001020c:	03065613          	srli	a2,a2,0x30
    80010210:	03010113          	addi	sp,sp,48
    80010214:	c70f506f          	j	80005684 <rt_device_register>

0000000080010218 <rt_pin_mode>:
    80010218:	fe010113          	addi	sp,sp,-32
    8001021c:	01213023          	sd	s2,0(sp)
    80010220:	00017917          	auipc	s2,0x17
    80010224:	91890913          	addi	s2,s2,-1768 # 80026b38 <_hw_pin>
    80010228:	08093783          	ld	a5,128(s2)
    8001022c:	00813823          	sd	s0,16(sp)
    80010230:	00913423          	sd	s1,8(sp)
    80010234:	00113c23          	sd	ra,24(sp)
    80010238:	00050413          	mv	s0,a0
    8001023c:	00058493          	mv	s1,a1
    80010240:	00079e63          	bnez	a5,8001025c <rt_pin_mode+0x44>
    80010244:	08a00613          	li	a2,138
    80010248:	00004597          	auipc	a1,0x4
    8001024c:	0e058593          	addi	a1,a1,224 # 80014328 <__FUNCTION__.3>
    80010250:	00004517          	auipc	a0,0x4
    80010254:	08050513          	addi	a0,a0,128 # 800142d0 <__FUNCTION__.9+0x10>
    80010258:	91df60ef          	jal	ra,80006b74 <rt_assert_handler>
    8001025c:	08093783          	ld	a5,128(s2)
    80010260:	00040593          	mv	a1,s0
    80010264:	01013403          	ld	s0,16(sp)
    80010268:	01813083          	ld	ra,24(sp)
    8001026c:	00013903          	ld	s2,0(sp)
    80010270:	0007b783          	ld	a5,0(a5)
    80010274:	00048613          	mv	a2,s1
    80010278:	00813483          	ld	s1,8(sp)
    8001027c:	00017517          	auipc	a0,0x17
    80010280:	8bc50513          	addi	a0,a0,-1860 # 80026b38 <_hw_pin>
    80010284:	02010113          	addi	sp,sp,32
    80010288:	00078067          	jr	a5

000000008001028c <rt_pin_write>:
    8001028c:	fe010113          	addi	sp,sp,-32
    80010290:	01213023          	sd	s2,0(sp)
    80010294:	00017917          	auipc	s2,0x17
    80010298:	8a490913          	addi	s2,s2,-1884 # 80026b38 <_hw_pin>
    8001029c:	08093783          	ld	a5,128(s2)
    800102a0:	00813823          	sd	s0,16(sp)
    800102a4:	00913423          	sd	s1,8(sp)
    800102a8:	00113c23          	sd	ra,24(sp)
    800102ac:	00050413          	mv	s0,a0
    800102b0:	00058493          	mv	s1,a1
    800102b4:	00079e63          	bnez	a5,800102d0 <rt_pin_write+0x44>
    800102b8:	09100613          	li	a2,145
    800102bc:	00004597          	auipc	a1,0x4
    800102c0:	05c58593          	addi	a1,a1,92 # 80014318 <__FUNCTION__.2>
    800102c4:	00004517          	auipc	a0,0x4
    800102c8:	00c50513          	addi	a0,a0,12 # 800142d0 <__FUNCTION__.9+0x10>
    800102cc:	8a9f60ef          	jal	ra,80006b74 <rt_assert_handler>
    800102d0:	08093783          	ld	a5,128(s2)
    800102d4:	00040593          	mv	a1,s0
    800102d8:	01013403          	ld	s0,16(sp)
    800102dc:	01813083          	ld	ra,24(sp)
    800102e0:	00013903          	ld	s2,0(sp)
    800102e4:	0087b783          	ld	a5,8(a5)
    800102e8:	00048613          	mv	a2,s1
    800102ec:	00813483          	ld	s1,8(sp)
    800102f0:	00017517          	auipc	a0,0x17
    800102f4:	84850513          	addi	a0,a0,-1976 # 80026b38 <_hw_pin>
    800102f8:	02010113          	addi	sp,sp,32
    800102fc:	00078067          	jr	a5

0000000080010300 <rt_pin_read>:
    80010300:	fe010113          	addi	sp,sp,-32
    80010304:	00913423          	sd	s1,8(sp)
    80010308:	00017497          	auipc	s1,0x17
    8001030c:	83048493          	addi	s1,s1,-2000 # 80026b38 <_hw_pin>
    80010310:	0804b783          	ld	a5,128(s1)
    80010314:	00813823          	sd	s0,16(sp)
    80010318:	00113c23          	sd	ra,24(sp)
    8001031c:	00050413          	mv	s0,a0
    80010320:	00079e63          	bnez	a5,8001033c <rt_pin_read+0x3c>
    80010324:	09800613          	li	a2,152
    80010328:	00004597          	auipc	a1,0x4
    8001032c:	fe058593          	addi	a1,a1,-32 # 80014308 <__FUNCTION__.1>
    80010330:	00004517          	auipc	a0,0x4
    80010334:	fa050513          	addi	a0,a0,-96 # 800142d0 <__FUNCTION__.9+0x10>
    80010338:	83df60ef          	jal	ra,80006b74 <rt_assert_handler>
    8001033c:	0804b783          	ld	a5,128(s1)
    80010340:	00040593          	mv	a1,s0
    80010344:	01013403          	ld	s0,16(sp)
    80010348:	01813083          	ld	ra,24(sp)
    8001034c:	00813483          	ld	s1,8(sp)
    80010350:	0107b783          	ld	a5,16(a5)
    80010354:	00016517          	auipc	a0,0x16
    80010358:	7e450513          	addi	a0,a0,2020 # 80026b38 <_hw_pin>
    8001035c:	02010113          	addi	sp,sp,32
    80010360:	00078067          	jr	a5

0000000080010364 <rt_pin_get>:
    80010364:	fe010113          	addi	sp,sp,-32
    80010368:	00913423          	sd	s1,8(sp)
    8001036c:	00016497          	auipc	s1,0x16
    80010370:	7cc48493          	addi	s1,s1,1996 # 80026b38 <_hw_pin>
    80010374:	0804b783          	ld	a5,128(s1)
    80010378:	00813823          	sd	s0,16(sp)
    8001037c:	00113c23          	sd	ra,24(sp)
    80010380:	00050413          	mv	s0,a0
    80010384:	00079e63          	bnez	a5,800103a0 <rt_pin_get+0x3c>
    80010388:	09f00613          	li	a2,159
    8001038c:	00004597          	auipc	a1,0x4
    80010390:	f6c58593          	addi	a1,a1,-148 # 800142f8 <__FUNCTION__.0>
    80010394:	00004517          	auipc	a0,0x4
    80010398:	f3c50513          	addi	a0,a0,-196 # 800142d0 <__FUNCTION__.9+0x10>
    8001039c:	fd8f60ef          	jal	ra,80006b74 <rt_assert_handler>
    800103a0:	00044703          	lbu	a4,0(s0)
    800103a4:	05000793          	li	a5,80
    800103a8:	00f70e63          	beq	a4,a5,800103c4 <rt_pin_get+0x60>
    800103ac:	0a000613          	li	a2,160
    800103b0:	00004597          	auipc	a1,0x4
    800103b4:	f4858593          	addi	a1,a1,-184 # 800142f8 <__FUNCTION__.0>
    800103b8:	00004517          	auipc	a0,0x4
    800103bc:	f3050513          	addi	a0,a0,-208 # 800142e8 <__FUNCTION__.9+0x28>
    800103c0:	fb4f60ef          	jal	ra,80006b74 <rt_assert_handler>
    800103c4:	0804b783          	ld	a5,128(s1)
    800103c8:	0307b783          	ld	a5,48(a5)
    800103cc:	00078e63          	beqz	a5,800103e8 <rt_pin_get+0x84>
    800103d0:	00040513          	mv	a0,s0
    800103d4:	01013403          	ld	s0,16(sp)
    800103d8:	01813083          	ld	ra,24(sp)
    800103dc:	00813483          	ld	s1,8(sp)
    800103e0:	02010113          	addi	sp,sp,32
    800103e4:	00078067          	jr	a5
    800103e8:	01813083          	ld	ra,24(sp)
    800103ec:	01013403          	ld	s0,16(sp)
    800103f0:	00813483          	ld	s1,8(sp)
    800103f4:	ffa00513          	li	a0,-6
    800103f8:	02010113          	addi	sp,sp,32
    800103fc:	00008067          	ret
    80010400:	6574                	ld	a3,200(a0)
    80010402:	00007473          	csrrci	s0,ustatus,0
	...

0000000080010408 <k>:
    80010408:	d76aa478 e8c7b756 242070db c1bdceee     x.j.V....p $....
    80010418:	f57c0faf 4787c62a a8304613 fd469501     ..|.*..G.F0...F.
    80010428:	698098d8 8b44f7af ffff5bb1 895cd7be     ...i..D..[....\.
    80010438:	6b901122 fd987193 a679438e 49b40821     "..k.q...Cy.!..I
    80010448:	f61e2562 c040b340 265e5a51 e9b6c7aa     b%..@.@.QZ^&....
    80010458:	d62f105d 02441453 d8a1e681 e7d3fbc8     ]./.S.D.........
    80010468:	21e1cde6 c33707d6 f4d50d87 455a14ed     ...!..7.......ZE
    80010478:	a9e3e905 fcefa3f8 676f02d9 8d2a4c8a     ..........og.L*.
    80010488:	fffa3942 8771f681 6d9d6122 fde5380c     B9....q."a.m.8..
    80010498:	a4beea44 4bdecfa9 f6bb4b60 bebfbc70     D......K`K..p...
    800104a8:	289b7ec6 eaa127fa d4ef3085 04881d05     .~.(.'...0......
    800104b8:	d9d4d039 e6db99e5 1fa27cf8 c4ac5665     9........|..eV..
    800104c8:	f4292244 432aff97 ab9423a7 fc93a039     D")...*C.#..9...
    800104d8:	655b59c3 8f0ccc92 ffeff47d 85845dd1     .Y[e....}....]..
    800104e8:	6fa87e4f fe2ce6e0 a3014314 4e0811a1     O~.o..,..C.....N
    800104f8:	f7537e82 bd3af235 2ad7d2bb eb86d391     .~S.5.:....*....

0000000080010508 <r>:
    80010508:	00000007 0000000c 00000011 00000016     ................
    80010518:	00000007 0000000c 00000011 00000016     ................
    80010528:	00000007 0000000c 00000011 00000016     ................
    80010538:	00000007 0000000c 00000011 00000016     ................
    80010548:	00000005 00000009 0000000e 00000014     ................
    80010558:	00000005 00000009 0000000e 00000014     ................
    80010568:	00000005 00000009 0000000e 00000014     ................
    80010578:	00000005 00000009 0000000e 00000014     ................
    80010588:	00000004 0000000b 00000010 00000017     ................
    80010598:	00000004 0000000b 00000010 00000017     ................
    800105a8:	00000004 0000000b 00000010 00000017     ................
    800105b8:	00000004 0000000b 00000010 00000017     ................
    800105c8:	00000006 0000000a 0000000f 00000015     ................
    800105d8:	00000006 0000000a 0000000f 00000015     ................
    800105e8:	00000006 0000000a 0000000f 00000015     ................
    800105f8:	00000006 0000000a 0000000f 00000015     ................
    80010608:	302e6425 00003030 00666572 00000000     %d.000..ref.....
    80010618:	0000002a 00000000 53534150 00000000     *.......PASS....
    80010628:	4c494146 00000000 74706d45 616d2079     FAIL....Empty ma
    80010638:	72616e69 202e7367 20657355 66657222     inargs. Use "ref
    80010648:	79622022 66656420 746c7561 0000000a     " by default....
    80010658:	69617274 0000006e 65677568 00000000     train...huge....
    80010668:	61766e49 2064696c 6e69616d 73677261     Invalid mainargs
    80010678:	2522203a 203b2273 7473756d 20656220     : "%s"; must be 
    80010688:	7b206e69 74736574 7274202c 2c6e6961     in {test, train,
    80010698:	66657220 7568202c 0a7d6567 00000000      ref, huge}.....
    800106a8:	3d3d3d3d 203d3d3d 6e6e7552 20676e69     ======= Running 
    800106b8:	7263694d 6e65426f 5b206863 75706e69     MicroBench [inpu
    800106c8:	252a2074 205d2a73 3d3d3d3d 0a3d3d3d     t *%s*] =======.
	...
    800106e0:	5d73255b 3a732520 00000020 00000000     [%s] %s: .......
    800106f0:	73615020 2e646573 00000000 00000000      Passed.........
    80010700:	69614620 2e64656c 00000000 00000000      Failed.........
    80010710:	696d2020 6974206e 203a656d 6d207325       min time: %s m
    80010720:	255b2073 000a5d64 3d3d3d3d 3d3d3d3d     s [%d]..========
    80010730:	3d3d3d3d 3d3d3d3d 3d3d3d3d 3d3d3d3d     ================
    80010740:	3d3d3d3d 3d3d3d3d 3d3d3d3d 3d3d3d3d     ================
    80010750:	3d3d3d3d 3d3d3d3d 000a3d3d 00000000     ==========......
    80010760:	7263694d 6e65426f 25206863 00000073     MicroBench %s...
    80010770:	20202020 20202020 4d206425 736b7261             %d Marks
    80010780:	0000000a 00000000 392d3969 4b303039     ........i9-9900K
    80010790:	33204020 4730362e 00007a48 00000000      @ 3.60GHz......
    800107a0:	20202020 20202020 20202020 20202020                     
    800107b0:	76202020 25202e73 614d2064 20736b72        vs. %d Marks 
    800107c0:	29732528 0000000a 726f6353 74206465     (%s)....Scored t
    800107d0:	3a656d69 20732520 000a736d 00000000     ime: %s ms......
    800107e0:	61746f54 7420206c 3a656d69 20732520     Total  time: %s 
    800107f0:	000a736d 00000000 726f7371 00000074     ms......qsort...
    80010800:	63697551 6f73206b 00007472 00000000     Quick sort......
    80010810:	65657571 0000006e 65657551 6c70206e     queen...Queen pl
    80010820:	6d656361 00746e65 00006662 00000000     acement.bf......
    80010830:	69617242 2a2a666e 6e69206b 70726574     Brainf**k interp
    80010840:	65746572 00000072 00626966 00000000     reter...fib.....
    80010850:	6f626946 6363616e 756e2069 7265626d     Fibonacci number
	...
    80010868:	76656973 00000065 74617245 6874736f     sieve...Eratosth
    80010878:	73656e65 65697320 00006576 00000000     enes sieve......
    80010888:	7a703531 00000000 31202a41 75702d35     15pz....A* 15-pu
    80010898:	656c7a7a 61657320 00686372 00000000     zzle search.....
    800108a8:	696e6964 00000063 696e6944 20732763     dinic...Dinic's 
    800108b8:	6678616d 20776f6c 6f676c61 68746972     maxflow algorith
    800108c8:	0000006d 00000000 70697a6c 00000000     m.......lzip....
    800108d8:	70697a4c 6d6f6320 73657270 6e6f6973     Lzip compression
	...
    800108f0:	726f7373 00000074 66667553 73207869     ssort...Suffix s
    80010900:	0074726f 00000000 0035646d 00000000     ort.....md5.....
    80010910:	2035444d 65676964 00007473 00000000     MD5 digest......
    80010920:	3e2b3e3e 3e3e3e3e 2b3e5b2c 5d2c3e3e     >>+>>>>>,[>+>>,]
    80010930:	2d5b2b3e 3c2b5b2d 5d2d3c3c 2b3c5b3c     >+[--[+<<<-]<[<+
    80010940:	3c5d2d3e 2d5b3c5b 3c3c5b3e 3e3e2b3c     >-]<[<[->[<<<+>>
    80010950:	3c2b3e3e 3c3c5d2d 2b3e3e5b 3e2d5b3e     >>+<-]<<[>>+>[->
    80010960:	5b3c3c5d 2d3c5d3c 3e5d3e5d 3c2b3e3e     ]<<[<]<-]>]>>>+<
    80010970:	5d2d5b5b 2b3e5b3c 3c5d2d3c 5b5b3e5d     [[-]<[>+<-]<]>[[
    80010980:	5d3e3e3e 3c3c3c2b 3c5b3c2d 3c3c5b3c     >>>]+<<<-<[<<[<<
    80010990:	3e3e5d3c 3e5b3e2b 3c5d3e3e 3c3c5d2d     <]>>+>[>>>]<-]<<
    800109a0:	3c3c3c5b 3e5b3e5d 3e3e5b3e 2b3c5d3e     [<<<]>[>>[>>>]<+
    800109b0:	3c5b3c3c 3e5d3c3c 2b5d5d2d 5d3c3c3c     <<[<<<]>-]]+<<<]
    800109c0:	3e2d5b2b 3e5d3e3e 3e3e5d3e 3e3e2e5b     +[->>>]>>]>>[.>>
    800109d0:	00005d3e 00000000 33323130 37363534     >]......01234567
    800109e0:	62613938 66656463 6a696867 6e6d6c6b     89abcdefghijklmn
    800109f0:	7271706f 76757473 7a797877 44434241     opqrstuvwxyzABCD
    80010a00:	48474645 4c4b4a49 504f4e4d 54535251     EFGHIJKLMNOPQRST
    80010a10:	58575655 00005a59 ffff2d10 ffff2d1c     UVWXYZ...-...-..
    80010a20:	ffff2d24 ffff2d40 ffff2d58 ffff2d7c     $-..@-..X-..|-..
    80010a30:	ffff2d9c ffff2db8 74726175 00000000     .-...-..uart....
    80010a40:	70616568 305b203a 38302578 202d2078     heap: [0x%08x - 
    80010a50:	30257830 0a5d7838 00000000 00000000     0x%08x].........

0000000080010a60 <__fsym___cmd_reboot_desc>:
    80010a60:	65736572 616d2074 6e696863 00000065     reset machine...

0000000080010a70 <__fsym___cmd_reboot_name>:
    80010a70:	6d635f5f 65725f64 746f6f62 00000000     __cmd_reboot....
    80010a80:	69726573 21206c61 5452203d 4c554e5f     serial != RT_NUL
    80010a90:	0000004c 00000000 74726175 203d2120     L.......uart != 
    80010aa0:	4e5f5452 004c4c55                       RT_NULL.

0000000080010aa8 <__FUNCTION__.0>:
    80010aa8:	755f7472 5f747261 666e6f63 72756769     rt_uart_configur
    80010ab8:	00000065 00000000                       e.......

0000000080010ac0 <__FUNCTION__.1>:
    80010ac0:	74726175 6e6f635f 6c6f7274 00000000     uart_control....

0000000080010ad0 <_uart_ops>:
    80010ad0:	80003974 00000000 800039d0 00000000     t9.......9......
    80010ae0:	80003938 00000000 80003954 00000000     89......T9......
	...
    80010af8:	656d6974 3d212072 5f545220 4c4c554e     timer != RT_NULL
	...
    80010b10:	6f5f7472 63656a62 65675f74 79745f74     rt_object_get_ty
    80010b20:	26286570 656d6974 703e2d72 6e657261     pe(&timer->paren
    80010b30:	3d202974 5452203d 6a624f5f 5f746365     t) == RT_Object_
    80010b40:	73616c43 69545f73 0072656d 00000000     Class_Timer.....
    80010b50:	6f5f7472 63656a62 73695f74 7379735f     rt_object_is_sys
    80010b60:	6f6d6574 63656a62 74262874 72656d69     temobject(&timer
    80010b70:	61703e2d 746e6572 00000029 00000000     ->parent).......
    80010b80:	656d6974 693e2d72 5f74696e 6b636974     timer->init_tick
    80010b90:	52203c20 49545f54 4d5f4b43 2f205841      < RT_TICK_MAX /
    80010ba0:	00003220 ffff35a4 ffff3598 ffff35cc      2...5...5...5..
    80010bb0:	ffff35dc ffff35e8 656d6974 00000072     .5...5..timer...

0000000080010bc0 <__FUNCTION__.0>:
    80010bc0:	745f7472 72656d69 6e6f635f 6c6f7274     rt_timer_control
	...

0000000080010bd8 <__FUNCTION__.1>:
    80010bd8:	745f7472 72656d69 6f74735f 00000070     rt_timer_stop...

0000000080010be8 <__FUNCTION__.3>:
    80010be8:	745f7472 72656d69 6174735f 00007472     rt_timer_start..

0000000080010bf8 <__FUNCTION__.5>:
    80010bf8:	745f7472 72656d69 7465645f 00686361     rt_timer_detach.

0000000080010c08 <__FUNCTION__.6>:
    80010c08:	745f7472 72656d69 696e695f 00000074     rt_timer_init...
    80010c18:	65726874 21206461 5452203d 4c554e5f     thread != RT_NUL
    80010c28:	0000004c 00000000                       L.......

0000000080010c30 <__FUNCTION__.0>:
    80010c30:	735f7472 64656863 5f656c75 6f6d6572     rt_schedule_remo
    80010c40:	745f6576 61657268 00000064 00000000     ve_thread.......

0000000080010c50 <__FUNCTION__.1>:
    80010c50:	735f7472 64656863 5f656c75 65736e69     rt_schedule_inse
    80010c60:	745f7472 61657268 00000064 00000000     rt_thread.......
    80010c70:	61746f74 656d206c 79726f6d 6425203a     total memory: %d
    80010c80:	0000000a 00000000 64657375 6d656d20     ........used mem
    80010c90:	2079726f 6425203a 0000000a 00000000     ory : %d........
    80010ca0:	6978616d 206d756d 6f6c6c61 65746163     maximum allocate
    80010cb0:	656d2064 79726f6d 6425203a 0000000a     d memory: %d....
    80010cc0:	6d656d0a 2079726f 70616568 64646120     .memory heap add
    80010cd0:	73736572 00000a3a 70616568 7274705f     ress:...heap_ptr
    80010ce0:	7830203a 78383025 0000000a 00000000     : 0x%08x........
    80010cf0:	6572666c 20202065 7830203a 78383025     lfree   : 0x%08x
    80010d00:	0000000a 00000000 70616568 646e655f     ........heap_end
    80010d10:	7830203a 78383025 0000000a 00000000     : 0x%08x........
    80010d20:	6d2d2d0a 726f6d65 74692079 69206d65     .--memory item i
    80010d30:	726f666e 6974616d 2d206e6f 00000a2d     nformation --...
    80010d40:	2578305b 20783830 0000202d 00000000     [0x%08x - ......
    80010d50:	00643525 00000000 4b643425 00000000     %5d.....%4dK....
    80010d60:	4d643425 00000000 6325205d 63256325     %4dM....] %c%c%c
    80010d70:	00006325 00000000 2a2a203a 00000a2a     %c......: ***...
    80010d80:	5f747228 746e6975 20745f38 656d292a     (rt_uint8_t *)me
    80010d90:	3d3e206d 61656820 74705f70 00000072     m >= heap_ptr...
    80010da0:	5f747228 746e6975 20745f38 656d292a     (rt_uint8_t *)me
    80010db0:	203c206d 5f747228 746e6975 20745f38     m < (rt_uint8_t 
    80010dc0:	6568292a 655f7061 0000646e 00000000     *)heap_end......
    80010dd0:	2d6d656d 6573753e 3d3d2064 00003020     mem->used == 0..
    80010de0:	6f6d654d 62207972 6b636f6c 6f727720     Memory block wro
    80010df0:	0a3a676e 00000000 72646461 3a737365     ng:.....address:
    80010e00:	25783020 0a783830 00000000 00000000      0x%08x.........
    80010e10:	616d2020 3a636967 25783020 0a783430       magic: 0x%04x.
	...
    80010e28:	75202020 3a646573 0a642520 00000000        used: %d.....
    80010e38:	69732020 203a657a 000a6425 00000000       size: %d......
    80010e48:	636e7546 6e6f6974 5d73255b 61687320     Function[%s] sha
    80010e58:	6e206c6c 6220746f 73752065 69206465     ll not be used i
    80010e68:	5349206e 00000a52 00000030 00000000     n ISR...0.......
    80010e78:	54494e49 00000000 70616568 00000000     INIT....heap....
    80010e88:	206d656d 74696e69 7265202c 20726f72     mem init, error 
    80010e98:	69676562 6461206e 73657264 78302073     begin address 0x
    80010ea8:	202c7825 20646e61 20646e65 72646461     %x, and end addr
    80010eb8:	20737365 78257830 0000000a 00000000     ess 0x%x........
    80010ec8:	20202020 00000000 454e4f4e 00000000         ....NONE....
    80010ed8:	5f747228 73616275 29745f65 206d656d     (rt_ubase_t)mem 
    80010ee8:	4953202b 464f455a 5254535f 5f544355     + SIZEOF_STRUCT_
    80010ef8:	204d454d 6973202b 3c20657a 7228203d     MEM + size <= (r
    80010f08:	62755f74 5f657361 65682974 655f7061     t_ubase_t)heap_e
    80010f18:	0000646e 00000000 5f747228 73616275     nd......(rt_ubas
    80010f28:	29745f65 74722828 6e69755f 745f3874     e_t)((rt_uint8_t
    80010f38:	6d292a20 2b206d65 5a495320 5f464f45      *)mem + SIZEOF_
    80010f48:	55525453 4d5f5443 20294d45 54522025     STRUCT_MEM) % RT
    80010f58:	494c415f 535f4e47 20455a49 30203d3d     _ALIGN_SIZE == 0
	...
    80010f70:	72282828 62755f74 5f657361 656d2974     (((rt_ubase_t)me
    80010f80:	2620296d 54522820 494c415f 535f4e47     m) & (RT_ALIGN_S
    80010f90:	20455a49 2931202d 3d3d2029 00003020     IZE - 1)) == 0..
    80010fa0:	72282828 62755f74 5f657361 6d722974     (((rt_ubase_t)rm
    80010fb0:	20296d65 52282026 4c415f54 5f4e4749     em) & (RT_ALIGN_
    80010fc0:	455a4953 31202d20 3d202929 0030203d     SIZE - 1)) == 0.
    80010fd0:	5f747228 746e6975 20745f38 6d72292a     (rt_uint8_t *)rm
    80010fe0:	3e206d65 7228203d 69755f74 5f38746e     em >= (rt_uint8_
    80010ff0:	292a2074 70616568 7274705f 20262620     t *)heap_ptr && 
    80011000:	5f747228 746e6975 20745f38 6d72292a     (rt_uint8_t *)rm
    80011010:	3c206d65 74722820 6e69755f 745f3874     em < (rt_uint8_t
    80011020:	68292a20 5f706165 00646e65 00000000      *)heap_end.....
    80011030:	66206f74 20656572 61622061 61642064     to free a bad da
    80011040:	62206174 6b636f6c 00000a3a 00000000     ta block:.......
    80011050:	3a6d656d 25783020 2c783830 65737520     mem: 0x%08x, use
    80011060:	6c662064 203a6761 202c6425 6967616d     d flag: %d, magi
    80011070:	6f632063 203a6564 30257830 000a7834     c code: 0x%04x..
    80011080:	2d6d656d 6573753e 00000064 00000000     mem->used.......
    80011090:	2d6d656d 67616d3e 3d206369 4548203d     mem->magic == HE
    800110a0:	4d5f5041 43494741 00000000 00000000     AP_MAGIC........

00000000800110b0 <__FUNCTION__.1>:
    800110b0:	67756c70 6c6f685f 00007365 00000000     plug_holes......

00000000800110c0 <__FUNCTION__.2>:
    800110c0:	725f7472 6c6c6165 0000636f 00000000     rt_realloc......

00000000800110d0 <__FUNCTION__.3>:
    800110d0:	6d5f7472 6f6c6c61 00000063 00000000     rt_malloc.......

00000000800110e0 <__FUNCTION__.4>:
    800110e0:	735f7472 65747379 65685f6d 695f7061     rt_system_heap_i
    800110f0:	0074696e 00000000                       nit.....

00000000800110f8 <__fsym___cmd_memtrace_desc>:
    800110f8:	706d7564 6d656d20 2079726f 63617274     dump memory trac
    80011108:	6e692065 6d726f66 6f697461 0000006e     e information...

0000000080011118 <__fsym___cmd_memtrace_name>:
    80011118:	6d635f5f 656d5f64 6172746d 00006563     __cmd_memtrace..

0000000080011128 <__fsym___cmd_memcheck_desc>:
    80011128:	63656863 656d206b 79726f6d 74616420     check memory dat
    80011138:	00000061 00000000                       a.......

0000000080011140 <__fsym___cmd_memcheck_name>:
    80011140:	6d635f5f 656d5f64 6568636d 00006b63     __cmd_memcheck..

0000000080011150 <__fsym_list_mem_desc>:
    80011150:	7473696c 6d656d20 2079726f 67617375     list memory usag
    80011160:	6e692065 6d726f66 6f697461 0000006e     e information...

0000000080011170 <__fsym_list_mem_name>:
    80011170:	7473696c 6d656d5f 00000000 00000000     list_mem........
    80011180:	20766564 52203d21 554e5f54 00004c4c     dev != RT_NULL..
    80011190:	6f5f7472 63656a62 65675f74 79745f74     rt_object_get_ty
    800111a0:	26286570 2d766564 7261703e 29746e65     pe(&dev->parent)
    800111b0:	203d3d20 4f5f5452 63656a62 6c435f74      == RT_Object_Cl
    800111c0:	5f737361 69766544 00006563 00000000     ass_Device......
    800111d0:	6f5f7472 63656a62 73695f74 7379735f     rt_object_is_sys
    800111e0:	6f6d6574 63656a62 64262874 3e2d7665     temobject(&dev->
    800111f0:	65726170 0029746e 69206f54 6974696e     parent).To initi
    80011200:	7a696c61 65642065 65636976 2073253a     alize device:%s 
    80011210:	6c696166 202e6465 20656854 6f727265     failed. The erro
    80011220:	6f632072 69206564 64252073 0000000a     r code is %d....
    80011230:	2d766564 6665723e 756f635f 2120746e     dev->ref_count !
    80011240:	0030203d 00000000                       = 0.....

0000000080011248 <__FUNCTION__.1>:
    80011248:	645f7472 63697665 65735f65 78725f74     rt_device_set_rx
    80011258:	646e695f 74616369 00000065 00000000     _indicate.......

0000000080011268 <__FUNCTION__.2>:
    80011268:	645f7472 63697665 6f635f65 6f72746e     rt_device_contro
    80011278:	0000006c 00000000                       l.......

0000000080011280 <__FUNCTION__.3>:
    80011280:	645f7472 63697665 72775f65 00657469     rt_device_write.

0000000080011290 <__FUNCTION__.4>:
    80011290:	645f7472 63697665 65725f65 00006461     rt_device_read..

00000000800112a0 <__FUNCTION__.5>:
    800112a0:	645f7472 63697665 6c635f65 0065736f     rt_device_close.

00000000800112b0 <__FUNCTION__.6>:
    800112b0:	645f7472 63697665 706f5f65 00006e65     rt_device_open..
    800112c0:	6c646974 00642565                       tidle%d.

00000000800112c8 <__FUNCTION__.0>:
    800112c8:	645f7472 6e756665 655f7463 75636578     rt_defunct_execu
    800112d8:	00006574 00000000 4c554e28 0000294c     te......(NULL)..
    800112e8:	ffff53a4 ffff55d8 ffff5324 ffff5324     .S...U..$S..$S..
    800112f8:	ffff5324 ffff5324 ffff55d8 ffff5324     $S..$S...U..$S..
    80011308:	ffff5324 ffff5324 ffff5324 ffff5324     $S..$S..$S..$S..
    80011318:	ffff55ec ffff555c ffff5324 ffff5324     .U..\U..$S..$S..
    80011328:	ffff544c ffff5324 ffff55dc ffff5324     LT..$S...U..$S..
    80011338:	ffff5324 ffff559c 205c200a 0a2f207c     $S...U... \ | /.
	...
    80011350:	5452202d 20202d20 54202020 61657268     - RT -     Threa
    80011360:	704f2064 74617265 20676e69 74737953     d Operating Syst
    80011370:	000a6d65 00000000 20636544 32203231     em......Dec 12 2
    80011380:	00313230 00000000 7c202f20 20205c20     021..... / | \  
    80011390:	25202020 64252e64 2064252e 6c697562        %d.%d.%d buil
    800113a0:	73252064 0000000a 30303220 202d2036     d %s.... 2006 - 
    800113b0:	31323032 706f4320 67697279 62207468     2021 Copyright b
    800113c0:	74722079 7268742d 20646165 6d616574     y rt-thread team
    800113d0:	0000000a 00000000 29732528 73736120     ........(%s) ass
    800113e0:	69747265 66206e6f 656c6961 74612064     ertion failed at
    800113f0:	6e756620 6f697463 73253a6e 696c202c      function:%s, li
    80011400:	6e20656e 65626d75 64253a72 00000a20     ne number:%d ...

0000000080011410 <__lowest_bit_bitmap>:
    80011410:	00010000 00010002 00010003 00010002     ................
    80011420:	00010004 00010002 00010003 00010002     ................
    80011430:	00010005 00010002 00010003 00010002     ................
    80011440:	00010004 00010002 00010003 00010002     ................
    80011450:	00010006 00010002 00010003 00010002     ................
    80011460:	00010004 00010002 00010003 00010002     ................
    80011470:	00010005 00010002 00010003 00010002     ................
    80011480:	00010004 00010002 00010003 00010002     ................
    80011490:	00010007 00010002 00010003 00010002     ................
    800114a0:	00010004 00010002 00010003 00010002     ................
    800114b0:	00010005 00010002 00010003 00010002     ................
    800114c0:	00010004 00010002 00010003 00010002     ................
    800114d0:	00010006 00010002 00010003 00010002     ................
    800114e0:	00010004 00010002 00010003 00010002     ................
    800114f0:	00010005 00010002 00010003 00010002     ................
    80011500:	00010004 00010002 00010003 00010002     ................

0000000080011510 <large_digits.2>:
    80011510:	33323130 37363534 42413938 46454443     0123456789ABCDEF
	...

0000000080011528 <small_digits.1>:
    80011528:	33323130 37363534 62613938 66656463     0123456789abcdef
	...
    80011540:	6f697270 79746972 52203c20 48545f54     priority < RT_TH
    80011550:	44414552 4952505f 5449524f 414d5f59     READ_PRIORITY_MA
    80011560:	00000058 00000000 72687428 2d646165     X.......(thread-
    80011570:	6174733e 20262074 545f5452 41455248     >stat & RT_THREA
    80011580:	54535f44 4d5f5441 294b5341 203d3d20     D_STAT_MASK) == 
    80011590:	545f5452 41455248 55535f44 4e455053     RT_THREAD_SUSPEN
    800115a0:	00000044 00000000 6f5f7472 63656a62     D.......rt_objec
    800115b0:	65675f74 79745f74 28286570 6f5f7472     t_get_type((rt_o
    800115c0:	63656a62 29745f74 65726874 20296461     bject_t)thread) 
    800115d0:	52203d3d 624f5f54 7463656a 616c435f     == RT_Object_Cla
    800115e0:	545f7373 61657268 00000064 00000000     ss_Thread.......
    800115f0:	63617473 74735f6b 20747261 52203d21     stack_start != R
    80011600:	554e5f54 00004c4c 6f5f7472 63656a62     T_NULL..rt_objec
    80011610:	73695f74 7379735f 6f6d6574 63656a62     t_is_systemobjec
    80011620:	72282874 626f5f74 7463656a 7429745f     t((rt_object_t)t
    80011630:	61657268 00002964 6f5f7472 63656a62     hread)..rt_objec
    80011640:	73695f74 7379735f 6f6d6574 63656a62     t_is_systemobjec
    80011650:	72282874 626f5f74 7463656a 7429745f     t((rt_object_t)t
    80011660:	61657268 3d202964 5452203d 4c41465f     hread) == RT_FAL
    80011670:	00004553 00000000 65726874 3d206461     SE......thread =
    80011680:	7472203d 7268745f 5f646165 666c6573     = rt_thread_self
    80011690:	00002928 00000000 72687428 2d646165     ()......(thread-
    800116a0:	6174733e 20262074 545f5452 41455248     >stat & RT_THREA
    800116b0:	54535f44 4d5f5441 294b5341 203d3d20     D_STAT_MASK) == 
    800116c0:	545f5452 41455248 4e495f44 00005449     RT_THREAD_INIT..

00000000800116d0 <__FUNCTION__.0>:
    800116d0:	745f7472 61657268 69745f64 756f656d     rt_thread_timeou
    800116e0:	00000074 00000000                       t.......

00000000800116e8 <__FUNCTION__.1>:
    800116e8:	745f7472 61657268 65725f64 656d7573     rt_thread_resume
	...

0000000080011700 <__FUNCTION__.10>:
    80011700:	745f7472 61657268 6e695f64 00007469     rt_thread_init..

0000000080011710 <__FUNCTION__.2>:
    80011710:	745f7472 61657268 75735f64 6e657073     rt_thread_suspen
    80011720:	00000064 00000000                       d.......

0000000080011728 <__FUNCTION__.3>:
    80011728:	745f7472 61657268 6f635f64 6f72746e     rt_thread_contro
    80011738:	0000006c 00000000                       l.......

0000000080011740 <__FUNCTION__.5>:
    80011740:	745f7472 61657268 6c735f64 00706565     rt_thread_sleep.

0000000080011750 <__FUNCTION__.6>:
    80011750:	745f7472 61657268 65645f64 6574656c     rt_thread_delete
	...

0000000080011768 <__FUNCTION__.7>:
    80011768:	745f7472 61657268 65645f64 68636174     rt_thread_detach
	...

0000000080011780 <__FUNCTION__.8>:
    80011780:	745f7472 61657268 74735f64 75747261     rt_thread_startu
    80011790:	00000070 00000000                       p.......

0000000080011798 <__FUNCTION__.9>:
    80011798:	5f74725f 65726874 695f6461 0074696e     _rt_thread_init.
    800117a8:	6e69616d 00000000 20646974 52203d21     main....tid != R
    800117b8:	554e5f54 00004c4c                       T_NULL..

00000000800117c0 <__FUNCTION__.0>:
    800117c0:	615f7472 696c7070 69746163 695f6e6f     rt_application_i
    800117d0:	0074696e 00000000 6f666e69 74616d72     nit.....informat
    800117e0:	206e6f69 52203d21 554e5f54 00004c4c     ion != RT_NULL..
    800117f0:	206a626f 6f203d21 63656a62 00000074     obj != object...
    80011800:	656a626f 21207463 5452203d 4c554e5f     object != RT_NUL
    80011810:	0000004c 00000000 626f2821 7463656a     L.......!(object
    80011820:	79743e2d 26206570 5f545220 656a624f     ->type & RT_Obje
    80011830:	435f7463 7373616c 6174535f 29636974     ct_Class_Static)
	...

0000000080011848 <__FUNCTION__.0>:
    80011848:	6f5f7472 63656a62 69665f74 0000646e     rt_object_find..

0000000080011858 <__FUNCTION__.1>:
    80011858:	6f5f7472 63656a62 65675f74 79745f74     rt_object_get_ty
    80011868:	00006570 00000000                       pe......

0000000080011870 <__FUNCTION__.2>:
    80011870:	6f5f7472 63656a62 73695f74 7379735f     rt_object_is_sys
    80011880:	6f6d6574 63656a62 00000074 00000000     temobject.......

0000000080011890 <__FUNCTION__.3>:
    80011890:	6f5f7472 63656a62 65645f74 6574656c     rt_object_delete
	...

00000000800118a8 <__FUNCTION__.4>:
    800118a8:	6f5f7472 63656a62 6c615f74 61636f6c     rt_object_alloca
    800118b8:	00006574 00000000                       te......

00000000800118c0 <__FUNCTION__.5>:
    800118c0:	6f5f7472 63656a62 65645f74 68636174     rt_object_detach
	...

00000000800118d8 <__FUNCTION__.6>:
    800118d8:	6f5f7472 63656a62 6e695f74 00007469     rt_object_init..
    800118e8:	206d6573 52203d21 554e5f54 00004c4c     sem != RT_NULL..
    800118f8:	756c6176 203c2065 30317830 55303030     value < 0x10000U
	...
    80011910:	6f5f7472 63656a62 65675f74 79745f74     rt_object_get_ty
    80011920:	26286570 2d6d6573 7261703e 2e746e65     pe(&sem->parent.
    80011930:	65726170 2029746e 52203d3d 624f5f54     parent) == RT_Ob
    80011940:	7463656a 616c435f 535f7373 70616d65     ject_Class_Semap
    80011950:	65726f68 00000000 6f5f7472 63656a62     hore....rt_objec
    80011960:	73695f74 7379735f 6f6d6574 63656a62     t_is_systemobjec
    80011970:	73262874 3e2d6d65 65726170 702e746e     t(&sem->parent.p
    80011980:	6e657261 00002974 636e7546 6e6f6974     arent)..Function
    80011990:	5d73255b 61687320 6e206c6c 6220746f     [%s] shall not b
    800119a0:	73752065 62206465 726f6665 63732065     e used before sc
    800119b0:	75646568 2072656c 72617473 00000a74     heduler start...
    800119c0:	6574756d 3d212078 5f545220 4c4c554e     mutex != RT_NULL
	...
    800119d8:	6f5f7472 63656a62 65675f74 79745f74     rt_object_get_ty
    800119e8:	26286570 6574756d 703e2d78 6e657261     pe(&mutex->paren
    800119f8:	61702e74 746e6572 3d3d2029 5f545220     t.parent) == RT_
    80011a08:	656a624f 435f7463 7373616c 74754d5f     Object_Class_Mut
    80011a18:	00007865 00000000 6f5f7472 63656a62     ex......rt_objec
    80011a28:	73695f74 7379735f 6f6d6574 63656a62     t_is_systemobjec
    80011a38:	6d262874 78657475 61703e2d 746e6572     t(&mutex->parent
    80011a48:	7261702e 29746e65 00000000 00000000     .parent)........

0000000080011a58 <__FUNCTION__.24>:
    80011a58:	6d5f7472 78657475 6c65725f 65736165     rt_mutex_release
	...

0000000080011a70 <__FUNCTION__.25>:
    80011a70:	6d5f7472 78657475 6b61745f 00000065     rt_mutex_take...

0000000080011a80 <__FUNCTION__.29>:
    80011a80:	6d5f7472 78657475 696e695f 00000074     rt_mutex_init...

0000000080011a90 <__FUNCTION__.31>:
    80011a90:	735f7472 725f6d65 61656c65 00006573     rt_sem_release..

0000000080011aa0 <__FUNCTION__.32>:
    80011aa0:	695f7472 6c5f6370 5f747369 70737573     rt_ipc_list_susp
    80011ab0:	00646e65 00000000                       end.....

0000000080011ab8 <__FUNCTION__.33>:
    80011ab8:	735f7472 745f6d65 00656b61 00000000     rt_sem_take.....

0000000080011ac8 <__FUNCTION__.37>:
    80011ac8:	735f7472 695f6d65 0074696e 00000000     rt_sem_init.....
    80011ad8:	682d4e55 6c646e61 69206465 7265746e     UN-handled inter
    80011ae8:	74707572 20642520 7563636f 64657272     rupt %d occurred
    80011af8:	0a212121 00000000 65707553 73697672     !!!.....Supervis
    80011b08:	4920726f 7265746e 74707572 616e4520     or Interrupt Ena
    80011b18:	64656c62 00000000 65707553 73697672     bled....Supervis
    80011b28:	4920726f 7265746e 74707572 73694420     or Interrupt Dis
    80011b38:	656c6261 00000064 7473614c 6d695420     abled...Last Tim
    80011b48:	75532065 76726570 726f7369 746e4920     e Supervisor Int
    80011b58:	75727265 45207470 6c62616e 00006465     errupt Enabled..
    80011b68:	7473614c 6d695420 75532065 76726570     Last Time Superv
    80011b78:	726f7369 746e4920 75727265 44207470     isor Interrupt D
    80011b88:	62617369 0064656c 7473614c 69725020     isabled.Last Pri
    80011b98:	656c6976 69206567 75532073 76726570     vilege is Superv
    80011ba8:	726f7369 646f4d20 00000065 00000000     isor Mode.......
    80011bb8:	7473614c 69725020 656c6976 69206567     Last Privilege i
    80011bc8:	73552073 4d207265 0065646f 00000000     s User Mode.....
    80011bd8:	6d726550 74207469 6341206f 73736563     Permit to Access
    80011be8:	65735520 61502072 00006567 00000000      User Page......
    80011bf8:	20746f4e 6d726550 74207469 6341206f     Not Permit to Ac
    80011c08:	73736563 65735520 61502072 00006567     cess User Page..
    80011c18:	6d726550 74207469 6552206f 45206461     Permit to Read E
    80011c28:	75636578 6c626174 6e6f2d65 5020796c     xecutable-only P
    80011c38:	00656761 00000000 20746f4e 6d726550     age.....Not Perm
    80011c48:	74207469 6552206f 45206461 75636578     it to Read Execu
    80011c58:	6c626174 6e6f2d65 5020796c 00656761     table-only Page.
    80011c68:	6e6b6e55 206e776f 72646441 20737365     Unknown Address 
    80011c78:	6e617254 74616c73 2f6e6f69 746f7250     Translation/Prot
    80011c88:	69746365 4d206e6f 0065646f 00000000     ection Mode.....
    80011c98:	2d2d2d2d 2d2d2d2d 2d2d2d2d 75442d2d     --------------Du
    80011ca8:	5220706d 73696765 73726574 2d2d2d2d     mp Registers----
    80011cb8:	2d2d2d2d 2d2d2d2d 2d2d2d2d 00000a2d     -------------...
    80011cc8:	636e7546 6e6f6974 67655220 65747369     Function Registe
    80011cd8:	0a3a7372 00000000 28617209 20293178     rs:......ra(x1) 
    80011ce8:	7830203d 75097025 5f726573 3d207073     = 0x%p.user_sp =
    80011cf8:	25783020 00000a70 28706709 20293378      0x%p....gp(x3) 
    80011d08:	7830203d 74097025 34782870 203d2029     = 0x%p.tp(x4) = 
    80011d18:	70257830 0000000a 706d6554 7261726f     0x%p....Temporar
    80011d28:	65522079 74736967 3a737265 0000000a     y Registers:....
    80011d38:	28307409 20293578 7830203d 74097025     .t0(x5) = 0x%p.t
    80011d48:	36782831 203d2029 70257830 0000000a     1(x6) = 0x%p....
    80011d58:	28327409 20293778 7830203d 000a7025     .t2(x7) = 0x%p..
    80011d68:	28337409 29383278 30203d20 09702578     .t3(x28) = 0x%p.
    80011d78:	78283474 20293932 7830203d 000a7025     t4(x29) = 0x%p..
    80011d88:	28357409 29303378 30203d20 09702578     .t5(x30) = 0x%p.
    80011d98:	78283674 20293133 7830203d 000a7025     t6(x31) = 0x%p..
    80011da8:	65766153 65522064 74736967 3a737265     Saved Registers:
    80011db8:	0000000a 00000000 2f307309 78287066     .........s0/fp(x
    80011dc8:	3d202938 25783020 31730970 29397828     8) = 0x%p.s1(x9)
    80011dd8:	30203d20 0a702578 00000000 00000000      = 0x%p.........
    80011de8:	28327309 29383178 30203d20 09702578     .s2(x18) = 0x%p.
    80011df8:	78283373 20293931 7830203d 000a7025     s3(x19) = 0x%p..
    80011e08:	28347309 29303278 30203d20 09702578     .s4(x20) = 0x%p.
    80011e18:	78283573 20293132 7830203d 000a7025     s5(x21) = 0x%p..
    80011e28:	28367309 29323278 30203d20 09702578     .s6(x22) = 0x%p.
    80011e38:	78283773 20293332 7830203d 000a7025     s7(x23) = 0x%p..
    80011e48:	28387309 29343278 30203d20 09702578     .s8(x24) = 0x%p.
    80011e58:	78283973 20293532 7830203d 000a7025     s9(x25) = 0x%p..
    80011e68:	30317309 36327828 203d2029 70257830     .s10(x26) = 0x%p
    80011e78:	31317309 37327828 203d2029 70257830     .s11(x27) = 0x%p
    80011e88:	0000000a 00000000 636e7546 6e6f6974     ........Function
    80011e98:	67724120 6e656d75 52207374 73696765      Arguments Regis
    80011ea8:	73726574 00000a3a 28306109 29303178     ters:....a0(x10)
    80011eb8:	30203d20 09702578 78283161 20293131      = 0x%p.a1(x11) 
    80011ec8:	7830203d 000a7025 28326109 29323178     = 0x%p...a2(x12)
    80011ed8:	30203d20 09702578 78283361 20293331      = 0x%p.a3(x13) 
    80011ee8:	7830203d 000a7025 28346109 29343178     = 0x%p...a4(x14)
    80011ef8:	30203d20 09702578 78283561 20293531      = 0x%p.a5(x15) 
    80011f08:	7830203d 000a7025 28366109 29363178     = 0x%p...a6(x16)
    80011f18:	30203d20 09702578 78283761 20293731      = 0x%p.a7(x17) 
    80011f28:	7830203d 000a7025 61747378 20737574     = 0x%p..xstatus 
    80011f38:	7830203d 000a7025 0a732509 00000000     = 0x%p...%s.....
    80011f48:	70746173 30203d20 0a702578 00000000     satp = 0x%p.....
    80011f58:	646f4d09 203d2065 000a7325 00000000     .Mode = %s......
    80011f68:	2d2d2d2d 2d2d2d2d 2d2d2d2d 2d2d2d2d     ----------------
    80011f78:	6d75442d 4b4f2070 2d2d2d2d 2d2d2d2d     -Dump OK--------
    80011f88:	2d2d2d2d 2d2d2d2d 2d2d2d2d 00000a2d     -------------...
    80011f98:	75616378 3d206573 38302520 74782c78     xcause = %08x,xt
    80011fa8:	206c6176 3025203d 782c7838 20637065     val = %08x,xepc 
    80011fb8:	3025203d 000a7838 6378450a 69747065     = %08x...Excepti
    80011fc8:	0a3a6e6f 00000000 74736e49 74637572     on:.....Instruct
    80011fd8:	206e6f69 72646461 20737365 6173696d     ion address misa
    80011fe8:	6e67696c 00006465 74736e49 74637572     ligned..Instruct
    80011ff8:	206e6f69 65636361 66207373 746c7561     ion access fault
	...
    80012010:	656c6c49 206c6167 74736e69 74637572     Illegal instruct
    80012020:	006e6f69 00000000 61657242 696f706b     ion.....Breakpoi
    80012030:	0000746e 00000000 64616f4c 64646120     nt......Load add
    80012040:	73736572 73696d20 67696c61 0064656e     ress misaligned.
    80012050:	64616f4c 63636120 20737365 6c756166     Load access faul
    80012060:	00000074 00000000 726f7453 64612065     t.......Store ad
    80012070:	73657264 696d2073 696c6173 64656e67     dress misaligned
	...
    80012088:	726f7453 63612065 73736563 75616620     Store access fau
    80012098:	0000746c 00000000 69766e45 6d6e6f72     lt......Environm
    800120a8:	20746e65 6c6c6163 6f726620 2d55206d     ent call from U-
    800120b8:	65646f6d 00000000 69766e45 6d6e6f72     mode....Environm
    800120c8:	20746e65 6c6c6163 6f726620 2d53206d     ent call from S-
    800120d8:	65646f6d 00000000 69766e45 6d6e6f72     mode....Environm
    800120e8:	20746e65 6c6c6163 6f726620 2d48206d     ent call from H-
    800120f8:	65646f6d 00000000 69766e45 6d6e6f72     mode....Environm
    80012108:	20746e65 6c6c6163 6f726620 2d4d206d     ent call from M-
    80012118:	65646f6d 00000000 6f6e6b55 65206e77     mode....Uknown e
    80012128:	70656378 6e6f6974 25203a20 586c3830     xception : %08lX
	...
    80012140:	65637865 6f697470 6370206e 203e3d20     exception pc => 
    80012150:	30257830 000a7838 72727563 20746e65     0x%08x..current 
    80012160:	65726874 203a6461 732a2e25 0000000a     thread: %.*s....
    80012170:	ffff69bc ffff6a08 ffff6a14 ffff6a20     .i...j...j.. j..
    80012180:	ffff6a2c ffff6a38 ffff6a44 ffff6a50     ,j..8j..Dj..Pj..
    80012190:	ffff6a5c ffff6a68 ffff6a74 ffff6a80     \j..hj..tj...j..
    800121a0:	41206f4e 65726464 54207373 736e6172     No Address Trans
    800121b0:	6974616c 502f6e6f 65746f72 6f697463     lation/Protectio
    800121c0:	6f4d206e 00006564 65676150 7361622d     n Mode..Page-bas
    800121d0:	33206465 69622d39 69562074 61757472     ed 39-bit Virtua
    800121e0:	6441206c 73657264 676e6973 646f4d20     l Addressing Mod
    800121f0:	00000065 00000000 65676150 7361622d     e.......Page-bas
    80012200:	34206465 69622d38 69562074 61757472     ed 48-bit Virtua
    80012210:	6441206c 73657264 676e6973 646f4d20     l Addressing Mod
    80012220:	00000065 00000000                       e.......

0000000080012228 <CSWTCH.17>:
    80012228:	800121a0 00000000 80011c68 00000000     .!......h.......
    80012238:	80011c68 00000000 80011c68 00000000     h.......h.......
    80012248:	80011c68 00000000 80011c68 00000000     h.......h.......
    80012258:	80011c68 00000000 80011c68 00000000     h.......h.......
    80012268:	800121c8 00000000 800121f8 00000000     .!.......!......
    80012278:	542d5452 61657268 68732064 206c6c65     RT-Thread shell 
    80012288:	6d6d6f63 73646e61 00000a3a 00000000     commands:.......
    80012298:	6d635f5f 00005f64 36312d25 202d2073     __cmd_..%-16s - 
    800122a8:	000a7325 00000000 206f6f54 796e616d     %s......Too many
    800122b8:	67726120 20212073 6f206557 20796c6e      args ! We only 
    800122c8:	3a657355 0000000a 00207325 00000000     Use:....%s .....
    800122d8:	203a7325 6d6d6f63 20646e61 20746f6e     %s: command not 
    800122e8:	6e756f66 000a2e64 0000002f 00000000     found.../.......

00000000800122f8 <__fsym___cmd_free_desc>:
    800122f8:	776f6853 65687420 6d656d20 2079726f     Show the memory 
    80012308:	67617375 6e692065 65687420 73797320     usage in the sys
    80012318:	2e6d6574 00000000                       tem.....

0000000080012320 <__fsym___cmd_free_name>:
    80012320:	6d635f5f 72665f64 00006565 00000000     __cmd_free......

0000000080012330 <__fsym___cmd_ps_desc>:
    80012330:	7473694c 72687420 73646165 206e6920     List threads in 
    80012340:	20656874 74737973 002e6d65 00000000     the system......

0000000080012350 <__fsym___cmd_ps_name>:
    80012350:	6d635f5f 73705f64 00000000 00000000     __cmd_ps........

0000000080012360 <__fsym___cmd_help_desc>:
    80012360:	542d5452 61657268 68732064 206c6c65     RT-Thread shell 
    80012370:	706c6568 0000002e                       help....

0000000080012378 <__fsym___cmd_help_name>:
    80012378:	6d635f5f 65685f64 0000706c 00000000     __cmd_help......
    80012388:	6e6e6163 7220746f 766f6d65 25272065     cannot remove '%
    80012398:	000a2773 00000000 00002e2e 00000000     s'..............
    800123a8:	252f7325 00000073 6f6d6572 20646576     %s/%s...removed 
    800123b8:	27732527 0000000a 6f6d6572 20646576     '%s'....removed 
    800123c8:	65726964 726f7463 25272079 000a2773     directory '%s'..
    800123d8:	67617355 72203a65 706f206d 6e6f6974     Usage: rm option
    800123e8:	20297328 454c4946 0a2e2e2e 00000000     (s) FILE........
    800123f8:	6f6d6552 28206576 696c6e75 20296b6e     Remove (unlink) 
    80012408:	20656874 454c4946 2e297328 0000000a     the FILE(s).....
    80012418:	6f727245 42203a72 6f206461 6f697470     Error: Bad optio
    80012428:	25203a6e 00000a63 6e6e6163 7220746f     n: %c...cannot r
    80012438:	766f6d65 25272065 203a2773 61207349     emove '%s': Is a
    80012448:	72696420 6f746365 000a7972 00000000      directory......
    80012458:	6e6e6163 7220746f 766f6d65 25272065     cannot remove '%
    80012468:	203a2773 73206f4e 20686375 656c6966     s': No such file
    80012478:	20726f20 65726964 726f7463 00000a79      or directory...
    80012488:	006d6c65 00000000 0000742d 00000000     elm.....-t......
    80012498:	67617355 6d203a65 2073666b 20742d5b     Usage: mkfs [-t 
    800124a8:	65707974 6564205d 65636976 0000000a     type] device....
    800124b8:	73666b6d 69616620 2c64656c 73657220     mkfs failed, res
    800124c8:	3d746c75 000a6425 656c6966 74737973     ult=%d..filesyst
    800124d8:	20206d65 69766564 20206563 6e756f6d     em  device  moun
    800124e8:	696f7074 000a746e 2d2d2d2d 2d2d2d2d     tpoint..--------
    800124f8:	20202d2d 2d2d2d2d 20202d2d 2d2d2d2d     --  ------  ----
    80012508:	2d2d2d2d 000a2d2d 30312d25 25202073     ------..%-10s  %
    80012518:	2073362d 732d2520 0000000a 00000000     -6s  %-s........
    80012528:	6e756f6d 65642074 65636976 28732520     mount device %s(
    80012538:	20297325 6f746e6f 20732520 202e2e2e     %s) onto %s ... 
	...
    80012550:	63637573 21646565 0000000a 00000000     succeed!........
    80012560:	6c696166 0a216465 00000000 00000000     failed!.........
    80012570:	67617355 6d203a65 746e756f 65643c20     Usage: mount <de
    80012580:	65636976 6d3c203e 746e756f 6e696f70     vice> <mountpoin
    80012590:	3c203e74 79747366 2e3e6570 0000000a     t> <fstype>.....
    800125a0:	67617355 75203a65 756f6d6e 3c20746e     Usage: unmount <
    800125b0:	6e756f6d 696f7074 2e3e746e 0000000a     mountpoint>.....
    800125c0:	6f6d6e75 20746e75 2e207325 00202e2e     unmount %s ... .
    800125d0:	67617355 74203a65 206c6961 206e2d5b     Usage: tail [-n 
    800125e0:	626d756e 5d737265 69663c20 616e656c     numbers] <filena
    800125f0:	0a3e656d 00000000 00006e2d 00000000     me>.....-n......
    80012600:	656c6946 656f6420 74276e73 69786520     File doesn't exi
    80012610:	000a7473 00000000 746f540a 4e206c61     st.......Total N
    80012620:	65626d75 666f2072 6e696c20 253a7365     umber of lines:%
    80012630:	00000a64 00000000 7272450a 523a726f     d........Error:R
    80012640:	69757165 20646572 656e696c 72612073     equired lines ar
    80012650:	6f6d2065 74206572 206e6168 61746f74     e more than tota
    80012660:	756e206c 7265626d 20666f20 656e696c     l number of line
    80012670:	00000a73 00000000 75716552 64657269     s.......Required
    80012680:	6d754e20 20726562 6c20666f 73656e69      Number of lines
    80012690:	0a64253a 00000000 67617355 63203a65     :%d.....Usage: c
    800126a0:	4f532070 45435255 53454420 00000a54     p SOURCE DEST...
    800126b0:	79706f43 554f5320 20454352 44206f74     Copy SOURCE to D
    800126c0:	2e545345 0000000a 67617355 6d203a65     EST.....Usage: m
    800126d0:	4f532076 45435255 53454420 00000a54     v SOURCE DEST...
    800126e0:	616e6552 5320656d 4352554f 6f742045     Rename SOURCE to
    800126f0:	53454420 6f202c54 6f6d2072 53206576      DEST, or move S
    80012700:	4352554f 29732845 206f7420 45524944     OURCE(s) to DIRE
    80012710:	524f5443 000a2e59 3d207325 7325203e     CTORY...%s => %s
    80012720:	0000000a 00000000 2074756f 6d20666f     ........out of m
    80012730:	726f6d65 00000a79 67617355 63203a65     emory...Usage: c
    80012740:	5b207461 454c4946 2e2e2e5d 0000000a     at [FILE].......
    80012750:	636e6f43 6e657461 20657461 454c4946     Concatenate FILE
    80012760:	0a297328 00000000 73206f4e 20686375     (s).....No such 
    80012770:	65726964 726f7463 25203a79 00000a73     directory: %s...
    80012780:	67617355 6d203a65 7269646b 504f5b20     Usage: mkdir [OP
    80012790:	4e4f4954 4944205d 54434552 0a59524f     TION] DIRECTORY.
	...
    800127a8:	61657243 74206574 44206568 43455249     Create the DIREC
    800127b8:	59524f54 6669202c 65687420 6f642079     TORY, if they do
    800127c8:	746f6e20 726c6120 79646165 69786520      not already exi
    800127d8:	0a2e7473 00000000 65682d2d 0000706c     st......--help..
    800127e8:	0000682d 00000000 5b206664 68746170     -h......df [path
    800127f8:	00000a5d 00000000 6e65706f 6c696620     ].......open fil
    80012808:	73253a65 69616620 2164656c 0000000a     e:%s failed!....
    80012818:	67617355 65203a65 206f6863 72747322     Usage: echo "str
    80012828:	22676e69 69665b20 616e656c 0a5d656d     ing" [filename].
	...
    80012840:	0068732e 00000000 0048532e 00000000     .sh......SH.....
    80012850:	6e69622f 2a2e252f 00000073 00000000     /bin/%.*s.......

0000000080012860 <__fsym___cmd_tail_desc>:
    80012860:	6e697270 68742074 616c2065 4e207473     print the last N
    80012870:	6e696c2d 64207365 20617461 7420666f     -lines data of t
    80012880:	67206568 6e657669 6c696620 00000065     he given file...

0000000080012890 <__fsym___cmd_tail_name>:
    80012890:	6d635f5f 61745f64 00006c69 00000000     __cmd_tail......

00000000800128a0 <__fsym___cmd_echo_desc>:
    800128a0:	6f686365 72747320 20676e69 66206f74     echo string to f
    800128b0:	00656c69 00000000                       ile.....

00000000800128b8 <__fsym___cmd_echo_name>:
    800128b8:	6d635f5f 63655f64 00006f68 00000000     __cmd_echo......

00000000800128c8 <__fsym___cmd_df_desc>:
    800128c8:	6b736964 65726620 00000065 00000000     disk free.......

00000000800128d8 <__fsym___cmd_df_name>:
    800128d8:	6d635f5f 66645f64 00000000 00000000     __cmd_df........

00000000800128e8 <__fsym___cmd_umount_desc>:
    800128e8:	6f6d6e55 20746e75 69766564 66206563     Unmount device f
    800128f8:	206d6f72 656c6966 73797320 006d6574     rom file system.

0000000080012908 <__fsym___cmd_umount_name>:
    80012908:	6d635f5f 6d755f64 746e756f 00000000     __cmd_umount....

0000000080012918 <__fsym___cmd_mount_desc>:
    80012918:	6e756f6d 643c2074 63697665 3c203e65     mount <device> <
    80012928:	6e756f6d 696f7074 203e746e 7473663c     mountpoint> <fst
    80012938:	3e657079 00000000                       ype>....

0000000080012940 <__fsym___cmd_mount_name>:
    80012940:	6d635f5f 6f6d5f64 00746e75 00000000     __cmd_mount.....

0000000080012950 <__fsym___cmd_mkfs_desc>:
    80012950:	6d726f66 64207461 206b7369 68746977     format disk with
    80012960:	6c696620 79732065 6d657473 00000000      file system....

0000000080012970 <__fsym___cmd_mkfs_name>:
    80012970:	6d635f5f 6b6d5f64 00007366 00000000     __cmd_mkfs......

0000000080012980 <__fsym___cmd_mkdir_desc>:
    80012980:	61657243 74206574 44206568 43455249     Create the DIREC
    80012990:	59524f54 0000002e                       TORY....

0000000080012998 <__fsym___cmd_mkdir_name>:
    80012998:	6d635f5f 6b6d5f64 00726964 00000000     __cmd_mkdir.....

00000000800129a8 <__fsym___cmd_pwd_desc>:
    800129a8:	6e697250 68742074 616e2065 6f20656d     Print the name o
    800129b8:	68742066 75632065 6e657272 6f772074     f the current wo
    800129c8:	6e696b72 69642067 74636572 2e79726f     rking directory.
	...

00000000800129e0 <__fsym___cmd_pwd_name>:
    800129e0:	6d635f5f 77705f64 00000064 00000000     __cmd_pwd.......

00000000800129f0 <__fsym___cmd_cd_desc>:
    800129f0:	6e616843 74206567 73206568 6c6c6568     Change the shell
    80012a00:	726f7720 676e696b 72696420 6f746365      working directo
    80012a10:	002e7972 00000000                       ry......

0000000080012a18 <__fsym___cmd_cd_name>:
    80012a18:	6d635f5f 64635f64 00000000 00000000     __cmd_cd........

0000000080012a28 <__fsym___cmd_rm_desc>:
    80012a28:	6f6d6552 75286576 6e696c6e 7420296b     Remove(unlink) t
    80012a38:	46206568 28454c49 002e2973 00000000     he FILE(s)......

0000000080012a48 <__fsym___cmd_rm_name>:
    80012a48:	6d635f5f 6d725f64 00000000 00000000     __cmd_rm........

0000000080012a58 <__fsym___cmd_cat_desc>:
    80012a58:	636e6f43 6e657461 20657461 454c4946     Concatenate FILE
    80012a68:	00297328 00000000                       (s).....

0000000080012a70 <__fsym___cmd_cat_name>:
    80012a70:	6d635f5f 61635f64 00000074 00000000     __cmd_cat.......

0000000080012a80 <__fsym___cmd_mv_desc>:
    80012a80:	616e6552 5320656d 4352554f 6f742045     Rename SOURCE to
    80012a90:	53454420 00002e54                        DEST...

0000000080012a98 <__fsym___cmd_mv_name>:
    80012a98:	6d635f5f 766d5f64 00000000 00000000     __cmd_mv........

0000000080012aa8 <__fsym___cmd_cp_desc>:
    80012aa8:	79706f43 554f5320 20454352 44206f74     Copy SOURCE to D
    80012ab8:	2e545345 00000000                       EST.....

0000000080012ac0 <__fsym___cmd_cp_name>:
    80012ac0:	6d635f5f 70635f64 00000000 00000000     __cmd_cp........

0000000080012ad0 <__fsym___cmd_ls_desc>:
    80012ad0:	7473694c 666e6920 616d726f 6e6f6974     List information
    80012ae0:	6f626120 74207475 46206568 73454c49      about the FILEs
    80012af0:	0000002e 00000000                       ........

0000000080012af8 <__fsym___cmd_ls_name>:
    80012af8:	6d635f5f 736c5f64 00000000 00000000     __cmd_ls........
    80012b08:	6c656873 3d21206c 5f545220 4c4c554e     shell != RT_NULL
	...
    80012b20:	2068736d 00000000 736e6966 00002068     msh ....finsh ..
    80012b30:	0000003e 00000000 4b325b1b 0000000d     >........[2K....
    80012b40:	73257325 00000000 6d206f6e 726f6d65     %s%s....no memor
    80012b50:	6f662079 68732072 0a6c6c65 00000000     y for shell.....
    80012b60:	65687374 00006c6c 78726873 00000000     tshell..shrx....
    80012b70:	736e6966 63203a68 6e206e61 6620746f     finsh: can not f
    80012b80:	20646e69 69766564 203a6563 000a7325     ind device: %s..
    80012b90:	00000008 00000000 20732508 00000820     .........%s  ...
    80012ba0:	00082008 00000000 00007325 00000000     . ......%s......

0000000080012bb0 <__FUNCTION__.0>:
    80012bb0:	736e6966 65675f68 61686374 00000072     finsh_getchar...

0000000080012bc0 <__FUNCTION__.4>:
    80012bc0:	736e6966 78725f68 646e695f 00000000     finsh_rx_ind....

0000000080012bd0 <__FUNCTION__.5>:
    80012bd0:	736e6966 65735f68 65645f74 65636976     finsh_set_device
	...

0000000080012be8 <__FUNCTION__.6>:
    80012be8:	736e6966 65735f68 72705f74 74706d6f     finsh_set_prompt
    80012bf8:	646f6d5f 00000065 6c6c6548 5452206f     _mode...Hello RT
    80012c08:	7268542d 21646165 0000000a 00000000     -Thread!........
    80012c18:	4a325b1b 00485b1b 75462d2d 6974636e     .[2J.[H.--Functi
    80012c28:	4c206e6f 3a747369 0000000a 00000000     on List:........
    80012c38:	00005f5f 00000000 36312d25 2d2d2073     __......%-16s --
    80012c48:	0a732520 00000000 0000002d 00000000      %s.....-.......
    80012c58:	2e2a2d25 70202073 6f697265 20636964     %-*.s  periodic 
    80012c68:	69742020 756f656d 20202074 20202020       timeout       
    80012c78:	67616c66 0000000a 2d2d2d20 2d2d2d2d     flag.... -------
    80012c88:	202d2d2d 2d2d2d2d 2d2d2d2d 2d202d2d     --- ---------- -
    80012c98:	2d2d2d2d 2d2d2d2d 000a2d2d 00000000     ----------......
    80012ca8:	2e2a2d25 3020732a 38302578 78302078     %-*.*s 0x%08x 0x
    80012cb8:	78383025 00000020 69746361 65746176     %08x ...activate
    80012cc8:	00000a64 00000000 63616564 61766974     d.......deactiva
    80012cd8:	0a646574 00000000 72727563 20746e65     ted.....current 
    80012ce8:	6b636974 2578303a 0a783830 00000000     tick:0x%08x.....
    80012cf8:	65726874 00006461 2e2a2d25 72702073     thread..%-*.s pr
    80012d08:	73202069 75746174 20202073 73202020     i  status      s
    80012d18:	20202070 74732020 206b6361 657a6973     p     stack size
    80012d28:	78616d20 65737520 656c2064 74207466      max used left t
    80012d38:	206b6369 72726520 000a726f 00000000     ick  error......
    80012d48:	2d2d2d20 2d2d2020 2d2d2d2d 2d2d202d      ---  ------- --
    80012d58:	2d2d2d2d 2d2d2d2d 2d2d2d20 2d2d2d2d     -------- -------
    80012d68:	202d2d2d 2d2d2d20 202d2d2d 2d2d2d20     ---  ------  ---
    80012d78:	2d2d2d2d 202d2d2d 0a2d2d2d 00000000     ------- ---.....
    80012d88:	2e2a2d25 2520732a 00206433 00000000     %-*.*s %3d .....
    80012d98:	61657220 20207964 00000000 00000000      ready  ........
    80012da8:	73757320 646e6570 00000000 00000000      suspend........
    80012db8:	696e6920 20202074 00000000 00000000      init   ........
    80012dc8:	6f6c6320 20206573 00000000 00000000      close  ........
    80012dd8:	6e757220 676e696e 00000000 00000000      running........
    80012de8:	25783020 20783830 30257830 20207838      0x%08x 0x%08x  
    80012df8:	30252020 25256432 30202020 38302578       %02d%%   0x%08
    80012e08:	30252078 000a6433 616d6573 726f6870     x %03d..semaphor
    80012e18:	00000065 00000000 2e2a2d25 20762073     e.......%-*.s v 
    80012e28:	75732020 6e657073 68742064 64616572       suspend thread
    80012e38:	0000000a 00000000 2d2d2d20 2d2d2d20     ........ --- ---
    80012e48:	2d2d2d2d 2d2d2d2d 0a2d2d2d 00000000     -----------.....
    80012e58:	2e2a2d25 2520732a 20643330 003a6425     %-*.*s %03d %d:.
    80012e68:	2e2a2d25 2520732a 20643330 000a6425     %-*.*s %03d %d..
    80012e78:	6e657665 00000074 2e2a2d25 20202073     event...%-*.s   
    80012e88:	73202020 20207465 75732020 6e657073        set    suspen
    80012e98:	68742064 64616572 0000000a 00000000     d thread........
    80012ea8:	2d2d2020 2d2d2d2d 2d2d2d2d 2d2d2d20       ---------- ---
    80012eb8:	2d2d2d2d 2d2d2d2d 0a2d2d2d 00000000     -----------.....
    80012ec8:	2e2a2d25 2020732a 30257830 25207838     %-*.*s  0x%08x %
    80012ed8:	3a643330 00000000 2e2a2d25 2020732a     03d:....%-*.*s  
    80012ee8:	30257830 30207838 0000000a 00000000     0x%08x 0........
    80012ef8:	6574756d 00000078 2e2a2d25 20202073     mutex...%-*.s   
    80012f08:	656e776f 68202072 20646c6f 70737573     owner  hold susp
    80012f18:	20646e65 65726874 000a6461 00000000     end thread......
    80012f28:	2d2d2d20 2d2d2d2d 2d2d202d 2d202d2d      -------- ---- -
    80012f38:	2d2d2d2d 2d2d2d2d 2d2d2d2d 00000a2d     -------------...
    80012f48:	2e2a2d25 2520732a 2a2e382d 30252073     %-*.*s %-8.*s %0
    80012f58:	25206434 00000a64 6c69616d 00786f62     4d %d...mailbox.
    80012f68:	2e2a2d25 6e652073 20797274 657a6973     %-*.s entry size
    80012f78:	73757320 646e6570 72687420 0a646165      suspend thread.
	...
    80012f90:	2d2d2d20 2d20202d 202d2d2d 2d2d2d2d      ----  ---- ----
    80012fa0:	2d2d2d2d 2d2d2d2d 000a2d2d 00000000     ----------......
    80012fb0:	2e2a2d25 2520732a 20643430 34302520     %-*.*s %04d  %04
    80012fc0:	64252064 0000003a 2e2a2d25 2520732a     d %d:...%-*.*s %
    80012fd0:	20643430 34302520 64252064 0000000a     04d  %04d %d....
    80012fe0:	7167736d 65756575 00000000 00000000     msgqueue........
    80012ff0:	2e2a2d25 6e652073 20797274 70737573     %-*.s entry susp
    80013000:	20646e65 65726874 000a6461 00000000     end thread......
    80013010:	2d2d2d20 2d20202d 2d2d2d2d 2d2d2d2d      ----  ---------
    80013020:	2d2d2d2d 00000a2d 2e2a2d25 2520732a     -----...%-*.*s %
    80013030:	20643430 3a642520 00000000 00000000     04d  %d:........
    80013040:	2e2a2d25 2520732a 20643430 0a642520     %-*.*s %04d  %d.
	...
    80013058:	706d656d 006c6f6f 2e2a2d25 6c622073     mempool.%-*.s bl
    80013068:	206b636f 61746f74 7266206c 73206565     ock total free s
    80013078:	65707375 7420646e 61657268 00000a64     uspend thread...
    80013088:	2d2d2d20 2d20202d 202d2d2d 2d2d2d20      ----  ----  ---
    80013098:	2d2d202d 2d2d2d2d 2d2d2d2d 2d2d2d2d     - --------------
    800130a8:	0000000a 00000000 2e2a2d25 2520732a     ........%-*.*s %
    800130b8:	20643430 34302520 25202064 20643430     04d  %04d  %04d 
    800130c8:	003a6425 00000000 2e2a2d25 2520732a     %d:.....%-*.*s %
    800130d8:	20643430 34302520 25202064 20643430     04d  %04d  %04d 
    800130e8:	000a6425 00000000 6e6b6e55 006e776f     %d......Unknown.
    800130f8:	69766564 00006563 2e2a2d25 20202073     device..%-*.s   
    80013108:	20202020 79742020 20206570 20202020           type      
    80013118:	72202020 63206665 746e756f 0000000a        ref count....
    80013128:	2d2d2d20 2d2d2d2d 2d2d2d2d 2d2d2d2d      ---------------
    80013138:	2d2d2d2d 2d2d202d 2d2d2d2d 2d2d2d2d     ----- ----------
    80013148:	0000000a 00000000 2e2a2d25 2520732a     ........%-*.*s %
    80013158:	7330322d 382d2520 00000a64 00000000     -20s %-8d.......
    80013168:	72616843 65746361 65442072 65636976     Character Device
	...
    80013180:	636f6c42 6544206b 65636976 00000000     Block Device....
    80013190:	7774654e 206b726f 65746e49 63616672     Network Interfac
    800131a0:	00000065 00000000 2044544d 69766544     e.......MTD Devi
    800131b0:	00006563 00000000 204e4143 69766544     ce......CAN Devi
    800131c0:	00006563 00000000 00435452 00000000     ce......RTC.....
    800131d0:	6e756f53 65442064 65636976 00000000     Sound Device....
    800131e0:	70617247 20636968 69766544 00006563     Graphic Device..
    800131f0:	20433249 00737542 20425355 76616c53     I2C Bus.USB Slav
    80013200:	65442065 65636976 00000000 00000000     e Device........
    80013210:	20425355 74736f48 73754220 00000000     USB Host Bus....
    80013220:	20495053 00737542 20495053 69766544     SPI Bus.SPI Devi
    80013230:	00006563 00000000 4f494453 73754220     ce......SDIO Bus
	...
    80013248:	50204d50 64756573 6544206f 65636976     PM Pseudo Device
	...
    80013260:	65706950 00000000 74726f50 44206c61     Pipe....Portal D
    80013270:	63697665 00000065 656d6954 65442072     evice...Timer De
    80013280:	65636976 00000000 6373694d 616c6c65     vice....Miscella
    80013290:	756f656e 65442073 65636976 00000000     neous Device....
    800132a0:	736e6553 4420726f 63697665 00000065     Sensor Device...
    800132b0:	63756f54 65442068 65636976 00000000     Touch Device....
    800132c0:	20796850 69766544 00006563 00000000     Phy Device......

00000000800132d0 <device_type_str>:
    800132d0:	80013168 00000000 80013180 00000000     h1.......1......
    800132e0:	80013190 00000000 800131a8 00000000     .1.......1......
    800132f0:	800131b8 00000000 800131c8 00000000     .1.......1......
    80013300:	800131d0 00000000 800131e0 00000000     .1.......1......
    80013310:	800131f0 00000000 800131f8 00000000     .1.......1......
    80013320:	80013210 00000000 80013220 00000000     .2...... 2......
    80013330:	80013228 00000000 80013238 00000000     (2......82......
    80013340:	80013248 00000000 80013260 00000000     H2......`2......
    80013350:	80013268 00000000 80013278 00000000     h2......x2......
    80013360:	80013288 00000000 800132a0 00000000     .2.......2......
    80013370:	800132b0 00000000 800132c0 00000000     .2.......2......
    80013380:	800130f0 00000000                       .0......

0000000080013388 <__fsym_list_desc>:
    80013388:	7473696c 6c6c6120 6d797320 206c6f62     list all symbol 
    80013398:	73206e69 65747379 0000006d 00000000     in system.......

00000000800133a8 <__fsym_list_name>:
    800133a8:	7473696c 00000000                       list....

00000000800133b0 <__fsym___cmd_list_device_desc>:
    800133b0:	7473696c 76656420 20656369 73206e69     list device in s
    800133c0:	65747379 0000006d                       ystem...

00000000800133c8 <__fsym___cmd_list_device_name>:
    800133c8:	6d635f5f 696c5f64 645f7473 63697665     __cmd_list_devic
    800133d8:	00000065 00000000                       e.......

00000000800133e0 <__fsym_list_device_desc>:
    800133e0:	7473696c 76656420 20656369 73206e69     list device in s
    800133f0:	65747379 0000006d                       ystem...

00000000800133f8 <__fsym_list_device_name>:
    800133f8:	7473696c 7665645f 00656369 00000000     list_device.....

0000000080013408 <__fsym___cmd_list_timer_desc>:
    80013408:	7473696c 6d697420 69207265 7973206e     list timer in sy
    80013418:	6d657473 00000000                       stem....

0000000080013420 <__fsym___cmd_list_timer_name>:
    80013420:	6d635f5f 696c5f64 745f7473 72656d69     __cmd_list_timer
	...

0000000080013438 <__fsym_list_timer_desc>:
    80013438:	7473696c 6d697420 69207265 7973206e     list timer in sy
    80013448:	6d657473 00000000                       stem....

0000000080013450 <__fsym_list_timer_name>:
    80013450:	7473696c 6d69745f 00007265 00000000     list_timer......

0000000080013460 <__fsym___cmd_list_mempool_desc>:
    80013460:	7473696c 6d656d20 2079726f 6c6f6f70     list memory pool
    80013470:	206e6920 74737973 00006d65 00000000      in system......

0000000080013480 <__fsym___cmd_list_mempool_name>:
    80013480:	6d635f5f 696c5f64 6d5f7473 6f706d65     __cmd_list_mempo
    80013490:	00006c6f 00000000                       ol......

0000000080013498 <__fsym_list_mempool_desc>:
    80013498:	7473696c 6d656d20 2079726f 6c6f6f70     list memory pool
    800134a8:	206e6920 74737973 00006d65 00000000      in system......

00000000800134b8 <__fsym_list_mempool_name>:
    800134b8:	7473696c 6d656d5f 6c6f6f70 00000000     list_mempool....

00000000800134c8 <__fsym___cmd_list_msgqueue_desc>:
    800134c8:	7473696c 73656d20 65676173 65757120     list message que
    800134d8:	69206575 7973206e 6d657473 00000000     ue in system....

00000000800134e8 <__fsym___cmd_list_msgqueue_name>:
    800134e8:	6d635f5f 696c5f64 6d5f7473 75716773     __cmd_list_msgqu
    800134f8:	00657565 00000000                       eue.....

0000000080013500 <__fsym_list_msgqueue_desc>:
    80013500:	7473696c 73656d20 65676173 65757120     list message que
    80013510:	69206575 7973206e 6d657473 00000000     ue in system....

0000000080013520 <__fsym_list_msgqueue_name>:
    80013520:	7473696c 67736d5f 75657571 00000065     list_msgqueue...

0000000080013530 <__fsym___cmd_list_mailbox_desc>:
    80013530:	7473696c 69616d20 6f62206c 6e692078     list mail box in
    80013540:	73797320 006d6574                        system.

0000000080013548 <__fsym___cmd_list_mailbox_name>:
    80013548:	6d635f5f 696c5f64 6d5f7473 626c6961     __cmd_list_mailb
    80013558:	0000786f 00000000                       ox......

0000000080013560 <__fsym_list_mailbox_desc>:
    80013560:	7473696c 69616d20 6f62206c 6e692078     list mail box in
    80013570:	73797320 006d6574                        system.

0000000080013578 <__fsym_list_mailbox_name>:
    80013578:	7473696c 69616d5f 786f626c 00000000     list_mailbox....

0000000080013588 <__fsym___cmd_list_mutex_desc>:
    80013588:	7473696c 74756d20 69207865 7973206e     list mutex in sy
    80013598:	6d657473 00000000                       stem....

00000000800135a0 <__fsym___cmd_list_mutex_name>:
    800135a0:	6d635f5f 696c5f64 6d5f7473 78657475     __cmd_list_mutex
	...

00000000800135b8 <__fsym_list_mutex_desc>:
    800135b8:	7473696c 74756d20 69207865 7973206e     list mutex in sy
    800135c8:	6d657473 00000000                       stem....

00000000800135d0 <__fsym_list_mutex_name>:
    800135d0:	7473696c 74756d5f 00007865 00000000     list_mutex......

00000000800135e0 <__fsym___cmd_list_event_desc>:
    800135e0:	7473696c 65766520 6920746e 7973206e     list event in sy
    800135f0:	6d657473 00000000                       stem....

00000000800135f8 <__fsym___cmd_list_event_name>:
    800135f8:	6d635f5f 696c5f64 655f7473 746e6576     __cmd_list_event
	...

0000000080013610 <__fsym_list_event_desc>:
    80013610:	7473696c 65766520 6920746e 7973206e     list event in sy
    80013620:	6d657473 00000000                       stem....

0000000080013628 <__fsym_list_event_name>:
    80013628:	7473696c 6576655f 0000746e 00000000     list_event......

0000000080013638 <__fsym___cmd_list_sem_desc>:
    80013638:	7473696c 6d657320 6f687061 69206572     list semaphore i
    80013648:	7973206e 6d657473 00000000 00000000     n system........

0000000080013658 <__fsym___cmd_list_sem_name>:
    80013658:	6d635f5f 696c5f64 735f7473 00006d65     __cmd_list_sem..

0000000080013668 <__fsym_list_sem_desc>:
    80013668:	7473696c 6d657320 6f687061 69206572     list semaphore i
    80013678:	7973206e 6d657473 00000000 00000000     n system........

0000000080013688 <__fsym_list_sem_name>:
    80013688:	7473696c 6d65735f 00000000 00000000     list_sem........

0000000080013698 <__fsym___cmd_list_thread_desc>:
    80013698:	7473696c 72687420 00646165 00000000     list thread.....

00000000800136a8 <__fsym___cmd_list_thread_name>:
    800136a8:	6d635f5f 696c5f64 745f7473 61657268     __cmd_list_threa
    800136b8:	00000064 00000000                       d.......

00000000800136c0 <__fsym_list_thread_desc>:
    800136c0:	7473696c 72687420 00646165 00000000     list thread.....

00000000800136d0 <__fsym_list_thread_name>:
    800136d0:	7473696c 7268745f 00646165 00000000     list_thread.....

00000000800136e0 <__fsym___cmd_version_desc>:
    800136e0:	776f6873 2d545220 65726854 76206461     show RT-Thread v
    800136f0:	69737265 69206e6f 726f666e 6974616d     ersion informati
    80013700:	00006e6f 00000000                       on......

0000000080013708 <__fsym___cmd_version_name>:
    80013708:	6d635f5f 65765f64 6f697372 0000006e     __cmd_version...

0000000080013718 <__fsym_version_desc>:
    80013718:	776f6873 2d545220 65726854 76206461     show RT-Thread v
    80013728:	69737265 69206e6f 726f666e 6974616d     ersion informati
    80013738:	00006e6f 00000000                       on......

0000000080013740 <__fsym_version_name>:
    80013740:	73726576 006e6f69                       version.

0000000080013748 <__fsym___cmd_clear_desc>:
    80013748:	61656c63 68742072 65742065 6e696d72     clear the termin
    80013758:	73206c61 65657263 0000006e 00000000     al screen.......

0000000080013768 <__fsym___cmd_clear_name>:
    80013768:	6d635f5f 6c635f64 00726165 00000000     __cmd_clear.....

0000000080013778 <__fsym_clear_desc>:
    80013778:	61656c63 68742072 65742065 6e696d72     clear the termin
    80013788:	73206c61 65657263 0000006e 00000000     al screen.......

0000000080013798 <__fsym_clear_name>:
    80013798:	61656c63 00000072                       clear...

00000000800137a0 <__fsym_hello_desc>:
    800137a0:	20796173 6c6c6568 6f77206f 00646c72     say hello world.

00000000800137b0 <__fsym_hello_name>:
    800137b0:	6c6c6568 0000006f 74206466 20657079     hello...fd type 
    800137c0:	72202020 6d206665 63696761 61702020        ref magic  pa
    800137d0:	000a6874 00000000 2d202d2d 2d2d2d2d     th......-- -----
    800137e0:	2d20202d 2d202d2d 2d2d2d2d 2d2d2d20     -  --- ----- ---
    800137f0:	0a2d2d2d 00000000 20643225 00000000     ---.....%2d ....
    80013800:	00726964 00000000 2e372d25 00207337     dir.....%-7.7s .
    80013810:	656c6966 00000000 6b636f73 00007465     file....socket..
    80013820:	72657375 00000000 6e6b6e75 006e776f     user....unknown.
    80013830:	2e382d25 00207338 20643325 00000000     %-8.8s .%3d ....
    80013840:	78343025 00002020 20736664 65726c61     %04x  ..dfs alre
    80013850:	20796461 74696e69 00000a2e 00000000     ady init........
    80013860:	6f6c7366 00006b63 66766564 00000073     fslock..devfs...
    80013870:	7665642f 00000000 442f455b 205d5346     /dev....[E/DFS] 
	...
    80013888:	20534644 6e206466 69207765 61662073     DFS fd new is fa
    80013898:	64656c69 6f432021 20646c75 20746f6e     iled! Could not 
    800138a8:	6e756f66 6e612064 706d6520 66207974     found an empty f
    800138b8:	6e652064 2e797274 00000000 00000000     d entry.........
    800138c8:	21206466 554e203d 00004c4c 00000000     fd != NULL......
    800138d8:	656c6966 656d616e 203d2120 4c4c554e     filename != NULL
	...

00000000800138f0 <__FUNCTION__.0>:
    800138f0:	5f736664 6d726f6e 7a696c61 61705f65     dfs_normalize_pa
    80013900:	00006874 00000000                       th......

0000000080013908 <__FUNCTION__.2>:
    80013908:	5f736664 6b636f6c 00000000 00000000     dfs_lock........

0000000080013918 <__fsym___cmd_list_fd_desc>:
    80013918:	7473696c 6c696620 65642065 69726373     list file descri
    80013928:	726f7470 00000000                       ptor....

0000000080013930 <__fsym___cmd_list_fd_name>:
    80013930:	6d635f5f 696c5f64 665f7473 00000064     __cmd_list_fd...
    80013940:	6e65704f 20732520 6c696166 000a6465     Open %s failed..
    80013950:	656c6544 25206574 61662073 64656c69     Delete %s failed
    80013960:	0000000a 00000000 64616552 20732520     ........Read %s 
    80013970:	6c696166 000a6465 74697257 73252065     failed..Write %s
    80013980:	69616620 0a64656c 00000000 00000000      failed.........
    80013990:	74697257 69662065 6420656c 20617461     Write file data 
    800139a0:	6c696166 202c6465 6e727265 64253d6f     failed, errno=%d
    800139b0:	0000000a 00000000 276e6163 69662074     ........can't fi
    800139c0:	6d20646e 746e756f 66206465 73656c69     nd mounted files
    800139d0:	65747379 6e6f206d 69687420 61702073     ystem on this pa
    800139e0:	253a6874 00000073 20656874 656c6966     th:%s...the file
    800139f0:	74737973 64206d65 276e6469 6d692074     system didn't im
    80013a00:	6d656c70 20746e65 73696874 6e756620     plement this fun
    80013a10:	6f697463 0000006e 65726944 726f7463     ction...Director
    80013a20:	73252079 00000a3a 30322d25 00000073     y %s:...%-20s...
    80013a30:	5249443c 0000003e 35322d25 00000a73     <DIR>...%-25s...
    80013a40:	35322d25 000a756c 20444142 656c6966     %-25lu..BAD file
    80013a50:	7325203a 0000000a 73206f4e 20686375     : %s....No such 
    80013a60:	65726964 726f7463 00000a79 00000000     directory.......
    80013a70:	6e65706f 20732520 6c696166 000a6465     open %s failed..
    80013a80:	2074756f 6d20666f 726f6d65 000a2179     out of memory!..
    80013a90:	6e65706f 6c696620 25203a65 61662073     open file: %s fa
    80013aa0:	64656c69 0000000a 79706f63 69616620     iled....copy fai
    80013ab0:	2c64656c 64616220 0a732520 00000000     led, bad %s.....
    80013ac0:	66207063 646c6961 7063202c 72696420     cp faild, cp dir
    80013ad0:	206f7420 656c6966 20736920 20746f6e      to file is not 
    80013ae0:	6d726570 65747469 000a2164 00000000     permitted!......

0000000080013af0 <__fsym_copy_desc>:
    80013af0:	79706f63 6c696620 726f2065 72696420     copy file or dir
	...

0000000080013b08 <__fsym_copy_name>:
    80013b08:	79706f63 00000000                       copy....

0000000080013b10 <__fsym_cat_desc>:
    80013b10:	6e697270 69662074 0000656c 00000000     print file......

0000000080013b20 <__fsym_cat_name>:
    80013b20:	00746163 00000000                       cat.....

0000000080013b28 <__fsym_rm_desc>:
    80013b28:	6f6d6572 66206576 73656c69 20726f20     remove files or 
    80013b38:	65726964 726f7463 00736569 00000000     directories.....

0000000080013b48 <__fsym_rm_name>:
    80013b48:	00006d72 00000000                       rm......

0000000080013b50 <__fsym_ls_desc>:
    80013b50:	7473696c 72696420 6f746365 63207972     list directory c
    80013b60:	65746e6f 0073746e                       ontents.

0000000080013b68 <__fsym_ls_name>:
    80013b68:	0000736c 00000000                       ls......

0000000080013b70 <__fsym_cd_desc>:
    80013b70:	6e616863 63206567 65727275 7720746e     change current w
    80013b80:	696b726f 6420676e 63657269 79726f74     orking directory
	...

0000000080013b98 <__fsym_cd_name>:
    80013b98:	00006463 00000000                       cd......

0000000080013ba0 <__fsym_mkdir_desc>:
    80013ba0:	61657263 61206574 72696420 6f746365     create a directo
    80013bb0:	00007972 00000000                       ry......

0000000080013bb8 <__fsym_mkdir_name>:
    80013bb8:	69646b6d 00000072 0000424b 00000000     mkdir...KB......
    80013bc8:	0000424d 00000000 00004247 00000000     MB......GB......
    80013bd8:	72656854 73692065 206f6e20 63617073     There is no spac
    80013be8:	6f742065 67657220 65747369 68742072     e to register th
    80013bf8:	66207369 20656c69 74737973 28206d65     is file system (
    80013c08:	2e297325 00000000 68746170 00000000     %s).....path....
    80013c18:	72656854 73692065 206f6e20 63617073     There is no spac
    80013c28:	6f742065 756f6d20 7420746e 20736968     e to mount this 
    80013c38:	656c6966 73797320 206d6574 29732528     file system (%s)
    80013c48:	0000002e 00000000 69766544 28206563     ........Device (
    80013c58:	20297325 20736177 20746f6e 6e756f66     %s) was not foun
    80013c68:	00000064 00000000 656c6946 73797320     d.......File sys
    80013c78:	206d6574 29732528 73617720 746f6e20     tem (%s) was not
    80013c88:	756f6620 002e646e 20656854 656c6966      found..The file
    80013c98:	73797320 206d6574 29732528 666b6d20      system (%s) mkf
    80013ca8:	75662073 6974636e 77206e6f 6e207361     s function was n
    80013cb8:	6920746f 656c706d 746e656d 00000000     ot implement....
    80013cc8:	5f736664 74617473 66207366 656c6961     dfs_statfs faile
    80013cd8:	000a2e64 00000000 6b736964 65726620     d.......disk fre
    80013ce8:	25203a65 64252e64 20732520 6425205b     e: %d.%d %s [ %d
    80013cf8:	6f6c6220 202c6b63 62206425 73657479      block, %d bytes
    80013d08:	72657020 6f6c6220 5d206b63 0000000a      per block ]....

0000000080013d18 <__FUNCTION__.1>:
    80013d18:	5f736664 656c6966 74737973 6c5f6d65     dfs_filesystem_l
    80013d28:	756b6f6f 00000070                       ookup...

0000000080013d30 <__fsym_df_desc>:
    80013d30:	20746567 6b736964 65726620 00000065     get disk free...

0000000080013d40 <__fsym_df_name>:
    80013d40:	00006664 00000000                       df......

0000000080013d48 <__fsym_mkfs_desc>:
    80013d48:	656b616d 66206120 20656c69 74737973     make a file syst
    80013d58:	00006d65 00000000                       em......

0000000080013d60 <__fsym_mkfs_name>:
    80013d60:	73666b6d 00000000 65726964 2120746e     mkfs....dirent !
    80013d70:	554e203d 00004c4c 65726964 3e2d746e     = NULL..dirent->
    80013d80:	65707974 203d3d20 464d4f52 49445f53     type == ROMFS_DI
    80013d90:	544e4552 5249445f 00000000 00000000     RENT_DIR........
    80013da0:	006d6f72 00000000                       rom.....

0000000080013da8 <__FUNCTION__.0>:
    80013da8:	5f736664 666d6f72 65675f73 6e656474     dfs_romfs_getden
    80013db8:	00007374 00000000                       ts......

0000000080013dc0 <__FUNCTION__.1>:
    80013dc0:	5f736664 666d6f72 65725f73 00006461     dfs_romfs_read..

0000000080013dd0 <_rom_fops>:
    80013dd0:	8000e6f0 00000000 8000e364 00000000     ........d.......
    80013de0:	8000e318 00000000 8000e370 00000000     ........p.......
	...
    80013e00:	8000e348 00000000 8000e428 00000000     H.......(.......
	...

0000000080013e18 <_romfs>:
    80013e18:	80013da0 00000000 00000000 00000000     .=..............
    80013e28:	80013dd0 00000000 8000e2f8 00000000     .=..............
    80013e38:	8000e310 00000000 00000000 00000000     ................
	...
    80013e58:	8000e79c 00000000 00000000 00000000     ................
    80013e68:	656c6966 203d2120 4e5f5452 004c4c55     file != RT_NULL.
    80013e78:	5f766564 21206469 5452203d 4c554e5f     dev_id != RT_NUL
    80013e88:	0000004c 00000000 746f6f72 7269645f     L.......root_dir
    80013e98:	20746e65 52203d21 554e5f54 00004c4c     ent != RT_NULL..

0000000080013ea8 <__FUNCTION__.0>:
    80013ea8:	5f736664 69766564 665f6563 65675f73     dfs_device_fs_ge
    80013eb8:	6e656474 00007374                       tdents..

0000000080013ec0 <__FUNCTION__.1>:
    80013ec0:	5f736664 69766564 665f6563 706f5f73     dfs_device_fs_op
    80013ed0:	00006e65 00000000                       en......

0000000080013ed8 <__FUNCTION__.2>:
    80013ed8:	5f736664 69766564 665f6563 6c635f73     dfs_device_fs_cl
    80013ee8:	0065736f 00000000                       ose.....

0000000080013ef0 <__FUNCTION__.3>:
    80013ef0:	5f736664 69766564 665f6563 72775f73     dfs_device_fs_wr
    80013f00:	00657469 00000000                       ite.....

0000000080013f08 <__FUNCTION__.4>:
    80013f08:	5f736664 69766564 665f6563 65725f73     dfs_device_fs_re
    80013f18:	00006461 00000000                       ad......

0000000080013f20 <__FUNCTION__.5>:
    80013f20:	5f736664 69766564 665f6563 6f695f73     dfs_device_fs_io
    80013f30:	006c7463 00000000                       ctl.....

0000000080013f38 <_device_fops>:
    80013f38:	8000eb3c 00000000 8000e9e4 00000000     <...............
    80013f48:	8000e81c 00000000 8000e8a4 00000000     ................
    80013f58:	8000e944 00000000 00000000 00000000     D...............
	...
    80013f70:	8000ec98 00000000 8000e814 00000000     ................

0000000080013f80 <_device_fs>:
    80013f80:	80013868 00000000 00000000 00000000     h8..............
    80013f90:	80013f38 00000000 8000e80c 00000000     8?..............
	...
    80013fc0:	8000ea98 00000000 00000000 00000000     ................
    80013fd0:	706d6f63 6974656c 21206e6f 5452203d     completion != RT
    80013fe0:	4c554e5f 0000004c 6c5f7472 5f747369     _NULL...rt_list_
    80013ff0:	6d657369 28797470 6f632826 656c706d     isempty(&(comple
    80014000:	6e6f6974 75733e2d 6e657073 5f646564     tion->suspended_
    80014010:	7473696c 00002929                       list))..

0000000080014018 <__FUNCTION__.1>:
    80014018:	635f7472 6c706d6f 6f697465 61775f6e     rt_completion_wa
    80014028:	00007469 00000000                       it......

0000000080014030 <__FUNCTION__.2>:
    80014030:	635f7472 6c706d6f 6f697465 6e695f6e     rt_completion_in
    80014040:	00007469 00000000 75657571 3d212065     it......queue !=
    80014050:	5f545220 4c4c554e 00000000 00000000      RT_NULL........
    80014060:	657a6973 30203e20 00000000 00000000     size > 0........
    80014070:	75657571 6d3e2d65 63696761 203d3d20     queue->magic == 
    80014080:	41544144 55455551 414d5f45 00434947     DATAQUEUE_MAGIC.

0000000080014090 <__FUNCTION__.1>:
    80014090:	645f7472 5f617461 75657571 65645f65     rt_data_queue_de
    800140a0:	74696e69 00000000                       init....

00000000800140a8 <__FUNCTION__.2>:
    800140a8:	645f7472 5f617461 75657571 65725f65     rt_data_queue_re
    800140b8:	00746573 00000000                       set.....

00000000800140c0 <__FUNCTION__.5>:
    800140c0:	645f7472 5f617461 75657571 75705f65     rt_data_queue_pu
    800140d0:	00006873 00000000                       sh......

00000000800140d8 <__FUNCTION__.6>:
    800140d8:	645f7472 5f617461 75657571 6e695f65     rt_data_queue_in
    800140e8:	00007469 00000000 665f7872 206f6669     it......rx_fifo 
    800140f8:	52203d21 554e5f54 00004c4c 00000000     != RT_NULL......
    80014108:	645f7872 2120616d 5452203d 4c554e5f     rx_dma != RT_NUL
    80014118:	0000004c 00000000 665f7874 206f6669     L.......tx_fifo 
    80014128:	52203d21 554e5f54 00004c4c 00000000     != RT_NULL......
    80014138:	645f7874 2120616d 5452203d 4c554e5f     tx_dma != RT_NUL
    80014148:	0000004c 00000000 21207874 5452203d     L.......tx != RT
    80014158:	4c554e5f 0000004c 72657328 206c6169     _NULL...(serial 
    80014168:	52203d21 554e5f54 20294c4c 28202626     != RT_NULL) && (
    80014178:	61746164 203d2120 4e5f5452 294c4c55     data != RT_NULL)
	...
    80014190:	69726573 3e2d6c61 2d73706f 616d643e     serial->ops->dma
    800141a0:	6172745f 696d736e 3d212074 5f545220     _transmit != RT_
    800141b0:	4c4c554e 00000000 206e656c 72203d3c     NULL....len <= r
    800141c0:	6d645f74 61635f61 725f636c 65766365     t_dma_calc_recve
    800141d0:	656c5f64 6573286e 6c616972 00000029     d_len(serial)...

00000000800141e0 <__FUNCTION__.10>:
    800141e0:	7265735f 5f6c6169 5f746e69 00007872     _serial_int_rx..

00000000800141f0 <__FUNCTION__.11>:
    800141f0:	735f7472 61697265 65725f6c 00006461     rt_serial_read..

0000000080014200 <__FUNCTION__.13>:
    80014200:	7265735f 5f6c6169 5f746e69 00007874     _serial_int_tx..

0000000080014210 <__FUNCTION__.14>:
    80014210:	735f7472 61697265 72775f6c 00657469     rt_serial_write.

0000000080014220 <__FUNCTION__.15>:
    80014220:	735f7472 61697265 6f635f6c 6f72746e     rt_serial_contro
    80014230:	0000006c 00000000                       l.......

0000000080014238 <__FUNCTION__.16>:
    80014238:	685f7472 65735f77 6c616972 6765725f     rt_hw_serial_reg
    80014248:	65747369 00000072                       ister...

0000000080014250 <__FUNCTION__.3>:
    80014250:	735f7472 61697265 6e695f6c 00007469     rt_serial_init..

0000000080014260 <__FUNCTION__.4>:
    80014260:	735f7472 61697265 706f5f6c 00006e65     rt_serial_open..

0000000080014270 <__FUNCTION__.5>:
    80014270:	735f7472 61697265 6c635f6c 0065736f     rt_serial_close.

0000000080014280 <__FUNCTION__.7>:
    80014280:	645f7472 725f616d 5f766365 61647075     rt_dma_recv_upda
    80014290:	675f6574 695f7465 7865646e 00000000     te_get_index....

00000000800142a0 <__FUNCTION__.8>:
    800142a0:	7265735f 5f6c6169 6f666966 6c61635f     _serial_fifo_cal
    800142b0:	65725f63 64657663 6e656c5f 00000000     c_recved_len....

00000000800142c0 <__FUNCTION__.9>:
    800142c0:	7265735f 5f6c6169 5f616d64 00007872     _serial_dma_rx..
    800142d0:	5f77685f 2e6e6970 2073706f 52203d21     _hw_pin.ops != R
    800142e0:	554e5f54 00004c4c 656d616e 205d305b     T_NULL..name[0] 
    800142f0:	27203d3d 00002750                       == 'P'..

00000000800142f8 <__FUNCTION__.0>:
    800142f8:	705f7472 675f6e69 00007465 00000000     rt_pin_get......

0000000080014308 <__FUNCTION__.1>:
    80014308:	705f7472 725f6e69 00646165 00000000     rt_pin_read.....

0000000080014318 <__FUNCTION__.2>:
    80014318:	705f7472 775f6e69 65746972 00000000     rt_pin_write....

0000000080014328 <__FUNCTION__.3>:
    80014328:	705f7472 6d5f6e69 0065646f 00000000     rt_pin_mode.....

0000000080014338 <__fsym_pinGet_desc>:
    80014338:	20746567 206e6970 626d756e 66207265     get pin number f
    80014348:	206d6f72 64726168 65726177 6e697020     rom hardware pin
	...

0000000080014360 <__fsym_pinGet_name>:
    80014360:	476e6970 00007465                       pinGet..

0000000080014368 <__fsym_pinRead_desc>:
    80014368:	64616572 61747320 20737574 6d6f7266     read status from
    80014378:	72616820 72617764 69702065 0000006e      hardware pin...

0000000080014388 <__fsym_pinRead_name>:
    80014388:	526e6970 00646165                       pinRead.

0000000080014390 <__fsym_pinWrite_desc>:
    80014390:	74697277 61762065 2065756c 68206f74     write value to h
    800143a0:	77647261 20657261 006e6970 00000000     ardware pin.....

00000000800143b0 <__fsym_pinWrite_name>:
    800143b0:	576e6970 65746972 00000000 00000000     pinWrite........

00000000800143c0 <__fsym_pinMode_desc>:
    800143c0:	20746573 64726168 65726177 6e697020     set hardware pin
    800143d0:	646f6d20 00000065                        mode...

00000000800143d8 <__fsym_pinMode_name>:
    800143d8:	4d6e6970 0065646f                       pinMode.

00000000800143e0 <__fsym___cmd_reboot>:
    800143e0:	80010a70 00000000 80010a60 00000000     p.......`.......
    800143f0:	80003878 00000000                       x8......

00000000800143f8 <__fsym___cmd_memtrace>:
    800143f8:	80011118 00000000 800110f8 00000000     ................
    80014408:	80004a08 00000000                       .J......

0000000080014410 <__fsym___cmd_memcheck>:
    80014410:	80011140 00000000 80011128 00000000     @.......(.......
    80014420:	80004cc8 00000000                       .L......

0000000080014428 <__fsym_list_mem>:
    80014428:	80011170 00000000 80011150 00000000     p.......P.......
    80014438:	800049bc 00000000                       .I......

0000000080014440 <__fsym___cmd_free>:
    80014440:	80012320 00000000 800122f8 00000000      #......."......
    80014450:	80008e78 00000000                       x.......

0000000080014458 <__fsym___cmd_ps>:
    80014458:	80012350 00000000 80012330 00000000     P#......0#......
    80014468:	80008e5c 00000000                       \.......

0000000080014470 <__fsym___cmd_help>:
    80014470:	80012378 00000000 80012360 00000000     x#......`#......
    80014480:	80008dac 00000000                       ........

0000000080014488 <__fsym___cmd_tail>:
    80014488:	80012890 00000000 80012860 00000000     .(......`(......
    80014498:	80009be8 00000000                       ........

00000000800144a0 <__fsym___cmd_echo>:
    800144a0:	800128b8 00000000 800128a0 00000000     .(.......(......
    800144b0:	8000a0d0 00000000                       ........

00000000800144b8 <__fsym___cmd_df>:
    800144b8:	800128d8 00000000 800128c8 00000000     .(.......(......
    800144c8:	8000a058 00000000                       X.......

00000000800144d0 <__fsym___cmd_umount>:
    800144d0:	80012908 00000000 800128e8 00000000     .).......(......
    800144e0:	80009b74 00000000                       t.......

00000000800144e8 <__fsym___cmd_mount>:
    800144e8:	80012940 00000000 80012918 00000000     @).......)......
    800144f8:	80009a68 00000000                       h.......

0000000080014500 <__fsym___cmd_mkfs>:
    80014500:	80012970 00000000 80012950 00000000     p)......P)......
    80014510:	800099e0 00000000                       ........

0000000080014518 <__fsym___cmd_mkdir>:
    80014518:	80012998 00000000 80012980 00000000     .).......)......
    80014528:	8000a00c 00000000                       ........

0000000080014530 <__fsym___cmd_pwd>:
    80014530:	800129e0 00000000 800129a8 00000000     .).......)......
    80014540:	80009588 00000000                       ........

0000000080014548 <__fsym___cmd_cd>:
    80014548:	80012a18 00000000 800129f0 00000000     .*.......)......
    80014558:	80009fa8 00000000                       ........

0000000080014560 <__fsym___cmd_rm>:
    80014560:	80012a48 00000000 80012a28 00000000     H*......(*......
    80014570:	800097f8 00000000                       ........

0000000080014578 <__fsym___cmd_cat>:
    80014578:	80012a70 00000000 80012a58 00000000     p*......X*......
    80014588:	80009f28 00000000                       (.......

0000000080014590 <__fsym___cmd_mv>:
    80014590:	80012a98 00000000 80012a80 00000000     .*.......*......
    800145a0:	80009dec 00000000                       ........

00000000800145a8 <__fsym___cmd_cp>:
    800145a8:	80012ac0 00000000 80012aa8 00000000     .*.......*......
    800145b8:	80009da0 00000000                       ........

00000000800145c0 <__fsym___cmd_ls>:
    800145c0:	80012af8 00000000 80012ad0 00000000     .*.......*......
    800145d0:	80009554 00000000                       T.......

00000000800145d8 <__fsym_list>:
    800145d8:	800133a8 00000000 80013388 00000000     .3.......3......
    800145e8:	8000ae20 00000000                        .......

00000000800145f0 <__fsym___cmd_list_device>:
    800145f0:	800133c8 00000000 800133b0 00000000     .3.......3......
    80014600:	8000bc5c 00000000                       \.......

0000000080014608 <__fsym_list_device>:
    80014608:	800133f8 00000000 800133e0 00000000     .3.......3......
    80014618:	8000bc5c 00000000                       \.......

0000000080014620 <__fsym___cmd_list_timer>:
    80014620:	80013420 00000000 80013408 00000000      4.......4......
    80014630:	8000afe8 00000000                       ........

0000000080014638 <__fsym_list_timer>:
    80014638:	80013450 00000000 80013438 00000000     P4......84......
    80014648:	8000afe8 00000000                       ........

0000000080014650 <__fsym___cmd_list_mempool>:
    80014650:	80013480 00000000 80013460 00000000     .4......`4......
    80014660:	8000bad4 00000000                       ........

0000000080014668 <__fsym_list_mempool>:
    80014668:	800134b8 00000000 80013498 00000000     .4.......4......
    80014678:	8000bad4 00000000                       ........

0000000080014680 <__fsym___cmd_list_msgqueue>:
    80014680:	800134e8 00000000 800134c8 00000000     .4.......4......
    80014690:	8000b944 00000000                       D.......

0000000080014698 <__fsym_list_msgqueue>:
    80014698:	80013520 00000000 80013500 00000000      5.......5......
    800146a8:	8000b944 00000000                       D.......

00000000800146b0 <__fsym___cmd_list_mailbox>:
    800146b0:	80013548 00000000 80013530 00000000     H5......05......
    800146c0:	8000b7ac 00000000                       ........

00000000800146c8 <__fsym_list_mailbox>:
    800146c8:	80013578 00000000 80013560 00000000     x5......`5......
    800146d8:	8000b7ac 00000000                       ........

00000000800146e0 <__fsym___cmd_list_mutex>:
    800146e0:	800135a0 00000000 80013588 00000000     .5.......5......
    800146f0:	8000b67c 00000000                       |.......

00000000800146f8 <__fsym_list_mutex>:
    800146f8:	800135d0 00000000 800135b8 00000000     .5.......5......
    80014708:	8000b67c 00000000                       |.......

0000000080014710 <__fsym___cmd_list_event>:
    80014710:	800135f8 00000000 800135e0 00000000     .5.......5......
    80014720:	8000b4f8 00000000                       ........

0000000080014728 <__fsym_list_event>:
    80014728:	80013628 00000000 80013610 00000000     (6.......6......
    80014738:	8000b4f8 00000000                       ........

0000000080014740 <__fsym___cmd_list_sem>:
    80014740:	80013658 00000000 80013638 00000000     X6......86......
    80014750:	8000b368 00000000                       h.......

0000000080014758 <__fsym_list_sem>:
    80014758:	80013688 00000000 80013668 00000000     .6......h6......
    80014768:	8000b368 00000000                       h.......

0000000080014770 <__fsym___cmd_list_thread>:
    80014770:	800136a8 00000000 80013698 00000000     .6.......6......
    80014780:	8000b14c 00000000                       L.......

0000000080014788 <__fsym_list_thread>:
    80014788:	800136d0 00000000 800136c0 00000000     .6.......6......
    80014798:	8000b14c 00000000                       L.......

00000000800147a0 <__fsym___cmd_version>:
    800147a0:	80013708 00000000 800136e0 00000000     .7.......6......
    800147b0:	8000ae04 00000000                       ........

00000000800147b8 <__fsym_version>:
    800147b8:	80013740 00000000 80013718 00000000     @7.......7......
    800147c8:	8000ae04 00000000                       ........

00000000800147d0 <__fsym___cmd_clear>:
    800147d0:	80013768 00000000 80013748 00000000     h7......H7......
    800147e0:	8000ad6c 00000000                       l.......

00000000800147e8 <__fsym_clear>:
    800147e8:	80013798 00000000 80013778 00000000     .7......x7......
    800147f8:	8000ad6c 00000000                       l.......

0000000080014800 <__fsym_hello>:
    80014800:	800137b0 00000000 800137a0 00000000     .7.......7......
    80014810:	8000ad48 00000000                       H.......

0000000080014818 <__fsym___cmd_list_fd>:
    80014818:	80013930 00000000 80013918 00000000     09.......9......
    80014828:	8000bdb8 00000000                       ........

0000000080014830 <__fsym_copy>:
    80014830:	80013b08 00000000 80013af0 00000000     .;.......:......
    80014840:	8000d140 00000000                       @.......

0000000080014848 <__fsym_cat>:
    80014848:	80013b20 00000000 80013b10 00000000      ;.......;......
    80014858:	8000c8d0 00000000                       ........

0000000080014860 <__fsym_rm>:
    80014860:	80013b48 00000000 80013b28 00000000     H;......(;......
    80014870:	8000ca94 00000000                       ........

0000000080014878 <__fsym_ls>:
    80014878:	80013b68 00000000 80013b50 00000000     h;......P;......
    80014888:	8000cdd4 00000000                       ........

0000000080014890 <__fsym_cd>:
    80014890:	80013b98 00000000 80013b70 00000000     .;......p;......
    800148a0:	8000da0c 00000000                       ........

00000000800148a8 <__fsym_mkdir>:
    800148a8:	80013bb8 00000000 80013ba0 00000000     .;.......;......
    800148b8:	8000d3c8 00000000                       ........

00000000800148c0 <__fsym_df>:
    800148c0:	80013d40 00000000 80013d30 00000000     @=......0=......
    800148d0:	8000e20c 00000000                       ........

00000000800148d8 <__fsym_mkfs>:
    800148d8:	80013d60 00000000 80013d48 00000000     `=......H=......
    800148e8:	8000e1c8 00000000                       ........

00000000800148f0 <__fsym_pinGet>:
    800148f0:	80014360 00000000 80014338 00000000     `C......8C......
    80014900:	80010364 00000000                       d.......

0000000080014908 <__fsym_pinRead>:
    80014908:	80014388 00000000 80014368 00000000     .C......hC......
    80014918:	80010300 00000000                       ........

0000000080014920 <__fsym_pinWrite>:
    80014920:	800143b0 00000000 80014390 00000000     .C.......C......
    80014930:	8001028c 00000000                       ........

0000000080014938 <__fsym_pinMode>:
    80014938:	800143d8 00000000 800143c0 00000000     .C.......C......
    80014948:	80010218 00000000                       ........

0000000080014950 <__rt_init_rti_start>:
    80014950:	80007764 00000000                       dw......

0000000080014958 <__rt_init_rti_board_start>:
    80014958:	80007774 00000000                       tw......

0000000080014960 <__rt_init_rti_board_end>:
    80014960:	8000777c 00000000                       |w......

0000000080014968 <__rt_init_dfs_init>:
    80014968:	8000bf58 00000000                       X.......

0000000080014970 <__rt_init_dfs_romfs_init>:
    80014970:	8000e560 00000000                       `.......

0000000080014978 <__rt_init_finsh_system_init>:
    80014978:	8000a584 00000000                       ........

0000000080014980 <__rt_init_rti_end>:
    80014980:	8000776c 00000000                       lw......
