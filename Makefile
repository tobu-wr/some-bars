CXX=g++

all: kefrens-bars.gb

kefrens-bars.gb: kefrens-bars.o
	wlalink linkfile kefrens-bars.gb

kefrens-bars.o: sine_table.bin kefrens-bars.s
	wla-gb kefrens-bars.s

sine_table.bin: sine_table_generator
	./sine_table_generator

sine_table_generator: sine_table_generator.cpp
	$(CXX) sine_table_generator.cpp -o sine_table_generator

clean:
	rm kefrens-bars.gb kefrens-bars.o sine_table.bin sine_table_generator
