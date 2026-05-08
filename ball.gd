extends Area2D

var speed = 400
var direction = Vector2.ZERO
var screen_size = Vector2(800, 600)
var ball_radius = 8
var ball_color = Color.WHITE

func _ready():
    hide()
    reset()

func _draw():
    draw_circle(Vector2.ZERO, ball_radius, ball_color)
    
func reset():
    position = Vector2(400, 500)
    direction = Vector2.ZERO
    hide()

func start_movement():
    show()
    direction = Vector2(randf_range(-0.5, 0.5), -1).normalized()

func _process(delta):
    if direction == Vector2.ZERO:
        return
    position += direction * speed * delta
    if position.x <= 10 or position.x >= 790:
        direction.x *= -1
    if position.y <= 10:
        direction.y *= -1
    if position.y >= 610:
        on_miss()

func on_miss():
    direction = Vector2.ZERO
    get_parent().on_ball_miss()

func _on_body_entered(body):
    if body.has_method("on_ball_hit"):
        direction.y *= -1
        body.on_ball_hit()
    elif body.has_method("get_paddle_hit"):
        direction = body.get_paddle_hit(position)
