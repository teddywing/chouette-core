module ConnectionLinksHelper

  def connection_link_type_label_pairs
    Chouette::ConnectionLink
      .connection_link_types
      .zip_map { |type| t("connection_link_types.label.#{type}") }
  end
end
