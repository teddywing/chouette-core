module Api
  module V1
    class ApiKey < ::ApplicationModel
      include MetadataSupport
      has_metadata
      before_create :generate_access_token
      belongs_to :referential, :class_name => '::Referential'
      belongs_to :organisation, :class_name => '::Organisation'

      validates_presence_of :organisation

      class << self
        def from(referential, name:)
          find_or_create_by!(name: name, referential: referential)
        end

        def referential_from_token(token)
          array = token.split('-')
          if !array.first.empty? && array.size > 1
            ::Referential.find array.first
          end
        end

        def model_name
          ActiveModel::Name.new self, Api::V1, self.name.demodulize
        end

        def organisation_from_token(token)
          array = token.split('-')
          if !array[1].empty? && array.size > 1
            ::Organisation.find array[1]
          end
        end
      end

      def eql?(other)
        return false unless other.respond_to?( :token)
        other.token == self.token
      end


    private
      def generate_access_token
        begin
          self.token = "#{referential_id}-#{organisation_id}-#{SecureRandom.hex}"
        end while self.class.exists?(:token => self.token)
      end
    end
  end
end
