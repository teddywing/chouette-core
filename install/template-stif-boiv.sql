set ON_ERROR_STOP=on;

CREATE SCHEMA shared_extensions;
GRANT ALL ON SCHEMA shared_extensions TO PUBLIC;
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA shared_extensions;
CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA shared_extensions;

UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_stif_boiv';

VACUUM FULL FREEZE;

