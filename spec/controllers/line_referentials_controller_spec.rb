RSpec.describe LineReferentialsController, :type => :controller do
  login_user

  let(:line_referential) { create :line_referential }

  describe 'PUT sync' do
    let(:request){ put :sync, id: line_referential.id }

    it 'should redirect to 403' do
       expect(request).to redirect_to "/403"
    end

    with_permission "line_referentials.synchronize" do
      it 'returns HTTP success' do
        expect(request).to redirect_to [line_referential]
      end
    end
  end
end
