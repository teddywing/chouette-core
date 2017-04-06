module TimeTablesHelper

  def month_periode_enum(years)
    start_date = Date.today - years.years
    end_date   = Date.today + years.years
    (start_date..end_date).map(&:beginning_of_month).uniq.map(&:to_s)
  end
end

