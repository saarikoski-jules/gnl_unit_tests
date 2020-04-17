#ifndef GNL_TESTS_H
# define GNL_TESTS_H
# include <stdio.h>
# include <stdlib.h>
# include <fcntl.h>
# include <unistd.h>
# include <string.h>
# ifndef BONUS
#  include "../get_next_line_cpy.h"
# else
#  include "../get_next_line_bonus_cpy.h"
# endif

extern int g_tofail;
extern int g_count;
extern int g_alloc_amt;
extern int g_free_amt;

void basic_tests(int fd, int lc);
void null_test();
void neg_buf_size_test();
void zero_buf_size_test();
void invalid_fd_test();
void alloc_tests();
void leak_test(char *arg, int buf_size);
void bonus_test_one();
void bonus_test_two();
void bonus_test_three();
void bonus_test_four();
void bonus_tests(int test_num);
void *count_malloc(size_t size);
void count_free(void *ptr);
void *fake_malloc(size_t i);
void *destroy_malloc(size_t i);
void print_result(char *line);
int	empty_gnl(int fd);
int get_linecount(int fd);
char *ft_test_strjoin(const char *str1, const char *str2);

#endif