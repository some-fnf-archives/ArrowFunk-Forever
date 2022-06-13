package gameObjects.userInterface;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import meta.CoolUtil;
import meta.InfoHud;
import meta.data.Conductor;
import meta.data.Timings;
import meta.state.PlayState;

using StringTools;

class ClassHUD extends FlxTypedGroup<FlxBasic>
{
	// set up variables and stuff here
	var infoBar:FlxText; // small side bar like kade engine that tells you engine info
	var scoreBar:FlxText;
	var scoreBarTween:FlxTween;

	public var songInfo:FlxSprite;

	var scoreLast:Float = -1;
	var scoreDisplay:String;

	private var healthBarBG:FlxSprite;
	private var healthBarOV:FlxSprite;
	private var healthBar:FlxBar;

	//time shit
	public var timeTxt:FlxText;

	//troços pra atualizar o tempo
	public var updateTime:Bool = Init.trueSettings.get('Display Timer') ? true : false;
	var songPercent:Float = 0;

	private var SONG = PlayState.SONG;
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	private var stupidHealth:Float = 0;

	private var timingsMap:Map<String, FlxText> = [];

	// Smooth healthbar
	var fakeHealth:Float = 1;
	
	// eep
	public function new()
	{
		// call the initializations and stuffs
		super();

		var scoreDisplay:String = 'beep bop bo skdkdkdbebedeoop brrapadop';

		if (Init.trueSettings.get('Display Timer'))
		{
			timeTxt = new FlxText(42 + (FlxG.width / 2) - 248, 19, 400, "", 32);
			timeTxt.setFormat(Paths.font("Vividly-Regular.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			timeTxt.scrollFactor.set();
			timeTxt.alpha = 0;
			timeTxt.borderSize = 2;
			if (Init.trueSettings.get('Downscroll')) timeTxt.y = FlxG.height - 44;
		}

		// le healthbar setup
		var barY = FlxG.height * 0.875;
		if (Init.trueSettings.get('Downscroll'))
			barY = 64;

		healthBarBG = new FlxSprite(0, barY).loadGraphic(Paths.image(ForeverTools.returnSkinAsset('healthBar', PlayState.assetModifier, PlayState.changeableSkin, 'UI')));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, (RIGHT_TO_LEFT), Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
		'fakeHealth', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.numDivisions = healthBar.barWidth;
		// healthBar

		reloadHealthBarColors();

		healthBarOV = new FlxSprite(0,
			barY).loadGraphic(Paths.image(ForeverTools.returnSkinAsset('healthBarOV', PlayState.assetModifier, PlayState.changeableSkin, 'UI')));
		healthBarOV.screenCenter(X);
		healthBarOV.scrollFactor.set();

		songInfo = new FlxSprite(Paths.image(ForeverTools.returnSkinAsset('songInfo/song-' + PlayState.SONG.song, PlayState.assetModifier, PlayState.changeableSkin, 'UI')));
		songInfo.scrollFactor.set();
		songInfo.antialiasing = true;
		songInfo.x -= 500;

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);

		scoreBar = new FlxText(FlxG.width / 2, healthBarBG.y + 40, 0, scoreDisplay, 20);
		scoreBar.setFormat(Paths.font("Vividly-Regular.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		updateScoreText();
		scoreBar.scrollFactor.set();
		scoreBar.borderSize = 1.25;

		// small info bar, kinda like the KE watermark
		// based on scoretxt which I will set up as well
		var infoDisplay:String = CoolUtil.dashToSpace(PlayState.SONG.song) + ' - ' + CoolUtil.difficultyFromNumber(PlayState.storyDifficulty);
		var engineDisplay:String = "Forever Engine v" + Main.gameVersion;
		var engineBar:FlxText = new FlxText(0, FlxG.height - 30, 0, engineDisplay, 32);
		engineBar.setFormat(Paths.font("Vividly-Regular.ttf"), 26, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		engineBar.updateHitbox();
		engineBar.x = FlxG.width - engineBar.width - 5;
		engineBar.scrollFactor.set();
		engineBar.borderSize = 1.25;

		infoBar = new FlxText(5, FlxG.height - 30, 0, infoDisplay, 20);
		infoBar.setFormat(Paths.font("Vividly-Regular.ttf"), 26, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoBar.scrollFactor.set();
		infoBar.borderSize = 1.25;

		// adiciona todos os objects
		if (Init.trueSettings.get('Display Timer'))
			add(timeTxt);
		add(healthBarBG);
		add(healthBar);
		add(healthBarOV);
		add(songInfo);
		add(iconP1);
		add(iconP2);
		add(scoreBar);
		add(engineBar);
		add(infoBar);

		// counter
		if (Init.trueSettings.get('Counter') != 'None') {
			var judgementNameArray:Array<String> = [];
			for (i in Timings.judgementsMap.keys())
				judgementNameArray.insert(Timings.judgementsMap.get(i)[0], i);
			judgementNameArray.sort(sortByShit);
			for (i in 0...judgementNameArray.length) {
				var textAsset:FlxText = new FlxText(5 + (!left ? (FlxG.width - 10) : 0),
					(FlxG.height / 2)
					- (counterTextSize * (judgementNameArray.length / 2))
					+ (i * counterTextSize), 0,
					'', counterTextSize);
				if (!left)
					textAsset.x -= textAsset.text.length * counterTextSize;
				textAsset.setFormat(Paths.font("Vividly-Regular.ttf"), counterTextSize, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				textAsset.scrollFactor.set();
				textAsset.borderSize = 1.25;
				timingsMap.set(judgementNameArray[i], textAsset);
				add(textAsset);
			}
		}
		updateScoreText();
	}

	var counterTextSize:Int = 28;

	function sortByShit(Obj1:String, Obj2:String):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Timings.judgementsMap.get(Obj1)[0], Timings.judgementsMap.get(Obj2)[0]);

	var left = (Init.trueSettings.get('Counter') == 'Left');

	public function reloadHealthBarColors() 
	{
		healthBar.createFilledBar(PlayState.dadOpponent.barColor, PlayState.boyfriend.barColor);
		healthBar.updateBar();
	}

	override public function update(elapsed:Float)
	{
		// pain, this is like the 7th attempt
		fakeHealth = FlxMath.lerp(fakeHealth, PlayState.health, CoolUtil.boundTo(elapsed * 20, 0, 1));
		healthBar.percent = (PlayState.health * 50);

		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP1.scale.set(mult, mult);
		iconP1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP2.scale.set(mult, mult);
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		var percent:Float = 1 - (fakeHealth / 2);
		iconP1.x = healthBar.x + (healthBar.width * percent) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
		iconP2.x = healthBar.x + (healthBar.width * percent) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;

		if (healthBar.percent < 20) {
            iconP2.animation.curAnim.curFrame = 2;
            iconP1.animation.curAnim.curFrame = 1;
        } else if (healthBar.percent > 80) {
            iconP2.animation.curAnim.curFrame = 1;
            iconP1.animation.curAnim.curFrame = 2;
        } else {
            iconP2.animation.curAnim.curFrame = 0;
            iconP1.animation.curAnim.curFrame = 0;
        }

		if (Init.trueSettings.get('Display Timer'))
		{
			if(updateTime)
			{
				var curTime:Float = Conductor.songPosition;
				if(curTime < 0) curTime = 0;
				songPercent = (curTime / PlayState.songLength);
		
				var songCalc:Float = (PlayState.songLength - curTime);
		
				var secondsTotal:Int = Math.floor(songCalc / 1000);
				if(secondsTotal < 0) secondsTotal = 0;
			
				timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false) + ' / ' + FlxStringUtil.formatTime(Math.floor((PlayState.songLength) / 1000), false);
			}
		}
	}

	private final divider:String = ' - ';

	public function updateScoreText()
	{
		var importSongScore = PlayState.songScore;
		var importPlayStateCombo = PlayState.combo;
		var importMisses = PlayState.misses;

		scoreBar.text = "Score: " + '$importSongScore';
		// testing purposes

		var displayAccuracy:Bool = Init.trueSettings.get('Display Accuracy');
		if (displayAccuracy)
		{
			scoreBar.text += divider + "Combo Breaks: " + Std.string(PlayState.misses);
			scoreBar.text += divider + "Rating: " + Std.string(Timings.returnScoreRating()/*.toUpperCase()*/)
			+ ' (' + Std.string(Math.floor(Timings.getAccuracy() * 100) / 100) + '%)';
			
			if (Timings.comboDisplay != '') 
				scoreBar.text += divider + Timings.comboDisplay;
		}

		scoreBar.x = ((FlxG.width / 2) - (scoreBar.width / 2));

		// update counter
		if (Init.trueSettings.get('Counter') != 'None')
		{
			for (i in timingsMap.keys()) {
				timingsMap[i].text = '${(i.charAt(0).toUpperCase() + i.substring(1, i.length))}: ${Timings.gottenJudgements.get(i)}';
				timingsMap[i].x = (5 + (!left ? (FlxG.width - 10) : 0) - (!left ? (6 * counterTextSize) : 0));
			}
		}

		// update playstate
		PlayState.detailsSub = scoreBar.text;
		PlayState.updateRPC(false);
	}

	public function scoreBarBounce()
	{
		if (scoreBarTween != null)
			scoreBarTween.cancel();
		scoreBar.scale.x = 1.15;
		scoreBarTween = FlxTween.tween(scoreBar.scale, {x: 1}, 0.4, {
			ease: FlxEase.cubeOut,
			onComplete: function(twn:FlxTween)
			{
				scoreBarTween = null;
			}
		});
	}

	public function beatHit()
	{
		if (!Init.trueSettings.get('Reduced Movements'))
		{
			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}
		//
	}
}
