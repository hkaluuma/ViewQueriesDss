SELECT
    pn.idcno AS PatientId,
	e4.VisitDate AS VisitDate,
	cm.DiabetesMellitus AS Diabates,
	-- art.Name As Diarrhoea,
	CASE
        WHEN art.Name = 'Rash' THEN 'yes'
        ELSE NULL
    END Rash,
	CASE
        WHEN art.Name = 'Diarrhea' THEN 'yes'
        ELSE NULL
    END Diarrhea,
	(Case When Exists(select 1 from IntakeHealthProblem ihp join HealthProblem hp on ihp.HealthProblem=hp.OID
	where ihp.IntakeQuestionnaire=iq.OID and hp.OID=37) THEN 'Yes' Else 'No' End) AS Paraparesis
FROM
	patient pn
	   JOIN
    encounter e4 ON e4.patient = pn.idcno
	   JOIN
	clientmonitoringflowsheet cm ON cm.encounter = e4.oid
	 left JOIN
	 FlowSheetToxicity fst ON cm.OID = fst.ClientMonitoringFlowSheet
	 JOIN
	 ARTToxicity art ON art.OID = fst.ARTToxicity
	 INNER JOIN
	 dbo.IntakeQuestionnaire AS iq ON iq.Patient=pn.IDCNO
WHERE
	e4.VisitDate = (SELECT MAX(e4.VisitDate) FROM encounter e4 WHERE e4.patient = pn.idcno) 
ORDER by pn.IDCNO ASC
--and pn.IDCNO = 8
