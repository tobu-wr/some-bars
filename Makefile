CXX=g++

all: some-bars.gb

some-bars.gb: some-bars.o
	wlalink linkfile some-bars.gb

some-bars.o: sine_table.bin some-bars.s
	wla-gb some-bars.s

sine_table.bin: sine_table_generator
	./sine_table_generator

sine_table_generator: sine_table_generator.cpp
	$(CXX) sine_table_generator.cpp -o sine_table_generator

clean:
	rm some-bars.gb some-bars.o sine_table.bin sine_table_generator
