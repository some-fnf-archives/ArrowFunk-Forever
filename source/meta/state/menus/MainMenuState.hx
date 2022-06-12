package meta.state.menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.Discord;

using StringTools;

/**
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class MainMenuState extends MusicBeatState
{
	var menuItems:FlxTypedGroup<FlxSprite>;
	private static var curSelected:Float = 0;

	var bg:FlxSprite; // the background has been separated for more control
	var magenta:FlxSprite;
	var chess:FlxBackdrop;
	var overlay:FlxSprite;
	var menushit:FlxSprite;
	var camFollow:FlxObject;

	var optionShit:Array<String> = ['story_mode', 'freeplay', 'options', 'credits'];
	var canSnap:Array<Float> = [];

	private static var firstStart:Bool = true;
	private static var finishedFunnyMove:Bool = false;

	// the create 'state'
	override function create()
	{
		super.create();

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		Main.doNumberOffset = false;

		// make sure the music is playing
		ForeverTools.resetMenuMusic();

		#if !html5
		Discord.changePresence('MENU SCREEN', 'Main Menu');
		#end

		// uh
		persistentUpdate = persistentDraw = true;

		// background
		bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/arrow/menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		chess = new FlxBackdrop(Paths.image('menus/arrow/otherassets/mebg'), 0, 0, true, false);
		chess.scrollFactor.set(0, 0.1);
		chess.y -= 80;
		add(chess);

		chess.offset.x -= 0;
		chess.offset.y += 0;
		chess.velocity.x = 20;

		var gradient:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('menus/arrow/otherassets/freeplay/fpbgradient'));
		gradient.scrollFactor.set(0, 0);
		gradient.updateHitbox();
		gradient.screenCenter();
		gradient.antialiasing = true;
		add(gradient);

		menushit = new FlxSprite();
		menushit.frames = Paths.getSparrowAtlas('menus/arrow/otherassets/shit');
		menushit.antialiasing = true;
		menushit.animation.addByPrefix('story', "storymode", 24);
		menushit.animation.addByPrefix('free', "freeplay", 24);
		menushit.animation.addByPrefix('opt', "options", 24);
		menushit.animation.addByPrefix('cred', "credits", 24);
		menushit.animation.play('story');
		menushit.scrollFactor.set(0, 0.1);
		menushit.x -= 1200;
		menushit.screenCenter(Y);
		add(menushit);

		// vem
		if (firstStart)
			FlxTween.tween(menushit, {x: -150}, 2.4, {ease: FlxEase.expoInOut});
		else
			menushit.x = -150;

		overlay = new FlxSprite(0).loadGraphic(Paths.image('menus/arrow/otherassets/mmov2'));
		overlay.scrollFactor.set(0, 0);
		overlay.x += 1200;
		overlay.updateHitbox();
		overlay.antialiasing = true;
		add(overlay);

		// vem
		if (firstStart)
			FlxTween.tween(overlay, {x: 0}, 2.4, {ease: FlxEase.expoInOut});
		else
			overlay.x = 0;

		magenta = new FlxSprite(-85).loadGraphic(Paths.image('menus/arrow/menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		// add the camera
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		// add the menu items
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		// create the menu items themselves
		//var tex = Paths.getSparrowAtlas('menus/base/title/FNF_main_menu_assets');
		
		var scale:Float = 0.4;

		// loop through the menu options
		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 130)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.x += 2000;
			//menuItem.y -= 50;
			
			menuItem.frames = Paths.getSparrowAtlas('menus/arrow/buttons/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = true;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
			menuItem.scale.set(0.8, 0.8);

			if (firstStart)
			{
				switch(i)
				{
					case 0:
						FlxTween.tween(menuItem, {x:650}, 2.4, {ease: FlxEase.expoInOut});
					case 1:
						FlxTween.tween(menuItem, {x:620}, 2.4, {ease: FlxEase.expoInOut});
					case 2:
						FlxTween.tween(menuItem, {x:590}, 2.4, {ease: FlxEase.expoInOut});
					case 3:
						FlxTween.tween(menuItem, {x:560}, 2.4, {ease: FlxEase.expoInOut});
					case 4:
						FlxTween.tween(menuItem, {x:530}, 2.4, {ease: FlxEase.expoInOut});
					case 5:
						FlxTween.tween(menuItem, {x:500}, 2.4, {ease: FlxEase.expoInOut});
				}
				finishedFunnyMove = true; 
			}
			else
			{
				switch(i)
				{
					case 0:
						menuItem.x = 650;
					case 1:
						menuItem.x = 620;
					case 2:
						menuItem.x = 590;
					case 3:
						menuItem.x = 560;
					case 4:
						menuItem.x = 530;
					case 5:
						menuItem.x = 500;
				}
			}
		}

		firstStart = false;

		// set the camera to actually follow the camera object that was created before
		var camLerp = Main.framerateAdjust(0.10);

		// faz a coisa
		if (firstStart)
			FlxG.camera.flash(FlxColor.BLACK, 1.5);
		
		FlxG.camera.follow(camFollow, null, camLerp);

		updateSelection();

		// from the base game lol

		var arrowFunky:FlxText = new FlxText(5, FlxG.height - 48, 0, "Arrow Funk v" + Main.modVersion, 12);
		arrowFunky.scrollFactor.set();
		arrowFunky.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(arrowFunky);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 28, 0, "Forever Engine v" + Main.gameVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeItem();

		//
	}

	// var colorTest:Float = 0;
	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;

	override function update(elapsed:Float)
	{
		// colorTest += 0.125;
		// bg.color = FlxColor.fromHSB(colorTest, 100, 100, 0.5);

		var up = controls.UI_UP;
		var down = controls.UI_DOWN;
		var up_p = controls.UI_UP_P;
		var down_p = controls.UI_DOWN_P;
		var controlArray:Array<Bool> = [up, down, up_p, down_p];

		if ((controlArray.contains(true)) && (!selectedSomethin))
		{
			for (i in 0...controlArray.length)
			{
				// here we check which keys are pressed
				if (controlArray[i] == true)
				{
					// if single press
					if (i > 1)
					{
						// up is 2 and down is 3
						// paaaaaiiiiiiinnnnn
						if (i == 2)
							changeItem(-1);
						else if (i == 3)
							changeItem(1);

						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
				}
				//
			}
		}
		else
		{
			// reset variables
			counterControl = 0;
		}

		if ((controls.ACCEPT) && (!selectedSomethin))
		{
			//
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));

			//FlxFlicker.flicker(magenta, 0.8, 0.1, false);
			FlxG.camera.flash(FlxColor.WHITE, 1);
			
			// aqui
			FlxTween.tween(overlay, {x: -2000}, 2.2, {ease: FlxEase.expoInOut});
			FlxTween.tween(menushit, {y: 1500}, 1.2, {ease: FlxEase.expoIn});


			menuItems.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxTween.tween(spr, {x: 2000}, 2.2, {
						ease: FlxEase.expoInOut,
					});
				}
				else
				{
					FlxTween.tween(spr, {x: -2000}, 2.2, {
						ease: FlxEase.expoInOut,
					});

					FlxTween.tween(spr, {alpha: 0}, 3.2, {
						ease: FlxEase.expoInOut,
					});
					
					FlxFlicker.flicker(spr, 1, 1, false, false, function(flick:FlxFlicker)
					{
						var daChoice:String = optionShit[Math.floor(curSelected)];
						switch (daChoice)
						{
							case 'story_mode':
								Main.switchState(this, new StoryMenuState());
							case 'freeplay':
								Main.switchState(this, new FreeplayState());
							case 'options':
								transIn = FlxTransitionableState.defaultTransIn;
								transOut = FlxTransitionableState.defaultTransOut;
								Main.switchState(this, new OptionsMenuState());
							case 'credits':
								transIn = FlxTransitionableState.defaultTransIn;
								transOut = FlxTransitionableState.defaultTransOut;
								Main.switchState(this, new CreditsState());
						}
					});
				}
			});
		}

		if (Math.floor(curSelected) != lastCurSelected)
			updateSelection();

		super.update(elapsed);

		menuItems.forEach(function(menuItem:FlxSprite)
		{
			//menuItem.screenCenter(X);
		});
	}

	var lastCurSelected:Int = 0;

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;
	
			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}

		switch (curSelected)
		{
			case 0:
				menushit.animation.play('story');
			case 1:
				menushit.animation.play('free');
			case 2:
				menushit.animation.play('opt');
			case 3:
				menushit.animation.play('cred');
		}
	}

	private function updateSelection()
	{
		// reset all selections
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
			lastCurSelected = Math.floor(curSelected);
		});
	}
}
