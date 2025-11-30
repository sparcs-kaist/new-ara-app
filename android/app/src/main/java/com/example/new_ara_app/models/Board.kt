package com.example.new_ara_app.models

import android.content.Context
import com.example.new_ara_app.R


enum class Board(val id: Int) {
    GeneralNotice(1020),
    IntlComm(26),
    IntlCoop(48),
    ITService(1021),
    FamilyEvents(42),
    FacultyClub(44),
    WorkStudyScholarship(50),
    NewsLetter(58),
    SeminarAndEvent(23),
    WorkManual(32),
    StudentCouncilNotice(29),
    MaintenanceNotice(40),
    Affiliates(51),
    Startup(56),
    SportsAndHealth(30),
    Employment(33),
    Covid19(55),
    StudentClubs(36),
    CurriculumChanges(54),
    LeadershipAndInternship(47),
    Dormitory(45),
    CourseAndThesis(31),
    ScholarshipAndWelfare(28),
    ResearchPersonnel(34),
    TeachingAndLearning(1019),
    Library(1018),
    Unknown(-1);

    companion object {
        fun fromId(id: Int): Board = entries.find { it.id == id } ?: Unknown
    }

    fun localizedString(context: Context): String = when (this) {
        GeneralNotice -> context.getString(R.string.general_notice)

        IntlComm -> context.getString(R.string.international_community)

        IntlCoop -> context.getString(R.string.international_opportunities_collaboration)

        ITService -> context.getString(R.string.it_services)

        FamilyEvents -> context.getString(R.string.family_events)

        FacultyClub -> context.getString(R.string.faculty_clubs)

        WorkStudyScholarship -> context.getString(R.string.work_study_scholarship)

        NewsLetter -> context.getString(R.string.newsletter)

        SeminarAndEvent -> context.getString(R.string.seminar_and_event)

        WorkManual -> context.getString(R.string.work_manual)

        StudentCouncilNotice -> context.getString(R.string.student_council_notice)

        MaintenanceNotice -> context.getString(R.string.maintenance_notice)

        Affiliates -> context.getString(R.string.affiliates)

        Startup -> context.getString(R.string.startup)

        SportsAndHealth -> context.getString(R.string.sports_and_health)

        Employment -> context.getString(R.string.employment)

        Covid19 -> context.getString(R.string.covid19)

        StudentClubs -> context.getString(R.string.student_clubs)

        CurriculumChanges -> context.getString(R.string.curriculum_changes)

        LeadershipAndInternship -> context.getString(R.string.leadership_and_internship)

        Dormitory -> context.getString(R.string.dormitory)

        CourseAndThesis -> context.getString(R.string.course_and_thesis)

        ScholarshipAndWelfare -> context.getString(R.string.scholarship_and_welfare)

        ResearchPersonnel -> context.getString(R.string.research_personnel)

        TeachingAndLearning -> context.getString(R.string.teaching_and_learning)

        Library -> context.getString(R.string.library)

        Unknown -> context.getString(R.string.unknown)
    }
}
