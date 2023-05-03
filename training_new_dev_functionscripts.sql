"pg_get_functiondef"
"CREATE OR REPLACE FUNCTION public.dump(p_schema text, p_table text, p_where text)
 RETURNS SETOF text
 LANGUAGE plpgsql
AS $function$
 DECLARE
     dumpquery_0 text;
     dumpquery_1 text;
     selquery text;
     selvalue text;
     valrec record;
     colrec record;
 BEGIN

     -- ------ --
     -- GLOBAL --
     --   build base INSERT
     --   build SELECT array[ ... ]
     dumpquery_0 := 'INSERT INTO ' ||  quote_ident(p_schema) || '.' || quote_ident(p_table) || '(';
     selquery    := 'SELECT array[';

     <<label0>>
     FOR colrec IN SELECT table_schema, table_name, column_name, data_type
                   FROM information_schema.columns
                   WHERE table_name = p_table and table_schema = p_schema
                   ORDER BY ordinal_position
     LOOP
         dumpquery_0 := dumpquery_0 || quote_ident(colrec.column_name) || ',';
         selquery    := selquery    || 'CAST(' || quote_ident(colrec.column_name) || ' AS TEXT),';
     END LOOP label0;

     dumpquery_0 := substring(dumpquery_0 ,1,length(dumpquery_0)-1) || ')';
     dumpquery_0 := dumpquery_0 || ' VALUES (';
     selquery    := substring(selquery    ,1,length(selquery)-1)    || '] AS MYARRAY';
     selquery    := selquery    || ' FROM ' ||quote_ident(p_schema)||'.'||quote_ident(p_table);
     selquery    := selquery    || ' WHERE '||p_where;
     -- GLOBAL --
     -- ------ --

     -- ----------- --
     -- SELECT LOOP --
     --   execute SELECT built and loop on each row
     <<label1>>
     FOR valrec IN  EXECUTE  selquery
     LOOP
         dumpquery_1 := '';
         IF not found THEN
             EXIT ;
         END IF;

         -- ----------- --
         -- LOOP ARRAY (EACH FIELDS) --
         <<label2>>
         FOREACH selvalue in ARRAY valrec.MYARRAY
         LOOP
             IF selvalue IS NULL
             THEN selvalue := 'NULL';
             ELSE selvalue := quote_literal(selvalue);
             END IF;
             dumpquery_1 := dumpquery_1 || selvalue || ',';
         END LOOP label2;
         dumpquery_1 := substring(dumpquery_1 ,1,length(dumpquery_1)-1) || ');';
         -- LOOP ARRAY (EACH FIELD) --
         -- ----------- --

         -- debug: RETURN NEXT dumpquery_0 || dumpquery_1 || ' --' || selquery;
         -- debug: RETURN NEXT selquery;
         RETURN NEXT dumpquery_0 || dumpquery_1;

     END LOOP label1 ;
     -- SELECT LOOP --
     -- ----------- --

 RETURN ;
 END
 
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_activitylevelcode(_activity_ref_id udd_code)
 RETURNS udd_code
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_level_code public.udd_code := '';
	v_activity_code udd_code := '';
BEGIN
	select activity_code into v_activity_code
	from   trng_mst_tnote
	where  activity_ref_id = _activity_ref_id;

	if v_activity_code = 'QCD_COURSE' 
	then
		select user_level_code into v_level_code 
		from   		trng_mst_tcourse as c
		inner join  core_mst_tuser as u
		on          c.created_by = u.user_code 
		where 	c.course_id = _activity_ref_id
		and     c.status_code <> 'I';
		
	elseif v_activity_code = 'QCD_TRNG_PROGRAM' 
	then
		select user_level_code into v_level_code 
		from   		trng_trn_ttprogram as p
		inner join  core_mst_tuser as u
		on          p.created_by = u.user_code 
		where 	p.tprogram_id = _activity_ref_id
		and     p.status_code <> 'I';
	end if;
	
	v_level_code = coalesce(v_level_code,'');
	return v_level_code;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_bankacclength(_bank_code udd_code, _bankacc_no udd_code)
 RETURNS udd_boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_bool udd_boolean := false;
	v_bank_account_len udd_code := '';
	v_bankacc_no_leng udd_code := '';
	v_pgbankaccno_max_count udd_int := 0;
	v_bankacc_no udd_int := 0;
BEGIN
	-- bank accno less than 20 validation
	select 	config_value  into v_pgbankaccno_max_count
	from 	core_mst_tconfig 
	where 	config_name = 'pgbankaccno_max_count'
	and 	status_code = 'A';
	
	select  bank_account_len into v_bank_account_len
	from 	bank_master
	where 	bank_code = _bank_code
	and 	is_active = 1;
	
	if v_bank_account_len = 'NULL' then
		v_bank_account_len := null;
	end if ;
	
	v_bank_account_len = coalesce(v_bank_account_len,'');
	v_bank_account_len = '{' || v_bank_account_len || '}';
	
	select length(_bankacc_no)::udd_code into v_bankacc_no_leng;
	select length(_bankacc_no) into v_bankacc_no;
	
	if v_bank_account_len <> '0' and v_bank_account_len <> '{}' then
			return (select v_bankacc_no_leng::text=ANY(v_bank_account_len::text[]));
		else if v_bankacc_no >= v_pgbankaccno_max_count then
			v_bool := true;
		else
			v_bool := false;
		end if;
	end if;
	
	return v_bool;
	
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_bankacclength(_bank_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_bank_account_len public.udd_text := '';
BEGIN
	select bank_account_len into v_bank_account_len
	from 	bank_master
	where 	bank_code = _bank_code
	and 	is_active = 1;
	
	v_bank_account_len = coalesce(v_bank_account_len,'20');
	return v_bank_account_len;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_bankbranchname(_bank_code udd_code, _bank_branch_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_bank_branch_name public.udd_text := '';
BEGIN
	select bank_branch_name into v_bank_branch_name
	from 		bank_branch_master
	where 	bank_code = _bank_code
	and     bank_branch_code::udd_code = _bank_branch_code
	and 	is_active = true;
	
	v_bank_branch_name = coalesce(v_bank_branch_name,'');
	return v_bank_branch_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_bankifsccode(_bank_code udd_code, _bank_branch_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_ifsc_code public.udd_text := '';
BEGIN
	select ifsc_code into v_ifsc_code
	from 		bank_branch_master
	where 	bank_code = _bank_code
	and     bank_branch_code::udd_code = _bank_branch_code
	and 	is_active = true;
	
	v_ifsc_code = coalesce(v_ifsc_code,'');
	return v_ifsc_code;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_bankname(_bank_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_bank_name public.udd_text := '';
BEGIN
	select bank_name into v_bank_name 
	from 		bank_master
	where 	bank_code = _bank_code
	and 	is_active = 1;
	
	v_bank_name = coalesce(v_bank_name,'');
	return v_bank_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_batchenddate(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_date
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 15-12-2022
	*/
	
	v_batch_date udd_date := null;
BEGIN
	select  end_date into v_batch_date
	from   	trng_trn_ttprogrambatch
	where 	tprogram_id 	= _tprogram_id
	and     tprogrambatch_id= _tprogrambatch_id
	and 	status_code 	<> 'I';
		
-- 	v_batch_date = coalesce(v_batch_date::udd_code,'');
	return v_batch_date;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_batchllname(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
	Created By  : Mangai
	Created Date : 09-02-2023
	*/
	v_batch_ll_name public.udd_text := '';
BEGIN 
	select batch_ll_name into v_batch_ll_name 
	from   trng_trn_ttprogrambatch
	where  tprogram_id = _tprogram_id
	and    tprogrambatch_id = _tprogrambatch_id;
	
	v_batch_ll_name = coalesce(v_batch_ll_name,'');
	return v_batch_ll_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_batchname(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 15-12-2022
	*/
	
	v_batch_name udd_desc := '';
BEGIN
	select  batch_name into v_batch_name
	from   	trng_trn_ttprogrambatch
	where 	tprogram_id 	= _tprogram_id
	and     tprogrambatch_id = _tprogrambatch_id
	and 	status_code not in ('I','L');
		
	v_batch_name = coalesce(v_batch_name,'');
	return v_batch_name;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_batchstartdate(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_date
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 15-12-2022
	*/
	
	v_batch_date udd_date := null;
BEGIN
	select  start_date into v_batch_date
	from   	trng_trn_ttprogrambatch
	where 	tprogram_id 	= _tprogram_id
	and     tprogrambatch_id= _tprogrambatch_id
	and 	status_code 	<> 'I';
		
-- 	v_batch_date = coalesce(v_batch_date::udd_code,'');
	return v_batch_date;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_block_ll_desc(_block_id udd_int, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		created date : 18-10-2022
	*/
	v_block_name_local public.udd_text := '';
	v_block_name_en public.udd_text := '';
BEGIN
	select  block_name_local,block_name_en 
	into 	v_block_name_local,v_block_name_en
	from   	block_master 
	where 	block_id = _block_id;
		
	if _lang_code = 'en_US' then
		v_block_name_en := coalesce(v_block_name_en,'');
		return v_block_name_en;
		
	else 
		v_block_name_local := coalesce(v_block_name_local,v_block_name_en);
		return v_block_name_local;
		
	end if;
	

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_blockdesc(_block_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_block_desc public.udd_text := '';
BEGIN
	select block_name_en into v_block_desc 
	from 		block_master
	where 	block_code = _block_code
	and 	is_active = true;
	
	v_block_desc = coalesce(v_block_desc,'');
	return v_block_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_blockdesc(_block_id udd_int)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_block_desc public.udd_text := '';
BEGIN
	select block_name_en into v_block_desc 
	from 		block_master
	where 	block_id = _block_id
	and 	is_active = true;
	
	v_block_desc = coalesce(v_block_desc,'');
	return v_block_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_blockid(_block_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_block_id public.udd_int := 0;
BEGIN
	select block_id into v_block_id 
	from 		block_master
	where 	block_code = _block_code
	and 	is_active = true;
	
	v_block_id = coalesce(v_block_id,0);
	return v_block_id;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_budgetamount(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_amount
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_budget_amount public.udd_amount := 0;
BEGIN
	select 	coalesce(sum(budget_amount),0) into v_budget_amount
	from 	trng_trn_ttprogrambudget
	where 	tprogram_id = _tprogram_id
	and   	tprogrambatch_id = _tprogrambatch_id
	and   	status_code = 'A';
	
-- 	v_budget_amount = coalesce(v_budget_amount,0);
	return v_budget_amount;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_cadreblockcount(_intuser_type_code udd_code, _tprogram_id udd_code, _resource_type udd_code, _c_role_code udd_code, _category udd_code, _vertical udd_code, _subvertical udd_code, _participant_name udd_desc, _state_id udd_int, _district_id udd_int, _block_id udd_int, _user_level_code udd_code, _shg_name udd_desc, _user_code udd_code, _role_code udd_code, _lang_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
	Created By   : Mangai
	Created Date : 28-12-2022
	*/

	v_count udd_int := 0;
	
	v_state_code udd_code := ''; 
	v_district_code udd_code := ''; 
	v_block_code udd_code := ''; 
	v_grampanchayat_code udd_code := ''; 
	v_village_code udd_code := ''; 
BEGIN
	-- Get tprogramgeo against tprogram_id 
	select 	state_code,district_code,block_code,grampanchayat_code,village_code
	into 	v_state_code,v_district_code,v_block_code,v_grampanchayat_code,v_village_code
	from 	trng_trn_ttprogramgeo
	where 	tprogram_id = _tprogram_id
	and 	status_code = 'A';
	
	select count(*) into v_count
	from   trng_mst_tcadreuser 
	where  cadreuser_name ilike _participant_name||'%' collate pg_catalog.""default""
	and    cadreuser_id not in (select participant_id from trng_trn_ttprogramparticipant
								where participant_type_code = 'QCD_INTERNAL'
								and participant_subtype_code = 'QCD_INT_CADRE'
								and tprogram_id = _tprogram_id
								and status_code = 'A')
	and    cadre_resource_type_code = 
	case 
		when _resource_type = '' or _resource_type isnull then
			coalesce(cadre_resource_type_code,_resource_type)
		else
			coalesce(_resource_type,cadre_resource_type_code)
	end
	and   cadre_role_code = 
	case 
		when    _c_role_code isnull or _c_role_code = ''  then 
				coalesce(cadre_role_code,_c_role_code)
		else 
				coalesce(_c_role_code,cadre_role_code) 
	end 
	and   cadre_cat_code = 
	case 
		when    _category isnull or _category = ''  then 
				coalesce(cadre_cat_code,_category)
		else 
				coalesce(_category,cadre_cat_code) 
	end 
	and  vertical_code = 
	case 
		when    _vertical isnull or _vertical = ''  then 
				coalesce(vertical_code,_vertical)
		else 
				coalesce(_vertical,vertical_code) 
	end 
	and  subvertical_code =
	case 
		when    _subvertical isnull or _subvertical = ''  then 
				coalesce(subvertical_code,_subvertical)
		else 
				coalesce(_subvertical,subvertical_code) 
	end 
	and addr_state_code =
	case 
		when	v_state_code = '' or v_state_code isnull then
				coalesce(addr_state_code,v_state_code)
		else 
				coalesce(v_state_code,addr_state_code)
	end
	and addr_district_code =
	case 
		when	v_district_code isnull or v_district_code = '' then
				coalesce(addr_district_code,v_district_code)
		else 
				coalesce(v_district_code,addr_district_code)
	end
	and addr_block_code =
	case 
		when	v_block_code isnull or v_block_code = '' then
				coalesce(addr_block_code,v_block_code)
		else 
				coalesce(v_block_code,addr_block_code)
	end
	and status_code = 'A';
	
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_cadredistrictcount(_intuser_type_code udd_code, _tprogram_id udd_code, _resource_type udd_code, _c_role_code udd_code, _category udd_code, _vertical udd_code, _subvertical udd_code, _participant_name udd_desc, _state_id udd_int, _district_id udd_int, _user_level_code udd_code, _shg_name udd_desc, _user_code udd_code, _role_code udd_code, _lang_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
	Created By   : Mangai
	Created Date : 28-12-2022
	*/

	v_count udd_int := 0;
	
	v_state_code udd_code := ''; 
	v_district_code udd_code := ''; 
	v_block_code udd_code := ''; 
	v_grampanchayat_code udd_code := ''; 
	v_village_code udd_code := ''; 
BEGIN
	-- Get tprogramgeo against tprogram_id 
	select 	state_code,district_code,block_code,grampanchayat_code,village_code
	into 	v_state_code,v_district_code,v_block_code,v_grampanchayat_code,v_village_code
	from 	trng_trn_ttprogramgeo
	where 	tprogram_id = _tprogram_id
	and 	status_code = 'A';
	
	select count(*) into v_count
	from   trng_mst_tcadreuser 
	where  cadreuser_name ilike _participant_name||'%' collate pg_catalog.""default""
	and    cadreuser_id not in (select participant_id from trng_trn_ttprogramparticipant
								where participant_type_code = 'QCD_INTERNAL'
								and participant_subtype_code = 'QCD_INT_CADRE'
								and tprogram_id = _tprogram_id
								and status_code = 'A')
	and    cadre_resource_type_code = 
	case 
		when _resource_type = '' or _resource_type isnull then
			coalesce(cadre_resource_type_code,_resource_type)
		else
			coalesce(_resource_type,cadre_resource_type_code)
	end
	and   cadre_role_code = 
	case 
		when    _c_role_code isnull or _c_role_code = ''  then 
				coalesce(cadre_role_code,_c_role_code)
		else 
				coalesce(_c_role_code,cadre_role_code) 
	end 
	and   cadre_cat_code = 
	case 
		when    _category isnull or _category = ''  then 
				coalesce(cadre_cat_code,_category)
		else 
				coalesce(_category,cadre_cat_code) 
	end 
	and  vertical_code = 
	case 
		when    _vertical isnull or _vertical = ''  then 
				coalesce(vertical_code,_vertical)
		else 
				coalesce(_vertical,vertical_code) 
	end 
	and  subvertical_code =
	case 
		when    _subvertical isnull or _subvertical = ''  then 
				coalesce(subvertical_code,_subvertical)
		else 
				coalesce(_subvertical,subvertical_code) 
	end 
	and addr_state_code =
	case 
		when	v_state_code = '' or v_state_code isnull then
				coalesce(addr_state_code,v_state_code)
		else 
				coalesce(v_state_code,addr_state_code)
	end
	and addr_district_code =
	case 
		when	v_district_code isnull or v_district_code = '' then
				coalesce(addr_district_code,v_district_code)
		else 
				coalesce(v_district_code,addr_district_code)
	end
	and status_code = 'A';
	
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_cadreid(vertical_code udd_code)
 RETURNS SETOF text
 LANGUAGE plpgsql
AS $function$
DECLARE _id trng_mst_ttrainer.cadre_id%TYPE;
BEGIN
	FOR _id IN	select Distinct
						cadre_id
				from 	trng_mst_ttrainer 
				where 	status_code = 'A'
	 LOOP
				RETURN NEXT _id;
	 END LOOP;
	 
   RETURN;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_cadrepanchayatcount(_intuser_type_code udd_code, _tprogram_id udd_code, _resource_type udd_code, _c_role_code udd_code, _category udd_code, _vertical udd_code, _subvertical udd_code, _participant_name udd_desc, _state_id udd_int, _district_id udd_int, _block_id udd_int, _panchayat_id udd_int, _user_level_code udd_code, _shg_name udd_desc, _user_code udd_code, _role_code udd_code, _lang_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
	Created By   : Mangai
	Created Date : 28-12-2022
	*/

	v_count udd_int := 0;
	
	v_state_code udd_code := ''; 
	v_district_code udd_code := ''; 
	v_block_code udd_code := ''; 
	v_grampanchayat_code udd_code := ''; 
	v_village_code udd_code := ''; 
BEGIN
	-- Get tprogramgeo against tprogram_id 
	select 	state_code,district_code,block_code,grampanchayat_code,village_code
	into 	v_state_code,v_district_code,v_block_code,v_grampanchayat_code,v_village_code
	from 	trng_trn_ttprogramgeo
	where 	tprogram_id = _tprogram_id
	and 	status_code = 'A';
	
	select count(*) into v_count
	from   trng_mst_tcadreuser 
	where  cadreuser_name ilike _participant_name||'%' collate pg_catalog.""default""
	and    cadreuser_id not in (select participant_id from trng_trn_ttprogramparticipant
								where participant_type_code = 'QCD_INTERNAL'
								and participant_subtype_code = 'QCD_INT_CADRE'
								and tprogram_id = _tprogram_id
								and status_code = 'A')
	and    cadre_resource_type_code = 
	case 
		when _resource_type = '' or _resource_type isnull then
			coalesce(cadre_resource_type_code,_resource_type)
		else
			coalesce(_resource_type,cadre_resource_type_code)
	end
	and   cadre_role_code = 
	case 
		when    _c_role_code isnull or _c_role_code = ''  then 
				coalesce(cadre_role_code,_c_role_code)
		else 
				coalesce(_c_role_code,cadre_role_code) 
	end 
	and   cadre_cat_code = 
	case 
		when    _category isnull or _category = ''  then 
				coalesce(cadre_cat_code,_category)
		else 
				coalesce(_category,cadre_cat_code) 
	end 
	and  vertical_code = 
	case 
		when    _vertical isnull or _vertical = ''  then 
				coalesce(vertical_code,_vertical)
		else 
				coalesce(_vertical,vertical_code) 
	end 
	and  subvertical_code =
	case 
		when    _subvertical isnull or _subvertical = ''  then 
				coalesce(subvertical_code,_subvertical)
		else 
				coalesce(_subvertical,subvertical_code) 
	end 
	and addr_state_code =
	case 
		when	v_state_code = '' or v_state_code isnull then
				coalesce(addr_state_code,v_state_code)
		else 
				coalesce(v_state_code,addr_state_code)
	end
	and addr_district_code =
	case 
		when	v_district_code isnull or v_district_code = '' then
				coalesce(addr_district_code,v_district_code)
		else 
				coalesce(v_district_code,addr_district_code)
	end
	and addr_block_code =
	case 
		when	v_block_code isnull or v_block_code = '' then
				coalesce(addr_block_code,v_block_code)
		else 
				coalesce(v_block_code,addr_block_code)
	end
	and addr_grampanchayat_code =
	case 
		when	v_grampanchayat_code isnull or v_grampanchayat_code = '' then
				coalesce(addr_grampanchayat_code,v_grampanchayat_code)
		else 
				coalesce(v_grampanchayat_code,addr_grampanchayat_code)
	end
	and status_code = 'A';
	
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_cadreresourcetypecode(_participant_id udd_code)
 RETURNS udd_code
 LANGUAGE plpgsql
AS $function$
declare
   /*
   created_by   :  Mangai
   created_date :  25-01-2023
   */
   v_cadreresourcetypecode udd_code := '';
begin   
   	 select cadre_resource_type_code into v_cadreresourcetypecode
	 from trng_mst_tcadreuser
	 where cadreuser_id = _participant_id;
	 
   v_cadreresourcetypecode = coalesce(v_cadreresourcetypecode,'');
   return v_cadreresourcetypecode;

end;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_cadreresourcetypedesc(_participant_id udd_code, _lang_code udd_code)
 RETURNS udd_desc
 LANGUAGE plpgsql
AS $function$
declare
   /*
   created_by   :  Mangai
   created_date :  25-01-2023
   */
   v_cadreresourcetypedesc udd_code := '';
   v_cadreresourcetypecode udd_code := '';
begin   
   	 select cadre_resource_type_code into v_cadreresourcetypecode
	 from trng_mst_tcadreuser
	 where cadreuser_id = _participant_id;
	 
	 v_cadreresourcetypedesc := (select fn_get_masterdesc('QCD_RESOURCE_TYPE',v_cadreresourcetypecode,_lang_code));
	 
   v_cadreresourcetypedesc = coalesce(v_cadreresourcetypedesc,'');
   return v_cadreresourcetypedesc;

end;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_cadrerolecode(_participant_id udd_code)
 RETURNS udd_code
 LANGUAGE plpgsql
AS $function$
declare
   /*
   created_by   :  Mangai
   created_date :  04-03-2023
   */
   v_cadre_role_code udd_code := '';
begin   
   	 select cadre_role_code into v_cadre_role_code
	 from trng_mst_tcadreuser
	 where cadreuser_id = _participant_id;
	 
   v_cadre_role_code = coalesce(v_cadre_role_code,'');
   return v_cadre_role_code;

end;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_cadresubverticalcode(_participant_id udd_code)
 RETURNS udd_code
 LANGUAGE plpgsql
AS $function$
declare
   /*
   created_by   :  Mangai
   created_date :  06-03-2023
   
   Version No : 1
   */
   v_cadresubverticalcode udd_code := '';
begin   
   	 select subvertical_code into v_cadresubverticalcode
	 from trng_mst_tcadreuser
	 where cadreuser_id = _participant_id;
	 
   v_cadresubverticalcode = coalesce(v_cadresubverticalcode,'');
   return v_cadresubverticalcode;

end;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_cadreverticalcode(_participant_id udd_code)
 RETURNS udd_code
 LANGUAGE plpgsql
AS $function$
declare
   /*
   created_by   :  Mangai
   created_date :  06-03-2023
   
   Version No : 1
   */
   v_cadreverticalcode udd_code := '';
begin   
   	 select vertical_code into v_cadreverticalcode
	 from trng_mst_tcadreuser
	 where cadreuser_id = _participant_id;
	 
   v_cadreverticalcode = coalesce(v_cadreverticalcode,'');
   return v_cadreverticalcode;

end;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_cadrevillagecount(_intuser_type_code udd_code, _tprogram_id udd_code, _resource_type udd_code, _c_role_code udd_code, _category udd_code, _vertical udd_code, _subvertical udd_code, _participant_name udd_desc, _state_id udd_int, _district_id udd_int, _block_id udd_int, _panchayat_id udd_int, _village_id udd_int, _user_level_code udd_code, _shg_name udd_desc, _user_code udd_code, _role_code udd_code, _lang_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
	Created By   : Mangai
	Created Date : 28-12-2022
	*/

	v_count udd_int := 0;
	
	v_state_code udd_code := ''; 
	v_district_code udd_code := ''; 
	v_block_code udd_code := ''; 
	v_grampanchayat_code udd_code := ''; 
	v_village_code udd_code := ''; 
BEGIN
	-- Get tprogramgeo against tprogram_id 
	select 	state_code,district_code,block_code,grampanchayat_code,village_code
	into 	v_state_code,v_district_code,v_block_code,v_grampanchayat_code,v_village_code
	from 	trng_trn_ttprogramgeo
	where 	tprogram_id = _tprogram_id
	and 	status_code = 'A';
	
	select count(*) into v_count
	from   trng_mst_tcadreuser 
	where  cadreuser_name ilike _participant_name||'%' collate pg_catalog.""default""
	and    cadreuser_id not in (select participant_id from trng_trn_ttprogramparticipant
								where participant_type_code = 'QCD_INTERNAL'
								and participant_subtype_code = 'QCD_INT_CADRE'
								and tprogram_id = _tprogram_id
								and status_code = 'A')
	and    cadre_resource_type_code = 
	case 
		when _resource_type = '' or _resource_type isnull then
			coalesce(cadre_resource_type_code,_resource_type)
		else
			coalesce(_resource_type,cadre_resource_type_code)
	end
	and   cadre_role_code = 
	case 
		when    _c_role_code isnull or _c_role_code = ''  then 
				coalesce(cadre_role_code,_c_role_code)
		else 
				coalesce(_c_role_code,cadre_role_code) 
	end 
	and   cadre_cat_code = 
	case 
		when    _category isnull or _category = ''  then 
				coalesce(cadre_cat_code,_category)
		else 
				coalesce(_category,cadre_cat_code) 
	end 
	and  vertical_code = 
	case 
		when    _vertical isnull or _vertical = ''  then 
				coalesce(vertical_code,_vertical)
		else 
				coalesce(_vertical,vertical_code) 
	end 
	and  subvertical_code =
	case 
		when    _subvertical isnull or _subvertical = ''  then 
				coalesce(subvertical_code,_subvertical)
		else 
				coalesce(_subvertical,subvertical_code) 
	end 
	and addr_state_code =
	case 
		when	v_state_code = '' or v_state_code isnull then
				coalesce(addr_state_code,v_state_code)
		else 
				coalesce(v_state_code,addr_state_code)
	end
	and addr_district_code =
	case 
		when	v_district_code isnull or v_district_code = '' then
				coalesce(addr_district_code,v_district_code)
		else 
				coalesce(v_district_code,addr_district_code)
	end
	and addr_block_code =
	case 
		when	v_block_code isnull or v_block_code = '' then
				coalesce(addr_block_code,v_block_code)
		else 
				coalesce(v_block_code,addr_block_code)
	end
	and addr_grampanchayat_code =
	case 
		when	v_grampanchayat_code isnull or v_grampanchayat_code = '' then
				coalesce(addr_grampanchayat_code,v_grampanchayat_code)
		else 
				coalesce(v_grampanchayat_code,addr_grampanchayat_code)
	end
	and addr_village_code =
	case 
		when	v_grampanchayat_code isnull or v_grampanchayat_code = '' then
				coalesce(addr_village_code,v_grampanchayat_code)
		else 
				coalesce(v_grampanchayat_code,addr_village_code)
	end
	and status_code = 'A';
	
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_category_jsonb(_category_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 07-10-2022
	*/
	v_category_jsonb_desc public.udd_jsonb := '[{}]';
BEGIN
	select 
			'['||
				string_agg('{""master_code"":""'||b.category||'"",""master_desc"":""'||
				fn_get_masterdesc('QCD_CATEGORY',b.category,_lang_code)||'""}',',')||
			']' 
			into v_category_jsonb_desc
		from 	jsonb_to_recordset(_category_jsonb) b(category udd_text);
	
	v_category_jsonb_desc = coalesce(v_category_jsonb_desc,'[{}]');
	return v_category_jsonb_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_clfname(_clf_cbo_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 09-02-2023
	*/
	v_clf_name public.udd_text := '';
BEGIN
	 select	federation_name into  v_clf_name
  	 from   federation_profile_consolidated 
  	 where  cbo_code = _clf_cbo_code
   	 and 	is_active = true
   	 and    cbo_type = 2;
	
	v_clf_name = coalesce(v_clf_name,'');
	return v_clf_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_concattrainername(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 04-02-2022
	*/
	v_trainer_name udd_text := '';
	v_confirmation_flag udd_flag := 'Y';
	v_status_code udd_code := 'A';
BEGIN
	  select c.trainer_name into v_trainer_name from (select 
				 tprogram_id,
				 tprogrambatch_id,
				 STRING_AGG((select public.fn_get_trainername(trainer_id)),',') as trainer_name
	  from 		 trng_trn_ttprogramtrainer
	  where 	 tprogram_id = _tprogram_id
	  and 		 tprogrambatch_id = _tprogrambatch_id
	  and        confirmation_flag = v_confirmation_flag
	  and        status_code = v_status_code
	  group by tprogram_id,tprogrambatch_id) as c;
	  
	v_trainer_name = coalesce(v_trainer_name,'');
	return v_trainer_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_configvalue(_config_name udd_desc)
 RETURNS udd_desc
 LANGUAGE plpgsql
AS $function$
declare
	/*
		Created By		: Vijayavel J
		Created Date	: 16-03-2022
		Function Code 	: 
	*/
	
	v_config_value udd_desc;
BEGIN
	SELECT 
   		config_value into v_config_value  
	FROM core_mst_tconfig
	where config_name = _config_name  
	and status_code = 'A';
	
	v_config_value = coalesce(v_config_value,'');
	
	RETURN v_config_value;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_confirmparticipantcount(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_count public.udd_int := 0;
	v_attendance_count udd_int := 0;
BEGIN	
	  select count(*) into v_attendance_count 
	  from 	 trng_trn_ttprogramparticipant
	  where  tprogram_id = _tprogram_id
	  and    tprogrambatch_id = _tprogrambatch_id
	  and    attendance_flag in ('QCD_YES','QCD_NO')
	  and    status_code = 'A' ;
	  
	  select fn_get_participantcount(_tprogram_id, _tprogrambatch_id) into v_count;
	  
	  if v_count = v_attendance_count then
	  		v_attendance_count := v_count;
	  else
	  		v_attendance_count = 0;
	  end if;
	  
-- 	v_attendance_count = coalesce(v_attendance_count,0);
	return v_attendance_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_confirmtrainercount(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_count public.udd_int := 0;
BEGIN	
	  select count(*) into v_count 
	  from 	 trng_trn_ttprogramtrainer
	  where  tprogram_id = _tprogram_id
	  and    tprogrambatch_id = _tprogrambatch_id
	  and    confirmation_flag = 'Y'
	  and    status_code = 'A' ;
	  
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_confirmtrainercount(_tprogram_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_count public.udd_int := 0;
BEGIN
	  select count(*) into v_count
	  from 	  trng_trn_ttprogramtrainer
	  where   tprogram_id = _tprogram_id
	  and     status_code <> 'I'
	  and 	  confirmation_flag = 'Y';

	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_course(_course_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 13-10-2022
	*/
	v_course_jsonb_desc public.udd_jsonb := '[{}]';
BEGIN
		select 
			'['||
				string_agg('""'||fn_get_coursename(b.course)|| '""'||'',',') ||
			']'::udd_text into v_course_jsonb_desc
		from jsonb_to_recordset(_course_jsonb) b(course udd_text);

	v_course_jsonb_desc = coalesce(v_course_jsonb_desc,'[{}]');
	return v_course_jsonb_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_course_jsonb(_course_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 10-10-2022
	*/
	v_course_jsonb_desc public.udd_jsonb := '[{}]';
BEGIN
	select 
			'['||
				string_agg('{""master_code"":""'||b.course||'"",""master_desc"":""'||
				fn_get_coursename(b.course)||'""}',',')||
			']' into v_course_jsonb_desc
		from 	jsonb_to_recordset(_course_jsonb) b(course udd_text);
	
	v_course_jsonb_desc = coalesce(v_course_jsonb_desc,'[{}]');
	return v_course_jsonb_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_course_level(_course_level_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 07-10-2022
		
		Updated by : Mangai
		Updated date : 22-02-2023
	*/
	v_course_level_desc udd_text := '[{}]';
BEGIN
	select 
			'['||
				string_agg('""'||fn_get_masterdesc('QCD_LEVEL',b.course_level,_lang_code) || '""'||'',',')||
			']'::udd_text into v_course_level_desc
		from jsonb_to_recordset(_course_level_jsonb) b(course_level udd_text);
		
	v_course_level_desc = coalesce(v_course_level_desc,'');
	return v_course_level_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_course_level_jsonb(_course_level_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 06-10-2022
	*/
	v_course_level_jsonb_desc public.udd_jsonb := '[{}]';
BEGIN
	select 
			'['||
				string_agg('{""master_code"":""'||b.course_level||'"",""master_desc"":""'||
				fn_get_masterdesc('QCD_COURSE_LEVEL',b.course_level,_lang_code)||'""}',',')||
			']' 
			into v_course_level_jsonb_desc
		from 	jsonb_to_recordset(_course_level_jsonb) b(course_level udd_text);
	
	v_course_level_jsonb_desc = coalesce(v_course_level_jsonb_desc,'[{}]');
	return v_course_level_jsonb_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_course_level_list(_course_level_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		Created date : 10-11-2022
	*/
	v_course_level_desc udd_text := '[{}]';
BEGIN
	select 
			fn_get_masterdesc('QCD_COURSE_LEVEL',b.course_level,_lang_code) 
	from jsonb_to_recordset(_course_level_jsonb) b(course_level udd_text);
		
	v_course_level_desc = coalesce(v_course_level_desc,'');
	return v_course_level_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_course_type(_course_type_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 07-10-2022
	*/
	v_course_type_desc udd_text := '[{}]';
BEGIN
	select 
			'['||
				string_agg('""'||fn_get_masterdesc('QCD_COURSE_TYPE',b.course_type,_lang_code) || '""'||'',',')||
			']'::udd_text into v_course_type_desc
		from jsonb_to_recordset(_course_type_jsonb) b(course_type udd_text);
		
	v_course_type_desc = coalesce(v_course_type_desc,'');
	return v_course_type_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_course_type_jsonb(_course_type_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 07-10-2022
	*/
	v_course_type_jsonb_desc public.udd_jsonb := '[{}]';
BEGIN
	select 
			'['||
				string_agg('{""master_code"":""'||b.course_type||'"",""master_desc"":""'||
				fn_get_masterdesc('QCD_COURSE_TYPE',b.course_type,_lang_code)||'""}',',')||
			']' 
			into v_course_type_jsonb_desc
		from 	jsonb_to_recordset(_course_type_jsonb) b(course_type udd_text);
	
	v_course_type_jsonb_desc = coalesce(v_course_type_jsonb_desc,'[{}]');
	return v_course_type_jsonb_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_coursename(_course_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 30-09-2022
	*/
	v_course_name public.udd_text := '';
BEGIN
	select 	course_name into v_course_name
	from 	trng_mst_tcourse
	where 	course_id 	= _course_id
	and 	status_code <> 'I';
	
	v_course_name = coalesce(v_course_name,'');
	return v_course_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_coursesubvertical(_course_id udd_code)
 RETURNS SETOF udd_code
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Vijayavel J
		Created date : 27-10-2022
	*/
     colrec record;
BEGIN
     for colrec in 	select subvertical_code from trng_mst_vcoursesubvertical 
	 				where course_id = _course_id 
					and status_code = 'A'
     loop
	 	return next colrec.subvertical_code;
     end loop;
	 
	 return;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_dbcoursecount(_user_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 27-02-2023
		
		Version No : 1
	*/
	v_vertical_code udd_code := '';
	v_state_code udd_code := '';
	v_district_code udd_code := '';
	v_block_code udd_code := '';
	v_panchayat_code udd_code := '';
	v_village_code  udd_code := '';
	v_user_level_code udd_code := '';
	v_count udd_int := 0;
BEGIN
	select 	vertical_code, user_level_code, state_code, district_code, block_code, panchayat_code, village_code  
	into    v_vertical_code, v_user_level_code, v_state_code, v_district_code, v_block_code, v_panchayat_code, v_village_code 
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';
	
	SELECT  count(distinct course_id)  into v_count
    FROM trng_mst_tcourse,
        jsonb_to_recordset(trng_mst_tcourse.course_level_jsonb::jsonb) a(course_level udd_text)
    WHERE a.course_level <= v_user_level_code
	and   vertical_code = v_vertical_code
	and   status_code = 'A';
						  
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_dbprngcompleteblockcount(_user_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 3-04-2023
		
		Version No : 1
	*/
	v_vertical_code udd_code := '';	
	v_user_level_code udd_code := '';	
	v_count udd_int := 0;
BEGIN
	select 	vertical_code, user_level_code
	into    v_vertical_code, v_user_level_code
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';
	
	select count(p.*) into v_count
	from   trng_trn_ttprogram as p
	inner join trng_mst_tcourse as c
	on     p.course_id = c.course_id
	and    c.status_code = 'A'
	where  c.vertical_code = v_vertical_code
	and    p.tprogram_level_code = '69'
	and    p.status_code = 'A'
	and    p.execution_status_code = 'C';
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_dbprngcompletebudgetamt(_user_code udd_code)
 RETURNS udd_decimal
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 3-04-2023
		
		Version No : 1
	*/
	v_vertical_code udd_code := '';	
	v_user_level_code udd_code := '';	
	v_amt udd_decimal := 0;
BEGIN
	select 	vertical_code, user_level_code
	into    v_vertical_code, v_user_level_code
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';

	select      coalesce(sum(pb.budget_amount),0) into v_amt
	from        trng_trn_ttprogram as p
	inner join  trng_mst_tcourse as c
	on          p.course_id = c.course_id
	and         c.status_code = 'A'
	inner join  trng_trn_ttprogrambudget as pb
	on          p.tprogram_id = pb.tprogram_id
	and         pb.status_code = 'A'
	where  c.vertical_code = v_vertical_code
	and    p.tprogram_level_code <= v_user_level_code
	and    p.status_code = 'A'
	and    p.execution_status_code = 'C';
	
-- 	v_amt = coalesce(v_amt,0);
	return v_amt;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_dbprngcompletecount(_user_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 27-02-2023
		
		Updated by : Mangai
		Updated date : 01-03-2023
		
		Version No : 1
	*/
	v_vertical_code udd_code := '';
	v_user_level_code udd_code := '';
	v_state_code udd_code := '';
	v_district_code udd_code := '';
	v_block_code udd_code := '';
	v_panchayat_code udd_code := '';
	v_village_code  udd_code := '';
	
	v_count udd_int := 0;
BEGIN
	select 	vertical_code, user_level_code, state_code, district_code, block_code, panchayat_code, village_code  
	into    v_vertical_code, v_user_level_code, v_state_code, v_district_code, v_block_code, v_panchayat_code, v_village_code 
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';
	
	select count(p.*) into v_count
	from   trng_trn_ttprogram as p
	inner join trng_mst_tcourse as c
	on     p.course_id = c.course_id
	and    c.status_code = 'A'
	where  p.tprogram_level_code <= v_user_level_code
	and    c.vertical_code = v_vertical_code
	and    p.status_code not in ('R','I')
	and    p.execution_status_code = 'C';
	
/*	select count(p.tprogram_id) into v_count
	from       trng_trn_ttprogram as p
	inner join trng_trn_ttprogramgeo as pg
	on         p.tprogram_id = pg.tprogram_id
	and        pg.status_code = 'A'
	where      p.coordinator_id = _user_code
	and        pg.state_code = 
	case 
		when  v_state_code = '' or v_state_code isnull then
					coalesce(pg.state_code,v_state_code)
		else
					coalesce(v_state_code,pg.state_code)
		end
	and        pg.district_code = 
	case 
		when  v_district_code = '' or v_district_code isnull then
					coalesce(pg.district_code,v_district_code)
		else
					coalesce(v_district_code,pg.district_code)
		end
	and        pg.block_code = 
	case 
		when  v_block_code = '' or v_block_code isnull then
					coalesce(pg.block_code,v_block_code)
		else
					coalesce(v_block_code,pg.block_code)
		end
	and        pg.grampanchayat_code = 
	case 
		when  v_panchayat_code = '' or v_panchayat_code isnull then
					coalesce(pg.grampanchayat_code,v_panchayat_code)
		else
					coalesce(v_panchayat_code,pg.grampanchayat_code)
		end
	and        pg.village_code = 
	case 
		when  v_village_code = '' or v_village_code isnull then
					coalesce(pg.village_code,v_village_code)
		else
					coalesce(v_village_code,pg.village_code)
		end
	and   p.status_code not in ('R','I')
	and   p.execution_status_code = 'C';
*/					  
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_dbprngcompleteexpenseamt(_user_code udd_code)
 RETURNS udd_decimal
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 3-04-2023
		
		Version No : 1
	*/
	v_vertical_code udd_code := '';	
	v_user_level_code udd_code := '';	
	v_amt udd_decimal := 0;
BEGIN
	select 	vertical_code, user_level_code
	into    v_vertical_code, v_user_level_code
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';

	select      coalesce(sum(pe.expense_amount),0) into v_amt
	from        trng_trn_ttprogram as p
	inner join  trng_mst_tcourse as c
	on          p.course_id = c.course_id
	and         c.status_code = 'A'
	inner join  trng_trn_ttprogramexpense as pe
	on          p.tprogram_id = pe.tprogram_id
	and         pe.status_code = 'A'
	where  c.vertical_code = v_vertical_code
	and    p.tprogram_level_code <= v_user_level_code
	and    p.status_code = 'A'
	and    p.execution_status_code = 'C';
	
-- 	v_amt = coalesce(v_amt,0);
	return v_amt;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_dbprngcompletenationalcount(_user_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 3-04-2023
		
		Version No : 1
	*/
	v_vertical_code udd_code := '';	
	v_user_level_code udd_code := '';	
	v_count udd_int := 0;
BEGIN
	select 	vertical_code, user_level_code
	into    v_vertical_code, v_user_level_code
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';
	
	select count(p.*) into v_count
	from   trng_trn_ttprogram as p
	inner join trng_mst_tcourse as c
	on     p.course_id = c.course_id
	and    c.status_code = 'A'
	where  c.vertical_code = v_vertical_code
	and    p.tprogram_level_code = '99'
	and    p.status_code = 'A'
	and    p.execution_status_code = 'C';
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_dbprngcompletencount(_user_code udd_code, _level_code udd_code)
 RETURNS SETOF text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		Created date : 02-05-2023
		
		Version No : 01
	*/
	v_vertical_code udd_code := '';	
	v_user_level_code udd_code := '';	
	v_count udd_text := '';
	v_month udd_code := '';	
	
BEGIN
	select 	vertical_code, user_level_code
	into    v_vertical_code, v_user_level_code
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';
	
	FOR v_count IN select to_char(p.execution_status_date,'Month') || count(p.tprogram_id)
					from   trng_trn_ttprogram as p
					inner join trng_mst_tcourse as c
					on     p.course_id = c.course_id
					and    c.status_code = 'A'
					where  c.vertical_code = v_vertical_code
					and    p.tprogram_level_code = _level_code
					and    p.status_code = 'A'
					and    p.execution_status_code = 'C'
					group by to_char(p.execution_status_date,'Month')
		 LOOP
				RETURN NEXT v_count;
	 END LOOP;
   RETURN;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_dbprngcompletensbcount(_user_code udd_code)
 RETURNS SETOF text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		Created date : 02-05-2023
		
		Version No : 01
	*/
	v_vertical_code udd_code := '';	
	v_user_level_code udd_code := '';	
	v_count udd_text := '';
	v_month udd_code := '';	
	
BEGIN
	select 	vertical_code, user_level_code
	into    v_vertical_code, v_user_level_code
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';
	
	FOR v_count IN select rtrim(to_char(p.execution_status_date,'Month'))
					from   trng_trn_ttprogram as p
					inner join trng_mst_tcourse as c
					on     p.course_id = c.course_id
					and    c.status_code = 'A'
					where  c.vertical_code = v_vertical_code
-- 					and    p.tprogram_level_code = '99'
					and    p.status_code = 'A'
					and    p.execution_status_code = 'C'
					group by to_char(p.execution_status_date,'Month')
		 LOOP
				RETURN NEXT v_count;
	 END LOOP;
   RETURN;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_dbprngcompletestatecount(_user_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 3-04-2023
		
		Version No : 1
	*/
	v_vertical_code udd_code := '';	
	v_user_level_code udd_code := '';	
	v_count udd_int := 0;
BEGIN
	select 	vertical_code, user_level_code
	into    v_vertical_code, v_user_level_code
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';
	
	select count(p.*) into v_count
	from   trng_trn_ttprogram as p
	inner join trng_mst_tcourse as c
	on     p.course_id = c.course_id
	and    c.status_code = 'A'
	where  c.vertical_code = v_vertical_code
	and    p.tprogram_level_code = '89'
	and    p.status_code = 'A'
	and    p.execution_status_code = 'C';
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_dbprngschedulecount(_user_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		Created by : Mangai
		Created date : 27-02-2023
		
		Updated by : Mangai
		Updated date : 01-03-2023
		
		Version No : 2
	*/
	v_vertical_code udd_code := '';
	v_user_level_code udd_code := '';
	v_state_code udd_code := '';
	v_district_code udd_code := '';
	v_block_code udd_code := '';
	v_panchayat_code udd_code := '';
	v_village_code  udd_code := '';
	
	v_count udd_int := 0;
BEGIN
	select 	vertical_code, user_level_code, state_code, district_code, block_code, panchayat_code, village_code  
	into    v_vertical_code, v_user_level_code, v_state_code, v_district_code, v_block_code, v_panchayat_code, v_village_code 
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';
	
	select count(p.*) into v_count
	from   trng_trn_ttprogram as p
	inner join trng_mst_tcourse as c
	on     p.course_id = c.course_id
	and    c.status_code = 'A'
	where  p.tprogram_level_code <= v_user_level_code
	and    c.vertical_code = v_vertical_code
	and    p.status_code not in ('R','I')
	and    p.execution_status_code = 'H';
/*	
	select count(p.tprogram_id) into v_count
	from  	trng_trn_ttprogram as p
	inner join trng_trn_ttprogramgeo as pg
	on         p.tprogram_id = pg.tprogram_id
	and        pg.status_code = 'A'
	where 	   p.coordinator_id = _user_code
	and        pg.state_code = 
	case 
		when  v_state_code = '' or v_state_code isnull then
					coalesce(pg.state_code,v_state_code)
		else
					coalesce(v_state_code,pg.state_code)
		end
	and        pg.district_code = 
	case 
		when  v_district_code = '' or v_district_code isnull then
					coalesce(pg.district_code,v_district_code)
		else
					coalesce(v_district_code,pg.district_code)
		end
	and        pg.block_code = 
	case 
		when  v_block_code = '' or v_block_code isnull then
					coalesce(pg.block_code,v_block_code)
		else
					coalesce(v_block_code,pg.block_code)
		end
	and        pg.grampanchayat_code = 
	case 
		when  v_panchayat_code = '' or v_panchayat_code isnull then
					coalesce(pg.grampanchayat_code,v_panchayat_code)
		else
					coalesce(v_panchayat_code,pg.grampanchayat_code)
		end
	and        pg.village_code = 
	case 
		when  v_village_code = '' or v_village_code isnull then
					coalesce(pg.village_code,v_village_code)
		else
					coalesce(v_village_code,pg.village_code)
		end
		and     p.status_code not in ('R','I')
		and   	p.execution_status_code = 'H';
*/						  
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_dbtrainercount(_user_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		Created by : Mangai
		Created date : 27-02-2023
		
		Updated by : Mangai
		Updated date : 02-03-2023
		
		Version No : 2
	*/
	v_vertical_code udd_code := '';
	v_state_code udd_code := '';
	v_district_code udd_code := '';
	v_block_code udd_code := '';
	v_panchayat_code udd_code := '';
	v_village_code  udd_code := '';
	v_user_level_code udd_code := '';
	v_count udd_int := 0;
BEGIN
	select 	vertical_code,user_level_code,state_code,district_code,block_code,panchayat_code,village_code  
	into    v_vertical_code,v_user_level_code,v_state_code,v_district_code,v_block_code,v_panchayat_code,v_village_code 
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';

	select     count(distinct t.trainer_id) into v_count
	from       trng_mst_ttrainer as t
	inner join trng_mst_ttrainerdomain as td
	on         t.trainer_id = td.trainer_id
	and        td.status_code = 'A'
	where      t.trainer_level_code <= v_user_level_code
	and        td.vertical_code = v_vertical_code
	and        t.trainer_type_code not in ('QCD_GROUP')
	and        t.status_code = 'A';
	
/*	select count(t.trainer_name) into v_count
	from       trng_mst_ttrainer as t
	inner join trng_mst_ttrainerdomain as td
	on         t.trainer_id = td.trainer_id
	and        td.status_code = 'A'
	inner join trng_mst_ttraineraddr as ta
	on         t.trainer_id = ta.trainer_id
	and        ta.status_code = 'A'
	where      t.created_by = _user_code
	and        td.vertical_code = v_vertical_code
	and        ta.state_code = 
	case 
		when  v_state_code = '' or v_state_code isnull then
					coalesce(ta.state_code,v_state_code)
		else
					coalesce(v_state_code,ta.state_code)
		end
	and        ta.district_code = 
	case 
		when  v_district_code = '' or v_district_code isnull then
					coalesce(ta.district_code,v_district_code)
		else
					coalesce(v_district_code,ta.district_code)
		end
	and        ta.block_code = 
	case 
		when  v_block_code = '' or v_block_code isnull then
					coalesce(ta.block_code,v_block_code)
		else
					coalesce(v_block_code,ta.block_code)
		end
	and        ta.grampanchayat_code = 
	case 
		when  v_panchayat_code = '' or v_panchayat_code isnull then
					coalesce(ta.grampanchayat_code,v_panchayat_code)
		else
					coalesce(v_panchayat_code,ta.grampanchayat_code)
		end
		and        ta.village_code = 
	case 
		when  v_village_code = '' or v_village_code isnull then
					coalesce(ta.village_code,v_village_code)
		else
					coalesce(v_village_code,ta.village_code)
		end
	and        t.status_code = 'A';
*/						  
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_district_ll_desc(_district_id udd_int, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		created date : 18-10-2022
	*/
	v_district_name_local public.udd_text := '';
	v_district_name_en public.udd_text := '';
BEGIN
	select  district_name_local,district_name_en 
	into 	v_district_name_local,v_district_name_en
	from   	district_master 
	where 	district_id = _district_id;
		
	if _lang_code = 'en_US' then
		v_district_name_en := coalesce(v_district_name_en,'');
		return v_district_name_en;
		
	else 
		v_district_name_local := coalesce(v_district_name_local,v_district_name_en);
		return v_district_name_local;
		
	end if;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_districtcode(_district_id udd_int)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_district_code public.udd_code := '';
BEGIN
	select district_code into v_district_code 
	from 		district_master
	where 	district_id = _district_id
	and 	is_active = true;
	
	v_district_code = coalesce(v_district_code,'');
	return v_district_code;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_districtdesc(_district_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_district_desc public.udd_text := '';
BEGIN
	select district_name_en into v_district_desc 
	from 		district_master
	where 	district_code = _district_code
	and 	is_active = true;
	
	v_district_desc = coalesce(v_district_desc,'');
	return v_district_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_districtdesc(_district_id udd_int)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_district_desc public.udd_text := '';
BEGIN
	select district_name_en into v_district_desc 
	from 		district_master
	where 	district_id = _district_id
	and 	is_active = true;
	
	v_district_desc = coalesce(v_district_desc,'');
	return v_district_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_districtid(_district_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_district_id public.udd_int := 0;
BEGIN
	select district_id into v_district_id 
	from 		district_master
	where 	district_code = _district_code
	and 	is_active = true;
	
	v_district_id = coalesce(v_district_id,0);
	return v_district_id;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_expenseamount(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_amount
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_expense_amount public.udd_amount := 0;
BEGIN
	select 	coalesce(sum(expense_amount),0) into v_expense_amount
	from 	trng_trn_ttprogramexpense
	where 	tprogram_id = _tprogram_id
	and   	tprogrambatch_id = _tprogrambatch_id
	and   	status_code = 'A';
	
-- 	v_expense_amount = coalesce(v_expense_amount,0);
	return v_expense_amount;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_facilityname(_facility_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 21-01-2023
	*/
	v_facility_name public.udd_text := '';
BEGIN
	select 	facility_name into v_facility_name
	from 	trng_mst_tvenueinfra
	where 	facility_id = _facility_id
	and 	status_code <> 'I';
	
	v_facility_name = coalesce(v_facility_name,'');
	return v_facility_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_fbcompletecount(_tprogram_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		Created By 	 : Mangai
		Created Date : 17-01-2023
	*/
	v_count public.udd_int := 0;
BEGIN
	  select count(*) into v_count 
	  from 	  trng_trn_tfeedbackparticipant 
	  where   tprogram_id = _tprogram_id
	  and 	  response_status = 'QCD_COMPLETED';

	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_fbcompletecount(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		Created By 	 : Mangai
		Created Date : 08-02-2023
	*/
	v_count public.udd_int := 0;
BEGIN
	  select count(*) into v_count 
	  from 	  trng_trn_ttprogramparticipant 
	  where   tprogram_id = _tprogram_id
	  and     tprogrambatch_id = _tprogrambatch_id
	  and 	  feedback_status = 'QCD_COMPLETED'
	  and     attendance_flag = 'QCD_YES'
	  and     status_code = 'A';
	  
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_fbpendingcount(_tprogram_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		Created By 	 : Mangai
		Created Date : 17-01-2023
	*/
	v_count public.udd_int := 0;
BEGIN
	  select count(*) into v_count 
	  from 	  trng_trn_tfeedbackparticipant 
	  where   tprogram_id = _tprogram_id
	  and 	  response_status = 'QCD_PENDING';

	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_fbpendingcount(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		Created By 	 : Mangai
		Created Date : 08-02-2023
	*/
	v_count public.udd_int := 0;
BEGIN 
	  select count(*) into v_count 
	  from 	  trng_trn_ttprogramparticipant 
	  where   tprogram_id = _tprogram_id
	  and     tprogrambatch_id = _tprogrambatch_id
	  and 	  feedback_status = 'QCD_PENDING'
	  and     attendance_flag = 'QCD_YES'
	  and     status_code = 'A';

	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_genderconversion(_gender_code udd_code)
 RETURNS udd_code
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		Created By  : Mangai
		Created Date : 06-04-2023
	*/
	v_gender_code udd_code := '';
BEGIN
	
	if _gender_code in ('M','1') then
		v_gender_code := '1';
	elseif _gender_code in ('F','2') then
		v_gender_code := '2';
	elseif _gender_code in ('O','3') then
		v_gender_code := '3';
	end if;
	
	v_gender_code = coalesce(v_gender_code,'');
	return v_gender_code;
	
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_group_ll_name(_trngorg_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 08-11-2022
	*/
	v_trngorg_ll_name public.udd_text := '';
BEGIN
	select 	trngorg_ll_name into v_trngorg_ll_name
	from 	trng_mst_ttrainingorg
	where 	trngorg_id = _trngorg_id
	and 	trngorg_type_code = 'QCD_GROUP'
	and 	status_code <> 'I';
	
	v_trngorg_ll_name = coalesce(v_trngorg_ll_name,'');
	return v_trngorg_ll_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_groupname(_trngorg_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 26-10-2022
	*/
	v_trngorg_name public.udd_text := '';
BEGIN
	select 	trngorg_name into v_trngorg_name
	from 	trng_mst_ttrainingorg
	where 	trngorg_id = _trngorg_id
	and 	trngorg_type_code = 'QCD_GROUP'
	and 	status_code <> 'I';
	
	v_trngorg_name = coalesce(v_trngorg_name,'');
	return v_trngorg_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_grouptrainerid(_trngorg_id udd_code)
 RETURNS SETOF udd_code
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Vijayavel J
		Created date : 02-11-2022
	*/
     colrec record;
BEGIN
     for colrec in 	select trainer_id from trng_mst_ttrainergroup
	 				where trngorg_id = _trngorg_id 
					and status_code = 'A'
     loop
	 	return next colrec.trainer_id;
     end loop;
	 
	 return;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_language(_lang_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 13-10-2022
	*/
	v_lang_jsonb_desc public.udd_jsonb := '[{}]';
BEGIN
		select 
			'['||
				string_agg('""'||fn_get_languagedesc(b.language)|| '""'||'',',') ||
			']'::udd_text into v_lang_jsonb_desc
		from jsonb_to_recordset(_lang_jsonb) b(language udd_text);

	v_lang_jsonb_desc = coalesce(v_lang_jsonb_desc,'[{}]');
	return v_lang_jsonb_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_language_code(_language_jsonb udd_jsonb)
 RETURNS SETOF udd_code
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		Created date : 07-11-2022
	*/
	 colrec record;
BEGIN
		for colrec in select a.language from 
						jsonb_to_recordset(_language_jsonb) a(language udd_text)
		 loop
			return next colrec.language;
		 end loop;
		  
	 return;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_language_jsonb(_lang_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 10-10-2022
	*/
	v_lang_jsonb_desc public.udd_jsonb := '[{}]';
BEGIN
	select 
			'['||
				string_agg('{""lang_code"":""'||b.language||'"",""lang_name"":""'||
				fn_get_languagedesc(b.language)||'""}',',')||
			']'	into v_lang_jsonb_desc
		from 	jsonb_to_recordset(_lang_jsonb) b(language udd_text);
	
	v_lang_jsonb_desc = coalesce(v_lang_jsonb_desc,'[{}]');
	return v_lang_jsonb_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_languagedesc(_lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 30-09-2022
	*/
	v_lang_desc public.udd_text := '';
BEGIN
	select 	lang_name into v_lang_desc
	from 	core_mst_tlanguage
	where 	lang_code 	= _lang_code
	and 	status_code = 'A';
	
	v_lang_desc = coalesce(v_lang_desc,'');
	return v_lang_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_lokosblockcount(_intuser_type_code udd_code, _tprogram_id udd_code, _resource_type udd_code, _c_role_code udd_code, _category udd_code, _vertical udd_code, _subvertical udd_code, _participant_name udd_desc, _state_id udd_int, _district_id udd_int, _block_id udd_int, _user_level_code udd_code, _shg_name udd_desc, _user_code udd_code, _role_code udd_code, _lang_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
	Created By   : Mangai
	Created Date : 29-12-2022
	*/

	v_count udd_int := 0;
	
BEGIN
	
	select count(*) into v_count
	from   shgmember_profileconsolidated_view 
	where  shg_member_name ilike _participant_name||'%' collate pg_catalog.""default""
	and    shg_name ilike _shg_name||'%' collate pg_catalog.""default""
	and    shg_member_id::udd_code not in (select participant_id from trng_trn_ttprogramparticipant
								 where participant_type_code = 'QCD_INTERNAL'
								 and participant_subtype_code = 'QCD_INT_LOKOS'
								 and tprogram_id = _tprogram_id
								 and status_code = 'A')
	and    state_id    = _state_id 
	and    district_id =
	case 
		when    _district_id isnull or _district_id = 0  then 
				coalesce(district_id,_district_id)
		else 
				coalesce(_district_id,district_id) 
	end 
	and    block_id =
	case 
		when    _block_id isnull or _block_id = 0  then 
				coalesce(block_id,_block_id)
		else 
				coalesce(_block_id,block_id) 
	end 
	limit 50;
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_lokosdistrictcount(_intuser_type_code udd_code, _tprogram_id udd_code, _resource_type udd_code, _c_role_code udd_code, _category udd_code, _vertical udd_code, _subvertical udd_code, _participant_name udd_desc, _state_id udd_int, _district_id udd_int, _user_level_code udd_code, _shg_name udd_desc, _user_code udd_code, _role_code udd_code, _lang_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
	Created By   : Mangai
	Created Date : 29-12-2022
	*/

	v_count udd_int := 0;
BEGIN
	
	select count(*) into v_count
	from   shgmember_profileconsolidated_view 
	where  shg_member_name ilike _participant_name||'%' collate pg_catalog.""default""
	and    shg_name ilike _shg_name||'%' collate pg_catalog.""default""
	and    shg_member_id::udd_code not in (select participant_id from trng_trn_ttprogramparticipant
								 where participant_type_code = 'QCD_INTERNAL'
								 and participant_subtype_code = 'QCD_INT_LOKOS'
								 and tprogram_id = _tprogram_id
								 and status_code = 'A')
	and    state_id    = _state_id 
	and    district_id =
	case 
		when    _district_id isnull or _district_id = 0  then 
				coalesce(district_id,_district_id)
		else 
				coalesce(_district_id,district_id) 
	end 
	limit 50;
	
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_lokospanchayatcount(_intuser_type_code udd_code, _tprogram_id udd_code, _resource_type udd_code, _c_role_code udd_code, _category udd_code, _vertical udd_code, _subvertical udd_code, _participant_name udd_desc, _state_id udd_int, _district_id udd_int, _block_id udd_int, _panchayat_id udd_int, _user_level_code udd_code, _shg_name udd_desc, _user_code udd_code, _role_code udd_code, _lang_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
	Created By   : Mangai
	Created Date : 29-12-2022
	*/

	v_count udd_int := 0;
BEGIN
	
	select count(*) into v_count
	from   shgmember_profileconsolidated_view 
	where  shg_member_name ilike _participant_name||'%' collate pg_catalog.""default""
	and    shg_name ilike _shg_name||'%' collate pg_catalog.""default""
	and    shg_member_id::udd_code not in (select participant_id from trng_trn_ttprogramparticipant
								 where participant_type_code = 'QCD_INTERNAL'
								 and participant_subtype_code = 'QCD_INT_LOKOS'
								 and tprogram_id = _tprogram_id
								 and status_code = 'A')
	and    state_id    = _state_id 
	and    district_id =
	case 
		when    _district_id isnull or _district_id = 0  then 
				coalesce(district_id,_district_id)
		else 
				coalesce(_district_id,district_id) 
	end 
	and    block_id =
	case 
		when    _block_id isnull or _block_id = 0  then 
				coalesce(block_id,_block_id)
		else 
				coalesce(_block_id,block_id) 
	end 
	and    panchayat_id =
	case 
		when    _panchayat_id isnull or _panchayat_id = 0  then 
				coalesce(panchayat_id,_panchayat_id)
		else 
				coalesce(_panchayat_id,panchayat_id) 
	end 
	limit 50;
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_lokosvillagecount(_intuser_type_code udd_code, _tprogram_id udd_code, _resource_type udd_code, _c_role_code udd_code, _category udd_code, _vertical udd_code, _subvertical udd_code, _participant_name udd_desc, _state_id udd_int, _district_id udd_int, _block_id udd_int, _panchayat_id udd_int, _village_id udd_int, _user_level_code udd_code, _shg_name udd_desc, _user_code udd_code, _role_code udd_code, _lang_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
	Created By   : Mangai
	Created Date : 29-12-2022
	*/

	v_count udd_int := 0;
BEGIN
		
	select count(*) into v_count
	from   shgmember_profileconsolidated_view
	where  shg_member_name ilike _participant_name||'%' collate pg_catalog.""default""
	and    shg_name ilike _shg_name||'%' collate pg_catalog.""default""
	and    shg_member_id::udd_code not in (select participant_id from trng_trn_ttprogramparticipant
								 where participant_type_code = 'QCD_INTERNAL'
								 and participant_subtype_code = 'QCD_INT_LOKOS'
								 and tprogram_id = _tprogram_id
								 and status_code = 'A')
	and    state_id    = _state_id 
	and    district_id =
	case 
		when    _district_id isnull or _district_id = 0  then 
				coalesce(district_id,_district_id)
		else 
				coalesce(_district_id,district_id) 
	end 
	and    block_id =
	case 
		when    _block_id isnull or _block_id = 0  then 
				coalesce(block_id,_block_id)
		else 
				coalesce(_block_id,block_id) 
	end 
	and    panchayat_id =
	case 
		when    _panchayat_id isnull or _panchayat_id = 0  then 
				coalesce(panchayat_id,_panchayat_id)
		else 
				coalesce(_panchayat_id,panchayat_id) 
	end 
	and    village_id =
	case 
		when    _village_id isnull or _village_id = 0  then 
				coalesce(village_id,_village_id)
		else 
				coalesce(_village_id,village_id) 
	end
	limit 50;
	
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_mainmenupermission(_parent_code udd_code, _role_code udd_code)
 RETURNS udd_boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
	/* Created By : Mangai
	   Created Date : 22-03-2023
	   
	   Version No : 1
	*/
	v_menu_code record;
	v_count udd_int := 0;
	v_deny_count udd_int := 0;
	v_menue_count udd_int := 0;
	v_return udd_boolean ;
BEGIN	
			select count(*) into v_menue_count 
			from   core_mst_tmenu
			where  parent_code = _parent_code
			and    status_code  = 'A';
								
			for v_menu_code in (select menu_code from core_mst_tmenu
								where  parent_code = _parent_code
								and status_code  = 'A'
								)
			loop
				select count(*) into v_count from core_mst_trolemenurights as a
				inner join core_mst_tmenu as b
				on a.menu_code = b.menu_code and b.status_code = 'A'
				where  a.role_code = _role_code
				and    a.menu_code = v_menu_code.menu_code
				and    a.deny_flag = 'Y';
				
				v_deny_count := (select sum(v_deny_count+v_count));				
			end loop;
			
			if (v_menue_count = v_deny_count) then		
				v_return = false;
			else 
				v_return = true;
			end if;
		return v_return;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_masterdesc(_parent_code udd_code, _master_code udd_code, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		created date : 24-08-2022
	*/
	v_master_desc public.udd_text := '';
BEGIN
	if _lang_code <> 'en_US' then
		select b.master_desc into v_master_desc 
		from 		core_mst_tmaster as a 
		inner join 	core_mst_tmastertranslate as b 
		on 		a.parent_code = b.parent_code 
		and 	a.master_code = b.master_code 
		where 	a.parent_code = _parent_code 
		and 	a.master_code = _master_code 
		and 	b.lang_code = _lang_code
		and 	a.status_code = 'A';

		v_master_desc = coalesce(v_master_desc,'');
		
		if v_master_desc <> '' then 
			return v_master_desc;
		else 
			return fn_get_masterdesc(_parent_code,_master_code,'en_US');
		end if;
	end if;
	
	select b.master_desc into v_master_desc 
	from 		core_mst_tmaster as a 
	inner join 	core_mst_tmastertranslate as b 
	on 		a.parent_code = b.parent_code 
	and 	a.master_code = b.master_code 
	where 	a.parent_code = _parent_code 
	and 	a.master_code = _master_code 
	and 	b.lang_code = 'en_US'
	and 	a.status_code = 'A';
	
	v_master_desc = coalesce(v_master_desc,'');
	
	return v_master_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_menudesc(_menu_code udd_code, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_menu_desc public.udd_text := '';
BEGIN
		select b.menu_desc into v_menu_desc 
		from 		core_mst_tmenu as a 
		inner join 	core_mst_tmenutranslate as b 
		on 		a.menu_code = b.menu_code
		where   a.menu_code = _menu_code
		and 	b.lang_code = _lang_code
		and 	a.status_code = 'A';
		
		v_menu_desc = coalesce(v_menu_desc,'');
		
		if v_menu_desc = '' then
			select b.menu_desc into v_menu_desc 
			from 		core_mst_tmenu as a 
			inner join 	core_mst_tmenutranslate as b 
			on 		a.menu_code = b.menu_code
			where   a.menu_code = _menu_code
			and 	b.lang_code = 'en_US'
			and 	a.status_code = 'A';
		end if;
		
		v_menu_desc = coalesce(v_menu_desc,'');
		
	return v_menu_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_msg(_msg_code udd_code, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*	created by 	: Mohan s
 		created date : 30-04-2022
	*/
	
	v_msg public.udd_text := '';
BEGIN
	select b.msg_desc into v_msg 
	from 		core_mst_tmessage as a 
	inner join 	core_mst_tmessagetranslate as b 
	on 		a.msg_code = b.msg_code 
	where 	a.msg_code = _msg_code 
	and 	b.lang_code = _lang_code
	and 	a.status_code = 'A';
	
	v_msg = coalesce(v_msg,'');
	
	if v_msg = '' then
		select b.msg_desc into v_msg 
		from 		core_mst_tmessage as a 
		inner join 	core_mst_tmessagetranslate as b 
		on 		a.msg_code = b.msg_code 
		where 	a.msg_code = _msg_code 
		and 	b.lang_code = 'en_US'
		and 	a.status_code = 'A';
	end if;
	
	v_msg = coalesce(v_msg,'');
	
	return v_msg;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_mvblockdesc(_block_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_block_desc public.udd_text := '';
BEGIN
	select block_name_en into v_block_desc 
	from 		mv_village_master
	where 	block_code = _block_code;
	
	v_block_desc = coalesce(v_block_desc,'');
	return v_block_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_mvdistrictdesc(_district_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_district_desc public.udd_text := '';
BEGIN
	select district_name_en into v_district_desc 
	from 		mv_village_master
	where 	district_code = _district_code;
	
	v_district_desc = coalesce(v_district_desc,'');
	return v_district_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_mvpanchayatdesc(_panchayat_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_panchayat_desc public.udd_text := '';
BEGIN
	select panchayat_name_en into v_panchayat_desc 
	from 		mv_village_master
	where 	panchayat_code = _panchayat_code;
	
	v_panchayat_desc = coalesce(v_panchayat_desc,'');
	return v_panchayat_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_mvstatedesc(_state_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_state_desc public.udd_text := '';
BEGIN
	select state_name_en into v_state_desc 
	from 		mv_village_master
	where 	state_code = _state_code;
	
	v_state_desc = coalesce(v_state_desc,'');
	return v_state_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_mvvillagedesc(_village_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_village_desc public.udd_text := '';
BEGIN
	select village_name_en into v_village_desc 
	from 		mv_village_master
	where 	village_code = _village_code;
	
	v_village_desc = coalesce(v_village_desc,'');
	return v_village_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_organizationname(_trngorg_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 01-10-2022
	*/
	v_trngorg_name public.udd_text := '';
BEGIN
	select 	trngorg_name into v_trngorg_name
	from 	trng_mst_ttrainingorg
	where 	trngorg_id = _trngorg_id
	and 	trngorg_type_code = 'QCD_ORGANIZATION'
	and 	status_code <> 'I';
	
	v_trngorg_name = coalesce(v_trngorg_name,'');
	return v_trngorg_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_panchayat_ll_desc(_panchayat_id udd_int, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		created date : 18-10-2022
	*/
	v_panchayat_name_local public.udd_text := '';
	v_panchayat_name_en public.udd_text := '';
BEGIN
	select  panchayat_name_local,panchayat_name_en 
	into 	v_panchayat_name_local,v_panchayat_name_en
	from   	panchayat_master 
	where 	panchayat_id = _panchayat_id;
		
	if _lang_code = 'en_US' then
		v_panchayat_name_en := coalesce(v_panchayat_name_en,'');
		return v_panchayat_name_en;
		
	else 
		v_panchayat_name_local := coalesce(v_panchayat_name_local,v_panchayat_name_en);
		return v_panchayat_name_local;
		
	end if;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_panchayatdesc(_panchayat_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_panchayat_desc public.udd_text := '';
BEGIN
	select panchayat_name_en into v_panchayat_desc 
	from 		panchayat_master
	where 	panchayat_code = _panchayat_code
	and 	is_active = true;
	
	v_panchayat_desc = coalesce(v_panchayat_desc,'');
	return v_panchayat_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_panchayatdesc(_panchayat_id udd_int)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_panchayat_desc public.udd_text := '';
BEGIN
	select panchayat_name_en into v_panchayat_desc 
	from 		panchayat_master
	where 	panchayat_id = _panchayat_id
	and 	is_active = true;
	
	v_panchayat_desc = coalesce(v_panchayat_desc,'');
	return v_panchayat_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_panchayatid(_panchayat_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_panchayat_id public.udd_int := 0;
BEGIN
	select panchayat_id into v_panchayat_id 
	from 		panchayat_master
	where 	panchayat_code = _panchayat_code
	and 	is_active = true;
	
	v_panchayat_id = coalesce(v_panchayat_id,0);
	return v_panchayat_id;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_partabsenttcount(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		Created By 	 : Mangai
		Created Date : 08-02-2023
		
		Updated By : Mangai
		Updated Date : 27-02-2023
		
		Version No : 2
	*/
	v_count public.udd_int := 0;
BEGIN
	  select count(*) into v_count 
	  from 	  trng_trn_ttprogramparticipant 
	  where   tprogram_id = _tprogram_id
	  and     tprogrambatch_id = _tprogrambatch_id
	  and     status_code <> 'I'
	  and 	  attendance_flag in ('QCD_NO','QCD_INVITED');
	  
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_particabsenttcount(_tprogram_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		Created By 	 : Mangai
		Created Date : 17-01-2023
	*/
	v_count public.udd_int := 0;
BEGIN
	  select count(*) into v_count 
	  from 	  trng_trn_ttprogramparticipant 
	  where   tprogram_id = _tprogram_id
	  and     status_code <> 'I'
	  and 	  attendance_flag = 'QCD_NO';

	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_particattendcount(_tprogram_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_count public.udd_int := 0;
BEGIN
	  select count(*) into v_count 
	  from 	  trng_trn_ttprogramparticipant 
	  where   tprogram_id = _tprogram_id
	  and     status_code <> 'I'
	  and 	  attendance_flag = 'QCD_YES';

	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_participant_jsonb(_participant_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 07-10-2022
	*/
	v_participant_jsonb_desc public.udd_jsonb := '[{}]';
BEGIN
	select 
			'['||
				string_agg('{""master_code"":""'||b.participant||'"",""master_desc"":""'||
				fn_get_masterdesc('QCD_TAR_PAR',b.participant,_lang_code)||'""}',',')||
			']' 
			into v_participant_jsonb_desc
		from 	jsonb_to_recordset(_participant_jsonb) b(participant udd_text);
	
	v_participant_jsonb_desc = coalesce(v_participant_jsonb_desc,'[{}]');
	return v_participant_jsonb_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_participantbatchdate(_tprogram_id udd_code, _tprogrambatch_id udd_code, _participant_id udd_code)
 RETURNS udd_date
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_batch_date public.udd_date := null;
BEGIN
	select  batch_date into v_batch_date 
	from 	trng_trn_ttprogramparticipant	
	where 	participant_id = _participant_id
	and     tprogram_id = _tprogram_id
	and     tprogrambatch_id = _tprogrambatch_id
	and 	status_code = 'A';
	
	v_batch_date = coalesce(v_batch_date::udd_code,'');
	return v_batch_date;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_participantcount(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_count public.udd_int := 0;
BEGIN
	  select count(pp.*) into v_count 
	  from 	      trng_trn_ttprogram p
	  inner join  trng_trn_ttprogrambatch pb on p.tprogram_id = pb.tprogram_id
	  and 		  p.status_code <> 'I'
	  and         pb.status_code <> 'I'
	  inner join  trng_trn_ttprogramparticipant as pp
	  on          pb.tprogram_id = pp.tprogram_id
	  and         pb.tprogrambatch_id = pp.tprogrambatch_id
	  and         pp.status_code <> 'I'
	  where 	  pp.tprogram_id = _tprogram_id
	  and         pp.tprogrambatch_id = _tprogrambatch_id;

	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_participantcount(_tprogram_id udd_code, _tprogrambatch_id udd_code, _batch_date udd_date, _participant_type_code udd_code, _participant_subtype_code udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_count public.udd_int := 0;
BEGIN
	select count(*) into v_count 
	from 	trng_trn_ttprogramparticipant
	where 	tprogram_id = _tprogram_id
	and 	tprogrambatch_id = _tprogrambatch_id
	and 	participant_type_code = _participant_type_code
	and 	participant_subtype_code = _participant_subtype_code
	and 	batch_date = _batch_date
	and 	status_code = 'A';
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_participantcount(_tprogram_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_count public.udd_int := 0;
BEGIN
	  select count(pp.*) into v_count 
	  from 	      trng_trn_ttprogram p
	  inner join  trng_trn_ttprogrambatch pb on p.tprogram_id = pb.tprogram_id
	  and 		  p.status_code <> 'I'
	  and         pb.status_code <> 'I'
	  inner join  trng_trn_ttprogramparticipant as pp
	  on          pb.tprogram_id = pp.tprogram_id
	  and         pb.tprogrambatch_id = pp.tprogrambatch_id
	  and         pp.status_code <> 'I'
	  where 	  pp.tprogram_id = _tprogram_id;

	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_participantemailid(_tprogram_id udd_code, _tprogrambatch_id udd_code, _participant_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_email_id public.udd_text := '';
BEGIN
	select  email_id into v_email_id 
	from 	trng_trn_ttprogramparticipant	
	where 	participant_id = _participant_id
	and     tprogram_id = _tprogram_id
	and     tprogrambatch_id = _tprogrambatch_id
	and 	status_code = 'A';
	
	v_email_id = coalesce(v_email_id,'');
	return v_email_id;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_participantmobileno(_tprogram_id udd_code, _tprogrambatch_id udd_code, _participant_id udd_code)
 RETURNS udd_mobile
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		created date : 02-01-2023
	*/
	v_participant_mobileno public.udd_mobile := '';
BEGIN
	select  mobile_no into v_participant_mobileno
	from   	trng_trn_ttprogramparticipant 
	where 	tprogram_id = _tprogram_id
	and 	tprogrambatch_id = _tprogrambatch_id
	and 	participant_id 	= _participant_id
	and 	status_code 	<> 'I';
		
	v_participant_mobileno = coalesce(v_participant_mobileno,'');
	return v_participant_mobileno;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_participantname(_participant_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 15-12-2022
	*/
	v_participant_name public.udd_text := '';
BEGIN
	select  participant_name into 	v_participant_name
	from   	trng_trn_ttprogramparticipant 
	where 	participant_id 	= _participant_id
	and 	status_code 	<> 'I';
		
	v_participant_name = coalesce(v_participant_name,'');
	return v_participant_name;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_participantname(_tprogram_id udd_code, _tprogrambatch_id udd_code, _batch_date udd_date, _participant_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		created date : 31-01-2023
	*/
	v_participant_name public.udd_text := '';
BEGIN
	select  participant_name into 	v_participant_name
	from   	trng_trn_ttprogramparticipant 
	where 	tprogram_id = _tprogram_id
	and 	tprogrambatch_id = _tprogrambatch_id
	and 	batch_date = _batch_date
	and		participant_id 	= _participant_id
	and 	status_code 	<> 'I';
		
	v_participant_name = coalesce(v_participant_name,'');
	return v_participant_name;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_participantpresentcount(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		Created By : Mangai
		Created Date : 18-01-2023
	*/
	v_count public.udd_int := 0;
BEGIN
	  select count(*) into v_count 
	  from 	  trng_trn_ttprogramparticipant 
	  where   tprogram_id = _tprogram_id
	  and     tprogrambatch_id = _tprogrambatch_id
	  and     status_code <> 'I'
	  and 	  attendance_flag = 'QCD_YES';

	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_partpresentcount(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_count public.udd_int := 0;
BEGIN
	  select count(*) into v_count 
	  from 	  trng_trn_ttprogramparticipant 
	  where   tprogram_id = _tprogram_id
	  and     tprogrambatch_id = _tprogrambatch_id
	  and     status_code <> 'I'
	  and 	  attendance_flag = 'QCD_YES';

	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_proglevelgeovalidation(_tprogram_id udd_code, _state_code udd_code, _district_code udd_code, _block_code udd_code, _grampanchayat_code udd_code, _village_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		Created By : Mangai
		Created Date : 23-02-2023
		
		Version No : 1
	*/
	v_result public.udd_text := '';
	v_program_level udd_code := '';
BEGIN
	
	v_program_level := (select fn_get_programlevel(_tprogram_id));
	
	if v_program_level :: udd_int = 89 then
		if (_state_code = '' or _state_code isnull) 
		then
			v_result := 'false';
		end if;
	elseif v_program_level :: udd_int = 79 then
		if (_state_code = '' or _state_code isnull or _district_code = '' or _district_code isnull)
		then
			v_result := 'false';
		end if;
	elseif v_program_level :: udd_int = 69 then
		if (_state_code = '' or _state_code isnull or _district_code = '' or _district_code isnull or
			_block_code = '' or _block_code isnull)
		then
			v_result := 'false';
		end if; 
	elseif v_program_level :: udd_int = 59 then
		if (_state_code = '' or _state_code isnull or _district_code = '' or _district_code isnull or
			_block_code = '' or _block_code isnull or _grampanchayat_code = '' or _grampanchayat_code isnull)
		then
			v_result := 'false';
		end if; 
	elseif v_program_level :: udd_int = 49 then
		if (_state_code = '' or _state_code isnull or _district_code = '' or _district_code isnull or
			_block_code = '' or _block_code isnull or _grampanchayat_code = '' or _grampanchayat_code isnull or
		    _village_code = '' or _village_code isnull)
		then
			v_result := 'false';
		end if; 
	end if;
	
	v_result = coalesce(v_result,'');
	
	if v_result  = '' then
		v_result := 'true';
	end if;
	
	return v_result;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_programenddate(_tprogram_id udd_code)
 RETURNS udd_date
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 06-02-2022
	*/
	
	v_end_date udd_date := null;
BEGIN
	select  end_date into v_end_date
	from   	trng_trn_ttprogram
	where 	tprogram_id 	= _tprogram_id
	and 	status_code not in ('I','R');
		
-- 	v_end_date = coalesce(v_end_date::udd_code,'');
	return v_end_date;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_programlevel(_tprogram_id udd_code)
 RETURNS udd_desc
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 01-02-2023
	*/
	
	v_prng_level udd_desc := '';
BEGIN
	select  tprogram_level_code into v_prng_level
	from   	trng_trn_ttprogram
	where 	tprogram_id 	= _tprogram_id
	and 	status_code not in ('I','R');
		
	v_prng_level = coalesce(v_prng_level,'');
	return v_prng_level;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_programname(_tprogram_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 15-12-2022
	*/
	
	v_prng_name udd_desc := '';
BEGIN
	select  tprogram_name into v_prng_name
	from   	trng_trn_ttprogram
	where 	tprogram_id 	= _tprogram_id
	and 	status_code not in ('I','R');
		
	v_prng_name = coalesce(v_prng_name,'');
	return v_prng_name;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_programstartdate(_tprogram_id udd_code)
 RETURNS udd_date
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 06-02-2022
	*/
	
	v_start_date udd_date := null;
BEGIN
	select  start_date into v_start_date
	from   	trng_trn_ttprogram
	where 	tprogram_id 	= _tprogram_id
	and 	status_code not in ('I','R');
		
-- 	v_start_date = coalesce(v_start_date::udd_code,'');
	return v_start_date;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_questionairegrpid(_question_id udd_code)
 RETURNS udd_code
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 15-12-2022
	*/
	
	v_questionairegrp_id udd_code := '';
BEGIN
	select  questionairegrp_id into v_questionairegrp_id
	from   	trng_mst_tquestion
	where 	question_id = _question_id
	and 	status_code = 'A';
	
	v_questionairegrp_id = coalesce(v_questionairegrp_id,'');
	return v_questionairegrp_id;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_questiondesc(_question_id udd_code, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		created date : 07-11-2022
	*/
	v_question_desc public.udd_text := ''; 
BEGIN
	if _lang_code <> 'en_US' then
		select b.question_desc into v_question_desc 
		from 		trng_mst_tquestion as a 
		inner join 	trng_mst_tquestiontranslate as b 
		on 		a.question_id = b.question_id 
		where 	a.question_id = _question_id
		and 	b.lang_code = _lang_code
		and 	a.status_code = 'A';

		v_question_desc = coalesce(v_question_desc,'');
		
		if v_question_desc <> '' then 
			return v_question_desc;
		else 
			return fn_get_questiondesc(_question_id,'en_US');
		end if;
	end if;
	
	select b.question_desc into v_question_desc 
	from 		trng_mst_tquestion as a 
	inner join 	trng_mst_tquestiontranslate as b 
	on 		a.question_id = b.question_id 
	where 	a.question_id = _question_id
	and 	b.lang_code = 'en_US'
	and 	a.status_code = 'A';
	
	v_question_desc = coalesce(v_question_desc,'');
	
	return v_question_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_questiongroupname(_question_id udd_code, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 15-12-2022
	*/
	
	v_questiongrp_name udd_desc := '';
	v_questionairegrp_code udd_code := '';
	v_questionairegrp_id udd_code := '';
BEGIN
	select  questionairegrp_id into v_questionairegrp_id
	from   	trng_mst_tquestion
	where 	question_id = _question_id
	and 	status_code = 'A';
	
	select questionairegrp_code into v_questionairegrp_code
	from   trng_mst_tquestionairegrp
	where  questionairegrp_id = v_questionairegrp_id
	and    status_code = 'A';
	
	v_questiongrp_name := (select fn_get_masterdesc('QCD_QUESTGRP_CODE',v_questionairegrp_code,_lang_code));
	
	v_questiongrp_name = coalesce(v_questiongrp_name,'');
	return v_questiongrp_name;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_questiongroupseqno(_question_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 15-12-2022
	*/
	
	v_questiongrp_name udd_desc := '';
	v_questionairegrp_seq_no udd_int := 0;
	v_questionairegrp_id udd_code := '';
BEGIN
	select  questionairegrp_id into v_questionairegrp_id
	from   	trng_mst_tquestion
	where 	question_id = _question_id
	and 	status_code = 'A';
	
	select questionairegrp_seq_no into v_questionairegrp_seq_no
	from   trng_mst_tquestionairegrp
	where  questionairegrp_id = v_questionairegrp_id
	and    status_code = 'A';
	
	v_questionairegrp_seq_no = coalesce(v_questionairegrp_seq_no,0);
	return v_questionairegrp_seq_no;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_rolecode(_role_id udd_bigint)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_role_code public.udd_text := '';
BEGIN
	if _role_id = 213 then
		v_role_code := 'SuperAdmin';
	elseif _role_id = 214 then
		v_role_code := 'TrainingMaster';
	elseif _role_id = 215 then
		v_role_code := 'ExternalTrainingCoordinator';
	elseif _role_id = 216 then
		v_role_code := 'TrainingCoordinator';
	end if;
	
	v_role_code = coalesce(v_role_code,'');
	return v_role_code;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_rolename(_role_code udd_code)
 RETURNS udd_desc
 LANGUAGE plpgsql
AS $function$

DECLARE
	v_role_name udd_desc := '';
BEGIN
	select  role_name into v_role_name
	from 	core_mst_trole
	where 	role_code = _role_code;
	
	v_role_name = coalesce(v_role_name,'');
	return v_role_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_rowtimestamp(_trngorg_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Magai
		Created date : 08-11-2022
	*/
	v_trngorg_row_timestamp public.udd_text := '';
BEGIN
	select 	row_timestamp into v_trngorg_row_timestamp
	from 	trng_mst_ttrainingorg
	where 	trngorg_id = _trngorg_id
	and 	trngorg_type_code = 'QCD_GROUP'
	and 	status_code <> 'I';
	
	v_trngorg_row_timestamp := (select to_char(v_trngorg_row_timestamp :: udd_datetime,'DD-MM-YYYY HH:MI:SS:MS'));
	
	v_trngorg_row_timestamp = coalesce(v_trngorg_row_timestamp,null);
	return v_trngorg_row_timestamp;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_screenname(_screen_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_screen_name public.udd_text := '';
BEGIN
	select screen_name into v_screen_name 
	from 		core_mst_tscreen
	where 	screen_code = _screen_code
	and 	status_code = 'A';
	
	v_screen_name = coalesce(v_screen_name,'');
	return v_screen_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_shgname(_shg_id udd_bigint)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 31-01-2023
	*/
	
	v_shg_name udd_desc := '';
BEGIN
	select  shg_name into v_shg_name
	from   	shg_profile_consolidated
	where 	shg_id 	= _shg_id ::udd_bigint
	and     is_active = 'true';
		
	v_shg_name = coalesce(v_shg_name,'');
	return v_shg_name;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_shgname(_participant_id udd_code, _participant_subtype_code udd_code)
 RETURNS udd_code
 LANGUAGE plpgsql
AS $function$
declare
   /*
   created_by   :  Satheesh
   created_date :  24-01-2023
   */
   v_shgname udd_code := '';
begin
   
   IF _participant_subtype_code = 'QCD_INT_CADRE' THEN
	 select shg_name into v_shgname
	 from trng_mst_tcadreuser
	 where cadreuser_id = _participant_id;
	 
   ELSEIF _participant_subtype_code = 'QCD_INT_LOKOS' THEN
	 select shg_name into v_shgname 
	 from shgmember_profileconsolidated_view
	 where shg_member_id = _participant_id ::udd_int;
   END IF;
   
   v_shgname = coalesce(v_shgname,'');
   return v_shgname;

end;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_shgname(_shg_code udd_desc)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 16-02-2023
	*/
	
	v_shg_name udd_desc := '';
BEGIN
	select  shg_name into v_shg_name
	from   	shg_profile_consolidated
	where 	shg_code 	= _shg_code
	and     is_active = 'true';
		
	v_shg_name = coalesce(v_shg_name,'');
	return v_shg_name;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_sp_category_jsonb(_sp_category_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 07-10-2022
	*/
	v_sp_category_jsonb_desc public.udd_jsonb := '[{}]';
BEGIN
	select 
			'['||
				string_agg('{""master_code"":""'||b.sp_category||'"",""master_desc"":""'||
				fn_get_masterdesc('QCD_SP_CATEGORY',b.sp_category,_lang_code)||'""}',',')||
			']' 
			into v_sp_category_jsonb_desc
		from 	jsonb_to_recordset(_sp_category_jsonb) b(sp_category udd_text);
	
	v_sp_category_jsonb_desc = coalesce(v_sp_category_jsonb_desc,'[{}]');
	return v_sp_category_jsonb_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_state_ll_desc(_state_id udd_int, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		created date : 18-10-2022
	*/
	v_state_name_local public.udd_text := '';
	v_state_name_en public.udd_text := '';
BEGIN
	select  state_name_local,state_name_en 
	into 	v_state_name_local,v_state_name_en
	from   	state_master 
	where 	state_id = _state_id;
		
	if _lang_code = 'en_US' then
		v_state_name_en := coalesce(v_state_name_en,'');
		return v_state_name_en;
		
	else 
		v_state_name_local := coalesce(v_state_name_local,v_state_name_en);
		return v_state_name_local;
		
	end if;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_statecode(_state_id udd_int)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_state_code public.udd_text := '';
BEGIN
	select  state_code into v_state_code 
	from 	state_master 
	where 	state_id =  _state_id
	and 	is_active = true ;
	
	v_state_code = coalesce(v_state_code,'');
	
	return v_state_code;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_statedesc(_state_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_state_desc public.udd_text := '';
BEGIN
	select state_name_en into v_state_desc 
	from 		state_master
	where 	state_code = _state_code
	and 	is_active = true;
	
	v_state_desc = coalesce(v_state_desc,'');
	return v_state_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_statedesc(_state_id udd_int)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_state_desc public.udd_text := '';
BEGIN
	select state_name_en into v_state_desc 
	from 		state_master
	where 	state_id = _state_id
	and 	is_active = true;
	
	v_state_desc = coalesce(v_state_desc,'');
	return v_state_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_stateid(_state_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_state_id public.udd_int := 0;
BEGIN
	select state_id into v_state_id 
	from 		state_master
	where 	state_code = _state_code
	and 	is_active = true;
	
	v_state_id = coalesce(v_state_id,0);
	return v_state_id;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_subvertical(_subvertical_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 07-10-2022
	*/
	v_subvertical_desc udd_text := '';
BEGIN
	select 
		string_agg(fn_get_masterdesc('QCD_SUBVERTICAL',b.subvertical,_lang_code) ||'',',')::udd_text into v_subvertical_desc
		from jsonb_to_recordset(_subvertical_jsonb) b(subvertical udd_text);
		
	v_subvertical_desc = coalesce(v_subvertical_desc,'');
	return v_subvertical_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_subvertical_code(_trainer_id udd_code, _subvertical_jsonb udd_jsonb)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 02-11-2022
	*/
	 -- colrec record;
	 v_subvertical_code udd_code := '';
BEGIN
		/*for colrec in 	select a.subvertical from trng_mst_ttrainerdomain,
						jsonb_to_recordset(_subvertical_jsonb) a(subvertical udd_text)
						where trainer_id = _trainer_id
						and status_code = 'A'
		 loop
			return next colrec.subvertical;
		 end loop;*/
		 select a.subvertical into v_subvertical_code from trng_mst_ttrainerdomain,
				jsonb_to_recordset(_subvertical_jsonb) a(subvertical udd_text)
		 where trainer_id = _trainer_id
		 and status_code = 'A';
		
		 v_subvertical_code = coalesce(v_subvertical_code,'');
		 return v_subvertical_code;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_subvertical_code(_subvertical_jsonb udd_jsonb)
 RETURNS SETOF udd_code
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 02-11-2022
	*/
	 colrec record;
BEGIN
		for colrec in 	select a.subvertical from trng_mst_ttrainerdomain,
						jsonb_to_recordset(_subvertical_jsonb) a(subvertical udd_text)
						where status_code = 'A'
		 loop
			return next colrec.subvertical;
		 end loop;
		  
	 return;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_subvertical_jsonb(_subvertical_jsonb udd_jsonb, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 07-10-2022
	*/
	v_subvertical_jsonb_desc public.udd_jsonb := '[{}]';
BEGIN
	select 
			'['||
				string_agg('{""master_code"":""'||b.subvertical||'"",""master_desc"":""'||
				fn_get_masterdesc('QCD_SUBVERTICAL',b.subvertical,_lang_code)||'""}',',')||
			']' 
			into v_subvertical_jsonb_desc
		from 	jsonb_to_recordset(_subvertical_jsonb) b(subvertical udd_text);
	
	v_subvertical_jsonb_desc = coalesce(v_subvertical_jsonb_desc,'[{}]');
	return v_subvertical_jsonb_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_tavailableflag(_trainer_id udd_code, _tprogrambatchid udd_code, _start_date udd_date, _end_date udd_date)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		Created By : Mohan S
		Created Date : 17-10-2022 
	*/
	v_available_flag public.udd_text := 'Y';
BEGIN
	if exists ( select '*' from trng_mst_ttrainer as t
				inner join trng_trn_ttprogramtrainer as tp 
				on t.trainer_id = tp.trainer_id and tp.status_code = 'A'
				inner join trng_trn_ttprogrambatch as tpb 
				on tp.tprogram_id = tpb.tprogram_id and tp.tprogrambatch_id = tpb.tprogrambatch_id
				and tpb.status_code in ('C','P')
			  	where tp.trainer_id = _trainer_id
-- 			    and   tp.tprogrambatch_id = _tprogrambatchid
			  	and   tpb.start_date 
			    between _start_date	and _end_date) then 
				
				v_available_flag := 'N';
	end if;
	
	-- Trainer leave check
	if v_available_flag = 'Y' then
		if exists (select '*' from trng_trn_ttrainerleave
					where trainer_id = _trainer_id
					and status_code = 'A') then 
			v_available_flag := 'N';
		else
			v_available_flag := 'Y';
		end if;
	end if;
	
	return v_available_flag;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_totalbudgetamount(_tprogram_id udd_code)
 RETURNS udd_amount
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_budget_amount public.udd_amount := 0;
BEGIN
	select 	coalesce(sum(budget_amount),0) into v_budget_amount
	from 	trng_trn_ttprogrambudget
	where 	tprogram_id = _tprogram_id
	and   	status_code = 'A';
	
-- 	v_budget_amount = coalesce(v_budget_amount,0);
	return v_budget_amount;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_totalexpenseamount(_tprogram_id udd_code)
 RETURNS udd_amount
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_expense_amount public.udd_amount := 0;
BEGIN
	select 	coalesce(sum(expense_amount),0) into v_expense_amount
	from 	trng_trn_ttprogramexpense
	where 	tprogram_id = _tprogram_id
	and   	status_code = 'A';
	
-- 	v_expense_amount = coalesce(v_expense_amount,0);
	
	return v_expense_amount;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_tprogrambatchcount(_tprogram_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_count public.udd_int := 0;
BEGIN
	select count(*) into v_count 
	from 	trng_trn_ttprogrambatch
	where 	tprogram_id = _tprogram_id
	and 	status_code <> 'I';
	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_tprogramlock(_tprogram_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		created date : 19-01-2023
	*/
	
	v_prng_lock udd_desc := '';
BEGIN
	select  tprogram_lock into v_prng_lock
	from   	core_mst_tmobilesync
	where 	tprogram_id = _tprogram_id
	and		sync_type_code	= 'WTM'	
	and		status_code		= 'A';
		
	v_prng_lock = coalesce(v_prng_lock,'');
	return v_prng_lock;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_tprogrmcourseid(_tprogram_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 03-01-2023
	*/
	v_course_id public.udd_text := '';
BEGIN
	select 	course_id into v_course_id
	from 	trng_trn_ttprogram
	where 	tprogram_id = _tprogram_id
	and 	status_code = 'A';
	
	v_course_id = coalesce(v_course_id,'');
	return v_course_id;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainercount(_tprogram_id udd_code, _tprogrambatch_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_count public.udd_int := 0;
BEGIN
	  select count(pt.*) into v_count 
	  from 	      trng_trn_ttprogram p
	  inner join  trng_trn_ttprogrambatch pb on p.tprogram_id = pb.tprogram_id
	  and 		  p.status_code <> 'I'
	  and         pb.status_code <> 'I'
	  inner join  trng_trn_ttprogramtrainer as pt
	  on          pb.tprogram_id = pt.tprogram_id
	  and         pb.tprogrambatch_id = pt.tprogrambatch_id
	  and         pt.status_code <> 'I'
	  where 	  pt.tprogram_id = _tprogram_id
	  and         pt.tprogrambatch_id = _tprogrambatch_id;

	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainercount(_tprogram_id udd_code)
 RETURNS udd_int
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_count public.udd_int := 0;
BEGIN
	  select count(pt.*) into v_count 
	  from 	      trng_trn_ttprogram p
	  inner join  trng_trn_ttprogrambatch pb on p.tprogram_id = pb.tprogram_id
	  and 		  p.status_code <> 'I'
	  and         pb.status_code <> 'I'
	  inner join  trng_trn_ttprogramtrainer as pt
	  on          pb.tprogram_id = pt.tprogram_id
	  and         pb.tprogrambatch_id = pt.tprogrambatch_id
	  and         pt.status_code <> 'I'
	  where 	  pt.tprogram_id = _tprogram_id;

	
	v_count = coalesce(v_count,0);
	return v_count;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainergroupname(_trainer_id udd_code, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Vijayavel J
		Created date : 02-11-2022
	*/
     colrec record;
BEGIN
     for colrec in 	select 
	 					string_agg(distinct 
				  			case when _lang_code = 'en_US' then 
				  				b.trngorg_name
				  			else
				  				case when b.trngorg_ll_name <> '' then
				  					b.trngorg_ll_name
				  				else
				  					b.trngorg_name
				  				end
				  			end
				  		,',') as trngorg_name 
					from trng_mst_ttrainergroup as a 
					inner join trng_mst_ttrainingorg as b on a.trngorg_id = b.trngorg_id and b.status_code = 'A'
					where a.trainer_id = _trainer_id 
					and a.status_code = 'A'
					group by a.trainer_id
     loop
	 	return colrec.trngorg_name;
     end loop;
	 
	 return 'Not Grouped';
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainerid_subvertical(_trngorg_type_code udd_code, _subvertical_jsonb udd_jsonb)
 RETURNS SETOF text
 LANGUAGE plpgsql
AS $function$
DECLARE _id trng_mst_ttrainer.trainer_id%TYPE;
BEGIN
if _subvertical_jsonb = '[{}]' or _subvertical_jsonb isnull then
	FOR _id IN	select Distinct
							t.trainer_id
				from 		  trng_mst_ttrainer as t
				inner join 	  trng_mst_ttrainerdomain as td on t.trainer_id = td.trainer_id
				and 		  td.status_code = 'A'
				where 		  t.trngorg_type_code = _trngorg_type_code
				and			  t.status_code <> 'I'
	 LOOP
				RETURN NEXT _id;
	 END LOOP;
else
	FOR _id IN	select Distinct
							trainer_id
				from 		  trng_mst_vtrainersubvertical,
				jsonb_to_recordset(_subvertical_jsonb) b(subvertical udd_text)
				where 		  trngorg_type_code = _trngorg_type_code
				and 		  subvertical_code = b.subvertical
				and			  status_code <> 'I'
	 LOOP
				RETURN NEXT _id;
	 END LOOP;
end if;
	 
   RETURN;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainerid_vertical(_trngorg_type_code udd_code, _vertical_code udd_code)
 RETURNS SETOF text
 LANGUAGE plpgsql
AS $function$
DECLARE _id trng_mst_ttrainer.trainer_id%TYPE;
BEGIN

	FOR _id IN	select Distinct
							t.trainer_id
				from 		  trng_mst_ttrainer as t
				inner join 	  trng_mst_ttrainerdomain as td on t.trainer_id = td.trainer_id
				and 		  td.status_code = 'A'
				where 		  t.trngorg_type_code = _trngorg_type_code
				and			  td.vertical_code =
				case 
					when _vertical_code = '' or _vertical_code isnull then
						coalesce(td.vertical_code ,_vertical_code)
					else 
						coalesce(_vertical_code,td.vertical_code) 
				end
				and 		  t.status_code <> 'I'
	 LOOP
				RETURN NEXT _id;
	 END LOOP;
	 
   RETURN;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainerlevel(_trainer_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 03-11-2022
	*/
	v_level_desc udd_text := '';
BEGIN
	select 	trainer_level_code 
	into 	v_level_desc
	from 	trng_mst_ttrainer
	where 	trainer_id = _trainer_id
	and 	status_code <> 'I';
		
	v_level_desc = coalesce(v_level_desc,'');
	return v_level_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainermobileno(_trainer_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		created date : 02-11-2022
	*/
	v_mobile_no public.udd_text := '';
BEGIN
	select  mobile_no into v_mobile_no
	from   	trng_mst_ttrainer 
	where 	trainer_id = _trainer_id
	and 	status_code = 'A';
		
	v_mobile_no = coalesce(v_mobile_no,'0');
	return v_mobile_no;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainername(_trainer_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		created date : 02-11-2022
	*/
	v_trainer_name public.udd_text := '';
BEGIN
	select  trainer_name into v_trainer_name
	from   	trng_mst_ttrainer 
	where 	trainer_id = _trainer_id
	and 	status_code = 'A';
		
	v_trainer_name = coalesce(v_trainer_name,'');
	return v_trainer_name;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainersubvertical(_trainer_id udd_code, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 27-10-2022
	*/
	v_subvertical_desc udd_text := '';
BEGIN
	select 	string_agg(fn_get_masterdesc('QCD_SUBVERTICAL', subvertical_code,_lang_code )||'',',') 
	into 	v_subvertical_desc
	from 	trng_mst_vtrainersubvertical 
	where trainer_id = _trainer_id
	and status_code <> 'I';
		
	v_subvertical_desc = coalesce(v_subvertical_desc,'');
	return v_subvertical_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainervertical(_trainer_id udd_code, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		Created date : 27-10-2022
	*/
	v_vertical_desc udd_text := '';
BEGIN
	select 	string_agg(fn_get_masterdesc('QCD_VERTICAL',vertical_code, _lang_code)||'',',')
	into 	v_vertical_desc
	from 	trng_mst_ttrainerdomain 
	where 	trainer_id = _trainer_id
	and 	status_code <> 'I';
		
	v_vertical_desc = coalesce(v_vertical_desc,'');
	return v_vertical_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainingorglevel(_trngorg_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 01-11-2022
	*/
	v_level_desc udd_text := '';
BEGIN
	select 	trngorg_level_code 
	into 	v_level_desc
	from 	trng_mst_ttrainingorg
	where 	trngorg_id = _trngorg_id
	and 	status_code <> 'I';
		
	v_level_desc = coalesce(v_level_desc,'');
	return v_level_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainingorgname(_trngorg_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 14-02-2022
	*/
	v_trngorg_name udd_text := '';
BEGIN 
	select 	trngorg_name into 	v_trngorg_name
	from 	trng_mst_ttrainingorg
	where 	trngorg_id = _trngorg_id
	and 	status_code <> 'I';
		
	v_trngorg_name = coalesce(v_trngorg_name,'');
	return v_trngorg_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainingorgsubvertical(_trngorgdomain_gid udd_int, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 31-10-2022
	*/
	v_subvertical_desc udd_text := '';
BEGIN
	select 	string_agg(fn_get_masterdesc('QCD_SUBVERTICAL', b.subvertical,_lang_code )||'',',') 
	into 	v_subvertical_desc
	from 	trng_mst_ttrainingorgdomain,
	jsonb_to_recordset(subvertical_jsonb) b(subvertical udd_text)
	where 	trngorgdomain_gid = _trngorgdomain_gid
	and status_code = 'A';

	v_subvertical_desc = coalesce(v_subvertical_desc,'');
	return v_subvertical_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainingorgsubvertical(_trngorg_id udd_code)
 RETURNS SETOF udd_code
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Vijayavel J
		Created date : 27-10-2022
	*/
     colrec record;
BEGIN
     for colrec in 	select subvertical_code from trng_mst_vtrainingorgsubvertical 
	 				where trngorg_id = _trngorg_id 
					and status_code = 'A'
     loop
	 	return next colrec.subvertical_code;
     end loop;
	 
	 return;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainingorgsubvertical_code(_trngorgdomain_gid udd_int, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 31-10-2022
	*/
	v_subvertical_code udd_text := '';
BEGIN
	select 	string_agg(b.subvertical||'',',') 
	into 	v_subvertical_code
	from 	trng_mst_ttrainingorgdomain,
	jsonb_to_recordset(subvertical_jsonb) b(subvertical udd_text)
	where 	trngorgdomain_gid = _trngorgdomain_gid
	and status_code = 'A';

	v_subvertical_code = coalesce(v_subvertical_code,'');
	return v_subvertical_code;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainingorgsubvertical_jsonb(_trngorgdomain_gid udd_int, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		Created date : 25-11-2022
	*/
	v_subvertical_jsonb_desc public.udd_jsonb := '[{}]';
BEGIN
	select 	
		'['||
			string_agg('{""master_code"":""'||b.subvertical||'"",""master_desc"":""'||
				fn_get_masterdesc('QCD_SUBVERTICAL',b.subvertical,_lang_code)||'""}',',')||
		']' 
		into 	v_subvertical_jsonb_desc
	from 	trng_mst_ttrainingorgdomain,
			jsonb_to_recordset(subvertical_jsonb) b(subvertical udd_text)
	where 	trngorgdomain_gid = _trngorgdomain_gid;
	-- and 	status_code = 'A';
		
	v_subvertical_jsonb_desc = coalesce(v_subvertical_jsonb_desc,'[{}]');
	return v_subvertical_jsonb_desc;
	
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trainingorgtype(_trngorg_id udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 26-11-2022
	*/
	v_trngorg_type_code udd_text := '';
BEGIN
	select 	trngorg_type_code into v_trngorg_type_code
	from 	trng_mst_ttrainingorg
	where 	trngorg_id = _trngorg_id
	and 	status_code = 'A';
		
	v_trngorg_type_code = coalesce(v_trngorg_type_code,'');
	return v_trngorg_type_code;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trngorgsubvertical(_trngorg_id udd_code, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 25-11-2022
	*/
	v_subvertical_desc udd_text := '';
BEGIN
	select 	string_agg(fn_get_masterdesc('QCD_SUBVERTICAL', b.subvertical,_lang_code )||'',',') 
	into 	v_subvertical_desc
	from 	trng_mst_ttrainingorgdomain,
	jsonb_to_recordset(subvertical_jsonb) b(subvertical udd_text)
	where 	trngorg_id = _trngorg_id;
	-- and status_code = 'A';
		
	v_subvertical_desc = coalesce(v_subvertical_desc,'');
	return v_subvertical_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_trngorgsubvertical_jsonb(_trngorg_id udd_code, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		Created date : 27-11-2022
	*/
	v_subvertical_jsonb_desc public.udd_jsonb := '[{}]';
BEGIN
	select 	
		'['||
			string_agg('{""master_code"":""'||b.subvertical||'"",""master_desc"":""'||
				fn_get_masterdesc('QCD_SUBVERTICAL',b.subvertical,_lang_code)||'""}',',')||
		']' 
		into 	v_subvertical_jsonb_desc
	from 	trng_mst_ttrainingorgdomain,
			jsonb_to_recordset(subvertical_jsonb) b(subvertical udd_text)
	where 	trngorg_id = _trngorg_id;
	--and 	status_code = 'A';
		
	v_subvertical_jsonb_desc = coalesce(v_subvertical_jsonb_desc,'[{}]');
	return v_subvertical_jsonb_desc;
	
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_userlevelcode(_user_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 30-11-2022
	*/
	v_user_level_code public.udd_text := '';
BEGIN
	select 	user_level_code into v_user_level_code
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';
	
	v_user_level_code = coalesce(v_user_level_code,'');
	return v_user_level_code;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_usermobileno(_user_code udd_code)
 RETURNS udd_desc
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_user_mobileno udd_mobile := '';
BEGIN
	select  mobile_no into v_user_mobileno
	from 	core_mst_tuser
	where 	user_code = _user_code;
	
	v_user_mobileno = coalesce(v_user_mobileno,'');
	return v_user_mobileno;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_username(_user_code udd_code)
 RETURNS udd_desc
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_user_name udd_desc := '';
BEGIN
	select  user_name into v_user_name
	from 	core_mst_tuser
	where 	user_code = _user_code;
	
	v_user_name = coalesce(v_user_name,'');
	return v_user_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_userverticalcode(_user_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan
		Created date : 18-11-2022
	*/
	v_vertical_code public.udd_text := '';
BEGIN
	select 	vertical_code into v_vertical_code
	from 	core_mst_tuser
	where 	user_code = _user_code
	and 	status_code = 'A';
	
	v_vertical_code = coalesce(v_vertical_code,'');
	return v_vertical_code;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_village_ll_desc(_village_id udd_int, _lang_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mohan S
		created date : 18-10-2022
	*/
	v_village_name_local public.udd_text := '';
	v_village_name_en public.udd_text := '';
BEGIN
	select  village_name_local,village_name_en 
	into 	v_village_name_local,v_village_name_en
	from   	village_master 
	where 	village_id = _village_id;
		
	if _lang_code = 'en_US' then
		v_village_name_en := coalesce(v_village_name_en,'');
		return v_village_name_en;
		
	else 
		v_village_name_local := coalesce(v_village_name_local,v_village_name_en);
		return v_village_name_local;
		
	end if;

END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_villagedesc(_village_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_village_desc public.udd_text := '';
BEGIN
	select village_name_en into v_village_desc 
	from 		village_master
	where 	village_code = _village_code
	and 	is_active = true;
	
	v_village_desc = coalesce(v_village_desc,'');
	return v_village_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_villagedesc(_village_id udd_int)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_village_desc public.udd_text := '';
BEGIN
	select village_name_en into v_village_desc 
	from 		village_master
	where 	village_id = _village_id
	and 	is_active = true;
	
	v_village_desc = coalesce(v_village_desc,'');
	return v_village_desc;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_villageid(_village_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_village_id public.udd_int := 0;
BEGIN
	select village_id into v_village_id 
	from 		village_master
	where 	village_code = _village_code
	and 	is_active = true;
	
	v_village_id = coalesce(v_village_id,0);
	return v_village_id;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_get_voname(_vo_cbo_code udd_code)
 RETURNS udd_text
 LANGUAGE plpgsql
AS $function$
DECLARE
	/*
		created by : Mangai
		Created date : 09-02-2023
	*/
	v_vo_name public.udd_text := '';
BEGIN
	 select federation_name into v_vo_name
						   from  federation_profile_consolidated 
						   where parent_cbo_code in (
													select cbo_code from federation_profile_consolidated
							   						where    cbo_type = 2
						   							)
						   and cbo_type = 1
						   and cbo_code = _vo_cbo_code
						   and 	 is_active = true;
	
	v_vo_name = coalesce(v_vo_name,'');
	return v_vo_name;
END;
$function$
"
"CREATE OR REPLACE FUNCTION public.fn_text_todatetime(_datetime udd_text)
 RETURNS udd_datetime
 LANGUAGE plpgsql
AS $function$
declare
	/*
		Created By 		: Vijayavel J
		Created Date 	: 09-03-2022
		Function Code 	:
	*/
begin
  perform _datetime::udd_datetime;
  return _datetime;
exception when others then
  return null;
end;
$function$
"
"CREATE OR REPLACE FUNCTION public.generate_lokos_script(_state_code udd_code, _district_code udd_code, _block_code udd_code, _panchayat_code udd_code, _village_code udd_code, _last_sync_date udd_date)
 RETURNS SETOF text
 LANGUAGE plpgsql
AS $function$
 DECLARE
 	 /*
	 	Created By   : Mangai
		Created Date : 12-04-2023
		
		Version No : 1
	 */
	 
 	 query_condi text;
	 query_condi_2 text;
	 v_table record;
	 v_tables_name udd_jsonb := '[{""tables_name"":""member_profile_consolidated""},{""tables_name"":""shg_profile_consolidated""},
	 							 {""tables_name"":""federation_profile_consolidated""}]';
	v_tablename udd_text := '';
 BEGIN
 	-- build select query
	for v_table in select tables_name from jsonb_to_recordset(v_tables_name) as b (tables_name udd_text)
	loop		
		query_condi := 'select * from ';
		query_condi := query_condi|| v_table.tables_name;
		
		query_condi_2 := query_condi || ' where 1=1 ';

		if _state_code <> '' then
			query_condi_2 := query_condi_2 || ' and state_code = ''' || _state_code || '''';
		end if;

		if _district_code <> '' then
			query_condi_2 := query_condi_2 || ' and district_code = ''' || _district_code || '''';
		end if;

		if _block_code <> '' then
			query_condi_2 := query_condi_2 || ' and block_code = ''' || _block_code || '''';
		end if;

		if _panchayat_code <> '' then
			query_condi_2 := query_condi_2 || ' and gp_code = ''' || _panchayat_code || '''';
		end if;

		if _village_code <> '' then
			query_condi_2 := query_condi_2 || ' and village_code = ''' || _village_code || '''';
		end if;

		if _last_sync_date notnull then
			query_condi_2 := query_condi_2 || ' and (created_date >= ''' || _last_sync_date || ''' '||
											' or last_updated_date >= ''' ||  _last_sync_date || ''') ';
		end if;

		-- execute the query variable 
		if (_state_code = '' and _district_code = '' and _block_code = '' and _panchayat_code = '' 
			and _village_code = '' and _last_sync_date isnull) then
				return next query_condi ||';' ;
				query_condi := '';
		else
				return next query_condi_2 ||';' ;
				query_condi := '';
		end if;
		
		
	end loop;
	
	return;
 END
 
$function$
"
"CREATE OR REPLACE FUNCTION public.generate_mobilesync_script(p_schema text, p_table text, p_where text, p_dest_table text, p_field_ignore text[])
 RETURNS SETOF text
 LANGUAGE plpgsql
AS $function$
 DECLARE
	 i	integer;
	 fld text[];
     dumpquery_0 text;
     dumpquery_1 text;
	 
     selquery text;
     selvalue text;
     valrec record;
     colrec record;
	 
	 colArray text[];
 BEGIN
     -- ------ --
     -- GLOBAL --
     --   build base INSERT
     --   build SELECT array[ ... ]
	 dumpquery_0 := 'INSERT or REPLACE INTO ';
	 
	 if p_dest_table <> '' then
     	dumpquery_0 := dumpquery_0 ||  quote_ident(p_dest_table) || '(';
	 else
     	dumpquery_0 := dumpquery_0 ||  quote_ident(p_table) || '(';
	 end if;
	 
     selquery    := 'SELECT array[';

     <<label0>>
     FOR colrec IN 
	 			select a.* from (SELECT distinct table_schema, table_name, column_name, data_type,ordinal_position
                   FROM information_schema.columns
                   WHERE table_name = p_table and table_schema = p_schema
--                    ORDER BY ordinal_position
				   union all
				   SELECT distinct s.nspname as table_schema,
				   t.relname as table_name,
				   a.attname as column_name,
				   pg_catalog.format_type(a.atttypid, a.atttypmod) as data_type,
				   a.attnum as ordinal_position
				   FROM pg_attribute a
				   JOIN pg_class t on a.attrelid = t.oid
				   JOIN pg_namespace s on t.relnamespace = s.oid
				   WHERE a.attnum > 0 AND NOT a.attisdropped
				   AND t.relname = p_table --<< replace with the name of the MV 
				   AND s.nspname = p_schema --<< change to the schema your MV is in 
				   AND t.relkind = 'm'
-- 				   ORDER BY a.attnum
					) as a order by a.ordinal_position
     LOOP
	 	 if not (quote_ident(colrec.column_name) = ANY(p_field_ignore)) then
			 dumpquery_0 := dumpquery_0 || quote_ident(colrec.column_name) || ',';
			 selquery    := selquery    || 'CAST(' || quote_ident(colrec.column_name) || ' AS TEXT),';

			 colArray := colArray || quote_ident(colrec.column_name);
		 end if;
     END LOOP label0;

     dumpquery_0 := substring(dumpquery_0 ,1,length(dumpquery_0)-1) || ')';
     dumpquery_0 := dumpquery_0 || ' VALUES (';
     selquery    := substring(selquery    ,1,length(selquery)-1)    || '] AS MYARRAY';
     selquery    := selquery    || ' FROM ' ||quote_ident(p_schema)||'.'||quote_ident(p_table);
	 
	 if p_where <> '' then
     	selquery    := selquery    || ' WHERE '||p_where;
	 end if;
     -- GLOBAL --
     -- ------ --

     -- ----------- --
     -- SELECT LOOP --
     --   execute SELECT built and loop on each row
     <<label1>>
     FOR valrec IN  EXECUTE  selquery
     LOOP
         dumpquery_1 := '';
		 i := 1;
		 
         IF not found THEN
             EXIT ;
         END IF;

         -- ----------- --
         -- LOOP ARRAY (EACH FIELDS) --
         <<label2>>
         FOREACH selvalue in ARRAY valrec.MYARRAY
         LOOP
             IF selvalue IS NULL THEN 
				selvalue := 'NULL';
             ELSE 
				selvalue := quote_literal(selvalue);
             END IF;

             dumpquery_1 := dumpquery_1 || selvalue || ',';
			 
			 i := i + 1;
         END LOOP label2;
		 
         dumpquery_1 := substring(dumpquery_1 ,1,length(dumpquery_1)-1) || ')' || ';'; 
         -- LOOP ARRAY (EACH FIELD) --
         -- ----------- --

         -- debug: RETURN NEXT dumpquery_0 || dumpquery_1 || ' --' || selquery;
         -- debug: RETURN NEXT selquery;
         RETURN NEXT dumpquery_0 || dumpquery_1;

     END LOOP label1 ;
     -- SELECT LOOP --
     -- ----------- --

 RETURN ;
 END
 
$function$
"
"CREATE OR REPLACE FUNCTION public.urlencode(text)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE STRICT
AS $function$
  select
    string_agg(
      case
        when ol>1 or ch !~ '[0-9a-zA-Z:/@._?#-]+' 
          then regexp_replace(upper(substring(ch::bytea::text, 3)), '(..)', E'%\\1', 'g')
        else ch
      end,
      ''
    )
  from (
    select ch, octet_length(ch) as ol
    from regexp_split_to_table($1, '') as ch
  ) as s;
$function$
"
