SELECT  
dbo.Patient.IDCNO, 
Encounter.VisitDate,
dbo.ClientMonitoringFlowSheet.DiabetesMellitus, 
MAX(CASE 
WHEN ARTToxicity.Name = 'Rash' THEN 'yes' ELSE NULL END) AS Rash, 
MAX(CASE 
WHEN ARTToxicity.Name = 'Diarrhea' THEN 'yes' ELSE NULL END) AS Diarrhea
FROM            
dbo.Patient 
INNER JOIN
dbo.Encounter AS Encounter ON dbo.Patient.IDCNO = Encounter.Patient 
INNER JOIN
dbo.ClientMonitoringFlowSheet ON dbo.Patient.IDCNO = dbo.ClientMonitoringFlowSheet.Patient
INNER JOIN
dbo.FlowSheetToxicity ON dbo.ClientMonitoringFlowSheet.OID = dbo.FlowSheetToxicity.ClientMonitoringFlowSheet 
INNER JOIN
                         dbo.ARTToxicity AS ARTToxicity ON dbo.FlowSheetToxicity.ARTToxicity = ARTToxicity.OID
WHERE        
(Encounter.VisitDate =
                             (SELECT        MAX(VisitDate) AS RecentVisitDate
                               FROM            dbo.Encounter AS e
                               WHERE        (Patient = dbo.Patient.IDCNO)))
GROUP BY
    Patient.idcno,
    Encounter.VisitDate,
    ClientMonitoringFlowSheet.DiabetesMellitus;
