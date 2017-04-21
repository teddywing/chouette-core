module NetworksHelper

  def source_type_name_label_pairs
    Chouette::Network.source_type_names
      .zip_map { |source_type_name| t("source_types.label.#{source_type_name}") }
  end
end
