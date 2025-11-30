package com.example.new_ara_app.models

enum class Board {
    GeneralNotice,
    IntlComm,
    IntlCoop,
    ITService,
    FamilyEvents,
    FacultyClub,
    WorkStudyScholarship,
    NewsLetter,
    SeminarAndEvent,
    WorkManual,
    StudentCouncilNotice,
    MaintenanceNotice,
    Affiliates,
    Startup,
    SportsAndHealth,
    Employment,
    Covid19,
    StudentClubs,
    CurriculumChanges,
    LeadershipAndInternship,
    Dormitory,
    CourseAndThesis,
    ScholarshipAndWelfare,
    ResearchPersonnel,
    TeachingAndLearning,
    Library,
    Unknown;

    val localizedString: String
        get() = when (this) {
            GeneralNotice -> "General Notice"
            IntlComm -> "International Community"
            IntlCoop -> "International Opportunities/Collaboration"
            ITService -> "IT Services"
            FamilyEvents -> "Family Events"
            FacultyClub -> "Faculty Clubs"
            WorkStudyScholarship -> "Work-Study Scholarship"
            NewsLetter -> "Newsletter"
            SeminarAndEvent -> "Seminars & Events"
            WorkManual -> "Work Manual"
            StudentCouncilNotice -> "Student Council Notice"
            MaintenanceNotice -> "Maintenance Notice"
            Affiliates -> "Affiliates"
            Startup -> "Start-ups"
            SportsAndHealth -> "Sports & Health Care"
            Employment -> "Employment"
            Covid19 -> "COVID-19"
            StudentClubs -> "Student Clubs"
            CurriculumChanges -> "Curriculum Changes"
            LeadershipAndInternship -> "Leadership/Internship/Counseling"
            Dormitory -> "Dormitory"
            CourseAndThesis -> "Course/Academic Record/Thesis"
            ScholarshipAndWelfare -> "Scholarship & Welfare"
            ResearchPersonnel -> "Technical Research Personnel"
            TeachingAndLearning -> "Teaching & Learning Board"
            Library -> "Library"
            Unknown -> ""
        }
}