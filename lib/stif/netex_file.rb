module STIF
  class NetexFile

    CALENDAR_FILE_NAME = 'calendriers.xml'
    LINE_FILE_FORMAT = /^offre_.*\.xml$/
    XML_NAME_SPACE = "http://www.netex.org.uk/netex"

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
          when LINE_FILE_FORMAT
            frames[entry_dir_name].add_offer_file(entry_file_name)
          end
        end
      end
      frames.values
    end

  end

  class NetexFile::Frame

    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def parse_calendars(calendars)
      # <netex:ValidBetween>
      #  <netex:FromDate>2017-03-01</netex:FromDate>
      #  <netex:ToDate>2017-03-31</netex:ToDate>
      # </netex:ValidBetween>
      xml = Nokogiri::XML(calendars)
      xml.xpath("//netex:ValidBetween", "netex" => NetexFile::XML_NAME_SPACE).each do |valid_between|
        from_date = valid_between.xpath("netex:FromDate").try :text
        to_date = valid_between.xpath("netex:ToDate").try :text
        periods << Range.new(Date.parse(from_date), Date.parse(to_date))
      end
    end

    LINE_FORMAT = /^offre_.*\.xml$/

    def add_offer_file(file_name)
      if file_name =~ /^offre_([^_]*)_/
        line_refs << $1
      end
    end

    def periods
      @periods ||= []
    end

    def line_refs
      @line_refs ||= []
    end

  end
end
