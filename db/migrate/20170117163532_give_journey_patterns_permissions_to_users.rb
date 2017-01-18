class GiveJourneyPatternsPermissionsToUsers < ActiveRecord::Migration
  def change
    User.find_each do |user|
      user.permissions += ['journey_patterns.create', 'journey_patterns.edit', 'journey_patterns.destroy']
      user.save!
    end
  end
end
