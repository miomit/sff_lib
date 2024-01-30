Small package designed to simplify working with files/directories

## Features

- File comparison for identity
- Recursive copying/moving of a directory
- Move/Delete/Copy files according to the rules

## Getting started

Add a dependency to `pubspec.yaml`

```yaml
dependencies:
    sff_lib:
```

## Usage

Look in `/example` folder.

```dart
await copyDirRec(
    Directory('/home/yura/Images'),
    Directory('/media/yura/Elements/Images')
);
```

## Additional information

This library is under development. With each new version, a new feature will be added.