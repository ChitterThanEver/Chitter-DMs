require 'user_repository'

def reset_users_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'database_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_users_table
  end
  
  context "#all" do
    it "returns all users" do
      repo = UserRepository.new
      users = repo.all

      expect(users.length).to eq(7)
      expect(users[-1].handle).to eq(7)

    end
  end
end