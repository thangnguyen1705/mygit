#!/bin/bash
#Created by PhuNH 01/06/2019
#Mục tiêu:
#- Hàng ngày sẽ đẩy file log đã nén lại của ngày hôm đó lên S3
#- Đường dẫn mục tiêu sẽ là: s3://nexttech-backup/Tên_server/Service/Tên_file_log/năm/tháng/ngày/filelog
#* Yêu cầu
#- Phải chạy logrotate hàng ngày
#- File log phải có chứa từ access (đối với access log)
#- Server cài awscli
#- Mỗi dự án (VLAN) sẽ có 1 cặp access key riêng
#* Cách thức chạy
#- Đặt crontab chạy file backup hàng ngày trong khoảng từ 6h - 23h
#- lệnh chạy như sau: /bin/bash backup.sh đường_dẫn_thư_mục_chứa_log tên_service
#- VD: /bin/bash /usr/local/sbin/backup_to_s3.sh /var/log httpd

path=$1
list=`find  -name "*.gz" -mtime +60 | sed  's/\.\///g'`
for file in $list;do
    aws s3 sync $path/$file s3://nexttech-backup/$HOSTNAME/$path/$file
done