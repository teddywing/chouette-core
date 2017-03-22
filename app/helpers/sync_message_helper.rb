module SyncMessageHelper
  def criticity_class criticity
    return criticity == 'error' ? 'danger' : criticity
  end
end
