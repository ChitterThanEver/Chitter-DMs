require_relative './user'

class UserRepository
  def all
    sql = 'SELECT * FROM users;'
    results = DatabaseConnection.exec_params(sql, [])
    
    users = []
    
    results.each{ |record| users << user_builder(record)}
  end
  
  def updated_verified(user)
    sql = 'UPDATE users SET verified = $1 WHERE id = $2;'
    sql_params = [user.verified, user.id]
    DatabaseConnection.exec_params(sql, sql_params) 
  end

  def find_blocked(id)
    sql = 'SELECT users.handle AS blocker_id, '
  end

  private 

  def user_builder(record)
    user = User.new
    user.id = record['id'].to_i
    user.handle = record['handle']
    user.verified = record['verified']
  end
  
end