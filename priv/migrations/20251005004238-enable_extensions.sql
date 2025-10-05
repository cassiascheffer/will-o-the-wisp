--- migration:up
--
CREATE EXTENSION IF NOT EXISTS plpgsql;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

--- migration:down
--
DROP EXTENSION IF EXISTS pgcrypto;
DROP EXTENSION IF EXISTS plpgsql;

--- migration:end
