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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bank_branch_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank_branch_master (
    bank_branch_id bigint DEFAULT nextval('public.bank_branch_master_copy_bank_branch_id_seq'::regclass) NOT NULL,
    bank_id integer,
    bank_code character varying(10) DEFAULT NULL::character varying,
    bank_branch_code integer,
    bank_branch_name character varying(200) DEFAULT NULL::character varying,
    ifsc_code character varying(20) DEFAULT NULL::character varying,
    bank_branch_address character varying(255) DEFAULT NULL::character varying,
    rural_urban_branch character varying(1) DEFAULT NULL::character varying,
    village_id integer,
    block_id integer,
    district_id integer,
    state_id integer,
    pincode character varying(6) DEFAULT NULL::character varying,
    branch_merged_with integer,
    is_active boolean NOT NULL,
    created_date timestamp without time zone,
    created_by character varying NOT NULL,
    updated_date timestamp without time zone,
    updated_by integer,
    entity_code character varying(30)
);


ALTER TABLE public.bank_branch_master OWNER TO postgres;

--
-- Name: bank_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank_master (
    bank_id integer DEFAULT nextval('public.bank_master_bank_id_seq'::regclass) NOT NULL,
    language_id character varying(2),
    bank_code character varying(10),
    bank_name character varying(100),
    bank_shortname character varying(20),
    bank_type smallint,
    ifsc_mask character varying(11),
    bank_merged_with character varying(20),
    bank_level smallint,
    is_active smallint,
    created_date timestamp without time zone,
    created_by integer,
    updated_date timestamp without time zone,
    updated_by integer,
    bank_account_len character varying(20)
);


ALTER TABLE public.bank_master OWNER TO postgres;

--
-- Name: block_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.block_master (
    block_id integer NOT NULL,
    state_id integer,
    district_id integer,
    block_code character(7),
    block_name_en character varying(100),
    block_name_local character varying(200),
    block_short_name_en character varying(20),
    block_short_name_local character varying(40),
    rural_urban_area character varying(1),
    language_id character varying(2),
    is_active boolean DEFAULT true NOT NULL,
    created_date timestamp without time zone NOT NULL,
    created_by integer NOT NULL,
    updated_date timestamp without time zone,
    updated_by integer
);


ALTER TABLE public.block_master OWNER TO postgres;

--
-- Name: block_master_copy_block_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.block_master_copy_block_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.block_master_copy_block_id_seq OWNER TO postgres;

--
-- Name: block_master_copy_block_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.block_master_copy_block_id_seq OWNED BY public.block_master.block_id;


--
-- Name: ccp_district_state; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.ccp_district_state (
    entitycode character varying NOT NULL,
    name character varying NOT NULL,
    hub_father_name character varying NOT NULL,
    gender character varying NOT NULL,
    contact_no character varying NOT NULL,
    social_category character varying NOT NULL,
    aadhar_no character varying,
    dob character varying NOT NULL,
    marital_status character varying NOT NULL,
    education character varying NOT NULL,
    address character varying NOT NULL,
    bank_code character varying,
    branch_code character varying,
    acc_no character varying,
    trainer_from character varying NOT NULL,
    ccp_id integer NOT NULL,
    pri_sub integer NOT NULL,
    pri_no_days integer NOT NULL,
    entered_on character varying,
    entered_by character varying,
    modified_on character varying,
    modified_by character varying,
    email_id character varying NOT NULL,
    aadhar_valid character varying
);


ALTER TABLE public.ccp_district_state OWNER TO flexi;

--
-- Name: ccp_district_state_sub; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.ccp_district_state_sub (
    sub_id integer NOT NULL,
    ccp_id integer,
    add_subject character varying,
    num_days integer
);


ALTER TABLE public.ccp_district_state_sub OWNER TO flexi;

--
-- Name: community_cadre_profile; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.community_cadre_profile (
    ccp_id integer NOT NULL,
    block_code character varying NOT NULL,
    grampanchayat_code character varying NOT NULL,
    village_code character varying NOT NULL,
    member_status character varying(1) NOT NULL,
    shg_code character varying,
    member_code character varying,
    shg_join_date character varying,
    ccp_name character varying,
    belonging_name character varying NOT NULL,
    gender character varying(1) NOT NULL,
    contact_no character varying,
    social_category character varying NOT NULL,
    religion character varying(1) NOT NULL,
    adhaar_no character varying,
    secc_tin character varying,
    dob character varying NOT NULL,
    marital_status character varying(1) NOT NULL,
    education character varying NOT NULL,
    other_education character varying,
    address character varying NOT NULL,
    working_date character varying NOT NULL,
    curr_work_status character varying(1) NOT NULL,
    acc_banck_code character varying NOT NULL,
    acc_branch_code character varying,
    acc_no character varying,
    cadre_group_prim character varying NOT NULL,
    carde_type_prim character varying NOT NULL,
    vo_code character varying,
    clf_code character varying,
    blf_code character varying,
    training_received_status character varying(1),
    vulner_category character varying NOT NULL,
    ccp_image bytea,
    ccp_image_name character varying,
    shg_form_date character varying,
    entered_on date,
    entered_by character varying,
    modified_on date,
    modified_by character varying,
    pri_bank_code character varying,
    pri_branch_code character varying,
    mst_cadre_group_prim character varying,
    mst_carde_type_prim character varying,
    mst_pri_bank_code character varying,
    mst_pri_branch_code character varying,
    other_cadre_group_prim character varying,
    other_carde_type_prim character varying,
    other_pri_bank_code character varying,
    other_pri_branch_code character varying,
    mst_cadre_group_two character varying,
    mst_carde_type_two character varying,
    mst_pri_bank_two character varying,
    mst_pri_branch_two character varying,
    mst_cadre_group_three character varying,
    mst_carde_type_three character varying,
    mst_pri_bank_three character varying,
    mst_pri_branch_three character varying,
    mst_cadre_group_four character varying,
    mst_carde_type_four character varying,
    mst_pri_bank_four character varying,
    mst_pri_branch_four character varying,
    other_cadre_group_two character varying,
    other_carde_type_two character varying,
    other_bank_code_two character varying,
    other_branch_code_two character varying,
    other_cadre_group_three character varying,
    other_carde_type_three character varying,
    other_bank_code_three character varying,
    other_branch_code_three character varying,
    other_cadre_group_four character varying,
    other_carde_type_four character varying,
    other_bank_code_four character varying,
    other_branch_code_four character varying,
    aadhar_valid character varying(1)
);


ALTER TABLE public.community_cadre_profile OWNER TO flexi;

--
-- Name: core_mst_tconfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tconfig (
    config_gid integer DEFAULT nextval('public.core_mst_tconfig_config_gid_seq'::regclass) NOT NULL,
    config_name public.udd_desc NOT NULL,
    config_value public.udd_desc NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tconfig OWNER TO postgres;

--
-- Name: core_mst_tdevicedocnum; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tdevicedocnum (
    devicedocnum_gid integer DEFAULT nextval('public.core_mst_tdevicedocnum_devicedocnum_gid_seq'::regclass) NOT NULL,
    activity_code public.udd_code NOT NULL,
    devicetoken public.udd_text NOT NULL,
    tran_date public.udd_date NOT NULL,
    next_seq_no public.udd_int NOT NULL,
    docnum_format public.udd_code,
    docnum_remark public.udd_desc,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tdevicedocnum OWNER TO postgres;

--
-- Name: core_mst_tdocnum; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tdocnum (
    docnum_gid integer DEFAULT nextval('public.core_mst_tdocnum_docnum_gid_seq'::regclass) NOT NULL,
    activity_code public.udd_code NOT NULL,
    docnum_seq_no public.udd_int NOT NULL,
    docnum_remark public.udd_desc,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tdocnum OWNER TO postgres;

--
-- Name: core_mst_temailtemplate; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.core_mst_temailtemplate (
    emailtemplate_gid integer DEFAULT nextval('public.core_mst_temailtemplate_emailtemplate_gid_seq'::regclass) NOT NULL,
    emailtemplate_code public.udd_code NOT NULL,
    email_template public.udd_text NOT NULL,
    lang_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_temailtemplate OWNER TO flexi;

--
-- Name: core_mst_tifsc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tifsc (
    ifsc_gid integer DEFAULT nextval('public.core_mst_tifsc_ifsc_gid_seq'::regclass) NOT NULL,
    ifsc_code public.udd_code NOT NULL,
    bank_code public.udd_code NOT NULL,
    bank_name public.udd_desc NOT NULL,
    branch_name public.udd_desc,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tifsc OWNER TO postgres;

--
-- Name: core_mst_tinterfaceurl; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tinterfaceurl (
    ifaceurl_gid integer DEFAULT nextval('public.core_mst_tinterfaceurl_ifaceurl_gid_seq'::regclass) NOT NULL,
    ifaceurl_code public.udd_code NOT NULL,
    ifaceurl_name public.udd_desc NOT NULL,
    iface_url public.udd_text,
    user_id public.udd_code NOT NULL,
    user_pwd public.udd_text,
    user_role_id public.udd_mobile,
    tenant_id public.udd_desc,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tinterfaceurl OWNER TO postgres;

--
-- Name: core_mst_tlanguage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tlanguage (
    lang_gid integer DEFAULT nextval('public.core_mst_tlanguage_lang_gid_seq'::regclass) NOT NULL,
    lang_code public.udd_code NOT NULL,
    lang_name public.udd_desc NOT NULL,
    default_flag public.udd_flag NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tlanguage OWNER TO postgres;

--
-- Name: core_mst_tmaster; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tmaster (
    master_gid integer DEFAULT nextval('public.core_mst_tmaster_master_gid_seq'::regclass) NOT NULL,
    parent_code public.udd_code NOT NULL,
    master_code public.udd_code NOT NULL,
    depend_parent_code public.udd_code,
    depend_code public.udd_code,
    rec_slno public.udd_int,
    sys_flag public.udd_flag NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    row_timestamp public.udd_datetime NOT NULL
);


ALTER TABLE public.core_mst_tmaster OWNER TO postgres;

--
-- Name: core_mst_tmastertranslate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tmastertranslate (
    mastertranslate_gid integer DEFAULT nextval('public.core_mst_tmastertranslate_mastertranslate_gid_seq'::regclass) NOT NULL,
    parent_code public.udd_code NOT NULL,
    master_code public.udd_code NOT NULL,
    lang_code public.udd_code NOT NULL,
    master_desc public.udd_desc NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_code NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_code
);


ALTER TABLE public.core_mst_tmastertranslate OWNER TO postgres;

--
-- Name: core_mst_tmenu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tmenu (
    menu_gid integer DEFAULT nextval('public.core_mst_tmenu_menu_gid_seq'::regclass) NOT NULL,
    menu_code public.udd_code NOT NULL,
    parent_code public.udd_code NOT NULL,
    menu_slno public.udd_amount,
    url_action_method public.udd_desc,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    menu_type_code public.udd_code
);


ALTER TABLE public.core_mst_tmenu OWNER TO postgres;

--
-- Name: core_mst_tmenutranslate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tmenutranslate (
    menutranslate_gid integer DEFAULT nextval('public.core_mst_tmenutranslate_menutranslate_gid_seq'::regclass) NOT NULL,
    menu_code public.udd_code NOT NULL,
    lang_code public.udd_code NOT NULL,
    menu_desc public.udd_desc NOT NULL,
    created_date public.udd_datetime,
    created_by public.udd_code,
    updated_date public.udd_datetime,
    updated_by public.udd_code
);


ALTER TABLE public.core_mst_tmenutranslate OWNER TO postgres;

--
-- Name: core_mst_tmessage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tmessage (
    msg_gid integer DEFAULT nextval('public.core_mst_tmessage_msg_gid_seq'::regclass) NOT NULL,
    msg_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tmessage OWNER TO postgres;

--
-- Name: core_mst_tmessagetranslate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tmessagetranslate (
    msgtranslate_gid integer DEFAULT nextval('public.core_mst_tmessagetranslate_msgtranslate_gid_seq'::regclass) NOT NULL,
    msg_code public.udd_code NOT NULL,
    lang_code public.udd_code NOT NULL,
    msg_desc public.udd_desc NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_code NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_code
);


ALTER TABLE public.core_mst_tmessagetranslate OWNER TO postgres;

--
-- Name: core_mst_tmetadata; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.core_mst_tmetadata (
    metadata_gid integer NOT NULL,
    metadata_code public.udd_code NOT NULL,
    metadata_name public.udd_desc NOT NULL,
    metadata_type_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tmetadata OWNER TO flexi;

--
-- Name: core_mst_tmetadata_metadata_gid_seq; Type: SEQUENCE; Schema: public; Owner: flexi
--

CREATE SEQUENCE public.core_mst_tmetadata_metadata_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_mst_tmetadata_metadata_gid_seq OWNER TO flexi;

--
-- Name: core_mst_tmetadata_metadata_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flexi
--

ALTER SEQUENCE public.core_mst_tmetadata_metadata_gid_seq OWNED BY public.core_mst_tmetadata.metadata_gid;


--
-- Name: core_mst_tmetadatamsg; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.core_mst_tmetadatamsg (
    metadatamsg_gid integer NOT NULL,
    metadata_code public.udd_code NOT NULL,
    msg_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tmetadatamsg OWNER TO flexi;

--
-- Name: core_mst_tmetadatamsg_metadatamsg_gid_seq; Type: SEQUENCE; Schema: public; Owner: flexi
--

CREATE SEQUENCE public.core_mst_tmetadatamsg_metadatamsg_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_mst_tmetadatamsg_metadatamsg_gid_seq OWNER TO flexi;

--
-- Name: core_mst_tmetadatamsg_metadatamsg_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flexi
--

ALTER SEQUENCE public.core_mst_tmetadatamsg_metadatamsg_gid_seq OWNED BY public.core_mst_tmetadatamsg.metadatamsg_gid;


--
-- Name: core_mst_tmobilesync; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tmobilesync (
    mobilesync_gid integer DEFAULT nextval('public.core_mst_tmobilesync_mobilesync_gid_seq'::regclass) NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    role_code public.udd_code NOT NULL,
    user_code public.udd_code NOT NULL,
    mobile_no public.udd_mobile,
    sync_type_code public.udd_code NOT NULL,
    last_sync_date public.udd_datetime NOT NULL,
    prev_last_sync_date public.udd_datetime,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    tprogram_lock public.udd_flag
);


ALTER TABLE public.core_mst_tmobilesync OWNER TO postgres;

--
-- Name: core_mst_tmobilesynctable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tmobilesynctable (
    mobilesynctable_gid integer DEFAULT nextval('public.core_mst_tmobilesynctable_mobilesynctable_gid_seq'::regclass) NOT NULL,
    db_schema_name public.udd_desc NOT NULL,
    src_table_name public.udd_desc NOT NULL,
    dest_table_name public.udd_desc NOT NULL,
    conflict_key public.udd_text[] NOT NULL,
    ignore_fields_onupdate public.udd_text[],
    default_condition public.udd_text,
    sync_group_name public.udd_desc NOT NULL,
    table_order public.udd_int,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    ignore_fields public.udd_text[],
    date_flag public.udd_flag,
    role_code public.udd_code,
    user_flag public.udd_code DEFAULT 'N'::character varying NOT NULL,
    role_flag public.udd_code DEFAULT 'N'::character varying NOT NULL,
    mobile_flag public.udd_code DEFAULT 'N'::character varying NOT NULL,
    trngprogram_flag public.udd_flag,
    activity_ref_flag public.udd_flag,
    offline_flag public.udd_flag DEFAULT 'N'::character varying,
    trainer_flag public.udd_flag DEFAULT 'N'::character varying NOT NULL
);


ALTER TABLE public.core_mst_tmobilesynctable OWNER TO postgres;

--
-- Name: core_mst_tpatchqry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tpatchqry (
    patchqry_gid integer DEFAULT nextval('public.core_mst_tpatchqry_patchqry_gid_seq'::regclass) NOT NULL,
    patch_no public.udd_int NOT NULL,
    patch_qry public.udd_text NOT NULL,
    role_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tpatchqry OWNER TO postgres;

--
-- Name: core_mst_trole; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_trole (
    role_gid integer DEFAULT nextval('public.core_mst_trole_role_gid_seq'::regclass) NOT NULL,
    role_code public.udd_code NOT NULL,
    role_name public.udd_desc NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    row_timestamp public.udd_datetime NOT NULL
);


ALTER TABLE public.core_mst_trole OWNER TO postgres;

--
-- Name: core_mst_trolemenurights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_trolemenurights (
    rolemenurights_gid integer DEFAULT nextval('public.core_mst_trolemenurights_rolemenurights_gid_seq'::regclass) NOT NULL,
    role_code public.udd_code NOT NULL,
    menu_code public.udd_code NOT NULL,
    add_flag public.udd_desc NOT NULL,
    modifiy_flag public.udd_flag NOT NULL,
    view_flag public.udd_flag NOT NULL,
    auth_flag public.udd_flag NOT NULL,
    print_flag public.udd_flag NOT NULL,
    inactive_flag public.udd_flag NOT NULL,
    deny_flag public.udd_flag NOT NULL
);


ALTER TABLE public.core_mst_trolemenurights OWNER TO postgres;

--
-- Name: core_mst_tscreen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tscreen (
    screen_gid integer DEFAULT nextval('public.core_mst_tscreen_screen_gid_seq'::regclass) NOT NULL,
    screen_code public.udd_code NOT NULL,
    screen_name public.udd_desc NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tscreen OWNER TO postgres;

--
-- Name: core_mst_tscreendata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tscreendata (
    screendata_gid integer DEFAULT nextval('public.core_mst_tscreendata_screendata_gid_seq'::regclass) NOT NULL,
    screen_code public.udd_code NOT NULL,
    lang_code public.udd_code,
    ctrl_type_code public.udd_code NOT NULL,
    ctrl_id public.udd_desc NOT NULL,
    data_field public.udd_desc,
    label_desc public.udd_desc,
    tooltip_desc public.udd_desc,
    default_label_desc public.udd_desc,
    default_tooltip_desc public.udd_desc,
    ctrl_slno public.udd_decimal,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tscreendata OWNER TO postgres;

--
-- Name: core_mst_tscreensp; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.core_mst_tscreensp (
    screensp_gid integer NOT NULL,
    screen_code public.udd_code NOT NULL,
    sp_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tscreensp OWNER TO flexi;

--
-- Name: core_mst_tscreensp_screensp_gid_seq; Type: SEQUENCE; Schema: public; Owner: flexi
--

CREATE SEQUENCE public.core_mst_tscreensp_screensp_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_mst_tscreensp_screensp_gid_seq OWNER TO flexi;

--
-- Name: core_mst_tscreensp_screensp_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flexi
--

ALTER SEQUENCE public.core_mst_tscreensp_screensp_gid_seq OWNED BY public.core_mst_tscreensp.screensp_gid;


--
-- Name: core_mst_tsmstemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tsmstemplate (
    smstemplate_gid integer DEFAULT nextval('public.core_mst_tsmstemplate_smstemplate_gid_seq'::regclass) NOT NULL,
    smstemplate_code public.udd_code NOT NULL,
    sms_template public.udd_text NOT NULL,
    dlt_template_id public.udd_code NOT NULL,
    lang_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tsmstemplate OWNER TO postgres;

--
-- Name: core_mst_ttenantidentifier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_ttenantidentifier (
    tenant_gid integer DEFAULT nextval('public.core_mst_ttenantidentifier_tenant_gid_seq'::regclass) NOT NULL,
    tenant_identifier public.udd_code NOT NULL,
    geo_location_flag public.udd_flag NOT NULL,
    bank_branch_flag public.udd_flag NOT NULL,
    shg_profile_flag public.udd_flag,
    tenant_user public.udd_user,
    tenant_password public.udd_desc,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    state_id public.udd_int
);


ALTER TABLE public.core_mst_ttenantidentifier OWNER TO postgres;

--
-- Name: core_mst_tuser; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tuser (
    user_gid integer DEFAULT nextval('public.core_mst_tuser_user_gid_seq'::regclass) NOT NULL,
    user_code public.udd_code NOT NULL,
    user_name public.udd_desc NOT NULL,
    role_code public.udd_code NOT NULL,
    user_pwd public.udd_text,
    mobile_no public.udd_mobile,
    email_id public.udd_desc,
    user_type_code public.udd_code,
    lokos_id public.udd_code,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    vertical_code public.udd_code,
    state_code public.udd_code,
    district_code public.udd_code,
    block_code public.udd_code,
    panchayat_code public.udd_code,
    village_code public.udd_code,
    user_level_code public.udd_code,
    subvertical_jsonb public.udd_jsonb,
    role_jsonb public.udd_jsonb,
    panchayat_jsonb public.udd_jsonb
);


ALTER TABLE public.core_mst_tuser OWNER TO postgres;

--
-- Name: core_mst_tuserblock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tuserblock (
    userblock_gid integer DEFAULT nextval('public.core_mst_tuserblock_userblock_gid_seq'::regclass) NOT NULL,
    user_code public.udd_code NOT NULL,
    block_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tuserblock OWNER TO postgres;

--
-- Name: core_mst_tusertoken; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_mst_tusertoken (
    token_gid integer DEFAULT nextval('public.core_mst_tusertoken_token_gid_seq'::regclass) NOT NULL,
    user_code public.udd_user NOT NULL,
    user_token public.udd_text NOT NULL,
    url public.udd_text,
    token_expired_date public.udd_datetime NOT NULL,
    token_expired_flag public.udd_flag NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.core_mst_tusertoken OWNER TO postgres;

--
-- Name: district_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.district_master (
    district_id integer NOT NULL,
    state_id integer NOT NULL,
    district_code character(4),
    district_name_en character varying(100),
    district_name_local character varying(200),
    district_short_name_en character varying(20),
    district_short_name_local character varying(40),
    fundrelease_flag boolean,
    language_id character varying(2),
    is_active boolean DEFAULT true NOT NULL,
    created_date timestamp without time zone NOT NULL,
    created_by integer NOT NULL,
    updated_date timestamp without time zone,
    updated_by integer,
    district_name_hi character varying(255)
);


ALTER TABLE public.district_master OWNER TO postgres;

--
-- Name: district_master_copy_district_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.district_master_copy_district_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.district_master_copy_district_id_seq OWNER TO postgres;

--
-- Name: district_master_copy_district_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.district_master_copy_district_id_seq OWNED BY public.district_master.district_id;


--
-- Name: federation_profile_consolidated; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.federation_profile_consolidated (
    local_id bigint NOT NULL,
    state_id integer,
    state_code character varying NOT NULL,
    district_id integer,
    district_code character varying NOT NULL,
    block_id integer,
    block_code character varying NOT NULL,
    gp_id integer,
    gp_code character varying,
    village_id integer,
    village_code character varying,
    cbo_type smallint,
    cbo_id bigint,
    cbo_code character varying(50),
    federation_name character varying(250),
    federation_name_local character varying(200),
    federation_formation_date date,
    federation_revival_date date,
    promoted_by smallint,
    promoter_name character varying(50),
    promoter_code character varying(5),
    meeting_frequency smallint,
    meeting_frequency_value smallint,
    meeting_on smallint,
    monthly_comp_saving integer,
    parent_cbo_type smallint,
    parent_cbo_id bigint,
    parent_cbo_code character varying(30),
    savings_frequency smallint,
    primary_activity smallint,
    secondary_activity smallint,
    tertiary_activity smallint,
    bookkeeper_identified smallint,
    bookkeeper_name character varying(100),
    bookkeeper_mobile character varying(12),
    election_tenure smallint,
    savings_interest double precision,
    voluntary_savings_interest double precision,
    does_financial_intermediation boolean,
    has_voluntary_savings boolean,
    status smallint,
    is_active boolean,
    source smallint,
    dedupl_status smallint,
    activation_status smallint,
    approve_status smallint,
    settlement_status smallint,
    created_date date,
    last_updated_date date,
    activation_date date,
    last_approval_date date,
    is_model_clf boolean,
    phone1_mobile_no bigint,
    phone1_phone_ownership smallint,
    phone2_mobile_no bigint,
    phone2_phone_ownership smallint,
    other_phones_json text,
    phone1_member_id bigint,
    phone2_member_id bigint,
    bank1_account_type smallint,
    bank1_account_no character varying(20),
    bank1_branch_code character varying(12),
    bank1_ifsc_code character varying(20),
    bank1_account_open_date date,
    bank1_passbook_name character varying(60),
    bank1_verification_status smallint,
    bank2_account_type smallint,
    bank2_account_no character varying(20),
    bank2_branch_code character varying(12),
    bank2_ifsc_code character varying(20),
    bank2_account_open_date date,
    bank2_passbook_name character varying(60),
    bank2_verification_status smallint,
    other_banks_json text
);


ALTER TABLE public.federation_profile_consolidated OWNER TO postgres;

--
-- Name: trng_mst_tvenue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tvenue (
    venue_gid integer DEFAULT nextval('public.trng_mst_tvenue_venue_gid_seq'::regclass) NOT NULL,
    venue_id public.udd_code NOT NULL,
    venue_name public.udd_desc NOT NULL,
    venue_ll_name public.udd_desc,
    venue_type_code public.udd_code NOT NULL,
    venue_subtype_code public.udd_code NOT NULL,
    contact_name public.udd_desc NOT NULL,
    contact_mobile_no public.udd_mobile,
    validity_from public.udd_date,
    validity_to public.udd_date,
    indefinite_flag public.udd_flag,
    others_flag public.udd_flag NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    row_timestamp public.udd_datetime NOT NULL,
    deactivation_reason_code public.udd_code,
    tprogram_id public.udd_code,
    tprogrambatch_id public.udd_code
);


ALTER TABLE public.trng_mst_tvenue OWNER TO postgres;

--
-- Name: trng_trn_ttprogram; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_ttprogram (
    tprogram_gid integer DEFAULT nextval('public.trng_trn_ttprogram_tprogram_gid_seq'::regclass) NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogram_name public.udd_desc NOT NULL,
    tprogram_ll_name public.udd_desc,
    course_id public.udd_code NOT NULL,
    coordinator_id public.udd_code NOT NULL,
    tprogram_level_code public.udd_code NOT NULL,
    start_date public.udd_date,
    end_date public.udd_date,
    no_of_days public.udd_int,
    no_of_batches public.udd_int,
    budget_amount public.udd_amount,
    actual_amount public.udd_amount,
    budget_remark public.udd_text,
    execution_status_code public.udd_code NOT NULL,
    execution_status_date public.udd_datetime NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    row_timestamp public.udd_datetime NOT NULL,
    deactivation_reason_code public.udd_code
);


ALTER TABLE public.trng_trn_ttprogram OWNER TO postgres;

--
-- Name: trng_trn_ttprogrambatch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_ttprogrambatch (
    tprogrambatch_gid integer DEFAULT nextval('public.trng_trn_ttprogrambatch_tprogrambatch_gid_seq'::regclass) NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogrambatch_id public.udd_code NOT NULL,
    batch_name public.udd_desc NOT NULL,
    batch_ll_name public.udd_desc,
    lang_code public.udd_code NOT NULL,
    start_date public.udd_date NOT NULL,
    end_date public.udd_date NOT NULL,
    no_of_days public.udd_int,
    tprogram_venue_id public.udd_code,
    confirm_venue_id public.udd_code,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    tprogrambatch_remark public.udd_text DEFAULT NULL::text
);


ALTER TABLE public.trng_trn_ttprogrambatch OWNER TO postgres;

--
-- Name: member_profile_consolidated; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.member_profile_consolidated (
    local_id bigint NOT NULL,
    state_id integer,
    state_code character varying,
    district_id integer,
    district_code character varying,
    block_id integer,
    block_code character varying,
    gp_id integer,
    gp_code character varying,
    village_id integer,
    village_code character varying,
    member_id bigint,
    member_code bigint,
    shg_id bigint,
    shg_code character varying(50),
    seq_no smallint,
    member_name character varying(100) NOT NULL,
    member_name_local character varying(100),
    relation_type character varying(1),
    relation_name character varying(100),
    relation_name_local character varying(100),
    gender smallint,
    religion smallint,
    social_category smallint,
    tribal_category smallint,
    highest_education_level smallint,
    dob_available smallint,
    dob date,
    age smallint,
    age_as_on date,
    minority smallint,
    is_disabled smallint,
    disability_details smallint,
    primary_occupation smallint,
    secondary_occupation smallint,
    tertiary_occupation smallint,
    joining_date date NOT NULL,
    leaving_date date,
    reason_for_leaving smallint,
    guardian_name character varying(100),
    guardian_name_local character varying(100),
    guardian_relation smallint,
    house_hold_code smallint,
    head_house_hold integer,
    insurance integer,
    is_active boolean,
    mem_activation_status smallint,
    approve_status smallint,
    mem_dedup_status smallint,
    settlement_status smallint,
    source smallint,
    created_date date,
    last_updated_date date,
    activation_date date,
    last_approval_date date,
    add1_type smallint,
    add1_line1 character varying(255),
    add1_line2 character varying(255),
    add1_village_id integer,
    add1_state_id integer,
    add1_district_id integer,
    add1_block_id integer,
    add1_gp_id integer,
    add1_postal_code integer,
    other_addresses_json text,
    kyc1_type smallint,
    kyc1_number character varying(50),
    kyc1_status smallint,
    other_kyc_json text,
    bank1_account_type smallint,
    bank1_account_no character varying(20),
    bank1_branch_code character varying(12),
    bank1_ifsc_code character varying(20),
    bank1_account_open_date date,
    bank1_passbook_name character varying(60),
    bank1_verification_status smallint,
    other_banks_json text,
    id1_system_type smallint,
    id1_system_id character varying(25),
    id1_status smallint,
    id2_system_type smallint,
    id2_system_id character varying(25),
    id2_status smallint,
    id3_system_type smallint,
    id3_system_id character varying(25),
    id3_status smallint,
    other_ids_json text,
    design1_cbo_type smallint,
    design1_cbo_id integer,
    design1_cbo_code character varying(15),
    desig1_category smallint,
    desig1_role smallint,
    desig1_from date,
    desig1_to date,
    desig1_status smallint,
    design2_cbo_type smallint,
    design2_cbo_id integer,
    design2_cbo_code character varying(15),
    design2_category smallint,
    desig2_role smallint,
    desig2_from date,
    desig2_to date,
    desig2_status smallint,
    design3_cbo_type smallint,
    design3_cbo_id integer,
    design3_cbo_code character varying(15),
    desig3_category smallint,
    desig3_role smallint,
    desig3_from date,
    desig3_to date,
    desig3_status smallint,
    desig_others_json text,
    ins1_type smallint,
    ins1_valid_till date,
    ins2_type smallint,
    ins2_valid_till date,
    ins3_type smallint,
    ins3_valid_till date,
    ins_others_json text,
    phone1_mobile_no bigint,
    phone1_phone_ownership smallint,
    phone2_mobile_no bigint,
    phone2_phone_ownership bigint,
    other_phones_json text
);


ALTER TABLE public.member_profile_consolidated OWNER TO postgres;

--
-- Name: member_profile_consolidated_tmp; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.member_profile_consolidated_tmp (
    local_id bigint NOT NULL,
    state_id integer,
    state_code character varying,
    district_id integer,
    district_code character varying,
    block_id integer,
    block_code character varying,
    gp_id integer,
    gp_code character varying,
    village_id integer,
    village_code character varying,
    member_id bigint,
    member_code bigint,
    shg_id bigint,
    shg_code character varying(50),
    seq_no smallint,
    member_name character varying(100) NOT NULL,
    member_name_local character varying(100),
    relation_type character varying(1),
    relation_name character varying(100),
    relation_name_local character varying(100),
    gender smallint,
    religion smallint,
    social_category smallint,
    tribal_category smallint,
    highest_education_level smallint,
    dob_available smallint,
    dob date,
    age smallint,
    age_as_on date,
    minority smallint,
    is_disabled smallint,
    disability_details smallint,
    primary_occupation smallint,
    secondary_occupation smallint,
    tertiary_occupation smallint,
    joining_date date NOT NULL,
    leaving_date date,
    reason_for_leaving smallint,
    guardian_name character varying(100),
    guardian_name_local character varying(100),
    guardian_relation smallint,
    house_hold_code smallint,
    head_house_hold integer,
    insurance integer,
    is_active boolean,
    mem_activation_status smallint,
    approve_status smallint,
    mem_dedup_status smallint,
    settlement_status smallint,
    source smallint,
    created_date date,
    last_updated_date date,
    activation_date date,
    last_approval_date date,
    add1_type smallint,
    add1_line1 character varying(255),
    add1_line2 character varying(255),
    add1_village_id integer,
    add1_state_id integer,
    add1_district_id integer,
    add1_block_id integer,
    add1_gp_id integer,
    add1_postal_code integer,
    other_addresses_json text,
    kyc1_type smallint,
    kyc1_number character varying(50),
    kyc1_status smallint,
    other_kyc_json text,
    bank1_account_type smallint,
    bank1_account_no character varying(20),
    bank1_branch_code character varying(12),
    bank1_ifsc_code character varying(20),
    bank1_account_open_date date,
    bank1_passbook_name character varying(60),
    bank1_verification_status smallint,
    other_banks_json text,
    id1_system_type smallint,
    id1_system_id character varying(25),
    id1_status smallint,
    id2_system_type smallint,
    id2_system_id character varying(25),
    id2_status smallint,
    id3_system_type smallint,
    id3_system_id character varying(25),
    id3_status smallint,
    other_ids_json text,
    design1_cbo_type smallint,
    design1_cbo_id integer,
    design1_cbo_code character varying(15),
    desig1_category smallint,
    desig1_role smallint,
    desig1_from date,
    desig1_to date,
    desig1_status smallint,
    design2_cbo_type smallint,
    design2_cbo_id integer,
    design2_cbo_code character varying(15),
    design2_category smallint,
    desig2_role smallint,
    desig2_from date,
    desig2_to date,
    desig2_status smallint,
    design3_cbo_type smallint,
    design3_cbo_id integer,
    design3_cbo_code character varying(15),
    desig3_category smallint,
    desig3_role smallint,
    desig3_from date,
    desig3_to date,
    desig3_status smallint,
    desig_others_json text,
    ins1_type smallint,
    ins1_valid_till date,
    ins2_type smallint,
    ins2_valid_till date,
    ins3_type smallint,
    ins3_valid_till date,
    ins_others_json text,
    phone1_mobile_no bigint,
    phone1_phone_ownership smallint,
    phone2_mobile_no bigint,
    phone2_phone_ownership bigint,
    other_phones_json text
);


ALTER TABLE public.member_profile_consolidated_tmp OWNER TO flexi;

--
-- Name: mst_grp_cadre; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.mst_grp_cadre (
    grp_id integer,
    grp_name character varying
);


ALTER TABLE public.mst_grp_cadre OWNER TO flexi;

--
-- Name: mst_type_cadre; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.mst_type_cadre (
    grp_id integer,
    cadre_id integer,
    cadre_name character varying
);


ALTER TABLE public.mst_type_cadre OWNER TO flexi;

--
-- Name: panchayat_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.panchayat_master (
    panchayat_id integer NOT NULL,
    state_id integer,
    district_id integer,
    block_id integer,
    panchayat_code character(10),
    panchayat_name_en character varying(100),
    panchayat_name_local character varying(200),
    language_id character varying(2),
    rural_urban_area character varying(1),
    is_active boolean DEFAULT true NOT NULL,
    created_date timestamp without time zone NOT NULL,
    created_by integer NOT NULL,
    updated_date timestamp without time zone,
    updated_by integer
);


ALTER TABLE public.panchayat_master OWNER TO postgres;

--
-- Name: state_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.state_master (
    state_id integer NOT NULL,
    state_code character(2),
    state_name_en character varying(50),
    state_name_hi character varying(100),
    state_name_local character varying(100),
    state_short_local_name character varying(10),
    state_short_name_en character varying(10),
    category smallint,
    is_active boolean DEFAULT true NOT NULL,
    created_date timestamp without time zone NOT NULL,
    created_by integer NOT NULL,
    updated_date timestamp without time zone,
    updated_by integer
);


ALTER TABLE public.state_master OWNER TO postgres;

--
-- Name: village_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.village_master (
    village_id integer NOT NULL,
    state_id integer,
    district_id integer,
    block_id integer,
    panchayat_id bigint,
    village_code character(16),
    village_name_en character varying(100),
    village_name_local character varying(200),
    is_active boolean DEFAULT true NOT NULL,
    created_date timestamp without time zone NOT NULL,
    created_by integer NOT NULL,
    updated_date timestamp without time zone,
    updated_by integer
);


ALTER TABLE public.village_master OWNER TO postgres;

--
-- Name: panchayat_master_copy_panchayat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.panchayat_master_copy_panchayat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.panchayat_master_copy_panchayat_id_seq OWNER TO postgres;

--
-- Name: panchayat_master_copy_panchayat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.panchayat_master_copy_panchayat_id_seq OWNED BY public.panchayat_master.panchayat_id;


--
-- Name: trng_mst_tvenueaddr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tvenueaddr (
    venueaddr_gid integer DEFAULT nextval('public.trng_mst_tvenueaddr_venueaddr_gid_seq'::regclass) NOT NULL,
    venue_id public.udd_code NOT NULL,
    addr_line public.udd_text NOT NULL,
    addr_pincode public.udd_pincode,
    state_code public.udd_code,
    district_code public.udd_code,
    block_code public.udd_code,
    grampanchayat_code public.udd_code,
    village_code public.udd_code,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_tvenueaddr OWNER TO postgres;

--
-- Name: trng_trn_ttprogramgeo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_ttprogramgeo (
    tprogramgeo_gid integer DEFAULT nextval('public.trng_trn_ttprogramgeo_tprogramgeo_gid_seq'::regclass) NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogram_level_code public.udd_code NOT NULL,
    state_code public.udd_code,
    district_code public.udd_code,
    block_code public.udd_code,
    grampanchayat_code public.udd_code,
    village_code public.udd_code,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_trn_ttprogramgeo OWNER TO postgres;

--
-- Name: shg_profile_consolidated; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shg_profile_consolidated (
    local_id bigint NOT NULL,
    state_id integer,
    state_code character varying,
    district_id integer,
    district_code character varying,
    block_id integer,
    block_code character varying,
    gp_id integer,
    gp_code character varying,
    village_id integer,
    village_code character varying,
    shg_id bigint,
    shg_code character varying(50),
    shg_name character varying(200) NOT NULL,
    shg_type_code smallint,
    shg_type_other character varying(100),
    shg_name_local character varying(120),
    shg_formation_date date,
    shg_revival_date date,
    shg_cooption_date date,
    shg_promoted_by smallint,
    meeting_frequency smallint,
    meeting_frequency_value smallint,
    meeting_on smallint,
    monthly_comp_saving integer,
    interloaning_rate double precision,
    saving_interest double precision,
    voluntary_savings_interest double precision,
    parent_cbo_id bigint,
    parent_cbo_code character varying(50),
    is_active boolean,
    dedupl_status smallint,
    activation_status smallint,
    approve_status smallint,
    settlement_status smallint,
    primary_activity smallint,
    secondary_activity smallint,
    tertiary_activity smallint,
    saving_frequency smallint,
    status smallint,
    has_voluntary_savings boolean,
    bookkeeper_identified smallint,
    bookkeeper_name character varying(60),
    bookkeeper_mobile character varying(12),
    election_tenure smallint,
    created_date date,
    last_updated_date date,
    activation_date date,
    last_approval_date date,
    inactive_reason smallint,
    add1_line1 character varying(255),
    add1_line2 character varying(255),
    add1_village_id integer,
    add1_state_id integer,
    add1_district_id integer,
    add1_block_id integer,
    add1_gp_id integer,
    add1_postal_code integer,
    other_addresses_json text,
    kyc1_type smallint,
    kyc1_number character varying(50),
    kyc1_status smallint,
    other_kyc_json text,
    bank1_account_type smallint,
    bank1_account_no character varying(20),
    bank1_branch_code character varying(12),
    bank1_ifsc_code character varying(20),
    bank1_account_open_date date,
    bank1_passbook_name character varying(60),
    bank1_verification_status smallint,
    bank2_account_type smallint,
    bank2_account_no character varying(20),
    bank2_branch_code character varying(12),
    bank2_ifsc_code character varying(20),
    bank2_account_open_date date,
    bank2_passbook_name character varying(60),
    bank2_verification_status smallint,
    other_banks_json text,
    id1_system_type smallint,
    id1_system_id character varying(25),
    id1_status smallint,
    id2_system_type smallint,
    id2_system_id character varying(25),
    id2_status smallint,
    id3_system_type smallint,
    id3_system_id character varying(25),
    id3_status smallint,
    other_ids_json text,
    design1_type smallint,
    design1_member_id bigint,
    design1_is_signatory boolean,
    desig1_from date,
    desig1_to date,
    design2_type smallint,
    design2_member_id bigint,
    design2_is_signatory boolean,
    desig2_from date,
    desig2_to date,
    design3_type smallint,
    design3_member_id bigint,
    design3_is_signatory boolean,
    desig3_from date,
    desig3_to date,
    desig_others_json text,
    source smallint,
    phone1_mobile_no bigint,
    phone1_phone_ownership smallint,
    phone2_mobile_no bigint,
    phone2_phone_ownership smallint,
    other_phones_json text,
    phone1_member_id bigint,
    phone2_member_id bigint
);


ALTER TABLE public.shg_profile_consolidated OWNER TO postgres;

--
-- Name: trng_trn_ttprogramparticipant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_ttprogramparticipant (
    tprogramparticipant_gid integer NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogrambatch_id public.udd_code NOT NULL,
    batch_date public.udd_date NOT NULL,
    participant_type_code public.udd_code NOT NULL,
    participant_subtype_code public.udd_code NOT NULL,
    participant_id public.udd_code NOT NULL,
    participant_name public.udd_desc NOT NULL,
    participant_ll_name public.udd_desc,
    fatherhusband_name public.udd_desc,
    fatherhusband_ll_name public.udd_desc,
    shg_id public.udd_code,
    mobile_no public.udd_mobile,
    email_id public.udd_email,
    gender_code public.udd_code NOT NULL,
    attendance_flag public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    feedback_status public.udd_code
);


ALTER TABLE public.trng_trn_ttprogramparticipant OWNER TO postgres;

--
-- Name: state_master_state_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.state_master_state_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.state_master_state_id_seq OWNER TO postgres;

--
-- Name: state_master_state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.state_master_state_id_seq OWNED BY public.state_master.state_id;


--
-- Name: trng_mst_tattachment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tattachment (
    attachment_gid integer DEFAULT nextval('public.trng_mst_tattachment_attachment_gid_seq'::regclass) NOT NULL,
    activity_code public.udd_code NOT NULL,
    activity_ref_id public.udd_code NOT NULL,
    doc_type_code public.udd_code NOT NULL,
    doc_subtype_code public.udd_code NOT NULL,
    file_name public.udd_desc NOT NULL,
    file_path public.udd_text NOT NULL,
    file_version public.udd_code NOT NULL,
    file_size public.udd_code NOT NULL,
    attachment_remark public.udd_desc,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_tattachment OWNER TO postgres;

--
-- Name: trng_mst_tcadreuser_flexi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tcadreuser_flexi (
    cadreuser_gid integer DEFAULT nextval('public.trng_mst_tcadreuser_cadreuser_gid_seq'::regclass) NOT NULL,
    cadreuser_id public.udd_code NOT NULL,
    cadreuser_name public.udd_desc NOT NULL,
    cadreuser_ll_name public.udd_desc NOT NULL,
    shg_name public.udd_desc NOT NULL,
    gender_code public.udd_code NOT NULL,
    mobile_no public.udd_mobile,
    mail_id public.udd_email,
    cadre_resource_type_code public.udd_code NOT NULL,
    cadre_role_code public.udd_code NOT NULL,
    vertical_code public.udd_code NOT NULL,
    subvertical_code public.udd_code NOT NULL,
    cadre_cat_code public.udd_code NOT NULL,
    cadreuser_type_code public.udd_code,
    cadre_level_code public.udd_code,
    status_code public.udd_code NOT NULL,
    addr_line public.udd_text,
    addr_pincode public.udd_pincode,
    addr_state_code public.udd_code,
    addr_district_code public.udd_code,
    addr_block_code public.udd_code,
    addr_grampanchayat_code public.udd_code,
    addr_village_code public.udd_code,
    state_code public.udd_code,
    district_code public.udd_code,
    block_code public.udd_code,
    grampanchayat_code public.udd_code,
    area_of_experience public.udd_text,
    years_of_experience public.udd_int,
    lang_code public.udd_code,
    read_flag public.udd_code,
    write_flag public.udd_code,
    speak_flag public.udd_code,
    bank_code public.udd_code,
    branch_name public.udd_desc,
    ifsc_code public.udd_code,
    acc_type_code public.udd_code,
    acc_no public.udd_code,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    father_husband_name public.udd_desc
);


ALTER TABLE public.trng_mst_tcadreuser_flexi OWNER TO postgres;

--
-- Name: trng_mst_tcourse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tcourse (
    course_gid integer DEFAULT nextval('public.trng_mst_tcourse_course_gid_seq'::regclass) NOT NULL,
    course_id public.udd_code,
    course_name public.udd_desc NOT NULL,
    course_ll_name public.udd_desc,
    course_desc public.udd_desc NOT NULL,
    course_level_jsonb public.udd_jsonb NOT NULL,
    course_type_jsonb public.udd_jsonb NOT NULL,
    vertical_code public.udd_code NOT NULL,
    subvertical_jsonb public.udd_jsonb NOT NULL,
    category_jsonb public.udd_jsonb,
    sp_category_jsonb public.udd_jsonb,
    course_duration_days public.udd_smallint,
    course_duration_hours public.udd_smallint,
    validity_from public.udd_date,
    validity_to public.udd_date,
    indefinite_flag public.udd_flag,
    participant_jsonb public.udd_jsonb,
    min_participant_count public.udd_smallint,
    max_participant_count public.udd_smallint,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    row_timestamp public.udd_datetime NOT NULL,
    deactivation_reason_code public.udd_code,
    certificate_flag public.udd_flag
);


ALTER TABLE public.trng_mst_tcourse OWNER TO postgres;

--
-- Name: trng_mst_tcourseapproval; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tcourseapproval (
    courseapproval_gid integer DEFAULT nextval('public.trng_mst_tcourseapproval_courseapproval_gid_seq'::regclass) NOT NULL,
    course_id public.udd_code NOT NULL,
    initiated_date public.udd_datetime NOT NULL,
    approver_id public.udd_code NOT NULL,
    approval_date public.udd_datetime,
    approval_status_code public.udd_code NOT NULL,
    reject_reason_code public.udd_code,
    approver_remark public.udd_desc,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_tcourseapproval OWNER TO postgres;

--
-- Name: trng_mst_tcoursecontent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tcoursecontent (
    coursecontent_gid integer NOT NULL,
    course_id public.udd_code NOT NULL,
    coursemodule_id public.udd_code NOT NULL,
    material_desc public.udd_desc NOT NULL,
    lang_code public.udd_code NOT NULL,
    file_type_code public.udd_code NOT NULL,
    file_name public.udd_text NOT NULL,
    file_path public.udd_text NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_tcoursecontent OWNER TO postgres;

--
-- Name: trng_mst_tcoursecontent_coursecontent_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trng_mst_tcoursecontent_coursecontent_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trng_mst_tcoursecontent_coursecontent_gid_seq OWNER TO postgres;

--
-- Name: trng_mst_tcoursecontent_coursecontent_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trng_mst_tcoursecontent_coursecontent_gid_seq OWNED BY public.trng_mst_tcoursecontent.coursecontent_gid;


--
-- Name: trng_mst_tcoursemodule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tcoursemodule (
    coursemodule_gid integer DEFAULT nextval('public.trng_mst_tcoursemodule_coursemodule_gid_seq'::regclass) NOT NULL,
    course_id public.udd_code NOT NULL,
    coursemodule_id public.udd_code NOT NULL,
    module_name public.udd_desc NOT NULL,
    module_ll_name public.udd_desc,
    module_desc public.udd_desc,
    subvertical_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_tcoursemodule OWNER TO postgres;

--
-- Name: trng_mst_tcoursereviewerhistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tcoursereviewerhistory (
    coursereviewerhistory_gid integer NOT NULL,
    course_gid public.udd_int NOT NULL,
    reviewed_date public.udd_datetime NOT NULL,
    reviewer_code public.udd_code NOT NULL,
    reviewer_remark public.udd_desc NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL
);


ALTER TABLE public.trng_mst_tcoursereviewerhistory OWNER TO postgres;

--
-- Name: trng_mst_tcoursereviewerhistory_coursereviewerhistory_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trng_mst_tcoursereviewerhistory_coursereviewerhistory_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trng_mst_tcoursereviewerhistory_coursereviewerhistory_gid_seq OWNER TO postgres;

--
-- Name: trng_mst_tcoursereviewerhistory_coursereviewerhistory_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trng_mst_tcoursereviewerhistory_coursereviewerhistory_gid_seq OWNED BY public.trng_mst_tcoursereviewerhistory.coursereviewerhistory_gid;


--
-- Name: trng_mst_tcoursetrainer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tcoursetrainer (
    coursetrainer_gid integer DEFAULT nextval('public.trng_mst_tcoursetrainer_coursetrainer_gid_seq'::regclass) NOT NULL,
    course_id public.udd_code NOT NULL,
    trainer_id public.udd_code NOT NULL,
    trainer_type_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    trngorg_type_code public.udd_code,
    trngorg_id public.udd_code,
    trainer_flag public.udd_flag
);


ALTER TABLE public.trng_mst_tcoursetrainer OWNER TO postgres;

--
-- Name: trng_mst_tnote; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tnote (
    note_gid integer DEFAULT nextval('public.trng_mst_tnote_coursenote_gid_seq'::regclass) NOT NULL,
    activity_code public.udd_code NOT NULL,
    activity_ref_id public.udd_code NOT NULL,
    note_desc public.udd_text,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    note_code public.udd_code,
    reject_reason_code public.udd_code,
    deactivation_reason_code public.udd_code,
    sendback_reason public.udd_text
);


ALTER TABLE public.trng_mst_tnote OWNER TO postgres;

--
-- Name: trng_mst_tquestion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tquestion (
    question_gid integer DEFAULT nextval('public.trng_mst_tquestion_question_gid_seq'::regclass) NOT NULL,
    questionaire_id public.udd_code NOT NULL,
    questionairegrp_id public.udd_code NOT NULL,
    question_id public.udd_code NOT NULL,
    question public.udd_desc NOT NULL,
    question_seq_no public.udd_int NOT NULL,
    question_type_code public.udd_code NOT NULL,
    question_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_tquestion OWNER TO postgres;

--
-- Name: trng_mst_tquestionaire; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tquestionaire (
    questionaire_gid integer DEFAULT nextval('public.trng_mst_tquestionaire_questionaire_gid_seq'::regclass) NOT NULL,
    questionaire_id public.udd_code,
    questionaire_name public.udd_desc NOT NULL,
    questionaire_ll_name public.udd_desc,
    questionaire_type_code public.udd_code NOT NULL,
    lang_jsonb public.udd_jsonb NOT NULL,
    course_jsonb public.udd_jsonb NOT NULL,
    validity_from public.udd_date,
    validity_to public.udd_date,
    indefinite_flag public.udd_flag,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    row_timestamp public.udd_datetime NOT NULL,
    deactivation_reason_code public.udd_code
);


ALTER TABLE public.trng_mst_tquestionaire OWNER TO postgres;

--
-- Name: trng_mst_tquestionairegrp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tquestionairegrp (
    questionairegrp_gid integer DEFAULT nextval('public.trng_mst_tquestionairegrp_questionairegrp_gid_seq'::regclass) NOT NULL,
    questionaire_id public.udd_code NOT NULL,
    questionairegrp_id public.udd_code NOT NULL,
    questionairegrp_code public.udd_code NOT NULL,
    questionairegrp_seq_no public.udd_int NOT NULL,
    status_code public.udd_code,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_tquestionairegrp OWNER TO postgres;

--
-- Name: trng_mst_tquestionairegrptranslate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tquestionairegrptranslate (
    questionairegrptranslate_gid integer DEFAULT nextval('public.trng_mst_tquestionairegrptranslate_questionairegrptranslate_gid'::regclass) NOT NULL,
    questionairegrp_id public.udd_code NOT NULL,
    lang_code public.udd_code NOT NULL,
    group_desc public.udd_text NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_code NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_code
);


ALTER TABLE public.trng_mst_tquestionairegrptranslate OWNER TO postgres;

--
-- Name: trng_mst_tquestiontranslate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tquestiontranslate (
    questiontranslate_gid integer DEFAULT nextval('public.trng_mst_tquestiontranslate_questiontranslate_gid'::regclass) NOT NULL,
    question_id public.udd_code NOT NULL,
    lang_code public.udd_code NOT NULL,
    question_desc public.udd_text NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_tquestiontranslate OWNER TO postgres;

--
-- Name: trng_mst_ttrainer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainer (
    trainer_gid integer DEFAULT nextval('public.trng_mst_ttrainer_trainer_gid_seq'::regclass) NOT NULL,
    trngorg_id public.udd_code NOT NULL,
    trngorg_type_code public.udd_code NOT NULL,
    trainer_id public.udd_code NOT NULL,
    trainer_name public.udd_desc NOT NULL,
    trainer_ll_name public.udd_desc,
    trainer_type_code public.udd_code NOT NULL,
    trainer_level_code public.udd_code NOT NULL,
    mobile_no public.udd_mobile,
    email_id public.udd_email,
    gender_code public.udd_code NOT NULL,
    resource_type_code public.udd_code,
    trainer_qualification public.udd_text,
    validity_from public.udd_date,
    validity_to public.udd_date,
    indefinite_flag public.udd_flag,
    photo_file_name public.udd_desc,
    photo_file_path public.udd_text,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    row_timestamp public.udd_datetime NOT NULL,
    cadre_id public.udd_code,
    deactivation_reason_code public.udd_code
);


ALTER TABLE public.trng_mst_ttrainer OWNER TO postgres;

--
-- Name: trng_mst_ttrainerdomain; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainerdomain (
    trainerdomain_gid integer DEFAULT nextval('public.trng_mst_ttrainerdomain_trainerdomain_gid_seq'::regclass) NOT NULL,
    trainer_id public.udd_code NOT NULL,
    vertical_code public.udd_code NOT NULL,
    subvertical_jsonb public.udd_jsonb NOT NULL,
    area_of_experience public.udd_text NOT NULL,
    yrs_of_experience public.udd_decimal NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttrainerdomain OWNER TO postgres;

--
-- Name: trng_mst_ttrainingorg; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainingorg (
    trngorg_gid integer DEFAULT nextval('public.trng_mst_ttrainingorg_trngorg_gid_seq'::regclass) NOT NULL,
    trngorg_id public.udd_code NOT NULL,
    trngorg_name public.udd_desc NOT NULL,
    trngorg_ll_name public.udd_desc,
    trngorg_type_code public.udd_code NOT NULL,
    trngorg_level_code public.udd_code NOT NULL,
    mobile_no public.udd_mobile,
    email_id public.udd_email,
    validity_from public.udd_date,
    validity_to public.udd_date,
    indefinite_flag public.udd_flag,
    sys_flag public.udd_flag NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    row_timestamp public.udd_datetime NOT NULL,
    deactivation_reason_code public.udd_code,
    contact_person public.udd_desc
);


ALTER TABLE public.trng_mst_ttrainingorg OWNER TO postgres;

--
-- Name: trng_mst_ttraineraddr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttraineraddr (
    traineraddr_gid integer DEFAULT nextval('public.trng_mst_ttraineraddr_traineraddr_gid_seq'::regclass) NOT NULL,
    trainer_id public.udd_code NOT NULL,
    addr_line public.udd_text NOT NULL,
    addr_pincode public.udd_mobile,
    state_code public.udd_code,
    district_code public.udd_code,
    block_code public.udd_code,
    grampanchayat_code public.udd_code,
    village_code public.udd_code,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttraineraddr OWNER TO postgres;

--
-- Name: trng_mst_ttrainerattachment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainerattachment (
    trainerattachment_gid integer NOT NULL,
    trainer_gid public.udd_int NOT NULL,
    doc_type_code public.udd_code NOT NULL,
    doc_subtype_code public.udd_code NOT NULL,
    file_name public.udd_desc NOT NULL,
    file_path public.udd_text NOT NULL,
    file_version public.udd_code NOT NULL,
    file_size public.udd_code NOT NULL,
    attachment_remark public.udd_desc,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttrainerattachment OWNER TO postgres;

--
-- Name: trng_mst_ttrainerattachment_trainerattachment_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trng_mst_ttrainerattachment_trainerattachment_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trng_mst_ttrainerattachment_trainerattachment_gid_seq OWNER TO postgres;

--
-- Name: trng_mst_ttrainerattachment_trainerattachment_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trng_mst_ttrainerattachment_trainerattachment_gid_seq OWNED BY public.trng_mst_ttrainerattachment.trainerattachment_gid;


--
-- Name: trng_mst_ttrainerbank; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainerbank (
    trainerbank_gid integer DEFAULT nextval('public.trng_mst_ttrainerbank_trainerbank_gid_seq'::regclass) NOT NULL,
    trainer_id public.udd_code NOT NULL,
    bank_code public.udd_code NOT NULL,
    branch_name public.udd_desc NOT NULL,
    ifsc_code public.udd_code NOT NULL,
    acc_type_code public.udd_code NOT NULL,
    acc_no public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttrainerbank OWNER TO postgres;

--
-- Name: trng_mst_ttrainergeo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainergeo (
    trainergeo_gid integer DEFAULT nextval('public.trng_mst_ttrainergeo_trainergeo_gid_seq'::regclass) NOT NULL,
    trainer_id public.udd_code NOT NULL,
    trainer_level_code public.udd_code NOT NULL,
    state_code public.udd_code,
    district_code public.udd_code,
    block_code public.udd_code,
    grampanchayat_code public.udd_code,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttrainergeo OWNER TO postgres;

--
-- Name: trng_mst_ttrainergroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainergroup (
    trainergroup_gid integer DEFAULT nextval('public.trng_mst_ttrainergroup_trainergroup_gid_seq'::regclass) NOT NULL,
    trngorg_type_code public.udd_code NOT NULL,
    trngorg_id public.udd_code NOT NULL,
    trainer_id public.udd_code NOT NULL,
    trainer_type_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttrainergroup OWNER TO postgres;

--
-- Name: trng_mst_ttrainerlang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainerlang (
    trainerlang_gid integer DEFAULT nextval('public.trng_mst_ttrainerlang_trainerlang_gid_seq'::regclass) NOT NULL,
    trainer_id public.udd_code NOT NULL,
    lang_code public.udd_code NOT NULL,
    read_flag public.udd_code NOT NULL,
    write_flag public.udd_code NOT NULL,
    speak_flag public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttrainerlang OWNER TO postgres;

--
-- Name: trng_mst_ttrainernote; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainernote (
    trainernote_gid integer NOT NULL,
    trainer_gid public.udd_int NOT NULL,
    note_desc public.udd_text NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL
);


ALTER TABLE public.trng_mst_ttrainernote OWNER TO postgres;

--
-- Name: trng_mst_ttrainernote_trainernote_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trng_mst_ttrainernote_trainernote_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trng_mst_ttrainernote_trainernote_gid_seq OWNER TO postgres;

--
-- Name: trng_mst_ttrainernote_trainernote_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trng_mst_ttrainernote_trainernote_gid_seq OWNED BY public.trng_mst_ttrainernote.trainernote_gid;


--
-- Name: trng_mst_ttrainingorgaddr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainingorgaddr (
    trngorgaddr_gid integer DEFAULT nextval('public.trng_mst_ttrainingorgaddr_trngorgaddr_gid_seq'::regclass) NOT NULL,
    trngorg_id public.udd_code NOT NULL,
    addr_line public.udd_text NOT NULL,
    addr_pincode public.udd_pincode,
    state_code public.udd_code,
    district_code public.udd_code,
    block_code public.udd_code,
    grampanchayat_code public.udd_code,
    village_code public.udd_code,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttrainingorgaddr OWNER TO postgres;

--
-- Name: trng_mst_ttrainingorgattachment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainingorgattachment (
    trngorgattachment_gid integer NOT NULL,
    trngorg_gid public.udd_int NOT NULL,
    doc_type_code public.udd_code NOT NULL,
    doc_subtype_code public.udd_code NOT NULL,
    file_name public.udd_desc NOT NULL,
    file_path public.udd_text NOT NULL,
    file_version public.udd_code NOT NULL,
    file_size public.udd_code NOT NULL,
    attachment_remark public.udd_desc,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttrainingorgattachment OWNER TO postgres;

--
-- Name: trng_mst_ttrainingorgattachment_trngorgattachment_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trng_mst_ttrainingorgattachment_trngorgattachment_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trng_mst_ttrainingorgattachment_trngorgattachment_gid_seq OWNER TO postgres;

--
-- Name: trng_mst_ttrainingorgattachment_trngorgattachment_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trng_mst_ttrainingorgattachment_trngorgattachment_gid_seq OWNED BY public.trng_mst_ttrainingorgattachment.trngorgattachment_gid;


--
-- Name: trng_mst_ttrainingorgbank; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainingorgbank (
    trngorgbank_gid integer DEFAULT nextval('public.trng_mst_ttrainingorgbank_trngorgbank_gid_seq'::regclass) NOT NULL,
    trngorg_id public.udd_code NOT NULL,
    bank_code public.udd_code NOT NULL,
    branch_name public.udd_desc NOT NULL,
    ifsc_code public.udd_code NOT NULL,
    acc_type_code public.udd_code NOT NULL,
    acc_no public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttrainingorgbank OWNER TO postgres;

--
-- Name: trng_mst_ttrainingorgdomain; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainingorgdomain (
    trngorgdomain_gid integer DEFAULT nextval('public.trng_mst_ttrainingorgdomain_trngorgdomain_gid_seq'::regclass) NOT NULL,
    trngorg_id public.udd_code NOT NULL,
    vertical_code public.udd_code NOT NULL,
    subvertical_jsonb public.udd_jsonb NOT NULL,
    area_of_experience public.udd_text NOT NULL,
    yrs_of_experience public.udd_decimal NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttrainingorgdomain OWNER TO postgres;

--
-- Name: trng_mst_ttrainingorggeo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainingorggeo (
    trngorggeo_gid integer DEFAULT nextval('public.trng_mst_ttrainingorggeo_trngorggeo_gid_seq'::regclass) NOT NULL,
    trngorg_id public.udd_code NOT NULL,
    trngorg_level_code public.udd_code NOT NULL,
    state_code public.udd_code,
    district_code public.udd_code,
    block_code public.udd_code,
    grampanchayat_code public.udd_code,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttrainingorggeo OWNER TO postgres;

--
-- Name: trng_mst_ttrainingorggroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainingorggroup (
    trngorggroup_gid integer NOT NULL,
    trngorg_id public.udd_code NOT NULL,
    group_name public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_ttrainingorggroup OWNER TO postgres;

--
-- Name: trng_mst_ttrainingorggroup_trngorggroup_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trng_mst_ttrainingorggroup_trngorggroup_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trng_mst_ttrainingorggroup_trngorggroup_gid_seq OWNER TO postgres;

--
-- Name: trng_mst_ttrainingorggroup_trngorggroup_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trng_mst_ttrainingorggroup_trngorggroup_gid_seq OWNED BY public.trng_mst_ttrainingorggroup.trngorggroup_gid;


--
-- Name: trng_mst_ttrainingorgnote; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_ttrainingorgnote (
    trngorgnote_gid integer NOT NULL,
    trngorg_gid public.udd_int NOT NULL,
    note_desc public.udd_text NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL
);


ALTER TABLE public.trng_mst_ttrainingorgnote OWNER TO postgres;

--
-- Name: trng_mst_ttrainingorgnote_trngorgnote_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trng_mst_ttrainingorgnote_trngorgnote_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trng_mst_ttrainingorgnote_trngorgnote_gid_seq OWNER TO postgres;

--
-- Name: trng_mst_ttrainingorgnote_trngorgnote_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trng_mst_ttrainingorgnote_trngorgnote_gid_seq OWNED BY public.trng_mst_ttrainingorgnote.trngorgnote_gid;


--
-- Name: trng_mst_tvenueinfra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_mst_tvenueinfra (
    venueinfra_gid integer DEFAULT nextval('public.trng_mst_tvenueinfra_venueinfra_gid_seq'::regclass) NOT NULL,
    venue_id public.udd_code NOT NULL,
    facility_name public.udd_desc NOT NULL,
    addr_line public.udd_text NOT NULL,
    addr_pincode public.udd_pincode,
    state_code public.udd_code,
    district_code public.udd_code,
    block_code public.udd_code,
    grampanchayat_code public.udd_code,
    village_code public.udd_code,
    conf_room_count public.udd_int,
    conf_room_capacity public.udd_int,
    accom_overnight_flag public.udd_flag,
    accom_overnight_capacity public.udd_int,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    facility_id public.udd_code
);


ALTER TABLE public.trng_mst_tvenueinfra OWNER TO postgres;

--
-- Name: trng_mst_tvenueinfradtl; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.trng_mst_tvenueinfradtl (
    venueinfradtl_gid integer DEFAULT nextval('public.trng_mst_tvenueinfra_venueinfradtl_gid_seq'::regclass) NOT NULL,
    venue_id public.udd_code NOT NULL,
    facility_id public.udd_code NOT NULL,
    infra_type public.udd_code,
    infra_count public.udd_int,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_mst_tvenueinfradtl OWNER TO flexi;

--
-- Name: trng_trn_ttprogramtrainer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_ttprogramtrainer (
    tprogramtrainer_gid integer DEFAULT nextval('public.trng_trn_ttprogramtrainer_tprogramtrainer_gid_seq'::regclass) NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogrambatch_id public.udd_code NOT NULL,
    org_type_code public.udd_code NOT NULL,
    trngorg_id public.udd_code NOT NULL,
    trainer_id public.udd_code,
    trainer_type_code public.udd_code NOT NULL,
    trainer_flag public.udd_flag NOT NULL,
    confirmation_flag public.udd_flag NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    feedback_status public.udd_code
);


ALTER TABLE public.trng_trn_ttprogramtrainer OWNER TO postgres;

--
-- Name: trng_trn_temailtran; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.trng_trn_temailtran (
    emailtran_gid integer DEFAULT nextval('public.trng_trn_temailtran_emailtran_gid_seq'::regclass) NOT NULL,
    email_id public.udd_text NOT NULL,
    emailtemplate_code public.udd_code NOT NULL,
    email_content public.udd_text NOT NULL,
    scheduled_date public.udd_datetime NOT NULL,
    email_delivered_flag public.udd_flag NOT NULL,
    user_code public.udd_code NOT NULL,
    role_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    email_remark public.udd_text,
    email_subject public.udd_text
);


ALTER TABLE public.trng_trn_temailtran OWNER TO flexi;

--
-- Name: trng_trn_tfeedbackparticipant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_tfeedbackparticipant (
    feedbackparticipant_gid integer NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogrambatch_id public.udd_code NOT NULL,
    participant_id public.udd_code NOT NULL,
    lang_code public.udd_code NOT NULL,
    questionaire_id public.udd_code NOT NULL,
    question_id public.udd_code NOT NULL,
    question_type_code public.udd_code NOT NULL,
    participants_feedback_code public.udd_code,
    participants_response public.udd_text,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    response_status public.udd_code NOT NULL
);


ALTER TABLE public.trng_trn_tfeedbackparticipant OWNER TO postgres;

--
-- Name: trng_trn_tfeedbackparticipant_feedbackparticipant_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trng_trn_tfeedbackparticipant_feedbackparticipant_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trng_trn_tfeedbackparticipant_feedbackparticipant_gid_seq OWNER TO postgres;

--
-- Name: trng_trn_tfeedbackparticipant_feedbackparticipant_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trng_trn_tfeedbackparticipant_feedbackparticipant_gid_seq OWNED BY public.trng_trn_tfeedbackparticipant.feedbackparticipant_gid;


--
-- Name: trng_trn_tfeedbacktrainer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_tfeedbacktrainer (
    feedbacktrainer_gid integer NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogrambatch_id public.udd_code NOT NULL,
    trainer_id public.udd_code NOT NULL,
    lang_code public.udd_code NOT NULL,
    questionaire_id public.udd_code NOT NULL,
    question_id public.udd_code NOT NULL,
    question_type_code public.udd_code NOT NULL,
    trainers_feedback_code public.udd_code,
    trainers_response public.udd_text,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    response_status public.udd_code NOT NULL
);


ALTER TABLE public.trng_trn_tfeedbacktrainer OWNER TO postgres;

--
-- Name: trng_trn_tfeedbacktrainer_feedbacktrainer_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trng_trn_tfeedbacktrainer_feedbacktrainer_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trng_trn_tfeedbacktrainer_feedbacktrainer_gid_seq OWNER TO postgres;

--
-- Name: trng_trn_tfeedbacktrainer_feedbacktrainer_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trng_trn_tfeedbacktrainer_feedbacktrainer_gid_seq OWNED BY public.trng_trn_tfeedbacktrainer.feedbacktrainer_gid;


--
-- Name: trng_trn_tloginhistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_tloginhistory (
    loginhistory_gid integer DEFAULT nextval('public.trng_trn_tloginhistory_loginhistory_gid_seq'::regclass) NOT NULL,
    user_code public.udd_code NOT NULL,
    ip_address public.udd_desc NOT NULL,
    login_date public.udd_datetime NOT NULL,
    login_mode public.udd_code NOT NULL,
    login_status public.udd_code NOT NULL
);


ALTER TABLE public.trng_trn_tloginhistory OWNER TO postgres;

--
-- Name: trng_trn_tmobilevenuemapping; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.trng_trn_tmobilevenuemapping (
    mobvenuemap_gid integer NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogrambatch_id public.udd_code NOT NULL,
    mobilevenue_id public.udd_code NOT NULL,
    venue_id public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL
);


ALTER TABLE public.trng_trn_tmobilevenuemapping OWNER TO flexi;

--
-- Name: trng_trn_tmobilevenuemapping_mobvenuemap_gid_seq; Type: SEQUENCE; Schema: public; Owner: flexi
--

CREATE SEQUENCE public.trng_trn_tmobilevenuemapping_mobvenuemap_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trng_trn_tmobilevenuemapping_mobvenuemap_gid_seq OWNER TO flexi;

--
-- Name: trng_trn_tmobilevenuemapping_mobvenuemap_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flexi
--

ALTER SEQUENCE public.trng_trn_tmobilevenuemapping_mobvenuemap_gid_seq OWNED BY public.trng_trn_tmobilevenuemapping.mobvenuemap_gid;


--
-- Name: trng_trn_tsmstran; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.trng_trn_tsmstran (
    smstran_gid integer DEFAULT nextval('public.trng_trn_tsmstran_smstran_gid_seq'::regclass) NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogrambatch_id public.udd_code NOT NULL,
    feedback_lang_code public.udd_code NOT NULL,
    feedback_type_code public.udd_code NOT NULL,
    questionaire_id public.udd_code NOT NULL,
    trainer_part_id public.udd_code NOT NULL,
    mobile_no public.udd_mobile NOT NULL,
    original_url public.udd_text NOT NULL,
    short_url public.udd_desc NOT NULL,
    smstemplate_code public.udd_code NOT NULL,
    dlt_template_id public.udd_code NOT NULL,
    sms_text public.udd_text NOT NULL,
    scheduled_date public.udd_datetime NOT NULL,
    sms_delivered_flag public.udd_flag NOT NULL,
    user_code public.udd_code NOT NULL,
    role_code public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    sms_remark public.udd_text
);


ALTER TABLE public.trng_trn_tsmstran OWNER TO flexi;

--
-- Name: trng_trn_tsqliteattachment; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.trng_trn_tsqliteattachment (
    sqliteattachment_gid integer DEFAULT nextval('public.trng_trn_tsqliteattachment_sqliteattachment_gid_seq'::regclass) NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    role_code public.udd_code NOT NULL,
    user_code public.udd_code NOT NULL,
    mobile_no public.udd_mobile NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_trn_tsqliteattachment OWNER TO flexi;

--
-- Name: trng_trn_ttprogramapproval; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_ttprogramapproval (
    programapproval_gid integer DEFAULT nextval('public.trng_trn_ttprogramapproval_programapproval_gid_seq'::regclass) NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    initiated_date public.udd_datetime NOT NULL,
    approver_id public.udd_code NOT NULL,
    approval_date public.udd_datetime,
    approval_status_code public.udd_code NOT NULL,
    reject_reason_code public.udd_code,
    approver_remark public.udd_desc,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_trn_ttprogramapproval OWNER TO postgres;

--
-- Name: trng_trn_ttprogrambatchattachment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_ttprogrambatchattachment (
    tprogrambatchattachment_gid integer DEFAULT nextval('public.trng_trn_ttprgbatchattachment_tprogrambatchattachment_gid_seq'::regclass) NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogrambatch_id public.udd_code NOT NULL,
    doc_type_code public.udd_code NOT NULL,
    doc_subtype_code public.udd_code NOT NULL,
    file_name public.udd_desc NOT NULL,
    file_path public.udd_text NOT NULL,
    file_version public.udd_code NOT NULL,
    file_size public.udd_code NOT NULL,
    status_code public.udd_code NOT NULL,
    attachment_remark public.udd_desc,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_trn_ttprogrambatchattachment OWNER TO postgres;

--
-- Name: trng_trn_ttprogrambatchcount; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_ttprogrambatchcount (
    tprogrambatchcount_gid integer DEFAULT nextval('public.trng_trn_ttprogrambatchcount_tprogrambatchcount_gid_seq'::regclass) NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogrambatch_id public.udd_code NOT NULL,
    batch_date public.udd_date NOT NULL,
    batch_count public.udd_int NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_trn_ttprogrambatchcount OWNER TO postgres;

--
-- Name: trng_trn_ttprogrambudget; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_ttprogrambudget (
    tprogrambudget_gid integer NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogrambatch_id public.udd_code NOT NULL,
    batch_date public.udd_date NOT NULL,
    expense_code public.udd_code NOT NULL,
    budget_desc public.udd_desc,
    budget_amount public.udd_amount NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_trn_ttprogrambudget OWNER TO postgres;

--
-- Name: trng_trn_ttprogrambudget_tprogrambudget_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trng_trn_ttprogrambudget_tprogrambudget_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trng_trn_ttprogrambudget_tprogrambudget_gid_seq OWNER TO postgres;

--
-- Name: trng_trn_ttprogrambudget_tprogrambudget_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trng_trn_ttprogrambudget_tprogrambudget_gid_seq OWNED BY public.trng_trn_ttprogrambudget.tprogrambudget_gid;


--
-- Name: trng_trn_ttprogramexpense; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_ttprogramexpense (
    tprogramexpense_gid integer DEFAULT nextval('public.trng_trn_ttprogramexpense_tprogramexpense_gid_seq'::regclass) NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogrambatch_id public.udd_code NOT NULL,
    expense_date public.udd_date NOT NULL,
    expense_code public.udd_code NOT NULL,
    expense_desc public.udd_desc,
    expense_amount public.udd_amount NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user,
    expense_reason public.udd_text
);


ALTER TABLE public.trng_trn_ttprogramexpense OWNER TO postgres;

--
-- Name: trng_trn_ttprogramlock; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.trng_trn_ttprogramlock (
    tprogram_lock_gid public.udd_int DEFAULT nextval('public.trng_trn_ttprogramlockgid_seq'::regclass) NOT NULL,
    tprogram_id public.udd_code
);


ALTER TABLE public.trng_trn_ttprogramlock OWNER TO flexi;

--
-- Name: trng_trn_ttprogramparticipant_tprogramparticipant_gid_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trng_trn_ttprogramparticipant_tprogramparticipant_gid_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trng_trn_ttprogramparticipant_tprogramparticipant_gid_seq1 OWNER TO postgres;

--
-- Name: trng_trn_ttprogramparticipant_tprogramparticipant_gid_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trng_trn_ttprogramparticipant_tprogramparticipant_gid_seq1 OWNED BY public.trng_trn_ttprogramparticipant.tprogramparticipant_gid;


--
-- Name: trng_trn_ttpurllink; Type: TABLE; Schema: public; Owner: flexi
--

CREATE TABLE public.trng_trn_ttpurllink (
    tpurllink integer DEFAULT nextval('public.trng_trn_ttpurllink_tpurllink_gidseq'::regclass) NOT NULL,
    tprogram_id public.udd_code NOT NULL,
    tprogrambatch_id public.udd_code NOT NULL,
    questionaire_id public.udd_code NOT NULL,
    trainer_part_id public.udd_code NOT NULL,
    mobile_no public.udd_mobile NOT NULL,
    original_url public.udd_text NOT NULL,
    short_link public.udd_text NOT NULL,
    expiration_date public.udd_date NOT NULL,
    status_code public.udd_code NOT NULL
);


ALTER TABLE public.trng_trn_ttpurllink OWNER TO flexi;

--
-- Name: trng_trn_ttrainerleave; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trng_trn_ttrainerleave (
    trainerleave_gid integer DEFAULT nextval('public.trng_trn_ttrainerleave_trainerleave_gidseq'::regclass) NOT NULL,
    trainer_id public.udd_code NOT NULL,
    leave_date public.udd_date NOT NULL,
    leave_desc public.udd_desc NOT NULL,
    status_code public.udd_code NOT NULL,
    created_date public.udd_datetime NOT NULL,
    created_by public.udd_user NOT NULL,
    updated_date public.udd_datetime,
    updated_by public.udd_user
);


ALTER TABLE public.trng_trn_ttrainerleave OWNER TO postgres;

--
-- Name: url_shortener; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.url_shortener (
    id bigint NOT NULL,
    creation_date timestamp without time zone,
    expiration_date timestamp without time zone,
    original_url text,
    short_link character varying(255),
    tprogrambatch_id character varying(255),
    trainerpart_id character varying(255)
);


ALTER TABLE public.url_shortener OWNER TO postgres;

--
-- Name: village_master_copy_village_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.village_master_copy_village_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.village_master_copy_village_id_seq OWNER TO postgres;

--
-- Name: village_master_copy_village_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.village_master_copy_village_id_seq OWNED BY public.village_master.village_id;


--
-- Name: block_master block_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_master ALTER COLUMN block_id SET DEFAULT nextval('public.block_master_copy_block_id_seq'::regclass);


--
-- Name: core_mst_tmetadata metadata_gid; Type: DEFAULT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.core_mst_tmetadata ALTER COLUMN metadata_gid SET DEFAULT nextval('public.core_mst_tmetadata_metadata_gid_seq'::regclass);


--
-- Name: core_mst_tmetadatamsg metadatamsg_gid; Type: DEFAULT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.core_mst_tmetadatamsg ALTER COLUMN metadatamsg_gid SET DEFAULT nextval('public.core_mst_tmetadatamsg_metadatamsg_gid_seq'::regclass);


--
-- Name: core_mst_tscreensp screensp_gid; Type: DEFAULT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.core_mst_tscreensp ALTER COLUMN screensp_gid SET DEFAULT nextval('public.core_mst_tscreensp_screensp_gid_seq'::regclass);


--
-- Name: district_master district_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.district_master ALTER COLUMN district_id SET DEFAULT nextval('public.district_master_copy_district_id_seq'::regclass);


--
-- Name: panchayat_master panchayat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.panchayat_master ALTER COLUMN panchayat_id SET DEFAULT nextval('public.panchayat_master_copy_panchayat_id_seq'::regclass);


--
-- Name: state_master state_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state_master ALTER COLUMN state_id SET DEFAULT nextval('public.state_master_state_id_seq'::regclass);


--
-- Name: trng_mst_tcoursecontent coursecontent_gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tcoursecontent ALTER COLUMN coursecontent_gid SET DEFAULT nextval('public.trng_mst_tcoursecontent_coursecontent_gid_seq'::regclass);


--
-- Name: trng_mst_tcoursereviewerhistory coursereviewerhistory_gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tcoursereviewerhistory ALTER COLUMN coursereviewerhistory_gid SET DEFAULT nextval('public.trng_mst_tcoursereviewerhistory_coursereviewerhistory_gid_seq'::regclass);


--
-- Name: trng_mst_ttrainerattachment trainerattachment_gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainerattachment ALTER COLUMN trainerattachment_gid SET DEFAULT nextval('public.trng_mst_ttrainerattachment_trainerattachment_gid_seq'::regclass);


--
-- Name: trng_mst_ttrainernote trainernote_gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainernote ALTER COLUMN trainernote_gid SET DEFAULT nextval('public.trng_mst_ttrainernote_trainernote_gid_seq'::regclass);


--
-- Name: trng_mst_ttrainingorgattachment trngorgattachment_gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainingorgattachment ALTER COLUMN trngorgattachment_gid SET DEFAULT nextval('public.trng_mst_ttrainingorgattachment_trngorgattachment_gid_seq'::regclass);


--
-- Name: trng_mst_ttrainingorggroup trngorggroup_gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainingorggroup ALTER COLUMN trngorggroup_gid SET DEFAULT nextval('public.trng_mst_ttrainingorggroup_trngorggroup_gid_seq'::regclass);


--
-- Name: trng_mst_ttrainingorgnote trngorgnote_gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainingorgnote ALTER COLUMN trngorgnote_gid SET DEFAULT nextval('public.trng_mst_ttrainingorgnote_trngorgnote_gid_seq'::regclass);


--
-- Name: trng_trn_tfeedbackparticipant feedbackparticipant_gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_tfeedbackparticipant ALTER COLUMN feedbackparticipant_gid SET DEFAULT nextval('public.trng_trn_tfeedbackparticipant_feedbackparticipant_gid_seq'::regclass);


--
-- Name: trng_trn_tfeedbacktrainer feedbacktrainer_gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_tfeedbacktrainer ALTER COLUMN feedbacktrainer_gid SET DEFAULT nextval('public.trng_trn_tfeedbacktrainer_feedbacktrainer_gid_seq'::regclass);


--
-- Name: trng_trn_tmobilevenuemapping mobvenuemap_gid; Type: DEFAULT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.trng_trn_tmobilevenuemapping ALTER COLUMN mobvenuemap_gid SET DEFAULT nextval('public.trng_trn_tmobilevenuemapping_mobvenuemap_gid_seq'::regclass);


--
-- Name: trng_trn_ttprogrambudget tprogrambudget_gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogrambudget ALTER COLUMN tprogrambudget_gid SET DEFAULT nextval('public.trng_trn_ttprogrambudget_tprogrambudget_gid_seq'::regclass);


--
-- Name: trng_trn_ttprogramparticipant tprogramparticipant_gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogramparticipant ALTER COLUMN tprogramparticipant_gid SET DEFAULT nextval('public.trng_trn_ttprogramparticipant_tprogramparticipant_gid_seq1'::regclass);


--
-- Name: village_master village_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.village_master ALTER COLUMN village_id SET DEFAULT nextval('public.village_master_copy_village_id_seq'::regclass);


--
-- Name: bank_branch_master bank_branch_master_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_branch_master
    ADD CONSTRAINT bank_branch_master_pkey PRIMARY KEY (bank_branch_id);


--
-- Name: bank_master bank_master_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_master
    ADD CONSTRAINT bank_master_pkey PRIMARY KEY (bank_id);


--
-- Name: block_master block_master_copy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_master
    ADD CONSTRAINT block_master_copy_pkey PRIMARY KEY (block_id);


--
-- Name: ccp_district_state ccp_district_state_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.ccp_district_state
    ADD CONSTRAINT ccp_district_state_pkey PRIMARY KEY (ccp_id);


--
-- Name: ccp_district_state_sub ccp_district_state_sub_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.ccp_district_state_sub
    ADD CONSTRAINT ccp_district_state_sub_pkey PRIMARY KEY (sub_id);


--
-- Name: core_mst_tconfig core_mst_tconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tconfig
    ADD CONSTRAINT core_mst_tconfig_pkey PRIMARY KEY (config_gid);


--
-- Name: core_mst_tdevicedocnum core_mst_tdevicedocnum_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tdevicedocnum
    ADD CONSTRAINT core_mst_tdevicedocnum_pkey PRIMARY KEY (devicedocnum_gid);


--
-- Name: core_mst_tdevicedocnum core_mst_tdevicedocnum_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tdevicedocnum
    ADD CONSTRAINT core_mst_tdevicedocnum_ukey UNIQUE (activity_code, devicetoken, tran_date);


--
-- Name: core_mst_tdocnum core_mst_tdocnum_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tdocnum
    ADD CONSTRAINT core_mst_tdocnum_pkey PRIMARY KEY (docnum_gid);


--
-- Name: core_mst_temailtemplate core_mst_temailtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.core_mst_temailtemplate
    ADD CONSTRAINT core_mst_temailtemplate_pkey PRIMARY KEY (emailtemplate_gid);


--
-- Name: core_mst_tifsc core_mst_tifsc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tifsc
    ADD CONSTRAINT core_mst_tifsc_pkey PRIMARY KEY (ifsc_gid);


--
-- Name: core_mst_tinterfaceurl core_mst_tinterfaceurl_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tinterfaceurl
    ADD CONSTRAINT core_mst_tinterfaceurl_pkey PRIMARY KEY (ifaceurl_gid);


--
-- Name: core_mst_tlanguage core_mst_tlanguage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tlanguage
    ADD CONSTRAINT core_mst_tlanguage_pkey PRIMARY KEY (lang_gid);


--
-- Name: core_mst_tmaster core_mst_tmaster_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tmaster
    ADD CONSTRAINT core_mst_tmaster_pkey PRIMARY KEY (master_gid);


--
-- Name: core_mst_tmastertranslate core_mst_tmastertranslate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tmastertranslate
    ADD CONSTRAINT core_mst_tmastertranslate_pkey PRIMARY KEY (mastertranslate_gid);


--
-- Name: core_mst_tmenu core_mst_tmenu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tmenu
    ADD CONSTRAINT core_mst_tmenu_pkey PRIMARY KEY (menu_gid);


--
-- Name: core_mst_tmenutranslate core_mst_tmenutranslate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tmenutranslate
    ADD CONSTRAINT core_mst_tmenutranslate_pkey PRIMARY KEY (menutranslate_gid);


--
-- Name: core_mst_tmessage core_mst_tmessage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tmessage
    ADD CONSTRAINT core_mst_tmessage_pkey PRIMARY KEY (msg_gid);


--
-- Name: core_mst_tmessagetranslate core_mst_tmessagetranslate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tmessagetranslate
    ADD CONSTRAINT core_mst_tmessagetranslate_pkey PRIMARY KEY (msgtranslate_gid);


--
-- Name: core_mst_tmessagetranslate core_mst_tmessagetranslate_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tmessagetranslate
    ADD CONSTRAINT core_mst_tmessagetranslate_ukey UNIQUE (msg_code, lang_code);


--
-- Name: core_mst_tmetadata core_mst_tmetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.core_mst_tmetadata
    ADD CONSTRAINT core_mst_tmetadata_pkey PRIMARY KEY (metadata_gid);


--
-- Name: core_mst_tmetadata core_mst_tmetadata_ukey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.core_mst_tmetadata
    ADD CONSTRAINT core_mst_tmetadata_ukey UNIQUE (metadata_code);


--
-- Name: core_mst_tmetadatamsg core_mst_tmetadatamsg_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.core_mst_tmetadatamsg
    ADD CONSTRAINT core_mst_tmetadatamsg_pkey PRIMARY KEY (metadatamsg_gid);


--
-- Name: core_mst_tmetadatamsg core_mst_tmetadatamsg_ukey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.core_mst_tmetadatamsg
    ADD CONSTRAINT core_mst_tmetadatamsg_ukey UNIQUE (metadata_code, msg_code);


--
-- Name: core_mst_tmobilesync core_mst_tmobilesync_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tmobilesync
    ADD CONSTRAINT core_mst_tmobilesync_ukey UNIQUE (tprogram_id, role_code, user_code, sync_type_code);


--
-- Name: core_mst_tmobilesynctable core_mst_tmobilesynctable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tmobilesynctable
    ADD CONSTRAINT core_mst_tmobilesynctable_pkey PRIMARY KEY (mobilesynctable_gid);


--
-- Name: core_mst_tpatchqry core_mst_tpatchqry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tpatchqry
    ADD CONSTRAINT core_mst_tpatchqry_pkey PRIMARY KEY (patchqry_gid);


--
-- Name: core_mst_trole core_mst_trole_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_trole
    ADD CONSTRAINT core_mst_trole_pkey PRIMARY KEY (role_gid);


--
-- Name: core_mst_trolemenurights core_mst_trolemenurights_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_trolemenurights
    ADD CONSTRAINT core_mst_trolemenurights_pkey PRIMARY KEY (rolemenurights_gid);


--
-- Name: core_mst_tscreen core_mst_tscreen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tscreen
    ADD CONSTRAINT core_mst_tscreen_pkey PRIMARY KEY (screen_gid);


--
-- Name: core_mst_tscreendata core_mst_tscreendata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tscreendata
    ADD CONSTRAINT core_mst_tscreendata_pkey PRIMARY KEY (screendata_gid);


--
-- Name: core_mst_tscreensp core_mst_tscreensp_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.core_mst_tscreensp
    ADD CONSTRAINT core_mst_tscreensp_pkey PRIMARY KEY (screensp_gid);


--
-- Name: core_mst_tscreensp core_mst_tscreensp_ukey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.core_mst_tscreensp
    ADD CONSTRAINT core_mst_tscreensp_ukey UNIQUE (screen_code, sp_code);


--
-- Name: core_mst_tsmstemplate core_mst_tsmstemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tsmstemplate
    ADD CONSTRAINT core_mst_tsmstemplate_pkey PRIMARY KEY (smstemplate_gid);


--
-- Name: core_mst_ttenantidentifier core_mst_ttenantidentifier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_ttenantidentifier
    ADD CONSTRAINT core_mst_ttenantidentifier_pkey PRIMARY KEY (tenant_gid);


--
-- Name: core_mst_tuser core_mst_tuser_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tuser
    ADD CONSTRAINT core_mst_tuser_pkey PRIMARY KEY (user_gid);


--
-- Name: core_mst_tuser core_mst_tuser_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tuser
    ADD CONSTRAINT core_mst_tuser_ukey UNIQUE (user_code, role_code);


--
-- Name: core_mst_tuserblock core_mst_tuserblock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tuserblock
    ADD CONSTRAINT core_mst_tuserblock_pkey PRIMARY KEY (userblock_gid);


--
-- Name: core_mst_tuserblock core_mst_tuserblock_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tuserblock
    ADD CONSTRAINT core_mst_tuserblock_unique UNIQUE (user_code);


--
-- Name: core_mst_tusertoken core_mst_tusertoken_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tusertoken
    ADD CONSTRAINT core_mst_tusertoken_pkey PRIMARY KEY (token_gid);


--
-- Name: core_mst_tusertoken core_mst_tusertoken_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tusertoken
    ADD CONSTRAINT core_mst_tusertoken_ukey UNIQUE (user_code, url) INCLUDE (user_code, url);


--
-- Name: district_master district_master_copy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.district_master
    ADD CONSTRAINT district_master_copy_pkey PRIMARY KEY (district_id);


--
-- Name: federation_profile_consolidated federation_profile_consolidated_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.federation_profile_consolidated
    ADD CONSTRAINT federation_profile_consolidated_pkey PRIMARY KEY (local_id);


--
-- Name: member_profile_consolidated member_profile_consolidated_pkey_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_profile_consolidated
    ADD CONSTRAINT member_profile_consolidated_pkey_1 PRIMARY KEY (local_id);


--
-- Name: member_profile_consolidated_tmp member_profile_consolidated_tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.member_profile_consolidated_tmp
    ADD CONSTRAINT member_profile_consolidated_tmp_pkey PRIMARY KEY (local_id);


--
-- Name: panchayat_master panchayat_master_copy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.panchayat_master
    ADD CONSTRAINT panchayat_master_copy_pkey PRIMARY KEY (panchayat_id);


--
-- Name: core_mst_tmobilesync pkey_core_mst_tmobilesync; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_mst_tmobilesync
    ADD CONSTRAINT pkey_core_mst_tmobilesync PRIMARY KEY (tprogram_id, role_code, user_code, sync_type_code);


--
-- Name: shg_profile_consolidated shg_profile_consolidated_pkey_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shg_profile_consolidated
    ADD CONSTRAINT shg_profile_consolidated_pkey_1 PRIMARY KEY (local_id);


--
-- Name: state_master state_master_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state_master
    ADD CONSTRAINT state_master_pkey PRIMARY KEY (state_id);


--
-- Name: trng_trn_ttpurllink tpurllink_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.trng_trn_ttpurllink
    ADD CONSTRAINT tpurllink_pkey PRIMARY KEY (tpurllink);


--
-- Name: trng_mst_tattachment trng_mst_tattachment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tattachment
    ADD CONSTRAINT trng_mst_tattachment_pkey PRIMARY KEY (attachment_gid);


--
-- Name: trng_mst_tcadreuser_flexi trng_mst_tcadreuser_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tcadreuser_flexi
    ADD CONSTRAINT trng_mst_tcadreuser_pkey PRIMARY KEY (cadreuser_gid);


--
-- Name: trng_mst_tcourse trng_mst_tcourse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tcourse
    ADD CONSTRAINT trng_mst_tcourse_pkey PRIMARY KEY (course_gid);


--
-- Name: trng_mst_tcourseapproval trng_mst_tcourseapproval_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tcourseapproval
    ADD CONSTRAINT trng_mst_tcourseapproval_pkey PRIMARY KEY (courseapproval_gid);


--
-- Name: trng_mst_tcoursecontent trng_mst_tcoursecontent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tcoursecontent
    ADD CONSTRAINT trng_mst_tcoursecontent_pkey PRIMARY KEY (coursecontent_gid);


--
-- Name: trng_mst_tcoursemodule trng_mst_tcoursemodule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tcoursemodule
    ADD CONSTRAINT trng_mst_tcoursemodule_pkey PRIMARY KEY (coursemodule_gid);


--
-- Name: trng_mst_tcoursereviewerhistory trng_mst_tcoursereviewerhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tcoursereviewerhistory
    ADD CONSTRAINT trng_mst_tcoursereviewerhistory_pkey PRIMARY KEY (coursereviewerhistory_gid);


--
-- Name: trng_mst_tcoursetrainer trng_mst_tcoursetrainer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tcoursetrainer
    ADD CONSTRAINT trng_mst_tcoursetrainer_pkey PRIMARY KEY (coursetrainer_gid);


--
-- Name: trng_trn_tmobilevenuemapping trng_mst_tmobvenuemap_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.trng_trn_tmobilevenuemapping
    ADD CONSTRAINT trng_mst_tmobvenuemap_pkey PRIMARY KEY (mobvenuemap_gid);


--
-- Name: trng_mst_tnote trng_mst_tnote_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tnote
    ADD CONSTRAINT trng_mst_tnote_pkey PRIMARY KEY (note_gid);


--
-- Name: trng_mst_tquestion trng_mst_tquestion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tquestion
    ADD CONSTRAINT trng_mst_tquestion_pkey PRIMARY KEY (question_gid);


--
-- Name: trng_mst_tquestionaire trng_mst_tquestionaire_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tquestionaire
    ADD CONSTRAINT trng_mst_tquestionaire_pkey PRIMARY KEY (questionaire_gid);


--
-- Name: trng_mst_tquestionairegrp trng_mst_tquestionairegrp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tquestionairegrp
    ADD CONSTRAINT trng_mst_tquestionairegrp_pkey PRIMARY KEY (questionairegrp_gid);


--
-- Name: trng_mst_tquestionairegrp trng_mst_tquestionairegrp_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tquestionairegrp
    ADD CONSTRAINT trng_mst_tquestionairegrp_ukey UNIQUE (questionaire_id, questionairegrp_id);


--
-- Name: trng_mst_tquestionairegrptranslate trng_mst_tquestionairegrptranslate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tquestionairegrptranslate
    ADD CONSTRAINT trng_mst_tquestionairegrptranslate_pkey PRIMARY KEY (questionairegrptranslate_gid);


--
-- Name: trng_mst_tquestiontranslate trng_mst_tquestiontranslate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tquestiontranslate
    ADD CONSTRAINT trng_mst_tquestiontranslate_pkey PRIMARY KEY (questiontranslate_gid);


--
-- Name: trng_mst_ttrainer trng_mst_ttrainer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainer
    ADD CONSTRAINT trng_mst_ttrainer_pkey PRIMARY KEY (trainer_gid);


--
-- Name: trng_mst_ttrainer trng_mst_ttrainer_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainer
    ADD CONSTRAINT trng_mst_ttrainer_ukey UNIQUE (trainer_id, cadre_id);


--
-- Name: trng_mst_ttraineraddr trng_mst_ttraineraddr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttraineraddr
    ADD CONSTRAINT trng_mst_ttraineraddr_pkey PRIMARY KEY (traineraddr_gid);


--
-- Name: trng_mst_ttrainerattachment trng_mst_ttrainerattachment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainerattachment
    ADD CONSTRAINT trng_mst_ttrainerattachment_pkey PRIMARY KEY (trainerattachment_gid);


--
-- Name: trng_mst_ttrainerbank trng_mst_ttrainerbank_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainerbank
    ADD CONSTRAINT trng_mst_ttrainerbank_pkey PRIMARY KEY (trainerbank_gid);


--
-- Name: trng_mst_ttrainerdomain trng_mst_ttrainerdomain_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainerdomain
    ADD CONSTRAINT trng_mst_ttrainerdomain_pkey PRIMARY KEY (trainerdomain_gid);


--
-- Name: trng_mst_ttrainergeo trng_mst_ttrainergeo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainergeo
    ADD CONSTRAINT trng_mst_ttrainergeo_pkey PRIMARY KEY (trainergeo_gid);


--
-- Name: trng_mst_ttrainergroup trng_mst_ttrainergroup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainergroup
    ADD CONSTRAINT trng_mst_ttrainergroup_pkey PRIMARY KEY (trainergroup_gid);


--
-- Name: trng_mst_ttrainergroup trng_mst_ttrainergroup_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainergroup
    ADD CONSTRAINT trng_mst_ttrainergroup_ukey UNIQUE (trngorg_type_code, trngorg_id, trainer_id);


--
-- Name: trng_mst_ttrainerlang trng_mst_ttrainerlang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainerlang
    ADD CONSTRAINT trng_mst_ttrainerlang_pkey PRIMARY KEY (trainerlang_gid);


--
-- Name: trng_mst_ttrainernote trng_mst_ttrainernote_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainernote
    ADD CONSTRAINT trng_mst_ttrainernote_pkey PRIMARY KEY (trainernote_gid);


--
-- Name: trng_mst_ttrainingorg trng_mst_ttrainingorg_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainingorg
    ADD CONSTRAINT trng_mst_ttrainingorg_pkey PRIMARY KEY (trngorg_gid);


--
-- Name: trng_mst_ttrainingorgaddr trng_mst_ttrainingorgaddr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainingorgaddr
    ADD CONSTRAINT trng_mst_ttrainingorgaddr_pkey PRIMARY KEY (trngorgaddr_gid);


--
-- Name: trng_mst_ttrainingorgattachment trng_mst_ttrainingorgattachment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainingorgattachment
    ADD CONSTRAINT trng_mst_ttrainingorgattachment_pkey PRIMARY KEY (trngorgattachment_gid);


--
-- Name: trng_mst_ttrainingorgbank trng_mst_ttrainingorgbank_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainingorgbank
    ADD CONSTRAINT trng_mst_ttrainingorgbank_pkey PRIMARY KEY (trngorgbank_gid);


--
-- Name: trng_mst_ttrainingorgdomain trng_mst_ttrainingorgdomain_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainingorgdomain
    ADD CONSTRAINT trng_mst_ttrainingorgdomain_pkey PRIMARY KEY (trngorgdomain_gid);


--
-- Name: trng_mst_ttrainingorggeo trng_mst_ttrainingorggeo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainingorggeo
    ADD CONSTRAINT trng_mst_ttrainingorggeo_pkey PRIMARY KEY (trngorggeo_gid);


--
-- Name: trng_mst_ttrainingorggroup trng_mst_ttrainingorggroup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainingorggroup
    ADD CONSTRAINT trng_mst_ttrainingorggroup_pkey PRIMARY KEY (trngorggroup_gid);


--
-- Name: trng_mst_ttrainingorgnote trng_mst_ttrainingorgnote_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_ttrainingorgnote
    ADD CONSTRAINT trng_mst_ttrainingorgnote_pkey PRIMARY KEY (trngorgnote_gid);


--
-- Name: trng_mst_tvenue trng_mst_tvenue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tvenue
    ADD CONSTRAINT trng_mst_tvenue_pkey PRIMARY KEY (venue_gid);


--
-- Name: trng_mst_tvenue trng_mst_tvenue_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tvenue
    ADD CONSTRAINT trng_mst_tvenue_ukey UNIQUE (venue_id);


--
-- Name: trng_mst_tvenueaddr trng_mst_tvenueaddr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tvenueaddr
    ADD CONSTRAINT trng_mst_tvenueaddr_pkey PRIMARY KEY (venueaddr_gid);


--
-- Name: trng_mst_tvenueinfra trng_mst_tvenueinfra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_mst_tvenueinfra
    ADD CONSTRAINT trng_mst_tvenueinfra_pkey PRIMARY KEY (venueinfra_gid);


--
-- Name: trng_mst_tvenueinfradtl trng_mst_tvenueinfradtl_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.trng_mst_tvenueinfradtl
    ADD CONSTRAINT trng_mst_tvenueinfradtl_pkey PRIMARY KEY (venueinfradtl_gid);


--
-- Name: trng_trn_temailtran trng_trn_temailtran_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.trng_trn_temailtran
    ADD CONSTRAINT trng_trn_temailtran_pkey PRIMARY KEY (emailtran_gid);


--
-- Name: trng_trn_tfeedbackparticipant trng_trn_tfeedbackparticipant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_tfeedbackparticipant
    ADD CONSTRAINT trng_trn_tfeedbackparticipant_pkey PRIMARY KEY (feedbackparticipant_gid);


--
-- Name: trng_trn_tfeedbackparticipant trng_trn_tfeedbackparticipant_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_tfeedbackparticipant
    ADD CONSTRAINT trng_trn_tfeedbackparticipant_ukey UNIQUE (tprogram_id, tprogrambatch_id, participant_id, lang_code, questionaire_id, question_id);


--
-- Name: trng_trn_tfeedbacktrainer trng_trn_tfeedbacktrainer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_tfeedbacktrainer
    ADD CONSTRAINT trng_trn_tfeedbacktrainer_pkey PRIMARY KEY (feedbacktrainer_gid);


--
-- Name: trng_trn_tfeedbacktrainer trng_trn_tfeedbacktrainer_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_tfeedbacktrainer
    ADD CONSTRAINT trng_trn_tfeedbacktrainer_ukey UNIQUE (tprogram_id, tprogrambatch_id, trainer_id, lang_code, questionaire_id, question_id);


--
-- Name: trng_trn_tloginhistory trng_trn_tloginhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_tloginhistory
    ADD CONSTRAINT trng_trn_tloginhistory_pkey PRIMARY KEY (loginhistory_gid);


--
-- Name: trng_trn_tsmstran trng_trn_tsmstran_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.trng_trn_tsmstran
    ADD CONSTRAINT trng_trn_tsmstran_pkey PRIMARY KEY (smstran_gid);


--
-- Name: trng_trn_tsqliteattachment trng_trn_tsqliteattachment_pkey; Type: CONSTRAINT; Schema: public; Owner: flexi
--

ALTER TABLE ONLY public.trng_trn_tsqliteattachment
    ADD CONSTRAINT trng_trn_tsqliteattachment_pkey PRIMARY KEY (sqliteattachment_gid);


--
-- Name: trng_trn_ttprogram trng_trn_ttprogram_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogram
    ADD CONSTRAINT trng_trn_ttprogram_pkey PRIMARY KEY (tprogram_gid);


--
-- Name: trng_trn_ttprogramapproval trng_trn_ttprogramapproval_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogramapproval
    ADD CONSTRAINT trng_trn_ttprogramapproval_pkey PRIMARY KEY (programapproval_gid);


--
-- Name: trng_trn_ttprogrambatch trng_trn_ttprogrambatch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogrambatch
    ADD CONSTRAINT trng_trn_ttprogrambatch_pkey PRIMARY KEY (tprogrambatch_gid);


--
-- Name: trng_trn_ttprogrambatchattachment trng_trn_ttprogrambatchattachment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogrambatchattachment
    ADD CONSTRAINT trng_trn_ttprogrambatchattachment_pkey PRIMARY KEY (tprogrambatchattachment_gid);


--
-- Name: trng_trn_ttprogrambatchcount trng_trn_ttprogrambatchcount_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogrambatchcount
    ADD CONSTRAINT trng_trn_ttprogrambatchcount_pkey PRIMARY KEY (tprogrambatchcount_gid);


--
-- Name: trng_trn_ttprogrambatchcount trng_trn_ttprogrambatchcount_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogrambatchcount
    ADD CONSTRAINT trng_trn_ttprogrambatchcount_ukey UNIQUE (tprogram_id, tprogrambatch_id, batch_date);


--
-- Name: trng_trn_ttprogrambudget trng_trn_ttprogrambudget_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogrambudget
    ADD CONSTRAINT trng_trn_ttprogrambudget_pkey PRIMARY KEY (tprogrambudget_gid);


--
-- Name: trng_trn_ttprogramexpense trng_trn_ttprogramexpense_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogramexpense
    ADD CONSTRAINT trng_trn_ttprogramexpense_pkey PRIMARY KEY (tprogramexpense_gid);


--
-- Name: trng_trn_ttprogramgeo trng_trn_ttprogramgeo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogramgeo
    ADD CONSTRAINT trng_trn_ttprogramgeo_pkey PRIMARY KEY (tprogramgeo_gid);


--
-- Name: trng_trn_ttprogramparticipant trng_trn_ttprogramparticipant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogramparticipant
    ADD CONSTRAINT trng_trn_ttprogramparticipant_pkey PRIMARY KEY (tprogramparticipant_gid);


--
-- Name: trng_trn_ttprogramparticipant trng_trn_ttprogramparticipant_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogramparticipant
    ADD CONSTRAINT trng_trn_ttprogramparticipant_ukey UNIQUE (tprogram_id, tprogrambatch_id, batch_date, participant_id);


--
-- Name: trng_trn_ttprogramtrainer trng_trn_ttprogramtrainer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogramtrainer
    ADD CONSTRAINT trng_trn_ttprogramtrainer_pkey PRIMARY KEY (tprogramtrainer_gid);


--
-- Name: trng_trn_ttprogramtrainer trng_trn_ttprogramtrainer_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttprogramtrainer
    ADD CONSTRAINT trng_trn_ttprogramtrainer_ukey UNIQUE (tprogram_id, tprogrambatch_id, trainer_id);


--
-- Name: trng_trn_ttrainerleave trng_trn_ttrainerleave_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trng_trn_ttrainerleave
    ADD CONSTRAINT trng_trn_ttrainerleave_pkey PRIMARY KEY (trainerleave_gid);


--
-- Name: url_shortener url_shortener_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.url_shortener
    ADD CONSTRAINT url_shortener_pkey PRIMARY KEY (id);


--
-- Name: village_master village_master_copy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.village_master
    ADD CONSTRAINT village_master_copy_pkey PRIMARY KEY (village_id);


--
-- Name: dx_core_mst_tmobilesync_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX dx_core_mst_tmobilesync_unique ON public.core_mst_tmobilesync USING btree (tprogram_id, role_code, user_code, mobile_no, sync_type_code);


--
-- Name: idx_bankbranch; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bankbranch ON public.bank_branch_master USING btree (bank_branch_id);


--
-- Name: idx_block; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_block ON public.block_master USING btree (block_code);


--
-- Name: idx_branch; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_branch ON public.bank_branch_master USING btree (bank_id, bank_branch_id);


--
-- Name: idx_district; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_district ON public.district_master USING btree (district_code);


--
-- Name: idx_member_profile_consd_state_code_cbo_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_member_profile_consd_state_code_cbo_code ON public.federation_profile_consolidated USING btree (state_code, cbo_code);


--
-- Name: idx_member_profile_consd_state_code_member_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_member_profile_consd_state_code_member_code ON public.member_profile_consolidated USING btree (state_code, member_code);


--
-- Name: idx_mobilesynctable_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_mobilesynctable_unique ON public.core_mst_tmobilesynctable USING btree (db_schema_name, src_table_name, sync_group_name, role_code);


--
-- Name: idx_panchayat; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_panchayat ON public.panchayat_master USING btree (panchayat_code);


--
-- Name: idx_shg_profile_consd_state_code_shg_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shg_profile_consd_state_code_shg_code ON public.shg_profile_consolidated USING btree (state_code, shg_code);


--
-- Name: idx_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_state ON public.state_master USING btree (state_code);


--
-- Name: idx_unique_ifsc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_ifsc ON public.core_mst_tifsc USING btree (ifsc_code);


--
-- Name: idx_unique_language; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_language ON public.core_mst_tlanguage USING btree (lang_code);


--
-- Name: idx_unique_master; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_master ON public.core_mst_tmaster USING btree (parent_code, master_code);


--
-- Name: idx_unique_mastertranslate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_mastertranslate ON public.core_mst_tmastertranslate USING btree (parent_code, master_code, lang_code);


--
-- Name: idx_unique_menu; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_menu ON public.core_mst_tmenu USING btree (menu_code);


--
-- Name: idx_unique_menutranslate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_menutranslate ON public.core_mst_tmenutranslate USING btree (menu_code, lang_code);


--
-- Name: idx_unique_msg; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_msg ON public.core_mst_tmessage USING btree (msg_code);


--
-- Name: idx_unique_msgtranslate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_unique_msgtranslate ON public.core_mst_tmessagetranslate USING btree (msg_code, lang_code);


--
-- Name: idx_unique_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_unique_role ON public.core_mst_trole USING btree (role_code);


--
-- Name: idx_unique_screen; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_unique_screen ON public.core_mst_tscreen USING btree (screen_code);


--
-- Name: idx_village; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_village ON public.village_master USING btree (state_id, district_id, block_id, panchayat_id, village_id, village_code);


--
-- Name: member_profile_consolidated_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX member_profile_consolidated_index ON public.member_profile_consolidated USING btree (state_code, member_code);


--
-- Name: member_profile_consolidated_shg_code_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX member_profile_consolidated_shg_code_index ON public.member_profile_consolidated USING btree (state_code, member_code, shg_code);


--
-- Name: shg_profile_consolidated_parent_cbo_code_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shg_profile_consolidated_parent_cbo_code_idx ON public.shg_profile_consolidated USING btree (parent_cbo_code);


--
-- Name: district_master fk5j4lfqocro3n0xh0bhd2ouxc5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.district_master
    ADD CONSTRAINT fk5j4lfqocro3n0xh0bhd2ouxc5 FOREIGN KEY (state_id) REFERENCES public.state_master(state_id);


--
-- PostgreSQL database dump complete
--

