package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;

	//stage light
	public var fundo1:FNFSprite;
	public var chao1:FNFSprite;
	public var base1:FNFSprite;
	public var luzes1:FNFSprite;
	public var curti1:FNFSprite;
	public var balight:FNFSprite;

	//stage dark
	public var fundo2:FNFSprite;
	public var chao2:FNFSprite;
	public var base2:FNFSprite;
	public var luzes2:FNFSprite;
	public var curti2:FNFSprite;

	//week 2
	public var barbaravirus:FNFSprite;
	var spookers:FNFSprite;
	public var dancef:FNFSprite;
	public var dancefvel:Int = 2;
	public var spookersvel:Int = 2;

	//week 3
	public var favelalight:FNFSprite;
	public var favelight:FNFSprite;
	public var kleitin:FNFSprite;
	public var daniel:FNFSprite;
	public var pessoas:FNFSprite;
	public var busao:FNFSprite;
	public var danielzinho:FNFSprite;
	public var carrofoda:FNFSprite;
	public var kleistate:Int = 3;

	// shaggster
	public var treefront:FNFSprite;
	public var florestalight:FNFSprite;

	var bgGirls:BackgroundGirls;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	public var opponentLoader:FNFSprite;
	public var playerLoader:FNFSprite;
	public var gfLoader:FNFSprite;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		// troço pra carregar personagem, valeu Shadow Mario pela ajudinha com isso
		opponentLoader = new FNFSprite(0, 0);
		opponentLoader.antialiasing = true;
		opponentLoader.alpha = 0.00001;

		playerLoader = new FNFSprite(0, 0);
		playerLoader.antialiasing = true;
		playerLoader.alpha = 0.00001;

		gfLoader = new FNFSprite(0, 0);
		gfLoader.antialiasing = true;
		gfLoader.alpha = 0.00001;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				case 'tutorial' | 'reboop' | 'fresher' | 'rap-king' | '-debug':
					curStage = 'balada';
				case 'bittersweet' | 'nightfall':
					curStage = 'baladamedo';
				case 'virus':
					curStage = 'baladamedovirus';
				case 'shacklesz':
					curStage = 'faveladia';
				case 'blam':
					curStage = 'favela';
				case 'loaded':
					curStage = 'favelanoite';
				case 'earthquake':
					curStage = 'floresta';
				default:
					curStage = 'stage';
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		//
		switch (curStage)
		{
			case 'balada': //Week 1
				curStage = 'balada';
				PlayState.defaultCamZoom = 0.57;

				if (PlayState.SONG.song.toLowerCase() == 'rap-king')
				{
					//FAÇA uh... Escuro??
					fundo2 = new FNFSprite(-0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer1D'));
					fundo2.scrollFactor.set(0.94, 0.9);
					fundo2.setGraphicSize(Std.int(fundo2.width * 2));
					fundo2.updateHitbox();
					fundo2.screenCenter(XY);
					fundo2.antialiasing = true;
					add(fundo2);

					chao2 = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer2D'));
					chao2.scrollFactor.set(0.9, 0.9);
					chao2.setGraphicSize(Std.int(chao2.width * 2));
					chao2.updateHitbox();
					chao2.screenCenter(XY);
					chao2.updateHitbox();
					chao2.antialiasing = true;
					add(chao2);

					base2 = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer3D'));
					base2.scrollFactor.set(0.88, 0.9);
					base2.setGraphicSize(Std.int(base2.width * 2));
					base2.updateHitbox();
					base2.screenCenter(XY);
					base2.antialiasing = true;
					add(base2);

					luzes2 = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer4D'));
					luzes2.scrollFactor.set(0.86, 0.86);
					luzes2.setGraphicSize(Std.int(luzes2.width * 2));
					luzes2.updateHitbox();
					luzes2.screenCenter(XY);
					luzes2.antialiasing = true;
					add(luzes2);

					curti2 = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer5D'));
					curti2.scrollFactor.set(0.82, 0.9);
					curti2.setGraphicSize(Std.int(curti2.width * 2));
					curti2.updateHitbox();
					curti2.screenCenter(XY);
					curti2.antialiasing = true;
					add(curti2);
				}

				balight = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/light'));
				balight.scrollFactor.set(0.80, 0.9);
				balight.setGraphicSize(Std.int(balight.width * 2));
				balight.updateHitbox();
				balight.screenCenter(XY);
				balight.antialiasing = true;
				add(balight);

				//FAÇA LUZ
				fundo1 = new FNFSprite(-0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer1'));
				fundo1.scrollFactor.set(0.94, 0.9);
				fundo1.setGraphicSize(Std.int(fundo1.width * 2));
				fundo1.updateHitbox();
				fundo1.screenCenter(XY);
				fundo1.antialiasing = true;
				add(fundo1);

				chao1 = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer2'));
				chao1.scrollFactor.set(0.9, 0.9);
				chao1.setGraphicSize(Std.int(chao1.width * 2));
				chao1.updateHitbox();
				chao1.screenCenter(XY);
				chao1.updateHitbox();
				chao1.antialiasing = true;
				add(chao1);

				base1 = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer3'));
				base1.scrollFactor.set(0.88, 0.9);
				base1.setGraphicSize(Std.int(base1.width * 2));
				base1.updateHitbox();
				base1.screenCenter(XY);
				base1.antialiasing = true;
				add(base1);

				luzes1 = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer4'));
				luzes1.scrollFactor.set(0.86, 0.86);
				luzes1.setGraphicSize(Std.int(luzes1.width * 2));
				luzes1.updateHitbox();
				luzes1.screenCenter(XY);
				luzes1.antialiasing = true;
				add(luzes1);

				curti1 = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer5'));
				curti1.scrollFactor.set(0.82, 0.9);
				curti1.setGraphicSize(Std.int(curti1.width * 2));
				curti1.updateHitbox();
				curti1.screenCenter(XY);
				curti1.antialiasing = true;
				add(curti1);

				base1 = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer5'));
				base1.scrollFactor.set(0.82, 0.9);
				base1.setGraphicSize(Std.int(base1.width * 2));
				base1.updateHitbox();
				base1.screenCenter(XY);
				base1.antialiasing = true;
				add(base1);

				if (PlayState.SONG.song.toLowerCase() == 'rap-king')
				{
					opponentLoader.frames = Paths.getSparrowAtlas('characters/SAGU_FIRE_DARK');
					opponentLoader.animation.addByPrefix('idle', 'Sagu idle dance', 24, false);
					opponentLoader.animation.play('idle');
					add(opponentLoader);

					playerLoader.frames = Paths.getSparrowAtlas('characters/BIDU_DARK');
					playerLoader.animation.addByPrefix('idle', 'BIDU idle dance', 24, false);
					playerLoader.animation.play('idle');
					add(playerLoader);
					
					gfLoader.frames = Paths.getSparrowAtlas('characters/BARBARA_DARK');
					gfLoader.animation.addByIndices('danceRight', 'BARBARA Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
					gfLoader.animation.play('danceRight');
					add(gfLoader);
				}

			case 'baladamedo':
				curStage = 'baladamedo';
				PlayState.defaultCamZoom = 0.56;

				var bg:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer0'));
				bg.scrollFactor.set(0.9, 0.9);
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();
				bg.screenCenter(XY);
				bg.antialiasing = true;
				add(bg);

				var front:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer1'));
				front.scrollFactor.set(0.9, 0.9);
				front.setGraphicSize(Std.int(front.width * 2));
				front.updateHitbox();
				front.screenCenter(XY);
				front.antialiasing = true;
				add(front);

				spookers = new FNFSprite(0, 0);
				spookers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/spookers');
				spookers.animation.addByPrefix('bump', 'SPEAKERS', 24, false);
				spookers.scrollFactor.set(0.9, 0.9);
				spookers.screenCenter(XY);
				spookers.antialiasing = true;
				spookers.y += 125;
				spookers.x += 6;
				add(spookers);

				dancef = new FNFSprite(0, 0);
				dancef.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/dancefloor');
				dancef.scrollFactor.set(0.9, 0.9);
				dancef.animation.addByPrefix('floor1', 'floor1a', 24, false);
				dancef.animation.addByPrefix('floor2', 'floor2a', 24, false);
				dancef.animation.addByPrefix('floor3', 'floor3a', 24, false);	
				dancef.animation.addByPrefix('floor4', 'floor4a', 24, false);
				dancef.animation.addByPrefix('floor5', 'floor5a', 24, false);
				dancef.screenCenter(XY);
				add(dancef);
				dancef.alpha = 0.001;

				if(PlayState.SONG.song.toLowerCase() == 'nightfall')
				{
					opponentLoader.frames = Paths.getSparrowAtlas('characters/KIDS_HAPPY');
					opponentLoader.animation.addByPrefix('idle', 'spooky dance idle', 24, false);
					opponentLoader.animation.play('idle');
					add(opponentLoader);
				}

			case 'baladamedovirus':
				curStage = 'baladamedovirus';
				PlayState.defaultCamZoom = 0.56;

				var bg:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/baladamedo/layer0'));
				bg.scrollFactor.set(0.9, 0.9);
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();
				bg.screenCenter(XY);
				bg.antialiasing = true;
				add(bg);

				var front:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer1'));
				front.scrollFactor.set(0.9, 0.9);
				front.setGraphicSize(Std.int(front.width * 2));
				front.updateHitbox();
				front.screenCenter(XY);
				front.antialiasing = true;
				add(front);

				dancef = new FNFSprite(0, 0);
				dancef.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/dancefloor');
				dancef.scrollFactor.set(0.9, 0.9);
				dancef.animation.addByPrefix('floor1', 'floor1a', 24, false);
				dancef.animation.addByPrefix('floor2', 'floor2a', 24, false);
				dancef.animation.addByPrefix('floor3', 'floor3a', 24, false);	
				dancef.animation.addByPrefix('floor4', 'floor4a', 24, false);
				dancef.animation.addByPrefix('floor5', 'floor5a', 24, false);
				dancef.screenCenter(XY);
				add(dancef);
				dancef.alpha = 0.001;

				spookers = new FNFSprite(0, 0);
				spookers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/spookers');
				spookers.animation.addByPrefix('bump', 'SPEAKERS', 24, false);
				spookers.scrollFactor.set(0.9, 0.9);
				spookers.screenCenter(XY);
				spookers.antialiasing = true;
				spookers.y += 125;
				spookers.x += 6;
				add(spookers);

				barbaravirus = new FNFSprite(-630, -630);
				barbaravirus.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/barbara');
				barbaravirus.animation.addByPrefix('danceleft', 'danceleft', 24, false);
				barbaravirus.animation.addByPrefix('danceright', 'danceright', 24, false);
				barbaravirus.animation.play('danceLeft');
				barbaravirus.scrollFactor.set(0.9, 0.9);
				barbaravirus.antialiasing = true;

			case 'faveladia':
				curStage = 'faveladia';
				PlayState.defaultCamZoom = 0.76;

				var sky:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer0'));
				sky.scrollFactor.set(0.1, 0.1);
				sky.setGraphicSize(Std.int(sky.width * 2));
				sky.updateHitbox();
				sky.screenCenter(XY);
				sky.antialiasing = true;
				add(sky);

				var roaded:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer6'));
				roaded.scrollFactor.set(0.2, 0.2);
				roaded.screenCenter(XY);
				roaded.setGraphicSize(Std.int(roaded.width * 1.7));
				roaded.antialiasing = true;
				add(roaded);

				var houseback:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer52'));
				houseback.scrollFactor.set(0.36, 0.36);
				houseback.setGraphicSize(Std.int(houseback.width * 2));
				houseback.updateHitbox();
				houseback.screenCenter(XY);
				houseback.antialiasing = true;
				add(houseback);

				var house:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer5'));
				house.scrollFactor.set(0.4, 0.4);
				house.setGraphicSize(Std.int(house.width * 2));
				house.updateHitbox();
				house.screenCenter(XY);
				house.antialiasing = true;
				add(house);

				var tree:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer42'));
				tree.scrollFactor.set(0.42, 0.42);
				tree.setGraphicSize(Std.int(tree.width * 2));
				tree.updateHitbox();
				tree.screenCenter(XY);
				tree.antialiasing = true;
				add(tree);

				var brickthing:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer4'));
				brickthing.scrollFactor.set(0.65, 0.65);
				brickthing.setGraphicSize(Std.int(brickthing.width * 2));
				brickthing.updateHitbox();
				brickthing.screenCenter(XY);
				brickthing.antialiasing = true;
				add(brickthing);

				var thing:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer3'));
				thing.scrollFactor.set(0.69, 0.69);
				thing.setGraphicSize(Std.int(thing.width * 2));
				thing.updateHitbox();
				thing.screenCenter(XY);
				thing.antialiasing = true;
				add(thing);

				var city:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer2'));
				city.scrollFactor.set(0.85, 0.85);
				city.setGraphicSize(Std.int(city.width * 2));
				city.updateHitbox();
				city.screenCenter(XY);
				city.antialiasing = true;
				add(city);

				var street:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer1'));
				street.scrollFactor.set(0.9, 0.9);
				street.setGraphicSize(Std.int(street.width * 2));
				street.updateHitbox();
				street.screenCenter(XY);
				street.antialiasing = true;
				add(street);

				favelalight = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer7'));
				favelalight.scrollFactor.set(0.1, 0.1);
				favelalight.setGraphicSize(Std.int(favelalight.width * 2));
				favelalight.updateHitbox();
				favelalight.screenCenter(XY);
				favelalight.antialiasing = true;

			case 'favela': //Week 3 (no por do sol lindo demais)
				curStage = 'favela';
				PlayState.defaultCamZoom = 0.68;

				var sky:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer0'));
				sky.scrollFactor.set(0.1, 0.1);
				sky.setGraphicSize(Std.int(sky.width * 2));
				sky.updateHitbox();
				sky.screenCenter(XY);
				sky.antialiasing = true;
				add(sky);
				
				var roaded:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer6'));
				roaded.scrollFactor.set(0.2, 0.2);
				roaded.screenCenter(XY);
				roaded.setGraphicSize(Std.int(roaded.width * 1.7));
				roaded.antialiasing = true;
				add(roaded);

				var houseback:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer52'));
				houseback.scrollFactor.set(0.36, 0.36);
				houseback.setGraphicSize(Std.int(houseback.width * 2));
				houseback.updateHitbox();
				houseback.screenCenter(XY);
				houseback.antialiasing = true;
				add(houseback);

				var house:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer5'));
				house.scrollFactor.set(0.4, 0.4);
				house.setGraphicSize(Std.int(house.width * 2));
				house.updateHitbox();
				house.screenCenter(XY);
				house.antialiasing = true;
				add(house);

				var tree:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer42'));
				tree.scrollFactor.set(0.42, 0.42);
				tree.setGraphicSize(Std.int(tree.width * 2));
				tree.updateHitbox();
				tree.screenCenter(XY);
				tree.antialiasing = true;
				add(tree);

				var brickthing:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer4'));
				brickthing.scrollFactor.set(0.65, 0.65);
				brickthing.setGraphicSize(Std.int(brickthing.width * 2));
				brickthing.updateHitbox();
				brickthing.screenCenter(XY);
				brickthing.antialiasing = true;
				add(brickthing);

				var thing:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer3'));
				thing.scrollFactor.set(0.69, 0.69);
				thing.setGraphicSize(Std.int(thing.width * 2));
				thing.updateHitbox();
				thing.screenCenter(XY);
				thing.antialiasing = true;
				add(thing);

				danielzinho = new FNFSprite(500, 510);
				danielzinho.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/danielzinho');
				danielzinho.animation.addByPrefix('walk', 'danielwalk', 24, true);
				danielzinho.scrollFactor.set(0.7, 0.7);
				danielzinho.antialiasing = true;
				add(danielzinho);

				carrofoda = new FNFSprite(0, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/carrofoda'));
				carrofoda.scrollFactor.set(0.72, 0.72);
				carrofoda.setGraphicSize(Std.int(carrofoda.width * 2));
				carrofoda.updateHitbox();
				carrofoda.antialiasing = true;
				add(carrofoda);

				busao = new FNFSprite(2300, -40);
				busao.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/busao');
				busao.animation.addByPrefix('dance', 'busao', 24, false);
				busao.scrollFactor.set(0.7, 0.7);
				busao.antialiasing = true;
				add(busao);

				var city:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer2'));
				city.scrollFactor.set(0.85, 0.85);
				city.setGraphicSize(Std.int(city.width * 2));
				city.updateHitbox();
				city.screenCenter(XY);
				city.antialiasing = true;
				add(city);

				var street:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer1'));
				street.scrollFactor.set(0.9, 0.9);
				street.setGraphicSize(Std.int(street.width * 2));
				street.updateHitbox();
				street.screenCenter(XY);
				street.antialiasing = true;
				add(street);

				daniel = new FNFSprite(-2000, 260);
				daniel.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/daniel');
				daniel.animation.addByPrefix('dance', 'danieldance', 24, false);
				daniel.scrollFactor.set(0.92, 0.91);
				daniel.antialiasing = true;

				kleitin = new FNFSprite(2500, 255);
				kleitin.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/kleitin');
				kleitin.animation.addByPrefix('walk', 'kleiwalk', 24, true);
				kleitin.animation.addByPrefix('stop', 'kleistop', 24, false);
				kleitin.animation.addByPrefix('idle', 'kleidance', 24, false);
				kleitin.animation.addByPrefix('susto', 'kleisusto', 24, false);
				kleitin.animation.addByPrefix('dance', 'kleitin', 24, false);
				kleitin.animation.addByPrefix('bala', 'kleitiro', 24, false);
				kleitin.scrollFactor.set(0.9, 0.9);
				kleitin.antialiasing = true;
				kleitin.animation.play('idle');

				favelalight = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer7'));
				favelalight.scrollFactor.set(0.1, 0.1);
				favelalight.setGraphicSize(Std.int(favelalight.width * 2));
				favelalight.updateHitbox();
				favelalight.screenCenter(XY);
				favelalight.antialiasing = true;

				favelight = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer7'));
				favelight.scrollFactor.set(0.8, 0.8);
				favelight.setGraphicSize(Std.int(favelight.width * 2));
				favelight.updateHitbox();
				favelight.screenCenter(XY);
				favelight.antialiasing = true;

				opponentLoader.frames = Paths.getSparrowAtlas('characters/DONO_GUN');
				opponentLoader.animation.addByPrefix('idle', 'Dono Idle Dance', 24, false);
				opponentLoader.animation.play('idle');
				add(opponentLoader);

			case 'favelanoite':
				curStage = 'favelanoite';
				PlayState.defaultCamZoom = 0.75;
	
				var sky:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer0'));
				sky.scrollFactor.set(0.1, 0.1);
				sky.setGraphicSize(Std.int(sky.width * 2));
				sky.updateHitbox();
				sky.screenCenter(XY);
				sky.antialiasing = true;
				add(sky);
				
				var roaded:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer6'));
				roaded.scrollFactor.set(0.2, 0.2);
				roaded.screenCenter(XY);
				roaded.setGraphicSize(Std.int(roaded.width * 1.7));
				roaded.antialiasing = true;
				add(roaded);

				var houseback:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer52'));
				houseback.scrollFactor.set(0.36, 0.36);
				houseback.setGraphicSize(Std.int(houseback.width * 2));
				houseback.updateHitbox();
				houseback.screenCenter(XY);
				houseback.antialiasing = true;
				add(houseback);

				var house:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer5'));
				house.scrollFactor.set(0.4, 0.4);
				house.setGraphicSize(Std.int(house.width * 2));
				house.updateHitbox();
				house.screenCenter(XY);
				house.antialiasing = true;
				add(house);

				var tree:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer42'));
				tree.scrollFactor.set(0.42, 0.42);
				tree.setGraphicSize(Std.int(tree.width * 2));
				tree.updateHitbox();
				tree.screenCenter(XY);
				tree.antialiasing = true;
				add(tree);

				var brickthing:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer4'));
				brickthing.scrollFactor.set(0.65, 0.65);
				brickthing.setGraphicSize(Std.int(brickthing.width * 2));
				brickthing.updateHitbox();
				brickthing.screenCenter(XY);
				brickthing.antialiasing = true;
				add(brickthing);

				var thing:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer3'));
				thing.scrollFactor.set(0.69, 0.69);
				thing.setGraphicSize(Std.int(thing.width * 2));
				thing.updateHitbox();
				thing.screenCenter(XY);
				thing.antialiasing = true;
				add(thing);

				carrofoda = new FNFSprite(-600, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/carrofoda'));
				carrofoda.scrollFactor.set(0.72, 0.72);
				carrofoda.setGraphicSize(Std.int(carrofoda.width * 2));
				carrofoda.updateHitbox();
				carrofoda.antialiasing = true;
				add(carrofoda);

				busao = new FNFSprite(230, -40);
				busao.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/busao');
				busao.animation.addByPrefix('dance', 'busao', 24, false);
				busao.scrollFactor.set(0.7, 0.7);
				busao.antialiasing = true;
				add(busao);
	
				var city:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer2'));
				city.scrollFactor.set(0.85, 0.85);
				city.setGraphicSize(Std.int(city.width * 2));
				city.updateHitbox();
				city.screenCenter(XY);
				city.antialiasing = true;
				add(city);
	
				var street:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer1'));
				street.scrollFactor.set(0.9, 0.9);
				street.setGraphicSize(Std.int(street.width * 2));
				street.updateHitbox();
				street.screenCenter(XY);
				street.antialiasing = true;
				add(street);

				daniel = new FNFSprite(-540, 260);
				daniel.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/daniel');
				daniel.animation.addByPrefix('dance', 'danieldance', 24, false);
				daniel.scrollFactor.set(0.92, 0.91);
				daniel.antialiasing = true;

				kleitin = new FNFSprite(1080, 255);
				kleitin.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/kleitin');
				kleitin.animation.addByPrefix('dance', 'kleitin', 24, false);
				kleitin.animation.addByPrefix('bala', 'kleitiro', 24, false);
				kleitin.scrollFactor.set(0.9, 0.9);
				kleitin.antialiasing = true;
				kleitin.animation.play('dance');

				pessoas = new FNFSprite(0, 0);
				pessoas.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/CARRO');
				pessoas.animation.addByPrefix('dance', 'carroum', 24, false);
				pessoas.screenCenter(XY);
				pessoas.y += 685;
				pessoas.antialiasing = true;
	
				favelalight = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer7'));
				favelalight.scrollFactor.set(0.1, 0.1);
				favelalight.setGraphicSize(Std.int(favelalight.width * 2));
				favelalight.updateHitbox();
				favelalight.screenCenter(XY);
				favelalight.antialiasing = true;

				opponentLoader.frames = Paths.getSparrowAtlas('characters/DONO_DOUBLEGUN_NIGHT');
				opponentLoader.animation.addByPrefix('idle', 'Dono Idle Dance', 24, false);
				opponentLoader.animation.play('idle');
				add(opponentLoader);

				playerLoader.frames = Paths.getSparrowAtlas('characters/BIDU_GOLD_NIGHT_ALT');
				playerLoader.animation.addByPrefix('idle', 'BIDU idle dance', 24, false);
				playerLoader.animation.play('idle');
				add(playerLoader);

			case 'floresta': //Salsisha Song lol
				curStage = 'floresta';
				PlayState.defaultCamZoom = 0.48;

				var sky:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer0'));
				sky.scrollFactor.set(0.1, 0.1);
				sky.setGraphicSize(Std.int(sky.width * 2));
				sky.updateHitbox();
				sky.screenCenter(XY);
				sky.antialiasing = true;
				add(sky);

				var tree:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer1'));
				tree.scrollFactor.set(0.2, 0.2);
				tree.setGraphicSize(Std.int(tree.width * 2));
				tree.updateHitbox();
				tree.screenCenter(XY);
				tree.antialiasing = true;
				add(tree);

				var tree:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer2'));
				tree.scrollFactor.set(0.46, 0.46);
				tree.setGraphicSize(Std.int(tree.width * 2));
				tree.updateHitbox();
				tree.screenCenter(XY);
				tree.antialiasing = true;
				add(tree);

				var tree:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer3'));
				tree.scrollFactor.set(0.55, 0.55);
				tree.setGraphicSize(Std.int(tree.width * 2));
				tree.updateHitbox();
				tree.screenCenter(XY);
				tree.antialiasing = true;
				add(tree);

				var tree:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer4'));
				tree.scrollFactor.set(0.66, 0.66);
				tree.setGraphicSize(Std.int(tree.width * 2));
				tree.updateHitbox();
				tree.screenCenter(XY);
				tree.antialiasing = true;
				add(tree);

				var pedras:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer5'));
				pedras.scrollFactor.set(0.85, 0.85);
				pedras.setGraphicSize(Std.int(pedras.width * 2));
				pedras.updateHitbox();
				pedras.screenCenter(XY);
				pedras.antialiasing = true;
				add(pedras);

				var van:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer6'));
				van.scrollFactor.set(0.9, 0.9);
				van.setGraphicSize(Std.int(van.width * 2));
				van.updateHitbox();
				van.screenCenter(XY);
				van.antialiasing = true;
				add(van);

				treefront = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer7'));
				treefront.scrollFactor.set(0.95, 0.95);
				treefront.setGraphicSize(Std.int(treefront.width * 2));
				treefront.updateHitbox();
				treefront.screenCenter(XY);
				treefront.antialiasing = true;

				florestalight = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/layer8'));
				florestalight.scrollFactor.set(0.1, 0.1);
				florestalight.setGraphicSize(Std.int(florestalight.width * 2));
				florestalight.updateHitbox();
				florestalight.screenCenter(XY);
				florestalight.antialiasing = true;

				opponentLoader.frames = Paths.getSparrowAtlas('characters/SALSICHA_BOMBADO');
				opponentLoader.animation.addByPrefix('idle', 'Salsicha Idle', 24, false);
				opponentLoader.animation.play('idle');
				add(opponentLoader);
				
			case 'spooky':
				curStage = 'spooky';
				// halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('backgrounds/' + curStage + '/halloween_bg');

				halloweenBG = new FNFSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

			// isHalloween = true;
			case 'philly':
				curStage = 'philly';

				var bg:FNFSprite = new FNFSprite(-100).loadGraphic(Paths.image('backgrounds/' + curStage + '/sky'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FNFSprite = new FNFSprite(-10).loadGraphic(Paths.image('backgrounds/' + curStage + '/city'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<FNFSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FNFSprite = new FNFSprite(city.x).loadGraphic(Paths.image('backgrounds/' + curStage + '/win' + i));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				var streetBehind:FNFSprite = new FNFSprite(-40, 50).loadGraphic(Paths.image('backgrounds/' + curStage + '/behindTrain'));
				add(streetBehind);

				phillyTrain = new FNFSprite(2000, 360).loadGraphic(Paths.image('backgrounds/' + curStage + '/train'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FNFSprite = new FNFSprite().loadGraphic(AssetPaths.win0.png);

				var street:FNFSprite = new FNFSprite(-40, streetBehind.y).loadGraphic(Paths.image('backgrounds/' + curStage + '/street'));
				add(street);
			case 'highway':
				curStage = 'highway';
				PlayState.defaultCamZoom = 0.90;

				var skyBG:FNFSprite = new FNFSprite(-120, -50).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoSunset'));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FNFSprite = new FNFSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bgLimo');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}

				var overlayShit:FNFSprite = new FNFSprite(-500, -600).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoOverlay'));
				overlayShit.alpha = 0.5;
				// add(overlayShit);

				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

				// overlayShit.shader = shaderBullshit;

				var limoTex = Paths.getSparrowAtlas('backgrounds/' + curStage + '/limoDrive');

				limo = new FNFSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FNFSprite(-300, 160).loadGraphic(Paths.image('backgrounds/' + curStage + '/fastCarLol'));
			// loadArray.add(limo);
			case 'mall':
				curStage = 'mall';
				PlayState.defaultCamZoom = 0.80;

				var bg:FNFSprite = new FNFSprite(-1000, -500).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgWalls'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FNFSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/upperBop');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);

				var bgEscalator:FNFSprite = new FNFSprite(-1100, -600).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgEscalator'));
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FNFSprite = new FNFSprite(370, -250).loadGraphic(Paths.image('backgrounds/' + curStage + '/christmasTree'));
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FNFSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bottomBop');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:FNFSprite = new FNFSprite(-600, 700).loadGraphic(Paths.image('backgrounds/' + curStage + '/fgSnow'));
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);

				santa = new FNFSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/santa');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);
			case 'mallEvil':
				curStage = 'mallEvil';
				var bg:FNFSprite = new FNFSprite(-400, -500).loadGraphic(Paths.image('backgrounds/mall/evilBG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:FNFSprite = new FNFSprite(300, -300).loadGraphic(Paths.image('backgrounds/mall/evilTree'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);

				var evilSnow:FNFSprite = new FNFSprite(-200, 700).loadGraphic(Paths.image("backgrounds/mall/evilSnow"));
				evilSnow.antialiasing = true;
				add(evilSnow);
			case 'school':
				curStage = 'school';

				// defaultCamZoom = 0.9;

				var bgSky = new FNFSprite().loadGraphic(Paths.image('backgrounds/' + curStage + '/weebSky'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FNFSprite = new FNFSprite(repositionShit, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebSchool'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FNFSprite = new FNFSprite(repositionShit).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebStreet'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FNFSprite = new FNFSprite(repositionShit + 170, 130).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebTreesBack'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FNFSprite = new FNFSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('backgrounds/' + curStage + '/weebTrees');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FNFSprite = new FNFSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/petals');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				if (PlayState.SONG.song.toLowerCase() == 'roses')
					bgGirls.getScared();

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);
			case 'schoolEvil':
				var posX = 400;
				var posY = 200;
				var bg:FNFSprite = new FNFSprite(posX, posY);
				bg.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/animatedEvilSchool');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);

			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'barbara';

		switch (curStage)
		{
			case 'balada' | 'floresta':
				gfVersion = 'barbara-blue';
			case 'baladamedo':
				gfVersion = 'barbara-raspberry';
			case 'baladamedovirus':
				gfVersion = 'lemon';
			case 'faveladia':
				gfVersion = 'barbara-chocolate';
			case 'favela':
				gfVersion = 'barbara-chocolate-sunset';
			case 'favelanoite':
				gfVersion = 'barbara-chocolate-night';
			case 'highway':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}
		
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'reboop':
				gfVersion = 'barbara-blue';
			case 'fresher':
				gfVersion = 'barbara-blue-bite';
			case 'rap-king':
				gfVersion = 'barbara';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray) {
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;
				case 'kevin':
					gf.visible = false;
				/*
					if (isStoryMode)
					{
						camPos.x += 600;
						tweenCamIn();
				}*/
				/*
				case 'spirit':
					var evilTrail = new FlxTrail(char, null, 4, 24, 0.3, 0.069);
					evilTrail.changeValuesEnabled(false, false, false, false);
					add(evilTrail);
					*/
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'highway':
				boyfriend.y -= 220;
				boyfriend.x += 260;
			case 'mall':
				boyfriend.x += 200;
				dad.x -= 400;
				dad.y += 20;
			case 'mallEvil':
				boyfriend.x += 320;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				dad.x += 200;
				dad.y += 580;
				gf.x += 200;
				gf.y += 320;
			case 'schoolEvil':
				dad.x -= 150;
				dad.y += 50;
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'balada':
				boyfriend.y -= 10;
				boyfriend.x += 65;
				dad.y -= 10;
				dad.x -= 90;
				gf.y -= 10;
				gf.x -= 15;
				gf.scrollFactor.set(0.93, 0.9);
				boyfriend.scrollFactor.set(0.9, 0.9);
				dad.scrollFactor.set(0.9, 0.9);
			case 'baladamedo':
				boyfriend.y -= 60;
				boyfriend.x += 35;
				dad.y -= 22;
				dad.x -= 180;
				//gf.x -= 80;
				gf.y -= 80;
				gf.scrollFactor.set(0.9, 0.9);
				boyfriend.scrollFactor.set(0.9, 0.9);
				dad.scrollFactor.set(0.9, 0.9);
			case 'baladamedovirus':
				boyfriend.y -= 60;
				boyfriend.x += 35;
				dad.y -= 22;
				dad.x -= 180;
				gf.x -= 314;
				gf.y -= 190;
				gf.scrollFactor.set(0.9, 0.9);
				boyfriend.scrollFactor.set(0.9, 0.9);
				dad.scrollFactor.set(0.9, 0.9);
			case 'faveladia' | 'favela' | 'favelanoite':
				boyfriend.y -= 80;
				boyfriend.x += 42;
				dad.x -= 180;
				dad.y -= 35;
				gf.y += 15;
				gf.x += 25;
				gf.scrollFactor.set(0.9, 0.9);
				boyfriend.scrollFactor.set(0.9, 0.9);
				dad.scrollFactor.set(0.9, 0.9);
			case 'floresta':
				boyfriend.x += 390;
				dad.x -= 440;
				gf.y -= 220;
				gf.x -= 60;
				gf.scrollFactor.set(0.85, 0.85);
				boyfriend.scrollFactor.set(0.9, 0.9);
				dad.scrollFactor.set(0.9, 0.9);
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'highway':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'baladamedo':
				if (spookersvel == 1)
				{
					if (curBeat % 1 == 0)
					{
						spookers.animation.play('bump', true);
					}
				}
				else 
				{
					if (curBeat % 2 == 0)
					{
						spookers.animation.play('bump', true);
					}
				}

				switch(dancefvel)
				{
					case 1:
						dancef.animation.play('floor' + ((curBeat % 5) + 1));
					case 3:
						dancef.animation.play('floor' + ((Math.floor(curBeat / 4) % 5) + 1));
					default:
						dancef.animation.play('floor' + ((Math.floor(curBeat / 2) % 5) + 1));
				}		
			case 'baladamedovirus':
				if (spookersvel == 1) {
	
					if (curBeat % 1 == 0)
						{
							spookers.animation.play('bump', true);
						}
	
				}
				else {
	
					if (curBeat % 2 == 0)
						{
							spookers.animation.play('bump', true);
						}
						
				}
				if (curBeat % 1 == 0)
					barbaravirus.animation.play('danceleft', true);
				if (curBeat % 2 == 0)
					barbaravirus.animation.play('danceright', true);

				switch(dancefvel)
				{
					case 1:
						dancef.animation.play('floor' + ((curBeat % 5) + 1));
					case 3:
						dancef.animation.play('floor' + ((Math.floor(curBeat / 4) % 5) + 1));
					default:
						dancef.animation.play('floor' + ((Math.floor(curBeat / 2) % 5) + 1));
				}
			case 'favela':
				if (kleistate == 1)
				{
					kleitin.animation.play('walk', true);
				}
				danielzinho.animation.play('walk', true);
				if (curBeat % 2 == 0)
				{
					switch(kleistate)
					{
						case 2:
							kleitin.animation.play('idle', true);
						case 3:
							kleitin.animation.play('dance', true);
					}
					daniel.animation.play('dance', true);
				}
				busao.animation.play('dance', true);
			case 'favelanoite':
				if (curBeat % 2 == 0)
				{
					kleitin.animation.play('dance', true);
					daniel.animation.play('dance', true);
				}
				busao.animation.play('dance', true);
				pessoas.animation.play('dance', true);

			case 'school':
				bgGirls.dance();

			case 'philly':
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var lastLight:FlxSprite = phillyCityLights.members[0];

					phillyCityLights.forEach(function(light:FNFSprite)
					{
						// Take note of the previous light
						if (light.visible == true)
							lastLight = light;

						light.visible = false;
					});

					// To prevent duplicate lights, iterate until you get a matching light
					while (lastLight == phillyCityLights.members[curLight])
					{
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					}

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}
		}
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}
