--
-- PostgreSQL database dump
--

-- Dumped from database version 13.9
-- Dumped by pg_dump version 14.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: core_mst_vmastertranslate; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.core_mst_vmastertranslate AS
 SELECT b.master_desc,
    a.parent_code,
    a.depend_code
   FROM (public.core_mst_tmaster a
     JOIN public.core_mst_tmastertranslate b ON (((b.master_code)::text = (a.master_code)::text)))
  WHERE ((a.status_code)::text = 'A'::text);


ALTER TABLE public.core_mst_vmastertranslate OWNER TO postgres;

--
-- Name: federation_profile_consolidated_clf; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.federation_profile_consolidated_clf AS
 SELECT federation_profile_consolidated.cbo_type,
    federation_profile_consolidated.cbo_code AS clf_cbo_code,
    federation_profile_consolidated.federation_name AS clf_name
   FROM public.federation_profile_consolidated
  WHERE (federation_profile_consolidated.cbo_type = 2);


ALTER TABLE public.federation_profile_consolidated_clf OWNER TO flexi;

--
-- Name: screendata_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.screendata_view AS
 SELECT concat((core_mst_tscreendata.screen_code COLLATE "default"), ',', regexp_replace(((core_mst_tscreendata.ctrl_id)::text COLLATE "default"), '[ ]'::text, ''::text, 'g'::text), ',', replace(((core_mst_tscreendata.data_field)::text COLLATE "default"), 'null'::text, ''::text)) AS concat_field,
    core_mst_tscreendata.screendata_gid,
    core_mst_tscreendata.screen_code,
    core_mst_tscreendata.lang_code,
    core_mst_tscreendata.ctrl_type_code,
    core_mst_tscreendata.ctrl_id,
    core_mst_tscreendata.data_field,
    core_mst_tscreendata.label_desc,
    core_mst_tscreendata.tooltip_desc,
    core_mst_tscreendata.default_label_desc,
    core_mst_tscreendata.default_tooltip_desc,
    core_mst_tscreendata.ctrl_slno,
    core_mst_tscreendata.created_date,
    core_mst_tscreendata.created_by,
    core_mst_tscreendata.updated_date,
    core_mst_tscreendata.updated_by
   FROM public.core_mst_tscreendata;


ALTER TABLE public.screendata_view OWNER TO postgres;

--
-- Name: shgmember_profileconsolidated_view; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.shgmember_profileconsolidated_view AS
 SELECT mem.state_id,
    mem.state_code,
    mem.district_id,
    mem.district_code,
    mem.block_id,
    mem.block_code,
    mem.gp_id AS panchayat_id,
    mem.gp_code AS panchayat_code,
    mem.village_id,
    mem.village_code,
    shg.shg_code AS shg_id,
    shg.shg_code,
    shg.shg_name,
    shg.shg_name_local,
    mem.member_code AS shg_member_id,
    mem.member_name AS shg_member_name,
    mem.member_name_local AS shg_member_name_local,
    mem.relation_name AS shg_member_relation_name,
    mem.relation_name_local AS shg_member_relation_name_local,
    mem.gender,
    mem.dob,
    mem.age,
    mem.age_as_on,
    mem.phone1_mobile_no AS member_phone,
    mem.created_date,
    mem.last_updated_date,
    c.cbo_code AS vo_cbo_code,
    c.federation_name AS vo_name,
    d.clf_cbo_code,
    d.clf_name
   FROM (((public.member_profile_consolidated mem
     JOIN public.shg_profile_consolidated shg ON ((((shg.shg_code)::text = (mem.shg_code)::text) AND (shg.is_active = true))))
     JOIN public.federation_profile_consolidated c ON ((((shg.parent_cbo_code)::text = (c.cbo_code)::text) AND (c.cbo_type = 1) AND (c.is_active = true))))
     JOIN public.federation_profile_consolidated_clf d ON (((c.parent_cbo_code)::text = (d.clf_cbo_code)::text)));


ALTER TABLE public.shgmember_profileconsolidated_view OWNER TO flexi;

--
-- Name: shgmember_profileconsolidated_usergeo_view; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.shgmember_profileconsolidated_usergeo_view AS
 SELECT a.state_id,
    a.state_code,
    a.district_id,
    a.district_code,
    a.block_id,
    a.block_code,
    a.panchayat_id,
    a.panchayat_code,
    a.village_id,
    a.village_code,
    a.shg_id,
    a.shg_code,
    a.shg_name,
    a.shg_name_local,
    a.shg_member_id,
    a.shg_member_name,
    a.shg_member_name_local,
    a.shg_member_relation_name,
    a.shg_member_relation_name_local,
    a.gender,
    a.dob,
    a.age,
    a.age_as_on,
    a.member_phone,
    a.created_date,
    a.last_updated_date,
    a.vo_cbo_code,
    a.vo_name,
    a.clf_cbo_code,
    a.clf_name,
    b.user_code,
    b.user_level_code
   FROM (public.shgmember_profileconsolidated_view a
     JOIN public.core_mst_tuser b ON ((((btrim((a.state_code)::text) = btrim((b.state_code)::text)) AND (btrim((a.district_code)::text) = btrim((b.district_code)::text)) AND (btrim((a.block_code)::text) = btrim((b.block_code)::text)) AND (btrim((a.panchayat_code)::text) = btrim((b.panchayat_code)::text))) OR (btrim((a.village_code)::text) = btrim((b.village_code)::text)))))
  WHERE (((b.user_level_code)::text <= '59'::text) AND ((b.status_code)::text = 'A'::text));


ALTER TABLE public.shgmember_profileconsolidated_usergeo_view OWNER TO flexi;

--
-- Name: shgparticipant_profileconsolidated_view; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.shgparticipant_profileconsolidated_view AS
 SELECT e.tprogram_id,
    mem.state_id,
    mem.state_code,
    mem.district_id,
    mem.district_code,
    mem.block_id,
    mem.block_code,
    mem.gp_id AS panchayat_id,
    mem.gp_code AS panchayat_code,
    mem.village_id,
    mem.village_code,
    shg.shg_code AS shg_id,
    shg.shg_code,
    shg.shg_name,
    shg.shg_name_local,
    mem.member_code AS shg_member_id,
    mem.member_name AS shg_member_name,
    mem.member_name_local AS shg_member_name_local,
    mem.relation_name AS shg_member_relation_name,
    mem.relation_name_local AS shg_member_relation_name_local,
    mem.gender,
    mem.dob,
    mem.age,
    mem.age_as_on,
    mem.phone1_mobile_no AS member_phone,
    mem.created_date,
    mem.last_updated_date,
    c.cbo_code AS vo_cbo_code,
    c.federation_name AS vo_name,
    d.clf_cbo_code,
    d.clf_name
   FROM ((((public.member_profile_consolidated mem
     JOIN public.shg_profile_consolidated shg ON ((((shg.shg_code)::text = (mem.shg_code)::text) AND (shg.is_active = true))))
     JOIN public.federation_profile_consolidated c ON ((((shg.parent_cbo_code)::text = (c.cbo_code)::text) AND (c.cbo_type = 1) AND (c.is_active = true))))
     JOIN public.federation_profile_consolidated_clf d ON (((c.parent_cbo_code)::text = (d.clf_cbo_code)::text)))
     JOIN public.trng_trn_ttprogramparticipant e ON ((((shg.shg_code)::text = (e.shg_id)::text) AND ((mem.member_code)::text = (e.participant_id)::text) AND ((e.status_code)::text = 'A'::text))));


ALTER TABLE public.shgparticipant_profileconsolidated_view OWNER TO flexi;

--
-- Name: trng_mst_tcourse_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_tcourse_view AS
 SELECT c.course_gid,
    c.course_id,
    c.course_name,
    c.course_ll_name,
    c.course_desc,
    c.course_level_jsonb,
    c.course_type_jsonb,
    c.subvertical_jsonb,
    c.category_jsonb,
    c.sp_category_jsonb,
    c.participant_jsonb,
    c.vertical_code,
    c.course_duration_days,
    c.course_duration_hours,
    c.validity_from,
    c.validity_to,
    c.indefinite_flag,
    c.min_participant_count,
    c.max_participant_count,
    ca.approver_id,
    ca.courseapproval_gid,
    to_char((c.row_timestamp)::timestamp without time zone, 'DD-MM-YYYY HH:MI:SS:MS'::text) AS row_timestamp,
    c.status_code,
    c.certificate_flag
   FROM (public.trng_mst_tcourse c
     LEFT JOIN public.trng_mst_tcourseapproval ca ON ((((c.course_id)::text = (ca.course_id)::text) AND ((ca.approval_status_code)::text = ANY (ARRAY[('s'::character varying)::text, ('A'::character varying)::text])))));


ALTER TABLE public.trng_mst_tcourse_view OWNER TO postgres;

--
-- Name: trng_mst_ttrainer_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_ttrainer_view AS
 SELECT DISTINCT t.trainer_id,
    tto.trngorg_id,
    t.mobile_no,
    t.trainer_name,
    t.trainer_type_code,
    t.trngorg_type_code,
    t.email_id,
    t.trainer_level_code,
    td.vertical_code,
    (td.subvertical_jsonb)::public.udd_text AS subvertical_jsonb,
    t.status_code,
    t.gender_code,
    t.resource_type_code,
    td.subvertical_jsonb AS org_subvertical_jsonb,
    t.validity_from,
    t.validity_to,
    t.indefinite_flag,
    t.trainer_ll_name
   FROM ((public.trng_mst_ttrainer t
     JOIN public.trng_mst_ttrainingorg tto ON ((((t.trngorg_id)::text = (tto.trngorg_id)::text) AND ((tto.status_code)::text = 'A'::text))))
     LEFT JOIN public.trng_mst_ttrainerdomain td ON ((((t.trainer_id)::text = (td.trainer_id)::text) AND ((td.status_code)::text = 'A'::text))));


ALTER TABLE public.trng_mst_ttrainer_view OWNER TO postgres;

--
-- Name: trng_mst_ttrainergroup_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_ttrainergroup_view AS
 SELECT t.trainer_id,
    t.trainer_name,
    t.mobile_no,
    t.trainer_type_code,
    tg.trngorg_type_code,
    t.email_id,
    t.trainer_level_code,
    tor.trngorg_id,
    td.vertical_code,
    td.subvertical_jsonb,
    public.fn_get_groupname(tor.trngorg_id) AS group_name,
    t.status_code
   FROM (((public.trng_mst_ttrainer t
     JOIN public.trng_mst_ttrainingorg tor ON ((((t.trngorg_id)::text = (tor.trngorg_id)::text) AND ((tor.status_code)::text = 'A'::text))))
     JOIN public.trng_mst_ttrainergroup tg ON ((((t.trainer_id)::text = (tg.trainer_id)::text) AND ((tor.trngorg_id)::text = (tg.trngorg_id)::text) AND ((tor.trngorg_type_code)::text = (tg.trngorg_type_code)::text))))
     LEFT JOIN public.trng_mst_ttrainerdomain td ON ((((t.trainer_id)::text = (td.trainer_id)::text) AND ((td.status_code)::text = 'A'::text))));


ALTER TABLE public.trng_mst_ttrainergroup_view OWNER TO postgres;

--
-- Name: trng_mst_ttrainingorg_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_ttrainingorg_view AS
 SELECT ct.course_id,
    t.trainer_id,
    t.trainer_name,
    t.mobile_no,
    t.trainer_type_code,
    t.email_id,
    t.trainer_level_code,
    tor.trngorg_id,
    tor.trngorg_name
   FROM ((public.trng_mst_ttrainer t
     JOIN public.trng_mst_ttrainingorg tor ON ((((t.trngorg_id)::text = (tor.trngorg_id)::text) AND ((tor.status_code)::text = 'A'::text))))
     JOIN public.trng_mst_tcoursetrainer ct ON ((((t.trainer_id)::text = (ct.trainer_id)::text) AND ((ct.status_code)::text = 'A'::text))))
  WHERE (((tor.trngorg_type_code)::text = 'QCD_ORGANIZATION'::text) AND ((t.status_code)::text = 'A'::text));


ALTER TABLE public.trng_mst_ttrainingorg_view OWNER TO postgres;

--
-- Name: trng_mst_tvenueaddr_view; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_tvenueaddr_view AS
 SELECT DISTINCT a.venueaddr_gid,
    a.venue_id,
    a.addr_line,
    a.addr_pincode,
    a.state_code,
    s.state_name_en AS state_desc,
    a.district_code,
    d.district_name_en AS district_desc,
    a.block_code,
    b.block_name_en AS block_desc,
    a.grampanchayat_code,
    p.panchayat_name_en AS panchayat_desc,
    a.village_code,
    v.village_name_en AS village_desc,
    a.status_code,
    a.created_date,
    a.created_by,
    a.updated_date,
    a.updated_by
   FROM (((((public.trng_mst_tvenueaddr a
     LEFT JOIN public.state_master s ON (((a.state_code)::bpchar = s.state_code)))
     LEFT JOIN public.district_master d ON (((a.district_code)::bpchar = d.district_code)))
     LEFT JOIN public.block_master b ON (((a.block_code)::bpchar = b.block_code)))
     LEFT JOIN public.panchayat_master p ON (((a.grampanchayat_code)::bpchar = p.panchayat_code)))
     LEFT JOIN public.village_master v ON (((a.village_code)::bpchar = v.village_code)));


ALTER TABLE public.trng_mst_tvenueaddr_view OWNER TO flexi;

--
-- Name: trng_mst_tvenueinfra_view; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_tvenueinfra_view AS
 SELECT a.venueinfra_gid,
    a.venue_id,
    a.facility_name,
    a.addr_line,
    a.addr_pincode,
    a.state_code,
    s.state_name_en AS state_desc,
    a.district_code,
    d.district_name_en AS district_desc,
    a.block_code,
    b.block_name_en AS block_desc,
    a.grampanchayat_code,
    p.panchayat_name_en AS panchayat_desc,
    a.village_code,
    v.village_name_en AS village_desc,
    a.conf_room_count,
    a.conf_room_capacity,
    a.accom_overnight_flag,
    a.accom_overnight_capacity,
    a.status_code,
    a.created_date,
    a.created_by,
    a.updated_date,
    a.updated_by,
    a.facility_id
   FROM (((((public.trng_mst_tvenueinfra a
     LEFT JOIN public.state_master s ON (((a.state_code)::bpchar = s.state_code)))
     LEFT JOIN public.district_master d ON (((a.district_code)::bpchar = d.district_code)))
     LEFT JOIN public.block_master b ON (((a.block_code)::bpchar = b.block_code)))
     LEFT JOIN public.panchayat_master p ON (((a.grampanchayat_code)::bpchar = p.panchayat_code)))
     LEFT JOIN public.village_master v ON (((a.village_code)::bpchar = v.village_code)));


ALTER TABLE public.trng_mst_tvenueinfra_view OWNER TO flexi;

--
-- Name: trng_mst_vcourselevel; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_vcourselevel AS
 SELECT a.course_level,
    trng_mst_tcourse.status_code,
    trng_mst_tcourse.course_id
   FROM public.trng_mst_tcourse,
    LATERAL jsonb_to_recordset((trng_mst_tcourse.course_level_jsonb)::jsonb) a(course_level public.udd_text)
  WHERE ((trng_mst_tcourse.status_code)::text <> 'I'::text);


ALTER TABLE public.trng_mst_vcourselevel OWNER TO postgres;

--
-- Name: trng_mst_vcoursesubvertical; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_vcoursesubvertical AS
 SELECT a.course_gid,
    a.course_id,
    a.course_name,
    a.course_ll_name,
    a.vertical_code,
    b.subvertical AS subvertical_code,
    a.status_code
   FROM public.trng_mst_tcourse a,
    LATERAL jsonb_to_recordset((a.subvertical_jsonb)::jsonb) b(subvertical public.udd_code);


ALTER TABLE public.trng_mst_vcoursesubvertical OWNER TO postgres;

--
-- Name: trng_mst_vmappedvenue; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vmappedvenue AS
 SELECT DISTINCT t.tprogram_id,
    tv.venue_gid,
    tv.venue_id,
    tv.venue_name,
    tv.venue_ll_name,
    tv.venue_type_code,
    tv.venue_subtype_code,
    tv.contact_name,
    tv.contact_mobile_no,
    tv.validity_from,
    tv.validity_to,
    tv.indefinite_flag,
    tv.others_flag,
    tv.status_code,
    tv.created_date,
    tv.created_by,
    tv.updated_date,
    tv.updated_by,
    tv.row_timestamp,
    tv.deactivation_reason_code
   FROM ((public.trng_trn_ttprogram t
     JOIN public.trng_trn_ttprogrambatch tb ON ((((t.tprogram_id)::text = (tb.tprogram_id)::text) AND ((tb.status_code)::text <> 'I'::text))))
     JOIN public.trng_mst_tvenue tv ON (((tv.venue_id)::text = (tb.tprogram_venue_id)::text)))
  WHERE ((tv.status_code)::text = 'A'::text);


ALTER TABLE public.trng_mst_vmappedvenue OWNER TO flexi;

--
-- Name: trng_mst_vmappedvenueaddr; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vmappedvenueaddr AS
 SELECT DISTINCT v.tprogram_id,
    va.venueaddr_gid,
    va.venue_id,
    va.addr_line,
    va.addr_pincode,
    va.state_code,
    s.state_name_en AS state_desc,
    va.district_code,
    d.district_name_en AS district_desc,
    va.block_code,
    b.block_name_en AS block_desc,
    va.grampanchayat_code,
    p.panchayat_name_en AS panchayat_desc,
    va.village_code,
    vi.village_name_en AS village_desc,
    va.status_code,
    va.created_by,
    va.created_date,
    va.updated_by,
    va.updated_date
   FROM ((((((public.trng_mst_vmappedvenue v
     JOIN public.trng_mst_tvenueaddr va ON ((((v.venue_id)::text = (va.venue_id)::text) AND ((va.status_code)::text = 'A'::text))))
     LEFT JOIN public.state_master_mv s ON (((va.state_code)::bpchar = s.state_code)))
     LEFT JOIN public.district_master_mv d ON (((va.district_code)::bpchar = d.district_code)))
     LEFT JOIN public.block_master_mv b ON (((va.block_code)::bpchar = b.block_code)))
     LEFT JOIN public.panchayat_master_mv p ON (((va.grampanchayat_code)::bpchar = p.panchayat_code)))
     LEFT JOIN public.village_master_mv vi ON (((va.village_code)::bpchar = vi.village_code)))
  WHERE ((va.status_code)::text = 'A'::text);


ALTER TABLE public.trng_mst_vmappedvenueaddr OWNER TO flexi;

--
-- Name: trng_mst_vmappedvenueinfra; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vmappedvenueinfra AS
 SELECT DISTINCT va.tprogram_id,
    i.venueinfra_gid,
    i.venue_id,
    i.facility_id,
    i.facility_name,
    i.addr_line,
    i.addr_pincode,
    i.state_code,
    va.state_desc,
    i.district_code,
    va.district_desc,
    i.block_code,
    va.block_desc,
    i.grampanchayat_code,
    va.panchayat_desc,
    i.village_code,
    va.village_desc,
    i.conf_room_count,
    i.conf_room_capacity,
    i.accom_overnight_flag,
    i.accom_overnight_capacity,
    i.status_code,
    i.created_by,
    i.created_date,
    i.updated_by,
    i.updated_date
   FROM (public.trng_mst_vmappedvenueaddr va
     JOIN public.trng_mst_tvenueinfra i ON (((va.venue_id)::text = (i.venue_id)::text)))
  WHERE ((i.status_code)::text = 'A'::text);


ALTER TABLE public.trng_mst_vmappedvenueinfra OWNER TO flexi;

--
-- Name: trng_mst_vmappedvenueinfradtl; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vmappedvenueinfradtl AS
 SELECT DISTINCT i.tprogram_id,
    b.venueinfradtl_gid,
    b.venue_id,
    b.facility_id,
    b.infra_type,
    b.infra_count,
    b.status_code,
    b.created_by,
    b.created_date,
    b.updated_by,
    b.updated_date
   FROM (public.trng_mst_vmappedvenueinfra i
     JOIN public.trng_mst_tvenueinfradtl b ON ((((i.venue_id)::text = (b.venue_id)::text) AND ((i.facility_id)::text = (b.facility_id)::text))))
  WHERE ((b.status_code)::text = 'A'::text);


ALTER TABLE public.trng_mst_vmappedvenueinfradtl OWNER TO flexi;

--
-- Name: trng_mst_vquestionairecourse; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_vquestionairecourse AS
 SELECT trng_mst_tquestionaire.questionaire_id,
    trng_mst_tquestionaire.course_jsonb,
    a.course AS course_id,
    trng_mst_tquestionaire.questionaire_type_code
   FROM public.trng_mst_tquestionaire,
    LATERAL jsonb_to_recordset((trng_mst_tquestionaire.course_jsonb)::jsonb) a(course public.udd_text)
  WHERE ((trng_mst_tquestionaire.status_code)::text = 'A'::text);


ALTER TABLE public.trng_mst_vquestionairecourse OWNER TO postgres;

--
-- Name: trng_mst_vquestionairelang; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_vquestionairelang AS
 SELECT trng_mst_tquestionaire.questionaire_id,
    trng_mst_tquestionaire.lang_jsonb,
    a.language AS lang_code
   FROM public.trng_mst_tquestionaire,
    LATERAL jsonb_to_recordset((trng_mst_tquestionaire.lang_jsonb)::jsonb) a(language public.udd_text);


ALTER TABLE public.trng_mst_vquestionairelang OWNER TO postgres;

--
-- Name: trng_mst_vtprogramgeotrainer; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vtprogramgeotrainer AS
 SELECT DISTINCT t.tprogram_id,
    trn.trainer_gid,
    trn.trngorg_id,
    trn.trngorg_type_code,
    trn.trainer_id,
    trn.trainer_name,
    trn.trainer_ll_name,
    trn.trainer_type_code,
    trn.trainer_level_code,
    trn.mobile_no,
    trn.email_id,
    trn.gender_code,
    trn.resource_type_code,
    trn.trainer_qualification,
    trn.validity_from,
    trn.validity_to,
    trn.indefinite_flag,
    trn.photo_file_name,
    trn.photo_file_path,
    trn.status_code,
    trn.created_date,
    trn.created_by,
    trn.updated_date,
    trn.updated_by,
    trn.row_timestamp,
    trn.cadre_id,
    trn.deactivation_reason_code
   FROM (((((((public.trng_trn_ttprogram t
     JOIN public.trng_trn_ttprogramgeo tg ON (((t.tprogram_id)::text = (tg.tprogram_id)::text)))
     JOIN public.trng_mst_ttrainergeo ta ON ((((tg.grampanchayat_code)::text = (ta.grampanchayat_code)::text) AND ((ta.status_code)::text = 'A'::text))))
     JOIN public.trng_mst_ttrainer trn ON ((((ta.trainer_id)::text = (trn.trainer_id)::text) AND ((trn.status_code)::text = 'A'::text))))
     JOIN public.state_master_mv s ON (((ta.state_code)::bpchar = s.state_code)))
     JOIN public.district_master_mv d ON (((ta.district_code)::bpchar = d.district_code)))
     JOIN public.block_master_mv b ON (((ta.block_code)::bpchar = b.block_code)))
     JOIN public.panchayat_master_mv p ON (((ta.grampanchayat_code)::bpchar = p.panchayat_code)))
  WHERE ((t.status_code)::text <> 'I'::text);


ALTER TABLE public.trng_mst_vtprogramgeotrainer OWNER TO flexi;

--
-- Name: trng_mst_vtprogramgeotrainerdomain; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vtprogramgeotrainerdomain AS
 SELECT DISTINCT t.tprogram_id,
    td.trainerdomain_gid,
    td.trainer_id,
    td.vertical_code,
    td.subvertical_jsonb,
    td.area_of_experience,
    td.yrs_of_experience,
    td.status_code,
    td.created_date,
    td.created_by,
    td.updated_date,
    td.updated_by
   FROM (public.trng_mst_vtprogramgeotrainer t
     JOIN public.trng_mst_ttrainerdomain td ON (((t.trainer_id)::text = (td.trainer_id)::text)))
  WHERE ((td.status_code)::text = 'A'::text);


ALTER TABLE public.trng_mst_vtprogramgeotrainerdomain OWNER TO flexi;

--
-- Name: trng_mst_vtprogramgeotrainingorgdomain; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vtprogramgeotrainingorgdomain AS
 SELECT DISTINCT t.tprogram_id,
    td.trngorgdomain_gid,
    td.trngorg_id,
    td.vertical_code,
    td.subvertical_jsonb,
    td.area_of_experience,
    td.yrs_of_experience,
    td.status_code,
    trn.created_date,
    trn.created_by,
    trn.updated_date,
    trn.updated_by
   FROM ((((((((public.trng_trn_ttprogram t
     JOIN public.trng_trn_ttprogramgeo tg ON (((t.tprogram_id)::text = (tg.tprogram_id)::text)))
     JOIN public.trng_mst_ttrainingorggeo ta ON ((((tg.grampanchayat_code)::text = (ta.grampanchayat_code)::text) AND ((ta.status_code)::text = 'A'::text))))
     JOIN public.trng_mst_ttrainingorgdomain td ON ((((ta.trngorg_id)::text = (td.trngorg_id)::text) AND ((td.status_code)::text = 'A'::text))))
     JOIN public.trng_mst_ttrainingorg trn ON ((((td.trngorg_id)::text = (trn.trngorg_id)::text) AND ((trn.status_code)::text = 'A'::text))))
     JOIN public.state_master_mv s ON (((ta.state_code)::bpchar = s.state_code)))
     JOIN public.district_master_mv d ON (((ta.district_code)::bpchar = d.district_code)))
     JOIN public.block_master_mv b ON (((ta.block_code)::bpchar = b.block_code)))
     JOIN public.panchayat_master_mv p ON (((ta.grampanchayat_code)::bpchar = p.panchayat_code)))
  WHERE ((t.status_code)::text <> 'I'::text);


ALTER TABLE public.trng_mst_vtprogramgeotrainingorgdomain OWNER TO flexi;

--
-- Name: trng_mst_vtprogramgeotrainingorg; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vtprogramgeotrainingorg AS
 SELECT DISTINCT t.tprogram_id,
    trn.trngorg_gid,
    trn.trngorg_id,
    trn.trngorg_name,
    trn.trngorg_ll_name,
    trn.trngorg_type_code,
    trn.trngorg_level_code,
    trn.mobile_no,
    trn.email_id,
    trn.validity_from,
    trn.validity_to,
    trn.indefinite_flag,
    trn.sys_flag,
    trn.status_code,
    trn.created_date,
    trn.created_by,
    trn.updated_date,
    trn.updated_by,
    trn.row_timestamp,
    trn.deactivation_reason_code,
    trn.contact_person
   FROM (public.trng_mst_vtprogramgeotrainingorgdomain t
     JOIN public.trng_mst_ttrainingorg trn ON (((t.trngorg_id)::text = (trn.trngorg_id)::text)))
  WHERE ((trn.status_code)::text <> 'I'::text);


ALTER TABLE public.trng_mst_vtprogramgeotrainingorg OWNER TO flexi;

--
-- Name: trng_mst_vtprogramgeovenueaddr; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vtprogramgeovenueaddr AS
 SELECT DISTINCT t.tprogram_id,
    va.venueaddr_gid,
    va.venue_id,
    va.addr_line,
    va.addr_pincode,
    va.state_code,
    s.state_name_en AS state_desc,
    va.district_code,
    d.district_name_en AS district_desc,
    va.block_code,
    b.block_name_en AS block_desc,
    va.grampanchayat_code,
    p.panchayat_name_en AS panchayat_desc,
    va.village_code,
    vi.village_name_en AS village_desc,
    va.status_code,
    va.created_by,
    va.created_date,
    va.updated_by,
    va.updated_date
   FROM ((((((((public.trng_trn_ttprogram t
     JOIN public.trng_trn_ttprogramgeo tg ON (((t.tprogram_id)::text = (tg.tprogram_id)::text)))
     JOIN public.trng_mst_tvenueaddr va ON ((((tg.grampanchayat_code)::text = (va.grampanchayat_code)::text) AND ((tg.village_code)::text = (COALESCE(va.village_code, tg.village_code))::text) AND ((va.status_code)::text = 'A'::text))))
     JOIN public.trng_mst_tvenue v ON ((((va.venue_id)::text = (v.venue_id)::text) AND ((v.status_code)::text = 'A'::text))))
     JOIN public.state_master_mv s ON (((va.state_code)::bpchar = s.state_code)))
     JOIN public.district_master_mv d ON (((va.district_code)::bpchar = d.district_code)))
     JOIN public.block_master_mv b ON (((va.block_code)::bpchar = b.block_code)))
     JOIN public.panchayat_master_mv p ON (((va.grampanchayat_code)::bpchar = p.panchayat_code)))
     LEFT JOIN public.village_master_mv vi ON (((va.village_code)::bpchar = vi.village_code)))
  WHERE ((t.status_code)::text <> 'I'::text);


ALTER TABLE public.trng_mst_vtprogramgeovenueaddr OWNER TO flexi;

--
-- Name: trng_mst_vtprogramgeovenue; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vtprogramgeovenue AS
 SELECT DISTINCT va.tprogram_id,
    v.venue_gid,
    v.venue_id,
    v.venue_name,
    v.venue_ll_name,
    v.venue_type_code,
    v.venue_subtype_code,
    v.contact_name,
    v.contact_mobile_no,
    v.validity_from,
    v.validity_to,
    v.indefinite_flag,
    v.others_flag,
    v.status_code,
    v.created_date,
    v.created_by,
    v.updated_date,
    v.updated_by,
    v.row_timestamp,
    v.deactivation_reason_code
   FROM (public.trng_mst_tvenue v
     JOIN public.trng_mst_vtprogramgeovenueaddr va ON (((va.venue_id)::text = (v.venue_id)::text)))
  WHERE ((v.status_code)::text = 'A'::text);


ALTER TABLE public.trng_mst_vtprogramgeovenue OWNER TO flexi;

--
-- Name: trng_mst_vtprogramgeovenueinfra; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vtprogramgeovenueinfra AS
 SELECT DISTINCT va.tprogram_id,
    i.venueinfra_gid,
    i.venue_id,
    i.facility_id,
    i.facility_name,
    i.addr_line,
    i.addr_pincode,
    i.state_code,
    va.state_desc,
    i.district_code,
    va.district_desc,
    i.block_code,
    va.block_desc,
    i.grampanchayat_code,
    va.panchayat_desc,
    i.village_code,
    va.village_desc,
    i.conf_room_count,
    i.conf_room_capacity,
    i.accom_overnight_flag,
    i.accom_overnight_capacity,
    i.status_code,
    i.created_by,
    i.created_date,
    i.updated_by,
    i.updated_date
   FROM (public.trng_mst_tvenueinfra i
     JOIN public.trng_mst_vtprogramgeovenueaddr va ON (((i.venue_id)::text = (va.venue_id)::text)))
  WHERE ((i.status_code)::text = 'A'::text);


ALTER TABLE public.trng_mst_vtprogramgeovenueinfra OWNER TO flexi;

--
-- Name: trng_mst_vtprogramgeovenueinfradtl; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vtprogramgeovenueinfradtl AS
 SELECT DISTINCT i.tprogram_id,
    b.venueinfradtl_gid,
    b.venue_id,
    b.facility_id,
    b.infra_type,
    b.infra_count,
    b.status_code,
    b.created_by,
    b.created_date,
    b.updated_by,
    b.updated_date
   FROM (public.trng_mst_tvenueinfradtl b
     JOIN public.trng_mst_vtprogramgeovenueinfra i ON ((((b.venue_id)::text = (i.venue_id)::text) AND ((b.facility_id)::text = (i.facility_id)::text))))
  WHERE ((b.status_code)::text = 'A'::text);


ALTER TABLE public.trng_mst_vtprogramgeovenueinfradtl OWNER TO flexi;

--
-- Name: trng_mst_vtprogrammaptrainer; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vtprogrammaptrainer AS
 SELECT DISTINCT t.tprogram_id,
    trn.trainer_gid,
    trn.trngorg_id,
    trn.trngorg_type_code,
    trn.trainer_id,
    trn.trainer_name,
    trn.trainer_ll_name,
    trn.trainer_type_code,
    trn.trainer_level_code,
    trn.mobile_no,
    trn.email_id,
    trn.gender_code,
    trn.resource_type_code,
    trn.trainer_qualification,
    trn.validity_from,
    trn.validity_to,
    trn.indefinite_flag,
    trn.photo_file_name,
    trn.photo_file_path,
    trn.status_code,
    trn.created_date,
    trn.created_by,
    trn.updated_date,
    trn.updated_by,
    trn.row_timestamp,
    trn.cadre_id,
    trn.deactivation_reason_code
   FROM ((public.trng_trn_ttprogram t
     JOIN public.trng_trn_ttprogramtrainer tg ON ((((t.tprogram_id)::text = (tg.tprogram_id)::text) AND ((tg.status_code)::text = 'A'::text))))
     JOIN public.trng_mst_ttrainer trn ON (((tg.trainer_id)::text = (trn.trainer_id)::text)))
  WHERE ((trn.status_code)::text = 'A'::text);


ALTER TABLE public.trng_mst_vtprogrammaptrainer OWNER TO flexi;

--
-- Name: trng_mst_vtprogrammaptrainerdomain; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vtprogrammaptrainerdomain AS
 SELECT DISTINCT t.tprogram_id,
    td.trainerdomain_gid,
    td.trainer_id,
    td.vertical_code,
    td.subvertical_jsonb,
    td.area_of_experience,
    td.yrs_of_experience,
    td.status_code,
    td.created_date,
    td.created_by,
    td.updated_date,
    td.updated_by
   FROM (public.trng_mst_vtprogrammaptrainer t
     JOIN public.trng_mst_ttrainerdomain td ON (((t.trainer_id)::text = (td.trainer_id)::text)))
  WHERE ((td.status_code)::text = 'A'::text);


ALTER TABLE public.trng_mst_vtprogrammaptrainerdomain OWNER TO flexi;

--
-- Name: trng_mst_vtrainersubvertical; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_mst_vtrainersubvertical AS
 SELECT a.trainer_gid,
    a.trngorg_id,
    a.trngorg_type_code,
    a.trainer_id,
    a.trainer_name,
    a.trainer_ll_name,
    b.vertical_code,
    a.trainer_level_code,
    c.subvertical AS subvertical_code,
    a.status_code
   FROM public.trng_mst_ttrainer a,
    public.trng_mst_ttrainerdomain b,
    LATERAL jsonb_to_recordset((b.subvertical_jsonb)::jsonb) c(subvertical public.udd_code)
  WHERE ((a.trainer_id)::text = (b.trainer_id)::text);


ALTER TABLE public.trng_mst_vtrainersubvertical OWNER TO flexi;

--
-- Name: trng_mst_vtrainingorg; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_vtrainingorg AS
 SELECT tor.trngorg_id,
    tor.trngorg_name,
    tordo.vertical_code,
    tor.trngorg_type_code
   FROM (public.trng_mst_ttrainingorg tor
     LEFT JOIN public.trng_mst_ttrainingorgdomain tordo ON ((((tor.trngorg_id)::text = (tordo.trngorg_id)::text) AND ((tor.status_code)::text = 'A'::text))));


ALTER TABLE public.trng_mst_vtrainingorg OWNER TO postgres;

--
-- Name: trng_mst_vtrainingorgsubvertical; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_vtrainingorgsubvertical AS
 SELECT a.trngorg_gid,
    a.trngorg_id,
    a.trngorg_name,
    a.trngorg_ll_name,
    a.trngorg_type_code,
    a.trngorg_level_code,
    b.vertical_code,
    b.status_code,
    c.subvertical AS subvertical_code,
    a.created_by
   FROM public.trng_mst_ttrainingorg a,
    public.trng_mst_ttrainingorgdomain b,
    LATERAL jsonb_to_recordset((b.subvertical_jsonb)::jsonb) c(subvertical public.udd_code)
  WHERE ((a.trngorg_id)::text = (b.trngorg_id)::text);


ALTER TABLE public.trng_mst_vtrainingorgsubvertical OWNER TO postgres;

--
-- Name: trng_mst_vtrainingorgsubvertical_v1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_vtrainingorgsubvertical_v1 AS
 SELECT a.trngorg_gid,
    a.trngorg_id,
    a.trngorg_name,
    a.trngorg_ll_name,
    a.trngorg_type_code,
    a.trngorg_level_code,
    b.vertical_code,
    a.status_code,
    b.subvertical_jsonb,
    a.created_by,
    c.subvertical AS subvertical_code
   FROM public.trng_mst_ttrainingorg a,
    public.trng_mst_ttrainingorgdomain b,
    LATERAL jsonb_to_recordset((b.subvertical_jsonb)::jsonb) c(subvertical public.udd_code)
  WHERE ((a.trngorg_id)::text = (b.trngorg_id)::text);


ALTER TABLE public.trng_mst_vtrainingorgsubvertical_v1 OWNER TO postgres;

--
-- Name: trng_mst_vtrnggroupvertical; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_vtrnggroupvertical AS
 SELECT a.trngorg_id,
    a.trngorg_name,
    b.vertical_code,
    a.trngorg_type_code
   FROM (public.trng_mst_ttrainingorg a
     JOIN public.trng_mst_ttrainingorgdomain b ON ((((a.trngorg_id)::text = (b.trngorg_id)::text) AND ((b.status_code)::text = 'A'::text))))
  WHERE (((a.status_code)::text = 'A'::text) AND ((a.trngorg_type_code)::text = 'QCD_GROUP'::text));


ALTER TABLE public.trng_mst_vtrnggroupvertical OWNER TO postgres;

--
-- Name: trng_mst_vtrngorgvertical; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_mst_vtrngorgvertical AS
 SELECT a.trngorg_id,
    a.trngorg_name,
    b.vertical_code,
    a.trngorg_type_code
   FROM (public.trng_mst_ttrainingorg a
     JOIN public.trng_mst_ttrainingorgdomain b ON ((((a.trngorg_id)::text = (b.trngorg_id)::text) AND ((b.status_code)::text = 'A'::text))))
  WHERE (((a.status_code)::text = 'A'::text) AND ((a.trngorg_type_code)::text = 'QCD_ORGANIZATION'::text));


ALTER TABLE public.trng_mst_vtrngorgvertical OWNER TO postgres;

--
-- Name: trng_trn_ttprogram_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_trn_ttprogram_view AS
 SELECT p.tprogram_gid,
    p.tprogram_id,
    p.tprogram_name,
    p.tprogram_ll_name,
    p.course_id,
    p.coordinator_id,
    p.tprogram_level_code,
    p.start_date,
    p.end_date,
    p.no_of_days,
    p.no_of_batches,
    p.budget_amount,
    p.actual_amount,
    p.budget_remark,
    p.execution_status_code,
    p.execution_status_date,
    p.status_code,
    p.row_timestamp,
    p.deactivation_reason_code,
    pa.programapproval_gid,
    pa.initiated_date,
    pa.approver_id,
    pa.approval_date,
    pa.approval_status_code,
    pa.reject_reason_code,
    pa.approver_remark,
    p.created_by
   FROM (public.trng_trn_ttprogram p
     LEFT JOIN public.trng_trn_ttprogramapproval pa ON ((((p.tprogram_id)::text = (pa.tprogram_id)::text) AND ((pa.approval_status_code)::text = ANY (ARRAY[('S'::character varying)::text, ('A'::character varying)::text, ('B'::character varying)::text, ('R'::character varying)::text])))));


ALTER TABLE public.trng_trn_ttprogram_view OWNER TO postgres;

--
-- Name: trng_trn_ttprogramgeo_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_trn_ttprogramgeo_view AS
 SELECT trng_trn_ttprogramgeo.tprogramgeo_gid,
    trng_trn_ttprogramgeo.tprogram_id,
    trng_trn_ttprogramgeo.tprogram_level_code,
    trng_trn_ttprogramgeo.state_code,
    public.fn_get_statedesc(trng_trn_ttprogramgeo.state_code) AS state_desc,
    trng_trn_ttprogramgeo.district_code,
    public.fn_get_districtdesc(trng_trn_ttprogramgeo.district_code) AS district_desc,
    trng_trn_ttprogramgeo.block_code,
    public.fn_get_blockdesc(trng_trn_ttprogramgeo.block_code) AS block_desc,
    trng_trn_ttprogramgeo.grampanchayat_code,
    public.fn_get_panchayatdesc(trng_trn_ttprogramgeo.grampanchayat_code) AS panchayat_desc,
    trng_trn_ttprogramgeo.village_code,
    public.fn_get_villagedesc(trng_trn_ttprogramgeo.village_code) AS village_desc,
    trng_trn_ttprogramgeo.status_code,
    trng_trn_ttprogramgeo.created_date,
    trng_trn_ttprogramgeo.created_by,
    trng_trn_ttprogramgeo.updated_date,
    trng_trn_ttprogramgeo.updated_by,
    public.fn_get_blockid(trng_trn_ttprogramgeo.block_code) AS block_id,
    public.fn_get_districtid(trng_trn_ttprogramgeo.district_code) AS district_id,
    public.fn_get_panchayatid(trng_trn_ttprogramgeo.grampanchayat_code) AS panchayat_id,
    public.fn_get_stateid(trng_trn_ttprogramgeo.state_code) AS state_id,
    public.fn_get_villageid(trng_trn_ttprogramgeo.village_code) AS village_id
   FROM public.trng_trn_ttprogramgeo;


ALTER TABLE public.trng_trn_ttprogramgeo_view OWNER TO postgres;

--
-- Name: trng_trn_vtprogram; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_trn_vtprogram AS
 SELECT p.tprogram_gid,
    p.tprogram_id,
    p.tprogram_name,
    p.tprogram_ll_name,
    p.course_id,
    c.vertical_code,
    p.coordinator_id,
    p.tprogram_level_code,
    p.start_date,
    p.end_date,
    p.no_of_days,
    p.no_of_batches,
    p.budget_amount,
    p.actual_amount,
    p.budget_remark,
    p.execution_status_code,
    p.execution_status_date,
    p.status_code,
    p.created_date,
    p.created_by,
    p.updated_date,
    p.updated_by,
    p.row_timestamp,
    p.deactivation_reason_code
   FROM (public.trng_trn_ttprogram p
     JOIN public.trng_mst_tcourse c ON ((((p.course_id)::text = (c.course_id)::text) AND ((c.status_code)::text = 'A'::text) AND ((p.status_code)::text = 'A'::text))));


ALTER TABLE public.trng_trn_vtprogram OWNER TO flexi;

--
-- Name: trng_trn_vtprogramsubvertical; Type: VIEW; Schema: public; Owner: flexi
--

CREATE VIEW public.trng_trn_vtprogramsubvertical AS
 SELECT DISTINCT a.tprogram_gid,
    a.tprogram_id,
    a.course_id,
    a.tprogram_name,
    a.tprogram_ll_name,
    a.tprogram_level_code,
    a.start_date,
    a.end_date,
    b.subvertical_jsonb,
    a.row_timestamp,
    a.execution_status_code,
    b.vertical_code,
    a.status_code
   FROM (public.trng_trn_ttprogram a
     JOIN public.trng_mst_tcourse b ON ((((a.course_id)::text = (b.course_id)::text) AND ((b.status_code)::text = 'A'::text))))
  WHERE ((a.status_code)::text = 'A'::text);


ALTER TABLE public.trng_trn_vtprogramsubvertical OWNER TO flexi;

--
-- Name: trng_trn_vtprogramvertical; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trng_trn_vtprogramvertical AS
 SELECT b.vertical_code,
    a.tprogram_id
   FROM (public.trng_trn_ttprogram a
     JOIN public.trng_mst_tcourse b ON ((((a.course_id)::text = (b.course_id)::text) AND ((b.status_code)::text = 'A'::text))))
  WHERE ((a.status_code)::text = 'A'::text);


ALTER TABLE public.trng_trn_vtprogramvertical OWNER TO postgres;

--
-- PostgreSQL database dump complete
--

