
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8e013103          	ld	sp,-1824(sp) # 800088e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	133050ef          	jal	ra,80005948 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	2e8080e7          	jalr	744(ra) # 80006342 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	388080e7          	jalr	904(ra) # 800063f6 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	d6e080e7          	jalr	-658(ra) # 80005df8 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	1be080e7          	jalr	446(ra) # 800062b2 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	216080e7          	jalr	534(ra) # 80006342 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	2b2080e7          	jalr	690(ra) # 800063f6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	288080e7          	jalr	648(ra) # 800063f6 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	c22080e7          	jalr	-990(ra) # 80000f50 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	c06080e7          	jalr	-1018(ra) # 80000f50 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	ae6080e7          	jalr	-1306(ra) # 80005e42 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	90a080e7          	jalr	-1782(ra) # 80001c76 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	f5c080e7          	jalr	-164(ra) # 800052d0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	1b8080e7          	jalr	440(ra) # 80001534 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	986080e7          	jalr	-1658(ra) # 80005d0a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	c9c080e7          	jalr	-868(ra) # 80006028 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	aa6080e7          	jalr	-1370(ra) # 80005e42 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	a96080e7          	jalr	-1386(ra) # 80005e42 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	a86080e7          	jalr	-1402(ra) # 80005e42 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	ac6080e7          	jalr	-1338(ra) # 80000ea2 <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	86a080e7          	jalr	-1942(ra) # 80001c4e <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	88a080e7          	jalr	-1910(ra) # 80001c76 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	ec6080e7          	jalr	-314(ra) # 800052ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	ed4080e7          	jalr	-300(ra) # 800052d0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	094080e7          	jalr	148(ra) # 80002498 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	724080e7          	jalr	1828(ra) # 80002b30 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	6ce080e7          	jalr	1742(ra) # 80003ae2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	fd6080e7          	jalr	-42(ra) # 800053f2 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	ede080e7          	jalr	-290(ra) # 80001302 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	96a080e7          	jalr	-1686(ra) # 80005df8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	872080e7          	jalr	-1934(ra) # 80005df8 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	862080e7          	jalr	-1950(ra) # 80005df8 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00005097          	auipc	ra,0x5
    80000614:	7e8080e7          	jalr	2024(ra) # 80005df8 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	736080e7          	jalr	1846(ra) # 80000e0e <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00005097          	auipc	ra,0x5
    80000760:	69c080e7          	jalr	1692(ra) # 80005df8 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	68c080e7          	jalr	1676(ra) # 80005df8 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	67c080e7          	jalr	1660(ra) # 80005df8 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	66c080e7          	jalr	1644(ra) # 80005df8 <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	58e080e7          	jalr	1422(ra) # 80005df8 <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	44c080e7          	jalr	1100(ra) # 80005df8 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	370080e7          	jalr	880(ra) # 80005df8 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	360080e7          	jalr	864(ra) # 80005df8 <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	2f6080e7          	jalr	758(ra) # 80005df8 <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <print_helper>:

void print_helper(pagetable_t pagetable, int depth)
{
  if(depth > 2)
    80000cd6:	4789                	li	a5,2
    80000cd8:	0ab7cc63          	blt	a5,a1,80000d90 <print_helper+0xba>
{
    80000cdc:	7159                	addi	sp,sp,-112
    80000cde:	f486                	sd	ra,104(sp)
    80000ce0:	f0a2                	sd	s0,96(sp)
    80000ce2:	eca6                	sd	s1,88(sp)
    80000ce4:	e8ca                	sd	s2,80(sp)
    80000ce6:	e4ce                	sd	s3,72(sp)
    80000ce8:	e0d2                	sd	s4,64(sp)
    80000cea:	fc56                	sd	s5,56(sp)
    80000cec:	f85a                	sd	s6,48(sp)
    80000cee:	f45e                	sd	s7,40(sp)
    80000cf0:	f062                	sd	s8,32(sp)
    80000cf2:	ec66                	sd	s9,24(sp)
    80000cf4:	e86a                	sd	s10,16(sp)
    80000cf6:	e46e                	sd	s11,8(sp)
    80000cf8:	1880                	addi	s0,sp,112
    80000cfa:	8b2e                	mv	s6,a1
    80000cfc:	892a                	mv	s2,a0
    return;
  for(int i=0; i<512; i++){
    80000cfe:	4481                	li	s1,0
    pte_t pte = pagetable[i];
    if(pte & PTE_V){
      uint64 child = PTE2PA(pte);
      if(depth == 1)
    80000d00:	4c85                	li	s9,1
        printf(".. ");
      else
        printf(".. .. ");
      printf("..%d: pte %p pa %p\n", i, pte, child);
    80000d02:	00007c17          	auipc	s8,0x7
    80000d06:	466c0c13          	addi	s8,s8,1126 # 80008168 <etext+0x168>
      print_helper((pagetable_t)child, depth+1);
    80000d0a:	00158b9b          	addiw	s7,a1,1
        printf(".. .. ");
    80000d0e:	00007d17          	auipc	s10,0x7
    80000d12:	452d0d13          	addi	s10,s10,1106 # 80008160 <etext+0x160>
        printf(".. ");
    80000d16:	00007d97          	auipc	s11,0x7
    80000d1a:	442d8d93          	addi	s11,s11,1090 # 80008158 <etext+0x158>
  for(int i=0; i<512; i++){
    80000d1e:	20000a93          	li	s5,512
    80000d22:	a805                	j	80000d52 <print_helper+0x7c>
        printf(".. .. ");
    80000d24:	856a                	mv	a0,s10
    80000d26:	00005097          	auipc	ra,0x5
    80000d2a:	11c080e7          	jalr	284(ra) # 80005e42 <printf>
      printf("..%d: pte %p pa %p\n", i, pte, child);
    80000d2e:	86d2                	mv	a3,s4
    80000d30:	864e                	mv	a2,s3
    80000d32:	85a6                	mv	a1,s1
    80000d34:	8562                	mv	a0,s8
    80000d36:	00005097          	auipc	ra,0x5
    80000d3a:	10c080e7          	jalr	268(ra) # 80005e42 <printf>
      print_helper((pagetable_t)child, depth+1);
    80000d3e:	85de                	mv	a1,s7
    80000d40:	8552                	mv	a0,s4
    80000d42:	00000097          	auipc	ra,0x0
    80000d46:	f94080e7          	jalr	-108(ra) # 80000cd6 <print_helper>
  for(int i=0; i<512; i++){
    80000d4a:	2485                	addiw	s1,s1,1
    80000d4c:	0921                	addi	s2,s2,8
    80000d4e:	03548263          	beq	s1,s5,80000d72 <print_helper+0x9c>
    pte_t pte = pagetable[i];
    80000d52:	00093983          	ld	s3,0(s2) # 1000 <_entry-0x7ffff000>
    if(pte & PTE_V){
    80000d56:	0019f793          	andi	a5,s3,1
    80000d5a:	dbe5                	beqz	a5,80000d4a <print_helper+0x74>
      uint64 child = PTE2PA(pte);
    80000d5c:	00a9da13          	srli	s4,s3,0xa
    80000d60:	0a32                	slli	s4,s4,0xc
      if(depth == 1)
    80000d62:	fd9b11e3          	bne	s6,s9,80000d24 <print_helper+0x4e>
        printf(".. ");
    80000d66:	856e                	mv	a0,s11
    80000d68:	00005097          	auipc	ra,0x5
    80000d6c:	0da080e7          	jalr	218(ra) # 80005e42 <printf>
    80000d70:	bf7d                	j	80000d2e <print_helper+0x58>
    }
  }

  return;

}
    80000d72:	70a6                	ld	ra,104(sp)
    80000d74:	7406                	ld	s0,96(sp)
    80000d76:	64e6                	ld	s1,88(sp)
    80000d78:	6946                	ld	s2,80(sp)
    80000d7a:	69a6                	ld	s3,72(sp)
    80000d7c:	6a06                	ld	s4,64(sp)
    80000d7e:	7ae2                	ld	s5,56(sp)
    80000d80:	7b42                	ld	s6,48(sp)
    80000d82:	7ba2                	ld	s7,40(sp)
    80000d84:	7c02                	ld	s8,32(sp)
    80000d86:	6ce2                	ld	s9,24(sp)
    80000d88:	6d42                	ld	s10,16(sp)
    80000d8a:	6da2                	ld	s11,8(sp)
    80000d8c:	6165                	addi	sp,sp,112
    80000d8e:	8082                	ret
    80000d90:	8082                	ret

0000000080000d92 <vmprint>:

void
vmprint(pagetable_t pagetable)
{
    80000d92:	7139                	addi	sp,sp,-64
    80000d94:	fc06                	sd	ra,56(sp)
    80000d96:	f822                	sd	s0,48(sp)
    80000d98:	f426                	sd	s1,40(sp)
    80000d9a:	f04a                	sd	s2,32(sp)
    80000d9c:	ec4e                	sd	s3,24(sp)
    80000d9e:	e852                	sd	s4,16(sp)
    80000da0:	e456                	sd	s5,8(sp)
    80000da2:	0080                	addi	s0,sp,64
    80000da4:	892a                	mv	s2,a0
  // int depth = 0;
  printf("page table %p\n", pagetable);
    80000da6:	85aa                	mv	a1,a0
    80000da8:	00007517          	auipc	a0,0x7
    80000dac:	3d850513          	addi	a0,a0,984 # 80008180 <etext+0x180>
    80000db0:	00005097          	auipc	ra,0x5
    80000db4:	092080e7          	jalr	146(ra) # 80005e42 <printf>
  for(int i=0; i<512; i++){
    80000db8:	4481                	li	s1,0
    pte_t pte = pagetable[i];
    if(pte & PTE_V){
      uint64 child = PTE2PA(pte);
      printf("..%d: pte %p pa %p\n", i, pte, child);
    80000dba:	00007a97          	auipc	s5,0x7
    80000dbe:	3aea8a93          	addi	s5,s5,942 # 80008168 <etext+0x168>
  for(int i=0; i<512; i++){
    80000dc2:	20000a13          	li	s4,512
    80000dc6:	a02d                	j	80000df0 <vmprint+0x5e>
      uint64 child = PTE2PA(pte);
    80000dc8:	00a65993          	srli	s3,a2,0xa
    80000dcc:	09b2                	slli	s3,s3,0xc
      printf("..%d: pte %p pa %p\n", i, pte, child);
    80000dce:	86ce                	mv	a3,s3
    80000dd0:	85a6                	mv	a1,s1
    80000dd2:	8556                	mv	a0,s5
    80000dd4:	00005097          	auipc	ra,0x5
    80000dd8:	06e080e7          	jalr	110(ra) # 80005e42 <printf>
      print_helper((pagetable_t)child, 1);
    80000ddc:	4585                	li	a1,1
    80000dde:	854e                	mv	a0,s3
    80000de0:	00000097          	auipc	ra,0x0
    80000de4:	ef6080e7          	jalr	-266(ra) # 80000cd6 <print_helper>
  for(int i=0; i<512; i++){
    80000de8:	2485                	addiw	s1,s1,1
    80000dea:	0921                	addi	s2,s2,8
    80000dec:	01448863          	beq	s1,s4,80000dfc <vmprint+0x6a>
    pte_t pte = pagetable[i];
    80000df0:	00093603          	ld	a2,0(s2)
    if(pte & PTE_V){
    80000df4:	00167793          	andi	a5,a2,1
    80000df8:	dbe5                	beqz	a5,80000de8 <vmprint+0x56>
    80000dfa:	b7f9                	j	80000dc8 <vmprint+0x36>
    }
  }
  return;
    80000dfc:	70e2                	ld	ra,56(sp)
    80000dfe:	7442                	ld	s0,48(sp)
    80000e00:	74a2                	ld	s1,40(sp)
    80000e02:	7902                	ld	s2,32(sp)
    80000e04:	69e2                	ld	s3,24(sp)
    80000e06:	6a42                	ld	s4,16(sp)
    80000e08:	6aa2                	ld	s5,8(sp)
    80000e0a:	6121                	addi	sp,sp,64
    80000e0c:	8082                	ret

0000000080000e0e <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e0e:	7139                	addi	sp,sp,-64
    80000e10:	fc06                	sd	ra,56(sp)
    80000e12:	f822                	sd	s0,48(sp)
    80000e14:	f426                	sd	s1,40(sp)
    80000e16:	f04a                	sd	s2,32(sp)
    80000e18:	ec4e                	sd	s3,24(sp)
    80000e1a:	e852                	sd	s4,16(sp)
    80000e1c:	e456                	sd	s5,8(sp)
    80000e1e:	e05a                	sd	s6,0(sp)
    80000e20:	0080                	addi	s0,sp,64
    80000e22:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e24:	00008497          	auipc	s1,0x8
    80000e28:	65c48493          	addi	s1,s1,1628 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e2c:	8b26                	mv	s6,s1
    80000e2e:	00007a97          	auipc	s5,0x7
    80000e32:	1d2a8a93          	addi	s5,s5,466 # 80008000 <etext>
    80000e36:	01000937          	lui	s2,0x1000
    80000e3a:	197d                	addi	s2,s2,-1
    80000e3c:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e3e:	0000ea17          	auipc	s4,0xe
    80000e42:	242a0a13          	addi	s4,s4,578 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000e46:	fffff097          	auipc	ra,0xfffff
    80000e4a:	2d2080e7          	jalr	722(ra) # 80000118 <kalloc>
    80000e4e:	862a                	mv	a2,a0
    if(pa == 0)
    80000e50:	c129                	beqz	a0,80000e92 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e52:	416485b3          	sub	a1,s1,s6
    80000e56:	8591                	srai	a1,a1,0x4
    80000e58:	000ab783          	ld	a5,0(s5)
    80000e5c:	02f585b3          	mul	a1,a1,a5
    80000e60:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e64:	4719                	li	a4,6
    80000e66:	6685                	lui	a3,0x1
    80000e68:	40b905b3          	sub	a1,s2,a1
    80000e6c:	854e                	mv	a0,s3
    80000e6e:	fffff097          	auipc	ra,0xfffff
    80000e72:	77a080e7          	jalr	1914(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e76:	17048493          	addi	s1,s1,368
    80000e7a:	fd4496e3          	bne	s1,s4,80000e46 <proc_mapstacks+0x38>
  }
}
    80000e7e:	70e2                	ld	ra,56(sp)
    80000e80:	7442                	ld	s0,48(sp)
    80000e82:	74a2                	ld	s1,40(sp)
    80000e84:	7902                	ld	s2,32(sp)
    80000e86:	69e2                	ld	s3,24(sp)
    80000e88:	6a42                	ld	s4,16(sp)
    80000e8a:	6aa2                	ld	s5,8(sp)
    80000e8c:	6b02                	ld	s6,0(sp)
    80000e8e:	6121                	addi	sp,sp,64
    80000e90:	8082                	ret
      panic("kalloc");
    80000e92:	00007517          	auipc	a0,0x7
    80000e96:	2fe50513          	addi	a0,a0,766 # 80008190 <etext+0x190>
    80000e9a:	00005097          	auipc	ra,0x5
    80000e9e:	f5e080e7          	jalr	-162(ra) # 80005df8 <panic>

0000000080000ea2 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000ea2:	7139                	addi	sp,sp,-64
    80000ea4:	fc06                	sd	ra,56(sp)
    80000ea6:	f822                	sd	s0,48(sp)
    80000ea8:	f426                	sd	s1,40(sp)
    80000eaa:	f04a                	sd	s2,32(sp)
    80000eac:	ec4e                	sd	s3,24(sp)
    80000eae:	e852                	sd	s4,16(sp)
    80000eb0:	e456                	sd	s5,8(sp)
    80000eb2:	e05a                	sd	s6,0(sp)
    80000eb4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000eb6:	00007597          	auipc	a1,0x7
    80000eba:	2e258593          	addi	a1,a1,738 # 80008198 <etext+0x198>
    80000ebe:	00008517          	auipc	a0,0x8
    80000ec2:	19250513          	addi	a0,a0,402 # 80009050 <pid_lock>
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	3ec080e7          	jalr	1004(ra) # 800062b2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ece:	00007597          	auipc	a1,0x7
    80000ed2:	2d258593          	addi	a1,a1,722 # 800081a0 <etext+0x1a0>
    80000ed6:	00008517          	auipc	a0,0x8
    80000eda:	19250513          	addi	a0,a0,402 # 80009068 <wait_lock>
    80000ede:	00005097          	auipc	ra,0x5
    80000ee2:	3d4080e7          	jalr	980(ra) # 800062b2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee6:	00008497          	auipc	s1,0x8
    80000eea:	59a48493          	addi	s1,s1,1434 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000eee:	00007b17          	auipc	s6,0x7
    80000ef2:	2c2b0b13          	addi	s6,s6,706 # 800081b0 <etext+0x1b0>
      p->kstack = KSTACK((int) (p - proc));
    80000ef6:	8aa6                	mv	s5,s1
    80000ef8:	00007a17          	auipc	s4,0x7
    80000efc:	108a0a13          	addi	s4,s4,264 # 80008000 <etext>
    80000f00:	01000937          	lui	s2,0x1000
    80000f04:	197d                	addi	s2,s2,-1
    80000f06:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f08:	0000e997          	auipc	s3,0xe
    80000f0c:	17898993          	addi	s3,s3,376 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000f10:	85da                	mv	a1,s6
    80000f12:	8526                	mv	a0,s1
    80000f14:	00005097          	auipc	ra,0x5
    80000f18:	39e080e7          	jalr	926(ra) # 800062b2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f1c:	415487b3          	sub	a5,s1,s5
    80000f20:	8791                	srai	a5,a5,0x4
    80000f22:	000a3703          	ld	a4,0(s4)
    80000f26:	02e787b3          	mul	a5,a5,a4
    80000f2a:	00d7979b          	slliw	a5,a5,0xd
    80000f2e:	40f907b3          	sub	a5,s2,a5
    80000f32:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f34:	17048493          	addi	s1,s1,368
    80000f38:	fd349ce3          	bne	s1,s3,80000f10 <procinit+0x6e>
  }
}
    80000f3c:	70e2                	ld	ra,56(sp)
    80000f3e:	7442                	ld	s0,48(sp)
    80000f40:	74a2                	ld	s1,40(sp)
    80000f42:	7902                	ld	s2,32(sp)
    80000f44:	69e2                	ld	s3,24(sp)
    80000f46:	6a42                	ld	s4,16(sp)
    80000f48:	6aa2                	ld	s5,8(sp)
    80000f4a:	6b02                	ld	s6,0(sp)
    80000f4c:	6121                	addi	sp,sp,64
    80000f4e:	8082                	ret

0000000080000f50 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f50:	1141                	addi	sp,sp,-16
    80000f52:	e422                	sd	s0,8(sp)
    80000f54:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f56:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f58:	2501                	sext.w	a0,a0
    80000f5a:	6422                	ld	s0,8(sp)
    80000f5c:	0141                	addi	sp,sp,16
    80000f5e:	8082                	ret

0000000080000f60 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f60:	1141                	addi	sp,sp,-16
    80000f62:	e422                	sd	s0,8(sp)
    80000f64:	0800                	addi	s0,sp,16
    80000f66:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f68:	2781                	sext.w	a5,a5
    80000f6a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f6c:	00008517          	auipc	a0,0x8
    80000f70:	11450513          	addi	a0,a0,276 # 80009080 <cpus>
    80000f74:	953e                	add	a0,a0,a5
    80000f76:	6422                	ld	s0,8(sp)
    80000f78:	0141                	addi	sp,sp,16
    80000f7a:	8082                	ret

0000000080000f7c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f7c:	1101                	addi	sp,sp,-32
    80000f7e:	ec06                	sd	ra,24(sp)
    80000f80:	e822                	sd	s0,16(sp)
    80000f82:	e426                	sd	s1,8(sp)
    80000f84:	1000                	addi	s0,sp,32
  push_off();
    80000f86:	00005097          	auipc	ra,0x5
    80000f8a:	370080e7          	jalr	880(ra) # 800062f6 <push_off>
    80000f8e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f90:	2781                	sext.w	a5,a5
    80000f92:	079e                	slli	a5,a5,0x7
    80000f94:	00008717          	auipc	a4,0x8
    80000f98:	0bc70713          	addi	a4,a4,188 # 80009050 <pid_lock>
    80000f9c:	97ba                	add	a5,a5,a4
    80000f9e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	3f6080e7          	jalr	1014(ra) # 80006396 <pop_off>
  return p;
}
    80000fa8:	8526                	mv	a0,s1
    80000faa:	60e2                	ld	ra,24(sp)
    80000fac:	6442                	ld	s0,16(sp)
    80000fae:	64a2                	ld	s1,8(sp)
    80000fb0:	6105                	addi	sp,sp,32
    80000fb2:	8082                	ret

0000000080000fb4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fb4:	1141                	addi	sp,sp,-16
    80000fb6:	e406                	sd	ra,8(sp)
    80000fb8:	e022                	sd	s0,0(sp)
    80000fba:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fbc:	00000097          	auipc	ra,0x0
    80000fc0:	fc0080e7          	jalr	-64(ra) # 80000f7c <myproc>
    80000fc4:	00005097          	auipc	ra,0x5
    80000fc8:	432080e7          	jalr	1074(ra) # 800063f6 <release>

  if (first) {
    80000fcc:	00008797          	auipc	a5,0x8
    80000fd0:	8c47a783          	lw	a5,-1852(a5) # 80008890 <first.1681>
    80000fd4:	eb89                	bnez	a5,80000fe6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fd6:	00001097          	auipc	ra,0x1
    80000fda:	cb8080e7          	jalr	-840(ra) # 80001c8e <usertrapret>
}
    80000fde:	60a2                	ld	ra,8(sp)
    80000fe0:	6402                	ld	s0,0(sp)
    80000fe2:	0141                	addi	sp,sp,16
    80000fe4:	8082                	ret
    first = 0;
    80000fe6:	00008797          	auipc	a5,0x8
    80000fea:	8a07a523          	sw	zero,-1878(a5) # 80008890 <first.1681>
    fsinit(ROOTDEV);
    80000fee:	4505                	li	a0,1
    80000ff0:	00002097          	auipc	ra,0x2
    80000ff4:	ac0080e7          	jalr	-1344(ra) # 80002ab0 <fsinit>
    80000ff8:	bff9                	j	80000fd6 <forkret+0x22>

0000000080000ffa <allocpid>:
allocpid() {
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	e04a                	sd	s2,0(sp)
    80001004:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001006:	00008917          	auipc	s2,0x8
    8000100a:	04a90913          	addi	s2,s2,74 # 80009050 <pid_lock>
    8000100e:	854a                	mv	a0,s2
    80001010:	00005097          	auipc	ra,0x5
    80001014:	332080e7          	jalr	818(ra) # 80006342 <acquire>
  pid = nextpid;
    80001018:	00008797          	auipc	a5,0x8
    8000101c:	87c78793          	addi	a5,a5,-1924 # 80008894 <nextpid>
    80001020:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001022:	0014871b          	addiw	a4,s1,1
    80001026:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001028:	854a                	mv	a0,s2
    8000102a:	00005097          	auipc	ra,0x5
    8000102e:	3cc080e7          	jalr	972(ra) # 800063f6 <release>
}
    80001032:	8526                	mv	a0,s1
    80001034:	60e2                	ld	ra,24(sp)
    80001036:	6442                	ld	s0,16(sp)
    80001038:	64a2                	ld	s1,8(sp)
    8000103a:	6902                	ld	s2,0(sp)
    8000103c:	6105                	addi	sp,sp,32
    8000103e:	8082                	ret

0000000080001040 <proc_pagetable>:
{
    80001040:	1101                	addi	sp,sp,-32
    80001042:	ec06                	sd	ra,24(sp)
    80001044:	e822                	sd	s0,16(sp)
    80001046:	e426                	sd	s1,8(sp)
    80001048:	e04a                	sd	s2,0(sp)
    8000104a:	1000                	addi	s0,sp,32
    8000104c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	784080e7          	jalr	1924(ra) # 800007d2 <uvmcreate>
    80001056:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001058:	cd39                	beqz	a0,800010b6 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000105a:	4729                	li	a4,10
    8000105c:	00006697          	auipc	a3,0x6
    80001060:	fa468693          	addi	a3,a3,-92 # 80007000 <_trampoline>
    80001064:	6605                	lui	a2,0x1
    80001066:	040005b7          	lui	a1,0x4000
    8000106a:	15fd                	addi	a1,a1,-1
    8000106c:	05b2                	slli	a1,a1,0xc
    8000106e:	fffff097          	auipc	ra,0xfffff
    80001072:	4da080e7          	jalr	1242(ra) # 80000548 <mappages>
    80001076:	04054763          	bltz	a0,800010c4 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000107a:	4719                	li	a4,6
    8000107c:	05893683          	ld	a3,88(s2)
    80001080:	6605                	lui	a2,0x1
    80001082:	020005b7          	lui	a1,0x2000
    80001086:	15fd                	addi	a1,a1,-1
    80001088:	05b6                	slli	a1,a1,0xd
    8000108a:	8526                	mv	a0,s1
    8000108c:	fffff097          	auipc	ra,0xfffff
    80001090:	4bc080e7          	jalr	1212(ra) # 80000548 <mappages>
    80001094:	04054063          	bltz	a0,800010d4 <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    80001098:	4749                	li	a4,18
    8000109a:	06093683          	ld	a3,96(s2)
    8000109e:	6605                	lui	a2,0x1
    800010a0:	040005b7          	lui	a1,0x4000
    800010a4:	15f5                	addi	a1,a1,-3
    800010a6:	05b2                	slli	a1,a1,0xc
    800010a8:	8526                	mv	a0,s1
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	49e080e7          	jalr	1182(ra) # 80000548 <mappages>
    800010b2:	04054463          	bltz	a0,800010fa <proc_pagetable+0xba>
}
    800010b6:	8526                	mv	a0,s1
    800010b8:	60e2                	ld	ra,24(sp)
    800010ba:	6442                	ld	s0,16(sp)
    800010bc:	64a2                	ld	s1,8(sp)
    800010be:	6902                	ld	s2,0(sp)
    800010c0:	6105                	addi	sp,sp,32
    800010c2:	8082                	ret
    uvmfree(pagetable, 0);
    800010c4:	4581                	li	a1,0
    800010c6:	8526                	mv	a0,s1
    800010c8:	00000097          	auipc	ra,0x0
    800010cc:	906080e7          	jalr	-1786(ra) # 800009ce <uvmfree>
    return 0;
    800010d0:	4481                	li	s1,0
    800010d2:	b7d5                	j	800010b6 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010d4:	4681                	li	a3,0
    800010d6:	4605                	li	a2,1
    800010d8:	040005b7          	lui	a1,0x4000
    800010dc:	15fd                	addi	a1,a1,-1
    800010de:	05b2                	slli	a1,a1,0xc
    800010e0:	8526                	mv	a0,s1
    800010e2:	fffff097          	auipc	ra,0xfffff
    800010e6:	62c080e7          	jalr	1580(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    800010ea:	4581                	li	a1,0
    800010ec:	8526                	mv	a0,s1
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	8e0080e7          	jalr	-1824(ra) # 800009ce <uvmfree>
    return 0;
    800010f6:	4481                	li	s1,0
    800010f8:	bf7d                	j	800010b6 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010fa:	4681                	li	a3,0
    800010fc:	4605                	li	a2,1
    800010fe:	040005b7          	lui	a1,0x4000
    80001102:	15fd                	addi	a1,a1,-1
    80001104:	05b2                	slli	a1,a1,0xc
    80001106:	8526                	mv	a0,s1
    80001108:	fffff097          	auipc	ra,0xfffff
    8000110c:	606080e7          	jalr	1542(ra) # 8000070e <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001110:	4681                	li	a3,0
    80001112:	4605                	li	a2,1
    80001114:	020005b7          	lui	a1,0x2000
    80001118:	15fd                	addi	a1,a1,-1
    8000111a:	05b6                	slli	a1,a1,0xd
    8000111c:	8526                	mv	a0,s1
    8000111e:	fffff097          	auipc	ra,0xfffff
    80001122:	5f0080e7          	jalr	1520(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80001126:	4581                	li	a1,0
    80001128:	8526                	mv	a0,s1
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	8a4080e7          	jalr	-1884(ra) # 800009ce <uvmfree>
    return 0;
    80001132:	4481                	li	s1,0
    80001134:	b749                	j	800010b6 <proc_pagetable+0x76>

0000000080001136 <proc_freepagetable>:
{
    80001136:	7179                	addi	sp,sp,-48
    80001138:	f406                	sd	ra,40(sp)
    8000113a:	f022                	sd	s0,32(sp)
    8000113c:	ec26                	sd	s1,24(sp)
    8000113e:	e84a                	sd	s2,16(sp)
    80001140:	e44e                	sd	s3,8(sp)
    80001142:	1800                	addi	s0,sp,48
    80001144:	84aa                	mv	s1,a0
    80001146:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001148:	4681                	li	a3,0
    8000114a:	4605                	li	a2,1
    8000114c:	04000937          	lui	s2,0x4000
    80001150:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001154:	05b2                	slli	a1,a1,0xc
    80001156:	fffff097          	auipc	ra,0xfffff
    8000115a:	5b8080e7          	jalr	1464(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000115e:	4681                	li	a3,0
    80001160:	4605                	li	a2,1
    80001162:	020005b7          	lui	a1,0x2000
    80001166:	15fd                	addi	a1,a1,-1
    80001168:	05b6                	slli	a1,a1,0xd
    8000116a:	8526                	mv	a0,s1
    8000116c:	fffff097          	auipc	ra,0xfffff
    80001170:	5a2080e7          	jalr	1442(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80001174:	4681                	li	a3,0
    80001176:	4605                	li	a2,1
    80001178:	1975                	addi	s2,s2,-3
    8000117a:	00c91593          	slli	a1,s2,0xc
    8000117e:	8526                	mv	a0,s1
    80001180:	fffff097          	auipc	ra,0xfffff
    80001184:	58e080e7          	jalr	1422(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80001188:	85ce                	mv	a1,s3
    8000118a:	8526                	mv	a0,s1
    8000118c:	00000097          	auipc	ra,0x0
    80001190:	842080e7          	jalr	-1982(ra) # 800009ce <uvmfree>
}
    80001194:	70a2                	ld	ra,40(sp)
    80001196:	7402                	ld	s0,32(sp)
    80001198:	64e2                	ld	s1,24(sp)
    8000119a:	6942                	ld	s2,16(sp)
    8000119c:	69a2                	ld	s3,8(sp)
    8000119e:	6145                	addi	sp,sp,48
    800011a0:	8082                	ret

00000000800011a2 <freeproc>:
{
    800011a2:	1101                	addi	sp,sp,-32
    800011a4:	ec06                	sd	ra,24(sp)
    800011a6:	e822                	sd	s0,16(sp)
    800011a8:	e426                	sd	s1,8(sp)
    800011aa:	1000                	addi	s0,sp,32
    800011ac:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011ae:	6d28                	ld	a0,88(a0)
    800011b0:	c509                	beqz	a0,800011ba <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011b2:	fffff097          	auipc	ra,0xfffff
    800011b6:	e6a080e7          	jalr	-406(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011ba:	0404bc23          	sd	zero,88(s1)
  if(p->usyscall)
    800011be:	70a8                	ld	a0,96(s1)
    800011c0:	c509                	beqz	a0,800011ca <freeproc+0x28>
    kfree((void*)p->usyscall);
    800011c2:	fffff097          	auipc	ra,0xfffff
    800011c6:	e5a080e7          	jalr	-422(ra) # 8000001c <kfree>
  p->usyscall = 0;
    800011ca:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011ce:	68a8                	ld	a0,80(s1)
    800011d0:	c511                	beqz	a0,800011dc <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    800011d2:	64ac                	ld	a1,72(s1)
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	f62080e7          	jalr	-158(ra) # 80001136 <proc_freepagetable>
  p->pagetable = 0;
    800011dc:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011e0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011e4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011e8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011ec:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011f0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011f4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011f8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011fc:	0004ac23          	sw	zero,24(s1)
}
    80001200:	60e2                	ld	ra,24(sp)
    80001202:	6442                	ld	s0,16(sp)
    80001204:	64a2                	ld	s1,8(sp)
    80001206:	6105                	addi	sp,sp,32
    80001208:	8082                	ret

000000008000120a <allocproc>:
{
    8000120a:	1101                	addi	sp,sp,-32
    8000120c:	ec06                	sd	ra,24(sp)
    8000120e:	e822                	sd	s0,16(sp)
    80001210:	e426                	sd	s1,8(sp)
    80001212:	e04a                	sd	s2,0(sp)
    80001214:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001216:	00008497          	auipc	s1,0x8
    8000121a:	26a48493          	addi	s1,s1,618 # 80009480 <proc>
    8000121e:	0000e917          	auipc	s2,0xe
    80001222:	e6290913          	addi	s2,s2,-414 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001226:	8526                	mv	a0,s1
    80001228:	00005097          	auipc	ra,0x5
    8000122c:	11a080e7          	jalr	282(ra) # 80006342 <acquire>
    if(p->state == UNUSED) {
    80001230:	4c9c                	lw	a5,24(s1)
    80001232:	cf81                	beqz	a5,8000124a <allocproc+0x40>
      release(&p->lock);
    80001234:	8526                	mv	a0,s1
    80001236:	00005097          	auipc	ra,0x5
    8000123a:	1c0080e7          	jalr	448(ra) # 800063f6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000123e:	17048493          	addi	s1,s1,368
    80001242:	ff2492e3          	bne	s1,s2,80001226 <allocproc+0x1c>
  return 0;
    80001246:	4481                	li	s1,0
    80001248:	a095                	j	800012ac <allocproc+0xa2>
  p->pid = allocpid();
    8000124a:	00000097          	auipc	ra,0x0
    8000124e:	db0080e7          	jalr	-592(ra) # 80000ffa <allocpid>
    80001252:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001254:	4785                	li	a5,1
    80001256:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	ec0080e7          	jalr	-320(ra) # 80000118 <kalloc>
    80001260:	892a                	mv	s2,a0
    80001262:	eca8                	sd	a0,88(s1)
    80001264:	c939                	beqz	a0,800012ba <allocproc+0xb0>
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    80001266:	fffff097          	auipc	ra,0xfffff
    8000126a:	eb2080e7          	jalr	-334(ra) # 80000118 <kalloc>
    8000126e:	892a                	mv	s2,a0
    80001270:	f0a8                	sd	a0,96(s1)
    80001272:	c125                	beqz	a0,800012d2 <allocproc+0xc8>
  p->usyscall->pid = p->pid;
    80001274:	589c                	lw	a5,48(s1)
    80001276:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    80001278:	8526                	mv	a0,s1
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	dc6080e7          	jalr	-570(ra) # 80001040 <proc_pagetable>
    80001282:	892a                	mv	s2,a0
    80001284:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001286:	c135                	beqz	a0,800012ea <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    80001288:	07000613          	li	a2,112
    8000128c:	4581                	li	a1,0
    8000128e:	06848513          	addi	a0,s1,104
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	ee6080e7          	jalr	-282(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000129a:	00000797          	auipc	a5,0x0
    8000129e:	d1a78793          	addi	a5,a5,-742 # 80000fb4 <forkret>
    800012a2:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012a4:	60bc                	ld	a5,64(s1)
    800012a6:	6705                	lui	a4,0x1
    800012a8:	97ba                	add	a5,a5,a4
    800012aa:	f8bc                	sd	a5,112(s1)
}
    800012ac:	8526                	mv	a0,s1
    800012ae:	60e2                	ld	ra,24(sp)
    800012b0:	6442                	ld	s0,16(sp)
    800012b2:	64a2                	ld	s1,8(sp)
    800012b4:	6902                	ld	s2,0(sp)
    800012b6:	6105                	addi	sp,sp,32
    800012b8:	8082                	ret
    freeproc(p);
    800012ba:	8526                	mv	a0,s1
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	ee6080e7          	jalr	-282(ra) # 800011a2 <freeproc>
    release(&p->lock);
    800012c4:	8526                	mv	a0,s1
    800012c6:	00005097          	auipc	ra,0x5
    800012ca:	130080e7          	jalr	304(ra) # 800063f6 <release>
    return 0;
    800012ce:	84ca                	mv	s1,s2
    800012d0:	bff1                	j	800012ac <allocproc+0xa2>
    freeproc(p);
    800012d2:	8526                	mv	a0,s1
    800012d4:	00000097          	auipc	ra,0x0
    800012d8:	ece080e7          	jalr	-306(ra) # 800011a2 <freeproc>
    release(&p->lock);
    800012dc:	8526                	mv	a0,s1
    800012de:	00005097          	auipc	ra,0x5
    800012e2:	118080e7          	jalr	280(ra) # 800063f6 <release>
    return 0;
    800012e6:	84ca                	mv	s1,s2
    800012e8:	b7d1                	j	800012ac <allocproc+0xa2>
    freeproc(p);
    800012ea:	8526                	mv	a0,s1
    800012ec:	00000097          	auipc	ra,0x0
    800012f0:	eb6080e7          	jalr	-330(ra) # 800011a2 <freeproc>
    release(&p->lock);
    800012f4:	8526                	mv	a0,s1
    800012f6:	00005097          	auipc	ra,0x5
    800012fa:	100080e7          	jalr	256(ra) # 800063f6 <release>
    return 0;
    800012fe:	84ca                	mv	s1,s2
    80001300:	b775                	j	800012ac <allocproc+0xa2>

0000000080001302 <userinit>:
{
    80001302:	1101                	addi	sp,sp,-32
    80001304:	ec06                	sd	ra,24(sp)
    80001306:	e822                	sd	s0,16(sp)
    80001308:	e426                	sd	s1,8(sp)
    8000130a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000130c:	00000097          	auipc	ra,0x0
    80001310:	efe080e7          	jalr	-258(ra) # 8000120a <allocproc>
    80001314:	84aa                	mv	s1,a0
  initproc = p;
    80001316:	00008797          	auipc	a5,0x8
    8000131a:	cea7bd23          	sd	a0,-774(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000131e:	03400613          	li	a2,52
    80001322:	00007597          	auipc	a1,0x7
    80001326:	57e58593          	addi	a1,a1,1406 # 800088a0 <initcode>
    8000132a:	6928                	ld	a0,80(a0)
    8000132c:	fffff097          	auipc	ra,0xfffff
    80001330:	4d4080e7          	jalr	1236(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001334:	6785                	lui	a5,0x1
    80001336:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001338:	6cb8                	ld	a4,88(s1)
    8000133a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000133e:	6cb8                	ld	a4,88(s1)
    80001340:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001342:	4641                	li	a2,16
    80001344:	00007597          	auipc	a1,0x7
    80001348:	e7458593          	addi	a1,a1,-396 # 800081b8 <etext+0x1b8>
    8000134c:	16048513          	addi	a0,s1,352
    80001350:	fffff097          	auipc	ra,0xfffff
    80001354:	f7a080e7          	jalr	-134(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001358:	00007517          	auipc	a0,0x7
    8000135c:	e7050513          	addi	a0,a0,-400 # 800081c8 <etext+0x1c8>
    80001360:	00002097          	auipc	ra,0x2
    80001364:	17e080e7          	jalr	382(ra) # 800034de <namei>
    80001368:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000136c:	478d                	li	a5,3
    8000136e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001370:	8526                	mv	a0,s1
    80001372:	00005097          	auipc	ra,0x5
    80001376:	084080e7          	jalr	132(ra) # 800063f6 <release>
}
    8000137a:	60e2                	ld	ra,24(sp)
    8000137c:	6442                	ld	s0,16(sp)
    8000137e:	64a2                	ld	s1,8(sp)
    80001380:	6105                	addi	sp,sp,32
    80001382:	8082                	ret

0000000080001384 <growproc>:
{
    80001384:	1101                	addi	sp,sp,-32
    80001386:	ec06                	sd	ra,24(sp)
    80001388:	e822                	sd	s0,16(sp)
    8000138a:	e426                	sd	s1,8(sp)
    8000138c:	e04a                	sd	s2,0(sp)
    8000138e:	1000                	addi	s0,sp,32
    80001390:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001392:	00000097          	auipc	ra,0x0
    80001396:	bea080e7          	jalr	-1046(ra) # 80000f7c <myproc>
    8000139a:	892a                	mv	s2,a0
  sz = p->sz;
    8000139c:	652c                	ld	a1,72(a0)
    8000139e:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800013a2:	00904f63          	bgtz	s1,800013c0 <growproc+0x3c>
  } else if(n < 0){
    800013a6:	0204cc63          	bltz	s1,800013de <growproc+0x5a>
  p->sz = sz;
    800013aa:	1602                	slli	a2,a2,0x20
    800013ac:	9201                	srli	a2,a2,0x20
    800013ae:	04c93423          	sd	a2,72(s2)
  return 0;
    800013b2:	4501                	li	a0,0
}
    800013b4:	60e2                	ld	ra,24(sp)
    800013b6:	6442                	ld	s0,16(sp)
    800013b8:	64a2                	ld	s1,8(sp)
    800013ba:	6902                	ld	s2,0(sp)
    800013bc:	6105                	addi	sp,sp,32
    800013be:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800013c0:	9e25                	addw	a2,a2,s1
    800013c2:	1602                	slli	a2,a2,0x20
    800013c4:	9201                	srli	a2,a2,0x20
    800013c6:	1582                	slli	a1,a1,0x20
    800013c8:	9181                	srli	a1,a1,0x20
    800013ca:	6928                	ld	a0,80(a0)
    800013cc:	fffff097          	auipc	ra,0xfffff
    800013d0:	4ee080e7          	jalr	1262(ra) # 800008ba <uvmalloc>
    800013d4:	0005061b          	sext.w	a2,a0
    800013d8:	fa69                	bnez	a2,800013aa <growproc+0x26>
      return -1;
    800013da:	557d                	li	a0,-1
    800013dc:	bfe1                	j	800013b4 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013de:	9e25                	addw	a2,a2,s1
    800013e0:	1602                	slli	a2,a2,0x20
    800013e2:	9201                	srli	a2,a2,0x20
    800013e4:	1582                	slli	a1,a1,0x20
    800013e6:	9181                	srli	a1,a1,0x20
    800013e8:	6928                	ld	a0,80(a0)
    800013ea:	fffff097          	auipc	ra,0xfffff
    800013ee:	488080e7          	jalr	1160(ra) # 80000872 <uvmdealloc>
    800013f2:	0005061b          	sext.w	a2,a0
    800013f6:	bf55                	j	800013aa <growproc+0x26>

00000000800013f8 <fork>:
{
    800013f8:	7179                	addi	sp,sp,-48
    800013fa:	f406                	sd	ra,40(sp)
    800013fc:	f022                	sd	s0,32(sp)
    800013fe:	ec26                	sd	s1,24(sp)
    80001400:	e84a                	sd	s2,16(sp)
    80001402:	e44e                	sd	s3,8(sp)
    80001404:	e052                	sd	s4,0(sp)
    80001406:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001408:	00000097          	auipc	ra,0x0
    8000140c:	b74080e7          	jalr	-1164(ra) # 80000f7c <myproc>
    80001410:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001412:	00000097          	auipc	ra,0x0
    80001416:	df8080e7          	jalr	-520(ra) # 8000120a <allocproc>
    8000141a:	10050b63          	beqz	a0,80001530 <fork+0x138>
    8000141e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001420:	04893603          	ld	a2,72(s2)
    80001424:	692c                	ld	a1,80(a0)
    80001426:	05093503          	ld	a0,80(s2)
    8000142a:	fffff097          	auipc	ra,0xfffff
    8000142e:	5dc080e7          	jalr	1500(ra) # 80000a06 <uvmcopy>
    80001432:	04054663          	bltz	a0,8000147e <fork+0x86>
  np->sz = p->sz;
    80001436:	04893783          	ld	a5,72(s2)
    8000143a:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000143e:	05893683          	ld	a3,88(s2)
    80001442:	87b6                	mv	a5,a3
    80001444:	0589b703          	ld	a4,88(s3)
    80001448:	12068693          	addi	a3,a3,288
    8000144c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001450:	6788                	ld	a0,8(a5)
    80001452:	6b8c                	ld	a1,16(a5)
    80001454:	6f90                	ld	a2,24(a5)
    80001456:	01073023          	sd	a6,0(a4)
    8000145a:	e708                	sd	a0,8(a4)
    8000145c:	eb0c                	sd	a1,16(a4)
    8000145e:	ef10                	sd	a2,24(a4)
    80001460:	02078793          	addi	a5,a5,32
    80001464:	02070713          	addi	a4,a4,32
    80001468:	fed792e3          	bne	a5,a3,8000144c <fork+0x54>
  np->trapframe->a0 = 0;
    8000146c:	0589b783          	ld	a5,88(s3)
    80001470:	0607b823          	sd	zero,112(a5)
    80001474:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001478:	15800a13          	li	s4,344
    8000147c:	a03d                	j	800014aa <fork+0xb2>
    freeproc(np);
    8000147e:	854e                	mv	a0,s3
    80001480:	00000097          	auipc	ra,0x0
    80001484:	d22080e7          	jalr	-734(ra) # 800011a2 <freeproc>
    release(&np->lock);
    80001488:	854e                	mv	a0,s3
    8000148a:	00005097          	auipc	ra,0x5
    8000148e:	f6c080e7          	jalr	-148(ra) # 800063f6 <release>
    return -1;
    80001492:	5a7d                	li	s4,-1
    80001494:	a069                	j	8000151e <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001496:	00002097          	auipc	ra,0x2
    8000149a:	6de080e7          	jalr	1758(ra) # 80003b74 <filedup>
    8000149e:	009987b3          	add	a5,s3,s1
    800014a2:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800014a4:	04a1                	addi	s1,s1,8
    800014a6:	01448763          	beq	s1,s4,800014b4 <fork+0xbc>
    if(p->ofile[i])
    800014aa:	009907b3          	add	a5,s2,s1
    800014ae:	6388                	ld	a0,0(a5)
    800014b0:	f17d                	bnez	a0,80001496 <fork+0x9e>
    800014b2:	bfcd                	j	800014a4 <fork+0xac>
  np->cwd = idup(p->cwd);
    800014b4:	15893503          	ld	a0,344(s2)
    800014b8:	00002097          	auipc	ra,0x2
    800014bc:	832080e7          	jalr	-1998(ra) # 80002cea <idup>
    800014c0:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014c4:	4641                	li	a2,16
    800014c6:	16090593          	addi	a1,s2,352
    800014ca:	16098513          	addi	a0,s3,352
    800014ce:	fffff097          	auipc	ra,0xfffff
    800014d2:	dfc080e7          	jalr	-516(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800014d6:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800014da:	854e                	mv	a0,s3
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	f1a080e7          	jalr	-230(ra) # 800063f6 <release>
  acquire(&wait_lock);
    800014e4:	00008497          	auipc	s1,0x8
    800014e8:	b8448493          	addi	s1,s1,-1148 # 80009068 <wait_lock>
    800014ec:	8526                	mv	a0,s1
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	e54080e7          	jalr	-428(ra) # 80006342 <acquire>
  np->parent = p;
    800014f6:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800014fa:	8526                	mv	a0,s1
    800014fc:	00005097          	auipc	ra,0x5
    80001500:	efa080e7          	jalr	-262(ra) # 800063f6 <release>
  acquire(&np->lock);
    80001504:	854e                	mv	a0,s3
    80001506:	00005097          	auipc	ra,0x5
    8000150a:	e3c080e7          	jalr	-452(ra) # 80006342 <acquire>
  np->state = RUNNABLE;
    8000150e:	478d                	li	a5,3
    80001510:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001514:	854e                	mv	a0,s3
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	ee0080e7          	jalr	-288(ra) # 800063f6 <release>
}
    8000151e:	8552                	mv	a0,s4
    80001520:	70a2                	ld	ra,40(sp)
    80001522:	7402                	ld	s0,32(sp)
    80001524:	64e2                	ld	s1,24(sp)
    80001526:	6942                	ld	s2,16(sp)
    80001528:	69a2                	ld	s3,8(sp)
    8000152a:	6a02                	ld	s4,0(sp)
    8000152c:	6145                	addi	sp,sp,48
    8000152e:	8082                	ret
    return -1;
    80001530:	5a7d                	li	s4,-1
    80001532:	b7f5                	j	8000151e <fork+0x126>

0000000080001534 <scheduler>:
{
    80001534:	7139                	addi	sp,sp,-64
    80001536:	fc06                	sd	ra,56(sp)
    80001538:	f822                	sd	s0,48(sp)
    8000153a:	f426                	sd	s1,40(sp)
    8000153c:	f04a                	sd	s2,32(sp)
    8000153e:	ec4e                	sd	s3,24(sp)
    80001540:	e852                	sd	s4,16(sp)
    80001542:	e456                	sd	s5,8(sp)
    80001544:	e05a                	sd	s6,0(sp)
    80001546:	0080                	addi	s0,sp,64
    80001548:	8792                	mv	a5,tp
  int id = r_tp();
    8000154a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000154c:	00779a93          	slli	s5,a5,0x7
    80001550:	00008717          	auipc	a4,0x8
    80001554:	b0070713          	addi	a4,a4,-1280 # 80009050 <pid_lock>
    80001558:	9756                	add	a4,a4,s5
    8000155a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000155e:	00008717          	auipc	a4,0x8
    80001562:	b2a70713          	addi	a4,a4,-1238 # 80009088 <cpus+0x8>
    80001566:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001568:	498d                	li	s3,3
        p->state = RUNNING;
    8000156a:	4b11                	li	s6,4
        c->proc = p;
    8000156c:	079e                	slli	a5,a5,0x7
    8000156e:	00008a17          	auipc	s4,0x8
    80001572:	ae2a0a13          	addi	s4,s4,-1310 # 80009050 <pid_lock>
    80001576:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001578:	0000e917          	auipc	s2,0xe
    8000157c:	b0890913          	addi	s2,s2,-1272 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001580:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001584:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001588:	10079073          	csrw	sstatus,a5
    8000158c:	00008497          	auipc	s1,0x8
    80001590:	ef448493          	addi	s1,s1,-268 # 80009480 <proc>
    80001594:	a03d                	j	800015c2 <scheduler+0x8e>
        p->state = RUNNING;
    80001596:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000159a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000159e:	06848593          	addi	a1,s1,104
    800015a2:	8556                	mv	a0,s5
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	640080e7          	jalr	1600(ra) # 80001be4 <swtch>
        c->proc = 0;
    800015ac:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800015b0:	8526                	mv	a0,s1
    800015b2:	00005097          	auipc	ra,0x5
    800015b6:	e44080e7          	jalr	-444(ra) # 800063f6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015ba:	17048493          	addi	s1,s1,368
    800015be:	fd2481e3          	beq	s1,s2,80001580 <scheduler+0x4c>
      acquire(&p->lock);
    800015c2:	8526                	mv	a0,s1
    800015c4:	00005097          	auipc	ra,0x5
    800015c8:	d7e080e7          	jalr	-642(ra) # 80006342 <acquire>
      if(p->state == RUNNABLE) {
    800015cc:	4c9c                	lw	a5,24(s1)
    800015ce:	ff3791e3          	bne	a5,s3,800015b0 <scheduler+0x7c>
    800015d2:	b7d1                	j	80001596 <scheduler+0x62>

00000000800015d4 <sched>:
{
    800015d4:	7179                	addi	sp,sp,-48
    800015d6:	f406                	sd	ra,40(sp)
    800015d8:	f022                	sd	s0,32(sp)
    800015da:	ec26                	sd	s1,24(sp)
    800015dc:	e84a                	sd	s2,16(sp)
    800015de:	e44e                	sd	s3,8(sp)
    800015e0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015e2:	00000097          	auipc	ra,0x0
    800015e6:	99a080e7          	jalr	-1638(ra) # 80000f7c <myproc>
    800015ea:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015ec:	00005097          	auipc	ra,0x5
    800015f0:	cdc080e7          	jalr	-804(ra) # 800062c8 <holding>
    800015f4:	c93d                	beqz	a0,8000166a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015f6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015f8:	2781                	sext.w	a5,a5
    800015fa:	079e                	slli	a5,a5,0x7
    800015fc:	00008717          	auipc	a4,0x8
    80001600:	a5470713          	addi	a4,a4,-1452 # 80009050 <pid_lock>
    80001604:	97ba                	add	a5,a5,a4
    80001606:	0a87a703          	lw	a4,168(a5)
    8000160a:	4785                	li	a5,1
    8000160c:	06f71763          	bne	a4,a5,8000167a <sched+0xa6>
  if(p->state == RUNNING)
    80001610:	4c98                	lw	a4,24(s1)
    80001612:	4791                	li	a5,4
    80001614:	06f70b63          	beq	a4,a5,8000168a <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001618:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000161c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000161e:	efb5                	bnez	a5,8000169a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001620:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001622:	00008917          	auipc	s2,0x8
    80001626:	a2e90913          	addi	s2,s2,-1490 # 80009050 <pid_lock>
    8000162a:	2781                	sext.w	a5,a5
    8000162c:	079e                	slli	a5,a5,0x7
    8000162e:	97ca                	add	a5,a5,s2
    80001630:	0ac7a983          	lw	s3,172(a5)
    80001634:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001636:	2781                	sext.w	a5,a5
    80001638:	079e                	slli	a5,a5,0x7
    8000163a:	00008597          	auipc	a1,0x8
    8000163e:	a4e58593          	addi	a1,a1,-1458 # 80009088 <cpus+0x8>
    80001642:	95be                	add	a1,a1,a5
    80001644:	06848513          	addi	a0,s1,104
    80001648:	00000097          	auipc	ra,0x0
    8000164c:	59c080e7          	jalr	1436(ra) # 80001be4 <swtch>
    80001650:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001652:	2781                	sext.w	a5,a5
    80001654:	079e                	slli	a5,a5,0x7
    80001656:	97ca                	add	a5,a5,s2
    80001658:	0b37a623          	sw	s3,172(a5)
}
    8000165c:	70a2                	ld	ra,40(sp)
    8000165e:	7402                	ld	s0,32(sp)
    80001660:	64e2                	ld	s1,24(sp)
    80001662:	6942                	ld	s2,16(sp)
    80001664:	69a2                	ld	s3,8(sp)
    80001666:	6145                	addi	sp,sp,48
    80001668:	8082                	ret
    panic("sched p->lock");
    8000166a:	00007517          	auipc	a0,0x7
    8000166e:	b6650513          	addi	a0,a0,-1178 # 800081d0 <etext+0x1d0>
    80001672:	00004097          	auipc	ra,0x4
    80001676:	786080e7          	jalr	1926(ra) # 80005df8 <panic>
    panic("sched locks");
    8000167a:	00007517          	auipc	a0,0x7
    8000167e:	b6650513          	addi	a0,a0,-1178 # 800081e0 <etext+0x1e0>
    80001682:	00004097          	auipc	ra,0x4
    80001686:	776080e7          	jalr	1910(ra) # 80005df8 <panic>
    panic("sched running");
    8000168a:	00007517          	auipc	a0,0x7
    8000168e:	b6650513          	addi	a0,a0,-1178 # 800081f0 <etext+0x1f0>
    80001692:	00004097          	auipc	ra,0x4
    80001696:	766080e7          	jalr	1894(ra) # 80005df8 <panic>
    panic("sched interruptible");
    8000169a:	00007517          	auipc	a0,0x7
    8000169e:	b6650513          	addi	a0,a0,-1178 # 80008200 <etext+0x200>
    800016a2:	00004097          	auipc	ra,0x4
    800016a6:	756080e7          	jalr	1878(ra) # 80005df8 <panic>

00000000800016aa <yield>:
{
    800016aa:	1101                	addi	sp,sp,-32
    800016ac:	ec06                	sd	ra,24(sp)
    800016ae:	e822                	sd	s0,16(sp)
    800016b0:	e426                	sd	s1,8(sp)
    800016b2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	8c8080e7          	jalr	-1848(ra) # 80000f7c <myproc>
    800016bc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016be:	00005097          	auipc	ra,0x5
    800016c2:	c84080e7          	jalr	-892(ra) # 80006342 <acquire>
  p->state = RUNNABLE;
    800016c6:	478d                	li	a5,3
    800016c8:	cc9c                	sw	a5,24(s1)
  sched();
    800016ca:	00000097          	auipc	ra,0x0
    800016ce:	f0a080e7          	jalr	-246(ra) # 800015d4 <sched>
  release(&p->lock);
    800016d2:	8526                	mv	a0,s1
    800016d4:	00005097          	auipc	ra,0x5
    800016d8:	d22080e7          	jalr	-734(ra) # 800063f6 <release>
}
    800016dc:	60e2                	ld	ra,24(sp)
    800016de:	6442                	ld	s0,16(sp)
    800016e0:	64a2                	ld	s1,8(sp)
    800016e2:	6105                	addi	sp,sp,32
    800016e4:	8082                	ret

00000000800016e6 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016e6:	7179                	addi	sp,sp,-48
    800016e8:	f406                	sd	ra,40(sp)
    800016ea:	f022                	sd	s0,32(sp)
    800016ec:	ec26                	sd	s1,24(sp)
    800016ee:	e84a                	sd	s2,16(sp)
    800016f0:	e44e                	sd	s3,8(sp)
    800016f2:	1800                	addi	s0,sp,48
    800016f4:	89aa                	mv	s3,a0
    800016f6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	884080e7          	jalr	-1916(ra) # 80000f7c <myproc>
    80001700:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001702:	00005097          	auipc	ra,0x5
    80001706:	c40080e7          	jalr	-960(ra) # 80006342 <acquire>
  release(lk);
    8000170a:	854a                	mv	a0,s2
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	cea080e7          	jalr	-790(ra) # 800063f6 <release>

  // Go to sleep.
  p->chan = chan;
    80001714:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001718:	4789                	li	a5,2
    8000171a:	cc9c                	sw	a5,24(s1)

  sched();
    8000171c:	00000097          	auipc	ra,0x0
    80001720:	eb8080e7          	jalr	-328(ra) # 800015d4 <sched>

  // Tidy up.
  p->chan = 0;
    80001724:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001728:	8526                	mv	a0,s1
    8000172a:	00005097          	auipc	ra,0x5
    8000172e:	ccc080e7          	jalr	-820(ra) # 800063f6 <release>
  acquire(lk);
    80001732:	854a                	mv	a0,s2
    80001734:	00005097          	auipc	ra,0x5
    80001738:	c0e080e7          	jalr	-1010(ra) # 80006342 <acquire>
}
    8000173c:	70a2                	ld	ra,40(sp)
    8000173e:	7402                	ld	s0,32(sp)
    80001740:	64e2                	ld	s1,24(sp)
    80001742:	6942                	ld	s2,16(sp)
    80001744:	69a2                	ld	s3,8(sp)
    80001746:	6145                	addi	sp,sp,48
    80001748:	8082                	ret

000000008000174a <wait>:
{
    8000174a:	715d                	addi	sp,sp,-80
    8000174c:	e486                	sd	ra,72(sp)
    8000174e:	e0a2                	sd	s0,64(sp)
    80001750:	fc26                	sd	s1,56(sp)
    80001752:	f84a                	sd	s2,48(sp)
    80001754:	f44e                	sd	s3,40(sp)
    80001756:	f052                	sd	s4,32(sp)
    80001758:	ec56                	sd	s5,24(sp)
    8000175a:	e85a                	sd	s6,16(sp)
    8000175c:	e45e                	sd	s7,8(sp)
    8000175e:	e062                	sd	s8,0(sp)
    80001760:	0880                	addi	s0,sp,80
    80001762:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001764:	00000097          	auipc	ra,0x0
    80001768:	818080e7          	jalr	-2024(ra) # 80000f7c <myproc>
    8000176c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000176e:	00008517          	auipc	a0,0x8
    80001772:	8fa50513          	addi	a0,a0,-1798 # 80009068 <wait_lock>
    80001776:	00005097          	auipc	ra,0x5
    8000177a:	bcc080e7          	jalr	-1076(ra) # 80006342 <acquire>
    havekids = 0;
    8000177e:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001780:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80001782:	0000e997          	auipc	s3,0xe
    80001786:	8fe98993          	addi	s3,s3,-1794 # 8000f080 <tickslock>
        havekids = 1;
    8000178a:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000178c:	00008c17          	auipc	s8,0x8
    80001790:	8dcc0c13          	addi	s8,s8,-1828 # 80009068 <wait_lock>
    havekids = 0;
    80001794:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001796:	00008497          	auipc	s1,0x8
    8000179a:	cea48493          	addi	s1,s1,-790 # 80009480 <proc>
    8000179e:	a0bd                	j	8000180c <wait+0xc2>
          pid = np->pid;
    800017a0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800017a4:	000b0e63          	beqz	s6,800017c0 <wait+0x76>
    800017a8:	4691                	li	a3,4
    800017aa:	02c48613          	addi	a2,s1,44
    800017ae:	85da                	mv	a1,s6
    800017b0:	05093503          	ld	a0,80(s2)
    800017b4:	fffff097          	auipc	ra,0xfffff
    800017b8:	356080e7          	jalr	854(ra) # 80000b0a <copyout>
    800017bc:	02054563          	bltz	a0,800017e6 <wait+0x9c>
          freeproc(np);
    800017c0:	8526                	mv	a0,s1
    800017c2:	00000097          	auipc	ra,0x0
    800017c6:	9e0080e7          	jalr	-1568(ra) # 800011a2 <freeproc>
          release(&np->lock);
    800017ca:	8526                	mv	a0,s1
    800017cc:	00005097          	auipc	ra,0x5
    800017d0:	c2a080e7          	jalr	-982(ra) # 800063f6 <release>
          release(&wait_lock);
    800017d4:	00008517          	auipc	a0,0x8
    800017d8:	89450513          	addi	a0,a0,-1900 # 80009068 <wait_lock>
    800017dc:	00005097          	auipc	ra,0x5
    800017e0:	c1a080e7          	jalr	-998(ra) # 800063f6 <release>
          return pid;
    800017e4:	a09d                	j	8000184a <wait+0x100>
            release(&np->lock);
    800017e6:	8526                	mv	a0,s1
    800017e8:	00005097          	auipc	ra,0x5
    800017ec:	c0e080e7          	jalr	-1010(ra) # 800063f6 <release>
            release(&wait_lock);
    800017f0:	00008517          	auipc	a0,0x8
    800017f4:	87850513          	addi	a0,a0,-1928 # 80009068 <wait_lock>
    800017f8:	00005097          	auipc	ra,0x5
    800017fc:	bfe080e7          	jalr	-1026(ra) # 800063f6 <release>
            return -1;
    80001800:	59fd                	li	s3,-1
    80001802:	a0a1                	j	8000184a <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001804:	17048493          	addi	s1,s1,368
    80001808:	03348463          	beq	s1,s3,80001830 <wait+0xe6>
      if(np->parent == p){
    8000180c:	7c9c                	ld	a5,56(s1)
    8000180e:	ff279be3          	bne	a5,s2,80001804 <wait+0xba>
        acquire(&np->lock);
    80001812:	8526                	mv	a0,s1
    80001814:	00005097          	auipc	ra,0x5
    80001818:	b2e080e7          	jalr	-1234(ra) # 80006342 <acquire>
        if(np->state == ZOMBIE){
    8000181c:	4c9c                	lw	a5,24(s1)
    8000181e:	f94781e3          	beq	a5,s4,800017a0 <wait+0x56>
        release(&np->lock);
    80001822:	8526                	mv	a0,s1
    80001824:	00005097          	auipc	ra,0x5
    80001828:	bd2080e7          	jalr	-1070(ra) # 800063f6 <release>
        havekids = 1;
    8000182c:	8756                	mv	a4,s5
    8000182e:	bfd9                	j	80001804 <wait+0xba>
    if(!havekids || p->killed){
    80001830:	c701                	beqz	a4,80001838 <wait+0xee>
    80001832:	02892783          	lw	a5,40(s2)
    80001836:	c79d                	beqz	a5,80001864 <wait+0x11a>
      release(&wait_lock);
    80001838:	00008517          	auipc	a0,0x8
    8000183c:	83050513          	addi	a0,a0,-2000 # 80009068 <wait_lock>
    80001840:	00005097          	auipc	ra,0x5
    80001844:	bb6080e7          	jalr	-1098(ra) # 800063f6 <release>
      return -1;
    80001848:	59fd                	li	s3,-1
}
    8000184a:	854e                	mv	a0,s3
    8000184c:	60a6                	ld	ra,72(sp)
    8000184e:	6406                	ld	s0,64(sp)
    80001850:	74e2                	ld	s1,56(sp)
    80001852:	7942                	ld	s2,48(sp)
    80001854:	79a2                	ld	s3,40(sp)
    80001856:	7a02                	ld	s4,32(sp)
    80001858:	6ae2                	ld	s5,24(sp)
    8000185a:	6b42                	ld	s6,16(sp)
    8000185c:	6ba2                	ld	s7,8(sp)
    8000185e:	6c02                	ld	s8,0(sp)
    80001860:	6161                	addi	sp,sp,80
    80001862:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001864:	85e2                	mv	a1,s8
    80001866:	854a                	mv	a0,s2
    80001868:	00000097          	auipc	ra,0x0
    8000186c:	e7e080e7          	jalr	-386(ra) # 800016e6 <sleep>
    havekids = 0;
    80001870:	b715                	j	80001794 <wait+0x4a>

0000000080001872 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001872:	7139                	addi	sp,sp,-64
    80001874:	fc06                	sd	ra,56(sp)
    80001876:	f822                	sd	s0,48(sp)
    80001878:	f426                	sd	s1,40(sp)
    8000187a:	f04a                	sd	s2,32(sp)
    8000187c:	ec4e                	sd	s3,24(sp)
    8000187e:	e852                	sd	s4,16(sp)
    80001880:	e456                	sd	s5,8(sp)
    80001882:	0080                	addi	s0,sp,64
    80001884:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001886:	00008497          	auipc	s1,0x8
    8000188a:	bfa48493          	addi	s1,s1,-1030 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000188e:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001890:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001892:	0000d917          	auipc	s2,0xd
    80001896:	7ee90913          	addi	s2,s2,2030 # 8000f080 <tickslock>
    8000189a:	a821                	j	800018b2 <wakeup+0x40>
        p->state = RUNNABLE;
    8000189c:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800018a0:	8526                	mv	a0,s1
    800018a2:	00005097          	auipc	ra,0x5
    800018a6:	b54080e7          	jalr	-1196(ra) # 800063f6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018aa:	17048493          	addi	s1,s1,368
    800018ae:	03248463          	beq	s1,s2,800018d6 <wakeup+0x64>
    if(p != myproc()){
    800018b2:	fffff097          	auipc	ra,0xfffff
    800018b6:	6ca080e7          	jalr	1738(ra) # 80000f7c <myproc>
    800018ba:	fea488e3          	beq	s1,a0,800018aa <wakeup+0x38>
      acquire(&p->lock);
    800018be:	8526                	mv	a0,s1
    800018c0:	00005097          	auipc	ra,0x5
    800018c4:	a82080e7          	jalr	-1406(ra) # 80006342 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018c8:	4c9c                	lw	a5,24(s1)
    800018ca:	fd379be3          	bne	a5,s3,800018a0 <wakeup+0x2e>
    800018ce:	709c                	ld	a5,32(s1)
    800018d0:	fd4798e3          	bne	a5,s4,800018a0 <wakeup+0x2e>
    800018d4:	b7e1                	j	8000189c <wakeup+0x2a>
    }
  }
}
    800018d6:	70e2                	ld	ra,56(sp)
    800018d8:	7442                	ld	s0,48(sp)
    800018da:	74a2                	ld	s1,40(sp)
    800018dc:	7902                	ld	s2,32(sp)
    800018de:	69e2                	ld	s3,24(sp)
    800018e0:	6a42                	ld	s4,16(sp)
    800018e2:	6aa2                	ld	s5,8(sp)
    800018e4:	6121                	addi	sp,sp,64
    800018e6:	8082                	ret

00000000800018e8 <reparent>:
{
    800018e8:	7179                	addi	sp,sp,-48
    800018ea:	f406                	sd	ra,40(sp)
    800018ec:	f022                	sd	s0,32(sp)
    800018ee:	ec26                	sd	s1,24(sp)
    800018f0:	e84a                	sd	s2,16(sp)
    800018f2:	e44e                	sd	s3,8(sp)
    800018f4:	e052                	sd	s4,0(sp)
    800018f6:	1800                	addi	s0,sp,48
    800018f8:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018fa:	00008497          	auipc	s1,0x8
    800018fe:	b8648493          	addi	s1,s1,-1146 # 80009480 <proc>
      pp->parent = initproc;
    80001902:	00007a17          	auipc	s4,0x7
    80001906:	70ea0a13          	addi	s4,s4,1806 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000190a:	0000d997          	auipc	s3,0xd
    8000190e:	77698993          	addi	s3,s3,1910 # 8000f080 <tickslock>
    80001912:	a029                	j	8000191c <reparent+0x34>
    80001914:	17048493          	addi	s1,s1,368
    80001918:	01348d63          	beq	s1,s3,80001932 <reparent+0x4a>
    if(pp->parent == p){
    8000191c:	7c9c                	ld	a5,56(s1)
    8000191e:	ff279be3          	bne	a5,s2,80001914 <reparent+0x2c>
      pp->parent = initproc;
    80001922:	000a3503          	ld	a0,0(s4)
    80001926:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001928:	00000097          	auipc	ra,0x0
    8000192c:	f4a080e7          	jalr	-182(ra) # 80001872 <wakeup>
    80001930:	b7d5                	j	80001914 <reparent+0x2c>
}
    80001932:	70a2                	ld	ra,40(sp)
    80001934:	7402                	ld	s0,32(sp)
    80001936:	64e2                	ld	s1,24(sp)
    80001938:	6942                	ld	s2,16(sp)
    8000193a:	69a2                	ld	s3,8(sp)
    8000193c:	6a02                	ld	s4,0(sp)
    8000193e:	6145                	addi	sp,sp,48
    80001940:	8082                	ret

0000000080001942 <exit>:
{
    80001942:	7179                	addi	sp,sp,-48
    80001944:	f406                	sd	ra,40(sp)
    80001946:	f022                	sd	s0,32(sp)
    80001948:	ec26                	sd	s1,24(sp)
    8000194a:	e84a                	sd	s2,16(sp)
    8000194c:	e44e                	sd	s3,8(sp)
    8000194e:	e052                	sd	s4,0(sp)
    80001950:	1800                	addi	s0,sp,48
    80001952:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	628080e7          	jalr	1576(ra) # 80000f7c <myproc>
    8000195c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000195e:	00007797          	auipc	a5,0x7
    80001962:	6b27b783          	ld	a5,1714(a5) # 80009010 <initproc>
    80001966:	0d850493          	addi	s1,a0,216
    8000196a:	15850913          	addi	s2,a0,344
    8000196e:	02a79363          	bne	a5,a0,80001994 <exit+0x52>
    panic("init exiting");
    80001972:	00007517          	auipc	a0,0x7
    80001976:	8a650513          	addi	a0,a0,-1882 # 80008218 <etext+0x218>
    8000197a:	00004097          	auipc	ra,0x4
    8000197e:	47e080e7          	jalr	1150(ra) # 80005df8 <panic>
      fileclose(f);
    80001982:	00002097          	auipc	ra,0x2
    80001986:	244080e7          	jalr	580(ra) # 80003bc6 <fileclose>
      p->ofile[fd] = 0;
    8000198a:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000198e:	04a1                	addi	s1,s1,8
    80001990:	01248563          	beq	s1,s2,8000199a <exit+0x58>
    if(p->ofile[fd]){
    80001994:	6088                	ld	a0,0(s1)
    80001996:	f575                	bnez	a0,80001982 <exit+0x40>
    80001998:	bfdd                	j	8000198e <exit+0x4c>
  begin_op();
    8000199a:	00002097          	auipc	ra,0x2
    8000199e:	d60080e7          	jalr	-672(ra) # 800036fa <begin_op>
  iput(p->cwd);
    800019a2:	1589b503          	ld	a0,344(s3)
    800019a6:	00001097          	auipc	ra,0x1
    800019aa:	53c080e7          	jalr	1340(ra) # 80002ee2 <iput>
  end_op();
    800019ae:	00002097          	auipc	ra,0x2
    800019b2:	dcc080e7          	jalr	-564(ra) # 8000377a <end_op>
  p->cwd = 0;
    800019b6:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800019ba:	00007497          	auipc	s1,0x7
    800019be:	6ae48493          	addi	s1,s1,1710 # 80009068 <wait_lock>
    800019c2:	8526                	mv	a0,s1
    800019c4:	00005097          	auipc	ra,0x5
    800019c8:	97e080e7          	jalr	-1666(ra) # 80006342 <acquire>
  reparent(p);
    800019cc:	854e                	mv	a0,s3
    800019ce:	00000097          	auipc	ra,0x0
    800019d2:	f1a080e7          	jalr	-230(ra) # 800018e8 <reparent>
  wakeup(p->parent);
    800019d6:	0389b503          	ld	a0,56(s3)
    800019da:	00000097          	auipc	ra,0x0
    800019de:	e98080e7          	jalr	-360(ra) # 80001872 <wakeup>
  acquire(&p->lock);
    800019e2:	854e                	mv	a0,s3
    800019e4:	00005097          	auipc	ra,0x5
    800019e8:	95e080e7          	jalr	-1698(ra) # 80006342 <acquire>
  p->xstate = status;
    800019ec:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019f0:	4795                	li	a5,5
    800019f2:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019f6:	8526                	mv	a0,s1
    800019f8:	00005097          	auipc	ra,0x5
    800019fc:	9fe080e7          	jalr	-1538(ra) # 800063f6 <release>
  sched();
    80001a00:	00000097          	auipc	ra,0x0
    80001a04:	bd4080e7          	jalr	-1068(ra) # 800015d4 <sched>
  panic("zombie exit");
    80001a08:	00007517          	auipc	a0,0x7
    80001a0c:	82050513          	addi	a0,a0,-2016 # 80008228 <etext+0x228>
    80001a10:	00004097          	auipc	ra,0x4
    80001a14:	3e8080e7          	jalr	1000(ra) # 80005df8 <panic>

0000000080001a18 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a18:	7179                	addi	sp,sp,-48
    80001a1a:	f406                	sd	ra,40(sp)
    80001a1c:	f022                	sd	s0,32(sp)
    80001a1e:	ec26                	sd	s1,24(sp)
    80001a20:	e84a                	sd	s2,16(sp)
    80001a22:	e44e                	sd	s3,8(sp)
    80001a24:	1800                	addi	s0,sp,48
    80001a26:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a28:	00008497          	auipc	s1,0x8
    80001a2c:	a5848493          	addi	s1,s1,-1448 # 80009480 <proc>
    80001a30:	0000d997          	auipc	s3,0xd
    80001a34:	65098993          	addi	s3,s3,1616 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001a38:	8526                	mv	a0,s1
    80001a3a:	00005097          	auipc	ra,0x5
    80001a3e:	908080e7          	jalr	-1784(ra) # 80006342 <acquire>
    if(p->pid == pid){
    80001a42:	589c                	lw	a5,48(s1)
    80001a44:	01278d63          	beq	a5,s2,80001a5e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a48:	8526                	mv	a0,s1
    80001a4a:	00005097          	auipc	ra,0x5
    80001a4e:	9ac080e7          	jalr	-1620(ra) # 800063f6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a52:	17048493          	addi	s1,s1,368
    80001a56:	ff3491e3          	bne	s1,s3,80001a38 <kill+0x20>
  }
  return -1;
    80001a5a:	557d                	li	a0,-1
    80001a5c:	a829                	j	80001a76 <kill+0x5e>
      p->killed = 1;
    80001a5e:	4785                	li	a5,1
    80001a60:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a62:	4c98                	lw	a4,24(s1)
    80001a64:	4789                	li	a5,2
    80001a66:	00f70f63          	beq	a4,a5,80001a84 <kill+0x6c>
      release(&p->lock);
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	00005097          	auipc	ra,0x5
    80001a70:	98a080e7          	jalr	-1654(ra) # 800063f6 <release>
      return 0;
    80001a74:	4501                	li	a0,0
}
    80001a76:	70a2                	ld	ra,40(sp)
    80001a78:	7402                	ld	s0,32(sp)
    80001a7a:	64e2                	ld	s1,24(sp)
    80001a7c:	6942                	ld	s2,16(sp)
    80001a7e:	69a2                	ld	s3,8(sp)
    80001a80:	6145                	addi	sp,sp,48
    80001a82:	8082                	ret
        p->state = RUNNABLE;
    80001a84:	478d                	li	a5,3
    80001a86:	cc9c                	sw	a5,24(s1)
    80001a88:	b7cd                	j	80001a6a <kill+0x52>

0000000080001a8a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a8a:	7179                	addi	sp,sp,-48
    80001a8c:	f406                	sd	ra,40(sp)
    80001a8e:	f022                	sd	s0,32(sp)
    80001a90:	ec26                	sd	s1,24(sp)
    80001a92:	e84a                	sd	s2,16(sp)
    80001a94:	e44e                	sd	s3,8(sp)
    80001a96:	e052                	sd	s4,0(sp)
    80001a98:	1800                	addi	s0,sp,48
    80001a9a:	84aa                	mv	s1,a0
    80001a9c:	892e                	mv	s2,a1
    80001a9e:	89b2                	mv	s3,a2
    80001aa0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001aa2:	fffff097          	auipc	ra,0xfffff
    80001aa6:	4da080e7          	jalr	1242(ra) # 80000f7c <myproc>
  if(user_dst){
    80001aaa:	c08d                	beqz	s1,80001acc <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001aac:	86d2                	mv	a3,s4
    80001aae:	864e                	mv	a2,s3
    80001ab0:	85ca                	mv	a1,s2
    80001ab2:	6928                	ld	a0,80(a0)
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	056080e7          	jalr	86(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001abc:	70a2                	ld	ra,40(sp)
    80001abe:	7402                	ld	s0,32(sp)
    80001ac0:	64e2                	ld	s1,24(sp)
    80001ac2:	6942                	ld	s2,16(sp)
    80001ac4:	69a2                	ld	s3,8(sp)
    80001ac6:	6a02                	ld	s4,0(sp)
    80001ac8:	6145                	addi	sp,sp,48
    80001aca:	8082                	ret
    memmove((char *)dst, src, len);
    80001acc:	000a061b          	sext.w	a2,s4
    80001ad0:	85ce                	mv	a1,s3
    80001ad2:	854a                	mv	a0,s2
    80001ad4:	ffffe097          	auipc	ra,0xffffe
    80001ad8:	704080e7          	jalr	1796(ra) # 800001d8 <memmove>
    return 0;
    80001adc:	8526                	mv	a0,s1
    80001ade:	bff9                	j	80001abc <either_copyout+0x32>

0000000080001ae0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ae0:	7179                	addi	sp,sp,-48
    80001ae2:	f406                	sd	ra,40(sp)
    80001ae4:	f022                	sd	s0,32(sp)
    80001ae6:	ec26                	sd	s1,24(sp)
    80001ae8:	e84a                	sd	s2,16(sp)
    80001aea:	e44e                	sd	s3,8(sp)
    80001aec:	e052                	sd	s4,0(sp)
    80001aee:	1800                	addi	s0,sp,48
    80001af0:	892a                	mv	s2,a0
    80001af2:	84ae                	mv	s1,a1
    80001af4:	89b2                	mv	s3,a2
    80001af6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001af8:	fffff097          	auipc	ra,0xfffff
    80001afc:	484080e7          	jalr	1156(ra) # 80000f7c <myproc>
  if(user_src){
    80001b00:	c08d                	beqz	s1,80001b22 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b02:	86d2                	mv	a3,s4
    80001b04:	864e                	mv	a2,s3
    80001b06:	85ca                	mv	a1,s2
    80001b08:	6928                	ld	a0,80(a0)
    80001b0a:	fffff097          	auipc	ra,0xfffff
    80001b0e:	08c080e7          	jalr	140(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b12:	70a2                	ld	ra,40(sp)
    80001b14:	7402                	ld	s0,32(sp)
    80001b16:	64e2                	ld	s1,24(sp)
    80001b18:	6942                	ld	s2,16(sp)
    80001b1a:	69a2                	ld	s3,8(sp)
    80001b1c:	6a02                	ld	s4,0(sp)
    80001b1e:	6145                	addi	sp,sp,48
    80001b20:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b22:	000a061b          	sext.w	a2,s4
    80001b26:	85ce                	mv	a1,s3
    80001b28:	854a                	mv	a0,s2
    80001b2a:	ffffe097          	auipc	ra,0xffffe
    80001b2e:	6ae080e7          	jalr	1710(ra) # 800001d8 <memmove>
    return 0;
    80001b32:	8526                	mv	a0,s1
    80001b34:	bff9                	j	80001b12 <either_copyin+0x32>

0000000080001b36 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b36:	715d                	addi	sp,sp,-80
    80001b38:	e486                	sd	ra,72(sp)
    80001b3a:	e0a2                	sd	s0,64(sp)
    80001b3c:	fc26                	sd	s1,56(sp)
    80001b3e:	f84a                	sd	s2,48(sp)
    80001b40:	f44e                	sd	s3,40(sp)
    80001b42:	f052                	sd	s4,32(sp)
    80001b44:	ec56                	sd	s5,24(sp)
    80001b46:	e85a                	sd	s6,16(sp)
    80001b48:	e45e                	sd	s7,8(sp)
    80001b4a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b4c:	00006517          	auipc	a0,0x6
    80001b50:	4fc50513          	addi	a0,a0,1276 # 80008048 <etext+0x48>
    80001b54:	00004097          	auipc	ra,0x4
    80001b58:	2ee080e7          	jalr	750(ra) # 80005e42 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b5c:	00008497          	auipc	s1,0x8
    80001b60:	a8448493          	addi	s1,s1,-1404 # 800095e0 <proc+0x160>
    80001b64:	0000d917          	auipc	s2,0xd
    80001b68:	67c90913          	addi	s2,s2,1660 # 8000f1e0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b6c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b6e:	00006997          	auipc	s3,0x6
    80001b72:	6ca98993          	addi	s3,s3,1738 # 80008238 <etext+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    80001b76:	00006a97          	auipc	s5,0x6
    80001b7a:	6caa8a93          	addi	s5,s5,1738 # 80008240 <etext+0x240>
    printf("\n");
    80001b7e:	00006a17          	auipc	s4,0x6
    80001b82:	4caa0a13          	addi	s4,s4,1226 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b86:	00006b97          	auipc	s7,0x6
    80001b8a:	6f2b8b93          	addi	s7,s7,1778 # 80008278 <states.1718>
    80001b8e:	a00d                	j	80001bb0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b90:	ed06a583          	lw	a1,-304(a3)
    80001b94:	8556                	mv	a0,s5
    80001b96:	00004097          	auipc	ra,0x4
    80001b9a:	2ac080e7          	jalr	684(ra) # 80005e42 <printf>
    printf("\n");
    80001b9e:	8552                	mv	a0,s4
    80001ba0:	00004097          	auipc	ra,0x4
    80001ba4:	2a2080e7          	jalr	674(ra) # 80005e42 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ba8:	17048493          	addi	s1,s1,368
    80001bac:	03248163          	beq	s1,s2,80001bce <procdump+0x98>
    if(p->state == UNUSED)
    80001bb0:	86a6                	mv	a3,s1
    80001bb2:	eb84a783          	lw	a5,-328(s1)
    80001bb6:	dbed                	beqz	a5,80001ba8 <procdump+0x72>
      state = "???";
    80001bb8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bba:	fcfb6be3          	bltu	s6,a5,80001b90 <procdump+0x5a>
    80001bbe:	1782                	slli	a5,a5,0x20
    80001bc0:	9381                	srli	a5,a5,0x20
    80001bc2:	078e                	slli	a5,a5,0x3
    80001bc4:	97de                	add	a5,a5,s7
    80001bc6:	6390                	ld	a2,0(a5)
    80001bc8:	f661                	bnez	a2,80001b90 <procdump+0x5a>
      state = "???";
    80001bca:	864e                	mv	a2,s3
    80001bcc:	b7d1                	j	80001b90 <procdump+0x5a>
  }
}
    80001bce:	60a6                	ld	ra,72(sp)
    80001bd0:	6406                	ld	s0,64(sp)
    80001bd2:	74e2                	ld	s1,56(sp)
    80001bd4:	7942                	ld	s2,48(sp)
    80001bd6:	79a2                	ld	s3,40(sp)
    80001bd8:	7a02                	ld	s4,32(sp)
    80001bda:	6ae2                	ld	s5,24(sp)
    80001bdc:	6b42                	ld	s6,16(sp)
    80001bde:	6ba2                	ld	s7,8(sp)
    80001be0:	6161                	addi	sp,sp,80
    80001be2:	8082                	ret

0000000080001be4 <swtch>:
    80001be4:	00153023          	sd	ra,0(a0)
    80001be8:	00253423          	sd	sp,8(a0)
    80001bec:	e900                	sd	s0,16(a0)
    80001bee:	ed04                	sd	s1,24(a0)
    80001bf0:	03253023          	sd	s2,32(a0)
    80001bf4:	03353423          	sd	s3,40(a0)
    80001bf8:	03453823          	sd	s4,48(a0)
    80001bfc:	03553c23          	sd	s5,56(a0)
    80001c00:	05653023          	sd	s6,64(a0)
    80001c04:	05753423          	sd	s7,72(a0)
    80001c08:	05853823          	sd	s8,80(a0)
    80001c0c:	05953c23          	sd	s9,88(a0)
    80001c10:	07a53023          	sd	s10,96(a0)
    80001c14:	07b53423          	sd	s11,104(a0)
    80001c18:	0005b083          	ld	ra,0(a1)
    80001c1c:	0085b103          	ld	sp,8(a1)
    80001c20:	6980                	ld	s0,16(a1)
    80001c22:	6d84                	ld	s1,24(a1)
    80001c24:	0205b903          	ld	s2,32(a1)
    80001c28:	0285b983          	ld	s3,40(a1)
    80001c2c:	0305ba03          	ld	s4,48(a1)
    80001c30:	0385ba83          	ld	s5,56(a1)
    80001c34:	0405bb03          	ld	s6,64(a1)
    80001c38:	0485bb83          	ld	s7,72(a1)
    80001c3c:	0505bc03          	ld	s8,80(a1)
    80001c40:	0585bc83          	ld	s9,88(a1)
    80001c44:	0605bd03          	ld	s10,96(a1)
    80001c48:	0685bd83          	ld	s11,104(a1)
    80001c4c:	8082                	ret

0000000080001c4e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c4e:	1141                	addi	sp,sp,-16
    80001c50:	e406                	sd	ra,8(sp)
    80001c52:	e022                	sd	s0,0(sp)
    80001c54:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c56:	00006597          	auipc	a1,0x6
    80001c5a:	65258593          	addi	a1,a1,1618 # 800082a8 <states.1718+0x30>
    80001c5e:	0000d517          	auipc	a0,0xd
    80001c62:	42250513          	addi	a0,a0,1058 # 8000f080 <tickslock>
    80001c66:	00004097          	auipc	ra,0x4
    80001c6a:	64c080e7          	jalr	1612(ra) # 800062b2 <initlock>
}
    80001c6e:	60a2                	ld	ra,8(sp)
    80001c70:	6402                	ld	s0,0(sp)
    80001c72:	0141                	addi	sp,sp,16
    80001c74:	8082                	ret

0000000080001c76 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c76:	1141                	addi	sp,sp,-16
    80001c78:	e422                	sd	s0,8(sp)
    80001c7a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c7c:	00003797          	auipc	a5,0x3
    80001c80:	58478793          	addi	a5,a5,1412 # 80005200 <kernelvec>
    80001c84:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c88:	6422                	ld	s0,8(sp)
    80001c8a:	0141                	addi	sp,sp,16
    80001c8c:	8082                	ret

0000000080001c8e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c8e:	1141                	addi	sp,sp,-16
    80001c90:	e406                	sd	ra,8(sp)
    80001c92:	e022                	sd	s0,0(sp)
    80001c94:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c96:	fffff097          	auipc	ra,0xfffff
    80001c9a:	2e6080e7          	jalr	742(ra) # 80000f7c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c9e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ca2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ca4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ca8:	00005617          	auipc	a2,0x5
    80001cac:	35860613          	addi	a2,a2,856 # 80007000 <_trampoline>
    80001cb0:	00005697          	auipc	a3,0x5
    80001cb4:	35068693          	addi	a3,a3,848 # 80007000 <_trampoline>
    80001cb8:	8e91                	sub	a3,a3,a2
    80001cba:	040007b7          	lui	a5,0x4000
    80001cbe:	17fd                	addi	a5,a5,-1
    80001cc0:	07b2                	slli	a5,a5,0xc
    80001cc2:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cc4:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cc8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cca:	180026f3          	csrr	a3,satp
    80001cce:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cd0:	6d38                	ld	a4,88(a0)
    80001cd2:	6134                	ld	a3,64(a0)
    80001cd4:	6585                	lui	a1,0x1
    80001cd6:	96ae                	add	a3,a3,a1
    80001cd8:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cda:	6d38                	ld	a4,88(a0)
    80001cdc:	00000697          	auipc	a3,0x0
    80001ce0:	13868693          	addi	a3,a3,312 # 80001e14 <usertrap>
    80001ce4:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001ce6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ce8:	8692                	mv	a3,tp
    80001cea:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cec:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cf0:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cf4:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cf8:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cfc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cfe:	6f18                	ld	a4,24(a4)
    80001d00:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d04:	692c                	ld	a1,80(a0)
    80001d06:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d08:	00005717          	auipc	a4,0x5
    80001d0c:	38870713          	addi	a4,a4,904 # 80007090 <userret>
    80001d10:	8f11                	sub	a4,a4,a2
    80001d12:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d14:	577d                	li	a4,-1
    80001d16:	177e                	slli	a4,a4,0x3f
    80001d18:	8dd9                	or	a1,a1,a4
    80001d1a:	02000537          	lui	a0,0x2000
    80001d1e:	157d                	addi	a0,a0,-1
    80001d20:	0536                	slli	a0,a0,0xd
    80001d22:	9782                	jalr	a5
}
    80001d24:	60a2                	ld	ra,8(sp)
    80001d26:	6402                	ld	s0,0(sp)
    80001d28:	0141                	addi	sp,sp,16
    80001d2a:	8082                	ret

0000000080001d2c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d2c:	1101                	addi	sp,sp,-32
    80001d2e:	ec06                	sd	ra,24(sp)
    80001d30:	e822                	sd	s0,16(sp)
    80001d32:	e426                	sd	s1,8(sp)
    80001d34:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d36:	0000d497          	auipc	s1,0xd
    80001d3a:	34a48493          	addi	s1,s1,842 # 8000f080 <tickslock>
    80001d3e:	8526                	mv	a0,s1
    80001d40:	00004097          	auipc	ra,0x4
    80001d44:	602080e7          	jalr	1538(ra) # 80006342 <acquire>
  ticks++;
    80001d48:	00007517          	auipc	a0,0x7
    80001d4c:	2d050513          	addi	a0,a0,720 # 80009018 <ticks>
    80001d50:	411c                	lw	a5,0(a0)
    80001d52:	2785                	addiw	a5,a5,1
    80001d54:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	b1c080e7          	jalr	-1252(ra) # 80001872 <wakeup>
  release(&tickslock);
    80001d5e:	8526                	mv	a0,s1
    80001d60:	00004097          	auipc	ra,0x4
    80001d64:	696080e7          	jalr	1686(ra) # 800063f6 <release>
}
    80001d68:	60e2                	ld	ra,24(sp)
    80001d6a:	6442                	ld	s0,16(sp)
    80001d6c:	64a2                	ld	s1,8(sp)
    80001d6e:	6105                	addi	sp,sp,32
    80001d70:	8082                	ret

0000000080001d72 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d72:	1101                	addi	sp,sp,-32
    80001d74:	ec06                	sd	ra,24(sp)
    80001d76:	e822                	sd	s0,16(sp)
    80001d78:	e426                	sd	s1,8(sp)
    80001d7a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d80:	00074d63          	bltz	a4,80001d9a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d84:	57fd                	li	a5,-1
    80001d86:	17fe                	slli	a5,a5,0x3f
    80001d88:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d8a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d8c:	06f70363          	beq	a4,a5,80001df2 <devintr+0x80>
  }
}
    80001d90:	60e2                	ld	ra,24(sp)
    80001d92:	6442                	ld	s0,16(sp)
    80001d94:	64a2                	ld	s1,8(sp)
    80001d96:	6105                	addi	sp,sp,32
    80001d98:	8082                	ret
     (scause & 0xff) == 9){
    80001d9a:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d9e:	46a5                	li	a3,9
    80001da0:	fed792e3          	bne	a5,a3,80001d84 <devintr+0x12>
    int irq = plic_claim();
    80001da4:	00003097          	auipc	ra,0x3
    80001da8:	564080e7          	jalr	1380(ra) # 80005308 <plic_claim>
    80001dac:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dae:	47a9                	li	a5,10
    80001db0:	02f50763          	beq	a0,a5,80001dde <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001db4:	4785                	li	a5,1
    80001db6:	02f50963          	beq	a0,a5,80001de8 <devintr+0x76>
    return 1;
    80001dba:	4505                	li	a0,1
    } else if(irq){
    80001dbc:	d8f1                	beqz	s1,80001d90 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dbe:	85a6                	mv	a1,s1
    80001dc0:	00006517          	auipc	a0,0x6
    80001dc4:	4f050513          	addi	a0,a0,1264 # 800082b0 <states.1718+0x38>
    80001dc8:	00004097          	auipc	ra,0x4
    80001dcc:	07a080e7          	jalr	122(ra) # 80005e42 <printf>
      plic_complete(irq);
    80001dd0:	8526                	mv	a0,s1
    80001dd2:	00003097          	auipc	ra,0x3
    80001dd6:	55a080e7          	jalr	1370(ra) # 8000532c <plic_complete>
    return 1;
    80001dda:	4505                	li	a0,1
    80001ddc:	bf55                	j	80001d90 <devintr+0x1e>
      uartintr();
    80001dde:	00004097          	auipc	ra,0x4
    80001de2:	484080e7          	jalr	1156(ra) # 80006262 <uartintr>
    80001de6:	b7ed                	j	80001dd0 <devintr+0x5e>
      virtio_disk_intr();
    80001de8:	00004097          	auipc	ra,0x4
    80001dec:	a24080e7          	jalr	-1500(ra) # 8000580c <virtio_disk_intr>
    80001df0:	b7c5                	j	80001dd0 <devintr+0x5e>
    if(cpuid() == 0){
    80001df2:	fffff097          	auipc	ra,0xfffff
    80001df6:	15e080e7          	jalr	350(ra) # 80000f50 <cpuid>
    80001dfa:	c901                	beqz	a0,80001e0a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dfc:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e00:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e02:	14479073          	csrw	sip,a5
    return 2;
    80001e06:	4509                	li	a0,2
    80001e08:	b761                	j	80001d90 <devintr+0x1e>
      clockintr();
    80001e0a:	00000097          	auipc	ra,0x0
    80001e0e:	f22080e7          	jalr	-222(ra) # 80001d2c <clockintr>
    80001e12:	b7ed                	j	80001dfc <devintr+0x8a>

0000000080001e14 <usertrap>:
{
    80001e14:	1101                	addi	sp,sp,-32
    80001e16:	ec06                	sd	ra,24(sp)
    80001e18:	e822                	sd	s0,16(sp)
    80001e1a:	e426                	sd	s1,8(sp)
    80001e1c:	e04a                	sd	s2,0(sp)
    80001e1e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e20:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e24:	1007f793          	andi	a5,a5,256
    80001e28:	e3ad                	bnez	a5,80001e8a <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e2a:	00003797          	auipc	a5,0x3
    80001e2e:	3d678793          	addi	a5,a5,982 # 80005200 <kernelvec>
    80001e32:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e36:	fffff097          	auipc	ra,0xfffff
    80001e3a:	146080e7          	jalr	326(ra) # 80000f7c <myproc>
    80001e3e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e40:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e42:	14102773          	csrr	a4,sepc
    80001e46:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e48:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e4c:	47a1                	li	a5,8
    80001e4e:	04f71c63          	bne	a4,a5,80001ea6 <usertrap+0x92>
    if(p->killed)
    80001e52:	551c                	lw	a5,40(a0)
    80001e54:	e3b9                	bnez	a5,80001e9a <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e56:	6cb8                	ld	a4,88(s1)
    80001e58:	6f1c                	ld	a5,24(a4)
    80001e5a:	0791                	addi	a5,a5,4
    80001e5c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e62:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e66:	10079073          	csrw	sstatus,a5
    syscall();
    80001e6a:	00000097          	auipc	ra,0x0
    80001e6e:	2e0080e7          	jalr	736(ra) # 8000214a <syscall>
  if(p->killed)
    80001e72:	549c                	lw	a5,40(s1)
    80001e74:	ebc1                	bnez	a5,80001f04 <usertrap+0xf0>
  usertrapret();
    80001e76:	00000097          	auipc	ra,0x0
    80001e7a:	e18080e7          	jalr	-488(ra) # 80001c8e <usertrapret>
}
    80001e7e:	60e2                	ld	ra,24(sp)
    80001e80:	6442                	ld	s0,16(sp)
    80001e82:	64a2                	ld	s1,8(sp)
    80001e84:	6902                	ld	s2,0(sp)
    80001e86:	6105                	addi	sp,sp,32
    80001e88:	8082                	ret
    panic("usertrap: not from user mode");
    80001e8a:	00006517          	auipc	a0,0x6
    80001e8e:	44650513          	addi	a0,a0,1094 # 800082d0 <states.1718+0x58>
    80001e92:	00004097          	auipc	ra,0x4
    80001e96:	f66080e7          	jalr	-154(ra) # 80005df8 <panic>
      exit(-1);
    80001e9a:	557d                	li	a0,-1
    80001e9c:	00000097          	auipc	ra,0x0
    80001ea0:	aa6080e7          	jalr	-1370(ra) # 80001942 <exit>
    80001ea4:	bf4d                	j	80001e56 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001ea6:	00000097          	auipc	ra,0x0
    80001eaa:	ecc080e7          	jalr	-308(ra) # 80001d72 <devintr>
    80001eae:	892a                	mv	s2,a0
    80001eb0:	c501                	beqz	a0,80001eb8 <usertrap+0xa4>
  if(p->killed)
    80001eb2:	549c                	lw	a5,40(s1)
    80001eb4:	c3a1                	beqz	a5,80001ef4 <usertrap+0xe0>
    80001eb6:	a815                	j	80001eea <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eb8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ebc:	5890                	lw	a2,48(s1)
    80001ebe:	00006517          	auipc	a0,0x6
    80001ec2:	43250513          	addi	a0,a0,1074 # 800082f0 <states.1718+0x78>
    80001ec6:	00004097          	auipc	ra,0x4
    80001eca:	f7c080e7          	jalr	-132(ra) # 80005e42 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ece:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ed2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ed6:	00006517          	auipc	a0,0x6
    80001eda:	44a50513          	addi	a0,a0,1098 # 80008320 <states.1718+0xa8>
    80001ede:	00004097          	auipc	ra,0x4
    80001ee2:	f64080e7          	jalr	-156(ra) # 80005e42 <printf>
    p->killed = 1;
    80001ee6:	4785                	li	a5,1
    80001ee8:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001eea:	557d                	li	a0,-1
    80001eec:	00000097          	auipc	ra,0x0
    80001ef0:	a56080e7          	jalr	-1450(ra) # 80001942 <exit>
  if(which_dev == 2)
    80001ef4:	4789                	li	a5,2
    80001ef6:	f8f910e3          	bne	s2,a5,80001e76 <usertrap+0x62>
    yield();
    80001efa:	fffff097          	auipc	ra,0xfffff
    80001efe:	7b0080e7          	jalr	1968(ra) # 800016aa <yield>
    80001f02:	bf95                	j	80001e76 <usertrap+0x62>
  int which_dev = 0;
    80001f04:	4901                	li	s2,0
    80001f06:	b7d5                	j	80001eea <usertrap+0xd6>

0000000080001f08 <kerneltrap>:
{
    80001f08:	7179                	addi	sp,sp,-48
    80001f0a:	f406                	sd	ra,40(sp)
    80001f0c:	f022                	sd	s0,32(sp)
    80001f0e:	ec26                	sd	s1,24(sp)
    80001f10:	e84a                	sd	s2,16(sp)
    80001f12:	e44e                	sd	s3,8(sp)
    80001f14:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f16:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f1a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f1e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f22:	1004f793          	andi	a5,s1,256
    80001f26:	cb85                	beqz	a5,80001f56 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f28:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f2c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f2e:	ef85                	bnez	a5,80001f66 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f30:	00000097          	auipc	ra,0x0
    80001f34:	e42080e7          	jalr	-446(ra) # 80001d72 <devintr>
    80001f38:	cd1d                	beqz	a0,80001f76 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f3a:	4789                	li	a5,2
    80001f3c:	06f50a63          	beq	a0,a5,80001fb0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f40:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f44:	10049073          	csrw	sstatus,s1
}
    80001f48:	70a2                	ld	ra,40(sp)
    80001f4a:	7402                	ld	s0,32(sp)
    80001f4c:	64e2                	ld	s1,24(sp)
    80001f4e:	6942                	ld	s2,16(sp)
    80001f50:	69a2                	ld	s3,8(sp)
    80001f52:	6145                	addi	sp,sp,48
    80001f54:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f56:	00006517          	auipc	a0,0x6
    80001f5a:	3ea50513          	addi	a0,a0,1002 # 80008340 <states.1718+0xc8>
    80001f5e:	00004097          	auipc	ra,0x4
    80001f62:	e9a080e7          	jalr	-358(ra) # 80005df8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f66:	00006517          	auipc	a0,0x6
    80001f6a:	40250513          	addi	a0,a0,1026 # 80008368 <states.1718+0xf0>
    80001f6e:	00004097          	auipc	ra,0x4
    80001f72:	e8a080e7          	jalr	-374(ra) # 80005df8 <panic>
    printf("scause %p\n", scause);
    80001f76:	85ce                	mv	a1,s3
    80001f78:	00006517          	auipc	a0,0x6
    80001f7c:	41050513          	addi	a0,a0,1040 # 80008388 <states.1718+0x110>
    80001f80:	00004097          	auipc	ra,0x4
    80001f84:	ec2080e7          	jalr	-318(ra) # 80005e42 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f88:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f8c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f90:	00006517          	auipc	a0,0x6
    80001f94:	40850513          	addi	a0,a0,1032 # 80008398 <states.1718+0x120>
    80001f98:	00004097          	auipc	ra,0x4
    80001f9c:	eaa080e7          	jalr	-342(ra) # 80005e42 <printf>
    panic("kerneltrap");
    80001fa0:	00006517          	auipc	a0,0x6
    80001fa4:	41050513          	addi	a0,a0,1040 # 800083b0 <states.1718+0x138>
    80001fa8:	00004097          	auipc	ra,0x4
    80001fac:	e50080e7          	jalr	-432(ra) # 80005df8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fb0:	fffff097          	auipc	ra,0xfffff
    80001fb4:	fcc080e7          	jalr	-52(ra) # 80000f7c <myproc>
    80001fb8:	d541                	beqz	a0,80001f40 <kerneltrap+0x38>
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	fc2080e7          	jalr	-62(ra) # 80000f7c <myproc>
    80001fc2:	4d18                	lw	a4,24(a0)
    80001fc4:	4791                	li	a5,4
    80001fc6:	f6f71de3          	bne	a4,a5,80001f40 <kerneltrap+0x38>
    yield();
    80001fca:	fffff097          	auipc	ra,0xfffff
    80001fce:	6e0080e7          	jalr	1760(ra) # 800016aa <yield>
    80001fd2:	b7bd                	j	80001f40 <kerneltrap+0x38>

0000000080001fd4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fd4:	1101                	addi	sp,sp,-32
    80001fd6:	ec06                	sd	ra,24(sp)
    80001fd8:	e822                	sd	s0,16(sp)
    80001fda:	e426                	sd	s1,8(sp)
    80001fdc:	1000                	addi	s0,sp,32
    80001fde:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	f9c080e7          	jalr	-100(ra) # 80000f7c <myproc>
  switch (n) {
    80001fe8:	4795                	li	a5,5
    80001fea:	0497e163          	bltu	a5,s1,8000202c <argraw+0x58>
    80001fee:	048a                	slli	s1,s1,0x2
    80001ff0:	00006717          	auipc	a4,0x6
    80001ff4:	3f870713          	addi	a4,a4,1016 # 800083e8 <states.1718+0x170>
    80001ff8:	94ba                	add	s1,s1,a4
    80001ffa:	409c                	lw	a5,0(s1)
    80001ffc:	97ba                	add	a5,a5,a4
    80001ffe:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002000:	6d3c                	ld	a5,88(a0)
    80002002:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002004:	60e2                	ld	ra,24(sp)
    80002006:	6442                	ld	s0,16(sp)
    80002008:	64a2                	ld	s1,8(sp)
    8000200a:	6105                	addi	sp,sp,32
    8000200c:	8082                	ret
    return p->trapframe->a1;
    8000200e:	6d3c                	ld	a5,88(a0)
    80002010:	7fa8                	ld	a0,120(a5)
    80002012:	bfcd                	j	80002004 <argraw+0x30>
    return p->trapframe->a2;
    80002014:	6d3c                	ld	a5,88(a0)
    80002016:	63c8                	ld	a0,128(a5)
    80002018:	b7f5                	j	80002004 <argraw+0x30>
    return p->trapframe->a3;
    8000201a:	6d3c                	ld	a5,88(a0)
    8000201c:	67c8                	ld	a0,136(a5)
    8000201e:	b7dd                	j	80002004 <argraw+0x30>
    return p->trapframe->a4;
    80002020:	6d3c                	ld	a5,88(a0)
    80002022:	6bc8                	ld	a0,144(a5)
    80002024:	b7c5                	j	80002004 <argraw+0x30>
    return p->trapframe->a5;
    80002026:	6d3c                	ld	a5,88(a0)
    80002028:	6fc8                	ld	a0,152(a5)
    8000202a:	bfe9                	j	80002004 <argraw+0x30>
  panic("argraw");
    8000202c:	00006517          	auipc	a0,0x6
    80002030:	39450513          	addi	a0,a0,916 # 800083c0 <states.1718+0x148>
    80002034:	00004097          	auipc	ra,0x4
    80002038:	dc4080e7          	jalr	-572(ra) # 80005df8 <panic>

000000008000203c <fetchaddr>:
{
    8000203c:	1101                	addi	sp,sp,-32
    8000203e:	ec06                	sd	ra,24(sp)
    80002040:	e822                	sd	s0,16(sp)
    80002042:	e426                	sd	s1,8(sp)
    80002044:	e04a                	sd	s2,0(sp)
    80002046:	1000                	addi	s0,sp,32
    80002048:	84aa                	mv	s1,a0
    8000204a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	f30080e7          	jalr	-208(ra) # 80000f7c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002054:	653c                	ld	a5,72(a0)
    80002056:	02f4f863          	bgeu	s1,a5,80002086 <fetchaddr+0x4a>
    8000205a:	00848713          	addi	a4,s1,8
    8000205e:	02e7e663          	bltu	a5,a4,8000208a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002062:	46a1                	li	a3,8
    80002064:	8626                	mv	a2,s1
    80002066:	85ca                	mv	a1,s2
    80002068:	6928                	ld	a0,80(a0)
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	b2c080e7          	jalr	-1236(ra) # 80000b96 <copyin>
    80002072:	00a03533          	snez	a0,a0
    80002076:	40a00533          	neg	a0,a0
}
    8000207a:	60e2                	ld	ra,24(sp)
    8000207c:	6442                	ld	s0,16(sp)
    8000207e:	64a2                	ld	s1,8(sp)
    80002080:	6902                	ld	s2,0(sp)
    80002082:	6105                	addi	sp,sp,32
    80002084:	8082                	ret
    return -1;
    80002086:	557d                	li	a0,-1
    80002088:	bfcd                	j	8000207a <fetchaddr+0x3e>
    8000208a:	557d                	li	a0,-1
    8000208c:	b7fd                	j	8000207a <fetchaddr+0x3e>

000000008000208e <fetchstr>:
{
    8000208e:	7179                	addi	sp,sp,-48
    80002090:	f406                	sd	ra,40(sp)
    80002092:	f022                	sd	s0,32(sp)
    80002094:	ec26                	sd	s1,24(sp)
    80002096:	e84a                	sd	s2,16(sp)
    80002098:	e44e                	sd	s3,8(sp)
    8000209a:	1800                	addi	s0,sp,48
    8000209c:	892a                	mv	s2,a0
    8000209e:	84ae                	mv	s1,a1
    800020a0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020a2:	fffff097          	auipc	ra,0xfffff
    800020a6:	eda080e7          	jalr	-294(ra) # 80000f7c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800020aa:	86ce                	mv	a3,s3
    800020ac:	864a                	mv	a2,s2
    800020ae:	85a6                	mv	a1,s1
    800020b0:	6928                	ld	a0,80(a0)
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	b70080e7          	jalr	-1168(ra) # 80000c22 <copyinstr>
  if(err < 0)
    800020ba:	00054763          	bltz	a0,800020c8 <fetchstr+0x3a>
  return strlen(buf);
    800020be:	8526                	mv	a0,s1
    800020c0:	ffffe097          	auipc	ra,0xffffe
    800020c4:	23c080e7          	jalr	572(ra) # 800002fc <strlen>
}
    800020c8:	70a2                	ld	ra,40(sp)
    800020ca:	7402                	ld	s0,32(sp)
    800020cc:	64e2                	ld	s1,24(sp)
    800020ce:	6942                	ld	s2,16(sp)
    800020d0:	69a2                	ld	s3,8(sp)
    800020d2:	6145                	addi	sp,sp,48
    800020d4:	8082                	ret

00000000800020d6 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020d6:	1101                	addi	sp,sp,-32
    800020d8:	ec06                	sd	ra,24(sp)
    800020da:	e822                	sd	s0,16(sp)
    800020dc:	e426                	sd	s1,8(sp)
    800020de:	1000                	addi	s0,sp,32
    800020e0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	ef2080e7          	jalr	-270(ra) # 80001fd4 <argraw>
    800020ea:	c088                	sw	a0,0(s1)
  return 0;
}
    800020ec:	4501                	li	a0,0
    800020ee:	60e2                	ld	ra,24(sp)
    800020f0:	6442                	ld	s0,16(sp)
    800020f2:	64a2                	ld	s1,8(sp)
    800020f4:	6105                	addi	sp,sp,32
    800020f6:	8082                	ret

00000000800020f8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020f8:	1101                	addi	sp,sp,-32
    800020fa:	ec06                	sd	ra,24(sp)
    800020fc:	e822                	sd	s0,16(sp)
    800020fe:	e426                	sd	s1,8(sp)
    80002100:	1000                	addi	s0,sp,32
    80002102:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002104:	00000097          	auipc	ra,0x0
    80002108:	ed0080e7          	jalr	-304(ra) # 80001fd4 <argraw>
    8000210c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000210e:	4501                	li	a0,0
    80002110:	60e2                	ld	ra,24(sp)
    80002112:	6442                	ld	s0,16(sp)
    80002114:	64a2                	ld	s1,8(sp)
    80002116:	6105                	addi	sp,sp,32
    80002118:	8082                	ret

000000008000211a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000211a:	1101                	addi	sp,sp,-32
    8000211c:	ec06                	sd	ra,24(sp)
    8000211e:	e822                	sd	s0,16(sp)
    80002120:	e426                	sd	s1,8(sp)
    80002122:	e04a                	sd	s2,0(sp)
    80002124:	1000                	addi	s0,sp,32
    80002126:	84ae                	mv	s1,a1
    80002128:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000212a:	00000097          	auipc	ra,0x0
    8000212e:	eaa080e7          	jalr	-342(ra) # 80001fd4 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002132:	864a                	mv	a2,s2
    80002134:	85a6                	mv	a1,s1
    80002136:	00000097          	auipc	ra,0x0
    8000213a:	f58080e7          	jalr	-168(ra) # 8000208e <fetchstr>
}
    8000213e:	60e2                	ld	ra,24(sp)
    80002140:	6442                	ld	s0,16(sp)
    80002142:	64a2                	ld	s1,8(sp)
    80002144:	6902                	ld	s2,0(sp)
    80002146:	6105                	addi	sp,sp,32
    80002148:	8082                	ret

000000008000214a <syscall>:



void
syscall(void)
{
    8000214a:	1101                	addi	sp,sp,-32
    8000214c:	ec06                	sd	ra,24(sp)
    8000214e:	e822                	sd	s0,16(sp)
    80002150:	e426                	sd	s1,8(sp)
    80002152:	e04a                	sd	s2,0(sp)
    80002154:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	e26080e7          	jalr	-474(ra) # 80000f7c <myproc>
    8000215e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002160:	05853903          	ld	s2,88(a0)
    80002164:	0a893783          	ld	a5,168(s2)
    80002168:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000216c:	37fd                	addiw	a5,a5,-1
    8000216e:	4775                	li	a4,29
    80002170:	00f76f63          	bltu	a4,a5,8000218e <syscall+0x44>
    80002174:	00369713          	slli	a4,a3,0x3
    80002178:	00006797          	auipc	a5,0x6
    8000217c:	28878793          	addi	a5,a5,648 # 80008400 <syscalls>
    80002180:	97ba                	add	a5,a5,a4
    80002182:	639c                	ld	a5,0(a5)
    80002184:	c789                	beqz	a5,8000218e <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002186:	9782                	jalr	a5
    80002188:	06a93823          	sd	a0,112(s2)
    8000218c:	a839                	j	800021aa <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000218e:	16048613          	addi	a2,s1,352
    80002192:	588c                	lw	a1,48(s1)
    80002194:	00006517          	auipc	a0,0x6
    80002198:	23450513          	addi	a0,a0,564 # 800083c8 <states.1718+0x150>
    8000219c:	00004097          	auipc	ra,0x4
    800021a0:	ca6080e7          	jalr	-858(ra) # 80005e42 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021a4:	6cbc                	ld	a5,88(s1)
    800021a6:	577d                	li	a4,-1
    800021a8:	fbb8                	sd	a4,112(a5)
  }
}
    800021aa:	60e2                	ld	ra,24(sp)
    800021ac:	6442                	ld	s0,16(sp)
    800021ae:	64a2                	ld	s1,8(sp)
    800021b0:	6902                	ld	s2,0(sp)
    800021b2:	6105                	addi	sp,sp,32
    800021b4:	8082                	ret

00000000800021b6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021b6:	1101                	addi	sp,sp,-32
    800021b8:	ec06                	sd	ra,24(sp)
    800021ba:	e822                	sd	s0,16(sp)
    800021bc:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021be:	fec40593          	addi	a1,s0,-20
    800021c2:	4501                	li	a0,0
    800021c4:	00000097          	auipc	ra,0x0
    800021c8:	f12080e7          	jalr	-238(ra) # 800020d6 <argint>
    return -1;
    800021cc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021ce:	00054963          	bltz	a0,800021e0 <sys_exit+0x2a>
  exit(n);
    800021d2:	fec42503          	lw	a0,-20(s0)
    800021d6:	fffff097          	auipc	ra,0xfffff
    800021da:	76c080e7          	jalr	1900(ra) # 80001942 <exit>
  return 0;  // not reached
    800021de:	4781                	li	a5,0
}
    800021e0:	853e                	mv	a0,a5
    800021e2:	60e2                	ld	ra,24(sp)
    800021e4:	6442                	ld	s0,16(sp)
    800021e6:	6105                	addi	sp,sp,32
    800021e8:	8082                	ret

00000000800021ea <sys_getpid>:

uint64
sys_getpid(void)
{
    800021ea:	1141                	addi	sp,sp,-16
    800021ec:	e406                	sd	ra,8(sp)
    800021ee:	e022                	sd	s0,0(sp)
    800021f0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	d8a080e7          	jalr	-630(ra) # 80000f7c <myproc>
}
    800021fa:	5908                	lw	a0,48(a0)
    800021fc:	60a2                	ld	ra,8(sp)
    800021fe:	6402                	ld	s0,0(sp)
    80002200:	0141                	addi	sp,sp,16
    80002202:	8082                	ret

0000000080002204 <sys_fork>:

uint64
sys_fork(void)
{
    80002204:	1141                	addi	sp,sp,-16
    80002206:	e406                	sd	ra,8(sp)
    80002208:	e022                	sd	s0,0(sp)
    8000220a:	0800                	addi	s0,sp,16
  return fork();
    8000220c:	fffff097          	auipc	ra,0xfffff
    80002210:	1ec080e7          	jalr	492(ra) # 800013f8 <fork>
}
    80002214:	60a2                	ld	ra,8(sp)
    80002216:	6402                	ld	s0,0(sp)
    80002218:	0141                	addi	sp,sp,16
    8000221a:	8082                	ret

000000008000221c <sys_wait>:

uint64
sys_wait(void)
{
    8000221c:	1101                	addi	sp,sp,-32
    8000221e:	ec06                	sd	ra,24(sp)
    80002220:	e822                	sd	s0,16(sp)
    80002222:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002224:	fe840593          	addi	a1,s0,-24
    80002228:	4501                	li	a0,0
    8000222a:	00000097          	auipc	ra,0x0
    8000222e:	ece080e7          	jalr	-306(ra) # 800020f8 <argaddr>
    80002232:	87aa                	mv	a5,a0
    return -1;
    80002234:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002236:	0007c863          	bltz	a5,80002246 <sys_wait+0x2a>
  return wait(p);
    8000223a:	fe843503          	ld	a0,-24(s0)
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	50c080e7          	jalr	1292(ra) # 8000174a <wait>
}
    80002246:	60e2                	ld	ra,24(sp)
    80002248:	6442                	ld	s0,16(sp)
    8000224a:	6105                	addi	sp,sp,32
    8000224c:	8082                	ret

000000008000224e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000224e:	7179                	addi	sp,sp,-48
    80002250:	f406                	sd	ra,40(sp)
    80002252:	f022                	sd	s0,32(sp)
    80002254:	ec26                	sd	s1,24(sp)
    80002256:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002258:	fdc40593          	addi	a1,s0,-36
    8000225c:	4501                	li	a0,0
    8000225e:	00000097          	auipc	ra,0x0
    80002262:	e78080e7          	jalr	-392(ra) # 800020d6 <argint>
    80002266:	87aa                	mv	a5,a0
    return -1;
    80002268:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000226a:	0207c063          	bltz	a5,8000228a <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	d0e080e7          	jalr	-754(ra) # 80000f7c <myproc>
    80002276:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002278:	fdc42503          	lw	a0,-36(s0)
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	108080e7          	jalr	264(ra) # 80001384 <growproc>
    80002284:	00054863          	bltz	a0,80002294 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002288:	8526                	mv	a0,s1
}
    8000228a:	70a2                	ld	ra,40(sp)
    8000228c:	7402                	ld	s0,32(sp)
    8000228e:	64e2                	ld	s1,24(sp)
    80002290:	6145                	addi	sp,sp,48
    80002292:	8082                	ret
    return -1;
    80002294:	557d                	li	a0,-1
    80002296:	bfd5                	j	8000228a <sys_sbrk+0x3c>

0000000080002298 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002298:	7139                	addi	sp,sp,-64
    8000229a:	fc06                	sd	ra,56(sp)
    8000229c:	f822                	sd	s0,48(sp)
    8000229e:	f426                	sd	s1,40(sp)
    800022a0:	f04a                	sd	s2,32(sp)
    800022a2:	ec4e                	sd	s3,24(sp)
    800022a4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    800022a6:	fcc40593          	addi	a1,s0,-52
    800022aa:	4501                	li	a0,0
    800022ac:	00000097          	auipc	ra,0x0
    800022b0:	e2a080e7          	jalr	-470(ra) # 800020d6 <argint>
    return -1;
    800022b4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022b6:	06054563          	bltz	a0,80002320 <sys_sleep+0x88>
  acquire(&tickslock);
    800022ba:	0000d517          	auipc	a0,0xd
    800022be:	dc650513          	addi	a0,a0,-570 # 8000f080 <tickslock>
    800022c2:	00004097          	auipc	ra,0x4
    800022c6:	080080e7          	jalr	128(ra) # 80006342 <acquire>
  ticks0 = ticks;
    800022ca:	00007917          	auipc	s2,0x7
    800022ce:	d4e92903          	lw	s2,-690(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022d2:	fcc42783          	lw	a5,-52(s0)
    800022d6:	cf85                	beqz	a5,8000230e <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022d8:	0000d997          	auipc	s3,0xd
    800022dc:	da898993          	addi	s3,s3,-600 # 8000f080 <tickslock>
    800022e0:	00007497          	auipc	s1,0x7
    800022e4:	d3848493          	addi	s1,s1,-712 # 80009018 <ticks>
    if(myproc()->killed){
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	c94080e7          	jalr	-876(ra) # 80000f7c <myproc>
    800022f0:	551c                	lw	a5,40(a0)
    800022f2:	ef9d                	bnez	a5,80002330 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022f4:	85ce                	mv	a1,s3
    800022f6:	8526                	mv	a0,s1
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	3ee080e7          	jalr	1006(ra) # 800016e6 <sleep>
  while(ticks - ticks0 < n){
    80002300:	409c                	lw	a5,0(s1)
    80002302:	412787bb          	subw	a5,a5,s2
    80002306:	fcc42703          	lw	a4,-52(s0)
    8000230a:	fce7efe3          	bltu	a5,a4,800022e8 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000230e:	0000d517          	auipc	a0,0xd
    80002312:	d7250513          	addi	a0,a0,-654 # 8000f080 <tickslock>
    80002316:	00004097          	auipc	ra,0x4
    8000231a:	0e0080e7          	jalr	224(ra) # 800063f6 <release>
  return 0;
    8000231e:	4781                	li	a5,0
}
    80002320:	853e                	mv	a0,a5
    80002322:	70e2                	ld	ra,56(sp)
    80002324:	7442                	ld	s0,48(sp)
    80002326:	74a2                	ld	s1,40(sp)
    80002328:	7902                	ld	s2,32(sp)
    8000232a:	69e2                	ld	s3,24(sp)
    8000232c:	6121                	addi	sp,sp,64
    8000232e:	8082                	ret
      release(&tickslock);
    80002330:	0000d517          	auipc	a0,0xd
    80002334:	d5050513          	addi	a0,a0,-688 # 8000f080 <tickslock>
    80002338:	00004097          	auipc	ra,0x4
    8000233c:	0be080e7          	jalr	190(ra) # 800063f6 <release>
      return -1;
    80002340:	57fd                	li	a5,-1
    80002342:	bff9                	j	80002320 <sys_sleep+0x88>

0000000080002344 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002344:	715d                	addi	sp,sp,-80
    80002346:	e486                	sd	ra,72(sp)
    80002348:	e0a2                	sd	s0,64(sp)
    8000234a:	fc26                	sd	s1,56(sp)
    8000234c:	f84a                	sd	s2,48(sp)
    8000234e:	f44e                	sd	s3,40(sp)
    80002350:	f052                	sd	s4,32(sp)
    80002352:	0880                	addi	s0,sp,80
  // lab pgtbl: your code here.
  uint64 buf;
  if(argaddr(0, &buf) < 0)
    80002354:	fc840593          	addi	a1,s0,-56
    80002358:	4501                	li	a0,0
    8000235a:	00000097          	auipc	ra,0x0
    8000235e:	d9e080e7          	jalr	-610(ra) # 800020f8 <argaddr>
    80002362:	0a054b63          	bltz	a0,80002418 <sys_pgaccess+0xd4>
    return -1;
  int n;
  if(argint(1, &n) < 0)
    80002366:	fc440593          	addi	a1,s0,-60
    8000236a:	4505                	li	a0,1
    8000236c:	00000097          	auipc	ra,0x0
    80002370:	d6a080e7          	jalr	-662(ra) # 800020d6 <argint>
    80002374:	0a054463          	bltz	a0,8000241c <sys_pgaccess+0xd8>
    return -1;
  uint64 ret_addr;
  if(argaddr(2, &ret_addr) < 0)
    80002378:	fb840593          	addi	a1,s0,-72
    8000237c:	4509                	li	a0,2
    8000237e:	00000097          	auipc	ra,0x0
    80002382:	d7a080e7          	jalr	-646(ra) # 800020f8 <argaddr>
    80002386:	08054d63          	bltz	a0,80002420 <sys_pgaccess+0xdc>
    return -1;
  pagetable_t p = myproc()->pagetable;
    8000238a:	fffff097          	auipc	ra,0xfffff
    8000238e:	bf2080e7          	jalr	-1038(ra) # 80000f7c <myproc>
    80002392:	05053983          	ld	s3,80(a0)
  uint64 value = 0;
    80002396:	fa043823          	sd	zero,-80(s0)
  for(int i=0, step = 0; i<n; i++) {
    8000239a:	fc442783          	lw	a5,-60(s0)
    8000239e:	04f05a63          	blez	a5,800023f2 <sys_pgaccess+0xae>
    800023a2:	4481                	li	s1,0
    pte_t * pte = walk(p, buf + step, 0);
    if(*pte & PTE_A) {
      value |= (1L << i);
    800023a4:	4a05                	li	s4,1
    800023a6:	a801                	j	800023b6 <sys_pgaccess+0x72>
  for(int i=0, step = 0; i<n; i++) {
    800023a8:	0485                	addi	s1,s1,1
    800023aa:	fc442703          	lw	a4,-60(s0)
    800023ae:	0004879b          	sext.w	a5,s1
    800023b2:	04e7d063          	bge	a5,a4,800023f2 <sys_pgaccess+0xae>
    800023b6:	0004891b          	sext.w	s2,s1
    pte_t * pte = walk(p, buf + step, 0);
    800023ba:	00c49593          	slli	a1,s1,0xc
    800023be:	4601                	li	a2,0
    800023c0:	fc843783          	ld	a5,-56(s0)
    800023c4:	95be                	add	a1,a1,a5
    800023c6:	854e                	mv	a0,s3
    800023c8:	ffffe097          	auipc	ra,0xffffe
    800023cc:	098080e7          	jalr	152(ra) # 80000460 <walk>
    if(*pte & PTE_A) {
    800023d0:	611c                	ld	a5,0(a0)
    800023d2:	0407f793          	andi	a5,a5,64
    800023d6:	dbe9                	beqz	a5,800023a8 <sys_pgaccess+0x64>
      value |= (1L << i);
    800023d8:	012a1933          	sll	s2,s4,s2
    800023dc:	fb043783          	ld	a5,-80(s0)
    800023e0:	0127e933          	or	s2,a5,s2
    800023e4:	fb243823          	sd	s2,-80(s0)
      *pte = ~(PTE_A) & *pte;
    800023e8:	611c                	ld	a5,0(a0)
    800023ea:	fbf7f793          	andi	a5,a5,-65
    800023ee:	e11c                	sd	a5,0(a0)
    800023f0:	bf65                	j	800023a8 <sys_pgaccess+0x64>
    }
    step += PGSIZE;
  }
  copyout(p, ret_addr, (char *)&value, sizeof(value));
    800023f2:	46a1                	li	a3,8
    800023f4:	fb040613          	addi	a2,s0,-80
    800023f8:	fb843583          	ld	a1,-72(s0)
    800023fc:	854e                	mv	a0,s3
    800023fe:	ffffe097          	auipc	ra,0xffffe
    80002402:	70c080e7          	jalr	1804(ra) # 80000b0a <copyout>
  return 0;
    80002406:	4501                	li	a0,0
}
    80002408:	60a6                	ld	ra,72(sp)
    8000240a:	6406                	ld	s0,64(sp)
    8000240c:	74e2                	ld	s1,56(sp)
    8000240e:	7942                	ld	s2,48(sp)
    80002410:	79a2                	ld	s3,40(sp)
    80002412:	7a02                	ld	s4,32(sp)
    80002414:	6161                	addi	sp,sp,80
    80002416:	8082                	ret
    return -1;
    80002418:	557d                	li	a0,-1
    8000241a:	b7fd                	j	80002408 <sys_pgaccess+0xc4>
    return -1;
    8000241c:	557d                	li	a0,-1
    8000241e:	b7ed                	j	80002408 <sys_pgaccess+0xc4>
    return -1;
    80002420:	557d                	li	a0,-1
    80002422:	b7dd                	j	80002408 <sys_pgaccess+0xc4>

0000000080002424 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002424:	1101                	addi	sp,sp,-32
    80002426:	ec06                	sd	ra,24(sp)
    80002428:	e822                	sd	s0,16(sp)
    8000242a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000242c:	fec40593          	addi	a1,s0,-20
    80002430:	4501                	li	a0,0
    80002432:	00000097          	auipc	ra,0x0
    80002436:	ca4080e7          	jalr	-860(ra) # 800020d6 <argint>
    8000243a:	87aa                	mv	a5,a0
    return -1;
    8000243c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000243e:	0007c863          	bltz	a5,8000244e <sys_kill+0x2a>
  return kill(pid);
    80002442:	fec42503          	lw	a0,-20(s0)
    80002446:	fffff097          	auipc	ra,0xfffff
    8000244a:	5d2080e7          	jalr	1490(ra) # 80001a18 <kill>
}
    8000244e:	60e2                	ld	ra,24(sp)
    80002450:	6442                	ld	s0,16(sp)
    80002452:	6105                	addi	sp,sp,32
    80002454:	8082                	ret

0000000080002456 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002456:	1101                	addi	sp,sp,-32
    80002458:	ec06                	sd	ra,24(sp)
    8000245a:	e822                	sd	s0,16(sp)
    8000245c:	e426                	sd	s1,8(sp)
    8000245e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002460:	0000d517          	auipc	a0,0xd
    80002464:	c2050513          	addi	a0,a0,-992 # 8000f080 <tickslock>
    80002468:	00004097          	auipc	ra,0x4
    8000246c:	eda080e7          	jalr	-294(ra) # 80006342 <acquire>
  xticks = ticks;
    80002470:	00007497          	auipc	s1,0x7
    80002474:	ba84a483          	lw	s1,-1112(s1) # 80009018 <ticks>
  release(&tickslock);
    80002478:	0000d517          	auipc	a0,0xd
    8000247c:	c0850513          	addi	a0,a0,-1016 # 8000f080 <tickslock>
    80002480:	00004097          	auipc	ra,0x4
    80002484:	f76080e7          	jalr	-138(ra) # 800063f6 <release>
  return xticks;
}
    80002488:	02049513          	slli	a0,s1,0x20
    8000248c:	9101                	srli	a0,a0,0x20
    8000248e:	60e2                	ld	ra,24(sp)
    80002490:	6442                	ld	s0,16(sp)
    80002492:	64a2                	ld	s1,8(sp)
    80002494:	6105                	addi	sp,sp,32
    80002496:	8082                	ret

0000000080002498 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002498:	7179                	addi	sp,sp,-48
    8000249a:	f406                	sd	ra,40(sp)
    8000249c:	f022                	sd	s0,32(sp)
    8000249e:	ec26                	sd	s1,24(sp)
    800024a0:	e84a                	sd	s2,16(sp)
    800024a2:	e44e                	sd	s3,8(sp)
    800024a4:	e052                	sd	s4,0(sp)
    800024a6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024a8:	00006597          	auipc	a1,0x6
    800024ac:	05058593          	addi	a1,a1,80 # 800084f8 <syscalls+0xf8>
    800024b0:	0000d517          	auipc	a0,0xd
    800024b4:	be850513          	addi	a0,a0,-1048 # 8000f098 <bcache>
    800024b8:	00004097          	auipc	ra,0x4
    800024bc:	dfa080e7          	jalr	-518(ra) # 800062b2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024c0:	00015797          	auipc	a5,0x15
    800024c4:	bd878793          	addi	a5,a5,-1064 # 80017098 <bcache+0x8000>
    800024c8:	00015717          	auipc	a4,0x15
    800024cc:	e3870713          	addi	a4,a4,-456 # 80017300 <bcache+0x8268>
    800024d0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024d4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024d8:	0000d497          	auipc	s1,0xd
    800024dc:	bd848493          	addi	s1,s1,-1064 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024e0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024e2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024e4:	00006a17          	auipc	s4,0x6
    800024e8:	01ca0a13          	addi	s4,s4,28 # 80008500 <syscalls+0x100>
    b->next = bcache.head.next;
    800024ec:	2b893783          	ld	a5,696(s2)
    800024f0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024f2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024f6:	85d2                	mv	a1,s4
    800024f8:	01048513          	addi	a0,s1,16
    800024fc:	00001097          	auipc	ra,0x1
    80002500:	4bc080e7          	jalr	1212(ra) # 800039b8 <initsleeplock>
    bcache.head.next->prev = b;
    80002504:	2b893783          	ld	a5,696(s2)
    80002508:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000250a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000250e:	45848493          	addi	s1,s1,1112
    80002512:	fd349de3          	bne	s1,s3,800024ec <binit+0x54>
  }
}
    80002516:	70a2                	ld	ra,40(sp)
    80002518:	7402                	ld	s0,32(sp)
    8000251a:	64e2                	ld	s1,24(sp)
    8000251c:	6942                	ld	s2,16(sp)
    8000251e:	69a2                	ld	s3,8(sp)
    80002520:	6a02                	ld	s4,0(sp)
    80002522:	6145                	addi	sp,sp,48
    80002524:	8082                	ret

0000000080002526 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002526:	7179                	addi	sp,sp,-48
    80002528:	f406                	sd	ra,40(sp)
    8000252a:	f022                	sd	s0,32(sp)
    8000252c:	ec26                	sd	s1,24(sp)
    8000252e:	e84a                	sd	s2,16(sp)
    80002530:	e44e                	sd	s3,8(sp)
    80002532:	1800                	addi	s0,sp,48
    80002534:	89aa                	mv	s3,a0
    80002536:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002538:	0000d517          	auipc	a0,0xd
    8000253c:	b6050513          	addi	a0,a0,-1184 # 8000f098 <bcache>
    80002540:	00004097          	auipc	ra,0x4
    80002544:	e02080e7          	jalr	-510(ra) # 80006342 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002548:	00015497          	auipc	s1,0x15
    8000254c:	e084b483          	ld	s1,-504(s1) # 80017350 <bcache+0x82b8>
    80002550:	00015797          	auipc	a5,0x15
    80002554:	db078793          	addi	a5,a5,-592 # 80017300 <bcache+0x8268>
    80002558:	02f48f63          	beq	s1,a5,80002596 <bread+0x70>
    8000255c:	873e                	mv	a4,a5
    8000255e:	a021                	j	80002566 <bread+0x40>
    80002560:	68a4                	ld	s1,80(s1)
    80002562:	02e48a63          	beq	s1,a4,80002596 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002566:	449c                	lw	a5,8(s1)
    80002568:	ff379ce3          	bne	a5,s3,80002560 <bread+0x3a>
    8000256c:	44dc                	lw	a5,12(s1)
    8000256e:	ff2799e3          	bne	a5,s2,80002560 <bread+0x3a>
      b->refcnt++;
    80002572:	40bc                	lw	a5,64(s1)
    80002574:	2785                	addiw	a5,a5,1
    80002576:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002578:	0000d517          	auipc	a0,0xd
    8000257c:	b2050513          	addi	a0,a0,-1248 # 8000f098 <bcache>
    80002580:	00004097          	auipc	ra,0x4
    80002584:	e76080e7          	jalr	-394(ra) # 800063f6 <release>
      acquiresleep(&b->lock);
    80002588:	01048513          	addi	a0,s1,16
    8000258c:	00001097          	auipc	ra,0x1
    80002590:	466080e7          	jalr	1126(ra) # 800039f2 <acquiresleep>
      return b;
    80002594:	a8b9                	j	800025f2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002596:	00015497          	auipc	s1,0x15
    8000259a:	db24b483          	ld	s1,-590(s1) # 80017348 <bcache+0x82b0>
    8000259e:	00015797          	auipc	a5,0x15
    800025a2:	d6278793          	addi	a5,a5,-670 # 80017300 <bcache+0x8268>
    800025a6:	00f48863          	beq	s1,a5,800025b6 <bread+0x90>
    800025aa:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025ac:	40bc                	lw	a5,64(s1)
    800025ae:	cf81                	beqz	a5,800025c6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025b0:	64a4                	ld	s1,72(s1)
    800025b2:	fee49de3          	bne	s1,a4,800025ac <bread+0x86>
  panic("bget: no buffers");
    800025b6:	00006517          	auipc	a0,0x6
    800025ba:	f5250513          	addi	a0,a0,-174 # 80008508 <syscalls+0x108>
    800025be:	00004097          	auipc	ra,0x4
    800025c2:	83a080e7          	jalr	-1990(ra) # 80005df8 <panic>
      b->dev = dev;
    800025c6:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800025ca:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800025ce:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025d2:	4785                	li	a5,1
    800025d4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025d6:	0000d517          	auipc	a0,0xd
    800025da:	ac250513          	addi	a0,a0,-1342 # 8000f098 <bcache>
    800025de:	00004097          	auipc	ra,0x4
    800025e2:	e18080e7          	jalr	-488(ra) # 800063f6 <release>
      acquiresleep(&b->lock);
    800025e6:	01048513          	addi	a0,s1,16
    800025ea:	00001097          	auipc	ra,0x1
    800025ee:	408080e7          	jalr	1032(ra) # 800039f2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025f2:	409c                	lw	a5,0(s1)
    800025f4:	cb89                	beqz	a5,80002606 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025f6:	8526                	mv	a0,s1
    800025f8:	70a2                	ld	ra,40(sp)
    800025fa:	7402                	ld	s0,32(sp)
    800025fc:	64e2                	ld	s1,24(sp)
    800025fe:	6942                	ld	s2,16(sp)
    80002600:	69a2                	ld	s3,8(sp)
    80002602:	6145                	addi	sp,sp,48
    80002604:	8082                	ret
    virtio_disk_rw(b, 0);
    80002606:	4581                	li	a1,0
    80002608:	8526                	mv	a0,s1
    8000260a:	00003097          	auipc	ra,0x3
    8000260e:	f2c080e7          	jalr	-212(ra) # 80005536 <virtio_disk_rw>
    b->valid = 1;
    80002612:	4785                	li	a5,1
    80002614:	c09c                	sw	a5,0(s1)
  return b;
    80002616:	b7c5                	j	800025f6 <bread+0xd0>

0000000080002618 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002618:	1101                	addi	sp,sp,-32
    8000261a:	ec06                	sd	ra,24(sp)
    8000261c:	e822                	sd	s0,16(sp)
    8000261e:	e426                	sd	s1,8(sp)
    80002620:	1000                	addi	s0,sp,32
    80002622:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002624:	0541                	addi	a0,a0,16
    80002626:	00001097          	auipc	ra,0x1
    8000262a:	466080e7          	jalr	1126(ra) # 80003a8c <holdingsleep>
    8000262e:	cd01                	beqz	a0,80002646 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002630:	4585                	li	a1,1
    80002632:	8526                	mv	a0,s1
    80002634:	00003097          	auipc	ra,0x3
    80002638:	f02080e7          	jalr	-254(ra) # 80005536 <virtio_disk_rw>
}
    8000263c:	60e2                	ld	ra,24(sp)
    8000263e:	6442                	ld	s0,16(sp)
    80002640:	64a2                	ld	s1,8(sp)
    80002642:	6105                	addi	sp,sp,32
    80002644:	8082                	ret
    panic("bwrite");
    80002646:	00006517          	auipc	a0,0x6
    8000264a:	eda50513          	addi	a0,a0,-294 # 80008520 <syscalls+0x120>
    8000264e:	00003097          	auipc	ra,0x3
    80002652:	7aa080e7          	jalr	1962(ra) # 80005df8 <panic>

0000000080002656 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002656:	1101                	addi	sp,sp,-32
    80002658:	ec06                	sd	ra,24(sp)
    8000265a:	e822                	sd	s0,16(sp)
    8000265c:	e426                	sd	s1,8(sp)
    8000265e:	e04a                	sd	s2,0(sp)
    80002660:	1000                	addi	s0,sp,32
    80002662:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002664:	01050913          	addi	s2,a0,16
    80002668:	854a                	mv	a0,s2
    8000266a:	00001097          	auipc	ra,0x1
    8000266e:	422080e7          	jalr	1058(ra) # 80003a8c <holdingsleep>
    80002672:	c92d                	beqz	a0,800026e4 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002674:	854a                	mv	a0,s2
    80002676:	00001097          	auipc	ra,0x1
    8000267a:	3d2080e7          	jalr	978(ra) # 80003a48 <releasesleep>

  acquire(&bcache.lock);
    8000267e:	0000d517          	auipc	a0,0xd
    80002682:	a1a50513          	addi	a0,a0,-1510 # 8000f098 <bcache>
    80002686:	00004097          	auipc	ra,0x4
    8000268a:	cbc080e7          	jalr	-836(ra) # 80006342 <acquire>
  b->refcnt--;
    8000268e:	40bc                	lw	a5,64(s1)
    80002690:	37fd                	addiw	a5,a5,-1
    80002692:	0007871b          	sext.w	a4,a5
    80002696:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002698:	eb05                	bnez	a4,800026c8 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000269a:	68bc                	ld	a5,80(s1)
    8000269c:	64b8                	ld	a4,72(s1)
    8000269e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026a0:	64bc                	ld	a5,72(s1)
    800026a2:	68b8                	ld	a4,80(s1)
    800026a4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026a6:	00015797          	auipc	a5,0x15
    800026aa:	9f278793          	addi	a5,a5,-1550 # 80017098 <bcache+0x8000>
    800026ae:	2b87b703          	ld	a4,696(a5)
    800026b2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026b4:	00015717          	auipc	a4,0x15
    800026b8:	c4c70713          	addi	a4,a4,-948 # 80017300 <bcache+0x8268>
    800026bc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026be:	2b87b703          	ld	a4,696(a5)
    800026c2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026c4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026c8:	0000d517          	auipc	a0,0xd
    800026cc:	9d050513          	addi	a0,a0,-1584 # 8000f098 <bcache>
    800026d0:	00004097          	auipc	ra,0x4
    800026d4:	d26080e7          	jalr	-730(ra) # 800063f6 <release>
}
    800026d8:	60e2                	ld	ra,24(sp)
    800026da:	6442                	ld	s0,16(sp)
    800026dc:	64a2                	ld	s1,8(sp)
    800026de:	6902                	ld	s2,0(sp)
    800026e0:	6105                	addi	sp,sp,32
    800026e2:	8082                	ret
    panic("brelse");
    800026e4:	00006517          	auipc	a0,0x6
    800026e8:	e4450513          	addi	a0,a0,-444 # 80008528 <syscalls+0x128>
    800026ec:	00003097          	auipc	ra,0x3
    800026f0:	70c080e7          	jalr	1804(ra) # 80005df8 <panic>

00000000800026f4 <bpin>:

void
bpin(struct buf *b) {
    800026f4:	1101                	addi	sp,sp,-32
    800026f6:	ec06                	sd	ra,24(sp)
    800026f8:	e822                	sd	s0,16(sp)
    800026fa:	e426                	sd	s1,8(sp)
    800026fc:	1000                	addi	s0,sp,32
    800026fe:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002700:	0000d517          	auipc	a0,0xd
    80002704:	99850513          	addi	a0,a0,-1640 # 8000f098 <bcache>
    80002708:	00004097          	auipc	ra,0x4
    8000270c:	c3a080e7          	jalr	-966(ra) # 80006342 <acquire>
  b->refcnt++;
    80002710:	40bc                	lw	a5,64(s1)
    80002712:	2785                	addiw	a5,a5,1
    80002714:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002716:	0000d517          	auipc	a0,0xd
    8000271a:	98250513          	addi	a0,a0,-1662 # 8000f098 <bcache>
    8000271e:	00004097          	auipc	ra,0x4
    80002722:	cd8080e7          	jalr	-808(ra) # 800063f6 <release>
}
    80002726:	60e2                	ld	ra,24(sp)
    80002728:	6442                	ld	s0,16(sp)
    8000272a:	64a2                	ld	s1,8(sp)
    8000272c:	6105                	addi	sp,sp,32
    8000272e:	8082                	ret

0000000080002730 <bunpin>:

void
bunpin(struct buf *b) {
    80002730:	1101                	addi	sp,sp,-32
    80002732:	ec06                	sd	ra,24(sp)
    80002734:	e822                	sd	s0,16(sp)
    80002736:	e426                	sd	s1,8(sp)
    80002738:	1000                	addi	s0,sp,32
    8000273a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000273c:	0000d517          	auipc	a0,0xd
    80002740:	95c50513          	addi	a0,a0,-1700 # 8000f098 <bcache>
    80002744:	00004097          	auipc	ra,0x4
    80002748:	bfe080e7          	jalr	-1026(ra) # 80006342 <acquire>
  b->refcnt--;
    8000274c:	40bc                	lw	a5,64(s1)
    8000274e:	37fd                	addiw	a5,a5,-1
    80002750:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002752:	0000d517          	auipc	a0,0xd
    80002756:	94650513          	addi	a0,a0,-1722 # 8000f098 <bcache>
    8000275a:	00004097          	auipc	ra,0x4
    8000275e:	c9c080e7          	jalr	-868(ra) # 800063f6 <release>
}
    80002762:	60e2                	ld	ra,24(sp)
    80002764:	6442                	ld	s0,16(sp)
    80002766:	64a2                	ld	s1,8(sp)
    80002768:	6105                	addi	sp,sp,32
    8000276a:	8082                	ret

000000008000276c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000276c:	1101                	addi	sp,sp,-32
    8000276e:	ec06                	sd	ra,24(sp)
    80002770:	e822                	sd	s0,16(sp)
    80002772:	e426                	sd	s1,8(sp)
    80002774:	e04a                	sd	s2,0(sp)
    80002776:	1000                	addi	s0,sp,32
    80002778:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000277a:	00d5d59b          	srliw	a1,a1,0xd
    8000277e:	00015797          	auipc	a5,0x15
    80002782:	ff67a783          	lw	a5,-10(a5) # 80017774 <sb+0x1c>
    80002786:	9dbd                	addw	a1,a1,a5
    80002788:	00000097          	auipc	ra,0x0
    8000278c:	d9e080e7          	jalr	-610(ra) # 80002526 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002790:	0074f713          	andi	a4,s1,7
    80002794:	4785                	li	a5,1
    80002796:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000279a:	14ce                	slli	s1,s1,0x33
    8000279c:	90d9                	srli	s1,s1,0x36
    8000279e:	00950733          	add	a4,a0,s1
    800027a2:	05874703          	lbu	a4,88(a4)
    800027a6:	00e7f6b3          	and	a3,a5,a4
    800027aa:	c69d                	beqz	a3,800027d8 <bfree+0x6c>
    800027ac:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027ae:	94aa                	add	s1,s1,a0
    800027b0:	fff7c793          	not	a5,a5
    800027b4:	8ff9                	and	a5,a5,a4
    800027b6:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800027ba:	00001097          	auipc	ra,0x1
    800027be:	118080e7          	jalr	280(ra) # 800038d2 <log_write>
  brelse(bp);
    800027c2:	854a                	mv	a0,s2
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	e92080e7          	jalr	-366(ra) # 80002656 <brelse>
}
    800027cc:	60e2                	ld	ra,24(sp)
    800027ce:	6442                	ld	s0,16(sp)
    800027d0:	64a2                	ld	s1,8(sp)
    800027d2:	6902                	ld	s2,0(sp)
    800027d4:	6105                	addi	sp,sp,32
    800027d6:	8082                	ret
    panic("freeing free block");
    800027d8:	00006517          	auipc	a0,0x6
    800027dc:	d5850513          	addi	a0,a0,-680 # 80008530 <syscalls+0x130>
    800027e0:	00003097          	auipc	ra,0x3
    800027e4:	618080e7          	jalr	1560(ra) # 80005df8 <panic>

00000000800027e8 <balloc>:
{
    800027e8:	711d                	addi	sp,sp,-96
    800027ea:	ec86                	sd	ra,88(sp)
    800027ec:	e8a2                	sd	s0,80(sp)
    800027ee:	e4a6                	sd	s1,72(sp)
    800027f0:	e0ca                	sd	s2,64(sp)
    800027f2:	fc4e                	sd	s3,56(sp)
    800027f4:	f852                	sd	s4,48(sp)
    800027f6:	f456                	sd	s5,40(sp)
    800027f8:	f05a                	sd	s6,32(sp)
    800027fa:	ec5e                	sd	s7,24(sp)
    800027fc:	e862                	sd	s8,16(sp)
    800027fe:	e466                	sd	s9,8(sp)
    80002800:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002802:	00015797          	auipc	a5,0x15
    80002806:	f5a7a783          	lw	a5,-166(a5) # 8001775c <sb+0x4>
    8000280a:	cbd1                	beqz	a5,8000289e <balloc+0xb6>
    8000280c:	8baa                	mv	s7,a0
    8000280e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002810:	00015b17          	auipc	s6,0x15
    80002814:	f48b0b13          	addi	s6,s6,-184 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002818:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000281a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000281c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000281e:	6c89                	lui	s9,0x2
    80002820:	a831                	j	8000283c <balloc+0x54>
    brelse(bp);
    80002822:	854a                	mv	a0,s2
    80002824:	00000097          	auipc	ra,0x0
    80002828:	e32080e7          	jalr	-462(ra) # 80002656 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000282c:	015c87bb          	addw	a5,s9,s5
    80002830:	00078a9b          	sext.w	s5,a5
    80002834:	004b2703          	lw	a4,4(s6)
    80002838:	06eaf363          	bgeu	s5,a4,8000289e <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000283c:	41fad79b          	sraiw	a5,s5,0x1f
    80002840:	0137d79b          	srliw	a5,a5,0x13
    80002844:	015787bb          	addw	a5,a5,s5
    80002848:	40d7d79b          	sraiw	a5,a5,0xd
    8000284c:	01cb2583          	lw	a1,28(s6)
    80002850:	9dbd                	addw	a1,a1,a5
    80002852:	855e                	mv	a0,s7
    80002854:	00000097          	auipc	ra,0x0
    80002858:	cd2080e7          	jalr	-814(ra) # 80002526 <bread>
    8000285c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000285e:	004b2503          	lw	a0,4(s6)
    80002862:	000a849b          	sext.w	s1,s5
    80002866:	8662                	mv	a2,s8
    80002868:	faa4fde3          	bgeu	s1,a0,80002822 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000286c:	41f6579b          	sraiw	a5,a2,0x1f
    80002870:	01d7d69b          	srliw	a3,a5,0x1d
    80002874:	00c6873b          	addw	a4,a3,a2
    80002878:	00777793          	andi	a5,a4,7
    8000287c:	9f95                	subw	a5,a5,a3
    8000287e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002882:	4037571b          	sraiw	a4,a4,0x3
    80002886:	00e906b3          	add	a3,s2,a4
    8000288a:	0586c683          	lbu	a3,88(a3)
    8000288e:	00d7f5b3          	and	a1,a5,a3
    80002892:	cd91                	beqz	a1,800028ae <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002894:	2605                	addiw	a2,a2,1
    80002896:	2485                	addiw	s1,s1,1
    80002898:	fd4618e3          	bne	a2,s4,80002868 <balloc+0x80>
    8000289c:	b759                	j	80002822 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000289e:	00006517          	auipc	a0,0x6
    800028a2:	caa50513          	addi	a0,a0,-854 # 80008548 <syscalls+0x148>
    800028a6:	00003097          	auipc	ra,0x3
    800028aa:	552080e7          	jalr	1362(ra) # 80005df8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028ae:	974a                	add	a4,a4,s2
    800028b0:	8fd5                	or	a5,a5,a3
    800028b2:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800028b6:	854a                	mv	a0,s2
    800028b8:	00001097          	auipc	ra,0x1
    800028bc:	01a080e7          	jalr	26(ra) # 800038d2 <log_write>
        brelse(bp);
    800028c0:	854a                	mv	a0,s2
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	d94080e7          	jalr	-620(ra) # 80002656 <brelse>
  bp = bread(dev, bno);
    800028ca:	85a6                	mv	a1,s1
    800028cc:	855e                	mv	a0,s7
    800028ce:	00000097          	auipc	ra,0x0
    800028d2:	c58080e7          	jalr	-936(ra) # 80002526 <bread>
    800028d6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028d8:	40000613          	li	a2,1024
    800028dc:	4581                	li	a1,0
    800028de:	05850513          	addi	a0,a0,88
    800028e2:	ffffe097          	auipc	ra,0xffffe
    800028e6:	896080e7          	jalr	-1898(ra) # 80000178 <memset>
  log_write(bp);
    800028ea:	854a                	mv	a0,s2
    800028ec:	00001097          	auipc	ra,0x1
    800028f0:	fe6080e7          	jalr	-26(ra) # 800038d2 <log_write>
  brelse(bp);
    800028f4:	854a                	mv	a0,s2
    800028f6:	00000097          	auipc	ra,0x0
    800028fa:	d60080e7          	jalr	-672(ra) # 80002656 <brelse>
}
    800028fe:	8526                	mv	a0,s1
    80002900:	60e6                	ld	ra,88(sp)
    80002902:	6446                	ld	s0,80(sp)
    80002904:	64a6                	ld	s1,72(sp)
    80002906:	6906                	ld	s2,64(sp)
    80002908:	79e2                	ld	s3,56(sp)
    8000290a:	7a42                	ld	s4,48(sp)
    8000290c:	7aa2                	ld	s5,40(sp)
    8000290e:	7b02                	ld	s6,32(sp)
    80002910:	6be2                	ld	s7,24(sp)
    80002912:	6c42                	ld	s8,16(sp)
    80002914:	6ca2                	ld	s9,8(sp)
    80002916:	6125                	addi	sp,sp,96
    80002918:	8082                	ret

000000008000291a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000291a:	7179                	addi	sp,sp,-48
    8000291c:	f406                	sd	ra,40(sp)
    8000291e:	f022                	sd	s0,32(sp)
    80002920:	ec26                	sd	s1,24(sp)
    80002922:	e84a                	sd	s2,16(sp)
    80002924:	e44e                	sd	s3,8(sp)
    80002926:	e052                	sd	s4,0(sp)
    80002928:	1800                	addi	s0,sp,48
    8000292a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000292c:	47ad                	li	a5,11
    8000292e:	04b7fe63          	bgeu	a5,a1,8000298a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002932:	ff45849b          	addiw	s1,a1,-12
    80002936:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000293a:	0ff00793          	li	a5,255
    8000293e:	0ae7e363          	bltu	a5,a4,800029e4 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002942:	08052583          	lw	a1,128(a0)
    80002946:	c5ad                	beqz	a1,800029b0 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002948:	00092503          	lw	a0,0(s2)
    8000294c:	00000097          	auipc	ra,0x0
    80002950:	bda080e7          	jalr	-1062(ra) # 80002526 <bread>
    80002954:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002956:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000295a:	02049593          	slli	a1,s1,0x20
    8000295e:	9181                	srli	a1,a1,0x20
    80002960:	058a                	slli	a1,a1,0x2
    80002962:	00b784b3          	add	s1,a5,a1
    80002966:	0004a983          	lw	s3,0(s1)
    8000296a:	04098d63          	beqz	s3,800029c4 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000296e:	8552                	mv	a0,s4
    80002970:	00000097          	auipc	ra,0x0
    80002974:	ce6080e7          	jalr	-794(ra) # 80002656 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002978:	854e                	mv	a0,s3
    8000297a:	70a2                	ld	ra,40(sp)
    8000297c:	7402                	ld	s0,32(sp)
    8000297e:	64e2                	ld	s1,24(sp)
    80002980:	6942                	ld	s2,16(sp)
    80002982:	69a2                	ld	s3,8(sp)
    80002984:	6a02                	ld	s4,0(sp)
    80002986:	6145                	addi	sp,sp,48
    80002988:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000298a:	02059493          	slli	s1,a1,0x20
    8000298e:	9081                	srli	s1,s1,0x20
    80002990:	048a                	slli	s1,s1,0x2
    80002992:	94aa                	add	s1,s1,a0
    80002994:	0504a983          	lw	s3,80(s1)
    80002998:	fe0990e3          	bnez	s3,80002978 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000299c:	4108                	lw	a0,0(a0)
    8000299e:	00000097          	auipc	ra,0x0
    800029a2:	e4a080e7          	jalr	-438(ra) # 800027e8 <balloc>
    800029a6:	0005099b          	sext.w	s3,a0
    800029aa:	0534a823          	sw	s3,80(s1)
    800029ae:	b7e9                	j	80002978 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029b0:	4108                	lw	a0,0(a0)
    800029b2:	00000097          	auipc	ra,0x0
    800029b6:	e36080e7          	jalr	-458(ra) # 800027e8 <balloc>
    800029ba:	0005059b          	sext.w	a1,a0
    800029be:	08b92023          	sw	a1,128(s2)
    800029c2:	b759                	j	80002948 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029c4:	00092503          	lw	a0,0(s2)
    800029c8:	00000097          	auipc	ra,0x0
    800029cc:	e20080e7          	jalr	-480(ra) # 800027e8 <balloc>
    800029d0:	0005099b          	sext.w	s3,a0
    800029d4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029d8:	8552                	mv	a0,s4
    800029da:	00001097          	auipc	ra,0x1
    800029de:	ef8080e7          	jalr	-264(ra) # 800038d2 <log_write>
    800029e2:	b771                	j	8000296e <bmap+0x54>
  panic("bmap: out of range");
    800029e4:	00006517          	auipc	a0,0x6
    800029e8:	b7c50513          	addi	a0,a0,-1156 # 80008560 <syscalls+0x160>
    800029ec:	00003097          	auipc	ra,0x3
    800029f0:	40c080e7          	jalr	1036(ra) # 80005df8 <panic>

00000000800029f4 <iget>:
{
    800029f4:	7179                	addi	sp,sp,-48
    800029f6:	f406                	sd	ra,40(sp)
    800029f8:	f022                	sd	s0,32(sp)
    800029fa:	ec26                	sd	s1,24(sp)
    800029fc:	e84a                	sd	s2,16(sp)
    800029fe:	e44e                	sd	s3,8(sp)
    80002a00:	e052                	sd	s4,0(sp)
    80002a02:	1800                	addi	s0,sp,48
    80002a04:	89aa                	mv	s3,a0
    80002a06:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a08:	00015517          	auipc	a0,0x15
    80002a0c:	d7050513          	addi	a0,a0,-656 # 80017778 <itable>
    80002a10:	00004097          	auipc	ra,0x4
    80002a14:	932080e7          	jalr	-1742(ra) # 80006342 <acquire>
  empty = 0;
    80002a18:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a1a:	00015497          	auipc	s1,0x15
    80002a1e:	d7648493          	addi	s1,s1,-650 # 80017790 <itable+0x18>
    80002a22:	00016697          	auipc	a3,0x16
    80002a26:	7fe68693          	addi	a3,a3,2046 # 80019220 <log>
    80002a2a:	a039                	j	80002a38 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a2c:	02090b63          	beqz	s2,80002a62 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a30:	08848493          	addi	s1,s1,136
    80002a34:	02d48a63          	beq	s1,a3,80002a68 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a38:	449c                	lw	a5,8(s1)
    80002a3a:	fef059e3          	blez	a5,80002a2c <iget+0x38>
    80002a3e:	4098                	lw	a4,0(s1)
    80002a40:	ff3716e3          	bne	a4,s3,80002a2c <iget+0x38>
    80002a44:	40d8                	lw	a4,4(s1)
    80002a46:	ff4713e3          	bne	a4,s4,80002a2c <iget+0x38>
      ip->ref++;
    80002a4a:	2785                	addiw	a5,a5,1
    80002a4c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a4e:	00015517          	auipc	a0,0x15
    80002a52:	d2a50513          	addi	a0,a0,-726 # 80017778 <itable>
    80002a56:	00004097          	auipc	ra,0x4
    80002a5a:	9a0080e7          	jalr	-1632(ra) # 800063f6 <release>
      return ip;
    80002a5e:	8926                	mv	s2,s1
    80002a60:	a03d                	j	80002a8e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a62:	f7f9                	bnez	a5,80002a30 <iget+0x3c>
    80002a64:	8926                	mv	s2,s1
    80002a66:	b7e9                	j	80002a30 <iget+0x3c>
  if(empty == 0)
    80002a68:	02090c63          	beqz	s2,80002aa0 <iget+0xac>
  ip->dev = dev;
    80002a6c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a70:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a74:	4785                	li	a5,1
    80002a76:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a7a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a7e:	00015517          	auipc	a0,0x15
    80002a82:	cfa50513          	addi	a0,a0,-774 # 80017778 <itable>
    80002a86:	00004097          	auipc	ra,0x4
    80002a8a:	970080e7          	jalr	-1680(ra) # 800063f6 <release>
}
    80002a8e:	854a                	mv	a0,s2
    80002a90:	70a2                	ld	ra,40(sp)
    80002a92:	7402                	ld	s0,32(sp)
    80002a94:	64e2                	ld	s1,24(sp)
    80002a96:	6942                	ld	s2,16(sp)
    80002a98:	69a2                	ld	s3,8(sp)
    80002a9a:	6a02                	ld	s4,0(sp)
    80002a9c:	6145                	addi	sp,sp,48
    80002a9e:	8082                	ret
    panic("iget: no inodes");
    80002aa0:	00006517          	auipc	a0,0x6
    80002aa4:	ad850513          	addi	a0,a0,-1320 # 80008578 <syscalls+0x178>
    80002aa8:	00003097          	auipc	ra,0x3
    80002aac:	350080e7          	jalr	848(ra) # 80005df8 <panic>

0000000080002ab0 <fsinit>:
fsinit(int dev) {
    80002ab0:	7179                	addi	sp,sp,-48
    80002ab2:	f406                	sd	ra,40(sp)
    80002ab4:	f022                	sd	s0,32(sp)
    80002ab6:	ec26                	sd	s1,24(sp)
    80002ab8:	e84a                	sd	s2,16(sp)
    80002aba:	e44e                	sd	s3,8(sp)
    80002abc:	1800                	addi	s0,sp,48
    80002abe:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002ac0:	4585                	li	a1,1
    80002ac2:	00000097          	auipc	ra,0x0
    80002ac6:	a64080e7          	jalr	-1436(ra) # 80002526 <bread>
    80002aca:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002acc:	00015997          	auipc	s3,0x15
    80002ad0:	c8c98993          	addi	s3,s3,-884 # 80017758 <sb>
    80002ad4:	02000613          	li	a2,32
    80002ad8:	05850593          	addi	a1,a0,88
    80002adc:	854e                	mv	a0,s3
    80002ade:	ffffd097          	auipc	ra,0xffffd
    80002ae2:	6fa080e7          	jalr	1786(ra) # 800001d8 <memmove>
  brelse(bp);
    80002ae6:	8526                	mv	a0,s1
    80002ae8:	00000097          	auipc	ra,0x0
    80002aec:	b6e080e7          	jalr	-1170(ra) # 80002656 <brelse>
  if(sb.magic != FSMAGIC)
    80002af0:	0009a703          	lw	a4,0(s3)
    80002af4:	102037b7          	lui	a5,0x10203
    80002af8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002afc:	02f71263          	bne	a4,a5,80002b20 <fsinit+0x70>
  initlog(dev, &sb);
    80002b00:	00015597          	auipc	a1,0x15
    80002b04:	c5858593          	addi	a1,a1,-936 # 80017758 <sb>
    80002b08:	854a                	mv	a0,s2
    80002b0a:	00001097          	auipc	ra,0x1
    80002b0e:	b4c080e7          	jalr	-1204(ra) # 80003656 <initlog>
}
    80002b12:	70a2                	ld	ra,40(sp)
    80002b14:	7402                	ld	s0,32(sp)
    80002b16:	64e2                	ld	s1,24(sp)
    80002b18:	6942                	ld	s2,16(sp)
    80002b1a:	69a2                	ld	s3,8(sp)
    80002b1c:	6145                	addi	sp,sp,48
    80002b1e:	8082                	ret
    panic("invalid file system");
    80002b20:	00006517          	auipc	a0,0x6
    80002b24:	a6850513          	addi	a0,a0,-1432 # 80008588 <syscalls+0x188>
    80002b28:	00003097          	auipc	ra,0x3
    80002b2c:	2d0080e7          	jalr	720(ra) # 80005df8 <panic>

0000000080002b30 <iinit>:
{
    80002b30:	7179                	addi	sp,sp,-48
    80002b32:	f406                	sd	ra,40(sp)
    80002b34:	f022                	sd	s0,32(sp)
    80002b36:	ec26                	sd	s1,24(sp)
    80002b38:	e84a                	sd	s2,16(sp)
    80002b3a:	e44e                	sd	s3,8(sp)
    80002b3c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b3e:	00006597          	auipc	a1,0x6
    80002b42:	a6258593          	addi	a1,a1,-1438 # 800085a0 <syscalls+0x1a0>
    80002b46:	00015517          	auipc	a0,0x15
    80002b4a:	c3250513          	addi	a0,a0,-974 # 80017778 <itable>
    80002b4e:	00003097          	auipc	ra,0x3
    80002b52:	764080e7          	jalr	1892(ra) # 800062b2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b56:	00015497          	auipc	s1,0x15
    80002b5a:	c4a48493          	addi	s1,s1,-950 # 800177a0 <itable+0x28>
    80002b5e:	00016997          	auipc	s3,0x16
    80002b62:	6d298993          	addi	s3,s3,1746 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b66:	00006917          	auipc	s2,0x6
    80002b6a:	a4290913          	addi	s2,s2,-1470 # 800085a8 <syscalls+0x1a8>
    80002b6e:	85ca                	mv	a1,s2
    80002b70:	8526                	mv	a0,s1
    80002b72:	00001097          	auipc	ra,0x1
    80002b76:	e46080e7          	jalr	-442(ra) # 800039b8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b7a:	08848493          	addi	s1,s1,136
    80002b7e:	ff3498e3          	bne	s1,s3,80002b6e <iinit+0x3e>
}
    80002b82:	70a2                	ld	ra,40(sp)
    80002b84:	7402                	ld	s0,32(sp)
    80002b86:	64e2                	ld	s1,24(sp)
    80002b88:	6942                	ld	s2,16(sp)
    80002b8a:	69a2                	ld	s3,8(sp)
    80002b8c:	6145                	addi	sp,sp,48
    80002b8e:	8082                	ret

0000000080002b90 <ialloc>:
{
    80002b90:	715d                	addi	sp,sp,-80
    80002b92:	e486                	sd	ra,72(sp)
    80002b94:	e0a2                	sd	s0,64(sp)
    80002b96:	fc26                	sd	s1,56(sp)
    80002b98:	f84a                	sd	s2,48(sp)
    80002b9a:	f44e                	sd	s3,40(sp)
    80002b9c:	f052                	sd	s4,32(sp)
    80002b9e:	ec56                	sd	s5,24(sp)
    80002ba0:	e85a                	sd	s6,16(sp)
    80002ba2:	e45e                	sd	s7,8(sp)
    80002ba4:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ba6:	00015717          	auipc	a4,0x15
    80002baa:	bbe72703          	lw	a4,-1090(a4) # 80017764 <sb+0xc>
    80002bae:	4785                	li	a5,1
    80002bb0:	04e7fa63          	bgeu	a5,a4,80002c04 <ialloc+0x74>
    80002bb4:	8aaa                	mv	s5,a0
    80002bb6:	8bae                	mv	s7,a1
    80002bb8:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bba:	00015a17          	auipc	s4,0x15
    80002bbe:	b9ea0a13          	addi	s4,s4,-1122 # 80017758 <sb>
    80002bc2:	00048b1b          	sext.w	s6,s1
    80002bc6:	0044d593          	srli	a1,s1,0x4
    80002bca:	018a2783          	lw	a5,24(s4)
    80002bce:	9dbd                	addw	a1,a1,a5
    80002bd0:	8556                	mv	a0,s5
    80002bd2:	00000097          	auipc	ra,0x0
    80002bd6:	954080e7          	jalr	-1708(ra) # 80002526 <bread>
    80002bda:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bdc:	05850993          	addi	s3,a0,88
    80002be0:	00f4f793          	andi	a5,s1,15
    80002be4:	079a                	slli	a5,a5,0x6
    80002be6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002be8:	00099783          	lh	a5,0(s3)
    80002bec:	c785                	beqz	a5,80002c14 <ialloc+0x84>
    brelse(bp);
    80002bee:	00000097          	auipc	ra,0x0
    80002bf2:	a68080e7          	jalr	-1432(ra) # 80002656 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bf6:	0485                	addi	s1,s1,1
    80002bf8:	00ca2703          	lw	a4,12(s4)
    80002bfc:	0004879b          	sext.w	a5,s1
    80002c00:	fce7e1e3          	bltu	a5,a4,80002bc2 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c04:	00006517          	auipc	a0,0x6
    80002c08:	9ac50513          	addi	a0,a0,-1620 # 800085b0 <syscalls+0x1b0>
    80002c0c:	00003097          	auipc	ra,0x3
    80002c10:	1ec080e7          	jalr	492(ra) # 80005df8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c14:	04000613          	li	a2,64
    80002c18:	4581                	li	a1,0
    80002c1a:	854e                	mv	a0,s3
    80002c1c:	ffffd097          	auipc	ra,0xffffd
    80002c20:	55c080e7          	jalr	1372(ra) # 80000178 <memset>
      dip->type = type;
    80002c24:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c28:	854a                	mv	a0,s2
    80002c2a:	00001097          	auipc	ra,0x1
    80002c2e:	ca8080e7          	jalr	-856(ra) # 800038d2 <log_write>
      brelse(bp);
    80002c32:	854a                	mv	a0,s2
    80002c34:	00000097          	auipc	ra,0x0
    80002c38:	a22080e7          	jalr	-1502(ra) # 80002656 <brelse>
      return iget(dev, inum);
    80002c3c:	85da                	mv	a1,s6
    80002c3e:	8556                	mv	a0,s5
    80002c40:	00000097          	auipc	ra,0x0
    80002c44:	db4080e7          	jalr	-588(ra) # 800029f4 <iget>
}
    80002c48:	60a6                	ld	ra,72(sp)
    80002c4a:	6406                	ld	s0,64(sp)
    80002c4c:	74e2                	ld	s1,56(sp)
    80002c4e:	7942                	ld	s2,48(sp)
    80002c50:	79a2                	ld	s3,40(sp)
    80002c52:	7a02                	ld	s4,32(sp)
    80002c54:	6ae2                	ld	s5,24(sp)
    80002c56:	6b42                	ld	s6,16(sp)
    80002c58:	6ba2                	ld	s7,8(sp)
    80002c5a:	6161                	addi	sp,sp,80
    80002c5c:	8082                	ret

0000000080002c5e <iupdate>:
{
    80002c5e:	1101                	addi	sp,sp,-32
    80002c60:	ec06                	sd	ra,24(sp)
    80002c62:	e822                	sd	s0,16(sp)
    80002c64:	e426                	sd	s1,8(sp)
    80002c66:	e04a                	sd	s2,0(sp)
    80002c68:	1000                	addi	s0,sp,32
    80002c6a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c6c:	415c                	lw	a5,4(a0)
    80002c6e:	0047d79b          	srliw	a5,a5,0x4
    80002c72:	00015597          	auipc	a1,0x15
    80002c76:	afe5a583          	lw	a1,-1282(a1) # 80017770 <sb+0x18>
    80002c7a:	9dbd                	addw	a1,a1,a5
    80002c7c:	4108                	lw	a0,0(a0)
    80002c7e:	00000097          	auipc	ra,0x0
    80002c82:	8a8080e7          	jalr	-1880(ra) # 80002526 <bread>
    80002c86:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c88:	05850793          	addi	a5,a0,88
    80002c8c:	40c8                	lw	a0,4(s1)
    80002c8e:	893d                	andi	a0,a0,15
    80002c90:	051a                	slli	a0,a0,0x6
    80002c92:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c94:	04449703          	lh	a4,68(s1)
    80002c98:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c9c:	04649703          	lh	a4,70(s1)
    80002ca0:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002ca4:	04849703          	lh	a4,72(s1)
    80002ca8:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002cac:	04a49703          	lh	a4,74(s1)
    80002cb0:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002cb4:	44f8                	lw	a4,76(s1)
    80002cb6:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cb8:	03400613          	li	a2,52
    80002cbc:	05048593          	addi	a1,s1,80
    80002cc0:	0531                	addi	a0,a0,12
    80002cc2:	ffffd097          	auipc	ra,0xffffd
    80002cc6:	516080e7          	jalr	1302(ra) # 800001d8 <memmove>
  log_write(bp);
    80002cca:	854a                	mv	a0,s2
    80002ccc:	00001097          	auipc	ra,0x1
    80002cd0:	c06080e7          	jalr	-1018(ra) # 800038d2 <log_write>
  brelse(bp);
    80002cd4:	854a                	mv	a0,s2
    80002cd6:	00000097          	auipc	ra,0x0
    80002cda:	980080e7          	jalr	-1664(ra) # 80002656 <brelse>
}
    80002cde:	60e2                	ld	ra,24(sp)
    80002ce0:	6442                	ld	s0,16(sp)
    80002ce2:	64a2                	ld	s1,8(sp)
    80002ce4:	6902                	ld	s2,0(sp)
    80002ce6:	6105                	addi	sp,sp,32
    80002ce8:	8082                	ret

0000000080002cea <idup>:
{
    80002cea:	1101                	addi	sp,sp,-32
    80002cec:	ec06                	sd	ra,24(sp)
    80002cee:	e822                	sd	s0,16(sp)
    80002cf0:	e426                	sd	s1,8(sp)
    80002cf2:	1000                	addi	s0,sp,32
    80002cf4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cf6:	00015517          	auipc	a0,0x15
    80002cfa:	a8250513          	addi	a0,a0,-1406 # 80017778 <itable>
    80002cfe:	00003097          	auipc	ra,0x3
    80002d02:	644080e7          	jalr	1604(ra) # 80006342 <acquire>
  ip->ref++;
    80002d06:	449c                	lw	a5,8(s1)
    80002d08:	2785                	addiw	a5,a5,1
    80002d0a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d0c:	00015517          	auipc	a0,0x15
    80002d10:	a6c50513          	addi	a0,a0,-1428 # 80017778 <itable>
    80002d14:	00003097          	auipc	ra,0x3
    80002d18:	6e2080e7          	jalr	1762(ra) # 800063f6 <release>
}
    80002d1c:	8526                	mv	a0,s1
    80002d1e:	60e2                	ld	ra,24(sp)
    80002d20:	6442                	ld	s0,16(sp)
    80002d22:	64a2                	ld	s1,8(sp)
    80002d24:	6105                	addi	sp,sp,32
    80002d26:	8082                	ret

0000000080002d28 <ilock>:
{
    80002d28:	1101                	addi	sp,sp,-32
    80002d2a:	ec06                	sd	ra,24(sp)
    80002d2c:	e822                	sd	s0,16(sp)
    80002d2e:	e426                	sd	s1,8(sp)
    80002d30:	e04a                	sd	s2,0(sp)
    80002d32:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d34:	c115                	beqz	a0,80002d58 <ilock+0x30>
    80002d36:	84aa                	mv	s1,a0
    80002d38:	451c                	lw	a5,8(a0)
    80002d3a:	00f05f63          	blez	a5,80002d58 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d3e:	0541                	addi	a0,a0,16
    80002d40:	00001097          	auipc	ra,0x1
    80002d44:	cb2080e7          	jalr	-846(ra) # 800039f2 <acquiresleep>
  if(ip->valid == 0){
    80002d48:	40bc                	lw	a5,64(s1)
    80002d4a:	cf99                	beqz	a5,80002d68 <ilock+0x40>
}
    80002d4c:	60e2                	ld	ra,24(sp)
    80002d4e:	6442                	ld	s0,16(sp)
    80002d50:	64a2                	ld	s1,8(sp)
    80002d52:	6902                	ld	s2,0(sp)
    80002d54:	6105                	addi	sp,sp,32
    80002d56:	8082                	ret
    panic("ilock");
    80002d58:	00006517          	auipc	a0,0x6
    80002d5c:	87050513          	addi	a0,a0,-1936 # 800085c8 <syscalls+0x1c8>
    80002d60:	00003097          	auipc	ra,0x3
    80002d64:	098080e7          	jalr	152(ra) # 80005df8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d68:	40dc                	lw	a5,4(s1)
    80002d6a:	0047d79b          	srliw	a5,a5,0x4
    80002d6e:	00015597          	auipc	a1,0x15
    80002d72:	a025a583          	lw	a1,-1534(a1) # 80017770 <sb+0x18>
    80002d76:	9dbd                	addw	a1,a1,a5
    80002d78:	4088                	lw	a0,0(s1)
    80002d7a:	fffff097          	auipc	ra,0xfffff
    80002d7e:	7ac080e7          	jalr	1964(ra) # 80002526 <bread>
    80002d82:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d84:	05850593          	addi	a1,a0,88
    80002d88:	40dc                	lw	a5,4(s1)
    80002d8a:	8bbd                	andi	a5,a5,15
    80002d8c:	079a                	slli	a5,a5,0x6
    80002d8e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d90:	00059783          	lh	a5,0(a1)
    80002d94:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d98:	00259783          	lh	a5,2(a1)
    80002d9c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002da0:	00459783          	lh	a5,4(a1)
    80002da4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002da8:	00659783          	lh	a5,6(a1)
    80002dac:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002db0:	459c                	lw	a5,8(a1)
    80002db2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002db4:	03400613          	li	a2,52
    80002db8:	05b1                	addi	a1,a1,12
    80002dba:	05048513          	addi	a0,s1,80
    80002dbe:	ffffd097          	auipc	ra,0xffffd
    80002dc2:	41a080e7          	jalr	1050(ra) # 800001d8 <memmove>
    brelse(bp);
    80002dc6:	854a                	mv	a0,s2
    80002dc8:	00000097          	auipc	ra,0x0
    80002dcc:	88e080e7          	jalr	-1906(ra) # 80002656 <brelse>
    ip->valid = 1;
    80002dd0:	4785                	li	a5,1
    80002dd2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002dd4:	04449783          	lh	a5,68(s1)
    80002dd8:	fbb5                	bnez	a5,80002d4c <ilock+0x24>
      panic("ilock: no type");
    80002dda:	00005517          	auipc	a0,0x5
    80002dde:	7f650513          	addi	a0,a0,2038 # 800085d0 <syscalls+0x1d0>
    80002de2:	00003097          	auipc	ra,0x3
    80002de6:	016080e7          	jalr	22(ra) # 80005df8 <panic>

0000000080002dea <iunlock>:
{
    80002dea:	1101                	addi	sp,sp,-32
    80002dec:	ec06                	sd	ra,24(sp)
    80002dee:	e822                	sd	s0,16(sp)
    80002df0:	e426                	sd	s1,8(sp)
    80002df2:	e04a                	sd	s2,0(sp)
    80002df4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002df6:	c905                	beqz	a0,80002e26 <iunlock+0x3c>
    80002df8:	84aa                	mv	s1,a0
    80002dfa:	01050913          	addi	s2,a0,16
    80002dfe:	854a                	mv	a0,s2
    80002e00:	00001097          	auipc	ra,0x1
    80002e04:	c8c080e7          	jalr	-884(ra) # 80003a8c <holdingsleep>
    80002e08:	cd19                	beqz	a0,80002e26 <iunlock+0x3c>
    80002e0a:	449c                	lw	a5,8(s1)
    80002e0c:	00f05d63          	blez	a5,80002e26 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e10:	854a                	mv	a0,s2
    80002e12:	00001097          	auipc	ra,0x1
    80002e16:	c36080e7          	jalr	-970(ra) # 80003a48 <releasesleep>
}
    80002e1a:	60e2                	ld	ra,24(sp)
    80002e1c:	6442                	ld	s0,16(sp)
    80002e1e:	64a2                	ld	s1,8(sp)
    80002e20:	6902                	ld	s2,0(sp)
    80002e22:	6105                	addi	sp,sp,32
    80002e24:	8082                	ret
    panic("iunlock");
    80002e26:	00005517          	auipc	a0,0x5
    80002e2a:	7ba50513          	addi	a0,a0,1978 # 800085e0 <syscalls+0x1e0>
    80002e2e:	00003097          	auipc	ra,0x3
    80002e32:	fca080e7          	jalr	-54(ra) # 80005df8 <panic>

0000000080002e36 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e36:	7179                	addi	sp,sp,-48
    80002e38:	f406                	sd	ra,40(sp)
    80002e3a:	f022                	sd	s0,32(sp)
    80002e3c:	ec26                	sd	s1,24(sp)
    80002e3e:	e84a                	sd	s2,16(sp)
    80002e40:	e44e                	sd	s3,8(sp)
    80002e42:	e052                	sd	s4,0(sp)
    80002e44:	1800                	addi	s0,sp,48
    80002e46:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e48:	05050493          	addi	s1,a0,80
    80002e4c:	08050913          	addi	s2,a0,128
    80002e50:	a021                	j	80002e58 <itrunc+0x22>
    80002e52:	0491                	addi	s1,s1,4
    80002e54:	01248d63          	beq	s1,s2,80002e6e <itrunc+0x38>
    if(ip->addrs[i]){
    80002e58:	408c                	lw	a1,0(s1)
    80002e5a:	dde5                	beqz	a1,80002e52 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e5c:	0009a503          	lw	a0,0(s3)
    80002e60:	00000097          	auipc	ra,0x0
    80002e64:	90c080e7          	jalr	-1780(ra) # 8000276c <bfree>
      ip->addrs[i] = 0;
    80002e68:	0004a023          	sw	zero,0(s1)
    80002e6c:	b7dd                	j	80002e52 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e6e:	0809a583          	lw	a1,128(s3)
    80002e72:	e185                	bnez	a1,80002e92 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e74:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e78:	854e                	mv	a0,s3
    80002e7a:	00000097          	auipc	ra,0x0
    80002e7e:	de4080e7          	jalr	-540(ra) # 80002c5e <iupdate>
}
    80002e82:	70a2                	ld	ra,40(sp)
    80002e84:	7402                	ld	s0,32(sp)
    80002e86:	64e2                	ld	s1,24(sp)
    80002e88:	6942                	ld	s2,16(sp)
    80002e8a:	69a2                	ld	s3,8(sp)
    80002e8c:	6a02                	ld	s4,0(sp)
    80002e8e:	6145                	addi	sp,sp,48
    80002e90:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e92:	0009a503          	lw	a0,0(s3)
    80002e96:	fffff097          	auipc	ra,0xfffff
    80002e9a:	690080e7          	jalr	1680(ra) # 80002526 <bread>
    80002e9e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ea0:	05850493          	addi	s1,a0,88
    80002ea4:	45850913          	addi	s2,a0,1112
    80002ea8:	a811                	j	80002ebc <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002eaa:	0009a503          	lw	a0,0(s3)
    80002eae:	00000097          	auipc	ra,0x0
    80002eb2:	8be080e7          	jalr	-1858(ra) # 8000276c <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002eb6:	0491                	addi	s1,s1,4
    80002eb8:	01248563          	beq	s1,s2,80002ec2 <itrunc+0x8c>
      if(a[j])
    80002ebc:	408c                	lw	a1,0(s1)
    80002ebe:	dde5                	beqz	a1,80002eb6 <itrunc+0x80>
    80002ec0:	b7ed                	j	80002eaa <itrunc+0x74>
    brelse(bp);
    80002ec2:	8552                	mv	a0,s4
    80002ec4:	fffff097          	auipc	ra,0xfffff
    80002ec8:	792080e7          	jalr	1938(ra) # 80002656 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ecc:	0809a583          	lw	a1,128(s3)
    80002ed0:	0009a503          	lw	a0,0(s3)
    80002ed4:	00000097          	auipc	ra,0x0
    80002ed8:	898080e7          	jalr	-1896(ra) # 8000276c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002edc:	0809a023          	sw	zero,128(s3)
    80002ee0:	bf51                	j	80002e74 <itrunc+0x3e>

0000000080002ee2 <iput>:
{
    80002ee2:	1101                	addi	sp,sp,-32
    80002ee4:	ec06                	sd	ra,24(sp)
    80002ee6:	e822                	sd	s0,16(sp)
    80002ee8:	e426                	sd	s1,8(sp)
    80002eea:	e04a                	sd	s2,0(sp)
    80002eec:	1000                	addi	s0,sp,32
    80002eee:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ef0:	00015517          	auipc	a0,0x15
    80002ef4:	88850513          	addi	a0,a0,-1912 # 80017778 <itable>
    80002ef8:	00003097          	auipc	ra,0x3
    80002efc:	44a080e7          	jalr	1098(ra) # 80006342 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f00:	4498                	lw	a4,8(s1)
    80002f02:	4785                	li	a5,1
    80002f04:	02f70363          	beq	a4,a5,80002f2a <iput+0x48>
  ip->ref--;
    80002f08:	449c                	lw	a5,8(s1)
    80002f0a:	37fd                	addiw	a5,a5,-1
    80002f0c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f0e:	00015517          	auipc	a0,0x15
    80002f12:	86a50513          	addi	a0,a0,-1942 # 80017778 <itable>
    80002f16:	00003097          	auipc	ra,0x3
    80002f1a:	4e0080e7          	jalr	1248(ra) # 800063f6 <release>
}
    80002f1e:	60e2                	ld	ra,24(sp)
    80002f20:	6442                	ld	s0,16(sp)
    80002f22:	64a2                	ld	s1,8(sp)
    80002f24:	6902                	ld	s2,0(sp)
    80002f26:	6105                	addi	sp,sp,32
    80002f28:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f2a:	40bc                	lw	a5,64(s1)
    80002f2c:	dff1                	beqz	a5,80002f08 <iput+0x26>
    80002f2e:	04a49783          	lh	a5,74(s1)
    80002f32:	fbf9                	bnez	a5,80002f08 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f34:	01048913          	addi	s2,s1,16
    80002f38:	854a                	mv	a0,s2
    80002f3a:	00001097          	auipc	ra,0x1
    80002f3e:	ab8080e7          	jalr	-1352(ra) # 800039f2 <acquiresleep>
    release(&itable.lock);
    80002f42:	00015517          	auipc	a0,0x15
    80002f46:	83650513          	addi	a0,a0,-1994 # 80017778 <itable>
    80002f4a:	00003097          	auipc	ra,0x3
    80002f4e:	4ac080e7          	jalr	1196(ra) # 800063f6 <release>
    itrunc(ip);
    80002f52:	8526                	mv	a0,s1
    80002f54:	00000097          	auipc	ra,0x0
    80002f58:	ee2080e7          	jalr	-286(ra) # 80002e36 <itrunc>
    ip->type = 0;
    80002f5c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f60:	8526                	mv	a0,s1
    80002f62:	00000097          	auipc	ra,0x0
    80002f66:	cfc080e7          	jalr	-772(ra) # 80002c5e <iupdate>
    ip->valid = 0;
    80002f6a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f6e:	854a                	mv	a0,s2
    80002f70:	00001097          	auipc	ra,0x1
    80002f74:	ad8080e7          	jalr	-1320(ra) # 80003a48 <releasesleep>
    acquire(&itable.lock);
    80002f78:	00015517          	auipc	a0,0x15
    80002f7c:	80050513          	addi	a0,a0,-2048 # 80017778 <itable>
    80002f80:	00003097          	auipc	ra,0x3
    80002f84:	3c2080e7          	jalr	962(ra) # 80006342 <acquire>
    80002f88:	b741                	j	80002f08 <iput+0x26>

0000000080002f8a <iunlockput>:
{
    80002f8a:	1101                	addi	sp,sp,-32
    80002f8c:	ec06                	sd	ra,24(sp)
    80002f8e:	e822                	sd	s0,16(sp)
    80002f90:	e426                	sd	s1,8(sp)
    80002f92:	1000                	addi	s0,sp,32
    80002f94:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f96:	00000097          	auipc	ra,0x0
    80002f9a:	e54080e7          	jalr	-428(ra) # 80002dea <iunlock>
  iput(ip);
    80002f9e:	8526                	mv	a0,s1
    80002fa0:	00000097          	auipc	ra,0x0
    80002fa4:	f42080e7          	jalr	-190(ra) # 80002ee2 <iput>
}
    80002fa8:	60e2                	ld	ra,24(sp)
    80002faa:	6442                	ld	s0,16(sp)
    80002fac:	64a2                	ld	s1,8(sp)
    80002fae:	6105                	addi	sp,sp,32
    80002fb0:	8082                	ret

0000000080002fb2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fb2:	1141                	addi	sp,sp,-16
    80002fb4:	e422                	sd	s0,8(sp)
    80002fb6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fb8:	411c                	lw	a5,0(a0)
    80002fba:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fbc:	415c                	lw	a5,4(a0)
    80002fbe:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fc0:	04451783          	lh	a5,68(a0)
    80002fc4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fc8:	04a51783          	lh	a5,74(a0)
    80002fcc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fd0:	04c56783          	lwu	a5,76(a0)
    80002fd4:	e99c                	sd	a5,16(a1)
}
    80002fd6:	6422                	ld	s0,8(sp)
    80002fd8:	0141                	addi	sp,sp,16
    80002fda:	8082                	ret

0000000080002fdc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fdc:	457c                	lw	a5,76(a0)
    80002fde:	0ed7e963          	bltu	a5,a3,800030d0 <readi+0xf4>
{
    80002fe2:	7159                	addi	sp,sp,-112
    80002fe4:	f486                	sd	ra,104(sp)
    80002fe6:	f0a2                	sd	s0,96(sp)
    80002fe8:	eca6                	sd	s1,88(sp)
    80002fea:	e8ca                	sd	s2,80(sp)
    80002fec:	e4ce                	sd	s3,72(sp)
    80002fee:	e0d2                	sd	s4,64(sp)
    80002ff0:	fc56                	sd	s5,56(sp)
    80002ff2:	f85a                	sd	s6,48(sp)
    80002ff4:	f45e                	sd	s7,40(sp)
    80002ff6:	f062                	sd	s8,32(sp)
    80002ff8:	ec66                	sd	s9,24(sp)
    80002ffa:	e86a                	sd	s10,16(sp)
    80002ffc:	e46e                	sd	s11,8(sp)
    80002ffe:	1880                	addi	s0,sp,112
    80003000:	8baa                	mv	s7,a0
    80003002:	8c2e                	mv	s8,a1
    80003004:	8ab2                	mv	s5,a2
    80003006:	84b6                	mv	s1,a3
    80003008:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000300a:	9f35                	addw	a4,a4,a3
    return 0;
    8000300c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000300e:	0ad76063          	bltu	a4,a3,800030ae <readi+0xd2>
  if(off + n > ip->size)
    80003012:	00e7f463          	bgeu	a5,a4,8000301a <readi+0x3e>
    n = ip->size - off;
    80003016:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000301a:	0a0b0963          	beqz	s6,800030cc <readi+0xf0>
    8000301e:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003020:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003024:	5cfd                	li	s9,-1
    80003026:	a82d                	j	80003060 <readi+0x84>
    80003028:	020a1d93          	slli	s11,s4,0x20
    8000302c:	020ddd93          	srli	s11,s11,0x20
    80003030:	05890613          	addi	a2,s2,88
    80003034:	86ee                	mv	a3,s11
    80003036:	963a                	add	a2,a2,a4
    80003038:	85d6                	mv	a1,s5
    8000303a:	8562                	mv	a0,s8
    8000303c:	fffff097          	auipc	ra,0xfffff
    80003040:	a4e080e7          	jalr	-1458(ra) # 80001a8a <either_copyout>
    80003044:	05950d63          	beq	a0,s9,8000309e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003048:	854a                	mv	a0,s2
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	60c080e7          	jalr	1548(ra) # 80002656 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003052:	013a09bb          	addw	s3,s4,s3
    80003056:	009a04bb          	addw	s1,s4,s1
    8000305a:	9aee                	add	s5,s5,s11
    8000305c:	0569f763          	bgeu	s3,s6,800030aa <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003060:	000ba903          	lw	s2,0(s7)
    80003064:	00a4d59b          	srliw	a1,s1,0xa
    80003068:	855e                	mv	a0,s7
    8000306a:	00000097          	auipc	ra,0x0
    8000306e:	8b0080e7          	jalr	-1872(ra) # 8000291a <bmap>
    80003072:	0005059b          	sext.w	a1,a0
    80003076:	854a                	mv	a0,s2
    80003078:	fffff097          	auipc	ra,0xfffff
    8000307c:	4ae080e7          	jalr	1198(ra) # 80002526 <bread>
    80003080:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003082:	3ff4f713          	andi	a4,s1,1023
    80003086:	40ed07bb          	subw	a5,s10,a4
    8000308a:	413b06bb          	subw	a3,s6,s3
    8000308e:	8a3e                	mv	s4,a5
    80003090:	2781                	sext.w	a5,a5
    80003092:	0006861b          	sext.w	a2,a3
    80003096:	f8f679e3          	bgeu	a2,a5,80003028 <readi+0x4c>
    8000309a:	8a36                	mv	s4,a3
    8000309c:	b771                	j	80003028 <readi+0x4c>
      brelse(bp);
    8000309e:	854a                	mv	a0,s2
    800030a0:	fffff097          	auipc	ra,0xfffff
    800030a4:	5b6080e7          	jalr	1462(ra) # 80002656 <brelse>
      tot = -1;
    800030a8:	59fd                	li	s3,-1
  }
  return tot;
    800030aa:	0009851b          	sext.w	a0,s3
}
    800030ae:	70a6                	ld	ra,104(sp)
    800030b0:	7406                	ld	s0,96(sp)
    800030b2:	64e6                	ld	s1,88(sp)
    800030b4:	6946                	ld	s2,80(sp)
    800030b6:	69a6                	ld	s3,72(sp)
    800030b8:	6a06                	ld	s4,64(sp)
    800030ba:	7ae2                	ld	s5,56(sp)
    800030bc:	7b42                	ld	s6,48(sp)
    800030be:	7ba2                	ld	s7,40(sp)
    800030c0:	7c02                	ld	s8,32(sp)
    800030c2:	6ce2                	ld	s9,24(sp)
    800030c4:	6d42                	ld	s10,16(sp)
    800030c6:	6da2                	ld	s11,8(sp)
    800030c8:	6165                	addi	sp,sp,112
    800030ca:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030cc:	89da                	mv	s3,s6
    800030ce:	bff1                	j	800030aa <readi+0xce>
    return 0;
    800030d0:	4501                	li	a0,0
}
    800030d2:	8082                	ret

00000000800030d4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030d4:	457c                	lw	a5,76(a0)
    800030d6:	10d7e863          	bltu	a5,a3,800031e6 <writei+0x112>
{
    800030da:	7159                	addi	sp,sp,-112
    800030dc:	f486                	sd	ra,104(sp)
    800030de:	f0a2                	sd	s0,96(sp)
    800030e0:	eca6                	sd	s1,88(sp)
    800030e2:	e8ca                	sd	s2,80(sp)
    800030e4:	e4ce                	sd	s3,72(sp)
    800030e6:	e0d2                	sd	s4,64(sp)
    800030e8:	fc56                	sd	s5,56(sp)
    800030ea:	f85a                	sd	s6,48(sp)
    800030ec:	f45e                	sd	s7,40(sp)
    800030ee:	f062                	sd	s8,32(sp)
    800030f0:	ec66                	sd	s9,24(sp)
    800030f2:	e86a                	sd	s10,16(sp)
    800030f4:	e46e                	sd	s11,8(sp)
    800030f6:	1880                	addi	s0,sp,112
    800030f8:	8b2a                	mv	s6,a0
    800030fa:	8c2e                	mv	s8,a1
    800030fc:	8ab2                	mv	s5,a2
    800030fe:	8936                	mv	s2,a3
    80003100:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003102:	00e687bb          	addw	a5,a3,a4
    80003106:	0ed7e263          	bltu	a5,a3,800031ea <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000310a:	00043737          	lui	a4,0x43
    8000310e:	0ef76063          	bltu	a4,a5,800031ee <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003112:	0c0b8863          	beqz	s7,800031e2 <writei+0x10e>
    80003116:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003118:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000311c:	5cfd                	li	s9,-1
    8000311e:	a091                	j	80003162 <writei+0x8e>
    80003120:	02099d93          	slli	s11,s3,0x20
    80003124:	020ddd93          	srli	s11,s11,0x20
    80003128:	05848513          	addi	a0,s1,88
    8000312c:	86ee                	mv	a3,s11
    8000312e:	8656                	mv	a2,s5
    80003130:	85e2                	mv	a1,s8
    80003132:	953a                	add	a0,a0,a4
    80003134:	fffff097          	auipc	ra,0xfffff
    80003138:	9ac080e7          	jalr	-1620(ra) # 80001ae0 <either_copyin>
    8000313c:	07950263          	beq	a0,s9,800031a0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003140:	8526                	mv	a0,s1
    80003142:	00000097          	auipc	ra,0x0
    80003146:	790080e7          	jalr	1936(ra) # 800038d2 <log_write>
    brelse(bp);
    8000314a:	8526                	mv	a0,s1
    8000314c:	fffff097          	auipc	ra,0xfffff
    80003150:	50a080e7          	jalr	1290(ra) # 80002656 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003154:	01498a3b          	addw	s4,s3,s4
    80003158:	0129893b          	addw	s2,s3,s2
    8000315c:	9aee                	add	s5,s5,s11
    8000315e:	057a7663          	bgeu	s4,s7,800031aa <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003162:	000b2483          	lw	s1,0(s6)
    80003166:	00a9559b          	srliw	a1,s2,0xa
    8000316a:	855a                	mv	a0,s6
    8000316c:	fffff097          	auipc	ra,0xfffff
    80003170:	7ae080e7          	jalr	1966(ra) # 8000291a <bmap>
    80003174:	0005059b          	sext.w	a1,a0
    80003178:	8526                	mv	a0,s1
    8000317a:	fffff097          	auipc	ra,0xfffff
    8000317e:	3ac080e7          	jalr	940(ra) # 80002526 <bread>
    80003182:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003184:	3ff97713          	andi	a4,s2,1023
    80003188:	40ed07bb          	subw	a5,s10,a4
    8000318c:	414b86bb          	subw	a3,s7,s4
    80003190:	89be                	mv	s3,a5
    80003192:	2781                	sext.w	a5,a5
    80003194:	0006861b          	sext.w	a2,a3
    80003198:	f8f674e3          	bgeu	a2,a5,80003120 <writei+0x4c>
    8000319c:	89b6                	mv	s3,a3
    8000319e:	b749                	j	80003120 <writei+0x4c>
      brelse(bp);
    800031a0:	8526                	mv	a0,s1
    800031a2:	fffff097          	auipc	ra,0xfffff
    800031a6:	4b4080e7          	jalr	1204(ra) # 80002656 <brelse>
  }

  if(off > ip->size)
    800031aa:	04cb2783          	lw	a5,76(s6)
    800031ae:	0127f463          	bgeu	a5,s2,800031b6 <writei+0xe2>
    ip->size = off;
    800031b2:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031b6:	855a                	mv	a0,s6
    800031b8:	00000097          	auipc	ra,0x0
    800031bc:	aa6080e7          	jalr	-1370(ra) # 80002c5e <iupdate>

  return tot;
    800031c0:	000a051b          	sext.w	a0,s4
}
    800031c4:	70a6                	ld	ra,104(sp)
    800031c6:	7406                	ld	s0,96(sp)
    800031c8:	64e6                	ld	s1,88(sp)
    800031ca:	6946                	ld	s2,80(sp)
    800031cc:	69a6                	ld	s3,72(sp)
    800031ce:	6a06                	ld	s4,64(sp)
    800031d0:	7ae2                	ld	s5,56(sp)
    800031d2:	7b42                	ld	s6,48(sp)
    800031d4:	7ba2                	ld	s7,40(sp)
    800031d6:	7c02                	ld	s8,32(sp)
    800031d8:	6ce2                	ld	s9,24(sp)
    800031da:	6d42                	ld	s10,16(sp)
    800031dc:	6da2                	ld	s11,8(sp)
    800031de:	6165                	addi	sp,sp,112
    800031e0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031e2:	8a5e                	mv	s4,s7
    800031e4:	bfc9                	j	800031b6 <writei+0xe2>
    return -1;
    800031e6:	557d                	li	a0,-1
}
    800031e8:	8082                	ret
    return -1;
    800031ea:	557d                	li	a0,-1
    800031ec:	bfe1                	j	800031c4 <writei+0xf0>
    return -1;
    800031ee:	557d                	li	a0,-1
    800031f0:	bfd1                	j	800031c4 <writei+0xf0>

00000000800031f2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031f2:	1141                	addi	sp,sp,-16
    800031f4:	e406                	sd	ra,8(sp)
    800031f6:	e022                	sd	s0,0(sp)
    800031f8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031fa:	4639                	li	a2,14
    800031fc:	ffffd097          	auipc	ra,0xffffd
    80003200:	054080e7          	jalr	84(ra) # 80000250 <strncmp>
}
    80003204:	60a2                	ld	ra,8(sp)
    80003206:	6402                	ld	s0,0(sp)
    80003208:	0141                	addi	sp,sp,16
    8000320a:	8082                	ret

000000008000320c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000320c:	7139                	addi	sp,sp,-64
    8000320e:	fc06                	sd	ra,56(sp)
    80003210:	f822                	sd	s0,48(sp)
    80003212:	f426                	sd	s1,40(sp)
    80003214:	f04a                	sd	s2,32(sp)
    80003216:	ec4e                	sd	s3,24(sp)
    80003218:	e852                	sd	s4,16(sp)
    8000321a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000321c:	04451703          	lh	a4,68(a0)
    80003220:	4785                	li	a5,1
    80003222:	00f71a63          	bne	a4,a5,80003236 <dirlookup+0x2a>
    80003226:	892a                	mv	s2,a0
    80003228:	89ae                	mv	s3,a1
    8000322a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000322c:	457c                	lw	a5,76(a0)
    8000322e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003230:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003232:	e79d                	bnez	a5,80003260 <dirlookup+0x54>
    80003234:	a8a5                	j	800032ac <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003236:	00005517          	auipc	a0,0x5
    8000323a:	3b250513          	addi	a0,a0,946 # 800085e8 <syscalls+0x1e8>
    8000323e:	00003097          	auipc	ra,0x3
    80003242:	bba080e7          	jalr	-1094(ra) # 80005df8 <panic>
      panic("dirlookup read");
    80003246:	00005517          	auipc	a0,0x5
    8000324a:	3ba50513          	addi	a0,a0,954 # 80008600 <syscalls+0x200>
    8000324e:	00003097          	auipc	ra,0x3
    80003252:	baa080e7          	jalr	-1110(ra) # 80005df8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003256:	24c1                	addiw	s1,s1,16
    80003258:	04c92783          	lw	a5,76(s2)
    8000325c:	04f4f763          	bgeu	s1,a5,800032aa <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003260:	4741                	li	a4,16
    80003262:	86a6                	mv	a3,s1
    80003264:	fc040613          	addi	a2,s0,-64
    80003268:	4581                	li	a1,0
    8000326a:	854a                	mv	a0,s2
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	d70080e7          	jalr	-656(ra) # 80002fdc <readi>
    80003274:	47c1                	li	a5,16
    80003276:	fcf518e3          	bne	a0,a5,80003246 <dirlookup+0x3a>
    if(de.inum == 0)
    8000327a:	fc045783          	lhu	a5,-64(s0)
    8000327e:	dfe1                	beqz	a5,80003256 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003280:	fc240593          	addi	a1,s0,-62
    80003284:	854e                	mv	a0,s3
    80003286:	00000097          	auipc	ra,0x0
    8000328a:	f6c080e7          	jalr	-148(ra) # 800031f2 <namecmp>
    8000328e:	f561                	bnez	a0,80003256 <dirlookup+0x4a>
      if(poff)
    80003290:	000a0463          	beqz	s4,80003298 <dirlookup+0x8c>
        *poff = off;
    80003294:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003298:	fc045583          	lhu	a1,-64(s0)
    8000329c:	00092503          	lw	a0,0(s2)
    800032a0:	fffff097          	auipc	ra,0xfffff
    800032a4:	754080e7          	jalr	1876(ra) # 800029f4 <iget>
    800032a8:	a011                	j	800032ac <dirlookup+0xa0>
  return 0;
    800032aa:	4501                	li	a0,0
}
    800032ac:	70e2                	ld	ra,56(sp)
    800032ae:	7442                	ld	s0,48(sp)
    800032b0:	74a2                	ld	s1,40(sp)
    800032b2:	7902                	ld	s2,32(sp)
    800032b4:	69e2                	ld	s3,24(sp)
    800032b6:	6a42                	ld	s4,16(sp)
    800032b8:	6121                	addi	sp,sp,64
    800032ba:	8082                	ret

00000000800032bc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032bc:	711d                	addi	sp,sp,-96
    800032be:	ec86                	sd	ra,88(sp)
    800032c0:	e8a2                	sd	s0,80(sp)
    800032c2:	e4a6                	sd	s1,72(sp)
    800032c4:	e0ca                	sd	s2,64(sp)
    800032c6:	fc4e                	sd	s3,56(sp)
    800032c8:	f852                	sd	s4,48(sp)
    800032ca:	f456                	sd	s5,40(sp)
    800032cc:	f05a                	sd	s6,32(sp)
    800032ce:	ec5e                	sd	s7,24(sp)
    800032d0:	e862                	sd	s8,16(sp)
    800032d2:	e466                	sd	s9,8(sp)
    800032d4:	1080                	addi	s0,sp,96
    800032d6:	84aa                	mv	s1,a0
    800032d8:	8b2e                	mv	s6,a1
    800032da:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032dc:	00054703          	lbu	a4,0(a0)
    800032e0:	02f00793          	li	a5,47
    800032e4:	02f70363          	beq	a4,a5,8000330a <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032e8:	ffffe097          	auipc	ra,0xffffe
    800032ec:	c94080e7          	jalr	-876(ra) # 80000f7c <myproc>
    800032f0:	15853503          	ld	a0,344(a0)
    800032f4:	00000097          	auipc	ra,0x0
    800032f8:	9f6080e7          	jalr	-1546(ra) # 80002cea <idup>
    800032fc:	89aa                	mv	s3,a0
  while(*path == '/')
    800032fe:	02f00913          	li	s2,47
  len = path - s;
    80003302:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003304:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003306:	4c05                	li	s8,1
    80003308:	a865                	j	800033c0 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000330a:	4585                	li	a1,1
    8000330c:	4505                	li	a0,1
    8000330e:	fffff097          	auipc	ra,0xfffff
    80003312:	6e6080e7          	jalr	1766(ra) # 800029f4 <iget>
    80003316:	89aa                	mv	s3,a0
    80003318:	b7dd                	j	800032fe <namex+0x42>
      iunlockput(ip);
    8000331a:	854e                	mv	a0,s3
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	c6e080e7          	jalr	-914(ra) # 80002f8a <iunlockput>
      return 0;
    80003324:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003326:	854e                	mv	a0,s3
    80003328:	60e6                	ld	ra,88(sp)
    8000332a:	6446                	ld	s0,80(sp)
    8000332c:	64a6                	ld	s1,72(sp)
    8000332e:	6906                	ld	s2,64(sp)
    80003330:	79e2                	ld	s3,56(sp)
    80003332:	7a42                	ld	s4,48(sp)
    80003334:	7aa2                	ld	s5,40(sp)
    80003336:	7b02                	ld	s6,32(sp)
    80003338:	6be2                	ld	s7,24(sp)
    8000333a:	6c42                	ld	s8,16(sp)
    8000333c:	6ca2                	ld	s9,8(sp)
    8000333e:	6125                	addi	sp,sp,96
    80003340:	8082                	ret
      iunlock(ip);
    80003342:	854e                	mv	a0,s3
    80003344:	00000097          	auipc	ra,0x0
    80003348:	aa6080e7          	jalr	-1370(ra) # 80002dea <iunlock>
      return ip;
    8000334c:	bfe9                	j	80003326 <namex+0x6a>
      iunlockput(ip);
    8000334e:	854e                	mv	a0,s3
    80003350:	00000097          	auipc	ra,0x0
    80003354:	c3a080e7          	jalr	-966(ra) # 80002f8a <iunlockput>
      return 0;
    80003358:	89d2                	mv	s3,s4
    8000335a:	b7f1                	j	80003326 <namex+0x6a>
  len = path - s;
    8000335c:	40b48633          	sub	a2,s1,a1
    80003360:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003364:	094cd463          	bge	s9,s4,800033ec <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003368:	4639                	li	a2,14
    8000336a:	8556                	mv	a0,s5
    8000336c:	ffffd097          	auipc	ra,0xffffd
    80003370:	e6c080e7          	jalr	-404(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003374:	0004c783          	lbu	a5,0(s1)
    80003378:	01279763          	bne	a5,s2,80003386 <namex+0xca>
    path++;
    8000337c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000337e:	0004c783          	lbu	a5,0(s1)
    80003382:	ff278de3          	beq	a5,s2,8000337c <namex+0xc0>
    ilock(ip);
    80003386:	854e                	mv	a0,s3
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	9a0080e7          	jalr	-1632(ra) # 80002d28 <ilock>
    if(ip->type != T_DIR){
    80003390:	04499783          	lh	a5,68(s3)
    80003394:	f98793e3          	bne	a5,s8,8000331a <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003398:	000b0563          	beqz	s6,800033a2 <namex+0xe6>
    8000339c:	0004c783          	lbu	a5,0(s1)
    800033a0:	d3cd                	beqz	a5,80003342 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033a2:	865e                	mv	a2,s7
    800033a4:	85d6                	mv	a1,s5
    800033a6:	854e                	mv	a0,s3
    800033a8:	00000097          	auipc	ra,0x0
    800033ac:	e64080e7          	jalr	-412(ra) # 8000320c <dirlookup>
    800033b0:	8a2a                	mv	s4,a0
    800033b2:	dd51                	beqz	a0,8000334e <namex+0x92>
    iunlockput(ip);
    800033b4:	854e                	mv	a0,s3
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	bd4080e7          	jalr	-1068(ra) # 80002f8a <iunlockput>
    ip = next;
    800033be:	89d2                	mv	s3,s4
  while(*path == '/')
    800033c0:	0004c783          	lbu	a5,0(s1)
    800033c4:	05279763          	bne	a5,s2,80003412 <namex+0x156>
    path++;
    800033c8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033ca:	0004c783          	lbu	a5,0(s1)
    800033ce:	ff278de3          	beq	a5,s2,800033c8 <namex+0x10c>
  if(*path == 0)
    800033d2:	c79d                	beqz	a5,80003400 <namex+0x144>
    path++;
    800033d4:	85a6                	mv	a1,s1
  len = path - s;
    800033d6:	8a5e                	mv	s4,s7
    800033d8:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033da:	01278963          	beq	a5,s2,800033ec <namex+0x130>
    800033de:	dfbd                	beqz	a5,8000335c <namex+0xa0>
    path++;
    800033e0:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800033e2:	0004c783          	lbu	a5,0(s1)
    800033e6:	ff279ce3          	bne	a5,s2,800033de <namex+0x122>
    800033ea:	bf8d                	j	8000335c <namex+0xa0>
    memmove(name, s, len);
    800033ec:	2601                	sext.w	a2,a2
    800033ee:	8556                	mv	a0,s5
    800033f0:	ffffd097          	auipc	ra,0xffffd
    800033f4:	de8080e7          	jalr	-536(ra) # 800001d8 <memmove>
    name[len] = 0;
    800033f8:	9a56                	add	s4,s4,s5
    800033fa:	000a0023          	sb	zero,0(s4)
    800033fe:	bf9d                	j	80003374 <namex+0xb8>
  if(nameiparent){
    80003400:	f20b03e3          	beqz	s6,80003326 <namex+0x6a>
    iput(ip);
    80003404:	854e                	mv	a0,s3
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	adc080e7          	jalr	-1316(ra) # 80002ee2 <iput>
    return 0;
    8000340e:	4981                	li	s3,0
    80003410:	bf19                	j	80003326 <namex+0x6a>
  if(*path == 0)
    80003412:	d7fd                	beqz	a5,80003400 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003414:	0004c783          	lbu	a5,0(s1)
    80003418:	85a6                	mv	a1,s1
    8000341a:	b7d1                	j	800033de <namex+0x122>

000000008000341c <dirlink>:
{
    8000341c:	7139                	addi	sp,sp,-64
    8000341e:	fc06                	sd	ra,56(sp)
    80003420:	f822                	sd	s0,48(sp)
    80003422:	f426                	sd	s1,40(sp)
    80003424:	f04a                	sd	s2,32(sp)
    80003426:	ec4e                	sd	s3,24(sp)
    80003428:	e852                	sd	s4,16(sp)
    8000342a:	0080                	addi	s0,sp,64
    8000342c:	892a                	mv	s2,a0
    8000342e:	8a2e                	mv	s4,a1
    80003430:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003432:	4601                	li	a2,0
    80003434:	00000097          	auipc	ra,0x0
    80003438:	dd8080e7          	jalr	-552(ra) # 8000320c <dirlookup>
    8000343c:	e93d                	bnez	a0,800034b2 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000343e:	04c92483          	lw	s1,76(s2)
    80003442:	c49d                	beqz	s1,80003470 <dirlink+0x54>
    80003444:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003446:	4741                	li	a4,16
    80003448:	86a6                	mv	a3,s1
    8000344a:	fc040613          	addi	a2,s0,-64
    8000344e:	4581                	li	a1,0
    80003450:	854a                	mv	a0,s2
    80003452:	00000097          	auipc	ra,0x0
    80003456:	b8a080e7          	jalr	-1142(ra) # 80002fdc <readi>
    8000345a:	47c1                	li	a5,16
    8000345c:	06f51163          	bne	a0,a5,800034be <dirlink+0xa2>
    if(de.inum == 0)
    80003460:	fc045783          	lhu	a5,-64(s0)
    80003464:	c791                	beqz	a5,80003470 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003466:	24c1                	addiw	s1,s1,16
    80003468:	04c92783          	lw	a5,76(s2)
    8000346c:	fcf4ede3          	bltu	s1,a5,80003446 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003470:	4639                	li	a2,14
    80003472:	85d2                	mv	a1,s4
    80003474:	fc240513          	addi	a0,s0,-62
    80003478:	ffffd097          	auipc	ra,0xffffd
    8000347c:	e14080e7          	jalr	-492(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003480:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003484:	4741                	li	a4,16
    80003486:	86a6                	mv	a3,s1
    80003488:	fc040613          	addi	a2,s0,-64
    8000348c:	4581                	li	a1,0
    8000348e:	854a                	mv	a0,s2
    80003490:	00000097          	auipc	ra,0x0
    80003494:	c44080e7          	jalr	-956(ra) # 800030d4 <writei>
    80003498:	872a                	mv	a4,a0
    8000349a:	47c1                	li	a5,16
  return 0;
    8000349c:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000349e:	02f71863          	bne	a4,a5,800034ce <dirlink+0xb2>
}
    800034a2:	70e2                	ld	ra,56(sp)
    800034a4:	7442                	ld	s0,48(sp)
    800034a6:	74a2                	ld	s1,40(sp)
    800034a8:	7902                	ld	s2,32(sp)
    800034aa:	69e2                	ld	s3,24(sp)
    800034ac:	6a42                	ld	s4,16(sp)
    800034ae:	6121                	addi	sp,sp,64
    800034b0:	8082                	ret
    iput(ip);
    800034b2:	00000097          	auipc	ra,0x0
    800034b6:	a30080e7          	jalr	-1488(ra) # 80002ee2 <iput>
    return -1;
    800034ba:	557d                	li	a0,-1
    800034bc:	b7dd                	j	800034a2 <dirlink+0x86>
      panic("dirlink read");
    800034be:	00005517          	auipc	a0,0x5
    800034c2:	15250513          	addi	a0,a0,338 # 80008610 <syscalls+0x210>
    800034c6:	00003097          	auipc	ra,0x3
    800034ca:	932080e7          	jalr	-1742(ra) # 80005df8 <panic>
    panic("dirlink");
    800034ce:	00005517          	auipc	a0,0x5
    800034d2:	25250513          	addi	a0,a0,594 # 80008720 <syscalls+0x320>
    800034d6:	00003097          	auipc	ra,0x3
    800034da:	922080e7          	jalr	-1758(ra) # 80005df8 <panic>

00000000800034de <namei>:

struct inode*
namei(char *path)
{
    800034de:	1101                	addi	sp,sp,-32
    800034e0:	ec06                	sd	ra,24(sp)
    800034e2:	e822                	sd	s0,16(sp)
    800034e4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034e6:	fe040613          	addi	a2,s0,-32
    800034ea:	4581                	li	a1,0
    800034ec:	00000097          	auipc	ra,0x0
    800034f0:	dd0080e7          	jalr	-560(ra) # 800032bc <namex>
}
    800034f4:	60e2                	ld	ra,24(sp)
    800034f6:	6442                	ld	s0,16(sp)
    800034f8:	6105                	addi	sp,sp,32
    800034fa:	8082                	ret

00000000800034fc <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034fc:	1141                	addi	sp,sp,-16
    800034fe:	e406                	sd	ra,8(sp)
    80003500:	e022                	sd	s0,0(sp)
    80003502:	0800                	addi	s0,sp,16
    80003504:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003506:	4585                	li	a1,1
    80003508:	00000097          	auipc	ra,0x0
    8000350c:	db4080e7          	jalr	-588(ra) # 800032bc <namex>
}
    80003510:	60a2                	ld	ra,8(sp)
    80003512:	6402                	ld	s0,0(sp)
    80003514:	0141                	addi	sp,sp,16
    80003516:	8082                	ret

0000000080003518 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003518:	1101                	addi	sp,sp,-32
    8000351a:	ec06                	sd	ra,24(sp)
    8000351c:	e822                	sd	s0,16(sp)
    8000351e:	e426                	sd	s1,8(sp)
    80003520:	e04a                	sd	s2,0(sp)
    80003522:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003524:	00016917          	auipc	s2,0x16
    80003528:	cfc90913          	addi	s2,s2,-772 # 80019220 <log>
    8000352c:	01892583          	lw	a1,24(s2)
    80003530:	02892503          	lw	a0,40(s2)
    80003534:	fffff097          	auipc	ra,0xfffff
    80003538:	ff2080e7          	jalr	-14(ra) # 80002526 <bread>
    8000353c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000353e:	02c92683          	lw	a3,44(s2)
    80003542:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003544:	02d05763          	blez	a3,80003572 <write_head+0x5a>
    80003548:	00016797          	auipc	a5,0x16
    8000354c:	d0878793          	addi	a5,a5,-760 # 80019250 <log+0x30>
    80003550:	05c50713          	addi	a4,a0,92
    80003554:	36fd                	addiw	a3,a3,-1
    80003556:	1682                	slli	a3,a3,0x20
    80003558:	9281                	srli	a3,a3,0x20
    8000355a:	068a                	slli	a3,a3,0x2
    8000355c:	00016617          	auipc	a2,0x16
    80003560:	cf860613          	addi	a2,a2,-776 # 80019254 <log+0x34>
    80003564:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003566:	4390                	lw	a2,0(a5)
    80003568:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000356a:	0791                	addi	a5,a5,4
    8000356c:	0711                	addi	a4,a4,4
    8000356e:	fed79ce3          	bne	a5,a3,80003566 <write_head+0x4e>
  }
  bwrite(buf);
    80003572:	8526                	mv	a0,s1
    80003574:	fffff097          	auipc	ra,0xfffff
    80003578:	0a4080e7          	jalr	164(ra) # 80002618 <bwrite>
  brelse(buf);
    8000357c:	8526                	mv	a0,s1
    8000357e:	fffff097          	auipc	ra,0xfffff
    80003582:	0d8080e7          	jalr	216(ra) # 80002656 <brelse>
}
    80003586:	60e2                	ld	ra,24(sp)
    80003588:	6442                	ld	s0,16(sp)
    8000358a:	64a2                	ld	s1,8(sp)
    8000358c:	6902                	ld	s2,0(sp)
    8000358e:	6105                	addi	sp,sp,32
    80003590:	8082                	ret

0000000080003592 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003592:	00016797          	auipc	a5,0x16
    80003596:	cba7a783          	lw	a5,-838(a5) # 8001924c <log+0x2c>
    8000359a:	0af05d63          	blez	a5,80003654 <install_trans+0xc2>
{
    8000359e:	7139                	addi	sp,sp,-64
    800035a0:	fc06                	sd	ra,56(sp)
    800035a2:	f822                	sd	s0,48(sp)
    800035a4:	f426                	sd	s1,40(sp)
    800035a6:	f04a                	sd	s2,32(sp)
    800035a8:	ec4e                	sd	s3,24(sp)
    800035aa:	e852                	sd	s4,16(sp)
    800035ac:	e456                	sd	s5,8(sp)
    800035ae:	e05a                	sd	s6,0(sp)
    800035b0:	0080                	addi	s0,sp,64
    800035b2:	8b2a                	mv	s6,a0
    800035b4:	00016a97          	auipc	s5,0x16
    800035b8:	c9ca8a93          	addi	s5,s5,-868 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035bc:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035be:	00016997          	auipc	s3,0x16
    800035c2:	c6298993          	addi	s3,s3,-926 # 80019220 <log>
    800035c6:	a035                	j	800035f2 <install_trans+0x60>
      bunpin(dbuf);
    800035c8:	8526                	mv	a0,s1
    800035ca:	fffff097          	auipc	ra,0xfffff
    800035ce:	166080e7          	jalr	358(ra) # 80002730 <bunpin>
    brelse(lbuf);
    800035d2:	854a                	mv	a0,s2
    800035d4:	fffff097          	auipc	ra,0xfffff
    800035d8:	082080e7          	jalr	130(ra) # 80002656 <brelse>
    brelse(dbuf);
    800035dc:	8526                	mv	a0,s1
    800035de:	fffff097          	auipc	ra,0xfffff
    800035e2:	078080e7          	jalr	120(ra) # 80002656 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035e6:	2a05                	addiw	s4,s4,1
    800035e8:	0a91                	addi	s5,s5,4
    800035ea:	02c9a783          	lw	a5,44(s3)
    800035ee:	04fa5963          	bge	s4,a5,80003640 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035f2:	0189a583          	lw	a1,24(s3)
    800035f6:	014585bb          	addw	a1,a1,s4
    800035fa:	2585                	addiw	a1,a1,1
    800035fc:	0289a503          	lw	a0,40(s3)
    80003600:	fffff097          	auipc	ra,0xfffff
    80003604:	f26080e7          	jalr	-218(ra) # 80002526 <bread>
    80003608:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000360a:	000aa583          	lw	a1,0(s5)
    8000360e:	0289a503          	lw	a0,40(s3)
    80003612:	fffff097          	auipc	ra,0xfffff
    80003616:	f14080e7          	jalr	-236(ra) # 80002526 <bread>
    8000361a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000361c:	40000613          	li	a2,1024
    80003620:	05890593          	addi	a1,s2,88
    80003624:	05850513          	addi	a0,a0,88
    80003628:	ffffd097          	auipc	ra,0xffffd
    8000362c:	bb0080e7          	jalr	-1104(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003630:	8526                	mv	a0,s1
    80003632:	fffff097          	auipc	ra,0xfffff
    80003636:	fe6080e7          	jalr	-26(ra) # 80002618 <bwrite>
    if(recovering == 0)
    8000363a:	f80b1ce3          	bnez	s6,800035d2 <install_trans+0x40>
    8000363e:	b769                	j	800035c8 <install_trans+0x36>
}
    80003640:	70e2                	ld	ra,56(sp)
    80003642:	7442                	ld	s0,48(sp)
    80003644:	74a2                	ld	s1,40(sp)
    80003646:	7902                	ld	s2,32(sp)
    80003648:	69e2                	ld	s3,24(sp)
    8000364a:	6a42                	ld	s4,16(sp)
    8000364c:	6aa2                	ld	s5,8(sp)
    8000364e:	6b02                	ld	s6,0(sp)
    80003650:	6121                	addi	sp,sp,64
    80003652:	8082                	ret
    80003654:	8082                	ret

0000000080003656 <initlog>:
{
    80003656:	7179                	addi	sp,sp,-48
    80003658:	f406                	sd	ra,40(sp)
    8000365a:	f022                	sd	s0,32(sp)
    8000365c:	ec26                	sd	s1,24(sp)
    8000365e:	e84a                	sd	s2,16(sp)
    80003660:	e44e                	sd	s3,8(sp)
    80003662:	1800                	addi	s0,sp,48
    80003664:	892a                	mv	s2,a0
    80003666:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003668:	00016497          	auipc	s1,0x16
    8000366c:	bb848493          	addi	s1,s1,-1096 # 80019220 <log>
    80003670:	00005597          	auipc	a1,0x5
    80003674:	fb058593          	addi	a1,a1,-80 # 80008620 <syscalls+0x220>
    80003678:	8526                	mv	a0,s1
    8000367a:	00003097          	auipc	ra,0x3
    8000367e:	c38080e7          	jalr	-968(ra) # 800062b2 <initlock>
  log.start = sb->logstart;
    80003682:	0149a583          	lw	a1,20(s3)
    80003686:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003688:	0109a783          	lw	a5,16(s3)
    8000368c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000368e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003692:	854a                	mv	a0,s2
    80003694:	fffff097          	auipc	ra,0xfffff
    80003698:	e92080e7          	jalr	-366(ra) # 80002526 <bread>
  log.lh.n = lh->n;
    8000369c:	4d3c                	lw	a5,88(a0)
    8000369e:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036a0:	02f05563          	blez	a5,800036ca <initlog+0x74>
    800036a4:	05c50713          	addi	a4,a0,92
    800036a8:	00016697          	auipc	a3,0x16
    800036ac:	ba868693          	addi	a3,a3,-1112 # 80019250 <log+0x30>
    800036b0:	37fd                	addiw	a5,a5,-1
    800036b2:	1782                	slli	a5,a5,0x20
    800036b4:	9381                	srli	a5,a5,0x20
    800036b6:	078a                	slli	a5,a5,0x2
    800036b8:	06050613          	addi	a2,a0,96
    800036bc:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036be:	4310                	lw	a2,0(a4)
    800036c0:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036c2:	0711                	addi	a4,a4,4
    800036c4:	0691                	addi	a3,a3,4
    800036c6:	fef71ce3          	bne	a4,a5,800036be <initlog+0x68>
  brelse(buf);
    800036ca:	fffff097          	auipc	ra,0xfffff
    800036ce:	f8c080e7          	jalr	-116(ra) # 80002656 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036d2:	4505                	li	a0,1
    800036d4:	00000097          	auipc	ra,0x0
    800036d8:	ebe080e7          	jalr	-322(ra) # 80003592 <install_trans>
  log.lh.n = 0;
    800036dc:	00016797          	auipc	a5,0x16
    800036e0:	b607a823          	sw	zero,-1168(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800036e4:	00000097          	auipc	ra,0x0
    800036e8:	e34080e7          	jalr	-460(ra) # 80003518 <write_head>
}
    800036ec:	70a2                	ld	ra,40(sp)
    800036ee:	7402                	ld	s0,32(sp)
    800036f0:	64e2                	ld	s1,24(sp)
    800036f2:	6942                	ld	s2,16(sp)
    800036f4:	69a2                	ld	s3,8(sp)
    800036f6:	6145                	addi	sp,sp,48
    800036f8:	8082                	ret

00000000800036fa <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036fa:	1101                	addi	sp,sp,-32
    800036fc:	ec06                	sd	ra,24(sp)
    800036fe:	e822                	sd	s0,16(sp)
    80003700:	e426                	sd	s1,8(sp)
    80003702:	e04a                	sd	s2,0(sp)
    80003704:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003706:	00016517          	auipc	a0,0x16
    8000370a:	b1a50513          	addi	a0,a0,-1254 # 80019220 <log>
    8000370e:	00003097          	auipc	ra,0x3
    80003712:	c34080e7          	jalr	-972(ra) # 80006342 <acquire>
  while(1){
    if(log.committing){
    80003716:	00016497          	auipc	s1,0x16
    8000371a:	b0a48493          	addi	s1,s1,-1270 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000371e:	4979                	li	s2,30
    80003720:	a039                	j	8000372e <begin_op+0x34>
      sleep(&log, &log.lock);
    80003722:	85a6                	mv	a1,s1
    80003724:	8526                	mv	a0,s1
    80003726:	ffffe097          	auipc	ra,0xffffe
    8000372a:	fc0080e7          	jalr	-64(ra) # 800016e6 <sleep>
    if(log.committing){
    8000372e:	50dc                	lw	a5,36(s1)
    80003730:	fbed                	bnez	a5,80003722 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003732:	509c                	lw	a5,32(s1)
    80003734:	0017871b          	addiw	a4,a5,1
    80003738:	0007069b          	sext.w	a3,a4
    8000373c:	0027179b          	slliw	a5,a4,0x2
    80003740:	9fb9                	addw	a5,a5,a4
    80003742:	0017979b          	slliw	a5,a5,0x1
    80003746:	54d8                	lw	a4,44(s1)
    80003748:	9fb9                	addw	a5,a5,a4
    8000374a:	00f95963          	bge	s2,a5,8000375c <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000374e:	85a6                	mv	a1,s1
    80003750:	8526                	mv	a0,s1
    80003752:	ffffe097          	auipc	ra,0xffffe
    80003756:	f94080e7          	jalr	-108(ra) # 800016e6 <sleep>
    8000375a:	bfd1                	j	8000372e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000375c:	00016517          	auipc	a0,0x16
    80003760:	ac450513          	addi	a0,a0,-1340 # 80019220 <log>
    80003764:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003766:	00003097          	auipc	ra,0x3
    8000376a:	c90080e7          	jalr	-880(ra) # 800063f6 <release>
      break;
    }
  }
}
    8000376e:	60e2                	ld	ra,24(sp)
    80003770:	6442                	ld	s0,16(sp)
    80003772:	64a2                	ld	s1,8(sp)
    80003774:	6902                	ld	s2,0(sp)
    80003776:	6105                	addi	sp,sp,32
    80003778:	8082                	ret

000000008000377a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000377a:	7139                	addi	sp,sp,-64
    8000377c:	fc06                	sd	ra,56(sp)
    8000377e:	f822                	sd	s0,48(sp)
    80003780:	f426                	sd	s1,40(sp)
    80003782:	f04a                	sd	s2,32(sp)
    80003784:	ec4e                	sd	s3,24(sp)
    80003786:	e852                	sd	s4,16(sp)
    80003788:	e456                	sd	s5,8(sp)
    8000378a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000378c:	00016497          	auipc	s1,0x16
    80003790:	a9448493          	addi	s1,s1,-1388 # 80019220 <log>
    80003794:	8526                	mv	a0,s1
    80003796:	00003097          	auipc	ra,0x3
    8000379a:	bac080e7          	jalr	-1108(ra) # 80006342 <acquire>
  log.outstanding -= 1;
    8000379e:	509c                	lw	a5,32(s1)
    800037a0:	37fd                	addiw	a5,a5,-1
    800037a2:	0007891b          	sext.w	s2,a5
    800037a6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037a8:	50dc                	lw	a5,36(s1)
    800037aa:	efb9                	bnez	a5,80003808 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037ac:	06091663          	bnez	s2,80003818 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800037b0:	00016497          	auipc	s1,0x16
    800037b4:	a7048493          	addi	s1,s1,-1424 # 80019220 <log>
    800037b8:	4785                	li	a5,1
    800037ba:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037bc:	8526                	mv	a0,s1
    800037be:	00003097          	auipc	ra,0x3
    800037c2:	c38080e7          	jalr	-968(ra) # 800063f6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037c6:	54dc                	lw	a5,44(s1)
    800037c8:	06f04763          	bgtz	a5,80003836 <end_op+0xbc>
    acquire(&log.lock);
    800037cc:	00016497          	auipc	s1,0x16
    800037d0:	a5448493          	addi	s1,s1,-1452 # 80019220 <log>
    800037d4:	8526                	mv	a0,s1
    800037d6:	00003097          	auipc	ra,0x3
    800037da:	b6c080e7          	jalr	-1172(ra) # 80006342 <acquire>
    log.committing = 0;
    800037de:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037e2:	8526                	mv	a0,s1
    800037e4:	ffffe097          	auipc	ra,0xffffe
    800037e8:	08e080e7          	jalr	142(ra) # 80001872 <wakeup>
    release(&log.lock);
    800037ec:	8526                	mv	a0,s1
    800037ee:	00003097          	auipc	ra,0x3
    800037f2:	c08080e7          	jalr	-1016(ra) # 800063f6 <release>
}
    800037f6:	70e2                	ld	ra,56(sp)
    800037f8:	7442                	ld	s0,48(sp)
    800037fa:	74a2                	ld	s1,40(sp)
    800037fc:	7902                	ld	s2,32(sp)
    800037fe:	69e2                	ld	s3,24(sp)
    80003800:	6a42                	ld	s4,16(sp)
    80003802:	6aa2                	ld	s5,8(sp)
    80003804:	6121                	addi	sp,sp,64
    80003806:	8082                	ret
    panic("log.committing");
    80003808:	00005517          	auipc	a0,0x5
    8000380c:	e2050513          	addi	a0,a0,-480 # 80008628 <syscalls+0x228>
    80003810:	00002097          	auipc	ra,0x2
    80003814:	5e8080e7          	jalr	1512(ra) # 80005df8 <panic>
    wakeup(&log);
    80003818:	00016497          	auipc	s1,0x16
    8000381c:	a0848493          	addi	s1,s1,-1528 # 80019220 <log>
    80003820:	8526                	mv	a0,s1
    80003822:	ffffe097          	auipc	ra,0xffffe
    80003826:	050080e7          	jalr	80(ra) # 80001872 <wakeup>
  release(&log.lock);
    8000382a:	8526                	mv	a0,s1
    8000382c:	00003097          	auipc	ra,0x3
    80003830:	bca080e7          	jalr	-1078(ra) # 800063f6 <release>
  if(do_commit){
    80003834:	b7c9                	j	800037f6 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003836:	00016a97          	auipc	s5,0x16
    8000383a:	a1aa8a93          	addi	s5,s5,-1510 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000383e:	00016a17          	auipc	s4,0x16
    80003842:	9e2a0a13          	addi	s4,s4,-1566 # 80019220 <log>
    80003846:	018a2583          	lw	a1,24(s4)
    8000384a:	012585bb          	addw	a1,a1,s2
    8000384e:	2585                	addiw	a1,a1,1
    80003850:	028a2503          	lw	a0,40(s4)
    80003854:	fffff097          	auipc	ra,0xfffff
    80003858:	cd2080e7          	jalr	-814(ra) # 80002526 <bread>
    8000385c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000385e:	000aa583          	lw	a1,0(s5)
    80003862:	028a2503          	lw	a0,40(s4)
    80003866:	fffff097          	auipc	ra,0xfffff
    8000386a:	cc0080e7          	jalr	-832(ra) # 80002526 <bread>
    8000386e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003870:	40000613          	li	a2,1024
    80003874:	05850593          	addi	a1,a0,88
    80003878:	05848513          	addi	a0,s1,88
    8000387c:	ffffd097          	auipc	ra,0xffffd
    80003880:	95c080e7          	jalr	-1700(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003884:	8526                	mv	a0,s1
    80003886:	fffff097          	auipc	ra,0xfffff
    8000388a:	d92080e7          	jalr	-622(ra) # 80002618 <bwrite>
    brelse(from);
    8000388e:	854e                	mv	a0,s3
    80003890:	fffff097          	auipc	ra,0xfffff
    80003894:	dc6080e7          	jalr	-570(ra) # 80002656 <brelse>
    brelse(to);
    80003898:	8526                	mv	a0,s1
    8000389a:	fffff097          	auipc	ra,0xfffff
    8000389e:	dbc080e7          	jalr	-580(ra) # 80002656 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038a2:	2905                	addiw	s2,s2,1
    800038a4:	0a91                	addi	s5,s5,4
    800038a6:	02ca2783          	lw	a5,44(s4)
    800038aa:	f8f94ee3          	blt	s2,a5,80003846 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038ae:	00000097          	auipc	ra,0x0
    800038b2:	c6a080e7          	jalr	-918(ra) # 80003518 <write_head>
    install_trans(0); // Now install writes to home locations
    800038b6:	4501                	li	a0,0
    800038b8:	00000097          	auipc	ra,0x0
    800038bc:	cda080e7          	jalr	-806(ra) # 80003592 <install_trans>
    log.lh.n = 0;
    800038c0:	00016797          	auipc	a5,0x16
    800038c4:	9807a623          	sw	zero,-1652(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038c8:	00000097          	auipc	ra,0x0
    800038cc:	c50080e7          	jalr	-944(ra) # 80003518 <write_head>
    800038d0:	bdf5                	j	800037cc <end_op+0x52>

00000000800038d2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038d2:	1101                	addi	sp,sp,-32
    800038d4:	ec06                	sd	ra,24(sp)
    800038d6:	e822                	sd	s0,16(sp)
    800038d8:	e426                	sd	s1,8(sp)
    800038da:	e04a                	sd	s2,0(sp)
    800038dc:	1000                	addi	s0,sp,32
    800038de:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038e0:	00016917          	auipc	s2,0x16
    800038e4:	94090913          	addi	s2,s2,-1728 # 80019220 <log>
    800038e8:	854a                	mv	a0,s2
    800038ea:	00003097          	auipc	ra,0x3
    800038ee:	a58080e7          	jalr	-1448(ra) # 80006342 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038f2:	02c92603          	lw	a2,44(s2)
    800038f6:	47f5                	li	a5,29
    800038f8:	06c7c563          	blt	a5,a2,80003962 <log_write+0x90>
    800038fc:	00016797          	auipc	a5,0x16
    80003900:	9407a783          	lw	a5,-1728(a5) # 8001923c <log+0x1c>
    80003904:	37fd                	addiw	a5,a5,-1
    80003906:	04f65e63          	bge	a2,a5,80003962 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000390a:	00016797          	auipc	a5,0x16
    8000390e:	9367a783          	lw	a5,-1738(a5) # 80019240 <log+0x20>
    80003912:	06f05063          	blez	a5,80003972 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003916:	4781                	li	a5,0
    80003918:	06c05563          	blez	a2,80003982 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000391c:	44cc                	lw	a1,12(s1)
    8000391e:	00016717          	auipc	a4,0x16
    80003922:	93270713          	addi	a4,a4,-1742 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003926:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003928:	4314                	lw	a3,0(a4)
    8000392a:	04b68c63          	beq	a3,a1,80003982 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000392e:	2785                	addiw	a5,a5,1
    80003930:	0711                	addi	a4,a4,4
    80003932:	fef61be3          	bne	a2,a5,80003928 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003936:	0621                	addi	a2,a2,8
    80003938:	060a                	slli	a2,a2,0x2
    8000393a:	00016797          	auipc	a5,0x16
    8000393e:	8e678793          	addi	a5,a5,-1818 # 80019220 <log>
    80003942:	963e                	add	a2,a2,a5
    80003944:	44dc                	lw	a5,12(s1)
    80003946:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003948:	8526                	mv	a0,s1
    8000394a:	fffff097          	auipc	ra,0xfffff
    8000394e:	daa080e7          	jalr	-598(ra) # 800026f4 <bpin>
    log.lh.n++;
    80003952:	00016717          	auipc	a4,0x16
    80003956:	8ce70713          	addi	a4,a4,-1842 # 80019220 <log>
    8000395a:	575c                	lw	a5,44(a4)
    8000395c:	2785                	addiw	a5,a5,1
    8000395e:	d75c                	sw	a5,44(a4)
    80003960:	a835                	j	8000399c <log_write+0xca>
    panic("too big a transaction");
    80003962:	00005517          	auipc	a0,0x5
    80003966:	cd650513          	addi	a0,a0,-810 # 80008638 <syscalls+0x238>
    8000396a:	00002097          	auipc	ra,0x2
    8000396e:	48e080e7          	jalr	1166(ra) # 80005df8 <panic>
    panic("log_write outside of trans");
    80003972:	00005517          	auipc	a0,0x5
    80003976:	cde50513          	addi	a0,a0,-802 # 80008650 <syscalls+0x250>
    8000397a:	00002097          	auipc	ra,0x2
    8000397e:	47e080e7          	jalr	1150(ra) # 80005df8 <panic>
  log.lh.block[i] = b->blockno;
    80003982:	00878713          	addi	a4,a5,8
    80003986:	00271693          	slli	a3,a4,0x2
    8000398a:	00016717          	auipc	a4,0x16
    8000398e:	89670713          	addi	a4,a4,-1898 # 80019220 <log>
    80003992:	9736                	add	a4,a4,a3
    80003994:	44d4                	lw	a3,12(s1)
    80003996:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003998:	faf608e3          	beq	a2,a5,80003948 <log_write+0x76>
  }
  release(&log.lock);
    8000399c:	00016517          	auipc	a0,0x16
    800039a0:	88450513          	addi	a0,a0,-1916 # 80019220 <log>
    800039a4:	00003097          	auipc	ra,0x3
    800039a8:	a52080e7          	jalr	-1454(ra) # 800063f6 <release>
}
    800039ac:	60e2                	ld	ra,24(sp)
    800039ae:	6442                	ld	s0,16(sp)
    800039b0:	64a2                	ld	s1,8(sp)
    800039b2:	6902                	ld	s2,0(sp)
    800039b4:	6105                	addi	sp,sp,32
    800039b6:	8082                	ret

00000000800039b8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039b8:	1101                	addi	sp,sp,-32
    800039ba:	ec06                	sd	ra,24(sp)
    800039bc:	e822                	sd	s0,16(sp)
    800039be:	e426                	sd	s1,8(sp)
    800039c0:	e04a                	sd	s2,0(sp)
    800039c2:	1000                	addi	s0,sp,32
    800039c4:	84aa                	mv	s1,a0
    800039c6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039c8:	00005597          	auipc	a1,0x5
    800039cc:	ca858593          	addi	a1,a1,-856 # 80008670 <syscalls+0x270>
    800039d0:	0521                	addi	a0,a0,8
    800039d2:	00003097          	auipc	ra,0x3
    800039d6:	8e0080e7          	jalr	-1824(ra) # 800062b2 <initlock>
  lk->name = name;
    800039da:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039de:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039e2:	0204a423          	sw	zero,40(s1)
}
    800039e6:	60e2                	ld	ra,24(sp)
    800039e8:	6442                	ld	s0,16(sp)
    800039ea:	64a2                	ld	s1,8(sp)
    800039ec:	6902                	ld	s2,0(sp)
    800039ee:	6105                	addi	sp,sp,32
    800039f0:	8082                	ret

00000000800039f2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039f2:	1101                	addi	sp,sp,-32
    800039f4:	ec06                	sd	ra,24(sp)
    800039f6:	e822                	sd	s0,16(sp)
    800039f8:	e426                	sd	s1,8(sp)
    800039fa:	e04a                	sd	s2,0(sp)
    800039fc:	1000                	addi	s0,sp,32
    800039fe:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a00:	00850913          	addi	s2,a0,8
    80003a04:	854a                	mv	a0,s2
    80003a06:	00003097          	auipc	ra,0x3
    80003a0a:	93c080e7          	jalr	-1732(ra) # 80006342 <acquire>
  while (lk->locked) {
    80003a0e:	409c                	lw	a5,0(s1)
    80003a10:	cb89                	beqz	a5,80003a22 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a12:	85ca                	mv	a1,s2
    80003a14:	8526                	mv	a0,s1
    80003a16:	ffffe097          	auipc	ra,0xffffe
    80003a1a:	cd0080e7          	jalr	-816(ra) # 800016e6 <sleep>
  while (lk->locked) {
    80003a1e:	409c                	lw	a5,0(s1)
    80003a20:	fbed                	bnez	a5,80003a12 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a22:	4785                	li	a5,1
    80003a24:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a26:	ffffd097          	auipc	ra,0xffffd
    80003a2a:	556080e7          	jalr	1366(ra) # 80000f7c <myproc>
    80003a2e:	591c                	lw	a5,48(a0)
    80003a30:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a32:	854a                	mv	a0,s2
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	9c2080e7          	jalr	-1598(ra) # 800063f6 <release>
}
    80003a3c:	60e2                	ld	ra,24(sp)
    80003a3e:	6442                	ld	s0,16(sp)
    80003a40:	64a2                	ld	s1,8(sp)
    80003a42:	6902                	ld	s2,0(sp)
    80003a44:	6105                	addi	sp,sp,32
    80003a46:	8082                	ret

0000000080003a48 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a48:	1101                	addi	sp,sp,-32
    80003a4a:	ec06                	sd	ra,24(sp)
    80003a4c:	e822                	sd	s0,16(sp)
    80003a4e:	e426                	sd	s1,8(sp)
    80003a50:	e04a                	sd	s2,0(sp)
    80003a52:	1000                	addi	s0,sp,32
    80003a54:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a56:	00850913          	addi	s2,a0,8
    80003a5a:	854a                	mv	a0,s2
    80003a5c:	00003097          	auipc	ra,0x3
    80003a60:	8e6080e7          	jalr	-1818(ra) # 80006342 <acquire>
  lk->locked = 0;
    80003a64:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a68:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a6c:	8526                	mv	a0,s1
    80003a6e:	ffffe097          	auipc	ra,0xffffe
    80003a72:	e04080e7          	jalr	-508(ra) # 80001872 <wakeup>
  release(&lk->lk);
    80003a76:	854a                	mv	a0,s2
    80003a78:	00003097          	auipc	ra,0x3
    80003a7c:	97e080e7          	jalr	-1666(ra) # 800063f6 <release>
}
    80003a80:	60e2                	ld	ra,24(sp)
    80003a82:	6442                	ld	s0,16(sp)
    80003a84:	64a2                	ld	s1,8(sp)
    80003a86:	6902                	ld	s2,0(sp)
    80003a88:	6105                	addi	sp,sp,32
    80003a8a:	8082                	ret

0000000080003a8c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a8c:	7179                	addi	sp,sp,-48
    80003a8e:	f406                	sd	ra,40(sp)
    80003a90:	f022                	sd	s0,32(sp)
    80003a92:	ec26                	sd	s1,24(sp)
    80003a94:	e84a                	sd	s2,16(sp)
    80003a96:	e44e                	sd	s3,8(sp)
    80003a98:	1800                	addi	s0,sp,48
    80003a9a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a9c:	00850913          	addi	s2,a0,8
    80003aa0:	854a                	mv	a0,s2
    80003aa2:	00003097          	auipc	ra,0x3
    80003aa6:	8a0080e7          	jalr	-1888(ra) # 80006342 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aaa:	409c                	lw	a5,0(s1)
    80003aac:	ef99                	bnez	a5,80003aca <holdingsleep+0x3e>
    80003aae:	4481                	li	s1,0
  release(&lk->lk);
    80003ab0:	854a                	mv	a0,s2
    80003ab2:	00003097          	auipc	ra,0x3
    80003ab6:	944080e7          	jalr	-1724(ra) # 800063f6 <release>
  return r;
}
    80003aba:	8526                	mv	a0,s1
    80003abc:	70a2                	ld	ra,40(sp)
    80003abe:	7402                	ld	s0,32(sp)
    80003ac0:	64e2                	ld	s1,24(sp)
    80003ac2:	6942                	ld	s2,16(sp)
    80003ac4:	69a2                	ld	s3,8(sp)
    80003ac6:	6145                	addi	sp,sp,48
    80003ac8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aca:	0284a983          	lw	s3,40(s1)
    80003ace:	ffffd097          	auipc	ra,0xffffd
    80003ad2:	4ae080e7          	jalr	1198(ra) # 80000f7c <myproc>
    80003ad6:	5904                	lw	s1,48(a0)
    80003ad8:	413484b3          	sub	s1,s1,s3
    80003adc:	0014b493          	seqz	s1,s1
    80003ae0:	bfc1                	j	80003ab0 <holdingsleep+0x24>

0000000080003ae2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ae2:	1141                	addi	sp,sp,-16
    80003ae4:	e406                	sd	ra,8(sp)
    80003ae6:	e022                	sd	s0,0(sp)
    80003ae8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003aea:	00005597          	auipc	a1,0x5
    80003aee:	b9658593          	addi	a1,a1,-1130 # 80008680 <syscalls+0x280>
    80003af2:	00016517          	auipc	a0,0x16
    80003af6:	87650513          	addi	a0,a0,-1930 # 80019368 <ftable>
    80003afa:	00002097          	auipc	ra,0x2
    80003afe:	7b8080e7          	jalr	1976(ra) # 800062b2 <initlock>
}
    80003b02:	60a2                	ld	ra,8(sp)
    80003b04:	6402                	ld	s0,0(sp)
    80003b06:	0141                	addi	sp,sp,16
    80003b08:	8082                	ret

0000000080003b0a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b0a:	1101                	addi	sp,sp,-32
    80003b0c:	ec06                	sd	ra,24(sp)
    80003b0e:	e822                	sd	s0,16(sp)
    80003b10:	e426                	sd	s1,8(sp)
    80003b12:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b14:	00016517          	auipc	a0,0x16
    80003b18:	85450513          	addi	a0,a0,-1964 # 80019368 <ftable>
    80003b1c:	00003097          	auipc	ra,0x3
    80003b20:	826080e7          	jalr	-2010(ra) # 80006342 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b24:	00016497          	auipc	s1,0x16
    80003b28:	85c48493          	addi	s1,s1,-1956 # 80019380 <ftable+0x18>
    80003b2c:	00016717          	auipc	a4,0x16
    80003b30:	7f470713          	addi	a4,a4,2036 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b34:	40dc                	lw	a5,4(s1)
    80003b36:	cf99                	beqz	a5,80003b54 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b38:	02848493          	addi	s1,s1,40
    80003b3c:	fee49ce3          	bne	s1,a4,80003b34 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b40:	00016517          	auipc	a0,0x16
    80003b44:	82850513          	addi	a0,a0,-2008 # 80019368 <ftable>
    80003b48:	00003097          	auipc	ra,0x3
    80003b4c:	8ae080e7          	jalr	-1874(ra) # 800063f6 <release>
  return 0;
    80003b50:	4481                	li	s1,0
    80003b52:	a819                	j	80003b68 <filealloc+0x5e>
      f->ref = 1;
    80003b54:	4785                	li	a5,1
    80003b56:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b58:	00016517          	auipc	a0,0x16
    80003b5c:	81050513          	addi	a0,a0,-2032 # 80019368 <ftable>
    80003b60:	00003097          	auipc	ra,0x3
    80003b64:	896080e7          	jalr	-1898(ra) # 800063f6 <release>
}
    80003b68:	8526                	mv	a0,s1
    80003b6a:	60e2                	ld	ra,24(sp)
    80003b6c:	6442                	ld	s0,16(sp)
    80003b6e:	64a2                	ld	s1,8(sp)
    80003b70:	6105                	addi	sp,sp,32
    80003b72:	8082                	ret

0000000080003b74 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b74:	1101                	addi	sp,sp,-32
    80003b76:	ec06                	sd	ra,24(sp)
    80003b78:	e822                	sd	s0,16(sp)
    80003b7a:	e426                	sd	s1,8(sp)
    80003b7c:	1000                	addi	s0,sp,32
    80003b7e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b80:	00015517          	auipc	a0,0x15
    80003b84:	7e850513          	addi	a0,a0,2024 # 80019368 <ftable>
    80003b88:	00002097          	auipc	ra,0x2
    80003b8c:	7ba080e7          	jalr	1978(ra) # 80006342 <acquire>
  if(f->ref < 1)
    80003b90:	40dc                	lw	a5,4(s1)
    80003b92:	02f05263          	blez	a5,80003bb6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b96:	2785                	addiw	a5,a5,1
    80003b98:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b9a:	00015517          	auipc	a0,0x15
    80003b9e:	7ce50513          	addi	a0,a0,1998 # 80019368 <ftable>
    80003ba2:	00003097          	auipc	ra,0x3
    80003ba6:	854080e7          	jalr	-1964(ra) # 800063f6 <release>
  return f;
}
    80003baa:	8526                	mv	a0,s1
    80003bac:	60e2                	ld	ra,24(sp)
    80003bae:	6442                	ld	s0,16(sp)
    80003bb0:	64a2                	ld	s1,8(sp)
    80003bb2:	6105                	addi	sp,sp,32
    80003bb4:	8082                	ret
    panic("filedup");
    80003bb6:	00005517          	auipc	a0,0x5
    80003bba:	ad250513          	addi	a0,a0,-1326 # 80008688 <syscalls+0x288>
    80003bbe:	00002097          	auipc	ra,0x2
    80003bc2:	23a080e7          	jalr	570(ra) # 80005df8 <panic>

0000000080003bc6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bc6:	7139                	addi	sp,sp,-64
    80003bc8:	fc06                	sd	ra,56(sp)
    80003bca:	f822                	sd	s0,48(sp)
    80003bcc:	f426                	sd	s1,40(sp)
    80003bce:	f04a                	sd	s2,32(sp)
    80003bd0:	ec4e                	sd	s3,24(sp)
    80003bd2:	e852                	sd	s4,16(sp)
    80003bd4:	e456                	sd	s5,8(sp)
    80003bd6:	0080                	addi	s0,sp,64
    80003bd8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bda:	00015517          	auipc	a0,0x15
    80003bde:	78e50513          	addi	a0,a0,1934 # 80019368 <ftable>
    80003be2:	00002097          	auipc	ra,0x2
    80003be6:	760080e7          	jalr	1888(ra) # 80006342 <acquire>
  if(f->ref < 1)
    80003bea:	40dc                	lw	a5,4(s1)
    80003bec:	06f05163          	blez	a5,80003c4e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bf0:	37fd                	addiw	a5,a5,-1
    80003bf2:	0007871b          	sext.w	a4,a5
    80003bf6:	c0dc                	sw	a5,4(s1)
    80003bf8:	06e04363          	bgtz	a4,80003c5e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bfc:	0004a903          	lw	s2,0(s1)
    80003c00:	0094ca83          	lbu	s5,9(s1)
    80003c04:	0104ba03          	ld	s4,16(s1)
    80003c08:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c0c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c10:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c14:	00015517          	auipc	a0,0x15
    80003c18:	75450513          	addi	a0,a0,1876 # 80019368 <ftable>
    80003c1c:	00002097          	auipc	ra,0x2
    80003c20:	7da080e7          	jalr	2010(ra) # 800063f6 <release>

  if(ff.type == FD_PIPE){
    80003c24:	4785                	li	a5,1
    80003c26:	04f90d63          	beq	s2,a5,80003c80 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c2a:	3979                	addiw	s2,s2,-2
    80003c2c:	4785                	li	a5,1
    80003c2e:	0527e063          	bltu	a5,s2,80003c6e <fileclose+0xa8>
    begin_op();
    80003c32:	00000097          	auipc	ra,0x0
    80003c36:	ac8080e7          	jalr	-1336(ra) # 800036fa <begin_op>
    iput(ff.ip);
    80003c3a:	854e                	mv	a0,s3
    80003c3c:	fffff097          	auipc	ra,0xfffff
    80003c40:	2a6080e7          	jalr	678(ra) # 80002ee2 <iput>
    end_op();
    80003c44:	00000097          	auipc	ra,0x0
    80003c48:	b36080e7          	jalr	-1226(ra) # 8000377a <end_op>
    80003c4c:	a00d                	j	80003c6e <fileclose+0xa8>
    panic("fileclose");
    80003c4e:	00005517          	auipc	a0,0x5
    80003c52:	a4250513          	addi	a0,a0,-1470 # 80008690 <syscalls+0x290>
    80003c56:	00002097          	auipc	ra,0x2
    80003c5a:	1a2080e7          	jalr	418(ra) # 80005df8 <panic>
    release(&ftable.lock);
    80003c5e:	00015517          	auipc	a0,0x15
    80003c62:	70a50513          	addi	a0,a0,1802 # 80019368 <ftable>
    80003c66:	00002097          	auipc	ra,0x2
    80003c6a:	790080e7          	jalr	1936(ra) # 800063f6 <release>
  }
}
    80003c6e:	70e2                	ld	ra,56(sp)
    80003c70:	7442                	ld	s0,48(sp)
    80003c72:	74a2                	ld	s1,40(sp)
    80003c74:	7902                	ld	s2,32(sp)
    80003c76:	69e2                	ld	s3,24(sp)
    80003c78:	6a42                	ld	s4,16(sp)
    80003c7a:	6aa2                	ld	s5,8(sp)
    80003c7c:	6121                	addi	sp,sp,64
    80003c7e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c80:	85d6                	mv	a1,s5
    80003c82:	8552                	mv	a0,s4
    80003c84:	00000097          	auipc	ra,0x0
    80003c88:	34c080e7          	jalr	844(ra) # 80003fd0 <pipeclose>
    80003c8c:	b7cd                	j	80003c6e <fileclose+0xa8>

0000000080003c8e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c8e:	715d                	addi	sp,sp,-80
    80003c90:	e486                	sd	ra,72(sp)
    80003c92:	e0a2                	sd	s0,64(sp)
    80003c94:	fc26                	sd	s1,56(sp)
    80003c96:	f84a                	sd	s2,48(sp)
    80003c98:	f44e                	sd	s3,40(sp)
    80003c9a:	0880                	addi	s0,sp,80
    80003c9c:	84aa                	mv	s1,a0
    80003c9e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003ca0:	ffffd097          	auipc	ra,0xffffd
    80003ca4:	2dc080e7          	jalr	732(ra) # 80000f7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ca8:	409c                	lw	a5,0(s1)
    80003caa:	37f9                	addiw	a5,a5,-2
    80003cac:	4705                	li	a4,1
    80003cae:	04f76763          	bltu	a4,a5,80003cfc <filestat+0x6e>
    80003cb2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cb4:	6c88                	ld	a0,24(s1)
    80003cb6:	fffff097          	auipc	ra,0xfffff
    80003cba:	072080e7          	jalr	114(ra) # 80002d28 <ilock>
    stati(f->ip, &st);
    80003cbe:	fb840593          	addi	a1,s0,-72
    80003cc2:	6c88                	ld	a0,24(s1)
    80003cc4:	fffff097          	auipc	ra,0xfffff
    80003cc8:	2ee080e7          	jalr	750(ra) # 80002fb2 <stati>
    iunlock(f->ip);
    80003ccc:	6c88                	ld	a0,24(s1)
    80003cce:	fffff097          	auipc	ra,0xfffff
    80003cd2:	11c080e7          	jalr	284(ra) # 80002dea <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cd6:	46e1                	li	a3,24
    80003cd8:	fb840613          	addi	a2,s0,-72
    80003cdc:	85ce                	mv	a1,s3
    80003cde:	05093503          	ld	a0,80(s2)
    80003ce2:	ffffd097          	auipc	ra,0xffffd
    80003ce6:	e28080e7          	jalr	-472(ra) # 80000b0a <copyout>
    80003cea:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cee:	60a6                	ld	ra,72(sp)
    80003cf0:	6406                	ld	s0,64(sp)
    80003cf2:	74e2                	ld	s1,56(sp)
    80003cf4:	7942                	ld	s2,48(sp)
    80003cf6:	79a2                	ld	s3,40(sp)
    80003cf8:	6161                	addi	sp,sp,80
    80003cfa:	8082                	ret
  return -1;
    80003cfc:	557d                	li	a0,-1
    80003cfe:	bfc5                	j	80003cee <filestat+0x60>

0000000080003d00 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d00:	7179                	addi	sp,sp,-48
    80003d02:	f406                	sd	ra,40(sp)
    80003d04:	f022                	sd	s0,32(sp)
    80003d06:	ec26                	sd	s1,24(sp)
    80003d08:	e84a                	sd	s2,16(sp)
    80003d0a:	e44e                	sd	s3,8(sp)
    80003d0c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d0e:	00854783          	lbu	a5,8(a0)
    80003d12:	c3d5                	beqz	a5,80003db6 <fileread+0xb6>
    80003d14:	84aa                	mv	s1,a0
    80003d16:	89ae                	mv	s3,a1
    80003d18:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d1a:	411c                	lw	a5,0(a0)
    80003d1c:	4705                	li	a4,1
    80003d1e:	04e78963          	beq	a5,a4,80003d70 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d22:	470d                	li	a4,3
    80003d24:	04e78d63          	beq	a5,a4,80003d7e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d28:	4709                	li	a4,2
    80003d2a:	06e79e63          	bne	a5,a4,80003da6 <fileread+0xa6>
    ilock(f->ip);
    80003d2e:	6d08                	ld	a0,24(a0)
    80003d30:	fffff097          	auipc	ra,0xfffff
    80003d34:	ff8080e7          	jalr	-8(ra) # 80002d28 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d38:	874a                	mv	a4,s2
    80003d3a:	5094                	lw	a3,32(s1)
    80003d3c:	864e                	mv	a2,s3
    80003d3e:	4585                	li	a1,1
    80003d40:	6c88                	ld	a0,24(s1)
    80003d42:	fffff097          	auipc	ra,0xfffff
    80003d46:	29a080e7          	jalr	666(ra) # 80002fdc <readi>
    80003d4a:	892a                	mv	s2,a0
    80003d4c:	00a05563          	blez	a0,80003d56 <fileread+0x56>
      f->off += r;
    80003d50:	509c                	lw	a5,32(s1)
    80003d52:	9fa9                	addw	a5,a5,a0
    80003d54:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d56:	6c88                	ld	a0,24(s1)
    80003d58:	fffff097          	auipc	ra,0xfffff
    80003d5c:	092080e7          	jalr	146(ra) # 80002dea <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d60:	854a                	mv	a0,s2
    80003d62:	70a2                	ld	ra,40(sp)
    80003d64:	7402                	ld	s0,32(sp)
    80003d66:	64e2                	ld	s1,24(sp)
    80003d68:	6942                	ld	s2,16(sp)
    80003d6a:	69a2                	ld	s3,8(sp)
    80003d6c:	6145                	addi	sp,sp,48
    80003d6e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d70:	6908                	ld	a0,16(a0)
    80003d72:	00000097          	auipc	ra,0x0
    80003d76:	3c8080e7          	jalr	968(ra) # 8000413a <piperead>
    80003d7a:	892a                	mv	s2,a0
    80003d7c:	b7d5                	j	80003d60 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d7e:	02451783          	lh	a5,36(a0)
    80003d82:	03079693          	slli	a3,a5,0x30
    80003d86:	92c1                	srli	a3,a3,0x30
    80003d88:	4725                	li	a4,9
    80003d8a:	02d76863          	bltu	a4,a3,80003dba <fileread+0xba>
    80003d8e:	0792                	slli	a5,a5,0x4
    80003d90:	00015717          	auipc	a4,0x15
    80003d94:	53870713          	addi	a4,a4,1336 # 800192c8 <devsw>
    80003d98:	97ba                	add	a5,a5,a4
    80003d9a:	639c                	ld	a5,0(a5)
    80003d9c:	c38d                	beqz	a5,80003dbe <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d9e:	4505                	li	a0,1
    80003da0:	9782                	jalr	a5
    80003da2:	892a                	mv	s2,a0
    80003da4:	bf75                	j	80003d60 <fileread+0x60>
    panic("fileread");
    80003da6:	00005517          	auipc	a0,0x5
    80003daa:	8fa50513          	addi	a0,a0,-1798 # 800086a0 <syscalls+0x2a0>
    80003dae:	00002097          	auipc	ra,0x2
    80003db2:	04a080e7          	jalr	74(ra) # 80005df8 <panic>
    return -1;
    80003db6:	597d                	li	s2,-1
    80003db8:	b765                	j	80003d60 <fileread+0x60>
      return -1;
    80003dba:	597d                	li	s2,-1
    80003dbc:	b755                	j	80003d60 <fileread+0x60>
    80003dbe:	597d                	li	s2,-1
    80003dc0:	b745                	j	80003d60 <fileread+0x60>

0000000080003dc2 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dc2:	715d                	addi	sp,sp,-80
    80003dc4:	e486                	sd	ra,72(sp)
    80003dc6:	e0a2                	sd	s0,64(sp)
    80003dc8:	fc26                	sd	s1,56(sp)
    80003dca:	f84a                	sd	s2,48(sp)
    80003dcc:	f44e                	sd	s3,40(sp)
    80003dce:	f052                	sd	s4,32(sp)
    80003dd0:	ec56                	sd	s5,24(sp)
    80003dd2:	e85a                	sd	s6,16(sp)
    80003dd4:	e45e                	sd	s7,8(sp)
    80003dd6:	e062                	sd	s8,0(sp)
    80003dd8:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dda:	00954783          	lbu	a5,9(a0)
    80003dde:	10078663          	beqz	a5,80003eea <filewrite+0x128>
    80003de2:	892a                	mv	s2,a0
    80003de4:	8aae                	mv	s5,a1
    80003de6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003de8:	411c                	lw	a5,0(a0)
    80003dea:	4705                	li	a4,1
    80003dec:	02e78263          	beq	a5,a4,80003e10 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003df0:	470d                	li	a4,3
    80003df2:	02e78663          	beq	a5,a4,80003e1e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003df6:	4709                	li	a4,2
    80003df8:	0ee79163          	bne	a5,a4,80003eda <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dfc:	0ac05d63          	blez	a2,80003eb6 <filewrite+0xf4>
    int i = 0;
    80003e00:	4981                	li	s3,0
    80003e02:	6b05                	lui	s6,0x1
    80003e04:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e08:	6b85                	lui	s7,0x1
    80003e0a:	c00b8b9b          	addiw	s7,s7,-1024
    80003e0e:	a861                	j	80003ea6 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e10:	6908                	ld	a0,16(a0)
    80003e12:	00000097          	auipc	ra,0x0
    80003e16:	22e080e7          	jalr	558(ra) # 80004040 <pipewrite>
    80003e1a:	8a2a                	mv	s4,a0
    80003e1c:	a045                	j	80003ebc <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e1e:	02451783          	lh	a5,36(a0)
    80003e22:	03079693          	slli	a3,a5,0x30
    80003e26:	92c1                	srli	a3,a3,0x30
    80003e28:	4725                	li	a4,9
    80003e2a:	0cd76263          	bltu	a4,a3,80003eee <filewrite+0x12c>
    80003e2e:	0792                	slli	a5,a5,0x4
    80003e30:	00015717          	auipc	a4,0x15
    80003e34:	49870713          	addi	a4,a4,1176 # 800192c8 <devsw>
    80003e38:	97ba                	add	a5,a5,a4
    80003e3a:	679c                	ld	a5,8(a5)
    80003e3c:	cbdd                	beqz	a5,80003ef2 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e3e:	4505                	li	a0,1
    80003e40:	9782                	jalr	a5
    80003e42:	8a2a                	mv	s4,a0
    80003e44:	a8a5                	j	80003ebc <filewrite+0xfa>
    80003e46:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	8b0080e7          	jalr	-1872(ra) # 800036fa <begin_op>
      ilock(f->ip);
    80003e52:	01893503          	ld	a0,24(s2)
    80003e56:	fffff097          	auipc	ra,0xfffff
    80003e5a:	ed2080e7          	jalr	-302(ra) # 80002d28 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e5e:	8762                	mv	a4,s8
    80003e60:	02092683          	lw	a3,32(s2)
    80003e64:	01598633          	add	a2,s3,s5
    80003e68:	4585                	li	a1,1
    80003e6a:	01893503          	ld	a0,24(s2)
    80003e6e:	fffff097          	auipc	ra,0xfffff
    80003e72:	266080e7          	jalr	614(ra) # 800030d4 <writei>
    80003e76:	84aa                	mv	s1,a0
    80003e78:	00a05763          	blez	a0,80003e86 <filewrite+0xc4>
        f->off += r;
    80003e7c:	02092783          	lw	a5,32(s2)
    80003e80:	9fa9                	addw	a5,a5,a0
    80003e82:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e86:	01893503          	ld	a0,24(s2)
    80003e8a:	fffff097          	auipc	ra,0xfffff
    80003e8e:	f60080e7          	jalr	-160(ra) # 80002dea <iunlock>
      end_op();
    80003e92:	00000097          	auipc	ra,0x0
    80003e96:	8e8080e7          	jalr	-1816(ra) # 8000377a <end_op>

      if(r != n1){
    80003e9a:	009c1f63          	bne	s8,s1,80003eb8 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e9e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ea2:	0149db63          	bge	s3,s4,80003eb8 <filewrite+0xf6>
      int n1 = n - i;
    80003ea6:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003eaa:	84be                	mv	s1,a5
    80003eac:	2781                	sext.w	a5,a5
    80003eae:	f8fb5ce3          	bge	s6,a5,80003e46 <filewrite+0x84>
    80003eb2:	84de                	mv	s1,s7
    80003eb4:	bf49                	j	80003e46 <filewrite+0x84>
    int i = 0;
    80003eb6:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003eb8:	013a1f63          	bne	s4,s3,80003ed6 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ebc:	8552                	mv	a0,s4
    80003ebe:	60a6                	ld	ra,72(sp)
    80003ec0:	6406                	ld	s0,64(sp)
    80003ec2:	74e2                	ld	s1,56(sp)
    80003ec4:	7942                	ld	s2,48(sp)
    80003ec6:	79a2                	ld	s3,40(sp)
    80003ec8:	7a02                	ld	s4,32(sp)
    80003eca:	6ae2                	ld	s5,24(sp)
    80003ecc:	6b42                	ld	s6,16(sp)
    80003ece:	6ba2                	ld	s7,8(sp)
    80003ed0:	6c02                	ld	s8,0(sp)
    80003ed2:	6161                	addi	sp,sp,80
    80003ed4:	8082                	ret
    ret = (i == n ? n : -1);
    80003ed6:	5a7d                	li	s4,-1
    80003ed8:	b7d5                	j	80003ebc <filewrite+0xfa>
    panic("filewrite");
    80003eda:	00004517          	auipc	a0,0x4
    80003ede:	7d650513          	addi	a0,a0,2006 # 800086b0 <syscalls+0x2b0>
    80003ee2:	00002097          	auipc	ra,0x2
    80003ee6:	f16080e7          	jalr	-234(ra) # 80005df8 <panic>
    return -1;
    80003eea:	5a7d                	li	s4,-1
    80003eec:	bfc1                	j	80003ebc <filewrite+0xfa>
      return -1;
    80003eee:	5a7d                	li	s4,-1
    80003ef0:	b7f1                	j	80003ebc <filewrite+0xfa>
    80003ef2:	5a7d                	li	s4,-1
    80003ef4:	b7e1                	j	80003ebc <filewrite+0xfa>

0000000080003ef6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ef6:	7179                	addi	sp,sp,-48
    80003ef8:	f406                	sd	ra,40(sp)
    80003efa:	f022                	sd	s0,32(sp)
    80003efc:	ec26                	sd	s1,24(sp)
    80003efe:	e84a                	sd	s2,16(sp)
    80003f00:	e44e                	sd	s3,8(sp)
    80003f02:	e052                	sd	s4,0(sp)
    80003f04:	1800                	addi	s0,sp,48
    80003f06:	84aa                	mv	s1,a0
    80003f08:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f0a:	0005b023          	sd	zero,0(a1)
    80003f0e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f12:	00000097          	auipc	ra,0x0
    80003f16:	bf8080e7          	jalr	-1032(ra) # 80003b0a <filealloc>
    80003f1a:	e088                	sd	a0,0(s1)
    80003f1c:	c551                	beqz	a0,80003fa8 <pipealloc+0xb2>
    80003f1e:	00000097          	auipc	ra,0x0
    80003f22:	bec080e7          	jalr	-1044(ra) # 80003b0a <filealloc>
    80003f26:	00aa3023          	sd	a0,0(s4)
    80003f2a:	c92d                	beqz	a0,80003f9c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f2c:	ffffc097          	auipc	ra,0xffffc
    80003f30:	1ec080e7          	jalr	492(ra) # 80000118 <kalloc>
    80003f34:	892a                	mv	s2,a0
    80003f36:	c125                	beqz	a0,80003f96 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f38:	4985                	li	s3,1
    80003f3a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f3e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f42:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f46:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f4a:	00004597          	auipc	a1,0x4
    80003f4e:	77658593          	addi	a1,a1,1910 # 800086c0 <syscalls+0x2c0>
    80003f52:	00002097          	auipc	ra,0x2
    80003f56:	360080e7          	jalr	864(ra) # 800062b2 <initlock>
  (*f0)->type = FD_PIPE;
    80003f5a:	609c                	ld	a5,0(s1)
    80003f5c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f60:	609c                	ld	a5,0(s1)
    80003f62:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f66:	609c                	ld	a5,0(s1)
    80003f68:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f6c:	609c                	ld	a5,0(s1)
    80003f6e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f72:	000a3783          	ld	a5,0(s4)
    80003f76:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f7a:	000a3783          	ld	a5,0(s4)
    80003f7e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f82:	000a3783          	ld	a5,0(s4)
    80003f86:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f8a:	000a3783          	ld	a5,0(s4)
    80003f8e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f92:	4501                	li	a0,0
    80003f94:	a025                	j	80003fbc <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f96:	6088                	ld	a0,0(s1)
    80003f98:	e501                	bnez	a0,80003fa0 <pipealloc+0xaa>
    80003f9a:	a039                	j	80003fa8 <pipealloc+0xb2>
    80003f9c:	6088                	ld	a0,0(s1)
    80003f9e:	c51d                	beqz	a0,80003fcc <pipealloc+0xd6>
    fileclose(*f0);
    80003fa0:	00000097          	auipc	ra,0x0
    80003fa4:	c26080e7          	jalr	-986(ra) # 80003bc6 <fileclose>
  if(*f1)
    80003fa8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fac:	557d                	li	a0,-1
  if(*f1)
    80003fae:	c799                	beqz	a5,80003fbc <pipealloc+0xc6>
    fileclose(*f1);
    80003fb0:	853e                	mv	a0,a5
    80003fb2:	00000097          	auipc	ra,0x0
    80003fb6:	c14080e7          	jalr	-1004(ra) # 80003bc6 <fileclose>
  return -1;
    80003fba:	557d                	li	a0,-1
}
    80003fbc:	70a2                	ld	ra,40(sp)
    80003fbe:	7402                	ld	s0,32(sp)
    80003fc0:	64e2                	ld	s1,24(sp)
    80003fc2:	6942                	ld	s2,16(sp)
    80003fc4:	69a2                	ld	s3,8(sp)
    80003fc6:	6a02                	ld	s4,0(sp)
    80003fc8:	6145                	addi	sp,sp,48
    80003fca:	8082                	ret
  return -1;
    80003fcc:	557d                	li	a0,-1
    80003fce:	b7fd                	j	80003fbc <pipealloc+0xc6>

0000000080003fd0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fd0:	1101                	addi	sp,sp,-32
    80003fd2:	ec06                	sd	ra,24(sp)
    80003fd4:	e822                	sd	s0,16(sp)
    80003fd6:	e426                	sd	s1,8(sp)
    80003fd8:	e04a                	sd	s2,0(sp)
    80003fda:	1000                	addi	s0,sp,32
    80003fdc:	84aa                	mv	s1,a0
    80003fde:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fe0:	00002097          	auipc	ra,0x2
    80003fe4:	362080e7          	jalr	866(ra) # 80006342 <acquire>
  if(writable){
    80003fe8:	02090d63          	beqz	s2,80004022 <pipeclose+0x52>
    pi->writeopen = 0;
    80003fec:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ff0:	21848513          	addi	a0,s1,536
    80003ff4:	ffffe097          	auipc	ra,0xffffe
    80003ff8:	87e080e7          	jalr	-1922(ra) # 80001872 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ffc:	2204b783          	ld	a5,544(s1)
    80004000:	eb95                	bnez	a5,80004034 <pipeclose+0x64>
    release(&pi->lock);
    80004002:	8526                	mv	a0,s1
    80004004:	00002097          	auipc	ra,0x2
    80004008:	3f2080e7          	jalr	1010(ra) # 800063f6 <release>
    kfree((char*)pi);
    8000400c:	8526                	mv	a0,s1
    8000400e:	ffffc097          	auipc	ra,0xffffc
    80004012:	00e080e7          	jalr	14(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004016:	60e2                	ld	ra,24(sp)
    80004018:	6442                	ld	s0,16(sp)
    8000401a:	64a2                	ld	s1,8(sp)
    8000401c:	6902                	ld	s2,0(sp)
    8000401e:	6105                	addi	sp,sp,32
    80004020:	8082                	ret
    pi->readopen = 0;
    80004022:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004026:	21c48513          	addi	a0,s1,540
    8000402a:	ffffe097          	auipc	ra,0xffffe
    8000402e:	848080e7          	jalr	-1976(ra) # 80001872 <wakeup>
    80004032:	b7e9                	j	80003ffc <pipeclose+0x2c>
    release(&pi->lock);
    80004034:	8526                	mv	a0,s1
    80004036:	00002097          	auipc	ra,0x2
    8000403a:	3c0080e7          	jalr	960(ra) # 800063f6 <release>
}
    8000403e:	bfe1                	j	80004016 <pipeclose+0x46>

0000000080004040 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004040:	7159                	addi	sp,sp,-112
    80004042:	f486                	sd	ra,104(sp)
    80004044:	f0a2                	sd	s0,96(sp)
    80004046:	eca6                	sd	s1,88(sp)
    80004048:	e8ca                	sd	s2,80(sp)
    8000404a:	e4ce                	sd	s3,72(sp)
    8000404c:	e0d2                	sd	s4,64(sp)
    8000404e:	fc56                	sd	s5,56(sp)
    80004050:	f85a                	sd	s6,48(sp)
    80004052:	f45e                	sd	s7,40(sp)
    80004054:	f062                	sd	s8,32(sp)
    80004056:	ec66                	sd	s9,24(sp)
    80004058:	1880                	addi	s0,sp,112
    8000405a:	84aa                	mv	s1,a0
    8000405c:	8aae                	mv	s5,a1
    8000405e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004060:	ffffd097          	auipc	ra,0xffffd
    80004064:	f1c080e7          	jalr	-228(ra) # 80000f7c <myproc>
    80004068:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000406a:	8526                	mv	a0,s1
    8000406c:	00002097          	auipc	ra,0x2
    80004070:	2d6080e7          	jalr	726(ra) # 80006342 <acquire>
  while(i < n){
    80004074:	0d405163          	blez	s4,80004136 <pipewrite+0xf6>
    80004078:	8ba6                	mv	s7,s1
  int i = 0;
    8000407a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000407c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000407e:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004082:	21c48c13          	addi	s8,s1,540
    80004086:	a08d                	j	800040e8 <pipewrite+0xa8>
      release(&pi->lock);
    80004088:	8526                	mv	a0,s1
    8000408a:	00002097          	auipc	ra,0x2
    8000408e:	36c080e7          	jalr	876(ra) # 800063f6 <release>
      return -1;
    80004092:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004094:	854a                	mv	a0,s2
    80004096:	70a6                	ld	ra,104(sp)
    80004098:	7406                	ld	s0,96(sp)
    8000409a:	64e6                	ld	s1,88(sp)
    8000409c:	6946                	ld	s2,80(sp)
    8000409e:	69a6                	ld	s3,72(sp)
    800040a0:	6a06                	ld	s4,64(sp)
    800040a2:	7ae2                	ld	s5,56(sp)
    800040a4:	7b42                	ld	s6,48(sp)
    800040a6:	7ba2                	ld	s7,40(sp)
    800040a8:	7c02                	ld	s8,32(sp)
    800040aa:	6ce2                	ld	s9,24(sp)
    800040ac:	6165                	addi	sp,sp,112
    800040ae:	8082                	ret
      wakeup(&pi->nread);
    800040b0:	8566                	mv	a0,s9
    800040b2:	ffffd097          	auipc	ra,0xffffd
    800040b6:	7c0080e7          	jalr	1984(ra) # 80001872 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040ba:	85de                	mv	a1,s7
    800040bc:	8562                	mv	a0,s8
    800040be:	ffffd097          	auipc	ra,0xffffd
    800040c2:	628080e7          	jalr	1576(ra) # 800016e6 <sleep>
    800040c6:	a839                	j	800040e4 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040c8:	21c4a783          	lw	a5,540(s1)
    800040cc:	0017871b          	addiw	a4,a5,1
    800040d0:	20e4ae23          	sw	a4,540(s1)
    800040d4:	1ff7f793          	andi	a5,a5,511
    800040d8:	97a6                	add	a5,a5,s1
    800040da:	f9f44703          	lbu	a4,-97(s0)
    800040de:	00e78c23          	sb	a4,24(a5)
      i++;
    800040e2:	2905                	addiw	s2,s2,1
  while(i < n){
    800040e4:	03495d63          	bge	s2,s4,8000411e <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800040e8:	2204a783          	lw	a5,544(s1)
    800040ec:	dfd1                	beqz	a5,80004088 <pipewrite+0x48>
    800040ee:	0289a783          	lw	a5,40(s3)
    800040f2:	fbd9                	bnez	a5,80004088 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040f4:	2184a783          	lw	a5,536(s1)
    800040f8:	21c4a703          	lw	a4,540(s1)
    800040fc:	2007879b          	addiw	a5,a5,512
    80004100:	faf708e3          	beq	a4,a5,800040b0 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004104:	4685                	li	a3,1
    80004106:	01590633          	add	a2,s2,s5
    8000410a:	f9f40593          	addi	a1,s0,-97
    8000410e:	0509b503          	ld	a0,80(s3)
    80004112:	ffffd097          	auipc	ra,0xffffd
    80004116:	a84080e7          	jalr	-1404(ra) # 80000b96 <copyin>
    8000411a:	fb6517e3          	bne	a0,s6,800040c8 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000411e:	21848513          	addi	a0,s1,536
    80004122:	ffffd097          	auipc	ra,0xffffd
    80004126:	750080e7          	jalr	1872(ra) # 80001872 <wakeup>
  release(&pi->lock);
    8000412a:	8526                	mv	a0,s1
    8000412c:	00002097          	auipc	ra,0x2
    80004130:	2ca080e7          	jalr	714(ra) # 800063f6 <release>
  return i;
    80004134:	b785                	j	80004094 <pipewrite+0x54>
  int i = 0;
    80004136:	4901                	li	s2,0
    80004138:	b7dd                	j	8000411e <pipewrite+0xde>

000000008000413a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000413a:	715d                	addi	sp,sp,-80
    8000413c:	e486                	sd	ra,72(sp)
    8000413e:	e0a2                	sd	s0,64(sp)
    80004140:	fc26                	sd	s1,56(sp)
    80004142:	f84a                	sd	s2,48(sp)
    80004144:	f44e                	sd	s3,40(sp)
    80004146:	f052                	sd	s4,32(sp)
    80004148:	ec56                	sd	s5,24(sp)
    8000414a:	e85a                	sd	s6,16(sp)
    8000414c:	0880                	addi	s0,sp,80
    8000414e:	84aa                	mv	s1,a0
    80004150:	892e                	mv	s2,a1
    80004152:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004154:	ffffd097          	auipc	ra,0xffffd
    80004158:	e28080e7          	jalr	-472(ra) # 80000f7c <myproc>
    8000415c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000415e:	8b26                	mv	s6,s1
    80004160:	8526                	mv	a0,s1
    80004162:	00002097          	auipc	ra,0x2
    80004166:	1e0080e7          	jalr	480(ra) # 80006342 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000416a:	2184a703          	lw	a4,536(s1)
    8000416e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004172:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004176:	02f71463          	bne	a4,a5,8000419e <piperead+0x64>
    8000417a:	2244a783          	lw	a5,548(s1)
    8000417e:	c385                	beqz	a5,8000419e <piperead+0x64>
    if(pr->killed){
    80004180:	028a2783          	lw	a5,40(s4)
    80004184:	ebc1                	bnez	a5,80004214 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004186:	85da                	mv	a1,s6
    80004188:	854e                	mv	a0,s3
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	55c080e7          	jalr	1372(ra) # 800016e6 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004192:	2184a703          	lw	a4,536(s1)
    80004196:	21c4a783          	lw	a5,540(s1)
    8000419a:	fef700e3          	beq	a4,a5,8000417a <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000419e:	09505263          	blez	s5,80004222 <piperead+0xe8>
    800041a2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041a4:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800041a6:	2184a783          	lw	a5,536(s1)
    800041aa:	21c4a703          	lw	a4,540(s1)
    800041ae:	02f70d63          	beq	a4,a5,800041e8 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041b2:	0017871b          	addiw	a4,a5,1
    800041b6:	20e4ac23          	sw	a4,536(s1)
    800041ba:	1ff7f793          	andi	a5,a5,511
    800041be:	97a6                	add	a5,a5,s1
    800041c0:	0187c783          	lbu	a5,24(a5)
    800041c4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041c8:	4685                	li	a3,1
    800041ca:	fbf40613          	addi	a2,s0,-65
    800041ce:	85ca                	mv	a1,s2
    800041d0:	050a3503          	ld	a0,80(s4)
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	936080e7          	jalr	-1738(ra) # 80000b0a <copyout>
    800041dc:	01650663          	beq	a0,s6,800041e8 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041e0:	2985                	addiw	s3,s3,1
    800041e2:	0905                	addi	s2,s2,1
    800041e4:	fd3a91e3          	bne	s5,s3,800041a6 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041e8:	21c48513          	addi	a0,s1,540
    800041ec:	ffffd097          	auipc	ra,0xffffd
    800041f0:	686080e7          	jalr	1670(ra) # 80001872 <wakeup>
  release(&pi->lock);
    800041f4:	8526                	mv	a0,s1
    800041f6:	00002097          	auipc	ra,0x2
    800041fa:	200080e7          	jalr	512(ra) # 800063f6 <release>
  return i;
}
    800041fe:	854e                	mv	a0,s3
    80004200:	60a6                	ld	ra,72(sp)
    80004202:	6406                	ld	s0,64(sp)
    80004204:	74e2                	ld	s1,56(sp)
    80004206:	7942                	ld	s2,48(sp)
    80004208:	79a2                	ld	s3,40(sp)
    8000420a:	7a02                	ld	s4,32(sp)
    8000420c:	6ae2                	ld	s5,24(sp)
    8000420e:	6b42                	ld	s6,16(sp)
    80004210:	6161                	addi	sp,sp,80
    80004212:	8082                	ret
      release(&pi->lock);
    80004214:	8526                	mv	a0,s1
    80004216:	00002097          	auipc	ra,0x2
    8000421a:	1e0080e7          	jalr	480(ra) # 800063f6 <release>
      return -1;
    8000421e:	59fd                	li	s3,-1
    80004220:	bff9                	j	800041fe <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004222:	4981                	li	s3,0
    80004224:	b7d1                	j	800041e8 <piperead+0xae>

0000000080004226 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004226:	df010113          	addi	sp,sp,-528
    8000422a:	20113423          	sd	ra,520(sp)
    8000422e:	20813023          	sd	s0,512(sp)
    80004232:	ffa6                	sd	s1,504(sp)
    80004234:	fbca                	sd	s2,496(sp)
    80004236:	f7ce                	sd	s3,488(sp)
    80004238:	f3d2                	sd	s4,480(sp)
    8000423a:	efd6                	sd	s5,472(sp)
    8000423c:	ebda                	sd	s6,464(sp)
    8000423e:	e7de                	sd	s7,456(sp)
    80004240:	e3e2                	sd	s8,448(sp)
    80004242:	ff66                	sd	s9,440(sp)
    80004244:	fb6a                	sd	s10,432(sp)
    80004246:	f76e                	sd	s11,424(sp)
    80004248:	0c00                	addi	s0,sp,528
    8000424a:	84aa                	mv	s1,a0
    8000424c:	dea43c23          	sd	a0,-520(s0)
    80004250:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004254:	ffffd097          	auipc	ra,0xffffd
    80004258:	d28080e7          	jalr	-728(ra) # 80000f7c <myproc>
    8000425c:	892a                	mv	s2,a0

  begin_op();
    8000425e:	fffff097          	auipc	ra,0xfffff
    80004262:	49c080e7          	jalr	1180(ra) # 800036fa <begin_op>

  if((ip = namei(path)) == 0){
    80004266:	8526                	mv	a0,s1
    80004268:	fffff097          	auipc	ra,0xfffff
    8000426c:	276080e7          	jalr	630(ra) # 800034de <namei>
    80004270:	c92d                	beqz	a0,800042e2 <exec+0xbc>
    80004272:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004274:	fffff097          	auipc	ra,0xfffff
    80004278:	ab4080e7          	jalr	-1356(ra) # 80002d28 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000427c:	04000713          	li	a4,64
    80004280:	4681                	li	a3,0
    80004282:	e5040613          	addi	a2,s0,-432
    80004286:	4581                	li	a1,0
    80004288:	8526                	mv	a0,s1
    8000428a:	fffff097          	auipc	ra,0xfffff
    8000428e:	d52080e7          	jalr	-686(ra) # 80002fdc <readi>
    80004292:	04000793          	li	a5,64
    80004296:	00f51a63          	bne	a0,a5,800042aa <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000429a:	e5042703          	lw	a4,-432(s0)
    8000429e:	464c47b7          	lui	a5,0x464c4
    800042a2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042a6:	04f70463          	beq	a4,a5,800042ee <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042aa:	8526                	mv	a0,s1
    800042ac:	fffff097          	auipc	ra,0xfffff
    800042b0:	cde080e7          	jalr	-802(ra) # 80002f8a <iunlockput>
    end_op();
    800042b4:	fffff097          	auipc	ra,0xfffff
    800042b8:	4c6080e7          	jalr	1222(ra) # 8000377a <end_op>
  }
  return -1;
    800042bc:	557d                	li	a0,-1
}
    800042be:	20813083          	ld	ra,520(sp)
    800042c2:	20013403          	ld	s0,512(sp)
    800042c6:	74fe                	ld	s1,504(sp)
    800042c8:	795e                	ld	s2,496(sp)
    800042ca:	79be                	ld	s3,488(sp)
    800042cc:	7a1e                	ld	s4,480(sp)
    800042ce:	6afe                	ld	s5,472(sp)
    800042d0:	6b5e                	ld	s6,464(sp)
    800042d2:	6bbe                	ld	s7,456(sp)
    800042d4:	6c1e                	ld	s8,448(sp)
    800042d6:	7cfa                	ld	s9,440(sp)
    800042d8:	7d5a                	ld	s10,432(sp)
    800042da:	7dba                	ld	s11,424(sp)
    800042dc:	21010113          	addi	sp,sp,528
    800042e0:	8082                	ret
    end_op();
    800042e2:	fffff097          	auipc	ra,0xfffff
    800042e6:	498080e7          	jalr	1176(ra) # 8000377a <end_op>
    return -1;
    800042ea:	557d                	li	a0,-1
    800042ec:	bfc9                	j	800042be <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042ee:	854a                	mv	a0,s2
    800042f0:	ffffd097          	auipc	ra,0xffffd
    800042f4:	d50080e7          	jalr	-688(ra) # 80001040 <proc_pagetable>
    800042f8:	8baa                	mv	s7,a0
    800042fa:	d945                	beqz	a0,800042aa <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042fc:	e7042983          	lw	s3,-400(s0)
    80004300:	e8845783          	lhu	a5,-376(s0)
    80004304:	c7ad                	beqz	a5,8000436e <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004306:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004308:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    8000430a:	6c85                	lui	s9,0x1
    8000430c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004310:	def43823          	sd	a5,-528(s0)
    80004314:	a489                	j	80004556 <exec+0x330>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004316:	00004517          	auipc	a0,0x4
    8000431a:	3b250513          	addi	a0,a0,946 # 800086c8 <syscalls+0x2c8>
    8000431e:	00002097          	auipc	ra,0x2
    80004322:	ada080e7          	jalr	-1318(ra) # 80005df8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004326:	8756                	mv	a4,s5
    80004328:	012d86bb          	addw	a3,s11,s2
    8000432c:	4581                	li	a1,0
    8000432e:	8526                	mv	a0,s1
    80004330:	fffff097          	auipc	ra,0xfffff
    80004334:	cac080e7          	jalr	-852(ra) # 80002fdc <readi>
    80004338:	2501                	sext.w	a0,a0
    8000433a:	1caa9563          	bne	s5,a0,80004504 <exec+0x2de>
  for(i = 0; i < sz; i += PGSIZE){
    8000433e:	6785                	lui	a5,0x1
    80004340:	0127893b          	addw	s2,a5,s2
    80004344:	77fd                	lui	a5,0xfffff
    80004346:	01478a3b          	addw	s4,a5,s4
    8000434a:	1f897d63          	bgeu	s2,s8,80004544 <exec+0x31e>
    pa = walkaddr(pagetable, va + i);
    8000434e:	02091593          	slli	a1,s2,0x20
    80004352:	9181                	srli	a1,a1,0x20
    80004354:	95ea                	add	a1,a1,s10
    80004356:	855e                	mv	a0,s7
    80004358:	ffffc097          	auipc	ra,0xffffc
    8000435c:	1ae080e7          	jalr	430(ra) # 80000506 <walkaddr>
    80004360:	862a                	mv	a2,a0
    if(pa == 0)
    80004362:	d955                	beqz	a0,80004316 <exec+0xf0>
      n = PGSIZE;
    80004364:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004366:	fd9a70e3          	bgeu	s4,s9,80004326 <exec+0x100>
      n = sz - i;
    8000436a:	8ad2                	mv	s5,s4
    8000436c:	bf6d                	j	80004326 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000436e:	4901                	li	s2,0
  iunlockput(ip);
    80004370:	8526                	mv	a0,s1
    80004372:	fffff097          	auipc	ra,0xfffff
    80004376:	c18080e7          	jalr	-1000(ra) # 80002f8a <iunlockput>
  end_op();
    8000437a:	fffff097          	auipc	ra,0xfffff
    8000437e:	400080e7          	jalr	1024(ra) # 8000377a <end_op>
  p = myproc();
    80004382:	ffffd097          	auipc	ra,0xffffd
    80004386:	bfa080e7          	jalr	-1030(ra) # 80000f7c <myproc>
    8000438a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000438c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004390:	6785                	lui	a5,0x1
    80004392:	17fd                	addi	a5,a5,-1
    80004394:	993e                	add	s2,s2,a5
    80004396:	757d                	lui	a0,0xfffff
    80004398:	00a977b3          	and	a5,s2,a0
    8000439c:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043a0:	6609                	lui	a2,0x2
    800043a2:	963e                	add	a2,a2,a5
    800043a4:	85be                	mv	a1,a5
    800043a6:	855e                	mv	a0,s7
    800043a8:	ffffc097          	auipc	ra,0xffffc
    800043ac:	512080e7          	jalr	1298(ra) # 800008ba <uvmalloc>
    800043b0:	8b2a                	mv	s6,a0
  ip = 0;
    800043b2:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043b4:	14050863          	beqz	a0,80004504 <exec+0x2de>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043b8:	75f9                	lui	a1,0xffffe
    800043ba:	95aa                	add	a1,a1,a0
    800043bc:	855e                	mv	a0,s7
    800043be:	ffffc097          	auipc	ra,0xffffc
    800043c2:	71a080e7          	jalr	1818(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    800043c6:	7c7d                	lui	s8,0xfffff
    800043c8:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800043ca:	e0043783          	ld	a5,-512(s0)
    800043ce:	6388                	ld	a0,0(a5)
    800043d0:	c535                	beqz	a0,8000443c <exec+0x216>
    800043d2:	e9040993          	addi	s3,s0,-368
    800043d6:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043da:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800043dc:	ffffc097          	auipc	ra,0xffffc
    800043e0:	f20080e7          	jalr	-224(ra) # 800002fc <strlen>
    800043e4:	2505                	addiw	a0,a0,1
    800043e6:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043ea:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043ee:	13896f63          	bltu	s2,s8,8000452c <exec+0x306>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043f2:	e0043d83          	ld	s11,-512(s0)
    800043f6:	000dba03          	ld	s4,0(s11)
    800043fa:	8552                	mv	a0,s4
    800043fc:	ffffc097          	auipc	ra,0xffffc
    80004400:	f00080e7          	jalr	-256(ra) # 800002fc <strlen>
    80004404:	0015069b          	addiw	a3,a0,1
    80004408:	8652                	mv	a2,s4
    8000440a:	85ca                	mv	a1,s2
    8000440c:	855e                	mv	a0,s7
    8000440e:	ffffc097          	auipc	ra,0xffffc
    80004412:	6fc080e7          	jalr	1788(ra) # 80000b0a <copyout>
    80004416:	10054f63          	bltz	a0,80004534 <exec+0x30e>
    ustack[argc] = sp;
    8000441a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000441e:	0485                	addi	s1,s1,1
    80004420:	008d8793          	addi	a5,s11,8
    80004424:	e0f43023          	sd	a5,-512(s0)
    80004428:	008db503          	ld	a0,8(s11)
    8000442c:	c911                	beqz	a0,80004440 <exec+0x21a>
    if(argc >= MAXARG)
    8000442e:	09a1                	addi	s3,s3,8
    80004430:	fb3c96e3          	bne	s9,s3,800043dc <exec+0x1b6>
  sz = sz1;
    80004434:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004438:	4481                	li	s1,0
    8000443a:	a0e9                	j	80004504 <exec+0x2de>
  sp = sz;
    8000443c:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000443e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004440:	00349793          	slli	a5,s1,0x3
    80004444:	f9040713          	addi	a4,s0,-112
    80004448:	97ba                	add	a5,a5,a4
    8000444a:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000444e:	00148693          	addi	a3,s1,1
    80004452:	068e                	slli	a3,a3,0x3
    80004454:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004458:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000445c:	01897663          	bgeu	s2,s8,80004468 <exec+0x242>
  sz = sz1;
    80004460:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004464:	4481                	li	s1,0
    80004466:	a879                	j	80004504 <exec+0x2de>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004468:	e9040613          	addi	a2,s0,-368
    8000446c:	85ca                	mv	a1,s2
    8000446e:	855e                	mv	a0,s7
    80004470:	ffffc097          	auipc	ra,0xffffc
    80004474:	69a080e7          	jalr	1690(ra) # 80000b0a <copyout>
    80004478:	0c054263          	bltz	a0,8000453c <exec+0x316>
  p->trapframe->a1 = sp;
    8000447c:	058ab783          	ld	a5,88(s5)
    80004480:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004484:	df843783          	ld	a5,-520(s0)
    80004488:	0007c703          	lbu	a4,0(a5)
    8000448c:	cf11                	beqz	a4,800044a8 <exec+0x282>
    8000448e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004490:	02f00693          	li	a3,47
    80004494:	a039                	j	800044a2 <exec+0x27c>
      last = s+1;
    80004496:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000449a:	0785                	addi	a5,a5,1
    8000449c:	fff7c703          	lbu	a4,-1(a5)
    800044a0:	c701                	beqz	a4,800044a8 <exec+0x282>
    if(*s == '/')
    800044a2:	fed71ce3          	bne	a4,a3,8000449a <exec+0x274>
    800044a6:	bfc5                	j	80004496 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800044a8:	4641                	li	a2,16
    800044aa:	df843583          	ld	a1,-520(s0)
    800044ae:	160a8513          	addi	a0,s5,352
    800044b2:	ffffc097          	auipc	ra,0xffffc
    800044b6:	e18080e7          	jalr	-488(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800044ba:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044be:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800044c2:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044c6:	058ab783          	ld	a5,88(s5)
    800044ca:	e6843703          	ld	a4,-408(s0)
    800044ce:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044d0:	058ab783          	ld	a5,88(s5)
    800044d4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044d8:	85ea                	mv	a1,s10
    800044da:	ffffd097          	auipc	ra,0xffffd
    800044de:	c5c080e7          	jalr	-932(ra) # 80001136 <proc_freepagetable>
  if(p->pid==1)
    800044e2:	030aa703          	lw	a4,48(s5)
    800044e6:	4785                	li	a5,1
    800044e8:	00f70563          	beq	a4,a5,800044f2 <exec+0x2cc>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044ec:	0004851b          	sext.w	a0,s1
    800044f0:	b3f9                	j	800042be <exec+0x98>
    vmprint(p->pagetable);
    800044f2:	050ab503          	ld	a0,80(s5)
    800044f6:	ffffd097          	auipc	ra,0xffffd
    800044fa:	89c080e7          	jalr	-1892(ra) # 80000d92 <vmprint>
    800044fe:	b7fd                	j	800044ec <exec+0x2c6>
    80004500:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004504:	e0843583          	ld	a1,-504(s0)
    80004508:	855e                	mv	a0,s7
    8000450a:	ffffd097          	auipc	ra,0xffffd
    8000450e:	c2c080e7          	jalr	-980(ra) # 80001136 <proc_freepagetable>
  if(ip){
    80004512:	d8049ce3          	bnez	s1,800042aa <exec+0x84>
  return -1;
    80004516:	557d                	li	a0,-1
    80004518:	b35d                	j	800042be <exec+0x98>
    8000451a:	e1243423          	sd	s2,-504(s0)
    8000451e:	b7dd                	j	80004504 <exec+0x2de>
    80004520:	e1243423          	sd	s2,-504(s0)
    80004524:	b7c5                	j	80004504 <exec+0x2de>
    80004526:	e1243423          	sd	s2,-504(s0)
    8000452a:	bfe9                	j	80004504 <exec+0x2de>
  sz = sz1;
    8000452c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004530:	4481                	li	s1,0
    80004532:	bfc9                	j	80004504 <exec+0x2de>
  sz = sz1;
    80004534:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004538:	4481                	li	s1,0
    8000453a:	b7e9                	j	80004504 <exec+0x2de>
  sz = sz1;
    8000453c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004540:	4481                	li	s1,0
    80004542:	b7c9                	j	80004504 <exec+0x2de>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004544:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004548:	2b05                	addiw	s6,s6,1
    8000454a:	0389899b          	addiw	s3,s3,56
    8000454e:	e8845783          	lhu	a5,-376(s0)
    80004552:	e0fb5fe3          	bge	s6,a5,80004370 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004556:	2981                	sext.w	s3,s3
    80004558:	03800713          	li	a4,56
    8000455c:	86ce                	mv	a3,s3
    8000455e:	e1840613          	addi	a2,s0,-488
    80004562:	4581                	li	a1,0
    80004564:	8526                	mv	a0,s1
    80004566:	fffff097          	auipc	ra,0xfffff
    8000456a:	a76080e7          	jalr	-1418(ra) # 80002fdc <readi>
    8000456e:	03800793          	li	a5,56
    80004572:	f8f517e3          	bne	a0,a5,80004500 <exec+0x2da>
    if(ph.type != ELF_PROG_LOAD)
    80004576:	e1842783          	lw	a5,-488(s0)
    8000457a:	4705                	li	a4,1
    8000457c:	fce796e3          	bne	a5,a4,80004548 <exec+0x322>
    if(ph.memsz < ph.filesz)
    80004580:	e4043603          	ld	a2,-448(s0)
    80004584:	e3843783          	ld	a5,-456(s0)
    80004588:	f8f669e3          	bltu	a2,a5,8000451a <exec+0x2f4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000458c:	e2843783          	ld	a5,-472(s0)
    80004590:	963e                	add	a2,a2,a5
    80004592:	f8f667e3          	bltu	a2,a5,80004520 <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004596:	85ca                	mv	a1,s2
    80004598:	855e                	mv	a0,s7
    8000459a:	ffffc097          	auipc	ra,0xffffc
    8000459e:	320080e7          	jalr	800(ra) # 800008ba <uvmalloc>
    800045a2:	e0a43423          	sd	a0,-504(s0)
    800045a6:	d141                	beqz	a0,80004526 <exec+0x300>
    if((ph.vaddr % PGSIZE) != 0)
    800045a8:	e2843d03          	ld	s10,-472(s0)
    800045ac:	df043783          	ld	a5,-528(s0)
    800045b0:	00fd77b3          	and	a5,s10,a5
    800045b4:	fba1                	bnez	a5,80004504 <exec+0x2de>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045b6:	e2042d83          	lw	s11,-480(s0)
    800045ba:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045be:	f80c03e3          	beqz	s8,80004544 <exec+0x31e>
    800045c2:	8a62                	mv	s4,s8
    800045c4:	4901                	li	s2,0
    800045c6:	b361                	j	8000434e <exec+0x128>

00000000800045c8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045c8:	7179                	addi	sp,sp,-48
    800045ca:	f406                	sd	ra,40(sp)
    800045cc:	f022                	sd	s0,32(sp)
    800045ce:	ec26                	sd	s1,24(sp)
    800045d0:	e84a                	sd	s2,16(sp)
    800045d2:	1800                	addi	s0,sp,48
    800045d4:	892e                	mv	s2,a1
    800045d6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045d8:	fdc40593          	addi	a1,s0,-36
    800045dc:	ffffe097          	auipc	ra,0xffffe
    800045e0:	afa080e7          	jalr	-1286(ra) # 800020d6 <argint>
    800045e4:	04054063          	bltz	a0,80004624 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045e8:	fdc42703          	lw	a4,-36(s0)
    800045ec:	47bd                	li	a5,15
    800045ee:	02e7ed63          	bltu	a5,a4,80004628 <argfd+0x60>
    800045f2:	ffffd097          	auipc	ra,0xffffd
    800045f6:	98a080e7          	jalr	-1654(ra) # 80000f7c <myproc>
    800045fa:	fdc42703          	lw	a4,-36(s0)
    800045fe:	01a70793          	addi	a5,a4,26
    80004602:	078e                	slli	a5,a5,0x3
    80004604:	953e                	add	a0,a0,a5
    80004606:	651c                	ld	a5,8(a0)
    80004608:	c395                	beqz	a5,8000462c <argfd+0x64>
    return -1;
  if(pfd)
    8000460a:	00090463          	beqz	s2,80004612 <argfd+0x4a>
    *pfd = fd;
    8000460e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004612:	4501                	li	a0,0
  if(pf)
    80004614:	c091                	beqz	s1,80004618 <argfd+0x50>
    *pf = f;
    80004616:	e09c                	sd	a5,0(s1)
}
    80004618:	70a2                	ld	ra,40(sp)
    8000461a:	7402                	ld	s0,32(sp)
    8000461c:	64e2                	ld	s1,24(sp)
    8000461e:	6942                	ld	s2,16(sp)
    80004620:	6145                	addi	sp,sp,48
    80004622:	8082                	ret
    return -1;
    80004624:	557d                	li	a0,-1
    80004626:	bfcd                	j	80004618 <argfd+0x50>
    return -1;
    80004628:	557d                	li	a0,-1
    8000462a:	b7fd                	j	80004618 <argfd+0x50>
    8000462c:	557d                	li	a0,-1
    8000462e:	b7ed                	j	80004618 <argfd+0x50>

0000000080004630 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004630:	1101                	addi	sp,sp,-32
    80004632:	ec06                	sd	ra,24(sp)
    80004634:	e822                	sd	s0,16(sp)
    80004636:	e426                	sd	s1,8(sp)
    80004638:	1000                	addi	s0,sp,32
    8000463a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000463c:	ffffd097          	auipc	ra,0xffffd
    80004640:	940080e7          	jalr	-1728(ra) # 80000f7c <myproc>
    80004644:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004646:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd8e98>
    8000464a:	4501                	li	a0,0
    8000464c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000464e:	6398                	ld	a4,0(a5)
    80004650:	cb19                	beqz	a4,80004666 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004652:	2505                	addiw	a0,a0,1
    80004654:	07a1                	addi	a5,a5,8
    80004656:	fed51ce3          	bne	a0,a3,8000464e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000465a:	557d                	li	a0,-1
}
    8000465c:	60e2                	ld	ra,24(sp)
    8000465e:	6442                	ld	s0,16(sp)
    80004660:	64a2                	ld	s1,8(sp)
    80004662:	6105                	addi	sp,sp,32
    80004664:	8082                	ret
      p->ofile[fd] = f;
    80004666:	01a50793          	addi	a5,a0,26
    8000466a:	078e                	slli	a5,a5,0x3
    8000466c:	963e                	add	a2,a2,a5
    8000466e:	e604                	sd	s1,8(a2)
      return fd;
    80004670:	b7f5                	j	8000465c <fdalloc+0x2c>

0000000080004672 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004672:	715d                	addi	sp,sp,-80
    80004674:	e486                	sd	ra,72(sp)
    80004676:	e0a2                	sd	s0,64(sp)
    80004678:	fc26                	sd	s1,56(sp)
    8000467a:	f84a                	sd	s2,48(sp)
    8000467c:	f44e                	sd	s3,40(sp)
    8000467e:	f052                	sd	s4,32(sp)
    80004680:	ec56                	sd	s5,24(sp)
    80004682:	0880                	addi	s0,sp,80
    80004684:	89ae                	mv	s3,a1
    80004686:	8ab2                	mv	s5,a2
    80004688:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000468a:	fb040593          	addi	a1,s0,-80
    8000468e:	fffff097          	auipc	ra,0xfffff
    80004692:	e6e080e7          	jalr	-402(ra) # 800034fc <nameiparent>
    80004696:	892a                	mv	s2,a0
    80004698:	12050f63          	beqz	a0,800047d6 <create+0x164>
    return 0;

  ilock(dp);
    8000469c:	ffffe097          	auipc	ra,0xffffe
    800046a0:	68c080e7          	jalr	1676(ra) # 80002d28 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046a4:	4601                	li	a2,0
    800046a6:	fb040593          	addi	a1,s0,-80
    800046aa:	854a                	mv	a0,s2
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	b60080e7          	jalr	-1184(ra) # 8000320c <dirlookup>
    800046b4:	84aa                	mv	s1,a0
    800046b6:	c921                	beqz	a0,80004706 <create+0x94>
    iunlockput(dp);
    800046b8:	854a                	mv	a0,s2
    800046ba:	fffff097          	auipc	ra,0xfffff
    800046be:	8d0080e7          	jalr	-1840(ra) # 80002f8a <iunlockput>
    ilock(ip);
    800046c2:	8526                	mv	a0,s1
    800046c4:	ffffe097          	auipc	ra,0xffffe
    800046c8:	664080e7          	jalr	1636(ra) # 80002d28 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046cc:	2981                	sext.w	s3,s3
    800046ce:	4789                	li	a5,2
    800046d0:	02f99463          	bne	s3,a5,800046f8 <create+0x86>
    800046d4:	0444d783          	lhu	a5,68(s1)
    800046d8:	37f9                	addiw	a5,a5,-2
    800046da:	17c2                	slli	a5,a5,0x30
    800046dc:	93c1                	srli	a5,a5,0x30
    800046de:	4705                	li	a4,1
    800046e0:	00f76c63          	bltu	a4,a5,800046f8 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046e4:	8526                	mv	a0,s1
    800046e6:	60a6                	ld	ra,72(sp)
    800046e8:	6406                	ld	s0,64(sp)
    800046ea:	74e2                	ld	s1,56(sp)
    800046ec:	7942                	ld	s2,48(sp)
    800046ee:	79a2                	ld	s3,40(sp)
    800046f0:	7a02                	ld	s4,32(sp)
    800046f2:	6ae2                	ld	s5,24(sp)
    800046f4:	6161                	addi	sp,sp,80
    800046f6:	8082                	ret
    iunlockput(ip);
    800046f8:	8526                	mv	a0,s1
    800046fa:	fffff097          	auipc	ra,0xfffff
    800046fe:	890080e7          	jalr	-1904(ra) # 80002f8a <iunlockput>
    return 0;
    80004702:	4481                	li	s1,0
    80004704:	b7c5                	j	800046e4 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004706:	85ce                	mv	a1,s3
    80004708:	00092503          	lw	a0,0(s2)
    8000470c:	ffffe097          	auipc	ra,0xffffe
    80004710:	484080e7          	jalr	1156(ra) # 80002b90 <ialloc>
    80004714:	84aa                	mv	s1,a0
    80004716:	c529                	beqz	a0,80004760 <create+0xee>
  ilock(ip);
    80004718:	ffffe097          	auipc	ra,0xffffe
    8000471c:	610080e7          	jalr	1552(ra) # 80002d28 <ilock>
  ip->major = major;
    80004720:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004724:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004728:	4785                	li	a5,1
    8000472a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000472e:	8526                	mv	a0,s1
    80004730:	ffffe097          	auipc	ra,0xffffe
    80004734:	52e080e7          	jalr	1326(ra) # 80002c5e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004738:	2981                	sext.w	s3,s3
    8000473a:	4785                	li	a5,1
    8000473c:	02f98a63          	beq	s3,a5,80004770 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004740:	40d0                	lw	a2,4(s1)
    80004742:	fb040593          	addi	a1,s0,-80
    80004746:	854a                	mv	a0,s2
    80004748:	fffff097          	auipc	ra,0xfffff
    8000474c:	cd4080e7          	jalr	-812(ra) # 8000341c <dirlink>
    80004750:	06054b63          	bltz	a0,800047c6 <create+0x154>
  iunlockput(dp);
    80004754:	854a                	mv	a0,s2
    80004756:	fffff097          	auipc	ra,0xfffff
    8000475a:	834080e7          	jalr	-1996(ra) # 80002f8a <iunlockput>
  return ip;
    8000475e:	b759                	j	800046e4 <create+0x72>
    panic("create: ialloc");
    80004760:	00004517          	auipc	a0,0x4
    80004764:	f8850513          	addi	a0,a0,-120 # 800086e8 <syscalls+0x2e8>
    80004768:	00001097          	auipc	ra,0x1
    8000476c:	690080e7          	jalr	1680(ra) # 80005df8 <panic>
    dp->nlink++;  // for ".."
    80004770:	04a95783          	lhu	a5,74(s2)
    80004774:	2785                	addiw	a5,a5,1
    80004776:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000477a:	854a                	mv	a0,s2
    8000477c:	ffffe097          	auipc	ra,0xffffe
    80004780:	4e2080e7          	jalr	1250(ra) # 80002c5e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004784:	40d0                	lw	a2,4(s1)
    80004786:	00004597          	auipc	a1,0x4
    8000478a:	f7258593          	addi	a1,a1,-142 # 800086f8 <syscalls+0x2f8>
    8000478e:	8526                	mv	a0,s1
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	c8c080e7          	jalr	-884(ra) # 8000341c <dirlink>
    80004798:	00054f63          	bltz	a0,800047b6 <create+0x144>
    8000479c:	00492603          	lw	a2,4(s2)
    800047a0:	00004597          	auipc	a1,0x4
    800047a4:	f6058593          	addi	a1,a1,-160 # 80008700 <syscalls+0x300>
    800047a8:	8526                	mv	a0,s1
    800047aa:	fffff097          	auipc	ra,0xfffff
    800047ae:	c72080e7          	jalr	-910(ra) # 8000341c <dirlink>
    800047b2:	f80557e3          	bgez	a0,80004740 <create+0xce>
      panic("create dots");
    800047b6:	00004517          	auipc	a0,0x4
    800047ba:	f5250513          	addi	a0,a0,-174 # 80008708 <syscalls+0x308>
    800047be:	00001097          	auipc	ra,0x1
    800047c2:	63a080e7          	jalr	1594(ra) # 80005df8 <panic>
    panic("create: dirlink");
    800047c6:	00004517          	auipc	a0,0x4
    800047ca:	f5250513          	addi	a0,a0,-174 # 80008718 <syscalls+0x318>
    800047ce:	00001097          	auipc	ra,0x1
    800047d2:	62a080e7          	jalr	1578(ra) # 80005df8 <panic>
    return 0;
    800047d6:	84aa                	mv	s1,a0
    800047d8:	b731                	j	800046e4 <create+0x72>

00000000800047da <sys_dup>:
{
    800047da:	7179                	addi	sp,sp,-48
    800047dc:	f406                	sd	ra,40(sp)
    800047de:	f022                	sd	s0,32(sp)
    800047e0:	ec26                	sd	s1,24(sp)
    800047e2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047e4:	fd840613          	addi	a2,s0,-40
    800047e8:	4581                	li	a1,0
    800047ea:	4501                	li	a0,0
    800047ec:	00000097          	auipc	ra,0x0
    800047f0:	ddc080e7          	jalr	-548(ra) # 800045c8 <argfd>
    return -1;
    800047f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047f6:	02054363          	bltz	a0,8000481c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800047fa:	fd843503          	ld	a0,-40(s0)
    800047fe:	00000097          	auipc	ra,0x0
    80004802:	e32080e7          	jalr	-462(ra) # 80004630 <fdalloc>
    80004806:	84aa                	mv	s1,a0
    return -1;
    80004808:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000480a:	00054963          	bltz	a0,8000481c <sys_dup+0x42>
  filedup(f);
    8000480e:	fd843503          	ld	a0,-40(s0)
    80004812:	fffff097          	auipc	ra,0xfffff
    80004816:	362080e7          	jalr	866(ra) # 80003b74 <filedup>
  return fd;
    8000481a:	87a6                	mv	a5,s1
}
    8000481c:	853e                	mv	a0,a5
    8000481e:	70a2                	ld	ra,40(sp)
    80004820:	7402                	ld	s0,32(sp)
    80004822:	64e2                	ld	s1,24(sp)
    80004824:	6145                	addi	sp,sp,48
    80004826:	8082                	ret

0000000080004828 <sys_read>:
{
    80004828:	7179                	addi	sp,sp,-48
    8000482a:	f406                	sd	ra,40(sp)
    8000482c:	f022                	sd	s0,32(sp)
    8000482e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004830:	fe840613          	addi	a2,s0,-24
    80004834:	4581                	li	a1,0
    80004836:	4501                	li	a0,0
    80004838:	00000097          	auipc	ra,0x0
    8000483c:	d90080e7          	jalr	-624(ra) # 800045c8 <argfd>
    return -1;
    80004840:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004842:	04054163          	bltz	a0,80004884 <sys_read+0x5c>
    80004846:	fe440593          	addi	a1,s0,-28
    8000484a:	4509                	li	a0,2
    8000484c:	ffffe097          	auipc	ra,0xffffe
    80004850:	88a080e7          	jalr	-1910(ra) # 800020d6 <argint>
    return -1;
    80004854:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004856:	02054763          	bltz	a0,80004884 <sys_read+0x5c>
    8000485a:	fd840593          	addi	a1,s0,-40
    8000485e:	4505                	li	a0,1
    80004860:	ffffe097          	auipc	ra,0xffffe
    80004864:	898080e7          	jalr	-1896(ra) # 800020f8 <argaddr>
    return -1;
    80004868:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000486a:	00054d63          	bltz	a0,80004884 <sys_read+0x5c>
  return fileread(f, p, n);
    8000486e:	fe442603          	lw	a2,-28(s0)
    80004872:	fd843583          	ld	a1,-40(s0)
    80004876:	fe843503          	ld	a0,-24(s0)
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	486080e7          	jalr	1158(ra) # 80003d00 <fileread>
    80004882:	87aa                	mv	a5,a0
}
    80004884:	853e                	mv	a0,a5
    80004886:	70a2                	ld	ra,40(sp)
    80004888:	7402                	ld	s0,32(sp)
    8000488a:	6145                	addi	sp,sp,48
    8000488c:	8082                	ret

000000008000488e <sys_write>:
{
    8000488e:	7179                	addi	sp,sp,-48
    80004890:	f406                	sd	ra,40(sp)
    80004892:	f022                	sd	s0,32(sp)
    80004894:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004896:	fe840613          	addi	a2,s0,-24
    8000489a:	4581                	li	a1,0
    8000489c:	4501                	li	a0,0
    8000489e:	00000097          	auipc	ra,0x0
    800048a2:	d2a080e7          	jalr	-726(ra) # 800045c8 <argfd>
    return -1;
    800048a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a8:	04054163          	bltz	a0,800048ea <sys_write+0x5c>
    800048ac:	fe440593          	addi	a1,s0,-28
    800048b0:	4509                	li	a0,2
    800048b2:	ffffe097          	auipc	ra,0xffffe
    800048b6:	824080e7          	jalr	-2012(ra) # 800020d6 <argint>
    return -1;
    800048ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048bc:	02054763          	bltz	a0,800048ea <sys_write+0x5c>
    800048c0:	fd840593          	addi	a1,s0,-40
    800048c4:	4505                	li	a0,1
    800048c6:	ffffe097          	auipc	ra,0xffffe
    800048ca:	832080e7          	jalr	-1998(ra) # 800020f8 <argaddr>
    return -1;
    800048ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d0:	00054d63          	bltz	a0,800048ea <sys_write+0x5c>
  return filewrite(f, p, n);
    800048d4:	fe442603          	lw	a2,-28(s0)
    800048d8:	fd843583          	ld	a1,-40(s0)
    800048dc:	fe843503          	ld	a0,-24(s0)
    800048e0:	fffff097          	auipc	ra,0xfffff
    800048e4:	4e2080e7          	jalr	1250(ra) # 80003dc2 <filewrite>
    800048e8:	87aa                	mv	a5,a0
}
    800048ea:	853e                	mv	a0,a5
    800048ec:	70a2                	ld	ra,40(sp)
    800048ee:	7402                	ld	s0,32(sp)
    800048f0:	6145                	addi	sp,sp,48
    800048f2:	8082                	ret

00000000800048f4 <sys_close>:
{
    800048f4:	1101                	addi	sp,sp,-32
    800048f6:	ec06                	sd	ra,24(sp)
    800048f8:	e822                	sd	s0,16(sp)
    800048fa:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048fc:	fe040613          	addi	a2,s0,-32
    80004900:	fec40593          	addi	a1,s0,-20
    80004904:	4501                	li	a0,0
    80004906:	00000097          	auipc	ra,0x0
    8000490a:	cc2080e7          	jalr	-830(ra) # 800045c8 <argfd>
    return -1;
    8000490e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004910:	02054463          	bltz	a0,80004938 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004914:	ffffc097          	auipc	ra,0xffffc
    80004918:	668080e7          	jalr	1640(ra) # 80000f7c <myproc>
    8000491c:	fec42783          	lw	a5,-20(s0)
    80004920:	07e9                	addi	a5,a5,26
    80004922:	078e                	slli	a5,a5,0x3
    80004924:	97aa                	add	a5,a5,a0
    80004926:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    8000492a:	fe043503          	ld	a0,-32(s0)
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	298080e7          	jalr	664(ra) # 80003bc6 <fileclose>
  return 0;
    80004936:	4781                	li	a5,0
}
    80004938:	853e                	mv	a0,a5
    8000493a:	60e2                	ld	ra,24(sp)
    8000493c:	6442                	ld	s0,16(sp)
    8000493e:	6105                	addi	sp,sp,32
    80004940:	8082                	ret

0000000080004942 <sys_fstat>:
{
    80004942:	1101                	addi	sp,sp,-32
    80004944:	ec06                	sd	ra,24(sp)
    80004946:	e822                	sd	s0,16(sp)
    80004948:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000494a:	fe840613          	addi	a2,s0,-24
    8000494e:	4581                	li	a1,0
    80004950:	4501                	li	a0,0
    80004952:	00000097          	auipc	ra,0x0
    80004956:	c76080e7          	jalr	-906(ra) # 800045c8 <argfd>
    return -1;
    8000495a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000495c:	02054563          	bltz	a0,80004986 <sys_fstat+0x44>
    80004960:	fe040593          	addi	a1,s0,-32
    80004964:	4505                	li	a0,1
    80004966:	ffffd097          	auipc	ra,0xffffd
    8000496a:	792080e7          	jalr	1938(ra) # 800020f8 <argaddr>
    return -1;
    8000496e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004970:	00054b63          	bltz	a0,80004986 <sys_fstat+0x44>
  return filestat(f, st);
    80004974:	fe043583          	ld	a1,-32(s0)
    80004978:	fe843503          	ld	a0,-24(s0)
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	312080e7          	jalr	786(ra) # 80003c8e <filestat>
    80004984:	87aa                	mv	a5,a0
}
    80004986:	853e                	mv	a0,a5
    80004988:	60e2                	ld	ra,24(sp)
    8000498a:	6442                	ld	s0,16(sp)
    8000498c:	6105                	addi	sp,sp,32
    8000498e:	8082                	ret

0000000080004990 <sys_link>:
{
    80004990:	7169                	addi	sp,sp,-304
    80004992:	f606                	sd	ra,296(sp)
    80004994:	f222                	sd	s0,288(sp)
    80004996:	ee26                	sd	s1,280(sp)
    80004998:	ea4a                	sd	s2,272(sp)
    8000499a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000499c:	08000613          	li	a2,128
    800049a0:	ed040593          	addi	a1,s0,-304
    800049a4:	4501                	li	a0,0
    800049a6:	ffffd097          	auipc	ra,0xffffd
    800049aa:	774080e7          	jalr	1908(ra) # 8000211a <argstr>
    return -1;
    800049ae:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049b0:	10054e63          	bltz	a0,80004acc <sys_link+0x13c>
    800049b4:	08000613          	li	a2,128
    800049b8:	f5040593          	addi	a1,s0,-176
    800049bc:	4505                	li	a0,1
    800049be:	ffffd097          	auipc	ra,0xffffd
    800049c2:	75c080e7          	jalr	1884(ra) # 8000211a <argstr>
    return -1;
    800049c6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049c8:	10054263          	bltz	a0,80004acc <sys_link+0x13c>
  begin_op();
    800049cc:	fffff097          	auipc	ra,0xfffff
    800049d0:	d2e080e7          	jalr	-722(ra) # 800036fa <begin_op>
  if((ip = namei(old)) == 0){
    800049d4:	ed040513          	addi	a0,s0,-304
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	b06080e7          	jalr	-1274(ra) # 800034de <namei>
    800049e0:	84aa                	mv	s1,a0
    800049e2:	c551                	beqz	a0,80004a6e <sys_link+0xde>
  ilock(ip);
    800049e4:	ffffe097          	auipc	ra,0xffffe
    800049e8:	344080e7          	jalr	836(ra) # 80002d28 <ilock>
  if(ip->type == T_DIR){
    800049ec:	04449703          	lh	a4,68(s1)
    800049f0:	4785                	li	a5,1
    800049f2:	08f70463          	beq	a4,a5,80004a7a <sys_link+0xea>
  ip->nlink++;
    800049f6:	04a4d783          	lhu	a5,74(s1)
    800049fa:	2785                	addiw	a5,a5,1
    800049fc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a00:	8526                	mv	a0,s1
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	25c080e7          	jalr	604(ra) # 80002c5e <iupdate>
  iunlock(ip);
    80004a0a:	8526                	mv	a0,s1
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	3de080e7          	jalr	990(ra) # 80002dea <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a14:	fd040593          	addi	a1,s0,-48
    80004a18:	f5040513          	addi	a0,s0,-176
    80004a1c:	fffff097          	auipc	ra,0xfffff
    80004a20:	ae0080e7          	jalr	-1312(ra) # 800034fc <nameiparent>
    80004a24:	892a                	mv	s2,a0
    80004a26:	c935                	beqz	a0,80004a9a <sys_link+0x10a>
  ilock(dp);
    80004a28:	ffffe097          	auipc	ra,0xffffe
    80004a2c:	300080e7          	jalr	768(ra) # 80002d28 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a30:	00092703          	lw	a4,0(s2)
    80004a34:	409c                	lw	a5,0(s1)
    80004a36:	04f71d63          	bne	a4,a5,80004a90 <sys_link+0x100>
    80004a3a:	40d0                	lw	a2,4(s1)
    80004a3c:	fd040593          	addi	a1,s0,-48
    80004a40:	854a                	mv	a0,s2
    80004a42:	fffff097          	auipc	ra,0xfffff
    80004a46:	9da080e7          	jalr	-1574(ra) # 8000341c <dirlink>
    80004a4a:	04054363          	bltz	a0,80004a90 <sys_link+0x100>
  iunlockput(dp);
    80004a4e:	854a                	mv	a0,s2
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	53a080e7          	jalr	1338(ra) # 80002f8a <iunlockput>
  iput(ip);
    80004a58:	8526                	mv	a0,s1
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	488080e7          	jalr	1160(ra) # 80002ee2 <iput>
  end_op();
    80004a62:	fffff097          	auipc	ra,0xfffff
    80004a66:	d18080e7          	jalr	-744(ra) # 8000377a <end_op>
  return 0;
    80004a6a:	4781                	li	a5,0
    80004a6c:	a085                	j	80004acc <sys_link+0x13c>
    end_op();
    80004a6e:	fffff097          	auipc	ra,0xfffff
    80004a72:	d0c080e7          	jalr	-756(ra) # 8000377a <end_op>
    return -1;
    80004a76:	57fd                	li	a5,-1
    80004a78:	a891                	j	80004acc <sys_link+0x13c>
    iunlockput(ip);
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	50e080e7          	jalr	1294(ra) # 80002f8a <iunlockput>
    end_op();
    80004a84:	fffff097          	auipc	ra,0xfffff
    80004a88:	cf6080e7          	jalr	-778(ra) # 8000377a <end_op>
    return -1;
    80004a8c:	57fd                	li	a5,-1
    80004a8e:	a83d                	j	80004acc <sys_link+0x13c>
    iunlockput(dp);
    80004a90:	854a                	mv	a0,s2
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	4f8080e7          	jalr	1272(ra) # 80002f8a <iunlockput>
  ilock(ip);
    80004a9a:	8526                	mv	a0,s1
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	28c080e7          	jalr	652(ra) # 80002d28 <ilock>
  ip->nlink--;
    80004aa4:	04a4d783          	lhu	a5,74(s1)
    80004aa8:	37fd                	addiw	a5,a5,-1
    80004aaa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aae:	8526                	mv	a0,s1
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	1ae080e7          	jalr	430(ra) # 80002c5e <iupdate>
  iunlockput(ip);
    80004ab8:	8526                	mv	a0,s1
    80004aba:	ffffe097          	auipc	ra,0xffffe
    80004abe:	4d0080e7          	jalr	1232(ra) # 80002f8a <iunlockput>
  end_op();
    80004ac2:	fffff097          	auipc	ra,0xfffff
    80004ac6:	cb8080e7          	jalr	-840(ra) # 8000377a <end_op>
  return -1;
    80004aca:	57fd                	li	a5,-1
}
    80004acc:	853e                	mv	a0,a5
    80004ace:	70b2                	ld	ra,296(sp)
    80004ad0:	7412                	ld	s0,288(sp)
    80004ad2:	64f2                	ld	s1,280(sp)
    80004ad4:	6952                	ld	s2,272(sp)
    80004ad6:	6155                	addi	sp,sp,304
    80004ad8:	8082                	ret

0000000080004ada <sys_unlink>:
{
    80004ada:	7151                	addi	sp,sp,-240
    80004adc:	f586                	sd	ra,232(sp)
    80004ade:	f1a2                	sd	s0,224(sp)
    80004ae0:	eda6                	sd	s1,216(sp)
    80004ae2:	e9ca                	sd	s2,208(sp)
    80004ae4:	e5ce                	sd	s3,200(sp)
    80004ae6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ae8:	08000613          	li	a2,128
    80004aec:	f3040593          	addi	a1,s0,-208
    80004af0:	4501                	li	a0,0
    80004af2:	ffffd097          	auipc	ra,0xffffd
    80004af6:	628080e7          	jalr	1576(ra) # 8000211a <argstr>
    80004afa:	18054163          	bltz	a0,80004c7c <sys_unlink+0x1a2>
  begin_op();
    80004afe:	fffff097          	auipc	ra,0xfffff
    80004b02:	bfc080e7          	jalr	-1028(ra) # 800036fa <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b06:	fb040593          	addi	a1,s0,-80
    80004b0a:	f3040513          	addi	a0,s0,-208
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	9ee080e7          	jalr	-1554(ra) # 800034fc <nameiparent>
    80004b16:	84aa                	mv	s1,a0
    80004b18:	c979                	beqz	a0,80004bee <sys_unlink+0x114>
  ilock(dp);
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	20e080e7          	jalr	526(ra) # 80002d28 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b22:	00004597          	auipc	a1,0x4
    80004b26:	bd658593          	addi	a1,a1,-1066 # 800086f8 <syscalls+0x2f8>
    80004b2a:	fb040513          	addi	a0,s0,-80
    80004b2e:	ffffe097          	auipc	ra,0xffffe
    80004b32:	6c4080e7          	jalr	1732(ra) # 800031f2 <namecmp>
    80004b36:	14050a63          	beqz	a0,80004c8a <sys_unlink+0x1b0>
    80004b3a:	00004597          	auipc	a1,0x4
    80004b3e:	bc658593          	addi	a1,a1,-1082 # 80008700 <syscalls+0x300>
    80004b42:	fb040513          	addi	a0,s0,-80
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	6ac080e7          	jalr	1708(ra) # 800031f2 <namecmp>
    80004b4e:	12050e63          	beqz	a0,80004c8a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b52:	f2c40613          	addi	a2,s0,-212
    80004b56:	fb040593          	addi	a1,s0,-80
    80004b5a:	8526                	mv	a0,s1
    80004b5c:	ffffe097          	auipc	ra,0xffffe
    80004b60:	6b0080e7          	jalr	1712(ra) # 8000320c <dirlookup>
    80004b64:	892a                	mv	s2,a0
    80004b66:	12050263          	beqz	a0,80004c8a <sys_unlink+0x1b0>
  ilock(ip);
    80004b6a:	ffffe097          	auipc	ra,0xffffe
    80004b6e:	1be080e7          	jalr	446(ra) # 80002d28 <ilock>
  if(ip->nlink < 1)
    80004b72:	04a91783          	lh	a5,74(s2)
    80004b76:	08f05263          	blez	a5,80004bfa <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b7a:	04491703          	lh	a4,68(s2)
    80004b7e:	4785                	li	a5,1
    80004b80:	08f70563          	beq	a4,a5,80004c0a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b84:	4641                	li	a2,16
    80004b86:	4581                	li	a1,0
    80004b88:	fc040513          	addi	a0,s0,-64
    80004b8c:	ffffb097          	auipc	ra,0xffffb
    80004b90:	5ec080e7          	jalr	1516(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b94:	4741                	li	a4,16
    80004b96:	f2c42683          	lw	a3,-212(s0)
    80004b9a:	fc040613          	addi	a2,s0,-64
    80004b9e:	4581                	li	a1,0
    80004ba0:	8526                	mv	a0,s1
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	532080e7          	jalr	1330(ra) # 800030d4 <writei>
    80004baa:	47c1                	li	a5,16
    80004bac:	0af51563          	bne	a0,a5,80004c56 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bb0:	04491703          	lh	a4,68(s2)
    80004bb4:	4785                	li	a5,1
    80004bb6:	0af70863          	beq	a4,a5,80004c66 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bba:	8526                	mv	a0,s1
    80004bbc:	ffffe097          	auipc	ra,0xffffe
    80004bc0:	3ce080e7          	jalr	974(ra) # 80002f8a <iunlockput>
  ip->nlink--;
    80004bc4:	04a95783          	lhu	a5,74(s2)
    80004bc8:	37fd                	addiw	a5,a5,-1
    80004bca:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bce:	854a                	mv	a0,s2
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	08e080e7          	jalr	142(ra) # 80002c5e <iupdate>
  iunlockput(ip);
    80004bd8:	854a                	mv	a0,s2
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	3b0080e7          	jalr	944(ra) # 80002f8a <iunlockput>
  end_op();
    80004be2:	fffff097          	auipc	ra,0xfffff
    80004be6:	b98080e7          	jalr	-1128(ra) # 8000377a <end_op>
  return 0;
    80004bea:	4501                	li	a0,0
    80004bec:	a84d                	j	80004c9e <sys_unlink+0x1c4>
    end_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	b8c080e7          	jalr	-1140(ra) # 8000377a <end_op>
    return -1;
    80004bf6:	557d                	li	a0,-1
    80004bf8:	a05d                	j	80004c9e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bfa:	00004517          	auipc	a0,0x4
    80004bfe:	b2e50513          	addi	a0,a0,-1234 # 80008728 <syscalls+0x328>
    80004c02:	00001097          	auipc	ra,0x1
    80004c06:	1f6080e7          	jalr	502(ra) # 80005df8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c0a:	04c92703          	lw	a4,76(s2)
    80004c0e:	02000793          	li	a5,32
    80004c12:	f6e7f9e3          	bgeu	a5,a4,80004b84 <sys_unlink+0xaa>
    80004c16:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c1a:	4741                	li	a4,16
    80004c1c:	86ce                	mv	a3,s3
    80004c1e:	f1840613          	addi	a2,s0,-232
    80004c22:	4581                	li	a1,0
    80004c24:	854a                	mv	a0,s2
    80004c26:	ffffe097          	auipc	ra,0xffffe
    80004c2a:	3b6080e7          	jalr	950(ra) # 80002fdc <readi>
    80004c2e:	47c1                	li	a5,16
    80004c30:	00f51b63          	bne	a0,a5,80004c46 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c34:	f1845783          	lhu	a5,-232(s0)
    80004c38:	e7a1                	bnez	a5,80004c80 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c3a:	29c1                	addiw	s3,s3,16
    80004c3c:	04c92783          	lw	a5,76(s2)
    80004c40:	fcf9ede3          	bltu	s3,a5,80004c1a <sys_unlink+0x140>
    80004c44:	b781                	j	80004b84 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c46:	00004517          	auipc	a0,0x4
    80004c4a:	afa50513          	addi	a0,a0,-1286 # 80008740 <syscalls+0x340>
    80004c4e:	00001097          	auipc	ra,0x1
    80004c52:	1aa080e7          	jalr	426(ra) # 80005df8 <panic>
    panic("unlink: writei");
    80004c56:	00004517          	auipc	a0,0x4
    80004c5a:	b0250513          	addi	a0,a0,-1278 # 80008758 <syscalls+0x358>
    80004c5e:	00001097          	auipc	ra,0x1
    80004c62:	19a080e7          	jalr	410(ra) # 80005df8 <panic>
    dp->nlink--;
    80004c66:	04a4d783          	lhu	a5,74(s1)
    80004c6a:	37fd                	addiw	a5,a5,-1
    80004c6c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c70:	8526                	mv	a0,s1
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	fec080e7          	jalr	-20(ra) # 80002c5e <iupdate>
    80004c7a:	b781                	j	80004bba <sys_unlink+0xe0>
    return -1;
    80004c7c:	557d                	li	a0,-1
    80004c7e:	a005                	j	80004c9e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c80:	854a                	mv	a0,s2
    80004c82:	ffffe097          	auipc	ra,0xffffe
    80004c86:	308080e7          	jalr	776(ra) # 80002f8a <iunlockput>
  iunlockput(dp);
    80004c8a:	8526                	mv	a0,s1
    80004c8c:	ffffe097          	auipc	ra,0xffffe
    80004c90:	2fe080e7          	jalr	766(ra) # 80002f8a <iunlockput>
  end_op();
    80004c94:	fffff097          	auipc	ra,0xfffff
    80004c98:	ae6080e7          	jalr	-1306(ra) # 8000377a <end_op>
  return -1;
    80004c9c:	557d                	li	a0,-1
}
    80004c9e:	70ae                	ld	ra,232(sp)
    80004ca0:	740e                	ld	s0,224(sp)
    80004ca2:	64ee                	ld	s1,216(sp)
    80004ca4:	694e                	ld	s2,208(sp)
    80004ca6:	69ae                	ld	s3,200(sp)
    80004ca8:	616d                	addi	sp,sp,240
    80004caa:	8082                	ret

0000000080004cac <sys_open>:

uint64
sys_open(void)
{
    80004cac:	7131                	addi	sp,sp,-192
    80004cae:	fd06                	sd	ra,184(sp)
    80004cb0:	f922                	sd	s0,176(sp)
    80004cb2:	f526                	sd	s1,168(sp)
    80004cb4:	f14a                	sd	s2,160(sp)
    80004cb6:	ed4e                	sd	s3,152(sp)
    80004cb8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cba:	08000613          	li	a2,128
    80004cbe:	f5040593          	addi	a1,s0,-176
    80004cc2:	4501                	li	a0,0
    80004cc4:	ffffd097          	auipc	ra,0xffffd
    80004cc8:	456080e7          	jalr	1110(ra) # 8000211a <argstr>
    return -1;
    80004ccc:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cce:	0c054163          	bltz	a0,80004d90 <sys_open+0xe4>
    80004cd2:	f4c40593          	addi	a1,s0,-180
    80004cd6:	4505                	li	a0,1
    80004cd8:	ffffd097          	auipc	ra,0xffffd
    80004cdc:	3fe080e7          	jalr	1022(ra) # 800020d6 <argint>
    80004ce0:	0a054863          	bltz	a0,80004d90 <sys_open+0xe4>

  begin_op();
    80004ce4:	fffff097          	auipc	ra,0xfffff
    80004ce8:	a16080e7          	jalr	-1514(ra) # 800036fa <begin_op>

  if(omode & O_CREATE){
    80004cec:	f4c42783          	lw	a5,-180(s0)
    80004cf0:	2007f793          	andi	a5,a5,512
    80004cf4:	cbdd                	beqz	a5,80004daa <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cf6:	4681                	li	a3,0
    80004cf8:	4601                	li	a2,0
    80004cfa:	4589                	li	a1,2
    80004cfc:	f5040513          	addi	a0,s0,-176
    80004d00:	00000097          	auipc	ra,0x0
    80004d04:	972080e7          	jalr	-1678(ra) # 80004672 <create>
    80004d08:	892a                	mv	s2,a0
    if(ip == 0){
    80004d0a:	c959                	beqz	a0,80004da0 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d0c:	04491703          	lh	a4,68(s2)
    80004d10:	478d                	li	a5,3
    80004d12:	00f71763          	bne	a4,a5,80004d20 <sys_open+0x74>
    80004d16:	04695703          	lhu	a4,70(s2)
    80004d1a:	47a5                	li	a5,9
    80004d1c:	0ce7ec63          	bltu	a5,a4,80004df4 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d20:	fffff097          	auipc	ra,0xfffff
    80004d24:	dea080e7          	jalr	-534(ra) # 80003b0a <filealloc>
    80004d28:	89aa                	mv	s3,a0
    80004d2a:	10050263          	beqz	a0,80004e2e <sys_open+0x182>
    80004d2e:	00000097          	auipc	ra,0x0
    80004d32:	902080e7          	jalr	-1790(ra) # 80004630 <fdalloc>
    80004d36:	84aa                	mv	s1,a0
    80004d38:	0e054663          	bltz	a0,80004e24 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d3c:	04491703          	lh	a4,68(s2)
    80004d40:	478d                	li	a5,3
    80004d42:	0cf70463          	beq	a4,a5,80004e0a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d46:	4789                	li	a5,2
    80004d48:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d4c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d50:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d54:	f4c42783          	lw	a5,-180(s0)
    80004d58:	0017c713          	xori	a4,a5,1
    80004d5c:	8b05                	andi	a4,a4,1
    80004d5e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d62:	0037f713          	andi	a4,a5,3
    80004d66:	00e03733          	snez	a4,a4
    80004d6a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d6e:	4007f793          	andi	a5,a5,1024
    80004d72:	c791                	beqz	a5,80004d7e <sys_open+0xd2>
    80004d74:	04491703          	lh	a4,68(s2)
    80004d78:	4789                	li	a5,2
    80004d7a:	08f70f63          	beq	a4,a5,80004e18 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d7e:	854a                	mv	a0,s2
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	06a080e7          	jalr	106(ra) # 80002dea <iunlock>
  end_op();
    80004d88:	fffff097          	auipc	ra,0xfffff
    80004d8c:	9f2080e7          	jalr	-1550(ra) # 8000377a <end_op>

  return fd;
}
    80004d90:	8526                	mv	a0,s1
    80004d92:	70ea                	ld	ra,184(sp)
    80004d94:	744a                	ld	s0,176(sp)
    80004d96:	74aa                	ld	s1,168(sp)
    80004d98:	790a                	ld	s2,160(sp)
    80004d9a:	69ea                	ld	s3,152(sp)
    80004d9c:	6129                	addi	sp,sp,192
    80004d9e:	8082                	ret
      end_op();
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	9da080e7          	jalr	-1574(ra) # 8000377a <end_op>
      return -1;
    80004da8:	b7e5                	j	80004d90 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004daa:	f5040513          	addi	a0,s0,-176
    80004dae:	ffffe097          	auipc	ra,0xffffe
    80004db2:	730080e7          	jalr	1840(ra) # 800034de <namei>
    80004db6:	892a                	mv	s2,a0
    80004db8:	c905                	beqz	a0,80004de8 <sys_open+0x13c>
    ilock(ip);
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	f6e080e7          	jalr	-146(ra) # 80002d28 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dc2:	04491703          	lh	a4,68(s2)
    80004dc6:	4785                	li	a5,1
    80004dc8:	f4f712e3          	bne	a4,a5,80004d0c <sys_open+0x60>
    80004dcc:	f4c42783          	lw	a5,-180(s0)
    80004dd0:	dba1                	beqz	a5,80004d20 <sys_open+0x74>
      iunlockput(ip);
    80004dd2:	854a                	mv	a0,s2
    80004dd4:	ffffe097          	auipc	ra,0xffffe
    80004dd8:	1b6080e7          	jalr	438(ra) # 80002f8a <iunlockput>
      end_op();
    80004ddc:	fffff097          	auipc	ra,0xfffff
    80004de0:	99e080e7          	jalr	-1634(ra) # 8000377a <end_op>
      return -1;
    80004de4:	54fd                	li	s1,-1
    80004de6:	b76d                	j	80004d90 <sys_open+0xe4>
      end_op();
    80004de8:	fffff097          	auipc	ra,0xfffff
    80004dec:	992080e7          	jalr	-1646(ra) # 8000377a <end_op>
      return -1;
    80004df0:	54fd                	li	s1,-1
    80004df2:	bf79                	j	80004d90 <sys_open+0xe4>
    iunlockput(ip);
    80004df4:	854a                	mv	a0,s2
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	194080e7          	jalr	404(ra) # 80002f8a <iunlockput>
    end_op();
    80004dfe:	fffff097          	auipc	ra,0xfffff
    80004e02:	97c080e7          	jalr	-1668(ra) # 8000377a <end_op>
    return -1;
    80004e06:	54fd                	li	s1,-1
    80004e08:	b761                	j	80004d90 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e0a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e0e:	04691783          	lh	a5,70(s2)
    80004e12:	02f99223          	sh	a5,36(s3)
    80004e16:	bf2d                	j	80004d50 <sys_open+0xa4>
    itrunc(ip);
    80004e18:	854a                	mv	a0,s2
    80004e1a:	ffffe097          	auipc	ra,0xffffe
    80004e1e:	01c080e7          	jalr	28(ra) # 80002e36 <itrunc>
    80004e22:	bfb1                	j	80004d7e <sys_open+0xd2>
      fileclose(f);
    80004e24:	854e                	mv	a0,s3
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	da0080e7          	jalr	-608(ra) # 80003bc6 <fileclose>
    iunlockput(ip);
    80004e2e:	854a                	mv	a0,s2
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	15a080e7          	jalr	346(ra) # 80002f8a <iunlockput>
    end_op();
    80004e38:	fffff097          	auipc	ra,0xfffff
    80004e3c:	942080e7          	jalr	-1726(ra) # 8000377a <end_op>
    return -1;
    80004e40:	54fd                	li	s1,-1
    80004e42:	b7b9                	j	80004d90 <sys_open+0xe4>

0000000080004e44 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e44:	7175                	addi	sp,sp,-144
    80004e46:	e506                	sd	ra,136(sp)
    80004e48:	e122                	sd	s0,128(sp)
    80004e4a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e4c:	fffff097          	auipc	ra,0xfffff
    80004e50:	8ae080e7          	jalr	-1874(ra) # 800036fa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e54:	08000613          	li	a2,128
    80004e58:	f7040593          	addi	a1,s0,-144
    80004e5c:	4501                	li	a0,0
    80004e5e:	ffffd097          	auipc	ra,0xffffd
    80004e62:	2bc080e7          	jalr	700(ra) # 8000211a <argstr>
    80004e66:	02054963          	bltz	a0,80004e98 <sys_mkdir+0x54>
    80004e6a:	4681                	li	a3,0
    80004e6c:	4601                	li	a2,0
    80004e6e:	4585                	li	a1,1
    80004e70:	f7040513          	addi	a0,s0,-144
    80004e74:	fffff097          	auipc	ra,0xfffff
    80004e78:	7fe080e7          	jalr	2046(ra) # 80004672 <create>
    80004e7c:	cd11                	beqz	a0,80004e98 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	10c080e7          	jalr	268(ra) # 80002f8a <iunlockput>
  end_op();
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	8f4080e7          	jalr	-1804(ra) # 8000377a <end_op>
  return 0;
    80004e8e:	4501                	li	a0,0
}
    80004e90:	60aa                	ld	ra,136(sp)
    80004e92:	640a                	ld	s0,128(sp)
    80004e94:	6149                	addi	sp,sp,144
    80004e96:	8082                	ret
    end_op();
    80004e98:	fffff097          	auipc	ra,0xfffff
    80004e9c:	8e2080e7          	jalr	-1822(ra) # 8000377a <end_op>
    return -1;
    80004ea0:	557d                	li	a0,-1
    80004ea2:	b7fd                	j	80004e90 <sys_mkdir+0x4c>

0000000080004ea4 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ea4:	7135                	addi	sp,sp,-160
    80004ea6:	ed06                	sd	ra,152(sp)
    80004ea8:	e922                	sd	s0,144(sp)
    80004eaa:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004eac:	fffff097          	auipc	ra,0xfffff
    80004eb0:	84e080e7          	jalr	-1970(ra) # 800036fa <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eb4:	08000613          	li	a2,128
    80004eb8:	f7040593          	addi	a1,s0,-144
    80004ebc:	4501                	li	a0,0
    80004ebe:	ffffd097          	auipc	ra,0xffffd
    80004ec2:	25c080e7          	jalr	604(ra) # 8000211a <argstr>
    80004ec6:	04054a63          	bltz	a0,80004f1a <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004eca:	f6c40593          	addi	a1,s0,-148
    80004ece:	4505                	li	a0,1
    80004ed0:	ffffd097          	auipc	ra,0xffffd
    80004ed4:	206080e7          	jalr	518(ra) # 800020d6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ed8:	04054163          	bltz	a0,80004f1a <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004edc:	f6840593          	addi	a1,s0,-152
    80004ee0:	4509                	li	a0,2
    80004ee2:	ffffd097          	auipc	ra,0xffffd
    80004ee6:	1f4080e7          	jalr	500(ra) # 800020d6 <argint>
     argint(1, &major) < 0 ||
    80004eea:	02054863          	bltz	a0,80004f1a <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004eee:	f6841683          	lh	a3,-152(s0)
    80004ef2:	f6c41603          	lh	a2,-148(s0)
    80004ef6:	458d                	li	a1,3
    80004ef8:	f7040513          	addi	a0,s0,-144
    80004efc:	fffff097          	auipc	ra,0xfffff
    80004f00:	776080e7          	jalr	1910(ra) # 80004672 <create>
     argint(2, &minor) < 0 ||
    80004f04:	c919                	beqz	a0,80004f1a <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	084080e7          	jalr	132(ra) # 80002f8a <iunlockput>
  end_op();
    80004f0e:	fffff097          	auipc	ra,0xfffff
    80004f12:	86c080e7          	jalr	-1940(ra) # 8000377a <end_op>
  return 0;
    80004f16:	4501                	li	a0,0
    80004f18:	a031                	j	80004f24 <sys_mknod+0x80>
    end_op();
    80004f1a:	fffff097          	auipc	ra,0xfffff
    80004f1e:	860080e7          	jalr	-1952(ra) # 8000377a <end_op>
    return -1;
    80004f22:	557d                	li	a0,-1
}
    80004f24:	60ea                	ld	ra,152(sp)
    80004f26:	644a                	ld	s0,144(sp)
    80004f28:	610d                	addi	sp,sp,160
    80004f2a:	8082                	ret

0000000080004f2c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f2c:	7135                	addi	sp,sp,-160
    80004f2e:	ed06                	sd	ra,152(sp)
    80004f30:	e922                	sd	s0,144(sp)
    80004f32:	e526                	sd	s1,136(sp)
    80004f34:	e14a                	sd	s2,128(sp)
    80004f36:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f38:	ffffc097          	auipc	ra,0xffffc
    80004f3c:	044080e7          	jalr	68(ra) # 80000f7c <myproc>
    80004f40:	892a                	mv	s2,a0
  
  begin_op();
    80004f42:	ffffe097          	auipc	ra,0xffffe
    80004f46:	7b8080e7          	jalr	1976(ra) # 800036fa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f4a:	08000613          	li	a2,128
    80004f4e:	f6040593          	addi	a1,s0,-160
    80004f52:	4501                	li	a0,0
    80004f54:	ffffd097          	auipc	ra,0xffffd
    80004f58:	1c6080e7          	jalr	454(ra) # 8000211a <argstr>
    80004f5c:	04054b63          	bltz	a0,80004fb2 <sys_chdir+0x86>
    80004f60:	f6040513          	addi	a0,s0,-160
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	57a080e7          	jalr	1402(ra) # 800034de <namei>
    80004f6c:	84aa                	mv	s1,a0
    80004f6e:	c131                	beqz	a0,80004fb2 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f70:	ffffe097          	auipc	ra,0xffffe
    80004f74:	db8080e7          	jalr	-584(ra) # 80002d28 <ilock>
  if(ip->type != T_DIR){
    80004f78:	04449703          	lh	a4,68(s1)
    80004f7c:	4785                	li	a5,1
    80004f7e:	04f71063          	bne	a4,a5,80004fbe <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f82:	8526                	mv	a0,s1
    80004f84:	ffffe097          	auipc	ra,0xffffe
    80004f88:	e66080e7          	jalr	-410(ra) # 80002dea <iunlock>
  iput(p->cwd);
    80004f8c:	15893503          	ld	a0,344(s2)
    80004f90:	ffffe097          	auipc	ra,0xffffe
    80004f94:	f52080e7          	jalr	-174(ra) # 80002ee2 <iput>
  end_op();
    80004f98:	ffffe097          	auipc	ra,0xffffe
    80004f9c:	7e2080e7          	jalr	2018(ra) # 8000377a <end_op>
  p->cwd = ip;
    80004fa0:	14993c23          	sd	s1,344(s2)
  return 0;
    80004fa4:	4501                	li	a0,0
}
    80004fa6:	60ea                	ld	ra,152(sp)
    80004fa8:	644a                	ld	s0,144(sp)
    80004faa:	64aa                	ld	s1,136(sp)
    80004fac:	690a                	ld	s2,128(sp)
    80004fae:	610d                	addi	sp,sp,160
    80004fb0:	8082                	ret
    end_op();
    80004fb2:	ffffe097          	auipc	ra,0xffffe
    80004fb6:	7c8080e7          	jalr	1992(ra) # 8000377a <end_op>
    return -1;
    80004fba:	557d                	li	a0,-1
    80004fbc:	b7ed                	j	80004fa6 <sys_chdir+0x7a>
    iunlockput(ip);
    80004fbe:	8526                	mv	a0,s1
    80004fc0:	ffffe097          	auipc	ra,0xffffe
    80004fc4:	fca080e7          	jalr	-54(ra) # 80002f8a <iunlockput>
    end_op();
    80004fc8:	ffffe097          	auipc	ra,0xffffe
    80004fcc:	7b2080e7          	jalr	1970(ra) # 8000377a <end_op>
    return -1;
    80004fd0:	557d                	li	a0,-1
    80004fd2:	bfd1                	j	80004fa6 <sys_chdir+0x7a>

0000000080004fd4 <sys_exec>:

uint64
sys_exec(void)
{
    80004fd4:	7145                	addi	sp,sp,-464
    80004fd6:	e786                	sd	ra,456(sp)
    80004fd8:	e3a2                	sd	s0,448(sp)
    80004fda:	ff26                	sd	s1,440(sp)
    80004fdc:	fb4a                	sd	s2,432(sp)
    80004fde:	f74e                	sd	s3,424(sp)
    80004fe0:	f352                	sd	s4,416(sp)
    80004fe2:	ef56                	sd	s5,408(sp)
    80004fe4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fe6:	08000613          	li	a2,128
    80004fea:	f4040593          	addi	a1,s0,-192
    80004fee:	4501                	li	a0,0
    80004ff0:	ffffd097          	auipc	ra,0xffffd
    80004ff4:	12a080e7          	jalr	298(ra) # 8000211a <argstr>
    return -1;
    80004ff8:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ffa:	0c054a63          	bltz	a0,800050ce <sys_exec+0xfa>
    80004ffe:	e3840593          	addi	a1,s0,-456
    80005002:	4505                	li	a0,1
    80005004:	ffffd097          	auipc	ra,0xffffd
    80005008:	0f4080e7          	jalr	244(ra) # 800020f8 <argaddr>
    8000500c:	0c054163          	bltz	a0,800050ce <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005010:	10000613          	li	a2,256
    80005014:	4581                	li	a1,0
    80005016:	e4040513          	addi	a0,s0,-448
    8000501a:	ffffb097          	auipc	ra,0xffffb
    8000501e:	15e080e7          	jalr	350(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005022:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005026:	89a6                	mv	s3,s1
    80005028:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000502a:	02000a13          	li	s4,32
    8000502e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005032:	00391513          	slli	a0,s2,0x3
    80005036:	e3040593          	addi	a1,s0,-464
    8000503a:	e3843783          	ld	a5,-456(s0)
    8000503e:	953e                	add	a0,a0,a5
    80005040:	ffffd097          	auipc	ra,0xffffd
    80005044:	ffc080e7          	jalr	-4(ra) # 8000203c <fetchaddr>
    80005048:	02054a63          	bltz	a0,8000507c <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000504c:	e3043783          	ld	a5,-464(s0)
    80005050:	c3b9                	beqz	a5,80005096 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005052:	ffffb097          	auipc	ra,0xffffb
    80005056:	0c6080e7          	jalr	198(ra) # 80000118 <kalloc>
    8000505a:	85aa                	mv	a1,a0
    8000505c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005060:	cd11                	beqz	a0,8000507c <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005062:	6605                	lui	a2,0x1
    80005064:	e3043503          	ld	a0,-464(s0)
    80005068:	ffffd097          	auipc	ra,0xffffd
    8000506c:	026080e7          	jalr	38(ra) # 8000208e <fetchstr>
    80005070:	00054663          	bltz	a0,8000507c <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005074:	0905                	addi	s2,s2,1
    80005076:	09a1                	addi	s3,s3,8
    80005078:	fb491be3          	bne	s2,s4,8000502e <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000507c:	10048913          	addi	s2,s1,256
    80005080:	6088                	ld	a0,0(s1)
    80005082:	c529                	beqz	a0,800050cc <sys_exec+0xf8>
    kfree(argv[i]);
    80005084:	ffffb097          	auipc	ra,0xffffb
    80005088:	f98080e7          	jalr	-104(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000508c:	04a1                	addi	s1,s1,8
    8000508e:	ff2499e3          	bne	s1,s2,80005080 <sys_exec+0xac>
  return -1;
    80005092:	597d                	li	s2,-1
    80005094:	a82d                	j	800050ce <sys_exec+0xfa>
      argv[i] = 0;
    80005096:	0a8e                	slli	s5,s5,0x3
    80005098:	fc040793          	addi	a5,s0,-64
    8000509c:	9abe                	add	s5,s5,a5
    8000509e:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050a2:	e4040593          	addi	a1,s0,-448
    800050a6:	f4040513          	addi	a0,s0,-192
    800050aa:	fffff097          	auipc	ra,0xfffff
    800050ae:	17c080e7          	jalr	380(ra) # 80004226 <exec>
    800050b2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b4:	10048993          	addi	s3,s1,256
    800050b8:	6088                	ld	a0,0(s1)
    800050ba:	c911                	beqz	a0,800050ce <sys_exec+0xfa>
    kfree(argv[i]);
    800050bc:	ffffb097          	auipc	ra,0xffffb
    800050c0:	f60080e7          	jalr	-160(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c4:	04a1                	addi	s1,s1,8
    800050c6:	ff3499e3          	bne	s1,s3,800050b8 <sys_exec+0xe4>
    800050ca:	a011                	j	800050ce <sys_exec+0xfa>
  return -1;
    800050cc:	597d                	li	s2,-1
}
    800050ce:	854a                	mv	a0,s2
    800050d0:	60be                	ld	ra,456(sp)
    800050d2:	641e                	ld	s0,448(sp)
    800050d4:	74fa                	ld	s1,440(sp)
    800050d6:	795a                	ld	s2,432(sp)
    800050d8:	79ba                	ld	s3,424(sp)
    800050da:	7a1a                	ld	s4,416(sp)
    800050dc:	6afa                	ld	s5,408(sp)
    800050de:	6179                	addi	sp,sp,464
    800050e0:	8082                	ret

00000000800050e2 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050e2:	7139                	addi	sp,sp,-64
    800050e4:	fc06                	sd	ra,56(sp)
    800050e6:	f822                	sd	s0,48(sp)
    800050e8:	f426                	sd	s1,40(sp)
    800050ea:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050ec:	ffffc097          	auipc	ra,0xffffc
    800050f0:	e90080e7          	jalr	-368(ra) # 80000f7c <myproc>
    800050f4:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050f6:	fd840593          	addi	a1,s0,-40
    800050fa:	4501                	li	a0,0
    800050fc:	ffffd097          	auipc	ra,0xffffd
    80005100:	ffc080e7          	jalr	-4(ra) # 800020f8 <argaddr>
    return -1;
    80005104:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005106:	0e054063          	bltz	a0,800051e6 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000510a:	fc840593          	addi	a1,s0,-56
    8000510e:	fd040513          	addi	a0,s0,-48
    80005112:	fffff097          	auipc	ra,0xfffff
    80005116:	de4080e7          	jalr	-540(ra) # 80003ef6 <pipealloc>
    return -1;
    8000511a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000511c:	0c054563          	bltz	a0,800051e6 <sys_pipe+0x104>
  fd0 = -1;
    80005120:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005124:	fd043503          	ld	a0,-48(s0)
    80005128:	fffff097          	auipc	ra,0xfffff
    8000512c:	508080e7          	jalr	1288(ra) # 80004630 <fdalloc>
    80005130:	fca42223          	sw	a0,-60(s0)
    80005134:	08054c63          	bltz	a0,800051cc <sys_pipe+0xea>
    80005138:	fc843503          	ld	a0,-56(s0)
    8000513c:	fffff097          	auipc	ra,0xfffff
    80005140:	4f4080e7          	jalr	1268(ra) # 80004630 <fdalloc>
    80005144:	fca42023          	sw	a0,-64(s0)
    80005148:	06054863          	bltz	a0,800051b8 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000514c:	4691                	li	a3,4
    8000514e:	fc440613          	addi	a2,s0,-60
    80005152:	fd843583          	ld	a1,-40(s0)
    80005156:	68a8                	ld	a0,80(s1)
    80005158:	ffffc097          	auipc	ra,0xffffc
    8000515c:	9b2080e7          	jalr	-1614(ra) # 80000b0a <copyout>
    80005160:	02054063          	bltz	a0,80005180 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005164:	4691                	li	a3,4
    80005166:	fc040613          	addi	a2,s0,-64
    8000516a:	fd843583          	ld	a1,-40(s0)
    8000516e:	0591                	addi	a1,a1,4
    80005170:	68a8                	ld	a0,80(s1)
    80005172:	ffffc097          	auipc	ra,0xffffc
    80005176:	998080e7          	jalr	-1640(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000517a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000517c:	06055563          	bgez	a0,800051e6 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005180:	fc442783          	lw	a5,-60(s0)
    80005184:	07e9                	addi	a5,a5,26
    80005186:	078e                	slli	a5,a5,0x3
    80005188:	97a6                	add	a5,a5,s1
    8000518a:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    8000518e:	fc042503          	lw	a0,-64(s0)
    80005192:	0569                	addi	a0,a0,26
    80005194:	050e                	slli	a0,a0,0x3
    80005196:	9526                	add	a0,a0,s1
    80005198:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000519c:	fd043503          	ld	a0,-48(s0)
    800051a0:	fffff097          	auipc	ra,0xfffff
    800051a4:	a26080e7          	jalr	-1498(ra) # 80003bc6 <fileclose>
    fileclose(wf);
    800051a8:	fc843503          	ld	a0,-56(s0)
    800051ac:	fffff097          	auipc	ra,0xfffff
    800051b0:	a1a080e7          	jalr	-1510(ra) # 80003bc6 <fileclose>
    return -1;
    800051b4:	57fd                	li	a5,-1
    800051b6:	a805                	j	800051e6 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051b8:	fc442783          	lw	a5,-60(s0)
    800051bc:	0007c863          	bltz	a5,800051cc <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051c0:	01a78513          	addi	a0,a5,26
    800051c4:	050e                	slli	a0,a0,0x3
    800051c6:	9526                	add	a0,a0,s1
    800051c8:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800051cc:	fd043503          	ld	a0,-48(s0)
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	9f6080e7          	jalr	-1546(ra) # 80003bc6 <fileclose>
    fileclose(wf);
    800051d8:	fc843503          	ld	a0,-56(s0)
    800051dc:	fffff097          	auipc	ra,0xfffff
    800051e0:	9ea080e7          	jalr	-1558(ra) # 80003bc6 <fileclose>
    return -1;
    800051e4:	57fd                	li	a5,-1
}
    800051e6:	853e                	mv	a0,a5
    800051e8:	70e2                	ld	ra,56(sp)
    800051ea:	7442                	ld	s0,48(sp)
    800051ec:	74a2                	ld	s1,40(sp)
    800051ee:	6121                	addi	sp,sp,64
    800051f0:	8082                	ret
	...

0000000080005200 <kernelvec>:
    80005200:	7111                	addi	sp,sp,-256
    80005202:	e006                	sd	ra,0(sp)
    80005204:	e40a                	sd	sp,8(sp)
    80005206:	e80e                	sd	gp,16(sp)
    80005208:	ec12                	sd	tp,24(sp)
    8000520a:	f016                	sd	t0,32(sp)
    8000520c:	f41a                	sd	t1,40(sp)
    8000520e:	f81e                	sd	t2,48(sp)
    80005210:	fc22                	sd	s0,56(sp)
    80005212:	e0a6                	sd	s1,64(sp)
    80005214:	e4aa                	sd	a0,72(sp)
    80005216:	e8ae                	sd	a1,80(sp)
    80005218:	ecb2                	sd	a2,88(sp)
    8000521a:	f0b6                	sd	a3,96(sp)
    8000521c:	f4ba                	sd	a4,104(sp)
    8000521e:	f8be                	sd	a5,112(sp)
    80005220:	fcc2                	sd	a6,120(sp)
    80005222:	e146                	sd	a7,128(sp)
    80005224:	e54a                	sd	s2,136(sp)
    80005226:	e94e                	sd	s3,144(sp)
    80005228:	ed52                	sd	s4,152(sp)
    8000522a:	f156                	sd	s5,160(sp)
    8000522c:	f55a                	sd	s6,168(sp)
    8000522e:	f95e                	sd	s7,176(sp)
    80005230:	fd62                	sd	s8,184(sp)
    80005232:	e1e6                	sd	s9,192(sp)
    80005234:	e5ea                	sd	s10,200(sp)
    80005236:	e9ee                	sd	s11,208(sp)
    80005238:	edf2                	sd	t3,216(sp)
    8000523a:	f1f6                	sd	t4,224(sp)
    8000523c:	f5fa                	sd	t5,232(sp)
    8000523e:	f9fe                	sd	t6,240(sp)
    80005240:	cc9fc0ef          	jal	ra,80001f08 <kerneltrap>
    80005244:	6082                	ld	ra,0(sp)
    80005246:	6122                	ld	sp,8(sp)
    80005248:	61c2                	ld	gp,16(sp)
    8000524a:	7282                	ld	t0,32(sp)
    8000524c:	7322                	ld	t1,40(sp)
    8000524e:	73c2                	ld	t2,48(sp)
    80005250:	7462                	ld	s0,56(sp)
    80005252:	6486                	ld	s1,64(sp)
    80005254:	6526                	ld	a0,72(sp)
    80005256:	65c6                	ld	a1,80(sp)
    80005258:	6666                	ld	a2,88(sp)
    8000525a:	7686                	ld	a3,96(sp)
    8000525c:	7726                	ld	a4,104(sp)
    8000525e:	77c6                	ld	a5,112(sp)
    80005260:	7866                	ld	a6,120(sp)
    80005262:	688a                	ld	a7,128(sp)
    80005264:	692a                	ld	s2,136(sp)
    80005266:	69ca                	ld	s3,144(sp)
    80005268:	6a6a                	ld	s4,152(sp)
    8000526a:	7a8a                	ld	s5,160(sp)
    8000526c:	7b2a                	ld	s6,168(sp)
    8000526e:	7bca                	ld	s7,176(sp)
    80005270:	7c6a                	ld	s8,184(sp)
    80005272:	6c8e                	ld	s9,192(sp)
    80005274:	6d2e                	ld	s10,200(sp)
    80005276:	6dce                	ld	s11,208(sp)
    80005278:	6e6e                	ld	t3,216(sp)
    8000527a:	7e8e                	ld	t4,224(sp)
    8000527c:	7f2e                	ld	t5,232(sp)
    8000527e:	7fce                	ld	t6,240(sp)
    80005280:	6111                	addi	sp,sp,256
    80005282:	10200073          	sret
    80005286:	00000013          	nop
    8000528a:	00000013          	nop
    8000528e:	0001                	nop

0000000080005290 <timervec>:
    80005290:	34051573          	csrrw	a0,mscratch,a0
    80005294:	e10c                	sd	a1,0(a0)
    80005296:	e510                	sd	a2,8(a0)
    80005298:	e914                	sd	a3,16(a0)
    8000529a:	6d0c                	ld	a1,24(a0)
    8000529c:	7110                	ld	a2,32(a0)
    8000529e:	6194                	ld	a3,0(a1)
    800052a0:	96b2                	add	a3,a3,a2
    800052a2:	e194                	sd	a3,0(a1)
    800052a4:	4589                	li	a1,2
    800052a6:	14459073          	csrw	sip,a1
    800052aa:	6914                	ld	a3,16(a0)
    800052ac:	6510                	ld	a2,8(a0)
    800052ae:	610c                	ld	a1,0(a0)
    800052b0:	34051573          	csrrw	a0,mscratch,a0
    800052b4:	30200073          	mret
	...

00000000800052ba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ba:	1141                	addi	sp,sp,-16
    800052bc:	e422                	sd	s0,8(sp)
    800052be:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052c0:	0c0007b7          	lui	a5,0xc000
    800052c4:	4705                	li	a4,1
    800052c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052c8:	c3d8                	sw	a4,4(a5)
}
    800052ca:	6422                	ld	s0,8(sp)
    800052cc:	0141                	addi	sp,sp,16
    800052ce:	8082                	ret

00000000800052d0 <plicinithart>:

void
plicinithart(void)
{
    800052d0:	1141                	addi	sp,sp,-16
    800052d2:	e406                	sd	ra,8(sp)
    800052d4:	e022                	sd	s0,0(sp)
    800052d6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052d8:	ffffc097          	auipc	ra,0xffffc
    800052dc:	c78080e7          	jalr	-904(ra) # 80000f50 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052e0:	0085171b          	slliw	a4,a0,0x8
    800052e4:	0c0027b7          	lui	a5,0xc002
    800052e8:	97ba                	add	a5,a5,a4
    800052ea:	40200713          	li	a4,1026
    800052ee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052f2:	00d5151b          	slliw	a0,a0,0xd
    800052f6:	0c2017b7          	lui	a5,0xc201
    800052fa:	953e                	add	a0,a0,a5
    800052fc:	00052023          	sw	zero,0(a0)
}
    80005300:	60a2                	ld	ra,8(sp)
    80005302:	6402                	ld	s0,0(sp)
    80005304:	0141                	addi	sp,sp,16
    80005306:	8082                	ret

0000000080005308 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005308:	1141                	addi	sp,sp,-16
    8000530a:	e406                	sd	ra,8(sp)
    8000530c:	e022                	sd	s0,0(sp)
    8000530e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005310:	ffffc097          	auipc	ra,0xffffc
    80005314:	c40080e7          	jalr	-960(ra) # 80000f50 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005318:	00d5179b          	slliw	a5,a0,0xd
    8000531c:	0c201537          	lui	a0,0xc201
    80005320:	953e                	add	a0,a0,a5
  return irq;
}
    80005322:	4148                	lw	a0,4(a0)
    80005324:	60a2                	ld	ra,8(sp)
    80005326:	6402                	ld	s0,0(sp)
    80005328:	0141                	addi	sp,sp,16
    8000532a:	8082                	ret

000000008000532c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000532c:	1101                	addi	sp,sp,-32
    8000532e:	ec06                	sd	ra,24(sp)
    80005330:	e822                	sd	s0,16(sp)
    80005332:	e426                	sd	s1,8(sp)
    80005334:	1000                	addi	s0,sp,32
    80005336:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005338:	ffffc097          	auipc	ra,0xffffc
    8000533c:	c18080e7          	jalr	-1000(ra) # 80000f50 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005340:	00d5151b          	slliw	a0,a0,0xd
    80005344:	0c2017b7          	lui	a5,0xc201
    80005348:	97aa                	add	a5,a5,a0
    8000534a:	c3c4                	sw	s1,4(a5)
}
    8000534c:	60e2                	ld	ra,24(sp)
    8000534e:	6442                	ld	s0,16(sp)
    80005350:	64a2                	ld	s1,8(sp)
    80005352:	6105                	addi	sp,sp,32
    80005354:	8082                	ret

0000000080005356 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005356:	1141                	addi	sp,sp,-16
    80005358:	e406                	sd	ra,8(sp)
    8000535a:	e022                	sd	s0,0(sp)
    8000535c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000535e:	479d                	li	a5,7
    80005360:	06a7c963          	blt	a5,a0,800053d2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005364:	00016797          	auipc	a5,0x16
    80005368:	c9c78793          	addi	a5,a5,-868 # 8001b000 <disk>
    8000536c:	00a78733          	add	a4,a5,a0
    80005370:	6789                	lui	a5,0x2
    80005372:	97ba                	add	a5,a5,a4
    80005374:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005378:	e7ad                	bnez	a5,800053e2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000537a:	00451793          	slli	a5,a0,0x4
    8000537e:	00018717          	auipc	a4,0x18
    80005382:	c8270713          	addi	a4,a4,-894 # 8001d000 <disk+0x2000>
    80005386:	6314                	ld	a3,0(a4)
    80005388:	96be                	add	a3,a3,a5
    8000538a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000538e:	6314                	ld	a3,0(a4)
    80005390:	96be                	add	a3,a3,a5
    80005392:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005396:	6314                	ld	a3,0(a4)
    80005398:	96be                	add	a3,a3,a5
    8000539a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000539e:	6318                	ld	a4,0(a4)
    800053a0:	97ba                	add	a5,a5,a4
    800053a2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053a6:	00016797          	auipc	a5,0x16
    800053aa:	c5a78793          	addi	a5,a5,-934 # 8001b000 <disk>
    800053ae:	97aa                	add	a5,a5,a0
    800053b0:	6509                	lui	a0,0x2
    800053b2:	953e                	add	a0,a0,a5
    800053b4:	4785                	li	a5,1
    800053b6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053ba:	00018517          	auipc	a0,0x18
    800053be:	c5e50513          	addi	a0,a0,-930 # 8001d018 <disk+0x2018>
    800053c2:	ffffc097          	auipc	ra,0xffffc
    800053c6:	4b0080e7          	jalr	1200(ra) # 80001872 <wakeup>
}
    800053ca:	60a2                	ld	ra,8(sp)
    800053cc:	6402                	ld	s0,0(sp)
    800053ce:	0141                	addi	sp,sp,16
    800053d0:	8082                	ret
    panic("free_desc 1");
    800053d2:	00003517          	auipc	a0,0x3
    800053d6:	39650513          	addi	a0,a0,918 # 80008768 <syscalls+0x368>
    800053da:	00001097          	auipc	ra,0x1
    800053de:	a1e080e7          	jalr	-1506(ra) # 80005df8 <panic>
    panic("free_desc 2");
    800053e2:	00003517          	auipc	a0,0x3
    800053e6:	39650513          	addi	a0,a0,918 # 80008778 <syscalls+0x378>
    800053ea:	00001097          	auipc	ra,0x1
    800053ee:	a0e080e7          	jalr	-1522(ra) # 80005df8 <panic>

00000000800053f2 <virtio_disk_init>:
{
    800053f2:	1101                	addi	sp,sp,-32
    800053f4:	ec06                	sd	ra,24(sp)
    800053f6:	e822                	sd	s0,16(sp)
    800053f8:	e426                	sd	s1,8(sp)
    800053fa:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053fc:	00003597          	auipc	a1,0x3
    80005400:	38c58593          	addi	a1,a1,908 # 80008788 <syscalls+0x388>
    80005404:	00018517          	auipc	a0,0x18
    80005408:	d2450513          	addi	a0,a0,-732 # 8001d128 <disk+0x2128>
    8000540c:	00001097          	auipc	ra,0x1
    80005410:	ea6080e7          	jalr	-346(ra) # 800062b2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005414:	100017b7          	lui	a5,0x10001
    80005418:	4398                	lw	a4,0(a5)
    8000541a:	2701                	sext.w	a4,a4
    8000541c:	747277b7          	lui	a5,0x74727
    80005420:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005424:	0ef71163          	bne	a4,a5,80005506 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005428:	100017b7          	lui	a5,0x10001
    8000542c:	43dc                	lw	a5,4(a5)
    8000542e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005430:	4705                	li	a4,1
    80005432:	0ce79a63          	bne	a5,a4,80005506 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005436:	100017b7          	lui	a5,0x10001
    8000543a:	479c                	lw	a5,8(a5)
    8000543c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000543e:	4709                	li	a4,2
    80005440:	0ce79363          	bne	a5,a4,80005506 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005444:	100017b7          	lui	a5,0x10001
    80005448:	47d8                	lw	a4,12(a5)
    8000544a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000544c:	554d47b7          	lui	a5,0x554d4
    80005450:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005454:	0af71963          	bne	a4,a5,80005506 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005458:	100017b7          	lui	a5,0x10001
    8000545c:	4705                	li	a4,1
    8000545e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005460:	470d                	li	a4,3
    80005462:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005464:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005466:	c7ffe737          	lui	a4,0xc7ffe
    8000546a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000546e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005470:	2701                	sext.w	a4,a4
    80005472:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005474:	472d                	li	a4,11
    80005476:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005478:	473d                	li	a4,15
    8000547a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000547c:	6705                	lui	a4,0x1
    8000547e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005480:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005484:	5bdc                	lw	a5,52(a5)
    80005486:	2781                	sext.w	a5,a5
  if(max == 0)
    80005488:	c7d9                	beqz	a5,80005516 <virtio_disk_init+0x124>
  if(max < NUM)
    8000548a:	471d                	li	a4,7
    8000548c:	08f77d63          	bgeu	a4,a5,80005526 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005490:	100014b7          	lui	s1,0x10001
    80005494:	47a1                	li	a5,8
    80005496:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005498:	6609                	lui	a2,0x2
    8000549a:	4581                	li	a1,0
    8000549c:	00016517          	auipc	a0,0x16
    800054a0:	b6450513          	addi	a0,a0,-1180 # 8001b000 <disk>
    800054a4:	ffffb097          	auipc	ra,0xffffb
    800054a8:	cd4080e7          	jalr	-812(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054ac:	00016717          	auipc	a4,0x16
    800054b0:	b5470713          	addi	a4,a4,-1196 # 8001b000 <disk>
    800054b4:	00c75793          	srli	a5,a4,0xc
    800054b8:	2781                	sext.w	a5,a5
    800054ba:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054bc:	00018797          	auipc	a5,0x18
    800054c0:	b4478793          	addi	a5,a5,-1212 # 8001d000 <disk+0x2000>
    800054c4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054c6:	00016717          	auipc	a4,0x16
    800054ca:	bba70713          	addi	a4,a4,-1094 # 8001b080 <disk+0x80>
    800054ce:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054d0:	00017717          	auipc	a4,0x17
    800054d4:	b3070713          	addi	a4,a4,-1232 # 8001c000 <disk+0x1000>
    800054d8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054da:	4705                	li	a4,1
    800054dc:	00e78c23          	sb	a4,24(a5)
    800054e0:	00e78ca3          	sb	a4,25(a5)
    800054e4:	00e78d23          	sb	a4,26(a5)
    800054e8:	00e78da3          	sb	a4,27(a5)
    800054ec:	00e78e23          	sb	a4,28(a5)
    800054f0:	00e78ea3          	sb	a4,29(a5)
    800054f4:	00e78f23          	sb	a4,30(a5)
    800054f8:	00e78fa3          	sb	a4,31(a5)
}
    800054fc:	60e2                	ld	ra,24(sp)
    800054fe:	6442                	ld	s0,16(sp)
    80005500:	64a2                	ld	s1,8(sp)
    80005502:	6105                	addi	sp,sp,32
    80005504:	8082                	ret
    panic("could not find virtio disk");
    80005506:	00003517          	auipc	a0,0x3
    8000550a:	29250513          	addi	a0,a0,658 # 80008798 <syscalls+0x398>
    8000550e:	00001097          	auipc	ra,0x1
    80005512:	8ea080e7          	jalr	-1814(ra) # 80005df8 <panic>
    panic("virtio disk has no queue 0");
    80005516:	00003517          	auipc	a0,0x3
    8000551a:	2a250513          	addi	a0,a0,674 # 800087b8 <syscalls+0x3b8>
    8000551e:	00001097          	auipc	ra,0x1
    80005522:	8da080e7          	jalr	-1830(ra) # 80005df8 <panic>
    panic("virtio disk max queue too short");
    80005526:	00003517          	auipc	a0,0x3
    8000552a:	2b250513          	addi	a0,a0,690 # 800087d8 <syscalls+0x3d8>
    8000552e:	00001097          	auipc	ra,0x1
    80005532:	8ca080e7          	jalr	-1846(ra) # 80005df8 <panic>

0000000080005536 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005536:	7159                	addi	sp,sp,-112
    80005538:	f486                	sd	ra,104(sp)
    8000553a:	f0a2                	sd	s0,96(sp)
    8000553c:	eca6                	sd	s1,88(sp)
    8000553e:	e8ca                	sd	s2,80(sp)
    80005540:	e4ce                	sd	s3,72(sp)
    80005542:	e0d2                	sd	s4,64(sp)
    80005544:	fc56                	sd	s5,56(sp)
    80005546:	f85a                	sd	s6,48(sp)
    80005548:	f45e                	sd	s7,40(sp)
    8000554a:	f062                	sd	s8,32(sp)
    8000554c:	ec66                	sd	s9,24(sp)
    8000554e:	e86a                	sd	s10,16(sp)
    80005550:	1880                	addi	s0,sp,112
    80005552:	892a                	mv	s2,a0
    80005554:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005556:	00c52c83          	lw	s9,12(a0)
    8000555a:	001c9c9b          	slliw	s9,s9,0x1
    8000555e:	1c82                	slli	s9,s9,0x20
    80005560:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005564:	00018517          	auipc	a0,0x18
    80005568:	bc450513          	addi	a0,a0,-1084 # 8001d128 <disk+0x2128>
    8000556c:	00001097          	auipc	ra,0x1
    80005570:	dd6080e7          	jalr	-554(ra) # 80006342 <acquire>
  for(int i = 0; i < 3; i++){
    80005574:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005576:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005578:	00016b97          	auipc	s7,0x16
    8000557c:	a88b8b93          	addi	s7,s7,-1400 # 8001b000 <disk>
    80005580:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005582:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005584:	8a4e                	mv	s4,s3
    80005586:	a051                	j	8000560a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005588:	00fb86b3          	add	a3,s7,a5
    8000558c:	96da                	add	a3,a3,s6
    8000558e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005592:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005594:	0207c563          	bltz	a5,800055be <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005598:	2485                	addiw	s1,s1,1
    8000559a:	0711                	addi	a4,a4,4
    8000559c:	25548063          	beq	s1,s5,800057dc <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800055a0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800055a2:	00018697          	auipc	a3,0x18
    800055a6:	a7668693          	addi	a3,a3,-1418 # 8001d018 <disk+0x2018>
    800055aa:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800055ac:	0006c583          	lbu	a1,0(a3)
    800055b0:	fde1                	bnez	a1,80005588 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055b2:	2785                	addiw	a5,a5,1
    800055b4:	0685                	addi	a3,a3,1
    800055b6:	ff879be3          	bne	a5,s8,800055ac <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055ba:	57fd                	li	a5,-1
    800055bc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800055be:	02905a63          	blez	s1,800055f2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055c2:	f9042503          	lw	a0,-112(s0)
    800055c6:	00000097          	auipc	ra,0x0
    800055ca:	d90080e7          	jalr	-624(ra) # 80005356 <free_desc>
      for(int j = 0; j < i; j++)
    800055ce:	4785                	li	a5,1
    800055d0:	0297d163          	bge	a5,s1,800055f2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055d4:	f9442503          	lw	a0,-108(s0)
    800055d8:	00000097          	auipc	ra,0x0
    800055dc:	d7e080e7          	jalr	-642(ra) # 80005356 <free_desc>
      for(int j = 0; j < i; j++)
    800055e0:	4789                	li	a5,2
    800055e2:	0097d863          	bge	a5,s1,800055f2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055e6:	f9842503          	lw	a0,-104(s0)
    800055ea:	00000097          	auipc	ra,0x0
    800055ee:	d6c080e7          	jalr	-660(ra) # 80005356 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055f2:	00018597          	auipc	a1,0x18
    800055f6:	b3658593          	addi	a1,a1,-1226 # 8001d128 <disk+0x2128>
    800055fa:	00018517          	auipc	a0,0x18
    800055fe:	a1e50513          	addi	a0,a0,-1506 # 8001d018 <disk+0x2018>
    80005602:	ffffc097          	auipc	ra,0xffffc
    80005606:	0e4080e7          	jalr	228(ra) # 800016e6 <sleep>
  for(int i = 0; i < 3; i++){
    8000560a:	f9040713          	addi	a4,s0,-112
    8000560e:	84ce                	mv	s1,s3
    80005610:	bf41                	j	800055a0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005612:	20058713          	addi	a4,a1,512
    80005616:	00471693          	slli	a3,a4,0x4
    8000561a:	00016717          	auipc	a4,0x16
    8000561e:	9e670713          	addi	a4,a4,-1562 # 8001b000 <disk>
    80005622:	9736                	add	a4,a4,a3
    80005624:	4685                	li	a3,1
    80005626:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000562a:	20058713          	addi	a4,a1,512
    8000562e:	00471693          	slli	a3,a4,0x4
    80005632:	00016717          	auipc	a4,0x16
    80005636:	9ce70713          	addi	a4,a4,-1586 # 8001b000 <disk>
    8000563a:	9736                	add	a4,a4,a3
    8000563c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005640:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005644:	7679                	lui	a2,0xffffe
    80005646:	963e                	add	a2,a2,a5
    80005648:	00018697          	auipc	a3,0x18
    8000564c:	9b868693          	addi	a3,a3,-1608 # 8001d000 <disk+0x2000>
    80005650:	6298                	ld	a4,0(a3)
    80005652:	9732                	add	a4,a4,a2
    80005654:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005656:	6298                	ld	a4,0(a3)
    80005658:	9732                	add	a4,a4,a2
    8000565a:	4541                	li	a0,16
    8000565c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000565e:	6298                	ld	a4,0(a3)
    80005660:	9732                	add	a4,a4,a2
    80005662:	4505                	li	a0,1
    80005664:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005668:	f9442703          	lw	a4,-108(s0)
    8000566c:	6288                	ld	a0,0(a3)
    8000566e:	962a                	add	a2,a2,a0
    80005670:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005674:	0712                	slli	a4,a4,0x4
    80005676:	6290                	ld	a2,0(a3)
    80005678:	963a                	add	a2,a2,a4
    8000567a:	05890513          	addi	a0,s2,88
    8000567e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005680:	6294                	ld	a3,0(a3)
    80005682:	96ba                	add	a3,a3,a4
    80005684:	40000613          	li	a2,1024
    80005688:	c690                	sw	a2,8(a3)
  if(write)
    8000568a:	140d0063          	beqz	s10,800057ca <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000568e:	00018697          	auipc	a3,0x18
    80005692:	9726b683          	ld	a3,-1678(a3) # 8001d000 <disk+0x2000>
    80005696:	96ba                	add	a3,a3,a4
    80005698:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000569c:	00016817          	auipc	a6,0x16
    800056a0:	96480813          	addi	a6,a6,-1692 # 8001b000 <disk>
    800056a4:	00018517          	auipc	a0,0x18
    800056a8:	95c50513          	addi	a0,a0,-1700 # 8001d000 <disk+0x2000>
    800056ac:	6114                	ld	a3,0(a0)
    800056ae:	96ba                	add	a3,a3,a4
    800056b0:	00c6d603          	lhu	a2,12(a3)
    800056b4:	00166613          	ori	a2,a2,1
    800056b8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800056bc:	f9842683          	lw	a3,-104(s0)
    800056c0:	6110                	ld	a2,0(a0)
    800056c2:	9732                	add	a4,a4,a2
    800056c4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056c8:	20058613          	addi	a2,a1,512
    800056cc:	0612                	slli	a2,a2,0x4
    800056ce:	9642                	add	a2,a2,a6
    800056d0:	577d                	li	a4,-1
    800056d2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056d6:	00469713          	slli	a4,a3,0x4
    800056da:	6114                	ld	a3,0(a0)
    800056dc:	96ba                	add	a3,a3,a4
    800056de:	03078793          	addi	a5,a5,48
    800056e2:	97c2                	add	a5,a5,a6
    800056e4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800056e6:	611c                	ld	a5,0(a0)
    800056e8:	97ba                	add	a5,a5,a4
    800056ea:	4685                	li	a3,1
    800056ec:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056ee:	611c                	ld	a5,0(a0)
    800056f0:	97ba                	add	a5,a5,a4
    800056f2:	4809                	li	a6,2
    800056f4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800056f8:	611c                	ld	a5,0(a0)
    800056fa:	973e                	add	a4,a4,a5
    800056fc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005700:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005704:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005708:	6518                	ld	a4,8(a0)
    8000570a:	00275783          	lhu	a5,2(a4)
    8000570e:	8b9d                	andi	a5,a5,7
    80005710:	0786                	slli	a5,a5,0x1
    80005712:	97ba                	add	a5,a5,a4
    80005714:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005718:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000571c:	6518                	ld	a4,8(a0)
    8000571e:	00275783          	lhu	a5,2(a4)
    80005722:	2785                	addiw	a5,a5,1
    80005724:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005728:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000572c:	100017b7          	lui	a5,0x10001
    80005730:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005734:	00492703          	lw	a4,4(s2)
    80005738:	4785                	li	a5,1
    8000573a:	02f71163          	bne	a4,a5,8000575c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000573e:	00018997          	auipc	s3,0x18
    80005742:	9ea98993          	addi	s3,s3,-1558 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005746:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005748:	85ce                	mv	a1,s3
    8000574a:	854a                	mv	a0,s2
    8000574c:	ffffc097          	auipc	ra,0xffffc
    80005750:	f9a080e7          	jalr	-102(ra) # 800016e6 <sleep>
  while(b->disk == 1) {
    80005754:	00492783          	lw	a5,4(s2)
    80005758:	fe9788e3          	beq	a5,s1,80005748 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000575c:	f9042903          	lw	s2,-112(s0)
    80005760:	20090793          	addi	a5,s2,512
    80005764:	00479713          	slli	a4,a5,0x4
    80005768:	00016797          	auipc	a5,0x16
    8000576c:	89878793          	addi	a5,a5,-1896 # 8001b000 <disk>
    80005770:	97ba                	add	a5,a5,a4
    80005772:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005776:	00018997          	auipc	s3,0x18
    8000577a:	88a98993          	addi	s3,s3,-1910 # 8001d000 <disk+0x2000>
    8000577e:	00491713          	slli	a4,s2,0x4
    80005782:	0009b783          	ld	a5,0(s3)
    80005786:	97ba                	add	a5,a5,a4
    80005788:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000578c:	854a                	mv	a0,s2
    8000578e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005792:	00000097          	auipc	ra,0x0
    80005796:	bc4080e7          	jalr	-1084(ra) # 80005356 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000579a:	8885                	andi	s1,s1,1
    8000579c:	f0ed                	bnez	s1,8000577e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000579e:	00018517          	auipc	a0,0x18
    800057a2:	98a50513          	addi	a0,a0,-1654 # 8001d128 <disk+0x2128>
    800057a6:	00001097          	auipc	ra,0x1
    800057aa:	c50080e7          	jalr	-944(ra) # 800063f6 <release>
}
    800057ae:	70a6                	ld	ra,104(sp)
    800057b0:	7406                	ld	s0,96(sp)
    800057b2:	64e6                	ld	s1,88(sp)
    800057b4:	6946                	ld	s2,80(sp)
    800057b6:	69a6                	ld	s3,72(sp)
    800057b8:	6a06                	ld	s4,64(sp)
    800057ba:	7ae2                	ld	s5,56(sp)
    800057bc:	7b42                	ld	s6,48(sp)
    800057be:	7ba2                	ld	s7,40(sp)
    800057c0:	7c02                	ld	s8,32(sp)
    800057c2:	6ce2                	ld	s9,24(sp)
    800057c4:	6d42                	ld	s10,16(sp)
    800057c6:	6165                	addi	sp,sp,112
    800057c8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057ca:	00018697          	auipc	a3,0x18
    800057ce:	8366b683          	ld	a3,-1994(a3) # 8001d000 <disk+0x2000>
    800057d2:	96ba                	add	a3,a3,a4
    800057d4:	4609                	li	a2,2
    800057d6:	00c69623          	sh	a2,12(a3)
    800057da:	b5c9                	j	8000569c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057dc:	f9042583          	lw	a1,-112(s0)
    800057e0:	20058793          	addi	a5,a1,512
    800057e4:	0792                	slli	a5,a5,0x4
    800057e6:	00016517          	auipc	a0,0x16
    800057ea:	8c250513          	addi	a0,a0,-1854 # 8001b0a8 <disk+0xa8>
    800057ee:	953e                	add	a0,a0,a5
  if(write)
    800057f0:	e20d11e3          	bnez	s10,80005612 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800057f4:	20058713          	addi	a4,a1,512
    800057f8:	00471693          	slli	a3,a4,0x4
    800057fc:	00016717          	auipc	a4,0x16
    80005800:	80470713          	addi	a4,a4,-2044 # 8001b000 <disk>
    80005804:	9736                	add	a4,a4,a3
    80005806:	0a072423          	sw	zero,168(a4)
    8000580a:	b505                	j	8000562a <virtio_disk_rw+0xf4>

000000008000580c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000580c:	1101                	addi	sp,sp,-32
    8000580e:	ec06                	sd	ra,24(sp)
    80005810:	e822                	sd	s0,16(sp)
    80005812:	e426                	sd	s1,8(sp)
    80005814:	e04a                	sd	s2,0(sp)
    80005816:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005818:	00018517          	auipc	a0,0x18
    8000581c:	91050513          	addi	a0,a0,-1776 # 8001d128 <disk+0x2128>
    80005820:	00001097          	auipc	ra,0x1
    80005824:	b22080e7          	jalr	-1246(ra) # 80006342 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005828:	10001737          	lui	a4,0x10001
    8000582c:	533c                	lw	a5,96(a4)
    8000582e:	8b8d                	andi	a5,a5,3
    80005830:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005832:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005836:	00017797          	auipc	a5,0x17
    8000583a:	7ca78793          	addi	a5,a5,1994 # 8001d000 <disk+0x2000>
    8000583e:	6b94                	ld	a3,16(a5)
    80005840:	0207d703          	lhu	a4,32(a5)
    80005844:	0026d783          	lhu	a5,2(a3)
    80005848:	06f70163          	beq	a4,a5,800058aa <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000584c:	00015917          	auipc	s2,0x15
    80005850:	7b490913          	addi	s2,s2,1972 # 8001b000 <disk>
    80005854:	00017497          	auipc	s1,0x17
    80005858:	7ac48493          	addi	s1,s1,1964 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000585c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005860:	6898                	ld	a4,16(s1)
    80005862:	0204d783          	lhu	a5,32(s1)
    80005866:	8b9d                	andi	a5,a5,7
    80005868:	078e                	slli	a5,a5,0x3
    8000586a:	97ba                	add	a5,a5,a4
    8000586c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000586e:	20078713          	addi	a4,a5,512
    80005872:	0712                	slli	a4,a4,0x4
    80005874:	974a                	add	a4,a4,s2
    80005876:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000587a:	e731                	bnez	a4,800058c6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000587c:	20078793          	addi	a5,a5,512
    80005880:	0792                	slli	a5,a5,0x4
    80005882:	97ca                	add	a5,a5,s2
    80005884:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005886:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000588a:	ffffc097          	auipc	ra,0xffffc
    8000588e:	fe8080e7          	jalr	-24(ra) # 80001872 <wakeup>

    disk.used_idx += 1;
    80005892:	0204d783          	lhu	a5,32(s1)
    80005896:	2785                	addiw	a5,a5,1
    80005898:	17c2                	slli	a5,a5,0x30
    8000589a:	93c1                	srli	a5,a5,0x30
    8000589c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058a0:	6898                	ld	a4,16(s1)
    800058a2:	00275703          	lhu	a4,2(a4)
    800058a6:	faf71be3          	bne	a4,a5,8000585c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800058aa:	00018517          	auipc	a0,0x18
    800058ae:	87e50513          	addi	a0,a0,-1922 # 8001d128 <disk+0x2128>
    800058b2:	00001097          	auipc	ra,0x1
    800058b6:	b44080e7          	jalr	-1212(ra) # 800063f6 <release>
}
    800058ba:	60e2                	ld	ra,24(sp)
    800058bc:	6442                	ld	s0,16(sp)
    800058be:	64a2                	ld	s1,8(sp)
    800058c0:	6902                	ld	s2,0(sp)
    800058c2:	6105                	addi	sp,sp,32
    800058c4:	8082                	ret
      panic("virtio_disk_intr status");
    800058c6:	00003517          	auipc	a0,0x3
    800058ca:	f3250513          	addi	a0,a0,-206 # 800087f8 <syscalls+0x3f8>
    800058ce:	00000097          	auipc	ra,0x0
    800058d2:	52a080e7          	jalr	1322(ra) # 80005df8 <panic>

00000000800058d6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058d6:	1141                	addi	sp,sp,-16
    800058d8:	e422                	sd	s0,8(sp)
    800058da:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058dc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058e0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058e4:	0037979b          	slliw	a5,a5,0x3
    800058e8:	02004737          	lui	a4,0x2004
    800058ec:	97ba                	add	a5,a5,a4
    800058ee:	0200c737          	lui	a4,0x200c
    800058f2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058f6:	000f4637          	lui	a2,0xf4
    800058fa:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058fe:	95b2                	add	a1,a1,a2
    80005900:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005902:	00269713          	slli	a4,a3,0x2
    80005906:	9736                	add	a4,a4,a3
    80005908:	00371693          	slli	a3,a4,0x3
    8000590c:	00018717          	auipc	a4,0x18
    80005910:	6f470713          	addi	a4,a4,1780 # 8001e000 <timer_scratch>
    80005914:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005916:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005918:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000591a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000591e:	00000797          	auipc	a5,0x0
    80005922:	97278793          	addi	a5,a5,-1678 # 80005290 <timervec>
    80005926:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000592a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000592e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005932:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005936:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000593a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000593e:	30479073          	csrw	mie,a5
}
    80005942:	6422                	ld	s0,8(sp)
    80005944:	0141                	addi	sp,sp,16
    80005946:	8082                	ret

0000000080005948 <start>:
{
    80005948:	1141                	addi	sp,sp,-16
    8000594a:	e406                	sd	ra,8(sp)
    8000594c:	e022                	sd	s0,0(sp)
    8000594e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005950:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005954:	7779                	lui	a4,0xffffe
    80005956:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000595a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000595c:	6705                	lui	a4,0x1
    8000595e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005962:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005964:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005968:	ffffb797          	auipc	a5,0xffffb
    8000596c:	9be78793          	addi	a5,a5,-1602 # 80000326 <main>
    80005970:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005974:	4781                	li	a5,0
    80005976:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000597a:	67c1                	lui	a5,0x10
    8000597c:	17fd                	addi	a5,a5,-1
    8000597e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005982:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005986:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000598a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000598e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005992:	57fd                	li	a5,-1
    80005994:	83a9                	srli	a5,a5,0xa
    80005996:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000599a:	47bd                	li	a5,15
    8000599c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059a0:	00000097          	auipc	ra,0x0
    800059a4:	f36080e7          	jalr	-202(ra) # 800058d6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059a8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059ac:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059ae:	823e                	mv	tp,a5
  asm volatile("mret");
    800059b0:	30200073          	mret
}
    800059b4:	60a2                	ld	ra,8(sp)
    800059b6:	6402                	ld	s0,0(sp)
    800059b8:	0141                	addi	sp,sp,16
    800059ba:	8082                	ret

00000000800059bc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800059bc:	715d                	addi	sp,sp,-80
    800059be:	e486                	sd	ra,72(sp)
    800059c0:	e0a2                	sd	s0,64(sp)
    800059c2:	fc26                	sd	s1,56(sp)
    800059c4:	f84a                	sd	s2,48(sp)
    800059c6:	f44e                	sd	s3,40(sp)
    800059c8:	f052                	sd	s4,32(sp)
    800059ca:	ec56                	sd	s5,24(sp)
    800059cc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059ce:	04c05663          	blez	a2,80005a1a <consolewrite+0x5e>
    800059d2:	8a2a                	mv	s4,a0
    800059d4:	84ae                	mv	s1,a1
    800059d6:	89b2                	mv	s3,a2
    800059d8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059da:	5afd                	li	s5,-1
    800059dc:	4685                	li	a3,1
    800059de:	8626                	mv	a2,s1
    800059e0:	85d2                	mv	a1,s4
    800059e2:	fbf40513          	addi	a0,s0,-65
    800059e6:	ffffc097          	auipc	ra,0xffffc
    800059ea:	0fa080e7          	jalr	250(ra) # 80001ae0 <either_copyin>
    800059ee:	01550c63          	beq	a0,s5,80005a06 <consolewrite+0x4a>
      break;
    uartputc(c);
    800059f2:	fbf44503          	lbu	a0,-65(s0)
    800059f6:	00000097          	auipc	ra,0x0
    800059fa:	78e080e7          	jalr	1934(ra) # 80006184 <uartputc>
  for(i = 0; i < n; i++){
    800059fe:	2905                	addiw	s2,s2,1
    80005a00:	0485                	addi	s1,s1,1
    80005a02:	fd299de3          	bne	s3,s2,800059dc <consolewrite+0x20>
  }

  return i;
}
    80005a06:	854a                	mv	a0,s2
    80005a08:	60a6                	ld	ra,72(sp)
    80005a0a:	6406                	ld	s0,64(sp)
    80005a0c:	74e2                	ld	s1,56(sp)
    80005a0e:	7942                	ld	s2,48(sp)
    80005a10:	79a2                	ld	s3,40(sp)
    80005a12:	7a02                	ld	s4,32(sp)
    80005a14:	6ae2                	ld	s5,24(sp)
    80005a16:	6161                	addi	sp,sp,80
    80005a18:	8082                	ret
  for(i = 0; i < n; i++){
    80005a1a:	4901                	li	s2,0
    80005a1c:	b7ed                	j	80005a06 <consolewrite+0x4a>

0000000080005a1e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a1e:	7119                	addi	sp,sp,-128
    80005a20:	fc86                	sd	ra,120(sp)
    80005a22:	f8a2                	sd	s0,112(sp)
    80005a24:	f4a6                	sd	s1,104(sp)
    80005a26:	f0ca                	sd	s2,96(sp)
    80005a28:	ecce                	sd	s3,88(sp)
    80005a2a:	e8d2                	sd	s4,80(sp)
    80005a2c:	e4d6                	sd	s5,72(sp)
    80005a2e:	e0da                	sd	s6,64(sp)
    80005a30:	fc5e                	sd	s7,56(sp)
    80005a32:	f862                	sd	s8,48(sp)
    80005a34:	f466                	sd	s9,40(sp)
    80005a36:	f06a                	sd	s10,32(sp)
    80005a38:	ec6e                	sd	s11,24(sp)
    80005a3a:	0100                	addi	s0,sp,128
    80005a3c:	8b2a                	mv	s6,a0
    80005a3e:	8aae                	mv	s5,a1
    80005a40:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a42:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a46:	00020517          	auipc	a0,0x20
    80005a4a:	6fa50513          	addi	a0,a0,1786 # 80026140 <cons>
    80005a4e:	00001097          	auipc	ra,0x1
    80005a52:	8f4080e7          	jalr	-1804(ra) # 80006342 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a56:	00020497          	auipc	s1,0x20
    80005a5a:	6ea48493          	addi	s1,s1,1770 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a5e:	89a6                	mv	s3,s1
    80005a60:	00020917          	auipc	s2,0x20
    80005a64:	77890913          	addi	s2,s2,1912 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a68:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a6a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a6c:	4da9                	li	s11,10
  while(n > 0){
    80005a6e:	07405863          	blez	s4,80005ade <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a72:	0984a783          	lw	a5,152(s1)
    80005a76:	09c4a703          	lw	a4,156(s1)
    80005a7a:	02f71463          	bne	a4,a5,80005aa2 <consoleread+0x84>
      if(myproc()->killed){
    80005a7e:	ffffb097          	auipc	ra,0xffffb
    80005a82:	4fe080e7          	jalr	1278(ra) # 80000f7c <myproc>
    80005a86:	551c                	lw	a5,40(a0)
    80005a88:	e7b5                	bnez	a5,80005af4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005a8a:	85ce                	mv	a1,s3
    80005a8c:	854a                	mv	a0,s2
    80005a8e:	ffffc097          	auipc	ra,0xffffc
    80005a92:	c58080e7          	jalr	-936(ra) # 800016e6 <sleep>
    while(cons.r == cons.w){
    80005a96:	0984a783          	lw	a5,152(s1)
    80005a9a:	09c4a703          	lw	a4,156(s1)
    80005a9e:	fef700e3          	beq	a4,a5,80005a7e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005aa2:	0017871b          	addiw	a4,a5,1
    80005aa6:	08e4ac23          	sw	a4,152(s1)
    80005aaa:	07f7f713          	andi	a4,a5,127
    80005aae:	9726                	add	a4,a4,s1
    80005ab0:	01874703          	lbu	a4,24(a4)
    80005ab4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005ab8:	079c0663          	beq	s8,s9,80005b24 <consoleread+0x106>
    cbuf = c;
    80005abc:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ac0:	4685                	li	a3,1
    80005ac2:	f8f40613          	addi	a2,s0,-113
    80005ac6:	85d6                	mv	a1,s5
    80005ac8:	855a                	mv	a0,s6
    80005aca:	ffffc097          	auipc	ra,0xffffc
    80005ace:	fc0080e7          	jalr	-64(ra) # 80001a8a <either_copyout>
    80005ad2:	01a50663          	beq	a0,s10,80005ade <consoleread+0xc0>
    dst++;
    80005ad6:	0a85                	addi	s5,s5,1
    --n;
    80005ad8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005ada:	f9bc1ae3          	bne	s8,s11,80005a6e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005ade:	00020517          	auipc	a0,0x20
    80005ae2:	66250513          	addi	a0,a0,1634 # 80026140 <cons>
    80005ae6:	00001097          	auipc	ra,0x1
    80005aea:	910080e7          	jalr	-1776(ra) # 800063f6 <release>

  return target - n;
    80005aee:	414b853b          	subw	a0,s7,s4
    80005af2:	a811                	j	80005b06 <consoleread+0xe8>
        release(&cons.lock);
    80005af4:	00020517          	auipc	a0,0x20
    80005af8:	64c50513          	addi	a0,a0,1612 # 80026140 <cons>
    80005afc:	00001097          	auipc	ra,0x1
    80005b00:	8fa080e7          	jalr	-1798(ra) # 800063f6 <release>
        return -1;
    80005b04:	557d                	li	a0,-1
}
    80005b06:	70e6                	ld	ra,120(sp)
    80005b08:	7446                	ld	s0,112(sp)
    80005b0a:	74a6                	ld	s1,104(sp)
    80005b0c:	7906                	ld	s2,96(sp)
    80005b0e:	69e6                	ld	s3,88(sp)
    80005b10:	6a46                	ld	s4,80(sp)
    80005b12:	6aa6                	ld	s5,72(sp)
    80005b14:	6b06                	ld	s6,64(sp)
    80005b16:	7be2                	ld	s7,56(sp)
    80005b18:	7c42                	ld	s8,48(sp)
    80005b1a:	7ca2                	ld	s9,40(sp)
    80005b1c:	7d02                	ld	s10,32(sp)
    80005b1e:	6de2                	ld	s11,24(sp)
    80005b20:	6109                	addi	sp,sp,128
    80005b22:	8082                	ret
      if(n < target){
    80005b24:	000a071b          	sext.w	a4,s4
    80005b28:	fb777be3          	bgeu	a4,s7,80005ade <consoleread+0xc0>
        cons.r--;
    80005b2c:	00020717          	auipc	a4,0x20
    80005b30:	6af72623          	sw	a5,1708(a4) # 800261d8 <cons+0x98>
    80005b34:	b76d                	j	80005ade <consoleread+0xc0>

0000000080005b36 <consputc>:
{
    80005b36:	1141                	addi	sp,sp,-16
    80005b38:	e406                	sd	ra,8(sp)
    80005b3a:	e022                	sd	s0,0(sp)
    80005b3c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b3e:	10000793          	li	a5,256
    80005b42:	00f50a63          	beq	a0,a5,80005b56 <consputc+0x20>
    uartputc_sync(c);
    80005b46:	00000097          	auipc	ra,0x0
    80005b4a:	564080e7          	jalr	1380(ra) # 800060aa <uartputc_sync>
}
    80005b4e:	60a2                	ld	ra,8(sp)
    80005b50:	6402                	ld	s0,0(sp)
    80005b52:	0141                	addi	sp,sp,16
    80005b54:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b56:	4521                	li	a0,8
    80005b58:	00000097          	auipc	ra,0x0
    80005b5c:	552080e7          	jalr	1362(ra) # 800060aa <uartputc_sync>
    80005b60:	02000513          	li	a0,32
    80005b64:	00000097          	auipc	ra,0x0
    80005b68:	546080e7          	jalr	1350(ra) # 800060aa <uartputc_sync>
    80005b6c:	4521                	li	a0,8
    80005b6e:	00000097          	auipc	ra,0x0
    80005b72:	53c080e7          	jalr	1340(ra) # 800060aa <uartputc_sync>
    80005b76:	bfe1                	j	80005b4e <consputc+0x18>

0000000080005b78 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b78:	1101                	addi	sp,sp,-32
    80005b7a:	ec06                	sd	ra,24(sp)
    80005b7c:	e822                	sd	s0,16(sp)
    80005b7e:	e426                	sd	s1,8(sp)
    80005b80:	e04a                	sd	s2,0(sp)
    80005b82:	1000                	addi	s0,sp,32
    80005b84:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b86:	00020517          	auipc	a0,0x20
    80005b8a:	5ba50513          	addi	a0,a0,1466 # 80026140 <cons>
    80005b8e:	00000097          	auipc	ra,0x0
    80005b92:	7b4080e7          	jalr	1972(ra) # 80006342 <acquire>

  switch(c){
    80005b96:	47d5                	li	a5,21
    80005b98:	0af48663          	beq	s1,a5,80005c44 <consoleintr+0xcc>
    80005b9c:	0297ca63          	blt	a5,s1,80005bd0 <consoleintr+0x58>
    80005ba0:	47a1                	li	a5,8
    80005ba2:	0ef48763          	beq	s1,a5,80005c90 <consoleintr+0x118>
    80005ba6:	47c1                	li	a5,16
    80005ba8:	10f49a63          	bne	s1,a5,80005cbc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005bac:	ffffc097          	auipc	ra,0xffffc
    80005bb0:	f8a080e7          	jalr	-118(ra) # 80001b36 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005bb4:	00020517          	auipc	a0,0x20
    80005bb8:	58c50513          	addi	a0,a0,1420 # 80026140 <cons>
    80005bbc:	00001097          	auipc	ra,0x1
    80005bc0:	83a080e7          	jalr	-1990(ra) # 800063f6 <release>
}
    80005bc4:	60e2                	ld	ra,24(sp)
    80005bc6:	6442                	ld	s0,16(sp)
    80005bc8:	64a2                	ld	s1,8(sp)
    80005bca:	6902                	ld	s2,0(sp)
    80005bcc:	6105                	addi	sp,sp,32
    80005bce:	8082                	ret
  switch(c){
    80005bd0:	07f00793          	li	a5,127
    80005bd4:	0af48e63          	beq	s1,a5,80005c90 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005bd8:	00020717          	auipc	a4,0x20
    80005bdc:	56870713          	addi	a4,a4,1384 # 80026140 <cons>
    80005be0:	0a072783          	lw	a5,160(a4)
    80005be4:	09872703          	lw	a4,152(a4)
    80005be8:	9f99                	subw	a5,a5,a4
    80005bea:	07f00713          	li	a4,127
    80005bee:	fcf763e3          	bltu	a4,a5,80005bb4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bf2:	47b5                	li	a5,13
    80005bf4:	0cf48763          	beq	s1,a5,80005cc2 <consoleintr+0x14a>
      consputc(c);
    80005bf8:	8526                	mv	a0,s1
    80005bfa:	00000097          	auipc	ra,0x0
    80005bfe:	f3c080e7          	jalr	-196(ra) # 80005b36 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c02:	00020797          	auipc	a5,0x20
    80005c06:	53e78793          	addi	a5,a5,1342 # 80026140 <cons>
    80005c0a:	0a07a703          	lw	a4,160(a5)
    80005c0e:	0017069b          	addiw	a3,a4,1
    80005c12:	0006861b          	sext.w	a2,a3
    80005c16:	0ad7a023          	sw	a3,160(a5)
    80005c1a:	07f77713          	andi	a4,a4,127
    80005c1e:	97ba                	add	a5,a5,a4
    80005c20:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005c24:	47a9                	li	a5,10
    80005c26:	0cf48563          	beq	s1,a5,80005cf0 <consoleintr+0x178>
    80005c2a:	4791                	li	a5,4
    80005c2c:	0cf48263          	beq	s1,a5,80005cf0 <consoleintr+0x178>
    80005c30:	00020797          	auipc	a5,0x20
    80005c34:	5a87a783          	lw	a5,1448(a5) # 800261d8 <cons+0x98>
    80005c38:	0807879b          	addiw	a5,a5,128
    80005c3c:	f6f61ce3          	bne	a2,a5,80005bb4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c40:	863e                	mv	a2,a5
    80005c42:	a07d                	j	80005cf0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c44:	00020717          	auipc	a4,0x20
    80005c48:	4fc70713          	addi	a4,a4,1276 # 80026140 <cons>
    80005c4c:	0a072783          	lw	a5,160(a4)
    80005c50:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c54:	00020497          	auipc	s1,0x20
    80005c58:	4ec48493          	addi	s1,s1,1260 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005c5c:	4929                	li	s2,10
    80005c5e:	f4f70be3          	beq	a4,a5,80005bb4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c62:	37fd                	addiw	a5,a5,-1
    80005c64:	07f7f713          	andi	a4,a5,127
    80005c68:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c6a:	01874703          	lbu	a4,24(a4)
    80005c6e:	f52703e3          	beq	a4,s2,80005bb4 <consoleintr+0x3c>
      cons.e--;
    80005c72:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c76:	10000513          	li	a0,256
    80005c7a:	00000097          	auipc	ra,0x0
    80005c7e:	ebc080e7          	jalr	-324(ra) # 80005b36 <consputc>
    while(cons.e != cons.w &&
    80005c82:	0a04a783          	lw	a5,160(s1)
    80005c86:	09c4a703          	lw	a4,156(s1)
    80005c8a:	fcf71ce3          	bne	a4,a5,80005c62 <consoleintr+0xea>
    80005c8e:	b71d                	j	80005bb4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c90:	00020717          	auipc	a4,0x20
    80005c94:	4b070713          	addi	a4,a4,1200 # 80026140 <cons>
    80005c98:	0a072783          	lw	a5,160(a4)
    80005c9c:	09c72703          	lw	a4,156(a4)
    80005ca0:	f0f70ae3          	beq	a4,a5,80005bb4 <consoleintr+0x3c>
      cons.e--;
    80005ca4:	37fd                	addiw	a5,a5,-1
    80005ca6:	00020717          	auipc	a4,0x20
    80005caa:	52f72d23          	sw	a5,1338(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005cae:	10000513          	li	a0,256
    80005cb2:	00000097          	auipc	ra,0x0
    80005cb6:	e84080e7          	jalr	-380(ra) # 80005b36 <consputc>
    80005cba:	bded                	j	80005bb4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cbc:	ee048ce3          	beqz	s1,80005bb4 <consoleintr+0x3c>
    80005cc0:	bf21                	j	80005bd8 <consoleintr+0x60>
      consputc(c);
    80005cc2:	4529                	li	a0,10
    80005cc4:	00000097          	auipc	ra,0x0
    80005cc8:	e72080e7          	jalr	-398(ra) # 80005b36 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ccc:	00020797          	auipc	a5,0x20
    80005cd0:	47478793          	addi	a5,a5,1140 # 80026140 <cons>
    80005cd4:	0a07a703          	lw	a4,160(a5)
    80005cd8:	0017069b          	addiw	a3,a4,1
    80005cdc:	0006861b          	sext.w	a2,a3
    80005ce0:	0ad7a023          	sw	a3,160(a5)
    80005ce4:	07f77713          	andi	a4,a4,127
    80005ce8:	97ba                	add	a5,a5,a4
    80005cea:	4729                	li	a4,10
    80005cec:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cf0:	00020797          	auipc	a5,0x20
    80005cf4:	4ec7a623          	sw	a2,1260(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005cf8:	00020517          	auipc	a0,0x20
    80005cfc:	4e050513          	addi	a0,a0,1248 # 800261d8 <cons+0x98>
    80005d00:	ffffc097          	auipc	ra,0xffffc
    80005d04:	b72080e7          	jalr	-1166(ra) # 80001872 <wakeup>
    80005d08:	b575                	j	80005bb4 <consoleintr+0x3c>

0000000080005d0a <consoleinit>:

void
consoleinit(void)
{
    80005d0a:	1141                	addi	sp,sp,-16
    80005d0c:	e406                	sd	ra,8(sp)
    80005d0e:	e022                	sd	s0,0(sp)
    80005d10:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d12:	00003597          	auipc	a1,0x3
    80005d16:	afe58593          	addi	a1,a1,-1282 # 80008810 <syscalls+0x410>
    80005d1a:	00020517          	auipc	a0,0x20
    80005d1e:	42650513          	addi	a0,a0,1062 # 80026140 <cons>
    80005d22:	00000097          	auipc	ra,0x0
    80005d26:	590080e7          	jalr	1424(ra) # 800062b2 <initlock>

  uartinit();
    80005d2a:	00000097          	auipc	ra,0x0
    80005d2e:	330080e7          	jalr	816(ra) # 8000605a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d32:	00013797          	auipc	a5,0x13
    80005d36:	59678793          	addi	a5,a5,1430 # 800192c8 <devsw>
    80005d3a:	00000717          	auipc	a4,0x0
    80005d3e:	ce470713          	addi	a4,a4,-796 # 80005a1e <consoleread>
    80005d42:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d44:	00000717          	auipc	a4,0x0
    80005d48:	c7870713          	addi	a4,a4,-904 # 800059bc <consolewrite>
    80005d4c:	ef98                	sd	a4,24(a5)
}
    80005d4e:	60a2                	ld	ra,8(sp)
    80005d50:	6402                	ld	s0,0(sp)
    80005d52:	0141                	addi	sp,sp,16
    80005d54:	8082                	ret

0000000080005d56 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d56:	7179                	addi	sp,sp,-48
    80005d58:	f406                	sd	ra,40(sp)
    80005d5a:	f022                	sd	s0,32(sp)
    80005d5c:	ec26                	sd	s1,24(sp)
    80005d5e:	e84a                	sd	s2,16(sp)
    80005d60:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d62:	c219                	beqz	a2,80005d68 <printint+0x12>
    80005d64:	08054663          	bltz	a0,80005df0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d68:	2501                	sext.w	a0,a0
    80005d6a:	4881                	li	a7,0
    80005d6c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d70:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d72:	2581                	sext.w	a1,a1
    80005d74:	00003617          	auipc	a2,0x3
    80005d78:	acc60613          	addi	a2,a2,-1332 # 80008840 <digits>
    80005d7c:	883a                	mv	a6,a4
    80005d7e:	2705                	addiw	a4,a4,1
    80005d80:	02b577bb          	remuw	a5,a0,a1
    80005d84:	1782                	slli	a5,a5,0x20
    80005d86:	9381                	srli	a5,a5,0x20
    80005d88:	97b2                	add	a5,a5,a2
    80005d8a:	0007c783          	lbu	a5,0(a5)
    80005d8e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d92:	0005079b          	sext.w	a5,a0
    80005d96:	02b5553b          	divuw	a0,a0,a1
    80005d9a:	0685                	addi	a3,a3,1
    80005d9c:	feb7f0e3          	bgeu	a5,a1,80005d7c <printint+0x26>

  if(sign)
    80005da0:	00088b63          	beqz	a7,80005db6 <printint+0x60>
    buf[i++] = '-';
    80005da4:	fe040793          	addi	a5,s0,-32
    80005da8:	973e                	add	a4,a4,a5
    80005daa:	02d00793          	li	a5,45
    80005dae:	fef70823          	sb	a5,-16(a4)
    80005db2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005db6:	02e05763          	blez	a4,80005de4 <printint+0x8e>
    80005dba:	fd040793          	addi	a5,s0,-48
    80005dbe:	00e784b3          	add	s1,a5,a4
    80005dc2:	fff78913          	addi	s2,a5,-1
    80005dc6:	993a                	add	s2,s2,a4
    80005dc8:	377d                	addiw	a4,a4,-1
    80005dca:	1702                	slli	a4,a4,0x20
    80005dcc:	9301                	srli	a4,a4,0x20
    80005dce:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005dd2:	fff4c503          	lbu	a0,-1(s1)
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	d60080e7          	jalr	-672(ra) # 80005b36 <consputc>
  while(--i >= 0)
    80005dde:	14fd                	addi	s1,s1,-1
    80005de0:	ff2499e3          	bne	s1,s2,80005dd2 <printint+0x7c>
}
    80005de4:	70a2                	ld	ra,40(sp)
    80005de6:	7402                	ld	s0,32(sp)
    80005de8:	64e2                	ld	s1,24(sp)
    80005dea:	6942                	ld	s2,16(sp)
    80005dec:	6145                	addi	sp,sp,48
    80005dee:	8082                	ret
    x = -xx;
    80005df0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005df4:	4885                	li	a7,1
    x = -xx;
    80005df6:	bf9d                	j	80005d6c <printint+0x16>

0000000080005df8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005df8:	1101                	addi	sp,sp,-32
    80005dfa:	ec06                	sd	ra,24(sp)
    80005dfc:	e822                	sd	s0,16(sp)
    80005dfe:	e426                	sd	s1,8(sp)
    80005e00:	1000                	addi	s0,sp,32
    80005e02:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e04:	00020797          	auipc	a5,0x20
    80005e08:	3e07ae23          	sw	zero,1020(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005e0c:	00003517          	auipc	a0,0x3
    80005e10:	a0c50513          	addi	a0,a0,-1524 # 80008818 <syscalls+0x418>
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	02e080e7          	jalr	46(ra) # 80005e42 <printf>
  printf(s);
    80005e1c:	8526                	mv	a0,s1
    80005e1e:	00000097          	auipc	ra,0x0
    80005e22:	024080e7          	jalr	36(ra) # 80005e42 <printf>
  printf("\n");
    80005e26:	00002517          	auipc	a0,0x2
    80005e2a:	22250513          	addi	a0,a0,546 # 80008048 <etext+0x48>
    80005e2e:	00000097          	auipc	ra,0x0
    80005e32:	014080e7          	jalr	20(ra) # 80005e42 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e36:	4785                	li	a5,1
    80005e38:	00003717          	auipc	a4,0x3
    80005e3c:	1ef72223          	sw	a5,484(a4) # 8000901c <panicked>
  for(;;)
    80005e40:	a001                	j	80005e40 <panic+0x48>

0000000080005e42 <printf>:
{
    80005e42:	7131                	addi	sp,sp,-192
    80005e44:	fc86                	sd	ra,120(sp)
    80005e46:	f8a2                	sd	s0,112(sp)
    80005e48:	f4a6                	sd	s1,104(sp)
    80005e4a:	f0ca                	sd	s2,96(sp)
    80005e4c:	ecce                	sd	s3,88(sp)
    80005e4e:	e8d2                	sd	s4,80(sp)
    80005e50:	e4d6                	sd	s5,72(sp)
    80005e52:	e0da                	sd	s6,64(sp)
    80005e54:	fc5e                	sd	s7,56(sp)
    80005e56:	f862                	sd	s8,48(sp)
    80005e58:	f466                	sd	s9,40(sp)
    80005e5a:	f06a                	sd	s10,32(sp)
    80005e5c:	ec6e                	sd	s11,24(sp)
    80005e5e:	0100                	addi	s0,sp,128
    80005e60:	8a2a                	mv	s4,a0
    80005e62:	e40c                	sd	a1,8(s0)
    80005e64:	e810                	sd	a2,16(s0)
    80005e66:	ec14                	sd	a3,24(s0)
    80005e68:	f018                	sd	a4,32(s0)
    80005e6a:	f41c                	sd	a5,40(s0)
    80005e6c:	03043823          	sd	a6,48(s0)
    80005e70:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e74:	00020d97          	auipc	s11,0x20
    80005e78:	38cdad83          	lw	s11,908(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e7c:	020d9b63          	bnez	s11,80005eb2 <printf+0x70>
  if (fmt == 0)
    80005e80:	040a0263          	beqz	s4,80005ec4 <printf+0x82>
  va_start(ap, fmt);
    80005e84:	00840793          	addi	a5,s0,8
    80005e88:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e8c:	000a4503          	lbu	a0,0(s4)
    80005e90:	16050263          	beqz	a0,80005ff4 <printf+0x1b2>
    80005e94:	4481                	li	s1,0
    if(c != '%'){
    80005e96:	02500a93          	li	s5,37
    switch(c){
    80005e9a:	07000b13          	li	s6,112
  consputc('x');
    80005e9e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ea0:	00003b97          	auipc	s7,0x3
    80005ea4:	9a0b8b93          	addi	s7,s7,-1632 # 80008840 <digits>
    switch(c){
    80005ea8:	07300c93          	li	s9,115
    80005eac:	06400c13          	li	s8,100
    80005eb0:	a82d                	j	80005eea <printf+0xa8>
    acquire(&pr.lock);
    80005eb2:	00020517          	auipc	a0,0x20
    80005eb6:	33650513          	addi	a0,a0,822 # 800261e8 <pr>
    80005eba:	00000097          	auipc	ra,0x0
    80005ebe:	488080e7          	jalr	1160(ra) # 80006342 <acquire>
    80005ec2:	bf7d                	j	80005e80 <printf+0x3e>
    panic("null fmt");
    80005ec4:	00003517          	auipc	a0,0x3
    80005ec8:	96450513          	addi	a0,a0,-1692 # 80008828 <syscalls+0x428>
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	f2c080e7          	jalr	-212(ra) # 80005df8 <panic>
      consputc(c);
    80005ed4:	00000097          	auipc	ra,0x0
    80005ed8:	c62080e7          	jalr	-926(ra) # 80005b36 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005edc:	2485                	addiw	s1,s1,1
    80005ede:	009a07b3          	add	a5,s4,s1
    80005ee2:	0007c503          	lbu	a0,0(a5)
    80005ee6:	10050763          	beqz	a0,80005ff4 <printf+0x1b2>
    if(c != '%'){
    80005eea:	ff5515e3          	bne	a0,s5,80005ed4 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005eee:	2485                	addiw	s1,s1,1
    80005ef0:	009a07b3          	add	a5,s4,s1
    80005ef4:	0007c783          	lbu	a5,0(a5)
    80005ef8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005efc:	cfe5                	beqz	a5,80005ff4 <printf+0x1b2>
    switch(c){
    80005efe:	05678a63          	beq	a5,s6,80005f52 <printf+0x110>
    80005f02:	02fb7663          	bgeu	s6,a5,80005f2e <printf+0xec>
    80005f06:	09978963          	beq	a5,s9,80005f98 <printf+0x156>
    80005f0a:	07800713          	li	a4,120
    80005f0e:	0ce79863          	bne	a5,a4,80005fde <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005f12:	f8843783          	ld	a5,-120(s0)
    80005f16:	00878713          	addi	a4,a5,8
    80005f1a:	f8e43423          	sd	a4,-120(s0)
    80005f1e:	4605                	li	a2,1
    80005f20:	85ea                	mv	a1,s10
    80005f22:	4388                	lw	a0,0(a5)
    80005f24:	00000097          	auipc	ra,0x0
    80005f28:	e32080e7          	jalr	-462(ra) # 80005d56 <printint>
      break;
    80005f2c:	bf45                	j	80005edc <printf+0x9a>
    switch(c){
    80005f2e:	0b578263          	beq	a5,s5,80005fd2 <printf+0x190>
    80005f32:	0b879663          	bne	a5,s8,80005fde <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f36:	f8843783          	ld	a5,-120(s0)
    80005f3a:	00878713          	addi	a4,a5,8
    80005f3e:	f8e43423          	sd	a4,-120(s0)
    80005f42:	4605                	li	a2,1
    80005f44:	45a9                	li	a1,10
    80005f46:	4388                	lw	a0,0(a5)
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	e0e080e7          	jalr	-498(ra) # 80005d56 <printint>
      break;
    80005f50:	b771                	j	80005edc <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f52:	f8843783          	ld	a5,-120(s0)
    80005f56:	00878713          	addi	a4,a5,8
    80005f5a:	f8e43423          	sd	a4,-120(s0)
    80005f5e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f62:	03000513          	li	a0,48
    80005f66:	00000097          	auipc	ra,0x0
    80005f6a:	bd0080e7          	jalr	-1072(ra) # 80005b36 <consputc>
  consputc('x');
    80005f6e:	07800513          	li	a0,120
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	bc4080e7          	jalr	-1084(ra) # 80005b36 <consputc>
    80005f7a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f7c:	03c9d793          	srli	a5,s3,0x3c
    80005f80:	97de                	add	a5,a5,s7
    80005f82:	0007c503          	lbu	a0,0(a5)
    80005f86:	00000097          	auipc	ra,0x0
    80005f8a:	bb0080e7          	jalr	-1104(ra) # 80005b36 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f8e:	0992                	slli	s3,s3,0x4
    80005f90:	397d                	addiw	s2,s2,-1
    80005f92:	fe0915e3          	bnez	s2,80005f7c <printf+0x13a>
    80005f96:	b799                	j	80005edc <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f98:	f8843783          	ld	a5,-120(s0)
    80005f9c:	00878713          	addi	a4,a5,8
    80005fa0:	f8e43423          	sd	a4,-120(s0)
    80005fa4:	0007b903          	ld	s2,0(a5)
    80005fa8:	00090e63          	beqz	s2,80005fc4 <printf+0x182>
      for(; *s; s++)
    80005fac:	00094503          	lbu	a0,0(s2)
    80005fb0:	d515                	beqz	a0,80005edc <printf+0x9a>
        consputc(*s);
    80005fb2:	00000097          	auipc	ra,0x0
    80005fb6:	b84080e7          	jalr	-1148(ra) # 80005b36 <consputc>
      for(; *s; s++)
    80005fba:	0905                	addi	s2,s2,1
    80005fbc:	00094503          	lbu	a0,0(s2)
    80005fc0:	f96d                	bnez	a0,80005fb2 <printf+0x170>
    80005fc2:	bf29                	j	80005edc <printf+0x9a>
        s = "(null)";
    80005fc4:	00003917          	auipc	s2,0x3
    80005fc8:	85c90913          	addi	s2,s2,-1956 # 80008820 <syscalls+0x420>
      for(; *s; s++)
    80005fcc:	02800513          	li	a0,40
    80005fd0:	b7cd                	j	80005fb2 <printf+0x170>
      consputc('%');
    80005fd2:	8556                	mv	a0,s5
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	b62080e7          	jalr	-1182(ra) # 80005b36 <consputc>
      break;
    80005fdc:	b701                	j	80005edc <printf+0x9a>
      consputc('%');
    80005fde:	8556                	mv	a0,s5
    80005fe0:	00000097          	auipc	ra,0x0
    80005fe4:	b56080e7          	jalr	-1194(ra) # 80005b36 <consputc>
      consputc(c);
    80005fe8:	854a                	mv	a0,s2
    80005fea:	00000097          	auipc	ra,0x0
    80005fee:	b4c080e7          	jalr	-1204(ra) # 80005b36 <consputc>
      break;
    80005ff2:	b5ed                	j	80005edc <printf+0x9a>
  if(locking)
    80005ff4:	020d9163          	bnez	s11,80006016 <printf+0x1d4>
}
    80005ff8:	70e6                	ld	ra,120(sp)
    80005ffa:	7446                	ld	s0,112(sp)
    80005ffc:	74a6                	ld	s1,104(sp)
    80005ffe:	7906                	ld	s2,96(sp)
    80006000:	69e6                	ld	s3,88(sp)
    80006002:	6a46                	ld	s4,80(sp)
    80006004:	6aa6                	ld	s5,72(sp)
    80006006:	6b06                	ld	s6,64(sp)
    80006008:	7be2                	ld	s7,56(sp)
    8000600a:	7c42                	ld	s8,48(sp)
    8000600c:	7ca2                	ld	s9,40(sp)
    8000600e:	7d02                	ld	s10,32(sp)
    80006010:	6de2                	ld	s11,24(sp)
    80006012:	6129                	addi	sp,sp,192
    80006014:	8082                	ret
    release(&pr.lock);
    80006016:	00020517          	auipc	a0,0x20
    8000601a:	1d250513          	addi	a0,a0,466 # 800261e8 <pr>
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	3d8080e7          	jalr	984(ra) # 800063f6 <release>
}
    80006026:	bfc9                	j	80005ff8 <printf+0x1b6>

0000000080006028 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006028:	1101                	addi	sp,sp,-32
    8000602a:	ec06                	sd	ra,24(sp)
    8000602c:	e822                	sd	s0,16(sp)
    8000602e:	e426                	sd	s1,8(sp)
    80006030:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006032:	00020497          	auipc	s1,0x20
    80006036:	1b648493          	addi	s1,s1,438 # 800261e8 <pr>
    8000603a:	00002597          	auipc	a1,0x2
    8000603e:	7fe58593          	addi	a1,a1,2046 # 80008838 <syscalls+0x438>
    80006042:	8526                	mv	a0,s1
    80006044:	00000097          	auipc	ra,0x0
    80006048:	26e080e7          	jalr	622(ra) # 800062b2 <initlock>
  pr.locking = 1;
    8000604c:	4785                	li	a5,1
    8000604e:	cc9c                	sw	a5,24(s1)
}
    80006050:	60e2                	ld	ra,24(sp)
    80006052:	6442                	ld	s0,16(sp)
    80006054:	64a2                	ld	s1,8(sp)
    80006056:	6105                	addi	sp,sp,32
    80006058:	8082                	ret

000000008000605a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000605a:	1141                	addi	sp,sp,-16
    8000605c:	e406                	sd	ra,8(sp)
    8000605e:	e022                	sd	s0,0(sp)
    80006060:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006062:	100007b7          	lui	a5,0x10000
    80006066:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000606a:	f8000713          	li	a4,-128
    8000606e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006072:	470d                	li	a4,3
    80006074:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006078:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000607c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006080:	469d                	li	a3,7
    80006082:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006086:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000608a:	00002597          	auipc	a1,0x2
    8000608e:	7ce58593          	addi	a1,a1,1998 # 80008858 <digits+0x18>
    80006092:	00020517          	auipc	a0,0x20
    80006096:	17650513          	addi	a0,a0,374 # 80026208 <uart_tx_lock>
    8000609a:	00000097          	auipc	ra,0x0
    8000609e:	218080e7          	jalr	536(ra) # 800062b2 <initlock>
}
    800060a2:	60a2                	ld	ra,8(sp)
    800060a4:	6402                	ld	s0,0(sp)
    800060a6:	0141                	addi	sp,sp,16
    800060a8:	8082                	ret

00000000800060aa <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060aa:	1101                	addi	sp,sp,-32
    800060ac:	ec06                	sd	ra,24(sp)
    800060ae:	e822                	sd	s0,16(sp)
    800060b0:	e426                	sd	s1,8(sp)
    800060b2:	1000                	addi	s0,sp,32
    800060b4:	84aa                	mv	s1,a0
  push_off();
    800060b6:	00000097          	auipc	ra,0x0
    800060ba:	240080e7          	jalr	576(ra) # 800062f6 <push_off>

  if(panicked){
    800060be:	00003797          	auipc	a5,0x3
    800060c2:	f5e7a783          	lw	a5,-162(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060c6:	10000737          	lui	a4,0x10000
  if(panicked){
    800060ca:	c391                	beqz	a5,800060ce <uartputc_sync+0x24>
    for(;;)
    800060cc:	a001                	j	800060cc <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060ce:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060d2:	0ff7f793          	andi	a5,a5,255
    800060d6:	0207f793          	andi	a5,a5,32
    800060da:	dbf5                	beqz	a5,800060ce <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060dc:	0ff4f793          	andi	a5,s1,255
    800060e0:	10000737          	lui	a4,0x10000
    800060e4:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800060e8:	00000097          	auipc	ra,0x0
    800060ec:	2ae080e7          	jalr	686(ra) # 80006396 <pop_off>
}
    800060f0:	60e2                	ld	ra,24(sp)
    800060f2:	6442                	ld	s0,16(sp)
    800060f4:	64a2                	ld	s1,8(sp)
    800060f6:	6105                	addi	sp,sp,32
    800060f8:	8082                	ret

00000000800060fa <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060fa:	00003717          	auipc	a4,0x3
    800060fe:	f2673703          	ld	a4,-218(a4) # 80009020 <uart_tx_r>
    80006102:	00003797          	auipc	a5,0x3
    80006106:	f267b783          	ld	a5,-218(a5) # 80009028 <uart_tx_w>
    8000610a:	06e78c63          	beq	a5,a4,80006182 <uartstart+0x88>
{
    8000610e:	7139                	addi	sp,sp,-64
    80006110:	fc06                	sd	ra,56(sp)
    80006112:	f822                	sd	s0,48(sp)
    80006114:	f426                	sd	s1,40(sp)
    80006116:	f04a                	sd	s2,32(sp)
    80006118:	ec4e                	sd	s3,24(sp)
    8000611a:	e852                	sd	s4,16(sp)
    8000611c:	e456                	sd	s5,8(sp)
    8000611e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006120:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006124:	00020a17          	auipc	s4,0x20
    80006128:	0e4a0a13          	addi	s4,s4,228 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    8000612c:	00003497          	auipc	s1,0x3
    80006130:	ef448493          	addi	s1,s1,-268 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006134:	00003997          	auipc	s3,0x3
    80006138:	ef498993          	addi	s3,s3,-268 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000613c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006140:	0ff7f793          	andi	a5,a5,255
    80006144:	0207f793          	andi	a5,a5,32
    80006148:	c785                	beqz	a5,80006170 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000614a:	01f77793          	andi	a5,a4,31
    8000614e:	97d2                	add	a5,a5,s4
    80006150:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006154:	0705                	addi	a4,a4,1
    80006156:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006158:	8526                	mv	a0,s1
    8000615a:	ffffb097          	auipc	ra,0xffffb
    8000615e:	718080e7          	jalr	1816(ra) # 80001872 <wakeup>
    
    WriteReg(THR, c);
    80006162:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006166:	6098                	ld	a4,0(s1)
    80006168:	0009b783          	ld	a5,0(s3)
    8000616c:	fce798e3          	bne	a5,a4,8000613c <uartstart+0x42>
  }
}
    80006170:	70e2                	ld	ra,56(sp)
    80006172:	7442                	ld	s0,48(sp)
    80006174:	74a2                	ld	s1,40(sp)
    80006176:	7902                	ld	s2,32(sp)
    80006178:	69e2                	ld	s3,24(sp)
    8000617a:	6a42                	ld	s4,16(sp)
    8000617c:	6aa2                	ld	s5,8(sp)
    8000617e:	6121                	addi	sp,sp,64
    80006180:	8082                	ret
    80006182:	8082                	ret

0000000080006184 <uartputc>:
{
    80006184:	7179                	addi	sp,sp,-48
    80006186:	f406                	sd	ra,40(sp)
    80006188:	f022                	sd	s0,32(sp)
    8000618a:	ec26                	sd	s1,24(sp)
    8000618c:	e84a                	sd	s2,16(sp)
    8000618e:	e44e                	sd	s3,8(sp)
    80006190:	e052                	sd	s4,0(sp)
    80006192:	1800                	addi	s0,sp,48
    80006194:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006196:	00020517          	auipc	a0,0x20
    8000619a:	07250513          	addi	a0,a0,114 # 80026208 <uart_tx_lock>
    8000619e:	00000097          	auipc	ra,0x0
    800061a2:	1a4080e7          	jalr	420(ra) # 80006342 <acquire>
  if(panicked){
    800061a6:	00003797          	auipc	a5,0x3
    800061aa:	e767a783          	lw	a5,-394(a5) # 8000901c <panicked>
    800061ae:	c391                	beqz	a5,800061b2 <uartputc+0x2e>
    for(;;)
    800061b0:	a001                	j	800061b0 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061b2:	00003797          	auipc	a5,0x3
    800061b6:	e767b783          	ld	a5,-394(a5) # 80009028 <uart_tx_w>
    800061ba:	00003717          	auipc	a4,0x3
    800061be:	e6673703          	ld	a4,-410(a4) # 80009020 <uart_tx_r>
    800061c2:	02070713          	addi	a4,a4,32
    800061c6:	02f71b63          	bne	a4,a5,800061fc <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061ca:	00020a17          	auipc	s4,0x20
    800061ce:	03ea0a13          	addi	s4,s4,62 # 80026208 <uart_tx_lock>
    800061d2:	00003497          	auipc	s1,0x3
    800061d6:	e4e48493          	addi	s1,s1,-434 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061da:	00003917          	auipc	s2,0x3
    800061de:	e4e90913          	addi	s2,s2,-434 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061e2:	85d2                	mv	a1,s4
    800061e4:	8526                	mv	a0,s1
    800061e6:	ffffb097          	auipc	ra,0xffffb
    800061ea:	500080e7          	jalr	1280(ra) # 800016e6 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061ee:	00093783          	ld	a5,0(s2)
    800061f2:	6098                	ld	a4,0(s1)
    800061f4:	02070713          	addi	a4,a4,32
    800061f8:	fef705e3          	beq	a4,a5,800061e2 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061fc:	00020497          	auipc	s1,0x20
    80006200:	00c48493          	addi	s1,s1,12 # 80026208 <uart_tx_lock>
    80006204:	01f7f713          	andi	a4,a5,31
    80006208:	9726                	add	a4,a4,s1
    8000620a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000620e:	0785                	addi	a5,a5,1
    80006210:	00003717          	auipc	a4,0x3
    80006214:	e0f73c23          	sd	a5,-488(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	ee2080e7          	jalr	-286(ra) # 800060fa <uartstart>
      release(&uart_tx_lock);
    80006220:	8526                	mv	a0,s1
    80006222:	00000097          	auipc	ra,0x0
    80006226:	1d4080e7          	jalr	468(ra) # 800063f6 <release>
}
    8000622a:	70a2                	ld	ra,40(sp)
    8000622c:	7402                	ld	s0,32(sp)
    8000622e:	64e2                	ld	s1,24(sp)
    80006230:	6942                	ld	s2,16(sp)
    80006232:	69a2                	ld	s3,8(sp)
    80006234:	6a02                	ld	s4,0(sp)
    80006236:	6145                	addi	sp,sp,48
    80006238:	8082                	ret

000000008000623a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000623a:	1141                	addi	sp,sp,-16
    8000623c:	e422                	sd	s0,8(sp)
    8000623e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006240:	100007b7          	lui	a5,0x10000
    80006244:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006248:	8b85                	andi	a5,a5,1
    8000624a:	cb91                	beqz	a5,8000625e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000624c:	100007b7          	lui	a5,0x10000
    80006250:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006254:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006258:	6422                	ld	s0,8(sp)
    8000625a:	0141                	addi	sp,sp,16
    8000625c:	8082                	ret
    return -1;
    8000625e:	557d                	li	a0,-1
    80006260:	bfe5                	j	80006258 <uartgetc+0x1e>

0000000080006262 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006262:	1101                	addi	sp,sp,-32
    80006264:	ec06                	sd	ra,24(sp)
    80006266:	e822                	sd	s0,16(sp)
    80006268:	e426                	sd	s1,8(sp)
    8000626a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000626c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000626e:	00000097          	auipc	ra,0x0
    80006272:	fcc080e7          	jalr	-52(ra) # 8000623a <uartgetc>
    if(c == -1)
    80006276:	00950763          	beq	a0,s1,80006284 <uartintr+0x22>
      break;
    consoleintr(c);
    8000627a:	00000097          	auipc	ra,0x0
    8000627e:	8fe080e7          	jalr	-1794(ra) # 80005b78 <consoleintr>
  while(1){
    80006282:	b7f5                	j	8000626e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006284:	00020497          	auipc	s1,0x20
    80006288:	f8448493          	addi	s1,s1,-124 # 80026208 <uart_tx_lock>
    8000628c:	8526                	mv	a0,s1
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	0b4080e7          	jalr	180(ra) # 80006342 <acquire>
  uartstart();
    80006296:	00000097          	auipc	ra,0x0
    8000629a:	e64080e7          	jalr	-412(ra) # 800060fa <uartstart>
  release(&uart_tx_lock);
    8000629e:	8526                	mv	a0,s1
    800062a0:	00000097          	auipc	ra,0x0
    800062a4:	156080e7          	jalr	342(ra) # 800063f6 <release>
}
    800062a8:	60e2                	ld	ra,24(sp)
    800062aa:	6442                	ld	s0,16(sp)
    800062ac:	64a2                	ld	s1,8(sp)
    800062ae:	6105                	addi	sp,sp,32
    800062b0:	8082                	ret

00000000800062b2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062b2:	1141                	addi	sp,sp,-16
    800062b4:	e422                	sd	s0,8(sp)
    800062b6:	0800                	addi	s0,sp,16
  lk->name = name;
    800062b8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062ba:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062be:	00053823          	sd	zero,16(a0)
}
    800062c2:	6422                	ld	s0,8(sp)
    800062c4:	0141                	addi	sp,sp,16
    800062c6:	8082                	ret

00000000800062c8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062c8:	411c                	lw	a5,0(a0)
    800062ca:	e399                	bnez	a5,800062d0 <holding+0x8>
    800062cc:	4501                	li	a0,0
  return r;
}
    800062ce:	8082                	ret
{
    800062d0:	1101                	addi	sp,sp,-32
    800062d2:	ec06                	sd	ra,24(sp)
    800062d4:	e822                	sd	s0,16(sp)
    800062d6:	e426                	sd	s1,8(sp)
    800062d8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062da:	6904                	ld	s1,16(a0)
    800062dc:	ffffb097          	auipc	ra,0xffffb
    800062e0:	c84080e7          	jalr	-892(ra) # 80000f60 <mycpu>
    800062e4:	40a48533          	sub	a0,s1,a0
    800062e8:	00153513          	seqz	a0,a0
}
    800062ec:	60e2                	ld	ra,24(sp)
    800062ee:	6442                	ld	s0,16(sp)
    800062f0:	64a2                	ld	s1,8(sp)
    800062f2:	6105                	addi	sp,sp,32
    800062f4:	8082                	ret

00000000800062f6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062f6:	1101                	addi	sp,sp,-32
    800062f8:	ec06                	sd	ra,24(sp)
    800062fa:	e822                	sd	s0,16(sp)
    800062fc:	e426                	sd	s1,8(sp)
    800062fe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006300:	100024f3          	csrr	s1,sstatus
    80006304:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006308:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000630a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000630e:	ffffb097          	auipc	ra,0xffffb
    80006312:	c52080e7          	jalr	-942(ra) # 80000f60 <mycpu>
    80006316:	5d3c                	lw	a5,120(a0)
    80006318:	cf89                	beqz	a5,80006332 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000631a:	ffffb097          	auipc	ra,0xffffb
    8000631e:	c46080e7          	jalr	-954(ra) # 80000f60 <mycpu>
    80006322:	5d3c                	lw	a5,120(a0)
    80006324:	2785                	addiw	a5,a5,1
    80006326:	dd3c                	sw	a5,120(a0)
}
    80006328:	60e2                	ld	ra,24(sp)
    8000632a:	6442                	ld	s0,16(sp)
    8000632c:	64a2                	ld	s1,8(sp)
    8000632e:	6105                	addi	sp,sp,32
    80006330:	8082                	ret
    mycpu()->intena = old;
    80006332:	ffffb097          	auipc	ra,0xffffb
    80006336:	c2e080e7          	jalr	-978(ra) # 80000f60 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000633a:	8085                	srli	s1,s1,0x1
    8000633c:	8885                	andi	s1,s1,1
    8000633e:	dd64                	sw	s1,124(a0)
    80006340:	bfe9                	j	8000631a <push_off+0x24>

0000000080006342 <acquire>:
{
    80006342:	1101                	addi	sp,sp,-32
    80006344:	ec06                	sd	ra,24(sp)
    80006346:	e822                	sd	s0,16(sp)
    80006348:	e426                	sd	s1,8(sp)
    8000634a:	1000                	addi	s0,sp,32
    8000634c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000634e:	00000097          	auipc	ra,0x0
    80006352:	fa8080e7          	jalr	-88(ra) # 800062f6 <push_off>
  if(holding(lk))
    80006356:	8526                	mv	a0,s1
    80006358:	00000097          	auipc	ra,0x0
    8000635c:	f70080e7          	jalr	-144(ra) # 800062c8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006360:	4705                	li	a4,1
  if(holding(lk))
    80006362:	e115                	bnez	a0,80006386 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006364:	87ba                	mv	a5,a4
    80006366:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000636a:	2781                	sext.w	a5,a5
    8000636c:	ffe5                	bnez	a5,80006364 <acquire+0x22>
  __sync_synchronize();
    8000636e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006372:	ffffb097          	auipc	ra,0xffffb
    80006376:	bee080e7          	jalr	-1042(ra) # 80000f60 <mycpu>
    8000637a:	e888                	sd	a0,16(s1)
}
    8000637c:	60e2                	ld	ra,24(sp)
    8000637e:	6442                	ld	s0,16(sp)
    80006380:	64a2                	ld	s1,8(sp)
    80006382:	6105                	addi	sp,sp,32
    80006384:	8082                	ret
    panic("acquire");
    80006386:	00002517          	auipc	a0,0x2
    8000638a:	4da50513          	addi	a0,a0,1242 # 80008860 <digits+0x20>
    8000638e:	00000097          	auipc	ra,0x0
    80006392:	a6a080e7          	jalr	-1430(ra) # 80005df8 <panic>

0000000080006396 <pop_off>:

void
pop_off(void)
{
    80006396:	1141                	addi	sp,sp,-16
    80006398:	e406                	sd	ra,8(sp)
    8000639a:	e022                	sd	s0,0(sp)
    8000639c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000639e:	ffffb097          	auipc	ra,0xffffb
    800063a2:	bc2080e7          	jalr	-1086(ra) # 80000f60 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063a6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063aa:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063ac:	e78d                	bnez	a5,800063d6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063ae:	5d3c                	lw	a5,120(a0)
    800063b0:	02f05b63          	blez	a5,800063e6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063b4:	37fd                	addiw	a5,a5,-1
    800063b6:	0007871b          	sext.w	a4,a5
    800063ba:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063bc:	eb09                	bnez	a4,800063ce <pop_off+0x38>
    800063be:	5d7c                	lw	a5,124(a0)
    800063c0:	c799                	beqz	a5,800063ce <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063c6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063ca:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063ce:	60a2                	ld	ra,8(sp)
    800063d0:	6402                	ld	s0,0(sp)
    800063d2:	0141                	addi	sp,sp,16
    800063d4:	8082                	ret
    panic("pop_off - interruptible");
    800063d6:	00002517          	auipc	a0,0x2
    800063da:	49250513          	addi	a0,a0,1170 # 80008868 <digits+0x28>
    800063de:	00000097          	auipc	ra,0x0
    800063e2:	a1a080e7          	jalr	-1510(ra) # 80005df8 <panic>
    panic("pop_off");
    800063e6:	00002517          	auipc	a0,0x2
    800063ea:	49a50513          	addi	a0,a0,1178 # 80008880 <digits+0x40>
    800063ee:	00000097          	auipc	ra,0x0
    800063f2:	a0a080e7          	jalr	-1526(ra) # 80005df8 <panic>

00000000800063f6 <release>:
{
    800063f6:	1101                	addi	sp,sp,-32
    800063f8:	ec06                	sd	ra,24(sp)
    800063fa:	e822                	sd	s0,16(sp)
    800063fc:	e426                	sd	s1,8(sp)
    800063fe:	1000                	addi	s0,sp,32
    80006400:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006402:	00000097          	auipc	ra,0x0
    80006406:	ec6080e7          	jalr	-314(ra) # 800062c8 <holding>
    8000640a:	c115                	beqz	a0,8000642e <release+0x38>
  lk->cpu = 0;
    8000640c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006410:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006414:	0f50000f          	fence	iorw,ow
    80006418:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000641c:	00000097          	auipc	ra,0x0
    80006420:	f7a080e7          	jalr	-134(ra) # 80006396 <pop_off>
}
    80006424:	60e2                	ld	ra,24(sp)
    80006426:	6442                	ld	s0,16(sp)
    80006428:	64a2                	ld	s1,8(sp)
    8000642a:	6105                	addi	sp,sp,32
    8000642c:	8082                	ret
    panic("release");
    8000642e:	00002517          	auipc	a0,0x2
    80006432:	45a50513          	addi	a0,a0,1114 # 80008888 <digits+0x48>
    80006436:	00000097          	auipc	ra,0x0
    8000643a:	9c2080e7          	jalr	-1598(ra) # 80005df8 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
