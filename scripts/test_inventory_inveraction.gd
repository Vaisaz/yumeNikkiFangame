extends Area2D

var index = 0
var interact: bool = false

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		
func _on_area_exited(_area):
	interact = false
		
func _input(_event):
	if interact and !Inventory.watches_has_interacted and Input.is_action_just_pressed("interact"):
		for item_count in Inventory.items:
			print(item_count)
			if Inventory.index == 0 and Inventory.items[Inventory.index].disabled and !Inventory.watches_has_interacted:
				Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[1]
				Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[1]
				Inventory.items[Inventory.index].disabled = false
			if Inventory.index == 1 and Inventory.items[Inventory.index].disabled and !Inventory.watches_has_interacted:
				Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[1]
				Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[1]
				Inventory.items[Inventory.index].disabled = false
			if Inventory.index == 2 and Inventory.items[Inventory.index].disabled and !Inventory.watches_has_interacted:
				Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[1]
				Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[1]
				Inventory.items[Inventory.index].disabled = false
			if !Inventory.watches_has_interacted:
				Inventory.watches_has_interacted = true
				Inventory.index += 1
				
