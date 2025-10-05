--- migration:up
ALTER TABLE blog_configs ADD FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE posts ADD FOREIGN KEY (blog_config_id) REFERENCES blog_configs(id);
ALTER TABLE posts ADD FOREIGN KEY (author_id) REFERENCES users(id);
ALTER TABLE pages ADD FOREIGN KEY (blog_config_id) REFERENCES blog_configs(id);
ALTER TABLE pages ADD FOREIGN KEY (author_id) REFERENCES users(id);
ALTER TABLE taggings ADD FOREIGN KEY (tag_id) REFERENCES tags(id);
ALTER TABLE user_tokens ADD FOREIGN KEY (user_id) REFERENCES users(id);
--- migration:down
ALTER TABLE blog_configs DROP CONSTRAINT blog_configs_user_id_fkey;
ALTER TABLE posts DROP CONSTRAINT posts_blog_config_id_fkey;
ALTER TABLE posts DROP CONSTRAINT posts_author_id_fkey;
ALTER TABLE pages DROP CONSTRAINT pages_blog_config_id_fkey;
ALTER TABLE pages DROP CONSTRAINT pages_author_id_fkey;
ALTER TABLE taggings DROP CONSTRAINT taggings_tag_id_fkey;
ALTER TABLE user_tokens DROP CONSTRAINT user_tokens_user_id_fkey;
--- migration:end
