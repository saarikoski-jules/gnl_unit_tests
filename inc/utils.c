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

char	*ft_test_strjoin(char const *s1, char const *s2)
{
	char	*new;
	int		i;
	int		j;

	if (s1 == NULL || s2 == NULL)
		return (NULL);
	new = (char *)malloc((strlen(s1) + strlen(s2) + 1) * sizeof(char));
	if (new == NULL)
		return (NULL);
	i = 0;
	while (s1[i] != '\0')
	{
		new[i] = s1[i];
		i++;
	}
	j = 0;
	while (s2[j] != '\0')
	{
		new[i] = s2[j];
		j++;
		i++;
	}
	new[i] = '\0';
	return (new);
}