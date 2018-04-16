namespace :check do
  desc "Check routes stop_points positions are valid"
  task routes_integrity: :environment do
    errors = []
    max = Referential.pluck(:name).map(&:size).max + 20
    Referential.find_each do |r|
      r.switch do
        Chouette::Route.find_each do |route|
          positions = route.stop_points.pluck(:position)
          if positions.size != positions.uniq.size
            lb = "Referential: #{r.id}/#{r.name}"
            errors << "#{lb + " "*(max-lb.size)} -> Wrong positions in Route #{route.id} : #{positions.inspect} "
          end
        end
      end
    end
    puts errors.join("\n")
  end
end
