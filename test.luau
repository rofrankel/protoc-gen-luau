-- --!strict

local any = require('gen/google/protobuf/any')
local duration = require('gen/google/protobuf/duration')
local descriptor = require('gen/proto/descriptor')
local account = require('gen/google/protobuf/account')
local typeRegistry = require('gen/proto/typeRegistry')

print(account)

local john = account.Account.new('John Doe', 100)
print(john)
print(john:encode())

print(descriptor)

print(duration)
local one_hour = duration.Duration.new()
one_hour.seconds = 3600
print(one_hour)

print(one_hour.descriptor().name())
print(one_hour.descriptor().full_name())

print(duration.Duration.encode(one_hour))
print(one_hour:encode())
print(typeof(one_hour:encode()))
one_hour_encoded = one_hour:encode()
print(typeof(one_hour_encoded))
print('asdf')
print(duration.Duration.decode(one_hour:encode()))
one_hour_decoded = duration.Duration.new()
print(one_hour_decoded.decode(one_hour:encode()))
print(one_hour_decoded)

registry = typeRegistry.TypeRegistry.new({
    duration.Duration,
    any.Any,
})
print('** type registry')
print(registry:findMessage("google.protobuf.Duration").decode(duration.Duration.new({seconds = 3600}):encode()))

print('** any')
local packed_duration = any.Any.new()
print(packed_duration)
print(any.Any.encode(packed_duration))
any.Any.pack(packed_duration, one_hour)
print(packed_duration:pack(one_hour))
print(packed_duration)

print(packed_duration:unpack(registry))

print(packed_duration:jsonEncode())

