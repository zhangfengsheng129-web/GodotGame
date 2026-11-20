
extends RefCounted

const WORDS_PATH = "res://scripts/testMain/words.json"

var words: Array[String] = []


func _init():
	load_words()


# JSONファイルから単語を読み込む
func load_words():
	words.clear()

	if not FileAccess.file_exists(WORDS_PATH):
		push_error("単語データが見つかりません: " + WORDS_PATH)
		return

	var file = FileAccess.open(WORDS_PATH, FileAccess.READ)

	if file == null:
		push_error("単語データを開けませんでした")
		return

	var json = JSON.new()
	var error = json.parse(file.get_as_text())

	if error != OK:
		push_error("JSON読み込みエラー: " + json.get_error_message())
		return

	var data = json.data

	if not data is Dictionary or not data.has("words"):
		push_error("JSONの形式が正しくありません")
		return

	for word in data["words"]:
		if word is String and not word.strip_edges().is_empty():
			words.append(word.strip_edges().to_upper())


# 指定文字数の単語をランダムに取得
func get_random_word(length: int) -> String:
	var candidates: Array[String] = []

	for word in words:
		if word.length() == length:
			candidates.append(word)

	if candidates.is_empty():
		push_warning("指定文字数の単語がありません: " + str(length))
		return ""

	return candidates.pick_random()


# 指定範囲に単語が存在するか確認
func has_words_in_range(min_length: int, max_length: int) -> bool:
	for word in words:
		if word.length() >= min_length and word.length() <= max_length:
			return true

	return false
