module ComplianceControlBlocksHelper
  def transport_mode(transport_mode, transport_submode)
    return "[Tous les modes de transport]" if transport_mode == ""
    if transport_submode == ""
       "[" + t("enumerize.transport_mode.#{transport_mode}") + "]"
    else
      "[" + t("enumerize.transport_mode.#{transport_mode}") + "]" + "[" + t("enumerize.transport_submode.#{transport_submode}") + "]"
    end
  end
end