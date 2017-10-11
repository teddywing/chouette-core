module ComplianceControlBlocksHelper
  def transport_mode(transport_mode, transport_submode)
    if (transport_mode) && (transport_submode) != ""
      transportMode = "[" + t("enumerize.transport_mode.#{transport_mode}") + "]" + "[" + t("enumerize.transport_submode.#{transport_submode}") + "]"
    else
      transportMode = "[Tous les modes de transport]"
    end
    transportMode
  end
end