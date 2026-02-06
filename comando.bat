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

echo ============================================
echo PREVIEW - Como quedarian los archivos:
echo ============================================
echo.

for /f "delims=" %%D in ('dir "%IMAGES_ROOT%" /ad /b') do (
    echo ----------------------------------------
    echo Carpeta: %%D
    echo ----------------------------------------

    set "IMAGES_LIST="
    set "VIDEOS_LIST="
    set "TIENE_IMAGES=0"
    set "TIENE_VIDEOS=0"

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

    rem ---- VERIFICAR SI YA EXISTEN LAS LINEAS ----
    if exist "%IMAGES_ROOT%\%%D\metadata.txt" (
        findstr /i /c:"images:" "%IMAGES_ROOT%\%%D\metadata.txt" >nul
        if !errorlevel! EQU 0 set "TIENE_IMAGES=1"
        
        findstr /i /c:"videos:" "%IMAGES_ROOT%\%%D\metadata.txt" >nul
        if !errorlevel! EQU 0 set "TIENE_VIDEOS=1"
    )

    if exist "%IMAGES_ROOT%\%%D\metadata.txt" (
        echo [ARCHIVO EXISTE - Contenido actual:]
        type "%IMAGES_ROOT%\%%D\metadata.txt"
        echo.
        
        if !TIENE_IMAGES! EQU 1 if !TIENE_VIDEOS! EQU 1 (
            echo [YA TIENE images: y videos: - NO SE AGREGARA NADA]
        ) else (
            echo [LINEAS A AGREGAR:]
            if !TIENE_IMAGES! EQU 0 echo images: !IMAGES_LIST!
            if !TIENE_VIDEOS! EQU 0 echo videos: !VIDEOS_LIST!
        )
    ) else (
        echo [ARCHIVO NUEVO - Se creara con:]
        echo images: !IMAGES_LIST!
        echo videos: !VIDEOS_LIST!
    )
    echo.
)

echo ============================================
echo.
set /p "CONFIRMAR=Deseas aplicar estos cambios? (S/N): "

if /i "%CONFIRMAR%" NEQ "S" (
    echo Operacion cancelada
    pause
    exit /b
)

echo.
echo Aplicando cambios...
echo.

for /f "delims=" %%D in ('dir "%IMAGES_ROOT%" /ad /b') do (
    set "IMAGES_LIST="
    set "VIDEOS_LIST="
    set "TIENE_IMAGES=0"
    set "TIENE_VIDEOS=0"

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

    rem ---- VERIFICAR SI YA EXISTEN LAS LINEAS ----
    if exist "%IMAGES_ROOT%\%%D\metadata.txt" (
        findstr /i /c:"images:" "%IMAGES_ROOT%\%%D\metadata.txt" >nul
        if !errorlevel! EQU 0 set "TIENE_IMAGES=1"
        
        findstr /i /c:"videos:" "%IMAGES_ROOT%\%%D\metadata.txt" >nul
        if !errorlevel! EQU 0 set "TIENE_VIDEOS=1"
    )

    rem ---- CREAR O AGREGAR AL METADATA ----
    if exist "%IMAGES_ROOT%\%%D\metadata.txt" (
        if !TIENE_IMAGES! EQU 1 if !TIENE_VIDEOS! EQU 1 (
            echo Procesando carpeta: %%D - Ya tiene images y videos, omitiendo
        ) else (
            echo Procesando carpeta: %%D
            echo. >> "%IMAGES_ROOT%\%%D\metadata.txt"
            if !TIENE_IMAGES! EQU 0 echo images: !IMAGES_LIST! >> "%IMAGES_ROOT%\%%D\metadata.txt"
            if !TIENE_VIDEOS! EQU 0 echo videos: !VIDEOS_LIST! >> "%IMAGES_ROOT%\%%D\metadata.txt"
            echo metadata.txt actualizado
        )
    ) else (
        echo Procesando carpeta: %%D
        (
            echo images: !IMAGES_LIST!
            echo videos: !VIDEOS_LIST!
        ) > "%IMAGES_ROOT%\%%D\metadata.txt"
        echo metadata.txt creado
    )
    echo.
)

echo FIN - Todos los archivos han sido procesados
pause