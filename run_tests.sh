#!/bin/bash

PATH_GNL="../get_next_line"
dir="inc/test_files"
includes="inc/tests.c inc/bonus_tests.c inc/utils.c inc/basic_tests.c"

rm results/result_log.txt
rm results/result_log_bonus.txt
touch results/result_log.txt
touch results/result_log_bonus.txt

buf_sizes=(1 7 8 9 16 200 100000 2162)
buf_sizes_bonus=(1 7 13 14 15 2162)

cp ${PATH_GNL}/get_next_line.h .

echo "void *fake_malloc(size_t i);" >> get_next_line.h
echo "void *count_malloc(size_t size);" >> get_next_line.h
echo "void count_free(void *ptr);" >> get_next_line.h

if [[ "$*" == "bonus" ]]; then
	echo
	echo "Testing bonus"
	echo

	compare_bonus() {
		./tester bonus $1 > gnl_output.txt
		local temp=$(diff -U 3 gnl_output.txt inc/bonus_results/test$1)
		if [[ -z "$temp" ]]; then
			echo "SUCCESS on bonus $1"
		elif [[ -n "$temp" ]]; then
			echo "\033[0;31mFAILED bonus $1\033[0m"
			echo >> results/result_log_bonus.txt
			echo "Failed test $1 with buf size $2" >> results/result_log_bonus.txt
			echo >> results/result_log_bonus.txt
			diff -U 3 gnl_output.txt inc/bonus_results/test$1 >> results/result_log_bonus.txt
			echo >> results/result_log_bonus.txt
		fi
		rm gnl_output.txt
	}

	for i in ${buf_sizes_bonus[@]}; do
		gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=$i ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c $includes
		echo "Bonus with buf size $i"
		compare_bonus 1 $i
		compare_bonus 2 $i
		compare_bonus 3 $i
		compare_bonus 4 $i
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
		gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=$i ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c $includes
		echo "Tests with buf size $i"
		echo
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
		compare_output $dir/data $i
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
		echo
	done

	echo "Testing large files ..."
	echo

	compare_output $dir/bible $i
	compare_output $dir/long-1x $i
	compare_output $dir/long-3x $i
	compare_output $dir/long-clear $i
	compare_output $dir/doomed-to-fail $i

	gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=12 ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c $includes
	echo
	echo "Testing with bad line param ..."
	echo
	./tester null > gnl_output.txt
	temp=$(diff $dir/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "SUCCESS with NULL line param"
	elif [[ -n "$temp" ]]; then
		echo "\033[0;31mFAILED with NULL line param\033[0m"
		diff -U 3 $dir/empty gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	echo
	echo "Testing with stdin ..."
	echo

	cat $dir/easy | ./tester  > gnl_output.txt
	temp=$(diff $dir/easy gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "SUCCESS with stdin"
	elif [[ -n "$temp" ]]; then
		echo "\033[0;31mFAILED with stdin\033[0m"
		diff -U 3 $dir/easy gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=0 ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c $includes

	echo
	echo "Testing with buf size 0 ..."
	echo
	./tester $dir/4-five > gnl_output.txt
	temp=$(diff $dir/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "SUCCESS with buf size 0"
	elif [[ -n "$temp" ]]; then
		echo "\033[0;31mFAILED with buf size 0\033[0m"
		diff -U 3 $1 gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt


	gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=-1 ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c $includes

	echo
	echo "Testing with buf size -1 ..."
	echo
	./tester neg > gnl_output.txt
	temp=$(diff $dir/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "SUCCESS with buf size -1"
	elif [[ -n "$temp" ]]; then
		echo "\033[0;31mFAILED with buf size -1\033[0m"
		diff -U 3 $dir/empty gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	gcc -o tester -Wall -Wextra -Werror -D BUFFER_SIZE=1 ${PATH_GNL}/get_next_line.c ${PATH_GNL}/get_next_line_utils.c $includes

	echo
	echo "Testing with bad fd ..."
	echo
	./tester fd > gnl_output.txt
	temp=$(diff $dir/empty gnl_output.txt)
	if [[ -z "$temp" ]]; then
		echo "SUCCESS with bad fd"
	elif [[ -n "$temp" ]]; then
		echo "\033[0;31mFAILED with bad fd -1\033[0m"
		diff -U 3 $dir/empty gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	echo
	echo "Testing malloc protection ..."
	echo

	cp ${PATH_GNL}/get_next_line.c fake_get_next_line.c
	cp ${PATH_GNL}/get_next_line_utils.c fake_get_next_line_utils.c
	perl -pi -e 's/([\s\(\)])malloc\(/\1fake_malloc\(/g' fake_get_next_line.c fake_get_next_line_utils.c
	gcc -o tester -D BUFFER_SIZE=1 fake_get_next_line.c fake_get_next_line_utils.c $includes
	rm fake_get_next_line.c
	rm fake_get_next_line_utils.c

	./tester alloc > gnl_output.txt
	ERR=$?;
	if [ $ERR -ne 0 ]; then 
		echo "\033[0;31mFAILED segfaults on malloc protection tests\033[0m"
		echo "FAILED segfaults on malloc protection tests" >> results/result_log.txt
	
	temp=$(diff $dir/empty gnl_output.txt)
	elif [[ -z "$temp" ]]; then
		echo "SUCCESS with malloc protection"
	elif [[ -n "$temp" ]]; then
		echo "\033[0;31mFAILED Bad return value when malloc fails\033[0m"
		diff -U 3 $dir/empty gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	echo
	echo "Testing for memory leaks ..."
	echo

	cp ${PATH_GNL}/get_next_line.c fake_get_next_line.c
	cp ${PATH_GNL}/get_next_line_utils.c fake_get_next_line_utils.c
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
		echo "SUCCESS: No leaks found"
	elif [[ -n "$temp" ]]; then
		echo "\033[0;31mFAILED: Leaks found\033[0m"
		diff -U 3 $dir/empty gnl_output.txt >> results/result_log.txt
	fi
	rm gnl_output.txt

	echo
	echo "Testing finished"
	echo "To test bonus, run sh run_tests.sh bonus"
	echo "To see the differences in output, see result_log.txt in results/"
fi

rm get_next_line.h
rm tester
