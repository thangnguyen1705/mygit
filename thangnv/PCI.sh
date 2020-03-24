#/bin/bash
text = "/tmp/pci.txt"
date > $text
echo "-----------------" >> $text
uname -r >> $text
echo "-----------------" >> $text
cat /etc/passwd | grep /*sh$ | awk -F: '{print $1}' >> /tmp/pci.txt
echo "awk -F: '($2 == "") {print $1}' /etc/shadow" >> /tmp/pci.txt
awk -F: '($2 == "") {print $1}' /etc/shadow >> /tmp/pci.txt

