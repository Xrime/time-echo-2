extends Node

var step: int = 0     
var win: bool = false     
var ASKING: bool = false
var MOVING: bool = true
var WIN: bool = false
var LOCKED: bool = false


var steps: int = 5
func _ready() -> void:
	step = steps
func deduct_steps(amount: int) -> void:
	steps = max(steps - amount, 0)

func reset_steps(value: int) -> void:
	steps = value
