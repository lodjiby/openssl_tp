#!/usr/bin/env bash
#
# Partie 2:

value=($(seq 1 5))
i=0

echo ${value[@]}

read input
while [ $i -lt ${#value[@]} ] && [ "$input" != "${value[$i]}" ]; do
	#echo ${value[$i]}
	((++i))	
done


if [ ! $i -lt ${#value[@]} ]; then
	echo "nop"
fi







cat << 'EOF' &> /dev/null

while true; do

if [ "$1" == 2 ]; then    # si le 2nd argument est 2 --> Partie2 du tp.

	openssl enc -base64 -in "$2" > ./base64.passwd.txt

	# send the encoded passwd by mail#
elif [ "$1" == 3 ]; then  # Partie 3 du tp
	if [ "$2" == "enc" ]; then     # chiffrement
	openssl enc -aes-256-cbc -salt -in "$3" -out "$3".enc -k "$4" # chiffrement

	elif [ "$2" == "dec" ]; then   # dechiffrement
		out=$(echo "$3" | sed 's/.enc//')
		openssl enc -d -aes-256-cbc -salt -in "$3" -out "$out" -k "$4"
	else
		echo "Unknown option: use enc or dec"
	fi
elif [ "$1" == 4]; then # partie 4
	

fi

done
EOF
