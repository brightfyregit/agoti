package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'screenplay':
				if (PlayState.isStoryMode)
				{
					FlxG.sound.playMusic(Paths.music('screenplaydialogue', 'agoti'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.45);
				}
			case 'parasite':
				if (PlayState.isStoryMode)
				{
					FlxG.sound.playMusic(Paths.music('prisonbreak', 'agoti'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.45);
				}
			case 'a.g.o.t.i':
				if (PlayState.isStoryMode)
				{
					FlxG.sound.playMusic(Paths.music('void', 'agoti'), 0);
					FlxG.sound.music.fadeIn(1, 0, 1);
				}
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'screenplay' | 'parasite' | 'a.g.o.t.i':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('Dialogue_Box', 'agoti');
				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
				box.animation.addByPrefix('normalOpen', 'P5_Box', 24, true);
				box.animation.addByIndices('normal', 'P5_Box', [4], "", 24, true);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		

		portraitLeft = new FlxSprite();
		portraitLeft.frames = Paths.getSparrowAtlas('Agoti_Dialogue', 'agoti');
		portraitLeft.animation.addByPrefix('normal', 'Agoti_Dialogue_A', 24, false);
		portraitLeft.animation.addByPrefix('angry', 'Agoti_Dialogue_B', 24, false);
		portraitLeft.animation.addByPrefix('scared', 'Agoti_Dialogue_C', 24, false);
		portraitLeft.animation.addByPrefix('crazy', 'Agoti_Dialogue_D', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		portraitLeft.screenCenter(X);
		portraitLeft.y += 125;
		portraitLeft.x -= 275;
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(700, 200);
		portraitRight.frames = Paths.getSparrowAtlas('BF_Dialogue', 'agoti');
		portraitRight.animation.addByPrefix('normal', 'BF_Dialogue_A', 24, false);
		portraitRight.animation.addByPrefix('scared', 'BF_Dialogue_B', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * 4.5));
		box.screenCenter(X);
		box.x -= 375;
		box.y -= 60;
		box.updateHitbox();
		add(box);



		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 50);
		dropText.font = 'p5hatty';
		dropText.color = FlxColor.fromRGB(90, 90, 90);
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 50);
		swagDialogue.font = 'p5hatty';
		swagDialogue.color = FlxColor.fromRGB(30, 30, 30);
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{

		dropText.text = swagDialogue.text;

		dialogueOpened = true;

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('skipDialog', 'agoti'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'screenplay' || PlayState.SONG.song.toLowerCase() == 'parasite' || PlayState.SONG.song.toLowerCase() == 'a.g.o.t.i')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'agoti':
				portraitRight.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('agotiText', 'agoti'), 0.6)];
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			case 'agoti-angry':
				portraitRight.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('agotiAngryText', 'agoti'), 0.6)];
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			case 'agoti-scared':
				portraitRight.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('agotiScaredText', 'agoti'), 0.6)];
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			case 'agoti-crazy':
				portraitRight.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('agotiScaredText', 'agoti'), 0.6)];
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			case 'bf':
				portraitLeft.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('boyfriendText', 'agoti'), 0.6)];
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
			case 'bf-scared':
				portraitLeft.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('boyfriendText', 'agoti'), 0.6)];
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();

		if (curCharacter.startsWith('agoti'))
		{
			box.flipX = true;
			if (curCharacter.contains('angry'))
			{
				portraitLeft.animation.play('angry');
			}
			else if (curCharacter.contains('scared'))
			{
				portraitLeft.animation.play('scared');
			}
			else if (curCharacter.contains('crazy'))
			{
				portraitLeft.animation.play('crazy');
			}
			else
			{
				portraitLeft.animation.play('normal');
			}
		}
		else if (curCharacter.startsWith('bf'))
		{
			box.flipX = false;
			if (curCharacter.contains('scared'))
			{
				portraitRight.animation.play('scared');
			}
			else 
			{
				portraitRight.animation.play('normal');
			}
		}
	}
}
