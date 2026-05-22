package llc.pact.app.ui.component

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Check
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp

/**
 * The leading indicator on every pact card.
 * - Completed → teal filled circle with a white check
 * - Incomplete → hollow outlined circle
 *
 * Matches the "My Pacts" list indicator in the pact.llc screenshots.
 */
@Composable
fun CheckDot(
    checked: Boolean,
    modifier: Modifier = Modifier,
) {
    Box(
        modifier = modifier
            .size(26.dp)
            .let {
                if (checked) {
                    it.background(MaterialTheme.colorScheme.primary, CircleShape)
                } else {
                    it.border(
                        width = 1.5.dp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.55f),
                        shape = CircleShape,
                    )
                }
            },
        contentAlignment = Alignment.Center,
    ) {
        if (checked) {
            Icon(
                imageVector = Icons.Rounded.Check,
                contentDescription = "Completed",
                tint = Color(0xFF0A1F1E),
                modifier = Modifier.size(16.dp),
            )
        }
    }
}
