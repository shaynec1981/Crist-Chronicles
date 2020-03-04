extends Sprite

onready var _name = $LabelName
onready var _text = $LabelText
onready var indicatorImg = $Indicator
onready var animationPlayer = $AnimationPlayer

var textArray = []
var messageIndex = 0

func _ready():
	pass

func _displayText(name, text):
	indicatorImg.visible = true
	animationPlayer.play("indicator")
	textArray.clear()
	_name.text = name
	var charCount = text.length()
	var lastCharIndex
	if charCount > 230:
		var tempStringContainer = text
		var i = 0
		var iterationsTotal = int(ceil(charCount / 230))
		while i <= iterationsTotal:
			if i != iterationsTotal:
				lastCharIndex = tempStringContainer.findn(" ", 230) # Find the next space so full last word is included.
				textArray.append(tempStringContainer.substr(0, lastCharIndex))
				tempStringContainer.erase(0, lastCharIndex + 1)
			else:
				textArray.append(tempStringContainer)
			i += 1
		splitMessage()
	else: # Entire message fits in one box
		_text.text = text
		
func splitMessage():
	_text.text = textArray[messageIndex]
	messageIndex += 1
	
func processLongMessage():
	if messageIndex != textArray.size() && textArray.size() != 0:
		splitMessage()
	else:
		
		messageIndex = 0
		hide()
		indicatorImg.visible = false
		animationPlayer.stop()
