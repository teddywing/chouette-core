class UpdateObjectidFormatValueToReferentials < ActiveRecord::Migration
  def change
    Workbench.update_all(objectid_format: 'stif_netex')
    Referential.update_all(objectid_format: 'stif_netex')
    LineReferential.update_all(objectid_format: 'stif_codifligne')
    StopAreaReferential.update_all(objectid_format: 'stif_reflex')
  end
end
