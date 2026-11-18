extends RefCounted


func calculate_damage(result: Array[String]) -> int:
	var damage = 0

	for color in result:
		if color == "green":
			damage += 2
		elif color == "yellow":
			damage += 1

	return damage
