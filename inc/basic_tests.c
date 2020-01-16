#include "gnl_tests.h"

int g_alloc_amt = 0;
int g_free_amt = 0;
int g_tofail = -1;
int g_count = 0;

void basic_tests(int fd)
{
	int ret;
	char *line;
	ret = 1;
	line = NULL;
	while(ret == 1)
	{
		ret = get_next_line(fd, &line);
		if (line != NULL)
			printf("%s", line);
		if (ret > 0)
			printf("\n");
		free(line);
	}
	ret = get_next_line(fd, &line);
	if (line != NULL)
		printf("%s", line);
	if (ret > 0)
		printf("\n");
	free(line);
	if (ret != 0 && ret != 1)
		printf("return value %d\n", ret);
	close(fd);
	if (get_next_line(fd, &line) != -1)
		printf("Failed bad fd return value\n");
}

void null_test()
{
	int fd;

	fd = open("test_files/standard", O_RDONLY);
	if (get_next_line(fd, NULL) != -1)
		printf("Bad return value with null line parameter\n");
}

void neg_buff_size_test()
{
	char *line;
	int ret;

	line = NULL;
	int fd = open("test_files/standard", O_RDONLY);
	if ((ret = get_next_line(fd, &line)) != -1)
		printf("Return value %d on negative buff size\n", ret);
	if (line != NULL && strcmp(line, "\0"))
		printf("line: '%s'\n", line);
}

void zero_buff_size_test()
{
	char *line;
	int ret;

	line = NULL;
	int fd = open("test_files/standard", O_RDONLY);
	if ((ret = get_next_line(fd, &line)) != -1 && ret != 0)
		printf("Return value %d on buff size 0\n", ret);
	if (line != NULL && strcmp(line, "\0"))
		printf("line: '%s'\n", line);
}

void invalid_fd_test()
{
	char *line;
	int ret;

	line = NULL;
	if ((ret = get_next_line(-1, &line)) != -1)
		printf("Return value %d with with bad fd\n", ret);
	if (line != NULL && strcmp(line, "\0"))
		printf("line: '%s'\n", line);
}

void alloc_tests()
{
	int fd1;
	char *line;
	line = NULL;
	int i;
	int ret;

	ret = 0;
	i = 1;
	while (i <= 100)
	{
		g_count = 0;
		g_tofail = i;
		fd1 = open("inc/test_files/4-five", O_RDONLY);
		if (empty_gnl(fd1) == -1)
			ret = -1;
		if (ret != -1)
			printf("Bad return value when malloc fails\n");
		close(fd1);
		i++;
	}
}

void leak_test(char *arg, int buf_size)
{
	int fd;
	int ret;
	char *line;

	ret = 1;
	line = NULL;
	fd = open(arg, O_RDONLY);
	while (ret == 1)
	{
		ret = get_next_line(fd, &line);
		count_free(line);
	}
	close(fd);
	if (g_alloc_amt > g_free_amt)
		printf("Leaks found with buf size %d testing file %s\n", buf_size, arg);
}