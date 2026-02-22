REM Build script for engine
@ECHO OFF
SetLocal EnableDelayedExpansion

REM Get a list of all the .c files.
SET cFilenames=
FOR /R %%f in (*.c) do (
    SET cFilenames=!cFilenames! %%f
)

REM echo "Files:" %cFilenames%

SET assembly=engine
SET compilerFlags=-g -shared -Wvarargs -Wall -Werror
REM -Wall -Werror
SET includeFlags=-Isrc -I%VULKAN_SDK%/Include
SET linkerFlags=-luser32 -lvulkan-1 -L%VULKAN_SDK%/Lib
SET defines=-D_DEBUG -DKEXPORT -D_CRT_SECURE_NO_WARNINGS

ECHO "Building %assembly%%..."
REM Locate clang: prefer system `clang`, otherwise try common install paths
SET CLANG_EXE=clang
where clang >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    IF EXIST "C:\Program Files\LLVM\bin\clang.exe" (
        SET CLANG_EXE="C:\Program Files\LLVM\bin\clang.exe"
    ) ELSE IF EXIST "C:\Program Files (x86)\LLVM\bin\clang.exe" (
        SET CLANG_EXE="C:\Program Files (x86)\LLVM\bin\clang.exe"
    )
)

%CLANG_EXE% %cFilenames% %compilerFlags% -o ../bin/%assembly%.dll %defines% %includeFlags% %linkerFlags%