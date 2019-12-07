/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   get_next_line.h                                    :+:    :+:            */
/*                                                     +:+                    */
/*   By: jsaariko <jsaariko@student.codam.nl>         +#+                     */
/*                                                   +#+                      */
/*   Created: 2019/11/19 16:26:15 by jsaariko       #+#    #+#                */
/*   Updated: 2019/11/30 12:59:23 by jsaariko      ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#ifndef GET_NEXT_LINE_H
# define GET_NEXT_LINE_H
# include <stdlib.h>
# include <unistd.h>

typedef struct			s_gnl_fd
{
	int					fd;
	char				*rem;
	struct s_gnl_fd		*next;
}						t_gnl_fd;

int						get_next_line(int fd, char **line);
void					handle_remainder(char **remainder, char **line_cpy);
int						read_input(t_gnl_fd *f, char **line_cpy, int ret);
char					*dup_line(char *orig, char *new, char c);
void					*ft_realloc(void *ptr, size_t size, int len);
int						find_len(char *s, char c);
t_gnl_fd				*add_fd(int fd, t_gnl_fd **store);
t_gnl_fd				*find_fd(int fd, t_gnl_fd **store);

#endif
