require_relative '../../lib/af83/stored_procedures'

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:primary_key] = "bigserial primary key"

StoredProcedures.create_stored_procedure(:clone_schema)
