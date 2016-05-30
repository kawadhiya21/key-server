require 'rspec'
require './keys'

describe Keys do
  describe "#generate" do
    key_server = Keys.new(5, 3)
    it "returns a key" do
      expect(key_server.generate.length).to eql(30)
    end

    it "returns different keys" do
      key = key_server.generate
      expect(key_server.generate).not_to eql(key)
    end
  end
  
  describe "#access" do
    key_server = Keys.new(5, 3)
    key = key_server.generate
    it "returns one of the available keys" do
      expect(key_server.access).to eql(key)
    end

    it "does not returns the same key as it blocks it" do
      expect(key_server.access).to_not eql(key)
    end
  end

  describe "#unblock" do
    key_server = Keys.new(5, 3)
    key = key_server.generate
    key_server.access

    it "should unblock a key if done within blocking time period" do
      expect(key_server.unblock(key)).to eql(true)
      expect(key_server.access).to eql(key)
    end

    it "should not be able to unblock after blocking time period" do
      sleep 4
      expect(key_server.unblock(key)).to eql(false)
    end
  end

  describe "#delete_key" do
    key_server = Keys.new(5, 3)
    key = key_server.generate
    it "deletes the key" do
      expect(key_server.delete_key(key)).to eql(true)
    end

    it "key should not be available" do
      expect(key_server.access).to_not eql(key)
    end
  end

  describe "#keep_alive" do
    key_server = Keys.new(2, 1)
    key = key_server.generate

    it "should not make live expired key" do
      sleep 3
      expect(key_server.access).to_not eql(true)
    end

    it "keys should be accessible once made live" do
      key = key_server.generate
      sleep 1
      key_server.keep_alive(key)
      sleep 1.2
      expect(key_server.access).to eql(key)
    end
  end
end