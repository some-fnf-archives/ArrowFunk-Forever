package meta.state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.dependency.Discord;
import meta.data.font.Alphabet;
import meta.state.menus.*;
import openfl.Assets;

using StringTools;

/**
	I hate this state so much that I gave up after trying to rewrite it 3 times and just copy pasted the original code
	with like minor edits so it actually runs in forever engine. I'll redo this later, I've said that like 12 times now

	I genuinely fucking hate this code no offense ninjamuffin I just dont like it and I don't know why or how I should rewrite it
**/
class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var bfSpr:FlxSprite;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		controls.setKeyboardScheme(None, false);
		curWacky = FlxG.random.getObject(getIntroTextShit());
		super.create();

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			startIntro();
		});
	}

	var gfDance:FlxSprite;
	var chess:FlxBackdrop;
	var danceLeft:Bool = false;

	function startIntro()
	{
		if (!initialized)
		{
			///*
			#if !html5
			Discord.changePresence('TITLE SCREEN', 'Main Menu');
			#end			
		}

		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/arrow/title/titlebg1'));
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		chess = new FlxBackdrop(Paths.image('menus/arrow/otherassets/mebg'), 0, 0, true, false);
		chess.y -= 80;
		add(chess);

		chess.offset.x -= 0;
		chess.offset.y += 0;
		chess.velocity.x = 20;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/arrow/menuBGoverlay'));
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('menus/arrow/title/gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		gfDance.y -= 35;
		gfDance.x -= 570;
		add(gfDance);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/arrow/title/titlebg0'));
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('menus/arrow/title/newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		bfSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('menus/arrow/otherassets/bufren'));
		add(bfSpr);
		bfSpr.visible = false;
		bfSpr.setGraphicSize(Std.int(bfSpr.width * 0.8));
		bfSpr.updateHitbox();
		bfSpr.screenCenter(X);
		bfSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
		{	
			ForeverTools.resetMenuMusic(true);
			initialized = true;
		}

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var swagGoodArray:Array<Array<String>> = [];
		if (Assets.exists(Paths.txt('introText')))
		{
			var fullText:String = Assets.getText(Paths.txt('introText'));
			var firstArray:Array<String> = fullText.split('\n');

			for (i in firstArray)
				swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			FlxTween.tween(FlxG.camera, {x:2000}, 3.4, {ease: FlxEase.expoInOut});
			FlxTween.tween(gfDance, {y:2000}, 3.4, {ease: FlxEase.expoInOut});
			FlxTween.tween(gfDance, {angle:180}, 3.8, {ease: FlxEase.expoInOut});

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				// Check if version is outdated

				var version:String = "v" + Application.current.meta.get('version');
				/*
					if (version.trim() != NGio.GAME_VER_NUMS.trim() && !OutdatedSubState.leftState)
					{
						FlxG.switchState(new OutdatedSubState());
						trace('OLD VERSION!');
						trace('old ver');
						trace(version.trim());
						trace('cur ver');
						trace(NGio.GAME_VER_NUMS.trim());
					}
					else
					{ */
				Main.switchState(this, new MainMenuState());
				closedState = true;
				// }
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		// hi game, please stop crashing its kinda annoyin, thanks!
		if (pressedEnter && !skippedIntro && initialized)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	private static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');

		FlxG.log.add(curBeat);

		if(!closedState) {
			//sickBeats++;
			switch (curBeat)
			{
				case 1:
					createCoolText(['Mod by'], 15);
				case 2:
					deleteCoolText();
					createCoolText(['Mod by yoisabo'], 15);
				case 3:
					addMoreText('roxo depressivo', 15);
				case 4:
					addMoreText('hiro mizuki', 15);
				case 5:
					addMoreText('im not sonic', 15);
				case 6:
					deleteCoolText();
					addMoreText('beastlychip', 15);
				case 7:
					addMoreText('tio sans', 15);
				case 8:
					addMoreText('tyefling', 15);
				case 9:
					deleteCoolText();
					createCoolText(['Forever Port by'], 15);
				case 10:
					addMoreText('beastlyghost', 15);
				case 11:
					addMoreText('gazozoz', 15);
				case 12:
					deleteCoolText();
				case 13:
					createCoolText(['NOT'], -40);
				case 14:
					deleteCoolText();
					createCoolText(['Not ASSOCIATED'], -40);
				case 15:
					deleteCoolText();
					createCoolText(['Not associated WITH'], -40);
				case 16:
					addMoreText('', -40);
					addMoreText('newgrounds', -40);
					ngSpr.visible = true;
				case 17:
					deleteCoolText();
					ngSpr.visible = false;
					createCoolText(['another'], 15);
				case 18:
					deleteCoolText();
					createCoolText(['another "remix"'], 15);
				case 19:
					deleteCoolText();
					createCoolText(['another "remix" mod'], 15);
				case 20:
					addMoreText('yaay', 15);
				case 21:
					deleteCoolText();
					createCoolText(['i dont know'], 15);	
				case 22:
					deleteCoolText();
					createCoolText(['i dont know what to'], 15);	
				case 23:
					deleteCoolText();
					createCoolText(['i dont know what to'], 15);	
					addMoreText('write here', 15);
					addMoreText('LOL', 15);
				case 24:
					deleteCoolText();
					addMoreText('look at this little dude', 15);

				case 25:
					bfSpr.visible = true;

				case 26:
					deleteCoolText();
					bfSpr.visible = false;
					addMoreText(curWacky[0]);

				case 27:
					addMoreText(curWacky[1]);
				case 28:
					deleteCoolText();
					createCoolText(['fnf'], -40);

				case 29:
					addMoreText('arrow', -40);

				case 30:
					addMoreText('funk', -40);

				case 31:
					deleteCoolText();
					addMoreText('', -40);
					addMoreText('LESGOOOOOOOO', -40);


				case 32:
					deleteCoolText();
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.camera.zoom = 1.4;
			FlxTween.tween(FlxG.camera, {zoom: 1}, 3.5, {ease: FlxEase.expoOut});
			remove(credGroup);
			skippedIntro = true;
		}
		//
	}
}
