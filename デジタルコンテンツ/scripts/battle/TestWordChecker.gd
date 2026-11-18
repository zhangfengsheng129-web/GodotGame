extends SceneTree

func _initialize():
	var manager = preload("res://scripts/battle/BattleManager.gd").new("APPLE", 10, 10)

	print("=== First Turn ===")

	var result1 = manager.submit_guess("ALLEY")

	print("Guess: ALLEY")
	print("Result: ", result1["result"])
	print("Damage: ", result1["damage"])
	print("Enemy HP: ", result1["enemy_hp"])
	print("Counter Damage: ", result1["counter_damage"])
	print("Player HP: ", result1["player_hp"])
	print("Status: ", result1["status"])

	print("=== Second Turn ===")

	var result2 = manager.submit_guess("ZZZZZ")

	print("Guess: ZZZZZ")
	print("Result: ", result2["result"])
	print("Damage: ", result2["damage"])
	print("Enemy HP: ", result2["enemy_hp"])
	print("Counter Damage: ", result2["counter_damage"])
	print("Player HP: ", result2["player_hp"])
	print("Status: ", result2["status"])

	quit()
