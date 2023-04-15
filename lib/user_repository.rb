require_relative './user'

class UserRepository
  def all
    sql = 'SELECT * FROM users;'
    results = DatabaseConnection.exec_params(sql, [])

    users = []

    results.each{ |record| users << user_builder(record)}
    return users
  end

  def list_handles
    sql = 'SELECT handle FROM users;'
    results = DatabaseConnection.exec_params(sql, [])

    handles = []
    results.each{ |record| handles << record['handle'] }
    return handles
  end

  # def updated_verified(user)
  #   sql = 'UPDATE users SET verified = $1 WHERE id = $2;'
  #   sql_params = [user.verified, user.id]
  #   DatabaseConnection.exec_params(sql, sql_params)
  # end

  def find_id(handle)
    sql = 'SELECT id FROM users WHERE handle = $1;'
    params = [handle]
    results = DatabaseConnection.exec_params(sql, params)
    user = User.new
    user.id = results[0]['id']
    return user.id
  end

  def find_handle(id)
    sql = 'SELECT handle FROM users WHERE id = $1;'
    params = [id]
    results = DatabaseConnection.exec_params(sql, params)
    user = User.new
    user.handle = results[0]['handle']
    return user
  end

  def find_blocked(id)
    sql = 'SELECT blocked.blocked_id FROM users
    JOIN blocked ON users.id = blocked.blocker_id
    WHERE blocked.blocker_id = $1;'
    params = [id]
    results = DatabaseConnection.exec_params(sql, params)

    block_list = []

    results.each { |record| block_list << find_handle(record['blocked_id']) }
    return block_list
  end

  def remove_from_blocked_list(blocker_id, blocked_id)
    sql = 'DELETE FROM blocked
    WHERE blocker_id = $1 AND blocked_id = $2;'
    sql_params = [blocker_id, blocked_id]
    DatabaseConnection.exec_params(sql, sql_params)
    return nil
  end

  def add_to_blocked_list(blocker_id, blocked_id)
    sql = 'INSERT INTO blocked (blocker_id, blocked_id)
    VALUES ($1, $2);'
    sql_params = [blocker_id, blocked_id]
    DatabaseConnection.exec_params(sql, sql_params)
    return nil
  end

  private

  def user_builder(record)
    user = User.new
    user.id = record['id'].to_i
    user.handle = record['handle']
    user.verified = record['verified'].eql?('t') ? true : false
    return user
  end

end
