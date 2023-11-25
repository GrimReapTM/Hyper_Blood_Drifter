extends Camera2D

@export var player: CharacterBody2D
@export var tilemap: TileMap

@export var Dead_Zone = 60

# camera zoom
@export var zoomSpeed = 160
@export var zoomMargin = 0.3

var zoomMin = 0.8
var zoomMax = 1

var zoomPos = Vector2()
var zoomFactor = 1

func _process(delta):
	if not player.paused:
		zoom.x = lerp(zoom.x, zoom.x * zoomFactor, zoomSpeed * delta)
		zoom.y = lerp(zoom.y, zoom.y * zoomFactor, zoomSpeed * delta)
	
		zoom.x = clamp(zoom.x, zoomMin, zoomMax)
		zoom.y = clamp(zoom.y, zoomMin, zoomMax)

# camera border
func _ready():
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize * 4
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y
	limit_left = 0
	limit_top = 0


func _input(event: InputEvent) -> void:
	# camera moves with the mouse
	if not player.paused:
		if event is InputEventMouseMotion:
			var _target = event.position - get_viewport().size * 0.1
			if _target.length() < Dead_Zone:
				self.position = Vector2(0, 0)
			else:
				self.position = _target.normalized() * (_target.length() - Dead_Zone) * 0.1
		
		# camera zoom
		if abs(zoomPos.x - get_global_mouse_position().x) > zoomMargin:
			zoomFactor = 1
		elif abs(zoomPos.x - get_global_mouse_position().x) > zoomMargin:
			zoomFactor = 1
			
		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					zoomFactor -= 0.02
					zoomPos = get_global_mouse_position()
				
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					zoomFactor += 0.02
					zoomPos = get_global_mouse_position()


