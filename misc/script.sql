USE master;
GO
CREATE DATABASE JLPTHub;
GO
USE JLPTHub;
GO
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
    Status BIT NOT NULL DEFAULT 1,
    CHECK (Level IN ('N5', 'N4', 'N3', 'N2', 'N1'))
);

CREATE TABLE Flashcard (
    ID uniqueidentifier NOT NULL PRIMARY KEY DEFAULT NEWID(),
    GroupId uniqueidentifier NOT NULL,
    Term nvarchar(100) NOT NULL,
    Definition nvarchar(100) NOT NULL,
    TermImageUrl nvarchar(max),
    DefinitionImageUrl nvarchar(max),
    OrderIndex INT NOT NULL DEFAULT 0,
    Status BIT NOT NULL DEFAULT 1,
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
    Status BIT NOT NULL DEFAULT 1,
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
    Status BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Lesson_Group FOREIGN KEY (GroupId) REFERENCES LessonGroup(ID) ON DELETE CASCADE
);

CREATE TABLE GrammarPoint (
    ID uniqueidentifier NOT NULL PRIMARY KEY DEFAULT NEWID(),
    LessonId uniqueidentifier NOT NULL,
    Title nvarchar(100) NOT NULL,
    Structure nvarchar(255),
    Explanation nvarchar(max),
    Example nvarchar(500),
    Status BIT NOT NULL DEFAULT 1,
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
    Status BIT NOT NULL DEFAULT 1,
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
    Status BIT NOT NULL DEFAULT 1,
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

INSERT [dbo].[FlashcardGroup] ([ID], [Name], [Description], [Level], [CreatedAt], [Status]) VALUES (N'73d8194a-b7f7-4a28-8d3c-145bef542dcd', N'N4 kanji', N'N4 KANJI FOR JLPT', N'N4', CAST(N'2026-01-16T13:11:21.650' AS DateTime), 1)
GO
INSERT [dbo].[FlashcardGroup] ([ID], [Name], [Description], [Level], [CreatedAt], [Status]) VALUES (N'0ffcd3db-b983-4a23-9325-493936c8f5a0', N'N5　かんじ', N'All N5 kanjis', N'N5', CAST(N'2026-01-15T21:36:54.213' AS DateTime), 1)
GO
INSERT [dbo].[FlashcardGroup] ([ID], [Name], [Description], [Level], [CreatedAt], [Status]) VALUES (N'20eadfad-c149-47fc-a359-fe1385300140', N'N3 kanji', N'N3 KANJI FOR JLPT', N'N3', CAST(N'2026-01-16T13:11:34.190' AS DateTime), 1)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'bc8f1b8a-297f-4ec2-98f1-157ae1d97243', N'73d8194a-b7f7-4a28-8d3c-145bef542dcd', N'a', N'1', NULL, NULL, 1, 1)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'85fe0b7b-6c3d-4e60-a261-25dc53c12f8f', N'0ffcd3db-b983-4a23-9325-493936c8f5a0', N'九', N'nine', N'', N'', 1, 10)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'8f89a931-6b62-4ec3-a92e-29f6367a1c92', N'73d8194a-b7f7-4a28-8d3c-145bef542dcd', N'b', N'2', NULL, NULL, 1, 2)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'95101369-e580-482a-878f-325a3ace2375', N'0ffcd3db-b983-4a23-9325-493936c8f5a0', N'八', N'eight', NULL, NULL, 1, 8)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'98084014-19a6-4ece-aedd-3dda8bcf2f8a', N'0ffcd3db-b983-4a23-9325-493936c8f5a0', N'七', N'seven', NULL, NULL, 1, 7)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'7da155c0-621b-4cc8-b25b-4b7e30fb714a', N'20eadfad-c149-47fc-a359-fe1385300140', N'one', N'ichi', NULL, NULL, 1, 1)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'9e5195d3-7582-419a-b978-4d4ac30e5e27', N'0ffcd3db-b983-4a23-9325-493936c8f5a0', N'六', N'six', NULL, NULL, 1, 6)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'60fb5e10-4a84-41e9-92e6-7f043dc5133c', N'0ffcd3db-b983-4a23-9325-493936c8f5a0', N'四', N'four', NULL, NULL, 1, 4)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'a4ccdb1a-c5e2-476a-8941-984cbeffee4e', N'0ffcd3db-b983-4a23-9325-493936c8f5a0', N'五', N'five', NULL, NULL, 1, 5)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'05528a27-6423-4aa6-bb3d-ab0893ad1772', N'0ffcd3db-b983-4a23-9325-493936c8f5a0', N'二', N'two', NULL, NULL, 1, 2)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'cd008762-e8aa-4415-8789-adee507fcb87', N'0ffcd3db-b983-4a23-9325-493936c8f5a0', N'十', N'ten', N'', N'', 1, 0)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'7808477b-b76b-4ad1-a4f2-df467c5ca905', N'20eadfad-c149-47fc-a359-fe1385300140', N'two', N'ni', NULL, NULL, 1, 2)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'7164d290-df15-4c16-bb1b-e5cffebb4ca6', N'0ffcd3db-b983-4a23-9325-493936c8f5a0', N'三', N'three', NULL, NULL, 1, 3)
GO
INSERT [dbo].[Flashcard] ([ID], [GroupId], [Term], [Definition], [TermImageUrl], [DefinitionImageUrl], [Status], [OrderIndex]) VALUES (N'0c0179a7-88b0-460f-b832-f50c5ddb1aed', N'0ffcd3db-b983-4a23-9325-493936c8f5a0', N'一', N'one', NULL, NULL, 1, 1)
GO
INSERT [dbo].[User] ([ID], [Email], [Fullname], [Password], [EmailVerificationToken], [EmailVerificationTokenExpire], [IsEmailVerified], [PasswordResetToken], [PasswordResetTokenExpire], [TargetLevel], [Role], [GoogleId], [AuthProvider]) VALUES (N'89b71122-24da-4c35-bbf2-0fcc3659c5e4', N'htlAdmin@example.com', N'Hạ Tuyết Linh', N'r13BzIbPBg7ZfrGuE4Epsg==:0//8/SriXOet/peQAmy9L8+disxvRv0yHqg+KHNV21o=', NULL, NULL, 1, NULL, NULL, N'N1', 2, NULL, N'local')
GO
INSERT [dbo].[User] ([ID], [Email], [Fullname], [Password], [EmailVerificationToken], [EmailVerificationTokenExpire], [IsEmailVerified], [PasswordResetToken], [PasswordResetTokenExpire], [TargetLevel], [Role], [GoogleId], [AuthProvider]) VALUES (N'1e091681-fb2b-4a66-b0b4-99a97e70a330', N'hieuthien20042004@gmail.com', N'HoangVK2', NULL, NULL, NULL, 1, NULL, NULL, N'N3', 1, N'101985874867977460049', N'google')
GO
INSERT [dbo].[User] ([ID], [Email], [Fullname], [Password], [EmailVerificationToken], [EmailVerificationTokenExpire], [IsEmailVerified], [PasswordResetToken], [PasswordResetTokenExpire], [TargetLevel], [Role], [GoogleId], [AuthProvider]) VALUES (N'0df09852-1864-40fd-9648-dacaf2d6c1b4', N'hoangvkhe180563@fpt.edu.vn', N'Vũ Khánh Hoàng', N'2kCmm+WC26vjYYSwfIqK+w==:DkHC1qvzFshVw3JhRl9eXZLJqcijNwbOVakSSawSFnE=', NULL, NULL, 1, NULL, NULL, N'N5', 1, NULL, N'local')
GO
INSERT [dbo].[UserFlashcardProgress] ([UserId], [FlashcardId], [IsFavorite], [Status], [LastReviewedDate]) VALUES (N'1e091681-fb2b-4a66-b0b4-99a97e70a330', N'bc8f1b8a-297f-4ec2-98f1-157ae1d97243', 0, N'New', NULL)
GO
INSERT [dbo].[UserFlashcardProgress] ([UserId], [FlashcardId], [IsFavorite], [Status], [LastReviewedDate]) VALUES (N'1e091681-fb2b-4a66-b0b4-99a97e70a330', N'98084014-19a6-4ece-aedd-3dda8bcf2f8a', 0, N'New', NULL)
GO
INSERT [dbo].[UserFlashcardProgress] ([UserId], [FlashcardId], [IsFavorite], [Status], [LastReviewedDate]) VALUES (N'1e091681-fb2b-4a66-b0b4-99a97e70a330', N'9e5195d3-7582-419a-b978-4d4ac30e5e27', 0, N'Learning', CAST(N'2026-01-26T15:01:10.850' AS DateTime))
GO
INSERT [dbo].[UserFlashcardProgress] ([UserId], [FlashcardId], [IsFavorite], [Status], [LastReviewedDate]) VALUES (N'1e091681-fb2b-4a66-b0b4-99a97e70a330', N'05528a27-6423-4aa6-bb3d-ab0893ad1772', 0, N'Learning', CAST(N'2026-01-26T15:01:07.030' AS DateTime))
GO
INSERT [dbo].[UserFlashcardProgress] ([UserId], [FlashcardId], [IsFavorite], [Status], [LastReviewedDate]) VALUES (N'1e091681-fb2b-4a66-b0b4-99a97e70a330', N'cd008762-e8aa-4415-8789-adee507fcb87', 0, N'Learned', CAST(N'2026-01-26T15:01:09.297' AS DateTime))
GO
INSERT [dbo].[LessonGroup] ([ID], [Name], [Level], [OrderIndex], [Status]) VALUES (N'68269ccb-2986-49b1-abb9-216fc0d35b22', N'sadsadsadasd', N'N5', 0, 1)
GO
INSERT [dbo].[Lesson] ([ID], [GroupId], [Title], [Description], [AudioUrl], [ContentHtml], [OrderIndex], [Status]) VALUES (N'368d78e5-312e-477b-9778-d0a5a524d93d', N'68269ccb-2986-49b1-abb9-216fc0d35b22', N'Bài 1 - こんにちは', N'Chào mừng bạn đến với tiếng Nhật! Học về hiragana', N'', N'<p>Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.</p>
<dl>
						   <dt>Definition list</dt>
						   <dd>Consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna
						aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
						commodo consequat.</dd>
						   <dt>Lorem ipsum dolor sit amet</dt>
						   <dd>Consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna
						aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
						commodo consequat.</dd>
						</dl>
<h1>HTML Ipsum Presents</h1>

				<p><strong>Pellentesque habitant morbi tristique</strong> senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. <em>Aenean ultricies mi vitae est.</em> Mauris placerat eleifend leo. Quisque sit amet est et sapien ullamcorper pharetra. Vestibulum erat wisi, condimentum sed, <code>commodo vitae</code>, ornare sit amet, wisi. Aenean fermentum, elit eget tincidunt condimentum, eros ipsum rutrum orci, sagittis tempus lacus enim ac dui. <a href="#">Donec non enim</a> in turpis pulvinar facilisis. Ut felis.</p>

				<h2>Header Level 2</h2>

				<ol>
				   <li>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</li>
				   <li>Aliquam tincidunt mauris eu risus.</li>
				</ol>

				<blockquote><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus magna. Cras in mi at felis aliquet congue. Ut a est eget ligula molestie gravida. Curabitur massa. Donec eleifend, libero at sagittis mollis, tellus est malesuada tellus, at luctus turpis elit sit amet quam. Vivamus pretium ornare est.</p></blockquote>

				<h3>Header Level 3</h3>

				<ul>
				   <li>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</li>
				   <li>Aliquam tincidunt mauris eu risus.</li>
				</ul>

				<pre><code>
				#header h1 a {
				  display: block;
				  width: 300px;
				  height: 80px;
				}
				</code></pre>', 0, 1)
GO
INSERT [dbo].[Lesson] ([ID], [GroupId], [Title], [Description], [AudioUrl], [ContentHtml], [OrderIndex], [Status]) VALUES (N'9a025000-0c88-4839-af52-eae90e10bf2f', N'68269ccb-2986-49b1-abb9-216fc0d35b22', N'Bài 2 - こんばんは', N'なにをしてる？
Ha tuyet linh', N'https://res.cloudinary.com/dnvp064it/video/upload/v1769496429/Lessons/foltx7d8jyyvwy72vy3i.mp4', N'<ul>
				   <li>Morbi in sem quis dui placerat ornare. Pellentesque odio nisi, euismod in, pharetra a, ultricies in, diam. Sed arcu. Cras consequat.</li>
				   <li>Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi, tincidunt quis, accumsan porttitor, facilisis luctus, metus.</li>
				   <li>Phasellus ultrices nulla quis nibh. Quisque a lectus. Donec consectetuer ligula vulputate sem tristique cursus. Nam nulla quam, gravida non, commodo a, sodales sit amet, nisi.</li>
				   <li>Pellentesque fermentum dolor. Aliquam quam lectus, facilisis auctor, ultrices ut, elementum vulputate, nunc.</li>
</ul>', 2, 1)
GO
INSERT [dbo].[UserLessonProgress] ([UserId], [LessonId], [IsCompleted], [CompletedDate]) VALUES (N'1e091681-fb2b-4a66-b0b4-99a97e70a330', N'368d78e5-312e-477b-9778-d0a5a524d93d', 1, CAST(N'2026-01-27T13:49:34.433' AS DateTime))
GO
INSERT [dbo].[UserLessonProgress] ([UserId], [LessonId], [IsCompleted], [CompletedDate]) VALUES (N'1e091681-fb2b-4a66-b0b4-99a97e70a330', N'9a025000-0c88-4839-af52-eae90e10bf2f', 1, CAST(N'2026-01-27T13:49:24.420' AS DateTime))
GO
INSERT [dbo].[GrammarPoint] ([ID], [LessonId], [Title], [Structure], [Explanation], [Example], [Status]) VALUES (N'b3d7bae6-bf4e-44d1-86bd-95b430a3bed2', N'368d78e5-312e-477b-9778-d0a5a524d93d', N'hihihi 222', N'見せてください', N'sadsadsadsadsadsadsa', N'Example: かばんを見せてください!
Meaning: Can i see the bag?', 1)
GO
INSERT [dbo].[GrammarPoint] ([ID], [LessonId], [Title], [Structure], [Explanation], [Example], [Status]) VALUES (N'638cf8e9-307e-435c-b1d6-dde879b3b0c4', N'368d78e5-312e-477b-9778-d0a5a524d93d', N'あいうえお', N'見てください', N'Please look at the explaination', N'', 1)
GO