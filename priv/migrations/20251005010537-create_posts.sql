--- migration:up
CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR,
    published BOOLEAN,
    published_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    body_markdown TEXT,
    slug VARCHAR,
    meta_description VARCHAR,
    author_id UUID NOT NULL,
    has_mermaid_diagrams BOOLEAN DEFAULT false NOT NULL,
    featured BOOLEAN DEFAULT false,
    blog_config_id UUID
);

CREATE INDEX index_posts_on_author_uuid ON posts(author_id);
CREATE INDEX index_posts_on_blog_config_id ON posts(blog_config_id);
CREATE UNIQUE INDEX index_posts_on_slug_blog_config_id_author_id ON posts(slug, blog_config_id, author_id);
--- migration:down
DROP TABLE posts;
--- migration:end
