module ZipSupport
  module CreateZipData

    class ZipData < Struct.new(:name, :data) 
      def write_to file
        File.write(file, data)
      end
    end

    class Implementation

      attr_reader :zip

      def initialize name
        @zip = ZipData.new(name, '') 
      end

      def make_from names_to_content_map
        os = Zip::OutputStream.write_buffer do | zio |
          names_to_content_map.each do |name_content_pair|
            p name_content_pair
            zio.put_next_entry(name_content_pair.first)
            zio.write(name_content_pair.last)
          end
        end
        zip.data = os.string
        zip
      end


      private

      def add_entries for_output_stream
        -> *args do
          file_output_stream.put_next_entry(args.first)
          file_output_stream.write args.second
        end
      end
    end


    def make_zip(name, names_to_content_map = {})
      Implementation.new(name).make_from(names_to_content_map)
    end
  end
end

RSpec.configure do |conf|
  conf.include ZipSupport::CreateZipData, type: :zip
end
