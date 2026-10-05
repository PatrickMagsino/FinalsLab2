# ITP107 Finals Hive To-Do List

This project keeps the existing Login and Sign-Up screens and changes the Home screen into the Hive to-do activity.

## Hive activity requirements implemented

- Hive initialization before `runApp()`
- `taskBox` for local task storage
- `Task` model with a Hive `TypeAdapter`
- Create task with `box.add()`
- Read tasks from the Hive box
- Update task with `box.put()`
- Delete task with swipe using `box.delete()`
- Floating action button for adding a task
- Separate Add/Edit task screen
- Task title and date displayed on the home screen
- Seven `TextFormField`s with validators:
  1. Task Title
  2. Description
  3. Category
  4. Priority
  5. Location
  6. Assigned To
  7. Notes

## Run

```text
flutter pub get
flutter run
```

The generated adapter is included as `lib/task.g.dart`. If you change the Hive model, regenerate it with:

```text
dart run build_runner build --delete-conflicting-outputs
```
