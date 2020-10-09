extends Resource


static func instructions():
	return [
		
		["Actor", "PChar1", "change_sequenced_follow_formation", 0, "split"],
		
		["Actor", "PChar2", "change_sequenced_follow_formation", 0, "split"],
				
		["Actor", "PChar3", "change_sequenced_follow_formation", 0, "split"],
		
		["Actor-async", "PChar1", "move_up", 1], 
		
		["Actor-async", "PChar1", "move_left", 1], 
		
		["Actor-async", "PChar1", "move_down", 1], 
		
		["Actor-async", "PChar3", "move_right", 0.5], 
		
		["Actor", "PChar1", "move_left", 0.7],
		
		["Actor", "PChar2", "move_up", 1.0],
				
		["Actor", "PChar3", "move_up", 1.0],
		
		["Actor", "PChar1", "move_right", 0.7],
		
		["Actor", "PChar2", "move_down", 1.0],
				
		["Actor", "PChar3", "move_down", 1.0],
		
		["Actor", "PChar1", "change_sequenced_follow_formation", 0, "following"],
		
		["Delay", 2.0],
		
		["Actor-async", "PChar1", "move_right", 2.0],
		
		["Actor", "PChar2", "change_sequenced_follow_formation", 0, "following"],
				
		["Actor", "PChar3", "change_sequenced_follow_formation", 0, "following"],
		
		["Actor-async", "PChar1", "move_up", 1.0], 
		
		["Actor-async", "PChar1", "move_left", 0.3], 
		
		["Actor-async", "PChar1", "move_down", 0.3], 
		
		["Actor-async", "PChar1", "move_left", 0.3], 
		
		["Actor-async", "PChar1", "move_down", 0.3], 
		
		["Actor-async", "PChar1", "move_left", 0.3], 
		
		["Actor-async", "PChar1", "move_down", 0.3], 
		
		["Actor-async", "PChar1", "move_left", 0.3], 
		
		["Actor", "PChar1", "change_sequenced_follow_formation", 0, "split"],
		
		["Actor", "PChar2", "change_sequenced_follow_formation", 0, "split"],
				
		["Actor", "PChar3", "change_sequenced_follow_formation", 0, "split"],
		
		["Actor", "PChar1", "change_sequenced_follow_formation", 0, "following"],
		
		["Actor", "PChar2", "change_sequenced_follow_formation", 0, "following"],
		
		["Actor-async", "PChar1", "move_left", 1.0], 

		["Actor-async", "PChar3", "move_left", 1.0], 
		
		["Actor", "PChar3", "change_sequenced_follow_formation", 0, "following"],
	]
