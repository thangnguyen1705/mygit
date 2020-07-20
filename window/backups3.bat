@echo on
echo "###########################" >> E:\SQL\scrip-backup\log.txt
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"

set "nam=%YYYY%"
set "thang=%MM%" 
set "ngay=%DD%"

set userprofile=C:\Users\thangnv
aws configure set AWS_ACCESS_KEY_ID AKIAY3LYZSBNNBF34XN6
aws configure set AWS_SECRET_ACCESS_KEY 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
aws configure set default.region ap-southeast-1

echo "start time %fullstamp%" >> E:\SQL\scrip-backup\log.txt

aws s3 sync E:\SQL\Backup\ s3://pushsale-backup/10.0.61.32/
echo Ok >> E:\SQL\scrip-backup\log.txt

for /d %%D in ("E:\SQL\Backup\*") do echo %%~nxD && (
    forfiles -p %%~fD -s -m *.bak -d -3 -c "cmd /c del @path"
)

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"
echo "End time %fullstamp%" >> E:\SQL\scrip-backup\log.txt
pause