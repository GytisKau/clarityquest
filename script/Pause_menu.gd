extends Control

@export_file var mainMenu
var paused = false
#@export var cross: Label
@onready var questions = $"../Questions"
#@export var retry: ColorRect
@onready var resume_button: Button = $VBoxContainer/GridContainer/ResumeButton
@onready var restart_button: Button = $VBoxContainer/GridContainer/RestartButton
@onready var main_menu_button: Button = $VBoxContainer/GridContainer/MainMenuButton

# Called when the node enters the scene tree for the first time.
func _ready():
	resume_button.text = Global.translation["Resume"]
	restart_button.text = Global.translation["Restart"]
	main_menu_button.text = Global.translation["Main menu"]
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		pauseMenu()


func pauseMenu():
	paused = !paused
	get_tree().paused = paused
	if paused:
		show()
	else:
		hide()

func _on_resume_button_pressed():
	pauseMenu()

func _on_main_menu_button_pressed():
	get_tree().paused = not get_tree().paused
	if get_tree().change_scene_to_file(mainMenu) != OK:
		printerr("Cant change scene to mainMenu")

func _on_restart_button_pressed():
	get_tree().paused = false
	if get_tree().reload_current_scene() != OK:
		printerr("Cant reload current scene")

func _on_settings_button_pressed():
	pauseMenu()
