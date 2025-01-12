class_name WorldTileMap
extends TileMapLayer

@onready var leaves_spawner := preload('res://scenes/spawner.tscn')
@onready var pileable_tile := preload('res://scenes/pileable_tile.tscn')

func _enter_tree() -> void:
	Config.root_2d = self

func _ready() -> void:
	for cell in self.get_used_cells():
		var tile_data := self.get_cell_tile_data(cell)
		var spawner_type : String = tile_data.get_custom_data("spawner")
		
		if spawner_type == null or spawner_type == '':
			continue
		
		if spawner_type in ['red', 'green', 'yellow']:
			add_spawner(cell, Leave.str_to_leave_type(spawner_type))

func add_spawner(cell: Vector2i, leave_type: Leave.LeaveType) -> void: 
	var spawner : Spawner = leaves_spawner.instantiate()
	spawner.type = leave_type
	spawner.global_position = to_global(map_to_local(cell))
	add_child(spawner)
