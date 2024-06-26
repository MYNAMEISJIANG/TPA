USE [miscwebdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_TPA_VIB_Backward]    Script Date: 11/10/2566 14:59:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_TPA_VIB_Backward]
AS
BEGIN
/*-----------------1.Table TPA_TempDaily--------*/
-- exec [sp_TPA_VIB]
-- =============================================
-- Relese Note
-- เพิ่มการส่งข้อมูลของ subclass 560
-- 2020/02/11 : เปลี่ยน CompanyName ของ Subclass 560 เป็น VIB
-- 2020/08/19 : เพิ่มดึงข้อมุล Subclass 587,588
-- =============================================
	--DECLARE @Start_Date VARCHAR(10)
	--SET @Start_Date=CONVERT(VARCHAR,dateadd(day, -10,  getdate()),111)
	--DECLARE @date VARCHAR(10)
	----SET @date = '2020/12/25'
	--SET @date = CONVERT(VARCHAR,dateadd(day, -1,  getdate()),111) /*เมื่อวานวันนี้*/
	DECLARE @Start_Date datetime, @date datetime
	SET @Start_Date = dateadd(dd,-10, datediff(dd,0, getDate()))
	SET @date = dateadd(dd,0, datediff(dd,0, getDate())) /*วันนี้*/

	DECLARE @Temp_TPA_Daily TABLE (
			CompanyName					VARCHAR(250) DEFAULT ''
			,MemberCode					VARCHAR(250) DEFAULT ''
			,Title						VARCHAR(250) DEFAULT ''
			,NameThai					VARCHAR(250) DEFAULT ''
			,SurnameThai				VARCHAR(250) DEFAULT ''
			,NameEng					VARCHAR(250) DEFAULT ''
			,SurnameEng					VARCHAR(250) DEFAULT ''
			,MemberType					VARCHAR(250) DEFAULT ''
			,PrincipleReferenceNumber	VARCHAR(250) DEFAULT ''
			,Gender						VARCHAR(250) DEFAULT ''
			,MaritalStatus				VARCHAR(250) DEFAULT ''
			,Nationality				VARCHAR(250) DEFAULT ''
			,CitizenId					VARCHAR(250) DEFAULT ''
			,OtherId					VARCHAR(250) DEFAULT ''
			,DateOfBirth				VARCHAR(250) DEFAULT ''
			,Age						SMALLINT
			,BuildingNo					VARCHAR(250) DEFAULT ''
			,VillageNo					VARCHAR(250) DEFAULT ''
			,LaneAlley					VARCHAR(250) DEFAULT ''
			,Road						VARCHAR(250) DEFAULT ''
			,SubDistrict				VARCHAR(250) DEFAULT ''
			,District					VARCHAR(250) DEFAULT ''
			,Province					VARCHAR(250) DEFAULT ''
			,PostCode					VARCHAR(250) DEFAULT ''
			,Country					VARCHAR(250) DEFAULT ''
			,ContactPersonName			VARCHAR(250) DEFAULT ''
			,OfficeTelNo				VARCHAR(250) DEFAULT ''
			,HomeTelNo					VARCHAR(250) DEFAULT ''
			,MobileNo					VARCHAR(250) DEFAULT ''
			,Email						VARCHAR(250) DEFAULT ''
			,FaxNo						VARCHAR(250) DEFAULT ''
			,StaffNo					VARCHAR(250) DEFAULT ''
			,JoinDate					VARCHAR(250) DEFAULT ''
			,EmploymentDate				VARCHAR(250) DEFAULT ''
			,PolicyNumber				VARCHAR(250) DEFAULT ''
			,ApplicationNumber			VARCHAR(250) DEFAULT ''
			,CertificateNo				VARCHAR(250) DEFAULT ''
			,InsurerCardNo				VARCHAR(250) DEFAULT ''
			,InsurerPreviousCardNo		VARCHAR(250) DEFAULT ''
			,PolicyYear					VARCHAR(250) DEFAULT ''
			,LifePolicyIssueDate		VARCHAR(250) DEFAULT ''
			,LifePolicyValidityDate		VARCHAR(250) DEFAULT ''
			,LifePolicyContractDate		VARCHAR(250) DEFAULT ''
			,[Plan]						VARCHAR(250) DEFAULT ''
			,PlanIssueDate				VARCHAR(250) DEFAULT ''
			,PlanContractDate			VARCHAR(250) DEFAULT ''
			,PlanEffectiveFromDate		VARCHAR(250) DEFAULT ''
			,PlanEffectiveToDate		VARCHAR(250) DEFAULT ''
			,PlanPaidDate				VARCHAR(250) DEFAULT ''
			,PlanPaidToDate				VARCHAR(250) DEFAULT ''
			,PlanNextDueDate			VARCHAR(250) DEFAULT ''
			,PlanTerminateDate			VARCHAR(250) DEFAULT ''
			,PlanReinstatementDate		VARCHAR(250) DEFAULT ''
			,PlanSuspensionDate			VARCHAR(250) DEFAULT ''
			,PlanSuspensionToDate		VARCHAR(250) DEFAULT ''
			,Rider						VARCHAR(250) DEFAULT ''
			,RiderIssueDate				VARCHAR(250) DEFAULT ''
			,RiderContractDate			VARCHAR(250) DEFAULT ''
			,RiderEffectiveFromDate		VARCHAR(250) DEFAULT ''
			,RiderEffectiveToDate		VARCHAR(250) DEFAULT ''
			,RiderPaidDate				VARCHAR(250) DEFAULT ''
			,RiderPaidToDate			VARCHAR(250) DEFAULT ''
			,RiderNextDueDate			VARCHAR(250) DEFAULT ''
			,RiderTerminateDate			VARCHAR(250) DEFAULT ''
			,RiderReinstatementDate		VARCHAR(250) DEFAULT ''
			,RiderSuspensionDate		VARCHAR(250) DEFAULT ''
			,ConditionDetail			VARCHAR(1000) DEFAULT ''
			,BankCode					VARCHAR(250) DEFAULT ''
			,BankAccountNo				VARCHAR(250) DEFAULT ''
			,PayeeName					VARCHAR(250) DEFAULT ''
			,PayeeCitizenId				VARCHAR(250) DEFAULT ''
			,Bu							VARCHAR(250) DEFAULT ''
			,Branch						VARCHAR(250) DEFAULT ''
			,CostCenter					VARCHAR(250) DEFAULT ''
			,AgentCode					VARCHAR(250) DEFAULT ''
			,AgentLeaderCode			VARCHAR(250) DEFAULT ''
			,[Broker]					VARCHAR(250) DEFAULT ''
			,Vip						VARCHAR(250) DEFAULT ''
			,PremiumFrequency			VARCHAR(250) DEFAULT ''
			,MemberPremium				FLOAT
			,PremiumIpd					VARCHAR(250) DEFAULT ''
			,PremiumOpd					VARCHAR(250) DEFAULT ''
			,SumInsured					FLOAT
			,SocialSecurityHospital		VARCHAR(250) DEFAULT ''
			,Remark1					VARCHAR(250) DEFAULT ''
			,Remark2					VARCHAR(250) DEFAULT ''
			,Remark3					VARCHAR(250) DEFAULT ''
			,Remark4					VARCHAR(250) DEFAULT ''
			,Remark5					VARCHAR(250) DEFAULT ''
			,Remark6					VARCHAR(250) DEFAULT ''
			,Remark7					VARCHAR(250) DEFAULT ''
			,Remark8					VARCHAR(250) DEFAULT ''
			,Remark9					VARCHAR(250) DEFAULT ''
			,Remark10					VARCHAR(250) DEFAULT ''
			,Transtype					VARCHAR(250) DEFAULT ''
			,Reason						VARCHAR(250) DEFAULT ''
			,product_code				VARCHAR(250) DEFAULT ''
			,IsEndorse					INT DEFAULT 0
			,CreateDate					DATETIME
			,pol_yr						VARCHAR(250) DEFAULT ''
			,pol_br						VARCHAR(250) DEFAULT ''
			,pol_no						VARCHAR(250) DEFAULT ''
			,pol_pre					VARCHAR(250) DEFAULT ''
			,plan_name_eng				VARCHAR(250) DEFAULT ''
			,ins_seq					Smallint DEFAULT 0 -- # 0 เพิ่มฟิล ins_seq สำหรับ policy / endos vis
			,flag_endoscode				VARCHAR(250) DEFAULT '' 
	)

/*	DECLARE @policy TABLE
	(
		pol_yr char(2),
		pol_br char(3),
		pol_pre char(3),
		pol_no char(6),
		app_yr char(2),
		app_no char(6),
		ref_yr CHAR(2),
		ref_no CHAR(6),
		endos_seq smallint,
		ref_type char(1),
		[start_date] datetime,
		end_date datetime,
		issue_date datetime,
		paid_date datetime,
		sale_code char(5),
		product_code char(4),
		rec_status char(1),
		tr_datetime datetime
	)

	DECLARE @his_policy TABLE
	(
		pol_yr char(2),
		pol_br char(3),
		pol_pre char(3),
		pol_no char(6),
		app_yr char(2),
		app_no char(6),
		endos_seq smallint,
		ref_type char(1),
		[start_date] datetime,
		end_date datetime,
		issue_date datetime,
		paid_date datetime,
		sale_code char(5),
		product_code char(4),
		rec_status char(1),
		tr_datetime datetime
	)

	DECLARE @endos TABLE
	(
		app_yr char(2),
		app_br char(3),
		app_pre char(3),
		app_no char(6),
		endos_group char(1),
		endos_yr char(2),
		endos_no char(6),
		pol_yr char(2),
		pol_br char(3),
		pol_no char(6),
		flag_group char(1),
		approve_datetime datetime
	)*/

/*--- test ----------
--print 'T1 :'+ CONVERT(VARCHAR,getdate())
------------------------------
	INSERT INTO @his_policy
	(
		pol_yr,
		pol_br,
		pol_pre,
		pol_no,
		app_yr,
		app_no,
		endos_seq,
		ref_type,
		[start_date],
		end_date,
		issue_date,
		paid_date,
		sale_code,
		product_code,
		rec_status,
		tr_datetime
	)
	SELECT
		pol_yr,
		pol_br,
		pol_pre,
		pol_no,
		app_yr,
		app_no,
		endos_seq,
		ref_type,
		[start_date],
		end_date,
		issue_date,
		paid_date,
		sale_code,
		product_code,
		rec_status,
		tr_datetime
	FROM his_policy
	--WHERE pol_pre in('523','560','580','581','582','587','588')
	--AND endos_seq = 0
	--AND CONVERT(VARCHAR(10) , tr_datetime ,111 ) = @date

	----AND CONVERT(VARCHAR(10) , tr_datetime ,111 ) between '2020/11/02' AND '2021/07/29'
	----and pol_yr+pol_br+'/POL/'+pol_no+'-'+pol_pre in (
	----'21181/POL/805240-588'
	----)

	WHERE (  ( pol_pre in('523','560','580','581','582','587','588')
			  AND endos_seq = 0
			  AND CONVERT(VARCHAR(10) , tr_datetime ,111 ) BETWEEN @Start_Date AND @date 
		     )
	      --  or
		     --( pol_yr+pol_br+'/POL/'+pol_no+'-'+pol_pre in ('21181/POL/800887-587','21181/POL/800886-587' ))
		   )
--- test ----------
--print 'T2 :'+ CONVERT(VARCHAR,getdate())
------------------------------

	INSERT INTO @endos
	(
		app_yr,
		app_br,
		app_pre,
		app_no,
		endos_group,
		endos_yr,
		endos_no,
		pol_yr,
		pol_no,
		pol_br,
		flag_group,
		approve_datetime
	)
	SELECT 
		app_yr,
		app_br,
		app_pre,
		app_no,
		endos_group,
		endos_yr,
		endos_no,
		pol_yr,
		pol_no,
		pol_br,
		flag_group,
		approve_datetime
	FROM endos 
	WHERE app_pre in('523','560','580','581','582','587','588')
	AND CONVERT(VARCHAR, approve_datetime,111) BETWEEN @Start_Date AND @date

	--AND CONVERT(VARCHAR(10) , approve_datetime ,111 ) between '2020/11/02' AND '2021/07/29'
	--and pol_yr+pol_br+'/POL/'+pol_no+'-'+app_pre in (
	--'21181/POL/801861-581'
	--)

--- test ----------
--print 'T3 :'+ CONVERT(VARCHAR,getdate())
------------------------------

	--ดึงข้อมูลไว้ใช้ Join กับ Endos และหา Renew Sequence	
	INSERT INTO @policy
	(
		pol_yr,
		pol_br,
		pol_pre,
		pol_no,
		app_yr,
		app_no,
		ref_yr,
		ref_no,
		endos_seq,
		ref_type,
		[start_date],
		end_date,
		issue_date,
		paid_date,
		sale_code,
		product_code,
		rec_status,
		tr_datetime
	)
	SELECT
		pol_yr,
		pol_br,
		pol_pre,
		pol_no,
		app_yr,
		app_no,
		ref_yr,
		ref_no,
		endos_seq,
		ref_type,
		[start_date],
		end_date,
		issue_date,
		paid_date,
		sale_code,
		product_code,
		rec_status,
		tr_datetime
	FROM [policy]
	WHERE pol_pre in('523','560','580','581','582','587','588')	
*/
--- test ----------
--print 'T4 :'+ CONVERT(VARCHAR,getdate())
------------------------------
DECLARE @TPA_Mapping_VIS TABLE (
		[pol_yr] [char](2) NOT NULL,
		[pol_br] [char](3) NOT NULL,
		[pol_pre] [char](3) NOT NULL,
		[pol_no] [char](6) NOT NULL,
		[ins_seq] [smallint] NOT NULL,
		[MemberCode] [varchar](250) NULL,
		[InsuredName] [varchar](250) NULL,
		[CitizenId] [varchar](50) NULL,
		[InsertDate] [datetime] NULL,
		[ModifiedDate] [datetime] NULL,
		[FlagActive] [bit] NULL
	) 
INSERT INTO @TPA_Mapping_VIS (
		[pol_yr]
		,[pol_br]
		,[pol_pre]
		,[pol_no]
		,[ins_seq]
		,[MemberCode]
		,[InsuredName]
		,[CitizenId]
		,[InsertDate]
		,[ModifiedDate]
		,[FlagActive])
	SELECT [pol_yr]
		  ,[pol_br]
		  ,[pol_pre]
		  ,[pol_no]
		  ,[ins_seq]
		  ,[MemberCode]
		  ,[InsuredName]
		  ,[CitizenId]
		  ,[InsertDate]
		  ,[ModifiedDate]
		  ,[FlagActive]
	FROM [dbo].[TPA_Mapping_VIS] 
	WHERE pol_pre in('574','573','578') AND [FlagActive] = 1

	INSERT INTO @Temp_TPA_Daily 
	SELECT CompanyName
			, MemberCode 
			, Title 
			, NameThai 
			, SurnameThai 
			, NameEng 
			, SurnameEng 
			, MemberType 
			, PrincipleReferenceNumber 
			, Gender 
			, MaritalStatus 
			, Nationality
			, CitizenId 
			, OtherId 
			, DateOfBirth 
			, Age 
			, BuildingNo 
			, VillageNo 
			, LaneAlley 
			, Road 
			, SubDistrict 
			, District 
			, Province
			, PostCode 
			, Country 
			, ContactPersonName
			, OfficeTelNo 
			, HomeTelNo 
			, MobileNo 
			, Email 
			, FaxNo 
			, StaffNo 
			, JoinDate 
			, EmploymentDate 
			, PolicyNumber 
			, ApplicationNumber 
			, CertificateNo 
			, InsurerCardNo 
			, InsurerPreviousCardNo 
			--, PolicyYear
			, case when ref_type = '4' then case when isnull(ref_no,'') = '' then PolicyYear else dbo.GetRenewCount(pol_yr,pol_br,pol_pre,pol_no) end else PolicyYear end PolicyYear
			, LifePolicyIssueDate 
			, LifePolicyValidityDate
			, LifePolicyContractDate
			, [Plan]
			, PlanIssueDate 
			, PlanContractDate
			, PlanEffectiveFromDate
			, PlanEffectiveToDate
			, PlanPaidDate
			, PlanPaidToDate
			, PlanNextDueDate 
			, PlanTerminateDate
			, PlanReinstatementDate
			, PlanSuspensionDate 
			, PlanSuspensionToDate
			, Rider
			, RiderIssueDate
			, RiderContractDate
			, RiderEffectiveFromDate
			, RiderEffectiveToDate
			, RiderPaidDate
			, RiderPaidToDate
			, RiderNextDueDate
			, RiderTerminateDate
			, RiderReinstatementDate
			, RiderSuspensionDate
			, ConditionDetail
			, BankCode
			, BankAccountNo
			, PayeeName
			, PayeeCitizenId 
			, Bu
			, Branch
			, CostCenter
			, AgentCode
			, AgentLeaderCode
			, [Broker]
			, Vip
			, PremiumFrequency
			, MemberPremium
			, PremiumIpd
			, PremiumOpd
			, SumInsured
			, SocialSecurityHospital
			, Remark1
			, Remark2
			, Remark3
			, Remark4
			, Remark5
			, Remark6
			, Remark7
			, Remark8
			, Remark9
			, Remark10
			, Transtype
			, Reason
			, product_code
			, IsEndorse
			, tr_datetime
			, pol_yr
			, pol_br
			, pol_no
			, pol_pre
			, plan_name_eng
			, ins_seq     -- # 5 add new for policy from vis
			, flag_endoscode
	FROM
	(
			SELECT
			/*ลำดับ run ด้านล่าง*/
			CompanyName = 'VIB' /*2.กรมธรรม์ แบ่งออกเป็น เดี่ยว ตั้งตาม Product นั้นๆ กลุ่ม ตั้งตามชื่อบริษัท ["ชื่อ Insurer"+Productname] */
			, MemberCode = p.pol_yr+p.pol_br+'/POL/'+p.pol_no+'-'+p.pol_pre+ins.ins_idno /*3.Unique Code for refer to member (Format depend ON member) [PolicyNo+Idno.] */
			, Title = ISNULL(prf.prefix_name,' ') /*4.คำนำหน้าชื่อ*/
			, NameThai = REPLACE(REPLACE(REPLACE(ISNULL(ins.ins_fname,' '),CHAR(13),''),CHAR(10),''),CHAR(9),'') /*5.ชื่อภาษาไทย*/
			, SurnameThai = REPLACE(REPLACE(REPLACE(ISNULL(ins.ins_lname,' '),CHAR(13),''),CHAR(10),''),CHAR(9),'') /*6.นามสกุลภาษาไทย*/
			, NameEng = ' ' /*7.ชื่อภาษาอังกฤษ*/
			, SurnameEng = ' ' /*8.นามสกุลภาษาอังกฤษ*/
			, MemberType = ' ' /*9.member,Spouse,Child, Dependant */
			, PrincipleReferenceNumber = ' ' /*10.ใช้ในกรณีที่กรมธรรม์นั้นมีผลประโยชน์กับครอบครัว (ในกรณีที่ไม่ใช่ Member)*/
			, Gender = (CASE ISNULL(ins.ins_sex,'') WHEN ' ' THEN 'U' ELSE ins.ins_sex END ) /*11.ใส่เป็น M,F,U*/
			, MaritalStatus = (CASE ISNULL(ins.ins_status,'') WHEN '1' THEN 'S' WHEN '2' THEN 'M' WHEN '4' THEN 'D' ELSE 'U' END) /*12.Divorced=หย่าร้าง, Single=โสด, Married=สมรส, Unknown=ไม่ระบุ*/
			, Nationality = ' ' /*13.Nationality*/
			, CitizenId = (CASE ISNULL(ins.ins_idno_flag,' ') WHEN '0' THEN  ISNULL(ins.ins_idno,'') ELSE '' END) /*14.เลขที่บัตรประชาชน*/
			, OtherId = (CASE ISNULL(ins.ins_idno_flag,' ') WHEN '0' THEN '' ELSE ISNULL(ins.ins_idno,'') END) /*15.เลขที่บัตรอื่น*/
			, DateOfBirth = CONVERT(VARCHAR(10),ins.ins_birthdate,103) /*16.วันเดือนปีเกิด*/
			, Age = ins.ins_age /*17.อายุ*/
			, BuildingNo = ISNULL(ins.ins_addno,'') /*18.บ้านเลขที่ */
			, VillageNo = ISNULL(ins.ins_village,'') /*19.หมู่บ้าน*/
			, LaneAlley = ISNULL(ins.ins_soi,'') /*20.ซอย*/
			, Road = ISNULL(ins.ins_street,'') /*21.ถนน*/
			, SubDistrict = ISNULL(ins.ins_tumbol,'') /*22.ตำบล*/
			, District = ISNULL(st.city_name,'') /*23.อำเภอ*/
			, Province = ISNULL(st.state_name,'') /*24.จังหวัด*/
			, PostCode = ISNULL(ins.ins_zipcode,'') /*25.รหัสไปรษณีย์*/
			, Country = ISNULL(st.country_nm_thai,'') /*26.ประเทศ*/
			, ContactPersonName = REPLACE(REPLACE(REPLACE((ISNULL(prf.prefix_name,'')+ CASE  ISNULL(prf.flag_space,'') WHEN 'Y' THEN ' '  ELSE '' END +ISNULL(ins.Ins_fname,'') + '  ' + ISNULL(ins.Ins_lname,'')),CHAR(13),''),CHAR(10),''),CHAR(9),'') /*27.ชื่อผู้ติดต่อ*/
			, OfficeTelNo = ISNULL(ins.ins_tel2,'') /*28.เบอร์โทรที่ทำงาน*/
			, HomeTelNo = ISNULL(ins.ins_tel1,'') /*29.เบอร์โทรบ้าน*/
			, MobileNo = ISNULL(ins.ins_mobile,'') /*30.เบอร์มือถือ */
			, Email = ISNULL(ins.ins_email,'') /*31.อีเมล์*/
			, FaxNo = ISNULL(ins.ins_fax,'') /*32.เบอร์โทรสาร*/
			, StaffNo = ' ' /*33.รหัสพนักงาน*/
			, JoinDate = CONVERT(VARCHAR(10),p.[start_date],103) /*34.วันที่กรมธรรม์มีผลบังคับปีแรก*/
			, EmploymentDate = ' ' /*35.วันที่เริ่มงาน*/
			, PolicyNumber = ''/*36.หมายเลขกรมธรรม์ เดี่ยว Policy dummy กลุ่ม  Policyno. ['V00001' กธเดี่ยว Policyno. กธกลุ่ม] */
			, ApplicationNumber = p.app_yr+p.pol_br+'/APP/'+p.app_no+'-'+p.pol_pre /*37.เลขที่ใบคำขอ*/
			, CertificateNo = p.pol_yr+p.pol_br+'/POL/'+p.pol_no+'-'+p.pol_pre /*38.เลขที่ Certificate .[Policyno.] */
			, InsurerCardNo = p.pol_yr+p.pol_br+'/POL/'+p.pol_no+'-'+p.pol_pre /*39.หมายเลขบนบัตรประกัน,หมายเลขบัตรเครดิต/ATM */
			, InsurerPreviousCardNo = p.pol_yr+p.pol_br+'/POL/'+p.pol_no+'-'+p.pol_pre /*40.หมายเลขบนบัตรประกัน,หมายเลขบัตรเครดิต/ATM (ใช้ในกรณีที่บัตรเก่าหาย) */
			, PolicyYear = 1 /*41.จำนวนปีที่ถือกรมธรรม์ Non Life หมายถึงปีที่ซื้อกรมธรรม์ (ปีต่อปี) Life หมายถึงกรมธรรม์นี้ซื้อมาแล้วกี่ปี (จำนวนปีที่ถือกรมธรรม์นั้น)*/
			, LifePolicyIssueDate = CONVERT(VARCHAR(10),p.issue_date,103) /*42.วันที่ออกกรมธรมธรรม์ */
			, LifePolicyValidityDate = ' ' /*43.Life Policy Validity Date */
			, LifePolicyContractDate = ' ' /*44.Life Policy Contract Date*/
			, [Plan] = CASE 
							WHEN CHARINDEX(' ',prd.plan_name) > 0 THEN SUBSTRING(prd.plan_name,0,CHARINDEX(' ',prd.plan_name))
							ELSE prd.plan_name 
						END/*45.แผนความคุ้มครอง*/
			, PlanIssueDate = ' ' /*46.Plan Issue Date*/
			, PlanContractDate = ' ' /*47.Plan Contract Date*/
			, PlanEffectiveFromDate = CONVERT(VARCHAR(10),cov.[start_date],103)  /*48.วันที่แผนมีผลบังคับ*/
			, PlanEffectiveToDate = CONVERT(VARCHAR(10),cov.end_date,103)  /*49.วันสุดท้ายที่แผนมีผลบังคับ  */
			, PlanPaidDate = ISNULL(CONVERT(VARCHAR(10),p.paid_date,103),'') /*50.วันที่ชำระเงิน*/
			, PlanPaidToDate = ' ' /*51.วันที่ครบกำหนดชำระ*/
			, PlanNextDueDate = ' ' /*52.วันที่ครบกำหนดชำระครั้งต่อไป*/
			, PlanTerminateDate = ' ' /*53.ถ้า Terminate Member แล้ว แต่ Rider ยังไม่ได้ Terminate ด้วย จะทำได้ไหม? [Y (ถ้า Trantype = Termination)]*/
			, PlanReinstatementDate = ' ' /*54.ถ้า Reinstatement Member แล้ว แต่ Rider ยังไม่ได้ Reinstatement ด้วย จะทำได้ไหม? [Y (ถ้า Trantype = Termination)]*/
			, PlanSuspensionDate = ' ' /*55.Plan Suspension Date [Y (Suspension)]*/
			, PlanSuspensionToDate = ' ' /*56.Plan Suspension To Date*/
			, Rider = ' ' /*57.Rider Code*/
			, RiderIssueDate = ' ' /*58.Rider Issue Date*/
			, RiderContractDate = ' ' /*59.Rider Contract Date*/
			, RiderEffectiveFromDate = ' ' /*60.วันที่ Rider มีผลบังคับ*/
			, RiderEffectiveToDate = ' ' /*61.วันที่ Rider มีผลสิ้นสุดบังคับ*/
			, RiderPaidDate = ' ' /*62.วันที่ Rider ชำระเงิน*/
			, RiderPaidToDate = ' ' /*63.วันที่ Rider ครบกำหนดชำระ*/
			, RiderNextDueDate = ' ' /*64.วันที่ Rider ครบกำหนดชำระครั้งต่อไป*/
			, RiderTerminateDate = ' ' /*65.ไม่มี Plan Terminate  เพราะ ณ เวลาหนึ่ง จะมี 1 คนต่อ 1 Plan ดังนั้นถ้า Terminate Member คือ Terminate Plan นั่นเอง*/
			, RiderReinstatementDate = ' ' /*66.วันที่ Rider กลับมามีผลบังคับ*/
			, RiderSuspensionDate = ' ' /*67.วันที่ Rider ระงับความคุ้มครอง*/
			, ConditionDetail = REPLACE(REPLACE(REPLACE(REPLACE(CAST(ISNULL(ins_remark,'') AS VARCHAR(1000)),CHAR(13),''),CHAR(10),''),CHAR(9),''),char(10)+NCHAR(0x0E48),' ') /*68.ข้อยกเว้นเฉพาะบุคคล*/
			, BankCode = ' ' /*69.รหัสธนาคาร*/
			, BankAccountNo = ' ' /*70.หมายเลขบัญชี*/
			, PayeeName = ' ' /*71.ชื่อผู้สั่งจ่าย*/
			, PayeeCitizenId = ' ' /*72.เลขที่บัตรประชาชนของผู้สั่งจ่าย*/
			, Bu = ' ' /*73.Business Unit Code (ลูกค้าต้องให้ค่ามา)*/
			, Branch = p.pol_br /*74.สาขา*/
			, CostCenter = ' ' /*75.Cost Center Code กรณีแยกรายงานตาม department ต่าง*/
			, AgentCode = ISNULL(p.sale_code,'') /*76.รหัสตัวแทน (ลูกค้าต้องให้ค่ามา)*/
			, AgentLeaderCode = ' ' /*77.รหัสหัวหน้าตัวแทน (ลูกค้าต้องให้ค่ามา) */
			, [Broker] = ' ' /*78.นายหน้าขายประกัน*/
			, Vip = ' ' /*79.บอกว่าเป็น VIP หรือไม่*/
			, PremiumFrequency = '1' /*80.ความถี่ในการชำระเงิน (รายปี = 12 / 6 ด = 6 / 3 ด = 3 / รายเดือน=1 )*/
			, MemberPremium = ISNULL(cov.net_premium,'0') /*81.ค่าเบี้ยประกัน*/
			, PremiumIpd = ' ' /*82.ค่าเบี้ยประกันผู้ป่วยใน*/
			, PremiumOpd = ' ' /*83.ค่าเบี้ยประกันผู้ป่วยนอก*/
			, SumInsured = ISNULL(cov.sumins_amt,'0') /*84.ทุนประกัน*/
			, SocialSecurityHospital = ' ' /*85.ชื่อ รพ ในเครือประกันสังคม*/
			, Remark1 = ' ' /*86.Remark 1*/
			, Remark2 = ' ' /*87.Remark 2*/
			, Remark3 = ' ' /*88.Remark 3*/
			, Remark4 = ' ' /*89.Remark 4*/
			, Remark5 = ' ' /*90.Remark 5*/
			, Remark6 = ' ' /*91.Remark 6*/
			, Remark7 = ' ' /*92.Remark 7*/
			, Remark8 = ' ' /*93.Remark 8*/
			, Remark9 = ' ' /*94.Remark 9*/
			, Remark10 = ' ' /*95.Remark 10*/
			, Transtype = 'N' /*96.Termination,Suspension,Reinstatement*/
			, Reason = ' ' /*97.Y (ถ้า Trantype = Termination, Suspension, Reinstatement)*/
			, p.product_code
			, 0 AS 'IsEndorse'
			, p.tr_datetime
			, p.pol_yr
			, p.pol_br
			, p.pol_no
			, p.pol_pre
			, prd.plan_name_eng
			, p.ref_no
			, p.ref_type
			, ins.ins_seq     -- # 5 add new for policy from vis
			, flag_endoscode = 'N'
			--FROM @his_policy p 
			FROM his_policy p
			INNER JOIN his_insured ins ON p.pol_yr = ins.pol_yr AND p.pol_br = ins.pol_br AND p.pol_pre = ins.pol_pre AND p.pol_no = ins.pol_no AND p.endos_seq = ins.endos_seq
			INNER JOIN his_receipt receipt ON receipt.pol_yr = p.pol_yr AND receipt.pol_br = p.pol_br AND receipt.pol_pre = p.pol_pre AND receipt.pol_no = p.pol_no  AND receipt.endos_seq = p.endos_seq
			INNER JOIN his_cover_insurance cov ON ins.pol_yr = cov.pol_yr AND ins.pol_br = cov.pol_br AND ins.pol_pre = cov.pol_pre AND ins.pol_no = cov.pol_no AND ins.endos_seq = cov.endos_seq AND ins.ins_seq =  cov.ins_seq 
			INNER JOIN product_insurance pri ON pri.class_code + pri.subclass_code = p.pol_pre AND pri.product_code = p.product_code 
			INNER JOIN product_insurance_plan prd ON prd.class_code = pri.class_code AND prd.subclass_code = pri.subclass_code AND prd.product_code = pri.product_code AND prd.plan_seq = cov.plan_seq
			LEFT JOIN centerdb.dbo.prefix prf ON ins.ins_prefix = prf.prefix_code
			LEFT JOIN vIState st ON ins.Ins_province = st.state_code AND ins.Ins_amphur = st.city_code AND ins.Ins_country = st.country_code
			WHERE p.pol_pre in('523','543','544','545','581','582','587','588','601','602','574','573','578')
			  AND p.endos_seq = 0
			  AND p.tr_datetime >= @Start_Date 
			  AND p.tr_datetime < @date 
			--====== For support การดึงโรคยกเว้น ให้ดึงจาก policy และ transtpye = 'E' ======
			--FROM @policy p
			--INNER JOIN pol_insured ins ON p.pol_yr = ins.pol_yr AND p.pol_br = ins.pol_br AND p.pol_no = ins.pol_no AND p.pol_pre = ins.pol_pre 
			--LEFT JOIN centerdb.dbo.prefix prf ON ins.ins_prefix = prf.prefix_code
			--INNER JOIN pol_receipt receipt ON receipt.pol_yr = p.pol_yr AND receipt.pol_br = p.pol_br AND receipt.pol_no = p.pol_no AND receipt.pol_pre = p.pol_pre 
			--INNER JOIN pol_cover_insurance cov ON ins.pol_yr = cov.pol_yr AND ins.pol_br = cov.pol_br AND ins.pol_no = cov.pol_no AND ins.pol_pre = cov.pol_pre AND ins.ins_seq =  cov.ins_seq 
			--INNER JOIN product_insurance pri ON pri.class_code + pri.subclass_code = p.pol_pre AND pri.product_code = p.product_code 
			--INNER JOIN product_insurance_plan prd ON prd.class_code = pri.class_code AND prd.subclass_code = pri.subclass_code AND prd.product_code = pri.product_code AND prd.plan_seq = cov.plan_seq
			--LEFT JOIN vIState st ON ins.Ins_province = st.state_code AND ins.Ins_amphur = st.city_code AND ins.Ins_country = st.country_code
			--WHERE (
			--(p.pol_yr = '19' AND p.pol_br = '181' AND p.pol_no = '002068' AND p.pol_pre = '581')
			--or(p.pol_yr = '19' AND p.pol_br = '181' AND p.pol_no = '002086' AND p.pol_pre = '581')
			--)

			UNION

			SELECT
			CompanyName = 'VIB' /*2.กรมธรรม์ แบ่งออกเป็น เดี่ยว ตั้งตาม Product นั้นๆ กลุ่ม ตั้งตามชื่อบริษัท ["ชื่อ Insurer"+Productname] */
			, MemberCode = p.pol_yr+p.pol_br+'/POL/'+p.pol_no+'-'+p.pol_pre+ins.ins_idno /*3.Unique Code for refer to member (Format depend ON member) [PolicyNo+Idno.] */
			, Title = ISNULL(prf.prefix_name,' ') /*4.คำนำหน้าชื่อ*/
			, NameThai = REPLACE(REPLACE(REPLACE(ISNULL(ins.ins_fname,' '),CHAR(13),''),CHAR(10),''),CHAR(9),'') /*5.ชื่อภาษาไทย*/
			, SurnameThai = REPLACE(REPLACE(REPLACE(ISNULL(ins.ins_lname,' '),CHAR(13),''),CHAR(10),''),CHAR(9),'') /*6.นามสกุลภาษาไทย*/
			, NameEng = ' ' /*7.ชื่อภาษาอังกฤษ*/
			, SurnameEng = ' ' /*8.นามสกุลภาษาอังกฤษ*/
			, MemberType = ' ' /*9.member,Spouse,Child, Dependant */
			, PrincipleReferenceNumber = ' ' /*10.ใช้ในกรณีที่กรมธรรม์นั้นมีผลประโยชน์กับครอบครัว (ในกรณีที่ไม่ใช่ Member)*/
			, Gender = (CASE ISNULL(ins.ins_sex,'') WHEN ' ' THEN 'U' ELSE ins.ins_sex END ) /*11.ใส่เป็น M,F,U*/
			, MaritalStatus = (CASE ISNULL(ins.ins_status,'') WHEN '1' THEN 'S' WHEN '2' THEN 'M' WHEN '4' THEN 'D' ELSE 'U' END) /*12.Divorced=หย่าร้าง, Single=โสด, Married=สมรส, Unknown=ไม่ระบุ*/
			, Nationality = ' ' /*13.Nationality*/
			, CitizenId = (CASE ISNULL(ins.ins_idno_flag,' ') WHEN '0' THEN  ISNULL(ins.ins_idno,'') ELSE '' END) /*14.เลขที่บัตรประชาชน*/
			, OtherId = (CASE ISNULL(ins.ins_idno_flag,' ') WHEN '0' THEN '' ELSE ISNULL(ins.ins_idno,'') END) /*15.เลขที่บัตรอื่น*/
			, DateOfBirth = CONVERT(VARCHAR(10),ins.ins_birthdate,103) /*16.วันเดือนปีเกิด*/
			, Age = ins.ins_age /*17.อายุ*/
			, BuildingNo = ISNULL(ins.ins_addno,'') /*18.บ้านเลขที่ */
			, VillageNo = ISNULL(ins.ins_village,'') /*19.หมู่บ้าน*/
			, LaneAlley = ISNULL(ins.ins_soi,'') /*20.ซอย*/
			, Road = ISNULL(ins.ins_street,'') /*21.ถนน*/
			, SubDistrict = ISNULL(ins.ins_tumbol,'') /*22.ตำบล*/
			, District = ISNULL(st.city_name,'') /*23.อำเภอ*/
			, Province = ISNULL(st.state_name,'') /*24.จังหวัด*/
			, PostCode = ISNULL(ins.ins_zipcode,'') /*25.รหัสไปรษณีย์*/
			, Country = ISNULL(st.country_nm_thai,'') /*26.ประเทศ*/
			, ContactPersonName = REPLACE(REPLACE(REPLACE((ISNULL(prf.prefix_name,'')+ CASE  ISNULL(prf.flag_space,'') WHEN 'Y' THEN ' '  ELSE '' END +ISNULL(ins.Ins_fname,'') + '  ' + ISNULL(ins.Ins_lname,'')),CHAR(13),''),CHAR(10),''),CHAR(9),'') /*27.ชื่อผู้ติดต่อ*/
			, OfficeTelNo = ISNULL(ins.ins_tel2,'') /*28.เบอร์โทรที่ทำงาน*/
			, HomeTelNo = ISNULL(ins.ins_tel1,'') /*29.เบอร์โทรบ้าน*/
			, MobileNo = ISNULL(ins.ins_mobile,'') /*30.เบอร์มือถือ */
			, Email = ISNULL(ins.ins_email,'') /*31.อีเมล์*/
			, FaxNo = ISNULL(ins.ins_fax,'') /*32.เบอร์โทรสาร*/
			, StaffNo = ' ' /*33.รหัสพนักงาน*/
			, JoinDate = CONVERT(VARCHAR(10),p.start_date,103) /*34.วันที่กรมธรรม์มีผลบังคับปีแรก*/
			, EmploymentDate = ' ' /*35.วันที่เริ่มงาน*/
			, PolicyNumber = '' /*36.หมายเลขกรมธรรม์ เดี่ยว Policy dummy กลุ่ม  Policyno. ['V00001' กธเดี่ยว Policyno. กธกลุ่ม] */
			, ApplicationNumber = p.app_yr+p.pol_br+'/APP/'+p.app_no+'-'+p.pol_pre /*37.เลขที่ใบคำขอ*/
			, CertificateNo = p.pol_yr+p.pol_br+'/POL/'+p.pol_no+'-'+p.pol_pre /*38.เลขที่ Certificate .[Policyno.] */
			, InsurerCardNo = p.pol_yr+p.pol_br+'/POL/'+p.pol_no+'-'+p.pol_pre /*39.หมายเลขบนบัตรประกัน,หมายเลขบัตรเครดิต/ATM */
			, InsurerPreviousCardNo = p.pol_yr+p.pol_br+'/POL/'+p.pol_no+'-'+p.pol_pre /*40.หมายเลขบนบัตรประกัน,หมายเลขบัตรเครดิต/ATM (ใช้ในกรณีที่บัตรเก่าหาย) */
			, PolicyYear = 1 /*41.จำนวนปีที่ถือกรมธรรม์ Non Life หมายถึงปีที่ซื้อกรมธรรม์ (ปีต่อปี) Life หมายถึงกรมธรรม์นี้ซื้อมาแล้วกี่ปี (จำนวนปีที่ถือกรมธรรม์นั้น)*/
			, LifePolicyIssueDate = CONVERT(VARCHAR(10),p.issue_date,103) /*42.วันที่ออกกรมธรมธรรม์ */
			, LifePolicyValidityDate = ' ' /*43.Life Policy Validity Date */
			, LifePolicyContractDate = ' ' /*44.Life Policy Contract Date*/
			, [Plan] = CASE 
							WHEN CHARINDEX(' ',prd.plan_name) > 0 THEN SUBSTRING(prd.plan_name,0,CHARINDEX(' ',prd.plan_name))
							ELSE prd.plan_name 
						END /*45.แผนความคุ้มครอง*/
			, PlanIssueDate = ' ' /*46.Plan Issue Date*/
			, PlanContractDate = ' ' /*47.Plan Contract Date*/
			, PlanEffectiveFromDate = CONVERT(VARCHAR(10),cov.[start_date],103)  /*48.วันที่แผนมีผลบังคับ*/
			--, PlanEffectiveToDate = CONVERT(VARCHAR(10),cov.end_date,103)  /*49.วันสุดท้ายที่แผนมีผลบังคับ  */
			, PlanEffectiveToDate = CASE p.rec_status		--'E' /*96.Termination,Suspension,Reinstatement*/
								WHEN 'C' THEN CONVERT(VARCHAR(10),cov.[start_date],103) 
								WHEN 'W' THEN CONVERT(VARCHAR(10),cov.end_date,103) 
								ELSE CONVERT(VARCHAR(10),cov.end_date,103)
							END
			, PlanPaidDate = ISNULL(CONVERT(VARCHAR(10),p.paid_date,103),'') /*50.วันที่ชำระเงิน*/
			, PlanPaidToDate = ' ' /*51.วันที่ครบกำหนดชำระ*/
			, PlanNextDueDate = ' ' /*52.วันที่ครบกำหนดชำระครั้งต่อไป*/
			, PlanTerminateDate = ' ' /*53.ถ้า Terminate Member แล้ว แต่ Rider ยังไม่ได้ Terminate ด้วย จะทำได้ไหม? [Y (ถ้า Trantype = Termination)]*/
			, PlanReinstatementDate = ' ' /*54.ถ้า Reinstatement Member แล้ว แต่ Rider ยังไม่ได้ Reinstatement ด้วย จะทำได้ไหม? [Y (ถ้า Trantype = Termination)]*/
			, PlanSuspensionDate = ' ' /*55.Plan Suspension Date [Y (Suspension)]*/
			, PlanSuspensionToDate = ' ' /*56.Plan Suspension To Date*/
			, Rider = ' ' /*57.Rider Code*/
			, RiderIssueDate = ' ' /*58.Rider Issue Date*/
			, RiderContractDate = ' ' /*59.Rider Contract Date*/
			, RiderEffectiveFromDate = ' ' /*60.วันที่ Rider มีผลบังคับ*/
			, RiderEffectiveToDate = ' ' /*61.วันที่ Rider มีผลสิ้นสุดบังคับ*/
			, RiderPaidDate = ' ' /*62.วันที่ Rider ชำระเงิน*/
			, RiderPaidToDate = ' ' /*63.วันที่ Rider ครบกำหนดชำระ*/
			, RiderNextDueDate = ' ' /*64.วันที่ Rider ครบกำหนดชำระครั้งต่อไป*/
			, RiderTerminateDate = ' ' /*65.ไม่มี Plan Terminate  เพราะ ณ เวลาหนึ่ง จะมี 1 คนต่อ 1 Plan ดังนั้นถ้า Terminate Member คือ Terminate Plan นั่นเอง*/
			, RiderReinstatementDate = ' ' /*66.วันที่ Rider กลับมามีผลบังคับ*/
			, RiderSuspensionDate = ' ' /*67.วันที่ Rider ระงับความคุ้มครอง*/
			, ConditionDetail =  REPLACE(REPLACE(REPLACE(REPLACE(CAST(ISNULL(ins_remark,'') AS VARCHAR(1000)),CHAR(13),''),CHAR(10),''),CHAR(9),''),char(10)+NCHAR(0x0E48),' ') /*68.ข้อยกเว้นเฉพาะบุคคล*/
			, BankCode = ' ' /*69.รหัสธนาคาร*/
			, BankAccountNo = ' ' /*70.หมายเลขบัญชี*/
			, PayeeName = ' ' /*71.ชื่อผู้สั่งจ่าย*/
			, PayeeCitizenId = ' ' /*72.เลขที่บัตรประชาชนของผู้สั่งจ่าย*/
			, Bu = ' ' /*73.Business Unit Code (ลูกค้าต้องให้ค่ามา)*/
			, Branch = p.pol_br /*74.สาขา*/
			, CostCenter = ' ' /*75.Cost Center Code กรณีแยกรายงานตาม department ต่าง*/
			, AgentCode = ISNULL(p.sale_code,'') /*76.รหัสตัวแทน (ลูกค้าต้องให้ค่ามา)*/
			, AgentLeaderCode = ' ' /*77.รหัสหัวหน้าตัวแทน (ลูกค้าต้องให้ค่ามา) */
			, [Broker] = ' ' /*78.นายหน้าขายประกัน*/
			, Vip = ' ' /*79.บอกว่าเป็น VIP หรือไม่*/
			, PremiumFrequency = '1' /*80.ความถี่ในการชำระเงิน (รายปี = 12 / 6 ด = 6 / 3 ด = 3 / รายเดือน=1 )*/
			, MemberPremium = ISNULL(cov.net_premium,'0') /*81.ค่าเบี้ยประกัน*/
			, PremiumIpd = ' ' /*82.ค่าเบี้ยประกันผู้ป่วยใน*/
			, PremiumOpd = ' ' /*83.ค่าเบี้ยประกันผู้ป่วยนอก*/
			, SumInsured = ISNULL(cov.sumins_amt,'0') /*84.ทุนประกัน*/
			, SocialSecurityHospital = ' ' /*85.ชื่อ รพ ในเครือประกันสังคม*/
			, Remark1 = ' ' /*86.Remark 1*/
			, Remark2 = ' ' /*87.Remark 2*/
			, Remark3 = ' ' /*88.Remark 3*/
			, Remark4 = ' ' /*89.Remark 4*/
			, Remark5 = ' ' /*90.Remark 5*/
			, Remark6 = ' ' /*91.Remark 6*/
			, Remark7 = ' ' /*92.Remark 7*/
			, Remark8 = ' ' /*93.Remark 8*/
			, Remark9 = ' ' /*94.Remark 9*/
			, Remark10 = ' ' /*95.Remark 10*/
			, Transtype = CASE p.rec_status		--'E' /*96.Termination,Suspension,Reinstatement*/
								WHEN 'C' THEN 'T' 
								WHEN 'W' THEN 'T' 
								ELSE 'E'
							END
			, Reason = ' ' /*97.Y (ถ้า Trantype = Termination, Suspension, Reinstatement)*/
			, p.product_code
			, 1 AS 'IsEndorse'
			, e.approve_datetime
			, p.pol_yr
			, p.pol_br
			, p.pol_no
			, p.pol_pre
			, prd.plan_name_eng
			, p.ref_no
			, p.ref_type
			, ins.ins_seq     -- # 5 add new for policy from vis
			, flag_endoscode = CASE WHEN et.endos_code = '51' and endos_name_eng = 'Change Insured' THEN 'Y' ELSE 'N' END
			--FROM @endos e
			FROM endos e
				--INNER JOIN @policy p  ON e.pol_yr = p.pol_yr AND e.pol_br = p.pol_br AND e.app_pre = p.pol_pre AND e.pol_no = p.pol_no
				INNER JOIN policy p ON e.pol_yr = p.pol_yr AND e.pol_br = p.pol_br AND e.app_pre = p.pol_pre AND e.pol_no = p.pol_no and p.pol_pre in ('523','560','580','581','582','587','588')	
				INNER JOIN endos_detail  ed (NOLOCK) ON e.app_yr = ed.app_yr AND e.app_br = ed.app_br AND e.app_pre = ed.app_pre AND e.app_no = ed.app_no AND  ed.seq_no IN (SELECT min(seq_no) FROM endos_detail WHERE e.app_yr = app_yr AND e.app_br = app_br AND  e.app_pre = app_pre AND e.app_no = app_no)
				INNER JOIN centerdb..endos_type et ON e.app_pre = et.class_code+et.subclass_code and e.endos_group = et.endos_group				
				INNER JOIN pol_insured ins ON e.pol_yr = ins.pol_yr AND e.app_br = ins.pol_br AND e.app_pre = ins.pol_pre AND e.pol_no = ins.pol_no 
											AND
											(( e.flag_group = 'G' AND  ins.ins_seq in (SELECT ins_seq FROM endos_insured WHERE endos_insured.app_yr = e.app_yr AND endos_insured.app_br = e.app_br AND endos_insured.app_pre = e.app_pre AND endos_insured.app_no = e.app_no))
												OR
												(ISNULL(e.flag_group,'I') ='I' AND ins.ins_seq in (SELECT ins_seq FROM pol_insured WHERE pol_insured.pol_yr = e.pol_yr AND pol_insured.pol_br = e.app_br AND pol_insured.pol_pre = e.app_pre AND pol_insured.pol_no = e.pol_no))
												OR
												(ins.ins_seq in (SELECT ins_seq FROM pol_insured WHERE pol_insured.pol_yr = e.pol_yr AND pol_insured.pol_br = e.app_br AND pol_insured.pol_pre = e.app_pre AND pol_insured.pol_no = e.pol_no AND e.endos_group in ('3','4') ))
											)
				INNER JOIN pol_cover_insurance cov ON ins.pol_yr = cov.pol_yr AND ins.pol_br = cov.pol_br AND ins.pol_pre = cov.pol_pre AND ins.pol_no = cov.pol_no AND ins.ins_seq =  cov.ins_seq 
				INNER JOIN product_insurance pri ON pri.class_code + pri.subclass_code = p.pol_pre AND pri.product_code = p.product_code 
				INNER JOIN product_insurance_plan prd ON prd.class_code = pri.class_code AND prd.subclass_code = pri.subclass_code AND prd.product_code = pri.product_code AND prd.plan_seq = cov.plan_seq
				LEFT JOIN centerdb.dbo.prefix prf  ON ins.ins_prefix = prf.prefix_code
				LEFT JOIN vIState st ON ins.Ins_province = st.state_code AND ins.Ins_amphur = st.city_code AND ins.Ins_country = st.country_code
		    WHERE e.app_pre in ('523','543','544','545','581','582','587','588','601','602','574','573','578')
			AND e.approve_datetime >= @Start_Date 
			AND e.approve_datetime < @date
	) AS Temp_TPA_Daily

--- test ----------
--print 'T5 :'+ CONVERT(VARCHAR,getdate())
------------------------------
	UPDATE @Temp_TPA_Daily SET [Plan] = plan_name_eng
	WHERE pol_pre in ('523','543','544','545','581','582','587','588','601','602','574','573','578')

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-523-AIS-' + product_code
	WHERE pol_pre = '523'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-581-LS-' + product_code
	WHERE pol_pre = '581' --AND product_code not in ('0016','0017')

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-581-TQM-' + product_code
	WHERE pol_pre = '581' AND product_code in ('0016','0017')

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-581-LS-0001' --+ product_code
	WHERE pol_pre = '581' AND product_code = '0012'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-581-LS-0002' --+ product_code
	WHERE pol_pre = '581' AND product_code = '0013'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-581-LS-0005' --+ product_code
	WHERE pol_pre = '581' AND product_code = '0014'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-581-LS-0006' --+ product_code
	WHERE pol_pre = '581' AND product_code = '0015'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-580-อุ่นใจรักษ์ (Tele)'
	WHERE pol_pre = '580' 

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-582-LS(Tele)-'+ product_code
	WHERE pol_pre = '582'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-560-LongStay'
	WHERE pol_pre = '560'

	UPDATE @Temp_TPA_Daily SET [Plan] = 'PLAN 1'
	WHERE pol_pre = '560'
	-- กลับไปใช้ CompanyName เดิมคือ VIB
	--UPDATE @Temp_TPA_Daily SET CompanyName = 'กรมธรรม์ประกันภัยอุบัติเหตุและสุขภาพส่วนบุคคล (Long Stay Visa) 560'
	--WHERE pol_pre = '560'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-587-LS-0001'
	WHERE pol_pre = '587' AND product_code in ('0001','0004') AND [Plan] = 'BDMS LSPY 0001'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-587-LS-0002' 
	WHERE pol_pre = '587' AND product_code in ('0002','0005') AND [Plan] = 'BDMS LSPY 0002'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-587-LS-0003' 
	WHERE pol_pre = '587' AND product_code in ('0003','0006') AND [Plan] = 'BDMS LSPY 0003'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-587-LS-0009' 
	WHERE pol_pre = '587' AND product_code in ('0009') AND [Plan] = 'BDMS LSPY 0001'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-587-LS-0010' 
	WHERE pol_pre = '587' AND product_code in ('0010') AND [Plan] = 'BDMS LSPY 0002'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-587-LS-0011' 
	WHERE pol_pre = '587' AND product_code in ('0011') AND [Plan] = 'BDMS LSPY 0003'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-588-LS-0001'
	WHERE pol_pre = '588' AND product_code in ('0001','0004') AND [Plan] = 'BDMS LSPY 0001'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-588-LS-0002' 
	WHERE pol_pre = '588' AND product_code in ('0002','0005') AND [Plan] = 'BDMS LSPY 0002'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-588-LS-0003' 
	WHERE pol_pre = '588' AND product_code in ('0003','0006') AND [Plan] = 'BDMS LSPY 0003'

	-- EXPORTPOL-259 ตรวจสอบการนำส่ง Text File ของแผน BCH 581/582/587/588 ไม่ส่งข้อมูล Policy No
	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-581-LS-0025'
	WHERE pol_pre = '581' AND product_code = '0025'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-582-LS-0029'
	WHERE pol_pre = '582' AND product_code = '0029'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-587-LS-0008'
	WHERE pol_pre = '587' AND product_code = '0008'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-588-LS-0007'
	WHERE pol_pre = '588' AND product_code = '0007'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-'+ pol_pre +'-NHS-' + product_code
	WHERE pol_pre in ('601','602')

	--#########UPDATE for TPA ปรับความคุ้มครอง หมวด 10,11 จากวงเงินเป็นจ่ายตามจริง วันที่ 20/06/2566 ทำให้ต้องแยก policy ที่ issue ออกก่อนและหลัง #######

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-'+ pol_pre +'-NHS-' + product_code + '-S1'
	WHERE pol_pre in ('601','602') and  CONVERT(DATETIME,LifePolicyIssueDate,103) >= '2023-06-20'
	--###############################################################################################################################



	-- INC0004497	
	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-581-LS-' + product_code
	WHERE pol_pre = '581' AND product_code in ('0034','0035','0036','0037','0038','0039','0040','0041','0042','0043','0044','0045')

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-582-LS-' + product_code
	WHERE pol_pre = '582' AND product_code in ('0038','0039','0040','0041','0042','0043' ,'0044','0045')

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-587-LS-' + product_code
	WHERE pol_pre = '587' AND product_code in ('0012','0013','0014' ,'0015' ,'0016' ,'0017','0018','0019','0020')

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-588-LS-' + product_code
	WHERE pol_pre = '588' AND product_code in ('0011','0012','0013','0014','0015' ,'0016' ,'0017')

	-- # 8 add query update 17/01/66 policy 573
	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-573-' + pol_yr+pol_br+'/POL/'+pol_no+'-'+pol_pre
	WHERE pol_pre = '573'

	-- # 7 add query update policy 574
	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-574-' + pol_yr+pol_br+'/POL/'+pol_no+'-'+pol_pre
	WHERE pol_pre = '574'

	-- # 9 add query update 17/01/66 policy 578
	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-578-' + pol_yr+pol_br+'/POL/'+pol_no+'-'+pol_pre
	WHERE pol_pre = '578'


	-- add new subclass 543,544,545
	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-'+pol_pre+'-Cancer-' + product_code
	WHERE pol_pre in ('543','544','545') AND product_code in ('0001','0002','0003')

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-587-LS-0012' , [Plan] = 'BDMS LSPY 0001'
	WHERE pol_pre = '587' AND product_code = '0012'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-587-LS-0013' , [Plan] = 'BDMS LSPY 0002'
	WHERE pol_pre = '587' AND product_code = '0013'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-587-LS-0014' , [Plan] = 'BDMS LSPY 0003'
	WHERE pol_pre = '587' AND product_code = '0014'

	/*--แก้ไข 588 31-10-2022
	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-588-LS-' + product_code , [Plan] = 'BDMS LSPY ' + product_code
	WHERE pol_pre = '588' AND product_code in ('0009','0010','0011')
	*/

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-588-LS-0009' , [Plan] = 'BDMS LSPY 0001'
	WHERE pol_pre = '588' AND product_code = '0009'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-588-LS-0010' , [Plan] = 'BDMS LSPY 0002'
	WHERE pol_pre = '588' AND product_code = '0010'

	UPDATE @Temp_TPA_Daily SET PolicyNumber = 'VIB-588-LS-0011' , [Plan] = 'BDMS LSPY 0003'
	WHERE pol_pre = '588' AND product_code = '0011'

	-- #8
	--====================== For Mapping Policy & Endos from VIS ====================== -- 
	
	-- Update MemberCode by Policy number and ins_seq and flag active
	UPDATE temp
	SET  MemberCode = CASE WHEN tpaMap.MemberCode IS NULL or temp.flag_endoscode = 'Y' THEN temp.MemberCode
		ELSE tpaMap.MemberCode END
	FROM @Temp_TPA_Daily temp 
	INNER JOIN [dbo].[TPA_Mapping_VIS] tpaMap on temp.pol_yr = tpaMap.pol_yr
									and temp.pol_br = tpaMap.pol_br
									and temp.pol_no = tpaMap.pol_no
									and temp.pol_pre = tpaMap.pol_pre
									and temp.ins_seq = tpaMap.ins_seq
									and tpaMap.FlagActive = 1
	UPDATE tpaMap
	SET  MemberCode = CASE WHEN tpaMap.MemberCode IS NULL or temp.flag_endoscode = 'Y' THEN temp.MemberCode
		ELSE tpaMap.MemberCode END
	FROM @Temp_TPA_Daily temp 
	INNER JOIN [dbo].[TPA_Mapping_VIS] tpaMap on temp.pol_yr = tpaMap.pol_yr
									and temp.pol_br = tpaMap.pol_br
									and temp.pol_no = tpaMap.pol_no
									and temp.pol_pre = tpaMap.pol_pre
									and temp.ins_seq = tpaMap.ins_seq
									and tpaMap.FlagActive = 1

	/*
	SELECT tpaMap.MemberCode ,temp.MemberCode FROM @Temp_TPA_Daily temp 
		INNER JOIN @TPA_Mapping_VIS tpaMap on temp.pol_yr = tpaMap.pol_yr
										and temp.pol_br = tpaMap.pol_br
										and temp.pol_no = tpaMap.pol_no
										and temp.pol_pre = tpaMap.pol_pre
										and temp.ins_seq = tpaMap.ins_seq
	--	where temp.pol_pre in ('573','574','578','579')

	SELECT tpaMap.MemberCode ,temp.MemberCode FROM @Temp_TPA_Daily temp 
		LEFT JOIN @TPA_Mapping_VIS tpaMap on temp.pol_yr = tpaMap.pol_yr
										and temp.pol_br = tpaMap.pol_br
										and temp.pol_no = tpaMap.pol_no
										and temp.pol_pre = tpaMap.pol_pre
										and temp.ins_seq = tpaMap.ins_seq
	where tpaMap.MemberCode is null
	*/
	
	-- If exists membercode (VIS) and Citizenid not the same and temp.CitizenId (Data new) not null
	-- insert to table TPA_MAPPING_VIS
	IF EXISTS(SELECT tpaMap.MemberCode ,temp.MemberCode , temp.CitizenId ,tpaMap.CitizenId 
		FROM @Temp_TPA_Daily temp 
		LEFT JOIN @TPA_Mapping_VIS tpaMap on temp.pol_yr = tpaMap.pol_yr
											and temp.pol_br = tpaMap.pol_br
											and temp.pol_no = tpaMap.pol_no
											and temp.pol_pre = tpaMap.pol_pre
											and temp.ins_seq = tpaMap.ins_seq
											and tpaMap.FlagActive = 1
		WHERE (len(tpaMap.MemberCode) = 56 and (temp.CitizenId <> tpaMap.CitizenId) and (DATALENGTH(temp.CitizenId) > 0)))
	BEGIN
		INSERT INTO [miscwebdb]..[TPA_Mapping_VIS] (pol_yr, pol_br,pol_pre,pol_no,ins_seq,MemberCode,InsuredName,CitizenId,InsertDate,ModifiedDate,FlagActive)
		SELECT distinct temp.pol_yr
				,temp.pol_br
				,temp.pol_pre
				,temp.pol_no
				,temp.ins_seq
				,tpaMap.MemberCode
				,temp.ContactPersonName
				,temp.CitizenId
				,GETDATE()
				,GETDATE()
				,1
		FROM @Temp_TPA_Daily temp 
		LEFT JOIN @TPA_Mapping_VIS tpaMap on temp.pol_yr = tpaMap.pol_yr
										and temp.pol_br = tpaMap.pol_br
										and temp.pol_no = tpaMap.pol_no
										and temp.pol_pre = tpaMap.pol_pre
										and temp.ins_seq = tpaMap.ins_seq
										and tpaMap.FlagActive = 1
		WHERE (len(tpaMap.MemberCode) = 56 and (temp.CitizenId <> tpaMap.CitizenId) and (DATALENGTH(temp.CitizenId) > 0))
	END

	-- # If tpaMap.MemberCode (in table mapping) ,  temp.MemberCode , temp.CitizenId <> tpaMap.CitizenId (CitizenId change)
	-- len(tpaMap.MemberCode) < 56 == policynumber + guid (membercode in vis)
	-- insert new record and update flag = 0 (not use) original record in TPA_MAPPING_VIS

	IF EXISTS(SELECT tpaMap.MemberCode ,temp.MemberCode , temp.CitizenId ,tpaMap.CitizenId 
		FROM @Temp_TPA_Daily temp 
		LEFT JOIN @TPA_Mapping_VIS tpaMap on temp.pol_yr = tpaMap.pol_yr
											and temp.pol_br = tpaMap.pol_br
											and temp.pol_no = tpaMap.pol_no
											and temp.pol_pre = tpaMap.pol_pre
											and temp.ins_seq = tpaMap.ins_seq
											and tpaMap.FlagActive = 1
		WHERE (len(tpaMap.MemberCode) < 56 and (temp.CitizenId <> tpaMap.CitizenId) and (DATALENGTH(temp.CitizenId) > 0)))
	BEGIN
			INSERT INTO [miscwebdb]..[TPA_Mapping_VIS] (pol_yr, pol_br,pol_pre,pol_no,ins_seq,MemberCode,InsuredName,CitizenId,InsertDate,ModifiedDate,FlagActive)
			SELECT distinct temp.pol_yr
					,temp.pol_br
					,temp.pol_pre
					,temp.pol_no
					,temp.ins_seq
					,temp.pol_yr+temp.pol_br+'/POL/'+temp.pol_no+'-'+temp.pol_pre+temp.CitizenId
					,temp.ContactPersonName
					,temp.CitizenId
					,GETDATE()
					,GETDATE()
					,1
			FROM @Temp_TPA_Daily temp 
			LEFT JOIN @TPA_Mapping_VIS tpaMap on temp.pol_yr = tpaMap.pol_yr
											and temp.pol_br = tpaMap.pol_br
											and temp.pol_no = tpaMap.pol_no
											and temp.pol_pre = tpaMap.pol_pre
											and temp.ins_seq = tpaMap.ins_seq
											and tpaMap.FlagActive = 1
			WHERE (len(tpaMap.MemberCode) < 56 and (temp.CitizenId <> tpaMap.CitizenId)  and (DATALENGTH(temp.CitizenId) > 0))

			update tpaMap
			set FlagActive = 0 
			--select tpaMap.*
			from @Temp_TPA_Daily temp 
			LEFT JOIN [dbo].[TPA_Mapping_VIS] tpaMap on temp.pol_yr = tpaMap.pol_yr
											and temp.pol_br = tpaMap.pol_br
											and temp.pol_no = tpaMap.pol_no
											and temp.pol_pre = tpaMap.pol_pre
											and temp.ins_seq = tpaMap.ins_seq
											and tpaMap.FlagActive = 1
			WHERE (len(tpaMap.MemberCode) < 56 and (temp.CitizenId <> tpaMap.CitizenId) and (DATALENGTH(temp.CitizenId) > 0))

	END

	IF EXISTS(SELECT tpaMap.MemberCode FROM @Temp_TPA_Daily temp 
		LEFT JOIN @TPA_Mapping_VIS tpaMap ON temp.pol_yr = tpaMap.pol_yr
										AND temp.pol_br = tpaMap.pol_br
										AND temp.pol_no = tpaMap.pol_no
										AND temp.pol_pre = tpaMap.pol_pre
										AND temp.ins_seq = tpaMap.ins_seq
										AND tpaMap.FlagActive = 1
		WHERE tpaMap.MemberCode is null)
	BEGIN
		INSERT INTO [miscwebdb]..[TPA_Mapping_VIS] (pol_yr, pol_br,pol_pre,pol_no,ins_seq,MemberCode,InsuredName,CitizenId,InsertDate,ModifiedDate,FlagActive)
		SELECT distinct temp.pol_yr
			 ,temp.pol_br
			 ,temp.pol_pre
			 ,temp.pol_no
			 ,temp.ins_seq
			 ,temp.MemberCode
			 ,temp.ContactPersonName
			 ,temp.CitizenId
			 ,GETDATE()
			 ,GETDATE()
			 ,1
		FROM @Temp_TPA_Daily temp 
		LEFT JOIN @TPA_Mapping_VIS tpaMap ON temp.pol_yr = tpaMap.pol_yr
										AND temp.pol_br = tpaMap.pol_br
										AND temp.pol_no = tpaMap.pol_no
										AND temp.pol_pre = tpaMap.pol_pre
										AND temp.ins_seq = tpaMap.ins_seq
										AND tpaMap.FlagActive = 1
		WHERE tpaMap.MemberCode IS NULL
	END

	--====================== For Policy & Endos from VIS ====================== -- 

----- test ----------
--print 'T6 :'+ CONVERT(VARCHAR,getdate())
------------------------------
/*	====================== Update Policy Year ====================--
	 เนื่องจาก column renew_seq ไม่ได้เก็บข้อมูลจำนวนครั้งของการทำ renew แต่เป็นการเก็บจำนวนครั้งของการทำสลักหลังขยายความคุ้มครอง
	 จึงไม่สามารถหยิบ column renew_seq มาใช้ได้เลย ต้องวนหา policy ก่อนหน้าที่ถูกนำมาทำ renew
 
	DECLARE @ReferencePolicy TABLE
	(
		pol_yr CHAR(2),
		pol_br CHAR(3),
		pol_pre CHAR(3),
		pol_no CHAR(6),
		ref_yr CHAR(2),
		ref_no CHAR(6)
	)
	DECLARE @TPAPolicy TABLE
	(
		pol_yr CHAR(2),
		pol_br CHAR(3),
		pol_pre CHAR(3),
		pol_no CHAR(6)
	)

	INSERT INTO @ReferencePolicy 
	SELECT DISTINCT
		pol_yr 
		,pol_br 
		,pol_pre
		,pol_no 
		,ref_yr 
		,ref_no 
	FROM [policy]
	WHERE pol_pre IN ('523','560','580','581','582','587','588')

- test ----------
--print 'T7 :'+ CONVERT(VARCHAR,getdate())
------------------------------

	INSERT INTO @TPAPolicy 
	SELECT DISTINCT
		 t.pol_yr 
		,t.pol_br 
		,t.pol_pre
		,t.pol_no 
	FROM @Temp_TPA_Daily t
	INNER JOIN @policy p ON 
		t.pol_yr = p.pol_yr 
		AND t.pol_br = p.pol_br 
		AND t.pol_pre = p.pol_pre 
		AND t.pol_no = p.pol_no
	WHERE p.ref_type = '4'
	--AND t.CertificateNo = '20181/POL/000130-581'

--- test ----------
--print 'T8 :'+ CONVERT(VARCHAR,getdate())
------------------------------
	DECLARE 
		@current_pol_yr CHAR(2)
		,@current_pol_br CHAR(3)
		,@current_pol_pre CHAR(3)
		,@current_pol_no CHAR(6)
		,@renew_pol_yr CHAR(2)
		,@renew_pol_br CHAR(3)
		,@renew_pol_pre CHAR(3)
		,@renew_pol_no CHAR(6)

	--DECLARE tpa_cursor CURSOR FOR   
	--SELECT 
	--	 pol_yr 
	--	,pol_br 
	--	,pol_pre
	--	,pol_no 
	--FROM @TPAPolicy 

    DECLARE tpa_cursor CURSOR FOR  
    SELECT t.pol_yr 
		  ,t.pol_br 
		  ,t.pol_pre
		  ,t.pol_no 
	FROM @Temp_TPA_Daily t
		,policy p 
	where t.pol_yr = p.pol_yr 
	AND t.pol_br = p.pol_br 
	AND t.pol_pre = p.pol_pre 
	AND t.pol_no = p.pol_no
	AND p.ref_type = '4'
	and p.ref_no is not null
	group by t.pol_yr 
			,t.pol_br 
			,t.pol_pre
			,t.pol_no

	OPEN tpa_cursor  
  
	FETCH NEXT FROM tpa_cursor   
	INTO 
	  @current_pol_yr 
	  ,@current_pol_br 
	  ,@current_pol_pre
	  ,@current_pol_no 
	WHILE @@FETCH_STATUS = 0  
	BEGIN

			DECLARE @CountRenew INT
			SET @CountRenew = 1
			SET @renew_pol_yr = @current_pol_yr
			SET @renew_pol_no = @current_pol_no

			WHILE(1=1)
			BEGIN
				SELECT 
					@CountRenew = @CountRenew + 1
					,@renew_pol_yr = p.ref_yr
					,@renew_pol_no = p.ref_no
				FROM policy p
				WHERE p.pol_yr = @renew_pol_yr
				AND p.pol_br = @current_pol_br
				AND p.pol_pre = @current_pol_pre
				AND p.pol_no = @renew_pol_no
				IF ISNULL(@renew_pol_no,'') = ''
				BREAK;
			END

			--BEGIN TRANSACTION Inner1;
			--UPDATE @Temp_TPA_Daily
			--SET PolicyYear = CAST(@CountRenew AS VARCHAR) 
			--WHERE pol_yr = @current_pol_yr
			--	AND pol_br = @current_pol_br
			--	AND pol_pre = @current_pol_pre
			--	AND pol_no = @current_pol_no
   --         IF @@ERROR <> 0   
			--rollback TRANSACTION Inner1;
   --         else
		 --   commit TRANSACTION Inner1;

			FETCH NEXT FROM tpa_cursor   
			INTO 
			  @current_pol_yr 
			  ,@current_pol_br 
			  ,@current_pol_pre
			  ,@current_pol_no 

	END
	CLOSE tpa_cursor;  
	DEALLOCATE tpa_cursor; 

--- test ----------
--print 'T9 :'+ CONVERT(VARCHAR,getdate())
*/
------------------------------

	SELECT 
		t.CompanyName
		,t.MemberCode					
		,t.Title						
		,t.NameThai					
		,t.SurnameThai				
		,t.NameEng					
		,t.SurnameEng					
		,t.MemberType					
		,t.PrincipleReferenceNumber	
		,t.Gender						
		,t.MaritalStatus				
		,t.Nationality				
		,t.CitizenId					
		,t.OtherId					
		,t.DateOfBirth				
		,t.Age						
		,t.BuildingNo					
		,t.VillageNo					
		,t.LaneAlley					
		,t.Road						
		,t.SubDistrict				
		,t.District					
		,t.Province					
		,t.PostCode					
		,t.Country					
		,t.ContactPersonName			
		,t.OfficeTelNo				
		,t.HomeTelNo					
		,t.MobileNo					
		,t.Email						
		,t.FaxNo						
		,t.StaffNo					
		,t.JoinDate					
		,t.EmploymentDate				
		,t.PolicyNumber				
		,t.ApplicationNumber			
		,t.CertificateNo				
		,t.InsurerCardNo				
		,t.InsurerPreviousCardNo		
		,t.PolicyYear					
		,t.LifePolicyIssueDate		
		,t.LifePolicyValidityDate		
		,t.LifePolicyContractDate		
		,t.[Plan]						
		,t.PlanIssueDate				
		,t.PlanContractDate			
		,t.PlanEffectiveFromDate		
		,t.PlanEffectiveToDate		
		,t.PlanPaidDate				
		,t.PlanPaidToDate				
		,t.PlanNextDueDate			
		,t.PlanTerminateDate			
		,t.PlanReinstatementDate		
		,t.PlanSuspensionDate			
		,t.PlanSuspensionToDate		
		,t.Rider						
		,t.RiderIssueDate				
		,t.RiderContractDate			
		,t.RiderEffectiveFromDate		
		,t.RiderEffectiveToDate		
		,t.RiderPaidDate				
		,t.RiderPaidToDate			
		,t.RiderNextDueDate			
		,t.RiderTerminateDate			
		,t.RiderReinstatementDate		
		,t.RiderSuspensionDate		
		,t.ConditionDetail			
		,t.BankCode					
		,t.BankAccountNo				
		,t.PayeeName					
		,t.PayeeCitizenId				
		,t.Bu							
		,t.Branch						
		,t.CostCenter					
		,t.AgentCode					
		,t.AgentLeaderCode			
		,t.[Broker]					
		,t.Vip						
		,t.PremiumFrequency			
		,t.MemberPremium				
		,t.PremiumIpd					
		,t.PremiumOpd					
		,t.SumInsured					
		,t.SocialSecurityHospital		
		,t.Remark1					
		,t.Remark2					
		,t.Remark3					
		,t.Remark4					
		,t.Remark5					
		,t.Remark6					
		,t.Remark7					
		,t.Remark8					
		,t.Remark9					
		,t.Remark10					
		,t.Transtype					
		,t.Reason
		,t.IsEndorse
		,t.CreateDate							
	FROM @Temp_TPA_Daily as t
	ORDER BY Transtype DESC , MemberCode ASC

--- test ----------
---print 'T10 :'+ CONVERT(VARCHAR,getdate())
------------------------------
END



