extends Node2D
class_name World

@onready var player : Player = %Player
@onready var hud : HUD = %HUD

var leaves_count := {
	Leave.LeaveType.RED: 50,
	Leave.LeaveType.YELLOW: 50,
	Leave.LeaveType.GREEN: 50
}

func _ready() -> void:
	player.on_leave_in_backpack.connect(_on_leave_in_backpack)
	player.on_try_spawn_leaves.connect(_on_player_try_spawn_leaves)
	_update_leaves_hud(false)

func _on_player_try_spawn_leaves(leave_type: Leave.LeaveType, pileable_tile: PileableTile) -> void:
	var cost := 10
	
	var has_enough_leaves : bool = leaves_count[leave_type] >= cost
	
	if has_enough_leaves and pileable_tile.can_spawn_leave():
		leaves_count[leave_type] -= cost
		pileable_tile.spawn(leave_type)
		_update_leaves_hud(true)

	player.play_pile_desposit_animation(leave_type, has_enough_leaves)

func _on_leave_in_backpack(leave_type: Leave.LeaveType) -> void:
	leaves_count[leave_type] += 1
	_update_leaves_hud(true)
	
func _update_leaves_hud(animate: bool) -> void:
	hud.update_leave_count([
		leaves_count[Leave.LeaveType.RED],
		leaves_count[Leave.LeaveType.YELLOW],
		leaves_count[Leave.LeaveType.GREEN]], animate)
