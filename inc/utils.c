#include "gnl_tests.h"

void *count_malloc(size_t size)
{
	g_alloc_amt++;
	return(malloc(size));
}

void count_free(void *ptr)
{
	if (ptr != NULL)
	{
		g_free_amt++;
		free(ptr);
	}
}

void *fake_malloc(size_t i)
{
	void		*ptr;

    g_count++;
	ptr = NULL;
	if (g_count != g_tofail)
		ptr = malloc(i);
    return ptr;
}

void print_result(char *line)
{
	if (line == NULL)
		printf("\n");
	else
		printf("%s\n", line);
	free(line);
}

int		empty_gnl(int fd)
{
	int		ret;
	char	*line;

	line = NULL;
	ret = get_next_line(fd, &line);
	while (ret != 0 && ret != -1)
	{
		free(line);
		line = NULL;
		ret = get_next_line(fd, &line);
	}
	if (ret != -1)
		free(line);
	return (ret);
}

void	*destroy_malloc(size_t i)
{
	void *ptr;
	size_t j;

	j = 0;
	ptr = malloc(i);
	while(j < i)
	{
		((char*)ptr)[j] = 'a';
		j++;
	}
	return(ptr);
}