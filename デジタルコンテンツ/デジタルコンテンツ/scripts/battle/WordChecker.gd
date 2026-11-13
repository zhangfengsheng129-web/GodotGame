extends RefCounted

func check_word(answer: String, guess: String) -> Array[String]:
	answer = answer.to_upper()
	guess = guess.to_upper()

	if answer.length() != guess.length():
		push_warning("Word length does not match.")
		return []

	var result: Array[String] = []
	var remaining: Dictionary = {}

	for i in range(guess.length()):
		result.append("gray")

		if answer[i] == guess[i]:
			result[i] = "green"
		else:
			remaining[answer[i]] = remaining.get(answer[i], 0) + 1

	# Second check: correct letters but wrong positions
	for i in range(guess.length()):
		if result[i] == "green":
			continue

		var letter = guess[i]

		if remaining.get(letter, 0) > 0:
			result[i] = "yellow"
			remaining[letter] -= 1

	return result
