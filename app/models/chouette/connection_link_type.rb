module Chouette
  class ConnectionLinkType < ActiveSupport::StringInquirer

    def initialize(text_code, numerical_code)
      super text_code.to_s
      @numerical_code = numerical_code
    end

    def to_i
      @numerical_code
    end

    def inspect
      "#{to_s}/#{to_i}"
    end

    def name
      camelize
    end

    class << self
      attr_reader :definitions
      @definitions = [
        ["underground", 0],
        ["mixed", 1],
        ["overground", 2]
      ]
      @all = nil

      def new(text_code, numerical_code = nil)
        if text_code and numerical_code
          super
        elsif self === text_code 
          text_code
        else
          if Fixnum === text_code
            text_code, numerical_code = definitions.rassoc(text_code)
          else
            text_code, numerical_code = definitions.assoc(text_code.to_s)
          end

          super text_code, numerical_code
        end
      end

      def all
        @all ||= definitions.collect do |text_code, numerical_code|
          new(text_code, numerical_code)
        end
      end

    end
  end
end