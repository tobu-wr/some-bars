all: resume-gdma.gb

resume-gdma.gb: resume-gdma.o
	wlalink linkfile resume-gdma.gb

resume-gdma.o: resume-gdma.s
	wla-gb resume-gdma.s

clean:
	rm resume-gdma.gb resume-gdma.o
