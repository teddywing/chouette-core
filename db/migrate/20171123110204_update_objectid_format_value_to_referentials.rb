class UpdateObjectidFormatValueToReferentials < ActiveRecord::Migration
  # Migration in the context of the STIF
  # Not a definitive choice since it cannot be used for Chouette
  def up
    Workbench.update_all(objectid_format: 'stif_netex')
    Referential.update_all(objectid_format: 'stif_netex')
    LineReferential.update_all(objectid_format: 'stif_codifligne')
    StopAreaReferential.update_all(objectid_format: 'stif_reflex')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
