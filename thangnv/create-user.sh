user="thangnv"
pass=""
yubikey="test"
sudo="1"
publickey=""

useradd $user

if [[ ! -z "$pass" ]] ; then
    echo -e $pass'\n'$pass | passwd $user
    echo "pass"
fi

if [[ ! -z "$yubikey" ]] ; then
    yubikey_old=`cat /etc/yubipasswd | grep thangnv | awk -F':' '{print $2}'| sed '$!d'`
    if [[ "$yubikey" != "$yubikey_old" ]] ; then
    sed -i 's/'$user'/\#'$user'/g'  /etc/yubipasswd
    echo $user:$yubikey >> /etc/yubipasswd #key offline
    echo "yubikey"
    fi
fi

if [ $sudo == 1 ] ; then
    checkuser=`cat /etc/sudoers | grep $user`
    echo "check sudo" $user
    if [[ -z "$checkuser" ]] ; then
    echo $user 'ALL=(ALL)        ALL' >> /etc/sudoers
    echo "sudo "
    fi
fi

if [[ ! -z "$publickey" ]] ; then
    cd /home/$user
    mkdir ./.ssh
    chmod 700 ./.ssh
    touch ./.ssh/authorized_keys
    chmod 600 ./.ssh/authorized_keys
    echo $publickey >> /home/$user/.ssh/authorized_keys
    echo "publickey"
fi

