--
-- PostgreSQL database dump
--

-- Dumped from database version 14.8 (Debian 14.8-1.pgdg110+1)
-- Dumped by pg_dump version 14.8 (Debian 14.8-1.pgdg110+1)

-- Started on 2023-05-12 22:49:46 UTC

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
-- TOC entry 4207 (class 1262 OID 16384)
-- Name: keycloak; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE keycloak WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


\connect keycloak

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
-- TOC entry 250 (class 1259 OID 17017)
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


--
-- TOC entry 279 (class 1259 OID 17460)
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


--
-- TOC entry 253 (class 1259 OID 17032)
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


--
-- TOC entry 252 (class 1259 OID 17027)
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


--
-- TOC entry 251 (class 1259 OID 17022)
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


--
-- TOC entry 254 (class 1259 OID 17037)
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


--
-- TOC entry 280 (class 1259 OID 17475)
-- Name: broker_link; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


--
-- TOC entry 211 (class 1259 OID 16398)
-- Name: client; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


--
-- TOC entry 234 (class 1259 OID 16756)
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


--
-- TOC entry 291 (class 1259 OID 17724)
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


--
-- TOC entry 290 (class 1259 OID 17599)
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


--
-- TOC entry 236 (class 1259 OID 16766)
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


--
-- TOC entry 268 (class 1259 OID 17265)
-- Name: client_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


--
-- TOC entry 269 (class 1259 OID 17279)
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


--
-- TOC entry 292 (class 1259 OID 17765)
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


--
-- TOC entry 270 (class 1259 OID 17284)
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


--
-- TOC entry 212 (class 1259 OID 16409)
-- Name: client_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


--
-- TOC entry 257 (class 1259 OID 17055)
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


--
-- TOC entry 235 (class 1259 OID 16761)
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


--
-- TOC entry 249 (class 1259 OID 16939)
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


--
-- TOC entry 213 (class 1259 OID 16414)
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


--
-- TOC entry 258 (class 1259 OID 17136)
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


--
-- TOC entry 288 (class 1259 OID 17520)
-- Name: component; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


--
-- TOC entry 287 (class 1259 OID 17515)
-- Name: component_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(4000)
);


--
-- TOC entry 214 (class 1259 OID 16417)
-- Name: composite_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


--
-- TOC entry 215 (class 1259 OID 16420)
-- Name: credential; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


--
-- TOC entry 210 (class 1259 OID 16390)
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


--
-- TOC entry 209 (class 1259 OID 16385)
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


--
-- TOC entry 293 (class 1259 OID 17781)
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


--
-- TOC entry 216 (class 1259 OID 16425)
-- Name: event_entity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255)
);


--
-- TOC entry 281 (class 1259 OID 17480)
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


--
-- TOC entry 282 (class 1259 OID 17485)
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


--
-- TOC entry 295 (class 1259 OID 17807)
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


--
-- TOC entry 283 (class 1259 OID 17494)
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


--
-- TOC entry 284 (class 1259 OID 17503)
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


--
-- TOC entry 285 (class 1259 OID 17506)
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


--
-- TOC entry 286 (class 1259 OID 17512)
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


--
-- TOC entry 239 (class 1259 OID 16802)
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


--
-- TOC entry 289 (class 1259 OID 17577)
-- Name: federated_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


--
-- TOC entry 265 (class 1259 OID 17204)
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


--
-- TOC entry 264 (class 1259 OID 17201)
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


--
-- TOC entry 240 (class 1259 OID 16807)
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


--
-- TOC entry 241 (class 1259 OID 16816)
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


--
-- TOC entry 246 (class 1259 OID 16920)
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


--
-- TOC entry 247 (class 1259 OID 16925)
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


--
-- TOC entry 263 (class 1259 OID 17198)
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


--
-- TOC entry 217 (class 1259 OID 16433)
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


--
-- TOC entry 245 (class 1259 OID 16917)
-- Name: migration_model; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


--
-- TOC entry 262 (class 1259 OID 17189)
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


--
-- TOC entry 261 (class 1259 OID 17184)
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 275 (class 1259 OID 17403)
-- Name: policy_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


--
-- TOC entry 237 (class 1259 OID 16791)
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


--
-- TOC entry 238 (class 1259 OID 16797)
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 16439)
-- Name: realm; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


--
-- TOC entry 219 (class 1259 OID 16456)
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


--
-- TOC entry 267 (class 1259 OID 17213)
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


--
-- TOC entry 244 (class 1259 OID 16909)
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 16464)
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- TOC entry 300 (class 1259 OID 17915)
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16467)
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


--
-- TOC entry 222 (class 1259 OID 16474)
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


--
-- TOC entry 242 (class 1259 OID 16825)
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 16484)
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- TOC entry 260 (class 1259 OID 17148)
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


--
-- TOC entry 259 (class 1259 OID 17141)
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


--
-- TOC entry 297 (class 1259 OID 17846)
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


--
-- TOC entry 277 (class 1259 OID 17430)
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


--
-- TOC entry 276 (class 1259 OID 17415)
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


--
-- TOC entry 271 (class 1259 OID 17353)
-- Name: resource_server; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


--
-- TOC entry 296 (class 1259 OID 17822)
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


--
-- TOC entry 274 (class 1259 OID 17389)
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


--
-- TOC entry 272 (class 1259 OID 17361)
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


--
-- TOC entry 273 (class 1259 OID 17375)
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


--
-- TOC entry 298 (class 1259 OID 17864)
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- TOC entry 299 (class 1259 OID 17874)
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


--
-- TOC entry 224 (class 1259 OID 16487)
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


--
-- TOC entry 278 (class 1259 OID 17445)
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 16493)
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


--
-- TOC entry 248 (class 1259 OID 16930)
-- Name: user_consent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


--
-- TOC entry 294 (class 1259 OID 17797)
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


--
-- TOC entry 227 (class 1259 OID 16498)
-- Name: user_entity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 228 (class 1259 OID 16506)
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


--
-- TOC entry 255 (class 1259 OID 17042)
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


--
-- TOC entry 256 (class 1259 OID 17047)
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 16511)
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


--
-- TOC entry 266 (class 1259 OID 17210)
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


--
-- TOC entry 230 (class 1259 OID 16516)
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 16519)
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


--
-- TOC entry 232 (class 1259 OID 16522)
-- Name: user_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


--
-- TOC entry 243 (class 1259 OID 16828)
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


--
-- TOC entry 225 (class 1259 OID 16490)
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


--
-- TOC entry 233 (class 1259 OID 16533)
-- Name: web_origins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- TOC entry 4151 (class 0 OID 17017)
-- Dependencies: 250
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- TOC entry 4180 (class 0 OID 17460)
-- Dependencies: 279
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- TOC entry 4154 (class 0 OID 17032)
-- Dependencies: 253
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
6019d13d-2b6c-48f6-9ce9-d4487ed4510a	\N	auth-cookie	d197e81d-3fcf-427b-b55c-debfeffaf415	f2c996ac-4621-4bee-8b4d-4a57d9d139ed	2	10	f	\N	\N
4b23063f-c3f7-4f62-bb1c-84c35a7888ef	\N	auth-spnego	d197e81d-3fcf-427b-b55c-debfeffaf415	f2c996ac-4621-4bee-8b4d-4a57d9d139ed	3	20	f	\N	\N
9a684ad8-8e23-4e0a-9275-84cb88a439ea	\N	identity-provider-redirector	d197e81d-3fcf-427b-b55c-debfeffaf415	f2c996ac-4621-4bee-8b4d-4a57d9d139ed	2	25	f	\N	\N
24ec9fde-a67a-4b24-bb21-8c1f365b3cfb	\N	\N	d197e81d-3fcf-427b-b55c-debfeffaf415	f2c996ac-4621-4bee-8b4d-4a57d9d139ed	2	30	t	ca6b5556-3dd2-4a4e-98c3-c3ea19d5b2a8	\N
5053a839-a6f9-4121-a3c5-037c5e65af85	\N	auth-username-password-form	d197e81d-3fcf-427b-b55c-debfeffaf415	ca6b5556-3dd2-4a4e-98c3-c3ea19d5b2a8	0	10	f	\N	\N
21a4811f-8983-4c44-a769-debcd9a6e770	\N	\N	d197e81d-3fcf-427b-b55c-debfeffaf415	ca6b5556-3dd2-4a4e-98c3-c3ea19d5b2a8	1	20	t	4be1282a-ee96-4355-b2c4-980a3f12449d	\N
49f3b289-0404-46e9-a64f-b497c3f296c9	\N	conditional-user-configured	d197e81d-3fcf-427b-b55c-debfeffaf415	4be1282a-ee96-4355-b2c4-980a3f12449d	0	10	f	\N	\N
e4f90a71-1c26-4c6f-a641-26cfd82bb2b9	\N	auth-otp-form	d197e81d-3fcf-427b-b55c-debfeffaf415	4be1282a-ee96-4355-b2c4-980a3f12449d	0	20	f	\N	\N
88f6516f-dd7f-468e-89f5-7a0410060347	\N	direct-grant-validate-username	d197e81d-3fcf-427b-b55c-debfeffaf415	ae18b243-ee16-4c41-bbdb-6b2a5ae8a3f7	0	10	f	\N	\N
3e67c9e8-3aa2-4382-ab40-ee8879c2e891	\N	direct-grant-validate-password	d197e81d-3fcf-427b-b55c-debfeffaf415	ae18b243-ee16-4c41-bbdb-6b2a5ae8a3f7	0	20	f	\N	\N
dd072e2b-a906-43f7-b6a5-bc6088b7c9ce	\N	\N	d197e81d-3fcf-427b-b55c-debfeffaf415	ae18b243-ee16-4c41-bbdb-6b2a5ae8a3f7	1	30	t	89aefb2b-c25f-43be-aa83-de446d7ed962	\N
262aa5d4-c2b0-45c5-b156-48c70c2cc7f2	\N	conditional-user-configured	d197e81d-3fcf-427b-b55c-debfeffaf415	89aefb2b-c25f-43be-aa83-de446d7ed962	0	10	f	\N	\N
1e0adb23-68ee-4c7e-924a-c9d99bce7f47	\N	direct-grant-validate-otp	d197e81d-3fcf-427b-b55c-debfeffaf415	89aefb2b-c25f-43be-aa83-de446d7ed962	0	20	f	\N	\N
cfa77235-7fc1-41af-b209-07e1727d4986	\N	registration-page-form	d197e81d-3fcf-427b-b55c-debfeffaf415	75e16c01-b714-404a-a6ec-b1cc91c4caa5	0	10	t	e321655c-8ced-4250-9cce-fe9ef859127b	\N
7c4affd0-aae5-485c-8785-6120cd5fa01c	\N	registration-user-creation	d197e81d-3fcf-427b-b55c-debfeffaf415	e321655c-8ced-4250-9cce-fe9ef859127b	0	20	f	\N	\N
e55655aa-a75a-440f-b6ef-7b45769cc44f	\N	registration-profile-action	d197e81d-3fcf-427b-b55c-debfeffaf415	e321655c-8ced-4250-9cce-fe9ef859127b	0	40	f	\N	\N
0ce7b285-6928-436f-9542-27cf57ab26a7	\N	registration-password-action	d197e81d-3fcf-427b-b55c-debfeffaf415	e321655c-8ced-4250-9cce-fe9ef859127b	0	50	f	\N	\N
52e7b67a-db11-4135-8f40-96f8d392f3c1	\N	registration-recaptcha-action	d197e81d-3fcf-427b-b55c-debfeffaf415	e321655c-8ced-4250-9cce-fe9ef859127b	3	60	f	\N	\N
e7ef092e-3699-41ca-9cce-eab3bbdc7afa	\N	reset-credentials-choose-user	d197e81d-3fcf-427b-b55c-debfeffaf415	c3bc14ba-631e-4730-a3de-5914bb6aba7b	0	10	f	\N	\N
47565d9b-ee01-4591-a486-8de15ed462ab	\N	reset-credential-email	d197e81d-3fcf-427b-b55c-debfeffaf415	c3bc14ba-631e-4730-a3de-5914bb6aba7b	0	20	f	\N	\N
d57fe739-c1f6-4901-9f52-385cc4f4691c	\N	reset-password	d197e81d-3fcf-427b-b55c-debfeffaf415	c3bc14ba-631e-4730-a3de-5914bb6aba7b	0	30	f	\N	\N
ff91056a-3628-434a-8537-8d787437db59	\N	\N	d197e81d-3fcf-427b-b55c-debfeffaf415	c3bc14ba-631e-4730-a3de-5914bb6aba7b	1	40	t	3ac6e07d-2ef7-4e64-b58a-d0e9b94961da	\N
4b4abe24-e7bb-495f-a73b-a300487559e2	\N	conditional-user-configured	d197e81d-3fcf-427b-b55c-debfeffaf415	3ac6e07d-2ef7-4e64-b58a-d0e9b94961da	0	10	f	\N	\N
ed567c4b-6de6-4d72-b58e-7b314b155b2b	\N	reset-otp	d197e81d-3fcf-427b-b55c-debfeffaf415	3ac6e07d-2ef7-4e64-b58a-d0e9b94961da	0	20	f	\N	\N
83c2ee2f-952a-4b17-b530-c6c1a5d51bab	\N	client-secret	d197e81d-3fcf-427b-b55c-debfeffaf415	ea4bf0df-61e2-4abf-8073-baffe6c2608e	2	10	f	\N	\N
519c36ca-4f57-4344-8fd9-79c6b9fe88be	\N	client-jwt	d197e81d-3fcf-427b-b55c-debfeffaf415	ea4bf0df-61e2-4abf-8073-baffe6c2608e	2	20	f	\N	\N
46851de3-f017-4a0e-b1b8-fab3c25d60eb	\N	client-secret-jwt	d197e81d-3fcf-427b-b55c-debfeffaf415	ea4bf0df-61e2-4abf-8073-baffe6c2608e	2	30	f	\N	\N
5dbb458d-9ac7-4761-a103-40c2533e3f10	\N	client-x509	d197e81d-3fcf-427b-b55c-debfeffaf415	ea4bf0df-61e2-4abf-8073-baffe6c2608e	2	40	f	\N	\N
af3cfde6-1796-49f6-81b4-e44d192d8eaf	\N	idp-review-profile	d197e81d-3fcf-427b-b55c-debfeffaf415	378ea165-bd98-45d5-965c-8219479ab50a	0	10	f	\N	1361d8d4-732c-4ff0-8b42-af6ee9536d46
a3f146b8-c000-4c41-965a-2b397b4c8f8e	\N	\N	d197e81d-3fcf-427b-b55c-debfeffaf415	378ea165-bd98-45d5-965c-8219479ab50a	0	20	t	de294a62-203a-463f-a188-33a92b0d8de7	\N
30f94d11-f3dc-4709-9e73-a5c1cb86d041	\N	idp-create-user-if-unique	d197e81d-3fcf-427b-b55c-debfeffaf415	de294a62-203a-463f-a188-33a92b0d8de7	2	10	f	\N	1bc3fcc1-6e4f-4aaa-92d3-1e087c6ec1fd
b999277d-696c-4074-aa8d-60d2f4037633	\N	\N	d197e81d-3fcf-427b-b55c-debfeffaf415	de294a62-203a-463f-a188-33a92b0d8de7	2	20	t	c761b54a-993f-4a0f-84b2-df617e9329ee	\N
58215680-7008-42d7-abbb-34bf02173505	\N	idp-confirm-link	d197e81d-3fcf-427b-b55c-debfeffaf415	c761b54a-993f-4a0f-84b2-df617e9329ee	0	10	f	\N	\N
4c9072fe-4be3-457b-8cc3-6ef9ebd6225f	\N	\N	d197e81d-3fcf-427b-b55c-debfeffaf415	c761b54a-993f-4a0f-84b2-df617e9329ee	0	20	t	4ce337bb-765e-463b-bcff-bcd5fd077967	\N
71e06812-3f6d-478e-98d2-8733f3b3d90d	\N	idp-email-verification	d197e81d-3fcf-427b-b55c-debfeffaf415	4ce337bb-765e-463b-bcff-bcd5fd077967	2	10	f	\N	\N
99f4415a-62e2-4549-b555-70b1c0025236	\N	\N	d197e81d-3fcf-427b-b55c-debfeffaf415	4ce337bb-765e-463b-bcff-bcd5fd077967	2	20	t	1617a9e0-1fda-416a-938a-c774c2ff7955	\N
61828e25-835b-4198-956b-e6b198cf45b1	\N	idp-username-password-form	d197e81d-3fcf-427b-b55c-debfeffaf415	1617a9e0-1fda-416a-938a-c774c2ff7955	0	10	f	\N	\N
46d75185-91b3-4c2b-904a-d9cc33ab26b8	\N	\N	d197e81d-3fcf-427b-b55c-debfeffaf415	1617a9e0-1fda-416a-938a-c774c2ff7955	1	20	t	7bdb8131-bac3-42ed-bd89-67c0e678e7e4	\N
c0a96f13-2a4e-4867-821a-0a7d21c86bfb	\N	conditional-user-configured	d197e81d-3fcf-427b-b55c-debfeffaf415	7bdb8131-bac3-42ed-bd89-67c0e678e7e4	0	10	f	\N	\N
03d34231-1d98-4bc3-adfe-2c83ba735d3b	\N	auth-otp-form	d197e81d-3fcf-427b-b55c-debfeffaf415	7bdb8131-bac3-42ed-bd89-67c0e678e7e4	0	20	f	\N	\N
5605a6af-4636-4b71-9136-d6f4f491babf	\N	http-basic-authenticator	d197e81d-3fcf-427b-b55c-debfeffaf415	d5e37635-dce2-4305-a0bf-f61cd55d8490	0	10	f	\N	\N
23774ed4-2e24-4b75-ac91-242bb82fe598	\N	docker-http-basic-authenticator	d197e81d-3fcf-427b-b55c-debfeffaf415	501b7b6a-0167-4b1f-a663-80eff02449cd	0	10	f	\N	\N
a0ffc5da-79ad-4a16-a79f-0320e811a3e0	\N	no-cookie-redirect	d197e81d-3fcf-427b-b55c-debfeffaf415	f43dd568-099a-44f9-aa6d-fb3720705368	0	10	f	\N	\N
1f5e17d1-1a20-4b95-b543-ce3e64abc311	\N	\N	d197e81d-3fcf-427b-b55c-debfeffaf415	f43dd568-099a-44f9-aa6d-fb3720705368	0	20	t	21230a07-8403-4b2a-87b7-4447ead2b740	\N
ae65b455-fdd7-48a9-918a-e3849d54e637	\N	basic-auth	d197e81d-3fcf-427b-b55c-debfeffaf415	21230a07-8403-4b2a-87b7-4447ead2b740	0	10	f	\N	\N
a11aadc4-2e77-4b24-9fa9-cb6a2b446310	\N	basic-auth-otp	d197e81d-3fcf-427b-b55c-debfeffaf415	21230a07-8403-4b2a-87b7-4447ead2b740	3	20	f	\N	\N
7b6d635f-61f0-4629-bfe9-d82434485694	\N	auth-spnego	d197e81d-3fcf-427b-b55c-debfeffaf415	21230a07-8403-4b2a-87b7-4447ead2b740	3	30	f	\N	\N
dada6944-73e2-40a7-9171-143e74d75bf9	\N	auth-cookie	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	68dba959-2ce8-488c-a463-fc0605d3baa4	2	10	f	\N	\N
78f46622-ff8f-4a86-a029-43f111cc1e58	\N	auth-spnego	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	68dba959-2ce8-488c-a463-fc0605d3baa4	3	20	f	\N	\N
d1cb1453-a7a1-45f0-8bb2-130ce6e5dd9e	\N	identity-provider-redirector	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	68dba959-2ce8-488c-a463-fc0605d3baa4	2	25	f	\N	\N
1ed3ee63-db75-4fba-a30b-c0814404484c	\N	\N	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	68dba959-2ce8-488c-a463-fc0605d3baa4	2	30	t	d6dea077-1843-42e2-8bd2-6c3422f534b3	\N
169d2e54-8319-4ada-a18f-d7441c465f1f	\N	auth-username-password-form	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	d6dea077-1843-42e2-8bd2-6c3422f534b3	0	10	f	\N	\N
360ee72c-154e-4f43-b012-130d0f82978b	\N	\N	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	d6dea077-1843-42e2-8bd2-6c3422f534b3	1	20	t	7428fa3f-88e5-4858-9ad9-d1c3fe8577c5	\N
5b23ee9f-4341-4dbd-97dc-597f05e129ae	\N	conditional-user-configured	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	7428fa3f-88e5-4858-9ad9-d1c3fe8577c5	0	10	f	\N	\N
68f24801-df3e-4004-904a-942abf8deccf	\N	auth-otp-form	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	7428fa3f-88e5-4858-9ad9-d1c3fe8577c5	0	20	f	\N	\N
bd95dded-7554-4958-9aa0-7318f9d17e9e	\N	direct-grant-validate-username	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	850ff647-577c-45f2-9be0-095046de8149	0	10	f	\N	\N
c8911c54-45ff-450f-acca-fbb930030b48	\N	direct-grant-validate-password	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	850ff647-577c-45f2-9be0-095046de8149	0	20	f	\N	\N
f681e06d-7fd3-46ec-bbbb-7d597703f898	\N	\N	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	850ff647-577c-45f2-9be0-095046de8149	1	30	t	e04691e2-8b40-4ef9-a23a-66d93a053023	\N
d787f78b-7531-4f7d-a4ee-4dc0cfcd3bf2	\N	conditional-user-configured	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	e04691e2-8b40-4ef9-a23a-66d93a053023	0	10	f	\N	\N
983fb851-2f26-4b81-a2b7-648c7ede3e6a	\N	direct-grant-validate-otp	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	e04691e2-8b40-4ef9-a23a-66d93a053023	0	20	f	\N	\N
71e8c37d-aaed-4220-b802-20841eed1545	\N	registration-page-form	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	6b52511e-e5dd-429a-b1d7-5370a8cb325d	0	10	t	0b5ee86b-0ea5-476f-bd39-875b15d69729	\N
9fe79bd1-7c42-4ebf-ace1-4ee5e9245457	\N	registration-user-creation	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	0b5ee86b-0ea5-476f-bd39-875b15d69729	0	20	f	\N	\N
c028ce73-19ff-4f5f-82ec-fc1579da605e	\N	registration-profile-action	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	0b5ee86b-0ea5-476f-bd39-875b15d69729	0	40	f	\N	\N
3670610c-b6c9-48fe-96f6-5ce6e194b4f9	\N	registration-password-action	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	0b5ee86b-0ea5-476f-bd39-875b15d69729	0	50	f	\N	\N
b8774c5a-035b-4b42-9c5e-525700e8af7b	\N	registration-recaptcha-action	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	0b5ee86b-0ea5-476f-bd39-875b15d69729	3	60	f	\N	\N
c855a7ff-f0d5-414a-a8dc-e289762044bf	\N	reset-credentials-choose-user	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	13a9128e-5761-4e78-aa3c-ec2f6ddd15d8	0	10	f	\N	\N
5a7bd2bf-1979-496a-afb7-8539159770ab	\N	reset-credential-email	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	13a9128e-5761-4e78-aa3c-ec2f6ddd15d8	0	20	f	\N	\N
f98eff2a-1870-4d6d-a83c-bb5da9dc8ed6	\N	reset-password	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	13a9128e-5761-4e78-aa3c-ec2f6ddd15d8	0	30	f	\N	\N
d2cdf180-aed3-4745-84dc-70e9a86c31d3	\N	\N	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	13a9128e-5761-4e78-aa3c-ec2f6ddd15d8	1	40	t	8df54222-d278-40df-82ad-6cb068395483	\N
26d7c31f-2c0e-40cd-8817-93afc3d74230	\N	conditional-user-configured	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	8df54222-d278-40df-82ad-6cb068395483	0	10	f	\N	\N
15a2d4f0-42cf-45f8-a84b-679c4bd68310	\N	reset-otp	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	8df54222-d278-40df-82ad-6cb068395483	0	20	f	\N	\N
e6fa3f6f-3604-41c7-8edb-24765724903b	\N	client-secret	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f69c4da4-5213-4907-aefa-1c72967df9ef	2	10	f	\N	\N
9593ff37-cb41-4e4c-8172-595371c11961	\N	client-jwt	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f69c4da4-5213-4907-aefa-1c72967df9ef	2	20	f	\N	\N
9f973b0d-9fa4-4515-b001-a95a8b65261a	\N	client-secret-jwt	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f69c4da4-5213-4907-aefa-1c72967df9ef	2	30	f	\N	\N
2ba7ca24-666c-4ce1-a568-5e0928d2924f	\N	client-x509	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f69c4da4-5213-4907-aefa-1c72967df9ef	2	40	f	\N	\N
ad023684-af82-410c-95e9-e98d38463589	\N	idp-review-profile	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	fcf2100c-db0b-4ab6-8323-a7d32527afcf	0	10	f	\N	528fe797-e28f-4032-95cb-b6c3e1d00b3e
8b7dec31-4d26-4859-a171-ebfbdcb912c0	\N	\N	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	fcf2100c-db0b-4ab6-8323-a7d32527afcf	0	20	t	2ce75924-c167-4d77-98bc-ad8ad40e3ab9	\N
c17b8f98-f9b4-4017-b259-2135f736004a	\N	idp-create-user-if-unique	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	2ce75924-c167-4d77-98bc-ad8ad40e3ab9	2	10	f	\N	5442a645-fd96-4868-8e22-4ceb5ba4128b
088feffd-1e99-43d4-8e0f-96cdb8ca0ec6	\N	\N	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	2ce75924-c167-4d77-98bc-ad8ad40e3ab9	2	20	t	13c4627d-e412-4251-9d29-3d9dd9527aff	\N
bae77c0e-edb3-412a-9fbf-f8c32f24a5a1	\N	idp-confirm-link	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	13c4627d-e412-4251-9d29-3d9dd9527aff	0	10	f	\N	\N
05203fa8-7a55-4ed2-b09e-b05da1d8d698	\N	\N	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	13c4627d-e412-4251-9d29-3d9dd9527aff	0	20	t	8ec178a9-3434-4da2-a73e-27eebc7b5965	\N
e3813056-5311-4565-afa9-403c6fa454d1	\N	idp-email-verification	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	8ec178a9-3434-4da2-a73e-27eebc7b5965	2	10	f	\N	\N
3664db6c-0782-4ddf-a32a-e4498264dc71	\N	\N	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	8ec178a9-3434-4da2-a73e-27eebc7b5965	2	20	t	231602cb-9580-4abb-af2f-9fcfaf44d254	\N
fd40ffbe-7b29-40dc-9c3a-bef3ae0d74bb	\N	idp-username-password-form	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	231602cb-9580-4abb-af2f-9fcfaf44d254	0	10	f	\N	\N
277aa69a-e79a-4fe8-86e0-91140cde48b7	\N	\N	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	231602cb-9580-4abb-af2f-9fcfaf44d254	1	20	t	dc720caa-8f7b-4641-b109-2f89ef07542e	\N
a2ab7f98-289b-48ba-90cf-243c636bc7cf	\N	conditional-user-configured	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	dc720caa-8f7b-4641-b109-2f89ef07542e	0	10	f	\N	\N
31278dbc-8ed9-4c48-98d3-72a1d6966ea6	\N	auth-otp-form	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	dc720caa-8f7b-4641-b109-2f89ef07542e	0	20	f	\N	\N
b828deef-2b45-4e8b-9387-70e185bd7017	\N	http-basic-authenticator	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f4728621-ea2f-45ab-bb51-2c4eecfdf3b8	0	10	f	\N	\N
a37b7021-95c7-47ae-8108-3542683a4181	\N	docker-http-basic-authenticator	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	70a343ac-0dcf-4ef5-a6a1-fb52c16c9b3b	0	10	f	\N	\N
e97f3c61-61e8-4c61-8ead-f262c39054cc	\N	no-cookie-redirect	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	ceb6d1f0-667b-4e94-be22-86d18a06b1e9	0	10	f	\N	\N
55dd476c-6037-4860-879a-8c2f6bade1f7	\N	\N	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	ceb6d1f0-667b-4e94-be22-86d18a06b1e9	0	20	t	cdaad91d-6443-4950-bcd6-a8f4e83b486c	\N
c0cabc20-a9cf-4522-baec-32650812f911	\N	basic-auth	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	cdaad91d-6443-4950-bcd6-a8f4e83b486c	0	10	f	\N	\N
7faa336d-b629-4f39-aa07-b3419c28a707	\N	basic-auth-otp	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	cdaad91d-6443-4950-bcd6-a8f4e83b486c	3	20	f	\N	\N
9fdcff2b-e496-445d-8855-13bb7448ea63	\N	auth-spnego	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	cdaad91d-6443-4950-bcd6-a8f4e83b486c	3	30	f	\N	\N
\.


--
-- TOC entry 4153 (class 0 OID 17027)
-- Dependencies: 252
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
f2c996ac-4621-4bee-8b4d-4a57d9d139ed	browser	browser based authentication	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	t	t
ca6b5556-3dd2-4a4e-98c3-c3ea19d5b2a8	forms	Username, password, otp and other auth forms.	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	f	t
4be1282a-ee96-4355-b2c4-980a3f12449d	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	f	t
ae18b243-ee16-4c41-bbdb-6b2a5ae8a3f7	direct grant	OpenID Connect Resource Owner Grant	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	t	t
89aefb2b-c25f-43be-aa83-de446d7ed962	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	f	t
75e16c01-b714-404a-a6ec-b1cc91c4caa5	registration	registration flow	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	t	t
e321655c-8ced-4250-9cce-fe9ef859127b	registration form	registration form	d197e81d-3fcf-427b-b55c-debfeffaf415	form-flow	f	t
c3bc14ba-631e-4730-a3de-5914bb6aba7b	reset credentials	Reset credentials for a user if they forgot their password or something	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	t	t
3ac6e07d-2ef7-4e64-b58a-d0e9b94961da	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	f	t
ea4bf0df-61e2-4abf-8073-baffe6c2608e	clients	Base authentication for clients	d197e81d-3fcf-427b-b55c-debfeffaf415	client-flow	t	t
378ea165-bd98-45d5-965c-8219479ab50a	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	t	t
de294a62-203a-463f-a188-33a92b0d8de7	User creation or linking	Flow for the existing/non-existing user alternatives	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	f	t
c761b54a-993f-4a0f-84b2-df617e9329ee	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	f	t
4ce337bb-765e-463b-bcff-bcd5fd077967	Account verification options	Method with which to verity the existing account	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	f	t
1617a9e0-1fda-416a-938a-c774c2ff7955	Verify Existing Account by Re-authentication	Reauthentication of existing account	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	f	t
7bdb8131-bac3-42ed-bd89-67c0e678e7e4	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	f	t
d5e37635-dce2-4305-a0bf-f61cd55d8490	saml ecp	SAML ECP Profile Authentication Flow	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	t	t
501b7b6a-0167-4b1f-a663-80eff02449cd	docker auth	Used by Docker clients to authenticate against the IDP	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	t	t
f43dd568-099a-44f9-aa6d-fb3720705368	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	t	t
21230a07-8403-4b2a-87b7-4447ead2b740	Authentication Options	Authentication options.	d197e81d-3fcf-427b-b55c-debfeffaf415	basic-flow	f	t
68dba959-2ce8-488c-a463-fc0605d3baa4	browser	browser based authentication	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	t	t
d6dea077-1843-42e2-8bd2-6c3422f534b3	forms	Username, password, otp and other auth forms.	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	f	t
7428fa3f-88e5-4858-9ad9-d1c3fe8577c5	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	f	t
850ff647-577c-45f2-9be0-095046de8149	direct grant	OpenID Connect Resource Owner Grant	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	t	t
e04691e2-8b40-4ef9-a23a-66d93a053023	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	f	t
6b52511e-e5dd-429a-b1d7-5370a8cb325d	registration	registration flow	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	t	t
0b5ee86b-0ea5-476f-bd39-875b15d69729	registration form	registration form	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	form-flow	f	t
13a9128e-5761-4e78-aa3c-ec2f6ddd15d8	reset credentials	Reset credentials for a user if they forgot their password or something	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	t	t
8df54222-d278-40df-82ad-6cb068395483	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	f	t
f69c4da4-5213-4907-aefa-1c72967df9ef	clients	Base authentication for clients	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	client-flow	t	t
fcf2100c-db0b-4ab6-8323-a7d32527afcf	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	t	t
2ce75924-c167-4d77-98bc-ad8ad40e3ab9	User creation or linking	Flow for the existing/non-existing user alternatives	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	f	t
13c4627d-e412-4251-9d29-3d9dd9527aff	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	f	t
8ec178a9-3434-4da2-a73e-27eebc7b5965	Account verification options	Method with which to verity the existing account	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	f	t
231602cb-9580-4abb-af2f-9fcfaf44d254	Verify Existing Account by Re-authentication	Reauthentication of existing account	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	f	t
dc720caa-8f7b-4641-b109-2f89ef07542e	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	f	t
f4728621-ea2f-45ab-bb51-2c4eecfdf3b8	saml ecp	SAML ECP Profile Authentication Flow	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	t	t
70a343ac-0dcf-4ef5-a6a1-fb52c16c9b3b	docker auth	Used by Docker clients to authenticate against the IDP	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	t	t
ceb6d1f0-667b-4e94-be22-86d18a06b1e9	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	t	t
cdaad91d-6443-4950-bcd6-a8f4e83b486c	Authentication Options	Authentication options.	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	basic-flow	f	t
\.


--
-- TOC entry 4152 (class 0 OID 17022)
-- Dependencies: 251
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
1361d8d4-732c-4ff0-8b42-af6ee9536d46	review profile config	d197e81d-3fcf-427b-b55c-debfeffaf415
1bc3fcc1-6e4f-4aaa-92d3-1e087c6ec1fd	create unique user config	d197e81d-3fcf-427b-b55c-debfeffaf415
528fe797-e28f-4032-95cb-b6c3e1d00b3e	review profile config	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb
5442a645-fd96-4868-8e22-4ceb5ba4128b	create unique user config	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb
\.


--
-- TOC entry 4155 (class 0 OID 17037)
-- Dependencies: 254
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
1361d8d4-732c-4ff0-8b42-af6ee9536d46	missing	update.profile.on.first.login
1bc3fcc1-6e4f-4aaa-92d3-1e087c6ec1fd	false	require.password.update.after.registration
528fe797-e28f-4032-95cb-b6c3e1d00b3e	missing	update.profile.on.first.login
5442a645-fd96-4868-8e22-4ceb5ba4128b	false	require.password.update.after.registration
\.


--
-- TOC entry 4181 (class 0 OID 17475)
-- Dependencies: 280
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- TOC entry 4112 (class 0 OID 16398)
-- Dependencies: 211
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
448c4db4-c6fa-45be-af4c-629ec0847ab9	t	f	master-realm	0	f	\N	\N	t	\N	f	d197e81d-3fcf-427b-b55c-debfeffaf415	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
f524cc57-d961-49af-9920-6608babb1039	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	d197e81d-3fcf-427b-b55c-debfeffaf415	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
e9532515-74ee-40b9-8673-3864fb56b97a	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	d197e81d-3fcf-427b-b55c-debfeffaf415	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
55e44de1-5e89-4152-8e28-ef88eef16d50	t	f	broker	0	f	\N	\N	t	\N	f	d197e81d-3fcf-427b-b55c-debfeffaf415	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
0b14429d-4885-412c-b4e2-4486b44d49a2	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	d197e81d-3fcf-427b-b55c-debfeffaf415	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
00062e40-745c-4303-8ff0-149e00d42837	t	f	admin-cli	0	t	\N	\N	f	\N	f	d197e81d-3fcf-427b-b55c-debfeffaf415	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	f	real-world-app-realm	0	f	\N	\N	t	\N	f	d197e81d-3fcf-427b-b55c-debfeffaf415	\N	0	f	f	real-world-app Realm	f	client-secret	\N	\N	\N	t	f	f	f
06926a74-3904-4b43-8f99-759133764249	t	f	realm-management	0	f	\N	\N	t	\N	f	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
f59bb731-a6bf-4ec4-9773-1daa4e329433	t	f	account	0	t	\N	/realms/real-world-app/account/	f	\N	f	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	t	f	account-console	0	t	\N	/realms/real-world-app/account/	f	\N	f	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
2b499a97-50c0-42a3-8931-eb17ceb4f08b	t	f	broker	0	f	\N	\N	t	\N	f	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	t	f	security-admin-console	0	t	\N	/admin/real-world-app/console/	f	\N	f	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
30fb180a-5ca5-4ee0-bbff-38dd1b3a7c8c	t	f	admin-cli	0	t	\N	\N	f	\N	f	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
\.


--
-- TOC entry 4135 (class 0 OID 16756)
-- Dependencies: 234
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
f524cc57-d961-49af-9920-6608babb1039	post.logout.redirect.uris	+
e9532515-74ee-40b9-8673-3864fb56b97a	post.logout.redirect.uris	+
e9532515-74ee-40b9-8673-3864fb56b97a	pkce.code.challenge.method	S256
0b14429d-4885-412c-b4e2-4486b44d49a2	post.logout.redirect.uris	+
0b14429d-4885-412c-b4e2-4486b44d49a2	pkce.code.challenge.method	S256
f59bb731-a6bf-4ec4-9773-1daa4e329433	post.logout.redirect.uris	+
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	post.logout.redirect.uris	+
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	pkce.code.challenge.method	S256
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	post.logout.redirect.uris	+
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	pkce.code.challenge.method	S256
\.


--
-- TOC entry 4192 (class 0 OID 17724)
-- Dependencies: 291
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- TOC entry 4191 (class 0 OID 17599)
-- Dependencies: 290
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- TOC entry 4137 (class 0 OID 16766)
-- Dependencies: 236
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- TOC entry 4169 (class 0 OID 17265)
-- Dependencies: 268
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
782144e9-3a93-4ad6-95c8-0d317b729d25	offline_access	d197e81d-3fcf-427b-b55c-debfeffaf415	OpenID Connect built-in scope: offline_access	openid-connect
72f403ae-4c6a-47b6-b4b3-cd5956c05b3c	role_list	d197e81d-3fcf-427b-b55c-debfeffaf415	SAML role list	saml
7d9681ef-40c4-47ba-8a7f-c225e60a925b	profile	d197e81d-3fcf-427b-b55c-debfeffaf415	OpenID Connect built-in scope: profile	openid-connect
6e8353ed-3602-4a78-870d-16e002041a74	email	d197e81d-3fcf-427b-b55c-debfeffaf415	OpenID Connect built-in scope: email	openid-connect
17b761f7-226b-4a43-872c-097eae7c56fe	address	d197e81d-3fcf-427b-b55c-debfeffaf415	OpenID Connect built-in scope: address	openid-connect
a46100a6-bdb2-4b05-8328-fd80a3e58090	phone	d197e81d-3fcf-427b-b55c-debfeffaf415	OpenID Connect built-in scope: phone	openid-connect
0504ac26-2417-45cc-a9a7-5c0403af90f4	roles	d197e81d-3fcf-427b-b55c-debfeffaf415	OpenID Connect scope for add user roles to the access token	openid-connect
3cde377e-53bc-4520-9d72-e53c5272322f	web-origins	d197e81d-3fcf-427b-b55c-debfeffaf415	OpenID Connect scope for add allowed web origins to the access token	openid-connect
9504ba54-710b-487f-8d1e-6d59446bbab2	microprofile-jwt	d197e81d-3fcf-427b-b55c-debfeffaf415	Microprofile - JWT built-in scope	openid-connect
2f95d32d-7b8d-488c-b72a-d8bc5f69cdcc	acr	d197e81d-3fcf-427b-b55c-debfeffaf415	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
447281fd-c5a3-4b3d-96ff-c75c8ad10cd5	offline_access	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	OpenID Connect built-in scope: offline_access	openid-connect
520f9c35-9829-43c3-8b0b-23f1006e06fb	role_list	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	SAML role list	saml
8251313f-9ef8-4197-a185-8c8e6b81eb34	profile	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	OpenID Connect built-in scope: profile	openid-connect
bf31f266-48b5-4a6f-894d-eb9b886e40eb	email	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	OpenID Connect built-in scope: email	openid-connect
4920ee39-71f1-462a-afc9-7d0384a0cfc7	address	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	OpenID Connect built-in scope: address	openid-connect
8a9c97d2-7b14-4408-bd78-fd2714d59789	phone	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	OpenID Connect built-in scope: phone	openid-connect
a5cea84b-99e3-4014-8d7e-459ab67befd9	roles	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	OpenID Connect scope for add user roles to the access token	openid-connect
76ebb562-2a74-422a-b418-06680bf03b4c	web-origins	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	OpenID Connect scope for add allowed web origins to the access token	openid-connect
539c2a3b-6d11-4a41-9632-4dfd9cc2af9b	microprofile-jwt	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	Microprofile - JWT built-in scope	openid-connect
f1f7c32c-b1e8-4bcf-ae2e-d6f2d3d77085	acr	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
\.


--
-- TOC entry 4170 (class 0 OID 17279)
-- Dependencies: 269
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
782144e9-3a93-4ad6-95c8-0d317b729d25	true	display.on.consent.screen
782144e9-3a93-4ad6-95c8-0d317b729d25	${offlineAccessScopeConsentText}	consent.screen.text
72f403ae-4c6a-47b6-b4b3-cd5956c05b3c	true	display.on.consent.screen
72f403ae-4c6a-47b6-b4b3-cd5956c05b3c	${samlRoleListScopeConsentText}	consent.screen.text
7d9681ef-40c4-47ba-8a7f-c225e60a925b	true	display.on.consent.screen
7d9681ef-40c4-47ba-8a7f-c225e60a925b	${profileScopeConsentText}	consent.screen.text
7d9681ef-40c4-47ba-8a7f-c225e60a925b	true	include.in.token.scope
6e8353ed-3602-4a78-870d-16e002041a74	true	display.on.consent.screen
6e8353ed-3602-4a78-870d-16e002041a74	${emailScopeConsentText}	consent.screen.text
6e8353ed-3602-4a78-870d-16e002041a74	true	include.in.token.scope
17b761f7-226b-4a43-872c-097eae7c56fe	true	display.on.consent.screen
17b761f7-226b-4a43-872c-097eae7c56fe	${addressScopeConsentText}	consent.screen.text
17b761f7-226b-4a43-872c-097eae7c56fe	true	include.in.token.scope
a46100a6-bdb2-4b05-8328-fd80a3e58090	true	display.on.consent.screen
a46100a6-bdb2-4b05-8328-fd80a3e58090	${phoneScopeConsentText}	consent.screen.text
a46100a6-bdb2-4b05-8328-fd80a3e58090	true	include.in.token.scope
0504ac26-2417-45cc-a9a7-5c0403af90f4	true	display.on.consent.screen
0504ac26-2417-45cc-a9a7-5c0403af90f4	${rolesScopeConsentText}	consent.screen.text
0504ac26-2417-45cc-a9a7-5c0403af90f4	false	include.in.token.scope
3cde377e-53bc-4520-9d72-e53c5272322f	false	display.on.consent.screen
3cde377e-53bc-4520-9d72-e53c5272322f		consent.screen.text
3cde377e-53bc-4520-9d72-e53c5272322f	false	include.in.token.scope
9504ba54-710b-487f-8d1e-6d59446bbab2	false	display.on.consent.screen
9504ba54-710b-487f-8d1e-6d59446bbab2	true	include.in.token.scope
2f95d32d-7b8d-488c-b72a-d8bc5f69cdcc	false	display.on.consent.screen
2f95d32d-7b8d-488c-b72a-d8bc5f69cdcc	false	include.in.token.scope
447281fd-c5a3-4b3d-96ff-c75c8ad10cd5	true	display.on.consent.screen
447281fd-c5a3-4b3d-96ff-c75c8ad10cd5	${offlineAccessScopeConsentText}	consent.screen.text
520f9c35-9829-43c3-8b0b-23f1006e06fb	true	display.on.consent.screen
520f9c35-9829-43c3-8b0b-23f1006e06fb	${samlRoleListScopeConsentText}	consent.screen.text
8251313f-9ef8-4197-a185-8c8e6b81eb34	true	display.on.consent.screen
8251313f-9ef8-4197-a185-8c8e6b81eb34	${profileScopeConsentText}	consent.screen.text
8251313f-9ef8-4197-a185-8c8e6b81eb34	true	include.in.token.scope
bf31f266-48b5-4a6f-894d-eb9b886e40eb	true	display.on.consent.screen
bf31f266-48b5-4a6f-894d-eb9b886e40eb	${emailScopeConsentText}	consent.screen.text
bf31f266-48b5-4a6f-894d-eb9b886e40eb	true	include.in.token.scope
4920ee39-71f1-462a-afc9-7d0384a0cfc7	true	display.on.consent.screen
4920ee39-71f1-462a-afc9-7d0384a0cfc7	${addressScopeConsentText}	consent.screen.text
4920ee39-71f1-462a-afc9-7d0384a0cfc7	true	include.in.token.scope
8a9c97d2-7b14-4408-bd78-fd2714d59789	true	display.on.consent.screen
8a9c97d2-7b14-4408-bd78-fd2714d59789	${phoneScopeConsentText}	consent.screen.text
8a9c97d2-7b14-4408-bd78-fd2714d59789	true	include.in.token.scope
a5cea84b-99e3-4014-8d7e-459ab67befd9	true	display.on.consent.screen
a5cea84b-99e3-4014-8d7e-459ab67befd9	${rolesScopeConsentText}	consent.screen.text
a5cea84b-99e3-4014-8d7e-459ab67befd9	false	include.in.token.scope
76ebb562-2a74-422a-b418-06680bf03b4c	false	display.on.consent.screen
76ebb562-2a74-422a-b418-06680bf03b4c		consent.screen.text
76ebb562-2a74-422a-b418-06680bf03b4c	false	include.in.token.scope
539c2a3b-6d11-4a41-9632-4dfd9cc2af9b	false	display.on.consent.screen
539c2a3b-6d11-4a41-9632-4dfd9cc2af9b	true	include.in.token.scope
f1f7c32c-b1e8-4bcf-ae2e-d6f2d3d77085	false	display.on.consent.screen
f1f7c32c-b1e8-4bcf-ae2e-d6f2d3d77085	false	include.in.token.scope
\.


--
-- TOC entry 4193 (class 0 OID 17765)
-- Dependencies: 292
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
f524cc57-d961-49af-9920-6608babb1039	7d9681ef-40c4-47ba-8a7f-c225e60a925b	t
f524cc57-d961-49af-9920-6608babb1039	0504ac26-2417-45cc-a9a7-5c0403af90f4	t
f524cc57-d961-49af-9920-6608babb1039	3cde377e-53bc-4520-9d72-e53c5272322f	t
f524cc57-d961-49af-9920-6608babb1039	2f95d32d-7b8d-488c-b72a-d8bc5f69cdcc	t
f524cc57-d961-49af-9920-6608babb1039	6e8353ed-3602-4a78-870d-16e002041a74	t
f524cc57-d961-49af-9920-6608babb1039	9504ba54-710b-487f-8d1e-6d59446bbab2	f
f524cc57-d961-49af-9920-6608babb1039	782144e9-3a93-4ad6-95c8-0d317b729d25	f
f524cc57-d961-49af-9920-6608babb1039	a46100a6-bdb2-4b05-8328-fd80a3e58090	f
f524cc57-d961-49af-9920-6608babb1039	17b761f7-226b-4a43-872c-097eae7c56fe	f
e9532515-74ee-40b9-8673-3864fb56b97a	7d9681ef-40c4-47ba-8a7f-c225e60a925b	t
e9532515-74ee-40b9-8673-3864fb56b97a	0504ac26-2417-45cc-a9a7-5c0403af90f4	t
e9532515-74ee-40b9-8673-3864fb56b97a	3cde377e-53bc-4520-9d72-e53c5272322f	t
e9532515-74ee-40b9-8673-3864fb56b97a	2f95d32d-7b8d-488c-b72a-d8bc5f69cdcc	t
e9532515-74ee-40b9-8673-3864fb56b97a	6e8353ed-3602-4a78-870d-16e002041a74	t
e9532515-74ee-40b9-8673-3864fb56b97a	9504ba54-710b-487f-8d1e-6d59446bbab2	f
e9532515-74ee-40b9-8673-3864fb56b97a	782144e9-3a93-4ad6-95c8-0d317b729d25	f
e9532515-74ee-40b9-8673-3864fb56b97a	a46100a6-bdb2-4b05-8328-fd80a3e58090	f
e9532515-74ee-40b9-8673-3864fb56b97a	17b761f7-226b-4a43-872c-097eae7c56fe	f
00062e40-745c-4303-8ff0-149e00d42837	7d9681ef-40c4-47ba-8a7f-c225e60a925b	t
00062e40-745c-4303-8ff0-149e00d42837	0504ac26-2417-45cc-a9a7-5c0403af90f4	t
00062e40-745c-4303-8ff0-149e00d42837	3cde377e-53bc-4520-9d72-e53c5272322f	t
00062e40-745c-4303-8ff0-149e00d42837	2f95d32d-7b8d-488c-b72a-d8bc5f69cdcc	t
00062e40-745c-4303-8ff0-149e00d42837	6e8353ed-3602-4a78-870d-16e002041a74	t
00062e40-745c-4303-8ff0-149e00d42837	9504ba54-710b-487f-8d1e-6d59446bbab2	f
00062e40-745c-4303-8ff0-149e00d42837	782144e9-3a93-4ad6-95c8-0d317b729d25	f
00062e40-745c-4303-8ff0-149e00d42837	a46100a6-bdb2-4b05-8328-fd80a3e58090	f
00062e40-745c-4303-8ff0-149e00d42837	17b761f7-226b-4a43-872c-097eae7c56fe	f
55e44de1-5e89-4152-8e28-ef88eef16d50	7d9681ef-40c4-47ba-8a7f-c225e60a925b	t
55e44de1-5e89-4152-8e28-ef88eef16d50	0504ac26-2417-45cc-a9a7-5c0403af90f4	t
55e44de1-5e89-4152-8e28-ef88eef16d50	3cde377e-53bc-4520-9d72-e53c5272322f	t
55e44de1-5e89-4152-8e28-ef88eef16d50	2f95d32d-7b8d-488c-b72a-d8bc5f69cdcc	t
55e44de1-5e89-4152-8e28-ef88eef16d50	6e8353ed-3602-4a78-870d-16e002041a74	t
55e44de1-5e89-4152-8e28-ef88eef16d50	9504ba54-710b-487f-8d1e-6d59446bbab2	f
55e44de1-5e89-4152-8e28-ef88eef16d50	782144e9-3a93-4ad6-95c8-0d317b729d25	f
55e44de1-5e89-4152-8e28-ef88eef16d50	a46100a6-bdb2-4b05-8328-fd80a3e58090	f
55e44de1-5e89-4152-8e28-ef88eef16d50	17b761f7-226b-4a43-872c-097eae7c56fe	f
448c4db4-c6fa-45be-af4c-629ec0847ab9	7d9681ef-40c4-47ba-8a7f-c225e60a925b	t
448c4db4-c6fa-45be-af4c-629ec0847ab9	0504ac26-2417-45cc-a9a7-5c0403af90f4	t
448c4db4-c6fa-45be-af4c-629ec0847ab9	3cde377e-53bc-4520-9d72-e53c5272322f	t
448c4db4-c6fa-45be-af4c-629ec0847ab9	2f95d32d-7b8d-488c-b72a-d8bc5f69cdcc	t
448c4db4-c6fa-45be-af4c-629ec0847ab9	6e8353ed-3602-4a78-870d-16e002041a74	t
448c4db4-c6fa-45be-af4c-629ec0847ab9	9504ba54-710b-487f-8d1e-6d59446bbab2	f
448c4db4-c6fa-45be-af4c-629ec0847ab9	782144e9-3a93-4ad6-95c8-0d317b729d25	f
448c4db4-c6fa-45be-af4c-629ec0847ab9	a46100a6-bdb2-4b05-8328-fd80a3e58090	f
448c4db4-c6fa-45be-af4c-629ec0847ab9	17b761f7-226b-4a43-872c-097eae7c56fe	f
0b14429d-4885-412c-b4e2-4486b44d49a2	7d9681ef-40c4-47ba-8a7f-c225e60a925b	t
0b14429d-4885-412c-b4e2-4486b44d49a2	0504ac26-2417-45cc-a9a7-5c0403af90f4	t
0b14429d-4885-412c-b4e2-4486b44d49a2	3cde377e-53bc-4520-9d72-e53c5272322f	t
0b14429d-4885-412c-b4e2-4486b44d49a2	2f95d32d-7b8d-488c-b72a-d8bc5f69cdcc	t
0b14429d-4885-412c-b4e2-4486b44d49a2	6e8353ed-3602-4a78-870d-16e002041a74	t
0b14429d-4885-412c-b4e2-4486b44d49a2	9504ba54-710b-487f-8d1e-6d59446bbab2	f
0b14429d-4885-412c-b4e2-4486b44d49a2	782144e9-3a93-4ad6-95c8-0d317b729d25	f
0b14429d-4885-412c-b4e2-4486b44d49a2	a46100a6-bdb2-4b05-8328-fd80a3e58090	f
0b14429d-4885-412c-b4e2-4486b44d49a2	17b761f7-226b-4a43-872c-097eae7c56fe	f
f59bb731-a6bf-4ec4-9773-1daa4e329433	bf31f266-48b5-4a6f-894d-eb9b886e40eb	t
f59bb731-a6bf-4ec4-9773-1daa4e329433	a5cea84b-99e3-4014-8d7e-459ab67befd9	t
f59bb731-a6bf-4ec4-9773-1daa4e329433	8251313f-9ef8-4197-a185-8c8e6b81eb34	t
f59bb731-a6bf-4ec4-9773-1daa4e329433	f1f7c32c-b1e8-4bcf-ae2e-d6f2d3d77085	t
f59bb731-a6bf-4ec4-9773-1daa4e329433	76ebb562-2a74-422a-b418-06680bf03b4c	t
f59bb731-a6bf-4ec4-9773-1daa4e329433	447281fd-c5a3-4b3d-96ff-c75c8ad10cd5	f
f59bb731-a6bf-4ec4-9773-1daa4e329433	539c2a3b-6d11-4a41-9632-4dfd9cc2af9b	f
f59bb731-a6bf-4ec4-9773-1daa4e329433	8a9c97d2-7b14-4408-bd78-fd2714d59789	f
f59bb731-a6bf-4ec4-9773-1daa4e329433	4920ee39-71f1-462a-afc9-7d0384a0cfc7	f
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	bf31f266-48b5-4a6f-894d-eb9b886e40eb	t
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	a5cea84b-99e3-4014-8d7e-459ab67befd9	t
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	8251313f-9ef8-4197-a185-8c8e6b81eb34	t
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	f1f7c32c-b1e8-4bcf-ae2e-d6f2d3d77085	t
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	76ebb562-2a74-422a-b418-06680bf03b4c	t
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	447281fd-c5a3-4b3d-96ff-c75c8ad10cd5	f
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	539c2a3b-6d11-4a41-9632-4dfd9cc2af9b	f
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	8a9c97d2-7b14-4408-bd78-fd2714d59789	f
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	4920ee39-71f1-462a-afc9-7d0384a0cfc7	f
30fb180a-5ca5-4ee0-bbff-38dd1b3a7c8c	bf31f266-48b5-4a6f-894d-eb9b886e40eb	t
30fb180a-5ca5-4ee0-bbff-38dd1b3a7c8c	a5cea84b-99e3-4014-8d7e-459ab67befd9	t
30fb180a-5ca5-4ee0-bbff-38dd1b3a7c8c	8251313f-9ef8-4197-a185-8c8e6b81eb34	t
30fb180a-5ca5-4ee0-bbff-38dd1b3a7c8c	f1f7c32c-b1e8-4bcf-ae2e-d6f2d3d77085	t
30fb180a-5ca5-4ee0-bbff-38dd1b3a7c8c	76ebb562-2a74-422a-b418-06680bf03b4c	t
30fb180a-5ca5-4ee0-bbff-38dd1b3a7c8c	447281fd-c5a3-4b3d-96ff-c75c8ad10cd5	f
30fb180a-5ca5-4ee0-bbff-38dd1b3a7c8c	539c2a3b-6d11-4a41-9632-4dfd9cc2af9b	f
30fb180a-5ca5-4ee0-bbff-38dd1b3a7c8c	8a9c97d2-7b14-4408-bd78-fd2714d59789	f
30fb180a-5ca5-4ee0-bbff-38dd1b3a7c8c	4920ee39-71f1-462a-afc9-7d0384a0cfc7	f
2b499a97-50c0-42a3-8931-eb17ceb4f08b	bf31f266-48b5-4a6f-894d-eb9b886e40eb	t
2b499a97-50c0-42a3-8931-eb17ceb4f08b	a5cea84b-99e3-4014-8d7e-459ab67befd9	t
2b499a97-50c0-42a3-8931-eb17ceb4f08b	8251313f-9ef8-4197-a185-8c8e6b81eb34	t
2b499a97-50c0-42a3-8931-eb17ceb4f08b	f1f7c32c-b1e8-4bcf-ae2e-d6f2d3d77085	t
2b499a97-50c0-42a3-8931-eb17ceb4f08b	76ebb562-2a74-422a-b418-06680bf03b4c	t
2b499a97-50c0-42a3-8931-eb17ceb4f08b	447281fd-c5a3-4b3d-96ff-c75c8ad10cd5	f
2b499a97-50c0-42a3-8931-eb17ceb4f08b	539c2a3b-6d11-4a41-9632-4dfd9cc2af9b	f
2b499a97-50c0-42a3-8931-eb17ceb4f08b	8a9c97d2-7b14-4408-bd78-fd2714d59789	f
2b499a97-50c0-42a3-8931-eb17ceb4f08b	4920ee39-71f1-462a-afc9-7d0384a0cfc7	f
06926a74-3904-4b43-8f99-759133764249	bf31f266-48b5-4a6f-894d-eb9b886e40eb	t
06926a74-3904-4b43-8f99-759133764249	a5cea84b-99e3-4014-8d7e-459ab67befd9	t
06926a74-3904-4b43-8f99-759133764249	8251313f-9ef8-4197-a185-8c8e6b81eb34	t
06926a74-3904-4b43-8f99-759133764249	f1f7c32c-b1e8-4bcf-ae2e-d6f2d3d77085	t
06926a74-3904-4b43-8f99-759133764249	76ebb562-2a74-422a-b418-06680bf03b4c	t
06926a74-3904-4b43-8f99-759133764249	447281fd-c5a3-4b3d-96ff-c75c8ad10cd5	f
06926a74-3904-4b43-8f99-759133764249	539c2a3b-6d11-4a41-9632-4dfd9cc2af9b	f
06926a74-3904-4b43-8f99-759133764249	8a9c97d2-7b14-4408-bd78-fd2714d59789	f
06926a74-3904-4b43-8f99-759133764249	4920ee39-71f1-462a-afc9-7d0384a0cfc7	f
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	bf31f266-48b5-4a6f-894d-eb9b886e40eb	t
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	a5cea84b-99e3-4014-8d7e-459ab67befd9	t
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	8251313f-9ef8-4197-a185-8c8e6b81eb34	t
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	f1f7c32c-b1e8-4bcf-ae2e-d6f2d3d77085	t
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	76ebb562-2a74-422a-b418-06680bf03b4c	t
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	447281fd-c5a3-4b3d-96ff-c75c8ad10cd5	f
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	539c2a3b-6d11-4a41-9632-4dfd9cc2af9b	f
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	8a9c97d2-7b14-4408-bd78-fd2714d59789	f
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	4920ee39-71f1-462a-afc9-7d0384a0cfc7	f
\.


--
-- TOC entry 4171 (class 0 OID 17284)
-- Dependencies: 270
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
782144e9-3a93-4ad6-95c8-0d317b729d25	5059447d-75b6-499c-ba70-08138fb8f37d
447281fd-c5a3-4b3d-96ff-c75c8ad10cd5	9bb90c60-fd0a-45b2-b886-05607fc1fcdb
\.


--
-- TOC entry 4113 (class 0 OID 16409)
-- Dependencies: 212
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- TOC entry 4158 (class 0 OID 17055)
-- Dependencies: 257
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- TOC entry 4136 (class 0 OID 16761)
-- Dependencies: 235
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- TOC entry 4150 (class 0 OID 16939)
-- Dependencies: 249
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- TOC entry 4114 (class 0 OID 16414)
-- Dependencies: 213
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- TOC entry 4159 (class 0 OID 17136)
-- Dependencies: 258
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- TOC entry 4189 (class 0 OID 17520)
-- Dependencies: 288
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
fe9359f8-c5d1-461f-a935-3d1af6cc6ebd	Trusted Hosts	d197e81d-3fcf-427b-b55c-debfeffaf415	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d197e81d-3fcf-427b-b55c-debfeffaf415	anonymous
5a53679c-d0ba-4aed-a468-9ccc8219eab1	Consent Required	d197e81d-3fcf-427b-b55c-debfeffaf415	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d197e81d-3fcf-427b-b55c-debfeffaf415	anonymous
42c46156-7d47-4b47-ab48-ae42c36715af	Full Scope Disabled	d197e81d-3fcf-427b-b55c-debfeffaf415	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d197e81d-3fcf-427b-b55c-debfeffaf415	anonymous
2955f62d-83c5-4d99-ad1d-6f310e3d65e6	Max Clients Limit	d197e81d-3fcf-427b-b55c-debfeffaf415	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d197e81d-3fcf-427b-b55c-debfeffaf415	anonymous
3171f410-9ff5-401e-b4d0-cd030758dcb2	Allowed Protocol Mapper Types	d197e81d-3fcf-427b-b55c-debfeffaf415	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d197e81d-3fcf-427b-b55c-debfeffaf415	anonymous
e0bf75eb-3815-4b84-9a93-25972dafded9	Allowed Client Scopes	d197e81d-3fcf-427b-b55c-debfeffaf415	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d197e81d-3fcf-427b-b55c-debfeffaf415	anonymous
7c4d01f9-0b3d-4657-ae76-828f362bbb4f	Allowed Protocol Mapper Types	d197e81d-3fcf-427b-b55c-debfeffaf415	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d197e81d-3fcf-427b-b55c-debfeffaf415	authenticated
6d328c30-2726-4a47-aa61-b43aa3f2fcab	Allowed Client Scopes	d197e81d-3fcf-427b-b55c-debfeffaf415	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d197e81d-3fcf-427b-b55c-debfeffaf415	authenticated
50520b93-0e83-4b82-8c24-e095f0f17949	rsa-generated	d197e81d-3fcf-427b-b55c-debfeffaf415	rsa-generated	org.keycloak.keys.KeyProvider	d197e81d-3fcf-427b-b55c-debfeffaf415	\N
77dd57f9-1d9c-4281-8840-0fb218e6583c	rsa-enc-generated	d197e81d-3fcf-427b-b55c-debfeffaf415	rsa-enc-generated	org.keycloak.keys.KeyProvider	d197e81d-3fcf-427b-b55c-debfeffaf415	\N
c7109179-e036-4835-b933-c30147d0a494	hmac-generated	d197e81d-3fcf-427b-b55c-debfeffaf415	hmac-generated	org.keycloak.keys.KeyProvider	d197e81d-3fcf-427b-b55c-debfeffaf415	\N
7156d670-c459-4325-95da-85eaec5a6a10	aes-generated	d197e81d-3fcf-427b-b55c-debfeffaf415	aes-generated	org.keycloak.keys.KeyProvider	d197e81d-3fcf-427b-b55c-debfeffaf415	\N
72f6a86b-8e28-4fc2-9d66-16301eb2b1db	rsa-generated	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	rsa-generated	org.keycloak.keys.KeyProvider	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	\N
5b8f7084-5973-4965-a939-108051f75940	rsa-enc-generated	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	rsa-enc-generated	org.keycloak.keys.KeyProvider	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	\N
868a3a96-60cf-4f8e-b360-ee1e829d34d4	hmac-generated	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	hmac-generated	org.keycloak.keys.KeyProvider	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	\N
6380f6f0-eb21-46f7-af9e-fbb42dc545f7	aes-generated	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	aes-generated	org.keycloak.keys.KeyProvider	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	\N
7d3527ca-1654-4a02-89c0-44bbfbcfa38b	Trusted Hosts	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	anonymous
ae0c68d9-258c-4b3e-a0fb-c9d3deb5d1bc	Consent Required	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	anonymous
1b086700-8dc7-4b3e-9900-bc1b231e7219	Full Scope Disabled	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	anonymous
3384066b-f599-451c-8636-e977e5951f04	Max Clients Limit	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	anonymous
87e2fafe-7e81-42d4-8c78-2d3ff4fcf32b	Allowed Protocol Mapper Types	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	anonymous
9562964e-ccae-4680-b6ac-5eec1542c340	Allowed Client Scopes	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	anonymous
4edb46df-05fe-4f24-8a5a-ea5523ebf1f6	Allowed Protocol Mapper Types	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	authenticated
b22e1c1f-2972-473c-b818-1ede882f9381	Allowed Client Scopes	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	authenticated
\.


--
-- TOC entry 4188 (class 0 OID 17515)
-- Dependencies: 287
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
11f22a9b-447d-4202-9b17-97f12fe81375	fe9359f8-c5d1-461f-a935-3d1af6cc6ebd	host-sending-registration-request-must-match	true
db52ed29-d700-4bf6-af9f-032e402d607e	fe9359f8-c5d1-461f-a935-3d1af6cc6ebd	client-uris-must-match	true
334e9988-9da5-4fb5-a6ae-e0560eaeb00a	e0bf75eb-3815-4b84-9a93-25972dafded9	allow-default-scopes	true
91ff04a5-0d61-4e1f-9d2a-8727f40a75bf	7c4d01f9-0b3d-4657-ae76-828f362bbb4f	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
53df9cff-08c3-4933-a4a7-b8315f914cc0	7c4d01f9-0b3d-4657-ae76-828f362bbb4f	allowed-protocol-mapper-types	oidc-address-mapper
fb23d945-6867-4fe8-9738-8b12cdfaa337	7c4d01f9-0b3d-4657-ae76-828f362bbb4f	allowed-protocol-mapper-types	oidc-full-name-mapper
9101ec6b-b687-4d6b-8349-d03b2f1fe7fc	7c4d01f9-0b3d-4657-ae76-828f362bbb4f	allowed-protocol-mapper-types	saml-role-list-mapper
b46693fe-a34d-42b6-8478-98fb4c0e4243	7c4d01f9-0b3d-4657-ae76-828f362bbb4f	allowed-protocol-mapper-types	saml-user-property-mapper
5b944298-03f9-4b44-9e7d-209009fa9513	7c4d01f9-0b3d-4657-ae76-828f362bbb4f	allowed-protocol-mapper-types	saml-user-attribute-mapper
87353629-235b-4ba3-a59e-1724e86bba30	7c4d01f9-0b3d-4657-ae76-828f362bbb4f	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
58aa684c-724f-44ee-a3c4-e46dadae3a9f	7c4d01f9-0b3d-4657-ae76-828f362bbb4f	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
f9260ca2-00a6-4612-9a73-69c29936349c	2955f62d-83c5-4d99-ad1d-6f310e3d65e6	max-clients	200
172e9d00-be58-447e-ab6f-ef4a9a73428f	6d328c30-2726-4a47-aa61-b43aa3f2fcab	allow-default-scopes	true
4c57f3b7-8605-4cae-aeba-5f6de0d943db	3171f410-9ff5-401e-b4d0-cd030758dcb2	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
929b2ca3-be88-4d30-8a79-34918869e35c	3171f410-9ff5-401e-b4d0-cd030758dcb2	allowed-protocol-mapper-types	oidc-address-mapper
f9e28eb1-cd0a-4d48-8cb5-602fd1c9bfea	3171f410-9ff5-401e-b4d0-cd030758dcb2	allowed-protocol-mapper-types	saml-role-list-mapper
96da2d02-545b-43dc-bb9e-804eeb32260c	3171f410-9ff5-401e-b4d0-cd030758dcb2	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
652cf4b9-5400-4181-bb16-cd693d283466	3171f410-9ff5-401e-b4d0-cd030758dcb2	allowed-protocol-mapper-types	saml-user-property-mapper
c00d330f-47c0-4fc4-904e-07036f69b99d	3171f410-9ff5-401e-b4d0-cd030758dcb2	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
c97376f0-e584-43b6-9319-da9221425d62	3171f410-9ff5-401e-b4d0-cd030758dcb2	allowed-protocol-mapper-types	saml-user-attribute-mapper
7225ba30-baf5-4273-9637-e1221536548b	3171f410-9ff5-401e-b4d0-cd030758dcb2	allowed-protocol-mapper-types	oidc-full-name-mapper
e365a85e-5b42-4950-b4e8-cf55c0f130a7	50520b93-0e83-4b82-8c24-e095f0f17949	priority	100
5a57dae5-4462-4e72-9a71-a5d2a3a16f9f	50520b93-0e83-4b82-8c24-e095f0f17949	keyUse	SIG
3bab49e1-942c-452a-9a68-66e1b682d32c	50520b93-0e83-4b82-8c24-e095f0f17949	certificate	MIICmzCCAYMCBgGIEiJQIjANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjMwNTEyMjI0MTU4WhcNMzMwNTEyMjI0MzM4WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDVlhgEnuAjG0Owb2iL/cljsmO8SMiZOjmbLTQMIAiFbWWQ5qq1B5vMEN39blBNUBztqrsQ6Fs4bTc9aWI1K3o/BRMjM1iwUL67qyg0t3XurWd5vsBSIBgr6m3dgSSbZdhBIMQWDH4GwJXYHBl4v2j/foD2FZT7HK3/lwTxmKFgEv17FsPkihTIFwYgwOUP4Veqb/YJn6lwlQduZU48xnMbBkg5N11OLNuou6gugcpBanf52IHROBxJc8Em8l6aWN/M6WVnT7w/eND84eGE+9mcEYOh1JOmiyCA3KGAHXyVqhu1VdgJT7CE++wnBXYii6EIl8Pk4qTBaDKVO6VPL7HrAgMBAAEwDQYJKoZIhvcNAQELBQADggEBADplDtmnktVuhGXL48kvRZDpfiABBfT6RfLgM7ncqdaGSrD7oDdVYr2JE55oReawtjwETK1VoY6JLht26BBHXN49IISt0YQfPVh+/HmxD6UaG4rnNV+NITjH6Z6gYq7Jy3Ca7CHjhnhro/Kojl8urildGBHmb+bXZXFJOXl6VplzVhJg2lprYLtfZp1mLDo++LuFuOglhcOFcqqTu+ch8Z/jXHqY8g87Cok8Jsm0LTRWdtQCq1g6ErXFASnwoeBWSE3kSd7UKxl99bcRzo7FOovNdtUPTw/c7ARGFrAEzDJbJcMw5DPPvv5zgfoTrAhP5Cf28UIrqqxAOUbWuR7MAKE=
eb82ad8b-c33a-4acd-8744-da3be32c559b	50520b93-0e83-4b82-8c24-e095f0f17949	privateKey	MIIEogIBAAKCAQEA1ZYYBJ7gIxtDsG9oi/3JY7JjvEjImTo5my00DCAIhW1lkOaqtQebzBDd/W5QTVAc7aq7EOhbOG03PWliNSt6PwUTIzNYsFC+u6soNLd17q1neb7AUiAYK+pt3YEkm2XYQSDEFgx+BsCV2BwZeL9o/36A9hWU+xyt/5cE8ZihYBL9exbD5IoUyBcGIMDlD+FXqm/2CZ+pcJUHbmVOPMZzGwZIOTddTizbqLuoLoHKQWp3+diB0TgcSXPBJvJemljfzOllZ0+8P3jQ/OHhhPvZnBGDodSTposggNyhgB18laobtVXYCU+whPvsJwV2IouhCJfD5OKkwWgylTulTy+x6wIDAQABAoIBAFr5T+ij7U82vTmo8mxyYDXVVXLsw3i0mrXUZq9lc4u1gYXbIknyYDNm2c8pDg4oOfInfv9gIP6jUlyXhwujpbGzDSg4piWPdvZDnF/75sEPXhw2mf9BCVqnQz2OVNPV6OswtCS6FHH21LxUl6rdSLFOpkpq/eaJnDlaD3KCcvYSyOBkNFJvHZBALiBKr2isZuROuvMTwfSFR6XxryY0vNaDiGy0oeh9B7MpKP3lA59cZ/5lJuOCaxRFn5iVCBccbP66OUsatC9jJYR4QKf0TTbLBAtoTv+/YnZJHIyoNcAy1RCRluN3culkn357bas1lW382gBgxqZ/9E0uYFDIo50CgYEA+/8irEpfY72rQis8njpwodcBz4KpF+dHdOuY1OdQZdVwojYMIlG194BaX7RA5No0wPTQXuIe5IrXybXO1XuE4eX/WNqe+4U4R6HWiKouq1QLDvTeSCBcSwYU5iHueqUwB9FWTsCF92e9jNWH2wPmebQOB9lkmpnr5rmZh5EIRFUCgYEA2Pq+lmIt4g9oXTyKy5svIiefS3bwlGLMCEf0l04ieQlKu3cly67UPV2TriB62eicQ8tQSkoMNnDIkNBEWO5Kibg0fkiYyWcAJOt9+PeEDi2JpE9OVznEj18UNZAFMaIdnVqDBhzs3MR0pFZWkZu3C3IQzGrYBPFSS6xcRVwEXT8CgYBbR2iM1gfFfj+ZoUW83thLlzEdtGuBsBHvJSPgAsXZjT3WVBODHuv18fVKc2WKQAwZ1NPherDMAgr2ErgQFkTk+sXKrq4l13SyZcnrCRIMl03GJiaaI7aqqlJJpgLXRByoyEgmEJC2NEqxx+sFB12lufXXHATYB2cu1Q3q0DsZXQKBgDFwqP6xLk1FP32HLwUHviylJJnYZycYf+8fHi9fwWEc6edfVcBcfMXizaSuh++hHgIgkJHs322EM18z5W7yFQ/eZi+kMRQrIRBIjHKvS2rDm4pR+8LKSex1OLCfuV8+1kqldhdtfdcr+Hv9pEoXVhUIj6VUbxZpOlw90OSI/AGXAoGAVAmEoUXYnwx0MpMtx/baiAYhXuw9PxNNjWhUJZZPoh/Bs+R4VDqU3XDfxiN4KxQdUdv4XbV0hpVKJOVL/W5xiHiB6eeHMpNoGCRmYbJ7geP3j8RVvtrtGvYoeDcIRhVtaIlHLDLUgCw70/u/6M68rANbjnQr14TNUhglckkRheY=
74a96285-8ce0-4b00-8a93-e56786f24908	77dd57f9-1d9c-4281-8840-0fb218e6583c	algorithm	RSA-OAEP
28bdd562-39fe-490b-be8d-c132e8537630	77dd57f9-1d9c-4281-8840-0fb218e6583c	certificate	MIICmzCCAYMCBgGIEiJQ1TANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjMwNTEyMjI0MTU4WhcNMzMwNTEyMjI0MzM4WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCmysjyjM27XHQNiVp9owOyVNTrlzeTpmVQRT5zkLHZzCLc0Xj9kXsijPxtXgZi1BshJNUHYl9L3wDXqIh3Z+Vj0AbM+V3KNd9DVi39iMeklbfoxB/iQPYY0kgmPj9KRsgSLk+fFTyZUsZAcH1wTRk0iAOtNpzMR+i/I021uBfN79APbZWctGDYmGDXJGR4/4KzeNUh0MYZZt+VkZ3tedYrkUnoK2HI0wDbEJB4tBnHCAc3hrj74xXOoF/Ncy6DaaTU+TBYOsr6N/YsPGFvc15dESJkD7PBK/lCDZnIfRmhDjjnJ1I4j7SaSDRR2H/xELAIaMJvUfQO00PVJdD1aCBxAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAFf09VwX5uvhZMPxw+V5BWFHT0+FtyxSDngfQtz7t7nUHMJ3WG/OWBoUgHjclnQZOVIzCCFci6tuI6zhjiirbeveDfDlz2GL4w9jbigkFK6I0WuiREzhM7E/XpgJdA8kUjyGa6SK4/RdBZjJF9Ho/8XuPXjbApEUeO6P1H3HNNLJmsDyr5NqrCfZXDABxBBe3P7c3/+pdEuIxer8Gmjh1vfFBsTc8Slg4/kwRUMVbhrrCp2G8Y6INeiQ8hzmDUnKEuYI+XraplvgDhZTdAGU+H4u+CcC9y6NHbf51ZkHshz/AK+s5HfC24ENpdZfP6x+f1Vf2mCLDkeOEQe51g4Eqhk=
359b3a5d-e018-4e28-b624-f7fca9c5afa4	77dd57f9-1d9c-4281-8840-0fb218e6583c	priority	100
9b9132f7-3a98-476e-bdc2-eb7a1c85951e	77dd57f9-1d9c-4281-8840-0fb218e6583c	keyUse	ENC
2060f660-09f5-44a4-9b95-4ca13a4f1dd1	77dd57f9-1d9c-4281-8840-0fb218e6583c	privateKey	MIIEowIBAAKCAQEApsrI8ozNu1x0DYlafaMDslTU65c3k6ZlUEU+c5Cx2cwi3NF4/ZF7Ioz8bV4GYtQbISTVB2JfS98A16iId2flY9AGzPldyjXfQ1Yt/YjHpJW36MQf4kD2GNJIJj4/SkbIEi5PnxU8mVLGQHB9cE0ZNIgDrTaczEfovyNNtbgXze/QD22VnLRg2Jhg1yRkeP+Cs3jVIdDGGWbflZGd7XnWK5FJ6CthyNMA2xCQeLQZxwgHN4a4++MVzqBfzXMug2mk1PkwWDrK+jf2LDxhb3NeXREiZA+zwSv5Qg2ZyH0ZoQ445ydSOI+0mkg0Udh/8RCwCGjCb1H0DtND1SXQ9WggcQIDAQABAoIBAAdo5996qOMjetZlHTuKo+3mveTPfX0WPdcAlIMu0O/jlULpHW5qaaWBzO8Q58i5MpFY4Qvob2JgAFoUVyey2mqCQeMWSvfiR85mhDmIu5HQwvBY0i/LggNdSC5GwqoKlfXUz9255EzNdBhFxxTXoACI8FzgGbwrj6f6KggiKxCPfeWzuGMJfcIilcrdgbQQvEACD8ytBlaDJ+VRZ8lZ819mR20WvdqugDrQmvpN+Wqe0ItXLa4ZYpuLcTB0VMDa3F7u+0rt3BzOV6OkUJJ1dFkBh/Uxqetu83Nn5T3k0zrhWVPm2nExQDEgfG60t4Ee8jOsy7RcVWdpcCDNlhAmHwcCgYEA41Iaqfd4a1zVeMyTK+Jo6AT4Vke/p4EwSh6OLvQG6f5jyAzp7llxh5EC0RrwpVO3yO64662DZjyC0ifDKN+j9z6KDHH1Q5zxQLr44jSf5CgUMZjaQtRDZ7eBpMH1b/4twLDXLppP/bS65/f9cJRS4d5vVhnFD8s4Wh6Gv5y6v8MCgYEAu9XB4HTAynnXOVWWOhOgSt3Hg322/jCt8/0p77igL3Q1p+WHRSXuKkJJYWFI6K6OWXC0CZmLuBsaBAGdGXNyNx+zklgJNQGHNUo6YLHrzmaW8sCaU9tg3POLl6pVF/d/84IL4J0WwCPJ6zfyV5vVYqmOjut2fazpbau+Vm+977sCgYAJkPz6RiXVLtT0/nb7E84iZYMl7mMMY41qsRp+s1pPIpuEYba+hxkWAW5C6oVSD9HeLN2vXV/4P3ep7G50G+VElGcu2uTdcY9dkADFVD2eVmlzJOGaimBDzx8vldIEYof+YfLMTUYsgRyUgoUx5awPQVMiJnd6kKzQbhRxn+DkDQKBgFl0HGfz0ljbG7ePXgL8k8rzwe+KMFrv/fgDqjQjHg5bbq4t7nTs8nanqOC6fwlpEBviQ6uKt3KPXZ1o01NqmotMCq34RTI8LxMe7ZxdP2rFir/DH/wtrvyq8+Df2rSWRxZF6bgnt8z7fk8KDtzQNxhMnbrMwlppvaVgND5f6vm/AoGBALTnGZtn38BMw7Rq3NSbXC+6E39ANTxJNLVIUwmOTEXilMFSU4T37km/LqERiKRe+GjP8h2YEoNyZuplWNmfhqjdfvbBEXxFfWjEDXkKJ/SRwJYy4M3ebRCAxeiWVtEFlZQQQDR2OmEX927mBYeOHONMZE8zC+iIgbaCNSKAzbpS
8b79d04b-4ad6-4cda-8419-2a30796dbfd6	7156d670-c459-4325-95da-85eaec5a6a10	kid	96a8f618-270b-492f-8f4e-535df4c7ce7c
3ec18794-5f3d-444e-a231-b2e394a4b42e	7156d670-c459-4325-95da-85eaec5a6a10	secret	SiNXkZWaEBnzsfQ-ui5l1g
faf73a26-340b-4a07-bd37-6c7e0d9d3748	7156d670-c459-4325-95da-85eaec5a6a10	priority	100
2e5836fc-3971-4583-8ccc-d7f6277fcf2a	c7109179-e036-4835-b933-c30147d0a494	kid	a05f921e-c082-4bd8-ae16-c502ec5a40f4
b16e248f-e144-46fc-9586-b8ec03dc44bf	c7109179-e036-4835-b933-c30147d0a494	algorithm	HS256
44850b54-eaa0-4dd5-b6eb-7aac01bd8aa5	c7109179-e036-4835-b933-c30147d0a494	priority	100
306e4374-0c1f-4fee-9f55-4a548c52337c	c7109179-e036-4835-b933-c30147d0a494	secret	oCEhzDBxo32kqa6Os6CQSObBjfHR4wckCwgWJw7d9Qz0Ngpq5tVE27aTI0RXBzms8wp64x37Tbc26OIYNa08ig
1d4fbecc-f2e8-4f15-b4a5-da1bd251753c	72f6a86b-8e28-4fc2-9d66-16301eb2b1db	keyUse	SIG
95cd4139-b46e-466d-9596-acb0fef095e1	72f6a86b-8e28-4fc2-9d66-16301eb2b1db	certificate	MIICqzCCAZMCBgGIEiNpIjANBgkqhkiG9w0BAQsFADAZMRcwFQYDVQQDDA5yZWFsLXdvcmxkLWFwcDAeFw0yMzA1MTIyMjQzMTBaFw0zMzA1MTIyMjQ0NTBaMBkxFzAVBgNVBAMMDnJlYWwtd29ybGQtYXBwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAupnpzx4/tDeYydQKbgDN1iSGuZvdANRoVCU2lcaDM+NWiuu7GY9PZVDxO/syWg9lFM2MCWJSfWkmszj0y4Rk59O3+v5eCtkY2JxK9Wv5X9e7ZW1R1JjDRONNk/rfRlaEi175ynY+8uCB1AlQ1mmX4cW4AbA8fraKmnTOgQFoBYRyWwAsZGm8kZSXhcQWbChQDoTpi/61h9ElYKGNc0Ych+IwLYZKeszB1yVC2DM7dIYX8QWPKGXqedIWi/guRULUyd6xIQpZ2ThRyZhlMKe7lU0l6t6uSc2N6oGNIAA6LV6FD550rYvwKmGeR0nykF57/1QcZTu7As/ifJXKWl7ZDQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQCRKgZxud9AYO7w+gXRMNmlFX9nu4XaP+QkUzWgKIaPEy3FnQoslSTPAiGa8wQmzg4+uDDVILpnBVXIjLlvrAiJPRfsWGBRcykASKls/FOE/FJQyyYxeUNOwjeR67pw6GOPktzFcReRg7I35FWHaGyMg7u4wfTjCDDgGczGdryIbp/KOQ2R4qyLBujVLi3Yv/iqembR/ZOdMILuIfLUNL9E9bYu91HENDEjqUvJhhcUYtWxcxhs98Lg/FpEmYpuKuLIKwU/fG5iemIpdMCvORpTr4M0VrfKLWT0Iv32ZQb0xZ2gjRKKG1OuMNfRFCcLehdZ3fzY4rZoOEfJ9nPbRS55
1081f4ba-68ba-4015-91ff-460ab600b864	72f6a86b-8e28-4fc2-9d66-16301eb2b1db	priority	100
ddb06ba5-6a51-4bf7-8524-cf6744a53631	72f6a86b-8e28-4fc2-9d66-16301eb2b1db	privateKey	MIIEogIBAAKCAQEAupnpzx4/tDeYydQKbgDN1iSGuZvdANRoVCU2lcaDM+NWiuu7GY9PZVDxO/syWg9lFM2MCWJSfWkmszj0y4Rk59O3+v5eCtkY2JxK9Wv5X9e7ZW1R1JjDRONNk/rfRlaEi175ynY+8uCB1AlQ1mmX4cW4AbA8fraKmnTOgQFoBYRyWwAsZGm8kZSXhcQWbChQDoTpi/61h9ElYKGNc0Ych+IwLYZKeszB1yVC2DM7dIYX8QWPKGXqedIWi/guRULUyd6xIQpZ2ThRyZhlMKe7lU0l6t6uSc2N6oGNIAA6LV6FD550rYvwKmGeR0nykF57/1QcZTu7As/ifJXKWl7ZDQIDAQABAoIBAADIwE2Km5XC4mK+FXbNtzpmPWW0H2Xkk/VUkbSSmL8OqRtc2b9bVZKqrX+FHaVOFBdAtOJeNileQtd1JBGN4ncB8gTn7ZZp6qY7DpVA8/5AiReoRwmCbyxP2zswY6CnS5fNWUs4m35IThYJcvxFBdUg+wC7evRFCUiUY0DHXtFKcceaJQDUd0YwgUyJUuRqhROkIC+YMe3/R+3YgFc69WM0wtWbRWeTSgSM63kYiVeZDV4dzFF+0Gduca/J1MD9DkEEVDtz0SZtnjZIQOGBCYs/kCjQjHxvYRoIjM54WwjCRjryCBwjmXTtO5rkMEXcfc+ZcMoFqZ8mp7h/vGKugCkCgYEA42HIA+d8rJig5yw1tnWbnwZoPnWFsaX9QATp7wRJXa+1aTgW7tIVR3KLiVcufjwAvscqeHyrBQP8QQV9+9lnyqiUuoCMB+6JPAQFdXdiDPn2Vr/jMhhkeLfg76o2Yz28MXlpor52jiQIm1bJXXIQhRO7CrPsKnqsNarStPPw+1UCgYEA0hYuiGe7KOyvsO5RK+uh2CdLYa9U0dH8PimqlmUasJgOYDeQWFDuYxJ5oo/N4PWKQp8NHCFEKy1SC4ezPphWv2SF6r8fB0BWCE8sEzFU0b1mE61iOavXqMJ7RiVQOdJM5mYEH+5E7kcU5WPMG06z5QU8OP+qhaDmrf4vofx+ltkCgYBTOExuMWEOAmaRdTrLZsvoLf4lLfoahLfloGbGFfmMEm0A74hlK/qhxaiQQZpAlVFogZhntKkbEtRWL95mOLGmGIEmqTmXBZSwpIAi9+io+ytPoLdUdF0BWbs3vEJfnA6uxNMGv1LAvytvPxo/2yl0qz3/ss4y1ecFVVn85HNEaQKBgF4jsHBRQy3Aea3n7Jmoudo5KW85eOGYndZhJ17DKWWOjYqR+22HvnrIkZbFp7SxcmYODXrYcUqDwWsHQMvAycZzzgp13/qI2sRYbeCfz2k43J/eptA+76FgnIq/N6bhVLI9boW8aEj5syRjRtfJuZTbdrP35LqCcjvvVfrZQQRpAoGAJX2Wi6HY69JJDMn9CR7xpKC72Ic0QqvzNElc0hSqu+jek6+NHPz23RH+cks25qtmKnDSGoNvy84RuTyMjbCGLAwT1zIWDtuy+RDf/OfwurnXOfhT/j6G512kr628YYGmdbxWslr3fg9IYzX5O5NorWjbKb+lgTp3pcBQ52doAFU=
af63a089-a924-449b-9ebe-dc91fa2449fb	6380f6f0-eb21-46f7-af9e-fbb42dc545f7	secret	35cVqISzhYOpgHeg4YeFDg
43fb94eb-7812-457a-bdac-2e0ca1adac2d	6380f6f0-eb21-46f7-af9e-fbb42dc545f7	priority	100
e6a29323-d9fc-4893-89e7-6fb47df23548	6380f6f0-eb21-46f7-af9e-fbb42dc545f7	kid	7dda4f9e-56b8-4a0e-aba2-a8bbfabe6bce
3fb7f311-c6cd-47ba-ad2f-e14a711ba459	868a3a96-60cf-4f8e-b360-ee1e829d34d4	kid	27e82a09-bc8d-46f8-97dd-e7f5f7a3b105
2c9e6abf-0bf4-4d42-93e1-aadac08af550	868a3a96-60cf-4f8e-b360-ee1e829d34d4	secret	wRiZI8Mpud7hGtvXMsmDbqM8FUXDmDyTlkpDHXoAvZ8anFVwyUsj3Kjdqxrf3ZELKBCfmxC5fbjR1-JPALifpw
5be4f49d-c91d-41d0-aac7-25994520d9b8	868a3a96-60cf-4f8e-b360-ee1e829d34d4	priority	100
6425a89b-1a60-4a05-a997-5993456fefc9	868a3a96-60cf-4f8e-b360-ee1e829d34d4	algorithm	HS256
29c432d9-82ba-429f-af61-40b252c07cd6	5b8f7084-5973-4965-a939-108051f75940	keyUse	ENC
cb5ac405-2bbb-4a82-9d11-a8b57f410fb7	5b8f7084-5973-4965-a939-108051f75940	certificate	MIICqzCCAZMCBgGIEiNqJDANBgkqhkiG9w0BAQsFADAZMRcwFQYDVQQDDA5yZWFsLXdvcmxkLWFwcDAeFw0yMzA1MTIyMjQzMTBaFw0zMzA1MTIyMjQ0NTBaMBkxFzAVBgNVBAMMDnJlYWwtd29ybGQtYXBwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzVFkcyp1r6jLg88UWbQu/LzOrpO9DSiFks8Yh7LxFM4gx1a1tW3bI/UExzv/dcQj6Zzb6cDLYId+QpCCV+ZqtuHDTvywFGdZbigdeqTj+3Fs2fh0yburMZ/wBQQuEqSHaDaj+5akFlOrgdQuZB2PqCavI/6ofc1xUI/aQxpV58LrP8M02CsFzy/O9JM7YM5uZIu99Ch+p/9taK83UlasOG604R/o4qM1oudd+FHjPHZB2a7ZZUAveIXizyXPv2sCBwYxqdJYIR+k7Eesnq8Ir5bumwUg47T+d8/LbcRGHX6jOYeOtJUjmT1nn2feKoTLwa1zmSDmApX7sSk0qE0oLwIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQCEHuNsJg+L5qJCJowKKK/3S/dd2rcI2VP+Cz8rWYtqnL4vIQmTdVXjpRg+JGmxkRCg9pisDebxu8RGOvE6S/1kOgngU8hkL6eeprw9cSReED02VC6GsfgQCDUoTcRonzig7vUiJKqn0tnNz8yqi4vmvZJYFk9pkdGErhNGyWE6fFM+AGqxDtQ04zDTegJeoYHS5Ci/gFZFrcTbFgrt/rpWSUSSrr1Vf79qZ04l0RZG9ARu/DjLH5FdhTMTNr1SDSmy9maFW5YAdT83t6bgvUmorhyJWHNg+9iKdSmOo80xOHrD8PRS8aoDkzBBKFEPtgo0jrdIAMizZQKd61Q6CGUN
d9c217f5-ef6f-4abb-8263-3173c9620bdc	5b8f7084-5973-4965-a939-108051f75940	algorithm	RSA-OAEP
b0344578-fd26-4850-8c6a-70fed65a1727	5b8f7084-5973-4965-a939-108051f75940	priority	100
5f5b2566-6e7a-4f84-9f63-5650e8286d13	5b8f7084-5973-4965-a939-108051f75940	privateKey	MIIEpAIBAAKCAQEAzVFkcyp1r6jLg88UWbQu/LzOrpO9DSiFks8Yh7LxFM4gx1a1tW3bI/UExzv/dcQj6Zzb6cDLYId+QpCCV+ZqtuHDTvywFGdZbigdeqTj+3Fs2fh0yburMZ/wBQQuEqSHaDaj+5akFlOrgdQuZB2PqCavI/6ofc1xUI/aQxpV58LrP8M02CsFzy/O9JM7YM5uZIu99Ch+p/9taK83UlasOG604R/o4qM1oudd+FHjPHZB2a7ZZUAveIXizyXPv2sCBwYxqdJYIR+k7Eesnq8Ir5bumwUg47T+d8/LbcRGHX6jOYeOtJUjmT1nn2feKoTLwa1zmSDmApX7sSk0qE0oLwIDAQABAoIBACGa53y3amPB65g7VfKzZy1pdHq70P73ru/Z2FioP9qj56w406z1D3UnLreyvkahlS8wxAh9IcyUNg+MZN52PD6Ksn5EevLGp6s8AvcxSI9of+R9TMA9aJvKuG0EbiC8WogCyXxC/8BtGW6P3WKi5AHQXcI1IDwsWsD7ipczwZ5udwDlDrp1hOhQdaPFkGilJk01rfbmBcGHZZfTcBkoxr48KIJErOUvyrZj8ZpTHPxp+/XHHVFrSLVey+N9m9FtsMyoPnHOsL511/ppzDXmrWCxw/14X8FI2OoQ3HNKZyZXfrrJL00DLa9DK3C1/wk0bj3CvT/MevFUl5B1o7cAk6ECgYEA9IBRVg9taCXqXj3HaUAA9jHKSbBmZ2VRX+Ka/Kl8Tq35+47OXvUAbwy1oswOVAkrZDxal3aPwyUUaOYii/AslEl9vgUli8OhwSnAwYgToiNaEjpvwCqSd0Zhz7t46aaUlwhKOqdLW3tnPxcG3QJ9zXidtnGOWRFT5fQ8Oegl9BsCgYEA1vlTZQxrBg3TJ/9d+GtzBwzTU1DusDPzebOvjJ3CJuVc64JO4sKIpzDgXXAOsHbvyPfp7u4yjVctmpFPZbCo4WKw4sbjJr3Aj2VwpQaQYDr8wcsMQ4D02CPMt8lsfgSU9unNrqhTGsLXBEJ3OLwikEJ7or8H77w5P8e/eKaoVX0CgYEA8rAni8/WXgk8f/y8Ybk4+yZizw/8JWdJBW7tPhuRGpvPxSVzrIdtvcyUwhnfowRTALRzi2IQwreccZ707YghB7OGz0VWhktR1GT4QmEqc8a5UdyVLd5T8XZ4AfToyKsjVGLTIzMJNq3fxpy5oEgnzPqLORuwGrJ7X4Y0/Zlzir8CgYEAmWohO7HbBt0C3j5+H3T/B/79KS5OyOyqSyYSl/VVw1BYObIq/eT6hOZ6l/QKZ6DZisBx8BOJfBjE8NPWp6mlPAOkXJK3NMSiETPBaeP/UM2H5/0x6VK0aTNTO63BgUVf0b4VDRoPBMAblmygjJqmx/DKLuDJlyrqaDvyxvWYmDkCgYATNO4KDdMNdpk6ZwqA8Kv4WZptzDdaXhFTzOQP0HGB9lQCXpN+TZ7hZ1i/0PfIMC7+ZNLPmMR0ti2fck3vJU+DsV6U0tJU99i5j99yKIaOJjYO/Z1x5D2byElsVozKku19n7H4O2fwOpUj8bzIX94BGB08wgMapRsuLczo4iqxbg==
3235c9f8-007d-4e4d-ba67-9be0998adc61	7d3527ca-1654-4a02-89c0-44bbfbcfa38b	client-uris-must-match	true
c1797acc-da90-439f-8778-f9b28e8921d1	7d3527ca-1654-4a02-89c0-44bbfbcfa38b	host-sending-registration-request-must-match	true
1ee16e9d-9fb5-482f-871e-adc19172d1ce	3384066b-f599-451c-8636-e977e5951f04	max-clients	200
0585c548-3fff-4d13-8cff-5c395cec0000	9562964e-ccae-4680-b6ac-5eec1542c340	allow-default-scopes	true
cbeb575c-9b71-44df-8e1e-03cae67f4f18	87e2fafe-7e81-42d4-8c78-2d3ff4fcf32b	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
8ae31fe5-6651-44f6-b7f1-230cfc5390a9	87e2fafe-7e81-42d4-8c78-2d3ff4fcf32b	allowed-protocol-mapper-types	saml-user-property-mapper
dad630d9-5afc-4c44-8a4c-55d6623da259	87e2fafe-7e81-42d4-8c78-2d3ff4fcf32b	allowed-protocol-mapper-types	saml-user-attribute-mapper
0a971b7e-2618-4413-ab11-3f47a8791936	87e2fafe-7e81-42d4-8c78-2d3ff4fcf32b	allowed-protocol-mapper-types	oidc-address-mapper
2e387cb7-c79b-40a3-a71a-ddb3f792e9d4	87e2fafe-7e81-42d4-8c78-2d3ff4fcf32b	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
c4dcdd3d-9d53-4211-a77a-6e6aff15313d	87e2fafe-7e81-42d4-8c78-2d3ff4fcf32b	allowed-protocol-mapper-types	oidc-full-name-mapper
d598bef8-43a7-4b16-8590-e4fd082289ee	87e2fafe-7e81-42d4-8c78-2d3ff4fcf32b	allowed-protocol-mapper-types	saml-role-list-mapper
2c741fe6-29c4-4e70-846f-1b18493cc368	87e2fafe-7e81-42d4-8c78-2d3ff4fcf32b	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
efbfcb23-415b-4ee1-aed8-b4bc0f86d0dd	4edb46df-05fe-4f24-8a5a-ea5523ebf1f6	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
5eecb2d0-43dd-42c6-bd34-2d9290ab3ad1	4edb46df-05fe-4f24-8a5a-ea5523ebf1f6	allowed-protocol-mapper-types	saml-user-attribute-mapper
a860f6d8-781b-4da7-a849-6f05eac65a9b	4edb46df-05fe-4f24-8a5a-ea5523ebf1f6	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
8cba5d63-3eb6-41f6-a5ec-0ee858f40840	4edb46df-05fe-4f24-8a5a-ea5523ebf1f6	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
2178cf6a-b8dd-4b72-9c22-3b4c546a0260	4edb46df-05fe-4f24-8a5a-ea5523ebf1f6	allowed-protocol-mapper-types	saml-user-property-mapper
5edbbdae-53f5-441b-9f90-0213187a0adc	4edb46df-05fe-4f24-8a5a-ea5523ebf1f6	allowed-protocol-mapper-types	saml-role-list-mapper
ae378174-50bd-42ef-a5b1-3e6c8caf749c	4edb46df-05fe-4f24-8a5a-ea5523ebf1f6	allowed-protocol-mapper-types	oidc-full-name-mapper
fea5909e-f7c9-420a-889c-60bd55d45cec	4edb46df-05fe-4f24-8a5a-ea5523ebf1f6	allowed-protocol-mapper-types	oidc-address-mapper
f0b8e209-feee-4004-881e-5eee240ca1c7	b22e1c1f-2972-473c-b818-1ede882f9381	allow-default-scopes	true
\.


--
-- TOC entry 4115 (class 0 OID 16417)
-- Dependencies: 214
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.composite_role (composite, child_role) FROM stdin;
9cb470e7-2706-460c-b1b7-b60b8e170fba	9191f779-5205-4d56-b6a1-774ec505d858
9cb470e7-2706-460c-b1b7-b60b8e170fba	dc71dc83-9bbb-4a81-a091-ed3d660d9d29
9cb470e7-2706-460c-b1b7-b60b8e170fba	131cc44a-f770-445b-a9c9-e54c7711d154
9cb470e7-2706-460c-b1b7-b60b8e170fba	4c1ba17f-ffa3-4c06-a5d6-da0dd11b63db
9cb470e7-2706-460c-b1b7-b60b8e170fba	3b92950b-44b5-4eae-8324-7fb9af45f172
9cb470e7-2706-460c-b1b7-b60b8e170fba	e1fb4c04-343b-491e-9c10-cd1aee18574c
9cb470e7-2706-460c-b1b7-b60b8e170fba	dcc16ae9-0a9c-413d-8665-ae255190a165
9cb470e7-2706-460c-b1b7-b60b8e170fba	9a98af5e-2f94-446a-94a6-c86e8f46742c
9cb470e7-2706-460c-b1b7-b60b8e170fba	b56dac6f-1724-4509-9ce9-40e2a9886b0c
9cb470e7-2706-460c-b1b7-b60b8e170fba	0de7fe90-8193-44ea-95ec-3b8851142793
9cb470e7-2706-460c-b1b7-b60b8e170fba	f2ef2e59-8c37-4a2b-893c-0a3f3378d9f4
9cb470e7-2706-460c-b1b7-b60b8e170fba	597fd5d8-e13c-4ee9-a65c-9a8591717923
9cb470e7-2706-460c-b1b7-b60b8e170fba	0ce2556e-6930-4244-8751-e37c11f0b59f
9cb470e7-2706-460c-b1b7-b60b8e170fba	14d08cbe-b087-4114-adef-1a3ef21b7e8e
9cb470e7-2706-460c-b1b7-b60b8e170fba	1068ba7c-dd18-4db4-bb4e-b10ef7db306b
9cb470e7-2706-460c-b1b7-b60b8e170fba	f5f69012-b57d-48ed-af92-f50b5dacb700
9cb470e7-2706-460c-b1b7-b60b8e170fba	824e8a8a-989b-49f9-b716-317b40d736a3
9cb470e7-2706-460c-b1b7-b60b8e170fba	f145231e-e150-4193-b759-b27e7b7d2579
3b92950b-44b5-4eae-8324-7fb9af45f172	f5f69012-b57d-48ed-af92-f50b5dacb700
4c1ba17f-ffa3-4c06-a5d6-da0dd11b63db	1068ba7c-dd18-4db4-bb4e-b10ef7db306b
4c1ba17f-ffa3-4c06-a5d6-da0dd11b63db	f145231e-e150-4193-b759-b27e7b7d2579
e8a5ef62-6c4c-4cf7-a11c-71e484133443	41f2f249-275e-432c-a13b-02974f020bc6
e8a5ef62-6c4c-4cf7-a11c-71e484133443	4d1611fa-5810-42d4-bf7b-009cee8a192f
4d1611fa-5810-42d4-bf7b-009cee8a192f	a7fd0f33-e65b-400b-be29-0718a37a14f2
c81a0965-2804-4b53-b033-a4a88e587ddb	764edc32-7120-412c-b272-8f1425d5d0e7
9cb470e7-2706-460c-b1b7-b60b8e170fba	1dbded9f-f976-46d8-bf64-4dbc8cec6afa
e8a5ef62-6c4c-4cf7-a11c-71e484133443	5059447d-75b6-499c-ba70-08138fb8f37d
e8a5ef62-6c4c-4cf7-a11c-71e484133443	24a720f1-ef7a-407d-8583-8cd1ad333f5f
9cb470e7-2706-460c-b1b7-b60b8e170fba	89a0f289-ff17-496e-813c-7ac0097a2ef2
9cb470e7-2706-460c-b1b7-b60b8e170fba	6dc7eefd-9c56-40d0-b8ad-520ce76bf010
9cb470e7-2706-460c-b1b7-b60b8e170fba	e41552a7-cf99-45f3-a053-2a16cf083e88
9cb470e7-2706-460c-b1b7-b60b8e170fba	76ce711b-5764-4ffb-b7ff-896ff85af8bc
9cb470e7-2706-460c-b1b7-b60b8e170fba	792413b1-9188-459a-a4a5-eedae9f1e4d2
9cb470e7-2706-460c-b1b7-b60b8e170fba	e760d71d-f632-45a1-8490-6dcc0ac67511
9cb470e7-2706-460c-b1b7-b60b8e170fba	b6d240a1-6cd3-4016-8943-13421b2f8746
9cb470e7-2706-460c-b1b7-b60b8e170fba	c519bd29-2cfa-406f-b46c-c0f6ac9c1d3e
9cb470e7-2706-460c-b1b7-b60b8e170fba	7fe5e3ee-51cb-4129-8371-24da78fa922c
9cb470e7-2706-460c-b1b7-b60b8e170fba	d027811f-f938-4db1-82e7-392a5d8e8a31
9cb470e7-2706-460c-b1b7-b60b8e170fba	f7cc317d-542f-4f38-8ae7-0a636a3f35db
9cb470e7-2706-460c-b1b7-b60b8e170fba	9233d892-4571-4fc7-b7a0-25451c6d88e8
9cb470e7-2706-460c-b1b7-b60b8e170fba	b5bb9089-defb-4c85-afe1-5e2981e2a369
9cb470e7-2706-460c-b1b7-b60b8e170fba	1058784d-c068-4c02-872d-182f98c7b4be
9cb470e7-2706-460c-b1b7-b60b8e170fba	01697a4f-17ab-4dd8-949d-673e7b6a1adc
9cb470e7-2706-460c-b1b7-b60b8e170fba	39ebb929-3969-4a71-b2a5-1f638a76773f
9cb470e7-2706-460c-b1b7-b60b8e170fba	a532d358-365a-48af-8666-a5f50f0ef6f1
76ce711b-5764-4ffb-b7ff-896ff85af8bc	01697a4f-17ab-4dd8-949d-673e7b6a1adc
e41552a7-cf99-45f3-a053-2a16cf083e88	a532d358-365a-48af-8666-a5f50f0ef6f1
e41552a7-cf99-45f3-a053-2a16cf083e88	1058784d-c068-4c02-872d-182f98c7b4be
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	19a77cb0-2c1e-4404-a780-6b55afb1a96e
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	16a4c21f-50d7-4da7-9cfd-c6d6ab76ef48
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	9d462a0f-eac4-4b55-9c0c-75ba453b62f7
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	c009e1da-ed47-4835-90a9-15c3a08e3945
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	1517f065-31db-4279-84c0-3596255eac2b
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	83119909-4dd5-4d29-b873-4060c2d47826
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	444195cc-e801-4774-bcb2-cf298f45677d
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	c8878ee5-afe7-4a69-838d-43da95d56bb8
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	9a885849-69d4-4040-8ada-93eb595fb381
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	35e4cc57-3ae1-4b6d-acea-d4a7cef8366d
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	16cec958-b9d4-45e0-84f8-8079fe37c86e
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	b785a81c-1345-484d-9299-3a4f29934b28
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	221d1026-5348-40f5-b925-f222ed34bdbb
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	2c9ff26f-d20b-41a3-9c3d-282838e88ee7
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	91789467-fbe8-4e19-880f-d6fe0256afbb
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	bf2bbedf-d76c-4fc1-898c-bb966d645e09
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	3f67447b-91e9-4cd2-855d-a8918d55e043
99af801d-8ec3-4f26-a5e3-418b8dac3158	84422bce-ba52-4bb8-b141-f93e32530e23
9d462a0f-eac4-4b55-9c0c-75ba453b62f7	2c9ff26f-d20b-41a3-9c3d-282838e88ee7
9d462a0f-eac4-4b55-9c0c-75ba453b62f7	3f67447b-91e9-4cd2-855d-a8918d55e043
c009e1da-ed47-4835-90a9-15c3a08e3945	91789467-fbe8-4e19-880f-d6fe0256afbb
99af801d-8ec3-4f26-a5e3-418b8dac3158	a1b34942-c9dd-4ccd-85b0-92290aa1be03
a1b34942-c9dd-4ccd-85b0-92290aa1be03	6a861774-b999-465c-b8f5-4423a0f72a4e
c33ad84a-8ed2-4577-b1a7-228c53b49b72	a6db033f-9ad5-4bfc-9eb7-97fcd77ef137
9cb470e7-2706-460c-b1b7-b60b8e170fba	afe7de4b-688c-42d2-b5e9-f149aeef112c
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	e1beec51-8c9d-4d88-8a1b-59eec75a89d5
99af801d-8ec3-4f26-a5e3-418b8dac3158	9bb90c60-fd0a-45b2-b886-05607fc1fcdb
99af801d-8ec3-4f26-a5e3-418b8dac3158	103d69e1-b39e-453b-b3d7-69c54c94dd84
\.


--
-- TOC entry 4116 (class 0 OID 16420)
-- Dependencies: 215
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
87f58599-d2ef-4b01-bf84-9c2624ec22e6	\N	password	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7	1683931419143	\N	{"value":"la/gYqtgr1ZjigAC06B15qtGoDoTlVd2iO4ZLeNe0lo=","salt":"n9Qtn2cpbDAXE1aQno4Wmw==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
f1508805-e1b1-4c8c-9fff-c30ec9a39239	\N	password	c9c01faf-4e07-4f9b-973b-1d401c36042c	1683931578558	My password	{"value":"AUbhRzUtvU82FCALACnqfwrl+ep1v+Z2aTf1PDxtZS0=","salt":"hbLA4F8mEnaDe/ELsew5Tw==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
\.


--
-- TOC entry 4111 (class 0 OID 16390)
-- Dependencies: 210
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2023-05-12 22:43:36.763942	1	EXECUTED	8:bda77d94bf90182a1e30c24f1c155ec7	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.16.1	\N	\N	3931416549
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2023-05-12 22:43:36.767841	2	MARK_RAN	8:1ecb330f30986693d1cba9ab579fa219	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.16.1	\N	\N	3931416549
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2023-05-12 22:43:36.788456	3	EXECUTED	8:cb7ace19bc6d959f305605d255d4c843	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.16.1	\N	\N	3931416549
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2023-05-12 22:43:36.790118	4	EXECUTED	8:80230013e961310e6872e871be424a63	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.16.1	\N	\N	3931416549
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2023-05-12 22:43:36.83129	5	EXECUTED	8:67f4c20929126adc0c8e9bf48279d244	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.16.1	\N	\N	3931416549
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2023-05-12 22:43:36.832334	6	MARK_RAN	8:7311018b0b8179ce14628ab412bb6783	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.16.1	\N	\N	3931416549
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2023-05-12 22:43:36.869851	7	EXECUTED	8:037ba1216c3640f8785ee6b8e7c8e3c1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.16.1	\N	\N	3931416549
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2023-05-12 22:43:36.871115	8	MARK_RAN	8:7fe6ffe4af4df289b3157de32c624263	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.16.1	\N	\N	3931416549
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2023-05-12 22:43:36.874009	9	EXECUTED	8:9c136bc3187083a98745c7d03bc8a303	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.16.1	\N	\N	3931416549
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2023-05-12 22:43:36.912488	10	EXECUTED	8:b5f09474dca81fb56a97cf5b6553d331	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.16.1	\N	\N	3931416549
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2023-05-12 22:43:36.933564	11	EXECUTED	8:ca924f31bd2a3b219fdcfe78c82dacf4	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.16.1	\N	\N	3931416549
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2023-05-12 22:43:36.934413	12	MARK_RAN	8:8acad7483e106416bcfa6f3b824a16cd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.16.1	\N	\N	3931416549
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2023-05-12 22:43:36.941357	13	EXECUTED	8:9b1266d17f4f87c78226f5055408fd5e	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.16.1	\N	\N	3931416549
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2023-05-12 22:43:36.949777	14	EXECUTED	8:d80ec4ab6dbfe573550ff72396c7e910	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.16.1	\N	\N	3931416549
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2023-05-12 22:43:36.95088	15	MARK_RAN	8:d86eb172171e7c20b9c849b584d147b2	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.16.1	\N	\N	3931416549
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2023-05-12 22:43:36.951869	16	MARK_RAN	8:5735f46f0fa60689deb0ecdc2a0dea22	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.16.1	\N	\N	3931416549
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2023-05-12 22:43:36.953213	17	EXECUTED	8:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.16.1	\N	\N	3931416549
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2023-05-12 22:43:36.969509	18	EXECUTED	8:5c1a8fd2014ac7fc43b90a700f117b23	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.16.1	\N	\N	3931416549
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2023-05-12 22:43:36.987219	19	EXECUTED	8:1f6c2c2dfc362aff4ed75b3f0ef6b331	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.16.1	\N	\N	3931416549
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2023-05-12 22:43:36.989332	20	EXECUTED	8:dee9246280915712591f83a127665107	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.16.1	\N	\N	3931416549
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2023-05-12 22:43:36.989866	21	MARK_RAN	8:9eb2ee1fa8ad1c5e426421a6f8fdfa6a	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.16.1	\N	\N	3931416549
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2023-05-12 22:43:36.991053	22	MARK_RAN	8:dee9246280915712591f83a127665107	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.16.1	\N	\N	3931416549
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2023-05-12 22:43:37.000396	23	EXECUTED	8:d9fa18ffa355320395b86270680dd4fe	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.16.1	\N	\N	3931416549
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2023-05-12 22:43:37.002629	24	EXECUTED	8:90cff506fedb06141ffc1c71c4a1214c	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.16.1	\N	\N	3931416549
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2023-05-12 22:43:37.003248	25	MARK_RAN	8:11a788aed4961d6d29c427c063af828c	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.16.1	\N	\N	3931416549
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2023-05-12 22:43:37.01629	26	EXECUTED	8:a4218e51e1faf380518cce2af5d39b43	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.16.1	\N	\N	3931416549
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2023-05-12 22:43:37.045511	27	EXECUTED	8:d9e9a1bfaa644da9952456050f07bbdc	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.16.1	\N	\N	3931416549
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2023-05-12 22:43:37.046945	28	EXECUTED	8:d1bf991a6163c0acbfe664b615314505	update tableName=RESOURCE_SERVER_POLICY		\N	4.16.1	\N	\N	3931416549
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2023-05-12 22:43:37.070302	29	EXECUTED	8:88a743a1e87ec5e30bf603da68058a8c	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.16.1	\N	\N	3931416549
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2023-05-12 22:43:37.076378	30	EXECUTED	8:c5517863c875d325dea463d00ec26d7a	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.16.1	\N	\N	3931416549
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2023-05-12 22:43:37.083218	31	EXECUTED	8:ada8b4833b74a498f376d7136bc7d327	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.16.1	\N	\N	3931416549
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2023-05-12 22:43:37.085149	32	EXECUTED	8:b9b73c8ea7299457f99fcbb825c263ba	customChange		\N	4.16.1	\N	\N	3931416549
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2023-05-12 22:43:37.087206	33	EXECUTED	8:07724333e625ccfcfc5adc63d57314f3	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.16.1	\N	\N	3931416549
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2023-05-12 22:43:37.087664	34	MARK_RAN	8:8b6fd445958882efe55deb26fc541a7b	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.16.1	\N	\N	3931416549
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2023-05-12 22:43:37.09931	35	EXECUTED	8:29b29cfebfd12600897680147277a9d7	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.16.1	\N	\N	3931416549
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2023-05-12 22:43:37.101203	36	EXECUTED	8:73ad77ca8fd0410c7f9f15a471fa52bc	addColumn tableName=REALM		\N	4.16.1	\N	\N	3931416549
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2023-05-12 22:43:37.103706	37	EXECUTED	8:64f27a6fdcad57f6f9153210f2ec1bdb	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.16.1	\N	\N	3931416549
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2023-05-12 22:43:37.105039	38	EXECUTED	8:27180251182e6c31846c2ddab4bc5781	addColumn tableName=FED_USER_CONSENT		\N	4.16.1	\N	\N	3931416549
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2023-05-12 22:43:37.106639	39	EXECUTED	8:d56f201bfcfa7a1413eb3e9bc02978f9	addColumn tableName=IDENTITY_PROVIDER		\N	4.16.1	\N	\N	3931416549
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2023-05-12 22:43:37.107193	40	MARK_RAN	8:91f5522bf6afdc2077dfab57fbd3455c	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.16.1	\N	\N	3931416549
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2023-05-12 22:43:37.107856	41	MARK_RAN	8:0f01b554f256c22caeb7d8aee3a1cdc8	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.16.1	\N	\N	3931416549
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2023-05-12 22:43:37.110236	42	EXECUTED	8:ab91cf9cee415867ade0e2df9651a947	customChange		\N	4.16.1	\N	\N	3931416549
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2023-05-12 22:43:37.154588	43	EXECUTED	8:ceac9b1889e97d602caf373eadb0d4b7	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.16.1	\N	\N	3931416549
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2023-05-12 22:43:37.156275	44	EXECUTED	8:84b986e628fe8f7fd8fd3c275c5259f2	addColumn tableName=USER_ENTITY		\N	4.16.1	\N	\N	3931416549
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2023-05-12 22:43:37.158309	45	EXECUTED	8:a164ae073c56ffdbc98a615493609a52	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.16.1	\N	\N	3931416549
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2023-05-12 22:43:37.161049	46	EXECUTED	8:70a2b4f1f4bd4dbf487114bdb1810e64	customChange		\N	4.16.1	\N	\N	3931416549
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2023-05-12 22:43:37.161663	47	MARK_RAN	8:7be68b71d2f5b94b8df2e824f2860fa2	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.16.1	\N	\N	3931416549
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2023-05-12 22:43:37.175835	48	EXECUTED	8:bab7c631093c3861d6cf6144cd944982	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.16.1	\N	\N	3931416549
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2023-05-12 22:43:37.177693	49	EXECUTED	8:fa809ac11877d74d76fe40869916daad	addColumn tableName=REALM		\N	4.16.1	\N	\N	3931416549
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2023-05-12 22:43:37.194206	50	EXECUTED	8:fac23540a40208f5f5e326f6ceb4d291	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.16.1	\N	\N	3931416549
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2023-05-12 22:43:37.205011	51	EXECUTED	8:2612d1b8a97e2b5588c346e817307593	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.16.1	\N	\N	3931416549
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2023-05-12 22:43:37.206215	52	EXECUTED	8:9842f155c5db2206c88bcb5d1046e941	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.16.1	\N	\N	3931416549
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2023-05-12 22:43:37.207499	53	EXECUTED	8:2e12e06e45498406db72d5b3da5bbc76	update tableName=REALM		\N	4.16.1	\N	\N	3931416549
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2023-05-12 22:43:37.208992	54	EXECUTED	8:33560e7c7989250c40da3abdabdc75a4	update tableName=CLIENT		\N	4.16.1	\N	\N	3931416549
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2023-05-12 22:43:37.211803	55	EXECUTED	8:87a8d8542046817a9107c7eb9cbad1cd	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.16.1	\N	\N	3931416549
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2023-05-12 22:43:37.21373	56	EXECUTED	8:3ea08490a70215ed0088c273d776311e	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.16.1	\N	\N	3931416549
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2023-05-12 22:43:37.221902	57	EXECUTED	8:2d56697c8723d4592ab608ce14b6ed68	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.16.1	\N	\N	3931416549
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2023-05-12 22:43:37.259426	58	EXECUTED	8:3e423e249f6068ea2bbe48bf907f9d86	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.16.1	\N	\N	3931416549
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2023-05-12 22:43:37.269457	59	EXECUTED	8:15cabee5e5df0ff099510a0fc03e4103	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.16.1	\N	\N	3931416549
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2023-05-12 22:43:37.272236	60	EXECUTED	8:4b80200af916ac54d2ffbfc47918ab0e	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.16.1	\N	\N	3931416549
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2023-05-12 22:43:37.275686	61	EXECUTED	8:66564cd5e168045d52252c5027485bbb	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.16.1	\N	\N	3931416549
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2023-05-12 22:43:37.277949	62	EXECUTED	8:1c7064fafb030222be2bd16ccf690f6f	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.16.1	\N	\N	3931416549
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2023-05-12 22:43:37.279064	63	EXECUTED	8:2de18a0dce10cdda5c7e65c9b719b6e5	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.16.1	\N	\N	3931416549
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2023-05-12 22:43:37.280332	64	EXECUTED	8:03e413dd182dcbd5c57e41c34d0ef682	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.16.1	\N	\N	3931416549
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2023-05-12 22:43:37.281642	65	EXECUTED	8:d27b42bb2571c18fbe3fe4e4fb7582a7	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.16.1	\N	\N	3931416549
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2023-05-12 22:43:37.287273	66	EXECUTED	8:698baf84d9fd0027e9192717c2154fb8	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.16.1	\N	\N	3931416549
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2023-05-12 22:43:37.28973	67	EXECUTED	8:ced8822edf0f75ef26eb51582f9a821a	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.16.1	\N	\N	3931416549
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2023-05-12 22:43:37.291428	68	EXECUTED	8:f0abba004cf429e8afc43056df06487d	addColumn tableName=REALM		\N	4.16.1	\N	\N	3931416549
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2023-05-12 22:43:37.295961	69	EXECUTED	8:6662f8b0b611caa359fcf13bf63b4e24	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.16.1	\N	\N	3931416549
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2023-05-12 22:43:37.297927	70	EXECUTED	8:9e6b8009560f684250bdbdf97670d39e	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.16.1	\N	\N	3931416549
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2023-05-12 22:43:37.300213	71	EXECUTED	8:4223f561f3b8dc655846562b57bb502e	addColumn tableName=RESOURCE_SERVER		\N	4.16.1	\N	\N	3931416549
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2023-05-12 22:43:37.302814	72	EXECUTED	8:215a31c398b363ce383a2b301202f29e	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.16.1	\N	\N	3931416549
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2023-05-12 22:43:37.305384	73	EXECUTED	8:83f7a671792ca98b3cbd3a1a34862d3d	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.16.1	\N	\N	3931416549
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2023-05-12 22:43:37.305953	74	MARK_RAN	8:f58ad148698cf30707a6efbdf8061aa7	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.16.1	\N	\N	3931416549
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2023-05-12 22:43:37.31199	75	EXECUTED	8:79e4fd6c6442980e58d52ffc3ee7b19c	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.16.1	\N	\N	3931416549
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2023-05-12 22:43:37.314678	76	EXECUTED	8:87af6a1e6d241ca4b15801d1f86a297d	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.16.1	\N	\N	3931416549
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2023-05-12 22:43:37.316082	77	EXECUTED	8:b44f8d9b7b6ea455305a6d72a200ed15	addColumn tableName=CLIENT		\N	4.16.1	\N	\N	3931416549
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2023-05-12 22:43:37.316675	78	MARK_RAN	8:2d8ed5aaaeffd0cb004c046b4a903ac5	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.16.1	\N	\N	3931416549
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2023-05-12 22:43:37.323998	79	EXECUTED	8:e290c01fcbc275326c511633f6e2acde	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.16.1	\N	\N	3931416549
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2023-05-12 22:43:37.324571	80	MARK_RAN	8:c9db8784c33cea210872ac2d805439f8	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.16.1	\N	\N	3931416549
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2023-05-12 22:43:37.326975	81	EXECUTED	8:95b676ce8fc546a1fcfb4c92fae4add5	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.16.1	\N	\N	3931416549
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2023-05-12 22:43:37.327463	82	MARK_RAN	8:38a6b2a41f5651018b1aca93a41401e5	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.16.1	\N	\N	3931416549
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2023-05-12 22:43:37.329134	83	EXECUTED	8:3fb99bcad86a0229783123ac52f7609c	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.16.1	\N	\N	3931416549
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2023-05-12 22:43:37.329612	84	MARK_RAN	8:64f27a6fdcad57f6f9153210f2ec1bdb	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.16.1	\N	\N	3931416549
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2023-05-12 22:43:37.331784	85	EXECUTED	8:ab4f863f39adafd4c862f7ec01890abc	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.16.1	\N	\N	3931416549
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2023-05-12 22:43:37.333743	86	EXECUTED	8:13c419a0eb336e91ee3a3bf8fda6e2a7	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.16.1	\N	\N	3931416549
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2023-05-12 22:43:37.336234	87	EXECUTED	8:e3fb1e698e0471487f51af1ed80fe3ac	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.16.1	\N	\N	3931416549
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2023-05-12 22:43:37.339454	88	EXECUTED	8:babadb686aab7b56562817e60bf0abd0	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.16.1	\N	\N	3931416549
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-05-12 22:43:37.3417	89	EXECUTED	8:72d03345fda8e2f17093d08801947773	addColumn tableName=REALM; customChange		\N	4.16.1	\N	\N	3931416549
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-05-12 22:43:37.344103	90	EXECUTED	8:61c9233951bd96ffecd9ba75f7d978a4	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.16.1	\N	\N	3931416549
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-05-12 22:43:37.34629	91	EXECUTED	8:ea82e6ad945cec250af6372767b25525	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.16.1	\N	\N	3931416549
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-05-12 22:43:37.348786	92	EXECUTED	8:d3f4a33f41d960ddacd7e2ef30d126b3	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.16.1	\N	\N	3931416549
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-05-12 22:43:37.34928	93	MARK_RAN	8:1284a27fbd049d65831cb6fc07c8a783	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.16.1	\N	\N	3931416549
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-05-12 22:43:37.352412	94	EXECUTED	8:9d11b619db2ae27c25853b8a37cd0dea	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.16.1	\N	\N	3931416549
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-05-12 22:43:37.352873	95	MARK_RAN	8:3002bb3997451bb9e8bac5c5cd8d6327	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.16.1	\N	\N	3931416549
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-05-12 22:43:37.354757	96	EXECUTED	8:dfbee0d6237a23ef4ccbb7a4e063c163	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.16.1	\N	\N	3931416549
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-05-12 22:43:37.35896	97	EXECUTED	8:75f3e372df18d38c62734eebb986b960	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.16.1	\N	\N	3931416549
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-05-12 22:43:37.359573	98	MARK_RAN	8:7fee73eddf84a6035691512c85637eef	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.16.1	\N	\N	3931416549
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-05-12 22:43:37.365381	99	MARK_RAN	8:7a11134ab12820f999fbf3bb13c3adc8	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.16.1	\N	\N	3931416549
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-05-12 22:43:37.368552	100	EXECUTED	8:c0f6eaac1f3be773ffe54cb5b8482b70	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.16.1	\N	\N	3931416549
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-05-12 22:43:37.369232	101	MARK_RAN	8:18186f0008b86e0f0f49b0c4d0e842ac	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.16.1	\N	\N	3931416549
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-05-12 22:43:37.371391	102	EXECUTED	8:09c2780bcb23b310a7019d217dc7b433	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.16.1	\N	\N	3931416549
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-05-12 22:43:37.373602	103	EXECUTED	8:276a44955eab693c970a42880197fff2	customChange		\N	4.16.1	\N	\N	3931416549
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2023-05-12 22:43:37.37565	104	EXECUTED	8:ba8ee3b694d043f2bfc1a1079d0760d7	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.16.1	\N	\N	3931416549
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2023-05-12 22:43:37.377655	105	EXECUTED	8:5e06b1d75f5d17685485e610c2851b17	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.16.1	\N	\N	3931416549
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2023-05-12 22:43:37.3795	106	EXECUTED	8:4b80546c1dc550ac552ee7b24a4ab7c0	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.16.1	\N	\N	3931416549
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2023-05-12 22:43:37.38131	107	EXECUTED	8:af510cd1bb2ab6339c45372f3e491696	customChange		\N	4.16.1	\N	\N	3931416549
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2023-05-12 22:43:37.38371	108	EXECUTED	8:05c99fc610845ef66ee812b7921af0ef	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.16.1	\N	\N	3931416549
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2023-05-12 22:43:37.384263	109	MARK_RAN	8:314e803baf2f1ec315b3464e398b8247	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.16.1	\N	\N	3931416549
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2023-05-12 22:43:37.386319	110	EXECUTED	8:56e4677e7e12556f70b604c573840100	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.16.1	\N	\N	3931416549
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2023-05-12 22:43:37.388166	111	EXECUTED	8:8806cb33d2a546ce770384bf98cf6eac	customChange		\N	4.16.1	\N	\N	3931416549
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2023-05-12 22:43:37.397879	112	EXECUTED	8:fdb2924649d30555ab3a1744faba4928	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.16.1	\N	\N	3931416549
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2023-05-12 22:43:37.398479	113	MARK_RAN	8:1c96cc2b10903bd07a03670098d67fd6	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.16.1	\N	\N	3931416549
\.


--
-- TOC entry 4110 (class 0 OID 16385)
-- Dependencies: 209
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- TOC entry 4194 (class 0 OID 17781)
-- Dependencies: 293
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
d197e81d-3fcf-427b-b55c-debfeffaf415	782144e9-3a93-4ad6-95c8-0d317b729d25	f
d197e81d-3fcf-427b-b55c-debfeffaf415	72f403ae-4c6a-47b6-b4b3-cd5956c05b3c	t
d197e81d-3fcf-427b-b55c-debfeffaf415	7d9681ef-40c4-47ba-8a7f-c225e60a925b	t
d197e81d-3fcf-427b-b55c-debfeffaf415	6e8353ed-3602-4a78-870d-16e002041a74	t
d197e81d-3fcf-427b-b55c-debfeffaf415	17b761f7-226b-4a43-872c-097eae7c56fe	f
d197e81d-3fcf-427b-b55c-debfeffaf415	a46100a6-bdb2-4b05-8328-fd80a3e58090	f
d197e81d-3fcf-427b-b55c-debfeffaf415	0504ac26-2417-45cc-a9a7-5c0403af90f4	t
d197e81d-3fcf-427b-b55c-debfeffaf415	3cde377e-53bc-4520-9d72-e53c5272322f	t
d197e81d-3fcf-427b-b55c-debfeffaf415	9504ba54-710b-487f-8d1e-6d59446bbab2	f
d197e81d-3fcf-427b-b55c-debfeffaf415	2f95d32d-7b8d-488c-b72a-d8bc5f69cdcc	t
58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	447281fd-c5a3-4b3d-96ff-c75c8ad10cd5	f
58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	520f9c35-9829-43c3-8b0b-23f1006e06fb	t
58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	8251313f-9ef8-4197-a185-8c8e6b81eb34	t
58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	bf31f266-48b5-4a6f-894d-eb9b886e40eb	t
58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	4920ee39-71f1-462a-afc9-7d0384a0cfc7	f
58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	8a9c97d2-7b14-4408-bd78-fd2714d59789	f
58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	a5cea84b-99e3-4014-8d7e-459ab67befd9	t
58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	76ebb562-2a74-422a-b418-06680bf03b4c	t
58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	539c2a3b-6d11-4a41-9632-4dfd9cc2af9b	f
58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f1f7c32c-b1e8-4bcf-ae2e-d6f2d3d77085	t
\.


--
-- TOC entry 4117 (class 0 OID 16425)
-- Dependencies: 216
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id) FROM stdin;
\.


--
-- TOC entry 4182 (class 0 OID 17480)
-- Dependencies: 281
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- TOC entry 4183 (class 0 OID 17485)
-- Dependencies: 282
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- TOC entry 4196 (class 0 OID 17807)
-- Dependencies: 295
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- TOC entry 4184 (class 0 OID 17494)
-- Dependencies: 283
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- TOC entry 4185 (class 0 OID 17503)
-- Dependencies: 284
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- TOC entry 4186 (class 0 OID 17506)
-- Dependencies: 285
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- TOC entry 4187 (class 0 OID 17512)
-- Dependencies: 286
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- TOC entry 4140 (class 0 OID 16802)
-- Dependencies: 239
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- TOC entry 4190 (class 0 OID 17577)
-- Dependencies: 289
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- TOC entry 4166 (class 0 OID 17204)
-- Dependencies: 265
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- TOC entry 4165 (class 0 OID 17201)
-- Dependencies: 264
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- TOC entry 4141 (class 0 OID 16807)
-- Dependencies: 240
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- TOC entry 4142 (class 0 OID 16816)
-- Dependencies: 241
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- TOC entry 4147 (class 0 OID 16920)
-- Dependencies: 246
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- TOC entry 4148 (class 0 OID 16925)
-- Dependencies: 247
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- TOC entry 4164 (class 0 OID 17198)
-- Dependencies: 263
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
\.


--
-- TOC entry 4118 (class 0 OID 16433)
-- Dependencies: 217
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
e8a5ef62-6c4c-4cf7-a11c-71e484133443	d197e81d-3fcf-427b-b55c-debfeffaf415	f	${role_default-roles}	default-roles-master	d197e81d-3fcf-427b-b55c-debfeffaf415	\N	\N
9191f779-5205-4d56-b6a1-774ec505d858	d197e81d-3fcf-427b-b55c-debfeffaf415	f	${role_create-realm}	create-realm	d197e81d-3fcf-427b-b55c-debfeffaf415	\N	\N
dc71dc83-9bbb-4a81-a091-ed3d660d9d29	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_create-client}	create-client	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
131cc44a-f770-445b-a9c9-e54c7711d154	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_view-realm}	view-realm	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
4c1ba17f-ffa3-4c06-a5d6-da0dd11b63db	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_view-users}	view-users	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
3b92950b-44b5-4eae-8324-7fb9af45f172	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_view-clients}	view-clients	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
e1fb4c04-343b-491e-9c10-cd1aee18574c	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_view-events}	view-events	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
dcc16ae9-0a9c-413d-8665-ae255190a165	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_view-identity-providers}	view-identity-providers	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
9a98af5e-2f94-446a-94a6-c86e8f46742c	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_view-authorization}	view-authorization	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
b56dac6f-1724-4509-9ce9-40e2a9886b0c	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_manage-realm}	manage-realm	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
0de7fe90-8193-44ea-95ec-3b8851142793	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_manage-users}	manage-users	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
f2ef2e59-8c37-4a2b-893c-0a3f3378d9f4	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_manage-clients}	manage-clients	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
597fd5d8-e13c-4ee9-a65c-9a8591717923	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_manage-events}	manage-events	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
0ce2556e-6930-4244-8751-e37c11f0b59f	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_manage-identity-providers}	manage-identity-providers	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
14d08cbe-b087-4114-adef-1a3ef21b7e8e	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_manage-authorization}	manage-authorization	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
1068ba7c-dd18-4db4-bb4e-b10ef7db306b	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_query-users}	query-users	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
f5f69012-b57d-48ed-af92-f50b5dacb700	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_query-clients}	query-clients	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
824e8a8a-989b-49f9-b716-317b40d736a3	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_query-realms}	query-realms	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
9cb470e7-2706-460c-b1b7-b60b8e170fba	d197e81d-3fcf-427b-b55c-debfeffaf415	f	${role_admin}	admin	d197e81d-3fcf-427b-b55c-debfeffaf415	\N	\N
f145231e-e150-4193-b759-b27e7b7d2579	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_query-groups}	query-groups	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
41f2f249-275e-432c-a13b-02974f020bc6	f524cc57-d961-49af-9920-6608babb1039	t	${role_view-profile}	view-profile	d197e81d-3fcf-427b-b55c-debfeffaf415	f524cc57-d961-49af-9920-6608babb1039	\N
4d1611fa-5810-42d4-bf7b-009cee8a192f	f524cc57-d961-49af-9920-6608babb1039	t	${role_manage-account}	manage-account	d197e81d-3fcf-427b-b55c-debfeffaf415	f524cc57-d961-49af-9920-6608babb1039	\N
a7fd0f33-e65b-400b-be29-0718a37a14f2	f524cc57-d961-49af-9920-6608babb1039	t	${role_manage-account-links}	manage-account-links	d197e81d-3fcf-427b-b55c-debfeffaf415	f524cc57-d961-49af-9920-6608babb1039	\N
cd0c2b35-5f7d-457f-bdb1-c0d405fe8577	f524cc57-d961-49af-9920-6608babb1039	t	${role_view-applications}	view-applications	d197e81d-3fcf-427b-b55c-debfeffaf415	f524cc57-d961-49af-9920-6608babb1039	\N
764edc32-7120-412c-b272-8f1425d5d0e7	f524cc57-d961-49af-9920-6608babb1039	t	${role_view-consent}	view-consent	d197e81d-3fcf-427b-b55c-debfeffaf415	f524cc57-d961-49af-9920-6608babb1039	\N
c81a0965-2804-4b53-b033-a4a88e587ddb	f524cc57-d961-49af-9920-6608babb1039	t	${role_manage-consent}	manage-consent	d197e81d-3fcf-427b-b55c-debfeffaf415	f524cc57-d961-49af-9920-6608babb1039	\N
13e2d70f-c893-4fc1-a534-a8b44b9252a4	f524cc57-d961-49af-9920-6608babb1039	t	${role_view-groups}	view-groups	d197e81d-3fcf-427b-b55c-debfeffaf415	f524cc57-d961-49af-9920-6608babb1039	\N
b71ebc8e-ccb6-4ce5-8bfa-9811e12de617	f524cc57-d961-49af-9920-6608babb1039	t	${role_delete-account}	delete-account	d197e81d-3fcf-427b-b55c-debfeffaf415	f524cc57-d961-49af-9920-6608babb1039	\N
68c9e533-3e35-499b-bfc7-22634bee6954	55e44de1-5e89-4152-8e28-ef88eef16d50	t	${role_read-token}	read-token	d197e81d-3fcf-427b-b55c-debfeffaf415	55e44de1-5e89-4152-8e28-ef88eef16d50	\N
1dbded9f-f976-46d8-bf64-4dbc8cec6afa	448c4db4-c6fa-45be-af4c-629ec0847ab9	t	${role_impersonation}	impersonation	d197e81d-3fcf-427b-b55c-debfeffaf415	448c4db4-c6fa-45be-af4c-629ec0847ab9	\N
5059447d-75b6-499c-ba70-08138fb8f37d	d197e81d-3fcf-427b-b55c-debfeffaf415	f	${role_offline-access}	offline_access	d197e81d-3fcf-427b-b55c-debfeffaf415	\N	\N
24a720f1-ef7a-407d-8583-8cd1ad333f5f	d197e81d-3fcf-427b-b55c-debfeffaf415	f	${role_uma_authorization}	uma_authorization	d197e81d-3fcf-427b-b55c-debfeffaf415	\N	\N
99af801d-8ec3-4f26-a5e3-418b8dac3158	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f	${role_default-roles}	default-roles-real-world-app	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	\N	\N
89a0f289-ff17-496e-813c-7ac0097a2ef2	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_create-client}	create-client	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
6dc7eefd-9c56-40d0-b8ad-520ce76bf010	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_view-realm}	view-realm	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
e41552a7-cf99-45f3-a053-2a16cf083e88	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_view-users}	view-users	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
76ce711b-5764-4ffb-b7ff-896ff85af8bc	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_view-clients}	view-clients	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
792413b1-9188-459a-a4a5-eedae9f1e4d2	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_view-events}	view-events	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
e760d71d-f632-45a1-8490-6dcc0ac67511	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_view-identity-providers}	view-identity-providers	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
b6d240a1-6cd3-4016-8943-13421b2f8746	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_view-authorization}	view-authorization	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
c519bd29-2cfa-406f-b46c-c0f6ac9c1d3e	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_manage-realm}	manage-realm	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
7fe5e3ee-51cb-4129-8371-24da78fa922c	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_manage-users}	manage-users	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
d027811f-f938-4db1-82e7-392a5d8e8a31	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_manage-clients}	manage-clients	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
f7cc317d-542f-4f38-8ae7-0a636a3f35db	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_manage-events}	manage-events	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
9233d892-4571-4fc7-b7a0-25451c6d88e8	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_manage-identity-providers}	manage-identity-providers	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
b5bb9089-defb-4c85-afe1-5e2981e2a369	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_manage-authorization}	manage-authorization	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
1058784d-c068-4c02-872d-182f98c7b4be	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_query-users}	query-users	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
01697a4f-17ab-4dd8-949d-673e7b6a1adc	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_query-clients}	query-clients	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
39ebb929-3969-4a71-b2a5-1f638a76773f	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_query-realms}	query-realms	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
a532d358-365a-48af-8666-a5f50f0ef6f1	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_query-groups}	query-groups	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
9ddc5d6a-43cf-4dca-b0c6-837cd41d5d56	06926a74-3904-4b43-8f99-759133764249	t	${role_realm-admin}	realm-admin	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
19a77cb0-2c1e-4404-a780-6b55afb1a96e	06926a74-3904-4b43-8f99-759133764249	t	${role_create-client}	create-client	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
16a4c21f-50d7-4da7-9cfd-c6d6ab76ef48	06926a74-3904-4b43-8f99-759133764249	t	${role_view-realm}	view-realm	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
9d462a0f-eac4-4b55-9c0c-75ba453b62f7	06926a74-3904-4b43-8f99-759133764249	t	${role_view-users}	view-users	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
c009e1da-ed47-4835-90a9-15c3a08e3945	06926a74-3904-4b43-8f99-759133764249	t	${role_view-clients}	view-clients	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
1517f065-31db-4279-84c0-3596255eac2b	06926a74-3904-4b43-8f99-759133764249	t	${role_view-events}	view-events	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
83119909-4dd5-4d29-b873-4060c2d47826	06926a74-3904-4b43-8f99-759133764249	t	${role_view-identity-providers}	view-identity-providers	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
444195cc-e801-4774-bcb2-cf298f45677d	06926a74-3904-4b43-8f99-759133764249	t	${role_view-authorization}	view-authorization	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
c8878ee5-afe7-4a69-838d-43da95d56bb8	06926a74-3904-4b43-8f99-759133764249	t	${role_manage-realm}	manage-realm	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
9a885849-69d4-4040-8ada-93eb595fb381	06926a74-3904-4b43-8f99-759133764249	t	${role_manage-users}	manage-users	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
35e4cc57-3ae1-4b6d-acea-d4a7cef8366d	06926a74-3904-4b43-8f99-759133764249	t	${role_manage-clients}	manage-clients	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
16cec958-b9d4-45e0-84f8-8079fe37c86e	06926a74-3904-4b43-8f99-759133764249	t	${role_manage-events}	manage-events	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
b785a81c-1345-484d-9299-3a4f29934b28	06926a74-3904-4b43-8f99-759133764249	t	${role_manage-identity-providers}	manage-identity-providers	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
221d1026-5348-40f5-b925-f222ed34bdbb	06926a74-3904-4b43-8f99-759133764249	t	${role_manage-authorization}	manage-authorization	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
2c9ff26f-d20b-41a3-9c3d-282838e88ee7	06926a74-3904-4b43-8f99-759133764249	t	${role_query-users}	query-users	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
91789467-fbe8-4e19-880f-d6fe0256afbb	06926a74-3904-4b43-8f99-759133764249	t	${role_query-clients}	query-clients	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
bf2bbedf-d76c-4fc1-898c-bb966d645e09	06926a74-3904-4b43-8f99-759133764249	t	${role_query-realms}	query-realms	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
3f67447b-91e9-4cd2-855d-a8918d55e043	06926a74-3904-4b43-8f99-759133764249	t	${role_query-groups}	query-groups	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
84422bce-ba52-4bb8-b141-f93e32530e23	f59bb731-a6bf-4ec4-9773-1daa4e329433	t	${role_view-profile}	view-profile	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f59bb731-a6bf-4ec4-9773-1daa4e329433	\N
a1b34942-c9dd-4ccd-85b0-92290aa1be03	f59bb731-a6bf-4ec4-9773-1daa4e329433	t	${role_manage-account}	manage-account	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f59bb731-a6bf-4ec4-9773-1daa4e329433	\N
6a861774-b999-465c-b8f5-4423a0f72a4e	f59bb731-a6bf-4ec4-9773-1daa4e329433	t	${role_manage-account-links}	manage-account-links	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f59bb731-a6bf-4ec4-9773-1daa4e329433	\N
66fec489-04b0-4d15-bcaa-fdf78fc47f59	f59bb731-a6bf-4ec4-9773-1daa4e329433	t	${role_view-applications}	view-applications	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f59bb731-a6bf-4ec4-9773-1daa4e329433	\N
a6db033f-9ad5-4bfc-9eb7-97fcd77ef137	f59bb731-a6bf-4ec4-9773-1daa4e329433	t	${role_view-consent}	view-consent	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f59bb731-a6bf-4ec4-9773-1daa4e329433	\N
c33ad84a-8ed2-4577-b1a7-228c53b49b72	f59bb731-a6bf-4ec4-9773-1daa4e329433	t	${role_manage-consent}	manage-consent	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f59bb731-a6bf-4ec4-9773-1daa4e329433	\N
f155b700-b3cf-453f-b9ad-9a2677d606d9	f59bb731-a6bf-4ec4-9773-1daa4e329433	t	${role_view-groups}	view-groups	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f59bb731-a6bf-4ec4-9773-1daa4e329433	\N
f2ec705e-30b1-4ba7-8263-ed35fe88421f	f59bb731-a6bf-4ec4-9773-1daa4e329433	t	${role_delete-account}	delete-account	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f59bb731-a6bf-4ec4-9773-1daa4e329433	\N
afe7de4b-688c-42d2-b5e9-f149aeef112c	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	t	${role_impersonation}	impersonation	d197e81d-3fcf-427b-b55c-debfeffaf415	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	\N
e1beec51-8c9d-4d88-8a1b-59eec75a89d5	06926a74-3904-4b43-8f99-759133764249	t	${role_impersonation}	impersonation	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	06926a74-3904-4b43-8f99-759133764249	\N
7a572118-cd8e-4345-9e58-c61f7b19619b	2b499a97-50c0-42a3-8931-eb17ceb4f08b	t	${role_read-token}	read-token	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	2b499a97-50c0-42a3-8931-eb17ceb4f08b	\N
9bb90c60-fd0a-45b2-b886-05607fc1fcdb	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f	${role_offline-access}	offline_access	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	\N	\N
103d69e1-b39e-453b-b3d7-69c54c94dd84	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f	${role_uma_authorization}	uma_authorization	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	\N	\N
\.


--
-- TOC entry 4146 (class 0 OID 16917)
-- Dependencies: 245
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.migration_model (id, version, update_time) FROM stdin;
z2o8q	21.1.1	1683931417
\.


--
-- TOC entry 4163 (class 0 OID 17189)
-- Dependencies: 262
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- TOC entry 4162 (class 0 OID 17184)
-- Dependencies: 261
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- TOC entry 4176 (class 0 OID 17403)
-- Dependencies: 275
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- TOC entry 4138 (class 0 OID 16791)
-- Dependencies: 237
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
c2af93d6-21ce-4e02-9208-c68dc23952ae	audience resolve	openid-connect	oidc-audience-resolve-mapper	e9532515-74ee-40b9-8673-3864fb56b97a	\N
4f0c1653-cd22-4862-b7ed-3db14c5ccfeb	locale	openid-connect	oidc-usermodel-attribute-mapper	0b14429d-4885-412c-b4e2-4486b44d49a2	\N
c7a97222-e485-408d-b474-e05d75b494e2	role list	saml	saml-role-list-mapper	\N	72f403ae-4c6a-47b6-b4b3-cd5956c05b3c
520f0fd2-96b1-4df2-a6b8-e6f72458ede0	full name	openid-connect	oidc-full-name-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
9985c31f-8bfa-42e4-98e2-be5b71201fc8	family name	openid-connect	oidc-usermodel-property-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
161afd39-5e3c-4f48-bc21-02d2c0851aa6	given name	openid-connect	oidc-usermodel-property-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
d9a1a220-f6b1-49f6-8b2f-30bbfb56e38d	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
c61ba0c3-5fa3-45a1-9a87-54e93b7680fe	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
22d4ed7a-567c-4173-aea2-9aa295055a63	username	openid-connect	oidc-usermodel-property-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
73e0b6aa-c13f-4d38-8a7d-a0137685e962	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
c3fcb3ee-0dab-439a-981a-81c1dd3a9073	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
6f2d1c26-66b6-44ea-a5e4-a7d1744af141	website	openid-connect	oidc-usermodel-attribute-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
e6a80531-b99f-488d-8049-b2334b77d0cd	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
50778bfc-28b2-484a-b348-baf59a3d739d	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
464b1221-74a7-4f7d-abb0-195977ce5e14	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
76cdc97e-f042-4c9c-bd72-993c3a692ed9	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
d689b356-611b-4d68-b9f4-554b122ac7fa	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	7d9681ef-40c4-47ba-8a7f-c225e60a925b
d74f7fe2-f2e4-421c-8bbf-385cadb84b22	email	openid-connect	oidc-usermodel-property-mapper	\N	6e8353ed-3602-4a78-870d-16e002041a74
af3f2214-8b3c-4d70-84ad-8eebf2fe2336	email verified	openid-connect	oidc-usermodel-property-mapper	\N	6e8353ed-3602-4a78-870d-16e002041a74
3943d6e9-0cb4-460a-9367-dc04f76f8dd9	address	openid-connect	oidc-address-mapper	\N	17b761f7-226b-4a43-872c-097eae7c56fe
48ebfe7f-1834-429a-97d1-b01b47358460	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	a46100a6-bdb2-4b05-8328-fd80a3e58090
3bd8c731-9e83-47aa-9519-c316f04f3173	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	a46100a6-bdb2-4b05-8328-fd80a3e58090
afa9faf7-a3a1-4c2f-990d-944d97e0dd04	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	0504ac26-2417-45cc-a9a7-5c0403af90f4
eb8a44e5-b560-4e13-ae39-8b2f037d614c	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	0504ac26-2417-45cc-a9a7-5c0403af90f4
d4016a29-4d57-4ecb-b883-d30211d40ca9	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	0504ac26-2417-45cc-a9a7-5c0403af90f4
8ff063c5-3ee0-4135-8272-28e899534a28	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	3cde377e-53bc-4520-9d72-e53c5272322f
9b5ba7ff-f428-4844-bb98-44d6abd709d6	upn	openid-connect	oidc-usermodel-property-mapper	\N	9504ba54-710b-487f-8d1e-6d59446bbab2
cfb98850-4b71-4f01-843a-f9da9633bc3c	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	9504ba54-710b-487f-8d1e-6d59446bbab2
e17f92e4-8262-4da5-8d0f-9dd9ad336202	acr loa level	openid-connect	oidc-acr-mapper	\N	2f95d32d-7b8d-488c-b72a-d8bc5f69cdcc
f645f77e-cb01-48d2-a72f-c4c44326ab9f	audience resolve	openid-connect	oidc-audience-resolve-mapper	ca585f83-a5b3-4169-b40d-bb3784fa5bcf	\N
002f0cdd-3a1f-419d-a650-ea28cb7db187	role list	saml	saml-role-list-mapper	\N	520f9c35-9829-43c3-8b0b-23f1006e06fb
1915f742-873e-43b3-8b74-7f6aac4fd80c	full name	openid-connect	oidc-full-name-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
28d6f592-51f8-4bdc-a9f5-20eb4c9138af	family name	openid-connect	oidc-usermodel-property-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
19792dae-0a66-4d24-aede-cecd3afc45a7	given name	openid-connect	oidc-usermodel-property-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
bcf865d7-c6bf-48c2-bf43-c5e0208df2f7	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
533f2173-84ec-4c3e-969e-a7406677a3b4	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
2adddeaa-991d-48ec-86e3-d725cdc946d0	username	openid-connect	oidc-usermodel-property-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
726094cb-0807-43d6-a5a0-b47e193649fe	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
64b7a9b9-48d7-4c98-9692-cca0335d60e6	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
5cb07873-4f53-4ba2-b58c-ae6e4afe1fd6	website	openid-connect	oidc-usermodel-attribute-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
d43267b9-7569-46f9-9879-aaaaf2f2af75	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
accd09b5-0ac6-4ffd-958c-589f0550e63e	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
254fdd5c-badd-4ab4-9b85-647f2dbe805e	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
2162f6f4-9328-477e-bad8-0059f24427cc	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
03a798d7-1980-41cf-a74e-17073ff96262	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	8251313f-9ef8-4197-a185-8c8e6b81eb34
6bbab890-d242-4299-be40-4a42fd3e6a7d	email	openid-connect	oidc-usermodel-property-mapper	\N	bf31f266-48b5-4a6f-894d-eb9b886e40eb
3b2970e0-38a6-4572-bcf0-8d6c7e9d1a9b	email verified	openid-connect	oidc-usermodel-property-mapper	\N	bf31f266-48b5-4a6f-894d-eb9b886e40eb
6330246b-c624-46b5-ae80-d045c7aacc9a	address	openid-connect	oidc-address-mapper	\N	4920ee39-71f1-462a-afc9-7d0384a0cfc7
0798fde1-e9b0-43ba-9a24-07c1482bcad6	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	8a9c97d2-7b14-4408-bd78-fd2714d59789
a59aa26a-e19c-4c29-9115-fc268f0707e3	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	8a9c97d2-7b14-4408-bd78-fd2714d59789
4ae1ef6f-7649-415c-a6f3-2128ded0c332	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	a5cea84b-99e3-4014-8d7e-459ab67befd9
0616f9ba-0c3f-4eec-9183-4718b8e8d560	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	a5cea84b-99e3-4014-8d7e-459ab67befd9
41fe3072-0543-478e-99e9-acabce36a920	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	a5cea84b-99e3-4014-8d7e-459ab67befd9
4bd8ab67-f59f-4207-a52e-ef6af2054f45	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	76ebb562-2a74-422a-b418-06680bf03b4c
f6a53d34-be9c-4b5f-b513-05308c731ce2	upn	openid-connect	oidc-usermodel-property-mapper	\N	539c2a3b-6d11-4a41-9632-4dfd9cc2af9b
8d737364-773f-4e26-9334-c643f08c9eb1	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	539c2a3b-6d11-4a41-9632-4dfd9cc2af9b
e0ae1e3e-ebd3-42e6-a7c2-eb63bd1c79ac	acr loa level	openid-connect	oidc-acr-mapper	\N	f1f7c32c-b1e8-4bcf-ae2e-d6f2d3d77085
c34c5471-94fa-48b5-abe5-a444856d1a57	locale	openid-connect	oidc-usermodel-attribute-mapper	37e2f933-0a5a-48dd-bf98-a0aa47339ab4	\N
\.


--
-- TOC entry 4139 (class 0 OID 16797)
-- Dependencies: 238
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
4f0c1653-cd22-4862-b7ed-3db14c5ccfeb	true	userinfo.token.claim
4f0c1653-cd22-4862-b7ed-3db14c5ccfeb	locale	user.attribute
4f0c1653-cd22-4862-b7ed-3db14c5ccfeb	true	id.token.claim
4f0c1653-cd22-4862-b7ed-3db14c5ccfeb	true	access.token.claim
4f0c1653-cd22-4862-b7ed-3db14c5ccfeb	locale	claim.name
4f0c1653-cd22-4862-b7ed-3db14c5ccfeb	String	jsonType.label
c7a97222-e485-408d-b474-e05d75b494e2	false	single
c7a97222-e485-408d-b474-e05d75b494e2	Basic	attribute.nameformat
c7a97222-e485-408d-b474-e05d75b494e2	Role	attribute.name
161afd39-5e3c-4f48-bc21-02d2c0851aa6	true	userinfo.token.claim
161afd39-5e3c-4f48-bc21-02d2c0851aa6	firstName	user.attribute
161afd39-5e3c-4f48-bc21-02d2c0851aa6	true	id.token.claim
161afd39-5e3c-4f48-bc21-02d2c0851aa6	true	access.token.claim
161afd39-5e3c-4f48-bc21-02d2c0851aa6	given_name	claim.name
161afd39-5e3c-4f48-bc21-02d2c0851aa6	String	jsonType.label
22d4ed7a-567c-4173-aea2-9aa295055a63	true	userinfo.token.claim
22d4ed7a-567c-4173-aea2-9aa295055a63	username	user.attribute
22d4ed7a-567c-4173-aea2-9aa295055a63	true	id.token.claim
22d4ed7a-567c-4173-aea2-9aa295055a63	true	access.token.claim
22d4ed7a-567c-4173-aea2-9aa295055a63	preferred_username	claim.name
22d4ed7a-567c-4173-aea2-9aa295055a63	String	jsonType.label
464b1221-74a7-4f7d-abb0-195977ce5e14	true	userinfo.token.claim
464b1221-74a7-4f7d-abb0-195977ce5e14	zoneinfo	user.attribute
464b1221-74a7-4f7d-abb0-195977ce5e14	true	id.token.claim
464b1221-74a7-4f7d-abb0-195977ce5e14	true	access.token.claim
464b1221-74a7-4f7d-abb0-195977ce5e14	zoneinfo	claim.name
464b1221-74a7-4f7d-abb0-195977ce5e14	String	jsonType.label
50778bfc-28b2-484a-b348-baf59a3d739d	true	userinfo.token.claim
50778bfc-28b2-484a-b348-baf59a3d739d	birthdate	user.attribute
50778bfc-28b2-484a-b348-baf59a3d739d	true	id.token.claim
50778bfc-28b2-484a-b348-baf59a3d739d	true	access.token.claim
50778bfc-28b2-484a-b348-baf59a3d739d	birthdate	claim.name
50778bfc-28b2-484a-b348-baf59a3d739d	String	jsonType.label
520f0fd2-96b1-4df2-a6b8-e6f72458ede0	true	userinfo.token.claim
520f0fd2-96b1-4df2-a6b8-e6f72458ede0	true	id.token.claim
520f0fd2-96b1-4df2-a6b8-e6f72458ede0	true	access.token.claim
6f2d1c26-66b6-44ea-a5e4-a7d1744af141	true	userinfo.token.claim
6f2d1c26-66b6-44ea-a5e4-a7d1744af141	website	user.attribute
6f2d1c26-66b6-44ea-a5e4-a7d1744af141	true	id.token.claim
6f2d1c26-66b6-44ea-a5e4-a7d1744af141	true	access.token.claim
6f2d1c26-66b6-44ea-a5e4-a7d1744af141	website	claim.name
6f2d1c26-66b6-44ea-a5e4-a7d1744af141	String	jsonType.label
73e0b6aa-c13f-4d38-8a7d-a0137685e962	true	userinfo.token.claim
73e0b6aa-c13f-4d38-8a7d-a0137685e962	profile	user.attribute
73e0b6aa-c13f-4d38-8a7d-a0137685e962	true	id.token.claim
73e0b6aa-c13f-4d38-8a7d-a0137685e962	true	access.token.claim
73e0b6aa-c13f-4d38-8a7d-a0137685e962	profile	claim.name
73e0b6aa-c13f-4d38-8a7d-a0137685e962	String	jsonType.label
76cdc97e-f042-4c9c-bd72-993c3a692ed9	true	userinfo.token.claim
76cdc97e-f042-4c9c-bd72-993c3a692ed9	locale	user.attribute
76cdc97e-f042-4c9c-bd72-993c3a692ed9	true	id.token.claim
76cdc97e-f042-4c9c-bd72-993c3a692ed9	true	access.token.claim
76cdc97e-f042-4c9c-bd72-993c3a692ed9	locale	claim.name
76cdc97e-f042-4c9c-bd72-993c3a692ed9	String	jsonType.label
9985c31f-8bfa-42e4-98e2-be5b71201fc8	true	userinfo.token.claim
9985c31f-8bfa-42e4-98e2-be5b71201fc8	lastName	user.attribute
9985c31f-8bfa-42e4-98e2-be5b71201fc8	true	id.token.claim
9985c31f-8bfa-42e4-98e2-be5b71201fc8	true	access.token.claim
9985c31f-8bfa-42e4-98e2-be5b71201fc8	family_name	claim.name
9985c31f-8bfa-42e4-98e2-be5b71201fc8	String	jsonType.label
c3fcb3ee-0dab-439a-981a-81c1dd3a9073	true	userinfo.token.claim
c3fcb3ee-0dab-439a-981a-81c1dd3a9073	picture	user.attribute
c3fcb3ee-0dab-439a-981a-81c1dd3a9073	true	id.token.claim
c3fcb3ee-0dab-439a-981a-81c1dd3a9073	true	access.token.claim
c3fcb3ee-0dab-439a-981a-81c1dd3a9073	picture	claim.name
c3fcb3ee-0dab-439a-981a-81c1dd3a9073	String	jsonType.label
c61ba0c3-5fa3-45a1-9a87-54e93b7680fe	true	userinfo.token.claim
c61ba0c3-5fa3-45a1-9a87-54e93b7680fe	nickname	user.attribute
c61ba0c3-5fa3-45a1-9a87-54e93b7680fe	true	id.token.claim
c61ba0c3-5fa3-45a1-9a87-54e93b7680fe	true	access.token.claim
c61ba0c3-5fa3-45a1-9a87-54e93b7680fe	nickname	claim.name
c61ba0c3-5fa3-45a1-9a87-54e93b7680fe	String	jsonType.label
d689b356-611b-4d68-b9f4-554b122ac7fa	true	userinfo.token.claim
d689b356-611b-4d68-b9f4-554b122ac7fa	updatedAt	user.attribute
d689b356-611b-4d68-b9f4-554b122ac7fa	true	id.token.claim
d689b356-611b-4d68-b9f4-554b122ac7fa	true	access.token.claim
d689b356-611b-4d68-b9f4-554b122ac7fa	updated_at	claim.name
d689b356-611b-4d68-b9f4-554b122ac7fa	long	jsonType.label
d9a1a220-f6b1-49f6-8b2f-30bbfb56e38d	true	userinfo.token.claim
d9a1a220-f6b1-49f6-8b2f-30bbfb56e38d	middleName	user.attribute
d9a1a220-f6b1-49f6-8b2f-30bbfb56e38d	true	id.token.claim
d9a1a220-f6b1-49f6-8b2f-30bbfb56e38d	true	access.token.claim
d9a1a220-f6b1-49f6-8b2f-30bbfb56e38d	middle_name	claim.name
d9a1a220-f6b1-49f6-8b2f-30bbfb56e38d	String	jsonType.label
e6a80531-b99f-488d-8049-b2334b77d0cd	true	userinfo.token.claim
e6a80531-b99f-488d-8049-b2334b77d0cd	gender	user.attribute
e6a80531-b99f-488d-8049-b2334b77d0cd	true	id.token.claim
e6a80531-b99f-488d-8049-b2334b77d0cd	true	access.token.claim
e6a80531-b99f-488d-8049-b2334b77d0cd	gender	claim.name
e6a80531-b99f-488d-8049-b2334b77d0cd	String	jsonType.label
af3f2214-8b3c-4d70-84ad-8eebf2fe2336	true	userinfo.token.claim
af3f2214-8b3c-4d70-84ad-8eebf2fe2336	emailVerified	user.attribute
af3f2214-8b3c-4d70-84ad-8eebf2fe2336	true	id.token.claim
af3f2214-8b3c-4d70-84ad-8eebf2fe2336	true	access.token.claim
af3f2214-8b3c-4d70-84ad-8eebf2fe2336	email_verified	claim.name
af3f2214-8b3c-4d70-84ad-8eebf2fe2336	boolean	jsonType.label
d74f7fe2-f2e4-421c-8bbf-385cadb84b22	true	userinfo.token.claim
d74f7fe2-f2e4-421c-8bbf-385cadb84b22	email	user.attribute
d74f7fe2-f2e4-421c-8bbf-385cadb84b22	true	id.token.claim
d74f7fe2-f2e4-421c-8bbf-385cadb84b22	true	access.token.claim
d74f7fe2-f2e4-421c-8bbf-385cadb84b22	email	claim.name
d74f7fe2-f2e4-421c-8bbf-385cadb84b22	String	jsonType.label
3943d6e9-0cb4-460a-9367-dc04f76f8dd9	formatted	user.attribute.formatted
3943d6e9-0cb4-460a-9367-dc04f76f8dd9	country	user.attribute.country
3943d6e9-0cb4-460a-9367-dc04f76f8dd9	postal_code	user.attribute.postal_code
3943d6e9-0cb4-460a-9367-dc04f76f8dd9	true	userinfo.token.claim
3943d6e9-0cb4-460a-9367-dc04f76f8dd9	street	user.attribute.street
3943d6e9-0cb4-460a-9367-dc04f76f8dd9	true	id.token.claim
3943d6e9-0cb4-460a-9367-dc04f76f8dd9	region	user.attribute.region
3943d6e9-0cb4-460a-9367-dc04f76f8dd9	true	access.token.claim
3943d6e9-0cb4-460a-9367-dc04f76f8dd9	locality	user.attribute.locality
3bd8c731-9e83-47aa-9519-c316f04f3173	true	userinfo.token.claim
3bd8c731-9e83-47aa-9519-c316f04f3173	phoneNumberVerified	user.attribute
3bd8c731-9e83-47aa-9519-c316f04f3173	true	id.token.claim
3bd8c731-9e83-47aa-9519-c316f04f3173	true	access.token.claim
3bd8c731-9e83-47aa-9519-c316f04f3173	phone_number_verified	claim.name
3bd8c731-9e83-47aa-9519-c316f04f3173	boolean	jsonType.label
48ebfe7f-1834-429a-97d1-b01b47358460	true	userinfo.token.claim
48ebfe7f-1834-429a-97d1-b01b47358460	phoneNumber	user.attribute
48ebfe7f-1834-429a-97d1-b01b47358460	true	id.token.claim
48ebfe7f-1834-429a-97d1-b01b47358460	true	access.token.claim
48ebfe7f-1834-429a-97d1-b01b47358460	phone_number	claim.name
48ebfe7f-1834-429a-97d1-b01b47358460	String	jsonType.label
afa9faf7-a3a1-4c2f-990d-944d97e0dd04	true	multivalued
afa9faf7-a3a1-4c2f-990d-944d97e0dd04	foo	user.attribute
afa9faf7-a3a1-4c2f-990d-944d97e0dd04	true	access.token.claim
afa9faf7-a3a1-4c2f-990d-944d97e0dd04	realm_access.roles	claim.name
afa9faf7-a3a1-4c2f-990d-944d97e0dd04	String	jsonType.label
eb8a44e5-b560-4e13-ae39-8b2f037d614c	true	multivalued
eb8a44e5-b560-4e13-ae39-8b2f037d614c	foo	user.attribute
eb8a44e5-b560-4e13-ae39-8b2f037d614c	true	access.token.claim
eb8a44e5-b560-4e13-ae39-8b2f037d614c	resource_access.${client_id}.roles	claim.name
eb8a44e5-b560-4e13-ae39-8b2f037d614c	String	jsonType.label
9b5ba7ff-f428-4844-bb98-44d6abd709d6	true	userinfo.token.claim
9b5ba7ff-f428-4844-bb98-44d6abd709d6	username	user.attribute
9b5ba7ff-f428-4844-bb98-44d6abd709d6	true	id.token.claim
9b5ba7ff-f428-4844-bb98-44d6abd709d6	true	access.token.claim
9b5ba7ff-f428-4844-bb98-44d6abd709d6	upn	claim.name
9b5ba7ff-f428-4844-bb98-44d6abd709d6	String	jsonType.label
cfb98850-4b71-4f01-843a-f9da9633bc3c	true	multivalued
cfb98850-4b71-4f01-843a-f9da9633bc3c	foo	user.attribute
cfb98850-4b71-4f01-843a-f9da9633bc3c	true	id.token.claim
cfb98850-4b71-4f01-843a-f9da9633bc3c	true	access.token.claim
cfb98850-4b71-4f01-843a-f9da9633bc3c	groups	claim.name
cfb98850-4b71-4f01-843a-f9da9633bc3c	String	jsonType.label
e17f92e4-8262-4da5-8d0f-9dd9ad336202	true	id.token.claim
e17f92e4-8262-4da5-8d0f-9dd9ad336202	true	access.token.claim
002f0cdd-3a1f-419d-a650-ea28cb7db187	false	single
002f0cdd-3a1f-419d-a650-ea28cb7db187	Basic	attribute.nameformat
002f0cdd-3a1f-419d-a650-ea28cb7db187	Role	attribute.name
03a798d7-1980-41cf-a74e-17073ff96262	true	userinfo.token.claim
03a798d7-1980-41cf-a74e-17073ff96262	updatedAt	user.attribute
03a798d7-1980-41cf-a74e-17073ff96262	true	id.token.claim
03a798d7-1980-41cf-a74e-17073ff96262	true	access.token.claim
03a798d7-1980-41cf-a74e-17073ff96262	updated_at	claim.name
03a798d7-1980-41cf-a74e-17073ff96262	long	jsonType.label
1915f742-873e-43b3-8b74-7f6aac4fd80c	true	userinfo.token.claim
1915f742-873e-43b3-8b74-7f6aac4fd80c	true	id.token.claim
1915f742-873e-43b3-8b74-7f6aac4fd80c	true	access.token.claim
19792dae-0a66-4d24-aede-cecd3afc45a7	true	userinfo.token.claim
19792dae-0a66-4d24-aede-cecd3afc45a7	firstName	user.attribute
19792dae-0a66-4d24-aede-cecd3afc45a7	true	id.token.claim
19792dae-0a66-4d24-aede-cecd3afc45a7	true	access.token.claim
19792dae-0a66-4d24-aede-cecd3afc45a7	given_name	claim.name
19792dae-0a66-4d24-aede-cecd3afc45a7	String	jsonType.label
2162f6f4-9328-477e-bad8-0059f24427cc	true	userinfo.token.claim
2162f6f4-9328-477e-bad8-0059f24427cc	locale	user.attribute
2162f6f4-9328-477e-bad8-0059f24427cc	true	id.token.claim
2162f6f4-9328-477e-bad8-0059f24427cc	true	access.token.claim
2162f6f4-9328-477e-bad8-0059f24427cc	locale	claim.name
2162f6f4-9328-477e-bad8-0059f24427cc	String	jsonType.label
254fdd5c-badd-4ab4-9b85-647f2dbe805e	true	userinfo.token.claim
254fdd5c-badd-4ab4-9b85-647f2dbe805e	zoneinfo	user.attribute
254fdd5c-badd-4ab4-9b85-647f2dbe805e	true	id.token.claim
254fdd5c-badd-4ab4-9b85-647f2dbe805e	true	access.token.claim
254fdd5c-badd-4ab4-9b85-647f2dbe805e	zoneinfo	claim.name
254fdd5c-badd-4ab4-9b85-647f2dbe805e	String	jsonType.label
28d6f592-51f8-4bdc-a9f5-20eb4c9138af	true	userinfo.token.claim
28d6f592-51f8-4bdc-a9f5-20eb4c9138af	lastName	user.attribute
28d6f592-51f8-4bdc-a9f5-20eb4c9138af	true	id.token.claim
28d6f592-51f8-4bdc-a9f5-20eb4c9138af	true	access.token.claim
28d6f592-51f8-4bdc-a9f5-20eb4c9138af	family_name	claim.name
28d6f592-51f8-4bdc-a9f5-20eb4c9138af	String	jsonType.label
2adddeaa-991d-48ec-86e3-d725cdc946d0	true	userinfo.token.claim
2adddeaa-991d-48ec-86e3-d725cdc946d0	username	user.attribute
2adddeaa-991d-48ec-86e3-d725cdc946d0	true	id.token.claim
2adddeaa-991d-48ec-86e3-d725cdc946d0	true	access.token.claim
2adddeaa-991d-48ec-86e3-d725cdc946d0	preferred_username	claim.name
2adddeaa-991d-48ec-86e3-d725cdc946d0	String	jsonType.label
533f2173-84ec-4c3e-969e-a7406677a3b4	true	userinfo.token.claim
533f2173-84ec-4c3e-969e-a7406677a3b4	nickname	user.attribute
533f2173-84ec-4c3e-969e-a7406677a3b4	true	id.token.claim
533f2173-84ec-4c3e-969e-a7406677a3b4	true	access.token.claim
533f2173-84ec-4c3e-969e-a7406677a3b4	nickname	claim.name
533f2173-84ec-4c3e-969e-a7406677a3b4	String	jsonType.label
5cb07873-4f53-4ba2-b58c-ae6e4afe1fd6	true	userinfo.token.claim
5cb07873-4f53-4ba2-b58c-ae6e4afe1fd6	website	user.attribute
5cb07873-4f53-4ba2-b58c-ae6e4afe1fd6	true	id.token.claim
5cb07873-4f53-4ba2-b58c-ae6e4afe1fd6	true	access.token.claim
5cb07873-4f53-4ba2-b58c-ae6e4afe1fd6	website	claim.name
5cb07873-4f53-4ba2-b58c-ae6e4afe1fd6	String	jsonType.label
64b7a9b9-48d7-4c98-9692-cca0335d60e6	true	userinfo.token.claim
64b7a9b9-48d7-4c98-9692-cca0335d60e6	picture	user.attribute
64b7a9b9-48d7-4c98-9692-cca0335d60e6	true	id.token.claim
64b7a9b9-48d7-4c98-9692-cca0335d60e6	true	access.token.claim
64b7a9b9-48d7-4c98-9692-cca0335d60e6	picture	claim.name
64b7a9b9-48d7-4c98-9692-cca0335d60e6	String	jsonType.label
726094cb-0807-43d6-a5a0-b47e193649fe	true	userinfo.token.claim
726094cb-0807-43d6-a5a0-b47e193649fe	profile	user.attribute
726094cb-0807-43d6-a5a0-b47e193649fe	true	id.token.claim
726094cb-0807-43d6-a5a0-b47e193649fe	true	access.token.claim
726094cb-0807-43d6-a5a0-b47e193649fe	profile	claim.name
726094cb-0807-43d6-a5a0-b47e193649fe	String	jsonType.label
accd09b5-0ac6-4ffd-958c-589f0550e63e	true	userinfo.token.claim
accd09b5-0ac6-4ffd-958c-589f0550e63e	birthdate	user.attribute
accd09b5-0ac6-4ffd-958c-589f0550e63e	true	id.token.claim
accd09b5-0ac6-4ffd-958c-589f0550e63e	true	access.token.claim
accd09b5-0ac6-4ffd-958c-589f0550e63e	birthdate	claim.name
accd09b5-0ac6-4ffd-958c-589f0550e63e	String	jsonType.label
bcf865d7-c6bf-48c2-bf43-c5e0208df2f7	true	userinfo.token.claim
bcf865d7-c6bf-48c2-bf43-c5e0208df2f7	middleName	user.attribute
bcf865d7-c6bf-48c2-bf43-c5e0208df2f7	true	id.token.claim
bcf865d7-c6bf-48c2-bf43-c5e0208df2f7	true	access.token.claim
bcf865d7-c6bf-48c2-bf43-c5e0208df2f7	middle_name	claim.name
bcf865d7-c6bf-48c2-bf43-c5e0208df2f7	String	jsonType.label
d43267b9-7569-46f9-9879-aaaaf2f2af75	true	userinfo.token.claim
d43267b9-7569-46f9-9879-aaaaf2f2af75	gender	user.attribute
d43267b9-7569-46f9-9879-aaaaf2f2af75	true	id.token.claim
d43267b9-7569-46f9-9879-aaaaf2f2af75	true	access.token.claim
d43267b9-7569-46f9-9879-aaaaf2f2af75	gender	claim.name
d43267b9-7569-46f9-9879-aaaaf2f2af75	String	jsonType.label
3b2970e0-38a6-4572-bcf0-8d6c7e9d1a9b	true	userinfo.token.claim
3b2970e0-38a6-4572-bcf0-8d6c7e9d1a9b	emailVerified	user.attribute
3b2970e0-38a6-4572-bcf0-8d6c7e9d1a9b	true	id.token.claim
3b2970e0-38a6-4572-bcf0-8d6c7e9d1a9b	true	access.token.claim
3b2970e0-38a6-4572-bcf0-8d6c7e9d1a9b	email_verified	claim.name
3b2970e0-38a6-4572-bcf0-8d6c7e9d1a9b	boolean	jsonType.label
6bbab890-d242-4299-be40-4a42fd3e6a7d	true	userinfo.token.claim
6bbab890-d242-4299-be40-4a42fd3e6a7d	email	user.attribute
6bbab890-d242-4299-be40-4a42fd3e6a7d	true	id.token.claim
6bbab890-d242-4299-be40-4a42fd3e6a7d	true	access.token.claim
6bbab890-d242-4299-be40-4a42fd3e6a7d	email	claim.name
6bbab890-d242-4299-be40-4a42fd3e6a7d	String	jsonType.label
6330246b-c624-46b5-ae80-d045c7aacc9a	formatted	user.attribute.formatted
6330246b-c624-46b5-ae80-d045c7aacc9a	country	user.attribute.country
6330246b-c624-46b5-ae80-d045c7aacc9a	postal_code	user.attribute.postal_code
6330246b-c624-46b5-ae80-d045c7aacc9a	true	userinfo.token.claim
6330246b-c624-46b5-ae80-d045c7aacc9a	street	user.attribute.street
6330246b-c624-46b5-ae80-d045c7aacc9a	true	id.token.claim
6330246b-c624-46b5-ae80-d045c7aacc9a	region	user.attribute.region
6330246b-c624-46b5-ae80-d045c7aacc9a	true	access.token.claim
6330246b-c624-46b5-ae80-d045c7aacc9a	locality	user.attribute.locality
0798fde1-e9b0-43ba-9a24-07c1482bcad6	true	userinfo.token.claim
0798fde1-e9b0-43ba-9a24-07c1482bcad6	phoneNumber	user.attribute
0798fde1-e9b0-43ba-9a24-07c1482bcad6	true	id.token.claim
0798fde1-e9b0-43ba-9a24-07c1482bcad6	true	access.token.claim
0798fde1-e9b0-43ba-9a24-07c1482bcad6	phone_number	claim.name
0798fde1-e9b0-43ba-9a24-07c1482bcad6	String	jsonType.label
a59aa26a-e19c-4c29-9115-fc268f0707e3	true	userinfo.token.claim
a59aa26a-e19c-4c29-9115-fc268f0707e3	phoneNumberVerified	user.attribute
a59aa26a-e19c-4c29-9115-fc268f0707e3	true	id.token.claim
a59aa26a-e19c-4c29-9115-fc268f0707e3	true	access.token.claim
a59aa26a-e19c-4c29-9115-fc268f0707e3	phone_number_verified	claim.name
a59aa26a-e19c-4c29-9115-fc268f0707e3	boolean	jsonType.label
0616f9ba-0c3f-4eec-9183-4718b8e8d560	true	multivalued
0616f9ba-0c3f-4eec-9183-4718b8e8d560	foo	user.attribute
0616f9ba-0c3f-4eec-9183-4718b8e8d560	true	access.token.claim
0616f9ba-0c3f-4eec-9183-4718b8e8d560	resource_access.${client_id}.roles	claim.name
0616f9ba-0c3f-4eec-9183-4718b8e8d560	String	jsonType.label
4ae1ef6f-7649-415c-a6f3-2128ded0c332	true	multivalued
4ae1ef6f-7649-415c-a6f3-2128ded0c332	foo	user.attribute
4ae1ef6f-7649-415c-a6f3-2128ded0c332	true	access.token.claim
4ae1ef6f-7649-415c-a6f3-2128ded0c332	realm_access.roles	claim.name
4ae1ef6f-7649-415c-a6f3-2128ded0c332	String	jsonType.label
8d737364-773f-4e26-9334-c643f08c9eb1	true	multivalued
8d737364-773f-4e26-9334-c643f08c9eb1	foo	user.attribute
8d737364-773f-4e26-9334-c643f08c9eb1	true	id.token.claim
8d737364-773f-4e26-9334-c643f08c9eb1	true	access.token.claim
8d737364-773f-4e26-9334-c643f08c9eb1	groups	claim.name
8d737364-773f-4e26-9334-c643f08c9eb1	String	jsonType.label
f6a53d34-be9c-4b5f-b513-05308c731ce2	true	userinfo.token.claim
f6a53d34-be9c-4b5f-b513-05308c731ce2	username	user.attribute
f6a53d34-be9c-4b5f-b513-05308c731ce2	true	id.token.claim
f6a53d34-be9c-4b5f-b513-05308c731ce2	true	access.token.claim
f6a53d34-be9c-4b5f-b513-05308c731ce2	upn	claim.name
f6a53d34-be9c-4b5f-b513-05308c731ce2	String	jsonType.label
e0ae1e3e-ebd3-42e6-a7c2-eb63bd1c79ac	true	id.token.claim
e0ae1e3e-ebd3-42e6-a7c2-eb63bd1c79ac	true	access.token.claim
c34c5471-94fa-48b5-abe5-a444856d1a57	true	userinfo.token.claim
c34c5471-94fa-48b5-abe5-a444856d1a57	locale	user.attribute
c34c5471-94fa-48b5-abe5-a444856d1a57	true	id.token.claim
c34c5471-94fa-48b5-abe5-a444856d1a57	true	access.token.claim
c34c5471-94fa-48b5-abe5-a444856d1a57	locale	claim.name
c34c5471-94fa-48b5-abe5-a444856d1a57	String	jsonType.label
\.


--
-- TOC entry 4119 (class 0 OID 16439)
-- Dependencies: 218
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
d197e81d-3fcf-427b-b55c-debfeffaf415	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	448c4db4-c6fa-45be-af4c-629ec0847ab9	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	f2c996ac-4621-4bee-8b4d-4a57d9d139ed	75e16c01-b714-404a-a6ec-b1cc91c4caa5	ae18b243-ee16-4c41-bbdb-6b2a5ae8a3f7	c3bc14ba-631e-4730-a3de-5914bb6aba7b	ea4bf0df-61e2-4abf-8073-baffe6c2608e	2592000	f	900	t	f	501b7b6a-0167-4b1f-a663-80eff02449cd	0	f	0	0	e8a5ef62-6c4c-4cf7-a11c-71e484133443
58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	60	300	300	\N	\N	\N	t	f	0	\N	real-world-app	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	4519eb8c-a57a-4c34-9efc-a5e5124fa4f9	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	68dba959-2ce8-488c-a463-fc0605d3baa4	6b52511e-e5dd-429a-b1d7-5370a8cb325d	850ff647-577c-45f2-9be0-095046de8149	13a9128e-5761-4e78-aa3c-ec2f6ddd15d8	f69c4da4-5213-4907-aefa-1c72967df9ef	2592000	f	900	t	f	70a343ac-0dcf-4ef5-a6a1-fb52c16c9b3b	0	f	0	0	99af801d-8ec3-4f26-a5e3-418b8dac3158
\.


--
-- TOC entry 4120 (class 0 OID 16456)
-- Dependencies: 219
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	d197e81d-3fcf-427b-b55c-debfeffaf415	
_browser_header.xContentTypeOptions	d197e81d-3fcf-427b-b55c-debfeffaf415	nosniff
_browser_header.xRobotsTag	d197e81d-3fcf-427b-b55c-debfeffaf415	none
_browser_header.xFrameOptions	d197e81d-3fcf-427b-b55c-debfeffaf415	SAMEORIGIN
_browser_header.contentSecurityPolicy	d197e81d-3fcf-427b-b55c-debfeffaf415	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	d197e81d-3fcf-427b-b55c-debfeffaf415	1; mode=block
_browser_header.strictTransportSecurity	d197e81d-3fcf-427b-b55c-debfeffaf415	max-age=31536000; includeSubDomains
bruteForceProtected	d197e81d-3fcf-427b-b55c-debfeffaf415	false
permanentLockout	d197e81d-3fcf-427b-b55c-debfeffaf415	false
maxFailureWaitSeconds	d197e81d-3fcf-427b-b55c-debfeffaf415	900
minimumQuickLoginWaitSeconds	d197e81d-3fcf-427b-b55c-debfeffaf415	60
waitIncrementSeconds	d197e81d-3fcf-427b-b55c-debfeffaf415	60
quickLoginCheckMilliSeconds	d197e81d-3fcf-427b-b55c-debfeffaf415	1000
maxDeltaTimeSeconds	d197e81d-3fcf-427b-b55c-debfeffaf415	43200
failureFactor	d197e81d-3fcf-427b-b55c-debfeffaf415	30
realmReusableOtpCode	d197e81d-3fcf-427b-b55c-debfeffaf415	false
displayName	d197e81d-3fcf-427b-b55c-debfeffaf415	Keycloak
displayNameHtml	d197e81d-3fcf-427b-b55c-debfeffaf415	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	d197e81d-3fcf-427b-b55c-debfeffaf415	RS256
offlineSessionMaxLifespanEnabled	d197e81d-3fcf-427b-b55c-debfeffaf415	false
offlineSessionMaxLifespan	d197e81d-3fcf-427b-b55c-debfeffaf415	5184000
_browser_header.contentSecurityPolicyReportOnly	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	
_browser_header.xContentTypeOptions	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	nosniff
_browser_header.xRobotsTag	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	none
_browser_header.xFrameOptions	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	SAMEORIGIN
_browser_header.contentSecurityPolicy	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	1; mode=block
_browser_header.strictTransportSecurity	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	max-age=31536000; includeSubDomains
bruteForceProtected	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	false
permanentLockout	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	false
maxFailureWaitSeconds	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	900
minimumQuickLoginWaitSeconds	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	60
waitIncrementSeconds	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	60
quickLoginCheckMilliSeconds	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	1000
maxDeltaTimeSeconds	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	43200
failureFactor	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	30
realmReusableOtpCode	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	false
defaultSignatureAlgorithm	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	RS256
offlineSessionMaxLifespanEnabled	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	false
offlineSessionMaxLifespan	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	5184000
actionTokenGeneratedByAdminLifespan	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	43200
actionTokenGeneratedByUserLifespan	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	300
oauth2DeviceCodeLifespan	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	600
oauth2DevicePollingInterval	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	5
webAuthnPolicyRpEntityName	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	keycloak
webAuthnPolicySignatureAlgorithms	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	ES256
webAuthnPolicyRpId	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	
webAuthnPolicyAttestationConveyancePreference	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	not specified
webAuthnPolicyAuthenticatorAttachment	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	not specified
webAuthnPolicyRequireResidentKey	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	not specified
webAuthnPolicyUserVerificationRequirement	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	not specified
webAuthnPolicyCreateTimeout	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	0
webAuthnPolicyAvoidSameAuthenticatorRegister	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	false
webAuthnPolicyRpEntityNamePasswordless	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	ES256
webAuthnPolicyRpIdPasswordless	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	
webAuthnPolicyAttestationConveyancePreferencePasswordless	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	not specified
webAuthnPolicyRequireResidentKeyPasswordless	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	not specified
webAuthnPolicyCreateTimeoutPasswordless	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	false
cibaBackchannelTokenDeliveryMode	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	poll
cibaExpiresIn	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	120
cibaInterval	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	5
cibaAuthRequestedUserHint	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	login_hint
parRequestUriLifespan	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	60
\.


--
-- TOC entry 4168 (class 0 OID 17213)
-- Dependencies: 267
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- TOC entry 4145 (class 0 OID 16909)
-- Dependencies: 244
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- TOC entry 4121 (class 0 OID 16464)
-- Dependencies: 220
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
d197e81d-3fcf-427b-b55c-debfeffaf415	jboss-logging
58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	jboss-logging
\.


--
-- TOC entry 4201 (class 0 OID 17915)
-- Dependencies: 300
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- TOC entry 4122 (class 0 OID 16467)
-- Dependencies: 221
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	d197e81d-3fcf-427b-b55c-debfeffaf415
password	password	t	t	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb
\.


--
-- TOC entry 4123 (class 0 OID 16474)
-- Dependencies: 222
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- TOC entry 4143 (class 0 OID 16825)
-- Dependencies: 242
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- TOC entry 4124 (class 0 OID 16484)
-- Dependencies: 223
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.redirect_uris (client_id, value) FROM stdin;
f524cc57-d961-49af-9920-6608babb1039	/realms/master/account/*
e9532515-74ee-40b9-8673-3864fb56b97a	/realms/master/account/*
0b14429d-4885-412c-b4e2-4486b44d49a2	/admin/master/console/*
f59bb731-a6bf-4ec4-9773-1daa4e329433	/realms/real-world-app/account/*
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	/realms/real-world-app/account/*
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	/admin/real-world-app/console/*
\.


--
-- TOC entry 4161 (class 0 OID 17148)
-- Dependencies: 260
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- TOC entry 4160 (class 0 OID 17141)
-- Dependencies: 259
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
cbc57752-0f1a-45ec-8252-513df8cb75de	VERIFY_EMAIL	Verify Email	d197e81d-3fcf-427b-b55c-debfeffaf415	t	f	VERIFY_EMAIL	50
fdec15c1-a40e-403e-b088-dabcfce9daa4	UPDATE_PROFILE	Update Profile	d197e81d-3fcf-427b-b55c-debfeffaf415	t	f	UPDATE_PROFILE	40
318fd7ea-1599-4aa9-850f-5c24c45110eb	CONFIGURE_TOTP	Configure OTP	d197e81d-3fcf-427b-b55c-debfeffaf415	t	f	CONFIGURE_TOTP	10
b288f2d4-7a83-45ef-b9c8-4d385ae14089	UPDATE_PASSWORD	Update Password	d197e81d-3fcf-427b-b55c-debfeffaf415	t	f	UPDATE_PASSWORD	30
5bb287f5-448e-4a3a-b02d-989cc58cef0f	TERMS_AND_CONDITIONS	Terms and Conditions	d197e81d-3fcf-427b-b55c-debfeffaf415	f	f	TERMS_AND_CONDITIONS	20
87509f8f-5831-4124-af0d-d7ef36a61bfe	delete_account	Delete Account	d197e81d-3fcf-427b-b55c-debfeffaf415	f	f	delete_account	60
31c590a4-83bc-4437-b631-114df31b4598	update_user_locale	Update User Locale	d197e81d-3fcf-427b-b55c-debfeffaf415	t	f	update_user_locale	1000
9b080a2a-b1f1-4d11-a7f1-20dc7c90e210	webauthn-register	Webauthn Register	d197e81d-3fcf-427b-b55c-debfeffaf415	t	f	webauthn-register	70
a10666f0-5f0d-4b42-8d9c-92fab2fbf80f	webauthn-register-passwordless	Webauthn Register Passwordless	d197e81d-3fcf-427b-b55c-debfeffaf415	t	f	webauthn-register-passwordless	80
6b0cf2b9-81be-4731-96ce-cfc63a97fb3e	VERIFY_EMAIL	Verify Email	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	t	f	VERIFY_EMAIL	50
7fd8272c-71a6-4871-830e-ad7f8b85c590	UPDATE_PROFILE	Update Profile	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	t	f	UPDATE_PROFILE	40
ce6b99b3-5183-4f0e-bccc-ba23eebfbc32	CONFIGURE_TOTP	Configure OTP	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	t	f	CONFIGURE_TOTP	10
e6e4c5f2-24ff-44c5-9d72-b7f0fa0e52fd	UPDATE_PASSWORD	Update Password	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	t	f	UPDATE_PASSWORD	30
44c76fd6-f346-4453-b5cb-34747a47b658	TERMS_AND_CONDITIONS	Terms and Conditions	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f	f	TERMS_AND_CONDITIONS	20
133fc398-c85f-4359-856c-edfeb38f1fa1	delete_account	Delete Account	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	f	f	delete_account	60
58a7d175-59ce-4c1c-84fe-12fdd6ce98ac	update_user_locale	Update User Locale	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	t	f	update_user_locale	1000
dd8f550e-f296-4a08-accc-486af92eb372	webauthn-register	Webauthn Register	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	t	f	webauthn-register	70
fd7a5180-c27c-46b1-bca9-a9de9fc6501c	webauthn-register-passwordless	Webauthn Register Passwordless	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	t	f	webauthn-register-passwordless	80
\.


--
-- TOC entry 4198 (class 0 OID 17846)
-- Dependencies: 297
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- TOC entry 4178 (class 0 OID 17430)
-- Dependencies: 277
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- TOC entry 4177 (class 0 OID 17415)
-- Dependencies: 276
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- TOC entry 4172 (class 0 OID 17353)
-- Dependencies: 271
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- TOC entry 4197 (class 0 OID 17822)
-- Dependencies: 296
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- TOC entry 4175 (class 0 OID 17389)
-- Dependencies: 274
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- TOC entry 4173 (class 0 OID 17361)
-- Dependencies: 272
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- TOC entry 4174 (class 0 OID 17375)
-- Dependencies: 273
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- TOC entry 4199 (class 0 OID 17864)
-- Dependencies: 298
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- TOC entry 4200 (class 0 OID 17874)
-- Dependencies: 299
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- TOC entry 4125 (class 0 OID 16487)
-- Dependencies: 224
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
e9532515-74ee-40b9-8673-3864fb56b97a	4d1611fa-5810-42d4-bf7b-009cee8a192f
e9532515-74ee-40b9-8673-3864fb56b97a	13e2d70f-c893-4fc1-a534-a8b44b9252a4
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	a1b34942-c9dd-4ccd-85b0-92290aa1be03
ca585f83-a5b3-4169-b40d-bb3784fa5bcf	f155b700-b3cf-453f-b9ad-9a2677d606d9
\.


--
-- TOC entry 4179 (class 0 OID 17445)
-- Dependencies: 278
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- TOC entry 4127 (class 0 OID 16493)
-- Dependencies: 226
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
\.


--
-- TOC entry 4149 (class 0 OID 16930)
-- Dependencies: 248
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- TOC entry 4195 (class 0 OID 17797)
-- Dependencies: 294
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- TOC entry 4128 (class 0 OID 16498)
-- Dependencies: 227
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7	\N	6d8f2ce2-9147-45c0-a0a9-a5411a5e1e11	f	t	\N	\N	\N	d197e81d-3fcf-427b-b55c-debfeffaf415	admin	1683931419060	\N	0
c9c01faf-4e07-4f9b-973b-1d401c36042c	testadmin@email.com	testadmin@email.com	f	t	\N	Thomas	Developer	58de7e78-0161-44e9-9a1c-b9a9b0fda2fb	testadmin	1683931567490	\N	0
\.


--
-- TOC entry 4129 (class 0 OID 16506)
-- Dependencies: 228
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- TOC entry 4156 (class 0 OID 17042)
-- Dependencies: 255
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- TOC entry 4157 (class 0 OID 17047)
-- Dependencies: 256
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- TOC entry 4130 (class 0 OID 16511)
-- Dependencies: 229
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- TOC entry 4167 (class 0 OID 17210)
-- Dependencies: 266
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
\.


--
-- TOC entry 4131 (class 0 OID 16516)
-- Dependencies: 230
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- TOC entry 4132 (class 0 OID 16519)
-- Dependencies: 231
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
e8a5ef62-6c4c-4cf7-a11c-71e484133443	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
9cb470e7-2706-460c-b1b7-b60b8e170fba	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
89a0f289-ff17-496e-813c-7ac0097a2ef2	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
6dc7eefd-9c56-40d0-b8ad-520ce76bf010	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
e41552a7-cf99-45f3-a053-2a16cf083e88	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
76ce711b-5764-4ffb-b7ff-896ff85af8bc	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
792413b1-9188-459a-a4a5-eedae9f1e4d2	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
e760d71d-f632-45a1-8490-6dcc0ac67511	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
b6d240a1-6cd3-4016-8943-13421b2f8746	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
c519bd29-2cfa-406f-b46c-c0f6ac9c1d3e	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
7fe5e3ee-51cb-4129-8371-24da78fa922c	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
d027811f-f938-4db1-82e7-392a5d8e8a31	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
f7cc317d-542f-4f38-8ae7-0a636a3f35db	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
9233d892-4571-4fc7-b7a0-25451c6d88e8	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
b5bb9089-defb-4c85-afe1-5e2981e2a369	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
1058784d-c068-4c02-872d-182f98c7b4be	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
01697a4f-17ab-4dd8-949d-673e7b6a1adc	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
39ebb929-3969-4a71-b2a5-1f638a76773f	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
a532d358-365a-48af-8666-a5f50f0ef6f1	5f216506-4cc6-46fe-a2d7-a8db8c0fbbd7
99af801d-8ec3-4f26-a5e3-418b8dac3158	c9c01faf-4e07-4f9b-973b-1d401c36042c
\.


--
-- TOC entry 4133 (class 0 OID 16522)
-- Dependencies: 232
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- TOC entry 4144 (class 0 OID 16828)
-- Dependencies: 243
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- TOC entry 4126 (class 0 OID 16490)
-- Dependencies: 225
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- TOC entry 4134 (class 0 OID 16533)
-- Dependencies: 233
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.web_origins (client_id, value) FROM stdin;
0b14429d-4885-412c-b4e2-4486b44d49a2	+
37e2f933-0a5a-48dd-bf98-a0aa47339ab4	+
\.


--
-- TOC entry 3654 (class 2606 OID 17589)
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- TOC entry 3627 (class 2606 OID 17898)
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- TOC entry 3870 (class 2606 OID 17728)
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- TOC entry 3872 (class 2606 OID 17927)
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- TOC entry 3867 (class 2606 OID 17603)
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- TOC entry 3784 (class 2606 OID 17251)
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- TOC entry 3832 (class 2606 OID 17526)
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- TOC entry 3753 (class 2606 OID 17160)
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- TOC entry 3858 (class 2606 OID 17546)
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- TOC entry 3861 (class 2606 OID 17544)
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- TOC entry 3850 (class 2606 OID 17542)
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- TOC entry 3834 (class 2606 OID 17528)
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- TOC entry 3837 (class 2606 OID 17530)
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- TOC entry 3842 (class 2606 OID 17536)
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- TOC entry 3846 (class 2606 OID 17538)
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- TOC entry 3854 (class 2606 OID 17540)
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- TOC entry 3865 (class 2606 OID 17583)
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- TOC entry 3786 (class 2606 OID 17687)
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- TOC entry 3712 (class 2606 OID 17704)
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- TOC entry 3641 (class 2606 OID 17706)
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- TOC entry 3707 (class 2606 OID 17708)
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- TOC entry 3700 (class 2606 OID 16837)
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- TOC entry 3684 (class 2606 OID 16771)
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- TOC entry 3624 (class 2606 OID 16545)
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- TOC entry 3696 (class 2606 OID 16839)
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- TOC entry 3633 (class 2606 OID 16547)
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- TOC entry 3615 (class 2606 OID 16549)
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- TOC entry 3679 (class 2606 OID 16551)
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- TOC entry 3670 (class 2606 OID 16553)
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- TOC entry 3686 (class 2606 OID 16773)
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- TOC entry 3607 (class 2606 OID 16557)
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- TOC entry 3612 (class 2606 OID 16559)
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- TOC entry 3651 (class 2606 OID 16561)
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- TOC entry 3688 (class 2606 OID 16775)
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- TOC entry 3638 (class 2606 OID 16563)
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- TOC entry 3644 (class 2606 OID 16565)
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- TOC entry 3629 (class 2606 OID 16567)
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- TOC entry 3730 (class 2606 OID 17691)
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- TOC entry 3743 (class 2606 OID 17068)
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- TOC entry 3739 (class 2606 OID 17066)
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- TOC entry 3736 (class 2606 OID 17064)
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- TOC entry 3733 (class 2606 OID 17062)
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- TOC entry 3751 (class 2606 OID 17072)
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- TOC entry 3676 (class 2606 OID 16569)
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- TOC entry 3617 (class 2606 OID 17685)
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- TOC entry 3728 (class 2606 OID 16955)
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- TOC entry 3705 (class 2606 OID 16841)
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- TOC entry 3818 (class 2606 OID 17409)
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- TOC entry 3646 (class 2606 OID 16571)
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- TOC entry 3621 (class 2606 OID 16573)
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- TOC entry 3668 (class 2606 OID 16575)
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- TOC entry 3885 (class 2606 OID 17826)
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- TOC entry 3803 (class 2606 OID 17367)
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- TOC entry 3813 (class 2606 OID 17395)
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- TOC entry 3829 (class 2606 OID 17464)
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- TOC entry 3823 (class 2606 OID 17434)
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- TOC entry 3808 (class 2606 OID 17381)
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- TOC entry 3820 (class 2606 OID 17419)
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- TOC entry 3826 (class 2606 OID 17449)
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- TOC entry 3660 (class 2606 OID 16577)
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- TOC entry 3749 (class 2606 OID 17076)
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- TOC entry 3745 (class 2606 OID 17074)
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- TOC entry 3883 (class 2606 OID 17811)
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- TOC entry 3880 (class 2606 OID 17801)
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- TOC entry 3723 (class 2606 OID 16949)
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- TOC entry 3770 (class 2606 OID 17218)
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- TOC entry 3777 (class 2606 OID 17225)
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- TOC entry 3774 (class 2606 OID 17239)
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- TOC entry 3718 (class 2606 OID 16945)
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- TOC entry 3721 (class 2606 OID 17125)
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- TOC entry 3715 (class 2606 OID 16943)
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- TOC entry 3766 (class 2606 OID 17904)
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- TOC entry 3760 (class 2606 OID 17195)
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- TOC entry 3690 (class 2606 OID 16835)
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- TOC entry 3694 (class 2606 OID 17118)
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- TOC entry 3648 (class 2606 OID 17710)
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- TOC entry 3758 (class 2606 OID 17158)
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- TOC entry 3755 (class 2606 OID 17156)
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- TOC entry 3673 (class 2606 OID 17070)
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- TOC entry 3891 (class 2606 OID 17873)
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- TOC entry 3893 (class 2606 OID 17880)
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- TOC entry 3656 (class 2606 OID 17154)
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- TOC entry 3781 (class 2606 OID 17232)
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- TOC entry 3710 (class 2606 OID 16845)
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- TOC entry 3681 (class 2606 OID 17712)
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- TOC entry 3605 (class 2606 OID 16389)
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- TOC entry 3795 (class 2606 OID 17335)
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- TOC entry 3790 (class 2606 OID 17294)
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- TOC entry 3801 (class 2606 OID 17665)
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- TOC entry 3799 (class 2606 OID 17323)
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- TOC entry 3878 (class 2606 OID 17786)
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- TOC entry 3896 (class 2606 OID 17921)
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- TOC entry 3889 (class 2606 OID 17853)
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- TOC entry 3772 (class 2606 OID 17595)
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- TOC entry 3703 (class 2606 OID 16892)
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- TOC entry 3610 (class 2606 OID 16581)
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- TOC entry 3792 (class 2606 OID 17739)
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- TOC entry 3664 (class 2606 OID 16585)
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- TOC entry 3806 (class 2606 OID 17912)
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- TOC entry 3887 (class 2606 OID 17908)
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- TOC entry 3816 (class 2606 OID 17656)
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- TOC entry 3811 (class 2606 OID 17660)
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- TOC entry 3726 (class 2606 OID 17900)
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- TOC entry 3636 (class 2606 OID 16593)
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- TOC entry 3666 (class 2606 OID 17585)
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- TOC entry 3731 (class 1259 OID 17937)
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- TOC entry 3830 (class 1259 OID 17609)
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- TOC entry 3734 (class 1259 OID 17613)
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- TOC entry 3740 (class 1259 OID 17611)
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- TOC entry 3741 (class 1259 OID 17610)
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- TOC entry 3737 (class 1259 OID 17612)
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- TOC entry 3873 (class 1259 OID 17928)
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- TOC entry 3608 (class 1259 OID 17913)
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- TOC entry 3868 (class 1259 OID 17653)
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- TOC entry 3613 (class 1259 OID 17617)
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- TOC entry 3793 (class 1259 OID 17816)
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- TOC entry 3874 (class 1259 OID 17925)
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- TOC entry 3691 (class 1259 OID 17813)
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- TOC entry 3796 (class 1259 OID 17814)
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- TOC entry 3859 (class 1259 OID 17619)
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- TOC entry 3862 (class 1259 OID 17887)
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- TOC entry 3863 (class 1259 OID 17618)
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- TOC entry 3618 (class 1259 OID 17620)
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- TOC entry 3619 (class 1259 OID 17621)
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- TOC entry 3875 (class 1259 OID 17819)
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- TOC entry 3876 (class 1259 OID 17820)
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- TOC entry 3625 (class 1259 OID 17914)
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- TOC entry 3697 (class 1259 OID 17352)
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- TOC entry 3698 (class 1259 OID 17351)
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- TOC entry 3835 (class 1259 OID 17713)
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- TOC entry 3838 (class 1259 OID 17733)
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- TOC entry 3839 (class 1259 OID 17896)
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- TOC entry 3840 (class 1259 OID 17715)
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- TOC entry 3843 (class 1259 OID 17716)
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- TOC entry 3844 (class 1259 OID 17717)
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- TOC entry 3847 (class 1259 OID 17718)
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- TOC entry 3848 (class 1259 OID 17719)
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- TOC entry 3851 (class 1259 OID 17720)
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- TOC entry 3852 (class 1259 OID 17721)
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- TOC entry 3855 (class 1259 OID 17722)
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- TOC entry 3856 (class 1259 OID 17723)
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- TOC entry 3778 (class 1259 OID 17938)
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- TOC entry 3779 (class 1259 OID 17624)
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- TOC entry 3775 (class 1259 OID 17625)
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- TOC entry 3719 (class 1259 OID 17627)
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- TOC entry 3701 (class 1259 OID 17626)
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- TOC entry 3630 (class 1259 OID 17628)
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- TOC entry 3631 (class 1259 OID 17629)
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- TOC entry 3767 (class 1259 OID 17931)
-- Name: idx_offline_css_preload; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offline_css_preload ON public.offline_client_session USING btree (client_id, offline_flag);


--
-- TOC entry 3761 (class 1259 OID 17932)
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- TOC entry 3762 (class 1259 OID 17933)
-- Name: idx_offline_uss_by_usersess; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offline_uss_by_usersess ON public.offline_user_session USING btree (realm_id, offline_flag, user_session_id);


--
-- TOC entry 3763 (class 1259 OID 17891)
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- TOC entry 3764 (class 1259 OID 17922)
-- Name: idx_offline_uss_preload; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offline_uss_preload ON public.offline_user_session USING btree (offline_flag, created_on, user_session_id);


--
-- TOC entry 3692 (class 1259 OID 17630)
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- TOC entry 3639 (class 1259 OID 17633)
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- TOC entry 3788 (class 1259 OID 17812)
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- TOC entry 3787 (class 1259 OID 17634)
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- TOC entry 3642 (class 1259 OID 17637)
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- TOC entry 3713 (class 1259 OID 17636)
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- TOC entry 3634 (class 1259 OID 17632)
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- TOC entry 3708 (class 1259 OID 17638)
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- TOC entry 3649 (class 1259 OID 17639)
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- TOC entry 3756 (class 1259 OID 17640)
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- TOC entry 3824 (class 1259 OID 17641)
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- TOC entry 3821 (class 1259 OID 17642)
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- TOC entry 3814 (class 1259 OID 17661)
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- TOC entry 3804 (class 1259 OID 17662)
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- TOC entry 3809 (class 1259 OID 17663)
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- TOC entry 3894 (class 1259 OID 17886)
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- TOC entry 3797 (class 1259 OID 17815)
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- TOC entry 3652 (class 1259 OID 17646)
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- TOC entry 3827 (class 1259 OID 17647)
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- TOC entry 3716 (class 1259 OID 17894)
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- TOC entry 3768 (class 1259 OID 17341)
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- TOC entry 3881 (class 1259 OID 17821)
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- TOC entry 3657 (class 1259 OID 17348)
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- TOC entry 3658 (class 1259 OID 17935)
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- TOC entry 3724 (class 1259 OID 17345)
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- TOC entry 3622 (class 1259 OID 17349)
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- TOC entry 3661 (class 1259 OID 17342)
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- TOC entry 3782 (class 1259 OID 17344)
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- TOC entry 3674 (class 1259 OID 17350)
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- TOC entry 3677 (class 1259 OID 17343)
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- TOC entry 3662 (class 1259 OID 17936)
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- TOC entry 3746 (class 1259 OID 17649)
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- TOC entry 3747 (class 1259 OID 17650)
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- TOC entry 3671 (class 1259 OID 17651)
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- TOC entry 3682 (class 1259 OID 17652)
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- TOC entry 3938 (class 2606 OID 17077)
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- TOC entry 3922 (class 2606 OID 16846)
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3915 (class 2606 OID 16776)
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3921 (class 2606 OID 16856)
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3917 (class 2606 OID 17003)
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3916 (class 2606 OID 16781)
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- TOC entry 3925 (class 2606 OID 16886)
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- TOC entry 3898 (class 2606 OID 16596)
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- TOC entry 3907 (class 2606 OID 16601)
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3911 (class 2606 OID 16606)
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3930 (class 2606 OID 16981)
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- TOC entry 3905 (class 2606 OID 16616)
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3968 (class 2606 OID 17854)
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- TOC entry 3909 (class 2606 OID 16621)
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3912 (class 2606 OID 16631)
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3902 (class 2606 OID 16636)
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- TOC entry 3906 (class 2606 OID 16641)
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3903 (class 2606 OID 16656)
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3899 (class 2606 OID 16661)
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- TOC entry 3934 (class 2606 OID 17097)
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- TOC entry 3933 (class 2606 OID 17092)
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3932 (class 2606 OID 17087)
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3931 (class 2606 OID 17082)
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3897 (class 2606 OID 16666)
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- TOC entry 3913 (class 2606 OID 16671)
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3945 (class 2606 OID 17760)
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- TOC entry 3946 (class 2606 OID 17750)
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- TOC entry 3939 (class 2606 OID 17166)
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- TOC entry 3919 (class 2606 OID 17745)
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- TOC entry 3961 (class 2606 OID 17604)
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3959 (class 2606 OID 17552)
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- TOC entry 3960 (class 2606 OID 17547)
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3944 (class 2606 OID 17252)
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3937 (class 2606 OID 17112)
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- TOC entry 3936 (class 2606 OID 17107)
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- TOC entry 3935 (class 2606 OID 17102)
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3958 (class 2606 OID 17470)
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- TOC entry 3956 (class 2606 OID 17455)
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- TOC entry 3964 (class 2606 OID 17827)
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- TOC entry 3947 (class 2606 OID 17671)
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- TOC entry 3965 (class 2606 OID 17832)
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- TOC entry 3966 (class 2606 OID 17837)
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- TOC entry 3957 (class 2606 OID 17465)
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- TOC entry 3955 (class 2606 OID 17450)
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- TOC entry 3967 (class 2606 OID 17859)
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- TOC entry 3949 (class 2606 OID 17666)
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- TOC entry 3951 (class 2606 OID 17420)
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- TOC entry 3953 (class 2606 OID 17435)
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- TOC entry 3954 (class 2606 OID 17440)
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- TOC entry 3952 (class 2606 OID 17425)
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- TOC entry 3948 (class 2606 OID 17676)
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- TOC entry 3900 (class 2606 OID 16686)
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- TOC entry 3963 (class 2606 OID 17802)
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- TOC entry 3929 (class 2606 OID 16966)
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3942 (class 2606 OID 17226)
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- TOC entry 3941 (class 2606 OID 17240)
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- TOC entry 3926 (class 2606 OID 16912)
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3904 (class 2606 OID 16696)
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3927 (class 2606 OID 16956)
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3928 (class 2606 OID 17126)
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- TOC entry 3914 (class 2606 OID 16706)
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3908 (class 2606 OID 16716)
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3918 (class 2606 OID 16851)
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3901 (class 2606 OID 16731)
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3920 (class 2606 OID 17119)
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- TOC entry 3962 (class 2606 OID 17787)
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3940 (class 2606 OID 17161)
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3969 (class 2606 OID 17867)
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- TOC entry 3970 (class 2606 OID 17881)
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- TOC entry 3924 (class 2606 OID 16881)
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3910 (class 2606 OID 16751)
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- TOC entry 3943 (class 2606 OID 17233)
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3950 (class 2606 OID 17410)
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- TOC entry 3923 (class 2606 OID 16861)
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


-- Completed on 2023-05-12 22:49:46 UTC

--
-- PostgreSQL database dump complete
--

