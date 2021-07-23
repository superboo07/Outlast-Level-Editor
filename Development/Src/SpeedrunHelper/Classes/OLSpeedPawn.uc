class OLSpeedPawn extends OLHero
config(tool);

Enum EStaminaState
{
	SS_HasStamina,
	SS_OutOfStamina
};

Enum EMovementState
{
	MS_Idle,
	MS_Walking,
	MS_Running,
	MS_Sprinting,
	MS_SpecialMove,
	MS_Vaulting,
	MS_LedgeClimbing,
	MS_Shimmying,
	MS_Other
};

var OLSpeedController SpeedController;
var OLSpeedInput Input;
var OLSpeedFunctions Function;

var bool bShouldSeizure;

var config array<ESpecialMoveType> SeizureModes;

//Bandage Stuff
var bool bNeedsBandage;
var bool bIsBandaging;
var bool bHasBandage;
var bool bDecreaseSpeed;
var float SpeedPercent;
var config float BleedingRunSpeedMultiplier;
var config float BandageTime;
var config float BleedingRunSpeedDecrease;
var config int RequireBandageAtHealth;
var config float BleedingRunSpeedDecreaseDelay;
var SoundCue BandageStartSound;
var SoundCue BandageLoopSound;
var SoundCue BandageEndSound;
var AudioComponent BandageAudioEmitter;

//Stamina Stuff
var config float RunStamina;
var float StaminaPercent;
var EStaminaState CurrentStaminaState;
var bool bOutofStamina;
var bool bReadytosprint;
var bool bGettingReadyToSprint;
var config float SprintMultiplier;
var config float StaminaDepletedRunSpeedMultiplier;
var config float StaminaPercentDecrease;
var config float StaminaDecrease;
var config float IdleStaminaIncrease;
var config float WalkStaminaIncrease;
var config float RunPercentIncrease;
var config float SprintPercentIncrease;
var config float MaximumRotationBeforePenalty;
var config float SprintMaxFOVIncrease;
var config int StaminaRotationCheckEveryTick;
var config float RunStaminaIncrease;
var rotator RotationLastTick;
var int StaminaRotationChecktick;


function PossessedBy(Controller C, bool bVehicleTransition)
{
	super.PossessedBy(C, bVehicleTransition);	
	SpeedController=OLSpeedController(C);
	Input = OLSpeedInput(SpeedController.Playerinput);
	SpeedController.InitializeHelper(Self);
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if (!SpeedController.bGodMode)
	{
		Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
		if (Health-Damage<=RequireBandageAtHealth)
		{
			WorldInfo.Game.SetTimer(0.01, false, 'RemoveBandage', self);
		}
	}
}

function TakeFallingDamage()
{
	if (!SpeedController.bGodMode)
	{
		NativeTakeFallingDamage();
		WorldInfo.Game.SetTimer(0.00001, false, 'BandageFallDamage', self);
	}
}

Function BandageFallDamage()
{
	if (Health<=RequireBandageAtHealth)
	{
		WorldInfo.Game.SetTimer(0.00001, false, 'RemoveBandage', self);
	}
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
	if (!SpeedController.bDisableKillBound)
	{
		ConsoleCommand("OpenConsoleMenu 0");
		super.FellOutOfWorld(dmgType);
	}
}

singular simulated event OutsideWorldBounds()
{
	if (!SpeedController.bDisableKillBound)
	{
		ConsoleCommand("OpenConsoleMenu 0");
		RespawnHero();
	}
}

Function EnableOL2Simulator()
{
	WorldInfo.Game.SetTimer(0.01, true, 'SpeedDecrease', self);
	WorldInfo.Game.SetTimer(0.01, true, 'StaminaRotationTick', self);
}

event Landed(Vector HitNormal, Actor FloorActor)
{
	local Vector Impulse;
	if (!SpeedController.bShouldMakeBhopsFree)
	{
		super.Landed(HitNormal, FloorActor);
		return;
	}
	TakeFallingDamage();
}

event RemoveBandage()
{
	if (SpeedController.bIsOL2BandageSimulatorEnabled && !bNeedsBandage)
	{
		bHasBandage=False;
		bNeedsBandage=True;
		HealthRegenRate=0;
		HealthRegenDelay=0;
		WorldInfo.Game.SetTimer(BleedingRunSpeedDecreaseDelay, false, 'LostEnoughBlood', self);
	}
}

Function EMovementState GetPlayerMovementState()
{
	local bool IsMoving;
	local EMovementState MoveState;

	IsMoving=Input.Movement.X!=0 || Input.Movement.Y!=0;

	if (bIsBandaging) 
	{
		MoveState=MS_Other;
		Return MoveState;
	}

	Switch ( LocomotionMode )
	{
		Case LM_SpecialMove:
			Switch (SpecialMove)
			{
				Case SMT_SlideOver: Case SMT_ClimbUpObstacle: Case SMT_ClimbUpWall: Case SMT_ClimbOverWall:
				Case SMT_StepUpAndLand: Case SMT_ClimbUpLedge: Case SMT_GrabAndClimb: Case SMT_JumpOver: Case SMT_JumpOverAndGrabLedge:
					MoveState=MS_Vaulting;
				break;

				Case SMT_AutomaticSqueeze:
					MoveState=MS_Shimmying;
				break;

				Default: MoveState=MS_SpecialMove;
			}
		break;

		Case LM_LedgeHang: Case LM_LedgeWalk:
			MoveState=MS_LedgeClimbing;
		break;

		Case LM_Squeeze:
			MoveState=MS_Shimmying;
		break;

		Case LM_Walk:
			if (IsRunning() && SpeedController.bIsOL2StaminaSimulatorEnabled && CurrentStaminaState!=SS_OutOfStamina && !bNeedsBandage && CheckRotation() && bReadytosprint && !bGettingReadyToSprint && RunStamina>=25)
			{
				MoveState=MS_Sprinting;
			}
			else if (IsRunning() )
			{
				MoveState=MS_Running;
			}
			else if (IsMoving)
			{
				MoveState=MS_Walking;
			}
			else
			{
				MoveState=MS_Idle;
			}
		break;

		Default:
			MoveState=MS_Other;
		break;
	}
	return MoveState;
}

Function IncreaseRunStamina(Float Target,Float Clamp, Optional Float SoftClamp)
{
	if (RunStamina+Target<Clamp)
	{
		RunStamina=Runstamina+Target;
		if (RunStamina>SoftClamp)
		{
			CurrentStaminaState=SS_HasStamina;
		}
	}
	else
	{
		RunStamina=Clamp;
		CurrentStaminaState=SS_HasStamina;
	}
}

Function DecreaseRunStamina(Float Target,Float Clamp)
{
	if (RunStamina-(Target * StaminaPercent)>Clamp && StaminaPercent<1.0)
	{
		RunStamina=Runstamina-(Target * StaminaPercent);
	}
	else if (RunStamina-Target>Clamp)
	{
		RunStamina = RunStamina-Target;
	}
	else
	{
		RunStamina=Clamp;
		CurrentStaminaState=SS_OutOfStamina;
	}
}

Function Bool DecreaseStaminaPercent(Float Target,Float Clamp)
{
	if (StaminaPercent-Target>Clamp)
	{
		StaminaPercent=StaminaPercent-Target;
		Return False;
	}
	else
	{
		StaminaPercent=Clamp;
		Return True;
	}
}

Function Bool IncreaseStaminaPercent(Float Target,Float Clamp)
{
	if (StaminaPercent+Target<Clamp)
	{
		StaminaPercent=StaminaPercent+Target;
		Return False;
	}
	else
	{
		StaminaPercent=Clamp;
		Return True;
	}
}

Function SpeedDecrease()
{
	local Float DecreasedNormalRunSpeed;
	local float DecreasedWaterRunSpeed;
	local float DecreasedHobblingRunSpeed;
	local float Percent;

	local EMovementState CurrentMovementState;

	CurrentMovementState=GetPlayerMovementState();

	if (SpeedController.bIsOL2BandageSimulatorEnabled && bNeedsBandage && bDecreaseSpeed)
	{
		if (SpeedPercent - BleedingRunSpeedDecrease>=BleedingRunSpeedMultiplier) 
		{
			SpeedPercent=(SpeedPercent - BleedingRunSpeedDecrease); 
		}
		else   
		{
			SpeedPercent=BleedingRunSpeedMultiplier;
		}
	}

	if (SpeedController.bIsOL2StaminaSimulatorEnabled)
	{
		Switch (CurrentMovementState)
		{
			Case MS_LedgeClimbing: Case MS_Vaulting: Case MS_Shimmying: Case MS_Walking:
				IncreaseRunStamina(WalkStaminaIncrease, Default.RunStamina, Default.RunStamina / 4);
				ClearSprint();
			break;

			Case MS_Running:
				Switch(CurrentStaminaState)
				{
					Case SS_HasStamina:
						if ( !CheckRotation() ) 
						{
							WorldInfo.Game.ClearTimer('ReadySprint', self);
							bGettingReadyToSprint=false;
						}
						DecreaseRunStamina(StaminaDecrease, 0);
						if ( IncreaseStaminaPercent(RunPercentIncrease,1) && !bGettingReadyToSprint && CurrentRunSpeed>=435.0 )
						{
							bGettingReadyToSprint=true;
							WorldInfo.Game.SetTimer(2, false, 'ReadySprint', self);
						}
					break;

					Case SS_OutOfStamina:
						IncreaseRunStamina(RunStaminaIncrease, Default.RunStamina, Default.RunStamina / 4);
						DecreaseStaminaPercent(StaminaPercentDecrease,StaminaDepletedRunSpeedMultiplier);
					ClearSprint();
					break;
				}
			break;
			
			Case MS_Sprinting:
				if (!CheckRotation()) 
				{
					WorldInfo.Game.ClearTimer('ReadySprint', self);
					bGettingReadyToSprint=false;
					break;
				}
				DecreaseRunStamina(StaminaDecrease, 0);
				IncreaseStaminaPercent(SprintPercentIncrease, SprintMultiplier);
			break;

			Default:
				IncreaseRunStamina(IdleStaminaIncrease, Default.RunStamina, Default.RunStamina / 4);
				ClearSprint();
			break;
		}
	}

	Percent = SpeedPercent * StaminaPercent; //Multiply SpeedPercent and Stamina Percnt So they both contribute

	DecreasedNormalRunSpeed=Default.NormalRunSpeed * Percent;
	DecreasedWaterRunSpeed=Default.WaterRunSpeed * Percent;
	DecreasedHobblingRunSpeed=Default.HobblingRunSpeed * Percent;
	ForwardSpeedForJumpRunning=Default.ForwardSpeedForJumpRunning * Percent;
	
	NormalRunSpeed = Function.ClampFloat(DecreasedNormalRunSpeed,NormalWalkSpeed);
	WaterRunSpeed = Function.ClampFloat(DecreasedWaterRunSpeed,WaterWalkSpeed);
	HobblingRunSpeed = Function.ClampFloat(DecreasedHobblingRunSpeed,HobblingWalkSpeed);

	if (Function.ClampFloat(Default.RunningFOV * StaminaPercent, DefaultFOV)<=SprintMaxFOVIncrease)
	{
		RunningFOV=Function.ClampFloat(Default.RunningFOV * StaminaPercent, DefaultFOV);
	}
	else
	{
		RunningFOV=SprintMaxFOVIncrease;
	}
}

Function LostEnoughBlood()
{
	bDecreaseSpeed=true;
}

Function ReadySprint()
{
	bGettingReadyToSprint=False;
	bReadytosprint=true;
}

Function ClearSprint()
{
	Switch(CurrentStaminaState)
	{
		Case SS_HasStamina:
			StaminaPercent=1;
		break;

		Case SS_OutOfStamina:
			StaminaPercent=StaminaDepletedRunSpeedMultiplier;
		break;
	}
	bReadytosprint=false;
	bGettingReadyToSprint=false;
	WorldInfo.Game.ClearTimer('ReadySprint', self);
}

event RespawnHero()
{
	ConsoleCommand("OpenConsoleMenu 0");
	super.RespawnHero();
}

Function DisableStamina()
{
	RunStamina=100;
	bOutofStamina=false;
	StaminaPercent=1.0;
}

Function StaminaRotationTick()
{
	if (StaminaRotationChecktick>StaminaRotationCheckEveryTick) //When Stamin
	{
		RotationLastTick=Rotation;
		StaminaRotationChecktick=0;
	}
	else
	{
		++StaminaRotationChecktick;
	}
}

exec Function Bandage()
{
	if (SpeedController.bIsOL2BandageSimulatorEnabled && bNeedsBandage && !bHasBandage && LocomotionMode==LM_Walk)
	{
		SpeedController.DisableInput(True);
		bIsBandaging=true;
		WorldInfo.Game.SetTimer(BandageTime, false, 'BandageFinish', self);
		BandagePlayStartAudio();
	}
}

exec Function ToggleSeizure()
{
	bShouldSeizure=!bShouldSeizure;
	If (bShouldSeizure) {Seizure();}
}

function Seizure()
{
	if (!bShouldSeizure) { Return; }

	if ( !IsSpecialMoveCompleted() ) 
	{ 
		goto Timer;
	}
	StartSpecialMove(SeizureModes[Rand(SeizureModes.Length-1)], Location, Vector(Rotation) );
	
	Timer:
	WorldInfo.Game.SetTimer(0.000000000001, false, 'Seizure', self);
}

exec Function StopBandage()
{
	if (SpeedController.bIsOL2BandageSimulatorEnabled && bNeedsBandage && !bHasBandage)
	{
		WorldInfo.Game.ClearTimer('BandageFinish', self);
		WorldInfo.Game.ClearTimer('BandagePlayAudioLoop', self);
		SpeedController.DisableInput(false);
		BisBandaging=false;
		BandageAudioEmitter.Stop();
	}
}

Function BandagePlayStartAudio()
{
	local OLProfileSettings Profile;
	local float volume;

	Profile=SpeedController.ProfileSettings;
	Profile.GetProfileSettingValueFloat(57, volume);

	BandageAudioEmitter.VolumeMultiplier=4 * volume;

	BandageAudioEmitter.SoundCue=BandageStartSound;
	BandageAudioEmitter.Play();
	WorldInfo.Game.SetTimer(BandageStartSound.Duration, false, 'BandagePlayAudioLoop', self);
}

Function BandagePlayAudioLoop()
{
	BandageAudioEmitter.SoundCue=BandageLoopSound;
	BandageAudioEmitter.Play();
}
Function BandageFinish()
{
	SpeedController.DisableInput(false);
	WorldInfo.Game.ClearTimer('BandageStartFinished', self);
	WorldInfo.Game.ClearTimer('BandageLoop', self);
	WorldInfo.Game.ClearTimer('LostEnoughBlood', self);
	BandageAudioEmitter.Stop();
	BandageAudioEmitter.SoundCue=BandageEndSound;
	BandageAudioEmitter.Play();
	bHasBandage=True;
	BisBandaging=false;
	bNeedsBandage=false;
	bDecreaseSpeed=false;
	HealthRegenRate=Default.HealthRegenRate;
	HealthRegenDelay=Default.HealthRegenDelay;
	NormalRunSpeed=Default.NormalRunSpeed;
	SpeedPercent=Default.SpeedPercent;

}

Function DisableBandage()
{
	WorldInfo.Game.ClearTimer('BandageStartFinished', self);
	WorldInfo.Game.ClearTimer('BandageLoop', self);
	WorldInfo.Game.ClearTimer('LostEnoughBlood', self);
	BandageAudioEmitter.Stop();
	bHasBandage=false;
	BisBandaging=false;
	bNeedsBandage=false;
	bDecreaseSpeed=false;
	HealthRegenRate=Default.HealthRegenRate;
	HealthRegenDelay=Default.HealthRegenDelay;
	RunSpeed=Default.NormalRunSpeed;
	SpeedPercent=Default.SpeedPercent;
}

Function Bool CheckRotation()
{
	local bool DoesExceed;

	DoesExceed = Rotation.Yaw > RotationLastTick.Yaw-Function.ConvertDegreesToRotationUnit(MakeRotator(MaximumRotationBeforePenalty,0,0)).Pitch && Rotation.Yaw<RotationLastTick.Yaw+Function.ConvertDegreesToRotationUnit( MakeRotator(MaximumRotationBeforePenalty,0,0) ).Pitch;
	
	Return DoesExceed;
}

DefaultProperties
{
	begin object name=MyLightEnvironment
		bEnabled=True
		bUseBooleanEnvironmentShadowing=false
		bSynthesizeSHLight=true
		bIsCharacterLightEnvironment=true
		bForceNonCompositeDynamicLights=true
	End Object
	LightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)

	begin object name=WPawnSkeletalMeshComponent
		LightEnvironment=MyLightEnvironment
	End Object

	//This is what is used for the shadow.
	begin object name=ShadowProxyComponent
		LightEnvironment=DynamicLightEnvironmentComponent'MyLightEnvironment'
	End Object

	// This is the head mesh seen in the shadow. 
	begin object name=HeadMeshComp
		LightEnvironment=DynamicLightEnvironmentComponent'MyLightEnvironment'
	End Object

	begin object name=BandageAudioComponent class=AudioComponent 
	End Object
	BandageAudioEmitter=BandageAudioComponent
	Components.Add(BandageAudioComponent)

	begin object name=FunctionHolder class=OLSpeedFunctions
	End Object
	Function=FunctionHolder
	Components.Add(FunctionHolder)
	
	BandageStartSound=SoundCue'SH_Audio.SoundCue.Bandage.Start'
	BandageLoopSound=SoundCue'SH_Audio.SoundCue.Bandage.Loop'
	BandageEndSound=SoundCue'SH_Audio.SoundCue.Bandage.End'
	SpeedPercent=1.0;
	RunStamina=100;
	StaminaPercent=1.0;
	CurrentStaminaState=SS_HasStamina;
}