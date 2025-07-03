import 'package:uuid/uuid.dart';
final uuid = Uuid();

final String DB_TABLES = '''
  -- User Table
CREATE TABLE User (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    firstName TEXT NOT NULL,
    lastName TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    username TEXT NOT NULL UNIQUE,
    profilePicture TEXT,
    createdAt INTEGER NOT NULL,
    updatedAt INTEGER NOT NULL
);

-- Folder Table
CREATE TABLE Folder (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER NOT NULL,
    title TEXT NOT NULL,
    color TEXT NOT NULL,
    createdAt INTEGER NOT NULL,
    updatedAt INTEGER NOT NULL,
    FOREIGN KEY (userId) REFERENCES User (id) ON DELETE CASCADE
);

-- Archive Table
CREATE TABLE Archive (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER NOT NULL,
    folderId INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    cover_image TEXT NOT NULL,
    resource_paths TEXT NOT NULL, 
    createdAt INTEGER NOT NULL,
    updatedAt INTEGER NOT NULL,
    FOREIGN KEY (userId) REFERENCES User (id) ON DELETE CASCADE,
    FOREIGN KEY (folderId) REFERENCES Folder (id) ON DELETE SET NULL
);

-- Category Table
CREATE TABLE Category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER NOT NULL,
    title TEXT NOT NULL,
    icon TEXT NOT NULL,
    createdAt INTEGER NOT NULL,
    updatedAt INTEGER NOT NULL,
    FOREIGN KEY (userId) REFERENCES User (id) ON DELETE CASCADE
);

-- Folder_Category Join Table for Many-to-Many Relationship
CREATE TABLE Folder_Category (
    folderId INTEGER NOT NULL,
    categoryId INTEGER NOT NULL,
    PRIMARY KEY (folderId, categoryId),
    FOREIGN KEY (folderId) REFERENCES Folder (id) ON DELETE CASCADE,
    FOREIGN KEY (categoryId) REFERENCES Category (id) ON DELETE CASCADE
);

CREATE TABLE PinCode (
    userId INTEGER NOT NULL,
    pin_code TEXT NOT NULL,
    FOREIGN KEY (userId) REFERENCES User (id) ON DELETE CASCADE
);
''';

List<String> folderFilters = [
  'All',
  "Last Added",
  "Last Updated",
  "Title Asc",
  "Title Desc",
];

final String defaultImagePath = "lib/assets/images";

final int DEFAULT_FOLDER_ID = 999;

enum SortingOption {
  all,
  lastAddedFirst,
  lastUpdatedFirst,
  titleAZ,
  titleZA,
}




















