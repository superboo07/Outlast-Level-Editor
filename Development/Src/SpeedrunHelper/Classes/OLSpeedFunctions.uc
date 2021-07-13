class OLSpeedFunctions extends ActorComponent;

Function Float ClampFloat(Float Input, Float Input2)
{
	if (Input>Input2)
	{
		Return Input;
	}
	else
	{
		Return Input2;
	}
}

Function Bool ContainsString(Array<String> Array, String find)
{
	Switch(Array.Find(find))
	{
		case -1:
			Return False;
		break;

		Default:
			Return true;
		Break;
	}
}

Function Rotator ConvertRotationUnitToDegrees(Rotator Rotation)
{
	Return Rotation * 0.005493;
}

Function Rotator ConvertDegreesToRotationUnit(Rotator Rotation)
{
	Return Rotation * 182.044449;
}

Function String Vect2DtoString(Vector2D Vector)
{
	Return Vector.X$", "$Vector.Y;
}