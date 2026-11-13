extends RefCounted

const WordCheckerScript = preload("res://scripts/battle/WordChecker.gd")
const BattleLogicScript = preload("res://scripts/battle/BattleLogic.gd")
const EnemyScript = preload("res://scripts/battle/Enemy.gd")

var answer: String
var checker
var battle_logic
var enemy

var player_max_hp: int
var player_hp: int

func _init(word: String, enemy_hp: int, player_hp_value: int = 10):
	answer = word.to_upper()
	checker = WordCheckerScript.new()
	battle_logic = BattleLogicScript.new()
	enemy = EnemyScript.new(enemy_hp)

	player_max_hp = player_hp_value
	player_hp = player_hp_value

func submit_guess(guess: String) -> Dictionary:
	if enemy.is_defeated():
		return {"error": "Enemy already defeated."}

	if player_hp <= 0:
		return {"error": "Player already defeated."}

	var result = checker.check_word(answer, guess)

	if result.is_empty():
		return {"error": "Invalid guess."}

	var damage = battle_logic.calculate_damage(result)
	enemy.take_damage(damage)

	var counter_damage = 0

	# Counterattack when the guess causes no damage
	if damage == 0 and not enemy.is_defeated():
		counter_damage = enemy.attack()
		player_hp = max(player_hp - counter_damage, 0)

	var status = "ongoing"

	if enemy.is_defeated():
		status = "win"
	elif player_hp <= 0:
		status = "lose"

	return {
		"result": result,
		"damage": damage,
		"enemy_hp": enemy.current_hp,
		"counter_damage": counter_damage,
		"player_hp": player_hp,
		"status": status
	}
