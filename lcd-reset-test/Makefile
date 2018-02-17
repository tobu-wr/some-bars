CXX=g++

all: lcd-reset-test.gb

lcd-reset-test.gb: lcd-reset-test.o
	wlalink linkfile lcd-reset-test.gb

lcd-reset-test.o: lcd-reset-test.s
	wla-gb lcd-reset-test.s

clean:
	rm lcd-reset-test.gb lcd-reset-test.o
