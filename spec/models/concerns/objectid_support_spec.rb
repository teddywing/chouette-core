RSpec.describe ObjectidSupport do 

  context 'when referential has an objectid format of stif_netex' do
    let(:route) { create(:route_with_after_commit, objectid: nil) }

    context "#objectid_format" do 
      it "should be stif_netex" do
        expect(route.referential.objectid_format).not_to be_nil
        expect(route.referential.objectid_format).to eq('stif_netex')
      end
    end

    context "#get_objectid" do
      let(:objectid) { route.get_objectid }
      it "should be valid" do
        expect(objectid).to be_valid
      end

      it "should have the same local id than the object" do
        expect(objectid.local_id).to eq(route.local_id)
      end

      it "should be a Chouette::Objectid::StifNetex" do
        expect(objectid).to be_kind_of(Chouette::Objectid::StifNetex)
      end

      context "#to_s" do
        it "should return a string" do
          expect(objectid.to_s).to be_kind_of(String)
        end

        it "should be the same as the db attribute" do 
          expect(objectid.to_s).to eq(route.read_attribute(:objectid))
          expect(objectid.to_s).to eq(route.objectid)
        end
      end
    end
  end

  # context 'when referential has an objectid format of netex' do
  #   let(:line) { create(:route_with_after_commit, objectid: nil) }

  #   before(:all) do 
  #     binding.pry
  #     route.referential.objectid_format = 'netex'
  #   end 

  #   context "#objectid_format" do 
  #     it "should be netex" do
  #       expect(route.objectid_format).to eq('netex')
  #     end
  #     it "should be the same as the referential" do
  #       expect(route.objectid_format).to eq(route.referential.objectid_format)
  #     end
  #   end

  #   context "#get_objectid" do
  #     let(:objectid) { route.get_objectid }
  #     it "should be valid" do
  #       expect(objectid).to be_valid
  #     end

  #     it "should have the same local id than the object" do
  #       expect(objectid.local_id).to eq(route.local_id)
  #     end

  #     it "should be a Chouette::Objectid::Netex" do
  #       expect(objectid).to be_kind_of(Chouette::Objectid::Netex)
  #     end

  #     context "#to_s" do
  #       it "should return a string" do
  #         expect(objectid.to_s).to be_kind_of(String)
  #       end

  #       it "should be the same as the db attribute" do 
  #         expect(objectid.to_s).to eq(route.read_attribute(:objectid))
  #         expect(objectid.to_s).to eq(route.objectid)
  #       end
  #     end
  #   end
  # end


end