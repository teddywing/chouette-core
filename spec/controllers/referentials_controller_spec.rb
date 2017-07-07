describe ReferentialsController, :type => :controller do

  login_user

  let(:referential) { Referential.first }
  let(:organisation) { create :organisation }
  let(:other_referential) { create :referential, organisation: organisation }

  describe 'PUT archive' do
    context "user's organisation matches referential's organisation" do
      it 'returns http success' do
        put :archive, id: referential.id
        expect(response).to have_http_status(302)
      end
    end

    context "user's organisation doesn't match referential's organisation" do
      it 'raises a ActiveRecord::RecordNotFound' do
        expect { put :archive, id: other_referential.id }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

end
