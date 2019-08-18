# frozen_string_literal: true

class ImportAll
  include Interactor

  def dirname
    @dirname ||= Pathname.new(context.dirname).realpath.freeze
  end

  def call
    import 'LPR_REGIONAL_DEPTS_ALL.csv', ImportRegionalOffice
    import 'LPR_PEOPLE_ALL.csv',         ImportPerson
    import 'LPR_CONTACTS_ALL.csv',       ImportContact
    import 'LPR_PARTY_MEMBERS_ALL.csv',  ImportRelationship

    # Imported in "db/seeds.rb":
    #
    # LPR_CONTACT_NETWORKS_ALL.csv
    # LPR_REGIONS_ALL.csv

    # Unnecessary:
    #
    # LPR_EVENTS_ALL.csv
    # LPR_STATUSES_ALL.csv
    # LPR_USERS.csv
  end

private

  def import(filename, interactor)
    CSV.read(dirname.join(filename), col_sep: ';').drop(1).each do |row|
      interactor.call row: row
    end
  end
end
