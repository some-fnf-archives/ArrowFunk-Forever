package meta.state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import meta.MusicBeat.MusicBeatState;

// Code from Psych Engine

class NoticeState extends MusicBeatState
{
	var bg:FlxSprite;
	var warnText:FlxText;
	
	override function create()
	{
		super.create();

		// set the volume to 100%, since flixel is weird and always boots up on 0%
		FlxG.sound.volume = 1;

		bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/arrow/flashing/flashbg0'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.alpha = 0.4;
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		warnText = new FlxText(-10, 0, FlxG.width,
			"
			Friendly reminder!\n
			This Mod contains flashing lights and colorful colors\n
			press ENTER to go to the Title Screen!",
			32);
		warnText.setFormat(Paths.font('Vividly-Regular.ttf'), 52, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		warnText.x = 20;
		add(warnText);
	}

	// copied from Init
	private function gotoTitleScreen()
	{
		FlxTransitionableState.skipNextTransIn = false;
		FlxTransitionableState.skipNextTransOut = false;

		if (Init.trueSettings.get("Custom Titlescreen"))
			Main.switchState(this, new CustomTitlescreen());
		else
			Main.switchState(this, new TitleState());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(!Init.trueSettings.get('Left State')) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				Init.trueSettings.set('Left State', true);
				if(!back) {
					FlxG.sound.play(Paths.sound('confirmMenu'));
					for (objects in [warnText, bg])
					{
						FlxFlicker.flicker(objects, 0.5, 0.06 * 2, false, true, function(flk:FlxFlicker) {
							new FlxTimer().start(0.5, function (tmr:FlxTimer) {
								gotoTitleScreen();
							});
						});
					}
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					for (objects in [warnText, bg])
					{
						FlxTween.tween(objects, {alpha: 0}, 1, {
							onComplete: function (twn:FlxTween) {
								gotoTitleScreen();
							}
						});
					}
				}
			}
		}
	}
}
