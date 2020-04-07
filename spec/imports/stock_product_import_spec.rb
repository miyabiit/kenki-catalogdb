require 'rails_helper'

RSpec.describe StockProductImport, type: :model do
  let(:company) { create :company }
  subject { StockProductImport.new(company.id).process_csv(csv) }

  describe '#process_csv' do
    let(:product) { create(:product) }
    let(:category) { create(:category, company: company) }

    context 'create case' do
      let(:csv) {
        [
          { product_id: '', company_id: '', category_id: '',  spec: 'テスト1', charterable: 'TRUE', category_name: category.name, product_code: product.product_code }
        ].map(&:deep_stringify_keys)
      }
      it do
        expect(subject).to be_empty
        expect(StockProduct.all.map(&:spec)).to match_array(['テスト1'])
        stock_product = StockProduct.find_by_spec('テスト1')
        expect(stock_product.charterable).to be_truthy
      end
    end
    context 'product not exists' do
      let(:csv) {
        [
          { product_id: '', company_id: '', category_id: '',  spec: 'テスト1', charterable: 'TRUE', category_name: category.name, product_code: 'invalid' }
        ].map(&:deep_stringify_keys)
      }
      it do
        expect(subject).not_to be_empty
        expect(StockProduct.all.count).to eq(0)
      end
    end
    context 'category not exists' do
      let(:csv) {
        [
          { product_id: '', company_id: '', category_id: '',  spec: 'テスト1', charterable: 'TRUE', category_name: 'invalid', product_code: product.product_code }
        ].map(&:deep_stringify_keys)
      }
      it do
        expect(subject).not_to be_empty
        expect(StockProduct.all.count).to eq(0)
      end
    end
  end
end
