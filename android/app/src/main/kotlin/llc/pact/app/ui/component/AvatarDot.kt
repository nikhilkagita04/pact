package llc.pact.app.ui.component

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import llc.pact.app.model.Person

/**
 * Rendered avatar for a Person. v1 uses a solid tinted circle with the first
 * initial — no photo loading, no network. Matches pact.llc's flat aesthetic
 * without the overhead of ImageLoader config, and keeps the demo deterministic.
 *
 * The tint comes from [Person.accent]; text color is derived to stay legible
 * (dark background personas → light initial, light pastels → dark initial).
 */
@Composable
fun AvatarDot(
    person: Person,
    modifier: Modifier = Modifier,
    size: Dp = 28.dp,
) {
    Box(
        modifier = modifier
            .size(size)
            .background(person.accent, CircleShape),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = person.initials,
            color = initialColorFor(person.accent),
            style = MaterialTheme.typography.labelMedium.copy(
                fontWeight = FontWeight.SemiBold,
                fontSize = (size.value * 0.42f).sp,
            ),
        )
    }
}

private fun initialColorFor(bg: Color): Color {
    // Simple luminance check — pastels in the screenshots are light enough that
    // a near-black initial reads cleaner than white.
    val luminance = 0.299 * bg.red + 0.587 * bg.green + 0.114 * bg.blue
    return if (luminance > 0.55f) Color(0xFF1A1F26) else Color.White
}
