extends CharacterBody2D
var gravity : Vector2
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
func _ready(): ## gets ready for character to move
	gravity = Vector2(0, 100) ## sets gravity 
	pass # Replace with function body.


func _get_input(): ## gets user input and reacts accordinhgly
	if is_on_floor(): ## checks to see if we're on the floor
		if Input.is_action_pressed("move_left"): ## checks to see if user pressed the key that indicates they want to move left
			velocity += Vector2(-movement_speed,0) ## changes the movement speed to the set movement speed

		if Input.is_action_pressed("move_right"): ## checks to see if user pressed the key that indicates they want to move right 
			velocity += Vector2(movement_speed,0) ## changes the movement speed to the set movement speed

		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			velocity += Vector2(1,-jump_height) ## moves the character up the amount of the given jump height

	if not is_on_floor(): ## checks if character is in the air 
		if Input.is_action_pressed("move_left"): ## checks if key is pressed indicating user wants to move left
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0) ## moves the character left but applies horizontal air coefficient, slowing them down

		if Input.is_action_pressed("move_right"): ## checks if key is pressed indicating user wants to move right
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0) ## moves the character right but applies horizontal air coefficient, slowing them down 

func _limit_speed():## limits character speed
	if velocity.x > speed_limit: ## checks to see if velocity is greater than speed limit
		velocity = Vector2(speed_limit, velocity.y) ## sets velocity to speed limit

	if velocity.x < -speed_limit: ## checks if velocity is less than negative speed limit
		velocity = Vector2(-speed_limit, velocity.y) ## sets velocity to negative speed limit

func _apply_friction(): ## applies friction
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")): ## checks to see if character is on floor and still
		velocity -= Vector2(velocity.x * friction, 0) ## applies friction by subtracting velocity times friction from velocity
		if abs(velocity.x) < 5: ## checks if absolute value of velocity is less than 5
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero

func _apply_gravity(): ## applies gravity
	if not is_on_floor(): ## checks if character is in air
		velocity += gravity ## adds effect of gravity to speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta): ## does the physics. many of these things do exactly what their names suggest.
	_get_input() ## gets user input (action pressed) 
	_limit_speed() ## limits speed of character's movement 
	_apply_friction() ## applies friction to character's movement
	_apply_gravity() ## applies gravity to character's movement

	move_and_slide() ## this isn't used in this script, but i imagine it moves and slides the character?? 
	pass ## passes data from above methods
