# frozen_string_literal: true

RSpec.shared_examples 'nameable' do
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.not_to validate_presence_of :middle_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :sex }
  it { is_expected.to validate_presence_of :date_of_birth }
  it { is_expected.to validate_presence_of :place_of_birth }

  describe '#middle_name' do
    context 'when it is empty' do
      subject { create :member_person, middle_name: '' }

      specify do
        expect(subject.middle_name).to eq nil
      end
    end

    context 'when it is blank' do
      subject { create :member_person, middle_name: '   ' }

      specify do
        expect(subject.middle_name).to eq nil
      end
    end
  end
end
