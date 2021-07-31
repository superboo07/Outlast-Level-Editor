class SHBandageFunny extends SHModifier;

var bool bNeedsBandage, bHasBandage, bIsBandaging;

var config float BandageTime;

var config int RequireBandageAtHealth;

var SoundCue BandageStartSound, BandageLoopSound, BandageEndSound;
var AudioComponent BandageAudioEmitter;

event bool onEnable()
{
    if (Game.SHOptions.GetSHBool("GodMode")) 
	{
        Game.BroadcastHandler.Broadcast(self, "Simulate Bandages cannot be turned on while GodMode is enabled");
        return false;
    }
    Hero.onTakeDamage=TakeDamage;
    Hero.onTakeFallingDamage=TakeFallingDamage;
    return true;
}

event onDisable()
{
    Game.ClearTimer('BandageStartFinished', self);
	Game.ClearTimer('BandageLoop', self);
	Game.ClearTimer('LostEnoughBlood', self);
	BandageAudioEmitter.Stop();
	bHasBandage=false;
	BisBandaging=false;
	bNeedsBandage=false;
	//bDecreaseSpeed=false;
	Hero.HealthRegenRate=Hero.Default.HealthRegenRate;
	Hero.HealthRegenDelay=Hero.Default.HealthRegenDelay;
	Hero.NormalRunSpeed=Hero.Default.NormalRunSpeed;
	//SpeedPercent=Default.SpeedPercent;
}

Event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Hero.onTakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    if (Hero.Health-Damage<=RequireBandageAtHealth)
	{
		Game.SetTimer(0.01, false, 'RemoveBandage', self);
	}
}

function TakeFallingDamage()
{
    Hero.onTakeFallingDamage=None;
    Hero.onTakeFallingDamage();
    Hero.onTakeFallingDamage=TakeFallingDamage;
    WorldInfo.Game.SetTimer(0.00001, false, 'BandageFallDamage', self);
}

Function BandageFallDamage()
{
	if (Hero.Health<=RequireBandageAtHealth)
	{
		WorldInfo.Game.SetTimer(0.00001, false, 'RemoveBandage', self);
	}
}

Function Bandage()
{
    if (bNeedsBandage && !bHasBandage && Hero.LocomotionMode==LM_Walk)
	{
        Controller.DisableInput(True);
	    bIsBandaging=true;
	    Game.SetTimer(BandageTime, false, 'BandageFinish', self);
	    BandagePlayStartAudio();
    }
}

Function BandagePlayStartAudio()
{
	local OLProfileSettings Profile;
	local float volume;

	Profile=Controller.ProfileSettings;
	Profile.GetProfileSettingValueFloat(57, volume);

	BandageAudioEmitter.VolumeMultiplier=4 * volume;

	BandageAudioEmitter.SoundCue=BandageStartSound;
	BandageAudioEmitter.Play();
	Game.SetTimer(BandageStartSound.Duration, false, 'BandagePlayAudioLoop', self);
}

Function BandagePlayAudioLoop()
{
	BandageAudioEmitter.SoundCue=BandageLoopSound;
	BandageAudioEmitter.Play();
}

Function BandageFinish()
{
	Controller.DisableInput(false);
	WorldInfo.Game.ClearTimer('BandageStartFinished', self);
	WorldInfo.Game.ClearTimer('BandageLoop', self);
	WorldInfo.Game.ClearTimer('LostEnoughBlood', self);
	BandageAudioEmitter.Stop();
	BandageAudioEmitter.SoundCue=BandageEndSound;
	BandageAudioEmitter.Play();
	bHasBandage=True;
	BisBandaging=false;
	bNeedsBandage=false;
	Hero.HealthRegenRate=Hero.Default.HealthRegenRate;
	Hero.HealthRegenDelay=Hero.Default.HealthRegenDelay;
	Hero.NormalRunSpeed=Hero.Default.NormalRunSpeed;
    //bDecreaseSpeed=false;
	//SpeedPercent=Default.SpeedPercent;
}

event RemoveBandage()
{
	if (!bNeedsBandage)
	{
		bHasBandage=False;
		bNeedsBandage=True;
		Hero.HealthRegenRate=0;
		Hero.HealthRegenDelay=0;
		//Game.SetTimer(BleedingRunSpeedDecreaseDelay, false, 'LostEnoughBlood', self);
	}
}

Function StopBandage()
{
	if (bNeedsBandage && !bHasBandage)
	{
		Game.ClearTimer('BandageFinish', self);
		Game.ClearTimer('BandagePlayAudioLoop', self);
		Controller.DisableInput(false);
		BisBandaging=false;
		BandageAudioEmitter.Stop();
	}
}

DefaultProperties
{
    begin object name=BandageAudioComponent class=AudioComponent 
	End Object
	BandageAudioEmitter=BandageAudioComponent
	Components.Add(BandageAudioComponent)

    BandageStartSound=SoundCue'SH_Audio.SoundCue.Bandage.Start'
	BandageLoopSound=SoundCue'SH_Audio.SoundCue.Bandage.Loop'
	BandageEndSound=SoundCue'SH_Audio.SoundCue.Bandage.End'
}