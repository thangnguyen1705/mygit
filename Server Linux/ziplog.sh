find /data/www/docker.vimo.vn/logs/vimo_web/ -name "*.gz" -print -exec mv {} /data/logs/vimo_web/ \;
find /data/www/docker.vimo.vn/logs/vimo_web/ -type f -name "*.txt" -not -name '*.gz' -mtime +7 -exec sh -c '
  for file do
        gzip -c $file > $file"$(date +%Y%m%d%u_%Hh%Mm)".gz
        /bin/rm $file
  done' sh {} +
find /data/www/www.vimo.vn/apps/runtime/logs -name "*.gz" -print -exec mv {} /data/logs/vimo_web/ \;
find /data/www/www.vimo.vn/apps/runtime/logs -type f -name "*.txt" -not -name '*.gz' -mtime +7 -exec sh -c '
  for file do
        gzip -c $file > $file"$(date +%Y%m%d%u_%Hh%Mm)".gz
        /bin/rm $file
  done' sh {} +
