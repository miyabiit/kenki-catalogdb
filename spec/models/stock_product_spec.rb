require 'rails_helper'

RSpec.describe StockProduct, type: :model do
  describe '#search' do
    subject { StockProduct.search(search_params) }

    context 'simple match' do
      let(:search_params) {
        { spec: 'hoge' }
      }
      let!(:matched) { create :stock_product, spec: 'hoge' }
      let!(:unmatched) { create :stock_product, spec: 'piyo' }
      it do
        expect(subject.to_a&.map(&:spec)).to eq(['hoge'])
      end
    end

    context 'match with has many relation' do
    end

    context 'match with through(has_many) relation' do
    end

    context 'match with belongs_to relation' do
    end

    context '$or condition' do
    end

    context 'complex condition' do
    end
  end
end
