extends Control


var screens : Dictionary = {}

var current_screen : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		screens[i.get_index()] = i
		i.hide()


func enter_screen(screen : Control) -> void:
	if current_screen:
		current_screen.hide()
	current_screen = screen
	current_screen.show()
