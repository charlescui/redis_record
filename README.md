# redis_record

:zap: 将redis作为存储的一种简单ORM实现，简单轻便，性能极快。

限于redis数据结构，除非使用lua存过，否则无法实现复杂的关连查询，使用场景有限。

- 建议用在对数据模型查询复杂度不高的场景上
- 建议配合[ngx_mruby](https://github.com/matsumoto-r/ngx_mruby)使用

支持以下操作:

* `find` 根据ID查找
* `delete` 根据ID删除
* `del_attr` 删除对象一个属性
* `del_attr!` 删除对象一个属性并保存
* `all` 查找模型全部实例
* `trunk` 清空模型全部实例
* `transaction` 事物操作
* `exists` 根据ID判断该实例是否存在
* `save` 保存

## 性能测试

```ruby
Benchmark.bm(15) do |x|
	x.report('save') {10000.times{User.new.save}}
	x.report('transaction') {User.transaction{10000.times{User.new}}}
	x.report('all') {User.all}
	x.report('trunk') {User.trunk}
end
```

结果如下:

```
                      user     system      total        real
save              2.760000   0.280000   3.040000 (  3.273148)
transaction       2.090000   0.110000   2.200000 (  2.258713)
all               8.400000   0.320000   8.720000 (  8.891607)
trunk             1.120000   0.180000   1.300000 (  1.582698)
```

:v: 还不错

## TODO

考虑引入[redis_objects](https://github.com/nateware/redis-objects)

Description goes here.

## Contributing to redis_record
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 崔峥. See LICENSE.txt for
further details.

