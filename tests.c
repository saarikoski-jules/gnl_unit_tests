#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include "libft.h"
#include "get_next_line.h"

static int g_tofail = -1;
static int g_count = 0;

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

static void		empty_gnl(int fd)
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
}

void bonus_test_one()
{
	int fd1;
	int fd2;
	char *line;
	line = NULL;

	fd1 = open("test_files/bonus-1", O_RDONLY);
	fd2 = open("test_files/bonus-2", O_RDONLY);
	get_next_line(fd1, &line);
	print_result(line);
	get_next_line(fd1, &line);
	print_result(line);
	get_next_line(fd2, &line);
	print_result(line);
	get_next_line(fd1, &line);
	print_result(line);
	empty_gnl(fd1);
	empty_gnl(fd2);
	close(fd1);
	close(fd2);
}

void bonus_test_two()
{
	int fd1;
	int fd2;
	int fd3;
	char *line;
	line = NULL;

	fd1 = open("test_files/bonus-1", O_RDONLY);
	fd2 = open("test_files/bonus-2", O_RDONLY);
	fd3 = open("test_files/bonus-3", O_RDONLY);
	get_next_line(fd1, &line);
	print_result(line);
	get_next_line(fd3, &line);
	print_result(line);
	get_next_line(fd2, &line);
	print_result(line);
	get_next_line(fd1, &line);
	print_result(line);
	get_next_line(fd3, &line);
	print_result(line);
	get_next_line(fd2, &line);
	print_result(line);
	get_next_line(fd2, &line);
	print_result(line);
	empty_gnl(fd1);
	empty_gnl(fd2);
	empty_gnl(fd3);
	close(fd1);
	close(fd2);
	close(fd3);
}

void bonus_test_three()
{
	int fd1;
	int fd2;
	int fd3;
	char *line;
	line = NULL;

	fd1 = open("test_files/bonus-1", O_RDONLY);
	fd2 = open("test_files/bonus-2", O_RDONLY);
	fd3 = open("test_files/bonus-3", O_RDONLY);
	get_next_line(fd1, &line);
	print_result(line);
	get_next_line(fd3, &line);
	print_result(line);
	get_next_line(fd2, &line);
	print_result(line);
	get_next_line(fd1, &line);
	print_result(line);
	get_next_line(fd3, &line);
	print_result(line);
	get_next_line(fd2, &line);
	print_result(line);
	get_next_line(fd2, &line);
	print_result(line);
	get_next_line(fd1, &line);
	print_result(line);
	get_next_line(fd2, &line);
	print_result(line);
	empty_gnl(fd1);
	empty_gnl(fd2);
	empty_gnl(fd3);
	close(fd1);
	close(fd2);
	close(fd3);
}

void bonus_tests(int test_num)
{
	char *line;

	line = NULL;
	if (test_num == 1)
		bonus_test_one();
	if (test_num == 2)
		bonus_test_two();
	if (test_num == 3)
		bonus_test_three();
}

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
	}
	if (ret != 0 && ret != 1)
		printf("return value %d\n", ret);
	close(fd);
	if (get_next_line(fd, &line) != -1)
		printf("Failed bad fd return value");
}

void null_test()
{
	int fd;

	fd = open("test_files/standard", O_RDONLY);
	if (get_next_line(fd, NULL) != -1)
		printf("Failed with null line parameter");
}

void neg_buf_size_test()
{
	char *line;

	line = NULL;
	int fd = open("test_files/standard", O_RDONLY);
	if (get_next_line(fd, &line) != -1)
		printf("Failed with negative buf size");
}

void invalid_fd_test()
{
	char *line;

	line = NULL;
	if (get_next_line(-1, &line) != -1)
		printf("Failed with invalid fd");
}

/*
** So the point is testing the first 100 allocations for protection in this way:
** - Loop over the numbers of the allocations that are going to fail and run gnl on a full file for each of them
** - fake_malloc will make only one malloc fail
** - If it crashes you failed the test. gnl should return -1 when it hits the alloc that fails, but right now that isn't tested.
*/

void alloc_tests()
{
	int fd1;
	char *line;
	line = NULL;
	int i;

	i = 1;
	while (i <= 100)
	{
		g_count = 0;
		g_tofail = i;
		fd1 = open("test_files/16-five", O_RDONLY);
		empty_gnl(fd1);
		close(fd1);
		i++;
	}
	printf("SUCCESS with malloc protection.\n");
}

int main(int amt, char **args)
{
	int fd;

	if (amt == 3 && (ft_strncmp("bonus", args[1], 100000) == 0))
		bonus_tests(ft_atoi(args[2]));
	else if (amt == 2 && (ft_strncmp("null", args[1], 100000) == 0))
		null_test();
	else if (amt == 2 && (ft_strncmp("fd", args[1], 100000) == 0))
		invalid_fd_test();
	else if (amt == 2 && (ft_strncmp("neg", args[1], 100000) == 0))
		neg_buf_size_test();
	else if (amt == 2 && (strcmp("alloc", args[1]) == 0))
		alloc_tests();
	else if (amt == 2 && (ft_strncmp("bonus", args[1], 100000) != 0))
	{
		fd = open(args[1], O_RDONLY);
		basic_tests(fd);
	}
	if (amt == 1)
	{
		fd = 0;
		basic_tests(fd);
	}
	return (0);
}

