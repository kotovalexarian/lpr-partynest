# frozen_string_literal: true

RSpec.shared_examples 'paginal controller' do |entities_count_var_name|
  context 'when there are no entities' do
    let(entities_count_var_name) { 0 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there is one entity' do
    let(entities_count_var_name) { 1 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are few entities' do
    let(entities_count_var_name) { rand 2..4 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are many entities' do
    let(entities_count_var_name) { rand 5..10 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are lot of entities' do
    let(entities_count_var_name) { rand 20..40 }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
