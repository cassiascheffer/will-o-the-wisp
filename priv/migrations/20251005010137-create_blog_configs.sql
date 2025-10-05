--- migration:up
CREATE TABLE blog_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    subdomain VARCHAR,
    title VARCHAR,
    meta_description TEXT,
    favicon_emoji VARCHAR,
    custom_domain VARCHAR,
    theme VARCHAR DEFAULT 'light',
    post_footer_markdown TEXT,
    no_index BOOLEAN DEFAULT false NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    primary_blog BOOLEAN DEFAULT false NOT NULL
);

CREATE UNIQUE INDEX index_blog_configs_on_custom_domain ON blog_configs(custom_domain);
CREATE UNIQUE INDEX index_blog_configs_on_subdomain ON blog_configs(subdomain);
CREATE UNIQUE INDEX index_blog_configs_on_user_id_primary_unique ON blog_configs(user_id, primary_blog) WHERE (primary_blog = true);
CREATE INDEX index_blog_configs_on_user_id ON blog_configs(user_id);
--- migration:down
DROP TABLE blog_configs;
--- migration:end
