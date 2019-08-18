# frozen_string_literal: true

class ImportAll
  include Interactor

  def dirname
    @dirname ||= Pathname.new(context.dirname).realpath.freeze
  end

  def call
    import 'LPR_PEOPLE_ALL.csv',   ImportPerson
    import 'LPR_CONTACTS_ALL.csv', ImportContact
  end

private

  def import(filename, interactor)
    CSV.read(dirname.join(filename), col_sep: ';').drop(1).each do |row|
      interactor.call row: row
    end
  end
end
