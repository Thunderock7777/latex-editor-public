@echo off
setlocal EnableExtensions

echo.
echo ==========================================
echo       Pandoc Document Converter
echo            TEX + PDF Output
echo ==========================================
echo.

REM =========================================================
REM FILE PATHS
REM =========================================================

set "INPUT=%~1"
set "SCRIPT_DIR=%~dp0"
set "BASENAME=%~dp1%~n1"
set "TEX_OUTPUT=%BASENAME%.tex"
set "PDF_OUTPUT=%BASENAME%.pdf"
set "TEMPLATE=%SCRIPT_DIR%custom-template.tex"
set "FILTER=%SCRIPT_DIR%fix-groups.lua"
set "BIN_DIR=%~dp1bin"

REM =========================================================
REM CHECK INPUT & SET WORKING DIRECTORY
REM =========================================================

if "%INPUT%"=="" (
    echo ERROR: No input file was supplied.
    echo.
    echo Drag an .htm, .html, .md, .txt, .csv, .docx, etc. onto compile.bat.
    echo.
    pause
    exit /b 1
)

if not exist "%INPUT%" (
    echo ERROR: Input file does not exist:
    echo "%INPUT%"
    echo.
    pause
    exit /b 1
)

REM Change working directory to where the input file is located
cd /d "%~dp1"

REM =========================================================
REM CHECK FILE TYPE
REM =========================================================

set "EXTENSION=%~x1"

if /I "%EXTENSION%"==".htm" goto TYPE_HTML
if /I "%EXTENSION%"==".html" goto TYPE_HTML
if /I "%EXTENSION%"==".md" goto TYPE_MARKDOWN
if /I "%EXTENSION%"==".txt" goto TYPE_TEXT
if /I "%EXTENSION%"==".csv" goto TYPE_CSV
if /I "%EXTENSION%"==".docx" goto TYPE_DOCX
if /I "%EXTENSION%"==".doc" goto TYPE_DOCX

REM If it doesn't match the above, send it to auto-detect (everything else)
goto TYPE_AUTO

REM =========================================================
REM FORMAT DEFINITIONS
REM =========================================================

:TYPE_HTML
set "INPUT_FORMAT=html+tex_math_dollars+tex_math_single_backslash-native_divs-native_spans"
set "USE_FILTER=YES"
set "TYPE_NAME=HTML/HTM"
goto CHECK_FILES

:TYPE_MARKDOWN
set "INPUT_FORMAT=markdown+tex_math_single_backslash"
set "USE_FILTER=YES"
set "TYPE_NAME=Markdown"
goto CHECK_FILES

:TYPE_TEXT
set "INPUT_FORMAT=markdown+tex_math_single_backslash"
set "USE_FILTER=YES"
set "TYPE_NAME=Text"
goto CHECK_FILES

:TYPE_CSV
set "INPUT_FORMAT=csv"
set "USE_FILTER=YES"
set "TYPE_NAME=CSV Spreadsheet"
goto CHECK_FILES

:TYPE_DOCX
set "INPUT_FORMAT=docx"
set "USE_FILTER=YES"
set "TYPE_NAME=Word Document"
goto CHECK_FILES

:TYPE_AUTO
set "INPUT_FORMAT="
set "USE_FILTER=YES"
set "TYPE_NAME=Auto-Detected (%EXTENSION%)"
goto CHECK_FILES


REM =========================================================
REM CHECK REQUIRED FILES
REM =========================================================

:CHECK_FILES

echo Input file:
echo "%INPUT%"
echo.
echo Detected type:
echo %TYPE_NAME%
echo.
echo TEX output:
echo "%TEX_OUTPUT%"
echo.
echo PDF output:
echo "%PDF_OUTPUT%"
echo.

if not exist "%TEMPLATE%" (
    echo ERROR: custom-template.tex was not found.
    echo.
    echo Expected:
    echo "%TEMPLATE%"
    echo.
    pause
    exit /b 1
)

if "%USE_FILTER%"=="YES" (
    if not exist "%FILTER%" (
        echo ERROR: fix-groups.lua was not found.
        echo.
        echo Expected:
        echo "%FILTER%"
        echo.
        pause
        exit /b 1
    )
)


REM =========================================================
REM CREATE TEX (PANDOC)
REM =========================================================

:CREATE_TEX

echo ==========================================
echo              CREATING TEX
echo ==========================================
echo.

REM Dynamically build the Pandoc command so we can omit the format flag for auto-detect
set "PANDOC_CMD=pandoc "%INPUT%""

if not "%INPUT_FORMAT%"=="" set "PANDOC_CMD=%PANDOC_CMD% -f "%INPUT_FORMAT%""
if "%USE_FILTER%"=="YES" set "PANDOC_CMD=%PANDOC_CMD% --lua-filter="%FILTER%""
set "PANDOC_CMD=%PANDOC_CMD% --wrap=none --template="%TEMPLATE%" -o "%TEX_OUTPUT%""

echo Executing: %PANDOC_CMD%
echo.
%PANDOC_CMD%

if errorlevel 1 (
    echo.
    echo ==========================================
    echo            TEX CREATION FAILED
    echo ==========================================
    pause
    exit /b 1
)

goto CREATE_PDF


REM =========================================================
REM CREATE PDF (XELATEX DIRECTLY)
REM =========================================================

:CREATE_PDF

echo.
echo ==========================================
echo              CREATING PDF
echo ==========================================
echo.
echo Compiling PDF and generating SyncTeX map...

REM Run XeLaTeX directly on the generated .tex file so the .synctex.gz map stays in this folder
xelatex -synctex=1 -interaction=nonstopmode "%TEX_OUTPUT%"

if errorlevel 1 (
    echo.
    echo ==========================================
    echo            PDF CREATION FAILED
    echo ==========================================
    echo.
    echo Check the terminal above for LaTeX errors.
    pause
    exit /b 1
)

goto CLEANUP


REM =========================================================
REM CLEANUP GARBAGE FILES
REM =========================================================

:CLEANUP

echo.
echo ==========================================
echo           SWEEPING GARBAGE FILES
echo ==========================================
echo.

if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

REM Move LaTeX build garbage from previous compilations
move "*.aux" "%BIN_DIR%\" >nul 2>&1
move "*.log" "%BIN_DIR%\" >nul 2>&1
move "*.out" "%BIN_DIR%\" >nul 2>&1
move "*.fls" "%BIN_DIR%\" >nul 2>&1
move "*.fdb_latexmk" "%BIN_DIR%\" >nul 2>&1
move "auto_plot_*" "%BIN_DIR%\" >nul 2>&1

goto SUCCESS


REM =========================================================
REM SUCCESS
REM =========================================================

:SUCCESS

echo.
echo ==========================================
echo          CONVERSION COMPLETED
echo ==========================================
echo.
echo TEX:
echo "%TEX_OUTPUT%"
echo.
echo PDF:
echo "%PDF_OUTPUT%"
echo.
echo MAP:
echo "%BASENAME%.synctex.gz"
echo.
echo ==========================================
echo.

pause
endlocal
exit /b 0