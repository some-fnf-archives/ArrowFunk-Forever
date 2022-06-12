package meta.state.menus;

// modified code from psych engine, credits to shadow mario lol!

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.AttachedSprite;
import flixel.addons.display.FlxBackdrop;
import meta.data.dependency.Discord;
import meta.data.font.Alphabet;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Dynamic> = [];

	var clickfreddy:Int = 0;
	var bg:FlxSprite;
	var bg2:FlxSprite;
	var chess:FlxBackdrop;
	var overlay:FlxSprite;
	var descText:FlxText;
    var descBox:AttachedSprite;

    var intendedColor:Int;
	var colorTween:FlxTween;

    var offsetThing:Float = -75;

	override function create()
	{
		super.create();

		Main.doNumberOffset = true;

        #if !html5
		Discord.changePresence('MENU SCREEN', 'Credits Menu');
		#end
		
		bg = new FlxSprite().loadGraphic(Paths.image('menus/arrow/menuDesat2'));
		add(bg);

		bg2 = new FlxSprite().loadGraphic(Paths.image('menus/arrow/credshit'));
		add(bg2);
		bg2.alpha = 0.5;

		chess = new FlxBackdrop(Paths.image('menus/arrow/otherassets/fpbg'), 0, 0, true, false);
		chess.y -= 80;
		add(chess);
		
		chess.offset.x -= 0;
		chess.offset.y += 0;
		chess.velocity.x = 20;

		overlay = new FlxSprite().loadGraphic(Paths.image('menus/arrow/otherassets/credov'));
		add(overlay);
		overlay.alpha = 1;

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		var pisspoop = [ //Name - Icon name - Description - Link
			['Arrow Fnuk Froever uwu'],
			['BeastlyGhost', 'ghost', 'Project Owner, overhaul a pretty cringe dev', 'https://twitter.com/Fan_de_RPG', '00ffbf'],
			['Gazozoz', 'gazozoz', 'the guy who gave me the urge to continue the port lol, overhaul a pretty cool and based dev', 'https://twitter.com/Gazozoz_', '640a0a'],
			[''],
			['Arrow Fnuk uwu'],
			['Yoisabo', 'yoisabo', 'Director, Artist, Character Designer, Background artist, Animator, Sprite animator, Programmer, Charter, Composer, im dead help \n*zombie noises*', 'https://twitter.com/abo_bora', 'C6297F'],
			['Roxo Depressivo', 'murasaki', 'Artist and Character Designer', 'https://twitter.com/Roxo_Depressivo', '441C8C'],
			['Im Not Sonic', 'sonic', 'Sprite artist', 'https://twitter.com/Imnotsonic1', '4E58C4'],
			['Hiro Mizuki', 'hiro', 'Programmer\ncomprei arroz hoje', 'https://twitter.com/umgaynanet1', '21ff7e'],
			['BeastlyChip', 'chip', 'Composer\nyou should definitely pause the game', 'https://twitter.com/BeastlyChip', '03BAFE'],
			['Tio Sans', 'tiosans', 'Composer\nhe makes cool music', 'https://twitter.com/NewTioSans', '14a3c7'],
			['Tyefling', 'tyefling', 'Voice actor\nhe also makes cool music', 'https://twitter.com/tyefling', '3A2538'],
			[''],
			['Credsit owo'],
			['Original Idea', 'jeferso', '"MINHA IRMÃ DANDO O NOME PARA OS PERSONAGENS DE FRIDAY NIGHT FUNKIN!"', 'https://youtu.be/9MdqEWp0YC8', 'EA3CDF'],
			['Roaded64', 'roaded', 'Helped with the psych port or something', 'https://twitter.com/64_Roaded', '21ff7e'],
			['Gabiss', 'gabiss', 'creator of Kleitin', 'https://twitter.com/G_GABlS', '83E800'],
			['Shaggy mod', 'shaggy', 'Earthquake is inspired by Shaggy mod by SrPerez\n go play shaggy mod\ntrain go train oh', 'https://gamejolt.com/games/fnf-shaggy/643999', '2D478E'],
			[''],
			['Special Thansk pwp'],
			['Aizakku',				'aizakku',			'emotional support <3', 'https://twitter.com/ItsAizakku', 'EA861C'],
			['Arwen Team',			'arwen',			'freinds <3', 'https://twitter.com/ArwenTeam', 'FF2400'],
			['Lightwuz, Yuumiwuz, Vsilva', 'acho', 'freinds (2) <3\n\nAcho que é o Lightwuz...', 'https://youtu.be/-_27xIq1pIs','8993FF'],
			['Shadow Mario', 'shadowmario', 'Helped me a lot to understand how the psych engine works\n(thank you shadow luigi)', 'https://twitter.com/Shadow_Mario_', '444444'],
			[''],
			["Special Thanks"],
			['Shadow Mario (again)', 'shadowmario', 'Psych Engine Lead Programmer, Credits Code', 'https://twitter.com/Shadow_Mario_', '444444'],
			['RiverOaken', 'riveroaken', 'Psych Engine Artist/Animator', 'https://twitter.com/RiverOaken','C30085'],
			['Shubs', 'shubs', 'Psych Engine Programmer', 'https://twitter.com/yoshubs', '279ADC'],
			[''],
			["Forever Engine Team"],
			['Shubs', 'shubs', 'Lead Programmer.', 'https://twitter.com/yoshubs', '279ADC'],
			['Pixloen', '', 'Forever\'s Custom Assets.', 'https://github.com/PixlJacket', '935ae0'],
			['Gedehari', '', 'Programmer.', 'https://github.com/gedehari', 'fedb7f'],
			['ImCodist', '', 'Issue Fixes.', 'https://github.com/ImCodist', 'ad2333'],
			['Scarlett', '', 'Programmer, Wrote the Math Formula for Note Quants.', 'https://github.com/SomeKitten', 'ed1c24'],
			['Oneilr', '', 'Forever\'s Custom Assets.', 'https://oneilr.newgrounds.com/', 'f8922a'],
			['HelloSammu', '', 'Engine Misc Fixes, Scaleable Text for Dialogue.', 'https://github.com/hellosammu', '93d6d1'],
			[''],
			['freddy fazbear'],
			['freddy fazbear', 'fredy', "freddy fazbear", 'https://youtu.be/w0h4YNI_aHI?t=65', '63272E']
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.itemType = 'Credits';
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable && (creditsStuff[i][1] != '')) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

        descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		descBox.sprTracker = descText;
		add(descText);

        bg.color = getCurrentBGColor();
		intendedColor = bg.color;

		changeSelection();
	}

    var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-1 * shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(1 * shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}
        }

		if (controls.BACK)
		{
            if(colorTween != null) {
                colorTween.cancel();
            }
			FlxG.sound.play(Paths.sound('cancelMenu'));
			Main.switchState(this, new MainMenuState());
            quitting = true;
		}
		if(controls.ACCEPT)
		{
			if (curSelected == 40)
			{
				clickfreddy += 1;
				if (clickfreddy == 87)
					CoolUtil.browserLoad(creditsStuff[curSelected][3]);
				else
					FlxG.sound.play(Paths.sound('fedy'));

				if (clickfreddy >= 87) clickfreddy = 0;
			}
			if (curSelected != 40) CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}

        for (item in grpOptions.members)
		{
			if(!item.isBold)
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
					item.forceX = item.x;
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
					item.forceX = item.x;
				}
			}
		}
	}

    var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

        var newColor:Int = getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 0.35, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

    function getCurrentBGColor() {
		var bgColor:String = creditsStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}