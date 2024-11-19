extends Control


const MONA_LISA_HD_RATION = 1.512693935119887165021

@onready var camera_2d: Camera2D = $Camera2D

@onready var texture: TextureRect = $TextureRect
@onready var h_scroll_bar: HScrollBar = %HScrollBar

@onready var resolution_label: Label = %ResolutionLabel
@onready var pixel_label: Label = %PixelLabel
@onready var area_label: Label = %AreaLabel

@onready var year_label: Label = %YearLabel

@onready var play_button: Button = %PlayButton

var og_image : Image
var scroll_tween : Tween


func _ready() -> void:
	og_image = texture.texture.get_image().duplicate()
	
	play_button.pressed.connect(play_scroll_tween)
	
	h_scroll_bar.scrolling.connect(func():
		var imagem : Image = og_image.duplicate()
		change_image_resolution(imagem)
		
		var texture_convert = ImageTexture.create_from_image(imagem)
		texture.texture = texture_convert
		)


## função que muda a resolução da imagem
func change_image_resolution(imagem : Image) -> void:
	var new_size = calculate_resize(imagem)
	imagem.resize(new_size.x, new_size.y)
	resolution_label.text = "Resolução: " + str(imagem.get_size())
	area_label.text = "Area aproximada perdida em km2: " + str(((h_scroll_bar.value - h_scroll_bar.min_value) * 20000) + 215000)
	pixel_label.text = "Pixels na tela: " + str(imagem.get_size().x * imagem.get_size().y)
	year_label.text = str(h_scroll_bar.value)



func calculate_resize(imagem : Image) -> Vector2:
	var current_year_change = h_scroll_bar.value - h_scroll_bar.min_value
	
	var current_image_size = imagem.get_size()
	var new_size = Vector2(current_image_size.x - (4 * current_year_change), current_image_size.y - (6 * current_year_change))
	print(new_size)
	var pixels_changed = (og_image.get_size().x * og_image.get_size().y) - (new_size.x * new_size.y)
	
	print("amount of pixels changed: " + str(pixels_changed))
	
	return new_size


func play_scroll_tween() -> void:
	if scroll_tween: scroll_tween.kill()
	scroll_tween = create_tween()
	#scroll_tween.tween_property(h_scroll_bar, "value", 2300, 30)
	scroll_tween.tween_method(func(value):
		h_scroll_bar.value = value
		h_scroll_bar.scrolling.emit()
		, h_scroll_bar.value, 2324, 30
		)



func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		event = event as InputEventKey
		if event.keycode == KEY_W:
			camera_2d.global_position.y -= 5
		if event.keycode == KEY_S:
			camera_2d.global_position.y += 5
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			#camera_2d.position = get_global_mouse_position()
			camera_2d.zoom += Vector2(0.01, 0.01)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			#camera_2d.position = get_global_mouse_position()
			camera_2d.zoom -= Vector2(0.01, 0.01)
