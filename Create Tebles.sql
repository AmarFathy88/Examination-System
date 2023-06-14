Create TABLE STUDENTS (
	[student_SSN] [varchar](14)  primary key,
	[ST_Fname] [varchar](50) NOT NULL,
	[ST_Lname] [varchar](50) ,
	[ST_Email] [varchar](50) unique NOT NULL,
	[ST_Password] [varchar](50) NOT NULL,
	[Gender] [varchar](1) Check (Gender in ('M','F') ),
	[Faculty] [varchar](30) NOT NULL,
	[Phone] [varchar](11)NOT NULL,
	[Birthdate] [date],
	[Gratuated]  [bit] NOT NULL DEFAULT 0,
	[Gratuation_date] [date],
	[GetAJob] bit NOT NULL DEFAULT 0, 
	[City] [varchar](25) default 'Cairo',
	[socila_Media_link] [varchar](150)
)
go
Create TABLE Instructor (
	[INST_SSN] [varchar](14) primary key,
	[INST_Fname] [varchar](50) NOT NULL, 
	[INST_Lname] [varchar](50) ,
	[INST_Email] [varchar](50) unique not null,
	[INST_Password] [varchar](50) NOT NULL,
	[Gender] [varchar](1) Check (Gender in ('M','F') ),
	[City] [varchar](50) default 'Cairo',
	[Phone] [varchar](11)not null,
	[Birthdate] [date],
	[Salary] [int] default 5000,
	[Position] [varchar](50) 
)
go
Create TABLE Tracks (
	[Track_id] [varchar](5) PRIMARY KEY,
	[Track_name] [varchar](50) NOT NULL,
	[Hours] [int] ,
--	[Price] int ,
)
go
Create TABLE Courses (
	[Course_id] [varchar](5) Primary key,
	[Course_name] [varchar](50) NOT NULL,
	[Course_Des] [varchar](255) ,
	--PRIMARY KEY (Course_id , Year , Round)
)
go
Create TABLE Course_Track (  --HAS
	[Course_id] [varchar](5) not null,
	[Track_id] [varchar](5) NOT NULL,
	[Hours] [int],
	foreign key (Course_id) REFERENCES Courses(Course_id),
	FOREIGN KEY (Track_id) REFERENCES Tracks(Track_id),
	PRIMARY KEY (Course_id , Track_id)
)
go
CREATE TABLE ROUND(
	YEAR INT NOT NULL,
	ROUND_N INT NOT NULL CHECK (ROUND_N IN (1,2,3,4))
	PRIMARY KEY (YEAR,ROUND_N)
)
go 
Create Table Course_Round(
	[Course_id] [varchar](5) not null,
	[Year] [int] NOT NULL,
	[Round] [int] NOT NULL,
	[price] [int] NOT NULL,
	foreign key (Course_id) REFERENCES Courses(Course_id),
	foreign key (Year , Round) REFERENCES ROUND(Year , Round_N),
	PRIMARY KEY (Year , Round,Course_id)
)
go
Create Table Track_Round(
	[Track_id] [varchar](5) not null,
	[Year] [int] NOT NULL,
	[Round_N] [int] NOT NULL,
	[price] [int] NOT NULL,
	foreign key (Track_id) REFERENCES Tracks(Track_id),
	foreign key (Year , Round_N) REFERENCES ROUND(Year , Round_N),
	PRIMARY KEY (Year , Round_N,Track_id)
)
GO
Create Table Branch(
	[Branch_id] int primary key,
	[City] [varchar] (25),
	[Location] [varchar](25)
)
go 
CREATE TABLE BRANCH_TRACKS(
	[GENERATED_ID] as (convert(varchar(4),YEAR) +convert(varchar(1),Round_N)+convert(varchar(3),Branch_id)+convert(varchar(5),Track_id)) PERSISTED NOT NULL,
	[Track_id] [varchar](5),
	[Branch_id] INT NOT NULL,
	[YEAR] INT NOT NULL,
	[ROUND_N] INT NOT NULL,
	[supervisor] [varchar](14) NOT NULL,
--	[TRACK_SATISFACTION] INT,
	FOREIGN KEY (Track_id) REFERENCES Tracks(Track_id),
	FOREIGN KEY (Branch_id) REFERENCES BRANCH(Branch_id),
	FOREIGN KEY (supervisor) REFERENCES Instructor(Inst_ssn),
	FOREIGN KEY (Year , Round_N) REFERENCES ROUND(Year , Round_N),
	PRIMARY KEY (GENERATED_ID)
)
go 
Create Table Student_Track_Branch( --belong to
	[Branch_id] int ,
	[Track_id] [varchar](5),
	[Student_SSN] [varchar](14),
	[Year] [int] NOT NULL,
	[Round] [int] NOT NULL,
	[std_branch_satisfaction] [int]
	FOREIGN KEY (Branch_id) REFERENCES Branch(Branch_id),
	FOREIGN KEY (Track_id) REFERENCES Tracks(Track_id),
	FOREIGN KEY (Student_SSN) REFERENCES Students(Student_SSN),
	FOREIGN KEY (Year , Round) REFERENCES ROUND(Year , Round_N),
	primary key (Year , Round,Branch_id,Track_id,Student_SSN)
)
go
Create TABLE Instructor_Tech_Course ( --TEACH
	[Course_id] [varchar](5) not null,
	[Generated_id] varchar(13) not null,
	[INST_SSN] [varchar](14) NOT NULL,
	[FULL_GRADE] [INT],
	[START_DATE] DATE,
	[END_DATE] DATE,
	FOREIGN KEY (Generated_id) REFERENCES BRANCH_TRACKS(Generated_id),
	FOREIGN KEY (Course_id) REFERENCES Courses(Course_id),
	FOREIGN KEY (INST_SSN) REFERENCES Instructor(INST_SSN),
	PRIMARY KEY (Course_id , INST_SSN,Generated_id)
)
GO
Create TABLE Student_Teach_Course (
	[Course_id] [varchar](5) not null,
	[Inst_SSN] varchar(14) NOT NULL,
	[Generated_id] varchar(13) NOT NULL,
	[Student_id] [varchar](14) NOT NULL,
	[std_crs_satisfaction] [int] ,
	[std_Instucrtor_satisfaction] [int] ,
	[std_crs_grade] [int],
	foreign key (Student_id) REFERENCES Students(Student_SSN),
	FOREIGN KEY (Course_id,Inst_SSN,Generated_id) REFERENCES Instructor_Tech_Course(Course_id,Inst_SSN,Generated_id),
	PRIMARY KEY (Student_id,Course_id,Inst_SSN,Generated_id)
)
go
Create TABLE Exam (
	[Exam_id] [int] IDENTITY(1,1) primary key,
	[Inst_SSN] [varchar](14) NOT NULL,
	[Course_id] [varchar](5) NOT NULL,
	[Generated_id] [varchar](13) NOT NULL,
	START_TIME DATE NOT NULL,
	END_TIME DATE NOT NULL,
	[Tital] [varchar](100) NOT NULL,
	[Describtion] [varchar](150),
	[T&F] [int],
	[Choice] [int],
	FOREIGN KEY (Course_id,Inst_SSN,Generated_id) REFERENCES Instructor_Tech_Course(Course_id,Inst_SSN,Generated_id),
)
go
CREATE TABLE EXAM_STUDENT(
	EXAM_ID INT NOT NULL,
	STUDENT_SSN VARCHAR(14),
	STUDENT_GRADE INT default 0,
	Available bit default 1 ,
	passed bit default 0,
	FOREIGN KEY (EXAM_ID) REFERENCES EXAM(EXAM_ID),
	FOREIGN KEY (STUDENT_SSN) REFERENCES STUDENTS(STUDENT_SSN),
	PRIMARY KEY (EXAM_ID,STUDENT_SSN)
)
go
Create TABLE Question_Bank (
	[Q_id] [int] IDENTITY(1,1) primary key,
	[Course_id] [varchar](5) NOT NULL,
	[Q_Type] [varchar](2) Check ([Q_Type] in ('ch','tf') ) default  'ch',
	[Question] [varchar](350) NOT NULL,
	[A] [varchar](100)NOT NULL,
	[B] [varchar](100)NOT NULL,
	[C] [varchar](100),
	[D] [varchar](100),
	[Model_Answer] [varchar](100)NOT NULL,
	FOREIGN KEY (Course_id) REFERENCES Courses(Course_id),
)
go
Create TABLE Answers (
	[Exam_id] [int] NOT NULL,
	[Student_SSN] [varchar](14) NOT NULL,
	[Q_id] [int] NOT NULL,
	[Student_Asn] [varchar](100),
	[Grade] [int],
	FOREIGN KEY (Exam_id) REFERENCES Exam(Exam_id),
	FOREIGN KEY (Q_id) REFERENCES Question_Bank(Q_id),
	FOREIGN KEY (Student_SSN) REFERENCES Students(Student_SSN),
	primary key (Q_id,Exam_id,Student_SSN)
)

