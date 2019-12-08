#!/bin/bash

PATH_GNL="../jsaariko2"

rm results/result_log.txt
rm results/result_log_bonus.txt
touch results/result_log.txt
touch results/result_log_bonus.txt

buf_sizes=(1 7 8 9 16 200 100000 2162)
buf_sizes_bonus=(1 7 13 14 15 2162)

cp ${PATH_GNL}/get_next_line.h .

# This adds the prototype for fake_malloc to the header file
echo "void *fake_malloc(size_t i);" >> get_next_line.h

if [[ "$*" == "bonus" ]]; then
	echo
	echo "Testing bonus"
	echo

	compare_bonus() {
		./tester bonus $1 > gnl_output.txt
		local temp=$(diff -U 3 gnl_output.txt bonus_results/test$1)
		if [[ -z "$temp" ]]; then
			echo "SUCCESS on bonus $1"
		elif [[ -n "$temp" ]]; then
			echo "\033[0;31mFAILED bonus $1\033[0m"
			echo >> results/result_log_bonus.txt
			echo "Failed test $1 with buf size $2" >> results/result_log_bonus.txt
			echo >> results/result_log_bonus.txt
			diff -U 3 gnl_output.txt bonus_results/test$1 >> results/result_log_bonus.txt
			echo >> results/result_log_bonus.txt
		fi
		rm gnl_output.txt
	}

	for i in ${buf_sizes_bonus[@]}; do
		gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=$i ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c tests.c -L. -lft
		echo "Bonus with buf size $i"
		compare_bonus 1 $i
		compare_bonus 2 $i
		compare_bonus 3 $i
		echo
	done

	echo "Bonus tests finished"
	echo "To test basic input: sh run_tests.sh"
	echo "To see differences in output, see result_log_bonus.txt in results/"

else
	compare_output() {
		./tester $1 > gnl_output.txt
		local temp=$(diff $1 gnl_output.txt)
		if [[ -z "$temp" ]]; then
			echo "SUCCESS $1"
		elif [[ -n "$temp" ]]; then
			echo "\033[0;31mFAILED: $1\033[0m"
			echo >> results/result_log.txt
			echo "Failed test $1 with buf size $2" >> results/result_log.txt
			echo >> results/result_log.txt
			diff -U 3 $1 gnl_output.txt >> results/result_log.txt
			echo >> results/result_log.txt
		fi
		rm gnl_output.txt
	}

	echo "Testing basic input ..."
	echo
	for i in ${buf_sizes[@]}; do
		gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=$i ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c tests.c -L. -lft
		echo "Tests with buf size $i"
		echo
		compare_output test_files/4-five $i
		compare_output test_files/4-one $i
		compare_output test_files/4-one-n $i
		compare_output test_files/4-three $i
		compare_output test_files/4-two $i
		compare_output test_files/8-five $i
		compare_output test_files/8-one $i
		compare_output test_files/8-one-n $i
		compare_output test_files/8-three $i
		compare_output test_files/8-two $i
		compare_output test_files/16-five $i
		compare_output test_files/16-one $i
		compare_output test_files/16-one-n $i
		compare_output test_files/16-three $i
		compare_output test_files/16-two $i
		compare_output test_files/alpha-3ln $i
		compare_output test_files/data $i
		compare_output test_files/easy $i
		compare_output test_files/empty $i
		compare_output test_files/empty-then-char $i
		compare_output test_files/libft.txt $i
		compare_output test_files/lorem1 $i
		compare_output test_files/lorem2 $i
		compare_output test_files/nl-disaster $i
		compare_output test_files/one-blank-line $i
		compare_output test_files/standard $i
		compare_output test_files/stuff $i
		compare_output test_files/these-are-four-words $i
		compare_output test_files/two-blank $i
		compare_output test_files/wazzup $i
		compare_output test_files/null-terminate $i
		echo
	done

	echo "Testing large files ..."
	echo

	compare_output test_files/bible $i
	compare_output test_files/long-1x $i
	compare_output test_files/long-3x $i
	compare_output test_files/long-clear $i
	compare_output test_files/doomed-to-fail $i

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
		diff test_files/empty gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

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


	gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=-1 ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c tests.c -L. -lft

	echo
	echo "Testing with buf size -1 ..."
	echo
	./tester neg > gnl_output.txt
	temp=$(diff test_files/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "SUCCESS with buf size -1"
	elif [[ -n "$temp" ]]; then
		echo "\033[0;31mFAILED with buf size -1\033[0m"
		diff test_files/empty gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=1 ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c tests.c -L. -lft

	echo
	echo "Testing with bad fd ..."
	echo
	./tester fd > gnl_output.txt
	temp=$(diff test_files/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "SUCCESS with bad fd"
	elif [[ -n "$temp" ]]; then
		echo "\033[0;31mFAILED with bad fd\033[0m"
		diff test_files/empty gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	cp ../get_next_line.c fake_get_next_line.c
	cp ${PATH_GNL}/get_next_line_utils.c fake_get_next_line_utils.c
	perl -pi -e 's/([\s\(\)])malloc\(/\1fake_malloc\(/g' fake_get_next_line.c fake_get_next_line_utils.c
	gcc -o tester -D BUFFER_SIZE=-12 fake_get_next_line.c fake_get_next_line_utils.c tests.c -L. -lft
	rm fake_get_next_line.c
	rm fake_get_next_line_utils.c

	echo
	echo "Testing malloc protection ..."
	echo
	./tester alloc

	echo
	echo "Testing finished"
	echo "To test bonus, run sh run_tests.sh bonus"
	echo "To see the differences in output, see result_log.txt in results/"
fi

rm get_next_line.h
rm tester
