# Contributing to Forui

## Design Guidelines

### Be agnostic about state management

There is a wide variety of competing state management packages. Picking one may discourage users of the other packages 
from adopting Forui. Use `InheritedWidget` instead.

### Be conservative when exposing configuration knobs

Additional knobs can always be introduced later if there's sufficient demand. Changing these knobs is time-consuming and
constitute a breaking change.

✅ Prefer this:
```dart
class Foo extends StatelessWidget {
  final int _someKnobWeDontKnowIfUsefulToUsers = ...;
  
  const Foo() {}
  
  @override
  void build(BuildContext context) {
    ...
  }
}
```

❌ Instead of:
```dart
class Foo extends StatelessWidget {
  final int someKnobWeDontKnowIfUsefulToUsers = ...;
  
  const Foo(this.someKnobWeDontKnowIfUsefulToUsers) {}
  
  @override
  void build(BuildContext context) {
    ...
  }
}
```

### Mark widgets as final when sensible

Subclasses can interact with Forui in unforeseen ways, and cause potential issues. It is not breaking to initially mark 
classes as `final`, and subsequently unmark it. The inverse isn't true. Favor composition over inheritance.

### Minimize dependency on 3rd party packages

3rd party packages introduce uncertainty. It is difficult to predict whether a package will be maintained in the future.
Furthermore, if a new major version of a 3rd party package is released, applications that depend on both Forui and the 
3rd party package may be forced into dependency hell. 

In some situations, it is unrealistic to implement things ourselves. In these cases, we should prefer packages that:
* Are authored by Forus Labs.
* [Are maintained by a group/community rather than an individual](https://en.wikipedia.org/wiki/Bus_factor).
* Have a "pulse", i.e. maintainers responding to issues in the past month at the time of introduction.

Lastly, types from 3rd party packages should not be publicly exported by Forui.

### Widget Styles

```dart
class FooStyle with Diagnosticable { // ---- (1)
  
  final Color color;
  
  FooStyle({required this.color}); // ---- (2)
  
  FooStyle.inherit({FFont font, FColorScheme scheme}): color = scheme.primary; // ---- (2)
  
  FooStyle copyWith({Color? color}) => FooStyle( // ---- (3)
    color: color ?? this.color, 
  );
  
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) { // ---- (4)
    super.debugFillProperties(properties);
    properties.add(ColorProperty<BorderRadius>('color', color));
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is FStyle && color == other.color; // ---- (5)

  @override
  int get hashCode => color.hashCode; // ---- (5)
  
}
```

They should:
1. mix-in [Diagnosticable](https://api.flutter.dev/flutter/foundation/Diagnosticable-mixin.html).
2. provide a primary constructor, and a named constructor, `inherit(...)` , that configures itself based on 
   an ancestor `FTheme`.
3. provide a `copyWith(...)` method.
4. override [debugFillProperties](https://api.flutter.dev/flutter/foundation/Diagnosticable/debugFillProperties.html).
5. implement `operator ==` and `hashCode`.


## Expose `String` and `Widget` variants of the same parameter.

Widgets typically contain string-based content such as titles and labels. These widgets should expose a `String` and
`Widget` variant of the same parameter. For example, a widget that has a title should expose `String? label` and `Widget?
rawLabel` constructor parameters. The constructor should then assert that only one of these parameters is non-null.

[Example](https://github.com/forus-labs/forui/blob/e61a11a346e8e1d788ba2eb9031b73a18a407402/forui/lib/src/widgets/badge/badge.dart#L20): 
```dart
FBadge({
  String? label,
  Widget? rawLabel,
}) :
    assert((label == null) ^ (rawLabel == null), 'Either "label" or "rawLabel" must be provided, but not both.'),
```


## Conventions

* Avoid [double negatives](https://en.wikipedia.org/wiki/Double_negative) when naming things, i.e. a boolean field should
  be named `enabled` instead of `disabled`.

* Avoid past tense when naming callbacks, prefer present tense instead.

  ✅ Prefer this:
  ```dart
  final VoidCallback onPress;
  ```

  ❌ Instead of:
  ```dart
  final VoidCallback onPressed;
  ```


* Prefix all publicly exported widgets and styles with `F`, i.e. `FScaffold`.
