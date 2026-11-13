extends RefCounted

var max_hp: int
var current_hp: int
var attack_power: int

func _init(hp: int, attack: int = 1):
	max_hp = hp
	current_hp = hp
	attack_power = attack

func take_damage(damage: int):
	current_hp -= damage
	current_hp = max(current_hp, 0)

func is_defeated() -> bool:
	return current_hp <= 0

func attack() -> int:
	return attack_power
