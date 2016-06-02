require 'thread'

class Keys
  def initialize(max_time_limit = 300, max_block_limit = 60)
    @keys = {}
    @blocked_keys = {}
    @max_block_limit = max_block_limit
    @max_time_limit = max_time_limit
    @mutex = Mutex.new
    Thread.new do
      loop do
        clean_keys
        sleep 0.1
      end
    end

    Thread.new do
      loop do
        clean_blocked_keys
        sleep 0.1
      end
    end
  end

  def generate
    @mutex.synchronize do
      key = (0...30).map { |e| ('a'...'z').to_a[rand(24)+1] }.join()
      @keys[key.to_sym] = Time.now.to_i
      return key
    end
  end

  def access
    @mutex.synchronize do
      if @keys.length == 0
        return false
      end
      key = @keys.select { |k, v| break k }
      if key != {}
        @blocked_keys[key] = Time.now.to_i
        @keys.delete(key)
        return key.to_s
      else
        return false
      end
    end
  end

  def unblock(key)
    @mutex.synchronize do
      if @blocked_keys[key.to_sym]
        @keys[key.to_sym] = Time.now.to_i
        @blocked_keys.delete(key.to_sym)
        return true
      else
        return false
      end
    end
  end

  def delete_key(key)
    @mutex.synchronize do
      if @keys[key.to_sym]
        @keys.delete(key.to_sym)
        @blocked_keys.delete(key.to_sym)
        return true
      else
        return false
      end
    end
  end

  def keep_alive(key)
    @mutex.synchronize do
      if @keys[key.to_sym]
        current_timestamp = Time.now.to_i
        @keys[key.to_sym] = current_timestamp
        return true
      else
        return false
      end
    end
  end

  def clean_keys
    @mutex.synchronize do
      @keys.each do |key, timestamp|
        current_timestamp = Time.now.to_i
        if current_timestamp - timestamp > @max_time_limit
          @keys.delete(key)
        end
      end
    end
  end

  def clean_blocked_keys
    @mutex.synchronize do
      @blocked_keys.each do |key, timestamp|
        current_timestamp = Time.now.to_i
        if current_timestamp - timestamp > @max_block_limit
          @blocked_keys.delete(key)
          @keys[keys] = current_timestamp
        end
      end
    end
  end
end
