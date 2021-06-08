class OLSpeedPawn extends OLHero;

var bool GodMode;

var bool DisableKillBound;

function PossessedBy(Controller C, bool bVehicleTransition)
{
    `Log("Player Respawned");
    OLSpeedController(C).InitPlayerModel();
    super.PossessedBy(C, bVehicleTransition);    
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (!GodMode)
    {
        Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    }
}

function TakeFallingDamage()
{
    if (!GodMode)
    {
        Super.TakeFallingDamage();
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

event RespawnHero()
{
    ConsoleCommand("OpenConsoleMenu 0");
    super.RespawnHero();
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
}