# BumbleB-iOS

[![CI Status](http://img.shields.io/travis/Ram Greenberg/BumbleB-iOS.svg?style=flat)](https://travis-ci.org/Ram Greenberg/BumbleB-iOS)
[![Version](https://img.shields.io/cocoapods/v/BumbleB-iOS.svg?style=flat)](http://cocoapods.org/pods/BumbleB-iOS)
[![License](https://img.shields.io/cocoapods/l/BumbleB-iOS.svg?style=flat)](http://cocoapods.org/pods/BumbleB-iOS)
[![Platform](https://img.shields.io/cocoapods/p/BumbleB-iOS.svg?style=flat)](http://cocoapods.org/pods/BumbleB-iOS)

BumbleB-iOS is a [BumblB-API](https://github.com/BumbleB-IO/BumbleB-API) client for iOS in Objective-C.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

You should read about [BumbleB's Access and API keys here](https://github.com/BumbleB-IO/BumbleB-API#access-and-api-keys).

### BumbleB-iOS / BumbleB
'BumbleB' provides convenient access to [BumbleB's API](https://github.com/BumbleB-IO/BumbleB-API) endpoints:

- search
- trending
- sound by ID
- sounds by IDs

You can query the endpoints through the blocks based interface:

```objective-c

#import <BumbleB_iOS/BumbleB.h>

- (void)viewDidLoad
{
    [super viewDidLoad];
    // set your API key before making any requests. You may use kSoundyPublicAPIKey for development.
    [BumbleB setBumbleBAPIKey:kBumbleBPublicAPIKey];
    [BumbleB bumbleBTrendingWithCompletion:^(NSArray *results,NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sounds = results;
            [self.tableView reloadData];
        });
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.searchBar startActivity];
    [BumbleB bumbleBSearchWithTerm:searchBar.text completion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sounds = results;
            [self.tableView reloadData];
            // Dismiss
            [self.searchBar finishActivity];
        });
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBCell *cell = [tableView dequeueReusableCellWithIdentifier:kSoundyCellIdentifier];
    
    // Configure the cell...
    BumbleB* sound = self.sounds[indexPath.row];
    [cell setSound:sound];
    
    return cell;
}

```

BumbleB instances represent BumbleB's sound clips and their metadata. However, BumbleB only provides URLs to audio files. How you use these URLs is up to you.

For your convenient please find my example app as a good starting point.

The blocks based class methods return NSURLSessionDataTasks for additional control, should you need it.
BumbleB also provides class methods to generate NSURLRequests for these endpoints.

## Requirements

AFNetworking/Serialization

## Installation

BumbleB-iOS is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BumbleB-iOS"
```

## Author

Ram Greenberg, ramgreenberg@hotmail.com

## License

BumbleB-iOS is available under the MIT license. See the LICENSE file for more info.
