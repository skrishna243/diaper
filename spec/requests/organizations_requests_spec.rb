require 'rails_helper'

RSpec.describe "OrganizationRequests", type: :request do
  let(:default_params) { { organization_id: @organization.to_param } }

  context "While signed in as a normal user" do
    before do
      sign_in(@user)
      # get organization_path(default_params)
    end

    describe "GET #show" do
      before { get organization_path(default_params) }

      it "is successful" do
        expect(response).to have_http_status :ok
      end
    end

    describe "GET #edit" do
      before { get edit_organization_path(default_params) }

      it "denies access and redirects with an error" do
        expect(response).to redirect_to dashboard_path(default_params)
        # expect(flash[:error]).to be_present
      end

      describe "PATCH #update" do
        before do
          update_params = { organization: { name: "Thunder Pants" } }
          patch "/#{@organization.id}/manage", params: update_params
        end
        subject { patch :update, params: default_params.merge(organization: { name: "Thunder Pants" }) }

        it "denies access" do
          expect(response).to redirect_to dashboard_path(default_params)
          expect(@organization.name).to eq @organization.reload.name
        end
      end
    end

  end

end
