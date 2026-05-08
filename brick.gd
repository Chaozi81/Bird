extends ColorRect

var brick_color = Color.RED
var hits_remaining = 1

func _ready():
    size = Vector2(64, 24)
    color = brick_color

func on_ball_hit():
    hits_remaining -= 1
    if hits_remaining <= 0:
        get_parent().on_brick_hit(self)
        queue_free()
