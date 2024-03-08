extends Node2D

const CELL_COLLECTION = [preload("res://area_1.tscn")]
var current_level = 1
var total_rooms = null
var required_shops = null
var boss_generated = null

var cell_dict = {}

var coordinates_dict = {'north': [0, 1], 
	'east': [1, 0], 'south':[0, -1], 
	'west':[-1, 0]}
		
var map_modifier = {'north': [0, - 288], 
	'east': [480, 0], 
	'south': [0, 288], 
	'west': [-480, 0]}

func _ready():
	set_levelparameters(current_level)
	generate_level()
	
func generate_level():
	if len(cell_dict) == 0:
		# Put starting cell in at 0, 0
		cell_dict[[0, 0]] = get_node("AreaID1_")
		
	var choices = ["north", "south", "east", "west"]
	var gentarget_cell_coord = [0, 0]
	
	while len(cell_dict) < total_rooms:
		var choice = choices[randi() % choices.size()]
		if [gentarget_cell_coord[0] + coordinates_dict[choice][0], gentarget_cell_coord[1] + coordinates_dict[choice][1]] in cell_dict:
			# already exists
			continue
		else:
			var new_cell_coord = [gentarget_cell_coord[0] + coordinates_dict[choice][0], gentarget_cell_coord[1] + coordinates_dict[choice][1]]
			var new_cell = CELL_COLLECTION[0].instantiate()
			new_cell.position.x = map_modifier[choice][0] * abs(new_cell_coord[0])
			new_cell.position.y = map_modifier[choice][1] * abs(new_cell_coord[1])
				
			cell_dict[new_cell_coord] = new_cell
			self.add_child(new_cell)
			print(new_cell.position.x, str(gentarget_cell_coord))
			print(choice, " new focus : " + str(gentarget_cell_coord))
				
	print(cell_dict)
				
			
			
func set_levelparameters(id):
	#total_rooms = (id + 5) * 2 TODO Work on Fix
	total_rooms = 1
	required_shops = id
	boss_generated = false
