<<doc
Name: Darshanraj Mandani
Date: 4-08-2023
Description: Command-Line-Test project
Sample Input:
Sample Output:
doc

#!/bin/bash

results(){

        header
        echo

        correct_ans=($(cat answers.txt))        #correct answers are stored
        user_ans=($(cat userans.txt))           #user answers are stored
        marks_count=0

        for ans in `seq 0 9`    #loop for 10 times
        do

                if [ ${correct_ans[ans]} = ${user_ans[ans]} ]; then #if answers are matching

                        echo -e "\e[92mQ$((ans+1))\e[0m) Your answers is    : ${user_ans[ans]}"
                        echo -e "\e[92mQ$((ans+1))\e[0m) Correct answers is : ${correct_ans[ans]}"; echo
                        marks_count=$((marks_count+1))

                else

                        echo -e "\e[92mQ$((ans+1))\e[0m) Your answers is    : ${user_ans[ans]} \e[91m[Incorrect]\e[0m"
                        echo -e "\e[92mQ$((ans+1))\e[0m) Correct answers is : ${correct_ans[ans]}"; echo

                fi

        done
        #echo -e "\e[92mCorrect answers are\e[0m - ${correct_ans[*]}";echo
        #echo -e "\e[91mour answers are\e[0m     - ${user_ans[*]}";echo
        echo -e "\e[1;92mTotal Marks obtained is\e[0m : $marks_count";echo

        sed -i '1,20d' userans.txt              #clearing the answers of the user

}

start_test(){

        for i in `seq 5 5 50`; do

                header
                echo

                cat questions.txt | head -$i | tail -5 #displaying 1 question with 4 options

                for j in `seq 15 -1 1`                          #loop running backwords from 15 to 1
                do
                        echo -en "\r\e[1;34mEnter your answer\e[0m \e[1;5m$j\e[0m : \c"  # '\r' carriage return '\c' cursor will not move the new line.
                        read -t 1 answer                        # -t enables the time by 1 second & answer taking the user input

                        if [ ${#answer} -eq 1 ]                 #if the answer length is 1
                        then
                                break
                        fi

                done

                if [ ${#answer} -eq 1 ]
                then
                        echo $answer >> userans.txt             #storing useranswer is userans.txt file
                else
                        echo "timed_out" >> userans.txt #if user didn't enter any input with in 15s then store timed out
                fi

                echo
        done

        results

}

sign_in(){

        usernames=(`cat usernames.csv`)         #storing the contents of usernames.csv file in an array
        length_usernames=${#usernames[*]}       #extracting the total length/lines of usernames

        found=0
        attempts=4

        while [ $found -ne 1 ];do                       #loop till found is 1

                echo -e "\e[92mEnter your username\e[0m: "
                read login_username ; echo              #reading username from user

                for user in `seq 0 1 $((length_usernames - 1))`; do

                        if [ ${usernames[user]} = $login_username ]; then #if the username is matching with existing usernames

                                found=1
                                position=$user                  #storing the position of the username

                        fi
                done

                if [ $found -eq 1 ];then
                        echo -e "\e[95mBeauty! username found\e[0m"; echo
                else
                        echo -e "\e[91mUsername not found\e[0m"; echo

                        attempts=$((attempts-1))        #reducing the attempts if username is not matching

                        if [ $attempts -gt 0 ]
                        then
                                echo -e "\e[91mPlease try again, you have\e[0m \e[92m$attempts\e[0m \e[91mremaining\e[0m"; echo
                        else
                                echo -e "\e[91mYou have used all attempts,please sign-up again\e[0m"; echo #when attempts left is zero
                                begin
                        fi
                fi
        done

        password=(`cat passwords.csv`)                  #contents of passwords.csv are stored
        attempts=4

        while [ $attempts -ne 0 ]                               #loop till attempts left is zero
        do

                echo -e "\e[92mEnter login password\e[0m: "
                read -s login_password ; echo           #securly reading the password

                if [ $login_password = ${password[position]} ]; then #if the passwords match

                        echo -e "\e[95msign-in successful\e[0m"; echo

                        flag=1
                        while [ $flag -ne 0 ]                   #loop till flag is zero
                        do
                                echo -e "1.\e[92mTake test\e[0m"
                                echo -e "2.\e[92mexit\e[0m"; echo

                                read -p "Enter your option: " option; echo

                                case $option in
                                        1)
                                                start_test
                                                flag=0
                                                ;;
                                        2)
                                                exit
                                                ;;
                                        *)
                                                echo -e "\e[91mEnter a valid option\e[0m"; echo
                                esac
                        done
                        attempts=0

                else

                        attempts=$((attempts-1))

                        if [ $attempts -ne 0 ]; then            #for each wrong password reducing the attempts by 1

                                echo -e "\e[91mYou have entered wrong password,please try again.You have\e[0m \e[92m$attempts\e[0m \e[91mattempts remaining\e[0m"; echo

                        else

                                echo -e "\e[91mYou have used all your attempts,please sign-in again\e[0m"; echo
                                sign_in

                        fi
                fi
        done

}

sign_up(){

        usernames=(`cat usernames.csv`)          #storing the contents of usernames.csv file in an array
        length_usernames=${#usernames[*]}       #extracting the total length/lines of usernames

        echo -e "\e[92mEnter your username\e[0m: "
        read username; echo                             #reading username from user

        for user in `seq 0 1 $((length_usernames - 1))`
        do
                if [ $username = ${usernames[$user]} ]; then  #comparing entered username to the usernames in usernames.csv file

                        echo -e "\e[91mUsername already exists!! Please enter different username\e[0m"; echo
                        sign_up
                fi
        done

        header

        #password section
        flag=1
        while [ $flag -ne 0 ]                                   #loop running till flag becomes zero
        do
                echo -e "\e[92mEnter your password\e[0m: "
                read -s password; echo                          # -s -> securly reading the password

                if [ ${#password} -lt 4 ]; then         #if length of the password is less than 4 characters

                        echo -e "\e[91mPassword should contain atleast 4 characters\e[0m" ; echo
                else
                        flag=0
                fi
        done

        attempts=4

        while [ $attempts -ne 0 ]                               #until the attempts is not equal to zero run the loop
        do
                echo -e "\e[92mconfirm password\e[0m: "
                read -s conf_password ; echo #reading the confirmed password securly

                if [ $conf_password = $password ]; then         #if both passwords match

                        attempts=0

                        echo -e "\e[92mSign-up successful\e[0m" ; echo

                        echo $username >> usernames.csv                 #storing username is username.csv file
                        echo $conf_password >> passwords.csv    #storing password in password.csv file
                        begin

                else
                        attempts=$((attempts-1))                #decreasing the attempts for wrong password
                        echo -e "\e[91mRe-enter,Passwords do not match. Remaining attempts\e[0m: " $attempts; echo

                        if [ $attempts -eq 0 ];then
                                echo -e "\e[91mNo more attempts left,please sign up again\e[0m"; echo
                                sign_up
                        fi
                fi
        done

}

begin(){

        header

        echo
        echo -e "1.\e[92mSign Up\e[0m"
        echo -e "2.\e[92mSign In\e[0m"
        echo -e "3.\e[92mexit\e[0m"

        echo -e "\e[96mEnter your option\e[0m: "
        read option ; echo #reading option from user

        case $option in
                1)
                        header
                        sign_up  #function call sign-up
                        ;;
                2)
                        header
                        sign_in  #function call sign-in
                        ;;
                3)
                        exit
                        ;;
                *)
                begin
        esac
}

header(){

        sleep .5s               #sleep for .5 seconds
        clear                   #clear the previous screen
        echo -e "\e[34m-----------------------------------------------------------------\e[0m"
        echo -e "\e[96m*********************\e[0m \e[1;4;92mCOMMAND-lINE-TEST\e[0m \e[96m***********************\e[0m"
        echo -e "\e[34m-----------------------------------------------------------------\e[0m"
        echo -e "\e[1;35mTotal-Marks : 10                     Time for Each question : 15s\e[0m";echo
        echo -e "             \e[5;33mNOTE: PRESS ENTER AFTER EACH ANSWER\e[0m"; echo
}

begin #function call begin
