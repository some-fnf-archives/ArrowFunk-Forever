package meta.state.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gameObjects.userInterface.menu.*;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.dependency.Discord;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	private static var lastDifficultyName:String = '';
	var scoreText:FlxText;
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, true, true, true];

	var weekCharacters:Array<Dynamic> = [
		['', 'kevin', 'bidu'],
		['sagu', 'barbara', 'bidu'],
		['kids', 'barbara', 'bidu'],
		['dono', 'barbara', 'bidu']
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;
	var bgSprite:FlxSprite;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{
		super.create();

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		#if !html5
		Discord.changePresence('STORY MENU', 'Main Menu');
		#end

		// freeaaaky
		ForeverTools.resetMenuMusic();

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("Vividly Regular", 52);
		scoreText.color = 0xFFDD29B8;

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("Vividly Regular", 52, FlxColor.BLACK, RIGHT);
		//txtWeekTitle.alpha = 0.7;
		txtWeekTitle.color = 0xFFDD29B8;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("Vividly-Regular.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('menus/arrow/storymenu/campaign_menu_UI_assets');
		//var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);
		var yellowBG:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/arrow/backgrounds/butte'));
		bgSprite = new FlxSprite(0, 56);
		bgSprite.loadGraphic(Paths.image('menus/arrow/backgrounds/nashiraArrowFunk'));
		bgSprite.antialiasing = true;

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		for (i in 0...Main.gameWeeks.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		trace("Line 96");

		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, weekCharacters[curWeek][char]);
			weekCharacterThing.antialiasing = true;

			switch (weekCharacterThing.character)
			{
				case 'bidu':	//bidu do story, eu te odeio
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.53));
					weekCharacterThing.updateHitbox();
					weekCharacterThing.y += 144;
					weekCharacterThing.x += 40;
			}

			grpWeekCharacters.add(weekCharacterThing);
		}
		add(yellowBG);
		add(bgSprite);
		add(grpWeekCharacters);

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 395);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.antialiasing = true;
		difficultySelectors.add(leftArrow);

		CoolUtil.difficulties = CoolUtil.difficultyArray.copy();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.difficultyArray.indexOf(lastDifficultyName)));

		sprDifficulty = new FlxSprite(0, leftArrow.y);
		sprDifficulty.antialiasing = true;

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(leftArrow.x + 376, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.antialiasing = true;
		difficultySelectors.add(rightArrow);

		trace("Arrow (Funk) pushed");


		var tracksSprite:FlxSprite = new FlxSprite(FlxG.width * 0.07, bgSprite.y + 425).loadGraphic(Paths.image('menus/arrow/tracks'));
		tracksSprite.antialiasing = true;
		add(tracksSprite);

		txtTracklist = new FlxText(FlxG.width * 1, tracksSprite.y - 40, 0, "", 46);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = FlxColor.WHITE;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		// very unprofessional yoshubs!

		changeWeek();
		changeDifficulty();
		updateText();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		var lerpVal = Main.framerateAdjust(0.5);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, lerpVal));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = Main.gameWeeks[curWeek][3].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UI_UP_P)
					changeWeek(-1);
				else if (controls.UI_DOWN_P)
					changeWeek(1);

				if (controls.UI_RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.UI_LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.UI_RIGHT_P)
					changeDifficulty(1);
				if (controls.UI_LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
				selectWeek();
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			Main.switchState(this, new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxTween.tween(FlxG.camera, {y:3000}, 1.8, {ease: FlxEase.expoIn});
				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'));

				//grpWeekText.members[curWeek].startFlashing();
				grpWeekCharacters.members[2].createCharacter('biduConfirm');
				grpWeekCharacters.members[2].x -= 100;
				grpWeekCharacters.members[2].y -= 50;
				stopspamming = true;
			}

			PlayState.storyPlaylist = Main.gameWeeks[curWeek][0].copy();
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic:String = '-' + CoolUtil.difficultyFromNumber(curDifficulty).toLowerCase();
			diffic = diffic.replace('-normal', '');

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				Main.switchState(this, new PlayState());
			});
		}
	}

	var tweenDifficulty:FlxTween;
	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficultyLength - 1;
		if (curDifficulty > CoolUtil.difficultyLength - 1)
			curDifficulty = 0;

		var diff:String = CoolUtil.difficulties[curDifficulty];
		var newImage:FlxGraphic = Paths.image('menus/arrow/storymenu/difficulties/' + Paths.formatToSongPath(diff));
			
		if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.x = leftArrow.x + 60;
			sprDifficulty.x += (308 - sprDifficulty.width) / 2;
			sprDifficulty.setGraphicSize(Std.int(sprDifficulty.width * 0.9));
			sprDifficulty.alpha = 0;
			sprDifficulty.y = leftArrow.y - 90;

			if(tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {y: leftArrow.y - 20, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenDifficulty = null;
			}});
		}
		lastDifficultyName = diff;

		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= Main.gameWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = Main.gameWeeks.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			item.scale.set(1, 1);
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.scale.set(0.8, 0.8);
				item.alpha = 1;
				bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].createCharacter(weekCharacters[curWeek][0], true);
		grpWeekCharacters.members[1].createCharacter(weekCharacters[curWeek][1], true);
		//grpWeekCharacters.members[2].createCharacter(weekCharacters[curWeek][2]);
		txtTracklist.text = "\n\n";

		var stringThing:Array<String> = Main.gameWeeks[curWeek][0];
		for (i in stringThing)
			txtTracklist.text += "\n" + CoolUtil.dashToSpace(i);

		txtTracklist.text += "\n"; // pain
		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
	}
}
