require 'rails_helper'

RSpec.describe CategoryImport, type: :model do
  let(:company) { create :company }
  subject { CategoryImport.new(company.id).process_csv(csv) }

  describe '#process_csv' do
    context 'create case' do
      before do
        @parent = create(:category, company: company, name: 'Parent')
      end

      let(:csv) {
        [
          {category_id: '', company_id: '', name: 'カテゴリ1', position: 1, last: 'FALSE', parent_category_name: ''},
          {category_id: '', company_id: '', name: 'カテゴリ2', position: 2, last: 'TRUE', parent_category_name: 'カテゴリ1'},
          {category_id: '', company_id: '', name: 'カテゴリ3', position: 3, last: 'TRUE', parent_category_name: 'Parent'}
        ].map(&:deep_stringify_keys)
      }

      it do
        expect(subject).to be_empty
        expect(Category.where(company_id: company.id).map(&:name)).to match_array(['Parent', 'カテゴリ1', 'カテゴリ2', 'カテゴリ3'])
        expect(Category.where(company_id: company.id).find_by_name('カテゴリ2').category.id).to eq(Category.find_by_name('カテゴリ1').id)
        expect(Category.where(company_id: company.id).find_by_name('カテゴリ3').category.id).to eq(@parent.id)
      end
    end

    context 'create & update mixed case' do
      before do
        @category_a = create(:category, company: company, name: 'カテゴリA')
        @category_b = create(:category, company: company, name: 'カテゴリB', category: @category_a)
      end
      let(:csv) {
        [
          {category_id: '', company_id: '', name: 'カテゴリ1', position: 1, last: 'FALSE', parent_category_name: ''},
          {category_id: '', company_id: '', name: 'カテゴリA', position: 2, last: 'FALSE', parent_category_name: 'カテゴリ1'},
          {category_id: '', company_id: '', name: 'カテゴリB', position: 3, last: 'FALSE', parent_category_name: 'カテゴリ1'},
        ].map(&:deep_stringify_keys)
      }
      it do
        expect(subject).to be_empty
        expect(Category.where(company_id: company.id).all.map(&:name)).to match_array(['カテゴリ1', 'カテゴリA', 'カテゴリB'])
        expect(Category.where(company_id: company.id).find_by_name('カテゴリA').category.id).to eq(Category.find_by_name('カテゴリ1').id)
        expect(Category.where(company_id: company.id).find_by_name('カテゴリB').category.id).to eq(Category.find_by_name('カテゴリ1').id)
      end
    end

    context 'error case' do
      context 'blank error' do
        let(:csv) {
          [
            {category_id: '', company_id: '', name: '', position: 1, last: 'TRUE', parent_category_name: ''}
          ].map(&:deep_stringify_keys)
        }

        it do
          expect(subject.count).to eq(1)
        end
      end

      context 'parent not found' do
        let(:csv) {
          [
            {category_id: '', company_id: '', name: 'カテゴリ1', position: 1, last: 'TRUE', parent_category_name: 'invalid'}
          ].map(&:deep_stringify_keys)
        }

        it do
          expect(subject.count).to eq(1)
        end
      end
    end
  end
end
