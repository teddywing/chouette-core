class Calendar
  class CalendarDate < ::Date

    module IllegalDate
      attr_reader :year, :month, :day
      def to_s(*_args)
        "%d-%02d-%02d" % [year, month, day]
      end
    end

    def self.new(*args)
      super(*args)
    rescue
      o = allocate()
      o.instance_exec do
        @illegal = true
        @year, @month, @day = args
        extend IllegalDate
      end
      o
    end

    def self.from_date(date)
      new date.year, date.month, date.day
    end

    def legal?; !!!@illegal end
  end
end
