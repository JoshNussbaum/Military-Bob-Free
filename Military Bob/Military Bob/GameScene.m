//  GameScene.m
//  Military Bob
//  Created by Josh on 10/1/14.

#import "GameScene.h"
#import "Hero.h"
#import "WorldGenerator.h"
#import "PointsLabel.h"
#import "GameData.h"
#import "math.h"
#import "CustomProgressBar.h"
#import "GameKitHelper.h"
#import "GameViewController.h"
@import AVFoundation;

@interface GameScene ()

@property BOOL isStarted;
@property BOOL isGameOver;
@property BOOL isAngleSet;
@property BOOL isPowerSet;
@property BOOL touchBegan;
@property BOOL usedJetPack;
@property BOOL usingJetPack;
@property BOOL usedGun;
@property BOOL usedIce;
@property BOOL usingIce;
@property BOOL reported;
@property BOOL isPaused;
@property BOOL ssBoost;
@property BOOL soundDisabled;
@property BOOL menuShowing;
@property BOOL powerGoing;

@property BOOL a_10k;
@property BOOL a_50k;
@property BOOL a_100k;
@property BOOL a_200k;
@property BOOL a_300k;
@property BOOL a_500k;
@property BOOL a_gun;
@property BOOL a_pack;
@property BOOL a_doppel;

@property BOOL l_1;
@property BOOL l_2;
@property BOOL l_3;
@property BOOL l_4;
@property BOOL l_5;
@property BOOL l_6;

@property BOOL g_1;
@property BOOL g_2;
@property BOOL g_3;
@property BOOL g_4;

@property BOOL j_1;
@property BOOL j_2;
@property BOOL j_3;
@property BOOL j_4;

@end

static const uint32_t groundCategory = 0x1 << 1;
static const uint32_t obstacleCategory1 = 0x1 << 2;
static const uint32_t obstacleCategory2 = 0x1 << 3;
static const uint32_t obstacleCategory3 = 0x1 << 4;
static const uint32_t obstacleCategory4 = 0x1 << 5;
static const uint32_t obstacleCategory5 = 0x1 << 6;
static const uint32_t obstacleCategory6 = 0x1 << 7;
static const uint32_t obstacleCategory7 = 0x1 << 8;
static const uint32_t obstacleCategory8 = 0x1 << 9;

static NSString *GAME_FONT = @"AmericanTypewriter-Bold";
static double fireAngle;
static float multiplier;
static dispatch_queue_t backgroundQueue;
static int i;
static int power;
static int gunHits;
static int packHits;
static int phoneType;
static int loadCount;
static NSInteger totalGun;
static NSInteger totalJetpack;
static NSInteger totalLaunches;
static NSInteger highScore;
static NSInteger finalDistance;

/* TO DO :
 
 FLURRY ANALYTICS FOR FREE VERSION
 
 Make spikes smaller and make ICE spawn more frequently
 
 Make old bob into a treasure chest
 
 Add some achievement for ICE ICE BABY
 
 Make Home Screen with Campaign, Arcade, Tutorial, Credits
 
 IN THE FUTURE:
 Make coins COINS COINS
 
 Make Military Bob Pay to Win. Make tons of activatables you can buy with gold or money.
 You get gold from completing the campaign. You also have daily arcade challenges that give you gold
 You can also buy gold
 Gold buys you activatables to use in the arcade.
 
 Gold can also buy you access to certain maps, where you have certain number of tries to beat them and get more gold
 Gold can get you stuff in campaign too.
 
 
 MAKE YOU GET SOME CURRENCY BASED ON DISTANCE WHEN GAME IS OVER
 YOU CAN BUY SOME ACTIVATABLES THAT GIVE U ACHIEVEMENT (THATS HOW WE KEEP TRACK OF IF U HAVE IT)
 
 
 */


@implementation GameScene{
    
    SKNode *world;
    SKSpriteNode *tank;
    SKSpriteNode *barrel;
    Hero *hero;
    WorldGenerator *generator;
    CustomProgressBar * progressBar;
    SKLabelNode *tapToBeginLabel;
    SKLabelNode *angleLabel;
    SKLabelNode *distanceLabel;
    SKSpriteNode *distanceBubble;
    SKTexture *heroNormal;
    SKTexture *heroJetPack;
    SKTexture *heroFrozen;
    
    SKSpriteNode *restartNode;
    SKSpriteNode *pauseNode;
    
    SKSpriteNode *menuNode;
    SKSpriteNode *menuBox;
    
    SKSpriteNode *soundOn;
    SKSpriteNode *soundOff;
    
    SKSpriteNode *rifleBox;
    SKSpriteNode *jetPackBox;
    SKSpriteNode *iceBox;
    
    SKAction *barrelSound;
    SKAction *fireSound;
    SKAction *groundSound;
    SKAction *grenadeSound;
    SKAction *bounceSound;
    SKAction *spikesSound;
    SKAction *volcanoSound;
    SKAction *ammoSound;
    SKAction *gunSound;
    SKAction *jetpackSound;
    SKAction *iceSound;
    AVAudioPlayer *backgroundMusic;
    AVAudioPlayer *backgroundMusic2;
    AVAudioPlayer *backgroundMusic3;
    NSTimer *timer;
    CGVector heroVelocity;
    
}

/***~~  Set Up Scene  ~~***/

-(void)didMoveToView:(SKView *)view {
    loadCount = 0;
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.physicsWorld.contactDelegate = self;
    _touchBegan = NO;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float height = screenSize.width;
    if (height == 480)
    {
        phoneType = 0;
    }
    else if (height == 568)
    {
        phoneType = 1;
        
    }
    else if (height == 667)
    {
        phoneType = 2;
    }
    else if (height == 736)
    {
        phoneType = 3;
    }
    [self createContent];
    [self loadAchievements];
}

-(void)createContent {
    
    self.backgroundColor= [SKColor colorWithRed:.54 green:.7853 blue:1.0 alpha:1.0];
    world = [SKNode node];
    [self addChild:world];
    
    generator = [WorldGenerator generatorWithWorld:world];
    [self addChild:generator];
    [generator populate];
    
    
    // Set up Tank
    tank = [SKSpriteNode spriteNodeWithImageNamed:@"tank.png"];
    CGPoint tankPos;
    if (phoneType == 0){
        tankPos = CGPointMake(-self.frame.size.width/2 + tank.frame.size.width/2 + 45, tank.position.y- self.view.frame.size.height/2 - 10);
    }
    else if (phoneType == 1){
        tankPos = CGPointMake(-self.frame.size.width/2 + tank.frame.size.width/2 + 60, tank.position.y- self.view.frame.size.height/2 );
    }
    else if (phoneType == 2){
        tankPos = CGPointMake(-self.frame.size.width/2 + tank.frame.size.width/2 + 45, tank.position.y- self.view.frame.size.height/2 + 20);
    }
    else if (phoneType == 3){
        tankPos = CGPointMake(-self.frame.size.width/2 + tank.frame.size.width/2 + 45, tank.position.y- self.view.frame.size.height/2 + 35);
    }
    else tankPos = CGPointMake(-self.frame.size.width/2 + tank.frame.size.width/2 + 45, tank.position.y- self.view.frame.size.height/2 - 10);
    tank.position = tankPos;
    tank.name=@"hero";
    
    barrel = [SKSpriteNode spriteNodeWithImageNamed:@"barrel.png"];
    barrel.name = @"barrel";
    CGPoint barrelPos;
    if(phoneType == 0){
        barrelPos = CGPointMake(barrel.position.x + 30, barrel.position.y - self.view.frame.size.height/2 - 15);
    }
    else if (phoneType == 1){
        barrelPos = CGPointMake(barrel.position.x + 42, barrel.position.y - self.view.frame.size.height/2 - 2);
    }
    else if (phoneType == 2){
        barrelPos = CGPointMake(barrel.position.x + 27, barrel.position.y - self.view.frame.size.height/2  + 20);
    }
    else if (phoneType == 3){
        barrelPos = CGPointMake(barrel.position.x + 27, barrel.position.y - self.view.frame.size.height/2 + 35);
    }
    else {
        barrelPos = CGPointMake(barrel.position.x + 27, barrel.position.y - self.view.frame.size.height/2 - 2);
    }
    barrel.position = barrelPos;
    fireAngle = 0;
    
    hero = [Hero hero];
    hero.zPosition = 1.0;
    hero.position = CGPointMake(barrel.position.x + barrel.frame.size.width/4, barrel.position.y + barrel.frame.size.height/4);
    [world addChild:barrel];
    
    SKSpriteNode *fireNode = [SKSpriteNode spriteNodeWithImageNamed:@"fire.png"];
    
    CGPoint fireButtonPos;
    
    if (phoneType == 0){
        fireButtonPos = CGPointMake(43 -tank.frame.size.width/4, -self.view.frame.size.height/2 - 15);
    }
    else if (phoneType == 1){
        fireButtonPos = CGPointMake(60-tank.frame.size.width/4, -self.view.frame.size.height/2 - 6);
    }
    else if (phoneType == 2){
        fireButtonPos = CGPointMake(42-tank.frame.size.width/4, -self.view.frame.size.height/2 + 15);
    }
    else if (phoneType == 3){
        fireButtonPos = CGPointMake(47 -tank.frame.size.width/4, -self.view.frame.size.height/2 + 30);
    }
    
    fireNode.position = fireButtonPos;
    fireNode.name=@"fireButtonNode";
    fireNode.zPosition = 6.0;
    
    [world addChild:tank];
    [world addChild:hero];
    [world addChild:fireNode];
    [self loadSounds];
    [self loadScoreLabels];
    [self loadActivatables];
    [self loadLabels];
    
}

-(void)loadLabels {
    progressBar = [CustomProgressBar new];
    progressBar.position = CGPointMake(-85, 20);
    progressBar.hidden = YES;
    [self addChild:progressBar];
    
    
    tapToBeginLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToBeginLabel.name=@"tapToBeginLabel";
    tapToBeginLabel.text =@"fire to begin";
    tapToBeginLabel.fontColor = [UIColor blackColor];
    
    tapToBeginLabel.fontSize=32.0;
    tapToBeginLabel.position=CGPointMake(20, 80);
    [self addChild:tapToBeginLabel];
    [self animateWithPulse:tapToBeginLabel];
    
    
    distanceLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    distanceLabel.name=@"distanceLabel";
    distanceLabel.text =@"10 ft";
    distanceLabel.fontSize=24.0;
    
    distanceBubble = [[SKSpriteNode alloc]initWithImageNamed:@"distanceBubble.png"];
    
    CGPoint distancePos;
    if (phoneType == 0){
        distancePos = CGPointMake(0, self.view.frame.size.height/1.3 + 10);
    }
    else if (phoneType == 1){
        distancePos = CGPointMake(0, self.view.frame.size.height/1.3 - 20);
    }
    else if (phoneType == 2){
        distancePos = CGPointMake(0, self.view.frame.size.height/1.3 - 65);
    }
    else if (phoneType == 3){
        distancePos = CGPointMake(0, self.view.frame.size.height/1.3 - 100);
    }
    else {
        CGPointMake(0, self.view.frame.size.height/1.3 - 25);
    }
    distanceBubble.position = distancePos;
    distanceBubble.hidden = YES;
    distanceBubble.zPosition = 2.0;
    [self addChild:distanceBubble];
    
    distanceLabel.position = CGPointMake(0, -20);
    distanceLabel.fontColor = [UIColor blackColor];
    distanceLabel.zPosition = 3.0;
    [distanceBubble addChild:distanceLabel];
    
    restartNode = [[SKSpriteNode alloc]initWithImageNamed:@"reset.png"];
    
    
    CGPoint restartPos;
    if (phoneType == 0){
        restartPos = CGPointMake(-self.view.frame.size.width/2 - 180, self.view.frame.size.height/2 + 110);
    }
    else if (phoneType == 1){
        restartPos = CGPointMake(-self.view.frame.size.width/2 - 145, self.view.frame.size.height/2 + 74);
    }
    else if (phoneType == 2){
        restartPos = CGPointMake(-self.view.frame.size.width/2 - 96, self.view.frame.size.height/2 + 46);
    }
    else if (phoneType == 3){
        restartPos = CGPointMake(-self.view.frame.size.width/2 - 55, self.view.frame.size.height/2 + 19);
    }
    else {
        restartPos = CGPointMake(-self.view.frame.size.width/2 - 150, self.view.frame.size.height/2 + 80);
    }
    
    restartNode.position = restartPos;
    restartNode.name = @"restartNode";
    restartNode.hidden = NO;
    restartNode.zPosition = 5.0;
    
    angleLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    angleLabel.name=@"angleLabel";
    NSString *angle =[NSString stringWithFormat:@"%.02f", fireAngle * 180/M_PI];
    angleLabel.text= angle;
    angleLabel.fontSize=24.0;
    angleLabel.fontColor = [UIColor blackColor];
    angleLabel.position=CGPointMake(30, 180);
    [tank addChild:angleLabel];
    
    
    CGPoint menuPos;
    float titleLabelsOffset = 0;
    if (phoneType == 0){
        menuPos = CGPointMake(-self.view.frame.size.width/2 - 180, self.view.frame.size.height/2 + 110);
    }
    else if (phoneType == 1){
        menuPos = CGPointMake(-self.view.frame.size.width/2 - 145, self.view.frame.size.height/2 + 74);
    }
    else if (phoneType == 2){
        menuPos = CGPointMake(-self.view.frame.size.width/2 - 96, self.view.frame.size.height/2 + 46);
    }
    else if (phoneType == 3){
        menuPos = CGPointMake(-self.view.frame.size.width/2 - 55, self.view.frame.size.height/2 + 19);
        titleLabelsOffset = 20;
    }
    else {
        menuPos = CGPointMake(-self.view.frame.size.width/2 - 150, self.view.frame.size.height/2 + 80);
    }
    
    
    menuNode = [[SKSpriteNode alloc]initWithImageNamed:@"menu.png"];
    menuNode.position = menuPos;
    menuNode.name = @"menuNode";
    menuNode.zPosition = 5.0;
    
    menuBox = [[SKSpriteNode alloc] initWithImageNamed:@"menuBox.png"];
    menuBox.name=@"menuBox";
    menuBox.zPosition = 12.0;
    
    SKLabelNode *menuTitle = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    menuTitle.name=@"closeNode";
    menuTitle.text = @"Menu";
    
    menuTitle.position = CGPointMake(0, self.view.frame.size.height/2 - 15 - titleLabelsOffset);
    menuTitle.fontSize = 42.0;
    
    SKLabelNode *tutorialLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tutorialLabel.name = @"tutorialNode";
    tutorialLabel.text = @"Tutorial";
    tutorialLabel.fontSize = 38.0;
    tutorialLabel.position = CGPointMake(0, self.view.frame.size.height/2 - 100 - titleLabelsOffset);
    
    SKLabelNode *leaderLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    leaderLabel.name = @"leaderNode";
    leaderLabel.text = @"Leaderboard";
    leaderLabel.fontSize = 38.0;
    leaderLabel.position = CGPointMake(0, self.view.frame.size.height/2 - 170 - titleLabelsOffset);
    
    SKLabelNode *achievementsLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    achievementsLabel.name = @"achievementsNode";
    achievementsLabel.text = @"Achievements";
    achievementsLabel.fontSize = 38.0;
    achievementsLabel.position = CGPointMake(0, self.view.frame.size.height/2 - 240 - titleLabelsOffset);
    
    SKLabelNode *closeLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    closeLabel.name = @"closeNode";
    closeLabel.text = @"Close";
    closeLabel.fontSize = 42.0;
    closeLabel.position = CGPointMake(0, self.view.frame.size.height/2 - 335 - titleLabelsOffset);
    
    
    pauseNode = [[SKSpriteNode alloc]initWithImageNamed:@"pause.png"];
    pauseNode.position = CGPointMake(0, 40);
    pauseNode.zPosition = 12.0;
    
    
    [menuBox addChild:menuTitle];
    [menuBox addChild:tutorialLabel];
    [menuBox addChild:leaderLabel];
    [menuBox addChild:achievementsLabel];
    [menuBox addChild:closeLabel];
    [self addChild:menuNode];
    
}

-(void)loadSounds {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    self.soundDisabled = [def boolForKey:@"soundDisabled"];
    bool skipTutorial = [def boolForKey:@"skipTutorial"];
    
    if (!skipTutorial){
        self.soundDisabled = YES;
        [def setBool:YES forKey:@"soundDisabled"];
        [def synchronize];
    }
    
    
    soundOn = [SKSpriteNode spriteNodeWithImageNamed:@"on.png"];
    soundOff = [SKSpriteNode spriteNodeWithImageNamed:@"off.png"];
    soundOff.name = @"soundLabel";
    soundOn.name = @"soundLabel";
    soundOn.zPosition = 7.0;
    soundOff.zPosition = 7.0;
    
    CGPoint soundPos;
    if (phoneType == 0){
        soundPos = CGPointMake(-self.view.frame.size.width/1.3 - 95, -self.view.frame.size.height/2 - 5);
    }
    else if (phoneType == 1){
        soundPos = CGPointMake(-self.view.frame.size.width/1.3 - 29, -self.view.frame.size.height/2 );
    }
    else if (phoneType == 2){
        soundPos = CGPointMake(-self.view.frame.size.width/1.3 + 50, -self.view.frame.size.height/2 + 35 );
    }
    else if (phoneType == 3){
        soundPos = CGPointMake(-self.view.frame.size.width/1.3 + 98, -self.view.frame.size.height/2 + 62);
    }
    else {
        soundPos = CGPointMake(-self.view.frame.size.width/1.3 + 10, -self.view.frame.size.height/2 - 105);
    }
    soundOn.position = soundPos;
    soundOff.position = soundPos;
    
    barrelSound = [SKAction playSoundFileNamed:@"barrel.wav" waitForCompletion:NO];
    fireSound = [SKAction playSoundFileNamed:@"fire.mp3" waitForCompletion:NO];
    bounceSound = [SKAction playSoundFileNamed:@"cartoonJump.mp3" waitForCompletion:NO];
    groundSound = [SKAction playSoundFileNamed:@"hitground.wav" waitForCompletion:NO];
    grenadeSound = [SKAction playSoundFileNamed:@"explosion.mp3" waitForCompletion:NO];
    spikesSound = [SKAction playSoundFileNamed:@"blood_splat.mp3" waitForCompletion:NO];
    volcanoSound = [SKAction playSoundFileNamed:@"sizzle.wav" waitForCompletion:NO];
    ammoSound = [SKAction playSoundFileNamed:@"ammo.wav" waitForCompletion:NO];
    gunSound = [SKAction playSoundFileNamed:@"machinegun.wav" waitForCompletion:NO];
    jetpackSound = [SKAction playSoundFileNamed:@"jetpack.wav" waitForCompletion:NO];
    iceSound = [SKAction playSoundFileNamed:@"freeze.wav" waitForCompletion:NO];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"song1" ofType:@"mp3"];
    NSError *error;
    backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
    if (error) {
    } else {
        backgroundMusic.numberOfLoops = -1;
        [backgroundMusic prepareToPlay];
    }
    
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"s2" ofType:@"mp3"];
    backgroundMusic2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath2] error:&error];
    if (error) {
    } else {
        backgroundMusic2.numberOfLoops = -1;
        [backgroundMusic2 prepareToPlay];
    }
    
    NSString *filePath3 = [[NSBundle mainBundle] pathForResource:@"song3" ofType:@"wav"];
    
    backgroundMusic3 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath3] error:&error];
    if (error) {
    } else {
        backgroundMusic3.numberOfLoops = -1;
        [backgroundMusic3 prepareToPlay];
    }
    
    if (self.soundDisabled){
        [soundOff removeFromParent];
        [self addChild:soundOff];
        
    }
    else {
        [backgroundMusic play];
        [soundOn removeFromParent];
        [self addChild:soundOn];
        
    }
}

-(void)loadScoreLabels {
    PointsLabel *pointsLabel = [PointsLabel pointsLabelWithFontNamed:GAME_FONT];
    pointsLabel.name=@"pointsLabel";
    pointsLabel.fontSize=25.0;
    pointsLabel.fontColor = [UIColor blackColor];
    
    CGPoint pointsPos;
    if (phoneType == 0){
        pointsPos = CGPointMake(self.frame.size.width/2.0 - 80 , self.view.frame.size.height/2.0 + 120);
        
    }
    else if (phoneType == 1){
        pointsPos = CGPointMake(self.frame.size.width/2.0 - 80 , self.view.frame.size.height/2.0 + 80);
    }
    else if (phoneType == 2){
        pointsPos = CGPointMake(self.frame.size.width/2.0 - 60 , self.view.frame.size.height/2.0 + 60);
    }
    else if (phoneType == 3){
        pointsPos = CGPointMake(self.frame.size.width/2.0 - 60 , self.view.frame.size.height/2.0 + 20);
    }
    
    else {
        pointsPos = CGPointMake(self.frame.size.width/2.0 - 80 , self.view.frame.size.height/2.0 + 120);
        
    }
    
    pointsLabel.position = pointsPos;
    pointsLabel.zPosition = 2.0;
    
    [self addChild:pointsLabel];
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    scoreLabel.fontSize = 25.0;
    scoreLabel.text=@"score:";
    scoreLabel.fontColor = [UIColor blackColor];
    scoreLabel.position = CGPointMake(-90, 0);
    [pointsLabel addChild:scoreLabel];
    
    GameData *data = [GameData data];
    [data load];
    
    
    PointsLabel *highScoreLabel = [PointsLabel pointsLabelWithFontNamed:GAME_FONT];
    highScoreLabel.name =@"highScoreLabel";
    highScoreLabel.fontSize=25.0;
    highScoreLabel.fontColor = [UIColor blackColor];
    
    CGPoint highScorePos;
    if (phoneType == 0){
        highScorePos = CGPointMake(self.frame.size.width/2.0 - 80 , self.view.frame.size.height/2.0 + 90);
    }
    else if (phoneType == 1){
        highScorePos = CGPointMake(self.frame.size.width/2.0 - 80 , self.view.frame.size.height/2.0 + 50);
    }
    else if (phoneType == 2){
        highScorePos = CGPointMake(self.frame.size.width/2.0 - 60 , self.view.frame.size.height/2.0 + 30);
    }
    else if (phoneType == 3){
        highScorePos = CGPointMake(self.frame.size.width/2.0 - 60 , self.view.frame.size.height/2.0 - 10);
    }
    else {
        highScorePos = CGPointMake(self.frame.size.width/2.0 - 80 , self.view.frame.size.height/2.0 + 50);
        
    }
    highScoreLabel.position = highScorePos;
    [highScoreLabel setPoints:data.highscore];
    highScoreLabel.zPosition = 2.0;
    [self addChild:highScoreLabel];
    
    SKLabelNode *bestLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    bestLabel.fontSize = 25.0;
    bestLabel.text=@"best:";
    bestLabel.fontColor = [UIColor blackColor];
    
    bestLabel.position = CGPointMake(-85, 0);
    [highScoreLabel addChild:bestLabel];
}

-(void)loadActivatables {
    heroNormal = [SKTexture textureWithImageNamed:@"bob4.png"];
    heroJetPack = [SKTexture textureWithImageNamed:@"bob4JetPack.png"];
    heroFrozen = [SKTexture textureWithImageNamed:@"bobFrozen.png"];
    
    rifleBox = [[SKSpriteNode alloc] initWithImageNamed:@"rifleButton3.png"];
    
    CGPoint activatable1Pos;
    if (phoneType == 0){
        activatable1Pos = CGPointMake(-self.view.frame.size.width/2 - 212, +self.view.frame.size.height/2 - 165);
    }
    else if (phoneType == 1){
        activatable1Pos = CGPointMake(-self.view.frame.size.width/2 - 163, + self.view.frame.size.height/2 - 180 );
    }
    else if (phoneType == 2){
        activatable1Pos = CGPointMake(-self.view.frame.size.width/2 - 120, +self.view.frame.size.height/2 - 192);
    }
    else if (phoneType == 3){
        activatable1Pos = CGPointMake(-self.view.frame.size.width/2 - 80, +self.view.frame.size.height/2 - 220);
    }
    else {
        activatable1Pos = CGPointMake(-75, -self.view.frame.size.height/2 - 170);
    }
    rifleBox.hidden = YES;
    rifleBox.position = activatable1Pos;
    rifleBox.zPosition = 7.0;
    rifleBox.name = @"activatable2";
    [self addChild:rifleBox];
    
    jetPackBox = [[SKSpriteNode alloc] initWithImageNamed:@"jetpackButton3.png"];
    
    CGPoint activatable2Pos;
    if (phoneType == 0){
        activatable2Pos = CGPointMake(-self.view.frame.size.width/2 - 212, + self.view.frame.size.height/2 - 40);
    }
    else if (phoneType == 1){
        activatable2Pos = CGPointMake(-self.view.frame.size.width/2 - 163, + self.view.frame.size.height/2 - 70);
    }
    else if (phoneType == 2){
        activatable2Pos = CGPointMake(-self.view.frame.size.width/2 - 120, + self.view.frame.size.height/2 - 80);
    }
    else if (phoneType == 3){
        activatable2Pos = CGPointMake(-self.view.frame.size.width/2 - 80, + self.view.frame.size.height/2 - 105);    }
    else {
        activatable2Pos = CGPointMake(75, -self.view.frame.size.height/2 - 80);
    }
    jetPackBox.position = activatable2Pos;
    jetPackBox.hidden = YES;
    
    jetPackBox.name=@"activatable1";
    jetPackBox.zPosition = 7.0;
    [self addChild:jetPackBox];
    
    iceBox = [[SKSpriteNode alloc] initWithImageNamed:@"iceBox.png"];
    
    
    CGPoint activatable3Pos;
    if (phoneType == 0){
        activatable3Pos = CGPointMake(-self.view.frame.size.width/2 - 93, self.view.frame.size.height/2 - 40);
    }
    else if (phoneType == 1){
        activatable3Pos = CGPointMake(-self.view.frame.size.width/2 - 50 , self.view.frame.size.height/2 - 70 );
    }
    else if (phoneType == 2){
        activatable3Pos = CGPointMake(-self.view.frame.size.width/2 - 9, self.view.frame.size.height/2 - 80);
    }
    else if (phoneType == 3){
        activatable3Pos = CGPointMake(-self.view.frame.size.width/2  + 34, self.view.frame.size.height/2 - 105);
    }
    else {
        activatable3Pos = CGPointMake(-50, -self.view.frame.size.height/2 - 77);
    }
    iceBox.hidden = YES;
    iceBox.position = activatable3Pos;
    iceBox.zPosition = 7.0;
    iceBox.name = @"activatable3";
    [self addChild:iceBox];}


/***~~  User Interaction  ~~*∂**/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKNode *node = [self nodeAtPoint:location];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        bool skipTutorial = [def boolForKey:@"skipTutorial"];
        
        if (!skipTutorial){
            [def setBool:YES forKey:@"skipTutorial"];
            [def synchronize];
            UIViewController *vc = self.view.window.rootViewController;
            [vc performSegueWithIdentifier:@"tutorial_segue" sender:nil];
        }
        else if (self.isPaused && ![node.name isEqualToString:@"soundLabel"] && ![node.name isEqualToString:@"restartNode"] ) {
            [self pause];
        }
        
        else if ([node.name isEqualToString:@"soundLabel"]){
            if (self.soundDisabled){
                if (!self.isPaused){
                    if (!self.isStarted && !self.isGameOver){
                        [backgroundMusic play];
                    }
                    else if (self.isStarted && !self.isGameOver){
                        [backgroundMusic2 play];
                    }
                    else if (self.isGameOver && !self.isStarted){
                        [backgroundMusic3 play];
                    }
                }
                [def setBool:NO forKey:@"soundDisabled"];
                [def synchronize];
                self.soundDisabled = NO;
                [soundOff removeFromParent];
                [self addChild:soundOn];
            }
            else {
                if (!self.isStarted && !self.isGameOver){
                    [backgroundMusic pause];
                }
                else if (self.isStarted && !self.isGameOver){
                    [backgroundMusic2 pause];
                }
                else if (self.isGameOver && !self.isStarted){
                    [backgroundMusic3 pause];
                }
                [def setBool:YES forKey:@"soundDisabled"];
                [def synchronize];
                self.soundDisabled = YES;
                [soundOn removeFromParent];
                [self addChild:soundOff];
            }
        }
        else if ([node.name isEqualToString:@"menuNode"]){
            if (!self.menuShowing){
                self.menuShowing = YES;
                [self addChild:menuBox];
            }
            else {
                self.menuShowing = NO;
                [menuBox removeFromParent];
            }
        }
        else if (self.menuShowing){
            if ([node.name isEqualToString:@"tutorialNode"]){
                UIViewController *vc = self.view.window.rootViewController;
                [vc performSegueWithIdentifier:@"tutorial_segue" sender:nil];
            }
            else if ([node.name isEqualToString:@"leaderNode"]){
                [self showLeaderboardAndAchievements:YES];
            }
            else if ([node.name isEqualToString:@"achievementsNode"]){
                [self showLeaderboardAndAchievements:NO];
            }
            else if ([node.name isEqualToString:@"closeNode"]){
                self.menuShowing = NO;
                [menuBox removeFromParent];
            }
            else if (![node.name isEqualToString:@"menuBox" ]){
                self.menuShowing = NO;
                [menuBox removeFromParent];
            }
            
        }
        else if(!self.isStarted && !self.isGameOver) {
            
            if ([node.name isEqualToString:@"fireButtonNode"]) {
                [[self childNodeWithName:@"tapToBeginLabel"] removeFromParent];
                [self runPowerBar];
                _touchBegan = YES;
            }
            else {
                if (location.x > -50) {
                    if (!self.soundDisabled){
                        [self runAction:barrelSound];
                    }
                    [self updateBarrel:location.x :location.y];
                }
            }
        }
        else if (self.isGameOver && !self.isStarted && !self.isPaused){
            if ([node.name isEqualToString:@"submitNode"]) {
                if (!self.reported) {
                    self.reported = YES;
                    GameKitHelper *gameKitHelper =
                    [GameKitHelper sharedGameKitHelper];
                    PointsLabel *pointsLabel = (PointsLabel*)[self childNodeWithName:@"pointsLabel"];
                    
                    [gameKitHelper reportScore:pointsLabel.number];
                    
                    [self showLeaderboardAndAchievements:YES];
                }
                
                
            }
            else if ([node.name isEqualToString:@"leaderNode"]) {
                [self showLeaderboardAndAchievements:NO];
            }
            else if (self.menuShowing){
                if ([node.name isEqualToString:@"tutorialNode"]){
                }
                else if ([node.name isEqualToString:@"leaderNode"]){
                    [self showLeaderboardAndAchievements:YES];
                }
                else if ([node.name isEqualToString:@"achievementsNode"]){
                    [self showLeaderboardAndAchievements:NO];
                }
                else if ([node.name isEqualToString:@"closeNode"]){
                    self.menuShowing = NO;
                    [menuBox removeFromParent];
                }
                else if (![node.name isEqualToString:@"menuBox" ]){
                    self.menuShowing = NO;
                    [menuBox removeFromParent];
                }
            }
            else{
                [self clear];
            }
            
        }
        else if (self.isStarted && (!_usedJetPack || !_usedGun || !_usedIce) && !self.usingJetPack && !self.usingIce) {
            if (!self.isPaused) {
                if (!_usedJetPack && [node.name isEqualToString:@"activatable1"]) {
                    [self jetPack];
                }
                else if (!_usedGun && [node.name isEqualToString:@"activatable2"] && !self.usingJetPack) {
                    [self shootGun];
                }
                else if (!_usedIce && [node.name isEqualToString:@"activatable3"] && !self.usingIce) {
                    [self useIce];
                }
                else if ([node.name isEqualToString:@"restartNode"]) {
                    [self clear];
                }
                else {
                    [self pause];
                }
            }
            
            else if ([node.name isEqualToString:@"restartNode"]) {
                [self clear];
            }
            else if ([node.name isEqualToString:@"soundLabel"]){
                if (self.soundDisabled){
                    [backgroundMusic2 play];
                    
                    [def setBool:NO forKey:@"soundDisabled"];
                    [def synchronize];
                    self.soundDisabled = NO;
                    [soundOff removeFromParent];
                    [self addChild:soundOn];
                }
                else {
                    [backgroundMusic2 pause];
                    [def setBool:YES forKey:@"soundDisabled"];
                    [def synchronize];
                    self.soundDisabled = YES;
                    [soundOn removeFromParent];
                    [self addChild:soundOff];
                }
            }
            else {
                [self pause];
            }
        }
        else if (self.isStarted){
            if ([node.name isEqualToString:@"restartNode"]) {
                [self clear];
            }
            else if (
                     !(
                       ([node.name isEqualToString:@"activatable1"] && node.hidden == NO) ||
                       ([node.name isEqualToString:@"activatable2"] && node.hidden == NO)|| ([node.name isEqualToString:@"activatable3"] && node.hidden == NO)
                       )
                     ){
                [self pause];
            }
            
        }
        else {
            
            [self pause];
        }
        
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.isStarted && !self.isGameOver) {
        
        if (!self.menuShowing){
            for (UITouch *touch in touches) {
                CGPoint location = [touch locationInNode:self];
                if (location.x > -50) {
                    
                    [self updateBarrel:location.x :location.y];
                }
                
            }
            
        }
        
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!self.isStarted && !self.isGameOver) {
        
        if (_touchBegan && !self.menuShowing) {
            self.touchBegan = NO;
            SKAction *rotation = [SKAction rotateByAngle: M_PI/12.0 duration:.1];
            [barrel runAction: rotation];
            [self start];
        }
    }
}


/***~~  User Interface  ~~***/

-(void)updateHighScoreLabel {
    PointsLabel *pointsLabel = (PointsLabel*)[self childNodeWithName:@"pointsLabel"];
    PointsLabel *highScoreLabel = (PointsLabel*)[self childNodeWithName:@"highScoreLabel"];
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    gameOverLabel.fontSize= 35.0;
    gameOverLabel.position = CGPointMake(0, self.view.frame.size.height/2 + 25);
    gameOverLabel.fontColor = [UIColor blackColor];
    
    
    if (pointsLabel.number > highScoreLabel.number) {
        [highScoreLabel setPoints:pointsLabel.number];
        GameData *data = [GameData data];
        data.highscore = pointsLabel.number;
        [data save];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setInteger:pointsLabel.number forKey:@"distance"];
        [def synchronize];
        gameOverLabel.text = @"High Score!";
        
        
    }
    else {
        gameOverLabel.text = @"Game Over";
    }
    [self addChild:gameOverLabel];
    
}

-(void)handlePoints {
    [world enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.x < hero.position.x) {
            PointsLabel *pointsLabel = (PointsLabel*)[self childNodeWithName:@"pointsLabel"];
            [pointsLabel increment:(hero.position.x)];
        }
    }];
}

-(void)animateWithPulse:(SKNode*)node {
    SKAction *disappear = [SKAction fadeAlphaTo:0.2 duration:.7];
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:.7];
    SKAction *pulse = [SKAction sequence:@[disappear, appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
}

-(void)updateBarrel:(NSInteger)x :(NSInteger)y {
    
    float oldx = -self.frame.size.width/2 + tank.frame.size.width/2 + barrel.size.width/2;
    float oldy =  -83;
    
    
    
    float diffx = x-oldx;
    float diffy = y-oldy;
    
    double angle = atan2(diffy, diffx);
    double constraint = angle  * 180/M_PI;
    
    if (constraint > 0 && constraint < 50.0) {
        barrel.zRotation = 0;
        barrel.zRotation = fmax(0, (angle));
        fireAngle = angle;
    }
    else {
        if (constraint < 45) {
            barrel.zRotation = 0;
            fireAngle = 0;
        }
        else {
            barrel.zRotation = .8727;
            fireAngle = .8727;
        }
    }
    
    NSString *angleString =[NSString stringWithFormat:@"%.02f", fireAngle * 180/M_PI];
    angleLabel.text= angleString;
    
}

-(void)runPowerBar {
    i = 3;
    progressBar.hidden = NO;
    power = 1;
    self.powerGoing = YES;
}



/***~~  Game Events  ~~***/

-(void)start {
    if (!self.isStarted && !self.isGameOver) {
        self.powerGoing = NO;
        self.isStarted = YES;
        self.ssBoost = NO;
        self.usedGun = YES;
        self.usedJetPack = YES;
        self.usedIce = YES;
        self.usingIce = NO;
        gunHits = 0;
        packHits = 0;
        double constraint = fireAngle * 180/M_PI;
        if (constraint > 50) {
            hero.position = CGPointMake(hero.position.x-5, hero.position.y+20);
            
        }
        else if (constraint < 30) {
            hero.position = CGPointMake(hero.position.x, hero.position.y-20);
        }
        [menuNode removeFromParent];
        
        [self addChild:restartNode];
        
        [timer invalidate];
        if (!self.soundDisabled){
            [backgroundMusic stop];
            [backgroundMusic2 play];
            [self runAction:fireSound];
            
        }
        [hero start:fireAngle :multiplier];
        [self checkLaunchAchievements];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            progressBar.hidden = YES;
        });
    }
}

-(void)pause{
    
    if (self.isPaused){
        if (!self.isStarted && !self.isGameOver && !self.soundDisabled){
            [backgroundMusic play];
        }
        else if (self.isStarted && !self.isGameOver && !self.soundDisabled){
            [backgroundMusic2 play];
        }
        else if (self.isGameOver && !self.soundDisabled){
            [backgroundMusic3 play];
        }
        self.scene.paused = NO;
        self.isPaused = NO;
        [pauseNode removeFromParent];
    } else {
        if (!self.isStarted && !self.isGameOver && !self.soundDisabled){
            [backgroundMusic pause];
        }
        else if (self.isStarted && !self.isGameOver && !self.soundDisabled){
            [backgroundMusic2 pause];
        }
        else if (self.isGameOver && !self.soundDisabled){
            [backgroundMusic3 pause];
        }
        
        self.scene.paused = YES;
        self.isPaused = YES;
        [self addChild:pauseNode];
    }
}

-(void)clear {
    self.isStarted = NO;
    self.isGameOver = NO;
    self.usingJetPack = NO;
    [backgroundMusic3 stop];
    [backgroundMusic2 stop];
    [self removeAllActions];
    [self removeAllChildren];
    [self createContent];
}

-(void)hitJetPack {
    self.usedJetPack = NO;
    jetPackBox.hidden = NO;
}

-(void)hitGun {
    self.usedGun = NO;
    rifleBox.hidden = NO;
}

-(void)hitIce{
    self.usedIce = NO;
    iceBox.hidden = NO;
}

-(void)gameOver {
    finalDistance = hero.position.x;
    self.isStarted = NO;
    
    self.isGameOver = YES;
    
    self.reported = NO;
    
    [backgroundMusic2 stop];
    if (!self.soundDisabled){
        [backgroundMusic3 play];
    }
    [restartNode removeFromParent];
    [self addChild:menuNode];
    
    SKLabelNode *tapToResetLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToResetLabel.name=@"tapToResetLabel";
    tapToResetLabel.text =@"tap to reset";
    tapToResetLabel.fontSize=32.0;
    tapToResetLabel.fontColor = [UIColor blackColor];
    tapToResetLabel.position=CGPointMake(0, self.view.frame.size.height/2 - 35);
    
    [self addChild:tapToResetLabel];
    
    [self animateWithPulse:tapToResetLabel];
    [self updateHighScoreLabel];
    
    SKSpriteNode *submitBox = [SKSpriteNode spriteNodeWithColor:[UIColor darkTextColor] size:CGSizeMake(340, 80)];
    submitBox.position = CGPointMake(0,50);
    submitBox.name=@"submitNode";
    submitBox.zPosition = 10.0;
    [self addChild:submitBox];
    
    SKLabelNode *submitLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    submitLabel.text = @"Submit High Score";
    submitLabel.name=@"submitNode";
    submitLabel.fontSize=28.0;
    [submitBox addChild:submitLabel];
    
    
    SKSpriteNode *leaderBox = [SKSpriteNode spriteNodeWithColor:[UIColor darkTextColor] size:CGSizeMake(340, 80)];
    leaderBox.position = CGPointMake(0, -50);
    leaderBox.name=@"leaderNode";
    leaderBox.zPosition = 10.0;
    [self addChild:leaderBox];
    
    SKLabelNode *leaderLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    leaderLabel.text = @"Game Center";
    leaderLabel.name=@"leaderNode";
    leaderLabel.fontSize=28.0;
    [leaderBox addChild:leaderLabel];
    [self checkAchievements];
    [self reportAchievements];
}


/***~~  Activatables  ~~***/

-(void)jetPack {
    hero.texture = heroJetPack;
    float xdis = (1000 + hero.physicsBody.velocity.dx) * 3.0;
    [hero removeAllActions];
    hero.physicsBody.affectedByGravity = NO;
    hero.physicsBody.velocity = CGVectorMake(0, 0);
    hero.zRotation = 0;
    hero.physicsBody.dynamic = NO;
    if (!self.soundDisabled){
        [self runAction:jetpackSound];
    }
    jetPackBox.hidden = YES;
    
    SKAction *moveAction = [SKAction moveByX:xdis y:350 duration:3.2];
    self.usingJetPack = YES;
    [hero runAction:moveAction completion:^{
        hero.texture = heroNormal;
        hero.zRotation = 0;
        hero.physicsBody.dynamic = YES;
        hero.physicsBody.affectedByGravity = YES;
        _usedJetPack = YES;
        hero.physicsBody.velocity = CGVectorMake(xdis/3.0, 0);
        self.usingJetPack = NO;
    }];
    totalJetpack++;
    packHits++;
    [self checkActivatableAchievements];
    
    
}

-(void)shootGun {
    _usedGun = YES;
    [hero boost5];
    if (!self.soundDisabled) {
        [self runAction:gunSound];
    }
    rifleBox.hidden = YES;
    
    totalGun++;
    gunHits++;
    [self checkActivatableAchievements];
    
}

-(void)useIce {
    self.usingIce = YES;
    hero.texture = heroFrozen;
    iceBox.hidden = YES;
    if (!self.soundDisabled) {
        [self runAction:iceSound];
    }
    SKAction *waitAction = [SKAction waitForDuration:8.0];
    [hero runAction:waitAction completion:^{
        hero.texture = heroNormal;
        self.usingIce = NO;
    }];
}


/***~~  Physics/Collision Delegates and World Generator  ~~***/

-(void)didSimulatePhysics {
    if (self.isStarted==YES && hero.physicsBody.resting && !self.usingJetPack &&!self.isPaused) {
        [self gameOver];
    }
    
    
    if ((int)hero.position.x % 35000 == 0) {
        [generator populate];
    }
    
    if (phoneType == 0){
        if (hero.position.y > self.view.frame.size.height/2 + 100) {
            distanceLabel.text=[NSString stringWithFormat:@"%.02f ft", hero.position.y - self.view.frame.size.height/2 - 100];
            
            distanceBubble.hidden = NO;
        }
        else {
            distanceBubble.hidden = YES;
        }
        
    }
    else if (phoneType == 1){
        if (hero.position.y > self.view.frame.size.height/2) {
            distanceLabel.text=[NSString stringWithFormat:@"%.02f ft", hero.position.y - self.view.frame.size.height/2];
            distanceBubble.hidden = NO;
            
        }
        else {
            distanceBubble.hidden = YES;
            
        }
    }
    else {
        if (hero.position.y > self.view.frame.size.height/2) {
            distanceLabel.text=[NSString stringWithFormat:@"%.02f ft", hero.position.y - self.view.frame.size.height/2];
            distanceBubble.hidden = NO;
            
        }
        else {
            distanceBubble.hidden = YES;
            
        }
    }
    if ( ( (hero.physicsBody.velocity.dx < 10.0 && fabs(hero.physicsBody.velocity.dy) < 10.0 && hero.position.y < -240.0) || hero.physicsBody.isResting) && (self.isStarted && !self.isPaused &&!self.usingJetPack) )   {
        
        [self gameOver];
    }
    [self centerOnNode:hero];
    [self handleGeneration];
    [self handleCleanup];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.isStarted && !self.isGameOver && !self.isPaused) {
        PointsLabel *pointsLabel = (PointsLabel*)[self childNodeWithName:@"pointsLabel"];
        [pointsLabel increment:(hero.position.x)];
    }
    if (self.powerGoing) {
        float prog = power * 0.1;
        multiplier = prog;
        [progressBar setProgress:prog];
        power = power + i;
        
        
        if (power > 100) {
            i = -3;
        }
        else if (power < 1) {
            i = 3;
        }
        
    }
    
    
}

-(void)handleGeneration {
    [world enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < hero.position.x) {
            node.name=@"obstacle_canceled";
            [generator generate:0];
        }
    }];
}

-(void)handleCleanup {
    [world enumerateChildNodesWithName:@"ground" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < hero.position.x - self.frame.size.width - node.frame.size.width/2) {
            [node removeFromParent];
            
        }
    }];
    
    [world enumerateChildNodesWithName:@"obstacle_cancelled" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < hero.position.x - self.frame.size.width/2 - node.frame.size.width/2) {
            [node removeFromParent];
        }
    }];
    
}

-(void)centerOnNode:(SKNode *)node {
    CGPoint positionInScene = [self convertPoint:node.position fromNode:node.parent];
    world.position = CGPointMake(world.position.x - positionInScene.x , self.view.frame.size.height/4);
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    if (contact.bodyA.categoryBitMask == obstacleCategory4) {
        if (!self.usingIce) {
            [hero stop];
            hero.physicsBody = nil;
            SKAction *action = [SKAction moveTo:contact.bodyA.node.position duration:.02];
            [hero runAction:action];
            
            
            SKSpriteNode * blood = [SKSpriteNode spriteNodeWithImageNamed:@"blood.png"];
            blood.name=@"blood";
            blood.zRotation = 1.5;
            
            [hero addChild:blood];
            if (!self.soundDisabled) {
                [self runAction:spikesSound];
            }
            [self gameOver];
        }
        
    }
    
    else if (contact.bodyA.categoryBitMask == obstacleCategory5){
        if (!self.usingIce) {
            [hero stop];
            hero.physicsBody = nil;
            SKAction *action = [SKAction moveTo:contact.bodyA.node.position duration:.02];
            [hero runAction:action];
            if (!self.soundDisabled){
                [self runAction:volcanoSound];
            }
            [self gameOver];
            
        }
    }
    
    
    else if(contact.bodyA.categoryBitMask == obstacleCategory1){
        //NSLog(@"Hero Speed on grenade contact: (%f, %f)", hero.physicsBody.velocity.dx, hero.physicsBody.velocity.dy);
        SKNode* node = contact.bodyA.node;
        [node removeFromParent];
        if (!self.soundDisabled){
            [self runAction:grenadeSound];
        }
        [hero boost1];
        
    }
    else if(contact.bodyB.categoryBitMask == obstacleCategory1){
        //NSLog(@"Hero Speed on grenade contact: (%f, %f)", hero.physicsBody.velocity.dx, hero.physicsBody.velocity.dy);
        SKNode* node = contact.bodyB.node;
        [node removeFromParent];
        if (!self.soundDisabled){
            [self runAction:grenadeSound];
        }
        [hero boost1];
        
    }
    
    else if (contact.bodyA.categoryBitMask == obstacleCategory2) {
        SKNode* node = contact.bodyA.node;
        [node removeFromParent];
        
        [hero boost1];
        if (!self.soundDisabled){
            [self runAction:bounceSound];
        }
        
    }
    
    else if (contact.bodyA.categoryBitMask == obstacleCategory3) {
        SKNode* node = contact.bodyA.node;
        [node removeFromParent];
        if (!self.soundDisabled){
            [self runAction:ammoSound];
        }
        
        [self hitJetPack];
        
    }
    else if (contact.bodyB.categoryBitMask == obstacleCategory3) {
        SKNode* node = contact.bodyB.node;
        [node removeFromParent];
        if (!self.soundDisabled){
            [self runAction:ammoSound];
        }
        
        [self hitJetPack];
        
    }
    
    else if (contact.bodyA.categoryBitMask == obstacleCategory6){
        SKNode* node = contact.bodyA.node;
        [node removeFromParent];
        if (!self.soundDisabled){
            [self runAction:ammoSound];
        }
        
        [self hitGun];
    }
    else if (contact.bodyB.categoryBitMask == obstacleCategory6){
        SKNode* node = contact.bodyB.node;
        [node removeFromParent];
        if (!self.soundDisabled){
            [self runAction:ammoSound];
        }
        
        [self hitGun];
    }
    else if (contact.bodyA.categoryBitMask == obstacleCategory7){
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        GKAchievement *a10 = [[GKAchievement alloc]initWithIdentifier:@"grp.achievement_doppelganger"];
        a10.showsCompletionBanner = YES;
        [standardUserDefaults setInteger:1 forKey:@"a10"];
        [standardUserDefaults synchronize];
        a10.percentComplete = 100.0;
        self.a_doppel = YES;
        [self hitJetPack];
        [self hitGun];
        [self hitIce];
        if (!self.soundDisabled){
            [self runAction:ammoSound];
        }
        [hero boost1];
        [GKAchievement reportAchievements:@[a10] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                
            }
        }];
    }
    else if (contact.bodyB.categoryBitMask == obstacleCategory7){
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        GKAchievement *a10 = [[GKAchievement alloc]initWithIdentifier:@"grp.achievement_doppelganger"];
        a10.showsCompletionBanner = YES;
        [standardUserDefaults setInteger:1 forKey:@"a10"];
        [standardUserDefaults synchronize];
        a10.percentComplete = 100.0;
        self.a_doppel = YES;
        [self hitJetPack];
        [self hitGun];
        [self hitIce];
        if (!self.soundDisabled){
            [self runAction:ammoSound];
        }
        [hero boost1];
        [GKAchievement reportAchievements:@[a10] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                
            }
        }];
    }
    else if (contact.bodyA.categoryBitMask == obstacleCategory8){
        SKNode* node = contact.bodyA.node;
        [node removeFromParent];
        if (!self.soundDisabled){
            [self runAction:ammoSound];
        }
        [self hitIce];
        
    }
    else if (contact.bodyB.categoryBitMask == obstacleCategory8){
        SKNode* node = contact.bodyB.node;
        [node removeFromParent];
        if (!self.soundDisabled){
            [self runAction:ammoSound];
        }
        [self hitIce];
        
    }
    
    else if (contact.bodyA.categoryBitMask == groundCategory){
        if ((fabs(hero.physicsBody.velocity.dx) > 30.0 && fabs(hero.physicsBody.velocity.dy) > 30.0) || fabs(hero.physicsBody.velocity.dy) > 500) {
            if (!self.soundDisabled){
                [self runAction:groundSound];
            }
        }
    }
}


/***~~  Achievements  ~~***/

-(void)loadAchievements {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSInteger distance = [def integerForKey:@"distance"];
    highScore = distance;
    NSInteger shootNumber = [def integerForKey:@"shootNumber"];
    NSInteger packNumber = [def integerForKey:@"packNumber"];
    NSInteger launches = [def integerForKey:@"launches"];
    
    totalLaunches = launches;
    totalGun = shootNumber;
    totalJetpack = packNumber;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self checkCompletedAchievements];
    });
}

-(void)checkCompletedAchievements {
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
     {
         if (error == nil && [achievements count] > 0)
         {
             for (GKAchievement* achievement in achievements){
                 if ([achievement.identifier isEqualToString:@"achievement_10k"]){
                     if (achievement.isCompleted){
                         self.a_10k = YES;
                     }
                     else {
                         self.a_10k = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_50k"]){
                     if (achievement.isCompleted){
                         self.a_50k = YES;
                     }
                     else {
                         self.a_50k = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement.100k"]){
                     if (achievement.isCompleted){
                         self.a_100k = YES;
                     }
                     else {
                         self.a_100k = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_200k"]){
                     if (achievement.isCompleted){
                         self.a_200k = YES;
                     }
                     else {
                         self.a_200k = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_300k"]){
                     if (achievement.isCompleted){
                         self.a_300k = YES;
                     }
                     else {
                         self.a_300k = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_500k"]){
                     if (achievement.isCompleted){
                         self.a_500k = YES;
                     }
                     else {
                         self.a_500k = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_g1"]){
                     if (achievement.isCompleted){
                         
                         self.g_1 = YES;
                     }
                     else {
                         self.g_1 = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_g2"]){
                     if (achievement.isCompleted){
                         self.g_2 = YES;
                     }
                     else {
                         self.g_2 = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_g3"]){
                     if (achievement.isCompleted){
                         self.g_3 = YES;
                     }
                     else {
                         self.g_3 = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_g4"]){
                     if (achievement.isCompleted){
                         self.g_4 = YES;
                     }
                     else {
                         self.g_4 = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_j1"]){
                     if (achievement.isCompleted){
                         self.j_1 = YES;
                     }
                     else {
                         self.j_1 = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_j2"]){
                     if (achievement.isCompleted){
                         self.j_2 = YES;
                     }
                     else {
                         self.j_2 = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_j3"]){
                     if (achievement.isCompleted){
                         self.j_3 = YES;
                     }
                     else {
                         self.j_3 = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_j4"]){
                     if (achievement.isCompleted){
                         self.j_4 = YES;
                     }
                     else {
                         self.j_4 = NO;
                     }
                 }
                 
                 else if ([achievement.identifier isEqualToString:@"achievement_gun"]){
                     if (achievement.isCompleted){
                         self.a_gun = YES;
                     }
                     else {
                         self.a_gun = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_jetpack"]){
                     if (achievement.isCompleted){
                         self.a_pack = YES;
                     }
                     else {
                         self.a_pack = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_doppel"]){
                     if (achievement.isCompleted){
                         self.a_doppel = YES;
                     }
                     else {
                         self.a_doppel = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_l1"]){
                     if (achievement.isCompleted){
                         self.l_1 = YES;
                     }
                     else {
                         self.l_1 = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_l2"]){
                     if (achievement.isCompleted){
                         self.l_2 = YES;
                     }
                     else {
                         self.l_2 = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_l3"]){
                     if (achievement.isCompleted){
                         self.l_3 = YES;
                     }
                     else {
                         self.l_3 = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_l4"]){
                     if (achievement.isCompleted){
                         self.l_4 = YES;
                     }
                     else {
                         self.l_4 = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"grp.achievement_l5"]){
                     if (achievement.isCompleted){
                         self.l_5 = YES;
                     }
                     else {
                         self.l_5 = NO;
                     }
                 }
                 else if ([achievement.identifier isEqualToString:@"achievement_l6"]){
                     if (achievement.isCompleted){
                         self.l_6 = YES;
                     }
                     else {
                         self.l_6 = NO;
                     }
                 }
             }
         }
         else if (totalLaunches >= 10 || totalGun >= 10 || totalJetpack >= 10 || highScore >= 20000) {
             loadCount++;
             if (loadCount < 5) {
                 [self performSelector:@selector(checkCompletedAchievements) withObject:nil afterDelay:2.0];
             }
             else {
                 
             }
             
         }
     }];
    
}

-(void)checkLaunchAchievements {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    totalLaunches++;
    [standardUserDefaults setInteger:totalLaunches forKey:@"launches"];
    [standardUserDefaults synchronize];
    
    
    NSMutableArray *achievements = [[NSMutableArray alloc]init];
    
    if (totalLaunches >= 1000){
        if (!self.l_6){
            GKAchievement *l6 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l6"];
            l6.identifier = @"grp.achievement_l6";
            l6.percentComplete = 100.0;
            if (totalLaunches == 1000){
                l6.showsCompletionBanner = YES;
            } else l6.showsCompletionBanner = NO;
            self.l_6 = YES;
            [achievements addObject:l6];
        }
        if (!self.l_5){
            GKAchievement *l5 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l5"];
            l5.identifier = @"grp.achievement_l5";
            l5.percentComplete = 100.0;
            self.l_5 = YES;
            [achievements addObject:l5];
            
        }
    }
    else if (totalLaunches >= 500){
        if (!self.l_5){
            GKAchievement *l5 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l5"];
            l5.identifier = @"grp.achievement_l5";
            l5.percentComplete = 100.0;
            if (totalLaunches == 500){
                l5.showsCompletionBanner = YES;
            } else l5.showsCompletionBanner = NO;
            self.l_5 = YES;
            [achievements addObject:l5];
        }
        if (!self.l_4){
            GKAchievement *l4 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l4"];
            l4.identifier = @"grp.achievement_l4";
            l4.percentComplete = 100.0;
            self.l_4 = YES;
            
            [achievements addObject:l4];
            
        }
        GKAchievement *l6 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l6"];
        l6.identifier = @"grp.achievement_l6";
        l6.percentComplete = 100 *totalLaunches/1000;
        [achievements addObject:l6];
    } else if (totalLaunches >= 200) {
        if (!self.l_4){
            GKAchievement *l4 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l4"];
            l4.identifier = @"grp.achievement_l4";
            l4.percentComplete = 100.0;
            if (totalLaunches == 200){
                l4.showsCompletionBanner = YES;
            } else l4.showsCompletionBanner = NO;
            self.l_4 = YES;
            [achievements addObject:l4];
            
        }
        if (!self.l_3){
            GKAchievement *l3 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l3"];
            l3.identifier = @"grp.achievement_l3";
            l3.percentComplete = 100.0;
            self.l_3 = YES;
            [achievements addObject:l3];
            
        }
        GKAchievement *l6 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l6"];
        l6.identifier = @"grp.achievement_l6";
        l6.percentComplete = 100 *totalLaunches/1000;
        [achievements addObject:l6];
        
        GKAchievement *l5 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l5"];
        l5.identifier = @"grp.achievement_l5";
        l5.percentComplete = 100 * totalLaunches/500 ;
        [achievements addObject:l5];
        
    } else if (totalLaunches >= 100) {
        if (!self.l_3){
            GKAchievement *l3 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l3"];
            l3.identifier = @"grp.achievement_l3";
            l3.percentComplete = 100.0;
            self.l_3 = YES;
            if (totalLaunches == 100){
                l3.showsCompletionBanner = YES;
            } else l3.showsCompletionBanner = NO;
            [achievements addObject:l3];
            
        }
        if (!self.l_2){
            GKAchievement *l2 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l2"];
            l2.identifier = @"grp.achievement_l2";
            l2.percentComplete = 100.0;
            self.l_2 = YES;
            [achievements addObject:l2];
            
        }
        GKAchievement *l6 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l6"];
        l6.identifier = @"grp.achievement_l6";
        l6.percentComplete = 100 *totalLaunches/1000;
        [achievements addObject:l6];
        
        GKAchievement *l5 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l5"];
        l5.identifier = @"grp.achievement_l5";
        l5.percentComplete = 100 * totalLaunches/500;
        [achievements addObject:l5];
        
        
        GKAchievement *l4 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l4"];
        l4.identifier = @"grp.achievement_l4";
        l4.percentComplete = 100 * totalLaunches/200;
        [achievements addObject:l4];
        
    } else if (totalLaunches >= 50) {
        if (!self.l_2){
            GKAchievement *l2 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l2"];
            l2.identifier = @"grp.achievement_l2";
            l2.percentComplete = 100.0;
            if (totalLaunches == 50){
                l2.showsCompletionBanner = YES;
            } else l2.showsCompletionBanner = NO;
            self.l_2 = YES;
            [achievements addObject:l2];
            
        }
        if (!self.l_1){
            GKAchievement *l1 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l1"];
            l1.identifier = @"grp.achievement_l1";
            l1.percentComplete = 100.0;
            self.l_1 = YES;
            [achievements addObject:l1];
            
        }
        
        GKAchievement *l6 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l6"];
        l6.identifier = @"grp.achievement_l6";
        l6.percentComplete = 100 *totalLaunches/1000;
        [achievements addObject:l6];
        
        GKAchievement *l5 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l5"];
        l5.identifier = @"grp.achievement_l5";
        l5.percentComplete = 100 * totalLaunches/500;
        [achievements addObject:l5];
        
        
        GKAchievement *l4 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l4"];
        l4.identifier = @"grp.achievement_l4";
        l4.percentComplete = 100 * totalLaunches/200;
        [achievements addObject:l4];
        
        
        GKAchievement *l3 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l3"];
        l3.identifier = @"grp.achievement_l3";
        l3.percentComplete = 100 * totalLaunches/100;
        [achievements addObject:l3];
        
    }else if (totalLaunches >= 10) {
        if (!self.l_1){
            GKAchievement *l1 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l1"];
            l1.identifier = @"grp.achievement_l1";
            l1.percentComplete = 100.0;
            if (totalLaunches == 10){
                l1.showsCompletionBanner = YES;
            } else l1.showsCompletionBanner = NO;
            self.l_1 = YES;
            [achievements addObject:l1];
        }
        GKAchievement *l6 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l6"];
        l6.identifier = @"grp.achievement_l6";
        l6.percentComplete = 100 *totalLaunches/1000;
        [achievements addObject:l6];
        
        GKAchievement *l5 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l5"];
        l5.identifier = @"grp.achievement_l5";
        l5.percentComplete = 100 * totalLaunches/500;
        [achievements addObject:l5];
        
        
        GKAchievement *l4 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l4"];
        l4.identifier = @"grp.achievement_l4";
        l4.percentComplete = 100 * totalLaunches/200;
        [achievements addObject:l4];
        
        
        GKAchievement *l3 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l3"];
        l3.identifier = @"grp.achievement_l3";
        l3.percentComplete = 100 * totalLaunches/100;
        [achievements addObject:l3];
        
        GKAchievement *l2 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l2"];
        l2.identifier = @"grp.achievement_l2";
        l2.percentComplete = 100 * totalLaunches/50;
        [achievements addObject:l2];
    }else {
        GKAchievement *l6 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l6"];
        l6.identifier = @"grp.achievement_l6";
        l6.percentComplete = 100 *totalLaunches/1000;
        [achievements addObject:l6];
        
        GKAchievement *l5 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l5"];
        l5.identifier = @"grp.achievement_l5";
        l5.percentComplete = 100 * totalLaunches/500;
        [achievements addObject:l5];
        
        
        GKAchievement *l4 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l4"];
        l4.identifier = @"grp.achievement_l4";
        l4.percentComplete = 100 * totalLaunches/200;
        [achievements addObject:l4];
        
        
        GKAchievement *l3 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l3"];
        l3.identifier = @"grp.achievement_l3";
        l3.percentComplete = 100 * totalLaunches/100;
        [achievements addObject:l3];
        
        GKAchievement *l2 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l2"];
        l2.identifier = @"grp.achievement_l2";
        l2.percentComplete = 100 * totalLaunches/50;
        [achievements addObject:l2];
        
        GKAchievement *l1 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_l1"];
        l1.identifier = @"grp.achievement_l1";
        l1.percentComplete = 100 * totalLaunches/10;
        [achievements addObject:l1];
    }
    
    if ([achievements count] > 0) {
        [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
            if (error != nil){
            }
        }];
    }
}

-(void)checkActivatableAchievements {
    NSMutableArray *achievements = [[NSMutableArray alloc]init];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger shootNumber = [standardUserDefaults integerForKey:@"shootNumber"];
    NSInteger packNumber = [standardUserDefaults integerForKey:@"packNumber"];
    
    if (gunHits > 0 ){
        GKAchievement *a8 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_gun"];
        a8.identifier = @"grp.achievement_gun";
        
        if (gunHits >= 5 && !self.a_gun) {
            a8.percentComplete = 100.0;
            a8.showsCompletionBanner = YES;
            [achievements addObject:a8];
            self.a_gun = YES;
            
        }
        else {
            a8.percentComplete = 100 * gunHits / 5;
            
            [achievements addObject:a8];
        }
        
    }
    
    if (packHits > 0 ){
        GKAchievement *a9 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_jetpack"];
        a9.identifier = @"grp.achievement_jetpack";
        if (packHits >= 2 &&!self.a_pack) {
            a9.showsCompletionBanner = YES;
            a9.percentComplete = 100.0;
            self.a_pack = YES;
            
            [achievements addObject:a9];
        }
        else {
            a9.percentComplete = 100 * packHits/2;
            [achievements addObject:a9];
        }
    }
    
    if (!(shootNumber > 500)){
        GKAchievement *g1 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_g1"];
        g1.identifier = @"grp.achievement_g1";
        
        GKAchievement *g2 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_g2"];
        g2.identifier = @"grp.achievement_g2";
        
        GKAchievement *g3 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_g3"];
        g3.identifier = @"grp.achievement_g3";
        
        GKAchievement *g4 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_g4"];
        g4.identifier = @"grp.achievement_g4";
        
        if (totalGun >= 500) {
            if (!self.g_4){
                self.g_4 = YES;
                g4.percentComplete = 100.0;
                g4.showsCompletionBanner = YES;
                [achievements addObject:g4];
                
            }
            if (!self.g_3){
                self.g_3 = YES;
                g3.percentComplete = 100.0;
                [achievements addObject:g3];
            }
        }
        else if (totalGun >= 100) {
            if (!self.g_3){
                self.g_3 = YES;
                g3.percentComplete = 100.0;
                g3.showsCompletionBanner = YES;
                [achievements addObject:g3];
            }
            if (!self.g_2){
                self.g_2 = YES;
                g2.percentComplete = 100.0;
                [achievements addObject:g2];
            }
            g4.percentComplete = 100 * totalGun/500;
            [achievements addObject:g4];
        }
        else if (totalGun >= 50) {
            if (!self.g_2){
                self.g_2 = YES;
                g2.percentComplete = 100.0;
                g2.showsCompletionBanner = YES;
                [achievements addObject:g2];
            }
            if(!self.g_1){
                self.g_1 = YES;
                g1.percentComplete = 100.0;
                [achievements addObject:g1];
            }
            g4.percentComplete = 100 * totalGun/500;
            [achievements addObject:g4];
            
            g3.percentComplete = 100 * totalGun/100;
            [achievements addObject:g3];
        }
        else if (totalGun >= 10) {
            if(!self.g_1){
                self.g_1 = YES;
                g1.showsCompletionBanner = YES;
                g1.percentComplete = 100.0;
                [achievements addObject:g1];
            }
            
            g4.percentComplete = 100 * totalGun/500;
            [achievements addObject:g4];
            
            g3.percentComplete = 100 * totalGun/100;
            [achievements addObject:g3];
            
            g2.percentComplete = 100 * totalGun/50;
            [achievements addObject:g2];
        }
        else if(totalGun > 0) {
            g1.percentComplete = 100 * totalGun/10;
            [achievements addObject:g1];
        }
    }
    if (!(packNumber > 500)){
        
        GKAchievement *j1 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_j1"];
        j1.identifier = @"grp.achievement_j1";
        
        GKAchievement *j2 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_j2"];
        j2.identifier = @"grp.achievement_j2";
        
        GKAchievement *j3 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_j3"];
        j3.identifier = @"grp.achievement_j3";
        
        GKAchievement *j4 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_j4"];
        j4.identifier = @"grp.achievement_j4";
        
        if (totalJetpack >= 500) {
            if (!self.j_4){
                self.j_4 = YES;
                j4.percentComplete = 100.0;
                j4.showsCompletionBanner = YES;
                [achievements addObject:j4];
            }
            if (!self.j_3){
                self.j_3 = YES;
                j3.percentComplete = 100.0;
                [achievements addObject:j3];
            }
        }
        else if (totalJetpack >= 100) {
            if (!self.j_3){
                self.j_3 = YES;
                j3.percentComplete = 100.0;
                j3.showsCompletionBanner = YES;
                [achievements addObject:j3];
            }
            if (!self.j_2){
                self.j_2 = YES;
                j2.percentComplete = 100.0;
                [achievements addObject:j2];
            }
            j4.percentComplete = 100 * totalJetpack/500;
            [achievements addObject:j4];
        }
        else if (totalJetpack >= 50) {
            if (!self.j_2){
                self.j_2 = YES;
                j2.percentComplete = 100.0;
                j2.showsCompletionBanner = YES;
                [achievements addObject:j2];
            }
            if (!self.j_1){
                self.j_1 = YES;
                j1.percentComplete = 100.0;
                [achievements addObject:j1];
            }
            j4.percentComplete = 100 * totalJetpack/500;
            [achievements addObject:j4];
            
            j3.percentComplete = 100 * totalJetpack/100;
            [achievements addObject:j3];
        }
        else if (totalJetpack >= 10) {
            if (!self.j_1){
                self.j_1 = YES;
                j1.percentComplete = 100.0;
                [achievements addObject:j1];
            }
            
            j4.percentComplete = 100 * totalJetpack/500;
            [achievements addObject:j4];
            
            j3.percentComplete = 100 * totalJetpack/100;
            [achievements addObject:j3];
            
            j2.percentComplete = 100 * totalJetpack/50;
            [achievements addObject:j2];
        }
        else if (totalJetpack > 0){
            
            j1.percentComplete = 100 * totalJetpack/10;
            [achievements addObject:j1];
        }
    }
    
    if ([achievements count] > 0) {
        [standardUserDefaults setInteger:totalGun forKey:@"shootNumber"];
        [standardUserDefaults setInteger:totalLaunches forKey:@"launches"];
        [standardUserDefaults setInteger:totalJetpack forKey:@"packNumber"];
        
        [standardUserDefaults synchronize];
        [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
            if (error != nil){
            }
            
        }];
    }
}

-(void)reportAchievements {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger distance = [standardUserDefaults integerForKey:@"distance"];
    NSMutableArray *achievements = [[NSMutableArray alloc]init];
    
    if (!(distance > finalDistance)) {
        if (self.a_300k){
            GKAchievement *a7 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_500k"];
            a7.identifier=@"grp.achievement_500k";
            a7.percentComplete = 100 * finalDistance / 500000.0;
            [achievements addObject:a7];
        }else if (self.a_200k){
            GKAchievement *a6 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_300k"];
            a6.identifier=@"grp.achievement_300k";
            a6.percentComplete = 100 * finalDistance / 300000.0;
            [achievements addObject:a6];
        }else if (self.a_100k){
            GKAchievement *a5 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_200k"];
            a5.identifier=@"grp.achievement_200k";
            a5.percentComplete = 100 * finalDistance / 200000.0;
            [achievements addObject:a5];
        }else if (self.a_50k){
            GKAchievement *a4 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement.100k"];
            a4.identifier=@"grp.achievement.100k";
            a4.percentComplete = 100 * finalDistance / 100000.0;
            [achievements addObject:a4];
        }else if (self.a_10k){
            GKAchievement *a3 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_50k"];
            a3.identifier=@"grp.achievement_50k";
            a3.percentComplete = 100 * finalDistance / 50000.0;
            [achievements addObject:a3];
        }else {
            GKAchievement *a1 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_20k"];
            a1.identifier=@"grp.achievement_20k";
            a1.percentComplete = 100 * finalDistance / 20000.0;
            [achievements addObject:a1];
            
        }
    }
    if ([achievements count] > 0) {
        [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
            if (error != nil){
                NSLog(@"Error reporting messages");
            }
            
        }];
    }
}

-(void)checkAchievements {
    NSMutableArray *achievements = [[NSMutableArray alloc]init];
    
    if (finalDistance >= 20000 && !self.a_10k){
        GKAchievement *a1 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_20k"];
        a1.identifier=@"grp.achievement_20k";
        a1.percentComplete = 100.0;
        a1.showsCompletionBanner = YES;
        self.a_10k = YES;
        [achievements addObject:a1];
    }
    
    if (finalDistance >= 50000 && !self.a_50k){
        GKAchievement *a3 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_50k"];
        a3.identifier=@"grp.achievement_50k";
        a3.percentComplete = 100.0;
        a3.showsCompletionBanner = YES;
        self.a_50k = YES;
        [achievements addObject:a3];
        
    }
    if (finalDistance >= 100000 && !self.a_100k){
        GKAchievement *a4 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement.100k"];
        a4.identifier=@"grp.achievement.100k";
        a4.percentComplete = 100.0;
        a4.showsCompletionBanner = YES;
        self.a_100k = YES;
        [achievements addObject:a4];
        
    }
    if (finalDistance >= 200000 && !self.a_200k){
        GKAchievement *a5 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_200k"];
        a5.identifier=@"grp.achievement_200k";
        a5.percentComplete = 100.0;
        a5.showsCompletionBanner = YES;
        self.a_200k = YES;
        [achievements addObject:a5];
        
    }
    if (finalDistance >= 300000 && !self.a_300k){
        GKAchievement *a6 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_300k"];
        a6.identifier=@"grp.achievement_300k";
        a6.percentComplete = 100.0;
        a6.showsCompletionBanner = YES;
        self.a_300k = YES;
        [achievements addObject:a6];
    }
    if (finalDistance>= 500000 && !self.a_500k){
        GKAchievement *a7 = [[GKAchievement alloc] initWithIdentifier:@"grp.achievement_500k"];
        a7.identifier=@"grp.achievement_500k";
        a7.percentComplete = 100.0;
        a7.showsCompletionBanner = YES;
        self.a_500k = YES;
        [achievements addObject:a7];
    }
    if ([achievements count] > 0) {
        [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
            if (error != nil){
            }
            
        }];
    }
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard {
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = @"grp.High_Score_Leaderboard";
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self.view.window.rootViewController presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


@end