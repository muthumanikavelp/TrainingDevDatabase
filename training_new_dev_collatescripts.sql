--
-- Name: case_insensitive; Type: COLLATION; Schema: public; Owner: postgres
--

CREATE COLLATION public.case_insensitive (provider = icu, deterministic = false, locale = 'und-u-ks-level2');


ALTER COLLATION public.case_insensitive OWNER TO postgres;

--
-- Name: case_insensitive2; Type: COLLATION; Schema: public; Owner: postgres
--

CREATE COLLATION public.case_insensitive2 (provider = icu, deterministic = false, locale = 'und-u-ks-level2');


ALTER COLLATION public.case_insensitive2 OWNER TO postgres;

--
-- Name: english_ci; Type: COLLATION; Schema: public; Owner: postgres
--

CREATE COLLATION public.english_ci (provider = icu, deterministic = false, locale = 'en-US-u-ks-level2');


ALTER COLLATION public.english_ci OWNER TO postgres;
