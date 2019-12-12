#include "gnl_tests.h"

int main(int amt, char **args)
{
	int fd;

	if (amt == 3 && (strcmp("bonus", args[1]) == 0))
		bonus_tests(atoi(args[2]));
	else if (amt == 2 && (strcmp("null", args[1]) == 0))
		null_test();
	else if (amt == 2 && (strcmp("fd", args[1]) == 0))
		invalid_fd_test();
	else if (amt == 2 && (strcmp("neg", args[1]) == 0))
		neg_buf_size_test();
	else if (amt == 2 && (strcmp("alloc", args[1]) == 0))
		alloc_tests();
	else if (amt == 4 && (strcmp("leaks", args[1]) == 0))
		leak_test(args[2], atoi(args[3]));
	else if (amt == 2)
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

