export type Descriptor = {
	name: string,
	fullName: string,
}

export type JsonEncodingOptions = {
	registry: type_registry.TypeRegistry,
}

export type JsonDecodingOptions = {
	registry: type_registry.TypeRegistry,
}

export type Message<T, Fields> = {
	new: (fields: Fields?) -> T,

	encode: (T) -> buffer,
	decode: (buffer) -> T,

	jsonEncode: (T, JsonEncodingOptions?) -> any,
	jsonDecode: ({ [string]: any }, JsonDecodingOptions?) -> T,

	descriptor: Descriptor,
}

-- Note that all consumers of CustomJson intentionally `any` their jsonDecode.
-- This is because it's the best way we can get Luau to actually "override".
export type CustomJson<T, Json> = {
	jsonEncode: (T) -> Json,
	jsonDecode: (Json) -> T,
}

return nil
