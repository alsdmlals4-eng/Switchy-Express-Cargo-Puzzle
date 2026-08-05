class_name ValidationRunStateFixture
extends RefCounted


func phase() -> StringName:
	return &"RUNNING"


func elapsed_seconds() -> float:
	return 0.0


func time_limit_seconds() -> float:
	return 90.0
