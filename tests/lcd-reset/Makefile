CXX=g++

all: lcd-reset.gb

lcd-reset.gb: lcd-reset.o
	wlalink linkfile lcd-reset.gb

lcd-reset.o: lcd-reset.s
	wla-gb lcd-reset.s

clean:
	rm lcd-reset.gb lcd-reset.o
