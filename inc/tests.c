#include "gnl_tests.h"
#include <stdlib.h>

int main(int amt, char **args)
{
	int fd;
	int lc;
	char buf[100];

	if (amt == 3 && (strcmp("bonus", args[1]) == 0))
		bonus_tests(atoi(args[2]));
	else if (amt == 2 && (strcmp("null", args[1]) == 0))
		null_test();
	else if (amt == 2 && (strcmp("fd", args[1]) == 0))
		invalid_fd_test();
	else if (amt == 2 && (strcmp("neg", args[1]) == 0))
		neg_buf_size_test();
	else if (amt == 2 && (strcmp("zero", args[1]) == 0))
		zero_buf_size_test();
	else if (amt == 2 && (strcmp("alloc", args[1]) == 0))
		alloc_tests();
	else if (amt == 4 && (strcmp("leaks", args[1]) == 0))
		leak_test(args[2], atoi(args[3]));
	else if (amt == 2)
	{
		char *str = ft_test_strjoin("wc -l ", args[1]);
		char *str2 = ft_test_strjoin(str, " > lines.txt");

		free(str);
		system(str2);
		int fd2 = open("lines.txt", O_RDONLY);
		read(fd2, buf, 100);
		lc = atoi(buf);
		fd = open(args[1], O_RDONLY);
		basic_tests(fd, lc);
		free(str2);
		close(fd2);
		close(fd);
		system("rm lines.txt");
	}
	if (amt == 1)
	{
		fd = 0;
		basic_tests(fd, -1);
	}
	return (0);
}

