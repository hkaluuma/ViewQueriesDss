SELECT
    pn.idcno AS PatientId,
    e4.VisitDate AS VisitDate,
    cm.DiabetesMellitus AS Diabetes,
    MAX(CASE
        WHEN art.Name = 'Rash' THEN 'yes'
        ELSE NULL
    END) AS Rash,
    MAX(CASE
        WHEN art.Name = 'Diarrhea' THEN 'yes'
        ELSE NULL
    END) AS Diarrhea
FROM
    patient pn
    INNER JOIN encounter e4 ON e4.patient = pn.idcno
    INNER JOIN clientmonitoringflowsheet cm ON cm.encounter = e4.oid
    INNER JOIN FlowSheetToxicity fst ON cm.OID = fst.ClientMonitoringFlowSheet
    INNER JOIN ARTToxicity art ON art.OID = fst.ARTToxicity
WHERE
    e4.VisitDate = (SELECT MAX(e4.VisitDate) FROM encounter e4 WHERE e4.patient = pn.idcno)

GROUP BY
    pn.idcno,
    e4.VisitDate,
    cm.DiabetesMellitus
ORDER BY pn.idcno asc
