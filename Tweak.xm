//Version 0.0.1

#import "SBBannerController.h"

//for PreferenceLoader
/*static BOOL isEnabled;
static float sensitivity;
static BOOL isDeleteNotif;*/

//record positions of touches
CGPoint touchLocation;
CGPoint touchLocation2;

//remove shadow
%hook SBBannerAndShadowView

-(void)setShadowAlpha:(float)alpha
{
    %orig(0.0f);
}

-(BOOL)_showsSideShadows
{
    return NO;
}

%end

%hook SBBulletinBannerView

//saving point of banner's view to this UIView* is justifily
UIView *targetView;

%new(v:@@)
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.suu.slide2killsettings.plist"];

    //if([[dict objectForKey:@"Enabled"] boolValue])
    //{
    UITouch *touch = [[event allTouches] anyObject]; 
    touchLocation = [touch locationInView:targetView]; 
        
        /*UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"ProjNo" message:[NSString stringWithFormat:@"%@",targetView.subviews] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [theAlert show];
    [theAlert release];*/
    //}
    
    //[dict release];
}

%new(v:@@)
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    touchLocation2 = [touch locationInView:targetView];
    if (touchLocation2.x - touchLocation.x > 0)
    {
        targetView.frame = CGRectMake(targetView.frame.origin.x - touchLocation.x + touchLocation2.x,
                                      targetView.frame.origin.y,
                                      targetView.frame.size.width,
                                      targetView.frame.size.height);
    }
}

%new(v:@@)
- (void)touchesEnded:(id)ended withEvent:(id)event
{
    if (touchLocation2.x - touchLocation.x >= 10)
    {
        [[%c(SBBannerController) sharedInstance] _tryToDismissBannerWithAnimation:0];
    }
    else if (touchLocation2.x - touchLocation.x <= -10)
    {
        [[%c(SBBannerController) sharedInstance] _tryToDismissBannerWithAnimation:0];
    }
    [UIView beginAnimations:@"ToggleViews" context:nil];
    [UIView setAnimationDuration:0.3];

    targetView.frame = CGRectMake(0, 0, targetView.frame.size.width, targetView.frame.size.height);

    [UIView commitAnimations];
    touchLocation = CGPointZero;
    touchLocation2 = CGPointZero;
}

//get the point of banner's view
-(id)initWithItem:(id)item
{
    %orig;
    targetView = %orig(item);
    return %orig;
}

%end
