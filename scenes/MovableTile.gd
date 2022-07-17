extends StaticBody2D


const TILE_SIZE = 48
const TILE_VECTOR = Vector2.ONE * TILE_SIZE
const MOVE_DURATION = 0.3


onready var tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	position = (position - TILE_VECTOR / 2.0).snapped(Vector2.ONE * TILE_SIZE) + TILE_VECTOR / 2.0
	pass # Replace with function body.


func move(direction: Vector2) -> bool:
	
	if tween.is_active():
		return false
	else:
		var target := (position + direction.normalized() * TILE_SIZE - TILE_VECTOR / 2.0).snapped(Vector2.ONE * TILE_SIZE) + TILE_VECTOR / 2.0
		for collision in get_world_2d().direct_space_state.intersect_point(target):
			if collision.collider.has_method("move"):
				if not collision.collider.move(direction):
					return false
			else:
				return false
		tween.interpolate_property(self, "position", position, target, MOVE_DURATION, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		return true


func _on_Area2D_area_entered(area):
	if area.name.begins_with("Box"):
		$CPUParticles2D.visible = false
		$AudioStreamPlayer2D.play()


func _on_Area2D_area_exited(area):
	if area.name.begins_with("Box"):
		$CPUParticles2D.visible = true
