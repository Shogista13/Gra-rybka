class_name Player extends CharacterBody2D
signal hit

@export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):
	if Input.is_action_pressed("move_right"):
		print("Right key pressed")
	
func _physics_process(delta: float) -> void:
	self.velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		self.velocity.x += 1
	if Input.is_action_pressed("move_left"):
		self.velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		self.velocity.y += 1
	if Input.is_action_pressed("move_up"):
		self.velocity.y -= 1
	if self.velocity.length() > 0:
		self.velocity = self.velocity.normalized() * speed
	if velocity.x**2+velocity.y**2 != 0:
		if velocity.x < 0:
			$AnimatedSprite2D.animation = "left"
			$AnimatedSprite2D.flip_h = false
		elif velocity.x > 0:
			$AnimatedSprite2D.animation = "left"
			$AnimatedSprite2D.flip_h = true
	move_and_slide()

func _on_body_entered(body: Node2D):
	hit.emit()
