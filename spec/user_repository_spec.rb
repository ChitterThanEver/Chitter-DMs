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

      expect(user).to eq('Bob')

      repo = UserRepository.new
      user = repo.find_handle(4)

      expect(user).to eq('Mary')
    end
  end

  context "#find_blocked" do
    it "returns an array of blocked users based on user_id" do
      repo = UserRepository.new
      blocked_list = repo.find_blocked(7)

      expect(blocked_list.length).to eq(2)
      expect(blocked_list[0]).to eq("Bob")
    end

    it "returns an array of blocked users based on user_id" do
      repo = UserRepository.new
      blocked_list = repo.find_blocked(6)

      expect(blocked_list.length).to eq(0)
    end
  end

  context 'removed_from_blocked_list' do
    it 'removes a user from the blocked list based on id' do
      repo = UserRepository.new
      repo.remove_from_blocked_list(7, 1)
      blocked_list = repo.find_blocked(7)

      expect(blocked_list.length).to eq(1)
      expect(blocked_list.first).to include('Sam')
    end
  end

  context 'add_to_blocked_list' do
    it 'adds a user to the blocked list' do
      repo = UserRepository.new
      repo.add_to_blocked_list(1, 3)
      blocked_list = repo.find_blocked(1)

      expect(blocked_list.length).to eq(1)
      expect(blocked_list.first).to include('Irene')
    end
  end

  it "gets user by handle" do
    repo = UserRepository.new
    user = repo.get_user_by_handle('Bob')
    expect(user.id).to eq 1
  end
end