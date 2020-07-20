user="giaplv"
checkuser=`cat /etc/passwd | grep $user`
if [[ ! -z "$checkuser" ]] ; then
    userdel $user
    mv /home/$user /home/$user.old
    sed -i '/'$user'/d' /etc/sudoers
    sed -i '/'$user'/d' /etc/passwd
    sed -i '/'$user'/d' /etc/yubipasswd
fi
