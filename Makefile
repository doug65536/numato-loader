VERSION := "0.6 beta"
SRC := numato-loader.c n25q128a.c
OBJ := $(SRC:.c=.o)
LIBMPSSE_ARCHIVE := libmpsse-master/src/libmpsse.a
LIBS := -lftdi1 $(LIBMPSSE_ARCHIVE)
CFLAGS := -std=c11 -pedantic -Wall -O0 -DVERSION=\"$(VERSION)\" -DLIBFTDI1=1 -Ilibmpsse-master/src -ggdb3
LDFLAGS := $(LIBS) -ggdb3
LIBMPSSE_URL := https://github.com/devttys0/libmpsse/archive/master.zip

all: numato-loader

libmpsse-master.zip:
	wget -O libmpsse-master.zip $(LIBMPSSE_URL)

libmpsse-master: libmpsse-master.zip
	unzip -o libmpsse-master.zip
	cd libmpsse-master/src; CFLAGS=-DLIBFTDI1=$$\(LIBFTDI1\) ./configure --disable-python
	make -C libmpsse-master/src

$(LIBMPSSE_ARCHIVE): libmpsse-master

.o: .c
	$(CC) $(CFLAGS) -c $?

numato-loader: $(LIBMPSSE_ARCHIVE) $(OBJ)
	$(CC) -o numato-loader $(OBJ) $(LDFLAGS)

clean:
	$(RM) numato-loader $(OBJ)

dist: clean
	mkdir -p numato-loader
	cp numato-loader.c n25q128a.h n25q128a.c LICENSE TODO Makefile \
	README.md numato-loader
	tar -cvjf numato-loader.tar.bz2 numato-loader
	$(RM) -r numato-loader

.PHONY: all clean dist
