package llc.pact.app.data

import androidx.compose.ui.graphics.Color
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import llc.pact.app.model.Audience
import llc.pact.app.model.Pact
import llc.pact.app.model.PactDirection
import llc.pact.app.model.PactState
import llc.pact.app.model.Person
import kotlin.time.Duration.Companion.days
import kotlin.time.Duration.Companion.hours

/**
 * Single source of truth for pacts + people in v1. In-memory only — state
 * resets on app kill. DataStore-backed persistence lands in v1.1 once the UI
 * is dialed in. Thread-safe via StateFlow.
 */
class PactRepository private constructor(
    seedPacts: List<Pact>,
    seedPeople: List<Person>,
) {
    private val _pacts = MutableStateFlow(seedPacts)
    val pacts: StateFlow<List<Pact>> = _pacts.asStateFlow()

    private val _people = MutableStateFlow(seedPeople)
    val people: StateFlow<List<Person>> = _people.asStateFlow()

    // -- Queries ---------------------------------------------------------------

    fun byAudience(audience: Audience): List<Pact> =
        if (audience == Audience.All) _pacts.value
        else _pacts.value.filter { it.counterpart.audience == audience }

    fun find(id: String): Pact? = _pacts.value.firstOrNull { it.id == id }

    // -- Mutations -------------------------------------------------------------

    fun add(pact: Pact) {
        _pacts.update { listOf(pact) + it }
    }

    fun update(pact: Pact) {
        _pacts.update { list -> list.map { if (it.id == pact.id) pact else it } }
    }

    fun delete(id: String) {
        _pacts.update { list -> list.filterNot { it.id == id } }
    }

    fun markComplete(id: String) {
        val now = Clock.System.now()
        _pacts.update { list ->
            list.map {
                if (it.id == id) it.copy(state = PactState.Completed, completedAt = now) else it
            }
        }
    }

    fun accept(id: String) {
        val now = Clock.System.now()
        _pacts.update { list ->
            list.map {
                if (it.id == id) it.copy(state = PactState.Active, acceptedAt = now) else it
            }
        }
    }

    fun decline(id: String) {
        _pacts.update { list ->
            list.map { if (it.id == id) it.copy(state = PactState.Declined) else it }
        }
    }

    private fun MutableStateFlow<List<Pact>>.update(block: (List<Pact>) -> List<Pact>) {
        value = block(value)
    }

    // -- Seed ------------------------------------------------------------------

    companion object {
        fun createSeeded(): PactRepository {
            val now = Clock.System.now()

            val emily = Person("p-emily", "Emily", Audience.Partner, Color(0xFFE8A5A1))
            val alex = Person("p-alex", "Alex", Audience.Friends, Color(0xFF8EA9C8))
            val sarah = Person("p-sarah", "Sarah", Audience.Friends, Color(0xFFD6A8C8))
            val michael = Person("p-michael", "Michael", Audience.Colleagues, Color(0xFFBBA68C))
            val dad = Person("p-dad", "Dad", Audience.Family, Color(0xFFC8A87A))

            val pacts = listOf(
                Pact(
                    id = "pact-1",
                    title = "Pick up Emily's favorite soup",
                    description = "Could you pick up my favorite soup? Feeling a bit under the weather.",
                    counterpart = emily,
                    direction = PactDirection.IDoForYou,
                    state = PactState.Completed,
                    createdAt = now - 2.hours,
                    completedAt = now - 1.hours,
                ),
                Pact(
                    id = "pact-2",
                    title = "Help Alex move his couch",
                    description = "Saturday morning, 10am. I'll bring the gloves.",
                    counterpart = alex,
                    direction = PactDirection.IDoForYou,
                    state = PactState.Completed,
                    createdAt = now - 3.days,
                    completedAt = now - 2.days,
                    streakNote = "You and Alex have completed 3 Pacts in a row!",
                ),
                Pact(
                    id = "pact-3",
                    title = "Water Sarah's plants while she's away",
                    description = "Every other day — fiddle leaf fig is dramatic.",
                    counterpart = sarah,
                    direction = PactDirection.IDoForYou,
                    state = PactState.Active,
                    createdAt = now - 1.days,
                    dueAt = now + 2.days,
                ),
                Pact(
                    id = "pact-4",
                    title = "Send me the link to that report we discussed",
                    description = "The Q3 retention deck. Slack or email both work.",
                    counterpart = michael,
                    direction = PactDirection.YouDoForMe,
                    state = PactState.Active,
                    createdAt = now - 6.hours,
                    dueAt = now + 3.days,
                ),
                Pact(
                    id = "pact-5",
                    title = "Help Dad set up his new tablet on Sunday",
                    description = "Walk through email, WhatsApp, and the news app.",
                    counterpart = dad,
                    direction = PactDirection.IDoForYou,
                    state = PactState.Active,
                    createdAt = now - 12.hours,
                    dueAt = now + 5.days,
                ),
            )

            return PactRepository(
                seedPacts = pacts,
                seedPeople = listOf(emily, alex, sarah, michael, dad),
            )
        }
    }
}

// kotlinx-datetime's Instant already defines Instant + Duration / Instant - Duration
// operators, so no extension shims needed here.
