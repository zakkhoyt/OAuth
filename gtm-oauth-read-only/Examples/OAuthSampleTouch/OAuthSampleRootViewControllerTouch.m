/* Copyright (c) 2010 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// OAuthSampleRootViewControllerTouch.m


//***************************************** Sources below here use OAuth 1.0 **********************************
//// Twitter
//#define VWW_OAUTH_KEY       @"PmrOuEkMNp5VtUYuxDFSjw"
//#define VWW_OAUTH_SECRET    @"UAcbVHkpC9OfGr1mwdw3VNimsvQZ7Ud6x7z4vBq7I"
//#define VWW_REQUEST_URL     @"https://api.twitter.com/oauth/request_token"
//#define VWW_ACCESS_URL      @"https://api.twitter.com/oauth/access_token"
//#define VWW_AUTH_URL        @"https://api.twitter.com/oauth/authorize"
//#define VWW_SCOPE_URL       @"http://api.twitter.com/"

//// IMGUR
//#define VWW_OAUTH_KEY       @"47547d27502a7bf4d801d3c5fcbd70430509b4d6c"
//#define VWW_OAUTH_SECRET    @"de0515025b636a1e58296da0d164d7a4"
//#define VWW_REQUEST_URL     @"https://api.imgur.com/oauth/request_token"
//#define VWW_ACCESS_URL      @"https://api.imgur.com/oauth/access_token"
//#define VWW_AUTH_URL        @"https://api.imgur.com/oauth/authorize"
//#define VWW_SCOPE_URL       @"http://api.imgur.com/"

//// Instagram
//#define VWW_OAUTH_KEY       @"436069b066654b8f8330c3f4d9d19723"
//#define VWW_OAUTH_SECRET    @"34677979b8f542d982fba60dce841a38"
//#define VWW_REQUEST_URL     @"https://api.instagram.com/oauth/request_token"
//#define VWW_ACCESS_URL      @"https://api.instagram.com/oauth/access_token"
//#define VWW_AUTH_URL        @"https://api.instagram.com/oauth/authorize"
//#define VWW_SCOPE_URL       @"http://api.instagram.com/"

//// Flickr
//#define VWW_OAUTH_KEY       @"547affc8f7ef457a0e53f2787239186e"
//#define VWW_OAUTH_SECRET    @"68412371079ed808"
//#define VWW_REQUEST_URL     @"http://www.flickr.com/services/oauth/request_token"
//#define VWW_ACCESS_URL      @"http://www.flickr.com/services/oauth/access_token"
//#define VWW_AUTH_URL        @"http://www.flickr.com/services/oauth/authorize"
//#define VWW_SCOPE_URL       @""

// Tumblr
#define VWW_OAUTH_KEY       @"rKKnikNqmDm2KtsY4BzwPJ4a3QEwuGSHZXIfF7Rcp5Aqg2jYSE"
#define VWW_OAUTH_SECRET    @"PmST95iwRI9KinYKj44uuKKY2AEPBC9ENWxTbBelTyKOoUyKlq"
#define VWW_REQUEST_URL     @"http://www.tumblr.com/oauth/request_token"
#define VWW_ACCESS_URL      @"http://www.tumblr.com/oauth/access_token?x_auth_mode=client_auth"
#define VWW_AUTH_URL        @"http://www.tumblr.com/oauth/authorize"
#define VWW_SCOPE_URL       @""


//// Linkedin
//#define VWW_OAUTH_KEY       @"grpsxvtrejpw"
//#define VWW_OAUTH_SECRET    @"QYsHpMiCJpatATUD"
//#define VWW_REQUEST_URL     @"https://api.linkedin.com/uas/oauth/requestToken"
//#define VWW_ACCESS_URL      @"https://api.linkedin.com/uas/oauth/accessToken"
//#define VWW_AUTH_URL        @"https://api.linkedin.com/uas/oauth/authenticate"
//#define VWW_SCOPE_URL       @""


//***************************************** Sources below here use OAuth 2.0 **********************************
//// Github
//#define VWW_OAUTH_KEY       @"rKKnikNqmDm2KtsY4BzwPJ4a3QEwuGSHZXIfF7Rcp5Aqg2jYSE"
//#define VWW_OAUTH_SECRET    @"PmST95iwRI9KinYKj44uuKKY2AEPBC9ENWxTbBelTyKOoUyKlq"
//#define VWW_REQUEST_URL     @"http://www.tumblr.com/oauth/request_token"
//#define VWW_ACCESS_URL      @"https://github.com/login/oauth/access_token"
//#define VWW_AUTH_URL        @"https://github.com/login/oauth/authorize"
//#define VWW_SCOPE_URL       @""





#import "OAuthSampleRootViewControllerTouch.h"
#import "GTMOAuthViewControllerTouch.h"

static NSString *const kShouldSaveInKeychainKey = @"shouldSaveInKeychain";

static NSString *const kTwitterKeychainItemName = @"OAuth Sample: Twitter";
static NSString *const kTwitterServiceName = @"Twitter";

@interface OAuthSampleRootViewControllerTouch()
- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error;
- (void)incrementNetworkActivity:(NSNotification *)notify;
- (void)decrementNetworkActivity:(NSNotification *)notify;
- (void)signInNetworkLostOrFound:(NSNotification *)notify;
- (GTMOAuthAuthentication *)authForTwitter;
- (void)doAnAuthenticatedAPIFetch;
- (BOOL)shouldSaveInKeychain;
@end

@implementation OAuthSampleRootViewControllerTouch

@synthesize serviceSegments = mServiceSegments;
@synthesize shouldSaveInKeychainSwitch = mShouldSaveInKeychainSwitch;
@synthesize signInOutButton = mSignInOutButton;
@synthesize emailField = mEmailField;
@synthesize tokenField = mTokenField;

- (void)awakeFromNib {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(incrementNetworkActivity:) name:kGTMOAuthFetchStarted object:nil];
  [nc addObserver:self selector:@selector(decrementNetworkActivity:) name:kGTMOAuthFetchStopped object:nil];
  [nc addObserver:self selector:@selector(signInNetworkLostOrFound:) name:kGTMOAuthNetworkLost  object:nil];
  [nc addObserver:self selector:@selector(signInNetworkLostOrFound:) name:kGTMOAuthNetworkFound object:nil];

  // Get the saved authentication, if any, from the keychain.
  //
  // The view controller supports methods for saving and restoring
  // authentication under arbitrary keychain item names; see the
  // "keychainForName" methods in the interface.  The keychain item
  // names are up to the application, and may reflect multiple accounts for
  // one or more services.
  //
  
  // Perhaps we have a saved authorization for Twitter; try getting
  // that from the keychain
  GTMOAuthAuthentication *auth = [self authForTwitter];
  if (auth) {
    BOOL didAuth = [GTMOAuthViewControllerTouch authorizeFromKeychainForName:kTwitterKeychainItemName
                                                              authentication:auth];
    if (didAuth) {
      // Select the Twitter index
      [mServiceSegments setSelectedSegmentIndex:1];
    }
  }
  
  // save the authentication object, which holds the auth tokens
  [self setAuthentication:auth];

  BOOL isRemembering = [self shouldSaveInKeychain];
  [mShouldSaveInKeychainSwitch setOn:isRemembering];
  [self updateUI];
}

- (void)dealloc {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  [mSignInOutButton release];
  [mShouldSaveInKeychainSwitch release];
  [mServiceSegments release];
  [mEmailField release];
  [mTokenField release];
  [mAuth release];
  [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
  // Returns non-zero on iPad, but backward compatible to SDKs earlier than 3.2.
  if (UI_USER_INTERFACE_IDIOM()) {
    return YES;
  }
  return [super shouldAutorotateToInterfaceOrientation:orientation];
}

- (BOOL)isSignedIn {
  BOOL isSignedIn = [mAuth canAuthorize];
  return isSignedIn;
}

- (IBAction)signInOutClicked:(id)sender {
  if (![self isSignedIn]) {
    // sign in
    [self signInToTwitter];
  } else {
    // sign out
    [self signOut];
  }
  [self updateUI];
}

// UISwitch does the toggling for us. We just need to read the state.
- (IBAction)toggleShouldSaveInKeychain:(id)sender {
  [[NSUserDefaults standardUserDefaults] setBool:[sender isOn]
                                          forKey:kShouldSaveInKeychainKey];
}

- (void)signOut {
  // remove the stored Twitter authentication from the keychain, if any
  [GTMOAuthViewControllerTouch removeParamsFromKeychainForName:kTwitterKeychainItemName];

  // Discard our retained authentication object.
  [self setAuthentication:nil];

  [self updateUI];
}

- (GTMOAuthAuthentication *)authForTwitter {
  // Note: to use this sample, you need to fill in a valid consumer key and
  // consumer secret provided by Twitter for their API
  //
  // http://twitter.com/apps/
  //
  // The controller requires a URL redirect from the server upon completion,
  // so your application should be registered with Twitter as a "web" app,
  // not a "client" app
  NSString *myConsumerKey = VWW_OAUTH_KEY;
  NSString *myConsumerSecret = VWW_OAUTH_SECRET;

  if ([myConsumerKey length] == 0 || [myConsumerSecret length] == 0) {
    return nil;
  }

  GTMOAuthAuthentication *auth;
  auth = [[[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                        consumerKey:myConsumerKey
                                                         privateKey:myConsumerSecret] autorelease];

  // setting the service name lets us inspect the auth object later to know
  // what service it is for
  [auth setServiceProvider:kTwitterServiceName];

  return auth;
}

- (void)signInToTwitter {

  [self signOut];

  NSURL *requestURL = [NSURL URLWithString:VWW_REQUEST_URL];
  NSURL *accessURL = [NSURL URLWithString:VWW_ACCESS_URL];
  NSURL *authorizeURL = [NSURL URLWithString:VWW_AUTH_URL];
  NSString *scope = VWW_SCOPE_URL;

  GTMOAuthAuthentication *auth = [self authForTwitter];
  if (auth == nil) {
    // perhaps display something friendlier in the UI?
    NSAssert(NO, @"A valid consumer key and consumer secret are required for signing in to Twitter");
  }

  // set the callback URL to which the site should redirect, and for which
  // the OAuth controller should look to determine when sign-in has
  // finished or been canceled
  //
  // This URL does not need to be for an actual web page; it will not be
  // loaded
  [auth setCallback:@"http://www.example.com/OAuthCallback"];

  NSString *keychainItemName = nil;
  if ([self shouldSaveInKeychain]) {
    keychainItemName = kTwitterKeychainItemName;
  }

  // Display the autentication view.
  GTMOAuthViewControllerTouch *viewController;
  viewController = [[[GTMOAuthViewControllerTouch alloc] initWithScope:scope
                language:nil
         requestTokenURL:requestURL
       authorizeTokenURL:authorizeURL
          accessTokenURL:accessURL
          authentication:auth
          appServiceName:keychainItemName
                delegate:self
        finishedSelector:@selector(viewController:finishedWithAuth:error:)] autorelease];

  // We can set a URL for deleting the cookies after sign-in so the next time
  // the user signs in, the browser does not assume the user is already signed
  // in
  [viewController setBrowserCookiesURL:[NSURL URLWithString:@"http://api.twitter.com/"]];

  // You can set the title of the navigationItem of the controller here, if you want.

  [[self navigationController] pushViewController:viewController animated:YES];
}

- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error {
  if (error != nil) {
    // Authentication failed (perhaps the user denied access, or closed the
    // window before granting access)
    NSLog(@"Authentication error: %@", error);
    NSData *responseData = [[error userInfo] objectForKey:@"data"]; // kGTMHTTPFetcherStatusDataKey
    if ([responseData length] > 0) {
      // show the body of the server's authentication failure response
      NSString *str = [[[NSString alloc] initWithData:responseData
                                             encoding:NSUTF8StringEncoding] autorelease];
      NSLog(@"%@", str);
    }

    [self setAuthentication:nil];
  } else {
    // Authentication succeeded
    //
    // At this point, we either use the authentication object to explicitly
    // authorize requests, like
    //
    //   [auth authorizeRequest:myNSURLMutableRequest]
    //
    // or store the authentication object into a GTM service object like
    //
    //   [[self contactService] setAuthorizer:auth];

    // save the authentication object
    [self setAuthentication:auth];

    // Just to prove we're signed in, we'll attempt an authenticated fetch for the
    // signed-in user
    [self doAnAuthenticatedAPIFetch];
  }

  [self updateUI];
}

- (void)doAnAuthenticatedAPIFetch {
  // Twitter status feed
  NSString *urlStr = @"http://api.twitter.com/1/statuses/home_timeline.json";

  NSURL *url = [NSURL URLWithString:urlStr];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [mAuth authorizeRequest:request];

  // Note that for a request with a body, such as a POST or PUT request, the
  // library will include the body data when signing only if the request has
  // the proper content type header:
  //
  //   [request setValue:@"application/x-www-form-urlencoded"
  //  forHTTPHeaderField:@"Content-Type"];

  // Synchronous fetches like this are a really bad idea in Cocoa applications
  //
  // For a very easy async alternative, we could use GTMHTTPFetcher
  NSError *error = nil;
  NSURLResponse *response = nil;
  NSData *data = [NSURLConnection sendSynchronousRequest:request
                                       returningResponse:&response
                                                   error:&error];
  if (data) {
    // API fetch succeeded
    NSString *str = [[[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"API response: %@", str);
  } else {
    // fetch failed
    NSLog(@"API fetch error: %@", error);
  }
}

#pragma mark -

- (void)incrementNetworkActivity:(NSNotification *)notify {
  ++mNetworkActivityCounter;
  if (1 == mNetworkActivityCounter) {
    UIApplication *app = [UIApplication sharedApplication];
    [app setNetworkActivityIndicatorVisible:YES];
  }
}

- (void)decrementNetworkActivity:(NSNotification *)notify {
  --mNetworkActivityCounter;
  if (0 == mNetworkActivityCounter) {
    UIApplication *app = [UIApplication sharedApplication];
    [app setNetworkActivityIndicatorVisible:NO];
  }
}

- (void)signInNetworkLostOrFound:(NSNotification *)notify {
  if ([[notify name] isEqual:kGTMOAuthNetworkLost]) {
    // network connection was lost; alert the user, or dismiss
    // the sign-in view with
    //   [[[notify object] delegate] cancelSigningIn];
  } else {
    // network connection was found again
  }
}

#pragma mark -

- (void)updateUI {
  // update the text showing the signed-in state and the button title
  // A real program would use NSLocalizedString() for strings shown to the user.
  if ([self isSignedIn]) {
    // signed in
    NSString *email = [mAuth userEmail];
    NSString *token = [mAuth token];

    [mEmailField setText:email];
    [mTokenField setText:token];
    [mSignInOutButton setTitle:@"Sign Out"];
  } else {
    // signed out
    [mEmailField setText:@"Not signed in"];
    [mTokenField setText:@"No authorization token"];
    [mSignInOutButton setTitle:@"Sign In..."];
  }
  BOOL isRemembering = [self shouldSaveInKeychain];
  [mShouldSaveInKeychainSwitch setOn:isRemembering];
}

- (void)setAuthentication:(GTMOAuthAuthentication *)auth {
  [mAuth autorelease];
  mAuth = [auth retain];
}

- (BOOL)shouldSaveInKeychain {
  return [[NSUserDefaults standardUserDefaults] boolForKey:kShouldSaveInKeychainKey];
}

@end

