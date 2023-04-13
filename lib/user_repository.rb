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

  def find_handle(id)
    sql = 'SELECT handle FROM users WHERE id = $1;'
    params = [id]
    results = DatabaseConnection.exec_params(sql, params)
    result[0]['handle']
  end
  
  def find_blocked(id)
    sql = 'SELECT blocked.blocked_id FROM users
    JOIN blocked ON users.id = blocked.blocker_id
    WHERE blocked.blocker_id = $1;'
    params = [id]
    results = DatabaseConnection.exec_params(sql, [])
    
    block_list = []

    results.each { |record| block_list << find_handle(record['blocked_id']) }
  end

  private 

  def user_builder(record)
    user = User.new
    user.id = record['id'].to_i
    user.handle = record['handle']
    user.verified = record['verified']
  end
  
end