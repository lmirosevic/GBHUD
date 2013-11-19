GBHUD
============

Lightweight HUD (heads up display) for quick transient modals in iOS & OSX apps.

Usage
------------

First import header:

```objective-c
#import "GBHUD.h"
```

Basics:

```objective-c
GBHUD *hud = [GBHUD sharedHUD];
    
[hud showHUDWithType:GBHUDTypeExplosion text:@"Explosion" animated:YES];	//optionally animate
[hud autoDismissAfterDelay:2 animated:YES];									//optionally autodismiss
```

Demo project
------------

See: [github.com/lmirosevic/GBHUDDemo](https://github.com/lmirosevic/GBHUDDemo)

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
