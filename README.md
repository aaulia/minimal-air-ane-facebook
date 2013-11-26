# minimal-air-ane-facebook

Minimal example FlashDevelop project to use Facebook ANE (Air Native Extension) from FreshPlanet


### FlashDevelop Setup

1. Clone this repository or create AIR Mobile AS3 Project in FlashDevelop.
2. Copy `AirFacebook.ane` from https://github.com/freshplanet/ANE-Facebook in to the `lib/` directory.
3. Modify `bat/Packager.bat` and change the following line
   
       `call adt -package -target %TYPE%%TARGET% %OPTIONS% %SIGNING_OPTIONS% "%OUTPUT%" "%APP_XML%" %FILE_OR_DIR%`
   
   by adding `-extdir lib/` at the end of the line, like this
   
       `call adt -package -target %TYPE%%TARGET% %OPTIONS% %SIGNING_OPTIONS% "%OUTPUT%" "%APP_XML%" %FILE_OR_DIR% -extdir lib/`
   
4. Open the project in FlashDevelop, *right click* on `AirFacebook.ane` and check *Add To Library*. After that, *right click* again and choose *Options...* and then choose *External library*.
5. Modify the `Application.xml` following the https://github.com/freshplanet/ANE-Facebook/blob/master/README.md.
6. Register the extension by adding this few lines at the end of the `Application.xml`
   
       ````xml
       <extensions>
           <extensionID>com.freshplanet.AirFacebook</extensionID>
       </extensions>
       ````
   
### How To Generate KeyHash for Facebook SSO from .p12.

1. Install JDK and OpenSSL
2. run this against your .p12
   
       `keytool -export -alias 1 -storetype pkcs12 -keystore <your certificate>.p12 | openssl sha1 -binary | openssl enc -a -e`

3. Copy paste the output (KeyHash) to facebook Application dashboard.
