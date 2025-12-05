@echo off

REM Default to port 3000 if not specified
if "%PORT%"=="" set PORT=3000

REM Let the debug gem allow remote connections
set RUBY_DEBUG_OPEN=true
set RUBY_DEBUG_LAZY=true

REM Start foreman with Procfile.dev using bundle exec
bundle exec foreman start -f Procfile.dev %*

