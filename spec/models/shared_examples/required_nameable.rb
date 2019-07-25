# frozen_string_literal: true

RSpec.shared_examples 'required_nameable' do
  it { is_expected.to     validate_presence_of :last_name }
  it { is_expected.to     validate_presence_of :first_name }
  it { is_expected.not_to validate_presence_of :middle_name }
  it { is_expected.to     validate_presence_of :sex }
  it { is_expected.to     validate_presence_of :date_of_birth }
  it { is_expected.to     validate_presence_of :place_of_birth }

  %i[
    last_name
    first_name
    middle_name
    sex
    date_of_birth
    place_of_birth
  ].each do |attribute|
    describe "##{attribute}" do
      context 'when it is empty' do
        subject { build :member_person, attribute => '' }

        before { subject.validate }

        specify do
          expect(subject.public_send(attribute)).to eq nil
        end
      end

      context 'when it is blank' do
        subject { build :member_person, attribute => '   ' }

        before { subject.validate }

        specify do
          expect(subject.public_send(attribute)).to eq nil
        end
      end
    end
  end
end
