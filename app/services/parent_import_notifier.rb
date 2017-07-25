class ParentImportNotifier
  def self.notify_when_finished(imports = nil)
    imports ||= self.imports_pending_notification
    imports.each do |import|
      import.notify_parent
    end
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
