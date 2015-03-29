GBHUD
============

Lightweight HUD (heads up display) for quick transient modals in iOS & OSX apps.

Usage
------------

First import header:

```objective-c
#import <GBHUD/GBHUD.h>
```

Basics:

```objective-c
[[GBHUD sharedHUD] showHUDWithType:GBHUDTypeExplosion text:@"Explosion" animated:YES];	//optionally animate
[[GBHUD sharedHUD] autoDismissAfterDelay:2 animated:YES];								//optionally autodismiss
```

Demo projects
------------

[GBHUDDemo iOS](https://github.com/lmirosevic/GBHUDDemo-iOS)

[GBHUDDemo OS X](https://github.com/lmirosevic/GBHUDDemo-OSX)

Dependencies
------------

Resources (add dependency and "copy bundle resources" entry to superproject):

* GBHUDResources.bundle

System Frameworks (link them in):

* CoreGraphics

Copyright & License
------------

Copyright 2013 Luka Mirosevic

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/lmirosevic/gbhud/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
