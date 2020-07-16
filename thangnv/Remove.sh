#!bin/bash
userdel $user
mv /home/$user /home/$user.old
sed -i '/'$user'/d' /etc/sudoers
sed -i '/'$user'/d' /etc/passwd
sed -i '/'$user'/d' /etc/yubipasswd
