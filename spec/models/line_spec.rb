require 'spec_helper'

describe Chouette::Line, type: :model do

  subject { create(:line) }

  it { is_expected.to belong_to(:line_referential) }

end
