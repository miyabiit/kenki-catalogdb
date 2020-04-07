require 'rails_helper'

RSpec.describe ProductImport, type: :model do
  subject { ProductImport.new.process_csv(csv) }

  describe '#process_csv' do
    context 'create case' do
      let(:csv) {
        [
          { product_name: 'PRODUCT1', title: 'プロダクト1',  product_code: 'CODE1', manufacture_name: 'ほげ建機1', product_model_name: 'モデル1', product_short_name: 'PRO1' },
          { product_name: 'PRODUCT2', title: 'プロダクト2',  product_code: 'CODE2', manufacture_name: 'ほげ建機2', product_model_name: 'モデル2', product_short_name: 'PRO2' },
        ].map(&:deep_stringify_keys)
      }
      it do
        expect(subject).to be_empty
        expect(Product.all.map(&:product_name)).to match_array(['PRODUCT1', 'PRODUCT2'])
        product = Product.find_by_product_name('PRODUCT1')
        expect(product.title).to eq('プロダクト1')
        expect(product.product_code).to eq('CODE1')
        expect(product.manufacture_name).to eq('ほげ建機1')
        expect(product.product_model_name).to eq('モデル1')
        expect(product.product_short_name).to eq('PRO1')
      end
    end
    context 'create & update mixed case' do
      let(:csv) {
        [
          { product_name: 'PRODUCT1', title: 'プロダクト1',  product_code: 'CODE1', manufacture_name: 'ほげ建機1', product_model_name: 'モデル1', product_short_name: 'PRO1' },
          { product_name: 'PRODUCT2', title: 'プロダクト2',  product_code: 'CODE2', manufacture_name: 'ほげ建機2', product_model_name: 'モデル2', product_short_name: 'PRO2' },
        ].map(&:deep_stringify_keys)
      }
      before do
        create :product, product_name: 'PRODUCT1', product_code: 'CODE1'
      end
      it do
        expect(subject).to be_empty
        expect(Product.all.map(&:product_name)).to match_array(['PRODUCT1', 'PRODUCT2'])
        product = Product.find_by_product_name('PRODUCT1')
        expect(product.title).to eq('プロダクト1')
        expect(product.product_code).to eq('CODE1')
        expect(product.manufacture_name).to eq('ほげ建機1')
        expect(product.product_model_name).to eq('モデル1')
        expect(product.product_short_name).to eq('PRO1')
      end
    end
    context 'error case' do
      let(:csv) {
        [
          { product_name: '', title: '1',  product_code: '', manufacture_name: '', product_model_name: '', product_short_name: '' },
        ].map(&:deep_stringify_keys)
      }
      it do
        expect(subject.count).to eq(1)
        failed_instance = subject.first
        expect(failed_instance.errors).to be_added(:product_code, :blank) 
      end
    end
  end
end
