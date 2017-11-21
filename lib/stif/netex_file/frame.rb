module STIF
  class NetexFile
    class Frame

      class << self
        def get_line_object_id file_name
          STIF::NetexFile.line_file_format.match(file_name).try(:[], 1)
        end
      end

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

      def add_offer_file(line_object_id)
        line_refs << line_object_id
      end

      def periods
        @periods ||= []
      end

      def line_refs
        @line_refs ||= []
      end

    end
  end
end
