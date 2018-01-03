
class WorkbenchImportWorker
  module ObjectStateUpdater

    def update_object_state entry, count
      workbench_import.update( total_steps: count )
      update_spurious entry
      update_foreign_lines entry
    end


    private

    def update_foreign_lines entry
      return if entry.foreign_lines.empty?
      workbench_import.messages.create(
        criticity: :error,
        message_key: 'foreign_lines_in_referential',
        message_attributes: {
          'source_filename' => workbench_import.file.file.file,
          'foreign_lines'   => entry.foreign_lines.join(', ')
        }) 
    end

    def update_spurious entry
      return if entry.spurious.empty?
      workbench_import.messages.create(
        criticity: :error,
        message_key: 'inconsistent_zip_file',
        message_attributes: {
          'source_filename' => workbench_import.file.file.file,
          'spurious_dirs'   => entry.spurious.join(', ')
        }) 
    end
  end
end
