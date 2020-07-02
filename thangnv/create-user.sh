user="test"
pass="test"
yubikey=""
sudo="0"
publickey=""

useradd $user

if [[ ! -z "$pass" ]] ; then
    echo -e $pass'\n'$pass | passwd $user
    echo "pass"
fi

if [[ ! -z "$yubikey" ]] ; then
    echo $user:$yubikey >> /etc/yubipasswd #key offline
    echo "yubikey"
fi

if [ $sudo == 1 ] ; then
    checkuser=`cat /etc/sudoers | grep thangnv`
    if [[ ! -z "$checkuser" ]] ; then
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

