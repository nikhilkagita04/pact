package llc.pact.app.ui.component

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import kotlinx.datetime.LocalDate
import kotlinx.datetime.TimeZone
import kotlinx.datetime.toLocalDateTime
import llc.pact.app.model.Pact
import llc.pact.app.model.PactState
import llc.pact.app.ui.theme.LocalPactExtras

/**
 * Single pact row on the My Pacts list. Mirrors the rounded-card look from
 * pact.llc: leading check/circle, title, "with X · meta" sub-line, optional
 * streak callout in amber when present.
 */
@Composable
fun PactCard(
    pact: Pact,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val extras = LocalPactExtras.current
    val completed = pact.state == PactState.Completed

    Row(
        modifier = modifier
            .fillMaxWidth()
            .background(
                color = MaterialTheme.colorScheme.surface,
                shape = RoundedCornerShape(20.dp),
            )
            .clickable(onClick = onClick)
            .padding(horizontal = 16.dp, vertical = 14.dp),
        verticalAlignment = Alignment.Top,
    ) {
        CheckDot(checked = completed)
        Spacer(Modifier.width(14.dp))
        Column(
            modifier = Modifier.fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(6.dp),
        ) {
            Text(
                text = pact.title,
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.onSurface,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis,
            )
            Row(verticalAlignment = Alignment.CenterVertically) {
                AvatarDot(person = pact.counterpart, size = 20.dp)
                Spacer(Modifier.width(8.dp))
                Text(
                    text = buildMetaLine(pact),
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
            }
            if (pact.streakNote != null) {
                Spacer(Modifier.height(2.dp))
                Text(
                    text = "${pact.streakNote} \uD83D\uDD25",
                    style = MaterialTheme.typography.labelLarge,
                    color = extras.streak,
                )
            }
        }
    }
}

private fun buildMetaLine(pact: Pact): String {
    val name = "with ${pact.counterpart.name}"
    val status = formatStatus(pact)
    return "$name  \u00B7  $status"
}

private fun formatStatus(pact: Pact): String {
    val now = Clock.System.now()
    return when (pact.state) {
        PactState.Completed -> {
            val completedAt = pact.completedAt ?: return "Completed"
            val today = now.toLocalDateTime(TimeZone.currentSystemDefault()).date
            val completedDay = completedAt.toLocalDateTime(TimeZone.currentSystemDefault()).date
            if (completedDay == today) "Completed today" else "Completed"
        }
        PactState.Pending -> "Awaiting you"
        PactState.AdjustmentProposed -> "Adjustment proposed"
        PactState.Declined -> "Declined"
        PactState.Cancelled -> "Cancelled"
        PactState.Active -> pact.dueAt?.let { formatDueIn(now, it) } ?: "In flight"
    }
}

private fun formatDueIn(now: Instant, due: Instant): String {
    val delta = due - now
    val days = delta.inWholeDays
    return when {
        days <= 0L -> "Due today"
        days == 1L -> "Due tomorrow"
        days < 7L -> "Due in $days days"
        else -> "Due in ${days / 7L} weeks"
    }
}

// Silence "unused" on LocalDate for IDE; kept imported for readability of the date compare above.
@Suppress("unused")
private val _localDateKeep: LocalDate? = null
