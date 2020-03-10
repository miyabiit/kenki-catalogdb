require 'rails_helper'

RSpec.describe Company, type: :model do
  describe '#search' do
    subject { Company.search(search_params) }

    context 'match with has many relation' do
      let(:search_params) {
        { sub_categories: { name: 'hoge' } }
      }
      let!(:matched) { create :company }
      let!(:unmatched) { create :company }
      before do
        matched.sub_categories << build(:sub_category, name: 'hoge')
        unmatched.sub_categories << build(:sub_category, name: 'piyo')
      end
      it do
        expect(subject.to_a&.map(&:id)).to eq([matched.id])
      end
    end
  end
end
