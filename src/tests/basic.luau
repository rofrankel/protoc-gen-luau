local tests = require("./tests")

local kitchen_sink = require("./samples/kitchen_sink")
local struct = require("./samples/google/protobuf/struct")

local assertEquals = tests.assertEquals
local assertTablesEquivalent = tests.assertTablesEquivalent
local describe = tests.describe
local it = tests.it

describe("json deserializing", function()
	it("should deserialize and reserialize primitives", function()
		local json = {
			int32 = 1,

			-- These need to be included because JSON output currently includes enum values.
			aliasedEnum = 0,
			enum = 0,
			nestedEnum = 0,
			enum2 = 0,
		}

		local kitchenSink = kitchen_sink.KitchenSink.jsonDecode(json)

		assertEquals(kitchenSink.int32, 1)

		assertTablesEquivalent(kitchenSink:jsonEncode(), json)
	end)

	it("should deserialize and reserialize WKTs", function()
		local json = {
			name = {
				family = "Doe",
				given = "John",
			},
			age = 42,
		}

		local deserialized_struct = struct.Struct.jsonDecode(json)

		assertEquals(deserialized_struct.fields.name.kind.value.fields.family.kind.value, "Doe")

		assertTablesEquivalent(deserialized_struct:jsonEncode(), json)
	end)
end)

tests.finish()
