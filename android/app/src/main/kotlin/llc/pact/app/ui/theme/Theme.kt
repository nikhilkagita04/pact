package llc.pact.app.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.compositionLocalOf
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color

// Dark-first theme — pact.llc is dark-dominant and we match it.
private val PactDarkScheme = darkColorScheme(
    primary = PactColors.Primary,
    onPrimary = PactColors.OnPrimary,
    background = PactColors.Background,
    onBackground = PactColors.OnSurface,
    surface = PactColors.Surface,
    onSurface = PactColors.OnSurface,
    surfaceVariant = PactColors.SurfaceHigh,
    onSurfaceVariant = PactColors.OnSurfaceVariant,
    outline = PactColors.Outline,
    outlineVariant = PactColors.Outline,
    error = PactColors.Heart,
    onError = Color.White,
)

/**
 * Extra color tokens not covered by Material3's colorScheme. Keep semantic —
 * components pull from this rather than hardcoding hex.
 */
data class PactExtras(
    val streak: Color = PactColors.Streak,
    val heart: Color = PactColors.Heart,
    val declineStroke: Color = PactColors.DeclineStroke,
    val surfaceHigh: Color = PactColors.SurfaceHigh,
)

val LocalPactExtras = staticCompositionLocalOf { PactExtras() }

@Composable
@Suppress("UNUSED_PARAMETER")
fun PactTheme(
    // v1 is dark-only regardless of system setting. Light theme lands in v2.
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit,
) {
    CompositionLocalProvider(LocalPactExtras provides PactExtras()) {
        MaterialTheme(
            colorScheme = PactDarkScheme,
            typography = PactTypography,
            content = content,
        )
    }
}
