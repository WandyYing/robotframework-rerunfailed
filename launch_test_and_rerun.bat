:: clean previous output files
@echo off
rd /s /q Output

echo #######################################
echo # Running tests first time #
echo #######################################
cmd /c pybot --outputdir output %*

:: we stop the script here if all the tests were OK
if errorlevel 1 goto DGTFO
echo #######################################
echo # Tests passed, no rerun #
echo #######################################
exit /b
:: otherwise we go for another round with the failing tests
:DGTFO
:: we keep a copy of the first log file
copy Output\log.html Output\first_run_log.html /Y

:: we launch the tests that failed
echo #######################################
echo # Running again the tests that failed #
echo #######################################
cmd /c pybot --outputdir Output --nostatusrc --rerunfailed Output/output.xml --output rerun.xml %*
:: Robot Framework generates file rerun.xml

:: we keep a copy of the second log file
copy Output\log.html Output\second_run_log.html /Y

:: Merging output files
echo ########################
echo # Merging output files #
echo ########################
cmd /c rebot --nostatusrc --outputdir Output --output output.xml --merge Output/output.xml Output/rerun.xml
:: Robot Framework generates a new output.xml
