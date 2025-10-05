--- migration:up
CREATE TABLE pages (
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
    blog_config_id UUID
);

CREATE INDEX index_pages_on_author_uuid ON pages(author_id);
CREATE INDEX index_pages_on_blog_config_id ON pages(blog_config_id);
CREATE UNIQUE INDEX index_pages_on_slug_blog_config_id_author_id ON pages(slug, blog_config_id, author_id);
--- migration:down
DROP TABLE pages;
--- migration:end
