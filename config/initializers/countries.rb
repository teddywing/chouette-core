ISO3166.configure  do |config|
  config.locales = (I18n.available_locales + Chouette::StopArea::AVAILABLE_LOCALIZATIONS).uniq
end
