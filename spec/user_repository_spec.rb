require 'user_repository'

def reset_users_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter-dms-test' })
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
      expect(users[-1].handle).to eq('Lucy')
      expect(users[-1].verified).to eq(false)
      expect(users[0].handle).to eq('Bob')
      expect(users[0].verified).to eq(false)
    end
  end

  context "#find_handle" do
    it "finds the handle based on id" do
      repo = UserRepository.new
      user = repo.find_handle(1)

      expect(user.handle).to eq('Bob')
    end

    it "finds the handle based on id" do
      repo = UserRepository.new
      user = repo.find_handle(4)

      expect(user.handle).to eq('Mary')
    end
  end

  context "#find_blocked" do




end