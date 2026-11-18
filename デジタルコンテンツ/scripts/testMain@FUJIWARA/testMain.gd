
extends Control
#これは章さんの作成したTestWordCheckerの挙動を参考に
#ゲーム上のクリックで文字を入力できるようにしたものです
#testMain下にあるスクリプトとシーン構成以外には手を加えていません。
const BattleManagerScript = preload("res://scripts/battle/BattleManager.gd")

const ENEMY_MAX_HP = 10
const PLAYER_MAX_HP = 10

var input_buffer = ""
var input_mode = "answer"

var battle_manager
var battle_finished = false

@onready var instruction_label = $MainLayout/InstructionLabel
@onready var input_label = $MainLayout/InputLabel
@onready var status_label = $MainLayout/StatusLabel
@onready var keyboard = $MainLayout/Keyboard


func _ready():
	keyboard.letter_pressed.connect(_on_letter_pressed)
	keyboard.backspace_pressed.connect(_on_backspace_pressed)
	keyboard.enter_pressed.connect(_on_enter_pressed)

	update_display()

	print("=== Word Battle Test ===")
	print("画面上のキーボードで正解単語を入力してください。")


# 文字入力
func _on_letter_pressed(letter: String):
	if battle_finished:
		return

	input_buffer += letter
	update_display()


# 一文字削除
func _on_backspace_pressed():
	if battle_finished:
		return

	if input_buffer.length() > 0:
		input_buffer = input_buffer.substr(
			0,
			input_buffer.length() - 1
		)

	update_display()


# 決定ボタン
func _on_enter_pressed():
	if battle_finished:
		return

	if input_buffer.is_empty():
		return

	var word = input_buffer
	input_buffer = ""

	if input_mode == "answer":
		start_battle(word)
	else:
		submit_guess(word)

	update_display()


# 正解単語を設定して戦闘開始
func start_battle(word: String):
	battle_manager = BattleManagerScript.new(
		word,
		ENEMY_MAX_HP,
		PLAYER_MAX_HP
	)

	input_mode = "guess"

	print("")
	print("=== Battle Start ===")
	print("正解単語: ", word)
	print("敵HP: ", ENEMY_MAX_HP)
	print("プレイヤーHP: ", PLAYER_MAX_HP)


# 回答を送信
func submit_guess(guess: String):
	print("")
	print("入力: ", guess)

	var result = battle_manager.submit_guess(guess)

	if result.has("error"):
		print("エラー: ", result["error"])
		return

	print("判定: ", result["result"])
	print("与えたダメージ: ", result["damage"])
	print("敵HP: ", result["enemy_hp"])
	print("受けたダメージ: ", result["counter_damage"])
	print("プレイヤーHP: ", result["player_hp"])

	if result["status"] == "win":
		finish_battle("勝利！")

	elif result["status"] == "lose":
		finish_battle("敗北...")


# 戦闘終了
func finish_battle(message: String):
	battle_finished = true

	print("")
	print("=== Battle Finished ===")
	print(message)

	status_label.text = message
	instruction_label.text = "戦闘終了"


# 画面表示更新
func update_display():
	input_label.text = input_buffer

	if input_mode == "answer":
		instruction_label.text = "正解単語を入力してください"
	else:
		instruction_label.text = "敵に回答する単語を入力してください"

	if not battle_finished:
		status_label.text = "入力待機中"
