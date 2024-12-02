#!/usr/bin/env bash
#




# function 2 to handle the 2nd part
function partie_3() {

	local TEXT_FILE="text.txt"      # text file
	local PASSWD_FILE="passwd.txt"  # file contains the passwd
	local ENC_FILE="$TEXT_FILE.enc" # file containing the encryption


	echo -e "\t you are at the third (3rd) part:"
	echo -e "\ttype q or Q to quit this part (part 2)"
	echo -e "\taccepted arguments (3 4 5)"
	echo -e "\t============================================"
	

	while true; do
		echo -n "partie_3> "
		read input
		if [ "$input" == "q" ] || [ "$input" == "Q" ]; then
			break;
		fi
		if [ "$input" == 3 ]; then  # handle the third (3) question
			openssl help &> helpfile.txt
			grep -E -i 'sha|rsa|des|aes' --colour=auto helpfile.txt
			rm helpfile.txt
		fi
		if [ "$input" == 4 ]; then    # handle the fourth (4)question
			
				 openssl enc -aes-256-cbc -salt -in "$TEXT_FILE" -out "$ENC_FILE" -k "$PASSWD_FILE"  &> /dev/null
				 echo -e "\033[31mencryption file ----> $ENC_FILE, with passord --------> "$PASSWD_FILE"\033[0M" 
				 
			 
			 	 openssl enc -d -aes-256-cbc -salt -in "$ENC_FILE" -out "$TEXT_FILE" -k "$PASSWD_FILE" &> /dev/null
				  echo -e "\033[31mencryption file ----> $TEXT_FILE\033[0m" 
			
				 
	
		fi
		if [ "$input" == 5 ]; then   # handle the question fith (5)
	       	     TEXT_SIZE=$(stat -f "%z" "$TEXT_FILE")
		     ECN_SIZE=$(stat -f "%z" "$ENC_FILE")

		     echo "the size of plain text is: $TEXT_SIZE"
		     echo "the size of encrypted text is: $ECN_SIZE"

                     echo "le text chiffré est plus grand a cause du padding et le mode de chiffrement"
		fi 
	        if [ "$input" != 3 ] && [ "$input" != 4 ] && [ "$input" != 5 ]; then 
		       echo "Valide options are 3 or 4 or 5"
#	       	       break;		       
		fi
	done	
}


#======================================================================================================================
# the third (4rd) :
function partie_4() {


 	echo -e "\t you're in the fourth (4th) part:"
	echo -e "\t Chiffrement Asymétrique"
	echo -e "\ttype q or Q to terminate this part"


	local RSA_TEXT_FILE="rsa_text.txt"
	local RSA_LONG_TEXT_FILE="bigfile.pdf"
	local RSA_ENC_LONG_TEXT_FILE="$RSA_LONG_TEXT_FILE".enc
	local RSA_PASSWD_FILE="rsa_passwd.txt"
	local RSA_ENC_FILE="$RSA_TEXT_FILE".enc
	local ACCEPTED_VALUES=($(seq 6 16))

	echo -e "\taccepted arguments: (${ACCEPTED_VALUES[@]})"
	echo -e "\t====================================================="


	while true; do
		echo -n "partie_4> "
		read input    # get the number of the question to answered

		if [ "$input" == "q" ] || [ "$input" == "Q" ]; then
   			break;
		fi
		
		i=0
		while [ $i -lt ${#ACCEPTED_VALUES[@]} ] && [ "$input" != "${ACCEPTED_VALUES[$i]}" ]; do
			((++i))
		done
		if [ ! $i -lt ${#ACCEPTED_VALUES[@]} ]; then
			echo -n "accepted values are:"
			echo ${ACCEPTED_VALUES[@]}
			break;
		fi

		if [ "$input" == 6 ]; then
			openssl genpkey -algorithm RSA -out myRSA2048.pem -pkeyopt rsa_keygen_bits:2048 &> /dev/null # paire de clef RSA
			echo " Key pair in  -----> myRSA2048.pem"
			echo -e "\033[31mVoici le résultat de la commande more myRSA2048.pem:\033[0m"
			echo ""
			more myRSA2048.pem
			echo -n -e "\033[31ma.\033[0m"
			echo -n -e "\033[31mCe fichier contient un text, sans signification, encadrer par:\033[0m "
			echo -e "\033[31m-----BEGIN PRIVATE KEY----- et -----END PRIVATE KEY-----\033[0m"
			echo -n -e "\033[31mb.\033[0m"
			echo -e "\033[31mCe fichier est en format: PEM (Privacy Enhanced Mail)\033[0m"
			echo ""
			echo -e "\033[31mresultat de la command 'openssl rsa -in myRSA2048.pem -text'\033[0m"
			echo ""
			openssl rsa -in myRSA2048.pem -text
			echo "============================================"
			echo -e "\033[31mresultat contient le modulo, les exposant e et d, et les deux nombres premiers, en hexadecimal.\033[0m"

		fi
		if [ "$input" == 7 ]; then	
 			echo -e "\033[31mIl ne fault pas conserver la clef privée en clair, ce qui le cas actuellement pour notre clef privée.\033[0m"
		fi
		if [ "$input" == 8 ]; then
			openssl genpkey -algorithm rsa -aes-256-cbc -out keyPair.pem -outform pem \
				-pass file:"$RSA_PASSWD_FILE" -pkeyopt rsa_keygen_bits:2048 &> /dev/null
			echo -e "\033[31mpaire de clef ---------->  keyPair.pem\033[0m"

		fi
		if [ "$input" == 9 ]; then
			echo ""
			echo -e "\033[31m\tinformation sur la clef privée:\033[0m"
			echo -e "\t================================================"
			openssl pkey -in keyPair.pem -passin file:"$RSA_PASSWD_FILE" -text -noout | more
			echo ""
			echo -e "\033[31m\tinformation sur la clée publique:\033[0m"
			echo -e "\t===================================================="
			openssl pkey -in keyPair.pem -passin file:"$RSA_PASSWD_FILE" -pubout -text -noout | more
		fi
		if [ "$input" == 10 ]; then
			echo " affichage de la contenu de cette nouvelle paire de clef:"
			echo ""
                        echo -e "\033[31m\tClef privée:\033[0m"
			echo ""
			openssl pkey -in keyPair.pem -passin file:"$RSA_PASSWD_FILE"   # info on the private key
			echo ""
			echo -e "\033[31m\tClef public:\033[0m"
			echo ""
			openssl pkey -in keyPair.pem -passin file:"$RSA_PASSWD_FILE" -pubout # info on the public key
			

		fi
		if [ "$input" == 11 ]; then
			openssl pkey -in keyPair.pem -passin file:"$RSA_PASSWD_FILE" -pubout -out keyPair_public.pem &> /dev/null #public key
			echo -e "\033[31mclef public dans ----------> keyPair_public.pem\033[0m"

			# send yPair_public.pem via email
		fi
		if [ "$input" == 12 ]; then
			echo ""
			echo -e "\033[31mi. affichage avec brute mode\033[0m"
			echo ""
			more keyPair_public.pem  # i
			echo ""
			echo -e "\033[31mii. affichage avec openssl rsa -pubin:\033[0m"
			echo ""
			openssl rsa -pubin -in keyPair_public.pem -text -noout # ii

		fi
		if [ "$input" == 13 ]; then
			echo -e "\033[31mOui on peut conserver la clef public en calir, ce qui est actuellement le cas.\033[0m"
		fi
                if [ "$input" == 14 ]; then
			echo -e "\033[31mtext to be encrypted: $RSA_TEXT_FILE\033[0m"
			openssl rsautl -encrypt -inkey keyPair_public.pem -pubin -in "$RSA_TEXT_FILE" -out "$RSA_ENC_FILE" &> /dev/null
			echo -e "\033[31mencrypted text: ----------> $RSA_ENC_FILE\033[0m"

		fi
		if [ "$input" == 15 ]; then
			 openssl rsautl -encrypt -inkey keyPair_public.pem -pubin -in "$RSA_LONG_TEXT_FILE" -out "$RSA_ENC_LONG_TEXT_FILE" &> /dev/null
			# description du resultat obtenu
			echo -e "\033[31mencrypted text: ----------> $\033[0m" 
			echo " description: "
		fi
		if [ "$input" == 16 ]; then

			# get here the public key of your pair
			#  encryption with AES with passwd.
			#  encrypt the passwd the pubkey of pair you got earlier.
			#  send by mail (ENC_PASSWD , ENC_TEXT)

			echo "a faire "
		fi
			



	done

}


#==================================================================================================================================
# function to handle the fith part: (Signature Numérique)
function partie_5() {

	local ACCETED_VALUES=($(seq 17 20))
	local MESSAGE="text.txt"
	local SIGNED_MESSAGE="$MESSAGE".sign
	local MESSAGE1="message1.txt"
	local SIGNED_MESSAGE1="$MESSAGE1".sign
	local MESSAGE2="message2.txt"
	local SIGNED_MESSAGE2="$MESSAGE2".sign
	local MESSAGE3="message3.txt"
        local SIGNED_MESSAGE3="$MESSAGE3".sign
	local RSA_PASSWD_FILE="rsa_passwd.txt"


	echo -e "\t This is the fith (5th) part:"
	echo -e "\t Type q or Q to quit this part"
	echo -e "\taccepted options: (${ACCETED_VALUES[@]})"
	echo -e "\t==================================================="



	while true; do
		echo -n "partie_5> "
                read input

		if [ "$input" == "q" ] || [ "$input" == "Q" ]; then
			break;
		fi

		i=0
		while [ $i -lt ${#ACCETED_VALUES[@]} ] && [ "$input" != ${ACCETED_VALUES[$i]} ]; do
			((++i))
		done
		if [ ! $i -lt ${#ACCETED_VALUES[@]} ]; then
			echo -n "Accepted options are :"
			echo ${ACCETED_VALUES[@]}
			#break;
		fi
		if [ "$input" == 17 ]; then
			echo -e "\033[31m Il faut utiliser la clef privée pour signer\033[0m"
		fi
		if [ "$input" == 18 ]; then
			 openssl dgst -sha256 -out "$SIGNED_MESSAGE"  -passin file:"$RSA_PASSWD_FILE" -sign keyPair.pem "$MESSAGE" &> /dev/null
			 echo -e "\033[31m signed message ------> "$SIGNED_MESSAGE" \033[0m"
			 
		fi
		if [ "$input" == 19 ]; then
			openssl dgst -sha256 -out "$SIGNED_MESSAGE1"  -passin file:"$RSA_PASSWD_FILE" -sign keyPair.pem "$MESSAGE1" &> /dev/null
			 echo -e "\033[31m signed message ------> "$SIGNED_MESSAGE1" \033[0m"
			 openssl dgst -sha256 -out "$SIGNED_MESSAGE2"  -passin file:"$RSA_PASSWD_FILE" -sign keyPair.pem "$MESSAGE2" &> /dev/null
		         echo -e "\033[31m signed message ------> "$SIGNED_MESSAGE2" \033[0m"
			openssl dgst -sha256 -out "$SIGNED_MESSAGE3"  -passin file:"$RSA_PASSWD_FILE" -sign keyPair.pem "$MESSAGE3" &> /dev/null
			 echo -e "\033[31m signed message ------> "$SIGNED_MESSAGE3" \033[0m"				  
		fi
		if [ "$input" == 20 ]; then
			# transmettre les mesg.
			echo "transmettre les message"
		fi


	done	       

}

#===================================================================================================================================================
# function to handle part 6
function partie_6() {
                      

	local ACCETED_VALUES=($(seq 21 28))
	local CA_PASSWD_FILE="ca_passwd.txt"
	local RSA_PASSWD_FILE="rsa_passwd.txt" 

	echo -e "\t This is the fith (6th) part:"
	echo -e "\t Type q or Q to quit this part"
	echo -e "\t accepted arguments: ${ACCETED_VALUES[@]}"
	echo -e "\t==================================================="



	while true; do
		echo -n "partie_6> "
                read input

		if [ "$input" == "q" ] || [ "$input" == "Q" ]; then
			break;
		fi


		i=0
		while [ $i -lt ${#ACCETED_VALUES[@]} ] && [ "$input" != ${ACCETED_VALUES[$i]} ]; do
			((++i))
		done
		if [ ! $i -lt ${#ACCETED_VALUES[@]} ]; then
			echo -n "Accepted options are :"
			echo ${ACCETED_VALUES[@]}
			#break;
                fi
		if [ "$input" == 21 ]; then
			echo -e "\033[31mCerticat in -------->   user-request.pem \033[0m"
		fi
		if [ "$input" == 22 ]; then
                        
			echo ""
			echo -e "\033[31m Visualiser le certificat:\033[0m"
			echo ""
			openssl req -in user-request.pem -noout -text
			       
		fi
		if [ "$input" == 23 ]; then
			echo ""
			echo -e "paire de clef pour CA"
			 openssl genpkey -algorithm rsa -aes-256-cbc -out ca_keyPair.pem -outform pem \
				 -pass file:"$CA_PASSWD_FILE" -pkeyopt rsa_keygen_bits:2048 &> /dev/null

			echo -e "\033[31mpaire de clef de CA --------> ca_keyPair.pem\033[0m"
			echo ""
			echo -e "\033[31mrequête dans ---------> ca-request.pem\033[0m"
			echo ""
		fi
		if [ "$input" == 24 ]; then
			echo -e "\033[31m Auto Signature de ca-request.pem:\033[0m"
			echo ""
			openssl x509 -req -in ca-request.pem -out ca-certificate.pem -signkey ca_keyPair.pem -days 3650 \
				-extfile ca_openssl.cnf -passin file:"$CA_PASSWD_FILE"

		fi
		if [  "$input" == 25 ]; then
			echo""
			echo -e "\033[31m\tVisualisation de ca-certificate.pem\033[0m"
			openssl x509 -in ca-certificate.pem -noout -text
			echo ""

		fi
		if [  "$input" == 26 ]; then
			echo ""
			echo -e "\033[31m\tSignature de usercertificate.pem \033[0m"
			openssl x509 -req -in user-request.pem -out usercertificate.pem -signkey keyPair.pem -days 3650 \
				-extfile ca_openssl.cnf -passin file:"$RSA_PASSWD_FILE"
		fi
		if [  "$input" == 27 ]; then
			echo ""
			echo -e "\033[31m\tVerification de usercertificate.pem \033[0m"
			openssl x509 -in usercertificate.pem -noout -text
			echo ""

		fi
		if [ "$input" == 28 ]; then
			echo "modify and check"
		fi


	done
}

#==============================================================================================================
# partie 2 du tp
function partie_2() {


	local ACCETED_VALUES=($(seq 1 2))
	local PASSWD_FILE="passwd.txt"

	echo -e "\t This is the second (2nd) part:"
	echo -e "\t Type q or Q to quit this part"
	echo -e "\t accepted arguments: (${ACCETED_VALUES[@]})"


	while true; do
		echo -n "partie_2> "
                read input

		if [ "$input" == "q" ] || [ "$input" == "Q" ]; then
			break;
		fi


		i=0
		while [ $i -lt ${#ACCETED_VALUES[@]} ] && [ "$input" != ${ACCETED_VALUES[$i]} ]; do
			((++i))
		done
		if [ ! $i -lt ${#ACCETED_VALUES[@]} ]; then
			echo -n "Accepted options are :"
			echo ${ACCETED_VALUES[@]}
		fi
		if [ "$input" == 1 ]; then

			openssl enc -base64 -in "$PASSWD_FILE" -out base64.passwd.txt
			echo -e "\033[31m mot de passe encodé dans -----> base64.passwd.txt \033[0m"
		fi
		if ["$input" ==  2 ]; then
			echo -e "\033[31mNon, Il n'est pas sûr de protéger par ce moyen.\033[0m"
		fi
	done

}

#===========================================================================================================================================
# function for partie 1
function partie_1() {

	cat .partie_1.txt
}





#====================================================================================
#==================FONCTION CALLS===================================================


	echo -e "\t TP OPENSSL"
	echo -e "\t type q or Q to quit"

        ACCEPTED_VALUES=("partie_1" "partie_2" "partie_3" "partie_4" "partie_5" "partie_6")

	echo "entrer une partie: ( ${ACCEPTED_VALUES[@]} )" 

while true; do
	echo -n "partie_x> "
	read input

	if [ "$input" == "q" ] || [ "$input" == "Q" ]; then
		break;
	fi

	i=0
	while [ $i -lt ${#ACCETED_VALUES[@]} ] && [ "$input" != ${ACCETED_VALUES[$i]} ]; do
			((++i))
	done
	if [  $i -gt ${#ACCETED_VALUES[@]} ]; then
		echo -n "Accepted arguments are :"
		echo "${ACCEPTED_VALUES[@]}"
	fi



		if [ "$input" == "partie_1" ]; then
			partie_1
		fi
		if [ "$input" == "partie_2" ]; then
			partie_2
		fi
		if [ "$input" == "partie_3" ]; then
			partie_3
		fi
		if [ "$input" == "partie_4" ]; then
			partie_4
		fi
		if [ "$input" == "partie_5" ]; then
			partie_5
		fi
		if [ "$input" == "partie_6" ]; then
			partie_6
		fi



done























# calling functions

#partie_6






