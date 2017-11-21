require_relative 'netex_file/frame'

module STIF
  class NetexFile

    CALENDAR_FILE_NAME = 'calendriers.xml'
    XML_NAME_SPACE = "http://www.netex.org.uk/netex"

    class << self
      def line_file_format; %r{\A offre_ (.*?) _ .* \. xml \z}x end
    end

    def initialize(file_name)
      @file_name = file_name
    end

    def frames
      frames = Hash.new { |h,k| h[k] = NetexFile::Frame.new(k) }
      Zip::File.open(@file_name) do |zipfile|
        zipfile.each do |entry|
          next unless entry.ftype == :file

          entry_dir_name, entry_file_name = File.split(entry.name)
          case entry_file_name
          when CALENDAR_FILE_NAME
            entry.get_input_stream do |stream|
              frames[entry_dir_name].parse_calendars(stream.read)
            end
          when self.class.line_file_format
            frames[entry_dir_name].add_offer_file($1)
          end
        end
      end
      frames.values
    end

  end
end
