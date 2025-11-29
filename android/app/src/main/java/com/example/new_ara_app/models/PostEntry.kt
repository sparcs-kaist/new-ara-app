package com.example.new_ara_app.models

import com.example.new_ara_app.R
import java.util.*

sealed class DisplayReason {
    data object Trending : DisplayReason()
    data class Keyword(val word: String) : DisplayReason()
    data class Board(val selectedBoard: com.example.new_ara_app.models.Board) : DisplayReason()


    companion object {
        fun icon(res: DisplayReason): Int = when (res) {
            Trending -> R.drawable.round_trending_up_24
            is Keyword -> R.drawable.outline_local_offer_24
            is Board -> R.drawable.outline_storage_24
        }
    }
}

val DisplayReason.localizedString: String
    get() = when (this) {
        is DisplayReason.Trending -> "Trending"
        is DisplayReason.Keyword -> "Keyword \"$word\" detected"
        is DisplayReason.Board -> "Notice in ${selectedBoard.localizedString}"
    }

data class Post(
    val id: Int,
    val title: String,
    val author: String,
    val reason: DisplayReason,
    val date: Date
) {
    companion object {
        val mock: Post
            get() = Post(
                id = 1,
                title = "Trending Post",
                author = "Admission Dept.",
                reason = DisplayReason.Trending,
                date = Date()
            )

        val mockList: List<Post>
            get() {
                val now = Calendar.getInstance()
                return listOf(
                    Post(1, "Post 1", "Admission Dept.", DisplayReason.Trending, now.apply { add(Calendar.MINUTE, 1) }.time),
                    Post(2, "Post 2", "Admission Dept.", DisplayReason.Board(Board.Affiliates), now.apply { add(Calendar.MINUTE, 2) }.time),
                    Post(3, "Post 3", "Admission Dept.", DisplayReason.Board(Board.Affiliates), now.apply { add(Calendar.MINUTE, 3) }.time),
                    Post(4, "Post 4", "Admission Dept.", DisplayReason.Keyword("Post"), now.apply { add(Calendar.MINUTE, 4) }.time),
                    Post(5, "Post 5", "Admission Dept.", DisplayReason.Keyword("Trending"), now.apply { add(Calendar.MINUTE, 5) }.time),
                )
            }
    }
}

data class PostEntry(
    val date: Date,
    val posts: List<Post>,
    val showTrending: Boolean = true,
    val keywords: Set<String> = emptySet(),
    val boards: Set<Board> = emptySet()
) {
    companion object {
        val mock: PostEntry
            get() = PostEntry(
                date = Date(),
                posts = Post.mockList,
                showTrending = true,
                keywords = setOf("Trending", "Post"),
                boards = setOf(Board.Affiliates)
            )
    }
}

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
}

val Board.localizedString: String
    get() = when (this) {
        Board.GeneralNotice -> "General Notice"
        Board.IntlComm -> "International Community"
        Board.IntlCoop -> "International Opportunities/Collaboration"
        Board.ITService -> "IT Services"
        Board.FamilyEvents -> "Family Events"
        Board.FacultyClub -> "Faculty Clubs"
        Board.WorkStudyScholarship -> "Work-Study Scholarship"
        Board.NewsLetter -> "Newsletter"
        Board.SeminarAndEvent -> "Seminars & Events"
        Board.WorkManual -> "Work Manual"
        Board.StudentCouncilNotice -> "Student Council Notice"
        Board.MaintenanceNotice -> "Maintenance Notice"
        Board.Affiliates -> "Affiliates"
        Board.Startup -> "Start-ups"
        Board.SportsAndHealth -> "Sports & Health Care"
        Board.Employment -> "Employment"
        Board.Covid19 -> "COVID-19"
        Board.StudentClubs -> "Student Clubs"
        Board.CurriculumChanges -> "Curriculum Changes"
        Board.LeadershipAndInternship -> "Leadership/Internship/Counseling"
        Board.Dormitory -> "Dormitory"
        Board.CourseAndThesis -> "Course/Academic Record/Thesis"
        Board.ScholarshipAndWelfare -> "Scholarship & Welfare"
        Board.ResearchPersonnel -> "Technical Research Personnel"
        Board.TeachingAndLearning -> "Teaching & Learning Board"
        Board.Library -> "Library"
        Board.Unknown -> ""
    }

data class WidgetConfiguration(
    val showTrending: Boolean = true,
    val keywords: List<String> = emptyList(),
    val selectedBoards: List<Board> = emptyList()
)
