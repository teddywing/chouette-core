RSpec.describe ReferentialSuitesController do

  describe 'routing' do
    let( :workbench_id ){ random_int }

    it 'routes from workbench/:id/output' do
      expect( get( "/workbenches/#{workbench_id}/output" ) ).to route_to(
        controller: 'referential_suites',
        action: 'index',
        workbench_id: workbench_id.to_s
      )
    end
  end

end



