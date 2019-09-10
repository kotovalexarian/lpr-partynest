# frozen_string_literal: true

class CreateRSAKeysAndX509SelfSignedCertificate
  include Interactor::Organizer

  organize CreateRSAKeys, CreateX509SelfSignedCertificate

  around do |interactor|
    ActiveRecord::Base.transaction do
      interactor.call
    end
  end
end
