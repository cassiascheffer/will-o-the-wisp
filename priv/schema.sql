--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Homebrew)
-- Dumped by pg_dump version 17.5 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._migrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    sha256 character varying(64) NOT NULL,
    createdat timestamp without time zone NOT NULL,
    appliedat timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: _migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public._migrations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public._migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: blog_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blog_configs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    subdomain character varying,
    title character varying,
    meta_description text,
    favicon_emoji character varying,
    custom_domain character varying,
    theme character varying DEFAULT 'light'::character varying,
    post_footer_markdown text,
    no_index boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    primary_blog boolean DEFAULT false NOT NULL
);


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying,
    published boolean,
    published_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    body_markdown text,
    slug character varying,
    meta_description character varying,
    author_id uuid NOT NULL,
    has_mermaid_diagrams boolean DEFAULT false NOT NULL,
    blog_config_id uuid
);


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying,
    published boolean,
    published_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    body_markdown text,
    slug character varying,
    meta_description character varying,
    author_id uuid NOT NULL,
    has_mermaid_diagrams boolean DEFAULT false NOT NULL,
    featured boolean DEFAULT false,
    blog_config_id uuid
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying NOT NULL,
    encrypted_password character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    blogs_count integer DEFAULT 0 NOT NULL
);


--
-- Name: _migrations _migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._migrations
    ADD CONSTRAINT _migrations_pkey PRIMARY KEY (id);


--
-- Name: blog_configs blog_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_configs
    ADD CONSTRAINT blog_configs_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_blog_configs_on_custom_domain; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_blog_configs_on_custom_domain ON public.blog_configs USING btree (custom_domain);


--
-- Name: index_blog_configs_on_subdomain; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_blog_configs_on_subdomain ON public.blog_configs USING btree (subdomain);


--
-- Name: index_blog_configs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blog_configs_on_user_id ON public.blog_configs USING btree (user_id);


--
-- Name: index_blog_configs_on_user_id_primary_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_blog_configs_on_user_id_primary_unique ON public.blog_configs USING btree (user_id, primary_blog) WHERE (primary_blog = true);


--
-- Name: index_pages_on_author_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_on_author_uuid ON public.pages USING btree (author_id);


--
-- Name: index_pages_on_blog_config_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_on_blog_config_id ON public.pages USING btree (blog_config_id);


--
-- Name: index_pages_on_slug_blog_config_id_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pages_on_slug_blog_config_id_author_id ON public.pages USING btree (slug, blog_config_id, author_id);


--
-- Name: index_posts_on_author_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_author_uuid ON public.posts USING btree (author_id);


--
-- Name: index_posts_on_blog_config_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_blog_config_id ON public.posts USING btree (blog_config_id);


--
-- Name: index_posts_on_slug_blog_config_id_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_posts_on_slug_blog_config_id_author_id ON public.posts USING btree (slug, blog_config_id, author_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- PostgreSQL database dump complete
--

