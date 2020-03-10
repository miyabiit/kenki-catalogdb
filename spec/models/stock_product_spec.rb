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

    context 'match with through(has_many) relation' do
      let(:search_params) {
        { sub_categories: { name: 'hoge' } }
      }
      let!(:matched) { create :stock_product }
      let!(:unmatched) { create :stock_product }
      before do
        matched.sub_categories << build(:sub_category, name: 'hoge')
        unmatched.sub_categories << build(:sub_category, name: 'piyo')
      end
      it do
        expect(subject.to_a&.map(&:id)).to eq([matched.id])
      end
    end

    context 'match with belongs_to relation' do
      let(:search_params) {
        { product: { title: 'hoge' } }
      }
      let!(:matched) { create :stock_product, product: create(:product, title: 'hoge') }
      let!(:unmatched) { create :stock_product, product: create(:product, title: 'piyo') }
      it do
        expect(subject.to_a&.map(&:id)).to eq([matched.id])
      end
    end

    context '$or condition (array value)' do
      let(:search_params) {
        {'$or' =>
          [
            { product: { title: 'hoge' } },
            { description: 'hoge' },
          ]
        }
      }
      let!(:matched1) { create :stock_product, product: create(:product, title: 'hoge') }
      let!(:matched2) { create :stock_product, description: 'hoge' }
      let!(:unmatched) { create :stock_product, description: 'piyo' }
      it do
        expect(subject.to_a&.map(&:id)).to match_array([matched1.id, matched2.id])
      end
    end

    context '$or condition (hash value)' do
      let(:search_params) {
        {'$or' =>
          { 
            product: { title: 'hoge' },
            description: 'hoge'
          }
        }
      }
      let!(:matched1) { create :stock_product, product: create(:product, title: 'hoge') }
      let!(:matched2) { create :stock_product, description: 'hoge' }
      let!(:unmatched) { create :stock_product, description: 'piyo' }
      it do
        expect(subject.to_a&.map(&:id)).to match_array([matched1.id, matched2.id])
      end
    end

    context 'complex condition' do
      let(:search_params) {
        {'$or' =>
          { 
            product: { 
              '$or' => {
                title: 'hoge',
                product_name: { '$like' => 'hoge' },
              }
            },
            description: { '$eq' => 'hoge' }
          }
        }
      }
      let!(:matched1) { create :stock_product, product: create(:product, title: 'hoge1') }
      let!(:matched2) { create :stock_product, product: create(:product, product_name: 'hoge2') }
      let!(:matched3) { create :stock_product, description: 'hoge' }
      let!(:unmatched) { create :stock_product, description: 'hogehoge' }
      it do
        expect(subject.to_a&.map(&:id)).to match_array([matched1.id, matched2.id, matched3.id])
      end
    end
  end
end
