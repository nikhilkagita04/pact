package llc.pact.app.ui.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.FavoriteBorder
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import llc.pact.app.model.Pact
import llc.pact.app.ui.component.AvatarDot
import llc.pact.app.ui.theme.LocalPactExtras

/**
 * The "New Request from Emily" modal (screenshot #2). Rendered as a full-screen
 * dimmed backdrop with a centered card. Caller controls visibility; this is
 * stateless.
 *
 * Layout top-to-bottom:
 *   - Large avatar
 *   - "New Request from X" title
 *   - Quoted description
 *   - Small heart outline (pact.llc leaves it visible — a soft emotional cue)
 *   - Accept (primary teal pill)
 *   - Decline (outlined pill, lower weight)
 *   - "Need to adjust? · · ·" tertiary action
 */
@Composable
fun IncomingRequestSheet(
    pact: Pact,
    onAccept: () -> Unit,
    onDecline: () -> Unit,
    onAdjust: () -> Unit,
    onDismiss: () -> Unit,
) {
    val extras = LocalPactExtras.current

    // Dimmed backdrop — tap outside dismisses.
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.Black.copy(alpha = 0.55f))
            .clickable(onClick = onDismiss),
        contentAlignment = Alignment.Center,
    ) {
        // Card — absorbs clicks so taps on it don't dismiss.
        Column(
            modifier = Modifier
                .padding(horizontal = 28.dp)
                .fillMaxWidth()
                .background(extras.surfaceHigh, RoundedCornerShape(28.dp))
                .clickable(enabled = false, onClick = {})
                .padding(horizontal = 28.dp, vertical = 28.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            AvatarDot(person = pact.counterpart, size = 72.dp)
            Spacer(Modifier.height(18.dp))
            Text(
                text = "New Request from ${pact.counterpart.name}",
                style = MaterialTheme.typography.titleLarge,
                color = MaterialTheme.colorScheme.onSurface,
                textAlign = TextAlign.Center,
            )
            Spacer(Modifier.height(18.dp))
            Text(
                text = "\u201C${pact.description ?: pact.title}\u201D",
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurface,
                textAlign = TextAlign.Center,
                modifier = Modifier.fillMaxWidth().padding(horizontal = 4.dp),
            )
            Spacer(Modifier.height(20.dp))
            Icon(
                imageVector = Icons.Outlined.FavoriteBorder,
                contentDescription = null,
                tint = extras.heart,
                modifier = Modifier.size(24.dp),
            )
            Spacer(Modifier.height(24.dp))
            PrimaryPill(label = "Accept", onClick = onAccept)
            Spacer(Modifier.height(12.dp))
            OutlinedPill(label = "Decline", onClick = onDecline)
            Spacer(Modifier.height(18.dp))
            Row(
                modifier = Modifier.clickable(onClick = onAdjust),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Text(
                    text = "Need to adjust?",
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Spacer(Modifier.width(4.dp))
                Text(
                    text = "\u2022\u2022\u2022",
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
        }
    }
}

@Composable
private fun PrimaryPill(label: String, onClick: () -> Unit) {
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
private fun OutlinedPill(label: String, onClick: () -> Unit) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .border(
                width = 1.dp,
                color = LocalPactExtras.current.declineStroke,
                shape = CircleShape,
            )
            .clickable(onClick = onClick)
            .padding(vertical = 16.dp),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = label,
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.onSurface,
        )
    }
}

// Arrangement import kept lean; unused but harmless no-op reference removed.
@Suppress("unused")
private val _arrKeep = Arrangement.Top
