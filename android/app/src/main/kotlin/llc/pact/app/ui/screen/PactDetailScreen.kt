package llc.pact.app.ui.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.ArrowBack
import androidx.compose.material.icons.rounded.DeleteOutline
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.unit.dp
import llc.pact.app.data.PactRepository
import llc.pact.app.model.PactState
import llc.pact.app.ui.component.AvatarDot

/**
 * Detail view for a single pact. Shown when a card on the list is tapped.
 * In v1, the only terminal actions are Complete or Delete; editing and
 * adjustment flows land in v1.1.
 */
@Composable
fun PactDetailScreen(
    repository: PactRepository,
    pactId: String,
    onBack: () -> Unit,
    onCompleted: (String) -> Unit,
) {
    val all by repository.pacts.collectAsState()
    val pact = all.firstOrNull { it.id == pactId }
    if (pact == null) {
        // Pact was deleted or missing — bounce back rather than render nothing.
        onBack()
        return
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .statusBarsPadding(),
    ) {
        DetailTopBar(
            onBack = onBack,
            onDelete = {
                repository.delete(pactId)
                onBack()
            },
        )

        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp),
        ) {
            Spacer(Modifier.height(8.dp))
            Row(verticalAlignment = Alignment.CenterVertically) {
                AvatarDot(person = pact.counterpart, size = 40.dp)
                Spacer(Modifier.width(12.dp))
                Column {
                    Text(
                        text = "with ${pact.counterpart.name}",
                        style = MaterialTheme.typography.labelLarge,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                    Text(
                        text = stateLabel(pact.state),
                        style = MaterialTheme.typography.labelMedium,
                        color = stateColor(pact.state),
                    )
                }
            }

            Spacer(Modifier.height(24.dp))
            Text(
                text = pact.title,
                style = MaterialTheme.typography.displaySmall.copy(
                    lineHeight = androidx.compose.ui.unit.TextUnit.Unspecified,
                ),
                color = MaterialTheme.colorScheme.onSurface,
            )

            if (!pact.description.isNullOrBlank()) {
                Spacer(Modifier.height(16.dp))
                Text(
                    text = pact.description,
                    style = MaterialTheme.typography.bodyLarge.copy(fontStyle = FontStyle.Italic),
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            Spacer(Modifier.height(28.dp))
            Timeline(pact.state)

            Spacer(Modifier.height(32.dp))
            if (pact.state != PactState.Completed && pact.state != PactState.Declined) {
                PrimaryAction(label = "Mark Complete") {
                    repository.markComplete(pactId)
                    onCompleted(pactId)
                }
                Spacer(Modifier.height(12.dp))
                SecondaryAction(label = "Need to adjust?", onClick = { /* v1.1 */ })
            } else {
                SecondaryAction(label = "Delete pact", onClick = {
                    repository.delete(pactId)
                    onBack()
                })
            }
            Spacer(Modifier.height(28.dp))
        }
    }
}

@Composable
private fun DetailTopBar(onBack: () -> Unit, onDelete: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        CircleButton(icon = Icons.Rounded.ArrowBack, description = "Back", onClick = onBack)
        Spacer(Modifier.weight(1f))
        CircleButton(
            icon = Icons.Rounded.DeleteOutline,
            description = "Delete",
            onClick = onDelete,
        )
    }
}

@Composable
private fun CircleButton(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    description: String,
    onClick: () -> Unit,
) {
    Box(
        modifier = Modifier
            .size(38.dp)
            .background(MaterialTheme.colorScheme.surface, CircleShape)
            .clickable(onClick = onClick),
        contentAlignment = Alignment.Center,
    ) {
        Icon(
            imageVector = icon,
            contentDescription = description,
            tint = MaterialTheme.colorScheme.onSurface,
            modifier = Modifier.size(18.dp),
        )
    }
}

@Composable
private fun Timeline(state: PactState) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .background(MaterialTheme.colorScheme.surface, RoundedCornerShape(20.dp))
            .padding(PaddingValues(horizontal = 18.dp, vertical = 14.dp)),
        verticalArrangement = Arrangement.spacedBy(10.dp),
    ) {
        TimelineRow("Requested", reached = true)
        TimelineRow(
            label = "Accepted",
            reached = state in listOf(PactState.Active, PactState.Completed, PactState.AdjustmentProposed),
        )
        TimelineRow(label = "Completed", reached = state == PactState.Completed)
    }
}

@Composable
private fun TimelineRow(label: String, reached: Boolean) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Box(
            modifier = Modifier
                .size(10.dp)
                .background(
                    color = if (reached) MaterialTheme.colorScheme.primary
                            else MaterialTheme.colorScheme.outline,
                    shape = CircleShape,
                ),
        )
        Spacer(Modifier.width(12.dp))
        Text(
            text = label,
            style = MaterialTheme.typography.labelLarge,
            color = if (reached) MaterialTheme.colorScheme.onSurface
                    else MaterialTheme.colorScheme.onSurfaceVariant,
        )
    }
}

@Composable
private fun PrimaryAction(label: String, onClick: () -> Unit) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .background(MaterialTheme.colorScheme.primary, CircleShape)
            .clickable(onClick = onClick)
            .padding(vertical = 16.dp),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = label,
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.onPrimary,
        )
    }
}

@Composable
private fun SecondaryAction(label: String, onClick: () -> Unit) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .border(
                width = 1.dp,
                color = MaterialTheme.colorScheme.outline,
                shape = CircleShape,
            )
            .clickable(onClick = onClick)
            .padding(vertical = 14.dp),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = label,
            style = MaterialTheme.typography.labelLarge,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
    }
}

private fun stateLabel(state: PactState): String = when (state) {
    PactState.Pending -> "Awaiting you"
    PactState.Active -> "In flight"
    PactState.AdjustmentProposed -> "Adjustment proposed"
    PactState.Declined -> "Declined"
    PactState.Completed -> "Completed"
    PactState.Cancelled -> "Cancelled"
}

@Composable
private fun stateColor(state: PactState) = when (state) {
    PactState.Completed -> MaterialTheme.colorScheme.primary
    PactState.Declined, PactState.Cancelled -> MaterialTheme.colorScheme.error
    else -> MaterialTheme.colorScheme.onSurfaceVariant
}
