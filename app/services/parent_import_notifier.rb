class ParentImportNotifier
  def self.notify_when_finished(imports = nil)
    imports ||= imports_pending_notification
    imports.each(&:notify_parent)
  end

  def self.imports_pending_notification
    Import
      .where(
        notified_parent_at: nil,
        status: [:failed, :successful, :aborted, :canceled]
      )
      .where.not(parent: nil)
  end
end
