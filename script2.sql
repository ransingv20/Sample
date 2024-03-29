CREATE TABLE TARGET_TABLE AS
SELECT * FROM (
select distinct
    CD.CHDRNUM as POLICY_NO,
--    PA1.APPLICATION_NO,
--    TO_CHAR(PA.PROPOSAL_DT,'DD/MM/YYYY') as LOGIN_DT,
--    TO_CHAR(PA.PROPOSAL_RECEIVED_DT,'DD/MM/YYYY') as PROPOSAL_RECEIVED_DT,
    TO_CHAR(COALESCE(HP.HOISSDTE,GD.OISS_DATE),'DD/MM/YYYY') as CONVERSION_DT,
	TO_CHAR(TO_DATE(HP.HISSDTE),'DD/MM/YYYY') POLICY_ISSUE_DT,
    CASE WHEN SUBSTR(CD.CHDRNUM,1,1) <> '9' THEN 
        CASE WHEN CD.PTDATE NOT IN ('0','99999999') THEN TO_CHAR(TO_DATE(CD.PTDATE,'YYYYMMDD'),'DD/MM/YYYY') ELSE NULL END
        ELSE  
        CASE WHEN GM.PTDATE NOT IN ('0','99999999') THEN TO_CHAR(TO_DATE(GM.PTDATE,'YYYYMMDD'),'DD/MM/YYYY') ELSE NULL END
    END as PAID_TO_DT,
    CD.CNTTYPE as Product_Cd,
    PRODM.product_name,
    CD.STATCODE as POLICY_STATUS,
    PRODM.PIPS_CLASSIFICATION AS PIPS,
    PRODM.PAR_NPAR_UL AS P_NP_UL,
    PRODM.LOB,
    COALESCE(CD.BILLFREQ,GC.BILLFREQ) AS FREQUENCY,
    COALESCE(CD.BILLCHNL,GC.BILLCHNL) AS PAYMENT_CHANNEL,
    CASE WHEN SUBSTR(CD.CHDRNUM,1,1) <> '9' THEN COALESCE(CT.PREM_CESS_TERM,CO.PREM_CESS_TERM) ELSE ZP.ZPPTERM END AS PREMIUM_PAYING_TERM,
--    CASE WHEN COALESCE(CT.PREM_CESS_DATE,CO.PREM_CESS_DATE) NOT IN ('0','99999999') THEN TO_CHAR(TO_DATE(COALESCE(CT.PREM_CESS_DATE,CO.PREM_CESS_DATE),'YYYYMMDD'),'DD/MM/YYYY') ELSE NULL END AS PREM_CESS_DATE,
    CASE WHEN SUBSTR(CD.CHDRNUM,1,1) <> '9' THEN COALESCE(CT.RISK_CESS_TERM,CO.RISK_CESS_TERM) ELSE ZP.ZPOLTERM END AS POLICY_TERM,
--    CASE WHEN COALESCE(CT.RISK_CESS_DATE,CO.RISK_CESS_DATE) NOT IN ('0','99999999') THEN TO_CHAR(TO_DATE(COALESCE(CT.RISK_CESS_DATE,CO.RISK_CESS_DATE),'YYYYMMDD'),'DD/MM/YYYY') ELSE NULL END AS RISK_CESS_DATE,
    CASE WHEN CD.BILLFREQ = '00' THEN COALESCE(sa_api.SINGPREM,sa_api1.SINGPREM) ELSE COALESCE(sa_api.PREMIUM,sa_api1.PREMIUM) END as PREMIUM_AMT,
    CASE WHEN SUBSTR(CD.CHDRNUM,1,1) <> '9' THEN COALESCE(sa_api.TOTAL_SUM_ASSURED,sa_api1.TOTAL_SUM_ASSURED) ELSE gl.FIXSI END as SUM_ASSURED,
--    PF.CLTPCODE,
    PF.MARRYD,
    PF.CLTSEX,
    TO_CHAR(TO_DATE(PF.CLTDOB,'YYYYMMDD'),'DD/MM/YYYY') CLTDOB,
    PF.OCCPCODE as OCCUPATION_CODE,
--    OCCP_DESC.LONGDESC OCCUPATION,
    CASE WHEN ZC.ZYEARINC01 <= 0 THEN NVL(CPD.ANNUAL_INCOME,0) ELSE ZC.ZYEARINC01 END AS Income01,
    NVL(CP.YEARLY_INCOME,0) AS Income02,
--    PF.CLTADDR04,
--    PF.CLTADDR05,
    CD.COWNNUM as CLIENT_NO,
--    TRIM(PF.LGIVNAME) || CASE WHEN PF.LGIVNAME IS NOT NULL THEN ' ' ELSE '' END || TRIM(PF.LSURNAME) AS CLIENT_NAME,
--    CASE WHEN LENGTH(TRIM(REGEXP_REPLACE(PF.CLTPHONE01,'[^0-9]',''))) > 10 THEN SUBSTR(TRIM(REGEXP_REPLACE(PF.CLTPHONE01,'[^0-9]','')),LENGTH(TRIM(REGEXP_REPLACE(PF.CLTPHONE01,'[^0-9]','')))-10+1,10) ELSE TRIM(REGEXP_REPLACE(PF.CLTPHONE01,'[^0-9]','')) END as CLTPHONE01_CLEAN,
--    CASE WHEN LENGTH(TRIM(REGEXP_REPLACE(PF.CLTPHONE02,'[^0-9]',''))) > 10 THEN SUBSTR(TRIM(REGEXP_REPLACE(PF.CLTPHONE02,'[^0-9]','')),LENGTH(TRIM(REGEXP_REPLACE(PF.CLTPHONE01,'[^0-9]','')))-10+1,10) ELSE TRIM(REGEXP_REPLACE(PF.CLTPHONE02,'[^0-9]','')) END as CLTPHONE02_CLEAN,
    CASE WHEN LENGTH(TRIM(REGEXP_REPLACE(EF.RMBLPHONE,'[^0-9]',''))) > 10 THEN SUBSTR(TRIM(REGEXP_REPLACE(EF.RMBLPHONE,'[^0-9]','')),LENGTH(TRIM(REGEXP_REPLACE(EF.RMBLPHONE,'[^0-9]','')))-10+1,10) ELSE TRIM(REGEXP_REPLACE(EF.RMBLPHONE,'[^0-9]','')) END as RMBLPHONE_CLEAN,
--    UPPER(REPLACE(EF.RINTERNET,' ','')) RINTERNET_CLEAN,
    TRIM(UPPER(REGEXP_REPLACE(ZM.zpanno,'[^0-9A-Za-z]',''))) as ZPANNO_CLEAN,
--    AL.PAYCLT,
--    HBANK.BRANCH_CODE H_Bank_Br_Cd, 
--    HBANK.BRANCH_NAME H_Bank_Br_NM, 
--    HBANK.BM_NAME, 
--    HBANK.RPM, 
--    HBANK.SR_RPM, 
--    HBANK.REGIONAL_HEAD_TPP, 
--    HBANK.ZONE, 
--    HBANK.ZONAL_HEAD, 
--    HBANK.REGION, 
--    HBANK.CLUSTER_HEAD, 
--    HBANK.CIRCLE_HEAD, 
--    HBANK.REGIONAL_HEAD, 
--    HBANK.BBH_HEAD, 
--    HBANK.SEGMENT, 
--    HBANK.SEGMENT1, 
    HBANK.STATUS, 
--    HBANK.LG_TYPE, 
--    HBANK.RBI_CAT, 
--    HBANK.BM_EMP_CODE, 
--    HBANK.BM_EMAIL_ID, 
--    HBANK.CH_EMAIL_ID, 
--    HBANK.CMS_CODE, 
--    HBANK.CMS_NAME, 
--    HBANK.TM_CODE, 
--    HBANK.TM_NAME, 
--    HBANK.RM, 
--    HBANK.ZM,
    CASE WHEN TEMP_SCHEMA_1.APP_NO IS NULL THEN COALESCE(CHNL_COP.CHANNEL, chnl.CHANNEL) 		--If App_No not found in TEMP_SCHEMA_1 APP Mapping, fetch from HIERARCHY_CHANNEL_SUBCHANNEL
	 ELSE 
	 CASE WHEN TEMP_SCHEMA_1.CHANNEL = 'Aggregators' 			--If TEMP_SCHEMA_1 Mapping Channel is Aggregators then set CHANNEL as Strategic Alliances
		  THEN 'Strategic Alliances'  
		  ELSE 'TEMP_SCHEMA_1' 								--Else set Channel as TEMP_SCHEMA_1
	 END 
    END as CHANNEL,
    CASE WHEN TEMP_SCHEMA_1.APP_NO IS NULL THEN COALESCE(CHNL_COP.SUB_CHANNEL, chnl.SUB_CHANNEL) 	--If App_No not found in TEMP_SCHEMA_1 APP Mapping, fetch from HIERARCHY_CHANNEL_SUBCHANNEL
	 ELSE 											--Else use CHANNEL from TEMP_SCHEMA_1_App_Mapping as SUB_CHANNEL
	 CASE WHEN TEMP_SCHEMA_1.channel IN ('Omni Channel','Self Sourced','Telemarketing CVM','QROPS') 
		  THEN TEMP_SCHEMA_1.channel 
		  ELSE 'Others' 
	 END
    END as SUB_CHANNEL,
    PA.APPLICATION_STATUS_RK,
--    QT.LEAD_ID TEBT_LEAD_ID,
--	LG.LG_CD,
	NRI.NRIFLAG NRI
FROM (SELECT CHDRNUM, PTDATE, STATCODE, CNTTYPE, BILLFREQ, BILLCHNL, COWNNUM, TRANNO, AGNTNUM, REGISTER FROM temp_schema_3.CHDRPF) CD
LEFT JOIN temp_schema_3.GCHIPF GC
ON CD.CHDRNUM = GC.CHDRNUM
AND CD.TRANNO = GC.TRANNO
LEFT JOIN temp_schema_3.ZPPTPF zp
ON CD.CHDRNUM = ZP.CHDRNUM
LEFT JOIN temp_schema_3.GMD2PF GM
ON CD.CHDRNUM = GM.CHDRNUM
AND GM.DPNTNO = '00'
LEFT JOIN (select CHDRNUM, FIXSI, DENSE_RANK()OVER(PARTITION BY CHDRNUM ORDER BY PLANNO DESC) RNK from temp_schema_3.GLHIPF WHERE SUBSTR(CHDRNUM,1,1) = '9') gl
ON gl.CHDRNUM = CD.CHDRNUM
AND CD.CNTTYPE NOT IN ('HRI','HRN')
AND gl.RNK = 1
LEFT JOIN (SELECT CHDRNUM, RISK_CESS_DATE, PREM_CESS_DATE, RISK_CESS_TERM, PREM_CESS_TERM FROM temp_schema_3.COVRPF WHERE RIDER = '00') CO ON CD.CHDRNUM = CO.CHDRNUM
LEFT JOIN (SELECT CHDRNUM, RISK_CESS_DATE, PREM_CESS_DATE, RISK_CESS_TERM, PREM_CESS_TERM FROM temp_schema_3.COVTPF WHERE RIDER = '00') CT ON CD.CHDRNUM = CT.CHDRNUM
LEFT JOIN TEMP_SCHEMA.co_pol CHNL_COP ON CD.CHDRNUM = CHNL_COP.POLICY_NO
LEFT JOIN hierarchy_250621 CHNL ON CD.AGNTNUM = CHNL.AGNTNUM
LEFT JOIN (SELECT CHDRNUM, CASE WHEN HOISSDTE NOT IN ('0','99999999') THEN TO_DATE(HOISSDTE,'YYYYMMDD') ELSE NULL END HOISSDTE, CASE WHEN HISSDTE NOT IN ('0','99999999') THEN TO_DATE(HISSDTE,'YYYYMMDD') ELSE NULL END HISSDTE FROM temp_schema_3.HPADPF) HP on CD.CHDRNUM = HP.CHDRNUM
LEFT JOIN prod_mast PRODM ON PRODM.CNTTYPE = CD.CNTTYPE
LEFT JOIN (SELECT CHDRNUM, SUM(SUMINS) as TOTAL_SUM_ASSURED, SUM(INSTPREM) as PREMIUM, SUM(SINGP) as SINGPREM FROM temp_schema_3.COVRPF GROUP BY CHDRNUM) sa_api
ON CD.CHDRNUM = sa_api.CHDRNUM
LEFT JOIN (SELECT CHDRNUM, SUM(SUMINS) as TOTAL_SUM_ASSURED, SUM(INSTPREM) as PREMIUM, SUM(SINGP) as SINGPREM FROM temp_schema_3.COVTPF GROUP BY CHDRNUM) sa_api1
ON CD.CHDRNUM = sa_api1.CHDRNUM		--replicate the same logic of COVRPF TO COVTPF also check data in COVRPF, If not present pick the value in COVTPF
LEFT JOIN temp_schema_3.CLNTPF PF on CD.COWNNUM = PF.CLNTNUM
LEFT JOIN temp_schema_3.CLEXPF EF ON CD.COWNNUM = EF.CLNTNUM
LEFT JOIN temp_schema_3.ZAMLPF ZM ON CD.COWNNUM = ZM.CLNTNUM
LEFT JOIN temp_schema_3.AGLFPF AL ON CD.AGNTNUM = AL.AGNTNUM
LEFT JOIN (SELECT CHDRNUM, NRIFLAG, DENSE_RANK() OVER(PARTITION BY CHDRNUM ORDER BY DATIME DESC) RNK FROM temp_schema_3.ZNRIPF) NRI ON CD.CHDRNUM = NRI.CHDRNUM AND NRI.RNK = 1
LEFT JOIN (SELECT a.clntnum, a.occpcode, a.datime, a.ZQLFCTN, a.ZYEARINC01, dense_rank() over (partition by clntnum order by a.datime desc) as rnk
			from temp_schema_3.ZCADPF a) ZC on ZC.CLNTNUM = CD.COWNNUM and ZC.rnk = 1
LEFT JOIN (SELECT ch.CHDRNUM, ch.REPNUM, COALESCE(apl.POS_APPLICATION_NO,apl1.TTMPRCNO) as APPLICATION_NO, ch.AGNTNUM, ch.CHDRCOY
    FROM temp_schema_3.CHDRPF ch
    LEFT JOIN (SELECT POS_APPLICATION_NO, POLICY_NO, DENSE_RANK() OVER (PARTITION BY POLICY_NO ORDER BY RECORD_CREATED_DT DESC) as Rnk
    FROM temp_schema_3.POS_APPLICATION) apl
    ON apl.POLICY_NO = ch.CHDRNUM		--24_Sep_21-get application numbers from TTRCPF from TEMP_SCHEMA for application TTMTCRNO	--get first value of application order by datetime desc
    AND apl.rnk = 1
    LEFT JOIN (SELECT CHDRNUM,TTMPRCNO, DENSE_RANK() OVER (PARTITION BY CHDRNUM ORDER BY DATIME DESC) as rnk FROM temp_schema_3.ttrcpf) apl1
    ON ch.CHDRNUM = apl1.CHDRNUM
    AND apl1.rnk = 1) PA1 
ON CD.CHDRNUM = PA1.CHDRNUM
LEFT JOIN TABLE_1 LG ON CD.CHDRNUM = LG.CHDRNUM
LEFT JOIN TEMP_SCHEMA.XYZ HBANK ON LG.REPNUM = HBANK.LG_CODE
LEFT JOIN temp_schema_3.POS_APPLICATION PA ON PA.POS_APPLICATION_NO = PA1.APPLICATION_NO
LEFT JOIN (SELECT POS_APPLICATION_RK, STATUS_RK, LEAD_ID, DENSE_RANK() OVER (PARTITION BY POS_APPLICATION_RK ORDER BY RECORD_CREATED_DT DESC, QUOTE_RK ASC) AS RNK  
           FROM temp_schema_3.QI_QUOTE_TRANSACTION WHERE STATUS_RK IN (28286,29231)) QT
ON PA.POS_APPLICATION_RK = QT.POS_APPLICATION_RK AND QT.RNK = 1
LEFT JOIN TEMP_SCHEMA_1_APP_MAPPING TEMP_SCHEMA_1
ON TEMP_SCHEMA_1.APP_NO = PA1.APPLICATION_NO
LEFT JOIN (select POS_APPLICATION_RK, PARTY_RK, dense_rank() over (partition by POS_APPLICATION_RK, PARTY_RK order by coalesce(RECORD_UPDATED_DT,RECORD_UPDATED_DT) desc) as rnk from temp_schema_3.CAP_PARTY_X_ROLE WHERE PARTY_ROLE_RK = 27578) CPX on PA.POS_APPLICATION_RK = CPX.POS_APPLICATION_RK AND CPX.rnk = 1
LEFT JOIN temp_schema_3.CAP_PARTY CP on CPX.PARTY_RK = CP.PARTY_RK
LEFT JOIN temp_schema_3.CAP_REFERENCE_MASTER EDUC on CP.EDUCATION_QUALIFICATION_RK = EDUC.REFERENCE_RK
LEFT JOIN temp_schema_3.POS_PARTY_DETAILS CPD on CPX.PARTY_RK = CPD.PARTY_RK
LEFT JOIN temp_schema_3.CAP_REFERENCE_MASTER OCCU on CPD.OCCUPATION_TYPE_RK = OCCU.REFERENCE_RK    
LEFT JOIN temp_schema_3.MAGNUM_TRANSACTION MT on CPX.PARTY_RK = MT.PARTY_RK AND MT.QUESTION_RK = 216
LEFT JOIN temp_schema_3.MAGNUM_TRANSACTION OCC on CPX.PARTY_RK = OCC.PARTY_RK AND OCC.QUESTION_RK = 214
LEFT JOIN temp_schema_3.MAGNUM_TRANSACTION IND on CPX.PARTY_RK = IND.PARTY_RK AND IND.QUESTION_RK = 220
LEFT JOIN temp_schema_3.ZPPTPF ZP ON CD.CHDRNUM = ZP.CHDRNUM
LEFT JOIN (SELECT CHDRNUM, TRANNO, BATCTRCDE, CASE WHEN TRANSACTION_DATE <> '0' THEN TO_DATE(TRANSACTION_DATE,'YYMMDD') ELSE NULL END OISS_DATE FROM temp_schema_3.GIDTPF) GD on CD.CHDRNUM = GD.CHDRNUM AND GD.TRANNO = 1 AND GD.BATCTRCDE = 'T903'
LEFT JOIN temp_schema_3.GCHPPF GC ON GC.CHDRNUM = CD.CHDRNUM
LEFT JOIN (SELECT distinct A.DESCITEM, A.LONGDESC FROM temp_schema_3.DESCPF A JOIN temp_schema_3.ITEMPF B ON A.DESCPFX = B.ITEMPFX
 AND A.DESCITEM = B.ITEMITEM
 AND A.DESCTABL = B.ITEMTABL
 AND A.DESCPFX ='IT'
 AND A.DESCTABL = 'T5696'
 AND A.LANGUAGE = 'E'
 AND B.VALIDFLAG = '1'
 AND A.DESCCOY='2') branch_name
ON CD.REGISTER = branch_name.DESCITEM
LEFT JOIN (SELECT DISTINCT A.DESCCOY, A.DESCITEM, A.LONGDESC
FROM temp_schema_3.DESCPF A
JOIN temp_schema_3.ITEMPF B
ON A.DESCPFX = B.ITEMPFX
AND A.DESCITEM = B.ITEMITEM
AND A.DESCTABL = B.ITEMTABL
AND A.DESCTABL = 'T3644'
AND A.DESCCOY = '9'
AND B.VALIDFLAG = '1') OCCP_DESC
ON PF.OCCPCODE = OCCP_DESC.DESCITEM
)
WHERE SUBSTR(POLICY_NO,1,1) <> '8'
AND SUB_CHANNEL NOT IN ('XYZ','XYZ Upsell','OL-XYZ')
AND ((CONVERSION_DT IS NOT NULL OR APPLICATION_STATUS_RK IS NULL) AND POLICY_STATUS <> 'QR');

DROP TABLE TABLE_1;

