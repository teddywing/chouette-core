module StopAreaCopiesHelper
  
  def label_stop_area_types(*stop_area_types)
    stop_area_types
      .flatten
      .zip_map { |stop_area_type| t("area_types.label.#{stop_area_type}") }
  end
end
