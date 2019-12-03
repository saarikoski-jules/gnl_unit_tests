#!/bin/bash

PATH_GNL="../gnl_vogsphere"

rm results/result_log.txt
rm results/result_log_bonus.txt
touch results/result_log.txt
touch results/result_log_bonus.txt

buf_sizes=(1 7 8 9 16 200 100000 2162)

cp ${PATH_GNL}/get_next_line.h .

if [[ "$*" == "bonus" ]]; then
	echo
	echo "Testing bonus"
	echo

	compare_bonus() {
		./tester bonus $1 > gnl_output.txt
		local temp=$(diff gnl_output.txt bonus_results/test$1)
		if [[ -z "$temp" ]]; then
			echo "SUCCESS on bonus $1"
		elif [[ -n "$temp" ]]; then
			echo "\033[0;31mFAILED bonus $1\033[0m"
			diff $1 gnl_output.txt >> results/result_log_bonus.txt
		fi
		rm gnl_output.txt
	}

	for i in ${buf_sizes[@]}; do
		gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=$i ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c tests.c -L. -lft
		echo "Bonus with buf size $i"
		compare_bonus 1
		compare_bonus 2
		compare_bonus 3
		echo
	done

	echo "Bonus tests finished"
	echo "To test basic input: sh run_tests.sh"
	echo "To see differences in output, see result_log_bonus.txt"

else
	compare_output() {
		./tester $1 > gnl_output.txt
		local temp=$(diff $1 gnl_output.txt)
		if [[ -z "$temp" ]]; then
			echo "SUCCESS $1"
		elif [[ -n "$temp" ]]; then
			echo "\033[0;31mFAILED: $1\033[0m"
			diff $1 gnl_output.txt >> results/result_log.txt
		fi
		rm gnl_output.txt
	}

	echo "Testing basic input ..."
	echo
	for i in ${buf_sizes[@]}; do
		gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=$i ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c tests.c -L. -lft
		echo "Tests with buf size $i"
		echo
		compare_output test_files/4-five
		compare_output test_files/4-one
		compare_output test_files/4-one-n
		compare_output test_files/4-three
		compare_output test_files/4-two
		compare_output test_files/8-five
		compare_output test_files/8-one
		compare_output test_files/8-one-n
		compare_output test_files/8-three
		compare_output test_files/8-two
		compare_output test_files/16-five
		compare_output test_files/16-one
		compare_output test_files/16-one-n
		compare_output test_files/16-three
		compare_output test_files/16-two
		compare_output test_files/alpha-3ln
		compare_output test_files/data
		compare_output test_files/easy
		compare_output test_files/empty
		compare_output test_files/empty-then-char
		compare_output test_files/libft.txt
		compare_output test_files/lorem1
		compare_output test_files/lorem2
		compare_output test_files/nl-disaster
		compare_output test_files/one-blank-line
		compare_output test_files/standard
		compare_output test_files/stuff
		compare_output test_files/these-are-four-words
		compare_output test_files/two-blank
		compare_output test_files/wazzup
		echo
	done

	echo "Testing large files ..."
	echo

	compare_output test_files/bible
	compare_output test_files/long-1x
	compare_output test_files/long-3x
	compare_output test_files/long-clear
	compare_output test_files/doomed-to-fail

	gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=12 ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c tests.c -L. -lft

	echo
	echo "Testing with bad line param ..."
	echo
	./tester null > gnl_output.txt
	temp=$(diff test_files/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "SUCCESS with NULL line param"
	elif [[ -n "$temp" ]]; then
		echo "\033[0;31mFAILED with NULL line param\033[0m"
		diff $1 gnl_output.txt >> results/result_log.txt
	fi

	echo
	echo "Testing with stdin ..."
	echo

	cat test_files/easy | ./tester  > gnl_output.txt
	temp=$(diff test_files/easy gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "SUCCESS with stdin"
	elif [[ -n "$temp" ]]; then
		echo "\033[0;31mFAILED with stdin\033[0m"
		diff test_files/easy gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=0 ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c tests.c -L. -lft

	echo
	echo "Testing with buf size 0 ..."
	echo
	./tester test_files/4-five > gnl_output.txt
	temp=$(diff test_files/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "SUCCESS with buf size 0"
	elif [[ -n "$temp" ]]; then
		echo "\033[0;31mFAILED with buf size 0\033[0m"
		diff $1 gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt


	echo
	echo "Testing finished"
	echo "To test bonus, run sh run_tests.sh bonus"
	echo "To see the differences in output, see result_log.txt"
fi

rm get_next_line.h
rm tester
