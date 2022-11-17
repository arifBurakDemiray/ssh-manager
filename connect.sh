#!/bin/bash

Color_Off='\033[0m' 

BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

start_time=$SECONDS

print_ssh_conn() {
    echo
    echo -e "${BGreen}------------ ------------ ----    ----      ------------   --------   ----    ---- ----    ----"
    echo -e "${BRed}************ ************ ****    ****      ************  **********  *****   **** *****   ****" 
    echo -e "${BYellow}----         ----         ----    ----      ---          ----    ---- ------  ---- ------  ----" 
    echo -e "${BBlue}************ ************ ************      ***          ***      *** ************ ************" 
    echo -e "${BGreen}------------ ------------ ------------      ---          ---      --- ------------ ------------" 
    echo -e "${BPurple}       *****        ***** ****    ****      ***          ****    **** ****  ****** ****  ******" 
    echo -e "${BCyan}------------ ------------ ----    ----      ------------  ----------  ----   ----- ----   -----" 
    echo -e "${BWhite}************ ************ ****    ****      ************   ********   ****    **** ****    ****${Color_Off}" 
}

print_elapsed_time(){
    elapsed=$(( SECONDS - start_time ))
    echo Elapsed time: $(date -ud "@$elapsed" +'%H hour(s) %M minute(s) %S second(s)')
    echo
}

print_ssh_conn

echo -----------------------------------------------------------
echo [1/3] - List Servers: Existing Files are:
echo -----------------------------------------------------------

array=($(ls context/*.server.str))

for i in "${!array[@]}"; do
   printf '[%d]:%s\n' "$i" "${array[i]}"
done
echo -----------------------------------------------------------
printf "[2/3] - Select Server: "
read serverIdx

if ! [[ "$serverIdx" =~ ^[0-9]+$ ]]
    then
        print_ssh_conn
        print_elapsed_time
        exit 1

fi

credentials=($(cat ${array[serverIdx]}))

echo -----------------------------------------------------------
echo [3/3] - Connect Server:
echo -----------------------------------------------------------

expect -c 'spawn ssh '${credentials[0]}@${credentials[1]}' ; expect "password:"; send "'${credentials[2]}'\r"; interact'

print_ssh_conn
print_elapsed_time