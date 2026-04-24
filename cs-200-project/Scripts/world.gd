extends Node2D

@export var display: Label
@export var input: LineEdit
@export var timer: Timer #Shows how much time left to decode the message
@export var t2: Timer
@export var startButton: Button
@export var infoButton: Button
@export var QuitButton: Button
@export var Title: Label
@export var t3: Timer
@onready var decoded_message_list: Array[String] = [
	"Hello World",
	"You successfully decrypted this message", 
	"The quick fox jumped over the lazy dog",
	"One two three",
	"This is a message",
	"Rock and stone",
	"Beetles playing soccer",
	"Playing Outer Wilds",
	"Steam powered superweapon",
	"Ants are annoyed at aardvarks amazing alliteration",
	"Ceaser Cypher confusion",
	"Made in Godot Engine",
	"Mountain Climbing Mania",
	"Out of Bounds",
	"Recording in Questionable Locations",
	"Wandering Wizards wonder with whimsy",
	"Not a big fan of blue stop signs",
	"Your goal is to sail into the abyss",
	"You are missing a starpointe and a vessel",
	"Do you want to be a big shot",
	"The land of the marquise will soon be overrun",
	"Sealed in the temple of the Ocean King",
	"Wizard Time",
	"You may not rest there are monsters nearby",
	"Watch out for the snowman mafia",
	"A cowardly captain",
	"The dragon resides in the jungle",
	"Ceaser Cypher conundrum",
	"Mechanical mixer",
	"Today Tomorrow Yesterday send us safely on our way",
	"Wizards companion",
	"laser pointer",
	"the alphabet",
	"remote control",
	"remote access",
	"Goliath Beetle",
	"Dolphin Dive",
	"Shield Bash",
	"Once or twice",
	"perfect picnic",
	"sunny day",
	"tournament on tuesday",
	] 
var decodedMessage
var gameOver: bool = false
var score: int = 0
var encodedMessage: String
var alphabet: String = "abcdefghijklmnopqrstuvwxyz"
var infoOn: bool = false
enum cypherMode{
	CAESAR}

enum questionType{
	ENCODE,
	DECODE
}

func _ready() -> void:
	title("Quick Code Cracking")
func title(titleName:String):
	hideGameStuff()
	Title.show()
	startButton.show()
	infoButton.show()
	QuitButton.show()
	Title.text = titleName
func game_start():
	score = 0
	$HBoxContainer/ScoreDisplay.text = "Score: %d" % score
	startButton.hide()
	infoButton.hide()
	QuitButton.hide()
	Title.hide()
	showGameStuff()
	
	t3.start(1)
	timer.start(timer.wait_time)
	var min: int = floori(abs(timer.time_left/60))
	var sec: int = floori(timer.time_left)-(min*60)
	var currentTime: String = "%02d:%02d" % [min, sec]
	$HBoxContainer/TimerDisplay.text = "%s :Timer" % currentTime
	game_loop()

func game_loop():
	decodedMessage = getMessage()
	encodedMessage = encodeMessage(decodedMessage,cypherMode.CAESAR)
	display.text = encodedMessage
	print(decodedMessage)
	#print(encodedMessage)


func getMessage() -> String:
	var randInt = randi_range(0,decoded_message_list.size()-1)
	return decoded_message_list[randInt]

func encodeMessage(message:String, cypherM:cypherMode) -> String:
	#print(message)
	var newLetterIndex:int = 0
	var aindex: int = 0
	var newmessage:String = message
	if cypherM == cypherMode.CAESAR: #Shifts the letters of the alphabet down by a certain number
		var shiftValue = randi_range(1,25)
		#print(shiftValue)
		var count = 0
		for i in message:
			newLetterIndex = 0
			#print(i.to_lower())
			aindex = alphabet.find(i.to_lower())
			#print("A",aindex)
			if aindex != -1:
				newLetterIndex = aindex+shiftValue
				#print("NLI:",newLetterIndex)
				if newLetterIndex > 25:
					newLetterIndex = (newLetterIndex-26)
					#print("NLI2:",newLetterIndex)
				newmessage[message.find(i,count)]= alphabet[newLetterIndex]
				#print(newmessage[message.find(i,count)] , alphabet[newLetterIndex])
				#print(newmessage[message.find(i,count+1)] , alphabet[newLetterIndex])
				#print(count)
				
				
				#print(newmessage)
			count += 1
	return newmessage
	


func _on_timer_timeout() -> void:
	gameOver = true
	hideGameStuff()
	title("Try Again? Score: %d" % score)


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.to_lower() == decodedMessage.to_lower():
		$Correct.show()
		t2.start(1)
		score += 1
		$HBoxContainer/ScoreDisplay.text = "Score: %d" % score
		input.text = ""
		var new_time = timer.time_left + 60
		timer.stop()
		timer.start(new_time)
		game_loop()
	else:
		$Incorrect.show()
	


func _on_t_2_timeout() -> void:
	$Correct.hide()
	$Incorrect.hide()

func hideGameStuff():
	$VBoxContainer.hide()
	$HBoxContainer.hide()
	display.hide()
	input.hide()
	$Correct.hide()
	$Incorrect.hide()
	$Instructions.hide()
func showGameStuff():
	$HBoxContainer.show()
	$VBoxContainer.show()
	display.show()
	input.show()
	


func _on_start_button_pressed() -> void:
	game_start()


func _on_info_pressed() -> void:
	if infoOn:
		$Instructions.hide()
		infoOn = false
	else:
		$Instructions.show()
		infoOn = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_t_3_timeout() -> void:
	if !gameOver:
		var min: int = floori(abs(timer.time_left/60))
		var sec: int = floori(timer.time_left)-(min*60)
		var currentTime: String = "%02d:%02d" % [min, sec]
		$HBoxContainer/TimerDisplay.text = "%s :Timer" % currentTime
		t3.start(1)
