tool
extends Node2D

export(float) var radius := 10.0

onready var tween := $Tween

var last_position := global_position

var eye_position := Vector2()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BlinkTimer.start(rand_range(1, 5))

func _process(delta: float) -> void:
	eye_position += last_position - global_position
	eye_position = eye_position.clamped(radius / 2)
	eye_position = eye_position.linear_interpolate(Vector2(), 0.1)
	last_position = global_position
	update()


func _draw() -> void:
	draw_circle(Vector2(), radius, Color.white)
	draw_circle(eye_position, radius / 2, Color.black)


func blink() -> void:
	tween.interpolate_property(self, "scale", scale, Vector2(1, 0.1), 0.1, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.interpolate_property(self, "scale", Vector2(1, 0.1), Vector2.ONE, 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.1)
	tween.start()

func _on_BlinkTimer_timeout():
	blink()
	$BlinkTimer.start(rand_range(1, 5))
