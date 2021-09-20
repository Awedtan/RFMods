behaviour("WallBehaviour")

local WALLSPEED, WALLACCEL

local DEFAULTSPEED
local DEFAULTSPEEDBOOL = true
local WALLBOOL = false
local BOOSTTIME = 30
local BOOST = 40
local BOOSTINCREMENT = 0
local BOOSTBOOL = false
local GROUNDTIME = 10
local GROUNDINCREMENT = 0
		
function WallBehaviour:Start()
	WALLSPEED = self.script.mutator.GetConfigurationFloat("WALLSPEED")
end

function StopWallRun()
	Player.ResetVelocity()
	BOOSTINCREMENT = 0
	INCREMENT = 0
	BOOST = 40
	BOOSTBOOL = false
	WALLBOOL = false
end

function WallBehaviour:Update()
	if(DEFAULTSPEEDBOOL)
	then
		DEFAULTSPEED = Player.actor.speedMultiplier
		DEFAULTSPEEDBOOL = false
	end
	
	if(not Player.actorIsGrounded and Player.actor.isSprinting) -- Player is sprinting and airborne
	then
		if(Mathf.Sqrt(Mathf.Pow(Player.actor.velocity.x, 2) + Mathf.Pow(Player.actor.velocity.z, 2)) > (6.4 * Player.actor.speedMultiplier)) -- Player is moving at full horizontal speed, PROBABLY not running against a wall
		then
			if(WALLBOOL) -- Prevent player from slamming to the ground after wall run ends
			then
				StopWallRun()
			end
			WALLBOOL = false
		end
		
		if((Player.actor.velocity.magnitude < (6.3 * Player.actor.speedMultiplier) and Player.actor.velocity.magnitude > (1 * Player.actor.speedMultiplier)) and not Player.actor.isParachuteDeployed or WALLBOOL) -- If player is PROBABLY running against a wall
		then
			if(Player.actor.velocity.y < 0) -- Only wall run after y-velocity is below zero
			then
				WALLBOOL = true
				BOOSTBOOL = true
			
				Player.MoveActor(Vector3(0, -Player.actor.velocity.y/BOOST, 0)) -- Apply vertical boost to keep player up
				BOOSTINCREMENT = BOOSTINCREMENT + 1
				if(BOOSTINCREMENT >= BOOSTTIME) -- Reduce boost strength after a while
				then
					BOOST = 60
				end
			
				if(Player.actor.speedMultiplier < DEFAULTSPEED + WALLSPEED)
				then
					Player.actor.speedMultiplier = Player.actor.speedMultiplier + 0.04
				end
			end
		end
	elseif(not Player.actor.isSprinting and WALLBOOL) -- Player stops sprinting, cancels wall run
	then
		StopWallRun()
	end
	
	if(Player.actorIsGrounded and (BOOSTBOOL or not Input.GetKeyBindButton(KeyBinds.Crouch))) -- Stop wall running when in contact with the ground for 10 consecutive ticks
	then
		GROUNDINCREMENT = GROUNDINCREMENT + 1
		
		if(GROUNDINCREMENT >= GROUNDTIME)
		then
			StopWallRun()
			Player.actor.speedMultiplier = DEFAULTSPEED
		end
	end
	
	if(not Player.actorIsGrounded)
	then
		GROUNDINCREMENT = 0
	end
	
	if(Player.actor.isParachuteDeployed)
	then
		StopWallRun()
	end
	
end