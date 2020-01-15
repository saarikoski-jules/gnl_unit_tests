#!/bin/bash

PATH_GNL=".."
dir="inc/test_files"
includes="inc/tests.c inc/bonus_tests.c inc/utils.c inc/basic_tests.c"

rm results/result_log.txt
rm results/result_log_bonus.txt
touch results/result_log.txt
touch results/result_log_bonus.txt

buf_sizes=(1 7 8 9 16 200 100000 2162)
buf_sizes_bonus=(1 7 13 14 15 2162)

GNL="${PATH_GNL}/get_next_line.c"
GNL_UTILS="${PATH_GNL}/get_next_line_utils.c"

F_GNL="fake_get_next_line.c"
F_GNL_UTILS="fake_get_next_line_utils.c"

#color codes
GREEN="\x1b[38;5;83m"
RED="\x1b[38;5;196m"
PURP="\x1b[38;5;200m"
PINK="\x1b[38;5;212m"
GREY="\x1b[38;5;244m"
DGREY="\x1b[38;5;240m"
RESET="\x1b[0m"

basic_tests() {
		compare_output() {
			./tester $1 > gnl_output.txt
			local temp=$(diff $1 gnl_output.txt)
			if [[ -n "$temp" ]]; then
				echo "${RED}FAILED${RESET}: $1"
				echo >> results/result_log.txt
				echo "Failed test $1 with buf size $2" >> results/result_log.txt
				echo >> results/result_log.txt
				diff -U 3 $1 gnl_output.txt >> results/result_log.txt
				echo >> results/result_log.txt
			fi
			rm gnl_output.txt
		}

		echo "${PINK}   _____ _   _ _         _______ ______  _____ _______ ______ _____   ";
		echo "  / ____| \ | | |       |__   __|  ____|/ ____|__   __|  ____|  __ \  ";
		echo " | |  __|  \| | |  ______  | |  | |__  | (___    | |  | |__  | |__) | ";
		echo " | | |_ | . \ | | |______| | |  |  __|  \___ \   | |  |  __| |  _  /  ";
		echo " | |__| | |\  | |____      | |  | |____ ____) |  | |  | |____| | \ \  ";
		echo "  \_____|_| \_|______|     |_|  |______|_____/   |_|  |______|_|  \_\ ${RESET}";
		echo "                                             ${GREY}-jsaariko${RESET}";
		echo "                                                   ${DGREY}make-up by ldideric${RESET}";

		echo "${PURP}Testing basic input ...${RESET}"
		echo
		for i in ${buf_sizes[@]}; do
			gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=$i $1 $2 $includes
			echo "${PINK}Tests with buf size $i${RESET}"
			compare_output $dir/4-five $i
			compare_output $dir/4-one $i
			compare_output $dir/4-one-n $i
			compare_output $dir/4-three $i
			compare_output $dir/4-two $i
			compare_output $dir/8-five $i
			compare_output $dir/8-one $i
			compare_output $dir/8-one-n $i
			compare_output $dir/8-three $i
			compare_output $dir/8-two $i
			compare_output $dir/16-five $i
			compare_output $dir/16-one $i
			compare_output $dir/16-one-n $i
			compare_output $dir/16-three $i
			compare_output $dir/16-two $i
			compare_output $dir/alpha-3ln $i
			compare_output $dir/easy $i
			compare_output $dir/empty $i
			compare_output $dir/empty-then-char $i
			compare_output $dir/libft.txt $i
			compare_output $dir/lorem1 $i
			compare_output $dir/lorem2 $i
			compare_output $dir/nl-disaster $i
			compare_output $dir/one-blank-line $i
			compare_output $dir/standard $i
			compare_output $dir/stuff $i
			compare_output $dir/these-are-four-words $i
			compare_output $dir/two-blank $i
			compare_output $dir/wazzup $i
			compare_output $dir/null-terminate $i
			echo "${GREEN}All done!${RESET}"
		done
		echo 
	}


if [[ "$*" == "bonus" ]]; then
	echo
	echo "${PURP}Testing bonus${RESET}"
	echo

	cp ${PATH_GNL}/get_next_line_bonus.h get_next_line_bonus_cpy.h

	compare_bonus() {
		./tester bonus $1 > gnl_output.txt
		local temp=$(diff -U 3 gnl_output.txt inc/bonus_results/test$1)
		if [[ -z "$temp" ]]; then
			echo "${GREEN}SUCCESS${RESET} on bonus $1"
		elif [[ -n "$temp" ]]; then
			echo "${RED}FAILED${RESET} bonus $1"
			echo >> results/result_log_bonus.txt
			echo "Failed test $1 with buf size $2" >> results/result_log_bonus.txt
			echo >> results/result_log_bonus.txt
			diff -U 3 gnl_output.txt inc/bonus_results/test$1 >> results/result_log_bonus.txt
			echo >> results/result_log_bonus.txt
		fi
		rm gnl_output.txt
	}

	for i in ${buf_sizes_bonus[@]}; do
		gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=$i -D BONUS ${PATH_GNL}/get_next_line_bonus.c ${PATH_GNL}/get_next_line_utils_bonus.c $includes
		echo "${PINK}Bonus with buf size $i${RESET}"
		compare_bonus 1 $i
		compare_bonus 2 $i
		compare_bonus 3 $i
		compare_bonus 4 $i
		echo
	done

	echo
	echo "--<>-- ${GREEN}TESTING FINISHED${RESET} --<>--"
	echo
	echo "${PINK}To test basic input: sh run_tests.sh${RESET}"
	echo "${PINK}To see differences in output, see result_log_bonus.txt in results/${RESET}"
	echo

	rm get_next_line_bonus_cpy.h

elif [[ "$*" == "malloc" ]]; then

	echo
	echo "${PURP}Running basic tests in destroy malloc mode ...${RESET}"

	cp ${PATH_GNL}/get_next_line.h get_next_line_cpy.h
	cp ${PATH_GNL}/get_next_line.c fake_get_next_line.c
	cp ${PATH_GNL}/get_next_line_utils.c fake_get_next_line_utils.c
	echo "void *destroy_malloc(size_t i);" >> get_next_line_cpy.h


	sed -i '' 's/get_next_line.h/get_next_line_cpy.h/g' fake_get_next_line.c fake_get_next_line_utils.c

	perl -pi -e 's/([\s\(\)])malloc\(/\1destroy_malloc\(/g' fake_get_next_line.c fake_get_next_line_utils.c	

	basic_tests $F_GNL $F_GNL_UTILS

	rm get_next_line_cpy.h
	rm fake_get_next_line.c
	rm fake_get_next_line_utils.c

else


	cp ${PATH_GNL}/get_next_line.h get_next_line_cpy.h
	sed -i '' 's/GET_NEXT_LINE_H/GET_NEXT_LINE_CPY_H/g' get_next_line_cpy.h

	echo "void *fake_malloc(size_t i);" >> get_next_line_cpy.h
	echo "void *count_malloc(size_t size);" >> get_next_line_cpy.h
	echo "void count_free(void *ptr);" >> get_next_line_cpy.h

	basic_tests $GNL $GNL_UTILS

	echo "${PURP}Testing miscellaneous tests ...${RESET}"
	echo
	echo "${PINK}Testing large files ...${RESET}"

	compare_output $dir/bible $i
	compare_output $dir/long-1x $i
	compare_output $dir/long-3x $i
	compare_output $dir/long-clear $i
	compare_output $dir/doomed-to-fail $i
	echo "${GREEN}All done!${RESET}"

	gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=12 ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c $includes

	echo
	echo "${PINK}Testing with bad line param ...${RESET}"
	./tester null > gnl_output.txt
	temp=$(diff $dir/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "${GREEN}SUCCESS${RESET} with NULL line param"
	elif [[ -n "$temp" ]]; then
		echo "${RED}FAILED${RESET} with NULL line param"
		diff -U 3 $dir/empty gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	echo
	echo "${PINK}Testing with stdin ...${RESET}"
	cat $dir/easy | ./tester  > gnl_output.txt
	temp=$(diff $dir/easy gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "${GREEN}SUCCESS${RESET} with stdin"
	elif [[ -n "$temp" ]]; then
		echo "${RED}FAILED${RESET} with stdin"
		diff -U 3 $dir/easy gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=0 ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c $includes

	echo
	echo "${PINK}Testing with buf size 0 ...${RESET}"
	./tester $dir/4-five > gnl_output.txt
	temp=$(diff $dir/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "${GREEN}SUCCESS${RESET} with buf size 0"
	elif [[ -n "$temp" ]]; then
		echo "${RED}FAILED${RESET} with buf size 0"
		diff -U 3 $1 gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=-1 ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c $includes

	echo
	echo "${PINK}Testing with buf size -1 ...${RESET}"
	./tester neg > gnl_output.txt
	temp=$(diff $dir/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "${GREEN}SUCCESS${RESET} with buf size -1"
	elif [[ -n "$temp" ]]; then
		echo "${RED}FAILED${RESET} with buf size -1"
		diff -U 3 $dir/empty gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=1 ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c $includes

	echo
	echo "${PINK}Testing with bad fd ...${RESET}"
	./tester fd > gnl_output.txt
	temp=$(diff $dir/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "${GREEN}SUCCESS${RESET} with bad fd"
	elif [[ -n "$temp" ]]; then
		echo "${RED}FAILED${RESET} with bad fd -1"
		diff -U 3 $dir/empty gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	echo
	echo "${PINK}Testing malloc protection ...${RESET}"

	cp ${PATH_GNL}/get_next_line.c fake_get_next_line.c
	cp ${PATH_GNL}/get_next_line_utils.c fake_get_next_line_utils.c

	sed -i '' 's/get_next_line.h/get_next_line_cpy.h/g' fake_get_next_line.c fake_get_next_line_utils.c

	perl -pi -e 's/([\s\(\)])malloc\(/\1fake_malloc\(/g' fake_get_next_line.c fake_get_next_line_utils.c	
	
	gcc -o tester -D BUFFER_SIZE=1 fake_get_next_line.c fake_get_next_line_utils.c $includes
	rm fake_get_next_line.c
	rm fake_get_next_line_utils.c

	./tester alloc > gnl_output.txt
	ERR=$?;
	if [ $ERR -ne 0 ]; then 
		echo "${RED}FAILED${RESET} segfaults on malloc protection tests"
		echo "FAILED segfaults on malloc protection tests" >> results/result_log.txt
	else
		temp=$(diff $dir/empty gnl_output.txt)
		if [[ -z "$temp" ]]; then
			echo "${GREEN}SUCCESS${RESET} with malloc protection"
		elif [[ -n "$temp" ]]; then
			echo "${RED}FAILED${RESET} Bad return value when malloc fails"
			diff -U 3 $dir/empty gnl_output.txt >> results/result_log.txt
		fi
	fi
	rm gnl_output.txt

	echo
	echo "${PINK}Testing for memory leaks ...${RESET}"

	cp ${PATH_GNL}/get_next_line.c fake_get_next_line.c
	cp ${PATH_GNL}/get_next_line_utils.c fake_get_next_line_utils.c

	sed -i '' 's/get_next_line.h/get_next_line_cpy.h/g' fake_get_next_line.c fake_get_next_line_utils.c

	perl -pi -e 's/([\s\(\)])malloc\(/\1count_malloc\(/g' fake_get_next_line.c fake_get_next_line_utils.c	
	perl -pi -e 's/([\s\(\)])free\(/\1count_free\(/g' fake_get_next_line.c fake_get_next_line_utils.c	

	leak_check() {
		./tester leaks $1 $2>> gnl_output.txt
	}

	for i in ${buf_sizes[@]}; do
		gcc -o tester -D BUFFER_SIZE=$i fake_get_next_line.c fake_get_next_line_utils.c $includes
		leak_check $dir/4-five $i
		leak_check $dir/4-one-n $i
		leak_check $dir/8-one $i
		leak_check $dir/16-five $i
		leak_check $dir/alpha-3ln $i
		leak_check $dir/empty $i
		leak_check $dir/lorem2 $i
		leak_check $dir/nl-disaster $i
		leak_check $dir/these-are-four-words $i
	done

	rm fake_get_next_line.c
	rm fake_get_next_line_utils.c

	temp=$(diff $dir/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "${GREEN}SUCCESS${RESET} No leaks found"
	elif [[ -n "$temp" ]]; then
		echo "${RED}FAILED${RESET}: Leaks found"
		diff -U 3 $dir/empty gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	echo
	echo "--<>-- ${GREEN}TESTING FINISHED${RESET} --<>--"
	echo
	echo "${PINK}To test in break malloc mode, run sh run_test.sh malloc${RESET}"
	echo "${PINK}To test bonus, run sh run_tests.sh bonus${RESET}"
	echo "${PINK}To see the differences in output, see result_log.txt in results/${RESET}"
	echo

	rm get_next_line_cpy.h

fi

rm tester
