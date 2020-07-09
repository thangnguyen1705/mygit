@Echo off

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"

set "nam=%YYYY%"
set "thang=%MM%" 
set "ngay=%DD%"

set userprofile=C:\Users\thaopt
aws configure set AWS_ACCESS_KEY_ID AKIAY3LYZSBNNBF34XN6
aws configure set AWS_SECRET_ACCESS_KEY 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
aws configure set default.region ap-southeast-1

Set "Pattern=pushsale_data_backup_%nam%_%thang%_%ngay%"
For %%A in ("G:\backups\pushsale_data\*") Do Echo:%%~nA|findstr "%Pattern%">NUL 2>&1 && (
	aws s3 cp %%~fA s3://pushsale-backup/pushsale_data/
	echo Ok > G:\backups\backupdb2s3\log.txt
) || (
    Echo No    Pattern in %%~fA
)

forfiles -p "G:\backups\pushsale_data" -s -m *.bak -d -7 -c "cmd /c del @path"

pause