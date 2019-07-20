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


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_roles (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    role_id bigint NOT NULL,
    deleted_at timestamp without time zone,
    expires_at timestamp without time zone
);


--
-- Name: account_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_roles_id_seq OWNED BY public.account_roles.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    guest_token character varying NOT NULL,
    person_id bigint,
    nickname character varying NOT NULL,
    biography text,
    public_name character varying,
    contacts_list_id bigint NOT NULL,
    CONSTRAINT biography CHECK (((biography IS NULL) OR (((length(biography) >= 3) AND (length(biography) <= 10000)) AND (biography !~ '^[[:space:]]*$'::text)))),
    CONSTRAINT guest_token CHECK (((guest_token)::text ~ '^[0-9a-f]{32}$'::text)),
    CONSTRAINT nickname CHECK ((((length((nickname)::text) >= 3) AND (length((nickname)::text) <= 36)) AND ((nickname)::text ~ '^[a-z][a-z0-9]*(_[a-z0-9]+)*$'::text))),
    CONSTRAINT public_name CHECK (((public_name IS NULL) OR (((length((public_name)::text) >= 3) AND (length((public_name)::text) <= 255)) AND ((public_name)::text !~ '^[[:space:]]*$'::text))))
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
-- Name: contacts_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts_lists (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: contacts_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contacts_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contacts_lists_id_seq OWNED BY public.contacts_lists.id;


--
-- Name: federal_subjects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.federal_subjects (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    english_name character varying NOT NULL,
    native_name character varying NOT NULL,
    number integer NOT NULL,
    timezone interval NOT NULL
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
    sex integer NOT NULL,
    date_of_birth date NOT NULL,
    place_of_birth character varying NOT NULL,
    series integer NOT NULL,
    number integer NOT NULL,
    issued_by text NOT NULL,
    unit_code character varying NOT NULL,
    date_of_issue date NOT NULL,
    person_id bigint
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    regional_office_id bigint,
    first_name character varying NOT NULL,
    middle_name character varying,
    last_name character varying NOT NULL,
    sex integer NOT NULL,
    date_of_birth date NOT NULL,
    place_of_birth character varying NOT NULL,
    contacts_list_id bigint NOT NULL
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
    text text NOT NULL
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    federal_subject_id bigint NOT NULL
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
    number integer NOT NULL,
    active_since date NOT NULL,
    status integer NOT NULL
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
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying NOT NULL,
    resource_type character varying,
    resource_id bigint
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: user_omniauths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_omniauths (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
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
-- Name: account_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_roles ALTER COLUMN id SET DEFAULT nextval('public.account_roles_id_seq'::regclass);


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
-- Name: contacts_lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts_lists ALTER COLUMN id SET DEFAULT nextval('public.contacts_lists_id_seq'::regclass);


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
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: user_omniauths id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_omniauths ALTER COLUMN id SET DEFAULT nextval('public.user_omniauths_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: account_roles account_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_roles
    ADD CONSTRAINT account_roles_pkey PRIMARY KEY (id);


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
-- Name: contacts_lists contacts_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts_lists
    ADD CONSTRAINT contacts_lists_pkey PRIMARY KEY (id);


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
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


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
-- Name: index_account_roles_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_roles_on_account_id ON public.account_roles USING btree (account_id);


--
-- Name: index_account_roles_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_roles_on_role_id ON public.account_roles USING btree (role_id);


--
-- Name: index_accounts_on_contacts_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_contacts_list_id ON public.accounts USING btree (contacts_list_id);


--
-- Name: index_accounts_on_guest_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_guest_token ON public.accounts USING btree (guest_token);


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
-- Name: index_passports_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_passports_on_person_id ON public.passports USING btree (person_id);


--
-- Name: index_people_on_contacts_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_contacts_list_id ON public.people USING btree (contacts_list_id);


--
-- Name: index_people_on_regional_office_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_regional_office_id ON public.people USING btree (regional_office_id);


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
-- Name: index_relationships_on_active_since; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relationships_on_active_since ON public.relationships USING btree (active_since);


--
-- Name: index_relationships_on_person_id_and_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_relationships_on_person_id_and_number ON public.relationships USING btree (person_id, number);


--
-- Name: index_relationships_on_regional_office_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relationships_on_regional_office_id ON public.relationships USING btree (regional_office_id);


--
-- Name: index_relationships_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relationships_on_status ON public.relationships USING btree (status);


--
-- Name: index_roles_on_name_and_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_roles_on_name_and_resource_type_and_resource_id ON public.roles USING btree (name, resource_type, resource_id);


--
-- Name: index_roles_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_resource_type_and_resource_id ON public.roles USING btree (resource_type, resource_id);


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
-- Name: accounts fk_rails_0fa1840045; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_rails_0fa1840045 FOREIGN KEY (contacts_list_id) REFERENCES public.contacts_lists(id);


--
-- Name: relationships fk_rails_100235139c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relationships
    ADD CONSTRAINT fk_rails_100235139c FOREIGN KEY (regional_office_id) REFERENCES public.regional_offices(id);


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
-- Name: user_omniauths fk_rails_8c1c9cb22e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_omniauths
    ADD CONSTRAINT fk_rails_8c1c9cb22e FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: account_roles fk_rails_a85be4ccfd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_roles
    ADD CONSTRAINT fk_rails_a85be4ccfd FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: person_comments fk_rails_a9c7b4ae11; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_comments
    ADD CONSTRAINT fk_rails_a9c7b4ae11 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: regional_offices fk_rails_ba9a6303c5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_offices
    ADD CONSTRAINT fk_rails_ba9a6303c5 FOREIGN KEY (federal_subject_id) REFERENCES public.federal_subjects(id);


--
-- Name: people fk_rails_cb9b5a21ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT fk_rails_cb9b5a21ec FOREIGN KEY (contacts_list_id) REFERENCES public.contacts_lists(id);


--
-- Name: people fk_rails_cc7540413a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT fk_rails_cc7540413a FOREIGN KEY (regional_office_id) REFERENCES public.regional_offices(id);


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
-- Name: account_roles fk_rails_f48937287f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_roles
    ADD CONSTRAINT fk_rails_f48937287f FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20181129203927'),
('20181130024918'),
('20181215040559'),
('20181215053720'),
('20190129013754'),
('20190129015721'),
('20190201002444'),
('20190201012021'),
('20190201035804'),
('20190201214347'),
('20190202041009'),
('20190208062215'),
('20190324192022'),
('20190324204513'),
('20190324210722'),
('20190324211036'),
('20190326004506'),
('20190326200244'),
('20190427141639'),
('20190605011616'),
('20190605012813'),
('20190605022109'),
('20190605041924'),
('20190623160009'),
('20190623160130'),
('20190627000456'),
('20190708130309'),
('20190715210610'),
('20190718184543'),
('20190719224405'),
('20190720022446'),
('20190720042127');


