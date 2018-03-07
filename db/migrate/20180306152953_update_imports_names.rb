class UpdateImportsNames < ActiveRecord::Migration
  def change
    Import::Base.all.pluck(:type).uniq.each do |type|
      next if type =~ /^Imports/
      Import::Base.where(type: type).update_all type: "Import::#{type.gsub 'Import', ''}"
    end
  end
end
