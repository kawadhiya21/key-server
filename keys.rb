class Keys
  def initialize(max_time_limit = 300, max_block_limit = 60)
    @keys = {}
    @blocked_keys = {}
    @max_block_limit = max_block_limit
    @max_time_limit = max_time_limit
  end

  def generate
    key = (0...30).map { |e| ('a'...'z').to_a[rand(24)+1] }.join()
    @keys[key.to_sym] = Time.now.to_i
    return key
  end

  def access
    if @blocked_keys.length == @keys.length
      return false
    end
    key = @keys.select { |k, v| break k if Time.now.to_i - v <= @max_time_limit && !@blocked_keys[k]}
    if key != {}
      @blocked_keys[key] = Time.now.to_i
      return key.to_s
    else
      return false
    end
  end

  def unblock(key)
    if @blocked_keys[key.to_sym]
      if Time.now.to_i - @blocked_keys[key.to_sym] <= @max_block_limit
        @keys[key.to_sym] = Time.now.to_i
        @blocked_keys.delete(key.to_sym)
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def delete_key(key)
    if @keys[key.to_sym]
      @keys.delete(key.to_sym)
      @blocked_keys.delete(key.to_sym)
      return true
    else
      return false
    end
  end

  def keep_alive(key)
    if @keys[key.to_sym]
      if Time.now.to_i - @keys[key.to_sym] <= @max_time_limit
        current_timestamp = Time.now.to_i
        @keys[key.to_sym] = current_timestamp
        return true
      else
        @keys.delete(key.to_sym)
        @blocked_keys.delete(key.to_sym)
        return false
      end
    else
      return false
    end
  end
end