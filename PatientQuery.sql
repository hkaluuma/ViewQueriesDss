select  
Distinct pn.idcno as PatientId
,CONCAT(pn.idcno, '_fname') as FirstName
,CONCAT(pn.idcno, '_lname') as LastName
,'Ugandan' as Nationality
,'English' as Language
,'Kampala' as City
,pn.BirthDate as BirthDate
,case when pn.Gender=1 then 'Female' when pn.Gender=2 then 'Male' else '99' end Gender
,(select top 1 pd.TamaNumber from PhoneDetail pd where pd.Patient=pn.IDCNO and pd.TamaNumber is not null order by e.VisitDate desc)Phone
,(select top 1 e1.visitdate from Encounter e1 join ClientMonitoringFlowSheet cm1 on cm1.Encounter=e1.OID where e1.Patient=pn.IDCNO 
  order by e1.VisitDate desc) as LatestVisit
 
	from Patient pn join IntakeQuestionnaire iq1 on iq1.Patient=pn.IDCNO
	join encounter e on e.Patient=pn.IDCNO
	join PhoneDetail pd on pd.Patient=pn.IDCNO

	where pn.FollowUpStatus in(1)
	and pd.TamaNumber is not null 
	--and pd.TamaNumber = NULLIF(pd.TamaNumber, '')
	and pd.TamaNumber not like ''
	and (select top 1 pd.TamaNumber from PhoneDetail pd where pd.Patient=pn.IDCNO and pd.TamaNumber is not null order by e.VisitDate desc) like '7%'
	--and pn.IDCNO in (select IDCNO from fn_active_art_givendate('2014-01-01','2015-01-01'))
	And--On ART
	Exists(Select 1 From encounter e1 join clientmonitoringflowsheet cm1 on cm1.encounter=e1.oid 
    where e1.patient=pn.idcno and cm1.art=1)
