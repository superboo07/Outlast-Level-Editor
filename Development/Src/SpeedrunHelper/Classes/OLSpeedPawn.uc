class OLSpeedPawn extends OLHero
config(tool);

var OLSpeedController SpeedController;

var config int RequireBandageAtHealth;
var config float BandageTime;

var bool GodMode;
var bool DisableKillBound;

//Bandage Stuff
var bool NeedsBandage;
var bool bIsBandaging;
var bool HasBandage;
var SoundCue BandageStartSound;
var SoundCue BandageLoopSound;
var SoundCue BandageEndSound;
var AudioComponent BandageAudioEmitter;


function PossessedBy(Controller C, bool bVehicleTransition)
{
    `Log("Player Respawned");
    OLSpeedController(C).InitPlayerModel();
    super.PossessedBy(C, bVehicleTransition);    
    SpeedController=OLSpeedController(C);
    SpeedController.SpeedPawn=self;
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (!GodMode)
    {
        Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        WorldInfo.Game.SetTimer(0.00001, false, 'RemoveBandage', self);
    }
}

function TakeFallingDamage()
{
    if (!GodMode)
    {
        NativeTakeFallingDamage();
        WorldInfo.Game.SetTimer(0.00001, false, 'RemoveBandage', self);
    }
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    if (!DisableKillBound)
    {
        ConsoleCommand("OpenConsoleMenu 0");
        super.FellOutOfWorld(dmgType);
    }
}

singular simulated event OutsideWorldBounds()
{
    if (!DisableKillBound)
    {
        ConsoleCommand("OpenConsoleMenu 0");
        RespawnHero();
    }
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    if (!SpeedController.BhopFree)
    {
        super.Landed(HitNormal, FloorActor);
        return;
    }
}

event Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);
}

event RemoveBandage()
{
    if (Health<=RequireBandageAtHealth && SpeedController.Bandage)
    {
        HasBandage=False;
        NeedsBandage=True;
        HealthRegenRate=0;
        HealthRegenDelay=0;
    }
}

event RespawnHero()
{
    ConsoleCommand("OpenConsoleMenu 0");
    super.RespawnHero();
}

exec Function Bandage()
{
    if (SpeedController.Bandage && NeedsBandage && !HasBandage)
    {
        SpeedController.DisableInput(True);
        bIsBandaging=true;
        WorldInfo.Game.SetTimer(BandageTime, false, 'BandageFinish', self);
        BandagePlayStartAudio();
    }
}

exec Function StopBandage()
{
    if (SpeedController.Bandage && NeedsBandage && !HasBandage)
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
    BandageAudioEmitter.Stop();
    BandageAudioEmitter.SoundCue=BandageEndSound;
    BandageAudioEmitter.Play();
    HasBandage=True;
    BisBandaging=false;
    NeedsBandage=false;
    HealthRegenRate=Default.HealthRegenRate;
    HealthRegenDelay=Default.HealthRegenDelay;
}

Function DisableBandage()
{
    WorldInfo.Game.ClearTimer('BandageStartFinished', self);
    WorldInfo.Game.ClearTimer('BandageLoop', self);
    BandageAudioEmitter.Stop();
    HasBandage=false;
    BisBandaging=false;
    NeedsBandage=false;
    HealthRegenRate=Default.HealthRegenRate;
    HealthRegenDelay=Default.HealthRegenDelay;
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
    
    BandageStartSound=SoundCue'SH_Audio.SoundCue.Bandage.Start'
    BandageLoopSound=SoundCue'SH_Audio.SoundCue.Bandage.Loop'
    BandageEndSound=SoundCue'SH_Audio.SoundCue.Bandage.End'
}