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
// OAuthSampleRootViewControllerTouch.h

@class GTMOAuthAuthentication;

@interface OAuthSampleRootViewControllerTouch : UIViewController<UINavigationControllerDelegate> {
  UISwitch *mShouldSaveInKeychainSwitch;
  UISegmentedControl *mServiceSegments;
  UIButton *mSignInOutButton;
  int mNetworkActivityCounter;
  UILabel *mEmailField;
  UILabel *mTokenField;
  GTMOAuthAuthentication *mAuth;
}
@property (nonatomic, retain) IBOutlet UISegmentedControl *serviceSegments;
@property (nonatomic, retain) IBOutlet UISwitch *shouldSaveInKeychainSwitch;
@property (nonatomic, retain) IBOutlet UIButton *signInOutButton;
@property (nonatomic, retain) IBOutlet UILabel *emailField;
@property (nonatomic, retain) IBOutlet UILabel *tokenField;

@property (nonatomic, retain) IBOutlet UIButton* signInTwitter;
@property (nonatomic, retain) IBOutlet UIButton* signInImgur;
@property (nonatomic, retain) IBOutlet UIButton* signInInstagram;
@property (nonatomic, retain) IBOutlet UIButton* signInFlickr;
@property (nonatomic, retain) IBOutlet UIButton* signInTumblr;
@property (nonatomic, retain) IBOutlet UIButton* signInLinkedin;

- (IBAction)signInTwitterButtonHandler:(id)sender;
- (IBAction)signInImgurButtonHandler:(id)sender;
- (IBAction)signInInstagramButtonHandler:(id)sender;
- (IBAction)signInFlickrButtonHandler:(id)sender;
- (IBAction)signInTumblrButtonHandler:(id)sender;
- (IBAction)signInLinkedinButtonHandler:(id)sender;



- (IBAction)signInOutClicked:(id)sender;
- (IBAction)toggleShouldSaveInKeychain:(id)sender;

- (void)signInToTwitter;
- (void)signOut;
- (BOOL)isSignedIn;

- (void)updateUI;

- (void)setAuthentication:(GTMOAuthAuthentication *)auth;

@end
