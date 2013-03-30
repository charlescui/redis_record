require_relative '../lib/redis_record'
require "benchmark"

RedisRecord.redis = Redis.new

class User < RedisRecord
	attribute :name, String
	attribute :age, Integer, :default => 18
	attribute :birthday, DateTime
end

user = User.new(:name => 'Piotr', :birthday => Time.now)
if user.save
	puts "saved!"
else
	puts "failed save to redis."
end

puts user.inspect

puts User.find(user.id)

puts User.all.inspect

puts user.delete

puts User.trunk

Benchmark.bm(15) do |x|
	x.report('save') {10000.times{User.new.save}}
	x.report('transaction') {User.transaction{10000.times{User.new.save}}}
	x.report('all') {User.all}
	x.report('trunk') {User.trunk}
end
