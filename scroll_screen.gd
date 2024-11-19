extends Control


const MONA_LISA_HD_RATION = 1.512693935119887165021


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

a\sdasdsad
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
	pass


func calculate_tree_loss(imagem : Image) -> int:
	return (og_image.get_width() * og_image.get_height() - imagem.get_width() * imagem.get_height())
