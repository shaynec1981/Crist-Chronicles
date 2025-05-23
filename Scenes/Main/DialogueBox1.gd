extends Sprite # Acknowledged: Unusual base class for a UI element.

@onready var _name = $LabelName
@onready var _text = $LabelText
@onready var indicatorImg = $Indicator
@onready var animationPlayer = $AnimationPlayer

var textArray = []
var messageIndex = 0

func _ready():
	pass

func _displayText(name, text):
	indicatorImg.visible = true
	animationPlayer.play("indicator")
	textArray.clear() # Valid in Godot 4
	_name.text = name
	var charCount = text.length() # Valid
	var lastCharIndex
	if charCount > 230:
		var tempStringContainer = text
		var i = 0
		# Using float for division and then ceil is fine. int() cast is fine.
		var iterationsTotal = int(ceil(float(charCount) / 230.0)) 
		while i <= iterationsTotal: # Loop condition seems okay, check original logic if it was i < iterationsTotal
			if i != iterationsTotal:
				lastCharIndex = tempStringContainer.findn(" ", 230) # Valid
				if lastCharIndex == -1: # If no space found after 230 chars, take the whole remaining string or fixed length
					lastCharIndex = tempStringContainer.length() # Or some other handling for very long words
					if lastCharIndex > 230 && i != iterationsTotal : # still ensure we are trying to split if not last iteration
						# this case could be handled by taking min(length, 230) if no space
						# for now, keeping original logic's potential to take a long segment if no space
						lastCharIndex = tempStringContainer.find(" ", 0) # try to find any space
						if lastCharIndex == -1 || lastCharIndex > 230 : lastCharIndex = 230 # fallback to hard cut
						
				textArray.append(tempStringContainer.substr(0, lastCharIndex)) # Valid
				tempStringContainer = tempStringContainer.substr(lastCharIndex + 1) # Reassign for erase behavior
			else:
				textArray.append(tempStringContainer)
			i += 1
		splitMessage()
	else: # Entire message fits in one box
		_text.text = text
		
func splitMessage():
	if messageIndex < textArray.size(): # Ensure messageIndex is valid
		_text.text = textArray[messageIndex]
		messageIndex += 1
	else: # No more messages to show from this split, or array was empty
		hide() # Assuming hide() is a method of Sprite or a custom method
		indicatorImg.visible = false
		animationPlayer.stop()

	
func processLongMessage():
	if messageIndex < textArray.size() && textArray.size() != 0: # Check if there are more parts
		splitMessage()
	else:
		messageIndex = 0
		textArray.clear() # Clear array when done
		hide() # Assuming hide() is a method of Sprite or a custom method
		indicatorImg.visible = false
		animationPlayer.stop()
