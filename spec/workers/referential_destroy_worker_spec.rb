require 'rails_helper'
RSpec.describe ReferentialDestroyWorker, type: :worker do
  let!(:referential) { create :referential }

  it 'should destroy referential on worker perform' do
    expect{ReferentialDestroyWorker.new.perform(referential.id)}.to change(Referential, :count).by(-1)
  end
end
