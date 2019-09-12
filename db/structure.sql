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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: person_comment_origin; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.person_comment_origin AS ENUM (
    'general_comments',
    'first_contact_date',
    'latest_contact_date',
    'human_readable_id',
    'past_experience',
    'aid_at_2014_elections',
    'aid_at_2015_elections'
);


--
-- Name: relationship_federal_secretary_flag; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.relationship_federal_secretary_flag AS ENUM (
    'federal_secretary'
);


--
-- Name: relationship_regional_secretary_flag; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.relationship_regional_secretary_flag AS ENUM (
    'regional_secretary'
);


--
-- Name: relationship_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.relationship_role AS ENUM (
    'federal_manager',
    'federal_supervisor',
    'regional_manager',
    'regional_supervisor'
);


--
-- Name: relationship_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.relationship_status AS ENUM (
    'supporter',
    'excluded',
    'member'
);


--
-- Name: sex; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.sex AS ENUM (
    'male',
    'female'
);


--
-- Name: ensure_contact_list_id_matches_related_person(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ensure_contact_list_id_matches_related_person() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  person record;
BEGIN
  IF NEW.person_id IS NULL THEN
    RETURN NEW;
  END IF;

  SELECT * FROM people INTO person WHERE people.id = NEW.person_id;

  IF person IS NULL THEN
    RETURN NEW;
  END IF;

  IF NEW.contact_list_id IS DISTINCT FROM person.contact_list_id THEN
    RAISE EXCEPTION
      'column "contact_list_id" does not match related person';
  END IF;

  RETURN NEW;
END;
$$;


--
-- Name: ensure_contact_list_id_remains_unchanged(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ensure_contact_list_id_remains_unchanged() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.contact_list_id IS DISTINCT FROM OLD.contact_list_id THEN
    RAISE EXCEPTION 'can not change column "contact_list_id"';
  END IF;

  RETURN NEW;
END;
$$;


--
-- Name: ensure_superuser_has_related_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ensure_superuser_has_related_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  user record;
BEGIN
  IF NOT NEW.superuser THEN
    RETURN NEW;
  END IF;

  SELECT * FROM users INTO user WHERE users.account_id = NEW.id;

  IF user IS NULL THEN
    RAISE EXCEPTION 'does not have related user';
  END IF;

  RETURN NEW;
END;
$$;


--
-- Name: is_codename(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_codename(str text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN is_nickname(str);
END;
$$;


--
-- Name: is_good_big_text(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_good_big_text(str text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN is_good_limited_text(str, 10000);
END;
$$;


--
-- Name: is_good_limited_text(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_good_limited_text(str text, max_length integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN LENGTH(str) BETWEEN 1 AND max_length AND is_good_text(str);
END;
$$;


--
-- Name: is_good_small_text(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_good_small_text(str text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN is_good_limited_text(str, 255);
END;
$$;


--
-- Name: is_good_text(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_good_text(str text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
  RETURN str ~ '^[^[:space:]]+(.*[^[:space:]])?$';
END;
$_$;


--
-- Name: is_nickname(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_nickname(str text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
  RETURN length(str) BETWEEN 3 AND 36
    AND str ~ '^[a-z][a-z0-9]*(_[a-z0-9]+)*$';
END;
$_$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    nickname character varying NOT NULL,
    public_name character varying,
    biography text,
    superuser boolean DEFAULT false NOT NULL,
    timezone interval DEFAULT '03:00:00'::interval NOT NULL,
    person_id bigint,
    contact_list_id bigint NOT NULL,
    CONSTRAINT biography CHECK (((biography IS NULL) OR public.is_good_big_text(biography))),
    CONSTRAINT nickname CHECK (public.is_nickname((nickname)::text)),
    CONSTRAINT public_name CHECK (((public_name IS NULL) OR public.is_good_small_text((public_name)::text)))
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: contact_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contact_lists (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: contact_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contact_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contact_lists_id_seq OWNED BY public.contact_lists.id;


--
-- Name: contact_networks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contact_networks (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    codename character varying NOT NULL,
    name character varying NOT NULL,
    CONSTRAINT codename CHECK (public.is_codename((codename)::text)),
    CONSTRAINT name CHECK (public.is_good_small_text((name)::text))
);


--
-- Name: contact_networks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contact_networks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_networks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contact_networks_id_seq OWNED BY public.contact_networks.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    contact_list_id bigint NOT NULL,
    contact_network_id bigint NOT NULL,
    value character varying NOT NULL,
    send_security_notifications boolean DEFAULT false NOT NULL,
    CONSTRAINT value CHECK (public.is_good_small_text((value)::text))
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contacts_id_seq OWNED BY public.contacts.id;


--
-- Name: federal_subjects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.federal_subjects (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    english_name character varying NOT NULL,
    native_name character varying NOT NULL,
    centre character varying NOT NULL,
    number integer NOT NULL,
    timezone interval NOT NULL,
    CONSTRAINT centre CHECK (public.is_good_small_text((centre)::text)),
    CONSTRAINT english_name CHECK (public.is_good_small_text((english_name)::text)),
    CONSTRAINT native_name CHECK (public.is_good_small_text((native_name)::text)),
    CONSTRAINT number CHECK ((number > 0))
);


--
-- Name: federal_subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.federal_subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: federal_subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.federal_subjects_id_seq OWNED BY public.federal_subjects.id;


--
-- Name: passports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.passports (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    last_name character varying NOT NULL,
    first_name character varying NOT NULL,
    middle_name character varying,
    sex public.sex NOT NULL,
    date_of_birth date NOT NULL,
    place_of_birth character varying NOT NULL,
    series integer NOT NULL,
    number integer NOT NULL,
    issued_by text NOT NULL,
    unit_code character varying NOT NULL,
    date_of_issue date NOT NULL,
    person_id bigint,
    federal_subject_id bigint,
    zip_code character varying,
    town_type character varying,
    town_name character varying,
    settlement_type character varying,
    settlement_name character varying,
    district_type character varying,
    district_name character varying,
    street_type character varying,
    street_name character varying,
    residence_type character varying,
    residence_name character varying,
    building_type character varying,
    building_name character varying,
    apartment_type character varying,
    apartment_name character varying,
    CONSTRAINT apartment_name CHECK (((apartment_name IS NULL) OR public.is_good_small_text((apartment_name)::text))),
    CONSTRAINT apartment_type CHECK (((apartment_type IS NULL) OR public.is_good_small_text((apartment_type)::text))),
    CONSTRAINT building_name CHECK (((building_name IS NULL) OR public.is_good_small_text((building_name)::text))),
    CONSTRAINT building_type CHECK (((building_type IS NULL) OR public.is_good_small_text((building_type)::text))),
    CONSTRAINT district_name CHECK (((district_name IS NULL) OR public.is_good_small_text((district_name)::text))),
    CONSTRAINT district_type CHECK (((district_type IS NULL) OR public.is_good_small_text((district_type)::text))),
    CONSTRAINT residence_name CHECK (((residence_name IS NULL) OR public.is_good_small_text((residence_name)::text))),
    CONSTRAINT residence_type CHECK (((residence_type IS NULL) OR public.is_good_small_text((residence_type)::text))),
    CONSTRAINT settlement_name CHECK (((settlement_name IS NULL) OR public.is_good_small_text((settlement_name)::text))),
    CONSTRAINT settlement_type CHECK (((settlement_type IS NULL) OR public.is_good_small_text((settlement_type)::text))),
    CONSTRAINT street_name CHECK (((street_name IS NULL) OR public.is_good_small_text((street_name)::text))),
    CONSTRAINT street_type CHECK (((street_type IS NULL) OR public.is_good_small_text((street_type)::text))),
    CONSTRAINT town_name CHECK (((town_name IS NULL) OR public.is_good_small_text((town_name)::text))),
    CONSTRAINT town_type CHECK (((town_type IS NULL) OR public.is_good_small_text((town_type)::text))),
    CONSTRAINT zip_code CHECK (((zip_code IS NULL) OR public.is_good_small_text((zip_code)::text)))
);


--
-- Name: passports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.passports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: passports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.passports_id_seq OWNED BY public.passports.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    account_connection_token character varying,
    first_name character varying NOT NULL,
    middle_name character varying,
    last_name character varying NOT NULL,
    sex public.sex,
    date_of_birth date,
    place_of_birth character varying,
    contact_list_id bigint NOT NULL
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: person_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_comments (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    person_id bigint NOT NULL,
    account_id bigint,
    text text NOT NULL,
    origin public.person_comment_origin
);


--
-- Name: person_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.person_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.person_comments_id_seq OWNED BY public.person_comments.id;


--
-- Name: regional_offices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regional_offices (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    federal_subject_id bigint NOT NULL,
    name character varying NOT NULL,
    CONSTRAINT name CHECK (public.is_good_small_text((name)::text))
);


--
-- Name: regional_offices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regional_offices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regional_offices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regional_offices_id_seq OWNED BY public.regional_offices.id;


--
-- Name: relationships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.relationships (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    person_id bigint NOT NULL,
    regional_office_id bigint NOT NULL,
    initiator_account_id bigint,
    from_date date NOT NULL,
    status public.relationship_status NOT NULL,
    role public.relationship_role,
    federal_secretary_flag public.relationship_federal_secretary_flag,
    regional_secretary_flag public.relationship_regional_secretary_flag,
    CONSTRAINT federal_secretary_flag CHECK (((federal_secretary_flag IS NULL) OR (role = 'federal_manager'::public.relationship_role))),
    CONSTRAINT regional_secretary_flag CHECK (((regional_secretary_flag IS NULL) OR (role = 'regional_manager'::public.relationship_role))),
    CONSTRAINT role CHECK (((status = 'member'::public.relationship_status) OR (role IS NULL)))
);


--
-- Name: relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.relationships_id_seq OWNED BY public.relationships.id;


--
-- Name: rsa_public_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rsa_public_keys (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    public_key_pem text NOT NULL,
    private_key_pem_iv bytea,
    private_key_pem_ciphertext bytea,
    bits integer NOT NULL,
    sha1 character varying NOT NULL,
    sha256 character varying NOT NULL,
    CONSTRAINT bits CHECK ((bits = ANY (ARRAY[2048, 4096])))
);


--
-- Name: rsa_public_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rsa_public_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rsa_public_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rsa_public_keys_id_seq OWNED BY public.rsa_public_keys.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    account_id bigint NOT NULL,
    logged_at timestamp without time zone NOT NULL,
    ip_address character varying NOT NULL,
    user_agent character varying DEFAULT ''::character varying NOT NULL,
    CONSTRAINT ip_address CHECK (public.is_good_small_text((ip_address)::text)),
    CONSTRAINT user_agent CHECK ((((user_agent)::text = ''::text) OR public.is_good_big_text((user_agent)::text)))
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: user_omniauths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_omniauths (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id bigint,
    provider character varying NOT NULL,
    remote_id character varying NOT NULL,
    email character varying NOT NULL
);


--
-- Name: user_omniauths_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_omniauths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_omniauths_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_omniauths_id_seq OWNED BY public.user_omniauths.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    account_id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: x509_certificate_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x509_certificate_requests (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    rsa_public_key_id bigint NOT NULL,
    distinguished_name character varying NOT NULL,
    pem text NOT NULL,
    CONSTRAINT distinguished_name CHECK (public.is_good_big_text((distinguished_name)::text))
);


--
-- Name: x509_certificate_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.x509_certificate_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: x509_certificate_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.x509_certificate_requests_id_seq OWNED BY public.x509_certificate_requests.id;


--
-- Name: x509_certificates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x509_certificates (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    rsa_public_key_id bigint NOT NULL,
    x509_certificate_request_id bigint,
    pem text NOT NULL,
    subject character varying NOT NULL,
    issuer character varying NOT NULL,
    not_before timestamp without time zone NOT NULL,
    not_after timestamp without time zone NOT NULL
);


--
-- Name: x509_certificates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.x509_certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: x509_certificates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.x509_certificates_id_seq OWNED BY public.x509_certificates.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: contact_lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_lists ALTER COLUMN id SET DEFAULT nextval('public.contact_lists_id_seq'::regclass);


--
-- Name: contact_networks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_networks ALTER COLUMN id SET DEFAULT nextval('public.contact_networks_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts ALTER COLUMN id SET DEFAULT nextval('public.contacts_id_seq'::regclass);


--
-- Name: federal_subjects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.federal_subjects ALTER COLUMN id SET DEFAULT nextval('public.federal_subjects_id_seq'::regclass);


--
-- Name: passports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passports ALTER COLUMN id SET DEFAULT nextval('public.passports_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: person_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_comments ALTER COLUMN id SET DEFAULT nextval('public.person_comments_id_seq'::regclass);


--
-- Name: regional_offices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_offices ALTER COLUMN id SET DEFAULT nextval('public.regional_offices_id_seq'::regclass);


--
-- Name: relationships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relationships ALTER COLUMN id SET DEFAULT nextval('public.relationships_id_seq'::regclass);


--
-- Name: rsa_public_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rsa_public_keys ALTER COLUMN id SET DEFAULT nextval('public.rsa_public_keys_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: user_omniauths id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_omniauths ALTER COLUMN id SET DEFAULT nextval('public.user_omniauths_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: x509_certificate_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x509_certificate_requests ALTER COLUMN id SET DEFAULT nextval('public.x509_certificate_requests_id_seq'::regclass);


--
-- Name: x509_certificates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x509_certificates ALTER COLUMN id SET DEFAULT nextval('public.x509_certificates_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: contact_lists contact_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_lists
    ADD CONSTRAINT contact_lists_pkey PRIMARY KEY (id);


--
-- Name: contact_networks contact_networks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_networks
    ADD CONSTRAINT contact_networks_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: federal_subjects federal_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.federal_subjects
    ADD CONSTRAINT federal_subjects_pkey PRIMARY KEY (id);


--
-- Name: passports passports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passports
    ADD CONSTRAINT passports_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: person_comments person_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_comments
    ADD CONSTRAINT person_comments_pkey PRIMARY KEY (id);


--
-- Name: regional_offices regional_offices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_offices
    ADD CONSTRAINT regional_offices_pkey PRIMARY KEY (id);


--
-- Name: relationships relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relationships
    ADD CONSTRAINT relationships_pkey PRIMARY KEY (id);


--
-- Name: rsa_public_keys rsa_public_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rsa_public_keys
    ADD CONSTRAINT rsa_public_keys_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: user_omniauths user_omniauths_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_omniauths
    ADD CONSTRAINT user_omniauths_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: x509_certificate_requests x509_certificate_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x509_certificate_requests
    ADD CONSTRAINT x509_certificate_requests_pkey PRIMARY KEY (id);


--
-- Name: x509_certificates x509_certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x509_certificates
    ADD CONSTRAINT x509_certificates_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_contact_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_contact_list_id ON public.accounts USING btree (contact_list_id);


--
-- Name: index_accounts_on_nickname; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_nickname ON public.accounts USING btree (nickname);


--
-- Name: index_accounts_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_person_id ON public.accounts USING btree (person_id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_contact_networks_on_codename; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_contact_networks_on_codename ON public.contact_networks USING btree (codename);


--
-- Name: index_contact_networks_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_contact_networks_on_name ON public.contact_networks USING btree (name);


--
-- Name: index_contacts_on_contact_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_contact_list_id ON public.contacts USING btree (contact_list_id);


--
-- Name: index_contacts_on_contact_network_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_contact_network_id ON public.contacts USING btree (contact_network_id);


--
-- Name: index_contacts_on_list_id_and_network_id_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_contacts_on_list_id_and_network_id_and_value ON public.contacts USING btree (contact_list_id, contact_network_id, value);


--
-- Name: index_contacts_on_send_security_notifications; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_send_security_notifications ON public.contacts USING btree (send_security_notifications);


--
-- Name: index_federal_subjects_on_english_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_federal_subjects_on_english_name ON public.federal_subjects USING btree (english_name);


--
-- Name: index_federal_subjects_on_native_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_federal_subjects_on_native_name ON public.federal_subjects USING btree (native_name);


--
-- Name: index_federal_subjects_on_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_federal_subjects_on_number ON public.federal_subjects USING btree (number);


--
-- Name: index_passports_on_federal_subject_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_passports_on_federal_subject_id ON public.passports USING btree (federal_subject_id);


--
-- Name: index_passports_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_passports_on_person_id ON public.passports USING btree (person_id);


--
-- Name: index_people_on_contact_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_contact_list_id ON public.people USING btree (contact_list_id);


--
-- Name: index_person_comments_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_comments_on_account_id ON public.person_comments USING btree (account_id);


--
-- Name: index_person_comments_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_comments_on_person_id ON public.person_comments USING btree (person_id);


--
-- Name: index_regional_offices_on_federal_subject_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_regional_offices_on_federal_subject_id ON public.regional_offices USING btree (federal_subject_id);


--
-- Name: index_regional_offices_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_regional_offices_on_name ON public.regional_offices USING btree (name);


--
-- Name: index_relationships_on_federal_secretary_flag; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_relationships_on_federal_secretary_flag ON public.relationships USING btree (federal_secretary_flag);


--
-- Name: index_relationships_on_from_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relationships_on_from_date ON public.relationships USING btree (from_date);


--
-- Name: index_relationships_on_initiator_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relationships_on_initiator_account_id ON public.relationships USING btree (initiator_account_id);


--
-- Name: index_relationships_on_person_id_and_from_date; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_relationships_on_person_id_and_from_date ON public.relationships USING btree (person_id, from_date);


--
-- Name: index_relationships_on_regional_office_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relationships_on_regional_office_id ON public.relationships USING btree (regional_office_id);


--
-- Name: index_relationships_on_regional_office_id_and_secretary_flag; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_relationships_on_regional_office_id_and_secretary_flag ON public.relationships USING btree (regional_office_id, regional_secretary_flag);


--
-- Name: index_relationships_on_regional_secretary_flag; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relationships_on_regional_secretary_flag ON public.relationships USING btree (regional_secretary_flag);


--
-- Name: index_relationships_on_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relationships_on_role ON public.relationships USING btree (role);


--
-- Name: index_relationships_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relationships_on_status ON public.relationships USING btree (status);


--
-- Name: index_rsa_public_keys_on_public_key_pem; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_rsa_public_keys_on_public_key_pem ON public.rsa_public_keys USING btree (public_key_pem);


--
-- Name: index_rsa_public_keys_on_sha1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_rsa_public_keys_on_sha1 ON public.rsa_public_keys USING btree (sha1);


--
-- Name: index_rsa_public_keys_on_sha256; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_rsa_public_keys_on_sha256 ON public.rsa_public_keys USING btree (sha256);


--
-- Name: index_sessions_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_account_id ON public.sessions USING btree (account_id);


--
-- Name: index_user_omniauths_on_remote_id_and_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_omniauths_on_remote_id_and_provider ON public.user_omniauths USING btree (remote_id, provider);


--
-- Name: index_user_omniauths_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_omniauths_on_user_id ON public.user_omniauths USING btree (user_id);


--
-- Name: index_users_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_account_id ON public.users USING btree (account_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: index_x509_certificate_requests_on_rsa_public_key_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_x509_certificate_requests_on_rsa_public_key_id ON public.x509_certificate_requests USING btree (rsa_public_key_id);


--
-- Name: index_x509_certificates_on_rsa_public_key_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_x509_certificates_on_rsa_public_key_id ON public.x509_certificates USING btree (rsa_public_key_id);


--
-- Name: index_x509_certificates_on_x509_certificate_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_x509_certificates_on_x509_certificate_request_id ON public.x509_certificates USING btree (x509_certificate_request_id);


--
-- Name: accounts ensure_contact_list_id_matches_related_person; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ensure_contact_list_id_matches_related_person BEFORE INSERT OR UPDATE OF person_id, contact_list_id ON public.accounts FOR EACH ROW EXECUTE PROCEDURE public.ensure_contact_list_id_matches_related_person();


--
-- Name: people ensure_contact_list_id_remains_unchanged; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ensure_contact_list_id_remains_unchanged BEFORE UPDATE OF contact_list_id ON public.people FOR EACH ROW EXECUTE PROCEDURE public.ensure_contact_list_id_remains_unchanged();


--
-- Name: accounts ensure_superuser_has_related_user; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ensure_superuser_has_related_user BEFORE INSERT OR UPDATE ON public.accounts FOR EACH ROW EXECUTE PROCEDURE public.ensure_superuser_has_related_user();


--
-- Name: relationships fk_rails_100235139c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relationships
    ADD CONSTRAINT fk_rails_100235139c FOREIGN KEY (regional_office_id) REFERENCES public.regional_offices(id);


--
-- Name: relationships fk_rails_124c042ac0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relationships
    ADD CONSTRAINT fk_rails_124c042ac0 FOREIGN KEY (initiator_account_id) REFERENCES public.accounts(id);


--
-- Name: x509_certificates fk_rails_4958020bc7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x509_certificates
    ADD CONSTRAINT fk_rails_4958020bc7 FOREIGN KEY (x509_certificate_request_id) REFERENCES public.x509_certificate_requests(id);


--
-- Name: people fk_rails_4f02f930eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT fk_rails_4f02f930eb FOREIGN KEY (contact_list_id) REFERENCES public.contact_lists(id);


--
-- Name: sessions fk_rails_5599381559; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT fk_rails_5599381559 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: passports fk_rails_5cdfa39dea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passports
    ADD CONSTRAINT fk_rails_5cdfa39dea FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: users fk_rails_61ac11da2b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_61ac11da2b FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: accounts fk_rails_777d10a224; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_rails_777d10a224 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: accounts fk_rails_77a360a20e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_rails_77a360a20e FOREIGN KEY (contact_list_id) REFERENCES public.contact_lists(id);


--
-- Name: regional_offices fk_rails_7a6d5fdd9a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_offices
    ADD CONSTRAINT fk_rails_7a6d5fdd9a FOREIGN KEY (federal_subject_id) REFERENCES public.federal_subjects(id);


--
-- Name: user_omniauths fk_rails_8c1c9cb22e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_omniauths
    ADD CONSTRAINT fk_rails_8c1c9cb22e FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: contacts fk_rails_8dffd7a589; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT fk_rails_8dffd7a589 FOREIGN KEY (contact_network_id) REFERENCES public.contact_networks(id);


--
-- Name: person_comments fk_rails_a9c7b4ae11; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_comments
    ADD CONSTRAINT fk_rails_a9c7b4ae11 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: passports fk_rails_cd632a506c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passports
    ADD CONSTRAINT fk_rails_cd632a506c FOREIGN KEY (federal_subject_id) REFERENCES public.federal_subjects(id);


--
-- Name: person_comments fk_rails_d3ef7dc526; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_comments
    ADD CONSTRAINT fk_rails_d3ef7dc526 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: relationships fk_rails_d60748ff4c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relationships
    ADD CONSTRAINT fk_rails_d60748ff4c FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: x509_certificates fk_rails_d6153a2956; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x509_certificates
    ADD CONSTRAINT fk_rails_d6153a2956 FOREIGN KEY (rsa_public_key_id) REFERENCES public.rsa_public_keys(id);


--
-- Name: contacts fk_rails_dd2a5400cf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT fk_rails_dd2a5400cf FOREIGN KEY (contact_list_id) REFERENCES public.contact_lists(id);


--
-- Name: x509_certificate_requests fk_rails_f0002b108f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x509_certificate_requests
    ADD CONSTRAINT fk_rails_f0002b108f FOREIGN KEY (rsa_public_key_id) REFERENCES public.rsa_public_keys(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20181129203927'),
('20181130024918'),
('20190910040709'),
('20190911081459');


