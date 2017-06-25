#include <fstream>
#include <cmath>

int main()
{
	std::ofstream file("table.bin");

	for(int i = 0; i < 256; ++i)
	{
		unsigned char f = (std::sin(i / 64.0 * 3.14) * 30.0 + 80.0) + std::sin(i / 16.0 * 3.14) * 15.0;
		file.write((char*)&f, 1);
	}
}