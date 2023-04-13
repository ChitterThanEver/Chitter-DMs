require 'dm'

class DMRepository
  def find_inbox(user_handle)
    dms = []

    sql = "SELECT * FROM dms WHERE recipient_handle = $1"
    params = [user_handle]

    result_set = DatabaseConnection.exec_params(sql, params)

    result_set.each do |record|
      dms << result_set_to_dm(record)
    end

    return dms
  end

  def result_set_to_dm(result_set)
    dm = DM.new
    dm.id = result_set['id'].to_i
    dm.contents = result_set['contents']
    dm.recipient_handle = result_set['recipient_handle']
    dm.sender_handle = result_set['sender_handle']
    dm.time = result_set['time']
    return dm
  end

end