@echo off
cd /d "C:\Users\USER\OneDrive\Desktop\WD195-Online-Movie-Ticket-Reservation-Platform\OnlineMovieTicketBooking"
echo Building project...
call mvnw.cmd clean install -DskipTests
echo.
echo Build complete. Starting Tomcat...
call mvnw.cmd tomcat:run
pause

