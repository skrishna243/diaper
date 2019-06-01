require 'rails_helper'

RSpec.describe "AdminRequests", type: :request do
  context "while signed in as a super admin" do
    before do
      sign_in(@super_admin_no_org)
    end

    subject do
      get admin_dashboard_url
      response
    end

    it "allows a user to load the dashboard" do
      expect(subject).to be_successful
    end

    # TODO: May be better suited for a system test
    it "shows a logout button" do
      expect(subject.body).to match(/log out/im)
    end
  end

  # Since all Admin namespace actions inherit from AdminController, this will serve as a
  # blanket check for access for non-super-admins
  context "while signed in as a non-super-admin" do
    subject do
      get admin_dashboard_url
      response
    end

    it "disallows dashboard access, redirecting to the normal dashboard" do
      [@organization_admin, @user].each do |u|
        sign_in(u)
        expect(subject).to redirect_to(dashboard_path(organization_id: @organization.to_param))
      end
    end

    # TODO: May be better suited for a system test
    it 'displays an alert message' do
      sign_in(@user)
      expect(subject).to redirect_to(dashboard_path(organization_id: @organization.to_param))
      follow_redirect!
      assert_select ".alert", /Access Denied/
    end
  end
end
