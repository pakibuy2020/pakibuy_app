#Note

      
keytool -exportcert -alias androiddebugkey -keystore "C:\Users\Jayson Gonzaga\.android\debug.keystore" | "C:\openssl\bin\openssl" sha1 -binary | "C:\openssl\bin\openssl" base64
      

      
keytool -exportcert -alias androiddebugkey -keystore "C:\Users\Jayson Gonzaga\.android\debug.keystore" | "C:\openssl\bin\openssl" sha1 -binary | "C:\openssl\bin\openssl" base64

keytool -list -printcert -jarfile yourapkname.apk
Copy the SHA1 value, which looks like this
CD:A1:EA:A3:5C:5C:68:FB:FA:0A:6B:E5:5A:72:64:DD:26:8D:44:84
and open http://tomeko.net/online_tools/hex_to_base64.php to convert your SHA1 value to base64.
This is what Facebook requires. Copy base64 value and paste it in key hashes under settings->Basic -> Key hashes