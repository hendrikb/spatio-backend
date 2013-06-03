require 'spec_helper'

describe Spatio do
  context '.redis' do
    it 'returns Redis.new' do
      Spatio.unstub(:redis)
      redis_conf = YAML.load_file('config/redis.yml').fetch('test')

      Redis.should_receive(:new).with(redis_conf)
      Spatio.redis
    end
  end
end
