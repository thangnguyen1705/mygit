find -name "*log" -mtime +90 -exec echo -n -e {}"\0" \; | du -hc --files0-from=-
# delete the files!
find /var/lib/docker/volumes/web-ap-adflex-dosg23-php7-home-public-html/_data/g8.ap.adflex.vn/storage/logs -name "*log" -mtime +90 -exec rm '{}' \;doc  