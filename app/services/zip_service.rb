class ZipService

  class Subdir < Struct.new(:name, :stream, :spurious, :foreign_lines)
    def ok?
      foreign_lines.empty? && spurious.empty?
    end
  end

  attr_reader :allowed_lines, :current_key, :foreign_lines, :current_output, :current_spurious, :yielder

  def initialize data, allowed_lines
    @zip_data       = StringIO.new(data)
    @allowed_lines  = allowed_lines
    @current_key    = nil
    @current_output = nil
  end

  def subdirs
    Enumerator.new do |yielder|
      @yielder = yielder
      Zip::File.open_buffer(@zip_data, &(method :_subdirs))
    end
  end

  def _subdirs zip_file
    zip_file.each do | entry |
      add_entry entry
    end
    finish_current_output
  end

  def add_entry entry
    key = entry_key entry
    unless key == current_key
      finish_current_output
      open_new_output key
    end
    add_to_current_output entry
  end

  def add_to_current_output entry
    return if is_spurious!(entry.name) || is_foreign_line!(entry.name)

    current_output.put_next_entry entry.name
    write_to_current_output entry.get_input_stream
  end

  def write_to_current_output input_stream
    # the condition below is true for directory entries
    return if Zip::NullInputStream == input_stream
    current_output.write input_stream.read 
  end

  def finish_current_output
    if current_output
      @yielder  << Subdir.new(
        current_key,
        # Second part of the solution, yield the closed stream
        current_output.close_buffer,
        current_spurious.to_a,
        foreign_lines)
    end
  end

  def open_new_output entry_key
    @current_key    = entry_key
    # First piece of the solution, use internal way to create a Zip::OutputStream
    @current_output   = Zip::OutputStream.new(StringIO.new(''), true, nil)
    @current_spurious = Set.new
    @foreign_lines    = []
  end

  def entry_key entry
    # last dir name File.dirname.split("/").last
    entry.name.split('/').first
  end

  def is_spurious! entry_name
    segments = entry_name.split('/', 3)
    return false if segments.size < 3

    current_spurious << segments.second
    return true
  end

  def is_foreign_line! entry_name
    STIF::NetexFile::Frame.get_line_object_id(entry_name).tap do | line_object_id |
      return nil unless line_object_id
      return nil if line_object_id.in? allowed_lines
      foreign_lines << line_object_id
    end
  end
end
