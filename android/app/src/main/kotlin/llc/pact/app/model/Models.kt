package llc.pact.app.model

import androidx.compose.ui.graphics.Color
import kotlinx.datetime.Instant

// -- Audience / relationship ---------------------------------------------------

enum class Audience(val label: String) {
    All("All"),
    Partner("Partner"),
    Friends("Friends"),
    Family("Family"),
    Colleagues("Colleagues"),
}

// -- People --------------------------------------------------------------------

/**
 * Represents another person we make pacts with. In Path A (solo/simulated) the
 * avatar is a solid tinted circle with initials — no network fetches for photos.
 */
data class Person(
    val id: String,
    val name: String,
    val audience: Audience,          // every person belongs to exactly one tab
    val accent: Color,               // avatar tint
    val initials: String = name.firstOrNull()?.uppercaseChar()?.toString() ?: "?",
)

// -- Pact state machine --------------------------------------------------------

enum class PactState {
    Pending,               // requested by partner, awaiting my accept
    Active,                // accepted, in flight
    AdjustmentProposed,    // one side asked to tweak
    Declined,
    Completed,
    Cancelled,
}

enum class PactDirection {
    IDoForYou,       // I'm the doer
    YouDoForMe,      // the other person is the doer — I'm the requester
    Together,        // joint
}

data class Pact(
    val id: String,
    val title: String,
    val description: String?,
    val counterpart: Person,         // the "with X" name on the card
    val direction: PactDirection,
    val state: PactState,
    val createdAt: Instant,
    val dueAt: Instant? = null,
    val acceptedAt: Instant? = null,
    val completedAt: Instant? = null,
    val streakNote: String? = null,  // e.g. "You and Alex have completed 3 Pacts in a row!"
    val adjustmentNote: String? = null,
)
