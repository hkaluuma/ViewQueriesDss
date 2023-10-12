SELECT        dbo.Patient.IDCNO, Encounter_1.VisitDate, dbo.ClientMonitoringFlowSheet.DiabetesMellitus, CASE WHEN ARTToxicity_Rash.Name = 'Rash' THEN 'yes' ELSE NULL END AS Rash, 
                         CASE WHEN ARTToxicity_Diarrhea.Name = 'Diarrhea' THEN 'yes' ELSE NULL END AS Diarrhea
FROM            dbo.Patient INNER JOIN
                         dbo.Encounter AS Encounter_1 ON dbo.Patient.IDCNO = Encounter_1.Patient INNER JOIN
                         dbo.ClientMonitoringFlowSheet ON dbo.Patient.IDCNO = dbo.ClientMonitoringFlowSheet.Patient AND Encounter_1.OID = dbo.ClientMonitoringFlowSheet.Encounter INNER JOIN
                         dbo.FlowSheetToxicity ON dbo.ClientMonitoringFlowSheet.OID = dbo.FlowSheetToxicity.ClientMonitoringFlowSheet INNER JOIN
                         dbo.ARTToxicity AS ARTToxicity_Diarrhea ON dbo.FlowSheetToxicity.ARTToxicity = ARTToxicity_Diarrhea.OID INNER JOIN
                         dbo.ARTToxicity AS ARTToxicity_Rash ON dbo.FlowSheetToxicity.ARTToxicity = ARTToxicity_Rash.OID
WHERE        (Encounter_1.VisitDate >
                             (SELECT        MIN(VisitDate) AS EarliestVisitDate
                               FROM            dbo.Encounter AS e
                               WHERE        (Patient = dbo.Patient.IDCNO)))
