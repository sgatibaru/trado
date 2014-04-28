require 'spec_helper'

describe Shipping do

    # ActiveRecord relations
    it { expect(subject).to have_many(:tiereds).dependent(:delete_all) }
    it { expect(subject).to have_many(:tiers).through(:tiereds) }
    it { expect(subject).to have_many(:destinations).dependent(:delete_all) }
    it { expect(subject).to have_many(:zones).through(:destinations) }
    it { expect(subject).to have_many(:countries).through(:zones) }
    it { expect(subject).to have_many(:orders).dependent(:restrict) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:price) }
    it { expect(subject).to validate_presence_of(:description) }

    it { expect(subject).to validate_uniqueness_of(:name) }

    it { expect(subject).to ensure_length_of(:name).is_at_least(10) }
    it { expect(subject).to ensure_length_of(:description).is_at_most(200) }

    describe "When a used shipping is updated or deleted" do
        let(:shipping) { create(:shipping, active: true) }

        it "should set the record as inactive" do
            shipping.inactivate!
            expect(shipping.active).to eq false
        end
    end

    describe "When the new shipping fails to update" do
        let(:shipping) { create(:shipping) }

        it "should set the record as active" do
            shipping.activate!
            expect(shipping.active).to eq true
        end
    end
    describe "Listing all products" do
        let!(:shipping_1) { create(:shipping, active: true) }
        let!(:shipping_2) { create(:shipping) }
        let!(:shipping_3) { create(:shipping, active: true) }

        it "should return an array of 'active' shippings" do
            expect(Shipping.active).to match_array([shipping_1, shipping_3])
        end
    end

end