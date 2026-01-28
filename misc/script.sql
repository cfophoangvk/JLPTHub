CREATE TABLE [User] (
    ID uniqueidentifier NOT NULL PRIMARY KEY DEFAULT NEWID(),
    Email nvarchar(100) NOT NULL UNIQUE,
    Fullname nvarchar(80) NOT NULL,
    Password nvarchar(100),
    EmailVerificationToken uniqueidentifier,
    EmailVerificationTokenExpire datetime,
    IsEmailVerified bit NOT NULL DEFAULT 0,
    PasswordResetToken uniqueidentifier,
    PasswordResetTokenExpire datetime,
    TargetLevel char(2) NOT NULL,
    Role tinyint NOT NULL,
    GoogleId nvarchar(100),
    AuthProvider nvarchar(20) NOT NULL DEFAULT 'local',
    CHECK (Role IN (1, 2)), -- 1: learner, 2: admin
    CHECK (TargetLevel IN ('N5', 'N4', 'N3', 'N2', 'N1')),
    CHECK (AuthProvider IN ('local', 'google'))
);

CREATE TABLE FlashcardGroup (
    ID uniqueidentifier NOT NULL PRIMARY KEY DEFAULT NEWID(),
    Name nvarchar(100) NOT NULL,
    Description nvarchar(255),
    Level char(2) NOT NULL,
    CreatedAt datetime DEFAULT GETDATE(),
    CHECK (Level IN ('N5', 'N4', 'N3', 'N2', 'N1'))
);

CREATE TABLE Flashcard (
    ID uniqueidentifier NOT NULL PRIMARY KEY DEFAULT NEWID(),
    GroupId uniqueidentifier NOT NULL,
    Term nvarchar(100) NOT NULL,
    Definition nvarchar(100) NOT NULL,
    TermImageUrl nvarchar(max),
    DefinitionImageUrl nvarchar(max),
    CONSTRAINT FK_Flashcard_Group FOREIGN KEY (GroupId) REFERENCES FlashcardGroup(ID) ON DELETE CASCADE
);

CREATE TABLE UserFlashcardProgress (
    UserId uniqueidentifier NOT NULL,
    FlashcardId uniqueidentifier NOT NULL,
    IsFavorite bit NOT NULL DEFAULT 0,
    Status varchar(10) NOT NULL DEFAULT 'New',
    LastReviewedDate datetime DEFAULT GETDATE(),
    CONSTRAINT FK_UFP_User FOREIGN KEY (UserId) REFERENCES [User](ID) ON DELETE CASCADE,
    CONSTRAINT FK_UFP_Flashcard FOREIGN KEY (FlashcardId) REFERENCES Flashcard(ID) ON DELETE CASCADE,
    PRIMARY KEY (UserId, FlashcardId)
);

CREATE TABLE LessonGroup (
    ID uniqueidentifier NOT NULL PRIMARY KEY DEFAULT NEWID(),
    Name nvarchar(100) NOT NULL,
    Level char(2) NOT NULL,
    OrderIndex int NOT NULL DEFAULT 0, -- To sort units (1, 2, 3...),
    CHECK (Level IN ('N5', 'N4', 'N3', 'N2', 'N1'))
);

CREATE TABLE Lesson (
    ID uniqueidentifier NOT NULL PRIMARY KEY DEFAULT NEWID(),
    GroupId uniqueidentifier NOT NULL,
    Title nvarchar(150) NOT NULL,
    Description nvarchar(max),
    AudioUrl nvarchar(500), -- Audio (optional)
    ContentHtml nvarchar(max), -- Reading (optional)
    OrderIndex int NOT NULL DEFAULT 0,
    CONSTRAINT FK_Lesson_Group FOREIGN KEY (GroupId) REFERENCES LessonGroup(ID) ON DELETE CASCADE
);

CREATE TABLE GrammarPoint (
    ID uniqueidentifier NOT NULL PRIMARY KEY DEFAULT NEWID(),
    LessonId uniqueidentifier NOT NULL,
    Title nvarchar(100) NOT NULL,
    Structure nvarchar(255),
    Explanation nvarchar(max),
    Example nvarchar(500),
    CONSTRAINT FK_Grammar_Lesson FOREIGN KEY (LessonId) REFERENCES Lesson(ID) ON DELETE CASCADE
);

CREATE TABLE UserLessonProgress (
    UserId uniqueidentifier NOT NULL,
    LessonId uniqueidentifier NOT NULL,
    IsCompleted bit DEFAULT 0,
    CompletedDate datetime,
    PRIMARY KEY (UserId, LessonId),
    CONSTRAINT FK_ULP_User FOREIGN KEY (UserId) REFERENCES [User](ID) ON DELETE CASCADE,
    CONSTRAINT FK_ULP_Lesson FOREIGN KEY (LessonId) REFERENCES Lesson(ID) ON DELETE CASCADE
);

CREATE TABLE Test (
    ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
    Title nvarchar(150) NOT NULL,
    Level char(2) NOT NULL,
    CreatedAt datetime DEFAULT GETDATE(),
    CHECK (Level IN ('N5', 'N4', 'N3', 'N2', 'N1'))
);

CREATE TABLE TestSection (
    ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
    TestId int NOT NULL,
    TimeLimitMinutes int NOT NULL,
    AudioUrl nvarchar(max), -- optional audio if there are Choukai questions
    SectionType nvarchar(10) NOT NULL,
    PassScore int NOT NULL,
    TotalScore int NOT NULL DEFAULT 180,
    CONSTRAINT FK_TestSection_Test FOREIGN KEY (TestId) REFERENCES Test(ID) ON DELETE CASCADE,
    CHECK (SectionType IN ('Moji/Goi', 'Bunpou', 'Choukai'))
);

CREATE TABLE Question (
    ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
    SectionId int NOT NULL,
    Content nvarchar(max) NOT NULL,
    ImageUrl nvarchar(500),
    CONSTRAINT FK_Question_TestSection FOREIGN KEY (SectionId) REFERENCES TestSection(ID) ON DELETE CASCADE,
);

CREATE TABLE QuestionOption (
    ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
    QuestionId int NOT NULL,
    Content nvarchar(500) NOT NULL,
    ImageUrl nvarchar(500),
    IsCorrect bit NOT NULL DEFAULT 0,
    CONSTRAINT FK_Option_Question FOREIGN KEY (QuestionId) REFERENCES Question(ID) ON DELETE CASCADE
);

CREATE TABLE UserTestResult (
    ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
    UserId uniqueidentifier NOT NULL,
    TestId int NOT NULL,
    ScoreObtained int NOT NULL,
    IsPassed bit NOT NULL,
    TakenDate datetime DEFAULT GETDATE(),
    DurationSeconds int,
    CONSTRAINT FK_UTR_User FOREIGN KEY (UserId) REFERENCES [User](ID) ON DELETE CASCADE,
    CONSTRAINT FK_UTR_Test FOREIGN KEY (TestId) REFERENCES Test(ID) ON DELETE CASCADE
);

CREATE TABLE UserTestAnswer (
    ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
    UserTestResultId int NOT NULL,
    QuestionId int NOT NULL,
    SelectedOptionId int,
    IsCorrect bit NOT NULL,
    CONSTRAINT FK_UTA_Result FOREIGN KEY (UserTestResultId) REFERENCES UserTestResult(ID) ON DELETE CASCADE,
    CONSTRAINT FK_UTA_Question FOREIGN KEY (QuestionId) REFERENCES Question(ID),
    CONSTRAINT FK_UTA_Option FOREIGN KEY (SelectedOptionId) REFERENCES QuestionOption(ID)
);