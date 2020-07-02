user="test"
pass="test"
yubikey=""
sudo="0"


useradd $user
if [[ "$pass" == "NULL" ]] ; then
    echo -e $pass'\n'$pass | passwd $user
fi
if [[ "$yubikey" == "NULL" ]] ; then
    echo $user:$yubikey >> /etc/yubipasswd #key offline
fic,     
if [[ "$sudo" == "1" ] ] ; then
    echo $user 'ALL=(ALL)        ALL' >> /etc/sudoers
fi


