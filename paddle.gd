extends ColorRect

var speed = 500
var screen_width = 800

func _ready():
    reset()

func reset():
    position = Vector2(350, 560)

func _process(delta):
    if Input.is_action_pressed("ui_left") and position.x > 0:
        position.x -= speed * delta
    if Input.is_action_pressed("ui_right") and position.x < screen_width - size.x:
        position.x += speed * delta
    var mouse_x = get_viewport().get_mouse_position().x
    position.x = clamp(mouse_x - size.x / 2, 0, screen_width - size.x)

func get_paddle_hit(ball_pos):
    var relative = (ball_pos.x - (position.x + size.x / 2)) / (size.x / 2)
    return Vector2(relative, -1).normalized()

func on_ball_hit():
    pass
