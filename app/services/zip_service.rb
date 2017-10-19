class ZipService

  class Subdir < Struct.new(:name, :stream, :spurious)
  end

  attr_reader :current_key, :current_output, :current_spurious, :yielder

  def initialize data
    @zip_data       = StringIO.new(data)
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
    return if is_spurious! entry.name
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
        current_spurious)
    end
  end

  def open_new_output entry_key
    @current_key    = entry_key
    # First piece of the solution, use internal way to create a Zip::OutputStream
    @current_output = Zip::OutputStream.new(StringIO.new(''), true, nil)
    @current_spurious = []
  end

  def entry_key entry
    # last dir name File.dirname.split("/").last
    entry.name.split('/', -1)[-2]
  end

  def is_spurious! entry_name
    segments = entry_name.split('/', 3)
    return false if segments.size < 3

    current_spurious << segments.second
    return true
  end
end
