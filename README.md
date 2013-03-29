# redis_record

将redis作为存储的一种简单ORM实现，简单轻便，性能极快。

限于redis数据结构，除非使用lua存过，否则无法实现复杂的关连查询，使用场景有限。

1 建议用在对数据模型查询复杂度不高的场景上
2 建议配合[ngx_mruby](https://github.com/matsumoto-r/ngx_mruby)使用

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
save              2.910000   0.330000   3.240000 (  4.766495)
transaction       0.000000   0.000000   0.000000 (  0.005528)
all               3.370000   0.160000   3.530000 (  3.940805)
trunk             0.470000   0.100000   0.570000 (  0.928632)
```

得益于redis的高性能，通过事物保存操作，0.005秒可以存入10000条数据。

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

