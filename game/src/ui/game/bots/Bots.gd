extends Node2D

var game_over = false

var home_score
var away_score
var goals

var animation_player


func _ready():
	get_tree().paused = false
	TouchHelper.reset()
	home_score = $Score/HomeScore
	away_score = $Score/AwayScore
	
	animation_player = $AnimationPlayer
	
	if Global.music:
		Global.music_loop.fade_out()
	if Global.sfx:
		$Field/Sounds/Crowd.play()
		
	goals = $Field/Goals
	goals.connect("home_goal",self,"_home_goal")
	goals.connect("away_goal",self,"_away_goal")
	
	animation_player.play("FadeIn")
	
	
	# break game or simulation
	if (Global.is_worldcup and Global.current_league_game is String) or (Global.current_league_game != null and Global.current_league_game["away"]["id"] == 0):
		game_over = true
		get_tree().paused = true
		$Pause.queue_free()
		
		# for simulation
		if Global.current_league_game is String:
			Global.game_over(0,0, true)
		else:
			Global.game_over(0,0)
			
		$Player.queue_free()
		$Computer.queue_free()
		$Ball.queue_free()
		
		$LeagueGameover.show()
		Global.music_loop.fade_in()
	
func _home_goal():
	print('home')
	home_score.goal()
	$Field.goal_sound()
	$Field/Commentator.home_goal()
	$Ball/RigidBody2D.on_home_goal()
		

func _away_goal():
	print("away")
	away_score.goal()
	$Field.goal_sound()
	$Field/Commentator.away_goal()
	$Ball/RigidBody2D.on_away_goal()
		
	
func _process(delta):
	if Global.current_league_game == null &&  (away_score.goals == Global.round_limit || home_score.goals == Global.round_limit) && !game_over:
		if home_score.goals == Global.round_limit:
			$Field/Commentator.win()
#			var player = $Player/Body/AnimationPlayer
#			player.play("Win")
#			yield(player,"animation_finished")
		else:
#			var player = $Computer/Body/AnimationPlayer
#			player.play("Win")
#			yield(player,"animation_finished")
			$Field/Commentator.loose()
		game_over = true
		Global.game_over(home_score.goals,away_score.goals)
		get_tree().paused = true
		$Pause.queue_free()
		$Computer2.queue_free()
		$Computer.queue_free()
		$Ball.queue_free()
		$GameOver.show()
		Global.music_loop.fade_in()
	elif  Global.current_league_game != null && (away_score.goals == 5 || home_score.goals == 5) && !game_over:
			if home_score.goals == 5:
				$Field/Commentator.win()
#				var player = $Player/Body/AnimationPlayer
#				player.play("Win")
#				yield(player,"animation_finished")
			else:
#				var player = $Computer/Body/AnimationPlayer
#				player.play("Win")
#				yield(player,"animation_finished")
				$Field/Commentator.loose()
			game_over = true
			get_tree().paused = true
			$Pause.queue_free()
			Global.game_over(home_score.goals,away_score.goals)
			$Computer2.queue_free()
			$Computer.queue_free()
			$Ball.queue_free()
			$LeagueGameover.show()
			Global.music_loop.fade_in()
					



