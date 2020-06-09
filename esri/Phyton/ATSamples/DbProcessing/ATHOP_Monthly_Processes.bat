rem Generate AT HOP Monthly Patronage Summmary for YYYY/MM
rem Stakeholder is AT HOP Team (Luke and Team)

rem Authored by Susan Jones

rem 31 March 2017


rem Retrieve the AT HOP Monthly Transaction of patronage across the Region for the YYYY/MM
python.exe \\atalgisap01\Projects\PT\HOPMonthlySummary\Scripts\Python\gisProcessATHOPMonthlyTransactions.py

rem Calculate Total ATHOP Summarised Patronage for the YYYY/MM
python.exe \\atalgisap01\Projects\PT\HOPMonthlySummary\Scripts\Python\gisCalculateTotalUsage.py
