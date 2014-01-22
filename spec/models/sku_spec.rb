require 'spec_helper'

describe Sku do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:product) }
    it { expect(subject).to belong_to(:accessory) }
    it { expect(subject).to belong_to(:attribute_type) }
    it { expect(subject).to have_many(:cart_items) }
    it { expect(subject).to have_many(:carts).through(:cart_items) }
    it { expect(subject).to have_many(:order_items).dependent(:restrict) }
    it { expect(subject).to have_many(:orders).through(:order_items).dependent(:restrict) }
    it { expect(subject).to have_many(:notifications).dependent(:delete_all) }

    # Validation
    it { expect(subject).to validate_presence_of(:price) }
    it { expect(subject).to validate_presence_of(:cost_value) }
    it { expect(subject).to validate_presence_of(:stock) }
    it { expect(subject).to validate_presence_of(:length) }
    it { expect(subject).to validate_presence_of(:weight) }
    it { expect(subject).to validate_presence_of(:thickness) }
    it { expect(subject).to validate_presence_of(:stock_warning_level) }
    it { expect(subject).to validate_presence_of(:attribute_type_id) }

    it { expect(subject).to validate_numericality_of(:length).is_greater_than_or_equal_to(0) }
    it { expect(subject).to validate_numericality_of(:weight).is_greater_than_or_equal_to(0) }
    it { expect(subject).to validate_numericality_of(:thickness).is_greater_than_or_equal_to(0) } 
    it { expect(subject).to validate_numericality_of(:stock).is_greater_than_or_equal_to(1) } 
    it { expect(subject).to validate_numericality_of(:stock_warning_level).is_greater_than_or_equal_to(1) } 
    it { expect(subject).to validate_numericality_of(:stock).only_integer } 
    it { expect(subject).to validate_numericality_of(:stock_warning_level).only_integer } 

    it { expect(create(:sku)).to validate_uniqueness_of(:sku).scoped_to(:active) }

    context "When a used SKU is updated or deleted" do

        it "should set the record as inactive" do
            sku = create(:sku)
            sku.inactivate!
            expect(sku.active).to eq false
        end
    end

    context "When creating a new SKU" do

        it "should validate whether the stock value is higher than stock_warning_level" do
            sku = build(:sku, stock: 5, stock_warning_level: 10)
            expect(sku).to have(1).error_on(:sku)
        end

        it "should assign new SKU value by using the product SKU as a prefix" do
            sku = create(:sku)
            expect(sku.sku).to eq "#{sku.product.sku}-#{sku.attribute_value}"
        end

    end

    it "should return an array of active SKUs" do
        sku_1 = create(:sku, active: false)
        sku_2 = create(:sku)
        sku_3 = create(:sku, active: false)
        expect(Sku.active).to match_array([sku_2])
    end

end