behaviour("SlideBehaviour")

local CHECKBOOL = false
local JUMPBOOL = false
local SLIDEBOOL = false
local DEFAULTSPEED, SLIDESPEED, GROUNDDECEL, AIRDECEL, SOUND
local SOUNDARR

function SlideBehaviour:Start()
	DEFAULTSPEED = self.script.mutator.GetConfigurationFloat("DEFAULTSPEED")
	SLIDESPEED = self.script.mutator.GetConfigurationFloat("SLIDESPEED")
	GROUNDDECEL = self.script.mutator.GetConfigurationFloat("GROUNDDECEL")
	AIRDECEL = self.script.mutator.GetConfigurationFloat("AIRDECEL")
	SOUND = self.script.mutator.GetConfigurationDropdown("SOUND")
	
	if(SOUND == 0)
	then
		SOUNDARR = {self.targets.ca, self.targets.cb, self.targets.cc, self.targets.cd, self.targets.ce}
	elseif(SOUND == 1)
	then
		SOUNDARR = {self.targets.da, self.targets.db, self.targets.dc, self.targets.dd, self.targets.de}
	elseif(SOUND == 2)
	then
		SOUNDARR = {self.targets.ga, self.targets.gb, self.targets.gc, self.targets.gd, self.targets.ge}
	elseif(SOUND == 3)
	then
		SOUNDARR = {self.targets.sa, self.targets.sb, self.targets.sc, self.targets.sd, self.targets.se}
	else
		print(SOUND)
	end
end

function SlideBehaviour:Update()
	if(Input.GetKeyBindButton(KeyBinds.Crouch))
	then
		if(Player.actor.velocity.magnitude == 0)
		then
			Player.actor.speedMultiplier = DEFAULTSPEED -- Stop sliding when crouched and not moving
			SLIDEBOOL = false
		end
		
		if(Player.actor.speedMultiplier > DEFAULTSPEED)
		then
			if(Player.actorIsGrounded)
			then
				Player.actor.speedMultiplier = Player.actor.speedMultiplier - GROUNDDECEL -- Full deceleration on ground
			else
				Player.actor.speedMultiplier = Player.actor.speedMultiplier - AIRDECEL -- Reduced deceleration in air
			end
		end
	elseif(Player.actorIsGrounded or SLIDEBOOL)
	then
		Player.actor.speedMultiplier = DEFAULTSPEED -- Stop sliding when not crouched
		SLIDEBOOL = false
	end

	if(Player.actor.isSprinting)
	then
		CHECKBOOL = true
	else
		if(Input.GetKeyBindButton(KeyBinds.Crouch) and Player.actorIsGrounded and CHECKBOOL) -- Start sliding
		then
			SLIDEBOOL = true
			Player.actor.speedMultiplier = DEFAULTSPEED + SLIDESPEED
			AudioSource.PlayClipAtPoint(SOUNDARR[Mathf.Floor(Random.Range(1,6))], Player.actor.position)
			CHECKBOOL = false
		end
		CHECKBOOL = false
	end
	
end