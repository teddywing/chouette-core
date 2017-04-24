module AccessLinksHelper
  def access_link_type_label_pairs
    Chouette::AccessLink
    .access_link_types
    .zip_map { |type| t("connection_link_types.label.#{type}") }
  end
end
