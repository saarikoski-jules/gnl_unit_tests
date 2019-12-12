#include "gnl_tests.h"

void bonus_test_one()
{
	int fd1;
	int fd2;
	char *line;
	line = NULL;

	fd1 = open("inc/test_files/bonus-1", O_RDONLY);
	fd2 = open("inc/test_files/bonus-2", O_RDONLY);
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

	fd1 = open("inc/test_files/bonus-1", O_RDONLY);
	fd2 = open("inc/test_files/bonus-2", O_RDONLY);
	fd3 = open("inc/test_files/bonus-3", O_RDONLY);
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

	fd1 = open("inc/test_files/bonus-1", O_RDONLY);
	fd2 = open("inc/test_files/bonus-2", O_RDONLY);
	fd3 = open("inc/test_files/bonus-3", O_RDONLY);
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

void bonus_test_four()
{
	int fd1;
	int fd2;
	int fd3;
	int fd4;
	char *line;
	line = NULL;

	fd1 = open("inc/test_files/bonus-1", O_RDONLY);
	fd2 = open("inc/test_files/bonus-2", O_RDONLY);
	fd3 = open("inc/test_files/bonus-3", O_RDONLY);
	fd4 = open("inc/test_files/standard", O_RDONLY);
	get_next_line(fd1, &line);
	print_result(line);
	get_next_line(fd3, &line);
	print_result(line);
	get_next_line(fd2, &line);
	print_result(line);
	get_next_line(fd4, &line);
	print_result(line);
	get_next_line(fd4, &line);
	print_result(line);
	get_next_line(fd4, &line);
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
	close(fd4);
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
	if (test_num == 4)
		bonus_test_four();
}