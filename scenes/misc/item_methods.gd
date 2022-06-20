extends Node

func use_item(item):
	if item.item_type == item.ItemType.EQUIPMENT:
		equip(item)
	elif item.item_type == item.ItemType.SEED:
		sow(item)
	elif item.item_type == item.ItemType.HARVEST:
		throw(item)
	pass

func equip(item):
	#
	# Switch-case item enum
	#
	pass

func throw(item):
	pass

func sow(item):
	pass
