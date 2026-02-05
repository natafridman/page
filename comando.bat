@echo on
setlocal enabledelayedexpansion

set "IMAGES_ROOT=images"

echo Carpeta actual:
cd
echo.

if not exist "%IMAGES_ROOT%" (
    echo ERROR: No existe la carpeta images
    pause
    exit /b
)

for /f "delims=" %%D in ('dir "%IMAGES_ROOT%" /ad /b') do (
    echo Procesando carpeta: %%D

    set "IMAGES_LIST="
    set "VIDEOS_LIST="

    rem ---- IMAGENES ----
    for %%I in ("%IMAGES_ROOT%\%%D\*.jpg" "%IMAGES_ROOT%\%%D\*.jpeg" "%IMAGES_ROOT%\%%D\*.png" "%IMAGES_ROOT%\%%D\*.webp" "%IMAGES_ROOT%\%%D\*.gif") do (
        if exist "%%I" (
            if defined IMAGES_LIST (
                set "IMAGES_LIST=!IMAGES_LIST!, %%~nxI"
            ) else (
                set "IMAGES_LIST=%%~nxI"
            )
        )
    )

    rem ---- VIDEOS ----
    for %%V in ("%IMAGES_ROOT%\%%D\*.mp4" "%IMAGES_ROOT%\%%D\*.webm" "%IMAGES_ROOT%\%%D\*.mov") do (
        if exist "%%V" (
            if defined VIDEOS_LIST (
                set "VIDEOS_LIST=!VIDEOS_LIST!, %%~nxV"
            ) else (
                set "VIDEOS_LIST=%%~nxV"
            )
        )
    )

    (
        echo images: !IMAGES_LIST!
        echo videos: !VIDEOS_LIST!
    ) > "%IMAGES_ROOT%\%%D\metadata.txt"

    echo metadata.txt creado
    echo.
)

echo FIN
pause
