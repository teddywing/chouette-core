module AccessPointsHelper


  def access_point_type_label_pairs
    Chouette::AccessPoint
    .access_point_types
    .zip_map { |access_point_type| t("access_types.label.#{access_point_type}") }
  end

  def pair_key(access_link)
    "#{access_link.access_point.id}-#{access_link.stop_area.id}"
  end

end
