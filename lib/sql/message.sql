CREATE OR REPLACE FUNCTION message( content text) RETURNS void AS
$BODY$
  BEGIN
    INSERT INTO xxx VALUES (nextval('xxx_id_seq'), 'message from stored procedure: ' || content, current_timestamp);
    RAISE EXCEPTION 'Oh no';
    RETURN;
  END;
$BODY$ LANGUAGE plpgsql VOLATILE COST 100;
