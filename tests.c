#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include "libft.h"
#include "get_next_line.h"

// #include ${PATH_GNL}"/get_next_line.h"
// #include "../../libft_project/libft/libft.h"

// void *ft_÷ßrealloc(void *ptr, size_t size);

//Handle multiple file descriptors somehow or youll hella fail

//TEst for different fds and different buf sizes

//Do I want gnl to return an empty line if theres nothing in the file

//do bonus with a two dimentional char array and create remainder in index fd of arr.

//do i want to return an empty string or null for empty file

void bonus_test_one()
{
	int fd1;
	int fd2;
	char *line;
	line = NULL;

	fd1 = open("test_files/easy", O_RDONLY);
	fd2 = open("test_files/stuff", O_RDONLY);

	get_next_line(fd1, &line);
	printf("%s\n", line);
	get_next_line(fd1, &line);
	printf("%s\n", line);
	get_next_line(fd2, &line);
	printf("%s\n", line);
	get_next_line(fd1, &line);
	printf("%s\n", line);
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

	fd1 = open("test_files/easy", O_RDONLY);
	fd2 = open("test_files/stuff", O_RDONLY);
	fd3 = open("test_files/data", O_RDONLY);

	get_next_line(fd1, &line);
	printf("%s\n", line);
	get_next_line(fd3, &line);
	printf("%s\n", line);
	get_next_line(fd2, &line);
	printf("%s\n", line);
	get_next_line(fd1, &line);
	printf("%s\n", line);
	get_next_line(fd3, &line);
	printf("%s\n", line);
	get_next_line(fd2, &line);
	printf("%s\n", line);
	get_next_line(fd2, &line);
	printf("%s\n", line);
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

	fd1 = open("test_files/easy", O_RDONLY);
	fd2 = open("test_files/standard", O_RDONLY);
	fd3 = open("test_files/data", O_RDONLY);

	get_next_line(fd1, &line);
	printf("%s\n", line);
	get_next_line(fd3, &line);
	printf("%s\n", line);
	get_next_line(fd2, &line);
	printf("%s\n", line);
	get_next_line(fd1, &line);
	printf("%s\n", line);
	get_next_line(fd3, &line);
	printf("%s\n", line);
	get_next_line(fd2, &line);
	printf("%s\n", line);
	get_next_line(fd2, &line);
	printf("%s\n", line);
	get_next_line(fd1, &line);
	printf("%s\n", line);
	get_next_line(fd2, &line);
	printf("%s\n", line);
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

void basic_tests(char **args)
{
	int fd;
	int ret;
	char *line;

	ret = 1;
	line = NULL;
	fd = open(args[1], O_RDONLY);
	while(ret == 1)
	{
		ret = get_next_line(fd, &line);
		printf("%s", line);
		if (ret > 0)
			printf("\n");
	}
	if (ret != 0 && ret != 1)
		printf("return value %d", ret);
	close(fd);
	if (get_next_line(fd, &line) != -1)
		printf("Failed bad fd return value");
}

int main(int amt, char **args)
{
	if (amt == 3 && (ft_strncmp("bonus", args[1], 100000) == 0))
		bonus_tests(ft_atoi(args[2]));
	if (amt == 2 && (ft_strncmp("bonus", args[1], 100000) != 0))
		basic_tests(args);
	return (0);
}

