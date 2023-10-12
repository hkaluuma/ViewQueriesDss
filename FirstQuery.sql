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
    END Diarrhea
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
WHERE
	e4.VisitDate > (SELECT MIN(e4.VisitDate) FROM encounter e4 WHERE e4.patient = pn.idcno) 
	-- AND fst.ARTToxicity IN (4,9)
	-- order by e4.VisitDate desc
