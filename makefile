ARM=arm-none-eabi
BIN_RPI3=kernel7
BIN_RPI1=kernel

OBJDIR=obj
DISASDIR=disas

CFLAGS=-g -Wall -Wextra -Werror -pedantic -fomit-frame-pointer -fno-stack-limit -mno-apcs-frame -nostartfiles -ffreestanding -marm -mthumb-interwork -O2
CFLAGS_RPI3=-mcpu=cortex-a7
CFLAGS_RPI1=-mcpu=arm1176jzf-s

ASFLAGS=
ASFLAGS_RPI3=-mcpu=cortex-a7
ASFLAGS_RPI1=-mcpu=arm1176jzf-s

DEFINES=
DEFINES_RPI3=
DEFINES_RPI1=-DRPI1

LDFLAGS=-nostartfiles

CFILES=$(wildcard core/*.c) $(wildcard drivers/*.c) $(wildcard app/*.c)
ASFILES=$(wildcard core/*.s)

LDSCRIPT=ldscript.ld

OBJS=$(patsubst %.s,$(OBJDIR)/%.o,$(ASFILES))
OBJS+=$(patsubst %.c,$(OBJDIR)/%.o,$(CFILES))

ifndef RPI1
CFLAGS+=$(CFLAGS_RPI3)
ASFLAGS+=$(ASFLAGS_RPI3)
DEFINES+=$(DEFINES_RPI3)
BIN=$(BIN_RPI3)
else
CFLAGS+=$(CFLAGS_RPI1)
ASFLAGS+=$(ASFLAGS_RPI1)
DEFINES+=$(DEFINES_RPI1)
BIN=$(BIN_RPI1)
endif

$(OBJDIR)/%.o : %.s
	$(ARM)-as $(ASFLAGS) $< -o $@

$(OBJDIR)/%.o : %.c
	$(ARM)-gcc $(CFLAGS) $(INCDIR) -c $< -o $@ $(DEFINES)

default: $(LDSCRIPT) $(OBJS)
	$(ARM)-gcc $(LDFLAGS) $(OBJS) -o $(BIN).elf $(LIBDIR) -T $(LDSCRIPT)
	$(ARM)-objcopy $(BIN).elf -O binary $(BIN).img
	$(ARM)-objdump -D $(BIN).elf > $(DISASDIR)/$(BIN)

build:
	mkdir -p $(OBJDIR) $(OBJDIR)/core $(OBJDIR)/app $(OBJDIR)/drivers $(DISASDIR)

clean:
	rm -f $(OBJS)
