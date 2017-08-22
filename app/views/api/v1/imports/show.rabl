object @import

attributes :id, :name, :status
node :referential_ids do |i|
  i.workbench.referentials.map(&:id)
end
