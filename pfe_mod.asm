; This disassembly was created using Emulicious (https://www.emulicious.net)
; This is a partial and commented disassembly on this game. I had some questions regarding what the game does and how it does it.
; My main questions were: -How is this game this big, despite having so little in content.
;						  -Is there anything else not used, or hidden? I was interested especially in music, since I really like
; what's in the game.
;						  -Also, I was interested in general how a game like this works, and what makes it tick.
;Most of the game's code is commented, even though I think I made a lot of mistakes in understanding z80 assembly, but this is my
;first time dissecting code.
;So answers to the questions: The game is large, as it does not use any compression on its graphics, and uses space for very 
;extravagant things, like the game over graphics zooming in. 
;The game has little in unused graphical assets, no extra music. Besides the known easter eggs, it does not have anything else unearthed.
;Also yes, it helped me understand the console better.
;Many thanks for Calindro for the Emulator, it's really awesome in every way.
.MEMORYMAP
SLOTSIZE $7FF0
SLOT 0 $0000
SLOTSIZE $10
SLOT 1 $7FF0
SLOTSIZE $4000
SLOT 2 $8000
DEFAULTSLOT 2
.ENDME
.ROMBANKMAP
BANKSTOTAL 32
BANKSIZE $7FF0
BANKS 1
BANKSIZE $10
BANKS 1
BANKSIZE $4000
BANKS 30
.ENDRO
;Many memory mappings were done with Emulicious' Memory Editor, and inspecting what's changed, then checking the code around it.
.enum $C000 export ;Start of SMS RAM.
_RAM_start dsb $10
_RAM_C010_MNEStays db ;This glitches the screen out, and you and the enemy stays on screen.
.ende

.enum $C020 export
_RAM_C020_palTemp dsb $20 ;32 bytes, definetly some temporary palette storage.
_RAM_C040_ db ;Used at a routine that executes at the beginning of the match, modified midgame will glitch the bg.
.ende

.enum $C100 export
_RAM_C100_plyr1Score db ;Highscore related, how it shows on the screen.
_RAM_C101_plyr1money db ;These are player money related, in BCD.
.ende

.enum $C20A export ;These should be sound engine related variables.
_RAM_C20A_musicEnable db
_RAM_C20B_musicVolume db
_RAM_C20C_musicSegmentLength db ;This tells how long a music segment is in bytes.
_RAM_C20D_musicTempo db
_RAM_C20E_musicTimer? db ;This decreases, stopping it stops the music also.
_RAM_C20F_musicSegmentPointer dw
_RAM_C211_musicPointer dw ;This is used also as a pointer for music.
_RAM_C213_ch1Note dw ;Second bytes are vibrato
_RAM_C215_ch2Note dw
_RAM_C217_ch3Note dw
_RAM_C219_noiseNote dw
_RAM_C21B_appregioDecayCH1 db
_RAM_C21C_appregioDecayCH2 db
_RAM_C21D_appregioDecayCH3 db
_RAM_C21E_noiseCHdecay db
_RAM_C21F_ch1enable db
_RAM_C220_ch2enable db
_RAM_C221_ch3Enable db
_RAM_C222_channel4Enable db
_RAM_C223_PSG1? db
_RAM_C224_musicFadaoutPrescaler db
_RAM_C225_soundFadeOutTimer db 
_RAM_C226_musicSegmentCounter? db
_RAM_C227_ db ;No idea yet, could be some temporary storage.
.ende
;What's up with these holes in memory enumeration?
.enum $C267 export
_RAM_C267_ch1NoteSustain db
.ende

.enum $C336 export
_RAM_C336_NMESpritePosOnScreen dw
_RAM_C338_howmanyspronscrn db
.ende

.enum $C33B export
_RAM_C33B_plyfieldborder dw
_RAM_C33D_playFieldBaseHeight dw ;This was used to determine where the "ground" is for the players.
.ende

.enum $C341 export 
_RAM_C341_gamepause2 db ;If this is not 0, the game will be paused, or if frozen, it cannot be paused.
_RAM_C342_gamePaused db ;This is also used for pausing apperently.
_RAM_C343_unused db	;It's only zeroed out, then nothing else writes to it.
_RAM_C344_mapperPagerTemp db ;Used to hold mapper page values temporarily.
_RAM_C345_ dw ;Playfield horizontal scroll related, it is a pointer for the stage graphics, and what to draw on the screen.
_RAM_C347_unused dw ;Seems to be unused.
_RAM_C349_unused dw ;Totally unused, nothing reads from here, just writes once.
_RAM_C34B_ dw ;No idea yet, could be just a temporary location. Just used only one place.
_RAM_C34D_animateCrowd db	;If 0, the crowd is not animated.
_RAM_C34E_playfieldcamerapos db 
_RAM_C34F_verticalScroll db
_RAM_C350_hudScrollEnable db 
_RAM_C351_ db ;Player1 something, changes with distance and a few factors.
_RAM_C352_unused db	;Seems to be unused, it is not read from at all directly.
_RAM_C353_unused db ;Seems to be unused, same as above.
_RAM_C354_isroundon db ;If this is zero, the players are removed from the screen, and the game cannot be paused either. If the game is not paused, and this is zero, the timer goes on.
_RAM_C355_scrollcamera2 db
_RAM_C356_scrollcamera db ;This tells the game if the screen has to scroll in a given direction. 01 is to the right
;FF to the left.
_RAM_C357_player1char db
_RAM_C358_player2char db
_RAM_C359_roundScreenNr db
_RAM_C35A_levelNumberInMenu db
_RAM_C35B_twoplayergametype db
_RAM_C35C_plyr1character db
_RAM_C35D_plyr2character db ;Yes, this is defined in two places, but these are rather used in the Options menu.
_RAM_C35E_soundOnOff db
_RAM_C35F_numberofPlayers db
_RAM_C360_difficulty db
_RAM_C361_practicemode db
_RAM_C362_hudTileOffset db ;The tiles making up the HUD are shifted to the next value in VRAM, that why I think it's an offset of some kind.
_RAM_C363_ db ;If it's not zero, the game freezes.
_RAM_C364_scoreLetterOffset db
_RAM_C365_paletteTemp dw ;Used to hold palette ROM addresses.
_RAM_C367_ dw ;Does nothing ingame, but it's around VDP things, so this is most likely a pointer.
.ende

.enum $C36C export
_RAM_C36C_canExitFromOptions db	;If this is set to 0 or 1, we can exit from the options menu, else we will go back to options.
_RAM_C36D_grudgematch db
_RAM_C36E_matchwin db
_RAM_C36F_ db ;Hides characters/scrolls to the right.
_RAM_C370_verticalScroll dw
_RAM_C372_timer? dw
_RAM_C374_timer? dw
_RAM_C376_menuCursorPos db ;
_RAM_C377_ db
_RAM_C378_titlescreenvscrolldata? dw ;In the intro, if you freeze the values, it reads the same data for the credits.
_RAM_C37A_plyrchooseDone? dw ;At the character select screen, if this is not 0, the game won't continue.
_RAM_C37A_plyr2chooseDone? dw ;For the second player.
_RAM_C37E_ dw ;Does nothing when frozen.
_RAM_C380_ dw ;Does nothing when frozen.
_RAM_C382_ db ;Ditto.
.ende

.enum $C385 export
_RAM_C385_levelNumberHex db ;$6F is level 0 This is used at the Options screen, when you select the level you want.
.ende

.enum $C391 export
_RAM_C391_pointer? dw ;If you modify it, it crashes the game, but it is likely some pointer.
_RAM_C393_JOYPAD1 db
_RAM_C394_JOYPAD2 db
_RAM_C395_ dw ;This does not seem to be used, as there is only one write to this address.
_RAM_C397_enemyState db ;Changing this value will alter the enemy behaviour.
_RAM_C398_isroundon db ; 01 during matches, and 00 otherwise.
_RAM_C399_unused? db ; 00 during matches.
_RAM_C39A_matchTimer db ;Controls the timer on the match screen in the middle.
_RAM_C39B_matchTimerSmall db ;This is the smaller segment of the timer, smaller than a second(per frame?), when stopped, the on screen timer also stops. Likely it updates the timer above, when going over certain value.
_RAM_C39C_VDPStatus db ;This is used for checking the VDP status. The code reads the status, and stores in this variable.
.ende

.enum $C39E export
_RAM_C39E_timer db ;Used for the menu cursor movement timing, and stops counting during pause. When frozen, no effect on matches.
.ende

.enum $C3A0 export
_RAM_C3A0_charSelectTimer db ;It's the timer on the screen. If you freeze this, you can stay on this screen as long as you want.
.ende

.enum $C3A2 export
_RAM_C3A2_timerml db ;This is more used like as a general timer in loops.
.ende

.enum $C3A4 export
_RAM_C3A4_ db ;In the code, we only read from this address, but never write.
_RAM_C3A5_JOYPAD1_2 db
.ende

.enum $C400 export
_RAM_C400_delay db ;This is used in delay codes, mostly with palette and general video stuff.
.ende

.enum $C500 export
_RAM_C500_soundPointer db ;Changing the number will play a sound and keep it in play, until it is zero again.
.ende

.enum $C503 export
_RAM_C503_soundNumberTemp dw
_RAM_C505_hitCounter2 db
_RAM_C506_hitCounter1 db ;These are all incremented when you push an attack button. Counts to three, and adds one to C505. Once those counters are full, they go back to 0.
_RAM_C507_sounfEff db
_RAM_C508_soundEff2 db
.ende

.enum $C528 export
_RAM_C528_soundEff3 db
.ende

.enum $C548 export
_RAM_C548_soundEff4 db
.ende

.enum $C568 export
_RAM_C568_soundEff5 db
.ende
;These above are in sound playing routines, my guess is that these are certain sound properties, but I've not went that deep.
.enum $C5C0 export
_RAM_C5C0_ramCodePointer1 dw
.ende

.enum $C64E export
_RAM_C64E_BANKSWITCH_PAGE db
.ende

.enum $C6CD export
_RAM_C6CD_ dsb $10 ;These are some temporary palette storages.
_RAM_C6DD_ dsb $10
_RAM_C6ED_plyr1XposScrnHalf dw ;The first byte is the X coordinate on the screen of plyr1. The second byte is on which half of the screen.
_RAM_C6EF_plyr1YPos dw
_RAM_C6F1_plyr2XPosScrnHalf dw
_RAM_C6F3_plyr2YPos dw
_RAM_C6F5_gmplyAnim db
_RAM_C6F6_animFrameCounter db
_RAM_C6F7_plyr1Frame db
_RAM_C6F8_plyr2Frame db
_RAM_C6F9_plyr1Frame2 dw
_RAM_C6FB_plyr1Frame3 db
_RAM_C6FC_plyr2Frame1 dw
_RAM_C6FE_plyr2Frame2 db
_RAM_C6FF_plyr1animateEnable db
_RAM_C700_plyr2animateEnable db
_RAM_C701_pointer dw ;This is some pointer, it phenomenally crashes the game, by overwriting memory.
_RAM_C703_spriteDrawNumber db
_RAM_C704_pointer dw ;Crashes the game, and corrupts graphics.
_RAM_C706_pointer dw ;=.= (palette)
_RAM_C708_plyr1PosPointer dw ;Player 1 starts to jump around vertically if frozen.
_RAM_C70A_plyr2PosPointer dw ;Same for player 2, but if frozen, the game refuses to boot.
_RAM_C70C_tempStorPlyr1 db ;It is used once for selecting a ROM bank. For player 1.
_RAM_C70D_tempStorPlyr2 db ;Same for player 2.
_RAM_C70E_plyr2SpriteRelated dw ;Jokes around with the enemy sprites somehow.
_RAM_C710_plyr1Animate db ;Frozen to zero makes the animation work, but glitches out sometimes. Any other fix value will freeze the animation.
_RAM_C711_plyr1AnimationFrame db ;Controls which frame of animation to show. If frozen, the character stays in that frame.
_RAM_C712_plyr1AnimFrameControl? dw ;When frozen, only the first frame of animation is shown.
_RAM_C714_plyr2AnimFrameControl? dw ;Does the same for the second player.
_RAM_C716_nmeAnimandHit? db ;Stops the animation of the enemy, but switches off the damage from the hits, but this is not the proper hit detection I think...
_RAM_C717_plyr2AnimFrame? db
_RAM_C718_plyr2animRelated? dw ;Does something with the enemy animation, but only the second byte.
.ende

.enum $C71C export
_RAM_C71C_nmeHitBox1? db
_RAM_C71D_ db ;This seems to be used around collision detection, but we are just reading from this, not writing to.
_RAM_C71E_hitbox? dw
_RAM_C720_hitboxDamage db ;If this is changed, the damage is changed, or even disabled.
_RAM_C721_dmgSpriteXscrnHalfNME dw ;This is only for the damage "indicator" sprites. (Sweat or something like that.)The X coordinate, and the screen half as the second byte.
_RAM_C723_dmgSpriteYNME db ;This is the Y coordinate for the damage sprite, for the enemy.
_RAM_C724_CrowdCheerAnimTimer db	;This is a timer, which is when filled with a number, it animates the background
;crowd much faster than normally. I guess this is a cheering variable.
_RAM_C725_ db ;Temp values? Not evident from here, and freezing them is not doing anything.
.ende

.enum $C729 export
_RAM_C729_unused db ;Not used, just one. Nothing reads from this. There is only one write to this value.
.ende

.enum $C72D export
_RAM_C72D_unused db ;This is the same as above, there is just one write here, but no reads directly.
.ende

.enum $C731 export
_RAM_C731_unused db ;Same as above.
.ende

.enum $C735 export
_RAM_C735_plyr1Dead db ;This goes to 0 when player 1 dies.
_RAM_C736_plyr1XandScrnHalf dw ;This is also player 1's X coordinate, and screen half indicator.
_RAM_C738_plyr1YCoordinate db
_RAM_C739_ db ;There is just one write to this value, yet the game gets frozen when the value is frozen too.
_RAM_C73A_plyr1State db ;Represents what the player does:
;00-standing still
;01-up/down/right movement
;02-left movement
;03-normal jump right
;04-normal jump left
;05-punch right
;06-punch left
;07-kick right
;08-kick left
;09-jumpkick right
;0A-jumpkick left
;0B-Special move left
;0C-Special move right
;0F-Gets hit from the right.
;10-Gets hit from the left.
;11-Knockdown from the right.
;12-Knockdown from the left.
;13-Lying down left.
;14-Lying down right.
;15-Flinching right.
;16-Flinching left.
;17-Stand up right.
;18-Stand up left.
;19-Punching ground target right.
;1A-Punching ground target left.
;1B-Right to left throw, then taunt.
;1C-Left to right throw, then taunt.
;1D-Some part of the jumping, landing or the beginning of the jump.
;1E-Very similar, maybe the other direction.
;1F-Getting hit from the right2.
;20-Same from the left.
;21-Spec move from the right, last part?
;22-From the left.
;23-Hit and knocked down from the right.
;24-From the left.
;25-Hitting ground target left right.
;26-Hitting ground target left.
;27-Knockdown right.
;28-Knockdown left.
;29-Specmove left?
;2A-from the right.
;2B-Dead, right.
;2C-Dead, left.
;2D-Pickup right.(object on ground)
;2E-Pickup left.
;2F-Lifting object right.
;30-From the right.
;31-Throw right?
;32-Left?
;33-Complete throw left.
;34-Complete throw right. (Spec move.)
;35-Complete spec move left animation.
;36-Same for right.
;37-Turns the character right(the actor disappears while doing this)
;38-Same for left.
;39-Taunt pose right.
;3A-Taunt pose left. (There is a few pixel difference between these, not sure why it exists as a separate frame.)
;3B-The actor disappears.
;3C-Same (pls dont tell me there is a right and left for this too..)
;3D-Right step frame?
;3E-Actor disappears.
;3F-=.=
;40 and over seems to do the same, as well as FF.
_RAM_C73B_plyr1Direction db ;Player 1 direction. 01 right 02 left.
.ende

.enum $C744 export
_RAM_C744_unused? db ;There is just one write to this, but nothing reads from it directly.
_RAM_C745_plyr1SpecMoveCounter db ;How many special moves plyr 1 has.
_RAM_C746_ db ;Messes up animation, and plyr1 can't move or attack, the enemy will attack, but with missing frames. Player still can be hurt, but no animation will play.
.ende

.enum $C74C export
_RAM_C74C_ db ;Some temp storage value, appears in a few subroutines.
_RAM_C74D_ dw ;Increments when plyr1 hits something. But not by 1 each time.
_RAM_C74F_plyr1Lives db ;How many defeats are permitted before a game over.
_RAM_C750_plyr1KnockDowns db ;Counts how many knockdowns the player has.
_RAM_C751_plyr1Life db ;Player 1 life meter.
_RAM_C752_forkliftPowerPill? db ;Setting this to FF will give you a power pill powerup at the end of the match, yet, at the round assesment after a win, the forklift with the player will go up forever, until we unfreeze this value.
_RAM_C753_unused? dw ;Not seemed to be used. It is written once, but not read once.
.ende

.enum $C758 export
_RAM_C758_plyrmneHit? db ;Both players will get randomly hit when this value is increased. 04 and onward.
_RAM_C759_unused? db ;This part is written, but not read from. So maybe it's unused.
.ende

.enum $C75E export
_RAM_C75E_unused? db ;This is also just written to, nothing reads it directly.
_RAM_C75F_unused? db ;Same.
_RAM_C760_unused? db ;Same.
_RAM_C761_unused? db ;Same.
.ende

.enum $C766 export
_RAM_C766_hitAmount? db ;Higher values caused many more hits on  player1, but this value was not read, just written to. I think the higher the value, the higher the chance is to receive seemingly random hits
;and damages, until you die.
_RAM_C767_ dw ;Frozen, or setting it to 00 does nothing.
_RAM_C769_Player2defeat? db ;When this is zero, the match is won.
_RAM_C76A_Plyr2XnScrnHalf dw ;Player 2's X position, and which half of the screen is on.
_RAM_C76C_player2yPosition db ;Player 2 Y position.
_RAM_C76D_plyrDistance? db ;It changes based on the distance between players. 03 is far (distance needs to be reduced),04-05-05 less and less distance and then attacking plyr 1.
_RAM_C76E_plyr2State db ;What the player does, it's the same as the big list a few lines above.
_RAM_C76F_plyr2Animation? db ;This breaks the animation of player 2, stucks in a position, and move around the screen like that.
.ende

.enum $C778 export
_RAM_C778_ db ;No idea yet. Used as a temporary value, which it only written to.
_RAM_C779_plyr2specMoveCounter db
_RAM_C77A_plyr2Attack? db ;This variable set to 00, plyr1 will attack itself.
.ende

.enum $C780 export
_RAM_C780_ db ;No idea yet, what it does, but changing does not do anything noticeable in single or in two player mode.
_RAM_C781_plyr2stats? dw ;On FF for both value, the enemy starts with powerpill, and 4 starts of knockouts, so this is related to it.
_RAM_C783_ db ;This is some temp storage, used in a few places, but mostly with player stats, HP and such.
_RAM_C784_plyr2KnockDown db
_RAM_C785_plyr2Life db
_RAM_C786_forkliftVictoryPose db ;Stops the forklift with the player going up, at the end of the assesment of the match. This is a counter,hitting 00 will initiate the victory pose of the character. 
_RAM_C787_unused? dw ;This was only written once, but not again, so it is likely unused.
.ende

.enum $C78C export
_RAM_C78C_ db ;Increasing this value will hit player 1 randomly.
_RAM_C78D_unused? db ;This is written to, but not read from, anytime the variable is mentioned.
.ende

.enum $C792 export ;Changing these values will determine the enemy's agressivity and willingness to hit you. If you put these to zero, the enemy will never hit you, just circle around.
_RAM_C792_chaseDistance? db ;This changes how the enemy chases you, the bigger the number, the less the distance.
_RAM_C793_mneAgressivity1? db
_RAM_C794_mneRetreatDistance? db ;Lowering this value will increase the distance the emeny goes away after a certain amount of hits. Normally they go back and give you some breathing room.
_RAM_C795_ db ;I guess these are signed values. This one does not do anything significant.
.ende

.enum $C79A export
_RAM_C79A_enemyBlindness? db ;If this is set to 00, the enemy does not find you, like he's blind, and goes around hitting the air. Anything not 00 is considered normal?
_RAM_C79B_unused? dw ;Does not do anythin when frozen or changed during a match.
_RAM_C79D_dataPointer? dsb $30 ;48 byte, the start address is a pointer, things get copied here.
_RAM_C7CD_pointer? db ;This is a pointer, but if frozen, nothing happens, but gets overwritten, so it is used for something.
.ende

.enum $C7D1 export
_RAM_C7D1_pointer? db ;This is near the previous one, used as a pointer.
.ende

.enum $C7D5 export
_RAM_C7D5_indexingPointer? db ;Used for indexing mostly.
.ende

.enum $C7E0 export
_RAM_C7E0_indexPointer? db ;This is also used for indexes (ix).
.ende

.enum $C7EB export
_RAM_C7EB_forkliftHeight db ;Player's height on the forklift at the end of match assesment.
_RAM_C7EC_counter? db	;This is used as a counter is many places.
_RAM_C7ED_plyr1ForkliftSprite db
_RAM_C7EE_counter? db ;Used for the forklift parts as some counter.
_RAM_C7EF_ dw
_RAM_C7F1_ dw
_RAM_C7F3_ dw
_RAM_C7F5_ dw
_RAM_C7F7_ dsb $10 ;Not used, at least nothing is written to it, or changed during gameplay.
_RAM_C807_lastHiscoreEntryFirstByte dsb $e ;Get 15 bytes for the last highscore entry.
_RAM_C815_lastHiscoreEntryLastByte db ;The last byte of this 15 byte table.
.ende

.enum $C825 export
_RAM_C825_OnhiScoreTable dsb $e ;15 bytes In the highscore list, near the third name. Not referenced anywhere.
.ende

.enum $C8B7 export
_RAM_C8B7_showSpriteHScore db
_RAM_C8B8_horizontalScrolltitlescrn db ;Also used for the high score name entry screen to mark where the cursor is.
.ende

.enum $C8BA export
_RAM_C8BA_highscoreNamePosSprite db ;This controls the red sprite, and the current character position on the high score name entry screen.
.ende

.enum $C8BE export
_RAM_C8BE_CanWeMoveTheCursor? db ;If this is set to a non-zero value, the letter select cursor won't move.
_RAM_C8BF_EnteredHighScoreName dsb $d ;This is the name we enter into the highscore name table.
_RAM_C8CC_hiscoreLastChar db ;Somehow, the last character is checked in the code.
.ende

.enum $C8CE export
_RAM_C8CE_ db ;This is some temp storage value.
_RAM_C8CF_ db
_RAM_C8D0_ db
_RAM_C8D1_markoPuzzle db ;Used in the hidden puzzle part.
.ende

.enum $C8DA export
_RAM_C8DA_markoPuzzle db
.ende

.enum $C901 export ;These are maybe the slider puzzle's variables.
_RAM_C901_puzzleColumnNr db ;Column number where the cursor is.
_RAM_C902_puzzleRowNr db ;Row number for the cursor.
_RAM_C903_animationCounter? db ;The number changes constantly whenever we move the cursor on the puzzle.
_RAM_C904_controllerStatePuzzle db ;Saves what was last used.08-up 04-down 02-left 01-right.
_RAM_C905_markoPuzzleCursor dw ;Smoother movement counter. If frozen, the in-between moves are ignored. The second byte is used for the Y movement.
_RAM_C907_markoPuzzleUnused? db ;When changed, it does nothing.
_RAM_C908_markoPuzzle dw
_RAM_C90A_markoPuzzle dw ;These are related to the puzzle pieces, and how they are arranged.
_RAM_C90C_pointer db
.ende

.enum $C90E export
_RAM_C90E_markoPuzzle dw ;Used along with the below, but does not effect gameplay if frozen. 
_RAM_C910_markoPuzzle dw ;Used in a lot of places, but does not affect gameplay.
.ende

.enum $CB20 export
_RAM_CB20_unused db
_RAM_CB21_unused db
_RAM_CB22_unused db
_RAM_CB23_unused db ;These are used for reset check somehow, but otherwise not used anywhere else.
.ende

.enum $DFB4 export
_RAM_DFB4_ db ;Used for stage data loading in columns.
.ende

.enum $DFEE export
_RAM_DFEE_unused dw
.ende

.enum $FFFB export
MAPPER_3DGLASS_CONTROL db
MAPPER_CARTRAM_CONTROL db
MAPPER_SLOT0_CONTROL db
MAPPER_SLOT1_CONTROL db
MAPPER_SLOT2_CONTROL db
.ende

; Ports
.define _PORT_7E_VCounter $7E
.define Port_PSG $7F
.define Port_VDPData $BE
.define Port_VDPAddressControlPort $BF

; Input Ports
.define Port_VCounter $7E
.define Port_VDPStatus $BF
.define Port_IOPort1 $DC
.define Port_IOPort2 $DD

.BANK 0 SLOT 0
.ORG $0000

_LABEL_0_:
	di ;Disabling interrupts, the code boots here.
	ld sp, $DFEC
	jp MAPPER_INIT

; Data from 7 to 15 (15 bytes)
_DATA_7_:
.db $00 $F3 $7B $D3 $BF $7A $C3 $8B $00 $00 $00 $00 $00 $00 $00

; Data from 16 to 17 (2 bytes)
_DATA_16_: ;This is the starting address for slot 2 mapper code, and it is used there.
.db $80 $00

MAPPER_PAGE2_SUB:
	jp SLOT2_PAGE_SWITCH

; Data from 1B to 37 (29 bytes) These appear to be unused bytes, but not really makes sense as code.
.db $00 $00 $00 $00 $00 $C3 $FA $00 $CD $AB $00 $00 $00 $C3 $91
.dsb 14, $00

_LABEL_38_:
	jp _RAM_C387_	; Code is loaded from _LABEL_7F807_

; Data from 3B to 50 (22 bytes)
.db $2A $EE $DF $7C $B5 $28 $05 $11 $4B $00 $D5 $E9 $DB $BF $DB $C1
.db $D1 $E1 $F1 $00 $FB $C9
;The below interpreted as code:
;_LABEL_3B_:	
;		ld hl, (_RAM_DFEE_) ;This piece of code uses this address, which otherwise seems to be unused.
;		ld a, h
;		or l
;		jr z, +
;		ld de, ++	; Overriding return address
;		push de
;		jp (hl)
	
;+:	
;		in a, (Port_VDPStatus)
;		in a, (_PORT_C1_)
;++:	
;		pop de
;		pop hl
;		pop af
;		nop
;		ei
;		ret
	
;+:	
;		push af
;		ld a, (_DATA_16_)
;		or e
;		ld (_RAM_FFFF_), a
;		pop af
;		ret
;It kinda seems valid to be, but this is not executed at all.




SLOT2_PAGE_SWITCH:
	push af	;Save register values on the stack.
	ld a, (_DATA_16_)
	or e	;Read a byte, and OR it with the page number received.
	ld (MAPPER_SLOT2_CONTROL), a ;Send command to mapper.
	pop af	;Retrieve value from stack.
	ret		;Go back, we are finished.

; Data from 5B to 65 (11 bytes)
.db $F5 $DB $B1 $FB $F1 $C9 $02 $00 $00 $00 $00
;Interpreted as code is:
;_LABEL_5B_:	
;		push af ;Push a value to the stack.
;		in a, (_PORT_B1_) ;Read a port. Init some external device?
;		ei ;Enable interrupts.
;		pop af ;Get back a.
;		ret ;Return.
	
;_LABEL_61_:	
;		ld (bc), a
;		nop
;		nop
;		nop
;		nop
;The first makes some sense, but the second doesn't.


_LABEL_66_:
	jp _LABEL_13AF_AdditionalpauseRoutine?
;This below is not used anywhere.
; Data from 69 to 14F (231 bytes)
.db $00 $22 $85 $00 $31 $8B $00 $F5 $E1 $DB $DD $CB $67 $CA $00 $00
.db $E5 $F1 $2A $85 $00 $ED $7B $87 $00 $C3 $FA $00 $00 $00 $00 $00
.db $00 $00 $F6 $40 $D3 $BF $FB $C9 $F5 $E5 $21 $FF $FF $7E $F5 $3E
.db $CE $77 $C5 $3A $23 $01 $E6 $01 $4F $3A $02 $80 $E6 $01 $B9 $C1
.db $20 $25 $21 $61 $00 $35 $20 $1F $36 $02 $3A $14 $00 $B7 $28 $09
.db $32 $FF $FF $F1 $32 $15 $00 $18 $04 $F1 $32 $FF $FF $3E $01 $32
.db $13 $00 $E1 $F1 $C3 $FA $00 $F1 $32 $FF $FF $E1 $F1 $C9 $3A $FF
.db $FF $32 $F6 $00 $3E $CE $32 $FF $FF $3E $93 $32 $03 $80 $3E $FF
.db $32 $00 $80 $3E $80 $32 $02 $80 $AF $32 $23 $01 $3E $82 $32 $FF
.db $FF $F3 $22 $8F $03 $ED $73 $93 $03 $E1 $22 $91 $03 $E1 $22 $62
.db $00 $E5 $31 $8F $03 $D5 $C5 $D9 $E5 $D5 $C5 $DD $E5 $FD $E5 $F5
.db $ED $57 $67 $ED $5F $6F $E5 $08 $F5 $16 $00 $01 $4F $00 $2A $91
.db $03 $A7 $ED $42 $20 $06 $2A $62 $00 $22 $91 $03 $21 $13 $00 $7E
.db $B7 $28 $05 $FA $47 $03 $36 $FF $CD $D1 $02 $7B $FE $01 $38 $0D
.db $FE $20 $30 $10 $32 $B2 $00
;The above interpreted as code has some valid parts, but the second half is a mess. A more experienced z80 programmer 
;could decipher it.


; Data from 150 to 1F3 (164 bytes)
_DATA_150_:
.db $32 $61 $00 $C3 $35 $01 $7E $B7 $CA $47 $03 $AF $77 $7B $FE $B4
.db $28 $5C $FE $BA $CA $93 $02 $FE $B8 $CA $13 $02 $FE $B9 $CA $35
.db $02 $FE $B7 $28 $6E $FE $B6 $CA $3D $02 $FE $B5 $28 $2C $FE $BB
.db $28 $59 $FE $C9 $20 $AF $3A $FF $FF $E6 $7F $32 $FF $FF $21 $A1
.db $04 $11 $00 $C0 $01 $00 $10 $ED $B0 $3A $FF $FF $F6 $80 $32 $FF
.db $FF $31 $F0 $DF $CD $FA $C1 $C3 $00 $C0 $CD $D1 $02 $63 $CD $D1
.db $02 $6B $22 $CC $02 $21 $00 $CD $22 $CA $02 $C3 $A9 $02 $CD $D1
.db $02 $63 $CD $D1 $02 $6B $CD $D1 $02 $43 $CD $D1 $02 $4B $CD $D1
.db $02 $73 $23 $0B $78 $B1 $20 $F6 $C3 $35 $01 $21 $91 $03 $01 $02
.db $00 $18 $36 $CD $D1 $02 $21 $13 $00 $7E $B7 $28 $18 $23 $7B $B7
.db $F2 $F7 $01 $AF

; Data from 1F4 to 315 (290 bytes)
_DATA_1F4_:
.db $77 $18 $19 $F6 $80 $77 $23 $7E $B7 $20 $06 $3A $FF $FF $77 $18
.db $0B $23 $36 $00 $7B $F6 $80 $E6 $BF $32 $FF $FF $C3 $35 $01 $21
.db $7B $03 $01 $1A $00 $3A $FF $FF $F5 $3E $CE $32 $FF $FF $3E $81
.db $32 $03 $80 $7A $EE $81 $F6 $40 $32 $02 $80 $F1 $32 $FF $FF $18
.db $18 $21 $7B $03 $01 $1A $00 $18 $91 $CD $D1 $02 $63 $CD $D1 $02
.db $6B $CD $D1 $02 $43 $CD $F4 $02 $4B $3A $FF $FF $32 $60 $02 $3E
.db $CE $32 $FF $FF $3A $02 $80 $AA $0F $38 $F9 $3E $82 $32 $FF $FF
.db $7A $EE $41 $57 $7E $CD $1F $03 $23 $0B $78 $B1 $20 $F6 $3A $FF
.db $FF $32 $8C $02 $3E $CE $32 $FF $FF $3E $93 $32 $03 $80 $7A $EE
.db $40 $32 $02 $80 $EE $80 $57 $3E $00 $32 $FF $FF $C3 $35 $01 $CD
.db $D1 $02 $6B $CD $D1 $02 $63 $22 $CA $02 $CD $D1 $02 $6B $CD $D1
.db $02 $63 $22 $CC $02 $AF $32 $13 $00 $7A $32 $23 $01 $F1 $08 $E1
.db $7C $ED $47 $7D $ED $4F $F1 $FD $E1 $DD $E1 $C1 $D1 $E1 $D9 $C1
.db $D1 $E1 $ED $7B $93 $03 $00 $00 $00 $00 $C3 $FA $00 $3A $FF $FF
.db $32 $EF $02 $3E $CE $32 $FF $FF $3A $02 $80 $AA $0F $38 $F9 $3A
.db $00 $80 $5F $7A $32 $02 $80 $EE $81 $57 $3E $82 $32 $FF $FF $C9
.db $3A $FF $FF $32 $1A $03 $3E $CE $32 $FF $FF $3A $02 $80 $AA $0F
.db $38 $F9 $3A $00 $80 $5F $3E $81 $32 $03 $80 $7A $F6 $40 $32 $02
.db $80 $7A

; 6th entry of Pointer Table from 2E85 (indexed by unknown)
; Data from 316 to 331 (28 bytes)
_DATA_316_: ;Used with the match card in another pointer table.
.db $EE $81 $57 $3E $82 $32 $FF $FF $C9 $32 $2E $03 $3A $FF $FF $32
.db $42 $03 $3E $CE $32 $FF $FF $3E $3E $32 $00 $80

; 2nd entry of Pointer Table from 2E85 (indexed by unknown)
; Data from 332 to 394 (99 bytes)
_DATA_332_:
.db $7A $32 $02 $80 $7A $EE $81 $57 $3A $02 $80 $AA $0F $30 $F9 $3E
.db $82 $32 $FF $FF $C9 $AF $32 $13 $00 $3A $15 $00 $B7 $28 $07 $32
.db $FF $FF $AF $32 $15 $00 $7A $32 $23 $01 $DB $B1 $F1 $08 $E1 $7C
.db $ED $47 $7D $ED $4F $F1 $FD $E1 $DD $E1 $C1 $D1 $E1 $D9 $C1 $D1
.db $E1 $ED $7B $93 $03 $FB $C9 $6C $02 $FF $82 $1D $00 $44 $82 $FB
.db $FF $FF $BF $00 $02 $59 $C4 $CD $AB $00 $00 $18 $13 $02 $07 $BE
.db $00 $EC $DF

MAPPER_INIT:
	xor a ;Nulling out a.
	im 1 ;Setting interrupt mode 1.
	ld (MAPPER_CARTRAM_CONTROL), a
	ld (MAPPER_SLOT0_CONTROL), a
	inc a
	ld (MAPPER_SLOT1_CONTROL), a
	inc a
	ld (MAPPER_SLOT2_CONTROL), a ;Setting up the first three banks, and turning off not needed things.
	in a, (Port_VDPStatus)		 ;Clear VDP status flag.
	ld hl, $0000
	ld (_RAM_DFEE_unused), hl			 ;Loads zero here, watchpoint added, but so far nothing really uses it.
	ld a, (_DATA_7_)
	or a
	jp nz, SKIP_MESS ;Loads a 0 from that table, since it's not zero, this mess below will be executed.
					 ;This will be always zero,and the jump won't be taken.
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
	ld l, d
	xor b
SKIP_MESS: ;No idea what this is for, at all. Maybe waiting for the VDP to warm up?
	jp INIT_VDP
;The below is a bunch of VDP related code, but I can't make heads or tails out of it. It seems valid tho.
; Data from 403 to 499 (151 bytes)
.db $CD $00 $21 $3A $2A $C1 $E6 $01 $20 $08 $3A $2B $C1 $E6 $0F $32
.db $52 $C1 $3A $2A $C1 $3C $32 $2A $C1 $3A $52 $C1 $FE $07 $20 $06
.db $CD $23 $06 $C3 $76 $06 $3A $52 $C1 $FE $0B $20 $06 $CD $5A $06
.db $C3 $84 $06 $3A $52 $C1 $FE $0D $20 $2B $CD $DD $05 $3A $28 $C1
.db $CB $3F $CB $3F $CB $3F $E6 $1F $87 $5F $16 $00 $21 $98 $20 $19
.db $7E $23 $66 $6F $22 $53 $C1 $11 $D8 $00 $2A $18 $C1 $19 $ED $5B
.db $16 $C1 $C3 $8E $06 $3A $52 $C1 $FE $0E $20 $28 $CD $8E $05 $3A
.db $28 $C1 $CB $3F $CB $3F $CB $3F $3C $E6 $1F $87 $5F $16 $00 $21
.db $98 $20 $19 $7E $23 $66 $6F $22 $53 $C1 $2A $18 $C1 $ED $5B $16
.db $C1 $C3 $8E $06 $3A $52 $C1

; Data from 49A to 50F (118 bytes)
_DATA_49A_:
.db $FE $09 $20 $38 $CD $DD $05 $CD $5A $06 $3A $2A $C1 $E6 $01 $20
.db $28 $3A $28 $C1 $CB $3F $CB $3F $CB $3F $E6 $1F $87 $5F $16 $00
.db $21 $98 $20 $19 $7E $23 $66 $6F $22 $53 $C1 $11 $D8 $00 $2A $18
.db $C1 $19 $ED $5B $16 $C1 $C3 $8E $06 $C3 $84 $06 $3A $52 $C1 $FE
.db $05 $20 $38 $CD $DD $05 $CD $23 $06 $3A $2A $C1 $E6 $01 $20 $28
.db $3A $28 $C1 $CB $3F $CB $3F $CB $3F $E6 $1F $87 $5F $16 $00 $21
.db $98 $20 $19 $7E $23 $66 $00 $08 $04 $0C $02 $0A $06 $0E $01 $09
.db $05 $0D $03 $0B $07 $0F

; Data from 510 to 52F (32 bytes)
FULL_BLACK_PALETTE_DATA:
.dsb 32, $00 ;Used in several places for clearing palettes.

LOAD_BOTH_PALETTES:
	ld (_RAM_C365_paletteTemp), hl	;Save the address, what was passed onto this routine. HL will hold the source address of the palette in ROM.
	ld c, Port_VDPAddressControlPort
	xor a
	out (c), a
	ld a, $C0
	nop
	nop
	out (c), a
	ld c, Port_VDPData
	ld b, $20
-:
	outi
	jr nz, -
	ret

_LABEL_547_updateBGPal:;Updates only a single palette.(Background, it seems.) HL needs to be loaded with the source address.
	ld c, Port_VDPAddressControlPort
	ld a, $10 ;16 (Maybe palette?) 0001 0000
	out (c), a ;Write the first byte to the VDP control port.
	ld a, $C0 ;1100 0000 will be written to the Control Port.(Color RAM.)
	nop
	nop
	out (c), a
	ld c, Port_VDPData
	ld b, $10
-:
	outi
	jr nz, -
	ret

_LABEL_55C_delay+pal?: ;I think I have seen this one during the intro...
	ld a, (_RAM_C400_delay) ;Grab a value from RAM.
	push af	;Push these to the stack.
	xor a ;Zero out the acc.
	ld (_RAM_C400_delay), a ;Zero out this address?
	ld hl, (_RAM_C365_paletteTemp)
	ld de, _RAM_start
	ld bc, $0020
	ldir ;Move 32 bytes from RAM to the beginning.
	ld b, $04 ;Load this
---:
	push bc ;Save this later on the stack.
	call _LABEL_5D0_delay? ;Delay again.
	ld b, $06
--:
	xor a ;Zero out the acc,
	ld (_RAM_C3A2_timerml), a ;Then push it to RAM.
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, $0000
	ld de, $0000
	ld bc, $012C
	ldir ;Write 300 bytes, from ROM...TO ROM. Definetly some delay here.
	ld hl, _RAM_start
	call LOAD_BOTH_PALETTES
	pop bc
	djnz ---
	pop af
	ld (_RAM_C400_delay), a
	ret
	;This one definetly delays, then changes palettes, which are stored at the very beginning of RAM.

_LABEL_59C_delay+pal?:
;This one seems to update the BG palette based on a timer again, yet this is for 32 colors?
	ld hl, (_RAM_C365_paletteTemp)
	ld de, _RAM_start
	ld bc, $0020
	ldir
	ld b, $04
---:
	push bc
	call _LABEL_5D0_delay?
	ld b, $06
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, $0000
	ld de, $0000
	ld bc, $012C
	ldir			;This is a delay again. I guess to show the Warrior, then wait, and fade the screen out.
	ld hl, _RAM_C010_MNEStays
	call _LABEL_547_updateBGPal
	pop bc
	djnz ---
	ret

_LABEL_5D0_delay?: ;This is some sort of timer, or setting delays...
	ld b, $20 ;Load 32 into b, as a counter.
	ld hl, _RAM_start
_LABEL_5D5_paletteCopyThing:
	push bc ;Push the register values on the stack.
	ld c, (hl) ;This is the source, usually it's the start of the RAM, but not always.
	ld a, c ;So, read a byte from the source, and put it into c.
	and $30	;0011 0000
	jr z, +	;Is it $30?
	ld a, c
	sub $10
	ld c, a
+:	;The byte is $30.
	ld a, c
	and $0C
	jr z, +	;Is it 12?
	ld a, c
	sub $04
	ld c, a
+:
	ld a, c
	and $03
	jr z, +
	dec c
+:
	ld (hl), c
	inc l
	pop bc
	djnz _LABEL_5D5_paletteCopyThing ;This has to loop 32 times.
	ret

_LABEL_5F5_timer+pal?:
	ld a, (_RAM_C400_delay)
	push af
	xor a
	ld (_RAM_C400_delay), a
	push hl
	ld de, _RAM_C020_palTemp
	ld bc, $0020
	ldir
	ld b, $04
---:
	push bc
	ld a, b
	ld hl, _RAM_C020_palTemp
	ld de, _RAM_start
	ld bc, $0020
	ldir
-:
	push af
	call _LABEL_5D0_delay?
	pop af
	dec a
	jr nz, -
	ld b, $06
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, $0000
	ld de, $0000
	ld bc, $012C
	ldir
	ld hl, _RAM_start
	call LOAD_BOTH_PALETTES
	pop bc
	djnz ---
	ld b, $06
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, $0000
	ld de, $0000
	ld bc, $012C
	ldir
	ld hl, _RAM_C020_palTemp
	call LOAD_BOTH_PALETTES
	pop hl
	ld (_RAM_C365_paletteTemp), hl
	pop af
	ld (_RAM_C400_delay), a
	ret

_LABEL_667_delay+bgpal?:
	push hl
	ld de, _RAM_C020_palTemp
	ld bc, $0020
	ldir
	ld b, $04
---:
	push bc
	ld a, b
	ld hl, _RAM_C020_palTemp
	ld de, _RAM_start
	ld bc, $0020
	ldir
-:
	push af
	call _LABEL_5D0_delay?
	pop af
	dec a
	jr nz, -
	ld b, $06
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, $0000
	ld de, $0000
	ld bc, $012C
	ldir
	ld hl, _RAM_start
	call _LABEL_547_updateBGPal
	pop bc
	djnz ---
	ld b, $06
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, $0000
	ld de, $0000
	ld bc, $012C
	ldir
	ld hl, _RAM_C020_palTemp
	call _LABEL_547_updateBGPal
	pop hl
	ld (_RAM_C365_paletteTemp), hl
	ret

_LABEL_6CD_tilemap_clear:
	ex af, af'
	ld c, Port_VDPAddressControlPort
	ld a, $00
	out (c), a
	nop
	nop
	nop
	ld a, $7F ;127 0111 1111
	out (c), a ;This is a VRAM write.
	nop
	nop
	nop
	ld a, $D0 ;1101 0000
	out (Port_VDPData), a
	ex af, af'
	nop
	nop
	nop
	ld a, $00
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $89 ;10 00 1001 Register write.
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld hl, _RAM_start
	ld de, _RAM_start + 1
	ld (hl), $00
	ld bc, $001F
	ldir ;Fill the start of the RAM with zeroes. 31 bytes.
	ld hl, _RAM_start
	ld de, $0000
	ld bc, $0020
	call _LABEL_7EF_VDPdataLoad ;Load the very first empty tile into VRAM.
	ld bc, $06FF ;This load is used below, as some counter. 
	;1791 bytes for the tilemap.So this clears the tilemap!
	ex af, af' ;Get back the values from the shadow registers.
	ld c, Port_VDPAddressControlPort
	ld a, $00
	out (c), a
	nop
	nop
	nop
	ld a, $78 ;0111 1000 
	;Setup for a vram address write, for 1110 0000 0000 00, 
	;which is $3800 Looks like we've hit a tile loader, but this loads zeroes.
	out (c), a
	nop
	nop
	nop
	ld a, $00
	out (Port_VDPData), a
	ex af, af'
	nop
	nop
	nop
-:
	push bc
	ld a, $00
	out (Port_VDPData), a
	nop
	nop
	nop
	pop bc
	dec bc
	ld a, b
	or c
	jr nz, -
	ret
	;This clears the tilemap completely.
_LABEL_737_clearTilesplusfirst256bytes:
	ld bc, $37FF ;14335 is loaded. This is the maximum amount of tiles supported by the VDP.
	ex af, af'
	ld c, Port_VDPAddressControlPort
	ld a, $00
	out (c), a
	nop
	nop
	nop
	ld a, $40
	out (c), a
	nop
	nop
	nop
	ld a, $00
	out (Port_VDPData), a
	ex af, af'
	nop
	nop
	nop
-:
	push bc
	ld a, $00
	out (Port_VDPData), a
	nop
	nop
	nop
	pop bc
	dec bc
	ld a, b
	or c
	jr nz, - ;The above does clear the whole pattern table in VRAM.
	ld hl, _RAM_start
	ld de, _RAM_start + 1
	ld (hl), $00
	ld bc, $00FF
	ldir
	ret ;We also clear the first 256 bytes of RAM.

_LABEL_76F_timerBasedVDPDL:
	xor a ;Zero the Acc out.
	ld (_RAM_C3A2_timerml), a ;Clear a timer in RAM.
-:
	ld a, (_RAM_C3A2_timerml) ;Fetch the timer's value. My guess that this number is updated during VBLANK, otherwise this would always branch?
	or a
	jr z, -
	ex af, af'
	ld c, Port_VDPAddressControlPort
	ld a, $00
	out (c), a
	nop
	nop
	nop
	ld a, $7F ;This is a VRAM write. The whole command is:'11 1111 0000 0000' F00 in HEX, 3840 in decimal
	out (c), a
	nop
	nop
	nop
	ld a, $D0 ;1101 0000 Write to Color RAM. First color I presume.
	out (Port_VDPData), a ;Load black? 
	ex af, af'
	nop
	nop
	nop
	xor a ;Zero A.
	ld (_RAM_C338_howmanyspronscrn), a ;Load 0 into some timer variable?
	ld hl, _RAM_start
	ld de, _RAM_start + 1
	ld bc, $001F
	ld (hl), $00
	ldir				;Clear the first 32 bytes in RAM.
	ld hl, _RAM_start
	ld de, $0000
	ld bc, $0020 
	call _LABEL_7EF_VDPdataLoad ;Tile/map base unit creation.
	push af
	ld a, $00
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $38 ;00 1110 0000 0000 00
	or $40
	out (Port_VDPAddressControlPort), a
	pop af
	ld hl, $3800
	ld bc, $0700 ;Set this to 1792 bytes (56 tiles) TILEMAP!
--:
	in a, (Port_VCounter) ;Fetch the current scanline.
	cp $B0 ;Is it 176?
	jr c, + ;If the carry flag is set, jump out to +.
	xor a ;Clear this timer?
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, - ;If the value is zero, jump back. This is definetly a delay part.
-:
	in a, (Port_VCounter)
	cp $B0
	jr nc, - ;Check again, and if the scanline is not 176, loop back.
	push af
	ld a, l ;Load 00 intro a. ()
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, h
	or $40
	out (Port_VDPAddressControlPort), a
	pop af
+:
	xor a
	out (Port_VDPData), a
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, --
	ret ;This is some sort of scanline marked VDP data loading, but not really clear what it does at the moment.

_LABEL_7EF_VDPdataLoad: 
	ld a, e
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, d
	or $40 ;0100 0000 This will be a VRAM data write.
	out (Port_VDPAddressControlPort), a
-:
	ld a, (hl)
	out (Port_VDPData), a
	nop
	nop
	nop
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, -
	ret

_LABEL_806_loadTiles:
	xor a
	ld (_RAM_C3A2_timerml), a	;Reset the counter.
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld a, e
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, d
	or $40
	out (Port_VDPAddressControlPort), a	;Setup write to vram.
--:
	in a, (Port_VCounter)	;Read the Vertical counter.
	cp $B0					;Compare with a scanline number.
	jr c, +					;Jump to + is current scanline is less than 176.
	xor a					
	ld (_RAM_C3A2_timerml), a	;Otherwise clear the timer. We did nothing with the VRAM thing yet.
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
-:
	in a, (Port_VCounter)
	cp $B0
	jr nc, -	;Wait until we hit scanline 176.
	ld a, e
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, d
	or $40
	out (Port_VDPAddressControlPort), a	;Setup a write again.
	nop
	nop
	nop
+:
	ld a, (hl)
	out (Port_VDPData), a
	inc de
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, --
	ret

_LABEL_848_timerAndVDPThing:
	ld c, (hl)
	inc hl
	ld b, (hl)
	inc hl	;Read two bytes from the source address, but not used yet.
_LABEL_84C_timerAndVDPThingy:
	ld a, (_RAM_C363_)
	or a
	jr z, + ;Check this value, and jump if it's zero.
	push bc	;Else save the values we just read from the source.
	ld b, $04
--:	;If the timer is not expired, just continue as usual.
	xor a
	ld (_RAM_C3A2_timerml), a	;Reset this timer.
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -	;Loop back if A is zero. I suspect this timer is updated during VBlank.
	djnz --	;Jump back if B is not zero.
	pop bc	;Get back the values from Stack.
+:
	ld a, (hl)
	or a
	ret z	;Read the third byte, if it's zero, then return.
	cp $0D	
	jr z, +++	;If this is 13, jump ahead.
	cp $01
	jp nz, ++
	inc hl
	ld a, (hl)
	or a
	jr nz, +
	inc c
	inc hl
	jp _LABEL_84C_timerAndVDPThingy	;Go back, so this is a nice loop there.

+:	;Increase the source data pointer.
	ld c, a
	inc hl
	jp _LABEL_84C_timerAndVDPThingy	;Then return to the main part of the loop.

++:
	push bc
	push hl
	call +++++	;Save these values, and do some video updates.
	pop hl
	pop bc
	inc c
	ld e, $20
	ld a, (_RAM_C3A4_)
	or a
	jr z, +
	ld e, $20
+:
	ld a, c
	cp e
	jr nz, ++++
+++:
	ld a, (_RAM_C3A4_)
	ld c, a
	inc b
	ld a, b
	cp $18
	jr nz, ++++
	ld b, $00
++++:
	inc hl
	jp _LABEL_84C_timerAndVDPThingy

+++++:
	ex af, af'
	sla b
	sla b
	sla b
	ld h, $00
	ld l, b
	add hl, hl
	add hl, hl
	add hl, hl
	sla c
	ld a, l
	or c
	out (Port_VDPAddressControlPort), a
	ld a, h
	add a, $38
	or $40
	out (Port_VDPAddressControlPort), a
	ex af, af'
	ld l, a
	ld a, (_RAM_C362_hudTileOffset)
	add a, l
	nop
	out (Port_VDPData), a
	nop
	nop
	ld a, $08
	out (Port_VDPData), a
	ret

_LABEL_8CD_READ_JOYPAD:
	in a, (Port_IOPort1) ;Read from joypad 1.
	cpl					 ;Invert what we just read, now 1 means pressed, and not 0.
	call +
	call ++
	ld (_RAM_C393_JOYPAD1), a
	ld a, c
	rlca
	rlca
	and $03
	ld c, a
	in a, (Port_IOPort2)
	cpl
	and $0F
	add a, a
	add a, a
	or c
	call +
	call ++
	ld (_RAM_C394_JOYPAD2), a
	ret

+:
	ld c, a ;Move it to c.
	and $0F ;
	ld l, a
	ld h, $05
	ld a, c
	and $30
	or (hl)
	ret

++:
	ld e, a
	and $03
	cp $03
	jr z, +
	ld a, e
	and $0C
	cp $0C
	jr z, +
	ld a, e
	and $3F
	ret

+:
	xor a
	ret

; Data from 910 to 919 (10 bytes)
_DATA_910_:
.db $10 $27 $E8 $03 $64 $00 $0A $00 $01 $00

_LABEL_91A_plyr1ScoreUpdate?:	;This is executed at the high score part of the title screen sequence, and during gameplay.
	;What is not clear to me yet, is that where in the gameplay part is the vertical scroll used?
	;But, this is definetly some timed scroll routine.
	;On the title screen sequence, this is used in some timing routine. I mean the score value.
	ld (_RAM_C370_verticalScroll), hl
	ld hl, _RAM_C100_plyr1Score
	ld de, _RAM_C100_plyr1Score + 1
	ld a, (_RAM_C364_scoreLetterOffset);This offset is a VRAM tile offset for the score.
	ld (hl), a
	ld bc, $0004
	ldir	;Move five bytes, sooo C100 might be the score value? Yes it is!
	xor a
	ld (de), a
	dec a
	ld (_RAM_C372_timer?), a	;Set this timer to 255.
--:
	ld a, (_RAM_C372_timer?)
	inc a	;Get back the timer value.
	cp $06
	ret z	;If it's zero, then return from the routine.
	ld (_RAM_C372_timer?), a
	sla a	;Move the last bit to carry.
	ld e, a
	ld d, $00
	ld hl, _DATA_910_
	add hl, de
	ld c, (hl)
	inc hl
	ld b, (hl)
-:
	ld hl, (_RAM_C370_verticalScroll)
	ld a, h
	cp b
	jr nz, +
	ld a, l
	cp c
+:
	jr c, --
	sbc hl, bc
	ld (_RAM_C370_verticalScroll), hl
	ld a, (_RAM_C372_timer?)
	ld e, a
	ld d, $00
	ld hl, $C100
	add hl, de
	inc (hl)
	jp -	

_LABEL_966_plyrScore:	
	push bc
	push af
	call _LABEL_91A_plyr1ScoreUpdate?
	pop af
	ld b, a
	ld hl, _RAM_C100_plyr1Score
	or a
	jr z, +
	ld a, (_RAM_C364_scoreLetterOffset)
	ld c, a
-:
	ld a, (hl)
	cp c
	jr nz, +
	inc hl
	djnz -
+:
	pop bc
	call _LABEL_84C_timerAndVDPThingy
	ret

_LABEL_983_:	;This is executed with the crowd animation, and other part, but I don't know what it does exactly.
	push bc
	push hl
	ld a, (_RAM_C382_)
	ld c, a
	ld h, a
	ld b, $00
	ld l, b
	and a
	sbc hl, bc
	sbc hl, bc
	ld bc, $00FE
	add hl, bc
	ld a, l
	sub h
	ld h, a
	ld a, r
	add a, h
	ld (_RAM_C382_), a
	jr c, +
	dec a
	ld (_RAM_C382_), a
+:
	pop hl
	pop bc
	ret
;The below is not tile data, or anything that is accessed by the code so far.
;It is not valid code as per emulicous' disassembler. If it's not really used, then we have 344 bytes of stuff to
;do.
; Data from 9A8 to AFF (344 bytes)
.db $CB $27 $CB $27 $CB $27 $80 $5F $16 $00 $19 $7E $57 $1E $00 $3A
.db $3A $C1 $32 $FF $FF $2A $38 $C1 $19 $3A $2C $C1 $47 $3A $2D $C1
.db $CB $27 $CB $27 $CB $27 $CB $27 $80 $5F $16 $00 $19 $5E $2A $40
.db $C1 $19 $EB $3A $2E $C1 $1F $30 $04 $14 $14 $14 $14 $3A $42 $C1
.db $32 $FF $FF $2A $30 $C1 $1A $77 $2C $14 $1A $77 $2C $14 $1A $77
.db $2C $14 $1A $77 $2C $22 $30 $C1 $00 $80 $40 $C0 $20 $A0 $60 $E0
.db $10 $90 $50 $D0 $30 $B0 $70 $F0 $08 $88 $48 $C8 $28 $A8 $68 $E8
.db $18 $98 $58 $D8 $38 $B8 $78 $F8 $04 $84 $44 $C4 $24 $A4 $64 $E4
.db $14 $94 $54 $D4 $34 $B4 $74 $F4 $0C $8C $4C $CC $2C $AC $6C $EC
.db $1C $9C $5C $DC $3C $BC $7C $FC $02 $82 $42 $C2 $22 $A2 $62 $E2
.db $12 $92 $52 $D2 $32 $B2 $72 $F2 $0A $8A $4A $CA $2A $AA $6A $EA
.db $1A $9A $5A $DA $3A $BA $7A $FA $06 $86 $46 $C6 $26 $A6 $66 $E6
.db $16 $96 $56 $D6 $36 $B6 $76 $F6 $0E $8E $4E $CE $2E $AE $6E $EE
.db $1E $9E $5E $DE $3E $BE $7E $FE $01 $81 $41 $C1 $21 $A1 $61 $E1
.db $11 $91 $51 $D1 $31 $B1 $71 $F1 $09 $89 $49 $C9 $29 $A9 $69 $E9
.db $19 $99 $59 $D9 $39 $B9 $79 $F9 $05 $85 $45 $C5 $25 $A5 $65 $E5
.db $15 $95 $55 $D5 $35 $B5 $75 $F5 $0D $8D $4D $CD $2D $AD $6D $ED
.db $1D $9D $5D $DD $3D $BD $7D $FD $03 $83 $43 $C3 $23 $A3 $63 $E3
.db $13 $93 $53 $D3 $33 $B3 $73 $F3 $0B $8B $4B $CB $2B $AB $6B $EB
.db $1B $9B $5B $DB $3B $BB $7B $FB $07 $87 $47 $C7 $27 $A7 $67 $E7
.db $17 $97 $57 $D7 $37 $B7 $77 $F7 $0F $8F $4F $CF $2F $AF $6F $EF
.db $1F $9F $5F $DF $3F $BF $7F $FF

_LABEL_B00_spriteHandler?:
;Loads data from ROM to VRAM based on how many sprites left, or how many to draw, depends on how you view it.
;There is a load of instructions like a case statement below, it should work like a Case statement in C.
	ld a, (_RAM_C338_howmanyspronscrn) ;Get the number of sprites shown on screen.(Or, the last sprite to draw.)
_LABEL_B03_:;This label was not used elsewhere.
	or a	;Lose carry.
	jp nz, + ;Jump ahead if we have any sprites on screen.
	ex af, af'
	ld c, Port_VDPAddressControlPort
	ld a, $00
	out (c), a
	nop
	nop
	nop
	ld a, $7F ;0111 1111 A write to VDP RAM 3F00, which is the sprite attribute table.
	out (c), a
	nop
	nop
	nop
	ld a, $D0 ;1101 0000 ;Write to Color RAM.
	out (Port_VDPData), a
	ex af, af'				;This above part checks, if there are any sprites on screen, and if there none,
							;set the background to black, and the last sprite to drawn to zero. Likely at the end of some 
							;screen display routine.(Like when the high-score screen fades out?)
_LABEL_B1D_:;Not used.
	nop
	nop
	nop
	jp _LABEL_DB3_ ;This is just a RET. Why this was used is anyone's guess.

+:					;We have more than one sprites left on screen.
	ld c, a
	ld a, $40		;64
	sub c
	ld c, a			;Get how many sprites are left.
	ex af, af'
	ld a, $80		;1000 0000
	out (Port_VDPAddressControlPort), a
	ld a, $7F		;Write to 1F80, which should be tiles, but at the near end of them.
	out (Port_VDPAddressControlPort), a
	ld b, $00
	ld l, c			;c still has the remaining amount of sprites left.
	ld h, b			;Clear the high byte of HL.
	add hl, hl
	add hl, hl		;Some bitshifting.
	add hl, bc
	ex de, hl
	ld ix, $0B46
	add ix, de
	ld c, $BE
	ld hl, $C10A
	jp (ix)			;This is some nifty VDP write, it loads tiles into the sprite part of the VRAM, I may be wrong on this.
					;But it looks like some kind of Case statement in C or similar languages.

_LABEL_B46_:;Oh boy..
	outi
	outi
	inc l
	outi
	outi
	inc l
	outi
	outi
	inc l
	outi
	outi
	inc l
	outi
	outi
	inc l
	outi
	outi
_LABEL_B63_:
	inc l
	outi
_LABEL_B66_:
	outi
	inc l
	outi
	outi
	inc l
	outi
_LABEL_B70_:
	outi
_LABEL_B72_:
	inc l
_LABEL_B73_:
	outi
_LABEL_B75_:
	outi
_LABEL_B77_:
	inc l
_LABEL_B78_:
	outi
_LABEL_B7A_:
	outi
_LABEL_B7C_:
	inc l
_LABEL_B7D_:
	outi
_LABEL_B7F_:
	outi
_LABEL_B81_:
	inc l
_LABEL_B82_:
	outi
_LABEL_B84_:
	outi
_LABEL_B86_:
	inc l
_LABEL_B87_:
	outi
_LABEL_B89_:
	outi
_LABEL_B8B_:
	inc l
_LABEL_B8C_:
	outi
_LABEL_B8E_:
	outi
_LABEL_B90_:
	inc l
_LABEL_B91_:
	outi
_LABEL_B93_:
	outi
_LABEL_B95_:
	inc l
_LABEL_B96_:
	outi
_LABEL_B98_:
	outi
_LABEL_B9A_:
	inc l
_LABEL_B9B_:
	outi
_LABEL_B9D_:
	outi
_LABEL_B9F_:
	inc l
_LABEL_BA0_:
	outi
_LABEL_BA2_:
	outi
_LABEL_BA4_:
	inc l
_LABEL_BA5_:
	outi
_LABEL_BA7_:
	outi
_LABEL_BA9_:
	inc l
_LABEL_BAA_:
	outi
_LABEL_BAC_:
	outi
_LABEL_BAE_:
	inc l
_LABEL_BAF_:
	outi
_LABEL_BB1_:
	outi
_LABEL_BB3_:
	inc l
_LABEL_BB4_:
	outi
_LABEL_BB6_:
	outi
_LABEL_BB8_:
	inc l
_LABEL_BB9_:
	outi
_LABEL_BBB_:
	outi
_LABEL_BBD_:
	inc l
_LABEL_BBE_:
	outi
_LABEL_BC0_:
	outi
_LABEL_BC2_:
	inc l
_LABEL_BC3_:
	outi
_LABEL_BC5_:
	outi
_LABEL_BC7_:
	inc l
_LABEL_BC8_:
	outi
_LABEL_BCA_:
	outi
_LABEL_BCC_:
	inc l
_LABEL_BCD_:
	outi
_LABEL_BCF_:
	outi
_LABEL_BD1_:
	inc l
_LABEL_BD2_:
	outi
_LABEL_BD4_:
	outi
_LABEL_BD6_:
	inc l
_LABEL_BD7_:
	outi
_LABEL_BD9_:
	outi
_LABEL_BDB_:
	inc l
_LABEL_BDC_:
	outi
_LABEL_BDE_:
	outi
_LABEL_BE0_:
	inc l
_LABEL_BE1_:
	outi
_LABEL_BE3_:
	outi
_LABEL_BE5_:
	inc l
_LABEL_BE6_:
	outi
_LABEL_BE8_:
	outi
_LABEL_BEA_:
	inc l
_LABEL_BEB_:
	outi
_LABEL_BED_:
	outi
_LABEL_BEF_:
	inc l
_LABEL_BF0_:
	outi
_LABEL_BF2_:
	outi
_LABEL_BF4_:
	inc l
_LABEL_BF5_:
	outi
_LABEL_BF7_:
	outi
_LABEL_BF9_:
	inc l
_LABEL_BFA_:
	outi
_LABEL_BFC_:
	outi
_LABEL_BFE_:
	inc l
_LABEL_BFF_:
	outi
_LABEL_C01_:
	outi
_LABEL_C03_:
	inc l
_LABEL_C04_:
	outi
_LABEL_C06_:
	outi
_LABEL_C08_:
	inc l
_LABEL_C09_:
	outi
_LABEL_C0B_:
	outi
_LABEL_C0D_:
	inc l
_LABEL_C0E_:
	outi
_LABEL_C10_:
	outi
_LABEL_C12_:
	inc l
_LABEL_C13_:
	outi
_LABEL_C15_:
	outi
_LABEL_C17_:
	inc l
_LABEL_C18_:
	outi
_LABEL_C1A_:
	outi
_LABEL_C1C_:
	inc l
_LABEL_C1D_:
	outi
_LABEL_C1F_:
	outi
_LABEL_C21_:
	inc l
_LABEL_C22_:
	outi
_LABEL_C24_:
	outi
_LABEL_C26_:
	inc l
_LABEL_C27_:
	outi
_LABEL_C29_:
	outi
_LABEL_C2B_:
	inc l
_LABEL_C2C_:
	outi
_LABEL_C2E_:
	outi
_LABEL_C30_:
	inc l
_LABEL_C31_:
	outi
_LABEL_C33_:
	outi
_LABEL_C35_:
	inc l
_LABEL_C36_:
	outi
_LABEL_C38_:
	outi
_LABEL_C3A_:
	inc l
_LABEL_C3B_:
	outi
_LABEL_C3D_:
	outi
_LABEL_C3F_:
	inc l
_LABEL_C40_:
	outi
_LABEL_C42_:
	outi
_LABEL_C44_:
	inc l
_LABEL_C45_:
	outi
_LABEL_C47_:
	outi
_LABEL_C49_:
	inc l
_LABEL_C4A_:
	outi
_LABEL_C4C_:
	outi
_LABEL_C4E_:
	inc l
_LABEL_C4F_:
	outi
_LABEL_C51_:
	outi
_LABEL_C53_:
	inc l
_LABEL_C54_:
	outi
_LABEL_C56_:
	outi
_LABEL_C58_:
	inc l
_LABEL_C59_:
	outi
_LABEL_C5B_:
	outi
_LABEL_C5D_:
	inc l
_LABEL_C5E_:
	outi
_LABEL_C60_:
	outi
_LABEL_C62_:
	inc l
_LABEL_C63_:
	outi
_LABEL_C65_:
	outi
_LABEL_C67_:
	inc l
_LABEL_C68_:
	outi
_LABEL_C6A_:
	outi
_LABEL_C6C_:
	inc l
_LABEL_C6D_:
	outi
_LABEL_C6F_:
	outi
_LABEL_C71_:
	inc l
_LABEL_C72_:
	outi
_LABEL_C74_:
	outi
_LABEL_C76_:
	inc l
_LABEL_C77_:
	outi
_LABEL_C79_:
	outi
_LABEL_C7B_:
	inc l
_LABEL_C7C_:
	outi
_LABEL_C7E_:
	outi
_LABEL_C80_:
	inc l
_LABEL_C81_:
	outi
_LABEL_C83_:
	outi
_LABEL_C85_:
	inc l
_LABEL_C86_:
	xor a
_LABEL_C87_:
	out (Port_VDPAddressControlPort), a
_LABEL_C89_:
	ld a, $7F
_LABEL_C8B_:
	out (Port_VDPAddressControlPort), a
_LABEL_C8D_:
	ex af, af'
_LABEL_C8E_:
	add a, a
_LABEL_C8F_:
	add a, a
_LABEL_C90_:
	ld e, a
_LABEL_C91_:
	ld d, $00
_LABEL_C93_:
	ld ix, $0C9E
_LABEL_C97_:
	add ix, de
_LABEL_C99_:
	ld hl, $C10C
_LABEL_C9C_:
	jp (ix)
;This is also not used, but this is very much like a bunch of palettes, but just repeated bytes, so
;could be just filler.
; Data from C9E to D09 (108 bytes)
.db $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C
.db $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C
.db $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C
.db $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C
.db $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C
.db $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C
.db $ED $A3 $2C $2C $ED $A3 $2C $2C $ED $A3 $2C $2C

_LABEL_D0A_:;Will this ever end?
	outi
	inc l
	inc l
_LABEL_D0E_:
	outi
	inc l
	inc l
_LABEL_D12_:
	outi
	inc l
	inc l
_LABEL_D16_:
	outi
	inc l
	inc l
_LABEL_D1A_:
	outi
	inc l
	inc l
_LABEL_D1E_:
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
_LABEL_D2E_:
	outi
	inc l
	inc l
_LABEL_D32_:
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
_LABEL_D3E_:
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
_LABEL_D56_:
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
_LABEL_D6E_:
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
_LABEL_D86_:
	outi
	inc l
	inc l

_LABEL_D8A_:
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	outi

_LABEL_D94_:
	inc l
	inc l
	outi
	inc l
	inc l
	outi
	inc l
	inc l
	ld a, (_RAM_C338_howmanyspronscrn)
	cp $40

_LABEL_DA3_:
	jr z, +	;Check how many sprites are used, and if we are at the maximum, jump ahead.
	ld a, $D0
	out (c), a

+:	;We used up all sprites, reset the sprite numbers.
	xor a
	ld (_RAM_C338_howmanyspronscrn), a
	ld hl, $C10A
	ld (_RAM_C336_NMESpritePosOnScreen), hl	;Load some pointer up, and return.
_LABEL_DB3_:
	ret

_LABEL_DB4_musicRelatedUNUSED?:
;In the original code, this is not used, and not decoded, but this is definetly right code.
	push af
	in a, (Port_VDPStatus)
	ld (_RAM_C39C_VDPStatus), a
	rla
	jp nc, ++
	ex af, af'
	push af
	push bc
	push de
	push hl
	push ix
	call _LABEL_8CD_READ_JOYPAD
	ld a, (_RAM_C39E_timer)
	inc a
	ld (_RAM_C39E_timer), a
	and $01
	jr nz, +
	ld a, (_RAM_C3A0_charSelectTimer)
	inc a
	ld (_RAM_C3A0_charSelectTimer), a
+:
	call _LABEL_B00_spriteHandler?
	call _LABEL_73C26_ForkLiftPart
	ld e, $1D ;Setting Bank 29
	rst $18	; MAPPER_PAGE2_SUB
	call _LABEL_74000_sound?
	call _LABEL_741D8_music?	;Switch into the music bank, and play music (or continue to do so)
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)	
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB ;Switch back to the previous bank.
	ld a, $01
	ld (_RAM_C3A2_timerml), a ;Reset a timer also. Music length? I forgot my own comments.
	pop ix
	pop hl
	pop de
	pop bc
	pop af
	ex af, af'
++:
	pop af
	ei
	ret

_LABEL_DFD_titleScreenMainLoop?:	;This runs on every frame on the title screen from what it seems.
	push af	; Save af for the stack, since we will use the accumulator.
	in a, (Port_VDPStatus)
	rla	;Read the status port, and check for the interrupt source.
	jp nc, _LABEL_E6A_ ;Jump there, if we not in hblank.
	ex af, af'
	push af
	push bc
	push de
	push hl
	push ix	;Save registers on the stack.
	ld a, (_RAM_C8B7_showSpriteHScore)
	or a
	jr z, + ;Do we have to show the Warrior Sprite? Jump ahead if we don't.
	ld hl, $9F2C
	ld bc, $285C
	call _LABEL_1420_SpriteHandleroutsideMatches
+:	;This is what we'll do when the warrior sprite is not needed to be drawn.
	call _LABEL_B00_spriteHandler?
	call _LABEL_8CD_READ_JOYPAD
	ld a, (_RAM_C39E_timer)
	inc a
	ld (_RAM_C39E_timer), a	;Get the timer, increase it, and read joypad.
	and $01
	jr nz, +
	ld a, (_RAM_C3A0_charSelectTimer)
	inc a
	ld (_RAM_C3A0_charSelectTimer), a	;Again, modify timers.
+:
	ld e, $1D ;Bank 29 again. 
	rst $18	; MAPPER_PAGE2_SUB
	call _LABEL_74000_sound?
	call _LABEL_741D8_music?			;This calls for the music playing part.
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB 	;Switch back to the last bank.
	ld a, $01
	ld (_RAM_C3A2_timerml), a
	ld a, (_RAM_C36C_canExitFromOptions)
	or a
	jr z, +
	ld a, (_RAM_C393_JOYPAD1)
	ld e, a
	ld a, (_RAM_C394_JOYPAD2)
	or e
	ld e, a
	and $30
	jr z, +
	and $20
	jp nz, _LABEL_3626_optionsEntryPoint	;This part is polling the joypad+playing music.
	ld a, e
	and $10
	jp nz, _LABEL_1CBF_characterSelectScreen
+:	;If we had not pressed anything, just come here, then get back the register values, and return.
	pop ix
	pop hl
	pop de
	pop bc
	pop af
	ex af, af'
_LABEL_E6A_:
	pop af
	ei
	ret

_LABEL_ED6_charSelectScreenTimer:
	push af	;Save the accumulator.
	in a, (Port_VDPStatus)
	ld (_RAM_C39C_VDPStatus), a	;Read and store the VDP status registers's values.
	rla	;Push the last bit of the Status Register into Carry to detect VBlank.
	jp nc, _LABEL_ED3_	;Jump if we are not in VBLank.
	ex af, af'			;We continue here, since we are in VBlank.
	push af
	push bc
	push de
	push hl
	push ix				;Save registers on the Stack.
	call _LABEL_B00_spriteHandler?
	call _LABEL_8CD_READ_JOYPAD
	ld a, (_RAM_C39E_timer)
	inc a
	ld (_RAM_C39E_timer), a
	call _LABEL_ED6_charSelectScreenTimer
	ld e, $1D;Bank 29.
	rst $18	; MAPPER_PAGE2_SUB
	call _LABEL_74000_sound?
	call _LABEL_741D8_music?
	ld e, $03 ;Bank 3.
	rst $18	; MAPPER_PAGE2_SUB
	ld a, (_RAM_C39E_timer)
	srl a
	and $07
	add a, a
	add a, a
	ld e, a
	ld d, $00
	push de
	ld hl, _DATA_F482_charSelectEffectTiles1
	add hl, de
	ld de, $0C60
	ld bc, $0020
	call _LABEL_7EF_VDPdataLoad	;Switch tiles for the first effect tile.
	pop de
	ld hl, _DATA_F4C2_charSelectEffectTiles2
	add hl, de
	ld de, $0C80
	ld bc, $0020
	call _LABEL_7EF_VDPdataLoad	;This is the little effect around the character's picture. 
								;Do it for the second time.
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	ld a, $01
	ld (_RAM_C3A2_timerml), a
	pop ix
	pop hl
	pop de
	pop bc
	pop af
	ex af, af'
_LABEL_ED3_:;Jump here if we are not in VBlank, and just return.
	pop af
	ei
	ret

_LABEL_ED6_charSelectScreenTimer:	;This was hit after the new game was initiated, at the character select screen.
	ld a, (_RAM_C39B_matchTimerSmall)
	inc a
	ld (_RAM_C39B_matchTimerSmall), a
	cp $64
	ret nz	;When the counter is 64, return. I guess this is to measure one second.
	xor a	
	ld (_RAM_C39B_matchTimerSmall), a ;Reset the timer back to zero.
	ld a, (_RAM_C3A0_charSelectTimer)
	cp $13
	jr z, +	;Check the overall timer, and jump ahead if we are finished with the counting.
	;So this is like a timer prescaler.
	inc a
	ld (_RAM_C3A0_charSelectTimer), a	;If we increased the timer, put it back into RAM.
+:	;The timer expired, so we are here. We still check the charSelectTimer
	cp $0A
	jr c, +
	sub $0A
	add a, $83
	ld (_RAM_C385_levelNumberHex), a
	push af	;Do some other things here and there...
	ld hl, _RAM_C385_levelNumberHex
	ld bc, $0203
	call _LABEL_84C_timerAndVDPThingy	;This is maaaybe a hud update? It goes four times, and the game 
		;timer is also four characters, but i'm not sure yet. It executes every second on the char select screen.
	dec hl
	ld (hl), $6A
	call _LABEL_84C_timerAndVDPThingy
	dec hl
	pop af
	add a, $1E
	ld (hl), a
	ld bc, $0303
	call _LABEL_84C_timerAndVDPThingy
	dec hl
	ld (hl), $6A
	call _LABEL_84C_timerAndVDPThingy
	ret

+:
	add a, a
	add a, $6F
	ld (_RAM_C385_levelNumberHex), a
	push af
	ld hl, _RAM_C385_levelNumberHex
	ld bc, $0203
	call _LABEL_84C_timerAndVDPThingy
	dec hl
	inc (hl)
	call _LABEL_84C_timerAndVDPThingy
	dec hl
	pop af
	add a, $1E
	ld (hl), a
	ld bc, $0303
	call _LABEL_84C_timerAndVDPThingy
	dec hl
	inc (hl)
	call _LABEL_84C_timerAndVDPThingy
	ret	;Yes, this part executes on the character select screen, every second.

_LABEL_F42_timerAndSpriteMoves:
	push de
	ld a, (hl)
	dec a
	ld e, a
	inc hl
	ld d, (hl)
	ld a, (_RAM_C39E_timer)
-:
	srl a
	dec d
	jr nz, -
	and e
	add a, a
	inc hl
	ld e, a
	ld d, $00
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex de, hl
	pop de
	jp _LABEL_1425_SpriteMoveLoop?

; Data from F5F to F7E (32 bytes)
_DATA_F5F_:;It gets used at the title screen sequence, but also used as a timer as well.(?)
.db $00 $2B $13 $02 $01 $06 $1B $1F $20 $34 $39 $16 $05 $3F $10 $3F
.db $00 $2B $13 $02 $01 $06 $1B $1F $20 $34 $39 $16 $05 $3F $10 $3F

_LABEL_F7F_charSelectEntryPoint:
	di
	call _LABEL_6CD_tilemap_clear
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES	;Disable interrupts, reset palettes.
	xor a
	ld (_RAM_C357_player1char), a	;Reset the current character.
	ld e, $03	;Set the second player as Kato.
	ld a, (_RAM_C35F_numberofPlayers)	;Get the number of players.
	or a
	jr z, +	;Jump ahead if we only have one player.
	ld e, $01	;By default, Player 1 will be Buzz.
+:
	ld a, e
	ld (_RAM_C358_player2char), a	;Yes, this is where that $03 is used for the players.
	;I am not yet convinced why you need to set player 2, if it's not gonna be used. (Later me- Because $03 is the first enemy, the Executioner.)
	ld e, $1D ;Bank 29.
	rst $18	; MAPPER_PAGE2_SUB	;Select the bank where we have the Player Character BIOs.
	ld hl, _DATA_75CE6_plyrSelectBioTiles
	ld de, $1680
	ld bc, $2180	;Over 8k of data loaded, but it looks like not the whole array is used.
	call _LABEL_7EF_VDPdataLoad	;Load them nicely.
	xor a
	ld (_RAM_C354_isroundon), a	;We are not in a match yet.
	ld (_RAM_C398_isroundon), a
	ld hl, _LABEL_ED6_charSelectScreenTimer	
	ld (_RAM_C391_pointer?), hl	;Load it into a pointer, I guess this will be executed later on.
	ld hl, _DATA_74D5C_charSelectMusic	
	call SelectMusicBank	;Load the music, and play it.
	xor a
	ld (_RAM_C362_hudTileOffset), a	;Set this to 0.
	dec a
	ld (_RAM_C3A0_charSelectTimer), a	;This timer is now FF.
	ld a, $31
	ld (_RAM_C39B_matchTimerSmall), a
	ld e, $03 ;Bank 03.
	rst $18	; MAPPER_PAGE2_SUB	;Switch back to the character select screen's bank.
	ld hl, _DATA_F5C2_charSelectBGTiles	;This is the character select screen background, without the player BIOs.
	ld de, $0CA0
	ld bc, $0140
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_F502_paletteCharSelect
	ld de, $3842
	ld bc, $0040
	call _LABEL_7EF_VDPdataLoad
	ld a, $13
	ld de, $3882
-:
	push af
	ld hl, _DATA_F542_palettescharSelect
	push de
	ld bc, $0040
	call _LABEL_7EF_VDPdataLoad
	pop hl
	ld de, $0040
	add hl, de
	ex de, hl
	pop af
	dec a
	jr nz, -
	ld hl, _DATA_F582_palettesCharSelect
	ld de, $3D42
	ld bc, $0040
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_F702_characterSelectTimerTiles
	ld de, $0DE0
	ld bc, $0780
	call _LABEL_7EF_VDPdataLoad	;With some imagination, it can be seen, that this part is also
		;for the effect on the screen. I must say it's pretty neat tho.
	call _LABEL_11ED_plyrNumberVDPThing	;This does some loading into VRAM based on how many players we have.
	ld de, $FFFF
	ld (_RAM_C37A_plyrchooseDone?), de
	ld hl, _DATA_11A4_
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr z, +	;Jump ahead if we only have one player.
	ld de, $0000	;If not, we are in two player mode.
	ld (_RAM_C37A_plyrchooseDone?), de
	ld hl, _DATA_111B_	;No idea what this data is, but maybe some kind of mapdata.
+:
	call _LABEL_848_timerAndVDPThing
	ld hl, $0000
	ld (_RAM_C378_titlescreenvscrolldata?), hl
	ei
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	call _LABEL_121A_playerSelectPics
	ld hl, _DATA_F5F_	;This is a palette of some kind, i'm sure it's used in the little screen effect it around the player mugshots.
	call _LABEL_5F5_timer+pal?
_LABEL_1051_charSelectMainLoop:
	xor a
	ld (_RAM_C3A2_timerml), a
-:	
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -	;Jump back if the zero flag is set, this timer is definetly updated in vblank.
	ld a, (_RAM_C39B_matchTimerSmall)
	cp $31
	jr nz, +
	ld a, (_RAM_C3A0_charSelectTimer)
	cp $13
	jr nz, +	;Jump to the second plus, if we are not yet at the end of the character select timer.
	ld hl, $1260
	ld (_RAM_C378_titlescreenvscrolldata?), hl
	ld (_RAM_C37A_plyrchooseDone?), hl
	call _LABEL_121A_playerSelectPics
	jp ++

+:
	ld hl, (_RAM_C378_titlescreenvscrolldata?)
	ld a, h
	or l
	jr z, +
	ld hl, (_RAM_C37A_plyrchooseDone?)
	ld a, h
	or l
	jp nz, ++
+:
	ld hl, (_RAM_C378_titlescreenvscrolldata?)
	ld a, l
	or h
	jr nz, +
	ld a, (_RAM_C393_JOYPAD1)
	ld de, _RAM_C378_titlescreenvscrolldata?
	ld hl, _RAM_C357_player1char
	call _LABEL_10EF_charSelectandLimit
+:
	ld hl, (_RAM_C37A_plyrchooseDone?)
	ld a, h
	or l
	jr nz, _LABEL_1051_charSelectMainLoop
	ld a, (_RAM_C394_JOYPAD2)
	ld de, $C37A
	ld hl, _RAM_C358_player2char
	call _LABEL_10EF_charSelectandLimit
	jp _LABEL_1051_charSelectMainLoop
;So, this loop is for the character select part. The smaller details are worked out, so it can be deduced with
;a good approximation what does what. The RAM values are also worked out mostly, so it's not that difficult.
; Data from 10B0 to 10B2 (3 bytes)
_DATA_10B0_:
.db $01 $00 $02

++:
	ld a, (_RAM_C357_player1char)
	ld e, a
	ld d, $00
	ld hl, _DATA_10B0_
	add hl, de
	ld a, (hl)
	ld (_RAM_C357_player1char), a
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr z, +
	ld a, (_RAM_C358_player2char)
	ld e, a
	ld d, $00
	ld hl, _DATA_10B0_
	add hl, de
	ld a, (hl)
	ld (_RAM_C358_player2char), a
+:
	ld a, $03
	call _LABEL_20F7_fadeoutandStop?
	ld b, $96
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	ret
;This is another part of the character select part, and does the character comparisons.
;It can be also seen, where the player select has been accepted, and the music will fade out.
;The code is fairly easy to follow.
_LABEL_10EF_charSelectandLimit:	;So, we receive the player character value into HL, and joypad value in A.
	srl a	;Roll the last byte into carry.
	jp nc, ++	;Jump ahead if the button is not pressed.
	ld a, (hl)	;Get the character number.
	inc a
	cp $03	;Increase the number, and check with 3.
	jr c, +	;If <3, then jump ahead. So this part check if we choose from the three characters.
	xor a	;If a>3, then reset to 0 (Buzz).
	;So if we change that number after cp, we could select more characters, but the mugshots and other
	;graphics would be messed up.
+:
	ld (hl), a
	jp _LABEL_121A_playerSelectPics	;Show the character's picture.

++:
	srl a
	jr nc, ++	;Check the next byte, and jump ahead if the button associated to it is not pressed.
	ld a, (hl)
	sub $01
	jr nc, +
	ld a, $02
+:
	ld (hl), a
	jp _LABEL_121A_playerSelectPics

++:
	and $0C;	AND with 0000 1100 and since it's different endianness, it's checking for one of the two fire buttons.
	ret z
	ex de, hl
	ld de, $1260
	ld (hl), e
	inc hl
	ld (hl), d
	jp _LABEL_121A_playerSelectPics

; Data from 111B to 11A3 (137 bytes)
_DATA_111B_:
.db $07 $00
.dsb 9, $63
.db $01 $11
.dsb 9, $64
.db $0D $01 $07 $63 $01 $0F $63 $01 $11 $64 $01 $19 $64 $0D $01 $07
.db $63 $01 $0F $63 $01 $11 $64 $01 $19 $64 $0D $01 $07 $63 $01 $0F
.db $63 $01 $11 $64 $01 $19 $64 $0D $01 $07 $63 $01 $0F $63 $01 $11
.db $64 $01 $19 $64 $0D $01 $07 $63 $01 $0F $63 $01 $11 $64 $01 $19
.db $64 $0D $01 $07 $63 $01 $0F $63 $01 $11 $64 $01 $19 $64 $0D $01
.db $07 $63 $01 $0F $63 $01 $11 $64 $01 $19 $64 $0D $01 $07
.dsb 9, $63
.db $01 $11
.dsb 9, $64
.db $00

; Data from 11A4 to 11EC (73 bytes)
_DATA_11A4_:
.db $0C $00
.dsb 9, $63
.db $0D $01 $0C $63 $01 $14 $63 $0D $01 $0C $63 $01 $14 $63 $0D $01
.db $0C $63 $01 $14 $63 $0D $01 $0C $63 $01 $14 $63 $0D $01 $0C $63
.db $01 $14 $63 $0D $01 $0C $63 $01 $14 $63 $0D $01 $0C $63 $01 $14
.db $63 $0D $01 $0C
.dsb 9, $63
.db $00

_LABEL_11ED_plyrNumberVDPThing:
	ld e, $03 ;Bank 03.
	rst $18	; MAPPER_PAGE2_SUB
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr z, +	;Load the player select bank, then check how many players are there. If one player, jump ahead.
	ld hl, _DATA_F2C2_	;This is the two player mode.
	ld de, $3850
	ld bc, $070E
	call _LABEL_2EB5_vramLoad?
	ld hl, _DATA_F2D0_
	ld de, $3864
	ld bc, $070E	;434 bytes
	jp _LABEL_2EB5_vramLoad?	

+:
	ld hl, _DATA_F2C2_
	ld de, $385A
	ld bc, $070E
	jp _LABEL_2EB5_vramLoad?

_LABEL_121A_playerSelectPics:	;This is executed after we have finished selecting our player, or when the timer hits zero.
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr z, _LABEL_1286_playerOneOnly	;Jump there if there is only one player.
	ld a, $1E ;Bank 30.
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB	;Switch to Bank 30.
	ld hl, $9970
	ld a, (_RAM_C357_player1char)	;Get the selected player.
	call _LABEL_12CE_charMapSet2
	ld de, (_RAM_C378_titlescreenvscrolldata?)
	add hl, de
	ld de, $0020
	ld bc, $0620
	call _LABEL_806_loadTiles
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld e, $03 ;Bank 03.
	rst $18	; MAPPER_PAGE2_SUB
	ld de, $3A4E
	ld a, (_RAM_C357_player1char)
	call _LABEL_12C0_charMapSet
	ld bc, $1312
	call _LABEL_2EB5_vramLoad?
	ld e, $1E ;Bank 30.
	rst $18	; MAPPER_PAGE2_SUB
	ld hl, $9970
	ld a, (_RAM_C358_player2char)
	call _LABEL_12CE_charMapSet2
	ld de, (_RAM_C37A_plyrchooseDone?)
	add hl, de
	ld de, $0640
	ld bc, $0620
	call _LABEL_806_loadTiles
	ld e, $03 ;Bank 03.
	rst $18	; MAPPER_PAGE2_SUB
	ld de, $3A62
	ld a, (_RAM_C358_player2char)
	call _LABEL_12C0_charMapSet
	ld bc, $1312
	jp _LABEL_2EB5_vramLoad?
	;So far, it can be deduced that this code gets the second player's choice, and loads the appropriate tiles
	;for it.
_LABEL_1286_playerOneOnly:
	;We jump here if we have only one player.
	ld a, $1E
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a ;Bank 30.
	rst $18	; MAPPER_PAGE2_SUB
	ld hl, $9970
	ld a, (_RAM_C357_player1char)
	call _LABEL_12CE_charMapSet2
	ld de, (_RAM_C378_titlescreenvscrolldata?)
	add hl, de
	ld de, $0020
	ld bc, $0620
	call _LABEL_806_loadTiles
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld e, $03;Bank 03.
	rst $18	; MAPPER_PAGE2_SUB
	ld de, $3A58
	ld a, (_RAM_C357_player1char)
	call _LABEL_12C0_charMapSet
	ld bc, $1312
	jp _LABEL_2EB5_vramLoad?

_LABEL_12C0_charMapSet:	;This part handles the character portraits in the mapdata part, most probably.
	add a, a
	ld l, a
	add a, a
	add a, a
	add a, a
	add a, l
	ld l, a
	ld h, $00
	ld bc, _DATA_EE02_mapdata?
	add hl, bc
	ret

_LABEL_12CE_charMapSet2:	;The input is the character of the player.
	or a	;Lose carry.
	ld de, $0000
	jr z, +	;If the player character is Buzz, jump ahead, since we don't have to do anything else.
	ld de, $0620
	cp $01	
	jr z, +	;This is for Ty.
	ld de, $0C40	;This is for Kato.
+:
	add hl, de
	ret

; Data from 12E0 to 1317 (56 bytes)
_DATA_12E0_:
.db $42 $3E $82 $3E $C2 $3E $02 $38 $42 $38 $82 $38 $C2 $38 $02 $39
.db $42 $39 $82 $39 $C2 $39 $02 $3A $42 $3A $82 $3A $C2 $3A $02 $3B
.db $42 $3B $82 $3B $C2 $3B $02 $3C $42 $3C $82 $3C $C2 $3C $02 $3D
.db $42 $3D $82 $3D $C2 $3D $02 $3E

_LABEL_1318_nameEntryTileLoad:
	ld e, $16;Bank 22.	;Switch to the highscore/round 9 graphics bank.
	rst $18	; MAPPER_PAGE2_SUB
	ld hl, _DATA_5A326_highScoreNameEntryTiles
	ld de, $24E0
	ld bc, $1300
	call _LABEL_7EF_VDPdataLoad	;Okay, so we load the highscore entry graphics.
	ld e, $1F ;Bank 31.
	rst $18	; MAPPER_PAGE2_SUB	;And switch to the last bank, where there is more graphics for the highscore.
	ret

_LABEL_132B_playerPositionAnimation:
	ld a, (_RAM_C6EF_plyr1YPos)
	ld e, a
	ld a, (_RAM_C6F3_plyr2YPos)
	cp e	;Compare player 1 and 2 Y coordinates.
	jr c, +	;Jump ahead if a<c. Collision detection?
	call _LABEL_1378_charSpriteroutine?	;Maybe this is for a move routine or something, but it is not clear for
	;me yet.
	jp ++
	;Okay, so this routine above is handling player 2 first, then player one, as seen below too.
+:
	call ++
	jp _LABEL_1378_charSpriteroutine?

++:	;From what I can see, this code is the same as the one above, I guess duplicating it is easier than adding some
;extra logic, and save some bytes.
	ld a, (_RAM_C6F7_plyr1Frame?)
	or a
	ret z	;Get player 1 frame, and if it's zero, just return.
	ex af, af'
	ld a, $01
	ld (_RAM_C703_spriteDrawNumber?), a
	ex af, af'
	ld hl, (_RAM_C704_pointer)
	ld (_RAM_C701_pointer?), hl
	call _LABEL_19FF_animateCharacter?	;From the first look, this seems like an animation code.
	ld a, (_RAM_C70C_tempStorPlyr1)
	ld e, a ;Bank 01? That does not seem any sense...
	rst $18	; MAPPER_PAGE2_SUB
	push hl
	ld bc, (_RAM_C6EF_plyr1YPos)
	ld a, (_RAM_C6F7_plyr1Frame?)
	dec a
	srl a
	ld e, a
	ld d, $00
	ld hl, (_RAM_C708_plyr1PosPointer)
	add hl, de
	ld a, (hl)
	add a, c
	ld c, a
	ld de, (_RAM_C6ED_plyr1XposScrnHalf)
	pop hl
	jp _LABEL_1425_SpriteMoveLoop?

_LABEL_1378_charSpriteroutine?:
	ld a, (_RAM_C6F8_plyr2Frame?)
	or a
	ret z	;Return if the player just standing still?
	ex af, af'
	ld a, $0D
	ld (_RAM_C703_spriteDrawNumber?), a	;Set this, so 13 sprites will be drawn?
	ex af, af'
	ld hl, (_RAM_C706_pointer)
	ld (_RAM_C701_pointer?), hl
	call _LABEL_19FF_animateCharacter?
	ld a, (_RAM_C70D_tempStorPlyr2)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 13 loaded.
	push hl
	ld bc, (_RAM_C6F3_plyr2YPos)
	ld a, (_RAM_C6F8_plyr2Frame?)
	dec a
	srl a
	ld e, a
	ld d, $00
	ld hl, (_RAM_C70A_plyr2PosPointer)
	add hl, de
	ld a, (hl)
	add a, c
	ld c, a
	ld de, (_RAM_C6F1_plyr2XPosScrnHalf)
	pop hl
	jp _LABEL_1425_SpriteMoveLoop?

_LABEL_13AF_AdditionalpauseRoutine?:
	push af
	ld a, (_RAM_C341_gamepause2)
	cpl
	ld (_RAM_C341_gamepause2), a
	pop af
	retn

_LABEL_13BA_:
	ld hl, $3840
	ld a, $54	;0101 0100
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $38	;0011 1000
	out (Port_VDPAddressControlPort), a
	;Set up read from VRAM address 111000 01010100 $3854 so this is from the BG part.
	ld de, _RAM_start
	ld b, $96
-:
	in a, (Port_VDPData)
	ld (de), a
	inc de
	djnz -	;Read 150 bytes from VRAM into the beginning of RAM.
	ld e, $1C;Bank 28.
	rst $18	; MAPPER_PAGE2_SUB
	ld de, $3854
	ld bc, $0316
	ld hl, _DATA_73F1C_	;Load some map data here, but not forklift or anything like that.
	call _LABEL_2EB5_vramLoad?
	xor a
	ld (_RAM_C341_gamepause2), a
SILENCE_PSG_ROUTINE:
	ld hl, SILENCE_PSG_DATA ;Load address into hl.
	ld c, Port_PSG
	ld b, $04
	otir ;Set up a 4 byte transfer to the PSG port to silence it.
	ret

; Data from 13F0 to 13F3 (4 bytes)
SILENCE_PSG_DATA:
.db $9F $BF $DF $FF

_LABEL_13F4_pauseRelated?:;This is called from RAM.
	ld a, (_RAM_C342_gamePaused)
	or a
	jr nz, +
	ld a, (_RAM_C341_gamepause2)
	or a
	ret z
	call _LABEL_13BA_
	ld a, $01
	ld (_RAM_C342_gamePaused), a
+:
	ld a, (_RAM_C341_gamepause2)
	or a
	ret z
	xor a
	ld (_RAM_C341_gamepause2), a
	ld (_RAM_C342_gamePaused), a
	ld hl, _RAM_start
	ld de, $3854
	ld bc, $0096
	call _LABEL_7EF_VDPdataLoad
	ret

_LABEL_1420_SpriteHandleroutsideMatches:;We come here first after setting those forklift pose variables
	ld e, c ;$32 loaded into e.
	ld c, b ;Load the forklift height into c.
	ld d, $00
	ld b, d	;Zero out d and b.
_LABEL_1425_SpriteMoveLoop?:	;This looks more like a game loop, where the sprites are moving around. 
				;This is used for the title screen, and the main loop of the game.
	push hl	
	ld hl, (_RAM_C33B_plyfieldborder)	;Get the X coordinate.
	ex de, hl
	or a
	sbc hl, de
	ld e, l
	ld a, h	
	cp $01	
	jp z, + 
	or a
	jp z, _LABEL_1480_	
	cp $FF	
	jp z, ++
-:
	pop hl
	ret	

+:	
	ld a, l
	ex af, af'
	push bc
	pop hl
	ld bc, (_RAM_C33D_playFieldBaseHeight) ;This handles where the players could walk on the playfield. 00 is the default, but you can 
	;push it to be upper than that. The first byte handles this, i don't know yet what the second byte does apart from
	;hiding the players.
	;C33B is X
	;C33D is Y
	;But these control the 'origo' for the moving sprites. as well as the title screen animations and such things.
	or a
	sbc hl, bc
	ld b, l
	ld c, e
	ld a, h
	or a
	jp z, _LABEL_16F4_
	ex af, af'
	cp $80
	jp nc, -
	ex af, af'
	cp $FF
	jp z, _LABEL_14DF_
	cp $01
	jp z, _LABEL_1568_
	pop hl
	ret

++:
	push bc
	pop hl
	ld bc, (_RAM_C33D_playFieldBaseHeight)
	or a
	sbc hl, bc
	ld b, l
	ld c, e
	ld a, h
	or a
	jp z, _LABEL_16A4_ ;This is for the lowest point in the stage's height.
	cp $FF
	jp z, + ;This might be for the "ceiling".
	cp $01
	jp z, _LABEL_1521_
	pop hl
	ret

_LABEL_1480_:
	push bc
	pop hl ;Save registers.
	ld bc, (_RAM_C33D_playFieldBaseHeight)
	or a ;Pull the base height from ram, and lose the carry.
	sbc hl, bc ;Subtract bc from hl.
	ld b, l
	ld c, e
	ld a, h
	cp $FF ;So, this is the highest point.
	jp z, _LABEL_1608_
	or a
	jp z, _LABEL_15AF_ ;Lowest point.
	cp $01
	jp z, _LABEL_1654_ ;Middle point?
	pop hl
	ret
;Here, my guess might be that this is used with signed numbers in mind, but checking the base height for something.
+:
	pop hl
	ld a, (_RAM_C338_howmanyspronscrn)
	exx
	ld e, a
	ld a, (_RAM_C703_spriteDrawNumber?)
	ld d, a
	ld hl, (_RAM_C336_NMESpritePosOnScreen)
	ld b, $08
	exx
-:
	ld a, (hl)
	or a
	jp nz, _LABEL_1744_
	inc hl
	ld a, (hl)
	ex af, af'
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	bit 7, d
	jr nz, -
	bit 7, e
	jr nz, -
	ld a, b
	add a, d
	jr nc, -
	sub $08
	exx
	ld c, a
	exx
	ld a, c
	add a, e
	jr nc, -
	exx
	ld (hl), a
	inc l
	ex af, af'
	add a, d
	ld (hl), a
	inc l
	ld (hl), c
	inc l
	inc e
	exx
	jp -

; Data from 14DC to 14DE (3 bytes)
.db $C3 $44 $17

_LABEL_14DF_:
	pop hl
	ld a, (_RAM_C338_howmanyspronscrn)
	exx
	ld e, a
	ld a, (_RAM_C703_spriteDrawNumber?)
	ld d, a
	ld hl, (_RAM_C336_NMESpritePosOnScreen)
	ld b, $08
	exx
-:
	ld a, (hl)
	or a
	jp nz, _LABEL_1744_
	inc hl
	ld a, (hl)
	ex af, af'
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	bit 7, d
	jr nz, -
	bit 7, e
	jr z, -
	ld a, b
	add a, d
	jr nc, -
	exx
	sub b
	ld c, a
	exx
	ld a, c
	add a, e
	jr c, -
	exx
	ld (hl), a
	inc l
	ex af, af'
	add a, d
	ld (hl), a
	inc l
	ld (hl), c
	inc l
	inc e
	exx
	jp -

; Data from 151E to 1520 (3 bytes)
.db $C3 $44 $17	;Unused bytes, this is not code or data.

_LABEL_1521_:
	pop hl
	ld a, (_RAM_C338_howmanyspronscrn)
	exx
	ld e, a
	ld a, (_RAM_C703_spriteDrawNumber?)
	ld d, a
	ld hl, (_RAM_C336_NMESpritePosOnScreen)
	ld b, $08
	exx
-:
	ld a, (hl)
	or a
	jp nz, _LABEL_1744_
	inc hl
	ld a, (hl)
	ex af, af'
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	bit 7, d
	jr z, -
	bit 7, e
	jr nz, -
	ld a, b
	add a, d
	jr c, -
	cp $C8
	jp nc, -
	exx
	sub b
	ld c, a
	exx
	ld a, c
	add a, e
	jr nc, -
	exx
	ld (hl), a
	inc l
	ex af, af'
	add a, d
	ld (hl), a
	inc l
	ld (hl), c
	inc l
	inc e
	exx
	jp -

; Data from 1565 to 1567 (3 bytes)
.db $C3 $44 $17	;No idea why these are here at all. They mean nothing in hex.

_LABEL_1568_:
	pop hl
	ld a, (_RAM_C338_howmanyspronscrn)
	exx
	ld e, a
	ld a, (_RAM_C703_spriteDrawNumber?)
	ld d, a
	ld hl, (_RAM_C336_NMESpritePosOnScreen)
	ld b, $08
	exx
-:
	ld a, (hl)
	or a
	jp nz, _LABEL_1744_
	inc hl
	ld a, (hl)
	ex af, af'
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	bit 7, d
	jr z, -
	bit 7, e
	jr z, -
	ld a, b
	add a, d
	jr c, -
	cp $C8
	jp nc, -
	exx
	sub b
	ld c, a
	exx
	ld a, c
	add a, e
	jr nc, -
	exx
	ld (hl), a
	inc l
	ex af, af'
	add a, d
	ld (hl), a
	inc l
	ld (hl), c
	inc l
	inc e
	exx
	jp -

; Data from 15AC to 15AE (3 bytes)
.db $C3 $44 $17

_LABEL_15AF_:
	pop hl
	ld a, (_RAM_C338_howmanyspronscrn)
	exx
	ld e, a
	ld a, (_RAM_C703_spriteDrawNumber?)
	ld d, a
	ld hl, (_RAM_C336_NMESpritePosOnScreen)
	ld b, $08
	exx
_LABEL_15BF_:
	ld a, (hl)
	or a
	jp nz, _LABEL_1744_
	inc hl
	ld a, (hl)
	ex af, af'
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	bit 7, d
	jr nz, +
	ld a, b
	add a, d
	jp c, _LABEL_15BF_
	cp $C8
	jp c, ++
	jp _LABEL_15BF_

+:
	ld a, b
	add a, d
	cp b
	jr nc, _LABEL_15BF_
++:
	exx
	sub b
	ld c, a
	exx
	bit 7, e
	jr nz, +
	ld a, c
	add a, e
	jp nc, ++
	jp _LABEL_15BF_

+:
	ld a, c
	add a, e
	cp c
	jr nc, _LABEL_15BF_
++:
	exx
	ld (hl), a
	inc l
	ex af, af'
	add a, d
	ld (hl), a
	inc l
	ld (hl), c
	inc l
	inc e
	exx
	jp _LABEL_15BF_

; Data from 1605 to 1607 (3 bytes)
.db $C3 $44 $17

_LABEL_1608_:
	pop hl
	ld a, (_RAM_C338_howmanyspronscrn)
	exx
	ld e, a
	ld a, (_RAM_C703_spriteDrawNumber?)
	ld d, a
	ld hl, (_RAM_C336_NMESpritePosOnScreen)
	ld b, $08
	exx
-:
	ld a, (hl)
	or a
	jp nz, _LABEL_1744_
	inc hl
	ld a, (hl)
	ex af, af'
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	bit 7, d
	jr nz, -
	ld a, b
	add a, d
	jr nc, -
	exx
	sub $08
	ld c, a
	exx
	bit 7, e
	jr nz, +
	ld a, c
	add a, e
	jp nc, ++
	jp -

+:
	ld a, c
	add a, e
	cp c
	jr nc, -
++:
	exx
	ld (hl), a
	inc l
	ex af, af'
	add a, d
	ld (hl), a
	inc l
	ld (hl), c
	inc l
	inc e
	exx
	jp -

; Data from 1651 to 1653 (3 bytes)
.db $C3 $44 $17

_LABEL_1654_:
	pop hl
	ld a, (_RAM_C338_howmanyspronscrn)
	exx
	ld e, a
	ld a, (_RAM_C703_spriteDrawNumber?)
	ld d, a
	ld hl, (_RAM_C336_NMESpritePosOnScreen)
	ld b, $08
	exx
-:
	ld a, (hl)
	or a
	jp nz, _LABEL_1744_
	inc hl
	ld a, (hl)
	ex af, af'
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	bit 7, d
	jr z, -
	ld a, b
	add a, d
	jr c, -
	cp $C8
	jp nc, -
	exx
	sub b
	ld c, a
	exx
	bit 7, e
	jr nz, +
	ld a, c
	add a, e
	jp nc, ++
	jp -

+:
	ld a, c
	add a, e
	cp c
	jr nc, -
++:
	exx
	ld (hl), a
	inc l
	ex af, af'
	add a, d
	ld (hl), a
	inc l
	ld (hl), c
	inc l
	inc e
	exx
	jp -

; Data from 16A1 to 16A3 (3 bytes)
.db $C3 $44 $17

_LABEL_16A4_:
	pop hl
	ld a, (_RAM_C338_howmanyspronscrn)
	exx
	ld e, a
	ld a, (_RAM_C703_spriteDrawNumber?)
	ld d, a
	ld hl, (_RAM_C336_NMESpritePosOnScreen)
	ld b, $08
	exx
-:
	ld a, (hl)
	or a
	jp nz, _LABEL_1744_
	inc hl
	ld a, (hl)
	ex af, af'
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	bit 7, d
	jr nz, +
	ld a, b
	add a, d
	jp c, -
	cp $C8
	jp c, ++
	jp -

+:
	ld a, b
	add a, d
	cp b
	jr nc, -
++:
	exx
	sub b
	ld c, a
	exx
	bit 7, e
	jr nz, -
	ld a, c
	add a, e
	jr nc, -
	exx
	ld (hl), a
	inc l
	ex af, af'
	add a, d
	ld (hl), a
	inc l
	ld (hl), c
	inc l
	inc e
	exx
	jp -

; Data from 16F1 to 16F3 (3 bytes)
.db $C3 $44 $17

_LABEL_16F4_:;We jump here, if a is zero. Before the match starts, this runs. I guess to put the characters on screen.
	pop hl
	ld a, (_RAM_C338_howmanyspronscrn)
	exx
	ld e, a
	ld a, (_RAM_C703_spriteDrawNumber?)
	ld d, a
	ld hl, (_RAM_C336_NMESpritePosOnScreen)
	ld b, $08
	exx
-:
	ld a, (hl)
	or a
	jp nz, _LABEL_1744_ 
	inc hl
	ld a, (hl)
	ex af, af'
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	bit 7, d
	jr nz, +
	ld a, b
	add a, d
	jp c, -
	cp $C8
	jp c, ++
	jp -

+:
	ld a, b
	add a, d
	cp b
	jr nc, -
++:
	exx
	sub b
	ld c, a
	exx
	bit 7, e
	jr z, -
	ld a, c
	add a, e
	jr c, -
	exx
	ld (hl), a
	inc l
	ex af, af'
	add a, d
	ld (hl), a
	inc l
	ld (hl), c
	inc l
	inc e
	exx
	jp -

; Data from 1741 to 1743 (3 bytes)
.db $C3 $44 $17

_LABEL_1744_:
	exx
	ld a, e
	ld (_RAM_C338_howmanyspronscrn), a
	ld (_RAM_C336_NMESpritePosOnScreen), hl
	exx
	ret

; Data from 174E to 17A1 (84 bytes)
_DATA_174E_:
.db $00 $80 $80 $81 $00 $83 $80 $84 $00 $86 $80 $87 $00 $89 $80 $8A
.db $00 $8C $80 $8D $00 $8F $80 $90 $00 $92 $80 $93 $00 $95 $80 $96
.db $00 $98 $80 $99 $00 $9B $80 $9C $00 $9E $80 $9F $00 $A1 $80 $A2
.db $00 $A4 $80 $A5 $00 $A7 $80 $A8 $00 $AA $80 $AB $00 $AD $80 $AE
.db $00 $B0 $80 $B1 $00 $B3 $80 $B4 $00 $B6 $80 $B7 $00 $B9 $80 $BA
.db $00 $BC $80 $BD

_LABEL_17A2_playerAnimations?:;Also executed from RAM.
	ld a, (_RAM_C6F5_gmplyAnim?)
	cp $04
	jr nz, _LABEL_17EF_animHandler?
	call _LABEL_3540_crowdAnimator?
	call _LABEL_1A5D_plyrAnimate?
	xor a
	ld (_RAM_C6F5_gmplyAnim?), a
	ld a, (_RAM_C6F6_animFrameCounter?)
	cpl
	ld (_RAM_C6F6_animFrameCounter?), a
	ld hl, (_RAM_C704_pointer)
	ld (_RAM_C701_pointer?), hl
	ld a, (_RAM_C6FF_plyr1animateEnable)
	call _LABEL_19E6_	;This sets some pointer up in RAM, but that's all I could decipher.
	ld (_RAM_C6F9_plyr1Frame2?), hl
	ex af, af'
	ld a, (_RAM_C6FB_plyr1Frame3?)
	ld (_RAM_C6F7_plyr1Frame?), a
	ex af, af'
	ld (_RAM_C6FB_plyr1Frame3?), a
	ld hl, (_RAM_C706_pointer)
	ld (_RAM_C701_pointer?), hl
	ld a, (_RAM_C700_plyr2animateEnable)
	call _LABEL_19E6_
	ld (_RAM_C6FC_plyr2Frame1?), hl
	ex af, af'
	ld a, (_RAM_C6FE_plyr2Frame2?)
	ld (_RAM_C6F8_plyr2Frame?), a
	ex af, af'
	ld (_RAM_C6FE_plyr2Frame2?), a
	ret

_LABEL_17EF_animHandler?:
	ld e, a
	inc a
	ld (_RAM_C6F5_gmplyAnim?), a
	ld a, (_RAM_C6F6_animFrameCounter?)
	or a
	jr z, +
	ld a, $04
+:
	add a, e
	ld e, a
	add a, a
	add a, e
	ld l, a
	ld h, $19
	jp (hl)

; Data from 1804 to 18FF (252 bytes)
.db $13 $01 $40 $00 $09 $7B $FE $3C $38 $03 $E6 $07 $5F $0E $BF $ED
.db $69 $00 $00 $00 $ED $61 $00 $00 $0D $1A $ED $79 $00 $00 $00 $13
.db $1A $ED $79 $13 $01 $40 $00 $09 $7B $FE $3C $38 $03 $E6 $07 $5F
.db $0E $BF $ED $69 $00 $00 $00 $ED $61 $00 $00 $0D $1A $ED $79 $00
.db $00 $00 $13 $1A $ED $79 $13 $01 $40 $00 $09 $7B $FE $3C $38 $03
.db $E6 $07 $5F $0E $BF $ED $69 $00 $00 $00 $ED $61 $00 $00 $0D $1A
.db $ED $79 $00 $00 $00 $13 $1A $ED $79 $13 $01 $40 $00 $09 $7B $FE
.db $3C $38 $03 $E6 $07 $5F $0E $BF $ED $69 $00 $00 $00 $ED $61 $00
.db $00 $0D $1A $ED $79 $00 $00 $00 $13 $1A $ED $79 $13 $01 $40 $00
.db $09 $7B $FE $3C $38 $03 $E6 $07 $5F $0E $BF $ED $69 $00 $00 $00
.db $ED $61 $00 $00 $0D $1A $ED $79 $00 $00 $00 $13 $1A $ED $79 $13
.db $01 $40 $00 $09 $7B $FE $3C $38 $03 $E6 $07 $5F $0E $BF $ED $69
.db $00 $00 $00 $ED $61 $00 $00 $0D $1A $ED $79 $00 $00 $00 $13 $1A
.db $ED $79 $13 $01 $40 $00 $09 $7B $FE $3C $38 $03 $E6 $07 $5F $0E
.db $BF $ED $69 $00 $00 $00 $ED $61 $00 $00 $0D $1A $ED $79 $00 $00
.db $00 $13 $1A $ED $79 $13 $01 $40 $00 $09 $7B $FE
;The above is not referenced anywhere, and is seemingly looking like code when decompiled, but it's not really
;valid. It makes a bunch of VDP accesses, and the way it does looks promising, but I have still no idea what it
;does, but it does not have a valid exit point.

;The below is some kind of jump table, and those jump also somewhere else, and definetly some animation related.
_LABEL_1900_:
	jp +

_LABEL_1903_:
	jp ++

_LABEL_1906_:
	jp +

_LABEL_1909_:
	jp +

_LABEL_190C_:
	jp +++++

_LABEL_190F_:
	jp _LABEL_1954_

_LABEL_1912_:
	jp +

_LABEL_1915_:
	ld hl, (_RAM_C6FC_plyr2Frame1?)
	ld de, $0560
	jp _LABEL_197B_

+:
	ld hl, (_RAM_C6FC_plyr2Frame1?)
	ld de, $04A0
	jp +++++++

+:
	ld hl, (_RAM_C6FC_plyr2Frame1?)
	ld de, $0260
	jp _LABEL_197B_

+:
	ld hl, (_RAM_C6FC_plyr2Frame1?)
	ld de, $01A0
	jp +++++++

+:
	ld hl, (_RAM_C6F9_plyr1Frame2?)
	ld de, $0020
	jp +++++++

++:
	ld hl, (_RAM_C6F9_plyr1Frame2?)
	ld de, $00E0
	jp _LABEL_197B_

+++++:
	ld hl, (_RAM_C6F9_plyr1Frame2?)
	ld de, $0320
	jp +++++++

_LABEL_1954_:
	ld hl, (_RAM_C6F9_plyr1Frame2?)
	ld de, $03E0
	jp _LABEL_197B_

+++++++:
	push de
	ld e, h
	rst $18	; MAPPER_PAGE2_SUB
	ld h, $00
	ld a, l
	and $80
	ex af, af'
	ld a, l
	and $7F
	add a, a
	ld l, a
	ld de, _DATA_174E_
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex de, hl
	pop de
	ex af, af'
	jp z, +++++
	jp _LABEL_19C1_

_LABEL_197B_:
	push de
	ld e, h
	rst $18	; MAPPER_PAGE2_SUB
	ld h, $00
	ld a, l
	and $80
	ex af, af'
	ld a, l
	and $7F
	add a, a
	ld l, a
	ld de, _DATA_174E_
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld hl, $00C0
	add hl, de
	pop de
	ex af, af'
	jp z, +++++
	jp _LABEL_19C1_

+++++:
	ld a, e
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, d
	or $40
	out (Port_VDPAddressControlPort), a
	ld b, $60
	push hl
	pop de
-:
	ld a, (hl)
	out (Port_VDPData), a
	inc hl
	djnz -
	ld d, $0A
	ld b, $30
-:
	ld e, (hl)
	ld a, (de)
	out (Port_VDPData), a
	inc hl
	ld e, (hl)
	ld a, (de)
	out (Port_VDPData), a
	inc hl
	djnz -
	ret
;These are animation handling parts, definetly.
_LABEL_19C1_:
	ld a, e
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, d
	or $40
	out (Port_VDPAddressControlPort), a
	ld d, $0A
	ld b, $30
-:
	ld e, (hl)
	ld a, (de)
	out (Port_VDPData), a
	inc hl
	ld e, (hl)
	ld a, (de)
	out (Port_VDPData), a
	inc hl
	djnz -
	ld b, $60
	push hl
	pop de
-:
	ld a, (hl)
	out (Port_VDPData), a
	inc hl
	djnz -
	ret

_LABEL_19E6_:
	or a
	jr nz, +
	ld hl, $0000
	ret

+:
	ld l, a
	dec l
	ld h, $00
	add hl, hl
	add hl, hl
	ld de, (_RAM_C701_pointer?)
	inc de
	inc de
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex de, hl
	ret

_LABEL_19FF_animateCharacter?:
	or a
	jr nz, +
	ld hl, $0000
	ret

+:
	ld l, a
	dec l
	ld h, $00
	add hl, hl
	add hl, hl
	ld de, (_RAM_C701_pointer?)
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex de, hl
	ld a, (_RAM_C6F6_animFrameCounter?)
	or a
	ret nz
	ld a, (_RAM_C703_spriteDrawNumber?)
	add a, $18
	ld (_RAM_C703_spriteDrawNumber?), a
	ret

; Data from 1A23 to 1A26 (4 bytes)
.db $23 $23 $08 $C9
;Really, what's up with these stray bytes?!
_LABEL_1A27_:	;This is executed at the beginning of a match.
	push af
	ld a, $20	;0010 0000
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $00
	or $40	;0100 0000
	out (Port_VDPAddressControlPort), a;Set up VRAM write to BG patters, after the first tile.
	pop af
	ld bc, $0600	;1536 bytes.
	ld hl, $0000
	ld de, $0000
	xor a
-:
	out (Port_VDPData), a
	nop
	ldi	;Yup, the ldi just does this data move. The first 1,5k is moved from RAM to VRAM.
	jp pe, -	;Jump on parity even? Wow.. It works tho.
	ld hl, _RAM_C6F5_gmplyAnim?
	ld de, _RAM_C6F5_gmplyAnim? + 1
	ld (hl), a
	ld bc, $000B
	ldir	;Move another few bytes.
	ld hl, _DATA_592E_ - 2
	call _LABEL_1AC4_
	call _LABEL_1AE1_	;The first one is for player one, and second for player 2.
	ret

_LABEL_1A5D_plyrAnimate?:
	ld a, (_RAM_C710_plyr1Animate)
	or a
	jr nz, ++
	ld hl, (_RAM_C70E_plyr2SpriteRelated)
-:
	ld a, (hl)
	cp $FE
	jr nz, +
	ld hl, (_RAM_C712_plyr1AnimFrameControl?)
	ld (_RAM_C70E_plyr2SpriteRelated), hl
	jp -

+:
	ld (_RAM_C710_plyr1Animate), a
	ex af, af'
	inc hl
	ld a, (hl)
	ld (_RAM_C711_plyr1AnimationFrame), a
	inc hl
	ld (_RAM_C70E_plyr2SpriteRelated), hl
	ex af, af'
++:
	cp $FF
	jr z, +
	dec a
	ld (_RAM_C710_plyr1Animate), a
+:
	ld a, (_RAM_C711_plyr1AnimationFrame)
	ld (_RAM_C6FF_plyr1animateEnable), a
	ld a, (_RAM_C716_nmeAnimandHit?)
	or a
	jr nz, ++
	ld hl, (_RAM_C714_plyr2AnimFrameControl?)
-:
	ld a, (hl)
	cp $FE
	jr nz, +
	ld hl, (_RAM_C718_plyr2animRelated?)
	ld (_RAM_C714_plyr2AnimFrameControl?), hl
	jp -

+:
	ld (_RAM_C716_nmeAnimandHit?), a
	ex af, af'
	inc hl
	ld a, (hl)
	ld (_RAM_C717_plyr2AnimFrame?), a
	inc hl
	ld (_RAM_C714_plyr2AnimFrameControl?), hl
	ex af, af'
++:
	cp $FF
	jr z, +
	dec a
	ld (_RAM_C716_nmeAnimandHit?), a
+:
	ld a, (_RAM_C717_plyr2AnimFrame?)
	ld (_RAM_C700_plyr2animateEnable), a
	ret

_LABEL_1AC4_:
	ld de, (_RAM_C712_plyr1AnimFrameControl?)
	ld a, h
	cp d
	jr nz, +
	ld a, l
	cp e
	jr nz, +
	ld a, (_RAM_C710_plyr1Animate)
	cp $FF
	ret nz
+:
	ld (_RAM_C70E_plyr2SpriteRelated), hl
	ld (_RAM_C712_plyr1AnimFrameControl?), hl
	xor a
	ld (_RAM_C710_plyr1Animate), a
	ret

_LABEL_1AE1_:
	ld de, (_RAM_C718_plyr2animRelated?)
	ld a, h
	cp d
	jr nz, +
	ld a, l
	cp e
	jr nz, +
	ld a, (_RAM_C716_nmeAnimandHit?)
	cp $FF
	ret nz
+:
	ld (_RAM_C714_plyr2AnimFrameControl?), hl
	ld (_RAM_C718_plyr2animRelated?), hl
	xor a
	ld (_RAM_C716_nmeAnimandHit?), a
	ret

_LABEL_1AFE_:
	ld a, (ix+17)
	or a
	jp z, _LABEL_1AC4_
	jp _LABEL_1AE1_

; Data from 1B08 to 1B48 (65 bytes)
_DATA_1B08_:
.db $02 $00 $64 $65 $66 $01 $0E $54 $49 $4D $45 $01 $13 $6D $6E $6F
.db $0D $01 $02 $67 $68 $69 $4B $4F $3E $01 $0E $30 $3F $30 $30 $01
.db $13 $70 $71 $72 $4B $4F $3E $0D $01 $02 $6A $6B $6C $61 $62 $62
.db $62 $62 $62 $63 $01 $13 $73 $74 $75 $61 $62 $62 $62 $62 $62 $63
.db $00

; Data from 1B49 to 1B52 (10 bytes)
_DATA_1B49_:
.db $05 $00 $3B $30 $30 $30 $30 $30 $30 $00

; Data from 1B53 to 1B5C (10 bytes)
_DATA_1B53_:
.db $16 $00 $3B $30 $30 $30 $30 $30 $30 $00

; Data from 1B5D to 1BB1 (85 bytes)
_DATA_1B5D_:
.db $02 $00 $64 $65 $66 $01 $0E $54 $49 $4D $45 $01 $13 $6D $6E $6F
.db $0D $01 $02 $67 $68 $69 $01 $06 $89 $8A $89 $8A $89 $8A $01 $0E
.db $30 $3F $30 $30 $01 $13 $70 $71 $72 $01 $17 $89 $8A $89 $8A $89
.db $8A $0D $01 $02 $6A $6B $6C $01 $06 $8B $8C $8B $8C $8B $8C $01
.db $13 $73 $74 $75 $01 $17 $8B $8C $8B $8C $8B $8C $00 $01 $01 $31
.db $32 $33 $34 $35 $00

INIT_VDP:
	di ;Disable interrupt, again? I guess to be on the safe side. (Later on, this was called from RAM as well, it seems.)
	ld sp, $DFF8 ;Setting up stack pointer.
	call SILENCE_PSG_ROUTINE
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES
	ld a, $FF
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $82
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $FF
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $85
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $FB
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $86
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $F0
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $87
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $FF
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $8A
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $36
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $80
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $E0
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $81
	out (Port_VDPAddressControlPort), a
	nop
	nop							;Initializing VDP.
	ld hl, _RAM_CB20_unused			;Loading this RAM address.
	xor a						;Load zero.
	add a, (hl)					;0+0.
	inc hl						;CB21
	add a, (hl)					;0+1
	inc hl						;CB22
	add a, (hl)					;1+2=3
	inc hl						;CB23
	add a, (hl)					;3+3=6
	cp $06						;Compare the two.
	jp z, +						;If they are the same, skip to +. This is definetly a reset check. Pretty strange that the programmer used it like this, and used three bytes for this small thing.
	xor a						;Zero->a.
	ld (_RAM_CB20_unused), a
	inc a
	ld (_RAM_CB21_unused), a
	inc a
	ld (_RAM_CB22_unused), a
	inc a
	ld (_RAM_CB23_unused), a	;The check is for these four values. If the compare fails, this small setup will be done.
	ld e, $1F 					;31 The last bank of the ROM.
	rst $18	; MAPPER_PAGE2_SUB  ;Switch Page 2 to Bank 31.
	ld hl, _DATA_ram_w_highscores
	ld de, _RAM_start
	ld bc, $09C4 ;2500.
	ldir 						;Copy 2500 bytes from ROM. This contains the high score values, and some other things as well.
	ld e, $02 ;Switch mapper bank 2 into slot 2.
	rst $18	; MAPPER_PAGE2_SUB ;Do the bankswitch.
	;So far, the VDP was inited, and the highscore values were also copied from ROM to RAM, and cleared some things out.
	;I can see the appeal in using these bytes to have an easier RAM preparation during bootup.
+:
	ld sp, $DFF8
-:
	call _LABEL_8CD_READ_JOYPAD 
	ld a, (_RAM_C393_JOYPAD1)
	ld e, a
	ld a, (_RAM_C394_JOYPAD2)
	or e
	jr nz, -	;Looks like this waits until all buttons are released on both joypads.
	xor a 
	ld (_RAM_C343_unused), a ;Load zero to this address, and never use it again.
_LABEL_1C5F_titleScreenEntryPoint: ;This is the title screen's entry point.
	xor a
	ld (_RAM_C354_isroundon), a	;Set that we are not in a match.
	ld (_RAM_C398_isroundon), a				;This does nothing here or elsewhere.
	ld (_RAM_C350_hudScrollEnable), a ;There is no HUD anymore, so the scroll of the hud can be disabled.
	ld a, $01
	ld (_RAM_C36C_canExitFromOptions), a ;Set so we can enter then exit from the options menu.
	ld hl, _DATA_74625_titleScreenMusic ;This is most possibly the music for the title screen.
	call SelectMusicBank	;Call a bankswitch, with the music's address in HL. By calling this, the selected music will play then.
	ld hl, _LABEL_DFD_titleScreenMainLoop?		;TODO No idea about this one yet.
	ld (_RAM_C391_pointer?), hl	;Pass it into a pointer variable? Not used by the next instruction.
	call _LABEL_737_clearTilesplusfirst256bytes
	ld a, $00
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $89	;1000 1001	Write 0 to register 9. Disable vertical scrolling.
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $00
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $88	;1000 1000	;Write 0 to register 8. H Scroll register, but this time to disable scrolling.
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $E0
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $81	;1000 0001 write 110 0000 to register 1. Turn on screen. (byte 6)
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ei	;The above cleared VRAM, reset screen scrolling, and enabled the display/screen.
-:
	ld a, $04	;Load bank with the tilescreen graphics.
	ld (_RAM_C64E_BANKSWITCH_PAGE), a	;Save it, so we'll know where we came from.
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 04.
	call _LABEL_119E2_titleScreenPart1
	call _LABEL_13660_titleScreenPart2
_LABEL_1CB2_highscore:
	ld a, $1F	;Load the last bank.
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 31. /Highscore graphics bank/
	call _LABEL_7DD39_showHighScoreTable
	jp -
;It seems the RAM contains the code to handle button presses, so I can't find it there exactly.
;Anyways, this is the title screen loop, which goes until you press 1 to start a game or 2 to enter the options menu.
;The code is fairly straightforward in this regard.
_LABEL_1CBF_characterSelectScreen:
	ld sp, $DFF8
	xor a
	ld (_RAM_C36C_canExitFromOptions), a
	ei
	ld a, $03
	call _LABEL_20F7_fadeoutandStop?
	ld b, $64
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch	;So far we faded the music out, and we will do the same with the 
	;graphics as well.
	ld a, $E0	;1110 0000
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $81	;1000 0001 Again, a write to register 1. Enables screen and interrupts.
	out (Port_VDPAddressControlPort), a
	nop
	nop
	xor a
	ld (_RAM_C8B7_showSpriteHScore), a
	di
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr z, +	;One or two players?
	xor a	;Two player mode.
	ld (_RAM_C74F_plyr1Lives), a	;Reset the lives.
	ld (_RAM_C783_), a
	ld a, (_RAM_C35B_twoplayergametype)	;Since we are in two player mode, check what kind of more we are in.
	cp $01
	jr z, ++	;If this is two player mode 1, jump there.
	ld a, $01
+:
	push af
	ld a, (_RAM_C35B_twoplayergametype)
	cp $02
	jr nz, +	;If the mode is not 2 (mode 3), then jump ahead. This is not how I would do it, but i'm not an expert on this.
	xor a
	ld (_RAM_C35F_numberofPlayers), a
+:
	call _LABEL_F7F_charSelectEntryPoint	;Go to the character select part.
	di
	pop af
	ld (_RAM_C35F_numberofPlayers), a
++:
	xor a
	ld (_RAM_C36D_grudgematch), a
	ld (_RAM_C8CE_), a
	ld (_RAM_C8CF_), a	;Resetting lives, that we are not in a grudge match, and a few other things.
	ld a, $03
	ld (_RAM_C74F_plyr1Lives), a	;Set the number of lives.
	ld a, $FF
	ld (_RAM_C751_plyr1Life), a
	ld (_RAM_C785_plyr2Life), a		;Set lives.
	ld a, $01
	ld (_RAM_C735_plyr1Dead), a
	ld (_RAM_C769_Player2defeat?), a	;We are not dead, and the enemy is not defeated.
	ld hl, $0000
	ld (_RAM_C74D_), hl
	ld (_RAM_C781_plyr2stats?), hl	;Reset some other values too.
	call _LABEL_2A20_levelNumberSet	;Handle some level number values for later.
	jp _LABEL_285B_twoPlayerAndGrudge?

_LABEL_1D4A_initRound:
	ld sp, $DFF8
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr z, +	;Jump to + if we are in one player mode.
	ld a, (_RAM_C35B_twoplayergametype)
	cp $01
	jr nz, +	;Check if we are in two player mode, and not mode 2.
	ld a, (_RAM_C35C_plyr1character)
	call _LABEL_272A_newGameSetup?
	ld a, (_RAM_C35D_plyr2character)	;Get both characters, and set up variables for a new game.
	call _LABEL_516C_getCharDetails		;This is a very similar routine to another one in a different bank.
	xor a
	ld (_RAM_C74C_), a
	ld (_RAM_C780_), a	;Reset some other values, that are not yet mapped.
	ld a, $02
	ld (_RAM_C76D_plyrDistance?), a
	ld a, $00
	ld (_RAM_C759_unused?), a
	ld (_RAM_C78D_unused?), a
	ld a, $03
	ld (_RAM_C745_plyr1SpecMoveCounter), a
	ld (_RAM_C779_plyr2specMoveCounter), a	;Set up the spec move counters.
	jp ++	;Then jump over to continue there.

+:	;So this is the one player part, or any two player modes that are not mode 2.
	ld a, (_RAM_C357_player1char)
	call _LABEL_272A_newGameSetup?
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr z, ++	;Get the first player, set variables, and get how many players there are. Jump to ++ if this is a one player game.
	ld a, (_RAM_C35B_twoplayergametype)
	or a
	jr nz, ++	;Jump if the game type is not type 1.
	ld a, (_RAM_C358_player2char)
	call _LABEL_516C_getCharDetails
	ld a, $02
	ld (_RAM_C76D_plyrDistance?), a	;Two player, mode 1.
++:	;Still a one player game, or two player, mode 2-3.
	ld a, $01
	ld (_RAM_C739_), a
	ld hl, _DATA_58F4_
	ld de, _RAM_C6DD_
	ld bc, $0010
	ldir	;This is a palette loading, but just for the first palette, the second palette is all black.
	;I think this is the palette for the coins on the screen, between matches, like who won more.
	ld hl, _RAM_C6CD_
	call LOAD_BOTH_PALETTES	;This is another palette from RAM getting load in.
	ld hl, _RAM_start
	ld de, _RAM_start + 1
	ld (hl), $00
	ld bc, $001F
	ldir	;Clear out the first 32 bytes of RAM.
	ld hl, _RAM_start
	ld de, $0000
	ld bc, $0020
	call _LABEL_7EF_VDPdataLoad	;I assume this is a palette loading.
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr z, +	;Jump for one player.
	ld a, (_RAM_C35B_twoplayergametype)	;Get the two player mode.
	cp $01
	jr nz, +	;if a!=1 then jump to +
	ld a, (_RAM_C35C_plyr1character)
	ld b, a
	ld a, (_RAM_C35D_plyr2character)
	ld c, a
	jr ++	;BC has the player characters now.

+:	;One player game.
	ld a, (_RAM_C357_player1char)
	ld b, a
	ld a, (_RAM_C358_player2char)
	ld c, a
++:
	call _LABEL_2EE3_loadHUDandMugshots	;We have the players, and we have to load their mugshots onto the HUD.
	call _LABEL_2F8F_checkForGrudge	;No idea why this needs to be a sub, since it's not called anytime else.
	ld e, $02
	rst $18	; MAPPER_PAGE2_SUB Bank 02.
	ld hl, _DATA_8000_
	ld bc, $00A0
	ld de, $0BE0
	call _LABEL_7EF_VDPdataLoad	;This is five tiles, but it could be mapdata or something else, I have to check.
	ld hl, _DATA_80A0_palettes?
	ld bc, $0040
	ld de, $0E80
	call _LABEL_7EF_VDPdataLoad
	call _LABEL_2BD5_matchOrGrudge
	ld e, $1E
	rst $18	; MAPPER_PAGE2_SUB Bank 30.
	ld hl, _DATA_793B0_plyrPicsPlyrSelectPowerUpsThrowables
	ld de, $0620
	ld bc, $05C0
	call _LABEL_7EF_VDPdataLoad	;Load some tiles again.
	ld e, $1C
	rst $18	; MAPPER_PAGE2_SUB Bank 28.
	ld hl, _DATA_73D1C_pausedTilesandData	;This is the 'paused' tiles, and some other data.
	ld de, $0C80
	ld bc, $0200
	call _LABEL_7EF_VDPdataLoad
	ld a, $01
	ld (_RAM_C398_isroundon), a
	ld (_RAM_C350_hudScrollEnable), a
	ld (_RAM_C354_isroundon), a	;Init some variables for the match.
	ld a, $1F	;0001 0000
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $8A	;1000 1010	;VDP register write.
	;Write to register 10. Set bit 5 on. This is to set the Raster line interrupt.
	;My guess is, that this controls how much the upper part of the screen, where the HUD is not scrolled,
	;and the rest is the playfield.
	out (Port_VDPAddressControlPort), a
	nop
	nop	;I don't know why Andrew used these nops here, since we don't write to any VDP ports immediately.
	;Maybe it was just a long night, and it does not matter that much.
	ld a, $10
	ld (_RAM_C64E_BANKSWITCH_PAGE), a	;Set up a future bankswitch? This is bank 16.
	xor a
	ld (_RAM_C341_gamepause2), a
	ld (_RAM_C342_gamePaused), a
	ld (_RAM_C724_CrowdCheerAnimTimer), a
	ld (_RAM_C7CD_pointer?), a
	ld (_RAM_C7D1_pointer?), a
	ld (_RAM_C7D5_indexingPointer?), a
	ld (_RAM_C7E0_indexPointer?), a
	ld (_RAM_C725_), a
	ld (_RAM_C729_unused), a
	ld (_RAM_C72D_unused), a
	ld (_RAM_C731_unused), a
	ld (_RAM_C36E_matchwin), a
	ei	;Finished loading stuff, setting up all needed variables, and now we enable interrupts.
	;With disabling interrupts back then, we were free to load whatever and whenever we want.
	push hl
	ld hl, $DBF5
	ld (_RAM_C5C0_ramCodePointer1), hl
	pop hl
	;We've just set a pointer, and restored HL the way before they were.
	xor a
	ld (_RAM_C766_hitAmount?), a
	inc a
	ld (_RAM_C79A_enemyBlindness?), a
	;Reset the hit amount, then turn on the enemy's eyes. Really, if this is zero, the opponent will just 
	;go around and hit thin air.
	ld hl, $C769
	ld (_RAM_C767_), hl
	ld hl, $C735
	ld (_RAM_C79B_unused?), hl	;Setting these variables seemingly does nothing.
	ld a, $08
	ld (_RAM_C36F_), a	;This scrolls the screen eight pixels to the right, or just to right until the 
	;value reaches zero.
	;So at the beginning of the match, the screen scrolls this amount to the right, then the match begins.
_LABEL_1E96_roundMainLoop:	;As it seems, this is the main match loop's entry point.
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld a, (_RAM_C342_gamePaused)
	or a
	jr nz, _LABEL_1E96_roundMainLoop	;This looks like a small pause routine as well. If this is not zero, just jump back.
	;The timer is updated in VBLANK anyways.
	call _LABEL_4F69_animation	;This is some animation part, but I don't want to dissect it yet.
	call _LABEL_25A3_sprites	;Then do some sprite moving.
	ld a, (_RAM_C39E_timer)
	and $01
	jr z, +
	call _LABEL_302B_hudStuff	;Get some HUD data in? It seems like this is what it does.
	jp ++

+:	;If the timer is now zero, jump here.
	call _LABEL_3126_drawSpecMoveMeter
++:
	ld a, (_RAM_C36E_matchwin)
	or a
	jr z, +	;Check if the currect match has been won or not. $01 or anything else is an instant win.
	dec a	;We have won, so decrease it back to zero.
	ld (_RAM_C36E_matchwin), a	;Load it back to the original variable.
	or a
	jr nz, +	;Is there some other checks other than 1?
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	di
	jp _LABEL_285B_twoPlayerAndGrudge?

+:	;This is where the jr z, + lands.
	ld a, (_RAM_C36D_grudgematch)
	or a
	jr z, ++	;Jump ahead if we are not in a grudge match.
	ld a, (_RAM_C36E_matchwin)	;We are in one.
	or a
	jr nz, ++	;Jump if we have won.
	ld a, (_RAM_C750_plyr1KnockDowns)
	cp $03
	jr nz, +	;Jump if player 1 knockdowns !=3.
	xor a
	ld (_RAM_C769_Player2defeat?), a	;Set player 2 as defeated.
	ld a, $96
	ld (_RAM_C36E_matchwin), a	;We've won the grudge match, jump ahead.
	jr +++

+:	;We don't have three knockdowns yet.
	ld a, (_RAM_C784_plyr2KnockDown)
	cp $03
	jr nz, +++	;If player 2 knockdowns !=3, jump.
	xor a
	ld (_RAM_C735_plyr1Dead), a	;Yikes, the opponent has three knockdowns! Player 1 is defeated.
	ld a, $96
	ld (_RAM_C36E_matchwin), a	;We lost, so jump ahead.
	jp +++

++:	;Player 1 won, and we landed here.
	ld a, (_RAM_C36E_matchwin)
	or a
	jr nz, +++	;Jump to +++ if we have won.
	ld a, (_RAM_C735_plyr1Dead)
	or a
	jr z, +	;Jump, if player 1 is dead.
	ld a, (_RAM_C769_Player2defeat?)
	or a
	jr nz, +++	;Jump if player 2 is not dead.
+:
	ld a, $96
	ld (_RAM_C36E_matchwin), a	;If the player is dead, then use this value.
+++:	;This is a common part of an If statement, or so it seems, and this may be the in match loop?
;Yes, it is.
	ld a, (_RAM_C6F5_gmplyAnim?)
	or a
	call z, _LABEL_2FA3_plyr1LifeThing
	ld a, (_RAM_C6F5_gmplyAnim?)
	cp $01
	call z, _LABEL_2FB4_plyr2LifeThing
	ld a, (_RAM_C6F5_gmplyAnim?)
	cp $02
	call z, _LABEL_2FD0_plyr1drawGrudgeMarks
	ld a, (_RAM_C6F5_gmplyAnim?)
	cp $03
	call z, _LABEL_2FE7_plyr2drawGrudgeMarks	;Do some HUD drawing, life, and if we are in grudge match, then 
	;draw the needed marks on the screen.
	call _LABEL_4CD0_	;This is some match thing, but not anything too visible. When the two mentioned variable
	;is frozen, you can't really pick stuff up.
	ld a, (_RAM_C724_CrowdCheerAnimTimer)	;
	or a
	jr z, +
	dec a
	ld (_RAM_C724_CrowdCheerAnimTimer), a
+:
	ld a, (_RAM_C355_scrollcamera2)
	or a
	jp z, ++
	and $80
	jr z, +
	call _LABEL_33D3_scrollScreenandLoadTiles
	jp ++

+:
	call _LABEL_334F_scrollScreenAndLoadTiles	;This is almost or if not the same routine as the above.
	;No idea as yet why this is done this way.
++:
	ld h, $00
	ld a, (_RAM_C356_scrollcamera)
	ld l, a
	ld (_RAM_C355_scrollcamera2), hl
	jp _LABEL_1E96_roundMainLoop
	;So the main match loop is now almost dissected, I guess the enemy logic is running from RAM, from VBlank.
	;The code is fairly nice again, but there is a deep rabbit hole of indexing thing, which I was not up to the 
	;task for, to disassemble and understand.
; Data from 1F67 to 1F83 (29 bytes)
.db $AF $32 $55 $C3 $3A $56 $C3 $E6 $80 $CA $5B $1F $2A $3B $C3 $2B
.db $22 $3B $C3 $C3 $96 $1E $23 $22 $3B $C3 $C3 $96 $1E
;This is some junk data, when disassembled, this does not resemble any valid code.
_LABEL_1F84_paletteAndDelays:	;HL contains a palette address as source.
	ld a, (_RAM_C400_delay)
	push af	;Save the delay value for later.
	xor a
	ld (_RAM_C400_delay), a	;Null the variable.
	ld (_RAM_C365_paletteTemp), hl	;Move this to the pointer we use for this.
	ld (_RAM_C370_verticalScroll), hl	;Also for this? Hm.
	ld de, _RAM_C020_palTemp
	ld bc, $0020
	ldir	;Move from ROM to RAM this 32 colors.
	ld hl, _RAM_C020_palTemp
	ld de, _RAM_C020_palTemp + 1
	ld (hl), $00
	ld bc, $000F
	ldir	;Null out the first 16 colors worth of RAM. Why load 32 bytes, then null out the first 16?
	ld b, $04
---:
	push bc	
	ld a, b
	ld hl, _RAM_C020_palTemp
	ld de, _RAM_start
	ld bc, $0020	;Copy this 32 bytes to the start of the ram.
	ldir
-:
	push af
	ld b, $10
	ld hl, _RAM_C010_MNEStays
	call _LABEL_5D5_paletteCopyThing
	pop af
	dec a
	jr nz, -
	ld b, $06
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, $0000
	ld de, $0000
	ld bc, $012C
	ldir
	ld hl, _RAM_start
	call LOAD_BOTH_PALETTES
	pop bc
	djnz ---
	ld b, $06
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, $0000
	ld de, $0000
	ld bc, $012C
	ldir
	ld hl, _RAM_C020_palTemp
	call LOAD_BOTH_PALETTES
	ld b, $4B
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, (_RAM_C370_verticalScroll)
	ld de, _RAM_C020_palTemp
	ld bc, $0020
	ldir
	ld b, $04
---:
	push bc
	ld a, b
	ld hl, _RAM_C020_palTemp
	ld de, _RAM_start
	ld bc, $0020
	ldir
-:
	push af
	ld b, $10
	ld hl, _RAM_start
	call _LABEL_5D5_paletteCopyThing
	pop af
	dec a
	jr nz, -
	ld b, $06
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, $0000
	ld de, $0000
	ld bc, $012C
	ldir
	ld hl, _RAM_start
	call LOAD_BOTH_PALETTES
	pop bc
	djnz ---
	ld b, $06
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, $0000
	ld de, $0000
	ld bc, $012C
	ldir
	ld hl, (_RAM_C370_verticalScroll)
	call LOAD_BOTH_PALETTES
	ld a, (_RAM_C400_delay)
	pop af
	ld (_RAM_C400_delay), a
	ret
	;These are palette changes, and delays, so I presume these are for animating some palette changes on the stage, where applicable.
	;Many of these are just copy-paste code there and there.
; Data from 2082 to 209E (29 bytes)
.db $7E $B7 $C8 $CB $7F $20 $09 $4F $06 $00 $23 $ED $B0 $C3 $82 $20
.db $E6 $7F $23 $47 $7E $12 $13 $10 $FC $23 $C3 $82 $20
;This might be just unused code, upon disassembled, this looks like valid code,
;though I have no ide about the purpose. See the code below which this disassembles to:
	
;--:	
;		ld a, (hl)
;		or a
;		ret z
;		bit 7, a
;		jr nz, 9
;		ld c, a
;		ld b, $00
;		inc hl
;		ldir
	
;	; Data from 208F to 208F (1 bytes)
;	.db $C3
	
;_LABEL_2090_:	
;		add a, d
;		jr nz, -26
;		ld a, a
;		inc hl
;		ld b, a
;		ld a, (hl)
;-:	
;		ld (de), a
;		inc de
;		djnz -
;		inc hl
;		jp --



_LABEL_209F_HiddenPuzzleGraphicsLoading:;This might be the puzzle graphics load part!
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	ld hl, _DATA_63C85_
	ld de, $3802
	ld bc, $0140
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_63B45_
	ld de, $3C82
	ld bc, $0140
	call _LABEL_7EF_VDPdataLoad
	ld e, $0D
	rst $18	; MAPPER_PAGE2_SUB Bank 13.
	ld hl, _DATA_37612_MarkoPuzzleLetters
	ld de, $1140
	ld bc, $08C0
	call _LABEL_7EF_VDPdataLoad
	ld e, $14
	rst $18	; MAPPER_PAGE2_SUB Bank 20.
	ld hl, _DATA_537C4_DomarkLogoTileset
	ld de, $1A00
	ld bc, $0820
	call _LABEL_7EF_VDPdataLoad
	ld e, $1B
	rst $18	; MAPPER_PAGE2_SUB Bank 27.
	ret

SelectMusicBank: ;_LABEL_20_DC
	ld e, $1D ;Select ROM Bank 29. (Player select/music player bank.)
	rst $18	; MAPPER_PAGE2_SUB ;Switch pages.
	call _LABEL_7418F_musicInit
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	ret

; Data from 20E8 to 20F5 (14 bytes)
.db $1E $1D $DF $CD $00 $80 $CD $D8 $81 $3A $4E $C6 $5F $DF

; Data from 20F6 to 20F6 (1 bytes)
_DATA_20F6_:
.db $C9
;The above is not valid for anything. Why is there so many of these? Just random padding or
;something?
_LABEL_20F7_fadeoutandStop?:
	ld e, $1D
	rst $18	; MAPPER_PAGE2_SUB Bank 29.
	call _LABEL_74186_fadeoutandStop?
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	ret

_LABEL_2103_PSGSilence+Bankswitch:
	ld e, $1D
	rst $18	; MAPPER_PAGE2_SUB Bank 29.
	call PSG_SILENCE2
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	ret

_LABEL_210F_SWBank2GameOverandTitleScreen:
	ld a, $02
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 2.
	call _LABEL_B6E0_	;This looks like a setup part for the Game Over screen.
	jp _LABEL_1C5F_titleScreenEntryPoint
	;Yeah, this might be that after getting a game over, we switch back to the title screen.
_LABEL_211C_GameOverThenHiScoreEntry:
	ld a, $02
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 2.
	call _LABEL_B6E0_
	;My guess is that we are switch, and perform a game over here.
	ld a, $1F
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 31.
	;Switch in the bank for the name entry part.
	call _LABEL_7F131_highScoreNameandEasterEggCheck
	or a
	jp z, _LABEL_1C5F_titleScreenEntryPoint
	;If you did not entered your name, because you suck, then just bump back to the title screen.
	xor a
	ld (_RAM_C354_isroundon), a
	ld (_RAM_C398_isroundon), a
	ld (_RAM_C350_hudScrollEnable), a	;Reset some variables.
	ld a, $01
	ld (_RAM_C36C_canExitFromOptions), a
	ld hl, _DATA_74625_titleScreenMusic
	call SelectMusicBank
	ld hl, _LABEL_DFD_titleScreenMainLoop?
	ld (_RAM_C391_pointer?), hl
	call _LABEL_737_clearTilesplusfirst256bytes
	ei
	jp _LABEL_1CB2_highscore
;In case you entered anything, then show the high score list, then go back to the title screen.
_LABEL_2156_plyr1PosRelated:
	ld a, (hl)
	ld (_RAM_C70C_tempStorPlyr1), a
	inc hl
	ld (_RAM_C704_pointer), hl
	ld de, _DATA_150_
	add hl, de
	ld (_RAM_C708_plyr1PosPointer), hl
	ld de, $002A
	add hl, de
	ld (_RAM_C753_unused?), hl
	ret
;This reads from a data block, puts it into some position pointer, but I don't see it yet
;what it does.
_LABEL_216D_plyr2PosRelated:
	ld a, (hl)
	ld (_RAM_C70D_tempStorPlyr2), a
	inc hl
	ld (_RAM_C706_pointer), hl
	ld de, _DATA_150_
	add hl, de
	ld (_RAM_C70A_plyr2PosPointer), hl
	ld de, $002A
	add hl, de
	ld (_RAM_C787_unused?), hl
	ret
;The same routine for player 2.
; Data from 2184 to 2193 (16 bytes)
_DATA_2184_palette?:
.db $00 $04 $08 $0C $01 $02 $06 $07 $1B $1F $3F $10 $20 $30 $34 $39

; Data from 2194 to 21B3 (32 bytes)
_DATA_2194_palette?:
.db $00 $04 $08 $0C $01 $02 $06 $07 $1B $1F $3F $10 $20 $30 $34 $39
.dsb 16, $00

_LABEL_21B4_CreditsEntryPoint:
	call _LABEL_76F_timerBasedVDPDL
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES
	;After some time, set both palettes black.
	ld a, $17
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 23.
	ld hl, _DATA_5F900_PresentingThePitFighterTeamTiles
	ld de, $3200
	ld bc, $0600
	call _LABEL_806_loadTiles
	ld hl, _DATA_5FF00_MapDataCredits
	ld de, $3AC2
	ld bc, $0080
	call _LABEL_806_loadTiles
	ld hl, _DATA_2184_palette?
	call _LABEL_5F5_timer+pal?
	ld b, $96
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	ld a, $0C
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 12.
	ld hl, _DATA_322E2_DomarkMentalHospitalTiles.
	ld de, $26A0
	ld bc, $1160
	call _LABEL_806_loadTiles
	ld hl, _DATA_33442_
	ld de, $3802
	ld bc, $05C0
	call _LABEL_806_loadTiles
	ld hl, _DATA_33A02_letters
	ld de, $1020
	ld bc, $04C0
	call _LABEL_806_loadTiles
	ld a, $41
	ld (_RAM_C362_hudTileOffset), a
	ld (_RAM_C363_), a
	ld hl, _DATA_2184_palette?
	call _LABEL_5F5_timer+pal?
	ld a, $10
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 16.
	ld hl, _DATA_43CC0_
	call _LABEL_848_timerAndVDPThing
	call _LABEL_59C_delay+pal?
	ld hl, _DATA_2194_palette?
	call LOAD_BOTH_PALETTES
	ld a, $04
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 04.
	ld hl, _DATA_137AE_
	ld de, $3844
	ld bc, $0820
	call _LABEL_2ECC_	;This is also some tile loading, but has some small additional logic.
	ld a, $0E
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 15.
	ld hl, _DATA_3A272_MattTaylorEndingGfx
	ld de, $0020
	ld bc, $1000
	call _LABEL_806_loadTiles
	ld hl, _DATA_2184_palette?
	call _LABEL_667_delay+bgpal?
	ld a, $10
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 16.
	ld hl, _DATA_43D58_
	call _LABEL_848_timerAndVDPThing;This might be a routine for text or something like that.
	call _LABEL_2300_	;This is some tile and other data, but definetly credits related.
	ld a, $0F
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 15.
	ld hl, _DATA_3E372_MattHicksGfx
	ld de, $0020
	ld bc, $1000
	call _LABEL_806_loadTiles
	ld hl, _DATA_2184_palette?
	call _LABEL_667_delay+bgpal?
	ld a, $10
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 16.
	ld hl, _DATA_43E0B_
	call _LABEL_848_timerAndVDPThing
	call _LABEL_2300_
	ld a, $12
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 18.
	ld hl, _DATA_4AD8E_GuillameCamusGFX
	ld de, $0020
	ld bc, $1000
	call _LABEL_806_loadTiles
	ld hl, _DATA_2184_palette?
	call _LABEL_667_delay+bgpal?
	ld a, $10
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 16.
	ld hl, _DATA_43EC2_
	call _LABEL_848_timerAndVDPThing
	call _LABEL_2300_
	xor a
	ld (_RAM_C363_), a
	ld a, $02
	call _LABEL_20F7_fadeoutandStop?
	ld b, $4B
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, _DATA_2194_palette?
	ld (_RAM_C365_paletteTemp), hl
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	jp _LABEL_211C_GameOverThenHiScoreEntry
;Yes, after you go with the credits, the screen fades, and you get thrown back to the
;game over screen and so on.
_LABEL_2300_:;This is just used on the ending part only.
	ld b, $96
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_59C_delay+pal?
	ld a, $0C
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 12.
	ld de, $3A82
	ld hl, _DATA_336C2_	;No idea, maybe a bigger tilemap.
	ld bc, $0340
	call _LABEL_806_loadTiles
	ret

_LABEL_2325_:
	ld a, (ix+49)
	call _LABEL_548F_
	ld a, (iy+5)
	cp $19
	jr c, ++
	cp $1B
	jr c, +
	cp $25
	jr c, ++
	cp $27
	jr nc, ++
+:
	call +++
	ret z
	ld a, (iy+29)
	inc a
	ld (iy+29), a
	xor a
	ret

++:
	cp $09
	jr c, ++++
	cp $0B
	jr nc, +
	call _LABEL_983_
	and $03
	jr z, +++
	jp _LABEL_2437_SetAToZero

+:
	cp $0F
	jr nc, ++++
+++:
	ld hl, $2018
	ld (_RAM_C71C_nmeHitBox1?), hl
	ld c, (iy+1)
	ld b, (iy+2)
	ld (_RAM_C71E_hitbox?), bc
	ld a, (iy+3)
	ld (_RAM_C720_hitboxDamage), a
	ld e, (ix+1)
	ld d, (ix+2)
	ld c, (ix+3)
	ld hl, $2018
	jp _LABEL_23F9_

++++:
	ld a, (iy+35)
	cp $04
	jr c, +
	call _LABEL_983_
	and $03
	jr nz, +
	xor a
	inc a
	ret

+:
	ld a, (ix+35)
	cp $02
	jr c, +
	cp $04
	jp nc, _LABEL_2437_SetAToZero
	call _LABEL_983_
	and $03
	jp nz, _LABEL_2437_SetAToZero
+:
	ld a, (iy+0)
	or a
	jp z, _LABEL_2437_SetAToZero
	ld a, (iy+5)
	cp $05
	jp c, _LABEL_2437_SetAToZero
	cp $0F
	jr c, +
	cp $19
	jr c, _LABEL_2437_SetAToZero
	cp $1B
	jr c, +
	cp $25
	jr c, _LABEL_2437_SetAToZero
	cp $2D
	jr c, +
	cp $2F
	jr c, _LABEL_2437_SetAToZero
+:
	ld a, (iy+3)
	sub (ix+3)
	jr nc, +
	neg
+:
	cp $04
	jr nc, _LABEL_2437_SetAToZero
	call _LABEL_2439_
	ld a, l
	or a
	jr z, _LABEL_2437_SetAToZero
	ld (_RAM_C71C_nmeHitBox1?), hl
	ld a, c
	ld (_RAM_C720_hitboxDamage), a
	ld (_RAM_C71E_hitbox?), de
	call _LABEL_24A2_
	ld a, l
	or a
	jr z, _LABEL_2437_SetAToZero
_LABEL_23F9_:
	ld a, c
	ld (_RAM_C723_dmgSpriteYNME), a
	ld (_RAM_C721_dmgSpriteXscrnHalfNME), de
	ld a, (_RAM_C720_hitboxDamage)
	ld b, a
	ld a, c
	sub b
	jr nc, +
	neg
	ex af, af'
	ld a, (_RAM_C71D_)
	ld h, a
	ex af, af'
+:
	cp h
	jp nc, _LABEL_2437_SetAToZero
	ld c, l
	ld hl, (_RAM_C71E_hitbox?)
	ex de, hl
	or a
	sbc hl, de
	bit 7, h
	jr z, +
	ld a, h
	cpl
	ld h, a
	ld a, l
	cpl
	ld l, a
	inc hl
	ld a, (_RAM_C71C_nmeHitBox1?)
	ld c, a
+:
	ld a, h
	or a
	jr nz, _LABEL_2437_SetAToZero
	ld a, l
	cp c
	jr nc, _LABEL_2437_SetAToZero
	xor a
	inc a
	ret

_LABEL_2437_SetAToZero:
	xor a
	ret

_LABEL_2439_:
	ld a, (ix+49)
	call _LABEL_549C_
	push de
	ld a, (ix+17)
	or a
	jr nz, +
	ld a, (_RAM_C6F8_plyr2Frame?)
	dec a
	ld b, a
	srl a
	ld e, a
	ld d, $00
	ld hl, (_RAM_C70A_plyr2PosPointer)
	add hl, de
	ld a, (hl)
	add a, c
	ld c, a
	jp ++

+:
	ld a, (_RAM_C6F7_plyr1Frame?)
	dec a
	ld b, a
	srl a
	ld e, a
	ld d, $00
	ld hl, (_RAM_C708_plyr1PosPointer)
	add hl, de
	ld a, (hl)
	add a, c
	ld c, a
++:
	pop de
	push bc
	ld a, b
	add a, a
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	ld c, (iy+30)
	ld b, (iy+31)
	add hl, bc
	ld bc, $0004
	add hl, bc
	ld c, (hl)
	inc hl
	ld b, (hl)
	inc hl
	push bc
	ld a, (hl)
	inc hl
	ld b, (hl)
	bit 7, a
	jr z, +
	neg
	ld l, a
	ld h, $00
	ex de, hl
	or a
	sbc hl, de
	jr ++

+:
	ld l, a
	ld h, $00
	add hl, de
++:
	ex de, hl
	ld a, b
	pop hl
	pop bc
	add a, c
	ld b, $00
	ret

_LABEL_24A2_:
	ld e, (ix+1)
	ld d, (ix+2)
	ld c, (ix+3)
	ld b, (ix+4)
	push de
	ld a, (ix+17)
	or a
	jr z, +
	ld a, (_RAM_C6F8_plyr2Frame?)
	dec a
	ld b, a
	srl a
	ld e, a
	ld d, $00
	ld hl, (_RAM_C70A_plyr2PosPointer)
	add hl, de
	ld a, (hl)
	add a, c
	ld c, a
	jp ++

+:
	ld a, (_RAM_C6F7_plyr1Frame?)
	dec a
	ld b, a
	srl a
	ld e, a
	ld d, $00
	ld hl, (_RAM_C708_plyr1PosPointer)
	add hl, de
	ld a, (hl)
	add a, c
	ld c, a
++:
	pop de
	push bc
	ld a, b
	add a, a
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	ld c, (ix+30)
	ld b, (ix+31)
	add hl, bc
	ld c, (hl)
	inc hl
	ld b, (hl)
	inc hl
	push bc
	ld a, (hl)
	inc hl
	ld b, (hl)
	bit 7, a
	jr z, +
	neg
	ld l, a
	ld h, $00
	ex de, hl
	or a
	sbc hl, de
	jr ++

+:
	ld l, a
	ld h, $00
	add hl, de
++:
	ex de, hl
	ld a, b
	pop hl
	pop bc
	add a, c
	ld b, $00
	ret

_LABEL_250D_:
	ld a, $96
	ld (_RAM_C724_CrowdCheerAnimTimer), a
	ld a, (ix+49)
	call _LABEL_548F_
	inc (iy+27)
	ret

_LABEL_251C_:
	push af
	ld a, (_RAM_C36D_grudgematch)
	or a
	jr z, +
	pop af
	ret

+:
	ld a, (ix+49)
	call _LABEL_548F_
	ld a, (iy+32)
	or a
	jr z, +
	pop af
	add a, a
	jp ++

+:
	pop af
++:
	ld e, a
	call _LABEL_983_
	and $03
	add a, e
	add a, (ix+36)
	ld e, a
	ld a, (ix+35)
	cp $02
	jr nc, +
	ld a, $05
	add a, e
	ld e, a
	xor a
+:
	cp $02
	jr c, +
	srl e
+:
	ld a, (ix+28)
	sub e
	jr nc, +
	ld a, $01
+:
	ld (ix+28), a
	ld d, $00
	ld l, (iy+24)
	ld h, (iy+25)
	add hl, de
	ld (iy+24), l
	ld (iy+25), h
	ret

_LABEL_256F_:
	push de
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	ld a, $01
	call _LABEL_639EF_
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB If a does not change, this is Bank 1.
	pop de
	ld b, $04
	ld hl, _RAM_C725_
-:
	ld a, (hl)
	or a
	jr z, +
	inc hl
	inc hl
	inc hl
	inc hl
	djnz -
	ret

+:
	ld (hl), $01
	inc hl
	call _LABEL_983_
	and $0F
	add a, e
	ld (hl), a
	inc hl
	ld (hl), d
	inc hl
	call _LABEL_983_
	and $0F
	add a, c
	ld (hl), a
	ret

_LABEL_25A3_sprites:;This is some sprite thing definetly. It sets up some values, and calls a sprite move loop.
	xor a
	ld (_RAM_C703_spriteDrawNumber?), a	;Zero the number of sprites we have to draw.
	ld hl, _RAM_C725_
	ld b, $04
-:
	ld a, (hl)
	or a
	call nz, +
	inc hl
	inc hl
	inc hl
	inc hl
	djnz -
	ret

+:
	push hl
	push bc	;Save register values.
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld c, (hl)
	ld b, $00	;Load up DE and BC, though B will be $00 as can be seen.
	push bc	;Save this new BC.
	dec a
	and $FC
	add a, a
	ld c, a
	ld b, $00
	ld hl, $25DD
	add hl, bc
	pop bc
	call _LABEL_1425_SpriteMoveLoop?
	pop bc
	pop hl
	ld a, (hl)
	inc a
	cp $15
	jr nz, +
	xor a
+:
	ld (hl), a
	ret

; Data from 25DD to 2601 (37 bytes)
_unused_25dd:
.db $00 $5F $00 $00 $40 $00 $00 $00 $00 $60 $00 $00 $40 $00 $00 $00
.db $00 $61 $00 $00 $40 $00 $00 $00 $00 $62 $00 $00 $40 $00 $00 $00
.db $00 $63 $00 $00 $40
;This is unused data, upon disassembling it, it does not look anything valid.
; Data from 2602 to 26B1 (176 bytes)
_DATA_2602_nmeProperty:
.db $00 $7F $07 $7F $1F $8E $5A
.dsb 9, $00
.db $02 $7F $07 $7F $1F $24 $60
.dsb 9, $00
.db $01 $7F $07 $7F $1F $59 $5D
.dsb 9, $00
.db $03 $7F $07 $7F $1F $EF $62
.dsb 9, $00
.db $05 $7F $07 $7F $1F $BA $65
.dsb 9, $00
.db $06 $7F $07 $7F $1F $50 $6B
.dsb 9, $00
.db $04 $7F $07 $7F $1F $85 $68
.dsb 9, $00
.db $04 $7F $07 $7F $1F $61 $77
.dsb 9, $00
.db $08 $7F $07 $7F $1F $46 $73
.dsb 9, $00
.db $07 $7F $07 $7F $1F $2B $6F
.dsb 9, $00
.db $09 $7F $07 $7F $1F $7C $7B
.dsb 9, $00

_LABEL_26B2_enemySpecsSet?:
	ex af, af'
	ld hl, _RAM_C769_Player2defeat?
	ld de, _RAM_C769_Player2defeat? + 1
	ld bc, $0033
	ld (hl), $00
	ldir
	ld hl, $012C
	ld (_RAM_C76A_Plyr2XnScrnHalf), hl
	ld a, $78
	ld (_RAM_C76C_player2yPosition), a
	ld a, $01
	ld (_RAM_C769_Player2defeat?), a
	ld (_RAM_C77A_plyr2Attack?), a
	inc a
	ld (_RAM_C76F_plyr2Animation?), a
	inc a
	ld (_RAM_C76D_plyrDistance?), a
	ld a, $FF
	ld (_RAM_C785_plyr2Life), a
	ld a, $00
	ld (_RAM_C78D_unused?), a
	ld a, $03
	ld (_RAM_C779_plyr2specMoveCounter), a
	ex af, af'	;Setting up some variables, and getting back a.
	add a, a
	add a, a
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_2602_nmeProperty
	add hl, de
	ld a, (hl)
	inc hl
	ld (_RAM_C778_), a
	ld a, (hl)
	inc hl
	ld (_RAM_C792_chaseDistance?), a
	ld a, (hl)
	inc hl
	ld (_RAM_C793_mneAgressivity1?), a
	ld a, (hl)
	inc hl
	ld (_RAM_C794_mneRetreatDistance?), a
	ld a, (hl)
	inc hl
	ld (_RAM_C795_), a	;So these parts handle enemy behaviour.
	;I don't really sense much difference between enemies, but here, you can find the 
	;data where you could change how they behave.
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	push hl
	ex de, hl
	call _LABEL_216D_plyr2PosRelated
	pop hl
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	ret z
	ld a, (_RAM_C35B_twoplayergametype)
	cp $02
	ret nz
	ld a, $02
	ld (_RAM_C76D_plyrDistance?), a
	ret

_LABEL_272A_newGameSetup?:
	ex af, af'	;Save the current a into a shadow register.
	ld a, (_RAM_C74F_plyr1Lives)
	push af
	ld a, (_RAM_C751_plyr1Life)
	push af
	ld hl, (_RAM_C74D_)
	push hl
	ld hl, _RAM_C735_plyr1Dead
	ld de, _RAM_C735_plyr1Dead + 1
	ld bc, $0033
	ld (hl), $00
	ldir	;Also mass reset variables in RAM.
	pop hl
	ld (_RAM_C74D_), hl	;Restore back this one.
	pop af	;Retrieve the player's life.
	add a, $08	;Restore some.
	jr nc, +	
	ld a, $FF	;If we overflow with the health, just set it to the maximum.
+:
	ld (_RAM_C751_plyr1Life), a	;Put back the new health we have.
	pop af
	ld (_RAM_C74F_plyr1Lives), a	;Retrieve the number of lives.
	ld hl, $00C8
	ld (_RAM_C736_plyr1XandScrnHalf), hl
	ld a, $78
	ld (_RAM_C738_plyr1YCoordinate), a
	ld a, $01
	ld (_RAM_C735_plyr1Dead), a	;Set the player to its default position on the screen.
	xor a
	ld (_RAM_C746_), a
	ld a, $01
	ld (_RAM_C73B_plyr1Direction), a
	ld (_RAM_C74C_), a	;Set some other things.
	ld a, (_RAM_C360_difficulty)	;Get the difficulty.
	ld e, $00
	or a
	jr z, +	;If it's set to easy, jump to plus.
	ld e, $05
	cp $01	
	jr z, +	;If it's medium, jump ahead.
	ld e, $0A	;Otherwise we play on hard.
+:
	ld a, e
	ld (_RAM_C759_unused?), a	;Load this into this seemingly unused variable.
	ld a, $03
	ld (_RAM_C745_plyr1SpecMoveCounter), a	;Reload the special move counter.
	ex af, af'	;Switch back a from the shadow register.
	add a, a
	add a, a
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_2602_nmeProperty
	add hl, de
	ld a, (hl)	;Roll some enemy properties. I guess the original a is the round number.
	;Otherwise why would you do this.
	inc hl
	ld (_RAM_C744_unused?), a
	ld a, (hl)
	inc hl
	ld (_RAM_C75E_unused?), a
	ld a, (hl)
	inc hl
	ld (_RAM_C75F_unused?), a
	ld a, (hl)
	inc hl
	ld (_RAM_C760_unused?), a
	ld a, (hl)
	inc hl
	ld (_RAM_C761_unused?), a
	;Are these debug related? These variables are not used otherwise, or at least not read from.
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	push hl
	ex de, hl
	call _LABEL_2156_plyr1PosRelated
	pop hl
	ret
;From the code, I suspect this is done to init a new game player-wise, and get some enemy
;variables from ROM. There should be a similar one for player two.
; Data from 27BB to 285A (160 bytes)
_DATA_27BB_:
.db $00 $00 $03 $02 $02 $01 $00 $00 $00 $00 $00 $02 $04 $03 $06 $01
.db $00 $00 $00 $00 $02 $00 $00 $00 $00 $01 $00 $00 $00 $00 $04 $00
.db $00 $00 $00 $00 $03 $05 $04 $05 $01 $00 $00 $00 $00 $00 $04 $06
.db $05 $01 $01 $00 $00 $00 $00 $02 $00 $00 $00 $00 $01 $00 $00 $00
.db $00 $00 $05 $09 $06 $03 $01 $00 $00 $00 $00 $00 $02 $08 $07 $02
.db $01 $00 $00 $00 $00 $02 $00 $00 $00 $00 $01 $00 $00 $00 $00 $04
.db $00 $00 $00 $00 $00 $06 $05 $08 $04 $01 $00 $00 $00 $00 $00 $04
.db $07 $09 $01 $01 $00 $00 $00 $00 $02 $00 $00 $00 $00 $01 $00 $00
.db $00 $00 $00 $05 $04 $0A $03 $01 $00 $00 $00 $00 $00 $07 $09 $0B
.db $01 $01 $00 $00 $00 $00 $00 $07 $0A $01 $06 $03 $00 $00 $00 $00

_LABEL_285B_twoPlayerAndGrudge?:
	ld a, (_RAM_C35B_twoplayergametype)
	cp $02
	jr z, _LABEL_2869_twoPlayerType3MatchEnd	;If the two player game type is 3, jump to this label.
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jp nz, _LABEL_295D_	;Get the number or players, and jump here if not 1 player.
_LABEL_2869_twoPlayerType3MatchEnd:
	ld a, (_RAM_C361_practicemode)
	or a
	jr nz, +	;Jump, if we are not in practice mode.
	ld a, (_RAM_C36D_grudgematch)
	or a
	jp z, _LABEL_28FA_initGrudgeMatch	;Jump, if we are not in a grudge match (in a normal game), but here, this
	;is the opposite. I'm sure I've checked this a few times... So this type of match is supposed to work like a 
	;grudge match.
	jp _LABEL_1C5F_titleScreenEntryPoint	;Else jump back to the title screen.

+:;We are not in practice mode.
	ld a, (_RAM_C735_plyr1Dead)
	or a
	jp z, _LABEL_2A34_plyr1defeat1	;If Player 1 is dead, then jump there.
	ld a, (_RAM_C359_roundScreenNr)
	inc a
	ld (_RAM_C359_roundScreenNr), a
	;We've won the match, update the round number.
	dec a
	call _LABEL_2A08_roundNumberinfoFetch;Based on the match number, we have to do some logic, then do the checks below.
	;Basically that table lets the game know what to do based on the match number. Later on, I should decode the
	;table. If you so decide, after every match you could get a grudge match or something like that.
	ld a, (hl)	;Read from said table.
	cp $01
	jp z, _LABEL_2939_setSouthSidefor2ndplyr
	cp $02
	jp z, _LABEL_28FA_initGrudgeMatch	
	cp $03
	jp z, _LABEL_28E3_plyrNrCheckorEnding	;Go here, and check if we have to go back to the menu, or init the ending
	;based on how many players we have.
	cp $04
	jp nc, _LABEL_2957_grudgeAndIntermission?	;Here if it's greater or equal to 4.
	xor a
	ld (_RAM_C36D_grudgematch), a	;Reset the grudge match flag, we are not in one now.
	inc hl	;HL still has that table's address, increase the source address.
	ld b, (hl)
	ld c, $10
	push bc
	inc hl
	ld a, (hl)
	ld (_RAM_C358_player2char), a ;Get the enemy character.
	push hl	;Push the source to stack.
	call _LABEL_26B2_enemySpecsSet?	;Get the enemy behaviour.
	pop hl ;Get back HL.
	inc hl
	ld b, (hl)
	inc hl
	ld c, (hl)	;This should get the details for the match card, before we show it on the screen.
	call _LABEL_2DD3_showMatchCard	;Show the match card.
	xor a
	ld (_RAM_C354_isroundon), a
	ld (_RAM_C398_isroundon), a ;Set there, we are not yet in a round.
	call _LABEL_6CD_tilemap_clear ;The match card was shown, now we clear the tilemap and screen.
	ld a, $1F ;0001 1111 32
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $8A ;1000 1010	;Write to register 10. So set a raster line interrupt at line 32.
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $02
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld hl, $C5C0
	ld (_RAM_C391_pointer?), hl
	pop bc
	call _LABEL_31F5_scrollStageLeft
	jp _LABEL_1D4A_initRound	;Then init the round itself, load the stage and so on.

_LABEL_28E3_plyrNrCheckorEnding:
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr z, +	;plyr nr.=1? then jump
	xor a	;plyr nr.=2
	ld (_RAM_C359_roundScreenNr), a	;Reset the round number back to zero.
	jp _LABEL_2869_twoPlayerType3MatchEnd	;End the two player match, and jump back where we came from.

+:;Switch to ending.
	ld a, $1A
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 26.
	jp _LABEL_6BD80_InitiateEnding

_LABEL_28FA_initGrudgeMatch:
	ld a, (_RAM_C357_player1char)
	ld (_RAM_C358_player2char), a
	call _LABEL_26B2_enemySpecsSet?	;Set the second player to the same as the first, and give it enemy specs.
	ld bc, $0000
	call _LABEL_2DD3_showMatchCard
	xor a
	ld (_RAM_C354_isroundon), a
	ld (_RAM_C398_isroundon), a
	call _LABEL_6CD_tilemap_clear
	ld a, $1F
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $8A
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $02
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld hl, $C5C0
	ld (_RAM_C391_pointer?), hl
	ld bc, $0110
	call _LABEL_31F5_scrollStageLeft
	ld a, $01
	ld (_RAM_C36D_grudgematch), a
	jp _LABEL_1D4A_initRound

_LABEL_2939_setSouthSidefor2ndplyr:
	ld a, $03
	ld (_RAM_C358_player2char), a	;Set Southside Jim for the second player/enemy.
	ld a, (_RAM_C36D_grudgematch)
	or a
	jr z, +	;If we are not in a G.Match, then jump.
	call _LABEL_399F_southsideAndMirrorMatchSetup ;We are in one, set things up.
	jp _LABEL_285B_twoPlayerAndGrudge?
;Based on this snippet of code, it seems really, that the GM uses Southside Jim as a base.
+: ;Not a G.Match.
	xor a
	ld (_RAM_C36D_grudgematch), a ;Set up the non GM.
	ld e, $1C
	rst $18	; MAPPER_PAGE2_SUB Bank 28.
	call _LABEL_737B4_forkliftEvaluation
	jp _LABEL_285B_twoPlayerAndGrudge?

_LABEL_2957_grudgeAndIntermission?:
	call _LABEL_3AA3_intermission
	jp _LABEL_285B_twoPlayerAndGrudge?

_LABEL_295D_:
	ld a, (_RAM_C735_plyr1Dead)
	or a
	jr nz, +
	ld a, (_RAM_C769_Player2defeat?)
	or a
	jr z, _LABEL_297F_
	ld a, (_RAM_C8CF_)
	inc a
	ld (_RAM_C8CF_), a
	jr _LABEL_297F_

+:
	ld a, (_RAM_C769_Player2defeat?)
	or a
	jr nz, _LABEL_297F_
	ld a, (_RAM_C8CE_)
	inc a
	ld (_RAM_C8CE_), a
_LABEL_297F_:
	ld a, (_RAM_C359_roundScreenNr)
	inc a
	ld (_RAM_C359_roundScreenNr), a
	dec a
	call _LABEL_2A08_roundNumberinfoFetch
	ld a, (hl)
	cp $01
	jp z, _LABEL_29F3_
	cp $02
	jp nz, +
	ld a, (_RAM_C359_roundScreenNr)
	inc a
	ld (_RAM_C359_roundScreenNr), a
	jp _LABEL_297F_

+:
	cp $03
	jp z, _LABEL_29E9_
	cp $04
	jp nc, _LABEL_297F_
	xor a
	ld (_RAM_C36D_grudgematch), a
	inc hl
	ld b, (hl)
	ld c, $10
	push bc
	ld e, $1B
	rst $18	; MAPPER_PAGE2_SUB Bank 27.
	call _LABEL_6DD00_
	xor a
	ld (_RAM_C354_isroundon), a
	ld (_RAM_C398_isroundon), a
	call _LABEL_6CD_tilemap_clear
	ld a, $1F
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $8A
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $02
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld hl, $C5C0
	ld (_RAM_C391_pointer?), hl
	pop bc
	call _LABEL_31F5_scrollStageLeft
	ld a, $FF
	ld (_RAM_C751_plyr1Life), a
	ld (_RAM_C785_plyr2Life), a
	jp _LABEL_1D4A_initRound

_LABEL_29E9_:
	ld a, $1A
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 26.
	jp _LABEL_6BD80_InitiateEnding

_LABEL_29F3_:
	xor a
	ld (_RAM_C36D_grudgematch), a
	ld a, (_RAM_C35B_twoplayergametype)
	cp $01
	jp z, _LABEL_297F_
	ld e, $1C
	rst $18	; MAPPER_PAGE2_SUB Bank 28.
	call _LABEL_737B4_forkliftEvaluation
	jp _LABEL_297F_

_LABEL_2A08_roundNumberinfoFetch:	;a holds the round number. Eg. 3
	ld c, a	;Move into c.
	add a, a	;6
	add a, a	;12
	add a, c	;15
	ld e, a
	ld d, $00	;It's now 00E0.
	ld hl, _DATA_27BB_
	add hl, de	;DE is now used as an index to fetch data from this label.
	ret

; Data from 2A14 to 2A1F (12 bytes)
_DATA_2A14_:
.db $00 $02 $07 $09 $0D $0F $14 $16 $1A $1C $1E $1F

_LABEL_2A20_levelNumberSet:
	ld a, (_RAM_C35A_levelNumberInMenu)
	cp $0C
	jr c, +	;Get the level number, and if it's less than 12, jump ahead.
	xor a	;Else reset it.
+:
	ld e, a	;So we receive the level number, and move it to e.
	ld d, $00	;Make up a 16-bit number from it.
	ld hl, _DATA_2A14_ ;We'll load the address from the above data.
	add hl, de	;Add what we have from de to hl.
	ld a, (hl)	;Read based from the address we've fabricated.
	ld (_RAM_C359_roundScreenNr), a	;Put what we've read into this variable and return.
	ret

_LABEL_2A34_plyr1defeat1:
	di
	ld a, (_RAM_C74F_plyr1Lives)
	or a
	jp z, _LABEL_211C_GameOverThenHiScoreEntry
	call _LABEL_6CD_tilemap_clear
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES
	ld a, $FF
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $8A
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld hl, _LABEL_DFD_titleScreenMainLoop?
	ld (_RAM_C391_pointer?), hl
	ld e, $0F
	rst $18	; MAPPER_PAGE2_SUB Bank 15.
	ld hl, _DATA_3F372_graphics?
	ld de, $2DC0
	ld bc, $0A20
	call _LABEL_7EF_VDPdataLoad
	ld a, $02
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 2.
	ld hl, _DATA_B89A_
	ld de, $3982
	ld bc, $0080
	call _LABEL_7EF_VDPdataLoad
	ld de, $3B82
	ld hl, _DATA_BB1A_
	ld bc, $0080
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_75C13_gameOverMusic
	call SelectMusicBank
	ld a, (_RAM_C74F_plyr1Lives)
	or a
	jp z, _LABEL_211C_GameOverThenHiScoreEntry
	ld hl, _DATA_B7DA_
	ld de, $3C5E
	ld bc, $0306
	dec a
	jr z, +
	ld de, $3C5A
	ld bc, $030E
	dec a
	jr z, +
	ld de, $3C58
	ld hl, _DATA_B7E2_
	ld bc, $0312
+:
	call _LABEL_2EB5_vramLoad?
	ei
	xor a
	ld (_RAM_C370_verticalScroll), a
	ld hl, _DATA_1F4_
	ld (_RAM_C372_timer?), hl
	call _LABEL_2B7F_
	ld hl, _DATA_397F_paletteOptions
	call _LABEL_5F5_timer+pal?
_LABEL_2AC8_:
	ld hl, (_RAM_C372_timer?)
	dec hl
	ld (_RAM_C372_timer?), hl
	ld a, h
	or l
	jr nz, +
_LABEL_2AD3_:
	ld a, $01
	call _LABEL_20F7_fadeoutandStop?
	ld b, $64
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	jp _LABEL_211C_GameOverThenHiScoreEntry

+:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld a, (_RAM_C393_JOYPAD1)
	ld e, a
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr z, +
	ld a, (_RAM_C394_JOYPAD2)
	or e
	ld e, a
+:
	ld a, e
	or a
	jr nz, +
	ld (_RAM_C3A5_JOYPAD1_2), a
	jp _LABEL_2AC8_

+:
	ld a, (_RAM_C3A5_JOYPAD1_2)
	or a
	jr nz, _LABEL_2AC8_
	ld a, $01
	ld (_RAM_C3A5_JOYPAD1_2), a
	srl e
	jr nc, +
	ld a, $01
	ld (_RAM_C370_verticalScroll), a
	call _LABEL_2B7F_
	jp _LABEL_2AC8_

+:
	srl e
	jr nc, +
	xor a
	ld (_RAM_C370_verticalScroll), a
	call _LABEL_2B7F_
	jp _LABEL_2AC8_

+:
	ld a, e
	and $0C
	jr z, _LABEL_2AC8_
	ld a, (_RAM_C370_verticalScroll)
	or a
	jr nz, _LABEL_2AD3_
	ld a, $01
	call _LABEL_20F7_fadeoutandStop?
	ld b, $64
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	ld a, (_RAM_C359_roundScreenNr)
	dec a
	ld (_RAM_C359_roundScreenNr), a
	ld a, $FF
	ld (_RAM_C751_plyr1Life), a
	ld (_RAM_C785_plyr2Life), a
	ld a, $01
	ld (_RAM_C735_plyr1Dead), a
	ld (_RAM_C735_plyr1Dead), a
	ld a, (_RAM_C74F_plyr1Lives)
	dec a
	ld (_RAM_C74F_plyr1Lives), a
	jp _LABEL_285B_twoPlayerAndGrudge?

_LABEL_2B7F_:
	ld de, $3A42
	ld bc, $0100
	ld a, (_RAM_C370_verticalScroll)
	or a
	jr nz, +
	ld hl, _DATA_B91A_
	jp _LABEL_806_loadTiles

+:
	ld hl, _DATA_BA1A_
	jp _LABEL_806_loadTiles

; Data from 2B97 to 2B9A (4 bytes)
.db $00 $00 $00 $00

; Pointer Table from 2B9B to 2B9C (1 entries, indexed by _RAM_C359_roundScreenNr)
_DATA_2B9B_:
.dw _DATA_2C03_

; Data from 2B9D to 2BD4 (56 bytes)
_unused_2b9d:
.db $00 $00 $00 $00 $00 $00 $00 $00 $33 $2C $00 $00 $63 $2C $00 $00
.db $00 $00 $00 $00 $93 $2C $00 $00 $C3 $2C $00 $00 $00 $00 $00 $00
.db $00 $00 $F3 $2C
.dsb 10, $00
.db $23 $2D $00 $00 $53 $2D $00 $00 $83 $2D

_LABEL_2BD5_matchOrGrudge:
	ld hl, _RAM_C79D_dataPointer?
	ld de, _RAM_C79D_dataPointer? + 1
	ld bc, $002F	;47
	ld (hl), $00
	ldir	;Clear 48 bytes of RAM from this pointer on.
	ld a, (_RAM_C36D_grudgematch)
	or a
	ret nz	;If we are in a grudge match, then return. We are in a regular match, if this is zero.
	ld a, (_RAM_C359_roundScreenNr)
	dec a
	add a, a
	ld e, a
	ld d, $00
	ld hl, $2B97
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld a, d
	or e
	ret z
	ex de, hl
	ld de, _RAM_C79D_dataPointer?
	ld bc, $0030
	ldir
	ret	;Do some datamove, but i don't really understand this part very well.

; 1st entry of Pointer Table from 2B9B (indexed by _RAM_C359_roundScreenNr)
; Data from 2C03 to 2DB2 (432 bytes)
_DATA_2C03_:
.db $01 $64 $00 $B4 $00 $00 $00 $01 $03 $6E $00 $96 $00 $00 $00 $00
.db $01 $CC $01 $8C
.dsb 28, $00
.db $01 $46 $00 $B4 $00 $00 $00 $00 $01 $5A $00 $A0 $00 $00 $00 $01
.db $03 $6E $00 $8C $00 $00 $00 $00 $04 $CC $01 $B4 $00 $00 $00 $00
.db $02 $90 $01 $AA $00 $00 $00 $01 $00 $00 $00 $00 $00 $00 $00 $00
.db $02 $90 $01 $8C $00 $00 $00 $01 $02 $B8 $01 $A0 $00 $00 $00 $00
.db $02 $CC $01 $B4 $00 $00 $00 $00 $04 $50 $00 $96 $00 $00 $00 $00
.db $04 $5A $00 $A0
.dsb 12, $00
.db $02 $82 $00 $96 $00 $00 $00 $01 $03 $50 $00 $96 $00 $00 $00 $00
.db $04 $64 $00 $AA $00 $00 $00 $00 $02 $B8 $01 $A0 $00 $00 $00 $00
.db $03 $90 $01 $8C
.dsb 12, $00
.db $01 $50 $00 $8C
.dsb 12, $00
.db $01 $64 $00 $B4 $00 $00 $00 $00 $01 $A4 $01 $96 $00 $00 $00 $00
.db $01 $AE $01 $AA
.dsb 12, $00
.db $01 $90 $01 $96 $00 $00 $00 $01
.dsb 40, $00
.db $01 $90 $01 $96 $00 $00 $00 $01
.dsb 40, $00
.db $01 $5A $00 $96 $00 $00 $00 $00 $02 $A4 $01 $96 $00 $00 $00 $00
.db $03 $C8 $00 $A0 $00 $00 $00 $00 $03 $C8 $00 $AA $00 $00 $00 $00
.db $04 $2C $01 $96
.dsb 12, $00
.db $01 $6E $00 $8C $00 $00 $00 $01 $00 $00 $00 $00 $00 $00 $00 $00
.db $01 $5A $00 $B4 $00 $00 $00 $00 $04 $90 $01 $8C $00 $00 $00 $00
.db $04 $A4 $01 $A0
.dsb 12, $00

; Data from 2DB3 to 2DD2 (32 bytes)
_DATA_2DB3_palette?:
.db $00 $15 $2A $3F $01 $02 $06 $0B $0F $04 $05 $10 $20 $30 $34 $38
.db $00 $15 $2A $3F $01 $02 $06 $0B $0F $04 $05 $10 $20 $30 $34 $38

_LABEL_2DD3_showMatchCard:
	push bc
	di
	call _LABEL_6CD_tilemap_clear
	call _LABEL_737_clearTilesplusfirst256bytes
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES
	;So, reset tilemaps, and palettes.
	ld e, $10
	rst $18	; MAPPER_PAGE2_SUB Bank 16.
	ld hl, _DATA_40000_secondMatchCards
	ld de, $13A0
	ld bc, $2460
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_42460_MatchTables
	ld de, $0000
	ld bc, $12E0
	call _LABEL_7EF_VDPdataLoad
	;Swap in the right bank, and load the match card tiles into VRAM.
	ld e, $03
	rst $18	; MAPPER_PAGE2_SUB Bank 3.
	pop bc
	push bc
	call _LABEL_2E66_matchCardSelect	;My deduction is, that after we load all match card gfx, this is
	;the tilemap loading, so it will show the correct one.
	pop bc
	call _LABEL_2E4B_selectMatchCardMap	;This is also some VRAM loading thing, with some small code before it.
	xor a
	ld (_RAM_C354_isroundon), a
	ld (_RAM_C398_isroundon), a
	ld hl, _LABEL_DFD_titleScreenMainLoop?
	ld (_RAM_C391_pointer?), hl
	ld hl, _DATA_754D7_matchCardMusic	;So this might be the music for the title cards between rounds.
	call SelectMusicBank
	push hl
	ld hl, $DBF5
	ld (_RAM_C5C0_ramCodePointer1), hl
	pop hl
	ei
	ld hl, _DATA_2DB3_palette?
	call _LABEL_1F84_paletteAndDelays	;Some match title card color fade in code? It uses delays and similar things.
	xor a
	ld (_RAM_C376_menuCursorPos), a
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld a, (_RAM_C376_menuCursorPos)
	inc a
	ld (_RAM_C376_menuCursorPos), a
	cp $B4
	jr c, --
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	di
	ret
	;Yes, then wait some more, and fade colors out, and return.
_LABEL_2E4B_selectMatchCardMap:	;This is some mapdata thing, Since this is called from the match cards, I assume this selects
 ;which match card to show, based on what level we will arrive on.
	ld a, c
	add a, a
	add a, a
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	push hl
	add hl, hl
	pop de
	add hl, de
	ld de, _DATA_E382_mapdata?
	add hl, de
	ld de, $3B02
	ld bc, $0338
	jp _LABEL_2EB5_vramLoad?
	;Just as I thought, the code is executed when the match cards are displayed. Since there is already a code
	;which loads the tiles.
_LABEL_2E66_matchCardSelect:
	ld a, b
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_2E85_matchCardPointerTable
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld c, (hl)
	inc hl
	ld b, (hl)
	ex de, hl
	ld a, $3E
	sub c
	srl a
	add a, $C2
	ld e, a
	ld d, $39
	jp _LABEL_2EB5_vramLoad?

; Pointer Table from 2E85 to 2EB4 (24 entries, indexed by unknown)
_DATA_2E85_matchCardPointerTable:
.dw _DATA_E8C8_ _DATA_332_ _DATA_E988_ _DATA_332_ _DATA_EA42_ _DATA_316_ _DATA_EA58_ _DATA_316_
.dw _DATA_EB02_ _DATA_316_ _DATA_EB18_ _DATA_316_ _DATA_EBC2_ _DATA_316_ _DATA_EBD8_ _DATA_316_
.dw _DATA_EC82_ _DATA_316_ _DATA_EC98_ _DATA_316_ _DATA_ED42_ _DATA_316_ _DATA_ED58_ _DATA_316_

_LABEL_2EB5_vramLoad?:
	push bc
	push hl
	push de	;Save these regs.
	ld b, $00	;Load zero into b.
	call _LABEL_7EF_VDPdataLoad	;I guess these reg values are loaded before we call this tile load.
	pop de	;Get back de.
	ld hl, $0040	
	add hl, de
	ex de, hl	;Do some destination calculation.
	pop hl	;Get back the original source address.
	ld bc, $0040
	add hl, bc
	pop bc
	djnz _LABEL_2EB5_vramLoad?	;Loop back if the zero flag is not set.
	ret

_LABEL_2ECC_:	;This is also some additional tile load thingy, but it's only used at the credits sequence.
	push bc
	push hl
	push de	;Push the previously provided values.
	ld b, $00
	call _LABEL_806_loadTiles
	pop de
	ld hl, $0040	;Add 64 to the source address.
	add hl, de
	ex de, hl
	pop hl
	ld bc, $0040
	add hl, bc
	pop bc
	djnz _LABEL_2ECC_
	ret

_LABEL_2EE3_loadHUDandMugshots:
	di
	push bc
	ld hl, $0000
	ld (_RAM_C399_unused?), hl	;Reset this value, but it's not really used anywhere.
	ld (_RAM_C39A_matchTimer), hl	;Reset the match timer on screen.
	ld a, $51
	ld (_RAM_C362_hudTileOffset), a
	ld e, $1E
	rst $18	; MAPPER_PAGE2_SUB Bank 30.
	ld hl, _DATA_78000_hudGraphics
	ld de, $1000
	ld bc, $06A0
	call _LABEL_7EF_VDPdataLoad	;Load the match HUD graphics.
	ld e, $02
	rst $18	; MAPPER_PAGE2_SUB Bank 2.
	ld hl, _DATA_BB9A_hudTileandMap
	ld de, $18E0
	ld bc, $0700
	call _LABEL_7EF_VDPdataLoad	;Load the whole thing in. It has HUD and other graphics
	;in it.
	ld e, $1E
	rst $18	; MAPPER_PAGE2_SUB Bank 30.
	pop bc
	push bc
	ld l, b
	ld d, b
	ld h, $00
	ld e, h
	call _LABEL_2F84_getMugShots
	ld de, $16A0
	ld bc, $0120
	call _LABEL_7EF_VDPdataLoad	;I guess this is for Player 1.
	pop bc
	push bc
	ld l, c
	ld d, c
	ld h, $00
	ld e, h
	call _LABEL_2F84_getMugShots
	ld de, $17C0
	ld bc, $0120
	call _LABEL_7EF_VDPdataLoad	;And for Player 2.
	pop bc
	push bc
	ld a, b
	ld bc, $0302
	call ++
	pop bc
	ld a, c
	ld bc, $0313
	call ++
	ld a, (_RAM_C36D_grudgematch)
	or a
	jr z, +	;If we are not in a grudge match, jump ahead.
	ld hl, _DATA_1B5D_	;This small part is the grudge match path.
	jp _LABEL_848_timerAndVDPThing

+:
	ld hl, _DATA_1B08_
	call _LABEL_848_timerAndVDPThing
	ld a, (_RAM_C74C_)
	or a
	jr z, +
	ld hl, _DATA_1B49_
	call _LABEL_848_timerAndVDPThing
+:
	ld a, (_RAM_C780_)
	or a
	ret z
	ld hl, _DATA_1B53_
	call _LABEL_848_timerAndVDPThing
	ret
	
++:
	add a, a
	add a, a
	add a, a
	add a, a
	ld l, a
	ld h, $00
	ld de, _DATA_79300_forklift
	add hl, de
	call _LABEL_84C_timerAndVDPThingy
	ret

_LABEL_2F84_getMugShots:
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, _DATA_786A0_plyrNmeMugshots
	add hl, de
	ret

_LABEL_2F8F_checkForGrudge:
	ld a, (_RAM_C36D_grudgematch)
	or a
	ret nz	;Return if we are in a grudge match, else do these below:
	call _LABEL_2FA3_plyr1LifeThing
	call _LABEL_2FB4_plyr2LifeThing
	call _LABEL_2FD0_plyr1drawGrudgeMarks
	call _LABEL_2FE7_plyr2drawGrudgeMarks
	jp _LABEL_302B_hudStuff

_LABEL_2FA3_plyr1LifeThing:
	ld a, (_RAM_C36D_grudgematch)
	or a
	ret nz	;Return if we are in a grudge match.
	ld a, (_RAM_C751_plyr1Life)
	ld hl, _DATA_3096_
	ld bc, $0205
	jp +

_LABEL_2FB4_plyr2LifeThing:
	ld a, (_RAM_C36D_grudgematch)
	or a
	ret nz
	ld a, (_RAM_C785_plyr2Life)
	ld hl, _DATA_30D6_
	ld bc, $0216
+:
	srl a
	srl a
	and $38
	ld e, a
	ld d, $00
	add hl, de
	call _LABEL_84C_timerAndVDPThingy
	ret

_LABEL_2FD0_plyr1drawGrudgeMarks:	;This seems like a part to draw the grudge marks when you earn a knockdown.
	ld a, (_RAM_C36D_grudgematch)
	or a
	jp nz, +	;If we are in a grudge match, jump ahead.
	ld a, $3D
	ld (_RAM_C385_levelNumberHex), a
	ld a, (_RAM_C750_plyr1KnockDowns)
	ld l, $04
	ld bc, $0108
	jp _LABEL_3070_plyrliveLevel

_LABEL_2FE7_plyr2drawGrudgeMarks:
	ld a, (_RAM_C36D_grudgematch)
	or a
	jp nz, ++
	ld a, $3D
	ld (_RAM_C385_levelNumberHex), a
	ld a, (_RAM_C784_plyr2KnockDown);Deduced from the fact that the same function is assigned in the above code for player 1.
	ld l, $04
	ld bc, $0119
	jp _LABEL_3070_plyrliveLevel

+:
	ld bc, $0106
	ld a, (_RAM_C784_plyr2KnockDown)
	or a
	ret z
	jp +++

++:
	ld bc, $0117
	ld a, (_RAM_C750_plyr1KnockDowns)
	or a
	ret z
+++:
	cp $04
	ret nc
	dec a
	add a, a
	add a, c
	ld c, a
	ld hl, _DATA_3025_
	call _LABEL_84C_timerAndVDPThingy
	inc hl
	dec c
	dec c
	inc b
	jp _LABEL_84C_timerAndVDPThingy

; Data from 3025 to 302A (6 bytes)
_DATA_3025_:	;This is very often read after the first Grudge Match knockdown.
.db $85 $86 $00 $87 $88 $00

_LABEL_302B_hudStuff:
	ld a, (_RAM_C36D_grudgematch)
	or a
	ret nz	;Return if we are in a grudge match.
	ld a, (_RAM_C74C_)	;I have not figured out what this does. The only time the code writes to it, it's set to 1.
	or a
	jr z, +
	ld a, $3C
	ld (_RAM_C385_levelNumberHex), a
	ld a, (_RAM_C74F_plyr1Lives)
	ld l, $03
	ld bc, $020C	
	call _LABEL_3070_plyrliveLevel
	ld hl, (_RAM_C74D_)
	ld bc, $0006
	xor a
	call _LABEL_966_plyrScore
+:	;This executes if that RAM variable is zero.
	ld a, (_RAM_C780_)
	or a
	ret z
	ld a, $3C
	ld (_RAM_C385_levelNumberHex), a
	ld a, (_RAM_C783_)
	ld l, $03
	ld bc, $021D
	call _LABEL_3070_plyrliveLevel
	ld hl, (_RAM_C781_plyr2stats?)
	ld bc, $0017
	xor a
	call _LABEL_966_plyrScore
	ret

_LABEL_3070_plyrliveLevel:	;a is the amount of player lives. l is $03.
	or a
	jr nz, +	;Jump, if we have more than zero lives? Seems logical. If we lose in the grudge match, we lose a life.
	;What is strange, that this is NOT how the game works on other platforms.
	ld a, $40
	ld (_RAM_C385_levelNumberHex), a
	xor a
+:	;If the lives are zero.
	cp l	;Compare l with a.
	jr c, +	;if a<l then
	ld a, l	;Reload with 3.
+:
	ld e, l
	ld hl, _RAM_C385_levelNumberHex
-:
	push de
	push af
	call _LABEL_84C_timerAndVDPThingy
	dec hl
	pop af
	dec a
	jr nz, +
	ld a, $40
	ld (_RAM_C385_levelNumberHex), a
	xor a
+:
	pop de
	dec e
	jr nz, -
	ret

; Data from 3096 to 30D5 (64 bytes)
_DATA_3096_:
.db $61 $62 $62 $62 $62 $62 $63 $00 $5B $62 $62 $62 $62 $62 $63 $00
.db $5B $5C $62 $62 $62 $62 $63 $00 $5B $5C $5C $62 $62 $62 $63 $00
.db $5B $5C $5C $5C $62 $62 $63 $00 $5B $5C $5C $5C $5C $62 $63 $00
.db $5B $5C $5C $5C $5C $5C $63 $00 $5B $5C $5C $5C $5C $5C $5D $00

; Data from 30D6 to 3115 (64 bytes)
_DATA_30D6_:
.db $61 $62 $62 $62 $62 $62 $63 $00 $5E $62 $62 $62 $62 $62 $63 $00
.db $5E $5F $62 $62 $62 $62 $63 $00 $5E $5F $5F $62 $62 $62 $63 $00
.db $5E $5F $5F $5F $62 $62 $63 $00 $5E $5F $5F $5F $5F $62 $63 $00
.db $5E $5F $5F $5F $5F $5F $63 $00 $5E $5F $5F $5F $5F $5F $60 $00

; Data from 3116 to 3125 (16 bytes)
_DATA_3116_specmoveMapData:
.db $74 $74 $74 $00 $74 $74 $75 $00 $74 $75 $75 $00 $75 $75 $75 $00
;74 means on, and 75 is off. These are the circles on the HUD marking how many spec move we have left.
_LABEL_3126_drawSpecMoveMeter:	;This is some juicy video thing!
	ld a, (_RAM_C745_plyr1SpecMoveCounter)	;Get the special move counter. Example: 3 0011
	add a, a ;This will be six: 0110
	add a, a	;Bitshift two times. This is 12. 1100
	ld e, a
	ld d, $00	;DE is now made up of these values.
	ld hl, _DATA_3116_specmoveMapData ;$3116
	add hl, de
	ex de, hl
	push af
	ld a, $02	;0000 0010
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $38	;0111 1000
	or $40	;Result is 0111 1000 so we are writing to VRAM. Why would not just ld a, $78 then from the start?
	;The result is $3802, which is mapdata. So basically we modify the nametable\map to mark which tile to
	;draw on the screen.
	out (Port_VDPAddressControlPort), a
	pop af	
	ld a, (de)
	inc de
	out (Port_VDPData), a
	;Write one byte to VRAM.
	nop
	nop
	push af
	ld a, $42	;0100 0010
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $38
	or $40	;And this again! 
	out (Port_VDPAddressControlPort), a
	pop af
	ld a, (de)
	inc de
	out (Port_VDPData), a
	nop
	nop
	push af
	ld a, $82
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $38
	or $40
	out (Port_VDPAddressControlPort), a
	pop af
	ld a, (de)
	inc de
	out (Port_VDPData), a
	;Without commenting this unrolled loop, this will draw the spec move counter on the HUD for Player 1.
	ld a, (_RAM_C779_plyr2specMoveCounter)
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_3116_specmoveMapData
	add hl, de
	ex de, hl
	push af
	ld a, $24
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $38
	or $40
	out (Port_VDPAddressControlPort), a
	pop af
	ld a, (de)
	inc de
	out (Port_VDPData), a
	nop
	nop
	push af
	ld a, $64
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $38
	or $40
	out (Port_VDPAddressControlPort), a
	pop af
	ld a, (de)
	inc de
	out (Port_VDPData), a
	nop
	nop
	push af
	ld a, $A4
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $38
	or $40
	out (Port_VDPAddressControlPort), a
	pop af
	ld a, (de)
	inc de
	out (Port_VDPData), a
	ret
	;This is the same for player 2.
; Data from 31B5 to 31C0 (12 bytes)
_DATA_31B5_:
.db $03 $00 $80 $B6 $89 $BB $16 $A1 $0E $00 $80 $B6

; Pointer Table from 31C1 to 31C4 (2 entries, indexed by unknown)
_DATA_31C1_:
.dw $BA89 $A0F6
;I guess the ones below also belong to the table, just not used anywhere.
; Data from 31C5 to 31F4 (48 bytes)
_unused_31c5:
.db $0C $00 $80 $B6 $89 $BB $D6 $A0 $0D $00 $80 $B6 $89 $C0 $B6 $A1
.db $0F $00 $80 $B6 $89 $BC $36 $A1 $16 $00 $80 $B6 $89 $BD $56 $A1
.db $14 $00 $80 $B6 $89 $6B $16 $97 $15 $00 $80 $B6 $89 $B0 $B6 $9F

_LABEL_31F5_scrollStageLeft:	;This looks like a left scroll routine and tilemap load. There is a similar one for the right scroll.
	push bc
	push hl
	ld hl, $DBF5
	ld (_RAM_C5C0_ramCodePointer1), hl
	pop hl
	ei
	call _LABEL_55C_delay+pal?
	di
	pop bc
	push bc
	ld l, c
	ld h, $00
	ld d, h
	add hl, hl
	add hl, hl
	add hl, hl
	ld (_RAM_C33B_plyfieldborder), hl
	ld a, b
	rlca
	rlca
	rlca
	and $F8
	ld e, a
	ld hl, _DATA_31B5_
	add hl, de
	ld a, (hl)
	ld (_RAM_C344_mapperPagerTemp), a
	ld e, a
	inc hl
	rst $18	; MAPPER_PAGE2_SUB No idea yet.
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld (_RAM_C345_), de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (_RAM_C347_unused), de
	inc hl
	ld a, (hl)
	inc hl
	push hl
	ex de, hl
	ld de, $2000
	rrca
	rrca
	rrca
	ld c, a
	and $1F
	ld b, a
	ld a, c
	and $E0
	ld c, a
	ld (_RAM_C349_unused), bc
	call _LABEL_7EF_VDPdataLoad
	pop hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (_RAM_C34B_), de
	pop bc
	ld a, c
	add a, a
	ld e, a
	ld d, $00
	ld hl, $32F0
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld hl, (_RAM_C345_)
	add hl, de
	ld (_RAM_C370_verticalScroll), hl
	ld a, $42
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	nop
	ld a, $79
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	nop
	ld de, $0025
	ld c, Port_VDPData
	ld b, $13
--:
	push bc
	push hl
	ld b, $20
-:
	ld a, (hl)
	out (c), a
	nop
	nop
	nop
	nop
	inc hl
	ld a, (hl)
	out (c), a
	nop
	nop
	nop
	nop
	add hl, de
	djnz -
	pop hl
	inc hl
	inc hl
	pop bc
	djnz --
	ld hl, (_RAM_C345_)
	ld de, $09A6
	add hl, de
	ld de, _RAM_C6CD_
	ld bc, $0010
	ldir
	xor a
	ld (_RAM_C34E_playfieldcamerapos), a
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $88
	out (Port_VDPAddressControlPort), a
	nop
	nop
	call _LABEL_1A27_
	xor a
	ld (_RAM_C354_isroundon), a
	ld (_RAM_C398_isroundon), a
	push hl
	ld hl, $DBF5
	ld (_RAM_C5C0_ramCodePointer1), hl
	pop hl
	ei
	ld hl, (_RAM_C370_verticalScroll)
	ld (_RAM_C345_), hl
	ld b, $08
--:
	push bc
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	call _LABEL_3332_updateAndSetScrollRight
	pop bc
	djnz --
	ld hl, _RAM_C6CD_
	ei
	call _LABEL_5F5_timer+pal?
	ld a, $01
	ld (_RAM_C354_isroundon), a
	ret

; Data from 32F0 to 32F0 (1 bytes)
.db $00

; Data from 32F1 to 3331 (65 bytes)
_DATA_32F1_:
.db $00 $26 $00 $4C $00 $72 $00 $98 $00 $BE $00 $E4 $00 $0A $01 $30
.db $01 $56 $01 $7C $01 $A2 $01 $C8 $01 $EE $01 $14 $02 $3A $02 $60
.db $02 $86 $02 $AC $02 $D2 $02 $F8 $02 $1E $03 $44 $03 $6A $03 $90
.db $03 $B6 $03 $DC $03 $02 $04 $28 $04 $4E $04 $74 $04 $9A $04 $00
.db $00

_LABEL_3332_updateAndSetScrollRight:	;This little code gets a value from a playfield related pointer,
;checks both the high and the low byte of HL, and sets the scroll byte in RAM to right, when appropriate.
	ld hl, (_RAM_C345_)	;Get a value from this pointer.
	ld de, $0474
	add hl, de	;Add these together.
	ld a, h	;Load the highest byte into a.
	cp $89
	jr c, +	;If it's less than $89, jump.
	ld a, l
	cp $80	;Check the lower byte too.
	ret nc	;If it's the same or bigger then return.
+:	;If it's smaller, also run this.
	ld hl, (_RAM_C33B_plyfieldborder)
	inc hl
	ld (_RAM_C33B_plyfieldborder), hl	;Increment the border's pointer (where it gets data from I guess)
	ld a, $01
	ld (_RAM_C356_scrollcamera), a	;Set this to scroll right.
	ret

_LABEL_334F_scrollScreenAndLoadTiles:
	ld a, (_RAM_C34E_playfieldcamerapos)
	dec a
	ld (_RAM_C34E_playfieldcamerapos), a
	ld c, a
	and $07
	cp $07
	ret nz
	ld a, (_RAM_C344_mapperPagerTemp)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	ld a, c
	inc a
	neg
	rrca
	rrca
	and $3E
	ld l, a
	ld h, $35
	ld e, (hl)
	inc l
	ld d, (hl)
	ld hl, (_RAM_C345_)
	ld bc, _DATA_49A_
	add hl, bc
	ld a, $13
-:
	ex af, af'
	ld a, e
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	nop
	nop
	ld a, d
	or $40
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	nop
	nop
	ld a, (hl)
	out (Port_VDPData), a
	inc hl
	nop
	nop
	nop
	nop
	nop
	ld a, (hl)
	out (Port_VDPData), a
	inc hl
	ex de, hl
	ld bc, $0040
	add hl, bc
	ex de, hl
	ex af, af'
	dec a
	jp nz, -
	ld hl, (_RAM_C345_)
	ld de, $0026
	add hl, de
	ld (_RAM_C345_), hl
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	ret

_LABEL_33B3_updateAndSetScrollLeft:
	ld hl, (_RAM_C345_)
	ld de, $FFDA
	add hl, de
	ld a, h
	cp $80
	ret c
	ld hl, (_RAM_C33B_plyfieldborder)
	ld a, h
	or a
	jr nz, +
	ld a, l
	cp $09
	ret c
+:
	dec hl
	ld (_RAM_C33B_plyfieldborder), hl
	ld a, $FF	;FF means scroll the screen left.
	ld (_RAM_C356_scrollcamera), a
	ret

_LABEL_33D3_scrollScreenandLoadTiles:
;Some insight from Calindro included below. I was not able to understand fully the meaning of the code.
;After the calculation of the columns, the game loads the appropriate column of tiles from the ROM.

	ld a, (_RAM_C34E_playfieldcamerapos)
	inc a
	ld (_RAM_C34E_playfieldcamerapos), a	;increase this camera variable.
	ld c, a
	and $07	;0000 0111
	ret nz	;Return if the camera position is not scrolled eight pixels.
	ld a, (_RAM_C344_mapperPagerTemp)	;Fetch the ROM Page we stored earlier. Let's use $03 here.
	;My guess is that this may be the stage's background's tile data, or where the data is stored, in which
	;bank.
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB	;Do a bankswitch.
	ld a, c	;The saved camera position is back in a.
	neg
	rrca
	rrca
	;This is like an integer division: (x/8)*2
	;Dividing by 8 then multiplying by 2 to get the index in the nametable (remember it's 2 bytes per tile) for 
	;the specified pixel x.
	and $3E	;0011 1110
	ld l, a
	ld h, $35
	ld e, (hl)
	inc l
	ld d, (hl)
	ld hl, (_RAM_C345_)	;This holds the data pointer for the column to load.
	ld bc, $2000 | _RAM_DFB4_
;Additional comments:
;[11:13 AM]Calindro: so the disassembler can't tell the signedness
;[11:14 AM]Calindro: You can replace
;    ld bc, $2000 | _RAMDFB4
;by
;ld bc, -76
;and
;    ld de, $FFDA
;by
;ld de, -38



	add hl, bc
	ld a, $13
-:
	ex af, af'
	ld a, e
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	nop
	nop
	ld a, d
	or $40
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	nop
	nop
	ld a, (hl)
	out (Port_VDPData), a
	inc hl
	nop
	nop
	nop
	nop
	nop
	ld a, (hl)
	out (Port_VDPData), a
	inc hl
	ex de, hl
	ld bc, $0040
	add hl, bc
	ex de, hl
	ex af, af'
	dec a
	jp nz, -
	ld hl, (_RAM_C345_)
	ld de, $FFDA
	add hl, de
	ld (_RAM_C345_), hl
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	ret

; Data from 3434 to 353F (268 bytes)
_unused_3434:
.db $7F $7F $5F $00 $80 $80 $80 $00 $C0 $C0 $40 $80 $E0 $E0 $E0 $20
.db $30 $F0 $F0 $E0 $EC $FC $FC $F4 $F2 $FE $FE $F8 $FA $FE $FE $78
.db $7A $FE $FE $3F $5F $7F $7F $2F $6F $7F $5F $07 $27 $3F $3F $1F
.db $3F $3F $2F $1F $7F $7F $4F $07 $39 $3F $37 $00 $0F $0F $0F $00
.db $00 $00 $00 $F8 $FB $FF $FD $FE $FD $FF $FF $4E $4D $FF $FF $FE
.db $FD $FF $FF $F8 $FE $FE $FA $E8 $E4 $FC $FC $A0 $F8 $F8 $18 $00
.db $E0 $E0 $E0 $01 $0F $0F $0E $0F $12 $1F $1D $03 $3F $3F $33 $29
.db $F1 $FF $CF $93 $63 $FF $DF $22 $C2 $FF $BF $4E $A6 $FF $DF $EC
.db $44 $FF $BF $00 $E0 $E0 $60 $E0 $38 $F8 $D8 $F0 $EE $FE $F6 $C6
.db $C3 $FF $FD $35 $33 $FF $FC $0C $03 $FF $FC $DE $01 $FF $FE $01
.db $01 $FF $FE $47 $87 $FF $FF $FD $5D $FF $BF $1C $DC $FF $BF $1E
.db $7E $7F $5F $2E $7E $7F $4F $6F $AF $FF $DF $1D $6D $7F $7F $0E
.db $18 $1F $17 $00 $01 $FF $FE $87 $80 $FF $FF $02 $40 $39 $42 $39
.db $44 $39 $46 $39 $48 $39 $4A $39 $4C $39 $4E $39 $50 $39 $52 $39
.db $54 $39 $56 $39 $58 $39 $5A $39 $5C $39 $5E $39 $60 $39 $62 $39
.db $64 $39 $66 $39 $68 $39 $6A $39 $6C $39 $6E $39 $70 $39 $72 $39
.db $74 $39 $76 $39 $78 $39 $7A $39 $7C $39 $7E $39

_LABEL_3540_crowdAnimator?:
	ld a, (_RAM_C724_CrowdCheerAnimTimer)	;Check the faster crowd cheer animation timer value.
	or a
	jr z, +	;If the timer is expired, jump.
	and $01
	jp ++

+:	;Timer is zero.
	call _LABEL_983_	;Maybe this is some crowd related thing.
	and $07
	ret nz
	ld a, (_RAM_C39E_timer)
	ld e, $00
	and $0F
	cp $08
	jr nc, +
	ld e, $01
+:
	ld a, e
++:
	ld (_RAM_C34D_animateCrowd), a
	ld a, (_RAM_C344_mapperPagerTemp)
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	ld hl, (_RAM_C345_)
	ld a, h
	sub $80
	ld h, a
	push hl
	ld de, $049A
	add hl, de
	pop de
	ld (_RAM_C370_verticalScroll), hl
	ld hl, (_RAM_C34B_)
-:
	ld c, (hl)
	inc hl
	ld a, (hl)
	cp $FF
	ret z
	ld b, a
	ld a, d
	cp b
	jr nz, +
	ld a, e
	cp c
+:
	jr c, +
	ld bc, $0005
	add hl, bc
	jp -

+:
	dec hl
	ld de, (_RAM_C370_verticalScroll)
_LABEL_3598_:
	ld c, (hl)
	inc hl
	ld a, (hl)
	cp $FF	;I guess this is also some scroll related thing.
	ret z
	cp d
	jr nz, +
	ld a, c
	cp e
+:
	ret nc
	push de
	ld e, c
	ld d, (hl)
	inc hl
	push hl
	ex de, hl
	ld de, (_RAM_C345_)
	ld a, d
	sub $80
	ld d, a
	or a
	sbc hl, de
	ld e, $10
	rst $18	; MAPPER_PAGE2_SUB Bank 16.
	ld a, $B8
	add a, h
	ld h, a
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	and $3F
	ld d, a
	ld a, (_RAM_C344_mapperPagerTemp)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	ld e, d
	ld a, (_RAM_C34E_playfieldcamerapos)
	cpl
	rrca
	rrca
	and $3E
	add a, e
	add a, $04
	and $3F
	ld e, a
	ld a, l
	and $C0
	or e
	out (Port_VDPAddressControlPort), a
	ld a, h
	or $40
	out (Port_VDPAddressControlPort), a
	pop hl
	ld a, (_RAM_C34D_animateCrowd)
	or a
	jr z, +
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	inc hl
	inc hl
	jp ++

+:
	inc hl
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
++:
	ld c, Port_VDPData
	out (c), e
	nop
	nop
	nop
	nop
	out (c), d
	pop de
	jp _LABEL_3598_

; Data from 3606 to 3625 (32 bytes)
_DATA_3606_palette?:
.db $00 $2A $15 $38 $20 $10 $03 $02 $01 $06 $07 $0B $0F $07 $0D $3F
.db $00 $2A $15 $30 $20 $10 $03 $02 $01 $06 $07 $0B $0F $07 $0D $3F

_LABEL_3626_optionsEntryPoint:
;This is the options part, where you can change settings. Without that many comments, it can be still seen
;what it does. A bigger logic part is not commented, it's not clear yet that one does, but it does not matter that much.
	ld sp, $DFF8
	xor a
	ld (_RAM_C36C_canExitFromOptions), a	;Set that we could exit from the options.
	ei
	ld a, $03
	call _LABEL_20F7_fadeoutandStop?	;Stop the previous music, I presume. Address C223 put to FF will
	;fade out the music, and stop it. No sound updates will be done in RAM.
	ld b, $64
--:
	xor a
	ld (_RAM_C3A2_timerml), a	;Reset this timer.
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	ld a, $E0	;1110 0000
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $81	;1000 0001	;We write to VDP Register 1:
		;Turn on the display.
		;Enable interrupts.
		;Set sprites to 8x8 in size.
	out (Port_VDPAddressControlPort), a
	nop
	nop
	xor a
	ld (_RAM_C8B7_showSpriteHScore), a
	call +
	jp _LABEL_1C5F_titleScreenEntryPoint	;Options loop end.

+:
	di
	call _LABEL_6CD_tilemap_clear	
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES	;Clear tilemap and reset both palettes to black.
	ld e, $14
	rst $18	; MAPPER_PAGE2_SUB Bank 20. Switch to the bank containing the graphics for the Options menu.
	ld hl, _DATA_518A4_OptionsScreenTileset
	ld de, $18E0
	ld bc, $1F20
	call _LABEL_7EF_VDPdataLoad	;And load the graphics into VRAM.
	ld e, $0D
	rst $18	; MAPPER_PAGE2_SUB Bank 13. Load the other bank containing the second part of the Options tileset.
	ld hl, _DATA_363F2_optionsTiles
	ld de, $0020
	ld bc, $0C60
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_37052_
	ld de, $3842
	ld bc, $05C0
	call _LABEL_7EF_VDPdataLoad	;Loading some other tiles and tilemaps. The above data label is most
	;probably a tilemap, since it has no resemblance of any graphics.
	xor a
	ld (_RAM_C354_isroundon), a
	ld (_RAM_C398_isroundon), a	
	ld hl, _LABEL_DFD_titleScreenMainLoop?
	ld (_RAM_C391_pointer?), hl
	ld hl, _DATA_75360_optionsMusic ;This should be the music for the title screen.
	call SelectMusicBank
	ld a, $E1
	ld (_RAM_C362_hudTileOffset), a
	ei
	call _LABEL_37F1_optionsMenuSwitches
	ld hl, _DATA_3606_palette?
	call _LABEL_5F5_timer+pal?	;
	ld hl, $0000
	ld (_RAM_C33B_plyfieldborder), hl
	ld (_RAM_C33D_playFieldBaseHeight), hl
	xor a
	ld (_RAM_C376_menuCursorPos), a
	ld (_RAM_C703_spriteDrawNumber?), a
_LABEL_36C4_optionsMainLoop:	;From a first look, this could be the options part joypad and menu handler.
	xor a
	ld (_RAM_C3A2_timerml), a	;Reset this almost globally used timer. I'm very sure, that this is updated in VBLANK.
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -	;As seen many times, loop back to - when this is zero.
	ld hl, $396D
	call _LABEL_37D0_menuCursorPos?	;HL is pushed in a linked sprite routine, but this puts the cursor on the screen, i'm sure.
	ld a, (_RAM_C393_JOYPAD1)
	ld e, a
	ld a, (_RAM_C394_JOYPAD2)
	or e
	or a
	jr nz, +	;My guess here is, that it checks if any button is pressed on a joypad, and jump ahead and process it.
				
	xor a
	ld (_RAM_C3A5_JOYPAD1_2), a
	jp _LABEL_36C4_optionsMainLoop	;If nothing was pressed, then loop back.

+:	;We have pressed a button, so there is some processing to do.
	ld e, a
	ld a, (_RAM_C3A5_JOYPAD1_2)	;I have not mapped this variable yet. TODO
	or a
	jr nz, _LABEL_36C4_optionsMainLoop	;Jump back to the options loop, if this is not pressed.
	inc a
	ld (_RAM_C3A5_JOYPAD1_2), a
	ld a, e
	and $20	;0010 0000	Fire Button 2
	jr nz, +++
	ld a, e
	and $10 ;0001 0000	Fire Button 1
	jr nz, _LABEL_3745_processMenuButton
	ld a, e
	and $04	;0000 0100	Left
	jr z, ++
	ld a, (_RAM_C376_menuCursorPos)
	cp $08	;0000 1000	Right
	jr z, _LABEL_36C4_optionsMainLoop
	inc a
	cp $05	;0000 0101	Left and\or up?
	jr nz, +
	inc a	;This part should be the joypad button evaluation.
+:
	ld (_RAM_C376_menuCursorPos), a
	jp _LABEL_36C4_optionsMainLoop

++:	;Left button check.
	ld a, e
	and $08	;Check for the right button? I guess if you press both left and right, it should just do nothing.
	jp z, _LABEL_36C4_optionsMainLoop
	ld a, (_RAM_C376_menuCursorPos)
	or a
	jr z, _LABEL_36C4_optionsMainLoop	;If we are at the very first option and press left, then do nothing.
	dec a
	cp $05
	jr nz, +	;If it's not $05, then jump.
	dec a
+:
	ld (_RAM_C376_menuCursorPos), a
	jp _LABEL_36C4_optionsMainLoop	;Write back the value, and return to the main loop.

+++:	;It seems this exits the option menu, fade out the music, switch all palette to black.
	ld a, $03
	call _LABEL_20F7_fadeoutandStop?
	ld b, $64
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	ret

_LABEL_3745_processMenuButton:
	ld a, (_RAM_C376_menuCursorPos)
	or a
	jr nz, ++	;Get the options menu cursor's row number, if we are not setting the starting level, jump ahead.
	ld a, (_RAM_C35A_levelNumberInMenu)	;Get the current level we've set.
	inc a	;Increase it.
	cp $03	
	jr nz, +	;If a!=$03 then jump to +.
	xor a	;Otherwise set it back to zero.
+:
	ld (_RAM_C35A_levelNumberInMenu), a	;Put back the level number into memory.
	jp _LABEL_37CA_handleOptSwitch	;Change the menu's tiles accordingly.

++:	;We are not setting the starting level. 'A' still has the menu cursor position.
	dec a
	jr nz, ++	;Decrease the value, and if we have zero, we are setting the difficulty.
	;Strange choice, but works well.
	ld a, (_RAM_C360_difficulty)	;Get the difficulty value.
	inc a	;Increase the difficulty. We start on medium btw.
	cp $03	
	jr nz, +	;If we are not on 'hard' yet, jump ahead and process the button press in that way.
	xor a	;Set is back to zero, aka. 'easy'.
+:
	ld (_RAM_C360_difficulty), a
	jp _LABEL_37CA_handleOptSwitch

++:	;This is the practice mode switch of course, this is the very same deal as before.
	dec a
	jr nz, +
	ld a, (_RAM_C361_practicemode)
	inc a
	and $01
	ld (_RAM_C361_practicemode), a
	jp _LABEL_37CA_handleOptSwitch

+:	;This is the number of players.
	dec a
	jr nz, +
	ld a, (_RAM_C35F_numberofPlayers)
	inc a
	and $01
	ld (_RAM_C35F_numberofPlayers), a
	jp _LABEL_37CA_handleOptSwitch

+:	;Sound switch.
	dec a
	jr nz, +
	ld a, (_RAM_C35E_soundOnOff)
	inc a
	and $01
	ld (_RAM_C35E_soundOnOff), a
	jp _LABEL_37CA_handleOptSwitch

+:	;Set the two player game type.
	dec a
	dec a
	jr nz, ++
	ld a, (_RAM_C35B_twoplayergametype)
	inc a
	cp $03
	jr nz, +
	xor a
+:
	ld (_RAM_C35B_twoplayergametype), a
	jp _LABEL_37CA_handleOptSwitch

++:	;Setting player 1.
	dec a
	jr nz, ++
	ld a, (_RAM_C35C_plyr1character)
	inc a
	cp $0A
	jr nz, +
	xor a
+:
	ld (_RAM_C35C_plyr1character), a
	jp _LABEL_37CA_handleOptSwitch

++:	;Same for player 2.
	ld a, (_RAM_C35D_plyr2character)
	inc a
	cp $0A
	jr nz, +
	xor a
+:
	ld (_RAM_C35D_plyr2character), a
_LABEL_37CA_handleOptSwitch:
	call _LABEL_37F1_optionsMenuSwitches
	jp _LABEL_36C4_optionsMainLoop

_LABEL_37D0_menuCursorPos?:
	ld a, (_RAM_C376_menuCursorPos)
	add a, a
	add a, a
	add a, a
	add a, a
	add a, $1B
	ld b, a
	ld a, (_RAM_C39E_timer)
	srl a
	and $07
	cp $04
	jr c, +
	sub $04
	ld e, a
	ld a, $04
	sub e
+:
	add a, $18
	ld c, a
	jp _LABEL_1420_SpriteHandleroutsideMatches

_LABEL_37F1_optionsMenuSwitches: 
;This part handles the configuration on the options screen. As the RAM values are mapped out,
;it's easy to see approximately what does what.
	ld a, (_RAM_C35A_levelNumberInMenu)
	add a, $6F
	ld (_RAM_C385_levelNumberHex), a
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld hl, $3976
	call _LABEL_37D0_menuCursorPos?
	ld hl, _RAM_C385_levelNumberHex
	ld bc, $0307
	call _LABEL_84C_timerAndVDPThingy
	ld a, (_RAM_C360_difficulty)
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_3961_diffMap
	add hl, de
	ld bc, $0506
	call _LABEL_84C_timerAndVDPThingy
	ld a, (_RAM_C361_practicemode)
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_3945_practiceModeMap
	add hl, de
	ld bc, $0706
	call _LABEL_84C_timerAndVDPThingy
	ld a, (_RAM_C35F_numberofPlayers)
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_394D_nrOfPlayerMap
	add hl, de
	ld bc, $0906
	call _LABEL_84C_timerAndVDPThingy
	ld a, (_RAM_C35E_soundOnOff)
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_3959_soundOnOffMap
	add hl, de
	ld bc, $0B06
	call _LABEL_84C_timerAndVDPThingy
	ld a, (_RAM_C35B_twoplayergametype)
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_394D_nrOfPlayerMap
	add hl, de
	ld bc, $0F06
	call _LABEL_84C_timerAndVDPThingy
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld hl, $3976
	call _LABEL_37D0_menuCursorPos?
	ld a, (_RAM_C35C_plyr1character)
	add a, a
	add a, a
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_38A5_
	add hl, de
	ld bc, $1106
	call _LABEL_84C_timerAndVDPThingy
	ld a, (_RAM_C35D_plyr2character)
	add a, a
	add a, a
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_38A5_
	add hl, de
	ld bc, $1306
	call _LABEL_84C_timerAndVDPThingy
	ret

; Data from 38A5 to 3944 (160 bytes)
_DATA_38A5_:
;This is some kind of map data, based on that the code reads from this, when you select a character.
.db $23 $24
.dsb 9, $7F
.db $00 $00 $00 $00 $00 $20 $21 $22 $7F $7F $7F $7F $7F $7F $7F $7F
.db $00 $00 $00 $00 $00 $25 $26 $27 $7F $7F $7F $7F $7F $7F $7F $7F
.db $00 $00 $00 $00 $00 $28 $29 $2A $2B $2C $2D $2E $2F $30 $31 $32
.db $00 $00 $00 $00 $00 $33 $34 $35 $36 $37 $38 $39 $3A $3B $7F $7F
.db $00 $00 $00 $00 $00 $3C $3D $3E $3F $7F $7F $7F $7F $7F $7F $7F
.db $00 $00 $00 $00 $00 $40 $41 $42 $43 $44 $45 $7F $7F $7F $7F $7F
.db $00 $00 $00 $00 $00 $58 $59 $5A $5B $5C $5D $5E $7F $7F $7F $7F
.db $00 $00 $00 $00 $00 $50 $51 $52 $53 $54 $55 $56 $57 $7F $7F $7F
.db $00 $00 $00 $00 $00 $46 $47 $48 $49 $4A $4B $4C $4D $4E $4F $7F
.db $00 $00 $00 $00 $00

; Data from 3945 to 394C (8 bytes)
_DATA_3945_practiceModeMap:
.db $5F $60 $61 $00 $62 $63 $7F $00

; Data from 394D to 3958 (12 bytes)
_DATA_394D_nrOfPlayerMap:
.db $64 $65 $66 $00 $67 $68 $69 $00 $80 $81 $82 $00

; Data from 3959 to 3960 (8 bytes)
_DATA_3959_soundOnOffMap:
.db $6A $6B $7F $00 $6C $6D $6E $00

; Data from 3961 to 397E (30 bytes)
_DATA_3961_diffMap:
.db $72 $73 $74 $00 $75 $76 $77 $00 $78 $79 $7A $00 $00 $5E $00 $00
.db $00 $5F $00 $08 $40 $00 $5C $00 $00 $00 $5D $00 $08 $40

; Data from 397F to 399E (32 bytes)
_DATA_397F_paletteOptions:;My guess this is the options screen palette.
.db $00 $02 $13 $2B $01 $04 $06 $1B $1F $09 $00 $10 $20 $30 $34 $39
.db $00 $02 $13 $2B $01 $04 $06 $1B $1F $09 $00 $10 $20 $30 $34 $39

_LABEL_399F_southsideAndMirrorMatchSetup:
;Some nice VDP things ahead! This is called from code setting Southside Jim as an opponent on Grudge Matches.
;Soooo, in mirror matches, we play against him? One would have to give an AI to that opponent, so this makes sense.
;But I have to dissect the difficulty system yet.
	di
	ld a, $FF	;1111 1111
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $8A	;1000 1010	;We'll write to a VDP register 10, FF.
	out (Port_VDPAddressControlPort), a	;With this, we disable line interrupts.
	nop
	nop
	ld hl, _LABEL_DFD_titleScreenMainLoop?
	ld (_RAM_C391_pointer?), hl	;Load the title screen's main loop code start.
	call _LABEL_2103_PSGSilence+Bankswitch
	call _LABEL_6CD_tilemap_clear	;Silence sound and clear tilemaps.
	ld e, $0E
	rst $18	; MAPPER_PAGE2_SUB Bank 14.
	ld hl, _DATA_3B272_BigLetters?
	ld de, $2FA0
	ld bc, $0860
	call _LABEL_7EF_VDPdataLoad	;Load these letters into VRAM.
	ld a, (_RAM_C784_plyr2KnockDown)
	cp $03
	jr nz, +	;Check the opponent's knockdown numbers. Jump if it's not 03.
	ld e, $0E
	rst $18	; MAPPER_PAGE2_SUB Bank 14.
	ld hl, _DATA_3BAD2_
	ld de, $3A42
	ld bc, $0240
	call _LABEL_2EB5_vramLoad?
	ld hl, _DATA_3BB52_
	ld de, $3B42
	ld bc, $0240
	call _LABEL_2EB5_vramLoad?	;These are certainly some tilemaps, which are getting loaded during this time. I mean if the 
	;player 2 knockdowns are not 3.
	jp _LABEL_3A49_grudgePaletteFade	;Judging from the code, this does some palette effect, I suspect it fades things out.

+:
	ld e, $0E
	rst $18	; MAPPER_PAGE2_SUB Bank 14.
	ld hl, _DATA_3BBD2_
	ld de, $3942
	ld bc, $0240
	call _LABEL_2EB5_vramLoad?
	ld hl, _DATA_3BC52_
	ld de, $3A02
	ld bc, $0240
	call _LABEL_2EB5_vramLoad?
	ld de, $3B82
	ld bc, $0240
	ld a, (_RAM_C784_plyr2KnockDown)
	ld hl, _DATA_3BCD2_	;Two knockdown coin mark mapdata? Most probably.
	cp $02
	jr z, +	;Jump if the opponent had two knockdowns.
	ld hl, _DATA_3BD92_
	cp $01	;One knockdown.
	jr z, +
	ld hl, _DATA_3BE52_
+:
	call _LABEL_2EB5_vramLoad?
	ld hl, _DATA_3A63_
	call _LABEL_848_timerAndVDPThing
	ld a, (_RAM_C784_plyr2KnockDown)
	or a
	jr z, _LABEL_3A49_grudgePaletteFade
-:
	push af
	ld bc, $0B0C	;2828 bytes, but I think b and c is evaluated individually.
	ld hl, _DATA_3A7D_
	call _LABEL_84C_timerAndVDPThingy
	inc hl
	inc b
	dec c
	dec c
	call _LABEL_84C_timerAndVDPThingy
	dec b
	inc c
	inc c
	pop af
	dec a
	jr nz, -	;These are loadings are the opposite of each other. The source address has a six byte data, then 
	;code, but other than that, I don't know why this is done. Yet.
_LABEL_3A49_grudgePaletteFade:
	ei
	ld hl, _DATA_397F_paletteOptions
	call _LABEL_5F5_timer+pal?
	ld b, $FA
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	di
	ret

; Data from 3A63 to 3A7C (26 bytes)
_DATA_3A63_:
.db $0C $0B $89 $8A $01 $10 $89 $8A $01 $14 $89 $8A $0D $01 $0C $8B
.db $8C $01 $10 $8B $8C $01 $14 $8B $8C $00

; Data from 3A7D to 3A82 (6 bytes)
_DATA_3A7D_:
.db $85 $86 $00 $87 $88 $00

; Data from 3A83 to 3A88 (6 bytes)
_DATA_3A83_:
.db $00 $01 $1B $2F $00 $1F

; Data from 3A89 to 3AA2 (26 bytes)
_DATA_3A89_:
.db $2F $3F $20 $06 $30 $3F $3A $34 $3E $39 $00 $01 $1B $2F $00 $1F
.db $2F $3F $20 $06 $30 $3F $3A $34 $3E $39

_LABEL_3AA3_intermission:
;VDP goodness again, but this is some kind of intermission screen.
	push af
	di
	ld a, $FF
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $8A
	out (Port_VDPAddressControlPort), a	;This is the same as the one a bit above, switch off line interrupts.
	nop
	nop
	ld hl, _LABEL_DFD_titleScreenMainLoop?
	ld (_RAM_C391_pointer?), hl
	call _LABEL_2103_PSGSilence+Bankswitch
	call _LABEL_6CD_tilemap_clear	;So far, this is also the same.
	ld e, $15
	rst $18	; MAPPER_PAGE2_SUB Bank 21.
	ld hl, _DATA_56782_intermissionTiles
	ld de, $21C0
	ld bc, $1640
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_561C2_mapDataSewers?
	ld de, $3882
	ld bc, $1240
	call _LABEL_2EB5_vramLoad?
	ld hl, _DATA_56642_warriorMapData	;Wait wait, this is near the Warrior's pose between matches and on the high score screen.
	pop af
	cp $04
	jr z, +
	ld hl, _DATA_566C2_
+:
	ld de, $3D42
	ld bc, $023F
	call _LABEL_2EB5_vramLoad?
	ei
	ld hl, _DATA_3A83_
	call _LABEL_5F5_timer+pal?
	ld b, $FA
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	di
	ret

_LABEL_3B07_:
	ld a, (ix+32)
	or a
	jr z, _LABEL_3B51_
	ex af, af'
	ld a, (_RAM_C39E_timer)
	and $03
	jr nz, +
	ex af, af'
	dec a
	ld (ix+32), a
+:
	ld a, (ix+3)
	add a, $28
	ld c, a
	ld a, (_RAM_C39E_timer)
	and $0F
	cp $08
	jr c, +
	ld e, a
	ld a, $0F
	sub e
+:
	add a, c
	ld b, $00
	ld e, (ix+1)
	ld d, (ix+2)
	ld a, (ix+6)
	ld hl, $FFF8
	add hl, de
	ex de, hl
	and $01
	jr nz, +
	ld hl, $0008
	add hl, de
	ex de, hl
+:
	ld hl, _DATA_4C3A_
	xor a
	ld (_RAM_C703_spriteDrawNumber?), a
	call _LABEL_F42_timerAndSpriteMoves
_LABEL_3B51_:
	ld l, (ix+1)
	ld h, (ix+2)
	ld a, h
	or a
	jr nz, +
	ld a, l
	cp $0A
	jr nc, ++
	ld l, $0A
	ld (ix+1), l
	ld (ix+2), h
	jp ++

+:
	ld a, h
	cp $01
	jr nz, +
	ld a, l
	cp $FE
	jr c, ++
+:
	ld hl, $01FE
	ld (ix+1), l
	ld (ix+2), h
++:
	ld a, (ix+5)
	or a
	jp z, ++
	add a, a
	ld l, a
	ld h, $3C
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex de, hl
	call _LABEL_1AFE_
-:
	ld e, (ix+1)
	ld d, (ix+2)
	ld a, (ix+3)
	ld c, a
	ld b, $00
	ld a, (ix+17)
	or a
	jp z, +
	ld (_RAM_C6F1_plyr2XPosScrnHalf), de
	ld (_RAM_C6F3_plyr2YPos), bc
	ret

+:
	ld (_RAM_C6ED_plyr1XposScrnHalf), de
	ld (_RAM_C6EF_plyr1YPos), bc
	ret

++:
	ld hl, _DATA_5929_
	ld a, (ix+6)
	and $01
	jp nz, +
	ld hl, _DATA_5926_
+:
	call _LABEL_1AFE_
	jp -

; Data from 3BC9 to 3C01 (57 bytes)
_unused_3bc9:
.db $1C $0C $CC $CC $CE $CC $78 $78 $7E $78 $00 $00 $3C $00 $18 $18
.db $18 $18 $38 $38 $3C $38 $58 $58 $5C $58 $D8 $D8 $FC $D8 $D8 $D8
.db $FC $D8 $FC $FC $FC $FC $18 $18 $7E $18 $00 $00 $0C $00 $FC $FC
.db $FC $FC $C0 $C0 $FE $C0 $F8 $00 $00

; Pointer Table from 3C02 to 3C05 (2 entries, indexed by unknown)
_DATA_3C02_:
.dw _DATA_591D_ _DATA_5914_
_unused_3C06:
; Data from 3C06 to 3C75 (112 bytes)
.db $48 $59 $3E $59 $36 $59 $2E $59 $5A $59 $52 $59 $6E $59 $62 $59
.db $88 $59 $7A $59 $88 $59 $7A $59 $98 $59 $96 $59 $A0 $59 $9A $59
.db $A9 $59 $A6 $59 $B0 $59 $AC $59 $BA $59 $B4 $59 $C6 $59 $C0 $59
.db $D4 $59 $CC $59 $E2 $59 $DC $59 $EA $59 $E8 $59 $F4 $59 $EC $59
.db $02 $5A $FC $59 $0C $5A $08 $5A $26 $5A $20 $5A $18 $5A $10 $5A
.db $2F $5A $2C $5A $34 $5A $32 $5A $3C $5A $36 $5A $46 $5A $42 $5A
.db $54 $5A $4A $5A $67 $5A $5E $5A $78 $5A $70 $5A $80 $5A $87 $5A

_LABEL_3C76_markoPlaySoundEffect:
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	call _LABEL_63780_playSoundEffect
	ld e, $1B
	rst $18	; MAPPER_PAGE2_SUB Bank 27.
	ret

_LABEL_3C80_:
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	call _LABEL_639EF_
	ld e, $1B
	rst $18	; MAPPER_PAGE2_SUB Bank 27.
	ret

_LABEL_3C8A_MarkoPuzzleEntry:
	ld a, $03
	call _LABEL_20F7_fadeoutandStop?
	ld b, $96
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	di
	ld e, $1B
	rst $18	; MAPPER_PAGE2_SUB Bank 27.
	ld sp, $DFF8
	jp _LABEL_6F9C7_markoPuzzlePrepare

_LABEL_3CAD_:
	ld a, $01
	ld (ix+7), a
	ld a, $27
	call _LABEL_47A6_
	ld hl, _LABEL_405B_
	ld (ix+8), l
	ld (ix+9), h
	ld a, $FB
	ld (ix+10), a
	ld l, (ix+1)
	ld h, (ix+2)
	ld c, $03
	ld e, (iy+1)
	ld d, (iy+2)
	ld a, h
	cp d
	jr nz, +
	ld a, l
	cp e
+:
	jr nc, +
	ld c, $FD
+:
	ld a, c
	ld (ix+11), a
	ld e, $0A
	ld a, (ix+28)
	sub e
	jr nc, +
	ld a, $01
+:
	ld (ix+28), a
	ret

_LABEL_3CEF_:
	ld ix, _RAM_C735_plyr1Dead
	ld a, (_RAM_C735_plyr1Dead)
	or a
	jr nz, +
	call _LABEL_3B07_
	jp _LABEL_3D4D_

+:
	call _LABEL_40E8_
	ld a, (ix+7)
	or a
	jr z, +
	call _LABEL_3E27_
	jp ++

+:
	call _LABEL_4156_
++:
	call _LABEL_3B07_
	ld a, (_RAM_C6F5_gmplyAnim?)
	or a
	jr nz, +
	call _LABEL_2325_
	jr z, +
	call _LABEL_43B1_
	ld (ix+34), $00
+:
	ld a, (ix+34)
	cp $FF
	jr z, +
	inc a
	ld (ix+34), a
+:
	cp $14
	jr c, +
	xor a
	ld (_RAM_C758_plyrmneHit?), a
+:
	ld a, (ix+28)
	or a
	jr nz, +
	ld (ix+0), a
	ld a, $2B
	call _LABEL_47A6_
+:
	call _LABEL_42DC_
	ld (_RAM_C351_), a
_LABEL_3D4D_:
	ld ix, _RAM_C769_Player2defeat?
	ld a, (_RAM_C769_Player2defeat?)
	or a
	jr nz, +
	jp _LABEL_3B07_

+:
	ld ix, _RAM_C769_Player2defeat?
	call _LABEL_40E8_
	ld a, (ix+7)
	or a
	jr z, +
	call _LABEL_3E27_
	jp ++

+:
	call _LABEL_4156_
++:
	call _LABEL_3B07_
	ld a, (_RAM_C6F5_gmplyAnim?)
	cp $01
	jr nz, +
	call _LABEL_2325_
	jr z, +
	call _LABEL_43B1_
	ld (ix+34), $00
+:
	ld a, (ix+34)
	cp $FF
	jr z, +
	inc a
	ld (ix+34), a
+:
	cp $28
	jr c, +
	xor a
	ld (_RAM_C78C_), a
+:
	ld a, (ix+28)
	or a
	jr nz, +
	ld (ix+0), a
	ld a, $2B
	call _LABEL_47A6_
+:
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	ret z
	call _LABEL_42DC_
	ld (_RAM_C352_unused), a
	ld c, a
	ld a, (_RAM_C351_)
	or c
	ret z
	cp $02
	jp z, _LABEL_3332_updateAndSetScrollRight
	cp $01
	jp z, _LABEL_33B3_updateAndSetScrollLeft
	ld hl, (_RAM_C736_plyr1XandScrnHalf)
	ld de, (_RAM_C33B_plyfieldborder)
	or a
	sbc hl, de
	jr c, ++
	ld a, h
	or a
	jr nz, +
	ld a, l
	cp $DF
	jr c, +++
+:
	ld hl, $00DF
	add hl, de
	ex de, hl
++:
	ld (_RAM_C736_plyr1XandScrnHalf), de
+++:
	ld hl, (_RAM_C76A_Plyr2XnScrnHalf)
	ld de, (_RAM_C33B_plyfieldborder)
	or a
	sbc hl, de
	jr c, ++
	ld a, h
	or a
	jr nz, +
	ld a, l
	cp $DF
	jr c, +++
+:
	ld hl, $00DF
	add hl, de
	ex de, hl
++:
	ld (_RAM_C76A_Plyr2XnScrnHalf), de
+++:
	ld hl, (_RAM_C736_plyr1XandScrnHalf)
	call +
	ld (_RAM_C736_plyr1XandScrnHalf), hl
	ld hl, (_RAM_C76A_Plyr2XnScrnHalf)
	call +
	ld (_RAM_C76A_Plyr2XnScrnHalf), hl
	ret

+:
	ld de, (_RAM_C33B_plyfieldborder)
	or a
	sbc hl, de
	ld a, l
	cp $08
	jr nc, +
	ld hl, $0006
	add hl, de
	ret

+:
	ld hl, $00E8
	add hl, de
	ret

_LABEL_3E27_:
	ld (ix+47), $00
	cp $03
	jr z, +
	ld e, a
	ld a, (_RAM_C6F5_gmplyAnim?)
	cp $04
	ret nz
	ld a, e
	inc a
	ld (ix+7), a
	ret

+:
	ld l, (ix+8)
	ld h, (ix+9)
	jp (hl)

_LABEL_3E43_:
	ld a, (ix+10)
	inc a
	ld (ix+10), a
	cp $15
	jr nz, +
	xor a
	ld (ix+7), a
	ld (ix+5), a
	ret

+:
	ld l, (ix+1)
	ld h, (ix+2)
	ld a, (ix+6)
	ld de, $0002
	and $01
	jr nz, +
	ld de, $FFFE
+:
	add hl, de
	ld (ix+1), l
	ld (ix+2), h
	ret

_LABEL_3E71_:
	ld a, (ix+10)
	inc a
	ld (ix+10), a
	cp $40
	jr nz, +
	xor a
	ld (ix+7), a
	ld (ix+5), a
	ret

+:
	ld l, (ix+1)
	ld h, (ix+2)
	ld a, (ix+6)
	ld de, $0002
	and $01
	jr nz, +
	ld de, $FFFE
+:
	add hl, de
	ld (ix+1), l
	ld (ix+2), h
	ret

; Data from 3E9F to 3EC4 (38 bytes)
_unused_38bytes:
.db $DD $7E $0A $3D $DD $77 $0A $20 $08 $AF $DD $77 $05 $DD $77 $07
.db $C9 $FE $0A $38 $08 $DD $7E $03 $3D $DD $77 $03 $C9 $DD $7E $03
.db $C6 $02 $DD $77 $03 $C9

_LABEL_3EC5_:
	ld a, (ix+10)
	dec a
	jp z, ++
	ld (ix+10), a
	cp $0A
	jr c, +
	ld a, (ix+3)
	dec a
	ld (ix+3), a
	ret

+:
	ld a, (ix+3)
	add a, $02
	ld (ix+3), a
	ret

_LABEL_3EE4_:
	ld a, (ix+10)
	dec a
	jr nz, +++
++:
	ld a, $03
	ld (_RAM_C34F_verticalScroll), a
_LABEL_3EEF_:
	ld a, $15
	call _LABEL_47A6_
	ld a, $14
	ld (ix+10), a
	xor a
	ld (ix+11), a
	ld hl, _LABEL_3F5D_
	ld (ix+8), l
	ld (ix+9), h
	call _LABEL_250D_
	ld a, $08
	call _LABEL_251C_
	push de
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	ld a, $03
	call _LABEL_639EF_
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 3 if a is not changed during that subroutine call.
	pop de
	ret

+++:
	ld (ix+10), a
	cp $10
	jr c, +++
	ld l, (ix+1)
	ld h, (ix+2)
	ld a, (ix+11)
	or a
	jr nz, +
	dec hl
	jr ++

+:
	inc hl
++:
	ld (ix+1), l
	ld (ix+2), h
	dec (ix+3)
	ret

+++:
	ld l, (ix+1)
	ld h, (ix+2)
	ld a, (ix+11)
	or a
	jr nz, +
	dec hl
	dec hl
	dec hl
	jr ++

+:
	inc hl
	inc hl
	inc hl
++:
	ld (ix+1), l
	ld (ix+2), h
	inc (ix+3)
	ret

_LABEL_3F5D_:
	ld a, (ix+10)
	cp $14
	jr nc, +
	inc a
	ld (ix+10), a
	ret

+:
	inc a
	ld (ix+10), a
	or a
	jp z, _LABEL_3FCA_
	ld a, (ix+28)
	cp $01
	jr nz, +
	xor a
	ld (ix+28), a
+:
	ld a, (ix+11)
	or a
	jr z, +++
	dec a
	ld (ix+11), a
	cp $F0
	jr c, ++
	jr nz, +
	xor a
	ld (ix+5), a
	ld (ix+7), a
	ret

+:
	ld a, $17
	jp _LABEL_47A6_

++:
	ld a, $15
	jp _LABEL_47A6_

+++:
	ld a, $13
	call _LABEL_47A6_
	ld a, (ix+4)
	cp $03
	jr c, +
	ld a, $10
	jp ++

+:
	ld hl, _RAM_C393_JOYPAD1
	cp $01
	jr z, +
	ld hl, _RAM_C394_JOYPAD2
+:
	ld a, (hl)
++:
	and $10
	ret z
	call _LABEL_983_
	and $07
	jr z, _LABEL_3FCA_
	ld a, $14
	ld (ix+11), a
	ret

_LABEL_3FCA_:
	ld a, $FF
	ld (ix+11), a
	ret

_LABEL_3FD0_:
	ld a, (ix+10)
	dec a
	ld (ix+10), a
	ret nz
	xor a
	ld (ix+5), a
	ld (ix+7), a
	ret

_LABEL_3FE0_:
	ld a, (ix+10)
	cp $1F
	jr nz, +
	ld a, (ix+3)
	sub $08
	ld (ix+3), a
	ld a, $1F
+:
	dec a
	ld (ix+10), a
	or a
	ret nz
	ld a, (ix+3)
	add a, $08
	ld (ix+3), a
	xor a
	ld (ix+7), a
	ld (ix+5), a
	ret

_LABEL_4007_:
	ld a, (ix+12)
	or a
	jr z, +
	ld a, (ix+11)
	cp $24
	jr nz, +++
	jp ++

+:
	ld a, (ix+11)
	cp $29
	jr nz, +++
++:
	xor a
	ld (ix+7), a
	ld (ix+5), a
	ret

+++:
	inc a
	ld (ix+11), a
	sub $06
	ret c
	srl a
	srl a
	sub $04
	ld c, (ix+1)
	ld b, (ix+2)
	ld d, (ix+3)
	add a, d
	ld d, a
	ld l, (ix+10)
	ld h, $00
	bit 7, l
	jr z, +
	ld h, $FF
+:
	add hl, bc
	call _LABEL_40D0_
	jr z, +
	push bc
	pop hl
+:
	ld (ix+1), l
	ld (ix+2), h
	ld (ix+3), d
	ret

_LABEL_405B_:
	ld a, (ix+10)
	inc a
	cp $80
	jr nc, ++
	cp $05
	jr c, ++
	jr nz, +
	ld a, $03
	ld (_RAM_C34F_verticalScroll), a
	ld a, $05
+:
	ld (ix+10), a
	cp $14
	jr nz, +++
	jp _LABEL_3EEF_

++:
	ld (ix+10), a
	add a, (ix+3)
	ld (ix+3), a
+++:
	ld a, (ix+11)
	ld l, a
	ld h, $00
	and $80
	jr z, +
	ld h, $FF
+:
	ld e, (ix+1)
	ld d, (ix+2)
	add hl, de
	ld (ix+1), l
	ld (ix+2), h
	ret

_LABEL_409D_:
	ld a, (ix+10)
	inc a
	cp $05
	jr nz, +
	xor a
	ld (ix+7), a
	ld (ix+5), a
	ret

+:
	ld (ix+10), a
	add a, (ix+3)
	ld (ix+3), a
	ld a, (ix+11)
	ld l, a
	ld h, $00
	and $80
	jr z, +
	ld h, $FF
+:
	ld e, (ix+1)
	ld d, (ix+2)
	add hl, de
	ld (ix+1), l
	ld (ix+2), h
	ret

_LABEL_40D0_:
	ld a, h
	or a
	jr nz, +
	ld a, l
	cp $0A
	jr c, ++
	xor a
	ret

+:
	cp $02
	jr nc, ++
	ld a, l
	cp $FE
	jr nc, ++
	xor a
	ret

++:
	inc a
	ret

_LABEL_40E8_:
	xor a
	ld (ix+48), a
	ld a, (ix+5)
	cp $03
	jr c, +
	cp $05
	ret c
	cp $09
	jr c, +
	cp $0B
	ret c
+:
	cp $0F
	ret z
	cp $10
	ret z
	ld c, $02
	ld l, (ix+1)
	ld h, (ix+2)
	ld a, h
	or a
	jr nz, +
	ld a, l
	cp $20
	jr c, ++
	ret

+:
	ld c, $FE
	ld a, l
	cp $E1
	ret c
++:
	call _LABEL_983_
	and $03
	ret nz
	ld a, $01
	ld (ix+7), a
	ld a, (ix+6)
	and $03
	add a, $0E
	ld (ix+5), a
	ld hl, $409D
	ld (ix+8), l
	ld (ix+9), h
	ld a, $FB
	ld (ix+10), a
	ld a, c
	ld (ix+11), a
	call _LABEL_47CD_
	ld a, $01
	ld (ix+48), a
	ld a, (ix+4)
	cp $08
	ret c
	ld a, $03
	ld (ix+4), a
	ret

_LABEL_4156_:
	ld a, (ix+0)
	cp $01
	ret nz
	ld hl, _RAM_C393_JOYPAD1
	ld a, (ix+4)
	cp $03
	jr c, +
	call _LABEL_5200_
	ld hl, _RAM_C397_enemyState
	ld (hl), a
	xor a
	ld (ix+47), a
	jp ++

+:
	and $01
	jr nz, ++
	ld hl, _RAM_C394_JOYPAD2
++:
	ld (_RAM_C395_), hl
	call _LABEL_4306_
	ld a, (hl)
	ld e, a
	and $30
	jr z, ++
	and $20
	jr z, +
	ld a, e
	and $10
	jp nz, _LABEL_458C_
	ld a, e
	and $08
	jp nz, _LABEL_4519_
	ld a, e
	and $0C
	jp z, _LABEL_44D9_
+:
	ld a, e
	and $10
	jr z, ++
	ld a, e
	and $08
	jp nz, _LABEL_4553_
	ld a, e
	and $0C
	jp z, _LABEL_448A_
	ld a, e
	and $04
	jp nz, _LABEL_47B4_
++:
	xor a
	ld (ix+5), a
	ld a, e
	and $0F
	ret z
	ld c, (ix+1)
	ld b, (ix+2)
	ld d, (ix+3)
	srl e
	jr nc, _LABEL_4207_
	ld a, b
	or a
	jr z, +
	ld a, c
	cp $FE
	jr c, +
	call _LABEL_42A5_
	jp _LABEL_4207_

+:
	inc bc
	ld a, e
	and $20
	jr z, +
	ld a, (ix+6)
	ld (ix+5), a
	jp ++

+:
	ld a, $01
	ld (ix+6), a
	ld (ix+5), a
++:
	push bc
	push de
	ld (_RAM_C370_verticalScroll), bc
	ld a, d
	ld (_RAM_C372_timer?), a
	call _LABEL_47EA_
	pop de
	pop bc
	or a
	jr z, _LABEL_4207_
	ld a, $01
	ld (ix+47), a
	dec bc
_LABEL_4207_:
	srl e
	jr nc, _LABEL_4249_
	ld a, b
	or a
	jr nz, +
	ld a, c
	cp $0A
	jr nc, +
	call _LABEL_42A5_
	jp _LABEL_4249_

+:
	dec bc
	ld a, e
	and $10
	jr z, +
	ld a, (ix+6)
	ld (ix+5), a
	jp ++

+:
	ld a, $02
	ld (ix+6), a
	ld (ix+5), a
++:
	push bc
	push de
	ld (_RAM_C370_verticalScroll), bc
	ld a, d
	ld (_RAM_C372_timer?), a
	call _LABEL_4836_
	pop de
	pop bc
	or a
	jr z, _LABEL_4249_
	ld a, $02
	ld (ix+47), a
	inc bc
_LABEL_4249_:
	srl e
	jr nc, _LABEL_4272_
	ld a, d
	cp $9C
	jr nz, +
	call _LABEL_42A5_
	jp _LABEL_4272_

+:
	inc d
	ld a, (ix+6)
	ld (ix+5), a
	push bc
	push de
	ld (_RAM_C370_verticalScroll), bc
	ld a, d
	ld (_RAM_C372_timer?), a
	call _LABEL_4877_
	pop de
	pop bc
	or a
	jr z, _LABEL_4272_
	dec d
_LABEL_4272_:
	srl e
	jr nc, ++
	ld a, d
	cp $6C
	jr nz, +
	call _LABEL_42A5_
	jp ++

+:
	dec d
	ld a, (ix+6)
	ld (ix+5), a
	push bc
	push de
	ld (_RAM_C370_verticalScroll), bc
	ld a, d
	ld (_RAM_C372_timer?), a
	call _LABEL_4877_
	pop de
	pop bc
	or a
	jr z, _LABEL_4272_
	inc d
++:
	ld (ix+1), c
	ld (ix+2), b
	ld (ix+3), d
	ret

_LABEL_42A5_:
	ld a, (ix+4)
	cp $06
	ret nz
	ld a, $03
	ld (ix+4), a
	ret

-:
	ld l, (ix+1)
	ld h, (ix+2)
	ld de, (_RAM_C33B_plyfieldborder)
	or a
	sbc hl, de
	ld a, h
	cp $C8
	jp nc, ++
	cp $01
	jp nc, +
	ld a, l
	cp $07
	jp c, ++
	cp $E8
	jp nc, +
	xor a
	ret

+:
	ld a, $02
	ret

++:
	ld a, $01
	ret

_LABEL_42DC_:
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr nz, -
	ld l, (ix+1)
	ld h, (ix+2)
	ld de, (_RAM_C33B_plyfieldborder)
	or a
	sbc hl, de
	ld a, h
	cp $C8
	jp nc, _LABEL_33B3_updateAndSetScrollLeft
	cp $01
	jp nc, _LABEL_3332_updateAndSetScrollRight
	ld a, l
	cp $40
	jp c, _LABEL_33B3_updateAndSetScrollLeft
	cp $A8
	jp nc, _LABEL_3332_updateAndSetScrollRight
	ret

_LABEL_4306_:
	ld a, (ix+3)
	cp $6C
	ret nc
	ld a, (ix+5)
	cp $0F
	jr c, +
	cp $19
	jr nc, +
	ld a, $74
	ld (ix+3), a
+:
	ld a, (hl)
	and $F3
	or $04
	ld (hl), a
	ret

_LABEL_4323_:
	ld a, (ix+5)
	cp $11
	jr c, +
	cp $13
	ret nc
+:
	xor a
	ld (ix+33), a
	ld a, $01
	ld (ix+7), a
	dec a
	ld (ix+10), a
	ld (ix+11), a
	ld a, (ix+6)
	and $03
	add a, $10
	ld (ix+5), a
	ld hl, $3F5D
	ld (ix+8), l
	ld (ix+9), h
	call _LABEL_250D_
	ld a, $08
	call _LABEL_251C_
	push de
	ld e, $18 
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	ld a, $03
	call _LABEL_639EF_
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB Bank 3 if a has not changed during the subroutine call.
	pop de
	ret

_LABEL_4368_:
	ld a, $01
	ld (ix+7), a
	ld a, $27
	call _LABEL_47A6_
	ld hl, _LABEL_405B_
	ld (ix+8), l
	ld (ix+9), h
	ld a, $FB
	ld (ix+10), a
	ld l, (ix+1)
	ld h, (ix+2)
	ld c, $03
	ld e, (iy+1)
	ld d, (iy+2)
	ld a, h
	cp d
	jr nz, +
	ld a, l
	cp e
+:
	jr nc, +
	ld c, $FD
+:
	ld a, c
	ld (ix+11), a
	ld a, $08
	call _LABEL_251C_
	push de
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	ld a, $05
	call _LABEL_639EF_
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	pop de
	ret

_LABEL_43B1_:
	ld a, (ix+5)
	cp $11
	jr c, +
	cp $2F
	ret c
	cp $33
	jr c, +
	ret

+:
	call _LABEL_50CA_
	call _LABEL_47CD_
	ld bc, (_RAM_C723_dmgSpriteYNME)
	ld de, (_RAM_C721_dmgSpriteXscrnHalfNME)
	ld b, $00
	call _LABEL_256F_
	ld a, (iy+15)
	cp $07
	jp z, _LABEL_4474_
	cp $09
	jp z, _LABEL_4474_
	cp $06
	jp z, _LABEL_447F_
	cp $04
	jr nz, _LABEL_43F1_
	ld a, (iy+5)
	cp $28
	jp nc, _LABEL_4368_
_LABEL_43F1_:
	ld a, (ix+28)
	cp $01
	jp z, _LABEL_4323_
	inc (ix+33)
	inc (ix+35)
	call _LABEL_983_
	and $07
	add a, $07
	cp (ix+33)
	jr nc, +
	ld a, (ix+34)
	cp $3C
	jp c, _LABEL_4323_
	cp $78
	jr nc, +
	call _LABEL_983_
	and $03
	jp z, _LABEL_4323_
+:
	ld a, $01
	ld (ix+7), a
	ld a, $1F
	call _LABEL_47A6_
	ld hl, $3FD0
	ld (ix+8), l
	ld (ix+9), h
	ld a, $05
	ld (ix+10), a
	ld d, $00
	ld a, (ix+49)
	call _LABEL_548F_
	ld a, (iy+6)
	xor $03
	add a, a
	add a, a
	add a, a
	sub $0C
	jr nc, +
	sub $08
	ld d, $FF
+:
	add a, $04
	ld e, a
	ld l, (ix+1)
	ld h, (ix+2)
	add hl, de
	ld (ix+1), l
	ld (ix+2), h
	ld a, $02
	call _LABEL_251C_
	push de
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	ld a, $02
	call _LABEL_639EF_
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	pop de
	ret

_LABEL_4474_:
	ld a, (iy+5)
	cp $33
	jp c, _LABEL_43F1_
	jp _LABEL_4368_

_LABEL_447F_:
	ld a, (iy+5)
	cp $33
	jp c, _LABEL_43F1_
	jp _LABEL_4323_

_LABEL_448A_:
	ld a, e
	and $03
	jr nz, +
	ld a, (ix+6)
+:
	ld e, a
	ld a, (ix+6)
	cp e
	jp nz, _LABEL_44D8_onlyReturn
	ld a, $01
	ld (ix+7), a
	ld a, (ix+49)
	call _LABEL_54B6_
	call _LABEL_5502_
	jr z, +
	ld a, $19
	call _LABEL_47A6_
	jp ++

+:
	ld a, $05
	call _LABEL_47A6_
++:
	ld hl, $3FD0
	ld (ix+8), l
	ld (ix+9), h
	ld a, $0B
	ld (ix+10), a
	call _LABEL_505A_
	push de
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	ld a, $09
	call _LABEL_639EF_
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	pop de
	ret

_LABEL_44D8_onlyReturn:
	ret

_LABEL_44D9_:
	ld a, $01
	ld (ix+7), a
	ld a, (ix+49)
	call _LABEL_54B6_
	call _LABEL_5502_
	jr z, +
	ld a, $25
	call _LABEL_47A6_
	jp ++

+:
	ld a, (ix+6)
	and $03
	add a, $06
	ld (ix+5), a
++:
	ld hl, $3FD0
	ld (ix+8), l
	ld (ix+9), h
	ld a, $0B
	ld (ix+10), a
	push de
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	ld a, $0B
	call _LABEL_639EF_
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	pop de
	ret

_LABEL_4519_:
	ld a, $01
	ld (ix+7), a
	ld a, (ix+4)
	cp $03
	jr c, +
	ld a, e
	jr ++

+:
	ld a, (ix+6)
++:
	and $03
	ld e, a
	jr z, +
	xor $03
	add a, a
	add a, a
	sub $06
+:
	ld (ix+10), a
	ld a, $0A
	ld (ix+11), a
	ld a, e
	add a, $08
	ld (ix+5), a
	ld hl, $4007
	ld (ix+8), l
	ld (ix+9), h
	ld a, $01
	ld (ix+12), a
	ret

_LABEL_4553_:
	ld a, $01
	ld (ix+7), a
	ld a, (ix+4)
	cp $03
	jr c, +
	ld a, e
	jr ++

+:
	ld a, (ix+6)
++:
	and $03
	ld e, a
	jr z, +
	xor $03
	add a, a
	add a, a
	sub $06
+:
	ld (ix+10), a
	ld a, $00
	ld (ix+11), a
	ld a, e
	add a, $02
	ld (ix+5), a
	ld hl, $4007
	ld (ix+8), l
	ld (ix+9), h
	xor a
	ld (ix+12), a
	ret

_LABEL_458C_:
	ld a, (ix+16)
	or a
	ret z
	dec a
	ld (ix+16), a
	ld a, (ix+15)
	cp $0A
	jr c, +
	xor a
+:
	ld e, a
	add a, a
	add a, e
	ld e, a
	ld d, $00
	ld hl, $45A8
	add hl, de
	jp (hl)

	jp _LABEL_4788_

	jp _LABEL_476A_

	jp _LABEL_46EF_

	jp _LABEL_467D_

	jp _LABEL_4664_

	jp _LABEL_448A_

	jp _LABEL_464C_

	jp _LABEL_462E_

	jp _LABEL_4606_

-:
	call _LABEL_983_
	and $03
	cp $03
	jr z, -
	or a
	jp z, _LABEL_467D_
	cp $01
	jr z, +
	ld a, $01
	ld (ix+7), a
	ld a, $39
	call _LABEL_47A6_
	ld hl, $3FD0
	ld (ix+8), l
	ld (ix+9), h
	ld a, $1F
	ld (ix+10), a
	ret

+:
	ld a, $01
	ld (ix+7), a
	ld a, $37
	call _LABEL_47A6_
	ld hl, $3FD0
	ld (ix+8), l
	ld (ix+9), h
	ld a, $10
	ld (ix+10), a
	ret

_LABEL_4606_:
	ld a, $01
	ld (ix+7), a
	ld a, (ix+6)
	and $03
	jr z, +
	xor $03
	add a, a
	add a, a
	sub $06
+:
	ld (ix+10), a
	xor a
	ld (ix+11), a
	ld a, $35
	call _LABEL_47A6_
	ld hl, $4007
	ld (ix+8), l
	ld (ix+9), h
	ret

_LABEL_462E_:
	call _LABEL_567B_
	ld a, c
	or a
	ret z
	ld a, $01
	ld (ix+7), a
	ld a, $35
	call _LABEL_47A6_
	ld hl, $3E71
	ld (ix+8), l
	ld (ix+9), h
	xor a
	ld (ix+10), a
	ret

_LABEL_464C_:
	ld a, $01
	ld (ix+7), a
	ld a, $33
	call _LABEL_47A6_
	ld hl, $3E43
	ld (ix+8), l
	ld (ix+9), h
	xor a
	ld (ix+10), a
	ret

_LABEL_4664_:
	ld a, $01
	ld (ix+7), a
	ld a, $29
	call _LABEL_47A6_
	ld hl, $3FD0
	ld (ix+8), l
	ld (ix+9), h
	ld a, $10
	ld (ix+10), a
	ret

_LABEL_467D_:
	call _LABEL_5664_
	ret z
	ld a, $01
	ld (ix+7), a
	ld a, $21
	call _LABEL_47A6_
	ld hl, $3E9F
	ld (ix+8), l
	ld (ix+9), h
	ld a, $1A
	ld (ix+10), a
	ld a, (ix+49)
	call _LABEL_548F_
	call _LABEL_47DD_
	call _LABEL_5100_
	ld a, $01
	ld (iy+7), a
	ld a, (iy+6)
	and $03
	add a, $22
	ld (iy+5), a
	ld hl, _LABEL_3EC5_
	ld (iy+8), l
	ld (iy+9), h
	ld a, $1A
	ld (iy+10), a
	ld a, (ix+6)
	ld de, $000C
	and $01
	jr nz, +
	ld de, $FFF4
+:
	ld l, (ix+1)
	ld h, (ix+2)
	add hl, de
	ld (iy+1), l
	ld (iy+2), h
	ld a, (ix+3)
	sub $04
	ld (iy+3), a
	ld a, (ix+6)
	xor $03
	and $01
	ld (iy+11), a
	ret

_LABEL_46EF_:
	call _LABEL_5664_
	jr z, _LABEL_4762_
	ld a, $01
	ld (ix+7), a
	ld a, $1B
	call _LABEL_47A6_
	ld hl, $3FD0
	ld (ix+8), l
	ld (ix+9), h
	ld a, $24
	ld (ix+10), a
	ld a, (ix+49)
	call _LABEL_548F_
	call _LABEL_47DD_
	call _LABEL_5100_
	ld a, $01
	ld (iy+7), a
	ld a, (iy+6)
	and $03
	add a, $1C
	ld (iy+5), a
	ld hl, _LABEL_3EE4_
	ld (iy+8), l
	ld (iy+9), h
	ld a, $20
	ld (iy+10), a
	ld a, (ix+6)
	ld de, $000C
	and $01
	jr nz, +
	ld de, $FFF4
+:
	ld l, (ix+1)
	ld h, (ix+2)
	add hl, de
	ld (iy+1), l
	ld (iy+2), h
	ld a, (ix+3)
	sub $04
	ld (iy+3), a
	ld a, (ix+6)
	xor $03
	and $01
	ld (iy+11), a
	ret

_LABEL_4762_:
	ld a, (ix+16)
	inc a
	ld (ix+16), a
	ret

_LABEL_476A_:
	ld a, $01
	ld (ix+7), a
	ld a, (ix+6)
	and $03
	add a, $0C
	ld (ix+5), a
	ld hl, $3FD0
	ld (ix+8), l
	ld (ix+9), h
	ld a, $1F
	ld (ix+10), a
	ret

_LABEL_4788_:
	ld a, $01
	ld (ix+7), a
	ld a, (ix+6)
	and $03
	add a, $0A
	ld (ix+5), a
	ld hl, $3FE0
	ld (ix+8), l
	ld (ix+9), h
	ld a, $1F
	ld (ix+10), a
	ret

_LABEL_47A6_:
	push de
	ld e, a
	ld a, (ix+6)
	and $03
	add a, e
	dec a
	ld (ix+5), a
	pop de
	ret

_LABEL_47B4_:
	ld a, $01
	ld (ix+7), a
	ld a, $2D
	call _LABEL_47A6_
	ld hl, $4EAC
	ld (ix+8), l
	ld (ix+9), h
	ld a, $06
	ld (ix+10), a
	ret

_LABEL_47CD_:
	ld a, (ix+14)
	or a
	ret z
	call _LABEL_4CB0_
	xor a
	ld (ix+14), a
	pop hl
	jp _LABEL_4368_

_LABEL_47DD_:
	ld a, (iy+14)
	or a
	ret z
	call _LABEL_4C89_
	xor a
	ld (iy+14), a
	ret

_LABEL_47EA_:
	ld hl, _RAM_C79D_dataPointer?
	ld b, $06
-:
	push bc
	ld a, (hl)
	or a
	jr z, +
	cp $03
	jr nc, +
	push hl
	call ++
	pop hl
+:
	ld de, $0008
	add hl, de
	pop bc
	djnz -
	xor a
	ret

++:
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld c, (hl)
	push de
	ld hl, (_RAM_C370_verticalScroll)
	ld de, $0016
	add hl, de
	pop de
	ex de, hl
	or a
	sbc hl, de
	ld a, h
	cp $FF
	ret nz
	ld a, l
	neg
	ret z
	cp $10
	ret nc
	ld a, (_RAM_C372_timer?)
	add a, $18
	sub c
	ret nc
	neg
	cp $10
	ret nc
	ld a, $01
	pop hl
	pop bc
	pop hl
	ret

_LABEL_4836_:
	ld hl, _RAM_C79D_dataPointer?
	ld b, $06
-:
	push bc
	ld a, (hl)
	or a
	jr z, +
	cp $03
	jr nc, +
	push hl
	call ++
	pop hl
+:
	ld de, $0008
	add hl, de
	pop bc
	djnz -
	xor a
	ret

++:
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld c, (hl)
	ld hl, (_RAM_C370_verticalScroll)
	or a
	sbc hl, de
	ld a, h
	or a
	ret nz
	ld a, l
	cp $10
	ret nc
	ld a, (_RAM_C372_timer?)
	add a, $18
	sub c
	ret nc
	neg
	cp $10
	ret nc
	ld a, $01
	pop hl
	pop bc
	pop hl
	ret

_LABEL_4877_:
	ld hl, _RAM_C79D_dataPointer?
	ld b, $06
-:
	push bc
	ld a, (hl)
	or a
	jr z, +
	cp $03
	jr nc, +
	push hl
	call ++
	pop hl
+:
	ld de, $0008
	add hl, de
	pop bc
	djnz -
	xor a
	ret

++:
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld c, (hl)
	ld hl, (_RAM_C370_verticalScroll)
	or a
	sbc hl, de
	ld a, h
	or a
	jr z, +
	ld a, l
	neg
	ld l, a
+:
	ld a, l
	cp $10
	ret nc
	ld a, (_RAM_C372_timer?)
	add a, $18
	sub c
	ret nc
	neg
	cp $10
	ret nc
	ld a, $01
	pop hl
	pop bc
	pop hl
	ret

_LABEL_48BD_:
	ld hl, _RAM_C79D_dataPointer?
	ld b, $06
-:
	push bc
	ld a, (hl)
	or a
	jr z, +
	cp $03
	jr nc, +
	push hl
	call ++
	pop hl
+:
	ld de, $0008
	add hl, de
	pop bc
	djnz -
	xor a
	ret

++:
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld c, (hl)
	push de
	ld hl, (_RAM_C370_verticalScroll)
	ld de, $0016
	add hl, de
	pop de
	ex de, hl
	or a
	sbc hl, de
	ld a, h
	cp $FF
	ret nz
	ld a, l
	neg
	cp $10
	ret nc
	ld a, (_RAM_C372_timer?)
	add a, $14
	sub c
	ret nc
	neg
	cp $0A
	ret nc
	ld a, $01
	pop hl
	pop hl
	pop bc
	ret

_LABEL_4908_:
	ld hl, _RAM_C79D_dataPointer?
	ld b, $06
-:
	push bc
	ld a, (hl)
	or a
	jr z, +
	cp $03
	jr nc, +
	push hl
	call ++
	pop hl
+:
	ld de, $0008
	add hl, de
	pop bc
	djnz -
	xor a
	ret

++:
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld c, (hl)
	ld hl, (_RAM_C370_verticalScroll)
	or a
	sbc hl, de
	ld a, h
	or a
	ret nz
	ld a, l
	cp $10
	ret nc
	ld a, (_RAM_C372_timer?)
	add a, $14
	sub c
	ret nc
	neg
	cp $0A
	ret nc
	ld a, $01
	pop hl
	pop hl
	pop bc
	ret

_LABEL_4949_:
	ld a, (hl)	;Read from hl.
	cp $03
	jp z, _LABEL_49F6_xorA	;that small routine just clears a, and comes back. Okay, so if it's 3, then clear a.
	inc hl
	inc hl	;hl+=2
	ld e, (hl)
	inc hl
	ld d, (hl)	;Read the next two bytes from the source.
	ex de, hl	;Save DE into HL.
	ld (_RAM_C372_timer?), hl	
	ld a, (hl)
	cp $07
	jp c, _LABEL_49F6_xorA	;Clear a if <7
	cp $09
	jp nc, _LABEL_49F6_xorA	;clear a if >9
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld b, (hl)
	inc hl
	ld a, (hl)
	cp $E0
	jp c, _LABEL_49F6_xorA
	add a, b
	ld b, a
	inc hl
	inc hl
	ld a, (hl)
	or a
	jr nz, +
	ld ix, _RAM_C769_Player2defeat?
	ld iy, _RAM_C735_plyr1Dead
	jp ++

+:
	ld ix, _RAM_C735_plyr1Dead
	ld iy, _RAM_C769_Player2defeat?
++:
	ld l, (ix+1)
	ld h, (ix+2)
	or a
	sbc hl, de
	bit 7, h
	jr z, +
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
+:
	ld a, h
	or a
	jr nz, _LABEL_49F6_xorA
	ld a, l
	cp $10
	jr nc, _LABEL_49F6_xorA
	push bc
	call _LABEL_4DA5_
	pop bc
	ld c, $10
	sub b
	jr nc, +
	ld c, $18
	neg
+:
	cp c
	jr nc, _LABEL_49F6_xorA
	ld a, (ix+5)
	cp $03
	jr c, +
	cp $05
	jr c, ++
	cp $11
	jr c, +
	cp $19
	jr c, ++
	cp $2B
	jr c, +
	cp $33
	jr c, ++
+:
	call _LABEL_3CAD_
++:
	ld hl, (_RAM_C372_timer?)
	ld a, (hl)
	ld c, $09
	cp $07
	jr z, +
	ld c, $0D
+:
	push de
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	ld a, $06
	call _LABEL_639EF_
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	pop de
	ld (hl), c
	ld a, $01
	ret

_LABEL_49F6_xorA:
	xor a
	ret

_LABEL_49F8_:
	ld hl, _RAM_C79D_dataPointer?
	ld b, $06
-:
	push bc
	ld a, (hl)
	cp $03
	jr c, +
	cp $07
	jr nc, +
	push hl
	call ++
	pop hl
+:
	ld de, $0008
	add hl, de
	pop bc
	djnz -
	xor a
	ret

++:
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld a, (hl)
	ld hl, (_RAM_C370_verticalScroll)
	ld bc, $0008
	add hl, bc
	ld c, a
	ex de, hl
	or a
	sbc hl, de
	ld a, h
	or a
	ret nz
	ld a, l
	cp $20
	ret nc
	ld a, (_RAM_C372_timer?)
	add a, $10
	sub c
	jr nc, +
	neg
+:
	cp $1C
	ret nc
	pop hl
	pop hl
	ld a, (hl)
	pop bc
	ret

_LABEL_4A40_:
	xor a
	ld (_RAM_C703_spriteDrawNumber?), a
	ld a, $06
	ld hl, _RAM_C79D_dataPointer?
-:
	push af
	ld a, (hl)
	push hl
	or a
	call nz, +
	pop hl
	ld de, $0008
	add hl, de
	pop af
	dec a
	jr nz, -
	ret

+:
	cp $12
	jr c, +
	xor a
	ld (hl), a
	ret

+:
	push hl
	cp $05
	call z, _LABEL_4AD6_
	ex af, af'
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld c, (hl)
	inc hl
	ld a, (hl)
	add a, c
	ld c, a
	ex af, af'
	push af
	push de
	add a, a
	ld e, a
	ld d, $00
	ld hl, $4AF6
	add hl, de
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	pop de
	ld b, $00
	call _LABEL_F42_timerAndSpriteMoves
	ld a, (_RAM_C39E_timer)
	and $03
	jr z, +
	pop af
	pop hl
	ret

+:
	pop af
	cp $09
	jr c, _LABEL_4AD4_
	inc a
	cp $0D
	jr nz, +
	xor a
+:
	cp $11
	jr nz, +
	xor a
+:
	pop hl
	ld (hl), a
	or a
	ret nz
	push hl
	ld de, $0007
	add hl, de
	ld a, (hl)
	pop hl
	or a
	ret z
	push hl
	ld (hl), $05
	inc hl
	inc hl
	ld a, (hl)
	cp $02
	jr c, +
	pop hl
	ld (hl), $00
	ret

+:
	inc hl
	inc hl
	xor a
	ld (hl), a
	ld de, $0003
	add hl, de
	ld (hl), a
	push de
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	ld a, $04
	call _LABEL_639EF_
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	pop de
_LABEL_4AD4_:
	pop hl
	ret

_LABEL_4AD6_:
	ld a, (_RAM_C39E_timer)
	ld e, a
	and $03
	jr nz, ++
	ld a, e
	rlca
	rlca
	and $03
	ld e, $01
	cp $02
	jr c, +
	ld e, $FF
+:
	push hl
	inc hl
	inc hl
	inc hl
	ld a, (hl)
	add a, e
	ld (hl), a
	pop hl
++:
	ld a, $05
	ret

; Data from 4AF6 to 4AF7 (2 bytes)
_unused_bytes2:
.db $00 $00

; Pointer Table from 4AF8 to 4B1D (19 entries, indexed by _RAM_C79D_dataPointer?)
_DATA_4AF8_:
.dw _DATA_4B1E_ _DATA_4B91_ _DATA_4C04_ _DATA_4C0F_ _DATA_4C1A_ _DATA_4C2F_ _DATA_4B1E_ _DATA_4B91_
.dw _DATA_4B35_ _DATA_4B4C_ _DATA_4B63_ _DATA_4B7A_ _DATA_4BA8_ _DATA_4BBF_ _DATA_4BD6_ _DATA_4BED_
.dw _DATA_4BED_ _DATA_4BED_ _DATA_4BED_

; 1st entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4B1E to 4B34 (23 bytes)
_DATA_4B1E_:
.db $02 $01 $24 $4B $24 $4B $00 $37 $00 $00 $00 $38 $08 $00 $00 $39
.db $00 $08 $00 $3A $08 $08 $40

; 9th entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4B35 to 4B4B (23 bytes)
_DATA_4B35_:
.db $02 $01 $3B $4B $3B $4B $00 $3F $00 $00 $00 $40 $08 $00 $00 $41
.db $00 $08 $00 $42 $08 $08 $40

; 10th entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4B4C to 4B62 (23 bytes)
_DATA_4B4C_:
.db $02 $01 $52 $4B $52 $4B $00 $43 $00 $00 $00 $44 $08 $00 $00 $45
.db $00 $08 $00 $46 $08 $08 $40

; 11th entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4B63 to 4B79 (23 bytes)
_DATA_4B63_:
.db $02 $01 $69 $4B $69 $4B $00 $47 $00 $00 $00 $48 $08 $00 $00 $49
.db $00 $08 $00 $4A $08 $08 $40

; 12th entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4B7A to 4B90 (23 bytes)
_DATA_4B7A_:
.db $02 $01 $80 $4B $80 $4B $00 $4B $00 $00 $00 $4C $08 $00 $00 $4D
.db $00 $08 $00 $4E $08 $08 $40

; 2nd entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4B91 to 4BA7 (23 bytes)
_DATA_4B91_:
.db $02 $01 $97 $4B $97 $4B $00 $3B $00 $00 $00 $3C $08 $00 $00 $3D
.db $00 $08 $00 $3E $08 $08 $40

; 13th entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4BA8 to 4BBE (23 bytes)
_DATA_4BA8_:
.db $02 $01 $AE $4B $AE $4B $00 $4F $00 $00 $00 $50 $08 $00 $00 $51
.db $00 $08 $00 $52 $08 $08 $40

; 14th entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4BBF to 4BD5 (23 bytes)
_DATA_4BBF_:
.db $02 $01 $C5 $4B $C5 $4B $00 $53 $00 $00 $00 $54 $08 $00 $00 $55
.db $00 $08 $00 $56 $08 $08 $40

; 15th entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4BD6 to 4BEC (23 bytes)
_DATA_4BD6_:
.db $02 $01 $DC $4B $DC $4B $00 $57 $00 $00 $00 $58 $08 $00 $00 $59
.db $00 $08 $00 $5A $08 $08 $40

; 16th entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4BED to 4C03 (23 bytes)
_DATA_4BED_:
.db $02 $01 $F3 $4B $F3 $4B $00 $5B $00 $00 $00 $5C $08 $00 $00 $5D
.db $00 $08 $00 $5E $08 $08 $40

; 3rd entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4C04 to 4C0E (11 bytes)
_DATA_4C04_:
.db $02 $01 $0A $4C $0A $4C $00 $33 $00 $00 $40

; 4th entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4C0F to 4C19 (11 bytes)
_DATA_4C0F_:
.db $02 $01 $15 $4C $15 $4C $00 $31 $00 $00 $40

; 5th entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4C1A to 4C2E (21 bytes)
_DATA_4C1A_:
.db $02 $01 $20 $4C $25 $4C $00 $35 $00 $00 $40 $00 $36 $00 $00 $40
.db $00 $35 $00 $00 $40

; 6th entry of Pointer Table from 4AF8 (indexed by _RAM_C79D_dataPointer?)
; Data from 4C2F to 4C39 (11 bytes)
_DATA_4C2F_:
.db $02 $01 $35 $4C $35 $4C $00 $5F $00 $00 $40

; Data from 4C3A to 4C61 (40 bytes)
_DATA_4C3A_:
.db $02 $03 $40 $4C $51 $4C $00 $CE $00 $00 $00 $CF $08 $00 $00 $D0
.db $10 $00 $00 $D1 $18 $00 $40 $00 $D2 $00 $00 $00 $D3 $08 $00 $00
.db $D4 $10 $00 $00 $D5 $18 $00 $40

_LABEL_4C62_:
	ld hl, _RAM_C7CD_pointer?
	ld a, (hl)
	or a
	jr z, +
	ld hl, _RAM_C7D1_pointer?
	ld a, (hl)
	or a
	jr z, +
	ret

+:
	ld a, (ix+6)
	and $01
	xor $01
	inc a
	ld (hl), a
	inc hl
	ld (hl), $FB
	inc hl
	ld e, (ix+12)
	ld d, (ix+13)
	dec de
	ld (hl), e
	inc hl
	ld (hl), d
	ret

_LABEL_4C89_:
	ld hl, _RAM_C7CD_pointer?
	ld a, (hl)
	or a
	jr z, +
	ld hl, _RAM_C7D1_pointer?
	ld a, (hl)
	or a
	jr z, +
	ret

+:
	ld a, (iy+6)
	and $01
	xor $01
	inc a
	ld (hl), a
	inc hl
	ld (hl), $FB
	inc hl
	ld e, (iy+12)
	ld d, (iy+13)
	dec de
	ld (hl), e
	inc hl
	ld (hl), d
	ret

_LABEL_4CB0_:
	ld hl, _RAM_C7CD_pointer?
	ld a, (hl)
	or a
	jr z, +
	ld hl, _RAM_C7D1_pointer?
	ld a, (hl)
	or a
	jr z, +
	ret

+:
	ld (hl), $03
	inc hl
	ld (hl), $FB
	inc hl
	ld e, (ix+12)
	ld d, (ix+13)
	dec de
	ld (hl), e
	inc hl
	ld (hl), d
	ret

_LABEL_4CD0_:
	ld a, (_RAM_C7CD_pointer?)
	or a
	jr z, +	;Jump if this pointer is zero.
	ld hl, _RAM_C7CD_pointer?	;It is not zero, load into HL and jump away.
	call ++
+:
	ld a, (_RAM_C7D1_pointer?)
	or a
	ret z
	ld hl, _RAM_C7D1_pointer?
++:
	push hl
	push af	;Okay, save these registers, then jump again somewhere else.
	call _LABEL_4949_	;This is some indexed thing that I cannot dissect, but it may be a part of a sprite logic.
	; If C7D1 is frozen, or put to FF, it does nothing visible during match.
	;But when both is frozen, and changed, you cannot pick up stuff properly, and a smash sound effect is played
	;at the start of the match.
	or a
	jr z, +
	pop af
	pop hl
	ld (hl), $00
	ret

+:
	pop af
	pop hl
	ex af, af'
	push hl
	inc hl
	ld a, (hl)
	cp $04
	jr z, +
	inc a
+:
	ld (hl), a
	ld c, a
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex de, hl
	ld a, (hl)
	cp $09
	jr nc, +
	or a
	jr nz, ++
+:
	pop hl
	ld (hl), $00
	ret

++:
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	dec hl
	ex af, af'
	ld (_RAM_C370_verticalScroll), a
	cp $03
	jr z, ++
	and $01
	jr z, +
	push hl
	ld hl, $0004
	add hl, de
	ex de, hl
	pop hl
	jp ++

+:
	push hl
	ld hl, $FFFC
	add hl, de
	ex de, hl
	pop hl
++:
	ld (hl), e
	inc hl
	ld (hl), d
	inc hl
	ld (_RAM_C37A_plyr2chooseDone?), de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld a, c
	add a, d
	ld c, a
	add a, e
	cp e
	jr nc, +
	ld (hl), c
	pop hl
	ret

+:
	ld (hl), $00
	inc hl
	ld a, (_RAM_C370_verticalScroll)
	ld de, (_RAM_C37A_plyr2chooseDone?)
	ld a, d
	or a
	jr nz, +
	ld a, e
	cp $18
	jr c, +++
	jp ++

+:
	cp $02
	jr nc, +++
	ld a, e
	cp $CF
	jr nc, +++
++:
	cp $03
	jr z, +++
	ld a, (hl)
	cp $03
	jr nc, +++
	inc a
	ld (hl), a
	ld de, MAPPER_3DGLASS_CONTROL
	add hl, de
	ld a, (hl)
	ld c, $01
	cp $07
	jr z, +
	ld c, $02
+:
	ld a, c
	ld (hl), a
	pop hl
	ld (hl), $00
	push de
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	ld a, $06
	call _LABEL_639EF_
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	pop de
	ret

+++:
	ld de, MAPPER_3DGLASS_CONTROL
	add hl, de
	ld a, (hl)
	ld c, $09
	cp $07
	jr z, +
	ld c, $0D
+:
	ld a, c
	ld (hl), a
	pop hl
	ld (hl), $00
	ret

_LABEL_4DA5_:
	ld c, (ix+3)
	ld a, (ix+17)
	or a
	jr z, +
	ld a, (_RAM_C6F8_plyr2Frame?)
	dec a
	ld b, a
	srl a
	ld e, a
	ld d, $00
	ld hl, (_RAM_C70A_plyr2PosPointer)
	add hl, de
	ld a, (hl)
	add a, c
	ret

+:
	ld a, (_RAM_C6F7_plyr1Frame?)
	dec a
	ld b, a
	srl a
	ld e, a
	ld d, $00
	ld hl, (_RAM_C708_plyr1PosPointer)
	add hl, de
	ld a, (hl)
	add a, c
	ret

_LABEL_4DD0_:
	ld a, (ix+10)
	or a
	jr z, _LABEL_4E4F_
	cp $0B
	jr nz, +
	ld a, $01
	ld (ix+14), a
	ld a, $0B
+:
	dec a
	ld (ix+10), a
	cp $06
	jr c, +
	ld l, (ix+12)
	ld h, (ix+13)
	inc hl
	inc hl
	inc hl
	ld a, (hl)
	sub $03
	ld (hl), a
	ret

+:
	ld l, (ix+12)
	ld h, (ix+13)
	or a
	jr nz, ++
	ld e, (ix+1)
	ld d, (ix+2)
	ex de, hl
	ld bc, $0008
	ld a, (ix+6)
	and $01
	jr z, +
	ld bc, $0000
+:
	add hl, bc
	ex de, hl
	ld (hl), e
	inc hl
	ld (hl), d
	inc hl
	push hl
	call _LABEL_4DA5_
	pop hl
	ld c, a
	ld a, (hl)
	sub c
	add a, $0A
	neg
	inc hl
	ld (hl), a
	xor a
	ld (ix+11), a
	ret

++:
	ld e, (hl)
	inc hl
	ld d, (hl)
	dec hl
	ex de, hl
	ld a, (ix+6)
	and $01
	jr z, +
	ld bc, $FFFD
	add hl, bc
	jp ++

+:
	ld bc, $0003
	add hl, bc
++:
	ex de, hl
	ld (hl), e
	inc hl
	ld (hl), d
	inc hl
	inc hl
	ld a, (hl)
	sub $03
	ld (hl), a
	ret

_LABEL_4E4F_:
	ld a, (ix+11)
	inc a
	ld (ix+11), a
	cp $FE
	jr nc, +++
	ld a, (ix+4)
	ld hl, _RAM_C393_JOYPAD1
	cp $01
	jr z, +
	ld hl, _RAM_C394_JOYPAD2
	cp $02
	jr z, +
	call _LABEL_5676_
	jp ++

+:
	ld c, (hl)
++:
	ld a, c
	and $30
	ret z
+++:
	ld a, $31
	call _LABEL_47A6_
	ld a, $0B
	ld (ix+10), a
	ld hl, $4E8F
	ld (ix+8), l
	ld (ix+9), h
	ld a, $01
	ld (ix+7), a
	ret

_LABEL_4E8F_:
	ld a, (ix+10)
	cp $0B
	jr nz, +
	call _LABEL_4C62_
	xor a
	ld (ix+14), a
	ld a, $0B
+:
	dec a
	ld (ix+10), a
	ret nz
	xor a
	ld (ix+5), a
	ld (ix+7), a
	ret

_LABEL_4EAC_:
	ld a, (ix+10)
	dec a
	ld (ix+10), a
	ret nz
	ld a, (ix+6)
	and $01
	jr nz, _LABEL_4F04_
	ld c, (ix+1)
	ld b, (ix+2)
	dec bc
	ld (_RAM_C370_verticalScroll), bc
	ld a, (ix+3)
	ld (_RAM_C372_timer?), a
	call _LABEL_4908_
	or a
	jp z, _LABEL_4F4A_
	ld a, (hl)
	add a, $06
	ld (hl), a
	inc hl
	ld (ix+12), l
	ld (ix+13), h
	ld de, $0005
	add hl, de
	push hl
	ld a, (ix+49)
	pop hl
	ld (hl), a
	ld hl, $4DD0
	ld (ix+8), l
	ld (ix+9), h
	ld a, $0B
	ld (ix+10), a
	ld a, $2F
	call _LABEL_47A6_
	ld a, $01
	ld (ix+7), a
	ld (ix+14), a
	ret

_LABEL_4F04_:
	ld c, (ix+1)
	ld b, (ix+2)
	inc bc
	ld (_RAM_C370_verticalScroll), bc
	ld a, (ix+3)
	ld (_RAM_C372_timer?), a
	call _LABEL_48BD_
	or a
	jp z, _LABEL_4F4A_
	ld a, (hl)
	add a, $06
	ld (hl), a
	inc hl
	ld (ix+12), l
	ld (ix+13), h
	ld de, $0005
	add hl, de
	push hl
	ld a, (ix+49)
	pop hl
	ld (hl), a
	ld hl, $4DD0
	ld (ix+8), l
	ld (ix+9), h
	ld a, $0B
	ld (ix+10), a
	ld a, $2F
	call _LABEL_47A6_
	ld a, $01
	ld (ix+7), a
	ret

_LABEL_4F4A_:
	call _LABEL_49F8_
	or a
	jr z, ++
	cp $05
	jr nz, +
	ld a, $FF
	ld (ix+32), a
	xor a
	ld (hl), a
	jp ++

+:
	call _LABEL_502A_
++:
	xor a
	ld (ix+5), a
	ld (ix+7), a
	ret

_LABEL_4F69_animation:
	ld ix, _RAM_C7D5_indexingPointer?
	ld a, (ix+0)
	cp $02
	call z, +
	ld ix, _RAM_C7E0_indexPointer?
	ld a, (ix+0)
	cp $02
	ret nz
+:
	ld a, (ix+8)
	inc a
	ld (ix+8), a
	ld c, (ix+4)
	ld a, (ix+6)
	or a
	jr nz, +
	ex af, af'
	inc c
	ld (ix+4), c
	ld a, (ix+7)
	inc a
	ld (ix+7), a
	cp $10
	jr z, _LABEL_4FE7_
	ex af, af'
	jp ++

+:
	dec a
	ld (ix+6), a
++:
	ld l, (ix+2)
	ld h, (ix+3)
	ld d, $FF
	ld a, (ix+5)
	cp $FC
	jr z, +
	ld d, $00
+:
	ld e, a
	add hl, de
	ld (ix+2), l
	ld (ix+3), h
	ld a, h
	cp $02
	jr nc, _LABEL_500B_
	ex de, hl
	ld b, $00
	call _LABEL_5110_
	ld a, (ix+1)
	or a
	jr nz, ++
	ld a, (ix+5)
	ld hl, $5010
	cp $04
	jr z, +
	ld hl, $5015
+:
	jp _LABEL_1425_SpriteMoveLoop?

++:
	ld hl, _DATA_501A_palette?
	jp _LABEL_F42_timerAndSpriteMoves

_LABEL_4FE7_:
	ld l, (ix+9)
	ld h, (ix+10)
	push hl
	ld de, $0005
	add hl, de
	ld a, (hl)
	inc (hl)
	pop hl
	cp $03
	jr nc, _LABEL_500B_
	ld a, (ix+1)
	add a, $03
	ld (hl), a
	inc hl
	ld e, (ix+2)
	ld d, (ix+3)
	ld (hl), e
	inc hl
	ld (hl), d
	inc hl
	ld (hl), c
_LABEL_500B_:
	xor a
	ld (ix+0), a
	ret

; Data from 5010 to 5019 (10 bytes)
_unused_10bytes:
.db $00 $33 $00 $00 $40 $00 $34 $00 $00 $40

; Data from 501A to 5029 (16 bytes)
_DATA_501A_palette?:
.db $02 $01 $20 $50 $25 $50 $00 $31 $00 $00 $40 $00 $32 $00 $00 $40

_LABEL_502A_:
	ex de, hl
	ex af, af'
	ld a, (ix+37)
	or a
	ret nz
	ld hl, _RAM_C7D5_indexingPointer?
	ld a, (hl)
	or a
	jr z, +
	ld hl, _RAM_C7E0_indexPointer?
	ld a, (hl)
	or a
	ret nz
+:
	ld (ix+38), l
	ld (ix+39), h
	ld (hl), $01
	inc hl
	ex af, af'
	sub $03
	ld (hl), a
	ld bc, $0008
	add hl, bc
	ld (hl), e
	inc hl
	ld (hl), d
	xor a
	ld (de), a
	ld a, $01
	ld (ix+37), a
	ret

_LABEL_505A_:
	ld a, (ix+37)
	or a
	ret z
	xor a
	ld (ix+37), a
	ld l, (ix+38)
	ld h, (ix+39)
	ld a, (hl)
	cp $01
	ret nz
	ld (hl), $02
	inc hl
	ld a, (hl)
	ex af, af'
	inc hl
	ld e, (ix+1)
	ld d, (ix+2)
	ld a, (ix+6)
	and $01
	jr nz, +
	push hl
	ld hl, $FFFC
	add hl, de
	ex de, hl
	pop hl
	jp ++

+:
	push hl
	ld hl, $001F
	add hl, de
	ex de, hl
	pop hl
++:
	ld (hl), e
	inc hl
	ld (hl), d
	inc hl
	push hl
	call _LABEL_4DA5_
	pop hl
	add a, $0E
	ld (hl), a
	inc hl
	ld a, (ix+6)
	ld e, $FC
	and $01
	jr z, +
	ld e, $04
+:
	ld (hl), e
	inc hl
	ex af, af'
	ld e, $09
	or a
	jr z, +
	ld e, $17
+:
	ld (hl), e
	inc hl
	ld (hl), $00
	inc hl
	ld (hl), $00
	push de
	ld e, $18
	rst $18	; MAPPER_PAGE2_SUB Bank 24.
	ld a, $0B
	call _LABEL_639EF_
	ld a, (_RAM_C64E_BANKSWITCH_PAGE)
	ld e, a
	rst $18	; MAPPER_PAGE2_SUB
	pop de
	ret

_LABEL_50CA_:
	ld a, (ix+37)
	or a
	ret z
	xor a
	ld (ix+37), a
	ld l, (ix+38)
	ld h, (ix+39)
	ld a, (hl)
	cp $01
	ret nz
	ld (hl), $00
	inc hl
	ld a, (hl)
	ld de, _DATA_7_ + 1
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex de, hl
	add a, $03
	ld (hl), a
	inc hl
	ld e, (ix+1)
	ld d, (ix+2)
	ld (hl), e
	inc hl
	ld (hl), d
	inc hl
	push hl
	call _LABEL_4DA5_
	add a, $18
	pop hl
	ld (hl), a
	ret

_LABEL_5100_:
	push ix
	push iy
	push iy
	pop ix
	call _LABEL_50CA_
	pop iy
	pop ix
	ret

_LABEL_5110_:
	ld a, (ix+8)
	cp $04
	ret c
	ld a, (ix+5)
	or a
	ret z
	push ix
	push bc
	push de
	ld ix, _RAM_C735_plyr1Dead
	ld hl, (_RAM_C736_plyr1XandScrnHalf)
	ld a, (_RAM_C738_plyr1YCoordinate)
	ld b, a
	call +
	pop de
	pop bc
	push bc
	push de
	ld ix, _RAM_C769_Player2defeat?
	ld hl, (_RAM_C76A_Plyr2XnScrnHalf)
	ld a, (_RAM_C76C_player2yPosition)
	ld b, a
	call +
	pop de
	pop bc
	pop ix
	ret

+:
	ex de, hl
	or a
	sbc hl, de
	ld a, h
	or a
	ret nz
	ld a, l
	cp $10
	ret nc
	ld a, b
	add a, $08
	sub c
	ret nc
	neg
	cp $14
	ret nc
	pop hl
	call _LABEL_4368_
	call _LABEL_50CA_
	pop de
	pop bc
	pop ix
	xor a
	ld (ix+5), a
	ld (ix+6), a
	ret

_LABEL_516C_getCharDetails:
	ex af, af'
	ld a, (_RAM_C783_)
	push af
	ld a, (_RAM_C785_plyr2Life)
	push af
	ld hl, (_RAM_C781_plyr2stats?)
	push hl
	ld hl, _RAM_C769_Player2defeat?
	ld de, _RAM_C769_Player2defeat? + 1
	ld bc, $0033
	ld (hl), $00
	ldir
	pop hl
	ld (_RAM_C781_plyr2stats?), hl
	pop af
	add a, $08
	jr nc, +
	ld a, $FF
+:
	ld (_RAM_C785_plyr2Life), a
	pop af
	ld (_RAM_C783_), a
	ld hl, $012C
	ld (_RAM_C76A_Plyr2XnScrnHalf), hl
	ld a, $78
	ld (_RAM_C76C_player2yPosition), a
	ld a, $01
	ld (_RAM_C769_Player2defeat?), a
	ld a, $01
	ld (_RAM_C77A_plyr2Attack?), a
	ld a, $02
	ld (_RAM_C76F_plyr2Animation?), a
	ld a, $01
	ld (_RAM_C780_), a
	ld a, (_RAM_C360_difficulty)
	ld e, $00
	or a
	jr z, +
	ld e, $05
	cp $01
	jr z, +
	ld e, $0A
+:
	ld a, e
	ld (_RAM_C78D_unused?), a
	ld a, $03
	ld (_RAM_C779_plyr2specMoveCounter), a
	ex af, af'
	add a, a
	add a, a
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_2602_nmeProperty
	add hl, de
	ld a, (hl)
	inc hl
	ld (_RAM_C778_), a
	ld a, (hl)
	inc hl
	ld (_RAM_C792_chaseDistance?), a
	ld a, (hl)
	inc hl
	ld (_RAM_C793_mneAgressivity1?), a
	ld a, (hl)
	inc hl
	ld (_RAM_C794_mneRetreatDistance?), a
	ld a, (hl)
	inc hl
	ld (_RAM_C795_), a
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	push hl
	ex de, hl
	call _LABEL_216D_plyr2PosRelated
	pop hl
	ret

_LABEL_5200_:
	ex af, af'
	ld a, (ix+40)
	or a
	jp z, +
	dec a
	ld (ix+40), a
	xor a
	ret

+:
	ex af, af'
	sub $03
	cp $08
	jr c, +
	xor a
+:
	ld e, a
	add a, a
	add a, e
	ld e, a
	ld d, $00
	ld hl, $5221
	add hl, de
	jp (hl)

	jp +

	jp ++

	jp _LABEL_5272_

	jp _LABEL_52B7_

	jp _LABEL_52EE_

	jp _LABEL_530C_

	jp _LABEL_5359_

	jp _LABEL_53AA_

+:
	call _LABEL_5832_
	call _LABEL_5739_
	ld a, (ix+49)
	call _LABEL_549C_
	call _LABEL_5510_
	call _LABEL_5868_
	or a
	ret nz
	ld a, $04
	ld (ix+4), a
	ret

++:
	call _LABEL_5832_
	call _LABEL_5739_
	ld a, (ix+49)
	call _LABEL_549C_
	call _LABEL_548F_
	call _LABEL_5574_
	call _LABEL_587A_
	call _LABEL_5892_
	call _LABEL_5856_
	call _LABEL_58B2_
	ret

_LABEL_5272_:
	call _LABEL_5832_
	call _LABEL_5739_
	ld a, (ix+49)
	call _LABEL_549C_
	ld a, (ix+45)
	dec a
	ld (ix+45), a
	jr z, +
	call _LABEL_560D_
	or a
	jp nz, _LABEL_58B2_
+:
	ld a, $04
	ld (ix+4), a
	call _LABEL_983_
	and $0F
	jr nz, +
	ld a, (ix+6)
	and $03
	or $28
	ret

+:
	call _LABEL_983_
	and $30
	cp $30
	ret nz
	call _LABEL_983_
	and $03
	jr z, +
	ld a, $20
	ret

+:
	ld a, $30
	ret

_LABEL_52B7_:
	ld a, (ix+48)
	or a
	jr z, +
	ld a, $03
	ld (ix+4), a
	xor a
	ret

+:
	call _LABEL_5832_
	call _LABEL_5739_
	ld a, (ix+45)
	dec a
	ld (ix+45), a
	jr nz, +
	ld a, $03
	ld (ix+4), a
	xor a
	ret

+:
	call _LABEL_983_
	and $3F
	jr nz, +
	call _LABEL_58E3_
	ld (ix+46), a
+:
	ld a, (ix+46)
	call _LABEL_58B2_
	ret

_LABEL_52EE_:
	call _LABEL_5832_
	ld a, (ix+49)
	call _LABEL_548F_
	ld a, (iy+14)
	or a
	jr nz, _LABEL_5304_
	ld a, $03
	ld (ix+4), a
	xor a
	ret

_LABEL_5304_:
	call _LABEL_56E4_
	call _LABEL_5868_
	ld a, c
	ret

_LABEL_530C_:
	ld a, (ix+47)
	or a
	jr nz, _LABEL_5318_
	ld (ix+4), $03
	xor a
	ret

_LABEL_5318_:
	cp $03
	jr nz, +
	ld (ix+4), a
	ld a, (ix+6)
	or $18
	ret

+:
	ex af, af'
	ld e, (ix+1)
	ld d, (ix+2)
	ld a, (ix+3)
	ld (_RAM_C372_timer?), a
	ex af, af'
	cp $01
	jr nz, +
	inc de
	ld (_RAM_C370_verticalScroll), de
	call _LABEL_48BD_
	or a
	jr nz, +++
	jp ++

+:
	dec de
	ld (_RAM_C370_verticalScroll), de
	call _LABEL_4908_
	or a
	jr nz, +++
++:
	ld a, (ix+6)
	or $04
	ret

+++:
	ld a, $14
	ret

_LABEL_5359_:
	call _LABEL_5832_
	ld a, $05
	call _LABEL_5418_
	jr nz, +
	ld a, $03
	ld (ix+4), a
	xor a
	ret

+:
	ld a, c
	ld l, (ix+1)
	ld h, (ix+2)
	ld bc, $0008
	add hl, bc
	ld c, a
	ex de, hl
	or a
	sbc hl, de
	ld a, h
	or a
	jr nz, ++
	ld a, l
	cp $20
	jr nc, +
	ld a, (ix+3)
	add a, $10
	sub c
	jr nc, +++
	neg
	cp $1C
	jr nc, ++++
	ld a, $14
	jp _LABEL_58B2_

+:
	ld a, $01
	jp _LABEL_58B2_

++:
	ld a, $02
	jp _LABEL_58B2_

+++:
	ld a, $08
	jp _LABEL_58B2_

++++:
	ld a, $04
	jp _LABEL_58B2_

_LABEL_53AA_:
	ld a, (ix+37)
	or a
	jr z, +
	ld a, $03
	ld (ix+4), a
	xor a
	ret

+:
	call _LABEL_5832_
	ld a, (ix+10)
	dec a
	ld (ix+10), a
	or a
	jr nz, +
	ld a, $03
	ld (ix+4), a
	xor a
	ret

+:
	ld a, (ix+45)
	cp $04
	jr z, +
	cp $05
	jr nz, ++
+:
	call _LABEL_5418_
	jr nz, +++
++:
	ld a, $03
	ld (ix+4), a
	xor a
	ret

+++:
	ld a, c
	ld l, (ix+1)
	ld h, (ix+2)
	ld bc, $0008
	add hl, bc
	ld c, a
	ex de, hl
	or a
	sbc hl, de
	ld a, h
	or a
	jr nz, ++
	ld a, l
	cp $10
	jr nc, +
	ld a, (ix+3)
	add a, $18
	sub c
	jr nc, +++
	neg
	cp $10
	jr nc, ++++
	ld a, $14
	ret

+:
	ld a, $01
	ret

++:
	ld a, $02
	ret

+++:
	ld a, $08
	ret

++++:
	ld a, $04
	ret

_LABEL_5418_:
	ld c, a
	ld hl, _RAM_C79D_dataPointer?
	ld de, $0008
	ld b, $06
-:
	ld a, (hl)
	cp c
	jr z, +
	add hl, de
	djnz -
	ld (_RAM_C37E_), hl
	ld (_RAM_C380_), bc
	xor a
	ret

+:
	ld (_RAM_C37E_), hl
	ld (_RAM_C380_), bc
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld c, (hl)
	xor a
	inc a
	ret

_LABEL_5441_:
	ld a, $FF
	ret

; Data from 5444 to 548E (75 bytes)
_unused_75bytes:
.db $3A $81 $C3 $FE $02 $30 $03 $3E $FF $C9 $ED $4B $80 $C3 $2A $7E
.db $C3 $11 $08 $00 $19 $05 $7E $B9 $28 $0C $19 $10 $F9 $AF $22 $7E
.db $C3 $ED $43 $80 $C3 $C9 $22 $7E $C3 $ED $43 $80 $C3 $23 $5E $23
.db $56 $23 $4E $AF $3C $C9 $DD $7E $31 $C9 $DD $E5 $E1 $D5 $11 $35
.db $C7 $B7 $ED $52 $D1 $7C $B5 $C8 $3E $01 $C9
;This isn't code either.
_LABEL_548F_:
	or a
	jr nz, +
	ld iy, _RAM_C769_Player2defeat?
	ret

+:
	ld iy, $C735
	ret

_LABEL_549C_:
	ld hl, _RAM_C6ED_plyr1XposScrnHalf
	or a
	jr nz, +
	ld hl, _RAM_C76A_Plyr2XnScrnHalf
+:
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld c, (hl)
	ld b, $00
	ld (ix+19), e
	ld (ix+20), d
	ld (ix+21), c
	ret

_LABEL_54B6_:
	or a
	jr nz, +
	ld a, (_RAM_C76F_plyr2Animation?)
	and $01
	ld d, a
	ld a, (_RAM_C76E_plyr2State)
	jr ++

+:
	ld a, (_RAM_C73B_plyr1Direction)
	and $01
	ld d, a
	ld a, (_RAM_C73A_plyr1State)
++:
	or a
	ret nz
	inc d
	ld d, a
	ret

; Data from 54D2 to 5501 (48 bytes)
_DATA_54D2_:
.dsb 17, $00
.db $01 $01 $01 $01 $01 $01 $00 $00 $00 $00 $00 $00 $01 $01 $00 $00
.db $00 $00 $01 $01
.dsb 11, $00

_LABEL_5502_:
	push hl
	push de
	ld e, a
	ld d, $00
	ld hl, _DATA_54D2_
	add hl, de
	ld a, (hl)
	pop de
	pop hl
	or a
	ret

_LABEL_5510_:
	ld c, $00
	ld l, (ix+1)
	ld h, (ix+2)
	ld e, (ix+19)
	ld d, (ix+20)
	or a
	sbc hl, de
	bit 7, h
	jr z, ++
	ld a, h
	cpl
	ld h, a
	ld a, l
	cpl
	ld l, a
	inc hl
	ld a, h
	or a
	jr nz, +
	ld a, l
	cp $20
	jr c, +++
	cp $64
	jr c, +
	ld c, $19
	jp +++

+:
	ld c, $01
	jp +++

++:
	ld a, h
	or a
	jr nz, +
	ld a, l
	cp $20
	jr c, +++
	cp $64
	jr c, +
	ld c, $1A
	jp +++

+:
	ld c, $02
+++:
	ld a, (ix+3)
	sub (ix+21)
	jp nc, +
	neg
	cp $04
	jp c, _LABEL_5569_
	set 2, c
_LABEL_5569_:
	ld a, c
	ret

+:
	cp $04
	jp c, _LABEL_5569_
	ld a, c
	or $08
	ret

_LABEL_5574_:
	ld c, $00
	ld l, (ix+1)
	ld h, (ix+2)
	ld e, (ix+19)
	ld d, (ix+20)
	or a
	sbc hl, de
	bit 7, h
	jr z, +
	ld a, h
	cpl
	ld h, a
	ld a, l
	cpl
	ld l, a
	inc hl
	ld a, l
	cp $20
	jr nc, _LABEL_5606_
	jr z, _LABEL_55B7_
	cp $10
	jr c, _LABEL_55E7_
	ld a, (_RAM_C39E_timer)
	ld e, a
	and $03
	jp nz, _LABEL_55E9_
	ld a, e
	srl a
	srl a
	srl a
	srl a
	and $01
	jp z, _LABEL_55E7_
	ld c, $01
	jp _LABEL_55E9_

_LABEL_55B7_:
	ld c, $41
	jp _LABEL_55E9_

+:
	ld a, h
	or a
	jr nz, _LABEL_55E7_
	ld a, l
	cp $20
	jr nc, _LABEL_5606_
	jr z, _LABEL_55E7_
	cp $10
	jr c, _LABEL_55B7_
	ld a, (_RAM_C39E_timer)
	ld e, a
	and $03
	jp nz, _LABEL_55E9_
	ld a, e
	srl a
	srl a
	srl a
	srl a
	and $01
	jp z, _LABEL_55B7_
	ld c, $02
	jp _LABEL_55E9_

_LABEL_55E7_:
	ld c, $42
_LABEL_55E9_:
	ld a, (ix+3)
	sub (ix+21)
	jp nc, +
	neg
	cp $04
	jp c, _LABEL_55FB_
	set 2, c
_LABEL_55FB_:
	ld a, c
	ret

+:
	cp $04
	jp c, _LABEL_55FB_
	ld a, c
	or $08
	ret

_LABEL_5606_:
	ld a, $03
	ld (ix+4), a
	xor a
	ret

_LABEL_560D_:
	ld c, $00
	ld l, (ix+1)
	ld h, (ix+2)
	ld e, (ix+19)
	ld d, (ix+20)
	or a
	sbc hl, de
	bit 7, h
	jr z, +
	ld a, h
	cpl
	ld h, a
	ld a, l
	cpl
	ld l, a
	inc hl
	ld a, h
	or a
	jr nz, _LABEL_5634_
	ld a, l
	cp $10
	jr z, +++
	jr c, ++
_LABEL_5634_:
	ld c, $41
	jp +++

+:
	ld a, h
	or a
	jr nz, ++
	ld a, l
	cp $10
	jr z, +++
	jp c, _LABEL_5634_
++:
	ld c, $42
+++:
	ld a, (ix+3)
	sub (ix+21)
	jp nc, +
	neg
	cp $02
	jp c, _LABEL_5659_
	set 2, c
_LABEL_5659_:
	ld a, c
	ret

+:
	cp $02
	jp c, _LABEL_5659_
	ld a, c
	or $08
	ret

_LABEL_5664_:
	ld a, (ix+49)
	call _LABEL_549C_
	call _LABEL_54B6_
	cp $04
	jr nc, +
	jp _LABEL_57D6_

+:
	xor a
	ret

_LABEL_5676_:
	ld a, $03
	ld (ix+4), a
_LABEL_567B_:
	ld a, (ix+49)
	call _LABEL_548F_
	ld l, (ix+1)
	ld h, (ix+2)
	ld e, (iy+1)
	ld d, (iy+2)
	or a
	sbc hl, de
	bit 7, h
	jr z, +
	ld a, (ix+6)
	and $01
	jr z, _LABEL_56DE_
	ld a, h
	cpl
	ld h, a
	ld a, l
	cpl
	ld l, a
	inc hl
	ld a, h
	or a
	jr nz, _LABEL_56DE_
	ld a, l
	cp $18
	jr c, _LABEL_56DE_
	cp $48
	jr nc, _LABEL_56DE_
	jp ++

+:
	ld a, (ix+6)
	and $01
	jr nz, _LABEL_56DE_
	ld a, h
	or a
	jr nz, _LABEL_56DE_
	ld a, l
	cp $18
	jr c, _LABEL_56DE_
	cp $48
	jr nc, _LABEL_56DE_
++:
	ld a, (ix+3)
	sub (iy+3)
	jp nc, +
	neg
	cp $08
	jp c, ++
	jp _LABEL_56DE_

+:
	cp $08
	jp c, ++
_LABEL_56DE_:
	ld c, $00
	ret

++:
	ld c, $10
	ret

_LABEL_56E4_:
	ld c, $00
	ld l, (ix+1)
	ld h, (ix+2)
	ld e, (iy+1)
	ld d, (iy+2)
	or a
	sbc hl, de
	bit 7, h
	jr z, +
	ld a, h
	cpl
	ld h, a
	ld a, l
	cpl
	ld l, a
	inc hl
	ld a, h
	or a
	jr nz, +++
	ld a, l
	cp $5A
	jr nc, +++
	ld c, $02
	jp ++

+:
	ld a, h
	or a
	jr nz, +++
	ld a, l
	cp $5A
	jr nc, +++
	ld c, $01
++:
	call _LABEL_983_
	and (ix+44)
	jr nz, +++
	ld a, $18
	add a, c
	ld c, a
	ret

+++:
	ld a, (ix+3)
	sub (iy+3)
	jp nc, +
	ld a, c
	or $08
	ld c, a
	ret

+:
	ld a, c
	or $04
	ld c, a
	ret

_LABEL_5739_:
	push af
	call _LABEL_983_
	and $07
	jr nz, +
	ld a, $05
	call _LABEL_5418_
	jr z, _LABEL_5754_
	call _LABEL_983_
	and $07
	jr z, _LABEL_5754_
	ld a, $09
	ld (ix+4), a
_LABEL_5754_:
	pop af
	ret

_LABEL_5756_:
	ld a, (_RAM_C372_timer?)
	ld (ix+45), a
	ld a, $0A
	ld (ix+4), a
	ld a, $C8
	ld (ix+10), a
	pop af
	ret

+:
	ld a, (ix+37)
	or a
	jr nz, _LABEL_5754_
	call _LABEL_983_
	and $7F
	jr nz, _LABEL_5754_
	call _LABEL_983_
	and $01
	jr z, +
	ld a, $04
	call _LABEL_5418_
	or a
	jr z, _LABEL_5754_
-:
	call ++
	jr nz, _LABEL_5756_
	call _LABEL_5441_
	cp $FF
	jr z, _LABEL_5754_
	jr -

+:
	ld a, $03
	call _LABEL_5418_
	or a
	jr z, _LABEL_5754_
-:
	call ++
	jr nz, _LABEL_5756_
	call _LABEL_5441_
	cp $FF
	jr z, _LABEL_5754_
	jr -

++:
	ld l, (ix+1)
	ld h, (ix+2)
	or a
	sbc hl, de
	bit 7, h
	jr z, +
	ld a, h
	cpl
	ld h, a
	ld a, l
	cpl
	ld l, a
	inc hl
	ld a, h
	or a
	jr nz, +++
	ld a, l
	cp $5A
	jr nc, +++
	jp ++

+:
	ld a, h
	or a
	jr nz, +++
	ld a, l
	cp $5A
	jr nc, +++
++:
	xor a
	inc a
	ret

+++:
	xor a
	ret

_LABEL_57D6_:
	ld l, (ix+1)
	ld h, (ix+2)
	ld e, (ix+19)
	ld d, (ix+20)
	or a
	sbc hl, de
	bit 7, h
	jr z, +
	ld a, h
	cpl
	ld h, a
	ld a, l
	cpl
	ld l, a
	inc hl
	ld a, h
	or a
	jr nz, +++
	ld a, l
	cp $08
	jr c, +++
	cp $18
	jr nc, +++
	ld a, (ix+6)
	and $01
	jp z, +++
	jp ++

+:
	ld a, h
	or a
	jr nz, +++
	ld a, l
	cp $08
	jp c, +++
	cp $18
	jp nc, +++
	ld a, (ix+6)
	and $01
	jr nz, +++
++:
	ld a, (ix+3)
	sub (ix+21)
	jp nc, +
	neg
+:
	cp $08
	jr nc, +++
	xor a
	inc a
	ret

+++:
	xor a
	ret

_LABEL_5832_:
	ld a, (ix+47)
	or a
	ret z
	ex af, af'
	call _LABEL_567B_
	ld a, c
	or a
	jr nz, +
	ld (ix+47), a
	call _LABEL_983_
	and $1F
	ret nz
	pop hl
	ex af, af'
	or $18
	ret

+:
	ld (ix+4), $08
	pop hl
	ex af, af'
	jp _LABEL_5318_

_LABEL_5856_:
	ld c, a
	ld a, (iy+14)
	or a
	jr nz, +
	ld a, c
	ret

+:
	ld a, $07
	ld (ix+4), a
	pop hl
	jp _LABEL_5304_

_LABEL_5868_:
	ld c, a
	call _LABEL_983_
	and (ix+41)
	jr z, +
	ld a, c
	ret

+:
	ld a, $20
	ld (ix+40), a
	xor a
	ret

_LABEL_587A_:
	ld c, a
	call _LABEL_983_
	and (ix+42)
	jr z, +
	ld a, c
	ret

+:
	ld a, $05
	ld (ix+4), a
	ld a, (ix+42)
	ld (ix+45), a
	xor a
	ret

_LABEL_5892_:
	ld c, a
	call _LABEL_983_
	and (ix+43)
	jr z, +
	ld a, c
	ret

+:
	ld a, $06
	ld (ix+4), a
	ld a, (ix+43)
	neg
	ld (ix+45), a
	call _LABEL_58E3_
	ld (ix+46), a
	xor a
	ret

_LABEL_58B2_:
	push af
	ld a, (ix+35)
	cp $05
	jr c, ++
	pop af
	xor a
	ld (ix+33), a
	ld a, (ix+49)
	call _LABEL_548F_
	ld l, (ix+1)
	ld h, (ix+2)
	ld e, (iy+1)
	ld d, (iy+2)
	ld c, $01
	ld a, h
	cp d
	jr nz, +
	ld a, l
	cp e
+:
	jr c, +
	ld c, $02
+:
	ld a, c
	or $18
	ret

++:
	pop af
	ret

_LABEL_58E3_:
	call _LABEL_983_
	ld c, $01
	and $03
	jp z, +
	ld b, a
-:
	sla c
	djnz -
+:
	ld a, c
	ret

; Data from 58F4 to 5913 (32 bytes)
_DATA_58F4_:
.db $00 $02 $13 $2B $01 $04 $06 $1B $1F $09 $00 $10 $20 $30 $34 $38
.dsb 16, $00

; 2nd entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5914 to 591C (9 bytes)
_DATA_5914_:
.db $01 $02 $01 $04 $01 $06 $01 $08 $FE

; 1st entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 591D to 5925 (9 bytes)
_DATA_591D_:
.db $01 $01 $01 $03 $01 $05 $01 $07 $FE

; Data from 5926 to 5928 (3 bytes)
_DATA_5926_:
.db $01 $0A $FE

; Data from 5929 to 592D (5 bytes)
_DATA_5929_:
.db $01 $09 $FE $FF $00

; 6th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 592E to 5935 (8 bytes)
_DATA_592E_:
.db $01 $0E $01 $0C $01 $0A $FD $0A

; 5th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5936 to 593D (8 bytes)
_DATA_5936_:
.db $01 $0D $01 $0B $01 $09 $FD $09

; 4th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 593E to 5947 (10 bytes)
_DATA_593E_:
.db $01 $10 $02 $12 $05 $14 $01 $12 $FD $10

; 3rd entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5948 to 5951 (10 bytes)
_DATA_5948_:
.db $01 $0F $02 $11 $05 $13 $01 $11 $FD $0F

; 8th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5952 to 5959 (8 bytes)
_DATA_5952_:
.db $01 $16 $01 $18 $01 $16 $FD $0A

; 7th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 595A to 5961 (8 bytes)
_DATA_595A_:
.db $01 $15 $01 $17 $01 $15 $FD $09

; 10th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5962 to 596D (12 bytes)
_DATA_5962_:
.db $01 $10 $01 $12 $01 $14 $02 $30 $01 $12 $FD $10

; 9th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 596E to 5979 (12 bytes)
_DATA_596E_:
.db $01 $0F $01 $11 $01 $13 $02 $2F $01 $11 $FD $0F

; 12th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 597A to 5987 (14 bytes)
_DATA_597A_:
.db $01 $46 $01 $48 $01 $4A $01 $4C $01 $4E $01 $50 $FD $0A

; 11th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5988 to 5995 (14 bytes)
_DATA_5988_:
.db $01 $45 $01 $47 $01 $49 $01 $4B $01 $4D $01 $4F $FD $09

; 16th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5996 to 5997 (2 bytes)
_DATA_5996_:
.db $FD $3C

; 15th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5998 to 5999 (2 bytes)
_DATA_5998_:
.db $FD $3B

; 18th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 599A to 599F (6 bytes)
_DATA_599A_:
.db $01 $3C $01 $3E $FD $40

; 17th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59A0 to 59A5 (6 bytes)
_DATA_59A0_:
.db $01 $3B $01 $3D $FD $3F

; 20th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59A6 to 59A8 (3 bytes)
_DATA_59A6_:
.db $01 $40 $FE

; 19th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59A9 to 59AB (3 bytes)
_DATA_59A9_:
.db $01 $3F $FE

; 22nd entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59AC to 59AF (4 bytes)
_DATA_59AC_:
.db $01 $42 $FD $40

; 21st entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59B0 to 59B3 (4 bytes)
_DATA_59B0_:
.db $01 $41 $FD $3F

; 24th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59B4 to 59B9 (6 bytes)
_DATA_59B4_:
.db $01 $42 $01 $3E $FD $0A

; 23rd entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59BA to 59BF (6 bytes)
_DATA_59BA_:
.db $01 $41 $01 $3D $FD $09

; 26th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59C0 to 59C5 (6 bytes)
_DATA_59C0_:
.db $01 $1A $01 $1C $FD $0A

; 25th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59C6 to 59CB (6 bytes)
_DATA_59C6_:
.db $01 $19 $01 $1B $FD $09

; 28th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59CC to 59D3 (8 bytes)
_DATA_59CC_:
.db $02 $46 $02 $48 $02 $4A $FD $3A

; 27th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59D4 to 59DB (8 bytes)
_DATA_59D4_:
.db $02 $45 $02 $47 $02 $49 $FD $39

; 30th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59DC to 59E1 (6 bytes)
_DATA_59DC_:
.db $02 $3C $04 $12 $FD $3E

; 29th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59E2 to 59E7 (6 bytes)
_DATA_59E2_:
.db $02 $3B $04 $11 $FD $3D

; 32nd entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59E8 to 59E9 (2 bytes)
_DATA_59E8_:
.db $FD $3C

; 31st entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59EA to 59EB (2 bytes)
_DATA_59EA_:
.db $FD $3B

; 34th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59EC to 59F3 (8 bytes)
_DATA_59EC_:
.db $01 $46 $01 $48 $02 $4A $FD $0A

; 33rd entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59F4 to 59FB (8 bytes)
_DATA_59F4_:
.db $01 $45 $01 $47 $02 $49 $FD $09

; 36th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 59FC to 5A01 (6 bytes)
_DATA_59FC_:
.db $02 $3C $01 $3E $FD $40

; 35th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A02 to 5A07 (6 bytes)
_DATA_5A02_:
.db $02 $3B $01 $3D $FD $3F

; 38th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A08 to 5A0B (4 bytes)
_DATA_5A08_:
.db $01 $20 $FD $0A

; 37th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A0C to 5A0F (4 bytes)
_DATA_5A0C_:
.db $01 $1F $FD $09

; 42nd entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A10 to 5A17 (8 bytes)
_DATA_5A10_:
.db $01 $46 $01 $48 $01 $4A $FD $0A

; 41st entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A18 to 5A1F (8 bytes)
_DATA_5A18_:
.db $01 $45 $01 $47 $01 $49 $FD $09

; 40th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A20 to 5A25 (6 bytes)
_DATA_5A20_:
.db $02 $3C $02 $3E $FD $40

; 39th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A26 to 5A2B (6 bytes)
_DATA_5A26_:
.db $02 $3B $02 $3D $FD $3F

; 44th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A2C to 5A2E (3 bytes)
_DATA_5A2C_:
.db $01 $44 $FE

; 43rd entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A2F to 5A31 (3 bytes)
_DATA_5A2F_:
.db $01 $43 $FE

; 46th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A32 to 5A33 (2 bytes)
_DATA_5A32_:
.db $FD $22

; 45th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A34 to 5A35 (2 bytes)
_DATA_5A34_:
.db $FD $21

; 48th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A36 to 5A3B (6 bytes)
_DATA_5A36_:
.db $01 $24 $FD $26 $FD $26

; 47th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A3C to 5A41 (6 bytes)
_DATA_5A3C_:
.db $01 $23 $FD $25 $FD $25

; 50th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A42 to 5A45 (4 bytes)
_DATA_5A42_:
.db $01 $2E $FD $24

; 49th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A46 to 5A49 (4 bytes)
_DATA_5A46_:
.db $01 $2D $FD $23

; 52nd entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A4A to 5A53 (10 bytes)
_DATA_5A4A_:
.db $01 $46 $01 $48 $01 $4A $01 $4C $FD $0A

; 51st entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A54 to 5A5D (10 bytes)
_DATA_5A54_:
.db $01 $45 $01 $47 $01 $49 $01 $4B $FD $09

; 54th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A5E to 5A66 (9 bytes)
_DATA_5A5E_:
.db $01 $46 $01 $48 $01 $4A $01 $4C $FE

; 53rd entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A67 to 5A6F (9 bytes)
_DATA_5A67_:
.db $01 $45 $01 $47 $01 $49 $01 $4B $FE

; 56th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A70 to 5A77 (8 bytes)
_DATA_5A70_:
.db $01 $4C $01 $4E $01 $4C $FD $0A

; 55th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A78 to 5A7F (8 bytes)
_DATA_5A78_:
.db $01 $4B $01 $4D $01 $4B $FD $09

; 57th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A80 to 5A86 (7 bytes)
_DATA_5A80_:
.db $01 $39 $01 $4F $01 $51 $FE

; 58th entry of Pointer Table from 3C02 (indexed by unknown)
; Data from 5A87 to 7FEF (9577 bytes)
_DATA_5A87_:
.incbin "pf_e_DATA_5A87_.inc";No idea what is this, but since this is the first bank, it may be the music data.

.BANK 1 SLOT 1
.ORG $0000; This is an almost empty bank?!

; Data from 7FF0 to 7FFF (16 bytes)
.db $54 $4D $52 $20 $53 $45 $47 $41 $FF $FF $A9 $19 $48 $80 $40 $40

.BANK 2
.ORG $0000

; Data from 8000 to 809F (160 bytes)
_DATA_8000_:
.dsb 12, $00
.db $48 $48 $00 $00 $00 $08 $00 $00 $10 $00 $00 $00 $04 $04
.dsb 10, $00
.db $02 $02 $00 $00 $00 $04 $00 $00 $04 $00 $00 $00 $10 $50 $00 $00
.db $88 $88 $00 $00 $00 $02 $00 $00 $01 $01 $00 $00 $00 $00 $00 $00
.db $00 $02 $00 $00 $25 $21
.dsb 10, $00
.db $42 $02 $00 $00 $00 $80 $00 $00 $81 $80
.dsb 14, $00
.db $02 $00 $00 $00 $40 $41
.dsb 10, $00
.db $82 $02
.dsb 34, $00

; Data from 80A0 to 80DF (64 bytes)
_DATA_80A0_palettes?:;This looks like a set of palettes, I think for the Game over graphics, as they zoom in.
.db $00 $38 $00 $00 $00 $44 $00 $00 $00 $82 $00 $00 $00 $82 $00 $00
.db $00 $82 $00 $00 $00 $44 $00 $00 $00 $38 $00 $00 $00 $00 $00 $00
.db $00 $38 $00 $00 $38 $44 $00 $00 $7C $82 $00 $00 $7C $82 $00 $00
.db $7C $82 $00 $00 $38 $44 $00 $00 $00 $38 $00 $00 $00 $00 $00 $00

; Data from 80E0 to B1C7 (12520 bytes)
_DATA_80E0_gameOverTileset:
.incbin "pf_e_DATA_80E0_.inc";Game over zooming-in graphics tileset.

; Data from B1C8 to B43F (632 bytes)
_DATA_B1C8_:
.db $39 $00 $3A $00 $3B $00 $3C $00 $3D $00 $3E $00 $38 $00 $3F $00
.db $40 $00 $41 $00 $38 $00 $42 $00 $43 $00 $44 $00 $38 $00 $45 $00
.db $46 $00 $47 $00 $48 $00 $49 $00 $4A $00 $4B $00 $4C $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $4D $00 $4E $00 $4F $00 $38 $00 $50 $00 $51 $00 $38 $00 $52 $00
.db $53 $00 $54 $00 $55 $00 $38 $00 $56 $00 $57 $00 $58 $00 $59 $00
.db $5A $00 $5B $00 $5C $00 $5D $00 $5E $00 $5F $00 $60 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $61 $00 $62 $00 $38 $00 $63 $00 $64 $00 $65 $00 $66 $00 $67 $00
.db $68 $00 $69 $00 $6A $00 $38 $00 $6B $00 $6C $00 $6D $00 $6E $00
.db $6F $00 $70 $00 $71 $00 $72 $00 $73 $00 $74 $00 $75 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $76 $00 $77 $00 $78 $00 $79 $00 $7A $00 $7B $00 $7C $00 $7D $00
.db $38 $00 $7E $00 $7F $00 $80 $00 $81 $00 $82 $00 $83 $00 $84 $00
.db $85 $00 $86 $00 $87 $00 $88 $00 $89 $00 $8A $00 $8B $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $8C $00 $8D $00 $8E $00 $8F $00 $90 $00 $91 $00 $92 $00
.db $93 $00 $94 $00 $95 $00 $96 $00 $97 $00 $98 $00 $99 $00 $9A $00
.db $9B $00 $9C $00 $9D $00 $9E $00 $9F $00 $A0 $00 $A1 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $39 $00 $A2 $00 $A3 $00 $A4 $00 $A5 $00 $A6 $00 $A7 $00
.db $A8 $00 $A9 $00 $AA $00 $AB $00 $AC $00 $AD $00 $AE $00 $AF $00
.db $B0 $00 $B1 $00 $B2 $00 $B3 $00 $B4 $00 $B5 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $B6 $00 $B7 $00 $B8 $00 $38 $00 $B9 $00 $BA $00 $BB $00
.db $BC $00 $BD $00 $BE $00 $38 $00 $BF $00 $C0 $00 $C1 $00 $C2 $00
.db $C3 $00 $C4 $00 $C5 $00 $C6 $00 $C7 $00 $C8 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $C9 $00 $CA $00 $CB $00 $38 $00 $CC $00 $CD $00 $38 $00
.db $CE $00 $CF $00 $D0 $00 $38 $00 $D1 $00 $D2 $00 $D3 $00 $D4 $00
.db $D5 $00 $D6 $00 $D7 $00 $D8 $00 $D9 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $DA $00 $DB $00 $DC $00 $DD $00 $DE $00 $38 $00
.db $DF $00 $E0 $00 $38 $00 $E1 $00 $E2 $00 $E3 $00 $E4 $00 $E5 $00
.db $E6 $00 $E7 $00 $E8 $00 $E9 $00 $EA $00 $EB $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $EC $00 $ED $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $EE $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00

; Data from B440 to B45B (28 bytes)
_DATA_B440_:
.db $EF $00 $F0 $00 $F1 $00 $F2 $00 $38 $00 $F3 $00 $38 $00 $F4 $00
.db $F5 $00 $F6 $00 $F7 $00 $F8 $00 $F9 $00 $FA $00

; Data from B45C to B55B (256 bytes)
_DATA_B45C_:
.db $FB $00 $FC $00 $FD $00 $FE $00 $FF $00 $00 $01 $01 $01 $02 $01
.db $03 $01 $04 $01 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $05 $01 $06 $01 $07 $01 $08 $01 $09 $01 $0A $01
.db $0B $01 $0C $01 $0D $01 $0E $01 $0F $01 $10 $01 $11 $01 $12 $01
.db $13 $01 $14 $01 $15 $01 $16 $01 $17 $01 $18 $01 $19 $01 $1A $01
.db $1B $01 $1C $01 $1D $01 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $1E $01 $1F $01 $20 $01 $21 $01 $22 $01 $23 $01
.db $24 $01 $25 $01 $26 $01 $27 $01 $28 $01 $29 $01 $2A $01 $2B $01
.db $38 $00 $2C $01 $2D $01 $2E $01 $2F $01 $30 $01 $31 $01 $32 $01
.db $33 $01 $34 $01 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $35 $01 $36 $01 $37 $01 $38 $01 $39 $01
.db $3A $01 $3B $01 $3C $01 $3D $01 $3E $01 $3F $01 $40 $01 $38 $00
.db $38 $00 $41 $01 $42 $01 $43 $01 $44 $01 $45 $01 $46 $01 $47 $01
.db $48 $01 $49 $01 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $4A $01 $4B $01 $4C $01 $4D $01 $4E $01
.db $4F $01 $50 $01 $51 $01 $52 $01 $53 $01 $54 $01 $55 $01 $38 $00

; Data from B55C to B567 (12 bytes)
_DATA_B55C_:
.db $56 $01 $57 $01 $58 $01 $59 $01 $5A $01 $5B $01

; Data from B568 to B5BF (88 bytes)
_DATA_B568_:
.db $5C $01 $5D $01 $5E $01 $5F $01 $60 $01 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $61 $01 $62 $01 $63 $01
.db $DF $02 $64 $01 $65 $01 $66 $01 $67 $01 $68 $01 $69 $01 $6A $01
.db $6B $01 $6C $01 $6D $01 $6E $01 $6F $01 $70 $01 $71 $01 $C8 $00
.db $72 $01 $73 $01 $74 $01 $75 $01 $76 $01 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00

; Data from B5C0 to B611 (82 bytes)
_DATA_B5C0_:
.db $38 $00 $77 $01 $78 $01 $79 $01 $7A $01 $7B $01 $7C $01 $7D $01
.db $55 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $7E $01 $7F $01
.db $80 $01 $81 $01 $82 $01 $38 $00 $38 $00 $83 $01 $84 $01 $85 $01
.db $86 $01 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $87 $01 $88 $01 $89 $01 $8A $01 $8B $01 $8C $01 $8D $01 $8E $01
.db $8F $01

; Data from B612 to B61F (14 bytes)
_DATA_B612_:
.db $90 $01 $91 $01 $92 $01 $93 $01 $94 $01 $95 $01 $96 $01

; Data from B620 to B6BF (160 bytes)
_DATA_B620_:
.db $97 $01 $98 $01 $99 $01 $9A $01 $9B $01 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $9C $01 $9D $01 $9E $01 $9F $01 $A0 $01 $A1 $01 $A2 $01
.db $66 $06 $A3 $01 $A4 $01 $A5 $01 $A6 $01 $A7 $01 $A8 $01 $A9 $01
.db $66 $04 $AA $01 $AB $01 $AC $01 $AD $01 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00
.db $38 $00 $AE $01 $AF $01 $B0 $01 $B1 $01 $B2 $01 $B3 $01 $B4 $01
.db $38 $00 $38 $00 $B5 $01 $B6 $01 $B7 $01 $B8 $01 $B9 $01 $BA $01
.db $38 $00 $BB $01 $BC $01 $BD $01 $BE $01 $38 $00 $38 $00 $38 $00
.db $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00 $38 $00

; Data from B6C0 to B6DF (32 bytes)
_DATA_B6C0_palettes?:
.db $00 $3F $0F $0B $07 $06 $02 $01 $01 $0C $08 $04 $0F $07 $3C $3F
.db $00 $3F $0F $0B $07 $06 $02 $01 $01 $0C $08 $04 $0F $07 $3C $3F

_LABEL_B6E0_:
	di
	ld hl, _LABEL_DFD_titleScreenMainLoop?
	ld (_RAM_C391_pointer?), hl
	ld hl, _DATA_74D5C_charSelectMusic
	call SelectMusicBank
	call _LABEL_6CD_tilemap_clear
	ld hl, _DATA_80E0_gameOverTileset
	ld de, $0700
	ld bc, $30E0
	call _LABEL_7EF_VDPdataLoad
	ei
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld hl, $0000
	ld de, $0000
	ld bc, $012C
	ldir
	ld hl, _DATA_B6C0_palettes?
	call LOAD_BOTH_PALETTES
	ld bc, $030A
	ld hl, _DATA_B620_
	ld e, $00
	call _LABEL_B79F_
	ld bc, $030A
	ld hl, _DATA_B568_
	ld e, $00
	call _LABEL_B79F_
	ld bc, $030C
	ld hl, _DATA_B55C_
	ld e, $00
	call _LABEL_B79F_
	ld bc, $030E
	ld hl, _DATA_B612_
	ld e, $00
	call _LABEL_B79F_
	ld bc, $0412
	ld hl, _DATA_B5C0_
	ld e, $01
	call _LABEL_B79F_
	ld bc, $0416
	ld hl, _DATA_B45C_
	ld e, $01
	call _LABEL_B79F_
	ld bc, $061C
	ld hl, _DATA_B440_
	ld e, $01
	call _LABEL_B79F_
	ld bc, $0A2E
	ld hl, _DATA_B1C8_
	ld e, $01
	call _LABEL_B79F_
	ld hl, $0190
-:
	dec hl
	ld a, h
	or l
	jr z, +
	ld a, (_RAM_C393_JOYPAD1)
	ld e, a
	ld a, (_RAM_C394_JOYPAD2)
	or e
	and $30
	jr z, -
+:
	ld a, $01
	call _LABEL_20F7_fadeoutandStop?
	ld b, $96
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	di
	ret

_LABEL_B79F_:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	push hl
	ld a, $18
	sub b
	srl a
	sub e
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, h
	add a, $38
	ld h, a
	ld a, $40
	sub c
	srl a
	and $FE
	add a, l
	ld l, a
	ex de, hl
	pop hl
	call _LABEL_2EB5_vramLoad?
	ld b, $05
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ret

; Data from B7DA to B7E1 (8 bytes)
_DATA_B7DA_:
.db $6E $01 $6F $01 $70 $01 $71 $01

; Data from B7E2 to B899 (184 bytes)
_DATA_B7E2_:
.db $6E $01 $6F $01 $70 $01 $6E $01 $6F $01 $70 $01 $6E $01 $6F $01
.db $70 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $72 $01 $73 $01 $74 $01 $71 $01
.db $72 $01 $73 $01 $74 $01 $72 $01 $73 $01 $74 $01 $72 $01 $73 $01
.db $74 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $75 $01 $76 $01 $77 $01 $71 $01
.db $75 $01 $76 $01 $77 $01 $75 $01 $76 $01 $77 $01 $75 $01 $76 $01
.db $77 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01

; Data from B89A to B919 (128 bytes)
_DATA_B89A_:
.db $71 $01 $71 $01 $78 $01 $79 $01 $78 $01 $7A $01 $7B $01 $7C $01
.db $7D $01 $7E $01 $7F $01 $7B $01 $7C $01 $80 $01 $81 $01 $82 $01
.db $83 $01 $71 $01 $84 $01 $85 $01 $86 $01 $87 $01 $88 $01 $89 $01
.db $82 $01 $83 $01 $71 $01 $8A $01 $8B $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $8C $01 $8D $01 $8C $01 $8E $01 $8F $01 $90 $01
.db $91 $01 $92 $01 $93 $01 $8F $01 $90 $01 $8C $01 $8E $01 $94 $01
.db $95 $01 $71 $01 $96 $01 $97 $01 $98 $01 $99 $01 $9A $01 $9B $01
.db $94 $01 $95 $01 $71 $01 $9C $01 $9D $01 $71 $01 $71 $01 $71 $01

; Data from B91A to BA19 (256 bytes)
_DATA_B91A_:
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $9E $01 $9F $01
.db $A0 $01 $A0 $01 $A0 $01 $A0 $01 $A1 $01 $A2 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $A3 $01 $A4 $01
.db $A5 $01 $82 $01 $83 $01 $A6 $01 $A7 $01 $A8 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $7B $01 $7C $01 $78 $01 $7A $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $A9 $01 $AA $01
.db $AB $01 $94 $01 $95 $01 $AC $01 $AD $01 $AE $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $8F $01 $90 $01 $8C $01 $8E $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $AF $01 $B0 $01
.db $B1 $01 $B1 $01 $B1 $01 $B1 $01 $B2 $01 $B3 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01

; Data from BA1A to BB19 (256 bytes)
_DATA_BA1A_:
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $9E $01 $9F $01 $A0 $01 $A0 $01 $A0 $01 $A0 $01 $A1 $01
.db $A2 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $A4 $01
.db $A5 $01 $82 $01 $83 $01 $A6 $01 $A7 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $A3 $01 $71 $01 $7B $01 $7C $01 $78 $01 $7A $01 $71 $01
.db $A8 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $AA $01
.db $AB $01 $94 $01 $95 $01 $AC $01 $AD $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $A9 $01 $71 $01 $8F $01 $90 $01 $8C $01 $8E $01 $71 $01
.db $AE $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $AF $01 $B0 $01 $B1 $01 $B1 $01 $B1 $01 $B1 $01 $B2 $01
.db $B3 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01

; Data from BB1A to BB99 (128 bytes)
_DATA_BB1A_:
.db $71 $01 $71 $01 $71 $01 $71 $01 $78 $01 $79 $01 $B4 $01 $87 $01
.db $82 $01 $83 $01 $B5 $01 $B6 $01 $7F $01 $7D $01 $7E $01 $A6 $01
.db $A7 $01 $71 $01 $71 $01 $80 $01 $71 $01 $82 $01 $83 $01 $82 $01
.db $83 $01 $7D $01 $7E $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01
.db $71 $01 $71 $01 $71 $01 $71 $01 $8C $01 $8D $01 $B7 $01 $B8 $01
.db $94 $01 $95 $01 $B9 $01 $BA $01 $93 $01 $91 $01 $92 $01 $AC $01
.db $AD $01 $71 $01 $71 $01 $BB $01 $BC $01 $94 $01 $95 $01 $BD $01
.db $BE $01 $91 $01 $92 $01 $71 $01 $71 $01 $71 $01 $71 $01 $71 $01

; Data from BB9A to BFFF (1126 bytes)
_DATA_BB9A_hudTileandMap:
.db $00 $00 $00 $00 $00 $99 $00 $FF $6C $FE $00 $92 $78 $FC $00 $84
.db $00 $F8 $00 $88 $00 $FC $00 $84 $6C $92 $00 $92 $66 $99 $00 $99
.db $00 $00 $00 $00 $00 $A9 $00 $EF $66 $FF $00 $99 $76 $FF $00 $89
.db $00 $FF $00 $91 $00 $FF $00 $99 $66 $99 $00 $99 $66 $99 $00 $99
.db $00 $00 $00 $00 $00 $42 $00 $7E $66 $FF $00 $99 $66 $FF $00 $99
.db $00 $FF $00 $99 $00 $FF $00 $99 $66 $99 $00 $99 $3C $42 $00 $42
.db $00 $00 $00 $00 $00 $42 $00 $7E $66 $FF $00 $99 $60 $F6 $00 $96
.db $00 $F0 $00 $90 $00 $F6 $00 $96 $66 $99 $00 $99 $3C $42 $00 $42
.db $00 $00 $00 $00 $00 $99 $00 $FF $66 $FF $00 $99 $66 $FF $00 $99
.db $00 $FF $00 $99 $00 $FF $00 $99 $66 $99 $00 $99 $3C $42 $00 $42
.db $00 $00 $00 $00 $00 $81 $00 $FF $18 $7E $00 $66 $18 $3C $00 $24
.db $00 $3C $00 $24 $00 $3C $00 $24 $18 $24 $00 $24 $18 $24 $00 $24
.db $00 $00 $00 $00 $00 $24 $00 $3C $18 $3C $00 $24 $18 $3C $00 $24
.db $00 $3C $00 $24 $00 $3C $00 $24 $00 $18 $00 $18 $18 $24 $00 $24
.db $80 $00 $80 $80 $28 $26 $28 $2E $00 $09 $00 $0F $40 $0A $40 $4F
.db $00 $39 $00 $3F $00 $5B $30 $7F $20 $BC $60 $FC $02 $60 $02 $62
.db $00 $00 $00 $00 $10 $A5 $10 $B5 $00 $5B $80 $FF $00 $AA $00 $FF
.db $00 $AA $00 $FF $80 $D5 $88 $FF $44 $FE $5C $FE $20 $7C $30 $7C
.db $00 $B0 $40 $F0 $00 $7D $A0 $FD $00 $A2 $00 $FF $00 $A6 $00 $FF
.db $00 $AE $00 $FF $00 $62 $00 $FF $02 $9F $02 $9F $40 $43 $40 $43
.db $00 $00 $00 $00 $00 $86 $00 $86 $02 $7B $06 $FF $04 $BE $1C $FE
.db $10 $7C $30 $FC $02 $B2 $02 $F2 $00 $C0 $00 $C0 $08 $00 $08 $08
.db $02 $60 $02 $62 $20 $BE $60 $FE $00 $59 $30 $7F $00 $3A $00 $3F
.db $40 $09 $40 $4F $00 $0B $00 $0F $28 $24 $28 $2C $80 $00 $80 $80
.db $20 $7C $30 $7C $40 $FE $58 $FE $80 $DB $80 $FF $00 $AA $00 $FF
.db $00 $AA $00 $FF $08 $5D $88 $FF $10 $A3 $10 $B3 $00 $00 $00 $00
.db $40 $43 $40 $43 $02 $5F $02 $5F $00 $A2 $00 $FF $00 $A6 $00 $FF
.db $00 $AE $00 $FF $00 $62 $00 $FF $00 $FD $60 $FD $00 $B0 $40 $F0
.db $08 $00 $08 $08 $00 $C0 $00 $C0 $02 $72 $02 $F2 $10 $BC $10 $FC
.db $04 $5E $3C $FE $02 $BB $06 $FF $80 $46 $80 $C6 $00 $00 $00 $00
.db $08 $C8 $08 $07 $00 $E0 $00 $0F $00 $70 $00 $07 $02 $3A $02 $00
.db $80 $9C $80 $40 $00 $0E $00 $E0 $10 $17 $10 $E0 $00 $03 $00 $E0
.db $20 $26 $20 $C0 $00 $0E $00 $E0 $00 $1C $00 $C0 $80 $B8 $80 $00
.db $02 $72 $02 $04 $00 $E0 $00 $0E $10 $D0 $10 $0E $00 $80 $00 $0E
.db $10 $17 $10 $E0 $00 $0E $00 $E0 $80 $9C $80 $40 $02 $3A $02 $00
.db $00 $70 $00 $07 $00 $E0 $00 $0F $08 $C8 $08 $07 $00 $00 $00 $00
.db $10 $D0 $10 $0E $00 $E0 $00 $0E $02 $72 $02 $04 $80 $B8 $80 $00
.db $00 $1C $00 $C0 $00 $0E $00 $E0 $20 $26 $20 $C0 $00 $00 $00 $00
.db $08 $08 $08 $07 $20 $20 $20 $1F $40 $40 $40 $3F $02 $02 $02 $7C
.db $88 $88 $88 $70 $00 $00 $00 $F0 $10 $10 $10 $E0 $00 $00 $00 $E0
.db $20 $20 $20 $C0 $08 $08 $08 $F0 $04 $04 $04 $F8 $80 $80 $80 $7C
.db $22 $22 $22 $1C $00 $00 $00 $1E $10 $10 $10 $0E $00 $00 $00 $0E
.db $10 $10 $10 $E0 $00 $00 $00 $F0 $88 $88 $88 $70 $02 $02 $02 $7C
.db $40 $40 $40 $3F $20 $20 $20 $1F $08 $08 $08 $07 $00 $00 $00 $00
.db $10 $10 $10 $0E $00 $00 $00 $1E $22 $22 $22 $1C $80 $80 $80 $7C
.db $04 $04 $04 $F8 $08 $08 $08 $F0 $20 $20 $20 $C0 $00 $00 $00 $00
.db $7F $7F $80 $5F $7F $7F $80 $5F $7F $7F $80 $FA $FA $FA $04 $7A
.db $FA $FA $04 $7A $FA $FA $04 $7A $FA $FA $04 $FA $FA $FA $04 $FA
.db $FA $FA $04 $FA $FA $FA $04 $F4 $F4 $F4 $08 $7E $7F $7F $80 $43
.db $7F $7F $80 $5D $7D $7D $82 $63 $63 $63 $9C $7E $7F $7F $80 $41
.db $7F $7F $80 $5F $7F $7F $80 $5F $7F $7F $80 $48 $48 $48 $48 $D8
.db $D8 $D8 $D8 $D8 $D8 $D8 $D8 $90 $90 $90 $90
.dsb 12, $00
.db $01 $01 $01 $01 $38 $38 $38 $38 $7C $7C $7C $7C $E5 $E5 $E5 $E5
.db $C1 $C1 $C1 $C1 $F3 $F3 $F3 $F3 $79 $79 $79 $79 $19 $19 $19 $19
.db $B9 $B9 $B9 $B9 $00 $00 $00 $00 $80 $80 $80 $80 $E0 $E0 $E0 $E0
.db $C7 $C7 $C7 $C7 $8D $8D $8D $8D
.dsb 12, $99
.dsb 12, $00
.db $0E $0E $0E $0E $BB $BB $BB $BB
.dsb 12, $B3
.dsb 32, $00
.db $02 $02 $02 $02 $06 $06 $06 $06 $06 $06 $06 $06 $76 $76 $76 $76
.db $E6 $E6 $E6 $E6 $C6 $C6 $C6 $C6 $66 $66 $66 $66 $36 $36 $36 $36
.dsb 12, $00
.db $38 $38 $38 $38 $6C $6C $6C $6C
.dsb 12, $CD
.db $01 $01 $01 $01 $03 $03 $03 $03 $03 $03 $03 $03 $73 $73 $73 $73
.db $DB $DB $DB $DB $83 $83 $83 $83 $83 $83 $83 $83 $9B $9B $9B $9B
.db $02 $02 $02 $02 $06 $06 $06 $06 $04 $04 $04 $04 $32 $32 $32 $32
.db $66 $66 $66 $66 $C6 $C6 $C6 $C6 $C6 $C6 $C6 $C6 $66 $66 $66 $66
.dsb 12, $00
.db $18 $18 $18 $18 $6C $6C $6C $6C $CD $CD $CD $CD $CD $CD $CD

.BANK 3
.ORG $0000

; Data from C000 to E381 (9090 bytes)
.incbin "pf_e_DATA_C000_.inc" ;This is a stage data, but I don't know which one.

; Data from E382 to E8C7 (1350 bytes)
_DATA_E382_mapdata?:
.incbin "pf_e_DATA_E382_mapdata?.inc";Not graphics, maybe mapdata.

; 1st entry of Pointer Table from 2E85 (indexed by unknown)
; Data from E8C8 to E987 (192 bytes)
_DATA_E8C8_:
.db $01 $08 $02 $08 $03 $08 $04 $08 $05 $08 $06 $08 $07 $08 $08 $08
.db $09 $08 $02 $08 $0A $08 $0B $08 $05 $08 $0C $08 $0D $08 $08 $08
.db $0E $08 $0F $08 $03 $08 $04 $08 $05 $08 $06 $08 $10 $08 $11 $08
.db $12 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $13 $08 $14 $08 $15 $08 $16 $08 $17 $08 $18 $08 $19 $08 $1A $08
.db $1B $08 $1C $08 $1D $08 $1E $08 $1F $08 $20 $08 $21 $08 $22 $08
.db $23 $08 $24 $08 $25 $08 $16 $08 $17 $08 $18 $08 $19 $08 $26 $08
.db $27 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $28 $08 $29 $08 $2A $08 $2B $08 $2C $08 $2D $08 $2E $08 $2F $08
.db $30 $08 $31 $08 $32 $08 $33 $08 $34 $08 $2D $08 $35 $08 $36 $08
.db $37 $08 $31 $08 $32 $08 $2B $08 $2C $08 $2D $08 $2E $08 $38 $08
.db $39 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08

; 3rd entry of Pointer Table from 2E85 (indexed by unknown)
; Data from E988 to EA41 (186 bytes)
_DATA_E988_:
.db $01 $08 $02 $08 $03 $08 $04 $08 $05 $08 $3A $08 $3B $08 $08 $08
.db $3C $08 $02 $08 $3D $08 $04 $08 $3E $08 $3F $08 $40 $08 $41 $08
.db $42 $08 $02 $08 $43 $08 $44 $08 $05 $08 $06 $08 $10 $08 $11 $08
.db $12 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $13 $08 $14 $08 $15 $08 $16 $08 $17 $08 $45 $08 $46 $08 $47 $08
.db $48 $08 $49 $08 $4A $08 $4B $08 $4C $08 $4D $08 $4E $08 $4F $08
.db $50 $08 $51 $08 $52 $08 $53 $08 $54 $08 $18 $08 $19 $08 $26 $08
.db $27 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $28 $08 $29 $08 $2A $08 $2B $08 $2C $08 $2D $08 $55 $08 $56 $08
.db $57 $08 $58 $08 $59 $08 $5A $08 $5B $08 $5C $08 $5D $08 $2F $08
.db $37 $08 $5E $08 $5F $08 $5A $08 $60 $08 $2D $08 $2E $08 $38 $08
.db $39 $08 $00 $08 $00 $08 $00 $08 $00 $08

; 5th entry of Pointer Table from 2E85 (indexed by unknown)
; Data from EA42 to EA57 (22 bytes)
_DATA_EA42_:
.db $01 $08 $02 $08 $61 $08 $62 $08 $63 $08 $64 $08 $65 $08 $08 $08
.db $66 $08 $67 $08 $68 $08

; 7th entry of Pointer Table from 2E85 (indexed by unknown)
; Data from EA58 to EB01 (170 bytes)
_DATA_EA58_:
.db $01 $08 $02 $08 $61 $08 $62 $08 $63 $08 $64 $08 $65 $08 $08 $08
.db $69 $08 $67 $08 $68 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $13 $08 $14 $08 $6A $08
.db $6B $08 $6C $08 $6D $08 $6E $08 $6F $08 $70 $08 $71 $08 $72 $08
.db $13 $08 $14 $08 $6A $08 $6B $08 $6C $08 $6D $08 $6E $08 $73 $08
.db $74 $08 $71 $08 $72 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $28 $08 $29 $08 $2A $08
.db $5A $08 $75 $08 $2D $08 $35 $08 $76 $08 $77 $08 $78 $08 $79 $08
.db $28 $08 $29 $08 $2A $08 $5A $08 $75 $08 $2D $08 $35 $08 $76 $08
.db $7A $08 $78 $08 $79 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08

; 9th entry of Pointer Table from 2E85 (indexed by unknown)
; Data from EB02 to EB17 (22 bytes)
_DATA_EB02_:
.db $01 $08 $02 $08 $61 $08 $62 $08 $63 $08 $64 $08 $65 $08 $08 $08
.db $7B $08 $67 $08 $68 $08

; 11th entry of Pointer Table from 2E85 (indexed by unknown)
; Data from EB18 to EBC1 (170 bytes)
_DATA_EB18_:
.db $01 $08 $02 $08 $61 $08 $62 $08 $63 $08 $64 $08 $65 $08 $08 $08
.db $7C $08 $67 $08 $68 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $13 $08 $14 $08 $6A $08
.db $6B $08 $6C $08 $6D $08 $6E $08 $7D $08 $7E $08 $71 $08 $72 $08
.db $13 $08 $14 $08 $6A $08 $6B $08 $6C $08 $6D $08 $6E $08 $7F $08
.db $80 $08 $71 $08 $72 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $28 $08 $29 $08 $2A $08
.db $5A $08 $75 $08 $2D $08 $35 $08 $76 $08 $77 $08 $78 $08 $79 $08
.db $28 $08 $29 $08 $2A $08 $5A $08 $75 $08 $2D $08 $35 $08 $38 $08
.db $81 $08 $78 $08 $79 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08

; 13th entry of Pointer Table from 2E85 (indexed by unknown)
; Data from EBC2 to EBD7 (22 bytes)
_DATA_EBC2_:
.db $01 $08 $02 $08 $61 $08 $62 $08 $63 $08 $64 $08 $65 $08 $08 $08
.db $7B $08 $67 $08 $68 $08

; 15th entry of Pointer Table from 2E85 (indexed by unknown)
; Data from EBD8 to EC81 (170 bytes)
_DATA_EBD8_:
.db $01 $08 $02 $08 $61 $08 $62 $08 $63 $08 $64 $08 $65 $08 $08 $08
.db $82 $08 $67 $08 $68 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $13 $08 $14 $08 $6A $08
.db $6B $08 $6C $08 $6D $08 $6E $08 $83 $08 $84 $08 $71 $08 $72 $08
.db $13 $08 $14 $08 $6A $08 $6B $08 $6C $08 $6D $08 $6E $08 $85 $08
.db $86 $08 $71 $08 $72 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $28 $08 $29 $08 $2A $08
.db $5A $08 $75 $08 $2D $08 $35 $08 $76 $08 $87 $08 $78 $08 $79 $08
.db $28 $08 $29 $08 $2A $08 $5A $08 $75 $08 $2D $08 $35 $08 $2F $08
.db $87 $08 $78 $08 $79 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08

; 17th entry of Pointer Table from 2E85 (indexed by unknown)
; Data from EC82 to EC97 (22 bytes)
_DATA_EC82_:
.db $01 $08 $02 $08 $61 $08 $62 $08 $63 $08 $64 $08 $65 $08 $41 $08
.db $88 $08 $67 $08 $68 $08

; 19th entry of Pointer Table from 2E85 (indexed by unknown)
; Data from EC98 to ED41 (170 bytes)
_DATA_EC98_:
.db $01 $08 $02 $08 $61 $08 $62 $08 $63 $08 $64 $08 $65 $08 $08 $08
.db $88 $08 $67 $08 $68 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $13 $08 $14 $08 $6A $08
.db $6B $08 $6C $08 $6D $08 $6E $08 $89 $08 $8A $08 $71 $08 $72 $08
.db $13 $08 $14 $08 $6A $08 $6B $08 $6C $08 $6D $08 $6E $08 $8B $08
.db $8C $08 $71 $08 $72 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $28 $08 $29 $08 $2A $08
.db $5A $08 $75 $08 $2D $08 $35 $08 $76 $08 $8D $08 $78 $08 $79 $08
.db $28 $08 $29 $08 $2A $08 $5A $08 $75 $08 $2D $08 $35 $08 $2F $08
.db $77 $08 $78 $08 $79 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08

; 21st entry of Pointer Table from 2E85 (indexed by unknown)
; Data from ED42 to ED57 (22 bytes)
_DATA_ED42_:
.db $01 $08 $02 $08 $61 $08 $62 $08 $63 $08 $64 $08 $65 $08 $08 $08
.db $69 $08 $67 $08 $68 $08

; 23rd entry of Pointer Table from 2E85 (indexed by unknown)
; Data from ED58 to EE01 (170 bytes)
_DATA_ED58_:
.db $01 $08 $02 $08 $61 $08 $62 $08 $63 $08 $64 $08 $65 $08 $08 $08
.db $8E $08 $8F $08 $68 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $13 $08 $14 $08 $6A $08
.db $6B $08 $6C $08 $6D $08 $6E $08 $90 $08 $91 $08 $71 $08 $72 $08
.db $13 $08 $14 $08 $6A $08 $6B $08 $6C $08 $6D $08 $6E $08 $6F $08
.db $92 $08 $93 $08 $72 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08 $28 $08 $29 $08 $2A $08
.db $5A $08 $75 $08 $2D $08 $35 $08 $76 $08 $94 $08 $78 $08 $79 $08
.db $28 $08 $29 $08 $2A $08 $5A $08 $75 $08 $2D $08 $35 $08 $76 $08
.db $95 $08 $78 $08 $79 $08 $00 $08 $00 $08 $00 $08 $00 $08 $00 $08
.db $00 $08 $00 $08 $00 $08 $00 $08 $00 $08

; Data from EE02 to F2C1 (1216 bytes)
_DATA_EE02_mapdata?:
.incbin "pf_e_DATA_EE02_.inc";Mapdata?

; Data from F2C2 to F2CF (14 bytes)
_DATA_F2C2_:
.db $01 $00 $02 $00 $03 $00 $04 $00 $05 $00 $06 $00 $07 $00

; Data from F2D0 to F481 (434 bytes)
_DATA_F2D0_:
.db $32 $00 $33 $00 $34 $00 $35 $00 $36 $00 $37 $00 $38 $00 $00 $0D
.dsb 33, $00
.db $07 $08 $00 $09 $00 $0A $00 $0B $00 $0C $00 $0D $00 $0E $00 $39
.db $00 $3A $00 $3B $00 $3C $00 $3D $00 $3E $00 $3F
.dsb 36, $00
.db $0E $0F $00 $10 $00 $11 $00 $12 $00 $13 $00 $14 $00 $15 $00 $40
.db $00 $41 $00 $42 $00 $43 $00 $44 $00 $45 $00 $46
.dsb 36, $00
.db $15 $16 $00 $17 $00 $18 $00 $19 $00 $1A $00 $1B $00 $1C $00 $47
.db $00 $48 $00 $49 $00 $4A $00 $4B $00 $4C $00 $4D $00 $00 $0E $01
.db $09 $05 $0D $03 $0B $07 $0F
.dsb 25, $00
.db $1C $1D $00 $1E $00 $1F $00 $20 $00 $21 $00 $22 $00 $23 $00 $4E
.db $00 $4F $00 $50 $00 $51 $00 $52 $00 $53 $00 $54 $00 $00 $0E $BF
.db $3E $10 $ED $79 $3E $C0 $00 $00 $ED $79 $0E $BE $06 $10 $ED $A3
.db $20 $FC $C9 $3A $00 $C4 $F5 $AF $32 $00 $C4 $2A $55 $C3 $11 $00
.db $23 $24 $00 $25 $00 $26 $00 $27 $00 $28 $00 $29 $00 $2A $00 $55
.db $00 $56 $00 $57 $00 $58 $00 $59 $00 $5A $00 $5B $00 $00 $00 $00
.db $01 $2C $01 $ED $B0 $21 $00 $C0 $CD $30 $05 $C1 $10 $DA $F1 $32
.db $00 $C4 $C9 $06 $20 $21 $00 $C0 $C5 $4E $79 $E6 $30 $28 $04 $79
.db $2A $2B $00 $2C $00 $2D $00 $2E $00 $2F $00 $30 $00 $31 $00 $5C
.db $00 $5D $00 $5E $00 $5F $00 $60 $00 $61 $00 $62 $00 $00 $00 $C4
.db $E5 $11 $20 $C0 $01 $20 $00 $ED $B0 $06 $04 $C5 $78 $21 $20 $C0
.db $11 $00 $C0 $01 $20 $00 $ED $B0 $F5 $CD $9C $05 $F1 $3D $20 $F8
.db $06
;The below palettes are used in the Character select screen.
; Data from F482 to F4C1 (64 bytes)
_DATA_F482_charSelectEffectTiles1:
.db $11 $CC $44 $FF $88 $66 $22 $FF $44 $33 $11 $FF $22 $99 $88 $FF
.db $11 $CC $44 $FF $88 $66 $22 $FF $44 $33 $11 $FF $22 $99 $88 $FF
.db $11 $CC $44 $FF $88 $66 $22 $FF $44 $33 $11 $FF $22 $99 $88 $FF
.db $11 $CC $44 $FF $88 $66 $22 $FF $44 $33 $11 $FF $22 $99 $88 $FF

; Data from F4C2 to F501 (64 bytes)
_DATA_F4C2_charSelectEffectTiles2:
.db $AA $33 $44 $00 $55 $99 $22 $00 $AA $CC $11 $00 $55 $66 $88 $00
.db $AA $33 $44 $00 $55 $99 $22 $00 $AA $CC $11 $00 $55 $66 $88 $00
.db $AA $33 $44 $00 $55 $99 $22 $00 $AA $CC $11 $00 $55 $66 $88 $00
.db $AA $33 $44 $00 $55 $99 $22 $00 $AA $CC $11 $00 $55 $66 $88 $00

; Data from F502 to F541 (64 bytes)
_DATA_F502_paletteCharSelect:
.db $65 $00 $66 $00 $67 $00 $67 $00 $67 $00 $67 $00 $67 $00 $67 $00
.db $67 $00 $67 $00 $67 $00 $67 $00 $67 $00 $67 $00 $67 $00 $67 $00
.db $67 $00 $67 $00 $67 $00 $67 $00 $67 $00 $67 $00 $67 $00 $67 $00
.db $67 $00 $67 $00 $67 $00 $67 $00 $67 $00 $68 $00 $65 $00 $65 $00

; Data from F542 to F581 (64 bytes)
_DATA_F542_palettescharSelect:
.db $65 $00 $69 $00 $6A $00 $6A $00 $6A $00 $6A $00 $6A $00 $6A $00
.db $6A $00 $6A $00 $6A $00 $6A $00 $6A $00 $6A $00 $6A $00 $6A $00
.db $6A $00 $6A $00 $6A $00 $6A $00 $6A $00 $6A $00 $6A $00 $6A $00
.db $6A $00 $6A $00 $6A $00 $6A $00 $6A $00 $6B $00 $65 $00 $65 $00

; Data from F582 to F5C1 (64 bytes)
_DATA_F582_palettesCharSelect:
.db $65 $00 $6C $00 $6D $00 $6D $00 $6D $00 $6D $00 $6D $00 $6D $00
.db $6D $00 $6D $00 $6D $00 $6D $00 $6D $00 $6D $00 $6D $00 $6D $00
.db $6D $00 $6D $00 $6D $00 $6D $00 $6D $00 $6D $00 $6D $00 $6D $00
.db $6D $00 $6D $00 $6D $00 $6D $00 $6D $00 $6E $00 $65 $00 $65 $00

; Data from F5C2 to F701 (320 bytes)
_DATA_F5C2_charSelectBGTiles:
.dsb 33, $00
.db $0F $00 $0F $0F $30 $00 $3F $30 $40 $00 $7F $20 $40 $00 $70 $40
.db $8E $0E $EE $40 $87 $07 $E7 $40 $83 $03 $E3 $40 $85 $05 $E5 $00
.db $FF $00 $FF $FF $00 $00 $FF $00 $00 $00 $FF $00 $00 $00 $00 $00
.db $EE $EE $EE $00 $47 $47 $47 $00 $83 $83 $83 $00 $C5 $C5 $C5 $00
.db $F0 $00 $F0 $F0 $0C $00 $FC $0C $02 $00 $FE $04 $02 $00 $0E $02
.db $E1 $E0 $E7 $02 $41 $40 $47 $02 $81 $80 $87 $02 $C1 $C0 $C7 $40
.db $8E $0E $EE $40 $8C $0C $EC $40 $88 $08 $E8 $40 $84 $04 $E4 $40
.db $8E $0E $EE $40 $87 $07 $E7 $40 $83 $03 $E3 $40 $85 $05 $E5 $00
.db $EE $EE $EE $00 $5C $5C $5C $00 $38 $38 $38 $00 $74 $74 $74 $00
.db $EE $EE $EE $00 $47 $47 $47 $00 $83 $83 $83 $00 $C5 $C5 $C5 $02
.db $E1 $E0 $E7 $02 $51 $50 $57 $02 $31 $30 $37 $02 $71 $70 $77 $02
.db $E1 $E0 $E7 $02 $41 $40 $47 $02 $81 $80 $87 $02 $C1 $C0 $C7 $40
.db $8E $0E $EE $40 $8C $0C $EC $40 $88 $08 $E8 $40 $84 $04 $E4 $20
.db $40 $00 $70 $30 $40 $00 $7F $0F $30 $00 $3F $00 $0F $00 $0F $00
.db $EE $EE $EE $00 $5C $5C $5C $00 $38 $38 $38 $00 $74 $74 $74 $00
.db $00 $00 $00 $00 $00 $00 $FF $FF $00 $00 $FF $00 $FF $00 $FF $02
.db $E1 $E0 $E7 $02 $51 $50 $57 $02 $31 $30 $37 $02 $71 $70 $77 $04
.db $02 $00 $0E $0C $02 $00 $FE $F0 $0C $00 $FC $00 $F0 $00 $F0

; Data from F702 to FFFF (2302 bytes)
_DATA_F702_characterSelectTimerTiles:;This is used on the character selection screen's timer.
.incbin "pf_e_DATA_F702_.inc"

.BANK 4
.ORG $0000

; Data from 10000 to 10DB7 (3512 bytes)
_DATA_10000_PitFighterLogoTileset:;This is the tilescreen's tileset, the Pit Fighter logo's.
.incbin "pf_e_DATA_10000_.inc"

; Data from 10DB8 to 10DBF (8 bytes)
_DATA_10DB8_:
.db $57 $00 $58 $00 $04 $00 $04 $00

; Data from 10DC0 to 10DDF (32 bytes)
_DATA_10DC0_palettes?:
.db $00 $15 $2A $3F $01 $02 $06 $0B $0F $04 $05 $10 $20 $30 $34 $3F
.db $00 $3F $3A $25 $10 $02 $0B $2A $15 $00 $1D $19 $04 $01 $17 $30

; Data from 10DE0 to 1139F (1472 bytes)
_DATA_10DE0_UltimateChallengeGraphics:
.dsb 32, $00
.db $03 $03 $03 $03 $03 $03 $03 $03 $02 $02 $02 $02
.dsb 20, $00
.db $FF $FF $FF $FF $7B $7B $7B $7B $79 $79 $79 $79
.dsb 20, $78
.db $08 $08 $08 $08 $78 $78 $78 $78 $38 $38 $38 $38 $38 $38 $38 $38
.db $3F $3F $3F $3F
.dsb 12, $3B
.dsb 16, $00
.db $07 $07 $07 $07 $8C $8C $8C $8C $9F $9F $9F $9F $9C $9C $9C $9C
.dsb 16, $00
.db $C0 $C0 $C0 $C0 $E0 $E0 $E0 $E0 $C0 $C0 $C0 $C0 $00 $00 $00 $00
.db $FD $FD $FD $FD
.dsb 28, $78
.db $F0 $F0 $F0 $F0 $E7 $E7 $E7 $E7
.dsb 24, $43
.db $82 $82 $82 $82 $82 $82 $82 $82 $86 $86 $86 $86 $8E $8E $8E $8E
.db $9F $9F $9F $9F
.dsb 12, $8E
.db $1C $1C $1C $1C $3E $3E $3E $3E $1C $1C $1C $1C $00 $00 $00 $00
.db $3C $3C $3C $3C
.dsb 12, $1C
.dsb 12, $00
.db $10 $10 $10 $10 $F6 $F6 $F6 $F6 $7F $7F $7F $7F $77 $77 $77 $77
.db $77 $77 $77 $77
.dsb 16, $00
.db $60 $60 $60 $60 $F1 $F1 $F1 $F1 $70 $70 $70 $70 $71 $71 $71 $71
.dsb 16, $00
.db $F8 $F8 $F8 $F8 $9C $9C $9C $9C $1C $1C $1C $1C $FC $FC $FC $FC
.db $10 $10 $10 $10 $10 $10 $10 $10 $30 $30 $30 $30 $70 $70 $70 $70
.db $F8 $F8 $F8 $F8 $70 $70 $70 $70 $71 $71 $71 $71 $71 $71 $71 $71
.dsb 16, $00
.db $7C $7C $7C $7C $CE $CE $CE $CE $FC $FC $FC $FC $C0 $C0 $C0 $C0
.db $00 $00 $00 $00 $03 $03 $03 $03 $07 $07 $07 $07
.dsb 20, $0F
.db $E4 $E4 $E4 $E4 $DD $DD $DD $DD $8C $8C $8C $8C $04 $04 $04 $04
.db $04 $04 $04 $04
.dsb 12, $00
.db $20 $20 $20 $20
.dsb 12, $E0
.db $FC $FC $FC $FC
.dsb 12, $EE
.dsb 16, $00
.db $1F $1F $1F $1F $33 $33 $33 $33 $03 $03 $03 $03 $3F $3F $3F $3F
.db $02 $02 $02 $02 $1E $1E $1E $1E
.dsb 12, $0E
.dsb 12, $8E
.db $08 $08 $08 $08 $78 $78 $78 $78
.dsb 16, $38
.db $39 $39 $39 $39 $39 $39 $39 $39 $00 $00 $00 $00 $00 $00 $00 $00
.db $01 $01 $01 $01 $02 $02 $02 $02 $1F $1F $1F $1F $3B $3B $3B $3B
.db $3B $3B $3B $3B $1F $1F $1F $1F $00 $00 $00 $00 $00 $00 $00 $00
.db $80 $80 $80 $80 $80 $80 $80 $80 $0F $0F $0F $0F $99 $99 $99 $99
.db $BF $BF $BF $BF $38 $38 $38 $38
.dsb 16, $00
.db $80 $80 $80 $80 $C0 $C0 $C0 $C0 $80 $80 $80 $80 $00 $00 $00 $00
.db $78 $78 $78 $78 $78 $78 $78 $78 $FC $FC $FC $FC
.dsb 20, $00
.db $3B $3B $3B $3B $3B $3B $3B $3B $7F $7F $7F $7F
.dsb 20, $00
.db $9E $9E $9E $9E $8F $8F $8F $8F $C7 $C7 $C7 $C7
.dsb 20, $00
.db $20 $20 $20 $20 $C0 $C0 $C0 $C0 $80 $80 $80 $80
.dsb 20, $00
.db $78 $78 $78 $78 $3C $3C $3C $3C $1F $1F $1F $1F
.dsb 20, $00
.db $43 $43 $43 $43 $83 $83 $83 $83 $07 $07 $07 $07
.dsb 20, $00
.db $8E $8E $8E $8E $8E $8E $8E $8E $C7 $C7 $C7 $C7
.dsb 20, $00
.db $1C $1C $1C $1C $9C $9C $9C $9C $3E $3E $3E $3E
.dsb 20, $00
.db $77 $77 $77 $77 $77 $77 $77 $77 $FF $FF $FF $FF
.dsb 20, $00
.db $73 $73 $73 $73 $73 $73 $73 $73 $F9 $F9 $F9 $F9
.dsb 20, $00
.db $9C $9C $9C $9C $9C $9C $9C $9C $EE $EE $EE $EE
.dsb 20, $00
.db $71 $71 $71 $71 $74 $74 $74 $74 $38 $38 $38 $38
.dsb 20, $00
.db $E2 $E2 $E2 $E2 $FC $FC $FC $FC $78 $78 $78 $78
.dsb 20, $00
.db $07 $07 $07 $07 $03 $03 $03 $03
.dsb 24, $00
.db $84 $84 $84 $84 $C8 $C8 $C8 $C8 $F1 $F1 $F1 $F1
.dsb 20, $00
.db $73 $73 $73 $73 $73 $73 $73 $73 $3D $3D $3D $3D
.dsb 20, $00
.db $8E $8E $8E $8E $8E $8E $8E $8E $DF $DF $DF $DF
.dsb 20, $00
.db $39 $39 $39 $39 $38 $38 $38 $38 $7C $7C $7C $7C
.dsb 20, $00
.db $0C $0C $0C $0C $3E $3E $3E $3E $BF $BF $BF $BF $07 $07 $07 $07
.db $31 $31 $31 $31 $1F $1F $1F $1F $00 $00 $00 $00 $00 $00 $00 $00
.db $3C $3C $3C $3C $1F $1F $1F $1F $8F $8F $8F $8F $80 $80 $80 $80
.db $80 $80 $80 $80
.dsb 12, $00
.db $40 $40 $40 $40 $80 $80 $80 $80
.dsb 41, $00
.db $F6 $E6 $32 $FF $AF $13 $7A $23 $13 $3A $00 $28 $00 $EA $00

; Data from 113A0 to 1141F (128 bytes)
_DATA_113A0_titleScreenCreditsTiles:
.db $5C $00 $5C $00 $5C $00 $5D $00 $5E $00 $5F $00 $60 $00 $61 $00
.db $62 $00 $63 $00 $64 $00 $65 $00 $66 $00 $67 $00 $68 $00 $69 $00
.db $6A $00 $6B $00 $6C $00 $6D $00 $6E $00 $6F $00 $70 $00 $6A $00
.db $66 $00 $71 $00 $72 $00 $73 $00 $5C $00 $5C $00 $5C $00 $5C $00
.db $5C $00 $5C $00 $5C $00 $5C $00 $74 $00 $75 $00 $76 $00 $77 $00
.db $78 $00 $79 $00 $7A $00 $7B $00 $7C $00 $7D $00 $7E $00 $7F $00
.db $80 $00 $81 $00 $82 $00 $7C $02 $83 $00 $84 $00 $85 $00 $80 $00
.db $7C $00 $86 $00 $87 $00 $88 $00 $5C $00 $5C $00 $5C $00 $5C $00

; Data from 11420 to 1191F (1280 bytes)
_DATA_11420_tileAndMap?:
.dsb 32, $00
.db $01 $01 $01 $01 $03 $03 $03 $03
.dsb 12, $06
.db $03 $03 $03 $03 $01 $01 $01 $01 $00 $00 $00 $00 $9E $9E $9E $9E
.dsb 20, $30
.db $9E $9E $9E $9E $00 $00 $00 $00 $C0 $C0 $C0 $C0 $60 $60 $60 $60
.dsb 12, $30
.db $60 $60 $60 $60 $C0 $C0 $C0 $C0 $00 $00 $00 $00 $0C $0C $0C $0C
.db $1C $1C $1C $1C
.dsb 16, $0C
.db $1E $1E $1E $1E $00 $00 $00 $00 $71 $71 $71 $71 $DB $DB $DB $DB
.db $DB $DB $DB $DB $79 $79 $79 $79 $18 $18 $18 $18 $18 $18 $18 $18
.db $71 $71 $71 $71 $00 $00 $00 $00 $C7 $C7 $C7 $C7 $6D $6D $6D $6D
.db $69 $69 $69 $69 $EA $EA $EA $EA $6C $6C $6C $6C $6D $6D $6D $6D
.db $C7 $C7 $C7 $C7 $00 $00 $00 $00 $00 $00 $00 $00
.dsb 20, $80
.db $00 $00 $00 $00 $00 $00 $00 $00 $21 $21 $21 $21 $71 $71 $71 $71
.db $DB $DB $DB $DB $D9 $D9 $D9 $D9 $F9 $F9 $F9 $F9 $D9 $D9 $D9 $D9
.db $D8 $D8 $D8 $D8 $00 $00 $00 $00 $80 $80 $80 $80 $80 $80 $80 $80
.db $DE $DE $DE $DE $83 $83 $83 $83 $8F $8F $8F $8F $9B $9B $9B $9B
.db $CF $CF $CF $CF $00 $00 $00 $00 $01 $01 $01 $01 $00 $00 $00 $00
.db $6D $6D $6D $6D $71 $71 $71 $71
.dsb 12, $61
.db $00 $00 $00 $00 $80 $80 $80 $80 $00 $00 $00 $00
.dsb 20, $80
.db $00 $00 $00 $00 $78 $78 $78 $78 $C0 $C0 $C0 $C0 $C3 $C3 $C3 $C3
.db $D8 $D8 $D8 $D8 $C9 $C9 $C9 $C9 $CB $CB $CB $CB $79 $79 $79 $79
.dsb 12, $00
.db $CE $CE $CE $CE $6F $6F $6F $6F $ED $ED $ED $ED $6D $6D $6D $6D
.db $ED $ED $ED $ED
.dsb 12, $00
.db $C7 $C7 $C7 $C7 $ED $ED $ED $ED $6F $6F $6F $6F $6C $6C $6C $6C
.db $67 $67 $67 $67
.dsb 12, $00
.db $1E $1E $1E $1E $B0 $B0 $B0 $B0 $9C $9C $9C $9C $06 $06 $06 $06
.db $BC $BC $BC $BC $00 $00 $00 $00 $01 $01 $01 $01
.dsb 20, $03
.db $01 $01 $01 $01 $00 $00 $00 $00 $E0 $E0 $E0 $E0 $00 $00 $00 $00
.db $07 $07 $07 $07
.dsb 12, $0D
.db $E7 $E7 $E7 $E7
.dsb 12, $00
.db $36 $36 $36 $36 $B8 $B8 $B8 $B8 $B0 $B0 $B0 $B0 $B0 $B0 $B0 $B0
.db $30 $30 $30 $30
.dsb 12, $00
.db $F1 $F1 $F1 $F1
.dsb 12, $DB
.db $F1 $F1 $F1 $F1 $C0 $C0 $C0 $C0 $00 $00 $00 $00 $00 $00 $00 $00
.db $CD $CD $CD $CD $6E $6E $6E $6E $6C $6C $6C $6C $6C $6C $6C $6C
.db $CC $CC $CC $CC
.dsb 12, $00
.db $BC $BC $BC $BC $06 $06 $06 $06 $1E $1E $1E $1E $36 $36 $36 $36
.db $1E $1E $1E $1E $00 $00 $00 $00 $66 $66 $66 $66 $60 $60 $60 $60
.db $F6 $F6 $F6 $F6
.dsb 12, $66
.db $36 $36 $36 $36
.dsb 12, $00
.db $73 $73 $73 $73
.dsb 12, $DB
.db $73 $73 $73 $73
.dsb 12, $00
.db $C0 $C0 $C0 $C0
.dsb 16, $60
.db $00 $00 $00 $00 $00 $00 $00 $00 $02 $02 $02 $02 $07 $07 $07 $07
.db $0D $0D $0D $0D $0D $0D $0D $0D $0F $0F $0F $0F $0D $0D $0D $0D
.db $0D $0D $0D $0D $00 $00 $00 $00 $3B $3B $3B $3B $19 $19 $19 $19
.dsb 20, $99
.db $00 $00 $00 $00
.dsb 28, $80
.db $00 $00 $00 $00 $03 $03 $03 $03 $00 $00 $00 $00 $DB $DB $DB $DB
.db $E3 $E3 $E3 $E3
.dsb 12, $C3
.db $00 $00 $00 $00 $01 $01 $01 $01 $01 $01 $01 $01 $3D $3D $3D $3D
.db $6D $6D $6D $6D $6D $6D $6D $6D $3D $3D $3D $3D $0D $0D $0D $0D
.db $00 $00 $00 $00 $83 $83 $83 $83 $83 $83 $83 $83 $E7 $E7 $E7 $E7
.dsb 12, $B3
.db $B1 $B1 $B1 $B1
.dsb 12, $00
.db $9E $9E $9E $9E $30 $30 $30 $30 $1C $1C $1C $1C $06 $06 $06 $06
.db $BC $BC $BC $BC
.dsb 12, $00
.dsb 20, $03
.dsb 12, $00
.db $67 $67 $67 $67 $8D $8D $8D $8D $0F $0F $0F $0F $0C $0C $0C $0C
.db $07 $07 $07 $07
.dsb 12, $00
.db $1E $1E $1E $1E $B0 $B0 $B0 $B0 $9C $9C $9C $9C $06 $06 $06 $06
.db $BC $BC $BC $BC
.dsb 12, $00
.db $73 $73 $73 $73 $DB $DB $DB $DB $FB $FB $FB $FB $C3 $C3 $C3 $C3
.db $7B $7B $7B $7B
.dsb 12, $00
.db $6D $6D $6D $6D $8D $8D $8D $8D $0D $0D $0D $0D $07 $07 $07 $07
.db $02 $02 $02 $02
.dsb 12, $00
.db $9C $9C $9C $9C $B6 $B6 $B6 $B6 $BE $BE $BE $BE $30 $30 $30 $30
.db $1E $1E $1E $1E $00 $00 $00 $00 $18 $18 $18 $18 $18 $18 $18 $18
.db $78 $78 $78 $78 $D8 $D8 $D8 $D8 $D8 $D8 $D8 $D8 $D9 $D9 $D9 $D9
.db $79 $79 $79 $79
.dsb 24, $00
.db $80 $80 $80 $80 $80 $80 $80 $80

; Data from 11920 to 1199F (128 bytes)
_DATA_11920_mapdata?:
.db $8A $00 $8A $00 $8A $00 $8A $00 $8B $00 $8C $00 $8D $00 $8E $00
.db $8F $00 $90 $00 $91 $00 $92 $00 $93 $00 $94 $00 $95 $00 $96 $00
.db $97 $00 $98 $00 $99 $00 $9A $00 $9B $00 $9C $00 $9D $00 $9E $00
.db $9F $00 $A0 $00 $A1 $00 $A2 $00 $8A $00 $8A $00 $8A $00 $8A $00
.db $8A $00 $8A $00 $8A $00 $8A $00 $8A $00 $8A $00 $8A $00 $8A $00
.db $8A $00 $A3 $00 $A4 $00 $A5 $00 $A6 $00 $A7 $00 $A8 $00 $A9 $00
.db $AA $00 $AB $00 $AC $00 $AD $00 $AE $00 $AF $00 $B0 $00 $B1 $00
.db $8A $00 $8A $00 $8A $00 $8A $00 $8A $00 $8A $00 $8A $00 $8A $00

; Data from 119A0 to 119E1 (66 bytes)
_DATA_119A0_:
.db $40 $8B $03 $09 $B8 $00 $06 $8C $02 $06 $C8 $18 $0A $8C $03 $06
.db $C8 $28 $50 $8B $04 $09 $B8 $40 $06 $8C $02 $06 $C8 $58 $1A $8C
.db $03 $06 $C8 $68 $20 $8C $04 $06 $C8 $80 $0A $8C $03 $06 $C8 $A0
.db $2E $8C $04 $06 $C8 $B8 $36 $8C $03 $06 $C8 $D8 $B8 $8D $02 $01
.db $F0 $E0

_LABEL_119E2_titleScreenPart1: ;Right after we load the bank with the title screen graphics, we land here.
;This is the part where the 'The Ultimate Challenge' and the Pit Fighter logo scrolls down letter by letter.
	xor a
	ld (_RAM_C3A2_timerml), a	;Reset this timer.
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -	;My guess is, that this timer is updated during vblank or something.
	call _LABEL_76F_timerBasedVDPDL ;These have some loading rountines, that are used as a timer, probably before the screen fades out.
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES	;Reset both palettes.
	ld hl, _DATA_10000_PitFighterLogoTileset
	ld de, $0020
	ld bc, $0B40	;2880 bytes
	call _LABEL_806_loadTiles
	ld hl, _DATA_10DE0_UltimateChallengeGraphics
	ld de, $0B80
	ld bc, $05A0	;1440 bytes
	call _LABEL_806_loadTiles
	ld hl, _DATA_113A0_titleScreenCreditsTiles
	ld de, $3982
	ld bc, $0080	;128 bytes Load these four tiles, but these are not used anywhere.
	call _LABEL_806_loadTiles
	ld hl, _DATA_11920_mapdata?
	ld de, $3D42
	ld bc, $0080
	call _LABEL_806_loadTiles
	ld hl, _DATA_11420_tileAndMap?
	ld de, $1140
	ld bc, $0500	;1280 bytes
	call _LABEL_806_loadTiles
	ld hl, _DATA_10DC0_palettes?	;Load the title screen palette.
	ld de, _RAM_C6CD_
	ld bc, $0010
	ldir	;Yes, it is. 16 colors.
	ld hl, _DATA_10DC0_palettes?
	ld bc, $0010
	ldir	;Once for the bg tiles, and once for the sprites, but they are the same anyways.
	ld hl, _DATA_10DB8_
	ld bc, $0102
	call _LABEL_11ADA_ ;This runs, when the letters run down from the upper side of the screen, but before 
	;the letters are drawn on the screen as background tiles.
	ld hl, $FFF8
	ld (_RAM_C33B_plyfieldborder), hl
	ld hl, $0000
	ld (_RAM_C33D_playFieldBaseHeight), hl
	ld hl, _RAM_C6CD_
	call _LABEL_5F5_timer+pal?	;This lets run the title screen demo, until the 'Ultimate Challenge' and the Atari credits are displayed, but not yet completely drawn with white.
	ld hl, $0000
	ld de, $0000
	ld bc, $0000
	ldir
	ldir
	ldir	;The game uses fake data transfers from ROM to ROM as a delay.
	ld hl, _DATA_119A0_
	ld a, $0B
-:
	push af
	call +
	pop af
	dec a
	jr nz, -
	ld hl, $0000
	ld de, $0000
	ld bc, $0000
	ldir
	ldir
	ldir
	call _LABEL_55C_delay+pal?
	ret

; Data from 11A8E to 11A90 (3 bytes)
.db $C3 $8E $9A

+:
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld c, (hl)
	inc hl
	ld b, (hl)
	ld (_RAM_C372_timer?), bc
	inc hl
	push hl
	ex de, hl
	call _LABEL_11ADA_
	pop hl
	ld a, (hl)
	inc hl
	ld e, (hl)
	inc e
	inc hl
	push hl
	ld d, $00
	ld bc, $FFB0
	srl a
	srl a
	srl a
	srl a
--:
	push af
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	push bc
	push de
	ld hl, _RAM_start
	call _LABEL_1425_SpriteMoveLoop?
	pop de
	pop hl
	ld bc, $0010
	add hl, bc
	push hl
	pop bc
	pop af
	dec a
	jr nz, --
	call _LABEL_11B22_
	pop hl
	ret
	;This is the part where the letters come down from the screen. Many parts of the code runs from RAM,
	;so most of this part will run from VBlank. Without commenting every line, it can be clearly seen what
	;the code does.

_LABEL_11ADA_:	;Let's see what this does.
	ld de, _RAM_start
	ld a, c
	ld (_RAM_C370_verticalScroll), a
	ld a, b
	ld b, $00
--:
	push af
	push hl
	ld c, $00
	ld a, (_RAM_C370_verticalScroll)
-:
	push af
	xor a
	ld (de), a
	inc de
	ldi
	inc hl
	ld a, c
	ld (de), a
	inc de
	ld a, b
	ld (de), a
	inc de
	ld a, c
	add a, $09
	ld c, a
	pop af
	dec a
	jr nz, -
	pop hl
	ld a, l
	cp $50
	jr nz, +
	ld a, h
	cp $8B
	jr nz, +
	ld a, $03
	ld (_RAM_C370_verticalScroll), a
+:
	push de
	ld de, $0040
	add hl, de
	pop de
	ld a, b
	add a, $09
	ld b, a
	pop af
	dec a
	jr nz, --
	ld a, $40
	ld (de), a
	ret

_LABEL_11B22_:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld a, c
	sub $10
	and $F8
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	srl e
	srl e
	add hl, de
	ld a, h
	add a, $38
	ld h, a
	inc hl
	inc hl
	ld de, $C000
	ld bc, (_RAM_C372_timer?)
	ld a, c
	ld (_RAM_C370_verticalScroll), a
	ld a, b
--:
	push af
	push hl
	ld a, (_RAM_C370_verticalScroll)
-:
	push af
	push af
	ld a, l
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, h
	or $40
	out (Port_VDPAddressControlPort), a
	pop af
	inc de
	ld a, (de)
	out (Port_VDPData), a
	inc de
	inc de
	inc de
	inc hl
	inc hl
	pop af
	dec a
	jr nz, -
	pop hl
	ld a, l
	and $3F
	cp $12
	jr nz, +
	ld a, $03
	ld (_RAM_C370_verticalScroll), a
+:
	push de
	ld de, $0040
	add hl, de
	pop de
	pop af
	dec a
	jr nz, --
	ei
	ret

; Data from 11B86 to 1365F (6874 bytes)
_DATA_11B86_:
.incbin "pf_e_DATA_11B86_.inc";This does not seem to be graphics, no idea yet.

_LABEL_13660_titleScreenPart2:	;This is the second part of the title screen sequence.
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES
	call _LABEL_76F_timerBasedVDPDL
	ld hl, _DATA_11B86_
	ld de, $1300
	call _LABEL_13748_
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld hl, $0000
	ld de, $0000
	ld bc, $012C
	ldir
	ld hl, _DATA_10DC0_palettes?
	call LOAD_BOTH_PALETTES
	xor a
	ld (_RAM_C370_verticalScroll), a
	ld (_RAM_C374_timer?), a
	ld a, $02
	ld (_RAM_C372_timer?), a
	ld hl, $B612
	ld (_RAM_C376_menuCursorPos), hl
_LABEL_1369F_:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld a, (_RAM_C370_verticalScroll)
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $89
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, (_RAM_C370_verticalScroll)
	inc a
	cp $E0
	jr nz, +
	xor a
+:
	ld (_RAM_C370_verticalScroll), a
	and $07
	jr nz, _LABEL_1369F_
	ld a, (_RAM_C370_verticalScroll)
	srl a
	srl a
	and $FE
	ld e, a
	ld d, $00
	ld hl, _DATA_12E0_
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld a, (_RAM_C372_timer?)
	inc a
	cp $03
	jr nz, +
	xor a
	ld (_RAM_C372_timer?), a
	ld a, (_RAM_C374_timer?)
	inc a
	ld (_RAM_C374_timer?), a
	cp $20
	jp z, ++
	ld hl, (_RAM_C376_menuCursorPos)
	inc hl
	inc hl
	ld (_RAM_C376_menuCursorPos), hl
	ld c, (hl)
	inc hl
	ld b, (hl)
	ld (_RAM_C378_titlescreenvscrolldata?), bc
	xor a
+:
	ld (_RAM_C372_timer?), a
	ld hl, (_RAM_C378_titlescreenvscrolldata?)
	ld bc, $003E
	call _LABEL_7EF_VDPdataLoad
	ld hl, (_RAM_C378_titlescreenvscrolldata?)
	ld de, $0040
	add hl, de
	ld (_RAM_C378_titlescreenvscrolldata?), hl
	jp _LABEL_1369F_

++:
	ld hl, $0000
	ld de, $0000
	ld bc, $0000
	ldir
	ldir
	ldir
	ldir
	ldir
	ldir
	ldir
	ldir
	call _LABEL_55C_delay+pal?
	call _LABEL_76F_timerBasedVDPDL
	ld a, $00
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $89
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ret

_LABEL_13748_:
	push hl
	ex de, hl
	ld (_RAM_C367_), hl
	push af
	ld a, l
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, h
	or $40
	out (Port_VDPAddressControlPort), a
	pop af
	pop hl
--:
	ld a, (hl)
	or a
	ret z
	bit 7, a
	jr nz, +
	ld b, a
	inc hl
-:
	ld a, (hl)
	call ++
	inc hl
	djnz -
	jp --

+:
	and $7F
	inc hl
	ld b, a
	ld a, (hl)
-:
	call ++
	djnz -
	inc hl
	jp --

++:
	push hl
	push af
	in a, (Port_VCounter)
	cp $B0
	jr c, +
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
-:
	in a, (Port_VCounter)
	cp $B0
	jr nc, -
	ld hl, (_RAM_C367_)
	push af
	ld a, l
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, h
	or $40
	out (Port_VDPAddressControlPort), a
	pop af
+:
	pop af
	out (Port_VDPData), a
	ld hl, (_RAM_C367_)
	inc hl
	ld (_RAM_C367_), hl
	pop hl
	ret

; Data from 137AE to 13FFF (2130 bytes)
_DATA_137AE_:
.db $01 $08 $02 $08 $03 $08 $04 $08 $05 $08 $06 $08 $07 $08 $08 $08
.db $09 $08 $0A $08 $0B $08 $0C $08 $0D $08 $0E $08 $0F $08 $10 $08
.db $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $00 $00
.db $FF $FF $FF $FF $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $FF $00
.db $11 $08 $12 $08 $13 $08 $14 $08 $15 $08 $16 $08 $17 $08 $18 $08
.db $19 $08 $1A $08 $1B $08 $1C $08 $1D $08 $1E $08 $1F $08 $20 $08
.db $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $00 $00
.db $FF $FF $FF $FF $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $FF $00
.db $21 $08 $22 $08 $23 $08 $24 $08 $25 $08 $26 $08 $27 $08 $28 $08
.db $29 $08 $2A $08 $2B $08 $2C $08 $2D $08 $2E $08 $2F $08 $30 $08
.db $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $00 $00
.db $FF $FF $FF $FF $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $FF $00
.db $31 $08 $32 $08 $33 $08 $34 $08 $35 $08 $36 $08 $37 $08 $38 $08
.db $39 $08 $3A $08 $3B $08 $3C $08 $3D $08 $3E $08 $3F $08 $40 $08
.db $FF $FF $00 $08 $04 $0C $02 $0A $06 $0E $01 $09 $05 $0D $03 $0B
.db $07 $0F
.dsb 14, $00
.db $41 $08 $42 $08 $43 $08 $44 $08 $45 $08 $46 $08 $47 $08 $48 $08
.db $49 $08 $4A $08 $4B $08 $4C $08 $4D $08 $4E $08 $4F $08 $50 $08
.db $0E $BE $06 $20 $ED $A3 $20 $FC $C9 $0E $BF $3E $10 $ED $79 $3E
.db $C0 $00 $00 $ED $79 $0E $BE $06 $10 $ED $A3 $20 $FC $C9 $3A $00
.db $51 $08 $52 $08 $53 $08 $54 $08 $55 $08 $56 $08 $57 $08 $58 $08
.db $59 $08 $5A $08 $5B $08 $5C $08 $5D $08 $5E $08 $5F $08 $60 $08
.db $B7 $28 $FA $10 $F4 $21 $00 $00 $11 $00 $00 $01 $2C $01 $ED $B0
.db $21 $00 $C0 $CD $30 $05 $C1 $10 $DA $F1 $32 $00 $C4 $C9 $06 $20
.db $61 $08 $62 $08 $63 $08 $64 $08 $65 $08 $66 $08 $67 $08 $68 $08
.db $69 $08 $6A $08 $6B $08 $6C $08 $6D $08 $6E $08 $6F $08 $70 $08
.db $10 $E1 $C9 $3A $00 $C4 $F5 $AF $32 $00 $C4 $E5 $11 $20 $C0 $01
.db $20 $00 $ED $B0 $06 $04 $C5 $78 $21 $20 $C0 $11 $00 $C0 $01 $20
.db $71 $08 $72 $08 $73 $08 $74 $08 $75 $08 $76 $08 $77 $08 $78 $08
.db $79 $08 $7A $08 $7B $08 $7C $08 $7D $08 $7E $08 $7F $08 $80 $08
.db $2C $01 $ED $B0 $21 $00 $C0 $CD $30 $05 $C1 $10 $C9 $06 $06 $AF
.db $32 $8A $C3 $3A $8A $C3 $B7 $28 $FA $10 $F4 $21 $00 $00 $11
.dsb 1619, $00

.BANK 5
.ORG $0000

; Data from 14000 to 17FFF (16384 bytes)
.incbin "pf_e_DATA_14000_.inc";This is Buzz's tile bank.

.BANK 6
.ORG $0000

; Data from 18000 to 1BFFF (16384 bytes)
.incbin "pf_e_DATA_18000_.inc" ;This is music, or something like that, but not graphics. Enemy patterns maybe?

.BANK 7
.ORG $0000

; Data from 1C000 to 1FFFF (16384 bytes)
.incbin "pf_e_DATA_1C000_.inc";Ty's bank? Again, at the end, some tiles are now triplicated.

.BANK 8
.ORG $0000

; Data from 20000 to 23FFF (16384 bytes)
.incbin "pf_e_DATA_20000_.inc";The Executioner's tileset? There are some duplicate stuff from the next bank.

.BANK 9
.ORG $0000

; Data from 24000 to 27FFF (16384 bytes)
.incbin "pf_e_DATA_24000_.inc";This seems to be Kato's tileset.

.BANK 10
.ORG $0000

; Data from 28000 to 2BFFF (16384 bytes)
.incbin "pf_e_DATA_28000_.inc" ;Southside Jim's tileset.

.BANK 11
.ORG $0000

; Data from 2C000 to 2FFFF (16384 bytes)
.incbin "pf_e_DATA_2C000_.inc" ;CC Rider's tileset.

.BANK 12
.ORG $0000

; Data from 30000 to 322E1 (8930 bytes)
.incbin "pf_e_DATA_30000_.inc" ;Tile and maps for the bar set. First the map, then the tiles.

; Data from 322E2 to 33441 (4448 bytes)
_DATA_322E2_DomarkMentalHospitalTiles:;Domark Mental hospital Ending screen.
.incbin "pf_e_DATA_322E2_.inc"

; Data from 33442 to 336C1 (640 bytes)
_DATA_33442_:
.db $35 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $37 $01 $38 $01 $39 $01 $39 $01 $39 $01 $39 $01 $39 $01
.db $39 $01 $39 $01 $39 $01 $39 $01 $39 $01 $39 $01 $37 $01 $3A $01
.db $3B $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3B $01 $3C $01 $3D $01 $3E $01 $3F $01 $40 $01 $41 $01
.db $42 $01 $43 $01 $44 $01 $45 $01 $46 $01 $47 $01 $48 $01 $3A $01
.db $3B $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3B $01 $3C $01 $49 $01 $4A $01 $4B $01 $4C $01 $4D $01
.db $4E $01 $4F $01 $50 $01 $51 $01 $51 $03 $47 $01 $48 $01 $3A $01
.db $3B $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3B $01 $3C $01 $52 $01 $53 $01 $54 $01 $55 $01 $56 $01
.db $57 $01 $47 $01 $47 $01 $47 $01 $47 $01 $47 $01 $48 $01 $3A $01
.db $3B $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3B $01 $3C $01 $58 $01 $59 $01 $5A $01 $5B $01 $5C $01
.db $5D $01 $5E $01 $5F $01 $60 $01 $61 $01 $62 $01 $48 $01 $3A $01
.db $3B $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3B $01 $3C $01 $63 $01 $64 $01 $65 $01 $66 $01 $67 $01
.db $68 $01 $69 $01 $6A $01 $6B $01 $6C $01 $6D $01 $48 $01 $3A $01
.db $3B $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3B $01 $3C $01 $6E $01 $6F $01 $70 $01 $71 $01 $72 $01
.db $47 $01 $47 $01 $47 $01 $47 $01 $47 $01 $47 $01 $48 $01 $3A $01
.db $3B $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3B $01 $73 $01 $74 $01 $74 $01 $74 $01 $74 $01 $74 $01
.db $74 $01 $74 $01 $74 $01 $75 $01 $47 $01 $47 $01 $48 $01 $3A $01
.db $3B $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3B $01 $76 $01 $77 $01 $78 $01 $79 $01 $7A $01 $7B $01
.db $7C $01 $7D $01 $7E $01 $7F $01 $47 $01 $47 $01 $48 $01 $3A $01
.db $80 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $81 $01 $82 $01 $83 $01 $83 $01 $83 $01 $83 $01 $83 $01
.db $83 $01 $83 $01 $83 $01 $84 $01 $47 $01 $47 $01 $48 $01 $3A $01

; Data from 336C2 to 33A01 (832 bytes)
_DATA_336C2_:
.db $38 $01 $85 $01 $39 $01 $39 $01 $39 $01 $39 $01 $39 $01 $39 $01
.db $39 $01 $86 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $36 $01 $87 $01 $88 $01 $88 $01 $88 $01 $88 $01 $88 $01
.db $88 $01 $88 $01 $88 $01 $88 $01 $88 $01 $88 $01 $48 $01 $3A $01
.db $89 $01 $8A $01 $8B $01 $8C $01 $8D $01 $8E $01 $47 $01 $47 $01
.db $47 $01 $48 $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3B $01 $3A $01
.db $8F $01 $90 $01 $91 $01 $92 $01 $93 $01 $47 $01 $47 $01 $47 $01
.db $47 $01 $94 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $95 $01 $3A $01
.db $96 $01 $97 $01 $98 $01 $99 $01 $47 $01 $47 $01 $47 $01 $47 $01
.db $47 $01 $48 $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3B $01 $3A $01
.db $9A $01 $9B $01 $9C $01 $9D $01 $47 $01 $47 $01 $47 $01 $47 $01
.db $47 $01 $94 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $95 $01 $3A $01
.db $9E $01 $9F $01 $A0 $01 $A1 $01 $A2 $01 $A3 $01 $A4 $01 $A5 $01
.db $47 $01 $48 $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3B $01 $3A $01
.db $9A $01 $A6 $01 $A7 $01 $A8 $01 $A9 $01 $AA $01 $AB $01 $AC $01
.db $47 $01 $48 $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3B $01 $3A $01
.db $9A $05 $AD $01 $AE $01 $AF $01 $B0 $01 $B1 $01 $B2 $01 $B3 $01
.db $B4 $01 $94 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $95 $01 $3A $01
.db $B5 $01 $B6 $01 $B7 $01 $B8 $01 $B9 $01 $BA $01 $BB $01 $BC $01
.db $BD $01 $BE $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3B $01 $3A $01
.db $3B $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3B $01 $3A $01
.db $3B $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3B $01 $3A $01
.db $3B $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01
.db $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3A $01 $3B $01 $3A $01
.db $80 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01
.db $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $36 $01 $81 $01 $3A $01

; Data from 33A02 to 33FFF (1534 bytes)
_DATA_33A02_letters:
.dsb 39, $00
.db $3C $62 $00 $00 $62 $00 $62 $00 $62 $7E $00 $00 $7E $00 $00 $00
.db $62 $62 $62 $62
.dsb 12, $00
.db $7C $62 $00 $00 $62 $00 $7C $00 $7C $62 $00 $00 $62 $00 $00 $00
.db $62 $7C $7C $7C
.dsb 12, $00
.db $3C $62 $00 $00 $62 $00 $60 $00 $60 $60 $00 $00 $60 $00 $00 $00
.db $62 $3C $3C $3C
.dsb 12, $00
.db $78 $64 $00 $00 $64 $00 $62 $00 $62 $62 $00 $00 $62 $00 $00 $00
.db $64 $78 $78 $78
.dsb 12, $00
.db $7E $60 $00 $00 $60 $00 $7C $00 $7C $60 $00 $00 $60 $00 $00 $00
.db $60 $7E $7E $7E
.dsb 12, $00
.db $7E $60 $00 $00 $60 $00 $7C $00 $7C $60 $00 $00 $60 $00 $00 $00
.db $60 $60 $60 $60
.dsb 12, $00
.db $3C $62 $00 $00 $62 $00 $60 $00 $60 $6E $00 $00 $6E $00 $00 $00
.db $62 $3E $3E $3E
.dsb 12, $00
.db $62 $62 $00 $00 $62 $00 $7E $00 $7E $62 $00 $00 $62 $00 $00 $00
.db $62 $62 $62 $62
.dsb 12, $00
.db $3C $18 $00 $00 $18 $00 $18 $00 $18 $18 $00 $00 $18 $00 $00 $00
.db $18 $3C $3C $3C
.dsb 12, $00
.db $06 $06 $00 $00 $06 $00 $06 $00 $06 $06 $00 $00 $06 $00 $00 $00
.db $46 $3C $3C $3C
.dsb 12, $00
.db $62 $64 $00 $00 $64 $00 $78 $00 $78 $64 $00 $00 $64 $00 $00 $00
.db $62 $62 $62 $62
.dsb 12, $00
.db $60 $60 $00 $00 $60 $00 $60 $00 $60 $60 $00 $00 $60 $00 $00 $00
.db $60 $7E $7E $7E
.dsb 12, $00
.db $62 $76 $00 $00 $76 $00 $6A $00 $6A $62 $00 $00 $62 $00 $00 $00
.db $62 $62 $62 $62
.dsb 12, $00
.db $42 $62 $00 $00 $62 $00 $72 $00 $72 $6A $00 $00 $6A $00 $00 $00
.db $66 $62 $62 $62
.dsb 12, $00
.db $3C $62 $00 $00 $62 $00 $62 $00 $62 $62 $00 $00 $62 $00 $00 $00
.db $62 $3C $3C $3C
.dsb 12, $00
.db $7C $62 $00 $00 $62 $00 $62 $00 $62 $7C $00 $00 $7C $00 $00 $00
.db $60 $60 $60 $60
.dsb 12, $00
.db $3C $62 $00 $00 $62 $00 $62 $00 $62 $6A $00 $00 $6A $00 $00 $00
.db $66 $3E $3E $3E
.dsb 12, $00
.db $7C $62 $00 $00 $62 $00 $62 $00 $62 $7C $00 $00 $7C $00 $00 $00
.db $62 $62 $62 $62
.dsb 12, $00
.db $3C $60 $00 $00 $60 $00 $3C $00 $3C $06 $00 $00 $06 $00 $00 $00
.db $66 $3C $3C $3C
.dsb 12, $00
.db $7E $18 $00 $00 $18 $00 $18 $00 $18 $18 $00 $00 $18 $00 $00 $00
.db $18 $18 $18 $18
.dsb 12, $00
.db $62 $62 $00 $00 $62 $00 $62 $00 $62 $62 $00 $00 $62 $00 $00 $00
.db $62 $3C $3C $3C
.dsb 12, $00
.db $62 $62 $00 $00 $62 $00 $62 $00 $62 $34 $00 $00 $34 $00 $00 $00
.db $34 $18 $18 $18
.dsb 12, $00
.db $62 $62 $00 $00 $62 $00 $62 $00 $62 $62 $00 $00 $62 $00 $00 $00
.db $6A $34 $34 $34
.dsb 12, $00
.db $62 $34 $00 $00 $34 $00 $18 $00 $18 $18 $00 $00 $18 $00 $00 $00
.db $34 $62 $62 $62
.dsb 12, $00
.db $46 $46 $00 $00 $46 $00 $3E $00 $3E $06 $00 $00 $06 $00 $00 $00
.db $46 $3C $3C $3C
.dsb 12, $00
.db $7E $0C $00 $00 $0C $00 $18 $00 $18 $30 $00 $00 $30 $00 $00 $00
.db $60 $7E $7E $7E
.dsb 12, $00
.db $3C $66 $00 $00 $66 $00 $6A $00 $6A $72 $00 $00 $72 $00 $00 $00
.db $62 $3C $3C $3C
.dsb 12, $00
.db $18 $38 $00 $00 $38 $00 $18 $00 $18 $18 $00 $00 $18 $00 $00 $00
.db $18 $18 $18 $18
.dsb 12, $00
.db $3C $46 $00 $00 $46 $00 $06 $00 $06 $3C $00 $00 $3C $00 $00 $00
.db $60 $7E $7E $7E
.dsb 12, $00
.db $3C $46 $00 $00 $46 $00 $0C $00 $0C $06 $00 $00 $06 $00 $00 $00
.db $46 $3C $3C $3C
.dsb 12, $00
.db $04 $0C $00 $00 $0C $00 $1C $00 $1C $2C $00 $00 $2C $00 $00 $00
.db $7E $0C $0C $0C
.dsb 12, $00
.db $7E $60 $00 $00 $60 $00 $7C $00 $7C $06 $00 $00 $06 $00 $00 $00
.db $46 $3C $3C $3C
.dsb 12, $00
.db $3C $60 $00 $00 $60 $00 $7C $00 $7C $62 $00 $00 $62 $00 $00 $00
.db $62 $3C $3C $3C
.dsb 12, $00
.db $7E $06 $00 $00 $06 $00 $0C $00 $0C $18 $00 $00 $18 $00 $00 $00
.db $18 $18 $18 $18
.dsb 12, $00
.db $3C $62 $00 $00 $62 $00 $3C $00 $3C $62 $00 $00 $62 $00 $00 $00
.db $62 $3C $3C $3C
.dsb 12, $00
.db $3C $46 $00 $00 $46 $00 $46 $00 $46 $3E $00 $00 $3E $00 $00 $00
.db $06 $3C $3C $3C
.dsb 28, $00
.db $18 $18 $18 $18
.dsb 323, $00

.BANK 13
.ORG $0000

; Data from 34000 to 363F1 (9202 bytes)
_unused_9k:
.incbin "pf_e_DATA_34000_.inc" ;This is not marked either.

; Data from 363F2 to 37051 (3168 bytes)
_DATA_363F2_optionsTiles:;These are the tiles for the options screen, enemy names, the arrow and so on.
;What is strange, that the Warrior was not meant to be playable from the beginning. The ROM is very very wasteful.
.incbin "pf_e_DATA_363F2_.inc"

; Data from 37052 to 37611 (1472 bytes)
_DATA_37052_: ;No idea.
.incbin "pf_e_DATA_37052_.inc"

; Data from 37612 to 37FFF (2542 bytes)
_DATA_37612_MarkoPuzzleLetters:
.incbin "pf_e_DATA_37612_.inc"

.BANK 14
.ORG $0000

; Data from 38000 to 3A271 (8818 bytes)
_unused_8k2:
.incbin "pf_e_DATA_38000_.inc" ;This is not referenced, but not tiles.

; Data from 3A272 to 3B271 (4096 bytes)
_DATA_3A272_MattTaylorEndingGfx:
.incbin "pf_e_DATA_3A272_.inc"

; Data from 3B272 to 3BAD1 (2144 bytes)
_DATA_3B272_BigLetters?:
.incbin "pf_e_DATA_3B272_.inc"

; Data from 3BAD2 to 3BB51 (128 bytes)
_DATA_3BAD2_:
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7E $01 $7F $01
.db $80 $01 $81 $01 $82 $01 $83 $01 $7D $01 $82 $01 $7D $01 $80 $01
.db $81 $01 $84 $01 $85 $01 $86 $01 $87 $01 $88 $01 $89 $01 $7D $01
.db $8A $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $8B $01 $8C $01
.db $8D $01 $8E $01 $8D $01 $8E $01 $7D $01 $8F $01 $90 $01 $8D $01
.db $8E $01 $91 $01 $92 $01 $93 $01 $94 $01 $95 $01 $96 $01 $7D $01
.db $97 $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01

; Data from 3BB52 to 3BBD1 (128 bytes)
_DATA_3BB52_:
.db $7D $01 $98 $01 $99 $01 $80 $01 $81 $01 $7D $01 $9A $01 $9B $01
.db $88 $01 $89 $01 $82 $01 $83 $01 $9C $01 $9D $01 $9A $01 $9B $01
.db $86 $01 $87 $01 $9E $01 $9F $01 $86 $01 $A0 $01 $80 $01 $81 $01
.db $98 $01 $99 $01 $82 $01 $83 $01 $84 $01 $85 $01 $7D $01 $7D $01
.db $7D $01 $A1 $01 $A2 $01 $8D $01 $8E $01 $7D $01 $A3 $01 $A4 $01
.db $95 $01 $96 $01 $8D $01 $8E $01 $A5 $01 $A6 $01 $A3 $01 $A4 $01
.db $93 $01 $94 $01 $A7 $01 $A8 $01 $93 $01 $A9 $01 $8D $01 $8E $01
.db $A1 $01 $A2 $01 $8D $01 $8E $01 $91 $01 $92 $01 $7D $01 $7D $01

; Data from 3BBD2 to 3BC51 (128 bytes)
_DATA_3BBD2_:
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $AA $01 $AB $01
.db $86 $01 $87 $01 $82 $01 $7D $01 $82 $01 $7D $01 $7D $01 $9C $01
.db $9D $01 $80 $01 $81 $01 $98 $01 $99 $01 $86 $01 $87 $01 $7D $01
.db $8A $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $AC $01 $AD $01
.db $93 $01 $94 $01 $8F $01 $90 $01 $8F $01 $90 $01 $7D $01 $A5 $01
.db $A6 $01 $8D $01 $8E $01 $A1 $01 $A2 $01 $93 $01 $94 $01 $7D $01
.db $97 $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01

; Data from 3BC52 to 3BCD1 (128 bytes)
_DATA_3BC52_:
.db $7D $01 $7D $01 $7D $01 $7D $01 $9A $01 $9B $01 $88 $01 $89 $01
.db $82 $01 $83 $01 $9C $01 $9D $01 $9A $01 $9B $01 $86 $01 $87 $01
.db $7D $01 $86 $01 $A0 $01 $80 $01 $81 $01 $98 $01 $99 $01 $82 $01
.db $83 $01 $84 $01 $85 $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $A3 $01 $A4 $01 $95 $01 $96 $01
.db $8D $01 $8E $01 $A5 $01 $A6 $01 $A3 $01 $A4 $01 $93 $01 $94 $01
.db $7D $01 $93 $01 $A9 $01 $8D $01 $8E $01 $A1 $01 $A2 $01 $8D $01
.db $8E $01 $91 $01 $92 $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01

; Data from 3BCD2 to 3BD91 (192 bytes)
_DATA_3BCD2_:
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $AE $01 $AF $01 $B0 $01 $B1 $01 $7D $01
.db $80 $01 $81 $01 $80 $01 $81 $01 $80 $01 $81 $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $B2 $01 $B3 $01 $7D $01 $B4 $01 $B5 $01
.db $8D $01 $8E $01 $8D $01 $8E $01 $8D $01 $8E $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $B6 $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01

; Data from 3BD92 to 3BE51 (192 bytes)
_DATA_3BD92_:
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $AE $01 $AF $01 $B7 $01 $B8 $01 $7D $01
.db $80 $01 $81 $01 $80 $01 $81 $01 $80 $01 $81 $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $B2 $01 $B3 $01 $B9 $01 $BA $01 $B5 $01
.db $8D $01 $8E $01 $8D $01 $8E $01 $8D $01 $8E $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $B6 $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01

; Data from 3BE52 to 3BFFF (430 bytes)
_DATA_3BE52_:
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $AE $01 $AF $01 $BB $01 $BC $01 $7D $01
.db $80 $01 $81 $01 $80 $01 $81 $01 $80 $01 $81 $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $B2 $01 $B3 $01 $BD $01 $BE $01 $B5 $01
.db $8D $01 $8E $01 $8D $01 $8E $01 $8D $01 $8E $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $B6 $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.db $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01 $7D $01
.dsb 238, $00

.BANK 15
.ORG $0000

; Data from 3C000 to 3E371 (9074 bytes)
_unused_9k:
.incbin "pf_e_DATA_3C000_.inc"	;This is not tile data, yet what else might it be? It is not referenced in
;the code. Upon disassembling this, it does not look like any code.

; Data from 3E372 to 3F371 (4096 bytes)
_DATA_3E372_MattHicksGfx:
.incbin "pf_e_DATA_3E372_.inc" ;Matt Hicks' ending portrait, and then some data.

; Data from 3F372 to 3FFFF (3214 bytes)
_DATA_3F372_graphics?:
.incbin "pf_e_DATA_3F372_.inc" ;I can't decipher what is this, but some kind of "interlaced" graphics?

.BANK 16
.ORG $0000

; Data from 40000 to 4245F (9312 bytes)
_DATA_40000_secondMatchCards: ;Cards, like No Pain No Gain and so on, so the second table that is shown under the number of the match.
.incbin "pf_e_DATA_40000_.inc"

; Data from 42460 to 43CBF (6240 bytes)
_DATA_42460_MatchTables: ;It contains every table that is shown between rounds, like Grudge Match and so on.
.incbin "pf_e_DATA_42460_.inc"

; Data from 43CC0 to 43D57 (152 bytes)
_DATA_43CC0_:
.db $02 $01 $53 $45 $41 $52 $43 $48 $49 $4E $47 $40 $44 $41 $54 $41
.db $40 $40 $0D $01 $02 $52 $45 $43 $4F $52 $44 $53 $65 $65 $65 $65
.db $40 $40 $40 $40 $40 $0D $01 $02
.dsb 16, $40
.db $0D $01 $02
.dsb 16, $40
.db $0D $01 $02 $5E $40 $46 $49 $4C $45 $53 $40 $46 $4F $55 $4E $44
.db $65 $40 $40 $0D $01 $02 $53 $54 $41 $4E $44 $42 $59 $65 $65 $65
.db $65 $40 $40 $40 $40 $40 $0D $01 $02
.dsb 16, $40
.db $0D $01 $02
.dsb 16, $40
.db $00

; Data from 43D58 to 43E0A (179 bytes)
_DATA_43D58_:
.db $10 $0B $41 $4E $44 $59 $40 $54 $41 $59 $4C $4F $52 $0D $0D $01
.db $11 $5D $5F $40 $59 $45 $41 $52 $53 $0D $0D $01 $0D $50 $52 $4F
.db $47 $52 $41 $4D $4D $49 $4E $47 $40 $57 $49 $54 $48 $0D $01 $0E
.db $49 $4E $54 $45 $4E $54 $40 $54 $4F $40 $4D $41 $49 $4D $45 $0D
.db $0D $01 $0B $54 $48 $45 $40 $50 $41 $54 $49 $45 $4E $54 $40 $44
.db $52 $49 $42 $42 $4C $45 $53 $0D $01 $02 $41 $40 $4C $4F $54 $40
.db $41 $4E $44 $40 $48 $41 $53 $40 $41 $40 $46 $49 $58 $41 $54 $49
.db $4F $4E $40 $57 $49 $54 $48 $0D $01 $02 $43 $41 $42 $42 $41 $47
.db $45 $53 $65 $40 $56 $45 $52 $59 $40 $56 $49 $4F $4C $45 $4E $54
.db $40 $57 $48 $45 $4E $0D $01 $02 $50 $49 $54 $46 $49 $47 $48 $54
.db $45 $52 $40 $49 $53 $40 $53 $41 $49 $44 $40 $54 $4F $40 $48 $49
.db $4D $65 $00

; Data from 43E0B to 43EC1 (183 bytes)
_DATA_43E0B_:
.db $10 $0B $4D $41 $54 $54 $40 $48 $49 $43 $4B $53 $0D $0D $01 $11
.db $5D $5B $40 $59 $45 $41 $52 $53 $0D $0D $01 $0B $43 $52 $41 $5A
.db $59 $40 $47 $52 $41 $50 $48 $49 $43 $40 $44 $45 $53 $49 $47 $4E
.db $0D $01 $0C $4E $4F $4E $40 $43 $4F $4D $50 $4F $53 $40 $4D $45
.db $4E $54 $49 $53 $65 $0D $0D $01 $0B $50 $41 $54 $49 $45 $4E $54
.db $40 $53 $55 $46 $46 $45 $52 $53 $40 $46 $52 $4F $4D $0D $01 $02
.db $44 $45 $4C $55 $53 $49 $4F $4E $53 $40 $4F $46 $40 $47 $52 $41
.db $4E $44 $45 $55 $52 $40 $55 $53 $49 $4E $47 $0D $01 $02 $4D $4F
.db $53 $54 $40 $4F $46 $40 $48 $49 $53 $40 $54 $49 $4D $45 $40 $54
.db $4F $40 $43 $41 $53 $54 $0D $01 $02 $4D $59 $53 $54 $49 $43 $41
.db $4C $40 $53 $50 $45 $4C $4C $53 $40 $4F $4E $40 $43 $4F $4C $4C
.db $45 $41 $47 $55 $45 $53 $00

; Data from 43EC2 to 43FFF (318 bytes)
_DATA_43EC2_:
.db $0E $0B $47 $55 $49 $4C $4C $41 $55 $4D $45 $40 $43 $41 $4D $55
.db $53 $0D $0D $01 $11 $5D $5D $40 $59 $45 $41 $52 $53 $0D $0D $01
.db $0E $53 $55 $50 $50 $4F $52 $54 $40 $41 $52 $54 $49 $53 $54 $0D
.db $01 $0B $41 $4E $44 $40 $56 $49 $43 $49 $4F $55 $53 $40 $44 $4F
.db $4F $44 $4C $49 $4E $47 $0D $0D $01 $0B $50 $41 $54 $49 $45 $4E
.db $54 $40 $49 $53 $40 $55 $4E $44 $45 $52 $40 $54 $48 $45 $0D $01
.db $02 $44 $45 $4C $55 $53 $49 $4F $4E $40 $48 $45 $40 $49 $53 $40
.db $41 $40 $46 $52 $4F $47 $65 $40 $4F $46 $54 $45 $4E $0D $01 $02
.db $43 $41 $54 $43 $48 $45 $53 $40 $46 $4C $49 $45 $53 $40 $49 $4E
.db $40 $48 $49 $53 $40 $4D $4F $55 $54 $48 $40 $0D $01 $02 $41 $4E
.db $44 $40 $54 $52 $49 $45 $53 $40 $54 $4F $40 $4C $41 $59 $40 $46
.db $52 $4F $47 $40 $53 $50 $41 $57 $4E $65
.dsb 132, $00

.BANK 17
.ORG $0000

; Data from 44000 to 47FFF (16384 bytes)
.incbin "pf_e_DATA_44000_.inc" ;This is Angel's graphics Bank.

.BANK 18 ;Related to the ending, there is Guillame Camus' head in it, but nothing else.
.ORG $0000

; Data from 48000 to 4AD8D (11662 bytes)
.incbin "pf_e_DATA_48000_.inc" ;Some graphics? It's completely compressed/coded, no idea.

; Data from 4AD8E to 4BFFF (4722 bytes)
_DATA_4AD8E_GuillameCamusGFX:
.incbin "pf_e_DATA_4AD8E_.inc" ;Guillame Camus' ending graphics, and some data after that.

.BANK 19 ;Chainman Edd Bank.
.ORG $0000

; Data from 4C000 to 4FFFF (16384 bytes)
.incbin "pf_e_DATA_4C000_.inc" ;Chainman Edd?

.BANK 20 ;Stage and options graphics.
.ORG $0000

; Data from 50000 to 518A3 (6308 bytes)
.incbin "pf_e_DATA_50000_.inc" ;This is an outside stage graphics.

; Data from 518A4 to 537C3 (7968 bytes)
_DATA_518A4_OptionsScreenTileset:
.incbin "pf_e_DATA_518A4_.inc"; Options screen tileset.

; Data from 537C4 to 53FFF (2108 bytes)
_DATA_537C4_DomarkLogoTileset:
.incbin "pf_e_DATA_537C4_.inc" ;Domark logo. For the Slider puzzle maybe?

.BANK 21 ;Level graphics mostly.
.ORG $0000

; Data from 54000 to 561C1 (8642 bytes)
.incbin "pf_e_DATA_54000_.inc" ;This is some sever type level tileset.

; Data from 561C2 to 56641 (1152 bytes)
_DATA_561C2_mapDataSewers?: ;Map data again?
.incbin "pf_e_DATA_561C2_.inc"

; Data from 56642 to 566C1 (128 bytes)
_DATA_56642_warriorMapData:
.db $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $A4 $01 $A5 $01 $A6 $01 $A7 $01 $A8 $01 $A9 $01
.db $AA $01 $AB $01 $A8 $01 $AC $01 $AD $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $AE $01 $AF $01 $B0 $01 $B1 $01 $B2 $01
.db $B3 $01 $B4 $01 $B1 $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01

; Data from 566C2 to 56781 (192 bytes)
_DATA_566C2_:
.db $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $AC $01 $B5 $01 $B6 $01 $B7 $01 $B8 $01
.db $B9 $01 $BA $01 $A4 $01 $A5 $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $0E $01 $B1 $03 $BB $01 $BC $01 $B8 $05
.db $BD $01 $BE $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01
.db $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01 $0E $01

; Data from 56782 to 57FFF (6270 bytes)
_DATA_56782_intermissionTiles:
.incbin "pf_e_DATA_56782_.inc" ;Intermission taunt screen with the Warrior. These are tiles and some map data.

.BANK 22 ;Round 9 and high score name entry graphics.
.ORG $0000

; Data from 58000 to 5A325 (8998 bytes)
.incbin "pf_e_DATA_58000_.inc" ;,Looks like tile and map data from round 9? The Warrior is on it, with his pose.

; Data from 5A326 to 5BFFF (7386 bytes)
_DATA_5A326_highScoreNameEntryTiles: ;HighScore name entry graphics. There is also some text for high score resetting?
.incbin "pf_e_DATA_5A326_.inc"

.BANK 23
.ORG $0000

; Data from 5C000 to 5F8FF (14592 bytes)
.incbin "pf_e_DATA_5C000_.inc" ;Heavy Metal's graphics.

; Data from 5F900 to 5FEFF (1536 bytes)
_DATA_5F900_PresentingThePitFighterTeamTiles:
.dsb 38, $00
.db $0E $00 $1F $00 $1F $00 $3B $3B $3B $00 $00 $00 $00 $33 $37 $00
.db $00 $37 $00 $3E $00 $3E $3C $00 $00 $3C
.dsb 19, $00
.db $18 $3C $00 $00 $3C $00 $65 $00 $65 $61 $00 $00 $61
.dsb 19, $00
.db $73 $DF $00 $00 $DF $00 $B6 $00 $B6 $E3 $00 $00 $E3
.dsb 19, $00
.db $8E $1B $00 $00 $1B $00 $36 $00 $36 $3C $00 $00 $3C
.dsb 19, $00
.db $18 $6D $00 $00 $6D $00 $CC $00 $CC $CC $00 $00 $CC $00 $00 $00
.db $00 $00 $00 $04 $00 $4C $00 $4C $00 $F8 $F8 $F8 $00 $00 $00 $00
.db $E4 $CC $00 $00 $CC $00 $CD $00 $CD $CD $00 $00 $CD
.dsb 19, $00
.db $30 $D9 $00 $00 $D9 $00 $9B $00 $9B $9B $00 $00 $9B
.dsb 19, $00
.db $E0 $B0 $00 $00 $B0 $00 $30 $00 $30 $30 $00 $00 $30 $00 $00 $00
.db $00 $00 $00 $00 $00 $02 $00 $02 $00 $07 $07 $07 $00 $00 $00 $00
.db $07 $0E $00 $00 $0E $00 $06 $00 $06 $06 $00 $00 $06 $00 $00 $00
.db $00 $00 $00 $20 $00 $60 $00 $60 $00 $E0 $E0 $E0 $00 $00 $00 $00
.db $6C $76 $00 $00 $76 $00 $66 $00 $66 $66 $00 $00 $66
.dsb 19, $00
.db $38 $6C $00 $00 $6C $00 $D8 $00 $D8 $F0 $00 $00 $F0 $00 $00 $00
.db $00 $00 $00 $01 $00 $03 $00 $03 $00 $07 $07 $07 $00 $00 $00 $00
.db $06 $06 $00 $00 $06 $00 $07 $00 $07 $07 $00 $00 $07 $00 $00 $00
.db $00 $00 $00 $C4 $00 $EC $00 $EC $00 $68 $68 $68 $00 $00 $00 $00
.db $64 $ED $00 $00 $ED $00 $CC $00 $CC $8C $00 $00 $8C $00 $00 $00
.db $00 $00 $00 $00 $00 $40 $00 $40 $00 $F0 $F0 $F0 $00 $00 $00 $00
.db $E0 $C7 $00 $00 $C7 $00 $CF $00 $CF $C0 $00 $00 $C0 $00 $00 $00
.db $00 $00 $00 $07 $00 $0F $00 $0F $00 $1C $1C $1C $00 $00 $00 $00
.db $18 $FF $00 $00 $FF $00 $DE $00 $DE $18 $00 $00 $18 $00 $00 $00
.db $00 $00 $00 $A0 $00 $60 $00 $60 $00 $40 $40 $40 $00 $00 $00 $00
.db $23 $66 $00 $00 $66 $00 $6C $00 $6C $6C $00 $00 $6C $00 $00 $00
.db $00 $00 $00 $08 $00 $18 $00 $18 $00 $18 $18 $18 $00 $00 $00 $00
.db $9B $DD $00 $00 $DD $00 $D9 $00 $D9 $D9 $00 $00 $D9 $00 $00 $00
.db $00 $00 $00 $00 $00 $08 $00 $08 $00 $1E $1E $1E $00 $00 $00 $00
.db $1C $B8 $00 $00 $B8 $00 $99 $00 $99 $99 $00 $00 $99
.dsb 19, $00
.db $71 $DB $00 $00 $DB $00 $B6 $00 $B6 $E6 $00 $00 $E6
.dsb 19, $00
.db $80 $C0 $00 $00 $C0 $00 $40 $00 $40
.dsb 10, $00
.db $03 $00 $1F $00 $1F $00 $3E $3E $3E $00 $00 $00 $00 $06 $06 $00
.db $00 $06 $00 $06 $00 $06 $06 $00 $00 $06 $00 $00 $00 $00 $00 $00
.db $C0 $00 $80 $00 $80 $00 $00 $00 $00 $00 $00 $00 $00 $0E $1B $00
.db $00 $1B $00 $36 $00 $36 $3C $00 $00 $3C
.dsb 19, $00
.db $38 $6C $00 $00 $6C $00 $CD $00 $CD $CD $00 $00 $CD
.dsb 19, $00
.db $33 $DD $00 $00 $DD $00 $99 $00 $99 $99 $00 $00 $99
.dsb 20, $00
.db $80 $00 $00 $80 $00 $80 $00 $80 $80 $00 $00 $80 $00 $00 $00 $30
.db $30 $30 $30 $00 $30 $00 $30
.dsb 24, $00
.db $61 $61 $61 $61 $00 $60 $00 $60
.dsb 24, $00
.db $91 $B3 $B3 $B3 $00 $E7 $00 $E7
.dsb 24, $00
.db $B2 $B6 $B6 $B6 $00 $1C $00 $1C
.dsb 24, $00
.db $CC $CC $CC $CC $00 $CC $00 $CC
.dsb 24, $00
.db $CD $CD $CD $CD $00 $CD $00 $CD
.dsb 24, $00
.db $9B $9B $9B $9B $00 $99 $00 $99
.dsb 24, $00
.db $30 $70 $70 $70 $00 $F0 $00 $F0 $00 $00 $00 $30 $00 $00 $00 $60
.db $00 $00 $00 $C0
.dsb 12, $00
.db $06 $06 $06 $06 $00 $06 $00 $06
.dsb 24, $00
.db $66 $66 $66 $66 $00 $66 $00 $66
.dsb 24, $00
.db $C8 $D8 $D8 $D8 $00 $70 $00 $70
.dsb 24, $00
.db $C0 $C0 $C0 $C0 $00 $C0 $00 $C0
.dsb 24, $00
.db $18 $18 $18 $18 $00 $18 $00 $18
.dsb 24, $00
.db $6C $6D $6D $6D $00 $67 $00 $67 $00 $00 $00 $00 $00 $00 $00 $01
.db $00 $00 $00 $03
.dsb 12, $00
.db $D9 $D9 $D9 $D9 $00 $D9 $00 $D9 $00 $00 $00 $C0 $00 $00 $00 $80
.dsb 16, $00
.db $99 $99 $99 $99 $00 $98 $00 $98
.dsb 24, $00
.db $96 $B6 $B6 $B6 $00 $E6 $00 $E6
.dsb 24, $00
.db $32 $36 $36 $36 $00 $1C $00 $1C
.dsb 24, $00
.db $CD $DD $DD $DD $00 $77 $00 $77
.dsb 24, $00
.db $99 $99 $99 $99 $00 $99 $00 $99
.dsb 24, $00
.db $80 $80 $80 $80 $00 $80 $00 $80
.dsb 37, $00
.db $F6 $E6 $32 $FF $AF $13 $7A $23 $13 $3A $00 $28 $CD $CD $00 $F3

; Data from 5FF00 to 5FFFF (256 bytes)
_DATA_5FF00_MapDataCredits:
.db $90 $01 $90 $01 $90 $01 $91 $01 $92 $01 $93 $01 $94 $01 $95 $01
.db $96 $01 $97 $01 $98 $01 $99 $01 $9A $01 $9B $01 $9C $01 $9D $01
.db $9E $01 $9F $01 $A0 $01 $A1 $01 $A2 $01 $A3 $01 $A4 $01 $A5 $01
.db $A6 $01 $A7 $01 $A8 $01 $A9 $01 $90 $01 $90 $01 $90 $01 $90 $01
.db $90 $01 $90 $01 $90 $01 $AA $01 $AB $01 $AC $01 $AD $01 $AE $01
.db $AF $01 $B0 $01 $B1 $01 $B2 $01 $B3 $01 $B4 $01 $B2 $01 $AA $03
.db $B5 $01 $B6 $01 $B7 $01 $B8 $01 $B9 $01 $BA $01 $90 $01 $B2 $01
.db $BB $01 $BC $01 $BD $01 $BE $01 $90 $01 $90 $01 $90 $01 $90 $01
.dsb 128, $00

.BANK 24 ;Looks like the bank for southside Jim, but Kato is also possible.
.ORG $0000

; Data from 60000 to 6377F (14208 bytes)
.incbin "pf_e_DATA_60000_.inc"

_LABEL_63780_playSoundEffect: ;This looks like a sound effect plying routine.
	call _LABEL_63946_
	ld a, (_RAM_C507_sounfEff)
	or a
	jr z, +
	xor a
	ld (_RAM_C508_soundEff2), a
	ld (_RAM_C528_soundEff3), a
	ld (_RAM_C548_soundEff4), a
	ld (_RAM_C568_soundEff5), a
	out (Port_PSG), a
	ld a, $BF
	out (Port_PSG), a
	ld a, $DF
	out (Port_PSG), a
	ld a, $FF
	out (Port_PSG), a
	ret

+:
	ld ix, _RAM_C508_soundEff2
	call +
	ld ix, _RAM_C528_soundEff3
	call +
	ld ix, _RAM_C548_soundEff4
	call +
	ld ix, _RAM_C568_soundEff5
+:
	ld a, (ix+0)
	or a
	ret z
	ld a, (ix+23)
	inc a
	ld (ix+23), a
	ld a, (ix+4)
	or a
	jr nz, ++
	ld a, (ix+0)
	and $10
	jr z, +
	ld a, $FF
	out (Port_PSG), a
+:
	xor a
	ld (ix+0), a
	ld a, $1F
	or (ix+5)
	out (Port_PSG), a
	ret

++:
	dec a
	ld (ix+4), a
	exx
	ld l, (ix+1)
	ld h, (ix+2)
	ld b, (ix+3)
	ld c, (ix+5)
	exx
	ld a, (ix+0)
	ld c, a
	call +
	exx
	ld (ix+1), l
	ld (ix+2), h
	ld (ix+3), b
	push hl
	ld a, c
	exx
	pop hl
	ld b, a
	ld a, l
	and $0F
	or b
	out (Port_PSG), a
	ld a, l
	rra
	rra
	rra
	rra
	and $0F
	ld l, a
	ld a, h
	rla
	rla
	rla
	rla
	and $30
	or l
	out (Port_PSG), a
	exx
	ld a, b
	exx
	or b
	or $10
	out (Port_PSG), a
	ret

+:
	bit 4, c
	jr z, +++
	ld a, (ix+20)
	or a
	jr z, +
	ld a, (ix+21)
	jp ++

+:
	exx
	ld a, b
	exx
++:
	or $F0
	out (Port_PSG), a
	ld a, (ix+22)
	or $E0
	out (Port_PSG), a
+++:
	bit 3, c
	jp z, ++
	ld a, (ix+23)
	and (ix+16)
	jp nz, ++
	ld a, (ix+17)
	or a
	jr z, +
	exx
	ld l, (ix+18)
	ld h, (ix+19)
	exx
	jp ++

+:
	exx
	ld e, (ix+18)
	ld d, (ix+19)
	add hl, de
	jr nc, +
	ld a, h
	and $03
	ld h, a
+:
	exx
++:
	bit 2, c
	jp z, ++
	ld a, (ix+12)
	or a
	jr z, +
	dec a
	ld (ix+12), a
	jp ++

+:
	ld a, (ix+14)
	or a
	jr z, +
	ld e, a
	ld a, (ix+23)
	and e
	jr nz, ++
+:
	ld a, (ix+13)
	or a
	jr nz, +
	ld a, c
	and $04
	ld c, a
	jr ++

+:
	dec a
	ld (ix+13), a
	ld a, (ix+15)
	exx
	add a, b
	and $0F
	ld b, a
	exx
++:
	bit 1, c
	jp z, _LABEL_63900_
	ld a, (ix+10)
	or a
	jp nz, +
	ld a, c
	and $02
	ld c, a
	jr _LABEL_63900_

+:
	ex af, af'
	ld a, (ix+23)
	and $01
	jp z, +
	ex af, af'
	dec a
	ld (ix+10), a
	ld l, (ix+11)
	ld h, $00
	neg
	ld e, a
	ld d, $FF
	add hl, de
	ex de, hl
	jp ++

+:
	ex af, af'
	dec a
	ld (ix+10), a
	ld e, a
	ld a, (ix+11)
	neg
	ld l, a
	ld h, $FF
	ld d, $00
	add hl, de
	ex de, hl
++:
	push de
	exx
	pop de
	add hl, de
	jr c, +
	ld a, h
	and $03
	ld h, a
+:
	exx
_LABEL_63900_:
	ld a, c
	rra
	ret nc
	ld a, (ix+6)
	or a
	jr z, ++
	dec a
	ld (ix+6), a
	ld a, (ix+7)
	exx
	ld d, $00
	ld e, a
	rla
	jr nc, +
	ld d, $FF
+:
	add hl, de
	jr c, +
	ld a, h
	and $03
	ld h, a
+:
	exx
	ret

++:
	ld a, (ix+8)
	or a
	jr nz, +
	ld a, c
	and $FE
	ld c, a
	ret

+:
	dec a
	ld (ix+8), a
	ld a, (ix+9)
	exx
	ld d, $00
	ld e, a
	rla
	jr nc, +
	ld d, $FF
+:
	add hl, de
	jr c, +
	ld a, h
	and $03
	ld h, a
+:
	exx
	ret

_LABEL_63946_:
	ld a, (_RAM_C507_sounfEff)
	or a
	ret nz
	ld hl, _RAM_C500_soundPointer
	ld (_RAM_C503_soundNumberTemp), hl
	ld a, (hl)
	or a
	call nz, +
	ld (hl), $00
	inc l
	ld a, (hl)
	or a
	call nz, +
	ld (hl), $00
	inc l
	ld a, (hl)
	or a
	call nz, +
	ld (hl), $00
	ret

+:
	push hl
	dec a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_63A00_
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld a, (_RAM_C506_hitCounter1)
	inc a
	and $03
	ld (_RAM_C506_hitCounter1), a
	or a
	jr z, +
	rrca
	rrca
	rrca
+:
	add a, $08
	ld l, a
	ld h, $C5
	ex de, hl
	ld a, (de)
	or a
	jr z, +
	and $10
	jr z, +
	ld a, $FF
	out (Port_PSG), a
+:
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ex de, hl
	xor a
	ld (hl), a
	ld a, (_RAM_C505_hitCounter2)
	inc a
	cp $03
	jp c, +
	xor a
+:
	ld (_RAM_C505_hitCounter2), a
	or a
	jr z, +
	cp $01
	jr z, ++
	ld e, $C0
	jp +++

+:
	ld e, $A0
	jp +++

++:
	ld e, $80
+++:
	ld a, l
	sub $12
	ld l, a
	ld (hl), e
	pop hl
	ret

_LABEL_639EF_:
	push hl
	ld hl, (_RAM_C503_soundNumberTemp)
	ld (hl), a
	ld a, l
	inc a
	and $03
	ld l, a
	ld (_RAM_C503_soundNumberTemp), hl
	pop hl
	ret

; Data from 639FE to 639FF (2 bytes)
_unused_2bytes:;Maybe this was used to pad something?
.db $00 $00

; Pointer Table from 63A00 to 63A19 (13 entries, indexed by _RAM_C500_soundPointer)
_DATA_63A00_:
.dw _DATA_63A1A_ _DATA_63A31_ _DATA_63A48_ _DATA_63A5F_ _DATA_63A76_ _DATA_63A8D_ _DATA_63AA4_ _DATA_63ABB_
.dw _DATA_63AD2_ _DATA_63AE9_ _DATA_63B00_ _DATA_63B17_ _DATA_63B2E_

; 1st entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63A1A to 63A30 (23 bytes)
_DATA_63A1A_:
.db $1D $8A $02 $00 $0A $C0 $FF $0A $00 $00 $32 $19 $01 $0F $00 $01
.db $07 $01 $2C $01 $00 $00 $06

; 2nd entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63A31 to 63A47 (23 bytes)
_DATA_63A31_:
.db $1D $8A $02 $00 $14 $C0 $FF $0A $00 $00 $32 $19 $01 $0F $00 $01
.db $07 $01 $64 $00 $00 $00 $06

; 3rd entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63A48 to 63A5E (23 bytes)
_DATA_63A48_:
.db $0D $4A $01 $00 $28 $A0 $FF $3C $00 $00 $FF $80 $05 $0F $01 $01
.db $00 $00 $00 $00 $00 $00 $06

; 4th entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63A5F to 63A75 (23 bytes)
_DATA_63A5F_:
.db $0F $DA $02 $00 $64 $A0 $FF $F6 $00 $00 $FF $80 $19 $0F $01 $01
.db $00 $00 $00 $00 $00 $00 $06

; 5th entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63A76 to 63A8C (23 bytes)
_DATA_63A76_:
.db $17 $64 $00 $00 $23 $A0 $05 $14 $0A $E7 $64 $32 $05 $0F $01 $01
.db $07 $01 $2C $01 $00 $00 $06

; 6th entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63A8D to 63AA3 (23 bytes)
_DATA_63A8D_:
.db $17 $C8 $00 $00 $23 $A0 $05 $14 $0A $E7 $64 $32 $05 $0F $01 $01
.db $07 $01 $2C $01 $00 $00 $06

; 7th entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63AA4 to 63ABA (23 bytes)
_DATA_63AA4_:
.db $1D $58 $02 $00 $46 $A0 $FF $F6 $00 $00 $32 $19 $05 $0F $03 $01
.db $03 $00 $64 $00 $00 $00 $04

; 8th entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63ABB to 63AD1 (23 bytes)
_DATA_63ABB_:
.db $1E $64 $00 $00 $41 $A0 $FF $EC $00 $00 $32 $19 $05 $0F $03 $01
.db $03 $00 $FA $00 $00 $00 $05

; 9th entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63AD2 to 63AE8 (23 bytes)
_DATA_63AD2_:
.db $1D $8A $02 $00 $02 $C0 $FF $0A $00 $00 $32 $19 $01 $0F $00 $01
.db $07 $01 $2C $01 $00 $00 $06

; 10th entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63AE9 to 63AFF (23 bytes)
_DATA_63AE9_:
.db $0D $4A $01 $00 $02 $A0 $FF $3C $00 $00 $FF $80 $05 $0F $01 $01
.db $00 $00 $00 $00 $00 $00 $06

; 11th entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63B00 to 63B16 (23 bytes)
_DATA_63B00_:
.db $17 $C8 $00 $00 $02 $A0 $05 $14 $0A $E7 $64 $32 $05 $0F $01 $01
.db $07 $01 $2C $01 $00 $00 $06

; 12th entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63B17 to 63B2D (23 bytes)
_DATA_63B17_:
.db $1D $58 $02 $00 $02 $A0 $FF $F6 $00 $00 $32 $19 $05 $0F $03 $01
.db $03 $00 $64 $00 $00 $00 $04

; 13th entry of Pointer Table from 63A00 (indexed by _RAM_C500_soundPointer)
; Data from 63B2E to 63B44 (23 bytes)
_DATA_63B2E_:
.db $1E $64 $00 $00 $02 $A0 $FF $EC $00 $00 $32 $19 $05 $0F $03 $01
.db $03 $00 $FA $00 $00 $00 $05

; Data from 63B45 to 63C84 (320 bytes)
_DATA_63B45_:
.db $8A $00 $8A $00 $8A $00 $8A $00 $8A $00 $8B $00 $8C $00 $8D $00
.db $8E $00 $8F $00 $90 $00 $91 $00 $8A $00 $8B $00 $8C $00 $8D $00
.db $92 $00 $93 $00 $8F $00 $8A $00 $94 $00 $95 $00 $96 $00 $96 $00
.db $97 $00 $98 $00 $8A $00 $8A $00 $8A $00 $8A $00 $8A $00 $8A $00
.db $8A $00 $8A $00 $8A $00 $8A $00 $8A $00 $99 $00 $9A $00 $9B $00
.db $9C $00 $9D $00 $9E $00 $9F $00 $8A $00 $99 $00 $9A $00 $9B $00
.db $A0 $00 $A1 $00 $9D $00 $8A $00 $A2 $00 $A3 $00 $A4 $00 $A5 $00
.db $A6 $00 $A7 $00 $8A $00 $8A $00 $8A $00 $8A $00 $8A $00 $8A $00
.db $A8 $00 $8A $00 $8A $00 $A9 $00 $8A $00 $AA $00 $AB $00 $AB $00
.db $AB $00 $AB $00 $AB $00 $AB $00 $AB $00 $AB $00 $AB $00 $AB $00
.db $AB $00 $AB $00 $AB $00 $AB $00 $AB $00 $AB $00 $AB $00 $AB $00
.db $AB $00 $AC $00 $8A $00 $8A $00 $8A $00 $8A $00 $8A $00 $8A $00
.db $AD $00 $AE $00 $AF $00 $B0 $00 $B1 $00 $B2 $00 $8A $00 $8A $00
.db $8B $00 $8C $00 $B3 $00 $B4 $00 $B5 $00 $B6 $00 $B7 $00 $8A $00
.db $8B $00 $8C $00 $B3 $00 $B8 $00 $B9 $00 $B5 $00 $8A $00 $BA $00
.db $B6 $00 $B6 $00 $BB $00 $BC $00 $BD $00 $BE $00 $BE $00 $8A $00
.db $BF $00 $AE $00 $C0 $00 $C1 $00 $C2 $00 $C3 $00 $8A $00 $8A $00
.db $99 $00 $9A $00 $C4 $00 $C5 $00 $C6 $00 $C7 $00 $C8 $00 $8A $00
.db $99 $00 $9A $00 $C4 $00 $C9 $00 $CA $00 $C6 $00 $8A $00 $CB $00
.db $C7 $00 $C7 $00 $CC $00 $CD $00 $CE $00 $CF $00 $CF $00 $8A $00

; Data from 63C85 to 63FFF (891 bytes)
_DATA_63C85_:
.db $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D1 $00 $D2 $00
.db $D3 $00 $D4 $00 $D5 $00 $D6 $00 $D7 $00 $D8 $00 $D9 $00 $DA $00
.db $DB $00 $DC $00 $DD $00 $DE $00 $DF $00 $E0 $00 $E1 $00 $E2 $00
.db $E3 $00 $E4 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00
.db $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $E5 $00 $E6 $00
.db $E7 $00 $E8 $00 $E9 $00 $EA $00 $EB $00 $EC $00 $ED $00 $EE $00
.db $EF $00 $F0 $00 $F1 $00 $F2 $00 $F3 $00 $F4 $00 $F5 $00 $F6 $00
.db $F7 $00 $F8 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00
.db $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $E5 $00 $F9 $00
.db $FA $00 $FB $00 $FC $00 $FD $00 $FE $00 $FF $00 $00 $01 $01 $01
.db $02 $01 $03 $01 $04 $01 $05 $01 $06 $01 $07 $01 $08 $01 $09 $01
.db $0A $01 $F8 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00
.db $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $0B $01 $0C $01
.db $0C $01 $0C $01 $0D $01 $0E $01 $0F $01 $0C $01 $0C $01 $0C $01
.db $0C $01 $0C $01 $0C $01 $0C $01 $0C $01 $0C $01 $0C $01 $0C $01
.db $0C $01 $10 $01 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00
.db $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00
.db $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00
.db $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00
.db $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0 $00 $D0
.dsb 572, $00

.BANK 25 ;Bank for Buzz? I can't quite make it out with TLP.
.ORG $0000

; Data from 64000 to 67FFF (16384 bytes)
.incbin "pf_e_DATA_64000_.inc"

.BANK 26 ;Contains the Ending graphics, and possibly the code for it.
.ORG $0000

; Data from 68000 to 6B79F (14240 bytes)
_DATA_68000_EndingGrxTiles: ;The ending graphics.
.incbin "pf_e_DATA_68000_.inc"

; Data from 6B7A0 to 6BD5F (1472 bytes)
_DATA_6B7A0_EndingGfxMapdata?: ;Mapdata? Music? This should be mapdata again.
.incbin "pf_e_DATA_6B7A0_.inc"

; Data from 6BD60 to 6BD7F (32 bytes)
_DATA_6BD60_EndingGfxPalette: ;Palette for the ending graphics.
.db $00 $04 $08 $3F $01 $02 $06 $07 $1B $1F $2F $10 $20 $30 $34 $39
.db $00 $04 $08 $3F $01 $02 $06 $07 $1B $1F $2F $10 $20 $30 $34 $39

_LABEL_6BD80_InitiateEnding:
	di
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES
	call _LABEL_2103_PSGSilence+Bankswitch
	ld a, $FF
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $8A
	out (Port_VDPAddressControlPort), a
	nop
	nop
	call _LABEL_6CD_tilemap_clear
	ld hl, _LABEL_DFD_titleScreenMainLoop?
	ld (_RAM_C391_pointer?), hl
	ld hl, _DATA_74D5C_charSelectMusic
	call SelectMusicBank
	xor a
	ld (_RAM_C36C_canExitFromOptions), a
	ld (_RAM_C8B7_showSpriteHScore), a
	ld hl, _DATA_68000_EndingGrxTiles
	ld de, $0060
	ld bc, $3780
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_6B7A0_EndingGfxMapdata?
	ld de, $3802
	ld bc, $05C0
	call _LABEL_7EF_VDPdataLoad
	ei
	ld hl, _DATA_6BD60_EndingGfxPalette
	call _LABEL_5F5_timer+pal?
	ld b, $FF
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	jp _LABEL_21B4_CreditsEntryPoint

; Data from 6BDEA to 6BFFF (534 bytes)
.dsb 534, $00

.BANK 27
.ORG $0000

; Data from 6C000 to 6D73F (5952 bytes)
_DATA_6C000_twoPlayerStatsTilesandMap: ;This is the graphics for the two player match statistics.
.incbin "pf_e_DATA_6C000_.inc"

; Data from 6D740 to 6D7BF (128 bytes)
_DATA_6D740_:
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $06 $01 $07 $01 $08 $01
.db $09 $01 $0A $01 $0B $01 $0C $01 $0D $01 $05 $01 $0E $01 $0F $01
.db $10 $01 $11 $01 $08 $01 $09 $01 $10 $01 $11 $01 $12 $01 $13 $01
.db $0E $01 $0F $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $14 $01
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $15 $01 $16 $01 $17 $01
.db $18 $01 $19 $01 $1A $01 $1B $01 $1C $01 $05 $01 $1D $01 $1E $01
.db $1F $01 $20 $01 $17 $01 $18 $01 $1F $01 $20 $01 $21 $01 $22 $01
.db $1D $01 $1E $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01

; Data from 6D7C0 to 6D7DF (32 bytes)
_DATA_6D7C0_:
.db $23 $01 $09 $01 $12 $01 $05 $01 $08 $01 $09 $01 $24 $01 $25 $01
.db $0C $01 $0D $01 $23 $01 $09 $01 $05 $01 $26 $01 $27 $01 $05 $01

; Data from 6D7E0 to 6D83F (96 bytes)
_DATA_6D7E0_:
.db $28 $01 $29 $01 $2A $01 $28 $01 $29 $01 $2A $01 $28 $01 $29 $01
.db $2A $01 $28 $01 $29 $01 $2A $01 $28 $01 $29 $01 $2A $01 $14 $01
.db $2B $01 $2C $01 $2D $01 $2E $01 $17 $01 $18 $01 $2F $01 $30 $01
.db $1B $01 $1C $01 $31 $01 $32 $01 $05 $01 $05 $01 $33 $01 $05 $01
.db $34 $01 $35 $01 $36 $01 $34 $01 $35 $01 $36 $01 $34 $01 $35 $01
.db $36 $01 $34 $01 $35 $01 $36 $01 $34 $01 $35 $01 $36 $01 $05 $01

; Data from 6D840 to 6D87F (64 bytes)
_DATA_6D840_:
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $37 $01 $38 $01 $39 $01 $37 $01 $38 $01 $39 $01 $37 $01 $38 $01
.db $39 $01 $37 $01 $38 $01 $39 $01 $37 $01 $38 $01 $39 $01 $14 $01

; Data from 6D880 to 6D8FF (128 bytes)
_DATA_6D880_:
.db $23 $01 $09 $01 $12 $01 $05 $01 $08 $01 $09 $01 $24 $01 $25 $01
.db $0C $01 $0D $01 $23 $01 $09 $01 $05 $01 $3A $01 $3B $01 $05 $01
.db $3C $01 $3D $01 $3E $01 $28 $01 $29 $01 $2A $01 $28 $01 $29 $01
.db $2A $01 $28 $01 $29 $01 $2A $01 $28 $01 $29 $01 $2A $01 $05 $01
.db $2B $01 $2C $01 $2D $01 $2E $01 $17 $01 $18 $01 $2F $01 $30 $01
.db $1B $01 $1C $01 $31 $01 $32 $01 $05 $01 $3F $01 $40 $01 $05 $01
.db $41 $01 $14 $01 $42 $01 $34 $01 $35 $01 $36 $01 $34 $01 $35 $01
.db $36 $01 $34 $01 $35 $01 $36 $01 $34 $01 $35 $01 $36 $01 $14 $01

; Data from 6D900 to 6D97F (128 bytes)
_DATA_6D900_:
.db $43 $01 $44 $01 $45 $01 $46 $01 $47 $01 $0E $01 $0F $01 $05 $01
.db $45 $01 $45 $01 $45 $01 $45 $01 $45 $01 $05 $01 $05 $01 $05 $01
.db $48 $01 $49 $01 $4A $01 $37 $01 $38 $01 $39 $01 $37 $01 $38 $01
.db $39 $01 $37 $01 $38 $01 $39 $01 $37 $01 $38 $01 $39 $01 $05 $01
.db $4B $01 $4C $01 $33 $01 $4D $01 $4E $01 $1D $01 $1E $01 $05 $01
.db $4F $01 $4F $01 $4F $01 $4F $01 $4F $01 $05 $01 $05 $01 $05 $01
.db $3C $01 $3D $01 $3E $01 $3C $01 $3D $01 $3E $01 $28 $01 $29 $01
.db $2A $01 $28 $01 $29 $01 $2A $01 $28 $01 $29 $01 $2A $01 $14 $01

; Data from 6D980 to 6D98F (16 bytes)
_DATA_6D980_palette?:
.db $50 $01 $51 $01 $52 $01 $53 $01 $54 $01 $55 $01 $56 $01 $57 $01

; Data from 6D990 to 6D9FF (112 bytes)
_DATA_6D990_:
.db $50 $01 $51 $01 $52 $01 $53 $01 $54 $01 $58 $01 $59 $01 $5A $01
.db $41 $01 $14 $01 $42 $01 $41 $01 $14 $01 $42 $01 $34 $01 $35 $01
.db $36 $01 $34 $01 $35 $01 $36 $01 $34 $01 $35 $01 $36 $01 $05 $01
.db $5B $01 $5C $01 $5D $01 $5E $01 $5F $01 $60 $01 $61 $01 $5E $03
.db $5B $01 $5C $01 $5D $01 $5E $01 $5F $01 $62 $01 $63 $01 $64 $01
.db $48 $01 $49 $01 $4A $01 $48 $01 $49 $01 $4A $01 $37 $01 $38 $01
.db $39 $01 $37 $01 $38 $01 $39 $01 $37 $01 $38 $01 $39 $01 $14 $01

; Data from 6DA00 to 6DCFF (768 bytes)
_DATA_6DA00_:
.db $65 $01 $66 $01 $67 $01 $68 $01 $69 $01 $6A $01 $6B $01 $6C $01
.db $6D $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $3C $01 $3D $01 $3E $01 $3C $01 $3D $01 $3E $01 $3C $01 $3D $01
.db $3E $01 $28 $01 $29 $01 $2A $01 $28 $01 $29 $01 $2A $01 $05 $01
.db $05 $01 $6E $01 $6F $01 $70 $01 $71 $01 $72 $01 $73 $01 $74 $01
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $41 $01 $14 $01 $42 $01 $41 $01 $14 $01 $42 $01 $41 $01 $14 $01
.db $42 $01 $34 $01 $35 $01 $36 $01 $34 $01 $35 $01 $36 $01 $14 $01
.db $75 $01 $76 $01 $77 $01 $78 $01 $79 $01 $7A $01 $7B $01 $7C $01
.db $7D $01 $7E $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $48 $01 $49 $01 $4A $01 $48 $01 $49 $01 $4A $01 $48 $01 $49 $01
.db $4A $01 $37 $01 $38 $01 $39 $01 $37 $01 $38 $01 $39 $01 $05 $01
.db $05 $01 $7F $01 $80 $01 $81 $01 $82 $01 $83 $01 $84 $01 $85 $01
.db $86 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $3C $01 $3D $01 $3E $01 $3C $01 $3D $01 $3E $01 $3C $01 $3D $01
.db $3E $01 $3C $01 $3D $01 $3E $01 $28 $01 $29 $01 $2A $01 $14 $01
.db $87 $01 $88 $01 $89 $01 $8A $01 $8B $01 $8C $01 $8D $01 $8E $01
.db $8F $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $41 $01 $14 $01 $42 $01 $41 $01 $14 $01 $42 $01 $41 $01 $14 $01
.db $42 $01 $41 $01 $14 $01 $42 $01 $34 $01 $35 $01 $36 $01 $05 $01
.db $5F $03 $90 $01 $60 $03 $5B $03 $64 $03 $91 $01 $92 $01 $62 $03
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $48 $01 $49 $01 $4A $01 $48 $01 $49 $01 $4A $01 $48 $01 $49 $01
.db $4A $01 $48 $01 $49 $01 $4A $01 $37 $01 $38 $01 $39 $01 $14 $01
.db $93 $01 $94 $01 $95 $01 $96 $01 $97 $01 $98 $01 $99 $01 $9A $01
.db $9B $01 $9C $01 $9D $01 $9E $01 $9F $01 $05 $01 $05 $01 $05 $01
.db $3C $01 $3D $01 $3E $01 $3C $01 $3D $01 $3E $01 $3C $01 $3D $01
.db $3E $01 $3C $01 $3D $01 $3E $01 $3C $01 $3D $01 $3E $01 $05 $01
.db $A0 $01 $90 $01 $A1 $01 $05 $01 $A2 $01 $05 $01 $A3 $01 $A4 $01
.db $A5 $01 $A6 $01 $86 $03 $71 $03 $05 $01 $05 $01 $05 $01 $05 $01
.db $41 $01 $14 $01 $42 $01 $41 $01 $14 $01 $42 $01 $41 $01 $14 $01
.db $42 $01 $41 $01 $14 $01 $42 $01 $41 $01 $14 $01 $42 $01 $14 $01
.db $A7 $01 $A8 $01 $A9 $01 $AA $01 $05 $01 $AB $01 $AC $01 $AD $01
.db $AE $01 $AF $01 $B0 $01 $6D $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $48 $01 $49 $01 $4A $01 $48 $01 $49 $01 $4A $01 $48 $01 $49 $01
.db $4A $01 $48 $01 $49 $01 $4A $01 $48 $01 $49 $01 $4A $01 $05 $01
.db $A0 $01 $B1 $01 $B2 $01 $B3 $01 $05 $01 $B4 $01 $B5 $01 $A1 $01
.db $B6 $01 $B7 $01 $B8 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $14 $01
.db $65 $01 $66 $01 $67 $01 $68 $01 $B9 $01 $BA $01 $BB $01 $BC $01
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $05 $01 $6E $01 $6F $01 $70 $01 $82 $01 $BD $01 $70 $01 $05 $01
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01
.db $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $05 $01 $BE $01

_LABEL_6DD00_:
	di
	call _LABEL_6CD_tilemap_clear
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES
	ld a, $1B
	ld (_RAM_C64E_BANKSWITCH_PAGE), a
	ld hl, _LABEL_DFD_titleScreenMainLoop?
	ld (_RAM_C391_pointer?), hl
	ld hl, _DATA_75360_optionsMusic
	call SelectMusicBank
	xor a
	ld (_RAM_C354_isroundon), a
	ld (_RAM_C398_isroundon), a
	ld hl, _DATA_6C000_twoPlayerStatsTilesandMap
	ld de, $20A0
	ld bc, $1740
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_6D740_
	ld de, $3982
	ld bc, $0080
	call _LABEL_7EF_VDPdataLoad
	ld de, $3A42
	ld hl, _DATA_6D7C0_
	ld bc, $021E
	call _LABEL_2EB5_vramLoad?
	ld de, $3B02
	ld hl, _DATA_6D840_
	ld bc, $031E
	call _LABEL_2EB5_vramLoad?
	ld hl, (_RAM_C8CE_)
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	push hl
	add hl, hl
	pop de
	add hl, de
	ld de, _DATA_6D7E0_
	add hl, de
	ld de, $3A62
	ld bc, $031E
	call _LABEL_2EB5_vramLoad?
	ld hl, (_RAM_C8CF_)
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	push hl
	add hl, hl
	pop de
	add hl, de
	ld de, _DATA_6D7E0_
	add hl, de
	ld de, $3B62
	ld bc, $031E
	call _LABEL_2EB5_vramLoad?
	ld a, (_RAM_C8CE_)
	cp $05
	jr z, _LABEL_6DE09_
	ld e, a
	ld hl, _DATA_6D980_palette?
	ld a, (_RAM_C8CF_)
	cp $05
	jp z, _LABEL_6DE2A_
	cp e
	jr z, ++
	jr nc, +
	ld hl, _DATA_6D990_
+:
	ld de, $3C4C
	ld bc, $0210
	call _LABEL_2EB5_vramLoad?
	ld a, (_RAM_C8D0_)
	inc a
	cp $06
	jr c, +
	xor a
+:
	ld (_RAM_C8D0_), a
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, _DATA_6DA00_
	add hl, de
	ld de, $3C60
	ld bc, $021C
	call _LABEL_2EB5_vramLoad?
++:
	ei
	ld hl, _DATA_397F_paletteOptions
	call _LABEL_5F5_timer+pal?
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld a, (_RAM_C393_JOYPAD1)
	ld e, a
	ld a, (_RAM_C394_JOYPAD2)
	or e
	and $30
	jr z, --
	ld a, $01
	call _LABEL_20F7_fadeoutandStop?
	ld b, $64
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	di
	ret

_LABEL_6DE09_:
	ld de, $3C42
	ld hl, _DATA_6D7C0_
	ld bc, $021E
	call _LABEL_2EB5_vramLoad?
	ld hl, _DATA_6D900_
	ld de, $3C62
	ld bc, $021E
	call _LABEL_2EB5_vramLoad?
	ld hl, $0000
	ld (_RAM_C781_plyr2stats?), hl
	jp +

_LABEL_6DE2A_:
	ld de, $3C42
	ld hl, _DATA_6D880_
	ld bc, $021E
	call _LABEL_2EB5_vramLoad?
	ld hl, _DATA_6D900_
	ld de, $3C62
	ld bc, $021E
	call _LABEL_2EB5_vramLoad?
	ld hl, $0000
	ld (_RAM_C74D_), hl
+:
	ld hl, _DATA_397F_paletteOptions
	ei
	call _LABEL_5F5_timer+pal?
	ld b, $FF
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	xor a
	ld (_RAM_C74F_plyr1Lives), a
	ld (_RAM_C74F_plyr1Lives), a
	ld a, $01
	call _LABEL_20F7_fadeoutandStop?
	ld b, $64
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	ld a, (_RAM_C35B_twoplayergametype)
	or a
	jp z, _LABEL_211C_GameOverThenHiScoreEntry
	jp _LABEL_210F_SWBank2GameOverandTitleScreen

; Data from 6DE87 to 6F266 (5088 bytes)
_DATA_6DE87_MarkoPuzzleTileAndMap:
.incbin "pf_e_DATA_6DE87_.inc"

; Data from 6F267 to 6F2C8 (98 bytes)
_DATA_6F267_MarkoThing:
.db $20 $01 $21 $01 $22 $01 $22 $01 $22 $01 $22 $01 $22 $01 $22 $01
.db $22 $01 $22 $01 $22 $01 $22 $01 $22 $01 $22 $01 $21 $03 $20 $01
.db $21 $01 $22 $01 $22 $01 $22 $01 $22 $01 $22 $01 $22 $01 $22 $01
.db $22 $01 $22 $01 $22 $01 $22 $01 $22 $01 $21 $03 $20 $01 $20 $01
.db $20 $01 $23 $01 $24 $01 $25 $01 $25 $01 $26 $01 $25 $01 $25 $01
.db $26 $01 $25 $01 $25 $01 $26 $01 $25 $01 $25 $01 $23 $03 $20 $01
.db $23 $01

; 2nd entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F2C9 to 6F2CE (6 bytes)
_DATA_6F2C9_:
.db $27 $01 $28 $01 $29 $01

; 3rd entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F2CF to 6F2D4 (6 bytes)
_DATA_6F2CF_:
.db $2A $01 $2B $01 $2C $01

; 4th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F2D5 to 6F2DA (6 bytes)
_DATA_6F2D5_:
.db $2D $01 $2E $01 $2F $01

; 1st entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F2DB to 6F388 (174 bytes)
_DATA_6F2DB_:
.db $30 $01 $31 $01 $32 $01 $23 $03 $20 $01 $20 $01 $20 $01 $23 $01
.db $33 $01 $34 $01 $34 $01 $35 $01 $34 $01 $34 $01 $35 $01 $34 $01
.db $34 $01 $35 $01 $34 $01 $34 $01 $23 $03 $20 $01 $23 $01 $36 $01
.db $37 $01 $38 $01 $39 $01 $3A $01 $3B $01 $3C $01 $3D $01 $3E $01
.db $3F $01 $40 $01 $41 $01 $23 $03 $20 $01 $20 $01 $20 $01 $23 $01
.db $33 $01 $34 $01 $34 $01 $42 $01 $34 $01 $34 $01 $42 $01 $34 $01
.db $34 $01 $42 $01 $34 $01 $34 $01 $23 $03 $20 $01 $23 $01 $43 $01
.db $44 $01 $45 $01 $46 $01 $47 $01 $48 $01 $49 $01 $4A $01 $4B $01
.db $4C $01 $4D $01 $4E $01 $23 $03 $20 $01 $20 $01 $20 $01 $23 $01
.db $4F $01 $50 $01 $51 $01 $52 $01 $50 $01 $51 $01 $52 $01 $50 $01
.db $51 $01 $52 $01 $50 $01 $51 $01 $23 $03 $20 $01 $23 $01

; 5th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F389 to 6F38E (6 bytes)
_DATA_6F389_:
.db $53 $01 $54 $01 $55 $01

; 6th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F38F to 6F394 (6 bytes)
_DATA_6F38F_:
.db $56 $01 $57 $01 $58 $01

; 7th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F395 to 6F39A (6 bytes)
_DATA_6F395_:
.db $59 $01 $5A $01 $5B $01

; 8th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F39B to 6F448 (174 bytes)
_DATA_6F39B_:
.db $5C $01 $5D $01 $5E $01 $23 $03 $20 $01 $20 $01 $20 $01 $23 $01
.db $33 $01 $34 $01 $34 $01 $35 $01 $34 $01 $34 $01 $35 $01 $34 $01
.db $34 $01 $35 $01 $34 $01 $34 $01 $23 $03 $20 $01 $23 $01 $5F $01
.db $60 $01 $61 $01 $62 $01 $63 $01 $64 $01 $65 $01 $66 $01 $67 $01
.db $68 $01 $69 $01 $6A $01 $23 $03 $20 $01 $20 $01 $20 $01 $23 $01
.db $33 $01 $34 $01 $34 $01 $42 $01 $34 $01 $34 $01 $42 $01 $34 $01
.db $34 $01 $42 $01 $34 $01 $34 $01 $23 $03 $20 $01 $23 $01 $6B $01
.db $6C $01 $6D $01 $6E $01 $6F $01 $70 $01 $71 $01 $72 $01 $73 $01
.db $74 $01 $75 $01 $76 $01 $23 $03 $20 $01 $20 $01 $20 $01 $23 $01
.db $4F $01 $50 $01 $51 $01 $52 $01 $50 $01 $51 $01 $52 $01 $50 $01
.db $51 $01 $52 $01 $50 $01 $51 $01 $23 $03 $20 $01 $23 $01

; 9th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F449 to 6F44E (6 bytes)
_DATA_6F449_:
.db $77 $01 $78 $01 $79 $01

; 10th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F44F to 6F454 (6 bytes)
_DATA_6F44F_:
.db $7A $01 $7B $01 $7C $01

; 11th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F455 to 6F45A (6 bytes)
_DATA_6F455_:
.db $7D $01 $7E $01 $7F $01

; 12th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F45B to 6F508 (174 bytes)
_DATA_6F45B_:
.db $80 $01 $81 $01 $82 $01 $23 $03 $20 $01 $20 $01 $20 $01 $23 $01
.db $33 $01 $34 $01 $34 $01 $35 $01 $34 $01 $34 $01 $35 $01 $34 $01
.db $34 $01 $35 $01 $34 $01 $34 $01 $23 $03 $20 $01 $23 $01 $83 $01
.db $84 $01 $85 $01 $86 $01 $87 $01 $88 $01 $89 $01 $8A $01 $8B $01
.db $8C $01 $8D $01 $8E $01 $23 $03 $20 $01 $20 $01 $20 $01 $23 $01
.db $33 $01 $34 $01 $34 $01 $42 $01 $34 $01 $34 $01 $42 $01 $34 $01
.db $34 $01 $42 $01 $34 $01 $34 $01 $23 $03 $20 $01 $23 $01 $8F $01
.db $90 $01 $91 $01 $92 $01 $93 $01 $94 $01 $95 $01 $96 $01 $97 $01
.db $98 $01 $99 $01 $9A $01 $23 $03 $20 $01 $20 $01 $20 $01 $23 $01
.db $4F $01 $50 $01 $51 $01 $52 $01 $50 $01 $51 $01 $52 $01 $50 $01
.db $51 $01 $52 $01 $50 $01 $51 $01 $23 $03 $20 $01 $23 $01

; 13th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F509 to 6F50E (6 bytes)
_DATA_6F509_:
.db $9B $01 $9C $01 $9D $01

; 14th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F50F to 6F514 (6 bytes)
_DATA_6F50F_:
.db $9E $01 $9F $01 $A0 $01

; 15th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F515 to 6F51A (6 bytes)
_DATA_6F515_:
.db $A1 $01 $A2 $01 $A3 $01

; 16th entry of Pointer Table from 6FEC8 (indexed by _RAM_C90C_pointer)
; Data from 6F51B to 6F5E6 (204 bytes)
_DATA_6F51B_:
.db $A4 $01 $A5 $01 $A6 $01 $23 $03 $20 $01 $20 $01 $20 $01 $23 $01
.db $33 $01 $34 $01 $34 $01 $35 $01 $34 $01 $34 $01 $35 $01 $34 $01
.db $34 $01 $35 $01 $34 $01 $34 $01 $23 $03 $20 $01 $23 $01 $A7 $01
.db $A8 $01 $A9 $01 $AA $01 $AB $01 $AC $01 $AD $01 $AE $01 $AF $01
.db $B0 $01 $B1 $01 $B2 $01 $23 $03 $20 $01 $20 $01 $20 $01 $23 $01
.db $33 $01 $34 $01 $34 $01 $42 $01 $34 $01 $34 $01 $42 $01 $34 $01
.db $34 $01 $42 $01 $34 $01 $34 $01 $23 $03 $20 $01 $23 $01 $B3 $01
.db $B4 $01 $B5 $01 $B6 $01 $B7 $01 $B8 $01 $B9 $01 $BA $01 $BB $01
.db $BC $01 $BD $01 $BE $01 $23 $03 $20 $01 $20 $01 $20 $01 $21 $05
.db $22 $07 $22 $07 $22 $07 $22 $07 $22 $07 $22 $07 $22 $07 $22 $07
.db $22 $07 $22 $07 $22 $07 $22 $07 $21 $07 $20 $01 $21 $05 $22 $07
.db $22 $07 $22 $07 $22 $07 $22 $07 $22 $07 $22 $07 $22 $07 $22 $07
.db $22 $07 $22 $07 $22 $07 $21 $07 $20 $01 $20 $01

; Data from 6F5E7 to 6F606 (32 bytes)
_DATA_6F5E7_MarkoPal:
.db $00 $0F $0B $06 $2F $3D $39 $35 $2A $30 $02 $17 $2B $0D $20 $3F
.db $00 $0F $0B $06 $2F $3D $39 $35 $2A $30 $02 $17 $2B $0D $20 $3F

; Data from 6F607 to 6F726 (288 bytes)
_DATA_6F607_:
.db $FF $FF $00 $FF $80 $FF $00 $FF $80 $C0 $00 $C0 $80 $C0 $00 $C0
.db $80 $C0 $00 $C0 $80 $C0 $00 $C0 $80 $C0 $00 $C0 $80 $C0 $00 $C0
.db $FF $FF $00 $FF $00 $FF $00 $FF
.dsb 24, $00
.db $FF $FF $00 $FF $01 $FF $00 $FF $01 $03 $00 $03 $01 $03 $00 $03
.db $01 $03 $00 $03 $01 $03 $00 $03 $01 $03 $00 $03 $01 $03 $00 $03
.db $80 $C0 $00 $C0 $80 $C0 $00 $C0 $80 $C0 $00 $C0 $80 $C0 $00 $C0
.db $80 $C0 $00 $C0 $80 $C0 $00 $C0 $80 $C0 $00 $C0 $80 $C0 $00 $C0
.dsb 32, $00
.db $01 $03 $00 $03 $01 $03 $00 $03 $01 $03 $00 $03 $01 $03 $00 $03
.db $01 $03 $00 $03 $01 $03 $00 $03 $01 $03 $00 $03 $01 $03 $00 $03
.db $80 $C0 $00 $C0 $80 $C0 $00 $C0 $80 $C0 $00 $C0 $80 $C0 $00 $C0
.db $80 $C0 $00 $C0 $80 $C0 $00 $C0 $80 $FF $00 $FF $FF $FF $00 $FF
.dsb 25, $00
.db $FF $00 $FF $FF $FF $00 $FF $01 $03 $00 $03 $01 $03 $00 $03 $01
.db $03 $00 $03 $01 $03 $00 $03 $01 $03 $00 $03 $01 $03 $00 $03 $01
.db $FF $00 $FF $FF $FF $00 $FF

; Data from 6F727 to 6F906 (480 bytes)
_DATA_6F727_:
.db $00 $00 $00 $00 $63 $63 $63 $77 $63 $63 $63 $77 $60 $60 $60 $73
.db $60 $60 $60 $70 $60 $60 $60 $70 $60 $60 $60 $70 $60 $60 $60 $70
.db $00 $00 $00 $00 $FF $FF $FF $FF $FF $FF $FF $FF $00 $00 $00 $FF
.dsb 20, $00
.db $C0 $C0 $C0 $E0 $C0 $C0 $C0 $E0 $00 $00 $00 $C0
.dsb 20, $00
.db $43 $A3 $A3 $E7 $43 $A3 $A3 $E7 $40 $A0 $A0 $E3 $40 $A0 $A0 $E0
.db $40 $A0 $A0 $E0 $40 $A0 $A0 $E0 $40 $A0 $A0 $E0 $00 $00 $00 $00
.db $63 $63 $63 $77 $03 $03 $03 $67 $00 $00 $00 $03
.dsb 16, $00
.db $40 $A0 $A0 $E0 $43 $A3 $A3 $E7 $43 $A3 $A3 $E7 $40 $A0 $A0 $E3
.db $40 $A0 $A0 $E0 $40 $A0 $A0 $E0 $40 $A0 $A0 $E0 $40 $A0 $A0 $E0
.db $00 $00 $00 $00 $7F $7F $7F $7F $7F $7F $7F $7F $00 $00 $00 $7F
.db $00 $00 $00 $00 $00 $00 $00 $60 $60 $60 $60 $70 $60 $60 $60 $70
.db $00 $7F $7F $7F $7F $00 $00 $7F $00 $7F $7F $7F
.dsb 11, $00
.db $60 $60 $60 $60 $70 $60 $60 $60 $70 $00 $FF $FF $FF $FF $00 $00
.db $FF $00 $FF $FF $FF
.dsb 24, $00
.db $40 $40 $40 $60 $40 $40 $40 $60 $00 $00 $00 $40 $00 $00 $00 $00
.db $00 $00 $00 $60 $60 $60 $60 $70 $60 $60 $60 $70
.dsb 32, $00
.db $60 $60 $60 $70 $60 $60 $60 $70 $00 $00 $00 $60
.dsb 21, $00
.db $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $FF $00
.db $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $FF $00 $FF $FF $FF $40
.db $A0 $A0 $E0 $40 $A0 $A0 $E0 $40 $A0 $A0 $E0 $40 $A0 $A0 $E0 $40
.db $A0 $A0 $E0 $40 $A0 $A0 $E0 $40 $A0 $A0 $E0 $40 $A0 $A0 $E0 $60
.db $60 $60 $70 $60 $60 $60 $70 $60 $60 $60 $70 $60 $60 $60 $70 $60
.db $60 $60 $70 $60 $60 $60 $70 $60 $60 $60 $70 $60 $60 $60 $70

; Data from 6F907 to 6F90C (6 bytes)
_DATA_6F907_:
.db $11 $01 $12 $01 $13 $01

; Data from 6F90D to 6F912 (6 bytes)
_DATA_6F90D_:
.db $14 $01 $12 $01 $13 $01

; Data from 6F913 to 6F918 (6 bytes)
_DATA_6F913_:
.db $15 $01 $12 $01 $13 $01

; Data from 6F919 to 6F91E (6 bytes)
_DATA_6F919_:
.db $16 $01 $12 $01 $13 $01

; Data from 6F91F to 6F922 (4 bytes)
_DATA_6F91F_:
.db $17 $01 $13 $01

; Data from 6F923 to 6F926 (4 bytes)
_DATA_6F923_:
.db $18 $01 $19 $01

; Data from 6F927 to 6F9C6 (160 bytes)
_DATA_6F927_:
.db $1A $01 $18 $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01
.db $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01
.db $1C $01 $1D $01 $1D $01 $1E $01 $1D $01 $1D $01 $1B $01 $1B $01
.db $1B $01 $1B $01 $1B $01 $1B $01 $1F $01 $1D $01 $1F $01 $1D $01
.db $1F $01 $1F $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01
.db $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01
.db $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01
.db $1B $01 $1B $01 $1B $01 $1B $01 $1C $01 $1D $01 $1C $01 $1D $01
.db $1C $01 $1C $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01
.db $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01 $1B $01

_LABEL_6F9C7_markoPuzzlePrepare:
	di
	ld a, $1B
	ld (_RAM_C64E_BANKSWITCH_PAGE), a ;Set the bankswitch page to 27.
	call _LABEL_6CD_tilemap_clear
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES	;Clear the screen from everything.
	call _LABEL_209F_HiddenPuzzleGraphicsLoading
	ld de, $3902
	ld hl, _DATA_6F267_MarkoThing ;This is also some map data, possibly the complete picture first.
	ld bc, $0380
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_6DE87_MarkoPuzzleTileAndMap
	ld de, $2400
	ld bc, $13E0
	call _LABEL_7EF_VDPdataLoad
	ld de, $0020
	ld hl, _DATA_6F607_
	ld bc, $0120
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_6F727_
	ld de, $2220
	ld bc, $01E0
	call _LABEL_7EF_VDPdataLoad
	ld hl, _LABEL_DFD_titleScreenMainLoop?
	ld (_RAM_C391_pointer?), hl
	call _LABEL_2103_PSGSilence+Bankswitch
	ld a, $FF
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $8A
	out (Port_VDPAddressControlPort), a ;Disable line interrupts.
	nop
	nop
	ld hl, $0000
	ld (_RAM_C33B_plyfieldborder), hl
	ld (_RAM_C33D_playFieldBaseHeight), hl ;Put the screen back to it's place.
	ei
	ld hl, _DATA_6F5E7_MarkoPal
	call _LABEL_5F5_timer+pal? ;Load the palette, and enable interrupts.
	;TODO
_LABEL_6FA2F_markoPuzzleMainLoop: ;Since there is no RET anywhere before this, the program is most likely continues here.
	call _LABEL_6FEA1_ ;This is some stack thing, i'm not seeing well yet what is it for, but this is used quite a lot.
	ld hl, $01F4
	call _LABEL_6FA5D_markoPuzzle
	ld bc, $0000
	ld (_RAM_C901_puzzleColumnNr), bc
	ld (_RAM_C905_markoPuzzleCursor), bc
	xor a
	ld (_RAM_C907_markoPuzzleUnused?), a
	ld (_RAM_C903_animationCounter?), a
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	call _LABEL_3C76_markoPlaySoundEffect ;It is connected to a bankswitch routine, and a sound playing code.
	call _LABEL_6FD73_controllerAndPuzzleHandler
	jp --

_LABEL_6FA5D_markoPuzzle: ;This is also some puzzle logic thing. I don't really can dissect it effectively.
	push hl
-:
	call _LABEL_983_
	and $03
	ld c, a
	call _LABEL_983_
	and $03
	ld b, a
	ld (_RAM_C901_puzzleColumnNr), bc
	ld a, b
	add a, a
	add a, a
	add a, a
	add a, $09
	ld l, a
	ld a, c
	add a, l
	ld l, a
	ld h, $00
	ld de, $C8D1
	add hl, de
	ld de, (_RAM_C90A_markoPuzzle)
	ld a, h
	cp d
	jr nz, +
	ld a, l
	cp e
	jr z, -
+:
	call _LABEL_6FA94_markoPuzzle
	pop hl
	dec hl
	ld a, h
	or l
	jr nz, _LABEL_6FA5D_markoPuzzle
	ret

_LABEL_6FA94_markoPuzzle: ;This is definetly the heavy logic part of the puzzle code, it deals with a lot of those 
;variables. Those who seek to know the more intricate workings shall look into these codes. The puzzle game is quite
;nice, so it might worth the effort.
;RAM values associated with the puzzle will be marked accordingly.
	ld a, (_RAM_C902_puzzleRowNr)
	add a, a
	add a, a
	add a, a
	add a, $09
	ld l, a
	ld a, (_RAM_C901_puzzleColumnNr)
	add a, l
	ld l, a
	ld h, $00
	ld de, _RAM_C8D1_markoPuzzle
	add hl, de
	ld (_RAM_C908_markoPuzzle), hl
	ld a, (hl)
	or a
	ret z
	ld de, $FFF8
	add hl, de
	ld c, $08
	ld a, (hl)
	or a
	jr z, +
	ld de, $0010
	add hl, de
	ld c, $04
	ld a, (hl)
	or a
	jr z, +
	ld de, $FFF7
	add hl, de
	ld c, $02
	ld a, (hl)
	or a
	jr z, +
	ld de, $0002
	add hl, de
	ld c, $01
	ld a, (hl)
	or a
	ret nz
+:
	ld de, (_RAM_C908_markoPuzzle)
	ld a, (de)
	ld (_RAM_C90C_pointer), a
	ld (_RAM_C90A_markoPuzzle), hl
	xor a
	ld (de), a
	ld a, c
	push af
	ld bc, (_RAM_C901_puzzleColumnNr)
	ld a, b
	add a, a
	add a, b
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, c
	add a, a
	add a, c
	add a, a
	add a, l
	ld l, a
	ld de, $3946
	add hl, de
	push hl
	ld a, (_RAM_C90C_pointer)
	add a, a
	ld l, a
	ld h, $00
	ld de, _DATA_6FEC8_pointerTable
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (_RAM_C90E_markoPuzzle), de
	pop de
	ld (_RAM_C910_markoPuzzle), de
	pop af
	srl a
	jp c, ++++
	srl a
	jp c, +++
	srl a
	jp c, ++
	srl a
	jp c, +
+: ;These might be directions, since there is only two of them at any time.
	ld a, (_RAM_C901_puzzleColumnNr)
	or a
	jp nz, _LABEL_6FCA2_
	jp _LABEL_6FBBE_

++:
	ld a, (_RAM_C901_puzzleColumnNr)
	or a
	jp nz, _LABEL_6FCDD_
	jp _LABEL_6FBF9_

+++:
	ld a, (_RAM_C902_puzzleRowNr)
	or a
	jp nz, _LABEL_6FC6B_
	jp _LABEL_6FB87_

++++:
	ld a, (_RAM_C902_puzzleRowNr)
	or a
	jp nz, _LABEL_6FC34_
	ld hl, (_RAM_C910_markoPuzzle)
	inc hl
	inc hl
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD39_markoPuzzle
	ld hl, _DATA_6F923_
	ld bc, $0304
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	ld hl, (_RAM_C910_markoPuzzle)
	inc hl
	inc hl
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD39_markoPuzzle
	ld hl, _DATA_6F927_ + 2
	ld bc, $0302
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	jp _LABEL_6FD15_

_LABEL_6FB87_:
	ld hl, (_RAM_C910_markoPuzzle)
	dec hl
	dec hl
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD39_markoPuzzle
	ld hl, _DATA_6F927_ + 2
	ld bc, $0302
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	ld hl, (_RAM_C910_markoPuzzle)
	dec hl
	dec hl
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD39_markoPuzzle
	ld hl, _DATA_6F923_
	ld bc, $0304
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	jp _LABEL_6FD15_

_LABEL_6FBBE_:
	ld hl, (_RAM_C910_markoPuzzle)
	ld de, $FFC0
	add hl, de
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD56_
	ld hl, _DATA_6F919_
	ld bc, $0106
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	ld hl, (_RAM_C910_markoPuzzle)
	ld de, $FFC0
	add hl, de
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD56_
	ld hl, _DATA_6F90D_
	ld bc, $0206
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	jp _LABEL_6FD15_

_LABEL_6FBF9_:
	ld hl, (_RAM_C910_markoPuzzle)
	ld de, $0040
	add hl, de
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD56_
	ld hl, _DATA_6F90D_
	ld bc, $0206
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	ld hl, (_RAM_C910_markoPuzzle)
	ld de, $0040
	add hl, de
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD56_
	ld hl, _DATA_6F919_
	ld bc, $0106
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	jp _LABEL_6FD15_

_LABEL_6FC34_:
	ld hl, (_RAM_C910_markoPuzzle)
	inc hl
	inc hl
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD39_markoPuzzle
	ld hl, _DATA_6F91F_
	ld bc, $0304
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	ld hl, (_RAM_C910_markoPuzzle)
	inc hl
	inc hl
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD39_markoPuzzle
	ld hl, _DATA_6F927_
	ld bc, $0302
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	jp _LABEL_6FD15_

_LABEL_6FC6B_:
	ld hl, (_RAM_C910_markoPuzzle)
	dec hl
	dec hl
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD39_markoPuzzle
	ld hl, _DATA_6F927_
	ld bc, $0302
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	ld hl, (_RAM_C910_markoPuzzle)
	dec hl
	dec hl
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD39_markoPuzzle
	ld hl, _DATA_6F91F_
	ld bc, $0304
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	jp _LABEL_6FD15_

_LABEL_6FCA2_:
	ld hl, (_RAM_C910_markoPuzzle)
	ld de, $FFC0
	add hl, de
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD56_
	ld hl, _DATA_6F913_
	ld bc, $0106
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	ld hl, (_RAM_C910_markoPuzzle)
	ld de, $FFC0
	add hl, de
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD56_
	ld hl, _DATA_6F907_
	ld bc, $0206
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	jp _LABEL_6FD15_

_LABEL_6FCDD_:
	ld hl, (_RAM_C910_markoPuzzle)
	ld de, $0040
	add hl, de
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD56_
	ld hl, _DATA_6F907_
	ld bc, $0206
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
	ld hl, (_RAM_C910_markoPuzzle)
	ld de, $0040
	add hl, de
	ld (_RAM_C910_markoPuzzle), hl
	call _LABEL_6FEA1_
	call _LABEL_6FD56_
	ld hl, _DATA_6F913_
	ld bc, $0106
	call _LABEL_2EB5_vramLoad?
	call _LABEL_6FD25_markoPlaySound
_LABEL_6FD15_:
	ld hl, (_RAM_C90A_markoPuzzle)
	ld a, (_RAM_C90C_pointer)
	ld (hl), a
	call _LABEL_6FEA1_
	ld a, $0C
	call _LABEL_3C80_
	ret

_LABEL_6FD25_markoPlaySound: ;This is connected to a timer, but gives to the same sound effect play routine.
	ld b, $03
--:
	push bc
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	call _LABEL_3C76_markoPlaySoundEffect
	pop bc
	djnz --
	ret

_LABEL_6FD39_markoPuzzle:
	push hl
	push bc
	push af
	ld hl, (_RAM_C90E_markoPuzzle)
	ld de, (_RAM_C910_markoPuzzle)
	ld bc, $0306
	call _LABEL_2EB5_vramLoad?
	ld de, (_RAM_C910_markoPuzzle)
	ld hl, $0006
	add hl, de
	ex de, hl
	pop af
	pop bc
	pop hl
	ret

_LABEL_6FD56_:
	push hl
	push bc
	push af
	ld hl, (_RAM_C90E_markoPuzzle)
	ld de, (_RAM_C910_markoPuzzle)
	ld bc, $0306
	call _LABEL_2EB5_vramLoad?
	ld de, (_RAM_C910_markoPuzzle)
	ld hl, $00C0
	add hl, de
	ex de, hl
	pop af
	pop bc
	pop hl
	ret

_LABEL_6FD73_controllerAndPuzzleHandler:
	ld a, (_RAM_C903_animationCounter?)
	or a
	jr nz, _LABEL_6FDEE_ ;I guess we check if we are moving or not. (moving a puzzle part)
	ld a, (_RAM_C393_JOYPAD1)
	or a
	jr nz, + ;Check for a joypad value.
	ld (_RAM_C3A5_JOYPAD1_2), a ;Load the joypad value to a second ram value. (to get the previous value?)
	jp _LABEL_6FDE8_puzzlePiecehandle ;This calculates some row and column values for the puzzle.

+:
	ld c, a
	ld a, (_RAM_C3A5_JOYPAD1_2)
	or a
	jp nz, _LABEL_6FDE8_puzzlePiecehandle
	ld a, $01
	ld (_RAM_C3A5_JOYPAD1_2), a
	ld a, c
	and $10
	jr z, +
	call _LABEL_6FA94_markoPuzzle
	jp _LABEL_6FDE8_puzzlePiecehandle

+:
	ld a, c
	and $20
	jr z, +
	ld sp, $DFF8
	jp _LABEL_6FA2F_markoPuzzleMainLoop

+:
	ld a, c
	ld (_RAM_C904_controllerStatePuzzle), a
	srl a
	jr nc, +
	ld a, (_RAM_C901_puzzleColumnNr)
	cp $03
	jp z, _LABEL_6FDE8_puzzlePiecehandle
	jp ++

+:
	srl a
	jr nc, +
	ld a, (_RAM_C901_puzzleColumnNr)
	or a
	jp z, _LABEL_6FDE8_puzzlePiecehandle
	jp ++

+:
	srl a
	jr nc, +
	ld a, (_RAM_C902_puzzleRowNr)
	cp $03
	jp z, _LABEL_6FDE8_puzzlePiecehandle
	jp ++

+:
	srl a
	jr nc, ++
	ld a, (_RAM_C902_puzzleRowNr)
	or a
	jp z, _LABEL_6FDE8_puzzlePiecehandle
++:
	ld a, $18
	ld (_RAM_C903_animationCounter?), a
_LABEL_6FDE8_puzzlePiecehandle:
	ld de, $0000
	jp _LABEL_6FE5B_markoPuzzlePieceSpriteHandler

_LABEL_6FDEE_:
	sub $02
	ld (_RAM_C903_animationCounter?), a
	ld de, (_RAM_C905_markoPuzzleCursor)
	ld a, (_RAM_C904_controllerStatePuzzle)
	srl a
	jr nc, +
	inc e
	inc e
	jp ++

+:
	srl a
	jr nc, +
	dec e
	dec e
	jp ++

+:
	srl a
	jr nc, +
	inc d
	inc d
	jp ++

+:
	srl a
	jr nc, ++
	dec d
	dec d
++:
	ld (_RAM_C905_markoPuzzleCursor), de
	call _LABEL_6FE5B_markoPuzzlePieceSpriteHandler
	ld a, (_RAM_C903_animationCounter?)
	or a
	ret nz
	ld bc, (_RAM_C901_puzzleColumnNr)
	ld a, (_RAM_C904_controllerStatePuzzle)
	srl a
	jr nc, +
	inc c
	jp ++

+:
	srl a
	jr nc, +
	dec c
	jp ++

+:
	srl a
	jr nc, +
	inc b
	jp ++

+:
	srl a
	jr nc, ++
	dec b
++:
	ld (_RAM_C901_puzzleColumnNr), bc
	ld de, $0000
	ld (_RAM_C905_markoPuzzleCursor), de
	xor a
	ld (_RAM_C3A5_JOYPAD1_2), a
	ret

_LABEL_6FE5B_markoPuzzlePieceSpriteHandler:
	ld a, (_RAM_C901_puzzleColumnNr)
	ld c, a
	add a, a
	add a, c
	add a, a
	add a, a
	add a, a
	add a, $18
	ld c, a
	ld a, (_RAM_C902_puzzleRowNr)
	ld b, a
	add a, a
	add a, b
	add a, a
	add a, a
	add a, a
	add a, $2F
	ld b, a
	ld a, e
	add a, c
	ld c, a
	ld a, d
	add a, b
	ld b, a
	ld hl, $BE80
	call _LABEL_1420_SpriteHandleroutsideMatches
	ret
_empty_6FE80_: ;Not referenced anywhere in code.
; Data from 6FE80 to 6FEA0 (33 bytes)
.db $00 $01 $00 $00 $00 $02 $08 $00 $00 $03 $10 $00 $00 $04 $00 $08
.db $00 $06 $10 $08 $00 $07 $00 $10 $00 $08 $08 $10 $00 $09 $10 $10
.db $40

_LABEL_6FEA1_:
	di
	xor a
	ld hl, _RAM_C8DA_markoPuzzle
--:
	push af
	push hl
	ld b, a
	xor a
-:
	push af
	ld c, a
	ld a, (hl)
	inc hl
	push hl
	push bc
	call +
	pop bc
	pop hl
	pop af
	inc a
	cp $04
	jr nz, -
	pop hl
	ld de, $0008
	add hl, de
	pop af
	inc a
	cp $04
	jr nz, --
	ei
	ret

; Pointer Table from 6FEC8 to 6FEE7 (16 entries, indexed by _RAM_C90C_pointer)
_DATA_6FEC8_pointerTable: ;This is almost exclusively used by the little puzzle game, and nothing else.
;I don't know what it is used for, yet.
.dw _DATA_6F2DB_ _DATA_6F2C9_ _DATA_6F2CF_ _DATA_6F2D5_ _DATA_6F389_ _DATA_6F38F_ _DATA_6F395_ _DATA_6F39B_
.dw _DATA_6F449_ _DATA_6F44F_ _DATA_6F455_ _DATA_6F45B_ _DATA_6F509_ _DATA_6F50F_ _DATA_6F515_ _DATA_6F51B_

+:
	ex af, af'
	ld a, b
	add a, a
	add a, b
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, c
	add a, a
	add a, c
	add a, a
	add a, l
	ld l, a
	ld de, $3946
	add hl, de
	ex de, hl
	ex af, af'
	or a
	jr nz, +
	push de
	ex de, hl
	ld de, $3902
	or a
	sbc hl, de
	ld de, $B267
	add hl, de
	pop de
	jp ++

+:
	add a, a
	ld c, a
	ld b, $00
	ld hl, _DATA_6FEC8_pointerTable
	add hl, bc
	ld c, a
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
++:
	ld bc, $0306
	call _LABEL_2EB5_vramLoad?
	ret

; Data from 6FF28 to 6FFFF (216 bytes)
_empty216_:;This was padded with zeroes, i guess there was nothing to be put here.
.dsb 216, $00

.BANK 28 ;This is a bank for the forklift data, graphics, and some code along with it.
.ORG $0000

; Data from 70000 to 7007F (128 bytes)
_DATA_70000_forkliftSpriteAttrData:	;Forklift and character Sprite Attribute data.
.db $1F $01 $20 $01 $21 $01 $20 $01 $22 $01 $23 $01 $24 $01 $25 $01
.db $26 $01 $27 $01 $28 $01 $29 $01 $28 $01 $2A $01 $2B $01 $2C $01
.db $2D $01 $2C $01 $1F $01 $29 $01 $28 $01 $2A $01 $2B $01 $2E $01
.db $20 $01 $22 $01 $23 $01 $24 $01 $2F $01 $30 $01 $1F $01 $1F $01
.db $1F $01 $31 $01 $32 $01 $31 $01 $33 $01 $34 $01 $35 $01 $36 $01
.db $37 $01 $38 $01 $39 $01 $38 $01 $3A $01 $3B $01 $3C $01 $31 $01
.db $33 $01 $3D $01 $3E $01 $38 $01 $3A $01 $3B $01 $3C $01 $3F $01
.db $31 $01 $33 $01 $34 $01 $35 $01 $40 $01 $41 $01 $1F $01 $1F $01

; Data from 70080 to 705BF (1344 bytes)
_DATA_70080_mapdata?: ;Is this some map data?
.incbin "pf_e_DATA_70080_.inc"

; Data from 705C0 to 719DF (5152 bytes)
_DATA_705C0_forklistScreenTiles:
.incbin "pf_e_DATA_705C0_.inc"

; Data from 719E0 to 7373F (7520 bytes)
_DATA_719E0_buzzForkliftTiles: ;Seems like the graphics for Buzz on the forklift.
.incbin "pf_e_DATA_719E0_.inc"

; Data from 73740 to 7375F (32 bytes)
_DATA_73740_paletteforForkliftScreen:
.db $00 $15 $10 $20 $30 $02 $35 $31 $0A $0B $1B $06 $05 $00 $2A $3F
.db $00 $15 $10 $20 $30 $02 $35 $31 $0A $0B $1B $06 $05 $00 $2A $3F

; Data from 73760 to 7379D (62 bytes)
_DATA_73760_: ;Used in the Forklift scene, but it might be some sprite data or something.
.db $E8 $03 $E8 $03 $DC $05 $DC $05 $DC $05 $DC $05 $DC $05 $D0 $07
.db $D0 $07 $C4 $09 $C4 $09 $C4 $09 $C4 $09 $B8 $0B $B8 $0B $AC $0D
.db $AC $0D $AC $0D $AC $0D $AC $0D $A0 $0F $A0 $0F $94 $11 $94 $11
.db $94 $11 $94 $11 $88 $13 $88 $13 $88 $13 $88 $13 $88 $13

; Data from 7379E to 737B3 (22 bytes)
_DATA_7379E_: ;Used around the player knockdown counts.
.db $32 $00 $FA $00 $F4 $01 $EE $02 $E8 $03 $E2 $04 $DC $05 $D6 $06
.db $D0 $07 $CA $08 $C4 $09

_LABEL_737B4_forkliftEvaluation: ;We are not in a GM, so the round will end in the Forklift scene counting up the dough.
	di
	ld a, (_RAM_C750_plyr1KnockDowns)
	cp $0A
	jr c, +	;Jump, if knockdowns are less than 10.
	ld a, $09 ;If we have more, limit it to 9. Why?
+:
	ld (_RAM_C750_plyr1KnockDowns), a
	ld a, (_RAM_C784_plyr2KnockDown)
	cp $0A
	jr c, +
	ld a, $09 ;Do the same for player 2.
+:
	ld (_RAM_C784_plyr2KnockDown), a
	ld a, $1C
	ld (_RAM_C64E_BANKSWITCH_PAGE), a ;Set this to bank 28.
	xor a
	ld (_RAM_C354_isroundon), a
	ld (_RAM_C398_isroundon), a
	ld (_RAM_C353_unused), a
	call _LABEL_6CD_tilemap_clear
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES ;Reset the screen, set a full black palette, and get it to a known state.
	ld hl, _DATA_719E0_buzzForkliftTiles
	ld de, $0020
	ld bc, $1D60
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_705C0_forklistScreenTiles
	ld de, $23E0
	ld bc, $1420
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_70000_forkliftSpriteAttrData
	ld de, $3802
	ld bc, $0080
	call _LABEL_7EF_VDPdataLoad ;Load the Forklift parts.
	ld a, (_RAM_C358_player2char)
	cp $03
	jr c, + ;Check if the second character is either one of the three main characters.
	ld hl, _DATA_70080_mapdata? 
	;So, If the second player is NOT one of the main characters, then just show one forklift, otherwise show two.
	;Character that are not in the trio does not have any forklift animations, so you can't show them.
	ld de, $38D2
	ld a, $15
-:
	push af
	push hl
	push de
	ld bc, $001E ;30
	call _LABEL_7EF_VDPdataLoad
	pop hl
	ld bc, $0040 ;64 tiles
	add hl, bc
	ex de, hl
	pop hl
	ld bc, $0040 ;64 tiles
	add hl, bc
	pop af
	dec a
	jr nz, - 
	jp ++

+: ;This is the case when the second player is one of the main chars.
	ld hl, _DATA_70080_mapdata?
	ld de, $38C2
	ld bc, $0540
	call _LABEL_7EF_VDPdataLoad ;Load the two forklift graphics.
++:
	ld hl, _DATA_7512F_ForkLiftMusic
	call SelectMusicBank ;Set the music for the screen.
	ld hl, $0000
	ld (_RAM_C33B_plyfieldborder), hl
	ld (_RAM_C33D_playFieldBaseHeight), hl
	ld (_RAM_C7EF_), hl ;These are used near some score calculations, but I don't know yet for sure what these variables for.
	ld (_RAM_C7F1_), hl
	;Reset some screen related variables, and others, that are not yet mapped.
	ld a, h ;zero out a.
	ld (_RAM_C703_spriteDrawNumber?), a
	ld (_RAM_C7ED_plyr1ForkliftSprite), a
	ld (_RAM_C7EE_counter?), a ;Reset more variables.
	ld a, $80
	ld (_RAM_C7EB_forkliftHeight), a
	ld (_RAM_C7EC_counter?), a
	ld a, $91
	ld (_RAM_C362_hudTileOffset), a ;Set some things that will be used with the forklift itself.
	ld a, $FF
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $8A	;This disables line interrupts, as before.
	out (Port_VDPAddressControlPort), a
	nop
	nop ;These extra nops are really not needed. Did he used some kind of macro here?
	ld hl, $0DB4
	ld (_RAM_C391_pointer?), hl ;This is some kind of ROM pointer.
	ei
	ld hl, _DATA_73740_paletteforForkliftScreen
	call _LABEL_5F5_timer+pal?
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld hl, _DATA_73A0D_
	call _LABEL_73C13_2ndPlayerthing
	ld a, (_RAM_C359_roundScreenNr)
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_73760_
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex de, hl
	ld (_RAM_C7F3_), hl
	ld (_RAM_C7F5_), hl
	xor a
	ld (_RAM_C3A2_timerml), a
-: ;This below might be related the way two player works in the game, as it shows coins on how many rounds have won
;by each player individually.
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	call _LABEL_73BA5_plyr1MoneyUpdate ;This is very possible to be a routine to update the money belonging to player 1.
	call _LABEL_73B2B_timer ;This is mostly used as a timer. From the code itself, I understand it as such.
	;So, it seems like update the money, then wait some time, and so on.
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld hl, _DATA_73A5E_
	call _LABEL_73C13_2ndPlayerthing
	ld a, (_RAM_C750_plyr1KnockDowns)
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_7379E_
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (_RAM_C7F3_), de
	ld a, (_RAM_C784_plyr2KnockDown)
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_7379E_
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (_RAM_C7F5_), de
	call _LABEL_73BA5_plyr1MoneyUpdate
	call _LABEL_73B2B_timer
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld hl, _DATA_73AB8_
	call _LABEL_73C13_2ndPlayerthing
	ld hl, _DATA_73B12_
	call _LABEL_73C13_2ndPlayerthing
	ld a, (_RAM_C358_player2char)
	cp $03
	jr c, +
	xor a
	ld (_RAM_C7EC_counter?), a
+:
	ld b, $32
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld a, (_RAM_C752_forkliftPowerPill?)
	cp $20
	jr c, +
	ld a, $20
+:
	ld (_RAM_C752_forkliftPowerPill?), a
	ld a, (_RAM_C786_forkliftVictoryPose)
	cp $20
	jr c, +
	ld a, $20
+:
	ld (_RAM_C786_forkliftVictoryPose), a
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld a, (_RAM_C752_forkliftPowerPill?)
	or a
	jr nz, +
	ld a, (_RAM_C786_forkliftVictoryPose)
	or a
	jr z, ++
+:
	ld a, (_RAM_C752_forkliftPowerPill?)
	or a
	jr z, +
	dec a
	ld (_RAM_C752_forkliftPowerPill?), a
	ld a, (_RAM_C7EB_forkliftHeight)
	dec a
	ld (_RAM_C7EB_forkliftHeight), a
+:
	ld a, (_RAM_C786_forkliftVictoryPose)
	or a
	jr z, --
	dec a
	ld (_RAM_C786_forkliftVictoryPose), a
	ld a, (_RAM_C7EC_counter?)
	dec a
	ld (_RAM_C7EC_counter?), a
	jp --

++:
	ld a, (_RAM_C358_player2char)
	cp $03
	jr c, +
	ld a, $20
	ld (_RAM_C7ED_plyr1ForkliftSprite), a
	jr +++

+:
	ld a, (_RAM_C7EB_forkliftHeight)
	ld e, a
	ld a, (_RAM_C7EC_counter?)
	cp e
	jr c, +
	jr z, ++
	ld a, $20
	ld (_RAM_C7ED_plyr1ForkliftSprite), a
	jp +++

+:
	ld a, $20
	ld (_RAM_C7EE_counter?), a
	jp +++

++:
	ld a, $20
	ld (_RAM_C7ED_plyr1ForkliftSprite), a
	ld (_RAM_C7EE_counter?), a
+++:
	ld b, $32
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld a, $02
	call _LABEL_20F7_fadeoutandStop?
	ld b, $32
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	ld hl, (_RAM_C7EF_)
	call +
	ld de, (_RAM_C74D_)
	add hl, de
	ld (_RAM_C74D_), hl
	ld hl, (_RAM_C7F1_)
	call +
	ld de, (_RAM_C781_plyr2stats?)
	add hl, de
	ld (_RAM_C781_plyr2stats?), hl
	ld b, $4B
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_2103_PSGSilence+Bankswitch
	di
	ret

+:
	ld bc, $0000
	ld de, $FFF6
-:
	ld a, h
	or l
	jr z, +
	add hl, de
	inc bc
	jp -

+:
	push bc
	pop hl
	ret
;This is basically the rest of the forklift stage evaluation. Even without dissecting the code too much, you can see 
;what does what, the labels are named already, and you can see the victory pose, when it happans, the forklift palette move for both players,
;and many other things. If you play the game, and watch the forklift screen, and look at this side by side, it will
;help you understand the sequence of things. 
; Data from 73A0D to 73A50 (68 bytes)
_DATA_73A0D_:
.db $26 $BA $0B $08 $46 $49 $47 $48 $54 $40 $50 $55 $52 $53 $45 $0D
.db $0D $01 $0E $3B $30 $30 $30 $30 $00 $03 $08 $46 $49 $47 $48 $54
.db $40 $50 $55 $52 $53 $45 $01 $13 $46 $49 $47 $48 $54 $40 $50 $55
.db $52 $53 $45 $0D $0D $01 $06 $3B $30 $30 $30 $30 $01 $16 $3B $30
.db $30 $30 $30 $00

; Data from 73A51 to 73A5D (13 bytes)
_DATA_73A51_:
.db $57 $BA $0E $02 $3B $00 $06 $02 $3B $01 $16 $3B $00

; Data from 73A5E to 73AB7 (90 bytes)
_DATA_73A5E_:
.db $7E $BA $0B $08 $40 $4B $4F $40 $40 $42 $4F $4E $55 $53 $40 $0D
.db $01 $0A $3B $32 $35 $30 $40 $50 $45 $52 $40 $48 $45 $41 $44 $00
.db $03 $08 $40 $4B $4F $40 $40 $42 $4F $4E $55 $53 $40 $01 $13 $40
.db $4B $4F $40 $40 $42 $4F $4E $55 $53 $40 $0D $01 $02 $3B $32 $35
.db $30 $40 $50 $45 $52 $40 $48 $45 $41 $44 $01 $12 $3B $32 $35 $30
.db $40 $50 $45 $52 $40 $48 $45 $41 $44 $00

; Data from 73AB8 to 73B11 (90 bytes)
_DATA_73AB8_:
.db $D8 $BA $0B $08 $40 $42 $52 $55 $54 $41 $4C $49 $54 $59 $40 $0D
.db $01 $0A $40 $40 $40 $40 $42 $4F $4E $55 $53 $40 $40 $40 $40 $00
.db $03 $08 $40 $42 $52 $55 $54 $41 $4C $49 $54 $59 $40 $01 $13 $40
.db $42 $52 $55 $54 $41 $4C $49 $54 $59 $40 $0D $01 $02 $40 $40 $40
.db $40 $42 $4F $4E $55 $53 $40 $40 $40 $40 $01 $12 $40 $40 $40 $40
.db $42 $4F $4E $55 $53 $40 $40 $40 $40 $00

; Data from 73B12 to 73B2A (25 bytes)
_DATA_73B12_:
.db $1C $BB $0E $02 $40 $40 $40 $40 $40 $00 $06 $02 $40 $40 $40 $40
.db $40 $01 $16 $40 $40 $40 $40 $40 $00

_LABEL_73B2B_timer:
	ld b, $32
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
_LABEL_73B39_forkliftAndCounters:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, - ;This is some timer again, used many times in the code before.
	call _LABEL_73BA5_plyr1MoneyUpdate
	call _LABEL_73BDF_ ;This is also some score\money update, but not really understandable to me.
	ld hl, (_RAM_C7F3_)
	ld a, h
	or l
	jr nz, +
	ld hl, (_RAM_C7F5_)
	ld a, h
	or l
	ret z
+:
	ld hl, (_RAM_C7F3_)
	ld a, h
	or l
	jr z, +
	ld de, $FFF6
	add hl, de
	ld (_RAM_C7F3_), hl
	ld hl, (_RAM_C7EF_)
	ld de, $000A
	add hl, de
	ld (_RAM_C7EF_), hl
	ld a, (_RAM_C39E_timer)
	and $1F
	jr nz, +
	ld a, (_RAM_C7EB_forkliftHeight)
	dec a
	ld (_RAM_C7EB_forkliftHeight), a
+:
	ld hl, (_RAM_C7F5_)
	ld a, h
	or l
	jr z, _LABEL_73B39_forkliftAndCounters
	ld de, $FFF6
	add hl, de
	ld (_RAM_C7F5_), hl
	ld hl, (_RAM_C7F1_)
	ld de, $000A
	add hl, de
	ld (_RAM_C7F1_), hl
	ld a, (_RAM_C39E_timer)
	and $1F
	jr nz, _LABEL_73B39_forkliftAndCounters
	ld a, (_RAM_C7EC_counter?)
	dec a
	ld (_RAM_C7EC_counter?), a
	jp _LABEL_73B39_forkliftAndCounters

_LABEL_73BA5_plyr1MoneyUpdate:
	ld hl, _DATA_73A51_
	call _LABEL_73C13_2ndPlayerthing
	ld a, (_RAM_C358_player2char)
	cp $03
	jr nc, + ;Jump if non-player character is used.
	ld hl, (_RAM_C7F3_)
	call _LABEL_91A_plyr1ScoreUpdate?
	ld bc, $0207
	ld hl, _RAM_C101_plyr1money
	call _LABEL_84C_timerAndVDPThingy
	ld hl, (_RAM_C7F5_)
	call _LABEL_91A_plyr1ScoreUpdate?
	ld bc, $0217
	ld hl, _RAM_C101_plyr1money
	jp _LABEL_84C_timerAndVDPThingy

+:
	ld hl, (_RAM_C7F3_)
	call _LABEL_91A_plyr1ScoreUpdate?
	ld bc, $020F
	ld hl, _RAM_C101_plyr1money
	jp _LABEL_84C_timerAndVDPThingy

_LABEL_73BDF_:
	ld a, (_RAM_C358_player2char)
	cp $03
	jr nc, +	;Jump if plyr2 is not in the trio.
	ld hl, (_RAM_C7EF_)
	call _LABEL_91A_plyr1ScoreUpdate?
	ld bc, $0A07
	ld hl, _RAM_C101_plyr1money
	call _LABEL_84C_timerAndVDPThingy
	ld hl, (_RAM_C7F1_)
	call _LABEL_91A_plyr1ScoreUpdate?
	ld bc, $0A17
	ld hl, _RAM_C101_plyr1money
	jp _LABEL_84C_timerAndVDPThingy

+:
	ld hl, (_RAM_C7EF_)
	call _LABEL_91A_plyr1ScoreUpdate?
	ld bc, $0A0F
	ld hl, _RAM_C101_plyr1money
	jp _LABEL_84C_timerAndVDPThingy

_LABEL_73C13_2ndPlayerthing: ;HL reads from that small chunk of data.
	ld a, (_RAM_C358_player2char)
	cp $03
	jr nc, + ;If the second player is not the trio, jump ahead.
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex de, hl
	jp _LABEL_848_timerAndVDPThing

+:
	inc hl
	inc hl
	jp _LABEL_848_timerAndVDPThing

_LABEL_73C26_ForkLiftPart:	;This is executed for the forklift part.
	ld a, (_RAM_C358_player2char)
	cp $03
	jr nc, _LABEL_73C76_forkliftCharSpriteSet ;If Player 2 not any of the valid players, jump there. I guess this could also be used for the two player mode?
	ld c, $32
	ld a, (_RAM_C7EB_forkliftHeight)
	ld b, a									;b is now the forklift height.
	ld a, (_RAM_C357_player1char)
	ld e, $00 ;Buzz.
	cp $01	
	jr z, +
	ld e, $40 ;Ty.
	cp $02	
	jr z, +
	ld e, $80 ;Kato.
+:			;The above checks what character we are, and sets some offsets for the forklift part, so the correct sprites will show up.
	ld a, (_RAM_C7ED_plyr1ForkliftSprite) ;This is an offset or sprite number to draw. 20 is Buzz's victory pose, 40 is Ty's default pose on the forklift.
	add a, e ;Now that we know what character we are, add it to a.
	ld (_RAM_C703_spriteDrawNumber?), a
	ld hl, $BC9B ;This should be the base address for the forklift poses.
	call _LABEL_1420_SpriteHandleroutsideMatches	;Handle sprites.
	ld c, $B2
	ld a, (_RAM_C7EC_counter?)
	ld b, a
	ld a, (_RAM_C358_player2char)
	ld e, $00
	cp $01
	jr z, +
	ld e, $40
	cp $02
	jr z, +
	ld e, $80	;Do the same for player 2.
+:
	ld a, (_RAM_C7EE_counter?)	;Get a counter value?
	add a, e					;Load the sprite base. Since this was loaded into vram already.
	ld (_RAM_C703_spriteDrawNumber?), a
	ld hl, $BC9B
	call _LABEL_1420_SpriteHandleroutsideMatches
	ret

_LABEL_73C76_forkliftCharSpriteSet:
;From what I could see from this is the 
	ld c, $72
	ld a, (_RAM_C7EB_forkliftHeight)
	ld b, a
	ld a, (_RAM_C357_player1char)
	ld e, $00
	cp $01
	jr z, +
	ld e, $40
	cp $02
	jr z, +
	ld e, $80
+:
	ld a, (_RAM_C7ED_plyr1ForkliftSprite)
	add a, e
	ld (_RAM_C703_spriteDrawNumber?), a
	ld hl, $BC9B
	call _LABEL_1420_SpriteHandleroutsideMatches
	ret
;unused, have to be checked later.
; Data from 73C9B to 73D1B (129 bytes)
.db $00 $01 $00 $00 $00 $02 $08 $00 $00 $03 $10 $00 $00 $04 $18 $00
.db $00 $05 $00 $08 $00 $06 $08 $08 $00 $07 $10 $08 $00 $08 $18 $08
.db $00 $09 $00 $10 $00 $0A $08 $10 $00 $0B $10 $10 $00 $0C $18 $10
.db $00 $0D $00 $18 $00 $0E $08 $18 $00 $0F $10 $18 $00 $10 $18 $18
.db $00 $11 $00 $20 $00 $12 $08 $20 $00 $13 $10 $20 $00 $14 $18 $20
.db $00 $15 $00 $28 $00 $16 $08 $28 $00 $17 $10 $28 $00 $18 $18 $28
.db $00 $19 $00 $30 $00 $1A $08 $30 $00 $1B $10 $30 $00 $1C $18 $30
.db $00 $1D $00 $38 $00 $1E $08 $38 $00 $1F $10 $38 $00 $20 $18 $38
.db $40

; Data from 73D1C to 73F1B (512 bytes)
_DATA_73D1C_pausedTilesandData:
.db $00 $00 $00 $00 $1F $1F $1F $1F $3F $20 $3F $3F $60 $40 $7F $7F
.db $60 $40 $70 $70 $60 $40 $70 $70 $60 $40 $70 $70 $60 $40 $70 $70
.db $00 $00 $00 $00 $FF $FF $FF $FF $FF $00 $FF $FF $00 $00 $FF $FF
.dsb 20, $00
.db $FF $FF $FF $FF $FF $00 $FF $FF $00 $00 $FF $FF
.dsb 15, $00
.db $0E $00 $00 $00 $00 $FF $FF $FF $FF $FF $00 $FF $FF $00 $00 $FF
.db $FF
.dsb 15, $00
.db $01
.dsb 32, $00
.db $60 $40 $70 $70 $60 $40 $70 $70 $60 $40 $70 $70 $60 $40 $70 $70
.db $60 $40 $70 $70 $60 $40 $70 $70 $60 $40 $70 $70 $60 $40 $70 $70
.db $00 $00 $00 $1F $00 $00 $00 $3B $00 $00 $00 $33 $00 $00 $00 $37
.db $00 $00 $00 $3E $00 $00 $00 $3C $00 $00 $00 $30 $00 $00 $00 $30
.dsb 11, $00
.db $1C $00 $00 $00 $36 $00 $00 $00 $66 $00 $00 $00 $66 $00 $00 $00
.db $66 $00 $00 $00 $6E
.dsb 11, $00
.db $44 $00 $00 $00 $CD $00 $00 $00 $CD $00 $00 $00 $CC $00 $00 $00
.db $CC $00 $00 $00 $D8
.dsb 11, $00
.db $E3 $00 $00 $00 $C6 $00 $00 $00 $8D $00 $00 $00 $CF $00 $00 $00
.db $6C $00 $00 $00 $ED $00 $00 $00 $03 $00 $00 $00 $03 $00 $00 $00
.db $8F $00 $00 $00 $DB $00 $00 $00 $B3 $00 $00 $00 $33 $00 $00 $00
.db $B3 $00 $00 $00 $B6 $00 $00 $00 $30
.dsb 14, $00
.db $FF $FF $FF $00 $FF $FF $FF $FF $FF $FF $00 $00 $00 $00 $00 $00
.db $00 $3B
.dsb 14, $00
.db $FF $FF $FF $00 $FF $FF $FF $FF $FF $FF $00 $00 $00 $00 $00 $00
.db $00 $71
.dsb 14, $00
.db $FF $FF $FF $00 $FF $FF $FF $FF $FF $FF $00 $00 $00 $00 $00 $00
.db $00 $C7
.dsb 14, $00
.db $FF $FF $FF $00 $FF $FF $FF $FF $FF $FF $00 $00 $00 $00 $00 $00
.db $00 $1C
.dsb 14, $00
.db $FF $FF $FF $00 $FF $FF $FF $FF $FF $FF $00 $00 $00 $00

; Data from 73F1C to 73FFF (228 bytes)
_DATA_73F1C_:
.db $64 $00 $65 $00 $65 $00 $66 $00 $65 $00 $65 $00 $65 $00 $67 $00
.db $65 $00 $65 $00 $64 $02 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00
.db $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00
.db $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00
.db $69 $00 $68 $00 $68 $00 $6A $00 $6B $00 $6C $00 $6D $00 $6E $00
.db $68 $00 $68 $00 $69 $02 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00
.db $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00
.db $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00
.db $64 $04 $65 $06 $65 $06 $6F $00 $70 $00 $71 $00 $72 $00 $73 $00
.db $65 $06 $65 $06 $64 $06 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00
.db $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00
.db $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68 $00 $68
.dsb 37, $00

.BANK 29
.ORG $0000

_LABEL_74000_sound?:
	ld a, (_RAM_C20A_musicEnable) ;Get if music is playing.
	or a						  ;Clear carry.
	ret z							;If music is not playing, then return.
	ld a, (_RAM_C20E_musicTimer?)	;Get the timer from the music.
	or a							;Clear carry again.
	jr z, +							;If the timer is zero, jump ahead
	dec a							;Otherwise decrement the counter.
	ld (_RAM_C20E_musicTimer?), a	;Load back the timer's value.
	ret								;Return from subroutine call.

+:									;The timer is zero, so let's see/guess what this does.
	ld a, (_RAM_C20D_musicTempo)	;Fetch the tempo/speed.
	ld (_RAM_C20E_musicTimer?), a	;Load it into the timer?
	ld a, (_RAM_C223_PSG1?)			;Check if PSG channel 1 is enabled.
	or a							;Clear carry.
	jr z, ++						;If channel is enabled (00), jump ahead.
	;---------------------------------------------------------------------------------
	ld e, a							;Since the channel is not enabled, move it to e.
	ld a, (_RAM_C225_soundFadeOutTimer) ;Load the sound fadeout timer in.
	or a							;Del carry.
	jr z, +							;If it's already zero, jump ahead again.
	dec a							;Else decrement the value.
	ld (_RAM_C225_soundFadeOutTimer), a	;and load it back to RAM.
	jp ++

+:
	ld a, (_RAM_C224_musicFadaoutPrescaler) ;Get the fadeout prescaler value.
	ld (_RAM_C225_soundFadeOutTimer), a ;Reload the fadeout timer.
	ld a, (_RAM_C20B_musicVolume)		;Get the music volume.
	add a, e 							
	cp $10								;Compare with 16.
	jr c, +								;If it is bigger than 16, jump.
	cp $C8								;Compare it with 200.
	jp nc, PSG_SILENCE2					;Jump if no carry is set, and silence the PSG.
	xor a								;Clear the accumulator.
	ld (_RAM_C223_PSG1?), a				;Turn on PSG Channel 1.
	ld a, $0F							
	ld (_RAM_C20B_musicVolume), a		;Then set a volume to the maximum.
	jp ++

+:
	cp $C8								;Compare again?
	jp nc, PSG_SILENCE2					;Jump when no carry.
	ld (_RAM_C20B_musicVolume), a		;Puts back the music volume.
++:
	ld a, (_RAM_C226_musicSegmentCounter?)		;After the volume setting, we get the current music segment counter.
	or a										;Clear Carry.
	jp z, +										;If the segment counter expired, jump ahead.
	ld a, (_RAM_C226_musicSegmentCounter?)		;Else fetch the the value again,
	dec a										;decrement it,
	ld (_RAM_C226_musicSegmentCounter?), a		;and put it back.
	jp _LABEL_740B2_appregioHandler?							;Jump to other parts of this code.TODO

+:
	ld a, (_RAM_C20C_musicSegmentLength)		;Get the total music segment length. If you modify this, the music will go haywire. Default length is 3F.
	ld (_RAM_C226_musicSegmentCounter?), a		;Set the segment length.
	xor a										;Clear accumulator.
	ld (_RAM_C21B_appregioDecayCH1), a
	ld (_RAM_C21C_appregioDecayCH2), a
	ld (_RAM_C21D_appregioDecayCH3), a
	ld (_RAM_C21E_noiseCHdecay), a				;Clear appregio and some other registers.
	ld hl, (_RAM_C20F_musicSegmentPointer)	;Load a music pointer from somewhere? I have to check where the code will get this before this code is called.
-:
	ld e, (hl)									;Read from the loaded address into e.
	inc hl										;Increase source.
	ld a, (hl)									;Read into the accumulator.
	cp $02										;Is the value 2?
	jr nc, +									;Jump if carry is not set.
	or a										;Clear carry.
	jp z, PSG_SILENCE2							;If the value is 00, then silence the channel.
	ld l, e										;Load e to the lower byte of the register.
	ld h, $00									;Reset the high byte.
	add hl, hl
	add hl, hl
	add hl, hl									;Shift bytes around.
	ld de, (_RAM_C211_musicPointer)							;This is definetly a pointer where the music data is from (2 byte pointer/variable)
	add hl, de									;Load pointer into HL, so the code can read from it. So this is the music reading loop.
	jp -										;This has any meaning with the code below.

+:
	inc hl										;The below part is most likely for getting song data, and pass it to RAM for the engine to process.
	ld d, a
	ld (_RAM_C213_ch1Note), de
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld (_RAM_C215_ch2Note), de
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld (_RAM_C217_ch3Note), de
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld (_RAM_C219_noiseNote), de	;Yes, fill the appropriate RAM addresses with the music data,
	ld (_RAM_C20F_musicSegmentPointer), hl	;then increment the segment pointer.
_LABEL_740B2_appregioHandler?:					;From the variables alone, this part is for handling appregio.
	ld a, (_RAM_C21B_appregioDecayCH1)			
	or a
	jr z, +										;If the appregio is done, jump ahead.
	dec a										;Else increase the value and write it back.
	ld (_RAM_C21B_appregioDecayCH1), a
	jp ++

+:												;If the appregio (timer?) is already zero, then jump here.
	ld hl, (_RAM_C213_ch1Note)					;Set the note.
	ld c, $00									;Set this to zero, and enable the channel.
	ld de, _RAM_C21F_ch1enable
	call _LABEL_74131_playnote?
	ld (_RAM_C21B_appregioDecayCH1), a
	ld (_RAM_C213_ch1Note), hl
++:
	ld a, (_RAM_C21C_appregioDecayCH2)
	or a
	jr z, +
	dec a
	ld (_RAM_C21C_appregioDecayCH2), a
	jp ++

+:
	ld hl, (_RAM_C215_ch2Note)
	ld c, $01
	ld de, _RAM_C220_ch2enable
	call _LABEL_74131_playnote?
	ld (_RAM_C21C_appregioDecayCH2), a
	ld (_RAM_C215_ch2Note), hl
++:
	ld a, (_RAM_C21D_appregioDecayCH3)
	or a
	jr z, +
	dec a
	ld (_RAM_C21D_appregioDecayCH3), a
	jp ++

+:
	ld hl, (_RAM_C217_ch3Note)
	ld c, $02
	ld de, _RAM_C221_ch3Enable
	call _LABEL_74131_playnote?
	ld (_RAM_C21D_appregioDecayCH3), a
	ld (_RAM_C217_ch3Note), hl
++:
	ld a, (_RAM_C21E_noiseCHdecay)
	or a
	jr z, +
	dec a
	ld (_RAM_C21E_noiseCHdecay), a
	ret

+:
	ld hl, (_RAM_C219_noiseNote)
	ld c, $03
	ld de, _RAM_C222_channel4Enable
	call _LABEL_74131_playnote?
	ld (_RAM_C21E_noiseCHdecay), a
	ld (_RAM_C219_noiseNote), hl
	ret

; Data from 74129 to 74130 (8 bytes)
_DATA_74129_:
.db $00 $01 $02 $03 $05 $07 $0B $0F

_LABEL_74131_playnote?:
	ld a, (hl)		;The note also comes here. HL here is the source of the note we'll have to play.
	ex af, af'		;Switch registers? (I guess to hold this value for later.)
	inc hl			;Get the next value.
	ld b, (hl)		;Second byte is in b now.
	inc hl
	push hl			;Get a third byte, and push it to the stack. This will be used, if the jr z below is taken.
	ld a, b			;Load the second byte into the accumulator, and it with 7. Bitmask it. 0000 0111
	and $07
	ld l, a			;Load it into the lower byte of HL.
	ld h, $00		;Set 00 to the higher one.
	ld a, (de)		;de contains the value if the channel is enabled or not.
	ld de, _DATA_74129_	;Load from above data label, and add it to HL.
	add hl, de
	or a			;Lose the carry.
	jr z, +			;If the channel is enabled, continue at the next +. Zero means the channel is enabled, any other value means the channel is disabled. 
	ld a, (hl)		;Read from the address into A. The address was made from the above few instructions.
	pop hl			;Get the value back from the stack, and return. I guess the value will be used elsewhere.
	ret				;Return from this small routine.

+:
	ld a, (hl)		;Read from this address made from above.
	push af			;Push what was just read on the stack.
	ex af, af'		;Put it into the shadow reg.
	or a			;Lose carry.
	jr nz, +
	pop af
	pop hl			;If the result is non-zero, jump ahead, else get back a and hl from the stack, and return.
	ret

+:
	ex af, af'
	ld a, b
	srl a
	srl a
	and $3E
	ld l, a
	ld h, $00		;Do some other data masking and stuff.
	ld de, _RAM_C227_
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex af, af'
	ex de, hl
	call _LABEL_745A8_
	pop af
	pop hl
	ret

PSG_SILENCE2:
	xor a
	ld (_RAM_C223_PSG1?), a
	ld (_RAM_C20B_musicVolume), a
	ld (_RAM_C20A_musicEnable), a
	ld a, $9F ;1001 1111
	out (Port_PSG), a
	ld a, $BF ;1000 1111
	out (Port_PSG), a
	ld a, $DF ;1101 1111
	out (Port_PSG), a
	ld a, $FF ;1111 1111
	out (Port_PSG), a
	ret

_LABEL_74186_fadeoutandStop?:
	ld (_RAM_C224_musicFadaoutPrescaler), a
	ld a, $FF
	ld (_RAM_C223_PSG1?), a
	ret

_LABEL_7418F_musicInit: ;This is the music playing routine entry point.
	push hl ;The music's source address is in HL before this routine is called.
	call PSG_SILENCE2 ;Stop everything, and silence the sound before we play anything new.
	pop hl ;Getting it back.
	ld a, (hl) ;Read a value from there.
	ld (_RAM_C20D_musicTempo), a	;So the first byte is the tempo for the song.
	inc hl
	ld a, (hl)
	ld (_RAM_C20B_musicVolume), a	;Second is the initial volume.
	inc hl
	ld a, (hl)
	ld (_RAM_C20C_musicSegmentLength), a	;Sets the segment length. 3
	inc hl
	ld a, (hl)
	ld (_RAM_C223_PSG1?), a	;Enable or disable channel 1. 4
	inc hl
	ld a, (hl)
	ld (_RAM_C224_musicFadaoutPrescaler), a	;Set prescaler. 5
	inc hl
	ld e, (hl) ;6th byte
	inc hl
	ld d, (hl)	;7th byte
	;Fill in the DE register pair.
	inc hl
	ld (_RAM_C211_musicPointer), hl	;8th byte
	ld (_RAM_C20F_musicSegmentPointer), hl	;Copy the same byte there also.
	ld a, $10
	ld hl, _RAM_C227_	;There is only three mentions of this variable, so I have no idea yet where data is loaded into this variable.
	ld bc, $0026
-:
	ld (hl), e	;Copy the 6th byte into C227.
	inc hl	;Now C228
	ld (hl), d	;7th byte into C227.
	inc hl	;C229
	ex de, hl	;Switch the contents of HL to DE. DE is now C229, and HL contains now the 6 and 7th byte.
	add hl, bc	;Add this $26 to HL to this byte grabbed from the data.
	ex de, hl	;Switch registers again, DE has now this summed value, and the originals in HL.
	dec a		;a is now F.
	jr nz, -	;Loop sixteen times.
	xor a		;a is 0.
	ld (_RAM_C20E_musicTimer?), a	;Expire music timer.
	ld (_RAM_C225_soundFadeOutTimer), a	
	ld (_RAM_C226_musicSegmentCounter?), a
	inc a
	ld (_RAM_C20A_musicEnable), a	;Enable music playing.
	ret

_LABEL_741D8_music?:
	ld ix, _RAM_C267_ch1NoteSustain
	ld a, $04
-:
	push af
	ld a, (ix+0)
	or a
	jr z, +++
	ld a, (ix+5)
	cp $60
	jr nz, +
	ld a, (ix+7)
	and $07
	or $E0
	out (_PORT_7E_VCounter), a
	jp ++

+:
	ld l, (ix+1)
	ld h, (ix+2)
	call _LABEL_7425A_
	call _LABEL_743A1_
	ld (ix+1), l
	ld (ix+2), h
	call _LABEL_74480_
	call +++++
++:
	call _LABEL_743D1_
	call ++++
+++:
	ld bc, $002C
	add ix, bc
	pop af
	dec a
	jr nz, -
	ret

++++:
	ld a, (_RAM_C20B_musicVolume)
	xor $0F
	ld e, a
	ld a, (ix+6)
	add a, e
	cp $10
	jr c, +
	ld a, $0F
+:
	or (ix+5)
	or $90
	out (Port_PSG), a
	ret

+++++:
	ld a, (ix+5)
	cp $60
	ret z
	ld e, a
	ld a, l
	and $0F
	or e
	or $80
	out (Port_PSG), a
	ld a, l
	rrca
	rrca
	rrca
	rrca
	and $0F
	ld l, a
	ld a, h
	rlca
	rlca
	rlca
	rlca
	and $30
	or l
	out (Port_PSG), a
	ret

_LABEL_7425A_:
	ld a, (ix+8)
	or a
	ret z
	ex af, af'
	ld a, (ix+9)
	or a
	jr z, +
	dec a
	ld (ix+9), a
	ret

+:
	ld a, (ix+15)
	or a
	jr z, +
	dec a
	ld (ix+15), a
	ret

+:
	ld a, (ix+14)
	ld (ix+15), a
	ex af, af'
	dec a
	jp z, +
	dec a
	jp z, _LABEL_742FC_
	dec a
	jp z, _LABEL_74325_
	dec a
	jp z, _LABEL_74339_
	dec a
	jp _LABEL_74357_

+:
	push hl
	call ++
	pop hl
	ld a, (ix+12)
	or a
	jr z, +
	cp $03
	jr z, +
	ld d, $00
	or a
	sbc hl, de
	ret

+:
	ld d, $00
	add hl, de
	ret

++:
	ld l, (ix+11)
	ld h, (ix+10)
	ld a, (ix+13)
	ld e, a
	and $80
	jr nz, ++
	srl l
	rr h
	ld (ix+11), l
	ld (ix+10), h
	inc e
	ld a, l
	or a
	jr nz, +
	ld a, (ix+12)
	inc a
	and $03
	ld (ix+12), a
	set 7, e
+:
	ld (ix+13), e
	ld e, l
	ret

++:
	sla h
	rl l
	ld (ix+11), l
	ld (ix+10), h
	ld a, e
	and $7F
	dec a
	jr z, +
	or $80
	ld (ix+13), a
	ld e, l
	ret

+:
	ld (ix+13), a
	ld a, (ix+12)
	inc a
	and $03
	ld (ix+12), a
	ld e, l
	ret

_LABEL_742FC_:
	ld a, (ix+12)
	or a
	jp z, +
	cp $03
	jp z, +
	dec hl
	jp ++

+:
	inc hl
++:
	ex af, af'
	ld e, (ix+13)
	inc e
	ld a, (ix+11)
	cp e
	jr nc, +
	ld e, $00
	ex af, af'
	inc a
	and $03
	ld (ix+12), a
+:
	ld (ix+13), e
	ret

_LABEL_74325_:
	dec hl
	ld e, (ix+13)
	inc e
	ld a, (ix+11)
	cp e
	jr nc, +
	ld d, $00
	add hl, de
	ld e, $00
+:
	ld (ix+13), e
	ret

_LABEL_74339_:
	ld a, (ix+13)
	inc a
	and $01
	ld (ix+13), a
	jr z, +
	ld e, (ix+11)
	srl e
	ld d, $00
	add hl, de
	ret

+:
	ld e, (ix+11)
	srl e
	ld d, $00
	sbc hl, de
	ret

_LABEL_74357_:
	ld a, (ix+12)
	or a
	jp z, +
	ld a, (ix+13)
	dec a
	ld (ix+13), a
	or a
	jp nz, ++
	ld a, (ix+12)
	inc a
	and $01
	ld (ix+12), a
	jp ++

+:
	ld a, (ix+13)
	inc a
	ld (ix+13), a
	cp (ix+11)
	jp c, ++
	ld a, (ix+12)
	inc a
	and $01
	ld (ix+12), a
++:
	ld a, (ix+13)
	ld e, a
	and $01
	jr z, +
	sla e
	ld d, $00
	add hl, de
	ret

+:
	sla e
	ld d, $00
	or a
	sbc hl, de
	ret

_LABEL_743A1_:
	ld a, (ix+16)
	or a
	ret z
	ex af, af'
	ld a, (ix+17)
	or a
	jr z, +
	dec a
	ld (ix+17), a
	ret

+:
	ld a, (ix+19)
	or a
	jr z, ++
	dec a
	or a
	jr nz, +
	ld (ix+16), a
	ret

+:
	ld (ix+19), a
++:
	ld e, (ix+18)
	ld d, $00
	ex af, af'
	dec a
	jr nz, +
	sbc hl, de
	ret

+:
	add hl, de
	ret

_LABEL_743D1_:
	ld a, (ix+30)
	or a
	jr z, _LABEL_74451_
	dec a
	jr z, _LABEL_7441F_
	dec a
	jr z, ++
	ld a, (ix+42)
	or a
	jr z, +
	dec a
	ld (ix+42), a
	ret

+:
	ld a, (ix+41)
	ld (ix+42), a
	ld a, (ix+40)
	or a
	jr nz, +
	xor a
	ld (ix+0), a
	ret

+:
	dec a
	ld (ix+40), a
	ld e, (ix+43)
	ld a, (ix+6)
	add a, e
	cp $10
	jr c, +
	ld a, $0F
+:
	ld (ix+6), a
	ret

++:
	ld a, (ix+39)
	or a
	jr z, +
	dec a
	ld (ix+39), a
	ret

+:
	ld a, $03
	ld (ix+30), a
	ret

_LABEL_7441F_:
	ld a, (ix+37)
	or a
	jr z, +
	dec a
	ld (ix+37), a
	ret

+:
	ld a, (ix+36)
	ld (ix+37), a
	ld a, (ix+35)
	or a
	jr nz, +
	ld a, $02
	ld (ix+30), a
	ret

+:
	dec a
	ld (ix+35), a
	ld e, (ix+38)
	ld a, (ix+6)
	add a, e
	cp $10
	jr c, +
	ld a, $0F
+:
	ld (ix+6), a
	ret

_LABEL_74451_:
	ld a, (ix+33)
	or a
	jr z, +
	dec a
	ld (ix+33), a
	ret

+:
	ld a, (ix+32)
	ld (ix+33), a
	ld a, (ix+31)
	or a
	jr nz, +
	ld a, $01
	ld (ix+30), a
	ret

+:
	dec a
	ld (ix+31), a
	ld e, (ix+34)
	ld a, (ix+6)
	sub e
	jr nc, +
	xor a
+:
	ld (ix+6), a
	ret

_LABEL_74480_:
	ld a, (ix+20)
	or a
	ret z
	ld a, (ix+21)
	or a
	jr z, +
	dec a
	ld (ix+21), a
	ret

+:
	ld a, (ix+22)
	or a
	jr z, ++
	dec a
	or a
	jr nz, +
	ld (ix+20), a
	ret

+:
	ld (ix+22), a
++:
	ld a, (ix+24)
	or a
	jr z, +
	dec a
	ld (ix+24), a
	ld a, (ix+25)
	jp ++

+:
	ld a, (ix+23)
	ld (ix+24), a
	ld a, (ix+25)
	inc a
	and $03
	ld (ix+25), a
++:
	push hl
	add a, $1A
	ld e, a
	ld d, $00
	push ix
	pop hl
	add hl, de
	ld e, (hl)
	sla e
	ld d, $00
	ld l, (ix+3)
	ld h, (ix+4)
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	pop hl
	push de
	call +
	pop hl
	add hl, de
	ret

+:
	push hl
	ld l, (ix+3)
	ld h, (ix+4)
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex de, hl
	pop de
	push de
	or a
	sbc hl, de
	ex de, hl
	pop hl
	ret

_LABEL_744F4_:
	dec a
	add a, a
	ld l, a
	ld h, $00
	ld de, _DATA_74508_
	add hl, de
	ld (ix+3), l
	ld (ix+4), h
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex de, hl
	ret

; Data from 74508 to 74597 (144 bytes)
_DATA_74508_:
.db $FF $03 $C6 $03 $90 $03 $5C $03 $2C $03 $FF $02 $D4 $02 $AB $02
.db $85 $02 $60 $02 $3E $02 $1E $02 $FF $03 $C6 $03 $90 $03 $5C $03
.db $2C $03 $FF $02 $D4 $02 $AB $02 $85 $02 $60 $02 $3E $02 $1E $02
.db $FF $01 $E3 $01 $C8 $01 $AE $01 $96 $01 $7F $01 $6A $01 $55 $01
.db $42 $01 $30 $01 $1F $01 $0F $01 $FF $00 $F1 $00 $E4 $00 $D7 $00
.db $CB $00 $BF $00 $B5 $00 $AA $00 $A1 $00 $98 $00 $8F $00 $87 $00
.db $7F $00 $78 $00 $72 $00 $6B $00 $65 $00 $5F $00 $5A $00 $55 $00
.db $50 $00 $4C $00 $47 $00 $43 $00 $3F $00 $3C $00 $39 $00 $35 $00
.db $32 $00 $2F $00 $2D $00 $2A $00 $28 $00 $26 $00 $23 $00 $21 $00

; Data from 74598 to 745A7 (16 bytes)
_DATA_74598_palette?: ;This may have been a palette?
.db $67 $C2 $00 $00 $93 $C2 $20 $00 $BF $C2 $40 $00 $EB $C2 $60 $00

_LABEL_745A8_:
	ex af, af'
	ld a, c
	exx
	add a, a
	add a, a
	ld l, a
	ld h, $00
	ld de, _DATA_74598_palette?
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld a, (hl)
	push de
	pop ix
	ld (ix+5), a
	ex af, af'
	call _LABEL_744F4_
	ld (ix+1), l
	ld (ix+2), h
	ld a, $01
	ld (ix+0), a
	push ix
	pop de
	ld hl, $0006
	add hl, de
	push hl
	exx
	pop de
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ret

; Data from 74625 to 74D5B (1847 bytes)
_DATA_74625_titleScreenMusic:
.incbin "pf_e_DATA_74625_.inc"

; Data from 74D5C to 7512E (979 bytes)
_DATA_74D5C_charSelectMusic:
.db $03 $00 $3F $01 $03 $D6 $8A $C5 $8E $C3 $8E $C1 $8E $CE $8A $E9
.db $8E $E7 $8E $E5 $8E $CE $8A $C5 $8E $3D $8E $3F $8E $61 $8F $E9
.db $8E $7F $8E $81 $8E $61 $8F $3F $8E $C5 $8E $C5 $8D $EF $90 $81
.db $8E $E9 $8E $F5 $8D $EF $90 $3F $8E $C5 $8E $C5 $8D $EF $90 $81
.db $8E $E9 $8E $F5 $8D $EF $90 $6F $90 $9F $8F $C7 $8F $EF $90 $EF
.db $8F $9F $8F $C7 $8F $EF $90 $6F $90 $9F $8F $2F $90 $EF $90 $EF
.db $8F $9F $8F $2F $90 $EF $90 $04 $01 $2E $1B $0A $09 $0A $09 $19
.db $09 $0A $09 $22 $1B $2E $1B $0A $09 $22 $19 $19 $09 $0A $09 $22
.db $1B $2A $23 $06 $09 $06 $09 $0A $09 $06 $09 $1E $23 $2A $23 $06
.db $09 $1E $21 $0A $09 $06 $09 $1E $23 $2C $23 $14 $09 $14 $21 $18
.db $09 $14 $09 $20 $23 $2C $23 $14 $09 $14 $09 $18 $09 $14 $09 $20
.db $23 $27 $1B $03 $09 $03 $09 $12 $09 $03 $09 $1B $1B $27 $1B $03
.db $09 $1B $19 $12 $09 $03 $09 $1B $1B $2C $23 $14 $09 $14 $21 $24
.db $09 $14 $09 $20 $23 $2C $23 $14 $09 $14 $09 $24 $09 $14 $09 $20
.db $23 $00 $00 $29 $09 $25 $09 $22 $09 $1D $09 $19 $09 $16 $09 $29
.db $09 $25 $09 $29 $09 $25 $09 $22 $09 $1D $09 $19 $09 $16 $09 $29
.db $09 $25 $09 $25 $09 $22 $09 $1E $09 $19 $09 $16 $09 $12 $09 $25
.db $09 $22 $09 $25 $09 $22 $09 $1E $09 $19 $09 $16 $09 $12 $09 $25
.db $09 $22 $09 $00 $00 $27 $09 $24 $09 $20 $09 $1B $09 $18 $09 $14
.db $09 $27 $09 $24 $09 $27 $09 $24 $09 $20 $09 $1B $09 $18 $09 $14
.db $09 $27 $09 $24 $09 $2E $09 $2A $09 $27 $09 $22 $09 $1E $09 $1B
.db $09 $2E $09 $2A $09 $2E $09 $2A $09 $27 $09 $22 $09 $1E $09 $1B
.db $09 $2E $09 $2A $09 $00 $00 $00 $00 $29 $0B $2E $0B $30 $0B $31
.db $0B $30 $0B $2E $0B $29 $0B $25 $0B $2A $0B $2E $0B $30 $0B $31
.db $0B $30 $0B $2E $0B $2A $0B $25 $0B $00 $00 $00 $00 $2C $0B $30
.db $0B $31 $0B $33 $0B $31 $0B $30 $0B $2C $0B $27 $0B $2E $0B $2A
.db $0B $29 $0B $27 $0B $2E $0B $2A $0B $29 $0B $27 $0B $2E $1D $22
.db $1B $2E $19 $22 $1B $2E $19 $22 $19 $22 $19 $00 $01 $22 $19 $22
.db $19 $22 $19 $2E $1D $22 $1B $2E $19 $22 $1B $2E $19 $22 $19 $22
.db $19 $00 $01 $22 $19 $22 $19 $22 $19 $2A $25 $1E $23 $2A $21 $1E
.db $23 $2A $21 $1E $21 $1E $21 $00 $01 $1E $21 $1E $21 $1E $21 $2C
.db $25 $20 $23 $2C $21 $20 $23 $2C $21 $20 $21 $20 $21 $00 $01 $20
.db $21 $20 $21 $20 $21 $00 $03 $01 $51 $01 $61 $01 $69 $01 $71 $01
.db $51 $01 $61 $01 $69 $01 $71 $01 $51 $01 $61 $01 $69 $01 $71 $01
.db $51 $01 $61 $01 $69 $01 $71 $01 $51 $01 $61 $01 $69 $01 $71 $01
.db $51 $01 $61 $01 $69 $01 $71 $01 $51 $01 $61 $01 $69 $01 $71 $01
.db $51 $01 $61 $2E $1B $29 $0B $27 $09 $29 $09 $00 $03 $29 $0C $29
.db $0B $29 $09 $27 $09 $29 $09 $2C $23 $27 $0B $25 $09 $27 $09 $00
.db $03 $27 $0C $27 $0B $27 $09 $25 $09 $22 $09 $3A $33 $00 $03 $22
.db $09 $22 $09 $00 $03 $25 $0C $25 $0B $25 $09 $25 $09 $25 $09 $38
.db $3B $00 $03 $20 $09 $20 $09 $00 $03 $22 $0C $22 $0B $22 $09 $22
.db $09 $22 $09 $16 $11 $16 $11 $22 $11 $16 $11 $16 $11 $16 $11 $14
.db $11 $22 $11 $19 $11 $19 $11 $25 $11 $19 $11 $19 $11 $19 $11 $17
.db $11 $25 $11 $14 $11 $14 $11 $20 $11 $14 $11 $14 $11 $12 $11 $14
.db $11 $20 $11 $0F $11 $0F $11 $1B $11 $0F $11 $0F $11 $0D $11 $0F
.db $11 $1B $11 $2E $11 $2E $11 $35 $11 $2E $11 $33 $11 $2E $11 $31
.db $11 $2E $11 $30 $11 $2E $11 $31 $11 $2E $11 $35 $11 $33 $11 $31
.db $11 $33 $11 $2E $11 $2E $11 $35 $11 $2E $11 $33 $11 $2E $11 $31
.db $11 $2E $11 $30 $11 $2E $11 $31 $11 $2E $11 $29 $11 $2C $11 $2E
.db $11 $31 $11 $16 $11 $16 $11 $1D $11 $16 $11 $16 $11 $1E $11 $16
.db $11 $16 $11 $1D $11 $16 $11 $16 $11 $16 $11 $1B $11 $19 $11 $18
.db $11 $19 $11 $16 $11 $16 $11 $1D $11 $16 $11 $16 $11 $1E $11 $16
.db $11 $16 $11 $1D $11 $16 $11 $16 $11 $16 $11 $1B $11 $1D $11 $19
.db $11 $18 $11 $12 $11 $12 $11 $1E $11 $12 $11 $12 $11 $1D $11 $12
.db $11 $12 $11 $1B $11 $12 $11 $12 $11 $19 $11 $18 $11 $16 $11 $14
.db $11 $12 $11 $14 $11 $14 $11 $1E $11 $14 $11 $14 $11 $1D $11 $14
.db $11 $14 $11 $1B $11 $14 $11 $14 $11 $19 $11 $18 $11 $19 $11 $1B
.db $11 $1D $11 $01 $51 $00 $01 $01 $59 $01 $51 $01 $51 $01 $51 $01
.db $59 $00 $01 $01 $51 $00 $01 $01 $59 $01 $51 $01 $51 $01 $51 $01
.db $59 $01 $59 $01 $51 $00 $01 $01 $59 $01 $51 $01 $51 $01 $51 $01
.db $59 $00 $01 $01 $51 $00 $01 $01 $59 $01 $51 $01 $59 $01 $51 $01
.db $59 $01 $59

; Data from 7512F to 7535F (561 bytes)
_DATA_7512F_ForkLiftMusic:
.db $03 $0F $3F $00 $00 $D6 $8A $AE $92 $AC $92 $CE $8A $20 $93 $AE
.db $92 $AC $92 $18 $92 $20 $93 $E0 $92 $DE $92 $AE $92 $20 $93 $E0
.db $92 $18 $92 $AE $92 $20 $93 $E8 $91 $68 $91 $60 $91 $20 $93 $02
.db $01 $1E $37 $36 $3F $20 $37 $38 $3F $1E $08 $23 $08 $25 $08 $23
.db $08 $25 $08 $2A $08 $2F $08 $2A $08 $2F $08 $31 $08 $2F $08 $31
.db $08 $36 $08 $3B $08 $36 $08 $31 $08 $1E $08 $23 $08 $25 $08 $23
.db $08 $25 $08 $2A $08 $2F $08 $2A $08 $2F $08 $31 $08 $2F $08 $31
.db $08 $36 $08 $3B $08 $36 $08 $31 $08 $20 $08 $25 $08 $27 $08 $25
.db $08 $27 $08 $2C $08 $31 $08 $2C $08 $31 $08 $33 $08 $31 $08 $33
.db $08 $38 $08 $3D $08 $38 $08 $33 $08 $20 $08 $25 $08 $27 $08 $25
.db $08 $27 $08 $2C $08 $31 $08 $2C $08 $31 $08 $33 $08 $31 $08 $33
.db $08 $38 $08 $3D $08 $38 $08 $33 $08 $12 $11 $12 $11 $15 $11 $12
.db $11 $1C $11 $12 $14 $15 $13 $15 $11 $17 $13 $17 $11 $15 $11 $14
.db $11 $14 $11 $14 $11 $17 $11 $14 $11 $1E $11 $14 $14 $17 $13 $17
.db $11 $19 $13 $19 $11 $1B $11 $1E $11 $25 $37 $31 $1C $31 $1C $25
.db $19 $31 $19 $2F $37 $2F $1C $2F $1C $23 $19 $2F $19 $00 $01 $00
.db $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00
.db $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00
.db $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00
.db $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00
.db $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00
.db $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00
.db $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00
.db $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $00 $19
.db $11 $19 $11 $1C $11 $19 $11 $23 $11 $19 $14 $1C $13 $1C $11 $1E
.db $13 $1E $11 $1C $11 $1B $11 $17 $11 $17 $11 $1A $11 $17 $11 $21
.db $11 $17 $14 $1A $13 $1A $11 $1C $13 $1C $11 $1E $11 $21 $11 $00
.db $00 $25 $09 $25 $09 $31 $09 $25 $09 $2F $09 $25 $09 $2C $09 $25
.db $09 $2A $09 $25 $09 $2C $09 $25 $09 $28 $09 $27 $09 $25 $09 $25
.db $09 $00 $09 $23 $09 $2F $09 $23 $09 $2D $09 $23 $09 $2A $09 $23
.db $09 $28 $09 $23 $09 $2A $09 $23 $09 $28 $09 $2A $09 $2D $09 $2F
.db $09 $01 $51 $00 $01 $01 $59 $01 $51 $01 $51 $01 $51 $01 $59 $00
.db $01 $01 $51 $00 $01 $01 $59 $01 $51 $01 $51 $01 $51 $01 $59 $01
.db $59 $01 $51 $00 $01 $01 $59 $01 $51 $01 $51 $01 $51 $01 $59 $00
.db $01 $01 $51 $00 $01 $01 $59 $01 $51 $01 $59 $01 $51 $01 $59 $01
.db $59

; Data from 75360 to 754D6 (375 bytes)
_DATA_75360_optionsMusic:
.db $02 $0F $3F $00 $00 $D6 $8A $63 $94 $61 $94 $5F $94 $CE $8A $63
.db $94 $61 $94 $5F $94 $B3 $94 $8B $94 $63 $94 $FF $93 $B3 $94 $9F
.db $94 $63 $94 $2F $94 $B3 $94 $8B $94 $63 $94 $FF $93 $B3 $94 $9F
.db $94 $B9 $93 $2F $94 $B3 $94 $8B $94 $DD $93 $FF $93 $B3 $94 $9F
.db $94 $63 $94 $2F $94 $B3 $94 $8B $94 $DD $93 $FF $93 $B3 $94 $9F
.db $94 $B9 $93 $2F $94 $B3 $94 $00 $01 $23 $13 $2F $13 $23 $13 $2F
.db $13 $23 $13 $2F $11 $1E $13 $2A $11 $1B $11 $2D $11 $24 $0B $25
.db $0B $27 $0B $25 $0B $27 $0B $29 $0B $27 $0B $2C $0B $29 $0D $2C
.db $0B $29 $0B $25 $0D $29 $0B $2A $0B $2C $0B $2A $0B $2C $0B $2E
.db $0B $2C $0B $31 $0B $00 $01 $00 $01 $00 $01 $00 $01 $00 $38 $19
.db $13 $14 $11 $19 $11 $0D $11 $19 $13 $19 $11 $19 $13 $14 $11 $19
.db $11 $0D $11 $19 $13 $19 $11 $19 $13 $19 $11 $14 $11 $0D $11 $19
.db $13 $19 $11 $19 $13 $14 $11 $19 $11 $0D $11 $19 $13 $19 $11 $17
.db $13 $12 $11 $17 $11 $0B $11 $17 $13 $17 $11 $17 $13 $12 $11 $17
.db $11 $0B $11 $17 $13 $17 $11 $14 $13 $14 $11 $0F $11 $08 $11 $14
.db $13 $14 $11 $14 $13 $0F $11 $14 $11 $08 $11 $14 $13 $14 $11 $00
.db $00 $00 $00 $25 $13 $31 $13 $25 $13 $31 $13 $25 $13 $31 $11 $20
.db $13 $2C $11 $1D $11 $2F $11 $25 $13 $31 $13 $25 $13 $31 $13 $25
.db $13 $31 $11 $20 $13 $2C $11 $1D $11 $2F $11 $31 $25 $31 $25 $25
.db $23 $31 $3D $00 $03 $0D $25 $19 $25 $25 $23 $31 $3D $00 $03 $2F
.db $25 $2F $25 $23 $23 $2F $3D $00 $03 $08 $25 $14 $25 $20 $23 $2C
.db $3D $00 $03 $01 $53 $00 $03 $01 $5B $01 $53 $01 $53 $01 $51 $01
.db $53 $01 $51 $01 $5B $01 $53 $00 $03 $01 $5B $01 $53 $01 $53 $01
.db $51 $01 $53 $01 $51 $01 $5B

; Data from 754D7 to 75519 (67 bytes)
_DATA_754D7_matchCardMusic:
.db $03 $0F $3F $00 $00 $D6 $8A $E8 $91 $68 $91 $60 $91 $20 $93 $0A
.db $95 $F0 $94 $00 $95 $CE $8A $00 $00 $25 $09 $25 $09 $31 $09 $25
.db $09 $00 $07 $00 $07 $00 $07 $00 $07 $25 $37 $00 $07 $00 $07 $00
.db $07 $00 $07 $19 $11 $19 $11 $1C $11 $19 $11 $00 $07 $00 $07 $00
.db $07 $00 $07

; Data from 7551A to 75C12 (1785 bytes)
_DATA_7551A_NameEntryMusic: ;This could be map data, as almost fits the complete space for that.
.incbin "pf_e_DATA_7551A_NameEntryMusic.inc"

; Data from 75C13 to 75CE5 (211 bytes)
_DATA_75C13_gameOverMusic: ;Sprite attribute tables might as well use these.
.db $06 $0F $3F $00 $00 $D6 $8A $66 $9C $46 $9C $24 $9C $B3 $94 $00
.db $01 $00 $01 $25 $0B $20 $0B $19 $0B $25 $0B $23 $0B $19 $0B $25
.db $0B $20 $0B $23 $0B $1E $0B $19 $0B $23 $0B $1E $0B $19 $0B $22
.db $0B $2A $0B $25 $03 $20 $03 $19 $03 $25 $03 $23 $03 $19 $03 $25
.db $03 $20 $03 $23 $03 $1E $03 $19 $03 $23 $03 $1E $03 $19 $03 $22
.db $03 $2A $03 $31 $10 $31 $10 $2C $10 $2C $10 $25 $10 $25 $10 $31
.db $10 $31 $10 $2F $10 $2F $10 $25 $10 $25 $10 $31 $10 $31 $10 $2C
.db $10 $2C $10 $31 $10 $31 $10 $2C $10 $2C $10 $25 $10 $25 $10 $31
.db $10 $31 $10 $2F $10 $2F $10 $25 $10 $25 $10 $31 $10 $31 $10 $38
.db $10 $38 $10 $2F $10 $2F $10 $2A $10 $2A $10 $25 $10 $25 $10 $2F
.db $10 $2F $10 $2C $10 $2C $10 $25 $10 $25 $10 $2F $10 $2F $10 $36
.db $10 $36 $10 $2E $10 $2E $10 $2A $10 $2A $10 $25 $10 $25 $10 $2E
.db $10 $2E $10 $2C $10 $2C $10 $25 $10 $25 $10 $2E $10 $2E $10 $36
.db $10 $36 $10

; Data from 75CE6 to 77FFF (8986 bytes)
_DATA_75CE6_plyrSelectBioTiles: ;Character selection graphics/character BIO.
.incbin "pf_e_DATA_75CE6_.inc"

.BANK 30 ;Player select character graphics, HUD and player/enemy mugshot graphics.
.ORG $0000

; Data from 78000 to 7869F (1696 bytes)
_DATA_78000_hudGraphics: ;Graphics for the HUD, and some map data.
.incbin "pf_e_DATA_78000_.inc"

; Data from 786A0 to 792FF (3168 bytes)
_DATA_786A0_plyrNmeMugshots: ;Player mugshots on the HUD, and some mapdata, I guess.
.incbin "pf_e_DATA_786A0_.inc"

; Data from 79300 to 793AF (176 bytes)
_DATA_79300_forklift: ;This is likely some mapdata for the forklift screen.
.db $54 $59
.dsb 11, $40
.db $00 $00 $00 $42 $55 $5A $5A
.dsb 9, $40
.db $00 $00 $00 $4B $41 $54 $4F
.dsb 9, $40
.db $00 $00 $00 $45 $58 $45 $43 $55 $54 $49 $4F $4E $45 $52 $40 $40
.db $00 $00 $00 $53 $4F $55 $54 $48 $53 $49 $44 $45 $40 $4A $49 $4D
.db $00 $00 $00 $41 $4E $47 $45 $4C $40 $40 $40 $40 $40 $40 $40 $40
.db $00 $00 $00 $43 $43 $40 $52 $49 $44 $45 $52 $40 $40 $40 $40 $40
.db $00 $00 $00 $4D $41 $44 $40 $4D $49 $4C $45 $53 $40 $40 $40 $40
.db $00 $00 $00 $48 $45 $41 $56 $59 $40 $4D $45 $54 $41 $4C $40 $40
.db $00 $00 $00 $43 $48 $41 $49 $4E $4D $41 $4E $40 $45 $44 $44 $40
.db $00 $00 $00 $54 $48 $45 $40 $57 $41 $52 $52 $49 $4F $52 $40 $40
.db $00 $00 $00

; Data from 793B0 to 7BFFF (11344 bytes)
_DATA_793B0_plyrPicsPlyrSelectPowerUpsThrowables: ;This is the player select portraits and power pill, and throwable object graphics.
.incbin "pf_e_DATA_793B0_.inc"

.BANK 31
.ORG $0000
;This bank contains graphics and tilemaps for the High Score and name entry screens.
; Data from 7C000 to 7CCFF (3328 bytes)
_DATA_7C000_hiScoreWarriorTile:
.incbin "pf_e_DATA_7C000_.inc"

; Data from 7CD00 to 7CD1F (32 bytes)
_DATA_7CD00_hiScorePalette:
.db $00 $01 $1B $2F $00 $1F $2F $3F $20 $06 $30 $3F $3A $34 $3E $39
.db $00 $01 $1B $2F $00 $1F $2F $3F $20 $06 $30 $3F $3A $34 $3E $39

; Data from 7CD20 to 7D71F (2560 bytes)
_DATA_7CD20_hiScoreLetterTiles:
.incbin "pf_e_DATA_7CD20_.inc"

; Data from 7D720 to 7D75F (64 bytes)
_DATA_7D720_:
.db $96 $11 $96 $11 $96 $11 $96 $11 $96 $11 $97 $11 $98 $11 $99 $11
.db $9A $11 $9B $11 $9C $11 $98 $11 $9D $11 $9E $11 $9F $11 $A0 $11
.db $A1 $11 $A2 $11 $A3 $11 $A4 $11 $A5 $11 $A6 $11 $A5 $11 $A7 $11
.db $A8 $11 $A0 $11 $A9 $11 $96 $11 $96 $11 $96 $11 $96 $11 $96 $11

; Data from 7D760 to 7D79F (64 bytes)
_DATA_7D760_:
.db $96 $11 $96 $11 $96 $11 $96 $11 $96 $11 $AA $11 $AB $11 $AC $11
.db $AD $11 $AE $11 $AF $11 $B0 $11 $B1 $11 $B2 $11 $B3 $11 $B4 $11
.db $B5 $11 $B6 $11 $B7 $11 $B8 $11 $B9 $11 $BA $11 $BB $11 $BC $11
.db $BD $11 $B4 $11 $BE $11 $96 $11 $96 $11 $96 $11 $96 $11 $96 $11

; Data from 7D7A0 to 7DCBF (1312 bytes)
_DATA_7D7A0_highScoresTileandMap:
.incbin "pf_e_DATA_7D7A0_.inc"

_LABEL_7DCC0_:
	ld de, (_RAM_C74D_)
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr z, ++
	ld c, $01
	ld hl, (_RAM_C781_plyr2stats?)
	ld a, h
	cp d
	jr nz, +
	ld a, l
	cp e
+:
	jr c, ++
	ld c, $02
	ex de, hl
++:
	ld a, c
	ld (_RAM_C372_timer?), a
	ld hl, _RAM_C815_lastHiscoreEntryLastByte
	call _LABEL_7DCF2_
	ret z
	ld a, (_RAM_C35F_numberofPlayers)
	or a
	jr nz, +
	ld a, $01
	ret

+:
	ld a, (_RAM_C372_timer?)
	ret

_LABEL_7DCF2_:
	push hl
	inc hl
	ld a, (hl)
	cp d
	jr nz, +
	dec hl
	ld a, (hl)
	cp e
+:
	jr nc, +
	pop hl
	ld bc, $0010
	add hl, bc
	jr _LABEL_7DCF2_

+:
	pop hl
	ld a, h
	cp $C8
	jr nz, +
	ld a, l
	cp $15
	jr nz, +
	xor a
	ret

+:
	inc hl
	inc hl
	ld bc, $C807
	or a
	sbc hl, bc
	push hl
	pop bc
	ld (_RAM_C374_timer?), de
	ld de, _RAM_C7F7_
	ld hl, _RAM_C807_lastHiscoreEntryFirstByte
	ldir
	push de
	ex de, hl
	ld de, (_RAM_C374_timer?)
	dec hl
	ld (hl), d
	dec hl
	ld (hl), e
	pop hl
	ld de, $FFF0
	add hl, de
	xor a
	inc a
	ret

_LABEL_7DD39_showHighScoreTable:
	call _LABEL_76F_timerBasedVDPDL
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES
	ld hl, _DATA_7C000_hiScoreWarriorTile
	ld de, $0040
	ld bc, $0D0A
	call _LABEL_806_loadTiles
	ld hl, _DATA_7CD20_hiScoreLetterTiles
	ld de, $0D40
	ld bc, $0A00
	call _LABEL_806_loadTiles
	ld hl, _DATA_7D7A0_highScoresTileandMap
	ld de, $32C0
	ld bc, $0520
	call _LABEL_806_loadTiles	;So we load all needed graphics, and reset both palettes.
	ld hl, $0000
	ld (_RAM_C33B_plyfieldborder), hl
	ld (_RAM_C33D_playFieldBaseHeight), hl	;Reset scrolling? It looks like this is what it will do.
	xor a
	ld (_RAM_C3A2_timerml), a	;Reset a timer here.
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	ld a, $E2	;1110 0010
	;Enable screen, set sprites to 8x8 and enable interrupts.
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $81	;1000 0001 Write to register 1.	
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $01
	ld (_RAM_C8B7_showSpriteHScore), a	;Enable showing The Warrior on screen as sprites.
	ld hl, _DATA_7CD00_hiScorePalette
	call _LABEL_7DFFD_
	xor a
	ld (_RAM_C8B8_horizontalScrolltitlescrn), a
	ld (_RAM_C8BA_highscoreNamePosSprite), a
	ld hl, $0000
	ld (_RAM_C374_timer?), hl
	ld hl, _RAM_start
	ld de, _RAM_start + 1
	ld bc, $007F
	ld (hl), $00
;The below is executed at the beginning of the RAM almost.
; Executed in RAM at 2
+:
	ldir
; Executed in RAM at 4
_LABEL_7DDAB_:
	xor a
; Executed in RAM at 5
++:
	ld (_RAM_C3A2_timerml), a
; Executed in RAM at 8
_LABEL_7DDAF_:
	ld a, (_RAM_C3A2_timerml)
; Executed in RAM at b
+++:
	or a
; Executed in RAM at c
++++:
	jr z, _LABEL_7DDAF_
; Executed in RAM at e
+++++:
	ld a, (_RAM_C8B8_horizontalScrolltitlescrn)
; Executed in RAM at 11
++++++:
	out (Port_VDPAddressControlPort), a
; Executed in RAM at 13
+++++++:
	nop
; Executed in RAM at 14
++++++++:
	nop
; Executed in RAM at 15
+++++++++:
	nop
; Executed in RAM at 16
++++++++++:
	ld a, $89
; Executed in RAM at 18
+++++++++++:
	out (Port_VDPAddressControlPort), a
; Executed in RAM at 1a
++++++++++++:
	nop
; Executed in RAM at 1b
+++++++++++++:
	nop
; Executed in RAM at 1c
++++++++++++++:
	ld a, (_RAM_C8BA_highscoreNamePosSprite)
; Executed in RAM at 1f
+++++++++++++++:
	cp $19
; Executed in RAM at 21
++++++++++++++++:
	jr nz, _LABEL_7DE09_scrollInatMatches
; Executed in RAM at 23
+++++++++++++++++:
	ld hl, (_RAM_C374_timer?)
; Executed in RAM at 26
++++++++++++++++++:
	inc hl
; Executed in RAM at 27
+++++++++++++++++++:
	ld (_RAM_C374_timer?), hl
; Executed in RAM at 2a
++++++++++++++++++++:
	ld a, h
; Executed in RAM at 2b
+++++++++++++++++++++:
	or a
; Executed in RAM at 2c
++++++++++++++++++++++:
	jr z, _LABEL_7DDAB_
; Executed in RAM at 2e
+++++++++++++++++++++++:
	ld a, l
; Executed in RAM at 2f
++++++++++++++++++++++++:
	cp $64
; Executed in RAM at 31
+++++++++++++++++++++++++:
	jr z, +++++++++++++++++++++++++++++
; Executed in RAM at 33
++++++++++++++++++++++++++:
	cp $FE
; Executed in RAM at 35
+++++++++++++++++++++++++++:
	jr z, ++++++++++++++++++++++++++++++
; Executed in RAM at 37
++++++++++++++++++++++++++++:
	jp _LABEL_7DDAB_

; Executed in RAM at 3a
+++++++++++++++++++++++++++++:
	call _LABEL_7E04D_
	xor a
	ld (_RAM_C8B7_showSpriteHScore), a
	jp _LABEL_7DDAB_

; Executed in RAM at 44
++++++++++++++++++++++++++++++:
	call _LABEL_55C_delay+pal?
	ld a, $E0
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $81
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ld a, $00
	out (Port_VDPAddressControlPort), a
	nop
	nop
	nop
	ld a, $89
	out (Port_VDPAddressControlPort), a
	nop
	nop
	ret

; Executed in RAM at 62
_LABEL_7DE09_scrollInatMatches: ;Okay, so this is executed from RAM.
;Also at the start of matches.
	ld a, (_RAM_C8B8_horizontalScrolltitlescrn)
	inc a
	cp $E0 ;224
	jr nz, + ;Jump if it's not line 224. Okay, so we wait until we are on line 224.
	xor a ;Reset a.
+: ;This is on line 224 being executed.
	ld (_RAM_C8B8_horizontalScrolltitlescrn), a ;Load the value back into RAM.
	and $07
	jr nz, _LABEL_7DDAB_ ;Jump back to RAM, if the value is not zero.
	ld a, (_RAM_C8B8_horizontalScrolltitlescrn) ;Get back the value we just saved.
	srl a
	srl a
	and $FE
	ld e, a
	ld d, $00
	ld hl, _DATA_12E0_ 
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld a, (_RAM_C8BA_highscoreNamePosSprite)
	inc a
	ld (_RAM_C8BA_highscoreNamePosSprite), a
	cp $01
	jr nz, +
	ld hl, _DATA_7D720_
	ld bc, $003E
	call _LABEL_7EF_VDPdataLoad
	jp _LABEL_7DDAB_ ;Yeah, update things, and return to RAM.

+:
	cp $02
	jr nz, +
	ld hl, _DATA_7D760_
	ld bc, $003E
	call _LABEL_7EF_VDPdataLoad
	jp _LABEL_7DDAB_

+:
	cp $04
	jp c, _LABEL_7DDAB_
	push de
	ld e, a
	and $01
	jr nz, _LABEL_7DECB_
	ld a, e
	sub $04
	srl a
	cp $09
	jr nz, +
	ld hl, $3031
	ld (_RAM_C376_menuCursorPos), hl
	ld a, $2E
	ld (_RAM_C378_titlescreenvscrolldata?), a
	ld bc, $0303
	jp ++

+:
	add a, $31
	ld (_RAM_C376_menuCursorPos), a
	ld a, $2E
	ld (_RAM_C377_), a
	ld bc, $0203
++:
	ld hl, _RAM_C376_menuCursorPos
	call _LABEL_7DED8_
	ld a, (_RAM_C8BA_highscoreNamePosSprite)
	sub $02
	ld e, a
	ld a, $14
	sub e
	srl a
	add a, a
	add a, a
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, _RAM_C807_lastHiscoreEntryFirstByte
	add hl, de
	ld bc, $0E07
	call _LABEL_7DED8_
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	call _LABEL_91A_plyr1ScoreUpdate?
	ld hl, _RAM_C100_plyr1Score
	ld bc, $0516
	call _LABEL_7DED8_
	ld bc, $011B
	ld a, $30
	ld (_RAM_C376_menuCursorPos), a
	ld hl, _RAM_C376_menuCursorPos
	call _LABEL_7DED8_
	ld hl, _RAM_start
	jp +
;At first, I thought this was used on the title screen, but it's not. This runs at the start of the matches.
_LABEL_7DECB_:
	ld hl, _RAM_C040_ ;Why is this byte sized? Anyways, this does some VDP loading, maybe updates map data or something
	;similar. Can't be tiles, since that should be 64 bytes for two tiles, and it's not palettes, that would be
	;32 bytes for both palettes.
+:
	pop de
	ld bc, $003E ;62 bytes?
	call _LABEL_7EF_VDPdataLoad
	jp _LABEL_7DDAB_ ;Jump back further in RAM. Almost at the beginning.

_LABEL_7DED8_: ;This is used around the high score name entry.
	ld a, c
	add a, a
	ld e, a
	ld d, $C0
	exx
	add a, $40
	ld e, a
	ld d, $C0
	exx
-:
	call +
	inc hl
	djnz -
	ret

+:
	ld a, (hl)
	cp $41
	jr c, +
	sub $41
	add a, $6A
-:
	ld (de), a
	inc de
	ex af, af'
	ld a, $10
	ld (de), a
	ex af, af'
	inc de
	exx
	add a, $28
	ld (de), a
	inc de
	ld a, $10
	ld (de), a
	inc de
	exx
	ret

+:
	cp $20
	jr z, ++
	cp $2E
	jr nz, +
	ld a, $8E
	jp -

+:
	sub $30
	add a, $84
	jp -

++:
	xor a
	ld (de), a
	inc de
	ld a, $10
	ld (de), a
	inc de
	exx
	xor a
	ld (de), a
	inc de
	ld a, $10
	ld (de), a
	inc de
	exx
	ret

; Data from 7DF2C to 7DFFC (209 bytes) ;Nothing really uses this, maybe some garbage data, unused code?
.db $00 $02 $18 $00 $00 $04 $20 $00 $00 $06 $28 $00 $00 $08 $18 $10
.db $00 $0A $20 $10 $00 $0C $28 $10 $00 $0E $18 $20 $00 $10 $20 $20
.db $00 $12 $28 $20 $00 $14 $30 $20 $00 $16 $08 $30 $00 $18 $10 $30
.db $00 $1A $18 $30 $00 $1C $20 $30 $00 $1E $28 $30 $00 $20 $30 $30
.db $00 $22 $38 $30 $00 $24 $00 $40 $00 $26 $08 $40 $00 $28 $10 $40
.db $00 $2A $18 $40 $00 $2C $20 $40 $00 $2E $28 $40 $00 $30 $30 $40
.db $00 $32 $38 $40 $00 $34 $00 $50 $00 $36 $08 $50 $00 $38 $10 $50
.db $00 $3A $18 $50 $00 $3C $20 $50 $00 $3E $28 $50 $00 $40 $30 $50
.db $00 $42 $38 $50 $00 $44 $00 $60 $00 $46 $08 $60 $00 $48 $10 $60
.db $00 $4A $18 $60 $00 $4C $20 $60 $00 $4E $28 $60 $00 $50 $30 $60
.db $00 $52 $38 $60 $00 $54 $08 $70 $00 $56 $10 $70 $00 $58 $18 $70
.db $00 $5A $20 $70 $00 $5C $28 $70 $00 $5E $30 $70 $00 $60 $10 $80
.db $00 $62 $18 $80 $00 $64 $20 $80 $00 $66 $28 $80 $00 $68 $30 $80
.db $40

_LABEL_7DFFD_:;Is this some kind of fade in or out? Used at the Warrior screen.
	push hl
	ld de, _RAM_C020_palTemp 
	ld bc, $0020
	ldir		;Load the two palettes into RAM.
	ld b, $04
---:
	push bc
	ld a, b
	ld hl, _RAM_C020_palTemp
	ld de, _RAM_start
	ld bc, $0020
	ldir			;From one location, copy the palette to the beginning of the RAM.
-:
	push af
	call _LABEL_5D0_delay?
	pop af
	dec a
	jr nz, -
	ld b, $06
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, _RAM_start
	call LOAD_BOTH_PALETTES
	pop bc
	djnz ---
	ld b, $06
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, _RAM_C020_palTemp
	call LOAD_BOTH_PALETTES
	pop hl
	ld (_RAM_C365_paletteTemp), hl
	ret

_LABEL_7E04D_: ;todo
	ld hl, (_RAM_C365_paletteTemp)
	ld de, _RAM_start
	ld bc, $0020
	ldir
	ld b, $04
---:
	push bc
	call _LABEL_5D0_delay?
	ld b, $06
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	ld hl, _RAM_C010_MNEStays
	call _LABEL_547_updateBGPal
	pop bc
	djnz ---
	ret

; Data from 7E076 to 7E095 (32 bytes)
_DATA_7E076_nameEntryPalette: ;This is definetly for some palette loads.
.db $00 $01 $1B $2F $00 $1F $2F $3F $20 $06 $30 $3F $02 $2B $03 $39
.db $00 $01 $1B $2F $00 $1F $2F $3F $20 $06 $30 $3F $02 $2B $03 $39

; Data from 7E096 to 7E115 (128 bytes)
_DATA_7E096_letters?:;In the HEX editor, these are test texts, numbers and letters increasing.
.db $27 $01 $28 $01 $29 $01 $2A $01 $2B $01 $2C $01 $2D $01 $2E $01
.db $2F $01 $29 $01 $30 $01 $31 $01 $32 $01 $33 $01 $34 $01 $30 $01
.db $31 $01 $35 $01 $36 $01 $37 $01 $38 $01 $39 $01 $3A $01 $39 $01
.db $3B $01 $3C $01 $28 $01 $2C $01 $2D $01 $29 $01 $3D $01 $29 $01
.db $3E $01 $3F $01 $29 $01 $40 $01 $41 $01 $42 $01 $43 $01 $44 $01
.db $45 $01 $29 $01 $46 $01 $47 $01 $48 $01 $49 $01 $4A $01 $4B $01
.db $47 $01 $4C $01 $4D $01 $4E $01 $4F $01 $50 $01 $51 $01 $50 $01
.db $52 $01 $3E $01 $53 $01 $42 $01 $43 $01 $29 $01 $54 $01 $29 $01

; Data from 7E116 to 7E615 (1280 bytes)
_DATA_7E116_nameEntryMap:
.incbin "pf_e_DATA_7E116_.inc"

; Data from 7E616 to 7F015 (2560 bytes)
_DATA_7E616_nameEntryTilesMap:
.incbin "pf_e_DATA_7E616_.inc" ;This is the name entry letters and tiles, along with some map data.

; Data from 7F016 to 7F020 (11 bytes)
_DATA_7F016_playerOneString:
.db $50 $4C $41 $59 $45 $52 $20 $4F $4E $45 $2E ;PLAYER ONE

; Data from 7F021 to 7F02B (11 bytes)
_DATA_7F021_playerTwoString:
.db $50 $4C $41 $59 $45 $52 $20 $54 $57 $4F $2E ;PLAYER TWO

; Data from 7F02C to 7F037 (12 bytes)
_DATA_7F02C_iHateEdamString:
.db $49 $20 $48 $41 $54 $45 $20 $45 $44 $41 $4D $00 ;I HATE EDAM

; Data from 7F038 to 7F045 (14 bytes)
_DATA_7F038_iHateLevelString:
.db $49 $20 $48 $41 $54 $45 $20 $4C $45 $56 $45 $4C $20 $00 ;I HATE LEVEL

; Data from 7F046 to 7F053 (14 bytes)
_DATA_7F046_iAmCheatString:
.db $49 $20 $41 $4D $20 $41 $20 $43 $48 $45 $41 $54 $2E $2E ;I AM CHEAT

; Data from 7F054 to 7F062 (15 bytes)
_DATA_7F054_iLuvNintendoString:
.db $49 $20 $4C $55 $56 $20 $4E $49 $4E $54 $45 $4E $44 $4F $00 ;I LUV NINTENDO

; Data from 7F063 to 7F070 (14 bytes)
_DATA_7F063_areYouMadString:
.db $41 $52 $45 $20 $59 $4F $55 $20 $4D $41 $44 $2E $2E $2E ;ARE YOU MAD..

; Data from 7F071 to 7F07F (15 bytes)
_DATA_7F071_marcoFootballString:
.db $4D $41 $52 $43 $4F $20 $46 $4F $4F $54 $42 $41 $4C $4C $00 ;MARCO FOOTBALL

; Data from 7F080 to 7F11F (160 bytes)
_DATA_7F080_cheeseNames:
.db $52 $45 $44 $20 $4C $45 $49 $43 $45 $53 $54 $45 $52 $20 $01 $00 ;RED LEICHESTER
.db $43 $48 $45 $44 $41 $52 $20 $20 $20 $20 $20 $20 $20 $20 $02 $00 ;CHEDAR
.db $42 $4C $55 $45 $20 $44 $41 $4E $49 $53 $48 $20 $20 $20 $03 $00 ;BLUE DANISH
.db $53 $57 $49 $53 $53 $20 $43 $48 $45 $45 $53 $45 $20 $20 $04 $00 ;SWISS CHEESE
.db $53 $54 $49 $4C $54 $4F $4E $20 $20 $20 $20 $20 $20 $20 $05 $00 ;STILTON
.db $43 $41 $4D $45 $4E $42 $45 $52 $54 $20 $20 $20 $20 $20 $06 $00 ;CAMENBERT
.db $42 $52 $49 $45													;BRIE
.dsb 10, $20
.db $07 $00 $43 $4F $54 $54 $41 $47 $45 $20 $43 $48 $45 $45 $53 $45 ;COTTAGE CHEESE
.db $08 $00 $4D $4F $52 $45 $20 $45 $44 $41 $4D $2E $20 $20 $20 $20 ;MORE EDAM
.db $09 $00 $45 $44 $41 $4D $20 $45 $44 $41 $4D $20 $41 $4E $44 $20 ;EDAM EDAM AND
.db $0A $00

_LABEL_7F120_checkEnteredName:
	ld a, (de)
	cp (hl)
	jr nz, ++
	inc hl
	inc de
	ld a, (de)
	or a
	jr z, +
	jr _LABEL_7F120_checkEnteredName

+:
	xor a
	inc a
	ret

++:
	xor a
	ret

_LABEL_7F131_highScoreNameandEasterEggCheck:
	call _LABEL_7DCC0_
	or a
	ret z
	;I guess this is about if you don't have enough to be on the list, just return.
	dec a
	ld (_RAM_C8BE_CanWeMoveTheCursor?), a	;Set this, so we could move the cursor.
	push hl
	call _LABEL_7F1A9_prepareNameEntry
	ld hl, $C8BF
	ld de, _DATA_7F02C_iHateEdamString
	call _LABEL_7F120_checkEnteredName
	jr z, +	;If the easter egg is not triggered, go ahead.
	ld hl, _DATA_7F080_cheeseNames
	ld de, _RAM_C807_lastHiscoreEntryFirstByte
	ld bc, $00A0
	ldir
	pop de
	ret	;If we entered "I hate cheese", then the game will switch high score entries to
	;names of cheese.

+:;This is another easter egg string.
	ld hl, $C8BF
	ld de, _DATA_7F038_iHateLevelString
	call _LABEL_7F120_checkEnteredName
	jr z, ++
	ld a, (_RAM_C8CC_hiscoreLastChar)
	sub $41
	cp $0D
	jr c, +
	xor a
+:
	ld (_RAM_C35A_levelNumberInMenu), a
	ld hl, _DATA_7F046_iAmCheatString
	ld de, _RAM_C8BF_EnteredHighScoreName
	ld bc, $000E
	ldir
++:;Yes, if you enter "I luv nintendo", then the game will mock you. Rightfully so.
	ld hl, $C8BF
	ld de, _DATA_7F054_iLuvNintendoString
	call _LABEL_7F120_checkEnteredName
	jr z, +
	ld hl, _DATA_7F063_areYouMadString
	ld de, _RAM_C8BF_EnteredHighScoreName
	ld bc, $000E
	ldir
+:;And for the last easter egg, if you enter "marco football", then you will be sent to
;a nice slider puzzle game.
	ld hl, $C8BF
	ld de, _DATA_7F071_marcoFootballString
	call _LABEL_7F120_checkEnteredName
	jr z, +;If the string is not for this easter egg, then jump ahead, and enter your
	;boring name, then return.
	jp _LABEL_3C8A_MarkoPuzzleEntry

+:
	pop de
	ld hl, _RAM_C8BF_EnteredHighScoreName
	ld bc, $000E
	ldir
	ld a, $01
	ret

_LABEL_7F1A9_prepareNameEntry:
	di
	xor a
	ld (_RAM_C398_isroundon), a	;This is 01 during matches, and 00 otherwise.
	ld (_RAM_C354_isroundon), a	;Reset these, so we are not in a match.
	ld hl, _LABEL_DFD_titleScreenMainLoop?
	ld (_RAM_C391_pointer?), hl	;Load the title screen's main loop entry point into this pointer.
	call _LABEL_6CD_tilemap_clear
	call _LABEL_737_clearTilesplusfirst256bytes
	ld hl, FULL_BLACK_PALETTE_DATA
	call LOAD_BOTH_PALETTES	;Do some cleanup.
	call _LABEL_1318_nameEntryTileLoad
	ld hl, _DATA_7E096_letters?
	ld de, $3802
	ld bc, $0080	;128 bytes
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_7E116_nameEntryMap
	ld de, $38C2
	ld bc, $0500	;1280 bytes
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_7E616_nameEntryTilesMap
	ld de, $0D40
	ld bc, $0A00	;2560 bytes
	call _LABEL_7EF_VDPdataLoad
	ld hl, _DATA_7551A_NameEntryMusic
	call SelectMusicBank
	ld a, (_RAM_C8BE_CanWeMoveTheCursor?)
	ld hl, _DATA_7F016_playerOneString
	or a
	jr z, +
	ld hl, _DATA_7F021_playerTwoString
+:
	ld bc, $0B0A
	call _LABEL_7DED8_
	ld hl, _RAM_start
	ld de, $3882
	ld bc, $007E
	call _LABEL_7EF_VDPdataLoad
	ei
	ld hl, _DATA_7E076_nameEntryPalette
	call _LABEL_5F5_timer+pal?
	ld hl, $0000
	ld (_RAM_C33B_plyfieldborder), hl
	ld (_RAM_C33D_playFieldBaseHeight), hl
	xor a
	ld (_RAM_C703_spriteDrawNumber?), a
	ld hl, _RAM_C8BF_EnteredHighScoreName
	ld de, _RAM_C8BF_EnteredHighScoreName + 1
	ld bc, $000D
	ld (hl), $20
	ldir
	xor a
	ld (_RAM_C8BA_highscoreNamePosSprite), a
	ld (_RAM_C8B8_horizontalScrolltitlescrn), a
_LABEL_7F236_:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	call _LABEL_7F369_
	ld hl, _RAM_C393_JOYPAD1
	ld a, (_RAM_C8BE_CanWeMoveTheCursor?)
	or a
	jr z, +
	ld hl, _RAM_C394_JOYPAD2
+:
	ld a, (hl)
	or a
	jr nz, +
	ld (_RAM_C3A5_JOYPAD1_2), a
	jp _LABEL_7F236_

+:
	ld e, a
	ld a, (_RAM_C3A5_JOYPAD1_2)
	or a
	jr nz, _LABEL_7F236_
	ld a, $01
	ld (_RAM_C3A5_JOYPAD1_2), a
	ld a, e
	and $01
	jp z, +
	ld a, (_RAM_C8B8_horizontalScrolltitlescrn)
	cp $1D
	jp z, _LABEL_7F236_
	inc a
	ld (_RAM_C8B8_horizontalScrolltitlescrn), a
	jp _LABEL_7F236_

+:
	ld a, e
	and $02
	jr z, +
	ld a, (_RAM_C8B8_horizontalScrolltitlescrn)
	or a
	jr z, _LABEL_7F236_
	dec a
	ld (_RAM_C8B8_horizontalScrolltitlescrn), a
	jp _LABEL_7F236_

+:
	ld a, e
	and $04
	jr z, ++
	ld a, (_RAM_C8B8_horizontalScrolltitlescrn)
	cp $1B
	jp nc, _LABEL_7F236_
	cp $12
	jr nc, +
	add a, $09
	ld (_RAM_C8B8_horizontalScrolltitlescrn), a
	jp _LABEL_7F236_

+:
	sub $12
	ld e, $1B
	cp $03
	jr c, _LABEL_7F2B5_
	ld e, $1C
	cp $06
	jr c, _LABEL_7F2B5_
	ld e, $1D
_LABEL_7F2B5_:
	ld a, e
	ld (_RAM_C8B8_horizontalScrolltitlescrn), a
	jp _LABEL_7F236_

++:
	ld a, e
	and $08
	jr z, ++
	ld a, (_RAM_C8B8_horizontalScrolltitlescrn)
	cp $09
	jp c, _LABEL_7F236_
	cp $1B
	jr nc, +
	sub $09
	ld (_RAM_C8B8_horizontalScrolltitlescrn), a
	jp _LABEL_7F236_

+:
	ld e, $14
	sub $1B
	jr z, _LABEL_7F2B5_
	ld e, $16
	dec a
	jr z, _LABEL_7F2B5_
	ld e, $18
	jp _LABEL_7F2B5_

++:
	ld a, e
	and $30
	jp z, _LABEL_7F236_
	ld a, (_RAM_C8B8_horizontalScrolltitlescrn)
	cp $1B
	jr nz, +
	ld a, (_RAM_C8BA_highscoreNamePosSprite)
	or a
	jp z, _LABEL_7F236_
	dec a
	ld (_RAM_C8BA_highscoreNamePosSprite), a
	ld a, $20
	call _LABEL_7F357_
	jp _LABEL_7F236_

+:
	cp $1D
	jr nz, +
	ld a, $03
	call _LABEL_20F7_fadeoutandStop?
	ld b, $96
--:
	xor a
	ld (_RAM_C3A2_timerml), a
-:
	ld a, (_RAM_C3A2_timerml)
	or a
	jr z, -
	djnz --
	call _LABEL_55C_delay+pal?
	call _LABEL_2103_PSGSilence+Bankswitch
	ret

+:
	ld a, (_RAM_C8BA_highscoreNamePosSprite)
	cp $0E
	jp nz, +
	ld a, $1D
	ld (_RAM_C8B8_horizontalScrolltitlescrn), a
	jp _LABEL_7F236_

+:
	ld a, (_RAM_C8B8_horizontalScrolltitlescrn)
	cp $1C
	jr nz, +
	ld a, $20
-:
	call _LABEL_7F357_
	ld a, (_RAM_C8BA_highscoreNamePosSprite)
	inc a
	ld (_RAM_C8BA_highscoreNamePosSprite), a
	jp _LABEL_7F236_

+:
	cp $1A
	jr nz, +
	ld a, $2E
	jp -

+:
	add a, $41
	jp -

_LABEL_7F357_:
	push hl
	push de
	ex af, af'
	ld a, (_RAM_C8BA_highscoreNamePosSprite)
	ld e, a
	ld d, $00
	ld hl, $C8BF
	add hl, de
	ex af, af'
	ld (hl), a
	pop de
	pop hl
	ret

_LABEL_7F369_:
	ld a, (_RAM_C8BA_highscoreNamePosSprite)
	add a, a
	add a, a
	add a, a
	add a, $48
	ld c, a
	ld b, $37
	ld hl, $B3E0
	call _LABEL_1420_SpriteHandleroutsideMatches
	ld hl, _RAM_C8BF_EnteredHighScoreName
	ld bc, $0E00
	call _LABEL_7DED8_
	ld de, $3912
	ld hl, _RAM_start
	ld bc, $001C
	call _LABEL_7EF_VDPdataLoad
	ld de, $3952
	ld hl, _RAM_C040_
	ld bc, $001C
	call _LABEL_7EF_VDPdataLoad
	ld a, (_RAM_C8B8_horizontalScrolltitlescrn)
	ld b, $47
	cp $09
	jr c, +
	sub $09
	ld b, $67
	cp $09
	jr c, +
	sub $09
	ld b, $87
	cp $09
	jr c, +
	ld hl, $B3E5
	ld bc, $A740
	sub $09
	jp z, _LABEL_1420_SpriteHandleroutsideMatches
	ld hl, $B416
	ld c, $68
	dec a
	jp z, _LABEL_1420_SpriteHandleroutsideMatches
	ld hl, $B3E5
	ld c, $A0
	dec a
	jp _LABEL_1420_SpriteHandleroutsideMatches

+:
	ld e, a
	add a, a
	add a, e
	add a, $03
	add a, a
	add a, a
	add a, a
	ld c, a
	ld hl, $B457
	jp _LABEL_1420_SpriteHandleroutsideMatches
;This isn't used anywhere, but it might be anything, even music too.
; Data from 7F3E0 to 7F47F (160 bytes)
.db $00 $B7 $00 $00 $40 $00 $AC $00 $00 $00 $AD $08 $00 $00 $AE $10
.db $00 $00 $AF $18 $00 $00 $B0 $20 $00 $00 $8F $00 $08 $00 $90 $20
.db $08 $00 $B1 $00 $10 $00 $B2 $08 $10 $00 $B3 $10 $10 $00 $B4 $18
.db $10 $00 $B5 $20 $10 $40 $00 $AC $00 $00 $00 $AD $08 $00 $00 $AE
.db $10 $00 $00 $AE $18 $00 $00 $AE $20 $00 $00 $AF $28 $00 $00 $B0
.db $30 $00 $00 $8F $00 $08 $00 $90 $30 $08 $00 $B1 $00 $10 $00 $B2
.db $08 $10 $00 $B3 $10 $10 $00 $B3 $18 $10 $00 $B3 $20 $10 $00 $B4
.db $28 $10 $00 $B5 $30 $10 $40 $00 $84 $00 $00 $00 $85 $08 $00 $00
.db $86 $10 $00 $00 $87 $00 $08 $00 $88 $10 $08 $00 $89 $00 $10 $00
.db $8A $10 $10 $00 $8B $00 $18 $00 $8C $08 $18 $00 $8D $10 $18 $40

; Data from 7F480 to 7F806 (903 bytes)
_DATA_ram_w_highscores:
.dsb 518, $00
.db $FF $FF $FF $FF $00 $0F $00 $02
.dsb 296, $00
.db $0A $C1
.dsb 32, $00
.db $02 $00 $00 $00 $00 $01 $00 $00 $01 $01 $51 $00 $30 $10 $05 $00
.db $00 $00 $00 $00 $00 $01 $00 $00 $00 $00 $00 $00 $64 $64
.dsb 17, $00

; Executed in RAM at 387
_LABEL_7F807_:
	push af
; Executed in RAM at 388
_LABEL_7F808_:
	in a, (Port_IOPort2)
; Executed in RAM at 38a
_LABEL_7F80A_:
	and $10
; Executed in RAM at 38c
_LABEL_7F80C_:
	jp z, INIT_VDP
; Executed in RAM at 38f
_LABEL_7F80F_:
	pop af
; Executed in RAM at 390
_LABEL_7F810_:
	jp _RAM_C5C0_ramCodePointer1	; Code is loaded from _LABEL_7FA40_
;This is also not referenced anywhere, and should be okay to use for something else.
; Data from 7F813 to 7FA3F (557 bytes)
.dsb 17, $00
.db $01 $00 $00 $00 $00 $00 $00 $22 $EE $DF $3A $07 $00 $B7 $C2 $00
.db $04 $FB $CD $60 $04 $21 $00 $00 $11 $00 $C0 $01 $60 $04 $ED $B0
.db $F3 $C3 $C8 $C3 $3E $82 $32 $FF $FF $11 $00 $00 $D9 $2A $23 $00
.db $D9 $21 $00 $C0 $01 $B5 $03 $ED $B0 $FB $D9 $22 $23 $00 $D9 $2A
.db $23 $00 $11 $CD $AB $A7 $ED $52 $28 $22 $3E $82 $32 $FF $FF $21
.db $00 $80 $11 $01 $80 $01 $FF $3F $75 $ED $B0 $21
.dsb 26, $00
.db $80 $F5 $32 $FF $FF $4E $36 $AA $34 $00 $7E $FE $AB $20 $15 $71
.db $F1 $3C $FE $A0 $20 $EB $3E $82 $32 $FF $FF $21 $E9 $06 $CD $47
.db $C4 $C3 $D7 $00 $F1 $21 $17 $07 $CD $47 $C4 $18 $E9 $08 $D9 $3A
.db $FF $FF $F5 $3E $02 $32 $FF $FF $11 $59 $C4 $D5 $D9 $08 $E9 $08
.db $F1 $32 $FF $FF $08 $C9 $0F $0F $0D $0F $0F $0F $0D $0F $0F $0F
.db $0D $0F $0F $0F $0D $0F $0F $0F $0D $0F $0F $0D $0D $2F $0F $0F
.db $0F $0F $0F $0F $0F $02 $F0 $00 $F0 $F0 $F0 $F0 $F0 $F0 $F0 $C0
.db $C0 $F0 $F0 $C0 $C0 $F0 $F0 $C0 $C0
.dsb 18, $F0
.db $D0 $D0 $F0 $F0 $F0 $D0 $F0 $F0 $D0 $D0 $F0 $F0 $F0 $D0 $F0 $F0
.db $D0 $D0 $F0 $F0 $F0 $D0 $F0 $F0 $C0 $D0 $F0 $0F $0F $0C $0F $0F
.db $0F $0C $0F $0F $0F $0D $0F $0F $0B $0D $0F $0F $0F $0D $0F $0F
.db $09 $0D $0F $8F $09 $00 $2F $0F $0F $0F $0F $0F $0F $0D
.dsb 28, $0F
.db $FF
.dsb 192, $00

; Executed in RAM at 5c0
_LABEL_7FA40_:
	push af
; Executed in RAM at 5c1
_LABEL_7FA41_:
	in a, (Port_VDPStatus)
; Executed in RAM at 5c3
_LABEL_7FA43_:
	ld ($C39C), a
; Executed in RAM at 5c6
_LABEL_7FA46_:
	rla
; Executed in RAM at 5c7
_LABEL_7FA47_:
	jp nc, _RAM_C676_	; Code is loaded from _LABEL_7FAF6_
; Executed in RAM at 5ca
_LABEL_7FA4A_:
	ex af, af'
; Executed in RAM at 5cb
_LABEL_7FA4B_:
	push af
; Executed in RAM at 5cc
_LABEL_7FA4C_:
	push bc
; Executed in RAM at 5cd
_LABEL_7FA4D_:
	push de
; Executed in RAM at 5ce
_LABEL_7FA4E_:
	push hl
; Executed in RAM at 5cf
_LABEL_7FA4F_:
	push ix
; Executed in RAM at 5d1
_LABEL_7FA51_:
	push iy
; Executed in RAM at 5d3
_LABEL_7FA53_:
	ld a, ($C350)
; Executed in RAM at 5d6
_LABEL_7FA56_:
	or a
; Executed in RAM at 5d7
_LABEL_7FA57_:
	jr z, _LABEL_7FA7B_
; Executed in RAM at 5d9
_LABEL_7FA59_:
	ld a, $00
; Executed in RAM at 5db
_LABEL_7FA5B_:
	out (Port_VDPAddressControlPort), a
; Executed in RAM at 5dd
_LABEL_7FA5D_:
	nop
; Executed in RAM at 5de
_LABEL_7FA5E_:
	nop
; Executed in RAM at 5df
_LABEL_7FA5F_:
	nop
; Executed in RAM at 5e0
_LABEL_7FA60_:
	ld a, $88
; Executed in RAM at 5e2
_LABEL_7FA62_:
	out (Port_VDPAddressControlPort), a
; Executed in RAM at 5e4
_LABEL_7FA64_:
	nop
; Executed in RAM at 5e5
_LABEL_7FA65_:
	nop
; Executed in RAM at 5e6
_LABEL_7FA66_:
	ld a, ($C34F)
; Executed in RAM at 5e9
_LABEL_7FA69_:
	or a
; Executed in RAM at 5ea
_LABEL_7FA6A_:
	jr z, _LABEL_7FA70_
; Executed in RAM at 5ec
_LABEL_7FA6C_:
	dec a
; Executed in RAM at 5ed
_LABEL_7FA6D_:
	ld ($C34F), a
; Executed in RAM at 5f0
_LABEL_7FA70_:
	out (Port_VDPAddressControlPort), a
; Executed in RAM at 5f2
_LABEL_7FA72_:
	nop
; Executed in RAM at 5f3
_LABEL_7FA73_:
	nop
; Executed in RAM at 5f4
_LABEL_7FA74_:
	nop
; Executed in RAM at 5f5
_LABEL_7FA75_:
	ld a, $89
; Executed in RAM at 5f7
_LABEL_7FA77_:
	out (Port_VDPAddressControlPort), a
; Executed in RAM at 5f9
_LABEL_7FA79_:
	nop
; Executed in RAM at 5fa
_LABEL_7FA7A_:
	nop
; Executed in RAM at 5fb
_LABEL_7FA7B_:
	ld a, ($C342)
; Executed in RAM at 5fe
_LABEL_7FA7E_:
	or a
; Executed in RAM at 5ff
_LABEL_7FA7F_:
	jp nz, _RAM_C665_	; Code is loaded from _LABEL_7FAE5_
; Executed in RAM at 602
_LABEL_7FA82_:
	ld a, ($C35E)
; Executed in RAM at 605
_LABEL_7FA85_:
	or a
; Executed in RAM at 606
_LABEL_7FA86_:
	jr nz, _LABEL_7FA8E_
; Executed in RAM at 608
_LABEL_7FA88_:
	ld e, $18
; Executed in RAM at 60a
_LABEL_7FA8A_bankswitch:
	rst $18	; MAPPER_PAGE2_SUB
; Executed in RAM at 60b
_LABEL_7FA8B_:
	call _LABEL_63780_playSoundEffect
; Executed in RAM at 60e
_LABEL_7FA8E_:
	ld a, ($C398)
; Executed in RAM at 611
_LABEL_7FA91_:
	or a
; Executed in RAM at 612
_LABEL_7FA92_:
	jp z, _RAM_C64A_	; Code is loaded from _LABEL_7FACA_
; Executed in RAM at 615
_LABEL_7FA95_:
	ld a, ($C39B)
; Executed in RAM at 618
_LABEL_7FA98_:
	inc a
; Executed in RAM at 619
_LABEL_7FA99_:
	cp $32
; Executed in RAM at 61b
_LABEL_7FA9B_:
	jr nz, _LABEL_7FAC7_
; Executed in RAM at 61d
_LABEL_7FA9D_:
	ld a, ($C39A)
; Executed in RAM at 620
_LABEL_7FAA0_:
	inc a
; Executed in RAM at 621
_LABEL_7FAA1_:
	cp $3C
; Executed in RAM at 623
_LABEL_7FAA3_:
	jr nz, _LABEL_7FAB8_
; Executed in RAM at 625
_LABEL_7FAA5_:
	ld a, ($C399)
; Executed in RAM at 628
_LABEL_7FAA8_:
	inc a
; Executed in RAM at 629
_LABEL_7FAA9_:
	ld ($C399), a
; Executed in RAM at 62c
_LABEL_7FAAC_:
	ld l, a
; Executed in RAM at 62d
_LABEL_7FAAD_:
	ld h, $00
; Executed in RAM at 62f
_LABEL_7FAAF_:
	ld bc, $010E
; Executed in RAM at 632
_LABEL_7FAB2_:
	ld a, $04
; Executed in RAM at 634
_LABEL_7FAB4_:
	call _LABEL_966_plyrScore
; Executed in RAM at 637
_LABEL_7FAB7_:
	xor a
; Executed in RAM at 638
_LABEL_7FAB8_:
	ld ($C39A), a
; Executed in RAM at 63b
_LABEL_7FABB_:
	ld l, a
; Executed in RAM at 63c
_LABEL_7FABC_:
	ld h, $00
; Executed in RAM at 63e
_LABEL_7FABE_:
	ld bc, $0110
; Executed in RAM at 641
_LABEL_7FAC1_:
	ld a, $03
; Executed in RAM at 643
_LABEL_7FAC3_:
	call _LABEL_966_plyrScore
; Executed in RAM at 646
_LABEL_7FAC6_:
	xor a
; Executed in RAM at 647
_LABEL_7FAC7_:
	ld ($C39B), a
; Executed in RAM at 64a
_LABEL_7FACA_:
	call _LABEL_8CD_READ_JOYPAD
; Executed in RAM at 64d
_LABEL_7FACD_:
	ld e, $0B
; Executed in RAM at 64f
_LABEL_7FACF_bankswitch:
	rst $18	; MAPPER_PAGE2_SUB Bank 11.
; Executed in RAM at 650
_LABEL_7FAD0_:
	ld a, ($C39E)
; Executed in RAM at 653
_LABEL_7FAD3_:
	inc a
; Executed in RAM at 654
_LABEL_7FAD4_:
	ld ($C39E), a
; Executed in RAM at 657
_LABEL_7FAD7_:
	and $01
; Executed in RAM at 659
_LABEL_7FAD9_:
	jr nz, _LABEL_7FAE2_
; Executed in RAM at 65b
_LABEL_7FADB_:
	ld a, ($C3A0)
; Executed in RAM at 65e
_LABEL_7FADE_:
	inc a
; Executed in RAM at 65f
_LABEL_7FADF_:
	ld ($C3A0), a
; Executed in RAM at 662
_LABEL_7FAE2_:
	call _LABEL_B00_spriteHandler?
; Executed in RAM at 665
_LABEL_7FAE5_:
	ld a, $01
; Executed in RAM at 667
_LABEL_7FAE7_:
	ld ($C3A2), a
; Executed in RAM at 66a
_LABEL_7FAEA_:
	pop iy
; Executed in RAM at 66c
_LABEL_7FAEC_:
	pop ix
; Executed in RAM at 66e
_LABEL_7FAEE_:
	pop hl
; Executed in RAM at 66f
_LABEL_7FAEF_:
	pop de
; Executed in RAM at 670
_LABEL_7FAF0_:
	pop bc
; Executed in RAM at 671
_LABEL_7FAF1_:
	pop af
; Executed in RAM at 672
_LABEL_7FAF2_:
	ex af, af'
; Executed in RAM at 673
_LABEL_7FAF3_:
	pop af
; Executed in RAM at 674
_LABEL_7FAF4_:
	ei
; Executed in RAM at 675
_LABEL_7FAF5_:
	ret

; Executed in RAM at 676
_LABEL_7FAF6_:
	and $C0
; Executed in RAM at 678
_LABEL_7FAF8_:
	or a
; Executed in RAM at 679
_LABEL_7FAF9_:
	jp nz, _RAM_C6CA_	; Code is loaded from _LABEL_7FB4A_
; Executed in RAM at 67c
_LABEL_7FAFC_:
	ld a, ($C354)
; Executed in RAM at 67f
_LABEL_7FAFF_:
	or a
; Executed in RAM at 680
_LABEL_7FB00_:
	jp z, _RAM_C6CA_	; Code is loaded from _LABEL_7FB4A_
; Executed in RAM at 683
_LABEL_7FB03_:
	in a, (Port_VCounter)
; Executed in RAM at 685
_LABEL_7FB05_:
	cp $1F
; Executed in RAM at 687
_LABEL_7FB07_:
	jp nz, _RAM_C6CA_	; Code is loaded from _LABEL_7FB4A_
; Executed in RAM at 68a
_LABEL_7FB0A_:
	ld a, ($C34E)
; Executed in RAM at 68d
_LABEL_7FB0D_:
	out (Port_VDPAddressControlPort), a
; Executed in RAM at 68f
_LABEL_7FB0F_:
	nop
; Executed in RAM at 690
_LABEL_7FB10_:
	nop
; Executed in RAM at 691
_LABEL_7FB11_:
	nop
; Executed in RAM at 692
_LABEL_7FB12_:
	nop
; Executed in RAM at 693
_LABEL_7FB13_:
	ld a, $88
; Executed in RAM at 695
_LABEL_7FB15_:
	out (Port_VDPAddressControlPort), a
; Executed in RAM at 697
_LABEL_7FB17_:
	push hl
; Executed in RAM at 698
_LABEL_7FB18_:
	push bc
; Executed in RAM at 699
_LABEL_7FB19_:
	push de
; Executed in RAM at 69a
_LABEL_7FB1A_:
	ex af, af'
; Executed in RAM at 69b
_LABEL_7FB1B_:
	push af
; Executed in RAM at 69c
_LABEL_7FB1C_:
	call _LABEL_13F4_pauseRelated?
; Executed in RAM at 69f
_LABEL_7FB1F_:
	ld a, ($C342)
; Executed in RAM at 6a2
_LABEL_7FB22_:
	or a
; Executed in RAM at 6a3
_LABEL_7FB23_:
	jr nz, _LABEL_7FB45_
; Executed in RAM at 6a5
_LABEL_7FB25_:
	ld a, ($C36F)
; Executed in RAM at 6a8
_LABEL_7FB28_:
	or a
; Executed in RAM at 6a9
_LABEL_7FB29_:
	jr z, _LABEL_7FB39_
; Executed in RAM at 6ab
_LABEL_7FB2B_:
	dec a
; Executed in RAM at 6ac
_LABEL_7FB2C_:
	ld ($C36F), a
; Executed in RAM at 6af
_LABEL_7FB2F_:
	cp $02
; Executed in RAM at 6b1
_LABEL_7FB31_:
	jr c, _LABEL_7FB45_
; Executed in RAM at 6b3
_LABEL_7FB33_:
	call _LABEL_3332_updateAndSetScrollRight
; Executed in RAM at 6b6
_LABEL_7FB36_:
	jp _RAM_C6C5_	; Code is loaded from _LABEL_7FB45_

; Executed in RAM at 6b9
_LABEL_7FB39_:
	call _LABEL_3CEF_
; Executed in RAM at 6bc
_LABEL_7FB3C_:
	call _LABEL_17A2_playerAnimations?
; Executed in RAM at 6bf
_LABEL_7FB3F_:
	call _LABEL_132B_playerPositionAnimation
; Executed in RAM at 6c2
_LABEL_7FB42_:
	call _LABEL_4A40_
; Executed in RAM at 6c5
_LABEL_7FB45_:
	pop af
; Executed in RAM at 6c6
_LABEL_7FB46_:
	ex af, af'
; Executed in RAM at 6c7
_LABEL_7FB47_:
	pop de
; Executed in RAM at 6c8
_LABEL_7FB48_:
	pop bc
; Executed in RAM at 6c9
_LABEL_7FB49_:
	pop hl
; Executed in RAM at 6ca
_LABEL_7FB4A_:
	pop af
; Executed in RAM at 6cb
_LABEL_7FB4B_:
	ei
; Executed in RAM at 6cc
_LABEL_7FB4C_:
	ret
;This below is not used at all, and not referenced by anything. So we have over a kilobyte of space to
;add code and mess around, so it could be a remnant of something, or just junk data.
; Data from 7FB4D to 7FFFF (1203 bytes)
_unused_7fb4d:
.dsb 50, $00
.db $01
.dsb 247, $00
.dsb 14, $2D
.db $00 $00 $20 $20 $20 $4A $49 $4D $20 $20 $50 $49 $4E $20 $20 $20
.db $F4 $01 $43 $4F $4C $49 $4E $20 $42 $4F $5A $57 $49 $42 $4C $45
.db $70 $17 $52 $55 $53 $53 $45 $4C $20 $46 $45 $52 $52 $49 $45 $52
.db $58 $1B $49 $4E $44 $52 $41 $20 $20 $4A $41 $43 $4B $53 $4F $4E
.db $40 $1F $20 $57 $41 $52 $52 $45 $4E $20 $4D $49 $4C $4C $53 $20
.db $28 $23 $20 $20 $4D $41 $54 $54 $20 $48 $49 $43 $4B $53 $20 $20
.db $10 $27 $20 $41 $4E $44 $59 $20 $20 $54 $41 $59 $4C $4F $52 $20
.db $20 $4E $41 $52 $45 $20 $59 $4F $55 $20 $54 $4F $55 $47 $48 $2E
.db $30 $75 $53 $48 $4F $57 $20 $4E $4F $20 $4D $45 $52 $43 $59 $2E
.db $40 $9C $20 $50 $49 $54 $20 $20 $46 $49 $47 $48 $54 $45 $52 $20
.db $50 $C3
.dsb 14, $5A
.db $FF $FF $00 $00 $00 $00 $00 $00 $00 $00 $41 $42 $43 $44 $45 $46
.db $47 $48 $49 $4A $4B $2E $20 $57 $00 $00 $00 $00
.dsb 10, $01
.db $02 $03 $00 $01 $01 $01 $01 $04 $05 $06 $07 $01 $01 $01 $01 $08
.db $09 $0A $0B $01 $01 $01 $01 $0C $0D $0E $0F
.dsb 11, $01
.dsb 17, $00
.db $03 $EF $02 $DE $02 $BC $81 $DE $03 $EF $02 $F7 $02 $7B $04 $00
.db $02 $80 $02 $C0 $03 $0F $81 $00 $03 $0F $81 $00 $03 $FF $81 $00
.db $03 $FF $91 $00 $FB $FB $F7 $0F $FF $FE $F8 $00 $BB $BB $BD $9E
.db $1F $0F $03 $00 $03 $FD $81 $01 $03 $FC $8D $00 $DF $DF $EF $F0
.db $FF $FF $3F $00 $FE $FE $FD $03 $03 $FF $82 $00 $E7 $03 $EF $03
.db $FE $8D $00 $BF $7F $7F $78 $FB $F3 $F3 $00 $FB $FD $FD $01 $03
.db $FD $82 $00 $C0 $03 $E7 $03 $F0 $81 $00 $00 $7F $00 $7F $00 $62
.db $00 $00 $7F $00 $7F $00 $62 $00 $00 $F0 $F0 $C0 $C0 $F0 $F0 $C0
.db $C0
.dsb 45, $F0
.db $0F $0F $0D $0F
.dsb 444, $00

