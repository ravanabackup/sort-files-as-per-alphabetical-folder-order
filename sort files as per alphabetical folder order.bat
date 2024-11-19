@echo off
setlocal enabledelayedexpansion

REM Initialize a temporary storage for folder counts
set "tempFile=FileCount.tmp"

REM Loop through all files in the current directory
for %%f in (*) do (
    REM Exclude the .bat file itself
    if /I not "%%~xf"==".bat" (
        REM Get the first letter of the file name
        set "filename=%%~nxf"
        set "firstChar=!filename:~0,1!"

        REM Check if the first character is alphabetic or numeric
        for %%a in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9) do (
            if /I "!firstChar!"=="%%a" (
                REM Create a folder named after the first character if it doesn't exist
                if not exist "%%a" mkdir "%%a"
                REM Move the file to the corresponding folder
                move "%%f" "%%a\" >nul
            )
        )
    )
)

REM Process each folder to add the file count to its name
for /d %%d in (*) do (
    REM Count the files in the folder
    dir /b "%%d" | find /c /v "" > "%tempFile%"
    set /p "fileCount=" < "%tempFile%"
    del "%tempFile%"

    REM Rename the folder to include the count
    for /f "tokens=1,* delims=-" %%x in ("%%d") do (
        ren "%%d" "%%x-!fileCount!"
    )
)

REM Cleanup temporary file if still present
if exist "%tempFile%" del "%tempFile%"

echo Sorting and renaming completed.
pause
