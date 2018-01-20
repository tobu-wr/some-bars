CXX=g++

all: plasma.gb

plasma.gb: plasma.o
	wlalink linkfile plasma.gb

plasma.o: plasma.s
	wla-gb plasma.s

clean:
	rm plasma.gb plasma.o
