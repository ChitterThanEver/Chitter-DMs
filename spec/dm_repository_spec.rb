require 'dm_repository'
require 'dm'

def reset_tables
  sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter-dms-test' })
  connection.exec(sql)
end

RSpec.describe DMRepository do
  before(:each) do
    reset_tables
  end

  it 'returns the inbox for a user' do
    repo = DMRepository.new

    dms_bob = repo.find_inbox('Bob')
    dms_george = repo.find_inbox('George')

    expect(dms_bob.length).to eq 1
    expect(dms_bob.first.contents).to eq 'Hello Bob'

    expect(dms_george.length).to eq 2
    expect(dms_george.first.contents).to eq 'How are you?'
  end
end
