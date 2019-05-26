require 'rails_helper'

RSpec.describe "OrganizationRequests", type: :request do
  let(:default_params) { { organization_id: @organization.to_param } }

  context "While signed in as a normal user" do
    before do
      sign_in(@user)
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
        follow_redirect!
        assert_select ".alert", /Access Denied/
      end

      describe "PATCH #update" do
        before do
          update_params = { organization: { name: "Thunder Pants" } }
          patch "/#{@organization.id}/manage", params: update_params
        end

        it "denies access" do
          expect(response).to redirect_to dashboard_path(default_params)
          expect(@organization.name).to eq @organization.reload.name
        end
      end
    end
  end

  context "While signed in as an organization admin" do
    before do
      sign_in(@organization_admin)
    end

    describe "GET #edit" do
      before { get edit_organization_path(default_params) }

      it "is successful" do
        expect(response).to have_http_status :ok
      end
    end

    describe "PATCH #update" do
      before do
        update_params = { organization: { name: "Thunder Pants" } }
        patch "/#{@organization.id}/manage", params: update_params
      end

      it "can update name" do
        expect(response).to redirect_to organization_path(default_params)
        expect(@organization.name).to eq "Thunder Pants"
      end
    end

    context "when attempting to access a different organization" do
      let(:other_organization_params) do
        { organization_id: create(:organization).to_param }
      end

      describe "GET #show" do
        it "redirects to dashboard" do
          get organization_path other_organization_params
          expect(response).to redirect_to dashboard_path(other_organization_params)
        end
      end

      describe "GET #edit" do
        it "redirects to dashboard" do
          get edit_organization_path other_organization_params
          expect(response).to redirect_to dashboard_path(other_organization_params)
        end
      end
    end
  end
end
