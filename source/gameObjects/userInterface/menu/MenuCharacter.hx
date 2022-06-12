package gameObjects.userInterface.menu;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class MenuCharacter extends FlxSprite
{
	public var character:String = '';

	var curCharacterMap:Map<String, Array<Dynamic>> = [
		// the format is currently
		// name of character => id in atlas, fps, loop, scale, offsetx, offsety
		'bidu' => ["BiduDance", 24, true, 0.4, 0, 500],
		'biduConfirm' => ['BiduHey', 24, false,  0.4, 0, 0],
		'kevin' => ["KevinDance", 24, true, 0.67, -145, 35],
		'barbara' => ["BarbaraDance", 24, true,  0.53, -45, 7],
		'sagu' => ["SaguDance", 24, true, 0.32, 58, -38],
		'kids' => ["SpookyDance(lol)", 24, true,  0.4, -5, 6],
		'dono' => ["DonoDance", 24, true,  0.4, -10, 84]
	];

	var baseX:Float = 0;
	var baseY:Float = 0;

	public function new(x:Float, newCharacter:String = 'bidu')
	{
		super(x);
		y += 70;

		baseX = x;
		baseY = y;

		createCharacter(newCharacter);
		updateHitbox();
	}

	public function createCharacter(newCharacter:String, canChange:Bool = false)
	{
		var tex = Paths.getSparrowAtlas('menus/arrow/storymenu/campaign_menu_UI_characters');
		frames = tex;
		var assortedValues = curCharacterMap.get(newCharacter);
		if (assortedValues != null)
		{
			if (!visible)
				visible = true;

			// animation
			animation.addByPrefix(newCharacter, assortedValues[0], assortedValues[1], assortedValues[2]);
			// if (character != newCharacter)
			animation.play(newCharacter);

			if (canChange)
			{
				// offset
				setGraphicSize(Std.int(width * assortedValues[3]));
				updateHitbox();
				setPosition(baseX + assortedValues[4], baseY + assortedValues[5]);
			}
		}
		else
			visible = false;

		character = newCharacter;
	}
}
