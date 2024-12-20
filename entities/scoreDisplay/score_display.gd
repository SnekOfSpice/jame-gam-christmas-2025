extends NinePatchRect

@onready
var score_label = $RichTextLabel

var current_score := 0

func _ready():
	score_label.text = "0"

func set_score(new_score: int) -> void:
	var final_score = current_score + new_score
	#current_score += new_score
	var tween = create_tween()
	tween.tween_method(set_text, current_score, final_score, .8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	#score_label.text = str(current_score)
	await tween.finished
	current_score = final_score

func set_text(value):
	score_label.text = str(value)
