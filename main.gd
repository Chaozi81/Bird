extends Node2D

var score = 0
var lives = 3
var bricks_left = 0

@onready var ball = $Ball
@onready var paddle = $Paddle
@onready var score_label = $UI/ScoreLabel
@onready var lives_label = $UI/LivesLabel
@onready var message_label = $UI/MessageLabel

func _ready():
    # 加载中文字体，解决 Web 导出版本中文乱码
    var chinese_font = load("res://wqy-microhei.ttc")
    if chinese_font:
        for label in [score_label, lives_label, message_label]:
            label.add_theme_font_override("font", chinese_font)
    new_game()

func new_game():
    score = 0
    lives = 3
    bricks_left = 0
    update_ui()
    message_label.text = "点击或按空格开始"
    ball.hide()
    paddle.reset()

func start_game():
    for old in $Bricks.get_children():
        old.queue_free()
    var colors = [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE]
    for row in 5:
        for col in 10:
            var brick = ColorRect.new()
            brick.script = preload("res://brick.gd")
            brick.brick_color = colors[row % colors.size()]
            brick.color = brick.brick_color
            brick.size = Vector2(64, 24)
            brick.position = Vector2(col * 72 + 44, row * 32 + 40)
            brick.mouse_filter = Control.MOUSE_FILTER_IGNORE
            $Bricks.add_child(brick)
            bricks_left += 1
    ball.show()
    ball.start_movement()
    message_label.text = ""

func on_brick_hit(brick):
    score += 10
    bricks_left -= 1
    update_ui()
    if bricks_left <= 0:
        ball.hide()
        message_label.text = "你赢了！点击重新开始"

func on_ball_miss():
    lives -= 1
    update_ui()
    if lives <= 0:
        message_label.text = "游戏结束！点击重新开始"
        ball.hide()
    else:
        ball.reset()
        paddle.reset()
        message_label.text = "点击或按空格继续"

func update_ui():
    score_label.text = "分数: " + str(score)
    lives_label.text = "生命: " + str(lives)

func _unhandled_input(event):
    if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
        if message_label.text != "":
            new_game()
            start_game()
