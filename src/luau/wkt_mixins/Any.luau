function _AnyImpl.jsonEncode(input: Any, options: proto.JsonEncodingOptions?): { [string]: any }
	if not (options and options.registry) then
		error("Type registry must be provided to serialize Any")
	end

	local unpacked = input:unpack(options.registry)
	if unpacked == nil then
		error("Cannot JSON-encode empty Any")
	end
	local json = unpacked:jsonEncode(options)

	if typeof(json) == "string" then
		return { ["@type"] = input.type_url, ["value"] = json }
	end

	json["@type"] = input.type_url

	return json
end

function _AnyImpl.jsonDecode(input: { [string]: any }, options: proto.JsonDecodingOptions?): Any
	if not (options and options.registry) then
		error("Type registry must be provided to deserialize Any")
	end

	local typeUrl = input["@type"]
	local typeName = typeUrl:sub(typeUrl:find("([^/]+)$"))
	local payloadType = options.registry:findMessage(typeName)

	if payloadType == nil then
		error("Could not find message type `" .. typeName .. "` for Any")
	end

	local typePrefix = typeUrl:sub(0, #typeUrl - #typeName - 1)

	local json = table.clone(input)
	-- For WKTs with special JSON representations, we need to decode input["value"] rather than
	-- input.
	local gpb = "google.protobuf."
	if typeName:sub(0, #gpb) == gpb and input["value"] then
		json = input["value"]
	else
		-- Clear this because it's not part of the JSON encoding of the payload itself.
		json["@type"] = nil
	end

	return _AnyImpl.pack(payloadType.jsonDecode(json, options), typePrefix)
end
