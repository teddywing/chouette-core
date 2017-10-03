# require 'rails_helper'
#
# RSpec.describe ComplianceControlSetsController, type: :controller do
#   login_user
#
#   let(:compliance_control_set) { create :compliance_control_set }
#
#   describe "GET show" do
#     it 'should be successful' do
#       get :show, id: compliance_control_set.id
#       expect(response).to be_success
#     end
#   end
#
#   describe "GET index" do
#     it 'should be successful' do
#       get :index, id: compliance_control_set.id
#       expect(response).to be_success
#     end
#   end
#
#   describe "GET #edit" do
#     it 'should be successful' do
#       get :edit, id: compliance_control_set.id
#       expect(response).to be_success
#     end
#   end
#
#   describe 'GET #new' do
#     it 'should be successful' do
#       get :new, id: compliance_control_set.id
#       expect(response).to be_success
#     end
#   end
#
#   describe 'POST #create' do
#     it 'should be successful' do
#       post :create, compliance_control_set: build(:compliance_control_set).as_json
#       expect(response).to have_http_status(302)
#       # expect(flash[:notice]).to eq(I18n.t('notice.compliance_control.created'))
#     end
#   end
#
#   describe 'POST #update' do
#     it 'should be successful' do
#       post :update, id: compliance_control_set.id, compliance_control_set: compliance_control_set.as_json
#       expect(response).to redirect_to compliance_control_set_path(compliance_control_set)
#       # expect(flash[:notice]).to eq(I18n.t('notice.compliance_control.updated'))
#     end
#   end
#
#   describe 'DELETE #destroy' do
#     it 'should be successful' do
#       delete :destroy, id: compliance_control_set.id
#       # expect(flash[:notice]).to eq I18n.t('notice.compliance_control.destroyed')
#     end
#   end
#
#
# end
