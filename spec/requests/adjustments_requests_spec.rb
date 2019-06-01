require 'rails_helper'

RSpec.describe "AdjustmentsRequests", type: :request do
  let(:default_params) { { organization_id: @organization.to_param } }

  # This should return the minimal set of attributes required to create a valid
  # Adjustment. As you add validations to Adjustment, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { adjustment: {
      organization_id: @organization.id,
      storage_location_id: create(:storage_location,
                                  organization: @organization).id
    } }
  end

  let(:invalid_attributes) do
    { adjustment: { organization_id: nil } }
  end

  describe "while signed in" do
    before do
      sign_in(@user)
    end

    describe "GET #index" do
      it "is successful" do
        Adjustment.create! valid_attributes[:adjustment]
        get adjustments_url(default_params)
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "is successful" do
        adjustment = create(:adjustment, organization: @organization)
        get adjustments_url(default_params.merge(id: adjustment.to_param))
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "is successful" do
        get new_adjustment_url(default_params)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        subject do
          post adjustments_url(default_params), params: valid_attributes
          response
        end

        it "creates a new Adjustment" do
          expect { subject }.to change(Adjustment, :count).by(1)
        end

        it "redirects to the #show after created adjustment" do
          expect(subject).to redirect_to adjustment_path(Adjustment.last)
        end
      end

      context "with invalid params" do
        subject do
          post adjustments_url(default_params), params: invalid_attributes
          response
        end

        it "does not create an Adjustment" do
          expect { subject }.to_not change(Adjustment, :count)
        end

        # TODO: May be better suited for a system test
        it "responds with a 200 and an alert" do
          expect(subject).to have_http_status :ok
          assert_select ".alert"
        end
      end
    end
  end
end
