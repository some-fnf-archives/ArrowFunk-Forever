package gameObjects;

/**
	The character class initialises any and all characters that exist within gameplay. For now, the character class will
	stay the same as it was in the original source of the game. I'll most likely make some changes afterwards though!
**/
import flixel.FlxG;
import flixel.addons.util.FlxSimplex;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import gameObjects.userInterface.HealthIcon;
import meta.*;
import meta.data.*;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

typedef CharacterData = {
	var offsetX:Float;
	var offsetY:Float;
	var camOffsetX:Float;
	var camOffsetY:Float;
	var quickDancer:Bool;
}

class Character extends FNFSprite
{
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bidu';
	public var barColor:Int;

	public var holdTimer:Float = 0;

	public var characterData:CharacterData;
	public var adjustPos:Bool = true;

	public var animationDisabled:Bool = false;

	public function new(?isPlayer:Bool = false)
	{
		super(x, y);
		this.isPlayer = isPlayer;
		
		// if the character has no Bar Color, it will use the default one
		// Lime for Boyfriend, Red for Dad
		barColor = isPlayer ? 0xFF66FF33 : 0xFFFF0000;
	}

	public function setCharacter(x:Float, y:Float, character:String):Character
	{
		curCharacter = character;
		var tex:FlxAtlasFrames;
		antialiasing = true;

		characterData = {
			offsetY: 0,
			offsetX: 0, 
			camOffsetY: 0,
			camOffsetX: 0,
			quickDancer: false
		};

		switch (curCharacter)
		{
			case 'kevin':
				barColor = 0xFFffffff;
				tex = Paths.getSparrowAtlas('characters/KevinLOL');
				frames = tex;
				animation.addByPrefix('cheer', 'KEVIN Cheer', 24, false);
				animation.addByIndices('danceLeft', 'KEVIN Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'KEVIN Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				animation.addByPrefix('singUP', 'KEVIN Up Note', 24, false);
				animation.addByPrefix('singLEFT', 'KEVIN left note', 24, false);
				animation.addByPrefix('singRIGHT', 'KEVIN Right Note', 24, false);
				animation.addByPrefix('singDOWN', 'KEVIN Down Note', 24, false);

				playAnim('danceRight');

				characterData.offsetX = 50;
				characterData.offsetY = -100;

			// barbara pq tem mtas variações e eu tive que fazer tudinho num lugar só
			case 'barbara':
				tex = Paths.getSparrowAtlas('characters/BARBARA');
				frames = tex;
				animation.addByPrefix('cheer', 'BARBARA Cheer', 24, false);
				animation.addByIndices('sad', 'BARBARA sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'BARBARA Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'BARBARA Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('shock', 'BARBAR Shock', 24);

				playAnim('danceRight');

			case 'barbara-blue':
				tex = Paths.getSparrowAtlas('characters/BARBARA_BLUE');
				frames = tex;
				animation.addByPrefix('cheer', 'BARBARA Cheer', 24, false);
				animation.addByIndices('sad', 'BARBARA sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'BARBARA Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'BARBARA Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('shock', 'BARBAR Shock', 24);

				playAnim('danceRight');

			case 'barbara-blue-bite':
				tex = Paths.getSparrowAtlas('characters/BARBARA_BLUE_BITE');
				frames = tex;
				animation.addByPrefix('cheer', 'BARBARA Cheer', 24, false);
				animation.addByIndices('sad', 'BARBARA sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'BARBARA Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'BARBARA Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('shock', 'BARBARA Shock', 24);

				playAnim('danceRight');

			case 'barbara-raspberry':
				tex = Paths.getSparrowAtlas('characters/BARBARA_RASPBERRY');
				frames = tex;
				animation.addByPrefix('cheer', 'BARBARA Cheer', 24, false);
				animation.addByIndices('sad', 'BARBARA sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'BARBARA Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'BARBARA Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('danceLeftSUS', 'BARBARA SUS Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRightSUS', 'BARBARA SUS Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				playAnim('danceRight');

				characterData.offsetX = -35;

			case 'barbara-chocolate':
				tex = Paths.getSparrowAtlas('characters/BARBARA_CHOCOLATE');
				frames = tex;
				animation.addByPrefix('cheer', 'BARBARA Cheer', 24, false);
				animation.addByPrefix('drink', 'BARBARA Drink', 24);
				animation.addByIndices('sad', 'BARBARA sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'BARBARA Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'BARBARA Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		
				playAnim('danceRight');

			case 'barbara-chocolate-sunset':
				tex = Paths.getSparrowAtlas('characters/BARBARA_CHOCOLATE_SUNSET');
				frames = tex;
				animation.addByPrefix('cheer', 'BARBARA Cheer', 24, false);
				animation.addByPrefix('scared', 'BARBARA Shock', 24, false);
				animation.addByPrefix('spit', 'BARBARA Spit', 24, false);
				animation.addByPrefix('drink', 'BARBARA Drink', 24);
				animation.addByIndices('sad', 'BARBARA sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'BARBARA Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'BARBARA Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	
				playAnim('danceRight');

			case 'barbara-chocolate-sunset-scared':
				tex = Paths.getSparrowAtlas('characters/BARBARA_CHOCOLATE_SUNSET');
				frames = tex;
				animation.addByPrefix('cheer', 'BARBARA Cheer', 24, false);
				animation.addByPrefix('scared', 'BARBARA Shock', 24, false);
				animation.addByPrefix('spit', 'BARBARA Spit', 24, false);
				animation.addByPrefix('drink', 'BARBARA Drink', 24);
				animation.addByIndices('sad', 'BARBARA sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'BARBARA Dancing Beat alt', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'BARBARA Dancing Beat alt', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		
				playAnim('danceRight');

			case 'barbara-chocolate-night':
				tex = Paths.getSparrowAtlas('characters/BARBARA_CHOCOLATE_NIGHT');
				frames = tex;

				animation.addByPrefix('scared', 'BARBARA Shock', 24, false);
				animation.addByIndices('sad', 'BARBARA sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'BARBARA Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'BARBARA Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		
				playAnim('danceRight');

			case 'barbara-dark':
				tex = Paths.getSparrowAtlas('characters/BARBARA_DARK');
				frames = tex;
	
				animation.addByPrefix('cheer', 'BARBARA Cheer', 24, false);
				animation.addByIndices('sad', 'BARBARA sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'BARBARA Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'BARBARA Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		
				playAnim('danceRight');

			case 'lemon':
				tex = Paths.getSparrowAtlas('characters/LIMAO_PODRE');
				frames = tex;

				animation.addByIndices('danceLeft', 'LEMON Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'LEMON Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				playAnim('danceRight');

				characterData.offsetX = -334;
				characterData.offsetY = -112;

			case 'bidu':
				frames = Paths.getSparrowAtlas('characters/BIDU');

				// common/special animations
				animation.addByPrefix('idle', 'BIDU idle dance', 24, false);
				animation.addByPrefix('hey', 'BIDU HEY', 24, false);
				animation.addByPrefix('damage', 'BIDU DAMAGE', 24, false);

				// sing animations
				animation.addByPrefix('singUP', 'BIDU NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BIDU NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BIDU NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BIDU NOTE DOWN0', 24, false);

				// alt animations
				animation.addByPrefix('singDOWN-alt', 'BIDU BEATBOX DOWN0', 24, false);
				animation.addByPrefix('singUP-alt', 'BIDU BEATBOX UP0', 24, false);

				// dodge animations
				animation.addByPrefix('singLEFT-dodge', 'BIDU NOTE LEFT DODGE0', 24, false);
				animation.addByPrefix('singDOWN-dodge', 'BIDU NOTE DOWN DODGE0', 24, false);
				animation.addByPrefix('singUP-dodge', 'BIDU NOTE UP DODGE0', 24, false);
				animation.addByPrefix('singRIGHT-dodge', 'BIDU NOTE RIGHT DODGE0', 24, false);

				// miss animations
				animation.addByPrefix('singUPmiss', 'BIDU NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BIDU NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BIDU NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BIDU NOTE DOWN MISS', 24, false);


				// death animations
				animation.addByPrefix('firstDeath', "BIDU dies", 24, false);
				animation.addByPrefix('deathLoop', "BIDU Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BIDU Dead confirm", 24, false);

				playAnim('idle');

			case 'bidu-dark':
				frames = Paths.getSparrowAtlas('characters/BIDU_DARK');
	
				// common/special animations
				animation.addByPrefix('idle', 'BIDU idle dance', 24, false);
				animation.addByPrefix('hey', 'BIDU HEY', 24, false);
				animation.addByPrefix('damage', 'BIDU DAMAGE', 24, false);
	
				// sing animations
				animation.addByPrefix('singUP', 'BIDU NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BIDU NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BIDU NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BIDU NOTE DOWN0', 24, false);
	
				// alt animations
				animation.addByPrefix('singDOWN-alt', 'BIDU BEATBOX DOWN0', 24, false);
				animation.addByPrefix('singUP-alt', 'BIDU BEATBOX UP0', 24, false);
	
				// dodge animations
				animation.addByPrefix('singLEFT-dodge', 'BIDU NOTE LEFT DODGE0', 24, false);
				animation.addByPrefix('singDOWN-dodge', 'BIDU NOTE DOWN DODGE0', 24, false);
				animation.addByPrefix('singUP-dodge', 'BIDU NOTE UP DODGE0', 24, false);
				animation.addByPrefix('singRIGHT-dodge', 'BIDU NOTE RIGHT DODGE0', 24, false);
	
				// miss animations
				animation.addByPrefix('singUPmiss', 'BIDU NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BIDU NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BIDU NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BIDU NOTE DOWN MISS', 24, false);
	
				playAnim('idle');

			case 'bidu-gold':
				frames = Paths.getSparrowAtlas('characters/BIDU_GOLD');
	
				// common/special animations
				animation.addByPrefix('idle', 'BIDU idle dance', 24, false);
				animation.addByPrefix('hey', 'BIDU HEY', 24, false);
				animation.addByPrefix('damage', 'BIDU DAMAGE', 24, false);
	
				// sing animations
				animation.addByPrefix('singUP', 'BIDU NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BIDU NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BIDU NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BIDU NOTE DOWN0', 24, false);
	
				// alt animations
				animation.addByPrefix('singDOWN-alt', 'BIDU BEATBOX DOWN0', 24, false);
				animation.addByPrefix('singUP-alt', 'BIDU BEATBOX UP0', 24, false);
	
				// dodge animations
				animation.addByPrefix('singLEFT-dodge', 'BIDU NOTE LEFT DODGE0', 24, false);
				animation.addByPrefix('singDOWN-dodge', 'BIDU NOTE DOWN DODGE0', 24, false);
				animation.addByPrefix('singUP-dodge', 'BIDU NOTE UP DODGE0', 24, false);
				animation.addByPrefix('singRIGHT-dodge', 'BIDU NOTE RIGHT DODGE0', 24, false);
	
				// miss animations
				animation.addByPrefix('singUPmiss', 'BIDU NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BIDU NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BIDU NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BIDU NOTE DOWN MISS', 24, false);

				// death animations
				animation.addByPrefix('firstDeath', "BIDU dies", 24, false);
				animation.addByPrefix('deathLoop', "BIDU Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BIDU Dead confirm", 24, false);
	
				playAnim('idle');

			case 'bidu-gold-night':
				frames = Paths.getSparrowAtlas('characters/BIDU_GOLD_NIGHT');
		
				// common/special animations
				animation.addByPrefix('idle', 'BIDU idle dance', 24, false);
				animation.addByPrefix('hey', 'BIDU HEY', 24, false);
				animation.addByPrefix('damage', 'BIDU DAMAGE', 24, false);
		
				// sing animations
				animation.addByPrefix('singUP', 'BIDU NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BIDU NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BIDU NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BIDU NOTE DOWN0', 24, false);
		
				// alt animations
				animation.addByPrefix('singDOWN-alt', 'BIDU BEATBOX DOWN0', 24, false);
				animation.addByPrefix('singUP-alt', 'BIDU BEATBOX UP0', 24, false);
		
				// dodge animations
				animation.addByPrefix('singLEFT-dodge', 'BIDU NOTE LEFT DODGE0', 24, false);
				animation.addByPrefix('singDOWN-dodge', 'BIDU NOTE DOWN DODGE0', 24, false);
				animation.addByPrefix('singUP-dodge', 'BIDU NOTE UP DODGE0', 24, false);
				animation.addByPrefix('singRIGHT-dodge', 'BIDU NOTE RIGHT DODGE0', 24, false);
		
				// miss animations
				animation.addByPrefix('singUPmiss', 'BIDU NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BIDU NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BIDU NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BIDU NOTE DOWN MISS', 24, false);
	
				// death animations
				animation.addByPrefix('firstDeath', "BIDU dies", 24, false);
				animation.addByPrefix('deathLoop', "BIDU Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BIDU Dead confirm", 24, false);
		
				playAnim('idle');

			case 'bidu-gold-night-alt':
				frames = Paths.getSparrowAtlas('characters/BIDU_GOLD_NIGHT_ALT');
		
				// common/special animations
				animation.addByPrefix('idle', 'BIDU idle dance', 24, false);
				animation.addByPrefix('hey', 'BIDU HEY', 24, false);
				animation.addByPrefix('damage', 'BIDU DAMAGE', 24, false);
		
				// sing animations
				animation.addByPrefix('singUP', 'BIDU NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BIDU NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BIDU NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BIDU NOTE DOWN0', 24, false);
		
				// alt animations
				animation.addByPrefix('singDOWN-alt', 'BIDU BEATBOX DOWN0', 24, false);
				animation.addByPrefix('singUP-alt', 'BIDU BEATBOX UP0', 24, false);
		
				// dodge animations
				animation.addByPrefix('singLEFT-dodge', 'BIDU NOTE LEFT DODGE0', 24, false);
				animation.addByPrefix('singDOWN-dodge', 'BIDU NOTE DOWN DODGE0', 24, false);
				animation.addByPrefix('singUP-dodge', 'BIDU NOTE UP DODGE0', 24, false);
				animation.addByPrefix('singRIGHT-dodge', 'BIDU NOTE RIGHT DODGE0', 24, false);
		
				// miss animations
				animation.addByPrefix('singUPmiss', 'BIDU NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BIDU NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BIDU NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BIDU NOTE DOWN MISS', 24, false);
		
				// death animations
				animation.addByPrefix('firstDeath', "BIDU dies", 24, false);
				animation.addByPrefix('deathLoop', "BIDU Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BIDU Dead confirm", 24, false);
		
				playAnim('idle');

			case 'bidu-spooky':
				frames = Paths.getSparrowAtlas('characters/BIDU_SPOOKY');
	
				// common/special animations
				animation.addByPrefix('idle', 'BIDU idle dance', 24, false);
				animation.addByPrefix('hey', 'BIDU HEY', 24, false);
	
				// sing animations
				animation.addByPrefix('singUP', 'BIDU NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BIDU NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BIDU NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BIDU NOTE DOWN0', 24, false);
	
				// miss animations
				animation.addByPrefix('singUPmiss', 'BIDU NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BIDU NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BIDU NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BIDU NOTE DOWN MISS', 24, false);
	
				playAnim('idle');
			
			
			case 'bidu-virus':
				barColor = 0xFFff5087;
				frames = Paths.getSparrowAtlas('characters/BIDU_SPOOKY_VIRUS');
	
				// common/special animations
				animation.addByPrefix('idle', 'BIDU idle dance', 24, false);
				animation.addByPrefix('hey', 'BIDU HEY', 24, false);
				animation.addByPrefix('damage', 'BIDU DAMAGE', 24, false);
	
				// sing animations
				animation.addByPrefix('singUP', 'BIDU NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BIDU NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BIDU NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BIDU NOTE DOWN0', 24, false);
	
				// miss animations
				animation.addByPrefix('singUPmiss', 'BIDU NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BIDU NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BIDU NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BIDU NOTE DOWN MISS', 24, false);

				// death animations
				animation.addByPrefix('firstDeath', "BIDU dies", 24, false);
				animation.addByPrefix('deathLoop', "BIDU Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BIDU Dead confirm", 24, false);
	
				playAnim('idle');
				flipX = true;
				characterData.offsetX = 65;
				characterData.offsetY = 25;
				characterData.camOffsetX = 40;
				characterData.camOffsetY = 10;

			case 'bidu-pixel': // esse filho da puta ta crashando o game tmnc - Gazozoz //NAO CRASHA MAIS LESS FUCKING GOOOOOOOOOOO
				barColor = 0xFFff5f9b;
				frames = Paths.getSparrowAtlas('characters/biduPixel');

				// common animation
				animation.addByPrefix('idle', 'BIDU idle dance', 24, false);

				// sing animations
				animation.addByPrefix('singUP', 'BIDU NOTE UP', 24, false);
				animation.addByPrefix('singLEFT', 'BIDU NOTE RIGHT', 24, false);
				animation.addByPrefix('singRIGHT', 'BIDU NOTE LEFT', 24, false);
				animation.addByPrefix('singDOWN', 'BIDU NOTE DOWN', 24, false);

				playAnim('idle');
	
				antialiasing = false;
				flipX = true;
				characterData.offsetX = -50;
				characterData.offsetY = -350;
				characterData.camOffsetY = 10;
				characterData.camOffsetX = 40;

			case 'sagu':
				barColor = 0xFFffaf00;
				tex = Paths.getSparrowAtlas('characters/SAGU');
				frames = tex;

				// common animation
				animation.addByPrefix('idle', 'Sagu idle dance', 24, false);

				// sing animations
				animation.addByPrefix('singUP', 'Sagu Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Sagu Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Sagu Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Sagu Sing Note LEFT', 24);

				// alt animations
				animation.addByPrefix('singDOWN-alt', 'Sagu Beatbox DOWN', 24);
				animation.addByPrefix('singUP-alt', 'Sagu Beatbox UP', 24);

			case 'sagu-fire':
				tex = Paths.getSparrowAtlas('characters/SAGU_FIRE');
				frames = tex;
	
				// common/special animations
				animation.addByPrefix('idle', 'Sagu idle dance', 24, false);
				animation.addByPrefix('throwmic', 'Sagu mic throw', 24, false);
				animation.addByPrefix('micend', 'Sagu end animation', 24, false);
	
				// sing animations
				animation.addByPrefix('singUP', 'Sagu Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Sagu Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Sagu Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Sagu Sing Note LEFT', 24);

			case 'sagu-fire-dark':
				tex = Paths.getSparrowAtlas('characters/SAGU_FIRE_DARK');
				frames = tex;
		
				// common animation
				animation.addByPrefix('idle', 'Sagu idle dance', 24, false);
		
				// sing animations
				animation.addByPrefix('singUP', 'Sagu Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Sagu Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Sagu Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Sagu Sing Note LEFT', 24);

			case 'bidu-dead':
				frames = Paths.getSparrowAtlas('characters/BF_DEATH');

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				playAnim('firstDeath');

				flipX = true;
				
			case 'kids':
				barColor = 0xFF4b2e73;
				tex = Paths.getSparrowAtlas('characters/KIDS');
				frames = tex;

				// common/special animations
				animation.addByPrefix('idle', 'spooky dance idle', 24, false);
				animation.addByPrefix('hey', 'spooky kids YEAH!!', 24, false);
				animation.addByPrefix('skeletons', 'spooky scary', 24, false);

				// sing animations
				animation.addByPrefix('singUP', 'spooky up', 24, false);
				animation.addByPrefix('singLEFT', 'spooky left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky right', 24, false);
				animation.addByPrefix('singDOWN', 'spooky down', 24 , false);

				playAnim('idle');

			case 'kids-happy':
				barColor = 0xFF4b2e73;
				tex = Paths.getSparrowAtlas('characters/KIDS_HAPPY');
				frames = tex;

				// common/special animations
				animation.addByPrefix('idle', 'spooky dance idle', 24, false);
				animation.addByPrefix('skeletons', 'spooky scary', 24, false);

				// sing animations
				animation.addByPrefix('singUP', 'spooky up', 24, false);
				animation.addByPrefix('singLEFT', 'spooky left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky right', 24, false);
				animation.addByPrefix('singDOWN', 'spooky down', 24 , false);

				playAnim('idle');

			case 'kids-virus':
				barColor = 0xFF9BF600;
				tex = Paths.getSparrowAtlas('characters/KIDS_VIRUS');
				frames = tex;

				// common/special animations
				animation.addByPrefix('idle', 'spooky dance idle', 24, false);
				animation.addByPrefix('skeletons', 'spooky scary', 24, false);

				// sing animations
				animation.addByPrefix('singUP', 'spooky up', 24, false);
				animation.addByPrefix('singLEFT', 'spooky left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky right', 24, false);
				animation.addByPrefix('singDOWN', 'spooky down', 24 , false);

				playAnim('idle');

			case 'dono':
				tex = Paths.getSparrowAtlas('characters/DONO');
				frames = tex;
	
				// common animation
				animation.addByPrefix('idle', 'Dono Idle Dance', 24, false);
	
				// sing animations
				animation.addByPrefix('singUP', 'Dono Up note', 24, false);
				animation.addByPrefix('singLEFT', 'Dono NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'Dono Note Right', 24, false);
				animation.addByPrefix('singDOWN', 'Dono Down Note', 24, false);
	
				playAnim('idle');

				characterData.camOffsetX = 20;
				characterData.camOffsetY = 40;

			case 'dono-gun':
				tex = Paths.getSparrowAtlas('characters/DONO_GUN');
				frames = tex;
		
				// common/special animations
				animation.addByPrefix('idle', 'Dono Idle Dance', 24, false);
				animation.addByPrefix('fail', 'Dono Fail', 24, false);
				animation.addByPrefix('out', 'Dono Out', 24, false);
		
				// sing animations
				animation.addByPrefix('singUP', 'Dono Up note0', 24, false);
				animation.addByPrefix('singLEFT', 'Dono NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'Dono Note Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Dono Down Note0', 24, false);
	
				// shoot animations
				animation.addByPrefix('singUP-shoot', 'Dono Note Up shoot', 24, false);
				animation.addByPrefix('singLEFT-shoot', 'Dono Note Left shoot', 24, false);
				animation.addByPrefix('singRIGHT-shoot', 'Dono Note Right shoot', 24, false);
				animation.addByPrefix('singDOWN-shoot', 'Dono Note Down shoot', 24, false);
		
				playAnim('idle');
	
				characterData.offsetX = -4;
				characterData.offsetY = 2;
				characterData.camOffsetX = -30;
				characterData.camOffsetY = 50;

			case 'dono-gun-night':
				tex = Paths.getSparrowAtlas('characters/DONO_GUN_NIGHT');
				frames = tex;
		
				// common/special animations
				animation.addByPrefix('idle', 'Dono Idle Dance', 24, false);
				animation.addByPrefix('fail', 'Dono Fail', 24, false);
				animation.addByPrefix('out', 'Dono Out', 24, false);
		
				// sing animations
				animation.addByPrefix('singUP', 'Dono Up note0', 24, false);
				animation.addByPrefix('singLEFT', 'Dono NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'Dono Note Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Dono Down Note0', 24, false);
	
				// shoot animations
				animation.addByPrefix('singUP-shoot', 'Dono Note Up shoot', 24, false);
				animation.addByPrefix('singLEFT-shoot', 'Dono Note Left shoot', 24, false);
				animation.addByPrefix('singRIGHT-shoot', 'Dono Note Right shoot', 24, false);
				animation.addByPrefix('singDOWN-shoot', 'Dono Note Down shoot', 24, false);
		
				playAnim('idle');
	
				characterData.offsetX = -4;
				characterData.offsetY = 2;
				characterData.camOffsetX = -30;
				characterData.camOffsetY = 50;

			case 'dono-doublegun-night':
				barColor = 0xFF285064;
				tex = Paths.getSparrowAtlas('characters/DONO_DOUBLEGUN_NIGHT');
				frames = tex;
		
				// common/special animations
				animation.addByPrefix('idle', 'Dono Idle Dance', 24, false);
				animation.addByPrefix('mic', 'Dono mic', 24, false);
				animation.addByPrefix('hey', 'Dono hey', 24, false);
		
				// sing animations
				animation.addByPrefix('singUP', 'Dono Up note0', 24, false);
				animation.addByPrefix('singLEFT', 'Dono NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'Dono Note Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Dono Down Note0', 24, false);
		
				// shoot animations
				animation.addByPrefix('singUP-shoot', 'Dono Note Up shoot', 24, false);
				animation.addByPrefix('singLEFT-shoot', 'Dono Note Left shoot', 24, false);
				animation.addByPrefix('singRIGHT-shoot', 'Dono Note Right shoot', 24, false);
				animation.addByPrefix('singDOWN-shoot', 'Dono Note Down shoot', 24, false);
		
				playAnim('idle');
		
				characterData.offsetX = -3;
				characterData.offsetY = 2;
				characterData.camOffsetX = -52;
				characterData.camOffsetY = 52;

			case 'salsicha':
				barColor = 0xFF9bc328;
				tex = Paths.getSparrowAtlas('characters/SALSICHA');
				frames = tex;

				// common/special animations
				animation.addByPrefix('idle', 'Salsicha Idle', 24, false);
				animation.addByPrefix('tampa', 'Salsicha Tampa', 24, false);
				animation.addByPrefix('risada', 'Salsicha Risada', 24, false);

				// sing animations
				animation.addByPrefix('singUP', 'Salsicha Up', 24, false);
				animation.addByPrefix('singLEFT', 'Salsicha Down', 24, false);
				animation.addByPrefix('singRIGHT', 'Salsicha Right', 24, false);
				animation.addByPrefix('singDOWN', 'Salsicha Left', 24, false);

				playAnim('idle');

				characterData.camOffsetX = 60;
				characterData.camOffsetY = 80;

			case 'salsicha-bombado':
				barColor = 0xFF73ffff;
				tex = Paths.getSparrowAtlas('characters/SALSICHA_BOMBADO');
				frames = tex;

				// common animations
				animation.addByPrefix('idle', 'Salsicha Idle', 24, false);

				// sing animations
				animation.addByPrefix('singUP', 'Salsicha Up', 24, false);
				animation.addByPrefix('singLEFT', 'Salsicha Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Salsicha Right', 24, false);
				animation.addByPrefix('singDOWN', 'Salsicha Down', 24, false);

				playAnim('idle');

				characterData.offsetX = 10;
				characterData.camOffsetX = -60;
				characterData.camOffsetY = -80;
				
			default:
				// set up animations if they aren't already

				// fyi if you're reading this this isn't meant to be well made, it's kind of an afterthought I wanted to mess with and
				// I'm probably not gonna clean it up and make it an actual feature of the engine I just wanted to play other people's mods but not add their files to
				// the engine because that'd be stealing assets
				var fileNew = curCharacter + 'Anims';
				if (OpenFlAssets.exists(Paths.offsetTxt(fileNew)))
				{
					var characterAnims:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt(fileNew));
					var characterName:String = characterAnims[0].trim();
					frames = Paths.getSparrowAtlas('characters/$characterName');
					for (i in 1...characterAnims.length)
					{
						var getterArray:Array<Array<String>> = CoolUtil.getAnimsFromTxt(Paths.offsetTxt(fileNew));
						animation.addByPrefix(getterArray[i][0], getterArray[i][1].trim(), 24, false);
					}
				}
				else 
					return setCharacter(x, y, 'bidu'); 					
		}

		switch(curCharacter)
		{
			case 'sagu-fire' | 'sagu-fire-dark':
				barColor = 0xFFaf4b87;
			case 'bidu' | 'bidu-dark' | 'bidu-spooky' | 'bidu-gold' | 'bidu-gold-night' | 'bidu-gold-night-alt':
				barColor = 0xFFff5087;
				flipX = true;
				characterData.offsetX = 70;
				characterData.camOffsetY = 10;
			case 'kids' | 'kids-virus' | 'kids-happy':
				characterData.offsetX = 10;
				characterData.offsetY = -40;
				characterData.camOffsetX = 70;
			case 'barbara-chocolate' | 'barbara-chocolate-sunset' | 'barbara-chocolate-sunset-scared' | 'barbara-chocolate-night' | 'barbara-dark':
				characterData.offsetX = -40;
			case 'dono' | 'dono-gun-night' | 'dono-gun':
				barColor = 0xFF286450;
		}

		// set up offsets cus why not
		if (OpenFlAssets.exists(Paths.offsetTxt(curCharacter + 'Offsets')))
		{
			var characterOffsets:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt(curCharacter + 'Offsets'));
			for (i in 0...characterOffsets.length)
			{
				var getterArray:Array<Array<String>> = CoolUtil.getOffsetsFromTxt(Paths.offsetTxt(curCharacter + 'Offsets'));
				addOffset(getterArray[i][0], Std.parseInt(getterArray[i][1]), Std.parseInt(getterArray[i][2]));
			}
		}

		dance();

		if (isPlayer) // fuck you ninjamuffin lmao
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bidu'))
				flipLeftRight();
			//
		}
		else if (curCharacter.startsWith('bidu'))
			flipLeftRight();

		if (adjustPos) {
			x += characterData.offsetX;
			trace('character ${curCharacter} scale ${scale.y}');
			y += (characterData.offsetY - (frameHeight * scale.y));
		}

		this.x = x;
		this.y = y;
		
		return this;
	}

	function flipLeftRight():Void
	{
		// get the old right sprite
		var oldRight = animation.getByName('singRIGHT').frames;

		// set the right to the left
		animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;

		// set the left to the old right
		animation.getByName('singLEFT').frames = oldRight;

		// insert ninjamuffin screaming I think idk I'm lazy as hell

		if (animation.getByName('singRIGHTmiss') != null)
		{
			var oldMiss = animation.getByName('singRIGHTmiss').frames;
			animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
			animation.getByName('singLEFTmiss').frames = oldMiss;
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}
	
			var dadVar:Float = 4;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		var curCharSimplified:String = simplifyCharacter();
		switch (curCharSimplified)
		{
			case 'barbara':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
				if ((animation.curAnim.name.startsWith('sad')) && (animation.curAnim.finished))
					playAnim('danceLeft');
		}

		// Post idle animation (think Week 4 and how the player and mom's hair continues to sway after their idle animations are done!)
		if (animation.curAnim.finished && animation.curAnim.name == 'idle')
		{
			// We look for an animation called 'idlePost' to switch to
			if (animation.getByName('idlePost') != null)
				// (( WE DON'T USE 'PLAYANIM' BECAUSE WE WANT TO FEED OFF OF THE IDLE OFFSETS! ))
				animation.play('idlePost', true, false, 0);
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?forced:Bool = false)
	{
		if (!debugMode)
		{
			var curCharSimplified:String = simplifyCharacter();
			switch (curCharSimplified)
			{
				case 'barbara':
					if ((!animation.curAnim.name.startsWith('hair')) && (!animation.curAnim.name.startsWith('sad')))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', forced);
						else
							playAnim('danceLeft', forced);
					}
				default:
					// Left/right dancing, think Skid & Pump
					if (animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null) {
						danced = !danced;
						if (danced)
							playAnim('danceRight', forced);
						else
							playAnim('danceLeft', forced);
					}
					else
						playAnim('idle', forced);
			}
		}
	}

	override public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (!animationDisabled)
		{
			if (animation.getByName(AnimName) != null)
				super.playAnim(AnimName, Force, Reversed, Frame);

			if (curCharacter == 'barbara')
			{
				if (AnimName == 'singLEFT')
					danced = true;
				else if (AnimName == 'singRIGHT')
					danced = false;

				if (AnimName == 'singUP' || AnimName == 'singDOWN')
					danced = !danced;
			}
		}
	}

	public function simplifyCharacter():String
	{
		var base = curCharacter;

		if (base.contains('-'))
			base = base.substring(0, base.indexOf('-'));
		return base;
	}
}
