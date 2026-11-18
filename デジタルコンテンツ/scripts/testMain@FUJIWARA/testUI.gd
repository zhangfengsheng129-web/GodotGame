
extends Control
#これはキーボード入力のためのスクリプトです
#少なくともMainLayout下のノード，ラベルの名前を参照しているため
#改変するときは一度AIに読み込ませるなどして依存関係を確認したほうが良いと思います
signal letter_pressed(letter: String)
signal backspace_pressed
signal enter_pressed

const KEY_ROWS = [
	"QWERTYUIOP",
	"ASDFGHJKL",
    "ZXCVBNM"
]

func _ready():
	create_keyboard()


func create_keyboard():
	var main_box = VBoxContainer.new()
	main_box.add_theme_constant_override("separation", 8)
	main_box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(main_box)

	for row_text in KEY_ROWS:
		create_key_row(main_box, row_text)

	# 削除・決定ボタン
	var bottom_row = HBoxContainer.new()
	bottom_row.add_theme_constant_override("separation", 10)
	main_box.add_child(bottom_row)

	var backspace = create_button("⌫ 一文字削除")
	backspace.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	backspace.pressed.connect(_on_backspace_pressed)
	bottom_row.add_child(backspace)

	var enter = create_button("決定 ↵")
	enter.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	enter.pressed.connect(_on_enter_pressed)
	bottom_row.add_child(enter)


func create_key_row(parent: VBoxContainer, letters: String):
	var row = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 5)
	parent.add_child(row)

	for i in range(letters.length()):
		var letter = letters.substr(i, 1)
		var button = create_button(letter)

		button.custom_minimum_size = Vector2(48, 55)
		button.pressed.connect(_on_letter_pressed.bind(letter))

		row.add_child(button)


func create_button(button_text: String) -> Button:
	var button = Button.new()
	button.text = button_text
	button.add_theme_font_size_override("font_size", 20)

	var normal = StyleBoxFlat.new()
	normal.bg_color = Color("#344054")
	normal.set_corner_radius_all(6)

	var hover = StyleBoxFlat.new()
	hover.bg_color = Color("#475467")
	hover.set_corner_radius_all(6)

	var pressed = StyleBoxFlat.new()
	pressed.bg_color = Color("#667085")
	pressed.set_corner_radius_all(6)

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)

	return button


func _on_letter_pressed(letter: String):
	letter_pressed.emit(letter)


func _on_backspace_pressed():
	backspace_pressed.emit()


func _on_enter_pressed():
	enter_pressed.emit()
