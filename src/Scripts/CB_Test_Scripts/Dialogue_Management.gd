extends CanvasLayer

#InputEngine
var input_id = "Dialogue"

var area = "Area01"

var dialogue_paths = {
	"Area01" : "res://Assets/Dialogue/Area01.res"
}

# Member variables
var dialogueDictionary = {}
var speakerDictionary = {} #where arr[0] is main, others are reactive
#export var ResFile = "Test_Project_Dialogue"
var displayedID = null
var currentspID = null
var finalWaltz = true
var reactiveID = ""

# Variables for dialogue options
var inOptions = false
var inOptionTree = false
var selectedOption = 1
var totalOptions = 1
var parentBranchNodes = []

# Nodes for ease of access
onready var scrollAudio = get_node("TextAudio")
onready var optionAudio = get_node("OptionAudio")
onready var dialogue_box = $"Control/Dialogue Box"
onready var options_box = $"Control/Options Box"
onready var textNode = dialogue_box.get_node("RichTextLabel")
onready var textTimer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_box.hide()
	options_box.hide()
	#var path = "res://Assets/Christian_Test_Assets/" + ResFile + ".res"
	var path = dialogue_paths[area]
	
	# Create file, test for existance
	var file = File.new()
	if !(file.file_exists(path)):
		Debugger.dprint("File not found")
		return
	file.open(path, file.READ)
	
	#parse file
	var qParse = []
	var raw = file.get_as_text()
	file.close()
	var rawArray = raw.split("\n", false)
	var prevSequenceID = null
	for val in rawArray:
		var mdLength = val.find("*/")
		if mdLength > -1:
			#get metadata and split into array
			var metaData = val.left(mdLength + 2)
			var metaArray = metaData.split(" ", false)
			if metaArray.size() > 5 && metaArray[1].length() == 5:
				#check for -z flag, to update speaker dictionary
				if !speakerDictionary.has(metaArray[1]) && metaArray[3] == "-z":
					speakerDictionary[metaArray[1]] = [metaArray[2]]
				
				#establish sub dictionary to add as val to dialogueDictionary
				var toInsert = {"msg": val.right(mdLength + 3)}
				var mdIndex = 0
				
				#get parent id for option logic
				if metaArray[metaArray.size() - 2].length() > 5:
					toInsert["pID"] = metaArray[metaArray.size() - 2] 
				
				#manage the flags in the metaArray
				var setPSID = false
				for item in metaArray:
					match item:
						"-s":
							if prevSequenceID != null:
								dialogueDictionary[prevSequenceID]["-s"] = metaArray[2]
							setPSID = true
						"-z":
							setPSID = true
						"-t":
							if prevSequenceID != null:
								dialogueDictionary[prevSequenceID]["-s"] = metaArray[2]
							toInsert["-t"] = true
							prevSequenceID = null
						"-q":
							if !qParse.has(metaArray[mdIndex + 1]):
								qParse.append(metaArray[2])
								toInsert["-q"] = metaArray[mdIndex + 1]
								prevSequenceID = null
							else:
								if qParse.find(mdIndex + 1) > -1:
									qParse.remove(qParse.find(mdIndex + 1))
						"-x":
							toInsert["-x"] = metaArray[mdIndex + 1]
						"-o":
							var optvals = mdIndex+1
							toInsert["-o"] = []
							while optvals < metaArray.size() - 1 && metaArray[optvals].length() > 5:
								toInsert["-o"].append(metaArray[optvals])
								optvals += 1
						"-rct":
							if prevSequenceID != null:
								dialogueDictionary[prevSequenceID]["-t"] = true
								dialogueDictionary[prevSequenceID].erase("-s")
							setPSID = true
							toInsert["-rct"] = metaArray[mdIndex + 1]
							speakerDictionary[metaArray[1]].append(metaArray[2])
					mdIndex += 1
				if setPSID:
					prevSequenceID = metaArray[2]
					setPSID = false
				
				#add entry with key of msgID and value as metadata subdirectory
				dialogueDictionary[metaArray[2]] = toInsert
	

#either skips scroll, advances to next line, or selects option
func ui_accept_pressed():
	if inOptions:
		optionAudio.stream = load("res://Assets/Christian_Test_Assets/Option_Selected.wav")
		optionAudio.play()
		displayedID = dialogueDictionary[displayedID]["-o"][selectedOption-1]
		parentBranchNodes.append(displayedID)
		clear_options()
		_advance()
	elif textNode.get_visible_characters() < textNode.get_text().length():
		textNode.set_visible_characters(textNode.get_text().length() - 1)
	else:
		_advance()

#move up and down in an option
func ui_down_pressed():
	if inOptions:
		optionAudio.stream = load("res://Assets/Christian_Test_Assets/Option_Arrow_Key_Pressed.wav")
		optionAudio.play()
		var opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).hide()
		selectedOption += 1
		if selectedOption > totalOptions:
			selectedOption = 1
		opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).show()

#move up and down in an option
func ui_up_pressed():
	if inOptions:
		optionAudio.stream = load("res://Assets/Christian_Test_Assets/Option_Arrow_Key_Pressed.wav")
		optionAudio.play()
		var opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).hide()
		selectedOption -= 1
		if selectedOption < 1:
			selectedOption = totalOptions
		opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).show()

func clear_options():
	inOptions = false
	while totalOptions > 0:
		var opName = "Option" + str(totalOptions)
		var n = options_box.get_node(opName)
		options_box.remove_child(n)
		totalOptions -= 1
	options_box.hide()
	totalOptions = 1

func _beginTransmit(var spID, var toSignal):
	InputEngine.activate_receiver(self)
	finalWaltz = false
	reactiveID = toSignal
	if !speakerDictionary.has(spID):
		Debugger.dprint("Could not find speaker ID: " + spID + " in dictionary!")
		InputEngine.deactivate_receiver(self)
		return
	currentspID = spID
	dialogue_box.show()
	_advance()
	
func transmit_message(var message):
	###############################NOT TESTED
	InputEngine.activate_receiver(self)
	finalWaltz = false
	dialogue_box.show()
	_advance()
	##############################NOT TESTED
	
func exec_final_waltz():
	dialogue_box.hide()
	currentspID = null
	displayedID = null
	parentBranchNodes = []
	InputEngine.deactivate_receiver(self)
	
func _advance():
	if dialogue_box.is_visible_in_tree():
		#if this was the final message, close
		if finalWaltz:
			exec_final_waltz()
			return
		
		textNode.set_visible_characters(0)
		
		if displayedID == null:
			if reactiveID != "" && reactiveID != null:
				displayedID = reactiveID
				for v in speakerDictionary[currentspID]:
					if dialogueDictionary[v].has("-rct") && dialogueDictionary[v]["-rct"] == reactiveID:
						displayedID = v
				if displayedID == null:
					displayedID = speakerDictionary[currentspID][0]
			else:
				displayedID = speakerDictionary[currentspID][0]
			textNode.text = dialogueDictionary[displayedID]["msg"]
		else:
			#if a response, obtain the next valid message
			if dialogueDictionary[displayedID].has("-r"):
				var advanceID = dialogueDictionary[displayedID]["-s"]
				textNode.text = dialogueDictionary[advanceID]["msg"]
				displayedID = advanceID
				
			#obtain and display the next item in the sequence
			var advanceable = false
			while !advanceable:
				advanceable = true
				if !dialogueDictionary[displayedID].has("-s"):
					exec_final_waltz()
					return
				var advanceID = dialogueDictionary[displayedID]["-s"]
				textNode.text = dialogueDictionary[advanceID]["msg"]
				displayedID = advanceID
				#if dialogue has a parent, ensure that the parent has been encountered
				if dialogueDictionary[displayedID].has("pID"):
					if !(parentBranchNodes.has(dialogueDictionary[displayedID]["pID"])):
						advanceable = false
							#nothing found before end of file
						if dialogueDictionary[displayedID].has("-t"):
							exec_final_waltz()
							return
		
		#check for a terminal flag and queued message to set
		if dialogueDictionary[displayedID].has("-q"):
			finalWaltz = true
			speakerDictionary[currentspID][0] = dialogueDictionary[displayedID]["-q"]
		if dialogueDictionary[displayedID].has("-t"):
			finalWaltz = true
			
		#begin text scroll
		textTimer.start()
		while (textNode.get_visible_characters() < textNode.get_text().length()):
			scrollAudio.play()
			textNode.set_visible_characters(textNode.get_visible_characters()+1)
			yield(textTimer, "timeout")
		
		#check for options flag and bring up bar if needed
		if dialogueDictionary[displayedID].has("-o"):
			inOptions = true
			options_box.show()
			var opCount = 1
			#create node for each option
			for val in dialogueDictionary[displayedID]["-o"]:
				var opNode = $"Control/Options Box/Option0".duplicate()
				opNode.get_node("msg").text = dialogueDictionary[val]["msg"]
				var marginSize = abs(opNode.get_node("msg").margin_top - opNode.get_node("msg").margin_bottom)
				opNode.position.y += opCount * marginSize
				opNode.set_owner(options_box)
				opNode.show()
				if (opCount != 1):
					opNode.get_node("Selected").hide()
				options_box.add_child(opNode, true)
				opCount += 1
			totalOptions = opCount - 1
			selectedOption = 1
