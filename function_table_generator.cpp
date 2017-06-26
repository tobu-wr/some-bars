#include <fstream>
#include <cmath>

int main()
{
	constexpr double PI = std::acos(-1);
	std::ofstream file("table.bin");

	for(int i = 0; i < 256; ++i)
	{
		unsigned char f = std::sin(i / 64.0 * PI) * 32.0 + 48.0;
		file.write((char*)&f, 1);
	}
}