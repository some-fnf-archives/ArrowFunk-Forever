package meta.subState;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import gameObjects.Boyfriend;
import meta.MusicBeat.MusicBeatSubState;
import meta.data.Conductor.BPMChangeEvent;
import meta.data.Conductor;
import meta.data.Song;
import meta.state.*;
import meta.state.menus.*;

class GameOverSubstate extends MusicBeatSubState
{
	//
	var bf:Boyfriend;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var updateCamera:Bool = false;
	var stageSuffix:String = "";
	var bgluz:FlxSprite;

	public function new(x:Float, y:Float)
	{
		var daBoyfriendType = PlayState.boyfriend.curCharacter;
		var daBf:String = '';
		switch (daBoyfriendType)
		{
			case 'bf-og':
				daBf = daBoyfriendType;
			case 'bf-pixel':
				daBf = 'bf-pixel-dead';
				stageSuffix = '-pixel';
			case 'bidu':
				daBf = 'bidu';
			case 'bidu-spooky' | 'bidu-gold' | 'bidu-gold-night':
				daBf = 'bidu-gold';
			case 'bidu-virus':
				daBf = 'bidu-virus';
			default:
				daBf = 'bf-dead';
		}

		FlxTween.tween(FlxG.camera, {zoom: 0.50}, 0.6, {ease: FlxEase.expoOut});

		FlxG.camera.flash(FlxColor.WHITE, 0.6);

		super();

		Conductor.songPosition = 0;

		var bg:FlxSprite = new FlxSprite(-200, -150).loadGraphic(Paths.image('backgrounds/graveyard/layer-0'));
		bg.screenCenter(XY);
		bg.antialiasing = true;
		bg.alpha = 0;
		add(bg);
		FlxTween.tween(bg, {alpha: 1}, 4.8, {ease: FlxEase.expoInOut});

		bgluz = new FlxSprite(-200, -150).loadGraphic(Paths.image('backgrounds/graveyard/layer0'));
		bgluz.screenCenter(XY);
		bgluz.antialiasing = true;
		bgluz.alpha = 0;
		add(bgluz);

		bf = new Boyfriend();
		bf.setCharacter(x, y + PlayState.boyfriend.height, daBf);
		bf.screenCenter(XY);
		bf.y += 30;
		add(bf);

		PlayState.boyfriend.destroy();

		camFollow = new FlxObject(bf.getGraphicMidpoint().x + 20, bf.getGraphicMidpoint().y - 40, 1, 1);
		add(camFollow);

		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');

		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
		add(camFollowPos);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(updateCamera) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 0.6, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		}

		if (controls.ACCEPT)
			endBullshit();

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;

			if (PlayState.isStoryMode)
			{
				Main.switchState(this, new StoryMenuState());
			}
			else
				Main.switchState(this, new FreeplayState());
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{	
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
			updateCamera = true;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));

		// if (FlxG.sound.music.playing)
		//		Conductor.songPosition = FlxG.sound.music.time;
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxTween.tween(bgluz, {alpha: 1}, 1, {ease: FlxEase.expoOut});
			FlxTween.tween(FlxG.camera, {zoom: 2.5}, 4, {ease: FlxEase.expoIn});
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					Main.switchState(this, new PlayState());
				});
			});
			//
		}
	}
}
