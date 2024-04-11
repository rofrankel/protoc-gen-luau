default:
	just --list

generate-conformance:
	rm -rf conformance/generated || true
	mkdir conformance/generated
	cargo build
	protoc -Iconformance/protos conformance.proto test_messages_proto3.proto --luau_out=conformance/generated --plugin=protoc-gen-luau=./target/debug/protoc-gen-luau

generate-wkts:
	mkdir -p src/luau/google/protobuf
	cargo build --release
	protoc \
		google/protobuf/any.proto \
		google/protobuf/api.proto \
		google/protobuf/duration.proto \
		google/protobuf/empty.proto \
		google/protobuf/field_mask.proto \
		google/protobuf/source_context.proto \
		google/protobuf/struct.proto \
		google/protobuf/timestamp.proto \
		google/protobuf/type.proto \
		google/protobuf/wrappers.proto \
		--luau_out=src/luau --plugin=protoc-gen-luau=./target/release/protoc-gen-luau
