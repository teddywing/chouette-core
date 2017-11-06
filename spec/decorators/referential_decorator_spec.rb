RSpec.describe ReferentialDecorator, type: [:helper, :decorator] do

  let( :object ){ build_stubbed :referential }
  let( :referential ){ object }
  let( :user ){ build_stubbed :user }

  describe 'delegation' do
    it 'delegates all' do
      %i{xx xxx anything save!}.each do |method|
        expect( object ).to receive(method)
      end
      # Almost as powerful as Quicktest :P
      %i{xx xxx anything save!}.each do |method|
        subject.send method
      end
    end
  end

  describe 'action links for' do

    context 'unarchived referential' do
      context 'no rights' do
        it 'has only a Calendar action' do
          expect_action_link_hrefs.to eq([referential_time_tables_path(object)])
        end
      end

      context 'all rights and different organisation' do

        let( :user ){ build_stubbed :allmighty_user }

        it 'has only default actions' do
          expect_action_link_elements.to be_empty
          expect_action_link_hrefs.to eq([
            referential_time_tables_path(object),
            new_referential_path(from: object),
            referential_select_compliance_control_set_path(object)
          ])
        end
      end
      context 'all rights and same organisation' do

        let( :user ){ build_stubbed :allmighty_user, organisation: referential.organisation }

        it 'has all actions' do
          expect_action_link_elements.to eq(%w{Purger})
          expect_action_link_hrefs.to eq([
            referential_time_tables_path(object),
            new_referential_path(from: object),
            referential_select_compliance_control_set_path(object),
            archive_referential_path(object),
            referential_path(object)
          ])
        end
      end
    end

    context 'archived referential' do
      before { referential.archived_at = 42.seconds.ago }
      context 'no rights' do
        it 'has only a Calendar action' do
          expect_action_link_hrefs.to eq([referential_time_tables_path(object)])
        end
      end

      context 'all rights and different organisation' do
        let( :user ){ build_stubbed :allmighty_user }
        it 'has only default actions' do
          expect_action_link_elements.to be_empty
          expect_action_link_hrefs.to eq([
            referential_time_tables_path(object),
          ])
        end
      end
    end
  end


end
