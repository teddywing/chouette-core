class ReferentialCloningWorker
  include Sidekiq::Worker

  # Replace default apartment created schema with clone schema from source referential
  def perform(id)
    ref_cloning = ReferentialCloning.find id

    source_schema = ref_cloning.source_referential.slug
    target_schema = ref_cloning.target_referential.slug

    clone_schema ref_cloning, source_schema, target_schema
  end

  private

  def clone_schema ref_cloning, source_schema, target_schema
    ref_cloning.run!

    StoredProcedures.invoke_stored_procedure(:clone_schema, source_schema, target_schema, true) 

    ref_cloning.successful!
  rescue Exception => e
    Rails.logger.error "ReferentialCloningWorker : #{e}"
    ref_cloning.failed!
  end

  def execute_sql sql
    ActiveRecord::Base.connection.execute sql
  end
end
