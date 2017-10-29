RSpec.describe "ComplianceControlSets", type: :feature do

  login_user

  # We setup a control_set with two blocks and one direct control (meaning that it is not attached to a block)
  # Then we add one control to the first block and two controls to the second block
  let( :control_set ){ create :compliance_control_set, organisation: organisation }
  let( :controls ){ control_set.compliance_controls }

  let(:blox){
    2.times.map{ | _ | create :compliance_control_block, compliance_control_set: control_set }
  }
  let( :controls_hash ){ Hash.new{ |h, k| h[k] = [] } }


  before do
    blox.first.update transport_mode: 'bus', transport_submode: 'bus'
    blox.second.update transport_mode: 'train', transport_submode: 'train'

    make_control
    make_control blox.first, severity: :error
    make_control blox.second, times: 2
  end

  describe 'show' do
    before do
      visit compliance_control_set_path( control_set )
    end

    it 'we can see the controls inside their blocks' do
      controls.each do | control |
        expect( page ).to have_content(control.code)
      end
    end

    it 'we can apply a filter' do
      within('#severity-filter') do
        find('input[value="error"]').click
      end
      click_on('Filtrer')
      controls_hash['error'].each do
        expect( page ).to have_content(control.code)
      end
      controls_hash['warning'].each do
        expect( page ).not_to have_content(control.code)
      end
    end

  end

  def make_control ccblock=nil, times: 1, severity: :warning
    times.times do
      make_one_control ccblock, severity
    end
  end

  def make_one_control ccblock, severity
      create( :generic_attribute_control_min_max,
        code: random_string,
        compliance_control_block: ccblock,
        compliance_control_set: control_set,
        criticity: severity ).tap do | ctrl |
          controls_hash[severity] << ctrl
        end
  end

end
