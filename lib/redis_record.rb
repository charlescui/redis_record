require "uuid"
require "redis"
require "virtus"
require "active_record"

# RdsBase模型是基于redis作为数据库的简洁ORM模型
class RedisRecord
	class << self; attr_accessor :redis; end

	include Virtus
	attribute :id, String, :default => proc{UUID.generate.gsub("-",'')}

	# 根据ID查找对象
	def self.find(id)
		key = self.redis_key(id)
		h = RedisRecord.redis.hgetall(key)
		h && self.new(h)
	end

	def self.delete(id)
		key = self.redis_key(id)
		RedisRecord.redis.del(key)
	end

	def delete
		self.class.delete(self.id)
	end

	# 删除某一属性
	def del_attr(attrt)
		key = self.class.redis_key(id)
		self.attributes[attrt.to_sym] = nil
		RedisRecord.redis.hdel(key, attrt.to_s)
	end

	# 删除某一属性并保存
	def del_attr!(attrt)
		RedisRecord.redis.multi do
			self.del_attr(attrt)
			self.save
		end
	end

	# 查找某个模型所有实例数据
	def self.all
		keys = RedisRecord.redis.keys("#{self.prefix_redis_key}::*")
		items = RedisRecord.redis.multi do
			keys.map do |key|
				RedisRecord.redis.hgetall(key)
			end
		end
		items.map{|item|self.new(item)}.compact
	end

	# 清空该模型所有记录
	def self.trunk
		keys = RedisRecord.redis.keys("#{self.prefix_redis_key}::*")
		items = RedisRecord.redis.multi do
			keys.each do |key|
				RedisRecord.redis.del(key)
			end
		end
		keys.size
	end

	# 事物操作
	def self.transaction
		if block_given?
			RedisRecord.redis.multi do
				yield(RedisRecord.redis)
			end
		end
	end

	# 判断某个模型的某条数据是否存在
	def self.exists(id)
		RedisRecord.redis.exists self.redis_key(id)
	end

	def exists
		self.class.exists(self.id)
	end

	# 保存数据
	def save
		RedisRecord.redis.hmset(self.redis_key, *self.attributes)
	end

	# 保存在内存中的Key
	def redis_key
		self.class.redis_key(self.id)
	end

	def self.redis_key(id)
		"#{self.prefix_redis_key}::#{id}"
	end

	def self.prefix_redis_key
		"Model::#{self.to_s.demodulize}"
	end
end