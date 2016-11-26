#if 0
g++ "$0" --std=c++11 -o /tmp/ejemplo.elf || exit
exec /tmp/ejemplo.elf
exit
#endif

#include <cstdio>
#include <cstdint>

typedef uint32_t vec2[2];

struct polygon
{
	polygon(size_t n)
		: npoints(n)
	{
		points = new vec2[n];
	}

	~polygon()
	{
		delete [] points;
	}

	size_t npoints = 0;
	vec2* points = nullptr;
};

struct polygon_list
{
	polygon_list(size_t n)
		: npolys(n)
	{
		polygons = new polygon*[n];
	}

	~polygon_list()
	{
		for( int i = 0; i < npolys; i++ )
		{
			delete polygons[i];
		}
		delete [] polygons;
	}

	size_t npolys = 0;
	polygon** polygons;
};


int main( int argc, char** argv )
{
	FILE* f = fopen("asd", "rb");
	uint32_t num_polygons;
	fread(&num_polygons, sizeof(uint32_t), 1, f);

	polygon_list pl(num_polygons);

	for( int i = 0; i < num_polygons; i++ )
	{
		uint32_t num_points;
		fread(&num_points, sizeof(uint32_t), 1, f);
		pl.polygons[i] = new polygon(num_points);
		polygon* poly = pl.polygons[i];
		for( int j = 0; j < num_points; j++ )
		{
			fread(poly->points + j, sizeof(uint32_t), 2, f);
		}
	}

	fclose(f);
	return 0;
}
