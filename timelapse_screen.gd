extends Control


@onready var play_button: Button = %PlayButton
@onready var texture_rect: TextureRect = $TextureRect

@onready var time_elapsed: Label = %TimeElapsed
@onready var camera_2d: Camera2D = $Camera2D
@onready var red_dots: Label = %RedDots

var og_image : Image
var timelapse_tween : Tween

var red_dots_n : int

func _ready() -> void:
	og_image = texture_rect.texture.get_image().duplicate()
	play_button.pressed.connect(start_timelapse)
	red_dots_n = 0


func start_timelapse() -> void:
	if timelapse_tween: timelapse_tween.kill()
	timelapse_tween = create_tween()
	timelapse_tween.tween_method(dot_single_point, 0, og_image.get_width() * og_image.get_height(), INF)
	


func _process(delta: float) -> void:
	if timelapse_tween:
		time_elapsed.text = str(int(timelapse_tween.get_total_elapsed_time()))


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


func dot_single_point(_value) -> void:
	var imagem : Image = texture_rect.texture.get_image().duplicate()
	var randon_pixel_pos = Vector2(randi_range(0, 1417 *2), randi_range(0, 2144 *2))
	imagem.set_pixelv(randon_pixel_pos, Color.RED)
	texture_rect.texture = ImageTexture.create_from_image(imagem)
	red_dots_n += 1
	red_dots.text = "Número de Pontos Vermelho: " + str(red_dots_n)
	
