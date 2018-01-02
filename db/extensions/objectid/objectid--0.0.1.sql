\echo Use "CREATE EXTENSION objectid" to load this file. \quit

CREATE OR REPLACE FUNCTION shared_extensions.objectid_short_id_before_last_fragment(text)
RETURNS text LANGUAGE sql AS $$
  SELECT (string_to_array($1, ':'))[array_upper(string_to_array($1, ':'), 1) - 1]::text;
$$;

CREATE OR REPLACE FUNCTION objectid_short_id(text)
RETURNS int LANGUAGE sql AS $$
  SELECT (string_to_array(shared_extensions.objectid_short_id_before_last_fragment($1), '-'))[array_upper(string_to_array(shared_extensions.objectid_short_id_before_last_fragment($1), '-'), 1)]::int;
$$;
