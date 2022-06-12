package meta.subState;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatSubState;
import meta.data.*;
import meta.data.Highscore;
import meta.data.Song;
import meta.data.font.Alphabet;
import meta.state.*;
import meta.state.menus.*;

class PauseSubState extends MusicBeatSubState
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;
	var pauseMusic:FlxSound;

	var pauseOG:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Exit to Options', 'Exit to menu'];
	var difficultyChoices:Array<String> = ['EASY', 'NORMAL', 'HARD', 'BACK'];

	var menuItems:Array<String> = [];

	var overlay:FlxSprite;
	var chess:FlxBackdrop;

	public static var toOptions:Bool = false;

	public function new(x:Float, y:Float)
	{
		super();

		toOptions = false;

		menuItems = pauseOG;

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('Hot_Lunch'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		// chess
		chess = new FlxBackdrop(Paths.image('menus/arrow/otherassets/mebg'), 0, 0, true, false);
		chess.y -= 80;
		add(chess);

		chess.offset.x -= 0;
		chess.offset.y += 0;
		chess.velocity.x = 20;
		chess.alpha = 0;

		overlay = new FlxSprite().loadGraphic(Paths.image('menus/arrow/otherassets/fpov'));
		overlay.antialiasing = true;
		add(overlay);

		overlay.alpha = 0;

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += CoolUtil.dashToSpace(PlayState.SONG.song);
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font('vcr.ttf'), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyFromNumber(PlayState.storyDifficulty);
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var levelDeaths:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		levelDeaths.text += "Epic Fails: " + PlayState.deathCounter;
		levelDeaths.scrollFactor.set();
		levelDeaths.setFormat(Paths.font('vcr.ttf'), 32);
		levelDeaths.updateHitbox();
		add(levelDeaths);

		levelInfo.alpha = 0;
		levelDifficulty.alpha = 0;
		levelDeaths.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		levelDeaths.x = FlxG.width - (levelDeaths.width + 20);

		FlxTween.tween(chess, {alpha: 1}, 2.4, {ease: FlxEase.quartOut});
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(overlay, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});

		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(levelDeaths, {alpha: 1, y: levelDeaths.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		regenMenu();
		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	private function regenMenu()
	{
		while (grpMenuShit.members.length > 0)
		{
			grpMenuShit.remove(grpMenuShit.members[0], true);
		}

		for (i in 0...menuItems.length)
		{
			var menuItem:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			menuItem.isMenuItem = true;
			menuItem.itemType = "Centered";
			menuItem.targetY = i;
			grpMenuShit.add(menuItem);
		}

		curSelected = 0;

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];
			if (menuItems == difficultyChoices)
			{
				if(menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {
					var name:String = PlayState.SONG.song;
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					Main.switchState(this, new PlayState());
					PlayState.resetMusic();
					PlayState.deathCounter = 0;
					return;
				}
				menuItems = pauseOG;
				regenMenu();
			}

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					PlayState.preventScoring = false;
					Main.switchState(this, new PlayState());
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					regenMenu();
				case "Exit to Options":
					toOptions = true;
					Main.switchState(this, new OptionsMenuState());
				case "Exit to menu":
					PlayState.resetMusic();
					PlayState.deathCounter = 0;

					if (PlayState.isStoryMode)
						Main.switchState(this, new StoryMenuState());
					else
						Main.switchState(this, new FreeplayState());

				//

				// Change Difficulty
				case "EASY" | "NORMAL" | "HARD":
					PlayState.SONG = Song.loadFromJson(Highscore.formatSong(PlayState.SONG.song.toLowerCase(), curSelected), PlayState.SONG.song.toLowerCase());
					PlayState.storyDifficulty = curSelected;
					PlayState.preventScoring = false;
					FlxG.resetState();
				case "BACK":
					menuItems = pauseOG;
					regenMenu();

				//
			}
		}

		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		//
	}
}